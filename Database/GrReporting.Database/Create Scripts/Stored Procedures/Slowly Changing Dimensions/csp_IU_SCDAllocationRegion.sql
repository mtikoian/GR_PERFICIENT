USE GrReporting
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDAllocationRegion]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[csp_IU_SCDAllocationRegion]
GO

CREATE PROCEDURE [dbo].[csp_IU_SCDAllocationRegion]
	@DataPriorToDate DATETIME

AS

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record that has been deleted in the source needs to be ended, use this date
DECLARE @MinimumStartDate DATETIME = '1753-01-01 00:00:00.000'
DECLARE @MaximumEndDate DATETIME = '9999-12-31 00:00:00.000'

CREATE TABLE #AllocationRegion
(
	GlobalRegionId INT NOT NULL,
	RegionCode VARCHAR(50) NOT NULL,
	RegionName VARCHAR(50) NOT NULL,
	SubRegionCode VARCHAR(10) NOT NULL,
	SubRegionName VARCHAR(50) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL,
	SnapshotId INT NOT NULL,
	ReasonForChange NVARCHAR(1024) NULL
)

INSERT INTO #AllocationRegion
(
	GlobalRegionId,
	RegionCode,
	RegionName,
	SubRegionCode,
	SubRegionName,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	GlobalRegionId,
	RegionCode,
	RegionName,
	SubRegionCode,
	SubRegionName,
	UpdatedDate AS StartDate,
	@MaximumEndDate AS EndDate,
	SnapshotId,
	ReasonForChange
FROM
(
	MERGE INTO
		dbo.AllocationRegion DIM
	USING
	(
		SELECT
			GlobalRegionId,
			RegionCode,
			RegionName,
			ISNULL(SubRegionCode, 'N/A') AS SubRegionCode,
			ISNULL(SubRegionName, 'Not Applicable') AS SubRegionName,
			InsertedDate,
			UpdatedDate,
			IsActive,
			0 AS SnapshotId
		FROM
			GrReportingStaging.Gr.GetGlobalRegionExpanded(@DataPriorToDate)
		WHERE
			IsAllocationRegion = 1

	) AS SRC ON
		SRC.GlobalRegionId = DIM.GlobalRegionId AND
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
			DIM.RegionCode <> SRC.RegionCode OR
			DIM.RegionName <> SRC.RegionName OR
			DIM.SubRegionCode <> SRC.SubRegionCode OR
			DIM.SubRegionName <> SRC.SubRegionName OR
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
		DIM.AllocationRegionKey <> -1 AND -- Do not update the 'UNKNOWN' record; this will not be matched in SOURCE
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
			GlobalRegionId,
			RegionCode,
			RegionName,
			SubRegionCode,
			SubRegionName,
			EndDate,
			SnapshotId,
			ReasonForChange,
			StartDate
		)
		VALUES
		(
			SRC.GlobalRegionId,
			SRC.RegionCode,
			SRC.RegionName,
			SRC.SubRegionCode,
			SRC.SubRegionName,
			@MaximumEndDate,
			SRC.SnapshotId,
			CASE
				WHEN -- If this record (identified by its primary key) doesn't exist in the dimension (regardless of its StartDate and EndDate)
					0 = (	SELECT
								COUNT(*)
							FROM
								GrReporting.dbo.AllocationRegion
							WHERE
								SnapshotId = 0 AND
								GlobalRegionId = SRC.GlobalRegionId)
				THEN -- Then it must be a new record
					'New record in source'
				ELSE -- Else the source record must have been reactivated and/or updated
					'Record reactivated in source'
			END,
			ISNULL(DATEADD(ms, 10, (SELECT
										MAX(EndDate)
									FROM
										GrReporting.dbo.AllocationRegion
									WHERE
										SnapshotId = 0 AND
										GlobalRegionId = SRC.GlobalRegionId)), @MinimumStartDate)
		)




	--------

	OUTPUT
		SRC.GlobalRegionId,
		SRC.RegionCode,
		SRC.RegionName,
		SRC.SubRegionCode,
		SRC.SubRegionName,
		SRC.IsActive,
		SRC.SnapshotId,
		'Record updated in source' AS ReasonForChange,
		DATEADD(ms, 10, SRC.UpdatedDate) AS UpdatedDate,
		$Action AS MergeAction

) AS MergedData
WHERE
	MergedData.MergeAction = 'UPDATE' AND -- Important: Only insert a new record into the dimension if the merge triggered an update.
	MergedData.IsActive = 1				 /*  An update can either be triggered by the field of a source record being updated, or a source record
												being deactivated. Make sure that we only insert records associated with updates caused by the
												former, where a new dimension record to reflect these changes is required. */

/* ===============================================================================================================================================
	There is a bug in SQL Server 2008 that prevents the use of the MERGE statement when the table that is being merged to is referenced by
		other tables using FKs. [http://connect.microsoft.com/SQLServer/feedback/details/435031/]
	A work-around is to insert the result of the merge into a temp table, and to then insert data from this temp table into the dimension.
   ============================================================================================================================================ */

INSERT INTO dbo.AllocationRegion
(
	GlobalRegionId,
	RegionCode,
	RegionName,
	SubRegionCode,
	SubRegionName,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	AllocationRegion.GlobalRegionId,
	AllocationRegion.RegionCode,
	AllocationRegion.RegionName,
	AllocationRegion.SubRegionCode,
	AllocationRegion.SubRegionName,
	DATEADD(MS, 10, (SELECT MAX(EndDate) FROM GrReporting.dbo.AllocationRegion DIM WHERE DIM.GlobalRegionId = AllocationRegion.GlobalRegionId AND DIM.SnapshotId = AllocationRegion.SnapshotId)) AS StartDate,
	AllocationRegion.EndDate,
	AllocationRegion.SnapshotId,
	AllocationRegion.ReasonForChange
FROM
	#AllocationRegion AllocationRegion

GO
