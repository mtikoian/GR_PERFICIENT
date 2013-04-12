/* ===============================================================================================================================================
	The following functions need to be dropped:
		[GACS].[DepartmentActive]
		[dbo].[BudgetsToProcessCurrent]
		[TapasGlobal].[PayrollRegionActive]
		
		[TapasGlobalBudgeting].[BenefitOptionActive]
		[TapasGlobalBudgeting].[BudgetActive]
		[TapasGlobalBudgeting].[BudgetEmployeeActive]
		[TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartmentActive]
		[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationActive]
		[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetailActive]
		[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetailActiveInner] -- ?
		[TapasGlobalBudgeting].[BudgetOverheadAllocationActive]
		[TapasGlobalBudgeting].[BudgetOverheadAllocationDetailActive]
		[TapasGlobalBudgeting].[BudgetProjectActive]
		[TapasGlobalBudgeting].[BudgetReportGroupActive]
		[TapasGlobalBudgeting].[BudgetReportGroupDetailActive]
		[TapasGlobalBudgeting].[BudgetStatusActive]		
		[TapasGlobalBudgeting].[BudgetTaxTypeActive]
		[TapasGlobalBudgeting].[TaxTypeActive]
		
	The following functions need to be deployed:

		[dbo].[GetGreatest]
		[dbo].[GetLongestWord]

		[TapasGlobal].[BillingUploadActive]
		[TapasGlobal].[BillingUploadDetailActive]
		[TapasGlobal].[OverheadActive]
		[TapasGlobal].[OverheadRegionActive]
		
		[TapasGlobal].[ProjectActive]
		[TapasGlobal].[RegionExtendedActive]
		[TapasGlobal].[SystemSettingActive]
		[TapasGlobal].[SystemSettingRegionActive]



		[GACS].[EntityActive]
		[GACS].[EntityMappingActive]
		[GACS].[JobCodeActive]

		[Gdm].[AllocationRegionActive]
		[Gdm].[AllocationSubRegionActive]
		[Gdm].[BudgetExchangeRateActive]
		[Gdm].[BudgetExchangeRateDetailActive]
		[Gdm].[BudgetReportGroupPeriodActive]
		[Gdm].[ConsolidationRegionActive]
		[Gdm].[ConsolidationRegionCorporateDepartmentActive]
		[Gdm].[ConsolidationRegionPropertyEntityActive]
		[Gdm].[ConsolidationSubRegionActive]
		[Gdm].[DepartmentActive]
		[Gdm].[EntityTypeActive]
		[Gdm].[GLAccountActive]
		[Gdm].[GLCategorizationActive]
		[Gdm].[GLCategorizationTypeActive]
		[Gdm].[GLFinancialCategoryActive]
		[Gdm].[GLGlobalAccountActive]
		[Gdm].[GLGlobalAccountCategorizationActive]
		[Gdm].[GLMajorCategoryActive]
		[Gdm].[GLMinorCategoryActive]
		[Gdm].[GLMinorCategoryPayrollTypeActive]
		[Gdm].[GlobalRegionActive]
		[Gdm].[GlobalAllocationRegionMappingActive]
		[Gdm].[ManageCorporateDepartmentActive]
		[Gdm].[ManageCorporateEntityActive]
		[Gdm].[ManagePropertyDepartmentActive]
		[Gdm].[ManagePropertyEntityActive]
		[Gdm].[ManageTypeActive]
		[Gdm].[OriginatingRegionCorporateEntityActive]
		[Gdm].[OriginatingRegionPropertyDepartmentActive]
		[Gdm].[PropertyEntityGLAccountInclusionActive]
		[Gdm].[PropertyFundMappingActive]
		[Gdm].[PropertyOverheadPropertyGLAccountActive]
		[Gdm].[PropertyPayrollPropertyGLAccountActive]
		[Gdm].[ReportingCategorizationActive]
		[Gdm].[ReportingEntityCorporateDepartmentActive]
		[Gdm].[ReportingEntityPropertyEntityActive]
		[Gdm].[RestrictedFunctionalDepartmentCorporateEntityActive]		
		[Gdm].[RestrictedFunctionalDepartmentGLGlobalAccountActive]

		[Gr].[GetActivityTypeBusinessLineExpanded]
		[Gr].[GetFunctionalDepartmentExpanded]
		[Gr].[GetGLCategorizationHierarchyExpanded]
		[Gr].[GetGlobalRegionExpanded]
		[Gr].[GetSnapshotActivityTypeBusinessLineExpanded]
		[Gr].[GetSnapshotGLCategorizationHierarchyExpanded]()
		[Gr].[GetSnapshotGlobalRegionExpanded]()
		
		[HR].[LocationActive]
		[HR].[RegionActive]

		-- WHERE ARE THE REST OF THEM? - do they need to be deployed as well?

		[BRCorp].[EntityActive]
		[BRCorp].[GAccActive]
		[BRCorp].[GJobActive]		

		[BRProp].[GAccActive]
		[BRProp].[GDepActive]
		[BRProp].[EntityActive]

		[CNCorp].[EntityActive]
		[CNCorp].[GAccActive]
		[CNCorp].[GDepActive]
		[CNCorp].[GJobActive]

		[CNProp].[EntityActive]
		[CNProp].[GAccActive]
		[CNProp].[GDepActive]
		[CNProp].[GJobActive]

		[EUCorp].[EntityActive]
		[EUCorp].[GAccActive]
		[EUCorp].[GDepActive]
		[EUCorp].[GJobActive]

		[EUProp].[EntityActive]
		[EUProp].[GAccActive]
		[EUProp].[GDepActive]
		[EUProp].[GJobActive]

		[INCorp].[EntityActive]
		[INCorp].[GAccActive]
		[INCorp].[GDepActive]
		[INCorp].[GJobActive]

		[INProp].[EntityActive]
		[INProp].[GAccActive]		
		[INProp].[GDepActive]

		[USCorp].[GDepActive]
		[USCorp].[GJobActive]

		[USProp].[EntityActive]
		[USProp].[GDepActive]
		[USProp].[GAccActive]
		[USProp].[GJobActive]

   ============================================================================================================================================= */
-- DO NOT DELETE	DO NOT DELETE	DO NOT DELETE	DO NOT DELETE	DO NOT DELETE	DO NOT DELETE	DO NOT DELETE	DO NOT DELETE	DO NOT DELETE

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GACS].[DepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [GACS].[DepartmentActive]
GO

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BudgetsToProcessCurrent]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[BudgetsToProcessCurrent]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLAccountSubTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLAccountSubTypeActive]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLAccountTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLAccountTypeActive]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLGlobalAccountGLAccountActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLGlobalAccountGLAccountActive]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLGlobalAccountTranslationSubTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLGlobalAccountTranslationSubTypeActive]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLGlobalAccountTranslationTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLGlobalAccountTranslationTypeActive]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLTranslationSubTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLTranslationSubTypeActive]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLTranslationTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLTranslationTypeActive]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetGlobalGlAccountCategoryTranslation]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gr].[GetGlobalGlAccountCategoryTranslation]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetSnapshotGlobalGlAccountCategoryTranslation]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gr].[GetSnapshotGlobalGlAccountCategoryTranslation]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[PayrollRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[PayrollRegionActive]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BenefitOptionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BenefitOptionActive]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetActive]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetEmployeeActive]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartmentActive]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationActive]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetailActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetailActive]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetailActiveInner]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetailActiveInner]
GO


iF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetOverheadAllocationActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetOverheadAllocationActive]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetOverheadAllocationDetailActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetOverheadAllocationDetailActive]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetProjectActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetProjectActive]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetReportGroupActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetReportGroupActive]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetReportGroupDetailActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetReportGroupDetailActive]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetStatusActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetStatusActive]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetTaxTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetTaxTypeActive]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[TaxTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[TaxTypeActive]
GO

-- DO NOT DELETE	DO NOT DELETE	DO NOT DELETE	DO NOT DELETE	DO NOT DELETE	DO NOT DELETE	DO NOT DELETE	DO NOT DELETE	DO NOT DELETE



USE [GrReportingStaging]
GO
/****** Object:  UserDefinedFunction [Gr].[GetActivityTypeBusinessLineExpanded]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetActivityTypeBusinessLineExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gr].[GetActivityTypeBusinessLineExpanded]
GO
/****** Object:  UserDefinedFunction [Gr].[GetFunctionalDepartmentExpanded]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetFunctionalDepartmentExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gr].[GetFunctionalDepartmentExpanded]
GO
/****** Object:  UserDefinedFunction [Gr].[GetGLCategorizationHierarchyExpanded]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetGLCategorizationHierarchyExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gr].[GetGLCategorizationHierarchyExpanded]
GO
/****** Object:  UserDefinedFunction [Gr].[GetGlobalGlAccountCategoryTranslation]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetGlobalGlAccountCategoryTranslation]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gr].[GetGlobalGlAccountCategoryTranslation]
GO
/****** Object:  UserDefinedFunction [Gr].[GetGlobalRegionExpanded]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetGlobalRegionExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gr].[GetGlobalRegionExpanded]
GO
/****** Object:  UserDefinedFunction [dbo].[GetGreatest]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetGreatest]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetGreatest]
GO
/****** Object:  UserDefinedFunction [Gdm].[ConsolidationSubRegionActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ConsolidationSubRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ConsolidationSubRegionActive]
GO
/****** Object:  UserDefinedFunction [GACS].[EntityMappingActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GACS].[EntityMappingActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [GACS].[EntityMappingActive]
GO
/****** Object:  UserDefinedFunction [Gr].[GetSnapshotActivityTypeBusinessLineExpanded]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetSnapshotActivityTypeBusinessLineExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gr].[GetSnapshotActivityTypeBusinessLineExpanded]
GO
/****** Object:  UserDefinedFunction [Gr].[GetSnapshotGLCategorizationHierarchyExpanded]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetSnapshotGLCategorizationHierarchyExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gr].[GetSnapshotGLCategorizationHierarchyExpanded]
GO
/****** Object:  UserDefinedFunction [Gr].[GetSnapshotGlobalGlAccountCategoryTranslation]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetSnapshotGlobalGlAccountCategoryTranslation]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gr].[GetSnapshotGlobalGlAccountCategoryTranslation]
GO
/****** Object:  UserDefinedFunction [Gr].[GetSnapshotGlobalRegionExpanded]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetSnapshotGlobalRegionExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gr].[GetSnapshotGlobalRegionExpanded]
GO
/****** Object:  UserDefinedFunction [HR].[FunctionalDepartmentActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[HR].[FunctionalDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [HR].[FunctionalDepartmentActive]
GO
/****** Object:  UserDefinedFunction [BRCorp].[GDepActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRCorp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [BRCorp].[GDepActive]
GO
/****** Object:  UserDefinedFunction [BRProp].[GDepActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRProp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [BRProp].[GDepActive]
GO
/****** Object:  UserDefinedFunction [CNCorp].[GDepActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNCorp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [CNCorp].[GDepActive]
GO
/****** Object:  UserDefinedFunction [CNProp].[GDepActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNProp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [CNProp].[GDepActive]
GO
/****** Object:  UserDefinedFunction [EUCorp].[GDepActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUCorp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [EUCorp].[GDepActive]
GO
/****** Object:  UserDefinedFunction [EUProp].[GDepActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUProp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [EUProp].[GDepActive]
GO
/****** Object:  UserDefinedFunction [INCorp].[GDepActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INCorp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [INCorp].[GDepActive]
GO
/****** Object:  UserDefinedFunction [INProp].[GDepActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INProp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [INProp].[GDepActive]
GO
/****** Object:  UserDefinedFunction [USCorp].[GDepActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USCorp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [USCorp].[GDepActive]
GO
/****** Object:  UserDefinedFunction [USProp].[GDepActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USProp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [USProp].[GDepActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[DepartmentActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[DepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[DepartmentActive]
GO
/****** Object:  UserDefinedFunction [BRCorp].[EntityActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRCorp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [BRCorp].[EntityActive]
GO
/****** Object:  UserDefinedFunction [BRProp].[EntityActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRProp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [BRProp].[EntityActive]
GO
/****** Object:  UserDefinedFunction [CNCorp].[EntityActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNCorp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [CNCorp].[EntityActive]
GO
/****** Object:  UserDefinedFunction [CNProp].[EntityActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNProp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [CNProp].[EntityActive]
GO
/****** Object:  UserDefinedFunction [EUCorp].[EntityActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUCorp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [EUCorp].[EntityActive]
GO
/****** Object:  UserDefinedFunction [EUProp].[EntityActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUProp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [EUProp].[EntityActive]
GO
/****** Object:  UserDefinedFunction [GACS].[EntityActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GACS].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [GACS].[EntityActive]
GO
/****** Object:  UserDefinedFunction [INCorp].[EntityActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INCorp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [INCorp].[EntityActive]
GO
/****** Object:  UserDefinedFunction [INProp].[EntityActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INProp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [INProp].[EntityActive]
GO
/****** Object:  UserDefinedFunction [USCorp].[EntityActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USCorp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [USCorp].[EntityActive]
GO
/****** Object:  UserDefinedFunction [USProp].[EntityActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USProp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [USProp].[EntityActive]
GO
/****** Object:  UserDefinedFunction [BRCorp].[GAccActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRCorp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [BRCorp].[GAccActive]
GO
/****** Object:  UserDefinedFunction [BRProp].[GAccActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRProp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [BRProp].[GAccActive]
GO
/****** Object:  UserDefinedFunction [CNCorp].[GAccActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNCorp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [CNCorp].[GAccActive]
GO
/****** Object:  UserDefinedFunction [CNProp].[GAccActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNProp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [CNProp].[GAccActive]
GO
/****** Object:  UserDefinedFunction [EUCorp].[GAccActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUCorp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [EUCorp].[GAccActive]
GO
/****** Object:  UserDefinedFunction [EUProp].[GAccActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUProp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [EUProp].[GAccActive]
GO
/****** Object:  UserDefinedFunction [INCorp].[GAccActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INCorp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [INCorp].[GAccActive]
GO
/****** Object:  UserDefinedFunction [INProp].[GAccActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INProp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [INProp].[GAccActive]
GO
/****** Object:  UserDefinedFunction [USCorp].[GAccActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USCorp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [USCorp].[GAccActive]
GO
/****** Object:  UserDefinedFunction [USProp].[GAccActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USProp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [USProp].[GAccActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[ActivityTypeActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ActivityTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ActivityTypeActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[ActivityTypeBusinessLineActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ActivityTypeBusinessLineActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ActivityTypeBusinessLineActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[AllocationSubRegionActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[AllocationSubRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[AllocationSubRegionActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[AllocationRegionActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[AllocationRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[AllocationRegionActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BenefitOptionActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BenefitOptionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BenefitOptionActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[BillingUploadActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[BillingUploadActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[BillingUploadActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[BillingUploadDetailActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[BillingUploadDetailActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[BillingUploadDetailActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetEmployeeActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetEmployeeActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartmentActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartmentActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetailActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetailActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetailActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[BudgetExchangeRateActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[BudgetExchangeRateActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[BudgetExchangeRateActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[BudgetExchangeRateDetailActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[BudgetExchangeRateDetailActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[BudgetExchangeRateDetailActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetOverheadAllocationActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetOverheadAllocationActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetOverheadAllocationActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetOverheadAllocationDetailActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetOverheadAllocationDetailActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetOverheadAllocationDetailActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetProjectActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetProjectActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetProjectActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetReportGroupActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetReportGroupActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetReportGroupActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetReportGroupDetailActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetReportGroupDetailActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetReportGroupDetailActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[BudgetReportGroupPeriodActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[BudgetReportGroupPeriodActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[BudgetReportGroupPeriodActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetStatusActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetStatusActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetStatusActive]
GO
/****** Object:  UserDefinedFunction [dbo].[BudgetsToProcessCurrent]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BudgetsToProcessCurrent]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[BudgetsToProcessCurrent]
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetTaxTypeActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetTaxTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetTaxTypeActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[BusinessLineActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[BusinessLineActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[BusinessLineActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[ConsolidationRegionActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ConsolidationRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ConsolidationRegionActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[ConsolidationRegionCorporateDepartmentActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ConsolidationRegionCorporateDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ConsolidationRegionCorporateDepartmentActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[ConsolidationRegionPropertyEntityActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ConsolidationRegionPropertyEntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ConsolidationRegionPropertyEntityActive]
GO
/****** Object:  UserDefinedFunction [BRCorp].[GJobActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRCorp].[GJobActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [BRCorp].[GJobActive]
GO
/****** Object:  UserDefinedFunction [CNCorp].[GJobActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNCorp].[GJobActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [CNCorp].[GJobActive]
GO
/****** Object:  UserDefinedFunction [CNProp].[GJobActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNProp].[GJobActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [CNProp].[GJobActive]
GO
/****** Object:  UserDefinedFunction [EUCorp].[GJobActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUCorp].[GJobActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [EUCorp].[GJobActive]
GO
/****** Object:  UserDefinedFunction [EUProp].[GJobActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUProp].[GJobActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [EUProp].[GJobActive]
GO
/****** Object:  UserDefinedFunction [INCorp].[GJobActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INCorp].[GJobActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [INCorp].[GJobActive]
GO
/****** Object:  UserDefinedFunction [USCorp].[GJobActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USCorp].[GJobActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [USCorp].[GJobActive]
GO
/****** Object:  UserDefinedFunction [USProp].[GJobActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USProp].[GJobActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [USProp].[GJobActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[GLAccountActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLAccountActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLAccountActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[GLCategorizationActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLCategorizationActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLCategorizationActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[GLCategorizationTypeActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLCategorizationTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLCategorizationTypeActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[GLFinancialCategoryActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLFinancialCategoryActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLFinancialCategoryActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[GLGlobalAccountCategorizationActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLGlobalAccountCategorizationActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLGlobalAccountCategorizationActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[GLGlobalAccountActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLGlobalAccountActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLGlobalAccountActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[GLMajorCategoryActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLMajorCategoryActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLMajorCategoryActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[GLMinorCategoryActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLMinorCategoryActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLMinorCategoryActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[GLMinorCategoryPayrollTypeActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLMinorCategoryPayrollTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLMinorCategoryPayrollTypeActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[GlobalRegionActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GlobalRegionActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[GlobalAllocationRegionMappingActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalAllocationRegionMappingActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GlobalAllocationRegionMappingActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[EntityTypeActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[EntityTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[EntityTypeActive]
GO
/****** Object:  UserDefinedFunction [GACS].[JobCodeActive]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GACS].[JobCodeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [GACS].[JobCodeActive]
GO
/****** Object:  UserDefinedFunction [HR].[LocationActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[HR].[LocationActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [HR].[LocationActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[ManageCorporateDepartmentActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ManageCorporateDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ManageCorporateDepartmentActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[ManageCorporateEntityActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ManageCorporateEntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ManageCorporateEntityActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[ManagePropertyDepartmentActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ManagePropertyDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ManagePropertyDepartmentActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[ManagePropertyEntityActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ManagePropertyEntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ManagePropertyEntityActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[ManageTypeActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ManageTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ManageTypeActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[MRIServerSourceActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[MRIServerSourceActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[MRIServerSourceActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[OriginatingRegionCorporateEntityActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[OriginatingRegionCorporateEntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[OriginatingRegionCorporateEntityActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[OriginatingRegionPropertyDepartmentActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[OriginatingRegionPropertyDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[OriginatingRegionPropertyDepartmentActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[OverheadActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[OverheadActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[OverheadActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[OverheadRegionActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[OverheadRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[OverheadRegionActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[PayrollRegionActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[PayrollRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[PayrollRegionActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[ProjectActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[ProjectActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[ProjectActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[PropertyEntityGLAccountInclusionActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[PropertyEntityGLAccountInclusionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[PropertyEntityGLAccountInclusionActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[PropertyFundActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[PropertyFundActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[PropertyFundActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[PropertyFundMappingActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[PropertyFundMappingActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[PropertyFundMappingActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[PropertyOverheadPropertyGLAccountActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[PropertyOverheadPropertyGLAccountActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[PropertyOverheadPropertyGLAccountActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[PropertyPayrollPropertyGLAccountActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[PropertyPayrollPropertyGLAccountActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[PropertyPayrollPropertyGLAccountActive]
GO
/****** Object:  UserDefinedFunction [HR].[RegionActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[HR].[RegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [HR].[RegionActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[RegionExtendedActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[RegionExtendedActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[RegionExtendedActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[ReportingCategorizationActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ReportingCategorizationActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ReportingCategorizationActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[ReportingEntityCorporateDepartmentActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ReportingEntityCorporateDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ReportingEntityCorporateDepartmentActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[ReportingEntityPropertyEntityActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ReportingEntityPropertyEntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ReportingEntityPropertyEntityActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[RestrictedFunctionalDepartmentCorporateEntityActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[RestrictedFunctionalDepartmentCorporateEntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[RestrictedFunctionalDepartmentCorporateEntityActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[RestrictedFunctionalDepartmentGLGlobalAccountActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[RestrictedFunctionalDepartmentGLGlobalAccountActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[RestrictedFunctionalDepartmentGLGlobalAccountActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[SystemSettingActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[SystemSettingActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[SystemSettingActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[SystemSettingRegionActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[SystemSettingRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[SystemSettingRegionActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[TaxTypeActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[TaxTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[TaxTypeActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[GlobalFunctionalDepartmentActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalFunctionalDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GlobalFunctionalDepartmentActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[GlobalAccountCategoryActive]    Script Date: 02/24/2012 10:21:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalAccountCategoryActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GlobalAccountCategoryActive]
GO
/****** Object:  UserDefinedFunction [dbo].[GetSplit]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetSplit]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetSplit]
GO
/****** Object:  UserDefinedFunction [dbo].[GetLongestWord]    Script Date: 02/24/2012 10:21:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetLongestWord]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetLongestWord]
GO
/****** Object:  UserDefinedFunction [dbo].[GetLongestWord]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetLongestWord]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[GetLongestWord]
(
	@InputString Varchar(255)
)
RETURNS int
AS

BEGIN
DECLARE @Name Varchar(50),
		@Output Varchar(50),
		@SpaceIndex Int,
		@ExitCount Int
DECLARE @Rows TABLE(Portion Varchar(50) NOT NULL)


SET @Name = @InputString
SET @SpaceIndex = PATINDEX(''% %'',@Name)
SET @ExitCount = 1

WHILE (@SpaceIndex > 0 AND @ExitCount <= 5)
	BEGIN
	--print ''@SpaceIndex''
	--print @SpaceIndex

	
	INSERT INTO  @Rows
	(Portion)
	Select SUBSTRING(@Name,0,@SpaceIndex)
	
	--print @Name
	--Select * From @Rows
	
	SET  @Name = SUBSTRING(@Name,@SpaceIndex+1, LEN(@Name)-@SpaceIndex)
	
	--print @Name
	
	SET @SpaceIndex = PATINDEX(''% %'',@Name)
	
	SET @ExitCount = @ExitCount + 1
	END

INSERT INTO  @Rows
(Portion)
Select @Name


RETURN (Select MAX(LEN(Portion)) From @Rows)

END
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetSplit]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetSplit]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE   FUNCTION [dbo].[GetSplit]
	(@str varchar(1024))
RETURNS @table TABLE 
	(item varchar(100))
AS
BEGIN   

	declare @start int
	set @start = 0
	WHILE (charindex('','', @str, @start) > 0)
	BEGIN
		if substring(@str, charindex('','', @str, @start) - 1, 1) = ''\'' begin
			set @start = charindex('','', @str, @start) + 1
		end else begin
			INSERT @table
			SELECT replace(left(@str, charindex('','', @str, @start) - 1), ''\,'', '','')

			set @str = stuff(@str, 1, charindex('','', @str, @start), '''')
			set @start = 0
		end
	END
	INSERT @table
	SELECT replace(@str, ''\,'', '','')
	RETURN 
END
' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[GlobalAccountCategoryActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalAccountCategoryActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE   FUNCTION [Gdm].[GlobalAccountCategoryActive]
	(@DataPriorToDate DateTime)
RETURNS @Result TABLE 
	(ImportKey Int NOT NULL)
AS
BEGIN   

INSERT Into @Result
(ImportKey)
Select 
	MAX(Gl1.ImportKey) ImportKey
	From
	[Gdm].[GlobalAccountCategory] Gl1
		INNER JOIN (
		Select 
				GlobalAccountCategoryId,
				MAX(UpdatedDate) UpdatedDate
		From 
				[Gdm].[GlobalAccountCategory]
		Where	UpdatedDate <= @DataPriorToDate
		Group By GlobalAccountCategoryId
		) t1 ON t1.GlobalAccountCategoryId = Gl1.GlobalAccountCategoryId
	AND t1.UpdatedDate = Gl1.UpdatedDate
	Where Gl1.UpdatedDate <= @DataPriorToDate
	Group By Gl1.GlobalAccountCategoryId	

RETURN 
END
' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[GlobalFunctionalDepartmentActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalFunctionalDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE   FUNCTION [Gdm].[GlobalFunctionalDepartmentActive]
	(@DataPriorToDate DateTime)
RETURNS @Result TABLE 
	(ImportKey Int NOT NULL)
AS
BEGIN   

INSERT Into @Result
(ImportKey)
Select 
	MAX(Gl1.ImportKey) ImportKey
	From
	[Gdm].[GlobalFunctionalDepartment] Gl1
		INNER JOIN (
		Select 
				GlobalFunctionalDepartmentId,
				MAX(UpdatedDate) UpdatedDate
		From 
				[Gdm].[GlobalFunctionalDepartment]
		Where	UpdatedDate < @DataPriorToDate
		Group By GlobalFunctionalDepartmentId
		) t1 ON t1.GlobalFunctionalDepartmentId = Gl1.GlobalFunctionalDepartmentId
	AND t1.UpdatedDate = Gl1.UpdatedDate
	Where Gl1.UpdatedDate < @DataPriorToDate
	Group By Gl1.GlobalFunctionalDepartmentId	

RETURN 
END
' 
END
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[TaxTypeActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[TaxTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [TapasGlobalBudgeting].[TaxTypeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[TaxType] B1
		INNER JOIN (
			SELECT 
				TaxTypeId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobalBudgeting].[TaxType]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY TaxTypeId
		) t1 ON t1.TaxTypeId = B1.TaxTypeId AND
				t1.UpdatedDate = B1.UpdatedDate
	WHERE B1.UpdatedDate <= @DataPriorToDate
	GROUP BY B1.TaxTypeId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[SystemSettingRegionActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[SystemSettingRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [TapasGlobal].[SystemSettingRegionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[SystemSettingRegion] Gl1
		INNER JOIN (
			SELECT 
				SystemSettingRegionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobal].[SystemSettingRegion]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY SystemSettingRegionId
		) t1 ON t1.SystemSettingRegionId = Gl1.SystemSettingRegionId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.SystemSettingRegionId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[SystemSettingActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[SystemSettingActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [TapasGlobal].[SystemSettingActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[SystemSetting] Gl1
		INNER JOIN (
		SELECT 
			SystemSettingId,
			MAX(UpdatedDate) UpdatedDate
		FROM 
			[TapasGlobal].[SystemSetting]
		WHERE	UpdatedDate <= @DataPriorToDate
		GROUP BY SystemSettingId
		) t1 ON t1.SystemSettingId = Gl1.SystemSettingId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.SystemSettingId
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[RestrictedFunctionalDepartmentGLGlobalAccountActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[RestrictedFunctionalDepartmentGLGlobalAccountActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
/*********************************************************************************************************************
Description
	This function returns the Import Keys of the active [Gdm].[RestrictedFunctionalDepartmentGLGlobalAccountActive] 
	records
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-09-08		: PKayongo	:	The function was created. 	
**********************************************************************************************************************/

CREATE FUNCTION [Gdm].[RestrictedFunctionalDepartmentGLGlobalAccountActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[RestrictedFunctionalDepartmentGLGlobalAccount] Gl1
		INNER JOIN (
			SELECT 
				GLGlobalAccountId,
				ISNULL(FunctionalDepartmentId, 0) AS FunctionalDepartmentId, -- Functional Department can have a null value.
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[RestrictedFunctionalDepartmentGLGlobalAccount]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				GLGlobalAccountId,
				FunctionalDepartmentId
		) t1 ON 
			t1.GLGlobalAccountId = Gl1.GLGlobalAccountId AND
			t1.FunctionalDepartmentId = ISNULL(Gl1.FunctionalDepartmentId, 0) AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.GLGlobalAccountId,
		Gl1.FunctionalDepartmentId
)


' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[RestrictedFunctionalDepartmentCorporateEntityActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[RestrictedFunctionalDepartmentCorporateEntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
/*********************************************************************************************************************
Description
	This function returns the Import Keys of the active [Gdm].[RestrictedFunctionalDepartmentCorporateEntityActive]
	records
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-09-08		: PKayongo	:	The function was created. 	
**********************************************************************************************************************/


CREATE FUNCTION [Gdm].[RestrictedFunctionalDepartmentCorporateEntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[RestrictedFunctionalDepartmentCorporateEntity] Gl1
		INNER JOIN (
			SELECT 
				CorporateEntityCode,
				FunctionalDepartmentId,
				CorporateEntitySourceCode,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[RestrictedFunctionalDepartmentCorporateEntity]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY 
				CorporateEntityCode,
				FunctionalDepartmentId,
				CorporateEntitySourceCode
		) t1 ON 
			t1.CorporateEntityCode = Gl1.CorporateEntityCode AND
			t1.FunctionalDepartmentId = Gl1.FunctionalDepartmentId AND
			t1.CorporateEntitySourceCode = Gl1.CorporateEntitySourceCode AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.CorporateEntityCode,
		Gl1.FunctionalDepartmentId,
		Gl1.CorporateEntitySourceCode
)' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[ReportingEntityPropertyEntityActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ReportingEntityPropertyEntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gdm].[ReportingEntityPropertyEntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ReportingEntityPropertyEntity] Gl1
		INNER JOIN (
			SELECT 
				PropertyEntityCode,
				SourceCode,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ReportingEntityPropertyEntity]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY 
				PropertyEntityCode,
				SourceCode
		) t1 ON 
			t1.PropertyEntityCode = Gl1.PropertyEntityCode AND
			t1.SourceCode = Gl1.SourceCode AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.PropertyEntityCode,
		Gl1.SourceCode
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[ReportingEntityCorporateDepartmentActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ReportingEntityCorporateDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gdm].[ReportingEntityCorporateDepartmentActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ReportingEntityCorporateDepartment] Gl1
		INNER JOIN (
			SELECT 
				CorporateDepartmentCode,
				SourceCode,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ReportingEntityCorporateDepartment]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				CorporateDepartmentCode,
				SourceCode
		) t1 ON 
			t1.CorporateDepartmentCode = Gl1.CorporateDepartmentCode AND
			t1.SourceCode = Gl1.SourceCode AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.CorporateDepartmentCode,
		Gl1.SourceCode
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[ReportingCategorizationActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ReportingCategorizationActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
/*********************************************************************************************************************
Description
	This function returns the Import Keys of the active [Gdm].[ReportingCategorizationActive] records
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-09-08		: PKayongo	:	The function was created. 	
**********************************************************************************************************************/

CREATE FUNCTION [Gdm].[ReportingCategorizationActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ReportingCategorization] Gl1
		INNER JOIN (
			SELECT 
				EntityTypeId,
				AllocationSubRegionGlobalRegionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ReportingCategorization]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				EntityTypeId,
				AllocationSubRegionGlobalRegionId
		) t1 ON 
			t1.EntityTypeId = Gl1.EntityTypeId AND
			t1.AllocationSubRegionGlobalRegionId = Gl1.AllocationSubRegionGlobalRegionId AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.EntityTypeId,
		Gl1.AllocationSubRegionGlobalRegionId
)

