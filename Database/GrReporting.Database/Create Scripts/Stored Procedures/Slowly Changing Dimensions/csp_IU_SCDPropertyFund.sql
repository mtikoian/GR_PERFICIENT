USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDPropertyFund]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[csp_IU_SCDPropertyFund]
GO

USE [GrReporting]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_IU_SCDPropertyFund]
	@DataPriorToDate DATETIME

AS

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record that has been deleted in the source needs to be ended, use this date
DECLARE @MinimumStartDate DATETIME = '1753-01-01 00:00:00.000'
DECLARE @MaximumEndDate DATETIME = '9999-12-31 00:00:00.000'

CREATE TABLE #PropertyFund
(
	PropertyFundId INT NOT NULL,
	PropertyFundName NVARCHAR(100) NOT NULL,
	PropertyFundType VARCHAR(50) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL,
	SnapshotId INT NOT NULL,
	ReasonForChange NVARCHAR(1024) NULL
)
INSERT INTO #PropertyFund
(
	PropertyFundId,
	PropertyFundName,
	PropertyFundType,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	PropertyFundId,
	PropertyFundName,
	PropertyFundType,
	UpdatedDate,
	@MaximumEndDate,
	0 AS SnapshotId,
	ReasonForChange
FROM
(
	MERGE INTO
		dbo.PropertyFund DIM
	USING
	(
		SELECT
			S.PropertyFundId,
			S.Name AS PropertyFundName,
			ET.Name AS PropertyFundType,
			S.IsActive,
			S.InsertedDate,
			S.UpdatedDate,
			0 AS SnapshotId
		FROM
			GrReportingStaging.GDM.PropertyFund S

			INNER JOIN GrReportingStaging.GDM.PropertyFundActive(@DataPriorToDate) SA ON
				S.ImportKey = SA.ImportKey

			INNER JOIN GrReportingStaging.GDM.EntityType ET ON
				S.EntityTypeId = ET.EntityTypeId
		WHERE
			S.IsReportingEntity = 1

	) AS SRC ON
		SRC.PropertyFundId = DIM.PropertyFundId AND
		DIM.EndDate = @MaximumEndDate AND -- Only consider active dimension records (those records that have not been 'ended')
		SRC.SnapshotId = DIM.SnapshotId AND
		DIM.SnapshotId = 0  -- hardcode 0 as this stored procedure handles only LIVE GDM data, not snapshotted data

	/* ===========================================================================================================================================
		When a record exists in [Target] and [Source] and is active in [TARGET] but has been updated/deactivated in [SOURCE], end the record in
			the dimension.	
	   ======================================================================================================================================== */

	WHEN
		MATCHED AND
		(	-- If a field has been updated or the record has been deactivated in the source		
			DIM.PropertyFundName <> SRC.PropertyFundName OR
			DIM.PropertyFundType <> SRC.PropertyFundType OR
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
		NOT MATCHED BY SOURCE AND
		DIM.SnapshotId = 0 AND
		DIM.PropertyFundKey <> -1 AND -- Do not update the 'UNKNOWN' record; this will not be matched in SOURCE
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
			PropertyFundId,
			PropertyFundName,
			PropertyFundType,
			EndDate,
			SnapshotId,
			ReasonForChange,
			StartDate
		)
		VALUES
		(
			SRC.PropertyFundId,
			SRC.PropertyFundName,
			SRC.PropertyFundType,
			@MaximumEndDate,
			SRC.SnapshotId,
			CASE
				WHEN -- If this record (identified by its primary key) doesn't exist in the dimension (regardless of its StartDate and EndDate)
					0 = (	SELECT
								COUNT(*)
							FROM
								GrReporting.dbo.PropertyFund
							WHERE
								SnapshotId = 0 AND
								PropertyFundId = SRC.PropertyFundId
						)
				THEN -- Then it must be a new record
					'New record in source'
				ELSE -- Else the source record must have been reactivated and/or updated
					'Record reactivated in source'
			END,
			ISNULL(DATEADD(ms, 10, (SELECT
										MAX(EndDate)
									FROM
										GrReporting.dbo.PropertyFund
									WHERE
										SnapshotId = 0 AND
										PropertyFundId = SRC.PropertyFundId)), @MinimumStartDate)
			/*
				The ISNULL(...) statement above was created to handle scenarios where a deactivated dimension record is reactivated in the
					source system. TSP does not want a gap in time to exist in the dimension between the dimension record that was created
					when the source record was deactivated and the dimension record that was created when it was reactivated.
					
					To illustrate, the example below shows a record that was deactivated and then reactivated. The EndDate of the first
						record is the date that the record was deactivated, and the StartDate of the second record is the date that it was
						reactivated. This leaves a gap between 2010-04-03 and 2011-02-03 where the record was not active. Because it is often
						the case that expenses will still be allocated to this property while it was inactive, these transactions in the
						warehouse will have UNKNOWN property funds because there wasn't a corresponding active record in the dimension at the
						time that the transaction was entered.
					
						PropertyFundKey PropertyFundId	PropertyFundName	PropertyFundType	StartDate	EndDate
						1				2546			Stafford Place I	Property			1753-01-01	2010-04-03
						2				2546			Stafford Place I	Property			2011-02-03	9999-12-31

					To resolve this, the StartDate of the new record must be set to 10 milliseconds after the date that the record was
						originally deactivated (the first record's EndDate).
			
				To achieve this:
			
					First, try and find the maximum EndDate in the dimension for the source record that is to be inserted.

						IF/[ISNULL]
							A version of this record already exists is the dimension (it cannot be active because we are in the NOT MATCHED BY
								TARGET clause)

						THEN/[DATEADD(ms, 10, (SELECT MAX(EndDate) FROM GrReporting.dbo.PropertyFund WHERE PropertyFundIdId = SRC.PropertyFundIdId))]
							Find the maximum EndDate (i.e.: The EndDate of the record that was last active), and add 10 milliseconds to it.
							This will be the StartDate of the new record that is to be inserted into the dimension

						ELSE/['1753-01-01']
							This source record has never existed in the dimension - we know this because the first statement within the ISNULL
								returned as a NULL value.
							As such, this is the first time that this record from the source is being inserted into the warehouse, so set its
								StartDate to '1753-01-01'																					*/
		)

	-----------

	OUTPUT
		SRC.PropertyFundId,
		SRC.PropertyFundName,
		SRC.PropertyFundType,
		SRC.SnapshotId,
		SRC.IsActive,
		'Record updated in source' AS ReasonForChange,
		DATEADD(ms, 10, SRC.UpdatedDate) AS UpdatedDate,
		$Action AS MergeAction

) AS MergedData
WHERE
	MergedData.MergeAction = 'UPDATE' AND  -- Important: Only insert a new record into the dimension if the merge triggered an update.
	MergedData.IsActive = 1		/* An update can either be triggered by the field of a source record being updated, or a source record
									being deactivated. Make sure that we only insert records associated with updates caused by the former, where
									a new dimension record to reflect these changes is required. */

/* ===============================================================================================================================================
	There is a bug in SQL Server 2008 that prevents the use of the MERGE statement when the table that is being merged to is referenced by
		other tables using FKs. [http://connect.microsoft.com/SQLServer/feedback/details/435031/]
	A work-around is to insert the result of the merge into a temp table, and to then insert data from this temp table into the dimension/[TARGET].
   ============================================================================================================================================ */

INSERT INTO dbo.PropertyFund
(
	PropertyFundId,
	PropertyFundName,
	PropertyFundType,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	PropertyFund.PropertyFundId,
	PropertyFund.PropertyFundName,
	PropertyFund.PropertyFundType,
	DATEADD(MS, 10, (SELECT MAX(EndDate) FROM GrReporting.dbo.PropertyFund DIM WHERE PropertyFund.PropertyFundId = DIM.PropertyFundId AND DIM.SnapshotId = PropertyFund.SnapshotId)) AS StartDate,
	PropertyFund.EndDate,
	PropertyFund.SnapshotId,
	PropertyFund.ReasonForChange
FROM
	#PropertyFund PropertyFund

GO
