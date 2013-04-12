/* DO NOT DELETE THIS SECTION - DO NOT DELETE THIS SECTION - DO NOT DELETE THIS SECTION - DO NOT DELETE THIS SECTION - DO NOT DELETE THIS SECTION
   ===============================================================================================================================================
	The drops below drop stored procedures that are not going to be recreated.
	
	The following stored procedures have been modified
	- stp_R_ProfitabilityV2
	- stp_R_ProfitabilityDetailV2
   ============================================================================================================================================= */

USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDGlAccount]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[csp_IU_SCDGlAccount]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDSnapshotGlAccount]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[csp_IU_SCDSnapshotGlAccount]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDGlAccountCategory]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[csp_IU_SCDGlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDSnapshotGlAccountCategory]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[csp_IU_SCDSnapshotGlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzarTotalComparison]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[stp_R_ExpenseCzarTotalComparison]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzarDetail]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[stp_R_ExpenseCzarDetail]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzar]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[stp_R_ExpenseCzar]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_Profitability]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[stp_R_Profitability]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ProfitabilityDetailV3]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[stp_R_ProfitabilityDetailV3]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_UnknownActivityType]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[stp_R_UnknownActivityType]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_UnknownFunctionalDepartment]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[stp_R_UnknownFunctionalDepartment]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_UnknownGlAccount]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[stp_R_UnknownGlAccount]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_UnknownOriginatingRegion]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[stp_R_UnknownOriginatingRegion]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_S_UnknownSummaryMRIActuals]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[stp_S_UnknownSummaryMRIActuals]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_S_UnknownSummaryAllocatedOverhead]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[stp_S_UnknownSummaryAllocatedOverhead]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_S_ValidNonPayrollRegionAndFunctionalDepartment]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[stp_S_ValidNonPayrollRegionAndFunctionalDepartment]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_S_ValidPayrollRegionAndFunctionalDepartment]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[stp_S_ValidPayrollRegionAndFunctionalDepartment]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ValidFunctionalDepartmentOriginatingRegionCombinations]    Script Date: 01/27/2012 10:36:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ValidFunctionalDepartmentOriginatingRegionCombinations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ValidFunctionalDepartmentOriginatingRegionCombinations]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ValidFunctionalDepartmentGLGlobalAccountCombinations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ValidFunctionalDepartmentGLGlobalAccountCombinations]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ValidReportingEntityActivityTypeCombinations]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[stp_R_ValidReportingEntityActivityTypeCombinations]
GO

/* DO NOT DELETE THIS SECTION - DO NOT DELETE THIS SECTION - DO NOT DELETE THIS SECTION - DO NOT DELETE THIS SECTION - DO NOT DELETE THIS SECTION */












/* ===============================================================================================================================================
	The following stored procedures need to be dropped and created:

		stp_I_ProfitabilityReforecastIndex
		stp_I_ProfitabilityBudgetIndex
		stp_I_ProfitabilityActualIndex
		stp_D_ProfitabilityActualIndex
		stp_D_ProfitabilityReforecastIndex
		stp_D_ProfitabilityBudgetIndex

		csp_IU_SCDSnapshotPropertyFund
		csp_IU_SCDSnapshotOriginatingRegion
		csp_IU_SCDSnapshotGLCategorizationHierarchy
		csp_IU_SCDSnapshotAllocationRegion
		csp_IU_SCDSnapshotActivityType
		csp_IU_SCDPropertyFund
		csp_IU_SCDOriginatingRegion
		csp_IU_SCDGLCategorizationHierarchy
		csp_IU_SCDFunctionalDepartment
		csp_IU_SCDAllocationRegion
		csp_IU_SCDActivityType

		stp_R_ProfitabilityV2
		stp_R_ProfitabilityDetailV2
		stp_R_ExpenseCzarTotalComparisonDetail
		stp_R_BudgetOwner
		stp_R_BudgetOriginator
		stp_R_BudgetJobCodeDetail
		stp_S_UnknownSummaryMRIActualsLocal
		stp_S_UnknownSummaryMRIActualsGlobal
		stp_S_UnknownMRIActualsCurrentWindowLocal
		stp_S_UnknownMRIActualsCurrentWindowGlobal
		
		[dbo].[stp_R_ValidReportingEntityActivityTypeCombinations]
   ============================================================================================================================================ */

USE [GrReporting]
GO
/****** Object:  StoredProcedure [dbo].[stp_S_UnknownMRIActualsCurrentWindowGlobal]    Script Date: 03/08/2012 12:51:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_S_UnknownMRIActualsCurrentWindowGlobal]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_S_UnknownMRIActualsCurrentWindowGlobal]
GO
/****** Object:  StoredProcedure [dbo].[stp_S_UnknownMRIActualsCurrentWindowLocal]    Script Date: 03/08/2012 12:51:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_S_UnknownMRIActualsCurrentWindowLocal]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_S_UnknownMRIActualsCurrentWindowLocal]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ProfitabilityV2]    Script Date: 03/08/2012 12:51:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ProfitabilityV2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ProfitabilityV2]
GO
/****** Object:  StoredProcedure [dbo].[stp_S_UnknownSummaryAllocatedOverhead]    Script Date: 03/08/2012 12:51:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_S_UnknownSummaryAllocatedOverhead]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_S_UnknownSummaryAllocatedOverhead]
GO
/****** Object:  StoredProcedure [dbo].[stp_S_UnknownSummaryMRIActualsGlobal]    Script Date: 03/08/2012 12:51:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_S_UnknownSummaryMRIActualsGlobal]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_S_UnknownSummaryMRIActualsGlobal]
GO
/****** Object:  StoredProcedure [dbo].[stp_S_UnknownSummaryMRIActualsLocal]    Script Date: 03/08/2012 12:51:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_S_UnknownSummaryMRIActualsLocal]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_S_UnknownSummaryMRIActualsLocal]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_BudgetJobCodeDetail]    Script Date: 03/08/2012 12:51:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetJobCodeDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_BudgetJobCodeDetail]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginator]    Script Date: 03/08/2012 12:51:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOriginator]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_BudgetOriginator]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOwner]    Script Date: 03/08/2012 12:51:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOwner]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_BudgetOwner]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzarTotalComparisonDetail]    Script Date: 03/08/2012 12:51:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzarTotalComparisonDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ExpenseCzarTotalComparisonDetail]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_MissingExchangeRates]    Script Date: 03/08/2012 12:51:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_MissingExchangeRates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_MissingExchangeRates]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ProfitabilityDetailV2]    Script Date: 03/08/2012 12:51:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ProfitabilityDetailV2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ProfitabilityDetailV2]
GO
/****** Object:  StoredProcedure [dbo].[stp_D_ProfitabilityActualIndex]    Script Date: 03/08/2012 12:51:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_D_ProfitabilityActualIndex]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_D_ProfitabilityActualIndex]
GO
/****** Object:  StoredProcedure [dbo].[stp_D_ProfitabilityBudgetIndex]    Script Date: 03/08/2012 12:51:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_D_ProfitabilityBudgetIndex]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_D_ProfitabilityBudgetIndex]
GO
/****** Object:  StoredProcedure [dbo].[stp_D_ProfitabilityReforecastIndex]    Script Date: 03/08/2012 12:51:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_D_ProfitabilityReforecastIndex]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_D_ProfitabilityReforecastIndex]
GO
/****** Object:  StoredProcedure [dbo].[stp_S_ValidNonPayrollRegionAndFunctionalDepartment]    Script Date: 03/08/2012 12:51:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_S_ValidNonPayrollRegionAndFunctionalDepartment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_S_ValidNonPayrollRegionAndFunctionalDepartment]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ValidFunctionalDepartmentGLGlobalAccountCombinations]    Script Date: 03/08/2012 12:51:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ValidFunctionalDepartmentGLGlobalAccountCombinations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ValidFunctionalDepartmentGLGlobalAccountCombinations]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ValidFunctionalDepartmentOriginatingRegionCombinations]    Script Date: 03/08/2012 12:51:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ValidFunctionalDepartmentOriginatingRegionCombinations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ValidFunctionalDepartmentOriginatingRegionCombinations]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ValidReportingEntityActivityTypeCombinations]    Script Date: 03/08/2012 12:51:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ValidReportingEntityActivityTypeCombinations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ValidReportingEntityActivityTypeCombinations]
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDActivityType]    Script Date: 03/08/2012 12:51:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDActivityType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDActivityType]
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDAllocationRegion]    Script Date: 03/08/2012 12:51:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDAllocationRegion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDAllocationRegion]
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDFunctionalDepartment]    Script Date: 03/08/2012 12:51:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDFunctionalDepartment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDFunctionalDepartment]
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDGLCategorizationHierarchy]    Script Date: 03/08/2012 12:51:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDGLCategorizationHierarchy]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDGLCategorizationHierarchy]
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDOriginatingRegion]    Script Date: 03/08/2012 12:51:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDOriginatingRegion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDOriginatingRegion]
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDPropertyFund]    Script Date: 03/08/2012 12:51:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDPropertyFund]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDPropertyFund]
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDSnapshotActivityType]    Script Date: 03/08/2012 12:51:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDSnapshotActivityType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDSnapshotActivityType]
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDSnapshotAllocationRegion]    Script Date: 03/08/2012 12:51:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDSnapshotAllocationRegion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDSnapshotAllocationRegion]
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDSnapshotGLCategorizationHierarchy]    Script Date: 03/08/2012 12:51:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDSnapshotGLCategorizationHierarchy]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDSnapshotGLCategorizationHierarchy]
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDSnapshotOriginatingRegion]    Script Date: 03/08/2012 12:51:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDSnapshotOriginatingRegion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDSnapshotOriginatingRegion]
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDSnapshotPropertyFund]    Script Date: 03/08/2012 12:51:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDSnapshotPropertyFund]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDSnapshotPropertyFund]
GO
/****** Object:  StoredProcedure [dbo].[csp_D_SCDFKConstraints]    Script Date: 03/08/2012 12:51:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_D_SCDFKConstraints]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_D_SCDFKConstraints]
GO
/****** Object:  StoredProcedure [dbo].[csp_I_SCDFKConstraints]    Script Date: 03/08/2012 12:51:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_I_SCDFKConstraints]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_I_SCDFKConstraints]
GO
/****** Object:  StoredProcedure [dbo].[stp_I_ProfitabilityActualIndex]    Script Date: 03/08/2012 12:51:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_I_ProfitabilityActualIndex]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_I_ProfitabilityActualIndex]
GO
/****** Object:  StoredProcedure [dbo].[stp_I_ProfitabilityBudgetIndex]    Script Date: 03/08/2012 12:51:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_I_ProfitabilityBudgetIndex]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_I_ProfitabilityBudgetIndex]
GO
/****** Object:  StoredProcedure [dbo].[stp_I_ProfitabilityReforecastIndex]    Script Date: 03/08/2012 12:51:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_I_ProfitabilityReforecastIndex]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_I_ProfitabilityReforecastIndex]
GO
/****** Object:  StoredProcedure [dbo].[stp_I_ProfitabilityReforecastIndex]    Script Date: 03/08/2012 12:51:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_I_ProfitabilityReforecastIndex]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_I_ProfitabilityReforecastIndex]
AS

/*
	Indexes:
		- dbo.ProfitabilityReforecast.IX_ActivityTypeKey
		- dbo.ProfitabilityReforecast.IX_AllocationRegionKey
		- dbo.ProfitabilityReforecast.IX_CalendarKey
		- dbo.ProfitabilityReforecast.IX_Clustered
		- dbo.ProfitabilityReforecast.IX_FunctionalDepartmentKey
		- dbo.ProfitabilityReforecast.IX_OriginatingRegionKey
		- dbo.ProfitabilityReforecast.IX_ProfitabilityReforecast_SourceSystemBudget
		- dbo.ProfitabilityReforecast.IX_PropertyFundKey
		- dbo.ProfitabilityReforecast.IX_ReferenceCode
		- dbo.ProfitabilityReforecast.IX_ReforecastKey
*/


/* =============================================================================================================================================== 
	Create Indexes
  ============================================================================================================================================== */

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityReforecast'') AND name = N''IX_Clustered'')
BEGIN

	CREATE CLUSTERED INDEX IX_Clustered ON dbo.ProfitabilityReforecast 
	(
		OriginatingRegionKey ASC,
		CalendarKey ASC,
		AllocationRegionKey ASC,
		GlobalGlCategorizationHierarchyKey ASC,
		FunctionalDepartmentKey ASC,
		PropertyFundKey ASC,
		SourceKey ASC,
		ReimbursableKey ASC,
		ActivityTypeKey ASC,
		LocalCurrencyKey ASC,
		OverheadKey ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityReforecast'') AND name = N''IX_ActivityTypeKey'')
BEGIN

	CREATE NONCLUSTERED INDEX IX_ActivityTypeKey ON dbo.ProfitabilityReforecast 
	(
		ActivityTypeKey ASC
	)
	INCLUDE (
		ProfitabilityReforecastKey,
		CalendarKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		PropertyFundKey,
		AllocationRegionKey,
		OriginatingRegionKey,
		LocalCurrencyKey,
		LocalReforecast,
		GlobalGlCategorizationHierarchyKey,
		BudgetReforecastTypeKey,
		OverheadKey,
		FeeAdjustmentKey
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityReforecast'') AND name = N''IX_AllocationRegionKey'')
BEGIN

	CREATE NONCLUSTERED INDEX IX_AllocationRegionKey ON dbo.ProfitabilityReforecast 
	(
		AllocationRegionKey ASC
	)
	INCLUDE (
		ProfitabilityReforecastKey,
		CalendarKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		PropertyFundKey,
		OriginatingRegionKey,
		LocalCurrencyKey,
		LocalReforecast,
		GlobalGlCategorizationHierarchyKey,
		BudgetReforecastTypeKey,
		OverheadKey,
		FeeAdjustmentKey
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityReforecast'') AND name = N''IX_CalendarKey'')
BEGIN

	CREATE NONCLUSTERED INDEX IX_CalendarKey ON dbo.ProfitabilityReforecast 
	(
		CalendarKey ASC
	)
	INCLUDE (
		LocalReforecast,
		ProfitabilityReforecastKey,
		PropertyFundKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		AllocationRegionKey,
		OriginatingRegionKey,
		LocalCurrencyKey,
		SourceKey,
		ActivityTypeKey,
		GlobalGlCategorizationHierarchyKey,
		BudgetReforecastTypeKey,
		OverheadKey,
		FeeAdjustmentKey
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityReforecast'') AND name = N''IX_FunctionalDepartmentKey'')
BEGIN

	CREATE NONCLUSTERED INDEX IX_FunctionalDepartmentKey ON dbo.ProfitabilityReforecast 
	(
		FunctionalDepartmentKey ASC
	)
	INCLUDE (
		ProfitabilityReforecastKey,
		CalendarKey,
		ReimbursableKey,
		PropertyFundKey,
		AllocationRegionKey,
		LocalCurrencyKey,
		LocalReforecast,
		SourceKey,
		ActivityTypeKey,
		OriginatingRegionKey,
		GlobalGlCategorizationHierarchyKey,
		BudgetReforecastTypeKey,
		OverheadKey,
		FeeAdjustmentKey
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityReforecast'') AND name = N''IX_OriginatingRegionKey'')
BEGIN

	CREATE NONCLUSTERED INDEX IX_OriginatingRegionKey ON dbo.ProfitabilityReforecast 
	(
		OriginatingRegionKey ASC,
		CalendarKey ASC,
		SourceKey ASC,
		FunctionalDepartmentKey ASC,
		ReimbursableKey ASC,
		ActivityTypeKey ASC,
		PropertyFundKey ASC,
		AllocationRegionKey ASC,
		LocalCurrencyKey ASC,
		GlobalGlCategorizationHierarchyKey ASC,
		BudgetReforecastTypeKey,
		OverheadKey ASC,
		FeeAdjustmentKey ASC
	)
	INCLUDE ( LocalReforecast,
	ProfitabilityReforecastKey) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityReforecast'') AND name = N''IX_PropertyFundKey'')
BEGIN

	CREATE NONCLUSTERED INDEX IX_PropertyFundKey ON dbo.ProfitabilityReforecast 
	(
		PropertyFundKey ASC
	)
	INCLUDE (
		LocalReforecast,
		ProfitabilityReforecastKey,
		CalendarKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		AllocationRegionKey,
		OriginatingRegionKey,
		LocalCurrencyKey,
		GlobalGlCategorizationHierarchyKey,
		BudgetReforecastTypeKey,
		OverheadKey,
		FeeAdjustmentKey
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityReforecast'') AND name = N''IX_ReferenceCode'')
BEGIN

	CREATE UNIQUE NONCLUSTERED INDEX IX_ReferenceCode ON dbo.ProfitabilityReforecast 
	(
		ReferenceCode ASC
	)
	INCLUDE ( ProfitabilityReforecastKey) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityReforecast'') AND name = N''IX_ReforecastKey'')
BEGIN

	CREATE INDEX IX_ReforecastKey ON GrReporting.dbo.ProfitabilityReforecast 
	(
		ReforecastKey
	) 
	INCLUDE (
		CalendarKey, 
		SourceKey, 
		FunctionalDepartmentKey,
		ReimbursableKey, 
		PropertyFundKey, 
		AllocationRegionKey, 
		OriginatingRegionKey, 
		LocalCurrencyKey, 
		LocalReforecast, 
		ReferenceCode, 
		GlobalGlCategorizationHierarchyKey,
		BudgetReforecastTypeKey, 
		OverheadKey
	)

END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityReforecast'') AND name = N''IX_ProfitabilityReforecast_Budget_BudgetReforecastType'')
BEGIN

	CREATE NONCLUSTERED INDEX IX_ProfitabilityReforecast_Budget_BudgetReforecastType ON dbo.ProfitabilityReforecast 
	(
		BudgetId ASC,
		BudgetReforecastTypeKey ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityReforecast'') AND name = N''IX_FeeAdjustmentKey'')
BEGIN

	CREATE NONCLUSTERED INDEX IX_FeeAdjustmentKey ON dbo.ProfitabilityReforecast 
	(
		FeeAdjustmentKey ASC
	)
	INCLUDE ( CalendarKey,
	ReforecastKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalReforecast,
	GlobalGlCategorizationHierarchyKey,
	OverheadKey,
	ConsolidationRegionKey) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_I_ProfitabilityBudgetIndex]    Script Date: 03/08/2012 12:51:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_I_ProfitabilityBudgetIndex]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_I_ProfitabilityBudgetIndex]
AS

/*
	Indexes:
		- dbo.ProfitabilityBudget.IX_ActivityTypeKey
		- dbo.ProfitabilityBudget.IX_AllocationRegionKey
		- dbo.ProfitabilityBudget.IX_CalendarKey
		- dbo.ProfitabilityBudget.IX_Clustered
		- dbo.ProfitabilityBudget.IX_FunctionalDepartmentKey
		- dbo.ProfitabilityBudget.IX_GlAccountKey
		- dbo.ProfitabilityBudget.IX_OriginatingRegionKey
		- dbo.ProfitabilityBudget.IX_ProfitabilityBudget_SourceSystemBudget				don''t recreate
		- dbo.ProfitabilityBudget.IX_PropertyFundKey
		- dbo.ProfitabilityBudget.IX_ReferenceCode
		- dbo.ProfitabilityBudget.IX_ProfitabilityBudget_Budget_BudgetReforecastType
		- dbo.ProfitabilityBudget.IX_BudgetIdSourceSystemId								don''t recreate
		- dbo.ProfitabilityBudget.IX_ProfitabilityBudget_SourceSystemBudget				don''t recreate

*/

/* ===============================================================================================================================================
	Create Indexes
   =============================================================================================================================================*/

DECLARE @StartTime DATETIME = GETDATE()

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityBudget'') AND name = N''IX_Clustered'')
BEGIN

	CREATE CLUSTERED INDEX IX_Clustered ON dbo.ProfitabilityBudget 
	(
		OriginatingRegionKey ASC,
		CalendarKey ASC,
		AllocationRegionKey ASC,
		GlobalGlCategorizationHierarchyKey ASC,
		FunctionalDepartmentKey ASC,
		PropertyFundKey ASC,
		SourceKey ASC,
		ReimbursableKey ASC,
		ActivityTypeKey ASC,
		LocalCurrencyKey ASC,
		OverheadKey ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

	PRINT (''Index dbo.ProfitabilityBudget.IX_Clustered created in '' + CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END

----------------------------------------------------------------------------------------------------------------------------------------

SET @StartTime = GETDATE()

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityBudget'') AND name = N''IX_ActivityTypeKey'')
BEGIN

	CREATE NONCLUSTERED INDEX IX_ActivityTypeKey ON dbo.ProfitabilityBudget 
	(
		ActivityTypeKey ASC
	)
	INCLUDE (
		ProfitabilityBudgetKey,
		CalendarKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		PropertyFundKey,
		AllocationRegionKey,
		OriginatingRegionKey,
		LocalCurrencyKey,
		LocalBudget,
		GlobalGlCategorizationHierarchyKey,
		BudgetReforecastTypeKey,
		OverheadKey,
		FeeAdjustmentKey
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

	PRINT (''Index dbo.ProfitabilityBudget.IX_ActivityTypeKey created in '' + CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END

----------------------------------------------------------------------------------------------------------------------------------------

SET @StartTime = GETDATE()

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityBudget'') AND name = N''IX_AllocationRegionKey'')
BEGIN

	CREATE NONCLUSTERED INDEX IX_AllocationRegionKey ON dbo.ProfitabilityBudget 
	(
		AllocationRegionKey ASC
	)
	INCLUDE (
		ProfitabilityBudgetKey,
		CalendarKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		PropertyFundKey,
		OriginatingRegionKey,
		LocalCurrencyKey,
		LocalBudget,
		GlobalGlCategorizationHierarchyKey,
		BudgetReforecastTypeKey,
		OverheadKey,
		FeeAdjustmentKey
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

	PRINT (''Index dbo.ProfitabilityBudget.IX_AllocationRegionKey created in '' + CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END


----------------------------------------------------------------------------------------------------------------------------------------

SET @StartTime = GETDATE()

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityBudget'') AND name = N''IX_CalendarKey'')
BEGIN

	CREATE NONCLUSTERED INDEX IX_CalendarKey ON dbo.ProfitabilityBudget 
	(
		CalendarKey ASC
	)
	INCLUDE (
		LocalBudget,
		ProfitabilityBudgetKey,
		PropertyFundKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		AllocationRegionKey,
		OriginatingRegionKey,
		LocalCurrencyKey,
		SourceKey,
		ActivityTypeKey,
		GlobalGlCategorizationHierarchyKey,
		BudgetReforecastTypeKey,
		OverheadKey,
		FeeAdjustmentKey
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

	PRINT (''Index dbo.ProfitabilityBudget.IX_CalendarKey created in '' + CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END

----------------------------------------------------------------------------------------------------------------------------------------

SET @StartTime = GETDATE()

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityBudget'') AND name = N''IX_FunctionalDepartmentKey'')
BEGIN

	CREATE NONCLUSTERED INDEX IX_FunctionalDepartmentKey ON dbo.ProfitabilityBudget 
	(
		FunctionalDepartmentKey ASC
	)
	INCLUDE (
		ProfitabilityBudgetKey,
		CalendarKey,
		ReimbursableKey,
		PropertyFundKey,
		AllocationRegionKey,
		LocalCurrencyKey,
		LocalBudget,
		SourceKey,
		ActivityTypeKey,
		OriginatingRegionKey,
		GlobalGlCategorizationHierarchyKey,
		BudgetReforecastTypeKey,
		OverheadKey,
		FeeAdjustmentKey
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

	PRINT (''Index dbo.ProfitabilityBudget.IX_FunctionalDepartmentKey created in '' + CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END

----------------------------------------------------------------------------------------------------------------------------------------

SET @StartTime = GETDATE()

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityBudget'') AND name = N''IX_OriginatingRegionKey'')
BEGIN

	CREATE NONCLUSTERED INDEX IX_OriginatingRegionKey ON dbo.ProfitabilityBudget 
	(
		OriginatingRegionKey ASC,
		CalendarKey ASC,
		SourceKey ASC,
		FunctionalDepartmentKey ASC,
		ReimbursableKey ASC,
		ActivityTypeKey ASC,
		PropertyFundKey ASC,
		AllocationRegionKey ASC,
		LocalCurrencyKey ASC,
		GlobalGlCategorizationHierarchyKey ASC,
		BudgetReforecastTypeKey ASC,
		OverheadKey ASC,
		FeeAdjustmentKey ASC
	)
	INCLUDE ( LocalBudget,
	ProfitabilityBudgetKey) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

	PRINT (''Index dbo.ProfitabilityBudget.IX_OriginatingRegionKey created in '' + CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END

----------------------------------------------------------------------------------------------------------------------------------------

SET @StartTime = GETDATE()

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityBudget'') AND name = N''IX_ProfitabilityBudget_Budget_BudgetReforecastType'')
BEGIN

	CREATE NONCLUSTERED INDEX IX_ProfitabilityBudget_Budget_BudgetReforecastType ON dbo.ProfitabilityBudget 
	(
		BudgetId ASC,
		BudgetReforecastTypeKey ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

	PRINT (''Index dbo.ProfitabilityBudget.IX_ProfitabilityBudget_Budget_BudgetReforecastType created in '' + CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END

----------------------------------------------------------------------------------------------------------------------------------------

SET @StartTime = GETDATE()

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityBudget'') AND name = N''IX_PropertyFundKey'')
BEGIN

	CREATE NONCLUSTERED INDEX IX_PropertyFundKey ON dbo.ProfitabilityBudget 
	(
		PropertyFundKey ASC
	)
	INCLUDE (
		LocalBudget,
		ProfitabilityBudgetKey,
		CalendarKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		AllocationRegionKey,
		OriginatingRegionKey,
		LocalCurrencyKey,
		GlobalGlCategorizationHierarchyKey,
		BudgetReforecastTypeKey,
		OverheadKey,
		FeeAdjustmentKey
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

	PRINT (''Index dbo.ProfitabilityBudget.IX_PropertyFundKey created in '' + CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END

----------------------------------------------------------------------------------------------------------------------------------------

SET @StartTime = GETDATE()

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityBudget'') AND name = N''IX_ReferenceCode'')
BEGIN

	CREATE UNIQUE NONCLUSTERED INDEX IX_ReferenceCode ON dbo.ProfitabilityBudget 
	(
		ReferenceCode ASC
	)
	INCLUDE ( ProfitabilityBudgetKey) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	 
	PRINT (''Index dbo.ProfitabilityBudget.IX_ReferenceCode created in '' + CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_I_ProfitabilityActualIndex]    Script Date: 03/08/2012 12:51:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_I_ProfitabilityActualIndex]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_I_ProfitabilityActualIndex]
AS


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ProfitabilityActual]'') AND name = N''IX_Clustered'')
BEGIN
CREATE CLUSTERED INDEX [IX_Clustered] ON [dbo].[ProfitabilityActual] 
(
	[OriginatingRegionKey] ASC,
	[CalendarKey] ASC,
	[AllocationRegionKey] ASC,
	[GlobalGlCategorizationHierarchyKey] ASC,
	[FunctionalDepartmentKey] ASC,
	[PropertyFundKey] ASC,
	[SourceKey] ASC,
	[ReimbursableKey] ASC,
	[ActivityTypeKey] ASC,
	[LocalCurrencyKey] ASC,
	[OverheadKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ProfitabilityActual]'') AND name = N''IX_ActivityTypeKey'')
BEGIN
CREATE NONCLUSTERED INDEX [IX_ActivityTypeKey] ON [dbo].[ProfitabilityActual] 
(
	[ActivityTypeKey] ASC
)
INCLUDE ( [ProfitabilityActualKey],
[CalendarKey],
[SourceKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[PropertyFundKey],
[AllocationRegionKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[LocalActual],
[GlobalGlCategorizationHierarchyKey],
[OverheadKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ProfitabilityActual]'') AND name = N''IX_AllocationRegionKey'')
BEGIN
CREATE NONCLUSTERED INDEX [IX_AllocationRegionKey] ON [dbo].[ProfitabilityActual] 
(
	[AllocationRegionKey] ASC
)
INCLUDE ( [ProfitabilityActualKey],
[CalendarKey],
[SourceKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[ActivityTypeKey],
[PropertyFundKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[LocalActual],
[GlobalGlCategorizationHierarchyKey],
[OverheadKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ProfitabilityActual]'') AND name = N''IX_CalendarKey'')
BEGIN
CREATE NONCLUSTERED INDEX [IX_CalendarKey] ON [dbo].[ProfitabilityActual] 
(
	[CalendarKey] ASC
)
INCLUDE ( [LocalActual],
[ProfitabilityActualKey],
[PropertyFundKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[AllocationRegionKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[SourceKey],
[ActivityTypeKey],
[GlobalGlCategorizationHierarchyKey],
[OverheadKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ProfitabilityActual]'') AND name = N''IX_FunctionalDepartmentKey'')
BEGIN
CREATE NONCLUSTERED INDEX [IX_FunctionalDepartmentKey] ON [dbo].[ProfitabilityActual] 
(
	[FunctionalDepartmentKey] ASC
)
INCLUDE ( [ProfitabilityActualKey],
[CalendarKey],
[ReimbursableKey],
[PropertyFundKey],
[AllocationRegionKey],
[LocalCurrencyKey],
[LocalActual],
[SourceKey],
[ActivityTypeKey],
[OriginatingRegionKey],
[GlobalGlCategorizationHierarchyKey],
[OverheadKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ProfitabilityActual]'') AND name = N''IX_OriginatingRegionKey'')
BEGIN
CREATE NONCLUSTERED INDEX [IX_OriginatingRegionKey] ON [dbo].[ProfitabilityActual] 
(
	[OriginatingRegionKey] ASC
)
INCLUDE ( [LocalActual],
[CalendarKey],
[SourceKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[ActivityTypeKey],
[PropertyFundKey],
[AllocationRegionKey],
[LocalCurrencyKey],
[GlobalGlCategorizationHierarchyKey],
[OverheadKey],
[ProfitabilityActualKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ProfitabilityActual]'') AND name = N''IX_PropertyFundKey'')
BEGIN
CREATE NONCLUSTERED INDEX [IX_PropertyFundKey] ON [dbo].[ProfitabilityActual] 
(
	[PropertyFundKey] ASC
)
INCLUDE ( [LocalActual],
[ProfitabilityActualKey],
[CalendarKey],
[SourceKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[ActivityTypeKey],
[AllocationRegionKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[GlobalGlCategorizationHierarchyKey],
[OverheadKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[csp_I_SCDFKConstraints]    Script Date: 03/08/2012 12:51:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_I_SCDFKConstraints]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_I_SCDFKConstraints]

AS
																																			 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.ActivityType                                                                                                                              ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */

ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_ActivityType] FOREIGN KEY([ActivityTypeKey])
	REFERENCES [dbo].[ActivityType] ([ActivityTypeKey])
ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_ActivityType]
--
ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_ActivityType] FOREIGN KEY([ActivityTypeKey])
	REFERENCES [dbo].[ActivityType] ([ActivityTypeKey])
ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_ActivityType]
--
ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_ActivityType] FOREIGN KEY([ActivityTypeKey])
	REFERENCES [dbo].[ActivityType] ([ActivityTypeKey])
ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_ActivityType]
--
ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_ActivityType] FOREIGN KEY([ActivityTypeKey])
	REFERENCES [dbo].[ActivityType] ([ActivityTypeKey])
ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_ActivityType]
																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.AllocationRegion                                                                                                                          ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */

ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_AllocationRegion] FOREIGN KEY([AllocationRegionKey])
	REFERENCES [dbo].[AllocationRegion] ([AllocationRegionKey])
ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_AllocationRegion]
--
ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_AllocationRegion] FOREIGN KEY([AllocationRegionKey])
	REFERENCES [dbo].[AllocationRegion] ([AllocationRegionKey])
ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_AllocationRegion]
--
ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_AllocationRegion] FOREIGN KEY([AllocationRegionKey])
	REFERENCES [dbo].[AllocationRegion] ([AllocationRegionKey])
ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_AllocationRegion]
--
ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_AllocationRegion] FOREIGN KEY([AllocationRegionKey])
	REFERENCES [dbo].[AllocationRegion] ([AllocationRegionKey])
ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_AllocationRegion]
																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.GLAccount                                                                                                                                 ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */

ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_GlAccount] FOREIGN KEY([GlAccountKey])
	REFERENCES [dbo].[GlAccount] ([GlAccountKey])
ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_GlAccount]
--
ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_GlAccount] FOREIGN KEY([GlAccountKey])
	REFERENCES [dbo].[GlAccount] ([GlAccountKey])
ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_GlAccount]
--
ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_GlAccount] FOREIGN KEY([GlAccountKey])
	REFERENCES [dbo].[GlAccount] ([GlAccountKey])
ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_GlAccount]
--
ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_GlAccount] FOREIGN KEY([GlAccountKey])
	REFERENCES [dbo].[GlAccount] ([GlAccountKey])
ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_GlAccount]
																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.OriginatingRegion                                                                                                                         ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */

ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_OriginatingRegion] FOREIGN KEY([OriginatingRegionKey])
	REFERENCES [dbo].[OriginatingRegion] ([OriginatingRegionKey])
ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_OriginatingRegion]
--
ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_OriginatingRegion] FOREIGN KEY([OriginatingRegionKey])
	REFERENCES [dbo].[OriginatingRegion] ([OriginatingRegionKey])
ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_OriginatingRegion]
--
ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_OriginatingRegion] FOREIGN KEY([OriginatingRegionKey])
	REFERENCES [dbo].[OriginatingRegion] ([OriginatingRegionKey])
ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_OriginatingRegion]
--
ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_OriginatingRegion] FOREIGN KEY([OriginatingRegionKey])
	REFERENCES [dbo].[OriginatingRegion] ([OriginatingRegionKey])
ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_OriginatingRegion]
																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.PropertyFund                                                                                                                              ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */

ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_PropertyFund] FOREIGN KEY([PropertyFundKey])
	REFERENCES [dbo].[PropertyFund] ([PropertyFundKey])
ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_PropertyFund]
--
ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_PropertyFund] FOREIGN KEY([PropertyFundKey])
	REFERENCES [dbo].[PropertyFund] ([PropertyFundKey])
ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_PropertyFund]
--
ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_PropertyFund] FOREIGN KEY([PropertyFundKey])
	REFERENCES [dbo].[PropertyFund] ([PropertyFundKey])
ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_PropertyFund]
--
ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_PropertyFund] FOREIGN KEY([PropertyFundKey])
	REFERENCES [dbo].[PropertyFund] ([PropertyFundKey])
ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_PropertyFund]
																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.GLAccountCategory                                                                                                                         ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */

	-- dbo.ProfitabilityActual
ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_Development_GlAccountCategory] FOREIGN KEY([DevelopmentGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_Development_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_EUCorporate_GlAccountCategory] FOREIGN KEY([EUCorporateGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_EUCorporate_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_EUFund_GlAccountCategory] FOREIGN KEY([EUFundGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_EUFund_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_EUProperty_GlAccountCategory] FOREIGN KEY([EUPropertyGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_EUProperty_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_Global_GlAccountCategory] FOREIGN KEY([GlobalGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_Global_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_USCorporate_GlAccountCategory] FOREIGN KEY([USCorporateGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_USCorporate_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_USFund_GlAccountCategory] FOREIGN KEY([USFundGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_USFund_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_USProperty_GlAccountCategory] FOREIGN KEY([USPropertyGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_USProperty_GlAccountCategory]

	-- dbo.ProfitabilityBudget
ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_Development_GlAccountCategory] FOREIGN KEY([DevelopmentGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_Development_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_EUCorporate_GlAccountCategory] FOREIGN KEY([EUCorporateGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_EUCorporate_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_EUFund_GlAccountCategory] FOREIGN KEY([EUFundGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_EUFund_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_EUProperty_GlAccountCategory] FOREIGN KEY([EUPropertyGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_EUProperty_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_Global_GlAccountCategory] FOREIGN KEY([GlobalGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_Global_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_USCorporate_GlAccountCategory] FOREIGN KEY([USCorporateGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_USCorporate_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_USFund_GlAccountCategory] FOREIGN KEY([USFundGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_USFund_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_USProperty_GlAccountCategory] FOREIGN KEY([USPropertyGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_USProperty_GlAccountCategory]

	-- dbo.ProfitabilityReforecast
ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_Development_GlAccountCategory] FOREIGN KEY([DevelopmentGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_Development_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_EUCorporate_GlAccountCategory] FOREIGN KEY([EUCorporateGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_EUCorporate_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_EUFund_GlAccountCategory] FOREIGN KEY([EUFundGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_EUFund_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_EUProperty_GlAccountCategory] FOREIGN KEY([EUPropertyGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_EUProperty_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_Global_GlAccountCategory] FOREIGN KEY([GlobalGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_Global_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_USCorporate_GlAccountCategory] FOREIGN KEY([USCorporateGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_USCorporate_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_USFund_GlAccountCategory] FOREIGN KEY([USFundGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_USFund_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_USProperty_GlAccountCategory] FOREIGN KEY([USPropertyGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_USProperty_GlAccountCategory]

-- dbo.ProfitabilityActualArchive
ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_Development_GlAccountCategory] FOREIGN KEY([DevelopmentGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_Development_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_EUCorporate_GlAccountCategory] FOREIGN KEY([EUCorporateGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_EUCorporate_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_EUFund_GlAccountCategory] FOREIGN KEY([EUFundGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_EUFund_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_EUProperty_GlAccountCategory] FOREIGN KEY([EUPropertyGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_EUProperty_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_Global_GlAccountCategory] FOREIGN KEY([GlobalGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_Global_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_USCorporate_GlAccountCategory] FOREIGN KEY([USCorporateGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_USCorporate_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_USFund_GlAccountCategory] FOREIGN KEY([USFundGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_USFund_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_USProperty_GlAccountCategory] FOREIGN KEY([USPropertyGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_USProperty_GlAccountCategory]
																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.ReportingEntity                                                                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */


																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.FunctionalDepartment                                                                                                                      ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */

' 
END
GO
/****** Object:  StoredProcedure [dbo].[csp_D_SCDFKConstraints]    Script Date: 03/08/2012 12:51:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_D_SCDFKConstraints]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_D_SCDFKConstraints]

AS

/*
	There is a bug in SQL Server 2008 that prevents the use of the MERGE statement when the table that is being merged to is referenced by
	other tables using FKs. [http://connect.microsoft.com/SQLServer/feedback/details/435031/]
	A work-around involves dropping the FKs that are affected, and recreating them after the MERGE operations have completed (stp_IU_SCDFKConstraints)
*/

																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.ActivityType                                                                                                                              ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityActual_ActivityType]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityActual]''))
	ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_ActivityType]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityActualArchive_ActivityType]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityActualArchive]''))
	ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_ActivityType]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityBudget_ActivityType]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityBudget]''))
	ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_ActivityType]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityReforecast_ActivityType]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityReforecast]''))
	ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_ActivityType]
																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.AllocationRegion                                                                                                                          ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityActual_AllocationRegion]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityActual]''))
	ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_AllocationRegion]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityActualArchive_AllocationRegion]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityActualArchive]''))
	ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_AllocationRegion]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityBudget_AllocationRegion]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityBudget]''))
	ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_AllocationRegion]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityReforecast_AllocationRegion]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityReforecast]''))
	ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_AllocationRegion]
																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.GLAccount                                                                                                                                 ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityActual_GlAccount]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityActual]''))
	ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_GlAccount]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityActualArchive_GlAccount]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityActualArchive]''))
	ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_GlAccount]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityBudget_GlAccount]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityBudget]''))
	ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_GlAccount]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityReforecast_GlAccount]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityReforecast]''))
	ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_GlAccount]
																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.OriginatingRegion                                                                                                                         ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityActual_OriginatingRegion]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityActual]''))
	ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_OriginatingRegion]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityActualArchive_OriginatingRegion]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityActualArchive]''))
	ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_OriginatingRegion]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityBudget_OriginatingRegion]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityBudget]''))
	ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_OriginatingRegion]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityReforecast_OriginatingRegion]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityReforecast]''))
	ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_OriginatingRegion]
																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.PropertyFund                                                                                                                              ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityActual_PropertyFund]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityActual]''))
	ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_PropertyFund]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityActualArchive_PropertyFund]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityActualArchive]''))
	ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_PropertyFund]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityBudget_PropertyFund]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityBudget]''))
	ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_PropertyFund]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityReforecast_PropertyFund]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityReforecast]''))
	ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_PropertyFund]

																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.GLAccountCategory                                                                                                                         ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */

	-- dbo.ProfitabilityActual

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityActual_Development_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityActual]''))
	ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_Development_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityActual_EUCorporate_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityActual]''))
	ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_EUCorporate_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityActual_EUFund_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityActual]''))
	ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_EUFund_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityActual_EUProperty_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityActual]''))
	ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_EUProperty_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityActual_Global_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityActual]''))
	ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_Global_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityActual_USCorporate_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityActual]''))
	ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_USCorporate_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityActual_USFund_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityActual]''))
	ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_USFund_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityActual_USProperty_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityActual]''))
	ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_USProperty_GlAccountCategory]

	-- dbo.ProfitabilityBudget

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityBudget_Development_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityBudget]''))
	ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_Development_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityBudget_EUCorporate_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityBudget]''))
	ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_EUCorporate_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityBudget_EUFund_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityBudget]''))
	ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_EUFund_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityBudget_EUProperty_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityBudget]''))
	ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_EUProperty_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityBudget_Global_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityBudget]''))
	ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_Global_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityBudget_USCorporate_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityBudget]''))
	ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_USCorporate_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityBudget_USFund_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityBudget]''))
	ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_USFund_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityBudget_USProperty_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityBudget]''))
	ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_USProperty_GlAccountCategory]

	-- dbo.ProfitabilityReforecast

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityReforecast_Development_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityReforecast]''))
	ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_Development_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityReforecast_EUCorporate_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityReforecast]''))
	ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_EUCorporate_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityReforecast_EUFund_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityReforecast]''))
	ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_EUFund_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityReforecast_EUProperty_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityReforecast]''))
	ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_EUProperty_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityReforecast_Global_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityReforecast]''))
	ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_Global_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityReforecast_USCorporate_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityReforecast]''))
	ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_USCorporate_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityReforecast_USFund_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityReforecast]''))
	ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_USFund_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityReforecast_USProperty_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityReforecast]''))
	ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_USProperty_GlAccountCategory]

	-- dbo.ProfitabilityActualArchive

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityActualArchive_Development_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityActualArchive]''))
	ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_Development_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityActualArchive_EUCorporate_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityActualArchive]''))
	ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_EUCorporate_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityActualArchive_EUFund_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityActualArchive]''))
	ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_EUFund_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityActualArchive_EUProperty_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityActualArchive]''))
	ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_EUProperty_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityActualArchive_Global_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityActualArchive]''))
	ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_Global_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityActualArchive_USCorporate_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityActualArchive]''))
	ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_USCorporate_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityActualArchive_USFund_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityActualArchive]''))
	ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_USFund_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityActualArchive_USProperty_GlAccountCategory]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityActualArchive]''))
	ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_USProperty_GlAccountCategory]
																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.ReportingEntity                                                                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */


																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.FunctionalDepartment                                                                                                                      ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityActual_FunctionalDepartment]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityActual]''))
	ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_FunctionalDepartment]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityActualArchive_FunctionalDepartment]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityActualArchive]''))
	ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_FunctionalDepartment]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityBudget_FunctionalDepartment]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityBudget]''))
	ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_FunctionalDepartment]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ProfitabilityReforecast_FunctionalDepartment]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ProfitabilityReforecast]''))
	ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_FunctionalDepartment]







' 
END
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDSnapshotPropertyFund]    Script Date: 03/08/2012 12:51:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDSnapshotPropertyFund]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[csp_IU_SCDSnapshotPropertyFund]

AS

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record needs to be ended, use this date
DECLARE @MaximumEndDate DATETIME = ''9999-12-31 00:00:00.000''

MERGE INTO
	dbo.PropertyFund DIM
USING
(
	SELECT
		PF.PropertyFundId,
		PF.Name AS PropertyFundName,
		ET.Name AS PropertyFundType,
		CONVERT(DATETIME, ''1753-01-01 00:00:00.000'') AS InsertedDate,
		CONVERT(DATETIME, ''9999-12-31 00:00:00.000'') AS UpdatedDate,
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
		DIM.EndDate = @MaximumEndDate,					-- Make sure that the dimension record''s EndDate = ''9999-12-31'' as this dimension
														--		record has been matched to an active SRC record.
		DIM.ReasonForChange = ''Record updated in source''

WHEN NOT MATCHED BY TARGET THEN -- When a record exists in [Source/SRC] that doesn''t exist in [Target/DIM], insert it
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
		''1753-01-01 00:00:00.000'',
		@MaximumEndDate,
		SRC.SnapshotId,
		''New record in source''
	)

WHEN NOT MATCHED BY SOURCE AND  -- When a record exists in [Target/DIM] that doesn''t exist in [Source/SRC], ''end'' it
	DIM.PropertyFundKey <> -1 AND		-- Exclude the ''UNKNOWN'' dimension record
	DIM.EndDate = @MaximumEndDate AND	-- Make sure that the dimension record hasn''t been ended already
	DIM.SnapshotId <> 0					-- Do not consider unsnapshotted (SnapshotId = 0) dimension records
THEN
	UPDATE
	SET
		DIM.EndDate = @NewEndDate,
		ReasonForChange = ''Record no longer exists in source'';


' 
END
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDSnapshotOriginatingRegion]    Script Date: 03/08/2012 12:51:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDSnapshotOriginatingRegion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[csp_IU_SCDSnapshotOriginatingRegion]

AS

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record needs to be ended, use this date
DECLARE @MaximumEndDate DATETIME = ''9999-12-31 00:00:00.000''

MERGE INTO
	dbo.OriginatingRegion DIM
USING
(
	SELECT
		GlobalRegionId,
		RegionCode,
		RegionName RegionName,
		CONVERT(DATETIME, ''1753-01-01 00:00:00.000'') AS InsertedDate,
		CONVERT(DATETIME, ''9999-12-31 00:00:00.000'') AS UpdatedDate,
		ISNULL(SubRegionCode,''N/A'') SubRegionCode,
		ISNULL(SubRegionName,''Not Applicable'') SubRegionName,
		SnapshotId		
	FROM
		GrReportingStaging.Gr.GetSnapshotGlobalRegionExpanded()
	WHERE
		IsOriginatingRegion = 1 AND
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
		DIM.EndDate = @MaximumEndDate,					-- Make sure that the dimension record''s EndDate = ''9999-12-31'' as this dimension
														--		record has been matched to an active SRC record.
		DIM.ReasonForChange = ''Record updated in source''

WHEN NOT MATCHED BY TARGET THEN -- When a record exists in [Source/SRC] that doesn''t exist in [Target/DIM], insert it
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
		''1753-01-01 00:00:00.000'',
		@MaximumEndDate,
		SRC.SnapshotId,
		''New record in source''
	)

WHEN NOT MATCHED BY SOURCE AND  -- When a record exists in [Target/DIM] that doesn''t exist in [Source/SRC], ''end'' it
	DIM.OriginatingRegionKey <> -1 AND	-- Exclude the ''UNKNOWN'' dimension record
	DIM.EndDate = @MaximumEndDate AND	-- Make sure that the dimension record hasn''t been ended already, else we''d continuously update EndDate
	DIM.SnapshotId <> 0					-- Do not consider unsnapshotted (SnapshotId = 0) dimension records
THEN
	UPDATE
	SET
		DIM.EndDate = @NewEndDate,
		ReasonForChange = ''Record no longer exists in source'';


' 
END
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDSnapshotGLCategorizationHierarchy]    Script Date: 03/08/2012 12:51:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDSnapshotGLCategorizationHierarchy]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_IU_SCDSnapshotGLCategorizationHierarchy]

AS

DECLARE @NewEndDate DATETIME = GETDATE()
DECLARE @MinimumStartDate DATETIME = ''1753-01-01 00:00:00.000''
DECLARE @MaximumEndDate DATETIME = ''9999-12-31 00:00:00.000''

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
		DIM.ReasonForChange = ''Record updated in source'',
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
		''New or reactivated record in source''
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
		ReasonForChange = ''Record no longer exists in source'';
			
	----------
' 
END
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDSnapshotAllocationRegion]    Script Date: 03/08/2012 12:51:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDSnapshotAllocationRegion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_IU_SCDSnapshotAllocationRegion]

AS

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record needs to be ended, use this date
DECLARE @MaximumEndDate DATETIME = ''9999-12-31 00:00:00.000''

MERGE INTO
	dbo.AllocationRegion DIM
USING
(
	SELECT
		GlobalRegionId,
		RegionCode,
		RegionName,
		CONVERT(DATETIME, ''1753-01-01 00:00:00.000'') AS InsertedDate,
		CONVERT(DATETIME, ''9999-12-31 00:00:00.000'') AS UpdatedDate,
		ISNULL(SubRegionCode,''N/A'') SubRegionCode,
		ISNULL(SubRegionName,''Not Applicable'') SubRegionName,
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
		DIM.EndDate = @MaximumEndDate,					-- Make sure that the dimension record''s EndDate = ''9999-12-31'' as this dimension
														--		record has been matched to an active SRC record.
		DIM.ReasonForChange = ''Record updated in source''

WHEN NOT MATCHED BY TARGET THEN -- When a record exists in [Source/SRC] that doesn''t exist in [Target/DIM], insert it
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
		''1753-01-01 00:00:00.000'',
		@MaximumEndDate,
		SRC.SnapshotId,
		''New record in source''
	)

WHEN NOT MATCHED BY SOURCE AND  -- When a record exists in [Target/DIM] that doesn''t exist in [Source/SRC], ''end'' it
	DIM.AllocationRegionKey <> -1 AND	-- Exclude the ''UNKNOWN'' dimension record
	DIM.EndDate = @MaximumEndDate AND	-- Make sure that the dimension record hasn''t been ended already, else we''d continuously update EndDate
	DIM.SnapshotId <> 0					-- Do not consider unsnapshotted (SnapshotId = 0) dimension records
THEN
	UPDATE
	SET
		DIM.EndDate = @NewEndDate,
		ReasonForChange = ''Record no longer exists in source'';

' 
END
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDSnapshotActivityType]    Script Date: 03/08/2012 12:51:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDSnapshotActivityType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[csp_IU_SCDSnapshotActivityType]

AS

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record needs to be ended, use this date
DECLARE @MaximumEndDate DATETIME = ''9999-12-31 00:00:00.000''

/* IMPORTANT: There is no single business key that we can use to match dimension records with source records: we match using ActivityTypeId and
			  BusinessLineId. For this reason it''s difficult to distinguish between new dimension records and dimension records that have been
			  updated. As such, the UpdatedDate of a record can''t be used as the dimension record''s StartDate or EndDate with any certainty.
			  For this reason, @NewEndDate is used to set a record''s EndDate for a deactivation, as well as to set the StartDate of a new
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
		DIM.EndDate = @MaximumEndDate,					-- Make sure that the dimension record''s EndDate = ''9999-12-31'' as this dimension
														--		record has been matched to an active SRC record.
		DIM.ReasonForChange = ''Record updated in source''

WHEN NOT MATCHED BY TARGET THEN -- When a record exists in [Source/SRC] that doesn''t exist in [Target/DIM], insert it
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
		''1753-01-01 00:00:00.000'',
		@MaximumEndDate,
		SRC.SnapshotId,
		''New record in source''
	)

WHEN NOT MATCHED BY SOURCE AND  -- When a record exists in [Target/DIM] that doesn''t exist in [Source/SRC], ''end'' it
	DIM.ActivityTypeKey <> -1 AND		-- Exclude the ''UNKNOWN'' dimension record
	DIM.EndDate = @MaximumEndDate AND	-- Make sure that the dimension record hasn''t been ended already
	DIM.SnapshotId <> 0					-- Do not consider unsnapshotted (SnapshotId = 0) dimension records
THEN
	UPDATE
	SET
		DIM.EndDate = @NewEndDate,
		ReasonForChange = ''Record no longer exists in source'';


' 
END
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDPropertyFund]    Script Date: 03/08/2012 12:51:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDPropertyFund]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_IU_SCDPropertyFund]
	@DataPriorToDate DATETIME

AS

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record that has been deleted in the source needs to be ended, use this date
DECLARE @MinimumStartDate DATETIME = ''1753-01-01 00:00:00.000''
DECLARE @MaximumEndDate DATETIME = ''9999-12-31 00:00:00.000''

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
		DIM.EndDate = @MaximumEndDate AND -- Only consider active dimension records (those records that have not been ''ended'')
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
											''Record deactivated in source''
										ELSE
											''Record updated in source''
									END			

	/* ===========================================================================================================================================
		When a record exists in [Target] that doesn''t exist in [Source], ''end'' it by updating its EndDate
	   ======================================================================================================================================== */

	WHEN
		NOT MATCHED BY SOURCE AND
		DIM.SnapshotId = 0 AND
		DIM.PropertyFundKey <> -1 AND -- Do not update the ''UNKNOWN'' record; this will not be matched in SOURCE
		DIM.EndDate = @MaximumEndDate -- Make sure that the dimension record is active, else we might continuously update the same inactive record
	THEN
		UPDATE
		SET
			DIM.EndDate = @NewEndDate,
			ReasonForChange = ''Record deleted in source''

	/* ===========================================================================================================================================
		When a record exists in [Source] that doesn''t exist in [Target], insert it
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
				WHEN -- If this record (identified by its primary key) doesn''t exist in the dimension (regardless of its StartDate and EndDate)
					0 = (	SELECT
								COUNT(*)
							FROM
								GrReporting.dbo.PropertyFund
							WHERE
								SnapshotId = 0 AND
								PropertyFundId = SRC.PropertyFundId
						)
				THEN -- Then it must be a new record
					''New record in source''
				ELSE -- Else the source record must have been reactivated and/or updated
					''Record reactivated in source''
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
						warehouse will have UNKNOWN property funds because there wasn''t a corresponding active record in the dimension at the
						time that the transaction was entered.
					
						PropertyFundKey PropertyFundId	PropertyFundName	PropertyFundType	StartDate	EndDate
						1				2546			Stafford Place I	Property			1753-01-01	2010-04-03
						2				2546			Stafford Place I	Property			2011-02-03	9999-12-31

					To resolve this, the StartDate of the new record must be set to 10 milliseconds after the date that the record was
						originally deactivated (the first record''s EndDate).
			
				To achieve this:
			
					First, try and find the maximum EndDate in the dimension for the source record that is to be inserted.

						IF/[ISNULL]
							A version of this record already exists is the dimension (it cannot be active because we are in the NOT MATCHED BY
								TARGET clause)

						THEN/[DATEADD(ms, 10, (SELECT MAX(EndDate) FROM GrReporting.dbo.PropertyFund WHERE PropertyFundIdId = SRC.PropertyFundIdId))]
							Find the maximum EndDate (i.e.: The EndDate of the record that was last active), and add 10 milliseconds to it.
							This will be the StartDate of the new record that is to be inserted into the dimension

						ELSE/[''1753-01-01'']
							This source record has never existed in the dimension - we know this because the first statement within the ISNULL
								returned as a NULL value.
							As such, this is the first time that this record from the source is being inserted into the warehouse, so set its
								StartDate to ''1753-01-01''																					*/
		)

	-----------

	OUTPUT
		SRC.PropertyFundId,
		SRC.PropertyFundName,
		SRC.PropertyFundType,
		SRC.SnapshotId,
		SRC.IsActive,
		''Record updated in source'' AS ReasonForChange,
		DATEADD(ms, 10, SRC.UpdatedDate) AS UpdatedDate,
		$Action AS MergeAction

) AS MergedData
WHERE
	MergedData.MergeAction = ''UPDATE'' AND  -- Important: Only insert a new record into the dimension if the merge triggered an update.
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

' 
END
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDOriginatingRegion]    Script Date: 03/08/2012 12:51:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDOriginatingRegion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_IU_SCDOriginatingRegion]
	@DataPriorToDate DATETIME

AS

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record that has been deleted in the source needs to be ended, use this date
DECLARE @MinimumStartDate DATETIME = ''1753-01-01 00:00:00.000''
DECLARE @MaximumEndDate DATETIME = ''9999-12-31 00:00:00.000''

CREATE TABLE #OriginatingRegion
(
	GlobalRegionId INT NOT NULL,
	RegionCode NVARCHAR(10) NOT NULL,
	RegionName NVARCHAR(50) NOT NULL,
	SubRegionCode NVARCHAR(10) NOT NULL,
	SubRegionName NVARCHAR(50) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL,
	SnapshotId INT NOT NULL,
	ReasonForChange NVARCHAR(1024) NULL
)
INSERT INTO #OriginatingRegion
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
		dbo.OriginatingRegion DIM
	USING
	(
		SELECT
			GlobalRegionId,
			RegionCode,
			RegionName,
			ISNULL(SubRegionCode, ''N/A'') AS SubRegionCode,
			ISNULL(SubRegionName, ''Not Applicable'') AS SubRegionName,
			InsertedDate,
			UpdatedDate,
			IsActive,
			0 AS SnapshotId
		FROM
			GrReportingStaging.Gr.GetGlobalRegionExpanded(@DataPriorToDate)
		WHERE
			IsOriginatingRegion = 1

	) AS SRC ON
		SRC.GlobalRegionId = DIM.GlobalRegionId AND
		DIM.EndDate = @MaximumEndDate AND -- Only consider active dimension records (those records that have not been ''ended'')
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
											''Record deactivated in source''
										ELSE
											''Record updated in source''
									END	

	/* ===========================================================================================================================================
		When a record exists in [Target] that doesn''t exist in [Source], ''end'' it by updating its EndDate
	   ======================================================================================================================================== */

	WHEN
		NOT MATCHED BY SOURCE AND
		DIM.SnapshotId = 0 AND
		DIM.OriginatingRegionKey <> -1 AND -- Do not update the ''UNKNOWN'' record; this will not be matched in SOURCE
		DIM.EndDate = @MaximumEndDate -- Make sure that the dimension record is active, else we might continuously update the same inactive record
	THEN
		UPDATE
		SET
			DIM.EndDate = @NewEndDate,
			ReasonForChange = ''Record deleted in source''			

	/* ===========================================================================================================================================
		When a record exists in [Source] that doesn''t exist in [Target], insert it
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
				WHEN -- If this record (identified by its primary key) doesn''t exist in the dimension (regardless of its StartDate and EndDate)
					0 = (	SELECT
								COUNT(*)
							FROM
								GrReporting.dbo.OriginatingRegion
							WHERE
								SnapshotId = 0 AND
								GlobalRegionId = SRC.GlobalRegionId
						)
				THEN -- Then it must be a new record
					''New record in source''
				ELSE -- Else the source record must have been reactivated and/or updated
					''Record reactivated in source''
			END,
			ISNULL(DATEADD(ms, 10, (SELECT
										MAX(EndDate)
									FROM
										GrReporting.dbo.OriginatingRegion
									WHERE
										SnapshotId = 0 AND
										GlobalRegionId = SRC.GlobalRegionId)), @MinimumStartDate)
		)

	--------------------

	OUTPUT
		SRC.GlobalRegionId,
		SRC.RegionCode,
		SRC.RegionName,
		SRC.SubRegionCode,
		SRC.SubRegionName,
		SRC.IsActive,
		SRC.SnapshotId,
		''Record updated in source'' AS ReasonForChange,
		DATEADD(ms, 10, SRC.UpdatedDate) AS UpdatedDate,
		$Action AS MergeAction

) AS MergedData
WHERE
	MergedData.MergeAction = ''UPDATE'' AND -- Important: Only insert a new record into the dimension if the merge triggered an update.
	MergedData.IsActive = 1				  /* An update can either be triggered by the field of a source record being updated, or a source record
												being deactivated. Make sure that we only insert records associated with updates caused by the
												former, where a new dimension record to reflect these changes is required. */

/* ===============================================================================================================================================
	There is a bug in SQL Server 2008 that prevents the use of the MERGE statement when the table that is being merged to is referenced by
		other tables using FKs. [http://connect.microsoft.com/SQLServer/feedback/details/435031/]
	A work-around is to insert the result of the merge into a temp table, and to then insert data from this temp table into the dimension/[TARGET].
   ============================================================================================================================================ */

INSERT INTO dbo.OriginatingRegion
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
	OriginatingRegion.GlobalRegionId,
	OriginatingRegion.RegionCode,
	OriginatingRegion.RegionName,
	OriginatingRegion.SubRegionCode,
	OriginatingRegion.SubRegionName,
	DATEADD(MS, 10, (SELECT MAX(EndDate) FROM GrReporting.dbo.OriginatingRegion DIM WHERE DIM.GlobalRegionId = OriginatingRegion.GlobalRegionId AND DIM.SnapshotId = OriginatingRegion.SnapshotId)) AS StartDate,
	OriginatingRegion.EndDate,
	OriginatingRegion.SnapshotId,
	OriginatingRegion.ReasonForChange
FROM
	#OriginatingRegion OriginatingRegion

' 
END
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDGLCategorizationHierarchy]    Script Date: 03/08/2012 12:51:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDGLCategorizationHierarchy]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_IU_SCDGLCategorizationHierarchy]
	@DataPriorToDate DATETIME

AS

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record that has been deleted in the source needs to be ended, use this date
DECLARE @MinimumStartDate DATETIME = ''1753-01-01 00:00:00.000''
DECLARE @MaximumEndDate DATETIME = ''9999-12-31 00:00:00.000''

CREATE TABLE #GLCategorizationHierarchy
(
	GLCategorizationHierarchyCode VARCHAR(50) NOT NULL,
	GLCategorizationTypeName VARCHAR(50) NOT NULL,
	GLCategorizationName VARCHAR(50) NOT NULL,
	GLFinancialCategoryName VARCHAR(50) NOT NULL,
	GLMajorCategoryName VARCHAR(400) NOT NULL,
	GLMinorCategoryName VARCHAR(400) NOT NULL,
	GLAccountName VARCHAR(150) NOT NULL,
	GLAccountCode VARCHAR(10) NOT NULL,
	InflowOutflow VARCHAR(7) NOT NULL,
	SnapshotId INT NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL,
	ReasonForChange NVARCHAR(1024) NULL
)
INSERT INTO #GLCategorizationHierarchy
(
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
	0 AS SnapshotId,
	UpdatedDate AS StartDate,
	@MaximumEndDate AS EndDate,
	ReasonForChange
FROM
(
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
			0 AS SnapshotId,
			IsActive,
			InsertedDate,
			UpdatedDate
		FROM
			GrReportingStaging.Gr.GetGLCategorizationHierarchyExpanded(@DataPriorToDate)

	) AS SRC ON
		SRC.GLCategorizationHierarchyCode = DIM.GLCategorizationHierarchyCode AND
		DIM.EndDate = @MaximumEndDate AND -- Only consider active dimension records (those records that have not been ''ended'')
		SRC.SnapshotId = DIM.SnapshotId AND
		DIM.SnapshotId = 0 -- hardcode 0 as this stored procedure handles only LIVE GDM data, not snapshotted data

	/* ===========================================================================================================================================
		When a record exists in [Target] and [Source] and is active in [TARGET] but has been updated/deactivated in [SOURCE], end the record in
			the dimension.	
	   ======================================================================================================================================== */

	WHEN
		MATCHED AND
		(	-- If a field has been updated or the record has been deactivated in the source
			DIM.GLCategorizationTypeName <> SRC.GLCategorizationTypeName OR
			DIM.GLCategorizationName <> SRC.GLCategorizationName OR
			DIM.GLFinancialCategoryName <> SRC.GLFinancialCategoryName OR
			DIM.GLMajorCategoryName <> SRC.GLMajorCategoryName OR
			DIM.GLMinorCategoryName <> SRC.GLMinorCategoryName OR
			DIM.GLAccountName <> SRC.GLGlobalAccountName OR
			DIM.GLAccountCode <> SRC.GLGlobalAccountCode OR
			DIM.InflowOutflow <> SRC.InflowOutflow OR
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
											''Record deactivated in source''
										ELSE
											''Record updated in source''
									END

	/* ===========================================================================================================================================
		When a record exists in [Target] that doesn''t exist in [Source], ''end'' it by updating its EndDate
	   ======================================================================================================================================== */

	WHEN
		NOT MATCHED BY SOURCE AND
		DIM.SnapshotId = 0 AND
		DIM.GLCategorizationHierarchyKey > 0 AND  -- Do not update the ''UNKNOWN'' record; this will not be matched in SOURCE
		DIM.EndDate = @MaximumEndDate -- Make sure that the dimension record is active, else we might continuously update the same inactive record
	THEN
		UPDATE
		SET
			DIM.EndDate = @NewEndDate,
			ReasonForChange = ''Record deleted in source''

	/* ===========================================================================================================================================
		When a record exists in [Source] that doesn''t exist in [Target], insert it
	   ======================================================================================================================================== */

	WHEN
		NOT MATCHED BY TARGET AND
		SRC.IsActive = 1
	THEN
		INSERT
		(
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
			EndDate,
			ReasonForChange,
			StartDate
		)
		VALUES
		(
			SRC.GLCategorizationHierarchyCode,
			SRC.GLCategorizationTypeName,
			SRC.GLCategorizationName,
			SRC.GLFinancialCategoryName,
			SRC.GLMajorCategoryName,
			SRC.GLMinorCategoryName,
			SRC.GLGlobalAccountName,
			SRC.GLGlobalAccountCode,
			SRC.InflowOutflow,
			0,
			@MaximumEndDate,
			CASE
				WHEN -- If this record (identified by its primary key) doesn''t exist in the dimension (regardless of its StartDate and EndDate)
					0 = (	SELECT
								COUNT(*)
							FROM
								GrReporting.dbo.GLCategorizationHierarchy
							WHERE
								SnapshotId = 0 AND
								GLCategorizationHierarchyCode = SRC.GLCategorizationHierarchyCode
						)
				THEN -- Then it must be a new record
					''New record in source''
				ELSE -- Else the source record must have been reactivated and/or updated
					''Record reactivated in source''
			END,
			ISNULL(DATEADD(ms, 10, (SELECT
										MAX(EndDate)
									FROM
										GrReporting.dbo.GLCategorizationHierarchy
									WHERE
										SnapshotId = 0 AND
										GLCategorizationHierarchyCode = SRC.GLCategorizationHierarchyCode)), @MinimumStartDate)
		)

	----------

	OUTPUT
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
		SRC.IsActive,
		@NewEndDate AS UpdatedDate,
		''Record updated in source'' AS ReasonForChange,
		$Action AS MergeAction
) AS MergedData
WHERE
	MergedData.MergeAction = ''UPDATE'' AND  -- Important: Only insert a new record into the dimension if the merge triggered an update.
	MergedData.IsActive = 1				   /* An update can either be triggered by the field of a source record being updated, or a source record
													being deactivated. Make sure that we only insert records associated with updates caused by the
													former, where a new dimension record to reflect these changes is required. */

/* ===============================================================================================================================================
	There is a bug in SQL Server 2008 that prevents the use of the MERGE statement when the table that is being merged to is referenced by
		other tables using FKs. [http://connect.microsoft.com/SQLServer/feedback/details/435031/]
	A work-around is to insert the result of the merge into a temp table, and to then insert data from this temp table into the dimension/[TARGET].
   ============================================================================================================================================ */
	
INSERT INTO dbo.GLCategorizationHierarchy
(
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
SELECT
	GLCategorizationHierarchy.GLCategorizationHierarchyCode,
	GLCategorizationHierarchy.GLCategorizationTypeName,
	GLCategorizationHierarchy.GLCategorizationName,
	GLCategorizationHierarchy.GLFinancialCategoryName,
	GLCategorizationHierarchy.GLMajorCategoryName,
	GLCategorizationHierarchy.GLMinorCategoryName,
	GLCategorizationHierarchy.GLAccountName,
	GLCategorizationHierarchy.GLAccountCode,
	GLCategorizationHierarchy.InflowOutflow,
	GLCategorizationHierarchy.SnapshotId,
	DATEADD(MS, 10, (SELECT MAX(EndDate) FROM GRReporting.dbo.GLCategorizationHierarchy DIM WHERE DIM.GLCategorizationHierarchyCode = GLCategorizationHierarchy.GLCategorizationHierarchyCode AND DIM.SnapshotId = GLCategorizationHierarchy.SnapshotId)),
	GLCategorizationHierarchy.EndDate,
	GLCategorizationHierarchy.ReasonForChange
FROM
	#GLCategorizationHierarchy GLCategorizationHierarchy
	
' 
END
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDFunctionalDepartment]    Script Date: 03/08/2012 12:51:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDFunctionalDepartment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_IU_SCDFunctionalDepartment]
	@DataPriorToDate DATETIME

AS

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record that has been deleted in the source needs to be ended, use this date
DECLARE @MinimumStartDate DATETIME = ''1753-01-01 00:00:00.000''
DECLARE @MaximumEndDate DATETIME = ''9999-12-31 00:00:00.000''

CREATE TABLE #FunctionalDepartment
(
	ReferenceCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentName VARCHAR(100) NOT NULL,
	SubFunctionalDepartmentCode VARCHAR(20) NOT NULL,
	SubFunctionalDepartmentName VARCHAR(100) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL,
	ReasonForChange NVARCHAR(1024) NULL
)

INSERT INTO #FunctionalDepartment
(
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	StartDate,
	EndDate,
	ReasonForChange
)
SELECT
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	UpdatedDate AS StartDate,
	@MaximumEndDate AS EndDate,
	ReasonForChange
FROM
(
	MERGE INTO
		dbo.FunctionalDepartment DIM
	USING
	(
		SELECT
			ReferenceCode,
			FunctionalDepartmentCode,
			FunctionalDepartmentName,
			SubFunctionalDepartmentCode,
			SubFunctionalDepartmentName,
			UpdatedDate,
			IsActive
		FROM
			GrReportingStaging.Gr.GetFunctionalDepartmentExpanded(@DataPriorToDate)	
		WHERE
			IsActive = 1
			/*
				It is necessary to filter on the IsActive flag. If the source data has 2 records, 1 inactivated record, and one
				changed active record, it will join 2 source records with one destination record. This will break the MERGE 
				statement and cause an error.
			*/
	) AS SRC ON
		DIM.ReferenceCode = SRC.ReferenceCode AND -- ReferenceCodef is treated as the Functional Department PK
		DIM.EndDate = @MaximumEndDate -- Only consider active dimension records (those records that have not been ''ended'')

	/* ===========================================================================================================================================
		When a record exists in [Target] and [Source] and is active in [TARGET] but has been updated/deactivated in [SOURCE], end the record in
			the dimension.	
	   ======================================================================================================================================== */

	WHEN
		MATCHED AND
		(	-- If a field has been updated or the record has been deactivated in the source
			DIM.FunctionalDepartmentCode <> SRC.FunctionalDepartmentCode OR
			DIM.FunctionalDepartmentName <> SRC.FunctionalDepartmentName OR
			DIM.SubFunctionalDepartmentCode <> SRC.SubFunctionalDepartmentCode OR
			DIM.SubFunctionalDepartmentName <> SRC.SubFunctionalDepartmentName OR
			SRC.IsActive = 0
		)  AND
		DIM.ReferenceCode NOT IN (''LGL:'', ''LGL:UNKNOWN'', ''LGL:RSK'', ''LGL:RIM'') -- Ignore these
	THEN
		UPDATE
		SET
			DIM.EndDate = SRC.UpdatedDate,
			DIM.ReasonForChange =   CASE
										WHEN
											SRC.IsActive = 0
										THEN
											''Record deactivated in source''
										ELSE
											''Record updated in source''
									END

	/* ===========================================================================================================================================
		When a record exists in [Target] that doesn''t exist in [Source], ''end'' it by updating its EndDate
	   ======================================================================================================================================== */

	WHEN
		NOT MATCHED BY SOURCE AND
		DIM.FunctionalDepartmentKey <> -1 AND -- Do not update the ''UNKNOWN'' record; this will not be matched in SOURCE
		DIM.ReferenceCode NOT IN (''LGL:'', ''LGL:UNKNOWN'', ''LGL:RSK'', ''LGL:RIM'') AND
		DIM.EndDate = @MaximumEndDate -- Make sure that the dimension record is active, else we might continuously update the same inactive record
	THEN
		UPDATE
		SET
			DIM.EndDate = @NewEndDate,
			ReasonForChange = ''Record deleted in source''

	/* ===========================================================================================================================================
		When a record exists in [Source] that doesn''t exist in [Target], insert it
	   ======================================================================================================================================== */

	WHEN
		NOT MATCHED BY TARGET
	THEN
		INSERT
		(
			ReferenceCode,
			FunctionalDepartmentCode,
			FunctionalDepartmentName,
			SubFunctionalDepartmentCode,
			SubFunctionalDepartmentName,
			EndDate,
			ReasonForChange,
			StartDate
		)
		VALUES
		(
			SRC.ReferenceCode,
			SRC.FunctionalDepartmentCode,
			SRC.FunctionalDepartmentName,
			SRC.SubFunctionalDepartmentCode,
			SRC.SubFunctionalDepartmentName,
			@MaximumEndDate,
			CASE
				WHEN -- If this record (identified by its primary key) doesn''t exist in the dimension (regardless of its StartDate and EndDate)
					0 = (	SELECT
								COUNT(*)
							FROM
								GrReporting.dbo.FunctionalDepartment
							WHERE
								ReferenceCode = SRC.ReferenceCode
						)
				THEN -- Then it must be a new record
					''New record in source''
				ELSE -- Else the source record must have been reactivated and/or updated
					''Record reactivated in source''
			END,
			ISNULL(DATEADD(ms, 10, (SELECT
										MAX(EndDate)
									FROM
										GrReporting.dbo.FunctionalDepartment
									WHERE
										ReferenceCode = SRC.ReferenceCode)), @MinimumStartDate)
		)

	--------

	OUTPUT -- Dimension
		SRC.ReferenceCode,
		SRC.FunctionalDepartmentCode,
		SRC.FunctionalDepartmentName,
		SRC.SubFunctionalDepartmentCode,
		SRC.SubFunctionalDepartmentName,
		SRC.IsActive,
		''Record updated in source'' AS ReasonForChange,
		@NewEndDate AS UpdatedDate, -- DATEADD(ms, 10, SRC.UpdatedDate) AS UpdatedDate,
		$Action AS MergeAction

) AS MergedData
WHERE
	MergedData.MergeAction = ''UPDATE'' AND -- Important: Only insert a new record into the dimension if the merge triggered an update.
	MergedData.IsActive = 1				  /* An update can either be triggered by the field of a source record being updated, or a source record
												being deactivated. Make sure that we only insert records associated with updates caused by the
												former, where a new dimension record to reflect these changes is required. */

/* ===============================================================================================================================================
	There is a bug in SQL Server 2008 that prevents the use of the MERGE statement when the table that is being merged to is referenced by
		other tables using FKs. [http://connect.microsoft.com/SQLServer/feedback/details/435031/]
	A work-around is to insert the result of the merge into a temp table, and to then insert data from this temp table into the dimension/[TARGET].
   ============================================================================================================================================ */

INSERT INTO dbo.FunctionalDepartment
(
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	StartDate,
	EndDate,
	ReasonForChange
)
SELECT
	Updated.ReferenceCode,
	Updated.FunctionalDepartmentCode,
	Updated.FunctionalDepartmentName,
	Updated.SubFunctionalDepartmentCode,
	Updated.SubFunctionalDepartmentName,
	DATEADD(MS, 10, (SELECT MAX(EndDate) FROM GrReporting.dbo.FunctionalDepartment DIM WHERE DIM.ReferenceCode = Updated.ReferenceCode)) AS StartDate,
	Updated.EndDate,
	Updated.ReasonForChange
FROM
	#FunctionalDepartment Updated

-- Make sure that ''Legal, Risk & Records'' is shown as having been deactivated at the end of 2010

UPDATE
	dbo.FunctionalDepartment
SET
	EndDate = ''2010-12-31 23:59:59.000''
WHERE
	FunctionalDepartmentName = ''Legal, Risk & Records''

' 
END
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDAllocationRegion]    Script Date: 03/08/2012 12:51:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDAllocationRegion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_IU_SCDAllocationRegion]
	@DataPriorToDate DATETIME

AS

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record that has been deleted in the source needs to be ended, use this date
DECLARE @MinimumStartDate DATETIME = ''1753-01-01 00:00:00.000''
DECLARE @MaximumEndDate DATETIME = ''9999-12-31 00:00:00.000''

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
			ISNULL(SubRegionCode, ''N/A'') AS SubRegionCode,
			ISNULL(SubRegionName, ''Not Applicable'') AS SubRegionName,
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
		DIM.EndDate = @MaximumEndDate AND -- Only consider active dimension records (those records that have not been ''ended'')
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
											''Record deactivated in source''
										ELSE
											''Record updated in source''
									END			

	/* ===========================================================================================================================================
		When a record exists in [Target] that doesn''t exist in [Source], ''end'' it by updating its EndDate
	   ======================================================================================================================================== */

	WHEN
		NOT MATCHED BY SOURCE AND
		DIM.SnapshotId = 0 AND
		DIM.AllocationRegionKey <> -1 AND -- Do not update the ''UNKNOWN'' record; this will not be matched in SOURCE
		DIM.EndDate = @MaximumEndDate -- Make sure that the dimension record is active, else we might continuously update the same inactive record
	THEN
		UPDATE
		SET
			DIM.EndDate = @NewEndDate,
			ReasonForChange = ''Record deleted in source''

	/* ===========================================================================================================================================
		When a record exists in [Source] that doesn''t exist in [Target], insert it
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
				WHEN -- If this record (identified by its primary key) doesn''t exist in the dimension (regardless of its StartDate and EndDate)
					0 = (	SELECT
								COUNT(*)
							FROM
								GrReporting.dbo.AllocationRegion
							WHERE
								SnapshotId = 0 AND
								GlobalRegionId = SRC.GlobalRegionId)
				THEN -- Then it must be a new record
					''New record in source''
				ELSE -- Else the source record must have been reactivated and/or updated
					''Record reactivated in source''
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
		''Record updated in source'' AS ReasonForChange,
		DATEADD(ms, 10, SRC.UpdatedDate) AS UpdatedDate,
		$Action AS MergeAction

) AS MergedData
WHERE
	MergedData.MergeAction = ''UPDATE'' AND -- Important: Only insert a new record into the dimension if the merge triggered an update.
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

' 
END
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDActivityType]    Script Date: 03/08/2012 12:51:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDActivityType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_IU_SCDActivityType]
	@DataPriorToDate DATETIME

AS

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record that has been deleted in the source needs to be ended, use this date
DECLARE @MinimumStartDate DATETIME = ''1753-01-01 00:00:00.000''
DECLARE @MaximumEndDate DATETIME = ''9999-12-31 00:00:00.000''

/* IMPORTANT: There is no single business key that we can use to match dimension records with source records: we match using ActivityTypeId and
			  BusinessLineId. For this reason it''s difficult to distinguish between new dimension records and dimension records that have been
			  updated. As such, the UpdatedDate of a record can''t be used as the dimension record''s StartDate or EndDate with any certainty.
			  For this reason, @NewEndDate is used to set a record''s EndDate for a deactivation, as well as to set the StartDate of a new
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
		DIM.EndDate = @MaximumEndDate AND -- Only consider active dimension records (those records that have not been ''ended'')
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
											''Record deactivated in source''
										ELSE
											''Record updated in source''
									END

	/* ===========================================================================================================================================
		When a record exists in [Target] that doesn''t exist in [Source], ''end'' it by updating its EndDate
	   ======================================================================================================================================== */

	WHEN
		NOT MATCHED BY SOURCE AND -- When a record exists in [Target] that doesn''t exist in [Source], ''end'' it
		DIM.SnapshotId = 0 AND
		DIM.ActivityTypeKey <> -1 AND -- Do not update the ''UNKNOWN'' record; this will not be matched in SOURCE
		DIM.EndDate = @MaximumEndDate -- Make sure that the dimension record is active, else we might continuously update the same inactive record
	THEN
		UPDATE
		SET
			DIM.EndDate = @NewEndDate,
			ReasonForChange = ''Record deleted in source''

	/* ===========================================================================================================================================
		When a record exists in [Source] that doesn''t exist in [Target], insert it
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
				WHEN -- If this record (identified by its primary key) doesn''t exist in the dimension (regardless of its StartDate and EndDate)
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
					''New record in source''
				ELSE -- Else the source record must have been reactivated and/or updated
					''Record reactivated in source''
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
						warehouse will have UNKNOWN activity types because there wasn''t a corresponding active record in the dimension at the
						time that the transaction was entered.
					
						ActivityTypeKey ActivityTypeId	BusinessLineId		...		StartDate	EndDate
						1				99				6					...		1753-01-01	2010-04-03
						2				99				6					...		2011-02-03	9999-12-31

					To resolve this, the StartDate of the new record must be set to 10 milliseconds after the date that the record was
						originally deactivated (the first record''s EndDate).
			
				To achieve this:
			
					First, try and find the maximum EndDate in the dimension for the source record that is to be inserted.

						IF/[ISNULL]
							A version of this record already exists is the dimension (it cannot be active because we are in the NOT MATCHED BY
								TARGET clause)

						THEN/[DATEADD(ms, 10, (SELECT MAX(EndDate) FROM GrReporting.dbo.ActivityType WHERE ....))]
							Find the maximum EndDate (i.e.: The EndDate of the record that was last active), and add 10 milliseconds to it.
							This will be the StartDate of the new record that is to be inserted into the dimension

						ELSE/[''1753-01-01'']
							This source record has never existed in the dimension - we know this because the first statement within the ISNULL
								returned as a NULL value.
							As such, this is the first time that this record from the source is being inserted into the warehouse, so set its
								StartDate to ''1753-01-01''																					*/
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
		''Record updated in source'' AS ReasonForChange,
		$Action AS MergeAction

) AS MergedData
WHERE
	MergedData.MergeAction = ''UPDATE'' AND -- Important: Only insert a new record into the dimension if the merge triggered an update
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

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ValidReportingEntityActivityTypeCombinations]    Script Date: 03/08/2012 12:51:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ValidReportingEntityActivityTypeCombinations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_R_ValidReportingEntityActivityTypeCombinations]
@BudgetAllocationSetId INT
AS

/*********************************************************************************************************************
Description
	This report generates a list of all valid Reporting Entity - Activity Type Combinations
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
			2012-03-05		: SNothling	:	CC21 - Create script
**********************************************************************************************************************/

BEGIN

	CREATE TABLE #HolisticReviewExportTemp
	(	
		ProjectCode VARCHAR(20) NULL,
		ProjectName VARCHAR(100) NULL,
		ProjectEndPeriod INT NULL,
		ActivityType VARCHAR(50) NULL,
		PropertyFund VARCHAR(100) NULL,
		RelatedFund VARCHAR(100) NULL,
		PropertyFundAllocationSubRegionName VARCHAR(50) NULL,
		Source CHAR(2) NULL,
		AllocationType VARCHAR(100) NULL,
		CorporateDepartment CHAR(8) NULL,
		CorporateDepartmentDescription VARCHAR(50) NULL,
		ReportingEntity VARCHAR(100) NULL,
		ReportingEntityAllocationSubRegionName varchar(50) NULL,
		EntityType VARCHAR(50) NULL,
		BudgetOwner VARCHAR(255) NULL,
		RegionalOwner VARCHAR(255) NULL,
		BudgetCoordinatorDisplayNames nvarchar(MAX) NULL,
		IsTSCost VARCHAR(3) NULL,
		PropertyEntity CHAR(6) NULL,
		PropertyEntityName NVARCHAR(264) NULL
	)

	SET XACT_ABORT ON

	-- Get actuals
	INSERT INTO #HolisticReviewExportTemp
	EXEC SERVER3.GDM.dbo.HolisticReviewExport

	-- Get budget
	INSERT INTO #HolisticReviewExportTemp
	EXEC SERVER3.GDM.dbo.HolisticReviewExport @BudgetAllocationSetId=@BudgetAllocationSetId

	-- Get a distinct list of valid combinations of
	--	activity type
	--	allocation type
	--	reporting entity
	-- as projects have been set up in AM
	SELECT DISTINCT 
		ValidEntityActivityTypeCombinations.ActivityType ActivityTypeName,
		ValidEntityActivityTypeCombinations.AllocationType AllocationTypeName,
		ValidEntityActivityTypeCombinations.ReportingEntity ReportingEntityName
	INTO #ValidActivityTypeEntity
	FROM 
		#HolisticReviewExportTemp ValidEntityActivityTypeCombinations
		
	-- IMS 56718: Martin has specified additional entries that are also
	-- valid, even though they have no projects in AM
	INSERT INTO #ValidActivityTypeEntity
	SELECT 
		AdditionalMappings.ActivityTypeName, 
		AdditionalMappings.AllocationTypeName,
		AdditionalMappings.ReportingEntityName
	FROM 
		dbo.AdditionalValidCombinationsForEntityActivity AdditionalMappings
		LEFT OUTER JOIN #ValidActivityTypeEntity AMMappings ON 
			 AdditionalMappings.ReportingEntityName = AMMappings.ReportingEntityName AND
			 AdditionalMappings.ActivityTypeName = AMMappings.ActivityTypeName AND
			 AdditionalMappings.AllocationTypeName = AMMappings.AllocationTypeName
	WHERE 
		AMMappings.AllocationTypeName IS NULL
		
	SELECT * FROM #ValidActivityTypeEntity



END' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ValidFunctionalDepartmentOriginatingRegionCombinations]    Script Date: 03/08/2012 12:51:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ValidFunctionalDepartmentOriginatingRegionCombinations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_R_ValidFunctionalDepartmentOriginatingRegionCombinations]
@SnapshotId INT
AS

/*********************************************************************************************************************
Description
	This report generates a list of all valid Originating Region - Functional Department Mappings
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
			2012-01-27		: SNothling	:	CC21 - Create script
**********************************************************************************************************************/

/* ================================================================================================================
	STEP 0: CROSS JOIN TO GET ALL ORIGINATING REGION - FUNCTIONAL DEPARTMENT COMBINATIONS
=================================================================================================================*/

BEGIN
SELECT DISTINCT
	GR.Code,
	GR.Name
INTO
	#OriginatingRegions	
FROM 
	GrReportingStaging.GDM.SnapshotOriginatingRegionCorporateEntity ORCE
	INNER JOIN GrReportingStaging.GDM.GlobalRegion GR ON
		ORCE.GlobalRegionId = GR.GlobalRegionId
WHERE 
	SnapshotId = @SnapshotId

				
SELECT
	FD.GlobalCode,
	FD.Name
INTO 
	#FunctionalDepartments
FROM	
	GrReportingStaging.HR.FunctionalDepartment FD
WHERE 
	FD.IsActive = 1 AND
    FD.GlobalCode IS NOT NULL AND
    FD.Code <> ''TESTING''
    
SELECT
	FD.GlobalCode AS ''FunctionalDepartmentCode'',
	ORS.Code AS ''OriginatingRegionCode''
INTO 
	#OriginatingRegionFunctionalDepartments
FROM 
	#OriginatingRegions ORS
	CROSS JOIN #FunctionalDepartments FD
	
END 
    
/* ================================================================================================================
	STEP 1: REMOVE ALL INVALID COMBINATIONS
=================================================================================================================*/
BEGIN

DELETE ORFD
FROM #OriginatingRegionFunctionalDepartments ORFD
	INNER JOIN #OriginatingRegions ON
		ORFD.OriginatingRegionCode = #OriginatingRegions.Code
	INNER JOIN #FunctionalDepartments ON
		ORFD.FunctionalDepartmentCode = #FunctionalDepartments.GlobalCode
	LEFT OUTER JOIN (
		-- get a list of functional for which all the corporate entities is restricted in a global region
		-- the global region - functional department combination is then restricted
		SELECT
			FunctionalDepartmentGlobalRegionCount.FunctionalDepartmentCode AS ''FunctionalDepartmentCode'',
			GlobalRegion.Code AS ''GlobalRegionCode''
		FROM (
			-- Get a count of corporate entities restricted for each functional department per originating region
			SELECT
				FunctionalDepartment.GlobalCode AS ''FunctionalDepartmentCode'',
				OriginatingRegionCorporateEntity.GlobalRegionId,
				COUNT(
					RestrictedCombinations.CorporateEntitySourceCode + 
					RestrictedCombinations.CorporateEntityCode
				) AS ''CorporateEntityRestrictionsCount''
			FROM 
				GrReportingStaging.Gdm.SnapshotRestrictedFunctionalDepartmentCorporateEntity RestrictedCombinations
			INNER JOIN GrReportingStaging.HR.FunctionalDepartment FunctionalDepartment ON
				RestrictedCombinations.FunctionalDepartmentId = FunctionalDepartment.FunctionalDepartmentId
			INNER JOIN GrReportingStaging.GDM.SnapshotOriginatingRegionCorporateEntity OriginatingRegionCorporateEntity ON
				RestrictedCombinations.CorporateEntityCode = OriginatingRegionCorporateEntity.CorporateEntityCode AND
				RestrictedCombinations.CorporateEntitySourceCode = OriginatingRegionCorporateEntity.SourceCode
			WHERE 
				FunctionalDepartment.IsActive = 1 AND
				RestrictedCombinations.SnapshotId = @SnapshotId AND
				OriginatingRegionCorporateEntity.SnapshotId = @SnapshotId
			GROUP BY 
				FunctionalDepartment.GlobalCode,
				GlobalRegionId
		) FunctionalDepartmentGlobalRegionCount
		INNER JOIN (
			-- Get a count of corporate entities per originating region
			SELECT
				GlobalRegionId,
				COUNT(OriginatingRegionCorporateEntity.SourceCode + CorporateEntityCode) AS CorporateEntitiesPerRegion
			FROM 
				GrReportingStaging.GDM.SnapshotOriginatingRegionCorporateEntity OriginatingRegionCorporateEntity
			WHERE
				OriginatingRegionCorporateEntity.SnapshotId = @SnapshotId
			GROUP BY
				GlobalRegionId
		) GlobalRegionCorporateEntityCount ON
			FunctionalDepartmentGlobalRegionCount.GlobalRegionId = GlobalRegionCorporateEntityCount.GlobalRegionId
		INNER JOIN GrReportingStaging.Gdm.GlobalRegion GlobalRegion ON
			FunctionalDepartmentGlobalRegionCount.GlobalRegionId = GlobalRegion.GlobalRegionId
		WHERE
			FunctionalDepartmentGlobalRegionCount.CorporateEntityRestrictionsCount = GlobalRegionCorporateEntityCount.CorporateEntitiesPerRegion
	) InvalidCombinations ON
		ORFD.FunctionalDepartmentCode = InvalidCombinations.FunctionalDepartmentCode AND
		ORFD.OriginatingRegionCode = InvalidCombinations.GlobalRegionCode
	LEFT OUTER JOIN dbo.AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment ON
		#OriginatingRegions.Name = AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment.OriginatingSubRegionName AND
		#FunctionalDepartments.Name = AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment.FunctionalDepartmentName
	WHERE
		InvalidCombinations.FunctionalDepartmentCode IS NOT NULL AND
		InvalidCombinations.GlobalRegionCode IS NOT NULL AND
		AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment.FunctionalDepartmentName IS NULL AND
		AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment.OriginatingSubRegionName IS NULL

END 
/* ================================================================================================================
	STEP 3: RETURN FINAL RESULTS
=================================================================================================================*/

BEGIN

SELECT
	#OriginatingRegions.Name AS ''OriginatingRegion'',
	#FunctionalDepartments.Name AS ''FunctionalDepartment''
FROM
	#OriginatingRegionFunctionalDepartments
INNER JOIN #OriginatingRegions ON
	#OriginatingRegionFunctionalDepartments.OriginatingRegionCode = #OriginatingRegions.Code
INNER JOIN #FunctionalDepartments ON
	#OriginatingRegionFunctionalDepartments.FunctionalDepartmentCode = #FunctionalDepartments.GlobalCode
	
END

IF OBJECT_ID(''tempdb..#OriginatingRegions'') IS NOT NULL
	DROP TABLE #OriginatingRegions

IF OBJECT_ID(''tempdb..#FunctionalDepartments'') IS NOT NULL
	DROP TABLE #FunctionalDepartments

IF OBJECT_ID(''tempdb..#OriginatingRegionFunctionalDepartments'') IS NOT NULL
	DROP TABLE #OriginatingRegionFunctionalDepartments





' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ValidFunctionalDepartmentGLGlobalAccountCombinations]    Script Date: 03/08/2012 12:51:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ValidFunctionalDepartmentGLGlobalAccountCombinations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


--exec stp_S_UnknownSummaryMRIActuals @BudgetYear=2010, @BudgetQuarter=''Q2'', @DataPriorToDate=''2010-12-31'', @StartPeriod=201001, @EndPeriod=201002

CREATE PROCEDURE [dbo].[stp_R_ValidFunctionalDepartmentGLGlobalAccountCombinations]
@DataPriorToDate DATETIME
AS

/*********************************************************************************************************************
Description
	This report generates a list of all valid Originating Region - Functional Department Mappings
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
			2012-01-27		: SNothling	:	CC21 - Create script
**********************************************************************************************************************/

/* ================================================================================================================
	STEP 0: CROSS JOIN TO GET ALL ORIGINATING REGION - FUNCTIONAL DEPARTMENT COMBINATIONS
=================================================================================================================*/
BEGIN
SELECT
	GA.Code,
	GA.Name
INTO
	#GlobalGLAccounts	
FROM 
	GrReportingStaging.GDM.GLGlobalAccount GA
WHERE GA.IsActive = 1
			
SELECT
	FD.GlobalCode,
	FD.Name
INTO 
	#FunctionalDepartments
FROM	
	GrReportingStaging.HR.FunctionalDepartment FD
WHERE 
	FD.IsActive = 1 AND
    FD.GlobalCode IS NOT NULL AND
    FD.Code <> ''TESTING''
    
SELECT
	FD.GlobalCode AS ''FunctionalDepartmentCode'',
	GA.Code AS ''GLGLobalAccountCode''
INTO 
	#GlobalGLAccountFunctionalDepartment
FROM 
	#FunctionalDepartments FD
	CROSS JOIN #GlobalGLAccounts GA
	
	
END 
    
/* ================================================================================================================
	STEP 1: REMOVE ALL INVALID COMBINATIONS
=================================================================================================================*/
BEGIN

DELETE GAFD
FROM #GlobalGLAccountFunctionalDepartment GAFD
	INNER JOIN (
			SELECT 
				GLGlobalAccount.Code AS ''GLGlobalAccountCode'',
				FunctionalDepartment.GlobalCode AS ''FunctionalDepartmentGlobalCode''
			FROM GrReportingStaging.GDM.RestrictedFunctionalDepartmentGLGlobalAccount
			INNER JOIN GrReportingStaging.GDM.RestrictedFunctionalDepartmentGLGlobalAccountActive(''2012-01-31'') ActiveRestrictedFunctionalDepartmentGlGlobalAccount ON
				RestrictedFunctionalDepartmentGLGlobalAccount.ImportKey = ActiveRestrictedFunctionalDepartmentGlGlobalAccount.ImportKey
			LEFT OUTER JOIN GrReportingStaging.HR.FunctionalDepartment FunctionalDepartment ON
				RestrictedFunctionalDepartmentGLGlobalAccount.FunctionalDepartmentId = FunctionalDepartment.FunctionalDepartmentId
			LEFT OUTER JOIN GrReportingStaging.HR.FunctionalDepartmentActive(''2012-01-31'') FunctionalDepartmentActive ON
				FunctionalDepartment.ImportKey = FunctionalDepartmentActive.ImportKey
			INNER JOIN GrReportingStaging.GDM.GLGlobalAccount ON
				RestrictedFunctionalDepartmentGLGlobalAccount.GLGlobalAccountId = GLGlobalAccount.GLGlobalAccountId
			INNER JOIN GrReportingStaging.GDM.GLGlobalAccountActive(''2012-01-31'') GLGlobalAccountActive ON
				GLGlobalAccount.ImportKey = GLGlobalAccountActive.ImportKey
	) InvalidCombinations ON
		GAFD.FunctionalDepartmentCode = 
		CASE
			WHEN InvalidCombinations.FunctionalDepartmentGlobalCode IS NULL THEN GAFD.FunctionalDepartmentCode
			ELSE InvalidCombinations.FunctionalDepartmentGlobalCode
		END	AND
		GAFD.GLGLobalAccountCode = InvalidCombinations.GLGlobalAccountCode

END 
/* ================================================================================================================
	STEP 3: RETURN FINAL RESULTS
=================================================================================================================*/

BEGIN

SELECT 
	#GlobalGLAccounts.Code AS ''GLGLobalAccountCode'',
	#GlobalGLAccounts.Name AS ''GLGLobalAccountName'',
	#FunctionalDepartments.Name AS ''FunctionalDepartment'',
	#FunctionalDepartments.GlobalCode
FROM
	#GlobalGLAccountFunctionalDepartment GAFD
	INNER JOIN #GlobalGLAccounts ON
		GAFD.GLGLobalAccountCode = #GlobalGLAccounts.Code
	INNER JOIN #FunctionalDepartments ON
		GAFD.FunctionalDepartmentCode = #FunctionalDepartments.GlobalCode
	
END

IF OBJECT_ID(''tempdb..#GlobalGLAccounts'') IS NOT NULL
	DROP TABLE #GlobalGLAccounts

IF OBJECT_ID(''tempdb..#FunctionalDepartments'') IS NOT NULL
	DROP TABLE #FunctionalDepartments

IF OBJECT_ID(''tempdb..#GlobalGLAccountFunctionalDepartment'') IS NOT NULL
	DROP TABLE #GlobalGLAccountFunctionalDepartment




' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_S_ValidNonPayrollRegionAndFunctionalDepartment]    Script Date: 03/08/2012 12:51:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_S_ValidNonPayrollRegionAndFunctionalDepartment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_S_ValidNonPayrollRegionAndFunctionalDepartment]
@BudgetYear int,
@BudgetQuater	Varchar(2),
@DataPriorToDate DateTime
AS

DECLARE @BudgetQuarterNumber INT
SET @BudgetQuarterNumber = CAST(SUBSTRING(@BudgetQuater, 2, 1) AS INT) + 1

CREATE TABLE #FunctionalDepartment(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	Code VARCHAR(20) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	GlobalCode CHAR(3) NULL
)

INSERT INTO #FunctionalDepartment(
	ImportKey,
	ImportBatchId,
	ImportDate,
	FunctionalDepartmentId,
	Name,
	Code,
	IsActive,
	InsertedDate,
	UpdatedDate,
	GlobalCode
)
SELECT 
	fd.* 
FROM 
	GrReportingStaging.HR.FunctionalDepartment fd
	INNER JOIN GrReportingStaging.HR.FunctionalDepartmentActive(@DataPriorToDate) fdA ON
		fd.ImportKey = fdA.ImportKey

PRINT ''Completed inserting records into #FunctionalDepartment:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_FunctionalDepartmentId ON #FunctionalDepartment (FunctionalDepartmentId)
PRINT ''Completed creating indexes on #FunctionalDepartment''
PRINT CONVERT(Varchar(27), getdate(), 121)


Select 
		DISTINCT
		Fd.Name FunctionalDepartmentName,
		GrOr.Name OriginatingSubRegionName
From 
		Server3.GBS.dbo.NonPayrollExpenseBreakdown ExB
			INNER JOIN #FunctionalDepartment Fd ON Fd.FunctionalDepartmentId = ExB.FunctionalDepartmentId
			
			 INNER JOIN (
					SELECT 
						Gr.* 
					FROM 
						GrReportingStaging.Gdm.GlobalRegion Gr
						INNER JOIN GrReportingStaging.Gdm.GlobalRegionActive(@DataPriorToDate) GrA ON
							Gr.ImportKey = GrA.ImportKey
					) GrOr ON GrOr.GlobalRegionId = ExB.OriginatingSubRegionGlobalRegionId
					
Where BudgetID in (										
					Select BudgetId
					From 
							Server3.GBS.dbo.Budget 
					Where BudgetReportGroupPeriodID IN (
						Select 
								BudgetReportGroupPeriodID 
						From 
								Server3.GDM_GR.dbo.BudgetReportGroupPeriod 
						Where [YEAR] = @BudgetYear and Period = (Select 
																		MIN(t1.ReforecastEffectivePeriod)
																 From 
																		GrReporting.dbo.Reforecast t1
																Where ReforecastEffectiveYear = @BudgetYear
																And	ReforecastEffectiveQuarter = @BudgetQuarterNumber
																)
														)
				)
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_D_ProfitabilityReforecastIndex]    Script Date: 03/08/2012 12:51:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_D_ProfitabilityReforecastIndex]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_D_ProfitabilityReforecastIndex]
AS

IF (
		( 
			(-- If there are GBS budgets to be processed AND
				SELECT
					COUNT(*)
				FROM
					GrReportingStaging.dbo.BudgetsToProcess
				WHERE
					IsCurrentBatch = 1 AND
					IsReforecast = 1 AND
					BudgetReforecastTypeName = ''GBS Budget/Reforecast''
			) > 0 AND
			(-- The processing of GBS Budgets is permitted
				SELECT
					ConfiguredValue
				FROM
					GrReportingStaging.dbo.SSISConfigurations
				WHERE
					ConfigurationFilter = ''CanImportGBSReforecast''
			) = ''1''
		)
		OR
		(
			(-- If there are TAPAS budgets to be processed AND
				SELECT
					COUNT(*)
				FROM
					GrReportingStaging.dbo.BudgetsToProcess
				WHERE
					IsCurrentBatch = 1 AND
					IsReforecast = 1 AND
					BudgetReforecastTypeName = ''TGB Budget/Reforecast''
			) > 0 AND
			(-- The processing of TAPAS Budgets is permitted
				SELECT
					ConfiguredValue
				FROM
					GrReportingStaging.dbo.SSISConfigurations
				WHERE
					ConfigurationFilter = ''CanImportTapasReforecast''
			) = ''1''
		)
	)
BEGIN

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityReforecast'') AND NAME = N''IX_ReforecastKey'')
		DROP INDEX IX_ReforecastKey ON dbo.ProfitabilityReforecast WITH ( ONLINE = OFF )

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityReforecast'') AND NAME = N''IX_ActivityTypeKey'')
		DROP INDEX IX_ActivityTypeKey ON dbo.ProfitabilityReforecast 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityReforecast'') AND NAME = N''IX_FeeAdjustmentKey'')
		DROP INDEX IX_FeeAdjustmentKey ON dbo.ProfitabilityReforecast WITH ( ONLINE = OFF )

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityReforecast'') AND NAME = N''IX_AllocationRegionKey'')
		DROP INDEX IX_AllocationRegionKey ON dbo.ProfitabilityReforecast 

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityReforecast'') AND NAME = N''IX_CalendarKey'')
		DROP INDEX IX_CalendarKey ON dbo.ProfitabilityReforecast 

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityReforecast'') AND NAME = N''IX_FunctionalDepartmentKey'')
		DROP INDEX IX_FunctionalDepartmentKey ON dbo.ProfitabilityReforecast 

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityReforecast'') AND NAME = N''IX_GlAccountKey'')
		DROP INDEX IX_GlAccountKey ON dbo.ProfitabilityReforecast 

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityReforecast'') AND NAME = N''IX_OriginatingRegionKey'')
		DROP INDEX IX_OriginatingRegionKey ON dbo.ProfitabilityReforecast 

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityReforecast'') AND NAME = N''IX_ProfitabilityReforecast_SourceSystem'')
		DROP INDEX IX_ProfitabilityReforecast_SourceSystem ON dbo.ProfitabilityReforecast 

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityReforecast'') AND NAME = N''IX_PropertyFundKey'')
		DROP INDEX IX_PropertyFundKey ON dbo.ProfitabilityReforecast 

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityReforecast'') AND NAME = N''IX_ReforecatKey'')
		DROP INDEX IX_ReforecatKey ON dbo.ProfitabilityReforecast 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityReforecast'') AND NAME = N''IX_ProfitabilityReforecast_Budget_BudgetReforecastType'')
		DROP INDEX  IX_ProfitabilityReforecast_Budget_BudgetReforecastType ON dbo.ProfitabilityReforecast WITH ( ONLINE = OFF )

	-------------------------------------------
	--Used by loading stp and cannot be dropped
	-------------------------------------------

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityReforecast'') AND NAME = N''IX_Clustered'')
		DROP INDEX IX_Clustered ON dbo.ProfitabilityReforecast 

END

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_D_ProfitabilityBudgetIndex]    Script Date: 03/08/2012 12:51:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_D_ProfitabilityBudgetIndex]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_D_ProfitabilityBudgetIndex]
AS

IF (
		( 
			(-- If there are GBS budgets to be processed AND
				SELECT
					COUNT(*)
				FROM
					GrReportingStaging.dbo.BudgetsToProcess
				WHERE
					IsCurrentBatch = 1 AND
					IsReforecast = 0 AND
					BudgetReforecastTypeName = ''GBS Budget/Reforecast''
			) > 0 AND
			(-- The processing of GBS Budgets is permitted
				SELECT
					ConfiguredValue
				FROM
					GrReportingStaging.dbo.SSISConfigurations
				WHERE
					ConfigurationFilter = ''CanImportGBSBudget''
			) = ''1''
		)
		OR
		(
			(-- If there are TAPAS budgets to be processed AND
				SELECT
					COUNT(*)
				FROM
					GrReportingStaging.dbo.BudgetsToProcess
				WHERE
					IsCurrentBatch = 1 AND
					IsReforecast = 0 AND
					BudgetReforecastTypeName = ''TGB Budget/Reforecast''
			) > 0 AND
			(-- The processing of TAPAS Budgets is permitted
				SELECT
					ConfiguredValue
				FROM
					GrReportingStaging.dbo.SSISConfigurations
				WHERE
					ConfigurationFilter = ''CanImportTapasBudget''
			) = ''1''
		)
	)
BEGIN

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityBudget'') AND name = N''IX_ActivityTypeKey'')
		DROP INDEX IX_ActivityTypeKey ON dbo.ProfitabilityBudget 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityBudget'') AND name = N''IX_AllocationRegionKey'')
		DROP INDEX IX_AllocationRegionKey ON dbo.ProfitabilityBudget 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityBudget'') AND name = N''IX_CalendarKey'')
		DROP INDEX IX_CalendarKey ON dbo.ProfitabilityBudget 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityBudget'') AND name = N''IX_FunctionalDepartmentKey'')
		DROP INDEX IX_FunctionalDepartmentKey ON dbo.ProfitabilityBudget 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityBudget'') AND name = N''IX_GlAccountKey'')
		DROP INDEX IX_GlAccountKey ON dbo.ProfitabilityBudget 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityBudget'') AND name = N''IX_OriginatingRegionKey'')
		DROP INDEX IX_OriginatingRegionKey ON dbo.ProfitabilityBudget 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityBudget'') AND name = N''IX_ProfitabilityBudget_SourceSystemBudget'')
		DROP INDEX IX_ProfitabilityBudget_SourceSystemBudget ON dbo.ProfitabilityBudget 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityBudget'') AND name = N''IX_PropertyFundKey'')
		DROP INDEX IX_PropertyFundKey ON dbo.ProfitabilityBudget 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityBudget'') AND name = N''IX_GlobalGlAccountCategoryKey'')
		DROP INDEX IX_GlobalGlAccountCategoryKey ON dbo.ProfitabilityBudget WITH ( ONLINE = OFF )

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityBudget'') AND name = N''IX_ProfitabilityBudget_SourceSystemBudget'')
		DROP INDEX IX_ProfitabilityBudget_SourceSystemBudget ON dbo.ProfitabilityBudget WITH ( ONLINE = OFF )

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''dbo.ProfitabilityBudget'') AND name = N''IX_Clustered'')
		DROP INDEX IX_Clustered ON dbo.ProfitabilityBudget 

END

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_D_ProfitabilityActualIndex]    Script Date: 03/08/2012 12:51:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_D_ProfitabilityActualIndex]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_D_ProfitabilityActualIndex]

AS

IF
		(
			((-- The processing of MRI Actuals is permitted
				SELECT
					ConfiguredValue
				FROM
					GrReportingStaging.dbo.SSISConfigurations
				WHERE
					ConfigurationFilter = ''CanImportMRIActuals''
			) = ''1'')
			
			OR
			
			((-- The processing of MRI Actuals is permitted
				SELECT
					ConfiguredValue
				FROM
					GrReportingStaging.dbo.SSISConfigurations
				WHERE
					ConfigurationFilter = ''CanImportOverheadActuals''
			) = ''1'')
		)
BEGIN

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ProfitabilityActual]'') AND name = N''IX_ActivityTypeKey'')
DROP INDEX [IX_ActivityTypeKey] ON [dbo].[ProfitabilityActual] 

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ProfitabilityActual]'') AND name = N''IX_AllocationRegionKey'')
DROP  INDEX [IX_AllocationRegionKey] ON [dbo].[ProfitabilityActual] 

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ProfitabilityActual]'') AND name = N''IX_CalendarKey'')
DROP  INDEX [IX_CalendarKey] ON [dbo].[ProfitabilityActual] 

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ProfitabilityActual]'') AND name = N''IX_FunctionalDepartmentKey'')
DROP  INDEX [IX_FunctionalDepartmentKey] ON [dbo].[ProfitabilityActual] 

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ProfitabilityActual]'') AND name = N''IX_GlAccountKey'')
DROP  INDEX [IX_GlAccountKey] ON [dbo].[ProfitabilityActual] 

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ProfitabilityActual]'') AND name = N''IX_OriginatingRegionKey'')
DROP  INDEX [IX_OriginatingRegionKey] ON [dbo].[ProfitabilityActual] 

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ProfitabilityActual]'') AND name = N''IX_PropertyFundKey'')
DROP  INDEX [IX_PropertyFundKey] ON [dbo].[ProfitabilityActual] 

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ProfitabilityActual]'') AND name = N''IX_Clustered'')
DROP  INDEX [IX_Clustered] ON [dbo].[ProfitabilityActual] 

END
ELSE
PRINT ''Actuals not set to be imported''

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ProfitabilityDetailV2]    Script Date: 03/08/2012 12:51:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ProfitabilityDetailV2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE [dbo].[stp_R_ProfitabilityDetailV2]
	@ReportExpensePeriod INT,
	@ReforecastQuarterName VARCHAR(2), --''Q0'' or ''Q1'' or ''Q2'' or ''Q3''
	@DestinationCurrency VARCHAR(3),
	@EntityList NVARCHAR(MAX),
	@DontSensitizeMRIPayrollData BIT,
	@IncludeGrossNonPayrollExpenses BIT,
	@IncludeFeeAdjustments BIT,
	@DisplayOverheadBy NVARCHAR(MAX),
	@ConsolidationRegionList NVARCHAR(MAX),
	@OriginatingSubRegionList NVARCHAR(MAX),
	@ActivityTypeList NVARCHAR(MAX),
	@GLCategorizationName VARCHAR(50)

AS

/* =============================================================================================================================================
	Declare Variables
   =========================================================================================================================================== */
BEGIN

	DECLARE
		@ErrorSeverity                     INT = ERROR_SEVERITY(), 
		@ErrorMessage            NVARCHAR(4000),
		@_ReforecastQuarterName     VARCHAR(10) = @ReforecastQuarterName,
		@_DestinationCurrency        VARCHAR(3) = @DestinationCurrency,
		@_EntityList               VARCHAR(MAX) = @EntityList,
		@_ActivityTypeList         VARCHAR(MAX) = @ActivityTypeList,
		@_DontSensitizeMRIPayrollData       BIT = @DontSensitizeMRIPayrollData,
		@_ReportExpensePeriod               INT = @ReportExpensePeriod,
		@_AllocationSubRegionList  VARCHAR(MAX) = @ConsolidationRegionList,
		@_OriginatingSubRegionList VARCHAR(MAX) = @OriginatingSubRegionList,
		@_DisplayOverheadBy        VARCHAR(255) = @DisplayOverheadBy,
		@ReportExpensePeriodParameter       INT = @ReportExpensePeriod -- The period for which the report is being generated

	DECLARE @InflowOutflowExpense VARCHAR(20) = ''Outflow''
	DECLARE @InflowOutflowIncome  VARCHAR(20) = ''Inflow''
	DECLARE @ActiveReforecastKey          INT = (SELECT ReforecastKey FROM dbo.GetReforecastRecord(@ReportExpensePeriodParameter, @_ReforecastQuarterName))
	DECLARE @FeeAdjustmentKey             INT = (SELECT FeeAdjustmentKey From FeeAdjustment Where FeeAdjustmentCode = ''NORMAL'')

	DECLARE @CalendarYear SMALLINT = CONVERT(SMALLINT, (SUBSTRING(CAST(@_ReportExpensePeriod AS VARCHAR(10)), 1, 4)))

	-- The year for which the report is generated (the YYYY part of the report period: YYYYMM)
	DECLARE @EffectiveYear SMALLINT = CONVERT(SMALLINT, LEFT(CAST(@_ReportExpensePeriod AS VARCHAR(6)),4))

	DECLARE @Q1ReforecastKey INT = (SELECT MIN(ReforecastKey) FROM dbo.Reforecast where ReforecastQuarterName = ''Q1'' AND ReforecastEffectiveYear = @EffectiveYear)
	DECLARE @Q2ReforecastKey INT = (SELECT MIN(ReforecastKey) FROM dbo.Reforecast where ReforecastQuarterName = ''Q2'' AND ReforecastEffectiveYear = @EffectiveYear)
	DECLARE @Q3ReforecastKey INT = (SELECT MIN(ReforecastKey) FROM dbo.Reforecast where ReforecastQuarterName = ''Q3'' AND ReforecastEffectiveYear = @EffectiveYear)

	-- Get the earliest period (YYYYMM) from the dbo.Reforecast dimension for which the dbo.Reforecast.ReforecastEffectiveYear is equal to the
	--		year of the report period and the dbo.Reforecast.ReforecastQuarterName is equal to the reforecast quarter.
	DECLARE @ReforecastEffectivePeriod INT = (SELECT TOP 1 ReforecastEffectivePeriod FROM dbo.Reforecast WHERE ReforecastEffectiveYear = LEFT(CAST(@_ReportExpensePeriod AS VARCHAR(6)),4) AND ReforecastQuarterName = @_ReforecastQuarterName ORDER BY ReforecastEffectivePeriod)

	DECLARE @GrOverheadCode VARCHAR(20)
	DECLARE @GrOverheadCodeAlloc   VARCHAR(10) = ''ALLOC''
	DECLARE @GrOverheadCodeUnAlloc VARCHAR(10) = ''UNALLOC''
	DECLARE @GrOverheadCodeNA      VARCHAR(10) = ''N/A''

	DECLARE @DisplayOverheadByUnallocatedOverhead BIT = 0
	DECLARE @DisplayOverheadByAllocatedOverhead BIT = 0

	IF (@_DisplayOverheadBy = ''Allocated Overhead'') 
	BEGIN
		SET @GrOverheadCode = @GrOverheadCodeAlloc
		SET @DisplayOverheadByAllocatedOverhead = 1
	END
	ELSE IF (@_DisplayOverheadBy = ''Unallocated Overhead'')
	BEGIN
		SET @GrOverheadCode = @GrOverheadCodeUnAlloc
		SET @DisplayOverheadByUnallocatedOverhead = 1
	END
	ELSE
	BEGIN
		SET @ErrorSeverity = ERROR_SEVERITY()
		SET @ErrorMessage = ''Error in display overhead By: '' + CONVERT(VARCHAR(10), ERROR_NUMBER()) + '':'' + ERROR_MESSAGE() 	
		RAISERROR ( @ErrorMessage, @ErrorSeverity, 1)
	END

END

/* ==============================================================================================================================================
	Create filter tables based on the values of the parameters passed to this stored procedure.
   =========================================================================================================================================== */
BEGIN

	--------------------------------------------------------------------------
	-- AllocationSubRegion
	--------------------------------------------------------------------------

	CREATE TABLE #AllocationSubRegionFilterTable 
	(
		AllocationRegionKey INT NOT NULL,
		AllocationRegionName VARCHAR(MAX) NOT NULL,
		AllocationSubRegionName VARCHAR(MAX) NOT NULL
	)

	IF (@_AllocationSubRegionList IS NOT NULL)
	BEGIN

		IF (@_AllocationSubRegionList <> ''All'')
		BEGIN

			INSERT INTO #AllocationSubRegionFilterTable
			SELECT DISTINCT
				AllocationRegionLatestState.AllocationRegionKey,
				AllocationRegionLatestState.LatestAllocationRegionName,
				AllocationRegionLatestState.LatestAllocationSubRegionName
			FROM 
				dbo.Split(@_AllocationSubRegionList) AllocationSubRegionParameters
				INNER JOIN dbo.AllocationRegion ON
					AllocationRegion.SubRegionName = AllocationSubRegionParameters.item
				INNER JOIN dbo.AllocationRegionLatestState ON
					AllocationRegion.GlobalRegionId = AllocationRegionLatestState.AllocationRegionGlobalRegionId AND
					AllocationRegion.SnapshotId = AllocationRegionLatestState.AllocationRegionSnapshotId
					
		END
		ELSE IF (@_AllocationSubRegionList = ''All'')
		BEGIN

			INSERT INTO #AllocationSubRegionFilterTable
			SELECT DISTINCT
				AllocationRegionLatestState.AllocationRegionKey,
				AllocationRegionLatestState.LatestAllocationRegionName,
				AllocationRegionLatestState.LatestAllocationSubRegionName
			FROM
				dbo.AllocationRegionLatestState

		END

	END

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)

	--------------------------------------------------------------------------
	-- Overhead
	--------------------------------------------------------------------------

	CREATE TABLE #OverheadFilterTable
	(
		OverheadKey INT NOT NULL
	)

	INSERT INTO #OverheadFilterTable
	SELECT 
		OverheadKey
	FROM 
		dbo.Overhead 
	WHERE
		OverheadCode IN (@GrOverheadCode, ''N/A'')

	--------------------------------------------------------------------------
	-- ActivityType
	--------------------------------------------------------------------------

	CREATE TABLE #ActivityTypeFilterTable
	(
		ActivityTypeKey INT NOT NULL,
	)

	IF (@_ActivityTypeList IS NOT NULL)
	BEGIN

		IF (@_ActivityTypeList <> ''All'')
		BEGIN

			INSERT INTO #ActivityTypeFilterTable
			SELECT 
				ActivityType.ActivityTypeKey
			FROM 
				dbo.Split(@_ActivityTypeList) ActivityTypeParameters
				INNER JOIN dbo.ActivityType ON
					ActivityType.ActivityTypeName = ActivityTypeParameters.item

		END
		ELSE IF (@_ActivityTypeList = ''All'')
		BEGIN

			INSERT INTO #ActivityTypeFilterTable
			SELECT
				ActivityType.ActivityTypeKey
			FROM
				dbo.ActivityType

		END

	END

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable (ActivityTypeKey)

	--------------------------------------------------------------------------
	-- Entity
	--------------------------------------------------------------------------

		CREATE TABLE #EntityFilterTable	
		(
			PropertyFundKey INT NOT NULL,
			PropertyFundName VARCHAR(MAX) NOT NULL,
			PropertyFundType VARCHAR(MAX) NOT NULL
		)

		IF (@_EntityList IS NOT NULL)
		BEGIN

			IF (@_EntityList <> ''All'')
			BEGIN

				INSERT INTO #EntityFilterTable
				SELECT DISTINCT 
					PropertyFundLatestState.PropertyFundKey,
					PropertyFundLatestState.LatestPropertyFundName,
					PropertyFundLatestState.LatestPropertyFundType
				FROM 
					dbo.Split(@_EntityList) EntityListParameters
					INNER JOIN dbo.PropertyFund ON 
						PropertyFund.PropertyFundName = EntityListParameters.item
					INNER JOIN PropertyFundLatestState ON
						PropertyFund.PropertyFundId = PropertyFundLatestState.PropertyFundId AND
						PropertyFund.SnapshotId = PropertyFundLatestState.PropertyFundSnapshotId
			END
			ELSE IF (@_EntityList = ''All'')
			BEGIN

				INSERT INTO #EntityFilterTable
				SELECT DISTINCT
					PropertyFundLatestState.PropertyFundKey,
					PropertyFundLatestState.LatestPropertyFundName AS PropertyFundName,
					PropertyFundLatestState.LatestPropertyFundType AS PropertyFundType
				FROM 
					dbo.PropertyFundLatestState

			END

		END

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable (PropertyFundKey)

	--------------------------------------------------------------------------
	-- OriginatingSubRegion
	--------------------------------------------------------------------------

	CREATE TABLE #OriginatingSubRegionFilterTable 
	(
		OriginatingRegionKey INT NOT NULL,
		OriginatingRegionName VARCHAR(MAX) NOT NULL,
		OriginatingSubRegionName VARCHAR(MAX) NOT NULL
	)

	IF (@_OriginatingSubRegionList IS NOT NULL)
	BEGIN

		IF (@_OriginatingSubRegionList <> ''All'')

		BEGIN
		
			INSERT INTO #OriginatingSubRegionFilterTable
			SELECT DISTINCT
				OriginatingRegionLatestState.OriginatingRegionKey,
				OriginatingRegionLatestState.LatestOriginatingRegionName,
				OriginatingRegionLatestState.LatestOriginatingSubRegionName
			FROM 
				dbo.Split(@_OriginatingSubRegionList) OriginatingSubRegionParameters
				INNER JOIN dbo.OriginatingRegion ON 
					OriginatingRegion.SubRegionName = OriginatingSubRegionParameters.item
				INNER JOIN dbo.OriginatingRegionLatestState ON
					OriginatingRegion.GlobalRegionId = OriginatingRegionLatestState.OriginatingRegionGlobalRegionId AND
					OriginatingRegion.SnapshotId = OriginatingRegionLatestState.OriginatingRegionSnapshotId		
		END

		ELSE IF (@_OriginatingSubRegionList = ''All'')
		BEGIN

			INSERT INTO #OriginatingSubRegionFilterTable
			SELECT DISTINCT
				OriginatingRegionLatestState.OriginatingRegionKey,
				OriginatingRegionLatestState.LatestOriginatingRegionName,
				OriginatingRegionLatestState.LatestOriginatingSubRegionName
			FROM 
				dbo.OriginatingRegionLatestState
		END

	END

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable (OriginatingRegionKey)

	--------------------------------------------------------------------------
	-- ExchangeRate
	--------------------------------------------------------------------------

	SELECT
		SourceCurrencyKey,
		DestinationCurrencyKey,
		CalendarKey,
		Rate
	INTO
		#ExchangeRate
	FROM
		dbo.ExchangeRate
	WHERE
		ReforecastKey = @ActiveReforecastKey -- We will use the exchange rate set that is active for the current reforecast.

	--------------------------------------------------------------------------
	-- FeeAdjustment
	--------------------------------------------------------------------------

	CREATE TABLE #FeeAdjustmentFilterTable 
	(
		FeeAdjustmentKey INT NOT NULL
	)

	IF (@IncludeFeeAdjustments = 1)
	BEGIN

		INSERT INTO #FeeAdjustmentFilterTable
		SELECT 
			FeeAdjustmentKey
		FROM 
			dbo.FeeAdjustment 
		WHERE
			FeeAdjustmentCode IN (''NORMAL'', ''FEEADJUST'')

	END
	ELSE
	BEGIN

		INSERT INTO #FeeAdjustmentFilterTable
		SELECT 
			FeeAdjustmentKey
		FROM 
			dbo.FeeAdjustment 
		WHERE
			FeeAdjustmentCode = ''NORMAL''

	END

END

/* ==============================================================================================================================================
	Create the main temporary table that will be used to contain Actual, Budget, and Reforecast data
   =========================================================================================================================================== */
BEGIN

	CREATE TABLE #ProfitabilityReport
	(
		GLCategorizationHierarchyKey INT,
		OverheadCode VARCHAR(20),
		ActivityTypeKey INT,
		PropertyFundKey INT,
		AllocationRegionKey INT,
		ConsolidationRegionKey INT,
		OriginatingRegionKey INT,
		SourceName VARCHAR(50),
		SourceKey INT,
		GlAccountCode VARCHAR(15) NOT NULL,
		GLAccountName VARCHAR(300) NOT NULL,
		GLFinancialCategoryName VARCHAR(300) NOT NULL,
		InflowOutflow VARCHAR(20),
		ReimbursableKey INT,
		FeeAdjustmentKey INT,
		FunctionalDepartmentKey INT,
		OverheadKey INT,
		CalendarPeriod VARCHAR(6) DEFAULT(''''),
		
		EntryDate VARCHAR(10),
		[User] NVARCHAR(20),
		[Description] NVARCHAR(60),
		AdditionalDescription NVARCHAR(4000),
		PropertyFundCode VARCHAR(11) DEFAULT(''''),
		OriginatingRegionCode VARCHAR(15) DEFAULT(''''),
		FunctionalDepartmentCode VARCHAR(15) DEFAULT(''''),

		--Month to date	
		MtdActual MONEY,
		MtdBudget MONEY,
		MtdReforecastQ1 MONEY,
		MtdReforecastQ2 MONEY,
		MtdReforecastQ3 MONEY,

		--Year to date
		YtdActual MONEY,	
		YtdBudget MONEY, 
		YtdReforecastQ1 MONEY, 
		YtdReforecastQ2 MONEY, 
		YtdReforecastQ3 MONEY, 

		--Annual
		AnnualBudget MONEY,
		AnnualReforecastQ1 MONEY,
		AnnualReforecastQ2 MONEY,
		AnnualReforecastQ3 MONEY
	)

END


/* ==============================================================================================================================================
	Get the Actual portion of the data by selecting from the GrReporting.dbo.ProfitabilityActual fact
   =========================================================================================================================================== */
BEGIN

	INSERT INTO #ProfitabilityReport
	SELECT
		GlCategorizationHierarchy.GLCategorizationHierarchyKey AS GLCategorizationHierarchyKey,
		Overhead.OverheadCode,
		ProfitabilityActual.ActivityTypeKey,
		ProfitabilityActual.PropertyFundKey,
		ProfitabilityActual.AllocationRegionKey,
		ProfitabilityActual.ConsolidationRegionKey,
		ProfitabilityActual.OriginatingRegionKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''	
			ELSE
				[Source].SourceName
		END AS SourceName,
		ProfitabilityActual.SourceKey AS SourceKey,
		GlCategorizationHierarchy.LatestGlAccountCode,
		GlCategorizationHierarchy.LatestGLAccountName,
		CASE 
			WHEN 
				(GlCategorizationHierarchy.LatestGLFinancialCategoryName = ''Payroll'' AND Overhead.OverheadCode = ''UNALLOC'') OR
				(GlCategorizationHierarchy.LatestGLFinancialCategoryName = ''Non-Payroll'' AND Overhead.OverheadCode = ''UNALLOC'') 
			THEN 
				''Overhead'' 
			ELSE  
				GlCategorizationHierarchy.LatestGLFinancialCategoryName 
		END AS GLFinancialCategoryName,
		GlCategorizationHierarchy.LatestInflowOutflow,
		ProfitabilityActual.ReimbursableKey,
		@FeeAdjustmentKey AS FeeAdjustmentKey,
		ProfitabilityActual.FunctionalDepartmentKey,
		ProfitabilityActual.OverheadKey,
		Calendar.CalendarPeriod,	
		CONVERT(VARCHAR(10), ISNULL(ProfitabilityActual.LastDate, ''''), 101) AS EntryDate,
		ProfitabilityActual.[User],
		ProfitabilityActual.[Description],
		ProfitabilityActual.AdditionalDescription,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''
			ELSE
				ISNULL(ProfitabilityActual.PropertyFundCode, '''')
		END AS PropertyFundCode,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''	
			ELSE
				ISNULL(ProfitabilityActual.OriginatingRegionCode, '''')
		END AS OriginatingRegionCode,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''	
			ELSE
				ISNULL(ProfitabilityActual.FunctionalDepartmentCode, '''')
		END AS FunctionalDepartmentCode,

		-- MonthToDate -------
		SUM
		(
			#ExchangeRate.Rate * -1 * -- Expenses must be displayed as negative as Income is saved in MRI as negative
			CASE
				WHEN -- If the period of the transaction record is the same as the period for which the report is being generated
					Calendar.CalendarPeriod = @ReportExpensePeriodParameter
				THEN -- Then include it
					ProfitabilityActual.LocalActual
				ELSE -- Else exclude it by adding zero
					0.0
			END
		) AS MtdActual,
		NULL AS MtdBudget,			-- NULL because we''re selecting from dbo.ProfitabilityActual: budget data is sourced from dbo.ProfitabilityBudget
		NULL AS MtdReforecastQ1,	-- NULL because we''re selecting from dbo.ProfitabilityActual: reforecast data is sourced from dbo.ProfitabilityReforecast
		NULL AS MtdReforecastQ2,	-- See above
		NULL AS MtdReforecastQ3,	-- See above

		-- YearToDate --------
		SUM
		(
			#ExchangeRate.Rate * -1 *
			CASE
				WHEN -- If the period of the transaction record is less than the period for which the report is being generated
					Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
				THEN -- Then include it
					ProfitabilityActual.LocalActual
				ELSE -- Else exclude it by adding zero
					0
			END
		) AS YtdActual,
		NULL AS YtdBudget,			-- NULL because we''re selecting from dbo.ProfitabilityActual: budget data is sourced from dbo.ProfitabilityBudget
		NULL AS YtdReforecastQ1,	-- NULL because we''re selecting from dbo.ProfitabilityActual: reforecast data is sourced from dbo.ProfitabilityReforecast
		NULL AS YtdReforecastQ2,	-- See above
		NULL AS YtdReforecastQ3,	-- See above

		-- Annual
		NULL AS AnnualBudget,		-- NULL because we''re selecting from dbo.ProfitabilityActual: budget data is sourced from dbo.ProfitabilityBudget
		NULL AS AnnualReforecastQ1,	-- NULL because we''re selecting from dbo.ProfitabilityActual: reforecast data is sourced from dbo.ProfitabilityReforecast
		NULL AS AnnualReforecastQ2,	-- See above
		NULL AS AnnualReforecastQ3	-- See above
	FROM
		dbo.ProfitabilityActual

		INNER JOIN dbo.Overhead ON
			ProfitabilityActual.Overheadkey = Overhead.OverheadKey

		INNER JOIN #ExchangeRate ON
			ProfitabilityActual.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
			ProfitabilityActual.CalendarKey = #ExchangeRate.CalendarKey

		INNER JOIN #EntityFilterTable ON
			ProfitabilityActual.PropertyFundKey = #EntityFilterTable.PropertyFundKey

		INNER JOIN dbo.Currency ON
			#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey

		INNER JOIN dbo.Reimbursable ON
			ProfitabilityActual.ReimbursableKey = Reimbursable.ReimbursableKey

		INNER JOIN dbo.Calendar ON
			ProfitabilityActual.CalendarKey = Calendar.CalendarKey

		INNER JOIN dbo.[Source] ON 
			[Source].SourceKey = ProfitabilityActual.SourceKey

		INNER JOIN #OverheadFilterTable ON
			ProfitabilityActual.OverheadKey = #OverheadFilterTable.OverheadKey

		INNER JOIN #ActivityTypeFilterTable ON
			ProfitabilityActual.ActivityTypeKey = #ActivityTypeFilterTable.ActivityTypeKey

		LEFT OUTER JOIN #OriginatingSubRegionFilterTable ON
			ProfitabilityActual.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey

		LEFT OUTER JOIN #AllocationSubRegionFilterTable ON	
			ProfitabilityActual.ConsolidationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey    

		INNER JOIN dbo.GlCategorizationHierarchyLatestState GlCategorizationHierarchy ON GlCategorizationHierarchy.GLCategorizationHierarchyKey = 
			CASE
				WHEN @GLCategorizationName = ''Global'' THEN ProfitabilityActual.GlobalGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = ''US Property'' THEN ProfitabilityActual.USPropertyGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = ''US Fund'' THEN ProfitabilityActual.USFundGLCategorizationHierarchyKey 
				WHEN @GLCategorizationName = ''US Development'' THEN ProfitabilityActual.USDevelopmentGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = ''EU Property'' THEN ProfitabilityActual.EUPropertyGLCategorizationHierarchyKey 
				WHEN @GLCategorizationName = ''EU Fund'' THEN ProfitabilityActual.EUFundGLCategorizationHierarchyKey 
				WHEN @GLCategorizationName = ''EU Development'' THEN ProfitabilityActual.EUDevelopmentGLCategorizationHierarchyKey
				ELSE NULL
			END
	WHERE
		Calendar.CalendarYear = @CalendarYear AND -- We only want to pull data that is for the year for which the report is being generated
		Currency.CurrencyCode = @_DestinationCurrency AND
		GlCategorizationHierarchy.LatestGLMinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */	AND
		(
			(	-- Retrieve transactions that are not overhead transactions, or transactions that are but are allocated overhead
				Overhead.OverheadCode IN (@GrOverheadCodeAlloc, @GrOverheadCodeNA) AND
				#AllocationSubRegionFilterTable.AllocationRegionKey IS NOT NULL
			) OR
			(	-- Retrieve transactions that are overhead transactions that are unallocated
				Overhead.OverheadCode IN (@GrOverheadCodeUnAlloc) AND
				#OriginatingSubRegionFilterTable.OriginatingRegionKey IS NOT NULL
			)
		)
	GROUP BY
		GlCategorizationHierarchy.GLCategorizationHierarchyKey,
		Overhead.OverheadCode,
		ProfitabilityActual.ActivityTypeKey,
		ProfitabilityActual.PropertyFundKey,
		ProfitabilityActual.AllocationRegionKey,
		ProfitabilityActual.ConsolidationRegionKey,
		ProfitabilityActual.OriginatingRegionKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''	
			ELSE
				[Source].SourceName
		END,
		GlCategorizationHierarchy.LatestGlAccountCode,
		GlCategorizationHierarchy.LatestGLAccountName,
		GlCategorizationHierarchy.LatestGLFinancialCategoryName,
		GlCategorizationHierarchy.LatestInflowOutflow,
		ProfitabilityActual.SourceKey,
		ProfitabilityActual.ReimbursableKey,
		ProfitabilityActual.FunctionalDepartmentKey,
		ProfitabilityActual.OverheadKey,
		Calendar.CalendarPeriod,	
		CONVERT(VARCHAR(10), ISNULL(ProfitabilityActual.LastDate, ''''), 101),
		ProfitabilityActual.[User],
		ProfitabilityActual.[Description],
		ProfitabilityActual.AdditionalDescription,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''
			ELSE
				ISNULL(ProfitabilityActual.PropertyFundCode, '''')
		END,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''
			ELSE
				ISNULL(ProfitabilityActual.OriginatingRegionCode, '''')
		END,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''	
			ELSE
				ISNULL(ProfitabilityActual.FunctionalDepartmentCode, '''')
		END
END

/* ==============================================================================================================================================
	Get the Budget portion of the data by selecting from the GrReporting.dbo.ProfitabilityBudget fact
   =========================================================================================================================================== */
BEGIN

	INSERT INTO #ProfitabilityReport
	SELECT
		GlCategorizationHierarchy.GLCategorizationHierarchyKey AS ''GLCategorizationHierarchyKey'',
		Overhead.OverheadCode,
		ProfitabilityBudget.ActivityTypeKey,
		ProfitabilityBudget.PropertyFundKey,
		ProfitabilityBudget.AllocationRegionKey,
		ProfitabilityBudget.ConsolidationRegionKey,
		ProfitabilityBudget.OriginatingRegionKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''	
			ELSE
				[Source].SourceName
		END AS ''SourceName'',    
		ProfitabilityBudget.SourceKey AS SourceKey,
		GlCategorizationHierarchy.LatestGlAccountCode,
		GlCategorizationHierarchy.LatestGLAccountName,
		CASE
			WHEN
				(GlCategorizationHierarchy.LatestGLFinancialCategoryName = ''Payroll'' AND Overhead.OverheadCode = ''UNALLOC'') OR
				(GlCategorizationHierarchy.LatestGLFinancialCategoryName = ''Non-Payroll'' AND Overhead.OverheadCode = ''UNALLOC'')
			THEN
				''Overhead''
			ELSE
				GlCategorizationHierarchy.LatestGLFinancialCategoryName
		END AS ''GLFinancialCategoryName'',
		GlCategorizationHierarchy.LatestInflowOutflow,
		ProfitabilityBudget.ReimbursableKey,
		ProfitabilityBudget.FeeAdjustmentKey,
		ProfitabilityBudget.FunctionalDepartmentKey,
		ProfitabilityBudget.OverheadKey,
		'''''''' AS CalendarPeriod,
		'''''''' AS EntryDate,
		'''''''' AS [User],
		'''''''' AS [Description],
		'''''''' AS AdditionalDescription,
		'''''''' AS PropertyFundCode,
		'''''''' AS OriginatingRegionCode,
		'''''''' AS FunctionalDepartmentCode,

		--Expenses must be displayed as negative
		NULL as MtdActual, -- NULL because we''re selecting from dbo.ProfitabilityBudget: actual data has already been sourced from dbo.ProfitabilityActual in the previous SELECT
		SUM
		(
			#ExchangeRate.Rate *
			(
				CASE
					WHEN
						GlCategorizationHierarchy.LatestInflowOutflow = @InflowOutflowIncome
					THEN
						1
					ELSE
						-1
				END
			) *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod = @ReportExpensePeriodParameter
					THEN
						ProfitabilityBudget.LocalBudget
					ELSE
						0
				END
			)
		) AS MtdBudget,
		NULL as MtdReforecastQ1, -- NULL because we''re selecting from dbo.ProfitabilityActual: reforecast data is sourced from dbo.ProfitabilityReforecast
		NULL as MtdReforecastQ2, -- See above
		NULL as MtdReforecastQ3, -- See above
		
		NULL as YtdActual, -- NULL because we''re selecting from dbo.ProfitabilityBudget: actual data has already been sourced from dbo.ProfitabilityActual in the previous SELECT
		SUM
		(
			#ExchangeRate.Rate *
			(
				CASE
					WHEN
						GlCategorizationHierarchy.LatestInflowOutflow = @InflowOutflowIncome
					THEN
						1
					ELSE
						-1 
				END
			) * 
			(
				CASE
					WHEN
						Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
					THEN
						ProfitabilityBudget.LocalBudget
					ELSE
						0
				END
			)
		) AS YtdBudget, -- NULL because we''re selecting from dbo.ProfitabilityActual: reforecast data is sourced from dbo.ProfitabilityReforecast
		NULL AS YtdReforecastQ1, -- NULL because we''re selecting from dbo.ProfitabilityActual: reforecast data is sourced from dbo.ProfitabilityReforecast
		NULL AS YtdReforecastQ2, -- See above
		NULL AS YtdReforecastQ3, -- See above

		SUM
		(
			#ExchangeRate.Rate *
			ProfitabilityBudget.LocalBudget *
			(
				CASE
					WHEN
						GlCategorizationHierarchy.LatestInflowOutflow = @InflowOutflowIncome
					THEN
						1
					ELSE
						-1 
				END
			)
		) AS AnnualBudget,
		NULL as AnnualReforecastQ1, -- NULL because we''re selecting from dbo.ProfitabilityActual: reforecast data is sourced from dbo.ProfitabilityReforecast
		NULL as AnnualReforecastQ2, -- See above
		NULL as AnnualReforecastQ3  -- See above
	FROM
		dbo.ProfitabilityBudget

		INNER JOIN dbo.Overhead ON
			ProfitabilityBudget.Overheadkey = Overhead.OverheadKey

		INNER JOIN #ExchangeRate ON
			ProfitabilityBudget.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
			ProfitabilityBudget.CalendarKey = #ExchangeRate.CalendarKey    

		INNER JOIN #EntityFilterTable ON
			ProfitabilityBudget.PropertyFundKey = #EntityFilterTable.PropertyFundKey

		INNER JOIN dbo.Currency ON
			#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey

		INNER JOIN dbo.Reimbursable ON
			ProfitabilityBudget.ReimbursableKey = Reimbursable.ReimbursableKey

		LEFT OUTER JOIN #OriginatingSubRegionFilterTable ON
			ProfitabilityBudget.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey

		INNER JOIN dbo.Calendar ON
			ProfitabilityBudget.CalendarKey = Calendar.CalendarKey

		INNER JOIN dbo.[Source] ON
			[Source].SourceKey = ProfitabilityBudget.SourceKey

		INNER JOIN #OverheadFilterTable ON
			ProfitabilityBudget.OverheadKey = #OverheadFilterTable.OverheadKey

		INNER JOIN #ActivityTypeFilterTable ON
			ProfitabilityBudget.ActivityTypeKey = #ActivityTypeFilterTable.ActivityTypeKey

		LEFT OUTER JOIN #AllocationSubRegionFilterTable ON
			-- ProfitabilityActual.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey
			-- Profitibility uses Consolidation regions instead of allocation regions
			ProfitabilityBudget.ConsolidationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey

		INNER JOIN #FeeAdjustmentFilterTable ON
			ProfitabilityBudget.FeeAdjustmentKey = #FeeAdjustmentFilterTable.FeeAdjustmentKey

		INNER JOIN dbo.GlCategorizationHierarchyLatestState GlCategorizationHierarchy ON GlCategorizationHierarchy.GLCategorizationHierarchyKey = 
			CASE
				WHEN @GLCategorizationName = ''Global'' THEN ProfitabilityBudget.GlobalGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = ''US Property'' THEN ProfitabilityBudget.USPropertyGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = ''US Fund'' THEN ProfitabilityBudget.USFundGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = ''US Development'' THEN ProfitabilityBudget.USDevelopmentGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = ''EU Property'' THEN ProfitabilityBudget.EUPropertyGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = ''EU Fund'' THEN ProfitabilityBudget.EUFundGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = ''EU Development'' THEN ProfitabilityBudget.EUDevelopmentGLCategorizationHierarchyKey
				ELSE NULL
			END
	WHERE
		Calendar.CalendarYear = @CalendarYear AND
		Currency.CurrencyCode = @_DestinationCurrency AND
		GlCategorizationHierarchy.LatestGLMinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */	AND
		(
			(
				Overhead.OverheadCode IN (@GrOverheadCodeAlloc, @GrOverheadCodeNA) AND
				#AllocationSubRegionFilterTable.AllocationRegionKey IS NOT NULL
			) OR
			(
				Overhead.OverheadCode IN (@GrOverheadCodeUnAlloc) AND
				#OriginatingSubRegionFilterTable.OriginatingRegionKey IS NOT NULL
			)
		)
	GROUP BY
		GlCategorizationHierarchy.GLCategorizationHierarchyKey,
		Overhead.OverheadCode,
		ProfitabilityBudget.ActivityTypeKey,
		ProfitabilityBudget.PropertyFundKey,
		ProfitabilityBudget.AllocationRegionKey,
		ProfitabilityBudget.ConsolidationRegionKey,
		ProfitabilityBudget.OriginatingRegionKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''
			ELSE
				[Source].SourceName
		END,
		GlCategorizationHierarchy.LatestGlAccountCode,
		GlCategorizationHierarchy.LatestGLAccountName,
		GlCategorizationHierarchy.LatestGLFinancialCategoryName,
		GlCategorizationHierarchy.LatestInflowOutflow,
		ProfitabilityBudget.SourceKey,
		ProfitabilityBudget.ReimbursableKey,
		ProfitabilityBudget.FeeAdjustmentKey,
		ProfitabilityBudget.FunctionalDepartmentKey,
		ProfitabilityBudget.OverheadKey,
		Calendar.CalendarPeriod

END
   
/* ==============================================================================================================================================
	Get the Q1 Reforecast portion of the data by selecting from the GrReporting.dbo.ProfitabilityReforecast fact
   =========================================================================================================================================== */
BEGIN

	INSERT INTO #ProfitabilityReport
	SELECT
		GlCategorizationHierarchy.GLCategorizationHierarchyKey,
		Overhead.OverheadCode,
		ProfitabilityReforecast.ActivityTypeKey,
		ProfitabilityReforecast.PropertyFundKey,
		ProfitabilityReforecast.AllocationRegionKey,
		ProfitabilityReforecast.ConsolidationRegionKey,
		ProfitabilityReforecast.OriginatingRegionKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''	
			ELSE
				[Source].SourceName
		END AS ''SourceName'',        
		ProfitabilityReforecast.SourceKey,
		GlCategorizationHierarchy.LatestGlAccountCode,
		GlCategorizationHierarchy.LatestGLAccountName,
		CASE 
			WHEN 
				(GlCategorizationHierarchy.LatestGLFinancialCategoryName = ''Payroll'' AND Overhead.OverheadCode = ''UNALLOC'') OR
				(GlCategorizationHierarchy.LatestGLFinancialCategoryName = ''Non-Payroll'' AND Overhead.OverheadCode = ''UNALLOC'') 
			THEN 
				''Overhead'' 
			ELSE  
				GlCategorizationHierarchy.LatestGLFinancialCategoryName 
		END AS ''GLFinancialCategoryName'',
		GlCategorizationHierarchy.LatestInflowOutflow,
		ProfitabilityReforecast.ReimbursableKey,
		ProfitabilityReforecast.FeeAdjustmentKey,
		ProfitabilityReforecast.FunctionalDepartmentKey,
		ProfitabilityReforecast.OverheadKey,
		'''''''' AS CalendarPeriod,
		
		'''''''' AS EntryDate,
		'''''''' AS [User],
		'''''''' AS [Description],
		'''''''' AS AdditionalDescription,
		'''''''' AS PropertyFundCode,
		'''''''' AS OriginatingRegionCode,
		'''''''' AS FunctionalDepartmentCode,

		NULL AS MtdActual, -- NULL because we''re selecting from dbo.ProfitabilityReforecast: actual data has already been sourced from dbo.ProfitabilityActual in a previous SELECT
		NULL AS MtdBudget, -- NULL because we''re selecting from dbo.ProfitabilityReforecast: budget data has already been sourced from dbo.ProfitabilityBudget in a previous SELECT
		SUM
		(
			#ExchangeRate.Rate *
			(	--Expenses must be displayed as negative
				CASE
					WHEN
						GlCategorizationHierarchy.LatestInflowOutflow = @InflowOutflowIncome
					THEN
						1
					ELSE
						-1
				END
			) *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod = @ReportExpensePeriodParameter
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0
				END
			)
		) AS MtdReforecastQ1,
		NULL AS MtdReforecastQ2, -- NULL because we''re selecting only Q1 reforecast data from dbo.ProfitabilityReforecast: Q2 reforecast data will be select later on
		NULL AS MtdReforecastQ3, -- NULL because we''re selecting only Q1 reforecast data from dbo.ProfitabilityReforecast: Q3 reforecast data will be select later on

		NULL AS YtdActual, -- NULL because we''re selecting from dbo.ProfitabilityReforecast: actual data has already been sourced from dbo.ProfitabilityActual in a previous SELECT
		NULL AS YtdBudget, -- NULL because we''re selecting from dbo.ProfitabilityReforecast: budget data has already been sourced from dbo.ProfitabilityBudget in a previous SELECT
		SUM
		(
			#ExchangeRate.Rate *
			(
				CASE
					WHEN
						GlCategorizationHierarchy.LatestInflowOutflow = @InflowOutflowIncome
					THEN
						1
					ELSE
					-1
				END
			) *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0
				END
			)
		) AS YtdReforecastQ1, 
		NULL AS YtdReforecastQ2, -- NULL because we''re selecting only Q1 reforecast data from dbo.ProfitabilityReforecast: Q2 reforecast data will be select later on
		NULL AS YtdReforecastQ3, -- NULL because we''re selecting only Q1 reforecast data from dbo.ProfitabilityReforecast: Q3 reforecast data will be select later on
		
		NULL AS AnnualBudget, -- NULL because we''re selecting from dbo.ProfitabilityReforecast: budget data has already been sourced from dbo.ProfitabilityBudget in a previous SELECT
		SUM
		(
			#ExchangeRate.Rate *
			ProfitabilityReforecast.LocalReforecast * 
			(
				CASE
					WHEN
						GlCategorizationHierarchy.LatestInflowOutflow = @InflowOutflowIncome
					THEN
						1
					ELSE
						-1 
				END
			)
		) AS AnnualReforecastQ1,
		NULL AS AnnualReforecastQ2, -- NULL because we''re selecting only Q1 reforecast data from dbo.ProfitabilityReforecast: Q2 reforecast data will be select later on
		NULL AS AnnualReforecastQ3  -- NULL because we''re selecting only Q1 reforecast data from dbo.ProfitabilityReforecast: Q3 reforecast data will be select later on
	FROM
		dbo.ProfitabilityReforecast

		INNER JOIN dbo.Overhead ON
			ProfitabilityReforecast.Overheadkey = Overhead.OverheadKey

		INNER JOIN #ExchangeRate ON
			ProfitabilityReforecast.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
			ProfitabilityReforecast.CalendarKey = #ExchangeRate.CalendarKey    

		INNER JOIN #EntityFilterTable ON
			ProfitabilityReforecast.PropertyFundKey = #EntityFilterTable.PropertyFundKey

		INNER JOIN dbo.Currency ON
			#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey

		INNER JOIN dbo.Reimbursable ON
			ProfitabilityReforecast.ReimbursableKey = Reimbursable.ReimbursableKey

		INNER JOIN dbo.Calendar ON
			ProfitabilityReforecast.CalendarKey = Calendar.CalendarKey

		INNER JOIN dbo.[Source] ON
			[Source].SourceKey = ProfitabilityReforecast.SourceKey

		INNER JOIN #OverheadFilterTable ON
			ProfitabilityReforecast.OverheadKey = #OverheadFilterTable.OverheadKey

		INNER JOIN #ActivityTypeFilterTable ON
			ProfitabilityReforecast.ActivityTypeKey = #ActivityTypeFilterTable.ActivityTypeKey	

		INNER JOIN Reforecast ON
			ProfitabilityReforecast.ReforecastKey = Reforecast.ReforecastKey

		INNER JOIN #FeeAdjustmentFilterTable ON
			ProfitabilityReforecast.FeeAdjustmentKey = #FeeAdjustmentFilterTable.FeeAdjustmentKey		

		INNER JOIN dbo.GlCategorizationHierarchyLatestState GlCategorizationHierarchy ON GlCategorizationHierarchy.GLCategorizationHierarchyKey = 
			CASE
				WHEN @GLCategorizationName = ''Global'' THEN ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey 
				WHEN @GLCategorizationName = ''US Property'' THEN ProfitabilityReforecast.USPropertyGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = ''US Fund'' THEN ProfitabilityReforecast.USFundGLCategorizationHierarchyKey 
				WHEN @GLCategorizationName = ''US Development'' THEN ProfitabilityReforecast.USDevelopmentGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = ''EU Property'' THEN ProfitabilityReforecast.EUPropertyGLCategorizationHierarchyKey 
				WHEN @GLCategorizationName = ''EU Fund'' THEN ProfitabilityReforecast.EUFundGLCategorizationHierarchyKey 
				WHEN @GLCategorizationName = ''EU Development'' THEN ProfitabilityReforecast.EUDevelopmentGLCategorizationHierarchyKey
				ELSE NULL
			END

		LEFT OUTER JOIN #OriginatingSubRegionFilterTable ON
			ProfitabilityReforecast.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey

		LEFT OUTER JOIN #AllocationSubRegionFilterTable ON	
			ProfitabilityReforecast.ConsolidationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey    		
	WHERE
		Reforecast.ReforecastKey = @Q1ReforecastKey AND -- Limit to Q1 data
		Calendar.CalendarYear = @CalendarYear AND
		Currency.CurrencyCode = @_DestinationCurrency AND
		GlCategorizationHierarchy.LatestGLMinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */	AND
		(
			(
				Overhead.OverheadCode IN (@GrOverheadCodeAlloc, @GrOverheadCodeNA) AND #AllocationSubRegionFilterTable.AllocationRegionKey IS NOT NULL
			) OR
			(
				Overhead.OverheadCode IN (@GrOverheadCodeUnAlloc) AND #OriginatingSubRegionFilterTable.OriginatingRegionKey IS NOT NULL
			)
		)
	GROUP BY
		GlCategorizationHierarchy.GLCategorizationHierarchyKey,
		Overhead.OverheadCode,
		ProfitabilityReforecast.ActivityTypeKey,
		ProfitabilityReforecast.PropertyFundKey,
		ProfitabilityReforecast.AllocationRegionKey,
		ProfitabilityReforecast.ConsolidationRegionKey,
		ProfitabilityReforecast.OriginatingRegionKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''
			ELSE
				[Source].SourceName
		END,
		GlCategorizationHierarchy.LatestGlAccountCode,
		GlCategorizationHierarchy.LatestGLAccountName,
		GlCategorizationHierarchy.LatestGLFinancialCategoryName,
		GlCategorizationHierarchy.LatestInflowOutflow,
		ProfitabilityReforecast.SourceKey,
		ProfitabilityReforecast.ReimbursableKey,
		ProfitabilityReforecast.FeeAdjustmentKey,
		ProfitabilityReforecast.FunctionalDepartmentKey,
		ProfitabilityReforecast.OverheadKey,
		Calendar.CalendarPeriod

END

/* ==============================================================================================================================================
	Get the Q2 Reforecast portion of the data by selecting from the GrReporting.dbo.ProfitabilityReforecast fact
   =========================================================================================================================================== */
BEGIN

	INSERT INTO #ProfitabilityReport
	SELECT
		GlCategorizationHierarchy.GLCategorizationHierarchyKey,
		Overhead.OverheadCode,
		ProfitabilityReforecast.ActivityTypeKey,
		ProfitabilityReforecast.PropertyFundKey,
		ProfitabilityReforecast.AllocationRegionKey,
		ProfitabilityReforecast.ConsolidationRegionKey,
		ProfitabilityReforecast.OriginatingRegionKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''	
			ELSE
				[Source].SourceName
		END AS ''SourceName'',        
		ProfitabilityReforecast.SourceKey,
		GlCategorizationHierarchy.LatestGlAccountCode,
		GlCategorizationHierarchy.LatestGLAccountName,
		CASE 
			WHEN 
				(GlCategorizationHierarchy.LatestGLFinancialCategoryName = ''Payroll'' AND Overhead.OverheadCode = ''UNALLOC'') OR
				(GlCategorizationHierarchy.LatestGLFinancialCategoryName = ''Non-Payroll'' AND Overhead.OverheadCode = ''UNALLOC'') 
			THEN 
				''Overhead'' 
			ELSE  
				GlCategorizationHierarchy.LatestGLFinancialCategoryName 
		END AS ''GLFinancialCategoryName'',
		GlCategorizationHierarchy.LatestInflowOutflow,
		ProfitabilityReforecast.ReimbursableKey,
		ProfitabilityReforecast.FeeAdjustmentKey,
		ProfitabilityReforecast.FunctionalDepartmentKey,
		ProfitabilityReforecast.OverheadKey,
		'''''''' AS CalendarPeriod,
		
		'''''''' AS EntryDate,
		'''''''' AS [User],
		'''''''' AS [Description],
		'''''''' AS AdditionalDescription,
		'''''''' AS PropertyFundCode,
		'''''''' AS OriginatingRegionCode,
		'''''''' AS FunctionalDepartmentCode,

		NULL AS MtdActual,		 -- NULL because we''re selecting from dbo.ProfitabilityReforecast: actual data has already been sourced from dbo.ProfitabilityActual in a previous SELECT
		NULL AS MtdBudget,		 -- NULL because we''re selecting from dbo.ProfitabilityReforecast: budget data has already been sourced from dbo.ProfitabilityBudget in a previous SELECT
		NULL AS MtdReforecastQ1, -- NULL because we''re selecting only Q2 reforecast data from dbo.ProfitabilityReforecast: Q1 reforecast data has already been sourced from dbo.ProfitabilityReforecast in a previous SELECT
		SUM
		(
			#ExchangeRate.Rate *
			(	--Expenses must be displayed as negative
				CASE
					WHEN
						GlCategorizationHierarchy.LatestInflowOutflow = @InflowOutflowIncome
					THEN
						1
					ELSE
						-1 
				END
			) *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod = @ReportExpensePeriodParameter
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0
				END
			)
		) AS MtdReforecastQ2,		
		NULL AS MtdReforecastQ3, -- NULL because we''re selecting only Q2 reforecast data from dbo.ProfitabilityReforecast: Q3 reforecast data will be select later on
		
		NULL AS YtdActual,		 -- NULL because we''re selecting from dbo.ProfitabilityReforecast: actual data has already been sourced from dbo.ProfitabilityActual in a previous SELECT
		NULL AS YtdBudget,		 -- NULL because we''re selecting from dbo.ProfitabilityReforecast: budget data has already been sourced from dbo.ProfitabilityBudget in a previous SELECT
		NULL AS YtdReforecastQ1, -- NULL because we''re selecting only Q2 reforecast data from dbo.ProfitabilityReforecast: Q1 reforecast data has already been sourced from dbo.ProfitabilityReforecast in a previous SELECT
		SUM
		(
			#ExchangeRate.Rate *
			(
				CASE
					WHEN
						GlCategorizationHierarchy.LatestInflowOutflow = @InflowOutflowIncome
					THEN
						1
					ELSE
						-1
				END
			) *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0
				END
			)
		) AS YtdReforecastQ2,
		NULL AS YtdReforecastQ3,	-- NULL because we''re selecting only Q2 reforecast data from dbo.ProfitabilityReforecast: Q3 reforecast data will be select later on
		
		NULL AS AnnualBudget,		-- NULL because we''re selecting from dbo.ProfitabilityReforecast: budget data has already been sourced from dbo.ProfitabilityBudget in a previous SELECT
		NULL as AnnualReforecastQ1, -- NULL because we''re selecting only Q2 reforecast data from dbo.ProfitabilityReforecast: Q1 reforecast data has already been sourced from dbo.ProfitabilityReforecast in a previous SELECT
		SUM
		(
			#ExchangeRate.Rate *
			ProfitabilityReforecast.LocalReforecast *
			(
				CASE
					WHEN
						GlCategorizationHierarchy.LatestInflowOutflow = @InflowOutflowIncome
					THEN
						1
					ELSE
						-1 
				END
			)
		) AS AnnualReforecastQ2,
		NULL AS AnnualReforecastQ3 -- NULL because we''re selecting only Q2 reforecast data from dbo.ProfitabilityReforecast: Q3 reforecast data will be select later on
	FROM
		dbo.ProfitabilityReforecast

		INNER JOIN dbo.Overhead ON
			ProfitabilityReforecast.Overheadkey = Overhead.OverheadKey

		INNER JOIN #ExchangeRate ON
			ProfitabilityReforecast.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
			ProfitabilityReforecast.CalendarKey = #ExchangeRate.CalendarKey

		INNER JOIN #EntityFilterTable ON
			ProfitabilityReforecast.PropertyFundKey = #EntityFilterTable.PropertyFundKey

		INNER JOIN dbo.Currency ON
			#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey

		INNER JOIN dbo.Reimbursable ON
			ProfitabilityReforecast.ReimbursableKey = Reimbursable.ReimbursableKey

		INNER JOIN dbo.Calendar ON
			ProfitabilityReforecast.CalendarKey = Calendar.CalendarKey

		INNER JOIN dbo.[Source] ON 
			[Source].SourceKey = ProfitabilityReforecast.SourceKey

		INNER JOIN #OverheadFilterTable ON
			ProfitabilityReforecast.OverheadKey = #OverheadFilterTable.OverheadKey

		INNER JOIN #ActivityTypeFilterTable ON
			ProfitabilityReforecast.ActivityTypeKey = #ActivityTypeFilterTable.ActivityTypeKey		

		INNER JOIN Reforecast ON
			ProfitabilityReforecast.ReforecastKey = Reforecast.ReforecastKey

		INNER JOIN #FeeAdjustmentFilterTable ON
			ProfitabilityReforecast.FeeAdjustmentKey = #FeeAdjustmentFilterTable.FeeAdjustmentKey

		INNER JOIN dbo.GlCategorizationHierarchyLatestState GlCategorizationHierarchy ON GlCategorizationHierarchy.GLCategorizationHierarchyKey = 
			CASE
				WHEN @GLCategorizationName = ''Global'' THEN ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey 
				WHEN @GLCategorizationName = ''US Property'' THEN ProfitabilityReforecast.USPropertyGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = ''US Fund'' THEN ProfitabilityReforecast.USFundGLCategorizationHierarchyKey 
				WHEN @GLCategorizationName = ''US Development'' THEN ProfitabilityReforecast.USDevelopmentGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = ''EU Property'' THEN ProfitabilityReforecast.EUPropertyGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = ''EU Fund'' THEN ProfitabilityReforecast.EUFundGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = ''EU Development'' THEN ProfitabilityReforecast.EUDevelopmentGLCategorizationHierarchyKey
				ELSE NULL
			END

		LEFT OUTER JOIN #OriginatingSubRegionFilterTable ON
			ProfitabilityReforecast.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey

		LEFT OUTER JOIN #AllocationSubRegionFilterTable ON	
			ProfitabilityReforecast.ConsolidationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey
	WHERE  
		Calendar.CalendarYear = @CalendarYear AND
		Currency.CurrencyCode = @_DestinationCurrency AND
		Reforecast.ReforecastKey = @Q2ReforecastKey AND -- Limit to Q2 data
		GlCategorizationHierarchy.LatestGLMinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */ AND
		(
			(
				Overhead.OverheadCode IN (@GrOverheadCodeAlloc, @GrOverheadCodeNA) AND
				#AllocationSubRegionFilterTable.AllocationRegionKey IS NOT NULL
			) OR
			(
				Overhead.OverheadCode IN (@GrOverheadCodeUnAlloc) AND
				#OriginatingSubRegionFilterTable.OriginatingRegionKey IS NOT NULL
			)
		)
	GROUP BY
		GlCategorizationHierarchy.GLCategorizationHierarchyKey,
		Overhead.OverheadCode,
		ProfitabilityReforecast.ActivityTypeKey,
		ProfitabilityReforecast.PropertyFundKey,
		ProfitabilityReforecast.AllocationRegionKey,
		ProfitabilityReforecast.ConsolidationRegionKey,
		ProfitabilityReforecast.OriginatingRegionKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''
			ELSE
				[Source].SourceName
		END,
		GlCategorizationHierarchy.LatestGlAccountCode,
		GlCategorizationHierarchy.LatestGLAccountName,
		GlCategorizationHierarchy.LatestGLFinancialCategoryName,
		GlCategorizationHierarchy.LatestInflowOutflow,
		ProfitabilityReforecast.SourceKey,
		ProfitabilityReforecast.ReimbursableKey,
		ProfitabilityReforecast.FeeAdjustmentKey,
		ProfitabilityReforecast.FunctionalDepartmentKey,
		ProfitabilityReforecast.OverheadKey,
		Calendar.CalendarPeriod	

END
	
/* ==============================================================================================================================================
	Get the Q2 Reforecast portion of the data by selecting from the GrReporting.dbo.ProfitabilityReforecast fact
   =========================================================================================================================================== */
BEGIN

	INSERT INTO #ProfitabilityReport
	SELECT
		GlCategorizationHierarchy.GLCategorizationHierarchyKey,
		Overhead.OverheadCode,
		ProfitabilityReforecast.ActivityTypeKey,
		ProfitabilityReforecast.PropertyFundKey,
		ProfitabilityReforecast.AllocationRegionKey,
		ProfitabilityReforecast.ConsolidationRegionKey,
		ProfitabilityReforecast.OriginatingRegionKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''	
			ELSE
				[Source].SourceName
		END AS ''SourceName'',
		ProfitabilityReforecast.SourceKey,
		GlCategorizationHierarchy.LatestGlAccountCode,
		GlCategorizationHierarchy.LatestGLAccountName,
		CASE
			WHEN
				(
					GlCategorizationHierarchy.LatestGLFinancialCategoryName = ''Payroll'' AND Overhead.OverheadCode = ''UNALLOC''
				) OR
				(
					GlCategorizationHierarchy.LatestGLFinancialCategoryName = ''Non-Payroll'' AND Overhead.OverheadCode = ''UNALLOC''
				)
			THEN 
				''Overhead''
			ELSE
				GlCategorizationHierarchy.LatestGLFinancialCategoryName 
		END AS ''GLFinancialCategoryName'',
		GlCategorizationHierarchy.LatestInflowOutflow,
		ProfitabilityReforecast.ReimbursableKey,
		ProfitabilityReforecast.FeeAdjustmentKey,
		ProfitabilityReforecast.FunctionalDepartmentKey,
		ProfitabilityReforecast.OverheadKey,
		'''''''' AS CalendarPeriod,
		
		'''''''' AS EntryDate,
		'''''''' AS [User],
		'''''''' AS [Description],
		'''''''' AS AdditionalDescription,
		'''''''' AS PropertyFundCode,
		'''''''' AS OriginatingRegionCode,
		'''''''' AS FunctionalDepartmentCode,
	    
		--Expenses must be displayed as negative
		NULL AS MtdActual,		 -- NULL because we''re selecting from dbo.ProfitabilityReforecast: actual data has already been sourced from dbo.ProfitabilityActual in a previous SELECT
		NULL AS MtdBudget,		 -- NULL because we''re selecting from dbo.ProfitabilityReforecast: budget data has already been sourced from dbo.ProfitabilityBudget in a previous SELECT
		NULL AS MtdReforecastQ1, -- NULL because we''re selecting only Q3 reforecast data from dbo.ProfitabilityReforecast: Q1 reforecast data has already been sourced from dbo.ProfitabilityReforecast in a previous SELECT
		NULL AS MtdReforecastQ2, -- NULL because we''re selecting only Q3 reforecast data from dbo.ProfitabilityReforecast: Q2 reforecast data has already been sourced from dbo.ProfitabilityReforecast in a previous SELECT
		SUM
		(
			#ExchangeRate.Rate *
			(
				CASE
					WHEN
						GlCategorizationHierarchy.LatestInflowOutflow = @InflowOutflowIncome
					THEN
						1
					ELSE
						-1
				END
			) *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod = @ReportExpensePeriodParameter
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0
				END
			)
		) AS MtdReforecastQ3,
		
		NULL AS YtdActual,		 -- NULL because we''re selecting from dbo.ProfitabilityReforecast: actual data has already been sourced from dbo.ProfitabilityActual in a previous SELECT
		NULL AS YtdBudget,		 -- NULL because we''re selecting from dbo.ProfitabilityReforecast: budget data has already been sourced from dbo.ProfitabilityBudget in a previous SELECT
		NULL AS YtdReforecastQ1, -- NULL because we''re selecting only Q3 reforecast data from dbo.ProfitabilityReforecast: Q1 reforecast data has already been sourced from dbo.ProfitabilityReforecast in a previous SELECT 
		NULL AS YtdReforecastQ2, -- NULL because we''re selecting only Q3 reforecast data from dbo.ProfitabilityReforecast: Q2 reforecast data has already been sourced from dbo.ProfitabilityReforecast in a previous SELECT
		SUM
		(
			#ExchangeRate.Rate *
			(
				CASE
					WHEN
						GlCategorizationHierarchy.LatestInflowOutflow = @InflowOutflowIncome
					THEN
						1
					ELSE
						-1
				END
			) *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0
				END
			)
		) AS YtdReforecastQ3,

		NULL AS AnnualBudget,		-- NULL because we''re selecting from dbo.ProfitabilityReforecast: budget data has already been sourced from dbo.ProfitabilityBudget in a previous SELECT
		NULL AS AnnualReforecastQ1, -- NULL because we''re selecting only Q3 reforecast data from dbo.ProfitabilityReforecast: Q1 reforecast data has already been sourced from dbo.ProfitabilityReforecast in a previous SELECT
		NULL AS AnnualReforecastQ2, -- NULL because we''re selecting only Q3 reforecast data from dbo.ProfitabilityReforecast: Q2 reforecast data has already been sourced from dbo.ProfitabilityReforecast in a previous SELECT
		SUM
		(
			#ExchangeRate.Rate *
			ProfitabilityReforecast.LocalReforecast *
			(
				CASE
					WHEN
						GlCategorizationHierarchy.LatestInflowOutflow = @InflowOutflowIncome
					THEN
						1
					ELSE
						-1
				END
			)
		) AS AnnualReforecastQ3
	FROM
		dbo.ProfitabilityReforecast

		INNER JOIN dbo.Overhead ON
			ProfitabilityReforecast.Overheadkey = Overhead.OverheadKey

		INNER JOIN #ExchangeRate ON
			ProfitabilityReforecast.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
			ProfitabilityReforecast.CalendarKey = #ExchangeRate.CalendarKey    

		INNER JOIN #EntityFilterTable ON
			ProfitabilityReforecast.PropertyFundKey = #EntityFilterTable.PropertyFundKey

		INNER JOIN dbo.Currency ON
			#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey

		INNER JOIN dbo.Reimbursable ON
			ProfitabilityReforecast.ReimbursableKey = Reimbursable.ReimbursableKey

		INNER JOIN dbo.Calendar ON
			ProfitabilityReforecast.CalendarKey = Calendar.CalendarKey

		INNER JOIN dbo.[Source] ON 
			[Source].SourceKey = ProfitabilityReforecast.SourceKey

		INNER JOIN #OverheadFilterTable ON
			ProfitabilityReforecast.OverheadKey = #OverheadFilterTable.OverheadKey

		INNER JOIN #ActivityTypeFilterTable ON
			ProfitabilityReforecast.ActivityTypeKey = #ActivityTypeFilterTable.ActivityTypeKey

		INNER JOIN Reforecast ON
			ProfitabilityReforecast.ReforecastKey = Reforecast.ReforecastKey

		INNER JOIN #FeeAdjustmentFilterTable ON
			ProfitabilityReforecast.FeeAdjustmentKey = #FeeAdjustmentFilterTable.FeeAdjustmentKey		

		INNER JOIN dbo.GlCategorizationHierarchyLatestState GlCategorizationHierarchy ON GlCategorizationHierarchy.GLCategorizationHierarchyKey = 
			CASE
				WHEN @GLCategorizationName = ''Global'' THEN ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = ''US Property'' THEN ProfitabilityReforecast.USPropertyGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = ''US Fund'' THEN ProfitabilityReforecast.USFundGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = ''US Development'' THEN ProfitabilityReforecast.USDevelopmentGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = ''EU Property'' THEN ProfitabilityReforecast.EUPropertyGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = ''EU Fund'' THEN ProfitabilityReforecast.EUFundGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = ''EU Development'' THEN ProfitabilityReforecast.EUDevelopmentGLCategorizationHierarchyKey
				ELSE NULL
			END

		LEFT OUTER JOIN #OriginatingSubRegionFilterTable ON
			ProfitabilityReforecast.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey

		LEFT OUTER JOIN #AllocationSubRegionFilterTable ON
			ProfitabilityReforecast.ConsolidationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey
	WHERE
		Calendar.CalendarYear = @CalendarYear AND
		Currency.CurrencyCode = @_DestinationCurrency AND
		Reforecast.ReforecastKey = @Q3ReforecastKey AND -- Limit to Q3 data
		GlCategorizationHierarchy.LatestGLMinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */ AND
		(
			(
				Overhead.OverheadCode IN (@GrOverheadCodeAlloc, @GrOverheadCodeNA) AND
				#AllocationSubRegionFilterTable.AllocationRegionKey IS NOT NULL
			) OR
			(
				Overhead.OverheadCode IN (@GrOverheadCodeUnAlloc) AND
				#OriginatingSubRegionFilterTable.OriginatingRegionKey IS NOT NULL
			)
		)
	GROUP BY
		GlCategorizationHierarchy.GLCategorizationHierarchyKey,
		Overhead.OverheadCode,
		ProfitabilityReforecast.ActivityTypeKey,
		ProfitabilityReforecast.PropertyFundKey,
		ProfitabilityReforecast.AllocationRegionKey,
		ProfitabilityReforecast.ConsolidationRegionKey,
		ProfitabilityReforecast.OriginatingRegionKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''
			ELSE
				[Source].SourceName
		END,
		GlCategorizationHierarchy.LatestGlAccountCode,
		GlCategorizationHierarchy.LatestGLAccountName,
		GlCategorizationHierarchy.LatestGLFinancialCategoryName,
		GlCategorizationHierarchy.LatestInflowOutflow,
		ProfitabilityReforecast.SourceKey,
		ProfitabilityReforecast.ReimbursableKey,
		ProfitabilityReforecast.FeeAdjustmentKey,
		ProfitabilityReforecast.FunctionalDepartmentKey,
		ProfitabilityReforecast.OverheadKey,
		Calendar.CalendarPeriod

END

/* ==============================================================================================================================================
	Combine the Actual, Original Budget, and Reforecast (Q1, Q2, and Q3) data in a single select
   =========================================================================================================================================== */
BEGIN

	SELECT
		#ProfitabilityReport.GLFinancialCategoryName AS ExpenseType, 
		#ProfitabilityReport.InflowOutflow AS ''InflowOutflow'',
		CategorizationHierarchyInWarehouse.LatestGLMajorCategoryName AS ''MajorExpenseCategoryName'',
		CategorizationHierarchyInWarehouse.LatestGLMinorCategoryName AS ''MinorExpenseCategoryName'',
		ActivityType.BusinessLineName AS BusinessLine,
		ActivityType.ActivityTypeName AS ActivityType,
		PropertyFund.PropertyFundName AS ReportingEntityName,
		PropertyFund.PropertyFundType AS ReportingEntityType,
		AllocationRegion.LatestAllocationSubRegionName AS AllocationSubRegionName,
		ConsolidationRegion.LatestAllocationSubRegionName as ConsolidationSubRegionName,
		OriginatingRegion.LatestOriginatingSubRegionName as OriginatingSubRegionName,
		#ProfitabilityReport.GlAccountCode AS GlobalGlAccountCode,
		#ProfitabilityReport.GlAccountName AS GlobalGlAccountName,    
		Reimbursable.ReimbursableName,
		FeeAdjustment.FeeAdjustmentCode,
		#ProfitabilityReport.SourceName,
		#ProfitabilityReport.GLCategorizationHierarchyKey,

		#ProfitabilityReport.CalendarPeriod AS ActualsExpensePeriod,
		#ProfitabilityReport.EntryDate,
		#ProfitabilityReport.[User],
		#ProfitabilityReport.[Description],
		#ProfitabilityReport.AdditionalDescription,
		#ProfitabilityReport.PropertyFundCode,
		#ProfitabilityReport.FunctionalDepartmentCode,
		#ProfitabilityReport.OriginatingRegionCode,

		--Gross
		--Month to date
		SUM(ISNULL(#ProfitabilityReport.MtdActual, 0)) AS MtdActual,
		SUM(ISNULL(#ProfitabilityReport.MtdBudget, 0)) AS MtdOriginalBudget,

		SUM(ISNULL(#ProfitabilityReport.MtdReforecastQ1, 0))AS MtdReforecastQ1,
		SUM(ISNULL(#ProfitabilityReport.MtdReforecastQ2, 0))AS MtdReforecastQ2,
		SUM(ISNULL(#ProfitabilityReport.MtdReforecastQ3, 0))AS MtdReforecastQ3,

		/* Enhanced case statement: IMS 58120 */

		CASE WHEN #ProfitabilityReport.InflowOutflow = @InflowOutflowExpense AND NOT (Reimbursable.ReimbursableName = ''Reimbursable'' AND (#ProfitabilityReport.GLFinancialCategoryName = ''Payroll'' OR #ProfitabilityReport.GLFinancialCategoryName = ''Overhead'')) THEN SUM(ISNULL(MtdBudget, 0)) - SUM(ISNULL(MtdActual, 0)) ELSE SUM(ISNULL(#ProfitabilityReport.MtdActual, 0)) - SUM(ISNULL(MtdBudget, 0)) END AS MtdVarianceQ0,
		CASE WHEN #ProfitabilityReport.InflowOutflow = @InflowOutflowExpense AND NOT ( Reimbursable.ReimbursableName = ''Reimbursable'' AND (#ProfitabilityReport.GLFinancialCategoryName = ''Payroll'' OR #ProfitabilityReport.GLFinancialCategoryName = ''Overhead'') ) THEN SUM(ISNULL(#ProfitabilityReport.MtdReforecastQ1, 0)) - SUM(ISNULL(MtdActual, 0)) ELSE SUM(ISNULL(MtdActual, 0)) - SUM(ISNULL(#ProfitabilityReport.MtdReforecastQ1, 0)) END AS MtdVarianceQ1,
		CASE WHEN #ProfitabilityReport.InflowOutflow = @InflowOutflowExpense AND NOT ( Reimbursable.ReimbursableName = ''Reimbursable'' AND (#ProfitabilityReport.GLFinancialCategoryName = ''Payroll'' OR #ProfitabilityReport.GLFinancialCategoryName = ''Overhead'') ) THEN SUM(ISNULL(#ProfitabilityReport.MtdReforecastQ2, 0)) - SUM(ISNULL(MtdActual, 0)) ELSE SUM(ISNULL(MtdActual, 0)) - SUM(ISNULL(#ProfitabilityReport.MtdReforecastQ2, 0)) END AS MtdVarianceQ2,
		CASE WHEN #ProfitabilityReport.InflowOutflow = @InflowOutflowExpense AND NOT ( Reimbursable.ReimbursableName = ''Reimbursable'' AND (#ProfitabilityReport.GLFinancialCategoryName = ''Payroll'' OR #ProfitabilityReport.GLFinancialCategoryName = ''Overhead'') ) THEN SUM(ISNULL(#ProfitabilityReport.MtdReforecastQ3, 0)) - SUM(ISNULL(MtdActual, 0)) ELSE SUM(ISNULL(MtdActual, 0)) - SUM(ISNULL(#ProfitabilityReport.MtdReforecastQ3, 0)) END AS MtdVarianceQ3,

		--Year to date
		SUM(ISNULL(#ProfitabilityReport.YtdActual, 0)) AS YtdActual,
		SUM(ISNULL(#ProfitabilityReport.YtdBudget, 0)) AS YtdOriginalBudget,

		SUM(ISNULL(#ProfitabilityReport.YtdReforecastQ1, 0)) AS YtdReforecastQ1,
		SUM(ISNULL(#ProfitabilityReport.YtdReforecastQ2, 0)) YtdReforecastQ2,
		SUM(ISNULL(#ProfitabilityReport.YtdReforecastQ3, 0)) YtdReforecastQ3,

		/* Enhanced case statement: IMS 58120 */

		CASE WHEN #ProfitabilityReport.InflowOutflow = @InflowOutflowExpense AND NOT ( Reimbursable.ReimbursableName = ''Reimbursable'' AND (#ProfitabilityReport.GLFinancialCategoryName = ''Payroll'' OR #ProfitabilityReport.GLFinancialCategoryName = ''Overhead'') ) THEN SUM(ISNULL(YtdBudget, 0)) - SUM(ISNULL(YtdActual, 0)) ELSE SUM(ISNULL(#ProfitabilityReport.YtdActual, 0)) - SUM(ISNULL(YtdBudget, 0)) END AS YtdVarianceQ0,
		CASE WHEN #ProfitabilityReport.InflowOutflow = @InflowOutflowExpense AND NOT ( Reimbursable.ReimbursableName = ''Reimbursable'' AND (#ProfitabilityReport.GLFinancialCategoryName = ''Payroll'' OR #ProfitabilityReport.GLFinancialCategoryName = ''Overhead'') ) THEN SUM(ISNULL(#ProfitabilityReport.YtdReforecastQ1, 0)) - SUM(ISNULL(YtdActual, 0)) ELSE SUM(ISNULL(YtdActual, 0)) - SUM(ISNULL(#ProfitabilityReport.YtdReforecastQ1, 0)) END AS YtdVarianceQ1,
		CASE WHEN #ProfitabilityReport.InflowOutflow = @InflowOutflowExpense AND NOT ( Reimbursable.ReimbursableName = ''Reimbursable'' AND (#ProfitabilityReport.GLFinancialCategoryName = ''Payroll'' OR #ProfitabilityReport.GLFinancialCategoryName = ''Overhead'') ) THEN SUM(ISNULL(#ProfitabilityReport.YtdReforecastQ2, 0)) - SUM(ISNULL(YtdActual, 0)) ELSE SUM(ISNULL(YtdActual, 0)) - SUM(ISNULL(#ProfitabilityReport.YtdReforecastQ2, 0)) END AS YtdVarianceQ2,
		CASE WHEN #ProfitabilityReport.InflowOutflow = @InflowOutflowExpense AND NOT ( Reimbursable.ReimbursableName = ''Reimbursable'' AND (#ProfitabilityReport.GLFinancialCategoryName = ''Payroll'' OR #ProfitabilityReport.GLFinancialCategoryName = ''Overhead'') ) THEN SUM(ISNULL(#ProfitabilityReport.YtdReforecastQ3, 0)) - SUM(ISNULL(YtdActual, 0)) ELSE SUM(ISNULL(YtdActual, 0)) - SUM(ISNULL(#ProfitabilityReport.YtdReforecastQ3, 0)) END AS YtdVarianceQ3,

		--Annual
		SUM(ISNULL(#ProfitabilityReport.AnnualBudget, 0)) AS AnnualOriginalBudget,
		SUM(ISNULL(#ProfitabilityReport.AnnualReforecastQ1, 0)) AS AnnualReforecastQ1,
		SUM(ISNULL(#ProfitabilityReport.AnnualReforecastQ2, 0)) AS AnnualReforecastQ2,
		SUM(ISNULL(#ProfitabilityReport.AnnualReforecastQ3, 0)) AS AnnualReforecastQ3
	INTO
		[#Output]
	FROM
		#ProfitabilityReport

		INNER JOIN dbo.Overhead oh ON
			oh.OverheadKey = #ProfitabilityReport.OverheadKey

		INNER JOIN dbo.Reimbursable ON
			#ProfitabilityReport.ReimbursableKey = Reimbursable.ReimbursableKey

		INNER JOIN dbo.[Source] ON
			[Source].SourceKey = #ProfitabilityReport.SourceKey

		INNER JOIN dbo.GLCategorizationHierarchyLatestState CategorizationHierarchyInWarehouse ON
			#ProfitabilityReport.GLCategorizationHierarchyKey = CategorizationHierarchyInWarehouse.GLCategorizationHierarchyKey

		INNER JOIN dbo.OriginatingRegionLatestState OriginatingRegion ON
			OriginatingRegion.OriginatingRegionKey = #ProfitabilityReport.OriginatingRegionKey

		INNER JOIN dbo.AllocationRegionLatestState ConsolidationRegion ON
			ConsolidationRegion.AllocationRegionKey = #ProfitabilityReport.ConsolidationRegionKey

		INNER JOIN dbo.AllocationRegionLatestState AllocationRegion ON
			 AllocationRegion.AllocationRegionKey = #ProfitabilityReport.AllocationRegionKey

		INNER JOIN dbo.ActivityType ON
			ActivityType.ActivityTypeKey = #ProfitabilityReport.ActivityTypeKey

		INNER JOIN #EntityFilterTable PropertyFund ON
			PropertyFund.PropertyFundKey = #ProfitabilityReport.PropertyFundKey

		INNER JOIN dbo.FeeAdjustment ON
			FeeAdjustment.FeeAdjustmentKey = #ProfitabilityReport.FeeAdjustmentKey
	GROUP BY
		#ProfitabilityReport.GLFinancialCategoryName, 
		#ProfitabilityReport.InflowOutflow,
		CategorizationHierarchyInWarehouse.LatestGLMajorCategoryName,
		CategorizationHierarchyInWarehouse.LatestGLMinorCategoryName,
		ActivityType.BusinessLineName,
		ActivityType.ActivityTypeName,
		PropertyFund.PropertyFundName,		
		PropertyFund.PropertyFundType,
		AllocationRegion.LatestAllocationSubRegionName,
		ConsolidationRegion.LatestAllocationSubRegionName,
		OriginatingRegion.LatestOriginatingSubRegionName,
		#ProfitabilityReport.GlAccountCode,
		#ProfitabilityReport.GlAccountName,    
		Reimbursable.ReimbursableName,
		FeeAdjustment.FeeAdjustmentCode,
		#ProfitabilityReport.SourceName,
		#ProfitabilityReport.GLCategorizationHierarchyKey,
		#ProfitabilityReport.CalendarPeriod,
		#ProfitabilityReport.EntryDate,
		#ProfitabilityReport.[User],
		#ProfitabilityReport.[Description],
		#ProfitabilityReport.AdditionalDescription,
		#ProfitabilityReport.PropertyFundCode,
		#ProfitabilityReport.FunctionalDepartmentCode,
		#ProfitabilityReport.OriginatingRegionCode

END

/* ==============================================================================================================================================
	Return Results
   =========================================================================================================================================== */
BEGIN

	SELECT
		ExpenseType, 
		InflowOutflow,
		MajorExpenseCategoryName,
		MinorExpenseCategoryName,
		GlobalGlAccountCode,
		GlobalGlAccountName,
		BusinessLine,
		ActivityType,
		ReportingEntityName,
		ReportingEntityType,
		PropertyFundCode,
		FunctionalDepartmentCode,
		AllocationSubRegionName,
		OriginatingSubRegionName,
		ActualsExpensePeriod,
		EntryDate,
		[User],
		[Description],
		AdditionalDescription,
		ReimbursableName,
		FeeAdjustmentCode,
		SourceName,
		GLCategorizationHierarchyKey,

		--Gross
		--Month to date
		MtdActual,
		MtdOriginalBudget,
		CASE WHEN @ReforecastQuarterName = ''Q0'' THEN 0 ELSE MtdReforecastQ1 END AS MtdReforecastQ1,
		CASE WHEN @ReforecastQuarterName = ''Q0'' THEN 0 ELSE MtdReforecastQ2 END AS MtdReforecastQ2,
		CASE WHEN @ReforecastQuarterName = ''Q0'' THEN 0 ELSE MtdReforecastQ3 END AS MtdReforecastQ3,

		MtdVarianceQ0,
		CASE WHEN @ReforecastQuarterName = ''Q0'' THEN 0 ELSE MtdVarianceQ1 END AS MtdVarianceQ1,
		CASE WHEN @ReforecastQuarterName = ''Q0'' THEN 0 ELSE MtdVarianceQ2 END AS MtdVarianceQ2,
		CASE WHEN @ReforecastQuarterName = ''Q0'' THEN 0 ELSE MtdVarianceQ3 END AS MtdVarianceQ3,

		--Year to date
		YtdActual,	
		YtdOriginalBudget,
		CASE WHEN @ReforecastQuarterName = ''Q0'' THEN 0 ELSE YtdReforecastQ1 END AS YtdReforecastQ1,
		CASE WHEN @ReforecastQuarterName = ''Q0'' THEN 0 ELSE YtdReforecastQ2 END AS YtdReforecastQ2,
		CASE WHEN @ReforecastQuarterName = ''Q0'' THEN 0 ELSE YtdReforecastQ3 END AS YtdReforecastQ3,

		YtdVarianceQ0,
		CASE WHEN @ReforecastQuarterName = ''Q0'' THEN 0 ELSE YtdVarianceQ1 END AS YtdVarianceQ1,
		CASE WHEN @ReforecastQuarterName = ''Q0'' THEN 0 ELSE YtdVarianceQ2 END AS YtdVarianceQ2,
		CASE WHEN @ReforecastQuarterName = ''Q0'' THEN 0 ELSE YtdVarianceQ3 END AS YtdVarianceQ3,

		--Annual
		AnnualOriginalBudget,	
		CASE WHEN @ReforecastQuarterName = ''Q0'' THEN 0 ELSE AnnualReforecastQ1 END AS AnnualReforecastQ1,
		CASE WHEN @ReforecastQuarterName = ''Q0'' THEN 0 ELSE AnnualReforecastQ2 END AS AnnualReforecastQ2,
		CASE WHEN @ReforecastQuarterName = ''Q0'' THEN 0 ELSE AnnualReforecastQ3 END AS AnnualReforecastQ3,
		ConsolidationSubRegionName
	FROM
		[#Output]

END

/* ==============================================================================================================================================
	Clean Up
   =========================================================================================================================================== */
BEGIN

	IF 	OBJECT_ID(''tempdb..#ProfitabilityReport'') IS NOT NULL
		DROP TABLE #ProfitabilityReport

	IF 	OBJECT_ID(''tempdb..#OverheadFilterTable'') IS NOT NULL
		DROP TABLE #OverheadFilterTable

	IF 	OBJECT_ID(''tempdb..#AllocationSubRegionFilterTable'') IS NOT NULL
		DROP TABLE #AllocationSubRegionFilterTable

	IF 	OBJECT_ID(''tempdb..#CategorizationHierarchyFilterTable'') IS NOT NULL
		DROP TABLE #CategorizationHierarchyFilterTable

	IF 	OBJECT_ID(''tempdb..#ActivityTypeFilterTable'') IS NOT NULL
		DROP TABLE #ActivityTypeFilterTable

	IF 	OBJECT_ID(''tempdb..#EntityFilterTable'') IS NOT NULL
		DROP TABLE #EntityFilterTable

	IF 	OBJECT_ID(''tempdb..#OriginatingSubRegionFilterTable'') IS NOT NULL
		DROP TABLE #OriginatingSubRegionFilterTable

	IF 	OBJECT_ID(''tempdb..#ExchangeRate'') IS NOT NULL
		DROP TABLE #ExchangeRate

	IF 	OBJECT_ID(''tempdb..#Output'') IS NOT NULL
		DROP TABLE #Output

	IF 	OBJECT_ID(''tempdb..#FeeAdjustmentFilterTable'') IS NOT NULL
		DROP TABLE #FeeAdjustmentFilterTable

END



' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_R_MissingExchangeRates]    Script Date: 03/08/2012 12:51:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_MissingExchangeRates]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_R_MissingExchangeRates]
 
AS 
DECLARE @CurrencyCount Int

Select	DISTINCT
		''Actual'' DataSource,
		Ca.CalendarDate,
		Scu.CurrencyCode LocalCurrencyCode,
		0 NumberOfCurrencies,
		0 NumberOfDestinationCurrencies
From
		ProfitabilityActual Pa
			INNER JOIN Calendar Ca ON Ca.CalendarKey = Pa.CalendarKey
			INNER JOIN Currency Scu ON Scu.CurrencyKey = Pa.LocalCurrencyKey
			LEFT OUTER JOIN ExchangeRate Ex ON pa.LocalCurrencyKey = Ex.SourceCurrencyKey
								AND pa.CalendarKey = Ex.CalendarKey
Where Ex.SourceCurrencyKey IS NULL
UNION ALL
Select	DISTINCT
		''Budget'',
		Ca.CalendarDate,
		Scu.CurrencyCode LocalCurrencyCode,
		0 NumberOfCurrencies,
		0 NumberOfDestinationCurrencies
From
		ProfitabilityBudget Pb
			INNER JOIN Calendar Ca ON Ca.CalendarKey = Pb.CalendarKey
			INNER JOIN Currency Scu ON Scu.CurrencyKey = Pb.LocalCurrencyKey
			LEFT OUTER JOIN ExchangeRate Ex ON pb.LocalCurrencyKey = Ex.SourceCurrencyKey
								AND pb.CalendarKey = Ex.CalendarKey
Where Ex.SourceCurrencyKey IS NULL
Order By 1,2,3

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzarTotalComparisonDetail]    Script Date: 03/08/2012 12:51:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzarTotalComparisonDetail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[stp_R_ExpenseCzarTotalComparisonDetail]
	@ReportExpensePeriod INT,
	@ReforecastQuarterName VARCHAR(2), --''Q0'' or ''Q1'' or ''Q2'' or ''Q3''
	@DestinationCurrency VARCHAR(3),
	@EntityList TEXT,
	@DontSensitizeMRIPayrollData BIT = 1,
	@FunctionalDepartmentList TEXT,
	@AllocationSubRegionList TEXT,
	@HierarchyReportParameter dbo.ReportParameterGLCategorizationHierarchyDetail READONLY
AS

DECLARE
	@_ReforecastQuarterName       VARCHAR(2) = @ReforecastQuarterName,
	@_DestinationCurrency         VARCHAR(3) = @DestinationCurrency,
	@_EntityList                VARCHAR(MAX) = @EntityList,
	@_FunctionalDepartmentList VARCHAR (MAX) = @FunctionalDepartmentList,
	@_DontSensitizeMRIPayrollData        BIT = @DontSensitizeMRIPayrollData,
	@_AllocationSubRegionList   VARCHAR(MAX) = @AllocationSubRegionList,
	@ReportExpensePeriodParameter        INT = @ReportExpensePeriod

/* ==============================================================================================================================================
	Setup Variables
   =========================================================================================================================================== */	
BEGIN

	DECLARE @CalculationMethod VARCHAR(50) = ''USD''
	DECLARE @CalendarYear SMALLINT = CONVERT(SMALLINT, (SUBSTRING(CAST(@ReportExpensePeriodParameter AS VARCHAR(10)), 1, 4)))	

	DECLARE @ActiveReforecastKey INT =
		(
			SELECT
				ReforecastKey
			FROM 
				dbo.GetReforecastRecord(@ReportExpensePeriodParameter, @ReforecastQuarterName)
		)

	---- Calculate reforecast effective period from reforecast name
	DECLARE @ReforecastEffectivePeriod INT =
		(
			SELECT TOP 1
				ReforecastEffectivePeriod
			FROM
				dbo.Reforecast
			WHERE
				ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriodParameter AS VARCHAR(6)),4) AND
				ReforecastQuarterName = @ReforecastQuarterName
			ORDER BY
				ReforecastEffectivePeriod
		)

END
	
/* ======================================================================================================================================
	Mapping Tables
========================================================================================================================================= */	
BEGIN

	----------------------------------------------------------------------------
	-- Functional Departments
	----------------------------------------------------------------------------

	CREATE TABLE #FunctionalDepartmentFilterTable 
	(
		FunctionalDepartmentKey INT NOT NULL,
		FunctionalDepartmentName VARCHAR(MAX) NOT NULL,
		SubFunctionalDepartmentName VARCHAR(MAX) NOT NULL
	)

	IF (@_FunctionalDepartmentList IS NOT NULL)
	BEGIN	

		IF (@_FunctionalDepartmentList <> ''All'')
		BEGIN

			INSERT INTO #FunctionalDepartmentFilterTable
			SELECT DISTINCT
				FunctionalDepartmentLatestState.FunctionalDepartmentKey,
				FunctionalDepartmentLatestState.LatestFunctionalDepartmentName,
				FunctionalDepartmentLatestState.LatestSubFunctionalDepartmentName
			FROM
				dbo.Split(@_FunctionalDepartmentList) FunctionalDepartmentParameters
				INNER JOIN dbo.FunctionalDepartment ON
					FunctionalDepartment.FunctionalDepartmentName = FunctionalDepartmentParameters.item	
				INNER JOIN FunctionalDepartmentLatestState ON
					FunctionalDepartment.ReferenceCode = FunctionalDepartmentLatestState.FunctionalDepartmentReferenceCode

		END
		ELSE IF (@_FunctionalDepartmentList = ''All'')
		BEGIN

			INSERT INTO #FunctionalDepartmentFilterTable
			SELECT DISTINCT
				FunctionalDepartmentLatestState.FunctionalDepartmentKey,
				FunctionalDepartmentLatestState.LatestFunctionalDepartmentName,
				FunctionalDepartmentLatestState.LatestSubFunctionalDepartmentName
			FROM 
				dbo.FunctionalDepartmentLatestState

		END

	END

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
	
	----------------------------------------------------------------------------
	-- Exchange Rate
	----------------------------------------------------------------------------

	SELECT
		SourceCurrencyKey,
		DestinationCurrencyKey,
		CalendarKey,
		Rate
	INTO
		#ExchangeRate
	FROM
		dbo.ExchangeRate
	WHERE
		ReforecastKey = @ActiveReforecastKey -- We will use the exchange rate set that is active for the current reforecast.

	CREATE INDEX IX_SourceCurrencyKey ON #ExchangeRate (SourceCurrencyKey)
	CREATE INDEX IX_CalendarKey ON #ExchangeRate (CalendarKey)

	----------------------------------------------------------------------------
	-- Reporting Entity / Property Fund
	----------------------------------------------------------------------------

		CREATE TABLE #EntityFilterTable	
		(
			PropertyFundKey INT NOT NULL,
			PropertyFundName VARCHAR(MAX) NOT NULL,
			PropertyFundType VARCHAR(MAX) NOT NULL
		)

		IF (@_EntityList IS NOT NULL)
		BEGIN

			IF (@_EntityList <> ''All'')
			BEGIN

				INSERT INTO #EntityFilterTable
				SELECT DISTINCT 
					PropertyFundLatestState.PropertyFundKey,
					PropertyFundLatestState.LatestPropertyFundName,
					PropertyFundLatestState.LatestPropertyFundType
				FROM 
					dbo.Split(@_EntityList) EntityListParameters
					INNER JOIN dbo.PropertyFund ON 
						PropertyFund.PropertyFundName = EntityListParameters.item
					INNER JOIN PropertyFundLatestState ON
						PropertyFund.PropertyFundId = PropertyFundLatestState.PropertyFundId AND
						PropertyFund.SnapshotId = PropertyFundLatestState.PropertyFundSnapshotId
			END
			ELSE IF (@_EntityList = ''All'')
			BEGIN

				INSERT INTO #EntityFilterTable
				SELECT DISTINCT
					PropertyFundLatestState.PropertyFundKey,
					PropertyFundLatestState.LatestPropertyFundName AS PropertyFundName,
					PropertyFundLatestState.LatestPropertyFundType AS PropertyFundType
				FROM 
					dbo.PropertyFundLatestState

			END

		END

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable (PropertyFundKey)
	
	----------------------------------------------------------------------------
	-- Allocation Sub Region
	----------------------------------------------------------------------------

	CREATE TABLE #AllocationSubRegionFilterTable 
	(
		AllocationRegionKey INT NOT NULL,
		AllocationRegionName VARCHAR(MAX) NOT NULL,
		AllocationSubRegionName VARCHAR(MAX) NOT NULL
	)

	IF (@_AllocationSubRegionList IS NOT NULL)
	BEGIN

		IF (@_AllocationSubRegionList <> ''All'')
		BEGIN

			INSERT INTO #AllocationSubRegionFilterTable
			SELECT DISTINCT
				AllocationRegionLatestState.AllocationRegionKey,
				AllocationRegionLatestState.LatestAllocationRegionName,
				AllocationRegionLatestState.LatestAllocationSubRegionName
			FROM 
				dbo.Split(@_AllocationSubRegionList) AllocationSubRegionParameters
				INNER JOIN dbo.AllocationRegion ON
					AllocationRegion.SubRegionName = AllocationSubRegionParameters.item
				INNER JOIN dbo.AllocationRegionLatestState ON
					AllocationRegion.GlobalRegionId = AllocationRegionLatestState.AllocationRegionGlobalRegionId AND
					AllocationRegion.SnapshotId = AllocationRegionLatestState.AllocationRegionSnapshotId
					
		END
		ELSE IF (@_AllocationSubRegionList = ''All'')
		BEGIN

			INSERT INTO #AllocationSubRegionFilterTable
			SELECT DISTINCT
				AllocationRegionLatestState.AllocationRegionKey,
				AllocationRegionLatestState.LatestAllocationRegionName,
				AllocationRegionLatestState.LatestAllocationSubRegionName
			FROM
				dbo.AllocationRegionLatestState

		END

	END

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)

	----------------------------------------------------------------------------
	-- GL Categorization Hierarchy
	----------------------------------------------------------------------------

	CREATE TABLE #CategorizationHierarchyFilterTable
	(
		CategorizationHierarchyKey INT NOT NULL,
		GLCategorizationName VARCHAR(50) NOT NULL,
		GLFinancialCategoryName VARCHAR(50) NOT NULL,
		GLMajorCategoryName VARCHAR(400) NOT NULL,
		GLMinorCategoryName VARCHAR(400) NOT NULL,
		GLAccountCode VARCHAR(15) NOT NULL,
		GLAccountName VARCHAR(300) NOT NULL,
		ActivityTypeId INT NOT NULL,
		ActivityTypeKey INT NOT NULL
	)

	INSERT INTO #CategorizationHierarchyFilterTable
	SELECT DISTINCT
		GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey,
		GLCategorizationHierarchyLatestState.LatestGLCategorizationName,
		GLCategorizationHierarchyLatestState.LatestGLFinancialCategoryName,
		GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName,
		GLCategorizationHierarchyLatestState.LatestGLMinorCategoryName,
		GLCategorizationHierarchyLatestState.LatestGLAccountCode,
		GLCategorizationHierarchyLatestState.LatestGlAccountName,
		HierarchyReportParameter.ActivityTypeId,
		ActivityType.ActivityTypeKey
	FROM 
		@HierarchyReportParameter HierarchyReportParameter

		INNER JOIN dbo.ActivityType ON
			HierarchyReportParameter.ActivityTypeId = 0 OR
			HierarchyReportParameter.ActivityTypeId = ActivityType.ActivityTypeId 
		
		INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
			(
				HierarchyReportParameter.FinancialCategoryName = ''All'' OR
				HierarchyReportParameter.FinancialCategoryName = GLCategorizationHierarchyLatestState.LatestGLFinancialCategoryName
			) 
			AND
			(
				HierarchyReportParameter.GLMajorCategoryName = ''All'' OR
				HierarchyReportParameter.GLMajorCategoryName = GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName
			) 
			AND
			(
				HierarchyReportParameter.GLMinorCategoryName = ''All'' OR
				HierarchyReportParameter.GLMinorCategoryName = GLCategorizationHierarchyLatestState.LatestGLMinorCategoryName
			) 
	WHERE -- IMS 51655
		GLCategorizationHierarchyLatestState.LatestGLMinorCategoryName <> ''Architects & Engineering'' AND	
		GLCategorizationHierarchyLatestState.LatestInflowOutflow = ''Outflow''

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #CategorizationHierarchyFilterTable (CategorizationHierarchyKey, ActivityTypeKey)

END

/* =============================================================================================================================================
	Create temporary table into which data for this report will be inserted
   =========================================================================================================================================== */	
BEGIN

	CREATE TABLE #ExpenseCzarTotalComparisonDetail
	(	
		GLCategorizationHierarchyKey	INT,
		AllocationRegionKey				INT,
		OriginatingRegionKey			INT,
		FunctionalDepartmentKey			INT,
		PropertyFundKey					INT,
		SourceName						VARCHAR(50),
		EntryDate						VARCHAR(10),
		[User]							NVARCHAR(20),
		[Description]					NVARCHAR(60),
		AdditionalDescription			NVARCHAR(4000),
		PropertyFundCode				VARCHAR(11) DEFAULT(''''),
		OriginatingRegionCode			VARCHAR(30) DEFAULT(''''),
		FunctionalDepartmentCode		VARCHAR(15) DEFAULT(''''),
		GlAccountCode					VARCHAR(15) DEFAULT(''''),
		GlAccountName					VARCHAR(300) DEFAULT(''''),
		CalendarPeriod					VARCHAR(6) DEFAULT(''''),
		
		--Month to date	
		MtdGrossActual					MONEY,
		MtdGrossBudget					MONEY,
		MtdGrossReforecast				MONEY,
		MtdNetActual					MONEY,
		MtdNetBudget					MONEY,
		MtdNetReforecast				MONEY,
		
		--Year to date
		YtdGrossActual					MONEY,	
		YtdGrossBudget					MONEY, 
		YtdGrossReforecast				MONEY,
		YtdNetActual					MONEY, 
		YtdNetBudget					MONEY, 
		YtdNetReforecast				MONEY,

		--Annual	
		AnnualGrossBudget				MONEY,
		AnnualGrossReforecast			MONEY,
		AnnualNetBudget					MONEY,
		AnnualNetReforecast				MONEY,
		
		--Annual estimated
		AnnualEstGrossBudget			MONEY,
		AnnualEstGrossReforecast		MONEY,
		AnnualEstNetBudget				MONEY,
		AnnualEstNetReforecast			MONEY

	)
	CREATE INDEX IX_AllocationRegionKey ON #ExpenseCzarTotalComparisonDetail (AllocationRegionKey)
	CREATE INDEX IX_OriginatingRegionKey ON #ExpenseCzarTotalComparisonDetail (OriginatingRegionKey)
	CREATE INDEX IX_PropertyFundKey ON #ExpenseCzarTotalComparisonDetail (PropertyFundKey)
	CREATE INDEX IX_FunctionalDepartmentKey ON #ExpenseCzarTotalComparisonDetail (FunctionalDepartmentKey)
	CREATE INDEX IX_GLCategorizationHierarchyKey ON #ExpenseCzarTotalComparisonDetail (GLCategorizationHierarchyKey)

END

/* ======================================================================================================================================
	Add Actuals
========================================================================================================================================= */	
BEGIN

	INSERT INTO #ExpenseCzarTotalComparisonDetail
	(
		GLCategorizationHierarchyKey,
		AllocationRegionKey,
		OriginatingRegionKey,
		FunctionalDepartmentKey,
		PropertyFundKey,
		SourceName,
		EntryDate,
		[User],
		[Description],
		AdditionalDescription,
		PropertyFundCode,
		OriginatingRegionCode,
		FunctionalDepartmentCode,
		GlAccountCode,
		GlAccountName,
		CalendarPeriod,
		
		--Month to date	
		MtdGrossActual,
		MtdGrossBudget,
		MtdGrossReforecast,
		MtdNetActual,
		MtdNetBudget,
		MtdNetReforecast,
		
		--Year to date
		YtdGrossActual,
		YtdGrossBudget, 
		YtdGrossReforecast,
		YtdNetActual, 
		YtdNetBudget,
		YtdNetReforecast,

		--Annual	
		AnnualGrossBudget,
		AnnualGrossReforecast,
		AnnualNetBudget,
		AnnualNetReforecast,
		
		--Annual estimated
		AnnualEstGrossBudget,
		AnnualEstGrossReforecast,
		AnnualEstNetBudget,
		AnnualEstNetReforecast		

	)
	SELECT --TOP 0
		ProfitabilityActual.GlobalGLCategorizationHierarchyKey AS ''GLCategorizationHierarchyKey'',
		ProfitabilityActual.AllocationRegionKey,
		ProfitabilityActual.OriginatingRegionKey,
		ProfitabilityActual.FunctionalDepartmentKey,
		ProfitabilityActual.PropertyFundKey,	
		CASE
			WHEN
				@DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.LatestGLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''
			ELSE
				[Source].SourceName
		END AS ''SourceName'',
		CONVERT(VARCHAR(10), ISNULL(ProfitabilityActual.LastDate, ''''), 101) AS ''EntryDate'',
		ProfitabilityActual.[User],
		ProfitabilityActual.[Description],
		ProfitabilityActual.AdditionalDescription,
		CASE
			WHEN
				@DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.LatestGLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''
			ELSE
				ProfitabilityActual.PropertyFundCode
		END AS ''PropertyFundCode'',
		CASE
			WHEN
				@DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.LatestGLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''
			ELSE
				ProfitabilityActual.OriginatingRegionCode
		END AS ''OriginatingRegionCode'',
		ProfitabilityActual.FunctionalDepartmentCode,
		GlobalGLCategorizationHierarchy.LatestGlAccountCode,
		GlobalGLCategorizationHierarchy.LatestGlAccountName,
		Calendar.CalendarPeriod,

		-- MTD Gross
		SUM
		(
			#ExchangeRate.Rate *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod = @ReportExpensePeriodParameter
					THEN
						ProfitabilityActual.LocalActual
					ELSE
						0.0
				END
			)
		) AS ''MtdGrossActual'',
		NULL AS ''MtdGrossBudget'',
		NULL AS ''MtdGrossReforecast'',

		-- MTD Net
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod = @ReportExpensePeriodParameter
					THEN
						ProfitabilityActual.LocalActual
					ELSE
						0.0
				END
			)
		) AS ''MtdNetActual'',
		NULL AS ''MtdNetBudget'',
		NULL AS ''MtdNetReforecast'',

		SUM
		(
			#ExchangeRate.Rate *
			(
				CASE 
					WHEN
						Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
					THEN
						ProfitabilityActual.LocalActual
					ELSE
						0.0
				END
			)
		) AS ''YtdGrossActual'',
		NULL AS ''YtdGrossBudget'',
		NULL AS ''YtdGrossReforecast'',

		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
					THEN
						ProfitabilityActual.LocalActual
					ELSE
						0.0
				END
			)
		) AS ''YtdNetActual'',
		NULL AS ''YtdNetBudget'',
		NULL AS ''YtdNetReforecast'',

		NULL AS ''AnnualGrossBudget'',
		NULL AS ''AnnualGrossReforecast'',

		NULL AS ''AnnualNetBudget'',
		NULL AS ''AnnualNetReforecast'',
		SUM
		(
			#ExchangeRate.Rate *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
					THEN
						ProfitabilityActual.LocalActual
					ELSE
						0.0
				END
			)
		) AS ''AnnualEstGrossBudget'',
		NULL AS ''AnnualEstGrossReforecast'',
		NULL AS ''AnnualEstNetBudget'',
		NULL AS ''AnnualEstNetReforecast''
	FROM
		dbo.ProfitabilityActual

		INNER JOIN #EntityFilterTable ON
			ProfitabilityActual.PropertyFundKey = #EntityFilterTable.PropertyFundKey

		INNER JOIN GLCategorizationHierarchyLatestState GlobalGLCategorizationHierarchy ON 
			GlobalGLCategorizationHierarchy.GLCategorizationHierarchyKey = ProfitabilityActual.GlobalGLCategorizationHierarchyKey 	

		INNER JOIN #CategorizationHierarchyFilterTable GlHierarchy ON 
			GlHierarchy.CategorizationHierarchyKey = ProfitabilityActual.GlobalGLCategorizationHierarchyKey AND
			(GlHierarchy.ActivityTypeKey = ProfitabilityActual.ActivityTypeKey)

		INNER JOIN #AllocationSubRegionFilterTable ON
			ProfitabilityActual.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey			

		INNER JOIN #FunctionalDepartmentFilterTable ON
			ProfitabilityActual.FunctionalDepartmentKey = #FunctionalDepartmentFilterTable.FunctionalDepartmentKey

		INNER JOIN dbo.[Source] ON
			ProfitabilityActual.SourceKey = Source.SourceKey

		INNER JOIN dbo.Reimbursable ON
			ProfitabilityActual.ReimbursableKey = Reimbursable.ReimbursableKey

		INNER JOIN dbo.Overhead ON
			ProfitabilityActual.OverheadKey = Overhead.OverheadKey

		INNER JOIN dbo.Calendar ON
			ProfitabilityActual.CalendarKey = Calendar.CalendarKey

		INNER JOIN #ExchangeRate ON
			ProfitabilityActual.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
			ProfitabilityActual.CalendarKey = #ExchangeRate.CalendarKey

		INNER JOIN dbo.Currency ON
			#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey
	WHERE
		GlobalGLCategorizationHierarchy.LatestInflowOutflow IN
		(
			''Outflow'',
			''UNKNOWN''
		) AND
		Calendar.CalendarYear = @CalendarYear AND
		Currency.CurrencyCode = @_DestinationCurrency
	GROUP BY
		ProfitabilityActual.GlobalGLCategorizationHierarchyKey,
		ProfitabilityActual.AllocationRegionKey,
		ProfitabilityActual.OriginatingRegionKey,
		ProfitabilityActual.FunctionalDepartmentKey,
		ProfitabilityActual.PropertyFundKey,
		Calendar.CalendarPeriod,
		CASE
			WHEN
				@DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.LatestGLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''	
			ELSE
				[Source].SourceName
		END,
		CONVERT(VARCHAR(10), ISNULL(ProfitabilityActual.LastDate,''''), 101),
		ProfitabilityActual.[User],
		ProfitabilityActual.[Description],
		ProfitabilityActual.AdditionalDescription,
		CASE
			WHEN
				@DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.LatestGLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''
			ELSE
				ProfitabilityActual.PropertyFundCode
		END,
		CASE
			WHEN
				@DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.LatestGLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''
			ELSE
				ProfitabilityActual.OriginatingRegionCode
		END,
		ProfitabilityActual.FunctionalDepartmentCode,
		GlobalGLCategorizationHierarchy.LatestGlAccountCode,
		GlobalGLCategorizationHierarchy.LatestGlAccountName

END

/* ======================================================================================================================================
	Add Budgets
========================================================================================================================================= */	
BEGIN

	INSERT INTO #ExpenseCzarTotalComparisonDetail
	(
		GLCategorizationHierarchyKey,
		AllocationRegionKey,
		OriginatingRegionKey,
		FunctionalDepartmentKey,
		PropertyFundKey,
		SourceName,
		EntryDate,
		[User],
		[Description],
		AdditionalDescription,
		PropertyFundCode,
		OriginatingRegionCode,
		FunctionalDepartmentCode,
		GlAccountCode,
		GlAccountName,
		CalendarPeriod,

		-- MTD Gross
		MtdGrossActual,
		MtdGrossBudget,
		MtdGrossReforecast,

		-- MTD Net
		MtdNetActual,
		MtdNetBudget,
		MtdNetReforecast,

		-- YTD Gross
		YtdGrossActual,
		YtdGrossBudget, 
		YtdGrossReforecast,

		-- YTD Net
		YtdNetActual, 
		YtdNetBudget,
		YtdNetReforecast,

		-- Annual Gross
		AnnualGrossBudget,
		AnnualGrossReforecast,

		-- Annual Net
		AnnualNetBudget,
		AnnualNetReforecast,

		-- Annual Estimated Gross
		AnnualEstGrossBudget,
		AnnualEstGrossReforecast,

		-- Annual Estimated Net
		AnnualEstNetBudget,
		AnnualEstNetReforecast
	)
	SELECT
		ProfitabilityBudget.GlobalGLCategorizationHierarchyKey AS ''GLCategorizationHierarchyKey'',
		ProfitabilityBudget.AllocationRegionKey,
		ProfitabilityBudget.OriginatingRegionKey,
		ProfitabilityBudget.FunctionalDepartmentKey,
		ProfitabilityBudget.PropertyFundKey,	
		CASE
			WHEN
				@DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.LatestGLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''	
			ELSE
				[Source].SourceName
		END AS ''SourceName'',
		'''' AS ''EntryDate'',
		'''' AS ''User'',
		'''' AS ''Description'',
		'''' AS ''AdditionalDescription'',
		'''' AS ''PropertyFundCode'',
		'''' AS ''OriginatingRegionCode'',
		'''' AS ''FunctionalDepartmentCode'',
		GlHierarchy.GlAccountCode,
		GlHierarchy.GlAccountName,
		Calendar.CalendarPeriod,

		-- Gross MTD Actuals
		NULL AS ''MtdGrossActual'',
		SUM
		(
			#ExchangeRate.Rate *
			(
				CASE 
					WHEN
						Calendar.CalendarPeriod = @ReportExpensePeriodParameter
					THEN
						ProfitabilityBudget.LocalBudget
					ELSE
						0.0
				END
			)
		) AS ''MtdGrossBudget'',
		NULL AS ''MtdGrossReforecast'',

		-- MTD Net Actuals
		NULL AS ''MtdNetActual'',
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod = @ReportExpensePeriodParameter
					THEN
						ProfitabilityBudget.LocalBudget
					ELSE
						0.0
				END
			)
		) AS ''MtdNetBudget'',
		NULL AS ''MtdNetReforecast'',
		
		-- YTD Gross
		NULL AS ''YtdGrossActual'',
		SUM
		(
			#ExchangeRate.Rate *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
					THEN
						ProfitabilityBudget.LocalBudget
					ELSE
						0
				END
			)
		) AS ''YtdGrossBudget'',
		NULL AS ''YtdGrossReforecast'',

		-- YTD Net
		NULL AS ''YtdNetActual'',
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
					THEN
						ProfitabilityBudget.LocalBudget
					ELSE
						0.0
				END
			)
		) AS ''YtdNetBudget'',
		NULL AS ''YtdNetReforecast'',

		-- Annual
		SUM
		(
			#ExchangeRate.Rate *
			ProfitabilityBudget.LocalBudget
		) AS ''AnnualGrossBudget'',
		NULL AS ''AnnualGrossReforecast'',
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			ProfitabilityBudget.LocalBudget
		) AS ''AnnualNetBudget'',
		NULL AS ''AnnualNetReforecast'',
		
		--Annual estimated
		SUM
		(
			#ExchangeRate.Rate *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
					THEN
						ProfitabilityBudget.LocalBudget
					ELSE
						0.0
			END
			)
		) AS ''AnnualEstGrossBudget'',		
		NULL AS ''AnnualEstGrossReforecast'',	
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
					THEN
						ProfitabilityBudget.LocalBudget
					ELSE
						0.0
				END
			)
		) AS ''AnnualEstNetBudget'',
		NULL AS ''AnnualEstNetReforecast''
	FROM
		dbo.ProfitabilityBudget

		INNER JOIN #EntityFilterTable ON
			ProfitabilityBudget.PropertyFundKey = #EntityFilterTable.PropertyFundKey

		INNER JOIN dbo.GLCategorizationHierarchyLatestState GlobalGLCategorizationHierarchy ON 
			GlobalGLCategorizationHierarchy.GLCategorizationHierarchyKey = ProfitabilityBudget.GlobalGLCategorizationHierarchyKey

		INNER JOIN #CategorizationHierarchyFilterTable GlHierarchy ON 
			GlHierarchy.CategorizationHierarchyKey = ProfitabilityBudget.GlobalGLCategorizationHierarchyKey AND
			(GlHierarchy.ActivityTypeKey = ProfitabilityBudget.ActivityTypeKey)

		INNER JOIN #AllocationSubRegionFilterTable ON
			ProfitabilityBudget.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey			

		INNER JOIN #FunctionalDepartmentFilterTable ON
			ProfitabilityBudget.FunctionalDepartmentKey = #FunctionalDepartmentFilterTable.FunctionalDepartmentKey

		INNER JOIN dbo.[Source] ON
			ProfitabilityBudget.SourceKey = Source.SourceKey

		INNER JOIN dbo.Reimbursable ON
			ProfitabilityBudget.ReimbursableKey = Reimbursable.ReimbursableKey

		INNER JOIN dbo.Calendar ON
			ProfitabilityBudget.CalendarKey = Calendar.CalendarKey

		INNER JOIN #ExchangeRate ON
			ProfitabilityBudget.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
			ProfitabilityBudget.CalendarKey = #ExchangeRate.CalendarKey

		INNER JOIN dbo.Currency ON
			#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey

		INNER JOIN dbo.Overhead ON
			ProfitabilityBudget.OverheadKey = Overhead.OverheadKey		
	WHERE 
		GlobalGLCategorizationHierarchy.LatestInflowOutflow IN
		(
				''Outflow'', 
				''UNKNOWN''
		) AND
		Calendar.CalendarYear = @CalendarYear AND
		Currency.CurrencyCode = @_DestinationCurrency	
	GROUP BY
		ProfitabilityBudget.GlobalGLCategorizationHierarchyKey,
		ProfitabilityBudget.AllocationRegionKey,
		ProfitabilityBudget.OriginatingRegionKey,
		ProfitabilityBudget.FunctionalDepartmentKey,
		ProfitabilityBudget.PropertyFundKey,
		Calendar.CalendarPeriod,
		CASE
			WHEN
				@DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.LatestGLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN 
				''Sensitized''
			ELSE
				[Source].SourceName
		END,
		GlHierarchy.GlAccountCode,
		GlHierarchy.GlAccountName

END

/* ======================================================================================================================================
	Add Reforecasts
========================================================================================================================================= */	
BEGIN

	IF @ReforecastQuarterName IN (''Q1'', ''Q2'', ''Q3'')
	BEGIN
		INSERT INTO #ExpenseCzarTotalComparisonDetail
		(
			GLCategorizationHierarchyKey,
			AllocationRegionKey,
			OriginatingRegionKey,
			FunctionalDepartmentKey,
			PropertyFundKey,
			SourceName,
			EntryDate,
			[User],
			[Description],
			AdditionalDescription,
			PropertyFundCode,
			OriginatingRegionCode,
			FunctionalDepartmentCode,
			GlAccountCode,
			GlAccountName,
			CalendarPeriod,

			--Month to date	
			MtdGrossActual,
			MtdGrossBudget,
			MtdGrossReforecast,

			MtdNetActual,
			MtdNetBudget,
			MtdNetReforecast,

			--Year to date
			YtdGrossActual,
			YtdGrossBudget,
			YtdGrossReforecast,

			YtdNetActual,
			YtdNetBudget,
			YtdNetReforecast,

			--Annual
			AnnualGrossBudget,
			AnnualGrossReforecast,
			AnnualNetBudget,
			AnnualNetReforecast,
			
			--Annual estimated
			AnnualEstGrossBudget,
			AnnualEstGrossReforecast,
			AnnualEstNetBudget,
			AnnualEstNetReforecast
		)
		SELECT
			ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey AS ''GLCategorizationHierarchyKey'',
			ProfitabilityReforecast.AllocationRegionKey,
			ProfitabilityReforecast.OriginatingRegionKey,
			ProfitabilityReforecast.FunctionalDepartmentKey,
			ProfitabilityReforecast.PropertyFundKey,
			CASE
				WHEN
					@DontSensitizeMRIPayrollData = 0 AND GlHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
				THEN
					''Sensitized''
				ELSE
					[Source].SourceName
			END AS ''SourceName'',
			'''' AS ''EntryDate'',
			'''' AS ''User'',
			'''' AS ''Description'',
			'''' as ''AdditionalDescription'',
			'''' AS ''PropertyFundCode'',
			'''' AS ''OriginatingRegionCode'',
			'''' AS ''FunctionalDepartmentCode'',
			GlHierarchy.GlAccountCode,
			GlHierarchy.GlAccountName,
			Calendar.CalendarPeriod,

			-- MTD Gross
			NULL AS ''MtdGrossActual'',
			NULL AS ''MtdGrossBudget'',
			SUM
			(
				#ExchangeRate.Rate *
				(
					CASE
						WHEN
							Calendar.CalendarPeriod = @ReportExpensePeriodParameter
						THEN
							ProfitabilityReforecast.LocalReforecast
						ELSE
							0.0
					END
				)
			) AS ''MtdGrossReforecast'',		

			-- MTD Net		
			NULL AS ''MtdNetActual'',
			NULL AS ''MtdNetBudget'',		
			SUM
			(
				#ExchangeRate.Rate *
				Reimbursable.MultiplicationFactor *
				(
					CASE
						WHEN
							Calendar.CalendarPeriod = @ReportExpensePeriodParameter
						THEN 
							ProfitabilityReforecast.LocalReforecast
						ELSE
							0
					END
				)
			) AS ''MtdNetReforecast'',

			-- YTD Gross
			NULL AS ''YtdGrossActual'',
			NULL AS ''YtdGrossBudget'',
			SUM
			(
				#ExchangeRate.Rate *
				(
					CASE
						WHEN
							Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
						THEN
							ProfitabilityReforecast.LocalReforecast
						ELSE
							0.0
					END
				)
			) AS ''YtdGrossReforecast'',

			-- YTD Net
			NULL AS ''YtdNetActual'', 	
			NULL AS ''YtdNetBudget'',
			SUM
			(
				#ExchangeRate.Rate *
				Reimbursable.MultiplicationFactor *
				(
					CASE
						WHEN
							Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
						THEN
							ProfitabilityReforecast.LocalReforecast
						ELSE
							0.0
					END
				)
			) AS ''YtdNetReforecast'',

			-- Annual Gross
			NULL AS AnnualGrossBudget,
			SUM
			(
				#ExchangeRate.Rate *
				ProfitabilityReforecast.LocalReforecast
			) AS ''AnnualGrossReforecast'',		

			-- Annual Net
			NULL AS AnnualNetBudget,
			SUM
			(
				#ExchangeRate.Rate *
				Reimbursable.MultiplicationFactor *
				ProfitabilityReforecast.LocalReforecast
			) AS ''AnnualNetReforecast'',

			-- Annual Estimated Gross
			NULL AS ''AnnualEstGrossBudget'',
			SUM
			(
				#ExchangeRate.Rate *
				(
					CASE
						WHEN
						(
							Calendar.CalendarPeriod > @ReportExpensePeriodParameter OR 
							(
								LEFT (ProfitabilityReforecast.ReferenceCode, 3) = ''BC:'' AND
								STR(@ReforecastEffectivePeriod,6,0) IN 
								(
									201003,
									201006,
									201009
								)
							)
						)
						THEN
							ProfitabilityReforecast.LocalReforecast
						ELSE
							0.0
					END
				)
			) AS ''AnnualEstGrossReforecast'',

			-- Annual Estimated Gross	
			NULL AS ''AnnualEstNetBudget'',
			SUM
			(
				#ExchangeRate.Rate *
				(
					CASE
						WHEN
						(
							Calendar.CalendarPeriod > @ReportExpensePeriodParameter OR
							(
								LEFT (ProfitabilityReforecast.ReferenceCode, 3) = ''BC:'' AND
								STR(@ReforecastEffectivePeriod,6,0) IN
								(
									201003,
									201006,
									201009
								)
							)
						)
						THEN
							ProfitabilityReforecast.LocalReforecast
						ELSE
							0.0
					END
				)
			) AS ''AnnualEstNetReforecast''
		FROM
			dbo.ProfitabilityReforecast

			INNER JOIN #EntityFilterTable ON
				ProfitabilityReforecast.PropertyFundKey = #EntityFilterTable.PropertyFundKey

			INNER JOIN dbo.GLCategorizationHierarchyLatestState GlobalGLCategorizationHierarchy ON 
				GlobalGLCategorizationHierarchy.GLCategorizationHierarchyKey = ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey

			INNER JOIN #CategorizationHierarchyFilterTable GlHierarchy ON 
				GlHierarchy.CategorizationHierarchyKey = ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey AND
				(GlHierarchy.ActivityTypeKey = ProfitabilityReforecast.ActivityTypeKey)

			INNER JOIN #AllocationSubRegionFilterTable ON
				ProfitabilityReforecast.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey

			INNER JOIN #ExchangeRate ON
				ProfitabilityReforecast.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
				ProfitabilityReforecast.CalendarKey = #ExchangeRate.CalendarKey

			INNER JOIN #FunctionalDepartmentFilterTable ON
				ProfitabilityReforecast.FunctionalDepartmentKey = #FunctionalDepartmentFilterTable.FunctionalDepartmentKey

			INNER JOIN dbo.Currency ON
				#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey

			INNER JOIN dbo.Overhead ON
				ProfitabilityReforecast.OverheadKey = Overhead.OverheadKey

			INNER JOIN dbo.Calendar ON
				ProfitabilityReforecast.CalendarKey = Calendar.CalendarKey

			INNER JOIN dbo.Reforecast ON
				ProfitabilityReforecast.ReforecastKey = Reforecast.ReforecastKey

			INNER JOIN dbo.[Source] ON
				ProfitabilityReforecast.SourceKey = [Source].SourceKey

			INNER JOIN dbo.Reimbursable ON
				ProfitabilityReforecast.ReimbursableKey = Reimbursable.ReimbursableKey
		WHERE 
			GlobalGLCategorizationHierarchy.LatestInflowOutflow IN
			(
				''Outflow'',
				''UNKNOWN''
			) AND
			Reforecast.ReforecastEffectivePeriod = @ReforecastEffectivePeriod AND
			Calendar.CalendarYear = @CalendarYear AND
			Currency.CurrencyCode = @_DestinationCurrency
		GROUP BY
			GlHierarchy.GlAccountCode,
			GlHierarchy.GlAccountName,
			Calendar.CalendarPeriod,
			ProfitabilityReforecast.ActivityTypeKey,
			ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey,
			ProfitabilityReforecast.AllocationRegionKey,
			ProfitabilityReforecast.OriginatingRegionKey,
			ProfitabilityReforecast.FunctionalDepartmentKey,
			ProfitabilityReforecast.PropertyFundKey,			
			CASE
				WHEN
					@DontSensitizeMRIPayrollData = 0 AND GlHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
				THEN
					''Sensitized''
				ELSE
					[Source].SourceName
			END,
			CASE
				WHEN
					@DontSensitizeMRIPayrollData = 0 AND GlHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
				THEN
					NULL
				ELSE
					GlHierarchy.GlAccountCode
			END,
			CASE
				WHEN
					@DontSensitizeMRIPayrollData = 0 AND GlHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
				THEN
					NULL	
				ELSE
					GlHierarchy.GlAccountName
			END

	END -- END IF

END

/* ==============================================================================================================================================
	Select Output
   =========================================================================================================================================== */	

SELECT
	AllocationRegion.AllocationRegionName AS ''AllocationRegionName'',
	AllocationRegion.AllocationSubRegionName AS ''AllocationSubRegionName'',
	OriginatingRegion.RegionName AS ''OriginatingRegionName'',
	OriginatingRegion.SubRegionName AS ''OriginatingSubRegionName'',
	FunctionalDepartment.FunctionalDepartmentName AS ''FunctionalDepartmentName'',
	FunctionalDepartment.SubFunctionalDepartmentName AS ''JobCode'',
	GLCategorizationHierarchyLatestState.LatestGLFinancialCategoryName AS ''FinancialCategoryName'',
	GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS ''MajorExpenseCategoryName'',
	GLCategorizationHierarchyLatestState.LatestGLMinorCategoryName AS ''MinorExpenseCategoryName'',
	PropertyFund.PropertyFundType AS ''EntityType'',
	PropertyFund.PropertyFundName AS ''EntityName'',
	#ExpenseCzarTotalComparisonDetail.CalendarPeriod AS ''ExpensePeriod'',
	#ExpenseCzarTotalComparisonDetail.EntryDate AS ''EntryDate'',
	#ExpenseCzarTotalComparisonDetail.[User] AS ''User'',
	#ExpenseCzarTotalComparisonDetail.[Description] AS ''Description'',
	#ExpenseCzarTotalComparisonDetail.[AdditionalDescription] AS ''AdditionalDescription'',
	#ExpenseCzarTotalComparisonDetail.SourceName AS ''SourceName'',
	#ExpenseCzarTotalComparisonDetail.PropertyFundCode AS ''PropertyFundCode'',
	CASE 
		WHEN (SUBSTRING(#ExpenseCzarTotalComparisonDetail.SourceName, CHARINDEX('' '', #ExpenseCzarTotalComparisonDetail.SourceName) +1, 8) = ''Property'') THEN RTRIM(#ExpenseCzarTotalComparisonDetail.OriginatingRegionCode) + LTRIM(#ExpenseCzarTotalComparisonDetail.FunctionalDepartmentCode) 
		ELSE #ExpenseCzarTotalComparisonDetail.OriginatingRegionCode 
	END AS ''OriginatingRegionCode'',
	ISNULL (#ExpenseCzarTotalComparisonDetail.GlAccountCode, '''') AS ''GlAccountCode'',
	ISNULL (#ExpenseCzarTotalComparisonDetail.GlAccountName, '''') AS ''GlAccountName'',
			
	--Month to date    
	SUM(
		ISNULL(MtdGrossActual,0) 
		
	) AS ''MtdActual'',
	SUM(
		ISNULL(MtdGrossBudget,0) 
	) AS ''MtdOriginalBudget'',
	
	SUM(
			ISNULL(
					CASE 
						WHEN @ReforecastQuarterName = ''Q0'' THEN MtdGrossBudget 
						ELSE MtdGrossReforecast
					END,
					0
				) 
			
		) 
	AS ''MtdReforecast'',
	
	SUM(
		ISNULL(
			CASE 
				WHEN @ReforecastQuarterName = ''Q0'' THEN MtdGrossBudget 
				ELSE MtdGrossReforecast
			END, 
			0
		) - ISNULL(MtdGrossActual, 0) 
	) 
	AS ''MtdVariance'',
	
	--Year to date
	SUM(
		ISNULL(YtdGrossActual,0) 
		
	) AS ''YtdActual'',	
	
	SUM(
			ISNULL(YtdGrossBudget,0) 
			
	) AS ''YtdOriginalBudget'',
	
	SUM(
		ISNULL(
			CASE 
				WHEN @ReforecastQuarterName = ''Q0'' THEN YtdGrossBudget 
				ELSE YtdGrossReforecast
			END,
			0
		) 
		
	) 
	AS ''YtdReforecast'',
	
	SUM(
		ISNULL(
			CASE 
				WHEN @ReforecastQuarterName = ''Q0'' THEN YtdGrossBudget 
				ELSE YtdGrossReforecast
			END, 
		0
		) - ISNULL(YtdGrossActual, 0) 			
	) 
	AS ''YtdVariance'',
		
	--Annual
	SUM(
		ISNULL(AnnualGrossBudget,0) 			
	) AS ''AnnualOriginalBudget'',
	
	SUM(			
		ISNULL(
			CASE 
				WHEN @ReforecastQuarterName = ''Q0'' THEN 0 
				ELSE AnnualGrossReforecast
			END,
			0
		)			
	) AS ''AnnualReforecast'',
	GLCategorizationHierarchyLatestState.LatestGLFinancialCategoryName AS FinancialCategory

INTO
	#Output

FROM 
	#ExpenseCzarTotalComparisonDetail 
	INNER JOIN #AllocationSubRegionFilterTable AllocationRegion ON
		#ExpenseCzarTotalComparisonDetail.AllocationRegionKey = AllocationRegion.AllocationRegionKey
		
	INNER JOIN OriginatingRegion ON
		#ExpenseCzarTotalComparisonDetail.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey
		
	INNER JOIN #EntityFilterTable PropertyFund On
		#ExpenseCzarTotalComparisonDetail.PropertyFundKey = PropertyFund.PropertyFundKey
		
	INNER JOIN #FunctionalDepartmentFilterTable FunctionalDepartment ON
		#ExpenseCzarTotalComparisonDetail.FunctionalDepartmentKey = FunctionalDepartment.FunctionalDepartmentKey
		
	INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
		#ExpenseCzarTotalComparisonDetail.GLCategorizationHierarchyKey = GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey
		
	GROUP BY
		GLCategorizationHierarchyLatestState.LatestInflowOutflow,
		AllocationRegion.AllocationRegionName,
		AllocationRegion.AllocationSubRegionName,
		OriginatingRegion.RegionName,
		OriginatingRegion.SubRegionName,
		FunctionalDepartment.FunctionalDepartmentName,
		FunctionalDepartment.SubFunctionalDepartmentName,
		GLCategorizationHierarchyLatestState.LatestGLFinancialCategoryName,
		GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName,
		GLCategorizationHierarchyLatestState.LatestGLMinorCategoryName,
		PropertyFund.PropertyFundType,
		PropertyFund.PropertyFundName,
		#ExpenseCzarTotalComparisonDetail.CalendarPeriod,
		#ExpenseCzarTotalComparisonDetail.EntryDate,
		#ExpenseCzarTotalComparisonDetail.[User],
		#ExpenseCzarTotalComparisonDetail.[Description],
		#ExpenseCzarTotalComparisonDetail.[AdditionalDescription],
		#ExpenseCzarTotalComparisonDetail.SourceName,
		#ExpenseCzarTotalComparisonDetail.PropertyFundCode,
		CASE 
			WHEN (SUBSTRING(#ExpenseCzarTotalComparisonDetail.SourceName, CHARINDEX('' '', #ExpenseCzarTotalComparisonDetail.SourceName) +1, 8) = ''Property'') THEN RTRIM(#ExpenseCzarTotalComparisonDetail.OriginatingRegionCode) + LTRIM(#ExpenseCzarTotalComparisonDetail.FunctionalDepartmentCode) 
			ELSE #ExpenseCzarTotalComparisonDetail.OriginatingRegionCode 
		END,
		ISNULL (#ExpenseCzarTotalComparisonDetail.GlAccountCode, ''''),
		ISNULL (#ExpenseCzarTotalComparisonDetail.GlAccountName, '''')

/* ======================================================================================================================================
	SELECT FINAL OUTPUT
========================================================================================================================================= */	

	SELECT
		FinancialCategory,
		MajorExpenseCategoryName,
		MinorExpenseCategoryName,
		AllocationSubRegionName,
		AllocationSubRegionName AS AllocationSubRegionFilterName,
		OriginatingRegionName,
		OriginatingSubRegionName,
		OriginatingSubRegionName AS OriginatingRegionFilterName,
		EntityType AS ''EntityType'',
		EntityName AS ''EntityName'',
		EntityName AS EntityFilterName,
		FunctionalDepartmentName,
		FunctionalDepartmentName AS FunctionalDepartmentFilterName,
		ExpensePeriod AS ActualsExpensePeriod,
		EntryDate,
		[User] AS ''User'',
		CASE 
			WHEN (
					AnnualOriginalBudget <> 0 OR 
					AnnualReforecast <> 0
				) AND  
				(
					MtdActual = 0 OR 
					YtdActual = 0
				) THEN ''[BUDGET/REFORECAST]'' 
			ELSE Description 
		END AS ''Description'',
		AdditionalDescription,
		SourceName,
		PropertyFundCode,
		OriginatingRegionCode,
		GlAccountCode,
		GlAccountName,
		--Month to date    
		MtdActual,
		MtdOriginalBudget,
		MtdReforecast,
		MtdVariance,
		
		--Year to date
		YtdActual,
		YtdOriginalBudget,
		YtdReforecast,
		YtdVariance,

		--Annual
		AnnualOriginalBudget,
		AnnualReforecast
	FROM 
		#Output
	WHERE
		--Month to date    
		MtdActual <> 0.00 OR
		MtdOriginalBudget <> 0.00 OR
		MtdReforecast <> 0.00 OR
		MtdVariance <> 0.00 OR
		
		YtdActual <> 0.00 OR
		YtdOriginalBudget <> 0.00 OR
		YtdReforecast <> 0.00 OR
		YtdVariance <> 0.00 OR

		AnnualOriginalBudget <> 0.00 OR
		AnnualReforecast <> 0.00 

/* ======================================================================================================================================
	CleanUp
========================================================================================================================================= */	

IF 	OBJECT_ID(''tempdb..#Output'') IS NOT NULL
    DROP TABLE #Output

IF 	OBJECT_ID(''tempdb..#ExpenseCzarTotalComparisonDetail'') IS NOT NULL
    DROP TABLE #ExpenseCzarTotalComparisonDetail

IF 	OBJECT_ID(''tempdb..#ExchangeRate'') IS NOT NULL
    DROP TABLE #ExchangeRate

IF 	OBJECT_ID(''tempdb..#EntityFilterTable'') IS NOT NULL
    DROP TABLE #EntityFilterTable

IF 	OBJECT_ID(''tempdb..#AllocationSubRegionFilterTable'') IS NOT NULL
    DROP TABLE #AllocationSubRegionFilterTable

IF 	OBJECT_ID(''tempdb..#CategorizationHierarchyFilterTable'') IS NOT NULL
    DROP TABLE #CategorizationHierarchyFilterTable

IF 	OBJECT_ID(''tempdb..#FunctionalDepartmentFilterTable'') IS NOT NULL
    DROP TABLE #FunctionalDepartmentFilterTable




' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOwner]    Script Date: 03/08/2012 12:51:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOwner]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_R_BudgetOwner]
	@ReportExpensePeriod INT,
	@ReforecastQuarterName VARCHAR(2), --''Q0'' or ''Q1'' or ''Q2'' or ''Q3''
	@DestinationCurrency VARCHAR(3),
	@EntityList VARCHAR(8000),
	@DontSensitizeMRIPayrollData BIT,
	@CalculationMethod VARCHAR(50),
	@OriginatingSubRegionList VARCHAR(8000),
	@AllocationSubRegionList VARCHAR(8000),
	@FunctionalDepartmentList VARCHAR(8000),	
	@HierarchyReportParameter dbo.ReportParameterGLCategorizationHierarchyDetail READONLY,
	@IncludeLocalCategorization BIT

AS

/*********************************************************************************************************************
Description
	The stored procedure is used for generating the data for the Budget Owner Report.
	
	Gross Mode: Includes all transactions
	Net Mode: Include only reimbursable costs
	
	MRI Source Sensitization: We need to sensitize source data that we group on for payroll transactions. For
	regions where there is one or two employees, the employee salary can be deduced from a payroll amount for that
	region. we therefore need to sensitize various fields like minor/major category, mri source and originating region. 
	This is controlled by the @DontSensitizeMRIPayrollData parameter.
	
	STEPS:
	
	STEP 1: Declare local variables - use this to easily set up test script
	STEP 2: Set up the Report Filter Variable defaults
	STEP 3: Set up Direct/Indirect Mapping
	STEP 4: Set up Local/Non-Local Mapping
	STEP 5: Set up the Report Filter Tables - We create temp tables containing the records of each parameter dimention
											  We can easily filter our data by inner joining onto these tables
											  
											  Note that we pass through the names of these parameters. If the name of the 
											  record was changed, we still want to return results for all it''s related transactions.
											  Therefore we use views which return the latest state in a dimension to get all the 
											  records related to that entity.
	STEP 6: Create results temp table
	STEP 7: Get Profitability Actual Data - NOTE: we group the transactions here to get a total amount for each type of transaction
	STEP 8: Get Profitability Budget Data
	STEP 9: Get Profitability Reforecast Data
	STEP 10: Get Total Summary Per cost point
	STEP 11: Get Final Results

	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-07-08		: PKayongo	:	Sensitized payroll data for the MRI Source, Originating Region Code and 
											Property Fund fields. (CC20)
			2011-07-11		: PKayongo	:	Allowed reforecast values to be dynamically selected from the 
											@ReforecastQuarterName variable. Only 1 reforecast dynamic query remained
											and only the different reforecast fields at the end (i.e. Q1, Q2, Q3)
											were consolidated into 1.
			2011-08-08		: SNothling	:	Set sensitized strings to ''Sensitized'' instead of ''''

**********************************************************************************************************************/

BEGIN

/* ===============================================================================================================================================
	STEP 1: Declare local variables - this makes debugging and testing easier	

		NOTE: We do not specify parameter defaults. We assume that all parameters have been saved correctly and completely in GRP, and we want the
			stored procedure to break if an expected parameter is not passed through. This prevents unexpected behaviour.
   ============================================================================================================================================= */

BEGIN 

	DECLARE
		@_ReportExpensePeriod INT				 = @ReportExpensePeriod,
		@_ReforecastQuarterName CHAR(2)			 = @ReforecastQuarterName,
		@_DestinationCurrency CHAR(3)			 = @DestinationCurrency,
		@_EntityList VARCHAR(MAX)				 = @EntityList,
		@_DontSensitizeMRIPayrollData BIT		 = @DontSensitizeMRIPayrollData,
		@_CalculationMethod VARCHAR(MAX)		 = @CalculationMethod,
		@_FunctionalDepartmentList VARCHAR (MAX) = @FunctionalDepartmentList,
		@_OriginatingSubRegionList VARCHAR(MAX)  = @OriginatingSubRegionList,
		@_AllocationSubRegionList  VARCHAR(MAX)  = @AllocationSubRegionList,
		@_IncludeLocalCategorization BIT		 = @IncludeLocalCategorization
	
END
			
/* ===============================================================================================================================================
	STEP 2: Set up the Report Filter Variable defaults		
	
		1. The report expense period defaults to the current report expense period
		2. The report expense period parameter is a pre-formatted string used in the select statements of the results
		3. The default destination currency is USD
		4. The calendar year defaults to the year of the expense period
		5. The reforecast quarter name defaults to the latest reforecast quarter name in the database
		   for the given period
		6. If there is no active reforecast for that period - reforecast name combination, get the latest active
		   reforecast
		7. Get the exchange rate set of the selected active reforecast
   ============================================================================================================================================= */

BEGIN

	-- Calculate default report expense period if none specified
	IF @_ReportExpensePeriod IS NULL
		SET @_ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + REPLACE(STR(MONTH(GETDATE()),2 ),'' '',''0'')AS INT)

	-- Calculate destination currency if none specified
	IF @_DestinationCurrency IS NULL
		SET @_DestinationCurrency = ''USD''

	-- Pre-format Report Expense period string
	DECLARE @ReportExpensePeriodParameter VARCHAR(6) = STR(@_ReportExpensePeriod, 6, 0)

	-- Calculate default calendar year if none specified
	DECLARE @CalendarYear AS VARCHAR(10) = SUBSTRING(CAST(@_ReportExpensePeriod AS VARCHAR(6)), 1, 4)

	-- Calculate default reforecast quarter name if not specified
	IF @_ReforecastQuarterName IS NULL OR @_ReforecastQuarterName NOT IN (''Q0'', ''Q1'', ''Q2'', ''Q3'')
		SET @_ReforecastQuarterName =
			(	
				SELECT TOP 1
					ReforecastQuarterName
				FROM
					dbo.Reforecast
				WHERE
					ReforecastEffectivePeriod <= @_ReportExpensePeriod AND
					ReforecastEffectiveYear = LEFT(CAST(@_ReportExpensePeriod AS VARCHAR(6)),4)
				ORDER BY 
					ReforecastEffectivePeriod DESC
			)
									 
	---- Calculate reforecast effective period from reforecast name
	DECLARE @ReforecastEffectivePeriod INT =
			(
				SELECT TOP 1
					ReforecastEffectivePeriod
				FROM
					dbo.Reforecast
				WHERE
					ReforecastEffectiveYear = LEFT(CAST(@_ReportExpensePeriod AS VARCHAR(6)),4) AND
					ReforecastQuarterName = @_ReforecastQuarterName
				ORDER BY
					ReforecastEffectivePeriod
			)

	-- Determine the ReforecastKey of the reforecast that is currently active (i.e.: 2011 Q1, 2011 Q2, 2012 Q0 etc)
	DECLARE @ActiveReforecastKey INT =
			(
				SELECT
					ReforecastKey
				FROM
					dbo.GetReforecastRecord(@_ReportExpensePeriod, @_ReforecastQuarterName)
			)

	-- Safeguard against NULL ReforecastKey returned from previous statement

	IF (@ActiveReforecastKey IS NULL)
	BEGIN
		SET @ActiveReforecastKey =
			(
				SELECT
					MAX(ReforecastKey)
				FROM
					dbo.ExchangeRate
			)
		PRINT (''Near disaster: @ActiveReforecastKey is NULL, so reverting to the largest/most recent ReforecastKey in dbo.ExchangeRate: '' + CONVERT(VARCHAR(10), @ActiveReforecastKey))
	END

	-- Determine Report Exchange Rates	
	-- get the exchange rate set for the specified reforecast

	SELECT
		SourceCurrencyKey,
		DestinationCurrencyKey,
		CalendarKey,
		Rate
	INTO
		#ExchangeRate
	FROM
		dbo.ExchangeRate
	WHERE
		ReforecastKey = @ActiveReforecastKey -- We will use the exchange rate set that is active for the current reforecast.

END

/* ===============================================================================================================================================
	STEP 3: Set up Direct/Indirect Mapping
	
		Change Control 14. CC Ref 5.4 Create Direct or Indirect field and map Direct to all the properties, 
		and Indirect to all the Corporates	
		
		8.	As per Change Control 14 , the following logic will be used to determine the values of the direct/indirect 
		column in the budget owner and budget originator reports :
		
		Source			Indirect/Direct
		
		EU Property		Direct
		US Property		Direct
		IN Property		Direct
		CN Property		Direct
		BR Property		Direct
		EU Corporate	Indirect
		US Corporate	Indirect
		IN Corporate	Indirect
		CN Corporate	Indirect
		BR Corporate	Indirect
		Unknown			—
   ============================================================================================================================================= */
BEGIN

	CREATE TABLE #DirectIndirectMapping
	(
		SourceName VARCHAR(50) PRIMARY KEY,
		DirectIndirect VARCHAR(10),
	)
	INSERT INTO #DirectIndirectMapping
	SELECT
		SourceName,
		''Direct'' AS ''DirectIndirect''
	FROM
		dbo.[Source]
	WHERE
		IsProperty = ''YES''

	UNION

	SELECT
		SourceName,
		''Indirect'' AS ''DirectIndirect''
	FROM
		dbo.[Source]
	WHERE
		IsCorporate = ''YES''

	UNION

	SELECT 
		SourceName, 
		''-'' AS ''DirectIndirect''
	FROM 
		dbo.[Source]
	WHERE 
		IsCorporate = ''NO'' AND 
		IsProperty = ''NO''

END

/* ===============================================================================================================================================
	STEP 4: Set up Local/Non-Local Mapping
	
		a.	The Local/Non-local field will read “local” when the allocation sub region and the originating sub-region are the same (except for
				China).
		b.	The Local/Non-local field will read “non-local” when the allocation sub region and originating sub-region differ (except for China).
		c.	For China, the four regions of China (Beijing, Shanghai, Tianjin and Chengdu) will be treated as local (i.e. if the allocation region
				is China and the originating region is Beijing, then the Local/Non-local field will be “local” however, if the allocation region
				is China and the originating region is New York, then the Local/Non-local field will be “non-local”).
   ============================================================================================================================================ */
BEGIN

	CREATE TABLE #LocalNonLocalMapping
	(
	  OriginatingRegionName VARCHAR (50),
	  OriginatingSubRegionName VARCHAR(50),
	  AllocationRegionName VARCHAR (50),
	  AllocationSubRegionName VARCHAR(50),
	  LocalNonLocal VARCHAR (10),
	)
	INSERT INTO #LocalNonLocalMapping
	SELECT
		OriginatingRegion.RegionName,
		OriginatingRegion.SubRegionName,
		AllocationRegion.RegionName,
		AllocationRegion.SubRegionName,
		''Local''
	FROM
		dbo.ProfitabilityActual
		INNER JOIN dbo.OriginatingRegion ON
			ProfitabilityActual.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey
		INNER JOIN dbo.AllocationRegion ON
			ProfitabilityActual.AllocationRegionKey = AllocationRegion.AllocationRegionKey
	WHERE
		(
			OriginatingRegion.SubRegionName = AllocationRegion.SubRegionName AND
			AllocationRegion.RegionName <> ''China'' AND
			OriginatingRegion.RegionName <> ''China''
		)
		OR
		(
			AllocationRegion.RegionName = ''China'' AND
			OriginatingRegion.RegionName = ''China''
		)

	UNION

	SELECT
		OriginatingRegion.RegionName,
		OriginatingRegion.SubRegionName,
		AllocationRegion.RegionName,
		AllocationRegion.SubRegionName,
		''Non-Local''
	FROM
		dbo.ProfitabilityActual
		INNER JOIN dbo.OriginatingRegion ON
			ProfitabilityActual.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey
		INNER JOIN dbo.AllocationRegion ON
			ProfitabilityActual.AllocationRegionKey = AllocationRegion.AllocationRegionKey
	WHERE
		(
			OriginatingRegion.SubRegionName <> AllocationRegion.SubRegionName AND
			AllocationRegion.RegionName <> ''China'' AND
			OriginatingRegion.RegionName <> ''China''
		)
		OR
		(
			OriginatingRegion.SubRegionName <> AllocationRegion.SubRegionName AND
			AllocationRegion.RegionName = ''China'' AND
			OriginatingRegion.RegionName <> ''China''
		)
		OR
		(
			OriginatingRegion.SubRegionName <> AllocationRegion.SubRegionName AND
			AllocationRegion.RegionName <> ''China'' AND
			OriginatingRegion.RegionName = ''China''
		)

	UNION

	SELECT 
		OriginatingRegion.RegionName,
		OriginatingRegion.SubRegionName,
		AllocationRegion.RegionName,
		AllocationRegion.SubRegionName,
		''Local''
	FROM
		dbo.ProfitabilityBudget
		INNER JOIN dbo.OriginatingRegion ON
			ProfitabilityBudget.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey
		INNER JOIN dbo.AllocationRegion ON
			ProfitabilityBudget.AllocationRegionKey = AllocationRegion.AllocationRegionKey
	WHERE
		(
			OriginatingRegion.SubRegionName = AllocationRegion.SubRegionName AND
			AllocationRegion.RegionName <> ''China'' AND
			OriginatingRegion.RegionName <> ''China''
		)
		OR
		(
			AllocationRegion.RegionName = ''China'' AND
			OriginatingRegion.RegionName = ''China''
		)

	UNION

	SELECT 
		OriginatingRegion.RegionName,
		OriginatingRegion.SubRegionName,
		AllocationRegion.RegionName,
		AllocationRegion.SubRegionName,
		''Non-Local''
	FROM
		dbo.ProfitabilityBudget
		INNER JOIN dbo.OriginatingRegion ON
			ProfitabilityBudget.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey
		INNER JOIN dbo.AllocationRegion ON
			ProfitabilityBudget.AllocationRegionKey = AllocationRegion.AllocationRegionKey
	WHERE
		(
			OriginatingRegion.SubRegionName <> AllocationRegion.SubRegionName AND
			AllocationRegion.RegionName <> ''China'' AND
			OriginatingRegion.RegionName <> ''China''
		)
		OR
		(
			OriginatingRegion.SubRegionName <> AllocationRegion.SubRegionName AND
			AllocationRegion.RegionName = ''China'' AND
			OriginatingRegion.RegionName <> ''China''
		)
		OR
		(
			OriginatingRegion.SubRegionName <> AllocationRegion.SubRegionName AND
			AllocationRegion.RegionName <> ''China'' AND
			OriginatingRegion.RegionName = ''China''
		)

	UNION

	SELECT 
		OriginatingRegion.RegionName, 
		OriginatingRegion.SubRegionName, 
		AllocationRegion.RegionName, 
		AllocationRegion.SubRegionName, 
		''Local''
	FROM
		dbo.ProfitabilityReforecast
		INNER JOIN dbo.OriginatingRegion ON 
			ProfitabilityReforecast.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey
		INNER JOIN dbo.AllocationRegion ON 
			ProfitabilityReforecast.AllocationRegionKey = AllocationRegion.AllocationRegionKey
	WHERE
		(
			OriginatingRegion.SubRegionName = AllocationRegion.SubRegionName AND
			AllocationRegion.RegionName <> ''China'' AND
			OriginatingRegion.RegionName <> ''China''
		)
		OR
		(
			AllocationRegion.RegionName = ''China'' AND
			OriginatingRegion.RegionName = ''China''
		)

	UNION

	SELECT
		OriginatingRegion.RegionName,
		OriginatingRegion.SubRegionName,
		AllocationRegion.RegionName,
		AllocationRegion.SubRegionName,
		''Non-Local''
	FROM
		dbo.ProfitabilityReforecast
		INNER JOIN dbo.OriginatingRegion ON 
			ProfitabilityReforecast.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey 
		INNER JOIN dbo.AllocationRegion ON 
			ProfitabilityReforecast.AllocationRegionKey = AllocationRegion.AllocationRegionKey
	WHERE
		(
			OriginatingRegion.SubRegionName <> AllocationRegion.SubRegionName AND 
			AllocationRegion.RegionName <> ''China'' AND 
			OriginatingRegion.RegionName <> ''China''
		)
		OR
		(
			OriginatingRegion.SubRegionName <> AllocationRegion.SubRegionName AND 
			AllocationRegion.RegionName = ''China'' AND 
			OriginatingRegion.RegionName <> ''China''
		)
		OR
		(
			OriginatingRegion.SubRegionName <> AllocationRegion.SubRegionName AND 
			AllocationRegion.RegionName <> ''China'' AND 
			OriginatingRegion.RegionName = ''China''
		)

END
	
/* ===============================================================================================================================================
	STEP 5: Set up the Report Filter Tables
	
		Note that we pass through the names of these parameters. If the name of the 
		record was changed, we still want to return results for all it''s related transactions.
		Therefore we use views which return the latest state in a dimension to get all the 
		records related to that entity.
	
		1. Reporting Entities - Get a table containing all the reporting entities specified in the filter parameter
		2. Originating Sub Regions - Get a table containing all the originating sub regions specified in the filter parameter
		3. Allocation Sub Regions - Get a table containing all the allocation sub regions specified in the filter parameter
   ============================================================================================================================================ */
BEGIN

	----------------------------------------------------------------------------
	-- Reporting Entities
	----------------------------------------------------------------------------

		CREATE TABLE #EntityFilterTable	
		(
			PropertyFundKey INT NOT NULL,
			PropertyFundName VARCHAR(MAX) NOT NULL,
			PropertyFundType VARCHAR(MAX) NOT NULL
		)

		IF (@_EntityList IS NOT NULL)
		BEGIN

			IF (@_EntityList <> ''All'')
			BEGIN

				INSERT INTO #EntityFilterTable
				SELECT DISTINCT 
					PropertyFundLatestState.PropertyFundKey,
					PropertyFundLatestState.LatestPropertyFundName,
					PropertyFundLatestState.LatestPropertyFundType
				FROM 
					dbo.Split(@_EntityList) EntityListParameters
					INNER JOIN dbo.PropertyFund ON 
						PropertyFund.PropertyFundName = EntityListParameters.item
					INNER JOIN PropertyFundLatestState ON
						PropertyFund.PropertyFundId = PropertyFundLatestState.PropertyFundId AND
						PropertyFund.SnapshotId = PropertyFundLatestState.PropertyFundSnapshotId
			END
			ELSE IF (@_EntityList = ''All'')
			BEGIN

				INSERT INTO #EntityFilterTable
				SELECT DISTINCT
					PropertyFundLatestState.PropertyFundKey,
					PropertyFundLatestState.LatestPropertyFundName AS PropertyFundName,
					PropertyFundLatestState.LatestPropertyFundType AS PropertyFundType
				FROM 
					dbo.PropertyFundLatestState

			END

		END

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable (PropertyFundKey)
	
	----------------------------------------------------------------------------
	-- Originating Sub Region
	----------------------------------------------------------------------------

	CREATE TABLE #OriginatingSubRegionFilterTable 
	(
		OriginatingRegionKey INT NOT NULL,
		OriginatingRegionName VARCHAR(MAX) NOT NULL,
		OriginatingSubRegionName VARCHAR(MAX) NOT NULL
	)

	IF (@_OriginatingSubRegionList IS NOT NULL)
	BEGIN

		IF (@_OriginatingSubRegionList <> ''All'')

		BEGIN
		
			INSERT INTO #OriginatingSubRegionFilterTable
			SELECT DISTINCT
				OriginatingRegionLatestState.OriginatingRegionKey,
				OriginatingRegionLatestState.LatestOriginatingRegionName,
				OriginatingRegionLatestState.LatestOriginatingSubRegionName
			FROM 
				dbo.Split(@_OriginatingSubRegionList) OriginatingSubRegionParameters
				INNER JOIN dbo.OriginatingRegion ON 
					OriginatingRegion.SubRegionName = OriginatingSubRegionParameters.item
				INNER JOIN dbo.OriginatingRegionLatestState ON
					OriginatingRegion.GlobalRegionId = OriginatingRegionLatestState.OriginatingRegionGlobalRegionId AND
					OriginatingRegion.SnapshotId = OriginatingRegionLatestState.OriginatingRegionSnapshotId
		END

		ELSE IF (@_OriginatingSubRegionList = ''All'')
		BEGIN

			INSERT INTO #OriginatingSubRegionFilterTable
			SELECT DISTINCT
				OriginatingRegionLatestState.OriginatingRegionKey,
				OriginatingRegionLatestState.LatestOriginatingRegionName,
				OriginatingRegionLatestState.LatestOriginatingSubRegionName
			FROM 
				dbo.OriginatingRegionLatestState
		END

	END

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable (OriginatingRegionKey)

	----------------------------------------------------------------------------
	-- Allocation Sub Region
	----------------------------------------------------------------------------

	CREATE TABLE #AllocationSubRegionFilterTable 
	(
		AllocationRegionKey INT NOT NULL,
		AllocationRegionName VARCHAR(MAX) NOT NULL,
		AllocationSubRegionName VARCHAR(MAX) NOT NULL
	)

	IF (@_AllocationSubRegionList IS NOT NULL)
	BEGIN

		IF (@_AllocationSubRegionList <> ''All'')
		BEGIN

			INSERT INTO #AllocationSubRegionFilterTable
			SELECT DISTINCT
				AllocationRegionLatestState.AllocationRegionKey,
				AllocationRegionLatestState.LatestAllocationRegionName,
				AllocationRegionLatestState.LatestAllocationSubRegionName
			FROM 
				dbo.Split(@_AllocationSubRegionList) AllocationSubRegionParameters
				INNER JOIN dbo.AllocationRegion ON
					AllocationRegion.SubRegionName = AllocationSubRegionParameters.item
				INNER JOIN dbo.AllocationRegionLatestState ON
					AllocationRegion.GlobalRegionId = AllocationRegionLatestState.AllocationRegionGlobalRegionId AND
					AllocationRegion.SnapshotId = AllocationRegionLatestState.AllocationRegionSnapshotId
					
		END
		ELSE IF (@_AllocationSubRegionList = ''All'')
		BEGIN

			INSERT INTO #AllocationSubRegionFilterTable
			SELECT DISTINCT
				AllocationRegionLatestState.AllocationRegionKey,
				AllocationRegionLatestState.LatestAllocationRegionName,
				AllocationRegionLatestState.LatestAllocationSubRegionName
			FROM
				dbo.AllocationRegionLatestState

		END

	END

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)

	----------------------------------------------------------------------------
	-- Functional Departments
	----------------------------------------------------------------------------

	CREATE TABLE #FunctionalDepartmentFilterTable 
	(
		FunctionalDepartmentKey INT NOT NULL,
		FunctionalDepartmentName VARCHAR(MAX) NOT NULL
	)

	IF (@_FunctionalDepartmentList IS NOT NULL)
	BEGIN	

		IF (@_FunctionalDepartmentList <> ''All'')
		BEGIN

			INSERT INTO #FunctionalDepartmentFilterTable
			SELECT DISTINCT
				FunctionalDepartmentLatestState.FunctionalDepartmentKey,
				FunctionalDepartmentLatestState.LatestFunctionalDepartmentName
			FROM
				dbo.Split(@_FunctionalDepartmentList) FunctionalDepartmentParameters
				INNER JOIN dbo.FunctionalDepartment ON
					FunctionalDepartment.FunctionalDepartmentName = FunctionalDepartmentParameters.item	
				INNER JOIN FunctionalDepartmentLatestState ON
					FunctionalDepartment.ReferenceCode = FunctionalDepartmentLatestState.FunctionalDepartmentReferenceCode

		END
		ELSE IF (@_FunctionalDepartmentList = ''All'')
		BEGIN

			INSERT INTO #FunctionalDepartmentFilterTable
			SELECT DISTINCT
				FunctionalDepartmentLatestState.FunctionalDepartmentKey,
				FunctionalDepartmentLatestState.LatestFunctionalDepartmentName
			FROM 
				dbo.FunctionalDepartmentLatestState

		END

	END

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)

	----------------------------------------------------------------------------
	-- Categorization Hierarchy
	----------------------------------------------------------------------------

	CREATE TABLE #CategorizationHierarchyFilterTable
	(
		CategorizationHierarchyKey INT NOT NULL,
		GLCategorizationName VARCHAR(50) NOT NULL,
		GLFinancialCategoryName VARCHAR(400) NOT NULL,
		GLMajorCategoryName VARCHAR(400) NOT NULL,
		GLMinorCategoryName VARCHAR(400) NOT NULL,
		GLAccountCode VARCHAR(15) NOT NULL,
		GLAccountName VARCHAR(300) NOT NULL
	)

	INSERT INTO #CategorizationHierarchyFilterTable
	SELECT DISTINCT
		GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey,
		GLCategorizationHierarchyLatestState.LatestGLCategorizationName,
		GLCategorizationHierarchyLatestState.LatestGLFinancialCategoryName,
		GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName,
		GLCategorizationHierarchyLatestState.LatestGLMinorCategoryName,
		GLCategorizationHierarchyLatestState.LatestGLAccountCode,
		GLCategorizationHierarchyLatestState.LatestGlAccountName
	FROM 
		@HierarchyReportParameter HierarchyReportParameter
		INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
			(
				HierarchyReportParameter.FinancialCategoryName = ''All'' OR
				HierarchyReportParameter.FinancialCategoryName = GLCategorizationHierarchyLatestState.LatestGLFinancialCategoryName
			) AND
			(
				HierarchyReportParameter.GLMajorCategoryName = ''All'' OR
				HierarchyReportParameter.GLMajorCategoryName = GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName
			) AND
			(
				HierarchyReportParameter.GLMinorCategoryName = ''All'' OR
				HierarchyReportParameter.GLMinorCategoryName = GLCategorizationHierarchyLatestState.LatestGLMinorCategoryName
			)
	WHERE
		GLCategorizationHierarchyLatestState.LatestInflowOutflow <> ''Inflow'' AND
		GLCategorizationHierarchyLatestState.LatestGLMinorCategoryName <> ''Architects & Engineering'' AND -- IMS 51655
		GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName NOT IN
			(
				''Corporate Tax'',
				''Depreciation Expense'',
				''Realized (Gain)/Loss'',
				''Unrealized (Gain)/Loss'',
				''Miscellaneous Expense'',
				''Miscellaneous Income'', -- Should be excluded by virtue of the fact that we are excluding ''Inflow'' above, but do it again here
				''Interest & Penalties'',
				''Guaranteed Payment''
			)

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #CategorizationHierarchyFilterTable (CategorizationHierarchyKey)

END
	
/* ===============================================================================================================================================
	STEP 6: Create results temp table

		We will insert all the resulting transaction data into this result temp table:
		
		1. Actuals transactions
		2. Budget transactions
		3. Reforecast transactions
    ============================================================================================================================================ */
BEGIN 

	CREATE TABLE #BudgetOwnerEntity
	(
		ActivityTypeKey					INT,	
		GlobalGLCategorizationKey		INT,
		ReportingGLCategorizationKey	INT,
		AllocationRegionKey				INT,
		OriginatingRegionKey			INT,
		FunctionalDepartmentKey			INT,
		PropertyFundKey					INT,
		ReimbursableKey					INT,
		SourceName						VARCHAR(50),
		EntryDate						VARCHAR(10),
		[User]							NVARCHAR(20),
		[Description]					NVARCHAR(60),
		AdditionalDescription			NVARCHAR(4000),
		PropertyFundCode				VARCHAR(11) DEFAULT(''''), --VARCHAR, for this helps to keep reports size smaller
		OriginatingRegionCode			VARCHAR(30) DEFAULT(''''), --VARCHAR, for this helps to keep reports size smaller
		FunctionalDepartmentCode		VARCHAR(15) DEFAULT(''''),
		GlAccountCode					VARCHAR(15) DEFAULT(''''),
		GlAccountName					VARCHAR(300) DEFAULT(''''),
		CalendarPeriod					VARCHAR(6) DEFAULT(''''),

		--Month to date	
		MtdGrossActual					MONEY,
		MtdGrossBudget					MONEY,
		MtdGrossReforecast				MONEY,
		
		MtdNetActual					MONEY,
		MtdNetBudget					MONEY,
		MtdNetReforecast				MONEY,
		
		--Year to date
		YtdGrossActual					MONEY,	
		YtdGrossBudget					MONEY, 
		YtdGrossReforecast				MONEY,
		
		YtdNetActual					MONEY, 
		YtdNetBudget					MONEY, 
		YtdNetReforecast				MONEY, 

		--Annual	
		AnnualGrossBudget				MONEY,
		AnnualGrossReforecast			MONEY,
		AnnualNetBudget					MONEY,
		AnnualNetReforecast				MONEY,

		--Annual estimated
		AnnualEstGrossBudget			MONEY,
		AnnualEstGrossReforecast		MONEY,
		AnnualEstNetBudget				MONEY,
		AnnualEstNetReforecast			MONEY
	)

END

/* ===============================================================================================================================================
	STEP 7: Get Profitability Actual Data

		Budget Owner data is only ''Allocated'', ''Not Overhead'', ''UNKNOWN''
		''Outflow'', ''UNKNOWN'' only, they only look at expenses, not income
		Exclude ''Architects & Engineering'', was re-classified, as per Martin''s request
    ============================================================================================================================================ */
BEGIN

	INSERT INTO #BudgetOwnerEntity
	SELECT
		ProfitabilityActual.ActivityTypeKey,
		ProfitabilityActual.GlobalGLCategorizationHierarchyKey,
		ProfitabilityActual.ReportingGLCategorizationHierarchyKey,
		ProfitabilityActual.AllocationRegionKey,
		ProfitabilityActual.OriginatingRegionKey,
		ProfitabilityActual.FunctionalDepartmentKey,
		ProfitabilityActual.PropertyFundKey,
		ProfitabilityActual.ReimbursableKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''
			ELSE
				Source.SourceName
		END AS ''SourceName'',
		CONVERT(VARCHAR(10),ISNULL(ProfitabilityActual.LastDate,''''), 101) AS EntryDate,
		ProfitabilityActual.[User],
		ProfitabilityActual.Description,
		ProfitabilityActual.AdditionalDescription,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''	
			ELSE
				ProfitabilityActual.PropertyFundCode
		END AS ''PropertyFundCode'',
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''	
			ELSE
				ProfitabilityActual.OriginatingRegionCode
		END AS ''OriginatingRegionCode'',
		ProfitabilityActual.FunctionalDepartmentCode,
		GlobalHierarchy.GLAccountCode,
		GlobalHierarchy.GLAccountName,
		Calendar.CalendarPeriod,
		SUM
		(
			#ExchangeRate.Rate *
			CASE
				WHEN
					(Calendar.CalendarPeriod = @ReportExpensePeriodParameter)
				THEN
					ProfitabilityActual.LocalActual
				ELSE
					0.0
			END
		) AS ''MtdGrossActual'',
		NULL AS ''MtdGrossBudget'',
		NULL AS ''MtdGrossReforeCast'',
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE
				WHEN
					(Calendar.CalendarPeriod = @ReportExpensePeriodParameter)
				THEN
					ProfitabilityActual.LocalActual
				ELSE
					0.0
			END
		) AS ''MtdNetActual'',
		NULL AS ''MtdNetBudget'',
		NULL AS ''MtdNetReforecast'',
		SUM
		(
			#ExchangeRate.Rate *
			CASE
				WHEN
					(Calendar.CalendarPeriod <= @ReportExpensePeriodParameter)
				THEN
					ProfitabilityActual.LocalActual
				ELSE
					0.0
			END
		) AS ''YtdGrossActual'',
		NULL AS ''YtdGrossBudget'',
		NULL AS ''YtdGrossReforecast'',
		SUM
		(
			#ExchangeRate.Rate * 
			Reimbursable.MultiplicationFactor *
			CASE
				WHEN
					(Calendar.CalendarPeriod <= @ReportExpensePeriodParameter)
				THEN
					ProfitabilityActual.LocalActual
				ELSE
					0.0
			END
		) AS ''YtdNetActual'',
		NULL AS ''YtdNetBudget'',
		NULL AS ''YtdNetReforecast'',
		NULL AS ''AnnualGrossBudget'',
		NULL AS ''AnnualGrossReforecast'',
		NULL AS ''AnnualNetBudget'',
		NULL AS ''AnnualNetReforecast'',
		SUM
		(
			#ExchangeRate.Rate *
			CASE
				WHEN
					(Calendar.CalendarPeriod <= @ReportExpensePeriodParameter)
				THEN
					ProfitabilityActual.LocalActual
				ELSE
					0.0
			END
		) AS ''AnnualEstGrossBudget'',
		NULL AS ''AnnualEstGrossReforecast'',
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE 
				WHEN
					(Calendar.CalendarPeriod <= @ReportExpensePeriodParameter)
				THEN
					ProfitabilityActual.LocalActual
				ELSE
					0.0
			END
		) AS ''AnnualEstNetBudget'',
		NULL AS ''AnnualEstNetReforecast''
	FROM 
		dbo.ProfitabilityActual 
		
		INNER JOIN #EntityFilterTable ON
			ProfitabilityActual.PropertyFundKey = #EntityFilterTable.PropertyFundKey
			
		INNER JOIN #OriginatingSubRegionFilterTable ON
			ProfitabilityActual.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey
			
		INNER JOIN #AllocationSubRegionFilterTable ON
			ProfitabilityActual.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey
			
		INNER JOIN #FunctionalDepartmentFilterTable ON
			ProfitabilityActual.FunctionalDepartmentKey = #FunctionalDepartmentFilterTable.FunctionalDepartmentKey
			
		INNER JOIN #ExchangeRate ON
			ProfitabilityActual.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
			ProfitabilityActual.CalendarKey = #ExchangeRate.CalendarKey
			
		INNER JOIN dbo.Currency ON
			#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey
			
		INNER JOIN dbo.Overhead ON
			ProfitabilityActual.Overheadkey = Overhead.OverheadKey
			
		INNER JOIN dbo.Calendar ON
			ProfitabilityActual.CalendarKey = Calendar.CalendarKey
		
		INNER JOIN dbo.[Source] ON
			ProfitabilityActual.SourceKey = Source.SourceKey
		
		INNER JOIN dbo.Reimbursable ON
			ProfitabilityActual.ReimbursableKey = Reimbursable.ReimbursableKey
						
		INNER JOIN #CategorizationHierarchyFilterTable GlobalHierarchy ON
			ProfitabilityActual.GlobalGLCategorizationHierarchyKey = GlobalHierarchy.CategorizationHierarchyKey
	WHERE
		Overhead.OverheadCode IN 
		(
			''ALLOC'',
			''UNKNOWN'',
			''N/A''
		) AND
		Calendar.CalendarYear = STR(@CalendarYear, 10, 0) AND
		Currency.CurrencyCode = @_DestinationCurrency
	GROUP BY
		ProfitabilityActual.ActivityTypeKey,
		ProfitabilityActual.GlobalGLCategorizationHierarchyKey,
		ProfitabilityActual.ReportingGLCategorizationHierarchyKey,
		ProfitabilityActual.AllocationRegionKey,
		ProfitabilityActual.OriginatingRegionKey,
		ProfitabilityActual.FunctionalDepartmentKey,
		ProfitabilityActual.PropertyFundKey,
		ProfitabilityActual.ReimbursableKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''
			ELSE
				Source.SourceName
		END,
		CONVERT(VARCHAR(10), ISNULL(ProfitabilityActual.LastDate, ''''), 101),
		ProfitabilityActual.[User],
		ProfitabilityActual.Description,
		ProfitabilityActual.AdditionalDescription,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''	
			ELSE
				ProfitabilityActual.PropertyFundCode
		END,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''	
			ELSE
				ProfitabilityActual.OriginatingRegionCode
		END,
		ProfitabilityActual.FunctionalDepartmentCode,
		GlobalHierarchy.GLAccountCode,
		GlobalHierarchy.GLAccountName,
		Calendar.CalendarPeriod

END

/* ===============================================================================================================================================
	STEP 8: Get Profitability Budget Data
			
		Budget Owner data is only ''Allocated'', ''UNKNOWN''
		''Outflow'', ''UNKNOWN'' only, they only look at expenses, not income
		Exclude ''Architects & Engineering'', was re-classified, as per Martin''s request
    ============================================================================================================================================ */
BEGIN

	INSERT INTO #BudgetOwnerEntity
	SELECT
		ProfitabilityBudget.ActivityTypeKey,
		ProfitabilityBudget.GlobalGLCategorizationHierarchyKey,
		ProfitabilityBudget.ReportingGLCategorizationHierarchyKey,
		ProfitabilityBudget.AllocationRegionKey,
		ProfitabilityBudget.OriginatingRegionKey,
		ProfitabilityBudget.FunctionalDepartmentKey,
		ProfitabilityBudget.PropertyFundKey,
		ProfitabilityBudget.ReimbursableKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''
			ELSE
				Source.SourceName
		END AS ''SourceName'',
		'''' AS ''EntryDate'',
		'''' AS ''User'',
		'''' AS ''Description'',
		'''' AS ''AdditionalDescription'',
		'''' AS ''PropertyFundCode'',
		'''' AS ''OriginatingRegionCode'',
		'''' AS ''FunctionalDepartmentCode'',
		GlobalHierarchy.GLAccountCode AS ''GLAccountCode'',
		GlobalHierarchy.GLAccountName AS ''GLAccountName'',	
		Calendar.CalendarPeriod,
		NULL AS ''MtdGrossActual'',
		SUM
		(
			#ExchangeRate.Rate *
			CASE
				WHEN
					(Calendar.CalendarPeriod = @ReportExpensePeriodParameter)
				THEN
					ProfitabilityBudget.LocalBudget
				ELSE
					0.0
			END
		) AS ''MtdGrossBudget'',
		NULL AS ''MtdGrossReforeCast'',
		NULL AS ''MtdNetActual'',
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE
				WHEN
					(Calendar.CalendarPeriod = @ReportExpensePeriodParameter)
				THEN
					ProfitabilityBudget.LocalBudget
				ELSE
					0.0
			END
		) AS ''MtdNetBudget'',
		NULL AS ''MtdNetReforecast'',
		NULL AS ''YtdGrossActual'',
		SUM
		(
			#ExchangeRate.Rate *
			CASE
				WHEN
					(Calendar.CalendarPeriod <= @ReportExpensePeriodParameter)
				THEN
					ProfitabilityBudget.LocalBudget
				ELSE
					0.0
			END
		) AS ''YtdGrossBudget'',
		NULL AS ''YtdGrossReforecast'',
		NULL AS ''YtdNetActual'',
		SUM
		(
			#ExchangeRate.Rate * 
			Reimbursable.MultiplicationFactor *
			CASE
				WHEN
					(Calendar.CalendarPeriod <= @ReportExpensePeriodParameter)
				THEN
					ProfitabilityBudget.LocalBudget
				ELSE
					0.0
			END
		) AS ''YtdNetBudget'',
		NULL AS ''YtdNetReforecast'',
		SUM
		(
			#ExchangeRate.Rate *
			ProfitabilityBudget.LocalBudget	
		) AS ''AnnualGrossBudget'',
		NULL AS ''AnnualGrossReforecast'',
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			ProfitabilityBudget.LocalBudget
		) AS ''AnnualNetBudget'',
		NULL AS ''AnnualNetReforecast'',
		SUM
		(
			#ExchangeRate.Rate *
			CASE
				WHEN
					(Calendar.CalendarPeriod > @ReportExpensePeriodParameter)
				THEN
					ProfitabilityBudget.LocalBudget
				ELSE
					0.0
			END 
		) AS ''AnnualEstGrossBudget'',
		NULL AS ''AnnualEstGrossReforecast'',
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE 
				WHEN
					(Calendar.CalendarPeriod > @ReportExpensePeriodParameter)
				THEN
					ProfitabilityBudget.LocalBudget
				ELSE
					0.0
			END
		) AS ''AnnualEstNetBudget'',
		NULL AS ''AnnualEstNetReforecast''
		
	FROM
		dbo.ProfitabilityBudget 

		INNER JOIN #EntityFilterTable ON
			ProfitabilityBudget.PropertyFundKey = #EntityFilterTable.PropertyFundKey
			
		INNER JOIN #OriginatingSubRegionFilterTable ON
			ProfitabilityBudget.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey
			
		INNER JOIN #AllocationSubRegionFilterTable ON
			ProfitabilityBudget.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey
			
		INNER JOIN #FunctionalDepartmentFilterTable ON
			ProfitabilityBudget.FunctionalDepartmentKey = #FunctionalDepartmentFilterTable.FunctionalDepartmentKey
			
		INNER JOIN #ExchangeRate ON
			ProfitabilityBudget.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
			ProfitabilityBudget.CalendarKey = #ExchangeRate.CalendarKey
			
		INNER JOIN dbo.Currency ON
			#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey
			
		INNER JOIN dbo.Overhead ON
			ProfitabilityBudget.Overheadkey = Overhead.OverheadKey
			
		INNER JOIN dbo.Calendar ON
			ProfitabilityBudget.CalendarKey = Calendar.CalendarKey
		
		INNER JOIN dbo.Source ON
			ProfitabilityBudget.SourceKey = Source.SourceKey
		
		INNER JOIN dbo.Reimbursable ON
			ProfitabilityBudget.ReimbursableKey = Reimbursable.ReimbursableKey
						
		INNER JOIN #CategorizationHierarchyFilterTable GlobalHierarchy ON
			ProfitabilityBudget.GlobalGLCategorizationHierarchyKey = GlobalHierarchy.CategorizationHierarchyKey
	WHERE 
		Overhead.OverheadCode IN 
		(
			''ALLOC'',
			''UNKNOWN'',
			''N/A''
		) AND
		Calendar.CalendarYear = @CalendarYear AND
		Currency.CurrencyCode = @_DestinationCurrency	
	GROUP BY
		ProfitabilityBudget.ActivityTypeKey,
		ProfitabilityBudget.GlobalGLCategorizationHierarchyKey,
		ProfitabilityBudget.ReportingGLCategorizationHierarchyKey,
		ProfitabilityBudget.AllocationRegionKey,
		ProfitabilityBudget.OriginatingRegionKey,
		ProfitabilityBudget.FunctionalDepartmentKey,
		ProfitabilityBudget.PropertyFundKey,
		ProfitabilityBudget.ReimbursableKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''	
			ELSE
				Source.SourceName
		END,
		GlobalHierarchy.GLAccountCode,
		GlobalHierarchy.GLAccountName,	
		Calendar.CalendarPeriod
		
END
	
/* ===============================================================================================================================================
	STEP 9: Get Profitability Reforecast Data

		There are only reforecast transactions for Q1, Q2, Q3
				
		Budget Owner data is only ''Allocated'', ''UNKNOWN''
		''Outflow'', ''UNKNOWN'' only, they only look at expenses, not income
		Exclude ''Architects & Engineering'', was re-classified, as per Martin''s request
    =========================================================================================================================================== */
BEGIN

	IF @_ReforecastQuarterName IN (''Q1'', ''Q2'', ''Q3'')
	BEGIN

		INSERT INTO #BudgetOwnerEntity
		SELECT
			ProfitabilityReforecast.ActivityTypeKey,
			ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey,
			ProfitabilityReforecast.ReportingGLCategorizationHierarchyKey,
			ProfitabilityReforecast.AllocationRegionKey,
			ProfitabilityReforecast.OriginatingRegionKey,
			ProfitabilityReforecast.FunctionalDepartmentKey,
			ProfitabilityReforecast.PropertyFundKey,
			ProfitabilityReforecast.ReimbursableKey,
			CASE
				WHEN
					@_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
				THEN
					''Sensitized''	
				ELSE
					Source.SourceName
			END AS ''SourceName'',
			'''' AS ''EntryDate'',
			'''' AS ''User'',
			'''' AS ''Description'',
			'''' AS ''AdditionalDescription'',
			'''' AS ''PropertyFundCode'',
			'''' AS ''OriginatingRegionCode'',
			'''' AS ''FunctionalDepartmentCode'',
			GlobalHierarchy.GLAccountCode AS ''GLAccountCode'',
			GlobalHierarchy.GLAccountName AS ''GLAccountName'',	
			'''' AS ''CalendarPeriod'',
			NULL AS ''MtdGrossActual'',
			NULL AS ''MtdGrossBudget'',
			SUM
			(
				#ExchangeRate.Rate *
				CASE
					WHEN
						Calendar.CalendarPeriod = @ReportExpensePeriodParameter
					THEN
						ProfitabilityReforecast.LocalReforecast
				ELSE
					0.0
				END
			) AS ''MtdGrossReforeCast'',
			NULL AS ''MtdNetActual'',
			NULL AS ''MtdNetBudget'',
			SUM
			(
				#ExchangeRate.Rate *
				Reimbursable.MultiplicationFactor *
				CASE 
					WHEN
						Calendar.CalendarPeriod = @ReportExpensePeriodParameter
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0.0
				END
			) AS ''MtdNetReforecast'',
			NULL AS ''YtdGrossActual'',
			NULL AS ''YtdGrossBudget'',
			SUM
			(
				#ExchangeRate.Rate *
				CASE
					WHEN
						Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0.0
				END
			) AS ''YtdGrossReforecast'',
			NULL AS ''YtdNetActual'',
			NULL AS ''YtdNetBudget'',
			SUM
			(
				#ExchangeRate.Rate *
				Reimbursable.MultiplicationFactor *
				CASE
					WHEN
						Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0.0
				END
			) AS ''YtdNetReforecast'',
			NULL AS ''AnnualGrossBudget'',
			SUM
			(
				#ExchangeRate.Rate *
				ProfitabilityReforecast.LocalReforecast
			) AS ''AnnualGrossReforecast'',
			NULL AS ''AnnualNetBudget'',
			SUM
			(
				#ExchangeRate.Rate *
				Reimbursable.MultiplicationFactor *
				ProfitabilityReforecast.LocalReforecast
			) AS ''AnnualNetReforecast'',
			NULL AS ''AnnualEstGrossBudget'',
			SUM
			(
				#ExchangeRate.Rate *
				CASE
					WHEN
					(
						Calendar.CalendarPeriod > @ReportExpensePeriodParameter OR 
						(
							LEFT (ProfitabilityReforecast.ReferenceCode, 3) = ''BC:'' AND
							STR(@ReforecastEffectivePeriod,6,0) IN 
							(
								201003, 
								201006, 
								201009
							)
						)
					)
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0.0
				END
			) AS ''AnnualEstGrossReforecast'',
			NULL AS ''AnnualEstNetBudget'',
			SUM
			(
				#ExchangeRate.Rate *
				CASE
					WHEN
					(
						Calendar.CalendarPeriod > @ReportExpensePeriodParameter OR 
						(
							LEFT (ProfitabilityReforecast.ReferenceCode, 3) = ''BC:'' AND
							STR(@ReforecastEffectivePeriod,6,0) IN 
							(
								201003,
								201006,
								201009
							)
						)
					)
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0.0
				END
			) AS ''AnnualEstNetReforecast''
		FROM
			dbo.ProfitabilityReforecast 
		
			INNER JOIN #EntityFilterTable ON
				ProfitabilityReforecast.PropertyFundKey = #EntityFilterTable.PropertyFundKey
				
			INNER JOIN #OriginatingSubRegionFilterTable ON
				ProfitabilityReforecast.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey
				
			INNER JOIN #AllocationSubRegionFilterTable ON
				ProfitabilityReforecast.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey
				
			INNER JOIN #FunctionalDepartmentFilterTable ON
				ProfitabilityReforecast.FunctionalDepartmentKey = #FunctionalDepartmentFilterTable.FunctionalDepartmentKey
						
			INNER JOIN #ExchangeRate ON
				ProfitabilityReforecast.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
				ProfitabilityReforecast.CalendarKey = #ExchangeRate.CalendarKey
				
			INNER JOIN dbo.Currency ON
				#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey
				
			INNER JOIN dbo.Overhead ON
				ProfitabilityReforecast.Overheadkey = Overhead.OverheadKey
				
			INNER JOIN dbo.Calendar ON
				ProfitabilityReforecast.CalendarKey = Calendar.CalendarKey
			
			INNER JOIN dbo.[Source] ON
				ProfitabilityReforecast.SourceKey = Source.SourceKey
				
			INNER JOIN dbo.Reimbursable ON
				ProfitabilityReforecast.ReimbursableKey = Reimbursable.ReimbursableKey
							
			INNER JOIN  #CategorizationHierarchyFilterTable GlobalHierarchy ON
				ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey = GlobalHierarchy.CategorizationHierarchyKey
			
			INNER JOIN dbo.Reforecast ON
				ProfitabilityReforecast.ReforecastKey = Reforecast.ReforecastKey
		WHERE 
			Overhead.OverheadCode IN 
			(
				''ALLOC'',
				''UNKNOWN'',
				''N/A''
			) AND
			Reforecast.ReforecastEffectivePeriod = @ReforecastEffectivePeriod AND
			Calendar.CalendarYear = @CalendarYear AND
			Currency.CurrencyCode = @_DestinationCurrency
		GROUP BY
			ProfitabilityReforecast.ActivityTypeKey,
			ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey,
			ProfitabilityReforecast.ReportingGLCategorizationHierarchyKey,
			ProfitabilityReforecast.AllocationRegionKey,
			ProfitabilityReforecast.OriginatingRegionKey,
			ProfitabilityReforecast.FunctionalDepartmentKey,
			ProfitabilityReforecast.PropertyFundKey,
			ProfitabilityReforecast.ReimbursableKey,
			CASE
				WHEN
					@_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
				THEN
					''Sensitized''	
				ELSE
					Source.SourceName
			END,
			GlobalHierarchy.GLAccountCode,
			GlobalHierarchy.GLAccountName,
			Calendar.CalendarPeriod

	END

END

/* ===============================================================================================================================================
	STEP 10: Get Total Summary Per cost point

		We are now combining the results for actuals, budgets and reforecasts, thus creating total amounts per:

		ActivityType,

		Global Categorization GLFinancialCategory,
		Global Categorization GLMajorCategory,
		Global Categorization GLMinorCategory,

		Default Reporting Categorization GLFinancialCategory,
		Default Reporting Categorization GLMajorCategory,
		Default Reporting Categorization GLMinorCategory,

		AllocationRegion,
		OriginatingRegion,
		FunctionalDepartmentName,
		PropertyFund,
		CalendarPeriod,
		EntryDate,
		[User],
		[Description],
		AdditionalDescription,
		SourceName,
		GLAccountCode,
		GLAccountName,
		LocalNonLocal,
		DirectIndirect
   ============================================================================================================================================ */
BEGIN

	SELECT 
		ActivityType.ActivityTypeName,
		ActivityType.ActivityTypeName AS ''ActivityTypeFilterName'',
		GlobalHierarchyInWarehouse.LatestGLCategorizationName AS ''GlobalCategorization'',
		GlobalHierarchyInWarehouse.LatestGLFinancialCategoryName AS ''GlobalFinancialCategory'',
		GlobalHierarchyInWarehouse.LatestGLMajorCategoryName AS ''GlobalMajorExpenseCategoryName'',
		GlobalHierarchyInWarehouse.LatestGLMinorCategoryName AS ''GlobalMinorExpenseCategoryName'',
		ReportingHierarchyInWarehouse.LatestGLCategorizationName AS ''ReportingCategorization'',
		ReportingHierarchyInWarehouse.LatestGLFinancialCategoryName AS ''ReportingFinancialCategory'',
		ReportingHierarchyInWarehouse.LatestGLMajorCategoryName AS ''ReportingMajorExpenseCategoryName'',
		ReportingHierarchyInWarehouse.LatestGLMinorCategoryName AS ''ReportingMinorExpenseCategoryName'',
		AllocationRegion.AllocationRegionName AS ''AllocationRegionName'',
		AllocationRegion.AllocationSubRegionName AS ''AllocationSubRegionName'',
		AllocationRegion.AllocationSubRegionName AS ''AllocationSubRegionFilterName'',
		OriginatingRegion.OriginatingRegionName AS ''OriginatingRegionName'',
		OriginatingRegion.OriginatingSubRegionName AS ''OriginatingSubRegionName'',
		OriginatingRegion.OriginatingSubRegionName AS ''OriginatingSubRegionFilterName'',
		/* IMPORTANT
			The roll up to payroll is very sensitive information. It is crutial that information regarding payroll does not get communicated to
				TS employees.
		*/
		CASE 
			WHEN 
				@_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchyInWarehouse.LatestGLMajorCategoryName = ''Salaries/Taxes/Benefits'' 
			THEN
				''Payroll'' 
			ELSE
				FunctionalDepartment.FunctionalDepartmentName 
		END AS ''FunctionalDepartmentName'',
		PropertyFund.PropertyFundType AS ''EntityType'',
		PropertyFund.PropertyFundName AS ''EntityName'',
		#BudgetOwnerEntity.CalendarPeriod AS ''ActualsExpensePeriod'',
		#BudgetOwnerEntity.EntryDate AS ''EntryDate'',
		#BudgetOwnerEntity.[User],
		#BudgetOwnerEntity.[Description],
		#BudgetOwnerEntity.AdditionalDescription,
		#BudgetOwnerEntity.SourceName,
		#BudgetOwnerEntity.PropertyFundCode,
		CASE 
			WHEN 
				(SUBSTRING(#BudgetOwnerEntity.SourceName, CHARINDEX('' '', #BudgetOwnerEntity.SourceName) +1, 8) = ''Property'') 
			THEN
				RTRIM(#BudgetOwnerEntity.OriginatingRegionCode) + LTRIM(#BudgetOwnerEntity.FunctionalDepartmentCode) 
			ELSE
				#BudgetOwnerEntity.OriginatingRegionCode 
		END AS ''OriginatingRegionCode'',	    
		ISNULL(#BudgetOwnerEntity.GLAccountCode, '''') AS ''GlAccountCode'',
		ISNULL(#BudgetOwnerEntity.GLAccountName, '''') AS ''GlAccountName'',
		Reimbursable.ReimbursableName AS ''ReimbursableName'',
		
		--Month to date    
		SUM
		(
			CASE 
				WHEN
					(@_CalculationMethod = ''Gross'')
				THEN
					ISNULL(MtdGrossActual, 0) 
				ELSE
					ISNULL(MtdNetActual, 0) 
			END
		) AS ''MtdActual'',
		SUM
		(
			CASE 
				WHEN
					(@_CalculationMethod = ''Gross'')
				THEN
					ISNULL(MtdGrossBudget, 0) 
				ELSE
					ISNULL(MtdNetBudget, 0) 
			END
		) AS ''MtdOriginalBudget'',

		----------

		SUM
		(
			CASE 
				WHEN
					(@_CalculationMethod = ''Gross'') 
				THEN
					ISNULL
					(
						CASE 
							WHEN
								@_ReforecastQuarterName = ''Q0''
							THEN
								MtdGrossBudget 
							ELSE
								MtdGrossReforecast
						END,
						0
					) 
				ELSE
					ISNULL
					(
						CASE 
							WHEN
								@_ReforecastQuarterName = ''Q0''
							THEN
								MtdNetBudget 
							ELSE
								MtdNetReforecast
							END,
							0
					)
			END
		) AS ''MtdReforecast'',

		----------

		SUM
		(
			CASE 
				WHEN
					(@_CalculationMethod = ''Gross'') 
				THEN
					ISNULL
					(
						CASE 
							WHEN
								@_ReforecastQuarterName = ''Q0''
							THEN
								MtdGrossBudget 
							ELSE
								MtdGrossReforecast
							END, 
							0
					) - ISNULL(MtdGrossActual, 0) 
				ELSE
					ISNULL
					(
						CASE 
							WHEN
								@_ReforecastQuarterName = ''Q0''
							THEN
								MtdNetBudget 
							ELSE
								MtdNetReforecast
							END, 
							0
					) - ISNULL(MtdNetActual, 0) 
			END
		) AS ''MtdVariance'',	

		--Year to date
		SUM
		(
			CASE 
				WHEN
					(@_CalculationMethod = ''Gross'')
				THEN
					ISNULL(YtdGrossActual,0) 
				ELSE
					ISNULL(YtdNetActual,0) 
			END
		) AS ''YtdActual'',

		SUM
		(
			CASE
				WHEN
					(@_CalculationMethod = ''Gross'')
				THEN
					ISNULL(YtdGrossBudget, 0)
				ELSE
					ISNULL(YtdNetBudget, 0)
			END
		) AS ''YtdOriginalBudget'',

		----------

		SUM
		(
			CASE
				WHEN
					(@_CalculationMethod = ''Gross'')
				THEN
					ISNULL
					(
						CASE
							WHEN
								@_ReforecastQuarterName = ''Q0''
							THEN
								YtdGrossBudget
							ELSE
								YtdGrossReforecast
							END,
							0
						) 
				ELSE
					ISNULL
					(
						CASE
							WHEN
								@_ReforecastQuarterName = ''Q0''
							THEN
								YtdNetBudget
							ELSE
								YtdNetReforecast
							END,
							0
					)
			END
		) AS ''YtdReforecast'',

		----------

		SUM
		(
			CASE
				WHEN
					(@_CalculationMethod = ''Gross'')
				THEN
					ISNULL
					(
						CASE
							WHEN
								@_ReforecastQuarterName = ''Q0''
							THEN
								YtdGrossBudget
							ELSE
								YtdGrossReforecast
							END, 
							0
						) - ISNULL(YtdGrossActual, 0) 
				ELSE
					ISNULL
					(
						CASE 
							WHEN
								@_ReforecastQuarterName = ''Q0''
							THEN
								YtdNetBudget 
							ELSE
								YtdNetReforecast
							END, 
							0
					) - ISNULL(YtdNetActual, 0) 
			END
		) AS ''YtdVariance'',

		----------

		--Annual
		SUM
		(
			CASE
				WHEN
					(@_CalculationMethod = ''Gross'')
				THEN
					ISNULL(AnnualGrossBudget, 0)
				ELSE
					ISNULL(AnnualNetBudget, 0)
			END
		) AS ''AnnualOriginalBudget'',	

		----------

		SUM
		(
			CASE
				WHEN
					(@_CalculationMethod = ''Gross'')
				THEN
					ISNULL
					(
						CASE
							WHEN
								@_ReforecastQuarterName = ''Q0''
							THEN
								0
							ELSE
								AnnualGrossReforecast
						END,
						0
					)
				ELSE
					ISNULL
					(
						CASE
							WHEN
								@_ReforecastQuarterName = ''Q0''
							THEN
								0
							ELSE
								AnnualNetReforecast
						END,
						0
					)
			END
		) AS ''AnnualReforecast'',
		#LocalNonLocalMapping.LocalNonLocal,
		ISNULL(#DirectIndirectMapping.DirectIndirect, ''-'') AS ''DirectIndirect''
	INTO
		#Output
	FROM
		#BudgetOwnerEntity

		-- we want to return the latest allocation region name regardless of what the 
		-- name was at the point that the transaction was incurred, otherwise it is treated as multiple entities
		-- and grouped wrong
		INNER JOIN #AllocationSubRegionFilterTable AllocationRegion ON 
			#BudgetOwnerEntity.AllocationRegionKey = AllocationRegion.AllocationRegionKey

		-- we want to return the latest originating region name regardless of what the 
		-- name was at the point that the transaction was incurred, otherwise it is treated as multiple entities
		-- and grouped wrong
		INNER JOIN #OriginatingSubRegionFilterTable OriginatingRegion ON 
			#BudgetOwnerEntity.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey

		-- we want to return the latest functional department name regardless of what the 
		-- name was at the point that the transaction was incurred, otherwise it is treated as multiple entities
		-- and grouped wrong
		INNER JOIN #FunctionalDepartmentFilterTable FunctionalDepartment ON 
			#BudgetOwnerEntity.FunctionalDepartmentKey = FunctionalDepartment.FunctionalDepartmentKey

		INNER JOIN dbo.GLCategorizationHierarchyLatestState GlobalHierarchyInWarehouse ON
			#BudgetOwnerEntity.GlobalGLCategorizationKey = GlobalHierarchyInWarehouse.GLCategorizationHierarchyKey

		INNER JOIN dbo.GLCategorizationHierarchyLatestState ReportingHierarchyInWarehouse ON
			#BudgetOwnerEntity.ReportingGLCategorizationKey = ReportingHierarchyInWarehouse.GLCategorizationHierarchyKey

		-- we want to return the latest property fund name regardless of what the 
		-- name was at the point that the transaction was incurred, otherwise it is treated as multiple entities
		-- and grouped wrong
		INNER JOIN #EntityFilterTable PropertyFund ON 
			#BudgetOwnerEntity.PropertyFundKey = PropertyFund.PropertyFundKey

		INNER JOIN dbo.ActivityType ON 
			#BudgetOwnerEntity.ActivityTypeKey = ActivityType.ActivityTypeKey
			
		INNER JOIN dbo.Reimbursable ON
			#BudgetOwnerEntity.ReimbursableKey = Reimbursable.ReimbursableKey
		
		INNER JOIN #LocalNonLocalMapping ON
			AllocationRegion.AllocationSubRegionName = #LocalNonLocalMapping.AllocationSubRegionName AND
			AllocationRegion.AllocationRegionName = #LocalNonLocalMapping.AllocationRegionName AND
			OriginatingRegion.OriginatingSubRegionName = #LocalNonLocalMapping.OriginatingSubRegionName AND
			OriginatingRegion.OriginatingRegionName = #LocalNonLocalMapping.OriginatingRegionName

		LEFT OUTER JOIN #DirectIndirectMapping ON
			#BudgetOwnerEntity.SourceName = #DirectIndirectMapping.SourceName
	GROUP BY
		ActivityType.ActivityTypeName,
		ActivityType.ActivityTypeName,
		GlobalHierarchyInWarehouse.LatestGLCategorizationName,
		GlobalHierarchyInWarehouse.LatestGLFinancialCategoryName,
		GlobalHierarchyInWarehouse.LatestGLMajorCategoryName,
		GlobalHierarchyInWarehouse.LatestGLMinorCategoryName,
		ReportingHierarchyInWarehouse.LatestGLCategorizationName,
		ReportingHierarchyInWarehouse.LatestGLFinancialCategoryName,
		ReportingHierarchyInWarehouse.LatestGLMajorCategoryName,
		ReportingHierarchyInWarehouse.LatestGLMinorCategoryName,
		AllocationRegion.AllocationRegionName,
		AllocationRegion.AllocationSubRegionName,
		AllocationRegion.AllocationSubRegionName,
		OriginatingRegion.OriginatingRegionName,
		OriginatingRegion.OriginatingSubRegionName,
		OriginatingRegion.OriginatingSubRegionName,
		/* IMPORTANT
			The roll up to payroll is very sensitive information. It is crutial that information regarding payroll does not get communicated to
				TS employees.
		*/
		CASE 
			WHEN 
				@_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchyInWarehouse.LatestGLMajorCategoryName = ''Salaries/Taxes/Benefits'' 
			THEN
				''Payroll'' 
			ELSE
				FunctionalDepartment.FunctionalDepartmentName 
		END,
		PropertyFund.PropertyFundType,
		PropertyFund.PropertyFundName,
		#BudgetOwnerEntity.CalendarPeriod,
		#BudgetOwnerEntity.EntryDate,
		#BudgetOwnerEntity.[User],
		#BudgetOwnerEntity.[Description],
		#BudgetOwnerEntity.AdditionalDescription,
		#BudgetOwnerEntity.SourceName,
		#BudgetOwnerEntity.PropertyFundCode,
		CASE 
			WHEN 
				(SUBSTRING(#BudgetOwnerEntity.SourceName, CHARINDEX('' '', #BudgetOwnerEntity.SourceName) +1, 8) = ''Property'') 
			THEN
				RTRIM(#BudgetOwnerEntity.OriginatingRegionCode) + LTRIM(#BudgetOwnerEntity.FunctionalDepartmentCode) 
			ELSE
				#BudgetOwnerEntity.OriginatingRegionCode 
		END,	    
		ISNULL(#BudgetOwnerEntity.GLAccountCode, ''''),
		ISNULL(#BudgetOwnerEntity.GLAccountName, ''''),
		Reimbursable.ReimbursableName,
		#LocalNonLocalMapping.LocalNonLocal,
		ISNULL(#DirectIndirectMapping.DirectIndirect, ''-'')
	
END
				
/* ===============================================================================================================================================
	STEP 11: Get Final Results
   ============================================================================================================================================= */
BEGIN
	
	--------------------------------------------------------------------
	-- Insert the Global and Local results into temporary tables so that we can check whether there''s less than a million (or so) records in each
	--------------------------------------------------------------------

	-- The dataset for the Global categorization mappings
	SELECT
		ActivityTypeName,
		ActivityTypeFilterName,
		GlobalCategorization AS ''Categorization'',
		GlobalFinancialCategory AS ''FinancialCategory'',
		GlobalMajorExpenseCategoryName AS ''MajorExpenseCategoryName'',
		GlobalMinorExpenseCategoryName AS ''MinorExpenseCategoryName'',
		AllocationRegionName,
		AllocationSubRegionName,
		AllocationSubRegionFilterName,
		OriginatingRegionName,
		OriginatingSubRegionName,
		OriginatingSubRegionFilterName,
		FunctionalDepartmentName,
		EntityType,
		EntityName,
		ActualsExpensePeriod,
		--EntryDate,
		'''' AS EntryDate,
		--[User] AS ''User'',
		'''' AS ''User'',
		CASE
			WHEN
				(
					AnnualOriginalBudget <> 0 OR
					AnnualReforecast <> 0
				) AND
				(
					MtdActual = 0 OR
					YtdActual = 0
				)
			THEN
				''[BUDGET/REFORECAST]''
			ELSE
				LTRIM(RTRIM([Description]))
		END AS ''Description'',
		'''' AS AdditionalDescription,
		SourceName,
		PropertyFundCode,
		OriginatingRegionCode,
		GlAccountCode,
		GlAccountName,
		ReimbursableName,
		OriginatingSubRegionName + '' : '' + FunctionalDepartmentName AS ''OriginatingSubRegionFunctionlDepartment'',
		
		--Month to date    
		SUM(MtdActual) AS ''MtdActual'',
		SUM(MtdOriginalBudget) AS ''MtdOriginalBudget'',
		SUM(MtdReforecast) AS ''MtdReforecast'',
		SUM(MtdVariance) AS ''MtdVariance'',
		
		--Year to date
		SUM(YtdActual) AS ''YtdActual'',
		SUM(YtdOriginalBudget) AS ''YtdOriginalBudget'',
		SUM(YtdReforecast) AS ''YtdReforecast'',
		SUM(YtdVariance) AS ''YtdVariance'',

		--Annual
		SUM(AnnualOriginalBudget) AS ''AnnualOriginalBudget'',
		SUM(AnnualReforecast) AS ''AnnualReforecast'',

		LocalNonLocal,
		DirectIndirect
	INTO
		#FinalResultsGlobal
	FROM 
		#Output
	WHERE
		--Month to date    
		MtdActual <> 0.00 OR
		-- MtdOriginalBudget <> 0.00 OR
		MtdReforecast <> 0.00 OR
		MtdVariance <> 0.00 OR
		
		YtdActual <> 0.00 OR
		-- YtdOriginalBudget <> 0.00 OR
		YtdReforecast <> 0.00 OR
		YtdVariance <> 0.00 OR

		AnnualOriginalBudget <> 0.00 OR
		AnnualReforecast <> 0.00 
	GROUP BY
		  ActivityTypeName,
		ActivityTypeFilterName,
		GlobalCategorization,
		GlobalFinancialCategory,
		GlobalMajorExpenseCategoryName,
		GlobalMinorExpenseCategoryName,
		AllocationRegionName,
		AllocationSubRegionName,
		AllocationSubRegionFilterName,
		OriginatingRegionName,
		OriginatingSubRegionName,
		OriginatingSubRegionFilterName,
		FunctionalDepartmentName,
		EntityType,
		EntityName,
		ActualsExpensePeriod,
		--EntryDate,
		--[User],
		CASE
			WHEN
				(
					AnnualOriginalBudget <> 0 OR
					AnnualReforecast <> 0
				) AND
				(
					MtdActual = 0 OR
					YtdActual = 0
				)
			THEN
				''[BUDGET/REFORECAST]''
			ELSE
				LTRIM(RTRIM([Description]))
		END,
		--AdditionalDescription,
		SourceName,
		PropertyFundCode,
		OriginatingRegionCode,
		GlAccountCode,
		GlAccountName,
		ReimbursableName,

		LocalNonLocal,
		DirectIndirect

	-- The dataset for the default Local categorization mappings
	SELECT
		ActivityTypeName,
		ActivityTypeFilterName,
		ReportingCategorization AS ''Categorization'',
		ReportingFinancialCategory AS ''FinancialCategory'',
		ReportingMajorExpenseCategoryName AS ''MajorExpenseCategoryName'',
		ReportingMinorExpenseCategoryName AS ''MinorExpenseCategoryName'',
		AllocationRegionName,
		AllocationSubRegionName,
		AllocationSubRegionFilterName,
		OriginatingRegionName,
		OriginatingSubRegionName,
		OriginatingSubRegionFilterName,
		FunctionalDepartmentName,
		EntityType,
		EntityName,
		ActualsExpensePeriod,
		--EntryDate,
		'''' AS EntryDate,
		--[User] AS ''User'',
		'''' AS ''User'',
		CASE
			WHEN
				(
					AnnualOriginalBudget <> 0 OR
					AnnualReforecast <> 0
				) AND
				(
					MtdActual = 0 OR
					YtdActual = 0
				)
			THEN
				''[BUDGET/REFORECAST]''
			ELSE
				LTRIM(RTRIM([Description]))
		END AS ''Description'',																							  
		'''' AS AdditionalDescription,
		SourceName,
		PropertyFundCode,
		OriginatingRegionCode,
		GlAccountCode,
		GlAccountName,
		ReimbursableName,
		OriginatingSubRegionName + '' : '' + FunctionalDepartmentName AS ''OriginatingSubRegionFunctionlDepartment'',
		
		--Month to date    
		SUM(MtdActual) AS ''MtdActual'',
		SUM(MtdOriginalBudget) AS ''MtdOriginalBudget'',
		SUM(MtdReforecast) AS ''MtdReforecast'',
		SUM(MtdVariance) AS ''MtdVariance'',
		
		--Year to date
		SUM(YtdActual) AS ''YtdActual'',
		SUM(YtdOriginalBudget) AS ''YtdOriginalBudget'',
		SUM(YtdReforecast) AS ''YtdReforecast'',
		SUM(YtdVariance) AS ''YtdVariance'',

		--Annual
		SUM(AnnualOriginalBudget) AS ''AnnualOriginalBudget'',
		SUM(AnnualReforecast) AS ''AnnualReforecast'',
		
		LocalNonLocal,
		DirectIndirect
	INTO
		#FinalResultsLocal
	FROM 
		#Output
	WHERE
		/*
			If local categorizations are not set to be reported, this makes sure they aren''t include in the report
		*/
		1 = @_IncludeLocalCategorization AND  
		(    
			MtdActual <> 0.00 OR
			-- MtdOriginalBudget <> 0.00 OR
			MtdReforecast <> 0.00 OR
			MtdVariance <> 0.00 OR
			
			YtdActual <> 0.00 OR
			-- YtdOriginalBudget <> 0.00 OR
			YtdReforecast <> 0.00 OR
			YtdVariance <> 0.00 OR

			AnnualOriginalBudget <> 0.00 OR
			AnnualReforecast <> 0.00 
		)
	GROUP BY
		ActivityTypeName,
		ActivityTypeFilterName,
		ReportingCategorization,
		ReportingFinancialCategory,
		ReportingMajorExpenseCategoryName,
		ReportingMinorExpenseCategoryName,
		AllocationRegionName,
		AllocationSubRegionName,
		AllocationSubRegionFilterName,
		OriginatingRegionName,
		OriginatingSubRegionName,
		OriginatingSubRegionFilterName,
		FunctionalDepartmentName,
		EntityType,
		EntityName,
		ActualsExpensePeriod,
		--EntryDate,
		--[User],
		CASE
			WHEN
				(
					AnnualOriginalBudget <> 0 OR
					AnnualReforecast <> 0
				) AND
				(
					MtdActual = 0 OR
					YtdActual = 0
				)
			THEN
				''[BUDGET/REFORECAST]''
			ELSE
				LTRIM(RTRIM([Description]))
		END,
		--AdditionalDescription,
		SourceName,
		PropertyFundCode,
		OriginatingRegionCode,
		GlAccountCode,
		GlAccountName,
		ReimbursableName,
		LocalNonLocal,
		DirectIndirect

	-------------------------------------------------------------
	-- GLOBAL
	-------------------------------------------------------------

	DECLARE @MaximumRecordsInExcel INT = (1048576 - 2) -- 1,048,576 is the maximum, but we need a row for the header and one as a safe-guard
	DECLARE @DescriptionLength INT = 17

	IF ((SELECT COUNT(*) FROM #FinalResultsGlobal) > @MaximumRecordsInExcel) -- If we are over the limit
	BEGIN

		-- If the data IS sensitised, only return the first ''@DescriptionLength'' characters of the description to help it roll up more
		-- If the data IS NOT sensitised, remove the description completely (replace with '''')

		SELECT
			ActivityTypeName,
			ActivityTypeFilterName,
			Categorization,
			FinancialCategory,
			MajorExpenseCategoryName,
			MinorExpenseCategoryName,
			AllocationRegionName,
			AllocationSubRegionName,
			AllocationSubRegionFilterName,
			OriginatingRegionName,
			OriginatingSubRegionName,
			OriginatingSubRegionFilterName,
			FunctionalDepartmentName,
			EntityType,
			EntityName,
			ActualsExpensePeriod,
			EntryDate,
			[User],
			CASE
				WHEN
					@_DontSensitizeMRIPayrollData = 1 -- Data IS NOT sensitised
				THEN
					'''' -- remove the Description field completely because trimming the Description will not reduce the number of records by enough
				ELSE -- Data IS sensitised	
					CASE
						WHEN
							[Description] <> ''[BUDGET/REFORECAST]''
						THEN
							LEFT([Description], @DescriptionLength)
						ELSE
							[Description]
					END
			END AS [Description],
			AdditionalDescription,
			SourceName,
			PropertyFundCode,
			OriginatingRegionCode,
			GlAccountCode,
			GlAccountName,
			
			ReimbursableName,
			OriginatingSubRegionFunctionlDepartment,

			--Month to date
			SUM(MtdActual) AS ''MtdActual'',
			SUM(MtdOriginalBudget) AS ''MtdOriginalBudget'',
			SUM(MtdReforecast) AS ''MtdReforecast'',
			SUM(MtdVariance) AS ''MtdVariance'',

			--Year to date
			SUM(YtdActual) AS ''YtdActual'',
			SUM(YtdOriginalBudget) AS ''YtdOriginalBudget'',
			SUM(YtdReforecast) AS ''YtdReforecast'',
			SUM(YtdVariance) AS ''YtdVariance'',

			--Annual
			SUM(AnnualOriginalBudget) AS ''AnnualOriginalBudget'',
			SUM(AnnualReforecast) AS ''AnnualReforecast'',

			LocalNonLocal,
			DirectIndirect
		FROM
			#FinalResultsGlobal
		GROUP BY
			ActivityTypeName,
			ActivityTypeFilterName,
			Categorization,
			FinancialCategory,
			MajorExpenseCategoryName,
			MinorExpenseCategoryName,
			AllocationRegionName,
			AllocationSubRegionName,
			AllocationSubRegionFilterName,
			OriginatingRegionName,
			OriginatingSubRegionName,
			OriginatingSubRegionFilterName,
			FunctionalDepartmentName,
			EntityType,
			EntityName,
			ActualsExpensePeriod,
			EntryDate,
			[User],
			CASE
				WHEN
					@_DontSensitizeMRIPayrollData = 1 -- Data IS NOT sensitised
				THEN
					'''' -- remove the Description field completely because trimming the Description will not reduce the number of records by enough
				ELSE -- Data IS sensitised	
					CASE
						WHEN
							[Description] <> ''[BUDGET/REFORECAST]''
						THEN
							LEFT([Description], @DescriptionLength)
						ELSE
							[Description]
					END
			END,
			AdditionalDescription,
			SourceName,
			PropertyFundCode,
			OriginatingRegionCode,
			GlAccountCode,
			GlAccountName,
			ReimbursableName,
			OriginatingSubRegionFunctionlDepartment,
			LocalNonLocal,
			DirectIndirect
		HAVING
			SUM(MtdActual) <> 0.00 OR
			SUM(MtdOriginalBudget) <> 0.00 OR
			SUM(MtdReforecast) <> 0.00 OR
			SUM(MtdVariance) <> 0.00 OR

			--Year to date
			SUM(YtdActual) <> 0.00 OR
			SUM(YtdOriginalBudget) <> 0.00 OR
			SUM(YtdReforecast) <> 0.00 OR
			SUM(YtdVariance) <> 0.00 OR

			--Annual
			SUM(AnnualOriginalBudget) <> 0.00 OR
			SUM(AnnualReforecast) <> 0.00

	END
	ELSE -- Else we are under the limit: just select the results as-is
	BEGIN

		SELECT
			ActivityTypeName,
			ActivityTypeFilterName,
			Categorization,
			FinancialCategory,
			MajorExpenseCategoryName,
			MinorExpenseCategoryName,
			AllocationRegionName,
			AllocationSubRegionName,
			AllocationSubRegionFilterName,
			OriginatingRegionName,
			OriginatingSubRegionName,
			OriginatingSubRegionFilterName,
			FunctionalDepartmentName,
			EntityType,
			EntityName,
			ActualsExpensePeriod,
			EntryDate,
			[User],
			[Description],
			AdditionalDescription,
			SourceName,
			PropertyFundCode,
			OriginatingRegionCode,
			GlAccountCode,
			GlAccountName,
			
			ReimbursableName,
			OriginatingSubRegionFunctionlDepartment,

			--Month to date
			MtdActual,
			MtdOriginalBudget,
			MtdReforecast,
			MtdVariance,

			--Year to date
			YtdActual,
			YtdOriginalBudget,
			YtdReforecast,
			YtdVariance,

			--Annual
			AnnualOriginalBudget,
			AnnualReforecast,

			LocalNonLocal,
			DirectIndirect
		FROM
			#FinalResultsGlobal
		WHERE
			--Month to date    
			MtdActual <> 0.00 OR
			-- MtdOriginalBudget <> 0.00 OR
			MtdReforecast <> 0.00 OR
			MtdVariance <> 0.00 OR
			
			YtdActual <> 0.00 OR
			-- YtdOriginalBudget <> 0.00 OR
			YtdReforecast <> 0.00 OR
			YtdVariance <> 0.00 OR

			AnnualOriginalBudget <> 0.00 OR
			AnnualReforecast <> 0.00
	END

	-------------------------------------------------------------
	-- LOCAL
	-------------------------------------------------------------

	IF ((SELECT COUNT(*) FROM #FinalResultsGlobal) > @MaximumRecordsInExcel) -- If we are over the limit
	BEGIN

		-- If the data IS sensitised, only return the first ''@DescriptionLength'' characters of the description to help it roll up more
		-- If the data IS NOT sensitised, remove the description completely (replace with '''')

		SELECT
			ActivityTypeName,
			ActivityTypeFilterName,
			Categorization,
			FinancialCategory,
			MajorExpenseCategoryName,
			MinorExpenseCategoryName,
			AllocationRegionName,
			AllocationSubRegionName,
			AllocationSubRegionFilterName,
			OriginatingRegionName,
			OriginatingSubRegionName,
			OriginatingSubRegionFilterName,
			FunctionalDepartmentName,
			EntityType,
			EntityName,
			ActualsExpensePeriod,
			EntryDate,
			[User],
			CASE
				WHEN
					@_DontSensitizeMRIPayrollData = 1 -- Data IS NOT sensitised
				THEN
					'''' -- remove the Description field completely because trimming the Description will not reduce the number of records by enough
				ELSE -- Data IS sensitised	
					CASE
						WHEN
							[Description] <> ''[BUDGET/REFORECAST]''
						THEN
							LEFT([Description], @DescriptionLength)
						ELSE
							[Description]
					END
			END AS [Description],
			AdditionalDescription,
			SourceName,
			PropertyFundCode,
			OriginatingRegionCode,
			GlAccountCode,
			GlAccountName,
			ReimbursableName,
			OriginatingSubRegionFunctionlDepartment,

			--Month to date    
			SUM(MtdActual) AS ''MtdActual'',
			SUM(MtdOriginalBudget) AS ''MtdOriginalBudget'',
			SUM(MtdReforecast) AS ''MtdReforecast'',
			SUM(MtdVariance) AS ''MtdVariance'',

			--Year to date
			SUM(YtdActual) AS ''YtdActual'',
			SUM(YtdOriginalBudget) AS ''YtdOriginalBudget'',
			SUM(YtdReforecast) AS ''YtdReforecast'',
			SUM(YtdVariance) AS ''YtdVariance'',

			--Annual
			SUM(AnnualOriginalBudget) AS ''AnnualOriginalBudget'',
			SUM(AnnualReforecast) AS ''AnnualReforecast'',

			LocalNonLocal,
			DirectIndirect
		FROM
			#FinalResultsLocal
		GROUP BY
			ActivityTypeName,
			ActivityTypeFilterName,
			Categorization,
			FinancialCategory,
			MajorExpenseCategoryName,
			MinorExpenseCategoryName,
			AllocationRegionName,
			AllocationSubRegionName,
			AllocationSubRegionFilterName,
			OriginatingRegionName,
			OriginatingSubRegionName,
			OriginatingSubRegionFilterName,
			FunctionalDepartmentName,
			EntityType,
			EntityName,
			ActualsExpensePeriod,
			EntryDate,
			[User],
			CASE
				WHEN
					@_DontSensitizeMRIPayrollData = 1 -- Data IS NOT sensitised
				THEN
					'''' -- remove the Description field completely because trimming the Description will not reduce the number of records by enough
				ELSE -- Data IS sensitised	
					CASE
						WHEN
							[Description] <> ''[BUDGET/REFORECAST]''
						THEN
							LEFT([Description], @DescriptionLength)
						ELSE
							[Description]
					END
			END,
			AdditionalDescription,
			SourceName,
			PropertyFundCode,
			OriginatingRegionCode,
			GlAccountCode,
			GlAccountName,
			ReimbursableName,
			OriginatingSubRegionFunctionlDepartment,
			LocalNonLocal,
			DirectIndirect
		HAVING
			SUM(MtdActual) <> 0.00 OR
			SUM(MtdOriginalBudget) <> 0.00 OR
			SUM(MtdReforecast) <> 0.00 OR
			SUM(MtdVariance) <> 0.00 OR

			--Year to date
			SUM(YtdActual) <> 0.00 OR
			SUM(YtdOriginalBudget) <> 0.00 OR
			SUM(YtdReforecast) <> 0.00 OR
			SUM(YtdVariance) <> 0.00 OR

			--Annual
			SUM(AnnualOriginalBudget) <> 0.00 OR
			SUM(AnnualReforecast) <> 0.00

	END
	ELSE -- Else we are under the limit: just select the results as-is
	BEGIN

		SELECT
			ActivityTypeName,
			ActivityTypeFilterName,
			Categorization,
			FinancialCategory,
			MajorExpenseCategoryName,
			MinorExpenseCategoryName,
			AllocationRegionName,
			AllocationSubRegionName,
			AllocationSubRegionFilterName,
			OriginatingRegionName,
			OriginatingSubRegionName,
			OriginatingSubRegionFilterName,
			FunctionalDepartmentName,
			EntityType,
			EntityName,
			ActualsExpensePeriod,
			EntryDate,
			[User],
			[Description],
			AdditionalDescription,
			SourceName,
			PropertyFundCode,
			OriginatingRegionCode,
			GlAccountCode,
			GlAccountName,
			ReimbursableName,
			OriginatingSubRegionFunctionlDepartment,
			
			--Month to date    
			MtdActual,
			MtdOriginalBudget,
			MtdReforecast,
			MtdVariance,
			
			--Year to date
			YtdActual,
			YtdOriginalBudget,
			YtdReforecast,
			YtdVariance,

			--Annual
			AnnualOriginalBudget,
			AnnualReforecast,
			
			LocalNonLocal,
			DirectIndirect			
		FROM
			#FinalResultsLocal
		WHERE
			--Month to date    
			MtdActual <> 0.00 OR
			-- MtdOriginalBudget <> 0.00 OR
			MtdReforecast <> 0.00 OR
			MtdVariance <> 0.00 OR
			
			YtdActual <> 0.00 OR
			-- YtdOriginalBudget <> 0.00 OR
			YtdReforecast <> 0.00 OR
			YtdVariance <> 0.00 OR

			AnnualOriginalBudget <> 0.00 OR
			AnnualReforecast <> 0.00

	END

END
	
/* ===============================================================================================================================================
	STEP 12: Clean Up
   ============================================================================================================================================= */
BEGIN

	IF OBJECT_ID(''tempdb..#EntityFilterTable'') IS NOT NULL
		DROP TABLE #EntityFilterTable

	IF OBJECT_ID(''tempdb..#ExchangeRate'') IS NOT NULL
		DROP TABLE #ExchangeRate
		
	IF OBJECT_ID(''tempdb..#OriginatingSubRegionFilterTable'') IS NOT NULL
		DROP TABLE #OriginatingSubRegionFilterTable

	IF OBJECT_ID(''tempdb..#AllocationSubRegionFilterTable'') IS NOT NULL
		DROP TABLE #AllocationSubRegionFilterTable

	IF OBJECT_ID(''tempdb..#CategorizationHierarchyFilterTable'') IS NOT NULL
		DROP TABLE #CategorizationHierarchyFilterTable

	IF 	OBJECT_ID(''tempdb..#BudgetOwnerEntity'') IS NOT NULL
		DROP TABLE #BudgetOwnerEntity

	IF  OBJECT_ID(''tempdb..#LocalNonLocalMapping'') IS NOT NULL
		DROP TABLE #LocalNonLocalMapping
		
	IF  OBJECT_ID(''tempdb..#DirectIndirectMapping'') IS NOT NULL
		DROP TABLE #DirectIndirectMapping

	IF  OBJECT_ID(''tempdb..#Output'') IS NOT NULL
		DROP TABLE #Output

	IF  OBJECT_ID(''tempdb..#FinalResultsGlobal'') IS NOT NULL
		DROP TABLE #FinalResultsGlobal

	IF  OBJECT_ID(''tempdb..#FinalResultsLocal'') IS NOT NULL
		DROP TABLE #FinalResultsLocal

END
	
END -- End Stored Procedure

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginator]    Script Date: 03/08/2012 12:51:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOriginator]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_R_BudgetOriginator]
	@ReportExpensePeriod INT,
	@ReforecastQuarterName VARCHAR(2), -- ''Q0'', ''Q1'', ''Q2'', or ''Q3''
	@DestinationCurrency VARCHAR(3),
	@EntityList VARCHAR(MAX),
	@DontSensitizeMRIPayrollData BIT,
	@CalculationMethod VARCHAR(50),
	@OriginatingSubRegionList VARCHAR(MAX),
	@AllocationSubRegionList VARCHAR(MAX),
	@FunctionalDepartmentList VARCHAR(MAX),	
	@HierarchyReportParameter dbo.ReportParameterGLCategorizationHierarchyDetail READONLY
AS

/* =============================================================================================================================================
	Description
		The stored procedure is used for generating the data for the Budget Originator report.
	
	History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

				2011-07-08		: PKayongo	:	Sensitized payroll data for the MRI Source, Originating Region Code and 
												Property Fund fields. (CC20)
				2011-07-11		: PKayongo	:	Allowed reforecast values to be dynamically selected from the 
												@ReforecastQuarterName variable. Only 1 reforecast dynamic query remained
												and only the different reforecast fields at the end (i.e. Q1, Q2, Q3)
												were consolidated into 1.
				2011-08-08		: SNothling	:	Set sensitized strings to ''Sensitized'' instead of ''''
   =========================================================================================================================================== */
BEGIN

/* =============================================================================================================================================
	STEP 1: Declare local variables - this makes debugging and testing easier	
	
	NOTE: We do not specify parameter defaults. We assume that all parameters have been saved correctly and completely in GRP, and we want the
		stored procedure to break if an expected parameter is not passed through. This prevents unexpected behaviour.
   =========================================================================================================================================== */
BEGIN

	DECLARE
		@_ReportExpensePeriod               INT = @ReportExpensePeriod,
		@_ReforecastQuarterName     VARCHAR(10) = @ReforecastQuarterName,
		@_DestinationCurrency        VARCHAR(3) = @DestinationCurrency,
		@_EntityList               VARCHAR(MAX) = @EntityList,
		@_DontSensitizeMRIPayrollData       BIT = @DontSensitizeMRIPayrollData,
		@_CalculationMethod        VARCHAR(MAX) = @CalculationMethod,
		@_FunctionalDepartmentList VARCHAR(MAX) = @FunctionalDepartmentList,
		@_OriginatingSubRegionList VARCHAR(MAX) = @OriginatingSubRegionList,
		@_AllocationSubRegionList  VARCHAR(MAX) = @AllocationSubRegionList
			
END
																																																																																																																																																																																																																																																																																																		
/* =============================================================================================================================================
	STEP 2: Set up the Report Filter Variable defaults		
	
		1. The report expense period defaults to the current report expense period
		2. The report expense period parameter is a pre-formatted string used in the select statements of the results
		3. The default destination currency is USD
		4. The calendar year defaults to the year of the expense period
		5. The reforecast quarter name defaults to the latest reforecast quarter name in the database
		   for the given period
		6. If there is no active reforecast for that period - reforecast name combination, get the latest active
		   reforecast
		7. Get the exchange rate set of the selected active reforecast
   =========================================================================================================================================== */
BEGIN

	-- Calculate default report expense period if none specified
	IF @_ReportExpensePeriod IS NULL
		SET @_ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + REPLACE(STR(MONTH(GETDATE()),2 ),'' '',''0'')AS INT)

	-- Pre-format Report Expense period string
	DECLARE @ReportExpensePeriodParameter VARCHAR(6) = STR(@_ReportExpensePeriod, 6, 0)

	-- Calculate destination currency if none specified
	IF @_DestinationCurrency IS NULL
		SET @_DestinationCurrency = ''USD''

	-- Calculate default calendar year if none specified
	DECLARE @CalendarYear AS SMALLINT = CAST(SUBSTRING(CAST(@_ReportExpensePeriod AS VARCHAR(10)), 1, 4) AS SMALLINT)

	-- Calculate default reforecast quarter name if not specified
	IF @_ReforecastQuarterName IS NULL OR @_ReforecastQuarterName NOT IN (''Q0'', ''Q1'', ''Q2'', ''Q3'')
		SET @_ReforecastQuarterName = (
			SELECT TOP 1
				ReforecastQuarterName 
			FROM
				dbo.Reforecast
			WHERE
				ReforecastEffectivePeriod <= @_ReportExpensePeriod AND
				ReforecastEffectiveYear = LEFT(CAST(@_ReportExpensePeriod AS VARCHAR(6)),4)
			ORDER BY
				ReforecastEffectivePeriod DESC )

	---- Calculate reforecast effective period from reforecast name
	DECLARE @ReforecastEffectivePeriod INT = (
			SELECT TOP 1
				ReforecastEffectivePeriod
			FROM
				dbo.Reforecast
			WHERE
				ReforecastEffectiveYear = LEFT(CAST(@_ReportExpensePeriod AS VARCHAR(6)),4) AND
				ReforecastQuarterName = @_ReforecastQuarterName
			ORDER BY
				ReforecastEffectivePeriod )
			
	-- Determine the ReforecastKey of the reforecast that is currently active (i.e.: 2011 Q1, 2011 Q2, 2012 Q0 etc)
	DECLARE @ActiveReforecastKey INT = (
			SELECT 
				ReforecastKey
			FROM
				dbo.GetReforecastRecord(@_ReportExpensePeriod, @_ReforecastQuarterName) )

	-- Safeguard against NULL ReforecastKey returned from previous statement
	IF (@ActiveReforecastKey IS NULL)
	BEGIN
		SET @ActiveReforecastKey = (
			SELECT
				MAX(ReforecastKey)
			FROM
				dbo.ExchangeRate )
		PRINT (''Near disaster: @ActiveReforecastKey is NULL, so reverting to the largest/most recent ReforecastKey in dbo.ExchangeRate: '' + CONVERT(VARCHAR(10), @ActiveReforecastKey))
	END 

	-- Get the GLCategorizationHierarchy to join on
	DECLARE @GLCategorizationParameter VARCHAR(50) = (
			SELECT DISTINCT
				GLCategorizationName
			FROM
				@HierarchyReportParameter )
			
	-- Determine Report Exchange Rates: get the exchange rate set for the specified reforecast
	SELECT
		SourceCurrencyKey,
		DestinationCurrencyKey,
		CalendarKey,
		Rate
	INTO
		#ExchangeRate
	FROM
		dbo.ExchangeRate
	WHERE
		ReforecastKey = @ActiveReforecastKey -- We will use the exchange rate set that is active for the current reforecast.

END

/* =============================================================================================================================================
	STEP 3: Set up Direct/Indirect Mapping
	
		Change Control 14. CC Ref 5.4 Create Direct or Indirect field and map Direct to all the properties, 
		and Indirect to all the Corporates	
		
		8.	As per Change Control 14 , the following logic will be used to determine the values of the direct/indirect 
		column in the budget owner and budget originator reports :
		
		Source			Indirect/Direct
		
		EU Property		Direct
		US Property		Direct
		IN Property		Direct
		CN Property		Direct
		BR Property		Direct
		EU Corporate	Indirect
		US Corporate	Indirect
		IN Corporate	Indirect
		CN Corporate	Indirect
		BR Corporate	Indirect
		Unknown			—

	========================================================================================================================================== */
BEGIN

	-- Change Control 14. CC Ref 5.4 Create Direct or Indirect field and map Direct to all the properties, and Indirect to all the Corporates	
	CREATE TABLE #DirectIndirectMapping
	(
		SourceName varchar(50) PRIMARY KEY ,
		DirectIndirect varchar (10),
	)

	INSERT INTO #DirectIndirectMapping
	SELECT
		SourceName,
		''Direct'' AS ''DirectIndirect''
	FROM
		dbo.[Source]
	WHERE
		IsProperty = ''YES''
	UNION
	SELECT
		SourceName,
		''Indirect'' AS ''DirectIndirect''
	FROM
		dbo.[Source]
	WHERE
		IsCorporate = ''YES''
	UNION
	SELECT
		SourceName,
		''-'' AS ''DirectIndirect''
	FROM
		dbo.[Source]
	WHERE
		IsCorporate = ''NO'' AND
		IsProperty = ''NO''

END

/* =============================================================================================================================================
	STEP 5: Set up the Report Filter Tables
	
		1. Reporting Entities - Get a table containing all the reporting entities specified in the filter parameter
		2. Originating Sub Regions - Get a table containing all the originating sub regions specified in the filter parameter
		3. Allocation Sub Regions - Get a table containing all the allocation sub regions specified in the filter parameter
	========================================================================================================================================== */
BEGIN
	
	----------------------------------------------------------------------------
	-- Reporting Entities
	----------------------------------------------------------------------------

		CREATE TABLE #EntityFilterTable	
		(
			PropertyFundKey INT NOT NULL,
			PropertyFundName VARCHAR(MAX) NOT NULL,
			PropertyFundType VARCHAR(MAX) NOT NULL
		)

		IF (@_EntityList IS NOT NULL)
		BEGIN

			IF (@_EntityList <> ''All'')
			BEGIN

				INSERT INTO #EntityFilterTable
				SELECT DISTINCT 
					PropertyFundLatestState.PropertyFundKey,
					PropertyFundLatestState.LatestPropertyFundName,
					PropertyFundLatestState.LatestPropertyFundType
				FROM 
					dbo.Split(@_EntityList) EntityListParameters
					INNER JOIN dbo.PropertyFund ON 
						PropertyFund.PropertyFundName = EntityListParameters.item
					INNER JOIN dbo.PropertyFundLatestState ON
						PropertyFund.PropertyFundId = PropertyFundLatestState.PropertyFundId AND
						PropertyFund.SnapshotId = PropertyFundLatestState.PropertyFundSnapshotId
			END
			ELSE IF (@_EntityList = ''All'')
			BEGIN

				INSERT INTO #EntityFilterTable
				SELECT DISTINCT
					PropertyFundLatestState.PropertyFundKey,
					PropertyFundLatestState.LatestPropertyFundName AS PropertyFundName,
					PropertyFundLatestState.LatestPropertyFundType AS PropertyFundType
				FROM 
					dbo.PropertyFundLatestState

			END

		END

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable (PropertyFundKey)

	----------------------------------------------------------------------------
	-- Originating Sub Region
	----------------------------------------------------------------------------

	CREATE TABLE #OriginatingSubRegionFilterTable 
	(
		OriginatingRegionKey INT NOT NULL,
		OriginatingRegionName VARCHAR(MAX) NOT NULL,
		OriginatingSubRegionName VARCHAR(MAX) NOT NULL
	)

	IF (@_OriginatingSubRegionList IS NOT NULL)
	BEGIN

		IF (@_OriginatingSubRegionList <> ''All'')

		BEGIN
		
			INSERT INTO #OriginatingSubRegionFilterTable
			SELECT DISTINCT
				OriginatingRegionLatestState.OriginatingRegionKey,
				OriginatingRegionLatestState.LatestOriginatingRegionName,
				OriginatingRegionLatestState.LatestOriginatingSubRegionName
			FROM 
				dbo.Split(@_OriginatingSubRegionList) OriginatingSubRegionParameters
				INNER JOIN dbo.OriginatingRegion ON 
					OriginatingRegion.SubRegionName = OriginatingSubRegionParameters.item
				INNER JOIN dbo.OriginatingRegionLatestState ON
					OriginatingRegion.GlobalRegionId = OriginatingRegionLatestState.OriginatingRegionGlobalRegionId AND
					OriginatingRegion.SnapshotId = OriginatingRegionLatestState.OriginatingRegionSnapshotId
		END

		ELSE IF (@_OriginatingSubRegionList = ''All'')
		BEGIN

			INSERT INTO #OriginatingSubRegionFilterTable
			SELECT DISTINCT
				OriginatingRegionLatestState.OriginatingRegionKey,
				OriginatingRegionLatestState.LatestOriginatingRegionName,
				OriginatingRegionLatestState.LatestOriginatingSubRegionName
			FROM 
				dbo.OriginatingRegionLatestState
		END

	END

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable (OriginatingRegionKey)

	----------------------------------------------------------------------------
	-- Allocation Sub Region
	----------------------------------------------------------------------------

	CREATE TABLE #AllocationSubRegionFilterTable 
	(
		AllocationRegionKey INT NOT NULL,
		AllocationRegionName VARCHAR(MAX) NOT NULL,
		AllocationSubRegionName VARCHAR(MAX) NOT NULL
	)

	IF (@_AllocationSubRegionList IS NOT NULL)
	BEGIN

		IF (@_AllocationSubRegionList <> ''All'')
		BEGIN

			INSERT INTO #AllocationSubRegionFilterTable
			SELECT DISTINCT
				AllocationRegionLatestState.AllocationRegionKey,
				AllocationRegionLatestState.LatestAllocationRegionName,
				AllocationRegionLatestState.LatestAllocationSubRegionName
			FROM 
				dbo.Split(@_AllocationSubRegionList) AllocationSubRegionParameters
				INNER JOIN dbo.AllocationRegion ON
					AllocationRegion.SubRegionName = AllocationSubRegionParameters.item
				INNER JOIN dbo.AllocationRegionLatestState ON
					AllocationRegion.GlobalRegionId = AllocationRegionLatestState.AllocationRegionGlobalRegionId AND
					AllocationRegion.SnapshotId = AllocationRegionLatestState.AllocationRegionSnapshotId
					
		END
		ELSE IF (@_AllocationSubRegionList = ''All'')
		BEGIN

			INSERT INTO #AllocationSubRegionFilterTable
			SELECT DISTINCT
				AllocationRegionLatestState.AllocationRegionKey,
				AllocationRegionLatestState.LatestAllocationRegionName,
				AllocationRegionLatestState.LatestAllocationSubRegionName
			FROM
				dbo.AllocationRegionLatestState

		END

	END

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)


	----------------------------------------------------------------------------
	-- Functional Departments
	----------------------------------------------------------------------------

	CREATE TABLE #FunctionalDepartmentFilterTable 
	(
		FunctionalDepartmentKey INT NOT NULL,
		FunctionalDepartmentName VARCHAR(MAX) NOT NULL
	)

	IF (@_FunctionalDepartmentList IS NOT NULL)
	BEGIN	

		IF (@_FunctionalDepartmentList <> ''All'')
		BEGIN

			INSERT INTO #FunctionalDepartmentFilterTable
			SELECT DISTINCT
				FunctionalDepartmentLatestState.FunctionalDepartmentKey,
				FunctionalDepartmentLatestState.LatestFunctionalDepartmentName
			FROM
				dbo.Split(@_FunctionalDepartmentList) FunctionalDepartmentParameters
				INNER JOIN dbo.FunctionalDepartment ON
					FunctionalDepartment.FunctionalDepartmentName = FunctionalDepartmentParameters.item	
				INNER JOIN FunctionalDepartmentLatestState ON
					FunctionalDepartment.ReferenceCode = FunctionalDepartmentLatestState.FunctionalDepartmentReferenceCode

		END
		ELSE IF (@_FunctionalDepartmentList = ''All'')
		BEGIN

			INSERT INTO #FunctionalDepartmentFilterTable
			SELECT DISTINCT
				FunctionalDepartmentLatestState.FunctionalDepartmentKey,
				FunctionalDepartmentLatestState.LatestFunctionalDepartmentName
			FROM 
				dbo.FunctionalDepartmentLatestState

		END

	END

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)

	----------------------------------------------------------------------------
	-- Categorization Hierarchy
	----------------------------------------------------------------------------

	CREATE TABLE #CategorizationHierarchyFilterTable
	(
		CategorizationHierarchyKey INT NOT NULL,
		GLCategorizationName VARCHAR(50) NOT NULL,
		GLFinancialCategoryName VARCHAR(400) NOT NULL,
		GLMajorCategoryName VARCHAR(400) NOT NULL,
		GLMinorCategoryName VARCHAR(400) NOT NULL,
		GLAccountCode VARCHAR(15) NOT NULL,
		GLAccountName VARCHAR(300) NOT NULL
	)
	
	INSERT INTO #CategorizationHierarchyFilterTable
	SELECT DISTINCT
		GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey,
		GLCategorizationHierarchyLatestState.LatestGLCategorizationName,
		GLCategorizationHierarchyLatestState.LatestGLFinancialCategoryName,
		GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName,
		GLCategorizationHierarchyLatestState.LatestGLMinorCategoryName,
		GLCategorizationHierarchyLatestState.LatestGLAccountCode,
		GLCategorizationHierarchyLatestState.LatestGlAccountName
	FROM 
		@HierarchyReportParameter HierarchyReportParameter
		INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
			(
				HierarchyReportParameter.FinancialCategoryName = ''All'' OR
				HierarchyReportParameter.FinancialCategoryName = GLCategorizationHierarchyLatestState.LatestGLFinancialCategoryName
			) AND
			(
				HierarchyReportParameter.GLMajorCategoryName = ''All'' OR
				HierarchyReportParameter.GLMajorCategoryName = GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName
			) AND
			(
				HierarchyReportParameter.GLMinorCategoryName = ''All'' OR
				HierarchyReportParameter.GLMinorCategoryName = GLCategorizationHierarchyLatestState.LatestGLMinorCategoryName
			)
	WHERE
		GLCategorizationHierarchyLatestState.LatestInflowOutflow <> ''Inflow'' AND
		GLCategorizationHierarchyLatestState.LatestGLMinorCategoryName <> ''Architects & Engineering'' AND	-- IMS 51655
		GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName NOT IN
			(
				''Corporate Tax'',
				''Depreciation Expense'',
				''Realized (Gain)/Loss'',
				''Unrealized (Gain)/Loss'',
				''Miscellaneous Expense'',
				''Miscellaneous Income'', -- Should be excluded by virtue of the fact that we are excluding ''Inflow'' above, but do it again here
				''Interest & Penalties'',
				''Guaranteed Payment''
			)
		

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #CategorizationHierarchyFilterTable (CategorizationHierarchyKey)

END
		
/* ==============================================================================================================================================
	STEP 6: Create results temp table

		We will insert all the resulting transaction data into this result temp table:

		1. Actuals transactions
		2. Budget transactions
		3. Reforecast transactions
   =========================================================================================================================================== */
BEGIN
	
	CREATE TABLE #BudgetOriginatorEntity
	(
		ActivityTypeKey					INT,	
		GLCategorizationHierarchyKey	INT,
		AllocationRegionKey				INT,
		OriginatingRegionKey			INT,
		FunctionalDepartmentKey			INT,
		PropertyFundKey					INT,
		SourceName						VARCHAR(50),
		EntryDate						VARCHAR(10),
		[User]							NVARCHAR(20),
		[Description]					NVARCHAR(60),
		AdditionalDescription			NVARCHAR(4000),
		PropertyFundCode				VARCHAR(11) DEFAULT(''''), --VARCHAR, for this helps to keep reports size smaller
		OriginatingRegionCode			VARCHAR(30) DEFAULT(''''), --VARCHAR, for this helps to keep reports size smaller
		FunctionalDepartmentCode		VARCHAR(15) DEFAULT(''''),
		GlAccountCode					VARCHAR(15) DEFAULT(''''),
		GlAccountName					VARCHAR(300) DEFAULT(''''),
		CalendarPeriod					VARCHAR(6) DEFAULT(''''),

		--Month to date	
		MtdGrossActual					MONEY,
		MtdGrossBudget					MONEY,
		MtdGrossReforecast				MONEY,
		
		MtdNetActual					MONEY,
		MtdNetBudget					MONEY,
		MtdNetReforecast				MONEY,
		
		--Year to date
		YtdGrossActual					MONEY,	
		YtdGrossBudget					MONEY, 
		YtdGrossReforecast				MONEY,
		
		YtdNetActual					MONEY, 
		YtdNetBudget					MONEY, 
		YtdNetReforecast				MONEY, 

		--Annual	
		AnnualGrossBudget				MONEY,
		AnnualGrossReforecast			MONEY,
		AnnualNetBudget					MONEY,
		AnnualNetReforecast				MONEY,

		--Annual estimated
		AnnualEstGrossBudget			MONEY,
		AnnualEstGrossReforecast		MONEY,
		AnnualEstNetBudget				MONEY,
		AnnualEstNetReforecast			MONEY
	)
	
END
	
/* ==============================================================================================================================================
	STEP 7: Get Profitability Actual Data
		
		Budget Owner data is only ''Allocated'',''Not Applicable'', ''UNKNOWN''
		''Outflow'', ''UNKNOWN'' only, they only look at expenses, not income
		Exclude ''Architects & Engineering'', was re-classified, as per Martin''s request
   =========================================================================================================================================== */
BEGIN
	
	INSERT INTO #BudgetOriginatorEntity
	SELECT
		ProfitabilityActual.ActivityTypeKey,
		GlHierarchy.CategorizationHierarchyKey AS ''GLCategorizationHierarchyKey'',
		ProfitabilityActual.AllocationRegionKey,
		ProfitabilityActual.OriginatingRegionKey,
		ProfitabilityActual.FunctionalDepartmentKey,
		ProfitabilityActual.PropertyFundKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND
				GlobalGLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''
			ELSE
				[Source].SourceName
		END AS ''SourceName'',
		CONVERT(VARCHAR(10),ISNULL(ProfitabilityActual.LastDate,''''), 101) AS EntryDate,
		ProfitabilityActual.[User],
		ProfitabilityActual.[Description],
		ProfitabilityActual.AdditionalDescription,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND
				GlobalGLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''
			ELSE
				ProfitabilityActual.PropertyFundCode
		END AS ''PropertyFundCode'',
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND
				GlobalGLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''
			ELSE
				ProfitabilityActual.OriginatingRegionCode
		END AS ''OriginatingRegionCode'',
		ProfitabilityActual.FunctionalDepartmentCode,
		GlHierarchy.GlAccountCode,
		GlHierarchy.GlAccountName,
		Calendar.CalendarPeriod,

		SUM
		(
			#ExchangeRate.Rate *
			CASE
				WHEN
					Calendar.CalendarPeriod = @ReportExpensePeriodParameter
				THEN
					ProfitabilityActual.LocalActual
				ELSE
					0.0
			END
		) AS ''MtdGrossActual'',
		NULL AS ''MtdGrossBudget'',
		NULL AS ''MtdGrossReforecast'',
		
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE 
				WHEN
					Calendar.CalendarPeriod = @ReportExpensePeriodParameter
				THEN
					ProfitabilityActual.LocalActual
				ELSE
					0.0
			END
		) AS ''MtdNetActual'',
		NULL AS ''MtdNetBudget'',
		NULL AS ''MtdNetReforecast'',
		
		SUM
		(
			#ExchangeRate.Rate * 
			CASE 
				WHEN
					Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
				THEN
					ProfitabilityActual.LocalActual
				ELSE
					0.0
			END
		) AS ''YtdGrossActual'',
		NULL AS ''YtdGrossBudget'',
		NULL AS ''YtdGrossReforecast'',
		
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE
				WHEN
					Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
				THEN
					ProfitabilityActual.LocalActual
				ELSE
					0.0
			END
		) AS ''YtdNetActual'',
		NULL AS ''YtdNetBudget'',
		NULL AS ''YtdNetReforecast'',
		
		NULL AS ''AnnualGrossBudget'',
		NULL AS ''AnnualGrossReforecast'',
		
		NULL AS ''AnnualNetBudget'',
		NULL AS ''AnnualNetReforecast'',
		
		SUM
		(
			#ExchangeRate.Rate *
			CASE
				WHEN
					Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
				THEN
					ProfitabilityActual.LocalActual
				ELSE
					0.0
			END
		) AS ''AnnualEstGrossBudget'',
		NULL AS ''AnnualEstGrossReforecast'',
		
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE
				WHEN
					Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
				THEN
					ProfitabilityActual.LocalActual
				ELSE
					0.0
			END
		) AS ''AnnualEstNetBudget'',
		NULL AS ''AnnualEstNetReforecast''
	FROM 
		dbo.ProfitabilityActual 
	
		INNER JOIN #EntityFilterTable ON
			ProfitabilityActual.PropertyFundKey = #EntityFilterTable.PropertyFundKey
			
		INNER JOIN #OriginatingSubRegionFilterTable ON
			ProfitabilityActual.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey
			
		INNER JOIN #AllocationSubRegionFilterTable ON
			ProfitabilityActual.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey
			
		INNER JOIN #FunctionalDepartmentFilterTable ON
			ProfitabilityActual.FunctionalDepartmentKey = #FunctionalDepartmentFilterTable.FunctionalDepartmentKey
			
		INNER JOIN #ExchangeRate ON
			ProfitabilityActual.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
			ProfitabilityActual.CalendarKey = #ExchangeRate.CalendarKey
			
		INNER JOIN dbo.Currency ON
			#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey
			
		INNER JOIN dbo.Overhead ON
			ProfitabilityActual.Overheadkey = Overhead.OverheadKey
			
		INNER JOIN dbo.Calendar ON
			ProfitabilityActual.CalendarKey = Calendar.CalendarKey
		
		INNER JOIN dbo.[Source] ON
			ProfitabilityActual.SourceKey = [Source].SourceKey
		
		INNER JOIN dbo.Reimbursable ON
			ProfitabilityActual.ReimbursableKey = Reimbursable.ReimbursableKey

		INNER JOIN dbo.GLCategorizationHierarchy GlobalGLCategorizationHierarchy ON
			ProfitabilityActual.GlobalGLCategorizationHierarchyKey = GlobalGLCategorizationHierarchy.GLCategorizationHierarchyKey
						
		INNER JOIN #CategorizationHierarchyFilterTable GlHierarchy ON 
			GlHierarchy.CategorizationHierarchyKey = 
				CASE
					WHEN
						@GLCategorizationParameter = ''Global''
					THEN
						ProfitabilityActual.GlobalGLCategorizationHierarchyKey 
					ELSE
						ProfitabilityActual.ReportingGLCategorizationHierarchyKey
				END AND
			GlHierarchy.GLCategorizationName = @GLCategorizationParameter
	WHERE
		Overhead.OverheadCode IN
		(
			''UNALLOC'', -- Unallocated Overhead
			''UNKNOWN'', -- Unknown (overhead type could not be resolved when loading the warehouse)
			''N/A''      -- Not an overhead transaction
		) AND
		Calendar.CalendarYear = @CalendarYear AND
		Currency.CurrencyCode = @_DestinationCurrency AND
		GlobalGLCategorizationHierarchy.GLMinorCategoryName <> ''Bonus''
	GROUP BY
		ProfitabilityActual.ActivityTypeKey,
		GlHierarchy.CategorizationHierarchyKey,
		ProfitabilityActual.AllocationRegionKey,
		ProfitabilityActual.OriginatingRegionKey,
		ProfitabilityActual.FunctionalDepartmentKey,
		ProfitabilityActual.PropertyFundKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND
				GlobalGLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''	
			ELSE
				[Source].SourceName
		END,
		CONVERT(VARCHAR(10),ISNULL(ProfitabilityActual.LastDate,''''), 101),
		ProfitabilityActual.[User],
		ProfitabilityActual.[Description],
		ProfitabilityActual.AdditionalDescription,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND
				GlobalGLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''	
			ELSE
				ProfitabilityActual.PropertyFundCode
		END,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND
				GlobalGLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''	
			ELSE
				ProfitabilityActual.OriginatingRegionCode
		END,
		ProfitabilityActual.FunctionalDepartmentCode,
		GlHierarchy.GlAccountCode,
		GlHierarchy.GlAccountName,
		Calendar.CalendarPeriod		
		
END
	
/* =============================================================================================================================================
	STEP 8: Get Profitability Budget Data
		
		Budget Owner data is only ''Allocated'',''Not Applicable'', ''UNKNOWN''
		''Outflow'', ''UNKNOWN'' only, they only look at expenses, not income
		Exclude ''Architects & Engineering'', was re-classified, as per Martin''s request
   =========================================================================================================================================== */
BEGIN

	INSERT INTO #BudgetOriginatorEntity	
	SELECT
		ProfitabilityBudget.ActivityTypeKey,
		GlHierarchy.CategorizationHierarchyKey AS ''GLCategorizationHierarchyKey'',
		ProfitabilityBudget.AllocationRegionKey,
		ProfitabilityBudget.OriginatingRegionKey,
		ProfitabilityBudget.FunctionalDepartmentKey,
		ProfitabilityBudget.PropertyFundKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND
				GlobalGLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''
			ELSE
				[Source].SourceName
		END AS ''SourceName'',
		'''' AS ''EntryDate'',
		'''' AS ''User'',
		'''' AS ''Description'',
		'''' AS ''AdditionalDescription'',
		'''' AS ''PropertyFundCode'',
		'''' AS ''OriginatingRegionCode'',
		'''' AS ''FunctionalDepartmentCode'',
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND
				GlobalGLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				NULL
			ELSE
				GlHierarchy.GlAccountCode
		END AS ''GlAccountCode'',
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND
				GlobalGLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				NULL
			ELSE
				GlHierarchy.GlAccountName
		END AS ''GlAccountName'',	
		'''' AS ''CalendarPeriod'',	
		NULL AS ''MtdGrossActual'',
		SUM
		(
			#ExchangeRate.Rate *
			CASE
				WHEN
					Calendar.CalendarPeriod = @ReportExpensePeriodParameter
				THEN
					ProfitabilityBudget.LocalBudget
				ELSE
					0.0
			END
		) AS ''MtdGrossBudget'',
		NULL AS ''MtdGrossReforecast'',
		
		NULL AS ''MtdNetActual'',
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE
				WHEN
					Calendar.CalendarPeriod = @ReportExpensePeriodParameter
				THEN
					ProfitabilityBudget.LocalBudget
				ELSE
					0.0
			END
		) AS ''MtdNetBudget'',
		NULL AS ''MtdNetReforecast'',
		
		NULL AS ''YtdGrossActual'',
		SUM
		(
			#ExchangeRate.Rate *
			CASE
				WHEN
					Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
				THEN
					ProfitabilityBudget.LocalBudget
				ELSE
					0.0
			END
		) AS ''YtdGrossBudget'',	
		NULL AS ''YtdGrossReforecast'',
		
		NULL AS ''YtdNetActual'', 
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE
				WHEN
					Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
				THEN
					ProfitabilityBudget.LocalBudget
				ELSE
					0.0
			END
		) AS ''YtdNetBudget'',
		NULL AS ''YtdnetReforecast'',
		
		SUM
		(
			#ExchangeRate.Rate *
			ProfitabilityBudget.LocalBudget
		) AS ''AnnualGrossBudget'',
		NULL AS ''AnnualGrossReforecast'',
		
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			ProfitabilityBudget.LocalBudget
		) AS ''AnnualNetBudget'',
		NULL AS ''AnnualNetReforeCast'',
		
		SUM
		(
			#ExchangeRate.Rate *
			CASE
				WHEN
					Calendar.CalendarPeriod > @ReportExpensePeriodParameter
				THEN
					ProfitabilityBudget.LocalBudget
				ELSE
					0.0
			END
		) AS ''AnnualEstGrossBudget'',
		NULL AS ''AnnualEstGrossReforecast'',
		
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE 
				WHEN
					Calendar.CalendarPeriod > @ReportExpensePeriodParameter
				THEN
					ProfitabilityBudget.LocalBudget
				ELSE
					0.0
			END
		) AS ''AnnualEstNetBudget'',
		NULL AS ''AnnualEstNetReforecast''
		
	FROM 
		dbo.ProfitabilityBudget 
	
		INNER JOIN #EntityFilterTable ON
			ProfitabilityBudget.PropertyFundKey = #EntityFilterTable.PropertyFundKey
			
		INNER JOIN #OriginatingSubRegionFilterTable ON
			ProfitabilityBudget.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey
			
		INNER JOIN #AllocationSubRegionFilterTable ON
			ProfitabilityBudget.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey
			
		INNER JOIN #FunctionalDepartmentFilterTable ON
			ProfitabilityBudget.FunctionalDepartmentKey = #FunctionalDepartmentFilterTable.FunctionalDepartmentKey
			
		INNER JOIN #ExchangeRate ON
			ProfitabilityBudget.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
			ProfitabilityBudget.CalendarKey = #ExchangeRate.CalendarKey
			
		INNER JOIN dbo.Currency ON
			#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey
			
		INNER JOIN dbo.Overhead ON
			ProfitabilityBudget.Overheadkey = Overhead.OverheadKey
			
		INNER JOIN dbo.Calendar ON
			ProfitabilityBudget.CalendarKey = Calendar.CalendarKey
		
		INNER JOIN dbo.[Source] ON
			ProfitabilityBudget.SourceKey = [Source].SourceKey
		
		INNER JOIN dbo.Reimbursable ON
			ProfitabilityBudget.ReimbursableKey = Reimbursable.ReimbursableKey
		
		INNER JOIN dbo.GLCategorizationHierarchy GlobalGLCategorizationHierarchy ON
			ProfitabilityBudget.GlobalGLCategorizationHierarchyKey = GlobalGLCategorizationHierarchy.GLCategorizationHierarchyKey
						
		INNER JOIN #CategorizationHierarchyFilterTable GlHierarchy ON GlHierarchy.CategorizationHierarchyKey = 
			CASE
				WHEN @GLCategorizationParameter = ''Global'' THEN ProfitabilityBudget.GlobalGLCategorizationHierarchyKey 
				WHEN @GLCategorizationParameter = ''US Property'' THEN ProfitabilityBudget.USPropertyGLCategorizationHierarchyKey
				WHEN @GLCategorizationParameter = ''US Fund'' THEN ProfitabilityBudget.USFundGLCategorizationHierarchyKey 
				WHEN @GLCategorizationParameter = ''US Development'' THEN ProfitabilityBudget.USDevelopmentGLCategorizationHierarchyKey
				WHEN @GLCategorizationParameter = ''EU Property'' THEN ProfitabilityBudget.EUPropertyGLCategorizationHierarchyKey 
				WHEN @GLCategorizationParameter = ''EU Fund'' THEN ProfitabilityBudget.EUFundGLCategorizationHierarchyKey 
				WHEN @GLCategorizationParameter = ''EU Development'' THEN ProfitabilityBudget.EUDevelopmentGLCategorizationHierarchyKey
				ELSE NULL
			END
	WHERE
		Overhead.OverheadCode IN 
		(
			''UNALLOC'',
			''UNKNOWN'',
			''N/A''
		) AND
		Calendar.CalendarYear = @CalendarYear AND
		Currency.CurrencyCode = @_DestinationCurrency AND
		GlobalGLCategorizationHierarchy.GLMinorCategoryName <> ''Bonus''
	GROUP BY
		ProfitabilityBudget.ActivityTypeKey,
		GlHierarchy.CategorizationHierarchyKey,
		ProfitabilityBudget.AllocationRegionKey,
		ProfitabilityBudget.OriginatingRegionKey,
		ProfitabilityBudget.FunctionalDepartmentKey,
		ProfitabilityBudget.PropertyFundKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND
				GlobalGLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''	
			ELSE
				[Source].SourceName
		END,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND
				GlobalGLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				NULL
			ELSE
				GlHierarchy.GlAccountCode
		END,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND
				GlobalGLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				NULL
			ELSE
				GlHierarchy.GlAccountName
		END	
		
END

/* =============================================================================================================================================
	STEP 9: Get Profitability Reforecast Data 
		
		There are only reforecast transactions for Q1, Q2, Q3
				
		Budget Owner data is only ''Allocated'', ''UNKNOWN''
		''Outflow'', ''UNKNOWN'' only, they only look at expenses, not income
		Exclude ''Architects & Engineering'', was re-classified, as per Martin''s request
   =========================================================================================================================================== */
BEGIN

	IF @_ReforecastQuarterName IN (''Q1'', ''Q2'', ''Q3'')
	BEGIN
	
		INSERT INTO #BudgetOriginatorEntity
		SELECT
			ProfitabilityReforecast.ActivityTypeKey,
			GlHierarchy.CategorizationHierarchyKey AS ''GLCategorizationHierarchyKey'',
			ProfitabilityReforecast.AllocationRegionKey,
			ProfitabilityReforecast.OriginatingRegionKey,
			ProfitabilityReforecast.FunctionalDepartmentKey,
			ProfitabilityReforecast.PropertyFundKey,
			CASE
				WHEN
					@_DontSensitizeMRIPayrollData = 0 AND
					GlobalGLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
				THEN
					''Sensitized''	
				ELSE
					[Source].SourceName
			END AS ''SourceName'',
			'''' AS ''EntryDate'',
			'''',
			'''',
			'''',
			'''' AS ''PropertyFundCode'',
			'''' AS ''OriginatingRegionCode'',
			'''' AS ''FunctionalDepartmentCode'',
			CASE
				WHEN
					@_DontSensitizeMRIPayrollData = 0 AND
					GlobalGLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
				THEN
					NULL	
				ELSE
					GlHierarchy.GlAccountCode
			END AS ''GLAccountCode'',
			CASE
				WHEN
					@_DontSensitizeMRIPayrollData = 0 AND
					GlobalGLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
				THEN
					NULL	
				ELSE
					GlHierarchy.GlAccountName
			END AS ''GlAccountName'',
			'''' AS ''CalendarPeriod'',
			
			NULL AS ''MtdGrossActual'',
			NULL AS ''MtdGrossBudget'',
		
			SUM
			(
				#ExchangeRate.Rate *
				CASE 
					WHEN
						Calendar.CalendarPeriod = @ReportExpensePeriodParameter
					THEN
						ProfitabilityReforecast.LocalReforecast
				ELSE
					0.0
				END
			) AS ''MtdGrossReforecast'',

			NULL AS ''MtdNetActual'',
			NULL AS ''MtdNetBudget'',
		
			SUM
			(
				#ExchangeRate.Rate *
				Reimbursable.MultiplicationFactor * 
				CASE 
					WHEN
						Calendar.CalendarPeriod = @ReportExpensePeriodParameter
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0.0
				END
			) AS ''MtdNetReforecast'',

			NULL AS ''YtdGrossActual'',
			NULL AS ''YtdGrossBudget'',
		
			SUM
			(
				#ExchangeRate.Rate * 
				CASE 
					WHEN
						Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0.0
				END
			) AS ''YtdGrossReforecast'',

			NULL AS ''YtdNetActual'',
			NULL AS ''YtdNetBudget'',

			SUM
			(
				#ExchangeRate.Rate *Reimbursable.MultiplicationFactor * 
				CASE 
					WHEN
						Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0.0
				END
			) AS ''YtdNetReforecast'',

			NULL AS ''AnnualGrossBudget'', 
			SUM
			(
				#ExchangeRate.Rate *
				ProfitabilityReforecast.LocalReforecast
			) AS ''AnnualGrossReforecast'',

			NULL AS ''AnnualNetBudget'',
			SUM
			(
				#ExchangeRate.Rate *
				Reimbursable.MultiplicationFactor *
				ProfitabilityReforecast.LocalReforecast
			) AS ''AnnualNetReforecast'',

			NULL AS ''AnnualEstGrossBudget'',
			SUM
			(
				#ExchangeRate.Rate *
				CASE
					WHEN
					(
						Calendar.CalendarPeriod > @ReportExpensePeriodParameter OR 
						(
							LEFT (ProfitabilityReforecast.ReferenceCode, 3) = ''BC:'' AND
							STR(@ReforecastEffectivePeriod,6,0) IN (201003, 
																	201006, 
																	201009)
						)
					)
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0.0
				END
			) AS ''AnnualEstGrossReforecast'',

			NULL AS ''AnnualEstNetBudget'',
			SUM
			(
				#ExchangeRate.Rate *
				CASE
					WHEN
					(
						Calendar.CalendarPeriod > @ReportExpensePeriodParameter OR 
						(
							LEFT (ProfitabilityReforecast.ReferenceCode, 3) = ''BC:'' AND
							STR(@ReforecastEffectivePeriod,6,0) IN (201003,
																	201006,
																	201009)
						)
					)
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0.0
				END 
			) AS ''AnnualEstNetReforecast''
			FROM 
				dbo.ProfitabilityReforecast 
			
				INNER JOIN #EntityFilterTable ON
					ProfitabilityReforecast.PropertyFundKey = #EntityFilterTable.PropertyFundKey
					
				INNER JOIN #OriginatingSubRegionFilterTable ON
					ProfitabilityReforecast.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey
					
				INNER JOIN #AllocationSubRegionFilterTable ON
					ProfitabilityReforecast.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey
					
				INNER JOIN #FunctionalDepartmentFilterTable ON
					ProfitabilityReforecast.FunctionalDepartmentKey = #FunctionalDepartmentFilterTable.FunctionalDepartmentKey
				
				INNER JOIN #ExchangeRate ON
					ProfitabilityReforecast.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
					ProfitabilityReforecast.CalendarKey = #ExchangeRate.CalendarKey
					
				INNER JOIN dbo.Currency ON
					#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey
					
				INNER JOIN dbo.Overhead ON
					ProfitabilityReforecast.Overheadkey = Overhead.OverheadKey
					
				INNER JOIN dbo.Calendar ON
					ProfitabilityReforecast.CalendarKey = Calendar.CalendarKey
				
				INNER JOIN dbo.[Source] ON
					ProfitabilityReforecast.SourceKey = [Source].SourceKey
				
				INNER JOIN dbo.Reimbursable ON
					ProfitabilityReforecast.ReimbursableKey = Reimbursable.ReimbursableKey
					
				INNER JOIN dbo.Reforecast ON
					ProfitabilityReforecast.ReforecastKey = Reforecast.ReforecastKey
			
				INNER JOIN dbo.GLCategorizationHierarchy GlobalGLCategorizationHierarchy ON
					ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey = GlobalGLCategorizationHierarchy.GLCategorizationHierarchyKey
								
				INNER JOIN #CategorizationHierarchyFilterTable GlHierarchy ON GlHierarchy.CategorizationHierarchyKey = 
					CASE
						WHEN @GLCategorizationParameter = ''Global'' THEN ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey 
						WHEN @GLCategorizationParameter = ''US Property'' THEN ProfitabilityReforecast.USPropertyGLCategorizationHierarchyKey
						WHEN @GLCategorizationParameter = ''US Fund'' THEN ProfitabilityReforecast.USFundGLCategorizationHierarchyKey 
						WHEN @GLCategorizationParameter = ''US Development'' THEN ProfitabilityReforecast.USDevelopmentGLCategorizationHierarchyKey
						WHEN @GLCategorizationParameter = ''EU Property'' THEN ProfitabilityReforecast.EUPropertyGLCategorizationHierarchyKey 
						WHEN @GLCategorizationParameter = ''EU Fund'' THEN ProfitabilityReforecast.EUFundGLCategorizationHierarchyKey 
						WHEN @GLCategorizationParameter = ''EU Development'' THEN ProfitabilityReforecast.EUDevelopmentGLCategorizationHierarchyKey
						ELSE NULL
					END	
			WHERE
				Overhead.OverheadCode IN 
				(
					''UNALLOC'',
					''UNKNOWN'',
					''N/A''
				) AND
				Reforecast.ReforecastEffectivePeriod = @ReforecastEffectivePeriod AND
				Calendar.CalendarYear = @CalendarYear AND
				Currency.CurrencyCode = @_DestinationCurrency AND
				GlobalGLCategorizationHierarchy.GLMinorCategoryName <> ''Bonus''
			GROUP BY
				ProfitabilityReforecast.ActivityTypeKey,
				GlHierarchy.CategorizationHierarchyKey,
				ProfitabilityReforecast.AllocationRegionKey,
				ProfitabilityReforecast.OriginatingRegionKey,
				ProfitabilityReforecast.FunctionalDepartmentKey,
				ProfitabilityReforecast.PropertyFundKey,
				CASE
					WHEN
						@_DontSensitizeMRIPayrollData = 0 AND
						GlobalGLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
					THEN
						''Sensitized''	
					ELSE
						[Source].SourceName
				END,
				CASE
					WHEN
						@_DontSensitizeMRIPayrollData = 0 AND
						GlobalGLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
					THEN
						NULL	
					ELSE
						GlHierarchy.GlAccountCode
				END,
				CASE
					WHEN
						@_DontSensitizeMRIPayrollData = 0 AND
						GlobalGLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
					THEN
						NULL
					ELSE
						GlHierarchy.GlAccountName
				END

	END

END
		
/* =============================================================================================================================================
	STEP 10: Get Total Summary Per cost point

		We are now combining the results for actuals, budgets and reforecasts, thus creating total amounts per:

		ActivityType,

		Global Categorization GLFinancialCategory,
		Global Categorization GLMajorCategory,
		Global Categorization GLMinorCategory,

		Default Reporting Categorization GLFinancialCategory,
		Default Reporting Categorization GLMajorCategory,
		Default Reporting Categorization GLMinorCategory,

		AllocationRegion,
		OriginatingRegion,
		FunctionalDepartmentName,
		PropertyFund,
		CalendarPeriod,
		EntryDate,
		[User],
		[Description],
		AdditionalDescription,
		SourceName,
		GLAccountCode,
		GLAccountName,
		LocalNonLocal,
		DirectIndirect
    ========================================================================================================================================== */
BEGIN

	SELECT
		ActivityType.ActivityTypeName,
		ActivityType.ActivityTypeName AS ''ActivityTypeFilterName'',
		CategorizationHierarchyInWarehouse.LatestGLFinancialCategoryName AS ''GLFinancialCategory'',
		CategorizationHierarchyInWarehouse.LatestGLMajorCategoryName AS ''GLMajorExpenseCategoryName'',
		CategorizationHierarchyInWarehouse.LatestGLMinorCategoryName AS ''GLMinorExpenseCategoryName'',
		AllocationRegion.AllocationRegionName AS ''AllocationRegionName'',
		AllocationRegion.AllocationSubRegionName AS ''AllocationSubRegionName'',
		AllocationRegion.AllocationSubRegionName AS ''AllocationSubRegionFilterName'',
		OriginatingRegion.OriginatingRegionName AS ''OriginatingRegionName'',
		OriginatingRegion.OriginatingSubRegionName AS ''OriginatingSubRegionName'',
		OriginatingRegion.OriginatingSubRegionName AS ''OriginatingSubRegionFilterName'',
		PropertyFund.PropertyFundType AS ''PropertyFundType'',
		PropertyFund.PropertyFundName AS ''PropertyFundName'',
		FunctionalDepartment.FunctionalDepartmentName AS ''FunctionalDepartmentName'',
		#BudgetOriginatorEntity.CalendarPeriod AS ''ActualsExpensePeriod'',
		#BudgetOriginatorEntity.EntryDate AS ''EntryDate'',
		#BudgetOriginatorEntity.[User] AS ''User'',
		#BudgetOriginatorEntity.[Description] AS ''Description'',
		#BudgetOriginatorEntity.AdditionalDescription AS ''AdditionalDescription'',
		#BudgetOriginatorEntity.SourceName AS ''SourceName'',
		#BudgetOriginatorEntity.PropertyFundCode AS ''PropertyFundCode'',
		CASE 
			WHEN
				SUBSTRING(#BudgetOriginatorEntity.SourceName, CHARINDEX('' '', #BudgetOriginatorEntity.SourceName) +1, 8) = ''Property''
			THEN
				RTRIM(#BudgetOriginatorEntity.OriginatingRegionCode) + LTRIM(#BudgetOriginatorEntity.FunctionalDepartmentCode) 
			ELSE
				#BudgetOriginatorEntity.OriginatingRegionCode 
		END AS ''OriginatingRegionCode'',
		ISNULL (#BudgetOriginatorEntity.GlAccountCode, '''') AS ''GlAccountCode'',
		ISNULL (#BudgetOriginatorEntity.GlAccountName, '''') AS ''GlAccountName'',
		
		--Month to date    
		SUM
		(
			CASE 
				WHEN
					(@_CalculationMethod = ''Gross'')
				THEN
					ISNULL(MtdGrossActual, 0) 
				ELSE
					ISNULL(MtdNetActual, 0) 
			END
		) AS ''MtdActual'',
		SUM
		(
			CASE 
				WHEN
					@_CalculationMethod = ''Gross''
				THEN
					ISNULL(MtdGrossBudget, 0) 
				ELSE
					ISNULL(MtdNetBudget, 0) 
			END
		) AS ''MtdOriginalBudget'',

		SUM
		(
			CASE 
				WHEN
					@_CalculationMethod = ''Gross''
				THEN
					ISNULL
					(
						CASE 
							WHEN
								@_ReforecastQuarterName = ''Q0''
							THEN
								MtdGrossBudget 
							ELSE
								MtdGrossReforecast
						END,
						0
					) 
				ELSE
					ISNULL
					(
						CASE 
							WHEN
								@_ReforecastQuarterName = ''Q0''
							THEN
								MtdNetBudget 
							ELSE
								MtdNetReforecast
						END,
						0
					) 
				END
			) 
		AS ''MtdReforecast'',
		
		SUM
		(
			CASE 
				WHEN
					@_CalculationMethod = ''Gross''
				THEN
					ISNULL
					(
						CASE 
							WHEN
								@_ReforecastQuarterName = ''Q0''
							THEN
								MtdGrossBudget 
							ELSE
								MtdGrossReforecast
						END, 
						0
					) - ISNULL(MtdGrossActual, 0) 
				ELSE
					ISNULL
					(
						CASE 
							WHEN
								@_ReforecastQuarterName = ''Q0''
							THEN
								MtdNetBudget 
							ELSE
								MtdNetReforecast 
						END,
						0
					) - ISNULL(MtdNetActual, 0) 
				END
		) AS ''MtdVariance'',
		
		--Year to date
		SUM
		(
			CASE 
				WHEN
					@_CalculationMethod = ''Gross''
				THEN
					ISNULL(YtdGrossActual, 0) 
				ELSE
					ISNULL(YtdNetActual, 0) 
			END
		) AS ''YtdActual'',	
		
		SUM
		(
			CASE 
				WHEN
					@_CalculationMethod = ''Gross''
				THEN
					ISNULL(YtdGrossBudget, 0) 
				ELSE
					ISNULL(YtdNetBudget, 0) 
			END
		) AS ''YtdOriginalBudget'',
		
		SUM
		(
			CASE 
				WHEN
					@_CalculationMethod = ''Gross''
				THEN
					ISNULL
					(
						CASE 
							WHEN
								@_ReforecastQuarterName = ''Q0''
							THEN
								YtdGrossBudget 
							ELSE
								YtdGrossReforecast
						END,
						0
					)
				ELSE
					ISNULL
					(
						CASE 
							WHEN
								@_ReforecastQuarterName = ''Q0''
							THEN
								YtdNetBudget 
							ELSE
								YtdNetReforecast
						END,
						0
					)
			END
		) AS ''YtdReforecast'',
		
		SUM
		(
			CASE 
				WHEN
					@_CalculationMethod = ''Gross''
				THEN
					ISNULL
					(
						CASE 
							WHEN
								@_ReforecastQuarterName = ''Q0''
							THEN
								YtdGrossBudget 
							ELSE
								YtdGrossReforecast
						END,
						0
					) - ISNULL(YtdGrossActual, 0) 
				ELSE
					ISNULL
					(
						CASE
							WHEN
								@_ReforecastQuarterName = ''Q0''
							THEN
								YtdNetBudget
							ELSE
								YtdNetReforecast
						END,
						0
					) - ISNULL(YtdNetActual, 0)
			END
		) AS ''YtdVariance'',
			
		--Annual
		SUM
		(
			CASE
				WHEN
					@_CalculationMethod = ''Gross''
				THEN
					ISNULL(AnnualGrossBudget,0)
				ELSE
					ISNULL(AnnualNetBudget,0)
			END
		) AS ''AnnualOriginalBudget'',
		
		SUM
		(
			CASE
				WHEN
					@_CalculationMethod = ''Gross''
				THEN
					ISNULL
					(
						CASE
							WHEN
								@_ReforecastQuarterName = ''Q0''
							THEN
								0
							ELSE
								AnnualGrossReforecast
						END,
						0
					)
				ELSE
					ISNULL
					(
					CASE 
						WHEN @_ReforecastQuarterName = ''Q0'' THEN 0 
						ELSE AnnualNetReforecast
					END,
					0
				) 
			END
		) AS ''AnnualReforecast'',
		ISNULL(#DirectIndirectMapping.DirectIndirect, ''-'') AS ''DirectIndirect''
	INTO
		#Output
	FROM
		#BudgetOriginatorEntity
		
		INNER JOIN #AllocationSubRegionFilterTable AllocationRegion ON 
			#BudgetOriginatorEntity.AllocationRegionKey = AllocationRegion.AllocationRegionKey
			
		INNER JOIN #OriginatingSubRegionFilterTable OriginatingRegion ON 
			#BudgetOriginatorEntity.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey
			
		INNER JOIN #FunctionalDepartmentFilterTable FunctionalDepartment ON 
			#BudgetOriginatorEntity.FunctionalDepartmentKey = FunctionalDepartment.FunctionalDepartmentKey
			
		INNER JOIN dbo.GLCategorizationHierarchyLatestState CategorizationHierarchyInWarehouse ON
			#BudgetOriginatorEntity.GLCategorizationHierarchyKey = CategorizationHierarchyInWarehouse.GLCategorizationHierarchyKey
						
		INNER JOIN #EntityFilterTable PropertyFund ON 
			#BudgetOriginatorEntity.PropertyFundKey = PropertyFund.PropertyFundKey
			
		INNER JOIN dbo.ActivityType ON 
			#BudgetOriginatorEntity.ActivityTypeKey = ActivityType.ActivityTypeKey
		
		LEFT OUTER JOIN #DirectIndirectMapping ON
			#BudgetOriginatorEntity.SourceName = #DirectIndirectMapping.SourceName
	GROUP BY
		ActivityType.ActivityTypeName,
		ActivityType.ActivityTypeName,
		CategorizationHierarchyInWarehouse.LatestGLFinancialCategoryName,
		CategorizationHierarchyInWarehouse.LatestGLMajorCategoryName,
		CategorizationHierarchyInWarehouse.LatestGLMinorCategoryName,
		AllocationRegion.AllocationRegionName,
		AllocationRegion.AllocationSubRegionName,
		AllocationRegion.AllocationSubRegionName,
		OriginatingRegion.OriginatingRegionName,
		OriginatingRegion.OriginatingSubRegionName,
		OriginatingRegion.OriginatingSubRegionName,
		PropertyFund.PropertyFundType,
		PropertyFund.PropertyFundName,
		FunctionalDepartment.FunctionalDepartmentName,
		#BudgetOriginatorEntity.CalendarPeriod,
		#BudgetOriginatorEntity.EntryDate,
		#BudgetOriginatorEntity.[User],
		#BudgetOriginatorEntity.Description,
		#BudgetOriginatorEntity.AdditionalDescription,
		#BudgetOriginatorEntity.SourceName,
		#BudgetOriginatorEntity.PropertyFundCode,
		CASE 
			WHEN
				SUBSTRING(#BudgetOriginatorEntity.SourceName, CHARINDEX('' '', #BudgetOriginatorEntity.SourceName) +1, 8) = ''Property''
			THEN
				RTRIM(#BudgetOriginatorEntity.OriginatingRegionCode) + LTRIM(#BudgetOriginatorEntity.FunctionalDepartmentCode) 
			ELSE
				#BudgetOriginatorEntity.OriginatingRegionCode 
		END,
		ISNULL (#BudgetOriginatorEntity.GlAccountCode, ''''),
		ISNULL (#BudgetOriginatorEntity.GlAccountName, ''''),
		ISNULL(#DirectIndirectMapping.DirectIndirect, ''-'')

END
		
/* =============================================================================================================================================
	STEP 11: Get Final Results
   ========================================================================================================================================== */
BEGIN

	SELECT
		ActivityTypeName,
		ActivityTypeFilterName,
		GLFinancialCategory,
		GLMajorExpenseCategoryName,
		GLMinorExpenseCategoryName,
		AllocationRegionName,
		AllocationSubRegionName,
		AllocationSubRegionFilterName,
		OriginatingRegionName,
		OriginatingSubRegionName,
		OriginatingSubRegionFilterName,
		PropertyFundType AS ''EntityType'',
		PropertyFundName AS ''EntityName'',
		FunctionalDepartmentName,
		ActualsExpensePeriod,
		EntryDate,
		[User] AS ''User'',
		CASE 
			WHEN
			(
				AnnualOriginalBudget <> 0 OR 
				AnnualReforecast <> 0
			) AND  
			(
				MtdActual = 0 OR 
				YtdActual = 0
			)
			THEN
				''[BUDGET/REFORECAST]'' 
			ELSE
				[Description]
		END AS ''Description'',
		AdditionalDescription,
		SourceName,
		PropertyFundCode,
		OriginatingRegionCode,
		GlAccountCode,
		GlAccountName,
		--Month to date    
		MtdActual,
		MtdOriginalBudget,
		MtdReforecast,
		MtdVariance,
		
		--Year to date
		YtdActual,
		YtdOriginalBudget,
		YtdReforecast,
		YtdVariance,

		--Annual
		AnnualOriginalBudget,
		AnnualReforecast,
		DirectIndirect AS ''DirectIndirect''
	FROM 
		#Output
	WHERE
		--Month to date    
		MtdActual <> 0.00 OR
		MtdOriginalBudget <> 0.00 OR
		MtdReforecast <> 0.00 OR
		MtdVariance <> 0.00 OR
		
		YtdActual <> 0.00 OR
		YtdOriginalBudget <> 0.00 OR
		YtdReforecast <> 0.00 OR
		YtdVariance <> 0.00 OR

		AnnualOriginalBudget <> 0.00 OR
		AnnualReforecast <> 0.00 

END
	
/* =============================================================================================================================================
	CLEAN UP TEMP TABLES
   =========================================================================================================================================== */
BEGIN

	IF OBJECT_ID(''tempdb..#EntityFilterTable'') IS NOT NULL
		DROP TABLE #EntityFilterTable

	IF OBJECT_ID(''tempdb..#ExchangeRate'') IS NOT NULL
		DROP TABLE #ExchangeRate
		
	IF OBJECT_ID(''tempdb..#OriginatingSubRegionFilterTable'') IS NOT NULL
		DROP TABLE #OriginatingSubRegionFilterTable

	IF OBJECT_ID(''tempdb..#AllocationSubRegionFilterTable'') IS NOT NULL
		DROP TABLE #AllocationSubRegionFilterTable

	IF OBJECT_ID(''tempdb..#CategorizationHierarchyFilterTable'') IS NOT NULL
		DROP TABLE #CategorizationHierarchyFilterTable

	IF 	OBJECT_ID(''tempdb..#BudgetOriginatorEntity'') IS NOT NULL
		DROP TABLE #BudgetOriginatorEntity
		
	IF  OBJECT_ID(''tempdb..#DirectIndirectMapping'') IS NOT NULL
		DROP TABLE #DirectIndirectMapping

	IF  OBJECT_ID(''tempdb..#Output'') IS NOT NULL
		DROP TABLE #Output

END

END

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_R_BudgetJobCodeDetail]    Script Date: 03/08/2012 12:51:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetJobCodeDetail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[stp_R_BudgetJobCodeDetail]
	@ReportExpensePeriod INT,
	@ReforecastQuarterName CHAR(2), --''Q0'' or ''Q1'' or ''Q2'' or ''Q3''
	@DestinationCurrency VARCHAR(3),
	@EntityList VARCHAR(MAX),
	@DontSensitizeMRIPayrollData BIT,
	@CalculationMethod VARCHAR(50),
	@GLCategorization VARCHAR(50),
	@FunctionalDepartmentList VARCHAR(MAX),	
	@AllocationSubRegionList VARCHAR(MAX),	
	@OriginatingSubRegionList VARCHAR(MAX) 
AS

/*********************************************************************************************************************
Description
	The stored procedure is used for generating the data for the Budget Originator Job Code Details Report.
	
	Gross Mode: Includes all transactions
	Net Mode: Include only reimbursable costs
	
	MRI Source Sensitization: We need to sensitize source data that we group on for payroll transactions. For
	regions where there is one or two employees, the employee salary can be deduced from a payroll amount for that
	region. we therefore need to sensitize various fields like minor/major category, mri source and originating region. 
	This is controlled by the @DontSensitizeMRIPayrollData parameter.
	
	STEPS:
	
	STEP 1: Declare local variables - use this to easily set up test script
	STEP 2: Set up the Report Filter Variable defaults
	STEP 3: Set up the Report Filter Tables - We create temp tables containing the records of each parameter dimention
											  We can easily filter our data by inner joining onto these tables
	STEP 4: Create results temp table
	STEP 5: Get Profitability Actual Data - NOTE: we group the transactions here to get a total amount for each type of transaction
	STEP 6: Get Profitability Budget Data
	STEP 7: Get Profitability Reforecast Data
	STEP 8: Get Total Summary Per cost point
	STEP 9: Get Final Results

History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-07-08		: PKayongo	:	Sensitized payroll data for the MRI Source, Originating Region Code and 
											Property Fund fields. (CC20)
			2011-07-11		: PKayongo	:	Allowed reforecast values to be dynamically selected from the 
											@ReforecastQuarterName variable. Only 1 reforecast dynamic query remained
											and only the different reforecast fields at the end (i.e. Q1, Q2, Q3)
											were consolidated into 1.
			2011-08-08		: PKayongo	:	Annual Reforecast = 0 when ReforecastQuarterName = "Q0"
			2011-08-08		: SNothling	:	Set sensitized strings to ''Sensitized'' instead of ''''
**********************************************************************************************************************/

BEGIN

/* ===============================================================================================================================================
	STEP 1: Declare local variables - this makes debugging and testing easier	
	
	NOTE: We do not specify parameter defaults. We assume that all parameters have been saved correctly and completely in GRP, and we want the
		stored procedure to break if an expected parameter is not passed through. This prevents unexpected behaviour.
   ============================================================================================================================================= */

BEGIN

DECLARE
	@_ReportExpensePeriod INT = @ReportExpensePeriod,
	@_ReforecastQuarterName VARCHAR(10) = @ReforecastQuarterName,
	@_DestinationCurrency VARCHAR(3) = @DestinationCurrency,
	@_EntityList VARCHAR(MAX) = @EntityList,
	@_DontSensitizeMRIPayrollData BIT = @DontSensitizeMRIPayrollData,
	@_CalculationMethod VARCHAR(MAX) = @CalculationMethod,
	@_GLCategorization VARCHAR(50) = @GLCategorization,
	@_FunctionalDepartmentList VARCHAR (MAX) = @FunctionalDepartmentList,
	@_OriginatingSubRegionList VARCHAR(MAX) = @OriginatingSubRegionList,
	@_AllocationSubRegionList  VARCHAR(MAX) = @AllocationSubRegionList
	
END
		
/* ===============================================================================================================================================
	STEP 2: Set up the Report Filter Variable defaults		
	
		1. The report expense period defaults to the current report expense period
		2. The report expense period parameter is a pre-formatted string used in the select statements of the results
		3. The default destination currency is USD
		4. The calendar year defaults to the year of the expense period
		5. The reforecast quarter name defaults to the latest reforecast quarter name in the database
		   for the given period
		6. If there is no active reforecast for that period - reforecast name combination, get the latest active
		   reforecast
		7. Get the exchange rate set of the selected active reforecast
   ============================================================================================================================================= */

BEGIN

	-- Calculate default report expense period if none specified
	IF @_ReportExpensePeriod IS NULL
		SET @_ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + REPLACE(STR(MONTH(GETDATE()),2 ),'' '',''0'')AS INT)

	-- Pre-format Report Expense period string
	DECLARE @ReportExpensePeriodParameter VARCHAR(6) = STR(@_ReportExpensePeriod, 6, 0)

	-- Calculate destination currency if none specified
	IF @_DestinationCurrency IS NULL
		SET @_DestinationCurrency = ''USD''

	-- Calculate default calendar year if none specified
	DECLARE @CalendarYear AS VARCHAR(10) = SUBSTRING(CAST(@_ReportExpensePeriod AS VARCHAR(10)), 1, 4)

	-- Calculate default reforecast quarter name if not specified
	IF @_ReforecastQuarterName IS NULL OR @_ReforecastQuarterName NOT IN (''Q0'', ''Q1'', ''Q2'', ''Q3'')
		SET @_ReforecastQuarterName = (
			SELECT TOP 1
				ReforecastQuarterName 
			FROM 
				dbo.Reforecast 
			WHERE
				ReforecastEffectivePeriod <= @_ReportExpensePeriod AND 
				ReforecastEffectiveYear = LEFT(CAST(@_ReportExpensePeriod AS VARCHAR(6)),4)
			ORDER BY 
				ReforecastEffectivePeriod DESC )

	---- Calculate reforecast effective period from reforecast name
	DECLARE @ReforecastEffectivePeriod INT = (
			SELECT TOP 1
				ReforecastEffectivePeriod
			FROM 
				dbo.Reforecast
			WHERE
				ReforecastEffectiveYear = LEFT(CAST(@_ReportExpensePeriod AS VARCHAR(6)),4) AND
				ReforecastQuarterName = @_ReforecastQuarterName
			ORDER BY
				ReforecastEffectivePeriod )
			
	-- Determine the ReforecastKey of the reforecast that is currently active (i.e.: 2011 Q1, 2011 Q2, 2012 Q0 etc)
	DECLARE @ActiveReforecastKey INT = (
			SELECT
				ReforecastKey
			FROM 
				dbo.GetReforecastRecord(@_ReportExpensePeriod, @_ReforecastQuarterName) )

	-- Safeguard against NULL ReforecastKey returned from previous statement
	IF (@ActiveReforecastKey IS NULL) 
	BEGIN
		SET @ActiveReforecastKey = (SELECT 
										MAX(ReforecastKey) 
									FROM 
										dbo.ExchangeRate )
		PRINT (''Near disaster: @ActiveReforecastKey is NULL, so reverting to the largest/most recent ReforecastKey in dbo.ExchangeRate: '' + CONVERT(VARCHAR(10), @ActiveReforecastKey))
	END 

	-- Determine Report Exchange Rates	
	-- get the exchange rate set for the specified reforecast

	SELECT
		SourceCurrencyKey,
		DestinationCurrencyKey,
		CalendarKey,
		Rate
	INTO
		#ExchangeRate
	FROM
		dbo.ExchangeRate
	WHERE
		ReforecastKey = @ActiveReforecastKey -- We will use the exchange rate set that is active for the current reforecast.

END

/* ===============================================================================================================================================
	STEP 3: Set up the Report Filter Tables
	
		1. Reporting Entities - Get a table containing all the reporting entities specified in the filter parameter
		2. Originating Sub Regions - Get a table containing all the originating sub regions specified in the filter parameter
		3. Allocation Sub Regions - Get a table containing all the allocation sub regions specified in the filter parameter
   ============================================================================================================================================= */
BEGIN 

	----------------------------------------------------------------------------
	-- Reporting Entities
	----------------------------------------------------------------------------

		CREATE TABLE #EntityFilterTable	
		(
			PropertyFundKey INT NOT NULL,
			PropertyFundName VARCHAR(MAX) NOT NULL,
			PropertyFundType VARCHAR(MAX) NOT NULL
		)

		IF (@_EntityList IS NOT NULL)
		BEGIN

			IF (@_EntityList <> ''All'')
			BEGIN

				INSERT INTO #EntityFilterTable
				SELECT DISTINCT 
					PropertyFundLatestState.PropertyFundKey,
					PropertyFundLatestState.LatestPropertyFundName,
					PropertyFundLatestState.LatestPropertyFundType
				FROM 
					dbo.Split(@_EntityList) EntityListParameters
					INNER JOIN dbo.PropertyFund ON 
						PropertyFund.PropertyFundName = EntityListParameters.item
					INNER JOIN PropertyFundLatestState ON
						PropertyFund.PropertyFundId = PropertyFundLatestState.PropertyFundId AND
						PropertyFund.SnapshotId = PropertyFundLatestState.PropertyFundSnapshotId
			END
			ELSE IF (@_EntityList = ''All'')
			BEGIN

				INSERT INTO #EntityFilterTable
				SELECT DISTINCT
					PropertyFundLatestState.PropertyFundKey,
					PropertyFundLatestState.LatestPropertyFundName AS PropertyFundName,
					PropertyFundLatestState.LatestPropertyFundType AS PropertyFundType
				FROM 
					dbo.PropertyFundLatestState

			END

		END

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable (PropertyFundKey)

	----------------------------------------------------------------------------	
	-- Originating Sub Regions
	----------------------------------------------------------------------------

	CREATE TABLE #OriginatingSubRegionFilterTable 
	(
		OriginatingRegionKey INT NOT NULL,
		OriginatingRegionName VARCHAR(MAX) NOT NULL,
		OriginatingSubRegionName VARCHAR(MAX) NOT NULL
	)

	IF (@_OriginatingSubRegionList IS NOT NULL)
	BEGIN

		IF (@_OriginatingSubRegionList <> ''All'')

		BEGIN
		
			INSERT INTO #OriginatingSubRegionFilterTable
			SELECT DISTINCT
				OriginatingRegionLatestState.OriginatingRegionKey,
				OriginatingRegionLatestState.LatestOriginatingRegionName,
				OriginatingRegionLatestState.LatestOriginatingSubRegionName
			FROM 
				dbo.Split(@_OriginatingSubRegionList) OriginatingSubRegionParameters
				INNER JOIN dbo.OriginatingRegion ON 
					OriginatingRegion.SubRegionName = OriginatingSubRegionParameters.item
				INNER JOIN dbo.OriginatingRegionLatestState ON
					OriginatingRegion.GlobalRegionId = OriginatingRegionLatestState.OriginatingRegionGlobalRegionId AND
					OriginatingRegion.SnapshotId = OriginatingRegionLatestState.OriginatingRegionSnapshotId
		END

		ELSE IF (@_OriginatingSubRegionList = ''All'')
		BEGIN

			INSERT INTO #OriginatingSubRegionFilterTable
			SELECT 
				OriginatingRegionLatestState.OriginatingRegionKey,
				OriginatingRegionLatestState.LatestOriginatingRegionName,
				OriginatingRegionLatestState.LatestOriginatingSubRegionName
			FROM 
				dbo.OriginatingRegionLatestState
		END

	END

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable (OriginatingRegionKey)

	----------------------------------------------------------------------------
	-- Allocation Sub Regions
	----------------------------------------------------------------------------

	CREATE TABLE #AllocationSubRegionFilterTable 
	(
		AllocationRegionKey INT NOT NULL,
		AllocationRegionName VARCHAR(MAX) NOT NULL,
		AllocationSubRegionName VARCHAR(MAX) NOT NULL
	)

	IF (@_AllocationSubRegionList IS NOT NULL)
	BEGIN

		IF (@_AllocationSubRegionList <> ''All'')
		BEGIN

			INSERT INTO #AllocationSubRegionFilterTable
			SELECT DISTINCT
				AllocationRegionLatestState.AllocationRegionKey,
				AllocationRegionLatestState.LatestAllocationRegionName,
				AllocationRegionLatestState.LatestAllocationSubRegionName
			FROM 
				dbo.Split(@_AllocationSubRegionList) AllocationSubRegionParameters
				INNER JOIN dbo.AllocationRegion ON
					AllocationRegion.SubRegionName = AllocationSubRegionParameters.item
				INNER JOIN dbo.AllocationRegionLatestState ON
					AllocationRegion.GlobalRegionId = AllocationRegionLatestState.AllocationRegionGlobalRegionId AND
					AllocationRegion.SnapshotId = AllocationRegionLatestState.AllocationRegionSnapshotId
					
		END
		ELSE IF (@_AllocationSubRegionList = ''All'')
		BEGIN

			INSERT INTO #AllocationSubRegionFilterTable
			SELECT 
				AllocationRegionLatestState.AllocationRegionKey,
				AllocationRegionLatestState.LatestAllocationRegionName,
				AllocationRegionLatestState.LatestAllocationSubRegionName
			FROM
				dbo.AllocationRegionLatestState

		END

	END

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)

	----------------------------------------------------------------------------
	-- Functional Departments
	----------------------------------------------------------------------------

	CREATE TABLE #FunctionalDepartmentFilterTable 
	(
		FunctionalDepartmentKey INT NOT NULL,
		FunctionalDepartmentName VARCHAR(MAX) NOT NULL,
		SubFunctionalDepartmentName VARCHAR(MAX) NOT NULL
	)

	IF (@_FunctionalDepartmentList IS NOT NULL)
	BEGIN	

		IF (@_FunctionalDepartmentList <> ''All'')
		BEGIN

			INSERT INTO #FunctionalDepartmentFilterTable
			SELECT DISTINCT
				FunctionalDepartmentLatestState.FunctionalDepartmentKey,
				FunctionalDepartmentLatestState.LatestFunctionalDepartmentName,
				FunctionalDepartmentLatestState.LatestSubFunctionalDepartmentName
			FROM
				dbo.Split(@_FunctionalDepartmentList) FunctionalDepartmentParameters
				INNER JOIN dbo.FunctionalDepartment ON
					FunctionalDepartment.FunctionalDepartmentName = FunctionalDepartmentParameters.item	
				INNER JOIN FunctionalDepartmentLatestState ON
					FunctionalDepartment.ReferenceCode = FunctionalDepartmentLatestState.FunctionalDepartmentReferenceCode

		END
		ELSE IF (@_FunctionalDepartmentList = ''All'')
		BEGIN

			INSERT INTO #FunctionalDepartmentFilterTable
			SELECT 
				FunctionalDepartmentLatestState.FunctionalDepartmentKey,
				FunctionalDepartmentLatestState.LatestFunctionalDepartmentName,
				FunctionalDepartmentLatestState.LatestSubFunctionalDepartmentName
			FROM 
				dbo.FunctionalDepartmentLatestState

		END

	END

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
	
END
	
/* ===============================================================================================================================================
	STEP 4: Create results temp table
	
		We will insert all the resulting transaction data into this result temp table:
		
		1. Actuals transactions
		2. Budget transactions
		3. Reforecast transactions									
   ============================================================================================================================================= */
BEGIN

	IF 	OBJECT_ID(''tempdb..#BudgetJobCode'') IS NOT NULL
		DROP TABLE #BudgetJobCode

	CREATE TABLE #BudgetJobCode
	(	
		GLCategorizationHierarchyKey	INT,
		AllocationRegionKey				INT,
		OriginatingRegionKey			INT,
		FunctionalDepartmentKey			INT,
		PropertyFundKey					INT,
		SourceName						VARCHAR(50),
		EntryDate						VARCHAR(10),
		[User]							NVARCHAR(20),
		[Description]					NVARCHAR(60),
		AdditionalDescription			NVARCHAR(4000),
		PropertyFundCode				Varchar(11) DEFAULT(''''),
		OriginatingRegionCode			Varchar(30) DEFAULT(''''),
		FunctionalDepartmentCode		Varchar(15) DEFAULT(''''),
		GlAccountCode					VARCHAR(15) DEFAULT(''''),
		GlAccountName					VARCHAR(300) DEFAULT(''''),
		CalendarPeriod					VARCHAR(6) DEFAULT(''''),
		
		--Month to date	
		MtdGrossActual					MONEY,
		MtdGrossBudget					MONEY,
		MtdGrossReforecast				MONEY,
		MtdNetActual					MONEY,
		MtdNetBudget					MONEY,
		MtdNetReforecast				MONEY,
		
		--Year to date
		YtdGrossActual					MONEY,	
		YtdGrossBudget					MONEY, 
		YtdGrossReforecast				MONEY,
		YtdNetActual					MONEY, 
		YtdNetBudget					MONEY, 
		YtdNetReforecast				MONEY,

		--Annual	
		AnnualGrossBudget				MONEY,
		AnnualGrossReforecast			MONEY,
		AnnualNetBudget					MONEY,
		AnnualNetReforecast				MONEY,
		
		--Annual estimated
		AnnualEstGrossBudget			MONEY,
		AnnualEstGrossReforecast		MONEY,
		AnnualEstNetBudget				MONEY,
		AnnualEstNetReforecast			MONEY
	)

END

/* ===============================================================================================================================================
	STEP 5: Get Profitability Actual Data
			
		Budget Originator data is only ''Unallocated'',''Not Overhead'', ''UNKNOWN''
		''Outflow'', ''UNKNOWN'' only, they only look at expenses, not income
		Exclude ''Architects & Engineering'', was re-classified, as per Martin''s request
   ============================================================================================================================================= */
BEGIN

	INSERT INTO #BudgetJobCode
	SELECT
		GlHierarchy.GLCategorizationHierarchyKey AS ''GLCategorizationHierarchyKey'',
		ProfitabilityActual.AllocationRegionKey AS ''AllocationRegionKey'',
		ProfitabilityActual.OriginatingRegionKey AS ''OriginatingRegionKey'',
		ProfitabilityActual.FunctionalDepartmentKey AS ''FunctionalDepartmentKey'',
		ProfitabilityActual.PropertyFundKey AS ''PropertyFundKey'',
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''	
			ELSE
				[Source].SourceName
		END AS ''SourceName'',
		CONVERT(VARCHAR(10), ISNULL(ProfitabilityActual.LastDate, ''''), 101) AS ''EntryDate'',
		ProfitabilityActual.[User] AS ''User'',
		ProfitabilityActual.[Description] AS ''Description'',
		ProfitabilityActual.AdditionalDescription AS ''AdditionalDescription'',
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''	
			ELSE
				ProfitabilityActual.PropertyFundCode
		END AS ''PropertyFundCode'',
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''	
			ELSE
				ProfitabilityActual.OriginatingRegionCode
		END AS ''OriginatingRegionCode'',
		ProfitabilityActual.FunctionalDepartmentCode,
		GlHierarchy.LatestGlAccountCode,
		GlHierarchy.LatestGlAccountName,
		Calendar.CalendarPeriod,

		SUM
		(
			#ExchangeRate.Rate *
			CASE
				WHEN
					Calendar.CalendarPeriod = @ReportExpensePeriodParameter
				THEN
					ProfitabilityActual.LocalActual
				ELSE
					0.0
			END
		) AS ''MtdGrossActual'',
		NULL AS ''MtdGrossBudget'',
		NULL AS ''MtdGrossReforecast'',
		
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE 
				WHEN
					Calendar.CalendarPeriod = @ReportExpensePeriodParameter
				THEN
					ProfitabilityActual.LocalActual
				ELSE
					0.0
			END
		) AS ''MtdNetActual'',
		NULL AS ''MtdNetBudget'',
		NULL AS ''MtdNetReforecast'',
		
		SUM
		(
			#ExchangeRate.Rate * 
			CASE 
				WHEN
					Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
				THEN
					ProfitabilityActual.LocalActual
				ELSE
					0.0
			END
		) AS ''YtdGrossActual'',
		NULL AS ''YtdGrossBudget'',
		NULL AS ''YtdGrossReforecast'',
		
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE
				WHEN
					Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
				THEN
					ProfitabilityActual.LocalActual
				ELSE
					0.0
			END
		) AS ''YtdNetActual'',
		NULL AS ''YtdNetBudget'',
		NULL AS ''YtdNetReforecast'',
		
		NULL AS ''AnnualGrossBudget'',
		NULL AS ''AnnualGrossReforecast'',
		
		NULL AS ''AnnualNetBudget'',
		NULL AS ''AnnualNetReforecast'',
		
		SUM
		(
			#ExchangeRate.Rate *
			CASE
				WHEN
					Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
				THEN
					ProfitabilityActual.LocalActual
				ELSE
					0.0
			END
		) AS ''AnnualEstGrossBudget'',
		NULL AS ''AnnualEstGrossReforecast'',
		
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE
				WHEN
					Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
				THEN
					ProfitabilityActual.LocalActual
				ELSE
					0.0
			END
		) AS ''AnnualEstNetBudget'',
		NULL AS ''AnnualEstNetReforecast''
	FROM 
		dbo.ProfitabilityActual 

		INNER JOIN #EntityFilterTable ON
			ProfitabilityActual.PropertyFundKey = #EntityFilterTable.PropertyFundKey
			
		INNER JOIN #OriginatingSubRegionFilterTable ON
			ProfitabilityActual.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey
			
		INNER JOIN #AllocationSubRegionFilterTable ON
			ProfitabilityActual.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey
			
		INNER JOIN #FunctionalDepartmentFilterTable ON
			ProfitabilityActual.FunctionalDepartmentKey = #FunctionalDepartmentFilterTable.FunctionalDepartmentKey
	
		INNER JOIN #ExchangeRate ON
			ProfitabilityActual.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
			ProfitabilityActual.CalendarKey = #ExchangeRate.CalendarKey
			
		INNER JOIN dbo.Currency ON
			#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey
			
		INNER JOIN dbo.Overhead ON
			ProfitabilityActual.OverheadKey = Overhead.OverheadKey
								
		INNER JOIN dbo.Calendar ON
			ProfitabilityActual.CalendarKey = Calendar.CalendarKey
		
		INNER JOIN dbo.Source ON
			ProfitabilityActual.SourceKey = Source.SourceKey
		
		INNER JOIN dbo.Reimbursable ON
			ProfitabilityActual.ReimbursableKey = Reimbursable.ReimbursableKey
			
		INNER JOIN dbo.GLCategorizationHierarchy GlobalGLCategorizationHierarchy ON
			ProfitabilityActual.GlobalGLCategorizationHierarchyKey = GlobalGLCategorizationHierarchy.GLCategorizationHierarchyKey

		INNER JOIN dbo.GlCategorizationHierarchyLatestState GlHierarchy ON
			GlHierarchy.GLCategorizationHierarchyKey = 
			CASE
				WHEN @_GLCategorization = ''Global'' THEN ProfitabilityActual.GlobalGLCategorizationHierarchyKey 
				WHEN @_GLCategorization = ''US Property'' THEN ProfitabilityActual.USPropertyGLCategorizationHierarchyKey
				WHEN @_GLCategorization = ''US Fund'' THEN ProfitabilityActual.USFundGLCategorizationHierarchyKey 
				WHEN @_GLCategorization = ''US Development'' THEN ProfitabilityActual.USDevelopmentGLCategorizationHierarchyKey
				WHEN @_GLCategorization = ''EU Property'' THEN ProfitabilityActual.EUPropertyGLCategorizationHierarchyKey 
				WHEN @_GLCategorization = ''EU Fund'' THEN ProfitabilityActual.EUFundGLCategorizationHierarchyKey 
				WHEN @_GLCategorization = ''EU Development'' THEN ProfitabilityActual.EUDevelopmentGLCategorizationHierarchyKey
				ELSE NULL
			END
	WHERE 
		Calendar.CalendarYear = STR(@CalendarYear, 10, 0) AND
		Currency.CurrencyCode = @_DestinationCurrency AND
		GlobalGLCategorizationHierarchy.GLMinorCategoryName <> ''Bonus'' AND
		GlHierarchy.LatestGLMinorCategoryName <> ''Architects & Engineering'' AND
		GlHierarchy.LatestGLMajorCategoryName NOT IN
			(
				''Corporate Tax'',
				''Depreciation Expense'',
				''Realized (Gain)/Loss'',
				''Unrealized (Gain)/Loss'',
				''Miscellaneous Expense'',
				''Miscellaneous Income'',
				''Interest & Penalties'',
				''Guaranteed Payment''
			) AND
		GlHierarchy.LatestInflowOutflow IN
		(
			''Outflow'', 
			''UNKNOWN''
		) AND
		Overhead.OverheadCode IN 
		(
			''UNALLOC'',
			''UNKNOWN'',
			''N/A''
		)
	GROUP BY
		GlHierarchy.GLCategorizationHierarchyKey,
		ProfitabilityActual.AllocationRegionKey,
		ProfitabilityActual.OriginatingRegionKey,
		ProfitabilityActual.FunctionalDepartmentKey,
		ProfitabilityActual.PropertyFundKey,
		Calendar.CalendarPeriod,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''	
			ELSE
				[Source].SourceName
		END,
		CONVERT(VARCHAR(10), ISNULL(ProfitabilityActual.LastDate, ''''), 101),
		ProfitabilityActual.[User],
		ProfitabilityActual.[Description],
		ProfitabilityActual.AdditionalDescription,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''	
			ELSE
				ProfitabilityActual.PropertyFundCode
		END,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''	
			ELSE
				ProfitabilityActual.OriginatingRegionCode
		END,
		ProfitabilityActual.FunctionalDepartmentCode,
		GlHierarchy.LatestGlAccountCode,
		GlHierarchy.LatestGlAccountName
	
END
	
/* ===============================================================================================================================================
	STEP 6: Get Profitability Budget Data
			
		Budget Originator data is only ''Unallocated'',''Not Overhead'', ''UNKNOWN''
		''Outflow'', ''UNKNOWN'' only, they only look at expenses, not income
		Exclude ''Architects & Engineering'', was re-classified, as per Martin''s request
   ============================================================================================================================================= */
BEGIN

	INSERT INTO #BudgetJobCode
	SELECT 
		GlHierarchy.GLCategorizationHierarchyKey,
		ProfitabilityBudget.AllocationRegionKey,
		ProfitabilityBudget.OriginatingRegionKey,
		ProfitabilityBudget.FunctionalDepartmentKey,
		ProfitabilityBudget.PropertyFundKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''
			ELSE
				[Source].SourceName
		END AS ''SourceName'',
		'''' AS ''EntryDate'',
		'''' AS ''User'',
		'''' AS ''Description'',
		'''' AS ''AdditionalDescription'',
		'''' AS ''PropertyFundCode'',
		'''' AS ''OriginatingRegionCode'',
		'''' AS ''FunctionalDepartmentCode'',
		GlHierarchy.LatestGlAccountCode,
		GlHierarchy.LatestGlAccountName,
		Calendar.CalendarPeriod,

		NULL AS ''MtdGrossActual'',
		SUM
		(
			#ExchangeRate.Rate *
			CASE 
				WHEN
					Calendar.CalendarPeriod = @ReportExpensePeriodParameter
				THEN
					ProfitabilityBudget.LocalBudget
				ELSE
					0.0
			END
		) AS ''MtdGrossBudget'',
		NULL AS ''MtdGrossReforecast'',
		
		NULL AS ''MtdNetActual'',
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE 
				WHEN
					Calendar.CalendarPeriod = @ReportExpensePeriodParameter
				THEN
					ProfitabilityBudget.LocalBudget
				ELSE
					0.0
			END
		) AS ''MtdNetBudget'',
		NULL AS ''MtdNetReforecast'',
		
		NULL AS ''YtdGrossActual'',
		SUM
		(
			#ExchangeRate.Rate *
			CASE 
				WHEN
					Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
				THEN
					ProfitabilityBudget.LocalBudget
				ELSE
					0.0
			END
		) AS ''YtdGrossBudget'',
		NULL AS ''YtdGrossReforecast'',
		
		NULL AS ''YtdNetActual'',
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE 
				WHEN
					Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
				THEN
					ProfitabilityBudget.LocalBudget
				ELSE
					0.0
			END
		) AS ''YtdNetBudget'',
		
		NULL AS ''YtdNetReforecast'',
		
		SUM
		(
			#ExchangeRate.Rate *
			ProfitabilityBudget.LocalBudget 
		) AS ''AnnualGrossBudget'',
		
		NULL AS ''AnnualGrossReforecast'',
		
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			ProfitabilityBudget.LocalBudget
		) AS ''AnnualNetBudget'',
		
		NULL AS ''AnnualNetReforecast'',
		
		SUM
		(
			#ExchangeRate.Rate *
			CASE
				WHEN
					Calendar.CalendarPeriod > @ReportExpensePeriodParameter
				THEN
					ProfitabilityBudget.LocalBudget
				ELSE
					0.0
			END
		) AS ''AnnualEstGrossBudget'',
		
		NULL AS ''AnnualEstGrossReforecast'',
		
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE
				WHEN
					Calendar.CalendarPeriod > @ReportExpensePeriodParameter
				THEN
					ProfitabilityBudget.LocalBudget
				ELSE
					0.0
			END
		) AS ''AnnualEstNetBudget'',
		
		NULL AS ''AnnualEstNetReforecast''
	FROM 
		ProfitabilityBudget

		INNER JOIN #EntityFilterTable ON
			ProfitabilityBudget.PropertyFundKey = #EntityFilterTable.PropertyFundKey
			
		INNER JOIN #OriginatingSubRegionFilterTable ON
			ProfitabilityBudget.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey
			
		INNER JOIN #AllocationSubRegionFilterTable ON
			ProfitabilityBudget.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey
			
		INNER JOIN #FunctionalDepartmentFilterTable ON
			ProfitabilityBudget.FunctionalDepartmentKey = #FunctionalDepartmentFilterTable.FunctionalDepartmentKey
		
		INNER JOIN #ExchangeRate ON
			ProfitabilityBudget.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
			ProfitabilityBudget.CalendarKey = #ExchangeRate.CalendarKey
			
		INNER JOIN dbo.Currency ON
			#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey
			
		INNER JOIN dbo.Overhead ON
			ProfitabilityBudget.OverheadKey = Overhead.OverheadKey
								
		INNER JOIN dbo.Calendar ON
			ProfitabilityBudget.CalendarKey = Calendar.CalendarKey
		
		INNER JOIN dbo.[Source] ON
			ProfitabilityBudget.SourceKey = [Source].SourceKey
		
		INNER JOIN dbo.Reimbursable ON
			ProfitabilityBudget.ReimbursableKey = Reimbursable.ReimbursableKey

		INNER JOIN dbo.GLCategorizationHierarchy GlobalGLCategorizationHierarchy ON
			ProfitabilityBudget.GlobalGLCategorizationHierarchyKey = GlobalGLCategorizationHierarchy.GLCategorizationHierarchyKey

		INNER JOIN dbo.GlCategorizationHierarchyLatestState GlHierarchy ON
			GlHierarchy.GLCategorizationHierarchyKey = 
			CASE
				WHEN @_GLCategorization = ''Global'' THEN ProfitabilityBudget.GlobalGLCategorizationHierarchyKey 
				WHEN @_GLCategorization = ''US Property'' THEN ProfitabilityBudget.USPropertyGLCategorizationHierarchyKey
				WHEN @_GLCategorization = ''US Fund'' THEN ProfitabilityBudget.USFundGLCategorizationHierarchyKey 
				WHEN @_GLCategorization = ''US Development'' THEN ProfitabilityBudget.USDevelopmentGLCategorizationHierarchyKey
				WHEN @_GLCategorization = ''EU Property'' THEN ProfitabilityBudget.EUPropertyGLCategorizationHierarchyKey 
				WHEN @_GLCategorization = ''EU Fund'' THEN ProfitabilityBudget.EUFundGLCategorizationHierarchyKey 
				WHEN @_GLCategorization = ''EU Development'' THEN ProfitabilityBudget.EUDevelopmentGLCategorizationHierarchyKey
				ELSE NULL
			END
	WHERE 
		Calendar.CalendarYear = @CalendarYear AND
		Currency.CurrencyCode = @_DestinationCurrency AND
		GlobalGLCategorizationHierarchy.GLMinorCategoryName <> ''Bonus'' AND
		GlHierarchy.LatestGLMinorCategoryName <> ''Architects & Engineering'' AND
		GlHierarchy.LatestGLMajorCategoryName NOT IN
			(
				''Corporate Tax'',
				''Depreciation Expense'',
				''Realized (Gain)/Loss'',
				''Unrealized (Gain)/Loss'',
				''Miscellaneous Expense'',
				''Miscellaneous Income'',
				''Interest & Penalties'',
				''Guaranteed Payment''
			) AND
		Overhead.OverheadCode IN 
		(
			''UNALLOC'',
			''UNKNOWN'',
			''N/A''
		) AND
		GlHierarchy.LatestInflowOutflow IN
		(
			''Outflow'',
			''UNKNOWN''
		)
	GROUP BY
		GlHierarchy.GLCategorizationHierarchyKey,
		ProfitabilityBudget.AllocationRegionKey,
		ProfitabilityBudget.OriginatingRegionKey,
		ProfitabilityBudget.FunctionalDepartmentKey,
		ProfitabilityBudget.PropertyFundKey,
		Calendar.CalendarPeriod,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
			THEN
				''Sensitized''	
			ELSE
				[Source].SourceName
		END,
		GlHierarchy.LatestGlAccountCode,
		GlHierarchy.LatestGlAccountName
	
END

/* ===============================================================================================================================================
	STEP 7: Get Profitability Reforecast Data 
	
	There are only reforecast transactions for Q1, Q2, Q3
			
	Budget Originator data is only ''Unallocated'',''Not Overhead'', ''UNKNOWN''
	''Outflow'', ''UNKNOWN'' only, they only look at expenses, not income
	Exclude ''Architects & Engineering'', was re-classified, as per Martin''s request
   ============================================================================================================================================ */
BEGIN
	
	IF @_ReforecastQuarterName IN (''Q1'', ''Q2'', ''Q3'')
	BEGIN

		INSERT INTO #BudgetJobCode
		SELECT 
			GlHierarchy.GLCategorizationHierarchyKey,
			ProfitabilityReforecast.AllocationRegionKey,
			ProfitabilityReforecast.OriginatingRegionKey,
			ProfitabilityReforecast.FunctionalDepartmentKey,
			ProfitabilityReforecast.PropertyFundKey,
			CASE
				WHEN
					@_DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
				THEN
					''Sensitized''	
				ELSE
					[Source].SourceName
			END AS ''SourceName'',
			'''' AS ''EntryDate'',
			'''' AS ''User'',
			'''' AS ''Description'',
			'''' AS ''AdditionalDescription'',
			'''' AS ''PropertyFundCode'',
			'''' AS ''OriginatingRegionCode'',
			'''' AS ''FunctionalDepartmentCode'',
			GlHierarchy.LatestGlAccountCode,
			GlHierarchy.LatestGlAccountName,
			Calendar.CalendarPeriod,

			NULL AS ''MtdGrossActual'',
			NULL AS ''MtdGrossBudget'',
			SUM
			(
				#ExchangeRate.Rate *
				CASE
					WHEN
						Calendar.CalendarPeriod = @ReportExpensePeriodParameter
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0.0
				END
			) AS ''MtdGrossReforecast'',
			
			NULL AS ''MtdNetActual'',
			NULL AS ''MtdNetBudget'',

			SUM
			(
				#ExchangeRate.Rate *
				Reimbursable.MultiplicationFactor * 
				CASE 
					WHEN
						Calendar.CalendarPeriod = @ReportExpensePeriodParameter
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0.0
				END
			) AS ''MtdNetReforecast'',

			NULL AS ''YtdGrossActual'',	
			NULL AS ''YtdGrossBudget'',

			SUM
			(
				#ExchangeRate.Rate * 
				CASE 
					WHEN
						Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0.0
				END
			) AS ''YtdGrossReforecast'',
			
			NULL AS ''YtdNetActual'', 
			NULL AS ''YtdNetBudget'',
			
			SUM
			(
				#ExchangeRate.Rate *Reimbursable.MultiplicationFactor * 
				CASE 
					WHEN
						Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0.0
				END
			) AS ''YtdNetReforecast'',
		    
			NULL AS ''AnnualGrossBudget'', 
			SUM
			(
				#ExchangeRate.Rate * 
				ProfitabilityReforecast.LocalReforecast
			) AS ''AnnualGrossReforecast'',

			NULL AS ''AnnualNetBudget'', 
			SUM
			(
				#ExchangeRate.Rate *
				Reimbursable.MultiplicationFactor * 
				ProfitabilityReforecast.LocalReforecast
			) AS ''AnnualNetReforecast'',

			NULL AS ''AnnualEstGrossBudget'',
			SUM
			(
				#ExchangeRate.Rate *
				CASE 
					WHEN
					(
						Calendar.CalendarPeriod > @ReportExpensePeriodParameter OR 
						(
							LEFT (ProfitabilityReforecast.ReferenceCode, 3) = ''BC:'' AND
							STR(@ReforecastEffectivePeriod,6,0) IN 
							(
								201003, 
								201006,
								201009
							)
						)
					)
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0.0
				END
			) AS ''AnnualEstGrossReforecast'',

			NULL AS ''AnnualEstNetBudget'',
			SUM
			(
				#ExchangeRate.Rate *
				CASE
					WHEN
					(
						Calendar.CalendarPeriod > @ReportExpensePeriodParameter OR 
						(
							LEFT (ProfitabilityReforecast.ReferenceCode, 3) = ''BC:'' AND
							STR(@ReforecastEffectivePeriod,6,0) IN 
							(
								201003,
								201006,
								201009
							)
						)
					)
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0.0
				END 
			) AS ''AnnualEstNetReforecast''

		FROM 
			dbo.ProfitabilityReforecast
		
		INNER JOIN #EntityFilterTable ON
			ProfitabilityReforecast.PropertyFundKey = #EntityFilterTable.PropertyFundKey
			
		INNER JOIN #OriginatingSubRegionFilterTable ON
			ProfitabilityReforecast.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey
			
		INNER JOIN #AllocationSubRegionFilterTable ON
			ProfitabilityReforecast.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey
			
		INNER JOIN #FunctionalDepartmentFilterTable ON
			ProfitabilityReforecast.FunctionalDepartmentKey = #FunctionalDepartmentFilterTable.FunctionalDepartmentKey

		INNER JOIN #ExchangeRate ON
			ProfitabilityReforecast.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
			ProfitabilityReforecast.CalendarKey = #ExchangeRate.CalendarKey

		INNER JOIN dbo.Currency ON
			#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey

		INNER JOIN dbo.Overhead ON
			ProfitabilityReforecast.OverheadKey = Overhead.OverheadKey

		INNER JOIN dbo.Calendar ON
			ProfitabilityReforecast.CalendarKey = Calendar.CalendarKey

		INNER JOIN dbo.[Source] ON
			ProfitabilityReforecast.SourceKey = [Source].SourceKey

		INNER JOIN dbo.Reimbursable ON
			ProfitabilityReforecast.ReimbursableKey = Reimbursable.ReimbursableKey

		INNER JOIN dbo.Reforecast ON
			ProfitabilityReforecast.ReforecastKey = Reforecast.ReforecastKey

		INNER JOIN dbo.GLCategorizationHierarchy GlobalGLCategorizationHierarchy ON
			ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey = GlobalGLCategorizationHierarchy.GLCategorizationHierarchyKey

		INNER JOIN dbo.GlCategorizationHierarchyLatestState GlHierarchy ON
			GlHierarchy.GLCategorizationHierarchyKey = 
			CASE
				WHEN @_GLCategorization = ''Global'' THEN ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey 
				WHEN @_GLCategorization = ''US Property'' THEN ProfitabilityReforecast.USPropertyGLCategorizationHierarchyKey
				WHEN @_GLCategorization = ''US Fund'' THEN ProfitabilityReforecast.USFundGLCategorizationHierarchyKey 
				WHEN @_GLCategorization = ''US Development'' THEN ProfitabilityReforecast.USDevelopmentGLCategorizationHierarchyKey
				WHEN @_GLCategorization = ''EU Property'' THEN ProfitabilityReforecast.EUPropertyGLCategorizationHierarchyKey 
				WHEN @_GLCategorization = ''EU Fund'' THEN ProfitabilityReforecast.EUFundGLCategorizationHierarchyKey 
				WHEN @_GLCategorization = ''EU Development'' THEN ProfitabilityReforecast.EUDevelopmentGLCategorizationHierarchyKey
				ELSE NULL
			END
		WHERE
			Reforecast.ReforecastEffectivePeriod = @ReforecastEffectivePeriod AND
			Calendar.CalendarYear = @CalendarYear AND
			Currency.CurrencyCode = @_DestinationCurrency AND
			GlobalGLCategorizationHierarchy.GLMinorCategoryName <> ''Bonus'' AND
			GlHierarchy.LatestGLMinorCategoryName <> ''Architects & Engineering'' AND
			GlHierarchy.LatestGLMajorCategoryName NOT IN
				(
					''Corporate Tax'',
					''Depreciation Expense'',
					''Realized (Gain)/Loss'',
					''Unrealized (Gain)/Loss'',
					''Miscellaneous Expense'',
					''Miscellaneous Income'',
					''Interest & Penalties'',
					''Guaranteed Payment''
				) AND
			GlHierarchy.LatestInflowOutflow IN
			(
				''Outflow'', 
				''UNKNOWN''
			) AND
			Overhead.OverheadCode IN
			(
				''UNALLOC'',
				''UNKNOWN'',
				''N/A''
			)
		GROUP BY
			GlHierarchy.GLCategorizationHierarchyKey,
			ProfitabilityReforecast.AllocationRegionKey,
			ProfitabilityReforecast.OriginatingRegionKey,
			ProfitabilityReforecast.FunctionalDepartmentKey,
			ProfitabilityReforecast.PropertyFundKey,
			Calendar.CalendarPeriod,
			CASE
				WHEN
					@_DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
				THEN
					''Sensitized''	
				ELSE
					[Source].SourceName
			END,
			GlHierarchy.LatestGlAccountCode,
			GlHierarchy.LatestGlAccountName

	END

END

/* ===============================================================================================================================================
	STEP 8: Get Total Summary Per cost point
	
	We are now combining the results for actuals, budgets and reforecasts, thus creating total amounts per:
	
	AllocationSubRegion,
	OriginatingSubRegion,
	FunctionalDepartment,
	GLFinancialCategory,
	GLMajorCategory,
	GLMinorCategory,
	PropertyFund
   ============================================================================================================================================= */
BEGIN

	SELECT
		AllocationRegion.AllocationRegionName AS ''AllocationRegionName'',
		AllocationRegion.AllocationSubRegionName AS ''AllocationSubRegionName'',
		OriginatingRegion.OriginatingRegionName AS ''OriginatingRegionName'',
		OriginatingRegion.OriginatingSubRegionName AS ''OriginatingSubRegionName'',
		FunctionalDepartment.FunctionalDepartmentName,
		FunctionalDepartment.SubFunctionalDepartmentName AS ''JobCode'',
		GLCategorizationHierarchy.LatestGLFinancialCategoryName AS ''FinancialCategoryName'',
		GLCategorizationHierarchy.LatestGLMajorCategoryName AS ''MajorExpenseCategoryName'',
		GLCategorizationHierarchy.LatestGLMinorCategoryName AS ''MinorExpenseCategoryName'',
		PropertyFund.PropertyFundType AS ''EntityType'',
		PropertyFund.PropertyFundName AS ''EntityName'',
		#BudgetJobCode.CalendarPeriod AS ''ExpensePeriod'',
		#BudgetJobCode.EntryDate,
		#BudgetJobCode.[User],
		#BudgetJobCode.[Description],
		#BudgetJobCode.AdditionalDescription,
		#BudgetJobCode.SourceName,
		#BudgetJobCode.PropertyFundCode,
		CASE 
			WHEN
				(SUBSTRING(#BudgetJobCode.SourceName, CHARINDEX('' '', #BudgetJobCode.SourceName) +1, 8) = ''Property'')
			THEN
				RTRIM(#BudgetJobCode.OriginatingRegionCode) + LTRIM(#BudgetJobCode.FunctionalDepartmentCode) 
			ELSE
				#BudgetJobCode.OriginatingRegionCode 
		END AS ''OriginatingRegionCode'',
		ISNULL (#BudgetJobCode.GlAccountCode, '''') AS ''GlAccountCode'',
		ISNULL (#BudgetJobCode.GlAccountName, '''') AS ''GlAccountName'',
				
		--Month to date    
		SUM
		(
			CASE 
				WHEN
					(@_CalculationMethod = ''Gross'')
				THEN
					ISNULL(MtdGrossActual, 0)
				ELSE
					ISNULL(MtdNetActual, 0)
			END
		) AS ''MtdActual'',
		SUM
		(
			CASE 
				WHEN
					@_CalculationMethod = ''Gross'' THEN ISNULL(MtdGrossBudget,0) 
				ELSE ISNULL(MtdNetBudget,0) 
			END
		) AS ''MtdOriginalBudget'',
		
		SUM
		(
			CASE 
				WHEN
					@_CalculationMethod = ''Gross''
				THEN
					ISNULL
					(
						CASE 
							WHEN
								@_ReforecastQuarterName = ''Q0''
							THEN
								MtdGrossBudget
							ELSE
								MtdGrossReforecast
						END,
						0
					)
				ELSE
					ISNULL
					(
						CASE
							WHEN
								@_ReforecastQuarterName = ''Q0''
							THEN
								MtdNetBudget
							ELSE
								MtdNetReforecast
						END,
						0
					) 
				END
			) 
		AS ''MtdReforecast'',
		
		SUM
		(
			CASE 
				WHEN
					@_CalculationMethod = ''Gross''
				THEN
					ISNULL
					(
						CASE
							WHEN
								@_ReforecastQuarterName = ''Q0''
							THEN
								MtdGrossBudget
							ELSE
								MtdGrossReforecast
						END,
						0
					) - ISNULL(MtdGrossActual, 0)
				ELSE
					ISNULL
					(
						CASE 
							WHEN
								@_ReforecastQuarterName = ''Q0''
							THEN
								MtdNetBudget
							ELSE
								MtdNetReforecast
						END,
						0
					) - ISNULL(MtdNetActual, 0)
				END
			)
		AS ''MtdVariance'',

		--Year to date
		SUM
		(
			CASE 
				WHEN
					@_CalculationMethod = ''Gross''
				THEN
					ISNULL(YtdGrossActual, 0)
				ELSE
					ISNULL(YtdNetActual, 0)
			END
		) AS ''YtdActual'',	

		SUM
		(
			CASE 
				WHEN
					@_CalculationMethod = ''Gross''
				THEN
					ISNULL(YtdGrossBudget, 0)
				ELSE
					ISNULL(YtdNetBudget, 0)
			END
		) AS ''YtdOriginalBudget'',

		SUM
		(
			CASE 
				WHEN
					@_CalculationMethod = ''Gross''
				THEN
					ISNULL
					(
						CASE
							WHEN
								@_ReforecastQuarterName = ''Q0''
							THEN
								YtdGrossBudget
							ELSE
								YtdGrossReforecast
						END,
						0
					)
				ELSE
					ISNULL
					(
						CASE
							WHEN
								@_ReforecastQuarterName = ''Q0''
							THEN
								YtdNetBudget
							ELSE
								YtdNetReforecast
						END,
						0
					)
			END
		) AS ''YtdReforecast'',

		SUM
		(
			CASE
				WHEN
					@_CalculationMethod = ''Gross''
				THEN
					ISNULL
					(
						CASE
							WHEN
								@_ReforecastQuarterName = ''Q0''
							THEN
								YtdGrossBudget
							ELSE
								YtdGrossReforecast
						END,
						0
					) - ISNULL(YtdGrossActual, 0)
				ELSE
					ISNULL
					(
						CASE 
							WHEN
								@_ReforecastQuarterName = ''Q0''
							THEN
								YtdNetBudget
							ELSE
								YtdNetReforecast
						END,
						0
					) - ISNULL(YtdNetActual, 0) 
			END
		)
		AS ''YtdVariance'',

		--Annual
		SUM
		(
			CASE 
				WHEN
					@_CalculationMethod = ''Gross''
				THEN
					ISNULL(AnnualGrossBudget, 0)
				ELSE
					ISNULL(AnnualNetBudget, 0)
			END
		) AS ''AnnualOriginalBudget'',
		
		SUM
		(
			CASE 
				WHEN
					@_CalculationMethod = ''Gross''
				THEN
					ISNULL
					(
						CASE 
							WHEN
								@_ReforecastQuarterName = ''Q0''
							THEN
								0
							ELSE
								AnnualGrossReforecast
						END,
						0
					) 
				ELSE
					ISNULL
					(
						CASE
							WHEN
								@_ReforecastQuarterName = ''Q0''
							THEN
								0
							ELSE
								AnnualNetReforecast
						END,
						0
					) 
			END
		) AS ''AnnualReforecast''

	INTO
		#Output
	FROM 
		#BudgetJobCode

		INNER JOIN #AllocationSubRegionFilterTable AllocationRegion ON
			#BudgetJobCode.AllocationRegionKey = AllocationRegion.AllocationRegionKey

		INNER JOIN #OriginatingSubRegionFilterTable OriginatingRegion ON
			#BudgetJobCode.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey

		INNER JOIN #EntityFilterTable PropertyFund On
			#BudgetJobCode.PropertyFundKey = PropertyFund.PropertyFundKey

		INNER JOIN #FunctionalDepartmentFilterTable FunctionalDepartment ON
			#BudgetJobCode.FunctionalDepartmentKey = FunctionalDepartment.FunctionalDepartmentKey

		INNER JOIN dbo.GLCategorizationHierarchyLatestState GLCategorizationHierarchy ON
			#BudgetJobCode.GLCategorizationHierarchyKey = GLCategorizationHierarchy.GLCategorizationHierarchyKey
	GROUP BY
		AllocationRegion.AllocationRegionName,
		AllocationRegion.AllocationSubRegionName,
		OriginatingRegion.OriginatingRegionName,
		OriginatingRegion.OriginatingSubRegionName,
		FunctionalDepartment.FunctionalDepartmentName,
		FunctionalDepartment.SubFunctionalDepartmentName,
		GLCategorizationHierarchy.LatestGLFinancialCategoryName,
		GLCategorizationHierarchy.LatestGLMajorCategoryName,
		GLCategorizationHierarchy.LatestGLMinorCategoryName,
		PropertyFund.PropertyFundType,
		PropertyFund.PropertyFundName,
		#BudgetJobCode.CalendarPeriod,
		#BudgetJobCode.EntryDate,
		#BudgetJobCode.[User],
		#BudgetJobCode.[Description],
		#BudgetJobCode.AdditionalDescription,
		#BudgetJobCode.SourceName,
		#BudgetJobCode.PropertyFundCode,
		CASE 
			WHEN
				(SUBSTRING(#BudgetJobCode.SourceName, CHARINDEX('' '', #BudgetJobCode.SourceName) +1, 8) = ''Property'')
			THEN
				RTRIM(#BudgetJobCode.OriginatingRegionCode) + LTRIM(#BudgetJobCode.FunctionalDepartmentCode) 
			ELSE
				#BudgetJobCode.OriginatingRegionCode 
		END,
		ISNULL (#BudgetJobCode.GlAccountCode, ''''),
		ISNULL (#BudgetJobCode.GlAccountName, '''')

END
				
/* ===============================================================================================================================================
	STEP 9: Get Final Results
   ============================================================================================================================================= */
BEGIN 

	SELECT
		AllocationRegionName,
		AllocationSubRegionName,
		OriginatingRegionName,
		OriginatingSubRegionName,
		FunctionalDepartmentName,
		JobCode,
		FinancialCategoryName,
		MajorExpenseCategoryName,
		MinorExpenseCategoryName,
		EntityType,
		EntityName,
		ExpensePeriod,
		EntryDate,
		[User],
		[Description],
		AdditionalDescription,
		SourceName,
		PropertyFundCode,
		OriginatingRegionCode,
		GlAccountCode,
		GlAccountName,
		MtdActual,
		MtdOriginalBudget,
		MtdReforecast,
		MtdVariance,
		
		YtdActual,	
		YtdOriginalBudget,
		YtdReforecast,
		YtdVariance,
		AnnualOriginalBudget,
		AnnualReforecast
	FROM 
		#Output
	WHERE  
		MtdActual <> 0.00 OR
		MtdOriginalBudget <> 0.00 OR
		MtdReforecast <> 0.00 OR
		MtdVariance <> 0.00 OR
		
		YtdActual <> 0.00 OR
		YtdOriginalBudget <> 0.00 OR
		YtdReforecast <> 0.00 OR
		YtdVariance <> 0.00 OR

		AnnualOriginalBudget <> 0.00 OR
		AnnualReforecast <> 0.00 
	
END

END


' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_S_UnknownSummaryMRIActualsLocal]    Script Date: 03/08/2012 12:51:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_S_UnknownSummaryMRIActualsLocal]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [dbo].[stp_S_UnknownSummaryMRIActualsLocal]
	@DataPriorToDate DateTime,
	@StartPeriod varchar(6),
	@EndPeriod varchar(6),
	@BudgetAllocationSetId int,
	@GBSAccounts bit = 0,
	@Sources varchar(max)
AS

/*********************************************************************************************************************
Description
	This validation report validates the profitability actuals for a specific period. The report is given to 
	Tishman Speyer, and they modify the data on their end to try and resolve the unknowns. There are two departments 
	that can handle this:

	2. Corporate Finance: They go into GDM and AM and modify mapping data to include the transaction setup.
	
	The report validates the following Corporate Finance (CDT Mapping) issues:
	
	2. Unknown GL Account
	3. Unknown Categorization Hierarchy 
		NOTE: This is due to two scenarios. First, GL Account unknown. Second, GL Account known, but rest of hierarchy
			  unknown, not mapped to global account in GDM.
	4. Unknown Property Fund
	
	Report Sections:
	
		STEP 1: GET ALL THE UNKNOWNS
		STEP 2.5: REMOVE ALL INFLOW Transactions
		STEP 8: Get Property Header GL Account Sum
		STEP 9: Get Corporate Header GL Account Sum
		STEP 10: GET FINAL RESULTS - GBS Only Version
		STEP 11: GET FINAL RESULTS - All Version													

History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
			2011-11-15		: SNothling	:	CC21 - Rewrite script to incorporate new hierarchy logic replacing 
											translation types etc. Please see CC21 Functional Specification for 
											further details.
**********************************************************************************************************************/

	/* ================================================================================================================
		STEP 0: GET THE SOURCE FILTER	
	=================================================================================================================*/

	CREATE TABLE #SourceFilter
	(
		SourceCode VARCHAR(2)
	)
	
	IF @Sources LIKE ''%All%''
	BEGIN
		INSERT INTO #SourceFilter
		SELECT
			SourceCode
		FROM 
			Source
	END
	ELSE BEGIN
		INSERT INTO #SourceFilter
		SELECT
		*
		FROM 
			dbo.Split(@Sources) Sources
	END

	/* ================================================================================================================
		STEP 1: GET ALL THE UNKNOWNS
		
		-- Comments (SMN):
		-- 1. An unknown in either GLFinancialCategory, GLMajorCategory or GLMinorCategory will
		--    cause the categorization hierarchy to default to unknown, hence we only have to validate one 
		--    of these.
	=================================================================================================================*/

	BEGIN 
	
	CREATE TABLE #ValidationSummary
	(
		SourceCode CHAR(2) NOT NULL,
		ProfitabilityActualKey INT NOT NULL,
		ReferenceCode VARCHAR(100) NOT NULL,
		HasUnknownGLAccount BIT NULL,
		HasUnknownCategorizationHierarchy BIT NULL,
		HasUnknownGlobalCategorizationHierarchy BIT NULL
	)
	
	-- Get all MRI sourced actuals with unknowns
	INSERT INTO #ValidationSummary
	SELECT 
		[Source].SourceCode AS ''SourceCode'',
		ProfitabilityActual.ProfitabilityActualKey AS ''ProfitabilityActualKey'',
		ProfitabilityActual.ReferenceCode AS ''ReferenceCode'',
		CASE
			WHEN ReportingHierarchy.GLAccountCode LIKE ''%UNKNOWN%'' THEN 1
			ELSE 0
		END AS ''HasUnknownGLAccount'',
		CASE
			WHEN ReportingHierarchy.GLMinorCategoryName LIKE ''%UNKNOWN%'' THEN 1
			ELSE 0
		END AS ''HasUnknownCategorizationHierarchy'',
		CASE
			WHEN GlobalGLHierarchy.GLMinorCategoryName LIKE ''%UNKNOWN%'' THEN 1
			ELSE 0
		END AS ''HasUnknownGlobalCategorizationHierarchy''
	FROM 
		dbo.ProfitabilityActual
		INNER JOIN dbo.Calendar ON
			ProfitabilityActual.CalendarKey = Calendar.CalendarKey
		INNER JOIN dbo.GLCategorizationHierarchy ReportingHierarchy ON
			ProfitabilityActual.ReportingGLCategorizationHierarchyKey = ReportingHierarchy.GLCategorizationHierarchyKey
		INNER JOIN dbo.GLCategorizationHierarchy GlobalGLHierarchy ON
			ProfitabilityActual.GlobalGLCategorizationHierarchyKey = GlobalGLHierarchy.GLCategorizationHierarchyKey
		INNER JOIN dbo.[Source] ON
			ProfitabilityActual.SourceKey = [Source].SourceKey
		INNER JOIN #SourceFilter ON
			Source.SourceCode = #SourceFilter.SourceCode
	WHERE
		Calendar.CalendarPeriod BETWEEN @StartPeriod AND @EndPeriod AND
		-- BillingUploadDetails indicate import from TAPAS, we want MRI only
		ProfitabilityActual.ReferenceCode NOT LIKE ''%BillingUploadDetailId%'' AND
		(
			ReportingHierarchy.GLAccountCode LIKE ''%UNKNOWN%'' OR
			ReportingHierarchy.GLMinorCategoryName LIKE ''%UNKNOWN%''
		) AND
		GlobalGLHierarchy.GLAccountCode NOT LIKE ''%UNKNOWN%'' AND
		GlobalGLHierarchy.GLMinorCategoryName NOT LIKE ''%UNKNOWN%''

		
	END
	
	/* ================================================================================================================
		STEP 2: Get all the original MRI actuals transactions from GrReportingStaging
		
		NOTE: We are going to use these to determine whether records have been reconciled with a re-class. Re-class items 
		still come up as unknowns, but they have duplicate records with identical but amount*-1.0 values so that they 
		balance out to 0.00
	=================================================================================================================*/
		
		BEGIN
	
	------------------------------------------------------------------------------------------------------		
	-- Create temp table
	------------------------------------------------------------------------------------------------------		

	CREATE TABLE #GeneralLedger
	(
		Period NVARCHAR(6),
		Item INT,
		Ref NVARCHAR(8),
		SiteId NVARCHAR(2),
		EntityId NVARCHAR(7),
		EntityName NVARCHAR(100),
		GlAccountCode NVARCHAR(14),
		GlAccountName NVARCHAR(70),
		DepartmentCode NVARCHAR(8),
		DepartmentDescription NVARCHAR(MAX),
		JobCode NVARCHAR(15),
		JobCodeDescription NVARCHAR(50),
		Amount MONEY,
		[Description] NVARCHAR(60),
		EnterDate DATETIME,
		Reversal NVARCHAR(1),
		Status NVARCHAR(1),
		Basis NVARCHAR(1),
		[UserId] NVARCHAR(20),
		CorporateDepartmentCode NVARCHAR(6),
		SourceCode NVARCHAR(2),
		SourcePrimaryKey NVARCHAR(62),
		[Source] NVARCHAR(2)
	)

	

	/* ================================================================================================================
		US
	=================================================================================================================*/
	
	-- US Prop
	IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = ''US''
	)
	BEGIN
		PRINT ''US''
		INSERT INTO #GeneralLedger
		SELECT
				GeneralLedger.Period,
				GeneralLedger.Item,
				GeneralLedger.Ref,
				GeneralLedger.SiteId,
				SourceEntity.EntityId,
				SourceEntity.Name AS ''EntityName'',
				GeneralLedger.GlAccountCode,
				SourceGlobalAccount.AcctName AS ''GlAccountName'',
				SourceDepartment.DepartmentCode,
				SourceDepartment.[Description] AS ''DepartmentDescription'',
				SourceJobCode.JobCode,
				SourceJobCode.[Description] AS ''JobCodeDescription'',
				GeneralLedger.Amount,
				GeneralLedger.[Description],
				GeneralLedger.EnterDate,
				GeneralLedger.Reversal,
				GeneralLedger.Status,
				GeneralLedger.Basis,
				GeneralLedger.[UserId],
				GeneralLedger.CorporateDepartmentCode,
				GeneralLedger.SourceCode,
				GeneralLedger.SourcePrimaryKey,
				GeneralLedger.[Source]
			FROM 
				GrReportingStaging.USProp.GeneralLedger GeneralLedger
				INNER JOIN (
					--This allows JOURNAL&GHIS to each have a record with the same PK,
					--but that is incorrect data and as such GR will pick GHIS as the 
					--more accurate data, for it is posted data, WHERE journal data is still open data
					SELECT 
						SourcePrimaryKey,
						MAX(SourceTableId) SourceTableId
					FROM
						GrReportingStaging.USProp.GeneralLedger Gl
					GROUP BY 
						SourcePrimaryKey
				) SourceGeneralLedger ON
					GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
					GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId
				
				--INNER JOIN #SourceFilter ON
				--	GeneralLedger.[Source] = #SourceFilter.SourceCode
					
				-- US Prop entity = propertyfund
				LEFT OUTER JOIN (
					SELECT
						Entity.*
					FROM 
						GrReportingStaging.USProp.Entity Entity
					INNER JOIN GrReportingStaging.USProp.EntityActive(@DataPriorToDate) ActiveEntity ON
						Entity.ImportKey = ActiveEntity.ImportKey
				) SourceEntity ON
					GeneralLedger.PropertyFundCode = SourceEntity.EntityId
				
				-- US Prop Department = Region + Functional Department OR Investors	
				LEFT OUTER JOIN (
					SELECT
						Department.*
					FROM 
						GrReportingStaging.gdm.Department Department 
					INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
						Department.ImportKey = ActiveDepartment.ImportKey 			
				) SourceDepartment ON
					GeneralLedger.SourceCode = SourceDepartment.[Source] AND
					GeneralLedger.RegionCode + GeneralLedger.FunctionalDepartmentCode = SourceDepartment.DepartmentCode
				
				-- US Prop GLAccount = Expense Type + Activity
				LEFT OUTER JOIN (
					SELECT
						GlobalAccount.*
					FROM
						GrReportingStaging.USProp.GACC GlobalAccount
					INNER JOIN GrReportingStaging.USProp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
						GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
				) SourceGlobalAccount ON
					GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
				
				-- US Prop Job Code = Tenant & Capital Improvements (Property Only)
				LEFT OUTER JOIN (
					SELECT
						JobCode.*
					FROM 
						GrReportingStaging.GACS.JobCode JobCode 
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
						JobCode.ImportKey = ActiveJobCode.ImportKey			
				) SourceJobCode ON
					GeneralLedger.SourceCode = SourceJobCode.[Source] AND 
					GeneralLedger.JobCode = SourceJobCode.JobCode
				
			WHERE
				GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod AND
				-- We do not import records with a corporate department code, because the transaction will
				-- come up as a corp transaction anyway, otherwise we count it twice
				(
					CorporateDepartmentCode IS NULL OR
					CorporateDepartmentCode = ''N''
				)
	END
					
	-- US Corp
	IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = ''UC''
	)
	BEGIN
		PRINT ''UC''
		INSERT INTO #GeneralLedger
			SELECT
				GeneralLedger.Period,
				GeneralLedger.Item,
				GeneralLedger.Ref,
				GeneralLedger.SiteId,
				SourceEntity.EntityId,
				SourceEntity.Name AS ''EntityName'',
				GeneralLedger.GlAccountCode,
				SourceGlobalAccount.AcctName AS ''GlAccountName'',
				SourceDepartment.DepartmentCode,
				SourceDepartment.[Description] AS ''DepartmentDescription'',
				SourceJobCode.JobCode,
				SourceJobCode.[Description] AS ''JobCodeDescription'',
				GeneralLedger.Amount,
				GeneralLedger.[Description],
				GeneralLedger.EnterDate,
				GeneralLedger.Reversal,
				GeneralLedger.Status,
				GeneralLedger.Basis,
				GeneralLedger.[UserId],
				GeneralLedger.CorporateDepartmentCode,
				GeneralLedger.SourceCode,
				GeneralLedger.SourcePrimaryKey,
				GeneralLedger.[Source]
			FROM 
				GrReportingStaging.USCorp.GeneralLedger GeneralLedger
				INNER JOIN (
					--This allows JOURNAL&GHIS to each have a record with the same PK,
					--but that is incorrect data and as such GR will pick GHIS as the 
					--more accurate data, for it is posted data, WHERE journal data is still open data
					SELECT 
						SourcePrimaryKey,
						MAX(SourceTableId) SourceTableId
					FROM
						GrReportingStaging.USCorp.GeneralLedger Gl
					GROUP BY 
						SourcePrimaryKey
				) SourceGeneralLedger ON
					GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
					GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId
				
				-- US Corp Entity = Region Code 
				LEFT OUTER JOIN (
					SELECT
						Entity.*
					FROM 
						GrReportingStaging.USCorp.Entity Entity
					INNER JOIN GrReportingStaging.USCorp.EntityActive(@DataPriorToDate) ActiveEntity ON
						Entity.ImportKey = ActiveEntity.ImportKey
				) SourceEntity ON
					GeneralLedger.RegionCode = SourceEntity.EntityId
					
				-- US Corp Department = PropertyFund
				LEFT OUTER JOIN (
					SELECT
						Department.*
					FROM 
						GrReportingStaging.gdm.Department Department 
					INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
						Department.ImportKey = ActiveDepartment.ImportKey 			
				) SourceDepartment ON
					GeneralLedger.SourceCode = SourceDepartment.[Source] AND
					GeneralLedger.PropertyFundCode = SourceDepartment.DepartmentCode
				
				-- US Prop GLAccount = Expense Type + Activity
				LEFT OUTER JOIN (
					SELECT
						GlobalAccount.*
					FROM
						GrReportingStaging.USCorp.GACC GlobalAccount
					INNER JOIN GrReportingStaging.USCorp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
						GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
				) SourceGlobalAccount ON
					GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
				
				-- US Corp Job Code = Functional Department OR IT Costs
				LEFT OUTER JOIN (
					SELECT
						JobCode.*
					FROM 
						GrReportingStaging.GACS.JobCode JobCode 
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
						JobCode.ImportKey = ActiveJobCode.ImportKey			
				) SourceJobCode ON
					GeneralLedger.SourceCode = SourceJobCode.[Source] AND 
					GeneralLedger.JobCode = SourceJobCode.JobCode
					
			WHERE
				GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod			
	END
				
	/* ================================================================================================================
		EU
	=================================================================================================================*/
	
	-- EU Prop
		IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = ''EU''
	)
	BEGIN
		PRINT ''EU''
		INSERT INTO #GeneralLedger
		SELECT
			GeneralLedger.Period,
			GeneralLedger.Item,
			GeneralLedger.Ref,
			GeneralLedger.SiteId,
			SourceEntity.EntityId,
			SourceEntity.Name AS ''EntityName'',
			GeneralLedger.GlAccountCode,
			SourceGlobalAccount.AcctName AS ''GlAccountName'',
			SourceDepartment.DepartmentCode,
			SourceDepartment.[Description] AS ''DepartmentDescription'',
			SourceJobCode.JobCode,
			SourceJobCode.[Description] AS ''JobCodeDescription'',
			GeneralLedger.Amount,
			GeneralLedger.[Description],
			GeneralLedger.EnterDate,
			GeneralLedger.Reversal,
			GeneralLedger.Status,
			GeneralLedger.Basis,
			GeneralLedger.[UserId],
			GeneralLedger.CorporateDepartmentCode,
			GeneralLedger.SourceCode,
			GeneralLedger.SourcePrimaryKey,
			GeneralLedger.[Source]
		FROM 
			GrReportingStaging.EUProp.GeneralLedger GeneralLedger
			INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, WHERE journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.EUProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
			) SourceGeneralLedger ON
				GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
				GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId
				
			-- EU Prop Entity = propertyFund
			LEFT OUTER JOIN (
				SELECT
					Entity.*
				FROM 
					GrReportingStaging.EUProp.Entity Entity
				INNER JOIN GrReportingStaging.EUProp.EntityActive(@DataPriorToDate) ActiveEntity ON
					Entity.ImportKey = ActiveEntity.ImportKey
			) SourceEntity ON
				GeneralLedger.PropertyFundCode = SourceEntity.EntityId
				
			LEFT OUTER JOIN (
				SELECT
					Department.*
				FROM 
					GrReportingStaging.gdm.Department Department 
				INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
					Department.ImportKey = ActiveDepartment.ImportKey 			
			) SourceDepartment ON
				GeneralLedger.SourceCode = SourceDepartment.[Source] AND
				GeneralLedger.RegionCode + GeneralLedger.FunctionalDepartmentCode = SourceDepartment.DepartmentCode
			
			LEFT OUTER JOIN (
				SELECT
					GlobalAccount.*
				FROM
					GrReportingStaging.EUProp.GACC GlobalAccount
				INNER JOIN GrReportingStaging.EUProp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
					GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
			) SourceGlobalAccount ON
				GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
			
			LEFT OUTER JOIN (
				SELECT
					JobCode.*
				FROM 
					GrReportingStaging.GACS.JobCode JobCode 
				INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
					JobCode.ImportKey = ActiveJobCode.ImportKey			
			) SourceJobCode ON
				GeneralLedger.SourceCode = SourceJobCode.[Source] AND 
				GeneralLedger.JobCode = SourceJobCode.JobCode
				
		WHERE
			GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod AND	
			-- We do not import records with a corporate department code, because the transaction will
			-- come up as a corp transaction anyway, otherwise we count it twice
			(
				CorporateDepartmentCode IS NULL OR
				CorporateDepartmentCode = ''N''
			)
	END	 
	
	-- EU Corp
	IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = ''EC''
	)
	BEGIN
		PRINT ''EC''
		INSERT INTO #GeneralLedger
		SELECT
			GeneralLedger.Period,
			GeneralLedger.Item,
			GeneralLedger.Ref,
			GeneralLedger.SiteId,
			SourceEntity.EntityId,
			SourceEntity.Name AS ''EntityName'',
			GeneralLedger.GlAccountCode,
			SourceGlobalAccount.AcctName AS ''GlAccountName'',
			SourceDepartment.DepartmentCode,
			SourceDepartment.[Description] AS ''DepartmentDescription'',
			SourceJobCode.JobCode,
			SourceJobCode.[Description] AS ''JobCodeDescription'',
			GeneralLedger.Amount,
			GeneralLedger.[Description],
			GeneralLedger.EnterDate,
			GeneralLedger.Reversal,
			GeneralLedger.Status,
			GeneralLedger.Basis,
			GeneralLedger.[UserId],
			GeneralLedger.CorporateDepartmentCode,
			GeneralLedger.SourceCode,
			GeneralLedger.SourcePrimaryKey,
			GeneralLedger.[Source]
		FROM 
			GrReportingStaging.EUCorp.GeneralLedger GeneralLedger
			INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, WHERE journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.EUCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
			) SourceGeneralLedger ON
				GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
				GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId
			
			-- EU Corp Entity = Region Code 	
			LEFT OUTER JOIN (
				SELECT
					Entity.*
				FROM 
					GrReportingStaging.EUCorp.Entity Entity
				INNER JOIN GrReportingStaging.EUCorp.EntityActive(@DataPriorToDate) ActiveEntity ON
					Entity.ImportKey = ActiveEntity.ImportKey
			) SourceEntity ON
				GeneralLedger.RegionCode = SourceEntity.EntityId
				
			LEFT OUTER JOIN (
				SELECT
					Department.*
				FROM 
					GrReportingStaging.gdm.Department Department 
				INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
					Department.ImportKey = ActiveDepartment.ImportKey 			
			) SourceDepartment ON
				GeneralLedger.SourceCode = SourceDepartment.[Source] AND
				GeneralLedger.PropertyFundCode = SourceDepartment.DepartmentCode
			
			LEFT OUTER JOIN (
				SELECT
					GlobalAccount.*
				FROM
					GrReportingStaging.EUCorp.GACC GlobalAccount
				INNER JOIN GrReportingStaging.EUCorp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
					GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
			) SourceGlobalAccount ON
				GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
			
			LEFT OUTER JOIN (
				SELECT
					JobCode.*
				FROM 
					GrReportingStaging.GACS.JobCode JobCode 
				INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
					JobCode.ImportKey = ActiveJobCode.ImportKey			
			) SourceJobCode ON
				GeneralLedger.SourceCode = SourceJobCode.[Source] AND GeneralLedger.JobCode = SourceJobCode.JobCode
				
		WHERE
			GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod
	END	
		
	/* ================================================================================================================
		BR
	=================================================================================================================*/
	
	-- BR Prop
	IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = ''BR''
	)
	BEGIN
		INSERT INTO #GeneralLedger
		SELECT
			GeneralLedger.Period,
			GeneralLedger.Item,
			GeneralLedger.Ref,
			GeneralLedger.SiteId,
			SourceEntity.EntityId,
			SourceEntity.Name AS ''EntityName'',
			GeneralLedger.GlAccountCode,
			SourceGlobalAccount.AcctName AS ''GlAccountName'',
			SourceDepartment.DepartmentCode,
			SourceDepartment.[Description] AS ''DepartmentDescription'',
			SourceJobCode.JobCode,
			SourceJobCode.[Description] AS ''JobCodeDescription'',
			GeneralLedger.Amount,
			GeneralLedger.[Description],
			GeneralLedger.EnterDate,
			GeneralLedger.Reversal,
			GeneralLedger.Status,
			GeneralLedger.Basis,
			GeneralLedger.[UserId],
			GeneralLedger.CorporateDepartmentCode,
			GeneralLedger.SourceCode,
			GeneralLedger.SourcePrimaryKey,
			GeneralLedger.[Source]
		FROM 
			GrReportingStaging.BRProp.GeneralLedger GeneralLedger
			INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, WHERE journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.BRProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
			) SourceGeneralLedger ON
				GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
				GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId
				
			LEFT OUTER JOIN (
				SELECT
					Entity.*
				FROM 
					GrReportingStaging.BRProp.Entity Entity
				INNER JOIN GrReportingStaging.BRProp.EntityActive(@DataPriorToDate) ActiveEntity ON
					Entity.ImportKey = ActiveEntity.ImportKey
			) SourceEntity ON
				GeneralLedger.PropertyFundCode = SourceEntity.EntityId
				
			LEFT OUTER JOIN (
				SELECT
					Department.*
				FROM 
					GrReportingStaging.gdm.Department Department 
				INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
					Department.ImportKey = ActiveDepartment.ImportKey 			
			) SourceDepartment ON
				GeneralLedger.SourceCode = SourceDepartment.[Source] AND
				GeneralLedger.RegionCode + GeneralLedger.FunctionalDepartmentCode = SourceDepartment.DepartmentCode
			
			LEFT OUTER JOIN (
				SELECT
					GlobalAccount.*
				FROM
					GrReportingStaging.BRProp.GACC GlobalAccount
				INNER JOIN GrReportingStaging.BRProp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
					GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
			) SourceGlobalAccount ON
				GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
			
			LEFT OUTER JOIN (
				SELECT
					JobCode.*
				FROM 
					GrReportingStaging.GACS.JobCode JobCode 
				INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
					JobCode.ImportKey = ActiveJobCode.ImportKey			
			) SourceJobCode ON
				GeneralLedger.SourceCode = SourceJobCode.[Source] AND GeneralLedger.JobCode = SourceJobCode.JobCode
			
		WHERE
			GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod AND	
			-- We do not import records with a corporate department code, because the transaction will
			-- come up as a corp transaction anyway, otherwise we count it twice
			(
				CorporateDepartmentCode IS NULL OR
				CorporateDepartmentCode = ''N''
			)	
	END
				
	-- BR Corp
	IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = ''BC''
	)
	BEGIN
		INSERT INTO #GeneralLedger
		SELECT
			GeneralLedger.Period,
			GeneralLedger.Item,
			GeneralLedger.Ref,
			GeneralLedger.SiteId,
			SourceEntity.EntityId,
			SourceEntity.Name AS ''EntityName'',
			GeneralLedger.GlAccountCode,
			SourceGlobalAccount.AcctName AS ''GlAccountName'',
			SourceDepartment.DepartmentCode,
			SourceDepartment.[Description] AS ''DepartmentDescription'',
			SourceJobCode.JobCode,
			SourceJobCode.[Description] AS ''JobCodeDescription'',
			GeneralLedger.Amount,
			GeneralLedger.[Description],
			GeneralLedger.EnterDate,
			GeneralLedger.Reversal,
			GeneralLedger.Status,
			GeneralLedger.Basis,
			GeneralLedger.[UserId],
			GeneralLedger.CorporateDepartmentCode,
			GeneralLedger.SourceCode,
			GeneralLedger.SourcePrimaryKey,
			GeneralLedger.[Source]
		FROM 
			GrReportingStaging.BRCorp.GeneralLedger GeneralLedger
			INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, WHERE journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.BRCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
			) SourceGeneralLedger ON
				GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
				GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId

			-- BR Corp Entity = Region Code 
			LEFT OUTER JOIN (
				SELECT
					Entity.*
				FROM 
					GrReportingStaging.BRCorp.Entity Entity
				INNER JOIN GrReportingStaging.BRCorp.EntityActive(@DataPriorToDate) ActiveEntity ON
					Entity.ImportKey = ActiveEntity.ImportKey
			) SourceEntity ON
				GeneralLedger.RegionCode = SourceEntity.EntityId
				
			LEFT OUTER JOIN (
				SELECT
					Department.*
				FROM 
					GrReportingStaging.gdm.Department Department 
				INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
					Department.ImportKey = ActiveDepartment.ImportKey 			
			) SourceDepartment ON
				GeneralLedger.SourceCode = SourceDepartment.[Source] AND
				GeneralLedger.PropertyFundCode = SourceDepartment.DepartmentCode
			
			LEFT OUTER JOIN (
				SELECT
					GlobalAccount.*
				FROM
					GrReportingStaging.BRCorp.GACC GlobalAccount
				INNER JOIN GrReportingStaging.BRCorp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
					GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
			) SourceGlobalAccount ON
				GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
			
			LEFT OUTER JOIN (
				SELECT
					JobCode.*
				FROM 
					GrReportingStaging.GACS.JobCode JobCode 
				INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
					JobCode.ImportKey = ActiveJobCode.ImportKey			
			) SourceJobCode ON
				GeneralLedger.SourceCode = SourceJobCode.[Source] AND GeneralLedger.JobCode = SourceJobCode.JobCode
			
		WHERE
			GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod		
	END
			
	/* ================================================================================================================
		IN
	=================================================================================================================*/

	-- IN Prop
	IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = ''IN''
	)
	BEGIN
		INSERT INTO #GeneralLedger
		SELECT
			GeneralLedger.Period,
			GeneralLedger.Item,
			GeneralLedger.Ref,
			GeneralLedger.SiteId,
			SourceEntity.EntityId,
			SourceEntity.Name AS ''EntityName'',
			GeneralLedger.GlAccountCode,
			SourceGlobalAccount.AcctName AS ''GlAccountName'',
			SourceDepartment.DepartmentCode,
			SourceDepartment.[Description] AS ''DepartmentDescription'',
			SourceJobCode.JobCode,
			SourceJobCode.[Description] AS ''JobCodeDescription'',
			GeneralLedger.Amount,
			GeneralLedger.[Description],
			GeneralLedger.EnterDate,
			GeneralLedger.Reversal,
			GeneralLedger.Status,
			GeneralLedger.Basis,
			GeneralLedger.[UserId],
			GeneralLedger.CorporateDepartmentCode,
			GeneralLedger.SourceCode,
			GeneralLedger.SourcePrimaryKey,
			GeneralLedger.[Source]
		FROM 
			GrReportingStaging.INProp.GeneralLedger GeneralLedger
			INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, WHERE journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.INProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
			) SourceGeneralLedger ON
				GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
				GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId
				
			LEFT OUTER JOIN (
				SELECT
					Entity.*
				FROM 
					GrReportingStaging.INProp.Entity Entity
				INNER JOIN GrReportingStaging.INProp.EntityActive(@DataPriorToDate) ActiveEntity ON
					Entity.ImportKey = ActiveEntity.ImportKey
			) SourceEntity ON
				GeneralLedger.PropertyFundCode = SourceEntity.EntityId
				
			LEFT OUTER JOIN (
				SELECT
					Department.*
				FROM 
					GrReportingStaging.gdm.Department Department 
				INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
					Department.ImportKey = ActiveDepartment.ImportKey 			
			) SourceDepartment ON
				GeneralLedger.SourceCode = SourceDepartment.[Source] AND
				GeneralLedger.RegionCode + GeneralLedger.FunctionalDepartmentCode = SourceDepartment.DepartmentCode
			
			LEFT OUTER JOIN (
				SELECT
					GlobalAccount.*
				FROM
					GrReportingStaging.INProp.GACC GlobalAccount
				INNER JOIN GrReportingStaging.INProp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
					GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
			) SourceGlobalAccount ON
				GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
			
			LEFT OUTER JOIN (
				SELECT
					JobCode.*
				FROM 
					GrReportingStaging.GACS.JobCode JobCode 
				INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
					JobCode.ImportKey = ActiveJobCode.ImportKey			
			) SourceJobCode ON
				GeneralLedger.SourceCode = SourceJobCode.[Source] AND GeneralLedger.JobCode = SourceJobCode.JobCode
			
		WHERE
			GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod AND	
			-- We do not import records with a corporate department code, because the transaction will
			-- come up as a corp transaction anyway, otherwise we count it twice
			(
				CorporateDepartmentCode IS NULL OR
				CorporateDepartmentCode = ''N''
			)
	END
	
	-- IN Corp
	IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = ''IC''
	)
	BEGIN
		INSERT INTO #GeneralLedger
		SELECT
			GeneralLedger.Period,
			GeneralLedger.Item,
			GeneralLedger.Ref,
			GeneralLedger.SiteId,
			SourceEntity.EntityId,
			SourceEntity.Name AS ''EntityName'',
			GeneralLedger.GlAccountCode,
			SourceGlobalAccount.AcctName AS ''GlAccountName'',
			SourceDepartment.DepartmentCode,
			SourceDepartment.[Description] AS ''DepartmentDescription'',
			SourceJobCode.JobCode,
			SourceJobCode.[Description] AS ''JobCodeDescription'',
			GeneralLedger.Amount,
			GeneralLedger.[Description],
			GeneralLedger.EnterDate,
			GeneralLedger.Reversal,
			GeneralLedger.Status,
			GeneralLedger.Basis,
			GeneralLedger.[UserId],
			GeneralLedger.CorporateDepartmentCode,
			GeneralLedger.SourceCode,
			GeneralLedger.SourcePrimaryKey,
			GeneralLedger.[Source]
		FROM 
			GrReportingStaging.INCorp.GeneralLedger GeneralLedger
			INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, WHERE journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.INCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
			) SourceGeneralLedger ON
				GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
				GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId
				
			-- IN Corp Entity = Region Code 
			LEFT OUTER JOIN (
				SELECT
					Entity.*
				FROM 
					GrReportingStaging.INCorp.Entity Entity
				INNER JOIN GrReportingStaging.INCorp.EntityActive(@DataPriorToDate) ActiveEntity ON
					Entity.ImportKey = ActiveEntity.ImportKey
			) SourceEntity ON
				GeneralLedger.RegionCode = SourceEntity.EntityId
				
			LEFT OUTER JOIN (
				SELECT
					Department.*
				FROM 
					GrReportingStaging.gdm.Department Department 
				INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
					Department.ImportKey = ActiveDepartment.ImportKey 			
			) SourceDepartment ON
				GeneralLedger.SourceCode = SourceDepartment.[Source] AND
				GeneralLedger.PropertyFundCode = SourceDepartment.DepartmentCode
			
			LEFT OUTER JOIN (
				SELECT
					GlobalAccount.*
				FROM
					GrReportingStaging.INCorp.GACC GlobalAccount
				INNER JOIN GrReportingStaging.INCorp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
					GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
			) SourceGlobalAccount ON
				GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
			
			LEFT OUTER JOIN (
				SELECT
					JobCode.*
				FROM 
					GrReportingStaging.GACS.JobCode JobCode 
				INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
					JobCode.ImportKey = ActiveJobCode.ImportKey			
			) SourceJobCode ON
				GeneralLedger.SourceCode = SourceJobCode.[Source] AND GeneralLedger.JobCode = SourceJobCode.JobCode
			
		WHERE
			GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod	
	END
	/* ================================================================================================================
		CN
	=================================================================================================================*/
	
	-- CN Prop
	IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = ''CN''
	)
	BEGIN
		INSERT INTO #GeneralLedger
		SELECT
			GeneralLedger.Period,
			GeneralLedger.Item,
			GeneralLedger.Ref,
			GeneralLedger.SiteId,
			SourceEntity.EntityId,
			SourceEntity.Name AS ''EntityName'',
			GeneralLedger.GlAccountCode,
			SourceGlobalAccount.AcctName AS ''GlAccountName'',
			SourceDepartment.DepartmentCode,
			SourceDepartment.[Description] AS ''DepartmentDescription'',
			SourceJobCode.JobCode,
			SourceJobCode.[Description] AS ''JobCodeDescription'',
			GeneralLedger.Amount,
			GeneralLedger.[Description],
			GeneralLedger.EnterDate,
			GeneralLedger.Reversal,
			GeneralLedger.Status,
			GeneralLedger.Basis,
			GeneralLedger.[UserId],
			GeneralLedger.CorporateDepartmentCode,
			GeneralLedger.SourceCode,
			GeneralLedger.SourcePrimaryKey,
			GeneralLedger.[Source]
		FROM 
			GrReportingStaging.CNProp.GeneralLedger GeneralLedger
			INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, WHERE journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.CNProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
			) SourceGeneralLedger ON
				GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
				GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId
				
			LEFT OUTER JOIN (
				SELECT
					Entity.*
				FROM 
					GrReportingStaging.CNProp.Entity Entity
				INNER JOIN GrReportingStaging.CNProp.EntityActive(@DataPriorToDate) ActiveEntity ON
					Entity.ImportKey = ActiveEntity.ImportKey
			) SourceEntity ON
				GeneralLedger.PropertyFundCode = SourceEntity.EntityId
				
			LEFT OUTER JOIN (
				SELECT
					Department.*
				FROM 
					GrReportingStaging.gdm.Department Department 
				INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
					Department.ImportKey = ActiveDepartment.ImportKey 			
			) SourceDepartment ON
				GeneralLedger.SourceCode = SourceDepartment.[Source] AND
				GeneralLedger.RegionCode + GeneralLedger.FunctionalDepartmentCode = SourceDepartment.DepartmentCode
			
			LEFT OUTER JOIN (
				SELECT
					GlobalAccount.*
				FROM
					GrReportingStaging.CNProp.GACC GlobalAccount
				INNER JOIN GrReportingStaging.CNProp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
					GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
			) SourceGlobalAccount ON
				GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
			
			LEFT OUTER JOIN (
				SELECT
					JobCode.*
				FROM 
					GrReportingStaging.GACS.JobCode JobCode 
				INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
					JobCode.ImportKey = ActiveJobCode.ImportKey			
			) SourceJobCode ON
				GeneralLedger.SourceCode = SourceJobCode.[Source] AND GeneralLedger.JobCode = SourceJobCode.JobCode
				
		WHERE
			GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod AND	
			-- We do not import records with a corporate department code, because the transaction will
			-- come up as a corp transaction anyway, otherwise we count it twice
			(
				CorporateDepartmentCode IS NULL OR
				CorporateDepartmentCode = ''N''
			)
	END
				
	-- CN Corp
	IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = ''CC''
	)
	BEGIN
		INSERT INTO #GeneralLedger
		SELECT
			GeneralLedger.Period,
			GeneralLedger.Item,
			GeneralLedger.Ref,
			GeneralLedger.SiteId,
			SourceEntity.EntityId,
			SourceEntity.Name AS ''EntityName'',
			GeneralLedger.GlAccountCode,
			SourceGlobalAccount.AcctName AS ''GlAccountName'',
			SourceDepartment.DepartmentCode,
			SourceDepartment.[Description] AS ''DepartmentDescription'',
			SourceJobCode.JobCode,
			SourceJobCode.[Description] AS ''JobCodeDescription'',
			GeneralLedger.Amount,
			GeneralLedger.[Description],
			GeneralLedger.EnterDate,
			GeneralLedger.Reversal,
			GeneralLedger.Status,
			GeneralLedger.Basis,
			GeneralLedger.[UserId],
			GeneralLedger.CorporateDepartmentCode,
			GeneralLedger.SourceCode,
			GeneralLedger.SourcePrimaryKey,
			GeneralLedger.[Source]
		FROM 
			GrReportingStaging.CNCorp.GeneralLedger GeneralLedger
			INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, WHERE journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.CNCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
			) SourceGeneralLedger ON
				GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
				GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId
				
			-- CN Corp Entity = Region Code 
			LEFT OUTER JOIN (
				SELECT
					Entity.*
				FROM 
					GrReportingStaging.CNCorp.Entity Entity
				INNER JOIN GrReportingStaging.CNCorp.EntityActive(@DataPriorToDate) ActiveEntity ON
					Entity.ImportKey = ActiveEntity.ImportKey
			) SourceEntity ON
				GeneralLedger.RegionCode = SourceEntity.EntityId
				
			LEFT OUTER JOIN (
				SELECT
					Department.*
				FROM 
					GrReportingStaging.gdm.Department Department 
				INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
					Department.ImportKey = ActiveDepartment.ImportKey 			
			) SourceDepartment ON
				GeneralLedger.SourceCode = SourceDepartment.[Source] AND
				GeneralLedger.PropertyFundCode = SourceDepartment.DepartmentCode
			
			LEFT OUTER JOIN (
				SELECT
					GlobalAccount.*
				FROM
					GrReportingStaging.CNCorp.GACC GlobalAccount
				INNER JOIN GrReportingStaging.CNCorp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
					GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
			) SourceGlobalAccount ON
				GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
			
			LEFT OUTER JOIN (
				SELECT
					JobCode.*
				FROM 
					GrReportingStaging.GACS.JobCode JobCode 
				INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
					JobCode.ImportKey = ActiveJobCode.ImportKey			
			) SourceJobCode ON
				GeneralLedger.SourceCode = SourceJobCode.[Source] AND GeneralLedger.JobCode = SourceJobCode.JobCode
				
		WHERE
			GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod
	END
		
	END
	
	/* ================================================================================================================
		STEP 2.5: REMOVE ALL INFLOW Transactions
		
		Global ''Inflow'' accounts 
	=================================================================================================================*/
	
	BEGIN
	
		DELETE ValidationSummary 
		FROM 
			#ValidationSummary ValidationSummary
		INNER JOIN ProfitabilityActual ON
			ValidationSummary.ProfitabilityActualKey = ProfitabilityActual.ProfitabilityActualKey
		INNER JOIN GLCategorizationHierarchy ON 
			ProfitabilityActual.GlobalGLCategorizationHierarchyKey = GLCategorizationHierarchy.GLCategorizationHierarchyKey
		INNER JOIN #GeneralLedger GeneralLedger ON 
			ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
			ValidationSummary.SourceCode = GeneralLedger.SourceCode
		WHERE 
			GLCategorizationHierarchy.InflowOutflow = ''Inflow'' OR 
			GLCategorizationHierarchy.GLFinancialCategoryName = ''Other Expenses''
	END
			
	/* ================================================================================================================
		STEP 3: VALIDATE RECLASSED UNKNOWNS DATA
		
		This validates fixes of type 2 - see comment at top of script. We need to remove unknown transactions that have
		been fixed by a reclass. GL Account balances are calculated by GL Account and Entity in MRI, so a re-class will 
		make the GL Account Balance even out for that GL Account - Entity combination.
		
		ALGORITHM USED:
		
		Scenario: Assume the following transactions are flagged with unknown activity types
		
		GL Account Code		Entity											Amount
		EU5002300002		REGION DE                                       630.00                                
		EU5002300002		TISHMAN SPEYER REV VI ALTERNATIVE (IRE), L.P.   450.00                          
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.     640.00                                
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.     780.00                                
		EU6702290012		REGION DE										12.00                                 
		EU6702290012		REGION DE                                       12.00                                		
		
		They go and fix some of the transactions with re-classes, so now we see the following. 
		We want to exclude all the transactions with *** from the new validation report, because
		they have been fixed with a re-class. Please note that the re-classed transaction will not appear
		here, because it does not have an unknown activity type any more.	
		
		GL Account Code		Entity											Amount
		EU5002300002		REGION DE                                       630.00*****   
	    EU5002300002        REGION DE										-630.00****
		EU5002300002		TISHMAN SPEYER REV VI ALTERNATIVE (IRE), L.P.   450.00                          
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.     640.00****
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.     -640.00****                               
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.     780.00                                
		EU6702290012		REGION DE										12.00****  
	    EU6702290012		REGION DE										-12.00****                          
		EU6702290012		REGION DE                                       12.00 
		
		Step 1: Get a distinct list of gl accout code, entity, absolute value (hereafter indicated as |amount|
		Please note what happens to the EU6702290012 transactions here.
		
		GL Account Code		Entity											Amount
		EU5002300002		REGION DE                                       |630.00| 
		EU5002300002		TISHMAN SPEYER REV VI ALTERNATIVE (IRE), L.P.   |450.00|                         
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.     |640.00|                    
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.     |780.00|                              
		EU6702290012		REGION DE										|12.00|

		Step 2: join all transactions back onto this distinct list, and group by gl account code, entity and |amount|
		
		GL Account Code		Entity											Sum(Amount)		|Amount|
		EU5002300002		REGION DE										0.00			|630.00| 
		EU5002300002		TISHMAN SPEYER REV VI ALTERNATIVE (IRE), L.P.	450.00			|450.00|                         
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.		0.00			|640.00|                    
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.		780.00			|780.00|                              
		EU6702290012		REGION DE										12.00			|12.00|
		
		Step 3: return all transactions where the sum(amount) in step 2 did not balance out to 0.00. Please note that ALL
		the transactions for EU6702290012 is returned here, because we cannot distinguish which transaction is still invalid,
		and which was fixed by the re-class transaction. This algorithm is not fool proof, but it is as accurate as we can get.
		
		GL Account Code		Entity											Amount
		EU5002300002		TISHMAN SPEYER REV VI ALTERNATIVE (IRE), L.P.   450.00                          
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.     780.00                                
		EU6702290012		REGION DE										12.00****  
	    EU6702290012		REGION DE										-12.00****                          
		EU6702290012		REGION DE                                       12.00 
		
		We do this for each unknown type.

	=================================================================================================================*/
		
	/* ================================================================================================================
		GL Account Unknowns
	=================================================================================================================*/

	BEGIN
	
	---------------------------------------------------------------------------------------
	-- Remove GLAccount Unknowns from #ValidationSummary that have been re-classed 
	-- and now net out to 0
	---------------------------------------------------------------------------------------
	
	UPDATE ValidationSummary 
	SET
		HasUnknownGlAccount = 0
	FROM 
	-- Step 3: Validation Summary Record where the account balance for that glaccount, entity and |amount| balances out to 0.0
		#ValidationSummary ValidationSummary
		INNER JOIN #GeneralLedger GeneralLedger ON
			ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
			ValidationSummary.SourceCode = GeneralLedger.SourceCode
		INNER JOIN (
			-- Step 2: Get a list of unknown transaction GL Account, Entity and Amount with an account balance of 0.00 for 
			-- that |amount|
			SELECT
				IndividualAmounts.GlAccountCode,
				IndividualAmounts.EntityId,
				IndividualAmounts.Amount
			FROM 
				#ValidationSummary ValidationSummary
			INNER JOIN #GeneralLedger GeneralLedger ON
				ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
				ValidationSummary.SourceCode = GeneralLedger.SourceCode
			INNER JOIN (
				-- Step 1: Get a distinct list of glaccountcode, entityid, |Amount|
				SELECT 
					GeneralLedger.GLAccountCode,
					GeneralLedger.EntityId, 
					CASE
						WHEN GeneralLedger.Amount < 0.0 THEN GeneralLedger.Amount * -1.0
						ELSE GeneralLedger.Amount
					END AS ''Amount''
				FROM #ValidationSummary ValidationSummary
				INNER JOIN #GeneralLedger GeneralLedger ON
					ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
					ValidationSummary.SourceCode = GeneralLedger.SourceCode
				WHERE
					ValidationSummary.HasUnknownGlAccount = 1
				GROUP BY
					GeneralLedger.GlAccountCode,
					GeneralLedger.EntityId,
					CASE
						WHEN GeneralLedger.Amount < 0.0 THEN GeneralLedger.Amount * -1.0
						ELSE GeneralLedger.Amount
					END
			) IndividualAmounts ON
				GeneralLedger.GLAccountCode = IndividualAmounts.GLAccountCode AND
				GeneralLedger.EntityId = IndividualAmounts.EntityId AND
				(CASE 
					WHEN GeneralLedger.Amount < 0.0 THEN -1.0 * GeneralLedger.Amount 
					ELSE GeneralLedger.Amount 
				END) = IndividualAmounts.Amount 
			WHERE 
				ValidationSummary.HasUnknownGlAccount = 1
			GROUP BY 
				IndividualAmounts.GlAccountCode,
				IndividualAmounts.EntityId,
				IndividualAmounts.Amount
			HAVING			
				SUM(GeneralLedger.Amount) = 0.0	
		) NonReclassedTransactions ON
			GeneralLedger.GlAccountCode = NonReclassedTransactions.GLAccountCode AND
			GeneralLedger.EntityId = NonReclassedTransactions.EntityId AND
			CASE 
				WHEN GeneralLedger.Amount < 0.0 THEN -1.0 * GeneralLedger.Amount
				ELSE GeneralLedger.Amount
			END = NonReclassedTransactions.Amount
		
	END	
		
	/* ================================================================================================================
		Global Categorization Unknowns
	=================================================================================================================*/
			
	BEGIN
	
	---------------------------------------------------------------------------------------
	-- Remove Global Categorization Hierarchy Unknowns from #ValidationSummary that have been re-classed 
	-- and now net out to 0
	---------------------------------------------------------------------------------------
	
	UPDATE ValidationSummary 
	SET
		HasUnknownCategorizationHierarchy = 0
	FROM 
	-- Step 3: Validation Summary Record where the account balance for that glaccount, entity and |amount| balances out to 0.0
		#ValidationSummary ValidationSummary
		INNER JOIN #GeneralLedger GeneralLedger ON
			ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
			ValidationSummary.SourceCode = GeneralLedger.SourceCode
		INNER JOIN (
			-- Step 2: Get a list of unknown transaction GL Account, Entity and Amount with an account balance of 0.00 for 
			-- that |amount|
			SELECT
				IndividualAmounts.GlAccountCode,
				IndividualAmounts.EntityId,
				IndividualAmounts.Amount
			FROM 
				#ValidationSummary ValidationSummary
			INNER JOIN #GeneralLedger GeneralLedger ON
				ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
				ValidationSummary.SourceCode = GeneralLedger.SourceCode
			INNER JOIN (
				-- Step 1: Get a distinct list of glaccountcode, entityid, |Amount|
				SELECT 
					GeneralLedger.GLAccountCode,
					GeneralLedger.EntityId, 
					CASE
						WHEN GeneralLedger.Amount < 0.0 THEN GeneralLedger.Amount * -1.0
						ELSE GeneralLedger.Amount
					END AS ''Amount''
				FROM #ValidationSummary ValidationSummary
				INNER JOIN #GeneralLedger GeneralLedger ON
					ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
					ValidationSummary.SourceCode = GeneralLedger.SourceCode
				WHERE
					ValidationSummary.HasUnknownCategorizationHierarchy = 1
				GROUP BY
					GeneralLedger.GlAccountCode,
					GeneralLedger.EntityId,
					CASE
						WHEN GeneralLedger.Amount < 0.0 THEN GeneralLedger.Amount * -1.0
						ELSE GeneralLedger.Amount
					END
			) IndividualAmounts ON
				GeneralLedger.GLAccountCode = IndividualAmounts.GLAccountCode AND
				GeneralLedger.EntityId = IndividualAmounts.EntityId AND
				(CASE 
					WHEN GeneralLedger.Amount < 0.0 THEN -1.0 * GeneralLedger.Amount 
					ELSE GeneralLedger.Amount 
				END) = IndividualAmounts.Amount 
			WHERE 
				ValidationSummary.HasUnknownCategorizationHierarchy = 1
			GROUP BY 
				IndividualAmounts.GlAccountCode,
				IndividualAmounts.EntityId,
				IndividualAmounts.Amount
			HAVING			
				SUM(GeneralLedger.Amount) = 0.0	
		) NonReclassedTransactions ON
			GeneralLedger.GlAccountCode = NonReclassedTransactions.GLAccountCode AND
			GeneralLedger.EntityId = NonReclassedTransactions.EntityId AND
			CASE 
				WHEN GeneralLedger.Amount < 0.0 THEN -1.0 * GeneralLedger.Amount
				ELSE GeneralLedger.Amount
			END = NonReclassedTransactions.Amount	
		
	END
		
	/* ================================================================================================================
		STEP 7: Clean Up Data														
	=================================================================================================================*/
	
	BEGIN
	
	DELETE 
		FROM 
			#ValidationSummary
	WHERE
		#ValidationSummary.HasUnknownGLAccount = 0 AND
		#ValidationSummary.HasUnknownCategorizationHierarchy = 0
	
	END	
	
 
	
	/* ================================================================================================================
		STEP 11: GET FINAL RESULTS
		Handle ALL Logic													
	=================================================================================================================*/
	BEGIN
		
	SELECT
		''Corporate Finance - Mapping'' AS ''ResolvedBy'',
		ValidationSummary.SourceCode,
		-- MRI
		GeneralLedger.Period,
		GeneralLedger.Ref,
		GeneralLedger.Item,
		ISNULL(GeneralLedger.EntityID, '''') AS ''EntityID'',
		ISNULL(GeneralLedger.EntityName, '''') AS ''EntityName'',
		ISNULL(GeneralLedger.GLAccountCode, '''') AS ''GLAccountCode'',
		ISNULL(GeneralLedger.GlAccountName, '''') AS ''GlAccountName'',
		ISNULL(GeneralLedger.DepartmentCode, '''') AS ''Department'',
		ISNULL(GeneralLedger.DepartmentDescription, '''') AS ''DepartmentDescription'',
		ISNULL(GeneralLedger.JobCode, '''') AS ''JobCode'',
		ISNULL(GeneralLedger.JobCodeDescription, '''') AS ''JobCodeDescription'',
		ISNULL(GeneralLedger.Amount, '''') AS ''Amount'',
		ISNULL(GeneralLedger.Description, '''') AS ''Description'',
		ISNULL(GeneralLedger.EnterDate, '''') AS ''EnterDate'',
		ISNULL(GeneralLedger.Reversal, '''') AS ''Reversal'',
		ISNULL(GeneralLedger.Status, '''') AS ''Status'',
		ISNULL(GeneralLedger.Basis, '''') AS ''Basis'',
		ISNULL(GeneralLedger.UserId, '''') AS ''UserId'',
		ISNULL(GeneralLedger.CorporateDepartmentCode, '''') AS ''CorporateDepartmentCode'',
		ISNULL(GeneralLedger.[Source], '''') AS ''Source'',
		GlobalHierarchy.GLAccountCode AS ''GlobalGLAccountCode'',
		GlobalHierarchy.GLAccountName AS ''GlobalGLAccountName'',
		ReportingHierarchy.GLCategorizationName AS ''LocalCategorization'',
		ReportingHierarchy.GLFinancialCategoryName AS ''LocalFinancialCategoryName'',
		ReportingHierarchy.GLMajorCategoryName AS ''LocalMajorCategoryName'',
		ReportingHierarchy.GLMinorCategoryName AS ''LocalMinorCategoryName'',
		ReportingHierarchy.InflowOutflow AS ''InflowOutFlow'',
		PropertyFund.PropertyFundName AS ''GrReportingEntityName'',
		ActivityType.ActivityTypeName AS ''GrActivityTypeName'',
		OriginatingRegion.SubRegionName AS ''GrOriginatingSubRegionName'',
		AllocationRegion.SubRegionName AS ''GrAllocationSubRegionName'',
		FunctionalDepartment.FunctionalDepartmentName AS ''GrFunctionalDepartmentName''
	FROM 
		#ValidationSummary ValidationSummary
		INNER JOIN dbo.ProfitabilityActual ON 
			ValidationSummary.ProfitabilityActualKey = ProfitabilityActual.ProfitabilityActualKey
		INNER JOIN dbo.GLCategorizationHierarchy GlobalHierarchy ON
			ProfitabilityActual.GlobalGLCategorizationHierarchyKey = GlobalHierarchy.GLCategorizationHierarchyKey
		INNER JOIN dbo.GLCategorizationHierarchy ReportingHierarchy ON 
			ProfitabilityActual.ReportingGLCategorizationHierarchyKey = ReportingHierarchy.GLCategorizationHierarchyKey
		INNER JOIN dbo.PropertyFund ON 
			ProfitabilityActual.PropertyFundKey = PropertyFund.PropertyFundKey
		INNER JOIN dbo.ActivityType ON 
			ProfitabilityActual.ActivityTypeKey = ActivityType.ActivityTypeKey
		INNER JOIN dbo.OriginatingRegion ON 
			ProfitabilityActual.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey
		INNER JOIN dbo.AllocationRegion ON 
			 ProfitabilityActual.AllocationRegionKey = AllocationRegion.AllocationRegionKey
		INNER JOIN dbo.Overhead ON 
			ProfitabilityActual.OverheadKey = Overhead.OverheadKey
		INNER JOIN dbo.FunctionalDepartment ON 
			ProfitabilityActual.FunctionalDepartmentKey	= FunctionalDepartment.FunctionalDepartmentKey
		INNER JOIN #GeneralLedger GeneralLedger ON 
			ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND 
			ValidationSummary.SourceCode = GeneralLedger.SourceCode
	WHERE
		(
			ValidationSummary.HasUnknownGLAccount = 1 OR
			ValidationSummary.HasUnknownCategorizationHierarchy = 1 
		) AND
		ValidationSummary.HasUnknownGlobalCategorizationHierarchy = 0
	END
	
	--------------------------------------------------------------------------
	/*	Clean up temp tables												*/
	--------------------------------------------------------------------------

	BEGIN
	
	IF OBJECT_ID(''tempdb..#ValidationSummary'') IS NOT NULL
		DROP TABLE #ValidationSummary
		
	IF OBJECT_ID(''tempdb..#GeneralLedger'') IS NOT NULL
		DROP TABLE #GeneralLedger
		
	IF OBJECT_ID(''tempdb..#IsGBSGlobalAccounts'') IS NOT NULL
		DROP TABLE #IsGBSGlobalAccounts

	END

















' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_S_UnknownSummaryMRIActualsGlobal]    Script Date: 03/08/2012 12:51:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_S_UnknownSummaryMRIActualsGlobal]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'






CREATE PROCEDURE [dbo].[stp_S_UnknownSummaryMRIActualsGlobal]
	@DataPriorToDate DateTime,
	@StartPeriod varchar(6),
	@EndPeriod varchar(6),
	@BudgetAllocationSetId int,
	@GBSAccounts bit = 0,
	@Sources varchar(max)
AS

/*********************************************************************************************************************
Description
	This validation report validates the profitability actuals for a specific period. The report is given to 
	Tishman Speyer, and they modify the data on their end to try and resolve the unknowns. There are two departments 
	that can handle this:
	
	1. Accounting: They go into MRI and modify the transaction data to be valid.	
		 NOTE: Tishman Speyer Accounting can handle unknowns in two ways in MRI:
		 1. Modify existing journal record and update foreign key references to valid entries
		 2. Cancel out invalid transaction by rolling back, and recapture transaction as new record. 
		    This will cause the incorrect transaction to appear twice, one with + and one with -, in 
		    effect ''zeroing out''.

	2. Corporate Finance: They go into GDM and AM and modify mapping data to include the transaction setup.
	
	The report validates the following Accounting (Re-class) issues:
	
	1. Unknown Activity Type
	2. Unknown Functional Department
	3. Unknown Originating Region
	4. Invalid Originating Region - Functional Department Mapping
	5. Invalid Activity Type - Entity Mapping
	6. Invalid Functional Department - Global Account Mapping (new since CC21 - Restricted tables in GDM)
	7. Invalid Functional Department - Functional Department - Corporate Entity Mapping (new since CC21 - Restricted tables in GDM)
	
	The report validates the following Corporate Finance (CDT Mapping) issues:
	
	1. Unknown Allocation Region
	2. Unknown GL Account
	3. Unknown Categorization Hierarchy 
		NOTE: This is due to two scenarios. First, GL Account unknown. Second, GL Account known, but rest of hierarchy
			  unknown, not mapped to global account in GDM.
	4. Unknown Property Fund
	
	Report Sections:
	
		STEP 1: GET ALL THE UNKNOWNS
		STEP 2: Get all the original MRI actuals transactions from GrReportingStaging
		STEP 3: VALIDATE RECLASSED UNKNOWNS DATA
		STEP 4: VALIDATE ENTITY - ACTIVITYTYPE COMBINATION
		STEP 5: Validate OriginatingRegion & FunctionalDepartment Combination		
		STEP 6: Validate FunctionalDepartment & GL Global Account Combination	
		STEP 6.5: Remove Global Inflow and Other Expenses	
		STEP 7: Clean Up Data - Remove items that have been resolved
		STEP 8: Get Property Header GL Account Sum
		STEP 9: Get Corporate Header GL Account Sum
		STEP 10: GET FINAL RESULTS - GBS Only Version
		STEP 11: GET FINAL RESULTS - All Version													

History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
			2011-11-15		: SNothling	:	CC21 - Rewrite script to incorporate new hierarchy logic replacing 
											translation types etc. Please see CC21 Functional Specification for 
											further details.
**********************************************************************************************************************/

	/* ================================================================================================================
		STEP 0: GET THE SOURCE FILTER	
	=================================================================================================================*/

	CREATE TABLE #SourceFilter
	(
		SourceCode VARCHAR(2)
	)
	
	IF @Sources LIKE ''%All%''
	BEGIN
		INSERT INTO #SourceFilter
		SELECT
			SourceCode
		FROM 
			dbo.Source
	END
	ELSE BEGIN
		INSERT INTO #SourceFilter
		SELECT
		*
		FROM 
			dbo.Split(@Sources) Sources
	END

	/* ================================================================================================================
		STEP 1: GET ALL THE UNKNOWNS
		
		-- Comments (SMN):
		-- 1. An unknown in either GLFinancialCategory, GLMajorCategory or GLMinorCategory will
		--    cause the categorization hierarchy to default to unknown, hence we only have to validate one 
		--    of these.
	=================================================================================================================*/

	BEGIN 
	
	CREATE TABLE #ValidationSummary
	(
		SourceCode CHAR(2) NOT NULL,
		ProfitabilityActualKey INT NOT NULL,
		ReferenceCode VARCHAR(100) NOT NULL,
		HasUnknownActivityType BIT NULL,
		HasUnknownAllocationRegion BIT NULL,
		HasUnknownGLAccount BIT NULL,
		HasUnknownCategorizationHierarchy BIT NULL,
		HasUnknownFunctionalDepartment BIT NULL,
		HasUnknownOriginatingRegion BIT NULL,
		HasUnknownPropertyFund BIT NULL,
		InValidOriginatingRegionAndFunctionalDepartment BIT NULL DEFAULT(0),
		InvalidGLAccountAndFunctionalDepartment BIT NULL DEFAULT(0),
		InValidActivityTypeAndEntity  BIT NULL DEFAULT(0)
	)
	
	-- Get all MRI sourced actuals with unknowns
	INSERT INTO #ValidationSummary
	SELECT 
		[Source].SourceCode AS ''SourceCode'',
		ProfitabilityActual.ProfitabilityActualKey AS ''ProfitabilityActualKey'',
		ProfitabilityActual.ReferenceCode AS ''ReferenceCode'',
		CASE
			WHEN ProfitabilityActual.ActivityTypeKey = -1 THEN 1
			ELSE 0
		END AS ''HasUnknownActivityType'',
		CASE 
			WHEN ProfitabilityActual.AllocationRegionKey = -1 THEN 1
			ELSE 0 
		END AS ''HasUnknownAllocationRegion'',
		CASE
			WHEN GlobalGLHierarchy.GLAccountCode LIKE ''%UNKNOWN%'' THEN 1
			ELSE 0
		END AS ''HasUnknownGLAccount'',
		CASE
			WHEN GlobalGLHierarchy.GLMinorCategoryName LIKE ''%UNKNOWN%'' THEN 1
			ELSE 0
		END AS ''HasUnknownCategorizationHierarchy'',
		CASE 
			WHEN ProfitabilityActual.FunctionalDepartmentKey= -1 THEN 1
			ELSE 0
		END AS ''HasUnknownFunctionalDepartment'',
		CASE 
			WHEN ProfitabilityActual.OriginatingRegionKey = -1 THEN 1
			ELSE 0
		END AS ''HasUnknownOriginatingRegion'',
		CASE 
			WHEN ProfitabilityActual.PropertyFundKey = -1 THEN 1
			ELSE 0
		END AS ''HasUnknownPropertyFund'',	
		CASE 
			WHEN ProfitabilityActual.FunctionalDepartmentKey= -1 OR ProfitabilityActual.PropertyFundKey = -1 THEN 1
			ELSE 0
		END AS ''InValidOriginatingRegionAndFunctionalDepartment'', 
		CASE 
			WHEN ProfitabilityActual.FunctionalDepartmentKey= -1 OR GlobalGLHierarchy.GLAccountCode LIKE ''%UNKNOWN%'' THEN 1
			ELSE 0
		END AS ''InvalidGLAccountAndFunctionalDepartment'', 
		0 AS ''InValidActivityTypeAndEntity''
	FROM 
		dbo.ProfitabilityActual
		INNER JOIN dbo.Calendar ON
			ProfitabilityActual.CalendarKey = Calendar.CalendarKey
		INNER JOIN dbo.GLCategorizationHierarchy GlobalGLHierarchy ON
			ProfitabilityActual.GlobalGLCategorizationHierarchyKey = GlobalGLHierarchy.GLCategorizationHierarchyKey
		INNER JOIN dbo.[Source] ON
			ProfitabilityActual.SourceKey = [Source].SourceKey
		INNER JOIN #SourceFilter ON
			Source.SourceCode = #SourceFilter.SourceCode
	WHERE
		Calendar.CalendarPeriod BETWEEN @StartPeriod AND @EndPeriod AND
		-- BillingUploadDetails indicate import from TAPAS, we want MRI only
		ProfitabilityActual.ReferenceCode NOT LIKE ''%BillingUploadDetailId%'' AND
		(
			ProfitabilityActual.ActivityTypeKey = -1 OR
			ProfitabilityActual.AllocationRegionKey = -1 OR
			ProfitabilityActual.FunctionalDepartmentKey = -1 OR
			GlobalGLHierarchy.GLAccountCode LIKE ''%UNKNOWN%'' OR
			GlobalGLHierarchy.GLMinorCategoryName LIKE ''%UNKNOWN%'' OR
			ProfitabilityActual.OriginatingRegionKey = -1 OR
			ProfitabilityActual.PropertyFundKey = -1
		)
		
	END
	
	/* ================================================================================================================
		STEP 2: Get all the original MRI actuals transactions from GrReportingStaging
		
		NOTE: We are going to use these to determine whether records have been reconciled with a re-class. Re-class items 
		still come up as unknowns, but they have duplicate records with identical but amount*-1.0 values so that they 
		balance out to 0.00
	=================================================================================================================*/
		
		BEGIN
	
	------------------------------------------------------------------------------------------------------		
	-- Create temp table
	------------------------------------------------------------------------------------------------------		

	CREATE TABLE #GeneralLedger
	(
		Period NVARCHAR(6),
		Item INT,
		Ref NVARCHAR(8),
		SiteId NVARCHAR(2),
		EntityId NVARCHAR(7),
		EntityName NVARCHAR(100),
		GlAccountCode NVARCHAR(14),
		GlAccountName NVARCHAR(70),
		DepartmentCode NVARCHAR(8),
		DepartmentDescription NVARCHAR(MAX),
		JobCode NVARCHAR(15),
		JobCodeDescription NVARCHAR(50),
		Amount MONEY,
		[Description] NVARCHAR(60),
		EnterDate DATETIME,
		Reversal NVARCHAR(1),
		Status NVARCHAR(1),
		Basis NVARCHAR(1),
		[UserId] NVARCHAR(20),
		CorporateDepartmentCode NVARCHAR(6),
		SourceCode NVARCHAR(2),
		SourcePrimaryKey NVARCHAR(62),
		[Source] NVARCHAR(2)
	)

	

	/* ================================================================================================================
		US
	=================================================================================================================*/
	
	-- US Prop
	IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = ''US''
	)
	BEGIN
		PRINT ''US''
		INSERT INTO #GeneralLedger
		SELECT
				GeneralLedger.Period,
				GeneralLedger.Item,
				GeneralLedger.Ref,
				GeneralLedger.SiteId,
				SourceEntity.EntityId,
				SourceEntity.Name AS ''EntityName'',
				GeneralLedger.GlAccountCode,
				SourceGlobalAccount.AcctName AS ''GlAccountName'',
				SourceDepartment.DepartmentCode,
				SourceDepartment.[Description] AS ''DepartmentDescription'',
				SourceJobCode.JobCode,
				SourceJobCode.[Description] AS ''JobCodeDescription'',
				GeneralLedger.Amount,
				GeneralLedger.[Description],
				GeneralLedger.EnterDate,
				GeneralLedger.Reversal,
				GeneralLedger.Status,
				GeneralLedger.Basis,
				GeneralLedger.[UserId],
				GeneralLedger.CorporateDepartmentCode,
				GeneralLedger.SourceCode,
				GeneralLedger.SourcePrimaryKey,
				GeneralLedger.[Source]
			FROM 
				GrReportingStaging.USProp.GeneralLedger GeneralLedger
				INNER JOIN (
					--This allows JOURNAL&GHIS to each have a record with the same PK,
					--but that is incorrect data and as such GR will pick GHIS as the 
					--more accurate data, for it is posted data, WHERE journal data is still open data
					SELECT 
						SourcePrimaryKey,
						MAX(SourceTableId) SourceTableId
					FROM
						GrReportingStaging.USProp.GeneralLedger Gl
					GROUP BY 
						SourcePrimaryKey
				) SourceGeneralLedger ON
					GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
					GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId
				
				--INNER JOIN #SourceFilter ON
				--	GeneralLedger.[Source] = #SourceFilter.SourceCode
					
				-- US Prop entity = propertyfund
				LEFT OUTER JOIN (
					SELECT
						Entity.*
					FROM 
						GrReportingStaging.USProp.Entity Entity
					INNER JOIN GrReportingStaging.USProp.EntityActive(@DataPriorToDate) ActiveEntity ON
						Entity.ImportKey = ActiveEntity.ImportKey
				) SourceEntity ON
					GeneralLedger.PropertyFundCode = SourceEntity.EntityId
				
				-- US Prop Department = Region + Functional Department OR Investors	
				LEFT OUTER JOIN (
					SELECT
						Department.*
					FROM 
						GrReportingStaging.gdm.Department Department 
					INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
						Department.ImportKey = ActiveDepartment.ImportKey 			
				) SourceDepartment ON
					GeneralLedger.SourceCode = SourceDepartment.[Source] AND
					GeneralLedger.RegionCode + GeneralLedger.FunctionalDepartmentCode = SourceDepartment.DepartmentCode
				
				-- US Prop GLAccount = Expense Type + Activity
				LEFT OUTER JOIN (
					SELECT
						GlobalAccount.*
					FROM
						GrReportingStaging.USProp.GACC GlobalAccount
					INNER JOIN GrReportingStaging.USProp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
						GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
				) SourceGlobalAccount ON
					GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
				
				-- US Prop Job Code = Tenant & Capital Improvements (Property Only)
				LEFT OUTER JOIN (
					SELECT
						JobCode.*
					FROM 
						GrReportingStaging.GACS.JobCode JobCode 
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
						JobCode.ImportKey = ActiveJobCode.ImportKey			
				) SourceJobCode ON
					GeneralLedger.SourceCode = SourceJobCode.[Source] AND 
					GeneralLedger.JobCode = SourceJobCode.JobCode
			WHERE
				GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod AND
				-- We do not import records with a corporate department code, because the transaction will
				-- come up as a corp transaction anyway, otherwise we count it twice
				(
					CorporateDepartmentCode IS NULL OR
					CorporateDepartmentCode = ''N''
				)
	END
					
	-- US Corp
	IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = ''UC''
	)
	BEGIN
		PRINT ''UC''
		INSERT INTO #GeneralLedger
			SELECT
				GeneralLedger.Period,
				GeneralLedger.Item,
				GeneralLedger.Ref,
				GeneralLedger.SiteId,
				SourceEntity.EntityId,
				SourceEntity.Name AS ''EntityName'',
				GeneralLedger.GlAccountCode,
				SourceGlobalAccount.AcctName AS ''GlAccountName'',
				SourceDepartment.DepartmentCode,
				SourceDepartment.[Description] AS ''DepartmentDescription'',
				SourceJobCode.JobCode,
				SourceJobCode.[Description] AS ''JobCodeDescription'',
				GeneralLedger.Amount,
				GeneralLedger.[Description],
				GeneralLedger.EnterDate,
				GeneralLedger.Reversal,
				GeneralLedger.Status,
				GeneralLedger.Basis,
				GeneralLedger.[UserId],
				GeneralLedger.CorporateDepartmentCode,
				GeneralLedger.SourceCode,
				GeneralLedger.SourcePrimaryKey,
				GeneralLedger.[Source]
			FROM 
				GrReportingStaging.USCorp.GeneralLedger GeneralLedger
				INNER JOIN (
					--This allows JOURNAL&GHIS to each have a record with the same PK,
					--but that is incorrect data and as such GR will pick GHIS as the 
					--more accurate data, for it is posted data, WHERE journal data is still open data
					SELECT 
						SourcePrimaryKey,
						MAX(SourceTableId) SourceTableId
					FROM
						GrReportingStaging.USCorp.GeneralLedger Gl
					GROUP BY 
						SourcePrimaryKey
				) SourceGeneralLedger ON
					GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
					GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId
				
				-- US Corp Entity = Region Code 
				LEFT OUTER JOIN (
					SELECT
						Entity.*
					FROM 
						GrReportingStaging.USCorp.Entity Entity
					INNER JOIN GrReportingStaging.USCorp.EntityActive(@DataPriorToDate) ActiveEntity ON
						Entity.ImportKey = ActiveEntity.ImportKey
				) SourceEntity ON
					GeneralLedger.RegionCode = SourceEntity.EntityId
					
				-- US Corp Department = PropertyFund
				LEFT OUTER JOIN (
					SELECT
						Department.*
					FROM 
						GrReportingStaging.gdm.Department Department 
					INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
						Department.ImportKey = ActiveDepartment.ImportKey 			
				) SourceDepartment ON
					GeneralLedger.SourceCode = SourceDepartment.[Source] AND
					GeneralLedger.PropertyFundCode = SourceDepartment.DepartmentCode
				
				-- US Prop GLAccount = Expense Type + Activity
				LEFT OUTER JOIN (
					SELECT
						GlobalAccount.*
					FROM
						GrReportingStaging.USCorp.GACC GlobalAccount
					INNER JOIN GrReportingStaging.USCorp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
						GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
				) SourceGlobalAccount ON
					GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
				
				-- US Corp Job Code = Functional Department OR IT Costs
				LEFT OUTER JOIN (
					SELECT
						JobCode.*
					FROM 
						GrReportingStaging.GACS.JobCode JobCode 
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
						JobCode.ImportKey = ActiveJobCode.ImportKey			
				) SourceJobCode ON
					GeneralLedger.SourceCode = SourceJobCode.[Source] AND 
					GeneralLedger.JobCode = SourceJobCode.JobCode
				
			WHERE
				GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod			
	END
				
	/* ================================================================================================================
		EU
	=================================================================================================================*/
	
	-- EU Prop
		IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = ''EU''
	)
	BEGIN
		PRINT ''EU''
		INSERT INTO #GeneralLedger
		SELECT
			GeneralLedger.Period,
			GeneralLedger.Item,
			GeneralLedger.Ref,
			GeneralLedger.SiteId,
			SourceEntity.EntityId,
			SourceEntity.Name AS ''EntityName'',
			GeneralLedger.GlAccountCode,
			SourceGlobalAccount.AcctName AS ''GlAccountName'',
			SourceDepartment.DepartmentCode,
			SourceDepartment.[Description] AS ''DepartmentDescription'',
			SourceJobCode.JobCode,
			SourceJobCode.[Description] AS ''JobCodeDescription'',
			GeneralLedger.Amount,
			GeneralLedger.[Description],
			GeneralLedger.EnterDate,
			GeneralLedger.Reversal,
			GeneralLedger.Status,
			GeneralLedger.Basis,
			GeneralLedger.[UserId],
			GeneralLedger.CorporateDepartmentCode,
			GeneralLedger.SourceCode,
			GeneralLedger.SourcePrimaryKey,
			GeneralLedger.[Source]
		FROM 
			GrReportingStaging.EUProp.GeneralLedger GeneralLedger
			INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, WHERE journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.EUProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
			) SourceGeneralLedger ON
				GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
				GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId
				
			-- EU Prop Entity = propertyFund
			LEFT OUTER JOIN (
				SELECT
					Entity.*
				FROM 
					GrReportingStaging.EUProp.Entity Entity
				INNER JOIN GrReportingStaging.EUProp.EntityActive(@DataPriorToDate) ActiveEntity ON
					Entity.ImportKey = ActiveEntity.ImportKey
			) SourceEntity ON
				GeneralLedger.PropertyFundCode = SourceEntity.EntityId
				
			LEFT OUTER JOIN (
				SELECT
					Department.*
				FROM 
					GrReportingStaging.gdm.Department Department 
				INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
					Department.ImportKey = ActiveDepartment.ImportKey 			
			) SourceDepartment ON
				GeneralLedger.SourceCode = SourceDepartment.[Source] AND
				GeneralLedger.RegionCode + GeneralLedger.FunctionalDepartmentCode = SourceDepartment.DepartmentCode
			
			LEFT OUTER JOIN (
				SELECT
					GlobalAccount.*
				FROM
					GrReportingStaging.EUProp.GACC GlobalAccount
				INNER JOIN GrReportingStaging.EUProp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
					GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
			) SourceGlobalAccount ON
				GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
			
			LEFT OUTER JOIN (
				SELECT
					JobCode.*
				FROM 
					GrReportingStaging.GACS.JobCode JobCode 
				INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
					JobCode.ImportKey = ActiveJobCode.ImportKey			
			) SourceJobCode ON
				GeneralLedger.SourceCode = SourceJobCode.[Source] AND 
				GeneralLedger.JobCode = SourceJobCode.JobCode
				
		WHERE
			GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod AND	
			-- We do not import records with a corporate department code, because the transaction will
			-- come up as a corp transaction anyway, otherwise we count it twice
			(
				CorporateDepartmentCode IS NULL OR
				CorporateDepartmentCode = ''N''
			)
	END	 
	
	-- EU Corp
	IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = ''EC''
	)
	BEGIN
		PRINT ''EC''
		INSERT INTO #GeneralLedger
		SELECT
			GeneralLedger.Period,
			GeneralLedger.Item,
			GeneralLedger.Ref,
			GeneralLedger.SiteId,
			SourceEntity.EntityId,
			SourceEntity.Name AS ''EntityName'',
			GeneralLedger.GlAccountCode,
			SourceGlobalAccount.AcctName AS ''GlAccountName'',
			SourceDepartment.DepartmentCode,
			SourceDepartment.[Description] AS ''DepartmentDescription'',
			SourceJobCode.JobCode,
			SourceJobCode.[Description] AS ''JobCodeDescription'',
			GeneralLedger.Amount,
			GeneralLedger.[Description],
			GeneralLedger.EnterDate,
			GeneralLedger.Reversal,
			GeneralLedger.Status,
			GeneralLedger.Basis,
			GeneralLedger.[UserId],
			GeneralLedger.CorporateDepartmentCode,
			GeneralLedger.SourceCode,
			GeneralLedger.SourcePrimaryKey,
			GeneralLedger.[Source]
		FROM 
			GrReportingStaging.EUCorp.GeneralLedger GeneralLedger
			INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, WHERE journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.EUCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
			) SourceGeneralLedger ON
				GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
				GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId
			
			-- EU Corp Entity = Region Code 	
			LEFT OUTER JOIN (
				SELECT
					Entity.*
				FROM 
					GrReportingStaging.EUCorp.Entity Entity
				INNER JOIN GrReportingStaging.EUCorp.EntityActive(@DataPriorToDate) ActiveEntity ON
					Entity.ImportKey = ActiveEntity.ImportKey
			) SourceEntity ON
				GeneralLedger.RegionCode = SourceEntity.EntityId
				
			LEFT OUTER JOIN (
				SELECT
					Department.*
				FROM 
					GrReportingStaging.gdm.Department Department 
				INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
					Department.ImportKey = ActiveDepartment.ImportKey 			
			) SourceDepartment ON
				GeneralLedger.SourceCode = SourceDepartment.[Source] AND
				GeneralLedger.PropertyFundCode = SourceDepartment.DepartmentCode
			
			LEFT OUTER JOIN (
				SELECT
					GlobalAccount.*
				FROM
					GrReportingStaging.EUCorp.GACC GlobalAccount
				INNER JOIN GrReportingStaging.EUCorp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
					GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
			) SourceGlobalAccount ON
				GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
			
			LEFT OUTER JOIN (
				SELECT
					JobCode.*
				FROM 
					GrReportingStaging.GACS.JobCode JobCode 
				INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
					JobCode.ImportKey = ActiveJobCode.ImportKey			
			) SourceJobCode ON
				GeneralLedger.SourceCode = SourceJobCode.[Source] AND GeneralLedger.JobCode = SourceJobCode.JobCode
				
		WHERE
			GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod
	END	
		
	/* ================================================================================================================
		BR
	=================================================================================================================*/
	
	-- BR Prop
	IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = ''BR''
	)
	BEGIN
		INSERT INTO #GeneralLedger
		SELECT
			GeneralLedger.Period,
			GeneralLedger.Item,
			GeneralLedger.Ref,
			GeneralLedger.SiteId,
			SourceEntity.EntityId,
			SourceEntity.Name AS ''EntityName'',
			GeneralLedger.GlAccountCode,
			SourceGlobalAccount.AcctName AS ''GlAccountName'',
			SourceDepartment.DepartmentCode,
			SourceDepartment.[Description] AS ''DepartmentDescription'',
			SourceJobCode.JobCode,
			SourceJobCode.[Description] AS ''JobCodeDescription'',
			GeneralLedger.Amount,
			GeneralLedger.[Description],
			GeneralLedger.EnterDate,
			GeneralLedger.Reversal,
			GeneralLedger.Status,
			GeneralLedger.Basis,
			GeneralLedger.[UserId],
			GeneralLedger.CorporateDepartmentCode,
			GeneralLedger.SourceCode,
			GeneralLedger.SourcePrimaryKey,
			GeneralLedger.[Source]
		FROM 
			GrReportingStaging.BRProp.GeneralLedger GeneralLedger
			INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, WHERE journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.BRProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
			) SourceGeneralLedger ON
				GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
				GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId
				
			LEFT OUTER JOIN (
				SELECT
					Entity.*
				FROM 
					GrReportingStaging.BRProp.Entity Entity
				INNER JOIN GrReportingStaging.BRProp.EntityActive(@DataPriorToDate) ActiveEntity ON
					Entity.ImportKey = ActiveEntity.ImportKey
			) SourceEntity ON
				GeneralLedger.PropertyFundCode = SourceEntity.EntityId
				
			LEFT OUTER JOIN (
				SELECT
					Department.*
				FROM 
					GrReportingStaging.gdm.Department Department 
				INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
					Department.ImportKey = ActiveDepartment.ImportKey 			
			) SourceDepartment ON
				GeneralLedger.SourceCode = SourceDepartment.[Source] AND
				GeneralLedger.RegionCode + GeneralLedger.FunctionalDepartmentCode = SourceDepartment.DepartmentCode
			
			LEFT OUTER JOIN (
				SELECT
					GlobalAccount.*
				FROM
					GrReportingStaging.BRProp.GACC GlobalAccount
				INNER JOIN GrReportingStaging.BRProp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
					GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
			) SourceGlobalAccount ON
				GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
			
			LEFT OUTER JOIN (
				SELECT
					JobCode.*
				FROM 
					GrReportingStaging.GACS.JobCode JobCode 
				INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
					JobCode.ImportKey = ActiveJobCode.ImportKey			
			) SourceJobCode ON
				GeneralLedger.SourceCode = SourceJobCode.[Source] AND GeneralLedger.JobCode = SourceJobCode.JobCode
				
		WHERE
			GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod AND	
			-- We do not import records with a corporate department code, because the transaction will
			-- come up as a corp transaction anyway, otherwise we count it twice
			(
				CorporateDepartmentCode IS NULL OR
				CorporateDepartmentCode = ''N''
			)	
	END
				
	-- BR Corp
	IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = ''BC''
	)
	BEGIN
		INSERT INTO #GeneralLedger
		SELECT
			GeneralLedger.Period,
			GeneralLedger.Item,
			GeneralLedger.Ref,
			GeneralLedger.SiteId,
			SourceEntity.EntityId,
			SourceEntity.Name AS ''EntityName'',
			GeneralLedger.GlAccountCode,
			SourceGlobalAccount.AcctName AS ''GlAccountName'',
			SourceDepartment.DepartmentCode,
			SourceDepartment.[Description] AS ''DepartmentDescription'',
			SourceJobCode.JobCode,
			SourceJobCode.[Description] AS ''JobCodeDescription'',
			GeneralLedger.Amount,
			GeneralLedger.[Description],
			GeneralLedger.EnterDate,
			GeneralLedger.Reversal,
			GeneralLedger.Status,
			GeneralLedger.Basis,
			GeneralLedger.[UserId],
			GeneralLedger.CorporateDepartmentCode,
			GeneralLedger.SourceCode,
			GeneralLedger.SourcePrimaryKey,
			GeneralLedger.[Source]
		FROM 
			GrReportingStaging.BRCorp.GeneralLedger GeneralLedger
			INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, WHERE journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.BRCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
			) SourceGeneralLedger ON
				GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
				GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId

			-- BR Corp Entity = Region Code 
			LEFT OUTER JOIN (
				SELECT
					Entity.*
				FROM 
					GrReportingStaging.BRCorp.Entity Entity
				INNER JOIN GrReportingStaging.BRCorp.EntityActive(@DataPriorToDate) ActiveEntity ON
					Entity.ImportKey = ActiveEntity.ImportKey
			) SourceEntity ON
				GeneralLedger.RegionCode = SourceEntity.EntityId
				
			LEFT OUTER JOIN (
				SELECT
					Department.*
				FROM 
					GrReportingStaging.gdm.Department Department 
				INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
					Department.ImportKey = ActiveDepartment.ImportKey 			
			) SourceDepartment ON
				GeneralLedger.SourceCode = SourceDepartment.[Source] AND
				GeneralLedger.PropertyFundCode = SourceDepartment.DepartmentCode
			
			LEFT OUTER JOIN (
				SELECT
					GlobalAccount.*
				FROM
					GrReportingStaging.BRCorp.GACC GlobalAccount
				INNER JOIN GrReportingStaging.BRCorp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
					GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
			) SourceGlobalAccount ON
				GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
			
			LEFT OUTER JOIN (
				SELECT
					JobCode.*
				FROM 
					GrReportingStaging.GACS.JobCode JobCode 
				INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
					JobCode.ImportKey = ActiveJobCode.ImportKey			
			) SourceJobCode ON
				GeneralLedger.SourceCode = SourceJobCode.[Source] AND GeneralLedger.JobCode = SourceJobCode.JobCode
			
		WHERE
			GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod		
	END
			
	/* ================================================================================================================
		IN
	=================================================================================================================*/

	-- IN Prop
	IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = ''IN''
	)
	BEGIN
		INSERT INTO #GeneralLedger
		SELECT
			GeneralLedger.Period,
			GeneralLedger.Item,
			GeneralLedger.Ref,
			GeneralLedger.SiteId,
			SourceEntity.EntityId,
			SourceEntity.Name AS ''EntityName'',
			GeneralLedger.GlAccountCode,
			SourceGlobalAccount.AcctName AS ''GlAccountName'',
			SourceDepartment.DepartmentCode,
			SourceDepartment.[Description] AS ''DepartmentDescription'',
			SourceJobCode.JobCode,
			SourceJobCode.[Description] AS ''JobCodeDescription'',
			GeneralLedger.Amount,
			GeneralLedger.[Description],
			GeneralLedger.EnterDate,
			GeneralLedger.Reversal,
			GeneralLedger.Status,
			GeneralLedger.Basis,
			GeneralLedger.[UserId],
			GeneralLedger.CorporateDepartmentCode,
			GeneralLedger.SourceCode,
			GeneralLedger.SourcePrimaryKey,
			GeneralLedger.[Source]
		FROM 
			GrReportingStaging.INProp.GeneralLedger GeneralLedger
			INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, WHERE journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.INProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
			) SourceGeneralLedger ON
				GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
				GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId
				
			LEFT OUTER JOIN (
				SELECT
					Entity.*
				FROM 
					GrReportingStaging.INProp.Entity Entity
				INNER JOIN GrReportingStaging.INProp.EntityActive(@DataPriorToDate) ActiveEntity ON
					Entity.ImportKey = ActiveEntity.ImportKey
			) SourceEntity ON
				GeneralLedger.PropertyFundCode = SourceEntity.EntityId
				
			LEFT OUTER JOIN (
				SELECT
					Department.*
				FROM 
					GrReportingStaging.gdm.Department Department 
				INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
					Department.ImportKey = ActiveDepartment.ImportKey 			
			) SourceDepartment ON
				GeneralLedger.SourceCode = SourceDepartment.[Source] AND
				GeneralLedger.RegionCode + GeneralLedger.FunctionalDepartmentCode = SourceDepartment.DepartmentCode
			
			LEFT OUTER JOIN (
				SELECT
					GlobalAccount.*
				FROM
					GrReportingStaging.INProp.GACC GlobalAccount
				INNER JOIN GrReportingStaging.INProp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
					GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
			) SourceGlobalAccount ON
				GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
			
			LEFT OUTER JOIN (
				SELECT
					JobCode.*
				FROM 
					GrReportingStaging.GACS.JobCode JobCode 
				INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
					JobCode.ImportKey = ActiveJobCode.ImportKey			
			) SourceJobCode ON
				GeneralLedger.SourceCode = SourceJobCode.[Source] AND GeneralLedger.JobCode = SourceJobCode.JobCode
			
		WHERE
			GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod AND	
			-- We do not import records with a corporate department code, because the transaction will
			-- come up as a corp transaction anyway, otherwise we count it twice
			(
				CorporateDepartmentCode IS NULL OR
				CorporateDepartmentCode = ''N''
			)
	END
	
	-- IN Corp
	IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = ''IC''
	)
	BEGIN
		INSERT INTO #GeneralLedger
		SELECT
			GeneralLedger.Period,
			GeneralLedger.Item,
			GeneralLedger.Ref,
			GeneralLedger.SiteId,
			SourceEntity.EntityId,
			SourceEntity.Name AS ''EntityName'',
			GeneralLedger.GlAccountCode,
			SourceGlobalAccount.AcctName AS ''GlAccountName'',
			SourceDepartment.DepartmentCode,
			SourceDepartment.[Description] AS ''DepartmentDescription'',
			SourceJobCode.JobCode,
			SourceJobCode.[Description] AS ''JobCodeDescription'',
			GeneralLedger.Amount,
			GeneralLedger.[Description],
			GeneralLedger.EnterDate,
			GeneralLedger.Reversal,
			GeneralLedger.Status,
			GeneralLedger.Basis,
			GeneralLedger.[UserId],
			GeneralLedger.CorporateDepartmentCode,
			GeneralLedger.SourceCode,
			GeneralLedger.SourcePrimaryKey,
			GeneralLedger.[Source]
		FROM 
			GrReportingStaging.INCorp.GeneralLedger GeneralLedger
			INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, WHERE journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.INCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
			) SourceGeneralLedger ON
				GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
				GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId
				
			-- IN Corp Entity = Region Code 
			LEFT OUTER JOIN (
				SELECT
					Entity.*
				FROM 
					GrReportingStaging.INCorp.Entity Entity
				INNER JOIN GrReportingStaging.INCorp.EntityActive(@DataPriorToDate) ActiveEntity ON
					Entity.ImportKey = ActiveEntity.ImportKey
			) SourceEntity ON
				GeneralLedger.RegionCode = SourceEntity.EntityId
				
			LEFT OUTER JOIN (
				SELECT
					Department.*
				FROM 
					GrReportingStaging.gdm.Department Department 
				INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
					Department.ImportKey = ActiveDepartment.ImportKey 			
			) SourceDepartment ON
				GeneralLedger.SourceCode = SourceDepartment.[Source] AND
				GeneralLedger.PropertyFundCode = SourceDepartment.DepartmentCode
			
			LEFT OUTER JOIN (
				SELECT
					GlobalAccount.*
				FROM
					GrReportingStaging.INCorp.GACC GlobalAccount
				INNER JOIN GrReportingStaging.INCorp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
					GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
			) SourceGlobalAccount ON
				GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
			
			LEFT OUTER JOIN (
				SELECT
					JobCode.*
				FROM 
					GrReportingStaging.GACS.JobCode JobCode 
				INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
					JobCode.ImportKey = ActiveJobCode.ImportKey			
			) SourceJobCode ON
				GeneralLedger.SourceCode = SourceJobCode.[Source] AND GeneralLedger.JobCode = SourceJobCode.JobCode
			
		WHERE
			GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod	
	END
	/* ================================================================================================================
		CN
	=================================================================================================================*/
	
	-- CN Prop
	IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = ''CN''
	)
	BEGIN
		INSERT INTO #GeneralLedger
		SELECT
			GeneralLedger.Period,
			GeneralLedger.Item,
			GeneralLedger.Ref,
			GeneralLedger.SiteId,
			SourceEntity.EntityId,
			SourceEntity.Name AS ''EntityName'',
			GeneralLedger.GlAccountCode,
			SourceGlobalAccount.AcctName AS ''GlAccountName'',
			SourceDepartment.DepartmentCode,
			SourceDepartment.[Description] AS ''DepartmentDescription'',
			SourceJobCode.JobCode,
			SourceJobCode.[Description] AS ''JobCodeDescription'',
			GeneralLedger.Amount,
			GeneralLedger.[Description],
			GeneralLedger.EnterDate,
			GeneralLedger.Reversal,
			GeneralLedger.Status,
			GeneralLedger.Basis,
			GeneralLedger.[UserId],
			GeneralLedger.CorporateDepartmentCode,
			GeneralLedger.SourceCode,
			GeneralLedger.SourcePrimaryKey,
			GeneralLedger.[Source]
		FROM 
			GrReportingStaging.CNProp.GeneralLedger GeneralLedger
			INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, WHERE journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.CNProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
			) SourceGeneralLedger ON
				GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
				GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId
				
			LEFT OUTER JOIN (
				SELECT
					Entity.*
				FROM 
					GrReportingStaging.CNProp.Entity Entity
				INNER JOIN GrReportingStaging.CNProp.EntityActive(@DataPriorToDate) ActiveEntity ON
					Entity.ImportKey = ActiveEntity.ImportKey
			) SourceEntity ON
				GeneralLedger.PropertyFundCode = SourceEntity.EntityId
				
			LEFT OUTER JOIN (
				SELECT
					Department.*
				FROM 
					GrReportingStaging.gdm.Department Department 
				INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
					Department.ImportKey = ActiveDepartment.ImportKey 			
			) SourceDepartment ON
				GeneralLedger.SourceCode = SourceDepartment.[Source] AND
				GeneralLedger.RegionCode + GeneralLedger.FunctionalDepartmentCode = SourceDepartment.DepartmentCode
			
			LEFT OUTER JOIN (
				SELECT
					GlobalAccount.*
				FROM
					GrReportingStaging.CNProp.GACC GlobalAccount
				INNER JOIN GrReportingStaging.CNProp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
					GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
			) SourceGlobalAccount ON
				GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
			
			LEFT OUTER JOIN (
				SELECT
					JobCode.*
				FROM 
					GrReportingStaging.GACS.JobCode JobCode 
				INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
					JobCode.ImportKey = ActiveJobCode.ImportKey			
			) SourceJobCode ON
				GeneralLedger.SourceCode = SourceJobCode.[Source] AND GeneralLedger.JobCode = SourceJobCode.JobCode
			
		WHERE
			GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod AND	
			-- We do not import records with a corporate department code, because the transaction will
			-- come up as a corp transaction anyway, otherwise we count it twice
			(
				CorporateDepartmentCode IS NULL OR
				CorporateDepartmentCode = ''N''
			)
	END
				
	-- CN Corp
	IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = ''CC''
	)
	BEGIN
		INSERT INTO #GeneralLedger
		SELECT
			GeneralLedger.Period,
			GeneralLedger.Item,
			GeneralLedger.Ref,
			GeneralLedger.SiteId,
			SourceEntity.EntityId,
			SourceEntity.Name AS ''EntityName'',
			GeneralLedger.GlAccountCode,
			SourceGlobalAccount.AcctName AS ''GlAccountName'',
			SourceDepartment.DepartmentCode,
			SourceDepartment.[Description] AS ''DepartmentDescription'',
			SourceJobCode.JobCode,
			SourceJobCode.[Description] AS ''JobCodeDescription'',
			GeneralLedger.Amount,
			GeneralLedger.[Description],
			GeneralLedger.EnterDate,
			GeneralLedger.Reversal,
			GeneralLedger.Status,
			GeneralLedger.Basis,
			GeneralLedger.[UserId],
			GeneralLedger.CorporateDepartmentCode,
			GeneralLedger.SourceCode,
			GeneralLedger.SourcePrimaryKey,
			GeneralLedger.[Source]
		FROM 
			GrReportingStaging.CNCorp.GeneralLedger GeneralLedger
			INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, WHERE journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.CNCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
			) SourceGeneralLedger ON
				GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
				GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId
				
			-- CN Corp Entity = Region Code 
			LEFT OUTER JOIN (
				SELECT
					Entity.*
				FROM 
					GrReportingStaging.CNCorp.Entity Entity
				INNER JOIN GrReportingStaging.CNCorp.EntityActive(@DataPriorToDate) ActiveEntity ON
					Entity.ImportKey = ActiveEntity.ImportKey
			) SourceEntity ON
				GeneralLedger.RegionCode = SourceEntity.EntityId
				
			LEFT OUTER JOIN (
				SELECT
					Department.*
				FROM 
					GrReportingStaging.gdm.Department Department 
				INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
					Department.ImportKey = ActiveDepartment.ImportKey 			
			) SourceDepartment ON
				GeneralLedger.SourceCode = SourceDepartment.[Source] AND
				GeneralLedger.PropertyFundCode = SourceDepartment.DepartmentCode
			
			LEFT OUTER JOIN (
				SELECT
					GlobalAccount.*
				FROM
					GrReportingStaging.CNCorp.GACC GlobalAccount
				INNER JOIN GrReportingStaging.CNCorp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
					GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
			) SourceGlobalAccount ON
				GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
			
			LEFT OUTER JOIN (
				SELECT
					JobCode.*
				FROM 
					GrReportingStaging.GACS.JobCode JobCode 
				INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
					JobCode.ImportKey = ActiveJobCode.ImportKey			
			) SourceJobCode ON
				GeneralLedger.SourceCode = SourceJobCode.[Source] AND GeneralLedger.JobCode = SourceJobCode.JobCode
			
		WHERE
			GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod
	END
		
	END
		
	/* ================================================================================================================
		STEP 3: VALIDATE RECLASSED UNKNOWNS DATA
		
		This validates fixes of type 2 - see comment at top of script. We need to remove unknown transactions that have
		been fixed by a reclass. GL Account balances are calculated by GL Account and Entity in MRI, so a re-class will 
		make the GL Account Balance even out for that GL Account - Entity combination.
		
		ALGORITHM USED:
		
		Scenario: Assume the following transactions are flagged with unknown activity types
		
		GL Account Code		Entity											Amount
		EU5002300002		REGION DE                                       630.00                                
		EU5002300002		TISHMAN SPEYER REV VI ALTERNATIVE (IRE), L.P.   450.00                          
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.     640.00                                
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.     780.00                                
		EU6702290012		REGION DE										12.00                                 
		EU6702290012		REGION DE                                       12.00                                		
		
		They go and fix some of the transactions with re-classes, so now we see the following. 
		We want to exclude all the transactions with *** from the new validation report, because
		they have been fixed with a re-class. Please note that the re-classed transaction will not appear
		here, because it does not have an unknown activity type any more.	
		
		GL Account Code		Entity											Amount
		EU5002300002		REGION DE                                       630.00*****   
	    EU5002300002        REGION DE										-630.00****
		EU5002300002		TISHMAN SPEYER REV VI ALTERNATIVE (IRE), L.P.   450.00                          
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.     640.00****
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.     -640.00****                               
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.     780.00                                
		EU6702290012		REGION DE										12.00****  
	    EU6702290012		REGION DE										-12.00****                          
		EU6702290012		REGION DE                                       12.00 
		
		Step 1: Get a distinct list of gl accout code, entity, absolute value (hereafter indicated as |amount|
		Please note what happens to the EU6702290012 transactions here.
		
		GL Account Code		Entity											Amount
		EU5002300002		REGION DE                                       |630.00| 
		EU5002300002		TISHMAN SPEYER REV VI ALTERNATIVE (IRE), L.P.   |450.00|                         
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.     |640.00|                    
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.     |780.00|                              
		EU6702290012		REGION DE										|12.00|

		Step 2: join all transactions back onto this distinct list, and group by gl account code, entity and |amount|
		
		GL Account Code		Entity											Sum(Amount)		|Amount|
		EU5002300002		REGION DE										0.00			|630.00| 
		EU5002300002		TISHMAN SPEYER REV VI ALTERNATIVE (IRE), L.P.	450.00			|450.00|                         
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.		0.00			|640.00|                    
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.		780.00			|780.00|                              
		EU6702290012		REGION DE										12.00			|12.00|
		
		Step 3: return all transactions where the sum(amount) in step 2 did not balance out to 0.00. Please note that ALL
		the transactions for EU6702290012 is returned here, because we cannot distinguish which transaction is still invalid,
		and which was fixed by the re-class transaction. This algorithm is not fool proof, but it is as accurate as we can get.
		
		GL Account Code		Entity											Amount
		EU5002300002		TISHMAN SPEYER REV VI ALTERNATIVE (IRE), L.P.   450.00                          
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.     780.00                                
		EU6702290012		REGION DE										12.00****  
	    EU6702290012		REGION DE										-12.00****                          
		EU6702290012		REGION DE                                       12.00 
		
		We do this for each unknown type.

	=================================================================================================================*/
	
	/* ================================================================================================================
		Activity Type Unknowns
	=================================================================================================================*/

	BEGIN
	
	---------------------------------------------------------------------------------------
	-- Remove activity type unknowns from #ValidationSummary that have been re-classed, 
	-- and now net out to 0. 
	
	-- We group by GLAccountCode and Entity, because as long as we balance out on unknowns for 
	-- a glaccountbalance, we are fine
	---------------------------------------------------------------------------------------
	
	UPDATE ValidationSummary 
	SET
		HasUnknownActivityType = 0
	FROM 
	-- step 3: Validation Summary Record where the account balance for that glaccount, entity and |amount| balances out to 0.0
		#ValidationSummary ValidationSummary
		INNER JOIN #GeneralLedger GeneralLedger ON
			ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
			ValidationSummary.SourceCode = GeneralLedger.SourceCode
		INNER JOIN (
			-- step 2: Get a list of unknown transaction GL Account, Entity and Amount with an account balance of 0.00 for 
			-- that |amount|
			SELECT
				IndividualAmounts.GlAccountCode,
				IndividualAmounts.EntityId,
				IndividualAmounts.Amount
			FROM 
				#ValidationSummary ValidationSummary
			INNER JOIN #GeneralLedger GeneralLedger ON
				ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
				ValidationSummary.SourceCode = GeneralLedger.SourceCode
			INNER JOIN (
				-- step 1: Get a distinct list of glaccountcode, entityid, |Amount|
				SELECT 
					GeneralLedger.GLAccountCode,
					GeneralLedger.EntityId, 
					CASE
						WHEN GeneralLedger.Amount < 0.0 THEN GeneralLedger.Amount * -1.0
						ELSE GeneralLedger.Amount
					END AS ''Amount''
				FROM 
					#ValidationSummary ValidationSummary
					INNER JOIN #GeneralLedger GeneralLedger ON
						ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
						ValidationSummary.SourceCode = GeneralLedger.SourceCode
				WHERE
					ValidationSummary.HasUnknownActivityType = 1
				GROUP BY
					GeneralLedger.GlAccountCode,
					GeneralLedger.EntityId,
					CASE
						WHEN GeneralLedger.Amount < 0.0 THEN GeneralLedger.Amount * -1.0
						ELSE GeneralLedger.Amount
					END
			) IndividualAmounts ON
				GeneralLedger.GLAccountCode = IndividualAmounts.GLAccountCode AND
				GeneralLedger.EntityId = IndividualAmounts.EntityId AND
				(CASE 
					WHEN GeneralLedger.Amount < 0.0 THEN -1.0 * GeneralLedger.Amount 
					ELSE GeneralLedger.Amount 
				END) = IndividualAmounts.Amount 
			WHERE 
				ValidationSummary.HasUnknownActivityType = 1
			GROUP BY 
				IndividualAmounts.GlAccountCode,
				IndividualAmounts.EntityId,
				IndividualAmounts.Amount
			HAVING			
				SUM(GeneralLedger.Amount) = 0.0	
		) NonReclassedTransactions ON
			GeneralLedger.GlAccountCode = NonReclassedTransactions.GLAccountCode AND
			GeneralLedger.EntityId = NonReclassedTransactions.EntityId AND
			CASE 
				WHEN GeneralLedger.Amount < 0.0 THEN -1.0 * GeneralLedger.Amount
				ELSE GeneralLedger.Amount
			END = NonReclassedTransactions.Amount	
		
	END
	
	/* ================================================================================================================
		Allocation Region Unknowns
	=================================================================================================================*/

	BEGIN
	
	---------------------------------------------------------------------------------------
	-- Remove AllocationRegion Unknowns from #ValidationSummary that have been re-classed 
	-- and now net out to 0
	---------------------------------------------------------------------------------------
	
	UPDATE ValidationSummary 
	SET
		HasUnknownAllocationRegion = 0
	FROM 
	-- step 3: Validation Summary Record where the account balance for that glaccount, entity and |amount| balances out to 0.0
		#ValidationSummary ValidationSummary
		INNER JOIN #GeneralLedger GeneralLedger ON
			ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
			ValidationSummary.SourceCode = GeneralLedger.SourceCode
		INNER JOIN (
			-- step 2: Get a list of unknown transaction GL Account, Entity and Amount with an account balance of 0.00 for 
			-- that |amount|
			SELECT
				IndividualAmounts.GlAccountCode,
				IndividualAmounts.EntityId,
				IndividualAmounts.Amount
			FROM 
				#ValidationSummary ValidationSummary
			INNER JOIN #GeneralLedger GeneralLedger ON
				ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
				ValidationSummary.SourceCode = GeneralLedger.SourceCode
			INNER JOIN (
				-- step 1: Get a distinct list of glaccountcode, entityid, |Amount|
				SELECT 
					GeneralLedger.GLAccountCode,
					GeneralLedger.EntityId, 
					CASE
						WHEN GeneralLedger.Amount < 0.0 THEN GeneralLedger.Amount * -1.0
						ELSE GeneralLedger.Amount
					END AS ''Amount''
				FROM #ValidationSummary ValidationSummary
				INNER JOIN #GeneralLedger GeneralLedger ON
					ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
					ValidationSummary.SourceCode = GeneralLedger.SourceCode
				WHERE
					ValidationSummary.HasUnknownAllocationRegion = 1
				GROUP BY
					GeneralLedger.GlAccountCode,
					GeneralLedger.EntityId,
					CASE
						WHEN GeneralLedger.Amount < 0.0 THEN GeneralLedger.Amount * -1.0
						ELSE GeneralLedger.Amount
					END
			) IndividualAmounts ON
				GeneralLedger.GLAccountCode = IndividualAmounts.GLAccountCode AND
				GeneralLedger.EntityId = IndividualAmounts.EntityId AND
				(CASE 
					WHEN GeneralLedger.Amount < 0.0 THEN -1.0 * GeneralLedger.Amount 
					ELSE GeneralLedger.Amount 
				END) = IndividualAmounts.Amount 
			WHERE 
				ValidationSummary.HasUnknownOriginatingRegion = 1
			GROUP BY 
				IndividualAmounts.GlAccountCode,
				IndividualAmounts.EntityId,
				IndividualAmounts.Amount
			HAVING			
				SUM(GeneralLedger.Amount) = 0.0	
		) NonReclassedTransactions ON
			GeneralLedger.GlAccountCode = NonReclassedTransactions.GLAccountCode AND
			GeneralLedger.EntityId = NonReclassedTransactions.EntityId AND
			CASE 
				WHEN GeneralLedger.Amount < 0.0 THEN -1.0 * GeneralLedger.Amount
				ELSE GeneralLedger.Amount
			END = NonReclassedTransactions.Amount
		
	END	
	
	/* ================================================================================================================
		GL Account Unknowns
	=================================================================================================================*/

	BEGIN
	
	---------------------------------------------------------------------------------------
	-- Remove GLAccount Unknowns from #ValidationSummary that have been re-classed 
	-- and now net out to 0
	---------------------------------------------------------------------------------------
	
	UPDATE ValidationSummary 
	SET
		HasUnknownGlAccount = 0
	FROM 
	-- Step 3: Validation Summary Record where the account balance for that glaccount, entity and |amount| balances out to 0.0
		#ValidationSummary ValidationSummary
		INNER JOIN #GeneralLedger GeneralLedger ON
			ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
			ValidationSummary.SourceCode = GeneralLedger.SourceCode
		INNER JOIN (
			-- Step 2: Get a list of unknown transaction GL Account, Entity and Amount with an account balance of 0.00 for 
			-- that |amount|
			SELECT
				IndividualAmounts.GlAccountCode,
				IndividualAmounts.EntityId,
				IndividualAmounts.Amount
			FROM 
				#ValidationSummary ValidationSummary
			INNER JOIN #GeneralLedger GeneralLedger ON
				ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
				ValidationSummary.SourceCode = GeneralLedger.SourceCode
			INNER JOIN (
				-- Step 1: Get a distinct list of glaccountcode, entityid, |Amount|
				SELECT 
					GeneralLedger.GLAccountCode,
					GeneralLedger.EntityId, 
					CASE
						WHEN GeneralLedger.Amount < 0.0 THEN GeneralLedger.Amount * -1.0
						ELSE GeneralLedger.Amount
					END AS ''Amount''
				FROM #ValidationSummary ValidationSummary
				INNER JOIN #GeneralLedger GeneralLedger ON
					ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
					ValidationSummary.SourceCode = GeneralLedger.SourceCode
				WHERE
					ValidationSummary.HasUnknownGlAccount = 1
				GROUP BY
					GeneralLedger.GlAccountCode,
					GeneralLedger.EntityId,
					CASE
						WHEN GeneralLedger.Amount < 0.0 THEN GeneralLedger.Amount * -1.0
						ELSE GeneralLedger.Amount
					END
			) IndividualAmounts ON
				GeneralLedger.GLAccountCode = IndividualAmounts.GLAccountCode AND
				GeneralLedger.EntityId = IndividualAmounts.EntityId AND
				(CASE 
					WHEN GeneralLedger.Amount < 0.0 THEN -1.0 * GeneralLedger.Amount 
					ELSE GeneralLedger.Amount 
				END) = IndividualAmounts.Amount 
			WHERE 
				ValidationSummary.HasUnknownGlAccount = 1
			GROUP BY 
				IndividualAmounts.GlAccountCode,
				IndividualAmounts.EntityId,
				IndividualAmounts.Amount
			HAVING			
				SUM(GeneralLedger.Amount) = 0.0	
		) NonReclassedTransactions ON
			GeneralLedger.GlAccountCode = NonReclassedTransactions.GLAccountCode AND
			GeneralLedger.EntityId = NonReclassedTransactions.EntityId AND
			CASE 
				WHEN GeneralLedger.Amount < 0.0 THEN -1.0 * GeneralLedger.Amount
				ELSE GeneralLedger.Amount
			END = NonReclassedTransactions.Amount
		
	END	
		
	/* ================================================================================================================
		Global Categorization Unknowns
	=================================================================================================================*/
			
	BEGIN
	
	---------------------------------------------------------------------------------------
	-- Remove Global Categorization Hierarchy Unknowns from #ValidationSummary that have been re-classed 
	-- and now net out to 0
	---------------------------------------------------------------------------------------
	
	UPDATE ValidationSummary 
	SET
		HasUnknownCategorizationHierarchy = 0
	FROM 
	-- Step 3: Validation Summary Record where the account balance for that glaccount, entity and |amount| balances out to 0.0
		#ValidationSummary ValidationSummary
		INNER JOIN #GeneralLedger GeneralLedger ON
			ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
			ValidationSummary.SourceCode = GeneralLedger.SourceCode
		INNER JOIN (
			-- Step 2: Get a list of unknown transaction GL Account, Entity and Amount with an account balance of 0.00 for 
			-- that |amount|
			SELECT
				IndividualAmounts.GlAccountCode,
				IndividualAmounts.EntityId,
				IndividualAmounts.Amount
			FROM 
				#ValidationSummary ValidationSummary
			INNER JOIN #GeneralLedger GeneralLedger ON
				ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
				ValidationSummary.SourceCode = GeneralLedger.SourceCode
			INNER JOIN (
				-- Step 1: Get a distinct list of glaccountcode, entityid, |Amount|
				SELECT 
					GeneralLedger.GLAccountCode,
					GeneralLedger.EntityId, 
					CASE
						WHEN GeneralLedger.Amount < 0.0 THEN GeneralLedger.Amount * -1.0
						ELSE GeneralLedger.Amount
					END AS ''Amount''
				FROM #ValidationSummary ValidationSummary
				INNER JOIN #GeneralLedger GeneralLedger ON
					ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
					ValidationSummary.SourceCode = GeneralLedger.SourceCode
				WHERE
					ValidationSummary.HasUnknownCategorizationHierarchy = 1
				GROUP BY
					GeneralLedger.GlAccountCode,
					GeneralLedger.EntityId,
					CASE
						WHEN GeneralLedger.Amount < 0.0 THEN GeneralLedger.Amount * -1.0
						ELSE GeneralLedger.Amount
					END
			) IndividualAmounts ON
				GeneralLedger.GLAccountCode = IndividualAmounts.GLAccountCode AND
				GeneralLedger.EntityId = IndividualAmounts.EntityId AND
				(CASE 
					WHEN GeneralLedger.Amount < 0.0 THEN -1.0 * GeneralLedger.Amount 
					ELSE GeneralLedger.Amount 
				END) = IndividualAmounts.Amount 
			WHERE 
				ValidationSummary.HasUnknownCategorizationHierarchy = 1
			GROUP BY 
				IndividualAmounts.GlAccountCode,
				IndividualAmounts.EntityId,
				IndividualAmounts.Amount
			HAVING			
				SUM(GeneralLedger.Amount) = 0.0	
		) NonReclassedTransactions ON
			GeneralLedger.GlAccountCode = NonReclassedTransactions.GLAccountCode AND
			GeneralLedger.EntityId = NonReclassedTransactions.EntityId AND
			CASE 
				WHEN GeneralLedger.Amount < 0.0 THEN -1.0 * GeneralLedger.Amount
				ELSE GeneralLedger.Amount
			END = NonReclassedTransactions.Amount	
		
	END
	
	/* ================================================================================================================
		Originating Region Unknowns
	=================================================================================================================*/

	BEGIN
	
	---------------------------------------------------------------------------------------
	-- Remove OriginatingRegion Unknowns from #ValidationSummary that have been re-classed 
	-- and now net out to 0
	---------------------------------------------------------------------------------------
	
	UPDATE ValidationSummary 
	SET
		HasUnknownOriginatingRegion = 0
	FROM 
	-- Step 3: Validation Summary Record where the account balance for that glaccount, entity and |amount| balances out to 0.0
		#ValidationSummary ValidationSummary
		INNER JOIN #GeneralLedger GeneralLedger ON
			ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
			ValidationSummary.SourceCode = GeneralLedger.SourceCode
		INNER JOIN (
			-- Step 2: Get a list of unknown transaction GL Account, Entity and Amount with an account balance of 0.00 for 
			-- that |amount|
			SELECT
				IndividualAmounts.GlAccountCode,
				IndividualAmounts.EntityId,
				IndividualAmounts.Amount
			FROM 
				#ValidationSummary ValidationSummary
			INNER JOIN #GeneralLedger GeneralLedger ON
				ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
				ValidationSummary.SourceCode = GeneralLedger.SourceCode
			INNER JOIN (
				-- Step 1: Get a distinct list of glaccountcode, entityid, |Amount|
				SELECT 
					GeneralLedger.GLAccountCode,
					GeneralLedger.EntityId, 
					CASE
						WHEN GeneralLedger.Amount < 0.0 THEN GeneralLedger.Amount * -1.0
						ELSE GeneralLedger.Amount
					END AS ''Amount''
				FROM #ValidationSummary ValidationSummary
				INNER JOIN #GeneralLedger GeneralLedger ON
					ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
					ValidationSummary.SourceCode = GeneralLedger.SourceCode
				WHERE
					ValidationSummary.HasUnknownOriginatingRegion = 1
				GROUP BY
					GeneralLedger.GlAccountCode,
					GeneralLedger.EntityId,
					CASE
						WHEN GeneralLedger.Amount < 0.0 THEN GeneralLedger.Amount * -1.0
						ELSE GeneralLedger.Amount
					END
			) IndividualAmounts ON
				GeneralLedger.GLAccountCode = IndividualAmounts.GLAccountCode AND
				GeneralLedger.EntityId = IndividualAmounts.EntityId AND
				(CASE 
					WHEN GeneralLedger.Amount < 0.0 THEN -1.0 * GeneralLedger.Amount 
					ELSE GeneralLedger.Amount 
				END) = IndividualAmounts.Amount 
			WHERE 
				ValidationSummary.HasUnknownOriginatingRegion = 1
			GROUP BY 
				IndividualAmounts.GlAccountCode,
				IndividualAmounts.EntityId,
				IndividualAmounts.Amount
			HAVING			
				SUM(GeneralLedger.Amount) = 0.0	
		) NonReclassedTransactions ON
			GeneralLedger.GlAccountCode = NonReclassedTransactions.GLAccountCode AND
			GeneralLedger.EntityId = NonReclassedTransactions.EntityId AND
			CASE 
				WHEN GeneralLedger.Amount < 0.0 THEN -1.0 * GeneralLedger.Amount
				ELSE GeneralLedger.Amount
			END = NonReclassedTransactions.Amount	
		
	END
		
	/* ================================================================================================================
		Functional Department Unknowns
	=================================================================================================================*/
	
	BEGIN
	
	---------------------------------------------------------------------------------------
	-- Remove FunctionalDepartment Unknowns from #ValidationSummary that have been re-classed 
	-- and now net out to 0
	---------------------------------------------------------------------------------------
			
	UPDATE ValidationSummary 
	SET
		HasUnknownFunctionalDepartment = 0
	FROM 
	-- Validation Summary Record where the account balance for that glaccount, entity and |amount| balances out to 0.0
		#ValidationSummary ValidationSummary
		INNER JOIN #GeneralLedger GeneralLedger ON
			ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
			ValidationSummary.SourceCode = GeneralLedger.SourceCode
		INNER JOIN (
			-- Get a list of unknown transaction GL Account, Entity and Amount with an account balance of 0.00 for 
			-- that |amount|
			SELECT
				IndividualAmounts.GlAccountCode,
				IndividualAmounts.EntityId,
				IndividualAmounts.Amount
			FROM 
				#ValidationSummary ValidationSummary
			INNER JOIN #GeneralLedger GeneralLedger ON
				ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
				ValidationSummary.SourceCode = GeneralLedger.SourceCode
			INNER JOIN (
				-- Get a distinct list of glaccountcode, entityid, |Amount|
				SELECT 
					GeneralLedger.GLAccountCode,
					GeneralLedger.EntityId, 
					CASE
						WHEN GeneralLedger.Amount < 0.0 THEN GeneralLedger.Amount * -1.0
						ELSE GeneralLedger.Amount
					END AS ''Amount''
				FROM #ValidationSummary ValidationSummary
				INNER JOIN #GeneralLedger GeneralLedger ON
					ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
					ValidationSummary.SourceCode = GeneralLedger.SourceCode
				WHERE
					ValidationSummary.HasUnknownFunctionalDepartment = 1
				GROUP BY
					GeneralLedger.GlAccountCode,
					GeneralLedger.EntityId,
					CASE
						WHEN GeneralLedger.Amount < 0.0 THEN GeneralLedger.Amount * -1.0
						ELSE GeneralLedger.Amount
					END
			) IndividualAmounts ON
				GeneralLedger.GLAccountCode = IndividualAmounts.GLAccountCode AND
				GeneralLedger.EntityId = IndividualAmounts.EntityId AND
				(CASE 
					WHEN GeneralLedger.Amount < 0.0 THEN -1.0 * GeneralLedger.Amount 
					ELSE GeneralLedger.Amount 
				END) = IndividualAmounts.Amount 
			WHERE 
				ValidationSummary.HasUnknownFunctionalDepartment = 1
			GROUP BY 
				IndividualAmounts.GlAccountCode,
				IndividualAmounts.EntityId,
				IndividualAmounts.Amount
			HAVING			
				SUM(GeneralLedger.Amount) = 0.0	
		) NonReclassedTransactions ON
			GeneralLedger.GlAccountCode = NonReclassedTransactions.GLAccountCode AND
			GeneralLedger.EntityId = NonReclassedTransactions.EntityId AND
			CASE 
				WHEN GeneralLedger.Amount < 0.0 THEN -1.0 * GeneralLedger.Amount
				ELSE GeneralLedger.Amount
			END = NonReclassedTransactions.Amount	
		
	END
			
	/* ================================================================================================================
		Property Fund Unknowns
	=================================================================================================================*/

	BEGIN
	
	---------------------------------------------------------------------------------------
	-- Remove PropertyFund Unknowns from #ValidationSummary that have been re-classed 
	-- and now net out to 0
	---------------------------------------------------------------------------------------
		
	UPDATE ValidationSummary 
	SET
		HasUnknownPropertyFund = 0
	FROM 
	-- Step 3: Validation Summary Record where the account balance for that glaccount, entity and |amount| balances out to 0.0
		#ValidationSummary ValidationSummary
		INNER JOIN #GeneralLedger GeneralLedger ON
			ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
			ValidationSummary.SourceCode = GeneralLedger.SourceCode
		INNER JOIN (
			-- Step 2: Get a list of unknown transaction GL Account, Entity and Amount with an account balance of 0.00 for 
			-- that |amount|
			SELECT
				IndividualAmounts.GlAccountCode,
				IndividualAmounts.EntityId,
				IndividualAmounts.Amount
			FROM 
				#ValidationSummary ValidationSummary
			INNER JOIN #GeneralLedger GeneralLedger ON
				ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
				ValidationSummary.SourceCode = GeneralLedger.SourceCode
			INNER JOIN (
				-- Step 1: Get a distinct list of glaccountcode, entityid, |Amount|
				SELECT 
					GeneralLedger.GLAccountCode,
					GeneralLedger.EntityId, 
					CASE
						WHEN GeneralLedger.Amount < 0.0 THEN GeneralLedger.Amount * -1.0
						ELSE GeneralLedger.Amount
					END AS ''Amount''
				FROM #ValidationSummary ValidationSummary
				INNER JOIN #GeneralLedger GeneralLedger ON
					ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
					ValidationSummary.SourceCode = GeneralLedger.SourceCode
				WHERE
					ValidationSummary.HasUnknownPropertyFund = 1
				GROUP BY
					GeneralLedger.GlAccountCode,
					GeneralLedger.EntityId,
					CASE
						WHEN GeneralLedger.Amount < 0.0 THEN GeneralLedger.Amount * -1.0
						ELSE GeneralLedger.Amount
					END
			) IndividualAmounts ON
				GeneralLedger.GLAccountCode = IndividualAmounts.GLAccountCode AND
				GeneralLedger.EntityId = IndividualAmounts.EntityId AND
				(CASE 
					WHEN GeneralLedger.Amount < 0.0 THEN -1.0 * GeneralLedger.Amount 
					ELSE GeneralLedger.Amount 
				END) = IndividualAmounts.Amount 
			WHERE 
				ValidationSummary.HasUnknownPropertyFund = 1
			GROUP BY 
				IndividualAmounts.GlAccountCode,
				IndividualAmounts.EntityId,
				IndividualAmounts.Amount
			HAVING			
				SUM(GeneralLedger.Amount) = 0.0	
		) NonReclassedTransactions ON
			GeneralLedger.GlAccountCode = NonReclassedTransactions.GLAccountCode AND
			GeneralLedger.EntityId = NonReclassedTransactions.EntityId AND
			CASE 
				WHEN GeneralLedger.Amount < 0.0 THEN -1.0 * GeneralLedger.Amount
				ELSE GeneralLedger.Amount
			END = NonReclassedTransactions.Amount	
			
	END
	
	/* ================================================================================================================
		STEP 4: VALIDATE ENTITY - ACTIVITYTYPE COMBINATION
		
		 The holistic review export temp stored procedure summarises which combinations
		 of:
		 
		 Project,
		 Activity Type,
		 PropertyFund, 
		 Allocation Sub Region,
		 Corporate Department,
		 Reporting Entity, 
		 Property Entity
		 
		 has been created in AM
		 
		 We only allow transactions for entity - activity type combinations that:
		 
		 1. Exist in AM
		 2. Has been explicitly defined by Martin, as per IMS 56718
	=================================================================================================================*/

	BEGIN
		
	IF OBJECT_ID(''tempdb..#HolisticReviewExportTemp'') IS NOT NULL
		DROP TABLE #HolisticReviewExportTemp

	CREATE TABLE #HolisticReviewExportTemp
	(	
		ProjectCode VARCHAR(20) NULL,
		ProjectName VARCHAR(100) NULL,
		ProjectEndPeriod INT NULL,
		ActivityType VARCHAR(50) NULL,
		PropertyFund VARCHAR(100) NULL,
		RelatedFund VARCHAR(100) NULL,
		PropertyFundAllocationSubRegionName VARCHAR(50) NULL,
		Source CHAR(2) NULL,
		AllocationType VARCHAR(100) NULL,
		CorporateDepartment CHAR(8) NULL,
		CorporateDepartmentDescription VARCHAR(50) NULL,
		ReportingEntity VARCHAR(100) NULL,
		ReportingEntityAllocationSubRegionName varchar(50) NULL,
		EntityType VARCHAR(50) NULL,
		BudgetOwner VARCHAR(255) NULL,
		RegionalOwner VARCHAR(255) NULL,
		BudgetCoordinatorDisplayNames nvarchar(MAX) NULL,
		IsTSCost VARCHAR(3) NULL,
		PropertyEntity CHAR(6) NULL,
		PropertyEntityName NVARCHAR(264) NULL
	)

	SET XACT_ABORT ON

	-- Get actuals
	INSERT INTO #HolisticReviewExportTemp
	EXEC SERVER3.GDM.dbo.HolisticReviewExport

	-- Get budget
	INSERT INTO #HolisticReviewExportTemp
	EXEC SERVER3.GDM.dbo.HolisticReviewExport @BudgetAllocationSetId=@BudgetAllocationSetId

	-- Get a distinct list of valid combinations of
	--	activity type
	--	allocation type
	--	reporting entity
	-- as projects have been set up in AM
	SELECT DISTINCT 
		ValidEntityActivityTypeCombinations.ActivityType ActivityTypeName,
		ValidEntityActivityTypeCombinations.AllocationType AllocationTypeName,
		ValidEntityActivityTypeCombinations.ReportingEntity ReportingEntityName
	INTO #ValidActivityTypeEntity
	FROM 
		#HolisticReviewExportTemp ValidEntityActivityTypeCombinations
		
	-- IMS 56718: Martin has specified additional entries that are also
	-- valid, even though they have no projects in AM
	INSERT INTO #ValidActivityTypeEntity
	SELECT 
		AdditionalMappings.ActivityTypeName, 
		AdditionalMappings.AllocationTypeName,
		AdditionalMappings.ReportingEntityName
	FROM 
		dbo.AdditionalValidCombinationsForEntityActivity AdditionalMappings
		LEFT OUTER JOIN #ValidActivityTypeEntity AMMappings ON 
			 AdditionalMappings.ReportingEntityName = AMMappings.ReportingEntityName AND
			 AdditionalMappings.ActivityTypeName = AMMappings.ActivityTypeName AND
			 AdditionalMappings.AllocationTypeName = AMMappings.AllocationTypeName
	WHERE 
		AMMappings.AllocationTypeName IS NULL

	SELECT
		[Source].SourceCode,
		ProfitabilityActual.ReferenceCode,
		ValidActivityTypeEntity.AllocationTypeName,
		REPLACE(GlobalHierarchy.GLFinancialCategoryName, ''_'', '''') FinancialCategoryName,
		ValidActivityTypeEntity.ActivityTypeName ValidationActivityTypeName,
		ActivityType.ActivityTypeName LocalActivityTypeName,
		ValidActivityTypeEntity.ReportingEntityName,
		PropertyFund.PropertyFundName
	INTO 
		#InValidActivityTypeAndEntityCombination
	FROM
		dbo.ProfitabilityActual
		INNER JOIN Calendar ON
			ProfitabilityActual.CalendarKey = Calendar.CalendarKey  
		INNER JOIN dbo.GLCategorizationHierarchy GlobalHierarchy ON
			ProfitabilityActual.GlobalGLCategorizationHierarchyKey = GlobalHierarchy.GLCategorizationHierarchyKey
		INNER JOIN dbo.[Source] ON 
			ProfitabilityActual.SourceKey = [Source].SourceKey
		INNER JOIN dbo.Overhead ON
			ProfitabilityActual.OverheadKey = Overhead.OverheadKey
		INNER JOIN dbo.PropertyFund ON
			ProfitabilityActual.PropertyFundKey = PropertyFund.PropertyFundKey
		INNER JOIN dbo.ActivityType ON
			ProfitabilityActual.ActivityTypeKey = ActivityType.ActivityTypeKey
		LEFT OUTER JOIN #ValidActivityTypeEntity ValidActivityTypeEntity ON
			-- HANDLE CORPORATE OVERHEAD SEPARATELY
			(
				-- GR
				GlobalHierarchy.GLMajorCategoryName <> ''Salaries/Taxes/Benefits'' AND
				Overhead.OverheadCode = ''UNALLOC'' AND
				GlobalHierarchy.GLFinancialCategoryName = ''Overhead'' AND
				
				-- AM
				ValidActivityTypeEntity.AllocationTypeName = ''NonPayroll'' AND
				ValidActivityTypeEntity.ActivityTypeName = ''Corporate Overhead'' AND
				ValidActivityTypeEntity.ReportingEntityName = PropertyFund.PropertyFundName
			) OR
			(
				-- GR
				GlobalHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits'' AND
				Overhead.OverheadCode = ''UNALLOC'' AND
				GlobalHierarchy.GLFinancialCategoryName = ''Overhead'' AND
				
				-- AM
				ValidActivityTypeEntity.AllocationTypeName = ''Payroll'' AND
				ValidActivityTypeEntity.ActivityTypeName = ''Corporate Overhead'' AND
				ValidActivityTypeEntity.ReportingEntityName = PropertyFund.PropertyFundName		
			) OR
			-- ALL OTHER TRANSACTIONS
			(
				ValidActivityTypeEntity.AllocationTypeName = REPLACE(GlobalHierarchy.GLFinancialCategoryName, ''-'', '''') AND
				ValidActivityTypeEntity.ActivityTypeName = ActivityType.ActivityTypeName AND
				ValidActivityTypeEntity.ReportingEntityName = PropertyFund.PropertyFundName
			)
	WHERE
		Calendar.CalendarPeriod BETWEEN @StartPeriod AND @EndPeriod AND
		-- Calendar.CalendarPeriod BETWEEN 201101 AND 201103 AND
		ValidActivityTypeEntity.ActivityTypeName IS NULL AND
		NOT (
			Overhead.OverheadCode = ''ALLOC'' AND
			GlobalHierarchy.GLFinancialCategoryName = ''Overhead''
		) AND
		GlobalHierarchy.GLMinorCategoryName <> ''Architects & Engineering'' AND
		Calendar.CalendarPeriod >= 201007 AND
		GlobalHierarchy.InflowOutflow IN (
			''Outflow'', 
			''UNKNOWN''
		) AND
		ProfitabilityActual.ReferenceCode NOT LIKE ''%BillingUploadDetailId%'' AND
		NOT (
			PropertyFund.PropertyFundType IN (
				''Property'', 
				''3rd party property''
			) AND
			ActivityType.ActivityTypeCode IN (
				''PMN'', 
				''AMA'', 
				''PME'', 
				''LEASE''
			)
		) --IMS #62502
		
	------------------------------------------------------------------------	
	-- Remove invalid activity type and entity combinations fixed by reclass
	------------------------------------------------------------------------
	
	DELETE InvalidCombo
	FROM 
		#InValidActivityTypeAndEntityCombination InvalidCombo
	INNER JOIN #GeneralLedger GeneralLedger ON
		InvalidCombo.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
		InvalidCombo.SourceCode = GeneralLedger.SourceCode
	INNER JOIN (
		-- Get all transactions per glaccount, entity and amount size that balance out to 0.00
		SELECT
			GeneralLedger.GlAccountCode,
			GeneralLedger.EntityId,
			InvalidAmounts.Amount
		FROM 
			#InValidActivityTypeAndEntityCombination InvalidCombo
			INNER JOIN #GeneralLedger GeneralLedger ON
				InvalidCombo.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
				InvalidCombo.SourceCode = GeneralLedger.SourceCode
			INNER JOIN (
				-- Get a distinct list of glaccountcode, entityid, |Amount|
				SELECT
					GeneralLedger.GlAccountCode,
					GeneralLedger.EntityId,
					CASE
						WHEN GeneralLedger.Amount < 0.0 THEN GeneralLedger.Amount * -1.0
						ELSE GeneralLedger.Amount
					END AS ''Amount''
				FROM 
					#InValidActivityTypeAndEntityCombination InvalidCombo
					INNER JOIN #GeneralLedger GeneralLedger ON
						InvalidCombo.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
						InvalidCombo.SourceCode = GeneralLedger.SourceCode
				GROUP BY
					GeneralLedger.GlAccountCode,
					GeneralLedger.EntityId,
					CASE
						WHEN GeneralLedger.Amount < 0.0 THEN GeneralLedger.Amount * -1.0
						ELSE GeneralLedger.Amount
					END
			) InvalidAmounts ON
				GeneralLedger.GlAccountCode = InvalidAmounts.GlAccountCode AND
				GeneralLedger.EntityId = InvalidAmounts.EntityId AND
				(CASE 
					WHEN GeneralLedger.Amount < 0.0 THEN -1.0 * GeneralLedger.Amount 
					ELSE GeneralLedger.Amount 
				END) = InvalidAmounts.Amount 
		GROUP BY
			GeneralLedger.GlAccountCode,
			GeneralLedger.EntityId,
			InvalidAmounts.Amount
		HAVING
			SUM(GeneralLedger.Amount) = 0.0
	) ValidatedCombinations ON
		GeneralLedger.GlAccountCode = ValidatedCombinations.GlAccountCode AND
		GeneralLedger.EntityId = ValidatedCombinations.EntityId AND
		(CASE 
			WHEN GeneralLedger.Amount < 0.0 THEN -1.0 * GeneralLedger.Amount 
			ELSE GeneralLedger.Amount 
		END) = ValidatedCombinations.Amount 
		
	------------------------------------------------------------------------	
	-- Remove Old Reporting Entity Names
	------------------------------------------------------------------------

	DELETE FROM #InValidActivityTypeAndEntityCombination
	WHERE 
		LTRIM(RTRIM(PropertyFundName)) IN (
			SELECT ''ECM Business Development'' AS ''ReportingEntity'' UNION
			SELECT ''Employee Reimbursables'' AS ''ReportingEntity'' UNION
			SELECT ''US CORP TBD'' AS ''ReportingEntity''
	)
	
	------------------------------------------------------------------------	
	-- Update #ValidationSummary with invalid combinations
	------------------------------------------------------------------------

	UPDATE ValidationSummary 
	SET
		InvalidActivityTypeAndEntity = 1	
	FROM 
		#ValidationSummary ValidationSummary
	INNER JOIN #InValidActivityTypeAndEntityCombination InvalidCombination ON
		ValidationSummary.ReferenceCode = InvalidCombination.ReferenceCode AND
		ValidationSummary.SourceCode = InvalidCombination.SourceCode
		
	------------------------------------------------------------------------	
	-- Insert records without unknowns but invalid entity/activity type combinations
	-- into validation summary
	------------------------------------------------------------------------
	
	INSERT INTO #ValidationSummary
	SELECT 
		[Source].SourceCode AS ''SourceCode'',
		ProfitabilityActual.ProfitabilityActualKey AS ''ProfitabilityActualKey'',
		ProfitabilityActual.ReferenceCode AS ''ReferenceCode'',
		0 AS ''HasUnknownActivityType'',
		0 AS ''HasUnknownAllocationRegion'',
		0 AS ''HasUnknownGLAccount'',
		0 AS ''HasUnknownCategorizationHierarchy'',
		0 AS ''HasUnknownFunctionalDepartment'',
		0 AS ''HasUnknownOriginatingRegion'',
		0 AS ''HasUnknownPropertyFund'',	
		0 AS ''InValidOriginatingRegionAndFunctionalDepartment'',
		0 AS ''InValidGLAccountAndFunctionalDepartment'',  
		1 AS ''InValidActivityTypeAndEntity''		
	FROM	
		dbo.ProfitabilityActual
		INNER JOIN dbo.[Source] ON
			ProfitabilityActual.SourceKey = [Source].SourceKey
		INNER JOIN #InValidActivityTypeAndEntityCombination InvalidCombo ON
			ProfitabilityActual.ReferenceCode = InvalidCombo.ReferenceCode AND
			[Source].SourceCode = InvalidCombo.SourceCode
		LEFT OUTER JOIN #ValidationSummary Existing ON
			[Source].SourceCode = Existing.SourceCode AND
			ProfitabilityActual.ReferenceCode = Existing.ReferenceCode
		INNER JOIN dbo.Calendar ON
			ProfitabilityActual.CalendarKey = Calendar.CalendarKey
		INNER JOIN dbo.GLCategorizationHierarchy GlobalHierarchy ON
			ProfitabilityActual.GlobalGLCategorizationHierarchyKey = GlobalHierarchy.GLCategorizationHierarchyKey
		INNER JOIN #SourceFilter ON
			Source.SourceCode = #SourceFilter.SourceCode
	WHERE
		Calendar.CalendarPeriod BETWEEN @StartPeriod AND @EndPeriod AND
		Calendar.CalendarPeriod >= 201107 AND
		Existing.ReferenceCode IS NULL AND
		GlobalHierarchy.GLMinorCategoryName <> ''Architects & Engineering''
		
	END
		
	/* ================================================================================================================
		STEP 5: Validate OriginatingRegion & FunctionalDepartment Combination		
		
		The functional department - originating region combination is only invalid if the functional department is
		restricted for ALL the corporate entities in that originating region. We therefore count the corporate entities
		mapped against the corporate department, and compare that to the count of corporate entities restricted
		for a functional department in that originating region.
	=================================================================================================================*/
	
BEGIN

	------------------------------------------------------------------------	
	-- Get the snapshotid from the budgetallocationsetId
	------------------------------------------------------------------------	

	DECLARE @SnapshotId INT = (
		SELECT
			SnapshotId
		FROM GrReportingStaging.gdm.Snapshot
		WHERE 
			GroupKey = @BudgetAllocationSetId
		)
			
	------------------------------------------------------------------------	
	-- Update all profitability actual transactions in the validation summary 
	-- where the functional department - originating region
	-- combination is invalid
	------------------------------------------------------------------------	
	UPDATE ValidationSummary
		SET
			InValidOriginatingRegionAndFunctionalDepartment = 1
	FROM #ValidationSummary ValidationSummary
		INNER JOIN dbo.ProfitabilityActual ON
			ValidationSummary.ProfitabilityActualKey = ProfitabilityActual.ProfitabilityActualKey
		INNER JOIN dbo.FunctionalDepartment ON	
			ProfitabilityActual.FunctionalDepartmentKey = FunctionalDepartment.FunctionalDepartmentKey
		INNER JOIN dbo.OriginatingRegion ON
			ProfitabilityActual.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey
		LEFT OUTER JOIN (
			-- get a list of functional for which all the corporate entities is restricted in a global region
			-- the global region - functional department combination is then restricted
			SELECT
				FunctionalDepartmentGlobalRegionCount.FunctionalDepartmentCode AS ''FunctionalDepartmentCode'',
				GlobalRegion.Code AS ''GlobalRegionCode''
			FROM (
				-- Get a count of corporate entities restricted for each functional department per originating region
				SELECT
					FunctionalDepartment.GlobalCode AS ''FunctionalDepartmentCode'',
					OriginatingRegionCorporateEntity.GlobalRegionId,
					COUNT(
						RestrictedCombinations.CorporateEntitySourceCode + 
						RestrictedCombinations.CorporateEntityCode
					) AS ''CorporateEntityRestrictionsCount''
				FROM 
					GrReportingStaging.Gdm.SnapshotRestrictedFunctionalDepartmentCorporateEntity RestrictedCombinations
				INNER JOIN GrReportingStaging.HR.FunctionalDepartment FunctionalDepartment ON
					RestrictedCombinations.FunctionalDepartmentId = FunctionalDepartment.FunctionalDepartmentId
				INNER JOIN GrReportingStaging.GDM.SnapshotOriginatingRegionCorporateEntity OriginatingRegionCorporateEntity ON
					RestrictedCombinations.CorporateEntityCode = OriginatingRegionCorporateEntity.CorporateEntityCode AND
					RestrictedCombinations.CorporateEntitySourceCode = OriginatingRegionCorporateEntity.SourceCode
				WHERE 
					FunctionalDepartment.IsActive = 1 AND
					RestrictedCombinations.SnapshotId = @SnapshotId AND
					OriginatingRegionCorporateEntity.SnapshotId = @SnapshotId
				GROUP BY 
					FunctionalDepartment.GlobalCode,
					GlobalRegionId
			) FunctionalDepartmentGlobalRegionCount
			INNER JOIN (
				-- Get a count of corporate entities per originating region
				SELECT
					GlobalRegionId,
					COUNT(OriginatingRegionCorporateEntity.SourceCode + CorporateEntityCode) AS CorporateEntitiesPerRegion
				FROM 
					GrReportingStaging.GDM.SnapshotOriginatingRegionCorporateEntity OriginatingRegionCorporateEntity
				WHERE
					OriginatingRegionCorporateEntity.SnapshotId = @SnapshotId
				GROUP BY
					GlobalRegionId
			) GlobalRegionCorporateEntityCount ON
				FunctionalDepartmentGlobalRegionCount.GlobalRegionId = GlobalRegionCorporateEntityCount.GlobalRegionId
			INNER JOIN GrReportingStaging.Gdm.GlobalRegion GlobalRegion ON
				FunctionalDepartmentGlobalRegionCount.GlobalRegionId = GlobalRegion.GlobalRegionId
			WHERE
				FunctionalDepartmentGlobalRegionCount.CorporateEntityRestrictionsCount = GlobalRegionCorporateEntityCount.CorporateEntitiesPerRegion
		) InvalidFunctionalDepartmentOriginatingRegion ON
			FunctionalDepartment.FunctionalDepartmentCode = InvalidFunctionalDepartmentOriginatingRegion.FunctionalDepartmentCode AND
			OriginatingRegion.SubRegionCode = InvalidFunctionalDepartmentOriginatingRegion.GlobalRegionCode
		LEFT OUTER JOIN dbo.AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment ON
			OriginatingRegion.SubRegionName = AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment.OriginatingSubRegionName AND
			FunctionalDepartment.FunctionalDepartmentName = AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment.FunctionalDepartmentName
	WHERE
		InvalidFunctionalDepartmentOriginatingRegion.FunctionalDepartmentCode IS NOT NULL AND
		InvalidFunctionalDepartmentOriginatingRegion.GlobalRegionCode IS NOT NULL AND
		AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment.FunctionalDepartmentName IS NULL AND
		AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment.OriginatingSubRegionName IS NULL

	------------------------------------------------------------------------	
	-- add all profitability actual transactions TO validation summary where 
	-- the functional department - originating region
	-- combination is invalid and they are not in the validation summary yet
	------------------------------------------------------------------------	
	
	INSERT INTO #ValidationSummary
	SELECT
		[Source].SourceCode AS ''SourceCode'',
		ProfitabilityActual.ProfitabilityActualKey AS ''ProfitabilityActualKey'',
		ProfitabilityActual.ReferenceCode AS ''ReferenceCode'',
		0 AS ''HasUnknownActivityType'',
		0 AS ''HasUnknownAllocationRegion'',
		0 AS ''HasUnknownGLAccount'',
		0 AS ''HasUnknownCategorizationHierarchy'',
		0 AS ''HasUnknownFunctionalDepartment'',
		0 AS ''HasUnknownOriginatingRegion'',
		0 AS ''HasUnknownPropertyFund'',	
		1 AS ''InValidOriginatingRegionAndFunctionalDepartment'',
		0 AS ''InValidGLAccountAndFunctionalDepartment'',  
		0 AS ''InValidActivityTypeAndEntity''		
	FROM	
		dbo.ProfitabilityActual
		INNER JOIN dbo.[Source] ON
			ProfitabilityActual.SourceKey = [Source].SourceKey
		LEFT OUTER JOIN #ValidationSummary Existing ON
			[Source].SourceCode = Existing.SourceCode AND
			ProfitabilityActual.ReferenceCode = Existing.ReferenceCode
		INNER JOIN dbo.Calendar ON
			ProfitabilityActual.CalendarKey = Calendar.CalendarKey
		INNER JOIN dbo.GLCategorizationHierarchy GlobalHierarchy ON
			ProfitabilityActual.GlobalGLCategorizationHierarchyKey = GlobalHierarchy.GLCategorizationHierarchyKey
		INNER JOIN dbo.FunctionalDepartment ON	
			ProfitabilityActual.FunctionalDepartmentKey = FunctionalDepartment.FunctionalDepartmentKey
		INNER JOIN dbo.OriginatingRegion ON
			ProfitabilityActual.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey
		LEFT OUTER JOIN (
			-- get a list of functional for which all the corporate entities is restricted in a global region
			-- the global region - functional department combination is then restricted
			SELECT
				FunctionalDepartmentGlobalRegionCount.FunctionalDepartmentCode AS ''FunctionalDepartmentCode'',
				GlobalRegion.Code AS ''GlobalRegionCode''
			FROM (
				-- Get a count of corporate entities restricted for each functional department per originating region
				SELECT
					FunctionalDepartment.GlobalCode AS ''FunctionalDepartmentCode'',
					OriginatingRegionCorporateEntity.GlobalRegionId,
					COUNT(
						RestrictedCombinations.CorporateEntitySourceCode + 
						RestrictedCombinations.CorporateEntityCode
					) AS ''CorporateEntityRestrictionsCount''
				FROM 
					GrReportingStaging.Gdm.SnapshotRestrictedFunctionalDepartmentCorporateEntity RestrictedCombinations
				INNER JOIN GrReportingStaging.HR.FunctionalDepartment FunctionalDepartment ON
					RestrictedCombinations.FunctionalDepartmentId = FunctionalDepartment.FunctionalDepartmentId
				INNER JOIN GrReportingStaging.GDM.SnapshotOriginatingRegionCorporateEntity OriginatingRegionCorporateEntity ON
					RestrictedCombinations.CorporateEntityCode = OriginatingRegionCorporateEntity.CorporateEntityCode AND
					RestrictedCombinations.CorporateEntitySourceCode = OriginatingRegionCorporateEntity.SourceCode
				WHERE 
					FunctionalDepartment.IsActive = 1 AND
					RestrictedCombinations.SnapshotId = @SnapshotId AND
					OriginatingRegionCorporateEntity.SnapshotId = @SnapshotId
				GROUP BY 
					FunctionalDepartment.GlobalCode,
					GlobalRegionId
			) FunctionalDepartmentGlobalRegionCount
			INNER JOIN (
				-- Get a count of corporate entities per originating region
				SELECT
					GlobalRegionId,
					COUNT(OriginatingRegionCorporateEntity.SourceCode + CorporateEntityCode) AS CorporateEntitiesPerRegion
				FROM 
					GrReportingStaging.GDM.SnapshotOriginatingRegionCorporateEntity OriginatingRegionCorporateEntity
				WHERE
					OriginatingRegionCorporateEntity.SnapshotId = @SnapshotId
				GROUP BY
					GlobalRegionId
			) GlobalRegionCorporateEntityCount ON
				FunctionalDepartmentGlobalRegionCount.GlobalRegionId = GlobalRegionCorporateEntityCount.GlobalRegionId
			INNER JOIN GrReportingStaging.Gdm.GlobalRegion GlobalRegion ON
				FunctionalDepartmentGlobalRegionCount.GlobalRegionId = GlobalRegion.GlobalRegionId
			WHERE
				FunctionalDepartmentGlobalRegionCount.CorporateEntityRestrictionsCount = GlobalRegionCorporateEntityCount.CorporateEntitiesPerRegion
		) InvalidFunctionalDepartmentOriginatingRegion ON
		FunctionalDepartment.FunctionalDepartmentCode = InvalidFunctionalDepartmentOriginatingRegion.FunctionalDepartmentCode AND
		OriginatingRegion.SubRegionCode = InvalidFunctionalDepartmentOriginatingRegion.GlobalRegionCode
		LEFT OUTER JOIN dbo.AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment ON
			OriginatingRegion.SubRegionName = AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment.OriginatingSubRegionName AND
			FunctionalDepartment.FunctionalDepartmentName = AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment.FunctionalDepartmentName
	WHERE
		Calendar.CalendarPeriod BETWEEN @StartPeriod AND @EndPeriod AND
		Existing.ReferenceCode IS NULL AND
		GlobalHierarchy.GLMinorCategoryName <> ''Architects & Engineering'' AND
		InvalidFunctionalDepartmentOriginatingRegion.FunctionalDepartmentCode IS NOT NULL AND
		InvalidFunctionalDepartmentOriginatingRegion.GlobalRegionCode IS NOT NULL AND
		AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment.FunctionalDepartmentName IS NULL AND
		AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment.OriginatingSubRegionName IS NULL
		
	END

	
	/* ================================================================================================================
		STEP 6: Validate FunctionalDepartment & GL Global Account Combination	
		
		The RestrictedFunctionalDepartmentGLGlobalAccount table in GDM handles two scenario''s:
		
		1. The FunctionalDepartmentId is null - the GLGlobalAccount is restricted for all functional departments	
	=================================================================================================================*/
	
	BEGIN
	
	UPDATE ValidationSummary
		SET 
			InvalidGLAccountAndFunctionalDepartment = 1
	FROM #ValidationSummary ValidationSummary
		INNER JOIN dbo.ProfitabilityActual ON
			ValidationSummary.ProfitabilityActualKey = ProfitabilityActual.ProfitabilityActualKey
		INNER JOIN dbo.FunctionalDepartment ON	
			ProfitabilityActual.FunctionalDepartmentKey = FunctionalDepartment.FunctionalDepartmentKey
		INNER JOIN dbo.GLCategorizationHierarchy GlobalHierarchy ON
			ProfitabilityActual.GlobalGLCategorizationHierarchyKey = GlobalHierarchy.GLCategorizationHierarchyKey
		INNER JOIN (
			SELECT 
				GLGlobalAccount.Code AS ''GLGlobalAccountCode'',
				FunctionalDepartment.GlobalCode AS ''FunctionalDepartmentGlobalCode''
			FROM GrReportingStaging.GDM.RestrictedFunctionalDepartmentGLGlobalAccount
			INNER JOIN GrReportingStaging.GDM.RestrictedFunctionalDepartmentGLGlobalAccountActive(@DataPriorToDate) ActiveRestrictedFunctionalDepartmentGlGlobalAccount ON
				RestrictedFunctionalDepartmentGLGlobalAccount.ImportKey = ActiveRestrictedFunctionalDepartmentGlGlobalAccount.ImportKey
			LEFT OUTER JOIN GrReportingStaging.HR.FunctionalDepartment FunctionalDepartment ON
				RestrictedFunctionalDepartmentGLGlobalAccount.FunctionalDepartmentId = FunctionalDepartment.FunctionalDepartmentId
			LEFT OUTER JOIN GrReportingStaging.HR.FunctionalDepartmentActive(@DataPriorToDate) FunctionalDepartmentActive ON
				FunctionalDepartment.ImportKey = FunctionalDepartmentActive.ImportKey
			INNER JOIN GrReportingStaging.GDM.GLGlobalAccount ON
				RestrictedFunctionalDepartmentGLGlobalAccount.GLGlobalAccountId = GLGlobalAccount.GLGlobalAccountId
			INNER JOIN GrReportingStaging.GDM.GLGlobalAccountActive(@DataPriorToDate) GLGlobalAccountActive ON
				GLGlobalAccount.ImportKey = GLGlobalAccountActive.ImportKey
		) InvalidCombinations ON
			GlobalHierarchy.GLAccountCode = InvalidCombinations.GLGlobalAccountCode AND 
			FunctionalDepartment.FunctionalDepartmentCode =
			CASE
				WHEN InvalidCombinations.FunctionalDepartmentGlobalCode IS NULL THEN FunctionalDepartment.FunctionalDepartmentCode 
				ELSE InvalidCombinations.FunctionalDepartmentGlobalCode
			END
			
			INSERT INTO #ValidationSummary
			SELECT
				[Source].SourceCode AS ''SourceCode'',
				ProfitabilityActual.ProfitabilityActualKey AS ''ProfitabilityActualKey'',
				ProfitabilityActual.ReferenceCode AS ''ReferenceCode'',
				0 AS ''HasUnknownActivityType'',
				0 AS ''HasUnknownAllocationRegion'',
				0 AS ''HasUnknownGLAccount'',
				0 AS ''HasUnknownCategorizationHierarchy'',
				0 AS ''HasUnknownFunctionalDepartment'',
				0 AS ''HasUnknownOriginatingRegion'',
				0 AS ''HasUnknownPropertyFund'',	
				0 AS ''InValidOriginatingRegionAndFunctionalDepartment'',
				1 AS ''InValidGLAccountAndFunctionalDepartment'',  
				0 AS ''InValidActivityTypeAndEntity''		
			FROM ProfitabilityActual
			INNER JOIN [Source] ON
				ProfitabilityActual.SourceKey = [Source].SourceKey
			INNER JOIN FunctionalDepartment ON	
				ProfitabilityActual.FunctionalDepartmentKey = FunctionalDepartment.FunctionalDepartmentKey
			INNER JOIN GLCategorizationHierarchy GlobalHierarchy ON
				ProfitabilityActual.GlobalGLCategorizationHierarchyKey = GlobalHierarchy.GLCategorizationHierarchyKey
			LEFT OUTER JOIN #ValidationSummary Existing ON
				[Source].SourceCode = Existing.SourceCode AND
				ProfitabilityActual.ReferenceCode = Existing.ReferenceCode
			INNER JOIN Calendar ON
				ProfitabilityActual.CalendarKey = Calendar.CalendarKey
			INNER JOIN (
				SELECT 
					GLGlobalAccount.Code AS ''GLGlobalAccountCode'',
					FunctionalDepartment.GlobalCode AS ''FunctionalDepartmentGlobalCode''
				FROM GrReportingStaging.GDM.RestrictedFunctionalDepartmentGLGlobalAccount
				INNER JOIN GrReportingStaging.GDM.RestrictedFunctionalDepartmentGLGlobalAccountActive(@DataPriorToDate) ActiveRestrictedFunctionalDepartmentGlGlobalAccount ON
					RestrictedFunctionalDepartmentGLGlobalAccount.ImportKey = ActiveRestrictedFunctionalDepartmentGlGlobalAccount.ImportKey
				LEFT OUTER JOIN GrReportingStaging.HR.FunctionalDepartment FunctionalDepartment ON
					RestrictedFunctionalDepartmentGLGlobalAccount.FunctionalDepartmentId = FunctionalDepartment.FunctionalDepartmentId
				LEFT OUTER JOIN GrReportingStaging.HR.FunctionalDepartmentActive(@DataPriorToDate) FunctionalDepartmentActive ON
					FunctionalDepartment.ImportKey = FunctionalDepartmentActive.ImportKey
				INNER JOIN GrReportingStaging.GDM.GLGlobalAccount ON
					RestrictedFunctionalDepartmentGLGlobalAccount.GLGlobalAccountId = GLGlobalAccount.GLGlobalAccountId
				INNER JOIN GrReportingStaging.GDM.GLGlobalAccountActive(@DataPriorToDate) GLGlobalAccountActive ON
					GLGlobalAccount.ImportKey = GLGlobalAccountActive.ImportKey
			) InvalidCombinations ON
				GlobalHierarchy.GLAccountCode = InvalidCombinations.GLGlobalAccountCode AND 
				FunctionalDepartment.FunctionalDepartmentCode =
				CASE
					WHEN InvalidCombinations.FunctionalDepartmentGlobalCode IS NULL THEN FunctionalDepartment.FunctionalDepartmentCode 
					ELSE InvalidCombinations.FunctionalDepartmentGlobalCode
				END	
		WHERE
			Calendar.CalendarPeriod BETWEEN @StartPeriod AND @EndPeriod AND
			Existing.ReferenceCode IS NULL AND
			GlobalHierarchy.GLMinorCategoryName <> ''Architects & Engineering''
	
	END	
	
	/* ================================================================================================================
		STEP 6.5: REMOVE ALL INFLOW Transactions
		
		Global ''Inflow'' accounts have a local gl account code starting with 4xxxxx
	=================================================================================================================*/
	
	BEGIN
	
		DELETE ValidationSummary 
		FROM 
			#ValidationSummary ValidationSummary
		INNER JOIN ProfitabilityActual ON
			ValidationSummary.ProfitabilityActualKey = ProfitabilityActual.ProfitabilityActualKey
		INNER JOIN GLCategorizationHierarchy ON 
			ProfitabilityActual.GlobalGLCategorizationHierarchyKey = GLCategorizationHierarchy.GLCategorizationHierarchyKey
		INNER JOIN #GeneralLedger GeneralLedger ON 
			ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
			ValidationSummary.SourceCode = GeneralLedger.SourceCode
		WHERE 
			GLCategorizationHierarchy.InflowOutflow = ''Inflow'' OR 
			GLCategorizationHierarchy.GLFinancialCategoryName = ''Other Expenses''
	END

	
	/* ================================================================================================================
		STEP 7: Clean Up Data														
	=================================================================================================================*/
	
	BEGIN
	
	DELETE 
		FROM 
			#ValidationSummary
	WHERE
		#ValidationSummary.HasUnknownActivityType = 0 AND
		#ValidationSummary.HasUnknownAllocationRegion = 0 AND
		#ValidationSummary.HasUnknownGLAccount = 0 AND
		#ValidationSummary.HasUnknownCategorizationHierarchy = 0 AND
		#ValidationSummary.HasUnknownFunctionalDepartment = 0 AND
		#ValidationSummary.HasUnknownOriginatingRegion = 0 AND
		#ValidationSummary.HasUnknownPropertyFund = 0 AND
		#ValidationSummary.InvalidOriginatingRegionAndFunctionalDepartment = 0 AND
		#ValidationSummary.InvalidActivityTypeAndEntity = 0
	
	END	
	
	/* ================================================================================================================
		STEP 8: Get Property Header GL Account Sum
		
		Gets a summary of the total of each header account with activity specific child gl accounts under it
	=================================================================================================================*/

	BEGIN
	
	SELECT 
		LEDGER.SourceCode, 
		LEDGER.EntityID, 
		LEDGER.GlAccountCode, 
		SUM(LEDGER.Amount) Amount
	INTO #PropertyHeaderSum
	FROM 
		GrReportingStaging.USPROP.GeneralLedger LEDGER 
		LEFT OUTER JOIN (
			SELECT 
				GACC.ACCTNUM, 
				GACC.ISGR
			FROM GrReportingStaging.USPROP.GACC
			INNER JOIN GrReportingStaging.USPROP.GAccActive(@DataPriorToDate) GaA ON 
				GaA.ImportKey = GACC.ImportKey
		) GACC ON 
			LEDGER.GlAccountCode = GACC.ACCTNUM
	WHERE 
		LEDGER.Period BETWEEN @StartPeriod AND @EndPeriod AND 
		LEDGER.Basis IN (''A'',''B'') AND 
		GACC.ISGR = ''Y'' AND 
		EXISTS(
			SELECT 
				NULL 
			FROM GrReportingStaging.USPROP.GACC G
			WHERE 
				G.ISGR = ''Y'' AND 
				LEFT(G.ACCTNUM, 10) = LEFT(GACC.ACCTNUM, 10) AND 
				G.ACCTNUM <> GACC.ACCTNUM
		) AND 
		RIGHT(RTRIM(GACC.ACCTNUM), 2) = ''00''
	GROUP BY
		LEDGER.SourceCode, 
		LEDGER.EntityID, 
		LEDGER.GlAccountCode
		
	UNION ALL
	 
	SELECT 
		LEDGER.SourceCode, 
		LEDGER.EntityID, 
		LEDGER.GlAccountCode, 
		SUM(LEDGER.Amount)
	FROM 
		GrReportingStaging.EUPROP.GeneralLedger LEDGER 
		LEFT OUTER JOIN (
			SELECT 
				GACC.ACCTNUM, 
				GACC.ISGR
			FROM GrReportingStaging.EUPROP.GACC
			INNER JOIN GrReportingStaging.EUPROP.GAccActive(@DataPriorToDate) GaA ON 
				GaA.ImportKey = GACC.ImportKey
		) GACC ON 
			LEDGER.GlAccountCode = GACC.ACCTNUM
	WHERE 
		LEDGER.Period BETWEEN @StartPeriod AND @EndPeriod AND 
		LEDGER.Basis IN (''A'',''B'') AND 
		GACC.ISGR = ''Y'' AND 
		EXISTS(
			SELECT 
				NULL 
			FROM GrReportingStaging.EUPROP.GACC G
			WHERE 
				G.ISGR = ''Y'' AND 
				LEFT(G.ACCTNUM, 10) = LEFT(GACC.ACCTNUM, 10) AND 
				G.ACCTNUM <> GACC.ACCTNUM
		)
		AND RIGHT(RTRIM(GACC.ACCTNUM), 2) = ''00''
	GROUP BY
		LEDGER.SourceCode, 
		LEDGER.EntityID, 
		LEDGER.GlAccountCode
		
	UNION ALL 

	SELECT 
		LEDGER.SourceCode, 
		LEDGER.EntityID, 
		LEDGER.GlAccountCode, 
		SUM(LEDGER.Amount)
	FROM 
		GrReportingStaging.CNPROP.GeneralLedger LEDGER 
		LEFT OUTER JOIN (
			SELECT 
				GACC.ACCTNUM, 
				GACC.ISGR
			FROM GrReportingStaging.CNCorp.GACC
			INNER JOIN GrReportingStaging.CNPROP.GAccActive(@DataPriorToDate) GaA ON 
				GaA.ImportKey = GACC.ImportKey
		) GACC ON 
			LEDGER.GlAccountCode = GACC.ACCTNUM
	WHERE 
		LEDGER.Period BETWEEN @StartPeriod AND @EndPeriod AND 
		LEDGER.Basis IN (''A'',''B'') AND
		GACC.ISGR = ''Y'' AND 
		EXISTS(
			SELECT 
				NULL 
			FROM GrReportingStaging.CNPROP.GACC G
			WHERE 
				G.ISGR = ''Y'' AND 
				LEFT(G.ACCTNUM, 10) = LEFT(GACC.ACCTNUM, 10) AND 
				G.ACCTNUM <> GACC.ACCTNUM
		)AND 
		RIGHT(RTRIM(GACC.ACCTNUM), 2) = ''00''
	GROUP BY
		LEDGER.SourceCode, 
		LEDGER.EntityID, 
		LEDGER.GlAccountCode
		
	UNION ALL 

	SELECT 
		LEDGER.SourceCode, 
		LEDGER.EntityID, 
		LEDGER.GlAccountCode, 
		SUM(LEDGER.Amount) 
	FROM 
		GrReportingStaging.INPROP.GeneralLedger LEDGER 
		LEFT OUTER JOIN (
			SELECT 
				GACC.ACCTNUM, 
				GACC.ISGR
			FROM GrReportingStaging.INPROP.GACC
			INNER JOIN GrReportingStaging.INPROP.GAccActive(@DataPriorToDate) GaA ON 
				GaA.ImportKey = GACC.ImportKey
		) GACC ON 
			LEDGER.GlAccountCode = GACC.ACCTNUM
	WHERE 
		LEDGER.Period BETWEEN @StartPeriod AND @EndPeriod AND 
		LEDGER.Basis IN (''A'',''B'') AND 
		GACC.ISGR = ''Y'' AND 
		EXISTS(
			SELECT 
				NULL 
			FROM GrReportingStaging.INPROP.GACC G
			WHERE 
				G.ISGR = ''Y'' AND 
				LEFT(G.ACCTNUM, 10) = LEFT(GACC.ACCTNUM, 10) AND 
				G.ACCTNUM <> GACC.ACCTNUM
		) AND 
		RIGHT(RTRIM(GACC.ACCTNUM), 2) = ''00''
	GROUP BY
		LEDGER.SourceCode, 
		LEDGER.EntityID, 
		LEDGER.GlAccountCode
		
	UNION ALL 

	SELECT 
		LEDGER.SourceCode, 
		LEDGER.EntityID, 
		LEDGER.GlAccountCode, 
		SUM(LEDGER.Amount) 
	FROM 
		GrReportingStaging.BRPROP.GeneralLedger LEDGER 
		LEFT OUTER JOIN (
			SELECT 
				GACC.ACCTNUM, 
				GACC.ISGR
			FROM GrReportingStaging.BRPROP.GACC
			INNER JOIN GrReportingStaging.BRPROP.GAccActive(@DataPriorToDate) GaA ON 
				GaA.ImportKey = GACC.ImportKey
		) GACC ON 
			LEDGER.GlAccountCode = GACC.ACCTNUM
	WHERE 
		LEDGER.Period BETWEEN @StartPeriod AND @EndPeriod AND 
		LEDGER.Basis IN (''A'',''B'') AND 
		GACC.ISGR = ''Y'' AND 
		EXISTS(
			SELECT 
				NULL 
			FROM GrReportingStaging.BRPROP.GACC G
			WHERE 
				G.ISGR = ''Y'' AND 
				LEFT(G.ACCTNUM, 10) = LEFT(GACC.ACCTNUM, 10) AND 
				G.ACCTNUM <> GACC.ACCTNUM
		) AND 
		RIGHT(RTRIM(GACC.ACCTNUM), 2) = ''00''
	GROUP BY
		LEDGER.SourceCode, 
		LEDGER.EntityID, 
		LEDGER.GlAccountCode
		
	END	

	/* ================================================================================================================
		STEP 9: Get Corporate Header GL Account Sum
		
		Gets a sum of all transactions against each corporate gl account (job code specific)
	=================================================================================================================*/

	BEGIN
		
	SELECT
		gl.SourceCode,
		gl.EntityID,
		gl.Source,
		ISNULL(gl.JobCode,'''') JobCode,
		ISNULL(gl.Description,'''') Description,
		SUM(gl.Amount) AS Amount
	INTO
		#CorporateDescSum
	FROM					
		#GeneralLedger gl	
	WHERE
		RIGHT(gl.SourceCode, 1) = ''C''
	GROUP BY
		gl.SourceCode,
		gl.EntityID,
		gl.Source,
		gl.JobCode,
		gl.Description
		
	END
			
	/* ================================================================================================================
		STEP 11: GET FINAL RESULTS
		Handle ALL Logic													
	=================================================================================================================*/
	
	BEGIN

	SELECT
		CASE 
			WHEN 
				ValidationSummary.HasUnknownActivityType = 1 OR 
				ValidationSummary.HasUnknownFunctionalDepartment = 1 OR
				ValidationSummary.HasUnknownOriginatingRegion = 1 OR
				ValidationSummary.InValidOriginatingRegionAndFunctionalDepartment = 1 OR
				ValidationSummary.InValidActivityTypeAndEntity = 1 OR
				InvalidGLAccountAndFunctionalDepartment = 1
			THEN 
				CASE WHEN
					ValidationSummary.HasUnknownPropertyFund = 1 OR
					ValidationSummary.HasUnknownAllocationRegion = 1 OR
					ValidationSummary.HasUnknownGlAccount = 1 OR
					ValidationSummary.HasUnknownCategorizationHierarchy = 1
				THEN 
					''Both Corporate Finance and Accounting''
				ELSE
					''Accounting - Re-class''
				END
			ELSE 
				''Corporate Finance - Mapping''
		END AS ''ResolvedBy'',
		ValidationSummary.SourceCode,
		
		-- MRI
		GeneralLedger.Period,
		GeneralLedger.Ref,
		GeneralLedger.Item,
		ISNULL(GeneralLedger.EntityID, '''') AS ''EntityID'',
		ISNULL(GeneralLedger.EntityName, '''') AS ''EntityName'',
		ISNULL(GeneralLedger.GLAccountCode, '''') AS ''GLAccountCode'',
		ISNULL(GeneralLedger.GlAccountName, '''') AS ''GlAccountName'',
		ISNULL(GeneralLedger.DepartmentCode, '''') AS ''Department'',
		ISNULL(GeneralLedger.DepartmentDescription, '''') AS ''DepartmentDescription'',
		ISNULL(GeneralLedger.JobCode, '''') AS ''JobCode'',
		ISNULL(GeneralLedger.JobCodeDescription, '''') AS ''JobCodeDescription'',
		ISNULL(GeneralLedger.Amount, '''') AS ''Amount'',
		ISNULL(GeneralLedger.Description, '''') AS ''Description'',
		ISNULL(GeneralLedger.EnterDate, '''') AS ''EnterDate'',
		ISNULL(GeneralLedger.Reversal, '''') AS ''Reversal'',
		ISNULL(GeneralLedger.Status, '''') AS ''Status'',
		ISNULL(GeneralLedger.Basis, '''') AS ''Basis'',
		ISNULL(GeneralLedger.UserId, '''') AS ''UserId'',
		ISNULL(GeneralLedger.CorporateDepartmentCode, '''') AS ''CorporateDepartmentCode'',
		ISNULL(GeneralLedger.[Source], '''') AS ''Source'',
		CASE 
			WHEN ValidationSummary.HasUnknownActivityType = 1 THEN ''YES'' 
			ELSE ''NO'' 
		END AS ''HasActivityTypeUnknown'',
		CASE 
			WHEN ValidationSummary.HasUnknownFunctionalDepartment = 1 THEN ''YES'' 
			ELSE ''NO'' 
		END AS ''HasFunctionalDepartmentUnknown'',
		CASE 
			WHEN ValidationSummary.HasUnknownOriginatingRegion = 1 THEN ''YES'' 
			ELSE ''NO'' 
		END AS ''HasOriginatingRegionUnknown'',
		CASE 
			WHEN ValidationSummary.HasUnknownPropertyFund = 1 THEN ''YES'' 
			ELSE ''NO'' 
		END AS ''HasReportingEntityUnknown'',
		CASE 
			WHEN ValidationSummary.HasUnknownAllocationRegion = 1 THEN ''YES'' 
			ELSE ''NO'' 
		END AS ''HasAllocationRegionUnknown'',
		CASE 
			WHEN ValidationSummary.HasUnknownGlAccount = 1 THEN ''YES'' 
			ELSE ''NO'' 
		END AS ''HasGlAccountUnknown'',
		CASE 
			WHEN ValidationSummary.InValidOriginatingRegionAndFunctionalDepartment = 1 THEN ''YES'' 
			ELSE ''NO'' 
		END AS ''InValidOriginatingRegionAndFunctionalDepartment'',
		CASE 
			WHEN ValidationSummary.InValidActivityTypeAndEntity = 1 THEN ''YES'' 
			ELSE ''NO'' 
		END AS ''InValidActivityTypeAndEntity'',
		CASE 
			WHEN ValidationSummary.InvalidGLAccountAndFunctionalDepartment = 1 THEN ''YES'' 
			ELSE ''NO'' 
		END AS ''InvalidGLAccountAndFunctionalDepartment'',
		ISNULL(PropertyHeaderSum.Amount, '''') AS ''PropertyParentAccountTotal'',
		ISNULL(CorporateDescriptionSum.Amount, '''') AS ''CorporateTotalByDescription'',
		''Global'' AS ''GrCategorization'',
		GlobalHierarchy.GLFinancialCategoryName AS ''GrFinancialCategoryName'',
		GlobalHierarchy.GLMajorCategoryName AS ''GrMajorCategoryName'',
		GlobalHierarchy.GLMinorCategoryName AS ''GrMinorCategoryName'',
		GlobalHierarchy.InflowOutflow AS ''InflowOutFlow'',
		PropertyFund.PropertyFundName AS ''GrReportingEntityName'',
		ActivityType.ActivityTypeName AS ''GrActivityTypeName'',
		OriginatingRegion.SubRegionName AS ''GrOriginatingSubRegionName'',
		AllocationRegion.SubRegionName AS ''GrAllocationSubRegionName'',
		FunctionalDepartment.FunctionalDepartmentName AS ''GrFunctionalDepartmentName''
	FROM 
		#ValidationSummary ValidationSummary
		INNER JOIN dbo.ProfitabilityActual ON 
			ValidationSummary.ProfitabilityActualKey = ProfitabilityActual.ProfitabilityActualKey
		INNER JOIN dbo.GLCategorizationHierarchy GlobalHierarchy ON 
			ProfitabilityActual.GlobalGLCategorizationHierarchyKey = GlobalHierarchy.GLCategorizationHierarchyKey
		INNER JOIN dbo.PropertyFund ON 
			ProfitabilityActual.PropertyFundKey = PropertyFund.PropertyFundKey
		INNER JOIN dbo.ActivityType ON 
			ProfitabilityActual.ActivityTypeKey = ActivityType.ActivityTypeKey
		INNER JOIN dbo.OriginatingRegion ON 
			ProfitabilityActual.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey
		INNER JOIN dbo.AllocationRegion ON 
			 ProfitabilityActual.AllocationRegionKey = AllocationRegion.AllocationRegionKey
		INNER JOIN dbo.Overhead ON 
			ProfitabilityActual.OverheadKey = Overhead.OverheadKey
		INNER JOIN dbo.FunctionalDepartment ON 
			ProfitabilityActual.FunctionalDepartmentKey	= FunctionalDepartment.FunctionalDepartmentKey
		INNER JOIN #GeneralLedger GeneralLedger ON 
			ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND 
			ValidationSummary.SourceCode = GeneralLedger.SourceCode
		LEFT OUTER JOIN #PropertyHeaderSum PropertyHeaderSum ON 
			GeneralLedger.SourceCode = PropertyHeaderSum.SourceCode AND
			GeneralLedger.EntityId = PropertyHeaderSum.EntityID AND 
			GeneralLedger.GlAccountCode = PropertyHeaderSum.GlAccountCode
		LEFT OUTER JOIN #CorporateDescSum CorporateDescriptionSum ON 
			GeneralLedger.SourceCode = CorporateDescriptionSum.SourceCode AND
			GeneralLedger.EntityID = CorporateDescriptionSum.EntityID AND
			GeneralLedger.Source = CorporateDescriptionSum.Source AND
			ISNULL(GeneralLedger.JobCode,'''') = CorporateDescriptionSum.JobCode AND
			ISNULL(GeneralLedger.Description,'''') = CorporateDescriptionSum.Description		

	END
	
	--------------------------------------------------------------------------
	/*	Clean up temp tables												*/
	--------------------------------------------------------------------------

	BEGIN
	
	IF OBJECT_ID(''tempdb..#ValidationSummary'') IS NOT NULL
		DROP TABLE #ValidationSummary
		
	IF OBJECT_ID(''tempdb..#GeneralLedger'') IS NOT NULL
		DROP TABLE #GeneralLedger
	
	IF OBJECT_ID(''tempdb..#HolisticReviewExport'') IS NOT NULL
		DROP TABLE #HolisticReviewExport

	IF OBJECT_ID(''tempdb..#ValidActivityTypeEntity'') IS NOT NULL
		DROP TABLE #ValidActivityTypeEntity
	
	IF OBJECT_ID(''tempdb..#HolisticReviewExportTemp'') IS NOT NULL
		DROP TABLE #HolisticReviewExportTemp
	
	IF OBJECT_ID(''tempdb..#InValidActivityTypeAndEntityCombination'') IS NOT NULL
		DROP TABLE #InValidActivityTypeAndEntityCombination
	
	IF OBJECT_ID(''tempdb..#IsGBSGlobalAccounts'') IS NOT NULL
		DROP TABLE #IsGBSGlobalAccounts
		
	IF OBJECT_ID(''tempdb..#ValidRegionAndFunctionalDepartment'') IS NOT NULL
		DROP TABLE #ValidRegionAndFunctionalDepartment
		
	IF OBJECT_ID(''tempdb..#PropertyHeaderSum'') IS NOT NULL
		DROP TABLE #PropertyHeaderSum

	IF OBJECT_ID(''tempdb..#CorporateDescSum'') IS NOT NULL
		DROP TABLE #CorporateDescSum


	END





















' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_S_UnknownSummaryAllocatedOverhead]    Script Date: 03/08/2012 12:51:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_S_UnknownSummaryAllocatedOverhead]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_S_UnknownSummaryAllocatedOverhead]
@BudgetYear int,
@BudgetQuater	Varchar(2),
@DataPriorToDate DateTime,
@StartPeriod int,
@EndPeriod int
AS


--SET @StartPeriod = 201001
--SET @EndPeriod = 201008
--SET @BudgetYear = 2010
--SET @BudgetQuater = ''Q2''
--SET @DataPriorToDate = ''2010-12-31''
--ActivityType
--GlAccount
--GlAccountCategory
--AllocationRegion
--OriginatingRegion
--FunctionalDepartment
--<<not included>>Overhead
--PropertyFund

--This is copied directly from stp_IU_LoadGrProfitabiltyOverhead
IF OBJECT_ID(''tempdb..#ActivityTypeGLAccount'') IS NOT NULL
	DROP TABLE #ActivityTypeGLAccount
	
CREATE TABLE #ActivityTypeGLAccount(
	ActivityTypeId INT,
	GLAccountCode VARCHAR(12)
)

INSERT INTO #ActivityTypeGLAccount (
	ActivityTypeId, 
	GLAccountCode
)
SELECT NULL AS ActivityTypeId, ''5002950000'' AS GLAccountCode UNION ALL --header (NULL in on hierarchy)
SELECT 1, ''5002950001'' UNION ALL --Leasing
SELECT 2, ''5002950002'' UNION ALL --Acquisitions
SELECT 3, ''5002950003'' UNION ALL --Asset Management
SELECT 4, ''5002950004'' UNION ALL --Development
SELECT 5, ''5002950005'' UNION ALL --Property Management Escalatable
SELECT 6, ''5002950006'' UNION ALL --Property Management Non-Escalatable
SELECT 7, ''5002950007'' UNION ALL --Syndication (Investment and Fund)
SELECT 8, ''5002950008'' UNION ALL --Fund Organization
SELECT 9, ''5002950009'' UNION ALL --Fund Operations
SELECT 10, ''5002950010'' UNION ALL --Property Management TI
SELECT 11, ''5002950011'' UNION ALL --Property Management CapEx
SELECT 12, ''5002950012'' UNION ALL --Corporate
SELECT 99, ''5002950099'' --Corporate Overhead (No corporate overhead (5002950099) account  use header instead)



IF OBJECT_ID(''tempdb..#ValidationSummary'') IS NOT NULL
	DROP TABLE #ValidationSummary
	
CREATE TABLE #ValidationSummary
(
SourceCode Char(2) NOT NULL,
ProfitabilityActualKey Int NOT NULL,
ReferenceCode varchar(100) NOT NULL,
HasActivityTypeUnknown TinyInt NULL,
HasAllocationRegionUnknown TinyInt NULL,
HasFunctionalDepartmentUnknown TinyInt NULL,
HasGlAccountUnknown TinyInt NULL,
HasGlAccountCategoryUnknown TinyInt NULL,
HasOriginatingRegionUnknown TinyInt NULL,
--HasOverheadUnknown TinyInt NULL,
HasPropertyFundUnknown TinyInt NULL,
InValidRegionAndFunctionalDepartment TinyInt NULL DEFAULT(0),
InValidActivityTypeEntity  TinyInt NULL DEFAULT(0)
)

--Step 1 :: Get all the unknowns
Insert Into #ValidationSummary
(SourceCode,ProfitabilityActualKey, ReferenceCode, HasActivityTypeUnknown, HasAllocationRegionUnknown, 
HasFunctionalDepartmentUnknown,HasGlAccountUnknown, HasGlAccountCategoryUnknown, 
HasOriginatingRegionUnknown,--HasOverheadUnknown, 
HasPropertyFundUnknown)

Select 
	ss.SourceCode,
	pa.ProfitabilityActualKey, 
	pa.ReferenceCode, 
	CASE WHEN pa.ActivityTypeKey = -1 THEN 1 ELSE 0 END HasActivityTypeUnknown, 
	CASE WHEN pa.AllocationRegionKey = -1 THEN 1 ELSE 0 END HasAllocationRegionUnknown, 
	CASE WHEN pa.FunctionalDepartmentKey = -1 AND gac.FeeOrExpense <> ''INCOME'' THEN 1 ELSE 0 END HasFunctionalDepartmentUnknown,
	CASE WHEN pa.GlAccountKey = -1 THEN 1 ELSE 0 END HasGlAccountUnknown, 
	CASE WHEN gac.MajorCategoryName like ''%unknown%'' THEN 1 ELSE 0 END HasGlAccountCategoryUnknown, 
	CASE WHEN pa.OriginatingRegionKey = -1 AND gac.FeeOrExpense <> ''INCOME'' THEN 1 ELSE 0 END HasOriginatingRegionUnknown,
	--CASE WHEN pa.OverheadKey = -1 THEN 1 ELSE 0 END HasOverheadUnknown, 
	CASE WHEN pa.PropertyFundKey = -1 THEN 1 ELSE 0 END HasPropertyFundUnknown

From	ProfitabilityActual pa
			INNER JOIN Calendar ca on ca.CalendarKey = pa.CalendarKey
			INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = pa.GlobalGlAccountCategoryKey
			INNER JOIN [Source] ss ON ss.SourceKey = pa.SourceKey
			INNER JOIN ProfitabilityActualSourceTable pas ON pas.ProfitabilityActualSourceTableId = pa.ProfitabilityActualSourceTableId
Where	ca.CalendarPeriod BETWEEN @StartPeriod AND @EndPeriod		
AND		pas.SourceTable IN (''BillingUploadDetail'')
AND		gac.MinorCategoryName <> ''Architects & Engineering''
--Only where one of the DimensionKey''s are unknown
AND (
	CASE WHEN pa.ActivityTypeKey = -1 THEN 1 ELSE 0 END = 1 OR 
	CASE WHEN pa.AllocationRegionKey = -1 THEN 1 ELSE 0 END = 1 OR
	CASE WHEN pa.FunctionalDepartmentKey = -1 THEN 1 ELSE 0 END = 1 OR
	CASE WHEN pa.GlAccountKey = -1 THEN 1 ELSE 0 END = 1 OR
	CASE WHEN gac.MajorCategoryName like ''%unknown%'' THEN 1 ELSE 0 END = 1 OR 
	CASE WHEN pa.OriginatingRegionKey = -1 THEN 1 ELSE 0 END = 1 OR
	--CASE WHEN pa.OverheadKey = -1 THEN 1 ELSE 0 END = 1 OR
	CASE WHEN pa.PropertyFundKey = -1 THEN 1 ELSE 0 END = 1
	)

IF OBJECT_ID(''tempdb..#GeneralLedger'') IS NOT NULL
	DROP TABLE #GeneralLedger
	
--Step 1 :: Get all the TapasUS (Payroll) GeneralLedger Details, used to removed re-classed MRI items
		


-----------------------------------------------------------------------------------------------------------------------------------------------
--Step 8 :: OriginatingRegion & FunctionalDepartment Combination
--Sheet 1 :: OriginatingSubRegion And FunctionalDepartment

IF OBJECT_ID(''tempdb..#ValidRegionAndFunctionalDepartment'') IS NOT NULL
	DROP TABLE #ValidRegionAndFunctionalDepartment

CREATE TABLE #ValidRegionAndFunctionalDepartment
(OriginatingSubRegionName Varchar(50) NOT NULL,
FunctionalDepartmentName Varchar(50) NOT NULL
)
Insert Into #ValidRegionAndFunctionalDepartment
(FunctionalDepartmentName,OriginatingSubRegionName)
EXEC [stp_S_ValidPayrollRegionAndFunctionalDepartment] 
	@BudgetYear = @BudgetYear,
	@BudgetQuater = @BudgetQuater,
	@DataPriorToDate = @DataPriorToDate

Insert Into #ValidRegionAndFunctionalDepartment
(FunctionalDepartmentName,OriginatingSubRegionName)
EXEC [stp_S_ValidNonPayrollRegionAndFunctionalDepartment] 
	@BudgetYear = @BudgetYear,
	@BudgetQuater = @BudgetQuater,
	@DataPriorToDate = @DataPriorToDate

--Select 
--		DISTINCT 
--		orr.Name GdmOriginatingRegionName,
--		orr.Code GdmOriginatingRegionCode,
--		fd.Code FunctionalDepartmentCode,
--		fd.Name FunctionalDepartmentName
--Into #ValidRegionAndFunctionalDepartment
--From	SERVER3.GACS.dbo.[Site] si
--			INNER JOIN SERVER3.GACS.dbo.Team te ON te.SiteID = si.SiteID
--			INNER JOIN SERVER3.GACS.dbo.StaffTeam st ON st.TeamID = te.TeamID
--			INNER JOIN SERVER3.GACS.dbo.Staff s ON s.StaffID = st.StaffID
--			INNER JOIN SERVER3.GACS.dbo.StaffFunctionalDepartment sf ON sf.StaffID = s.StaffID
--			INNER JOIN SERVER3.GACS.dbo.FunctionalDepartment fd ON fd.FunctionalDepartmentID = sf.FunctionalDepartmentID
--			INNER JOIN SERVER3.GACS.dbo.StaffEntity se ON se.StaffID = s.StaffID
--			INNER JOIN SERVER3.GACS.dbo.Entity e ON e.EntityRef = se.EntityRef
--			INNER JOIN SERVER3.Gdm.dbo.OriginatingRegionCorporateEntity orrce ON orrce.CorporateEntityCode = e.EntityRef AND orrce.SourceCode = e.[Source]
--			INNER JOIN SERVER3.Gdm.dbo.OriginatingSubRegion orr ON orr.OriginatingSubRegionGlobalRegionId = orrce.GlobalRegionId
--Where te.name like ''%Budget Coordinator%''
--and e.IsHistoric = 0
--and e.[Source] like ''%C''

------------------------------------------------------------------------------------------------------------------------------------------
--The view an interim solution, until the spreadhseet is finalyzed
------------------------------------------------------------------------------------------------------------------------------------------
--Select
--		DISTINCT 
--		list.OriginatingSubRegionName,
--		list.FunctionalDepartmentName
--Into #ValidRegionAndFunctionalDepartment
--From
--		GrReportingStaging.dbo.ValidOriginatingSubRegionAndFunctionalDepartment list

IF OBJECT_ID(''tempdb..#InvalidRegionAndFunctDeptCombination'') IS NOT NULL
	DROP TABLE #InvalidRegionAndFunctDeptCombination
	
Select  
		s.SourceCode,
		pa.ReferenceCode,
		fd.FunctionalDepartmentName,
		orr.SubRegionName
Into #InvalidRegionAndFunctDeptCombination
From ProfitabilityActual pa

		INNER JOIN ProfitabilityActualSourceTable pas ON pas.ProfitabilityActualSourceTableId = pa.ProfitabilityActualSourceTableId

		INNER JOIN [Source] s ON s.SourceKey = pa.SourceKey
		
		LEFT OUTER JOIN FunctionalDepartment fd ON 
					fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey
				
		LEFT OUTER JOIN OriginatingRegion orr ON 
					orr.OriginatingRegionKey = pa.OriginatingRegionKey

		LEFT OUTER JOIN GlAccountCategory gac ON 
					gac.GlAccountCategoryKey = pa.GlobalGlAccountCategoryKey
					
		LEFT OUTER JOIN #ValidRegionAndFunctionalDepartment vs 
			on vs.FunctionalDepartmentName = fd.FunctionalDepartmentName
			 AND vs.OriginatingSubRegionName = orr.SubRegionName

Where	vs.FunctionalDepartmentName IS NULL
--AND		s.SourceCode LIKE ''%C'' --GC 2010-11-25 removed this for in MRI actuals its not included
AND		pas.SourceTable IN (''BillingUploadDetail'')
AND		gac.FeeOrExpense <> ''INCOME''
AND		gac.MinorCategoryName <> ''Architects & Engineering''



--Remove from this table the items, that the reclass logic already fixed the issue at hand
-->> No reclass removal required for the process do not exist in TAPAS


--Updated the existing rows in #ValidationSummary where FunctionalDepartment&OriginatingRegion combination is not valid
Update #ValidationSummary
Set	InValidRegionAndFunctionalDepartment = 1
	From	
		#InvalidRegionAndFunctDeptCombination InvalidRegionAndFunctDeptCombination
						
Where	#ValidationSummary.ReferenceCode = InvalidRegionAndFunctDeptCombination.ReferenceCode
 AND	#ValidationSummary.SourceCode = InvalidRegionAndFunctDeptCombination.SourceCode


--Insert only where FunctionalDepartment&OriginatingRegion combination is not valid and the item is not in #ValidationSummary yet
Insert Into #ValidationSummary
(SourceCode,ProfitabilityActualKey, ReferenceCode, HasActivityTypeUnknown, HasAllocationRegionUnknown, 
HasFunctionalDepartmentUnknown,HasGlAccountUnknown, HasGlAccountCategoryUnknown, 
HasOriginatingRegionUnknown,--HasOverheadUnknown, 
HasPropertyFundUnknown,InValidRegionAndFunctionalDepartment)
Select 
	ss.SourceCode,
	pa.ProfitabilityActualKey, 
	pa.ReferenceCode, 
	0 HasActivityTypeUnknown, 
	0 HasAllocationRegionUnknown, 
	0 HasFunctionalDepartmentUnknown,
	0 HasGlAccountUnknown, 
	0 HasGlAccountCategoryUnknown, 
	0 HasOriginatingRegionUnknown,
	--1 HasOverheadUnknown, 
	0 HasPropertyFundUnknown,
	1 InValidRegionAndFunctionalDepartment

From	ProfitabilityActual pa

			INNER JOIN ProfitabilityActualSourceTable pas ON pas.ProfitabilityActualSourceTableId = pa.ProfitabilityActualSourceTableId

			INNER JOIN Calendar ca on ca.CalendarKey = pa.CalendarKey

			INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = pa.GlobalGlAccountCategoryKey

			INNER JOIN [Source] ss ON ss.SourceKey = pa.SourceKey

			LEFT OUTER JOIN #ValidationSummary existing ON existing.SourceCode = ss.SourceCode AND existing.ReferenceCode = pa.ReferenceCode

			INNER JOIN #InvalidRegionAndFunctDeptCombination InvalidRegionAndFunctDeptCombination ON
						InvalidRegionAndFunctDeptCombination.ReferenceCode = pa.ReferenceCode
					AND	InvalidRegionAndFunctDeptCombination.SourceCode = ss.SourceCode
 
Where	ca.CalendarPeriod BETWEEN @StartPeriod AND @EndPeriod		
AND		existing.ReferenceCode IS NULL --Not in table yet
AND		pas.SourceTable IN (''BillingUploadDetail'')
AND		gac.MinorCategoryName <> ''Architects & Engineering''


------------------------------------------------------------
--Sheet 2 :: ActivityType And Entity

IF OBJECT_ID(''tempdb..#HolisticReviewExport'') IS NOT NULL
	DROP TABLE #HolisticReviewExport
	
CREATE TABLE #HolisticReviewExport
(	ProjectCode varchar(20) NULL,
	ProjectName varchar(100) NULL,
	ProjectEndPeriod int NULL,
	ActivityType varchar(50) NULL,
	PropertyFund varchar(100) NULL,
	PropertyFundAllocationSubRegionName varchar(50) NULL,
	Source char(2) NULL,
	AllocationType varchar(100) NULL,
	CorporateDepartment char(8) NULL,
	CorporateDepartmentDescription varchar(50) NULL,
	ReportingEntity varchar(100) NULL,
	ReportingEntityAllocationSubRegionName varchar(50) NULL,
	EntityType varchar(50) NULL,
	BudgetOwner varchar(255) NULL,
	RegionalOwner varchar(255) NULL,
	BudgetCoordinatorDisplayNames nvarchar(max) NULL,
	IsTSCost Varchar(3) NULL,
	PropertyEntity char(6) NULL,
	PropertyEntityName nvarchar(264) NULL
)
SET XACT_ABORT ON

Insert Into #HolisticReviewExport
EXEC SERVER3.Gdm.dbo.HolisticReviewExport


IF OBJECT_ID(''tempdb..#ValidActivityTypeEntity'') IS NOT NULL
	DROP TABLE #ValidActivityTypeEntity
	
Select
		DISTINCT 
		list.ActivityType ActivityTypeName,
		list.AllocationType AllocationTypeName,
		list.ReportingEntity ReportingEntityName
Into #ValidActivityTypeEntity
From
		#HolisticReviewExport list


--Add additional entries provided by Martin: IMS 56718
Insert Into #ValidActivityTypeEntity
(ReportingEntityName, ActivityTypeName, AllocationTypeName)
Select t1.ReportingEntityName, t1.ActivityTypeName, t1.AllocationTypeName 
From AdditionalValidCombinationsForEntityActivity t1
		LEFT OUTER JOIN #ValidActivityTypeEntity t2
				ON t2.ReportingEntityName = t1.ReportingEntityName AND
				t2.ActivityTypeName = t1.ActivityTypeName AND
				t2.AllocationTypeName = t1.AllocationTypeName
Where t2.AllocationTypeName IS NULL


IF OBJECT_ID(''tempdb..#InvalidActivityTypeEntityCombination'') IS NOT NULL
	DROP TABLE #InvalidActivityTypeEntityCombination
	
Select  
		s.SourceCode,
		pa.ReferenceCode,

		vs.AllocationTypeName,
		REPLACE(gac.AccountSubTypeName,''-'','''') AccountSubTypeName,

		vs.ActivityTypeName LocalActivityTypeName,
		at.ActivityTypeName ValidationActivityTypeName,

		vs.ReportingEntityName,
		pf.PropertyFundName
		
Into #InvalidActivityTypeEntityCombination
From ProfitabilityActual pa

		INNER JOIN ProfitabilityActualSourceTable pas ON pas.ProfitabilityActualSourceTableId = pa.ProfitabilityActualSourceTableId

		INNER JOIN [Source] s ON s.SourceKey = pa.SourceKey
		
		INNER JOIN PropertyFund pf ON 
					pf.PropertyFundKey = pa.PropertyFundKey
				
		INNER JOIN ActivityType at ON 
					at.ActivityTypeKey = pa.ActivityTypeKey

		INNER JOIN GlAccountCategory gac ON 
					gac.GlAccountCategoryKey = pa.GlobalGlAccountCategoryKey

		INNER JOIN Overhead oh ON oh.OverheadKey = pa.OverheadKey

		INNER JOIN Calendar ca ON ca.CalendarKey = pa.CalendarKey

		LEFT OUTER JOIN #ValidActivityTypeEntity vs 
			on 
				(	--GR
						gac.MajorCategoryName		<> ''Salaries/Taxes/Benefits''
				AND		oh.OverheadCode				= ''UNALLOC''
				AND		gac.AccountSubTypeName			= ''Overhead''
					--AM
				AND		vs.AllocationTypeName		= ''NonPayroll''
				AND		vs.ActivityTypeName			= ''Corporate Overhead''
				AND		vs.ReportingEntityName		= pf.PropertyFundName
				)
				OR
				(	--GR
						gac.MajorCategoryName		= ''Salaries/Taxes/Benefits''
				AND		oh.OverheadCode				= ''UNALLOC''
				AND		gac.AccountSubTypeName			= ''Overhead''
					--AM
				AND		vs.AllocationTypeName		= ''Payroll''
				AND		vs.ActivityTypeName			= ''Corporate Overhead''
				AND		vs.ReportingEntityName		= pf.PropertyFundName
				)
				OR
				(	--Default Match	
						vs.AllocationTypeName		= REPLACE(gac.AccountSubTypeName,''-'','''')
				AND		vs.ActivityTypeName			= at.ActivityTypeName
				AND		vs.ReportingEntityName		= pf.PropertyFundName
				)

Where	vs.ActivityTypeName		IS NULL
AND		pas.SourceTable			IN (''BillingUploadDetail'')
AND		NOT(oh.OverheadCode		= ''ALLOC'' AND gac.AccountSubTypeName = ''Overhead'')
AND		gac.MinorCategoryName	<> ''Architects & Engineering''
AND		ca.CalendarPeriod		>= 201007 

--Remove from this table the items, that the reclass logic already fixed the issue at hand
-->>> This is not required for reclass is a option from TAPAS

--Delete the old Reporting Entity Names
Delete From #InvalidActivityTypeEntityCombination
Where LTRIM(RTRIM(PropertyFundName)) IN (
		Select ''ECM Business Development'' ReportingEntity UNION
		Select ''Employee Reimbursables'' ReportingEntity UNION
		Select ''US CORP TBD'' ReportingEntity
		)

--Updated the existing rows in #ValidationSummary where FunctionalDepartment&OriginatingRegion combination is not valid
Update #ValidationSummary
Set	InvalidActivityTypeEntity = 1
	From	
		#InvalidActivityTypeEntityCombination InvalidActivityTypeEntityCombination
						
Where	#ValidationSummary.ReferenceCode = InvalidActivityTypeEntityCombination.ReferenceCode
 AND	#ValidationSummary.SourceCode = InvalidActivityTypeEntityCombination.SourceCode


--Insert only where ActivityTypeEntity&OriginatingRegion combination is not valid and the item is not in #ValidationSummary yet
Insert Into #ValidationSummary
(SourceCode,ProfitabilityActualKey, ReferenceCode, HasActivityTypeUnknown, HasAllocationRegionUnknown, 
HasFunctionalDepartmentUnknown,HasGlAccountUnknown, HasGlAccountCategoryUnknown, 
HasOriginatingRegionUnknown,--HasOverheadUnknown, 
HasPropertyFundUnknown,InvalidActivityTypeEntity)
Select 
	ss.SourceCode,
	pa.ProfitabilityActualKey, 
	pa.ReferenceCode, 
	0 HasActivityTypeUnknown, 
	0 HasAllocationRegionUnknown, 
	0 HasFunctionalDepartmentUnknown,
	0 HasGlAccountUnknown, 
	0 HasGlAccountCategoryUnknown, 
	0 HasOriginatingRegionUnknown,
	--1 HasOverheadUnknown, 
	0 HasPropertyFundUnknown,
	1 InValidRegionAndFunctionalDepartment

From	ProfitabilityActual pa

			INNER JOIN Calendar ca on ca.CalendarKey = pa.CalendarKey

			INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = pa.GlobalGlAccountCategoryKey

			INNER JOIN [Source] ss ON ss.SourceKey = pa.SourceKey

			LEFT OUTER JOIN #ValidationSummary existing ON existing.SourceCode = ss.SourceCode AND existing.ReferenceCode = pa.ReferenceCode

			INNER JOIN #InvalidActivityTypeEntityCombination InvalidActivityTypeEntityCombination ON
						InvalidActivityTypeEntityCombination.ReferenceCode = pa.ReferenceCode
					AND	InvalidActivityTypeEntityCombination.SourceCode = ss.SourceCode
 
Where	ca.CalendarPeriod BETWEEN @StartPeriod AND @EndPeriod	
AND		ca.CalendarPeriod		>= 201007 	
AND		existing.ReferenceCode IS NULL --Not in table yet
AND		gac.MinorCategoryName <> ''Architects & Engineering''


------------------------------------------------------------------------------------------------------------------------------------------
--Now Remove the rows from #ValidationSummary, where the re-class of items cause the to be valid now
Delete From #ValidationSummary
Where	HasActivityTypeUnknown = 0
AND		HasAllocationRegionUnknown = 0
AND		HasFunctionalDepartmentUnknown = 0
AND		HasGlAccountUnknown = 0
AND		HasGlAccountCategoryUnknown = 0
AND		HasOriginatingRegionUnknown = 0
--AND		HasOverheadUnknown = 0
AND		HasPropertyFundUnknown = 0
AND		InValidRegionAndFunctionalDepartment = 0
AND		InValidActivityTypeEntity = 0


--Return the UNKNOWN''s
Select 
	vs.SourceCode,
	CASE WHEN vs.HasActivityTypeUnknown = 1 THEN ''YES'' ELSE ''NO'' END HasActivityTypeUnknown,
	CASE WHEN vs.HasFunctionalDepartmentUnknown = 1 THEN ''YES'' ELSE ''NO'' END HasFunctionalDepartmentUnknown,
	CASE WHEN vs.HasOriginatingRegionUnknown = 1 THEN ''YES'' ELSE ''NO'' END HasOriginatingRegionUnknown,
	CASE WHEN vs.HasPropertyFundUnknown = 1 THEN ''YES'' ELSE ''NO'' END HasPropertyFundUnknown,
	CASE WHEN vs.HasAllocationRegionUnknown = 1 THEN ''YES'' ELSE ''NO'' END HasAllocationRegionUnknown,
	CASE WHEN vs.HasGlAccountUnknown = 1 THEN ''YES'' ELSE ''NO'' END HasGlAccountUnknown,
	CASE WHEN vs.HasGlAccountCategoryUnknown = 1 THEN ''YES'' ELSE ''NO'' END HasGlAccountCategoryUnknown,
	CASE WHEN vs.InValidRegionAndFunctionalDepartment = 1 THEN ''YES'' ELSE ''NO'' END InValidRegionAndFunctionalDepartment,
	CASE WHEN vs.InValidActivityTypeEntity = 1 THEN ''YES'' ELSE ''NO'' END InValidActivityTypeEntity,
	CASE WHEN 
		vs.HasActivityTypeUnknown = 1 OR 
		vs.HasFunctionalDepartmentUnknown = 1 OR
		vs.HasOriginatingRegionUnknown = 1 OR
		vs.InValidRegionAndFunctionalDepartment = 1 OR
		vs.InValidActivityTypeEntity = 1
	THEN CASE WHEN
			vs.HasPropertyFundUnknown = 1 OR
			vs.HasAllocationRegionUnknown = 1 OR
			vs.HasGlAccountUnknown = 1 OR
			vs.HasGlAccountCategoryUnknown = 1
		THEN 
			''Both Corporate Finance and Accounting''
		ELSE
			''Accounting - Re-class''
		END
	ELSE 
		''Corporate Finance - Mapping''
	END AS ResolvedBy,
	--DW
	gl.ExpensePeriod,
	gl.AllocationRegionCode,
	gl.AllocationRegionName,
	gl.OriginatingRegionCode,
	gl.OriginatingRegionSourceCode,
	gl.PropertyFundName,
	gl.FunctionalDepartmentCode,
	gl.ActivityTypeCode,
	gl.ForeignCurrency,
	gl.ForeignActual,
	gl.GlAccountCode,
	gl.EmployeeDisplayName
	
From #ValidationSummary vs

	INNER JOIN 
	(
		Select 
				Bud.BillingUploadDetailId,
				Bu.ExpensePeriod,
				GrAr.RegionCode AllocationRegionCode,
				GrAr.RegionName AllocationRegionName,
				Ovr.CorporateEntityRef OriginatingRegionCode,
				Ovr.CorporateSourceCode OriginatingRegionSourceCode,
				PF.Name PropertyFundName,
				Fd.GlobalCode FunctionalDepartmentCode,
				At.Code ActivityTypeCode,
				Bud.CurrencyCode ForeignCurrency,
				Bud.AllocationAmount ForeignActual,
				
				CASE
					WHEN (P1.AllocateOverheadsProjectId IS NULL OR P1.AllocateOverheadsProjectId = 0) THEN 
						ISNULL(DepartmentPropertyFund.PropertyFundId, -1)
					ELSE
						ISNULL(OverheadPropertyFund.PropertyFundId, -1)
				END PFID,
				
				P1.PropertyFundId P1,
				P1.PropertyFundId P2,
				ISNULL(DepartmentPropertyFund.PropertyFundId, -1)  DepartmentPropertyFundId,
				ISNULL(OverheadPropertyFund.PropertyFundId, -1) OverheadPropertyFundId,
				GA.Code GlAccountCode,
				Emp.DisplayName EmployeeDisplayName
		From	
				(Select		
						Bu.*
					From	GrReportingStaging.TapasGlobal.BillingUpload Bu
								INNER JOIN GrReportingStaging.TapasGlobal.BillingUploadActive(@DataPriorToDate) BuA 
							ON buA.ImportKey = bu.ImportKey
				) Bu
				
				LEFT OUTER JOIN SERVER3.ERPHR.dbo.HREmployee emp ON Emp.HREmployeeId = Bu.HREmployeeId
					
				INNER JOIN (Select 
								Bud.*
							From	GrReportingStaging.TapasGlobal.BillingUploadDetail Bud
										INNER JOIN GrReportingStaging.TapasGlobal.BillingUploadDetailActive(@DataPriorToDate) BudA 
											ON BudA.ImportKey = Bud.ImportKey
							) Bud ON Bud.BillingUploadId = Bu.BillingUploadId
						
				
				INNER JOIN (
							Select Oh.*
							From	GrReportingStaging.TapasGlobal.Overhead oh 
								INNER JOIN GrReportingStaging.TapasGlobal.OverheadActive(@DataPriorToDate) OhA ON
									OhA.ImportKey = Oh.ImportKey
							) Oh ON Oh.OverheadId = Bu.OverheadId

					LEFT OUTER JOIN (
									Select 
											Fd.*
									From GrReportingStaging.HR.FunctionalDepartment Fd 
										INNER JOIN GrReportingStaging.HR.FunctionalDepartmentActive(@DataPriorToDate) FdA ON
											FdA.ImportKey = Fd.ImportKey
									) Fd ON Fd.FunctionalDepartmentId = Bu.OverheadFunctionalDepartmentId

					LEFT OUTER JOIN (
									Select 
										P.*
									From GrReportingStaging.TapasGlobal.Project P
											INNER JOIN GrReportingStaging.TapasGlobal.ProjectActive(@DataPriorToDate) PA ON
												PA.ImportKey = P.ImportKey
									) P1 ON P1.ProjectId = Bu.ProjectId

					LEFT OUTER JOIN (
									Select 
										P.*
									From GrReportingStaging.TapasGlobal.Project P
											INNER JOIN GrReportingStaging.TapasGlobal.ProjectActive(@DataPriorToDate) PA ON
												PA.ImportKey = P.ImportKey
									) P2 ON
						P2.ProjectId = P1.AllocateOverheadsProjectId

					-- P1 ---------------------------

					LEFT OUTER JOIN GrReporting.dbo.[Source] GrScC ON
						GrScC.SourceCode = P1.CorporateSourceCode

					LEFT OUTER JOIN	(
									Select 
										RECD.*
									From GrReportingStaging.Gdm.ReportingEntityCorporateDepartment RECD
											INNER JOIN GrReportingStaging.Gdm.ReportingEntityCorporateDepartmentActive(@DataPriorToDate) RECDA ON
												RECDA.ImportKey = RECD.ImportKey
									)  RECDC ON GrScC.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
						RECDC.CorporateDepartmentCode = LTRIM(RTRIM(P1.CorporateDepartmentCode)) AND
						RECDC.SourceCode = P1.CorporateSourceCode AND
						Bu.ExpensePeriod >= ''201007'' AND		   
						RECDC.IsDeleted = 0
						   
					LEFT OUTER JOIN (
									Select 
										REPE.*
									From GrReportingStaging.Gdm.ReportingEntityPropertyEntity REPE
												INNER JOIN GrReportingStaging.Gdm.ReportingEntityPropertyEntityActive(@DataPriorToDate) REPEA ON
													REPEA.ImportKey = REPE.ImportKey
									) REPEC ON -- added
						GrScC.IsProperty = ''YES'' AND -- only property MRIs resolved through this
						REPEC.PropertyEntityCode = LTRIM(RTRIM(P1.CorporateDepartmentCode)) AND
						REPEC.SourceCode = P1.CorporateSourceCode AND
						Bu.ExpensePeriod >= ''201007'' AND
						REPEC.IsDeleted = 0

					LEFT OUTER JOIN (
									Select pfm.*
									From	GrReportingStaging.Gdm.PropertyFundMapping Pfm 
												INNER JOIN GrReportingStaging.Gdm.PropertyFundMappingActive(@DataPriorToDate) PfmA ON
													PfmA.ImportKey = Pfm.ImportKey
									) pfm ON pfm.PropertyFundCode = P1.CorporateDepartmentCode AND -- Combination of entity and corporate department
						pfm.SourceCode = P1.CorporateSourceCode AND
						pfm.IsDeleted = 0 AND 
						(
							(GrScC.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL) 
							OR
							(
								(GrScC.IsCorporate = ''YES'' AND pfm.ActivityTypeId = Bu.ActivityTypeId)
								OR
								(GrScC.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND Bu.ActivityTypeId IS NULL)
							)
						) AND Bu.ExpensePeriod < ''201007'' 
						
					LEFT OUTER JOIN GrReporting.dbo.PropertyFund DepartmentPropertyFund ON
						DepartmentPropertyFund.PropertyFundId =
							CASE
								WHEN Bu.ExpensePeriod < ''201007'' THEN pfm.PropertyFundId
								ELSE
									CASE
										WHEN GrScC.IsCorporate = ''YES'' THEN RECDC.PropertyFundId
										ELSE REPEC.PropertyFundId
									END
							END -- extra condition? re: date

					-- P1 end -----------------------
					-- P2 ---------------------------

					LEFT OUTER JOIN GrReporting.dbo.[Source] GrScO
						ON GrScO.SourceCode = P2.CorporateSourceCode

					LEFT OUTER JOIN	(
									Select 
											RECD.*
									From	GrReportingStaging.Gdm.ReportingEntityCorporateDepartment RECD
												INNER JOIN GrReportingStaging.Gdm.ReportingEntityCorporateDepartmentActive(@DataPriorToDate) RECDA ON
													RECDA.ImportKey = RECD.ImportKey
									) RECDO ON -- added
						GrScO.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
						RECDO.CorporateDepartmentCode = LTRIM(RTRIM(P2.CorporateDepartmentCode)) AND
						RECDO.SourceCode = P2.CorporateSourceCode AND
						Bu.ExpensePeriod >= ''201007''  AND 
						RECDO.IsDeleted = 0
						   
					LEFT OUTER JOIN (
									Select 
										REPE.*
									From GrReportingStaging.Gdm.ReportingEntityPropertyEntity REPE
												INNER JOIN GrReportingStaging.Gdm.ReportingEntityPropertyEntityActive(@DataPriorToDate) REPEA ON
													REPEA.ImportKey = REPE.ImportKey
									)  REPEO ON -- added
						GrScO.IsProperty = ''YES'' AND -- only property MRIs resolved through this
						REPEO.PropertyEntityCode = LTRIM(RTRIM(P2.CorporateDepartmentCode)) AND
						REPEO.SourceCode = P2.CorporateSourceCode AND
						Bu.ExpensePeriod >= ''201007''  AND
						REPEO.IsDeleted = 0

					LEFT OUTER JOIN (
									Select pfm.*
									From	GrReportingStaging.Gdm.PropertyFundMapping Pfm 
												INNER JOIN GrReportingStaging.Gdm.PropertyFundMappingActive(@DataPriorToDate) PfmA ON
													PfmA.ImportKey = Pfm.ImportKey
									) opfm ON
						P2.CorporateDepartmentCode = opfm.PropertyFundCode AND -- Combination of entity and corporate department
						P2.CorporateSourceCode = opfm.SourceCode AND
						opfm.IsDeleted = 0  AND 
						(
							(GrScO.IsProperty = ''YES'' AND opfm.ActivityTypeId IS NULL) 
							OR
							(
								(GrScO.IsCorporate = ''YES'' AND opfm.ActivityTypeId = Bu.ActivityTypeId)
								OR
								(GrScO.IsCorporate = ''YES'' AND opfm.ActivityTypeId IS NULL AND Bu.ActivityTypeId IS NULL) 
							)	
						) AND Bu.ExpensePeriod < ''201007'' 

					LEFT OUTER JOIN GrReporting.dbo.PropertyFund OverheadPropertyFund ON
						OverheadPropertyFund.PropertyFundId =
							CASE
								WHEN Bu.ExpensePeriod < ''201007'' THEN opfm.PropertyFundId
								ELSE
									CASE
										WHEN GrScO.IsCorporate = ''YES'' THEN RECDO.PropertyFundId
										ELSE REPEO.PropertyFundId
									END
							END	

					-- P2 end -----------------------

					LEFT OUTER JOIN (
									Select 
										PF.*
										From	GrReportingStaging.Gdm.PropertyFund PF 
													INNER JOIN GrReportingStaging.Gdm.PropertyFundActive(@DataPriorToDate) PFA ON
														PFA.ImportKey = PF.ImportKey
									) PF ON PF.PropertyFundId = (
												CASE
												WHEN (P1.AllocateOverheadsProjectId IS NULL OR P1.AllocateOverheadsProjectId = 0) THEN 
													ISNULL(DepartmentPropertyFund.PropertyFundId, -1)
												ELSE
													ISNULL(OverheadPropertyFund.PropertyFundId, -1)
											END
											)
						
					LEFT OUTER JOIN (Select	
										ASR.*
									From	GrReportingStaging.Gdm.AllocationSubRegion ASR
											INNER JOIN	GrReportingStaging.Gdm.AllocationSubRegionActive(@DataPriorToDate) ASRA ON ASRA.ImportKey = ASR.ImportKey
									) ASR ON PF.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId


					LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
						GrAr.GlobalRegionId = ASR.AllocationSubRegionGlobalRegionId --AND
						-- ISNULL(Gl.LastDate, EnterDate) BETWEEN GrAr.StartDate AND GrAr.EndDate ???????

					LEFT OUTER JOIN (Select 
										At.*
									From 	GrReportingStaging.Gdm.ActivityType At
												INNER JOIN GrReportingStaging.Gdm.ActivityTypeActive(@DataPriorToDate) Ata ON
														Ata.ImportKey = At.ImportKey
									) At ON
						At.ActivityTypeId = Bu.ActivityTypeId

					LEFT OUTER JOIN (Select		
										Ovr.*
									From	GrReportingStaging.TapasGlobal.OverheadRegion Ovr 
												INNER JOIN GrReportingStaging.TapasGlobal.OverheadRegionActive(@DataPriorToDate) OvrA ON
													OvrA.ImportKey = Ovr.ImportKey
									) Ovr ON
						Ovr.OverheadRegionId = Bu.OverheadRegionId	
						
					
						LEFT OUTER JOIN #ActivityTypeGLAccount AtGla ON
							AtGla.ActivityTypeId = At.ActivityTypeId

						LEFT OUTER JOIN (
										Select	
												GLA.*
										FROM
												GrReportingStaging.Gdm.GLGlobalAccount GLA
												INNER JOIN GrReportingStaging.Gdm.GLGlobalAccountActive(@DataPriorToDate) GLAA ON
													GLAA.ImportKey = GLA.ImportKey
										) GA ON
							GA.Code = AtGla.GLAccountCode AND
							ISNULL(AtGla.ActivityTypeId, 0) = ISNULL(GA.ActivityTypeId, 0) -- Nulls for header (00) accounts. (Should really have an activity for this)
	
					
						
	) gl on vs.ReferenceCode = ''BillingUploadDetailId='' + LTRIM(STR(gl.BillingUploadDetailId, 10, 0))
Order By vs.SourceCode, vs.ReferenceCode
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ProfitabilityV2]    Script Date: 03/08/2012 12:51:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ProfitabilityV2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE [dbo].[stp_R_ProfitabilityV2]
	@ReportExpensePeriod INT,
	@ReforecastQuarterName VARCHAR(2), --''Q0'' or ''Q1'' or ''Q2'' or ''Q3''
	@DestinationCurrency VARCHAR(3),
	@EntityList NVARCHAR(MAX),
	@ActivityTypeList VARCHAR(MAX),
	@DontSensitizeMRIPayrollData BIT,
	@IncludeGrossNonPayrollExpenses BIT,
	@IncludeFeeAdjustments BIT,
	@DisplayOverheadBy VARCHAR(32),
	@OverheadOriginatingSubRegionList NVARCHAR(MAX),
	@ConsolidationRegionList NVARCHAR(MAX),
	@CategorizationName VARCHAR(250)
AS 

/* =============================================================================================================================================
	1. Setup Variables
   =========================================================================================================================================== */	
BEGIN

	DECLARE
		@_DisplayOverheadBy VARCHAR(250) = @DisplayOverheadBy,
		@AllocatedOverhead VARCHAR(50) = ''Allocated Overhead'',
		@UnAllocatedOverhead VARCHAR(50) = ''Unallocated Overhead'',
		@OtherExpensesExpenseType VARCHAR(50) = ''Other Expenses''	

	IF (ISNULL(@_DisplayOverheadBy,'''') NOT IN (@AllocatedOverhead,@UnAllocatedOverhead))
	BEGIN
		RAISERROR (''@DisplayOverheadBy have invalid value (Must be one of:Allocated,Unallocated)'',18,1)
		RETURN
	END
			
	IF (@ReforecastQuarterName IS NULL OR @ReforecastQuarterName NOT IN (''Q0'', ''Q1'', ''Q2'', ''Q3''))
		SET @ReforecastQuarterName = (SELECT TOP 1
										ReforecastQuarterName 
									 FROM
										dbo.Reforecast 
									 WHERE
										ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
										ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)), 4)
									 ORDER BY
										ReforecastEffectivePeriod DESC)

END

/* =============================================================================================================================================
	2. Execute the ''Details'' stored procedure
	
		The stored procedure that follows returns Actual, Original Budget, and Reforecast (Q1, Q2, and Q3) data that has been combined into a
			single dataset. This is returned by the stored procedure and inserted into the temp table below.
	
   =========================================================================================================================================== */
BEGIN

	CREATE TABLE #DetailResult
	(
		ExpenseType VARCHAR(50) NULL,
		InflowOutflow VARCHAR(50) NULL,
		MajorExpenseCategoryName VARCHAR(400) NULL,
		MinorExpenseCategoryName VARCHAR(400) NULL,
		GlobalGlAccountCode VARCHAR(50) NULL,
		GlobalGlAccountName VARCHAR(300) NULL,
		BusinessLine VARCHAR(50) NULL,
		ActivityType VARCHAR(50) NULL,
		ReportingEntityName VARCHAR(100) NULL,
		ReportingEntityType VARCHAR(50) NULL,
		PropertyFundCode VARCHAR(11) NULL,
		FunctionalDepartmentCode VARCHAR(15) NULL,
		AllocationSubRegionName VARCHAR(50) NULL,
		OriginatingSubRegionName VARCHAR(50) NULL,

		ActualsExpensePeriod VARCHAR(6) NULL,
		EntryDate VARCHAR(10) NULL,
		[User] NVARCHAR(20) NULL,
		[Description] NVARCHAR(60) NULL,
		AdditionalDescription NVARCHAR(4000) NULL,
		ReimbursableName VARCHAR(50) NULL,
		FeeAdjustmentCode VARCHAR(10) NULL,
		SourceName VARCHAR(50) NULL,
		GLCategorizationHierarchyKey INT not null,

		MtdActual MONEY NULL,
		MtdOriginalBudget MONEY NULL,
		MtdReforecastQ1 MONEY NULL,
		MtdReforecastQ2 MONEY NULL,
		MtdReforecastQ3 MONEY NULL,
		MtdVarianceQ0 MONEY NULL,
		MtdVarianceQ1 MONEY NULL,
		MtdVarianceQ2 MONEY NULL,
		MtdVarianceQ3 MONEY NULL,
		YtdActual MONEY NULL,
		YtdOriginalBudget MONEY NULL,
		YtdReforecastQ1 MONEY NULL,
		YtdReforecastQ2 MONEY NULL,
		YtdReforecastQ3 MONEY NULL,
		YtdVarianceQ0 MONEY NULL,
		YtdVarianceQ1 MONEY NULL,
		YtdVarianceQ2 MONEY NULL,
		YtdVarianceQ3 MONEY NULL,
		AnnualOriginalBudget MONEY NULL,
		AnnualReforecastQ1 MONEY NULL,
		AnnualReforecastQ2 MONEY NULL,
		AnnualReforecastQ3 MONEY NULL,
		ConsolidationSubRegionName VARCHAR(50) NULL
	)
	INSERT INTO #DetailResult
	(
		ExpenseType, 
		InflowOutflow,
		MajorExpenseCategoryName,
		MinorExpenseCategoryName,
		GlobalGlAccountCode,
		GlobalGlAccountName,
		BusinessLine,
		ActivityType,
		ReportingEntityName,
		ReportingEntityType,
		PropertyFundCode,
		FunctionalDepartmentCode,
		AllocationSubRegionName,
		OriginatingSubRegionName,
		ActualsExpensePeriod,
		EntryDate,
		[User],
		[Description],
		AdditionalDescription,
		ReimbursableName,
		FeeAdjustmentCode,
		SourceName,
		GLCategorizationHierarchyKey,

		-- Gross
		-- Month to Date    
		MtdActual,
		MtdOriginalBudget,
		MtdReforecastQ1,
		MtdReforecastQ2,
		MtdReforecastQ3,

		MtdVarianceQ0,
		MtdVarianceQ1,
		MtdVarianceQ2,
		MtdVarianceQ3,
		
		--Year to Date
		YtdActual,	
		YtdOriginalBudget,
		YtdReforecastQ1,
		YtdReforecastQ2,
		YtdReforecastQ3,

		-- Year to Date Variance
		YtdVarianceQ0,
		YtdVarianceQ1,
		YtdVarianceQ2,
		YtdVarianceQ3,
		
		-- Annual
		AnnualOriginalBudget,	
		AnnualReforecastQ1,
		AnnualReforecastQ2,
		AnnualReforecastQ3,
		ConsolidationSubRegionName
	)
	EXEC stp_R_ProfitabilityDetailV2
			@ReportExpensePeriod = @ReportExpensePeriod,
			@ReforecastQuarterName = @ReforecastQuarterName,
			@DestinationCurrency = @DestinationCurrency,
			@GLCategorizationName = @CategorizationName,
			@ActivityTypeList = @ActivityTypeList,
			@EntityList = @EntityList,
			@ConsolidationRegionList = @ConsolidationRegionList,
			@OriginatingSubRegionList = @OverheadOriginatingSubRegionList,
			@DisplayOverheadBy = @DisplayOverheadBy,
			@IncludeFeeAdjustments = @IncludeFeeAdjustments,
			@DontSensitizeMRIPayrollData = @DontSensitizeMRIPayrollData,
			@IncludeGrossNonPayrollExpenses = @IncludeGrossNonPayrollExpenses

	PRINT (''Detail stored procedure finished executing'')

END

/* =============================================================================================================================================
	3. Create Result


		┌────────────────────┬────────────────────────────────────────────────────────┐
		│ DisplayOrderNumber │ GroupDisplayName                                       │
		├────────────────────┼────────────────────────────────────────────────────────┤
		│                100 │		REVENUE                                           │
		│                200 │			Fee Revenue                                   │
		│                201 │				Acquisition Fees                          │
		│                202 │					Atlanda Adjustment                    │
		│                202 │					New York Adjustment                   │
		│                201 │              Management Fees                           │
		│                203 │			Total Fee Revenue                             │
		│                210 │			Other Revenue                                 │
		│                211 │				Miscellaneous Income                      │
		│                211 │				Investment Income                         │
		│                212 │			Total Other Income                            │
		│                220 │		TOTAL REVENUE                                     │
		│                230 │	<-BLANK ROW->                                         │
		│                240 │		EXPENSES                                          │
		│                241 │			Payroll Expenses                              │
		│                242 │				Gross Salaries/Bonus/Taxes/Benefits       │
		│                243 │				Reimbursed Salaries/Bonus/Taxes/Benefits  │
		│                244 │			Total Net Salary/Taxes/Benefits               │
		│                245 │			Payroll Reimbursement Rate                    │
		│                250 │	<-BLANK ROW->                                         │
		│                260 │			Overhead Expenses                             │
		│                262 │				Equipment Rental                          │
		│                262 │				Office Rental                             │
		│                271 │				Equipment Rental                          │
		│                271 │				Office Rental                             │
		│                273 │			Total Net Overhead Expenses                   │
		│                274 │			Overhead Reimbursement Rate                   │
		│                280 │	<-BLANK ROW->                                         │
		│                290 │			Non-Payroll Expenses                          │
		│                291 │			Gross Non-Payroll Expenses                    │
		│                292 │				Dues & Subscriptions                      │
		│                292 │				Storage Costs                             │
		│                293 │			Total Gross Non-Payroll Expenses              │
		│                301 │			Net Non-Payroll Expenses                      │
		│                302 │				Dues & Subscriptions                      │
		│                302 │				Storage Costs                             │
		│                303 │			Total Net Non-Payroll Expenses                │
		│                310 │	<-BLANK ROW->                                         │
		│                320 │		TOTAL NET EXPENSES                                │
		│                321 │	<-BLANK ROW->                                         │
		│                322 │		INCOME/(LOSS) Before Taxes & Depreciation         │
		│                323 │	<-BLANK ROW->                                         │
		│                324 │			Depreciation Expenses                         │
		│                325 │		INCOME/(LOSS) Before Taxes                        │
		│                326 │	<-BLANK ROW->                                         │
		│                327 │			Unrealized (Gain)/Loss                        │
		│                327 │			Realized (Gain)/Loss                          │
		│                327 │			Corporate Tax                                 │
		│                330 │		NET INCOME/(LOSS)                                 │
		│                331 │			Profit Margin (Profit / Total Revenue)        │
		│                340 │	<-BLANK ROW->                                         │
		│                341 │		UNKNOWN	                                          │
		└────────────────────┴────────────────────────────────────────────────────────┘

   =========================================================================================================================================== */	
BEGIN

	CREATE TABLE #Result
	(
		NumberOfSpacesToPad TINYINT NOT NULL,
		GroupDisplayCode VARCHAR(500) NOT NULL,
		GroupDisplayName VARCHAR(500) NOT NULL,
		DisplayOrderNumber INT NOT NULL,
		MtdActual MONEY NOT NULL DEFAULT(0),
		MtdOriginalBudget MONEY NOT NULL DEFAULT(0),
		MtdReforecastQ1 MONEY NOT NULL DEFAULT(0),
		MtdReforecastQ2 MONEY NOT NULL DEFAULT(0),
		MtdReforecastQ3 MONEY NOT NULL DEFAULT(0),

		MtdVarianceQ0 MONEY NOT NULL DEFAULT(0),
		MtdVarianceQ1 MONEY NOT NULL DEFAULT(0),
		MtdVarianceQ2 MONEY NOT NULL DEFAULT(0),
		MtdVarianceQ3 MONEY NOT NULL DEFAULT(0),

		MtdVariancePercentageQ0 MONEY NOT NULL DEFAULT(0),
		MtdVariancePercentageQ1 MONEY NOT NULL DEFAULT(0),
		MtdVariancePercentageQ2 MONEY NOT NULL DEFAULT(0),
		MtdVariancePercentageQ3 MONEY NOT NULL DEFAULT(0),

		YtdActual MONEY NOT NULL DEFAULT(0),
		YtdOriginalBudget MONEY NOT NULL DEFAULT(0),
		YtdReforecastQ1 MONEY NOT NULL DEFAULT(0),
		YtdReforecastQ2 MONEY NOT NULL DEFAULT(0),
		YtdReforecastQ3 MONEY NOT NULL DEFAULT(0),

		YtdVarianceQ0 MONEY NOT NULL DEFAULT(0),
		YtdVarianceQ1 MONEY NOT NULL DEFAULT(0),
		YtdVarianceQ2 MONEY NOT NULL DEFAULT(0),
		YtdVarianceQ3 MONEY NOT NULL DEFAULT(0),

		YtdVariancePercentageQ0 MONEY NOT NULL DEFAULT(0),
		YtdVariancePercentageQ1 MONEY NOT NULL DEFAULT(0),
		YtdVariancePercentageQ2 MONEY NOT NULL DEFAULT(0),
		YtdVariancePercentageQ3 MONEY NOT NULL DEFAULT(0),

		AnnualOriginalBudget MONEY NOT NULL DEFAULT(0),
		AnnualReforecastQ1 MONEY NOT NULL DEFAULT(0),
		AnnualReforecastQ2 MONEY NOT NULL DEFAULT(0),
		AnnualReforecastQ3 MONEY NOT NULL DEFAULT(0)
	)

	---------------------------------------------------------------------------------------------
	-- REVENUE (100) -> Fee Revenue (200)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber
		)
		VALUES
			(0, ''REVENUE'', ''REVENUE'', 100),
			(0, ''FEEREVENUE'', ''Fee Revenue'', 200)

	END

	---------------------------------------------------------------------------------------------
	-- REVENUE (100) -> Fee Revenue (200) -> Acquisition Fees (201)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
			MtdActual,
			MtdOriginalBudget,
			MtdReforecastQ1,
			MtdReforecastQ2,
			MtdReforecastQ3,
			MtdVarianceQ0,
			MtdVarianceQ1,
			MtdVarianceQ2,
			MtdVarianceQ3,
			YtdActual,	
			YtdOriginalBudget,
			YtdReforecastQ1,
			YtdReforecastQ2,
			YtdReforecastQ3,
			YtdVarianceQ0,
			YtdVarianceQ1,
			YtdVarianceQ2,
			YtdVarianceQ3,
			AnnualOriginalBudget,
			AnnualReforecastQ1,
			AnnualReforecastQ2,
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			GLCategorizationHierarchyLatestState.LatestGLMinorCategoryName AS GroupDisplayCode,
			GLCategorizationHierarchyLatestState.LatestGLMinorCategoryName AS GroupDisplayName,
			201 AS DisplayOrderNumber,
			ISNULL(SUM(t1.MtdActual), 0),
			ISNULL(SUM(t1.MtdOriginalBudget), 0),
			ISNULL(SUM(t1.MtdReforecastQ1), 0),
			ISNULL(SUM(t1.MtdReforecastQ2), 0),
			ISNULL(SUM(t1.MtdReforecastQ3), 0),
			ISNULL(SUM(t1.MtdVarianceQ0), 0),
			ISNULL(SUM(t1.MtdVarianceQ1) , 0),
			ISNULL(SUM(t1.MtdVarianceQ2), 0),
			ISNULL(SUM(t1.MtdVarianceQ3), 0),
			ISNULL(SUM(t1.YtdActual), 0),
			ISNULL(SUM(t1.YtdOriginalBudget), 0),
			ISNULL(SUM(t1.YtdReforecastQ1), 0),
			ISNULL(SUM(t1.YtdReforecastQ2), 0),
			ISNULL(SUM(t1.YtdReforecastQ3), 0),
			ISNULL(SUM(t1.YtdVarianceQ0), 0),
			ISNULL(SUM(t1.YtdVarianceQ1), 0),
			ISNULL(SUM(t1.YtdVarianceQ2), 0),
			ISNULL(SUM(t1.YtdVarianceQ3), 0),
			ISNULL(SUM(t1.AnnualOriginalBudget), 0),
			ISNULL(SUM(t1.AnnualReforecastQ1), 0),
			ISNULL(SUM(t1.AnnualReforecastQ2), 0),
			ISNULL(SUM(t1.AnnualReforecastQ3), 0)
		FROM 
			dbo.GLCategorizationHierarchy
			
			INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey

			LEFT OUTER JOIN 
			(
				SELECT 
					* 
				FROM 
					#DetailResult
				WHERE 
					@IncludeFeeAdjustments = 1 OR FeeAdjustmentCode = ''NORMAL''
			) t1 ON 
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = t1.GLCategorizationHierarchyKey
		WHERE	
			GLCategorizationHierarchy.InflowOutflow	= ''Inflow'' AND
			GLCategorizationHierarchy.GLFinancialCategoryName = ''Fee Income'' AND
			GLCategorizationHierarchy.GLCategorizationName = @CategorizationName
		GROUP BY
			GLCategorizationHierarchyLatestState.LatestGLMinorCategoryName
				
		-- Fee adjustment Insert queries removed as per Change Request 13
	END

	---------------------------------------------------------------------------------------------
	-- REVENUE (100) -> Total Fee Revenue (203)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
			MtdActual,
			MtdOriginalBudget,
			MtdReforecastQ1,
			MtdReforecastQ2,
			MtdReforecastQ3,
			MtdVarianceQ0,
			MtdVarianceQ1,
			MtdVarianceQ2,
			MtdVarianceQ3,
			YtdActual,
			YtdOriginalBudget,
			YtdReforecastQ1,
			YtdReforecastQ2,
			YtdReforecastQ3,
			YtdVarianceQ0,
			YtdVarianceQ1,
			YtdVarianceQ2,
			YtdVarianceQ3,
			AnnualOriginalBudget,
			AnnualReforecastQ1,
			AnnualReforecastQ2,
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			''TOTALFEEREVENUE'' AS GroupDisplayCode,
			''Total Fee Revenue'' AS GroupDisplayName,
			203 AS DisplayOrderNumber,
			ISNULL(SUM(MtdActual), 0),
			ISNULL(SUM(MtdOriginalBudget), 0),
			ISNULL(SUM(MtdReforecastQ1), 0),
			ISNULL(SUM(MtdReforecastQ2), 0),
			ISNULL(SUM(MtdReforecastQ3), 0),
			ISNULL(SUM(MtdVarianceQ0), 0),
			ISNULL(SUM(MtdVarianceQ1), 0),
			ISNULL(SUM(MtdVarianceQ2), 0),
			ISNULL(SUM(MtdVarianceQ3), 0),
			ISNULL(SUM(YtdActual), 0),
			ISNULL(SUM(YtdOriginalBudget), 0),
			ISNULL(SUM(YtdReforecastQ1), 0),
			ISNULL(SUM(YtdReforecastQ2), 0),
			ISNULL(SUM(YtdReforecastQ3), 0),
			ISNULL(SUM(YtdVarianceQ0), 0),
			ISNULL(SUM(YtdVarianceQ1), 0),
			ISNULL(SUM(YtdVarianceQ2), 0),
			ISNULL(SUM(YtdVarianceQ3), 0),
			ISNULL(SUM(AnnualOriginalBudget), 0),
			ISNULL(SUM(AnnualReforecastQ1), 0),
			ISNULL(SUM(AnnualReforecastQ2), 0),
			ISNULL(SUM(AnnualReforecastQ3), 0)
		FROM
			#DetailResult
		WHERE
			InflowOutflow = ''Inflow'' AND
			ExpenseType = ''Fee Income''

	END

	---------------------------------------------------------------------------------------------
	-- REVENUE (100) -> Other Revenue (210)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad,
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber
		)
		VALUES
			(0, ''OTHERREVENUE'', ''Other Revenue'', 210)
	
	END

	---------------------------------------------------------------------------------------------
	-- REVENUE (100) -> Other Revenue (210) -> Miscellaneous Income / Investment Income (211)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
			MtdActual,
			MtdOriginalBudget,
			MtdReforecastQ1,
			MtdReforecastQ2,
			MtdReforecastQ3,
			MtdVarianceQ0,
			MtdVarianceQ1,
			MtdVarianceQ2,
			MtdVarianceQ3,
			YtdActual,	
			YtdOriginalBudget,
			YtdReforecastQ1,
			YtdReforecastQ2,
			YtdReforecastQ3,
			YtdVarianceQ0,
			YtdVarianceQ1,
			YtdVarianceQ2,
			YtdVarianceQ3,
			AnnualOriginalBudget,
			AnnualReforecastQ1,
			AnnualReforecastQ2,
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayCode,
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayName,
			211 AS DisplayOrderNumber,
			ISNULL(SUM(DetailResult.MtdActual), 0),
			ISNULL(SUM(DetailResult.MtdOriginalBudget), 0),
			ISNULL(SUM(DetailResult.MtdReforecastQ1), 0),
			ISNULL(SUM(DetailResult.MtdReforecastQ2), 0),
			ISNULL(SUM(DetailResult.MtdReforecastQ3), 0),
			ISNULL(SUM(DetailResult.MtdVarianceQ0), 0),
			ISNULL(SUM(DetailResult.MtdVarianceQ1), 0),
			ISNULL(SUM(DetailResult.MtdVarianceQ2), 0),
			ISNULL(SUM(DetailResult.MtdVarianceQ3), 0),
			ISNULL(SUM(DetailResult.YtdActual), 0),
			ISNULL(SUM(DetailResult.YtdOriginalBudget), 0),
			ISNULL(SUM(DetailResult.YtdReforecastQ1), 0),
			ISNULL(SUM(DetailResult.YtdReforecastQ2), 0),
			ISNULL(SUM(DetailResult.YtdReforecastQ3), 0),
			ISNULL(SUM(DetailResult.YtdVarianceQ0), 0),
			ISNULL(SUM(DetailResult.YtdVarianceQ1), 0),
			ISNULL(SUM(DetailResult.YtdVarianceQ2), 0),
			ISNULL(SUM(DetailResult.YtdVarianceQ3), 0),
			ISNULL(SUM(DetailResult.AnnualOriginalBudget), 0),
			ISNULL(SUM(DetailResult.AnnualReforecastQ1), 0),
			ISNULL(SUM(DetailResult.AnnualReforecastQ2), 0),
			ISNULL(SUM(DetailResult.AnnualReforecastQ3), 0)
		FROM 
			dbo.GLCategorizationHierarchy
			
			INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey

			LEFT OUTER JOIN #DetailResult DetailResult ON 
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = DetailResult.GLCategorizationHierarchyKey
		WHERE
			GLCategorizationHierarchy.InflowOutflow	= ''Inflow'' AND
			GLCategorizationHierarchy.GLFinancialCategoryName = ''Other Revenue'' AND
			GLCategorizationHierarchy.GLMajorCategoryName <> ''Realized (Gain)/Loss'' AND --IMS #61973
			GLCategorizationHierarchy.GLCategorizationName = @CategorizationName
		GROUP BY
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName

	END

	---------------------------------------------------------------------------------------------
	-- REVENUE (100) -> Total Other Income (212)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
			MtdActual,
			MtdOriginalBudget,
			MtdReforecastQ1,
			MtdReforecastQ2,
			MtdReforecastQ3,
			MtdVarianceQ0,
			MtdVarianceQ1,
			MtdVarianceQ2,
			MtdVarianceQ3,
			YtdActual,
			YtdOriginalBudget,
			YtdReforecastQ1,
			YtdReforecastQ2,
			YtdReforecastQ3,
			YtdVarianceQ0,
			YtdVarianceQ1,
			YtdVarianceQ2,
			YtdVarianceQ3,
			AnnualOriginalBudget,
			AnnualReforecastQ1,
			AnnualReforecastQ2,
			AnnualReforecastQ3
		)
		SELECT 
			0 AS NumberOfSpacesToPad,
			''TOTALOTHERREVENUE'' AS GroupDisplayCode,
			''Total Other Revenue'' AS GroupDisplayName,
			212 AS DisplayOrderNumber,
			ISNULL(SUM(MtdActual), 0),
			ISNULL(SUM(MtdOriginalBudget), 0),
			ISNULL(SUM(MtdReforecastQ1), 0),
			ISNULL(SUM(MtdReforecastQ2), 0),
			ISNULL(SUM(MtdReforecastQ3), 0),
			ISNULL(SUM(MtdVarianceQ0), 0),
			ISNULL(SUM(MtdVarianceQ1), 0),
			ISNULL(SUM(MtdVarianceQ2), 0),
			ISNULL(SUM(MtdVarianceQ3), 0),
			ISNULL(SUM(YtdActual), 0),
			ISNULL(SUM(YtdOriginalBudget), 0),
			ISNULL(SUM(YtdReforecastQ1), 0),
			ISNULL(SUM(YtdReforecastQ2), 0),
			ISNULL(SUM(YtdReforecastQ3), 0),
			ISNULL(SUM(YtdVarianceQ0), 0),
			ISNULL(SUM(YtdVarianceQ1), 0),
			ISNULL(SUM(YtdVarianceQ2), 0),
			ISNULL(SUM(YtdVarianceQ3), 0),
			ISNULL(SUM(AnnualOriginalBudget), 0),
			ISNULL(SUM(AnnualReforecastQ1), 0),
			ISNULL(SUM(AnnualReforecastQ2), 0),
			ISNULL(SUM(AnnualReforecastQ3), 0)
		FROM 
			#DetailResult 
		WHERE
			InflowOutflow = ''Inflow'' AND
			MajorExpenseCategoryName <> ''Realized (Gain)/Loss'' AND --IMS #61973
			ExpenseType = ''Other Revenue''

	END

	---------------------------------------------------------------------------------------------
	-- TOTAL REVENUE (220)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
			MtdActual,
			MtdOriginalBudget,
			MtdReforecastQ1,
			MtdReforecastQ2,
			MtdReforecastQ3,
			MtdVarianceQ0,
			MtdVarianceQ1,
			MtdVarianceQ2,
			MtdVarianceQ3,
			YtdActual,	
			YtdOriginalBudget,
			YtdReforecastQ1,
			YtdReforecastQ2,
			YtdReforecastQ3,
			YtdVarianceQ0,
			YtdVarianceQ1,
			YtdVarianceQ2,
			YtdVarianceQ3,
			AnnualOriginalBudget,
			AnnualReforecastQ1,
			AnnualReforecastQ2,
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			''TOTALREVENUE'' AS GroupDisplayCode,
			''Total Revenue'' AS GroupDisplayName,
			220 AS DisplayOrderNumber,
			ISNULL(SUM(MtdActual), 0),
			ISNULL(SUM(MtdOriginalBudget), 0),
			ISNULL(SUM(MtdReforecastQ1), 0),
			ISNULL(SUM(MtdReforecastQ2), 0),
			ISNULL(SUM(MtdReforecastQ3), 0),
			ISNULL(SUM(MtdVarianceQ0), 0),
			ISNULL(SUM(MtdVarianceQ1), 0),
			ISNULL(SUM(MtdVarianceQ2), 0),
			ISNULL(SUM(MtdVarianceQ3), 0),
			ISNULL(SUM(YtdActual), 0),
			ISNULL(SUM(YtdOriginalBudget), 0),
			ISNULL(SUM(YtdReforecastQ1), 0),
			ISNULL(SUM(YtdReforecastQ2), 0),
			ISNULL(SUM(YtdReforecastQ3), 0),
			ISNULL(SUM(YtdVarianceQ0), 0),
			ISNULL(SUM(YtdVarianceQ1), 0),
			ISNULL(SUM(YtdVarianceQ2), 0),
			ISNULL(SUM(YtdVarianceQ3), 0),
			ISNULL(SUM(AnnualOriginalBudget), 0),
			ISNULL(SUM(AnnualReforecastQ1), 0),
			ISNULL(SUM(AnnualReforecastQ2), 0),
			ISNULL(SUM(AnnualReforecastQ3), 0)
		FROM 
			#DetailResult
		WHERE
			InflowOutflow = ''Inflow'' AND
			MajorExpenseCategoryName <> ''Realized (Gain)/Loss'' --IMS #61973

	END

	---------------------------------------------------------------------------------------------
	-- EXPENSES (240) -> Payroll Expenses (241)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad,
			GroupDisplayCode,
			GroupDisplayName,
			DisplayOrderNumber
		)
		VALUES
			(0, ''BLANK'', '''', 230),
			(0, ''EXPENSES'', ''EXPENSES'', 240),
			(0, ''PAYROLLEXPENSES'', ''Payroll Expenses'', 241)

	END

	---------------------------------------------------------------------------------------------
	-- EXPENSES (240) -> Payroll Expenses (241) -> Gross Salaries/Bonus/Taxes/Benefits (242)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
			MtdActual,
			MtdOriginalBudget,
			MtdReforecastQ1,
			MtdReforecastQ2,
			MtdReforecastQ3,
			MtdVarianceQ0,
			MtdVarianceQ1,
			MtdVarianceQ2,
			MtdVarianceQ3,
			YtdActual,	
			YtdOriginalBudget,
			YtdReforecastQ1,
			YtdReforecastQ2,
			YtdReforecastQ3,
			YtdVarianceQ0,
			YtdVarianceQ1,
			YtdVarianceQ2,
			YtdVarianceQ3,
			AnnualOriginalBudget,
			AnnualReforecastQ1,
			AnnualReforecastQ2,
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			''Gross '' + MajorExpenseCategoryName AS GroupDisplayCode,
			''Gross '' + MajorExpenseCategoryName AS GroupDisplayName,
			242 AS DisplayOrderNumber,
			ISNULL(SUM(MtdActual), 0) * -1,
			ISNULL(SUM(MtdOriginalBudget), 0) * -1,
			ISNULL(SUM(MtdReforecastQ1), 0) * -1,
			ISNULL(SUM(MtdReforecastQ2), 0) * -1,
			ISNULL(SUM(MtdReforecastQ3), 0) * -1,
			
			-- Variance amounts adjusted as per IMS 61749
			ISNULL(SUM(CASE WHEN ReimbursableName = ''Reimbursable'' THEN (MtdVarianceQ0 * -1) ELSE MtdVarianceQ0 END), 0) * -1,
			ISNULL(SUM(CASE WHEN ReimbursableName = ''Reimbursable'' THEN (MtdVarianceQ1 * -1) ELSE MtdVarianceQ1 END), 0) * -1,
			ISNULL(SUM(CASE WHEN ReimbursableName = ''Reimbursable'' THEN (MtdVarianceQ2 * -1) ELSE MtdVarianceQ2 END), 0) * -1,
			ISNULL(SUM(CASE WHEN ReimbursableName = ''Reimbursable'' THEN (MtdVarianceQ3 * -1) ELSE MtdVarianceQ3 END), 0) * -1,
			ISNULL(SUM(YtdActual), 0) * -1,
			ISNULL(SUM(YtdOriginalBudget), 0) * -1,
			ISNULL(SUM(YtdReforecastQ1), 0) * -1,
			ISNULL(SUM(YtdReforecastQ2), 0) * -1,
			ISNULL(SUM(YtdReforecastQ3), 0) * -1,
			ISNULL(SUM(CASE WHEN ReimbursableName = ''Reimbursable'' THEN (YtdVarianceQ0 * -1) ELSE YtdVarianceQ0 END), 0) * -1,
			ISNULL(SUM(CASE WHEN ReimbursableName = ''Reimbursable'' THEN (YtdVarianceQ1 * -1) ELSE YtdVarianceQ1 END), 0) * -1,
			ISNULL(SUM(CASE WHEN ReimbursableName = ''Reimbursable'' THEN (YtdVarianceQ2 * -1) ELSE YtdVarianceQ2 END), 0) * -1,
			ISNULL(SUM(CASE WHEN ReimbursableName = ''Reimbursable'' THEN (YtdVarianceQ3 * -1) ELSE YtdVarianceQ3 END), 0) * -1,
			ISNULL(SUM(AnnualOriginalBudget), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ1), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ2), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ3), 0) * -1
		FROM 
			#DetailResult
		WHERE
			InflowOutflow = ''Outflow'' AND
			ExpenseType = ''Payroll''
		GROUP BY
			MajorExpenseCategoryName	

	END

	---------------------------------------------------------------------------------------------
	-- EXPENSES (240) -> Payroll Expenses (241) -> Reimbursed Salaries/Bonus/Taxes/Benefits (243)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
			MtdActual,
			MtdOriginalBudget,
			MtdReforecastQ1,
			MtdReforecastQ2,
			MtdReforecastQ3,
			MtdVarianceQ0,
			MtdVarianceQ1,
			MtdVarianceQ2,
			MtdVarianceQ3,
			YtdActual,	
			YtdOriginalBudget,
			YtdReforecastQ1,
			YtdReforecastQ2,
			YtdReforecastQ3,
			YtdVarianceQ0,
			YtdVarianceQ1,
			YtdVarianceQ2,
			YtdVarianceQ3,
			AnnualOriginalBudget,
			AnnualReforecastQ1,
			AnnualReforecastQ2,
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			''Reimbursed '' + MajorExpenseCategoryName AS GroupDisplayCode,
			''Reimbursed '' + MajorExpenseCategoryName AS GroupDisplayName,
			243 AS DisplayOrderNumber,
			ISNULL(SUM(MtdActual), 0) * -1,
			ISNULL(SUM(MtdOriginalBudget), 0) * -1,
			ISNULL(SUM(MtdReforecastQ1), 0) * -1,
			ISNULL(SUM(MtdReforecastQ2), 0) * -1,
			ISNULL(SUM(MtdReforecastQ3), 0) * -1,
			ISNULL(SUM(MtdVarianceQ0), 0) * -1,
			ISNULL(SUM(MtdVarianceQ1), 0) * -1,
			ISNULL(SUM(MtdVarianceQ2), 0) * -1,
			ISNULL(SUM(MtdVarianceQ3), 0) * -1,
			ISNULL(SUM(YtdActual), 0) * -1,
			ISNULL(SUM(YtdOriginalBudget), 0) * -1,
			ISNULL(SUM(YtdReforecastQ1), 0) * -1,
			ISNULL(SUM(YtdReforecastQ2), 0) * -1,
			ISNULL(SUM(YtdReforecastQ3), 0) * -1,
			ISNULL(SUM(YtdVarianceQ0), 0) * -1,
			ISNULL(SUM(YtdVarianceQ1), 0) * -1,
			ISNULL(SUM(YtdVarianceQ2), 0) * -1,
			ISNULL(SUM(YtdVarianceQ3), 0) * -1,
			ISNULL(SUM(AnnualOriginalBudget), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ1), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ2), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ3), 0) * -1
		FROM 
			#DetailResult
		WHERE	
			InflowOutflow = ''Outflow'' AND
			ExpenseType = ''Payroll'' AND
			ReimbursableName = ''Reimbursable''
		GROUP BY
			#DetailResult.MajorExpenseCategoryName	

	END

	---------------------------------------------------------------------------------------------
	-- EXPENSES (240) -> Total Net Salary/Taxes/Benefits (244)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
			MtdActual,
			MtdOriginalBudget,
			MtdReforecastQ1,
			MtdReforecastQ2,
			MtdReforecastQ3,
			MtdVarianceQ0,
			MtdVarianceQ1,
			MtdVarianceQ2,
			MtdVarianceQ3,
			YtdActual,
			YtdOriginalBudget,
			YtdReforecastQ1,
			YtdReforecastQ2,
			YtdReforecastQ3,
			YtdVarianceQ0,
			YtdVarianceQ1,
			YtdVarianceQ2,
			YtdVarianceQ3,
			AnnualOriginalBudget,
			AnnualReforecastQ1,
			AnnualReforecastQ2,
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			''Total Net '' + MajorExpenseCategoryName AS GroupDisplayCode,
			''Total Net '' + MajorExpenseCategoryName AS GroupDisplayName,
			244 AS DisplayOrderNumber,
			ISNULL(SUM(MtdActual), 0) * -1,
			ISNULL(SUM(MtdOriginalBudget), 0) * -1,
			ISNULL(SUM(MtdReforecastQ1), 0) * -1,
			ISNULL(SUM(MtdReforecastQ2), 0) * -1,
			ISNULL(SUM(MtdReforecastQ3), 0) * -1,
			ISNULL(SUM(MtdVarianceQ0), 0) * -1,
			ISNULL(SUM(MtdVarianceQ1), 0) * -1,
			ISNULL(SUM(MtdVarianceQ2), 0) * -1,
			ISNULL(SUM(MtdVarianceQ3), 0) * -1,
			ISNULL(SUM(YtdActual), 0) * -1,
			ISNULL(SUM(YtdOriginalBudget), 0) * -1,
			ISNULL(SUM(YtdReforecastQ1), 0) * -1,
			ISNULL(SUM(YtdReforecastQ2), 0) * -1,
			ISNULL(SUM(YtdReforecastQ3), 0) * -1,
			ISNULL(SUM(YtdVarianceQ0), 0) * -1,
			ISNULL(SUM(YtdVarianceQ1), 0) * -1,
			ISNULL(SUM(YtdVarianceQ2), 0) * -1,
			ISNULL(SUM(YtdVarianceQ3), 0) * -1,
			ISNULL(SUM(AnnualOriginalBudget), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ1), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ2), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ3), 0) * -1
		FROM
			#DetailResult
		WHERE	
			#DetailResult.InflowOutflow	= ''Outflow'' AND
			#DetailResult.ReimbursableName = ''Not Reimbursable'' AND
			#DetailResult.ExpenseType = ''Payroll''
		GROUP BY
			#DetailResult.MajorExpenseCategoryName

	END

	---------------------------------------------------------------------------------------------
	-- EXPENSES (240) -> Payroll Reimbursement Rate (245)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
			MtdActual,
			MtdOriginalBudget,
			MtdReforecastQ1,
			MtdReforecastQ2,
			MtdReforecastQ3,
			MtdVarianceQ0,
			MtdVarianceQ1,
			MtdVarianceQ2,
			MtdVarianceQ3,
			YtdActual,
			YtdOriginalBudget,
			YtdReforecastQ1,
			YtdReforecastQ2,
			YtdReforecastQ3,
			YtdVarianceQ0,
			YtdVarianceQ1,
			YtdVarianceQ2,
			YtdVarianceQ3,
			AnnualOriginalBudget,
			AnnualReforecastQ1,
			AnnualReforecastQ2,
			AnnualReforecastQ3
		)
		SELECT 
			0 AS NumberOfSpacesToPad,
			''Payroll Reimbursement Rate'' AS GroupDisplayCode,
			''% Recovery'' AS GroupDisplayName,
			245 AS DisplayOrderNumber,
			ISNULL(Reimbursed.MtdActual / CASE WHEN Gross.MtdActual = 0 THEN NULL ELSE Gross.MtdActual END, 0),
			ISNULL(Reimbursed.MtdOriginalBudget / CASE WHEN Gross.MtdOriginalBudget = 0 THEN NULL ELSE Gross.MtdOriginalBudget END, 0),
			ISNULL(Reimbursed.MtdReforecastQ1 / CASE WHEN Gross.MtdReforecastQ1 = 0 THEN NULL ELSE Gross.MtdReforecastQ1 END, 0),
			ISNULL(Reimbursed.MtdReforecastQ2 / CASE WHEN Gross.MtdReforecastQ2 = 0 THEN NULL ELSE Gross.MtdReforecastQ2 END, 0),
			ISNULL(Reimbursed.MtdReforecastQ3 / CASE WHEN Gross.MtdReforecastQ3 = 0 THEN NULL ELSE Gross.MtdReforecastQ3 END, 0),
			0,
			0,
			0,
			0,
			ISNULL(Reimbursed.YtdActual / CASE WHEN Gross.YtdActual = 0 THEN NULL ELSE Gross.YtdActual END, 0),
			ISNULL(Reimbursed.YtdOriginalBudget / CASE WHEN Gross.YtdOriginalBudget = 0 THEN NULL ELSE Gross.YtdOriginalBudget END, 0),
			ISNULL(Reimbursed.YtdReforecastQ1 / CASE WHEN Gross.YtdReforecastQ1 = 0 THEN NULL ELSE Gross.YtdReforecastQ1 END, 0),
			ISNULL(Reimbursed.YtdReforecastQ2 / CASE WHEN Gross.YtdReforecastQ2 = 0 THEN NULL ELSE Gross.YtdReforecastQ2 END, 0),
			ISNULL(Reimbursed.YtdReforecastQ3 / CASE WHEN Gross.YtdReforecastQ3 = 0 THEN NULL ELSE Gross.YtdReforecastQ3 END, 0),
			0,
			0,
			0,
			0,
			ISNULL(Reimbursed.AnnualOriginalBudget / CASE WHEN Gross.AnnualOriginalBudget = 0 THEN NULL ELSE Gross.AnnualOriginalBudget END, 0),
			ISNULL(Reimbursed.AnnualReforecastQ1 / CASE WHEN Gross.AnnualReforecastQ1 = 0 THEN NULL ELSE Gross.AnnualReforecastQ1 END, 0),
			ISNULL(Reimbursed.AnnualReforecastQ2 / CASE WHEN Gross.AnnualReforecastQ2 = 0 THEN NULL ELSE Gross.AnnualReforecastQ2 END, 0),
			ISNULL(Reimbursed.AnnualReforecastQ3 / CASE WHEN Gross.AnnualReforecastQ3 = 0 THEN NULL ELSE Gross.AnnualReforecastQ3 END, 0)
		FROM 
		(
			SELECT 
				ISNULL(SUM(MtdActual), 0) AS MtdActual,
				ISNULL(SUM(MtdOriginalBudget), 0) AS MtdOriginalBudget,
				ISNULL(SUM(MtdReforecastQ1), 0) AS MtdReforecastQ1,
				ISNULL(SUM(MtdReforecastQ2), 0) AS MtdReforecastQ2,
				ISNULL(SUM(MtdReforecastQ3), 0) AS MtdReforecastQ3,
				ISNULL(SUM(MtdVarianceQ0), 0) AS MtdVarianceQ0,
				ISNULL(SUM(MtdVarianceQ1), 0) AS MtdVarianceQ1,
				ISNULL(SUM(MtdVarianceQ2), 0) AS MtdVarianceQ2,
				ISNULL(SUM(MtdVarianceQ3), 0) AS MtdVarianceQ3,
				ISNULL(SUM(YtdActual), 0) AS YtdActual,
				ISNULL(SUM(YtdOriginalBudget), 0) AS YtdOriginalBudget,
				ISNULL(SUM(YtdReforecastQ1), 0) AS YtdReforecastQ1,
				ISNULL(SUM(YtdReforecastQ2), 0) AS YtdReforecastQ2,
				ISNULL(SUM(YtdReforecastQ3), 0) AS YtdReforecastQ3,
				ISNULL(SUM(YtdVarianceQ0), 0) AS YtdVarianceQ0,
				ISNULL(SUM(YtdVarianceQ1), 0) AS YtdVarianceQ1,
				ISNULL(SUM(YtdVarianceQ2), 0) AS YtdVarianceQ2,
				ISNULL(SUM(YtdVarianceQ3), 0) AS YtdVarianceQ3,
				ISNULL(SUM(AnnualOriginalBudget), 0) AS AnnualOriginalBudget,
				ISNULL(SUM(AnnualReforecastQ1), 0) AS AnnualReforecastQ1,
				ISNULL(SUM(AnnualReforecastQ2), 0) AS AnnualReforecastQ2,
				ISNULL(SUM(AnnualReforecastQ3), 0) AS AnnualReforecastQ3
			FROM 
				#DetailResult
			WHERE
				InflowOutflow = ''Outflow'' AND
				ReimbursableName = ''Reimbursable'' AND
				ExpenseType = ''Payroll''
		) Reimbursed

		CROSS JOIN
		(
			SELECT 
				ISNULL(SUM(MtdActual), 0) MtdActual,
				ISNULL(SUM(MtdOriginalBudget), 0) MtdOriginalBudget,
				ISNULL(SUM(MtdReforecastQ1), 0) MtdReforecastQ1,
				ISNULL(SUM(MtdReforecastQ2), 0) MtdReforecastQ2,
				ISNULL(SUM(MtdReforecastQ3), 0) MtdReforecastQ3,
				ISNULL(SUM(MtdVarianceQ0), 0) MtdVarianceQ0,
				ISNULL(SUM(MtdVarianceQ1), 0) MtdVarianceQ1,
				ISNULL(SUM(MtdVarianceQ2), 0) MtdVarianceQ2,
				ISNULL(SUM(MtdVarianceQ3), 0) MtdVarianceQ3,
				ISNULL(SUM(YtdActual), 0) YtdActual,
				ISNULL(SUM(YtdOriginalBudget), 0) YtdOriginalBudget,
				ISNULL(SUM(YtdReforecastQ1), 0) YtdReforecastQ1,
				ISNULL(SUM(YtdReforecastQ2), 0) YtdReforecastQ2,
				ISNULL(SUM(YtdReforecastQ3), 0) YtdReforecastQ3,
				ISNULL(SUM(YtdVarianceQ0), 0) YtdVarianceQ0,
				ISNULL(SUM(YtdVarianceQ1), 0) YtdVarianceQ1,
				ISNULL(SUM(YtdVarianceQ2), 0) YtdVarianceQ2,
				ISNULL(SUM(YtdVarianceQ3), 0) YtdVarianceQ3,
				ISNULL(SUM(AnnualOriginalBudget), 0) AnnualOriginalBudget,
				ISNULL(SUM(AnnualReforecastQ1), 0) AnnualReforecastQ1,
				ISNULL(SUM(AnnualReforecastQ2), 0) AnnualReforecastQ2,
				ISNULL(SUM(AnnualReforecastQ3), 0) AnnualReforecastQ3
			FROM 
				#DetailResult
			WHERE
				InflowOutflow = ''Outflow'' AND
				ExpenseType = ''Payroll''
		) Gross 

		UPDATE -- Calculate the Payroll Reimbursement Rate Variance Columns
			#Result
		SET
			MtdVarianceQ0 = (MtdActual - MtdOriginalBudget),
			MtdVarianceQ1 = (MtdActual - MtdReforecastQ1),
			MtdVarianceQ2 = (MtdActual - MtdReforecastQ2),
			MtdVarianceQ3 = (MtdActual - MtdReforecastQ3),
			YtdVarianceQ0 = (YtdActual - YtdOriginalBudget),
			YtdVarianceQ1 = (YtdActual - YtdReforecastQ1),
			YtdVarianceQ2 = (YtdActual - YtdReforecastQ2),
			YtdVarianceQ3 = (YtdActual - YtdReforecastQ3)
		WHERE
			GroupDisplayCode = ''Payroll Reimbursement Rate'' AND
			DisplayOrderNumber = 245

	END

	---------------------------------------------------------------------------------------------
	-- EXPENSES (240) -> Overhead Expenses (260)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad,
			GroupDisplayCode,
			GroupDisplayName,
			DisplayOrderNumber
		)
		VALUES
			(0, ''BLANK'', '''', 250),
			(0, ''OVERHEADEXPENSE'', ''Overhead  Expenses'', 260)

	END

	--Removed GROSS OVERHEAD Expense header due to IMS #62074 

	IF (@_DisplayOverheadBy = @UnAllocatedOverhead)
	BEGIN
		---------------------------------------------------------------------------------------------
		-- EXPENSES (240) -> Overhead Expenses (260) -> Equipment Rental / Office Rental (262)
		---------------------------------------------------------------------------------------------
		BEGIN

			INSERT INTO #Result
			(
				NumberOfSpacesToPad, 
				GroupDisplayCode, 
				GroupDisplayName, 
				DisplayOrderNumber,
				MtdActual,
				MtdOriginalBudget,
				MtdReforecastQ1,
				MtdReforecastQ2,
				MtdReforecastQ3,
				MtdVarianceQ0,
				MtdVarianceQ1,
				MtdVarianceQ2,
				MtdVarianceQ3,
				YtdActual,	
				YtdOriginalBudget,
				YtdReforecastQ1,
				YtdReforecastQ2,
				YtdReforecastQ3,
				YtdVarianceQ0,
				YtdVarianceQ1,
				YtdVarianceQ2,
				YtdVarianceQ3,
				AnnualOriginalBudget,
				AnnualReforecastQ1,
				AnnualReforecastQ2,
				AnnualReforecastQ3
			)
			SELECT 
				0 AS NumberOfSpacesToPad,
				''Gross '' + GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayCode,
				''Gross '' + GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayName,
				262 AS DisplayOrderNumber,
				ISNULL(SUM(OverheadDetailResults.MtdActual), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.MtdOriginalBudget), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.MtdReforecastQ1), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.MtdReforecastQ2), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.MtdReforecastQ3), 0) * -1,
				
				-- Variance amounts adjusted as per IMS 61749
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = ''Reimbursable'' THEN (OverheadDetailResults.MtdVarianceQ0 * -1) ELSE OverheadDetailResults.MtdVarianceQ0 END), 0) * -1,
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = ''Reimbursable'' THEN (OverheadDetailResults.MtdVarianceQ1 * -1) ELSE OverheadDetailResults.MtdVarianceQ1 END), 0) * -1,
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = ''Reimbursable'' THEN (OverheadDetailResults.MtdVarianceQ2 * -1) ELSE OverheadDetailResults.MtdVarianceQ2 END), 0) * -1,
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = ''Reimbursable'' THEN (OverheadDetailResults.MtdVarianceQ3 * -1) ELSE OverheadDetailResults.MtdVarianceQ3 END), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.YtdActual), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.YtdOriginalBudget), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.YtdReforecastQ1), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.YtdReforecastQ2), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.YtdReforecastQ3), 0) * -1,
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = ''Reimbursable'' THEN (OverheadDetailResults.YtdVarianceQ0 * -1) ELSE OverheadDetailResults.YtdVarianceQ0 END), 0) * -1,
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = ''Reimbursable'' THEN (OverheadDetailResults.YtdVarianceQ1 * -1) ELSE OverheadDetailResults.YtdVarianceQ1 END), 0) * -1,
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = ''Reimbursable'' THEN (OverheadDetailResults.YtdVarianceQ2 * -1) ELSE OverheadDetailResults.YtdVarianceQ2 END), 0) * -1,
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = ''Reimbursable'' THEN (OverheadDetailResults.YtdVarianceQ3 * -1) ELSE OverheadDetailResults.YtdVarianceQ3 END), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.AnnualOriginalBudget), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.AnnualReforecastQ1), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.AnnualReforecastQ2), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.AnnualReforecastQ3), 0) * -1
			FROM 
				dbo.GLCategorizationHierarchy
				
				INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
					GLCategorizationHierarchy.GLCategorizationHierarchyKey = GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey

				LEFT OUTER JOIN
				(
					SELECT
						* 
					FROM 
						#DetailResult
					WHERE 
						ExpenseType = ''Overhead''
				) OverheadDetailResults ON 
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = OverheadDetailResults.GLCategorizationHierarchyKey
			WHERE
				GLCategorizationHierarchy.InflowOutflow	= ''Outflow'' AND
				GLCategorizationHierarchy.GLCategorizationName = @CategorizationName AND
				GLCategorizationHierarchy.GLFinancialCategoryName IN (''Overhead'', ''Non-Payroll'', ''Payroll'')  AND
				GLCategorizationHierarchy.GLMajorCategoryName <> ''Corporate Tax''
			GROUP BY
				GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName

		END

	END
	ELSE
	BEGIN
		---------------------------------------------------------------------------------------------
		-- EXPENSES (240) -> Overhead Expenses (260) -> Equipment Rental / Office Rental (262)
		---------------------------------------------------------------------------------------------
		BEGIN

			INSERT INTO #Result
			(
				NumberOfSpacesToPad, 
				GroupDisplayCode, 
				GroupDisplayName, 
				DisplayOrderNumber,
				MtdActual,
				MtdOriginalBudget,
				MtdReforecastQ1,
				MtdReforecastQ2,
				MtdReforecastQ3,
				MtdVarianceQ0,
				MtdVarianceQ1,
				MtdVarianceQ2,
				MtdVarianceQ3,
				YtdActual,	
				YtdOriginalBudget,
				YtdReforecastQ1,
				YtdReforecastQ2,
				YtdReforecastQ3,
				YtdVarianceQ0,
				YtdVarianceQ1,
				YtdVarianceQ2,
				YtdVarianceQ3,
				AnnualOriginalBudget,
				AnnualReforecastQ1,
				AnnualReforecastQ2,
				AnnualReforecastQ3
			)
			SELECT 
				0 AS NumberOfSpacesToPad,
				''Gross '' + GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayCode,
				''Gross '' + GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayName,
				262 DisplayOrderNumber,
				ISNULL(SUM(OverheadDetailResults.MtdActual), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.MtdOriginalBudget), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.MtdReforecastQ1), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.MtdReforecastQ2), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.MtdReforecastQ3), 0) * -1,
				-- Variance amounts adjusted as per IMS 61749
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = ''Reimbursable'' THEN (OverheadDetailResults.MtdVarianceQ0 * -1) ELSE OverheadDetailResults.MtdVarianceQ0 END), 0) * -1,
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = ''Reimbursable'' THEN (OverheadDetailResults.MtdVarianceQ1 * -1) ELSE OverheadDetailResults.MtdVarianceQ1 END), 0) * -1,
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = ''Reimbursable'' THEN (OverheadDetailResults.MtdVarianceQ2 * -1) ELSE OverheadDetailResults.MtdVarianceQ2 END), 0) * -1,
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = ''Reimbursable'' THEN (OverheadDetailResults.MtdVarianceQ3 * -1) ELSE OverheadDetailResults.MtdVarianceQ3 END), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.YtdActual), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.YtdOriginalBudget), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.YtdReforecastQ1), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.YtdReforecastQ2), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.YtdReforecastQ3), 0) * -1,
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = ''Reimbursable'' THEN (OverheadDetailResults.YtdVarianceQ0 * -1) ELSE OverheadDetailResults.YtdVarianceQ0 END), 0) * -1,
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = ''Reimbursable'' THEN (OverheadDetailResults.YtdVarianceQ1 * -1) ELSE OverheadDetailResults.YtdVarianceQ1 END), 0) * -1,
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = ''Reimbursable'' THEN (OverheadDetailResults.YtdVarianceQ2 * -1) ELSE OverheadDetailResults.YtdVarianceQ2 END), 0) * -1,
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = ''Reimbursable'' THEN (OverheadDetailResults.YtdVarianceQ3 * -1) ELSE OverheadDetailResults.YtdVarianceQ3 END), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.AnnualOriginalBudget), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.AnnualReforecastQ1), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.AnnualReforecastQ2), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.AnnualReforecastQ3), 0) * -1
			FROM 
				dbo.GLCategorizationHierarchy
				
				INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
					GLCategorizationHierarchy.GLCategorizationHierarchyKey = GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey

				INNER JOIN
				(
					SELECT
						* 
					FROM 
						#DetailResult
					WHERE
						ExpenseType = ''Overhead''
				) OverheadDetailResults ON 
					GLCategorizationHierarchy.GLCategorizationHierarchyKey = OverheadDetailResults.GLCategorizationHierarchyKey
			WHERE
				GLCategorizationHierarchy.InflowOutflow	= ''Outflow'' AND
				GLCategorizationHierarchy.GLCategorizationName = @CategorizationName AND
				GLCategorizationHierarchy.GLFinancialCategoryName = ''Overhead'' AND
				GLCategorizationHierarchy.GLMajorCategoryName <> ''Corporate Tax'' 
			GROUP BY
				GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName

		END

	END

	--IMS #62074 Removed logic for Displayoverheadby .Removed due to IMS #62074 - REIMBERSEDOVERHEADEXPENSE header

	IF (@_DisplayOverheadBy = @UnAllocatedOverhead)
	BEGIN
		---------------------------------------------------------------------------------------------
		-- EXPENSES (240) -> Overhead Expenses (260) -> Equipment Rental / Office Rental (271)
		---------------------------------------------------------------------------------------------
		BEGIN
	
			INSERT INTO #Result
			(
				NumberOfSpacesToPad, 
				GroupDisplayCode, 
				GroupDisplayName, 
				DisplayOrderNumber,
				MtdActual,
				MtdOriginalBudget,
				MtdReforecastQ1,
				MtdReforecastQ2,
				MtdReforecastQ3,
				MtdVarianceQ0,
				MtdVarianceQ1,
				MtdVarianceQ2,
				MtdVarianceQ3,
				YtdActual,	
				YtdOriginalBudget,
				YtdReforecastQ1,
				YtdReforecastQ2,
				YtdReforecastQ3,
				YtdVarianceQ0,
				YtdVarianceQ1,
				YtdVarianceQ2,
				YtdVarianceQ3,
				AnnualOriginalBudget,
				AnnualReforecastQ1,
				AnnualReforecastQ2,
				AnnualReforecastQ3
			)
			SELECT 
				0 AS NumberOfSpacesToPad,
				''Reimbursed '' + GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayCode,
				''Reimbursed '' + GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayName,
				271 AS DisplayOrderNumber,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdActual), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdOriginalBudget), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdReforecastQ1), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdReforecastQ2), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdReforecastQ3), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdVarianceQ0), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdVarianceQ1), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdVarianceQ2), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdVarianceQ3), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdActual), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdOriginalBudget), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdReforecastQ1), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdReforecastQ2), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdReforecastQ3), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdVarianceQ0), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdVarianceQ1), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdVarianceQ2), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdVarianceQ3), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.AnnualOriginalBudget), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.AnnualReforecastQ1), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.AnnualReforecastQ2), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.AnnualReforecastQ3), 0) * -1
			FROM
				dbo.GLCategorizationHierarchy
				
				INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
					GLCategorizationHierarchy.GLCategorizationHierarchyKey = GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey

				LEFT OUTER JOIN
				(
					SELECT
						*
					FROM
						#DetailResult
					WHERE
						ExpenseType = ''Overhead'' AND
						ReimbursableName = ''Reimbursable''
				) OverheadReimbursableDetailResults ON
					GLCategorizationHierarchy.GLCategorizationHierarchyKey = OverheadReimbursableDetailResults.GLCategorizationHierarchyKey
			WHERE
				GLCategorizationHierarchy.InflowOutflow	= ''Outflow'' AND
				GLCategorizationHierarchy.GLCategorizationName = @CategorizationName AND
				GLCategorizationHierarchy.GLFinancialCategoryName IN (''Overhead'', ''Non-Payroll'', ''Payroll'') AND
				GLCategorizationHierarchy.GLMajorCategoryName <> ''Corporate Tax''
			GROUP BY
				GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName

		END

	END
	ELSE
	BEGIN
		---------------------------------------------------------------------------------------------
		-- EXPENSES (240) -> Overhead Expenses (260) -> Equipment Rental / Office Rental (271)
		---------------------------------------------------------------------------------------------
		BEGIN

			INSERT INTO #Result
			(
				NumberOfSpacesToPad, 
				GroupDisplayCode, 
				GroupDisplayName, 
				DisplayOrderNumber,
				MtdActual,
				MtdOriginalBudget,
				MtdReforecastQ1,
				MtdReforecastQ2,
				MtdReforecastQ3,
				MtdVarianceQ0,
				MtdVarianceQ1,
				MtdVarianceQ2,
				MtdVarianceQ3,
				YtdActual,	
				YtdOriginalBudget,
				YtdReforecastQ1,
				YtdReforecastQ2,
				YtdReforecastQ3,
				YtdVarianceQ0,
				YtdVarianceQ1,
				YtdVarianceQ2,
				YtdVarianceQ3,
				AnnualOriginalBudget,
				AnnualReforecastQ1,
				AnnualReforecastQ2,
				AnnualReforecastQ3
			)
			SELECT 
				0 AS NumberOfSpacesToPad,
				''Reimbursed '' + GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayCode,
				''Reimbursed '' + GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayName,
				271 AS DisplayOrderNumber,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdActual), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdOriginalBudget), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdReforecastQ1), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdReforecastQ2), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdReforecastQ3), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdVarianceQ0), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdVarianceQ1), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdVarianceQ2), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdVarianceQ3), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdActual), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdOriginalBudget), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdReforecastQ1), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdReforecastQ2), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdReforecastQ3), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdVarianceQ0), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdVarianceQ1), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdVarianceQ2), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdVarianceQ3), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.AnnualOriginalBudget), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.AnnualReforecastQ1), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.AnnualReforecastQ2), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.AnnualReforecastQ3), 0) * -1
			FROM 
				dbo.GLCategorizationHierarchy
				
				INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
					GLCategorizationHierarchy.GLCategorizationHierarchyKey = GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey

				INNER JOIN
				(
					SELECT 
						* 
					FROM 
						#DetailResult
					WHERE	
						ExpenseType = ''Overhead'' AND
						ReimbursableName	= ''Reimbursable''
				) OverheadReimbursableDetailResults ON
					GLCategorizationHierarchy.GLCategorizationHierarchyKey = OverheadReimbursableDetailResults.GLCategorizationHierarchyKey
			WHERE
				GLCategorizationHierarchy.InflowOutflow = ''Outflow'' AND
				GLCategorizationHierarchy.GLCategorizationName	= @CategorizationName AND
				GLCategorizationHierarchy.GLFinancialCategoryName = ''Overhead'' AND
				GLCategorizationHierarchy.GLMajorCategoryName <> ''Corporate Tax''
			GROUP BY
				GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName

		END

	END

	--IMS #62074 - removed logic for unallocated displayoverheadby

	---------------------------------------------------------------------------------------------
	-- EXPENSES (240) -> Total Net Overhead Expenses (273)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
			MtdActual,
			MtdOriginalBudget,
			MtdReforecastQ1,
			MtdReforecastQ2,
			MtdReforecastQ3,
			MtdVarianceQ0,
			MtdVarianceQ1,
			MtdVarianceQ2,
			MtdVarianceQ3,
			YtdActual,	
			YtdOriginalBudget,
			YtdReforecastQ1,
			YtdReforecastQ2,
			YtdReforecastQ3,
			YtdVarianceQ0,
			YtdVarianceQ1,
			YtdVarianceQ2,
			YtdVarianceQ3,
			AnnualOriginalBudget,
			AnnualReforecastQ1,
			AnnualReforecastQ2,
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			''Total Net Overhead Expense'' AS GroupDisplayCode,
			''Total Net Overhead Expense'' AS GroupDisplayName,
			273 AS DisplayOrderNumber,
			ISNULL(SUM(MtdActual), 0) * -1,
			ISNULL(SUM(MtdOriginalBudget), 0) * -1,
			ISNULL(SUM(MtdReforecastQ1), 0) * -1,
			ISNULL(SUM(MtdReforecastQ2), 0) * -1,
			ISNULL(SUM(MtdReforecastQ3), 0) * -1,
			ISNULL(SUM(MtdVarianceQ0), 0) * -1,
			ISNULL(SUM(MtdVarianceQ1), 0) * -1,
			ISNULL(SUM(MtdVarianceQ2), 0) * -1,
			ISNULL(SUM(MtdVarianceQ3), 0) * -1,
			ISNULL(SUM(YtdActual), 0) * -1,
			ISNULL(SUM(YtdOriginalBudget), 0) * -1,
			ISNULL(SUM(YtdReforecastQ1), 0) * -1,
			ISNULL(SUM(YtdReforecastQ2), 0) * -1,
			ISNULL(SUM(YtdReforecastQ3), 0) * -1,
			ISNULL(SUM(YtdVarianceQ0), 0) * -1,
			ISNULL(SUM(YtdVarianceQ1), 0) * -1,
			ISNULL(SUM(YtdVarianceQ2), 0) * -1,
			ISNULL(SUM(YtdVarianceQ3), 0) * -1,
			ISNULL(SUM(AnnualOriginalBudget), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ1), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ2), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ3), 0) * -1
		FROM
			#DetailResult
		WHERE
			InflowOutflow = ''Outflow'' AND
			ExpenseType = ''Overhead'' AND
			ReimbursableName = ''Not Reimbursable'' AND
			MajorExpenseCategoryName <> ''Corporate Tax''

	END

	---------------------------------------------------------------------------------------------
	-- EXPENSES (240) -> Overhead Reimbursement Rate (274)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
			MtdActual,
			MtdOriginalBudget,
			MtdReforecastQ1,
			MtdReforecastQ2,
			MtdReforecastQ3,
			MtdVarianceQ0,
			MtdVarianceQ1,
			MtdVarianceQ2,
			MtdVarianceQ3,
			YtdActual,	
			YtdOriginalBudget,
			YtdReforecastQ1,
			YtdReforecastQ2,
			YtdReforecastQ3,
			YtdVarianceQ0,
			YtdVarianceQ1,
			YtdVarianceQ2,
			YtdVarianceQ3,
			AnnualOriginalBudget,
			AnnualReforecastQ1,
			AnnualReforecastQ2,
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			''Overhead Reimbursement Rate'' AS GroupDisplayCode,
			''% Recovery'' AS GroupDisplayName,
			274 AS DisplayOrderNumber,
			ISNULL(Reimbursed.MtdActual / CASE WHEN Gross.MtdActual = 0 THEN NULL ELSE Gross.MtdActual END, 0),
			ISNULL(Reimbursed.MtdOriginalBudget / CASE WHEN Gross.MtdOriginalBudget = 0 THEN NULL ELSE Gross.MtdOriginalBudget END, 0),
			ISNULL(Reimbursed.MtdReforecastQ1 / CASE WHEN Gross.MtdReforecastQ1 = 0 THEN NULL ELSE Gross.MtdReforecastQ1 END, 0),
			ISNULL(Reimbursed.MtdReforecastQ2 / CASE WHEN Gross.MtdReforecastQ2 = 0 THEN NULL ELSE Gross.MtdReforecastQ2 END, 0),
			ISNULL(Reimbursed.MtdReforecastQ3 / CASE WHEN Gross.MtdReforecastQ3 = 0 THEN NULL ELSE Gross.MtdReforecastQ3 END, 0),
			0,
			0,
			0,
			0,
			ISNULL(Reimbursed.YtdActual / CASE WHEN Gross.YtdActual = 0 THEN NULL ELSE Gross.YtdActual END, 0),
			ISNULL(Reimbursed.YtdOriginalBudget / CASE WHEN Gross.YtdOriginalBudget = 0 THEN NULL ELSE Gross.YtdOriginalBudget END, 0),
			ISNULL(Reimbursed.YtdReforecastQ1 / CASE WHEN Gross.YtdReforecastQ1 = 0 THEN NULL ELSE Gross.YtdReforecastQ1 END, 0),
			ISNULL(Reimbursed.YtdReforecastQ2 / CASE WHEN Gross.YtdReforecastQ2 = 0 THEN NULL ELSE Gross.YtdReforecastQ2 END, 0),
			ISNULL(Reimbursed.YtdReforecastQ3 / CASE WHEN Gross.YtdReforecastQ3 = 0 THEN NULL ELSE Gross.YtdReforecastQ3 END, 0),
			0,
			0,
			0,
			0,
			ISNULL(Reimbursed.AnnualOriginalBudget / CASE WHEN Gross.AnnualOriginalBudget = 0 THEN NULL ELSE Gross.AnnualOriginalBudget END, 0),
			ISNULL(Reimbursed.AnnualReforecastQ1 / CASE WHEN Gross.AnnualReforecastQ1 = 0 THEN NULL ELSE Gross.AnnualReforecastQ1 END, 0),
			ISNULL(Reimbursed.AnnualReforecastQ2 / CASE WHEN Gross.AnnualReforecastQ2 = 0 THEN NULL ELSE Gross.AnnualReforecastQ2 END, 0),
			ISNULL(Reimbursed.AnnualReforecastQ3 / CASE WHEN Gross.AnnualReforecastQ3 = 0 THEN NULL ELSE Gross.AnnualReforecastQ3 END, 0)
		FROM
		(
			SELECT 
				ISNULL(SUM(MtdActual), 0) MtdActual,
				ISNULL(SUM(MtdOriginalBudget), 0) MtdOriginalBudget,
				ISNULL(SUM(MtdReforecastQ1), 0) MtdReforecastQ1,
				ISNULL(SUM(MtdReforecastQ2), 0) MtdReforecastQ2,
				ISNULL(SUM(MtdReforecastQ3), 0) MtdReforecastQ3,
				ISNULL(SUM(MtdVarianceQ0), 0) MtdVarianceQ0,
				ISNULL(SUM(MtdVarianceQ1), 0) MtdVarianceQ1,
				ISNULL(SUM(MtdVarianceQ2), 0) MtdVarianceQ2,
				ISNULL(SUM(MtdVarianceQ3), 0) MtdVarianceQ3,
				ISNULL(SUM(YtdActual), 0) YtdActual,
				ISNULL(SUM(YtdOriginalBudget), 0) YtdOriginalBudget,
				ISNULL(SUM(YtdReforecastQ1), 0) YtdReforecastQ1,
				ISNULL(SUM(YtdReforecastQ2), 0) YtdReforecastQ2,
				ISNULL(SUM(YtdReforecastQ3), 0) YtdReforecastQ3,
				ISNULL(SUM(YtdVarianceQ0), 0) YtdVarianceQ0,
				ISNULL(SUM(YtdVarianceQ1), 0) YtdVarianceQ1,
				ISNULL(SUM(YtdVarianceQ2), 0) YtdVarianceQ2,
				ISNULL(SUM(YtdVarianceQ3), 0) YtdVarianceQ3,
				ISNULL(SUM(AnnualOriginalBudget), 0) AnnualOriginalBudget,
				ISNULL(SUM(AnnualReforecastQ1), 0) AnnualReforecastQ1,
				ISNULL(SUM(AnnualReforecastQ2), 0) AnnualReforecastQ2,
				ISNULL(SUM(AnnualReforecastQ3), 0) AnnualReforecastQ3
			FROM
				#DetailResult
			WHERE	
				InflowOutflow = ''Outflow'' AND
				ExpenseType = ''Overhead'' AND
				ReimbursableName = ''Reimbursable'' AND
				MajorExpenseCategoryName <> ''Corporate Tax''
		) Reimbursed

		CROSS JOIN
		(
			SELECT
				ISNULL(SUM(MtdActual), 0) MtdActual,
				ISNULL(SUM(MtdOriginalBudget), 0) MtdOriginalBudget,
				ISNULL(SUM(MtdReforecastQ1), 0) MtdReforecastQ1,
				ISNULL(SUM(MtdReforecastQ2), 0) MtdReforecastQ2,
				ISNULL(SUM(MtdReforecastQ3), 0) MtdReforecastQ3,
				ISNULL(SUM(MtdVarianceQ0), 0) MtdVarianceQ0,
				ISNULL(SUM(MtdVarianceQ1), 0) MtdVarianceQ1,
				ISNULL(SUM(MtdVarianceQ2), 0) MtdVarianceQ2,
				ISNULL(SUM(MtdVarianceQ3), 0) MtdVarianceQ3,
				ISNULL(SUM(YtdActual), 0) YtdActual,
				ISNULL(SUM(YtdOriginalBudget), 0) YtdOriginalBudget,
				ISNULL(SUM(YtdReforecastQ1), 0) YtdReforecastQ1,
				ISNULL(SUM(YtdReforecastQ2), 0) YtdReforecastQ2,
				ISNULL(SUM(YtdReforecastQ3), 0) YtdReforecastQ3,
				ISNULL(SUM(YtdVarianceQ0), 0) YtdVarianceQ0,
				ISNULL(SUM(YtdVarianceQ1), 0) YtdVarianceQ1,
				ISNULL(SUM(YtdVarianceQ2), 0) YtdVarianceQ2,
				ISNULL(SUM(YtdVarianceQ3), 0) YtdVarianceQ3,
				ISNULL(SUM(AnnualOriginalBudget), 0) AnnualOriginalBudget,
				ISNULL(SUM(AnnualReforecastQ1), 0) AnnualReforecastQ1,
				ISNULL(SUM(AnnualReforecastQ2), 0) AnnualReforecastQ2,
				ISNULL(SUM(AnnualReforecastQ3), 0) AnnualReforecastQ3
			FROM
				#DetailResult
			WHERE
				InflowOutflow = ''Outflow'' AND
				ExpenseType = ''Overhead'' AND
				MajorExpenseCategoryName <> ''Corporate Tax''
		) Gross

		--Calculate the Overhead Reimbursement Rate Variance Columns
		UPDATE
			#Result
		SET
			MtdVarianceQ0 = (MtdActual - MtdOriginalBudget),
			MtdVarianceQ1 = (MtdActual - MtdReforecastQ1),
			MtdVarianceQ2 = (MtdActual - MtdReforecastQ2),
			MtdVarianceQ3 = (MtdActual - MtdReforecastQ3),
			YtdVarianceQ0 = (YtdActual - YtdOriginalBudget),
			YtdVarianceQ1 = (YtdActual - YtdReforecastQ1),
			YtdVarianceQ2 = (YtdActual - YtdReforecastQ2),
			YtdVarianceQ3 = (YtdActual - YtdReforecastQ3)
		WHERE
			GroupDisplayCode = ''Overhead Reimbursement Rate'' AND
			DisplayOrderNumber = 274

	END

	---------------------------------------------------------------------------------------------
	-- EXPENSES (240) -> Non-Payroll Expenses (290)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber
		)
		VALUES
			(0, ''BLANK'', '''', 280),
			(0, ''NONPAYROLLEXPENSE'', ''Non-Payroll Expenses'', 290)

	END

	---------------------------------------------------------------------------------------------
	-- 
	---------------------------------------------------------------------------------------------

	IF (@IncludeGrossNonPayrollExpenses = 1)
	BEGIN
		---------------------------------------------------------------------------------------------
		-- EXPENSES (240) -> Gross Non-Payroll Expenses (291)
		---------------------------------------------------------------------------------------------
		BEGIN

			INSERT INTO #Result
			(
				NumberOfSpacesToPad,
				GroupDisplayCode,
				GroupDisplayName,
				DisplayOrderNumber
			)
			VALUES
				(0, ''GROSSNONPAYROLLEXPENSE'', ''Gross Non-Payroll  Expenses'', 291)

		END

		---------------------------------------------------------------------------------------------
		-- EXPENSES (240) -> Gross Non-Payroll Expenses (291) - > Storage Costs (292)
		---------------------------------------------------------------------------------------------
		BEGIN

			INSERT INTO #Result
			(
				NumberOfSpacesToPad, 
				GroupDisplayCode, 
				GroupDisplayName, 
				DisplayOrderNumber,
				MtdActual,
				MtdOriginalBudget,
				MtdReforecastQ1,
				MtdReforecastQ2,
				MtdReforecastQ3,
				MtdVarianceQ0,
				MtdVarianceQ1,
				MtdVarianceQ2,
				MtdVarianceQ3,
				YtdActual,	
				YtdOriginalBudget,
				YtdReforecastQ1,
				YtdReforecastQ2,
				YtdReforecastQ3,
				YtdVarianceQ0,
				YtdVarianceQ1,
				YtdVarianceQ2,
				YtdVarianceQ3,
				AnnualOriginalBudget,
				AnnualReforecastQ1,
				AnnualReforecastQ2,
				AnnualReforecastQ3
			)
			SELECT 
				0 AS NumberOfSpacesToPad,
				CASE WHEN (GLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits'') THEN ''Salaries/Bonus/Taxes/Benefits'' ELSE GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName END as GroupDisplayCode,
				--gac.MajorCategoryName GroupDisplayCode,
				CASE WHEN (GLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits'') THEN ''Salaries/Bonus/Taxes/Benefits'' ELSE GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName END as MajorCategoryName,
				--gac.MajorCategoryName,
				292 AS DisplayOrderNumber,
				ISNULL(SUM(NonPayrollDetailResults.MtdActual), 0) * -1,
				ISNULL(SUM(NonPayrollDetailResults.MtdOriginalBudget), 0) * -1,
				ISNULL(SUM(NonPayrollDetailResults.MtdReforecastQ1), 0) * -1,
				ISNULL(SUM(NonPayrollDetailResults.MtdReforecastQ2), 0) * -1,
				ISNULL(SUM(NonPayrollDetailResults.MtdReforecastQ3), 0) * -1,

				--IMS #61973
				ISNULL(SUM(CASE WHEN NonPayrollDetailResults.InflowOutflow = ''Inflow'' THEN (NonPayrollDetailResults.MtdVarianceQ0 * -1) ELSE NonPayrollDetailResults.MtdVarianceQ0 END), 0) * -1,
				ISNULL(SUM(CASE WHEN NonPayrollDetailResults.InflowOutflow = ''Inflow'' THEN (NonPayrollDetailResults.MtdVarianceQ1 * -1) ELSE NonPayrollDetailResults.MtdVarianceQ1 END), 0) * -1,
				ISNULL(SUM(CASE WHEN NonPayrollDetailResults.InflowOutflow = ''Inflow'' THEN (NonPayrollDetailResults.MtdVarianceQ2 * -1) ELSE NonPayrollDetailResults.MtdVarianceQ2 END), 0) * -1,
				ISNULL(SUM(CASE WHEN NonPayrollDetailResults.InflowOutflow = ''Inflow'' THEN (NonPayrollDetailResults.MtdVarianceQ3 * -1) ELSE NonPayrollDetailResults.MtdVarianceQ3 END), 0) * -1,

				ISNULL(SUM(NonPayrollDetailResults.YtdActual), 0) * -1,			
				ISNULL(SUM(NonPayrollDetailResults.YtdOriginalBudget), 0) * -1,
				ISNULL(SUM(NonPayrollDetailResults.YtdReforecastQ1), 0) * -1,
				ISNULL(SUM(NonPayrollDetailResults.YtdReforecastQ2), 0) * -1,
				ISNULL(SUM(NonPayrollDetailResults.YtdReforecastQ3), 0) * -1,

				--IMS #61973
				ISNULL(SUM(CASE WHEN NonPayrollDetailResults.InflowOutflow = ''Inflow'' THEN (NonPayrollDetailResults.YtdVarianceQ0 * -1) ELSE NonPayrollDetailResults.YtdVarianceQ0 END), 0) * -1,
				ISNULL(SUM(CASE WHEN NonPayrollDetailResults.InflowOutflow = ''Inflow'' THEN (NonPayrollDetailResults.YtdVarianceQ1 * -1) ELSE NonPayrollDetailResults.YtdVarianceQ1 END), 0) * -1,
				ISNULL(SUM(CASE WHEN NonPayrollDetailResults.InflowOutflow = ''Inflow'' THEN (NonPayrollDetailResults.YtdVarianceQ2 * -1) ELSE NonPayrollDetailResults.YtdVarianceQ2 END), 0) * -1,
				ISNULL(SUM(CASE WHEN NonPayrollDetailResults.InflowOutflow = ''Inflow'' THEN (NonPayrollDetailResults.YtdVarianceQ3 * -1) ELSE NonPayrollDetailResults.YtdVarianceQ3 END), 0) * -1,		

				ISNULL(SUM(NonPayrollDetailResults.AnnualOriginalBudget), 0) * -1,
				ISNULL(SUM(NonPayrollDetailResults.AnnualReforecastQ1), 0) * -1,
				ISNULL(SUM(NonPayrollDetailResults.AnnualReforecastQ2), 0) * -1,
				ISNULL(SUM(NonPayrollDetailResults.AnnualReforecastQ3), 0) * -1
			FROM
				dbo.GLCategorizationHierarchy
				
				INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
					GLCategorizationHierarchy.GLCategorizationHierarchyKey = GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey

				LEFT OUTER JOIN
				(
					SELECT
						*
					FROM
						#DetailResult
					WHERE
						ExpenseType = ''Non-Payroll''
				) NonPayrollDetailResults ON
					GLCategorizationHierarchy.GLCategorizationHierarchyKey = NonPayrollDetailResults.GLCategorizationHierarchyKey
			WHERE			
				GLCategorizationHierarchy.GLCategorizationName = @CategorizationName AND
				GLCategorizationHierarchy.GLFinancialCategoryName = ''Non-Payroll''
			GROUP BY
				CASE
					WHEN
						GLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
					THEN
						''Salaries/Bonus/Taxes/Benefits''
					ELSE
						GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName
				END

		END

		---------------------------------------------------------------------------------------------
		-- EXPENSES (240) -> Gross Non-Payroll Expenses (291) - > Total Gross Non-Payroll Expenses (293)
		---------------------------------------------------------------------------------------------
		BEGIN

			INSERT INTO #Result
			(
				NumberOfSpacesToPad, 
				GroupDisplayCode, 
				GroupDisplayName, 
				DisplayOrderNumber,
				MtdActual,
				MtdOriginalBudget,
				MtdReforecastQ1,
				MtdReforecastQ2,
				MtdReforecastQ3,
				MtdVarianceQ0,
				MtdVarianceQ1,
				MtdVarianceQ2,
				MtdVarianceQ3,
				YtdActual,	
				YtdOriginalBudget,
				YtdReforecastQ1,
				YtdReforecastQ2,
				YtdReforecastQ3,
				YtdVarianceQ0,
				YtdVarianceQ1,
				YtdVarianceQ2,
				YtdVarianceQ3,
				AnnualOriginalBudget,
				AnnualReforecastQ1,
				AnnualReforecastQ2,
				AnnualReforecastQ3
			)
			SELECT 
				0 AS NumberOfSpacesToPad,
				''Total Gross Non-Payroll Expense'' AS GroupDisplayCode,
				''Total Gross Non-Payroll Expense'' AS GroupDisplayName,
				293 AS DisplayOrderNumber,
				ISNULL(SUM(MtdActual), 0) * -1,
				ISNULL(SUM(MtdOriginalBudget), 0) * -1,
				ISNULL(SUM(MtdReforecastQ1), 0) * -1,
				ISNULL(SUM(MtdReforecastQ2), 0) * -1,
				ISNULL(SUM(MtdReforecastQ3), 0) * -1,

				--IMS #61973
				ISNULL(SUM(CASE WHEN InflowOutflow = ''Inflow'' THEN (MtdVarianceQ0 * -1) ELSE MtdVarianceQ0 END), 0) * -1,
				ISNULL(SUM(CASE WHEN InflowOutflow = ''Inflow'' THEN (MtdVarianceQ1 * -1) ELSE MtdVarianceQ1 END), 0) * -1,
				ISNULL(SUM(CASE WHEN InflowOutflow = ''Inflow'' THEN (MtdVarianceQ2 * -1) ELSE MtdVarianceQ2 END), 0) * -1,
				ISNULL(SUM(CASE WHEN InflowOutflow = ''Inflow'' THEN (MtdVarianceQ3 * -1) ELSE MtdVarianceQ3 END), 0) * -1,

				ISNULL(SUM(YtdActual), 0) * -1,
				ISNULL(SUM(YtdOriginalBudget), 0) * -1,
				ISNULL(SUM(YtdReforecastQ1), 0) * -1,
				ISNULL(SUM(YtdReforecastQ2), 0) * -1,
				ISNULL(SUM(YtdReforecastQ3), 0) * -1,

				--IMS #61973
				ISNULL(SUM(CASE WHEN InflowOutflow = ''Inflow'' THEN (YtdVarianceQ0 * -1) ELSE YtdVarianceQ0 END), 0) * -1,
				ISNULL(SUM(CASE WHEN InflowOutflow = ''Inflow'' THEN (YtdVarianceQ1 * -1) ELSE YtdVarianceQ1 END), 0) * -1,
				ISNULL(SUM(CASE WHEN InflowOutflow = ''Inflow'' THEN (YtdVarianceQ2 * -1) ELSE YtdVarianceQ2 END), 0) * -1,
				ISNULL(SUM(CASE WHEN InflowOutflow = ''Inflow'' THEN (YtdVarianceQ3 * -1) ELSE YtdVarianceQ3 END), 0) * -1,	

				ISNULL(SUM(AnnualOriginalBudget), 0) * -1,
				ISNULL(SUM(AnnualReforecastQ1), 0) * -1,
				ISNULL(SUM(AnnualReforecastQ2), 0) * -1,
				ISNULL(SUM(AnnualReforecastQ3), 0) * -1
			FROM
				 #DetailResult
			WHERE			
				ExpenseType = ''Non-Payroll''
		END

	END

	---------------------------------------------------------------------------------------------
	-- EXPENSES (240) -> Net Non-Payroll Expenses (301)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber
		)
		VALUES
			(0, ''NETNONPAYROLLEXPENSE'', ''Net Non-Payroll  Expenses'', 301)

	END

	---------------------------------------------------------------------------------------------
	-- EXPENSES (240) -> Net Non-Payroll Expenses (301) - > Dues & Subscriptions (302)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
			MtdActual,
			MtdOriginalBudget,
			MtdReforecastQ1,
			MtdReforecastQ2,
			MtdReforecastQ3,
			MtdVarianceQ0,
			MtdVarianceQ1,
			MtdVarianceQ2,
			MtdVarianceQ3,
			YtdActual,	
			YtdOriginalBudget,
			YtdReforecastQ1,
			YtdReforecastQ2,
			YtdReforecastQ3,
			YtdVarianceQ0,
			YtdVarianceQ1,
			YtdVarianceQ2,
			YtdVarianceQ3,
			AnnualOriginalBudget,
			AnnualReforecastQ1,
			AnnualReforecastQ2,
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			CASE WHEN (GLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits'') THEN ''Salaries/Bonus/Taxes/Benefits'' ELSE GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName END as GroupDisplayCode,
			CASE WHEN (GLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits'') THEN ''Salaries/Bonus/Taxes/Benefits'' ELSE GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName END as MajorCategoryName,
			302 AS DisplayOrderNumber,
			ISNULL(SUM(NonPayrollNonReimbursableDetailResults.MtdActual), 0) * -1,
			ISNULL(SUM(NonPayrollNonReimbursableDetailResults.MtdOriginalBudget), 0) * -1,
			ISNULL(SUM(NonPayrollNonReimbursableDetailResults.MtdReforecastQ1), 0) * -1,
			ISNULL(SUM(NonPayrollNonReimbursableDetailResults.MtdReforecastQ2), 0) * -1,
			ISNULL(SUM(NonPayrollNonReimbursableDetailResults.MtdReforecastQ3), 0) * -1,

			--IMS #61973
			ISNULL(SUM(CASE WHEN NonPayrollNonReimbursableDetailResults.InflowOutflow = ''Inflow'' THEN (NonPayrollNonReimbursableDetailResults.MtdVarianceQ0 * -1) ELSE NonPayrollNonReimbursableDetailResults.MtdVarianceQ0 END), 0) * -1,
			ISNULL(SUM(CASE WHEN NonPayrollNonReimbursableDetailResults.InflowOutflow = ''Inflow'' THEN (NonPayrollNonReimbursableDetailResults.MtdVarianceQ1 * -1) ELSE NonPayrollNonReimbursableDetailResults.MtdVarianceQ1 END), 0) * -1,
			ISNULL(SUM(CASE WHEN NonPayrollNonReimbursableDetailResults.InflowOutflow = ''Inflow'' THEN (NonPayrollNonReimbursableDetailResults.MtdVarianceQ2 * -1) ELSE NonPayrollNonReimbursableDetailResults.MtdVarianceQ2 END), 0) * -1,
			ISNULL(SUM(CASE WHEN NonPayrollNonReimbursableDetailResults.InflowOutflow = ''Inflow'' THEN (NonPayrollNonReimbursableDetailResults.MtdVarianceQ3 * -1) ELSE NonPayrollNonReimbursableDetailResults.MtdVarianceQ3 END), 0) * -1,

			ISNULL(SUM(NonPayrollNonReimbursableDetailResults.YtdActual), 0) * -1,
			ISNULL(SUM(NonPayrollNonReimbursableDetailResults.YtdOriginalBudget), 0) * -1,
			ISNULL(SUM(NonPayrollNonReimbursableDetailResults.YtdReforecastQ1), 0) * -1,
			ISNULL(SUM(NonPayrollNonReimbursableDetailResults.YtdReforecastQ2), 0) * -1,
			ISNULL(SUM(NonPayrollNonReimbursableDetailResults.YtdReforecastQ3), 0) * -1,

			--IMS #61973
			ISNULL(SUM(CASE WHEN NonPayrollNonReimbursableDetailResults.InflowOutflow = ''Inflow'' THEN (NonPayrollNonReimbursableDetailResults.YtdVarianceQ0 * -1) ELSE NonPayrollNonReimbursableDetailResults.YtdVarianceQ0 END), 0) * -1,
			ISNULL(SUM(CASE WHEN NonPayrollNonReimbursableDetailResults.InflowOutflow = ''Inflow'' THEN (NonPayrollNonReimbursableDetailResults.YtdVarianceQ1 * -1) ELSE NonPayrollNonReimbursableDetailResults.YtdVarianceQ1 END), 0) * -1,
			ISNULL(SUM(CASE WHEN NonPayrollNonReimbursableDetailResults.InflowOutflow = ''Inflow'' THEN (NonPayrollNonReimbursableDetailResults.YtdVarianceQ2 * -1) ELSE NonPayrollNonReimbursableDetailResults.YtdVarianceQ2 END), 0) * -1,
			ISNULL(SUM(CASE WHEN NonPayrollNonReimbursableDetailResults.InflowOutflow = ''Inflow'' THEN (NonPayrollNonReimbursableDetailResults.YtdVarianceQ3 * -1) ELSE NonPayrollNonReimbursableDetailResults.YtdVarianceQ3 END), 0) * -1,

			ISNULL(SUM(NonPayrollNonReimbursableDetailResults.AnnualOriginalBudget), 0) * -1,
			ISNULL(SUM(NonPayrollNonReimbursableDetailResults.AnnualReforecastQ1), 0) * -1,
			ISNULL(SUM(NonPayrollNonReimbursableDetailResults.AnnualReforecastQ2), 0) * -1,
			ISNULL(SUM(NonPayrollNonReimbursableDetailResults.AnnualReforecastQ3), 0) * -1
		FROM
			dbo.GLCategorizationHierarchy
			
			INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey

			LEFT OUTER JOIN
			(
				SELECT 
					* 
				FROM 
					#DetailResult
				WHERE
					ExpenseType	= ''Non-Payroll'' AND
					ReimbursableName = ''Not Reimbursable''
			) NonPayrollNonReimbursableDetailResults ON 
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = NonPayrollNonReimbursableDetailResults.GLCategorizationHierarchyKey
		WHERE
			GLCategorizationHierarchy.GLCategorizationName	= @CategorizationName AND
			GLCategorizationHierarchy.GLFinancialCategoryName = ''Non-Payroll''
		GROUP BY
			CASE
				WHEN
					GLCategorizationHierarchy.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
				THEN
					''Salaries/Bonus/Taxes/Benefits''
				ELSE
					GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName
			END

	END

	---------------------------------------------------------------------------------------------
	-- EXPENSES (240) -> Total Net Non-Payroll Expenses (303)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode,
			GroupDisplayName, 
			DisplayOrderNumber,
			MtdActual,
			MtdOriginalBudget,
			MtdReforecastQ1,
			MtdReforecastQ2,
			MtdReforecastQ3,
			MtdVarianceQ0,
			MtdVarianceQ1,
			MtdVarianceQ2,
			MtdVarianceQ3,
			YtdActual,	
			YtdOriginalBudget,
			YtdReforecastQ1,
			YtdReforecastQ2,
			YtdReforecastQ3,
			YtdVarianceQ0,
			YtdVarianceQ1,
			YtdVarianceQ2,
			YtdVarianceQ3,
			AnnualOriginalBudget,
			AnnualReforecastQ1,
			AnnualReforecastQ2,
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			''Total Net Non-Payroll Expense'' AS GroupDisplayCode,
			''Total Net Non-Payroll Expense'' AS GroupDisplayName,
			303 AS DisplayOrderNumber,
			ISNULL(SUM(MtdActual), 0) * -1,
			ISNULL(SUM(MtdOriginalBudget), 0) * -1,
			ISNULL(SUM(MtdReforecastQ1), 0) * -1,
			ISNULL(SUM(MtdReforecastQ2), 0) * -1,
			ISNULL(SUM(MtdReforecastQ3), 0) * -1,

			--IMS #61973
			ISNULL(SUM(CASE WHEN InflowOutflow = ''Inflow'' THEN (MtdVarianceQ0 * -1) ELSE MtdVarianceQ0 END), 0) * -1,
			ISNULL(SUM(CASE WHEN InflowOutflow = ''Inflow'' THEN (MtdVarianceQ1 * -1) ELSE MtdVarianceQ1 END), 0) * -1,
			ISNULL(SUM(CASE WHEN InflowOutflow = ''Inflow'' THEN (MtdVarianceQ2 * -1) ELSE MtdVarianceQ2 END), 0) * -1,
			ISNULL(SUM(CASE WHEN InflowOutflow = ''Inflow'' THEN (MtdVarianceQ3 * -1) ELSE MtdVarianceQ3 END), 0) * -1,

			ISNULL(SUM(YtdActual), 0) * -1,
			ISNULL(SUM(YtdOriginalBudget), 0) * -1,
			ISNULL(SUM(YtdReforecastQ1), 0) * -1,
			ISNULL(SUM(YtdReforecastQ2), 0) * -1,
			ISNULL(SUM(YtdReforecastQ3), 0) * -1,

			--IMS #61973
			ISNULL(SUM(CASE WHEN InflowOutflow = ''Inflow'' THEN (YtdVarianceQ0 * -1) ELSE YtdVarianceQ0 END), 0) * -1,
			ISNULL(SUM(CASE WHEN InflowOutflow = ''Inflow'' THEN (YtdVarianceQ1 * -1) ELSE YtdVarianceQ1 END), 0) * -1,
			ISNULL(SUM(CASE WHEN InflowOutflow = ''Inflow'' THEN (YtdVarianceQ2 * -1) ELSE YtdVarianceQ2 END), 0) * -1,
			ISNULL(SUM(CASE WHEN InflowOutflow = ''Inflow'' THEN (YtdVarianceQ3 * -1) ELSE YtdVarianceQ3 END), 0) * -1,

			ISNULL(SUM(AnnualOriginalBudget), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ1), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ2), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ3), 0) * -1
		FROM
			 #DetailResult
		WHERE
			ExpenseType = ''Non-Payroll'' AND
			ReimbursableName = ''Not Reimbursable''

	END

	---------------------------------------------------------------------------------------------
	-- BLANK-ROW
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad,
			GroupDisplayCode,
			GroupDisplayName,
			DisplayOrderNumber)
		VALUES
			(0, ''BLANK'', '''', 310)

	END

	---------------------------------------------------------------------------------------------
	-- TOTAL NET EXPENSES (320)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
			MtdActual,
			MtdOriginalBudget,
			MtdReforecastQ1,
			MtdReforecastQ2,
			MtdReforecastQ3,
			MtdVarianceQ0,
			MtdVarianceQ1,
			MtdVarianceQ2,
			MtdVarianceQ3,
			YtdActual,	
			YtdOriginalBudget,
			YtdReforecastQ1,
			YtdReforecastQ2,
			YtdReforecastQ3,
			YtdVarianceQ0,
			YtdVarianceQ1,
			YtdVarianceQ2,
			YtdVarianceQ3,
			AnnualOriginalBudget,
			AnnualReforecastQ1,
			AnnualReforecastQ2,
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			''TOTALNETEXPENSE'' AS GroupDisplayCode,
			''Total Net Expenses'' AS GroupDisplayName,
			320 AS DisplayOrderNumber,

			-- MTD Actuals/Q0/Q1/Q2/Q3
			ISNULL(SUM(MtdActual), 0) * -1,
			ISNULL(SUM(MtdOriginalBudget), 0) * -1,
			ISNULL(SUM(MtdReforecastQ1), 0) * -1,
			ISNULL(SUM(MtdReforecastQ2), 0) * -1,
			ISNULL(SUM(MtdReforecastQ3), 0) * -1,

			--IMS #61973
			-- MTD Variance Q0/Q1/Q2/Q3
			ISNULL(SUM(CASE WHEN InflowOutflow = ''Inflow'' THEN (MtdVarianceQ0 * -1) ELSE MtdVarianceQ0 END), 0) * -1,
			ISNULL(SUM(CASE WHEN InflowOutflow = ''Inflow'' THEN (MtdVarianceQ1 * -1) ELSE MtdVarianceQ1 END), 0) * -1,
			ISNULL(SUM(CASE WHEN InflowOutflow = ''Inflow'' THEN (MtdVarianceQ2 * -1) ELSE MtdVarianceQ2 END), 0) * -1,
			ISNULL(SUM(CASE WHEN InflowOutflow = ''Inflow'' THEN (MtdVarianceQ3 * -1) ELSE MtdVarianceQ3 END), 0) * -1,

			-- YTD Actual/Q0/Q1/Q2/Q3
			ISNULL(SUM(YtdActual), 0) * -1,
			ISNULL(SUM(YtdOriginalBudget), 0) * -1,
			ISNULL(SUM(YtdReforecastQ1), 0) * -1,
			ISNULL(SUM(YtdReforecastQ2), 0) * -1,
			ISNULL(SUM(YtdReforecastQ3), 0) * -1,

			--IMS #61973
			-- YTD Variance Q0/Q1/Q2/Q3
			ISNULL(SUM(CASE WHEN InflowOutflow = ''Inflow'' THEN (YtdVarianceQ0 * -1) ELSE YtdVarianceQ0 END), 0) * -1,
			ISNULL(SUM(CASE WHEN InflowOutflow = ''Inflow'' THEN (YtdVarianceQ1 * -1) ELSE YtdVarianceQ1 END), 0) * -1,
			ISNULL(SUM(CASE WHEN InflowOutflow = ''Inflow'' THEN (YtdVarianceQ2 * -1) ELSE YtdVarianceQ2 END), 0) * -1,
			ISNULL(SUM(CASE WHEN InflowOutflow = ''Inflow'' THEN (YtdVarianceQ3 * -1) ELSE YtdVarianceQ3 END), 0) * -1,

			-- Annual Q0/Q1/Q2/Q3
			ISNULL(SUM(AnnualOriginalBudget), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ1), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ2), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ3), 0) * -1
		FROM
			 #DetailResult
		WHERE
			ReimbursableName = ''Not Reimbursable'' AND -- We only want NET amounts only
			ExpenseType <> ''Other Expenses'' AND
			InflowOutflow = ''Outflow'' -- To prevent unknown and income from being added.

	END

	---------------------------------------------------------------------------------------------
	-- BLANK-ROW
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad,
			GroupDisplayCode,
			GroupDisplayName,
			DisplayOrderNumber
		)
		VALUES
			(0, ''BLANK'', '''', 321)

	END

	---------------------------------------------------------------------------------------------
	-- INCOME/(LOSS) Before Taxes & Depreciation (322)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
			MtdActual,
			MtdOriginalBudget,
			MtdReforecastQ1,
			MtdReforecastQ2,
			MtdReforecastQ3,
			MtdVarianceQ0,
			MtdVarianceQ1,
			MtdVarianceQ2,
			MtdVarianceQ3,
			YtdActual,	
			YtdOriginalBudget,
			YtdReforecastQ1,
			YtdReforecastQ2,
			YtdReforecastQ3,
			YtdVarianceQ0,
			YtdVarianceQ1,
			YtdVarianceQ2,
			YtdVarianceQ3,
			AnnualOriginalBudget,
			AnnualReforecastQ1,
			AnnualReforecastQ2,
			AnnualReforecastQ3
		)
		SELECT 
			0 AS NumberOfSpacesToPad,
			''INCOMELOSSBEFOREDEPRECIATIONANDTAX'' AS GroupDisplayCode,
			''Income / (Loss) Before Taxes and Depreciation'' AS GroupDisplayName,
			322 AS DisplayOrderNumber,
			(INC.MtdActual + EP.MtdActual) AS MtdActual,
			(INC.MtdOriginalBudget + EP.MtdOriginalBudget) AS MtdOriginalBudget,
			(INC.MtdReforecastQ1 + EP.MtdReforecastQ1) AS MtdReforecastQ1,
			(INC.MtdReforecastQ2 + EP.MtdReforecastQ2) AS MtdReforecastQ2,
			(INC.MtdReforecastQ3 + EP.MtdReforecastQ3) AS MtdReforecastQ3,
			(INC.MtdVarianceQ0 - EP.MtdVarianceQ0) AS MtdVarianceQ0,
			(INC.MtdVarianceQ1 - EP.MtdVarianceQ1) AS MtdVarianceQ1,
			(INC.MtdVarianceQ2 - EP.MtdVarianceQ2) AS MtdVarianceQ2,
			(INC.MtdVarianceQ3 - EP.MtdVarianceQ3) AS MtdVarianceQ3,
			(INC.YtdActual + EP.YtdActual) AS YtdActual,
			(INC.YtdOriginalBudget + EP.YtdOriginalBudget) AS YtdOriginalBudget,
			(INC.YtdReforecastQ1 + EP.YtdReforecastQ1) AS YtdReforecastQ1,
			(INC.YtdReforecastQ2 + EP.YtdReforecastQ2) AS YtdReforecastQ2,
			(INC.YtdReforecastQ3 + EP.YtdReforecastQ3) AS YtdReforecastQ3,
			(INC.YtdVarianceQ0 - EP.YtdVarianceQ0) AS YtdVarianceQ0,
			(INC.YtdVarianceQ1 - EP.YtdVarianceQ1) AS YtdVarianceQ1,
			(INC.YtdVarianceQ2 - EP.YtdVarianceQ2) AS YtdVarianceQ2,
			(INC.YtdVarianceQ3 - EP.YtdVarianceQ3) AS YtdVarianceQ3,
			(INC.AnnualOriginalBudget + EP.AnnualOriginalBudget) AS AnnualOriginalBudget,
			(INC.AnnualReforecastQ1 + EP.AnnualReforecastQ1) AS AnnualReforecastQ1,
			(INC.AnnualReforecastQ2 + EP.AnnualReforecastQ2) AS AnnualReforecastQ2,
			(INC.AnnualReforecastQ3 + EP.AnnualReforecastQ3) AS AnnualReforecastQ3
		FROM
		(
			SELECT 
				ISNULL(SUM(MtdActual), 0) AS MtdActual,
				ISNULL(SUM(MtdOriginalBudget), 0) AS MtdOriginalBudget,
				ISNULL(SUM(MtdReforecastQ1), 0) AS MtdReforecastQ1,
				ISNULL(SUM(MtdReforecastQ2), 0) AS MtdReforecastQ2,
				ISNULL(SUM(MtdReforecastQ3), 0) AS MtdReforecastQ3,
				ISNULL(SUM(MtdVarianceQ0), 0) AS MtdVarianceQ0,
				ISNULL(SUM(MtdVarianceQ1), 0) AS MtdVarianceQ1,
				ISNULL(SUM(MtdVarianceQ2), 0) AS MtdVarianceQ2,
				ISNULL(SUM(MtdVarianceQ3), 0) AS MtdVarianceQ3,
				ISNULL(SUM(YtdActual), 0) AS YtdActual,
				ISNULL(SUM(YtdOriginalBudget), 0) AS YtdOriginalBudget,
				ISNULL(SUM(YtdReforecastQ1), 0) AS YtdReforecastQ1,
				ISNULL(SUM(YtdReforecastQ2), 0) AS YtdReforecastQ2,
				ISNULL(SUM(YtdReforecastQ3), 0) AS YtdReforecastQ3,
				ISNULL(SUM(YtdVarianceQ0), 0) AS YtdVarianceQ0,
				ISNULL(SUM(YtdVarianceQ1), 0) AS YtdVarianceQ1,
				ISNULL(SUM(YtdVarianceQ2), 0) AS YtdVarianceQ2,
				ISNULL(SUM(YtdVarianceQ3), 0) AS YtdVarianceQ3,
				ISNULL(SUM(AnnualOriginalBudget), 0) AS AnnualOriginalBudget,
				ISNULL(SUM(AnnualReforecastQ1), 0) AS AnnualReforecastQ1,
				ISNULL(SUM(AnnualReforecastQ2), 0) AS AnnualReforecastQ2,
				ISNULL(SUM(AnnualReforecastQ3), 0) AS AnnualReforecastQ3
			FROM
				#DetailResult
			WHERE
				InflowOutflow = ''Inflow''
		) INC

		CROSS JOIN 
		(
			SELECT 
				ISNULL(SUM(MtdActual), 0) AS MtdActual,
				ISNULL(SUM(MtdOriginalBudget), 0) AS MtdOriginalBudget,
				ISNULL(SUM(MtdReforecastQ1), 0) AS MtdReforecastQ1,
				ISNULL(SUM(MtdReforecastQ2), 0) AS MtdReforecastQ2,
				ISNULL(SUM(MtdReforecastQ3), 0) AS MtdReforecastQ3,
				ISNULL(SUM(MtdVarianceQ0), 0) AS MtdVarianceQ0,
				ISNULL(SUM(MtdVarianceQ1), 0) AS MtdVarianceQ1,
				ISNULL(SUM(MtdVarianceQ2), 0) AS MtdVarianceQ2,
				ISNULL(SUM(MtdVarianceQ3), 0) AS MtdVarianceQ3,
				ISNULL(SUM(YtdActual), 0) AS YtdActual,
				ISNULL(SUM(YtdOriginalBudget), 0) AS YtdOriginalBudget,
				ISNULL(SUM(YtdReforecastQ1), 0) AS YtdReforecastQ1,
				ISNULL(SUM(YtdReforecastQ2), 0) AS YtdReforecastQ2,
				ISNULL(SUM(YtdReforecastQ3), 0) AS YtdReforecastQ3,
				ISNULL(SUM(YtdVarianceQ0), 0) AS YtdVarianceQ0,
				ISNULL(SUM(YtdVarianceQ1), 0) AS YtdVarianceQ1,
				ISNULL(SUM(YtdVarianceQ2), 0) AS YtdVarianceQ2,
				ISNULL(SUM(YtdVarianceQ3), 0) AS YtdVarianceQ3,
				ISNULL(SUM(AnnualOriginalBudget), 0) AS AnnualOriginalBudget,
				ISNULL(SUM(AnnualReforecastQ1), 0) AS AnnualReforecastQ1,
				ISNULL(SUM(AnnualReforecastQ2), 0) AS AnnualReforecastQ2,
				ISNULL(SUM(AnnualReforecastQ3), 0) AS AnnualReforecastQ3
			FROM
				#DetailResult
			WHERE 
				InflowOutflow = ''Outflow'' AND
				ReimbursableName = ''Not Reimbursable'' AND
				ExpenseType <> ''Other Expenses''
		) EP

	END

	---------------------------------------------------------------------------------------------
	-- BLANK-ROW
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad,
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber
		)
		VALUES
			(0, ''BLANK'', '''', 323)

	END

	---------------------------------------------------------------------------------------------
	-- INCOME/(LOSS) Before Taxes & Depreciation (322) -> Depreciation Expenses (324)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
			MtdActual,
			MtdOriginalBudget,
			MtdReforecastQ1,
			MtdReforecastQ2,
			MtdReforecastQ3,
			MtdVarianceQ0,
			MtdVarianceQ1,
			MtdVarianceQ2,
			MtdVarianceQ3,
			YtdActual,	
			YtdOriginalBudget,
			YtdReforecastQ1,
			YtdReforecastQ2,
			YtdReforecastQ3,
			YtdVarianceQ0,
			YtdVarianceQ1,
			YtdVarianceQ2,
			YtdVarianceQ3,
			AnnualOriginalBudget,
			AnnualReforecastQ1,
			AnnualReforecastQ2,
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayCode,
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayName,
			324 AS DisplayOrderNumber,
			ISNULL(SUM(NotReimbursableDetailResults.MtdActual), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdOriginalBudget), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdReforecastQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdReforecastQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdReforecastQ3), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdVarianceQ0), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdVarianceQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdVarianceQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdVarianceQ3), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdActual), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdOriginalBudget), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdReforecastQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdReforecastQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdReforecastQ3), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdVarianceQ0), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdVarianceQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdVarianceQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdVarianceQ3), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.AnnualOriginalBudget), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.AnnualReforecastQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.AnnualReforecastQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.AnnualReforecastQ3), 0) * -1
		FROM
			dbo.GLCategorizationHierarchy
			
			INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey

			LEFT OUTER JOIN
			(
				SELECT
					*
				FROM
					#DetailResult
				WHERE -- IMS 69602 - Information not being displaying in the Profitability report
					ExpenseType = @OtherExpensesExpenseType AND
					ReimbursableName = ''Not Reimbursable''
			) NotReimbursableDetailResults ON
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = NotReimbursableDetailResults.GLCategorizationHierarchyKey
		WHERE
			GLCategorizationHierarchy.GLCategorizationName = @CategorizationName AND
			GLCategorizationHierarchy.GLMinorCategoryName = ''Depreciation Expense''
			/* IMS 69602 - Information not being displaying in the Profitability report
				Remove Non Payroll from the filter it is now actually Other Expenses, so actually just exclude the financial category
				-- GLCategorizationHierarchy.GLFinancialCategoryName = ''Non-Payroll'' AND */
		GROUP BY
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName

	END

	---------------------------------------------------------------------------------------------
	-- INCOME/(LOSS) Before Taxes (325)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
			MtdActual,
			MtdOriginalBudget,
			MtdReforecastQ1,
			MtdReforecastQ2,
			MtdReforecastQ3,
			MtdVarianceQ0,
			MtdVarianceQ1,
			MtdVarianceQ2,
			MtdVarianceQ3,
			YtdActual,	
			YtdOriginalBudget,
			YtdReforecastQ1,
			YtdReforecastQ2,
			YtdReforecastQ3,
			YtdVarianceQ0,
			YtdVarianceQ1,
			YtdVarianceQ2,
			YtdVarianceQ3,
			AnnualOriginalBudget,
			AnnualReforecastQ1,
			AnnualReforecastQ2,
			AnnualReforecastQ3
		)
		SELECT 
			0 AS NumberOfSpacesToPad,
			''INCOMELOSSBEFORETAX'' AS GroupDisplayCode,
			''Income / (Loss) Before Taxes'' AS GroupDisplayName,
			325 AS DisplayOrderNumber,
			(INC.MtdActual + EP.MtdActual) AS MtdActual,
			(INC.MtdOriginalBudget + EP.MtdOriginalBudget) AS MtdOriginalBudget,
			(INC.MtdReforecastQ1 + EP.MtdReforecastQ1) AS MtdReforecastQ1,
			(INC.MtdReforecastQ2 + EP.MtdReforecastQ2) AS MtdReforecastQ2,
			(INC.MtdReforecastQ3 + EP.MtdReforecastQ3) AS MtdReforecastQ3,
			(INC.MtdVarianceQ0 - EP.MtdVarianceQ0) AS MtdVarianceQ0,
			(INC.MtdVarianceQ1 - EP.MtdVarianceQ1) AS MtdVarianceQ1,
			(INC.MtdVarianceQ2 - EP.MtdVarianceQ2) AS MtdVarianceQ2,
			(INC.MtdVarianceQ3 - EP.MtdVarianceQ3) AS MtdVarianceQ3,
			(INC.YtdActual + EP.YtdActual) AS YtdActual,
			(INC.YtdOriginalBudget + EP.YtdOriginalBudget) AS YtdOriginalBudget,
			(INC.YtdReforecastQ1 + EP.YtdReforecastQ1) AS YtdReforecastQ1,
			(INC.YtdReforecastQ2 + EP.YtdReforecastQ2) AS YtdReforecastQ2,
			(INC.YtdReforecastQ3 + EP.YtdReforecastQ3) AS YtdReforecastQ3,
			(INC.YtdVarianceQ0 - EP.YtdVarianceQ0) AS YtdVarianceQ0,
			(INC.YtdVarianceQ1 - EP.YtdVarianceQ1) AS YtdVarianceQ1,
			(INC.YtdVarianceQ2 - EP.YtdVarianceQ2) AS YtdVarianceQ2,
			(INC.YtdVarianceQ3 - EP.YtdVarianceQ3) AS YtdVarianceQ3,
			(INC.AnnualOriginalBudget + EP.AnnualOriginalBudget) AS AnnualOriginalBudget,
			(INC.AnnualReforecastQ1 + EP.AnnualReforecastQ1) AS AnnualReforecastQ1,
			(INC.AnnualReforecastQ2 + EP.AnnualReforecastQ2) AS AnnualReforecastQ2,
			(INC.AnnualReforecastQ3 + EP.AnnualReforecastQ3) AS AnnualReforecastQ3
		FROM
		(
			SELECT
				ISNULL(SUM(MtdActual), 0) AS MtdActual,
				ISNULL(SUM(MtdOriginalBudget), 0) AS MtdOriginalBudget,
				ISNULL(SUM(MtdReforecastQ1), 0) AS MtdReforecastQ1,
				ISNULL(SUM(MtdReforecastQ2), 0) AS MtdReforecastQ2,
				ISNULL(SUM(MtdReforecastQ3), 0) AS MtdReforecastQ3,
				ISNULL(SUM(MtdVarianceQ0), 0) AS MtdVarianceQ0,
				ISNULL(SUM(MtdVarianceQ1), 0) AS MtdVarianceQ1,
				ISNULL(SUM(MtdVarianceQ2), 0) AS MtdVarianceQ2,
				ISNULL(SUM(MtdVarianceQ3), 0) AS MtdVarianceQ3,
				ISNULL(SUM(YtdActual), 0) AS YtdActual,
				ISNULL(SUM(YtdOriginalBudget), 0) AS YtdOriginalBudget,
				ISNULL(SUM(YtdReforecastQ1), 0) AS YtdReforecastQ1,
				ISNULL(SUM(YtdReforecastQ2), 0) AS YtdReforecastQ2,
				ISNULL(SUM(YtdReforecastQ3), 0) AS YtdReforecastQ3,
				ISNULL(SUM(YtdVarianceQ0), 0) AS YtdVarianceQ0,
				ISNULL(SUM(YtdVarianceQ1), 0) AS YtdVarianceQ1,
				ISNULL(SUM(YtdVarianceQ2), 0) AS YtdVarianceQ2,
				ISNULL(SUM(YtdVarianceQ3), 0) AS YtdVarianceQ3,
				ISNULL(SUM(AnnualOriginalBudget), 0) AS AnnualOriginalBudget,
				ISNULL(SUM(AnnualReforecastQ1), 0) AS AnnualReforecastQ1,
				ISNULL(SUM(AnnualReforecastQ2), 0) AS AnnualReforecastQ2,
				ISNULL(SUM(AnnualReforecastQ3), 0) AS AnnualReforecastQ3
		FROM
			 #DetailResult
		WHERE
			InflowOutflow = ''Inflow''
		) INC

		CROSS JOIN
		(
			SELECT
				ISNULL(SUM(MtdActual), 0) AS MtdActual,
				ISNULL(SUM(MtdOriginalBudget), 0) AS MtdOriginalBudget,
				ISNULL(SUM(MtdReforecastQ1), 0) AS MtdReforecastQ1,
				ISNULL(SUM(MtdReforecastQ2), 0) AS MtdReforecastQ2,
				ISNULL(SUM(MtdReforecastQ3), 0) AS MtdReforecastQ3,
				ISNULL(SUM(MtdVarianceQ0), 0) AS MtdVarianceQ0,
				ISNULL(SUM(MtdVarianceQ1), 0) AS MtdVarianceQ1,
				ISNULL(SUM(MtdVarianceQ2), 0) AS MtdVarianceQ2,
				ISNULL(SUM(MtdVarianceQ3), 0) AS MtdVarianceQ3,
				ISNULL(SUM(YtdActual), 0) AS YtdActual,
				ISNULL(SUM(YtdOriginalBudget), 0) AS YtdOriginalBudget,
				ISNULL(SUM(YtdReforecastQ1), 0) AS YtdReforecastQ1,
				ISNULL(SUM(YtdReforecastQ2), 0) AS YtdReforecastQ2,
				ISNULL(SUM(YtdReforecastQ3), 0) AS YtdReforecastQ3,
				ISNULL(SUM(YtdVarianceQ0), 0) AS YtdVarianceQ0,
				ISNULL(SUM(YtdVarianceQ1), 0) AS YtdVarianceQ1,
				ISNULL(SUM(YtdVarianceQ2), 0) AS YtdVarianceQ2,
				ISNULL(SUM(YtdVarianceQ3), 0) AS YtdVarianceQ3,
				ISNULL(SUM(AnnualOriginalBudget), 0) AS AnnualOriginalBudget,
				ISNULL(SUM(AnnualReforecastQ1), 0) AS AnnualReforecastQ1,
				ISNULL(SUM(AnnualReforecastQ2), 0) AS AnnualReforecastQ2,
				ISNULL(SUM(AnnualReforecastQ3), 0) AS AnnualReforecastQ3
			FROM
				 #DetailResult
			WHERE
				InflowOutflow = ''Outflow'' AND
				ReimbursableName = ''Not Reimbursable'' AND
				MajorExpenseCategoryName NOT IN (''Corporate Tax'', ''Unrealized (Gain)/Loss'')
		) EP

	END

	---------------------------------------------------------------------------------------------
	-- BLANK-ROW
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad,
			GroupDisplayCode,
			GroupDisplayName,
			DisplayOrderNumber
		)
		VALUES
			(0, ''BLANK'', '''', 326)

	END

	---------------------------------------------------------------------------------------------
	-- INCOME/(LOSS) Before Taxes (325) -> Unrealized (Gain)/Loss (327)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
			MtdActual,
			MtdOriginalBudget,
			MtdReforecastQ1,
			MtdReforecastQ2,
			MtdReforecastQ3,
			MtdVarianceQ0,
			MtdVarianceQ1,
			MtdVarianceQ2,
			MtdVarianceQ3,
			YtdActual,	
			YtdOriginalBudget,
			YtdReforecastQ1,
			YtdReforecastQ2,
			YtdReforecastQ3,
			YtdVarianceQ0,
			YtdVarianceQ1,
			YtdVarianceQ2,
			YtdVarianceQ3,
			AnnualOriginalBudget,
			AnnualReforecastQ1,
			AnnualReforecastQ2,
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayCode,
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayName,
			327 AS DisplayOrderNumber,
			ISNULL(SUM(NotReimbursableDetailResults.MtdActual), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdOriginalBudget), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdReforecastQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdReforecastQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdReforecastQ3), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdVarianceQ0), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdVarianceQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdVarianceQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdVarianceQ3), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdActual), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdOriginalBudget), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdReforecastQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdReforecastQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdReforecastQ3), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdVarianceQ0), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdVarianceQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdVarianceQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdVarianceQ3), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.AnnualOriginalBudget), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.AnnualReforecastQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.AnnualReforecastQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.AnnualReforecastQ3), 0) * -1
		FROM
			dbo.GLCategorizationHierarchy
			
			INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey

			LEFT OUTER JOIN
			(
				SELECT
					*
				FROM
					#DetailResult
				WHERE
					ExpenseType = @OtherExpensesExpenseType AND
					ReimbursableName = ''Not Reimbursable''
			) NotReimbursableDetailResults ON
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = NotReimbursableDetailResults.GLCategorizationHierarchyKey
		WHERE
			GLCategorizationHierarchy.InflowOutflow	= ''Outflow'' AND
			GLCategorizationHierarchy.GLCategorizationName = @CategorizationName AND
			GLCategorizationHierarchy.GLMinorCategoryName = ''Unrealized (Gain)/Loss''
			/* IMS 69602 - Information not being displaying in the Profitability report
				Remove Non Payroll from the filter it is now actually Other Expenses, so actually just exclude the financial category
				-- GLCategorizationHierarchy.GLFinancialCategoryName = ''Non-Payroll'' AND */
		GROUP BY
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName

	END

	---------------------------------------------------------------------------------------------
	-- INCOME/(LOSS) Before Taxes (325) -> Realized (Gain)/Loss (327)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
			MtdActual,
			MtdOriginalBudget,
			MtdReforecastQ1,
			MtdReforecastQ2,
			MtdReforecastQ3,
			MtdVarianceQ0,
			MtdVarianceQ1,
			MtdVarianceQ2,
			MtdVarianceQ3,
			YtdActual,	
			YtdOriginalBudget,
			YtdReforecastQ1,
			YtdReforecastQ2,
			YtdReforecastQ3,
			YtdVarianceQ0,
			YtdVarianceQ1,
			YtdVarianceQ2,
			YtdVarianceQ3,
			AnnualOriginalBudget,
			AnnualReforecastQ1,
			AnnualReforecastQ2,
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayCode,
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayName,
			327 AS DisplayOrderNumber,
			ISNULL(SUM(NonReimbursableDetailResults.MtdActual), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.MtdOriginalBudget), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.MtdReforecastQ1), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.MtdReforecastQ2), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.MtdReforecastQ3), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.MtdVarianceQ0), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.MtdVarianceQ1), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.MtdVarianceQ2), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.MtdVarianceQ3), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.YtdActual), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.YtdOriginalBudget), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.YtdReforecastQ1), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.YtdReforecastQ2), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.YtdReforecastQ3), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.YtdVarianceQ0), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.YtdVarianceQ1), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.YtdVarianceQ2), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.YtdVarianceQ3), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.AnnualOriginalBudget), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.AnnualReforecastQ1), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.AnnualReforecastQ2), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.AnnualReforecastQ3), 0) * -1
		FROM
			dbo.GLCategorizationHierarchy
			
			INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey

			LEFT OUTER JOIN
			(
				SELECT
					* 
				FROM
					#DetailResult
				WHERE
					ExpenseType = @OtherExpensesExpenseType AND
					ReimbursableName = ''Not Reimbursable''
			) NonReimbursableDetailResults ON
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = NonReimbursableDetailResults.GLCategorizationHierarchyKey
		WHERE
			GLCategorizationHierarchy.InflowOutflow	= ''Outflow'' AND
			GLCategorizationHierarchy.GLCategorizationName = @CategorizationName AND
			GLCategorizationHierarchy.GLMinorCategoryName = ''Realized (Gain)/Loss''
			/* IMS 69602 - Information not being displaying in the Profitability report
				Remove Non Payroll from the filter it is now actually Other Expenses, so actually just exclude the financial category
				-- GLCategorizationHierarchy.GLFinancialCategoryName = ''Non-Payroll'' AND */
		GROUP BY
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName

	END

	---------------------------------------------------------------------------------------------
	-- INCOME/(LOSS) Before Taxes (325) -> Corporate Tax (327)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
			MtdActual,
			MtdOriginalBudget,
			MtdReforecastQ1,
			MtdReforecastQ2,
			MtdReforecastQ3,
			MtdVarianceQ0,
			MtdVarianceQ1,
			MtdVarianceQ2,
			MtdVarianceQ3,
			YtdActual,	
			YtdOriginalBudget,
			YtdReforecastQ1,
			YtdReforecastQ2,
			YtdReforecastQ3,
			YtdVarianceQ0,
			YtdVarianceQ1,
			YtdVarianceQ2,
			YtdVarianceQ3,
			AnnualOriginalBudget,
			AnnualReforecastQ1,
			AnnualReforecastQ2,
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayCode,
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayName,
			327 AS DisplayOrderNumber,
			ISNULL(SUM(NotReimbursableDetailResults.MtdActual), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdOriginalBudget), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdReforecastQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdReforecastQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdReforecastQ3), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdVarianceQ0), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdVarianceQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdVarianceQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdVarianceQ3), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdActual), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdOriginalBudget), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdReforecastQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdReforecastQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdReforecastQ3), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdVarianceQ0), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdVarianceQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdVarianceQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdVarianceQ3), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.AnnualOriginalBudget), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.AnnualReforecastQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.AnnualReforecastQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.AnnualReforecastQ3), 0) * -1
		FROM
			dbo.GLCategorizationHierarchy
			
			INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey

			LEFT OUTER JOIN
			(
				SELECT
					*
				FROM
					#DetailResult
				WHERE
					ExpenseType = @OtherExpensesExpenseType AND
					ReimbursableName = ''Not Reimbursable''
			) NotReimbursableDetailResults ON
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = NotReimbursableDetailResults.GLCategorizationHierarchyKey
		WHERE
			GLCategorizationHierarchy.InflowOutflow	= ''Outflow'' AND
			GLCategorizationHierarchy.GLCategorizationName = @CategorizationName AND
			GLCategorizationHierarchy.GLMinorCategoryName = ''Corporate Tax''
			/* IMS 69602 - Information not being displaying in the Profitability report
				Remove Non Payroll from the filter it is now actually Other Expenses, so actually just exclude the financial category
				-- GLCategorizationHierarchy.GLFinancialCategoryName = ''Non-Payroll'' AND */
		GROUP BY
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName

	END

	---------------------------------------------------------------------------------------------
	-- NET INCOME/(LOSS) (330)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
			MtdActual,
			MtdOriginalBudget,
			MtdReforecastQ1,
			MtdReforecastQ2,
			MtdReforecastQ3,
			MtdVarianceQ0,
			MtdVarianceQ1,
			MtdVarianceQ2,
			MtdVarianceQ3,
			YtdActual,	
			YtdOriginalBudget,
			YtdReforecastQ1,
			YtdReforecastQ2,
			YtdReforecastQ3,
			YtdVarianceQ0,
			YtdVarianceQ1,
			YtdVarianceQ2,
			YtdVarianceQ3,
			AnnualOriginalBudget,
			AnnualReforecastQ1,
			AnnualReforecastQ2,
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			''NETINCOMELOSS'' AS GroupDisplayCode,
			''NET INCOME / (LOSS)'' AS GroupDisplayName,
			330 AS DisplayOrderNumber,
			(INC.MtdActual + EP.MtdActual) AS MtdActual,
			(INC.MtdOriginalBudget + EP.MtdOriginalBudget) AS MtdOriginalBudget,
			(INC.MtdReforecastQ1 + EP.MtdReforecastQ1) AS MtdReforecastQ1,
			(INC.MtdReforecastQ2 + EP.MtdReforecastQ2) AS MtdReforecastQ2,
			(INC.MtdReforecastQ3 + EP.MtdReforecastQ3) AS MtdReforecastQ3,
			(INC.MtdVarianceQ0 - EP.MtdVarianceQ0) AS MtdVarianceQ0,
			(INC.MtdVarianceQ1 - EP.MtdVarianceQ1) AS MtdVarianceQ1,
			(INC.MtdVarianceQ2 - EP.MtdVarianceQ2) AS MtdVarianceQ2,
			(INC.MtdVarianceQ3 - EP.MtdVarianceQ3) AS MtdVarianceQ3,
			(INC.YtdActual + EP.YtdActual) AS YtdActual,
			(INC.YtdOriginalBudget + EP.YtdOriginalBudget) AS YtdOriginalBudget,
			(INC.YtdReforecastQ1 + EP.YtdReforecastQ1) AS YtdReforecastQ1,
			(INC.YtdReforecastQ2 + EP.YtdReforecastQ2) AS YtdReforecastQ2,
			(INC.YtdReforecastQ3 + EP.YtdReforecastQ3) AS YtdReforecastQ3,
			(INC.YtdVarianceQ0 - EP.YtdVarianceQ0) AS YtdVarianceQ0,
			(INC.YtdVarianceQ1 - EP.YtdVarianceQ1) AS YtdVarianceQ1,
			(INC.YtdVarianceQ2 - EP.YtdVarianceQ2) AS YtdVarianceQ2,
			(INC.YtdVarianceQ3 - EP.YtdVarianceQ3) AS YtdVarianceQ3,
			(INC.AnnualOriginalBudget + EP.AnnualOriginalBudget) AS AnnualOriginalBudget,
			(INC.AnnualReforecastQ1 + EP.AnnualReforecastQ1) AS AnnualReforecastQ1,
			(INC.AnnualReforecastQ2 + EP.AnnualReforecastQ2) AS AnnualReforecastQ2,
			(INC.AnnualReforecastQ3 + EP.AnnualReforecastQ3) AS AnnualReforecastQ3
		FROM
		(
			SELECT
				ISNULL(SUM(MtdActual), 0) AS MtdActual,
				ISNULL(SUM(MtdOriginalBudget), 0) AS MtdOriginalBudget,
				ISNULL(SUM(MtdReforecastQ1), 0) AS MtdReforecastQ1,
				ISNULL(SUM(MtdReforecastQ2), 0) AS MtdReforecastQ2,
				ISNULL(SUM(MtdReforecastQ3), 0) AS MtdReforecastQ3,
				ISNULL(SUM(MtdVarianceQ0), 0) AS MtdVarianceQ0,
				ISNULL(SUM(MtdVarianceQ1), 0) AS MtdVarianceQ1,
				ISNULL(SUM(MtdVarianceQ2), 0) AS MtdVarianceQ2,
				ISNULL(SUM(MtdVarianceQ3), 0) AS MtdVarianceQ3,
				ISNULL(SUM(YtdActual), 0) AS YtdActual,
				ISNULL(SUM(YtdOriginalBudget), 0) AS YtdOriginalBudget,
				ISNULL(SUM(YtdReforecastQ1), 0) AS YtdReforecastQ1,
				ISNULL(SUM(YtdReforecastQ2), 0) AS YtdReforecastQ2,
				ISNULL(SUM(YtdReforecastQ3), 0) AS YtdReforecastQ3,
				ISNULL(SUM(YtdVarianceQ0), 0) AS YtdVarianceQ0,
				ISNULL(SUM(YtdVarianceQ1), 0) AS YtdVarianceQ1,
				ISNULL(SUM(YtdVarianceQ2), 0) AS YtdVarianceQ2,
				ISNULL(SUM(YtdVarianceQ3), 0) AS YtdVarianceQ3,
				ISNULL(SUM(AnnualOriginalBudget), 0) AS AnnualOriginalBudget,
				ISNULL(SUM(AnnualReforecastQ1), 0) AS AnnualReforecastQ1,
				ISNULL(SUM(AnnualReforecastQ2), 0) AS AnnualReforecastQ2,
				ISNULL(SUM(AnnualReforecastQ3), 0) AS AnnualReforecastQ3
			FROM
				 #DetailResult
			WHERE
				InflowOutflow = ''Inflow''
		) INC

		CROSS JOIN
		(
			SELECT
				ISNULL(SUM(MtdActual), 0) AS MtdActual,
				ISNULL(SUM(MtdOriginalBudget), 0) AS MtdOriginalBudget,
				ISNULL(SUM(MtdReforecastQ1), 0) AS MtdReforecastQ1,
				ISNULL(SUM(MtdReforecastQ2), 0) AS MtdReforecastQ2,
				ISNULL(SUM(MtdReforecastQ3), 0) AS MtdReforecastQ3,
				ISNULL(SUM(MtdVarianceQ0), 0) AS MtdVarianceQ0,
				ISNULL(SUM(MtdVarianceQ1), 0) AS MtdVarianceQ1,
				ISNULL(SUM(MtdVarianceQ2), 0) AS MtdVarianceQ2,
				ISNULL(SUM(MtdVarianceQ3), 0) AS MtdVarianceQ3,
				ISNULL(SUM(YtdActual), 0) AS YtdActual,
				ISNULL(SUM(YtdOriginalBudget), 0) AS YtdOriginalBudget,
				ISNULL(SUM(YtdReforecastQ1), 0) AS YtdReforecastQ1,
				ISNULL(SUM(YtdReforecastQ2), 0) AS YtdReforecastQ2,
				ISNULL(SUM(YtdReforecastQ3), 0) AS YtdReforecastQ3,
				ISNULL(SUM(YtdVarianceQ0), 0) AS YtdVarianceQ0,
				ISNULL(SUM(YtdVarianceQ1), 0) AS YtdVarianceQ1,
				ISNULL(SUM(YtdVarianceQ2), 0) AS YtdVarianceQ2,
				ISNULL(SUM(YtdVarianceQ3), 0) AS YtdVarianceQ3,
				ISNULL(SUM(AnnualOriginalBudget), 0) AS AnnualOriginalBudget,
				ISNULL(SUM(AnnualReforecastQ1), 0) AS AnnualReforecastQ1,
				ISNULL(SUM(AnnualReforecastQ2), 0) AS AnnualReforecastQ2,
				ISNULL(SUM(AnnualReforecastQ3), 0) AS AnnualReforecastQ3
			FROM
				#DetailResult
			WHERE
				InflowOutflow = ''Outflow'' AND
				ReimbursableName = ''Not Reimbursable''
		) EP

	END

	---------------------------------------------------------------------------------------------
	-- NET INCOME/(LOSS) (330) -> Profit Margin (Profit / Total Revenue) (331)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
			MtdActual,
			MtdOriginalBudget,
			MtdReforecastQ1,
			MtdReforecastQ2,
			MtdReforecastQ3,
			MtdVarianceQ0,
			MtdVarianceQ1,
			MtdVarianceQ2,
			MtdVarianceQ3,
			YtdActual,	
			YtdOriginalBudget,
			YtdReforecastQ1,
			YtdReforecastQ2,
			YtdReforecastQ3,
			YtdVarianceQ0,
			YtdVarianceQ1,
			YtdVarianceQ2,
			YtdVarianceQ3,
			AnnualOriginalBudget,
			AnnualReforecastQ1,
			AnnualReforecastQ2,
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			''PROFITMARGIN'' AS GroupDisplayCode,
			''Profit Margin (Net Income/(Loss)/ Total Revenue)'' AS GroupDisplayName,
			331 AS DisplayOrderNumber,
			ISNULL(((INC.MtdActual + EP.MtdActual) / CASE WHEN INC.MtdActual <> 0 THEN INC.MtdActual ELSE NULL END), 0) AS MtdActual,
			ISNULL(((INC.MtdOriginalBudget + EP.MtdOriginalBudget) / CASE WHEN INC.MtdOriginalBudget <> 0 THEN INC.MtdOriginalBudget ELSE NULL END), 0) AS MtdOriginalBudget,
			ISNULL(((INC.MtdReforecastQ1 + EP.MtdReforecastQ1) / CASE WHEN INC.MtdReforecastQ1 <> 0 THEN INC.MtdReforecastQ1 ELSE NULL END), 0) AS MtdReforecastQ1,
			ISNULL(((INC.MtdReforecastQ2 + EP.MtdReforecastQ2) / CASE WHEN INC.MtdReforecastQ2 <> 0 THEN INC.MtdReforecastQ2 ELSE NULL END), 0) AS MtdReforecastQ2,
			ISNULL(((INC.MtdReforecastQ3 + EP.MtdReforecastQ3) / CASE WHEN INC.MtdReforecastQ3 <> 0 THEN INC.MtdReforecastQ3 ELSE NULL END), 0) AS MtdReforecastQ3,
			0 AS MtdVarianceQ0, --Done Below for it use these results to sub calculate
			0 AS MtdVarianceQ1, --Done Below for it use these results to sub calculate
			0 AS MtdVarianceQ2, --Done Below for it use these results to sub calculate
			0 AS MtdVarianceQ3, --Done Below for it use these results to sub calculate
			ISNULL(((INC.YtdActual + EP.YtdActual) / CASE WHEN INC.YtdActual <> 0 THEN INC.YtdActual ELSE NULL END), 0) AS YtdActual,
			ISNULL(((INC.YtdOriginalBudget + EP.YtdOriginalBudget) / CASE WHEN INC.YtdOriginalBudget <> 0 THEN INC.YtdOriginalBudget ELSE NULL END), 0) AS YtdOriginalBudget,
			ISNULL(((INC.YtdReforecastQ1 + EP.YtdReforecastQ1) / CASE WHEN INC.YtdReforecastQ1 <> 0 THEN INC.YtdReforecastQ1 ELSE NULL END), 0) AS YtdReforecastQ1,
			ISNULL(((INC.YtdReforecastQ2 + EP.YtdReforecastQ2) / CASE WHEN INC.YtdReforecastQ2 <> 0 THEN INC.YtdReforecastQ2 ELSE NULL END), 0) AS YtdReforecastQ2,
			ISNULL(((INC.YtdReforecastQ3 + EP.YtdReforecastQ3) / CASE WHEN INC.YtdReforecastQ3 <> 0 THEN INC.YtdReforecastQ3 ELSE NULL END), 0) AS YtdReforecastQ3,
			0 AS YtdVarianceQ0, --Done Below for it use these results to sub calculate
			0 AS YtdVarianceQ1, --Done Below for it use these results to sub calculate
			0 AS YtdVarianceQ2, --Done Below for it use these results to sub calculate
			0 AS YtdVarianceQ3, --Done Below for it use these results to sub calculate
			ISNULL(((INC.AnnualOriginalBudget + EP.AnnualOriginalBudget) / CASE WHEN INC.AnnualOriginalBudget <> 0 THEN INC.AnnualOriginalBudget ELSE NULL END), 0) AS AnnualOriginalBudget,
			ISNULL(((INC.AnnualReforecastQ1 + EP.AnnualReforecastQ1) / CASE WHEN INC.AnnualReforecastQ1 <> 0 THEN INC.AnnualReforecastQ1 ELSE NULL END), 0) AS AnnualReforecastQ1,
			ISNULL(((INC.AnnualReforecastQ2 + EP.AnnualReforecastQ2) / CASE WHEN INC.AnnualReforecastQ2 <> 0 THEN INC.AnnualReforecastQ2 ELSE NULL END), 0) AS AnnualReforecastQ2,
			ISNULL(((INC.AnnualReforecastQ3 + EP.AnnualReforecastQ3) / CASE WHEN INC.AnnualReforecastQ3 <> 0 THEN INC.AnnualReforecastQ3 ELSE NULL END), 0) AS AnnualReforecastQ3
		FROM
		(
			SELECT
				ISNULL(SUM(MtdActual), 0) AS MtdActual,
				ISNULL(SUM(MtdOriginalBudget), 0) AS MtdOriginalBudget,
				ISNULL(SUM(MtdReforecastQ1), 0) AS MtdReforecastQ1,
				ISNULL(SUM(MtdReforecastQ2), 0) AS MtdReforecastQ2,
				ISNULL(SUM(MtdReforecastQ3), 0) AS MtdReforecastQ3,
				ISNULL(SUM(MtdVarianceQ0), 0) AS MtdVarianceQ0,
				ISNULL(SUM(MtdVarianceQ1), 0) AS MtdVarianceQ1,
				ISNULL(SUM(MtdVarianceQ2), 0) AS MtdVarianceQ2,
				ISNULL(SUM(MtdVarianceQ3), 0) AS MtdVarianceQ3,
				ISNULL(SUM(YtdActual), 0) AS YtdActual,
				ISNULL(SUM(YtdOriginalBudget), 0) AS YtdOriginalBudget,
				ISNULL(SUM(YtdReforecastQ1), 0) AS YtdReforecastQ1,
				ISNULL(SUM(YtdReforecastQ2), 0) AS YtdReforecastQ2,
				ISNULL(SUM(YtdReforecastQ3), 0) AS YtdReforecastQ3,
				ISNULL(SUM(YtdVarianceQ0), 0) AS YtdVarianceQ0,
				ISNULL(SUM(YtdVarianceQ1), 0) AS YtdVarianceQ1,
				ISNULL(SUM(YtdVarianceQ2), 0) AS YtdVarianceQ2,
				ISNULL(SUM(YtdVarianceQ3), 0) AS YtdVarianceQ3,
				ISNULL(SUM(AnnualOriginalBudget), 0) AS AnnualOriginalBudget,
				ISNULL(SUM(AnnualReforecastQ1), 0) AS AnnualReforecastQ1,
				ISNULL(SUM(AnnualReforecastQ2), 0) AS AnnualReforecastQ2,
				ISNULL(SUM(AnnualReforecastQ3), 0) AS AnnualReforecastQ3
		FROM
			 #DetailResult
		WHERE
			InflowOutflow = ''Inflow''
		) INC

		CROSS JOIN
		(
			SELECT
				ISNULL(SUM(MtdActual), 0) AS MtdActual,
				ISNULL(SUM(MtdOriginalBudget), 0) AS MtdOriginalBudget,
				ISNULL(SUM(MtdReforecastQ1), 0) AS MtdReforecastQ1,
				ISNULL(SUM(MtdReforecastQ2), 0) AS MtdReforecastQ2,
				ISNULL(SUM(MtdReforecastQ3), 0) AS MtdReforecastQ3,
				ISNULL(SUM(MtdVarianceQ0), 0) AS MtdVarianceQ0,
				ISNULL(SUM(MtdVarianceQ1), 0) AS MtdVarianceQ1,
				ISNULL(SUM(MtdVarianceQ2), 0) AS MtdVarianceQ2,
				ISNULL(SUM(MtdVarianceQ3), 0) AS MtdVarianceQ3,
				ISNULL(SUM(YtdActual), 0) AS YtdActual,
				ISNULL(SUM(YtdOriginalBudget), 0) AS YtdOriginalBudget,
				ISNULL(SUM(YtdReforecastQ1), 0) AS YtdReforecastQ1,
				ISNULL(SUM(YtdReforecastQ2), 0) AS YtdReforecastQ2,
				ISNULL(SUM(YtdReforecastQ3), 0) AS YtdReforecastQ3,
				ISNULL(SUM(YtdVarianceQ0), 0) AS YtdVarianceQ0,
				ISNULL(SUM(YtdVarianceQ1), 0) AS YtdVarianceQ1,
				ISNULL(SUM(YtdVarianceQ2), 0) AS YtdVarianceQ2,
				ISNULL(SUM(YtdVarianceQ3), 0) AS YtdVarianceQ3,
				ISNULL(SUM(AnnualOriginalBudget), 0) AS AnnualOriginalBudget,
				ISNULL(SUM(AnnualReforecastQ1), 0) AS AnnualReforecastQ1,
				ISNULL(SUM(AnnualReforecastQ2), 0) AS AnnualReforecastQ2,
				ISNULL(SUM(AnnualReforecastQ3), 0) AS AnnualReforecastQ3
			FROM
				#DetailResult
			WHERE
				InflowOutflow = ''Outflow'' AND
				ReimbursableName = ''Not Reimbursable''
		) EP

		--Calculate the Profit Variance Columns
		UPDATE
			#Result
		SET		
			MtdVarianceQ0 = MtdActual - MtdOriginalBudget,
			MtdVarianceQ1 = MtdActual - MtdReforecastQ1,
			MtdVarianceQ2 = MtdActual - MtdReforecastQ2,
			MtdVarianceQ3 = MtdActual - MtdReforecastQ3,
			YtdVarianceQ0 = YtdActual - YtdOriginalBudget,
			YtdVarianceQ1 = YtdActual - YtdReforecastQ1,
			YtdVarianceQ2 = YtdActual - YtdReforecastQ2,
			YtdVarianceQ3 = YtdActual - YtdReforecastQ3
		WHERE
			GroupDisplayCode = ''PROFITMARGIN'' AND
			DisplayOrderNumber = 331

	END

END
		
	--------------------------------------------------------------------------------------------------------------------------------------	
	--Final Common block to set the Variance% columns, and cater for UNKNOWNS
	--------------------------------------------------------------------------------------------------------------------------------------	
	BEGIN

		UPDATE
			#Result
		SET
			MtdVariancePercentageQ0 = ISNULL(MtdVarianceQ0 / CASE WHEN MtdOriginalBudget <> 0 THEN MtdOriginalBudget ELSE NULL END, 0) ,
			MtdVariancePercentageQ1 = ISNULL(MtdVarianceQ1 / CASE WHEN MtdReforecastQ1 <> 0 THEN MtdReforecastQ1 ELSE NULL END, 0) ,
			MtdVariancePercentageQ2 = ISNULL(MtdVarianceQ2 / CASE WHEN MtdReforecastQ2 <> 0 THEN MtdReforecastQ2 ELSE NULL END, 0) ,
			MtdVariancePercentageQ3 = ISNULL(MtdVarianceQ3 / CASE WHEN MtdReforecastQ3 <> 0 THEN MtdReforecastQ3 ELSE NULL END, 0) ,

			YtdVariancePercentageQ0 = ISNULL(YtdVarianceQ0 / CASE WHEN YtdOriginalBudget <> 0 THEN YtdOriginalBudget ELSE NULL END, 0) ,
			YtdVariancePercentageQ1 = ISNULL(YtdVarianceQ1 / CASE WHEN YtdReforecastQ1 <> 0 THEN YtdReforecastQ1 ELSE NULL END, 0) ,
			YtdVariancePercentageQ2 = ISNULL(YtdVarianceQ2 / CASE WHEN YtdReforecastQ2 <> 0 THEN YtdReforecastQ2 ELSE NULL END, 0) ,
			YtdVariancePercentageQ3 = ISNULL(YtdVarianceQ3 / CASE WHEN YtdReforecastQ3 <> 0 THEN YtdReforecastQ3 ELSE NULL END, 0) 
		WHERE
			GroupDisplayCode NOT IN(''Payroll Reimbursement Rate'',''Overhead Reimbursement Rate'',''PROFITMARGIN'')

		--UNKNOWN MajorCategory

		---------------------------------------------------------------------------------------------
		-- BLANK-ROW
		---------------------------------------------------------------------------------------------
		BEGIN

			INSERT INTO #Result
			(
				NumberOfSpacesToPad,
				GroupDisplayCode, 
				GroupDisplayName, 
				DisplayOrderNumber
			)
			VALUES
				(0, ''BLANK'', '''', 340)

		END

		---------------------------------------------------------------------------------------------
		-- UNKNOWN (341)
		---------------------------------------------------------------------------------------------
		BEGIN

			INSERT INTO #Result
			(
				NumberOfSpacesToPad, 
				GroupDisplayCode, 
				GroupDisplayName, 
				DisplayOrderNumber,
				MtdActual,
				MtdOriginalBudget,
				MtdReforecastQ1,
				MtdReforecastQ2,
				MtdReforecastQ3,
				MtdVarianceQ0,
				MtdVarianceQ1,
				MtdVarianceQ2,
				MtdVarianceQ3,
				YtdActual,	
				YtdOriginalBudget,
				YtdReforecastQ1,
				YtdReforecastQ2,
				YtdReforecastQ3,
				YtdVarianceQ0,
				YtdVarianceQ1,
				YtdVarianceQ2,
				YtdVarianceQ3,
				AnnualOriginalBudget,
				AnnualReforecastQ1,
				AnnualReforecastQ2,
				AnnualReforecastQ3
			)
			SELECT
				0 AS NumberOfSpacesToPad,
				''UNKNOWN'' AS GroupDisplayCode,
				''Unknown'' AS GroupDisplayName,
				341 AS DisplayOrderNumber,
				ISNULL(SUM(MtdActual), 0),
				ISNULL(SUM(MtdOriginalBudget), 0),
				ISNULL(SUM(MtdReforecastQ1), 0),
				ISNULL(SUM(MtdReforecastQ2), 0),
				ISNULL(SUM(MtdReforecastQ3), 0),
				ISNULL(SUM(MtdVarianceQ0), 0),
				ISNULL(SUM(MtdVarianceQ1), 0),
				ISNULL(SUM(MtdVarianceQ2), 0),
				ISNULL(SUM(MtdVarianceQ3), 0),
				ISNULL(SUM(YtdActual), 0),
				ISNULL(SUM(YtdOriginalBudget), 0),
				ISNULL(SUM(YtdReforecastQ1), 0),
				ISNULL(SUM(YtdReforecastQ2), 0),
				ISNULL(SUM(YtdReforecastQ3), 0),
				ISNULL(SUM(YtdVarianceQ0), 0),
				ISNULL(SUM(YtdVarianceQ1), 0),
				ISNULL(SUM(YtdVarianceQ2), 0),
				ISNULL(SUM(YtdVarianceQ3), 0),
				ISNULL(SUM(AnnualOriginalBudget), 0),
				ISNULL(SUM(AnnualReforecastQ1), 0),
				ISNULL(SUM(AnnualReforecastQ2), 0),
				ISNULL(SUM(AnnualReforecastQ3), 0)
			FROM
				#DetailResult
			WHERE
				MajorExpenseCategoryName = ''UNKNOWN''
			HAVING
				(
					ISNULL(SUM(MtdActual), 0) <> 0 OR
					ISNULL(SUM(MtdOriginalBudget), 0) <> 0 OR
					ISNULL(SUM(MtdReforecastQ1), 0) <> 0 OR
					ISNULL(SUM(MtdReforecastQ2), 0) <> 0 OR
					ISNULL(SUM(MtdReforecastQ3), 0) <> 0 OR
					ISNULL(SUM(MtdVarianceQ0), 0) <> 0 OR
					ISNULL(SUM(MtdVarianceQ1), 0) <> 0 OR
					ISNULL(SUM(MtdVarianceQ2), 0) <> 0 OR
					ISNULL(SUM(MtdVarianceQ3), 0) <> 0 OR
					ISNULL(SUM(YtdActual), 0) <> 0 OR
					ISNULL(SUM(YtdOriginalBudget), 0) <> 0 OR
					ISNULL(SUM(YtdReforecastQ1), 0) <> 0 OR
					ISNULL(SUM(YtdReforecastQ2), 0) <> 0 OR
					ISNULL(SUM(YtdReforecastQ3), 0) <> 0 OR
					ISNULL(SUM(YtdVarianceQ0), 0) <> 0 OR
					ISNULL(SUM(YtdVarianceQ1), 0) <> 0 OR
					ISNULL(SUM(YtdVarianceQ2), 0) <> 0 OR
					ISNULL(SUM(YtdVarianceQ3), 0) <> 0 OR
					ISNULL(SUM(AnnualOriginalBudget), 0) <> 0 OR
					ISNULL(SUM(AnnualReforecastQ1), 0) <> 0 OR
					ISNULL(SUM(AnnualReforecastQ2), 0) <> 0 OR
					ISNULL(SUM(AnnualReforecastQ3), 0) <> 0
				)

		END

	END

/* ====================================================================================================================================	
	Final Result
   ================================================================================================================================= */	
BEGIN

	SELECT
		NumberOfSpacesToPad,
		GroupDisplayCode,
		REPLICATE('' '', NumberOfSpacesToPad) + GroupDisplayName AS GroupDisplayName,
		DisplayOrderNumber,
		MtdActual,
		MtdOriginalBudget,
		CASE WHEN @ReforecastQuarterName = ''Q0'' THEN 0 ELSE MtdReforecastQ1 END AS MtdReforecastQ1,
		CASE WHEN @ReforecastQuarterName = ''Q0'' THEN 0 ELSE MtdReforecastQ2 END AS MtdReforecastQ2,
		CASE WHEN @ReforecastQuarterName = ''Q0'' THEN 0 ELSE MtdReforecastQ3 END AS MtdReforecastQ3,

		MtdVarianceQ0,
		MtdVarianceQ1,
		MtdVarianceQ2,
		MtdVarianceQ3,

		MtdVariancePercentageQ0,
		MtdVariancePercentageQ1,
		MtdVariancePercentageQ2,
		MtdVariancePercentageQ3,

		YtdActual,
		YtdOriginalBudget,
		CASE WHEN @ReforecastQuarterName = ''Q0'' THEN 0 ELSE YtdReforecastQ1 END AS YtdReforecastQ1,
		CASE WHEN @ReforecastQuarterName = ''Q0'' THEN 0 ELSE YtdReforecastQ2 END AS YtdReforecastQ2,
		CASE WHEN @ReforecastQuarterName = ''Q0'' THEN 0 ELSE YtdReforecastQ3 END AS YtdReforecastQ3,

		YtdVarianceQ0,
		YtdVarianceQ1,
		YtdVarianceQ2,
		YtdVarianceQ3,

		YtdVariancePercentageQ0,
		YtdVariancePercentageQ1,
		YtdVariancePercentageQ2,
		YtdVariancePercentageQ3,

		AnnualOriginalBudget,
		CASE WHEN @ReforecastQuarterName = ''Q0'' THEN 0 ELSE AnnualReforecastQ1 END AS AnnualReforecastQ1,
		CASE WHEN @ReforecastQuarterName = ''Q0'' THEN 0 ELSE AnnualReforecastQ2 END AS AnnualReforecastQ2,
		CASE WHEN @ReforecastQuarterName = ''Q0'' THEN 0 ELSE AnnualReforecastQ3 END AS AnnualReforecastQ3
	FROM
		#Result
	ORDER BY
		DisplayOrderNumber,
		#Result.GroupDisplayCode

	SELECT
		ExpenseType,
		InflowOutflow,
		MajorExpenseCategoryName,
		MinorExpenseCategoryName,
		GlobalGlAccountCode,
		GlobalGlAccountName,
		BusinessLine,
		ActivityType,
		ReportingEntityName,
		ReportingEntityType,
		PropertyFundCode,
		FunctionalDepartmentCode,
		AllocationSubRegionName,
		OriginatingSubRegionName,

		ActualsExpensePeriod,
		EntryDate,
		[User],
		[Description],
		AdditionalDescription,
		ReimbursableName,
		FeeAdjustmentCode,
		SourceName,
		GLCategorizationHierarchyKey,

		MtdActual,
		MtdOriginalBudget,
		MtdReforecastQ1,
		MtdReforecastQ2,
		MtdReforecastQ3,
		MtdVarianceQ0,
		MtdVarianceQ1,
		MtdVarianceQ2,
		MtdVarianceQ3,
		YtdActual,
		YtdOriginalBudget,
		YtdReforecastQ1,
		YtdReforecastQ2,
		YtdReforecastQ3,
		YtdVarianceQ0,
		YtdVarianceQ1,
		YtdVarianceQ2,
		YtdVarianceQ3,
		AnnualOriginalBudget,
		AnnualReforecastQ1,
		AnnualReforecastQ2,
		AnnualReforecastQ3,
		ConsolidationSubRegionName
	FROM
		#DetailResult

END

/* =============================================================================================================================================
	Clean Up
   =========================================================================================================================================== */
BEGIN

	IF 	OBJECT_ID(''tempdb..#DetailResult'') IS NOT NULL
		DROP TABLE #DetailResult

	IF 	OBJECT_ID(''tempdb..#Result'') IS NOT NULL
		DROP TABLE #Result

END



' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_S_UnknownMRIActualsCurrentWindowLocal]    Script Date: 03/08/2012 12:51:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_S_UnknownMRIActualsCurrentWindowLocal]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'










--exec stp_S_UnknownSummaryMRIActuals @BudgetYear=2010, @BudgetQuarter=''Q2'', @DataPriorToDate=''2010-12-31'', @StartPeriod=201001, @EndPeriod=201002

CREATE PROCEDURE [dbo].[stp_S_UnknownMRIActualsCurrentWindowLocal]
	@BudgetAllocationSetId int,
	@GBSAccounts bit = 0,
	@StartPeriod int,
	@EndPeriod int,
	@Sources varchar(max)
AS

BEGIN

DECLARE @DataPriorToDate DATETIME
SET @DataPriorToDate = 
(
	SELECT
		ConfiguredValue
	FROM GrReportingStaging.dbo.SSISConfigurations
	WHERE ConfigurationFilter = ''ActualDataPriorToDate''
)

-- Get the period in int form from a datetime
DECLARE @WindowStartPeriod INT
SET @WindowStartPeriod = 
(
	SELECT
		CONVERT(INT, (YEAR(ConfiguredValue) + MONTH(ConfiguredValue)*0.01)*100)  AS ConfiguredValue
	FROM GrReportingStaging.dbo.SSISConfigurations
	WHERE ConfigurationFilter = ''ActualImportStartDate''
)

-- Get the period in int form from a datetime
DECLARE @WindowEndPeriod INT
SET @WindowEndPeriod = 
(
	SELECT
		CONVERT(INT, (YEAR(ConfiguredValue) + MONTH(ConfiguredValue)*0.01)*100)  AS ConfiguredValue
	FROM GrReportingStaging.dbo.SSISConfigurations
	WHERE ConfigurationFilter = ''ActualImportEndDate''
)

IF @StartPeriod < @WindowStartPeriod
	SET @StartPeriod = @WindowStartPeriod
	
IF @EndPeriod > @WindowEndPeriod
	SET @EndPeriod = @WindowEndPeriod

EXECUTE [stp_S_UnknownSummaryMRIActualsLocal] 
   @DataPriorToDate
  ,@StartPeriod
  ,@EndPeriod
  ,@BudgetAllocationSetId
  ,@GBSAccounts,
   @Sources


END









' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_S_UnknownMRIActualsCurrentWindowGlobal]    Script Date: 03/08/2012 12:51:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_S_UnknownMRIActualsCurrentWindowGlobal]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
--exec stp_S_UnknownSummaryMRIActuals @BudgetYear=2010, @BudgetQuarter=''Q2'', @DataPriorToDate=''2010-12-31'', @StartPeriod=201001, @EndPeriod=201002

CREATE PROCEDURE [dbo].[stp_S_UnknownMRIActualsCurrentWindowGlobal]
	@BudgetAllocationSetId int,
	@GBSAccounts bit = 0,
	@StartPeriod int,
	@EndPeriod int,
	@Sources varchar(max)
AS

BEGIN

DECLARE @DataPriorToDate DATETIME
SET @DataPriorToDate = 
(
	SELECT
		ConfiguredValue
	FROM GrReportingStaging.dbo.SSISConfigurations
	WHERE ConfigurationFilter = ''ActualDataPriorToDate''
)

-- Get the period in int form from a datetime
DECLARE @WindowStartPeriod INT
SET @WindowStartPeriod = 
(
	SELECT
		CONVERT(INT, (YEAR(ConfiguredValue) + MONTH(ConfiguredValue)*0.01)*100)  AS ConfiguredValue
	FROM GrReportingStaging.dbo.SSISConfigurations
	WHERE ConfigurationFilter = ''ActualImportStartDate''
)

-- Get the period in int form from a datetime
DECLARE @WindowEndPeriod INT
SET @WindowEndPeriod = 
(
	SELECT
		CONVERT(INT, (YEAR(ConfiguredValue) + MONTH(ConfiguredValue)*0.01)*100)  AS ConfiguredValue
	FROM GrReportingStaging.dbo.SSISConfigurations
	WHERE ConfigurationFilter = ''ActualImportEndDate''
)

IF @StartPeriod < @WindowStartPeriod
	SET @StartPeriod = @WindowStartPeriod
	
IF @EndPeriod > @WindowEndPeriod
	SET @EndPeriod = @WindowEndPeriod

EXECUTE [stp_S_UnknownSummaryMRIActualsGlobal] 
   @DataPriorToDate
  ,@StartPeriod
  ,@EndPeriod
  ,@BudgetAllocationSetId
  ,@GBSAccounts
  ,@Sources


END








' 
END
GO
