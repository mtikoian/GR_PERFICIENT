USE [GrReporting]
GO
/****** Object:  View [dbo].[ActivityTypeLatestState]    Script Date: 02/28/2012 13:44:20 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ActivityTypeLatestState]'))
DROP VIEW [dbo].[ActivityTypeLatestState]
GO
/****** Object:  View [dbo].[AllocationRegionLatestState]    Script Date: 02/28/2012 13:44:20 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[AllocationRegionLatestState]'))
DROP VIEW [dbo].[AllocationRegionLatestState]
GO
/****** Object:  View [dbo].[FunctionalDepartmentLatestState]    Script Date: 02/28/2012 13:44:20 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[FunctionalDepartmentLatestState]'))
DROP VIEW [dbo].[FunctionalDepartmentLatestState]
GO
/****** Object:  View [dbo].[GLCategorizationHierarchyLatestState]    Script Date: 02/28/2012 13:44:20 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[GLCategorizationHierarchyLatestState]'))
DROP VIEW [dbo].[GLCategorizationHierarchyLatestState]
GO
/****** Object:  View [dbo].[OriginatingRegionLatestState]    Script Date: 02/28/2012 13:44:20 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[OriginatingRegionLatestState]'))
DROP VIEW [dbo].[OriginatingRegionLatestState]
GO
/****** Object:  View [dbo].[PropertyFundLatestState]    Script Date: 02/28/2012 13:44:20 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[PropertyFundLatestState]'))
DROP VIEW [dbo].[PropertyFundLatestState]
GO
/****** Object:  View [dbo].[PropertyFundLatestState]    Script Date: 02/28/2012 13:44:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[PropertyFundLatestState]'))
EXEC dbo.sp_executesql @statement = N'













CREATE VIEW [dbo].[PropertyFundLatestState]
AS

/*********************************************************************************************************************
Description
	This view returns all records in the property fund dimension, 
	as well as the latest property fund state for that GDM item. 
	This allows us to handle property fund name and property fund type
	changes correctly.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

2012-01-18	Sarah-Marie Nothling	: Created View
**********************************************************************************************************************/

SELECT
	PropertyFund.PropertyFundKey AS ''PropertyFundKey'',
	PropertyFund.PropertyFundId AS ''PropertyFundId'',
	PropertyFund.SnapshotId AS ''PropertyFundSnapshotId'',
	MaxPropertyFundRecord.PropertyFundName AS ''LatestPropertyFundName'',
	MaxPropertyFundRecord.PropertyFundType AS ''LatestPropertyFundType''
FROM
	dbo.PropertyFund
	INNER JOIN (
		SELECT
			PropertyFundId,
			SnapshotId,
			MAX(EndDate) AS ''MaxPropertyFundEndDate''
		FROM 
			dbo.PropertyFund
		GROUP BY 
			PropertyFundId,
			SnapshotId
		) MaxPropertyFund ON
		PropertyFund.PropertyFundId = MaxPropertyFund.PropertyFundId AND
		PropertyFund.SnapshotId = MaxPropertyFund.SnapshotId
	INNER JOIN dbo.PropertyFund MaxPropertyFundRecord ON
		MaxPropertyFund.PropertyFundId = MaxPropertyFundRecord.PropertyFundId AND
		MaxPropertyFund.SnapshotId = MaxPropertyFundRecord.SnapshotId AND
		MaxPropertyFund.MaxPropertyFundEndDate = MaxPropertyFundRecord.EndDate







'
GO
/****** Object:  View [dbo].[OriginatingRegionLatestState]    Script Date: 02/28/2012 13:44:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[OriginatingRegionLatestState]'))
EXEC dbo.sp_executesql @statement = N'













CREATE VIEW [dbo].[OriginatingRegionLatestState]
AS

/*********************************************************************************************************************
Description
	This view returns all records in the OriginatingRegion dimension, 
	as well as the latest property fund state for that GDM item. 
	This allows us to handle property fund name and property fund type
	changes correctly.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

2012-01-18	Sarah-Marie Nothling	: Created View
**********************************************************************************************************************/

SELECT
	OriginatingRegion.OriginatingRegionKey AS ''OriginatingRegionKey'',
	OriginatingRegion.SnapshotId AS ''OriginatingRegionSnapshotId'',
	OriginatingRegion.GlobalRegionId AS ''OriginatingRegionGlobalRegionId'',
	MaxOriginatingRegionRecord.RegionCode AS ''LatestOriginatingRegionCode'',
	MaxOriginatingRegionRecord.RegionName AS ''LatestOriginatingRegionName'',
	MaxOriginatingRegionRecord.SubRegionCode AS ''LatestOriginatingSubRegionCode'',
	MaxOriginatingRegionRecord.SubRegionName AS ''LatestOriginatingSubRegionName''
