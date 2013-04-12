USE GrReporting
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDActivityType]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[csp_IU_SCDActivityType]
GO

CREATE PROCEDURE [dbo].[csp_IU_SCDActivityType]
	@DataPriorToDate DATETIME

AS

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record that has been deleted in the source needs to be ended, use this date
DECLARE @MinimumStartDate DATETIME = '1753-01-01 00:00:00.000'
DECLARE @MaximumEndDate DATETIME = '9999-12-31 00:00:00.000'

/* IMPORTANT: There is no single business key that we can use to match dimension records with source records: we match using ActivityTypeId and
			  BusinessLineId. For this reason it's difficult to distinguish between new dimension records and dimension records that have been
			  updated. As such, the UpdatedDate of a record can't be used as the dimension record's StartDate or EndDate with any certainty.
			  For this reason, @NewEndDate is used to set a record's EndDate for a deactivation, as well as to set the StartDate of a new
			  dimension record. */

CREATE TABLE #ActivityType
(
	ActivityTypeId INT NOT NULL,
	ActivityTypeName VARCHAR(50) NOT NULL,
	ActivityTypeCode VARCHAR(50) NOT NULL,
	BusinessLineId INT NOT NULL,
	BusinessLineName VARCHAR(50) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL,
	SnapshotId INT NOT NULL,
	ReasonForChange  VARCHAR(1024) NOT NULL
)
INSERT INTO #ActivityType
(
	ActivityTypeId,
	ActivityTypeName,
	ActivityTypeCode,
	BusinessLineId,
	BusinessLineName,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	ActivityTypeId,
	ActivityTypeName,
	ActivityTypeCode,
	BusinessLineId,
	BusinessLineName,
	UpdatedDate AS StartDate,
	@MaximumEndDate AS EndDate,
	0 AS SnapshotId,
	ReasonForChange
FROM
(
	MERGE INTO
		dbo.ActivityType DIM
	USING
	(
		SELECT
			ActivityTypeId,
			ActivityTypeName,
			ActivityTypeCode,
			BusinessLineId,
			BusinessLineName,
			InsertedDate,
			UpdatedDate,
			IsActive,
			0 AS SnapshotId
		FROM
			GrReportingStaging.GR.GetActivityTypeBusinessLineExpanded(@DataPriorToDate)

	) AS SRC ON
		SRC.ActivityTypeId = DIM.ActivityTypeId AND
		SRC.BusinessLineId = DIM.BusinessLineID AND
		DIM.EndDate = @MaximumEndDate AND -- Only consider active dimension records (those records that have not been 'ended')
		SRC.SnapshotId = DIM.SnapshotId AND
		DIM.SnapshotId = 0 -- hardcode 0 as this stored procedure handles only LIVE GDM data, not snapshotted data

	/* ===========================================================================================================================================
		When a record exists in [Target] and [Source] and is active in [TARGET] but has been updated/deactivated in [SOURCE], end the record in
			the dimension.	
	   ======================================================================================================================================== */

	WHEN
		MATCHED AND
		(	-- If a field has been updated or the record has been deactivated in the source	
			DIM.ActivityTypeId <> SRC.ActivityTypeId OR
			DIM.BusinessLineId <> SRC.BusinessLineId OR
			DIM.ActivityTypeName <> SRC.ActivityTypeName OR
			DIM.ActivityTypeCode <> SRC.ActivityTypeCode OR
			DIM.BusinessLineName <> SRC.BusinessLineName OR
			SRC.IsActive = 0
		)
	THEN
		UPDATE
		SET
			DIM.EndDate = SRC.UpdatedDate,
			DIM.ReasonForChange =   CASE
										WHEN
											SRC.IsActive = 0
										THEN
											'Record deactivated in source'
										ELSE
											'Record updated in source'
									END

	/* ===========================================================================================================================================
		When a record exists in [Target] that doesn't exist in [Source], 'end' it by updating its EndDate
	   ======================================================================================================================================== */

	WHEN
		NOT MATCHED BY SOURCE AND -- When a record exists in [Target] that doesn't exist in [Source], 'end' it
		DIM.SnapshotId = 0 AND
		DIM.ActivityTypeKey <> -1 AND -- Do not update the 'UNKNOWN' record; this will not be matched in SOURCE
		DIM.EndDate = @MaximumEndDate -- Make sure that the dimension record is active, else we might continuously update the same inactive record
	THEN
		UPDATE
		SET
			DIM.EndDate = @NewEndDate,
			ReasonForChange = 'Record deleted in source'

	/* ===========================================================================================================================================
		When a record exists in [Source] that doesn't exist in [Target], insert it
	   ======================================================================================================================================== */

	WHEN
		NOT MATCHED BY TARGET AND
		SRC.IsActive = 1
	THEN
		INSERT
		(
			ActivityTypeId,
			ActivityTypeName,
			ActivityTypeCode,
			BusinessLineId,
			BusinessLineName,
			EndDate,
			SnapshotId,
			ReasonForChange,
			StartDate
		)
		VALUES
		(
			SRC.ActivityTypeId,
			SRC.ActivityTypeName,
			SRC.ActivityTypeCode,
			SRC.BusinessLineId,
			SRC.BusinessLineName,
			@MaximumEndDate,
			SRC.SnapshotId,
			CASE
				WHEN -- If this record (identified by its primary key) doesn't exist in the dimension (regardless of its StartDate and EndDate)
					0 = (	SELECT
								COUNT(*)
							FROM
								GrReporting.dbo.ActivityType
							WHERE
								SnapshotId = 0 AND
								ActivityTypeId = SRC.ActivityTypeId AND
								BusinessLineId = SRC.BusinessLineId
						)
				THEN -- Then it must be a new record
					'New record in source'
				ELSE -- Else the source record must have been reactivated and/or updated
					'Record reactivated in source'
			END,
			ISNULL(DATEADD(ms, 10, (SELECT
										MAX(EndDate)
									FROM
										GrReporting.dbo.ActivityType
									WHERE
										SnapshotId = 0 AND	-- This stored procedure handles only the unsnapshotted segment of the dimension
										ActivityTypeId = SRC.ActivityTypeId AND
										BusinessLineId = SRC.BusinessLineId)), @MinimumStartDate)
			/*
				The ISNULL(...) statement above was created to handle scenarios where a deactivated dimension record is reactivated in the
					source system. TSP does not want a gap in time to exist in the dimension between the dimension record that was created
					when the source record was deactivated and the dimension record that was created when it was reactivated.
					
					To illustrate, the example below shows a record that was deactivated and then reactivated. The EndDate of the first
						record is the date that the record was deactivated, and the StartDate of the second record is the date that it was
						reactivated. This leaves a gap between 2010-04-03 and 2011-02-03 where the record was not active. Because it is often
						the case that expenses will still be allocated to this activity type while it was inactive, these transactions in the
						warehouse will have UNKNOWN activity types because there wasn't a corresponding active record in the dimension at the
						time that the transaction was entered.
					
						ActivityTypeKey ActivityTypeId	BusinessLineId		...		StartDate	EndDate
						1				99				6					...		1753-01-01	2010-04-03
						2				99				6					...		2011-02-03	9999-12-31

					To resolve this, the StartDate of the new record must be set to 10 milliseconds after the date that the record was
						originally deactivated (the first record's EndDate).
			
				To achieve this:
			
					First, try and find the maximum EndDate in the dimension for the source record that is to be inserted.

						IF/[ISNULL]
							A version of this record already exists is the dimension (it cannot be active because we are in the NOT MATCHED BY
								TARGET clause)

						THEN/[DATEADD(ms, 10, (SELECT MAX(EndDate) FROM GrReporting.dbo.ActivityType WHERE ....))]
							Find the maximum EndDate (i.e.: The EndDate of the record that was last active), and add 10 milliseconds to it.
							This will be the StartDate of the new record that is to be inserted into the dimension

						ELSE/['1753-01-01']
							This source record has never existed in the dimension - we know this because the first statement within the ISNULL
								returned as a NULL value.
							As such, this is the first time that this record from the source is being inserted into the warehouse, so set its
								StartDate to '1753-01-01'																					*/
		)

	--------

	OUTPUT
		SRC.ActivityTypeId,
		SRC.ActivityTypeName,
		SRC.ActivityTypeCode,
		SRC.BusinessLineId,
		SRC.BusinessLineName,
		SRC.SnapshotId,
		SRC.IsActive,
		DATEADD(ms, 10, SRC.UpdatedDate) AS UpdatedDate,
		'Record updated in source' AS ReasonForChange,
		$Action AS MergeAction

) AS MergedData
WHERE
	MergedData.MergeAction = 'UPDATE' AND -- Important: Only insert a new record into the dimension if the merge triggered an update
	MergedData.IsActive = 1				  /* An update can either be triggered by the field of a source record being updated, or a source record
												being deactivated. Make sure that we only insert records associated with updates caused by the
												former, where a new dimension record to reflect these changes is required. */

/* ===============================================================================================================================================
	There is a bug in SQL Server 2008 that prevents the use of the MERGE statement when the table that is being merged to is referenced by
		other tables using FKs. [http://connect.microsoft.com/SQLServer/feedback/details/435031/]
	A work-around is to insert the result of the merge into a temp table, and to then insert data from this temp table into the dimension/[TARGET].
   ============================================================================================================================================ */

INSERT INTO dbo.ActivityType
(
	ActivityTypeId,
	ActivityTypeName,
	ActivityTypeCode,
	BusinessLineId,
	BusinessLineName,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	ACT.ActivityTypeId,
	ACT.ActivityTypeName,
	ACT.ActivityTypeCode,
	ACT.BusinessLineId,
	ACT.BusinessLineName,
	DATEADD(MS, 10, (SELECT MAX(EndDate) FROM GrReporting.dbo.ActivityType DIM WHERE DIM.ActivityTypeId = ACT.ActivityTypeId AND DIM.SnapshotId = ACT.SnapshotId)) AS StartDate,
	ACT.EndDate,
	ACT.SnapshotId,
	ACT.ReasonForChange
FROM
	#ActivityType ACT

GO

