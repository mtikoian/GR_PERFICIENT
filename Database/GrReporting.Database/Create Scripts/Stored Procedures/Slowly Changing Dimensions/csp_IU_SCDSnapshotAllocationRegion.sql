USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDSnapshotAllocationRegion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDSnapshotAllocationRegion]
GO

USE [GrReporting]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.csp_IU_SCDSnapshotAllocationRegion

AS

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record needs to be ended, use this date
DECLARE @MaximumEndDate DATETIME = '9999-12-31 00:00:00.000'

MERGE INTO
	dbo.AllocationRegion DIM
USING
(
	SELECT
		GlobalRegionId,
		RegionCode,
		RegionName,
		CONVERT(DATETIME, '1753-01-01 00:00:00.000') AS InsertedDate,
		CONVERT(DATETIME, '9999-12-31 00:00:00.000') AS UpdatedDate,
		ISNULL(SubRegionCode,'N/A') SubRegionCode,
		ISNULL(SubRegionName,'Not Applicable') SubRegionName,
		SnapshotId		
	FROM
		GrReportingStaging.Gr.GetSnapshotGlobalRegionExpanded()
	WHERE
		IsAllocationRegion = 1 AND
		IsActive = 1

) AS SRC ON
	SRC.GlobalRegionId = DIM.GlobalRegionId AND
	SRC.SnapshotId = DIM.SnapshotId AND
	DIM.SnapshotId <> 0							-- Exclude unsnapshotted (SnapshotId = 0) dimension records

WHEN MATCHED AND								-- When a SRC record has been matched to a DIM record
	(											-- If any field is different in SRC and DIM
		DIM.RegionCode <> SRC.RegionCode OR
		DIM.RegionName <> SRC.RegionName OR
		DIM.SubRegionCode <> SRC.SubRegionCode OR
		DIM.SubRegionName <> SRC.SubRegionName OR
		DIM.EndDate <> @MaximumEndDate			-- If the record is inactive in the dimension but has been reactivated in the source
	)
THEN
	UPDATE
	SET
		DIM.RegionCode = SRC.RegionCode,
		DIM.RegionName = SRC.RegionName,
		DIM.SubRegionCode = SRC.SubRegionCode,
		DIM.SubRegionName = SRC.SubRegionName,
		DIM.EndDate = @MaximumEndDate,					-- Make sure that the dimension record's EndDate = '9999-12-31' as this dimension
														--		record has been matched to an active SRC record.
		DIM.ReasonForChange = 'Record updated in source'

WHEN NOT MATCHED BY TARGET THEN -- When a record exists in [Source/SRC] that doesn't exist in [Target/DIM], insert it
	INSERT
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
	VALUES
	(
		SRC.GlobalRegionId,
		SRC.RegionCode,
		SRC.RegionName,
		SRC.SubRegionCode,
		SRC.SubRegionName,
		'1753-01-01 00:00:00.000',
		@MaximumEndDate,
		SRC.SnapshotId,
		'New record in source'
	)

WHEN NOT MATCHED BY SOURCE AND  -- When a record exists in [Target/DIM] that doesn't exist in [Source/SRC], 'end' it
	DIM.AllocationRegionKey <> -1 AND	-- Exclude the 'UNKNOWN' dimension record
	DIM.EndDate = @MaximumEndDate AND	-- Make sure that the dimension record hasn't been ended already, else we'd continuously update EndDate
	DIM.SnapshotId <> 0					-- Do not consider unsnapshotted (SnapshotId = 0) dimension records
THEN
	UPDATE
	SET
		DIM.EndDate = @NewEndDate,
		ReasonForChange = 'Record no longer exists in source';

GO
