 USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[csp_IU_SCDSnapshotActivityType]    Script Date: 11/30/2011 08:53:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDSnapshotActivityType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDSnapshotActivityType]
GO

USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[csp_IU_SCDSnapshotActivityType]    Script Date: 11/30/2011 08:53:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_IU_SCDSnapshotActivityType]

AS

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record needs to be ended, use this date
DECLARE @MaximumEndDate DATETIME = '9999-12-31 00:00:00.000'

/* IMPORTANT: There is no single business key that we can use to match dimension records with source records: we match using ActivityTypeId and
			  BusinessLineId. For this reason it's difficult to distinguish between new dimension records and dimension records that have been
			  updated. As such, the UpdatedDate of a record can't be used as the dimension record's StartDate or EndDate with any certainty.
			  For this reason, @NewEndDate is used to set a record's EndDate for a deactivation, as well as to set the StartDate of a new
			  dimension record. */

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
		SnapshotId,
		IsActive
	FROM
		GrReportingStaging.GR.GetSnapshotActivityTypeBusinessLineExpanded()
	WHERE
		IsActive = 1

) AS SRC ON
	SRC.ActivityTypeId = DIM.ActivityTypeId AND
	SRC.BusinessLineId = DIM.BusinessLineID AND
	SRC.SnapshotId = DIM.SnapshotId AND
	DIM.SnapshotId <> 0							-- Exclude unsnapshotted (SnapshotId = 0) dimension records

WHEN MATCHED AND								-- When a SRC record has been matched to a DIM record
	(											-- If any field is different in SRC and DIM
		DIM.ActivityTypeId <> SRC.ActivityTypeId OR
		DIM.BusinessLineId <> SRC.BusinessLineId OR
		DIM.ActivityTypeName <> SRC.ActivityTypeName OR
		DIM.ActivityTypeCode <> SRC.ActivityTypeCode OR
		DIM.BusinessLineName <> SRC.BusinessLineName OR
		DIM.EndDate <> @MaximumEndDate			-- If the record is inactive in the dimension but has been reactivated in the source
	)
THEN
	UPDATE
	SET
		DIM.ActivityTypeId = SRC.ActivityTypeId,
		DIM.BusinessLineId = SRC.BusinessLineId,
		DIM.ActivityTypeName = SRC.ActivityTypeName,
		DIM.ActivityTypeCode = SRC.ActivityTypeCode,
		DIM.BusinessLineName = SRC.BusinessLineName,
		DIM.EndDate = @MaximumEndDate,					-- Make sure that the dimension record's EndDate = '9999-12-31' as this dimension
														--		record has been matched to an active SRC record.
		DIM.ReasonForChange = 'Record updated in source'

WHEN NOT MATCHED BY TARGET THEN -- When a record exists in [Source/SRC] that doesn't exist in [Target/DIM], insert it
	INSERT (
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
	VALUES (
		SRC.ActivityTypeId,
		SRC.ActivityTypeName,
		SRC.ActivityTypeCode,
		SRC.BusinessLineId,
		SRC.BusinessLineName,
		'1753-01-01 00:00:00.000',
		@MaximumEndDate,
		SRC.SnapshotId,
		'New record in source'
	)

WHEN NOT MATCHED BY SOURCE AND  -- When a record exists in [Target/DIM] that doesn't exist in [Source/SRC], 'end' it
	DIM.ActivityTypeKey <> -1 AND		-- Exclude the 'UNKNOWN' dimension record
	DIM.EndDate = @MaximumEndDate AND	-- Make sure that the dimension record hasn't been ended already
	DIM.SnapshotId <> 0					-- Do not consider unsnapshotted (SnapshotId = 0) dimension records
THEN
	UPDATE
	SET
		DIM.EndDate = @NewEndDate,
		ReasonForChange = 'Record no longer exists in source';


GO


