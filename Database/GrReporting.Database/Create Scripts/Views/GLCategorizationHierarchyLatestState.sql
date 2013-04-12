 USE GrReporting
 GO
 
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[GLCategorizationHierarchyLatestState]'))
DROP VIEW [dbo].[GLCategorizationHierarchyLatestState]
GO

CREATE VIEW [dbo].[GLCategorizationHierarchyLatestState]
AS

/*********************************************************************************************************************
Description
	This view returns all records in the GL Categorization Hierarchy dimension, 
	as well as the latest GL Categorization Hierarchy state for that GDM item. 
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2012-02-27		: PKayongo	: Created View
**********************************************************************************************************************/

SELECT
	GCH.GLCategorizationHierarchyKey,
	GCH.GLCategorizationHierarchyCode,
	GCH.SnapshotId,
	MaxGCHRecord.GLCategorizationTypeName AS 'LatestGLCategorizationTypeName',
	MaxGCHRecord.GLCategorizationName AS 'LatestGLCategorizationName',
	MaxGCHRecord.GLFinancialCategoryName AS 'LatestGLFinancialCategoryName',
	MaxGCHRecord.GLMajorCategoryName AS 'LatestGLMajorCategoryName',
	MaxGCHRecord.GLMinorCategoryName AS 'LatestGLMinorCategoryName',
	MaxGCHRecord.GLAccountName AS 'LatestGLAccountName',
	MaxGCHRecord.GLAccountCode AS 'LatestGLAccountCode',
	MaxGCHRecord.InflowOutflow AS 'LatestInflowOutflow',
	MaxGCHRecord.FeeOrExpenseMultiplicationFactor AS 'LatestFeeOrExpenseMultiplicationFactor'
FROM
	dbo.GLCategorizationHierarchy GCH
	
	INNER JOIN (
		SELECT
			GLCategorizationHierarchyCode,
			SnapshotId,
			MAX(EndDate) AS 'MaxGLCategorizationHierarchyEndDate'
		FROM
			dbo.GLCategorizationHierarchy
		GROUP BY
			GLCategorizationHierarchyCode,
			SnapshotId
	) MaxGCH ON
		GCH.GLCategorizationHierarchyCode = MaxGCH.GLCategorizationHierarchyCode AND
		GCH.SnapshotId = MaxGCH.SnapshotId
		
	INNER JOIN dbo.GLCategorizationHierarchy MaxGCHRecord ON
		MaxGCH.GLCategorizationHierarchyCode = MaxGCHRecord.GLCategorizationHierarchyCode AND
		MaxGCH.SnapshotId = MaxGCHRecord.SnapshotId AND
		MaxGCH.MaxGLCategorizationHierarchyEndDate = MaxGCHRecord.EndDate