' 
END
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[RegionExtendedActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[RegionExtendedActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [TapasGlobal].[RegionExtendedActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[RegionExtended] Gl1
		INNER JOIN (
			SELECT 
				RegionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobal].[RegionExtended]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY RegionId
		) t1 ON t1.RegionId = Gl1.RegionId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.RegionId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [HR].[RegionActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[HR].[RegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [HR].[RegionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
	[HR].[Region] Gl1
		INNER JOIN (
			SELECT 
				RegionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[HR].[Region]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY RegionId
		) t1 ON t1.RegionId = Gl1.RegionId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.RegionId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[PropertyPayrollPropertyGLAccountActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[PropertyPayrollPropertyGLAccountActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
/*********************************************************************************************************************
Description
	This function returns the Import Keys of the active Gdm.PropertyPayrollPropertyGLAccountActive records
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-09-08		: PKayongo	:	The function was created. 	
**********************************************************************************************************************/

CREATE FUNCTION [Gdm].[PropertyPayrollPropertyGLAccountActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[PropertyPayrollPropertyGLAccount] Gl1
		INNER JOIN (
			SELECT 
				ISNULL(GLCategorizationId, '''') AS GLCategorizationId,
				ISNULL(PayrollTypeId, '''') AS PayrollTypeId,
				ISNULL(GLMinorCategoryId, '''') AS GLMinorCategoryId,
				ISNULL(ActivityTypeId, '''') AS ActivityTypeId,
				ISNULL(FunctionalDepartmentId, '''') AS FunctionalDepartmentId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[PropertyPayrollPropertyGLAccount]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				ISNULL(GLCategorizationId, ''''),
				ISNULL(PayrollTypeId, ''''),
				ISNULL(GLMinorCategoryId, ''''),
				ISNULL(ActivityTypeId, ''''),
				ISNULL(FunctionalDepartmentId, '''')
		) t1 ON 
			t1.GLCategorizationId = ISNULL(Gl1.GLCategorizationId, '''') AND
			t1.PayrollTypeId = ISNULL(Gl1.PayrollTypeId, '''') AND
			t1.GLMinorCategoryId = ISNULL(Gl1.GLMinorCategoryId, '''') AND
			t1.ActivityTypeId = ISNULL(Gl1.ActivityTypeId, '''') AND
			t1.FunctionalDepartmentId = ISNULL(Gl1.FunctionalDepartmentId, '''') AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.GLCategorizationId,
		Gl1.PayrollTypeId,
		Gl1.GLMinorCategoryId,
		Gl1.ActivityTypeId,
		Gl1.FunctionalDepartmentId
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[PropertyOverheadPropertyGLAccountActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[PropertyOverheadPropertyGLAccountActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
/*********************************************************************************************************************
Description
	This function returns the Import Keys of the active [Gdm].[PropertyOverheadPropertyGLAccountActive] records
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-09-08		: PKayongo	:	The function was created. 	
**********************************************************************************************************************/

CREATE FUNCTION [Gdm].[PropertyOverheadPropertyGLAccountActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[PropertyOverheadPropertyGLAccount] Gl1
		INNER JOIN (
			SELECT 
				ISNULL(GLCategorizationId, '''') AS GLCategorizationId,
				ISNULL(ActivityTypeId, '''') AS ActivityTypeId,
				ISNULL(FunctionalDepartmentId, '''') AS FunctionalDepartmentId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[PropertyOverheadPropertyGLAccount]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				ISNULL(GLCategorizationId, ''''),
				ISNULL(ActivityTypeId, ''''),
				ISNULL(FunctionalDepartmentId, '''')
		) t1 ON 
			t1.GLCategorizationId = ISNULL(Gl1.GLCategorizationId, '''') AND
			t1.ActivityTypeId = ISNULL(Gl1.ActivityTypeId, '''') AND
			t1.FunctionalDepartmentId = ISNULL(Gl1.FunctionalDepartmentId, '''') AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.GLCategorizationId,
		Gl1.ActivityTypeId,
		Gl1.FunctionalDepartmentId
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[PropertyFundMappingActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[PropertyFundMappingActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [Gdm].[PropertyFundMappingActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[PropertyFundMapping] Gl1
		INNER JOIN (
			SELECT 
				SourceCode,
				PropertyFundCode,
				ActivityTypeId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[PropertyFundMapping]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY SourceCode,
				PropertyFundCode,
				ActivityTypeId
		) t1 ON t1.SourceCode = Gl1.SourceCode AND
				t1.PropertyFundCode = Gl1.PropertyFundCode AND
				(
				(t1.ActivityTypeId IS NOT NULL AND t1.ActivityTypeId = Gl1.ActivityTypeId)
				OR
				(t1.ActivityTypeId IS NULL AND Gl1.ActivityTypeId IS NULL)
				) AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.PropertyFundMappingId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[PropertyFundActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[PropertyFundActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE   FUNCTION [Gdm].[PropertyFundActive]
	(@DataPriorToDate DateTime)
RETURNS @Result TABLE 
	(ImportKey Int NOT NULL)
AS
BEGIN   

INSERT Into @Result
(ImportKey)
Select 
	MAX(Gl1.ImportKey) ImportKey
	From
	[Gdm].[PropertyFund] Gl1
		INNER JOIN (
		Select 
				PropertyFundId,
				MAX(UpdatedDate) UpdatedDate
		From 
				[Gdm].[PropertyFund]
		Where	UpdatedDate <= @DataPriorToDate
		Group By PropertyFundId
		) t1 ON t1.PropertyFundId = Gl1.PropertyFundId
	AND t1.UpdatedDate = Gl1.UpdatedDate
	Where Gl1.UpdatedDate <= @DataPriorToDate
	Group By Gl1.PropertyFundId	

RETURN 
END

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[PropertyEntityGLAccountInclusionActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[PropertyEntityGLAccountInclusionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gdm].[PropertyEntityGLAccountInclusionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[PropertyEntityGLAccountInclusion] Gl1
		INNER JOIN (
			SELECT 
				PropertyEntityGLAccountInclusionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[PropertyEntityGLAccountInclusion]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY PropertyEntityGLAccountInclusionId
		) t1 ON t1.PropertyEntityGLAccountInclusionId = Gl1.PropertyEntityGLAccountInclusionId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.PropertyEntityGLAccountInclusionId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[ProjectActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[ProjectActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [TapasGlobal].[ProjectActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[Project] Gl1
		INNER JOIN (
			SELECT 
				ProjectId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
					[TapasGlobal].[Project]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY ProjectId
		) t1 ON t1.ProjectId = Gl1.ProjectId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.ProjectId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[PayrollRegionActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[PayrollRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [TapasGlobal].[PayrollRegionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[PayrollRegion] Gl1
		INNER JOIN (
			SELECT 
				PayrollRegionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobal].[PayrollRegion]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY PayrollRegionId
		) t1 ON t1.PayrollRegionId = Gl1.PayrollRegionId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.PayrollRegionId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[OverheadRegionActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[OverheadRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [TapasGlobal].[OverheadRegionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[OverheadRegion] Gl1
		INNER JOIN (
			SELECT 
				OverheadRegionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobal].[OverheadRegion]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY OverheadRegionId
		) t1 ON t1.OverheadRegionId = Gl1.OverheadRegionId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.OverheadRegionId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[OverheadActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[OverheadActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [TapasGlobal].[OverheadActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[Overhead] Gl1
		INNER JOIN (
			SELECT 
				OverheadId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobal].[Overhead]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY OverheadId
		) t1 ON t1.OverheadId = Gl1.OverheadId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.OverheadId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[OriginatingRegionPropertyDepartmentActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[OriginatingRegionPropertyDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gdm].[OriginatingRegionPropertyDepartmentActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[OriginatingRegionPropertyDepartment] Gl1
		INNER JOIN (
			SELECT 
				PropertyDepartmentCode,
				SourceCode,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[OriginatingRegionPropertyDepartment]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				PropertyDepartmentCode,
				SourceCode
		) t1 ON 
			t1.PropertyDepartmentCode = Gl1.PropertyDepartmentCode AND
			t1.SourceCode = Gl1.SourceCode AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.PropertyDepartmentCode,
		Gl1.SourceCode	
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[OriginatingRegionCorporateEntityActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[OriginatingRegionCorporateEntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gdm].[OriginatingRegionCorporateEntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[OriginatingRegionCorporateEntity] Gl1
		INNER JOIN (
			SELECT 
				CorporateEntityCode,
				SourceCode,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[OriginatingRegionCorporateEntity]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				CorporateEntityCode,
				SourceCode
		) t1 ON 
			t1.CorporateEntityCode = Gl1.CorporateEntityCode AND
			t1.SourceCode = Gl1.SourceCode AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.CorporateEntityCode,
		Gl1.SourceCode	
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[MRIServerSourceActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[MRIServerSourceActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gdm].[MRIServerSourceActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[MRIServerSource] Gl1
		INNER JOIN (
			SELECT 
				SourceCode,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[MRIServerSource]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				SourceCode
		) t1 ON 
			t1.SourceCode = Gl1.SourceCode AND
			t1.UpdatedDate = Gl1.UpdatedDate
	Where 
		Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.SourceCode	
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[ManageTypeActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ManageTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

CREATE FUNCTION [Gdm].[ManageTypeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ManageType] Gl1
		INNER JOIN (
			SELECT 
				Code,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ManageType]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				Code
		) t1 ON 
			t1.Code = Gl1.Code AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.Code
)


' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[ManagePropertyEntityActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ManagePropertyEntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gdm].[ManagePropertyEntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ManagePropertyEntity] Gl1
		INNER JOIN (
			SELECT 
				ManageTypeId,
				PropertyEntityCode,
				SourceCode,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ManagePropertyEntity]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				ManageTypeId,
				PropertyEntityCode,
				SourceCode
		) t1 ON 
			t1.ManageTypeId = Gl1.ManageTypeId AND
			t1.PropertyEntityCode = Gl1.PropertyEntityCode AND
			t1.SourceCode = Gl1.SourceCode AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.ManageTypeId,
		Gl1.PropertyEntityCode,
		Gl1.SourceCode
)


' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[ManagePropertyDepartmentActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ManagePropertyDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

CREATE FUNCTION [Gdm].[ManagePropertyDepartmentActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ManagePropertyDepartment] Gl1
		INNER JOIN (
			SELECT 
				ManageTypeId,
				PropertyDepartmentCode,
				SourceCode,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ManagePropertyDepartment]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				ManageTypeId,
				PropertyDepartmentCode,
				SourceCode
		) t1 ON 
			t1.ManageTypeId = Gl1.ManageTypeId AND
			t1.PropertyDepartmentCode = Gl1.PropertyDepartmentCode AND
			t1.SourceCode = Gl1.SourceCode AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.ManageTypeId,
		Gl1.PropertyDepartmentCode,
		Gl1.SourceCode
)


' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[ManageCorporateEntityActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ManageCorporateEntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gdm].[ManageCorporateEntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ManageCorporateEntity] Gl1
		INNER JOIN (
			SELECT 
				ManageTypeId,
				CorporateEntityCode,
				SourceCode,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ManageCorporateEntity]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				ManageTypeId,
				CorporateEntityCode,
				SourceCode
		) t1 ON 
			t1.ManageTypeId = Gl1.ManageTypeId AND
			t1.CorporateEntityCode = Gl1.CorporateEntityCode AND
			t1.SourceCode = Gl1.SourceCode AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.ManageTypeId,
		Gl1.CorporateEntityCode,
		Gl1.SourceCode
)


' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[ManageCorporateDepartmentActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ManageCorporateDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gdm].[ManageCorporateDepartmentActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ManageCorporateDepartment] Gl1
		INNER JOIN (
			SELECT 
				ManageTypeId,
				CorporateDepartmentCode,
				SourceCode,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ManageCorporateDepartment]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				ManageTypeId,
				CorporateDepartmentCode,
				SourceCode
		) t1 ON 
			t1.ManageTypeId = Gl1.ManageTypeId AND
			t1.CorporateDepartmentCode = Gl1.CorporateDepartmentCode AND
			t1.SourceCode = Gl1.SourceCode AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.ManageTypeId,
		Gl1.CorporateDepartmentCode,
		Gl1.SourceCode
)


' 
END
GO
/****** Object:  UserDefinedFunction [HR].[LocationActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[HR].[LocationActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [HR].[LocationActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
	[HR].[Location] Gl1
		INNER JOIN (
			SELECT 
				LocationId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[HR].[Location]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY LocationId
		) t1 ON t1.LocationId = Gl1.LocationId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.LocationId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [GACS].[JobCodeActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GACS].[JobCodeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [GACS].[JobCodeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[GACS].[JobCode] Gl1
		INNER JOIN (
			SELECT 
				JobCode,
				Source,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[GACS].[JobCode]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY JobCode,
				Source
		) t1 ON t1.JobCode = Gl1.JobCode AND
				t1.Source = Gl1.Source AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.JobCode,
				Gl1.Source
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[EntityTypeActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[EntityTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [Gdm].[EntityTypeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[EntityType] Gl1
		INNER JOIN (
			SELECT 
				EntityTypeId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[EntityType]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY EntityTypeId
		) t1 ON t1.EntityTypeId = Gl1.EntityTypeId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.EntityTypeId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[GlobalAllocationRegionMappingActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalAllocationRegionMappingActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [Gdm].[GlobalAllocationRegionMappingActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GlobalAllocationRegionMapping] Gl1
		INNER JOIN (
			SELECT 
				GlobalAllocationRegionMappingId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GlobalAllocationRegionMapping]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GlobalAllocationRegionMappingId
		) t1 ON t1.GlobalAllocationRegionMappingId = Gl1.GlobalAllocationRegionMappingId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GlobalAllocationRegionMappingId	

)
' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[GlobalRegionActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [Gdm].[GlobalRegionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GlobalRegion] Gl1
		INNER JOIN (
			SELECT 
				GlobalRegionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GlobalRegion]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GlobalRegionId
		) t1 ON t1.GlobalRegionId = Gl1.GlobalRegionId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GlobalRegionId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[GLMinorCategoryPayrollTypeActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLMinorCategoryPayrollTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
/*********************************************************************************************************************
Description
	This function returns the Import Keys of the active Gdm.GLMinorCategoryPayrollTypeActive records
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-09-08		: PKayongo	:	The function was created. 	
**********************************************************************************************************************/


CREATE FUNCTION [Gdm].[GLMinorCategoryPayrollTypeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GLMinorCategoryPayrollType] Gl1
		INNER JOIN (
			SELECT 
				GLMinorCategoryPayrollTypeId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GLMinorCategoryPayrollType]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GLMinorCategoryPayrollTypeId
		) t1 ON t1.GLMinorCategoryPayrollTypeId = Gl1.GLMinorCategoryPayrollTypeId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GLMinorCategoryPayrollTypeId
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[GLMinorCategoryActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLMinorCategoryActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gdm].[GLMinorCategoryActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GLMinorCategory] Gl1
		INNER JOIN (
			SELECT 
				GLMinorCategoryId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GLMinorCategory]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GLMinorCategoryId
		) t1 ON t1.GLMinorCategoryId = Gl1.GLMinorCategoryId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GLMinorCategoryId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[GLMajorCategoryActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLMajorCategoryActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gdm].[GLMajorCategoryActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GLMajorCategory] Gl1
		INNER JOIN (
			SELECT 
				GLMajorCategoryId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GLMajorCategory]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GLMajorCategoryId
		) t1 ON t1.GLMajorCategoryId = Gl1.GLMajorCategoryId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	Where Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GLMajorCategoryId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[GLGlobalAccountActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLGlobalAccountActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gdm].[GLGlobalAccountActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GLGlobalAccount] Gl1
		INNER JOIN (
			SELECT 
				GLGlobalAccountId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GLGlobalAccount]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GLGlobalAccountId
		) t1 ON t1.GLGlobalAccountId = Gl1.GLGlobalAccountId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GLGlobalAccountId
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[GLGlobalAccountCategorizationActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLGlobalAccountCategorizationActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

/*********************************************************************************************************************
Description
	This function returns the Import Keys of the active Gdm.GLGlobalAccountCategorization records
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-09-08		: PKayongo	:	The function was created. 	
**********************************************************************************************************************/


CREATE FUNCTION [Gdm].[GLGlobalAccountCategorizationActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GLGlobalAccountCategorization] Gl1
		INNER JOIN (
			SELECT 
				GLGlobalAccountId,
				GLCategorizationId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GLGlobalAccountCategorization]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				GLGlobalAccountId,
				GLCategorizationId
		) t1 ON 
			t1.GLGlobalAccountId = Gl1.GLGlobalAccountId AND
			t1.GLCategorizationId = Gl1.GLCategorizationId AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.GLGlobalAccountId,
		Gl1.GLCategorizationId
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[GLFinancialCategoryActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLFinancialCategoryActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
/*********************************************************************************************************************
Description
	This function returns the Import Keys of the active GL Financial Categories
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-09-08		: PKayongo	:	The function was created. 	
**********************************************************************************************************************/

CREATE FUNCTION [Gdm].[GLFinancialCategoryActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GLFinancialCategory] Gl1
		INNER JOIN (
			SELECT 
				GLFinancialCategoryId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GLFinancialCategory]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GLFinancialCategoryId
		) t1 ON t1.GLFinancialCategoryId = Gl1.GLFinancialCategoryId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GLFinancialCategoryId
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[GLCategorizationTypeActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLCategorizationTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

/*********************************************************************************************************************
Description
	This function returns the Import Keys of the active GLCategorizationTypes
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-09-08		: PKayongo	:	The function was created. 	
**********************************************************************************************************************/

CREATE FUNCTION [Gdm].[GLCategorizationTypeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GLCategorizationType] Gl1
		INNER JOIN (
			SELECT 
				GLCategorizationTypeId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GLCategorizationType]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GLCategorizationTypeId
		) t1 ON t1.GLCategorizationTypeId = Gl1.GLCategorizationTypeId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GLCategorizationTypeId
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[GLCategorizationActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLCategorizationActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
/*********************************************************************************************************************
Description
	This function returns the Import Keys of the active GLCategorizations
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-09-08		: PKayongo	:	The function was created. 	
**********************************************************************************************************************/

CREATE FUNCTION [Gdm].[GLCategorizationActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GLCategorization] Gl1
		INNER JOIN (
			SELECT 
				GLCategorizationId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GLCategorization]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GLCategorizationId
		) t1 ON t1.GLCategorizationId = Gl1.GLCategorizationId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GLCategorizationId
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[GLAccountActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLAccountActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
/*********************************************************************************************************************
Description
	This function returns the Import Keys of the active GLAccount records
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-09-08		: PKayongo	:	The function was created. 	
**********************************************************************************************************************/

CREATE FUNCTION [Gdm].[GLAccountActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GLAccount] Gl1
		INNER JOIN (
			SELECT 
				GLAccountId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GLAccount]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GLAccountId
		) t1 ON t1.GLAccountId = Gl1.GLAccountId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GLAccountId
)

' 
END
GO
/****** Object:  UserDefinedFunction [USProp].[GJobActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USProp].[GJobActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [USProp].[GJobActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
	[USProp].[GJob] Gl1
		INNER JOIN (
			SELECT 
				JOBCODE,
				MAX(LASTDATE) LASTDATE
			FROM 
				[USProp].[GJob]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY JOBCODE
		) t1 ON t1.JOBCODE = Gl1.JOBCODE AND
			    t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.JOBCODE	

)

' 
END
GO
/****** Object:  UserDefinedFunction [USCorp].[GJobActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USCorp].[GJobActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [USCorp].[GJobActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[USCorp].[GJob] Gl1
		INNER JOIN (
			SELECT 
				JOBCODE,
				MAX(LASTDATE) LASTDATE
			FROM 
					[USCorp].[GJob]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY JOBCODE
		) t1 ON t1.JOBCODE = Gl1.JOBCODE AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.JOBCODE	
)

' 
END
GO
/****** Object:  UserDefinedFunction [INCorp].[GJobActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INCorp].[GJobActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [INCorp].[GJobActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[INCorp].[GJob] Gl1
		INNER JOIN (
			SELECT 
				JOBCODE,
				MAX(LASTDATE) LASTDATE
			FROM 
				[INCorp].[GJob]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY JOBCODE
		) t1 ON t1.JOBCODE = Gl1.JOBCODE AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.JOBCODE	
)

' 
END
GO
/****** Object:  UserDefinedFunction [EUProp].[GJobActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUProp].[GJobActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [EUProp].[GJobActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[EUProp].[GJob] Gl1
		INNER JOIN (
			SELECT 
				JOBCODE,
				MAX(LASTDATE) LASTDATE
			FROM 
				[EUProp].[GJob]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY JOBCODE
		) t1 ON t1.JOBCODE = Gl1.JOBCODE AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.JOBCODE	
)

' 
END
GO
/****** Object:  UserDefinedFunction [EUCorp].[GJobActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUCorp].[GJobActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [EUCorp].[GJobActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[EUCorp].[GJob] Gl1
		INNER JOIN (
			SELECT 
				JOBCODE,
				MAX(LASTDATE) LASTDATE
			FROM 
				[EUCorp].[GJob]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY JOBCODE
		) t1 ON t1.JOBCODE = Gl1.JOBCODE AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.JOBCODE	
)

' 
END
GO
/****** Object:  UserDefinedFunction [CNProp].[GJobActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNProp].[GJobActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [CNProp].[GJobActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[CNProp].[GJob] Gl1
		INNER JOIN (
			SELECT 
				JOBCODE,
				MAX(LASTDATE) LASTDATE
			FROM 
				[CNProp].[GJob]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY JOBCODE
		) t1 ON t1.JOBCODE = Gl1.JOBCODE AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.JOBCODE	

)

' 
END
GO
/****** Object:  UserDefinedFunction [CNCorp].[GJobActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNCorp].[GJobActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [CNCorp].[GJobActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[CNCorp].[GJob] Gl1
		INNER JOIN (
			Select 
				JOBCODE,
				MAX(LASTDATE) LASTDATE
			From 
				[CNCorp].[GJob]
			Where	LASTDATE <= @DataPriorToDate
			Group By JOBCODE
		) t1 ON t1.JOBCODE = Gl1.JOBCODE AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.JOBCODE	
)

' 
END
GO
/****** Object:  UserDefinedFunction [BRCorp].[GJobActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRCorp].[GJobActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [BRCorp].[GJobActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[BRCorp].[GJob] Gl1
		INNER JOIN (
			SELECT 
				JOBCODE,
				MAX(LASTDATE) LASTDATE
			FROM 
				[BRCorp].[GJob]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY JOBCODE
		) t1 ON t1.JOBCODE = Gl1.JOBCODE AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.JOBCODE	
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[ConsolidationRegionPropertyEntityActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ConsolidationRegionPropertyEntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N' 
CREATE FUNCTION [Gdm].[ConsolidationRegionPropertyEntityActive]
	(@DatePriorToDate DATETIME)
	
RETURNS TABLE as RETURN
(
	SELECT
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].ConsolidationRegionPropertyEntity Gl1
		INNER JOIN (
			SELECT
				PropertyEntityCode,
				SourceCode,
				MAX(UpdatedDate) UpdatedDate
			FROM
				[Gdm].ConsolidationRegionPropertyEntity
			WHERE
				UpdatedDate <= @DatePriorToDate
			GROUP BY
				PropertyEntityCode,
				SourceCode
		) t1 ON 
			t1.PropertyEntityCode = Gl1.PropertyEntityCode AND
			t1.SourceCode = Gl1.SourceCode AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DatePriorToDate
	GROUP BY
		Gl1.PropertyEntityCode,
		Gl1.SourceCode
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[ConsolidationRegionCorporateDepartmentActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ConsolidationRegionCorporateDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N' 
 CREATE FUNCTION [Gdm].[ConsolidationRegionCorporateDepartmentActive]
	(@DatePriorToDate DATETIME)
	
RETURNS TABLE as RETURN
(
	SELECT
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].ConsolidationRegionCorporateDepartment Gl1
		INNER JOIN (
			SELECT
				CorporateDepartmentCode,
				SourceCode,
				MAX(UpdatedDate) UpdatedDate
			FROM
				[Gdm].ConsolidationRegionCorporateDepartment
			WHERE
				UpdatedDate <= @DatePriorToDate
			GROUP BY
				CorporateDepartmentCode,
				SourceCode
		) t1 ON 
			t1.CorporateDepartmentCode = Gl1.CorporateDepartmentCode AND
			t1.SourceCode = Gl1.SourceCode AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DatePriorToDate
	GROUP BY
		Gl1.CorporateDepartmentCode,
		Gl1.SourceCode
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[ConsolidationRegionActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ConsolidationRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gdm].[ConsolidationRegionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ConsolidationRegion] Gl1
		INNER JOIN (
			SELECT 
				ConsolidationRegionGlobalRegionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ConsolidationRegion]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY ConsolidationRegionGlobalRegionId
		) t1 ON t1.ConsolidationRegionGlobalRegionId = Gl1.ConsolidationRegionGlobalRegionId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.ConsolidationRegionGlobalRegionId
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[BusinessLineActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[BusinessLineActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

CREATE   FUNCTION [Gdm].[BusinessLineActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[BusinessLine] Gl1
		INNER JOIN (
			SELECT 
				BusinessLineId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[BusinessLine]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY BusinessLineId
		) t1 ON t1.BusinessLineId = Gl1.BusinessLineId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.BusinessLineId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetTaxTypeActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetTaxTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [TapasGlobalBudgeting].[BudgetTaxTypeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BudgetTaxType] B1

		INNER JOIN (
		
			SELECT 
				B2.BudgetTaxTypeId,
				MAX(B2.ImportBatchId) as ImportBatchId
			FROM 
				[TapasGlobalBudgeting].[BudgetTaxType] B2
				
				INNER JOIN Batch ON
					B2.ImportBatchId = batch.BatchId
					
			WHERE	
				batch.BatchEndDate IS NOT NULL AND
				batch.PackageName = ''ETL.Staging.TapasGlobalBudgeting'' AND
				batch.ImportEndDate <= @DataPriorToDate
					
			GROUP BY B2.BudgetTaxTypeId
			
		) t1 ON 
			t1.BudgetTaxTypeId = B1.BudgetTaxTypeId AND
			t1.ImportBatchId = B1.ImportBatchId
	
	GROUP BY B1.BudgetTaxTypeId
)

' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[BudgetsToProcessCurrent]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BudgetsToProcessCurrent]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

CREATE FUNCTION [dbo].[BudgetsToProcessCurrent]
	(@BudgetReforecastTypeName VARCHAR(25) = NULL) -- If NULL is passed then we will not restrict the result set based on BudgetReforecastTypeName
RETURNS TABLE AS RETURN
(
	SELECT
		BudgetsToProcessId,
		MAX(BatchId) AS CurrentBatchId,
		ImportBatchId,
		BudgetReforecastTypeName,
		BudgetId,
		BudgetExchangeRateId,
		BudgetReportGroupPeriodId,
		ImportBudgetFromSourceSystem,
		IsReforecast,
		BudgetYear,
		BudgetQuarter,
		SnapshotId,
		ImportSnapshotFromSourceSystem,
		InsertedDate,
		MustImportAllActualsIntoWarehouse,
		OriginalBudgetProcessedIntoWarehouse,
		ReforecastActualsProcessedIntoWarehouse,
		ReforecastBudgetsProcessedIntoWarehouse,
		ReasonForFailure,
		DateBudgetProcessedIntoWarehouse
	FROM
		dbo.BudgetsToProcess
	WHERE
		BudgetReforecastTypeName = (CASE WHEN @BudgetReforecastTypeName IS NULL THEN BudgetReforecastTypeName ELSE @BudgetReforecastTypeName END) AND
		DateBudgetProcessedIntoWarehouse IS NULL AND
		ReasonForFailure IS NULL AND
		OriginalBudgetProcessedIntoWarehouse IS NULL AND
		ReforecastActualsProcessedIntoWarehouse IS NULL AND
		ReforecastBudgetsProcessedIntoWarehouse IS NULL

	GROUP BY
		BudgetsToProcessId,
		ImportBatchId,
		BudgetReforecastTypeName,
		BudgetId,
		BudgetExchangeRateId,
		BudgetReportGroupPeriodId,
		ImportBudgetFromSourceSystem,
		IsReforecast,
		BudgetYear,
		BudgetQuarter,
		SnapshotId,
		ImportSnapshotFromSourceSystem,
		InsertedDate,
		MustImportAllActualsIntoWarehouse,
		OriginalBudgetProcessedIntoWarehouse,
		ReforecastActualsProcessedIntoWarehouse,
		ReforecastBudgetsProcessedIntoWarehouse,
		ReasonForFailure,
		DateBudgetProcessedIntoWarehouse

)


' 
END
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetStatusActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetStatusActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [TapasGlobalBudgeting].[BudgetStatusActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
	[TapasGlobalBudgeting].[BudgetStatus] B1
		INNER JOIN (
			SELECT 
				BudgetStatusId,
				MAX(InsertedDate) InsertedDate
			FROM 
				[TapasGlobalBudgeting].[BudgetStatus]
			WHERE	InsertedDate <= @DataPriorToDate
			GROUP BY BudgetStatusId
		) t1 ON t1.BudgetStatusId = B1.BudgetStatusId AND
				t1.InsertedDate = B1.InsertedDate
	WHERE B1.InsertedDate <= @DataPriorToDate
	GROUP BY B1.BudgetStatusId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[BudgetReportGroupPeriodActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[BudgetReportGroupPeriodActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gdm].[BudgetReportGroupPeriodActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[Gdm].[BudgetReportGroupPeriod] B1
		INNER JOIN (
			SELECT 
				BudgetReportGroupPeriodId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[BudgetReportGroupPeriod]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY BudgetReportGroupPeriodId
		) t1 ON t1.BudgetReportGroupPeriodId = B1.BudgetReportGroupPeriodId AND
				t1.UpdatedDate = B1.UpdatedDate
	WHERE B1.UpdatedDate <= @DataPriorToDate
	GROUP BY B1.BudgetReportGroupPeriodId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetReportGroupDetailActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetReportGroupDetailActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [TapasGlobalBudgeting].[BudgetReportGroupDetailActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BudgetReportGroupDetail] B1
		INNER JOIN (
			SELECT 
				BudgetReportGroupDetailId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobalBudgeting].[BudgetReportGroupDetail]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY BudgetReportGroupDetailId
		) t1 ON t1.BudgetReportGroupDetailId = B1.BudgetReportGroupDetailId AND
				t1.UpdatedDate = B1.UpdatedDate
	WHERE B1.UpdatedDate <= @DataPriorToDate
	GROUP BY B1.BudgetReportGroupDetailId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetReportGroupActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetReportGroupActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [TapasGlobalBudgeting].[BudgetReportGroupActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BudgetReportGroup] B1
		INNER JOIN (
			SELECT 
				BudgetReportGroupId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobalBudgeting].[BudgetReportGroup]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY BudgetReportGroupId
		) t1 ON t1.BudgetReportGroupId = B1.BudgetReportGroupId AND
				t1.UpdatedDate = B1.UpdatedDate
	WHERE B1.UpdatedDate <= @DataPriorToDate
	GROUP BY B1.BudgetReportGroupId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetProjectActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetProjectActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [TapasGlobalBudgeting].[BudgetProjectActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BudgetProject] B1

		INNER JOIN (
		
			SELECT 
				B2.BudgetProjectId,
				MAX(B2.ImportBatchId) as ImportBatchId
			FROM 
				[TapasGlobalBudgeting].[BudgetProject] B2
					
				INNER JOIN Batch ON
					B2.ImportBatchId = batch.BatchId
					
			WHERE	
				batch.BatchEndDate IS NOT NULL AND
				batch.PackageName = ''ETL.Staging.TapasGlobalBudgeting'' AND
				batch.ImportEndDate <= @DataPriorToDate
					
			GROUP BY B2.BudgetProjectId
			
		) t1 ON 
			t1.BudgetProjectId = B1.BudgetProjectId AND
			t1.ImportBatchId = B1.ImportBatchId
	
	GROUP BY B1.BudgetProjectId
)

' 
END
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetOverheadAllocationDetailActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetOverheadAllocationDetailActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [TapasGlobalBudgeting].[BudgetOverheadAllocationDetailActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BudgetOverheadAllocationDetail] B1

		INNER JOIN (
		
			SELECT 
				B2.BudgetOverheadAllocationDetailId,
				MAX(B2.ImportBatchId) as ImportBatchId
			FROM 
				[TapasGlobalBudgeting].[BudgetOverheadAllocationDetail] B2
				
				INNER JOIN Batch ON
					B2.ImportBatchId = batch.BatchId
					
			WHERE	
				batch.BatchEndDate IS NOT NULL AND
				batch.PackageName = ''ETL.Staging.TapasGlobalBudgeting'' AND
				batch.ImportEndDate <= @DataPriorToDate
					
			GROUP BY B2.BudgetOverheadAllocationDetailId
			
		) t1 ON 
			t1.BudgetOverheadAllocationDetailId = B1.BudgetOverheadAllocationDetailId AND
			t1.ImportBatchId = B1.ImportBatchId
	
	GROUP BY B1.BudgetOverheadAllocationDetailId
)

' 
END
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetOverheadAllocationActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetOverheadAllocationActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [TapasGlobalBudgeting].[BudgetOverheadAllocationActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BudgetOverheadAllocation] B1

		INNER JOIN (
		
			SELECT 
				B2.BudgetOverheadAllocationId,
				MAX(B2.ImportBatchId) as ImportBatchId
			FROM 
				[TapasGlobalBudgeting].[BudgetOverheadAllocation] B2
					
				INNER JOIN Batch ON
					B2.ImportBatchId = batch.BatchId
					
			WHERE	
				batch.BatchEndDate IS NOT NULL AND
				batch.PackageName = ''ETL.Staging.TapasGlobalBudgeting'' AND
				batch.ImportEndDate <= @DataPriorToDate
					
			GROUP BY B2.BudgetOverheadAllocationId
			
		) t1 ON 
			t1.BudgetOverheadAllocationId = B1.BudgetOverheadAllocationId AND
			t1.ImportBatchId = B1.ImportBatchId
	
	GROUP BY B1.BudgetOverheadAllocationId
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[BudgetExchangeRateDetailActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[BudgetExchangeRateDetailActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gdm].[BudgetExchangeRateDetailActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[Gdm].[BudgetExchangeRateDetail] B1
		INNER JOIN (
			SELECT 
				BudgetExchangeRateDetailId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[BudgetExchangeRateDetail]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY BudgetExchangeRateDetailId
		) t1 ON t1.BudgetExchangeRateDetailId = B1.BudgetExchangeRateDetailId AND
				t1.UpdatedDate = B1.UpdatedDate
	WHERE B1.UpdatedDate <= @DataPriorToDate
	GROUP BY B1.BudgetExchangeRateDetailId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[BudgetExchangeRateActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[BudgetExchangeRateActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gdm].[BudgetExchangeRateActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[Gdm].[BudgetExchangeRate] B1
		INNER JOIN (
			SELECT 
				BudgetExchangeRateId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[BudgetExchangeRate]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY BudgetExchangeRateId
		) t1 ON t1.BudgetExchangeRateId = B1.BudgetExchangeRateId AND
				t1.UpdatedDate = B1.UpdatedDate
	WHERE B1.UpdatedDate <= @DataPriorToDate
	GROUP BY B1.BudgetExchangeRateId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetailActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetailActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetailActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B1

		INNER JOIN (
		
			SELECT 
				B2.BudgetEmployeePayrollAllocationDetailId,
				MAX(B2.ImportBatchId) as ImportBatchId
			FROM 
				[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B2
					
				INNER JOIN Batch ON
					B2.ImportBatchId = batch.BatchId
					
			WHERE	
				batch.BatchEndDate IS NOT NULL AND
				batch.PackageName = ''ETL.Staging.TapasGlobalBudgeting'' AND
				batch.ImportEndDate <= @DataPriorToDate
					
			GROUP BY B2.BudgetEmployeePayrollAllocationDetailId
			
		) t1 ON 
			t1.BudgetEmployeePayrollAllocationDetailId = B1.BudgetEmployeePayrollAllocationDetailId AND
			t1.ImportBatchId = B1.ImportBatchId
	
	GROUP BY B1.BudgetEmployeePayrollAllocationDetailId
)

' 
END
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	Select 
		MAX(B1.ImportKey) ImportKey
	From
		[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocation] B1

		INNER JOIN (
		
			SELECT 
				B2.BudgetEmployeePayrollAllocationId,
				MAX(B2.ImportBatchId) as ImportBatchId
			FROM 
				[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocation] B2
					
				INNER JOIN Batch ON
					B2.ImportBatchId = batch.BatchId
					
			WHERE	
				batch.BatchEndDate IS NOT NULL AND
				batch.PackageName = ''ETL.Staging.TapasGlobalBudgeting'' AND
				batch.ImportEndDate <= @DataPriorToDate
					
			GROUP BY B2.BudgetEmployeePayrollAllocationId
			
		) t1 ON 
			t1.BudgetEmployeePayrollAllocationId = B1.BudgetEmployeePayrollAllocationId AND
			t1.ImportBatchId = B1.ImportBatchId
	
	GROUP BY B1.BudgetEmployeePayrollAllocationId
)

' 
END
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartmentActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartmentActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartment] B1

		INNER JOIN (
		
			SELECT 
				B2.BudgetEmployeeFunctionalDepartmentId,
				MAX(B2.ImportBatchId) as ImportBatchId
			FROM 
				[TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartment] B2
				
				INNER JOIN Batch ON
					B2.ImportBatchId = batch.BatchId
					
			WHERE	
				batch.BatchEndDate IS NOT NULL AND
				batch.PackageName = ''ETL.Staging.TapasGlobalBudgeting'' AND
				batch.ImportEndDate <= @DataPriorToDate
					
			GROUP BY B2.BudgetEmployeeFunctionalDepartmentId
			
		) t1 ON 
			t1.BudgetEmployeeFunctionalDepartmentId = B1.BudgetEmployeeFunctionalDepartmentId AND
			t1.ImportBatchId = B1.ImportBatchId
	
	GROUP BY B1.BudgetEmployeeFunctionalDepartmentId
)

' 
END
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetEmployeeActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [TapasGlobalBudgeting].[BudgetEmployeeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BudgetEmployee] B1

		INNER JOIN (
		
			SELECT 
				B2.BudgetEmployeeId,
				MAX(B2.ImportBatchId) as ImportBatchId
			FROM 
				[TapasGlobalBudgeting].[BudgetEmployee] B2
					
				INNER JOIN Batch ON
					B2.ImportBatchId = batch.BatchId
					
			WHERE	
				batch.BatchEndDate IS NOT NULL AND
				batch.PackageName = ''ETL.Staging.TapasGlobalBudgeting'' AND
				batch.ImportEndDate <= @DataPriorToDate
					
			GROUP BY B2.BudgetEmployeeId
		
		) t1 ON 
			t1.BudgetEmployeeId = B1.BudgetEmployeeId AND
			t1.ImportBatchId = B1.ImportBatchId
	
	GROUP BY B1.BudgetEmployeeId
)

' 
END
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [TapasGlobalBudgeting].[BudgetActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[Budget] B1
	
		INNER JOIN (
		
			SELECT 
				Budget.BudgetId,
				MAX(Budget.ImportBatchId) as ImportBatchId
			FROM 
				[TapasGlobalBudgeting].[Budget] budget
					
				INNER JOIN Batch ON
					Budget.ImportBatchId = batch.BatchId
					
			WHERE	
				batch.BatchEndDate IS NOT NULL AND
				batch.PackageName = ''ETL.Staging.TapasGlobalBudgeting'' AND
				batch.ImportEndDate <= @DataPriorToDate
					
			GROUP BY Budget.BudgetId
		
		) t1 ON 
			t1.BudgetId = B1.BudgetId AND
			t1.ImportBatchId = B1.ImportBatchId
	
	GROUP BY B1.BudgetId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[BillingUploadDetailActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[BillingUploadDetailActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [TapasGlobal].[BillingUploadDetailActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[BillingUploadDetail] Gl1
		INNER JOIN (
			SELECT 
				BillingUploadDetailId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobal].[BillingUploadDetail]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY BillingUploadDetailId
		) t1 ON t1.BillingUploadDetailId = Gl1.BillingUploadDetailId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.BillingUploadDetailId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[BillingUploadActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[BillingUploadActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [TapasGlobal].[BillingUploadActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[BillingUpload] Gl1
		INNER JOIN (
			SELECT 
				BillingUploadId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobal].[BillingUpload]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY BillingUploadId
		) t1 ON t1.BillingUploadId = Gl1.BillingUploadId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.BillingUploadId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BenefitOptionActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BenefitOptionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [TapasGlobalBudgeting].[BenefitOptionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BenefitOption] B1
		INNER JOIN (
		
			SELECT 
				BenefitOptionId,
				MAX(InsertedDate) InsertedDate
			FROM 
				[TapasGlobalBudgeting].[BenefitOption]
			WHERE	InsertedDate <= @DataPriorToDate
			GROUP BY BenefitOptionId
		
		) t1 ON t1.BenefitOptionId = B1.BenefitOptionId AND
				t1.InsertedDate = B1.InsertedDate
	WHERE B1.InsertedDate <= @DataPriorToDate
	GROUP BY B1.BenefitOptionId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[AllocationRegionActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[AllocationRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gdm].[AllocationRegionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[AllocationRegion] Gl1
		INNER JOIN (
			SELECT 
				Code,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[AllocationRegion]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				Code
		) t1 ON 
			t1.Code = Gl1.Code AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.Code
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[AllocationSubRegionActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[AllocationSubRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gdm].[AllocationSubRegionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[AllocationSubRegion] Gl1
		INNER JOIN (
			SELECT 
				Code,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[AllocationSubRegion]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				Code
		) t1 ON 
			t1.Code = Gl1.Code AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.Code
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[ActivityTypeBusinessLineActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ActivityTypeBusinessLineActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

CREATE   FUNCTION [Gdm].[ActivityTypeBusinessLineActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ActivityTypeBusinessLine] Gl1
		INNER JOIN (
			SELECT 
				ActivityTypeBusinessLineId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ActivityTypeBusinessLine]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY ActivityTypeBusinessLineId
		) t1 ON t1.ActivityTypeBusinessLineId = Gl1.ActivityTypeBusinessLineId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.ActivityTypeBusinessLineId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[ActivityTypeActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ActivityTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE   FUNCTION [Gdm].[ActivityTypeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ActivityType] Gl1
		INNER JOIN (
			SELECT 
				Code,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ActivityType]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				Code
		) t1 ON 
			t1.Code = Gl1.Code AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.Code	
)

' 
END
GO
/****** Object:  UserDefinedFunction [USProp].[GAccActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USProp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [USProp].[GAccActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
	[USProp].[GAcc] Gl1
		INNER JOIN (
			SELECT 
				ACCTNUM,
				MAX(LASTDATE) LASTDATE
			FROM 
				[USProp].[GAcc]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ACCTNUM
		) t1 ON t1.ACCTNUM = Gl1.ACCTNUM AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ACCTNUM	
)

' 
END
GO
/****** Object:  UserDefinedFunction [USCorp].[GAccActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USCorp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE   FUNCTION [USCorp].[GAccActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[USCorp].[GAcc] Gl1
		INNER JOIN (
			SELECT 
				ACCTNUM,
				MAX(LASTDATE) LASTDATE
			FROM 
				[USCorp].[GAcc]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ACCTNUM
		) t1 ON t1.ACCTNUM = Gl1.ACCTNUM AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ACCTNUM	
)

' 
END
GO
/****** Object:  UserDefinedFunction [INProp].[GAccActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INProp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [INProp].[GAccActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[INProp].[GAcc] Gl1
		INNER JOIN (
		SELECT 
				ACCTNUM,
				MAX(LASTDATE) LASTDATE
		FROM 
				[INProp].[GAcc]
		WHERE	LASTDATE <= @DataPriorToDate
		GROUP BY ACCTNUM
		) t1 ON t1.ACCTNUM = Gl1.ACCTNUM AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ACCTNUM	
)

' 
END
GO
/****** Object:  UserDefinedFunction [INCorp].[GAccActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INCorp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [INCorp].[GAccActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[INCorp].[GAcc] Gl1
		INNER JOIN (
			SELECT 
				ACCTNUM,
				MAX(LASTDATE) LASTDATE
			FROM 
				[INCorp].[GAcc]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ACCTNUM
		) t1 ON t1.ACCTNUM = Gl1.ACCTNUM AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ACCTNUM	
)

' 
END
GO
/****** Object:  UserDefinedFunction [EUProp].[GAccActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUProp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [EUProp].[GAccActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[EUProp].[GAcc] Gl1
		INNER JOIN (
			SELECT 
				ACCTNUM,
				MAX(LASTDATE) LASTDATE
			FROM 
				[EUProp].[GAcc]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ACCTNUM
		) t1 ON t1.ACCTNUM = Gl1.ACCTNUM AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ACCTNUM	
)

' 
END
GO
/****** Object:  UserDefinedFunction [EUCorp].[GAccActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUCorp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [EUCorp].[GAccActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[EUCorp].[GAcc] Gl1
		INNER JOIN (
			SELECT 
				ACCTNUM,
				MAX(LASTDATE) LASTDATE
			FROM 
				[EUCorp].[GAcc]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ACCTNUM
		) t1 ON t1.ACCTNUM = Gl1.ACCTNUM AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ACCTNUM	

)

' 
END
GO
/****** Object:  UserDefinedFunction [CNProp].[GAccActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNProp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [CNProp].[GAccActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[CNProp].[GAcc] Gl1
		INNER JOIN (
			SELECT 
				ACCTNUM,
				MAX(LASTDATE) LASTDATE
			FROM 
				[CNProp].[GAcc]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ACCTNUM
		) t1 ON t1.ACCTNUM = Gl1.ACCTNUM AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ACCTNUM	
)

' 
END
GO
/****** Object:  UserDefinedFunction [CNCorp].[GAccActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNCorp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [CNCorp].[GAccActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[CNCorp].[GAcc] Gl1
		INNER JOIN (
			SELECT 
				ACCTNUM,
				MAX(LASTDATE) LASTDATE
			FROM 
				[CNCorp].[GAcc]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ACCTNUM
		) t1 ON t1.ACCTNUM = Gl1.ACCTNUM AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ACCTNUM	
)

' 
END
GO
/****** Object:  UserDefinedFunction [BRProp].[GAccActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRProp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [BRProp].[GAccActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[BRProp].[GAcc] Gl1
		INNER JOIN (
			SELECT 
				ACCTNUM,
				MAX(LASTDATE) LASTDATE
			FROM 
				[BRProp].[GAcc]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ACCTNUM
		) t1 ON t1.ACCTNUM = Gl1.ACCTNUM AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ACCTNUM	
)

' 
END
GO
/****** Object:  UserDefinedFunction [BRCorp].[GAccActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRCorp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [BRCorp].[GAccActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[BRCorp].[GAcc] Gl1
		INNER JOIN (
			SELECT 
				ACCTNUM,
				MAX(LASTDATE) LASTDATE
			FROM 
				[BRCorp].[GAcc]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ACCTNUM
		) t1 ON t1.ACCTNUM = Gl1.ACCTNUM AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ACCTNUM	
)

' 
END
GO
/****** Object:  UserDefinedFunction [USProp].[EntityActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USProp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [USProp].[EntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[USProp].[Entity] Gl1
		INNER JOIN (
			SELECT 
					ENTITYID,
					MAX(LASTDATE) LASTDATE
			FROM 
					[USProp].[Entity]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ENTITYID
		) t1 ON t1.ENTITYID = Gl1.ENTITYID AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ENTITYID	
)

' 
END
GO
/****** Object:  UserDefinedFunction [USCorp].[EntityActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USCorp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE   FUNCTION [USCorp].[EntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[USCorp].[Entity] Gl1
		INNER JOIN (
			SELECT 
				ENTITYID,
				MAX(LASTDATE) LASTDATE
			FROM 
				[USCorp].[Entity]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ENTITYID
		) t1 ON t1.ENTITYID = Gl1.ENTITYID AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ENTITYID	
)

' 
END
GO
/****** Object:  UserDefinedFunction [INProp].[EntityActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INProp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [INProp].[EntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[INProp].[Entity] Gl1
		INNER JOIN (
			SELECT 
				ENTITYID,
				MAX(LASTDATE) LASTDATE
			FROM 
				[INProp].[Entity]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ENTITYID
		) t1 ON t1.ENTITYID = Gl1.ENTITYID AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ENTITYID	
)

' 
END
GO
/****** Object:  UserDefinedFunction [INCorp].[EntityActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INCorp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [INCorp].[EntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
	[INCorp].[Entity] Gl1
		INNER JOIN (
			SELECT 
				ENTITYID,
				MAX(LASTDATE) LASTDATE
			FROM 
				[INCorp].[Entity]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ENTITYID
		) t1 ON t1.ENTITYID = Gl1.ENTITYID AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ENTITYID	
)

' 
END
GO
/****** Object:  UserDefinedFunction [GACS].[EntityActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GACS].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [GACS].[EntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[GACS].[Entity] Gl1
		INNER JOIN (
		
			SELECT 
				EntityRef,
				Source,
				MAX(LastDate) AS LastDate
			FROM 
				[GACS].[Entity]
			WHERE	
				LastDate <= @DataPriorToDate
			GROUP BY 
				EntityRef,
				Source
			
		) t1 ON 
			t1.EntityRef = Gl1.EntityRef AND
			t1.Source = Gl1.Source AND
			t1.LastDate = Gl1.LastDate
	WHERE 
		Gl1.LastDate <= @DataPriorToDate
	GROUP BY 
		Gl1.EntityRef,
		Gl1.Source
)

' 
END
GO
/****** Object:  UserDefinedFunction [EUProp].[EntityActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUProp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [EUProp].[EntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[EUProp].[Entity] Gl1
		INNER JOIN (
			SELECT 
				ENTITYID,
				MAX(LASTDATE) LASTDATE
			FROM 
				[EUProp].[Entity]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ENTITYID
		) t1 ON t1.ENTITYID = Gl1.ENTITYID AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ENTITYID	
)

' 
END
GO
/****** Object:  UserDefinedFunction [EUCorp].[EntityActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUCorp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [EUCorp].[EntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[EUCorp].[Entity] Gl1
		INNER JOIN (
			SELECT 
				ENTITYID,
				MAX(LASTDATE) LASTDATE
			FROM 
				[EUCorp].[Entity]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ENTITYID
		) t1 ON t1.ENTITYID = Gl1.ENTITYID AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ENTITYID	
)

' 
END
GO
/****** Object:  UserDefinedFunction [CNProp].[EntityActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNProp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [CNProp].[EntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[CNProp].[Entity] Gl1
		INNER JOIN (
			SELECT 
				ENTITYID,
				MAX(LASTDATE) LASTDATE
			FROM 
				[CNProp].[Entity]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ENTITYID
		) t1 ON t1.ENTITYID = Gl1.ENTITYID AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ENTITYID
)

' 
END
GO
/****** Object:  UserDefinedFunction [CNCorp].[EntityActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNCorp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [CNCorp].[EntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[CNCorp].[Entity] Gl1
		INNER JOIN (
			SELECT 
				ENTITYID,
				MAX(LASTDATE) LASTDATE
			FROM 
				[CNCorp].[Entity]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ENTITYID
		) t1 ON t1.ENTITYID = Gl1.ENTITYID AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ENTITYID	
)

' 
END
GO
/****** Object:  UserDefinedFunction [BRProp].[EntityActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRProp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [BRProp].[EntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
	[BRProp].[Entity] Gl1
		INNER JOIN (
			SELECT 
				ENTITYID,
				MAX(LASTDATE) LASTDATE
			FROM 
				[BRProp].[Entity]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ENTITYID
		) t1 ON t1.ENTITYID = Gl1.ENTITYID AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ENTITYID	
)

' 
END
GO
/****** Object:  UserDefinedFunction [BRCorp].[EntityActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRCorp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [BRCorp].[EntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[BRCorp].[Entity] Gl1
		INNER JOIN (
			SELECT 
				ENTITYID,
				MAX(LASTDATE) LASTDATE
			FROM 
				[BRCorp].[Entity]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ENTITYID
		) t1 ON t1.ENTITYID = Gl1.ENTITYID AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ENTITYID	
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[DepartmentActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[DepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE   FUNCTION [Gdm].[DepartmentActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[Department] Gl1
		INNER JOIN (
			SELECT 
				DepartmentCode,
				[Source],
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[Department]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				DepartmentCode,
				[Source]
		) t1 ON 
			t1.DepartmentCode = Gl1.DepartmentCode AND
			t1.[Source] = Gl1.Source AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.DepartmentCode,
		Gl1.Source
)

' 
END
GO
/****** Object:  UserDefinedFunction [USProp].[GDepActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USProp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [USProp].[GDepActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
	[USProp].[GDep] Gl1
		INNER JOIN (
			SELECT 
				DEPARTMENT,
				MAX(LASTDATE) LASTDATE
			FROM 
				[USProp].[GDep]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY DEPARTMENT
		) t1 ON t1.DEPARTMENT = Gl1.DEPARTMENT AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.DEPARTMENT	
)

' 
END
GO
/****** Object:  UserDefinedFunction [USCorp].[GDepActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USCorp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [USCorp].[GDepActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[USCorp].[GDep] Gl1
		INNER JOIN (
			SELECT 
					DEPARTMENT,
					MAX(LASTDATE) LASTDATE
			FROM 
					[USCorp].[GDep]
			WHERE	LASTDATE <= @DataPriorToDate
		GROUP BY DEPARTMENT
		) t1 ON t1.DEPARTMENT = Gl1.DEPARTMENT AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.DEPARTMENT	
)

' 
END
GO
/****** Object:  UserDefinedFunction [INProp].[GDepActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INProp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [INProp].[GDepActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	From
		[INProp].[GDep] Gl1
		INNER JOIN (
			SELECT 
				DEPARTMENT,
				MAX(LASTDATE) LASTDATE
			FROM 
				[INProp].[GDep]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY DEPARTMENT
		) t1 ON t1.DEPARTMENT = Gl1.DEPARTMENT AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.DEPARTMENT	
)

' 
END
GO
/****** Object:  UserDefinedFunction [INCorp].[GDepActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INCorp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [INCorp].[GDepActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[INCorp].[GDep] Gl1
		INNER JOIN (
			SELECT 
				DEPARTMENT,
				MAX(LASTDATE) LASTDATE
			FROM 
				[INCorp].[GDep]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY DEPARTMENT
		) t1 ON t1.DEPARTMENT = Gl1.DEPARTMENT AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.DEPARTMENT	
)

' 
END
GO
/****** Object:  UserDefinedFunction [EUProp].[GDepActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUProp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [EUProp].[GDepActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[EUProp].[GDep] Gl1
		INNER JOIN (
			SELECT 
				DEPARTMENT,
				MAX(LASTDATE) LASTDATE
			FROM 
				[EUProp].[GDep]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY DEPARTMENT
		) t1 ON t1.DEPARTMENT = Gl1.DEPARTMENT AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.DEPARTMENT	
)

' 
END
GO
/****** Object:  UserDefinedFunction [EUCorp].[GDepActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUCorp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [EUCorp].[GDepActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[EUCorp].[GDep] Gl1
		INNER JOIN (
			SELECT 
				DEPARTMENT,
				MAX(LASTDATE) LASTDATE
			FROM 
				[EUCorp].[GDep]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY DEPARTMENT
		) t1 ON t1.DEPARTMENT = Gl1.DEPARTMENT AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.DEPARTMENT	
)

' 
END
GO
/****** Object:  UserDefinedFunction [CNProp].[GDepActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNProp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [CNProp].[GDepActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[CNProp].[GDep] Gl1
		INNER JOIN (
			SELECT 
				DEPARTMENT,
				MAX(LASTDATE) LASTDATE
			FROM 
				[CNProp].[GDep]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY DEPARTMENT
		) t1 ON t1.DEPARTMENT = Gl1.DEPARTMENT ANd
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.DEPARTMENT	
)

' 
END
GO
/****** Object:  UserDefinedFunction [CNCorp].[GDepActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNCorp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [CNCorp].[GDepActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[CNCorp].[GDep] Gl1
		INNER JOIN (
			SELECT 
				DEPARTMENT,
				MAX(LASTDATE) LASTDATE
			FROM 
				[CNCorp].[GDep]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY DEPARTMENT
		) t1 ON t1.DEPARTMENT = Gl1.DEPARTMENT AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.DEPARTMENT	
)

' 
END
GO
/****** Object:  UserDefinedFunction [BRProp].[GDepActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRProp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [BRProp].[GDepActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	Select 
		MAX(Gl1.ImportKey) ImportKey
	From
		[BRProp].[GDep] Gl1
		INNER JOIN (
			SELECT 
				DEPARTMENT,
				MAX(LASTDATE) LASTDATE
			FROM 
				[BRCorp].[GDep]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY DEPARTMENT
		) t1 ON t1.DEPARTMENT = Gl1.DEPARTMENT AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.DEPARTMENT	
)

' 
END
GO
/****** Object:  UserDefinedFunction [BRCorp].[GDepActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRCorp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE   FUNCTION [BRCorp].[GDepActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	Select 
		MAX(Gl1.ImportKey) ImportKey
	From
		[BRCorp].[GDep] Gl1
		INNER JOIN (
			SELECT 
				DEPARTMENT,
				MAX(LASTDATE) LASTDATE
			FROM 
				[BRCorp].[GDep]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY DEPARTMENT
		) t1 ON t1.DEPARTMENT = Gl1.DEPARTMENT AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.DEPARTMENT	
)

' 
END
GO
/****** Object:  UserDefinedFunction [HR].[FunctionalDepartmentActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[HR].[FunctionalDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE   FUNCTION [HR].[FunctionalDepartmentActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[HR].[FunctionalDepartment] Gl1
		INNER JOIN (
			SELECT 
				FunctionalDepartmentId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[HR].[FunctionalDepartment]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY FunctionalDepartmentId
		) t1 ON t1.FunctionalDepartmentId = Gl1.FunctionalDepartmentId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.FunctionalDepartmentId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gr].[GetSnapshotGlobalRegionExpanded]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetSnapshotGlobalRegionExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gr].[GetSnapshotGlobalRegionExpanded]()

RETURNS @Result TABLE
(
	GlobalRegionId INT NOT NULL,
	RegionCode VARCHAR(10) NOT NULL,
	RegionName VARCHAR(50) NOT NULL,
	RegionCountryId INT NULL,
	RegionDefaultCurrencyCode CHAR(3) NOT NULL,
	RegionDefaultCorporateSourceCode CHAR(2) NOT NULL,
	RegionProjectCodePortion CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsAllocationRegion BIT NOT NULL,
	IsOriginatingRegion BIT NOT NULL,
	SubRegionCode VARCHAR(10) NULL,
	SubRegionName VARCHAR(50) NULL,
	SubRegionDefaultCurrencyCode CHAR(3) NULL,
	SubRegionProjectCodePortion CHAR(2) NULL,
	IsActive BIT NOT NULL,
	SnapshotId INT NOT NULL
)
AS
BEGIN 

INSERT INTO @Result
SELECT
	SubRegion.GlobalRegionId,
	ParentRegion.Code AS RegionCode,
	ParentRegion.Name AS RegionName,
	ParentRegion.CountryId AS RegionCountryId,
	ParentRegion.DefaultCurrencyCode AS RegionDefaultCurrencyCode,
	ParentRegion.DefaultCorporateSourceCode AS RegionDefaultCorporateSourceCode,
	ParentRegion.ProjectCodePortion AS RegionProjectCodePortion,
	(	-- We will choose the InsertedDate of the record (ParentRegion or SubRegion) that was last inserted
		SELECT
			MAX(InsertedDate) AS InsertedDate
		FROM
			(
				SELECT ParentRegion.InsertedDate UNION
				SELECT SubRegion.InsertedDate
			) InsertedDates
	) AS InsertedDate,
	(	-- Again, we will choose the InsertedDate of the record (ParentRegion or SubRegion) that was last inserted
		SELECT
			MAX(UpdatedDate) AS UpdatedDate
		FROM
			(
				SELECT ParentRegion.UpdatedDate UNION
				SELECT SubRegion.UpdatedDate
			) UpdatedDates
	) AS UpdatedDate,
	SubRegion.IsAllocationRegion,
	SubRegion.IsOriginatingRegion,
	SubRegion.Code SubRegionCode,
	SubRegion.Name SubRegionName,
	SubRegion.DefaultCurrencyCode SubRegionDefaultCurrencyCode,
	SubRegion.ProjectCodePortion SubRegionProjectCodePortion,
	ParentRegion.IsActive & SubRegion.IsActive AS IsActive, -- If the Parent Region is not active, then its SubRegions should not be active either
	ParentRegion.SnapshotId
FROM
	Gdm.SnapshotGlobalRegion ParentRegion

	INNER JOIN Gdm.SnapshotGlobalRegion SubRegion ON
		SubRegion.ParentGlobalRegionId = ParentRegion.GlobalRegionId AND
		SubRegion.SnapshotId = ParentRegion.SnapshotId

UNION

SELECT
	ParentRegion.GlobalRegionId,
	ParentRegion.Code AS RegionCode,
	ParentRegion.[Name] AS RegionName,
	ParentRegion.CountryId AS RegionCountryId,
	ParentRegion.DefaultCurrencyCode AS RegionDefaultCurrencyCode,
	ParentRegion.DefaultCorporateSourceCode AS RegionDefaultCorporateSourceCode,
	ParentRegion.ProjectCodePortion AS RegionProjectCodePortion,
	ParentRegion.InsertedDate,
	ParentRegion.UpdatedDate,
	ParentRegion.IsAllocationRegion,
	ParentRegion.IsOriginatingRegion,
	NULL AS SubRegionCode,
	NULL AS SubRegionName,
	NULL AS SubRegionDefaultCurrencyCode,
	NULL AS SubRegionProjectCodePortion,
	ParentRegion.IsActive,
	ParentRegion.SnapshotId
FROM
	Gdm.SnapshotGlobalRegion ParentRegion
WHERE
	ParentRegion.ParentGlobalRegionId IS NULL AND -- Regions that do not have a parent region (i.e.: are parent regions themselves)
	ParentRegion.GlobalRegionId IN (SELECT -- Find all global regions that have a parent region (to make sure we don''t include parent regions that aren''t
										   --		references by sub regions)
										ParentGlobalRegionId
									FROM
										Gdm.SnapshotGlobalRegion
									WHERE
										ParentGlobalRegionId IS NOT NULL AND
										SnapshotId = ParentRegion.SnapshotId )

RETURN

END

' 
END
GO
/****** Object:  UserDefinedFunction [Gr].[GetSnapshotGlobalGlAccountCategoryTranslation]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetSnapshotGlobalGlAccountCategoryTranslation]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gr].[GetSnapshotGlobalGlAccountCategoryTranslation] ()

RETURNS @Result TABLE
(
	GlobalAccountCategoryCode varchar(33) NULL,
	TranslationTypeName varchar(50) NOT NULL,
	TranslationSubTypeName varchar(50) NOT NULL,
	GLMajorCategoryId int NOT NULL,
	GLMajorCategoryName varchar(50) NOT NULL,
	GLMinorCategoryId int NOT NULL,
	GLMinorCategoryName varchar(100) NOT NULL,
	FeeOrExpense varchar(7) NOT NULL,
	GLAccountSubTypeName varchar(50) NULL,
	SnapshotId INT NOT NULL,
	IsActive BIT NOT NULL
)
AS

BEGIN
	
	INSERT INTO @Result (
		GlobalAccountCategoryCode,
		TranslationTypeName,
		TranslationSubTypeName,
		GLMajorCategoryId,
		GLMajorCategoryName,
		GLMinorCategoryId,
		GLMinorCategoryName,
		FeeOrExpense,
		GLAccountSubTypeName,
		SnapshotId,
		IsActive
	)
	SELECT DISTINCT
		CONVERT(VARCHAR(32), LTRIM(STR(TT.GLTranslationTypeId, 10, 0)) + '':'' + 
			LTRIM(STR(TST.GLTranslationSubTypeId, 10, 0)) + '':'' + 
			LTRIM(STR(MajC.GLMajorCategoryId, 10, 0)) + '':'' + 
			LTRIM(STR(MinC.GLMinorCategoryId, 10, 0)) + '':'' + 
			LTRIM(STR(AT.GLAccountTypeId, 10, 0)) + '':'' + 
			LTRIM(STR(AST.GLAccountSubTypeId, 10, 0))) GlobalAccountCategoryCode,
		TT.Name TranslationTypeName,
		TST.Name TranslationSubTypeName,
		MajC.GLMajorCategoryId,
		MajC.Name GLMajorCategoryName,
		MinC.GLMinorCategoryId,
		MinC.Name GLMinorCategoryName,
		CASE WHEN AT.Code LIKE ''%EXP%'' THEN ''EXPENSE'' 
			WHEN AT.Code LIKE ''%INC%'' THEN ''INCOME''
			ELSE ''UNKNOWN'' END as FeeOrExpense,		-- sourced from Gdm.GlobalGlAccountCategoryHierarchy.AccountType
		AST.Name GLAccountSubTypeName,				-- used to be ExpenseType, sourced from Gdm.GlobalGlAccountCategoryHierarchy.ExpenseType
		TST.SnapshotId, -- shouldn''t matter which table we source the SnapshotId from - it should form part of all join criteria
		CONVERT(BIT, TST.IsActive & TT.IsActive & MajC.IsActive & MinC.IsActive & AT.IsActive & AST.IsActive) AS IsActive
	FROM
		Gdm.SnapshotGLTranslationSubType TST
		
		INNER JOIN Gdm.SnapshotGLGlobalAccountTranslationSubType GLATST ON
			TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
			TST.SnapshotId = GLATST.SnapshotId				
			
		INNER JOIN Gdm.SnapshotGLGlobalAccountTranslationType GLATT ON
			GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
			GLATST.SnapshotId = GLATT.SnapshotId AND
			TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
			TST.SnapshotId = GLATT.SnapshotId
					
		INNER JOIN Gdm.SnapshotGLTranslationType TT ON
			GLATT.GLTranslationTypeId = TT.GLTranslationTypeId AND
			GLATT.SnapshotId = TT.SnapshotId
	
		INNER JOIN Gdm.SnapshotGLGlobalAccount GLA ON
			GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId	AND
			GLATT.SnapshotId = GLA.SnapshotId
		
		INNER JOIN Gdm.SnapshotGLMinorCategory MinC ON
			GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
			GLATST.SnapshotId = MinC.SnapshotId

		INNER JOIN Gdm.SnapshotGLMajorCategory MajC ON
			MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
			MinC.SnapshotId = MajC.SnapshotId

		INNER JOIN Gdm.SnapshotGLAccountSubType AST ON
			GLATT.GLAccountSubTypeId = AST.GLAccountSubTypeId AND
			GLATT.SnapshotId = AST.SnapshotId
			
		INNER JOIN Gdm.SnapshotGLAccountType AT ON
			GLATT.GLAccountTypeId = AT.GLAccountTypeId AND
			GLATT.SnapshotId = AT.SnapshotId
	WHERE
		TST.IsGRDefault = 1


/*	-- When using unknown values in the dimension tables, both actuals and snapshot records that are to be inserted into the fact tables will use
    -- the ACTUAL unknowns (with snapshotId = 0). At present it doesn''t make sense to have unknowns for actuals, and for every snapshot that is
    -- represented in the dimensions. When an unknown record is needed, there will only be one version in the dimension - this will be sourced
    -- from the actuals - this is why the code below is commented: we don''t need unknowns for snapshots, as the actual unknowns will be used.
	UNION
	
	SELECT
		LTRIM(STR(TT.GLTranslationTypeId, 10, 0)) + '':'' + LTRIM(STR(TST.GLTranslationSubTypeId, 10, 0)) + '':-1:-1:-1:-1'',
		TT.Name TranslationTypeName,
		TST.Name TranslationSubTypeName,
		-1,
		''UNKNOWN'',
		-1,
		''UNKNOWN'',
		''UNKNOWN'',
		''UNKNOWN'',
		''1900-01-01'',
		''1900-01-01'',
		TT.SnapshotId
		
	FROM
	
		(
			SELECT
				TT.*
			FROM
				Gdm.SnapshotGLTranslationType TT
			INNER JOIN
					Gdm.GLTranslationTypeActive(@DataPriorToDate) TTA
					ON TTA.ImportKey = TT.ImportKey
		) TT
	
		INNER JOIN (
			SELECT
				TST.*
			FROM
				Gdm.SnapshotGLTranslationSubType TST
				INNER JOIN
					Gdm.GLTranslationSubTypeActive(@DataPriorToDate) TSTA 
					ON TSTA.ImportKey = TST.ImportKey
		) TST ON
			TT.GLTranslationTypeId = TST.GLTranslationTypeId AND
			TT.SnapshotId = TST.SnapshotId
*/	
	DECLARE @Temp TABLE
	(
		GlobalAccountCategoryCode varchar(33) NULL,
		TranslationTypeName varchar(50) NOT NULL,
		TranslationSubTypeName varchar(50) NOT NULL,
		GLMajorCategoryId int NOT NULL,
		GLMajorCategoryName varchar(50) NOT NULL,
		GLMinorCategoryId int NOT NULL,
		GLMinorCategoryName varchar(100) NOT NULL,
		FeeOrExpense varchar(7) NOT NULL,
		GLAccountSubTypeName varchar(50) NULL,
		SnapshotId INT NOT NULL,
		IsActive BIT NOT NULL
	)
	
		
	--Now add the virtual rows, for each Major&Minor combination, we need to have a copy combination, but the
	--GLAccountSubType must be Overhead instead of the original GLAccountSubType
	INSERT INTO @Temp
	(
		GlobalAccountCategoryCode,
		TranslationTypeName,
		TranslationSubTypeName,
		GLMajorCategoryId,
		GLMajorCategoryName,
		GLMinorCategoryId,
		GLMinorCategoryName,
		FeeOrExpense,
		GLAccountSubTypeName,
		SnapshotId,
		IsActive
	)
	SELECT DISTINCT
		REVERSE(SUBSTRING(REVERSE(GlobalAccountCategoryCode), patindex(''%:%'',REVERSE(GlobalAccountCategoryCode)), LEN(GlobalAccountCategoryCode)))+
			(SELECT LTRIM(STR(GLAccountSubTypeId,10,0)) FROM Gdm.SnapshotGLAccountSubType WHERE Code = ''GRPOHD'' AND SnapshotId = Result.SnapshotId) AS GlobalAccountCategoryCode,
		Result.TranslationTypeName,
		Result.TranslationSubTypeName,
		Result.GLMajorCategoryId,
		Result.GLMajorCategoryName,
		Result.GLMinorCategoryId,
		Result.GLMinorCategoryName,
		Result.FeeOrExpense,
		(SELECT Name FROM Gdm.SnapshotGLAccountSubType Where Code = ''GRPOHD'' AND SnapshotId = Result.SnapshotId),
		Result.SnapshotId,
		IsActive
	FROM
		@Result Result
			
	INSERT INTO @Result
	(
		GlobalAccountCategoryCode,
		TranslationTypeName,
		TranslationSubTypeName,
		GLMajorCategoryId,
		GLMajorCategoryName,
		GLMinorCategoryId,
		GLMinorCategoryName,
		FeeOrExpense,
		GLAccountSubTypeName,
		SnapshotId,
		IsActive
	)
	SELECT DISTINCT
		t1.GlobalAccountCategoryCode,
		t1.TranslationTypeName,
		t1.TranslationSubTypeName,
		t1.GLMajorCategoryId,
		t1.GLMajorCategoryName,
		t1.GLMinorCategoryId,
		t1.GLMinorCategoryName,
		t1.FeeOrExpense,
		t1.GLAccountSubTypeName,
		t1.SnapshotId,
		t1.IsActive
	FROM
		@Temp t1
		LEFT OUTER JOIN @Result t2 ON
			t1.GlobalAccountCategoryCode = t2.GlobalAccountCategoryCode AND
			t1.SnapshotId = t2.SnapshotId
	WHERE
		t2.GlobalAccountCategoryCode IS NULL
		
	RETURN 
END

' 
END
GO
/****** Object:  UserDefinedFunction [Gr].[GetSnapshotGLCategorizationHierarchyExpanded]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetSnapshotGLCategorizationHierarchyExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gr].[GetSnapshotGLCategorizationHierarchyExpanded]()

RETURNS @GLAccountCategories TABLE
(
	GLCategorizationHierarchyCode VARCHAR(32) NULL,
	GLCategorizationTypeName VARCHAR(50) NOT NULL,
	GLCategorizationName VARCHAR(50) NOT NULL,
	GLFinancialCategoryName VARCHAR(50) NOT NULL,
	InflowOutflow VARCHAR(7) NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	GLMajorCategoryName VARCHAR(400) NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLMinorCategoryName VARCHAR(400) NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLGlobalAccountName VARCHAR(150) NOT NULL,
	GLGlobalAccountCode VARCHAR(10) NOT NULL,
	SnapshotId INT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)
AS

BEGIN
	-- The purpose of this table is to combine the columns of DirectGLMinorCategoryId, IndirectGLMinorCategoryId and CoAGLMinorCategoryId
	DECLARE @GLGlobalAccountCategorization TABLE 
	(
		SnapshotId INT NOT NULL,
		GLCategorizationId INT NOT NULL,
		GLMinorCategoryId INT NOT NULL,
		GLGlobalAccountId INT NOT NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL
	)
	INSERT INTO @GLGlobalAccountCategorization(
		SnapshotId,
		GLCategorizationId,
		GLMinorCategoryId,
		GLGlobalAccountId,
		InsertedDate,
		UpdatedDate
	)
	SELECT
		GGAC.SnapshotId,
		GGAC.GLCategorizationId,
		GGAC.DirectGLMinorCategoryId AS GLMinorCategoryId,
		GGAC.GLGlobalAccountId,
		GGAC.InsertedDate,
		GGAC.UpdatedDate
	FROM
		Gdm.SnapshotGLGlobalAccountCategorization GGAC 
	WHERE
		GGAC.DirectGLMinorCategoryId IS NOT NULL
	
	UNION
	
	SELECT
		GGAC.SnapshotId,
		GGAC.GLCategorizationId,
		GGAC.IndirectGLMinorCategoryId AS GLMinorCategoryId,
		GLGlobalAccountId,
		InsertedDate,
		UpdatedDate
	FROM
		Gdm.SnapshotGLGlobalAccountCategorization GGAC 
	WHERE
		GGAC.IndirectGLMinorCategoryId IS NOT NULL
	UNION
	
	SELECT
		GGAC.SnapshotId,
		GGAC.GLCategorizationId,
		GGAC.CoAGLMinorCategoryId AS GLMinorCategoryId,
		GGAC.GLGlobalAccountId,
		GGAC.InsertedDate,
		GGAC.UpdatedDate
	FROM
		Gdm.SnapshotGLGlobalAccountCategorization GGAC 
	WHERE
		GGAC.CoAGLMinorCategoryId IS NOT NULL

	INSERT INTO @GLAccountCategories
	(
		GLCategorizationHierarchyCode,
		GLCategorizationTypeName,
		GLCategorizationName,
		GLFinancialCategoryName,
		InflowOutflow,
		GLMajorCategoryId,
		GLMajorCategoryName,
		GLMinorCategoryId,
		GLMinorCategoryName,
		GLGlobalAccountId,
		GLGlobalAccountName,
		GLGlobalAccountCode,
		SnapshotId,
		IsActive,
		InsertedDate,
		UpdatedDate
	)
	/* ===========================================================================================================================================
		Records are created for each GL Global Account with unknown Categorization information (Major Account, Minor Account and Financial
			Category). This is to ensure that if the Categorization cannot be mapped, there will be a record available to map a transaction to
			which shows that the GL Global Account is known, but the Categorization information is unknown.
	   ======================================================================================================================================== */
	SELECT
		''-1:-1:-1:-1:-1:'' + LTRIM(STR(GLA.GLGlobalAccountId, 10, 0)),
		''UNKNOWN'',
		''UNKNOWN'',
		''UNKNOWN'',
		''UNKNOWN'',
		-1,
		''UNKNOWN'',
		-1,
		''UNKNOWN'',
		GLA.GLGlobalAccountId,
		GLA.Name,
		GLA.Code,
		GLA.SnapshotId,
		GLA.IsActive,
		GLA.InsertedDate,
		GLA.UpdatedDate
	FROM
		(
			SELECT
				GLA.GLGlobalAccountId,
				GLA.Name,
				GLA.Code,
				GLA.IsActive,
				GLA.InsertedDate,
				GLA.UpdatedDate,
				GLA.SnapshotId
			FROM
				Gdm.SnapshotGLGlobalAccount GLA
	
		) GLA
		
	UNION
		
	SELECT
		CONVERT(VARCHAR(10), GLA.GLCategorizationTypeId) + '':'' +
			CONVERT(VARCHAR(10), GLA.GLCategorizationId) + 
			'':-1:-1:-1:'' + LTRIM(STR(GLA.GLGlobalAccountId, 10, 0)),
		GLA.GLCategorizationTypeName,
		GLA.GLCategorizationName,
		''UNKNOWN'',
		''UNKNOWN'',
		-1,
		''UNKNOWN'',
		-1,
		''UNKNOWN'',
		GLA.GLGlobalAccountId,
		GLA.Name,
		GLA.Code,
		GLA.SnapshotId,
		GLA.IsActive,
		GLA.InsertedDate,
		GLA.UpdatedDate
	FROM
		(
			SELECT
				GLA.GLGlobalAccountId,
				GCT.GLCategorizationTypeId,
				GCT.Name AS GLCategorizationTypeName,
				GC.GLCategorizationId,
				GC.Name AS GLCategorizationName,
				GLA.Name,
				GLA.Code,
				GLA.IsActive,
				GLA.InsertedDate,
				GLA.UpdatedDate,
				GLA.SnapshotId
			FROM
				Gdm.SnapshotGLGlobalAccount GLA
					
				LEFT OUTER JOIN Gdm.SnapshotGLCategorization GC ON
					GLA.SnapshotId = GC.SnapshotId -- Joins onto itself. Has the same effect as a cross join.
					
				INNER JOIN Gdm.SnapshotGLCategorizationType GCT ON
					GC.GLCategorizationTypeId = GCT.GLCategorizationTypeId AND
					GC.SnapshotId = GCT.SnapshotId
				
		) GLA

	UNION

	/* ===========================================================================================================================================
		The Categorization information for each mapped GL Global Account is mapped below. This includes Direct, Indirect and CoA mappings.
	   ========================================================================================================================================= */
	
	SELECT
		CONVERT(VARCHAR(32),
			LTRIM(STR(GCT.GLCategorizationTypeId, 10, 0)) + '':'' + 
			LTRIM(STR(GC.GLCategorizationId, 10, 0)) + '':'' +
			LTRIM(STR(GFC.GLFinancialCategoryId, 10, 0)) + '':'' +
			LTRIM(STR(MajC.GLMajorCategoryId, 10, 0)) + '':'' + 
			LTRIM(STR(MinC.GLMinorCategoryId, 10, 0)) + '':'' +
			LTRIM(STR(GGA.GLGlobalAccountId, 10, 0))) AS GlobalAccountCategoryCode,
		GCT.Name AS GLCategorizationTypeName,
		GC.Name AS GLCategorizationName,
		GFC.Name AS GLFinancialCategoryName,
		GFC.InflowOutflow,
		MajC.GLMajorCategoryId,
		MajC.Name AS GLMajorCategoryName,
		MinC.GLMinorCategoryId,
		MinC.Name AS GLMinorCategoryName,
		GGA.GLGlobalAccountId,
		GGA.Name,
		GGA.Code,
		GCT.SnapshotId,
		GCT.IsActive & GC.IsActive & MajC.IsActive & MinC.IsActive & GGA.IsActive AS IsActive,
		(	-- Select the highest Inserted Date from all the tables used
			SELECT TOP 1
				MAX(Dates.InsertedDate)
			FROM
			(
				SELECT GCT.InsertedDate UNION
				SELECT GC.InsertedDate UNION
				SELECT GFC.InsertedDate UNION
				SELECT MajC.InsertedDate UNION
				SELECT MinC.InsertedDate UNION
				SELECT GGAC.InsertedDate UNION
				SELECT GGA.InsertedDate
			) Dates
		) InsertedDate,
		(	-- Select the highest Updated Date from all the tables used
			SELECT TOP 1
				MAX(Dates.UpdatedDate)
			FROM
			(
				SELECT GC.UpdatedDate UNION
				SELECT GCT.UpdatedDate UNION
				SELECT GFC.UpdatedDate UNION
				SELECT MajC.UpdatedDate UNION
				SELECT MinC.UpdatedDate UNION
				SELECT GGAC.UpdatedDate UNION
				SELECT GGA.UpdatedDate
			) Dates
		) UpdatedDate
	FROM
		Gdm.SnapshotGLCategorizationType GCT

		INNER JOIN Gdm.SnapshotGLCategorization GC ON
			GCT.GLCategorizationTypeId = GC.GLCategorizationTypeId AND
			GCT.SnapshotId = GC.SnapshotId

		INNER JOIN @GLGlobalAccountCategorization GGAC ON -- This combines Indirect, Direct and CoA mappings into one field.
			GGAC.GLCategorizationId = GC.GLCategorizationId AND
			GGAC.SnapshotId = GC.SnapshotId

		INNER JOIN Gdm.SnapshotGLGlobalAccount GGA ON
			GGA.GLGlobalAccountId = GGAC.GLGlobalAccountId AND
			GGA.SnapshotId = GGAC.SnapshotId

		INNER JOIN Gdm.SnapshotGLMinorCategory MinC ON
			MinC.GLMinorCategoryId = GGAC.GLMinorCategoryId AND
			MinC.SnapshotId = GGAC.SnapshotId

		INNER JOIN Gdm.SnapshotGLMajorCategory MajC ON
			MajC.GLMajorCategoryId = MinC.GLMajorCategoryID AND
			MajC.SnapshotId = MinC.SnapshotId

		INNER JOIN Gdm.SnapshotGLFinancialCategory GFC ON
			GFC.GLFinancialCategoryId = MajC.GLFinancialCategoryId AND
			GFC.SnapshotId = MajC.SnapshotId

	UNION

	/* ===========================================================================================================================================
		Payroll data from Tapas Global Budgeting doesn''t use GL Accounts. The portion below gets the Categorization mappings for payroll data and
			sets the GL Global Account information to ''N/A''.
	   ========================================================================================================================================= */
	
	SELECT
		CONVERT(VARCHAR(32),
			LTRIM(STR(GCT.GLCategorizationTypeId, 10, 0)) + '':'' + 
			LTRIM(STR(GC.GLCategorizationId, 10, 0)) + '':'' +
			LTRIM(STR(GFC.GLFinancialCategoryId, 10, 0)) + '':'' +
			LTRIM(STR(MajC.GLMajorCategoryId, 10, 0)) + '':'' + 
			LTRIM(STR(MinC.GLMinorCategoryId, 10, 0)) + '':0'') GlobalAccountCategoryCode, -- Global Account Id is set to 0
		GCT.Name,					-- GLCategorizationTypeName,
		GC.Name,					-- GLCategorizationName,
		GFC.Name,					-- GLFinancialCategoryName,
		GFC.InflowOutflow,
		MajC.GLMajorCategoryId,
		MajC.Name,					-- GLMajorCategoryName,
		MinC.GLMinorCategoryId, 
		MinC.Name,					--GLMinorCategoryName,
		0,
		''N/A'',						-- GL Account Name
		''N/A'',						-- GL Account Code
		MinC.SnapshotId,
		GCT.IsActive & GC.IsActive & MinC.IsActive & MajC.IsActive AS IsActive,
		(	-- Select the highest Inserted Date from all the tables used
			SELECT
				MAX(InsertedDates.InsertedDate)
			FROM
				(
					SELECT GCT.InsertedDate UNION
					SELECT GC.InsertedDate UNION
					SELECT GFC.InsertedDate UNION
					SELECT MajC.InsertedDate UNION
					SELECT MinC.InsertedDate
				) InsertedDates
		) AS InsertedDate,
		(	-- Select the highest Updated Date from all the tables used
			SELECT
				MAX(UpdatedDates.UpdatedDate)
			FROM
				(
					SELECT GCT.UpdatedDate UNION
					SELECT GC.UpdatedDate UNION
					SELECT GFC.UpdatedDate UNION
					SELECT MajC.UpdatedDate UNION
					SELECT MinC.UpdatedDate
				) UpdatedDates
		) AS UpdatedDate
	FROM
		Gdm.SnapshotGLMinorCategory MinC

		INNER JOIN Gdm.SnapshotGLMajorCategory MajC ON
			MajC.GLMajorCategoryId = MinC.GLMajorCategoryID AND
			MajC.SnapshotId = MinC.SnapshotId AND
			MajC.Name = ''Salaries/Taxes/Benefits'' -- Limits this to Payroll information.

		INNER JOIN Gdm.SnapshotGLFinancialCategory GFC ON
			GFC.GLFinancialCategoryId = MajC.GLFinancialCategoryId AND
			GFC.SnapshotId = MajC.SnapshotId 

		INNER JOIN Gdm.SnapshotGLCategorization GC ON
			GFC.GLCategorizationId = GC.GLCategorizationId AND
			GFC.SnapshotId = GC.SnapshotId

		INNER JOIN Gdm.SnapshotGLCategorizationType GCT ON
			GCT.GLCategorizationTypeId = GC.GLCategorizationTypeId AND
			GCT.SnapshotId = GC.SnapshotId

RETURN

END

' 
END
GO
/****** Object:  UserDefinedFunction [Gr].[GetSnapshotActivityTypeBusinessLineExpanded]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetSnapshotActivityTypeBusinessLineExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

CREATE FUNCTION [Gr].[GetSnapshotActivityTypeBusinessLineExpanded] 
	()
RETURNS @Result TABLE (
	ActivityTypeId INT NOT NULL,
	ActivityTypeName VARCHAR(50) NOT NULL,
	ActivityTypeCode VARCHAR(50) NOT NULL,
	BusinessLineId INT NOT NULL,
	BusinessLineName VARCHAR(50) NOT NULL,
	SnapshotId INT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsActive BIT NOT NULL
)
AS
BEGIN 

INSERT INTO @Result
SELECT
	ActivityType.ActivityTypeId,
	ActivityType.Name,
	ActivityType.Code,
	BusinessLine.BusinessLineId,
	BusinessLine.Name,
	ActivityTypeBusinessLine.SnapshotId,
	ActivityTypeBusinessLine.InsertedDate, /* The records that are returned by this function are a combination of Activity Type and Business Line
													records, with the ActivityTypeBusinessLine table being used to store these associations. The
													InsertedDate of this record is set to ActivityTypeBusinessLine.InsertedDate because that is
													when the combination that this record represents came into existence. Both the ActivityType
													and BusinessLine records might have existed long before the ActivityTypeBusinessLine record
													was created to unite them. This is why the InsertedDate fields of the ActivityType and
													BusinessLine records are not used. */
	(	/* The UpdatedDate of the record (either ActivityType, BusinessLine, or ActivityTypeBusinessLine) that was last updated will be used as
				the UpdatedDate that is returned for this record. */
		SELECT
			MAX(UpdatedDate)
		FROM
			(
				SELECT ActivityType.UpdatedDate UNION
				SELECT BusinessLine.UpdatedDate UNION
				SELECT ActivityTypeBusinessLine.UpdatedDate
			) UpdatedDates
	) AS UpdatedDate,
	CONVERT(BIT, (ActivityTypeBusinessLine.IsActive & ActivityType.IsActive & BusinessLine.IsActive)) AS IsActive
FROM
	Gdm.SnapshotActivityTypeBusinessLine ActivityTypeBusinessLine
			
	INNER JOIN Gdm.SnapshotActivityType ActivityType ON
		ActivityTypeBusinessLine.ActivityTypeId = ActivityType.ActivityTypeId AND
		ActivityTypeBusinessLine.SnapshotId = ActivityType.SnapshotId

	INNER JOIN Gdm.SnapshotBusinessLine BusinessLine ON
		ActivityTypeBusinessLine.BusinessLineId = BusinessLine.BusinessLineId AND
		ActivityTypeBusinessLine.SnapshotId = BusinessLine.SnapshotId

RETURN
END

' 
END
GO
/****** Object:  UserDefinedFunction [GACS].[EntityMappingActive]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GACS].[EntityMappingActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [GACS].[EntityMappingActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[GACS].[EntityMapping] Gl1
		INNER JOIN (
		
			SELECT 
				EntityMappingId,
				MAX(InsertedDate) InsertedDate
			FROM 
				[GACS].[EntityMapping]
			WHERE	InsertedDate <= @DataPriorToDate
			GROUP BY EntityMappingId
			
		) t1 ON t1.EntityMappingId = Gl1.EntityMappingId AND
				t1.InsertedDate = Gl1.InsertedDate
	WHERE Gl1.InsertedDate <= @DataPriorToDate
	GROUP BY Gl1.EntityMappingId
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[ConsolidationSubRegionActive]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ConsolidationSubRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gdm].[ConsolidationSubRegionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ConsolidationSubRegion] Gl1
		INNER JOIN (
			SELECT 
				ConsolidationSubRegionGlobalRegionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ConsolidationSubRegion]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY ConsolidationSubRegionGlobalRegionId
		) t1 ON t1.ConsolidationSubRegionGlobalRegionId = Gl1.ConsolidationSubRegionGlobalRegionId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.ConsolidationSubRegionGlobalRegionId
)

' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetGreatest]    Script Date: 02/24/2012 10:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetGreatest]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[GetGreatest] (@str varchar(1024))
	
RETURNS varchar(100) 


AS 
BEGIN	
	DECLARE @item varchar(100)
	SET @item = (SELECT MAX(item) FROM dbo.GetSplit(@str))

	RETURN @item
END
' 
END
GO
/****** Object:  UserDefinedFunction [Gr].[GetGlobalRegionExpanded]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetGlobalRegionExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gr].[GetGlobalRegionExpanded]
	(@DataPriorToDate DATETIME)
	
RETURNS @Result TABLE
(
	GlobalRegionId INT NOT NULL,
	RegionCode VARCHAR(10) NOT NULL,
	RegionName VARCHAR(50) NOT NULL,
	RegionCountryId INT NULL,
	RegionDefaultCurrencyCode CHAR(3) NOT NULL,
	RegionDefaultCorporateSourceCode CHAR(2) NOT NULL,
	RegionProjectCodePortion CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsAllocationRegion BIT NOT NULL,
	IsOriginatingRegion BIT NOT NULL,
	SubRegionCode VARCHAR(10) NULL,
	SubRegionName VARCHAR(50) NULL,
	SubRegionDefaultCurrencyCode CHAR(3) NULL,
	SubRegionProjectCodePortion CHAR(2) NULL,
	IsActive BIT NOT NULL
)
AS
BEGIN 

INSERT INTO @Result
SELECT
	GR.GlobalRegionId,
	GR.RegionCode,
	GR.RegionName,
	GR.RegionCountryId,
	GR.RegionDefaultCurrencyCode,
	GR.RegionDefaultCorporateSourceCode,
	GR.RegionProjectCodePortion,
	GR.InsertedDate,
	GR.UpdatedDate,
	GR.IsAllocationRegion,
	GR.IsOriginatingRegion,
	GR.SubRegionCode,
	GR.SubRegionName,
	GR.SubRegionDefaultCurrencyCode,
	GR.SubRegionProjectCodePortion,
	GR.IsActive
FROM
	Gdm.GlobalRegionActive(@DataPriorToDate) GRA

	INNER JOIN
	(
		SELECT
			SubRegion.ImportKey,
			SubRegion.GlobalRegionId,
			ParentRegion.Code RegionCode,
			ParentRegion.Name RegionName,
			ParentRegion.CountryId RegionCountryId,
			ParentRegion.DefaultCurrencyCode RegionDefaultCurrencyCode,
			ParentRegion.DefaultCorporateSourceCode RegionDefaultCorporateSourceCode,
			ParentRegion.ProjectCodePortion RegionProjectCodePortion,
			(	-- We will choose the InsertedDate of the record (ParentRegion or SubRegion) that was last inserted
				SELECT
					MAX(InsertedDate) AS InsertedDate
				FROM
					(
						SELECT ParentRegion.InsertedDate UNION
						SELECT SubRegion.InsertedDate
					) InsertedDates
			) AS InsertedDate,
			(	-- Again, we will choose the InsertedDate of the record (ParentRegion or SubRegion) that was last inserted
				SELECT
					MAX(UpdatedDate) AS UpdatedDate
				FROM
					(
						SELECT ParentRegion.UpdatedDate UNION
						SELECT SubRegion.UpdatedDate
					) UpdatedDates
			) AS UpdatedDate,
			SubRegion.IsAllocationRegion,
			SubRegion.IsOriginatingRegion,
			SubRegion.Code SubRegionCode,
			SubRegion.Name SubRegionName,
			SubRegion.DefaultCurrencyCode SubRegionDefaultCurrencyCode,
			SubRegion.ProjectCodePortion SubRegionProjectCodePortion,
			(ParentRegion.IsActive & SubRegion.IsActive) AS IsActive -- If the Parent Region is not active, then its SubRegions should not be active either
		FROM
			Gdm.GlobalRegion ParentRegion

			INNER JOIN Gdm.GlobalRegion SubRegion ON
				SubRegion.ParentGlobalRegionId = ParentRegion.GlobalRegionId

		UNION

		-- SELECT the Parent Regions (Regions that have no Parent Region)

		SELECT
			ImportKey,
			GlobalRegionId,
			Code RegionCode,
			[Name] RegionName,
			CountryId RegionCountryId,
			DefaultCurrencyCode RegionDefaultCurrencyCode,
			DefaultCorporateSourceCode RegionDefaultCorporateSourceCode,
			ProjectCodePortion RegionProjectCodePortion,
			InsertedDate,
			UpdatedDate,
			IsAllocationRegion,
			IsOriginatingRegion,
			NULL SubRegionCode,
			NULL SubRegionName,
			NULL SubRegionDefaultCurrencyCode,
			NULL SubRegionProjectCodePortion,
			IsActive
		FROM
			Gdm.GlobalRegion
		WHERE
			ParentGlobalRegionId IS NULL AND -- Regions that do not have a parent region (i.e.: are parent regions themselves)
			GlobalRegionId IN ( SELECT -- Find all global regions that have a parent region (to make sure we don''t include parent regions that aren''t
									   --		references by sub regions)
									ParentGlobalRegionId 
								FROM
									Gdm.GlobalRegion
								WHERE
									ParentGlobalRegionId IS NOT NULL )
	) GR ON
		GRA.ImportKey = GR.ImportKey

RETURN
END

' 
END
GO
/****** Object:  UserDefinedFunction [Gr].[GetGlobalGlAccountCategoryTranslation]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetGlobalGlAccountCategoryTranslation]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

CREATE FUNCTION [Gr].[GetGlobalGlAccountCategoryTranslation]
	(@DataPriorToDate DATETIME)

RETURNS @GLAccountCategories TABLE (
		GlobalAccountCategoryCode VARCHAR(33) NULL,
		TranslationTypeName VARCHAR(50) NOT NULL,
		TranslationSubTypeName VARCHAR(50) NOT NULL,
		GLMajorCategoryId INT NOT NULL,
		GLMajorCategoryName VARCHAR(50) NOT NULL,
		GLMinorCategoryId INT NOT NULL,
		GLMinorCategoryName VARCHAR(100) NOT NULL,
		FeeOrExpense VARCHAR(7) NOT NULL,
		GLAccountSubTypeName VARCHAR(50) NULL,
		IsActive BIT NOT NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL
	)
AS

BEGIN	

	INSERT INTO @GLAccountCategories (
		GlobalAccountCategoryCode,
		TranslationTypeName,
		TranslationSubTypeName,
		GLMajorCategoryId,
		GLMajorCategoryName,
		GLMinorCategoryId,
		GLMinorCategoryName,
		FeeOrExpense,
		GLAccountSubTypeName,
		IsActive,
		InsertedDate,
		UpdatedDate
	)

--------------------------------------------------------------------------------------------------------------------------------------------

	-- Get ''UNKNOWN'' GL Account Category records for each Translation SubType

	SELECT
		LTRIM(STR(TT.GLTranslationTypeId, 10, 0)) + '':'' + LTRIM(STR(TST.GLTranslationSubTypeId, 10, 0)) + '':-1:-1:-1:-1'',
		TT.Name TranslationTypeName,
		TST.Name TranslationSubTypeName,
		-1,
		''UNKNOWN'',
		-1,
		''UNKNOWN'',
		''UNKNOWN'',
		''UNKNOWN'',
		1,
		''1900-01-01'',
		''1900-01-01''	
	FROM
	
		(
			SELECT
				TT.*
			FROM
				Gdm.GLTranslationType TT
				INNER JOIN
					Gdm.GLTranslationTypeActive(@DataPriorToDate) TTA
					ON TTA.ImportKey = TT.ImportKey
		) TT
	
		INNER JOIN (
			SELECT
				TST.*
			FROM
				Gdm.GLTranslationSubType TST
				INNER JOIN
					Gdm.GLTranslationSubTypeActive(@DataPriorToDate) TSTA 
					ON TSTA.ImportKey = TST.ImportKey
		) TST ON TT.GLTranslationTypeId = TST.GLTranslationTypeId

	------------------

	UNION

	------------------

	/*  Sample output from the SELECT below:

		GlobalAccountCategoryCode	TranslationTypeName	TranslationSubTypeName	GLMajorCategoryId	GLMajorCategoryName			GLMinorCategoryId	GLMinorCategoryName				FeeOrExpense	GLAccountSubTypeName
		1:233:18:490:1:1			Global				Global					18					Legal & Professional Fees	490					Legal - HR Related - Non-Union	EXPENSE			Non-Payroll
	*/

	SELECT
		CONVERT(VARCHAR(32), LTRIM(STR(TT.GLTranslationTypeId, 10, 0)) + '':'' + 
			LTRIM(STR(TST.GLTranslationSubTypeId, 10, 0)) + '':'' + 
			LTRIM(STR(MajC.GLMajorCategoryId, 10, 0)) + '':'' + 
			LTRIM(STR(MinC.GLMinorCategoryId, 10, 0)) + '':'' + 
			LTRIM(STR(AT.GLAccountTypeId, 10, 0)) + '':'' + 
			LTRIM(STR(AST.GLAccountSubTypeId, 10, 0))) GlobalAccountCategoryCode,
		TT.Name TranslationTypeName,
		TST.Name TranslationSubTypeName,
		MajC.GLMajorCategoryId,
		MajC.Name GLMajorCategoryName,
		MinC.GLMinorCategoryId,
		MinC.Name GLMinorCategoryName,
		CASE
			WHEN
				AT.Code LIKE ''%EXP%''
			THEN
				''EXPENSE'' 
			WHEN
				AT.Code LIKE ''%INC%''
			THEN
				''INCOME''
			ELSE ''UNKNOWN''
		END AS FeeOrExpense,						-- sourced from Gdm.GlobalGlAccountCategoryHierarchy.AccountType
		AST.Name GLAccountSubTypeName,				-- used to be ExpenseType, sourced from Gdm.GlobalGlAccountCategoryHierarchy.ExpenseType
		CASE
			WHEN									-- Every record that is used to construct the GL Account Category record needs to be active
				TST.IsActive = 1 AND				-- for the GL Account Category record to be active itself.
				GLATST.IsActive = 1 AND
				GLATT.IsActive = 1 AND
				TT.IsActive = 1 AND
				MajC.IsActive = 1 AND
				MinC.IsActive = 1 AND
				AST.IsActive = 1 AND
				AT.IsActive = 1
			THEN
				1
			ELSE
				0
		END AS IsActive, 
		MIN(GLATT.InsertedDate) InsertedDate,
		MAX(GLATT.UpdatedDate) UpdatedDate
	FROM
		Gdm.GLTranslationSubType TST
		
		INNER JOIN Gdm.GLGlobalAccountTranslationSubType GLATST ON
			TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId					
			
		INNER JOIN Gdm.GLGlobalAccountTranslationType GLATT ON
			GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
			TST.GLTranslationTypeId = GLATT.GLTranslationTypeId
					
		INNER JOIN Gdm.GLTranslationType TT ON
			GLATT.GLTranslationTypeId = TT.GLTranslationTypeId
	
		INNER JOIN Gdm.GLMinorCategory MinC ON
			GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId

		INNER JOIN Gdm.GLMajorCategory MajC ON
			MinC.GLMajorCategoryId = MajC.GLMajorCategoryId

		INNER JOIN Gdm.GLAccountSubType AST ON
			GLATT.GLAccountSubTypeId = AST.GLAccountSubTypeId
			
		INNER JOIN Gdm.GLAccountType AT ON
			GLATT.GLAccountTypeId = AT.GLAccountTypeId 
			
		INNER JOIN Gdm.GLTranslationSubTypeActive(@DataPriorToDate) TSTA ON 
			TSTA.ImportKey = TST.ImportKey	
			
		INNER JOIN Gdm.GLGlobalAccountTranslationSubTypeActive(@DataPriorToDate) GLATSTA ON 
			GLATSTA.ImportKey = GLATST.ImportKey
			
		INNER JOIN Gdm.GLTranslationTypeActive(@DataPriorToDate) TTA ON 
			TTA.ImportKey = TT.ImportKey	
			
		INNER JOIN Gdm.GLGlobalAccountTranslationTypeActive(@DataPriorToDate) GLATTA ON 
			GLATTA.ImportKey = GLATT.ImportKey	
			
		INNER JOIN Gdm.GLMinorCategoryActive(@DataPriorToDate) MinCA ON 
			MinCA.ImportKey = MinC.ImportKey
			
		INNER JOIN Gdm.GLMajorCategoryActive(@DataPriorToDate) MajCA ON 
			MajCA.ImportKey = MajC.ImportKey	
			
		INNER JOIN Gdm.GLAccountSubTypeActive(@DataPriorToDate) ASTA ON 
			ASTA.ImportKey = AST.ImportKey	
			
		INNER JOIN Gdm.GLAccountTypeActive(@DataPriorToDate) ATA ON
			ATA.ImportKey = AT.ImportKey 	
			
	GROUP BY
		TT.GLTranslationTypeId,
		TT.Name,		
		TST.GLTranslationSubTypeId,
		TST.Name,
		MajC.GLMajorCategoryId,
		MajC.Name,
		MinC.GLMinorCategoryId,
		MinC.Name,
		CASE
			WHEN
				AT.Code LIKE ''%EXP%''
			THEN
				''EXPENSE'' 
			WHEN
				AT.Code LIKE ''%INC%''
			THEN
				''INCOME''
			ELSE
				''UNKNOWN''
		END,
		AT.GLAccountTypeId,
		AST.Name,
		AST.GLAccountSubTypeId,
		CASE
			WHEN
				TST.IsActive = 1 AND
				GLATST.IsActive = 1 AND
				GLATT.IsActive = 1 AND
				TT.IsActive = 1 AND
				MajC.IsActive = 1 AND
				MinC.IsActive = 1 AND
				AST.IsActive = 1 AND
				AT.IsActive = 1
			THEN
				1
			ELSE
				0
		END

--------------------------------------------------------------------------------------------------------------------------------------------

	DECLARE @GLAccountCategories_GLAccountSubTypeAsOverhead TABLE(
		GlobalAccountCategoryCode VARCHAR(33) NULL,
		TranslationTypeName VARCHAR(50) NOT NULL,
		TranslationSubTypeName VARCHAR(50) NOT NULL,
		GLMajorCategoryId INT NOT NULL,
		GLMajorCategoryName VARCHAR(50) NOT NULL,
		GLMinorCategoryId INT NOT NULL,
		GLMinorCategoryName VARCHAR(100) NOT NULL,
		FeeOrExpense VARCHAR(7) NOT NULL,
		GLAccountSubTypeName VARCHAR(50) NULL,
		IsActive BIT NOT NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL
	)
	
	DECLARE @GRPOHD_Name VARCHAR(50) = (SELECT TOP 1 Name FROM Gdm.GLAccountSubType WHERE Code = ''GRPOHD'')
	DECLARE @GRPOHD_ID VARCHAR(10) = (SELECT LTRIM(STR(GLAccountSubTypeId, 10, 0)) FROM Gdm.GLAccountSubType WHERE Code = ''GRPOHD'')
	
	/*
		For each GL Account Category record that has been inserted into @GLAccountCategories, a new record needs to be inserted that is identical to this
		record in every respect apart from its GLAccountSubType - this will be hardcoded from the original GLAccountSubType to ''Overhead''
		Note that in thet record below, all field values should be identical to the sample record above (around line 100) besides the
		GLAccountSubType field: this has been updated from ''Non-Payroll'' to ''Overhead''.

		GlobalAccountCategoryCode	TranslationTypeName		TranslationSubTypeName	GLMajorCategoryId	GLMajorCategoryName			GLMinorCategoryId	GLMinorCategoryName					FeeOrExpense	GLAccountSubTypeName
		1:233:18:490:1:3			Global					Global					18					Legal & Professional Fees	490					Legal - HR Related - Non-Union		EXPENSE			Overhead
	*/

	INSERT INTO @GLAccountCategories_GLAccountSubTypeAsOverhead (
		GlobalAccountCategoryCode,
		TranslationTypeName,
		TranslationSubTypeName,
		GLMajorCategoryId,
		GLMajorCategoryName,
		GLMinorCategoryId,
		GLMinorCategoryName,
		FeeOrExpense,
		GLAccountSubTypeName,
		IsActive,
		InsertedDate,
		UpdatedDate
	)
	SELECT	
		DISTINCT
		REVERSE(SUBSTRING(REVERSE(GlobalAccountCategoryCode),
						  PATINDEX(''%:%'', REVERSE(GlobalAccountCategoryCode)),
						  LEN(GlobalAccountCategoryCode))
						  ) + @GRPOHD_ID -- we can hardcode the ID of the ''Overhead'' GLAccountSubType record
		AS GlobalAccountCategoryCode,
		TranslationTypeName,
		TranslationSubTypeName,
		GLMajorCategoryId,
		GLMajorCategoryName,
		GLMinorCategoryId,
		GLMinorCategoryName,
		FeeOrExpense,
		@GRPOHD_Name AS GLAccountSubTypeName, -- Instead of selecting the original GLAccountSubType, hardcode ''Overhead''
		IsActive,
		InsertedDate,
		UpdatedDate
	FROM
		@GLAccountCategories
		
	-- Insert the new ''Overhead'' GL Account Category records into @GLAccountCategories that do not already exist in @GLAccountCategories.
	
	INSERT INTO @GLAccountCategories (
		GlobalAccountCategoryCode,
		TranslationTypeName,
		TranslationSubTypeName,
		GLMajorCategoryId,
		GLMajorCategoryName,
		GLMinorCategoryId,
		GLMinorCategoryName,
		FeeOrExpense,
		GLAccountSubTypeName,
		IsActive,
		InsertedDate,
		UpdatedDate
	)
	SELECT  
		t1.GlobalAccountCategoryCode,
		t1.TranslationTypeName,
		t1.TranslationSubTypeName,
		t1.GLMajorCategoryId,
		t1.GLMajorCategoryName,
		t1.GLMinorCategoryId,
		t1.GLMinorCategoryName,
		t1.FeeOrExpense,
		t1.GLAccountSubTypeName,
		t1.IsActive,
		t1.InsertedDate,
		t1.UpdatedDate
	FROM
		@GLAccountCategories_GLAccountSubTypeAsOverhead t1

		LEFT OUTER JOIN @GLAccountCategories t2 ON
			t1.GlobalAccountCategoryCode = t2.GlobalAccountCategoryCode
	WHERE
		t2.GlobalAccountCategoryCode IS NULL
		
	RETURN

END

' 
END
GO
/****** Object:  UserDefinedFunction [Gr].[GetGLCategorizationHierarchyExpanded]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetGLCategorizationHierarchyExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gr].[GetGLCategorizationHierarchyExpanded]
	(@DataPriorToDate DATETIME)
	
RETURNS @GLAccountCategories TABLE
(
	GLCategorizationHierarchyCode VARCHAR(32) NULL,
	GLCategorizationTypeName VARCHAR(50) NOT NULL,
	GLCategorizationName VARCHAR(50) NOT NULL,
	GLFinancialCategoryName VARCHAR(50) NOT NULL,
	InflowOutflow VARCHAR(7) NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	GLMajorCategoryName VARCHAR(400) NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLMinorCategoryName VARCHAR(400) NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLGlobalAccountName VARCHAR(300) NOT NULL,
	GLGlobalAccountCode VARCHAR(10) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)
AS

BEGIN

	-- The purpose of this table is to combine the columns of DirectGLMinorCategoryId, IndirectGLMinorCategoryId and CoAGLMinorCategoryId
	DECLARE @GLGlobalAccountCategorization TABLE
	(
		GLCategorizationId INT NOT NULL,
		GLMinorCategoryId INT NOT NULL,
		GLGlobalAccountId INT NOT NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL
	)
	INSERT INTO @GLGlobalAccountCategorization
	(
		GLCategorizationId,
		GLMinorCategoryId,
		GLGlobalAccountId,
		InsertedDate,
		UpdatedDate
	)
	SELECT
		GGAC.GLCategorizationId,
		GGAC.DirectGLMinorCategoryId AS GLMinorCategoryId,
		GLGlobalAccountId,
		InsertedDate,
		UpdatedDate
	FROM
		Gdm.GLGlobalAccountCategorization GGAC 
		INNER JOIN Gdm.GLGlobalAccountCategorizationActive(@DataPriorToDate) GGACA ON
			GGACA.ImportKey = GGAC.ImportKey
	WHERE
		GGAC.DirectGLMinorCategoryId IS NOT NULL

	UNION

	SELECT
		GGAC.GLCategorizationId,
		GGAC.IndirectGLMinorCategoryId AS GLMinorCategoryId,
		GLGlobalAccountId,
		InsertedDate,
		UpdatedDate
	FROM
		Gdm.GLGlobalAccountCategorization GGAC 
		INNER JOIN Gdm.GLGlobalAccountCategorizationActive(@DataPriorToDate) GGACA ON
			GGACA.ImportKey = GGAC.ImportKey
	WHERE
		GGAC.IndirectGLMinorCategoryId IS NOT NULL
	UNION

	SELECT
		GGAC.GLCategorizationId,
		GGAC.CoAGLMinorCategoryId AS GLMinorCategoryId,
		GLGlobalAccountId,
		InsertedDate,
		UpdatedDate
	FROM
		Gdm.GLGlobalAccountCategorization GGAC 
		INNER JOIN Gdm.GLGlobalAccountCategorizationActive(@DataPriorToDate) GGACA ON
			GGACA.ImportKey = GGAC.ImportKey
	WHERE
		GGAC.CoAGLMinorCategoryId IS NOT NULL

	INSERT INTO @GLAccountCategories
	(
		GLCategorizationHierarchyCode,
		GLCategorizationTypeName,
		GLCategorizationName,
		GLFinancialCategoryName,
		InflowOutflow,
		GLMajorCategoryId,
		GLMajorCategoryName,
		GLMinorCategoryId,
		GLMinorCategoryName,
		GLGlobalAccountId,
		GLGlobalAccountName,
		GLGlobalAccountCode,
		IsActive,
		InsertedDate,
		UpdatedDate
	)
	/* ===========================================================================================================================================
		Records are created for each GL Global Account with unknown Categorization information (Major Account, Minor Account and Financial
			Category). This is to ensure that if the Categorization cannot be mapped, there will be a record available to map a transaction to
			which shows that the GL Global Account is known, but the Categorization information is unknown.
	   ======================================================================================================================================== */

	SELECT
		''-1:-1:-1:-1:-1:'' + LTRIM(STR(GLA.GLGlobalAccountId, 10, 0)),
		''UNKNOWN'',
		''UNKNOWN'',
		''UNKNOWN'',
		''UNKNOWN'',
		-1,
		''UNKNOWN'',
		-1,
		''UNKNOWN'',
		GLA.GLGlobalAccountId,
		GLA.Name,
		GLA.Code,
		GLA.IsActive,
		GLA.InsertedDate,
		GLA.UpdatedDate
	FROM
		(
			SELECT
				GLA.GLGlobalAccountId,
				GLA.Name,
				GLA.Code,
				GLA.IsActive,
				GLA.InsertedDate,
				GLA.UpdatedDate
			FROM
				Gdm.GLGlobalAccount GLA
				INNER JOIN Gdm.GLGlobalAccountActive(@DataPriorToDate) GLAa ON
					GLA.ImportKey = GLAa.ImportKey
					
		) GLA

	UNION
	
	SELECT
		CONVERT(VARCHAR(10), GLA.GLCategorizationTypeId) + '':'' +
			CONVERT(VARCHAR(10), GLA.GLCategorizationId) + 
			'':-1:-1:-1:'' + LTRIM(STR(GLA.GLGlobalAccountId, 10, 0)),
		GLA.GLCategorizationTypeName,
		GLA.GLCategorizationName,
		''UNKNOWN'',
		''UNKNOWN'',
		-1,
		''UNKNOWN'',
		-1,
		''UNKNOWN'',
		GLA.GLGlobalAccountId,
		GLA.Name,
		GLA.Code,
		GLA.IsActive,
		GLA.InsertedDate,
		GLA.UpdatedDate
	FROM
		(
			SELECT
				GLA.GLGlobalAccountId,
				GCT.GLCategorizationTypeId,
				GCT.Name AS GLCategorizationTypeName,
				GC.GLCategorizationId,
				GC.Name AS GLCategorizationName,
				GLA.Name,
				GLA.Code,
				GLA.IsActive,
				GLA.InsertedDate,
				GLA.UpdatedDate
			FROM
				Gdm.GLGlobalAccount GLA
				INNER JOIN Gdm.GLGlobalAccountActive(@DataPriorToDate) GLAa ON
					GLA.ImportKey = GLAa.ImportKey
					
				LEFT OUTER JOIN Gdm.GLCategorization GC ON
					GC.GLCategorizationId = GC.GLCategorizationId -- Joins onto itself. Has the same effect as a cross join.
					
				INNER JOIN Gdm.GLCategorizationActive(@DataPriorToDate) GCa ON
					GC.ImportKey = GCa.ImportKey
					
				LEFT OUTER JOIN Gdm.GLCategorizationType GCT ON
					GC.GLCategorizationTypeId = GCT.GLCategorizationTypeId 
				
				INNER JOIN Gdm.GLCategorizationTypeActive(@DataPriorToDate) GCTa ON
					GCT.ImportKey = GCTa.ImportKey
		) GLA
		
	UNION

	/* ===========================================================================================================================================
		The Categorization information for each mapped GL Global Account is mapped below. This includes Direct, Indirect and CoA mappings.
	   =========================================================================================================================================*/

	SELECT
		CONVERT(VARCHAR(32),
			LTRIM(STR(GCT.GLCategorizationTypeId, 10, 0)) + '':'' + 
			LTRIM(STR(GC.GLCategorizationId, 10, 0)) + '':'' +
			LTRIM(STR(GFC.GLFinancialCategoryId, 10, 0)) + '':'' +
			LTRIM(STR(MajC.GLMajorCategoryId, 10, 0)) + '':'' + 
			LTRIM(STR(MinC.GLMinorCategoryId, 10, 0)) + '':'' +
			LTRIM(STR(GGA.GLGlobalAccountId, 10, 0))
		) AS GLCategorizationHierarchyCode,
		GCT.Name AS GLCategorizationTypeName,
		GC.Name AS GLCategorizationName,
		GFC.Name AS GLFinancialCategoryName,
		GFC.InflowOutflow,
		MajC.GLMajorCategoryId,
		MajC.Name AS GLMajorCategoryName,
		MinC.GLMinorCategoryId,
		MinC.Name AS GLMinorCategoryName,
		GGA.GLGlobalAccountId,
		GGA.Name,
		GGA.Code,
		CAST((GCT.IsActive & GC.IsActive & MajC.IsActive & MinC.IsActive & GGA.IsActive) AS BIT) AS IsActive,
		(	/* Select the highest Inserted Date from all the tables used. This is because this record (which is composed of records from several
					other tables) only came into existence once all of the records that were used to created it were created */
			SELECT
				MAX(Dates.InsertedDate)
			FROM
			(
				SELECT GCT.InsertedDate UNION 
				SELECT GC.InsertedDate UNION 
				SELECT GFC.InsertedDate UNION 
				SELECT MajC.InsertedDate UNION 
				SELECT MinC.InsertedDate UNION 
				SELECT GGAC.InsertedDate UNION
				SELECT GGA.InsertedDate
			) Dates
		) AS InsertedDate,
		(	-- Select the highest Updated Date from all the tables used
			SELECT
				MAX(Dates.UpdatedDate)
			FROM
			(
				SELECT GCT.UpdatedDate UNION 
				SELECT GC.UpdatedDate UNION 
				SELECT GFC.UpdatedDate UNION 
				SELECT MajC.UpdatedDate UNION 
				SELECT MinC.UpdatedDate UNION 
				SELECT GGAC.UpdatedDate UNION
				SELECT GGA.UpdatedDate
			) Dates
		) AS UpdatedDate
	FROM
		Gdm.GLCategorizationType GCT

		INNER JOIN Gdm.GLCategorization GC ON
			GCT.GLCategorizationTypeId = GC.GLCategorizationTypeId

		INNER JOIN @GLGlobalAccountCategorization GGAC ON -- This combines Indirect, Direct and CoA mappings into one field.
			GGAC.GLCategorizationId = GC.GLCategorizationId

		INNER JOIN Gdm.GLGlobalAccount GGA ON
			GGA.GLGlobalAccountId = GGAC.GLGlobalAccountId

		INNER JOIN Gdm.GLMinorCategory MinC ON
			MinC.GLMinorCategoryId = GGAC.GLMinorCategoryId

		INNER JOIN Gdm.GLMajorCategory MajC ON
			MajC.GLMajorCategoryId = MinC.GLMajorCategoryID

		INNER JOIN Gdm.GLFinancialCategory GFC ON
			GFC.GLFinancialCategoryId = MajC.GLFinancialCategoryId

		INNER JOIN Gdm.GLCategorizationTypeActive(@DataPriorToDate) GCTA ON
			GCTA.ImportKey = GCT.ImportKey

		INNER JOIN Gdm.GLCategorizationActive(@DataPriorToDate) GCA ON
			GCA.ImportKey = GC.ImportKey

		INNER JOIN Gdm.GLGlobalAccountActive(@DataPriorToDate) GGAa ON
			GGA.ImportKey = GGAa.ImportKey	

		INNER JOIN Gdm.GLMinorCategoryActive(@DataPriorToDate) MinCA ON
			MinCA.ImportKey = MinC.ImportKey

		INNER JOIN Gdm.GLMajorCategoryActive(@DataPriorToDate) MajCA ON
			MajCA.ImportKey = MajC.ImportKey

		INNER JOIN Gdm.GLFinancialCategoryActive(@DataPriorToDate) GFCA ON
			GFCA.ImportKey = GFC.ImportKey

RETURN

END

' 
END
GO
/****** Object:  UserDefinedFunction [Gr].[GetFunctionalDepartmentExpanded]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetFunctionalDepartmentExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
/*********************************************************************************************************************
Description
	The function is used for as source data for populating the FunctionalDepartment slowly changing	dimension in 
	the data warehouse (GrReporting).
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-07-20		: PKayongo	:	Add the IsActive = 1 condition to Functional Departments to make sure inactive functional departments
												are not included.
											
			2011-08-09		: ISaunder	:	Removed the IsActive filter and added it to the SELECTs instead. The SCD stored procedures will
												determine how inactive functional departments should ne handled.

			2011-12-28		: ISaunder	:	Updated logic used to determine the UpdatedDate field - the UpdatedDate of the record that was last
												updated (either FunctionalDepartment or JobCode) is chosen as the UpdatedDate that is returned.
**********************************************************************************************************************/

CREATE FUNCTION [Gr].[GetFunctionalDepartmentExpanded]
	(@DataPriorToDate DateTime)

RETURNS @Result TABLE
(
	FunctionalDepartmentId INT NOT NULL,
	ReferenceCode VARCHAR(20) NULL,
	FunctionalDepartmentCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentName VARCHAR(50) NOT NULL,
	SubFunctionalDepartmentCode VARCHAR(20) NOT NULL,
	SubFunctionalDepartmentName VARCHAR(100) NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsActive BIT NOT NULL
)

AS

BEGIN 

INSERT INTO @Result
(
	FunctionalDepartmentId, 
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	UpdatedDate,
	IsActive
)
SELECT 
	FD.FunctionalDepartmentId,
	FD.GlobalCode+'':'',
	FD.GlobalCode FunctionalDepartmentCode,
	FD.Name FunctionalDepartmentName,
	FD.GlobalCode SubFunctionalDepartmentCode,
	RTRIM(Fd.GlobalCode) + '' - '' + Fd.Name SubFunctionalDepartmentName,
	FD.UpdatedDate,
	FD.IsActive	
FROM 
	HR.FunctionalDepartment FD
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FDA ON 
		FDA.ImportKey = FD.ImportKey
WHERE 
	FD.GlobalCode IS NOT NULL

INSERT INTO @Result
(
	FunctionalDepartmentId, 
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	UpdatedDate,
	IsActive
)
SELECT 
	JobCodes.FunctionalDepartmentId,
	FunctionalDepartments.FunctionalDepartmentCode + '':'' + JobCodes.Code,
	FunctionalDepartments.FunctionalDepartmentCode,
	FunctionalDepartments.FunctionalDepartmentName,
	JobCodes.Code,
	RTRIM(JobCodes.Code) + '' - '' + JobCodes.Description,
	CASE -- We will choose the InsertedDate of the record (FunctionalDepartment or JobCde) that was last inserted
		WHEN
			FunctionalDepartments.UpdatedDate > JobCodes.UpdatedDate
		THEN
			FunctionalDepartments.UpdatedDate
		ELSE
			JobCodes.UpdatedDate
	END AS UpdatedDate,
	FunctionalDepartments.IsActive & JobCodes.IsActive AS IsActive
FROM	
	@Result FunctionalDepartments
	INNER JOIN 
	(
		SELECT 
			JC.JobCode Code,
			MAX(JC.Description) AS Description,
			MAX(JC.FunctionalDepartmentId) AS FunctionalDepartmentId,
			MAX(JC.UpdatedDate) AS UpdatedDate,
			IsActive
		FROM 
			GACS.JobCode JC
			INNER JOIN GACS.JobCodeActive(@DataPriorToDate) JCA ON
				JCA.ImportKey = JC.ImportKey
		WHERE 
			JC.FunctionalDepartmentId IS NOT NULL
		GROUP BY
			JC.JobCode,
			JC.IsActive
	) JobCodes ON 
		JobCodes.FunctionalDepartmentId = FunctionalDepartments.FunctionalDepartmentId AND
		JobCodes.Code <> FunctionalDepartments.FunctionalDepartmentCode
ORDER BY 
	FunctionalDepartments.FunctionalDepartmentCode

--Add All the Parent FunctionalDepartments with UNKNOWN SubFunctionalDepartment, (that have a GlobalCode)
INSERT INTO @Result
(
	FunctionalDepartmentId,
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	UpdatedDate,
	IsActive
)
SELECT 
	FD.FunctionalDepartmentId,
	FD.GlobalCode+'':UNKNOWN'',
	FD.GlobalCode FunctionalDepartmentCode,
	FD.Name FunctionalDepartmentName,
	''UNKNOWN'' SubFunctionalDepartmentCode,
	''UNKNOWN'' SubFunctionalDepartmentName,
	FD.UpdatedDate,
	FD.IsActive
FROM 
	HR.FunctionalDepartment FD
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FDA ON
		FDA.ImportKey = FD.ImportKey
WHERE 
	FD.GlobalCode IS NOT NULL

RETURN

END

' 
END
GO
/****** Object:  UserDefinedFunction [Gr].[GetActivityTypeBusinessLineExpanded]    Script Date: 02/24/2012 10:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetActivityTypeBusinessLineExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gr].[GetActivityTypeBusinessLineExpanded] 
	(@DataPriorToDate DATETIME)

RETURNS @Result TABLE
(
	ActivityTypeId INT NOT NULL,
	ActivityTypeName VARCHAR(50) NOT NULL,
	ActivityTypeCode VARCHAR(50) NOT NULL,
	BusinessLineId INT NOT NULL,
	BusinessLineName VARCHAR(50) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsActive BIT NOT NULL
)
AS
BEGIN

INSERT INTO @Result
SELECT
	ActivityType.ActivityTypeId,
	ActivityType.ActivityTypeName,
	ActivityType.ActivityTypeCode,
	BusinessLine.BusinessLineId,
	BusinessLine.BusinessLineName,
	ActivityTypeBusinessLine.InsertedDate, /* The records that are returned by this function are a combination of Activity Type and Business Line
													records, with the ActivityTypeBusinessLine table being used to store these associations. The
													InsertedDate of this record is set to ActivityTypeBusinessLine.InsertedDate because that is
													when the combination that this record represents came into existence. Both the ActivityType
													and BusinessLine records might have existed long before the ActivityTypeBusinessLine record
													was created to unite them. This is why the InsertedDate fields of the ActivityType and
													BusinessLine records are not used. */
	(	/* The UpdatedDate of the record (either ActivityType, BusinessLine, or ActivityTypeBusinessLine) that was last updated will be used as
				the UpdatedDate that is returned for this record. */
		SELECT
			MAX(UpdatedDate) AS UpdatedDate
		FROM
			(
				SELECT ActivityType.UpdatedDate UNION
				SELECT BusinessLine.UpdatedDate UNION
				SELECT ActivityTypeBusinessLine.UpdatedDate
			) UpdatedDates
	) AS UpdatedDate,
	-- All records (ActivityType, BusinessLine, and ActivityTypeBusinessLine) need to be active for the ''final'' record to be active
	(ActivityTypeBusinessLine.IsActive & ActivityType.IsActive & BusinessLine.IsActive) AS IsActive
FROM
	(
		SELECT
			ATBL.ActivityTypeId,
			ATBL.BusinessLineId,
			ATBL.InsertedDate,
			ATBL.UpdatedDate,
			ATBL.IsActive
		FROM
			Gdm.ActivityTypeBusinessLine ATBL
			INNER JOIN Gdm.ActivityTypeBusinessLineActive(@DataPriorToDate) ATBLA ON
				ATBL.ImportKey = ATBLA.ImportKey

	) ActivityTypeBusinessLine

	INNER JOIN
	(	
		SELECT
			AT.ActivityTypeId,
			AT.Name AS ActivityTypeName,
			AT.Code AS ActivityTypeCode,
			AT.InsertedDate,
			AT.UpdatedDate,
			AT.IsActive
		FROM
			Gdm.ActivityType AT
			INNER JOIN Gdm.ActivityTypeActive(@DataPriorToDate) ATA ON
				AT.ImportKey = ATA.ImportKey

	) ActivityType ON
		ActivityTypeBusinessLine.ActivityTypeId = ActivityType.ActivityTypeId

	INNER JOIN
	(	
		SELECT
			BL.BusinessLineId,
			BL.Name AS BusinessLineName,
			BL.InsertedDate,
			BL.UpdatedDate,
			BL.IsActive
		FROM
			Gdm.BusinessLine BL
			INNER JOIN Gdm.BusinessLineActive(@DataPriorToDate) BLA ON
				BL.ImportKey = BLA.ImportKey

	) BusinessLine ON
		ActivityTypeBusinessLine.BusinessLineId = BusinessLine.BusinessLineId

RETURN

END

' 
END
GO