FROM
	dbo.OriginatingRegion
	INNER JOIN (
		SELECT
			GlobalRegionId,
			SnapshotId,
			MAX(EndDate) AS ''MaxOriginatingRegionEndDate''
		FROM 
			dbo.OriginatingRegion
		GROUP BY 
			GlobalRegionId,
			SnapshotId
		) MaxOriginatingRegion ON
		OriginatingRegion.GlobalRegionId = MaxOriginatingRegion.GlobalRegionId AND
		OriginatingRegion.SnapshotId = MaxOriginatingRegion.SnapshotId
	INNER JOIN dbo.OriginatingRegion MaxOriginatingRegionRecord ON
		MaxOriginatingRegion.GlobalRegionId = MaxOriginatingRegionRecord.GlobalRegionId AND
		MaxOriginatingRegion.SnapshotId = MaxOriginatingRegionRecord.SnapshotId AND
		MaxOriginatingRegion.MaxOriginatingRegionEndDate = MaxOriginatingRegionRecord.EndDate







'
GO
/****** Object:  View [dbo].[GLCategorizationHierarchyLatestState]    Script Date: 02/28/2012 13:44:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[GLCategorizationHierarchyLatestState]'))
EXEC dbo.sp_executesql @statement = N'
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
	MaxGCHRecord.GLCategorizationTypeName AS ''LatestGLCategorizationTypeName'',
	MaxGCHRecord.GLCategorizationName AS ''LatestGLCategorizationName'',
	MaxGCHRecord.GLFinancialCategoryName AS ''LatestGLFinancialCategoryName'',
	MaxGCHRecord.GLMajorCategoryName AS ''LatestGLMajorCategoryName'',
	MaxGCHRecord.GLMinorCategoryName AS ''LatestGLMinorCategoryName'',
	MaxGCHRecord.GLAccountName AS ''LatestGLAccountName'',
	MaxGCHRecord.GLAccountCode AS ''LatestGLAccountCode'',
	MaxGCHRecord.InflowOutflow AS ''LatestInflowOutflow'',
	MaxGCHRecord.FeeOrExpenseMultiplicationFactor AS ''LatestFeeOrExpenseMultiplicationFactor''
FROM
	dbo.GLCategorizationHierarchy GCH
	
	INNER JOIN (
		SELECT
			GLCategorizationHierarchyCode,
			SnapshotId,
			MAX(EndDate) AS ''MaxGLCategorizationHierarchyEndDate''
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
		MaxGCH.MaxGLCategorizationHierarchyEndDate = MaxGCHRecord.EndDate'
GO
/****** Object:  View [dbo].[FunctionalDepartmentLatestState]    Script Date: 02/28/2012 13:44:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[FunctionalDepartmentLatestState]'))
EXEC dbo.sp_executesql @statement = N'













CREATE VIEW [dbo].[FunctionalDepartmentLatestState]
AS

/*********************************************************************************************************************
Description
	This view returns all records in the FunctionalDepartment dimension, 
	as well as the latest property fund state for that GDM item. 
	This allows us to handle property fund name and property fund type
	changes correctly.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

2012-01-18	Sarah-Marie Nothling	: Created View
**********************************************************************************************************************/

SELECT
	FunctionalDepartment.FunctionalDepartmentKey AS ''FunctionalDepartmentKey'',
	FunctionalDepartment.ReferenceCode AS ''FunctionalDepartmentReferenceCode'',
	MaxFunctionalDepartmentRecord.FunctionalDepartmentName AS ''LatestFunctionalDepartmentName'',
	MaxFunctionalDepartmentRecord.ReferenceCode AS ''LatestFunctionalDepartmentReferenceCode'',
	MaxFunctionalDepartmentRecord.FunctionalDepartmentCode AS ''LatestFunctionalDepartmentCode'',
	MaxFunctionalDepartmentRecord.SubFunctionalDepartmentCode AS ''LatestSubFunctionalDepartmentCode'',
	MaxFunctionalDepartmentRecord.SubFunctionalDepartmentName AS ''LatestSubFunctionalDepartmentName''
