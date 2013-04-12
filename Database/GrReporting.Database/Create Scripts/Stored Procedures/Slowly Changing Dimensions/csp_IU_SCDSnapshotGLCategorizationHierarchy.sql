  USE GrReporting
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDSnapshotGLCategorizationHierarchy]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[csp_IU_SCDSnapshotGLCategorizationHierarchy]
GO

CREATE PROCEDURE [dbo].[csp_IU_SCDSnapshotGLCategorizationHierarchy]

AS

DECLARE @NewEndDate DATETIME = GETDATE()
DECLARE @MinimumStartDate DATETIME = '1753-01-01 00:00:00.000'
DECLARE @MaximumEndDate DATETIME = '9999-12-31 00:00:00.000'

MERGE INTO
	dbo.GLCategorizationHierarchy DIM
USING
(
	SELECT
		GLCategorizationHierarchyCode,
		GLCategorizationTypeName,
		GLCategorizationName,
		GLFinancialCategoryName,
		GLMajorCategoryName,
		GLMinorCategoryName,
		GLGlobalAccountName,
		GLGlobalAccountCode,
		InflowOutflow,
		SnapshotId,
		IsActive,
		InsertedDate,
		UpdatedDate
	FROM 
		GrReportingStaging.Gr.GetSnapshotGLCategorizationHierarchyExpanded()
	WHERE
		IsActive = 1
) AS SRC ON
	SRC.GLCategorizationHierarchyCode = DIM.GLCategorizationHierarchyCode AND
	SRC.SnapshotId = DIM.SnapshotId AND
	DIM.SnapshotId <> 0
---
WHEN MATCHED AND
	(
		DIM.GLCategorizationTypeName <> SRC.GLCategorizationTypeName OR
		DIM.GLCategorizationName <> SRC.GLCategorizationName OR
		DIM.GLFinancialCategoryName <> SRC.GLFinancialCategoryName OR
		DIM.GLMajorCategoryName <> SRC.GLMajorCategoryName OR
		DIM.GLMinorCategoryName <> SRC.GLMinorCategoryName OR
		DIM.GLAccountName <> SRC.GLGlobalAccountName OR
		DIM.GLAccountCode <> SRC.GLGlobalAccountCode OR
		DIM.InflowOutflow <> SRC.InflowOutflow OR
		DIM.EndDate <> @MaximumEndDate
	) AND
	SRC.IsActive = 1
THEN
	UPDATE
	SET
		DIM.GLCategorizationTypeName = SRC.GLCategorizationTypeName,
		DIM.GLCategorizationName = SRC.GLCategorizationName,
		DIM.GLFinancialCategoryName = SRC.GLFinancialCategoryName,
		DIM.GLMajorCategoryName = SRC.GLMajorCategoryName,
		DIM.GLMinorCategoryName = SRC.GLMinorCategoryName,
		DIM.GLAccountName = SRC.GLGlobalAccountName,
		DIM.GLAccountCode = SRC.GLGlobalAccountCode,
		DIM.InflowOutflow = SRC.InflowOutflow,
		DIM.ReasonForChange = 'Record updated in source',
		DIM.EndDate = @MaximumEndDate
----------

WHEN NOT MATCHED BY TARGET AND
	SRC.IsActive = 1
THEN
	INSERT(
		GLCategorizationHierarchyCode,
		GLCategorizationTypeName,
		GLCategorizationName,
		GLFinancialCategoryName,
		GLMajorCategoryName,
		GLMinorCategoryName,
		GLAccountName,
		GLAccountCode,
		InflowOutflow,
		SnapshotId,
		StartDate,
		EndDate,
		ReasonForChange
	)
	VALUES(
		SRC.GLCategorizationHierarchyCode,
		SRC.GLCategorizationTypeName,
		SRC.GLCategorizationName,
		SRC.GLFinancialCategoryName,
		SRC.GLMajorCategoryName,
		SRC.GLMinorCategoryName,
		SRC.GLGlobalAccountName,
		SRC.GLGlobalAccountCode,
		SRC.InflowOutflow,
		SRC.SnapshotId,
		@MinimumStartDate,
		@MaximumEndDate,
		'New or reactivated record in source'
	)

----------
	
WHEN NOT MATCHED BY SOURCE AND
	DIM.EndDate = @MaximumEndDate AND
	DIM.SnapshotId <> 0 AND
	DIM.GLCategorizationHierarchyKey > 0 AND
	DIM.SnapshotId IN (SELECT SnapshotId FROM GrReportingStaging.Gdm.Snapshot)
THEN
	UPDATE
	SET
		DIM.EndDate = @NewEndDate,
		ReasonForChange = 'Record no longer exists in source';
			
	----------
GO