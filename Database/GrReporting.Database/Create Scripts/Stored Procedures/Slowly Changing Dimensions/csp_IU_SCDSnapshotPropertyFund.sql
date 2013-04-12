 USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[csp_IU_SCDSnapshotPropertyFund]    Script Date: 11/30/2011 09:18:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDSnapshotPropertyFund]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDSnapshotPropertyFund]
GO

USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[csp_IU_SCDSnapshotPropertyFund]    Script Date: 11/30/2011 09:18:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_IU_SCDSnapshotPropertyFund]

AS

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record needs to be ended, use this date
DECLARE @MaximumEndDate DATETIME = '9999-12-31 00:00:00.000'

MERGE INTO
	dbo.PropertyFund DIM
USING
(
	SELECT
		PF.PropertyFundId,
		PF.Name AS PropertyFundName,
		ET.Name AS PropertyFundType,
		CONVERT(DATETIME, '1753-01-01 00:00:00.000') AS InsertedDate,
		CONVERT(DATETIME, '9999-12-31 00:00:00.000') AS UpdatedDate,
		PF.SnapshotId		
	FROM
		GrReportingStaging.Gdm.SnapshotPropertyFund PF
		INNER JOIN GrReportingStaging.Gdm.SnapshotEntityType ET ON
			PF.EntityTypeId = ET.EntityTypeId AND
			PF.SnapshotId = ET.SnapshotId
	WHERE
		PF.IsActive = 1 AND
		ET.IsActive = 1 AND
		PF.IsReportingEntity = 1

) AS SRC ON
	SRC.PropertyFundId = DIM.PropertyFundId AND
	SRC.SnapshotId = DIM.SnapshotId AND
	DIM.SnapshotId <> 0							-- Exclude unsnapshotted (SnapshotId = 0) dimension records

WHEN MATCHED AND								-- When a SRC record has been matched to a DIM record
	(											-- If any field is different in SRC and DIM
		DIM.PropertyFundId <> SRC.PropertyFundId OR
		DIM.PropertyFundName <> SRC.PropertyFundName OR
		DIM.PropertyFundType <> SRC.PropertyFundType OR
		DIM.EndDate <> @MaximumEndDate			-- If the record is inactive in the dimension but has been reactivated in the source
	)
THEN
	UPDATE
	SET
		DIM.PropertyFundId = SRC.PropertyFundId,
		DIM.PropertyFundName = SRC.PropertyFundName,
		DIM.PropertyFundType = SRC.PropertyFundType,
		DIM.EndDate = @MaximumEndDate,					-- Make sure that the dimension record's EndDate = '9999-12-31' as this dimension
														--		record has been matched to an active SRC record.
		DIM.ReasonForChange = 'Record updated in source'

WHEN NOT MATCHED BY TARGET THEN -- When a record exists in [Source/SRC] that doesn't exist in [Target/DIM], insert it
	INSERT
	(
		PropertyFundId,
		PropertyFundName,
		PropertyFundType,
		StartDate,
		EndDate,
		SnapshotId,
		ReasonForChange
	)
	VALUES
	(
		SRC.PropertyFundId,
		SRC.PropertyFundName,
		SRC.PropertyFundType,
		'1753-01-01 00:00:00.000',
		@MaximumEndDate,
		SRC.SnapshotId,
		'New record in source'
	)

WHEN NOT MATCHED BY SOURCE AND  -- When a record exists in [Target/DIM] that doesn't exist in [Source/SRC], 'end' it
	DIM.PropertyFundKey <> -1 AND		-- Exclude the 'UNKNOWN' dimension record
	DIM.EndDate = @MaximumEndDate AND	-- Make sure that the dimension record hasn't been ended already
	DIM.SnapshotId <> 0					-- Do not consider unsnapshotted (SnapshotId = 0) dimension records
THEN
	UPDATE
	SET
		DIM.EndDate = @NewEndDate,
		ReasonForChange = 'Record no longer exists in source';


GO