FROM
	dbo.FunctionalDepartment
	INNER JOIN (
		SELECT
			ReferenceCode,
			MAX(EndDate) AS ''MaxFunctionalDepartmentEndDate''
		FROM 
			dbo.FunctionalDepartment
		GROUP BY 
			ReferenceCode
		) MaxFunctionalDepartment ON
		FunctionalDepartment.ReferenceCode = MaxFunctionalDepartment.ReferenceCode
	INNER JOIN dbo.FunctionalDepartment MaxFunctionalDepartmentRecord ON
		MaxFunctionalDepartment.ReferenceCode = MaxFunctionalDepartmentRecord.ReferenceCode AND
		MaxFunctionalDepartment.MaxFunctionalDepartmentEndDate = MaxFunctionalDepartmentRecord.EndDate







'
GO
/****** Object:  View [dbo].[AllocationRegionLatestState]    Script Date: 02/28/2012 13:44:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[AllocationRegionLatestState]'))
EXEC dbo.sp_executesql @statement = N'












CREATE VIEW [dbo].[AllocationRegionLatestState]
AS

/*********************************************************************************************************************
Description
	This view returns all records in the AllocationRegion dimension, 
	as well as the latest property fund state for that GDM item. 
	This allows us to handle property fund name and property fund type
	changes correctly.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

2012-01-18	Sarah-Marie Nothling	: Created View
**********************************************************************************************************************/

SELECT
	AllocationRegion.AllocationRegionKey AS ''AllocationRegionKey'',
	AllocationRegion.SnapshotId AS ''AllocationRegionSnapshotId'',
	AllocationRegion.GlobalRegionId AS ''AllocationRegionGlobalRegionId'',
	MaxAllocationRegionRecord.RegionCode AS ''LatestAllocationRegionCode'',
	MaxAllocationRegionRecord.RegionName AS ''LatestAllocationRegionName'',
	MaxAllocationRegionRecord.SubRegionCode AS ''LatestAllocationSubRegionCode'',
	MaxAllocationRegionRecord.SubRegionName AS ''LatestAllocationSubRegionName''
FROM
	dbo.AllocationRegion
	INNER JOIN (
		SELECT
			GlobalRegionId,
			SnapshotId,
			MAX(EndDate) AS ''MaxAllocationRegionEndDate''
		FROM 
			dbo.AllocationRegion
		GROUP BY 
			GlobalRegionId,
			SnapshotId
		) MaxAllocationRegion ON
		AllocationRegion.GlobalRegionId = MaxAllocationRegion.GlobalRegionId AND
		AllocationRegion.SnapshotId = MaxAllocationRegion.SnapshotId
	INNER JOIN dbo.AllocationRegion MaxAllocationRegionRecord ON
		MaxAllocationRegion.GlobalRegionId = MaxAllocationRegionRecord.GlobalRegionId AND
		MaxAllocationRegion.SnapshotId = MaxAllocationRegionRecord.SnapshotId AND
		MaxAllocationRegion.MaxAllocationRegionEndDate = MaxAllocationRegionRecord.EndDate






'
GO
/****** Object:  View [dbo].[ActivityTypeLatestState]    Script Date: 02/28/2012 13:44:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ActivityTypeLatestState]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [dbo].[ActivityTypeLatestState]
AS

/*********************************************************************************************************************
Description
	This view returns all records in the activity type dimension, 
	as well as the latest activity type state for that GDM item. 
	This allows us to handle activity type name, code and business line
	changes correctly.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

2012-01-18	Sarah-Marie Nothling	: Created View
**********************************************************************************************************************/

SELECT
	ActivityType.ActivityTypeKey AS ''ActivityTypeKey'',
	ActivityType.ActivityTypeId AS ''ActivityTypeId'',
	ActivityType.SnapshotId AS ''ActivityTypeSnapshotId'',
	MaxActivityTypeRecord.ActivityTypeCode AS ''LatestActivityTypeCode'',
	MaxActivityTypeRecord.ActivityTypeName AS ''LatestActivityTypeName'',
	MaxActivityTypeRecord.BusinessLineName AS ''LatestBusinessLineName''
FROM
	dbo.ActivityType
	INNER JOIN (
		SELECT
			ActivityTypeId,
			SnapshotId,
			MAX(EndDate) AS ''MaxActivityTypeEndDate''
		FROM 
			dbo.ActivityType
		GROUP BY 
			ActivityTypeId,
			SnapshotId
		) MaxActivityType ON
		ActivityType.ActivityTypeId = MaxActivityType.ActivityTypeId AND
		ActivityType.SnapshotId = MaxActivityType.SnapshotId
	INNER JOIN dbo.ActivityType MaxActivityTypeRecord ON
		MaxActivityType.ActivityTypeId = MaxActivityTypeRecord.ActivityTypeId AND
		MaxActivityType.SnapshotId = MaxActivityTypeRecord.SnapshotId AND
		MaxActivityType.MaxActivityTypeEndDate = MaxActivityTypeRecord.EndDate






'
GO
