 USE [GrReportingStaging]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]    Script Date: 08/05/2010 15:16:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]    Script Date: 08/05/2010 15:16:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]    Script Date: 08/05/2010 15:16:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyOverhead]    Script Date: 08/05/2010 15:16:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyOverhead]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyOverhead]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadExchangeRates]    Script Date: 08/05/2010 15:16:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadExchangeRates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadExchangeRates]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]    Script Date: 08/05/2010 15:16:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyCorporateReforecast]    Script Date: 08/05/2010 15:16:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyCorporateReforecast]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyCorporateReforecast]
GO
/****** Object:  View [BRCorp].[GeneralLedger]    Script Date: 08/05/2010 15:16:01 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BRCorp].[GeneralLedger]'))
DROP VIEW [BRCorp].[GeneralLedger]
GO
/****** Object:  View [BRProp].[GeneralLedger]    Script Date: 08/05/2010 15:16:01 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BRProp].[GeneralLedger]'))
DROP VIEW [BRProp].[GeneralLedger]
GO
/****** Object:  View [CNCorp].[GeneralLedger]    Script Date: 08/05/2010 15:16:01 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNCorp].[GeneralLedger]'))
DROP VIEW [CNCorp].[GeneralLedger]
GO
/****** Object:  View [CNProp].[GeneralLedger]    Script Date: 08/05/2010 15:16:01 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNProp].[GeneralLedger]'))
DROP VIEW [CNProp].[GeneralLedger]
GO
/****** Object:  View [EUCorp].[GeneralLedger]    Script Date: 08/05/2010 15:16:01 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUCorp].[GeneralLedger]'))
DROP VIEW [EUCorp].[GeneralLedger]
GO
/****** Object:  View [EUProp].[GeneralLedger]    Script Date: 08/05/2010 15:16:01 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUProp].[GeneralLedger]'))
DROP VIEW [EUProp].[GeneralLedger]
GO
/****** Object:  View [INCorp].[GeneralLedger]    Script Date: 08/05/2010 15:16:02 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[INCorp].[GeneralLedger]'))
DROP VIEW [INCorp].[GeneralLedger]
GO
/****** Object:  View [INProp].[GeneralLedger]    Script Date: 08/05/2010 15:16:02 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[INProp].[GeneralLedger]'))
DROP VIEW [INProp].[GeneralLedger]
GO
/****** Object:  View [USCorp].[GeneralLedger]    Script Date: 08/05/2010 15:16:02 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USCorp].[GeneralLedger]'))
DROP VIEW [USCorp].[GeneralLedger]
GO
/****** Object:  View [USProp].[GeneralLedger]    Script Date: 08/05/2010 15:16:02 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USProp].[GeneralLedger]'))
DROP VIEW [USProp].[GeneralLedger]
GO
/****** Object:  UserDefinedFunction [Gr].[GetFunctionalDepartmentExpanded]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetFunctionalDepartmentExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gr].[GetFunctionalDepartmentExpanded]
GO
/****** Object:  UserDefinedFunction [Gr].[GetGlobalGlAccountCategoryTranslation]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetGlobalGlAccountCategoryTranslation]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gr].[GetGlobalGlAccountCategoryTranslation]
GO
/****** Object:  UserDefinedFunction [dbo].[GetGreatest]    Script Date: 08/05/2010 15:16:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetGreatest]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetGreatest]
GO
/****** Object:  UserDefinedFunction [BRCorp].[GAccActive]    Script Date: 08/05/2010 15:16:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRCorp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [BRCorp].[GAccActive]
GO
/****** Object:  UserDefinedFunction [BRProp].[GAccActive]    Script Date: 08/05/2010 15:16:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRProp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [BRProp].[GAccActive]
GO
/****** Object:  UserDefinedFunction [CNCorp].[GAccActive]    Script Date: 08/05/2010 15:16:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNCorp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [CNCorp].[GAccActive]
GO
/****** Object:  UserDefinedFunction [CNProp].[GAccActive]    Script Date: 08/05/2010 15:16:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNProp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [CNProp].[GAccActive]
GO
/****** Object:  UserDefinedFunction [EUCorp].[GAccActive]    Script Date: 08/05/2010 15:16:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUCorp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [EUCorp].[GAccActive]
GO
/****** Object:  UserDefinedFunction [EUProp].[GAccActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUProp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [EUProp].[GAccActive]
GO
/****** Object:  UserDefinedFunction [INCorp].[GAccActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INCorp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [INCorp].[GAccActive]
GO
/****** Object:  UserDefinedFunction [INProp].[GAccActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INProp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [INProp].[GAccActive]
GO
/****** Object:  UserDefinedFunction [USCorp].[GAccActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USCorp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [USCorp].[GAccActive]
GO
/****** Object:  UserDefinedFunction [USProp].[GAccActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USProp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [USProp].[GAccActive]
GO
/****** Object:  UserDefinedFunction [BRCorp].[EntityActive]    Script Date: 08/05/2010 15:16:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRCorp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [BRCorp].[EntityActive]
GO
/****** Object:  UserDefinedFunction [BRProp].[EntityActive]    Script Date: 08/05/2010 15:16:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRProp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [BRProp].[EntityActive]
GO
/****** Object:  UserDefinedFunction [CNCorp].[EntityActive]    Script Date: 08/05/2010 15:16:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNCorp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [CNCorp].[EntityActive]
GO
/****** Object:  UserDefinedFunction [CNProp].[EntityActive]    Script Date: 08/05/2010 15:16:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNProp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [CNProp].[EntityActive]
GO
/****** Object:  UserDefinedFunction [EUCorp].[EntityActive]    Script Date: 08/05/2010 15:16:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUCorp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [EUCorp].[EntityActive]
GO
/****** Object:  UserDefinedFunction [EUProp].[EntityActive]    Script Date: 08/05/2010 15:16:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUProp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [EUProp].[EntityActive]
GO
/****** Object:  UserDefinedFunction [INCorp].[EntityActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INCorp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [INCorp].[EntityActive]
GO
/****** Object:  UserDefinedFunction [INProp].[EntityActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INProp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [INProp].[EntityActive]
GO
/****** Object:  UserDefinedFunction [USCorp].[EntityActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USCorp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [USCorp].[EntityActive]
GO
/****** Object:  UserDefinedFunction [USProp].[EntityActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USProp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [USProp].[EntityActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetTaxTypeActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetTaxTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetTaxTypeActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetStatusActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetStatusActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetStatusActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BenefitOptionActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BenefitOptionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BenefitOptionActive]
GO
/****** Object:  UserDefinedFunction [GACS].[EntityMappingActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GACS].[EntityMappingActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [GACS].[EntityMappingActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[EntityTypeActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[EntityTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[EntityTypeActive]
GO
/****** Object:  UserDefinedFunction [HR].[FunctionalDepartmentActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[HR].[FunctionalDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [HR].[FunctionalDepartmentActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[ActivityTypeActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ActivityTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ActivityTypeActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[AllocationSubRegionActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[AllocationSubRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[AllocationSubRegionActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[AllocationRegionActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[AllocationRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[AllocationRegionActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[BillingUploadActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[BillingUploadActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[BillingUploadActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[BillingUploadDetailActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[BillingUploadDetailActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[BillingUploadDetailActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetEmployeeActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetEmployeeActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartmentActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartmentActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetailActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetailActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetailActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetailActiveInner]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetailActiveInner]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetailActiveInner]
GO
/****** Object:  UserDefinedFunction [Gdm].[BudgetExchangeRateActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[BudgetExchangeRateActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[BudgetExchangeRateActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[BudgetExchangeRateDetailActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[BudgetExchangeRateDetailActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[BudgetExchangeRateDetailActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetOverheadAllocationActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetOverheadAllocationActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetOverheadAllocationActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetOverheadAllocationDetailActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetOverheadAllocationDetailActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetOverheadAllocationDetailActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetProjectActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetProjectActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetProjectActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetReportGroupActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetReportGroupActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetReportGroupActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetReportGroupDetailActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetReportGroupDetailActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetReportGroupDetailActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[BudgetReportGroupPeriodActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[BudgetReportGroupPeriodActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[BudgetReportGroupPeriodActive]
GO
/****** Object:  UserDefinedFunction [GACS].[DepartmentActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GACS].[DepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [GACS].[DepartmentActive]
GO
/****** Object:  UserDefinedFunction [BRCorp].[GJobActive]    Script Date: 08/05/2010 15:16:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRCorp].[GJobActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [BRCorp].[GJobActive]
GO
/****** Object:  UserDefinedFunction [CNCorp].[GJobActive]    Script Date: 08/05/2010 15:16:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNCorp].[GJobActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [CNCorp].[GJobActive]
GO
/****** Object:  UserDefinedFunction [CNProp].[GJobActive]    Script Date: 08/05/2010 15:16:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNProp].[GJobActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [CNProp].[GJobActive]
GO
/****** Object:  UserDefinedFunction [EUCorp].[GJobActive]    Script Date: 08/05/2010 15:16:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUCorp].[GJobActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [EUCorp].[GJobActive]
GO
/****** Object:  UserDefinedFunction [EUProp].[GJobActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUProp].[GJobActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [EUProp].[GJobActive]
GO
/****** Object:  UserDefinedFunction [INCorp].[GJobActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INCorp].[GJobActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [INCorp].[GJobActive]
GO
/****** Object:  UserDefinedFunction [USCorp].[GJobActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USCorp].[GJobActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [USCorp].[GJobActive]
GO
/****** Object:  UserDefinedFunction [USProp].[GJobActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USProp].[GJobActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [USProp].[GJobActive]
GO
/****** Object:  UserDefinedFunction [BRCorp].[GDepActive]    Script Date: 08/05/2010 15:16:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRCorp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [BRCorp].[GDepActive]
GO
/****** Object:  UserDefinedFunction [BRProp].[GDepActive]    Script Date: 08/05/2010 15:16:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRProp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [BRProp].[GDepActive]
GO
/****** Object:  UserDefinedFunction [CNCorp].[GDepActive]    Script Date: 08/05/2010 15:16:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNCorp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [CNCorp].[GDepActive]
GO
/****** Object:  UserDefinedFunction [CNProp].[GDepActive]    Script Date: 08/05/2010 15:16:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNProp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [CNProp].[GDepActive]
GO
/****** Object:  UserDefinedFunction [EUCorp].[GDepActive]    Script Date: 08/05/2010 15:16:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUCorp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [EUCorp].[GDepActive]
GO
/****** Object:  UserDefinedFunction [EUProp].[GDepActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUProp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [EUProp].[GDepActive]
GO
/****** Object:  UserDefinedFunction [INCorp].[GDepActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INCorp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [INCorp].[GDepActive]
GO
/****** Object:  UserDefinedFunction [INProp].[GDepActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INProp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [INProp].[GDepActive]
GO
/****** Object:  UserDefinedFunction [USCorp].[GDepActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USCorp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [USCorp].[GDepActive]
GO
/****** Object:  UserDefinedFunction [USProp].[GDepActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USProp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [USProp].[GDepActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[GLAccountSubTypeActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLAccountSubTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLAccountSubTypeActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[GLAccountTypeActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLAccountTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLAccountTypeActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[GLGlobalAccountActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLGlobalAccountActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLGlobalAccountActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[GLGlobalAccountGLAccountActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLGlobalAccountGLAccountActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLGlobalAccountGLAccountActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[GLGlobalAccountTranslationSubTypeActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLGlobalAccountTranslationSubTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLGlobalAccountTranslationSubTypeActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[GLMajorCategoryActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLMajorCategoryActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLMajorCategoryActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[GLGlobalAccountTranslationTypeActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLGlobalAccountTranslationTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLGlobalAccountTranslationTypeActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[GLMinorCategoryActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLMinorCategoryActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLMinorCategoryActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[GLTranslationTypeActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLTranslationTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLTranslationTypeActive]
GO
/****** Object:  View [CNCorp].[GrGHis]    Script Date: 08/05/2010 15:16:01 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNCorp].[GrGHis]'))
DROP VIEW [CNCorp].[GrGHis]
GO
/****** Object:  View [CNProp].[GrGHis]    Script Date: 08/05/2010 15:16:01 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNProp].[GrGHis]'))
DROP VIEW [CNProp].[GrGHis]
GO
/****** Object:  View [EUCorp].[GrGHis]    Script Date: 08/05/2010 15:16:01 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUCorp].[GrGHis]'))
DROP VIEW [EUCorp].[GrGHis]
GO
/****** Object:  View [EUProp].[GrGHis]    Script Date: 08/05/2010 15:16:01 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUProp].[GrGHis]'))
DROP VIEW [EUProp].[GrGHis]
GO
/****** Object:  View [USCorp].[GrGHis]    Script Date: 08/05/2010 15:16:02 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USCorp].[GrGHis]'))
DROP VIEW [USCorp].[GrGHis]
GO
/****** Object:  View [USProp].[GrGHis]    Script Date: 08/05/2010 15:16:02 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USProp].[GrGHis]'))
DROP VIEW [USProp].[GrGHis]
GO
/****** Object:  View [BRCorp].[GrJournal]    Script Date: 08/05/2010 15:16:01 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BRCorp].[GrJournal]'))
DROP VIEW [BRCorp].[GrJournal]
GO
/****** Object:  View [BRProp].[GrJournal]    Script Date: 08/05/2010 15:16:01 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BRProp].[GrJournal]'))
DROP VIEW [BRProp].[GrJournal]
GO
/****** Object:  View [CNCorp].[GrJournal]    Script Date: 08/05/2010 15:16:01 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNCorp].[GrJournal]'))
DROP VIEW [CNCorp].[GrJournal]
GO
/****** Object:  View [CNProp].[GrJournal]    Script Date: 08/05/2010 15:16:01 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNProp].[GrJournal]'))
DROP VIEW [CNProp].[GrJournal]
GO
/****** Object:  View [EUCorp].[GrJournal]    Script Date: 08/05/2010 15:16:01 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUCorp].[GrJournal]'))
DROP VIEW [EUCorp].[GrJournal]
GO
/****** Object:  View [EUProp].[GrJournal]    Script Date: 08/05/2010 15:16:01 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUProp].[GrJournal]'))
DROP VIEW [EUProp].[GrJournal]
GO
/****** Object:  View [INCorp].[GrJournal]    Script Date: 08/05/2010 15:16:02 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[INCorp].[GrJournal]'))
DROP VIEW [INCorp].[GrJournal]
GO
/****** Object:  View [INProp].[GrJournal]    Script Date: 08/05/2010 15:16:02 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[INProp].[GrJournal]'))
DROP VIEW [INProp].[GrJournal]
GO
/****** Object:  View [USCorp].[GrJournal]    Script Date: 08/05/2010 15:16:02 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USCorp].[GrJournal]'))
DROP VIEW [USCorp].[GrJournal]
GO
/****** Object:  View [USProp].[GrJournal]    Script Date: 08/05/2010 15:16:02 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USProp].[GrJournal]'))
DROP VIEW [USProp].[GrJournal]
GO
/****** Object:  UserDefinedFunction [Gdm].[GLTranslationSubTypeActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLTranslationSubTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLTranslationSubTypeActive]
GO
/****** Object:  UserDefinedFunction [GACS].[JobCodeActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GACS].[JobCodeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [GACS].[JobCodeActive]
GO
/****** Object:  UserDefinedFunction [BudgetingCorp].[GlobalReportingCorporateBudgetActive]    Script Date: 08/05/2010 15:16:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BudgetingCorp].[GlobalReportingCorporateBudgetActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [BudgetingCorp].[GlobalReportingCorporateBudgetActive]
GO
/****** Object:  UserDefinedFunction [HR].[LocationActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[HR].[LocationActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [HR].[LocationActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[OriginatingRegionCorporateEntityActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[OriginatingRegionCorporateEntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[OriginatingRegionCorporateEntityActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[GlobalRegionActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GlobalRegionActive]
GO
/****** Object:  View [Gdm].[GlobalRegionExpanded]    Script Date: 08/05/2010 15:16:01 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalRegionExpanded]'))
DROP VIEW [Gdm].[GlobalRegionExpanded]
GO
/****** Object:  UserDefinedFunction [Gdm].[OriginatingRegionPropertyDepartmentActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[OriginatingRegionPropertyDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[OriginatingRegionPropertyDepartmentActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[OverheadActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[OverheadActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[OverheadActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[OverheadRegionActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[OverheadRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[OverheadRegionActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[PayrollRegionActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[PayrollRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[PayrollRegionActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[ProjectActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[ProjectActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[ProjectActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[PropertyFundActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[PropertyFundActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[PropertyFundActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[PropertyFundMappingActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[PropertyFundMappingActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[PropertyFundMappingActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[RegionExtendedActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[RegionExtendedActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[RegionExtendedActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[ReportingEntityCorporateDepartmentActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ReportingEntityCorporateDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ReportingEntityCorporateDepartmentActive]
GO
/****** Object:  UserDefinedFunction [HR].[RegionActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[HR].[RegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [HR].[RegionActive]
GO
/****** Object:  UserDefinedFunction [Gdm].[ReportingEntityPropertyEntityActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ReportingEntityPropertyEntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ReportingEntityPropertyEntityActive]
GO
/****** Object:  StoredProcedure [dbo].[stp_J_UpdateSSISConfigurationsImportWindow]    Script Date: 08/05/2010 15:16:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_J_UpdateSSISConfigurationsImportWindow]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_J_UpdateSSISConfigurationsImportWindow]
GO
/****** Object:  StoredProcedure [dbo].[stp_U_ImportBatch]    Script Date: 08/05/2010 15:16:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_U_ImportBatch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_U_ImportBatch]
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[SystemSettingActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[SystemSettingActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[SystemSettingActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[SystemSettingRegionActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[SystemSettingRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[SystemSettingRegionActive]
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[TaxTypeActive]    Script Date: 08/05/2010 15:16:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[TaxTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[TaxTypeActive]
GO
/****** Object:  StoredProcedure [dbo].[stp_I_ImportBatch]    Script Date: 08/05/2010 15:16:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_I_ImportBatch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_I_ImportBatch]
GO
/****** Object:  UserDefinedFunction [dbo].[GetLongestWord]    Script Date: 08/05/2010 15:16:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetLongestWord]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetLongestWord]
GO
/****** Object:  UserDefinedFunction [dbo].[GetSplit]    Script Date: 08/05/2010 15:16:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetSplit]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetSplit]
GO
/****** Object:  UserDefinedFunction [dbo].[GetSplit]    Script Date: 08/05/2010 15:16:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[GetLongestWord]    Script Date: 08/05/2010 15:16:04 ******/
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
/****** Object:  StoredProcedure [dbo].[stp_I_ImportBatch]    Script Date: 08/05/2010 15:16:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_I_ImportBatch]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_I_ImportBatch]
	@PackageName		VARCHAR(100)
AS
	DECLARE @ImportStartDate DateTime
	DECLARE @ImportEndDate DateTime
	DECLARE @DataPriorToDate DateTime
	
	SET @ImportStartDate = (SELECT Convert(DateTime,ConfiguredValue) 
							FROM dbo.SSISConfigurations WHERE ConfigurationFilter = ''ImportStartDate'')
	
	SET @ImportEndDate = (SELECT Convert(DateTime,ConfiguredValue) 
							FROM dbo.SSISConfigurations WHERE ConfigurationFilter = ''ImportEndDate'')
							
	SET @DataPriorToDate = (SELECT Convert(DateTime,ConfiguredValue) 
							FROM dbo.SSISConfigurations WHERE ConfigurationFilter = ''DataPriorToDate'')
	
	INSERT INTO Batch
	(
		PackageName,
		BatchStartDate,
		ImportStartDate,
		ImportEndDate,
		DataPriorToDate
	)
	VALUES
	(
		@PackageName,	/* PackageName	*/
		GetDate(),
		@ImportStartDate,
		@ImportEndDate,
		@DataPriorToDate
	)
	
	SELECT SCOPE_IDENTITY() AS BatchId

' 
END
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[TaxTypeActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [TapasGlobal].[SystemSettingRegionActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [TapasGlobal].[SystemSettingActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  StoredProcedure [dbo].[stp_U_ImportBatch]    Script Date: 08/05/2010 15:16:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_U_ImportBatch]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_U_ImportBatch]
	@BatchId INT
AS
	UPDATE 
		Batch
	SET 
	    BatchEndDate = GETDATE()
	WHERE BatchId=@BatchId

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_J_UpdateSSISConfigurationsImportWindow]    Script Date: 08/05/2010 15:16:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_J_UpdateSSISConfigurationsImportWindow]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_J_UpdateSSISConfigurationsImportWindow]
	@JobName varchar(500),
	@SucessfulStepCount int
AS

DECLARE @JobId uniqueidentifier

SELECT
	@JobId = j.job_id
FROM
	msdb.dbo.sysjobhistory h
	
	INNER JOIN msdb.dbo.sysjobs j ON
		h.job_id = j.job_id
WHERE
	j.name 	= @JobName AND
	h.run_status = 4 AND -- In Progress
	h.run_date = CONVERT(varchar, getdate(), 112)
	
IF @JobId IS NOT NULL
BEGIN
	
	DECLARE @SucessfulSteps int
	SELECT
		@SucessfulSteps = COUNT(*)
	FROM
		msdb.dbo.sysjobsteps 
	WHERE 
		job_id = @JobId AND
		last_run_outcome = 1 -- Succeeded
	
	DECLARE @StopDate datetime,
			@NewStartDate datetime,
			@Yesterday datetime
			
	-- Only updates the imports dates if all steps have run sucesfully		
	IF @SucessfulSteps = @SucessfulStepCount
	BEGIN
			
		SELECT
			@StopDate = CONVERT(datetime, [ConfiguredValue])
		FROM
			[GrReportingStaging].[dbo].[SSISConfigurations]
		WHERE
			[ConfigurationFilter] = ''ImportEndDate''
			
		SET @NewStartDate = DATEADD(DAY, 1, @StopDate)
		SET @Yesterday = DATEADD(day, -1, getdate())
		
		-- Sets the ImportStartDate to one day after the last import end date
		UPDATE [GrReportingStaging].[dbo].[SSISConfigurations]
		SET
			[ConfiguredValue] = RIGHT(''00'' + DATENAME(DAY,@NewStartDate),2) + '' '' + -- two digit day value
								LEFT(CONVERT(varchar, @NewStartDate),3) + '' '' + -- Abbreviated month description
								DATENAME(YEAR,@NewStartDate)
		WHERE
			[ConfigurationFilter] = ''ImportStartDate''
			
		
		-- Sets the ImportEndDate and DataPriorToDate to yesterday	
		UPDATE [GrReportingStaging].[dbo].[SSISConfigurations]
		SET
			[ConfiguredValue] = RIGHT(''00'' + DATENAME(DAY,@Yesterday),2) + '' '' + -- two digit day value
								LEFT(CONVERT(varchar, @Yesterday),3) + '' '' + -- Abbreviated month description
								DATENAME(YEAR,@Yesterday)
		WHERE
			[ConfigurationFilter] = ''ImportEndDate'' OR 
			[ConfigurationFilter] = ''DataPriorToDate''
	END
		
		
		
END

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[ReportingEntityPropertyEntityActive]    Script Date: 08/05/2010 15:16:05 ******/
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
				ReportingEntityPropertyEntityId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ReportingEntityPropertyEntity]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY ReportingEntityPropertyEntityId
		) t1 ON t1.ReportingEntityPropertyEntityId = Gl1.ReportingEntityPropertyEntityId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.ReportingEntityPropertyEntityId
)

' 
END
GO
/****** Object:  UserDefinedFunction [HR].[RegionActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [Gdm].[ReportingEntityCorporateDepartmentActive]    Script Date: 08/05/2010 15:16:05 ******/
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
				ReportingEntityCorporateDepartmentId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ReportingEntityCorporateDepartment]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY ReportingEntityCorporateDepartmentId
		) t1 ON t1.ReportingEntityCorporateDepartmentId = Gl1.ReportingEntityCorporateDepartmentId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.ReportingEntityCorporateDepartmentId
)

' 
END
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[RegionExtendedActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [Gdm].[PropertyFundMappingActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [Gdm].[PropertyFundActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [TapasGlobal].[ProjectActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [TapasGlobal].[PayrollRegionActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [TapasGlobal].[OverheadRegionActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [TapasGlobal].[OverheadActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [Gdm].[OriginatingRegionPropertyDepartmentActive]    Script Date: 08/05/2010 15:16:05 ******/
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
				OriginatingRegionPropertyDepartmentId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[OriginatingRegionPropertyDepartment]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY OriginatingRegionPropertyDepartmentId
		) t1 ON t1.OriginatingRegionPropertyDepartmentId = Gl1.OriginatingRegionPropertyDepartmentId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.OriginatingRegionPropertyDepartmentId	
)

' 
END
GO
/****** Object:  View [Gdm].[GlobalRegionExpanded]    Script Date: 08/05/2010 15:16:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalRegionExpanded]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [Gdm].[GlobalRegionExpanded]
AS
SELECT
	SubReg.[ImportKey],
	SubReg.[GlobalRegionId],
	
	Reg.Code RegionCode,
	Reg.[Name] RegionName,
	Reg.CountryId RegionCountryId,
	Reg.DefaultCurrencyCode RegionDefaultCurrencyCode,
	Reg.DefaultCorporateSourceCode RegionDefaultCorporateSourceCode,
	Reg.ProjectCodePortion RegionProjectCodePortion,
	
	CONVERT(DATETIME,CONVERT(VARCHAR(23),Reg.[InsertedDate],120),120) InsertedDate,
	CONVERT(DATETIME,CONVERT(VARCHAR(23),CASE WHEN MAX(SubReg.[UpdatedDate]) < MAX(Reg.[UpdatedDate]) THEN MAX(Reg.[UpdatedDate]) ELSE MAX(SubReg.[UpdatedDate]) END,120),120)  UpdatedDate,
	
	SubReg.[IsAllocationRegion],
	SubReg.[IsOriginatingRegion],
	SubReg.[Code] SubRegionCode,
	SubReg.[Name] SubRegionName,
	SubReg.DefaultCurrencyCode SubRegionDefaultCurrencyCode,
	--SubReg.DefaultCorporateSourceCode SubRegionDefaultCorporateSourceCode,
	SubReg.ProjectCodePortion SubRegionProjectCodePortion
	
FROM
	[Gdm].[GlobalRegion] Reg
	INNER JOIN
		[Gdm].[GlobalRegion] SubReg ON SubReg.ParentGlobalRegionId = Reg.GlobalRegionId

GROUP BY
	SubReg.[ImportKey],
	SubReg.[GlobalRegionId],
	Reg.[Code],
	Reg.[Name],
	Reg.CountryId,
	Reg.DefaultCurrencyCode,
	Reg.DefaultCorporateSourceCode,	
	Reg.ProjectCodePortion,
	Reg.[InsertedDate],
	SubReg.[IsAllocationRegion],
	SubReg.[IsOriginatingRegion],
	SubReg.[Code],
	SubReg.[Name],
	SubReg.DefaultCurrencyCode,
	--SubReg.DefaultCorporateSourceCode,
	SubReg.ProjectCodePortion

UNION

SELECT
	Reg.[ImportKey],
	Reg.[GlobalRegionId],
	Reg.[Code] RegionCode,
	Reg.[Name] RegionName,
	Reg.CountryId RegionCountryId,
	Reg.DefaultCurrencyCode RegionDefaultCurrencyCode,
	Reg.DefaultCorporateSourceCode RegionDefaultCorporateSourceCode,
	Reg.ProjectCodePortion RegionProjectCodePortion,
		
	CONVERT(DATETIME,CONVERT(VARCHAR(23),Reg.[InsertedDate],120),120),
	CONVERT(DATETIME,CONVERT(VARCHAR(23),Reg.[UpdatedDate],120),120),
	
	Reg.[IsAllocationRegion],
	Reg.[IsOriginatingRegion],
	NULL SubRegionCode,
	NULL SubRegionName,
	NULL SubRegionDefaultCurrencyCode,
	--NULL SubRegionDefaultCorporateSourceCode,
	NULL SubRegionProjectCodePortion
	
FROM
	[Gdm].[GlobalRegion] Reg
WHERE
	Reg.ParentGlobalRegionId IS NULL AND
	Reg.GlobalRegionId IN (
								SELECT ParentGlobalRegionId 
								FROM [Gdm].[GlobalRegion] Reg 
								WHERE Reg.ParentGlobalRegionId IS NOT NULL
							   )


'
GO
/****** Object:  UserDefinedFunction [Gdm].[GlobalRegionActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [Gdm].[OriginatingRegionCorporateEntityActive]    Script Date: 08/05/2010 15:16:05 ******/
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
				OriginatingRegionCorporateEntityId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[OriginatingRegionCorporateEntity]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY OriginatingRegionCorporateEntityId
		) t1 ON t1.OriginatingRegionCorporateEntityId = Gl1.OriginatingRegionCorporateEntityId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.OriginatingRegionCorporateEntityId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [HR].[LocationActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [BudgetingCorp].[GlobalReportingCorporateBudgetActive]    Script Date: 08/05/2010 15:16:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BudgetingCorp].[GlobalReportingCorporateBudgetActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [BudgetingCorp].[GlobalReportingCorporateBudgetActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		B1.ImportKey ImportKey
	FROM
		[BudgetingCorp].[GlobalReportingCorporateBudget] B1

		INNER JOIN (
			SELECT 
				Budget.BudgetId,
				MAX(Budget.ImportBatchId) as ImportBatchId
			FROM 
				[BudgetingCorp].[GlobalReportingCorporateBudget] budget
				
				INNER JOIN Batch ON
					Budget.ImportBatchId = batch.BatchId
				
			WHERE	
				batch.BatchEndDate IS NOT NULL AND
				batch.PackageName = ''ETL.Staging.BudgetingCorp'' AND
				batch.ImportEndDate <= @DataPriorToDate
				
		GROUP BY Budget.BudgetId
		) t1 ON 
			t1.BudgetId = B1.BudgetId AND
			t1.ImportBatchId = B1.ImportBatchId

)

' 
END
GO
/****** Object:  UserDefinedFunction [GACS].[JobCodeActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [Gdm].[GLTranslationSubTypeActive]    Script Date: 08/05/2010 15:16:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLTranslationSubTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gdm].[GLTranslationSubTypeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GLTranslationSubType] Gl1
		INNER JOIN (
			SELECT 
				GLTranslationSubTypeId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GLTranslationSubType]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GLTranslationSubTypeId
		) t1 ON t1.GLTranslationSubTypeId = Gl1.GLTranslationSubTypeId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GLTranslationSubTypeId	
)

' 
END
GO
/****** Object:  View [USProp].[GrJournal]    Script Date: 08/05/2010 15:16:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USProp].[GrJournal]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [USProp].[GrJournal]
AS
Select 
	''PERIOD=''+JR.PERIOD+''&REF=''+JR.REF+''&SOURCE=''+JR.SOURCE+''&SITEID=''+JR.SITEID+''&ITEM=''+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	1 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	''JOURNAL'' SourceTable,
	''US'' SourceCode,
	JR.PERIOD Period,
	JR.ENTITYID PropertyFundCode,
	LEFT(JR.DEPARTMENT,3) RegionCode,
	SUBSTRING(JR.DEPARTMENT,4,DATALENGTH (JR.DEPARTMENT)-3) FunctionalDepartmentCode,
	JR.JOBCODE JobCode,
	JR.ACCTNUM GlAccountCode,
	JR.AMT Amount,
	JR.ENTRDATE [EnterDate],
	JR.USERID [User],
	JR.DESCRPN Description,
	JR.ADDLDESC AdditionalDescription,
	JR.BASIS Basis,
	CONVERT(DateTime,NULL,120) LastDate,
	RIGHT(RTRIM(JR.ACCTNUM),2) GlAccountSuffix,
	JR.CDEP CorporateDepartmentCode,
	''USD'' OcurrCode,
	''N'' BALFOR,
	JR.SOURCE
From USProp.JOURNAL JR
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [USCorp].[GrJournal]    Script Date: 08/05/2010 15:16:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USCorp].[GrJournal]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [USCorp].[GrJournal]
AS
Select 
	''PERIOD=''+JR.PERIOD+''&REF=''+JR.REF+''&SOURCE=''+JR.SOURCE+''&SITEID=''+JR.SITEID+''&ITEM=''+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	1 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	''JOURNAL'' SourceTable,
	''UC'' SourceCode,
	JR.PERIOD Period,
	JR.ENTITYID RegionCode,
	JR.DEPARTMENT PropertyFundCode,
	--This looks strange, but its because in Corp: the jobcode is the same as the functionaldepartment
	JR.JOBCODE FunctionalDepartmentCode,
	JR.JOBCODE JobCode,
	JR.ACCTNUM GlAccountCode,
	JR.AMT Amount,
	JR.ENTRDATE EnterDate,
	JR.USERID [User],
	JR.DESCRPN [Description],
	JR.ADDLDESC AdditionalDescription,
	JR.BASIS Basis,
	JR.LASTDATE LastDate,
	RIGHT(RTRIM(JR.ACCTNUM),2) GlAccountSuffix,
	''USD'' OcurrCode,
	''N'' BALFOR,
	JR.SOURCE
From USCorp.JOURNAL JR
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [INProp].[GrJournal]    Script Date: 08/05/2010 15:16:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[INProp].[GrJournal]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [INProp].[GrJournal]
AS
Select 
	''PERIOD=''+JR.PERIOD+''&REF=''+JR.REF+''&SOURCE=''+JR.SOURCE+''&SITEID=''+JR.SITEID+''&ITEM=''+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	1 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	''JOURNAL'' SourceTable,
	''IN'' SourceCode,
	JR.PERIOD Period,
	JR.ENTITYID PropertyFundCode,
	LEFT(JR.DEPARTMENT,3) RegionCode,
	SUBSTRING(JR.DEPARTMENT,4,DATALENGTH (JR.DEPARTMENT)-3) FunctionalDepartmentCode,
	JR.JOBCODE JobCode,
	JR.ACCTNUM GlAccountCode,
	JR.AMT Amount,
	JR.ENTRDATE EnterDate,
	JR.USERID [User],
	JR.DESCRPN [Description],
	'''' AdditionalDescription,
	JR.BASIS Basis,
	CONVERT(DateTime,NULL,120) LastDate,
	RIGHT(RTRIM(JR.ACCTNUM),2) GlAccountSuffix,
	JR.CDEP CorporateDepartmentCode,
	ISNULL(JR.OCURRCODE,''INR'') OcurrCode,
	''N'' BALFOR,
	JR.SOURCE
From INProp.JOURNAL JR
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [INCorp].[GrJournal]    Script Date: 08/05/2010 15:16:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[INCorp].[GrJournal]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [INCorp].[GrJournal]
AS
Select 
	''PERIOD=''+JR.PERIOD+''&REF=''+JR.REF+''&SOURCE=''+JR.SOURCE+''&SITEID=''+JR.SITEID+''&ITEM=''+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	1 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	''JOURNAL'' SourceTable,
	''IC'' SourceCode,
	JR.PERIOD Period,
	JR.ENTITYID RegionCode,
	JR.DEPARTMENT PropertyFundCode,
	--This looks strange, but its because in Corp: the jobcode is the same as the functionaldepartment
	JR.JOBCODE FunctionalDepartmentCode,
	JR.JOBCODE JobCode,
	JR.ACCTNUM GlAccountCode,
	JR.AMT Amount,
	JR.ENTRDATE EnterDate,
	JR.USERID [User],
	JR.DESCRPN [Description],
	JR.ADDLDESC AdditionalDescription,
	JR.BASIS Basis,
	JR.LASTDATE LastDate,
	RIGHT(RTRIM(JR.ACCTNUM),2) GlAccountSuffix,
	''INR'' OcurrCode,
	''N'' BALFOR,
	JR.SOURCE
From INCorp.JOURNAL JR
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [EUProp].[GrJournal]    Script Date: 08/05/2010 15:16:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUProp].[GrJournal]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [EUProp].[GrJournal]
AS
Select 
	''PERIOD=''+JR.PERIOD+''&REF=''+JR.REF+''&SOURCE=''+JR.SOURCE+''&SITEID=''+JR.SITEID+''&ITEM=''+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	1 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	''JOURNAL'' SourceTable,
	''EU'' SourceCode,
	JR.PERIOD Period,
	JR.ENTITYID PropertyFundCode,
	LEFT(JR.DEPARTMENT,3) RegionCode,
	SUBSTRING(JR.DEPARTMENT,4,DATALENGTH (JR.DEPARTMENT)-3) FunctionalDepartmentCode,
	JR.JOBCODE JobCode,
	JR.ACCTNUM GlAccountCode,
	JR.AMT Amount,
	JR.ENTRDATE EnterDate,
	JR.USERID [User],
	JR.DESCRPN [Description],
	JR.ADDLDESC AdditionalDescription,
	JR.BASIS Basis,
	CONVERT(DateTime,NULL,120) LastDate,
	RIGHT(RTRIM(JR.ACCTNUM),2) GlAccountSuffix,
	JR.CDEP CorporateDepartmentCode,
	JR.OcurrCode,
	''N'' BALFOR,
	JR.SOURCE
From EUProp.JOURNAL JR
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [EUCorp].[GrJournal]    Script Date: 08/05/2010 15:16:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUCorp].[GrJournal]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [EUCorp].[GrJournal]
AS
Select 
	''PERIOD=''+JR.PERIOD+''&REF=''+JR.REF+''&SOURCE=''+JR.SOURCE+''&SITEID=''+JR.SITEID+''&ITEM=''+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	1 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	''JOURNAL'' SourceTable,
	''EC'' SourceCode,
	JR.PERIOD Period,
	JR.ENTITYID RegionCode,
	JR.DEPARTMENT PropertyFundCode,
	--This looks strange, but its because in Corp: the jobcode is the same as the functionaldepartment
	JR.JOBCODE FunctionalDepartmentCode,
	JR.JOBCODE JobCode,
	JR.ACCTNUM GlAccountCode,
	JR.AMT Amount,
	JR.ENTRDATE EnterDate,
	JR.USERID [User],
	JR.DESCRPN [Description],
	JR.ADDLDESC AdditionalDescription,
	JR.BASIS Basis,
	JR.LASTDATE LastDate,
	RIGHT(RTRIM(JR.ACCTNUM),2) GlAccountSuffix,
	JR.OcurrCode,
	''N'' BALFOR,
	JR.SOURCE
From EUCorp.JOURNAL JR

--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [CNProp].[GrJournal]    Script Date: 08/05/2010 15:16:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNProp].[GrJournal]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [CNProp].[GrJournal]
AS
Select 
	''PERIOD=''+JR.PERIOD+''&REF=''+JR.REF+''&SOURCE=''+JR.SOURCE+''&SITEID=''+JR.SITEID+''&ITEM=''+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	1 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	''JOURNAL'' SourceTable,
	''CN'' SourceCode,
	JR.PERIOD Period,
	JR.ENTITYID PropertyFundCode,
	LEFT(JR.DEPARTMENT,3) RegionCode,
	SUBSTRING(JR.DEPARTMENT,4,DATALENGTH (JR.DEPARTMENT)-3) FunctionalDepartmentCode,
	JR.JOBCODE JobCode,
	JR.ACCTNUM GlAccountCode,
	JR.AMT Amount,
	JR.ENTRDATE EnterDate,
	JR.USERID [User],
	JR.DESCRPN [Description],
	JR.ADDLDESC AdditionalDescription,
	JR.BASIS Basis,
	CONVERT(DateTime,NULL,120) LastDate,
	RIGHT(RTRIM(JR.ACCTNUM),2) GlAccountSuffix,
	JR.CDEP CorporateDepartmentCode,
	''CNY'' OcurrCode,
	''N'' BALFOR,
	JR.SOURCE
From CNProp.JOURNAL JR
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [CNCorp].[GrJournal]    Script Date: 08/05/2010 15:16:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNCorp].[GrJournal]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [CNCorp].[GrJournal]
AS
Select 
	''PERIOD=''+JR.PERIOD+''&REF=''+JR.REF+''&SOURCE=''+JR.SOURCE+''&SITEID=''+JR.SITEID+''&ITEM=''+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	1 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	''JOURNAL'' SourceTable,
	''CC'' SourceCode,
	JR.PERIOD Period,
	JR.ENTITYID RegionCode,
	JR.DEPARTMENT PropertyFundCode,
	--This looks strange, but its because in Corp: the jobcode is the same as the functionaldepartment
	JR.JOBCODE FunctionalDepartmentCode,
	JR.JOBCODE JobCode,
	JR.ACCTNUM GlAccountCode,
	JR.AMT Amount,
	JR.ENTRDATE EnterDate,
	JR.USERID [User],
	JR.DESCRPN [Description],
	JR.ADDLDESC AdditionalDescription,
	JR.BASIS Basis,
	JR.LASTDATE LastDate,
	RIGHT(RTRIM(JR.ACCTNUM),2) GlAccountSuffix,
	''CNY'' OcurrCode,
	''N'' BALFOR,
	JR.SOURCE
From CNCorp.JOURNAL JR
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [BRProp].[GrJournal]    Script Date: 08/05/2010 15:16:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BRProp].[GrJournal]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [BRProp].[GrJournal]
AS
Select 
	''PERIOD=''+JR.PERIOD+''&REF=''+JR.REF+''&SOURCE=''+JR.SOURCE+''&SITEID=''+JR.SITEID+''&ITEM=''+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	1 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	''JOURNAL'' SourceTable,
	''BR'' SourceCode,
	JR.PERIOD Period,
	JR.ENTITYID PropertyFundCode,
	LEFT(JR.DEPARTMENT,3) RegionCode,
	SUBSTRING(JR.DEPARTMENT,4,DATALENGTH (JR.DEPARTMENT)-3) FunctionalDepartmentCode,
	JR.JOBCODE JobCode,
	JR.ACCTNUM GlAccountCode,
	JR.AMT Amount,
	JR.ENTRDATE EnterDate,
	JR.USERID [User],
	JR.DESCRPN [Description],
	'''' AdditionalDescription,
	JR.BASIS Basis,
	CONVERT(DateTime,NULL,120) LastDate,
	RIGHT(RTRIM(JR.ACCTNUM),2) GlAccountSuffix,
	JR.CDEP CorporateDepartmentCode,
	ISNULL(JR.OCURRCODE,''BRL'') OcurrCode,
	''N'' BALFOR,
	JR.SOURCE
From BRProp.JOURNAL JR
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [BRCorp].[GrJournal]    Script Date: 08/05/2010 15:16:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BRCorp].[GrJournal]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [BRCorp].[GrJournal]
AS
Select 
	''PERIOD=''+JR.PERIOD+''&REF=''+JR.REF+''&SOURCE=''+JR.SOURCE+''&SITEID=''+JR.SITEID+''&ITEM=''+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	1 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	''JOURNAL'' SourceTable,
	''BC'' SourceCode,
	JR.PERIOD Period,
	JR.ENTITYID RegionCode,
	JR.DEPARTMENT PropertyFundCode,
	--This looks strange, but its because in Corp: the jobcode is the same as the functionaldepartment
	JR.JOBCODE FunctionalDepartmentCode,
	JR.JOBCODE JobCode,
	JR.ACCTNUM GlAccountCode,
	JR.AMT Amount,
	JR.ENTRDATE EnterDate,
	JR.USERID [User],
	JR.DESCRPN [Description],
	JR.ADDLDESC AdditionalDescription,
	JR.BASIS Basis,
	JR.LASTDATE LastDate,
	RIGHT(RTRIM(JR.ACCTNUM),2) GlAccountSuffix,
	''BRL'' OcurrCode,
	''N'' BALFOR,
	JR.SOURCE
From BRCorp.JOURNAL JR
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [USProp].[GrGHis]    Script Date: 08/05/2010 15:16:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USProp].[GrGHis]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [USProp].[GrGHis]
AS
Select 
	''PERIOD=''+GHIS.PERIOD+''&REF=''+GHIS.REF+''&SOURCE=''+GHIS.SOURCE+''&SITEID=''+GHIS.SITEID+''&ITEM=''+LTRIM(STR(GHIS.ITEM,10,0)) SourcePrimaryKey,
	2 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	''GHIS'' SourceTable,
	''US'' SourceCode,
	GHIS.PERIOD Period,
	GHIS.ENTITYID PropertyFundCode,
	LEFT(GHIS.DEPARTMENT,3) RegionCode,
	SUBSTRING(GHIS.DEPARTMENT,4,DATALENGTH (GHIS.DEPARTMENT)-3) FunctionalDepartmentCode,
	GHIS.JOBCODE JobCode,
	GHIS.ACCTNUM GlAccountCode,
	GHIS.AMT Amount,
	GHIS.ENTRDATE EnterDate,
	'''' [User],
	GHIS.DESCRPN Description,
	GHIS.ADDLDESC AdditionalDescription,
	GHIS.BASIS Basis,
	CONVERT(DateTime,NULL,120) LastDate,
	RIGHT(RTRIM(GHIS.ACCTNUM),2) GlAccountSuffix,
	GHIS.CDEP CorporateDepartmentCode,
	''USD'' OcurrCode,
	GHIS.BALFOR,
	GHIS.SOURCE
From USProp.GHIS
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [USCorp].[GrGHis]    Script Date: 08/05/2010 15:16:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USCorp].[GrGHis]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [USCorp].[GrGHis]
AS
Select 
	''PERIOD=''+GHIS.PERIOD+''&REF=''+GHIS.REF+''&SOURCE=''+GHIS.SOURCE+''&SITEID=''+GHIS.SITEID+''&ITEM=''+LTRIM(STR(GHIS.ITEM,10,0)) SourcePrimaryKey,
	2 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	''GHIS'' SourceTable,
	''UC'' SourceCode,
	GHIS.PERIOD Period,
	GHIS.ENTITYID RegionCode,
	GHIS.DEPARTMENT PropertyFundCode,
	--This looks strange, but its because in Corp: the jobcode is the same as the functionaldepartment
	GHIS.JOBCODE FunctionalDepartmentCode,
	GHIS.JOBCODE JobCode,
	GHIS.ACCTNUM GlAccountCode,
	GHIS.AMT Amount,
	GHIS.ENTRDATE EnterDate,
	'''' [User],
	GHIS.DESCRPN [Description],
	GHIS.ADDLDESC AdditionalDescription,
	GHIS.BASIS Basis,
	CONVERT(DateTime,NULL,120) LastDate,
	RIGHT(RTRIM(GHIS.ACCTNUM),2) GlAccountSuffix,
	''USD'' OcurrCode,
	GHIS.BALFOR,
	GHIS.SOURCE
From USCorp.GHIS

--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [EUProp].[GrGHis]    Script Date: 08/05/2010 15:16:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUProp].[GrGHis]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [EUProp].[GrGHis]
AS
Select 
	''PERIOD=''+GHIS.PERIOD+''&REF=''+GHIS.REF+''&SOURCE=''+GHIS.SOURCE+''&SITEID=''+GHIS.SITEID+''&ITEM=''+LTRIM(STR(GHIS.ITEM,10,0)) SourcePrimaryKey,
	2 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	''GHIS'' SourceTable,
	''EU'' SourceCode,
	GHIS.PERIOD Period,
	GHIS.ENTITYID PropertyFundCode,
	LEFT(GHIS.DEPARTMENT,3) RegionCode,
	SUBSTRING(GHIS.DEPARTMENT,4,DATALENGTH (GHIS.DEPARTMENT)-3) FunctionalDepartmentCode,
	GHIS.JOBCODE JobCode,
	GHIS.ACCTNUM GlAccountCode,
	GHIS.AMT Amount,
	GHIS.ENTRDATE EnterDate,
	'''' [User],
	GHIS.DESCRPN [Description],
	GHIS.ADDLDESC AdditionalDescription,
	GHIS.BASIS Basis,
	CONVERT(DateTime,NULL,120) LastDate,
	RIGHT(RTRIM(GHIS.ACCTNUM),2) GlAccountSuffix,
	GHIS.CDEP CorporateDepartmentCode,
	GHIS.OcurrCode,
	GHIS.BALFOR,
	GHIS.SOURCE
From EUProp.GHIS
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [EUCorp].[GrGHis]    Script Date: 08/05/2010 15:16:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUCorp].[GrGHis]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [EUCorp].[GrGHis]
AS
Select 
	''PERIOD=''+GHIS.PERIOD+''&REF=''+GHIS.REF+''&SOURCE=''+GHIS.SOURCE+''&SITEID=''+GHIS.SITEID+''&ITEM=''+LTRIM(STR(GHIS.ITEM,10,0)) SourcePrimaryKey,
	2 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	''GHIS'' SourceTable,
	''EC'' SourceCode,
	GHIS.PERIOD Period,
	GHIS.ENTITYID RegionCode,
	GHIS.DEPARTMENT PropertyFundCode,
	--This looks strange, but its because in Corp: the jobcode is the same as the functionaldepartment
	GHIS.JOBCODE FunctionalDepartmentCode,
	GHIS.JOBCODE JobCode,
	GHIS.ACCTNUM GlAccountCode,
	GHIS.AMT Amount,
	GHIS.ENTRDATE EnterDate,
	'''' [User],
	GHIS.DESCRPN [Description],
	GHIS.ADDLDESC AdditionalDescription,
	GHIS.BASIS Basis,
	CONVERT(DateTime,NULL,120) LastDate,
	RIGHT(RTRIM(GHIS.ACCTNUM),2) GlAccountSuffix,
	GHIS.OcurrCode,
	GHIS.BALFOR,
	GHIS.SOURCE
From EUCorp.GHIS
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [CNProp].[GrGHis]    Script Date: 08/05/2010 15:16:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNProp].[GrGHis]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [CNProp].[GrGHis]
AS
Select 
	''PERIOD=''+GHIS.PERIOD+''&REF=''+GHIS.REF+''&SOURCE=''+GHIS.SOURCE+''&SITEID=''+GHIS.SITEID+''&ITEM=''+LTRIM(STR(GHIS.ITEM,10,0)) SourcePrimaryKey,
	2 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	''GHIS'' SourceTable,
	''CN'' SourceCode,
	GHIS.PERIOD Period,
	GHIS.ENTITYID PropertyFundCode,
	LEFT(GHIS.DEPARTMENT,3) RegionCode,
	SUBSTRING(GHIS.DEPARTMENT,4,DATALENGTH (GHIS.DEPARTMENT)-3) FunctionalDepartmentCode,
	GHIS.JOBCODE JobCode,
	GHIS.ACCTNUM GlAccountCode,
	GHIS.AMT Amount,
	GHIS.ENTRDATE EnterDate,
	GHIS.DESCRPN [Description],
	'''' [User],
	GHIS.ADDLDESC AdditionalDescription,
	GHIS.BASIS Basis,
	CONVERT(DateTime,NULL,120) LastDate,
	RIGHT(RTRIM(GHIS.ACCTNUM),2) GlAccountSuffix,
	GHIS.CDEP CorporateDepartmentCode,
	''CNY'' OcurrCode,
	GHIS.BALFOR,
	GHIS.SOURCE
From CNProp.GHIS
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [CNCorp].[GrGHis]    Script Date: 08/05/2010 15:16:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNCorp].[GrGHis]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [CNCorp].[GrGHis]
AS
Select 
	''PERIOD=''+GHIS.PERIOD+''&REF=''+GHIS.REF+''&SOURCE=''+GHIS.SOURCE+''&SITEID=''+GHIS.SITEID+''&ITEM=''+LTRIM(STR(GHIS.ITEM,10,0)) SourcePrimaryKey,
	2 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	''GHIS'' SourceTable,
	''CC'' SourceCode,
	GHIS.PERIOD Period,
	GHIS.ENTITYID RegionCode,
	GHIS.DEPARTMENT PropertyFundCode,
	--This looks strange, but its because in Corp: the jobcode is the same as the functionaldepartment
	GHIS.JOBCODE FunctionalDepartmentCode,
	GHIS.JOBCODE JobCode,
	GHIS.ACCTNUM GlAccountCode,
	GHIS.AMT Amount,
	GHIS.ENTRDATE EnterDate,
	GHIS.DESCRPN [Description],
	'''' [User],
	GHIS.ADDLDESC AdditionalDescription,
	GHIS.BASIS Basis,
	CONVERT(DateTime,NULL,120) LastDate,
	RIGHT(RTRIM(GHIS.ACCTNUM),2) GlAccountSuffix,
	''CNY'' OcurrCode,
	GHIS.BALFOR,
	GHIS.SOURCE
From CNCorp.GHIS
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  UserDefinedFunction [Gdm].[GLTranslationTypeActive]    Script Date: 08/05/2010 15:16:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLTranslationTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gdm].[GLTranslationTypeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GLTranslationType] Gl1
		INNER JOIN (
			SELECT 
				GLTranslationTypeId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GLTranslationType]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GLTranslationTypeId
		) t1 ON t1.GLTranslationTypeId = Gl1.GLTranslationTypeId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GLTranslationTypeId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[GLMinorCategoryActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [Gdm].[GLGlobalAccountTranslationTypeActive]    Script Date: 08/05/2010 15:16:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLGlobalAccountTranslationTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gdm].[GLGlobalAccountTranslationTypeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GLGlobalAccountTranslationType] Gl1
		INNER JOIN (
			SELECT 
				GLGlobalAccountTranslationTypeId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GLGlobalAccountTranslationType]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GLGlobalAccountTranslationTypeId
		) t1 ON t1.GLGlobalAccountTranslationTypeId = Gl1.GLGlobalAccountTranslationTypeId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GLGlobalAccountTranslationTypeId
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[GLMajorCategoryActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [Gdm].[GLGlobalAccountTranslationSubTypeActive]    Script Date: 08/05/2010 15:16:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLGlobalAccountTranslationSubTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gdm].[GLGlobalAccountTranslationSubTypeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GLGlobalAccountTranslationSubType] Gl1
		INNER JOIN (
			SELECT 
				GLGlobalAccountTranslationSubTypeId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GLGlobalAccountTranslationSubType]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GLGlobalAccountTranslationSubTypeId
		) t1 ON t1.GLGlobalAccountTranslationSubTypeId = Gl1.GLGlobalAccountTranslationSubTypeId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GLGlobalAccountTranslationSubTypeId
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[GLGlobalAccountGLAccountActive]    Script Date: 08/05/2010 15:16:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLGlobalAccountGLAccountActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gdm].[GLGlobalAccountGLAccountActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GLGlobalAccountGLAccount] Gl1
		INNER JOIN (
			SELECT 
				GLGlobalAccountGLAccountId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GLGlobalAccountGLAccount]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GLGlobalAccountGLAccountId
		) t1 ON t1.GLGlobalAccountGLAccountId = Gl1.GLGlobalAccountGLAccountId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GLGlobalAccountGLAccountId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[GLGlobalAccountActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [Gdm].[GLAccountTypeActive]    Script Date: 08/05/2010 15:16:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLAccountTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gdm].[GLAccountTypeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GLAccountType] Gl1
		INNER JOIN (
			SELECT 
				GLAccountTypeId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GLAccountType]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GLAccountTypeId
		) t1 ON t1.GLAccountTypeId = Gl1.GLAccountTypeId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GLAccountTypeId
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[GLAccountSubTypeActive]    Script Date: 08/05/2010 15:16:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLAccountSubTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [Gdm].[GLAccountSubTypeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GLAccountSubType] Gl1
		INNER JOIN (
			SELECT 
				GLAccountSubTypeId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GLAccountSubType]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GLAccountSubTypeId
		) t1 ON t1.GLAccountSubTypeId = Gl1.GLAccountSubTypeId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GLAccountSubTypeId
)

' 
END
GO
/****** Object:  UserDefinedFunction [USProp].[GDepActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [USCorp].[GDepActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [INProp].[GDepActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [INCorp].[GDepActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [EUProp].[GDepActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [EUCorp].[GDepActive]    Script Date: 08/05/2010 15:16:04 ******/
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
/****** Object:  UserDefinedFunction [CNProp].[GDepActive]    Script Date: 08/05/2010 15:16:04 ******/
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
/****** Object:  UserDefinedFunction [CNCorp].[GDepActive]    Script Date: 08/05/2010 15:16:04 ******/
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
/****** Object:  UserDefinedFunction [BRProp].[GDepActive]    Script Date: 08/05/2010 15:16:04 ******/
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
/****** Object:  UserDefinedFunction [BRCorp].[GDepActive]    Script Date: 08/05/2010 15:16:04 ******/
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
/****** Object:  UserDefinedFunction [USProp].[GJobActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [USCorp].[GJobActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [INCorp].[GJobActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [EUProp].[GJobActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [EUCorp].[GJobActive]    Script Date: 08/05/2010 15:16:04 ******/
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
/****** Object:  UserDefinedFunction [CNProp].[GJobActive]    Script Date: 08/05/2010 15:16:04 ******/
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
/****** Object:  UserDefinedFunction [CNCorp].[GJobActive]    Script Date: 08/05/2010 15:16:04 ******/
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
/****** Object:  UserDefinedFunction [BRCorp].[GJobActive]    Script Date: 08/05/2010 15:16:04 ******/
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
/****** Object:  UserDefinedFunction [GACS].[DepartmentActive]    Script Date: 08/05/2010 15:16:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GACS].[DepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [GACS].[DepartmentActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[GACS].[Department] Gl1
		INNER JOIN (
			SELECT 
				Department,
				Source,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[GACS].[Department]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY Department,
				Source
		) t1 ON t1.Department = Gl1.Department AND
				t1.Source = Gl1.Source AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.Department,
				Gl1.Source
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[BudgetReportGroupPeriodActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetReportGroupDetailActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetReportGroupActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetProjectActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetOverheadAllocationDetailActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetOverheadAllocationActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [Gdm].[BudgetExchangeRateDetailActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [Gdm].[BudgetExchangeRateActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetailActiveInner]    Script Date: 08/05/2010 15:16:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetailActiveInner]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetailActiveInner]
	(@DataPriorToDate DateTime)
RETURNS @Result TABLE 
	(BudgetEmployeePayrollAllocationDetailId Int NOT NULL,
	ImportBatchId Int NOT NULL)
AS
BEGIN 
	Insert Into @Result
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

RETURN
 END
' 
END
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetailActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartmentActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetEmployeeActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [TapasGlobal].[BillingUploadDetailActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [TapasGlobal].[BillingUploadActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [Gdm].[AllocationRegionActive]    Script Date: 08/05/2010 15:16:05 ******/
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
				AllocationRegionGlobalRegionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[AllocationRegion]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY AllocationRegionGlobalRegionId
		) t1 ON t1.AllocationRegionGlobalRegionId = Gl1.AllocationRegionGlobalRegionId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.AllocationRegionGlobalRegionId
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[AllocationSubRegionActive]    Script Date: 08/05/2010 15:16:05 ******/
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
				AllocationSubRegionGlobalRegionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[AllocationSubRegion]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY AllocationSubRegionGlobalRegionId
		) t1 ON t1.AllocationSubRegionGlobalRegionId = Gl1.AllocationSubRegionGlobalRegionId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.AllocationSubRegionGlobalRegionId
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[ActivityTypeActive]    Script Date: 08/05/2010 15:16:05 ******/
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
				ActivityTypeId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ActivityType]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY ActivityTypeId
		) t1 ON t1.ActivityTypeId = Gl1.ActivityTypeId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.ActivityTypeId	
)

' 
END
GO
/****** Object:  UserDefinedFunction [HR].[FunctionalDepartmentActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [Gdm].[EntityTypeActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [GACS].[EntityMappingActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BenefitOptionActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetStatusActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetTaxTypeActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [USProp].[EntityActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [USCorp].[EntityActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [INProp].[EntityActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [INCorp].[EntityActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [EUProp].[EntityActive]    Script Date: 08/05/2010 15:16:04 ******/
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
/****** Object:  UserDefinedFunction [EUCorp].[EntityActive]    Script Date: 08/05/2010 15:16:04 ******/
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
/****** Object:  UserDefinedFunction [CNProp].[EntityActive]    Script Date: 08/05/2010 15:16:04 ******/
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
/****** Object:  UserDefinedFunction [CNCorp].[EntityActive]    Script Date: 08/05/2010 15:16:04 ******/
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
/****** Object:  UserDefinedFunction [BRProp].[EntityActive]    Script Date: 08/05/2010 15:16:04 ******/
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
/****** Object:  UserDefinedFunction [BRCorp].[EntityActive]    Script Date: 08/05/2010 15:16:04 ******/
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
/****** Object:  UserDefinedFunction [USProp].[GAccActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [USCorp].[GAccActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [INProp].[GAccActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [INCorp].[GAccActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [EUProp].[GAccActive]    Script Date: 08/05/2010 15:16:05 ******/
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
/****** Object:  UserDefinedFunction [EUCorp].[GAccActive]    Script Date: 08/05/2010 15:16:04 ******/
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
/****** Object:  UserDefinedFunction [CNProp].[GAccActive]    Script Date: 08/05/2010 15:16:04 ******/
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
/****** Object:  UserDefinedFunction [CNCorp].[GAccActive]    Script Date: 08/05/2010 15:16:04 ******/
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
/****** Object:  UserDefinedFunction [BRProp].[GAccActive]    Script Date: 08/05/2010 15:16:04 ******/
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
/****** Object:  UserDefinedFunction [BRCorp].[GAccActive]    Script Date: 08/05/2010 15:16:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[GetGreatest]    Script Date: 08/05/2010 15:16:04 ******/
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
/****** Object:  UserDefinedFunction [Gr].[GetGlobalGlAccountCategoryTranslation]    Script Date: 08/05/2010 15:16:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetGlobalGlAccountCategoryTranslation]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

CREATE FUNCTION [Gr].[GetGlobalGlAccountCategoryTranslation]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT	
		TT.Name TranslationTypeName,
		TST.Name TranslationSubTypeName,
		CONVERT(VARCHAR(32), LTRIM(STR(TT.GLTranslationTypeId, 10, 0)) + '':'' + 
		LTRIM(STR(TST.GLTranslationSubTypeId, 10, 0)) + '':'' + 
		LTRIM(STR(MajC.GLMajorCategoryId, 10, 0)) + '':'' + 
		LTRIM(STR(MinC.GLMinorCategoryId, 10, 0)) + '':'' + 
		LTRIM(STR(AT.GLAccountTypeId, 10, 0)) + '':'' + 
		LTRIM(STR(AST.GLAccountSubTypeId, 10, 0))) GlobalAccountCategoryCode,
		MajC.GLMajorCategoryId,
		MajC.Name GLMajorCategoryName,
		MinC.GLMinorCategoryId,
		MinC.Name GLMinorCategoryName,
		CASE WHEN AT.Code LIKE ''%EXP%'' THEN ''EXPENSE'' 
			WHEN AT.Code LIKE ''%INC%'' THEN ''INCOME''
			ELSE ''UNKNOWN'' END as FeeOrExpense, -- sourced from Gdm.GlobalGlAccountCategoryHierarchy.AccountType
		AST.Name GLAccountSubTypeName, -- used to be ExpenseType, sourced from Gdm.GlobalGlAccountCategoryHierarchy.ExpenseType
		--GATT.GLGlobalAccountId GLGLobalAccountId,
		--GATST.GLGlobalAccountId GLGLobalAccountIdSub,
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
	
		INNER JOIN Gdm.GLGlobalAccount GLA ON
			GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId	
		
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
			
		INNER JOIN 	Gdm.GLGlobalAccountActive(@DataPriorToDate) GLAA ON
			GLAA.ImportKey = GLA.ImportKey	
			
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
		CASE WHEN AT.Code LIKE ''%EXP%'' THEN ''EXPENSE'' 
			WHEN AT.Code LIKE ''%INC%'' THEN ''INCOME''
			ELSE ''UNKNOWN'' END,
		AT.GLAccountTypeId,
		AST.Name,
		AST.GLAccountSubTypeId

	UNION ALL

	SELECT
		TT.Name TranslationTypeName,
		TST.Name TranslationSubTypeName,
		LTRIM(STR(TT.GLTranslationTypeId, 10, 0)) + '':'' + LTRIM(STR(TST.GLTranslationSubTypeId, 10, 0)) + '':-1:-1:-1:-1'',
		-1,
		''UNKNOWN'',
		-1,
		''UNKNOWN'',
		''UNKNOWN'',
		''UNKNOWN'',
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
)

' 
END
GO
/****** Object:  UserDefinedFunction [Gr].[GetFunctionalDepartmentExpanded]    Script Date: 08/05/2010 15:16:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetFunctionalDepartmentExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE   FUNCTION [Gr].[GetFunctionalDepartmentExpanded]
	()
RETURNS @Result TABLE 
	(
	FunctionalDepartmentId Int NOT NULL,
	ReferenceCode varchar(20) NULL,
	FunctionalDepartmentCode varchar(20) NOT NULL,
	FunctionalDepartmentName Varchar(50) NOT NULL,
	SubFunctionalDepartmentCode varchar(20) NOT NULL,
	SubFunctionalDepartmentName Varchar(100) NOT NULL,
	UpdatedDate DateTime NOT NULL
	)
AS
BEGIN 
DECLARE @DataPriorToDate	DateTime


SET @DataPriorToDate = CONVERT(DateTime,(Select t1.ConfiguredValue From GrReportingStaging.dbo.SSISConfigurations t1 where ConfigurationFilter = ''DataPriorToDate''),103)

Insert Into @Result
(FunctionalDepartmentId, ReferenceCode,FunctionalDepartmentCode,FunctionalDepartmentName,SubFunctionalDepartmentCode,SubFunctionalDepartmentName,UpdatedDate)
Select 
		Fd.FunctionalDepartmentId,
		Fd.GlobalCode+'':'',
		Fd.GlobalCode FunctionalDepartmentCode,
		Fd.Name FunctionalDepartmentName,
		Fd.GlobalCode SubFunctionalDepartmentCode,
		RTRIM(Fd.GlobalCode) + '' - '' + Fd.Name SubFunctionalDepartmentName,
		Fd.UpdatedDate
FROM HR.FunctionalDepartment Fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FdA ON FdA.ImportKey = Fd.ImportKey
Where Fd.GlobalCode IS NOT NULL

Insert Into @Result
(FunctionalDepartmentId, ReferenceCode,FunctionalDepartmentCode,FunctionalDepartmentName,SubFunctionalDepartmentCode,SubFunctionalDepartmentName,UpdatedDate)
Select 
		T2.FunctionalDepartmentId,
		T1.FunctionalDepartmentCode+'':''+T2.Code,
		T1.FunctionalDepartmentCode,
		T1.FunctionalDepartmentName,
		T2.Code,
		RTRIM(T2.Code) + '' - '' + T2.Description,
		T2.UpdatedDate
From	
		@Result T1
			INNER JOIN 
						(
							Select 
									--Jc.Source,
									Jc.JobCode Code,
									Max(Jc.Description) as Description,
									Max(Jc.FunctionalDepartmentId) as FunctionalDepartmentId,
									Max(Jc.UpdatedDate) as UpdatedDate
							From GACS.JobCode Jc
								INNER JOIN GACS.JobCodeActive(@DataPriorToDate) JcA ON JcA.ImportKey = Jc.ImportKey
							Where Jc.FunctionalDepartmentId IS NOT NULL
							Group By --TODO. As per AW advice job code will never be map to functional departments for day 1, we will address a change in this when the time comes.
									Jc.JobCode
							
						) T2 ON T2.FunctionalDepartmentId = T1.FunctionalDepartmentId
						AND T2.Code <> T1.FunctionalDepartmentCode

Order By T1.FunctionalDepartmentCode

--Add All the Parent FunctionalDepartments with UNKNOWN SubFunctionalDepartment, (that have a GlobalCode)
Insert Into @Result
(FunctionalDepartmentId, ReferenceCode,FunctionalDepartmentCode,FunctionalDepartmentName,SubFunctionalDepartmentCode,SubFunctionalDepartmentName,UpdatedDate)
Select 
		Fd.FunctionalDepartmentId,
		Fd.GlobalCode+'':UNKNOWN'',
		Fd.GlobalCode FunctionalDepartmentCode,
		Fd.Name FunctionalDepartmentName,
		''UNKNOWN'' SubFunctionalDepartmentCode,
		''UNKNOWN'' SubFunctionalDepartmentName,
		Fd.UpdatedDate
FROM HR.FunctionalDepartment Fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FdA ON FdA.ImportKey = Fd.ImportKey
Where Fd.GlobalCode IS NOT NULL

RETURN
END

' 
END
GO
/****** Object:  View [USProp].[GeneralLedger]    Script Date: 08/05/2010 15:16:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USProp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [USProp].[GeneralLedger]
AS
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source
From USProp.GrGHis
--NO Where clauses allowed here, that should be in relevant stp
UNION ALL
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableId,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source
From USProp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [USCorp].[GeneralLedger]    Script Date: 08/05/2010 15:16:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USCorp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [USCorp].[GeneralLedger]
AS
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	OcurrCode,
	Balfor,
	Source
From USCorp.GrGHis
--NO Where clauses allowed here, that should be in relevant stp
UNION ALL
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	OcurrCode,
	Balfor,
	Source
From USCorp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [INProp].[GeneralLedger]    Script Date: 08/05/2010 15:16:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[INProp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [INProp].[GeneralLedger]
AS
-- Integration Databases will not have a GHIS table, for no closing process will run that move
-- the journal entries to GHIS
/*
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	Description,
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source
From INProp.GrGHis
--NO Where clauses allowed here, that should be in relevant stp
UNION ALL
*/
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source
From INProp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [INCorp].[GeneralLedger]    Script Date: 08/05/2010 15:16:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[INCorp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [INCorp].[GeneralLedger]
AS
-- Integration Databases will not have a GHIS table, for no closing process will run that move
-- the journal entries to GHIS
/*
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	OcurrCode,
	Balfor,
	Source
From INCorp.GrGHis
--NO Where clauses allowed here, that should be in relevant stp
UNION ALL
*/
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	OcurrCode,
	Balfor,
	Source
From INCorp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [EUProp].[GeneralLedger]    Script Date: 08/05/2010 15:16:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUProp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [EUProp].[GeneralLedger]
AS
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source
From EUProp.GrGHis
--NO Where clauses allowed here, that should be in relevant stp
UNION ALL
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source
From EUProp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [EUCorp].[GeneralLedger]    Script Date: 08/05/2010 15:16:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUCorp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [EUCorp].[GeneralLedger]
AS
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	OcurrCode,
	Balfor,
	Source
From EUCorp.GrGHis
UNION ALL
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	OcurrCode,
	Balfor,
	Source
From EUCorp.GrJournal

'
GO
/****** Object:  View [CNProp].[GeneralLedger]    Script Date: 08/05/2010 15:16:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNProp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [CNProp].[GeneralLedger]
AS
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source
From CNProp.GrGHis
--NO Where clauses allowed here, that should be in relevant stp
UNION ALL
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source
From CNProp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [CNCorp].[GeneralLedger]    Script Date: 08/05/2010 15:16:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNCorp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [CNCorp].[GeneralLedger]
AS
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	OcurrCode,
	Balfor,
	Source
From CNCorp.GrGHis
--NO Where clauses allowed here, that should be in relevant stp

UNION ALL
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	OcurrCode,
	Balfor,
	Source
From CNCorp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [BRProp].[GeneralLedger]    Script Date: 08/05/2010 15:16:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BRProp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [BRProp].[GeneralLedger]
AS
-- Integration Databases will not have a GHIS table, for no closing process will run that move
-- the journal entries to GHIS
/*
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source
From BRProp.GrGHis
--NO Where clauses allowed here, that should be in relevant stp
UNION ALL
*/
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source
From BRProp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [BRCorp].[GeneralLedger]    Script Date: 08/05/2010 15:16:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BRCorp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [BRCorp].[GeneralLedger]
AS
-- Integration Databases will not have a GHIS table, for no closing process will run that move
-- the journal entries to GHIS
/*
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	OcurrCode,
	Balfor,
	Source
From BRCorp.GrGHis
--NO Where clauses allowed here, that should be in relevant stp

UNION ALL
*/
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	OcurrCode,
	Balfor,
	Source
From BRCorp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyCorporateReforecast]    Script Date: 08/05/2010 15:16:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyCorporateReforecast]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyCorporateReforecast]
	@ImportStartDate	DateTime,
	@ImportEndDate		DateTime,
	@DataPriorToDate	DateTime=NULL
AS

SET NOCOUNT ON
IF @DataPriorToDate IS NULL 
	SET @DataPriorToDate = GETDATE()

PRINT ''####''
PRINT ''stp_IU_LoadGrProfitabiltyCorporateReforecast''
PRINT ''####''
--*/

/*
[stp_IU_LoadGrProfitabiltyCorporateReforecast]
	@ImportStartDate	= ''1900-01-01'',
	@ImportEndDate		= ''2010-12-31'',
	@DataPriorToDate	= ''2010-12-31''
*/ 

DECLARE 
      @GlAccountKey				Int = (Select GlAccountKey From GrReporting.dbo.GlAccount WHERE Code = ''UNKNOWN''),
      @SourceKey				Int = (Select SourceKey From GrReporting.dbo.Source Where SourceName = ''UNKNOWN''),
      @FunctionalDepartmentKey	Int = (Select FunctionalDepartmentKey From GrReporting.dbo.FunctionalDepartment Where FunctionalDepartmentCode = ''UNKNOWN''),
      @ReimbursableKey			Int = (Select ReimbursableKey From GrReporting.dbo.Reimbursable Where ReimbursableCode = ''UNKNOWN''),
      @ActivityTypeKey			Int = (Select ActivityTypeKey From GrReporting.dbo.ActivityType Where ActivityTypeCode = ''UNKNOWN''),
      @PropertyFundKey			Int = (Select PropertyFundKey From GrReporting.dbo.PropertyFund Where PropertyFundName = ''UNKNOWN''),
      @AllocationRegionKey		Int = (Select AllocationRegionKey From GrReporting.dbo.AllocationRegion Where RegionCode = ''UNKNOWN''),
      @OriginatingRegionKey		Int = (Select OriginatingRegionKey From GrReporting.dbo.OriginatingRegion Where RegionCode = ''UNKNOWN''),
      @LocalCurrencyKey			Int = (Select CurrencyKey From GrReporting.dbo.Currency Where CurrencyCode = ''UNKNOWN'')

DECLARE
		@EUFundGlAccountCategoryKeyUnknown				Int,
		@EUCorporateGlAccountCategoryKeyUnknown			Int,
		@EUPropertyGlAccountCategoryKeyUnknown			Int,
		@USFundGlAccountCategoryKeyUnknown				Int,
		@USPropertyGlAccountCategoryKeyUnknown			Int,
		@USCorporateGlAccountCategoryKeyUnknown			Int,
		@DevelopmentGlAccountCategoryKeyUnknown			Int,
		@GlobalGlAccountCategoryKeyUnknown				Int
		
SET @EUFundGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Fund Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @EUCorporateGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Corporate Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @EUPropertyGlAccountCategoryKeyUnknown  = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Property Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @USFundGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Fund Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @USPropertyGlAccountCategoryKeyUnknown  = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Property Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @USCorporateGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Corporate Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @DevelopmentGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''Development Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @GlobalGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global'' AND TranslationSubTypeName = ''Global'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')

DECLARE @SourceSystemId int
SET @SourceSystemId = 1 -- Corporate budgeting source system

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Source Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

------------------------------------------------------------------------------------------------------
--Source allocation records
------------------------------------------------------------------------------------------------------

PRINT ''Start''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget line item.
SELECT
	CAST(Budget.BudgetYear AS VARCHAR(4)) + CASE Budget.BudgetPeriodCode 
												WHEN ''Q1'' THEN CASE WHEN Budget.BudgetYear = 2010 THEN ''03'' /*March isn Q1 start in 2010 - Ask Mike Caracciolo why*/ ELSE ''04'' END --Q1 - April (04)
												WHEN ''Q2'' THEN ''06'' --Q2 - June (06)
												WHEN ''Q3'' THEN ''10'' --Q3 - Oct (10)
												ELSE ''01'' -- Default to Q0 Jan (01)
											END as FirstProjectedPeriod,
	Budget.*
INTO
	#Budget
FROM
	BudgetingCorp.GlobalReportingCorporateBudget Budget
	INNER JOIN BudgetingCorp.GlobalReportingCorporateBudgetActive(@DataPriorToDate) BudgetA ON
		Budget.ImportKey = BudgetA.ImportKey
WHERE
	Budget.LockedDate IS NOT NULL AND
	Budget.LockedDate BETWEEN @ImportStartDate AND @ImportEndDate AND
	Budget.BudgetPeriodCode <> ''Q0'' -- Reforecast budget values only

PRINT ''Rows Inserted into #Budget::''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
------------------------------------------------------------------------------------------------------
--Source associated records
------------------------------------------------------------------------------------------------------

-- Source Gl Account
SELECT
	gla.*
INTO
	#GlAccount
FROM
	Gdm.GlGlobalAccount gla
	INNER JOIN Gdm.GlGlobalAccountActive(@DataPriorToDate) glaA ON
		gla.ImportKey = glaA.ImportKey 

PRINT ''Rows Inserted into #GlAccount::''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Functional Department
SELECT 
	fd.* 
INTO
	#FunctionalDepartment
FROM 
	HR.FunctionalDepartment fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) fdA ON
		fd.ImportKey = fdA.ImportKey

PRINT ''Rows Inserted into #FunctionalDepartment:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Activity Type
SELECT
	at.*
INTO
	#ActivityType
FROM
	Gdm.ActivityType at
	INNER JOIN Gdm.ActivityTypeActive(@DataPriorToDate) atA ON
		at.ImportKey = atA.ImportKey

PRINT ''Rows Inserted into #ActvityType:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source originating region
SELECT
	gr.*
INTO
	#GlobalRegion
FROM
	Gdm.GlobalRegion gr
	INNER JOIN Gdm.GlobalRegionActive(@DataPriorToDate) grA ON
		gr.ImportKey = grA.ImportKey 

PRINT ''Rows Inserted into #GlobalRegion:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Property Fund Mapping (untill the switch over to GBS all budgets sourced from the grinder will use old mappings)
SELECT 
	PropertyFundMapping.* 
INTO
	#PropertyFundMapping
FROM 
	Gdm.PropertyFundMapping PropertyFundMapping
	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PropertyFundMappingA ON
		PropertyFundMapping.ImportKey = PropertyFundMappingA.ImportKey 

PRINT ''Rows Inserted into #PropertyFundMapping:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFundMapping (PropertyFundCode,SourceCode,IsDeleted,PropertyFundId,ActivityTypeId)

-- Source Property Fund
SELECT 
	PropertyFund.* 
INTO
	#PropertyFund
FROM 
	Gdm.PropertyFund PropertyFund
	INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PropertyFundA ON
		PropertyFund.ImportKey = PropertyFundA.ImportKey 

PRINT ''Completed inserting records into #PropertyFund:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFund (PropertyFundId)
PRINT ''Completed creating indexes on #PropertyFund''
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE TABLE #GLTranslationType(
	ImportKey INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLTranslationSubType(
	ImportKey INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsGRDefault BIT NOT NULL
)

CREATE TABLE #GLGlobalAccountTranslationType(
	ImportKey INT NOT NULL,
	GLGlobalAccountTranslationTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLGlobalAccountTranslationSubType(
	ImportKey INT NOT NULL,
	GLGlobalAccountTranslationSubTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	PostingPropertyGLAccountCode VARCHAR(14) NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMajorCategory(
	ImportKey INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMinorCategory(
	ImportKey INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

-- #GLGlobalAccountTranslationType

INSERT INTO
	#GLGlobalAccountTranslationType (ImportKey, GLGlobalAccountTranslationTypeId, GLGlobalAccountId, GLTranslationTypeId, GLAccountTypeId,
	GLAccountSubTypeId, IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	GATT.ImportKey, GATT.GLGlobalAccountTranslationTypeId, GATT.GLGlobalAccountId, GATT.GLTranslationTypeId, GATT.GLAccountTypeId,
	GATT.GLAccountSubTypeId, GATT.IsActive, GATT.InsertedDate, GATT.UpdatedDate, GATT.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccountTranslationType GATT
	INNER JOIN Gdm.GLGlobalAccountTranslationTypeActive(@DataPriorToDate) GATTA ON
		GATTA.ImportKey = GATT.ImportKey

-- #GLGlobalAccountTranslationSubType

INSERT INTO
	#GLGlobalAccountTranslationSubType (ImportKey, GLGlobalAccountTranslationSubTypeId, GLGlobalAccountId, GLTranslationSubTypeId, GLMinorCategoryId,
	PostingPropertyGLAccountCode, IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	GATST.ImportKey, GATST.GLGlobalAccountTranslationSubTypeId, GATST.GLGlobalAccountId, GATST.GLTranslationSubTypeId, GATST.GLMinorCategoryId,
	GATST.PostingPropertyGLAccountCode, GATST.IsActive, GATST.InsertedDate, GATST.UpdatedDate, GATST.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccountTranslationSubType GATST
	INNER JOIN Gdm.GLGlobalAccountTranslationSubTypeActive(@DataPriorToDate) GATSTA ON
		GATSTA.ImportKey = GATST.ImportKey

-- #GLTranslationType

INSERT INTO
	#GLTranslationType (ImportKey, GLTranslationTypeId, Code, [Name], [Description], IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	TT.ImportKey, TT.GLTranslationTypeId, TT.Code, TT.[Name], TT.[Description], TT.IsActive, TT.InsertedDate, TT.UpdatedDate, TT.UpdatedByStaffId
FROM
	Gdm.GLTranslationType TT
	INNER JOIN Gdm.GLTranslationTypeActive(@DataPriorToDate) TTA ON
		TTA.ImportKey = TT.ImportKey

-- #GLTranslationSubType

INSERT INTO
	#GLTranslationSubType (ImportKey, GLTranslationSubTypeId, GLTranslationTypeId, Code, [Name], IsActive, InsertedDate, UpdatedDate,
	UpdatedByStaffId, IsGRDefault)
SELECT
	TST.ImportKey, TST.GLTranslationSubTypeId, TST.GLTranslationTypeId, TST.Code, TST.[Name], TST.IsActive, TST.InsertedDate, TST.UpdatedDate,
	TST.UpdatedByStaffId, TST.IsGRDefault
FROM
	Gdm.GLTranslationSubType TST
	INNER JOIN Gdm.GLTranslationSubTypeActive(@DataPriorToDate) TSTA ON
		TSTA.ImportKey = TST.ImportKey

-- #GLMajorCategory

INSERT INTO
	#GLMajorCategory (ImportKey, GLMajorCategoryId, GLTranslationSubTypeId, [Name], IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	MajC.ImportKey, MajC.GLMajorCategoryId, MajC.GLTranslationSubTypeId, MajC.[Name], MajC.IsActive, MajC.InsertedDate, MajC.UpdatedDate, MajC.UpdatedByStaffId
FROM
	Gdm.GLMajorCategory MajC
	INNER JOIN Gdm.GLMajorCategoryActive(@DataPriorToDate) MajCA ON
		MajC.ImportKey = MajCA.ImportKey

-- #GLMinorCategory

INSERT INTO
	#GLMinorCategory (ImportKey, GLMinorCategoryId, GLMajorCategoryId, [Name], IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	Minc.ImportKey, Minc.GLMinorCategoryId, Minc.GLMajorCategoryId, Minc.[Name], Minc.IsActive, Minc.InsertedDate, Minc.UpdatedDate, Minc.UpdatedByStaffId
FROM
	Gdm.GLMinorCategory MinC
	INNER JOIN Gdm.GLMinorCategoryActive(@DataPriorToDate) MinCA ON
		MinCA.ImportKey = MinC.ImportKey


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Map Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

--Map reforecast budget Amounts
CREATE TABLE #ProfitabilitySource
(
	BudgetId int NOT NULL,
	ReferenceCode varchar(300) NOT NULL,
	FirstProjectedPeriod char(6) NOT NULL,
	ExpensePeriod char(6) NOT NULL,	
	SourceCode varchar(2) NULL,
	ReforecastAmount money NOT NULL,
	GlGlobalAccountCode varchar(21) NOT NULL,
	GlGlobalAccountId int NOT NULL,
	FunctionalDepartmentCode varchar(31) NULL,
	FunctionalDepartmentId int NULL,
	JobCode varchar(20) NULL,
	Reimbursable bit NULL,
	ActivityTypeCode varchar(10) NULL,
	ActivityTypeId int NOT NULL,
	PropertyFundId int NULL,
	AllocationSubRegionGlobalRegionId int NOT NULL,
	OriginatingRegionCode char(6) NULL,
	OriginatingGlobalRegionId int NULL,
	LocalCurrencyCode char(3) NOT NULL,
	LockedDate datetime NOT NULL,
	IsExpense bit NOT NULL
)
-- Insert reforecast budget amounts
INSERT INTO #ProfitabilitySource
(
	BudgetId,
	ReferenceCode,
	FirstProjectedPeriod,
	ExpensePeriod,
	SourceCode,
	ReforecastAmount,
	GlGlobalAccountCode,
	GlGlobalAccountId,
	FunctionalDepartmentCode,
	FunctionalDepartmentId,
	JobCode,
	Reimbursable,
	ActivityTypeCode,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingGlobalRegionId,
	LocalCurrencyCode,
	LockedDate,
	IsExpense
)

SELECT 
	b.BudgetId,
	''BC:'' + b.SourceUniqueKey + ''&ImportKey='' + CONVERT(varchar, b.ImportKey) as ReferenceCode,
	b.FirstProjectedPeriod,
	b.Period as ExpensePeriod,
	b.SourceCode,
	b.LocalAmount as ReforecastAmount,
	CONVERT(varchar,b.GlobalGlAccountCode) as GlGlobalAccountCode,
	IsNull(gla.GLGlobalAccountId,-1) as GlGlobalAccountId,
	b.FunctionalDepartmentGlobalCode as FunctionalDepartmentCode,
	IsNull(fd.FunctionalDepartmentId,-1),
	b.JobCode,
	b.IsReimbursable as Reimbursable,
	at.ActivityTypeCode,
	IsNull(at.ActivityTypeId,-1),
	pfm.PropertyFundId,
	IsNull(DepartmentPropertyFund.AllocationSubRegionGlobalRegionId,-1) as ProjectRegionId,
	b.OriginatingSubRegionCode as OriginatingRegionCode,
	IsNull(gr.GlobalRegionId,-1) as OriginatingGlobalRegionId,
	b.InternationalCurrencyCode as LocalCurrencyCode,
	b.LockedDate,
	b.IsExpense
FROM
	#Budget b 
	
	LEFT OUTER JOIN #GlAccount gla ON
		b.GlobalGlAccountCode = gla.Code
		
	LEFT OUTER JOIN #FunctionalDepartment fd ON
		b.FunctionalDepartmentGlobalCode = fd.GlobalCode
		
	LEFT OUTER JOIN #ActivityType at ON
		gla.ActivityTypeId = at.ActivityTypeId
		
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON GrSc.SourceCode = b.SourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		b.NonPayrollCorporateMRIDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		b.SourceCode = pfm.SourceCode AND 
		(
			(GrSc.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL) OR
			(
				(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId = at.ActivityTypeId) OR
				(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND at.ActivityTypeId IS NULL)
			)
		) AND
		pfm.IsDeleted = 0
		
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		pfm.PropertyFundId = DepartmentPropertyFund.PropertyFundId
		
	LEFT OUTER JOIN #GlobalRegion gr ON
		b.OriginatingSubRegionCode = gr.Code

WHERE
	b.LocalAmount <> 0 --AND
	--(b.Period >= b.FirstProjectedPeriod OR b.FirstProjectedPeriod = ''201003'') -- Get only reforecasted budgeted amounts 
	--(UPDATED: Hack the planet: Now also source actuals for non payroll (including fees) for reforecast Q1, 201003 from the grinder (Yes Q1 201003 - Ask MikeC))


PRINT ''Rows Inserted into #ProfitabilitySource:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)



-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Map mapped source data into the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

------------------------------------------------------------------------------------------------------
-- Additional required mappings
------------------------------------------------------------------------------------------------------

-- See hack below. 
SELECT
	asr.*
INTO
	#AllocationSubRegion
FROM
	Gdm.AllocationSubRegion asr
	INNER JOIN Gdm.AllocationSubRegionActive(@DataPriorToDate) asrA ON
		asr.ImportKey = asrA.ImportKey
		
PRINT ''Rows Inserted into #AllocationSubRegion''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--If the join is not possible, default the link to the ''UNKNOWN'' link
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityReforecast(
	CalendarKey int NOT NULL,
	ReforecastKey int NOT NULL,
	GlAccountKey int NOT NULL,
	SourceKey int NOT NULL,
	FunctionalDepartmentKey int NOT NULL,
	ReimbursableKey int NOT NULL,
	ActivityTypeKey int NOT NULL,
	PropertyFundKey int NOT NULL,	
	AllocationRegionKey int NOT NULL,
	OriginatingRegionKey int NOT NULL,
	LocalCurrencyKey int NOT NULL,
	LocalReforecast money NOT NULL,
	ReferenceCode Varchar(300) NOT NULL,
	BudgetId int NOT NULL,
	SourceSystemId int NOT NULL,

	EUCorporateGlAccountCategoryKey int NULL,
	EUPropertyGlAccountCategoryKey int NULL,
	EUFundGlAccountCategoryKey int NULL,

	USPropertyGlAccountCategoryKey int NULL,
	USCorporateGlAccountCategoryKey int NULL,
	USFundGlAccountCategoryKey int NULL,

	GlobalGlAccountCategoryKey int NULL,
	DevelopmentGlAccountCategoryKey int NULL
) 

INSERT INTO #ProfitabilityReforecast 
(
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	SourceSystemId
)
SELECT
		DATEDIFF(dd, ''1900-01-01'', LEFT(ps.ExpensePeriod,4)+''-''+RIGHT(ps.ExpensePeriod,2)+''-01'') as CalendarKey
		,DATEDIFF(dd, ''1900-01-01'', LEFT(ps.FirstProjectedPeriod,4)+''-''+RIGHT(ps.FirstProjectedPeriod,2)+''-01'') as ReforecastKey
		,CASE WHEN GrGl.[GlAccountKey] IS NULL THEN @GlAccountKey ELSE GrGl.[GlAccountKey] END GlAccountKey
		,CASE WHEN GrSc.[SourceKey] IS NULL THEN @SourceKey ELSE GrSc.[SourceKey] END SourceKey
		,CASE WHEN ISNULL(GrFdmD.[FunctionalDepartmentKey], GrFdmP.[FunctionalDepartmentKey]) IS NULL THEN @FunctionalDepartmentKey ELSE ISNULL(GrFdmD.[FunctionalDepartmentKey], GrFdmP.[FunctionalDepartmentKey]) END FunctionalDepartmentKey
		,CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKey ELSE GrRi.ReimbursableKey END ReimbursableKey
		,CASE WHEN GrAt.[ActivityTypeKey] IS NULL THEN @ActivityTypeKey ELSE GrAt.[ActivityTypeKey] END ActivityTypeKey
		,CASE WHEN GrPf.[PropertyFundKey] IS NULL THEN @PropertyFundKey ELSE GrPf.[PropertyFundKey] END PropertyFundKey
		,CASE WHEN GrAr.[AllocationRegionKey] IS NULL THEN @AllocationRegionKey ELSE GrAr.[AllocationRegionKey] END AllocationRegionKey
		,CASE WHEN IsNull(ps.IsExpense,-1) = 0 THEN 
			CASE WHEN GrOrFee.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKey ELSE GrOrFee.[OriginatingRegionKey] END 
		 ELSE 
			CASE WHEN GrOr.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKey ELSE GrOr.[OriginatingRegionKey] END 
		 END OriginatingRegionKey
		,CASE WHEN GrCu.[CurrencyKey] IS NULL THEN @LocalCurrencyKey ELSE GrCu.[CurrencyKey] END LocalCurrencyKey
		,ps.ReforecastAmount
		,ps.ReferenceCode
		,ps.BudgetId
		,@SourceSystemId
FROM
	#ProfitabilitySource ps
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccount GrGl ON
		ps.GlGlobalAccountId = GrGl.GlGlobalAccountId AND
		ps.LockedDate BETWEEN GrGl.StartDate AND GrGl.EndDate
	
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON
		ps.SourceCode = GrSc.SourceCode

	--Detail/Sub Level (job level)
	LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdmD ON
		ps.LockedDate  BETWEEN GrFdmD.StartDate AND GrFdmD.EndDate AND
		GrFdmD.SubFunctionalDepartmentCode <> GrFdmD.FunctionalDepartmentCode AND
		--GrFdmD.ReferenceCode LIKE ''%:''+ ps.JobCode --new substitude below
		GrFdmD.SubFunctionalDepartmentCode = ps.JobCode
			
	--Parent Level
	LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdmP ON
		ps.LockedDate  BETWEEN GrFdmP.StartDate AND GrFdmP.EndDate AND
		GrFdmP.SubFunctionalDepartmentCode = GrFdmP.FunctionalDepartmentCode AND
		--GrFdmP.ReferenceCode LIKE ps.FunctionalDepartmentCode +'':%'' --new substitude below
		GrFdmP.FunctionalDepartmentCode = ps.FunctionalDepartmentCode
		
	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		CASE WHEN ps.Reimbursable = 1 THEN ''YES'' ELSE ''NO'' END = GrRi.ReimbursableCode

	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		ps.ActivityTypeId = GrAt.ActivityTypeId AND
		ps.LockedDate BETWEEN GrAt.StartDate AND GrAt.EndDate

	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		ps.PropertyFundId = GrPf.PropertyFundId AND
		ps.LockedDate BETWEEN GrPf.StartDate AND GrPf.EndDate

	LEFT OUTER JOIN #AllocationSubRegion Asr ON
		ps.AllocationSubRegionGlobalRegionId = Asr.AllocationSubRegionGlobalRegionId AND
		Asr.IsActive = 1

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		Asr.AllocationSubRegionGlobalRegionId = GrAr.GlobalRegionId AND
		ps.LockedDate BETWEEN GrAr.StartDate AND GrAr.EndDate

	-- This is only used for fees. It sets the originating region to the allocation region
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOrFee ON
		Asr.AllocationSubRegionGlobalRegionId = GrOrFee.GlobalRegionId AND
		ps.LockedDate BETWEEN GrOrFee.StartDate AND GrOrFee.EndDate


	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		ps.OriginatingRegionCode = GrOr.SubRegionCode AND
		ps.LockedDate BETWEEN GrOr.StartDate AND GrOr.EndDate

	LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
		ps.LocalCurrencyCode = GrCu.CurrencyCode 


PRINT ''Rows Inserted into #ProfitabilityReforecast:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_GlAcocuntKey ON #ProfitabilityReforecast (GlAccountKey)
PRINT ''Created Index on GlAccountKey #ProfitabilityReforecast''
PRINT CONVERT(Varchar(27), getdate(), 121)

-------------------------------------------------------------------------------------------------------------------
		
--GlobalGlAccountCategoryKey
UPDATE
	#ProfitabilityReforecast
SET
	GlobalGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM #ProfitabilityReforecast Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = ''GL'' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))


PRINT ''Completed converting all GlobalGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

/*
-- EUCorporateGlAccountCategoryKey
UPDATE
	#ProfitabilityReforecast
SET
	EUCorporateGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUCorporateGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END 
FROM
	#ProfitabilityReforecast Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = ''EU CORP'' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))

		
			
PRINT ''Completed converting all EUCorporateGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--EUPropertyGlAccountCategoryKey
UPDATE
	#ProfitabilityReforecast
SET
	EUPropertyGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUPropertyGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityReforecast Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = ''EU PROP'' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))


PRINT ''Completed converting all EUPropertyGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)


--EUFundGlAccountCategoryKey
UPDATE
	#ProfitabilityReforecast
SET
	EUFundGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUFundGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityReforecast Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = ''EU FUND'' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))

	
PRINT ''Completed converting all EUFundGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USPropertyGlAccountCategoryKey
UPDATE
	#ProfitabilityReforecast
SET
	USPropertyGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USPropertyGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityReforecast Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = ''US PROP'' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))


PRINT ''Completed converting all USPropertyGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USCorporateGlAccountCategoryKey
UPDATE
	#ProfitabilityReforecast
SET
	USCorporateGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USCorporateGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
From #ProfitabilityReforecast Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = ''US CORP'' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))

	
PRINT ''Completed converting all USCorporateGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USFundGlAccountCategoryKey
UPDATE
	#ProfitabilityReforecast
SET
	USFundGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USFundGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityReforecast Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = ''US FUND'' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))


PRINT ''Completed converting all USFundGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--DevelopmentGlAccountCategoryKey
UPDATE
	#ProfitabilityReforecast
SET
	DevelopmentGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @DevelopmentGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM #ProfitabilityReforecast Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = ''DEV'' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))

	
PRINT ''Completed converting all DevelopmentGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
*/

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Remove existing data for modified reforecast budget projects
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #DeletingBudget
(
	BudgetId int NOT NULL
)

INSERT INTO #DeletingBudget
(
	BudgetId
)
SELECT DISTINCT 
	BudgetId
FROM
	#ProfitabilityReforecast

PRINT ''Rows Inserted into #DeletingReforecast:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Remove 
DECLARE @BudgetId int = -1
DECLARE @LoopCount int = 0 -- Infinite loop safe guard
WHILE (EXISTS (SELECT TOP 1 BudgetId FROM #DeletingBudget) AND @LoopCount < 100000)
BEGIN
	
	SET @LoopCount = @LoopCount + 1
	
	SET @BudgetId = (SELECT TOP 1 BudgetId FROM #DeletingBudget)

	-- Remove old facts
	DELETE 
	FROM GrReporting.dbo.ProfitabilityReforecast 
	Where BudgetId = @BudgetId and SourceSystemId = @SourceSystemId
		
	PRINT ''Rows Deleted from ProfitabilityReforecast:''+CONVERT(char(10),@@rowcount)
	PRINT CONVERT(Varchar(27), getdate(), 121)
	
	DELETE FROM #DeletingBudget WHERE BudgetId = @BudgetId
	
	PRINT ''Rows Deleted from #DeletingBudget:''+CONVERT(char(10),@@rowcount)
	PRINT CONVERT(Varchar(27), getdate(), 121)
	
END

print ''Cleaned up rows in ProfitabilityReforecast''


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Insert modified and new fact data 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

INSERT INTO GrReporting.dbo.ProfitabilityReforecast
(
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
)
SELECT
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	@EUCorporateGlAccountCategoryKeyUnknown, --EUCorporateGlAccountCategoryKey,
	@EUPropertyGlAccountCategoryKeyUnknown, --EUPropertyGlAccountCategoryKey,
	@EUFundGlAccountCategoryKeyUnknown, --EUFundGlAccountCategoryKey,

	@USPropertyGlAccountCategoryKeyUnknown, --USPropertyGlAccountCategoryKey,
	@USCorporateGlAccountCategoryKeyUnknown, ----USCorporateGlAccountCategoryKey,
	@USFundGlAccountCategoryKeyUnknown, --USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	@DevelopmentGlAccountCategoryKeyUnknown --DevelopmentGlAccountCategoryKey

FROM 
	#ProfitabilityReforecast


PRINT ''Rows Inserted into #ProfitabilityReforecast:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)



	
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Clean up
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Source data
DROP TABLE #Budget
DROP TABLE #GlAccount
DROP TABLE #FunctionalDepartment
DROP TABLE #ActivityType
DROP TABLE #GlobalRegion
DROP TABLE #PropertyFundMapping
DROP TABLE #PropertyFund
DROP TABLE #AllocationSubRegion
-- Mapping mapping
DROP TABLE #ProfitabilitySource
DROP TABLE #DeletingBudget
DROP TABLE #ProfitabilityReforecast
-- Account Category Mapping
DROP TABLE #GLTranslationType
DROP TABLE #GLTranslationSubType
DROP TABLE #GLGlobalAccountTranslationType
DROP TABLE #GLGlobalAccountTranslationSubType
DROP TABLE #GLMajorCategory
DROP TABLE #GLMinorCategory


' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]    Script Date: 08/05/2010 15:16:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]
	@ImportStartDate	DateTime,
	@ImportEndDate		DateTime,
	@DataPriorToDate	DateTime=NULL
AS

SET NOCOUNT ON
IF @DataPriorToDate IS NULL 
	SET @DataPriorToDate = GETDATE()

PRINT ''####''
PRINT ''stp_IU_LoadGrProfitabiltyCorporateOriginalBudget''
PRINT ''####''
--*/

/*
[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]
	@ImportStartDate	= ''1900-01-01'',
	@ImportEndDate		= ''2010-12-31'',
	@DataPriorToDate	= ''2010-12-31''
*/ 

DECLARE 
      @GlAccountKey				Int = (SELECT GlAccountKey FROM GrReporting.dbo.GlAccount WHERE Code = ''UNKNOWN''),
      @SourceKey				Int = (Select SourceKey From GrReporting.dbo.Source Where SourceName = ''UNKNOWN''),
      @FunctionalDepartmentKey	Int = (Select FunctionalDepartmentKey From GrReporting.dbo.FunctionalDepartment Where FunctionalDepartmentCode = ''UNKNOWN''),
      @ReimbursableKey			Int = (Select ReimbursableKey From GrReporting.dbo.Reimbursable Where ReimbursableCode = ''UNKNOWN''),
      @ActivityTypeKey			Int = (Select ActivityTypeKey From GrReporting.dbo.ActivityType Where ActivityTypeCode = ''UNKNOWN''),
      @PropertyFundKey			Int = (Select PropertyFundKey From GrReporting.dbo.PropertyFund Where PropertyFundName = ''UNKNOWN''),
      @AllocationRegionKey		Int = (Select AllocationRegionKey From GrReporting.dbo.AllocationRegion Where RegionCode = ''UNKNOWN''),
      @OriginatingRegionKey		Int = (Select OriginatingRegionKey From GrReporting.dbo.OriginatingRegion Where RegionCode = ''UNKNOWN''),
      @LocalCurrencyKey			Int = (Select CurrencyKey From GrReporting.dbo.Currency Where CurrencyCode = ''UNKNOWN'')

DECLARE
		@EUFundGlAccountCategoryKeyUnknown				Int,
		@EUCorporateGlAccountCategoryKeyUnknown			Int,
		@EUPropertyGlAccountCategoryKeyUnknown			Int,
		@USFundGlAccountCategoryKeyUnknown				Int,
		@USPropertyGlAccountCategoryKeyUnknown			Int,
		@USCorporateGlAccountCategoryKeyUnknown			Int,
		@DevelopmentGlAccountCategoryKeyUnknown			Int,
		@GlobalGlAccountCategoryKeyUnknown				Int
	
SET @EUFundGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Fund Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @EUCorporateGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Corporate Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @EUPropertyGlAccountCategoryKeyUnknown  = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Property Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @USFundGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Fund Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @USPropertyGlAccountCategoryKeyUnknown  = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Property Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @USCorporateGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Corporate Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @DevelopmentGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''Development Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @GlobalGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global'' AND TranslationSubTypeName = ''Global'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')

DECLARE @SourceSystemId int
SET @SourceSystemId = 1 -- Corporate budgeting source system

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Source Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

------------------------------------------------------------------------------------------------------
--Source allocation records
------------------------------------------------------------------------------------------------------

PRINT ''Start''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget line item.
SELECT	
	Budget.*
INTO
	#Budget
FROM
	BudgetingCorp.GlobalReportingCorporateBudget Budget
	INNER JOIN BudgetingCorp.GlobalReportingCorporateBudgetActive(@DataPriorToDate) BudgetA ON
		Budget.ImportKey = BudgetA.ImportKey
WHERE
	Budget.LockedDate IS NOT NULL AND
	Budget.LockedDate BETWEEN @ImportStartDate AND @ImportEndDate AND
	Budget.BudgetPeriodCode = ''Q0'' -- Original budget values only

PRINT ''Rows Inserted into #Budget::''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
------------------------------------------------------------------------------------------------------
--Source associated records
------------------------------------------------------------------------------------------------------

-- Source Gl Account
SELECT
	gla.*
INTO
	#GlAccount
FROM
	Gdm.GLGlobalAccount gla
	INNER JOIN Gdm.GLGlobalAccountActive(@DataPriorToDate) glaA ON
		gla.ImportKey = glaA.ImportKey 

PRINT ''Rows Inserted into #GlAccount::''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Functional Department
SELECT 
	fd.* 
INTO
	#FunctionalDepartment
FROM 
	HR.FunctionalDepartment fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) fdA ON
		fd.ImportKey = fdA.ImportKey

PRINT ''Rows Inserted into #FunctionalDepartment:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Activity Type
SELECT
	at.*
INTO
	#ActivityType
FROM
	Gdm.ActivityType at
	INNER JOIN Gdm.ActivityTypeActive(@DataPriorToDate) atA ON
		at.ImportKey = atA.ImportKey

PRINT ''Rows Inserted into #ActvityType:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source originating region
SELECT
	gr.*
INTO
	#GlobalRegion
FROM
	Gdm.GlobalRegion gr
	INNER JOIN Gdm.GlobalRegionActive(@DataPriorToDate) grA ON
		gr.ImportKey = grA.ImportKey 

PRINT ''Rows Inserted into #GlobalRegion:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Property Fund Mappings (untill the switch over to GBS all budgets sourced from the grinder will use old mappings)
SELECT
	pfm.*
INTO
	#PropertyFundMapping
FROM
	Gdm.PropertyFundMapping Pfm 
	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PfmA ON
		PfmA.ImportKey = Pfm.ImportKey
		
PRINT ''Rows Inserted into #PropertyFundMapping''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFundMapping (PropertyFundCode, SourceCode, IsDeleted, PropertyFundId, PropertyFundMappingId, ActivityTypeId)

-- Source Property Fund
SELECT 
	PropertyFund.* 
INTO
	#PropertyFund
FROM 
	Gdm.PropertyFund PropertyFund
	INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PropertyFundA ON
		PropertyFund.ImportKey = PropertyFundA.ImportKey 

PRINT ''Completed inserting records into #PropertyFund:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFund (PropertyFundId)
PRINT ''Completed creating indexes on #PropertyFund''
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE TABLE #GLTranslationType(
	ImportKey INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLTranslationSubType(
	ImportKey INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsGRDefault BIT NOT NULL
)

CREATE TABLE #GLGlobalAccountTranslationType(
	ImportKey INT NOT NULL,
	GLGlobalAccountTranslationTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLGlobalAccountTranslationSubType(
	ImportKey INT NOT NULL,
	GLGlobalAccountTranslationSubTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	PostingPropertyGLAccountCode VARCHAR(14) NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMajorCategory(
	ImportKey INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMinorCategory(
	ImportKey INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

-- #GLGlobalAccountTranslationType

INSERT INTO
	#GLGlobalAccountTranslationType (ImportKey, GLGlobalAccountTranslationTypeId, GLGlobalAccountId, GLTranslationTypeId, GLAccountTypeId,
	GLAccountSubTypeId, IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	GATT.ImportKey, GATT.GLGlobalAccountTranslationTypeId, GATT.GLGlobalAccountId, GATT.GLTranslationTypeId, GATT.GLAccountTypeId,
	GATT.GLAccountSubTypeId, GATT.IsActive, GATT.InsertedDate, GATT.UpdatedDate, GATT.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccountTranslationType GATT
	INNER JOIN Gdm.GLGlobalAccountTranslationTypeActive(@DataPriorToDate) GATTA ON
		GATTA.ImportKey = GATT.ImportKey

-- #GLGlobalAccountTranslationSubType

INSERT INTO
	#GLGlobalAccountTranslationSubType (ImportKey, GLGlobalAccountTranslationSubTypeId, GLGlobalAccountId, GLTranslationSubTypeId, GLMinorCategoryId,
	PostingPropertyGLAccountCode, IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	GATST.ImportKey, GATST.GLGlobalAccountTranslationSubTypeId, GATST.GLGlobalAccountId, GATST.GLTranslationSubTypeId, GATST.GLMinorCategoryId,
	GATST.PostingPropertyGLAccountCode, GATST.IsActive, GATST.InsertedDate, GATST.UpdatedDate, GATST.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccountTranslationSubType GATST
	INNER JOIN Gdm.GLGlobalAccountTranslationSubTypeActive(@DataPriorToDate) GATSTA ON
		GATSTA.ImportKey = GATST.ImportKey

-- #GLTranslationType

INSERT INTO
	#GLTranslationType (ImportKey, GLTranslationTypeId, Code, [Name], [Description], IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	TT.ImportKey, TT.GLTranslationTypeId, TT.Code, TT.[Name], TT.[Description], TT.IsActive, TT.InsertedDate, TT.UpdatedDate, TT.UpdatedByStaffId
FROM
	Gdm.GLTranslationType TT
	INNER JOIN Gdm.GLTranslationTypeActive(@DataPriorToDate) TTA ON
		TTA.ImportKey = TT.ImportKey

-- #GLTranslationSubType

INSERT INTO
	#GLTranslationSubType (ImportKey, GLTranslationSubTypeId, GLTranslationTypeId, Code, [Name], IsActive, InsertedDate, UpdatedDate,
	UpdatedByStaffId, IsGRDefault)
SELECT
	TST.ImportKey, TST.GLTranslationSubTypeId, TST.GLTranslationTypeId, TST.Code, TST.[Name], TST.IsActive, TST.InsertedDate, TST.UpdatedDate,
	TST.UpdatedByStaffId, TST.IsGRDefault
FROM
	Gdm.GLTranslationSubType TST
	INNER JOIN Gdm.GLTranslationSubTypeActive(@DataPriorToDate) TSTA ON
		TSTA.ImportKey = TST.ImportKey

-- #GLMajorCategory

INSERT INTO
	#GLMajorCategory (ImportKey, GLMajorCategoryId, GLTranslationSubTypeId, [Name], IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	MajC.ImportKey, MajC.GLMajorCategoryId, MajC.GLTranslationSubTypeId, MajC.[Name], MajC.IsActive, MajC.InsertedDate, MajC.UpdatedDate, MajC.UpdatedByStaffId
FROM
	Gdm.GLMajorCategory MajC
	INNER JOIN Gdm.GLMajorCategoryActive(@DataPriorToDate) MajCA ON
		MajC.ImportKey = MajCA.ImportKey

-- #GLMinorCategory

INSERT INTO
	#GLMinorCategory (ImportKey, GLMinorCategoryId, GLMajorCategoryId, [Name], IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	Minc.ImportKey, Minc.GLMinorCategoryId, Minc.GLMajorCategoryId, Minc.[Name], Minc.IsActive, Minc.InsertedDate, Minc.UpdatedDate, Minc.UpdatedByStaffId
FROM
	Gdm.GLMinorCategory MinC
	INNER JOIN Gdm.GLMinorCategoryActive(@DataPriorToDate) MinCA ON
		MinCA.ImportKey = MinC.ImportKey


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Map Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

--Map budget Amounts
CREATE TABLE #ProfitabilitySource
(
	BudgetId int NOT NULL,
	ReferenceCode varchar(300) NOT NULL,
	ExpensePeriod char(6) NOT NULL,	
	SourceCode varchar(2) NULL,
	BudgetAmount money NOT NULL,
	GlGlobalAccountCode varchar(21) NOT NULL,
	GLGlobalAccountId int NOT NULL,
	FunctionalDepartmentCode varchar(31) NULL,
	FunctionalDepartmentId int NULL,
	JobCode varchar(20) NULL,
	Reimbursable bit NULL,
	ActivityTypeCode varchar(10) NULL,
	ActivityTypeId int NOT NULL,
	PropertyFundId int NULL,
	AllocationSubRegionGlobalRegionId int NOT NULL,
	OriginatingRegionCode char(6) NULL,
	OriginatingGlobalRegionId int NULL,
	LocalCurrencyCode char(3) NOT NULL,
	LockedDate datetime NOT NULL,
	IsExpense bit NOT NULL
)
-- Insert original budget amounts
INSERT INTO #ProfitabilitySource
(
	BudgetId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	BudgetAmount,
	GlGlobalAccountCode,
	GLGlobalAccountId,
	FunctionalDepartmentCode,
	FunctionalDepartmentId,
	JobCode,
	Reimbursable,
	ActivityTypeCode,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingGlobalRegionId,
	LocalCurrencyCode,
	LockedDate,
	IsExpense
)

SELECT 
	b.BudgetId,
	''BC:'' + b.SourceUniqueKey + ''&ImportKey='' + CONVERT(varchar, b.ImportKey) as ReferenceCode,
	b.Period as ExpensePeriod,
	b.SourceCode,
	b.LocalAmount as BudgetAmount,
	CONVERT(varchar,b.GlobalGlAccountCode) as GlGlobalAccountCode,
	IsNull(gla.GLGlobalAccountId,-1) as GlGlobalAccountId,
	b.FunctionalDepartmentGlobalCode as FunctionalDepartmentCode,
	IsNull(fd.FunctionalDepartmentId,-1),
	b.JobCode,
	b.IsReimbursable as Reimbursable,
	at.ActivityTypeCode,
	IsNull(at.ActivityTypeId,-1),
	pfm.PropertyFundId,
	IsNull(DepartmentPropertyFund.AllocationSubRegionGlobalRegionId,-1) as AllocationSubRegionGlobalRegionId,
	b.OriginatingSubRegionCode as OriginatingRegionCode,
	IsNull(gr.GlobalRegionId,-1) as OriginatingGlobalRegionId,
	b.InternationalCurrencyCode as LocalCurrencyCode,
	b.LockedDate,
	b.IsExpense
FROM
	#Budget b 
	
	LEFT OUTER JOIN #GlAccount gla ON
		b.GlobalGlAccountCode = gla.Code
		
	LEFT OUTER JOIN #FunctionalDepartment fd ON
		b.FunctionalDepartmentGlobalCode = fd.GlobalCode
		
	LEFT OUTER JOIN #ActivityType at ON
		gla.ActivityTypeId = at.ActivityTypeId
		
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON GrSc.SourceCode = b.SourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		b.NonPayrollCorporateMRIDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		b.SourceCode = pfm.SourceCode AND 
		(
			(GrSc.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL) OR
			(
			 (GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId = at.ActivityTypeId) OR
			 (GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND at.ActivityTypeId IS NULL)
			)
		) AND
		pfm.IsDeleted = 0

	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		pfm.PropertyFundId = DepartmentPropertyFund.PropertyFundId

	LEFT OUTER JOIN #GlobalRegion gr ON
		b.OriginatingSubRegionCode = gr.Code

WHERE
	b.LocalAmount <> 0

PRINT ''Rows Inserted into #ProfitabilitySource:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


CREATE NONCLUSTERED INDEX IX_LocalAmount ON [#Budget] ([LocalAmount])
INCLUDE ([ImportKey],[SourceUniqueKey],[BudgetId],[SourceCode],[LockedDate],[Period],[InternationalCurrencyCode],[GlobalGlAccountCode],[FunctionalDepartmentGlobalCode],[OriginatingSubRegionCode],[NonPayrollCorporateMRIDepartmentCode],[AllocationSubRegionProjectRegionId],[IsReimbursable],[JobCode])

PRINT ''Created Index on GlAccountKey #ProfitabilitySource''
PRINT CONVERT(Varchar(27), getdate(), 121)


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Map mapped source data into the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

------------------------------------------------------------------------------------------------------
-- Additional required mappings
------------------------------------------------------------------------------------------------------
SELECT
	asr.*
INTO
	#AllocationSubRegion
FROM
	Gdm.AllocationSubRegion asr
	INNER JOIN Gdm.AllocationSubRegionActive(@DataPriorToDate) asrA ON
		asr.ImportKey = asrA.ImportKey
		
PRINT ''Rows Inserted into #AllocationSubRegion''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--If the join is not possible, default the link to the ''UNKNOWN'' link
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityBudget(
	CalendarKey int NOT NULL,
	GlAccountKey int NOT NULL,
	SourceKey int NOT NULL,
	FunctionalDepartmentKey int NOT NULL,
	ReimbursableKey int NOT NULL,
	ActivityTypeKey int NOT NULL,
	PropertyFundKey int NOT NULL,	
	AllocationRegionKey int NOT NULL,
	OriginatingRegionKey int NOT NULL,
	LocalCurrencyKey int NOT NULL,
	LocalBudget money NOT NULL,
	ReferenceCode Varchar(300) NOT NULL,
	BudgetId int NOT NULL,
	SourceSystemId int NOT NULL,

	EUCorporateGlAccountCategoryKey int NULL,
	EUPropertyGlAccountCategoryKey int NULL,
	EUFundGlAccountCategoryKey int NULL,

	USPropertyGlAccountCategoryKey int NULL,
	USCorporateGlAccountCategoryKey int NULL,
	USFundGlAccountCategoryKey int NULL,

	GlobalGlAccountCategoryKey int NULL,
	DevelopmentGlAccountCategoryKey int NULL
) 

INSERT INTO #ProfitabilityBudget 
(
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId
)
SELECT
		DATEDIFF(dd, ''1900-01-01'', LEFT(ps.ExpensePeriod,4)+''-''+RIGHT(ps.ExpensePeriod,2)+''-01'') as CalendarKey
		,CASE WHEN GrGl.[GlAccountKey] IS NULL THEN @GlAccountKey ELSE GrGl.[GlAccountKey] END GlAccountKey
		,CASE WHEN GrSc.[SourceKey] IS NULL THEN @SourceKey ELSE GrSc.[SourceKey] END SourceKey
		,CASE WHEN ISNULL(GrFdmD.[FunctionalDepartmentKey], GrFdmP.[FunctionalDepartmentKey]) IS NULL THEN @FunctionalDepartmentKey ELSE ISNULL(GrFdmD.[FunctionalDepartmentKey], GrFdmP.[FunctionalDepartmentKey]) END FunctionalDepartmentKey
		,CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKey ELSE GrRi.ReimbursableKey END ReimbursableKey
		,CASE WHEN GrAt.[ActivityTypeKey] IS NULL THEN @ActivityTypeKey ELSE GrAt.[ActivityTypeKey] END ActivityTypeKey
		,CASE WHEN GrPf.[PropertyFundKey] IS NULL THEN @PropertyFundKey ELSE GrPf.[PropertyFundKey] END PropertyFundKey
		,CASE WHEN GrAr.[AllocationRegionKey] IS NULL THEN @AllocationRegionKey ELSE GrAr.[AllocationRegionKey] END AllocationRegionKey
		,CASE WHEN IsNull(ps.IsExpense,-1) = 0 THEN 
			CASE WHEN GrOrFee.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKey ELSE GrOrFee.[OriginatingRegionKey] END 
		 ELSE 
			CASE WHEN GrOr.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKey ELSE GrOr.[OriginatingRegionKey] END 
		 END OriginatingRegionKey
		,CASE WHEN GrCu.[CurrencyKey] IS NULL THEN @LocalCurrencyKey ELSE GrCu.[CurrencyKey] END LocalCurrencyKey
		,ps.BudgetAmount
		,ps.ReferenceCode
		,ps.BudgetId
		,@SourceSystemId 
FROM
	#ProfitabilitySource ps
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccount GrGl ON
		ps.GlGlobalAccountId = GrGl.GlGlobalAccountId AND
		ps.LockedDate BETWEEN GrGl.StartDate AND GrGl.EndDate
	
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON
		ps.SourceCode = GrSc.SourceCode

	--Detail/Sub Level (job level)
	LEFT OUTER JOIN (
				Select 
					*
				From GrReporting.dbo.FunctionalDepartment
				Where SubFunctionalDepartmentCode <> FunctionalDepartmentCode
				) GrFdmD ON
		ps.LockedDate  BETWEEN GrFdmD.StartDate AND GrFdmD.EndDate AND
		--GrFdmD.ReferenceCode LIKE ''%:''+ ps.JobCode --new substitude below
		GrFdmD.SubFunctionalDepartmentCode = ps.JobCode
			
	--Parent Level
	LEFT OUTER JOIN (
			Select 
				* 
			From 
			GrReporting.dbo.FunctionalDepartment
			Where SubFunctionalDepartmentCode = FunctionalDepartmentCode
			) GrFdmP ON
		ps.LockedDate  BETWEEN GrFdmP.StartDate AND GrFdmP.EndDate AND
		--GrFdmP.ReferenceCode LIKE ps.FunctionalDepartmentCode +'':%'' --new substitude below
		GrFdmP.FunctionalDepartmentCode = ps.FunctionalDepartmentCode

	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		CASE WHEN ps.Reimbursable = 1 THEN ''YES'' ELSE ''NO'' END = GrRi.ReimbursableCode

	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		ps.ActivityTypeId = GrAt.ActivityTypeId AND
		ps.LockedDate BETWEEN GrAt.StartDate AND GrAt.EndDate

	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		ps.PropertyFundId = GrPf.PropertyFundId AND
		ps.LockedDate BETWEEN GrPf.StartDate AND GrPf.EndDate

	LEFT OUTER JOIN #AllocationSubRegion Asr ON
		Asr.AllocationSubRegionGlobalRegionId = ps.AllocationSubRegionGlobalRegionId AND 
		Asr.IsActive = 1

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		Asr.AllocationSubRegionGlobalRegionId = GrAr.GlobalRegionId AND
		ps.LockedDate BETWEEN GrAr.StartDate AND GrAr.EndDate

	-- This is only used for fees. It sets the originating region to the allocation region
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOrFee ON
		Asr.AllocationSubRegionGlobalRegionId = GrOrFee.GlobalRegionId AND
		ps.LockedDate BETWEEN GrOrFee.StartDate AND GrOrFee.EndDate

	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		ps.OriginatingGlobalRegionId = GrOr.GlobalRegionId AND
		ps.LockedDate BETWEEN GrOr.StartDate AND GrOr.EndDate

	LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
		ps.LocalCurrencyCode = GrCu.CurrencyCode 


PRINT ''Rows Inserted into #ProfitabilityBudget:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_GlAcocuntKey ON #ProfitabilityBudget (GlAccountKey)
PRINT ''Created Index on GlAccountKey #ProfitabilityBudget''
PRINT CONVERT(Varchar(27), getdate(), 121)

--GlobalGlAccountCategoryKey
UPDATE
	#ProfitabilityBudget
SET
	GlobalGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM #ProfitabilityBudget Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = ''GL'' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))


PRINT ''Completed converting all GlobalGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

/* This is not used by the business yet: Gcloete
-------------------------------------------------------------------------------------------------------------------
-- EUCorporateGlAccountCategoryKey
UPDATE
	#ProfitabilityBudget
SET
	EUCorporateGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUCorporateGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END 
FROM
	#ProfitabilityBudget Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = ''EU CORP'' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))

		
			
PRINT ''Completed converting all EUCorporateGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--EUPropertyGlAccountCategoryKey
UPDATE
	#ProfitabilityBudget
SET
	EUPropertyGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUPropertyGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityBudget Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = ''EU PROP'' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))


PRINT ''Completed converting all EUPropertyGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)


--EUFundGlAccountCategoryKey
UPDATE
	#ProfitabilityBudget
SET
	EUFundGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUFundGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityBudget Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = ''EU FUND'' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))

	
PRINT ''Completed converting all EUFundGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USPropertyGlAccountCategoryKey
UPDATE
	#ProfitabilityBudget
SET
	USPropertyGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USPropertyGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityBudget Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = ''US PROP'' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))


PRINT ''Completed converting all USPropertyGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USCorporateGlAccountCategoryKey
UPDATE
	#ProfitabilityBudget
SET
	USCorporateGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USCorporateGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
From #ProfitabilityBudget Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = ''US CORP'' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))

	
PRINT ''Completed converting all USCorporateGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USFundGlAccountCategoryKey
UPDATE
	#ProfitabilityBudget
SET
	USFundGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USFundGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityBudget Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = ''US FUND'' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))


PRINT ''Completed converting all USFundGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

		

--DevelopmentGlAccountCategoryKey
UPDATE
	#ProfitabilityBudget
SET
	DevelopmentGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @DevelopmentGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM #ProfitabilityBudget Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = ''DEV'' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))

	
PRINT ''Completed converting all DevelopmentGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
*/

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Remove existing data for modified budget projects
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #DeletingBudget
(
	BudgetId int NOT NULL
)

INSERT INTO #DeletingBudget
(
	BudgetId
)
SELECT DISTINCT 
	BudgetId
FROM
	#ProfitabilityBudget

PRINT ''Rows Inserted into #DeletingBudget:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Remove 
DECLARE @BudgetId int = -1
DECLARE @LoopCount int = 0 -- Infinite loop safe guard
WHILE (EXISTS (SELECT TOP 1 BudgetId FROM #DeletingBudget) AND @LoopCount < 100000)
BEGIN
	
	SET @LoopCount = @LoopCount + 1
	
	SET @BudgetId = (SELECT TOP 1 BudgetId FROM #DeletingBudget)

	-- Remove old facts
	DELETE 
	FROM GrReporting.dbo.ProfitabilityBudget 
	Where BudgetId = @BudgetId and SourceSystemId = @SourceSystemId
		
	PRINT ''Rows Deleted from ProfitabilityBudget:''+CONVERT(char(10),@@rowcount)
	PRINT CONVERT(Varchar(27), getdate(), 121)
	
	DELETE FROM #DeletingBudget WHERE BudgetId = @BudgetId
	
	PRINT ''Rows Deleted from #DeletingBudget:''+CONVERT(char(10),@@rowcount)
	PRINT CONVERT(Varchar(27), getdate(), 121)
	
END

print ''Cleaned up rows in ProfitabilityBudget''


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Insert modified and new fact data 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

INSERT INTO GrReporting.dbo.ProfitabilityBudget
(
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
)
SELECT
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	@EUCorporateGlAccountCategoryKeyUnknown, --EUCorporateGlAccountCategoryKey,
	@EUPropertyGlAccountCategoryKeyUnknown, --EUPropertyGlAccountCategoryKey,
	@EUFundGlAccountCategoryKeyUnknown, --EUFundGlAccountCategoryKey,

	@USPropertyGlAccountCategoryKeyUnknown, --USPropertyGlAccountCategoryKey,
	@USCorporateGlAccountCategoryKeyUnknown, ----USCorporateGlAccountCategoryKey,
	@USFundGlAccountCategoryKeyUnknown, --USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	@DevelopmentGlAccountCategoryKeyUnknown --DevelopmentGlAccountCategoryKey
FROM 
	#ProfitabilityBudget


PRINT ''Rows Inserted into ProfitabilityBudget:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)



	
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Clean up
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Source data
DROP TABLE #Budget
DROP TABLE #GlAccount
DROP TABLE #FunctionalDepartment
DROP TABLE #ActivityType
DROP TABLE #GlobalRegion
DROP TABLE #PropertyFundMapping
DROP TABLE #PropertyFund
DROP TABLE #AllocationSubRegion
-- Mapping mapping
DROP TABLE #ProfitabilitySource
DROP TABLE #DeletingBudget
DROP TABLE #ProfitabilityBudget
-- Account Category Mapping
DROP TABLE #GLTranslationType
DROP TABLE #GLTranslationSubType
DROP TABLE #GLGlobalAccountTranslationType
DROP TABLE #GLGlobalAccountTranslationSubType
DROP TABLE #GLMajorCategory
DROP TABLE #GLMinorCategory


' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadExchangeRates]    Script Date: 08/05/2010 15:16:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadExchangeRates]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_IU_LoadExchangeRates]
	@ImportStartDate	DateTime,
	@ImportEndDate		DateTime,
	@DataPriorToDate	DateTime=NULL
AS

IF (@DataPriorToDate IS NULL)
	SET @DataPriorToDate = GETDATE()
	
SET NOCOUNT OFF
PRINT ''####''
PRINT ''stp_IU_LoadExchangeRates''
PRINT ''####''

--Generate temp table to prevent repeated function calls

CREATE TABLE #BudgetReportGroupActive
(
	ImportKey INT
)
INSERT INTO #BudgetReportGroupActive
SELECT * FROM TapasGlobalBudgeting.BudgetReportGroupActive(@DataPriorToDate)
 
CREATE TABLE #BudgetReportGroupDetailActive
(
	ImportKey INT
)
INSERT INTO #BudgetReportGroupDetailActive
SELECT * FROM TapasGlobalBudgeting.BudgetReportGroupDetailActive(@DataPriorToDate)
 
CREATE TABLE #BudgetActive
(
	ImportKey INT
)
INSERT INTO #BudgetActive
SELECT * FROM TapasGlobalBudgeting.BudgetActive(@DataPriorToDate)

CREATE TABLE #ExchangeRateActive
(
	ImportKey INT
)
INSERT INTO #ExchangeRateActive
SELECT * FROM Gdm.BudgetExchangeRateActive(@DataPriorToDate)

CREATE TABLE #ExchangeRateDetailActive
(
	ImportKey INT
)
INSERT INTO #ExchangeRateDetailActive
SELECT * FROM Gdm.BudgetExchangeRateDetailActive(@DataPriorToDate)

CREATE TABLE #BudgetStatusActive
(
	ImportKey INT
)
INSERT INTO #BudgetStatusActive
SELECT * FROM TapasGlobalBudgeting.BudgetStatusActive(@DataPriorToDate)

CREATE TABLE #BudgetReportGroupPeriodActive
(
	ImportKey INT
)
INSERT INTO #BudgetReportGroupPeriodActive
SELECT * FROM Gdm.BudgetReportGroupPeriodActive(@DataPriorToDate)

--Get all budget report groups which have been modified
DECLARE @UpdatedBudgetReportGroupIds  TABLE 
        (BudgetReportGroupId INT)

INSERT INTO @UpdatedBudgetReportGroupIds
SELECT 
	DISTINCT brg.BudgetReportGroupId
FROM
	Gdm.BudgetExchangeRateDetail erd
    INNER JOIN Gdm.BudgetExchangeRate er ON  
		er.BudgetExchangeRateId= erd.BudgetExchangeRateId
    INNER JOIN TapasGlobalBudgeting.BudgetReportGroup brg ON  
		brg.BudgetExchangeRateId = er.BudgetExchangeRateId
    INNER JOIN TapasGlobalBudgeting.BudgetReportGroupDetail brgd ON  
		brgd.BudgetReportGroupId = brg.BudgetReportGroupId
    INNER JOIN TapasGlobalBudgeting.Budget b ON  
		b.BudgetId = brgd.BudgetId
    INNER JOIN TapasGlobalBudgeting.BudgetStatus bs ON  
		bs.BudgetStatusId = b.BudgetStatusId
WHERE  
	(
		(erd.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
		(er.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
		(brg.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
		(brg.GRChangedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
		(brgd.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
		(b.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate)
	) AND
	er.IsDeleted = 0
	  

--Filter items that are deleted or not global
DECLARE @FirstFilterBudgetReportGroupIds TABLE 
        (BudgetReportGroupId INT)

INSERT INTO @FirstFilterBudgetReportGroupIds
SELECT 
	brg.BudgetReportGroupId
FROM
	@UpdatedBudgetReportGroupIds ubrgi
    INNER JOIN TapasGlobalBudgeting.BudgetReportGroup brg ON  
		brg.BudgetReportGroupId = ubrgi.BudgetReportGroupId
    INNER JOIN #BudgetReportGroupActive bprga ON  
		bprga.ImportKey = brg.ImportKey
	INNER JOIN Gdm.BudgetReportGroupPeriod grgp ON 
		grgp.BudgetReportGroupPeriodId = brg.BudgetReportGroupPeriodId
	INNER JOIN #BudgetReportGroupPeriodActive grbrgpa ON 
		grbrgpa.ImportKey = grgp.ImportKey
WHERE  
	brg.IsDeleted = 0 AND
	grgp.IsDeleted = 0

--Get the budgets that are locked

CREATE TABLE #FilteredBudgetGroups 
(
    BudgetReportGroupId INT,
    StartPeriod INT,
    EndPeriod INT,
    FirstProjectedPeriod INT,
	ExchangeRateId INT
)

INSERT INTO #FilteredBudgetGroups
SELECT 
	brg.BudgetReportGroupId,
    MAX(brg.StartPeriod),
    MAX(brg.EndPeriod),
    MAX(brg.FirstProjectedPeriod),
    MAX(brg.BudgetExchangeRateId)
FROM
	@FirstFilterBudgetReportGroupIds ffbrgi
    INNER JOIN TapasGlobalBudgeting.BudgetReportGroup brg ON  
		brg.BudgetReportGroupId = ffbrgi.BudgetReportGroupId
    INNER JOIN #BudgetReportGroupActive brga ON  
		brga.ImportKey = brg.ImportKey
    INNER JOIN TapasGlobalBudgeting.BudgetReportGroupDetail brgd ON  
		brgd.BudgetReportGroupId = brg.BudgetReportGroupId AND 
		brgd.IsDeleted = 0
    INNER JOIN #BudgetReportGroupDetailActive brgda ON  
		brgda.ImportKey = brgd.ImportKey
    INNER JOIN TapasGlobalBudgeting.Budget b ON  
		b.BudgetId = brgd.BudgetId AND 
		b.IsDeleted = 0
	INNER JOIN #BudgetActive ba ON  
		ba.ImportKey = b.ImportKey
    INNER JOIN TapasGlobalBudgeting.BudgetStatus bs ON  
		b.BudgetStatusId = bs.BudgetStatusId
	INNER JOIN #BudgetStatusActive bsa ON 
		bsa.ImportKey = bs.ImportKey
GROUP BY
    brg.BudgetReportGroupId
HAVING  COUNT(*) = SUM(CASE WHEN bs.[Name] = ''Locked'' THEN 1 ELSE 0 END) 

--Get only the latest budgets
CREATE TABLE #LatestBudgetGroups 
(
	BudgetReportGroupId INT,
    StartPeriod INT,
    EndPeriod INT,
    ExchangeRateId INT
)
        
--Number the budgetgroups with no first projected date
UPDATE #FilteredBudgetGroups
SET FirstProjectedPeriod = NumberedRows.RowNumber
FROM
(
	SELECT BudgetReportGroupId, StartPeriod, EndPeriod, ExchangeRateId, ROW_NUMBER() OVER (ORDER BY ExchangeRateId) AS RowNumber
	FROM #FilteredBudgetGroups
) NumberedRows
INNER JOIN #FilteredBudgetGroups lbg ON
	NumberedRows.BudgetReportGroupId = lbg.BudgetReportGroupId AND
	NumberedRows.StartPeriod = lbg.StartPeriod AND
	NumberedRows.EndPeriod = lbg.EndPeriod AND
	NumberedRows.ExchangeRateId = lbg.ExchangeRateId
WHERE FirstProjectedPeriod IS NULL

;with FilteredBudgetGroupsRank as
(
    SELECT  
		fbg.BudgetReportGroupId,
		fbg.StartPeriod,
		fbg.EndPeriod,
		fbg.FirstProjectedPeriod,
		fbg.ExchangeRateId,
        RANK() OVER (PARTITION BY fbg.StartPeriod, fbg.EndPeriod ORDER BY fbg.FirstProjectedPeriod DESC) AS GroupRank
    FROM #FilteredBudgetGroups fbg
)
INSERT INTO #LatestBudgetGroups
SELECT DISTINCT
	fbgr.BudgetReportGroupId,
	fbgr.StartPeriod,
	fbgr.EndPeriod,
	fbgr.ExchangeRateId
FROM
	FilteredBudgetGroupsRank fbgr
WHERE 
	fbgr.GroupRank <= 1
	
--Get the exchange rate for the given groups
CREATE TABLE #ExchangeRates 
(
	CurrencyCode CHAR(3),
    Period INT,
    Rate DECIMAL(18, 12),
    BudgetReportGroupId INT,
    BudgetExchangeRateId INT,
    BudgetExchangeRateDetailId INT
)

INSERT INTO #ExchangeRates
SELECT 
	erd.CurrencyCode,
    erd.Period,
    erd.Rate,
    lbg.BudgetReportGroupId,
    lbg.ExchangeRateId,
    erd.BudgetExchangeRateDetailId
FROM
	#LatestBudgetGroups lbg
    INNER JOIN Gdm.BudgetExchangeRate er ON  
		er.BudgetExchangeRateId = lbg.ExchangeRateId
    INNER JOIN #ExchangeRateActive era ON  
		era.ImportKey = er.ImportKey
    INNER JOIN Gdm.BudgetExchangeRateDetail erd ON  
		er.BudgetExchangeRateId = erd.BudgetExchangeRateId
    INNER JOIN #ExchangeRateDetailActive erda ON  
		erda.ImportKey = erd.ImportKey
WHERE  
	erd.Period BETWEEN lbg.StartPeriod AND lbg.EndPeriod
	
--Calculate the cross rates
DECLARE @CrossCurrency TABLE 
(
	SourceCurrencyCode CHAR(3),
    DestinationCurrencyCode CHAR(3),
    Period INT,
    Rate DECIMAL(18, 12),
    SourceReferenceCode VARCHAR(127),
    DestinationReferenceCode VARCHAR(127)
)
        
INSERT INTO @CrossCurrency
SELECT 
	s.CurrencyCode AS SourceCurrencyCode, 
	d.CurrencyCode AS DestinationCurrencyCode,
	es.Period, 
	(ed.Rate / es.Rate) AS Rate,
	''BudgetReportGroupId='' + CAST(es.BudgetReportGroupId AS VARCHAR(50)) +
    ''&BudgetExchangeRateId='' + CAST(es.BudgetExchangeRateId AS VARCHAR(50)) +
    ''&BudgetExchangeRateDetailId='' + CAST(es.BudgetExchangeRateDetailId AS VARCHAR(50)) AS 
    SourceReferenceCode,
    ''BudgetReportGroupId='' + CAST(ed.BudgetReportGroupId AS VARCHAR(50)) +
    ''&BudgetExchangeRateId='' + CAST(ed.BudgetExchangeRateId AS VARCHAR(50)) +
    ''&BudgetExchangeRateDetailId='' + CAST(ed.BudgetExchangeRateDetailId AS VARCHAR(50)) AS 
    DestinationReferenceCode
FROM
	GrReporting.dbo.Currency s
    CROSS JOIN GrReporting.dbo.Currency d
    INNER JOIN #ExchangeRates es ON es.CurrencyCode = s.CurrencyCode
    INNER JOIN #ExchangeRates ed ON ed.CurrencyCode = d.CurrencyCode
WHERE  
	s.CurrencyCode <> ''UNK'' AND 
	d.CurrencyCode <> ''UNK'' AND
	es.Period = ed.Period
	
--Build the fact
DECLARE @USDCurrencyKey INT
SELECT 
	@USDCurrencyKey = CurrencyKey
FROM
	GrReporting.dbo.Currency cur
WHERE  
	cur.CurrencyCode = ''USD''
	
IF (@USDCurrencyKey IS NULL)
BEGIN
	SET @USDCurrencyKey = -1
END

CREATE TABLE #FactData 
(
	SourceCurrencyKey INT,
    DestinationCurrencyKey INT,
    CalendarKey INT,
    Rate DECIMAL(18, 12),
    ReferenceCode VARCHAR(255)
)

INSERT INTO #FactData
SELECT 
	 ISNULL(curs.CurrencyKey, -1) AS SourceCurrencyKey,
	 ISNULL(curd.CurrencyKey, -1) AS DestinationCurrencyKey,
	 c.CalendarKey,
	 CASE 
         WHEN cc.Rate IS NULL THEN 0
         ELSE cc.Rate
    END AS Rate,
    (''SRC:'' + cc.SourceReferenceCode + '' DST:'' + cc.DestinationReferenceCode) AS ReferenceCode
FROM 
	@CrossCurrency cc 
	INNER JOIN GrReporting.dbo.Calendar c ON  
		cc.Period = c.CalendarPeriod
    LEFT JOIN GrReporting.dbo.Currency curs ON  
		curs.CurrencyCode = cc.SourceCurrencyCode
	LEFT JOIN GrReporting.dbo.Currency curd ON
		curd.CurrencyCode = cc.DestinationCurrencyCode
		
INSERT INTO #FactData		
SELECT 
	@USDCurrencyKey AS SourceCurrencyKey,
    ISNULL(cur.CurrencyKey, -1) AS DestinationCurrencyKey,
    c.CalendarKey,
    er.Rate,
    ''BudgetReportGroupId='' + CAST(er.BudgetReportGroupId AS VARCHAR(50)) +
    ''&BudgetExchangeRateId='' + CAST(er.BudgetExchangeRateId AS VARCHAR(50)) +
    ''&BudgetExchangeRateDetailId='' + CAST(er.BudgetExchangeRateDetailId AS VARCHAR(50)) AS 
    ReferenceCode
FROM
	#ExchangeRates er
    INNER JOIN GrReporting.dbo.Calendar c ON  
		er.Period = c.CalendarPeriod
    LEFT JOIN GrReporting.dbo.Currency cur ON  
		cur.CurrencyCode = er.CurrencyCode
	LEFT JOIN #FactData fd ON 
		fd.SourceCurrencyKey=@USDCurrencyKey AND
		fd.DestinationCurrencyKey=ISNULL(cur.CurrencyKey, -1) AND
		fd.CalendarKey = c.CalendarKey
WHERE fd.Rate IS NULL

INSERT INTO #FactData
SELECT 
	ISNULL(cur.CurrencyKey, -1) AS SourceCurrencyKey,
    @USDCurrencyKey AS DestinationCurrencyKey,
    c.CalendarKey,
    CASE 
         WHEN er.Rate IS NULL THEN 0
         ELSE (1 / er.Rate)
    END AS Rate,
    ''BudgetReportGroupId='' + CAST(er.BudgetReportGroupId AS VARCHAR(50)) +
    ''&BudgetExchangeRateId='' + CAST(er.BudgetExchangeRateId AS VARCHAR(50)) +
    ''&BudgetExchangeRateDetailId='' + CAST(er.BudgetExchangeRateDetailId AS VARCHAR(50)) AS 
    ReferenceCode
FROM
	#ExchangeRates er
    INNER JOIN GrReporting.dbo.Calendar c ON  
		er.Period = c.CalendarPeriod
    LEFT JOIN GrReporting.dbo.Currency cur ON  
		cur.CurrencyCode = er.CurrencyCode
	LEFT JOIN #FactData fd ON 
		fd.SourceCurrencyKey=ISNULL(cur.CurrencyKey, -1) AND
		fd.DestinationCurrencyKey=@USDCurrencyKey AND
		fd.CalendarKey = c.CalendarKey
WHERE fd.Rate IS NULL

IF ((SELECT COUNT(*) FROM #FactData WHERE SourceCurrencyKey = @USDCurrencyKey AND DestinationCurrencyKey = @USDCurrencyKey)<=0)
BEGIN
	INSERT INTO #FactData
	SELECT DISTINCT
		@USDCurrencyKey AS SourceCurrencyKey,
		@USDCurrencyKey AS DestinationCurrencyKey,
		c.CalendarKey,
		1 AS Rate,
		''Default'' AS ReferenceCode
	FROM
		#ExchangeRates er
		INNER JOIN GrReporting.dbo.Calendar c ON  
			er.Period = c.CalendarPeriod
		LEFT JOIN #FactData fd ON 
			fd.SourceCurrencyKey=@USDCurrencyKey AND
			fd.DestinationCurrencyKey=@USDCurrencyKey AND
			fd.CalendarKey = c.CalendarKey
	WHERE fd.Rate IS NULL
END

--Update the star schema
MERGE GrReporting.dbo.ExchangeRate AS d
USING #FactData AS s ON  
	d.SourceCurrencyKey = s.SourceCurrencyKey AND 
	d.DestinationCurrencyKey = s.DestinationCurrencyKey AND 
	d.CalendarKey = s.CalendarKey
WHEN MATCHED
THEN
	UPDATE
	SET 
		d.Rate = s.Rate,
		d.ReferenceCode = s.ReferenceCode
WHEN NOT MATCHED
THEN
	INSERT 
	VALUES
	  (
		s.SourceCurrencyKey,
		s.DestinationCurrencyKey,
		s.CalendarKey,
		s.Rate,
		s.ReferenceCode
	  );

DROP TABLE #FilteredBudgetGroups
DROP TABLE #LatestBudgetGroups
DROP TABLE #ExchangeRates
DROP TABLE #FactData

DROP TABLE #BudgetReportGroupActive 
DROP TABLE #BudgetReportGroupDetailActive 
DROP TABLE #BudgetReportGroupPeriodActive
DROP TABLE #BudgetActive
DROP TABLE #ExchangeRateActive
DROP TABLE #ExchangeRateDetailActive
DROP TABLE #BudgetStatusActive
  
print ''Rows inserted/updated: ''+CONVERT(char(10),@@rowcount)
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyOverhead]    Script Date: 08/05/2010 15:16:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyOverhead]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyOverhead]
	@ImportStartDate	DateTime,
	@ImportEndDate		DateTime,
	@DataPriorToDate	DateTime=NULL
AS

SET NOCOUNT ON
IF @DataPriorToDate IS NULL 
	SET @DataPriorToDate = GETDATE()


DECLARE 
	@GlAccountKeyUnknown INT,
	--@OverheadGlAccountKeyUnknown INT,
	@FunctionalDepartmentKeyUnknown INT,
	@ReimbursableKeyUnknown INT,
	@ActivityTypeKeyUnknown INT,
	@SourceKeyUnknown INT,
	@OriginatingRegionKeyUnknown INT,
	@AllocationRegionKeyUnknown INT,
	@PropertyFundKeyUnknown INT,
	--@CurrencyKey INT,
	@EUFundGlAccountCategoryKeyUnknown INT,
	@EUCorporateGlAccountCategoryKeyUnknown INT,
	@EUPropertyGlAccountCategoryKeyUnknown	INT,
	@USFundGlAccountCategoryKeyUnknown	INT,
	@USPropertyGlAccountCategoryKeyUnknown	INT,
	@USCorporateGlAccountCategoryKeyUnknown INT,
	@DevelopmentGlAccountCategoryKeyUnknown INT,
	@GlobalGlAccountCategoryKeyUnknown INT

PRINT ''####''
PRINT ''stp_IU_LoadGrProfitabiltyOverhead''
PRINT ''####''
SET NOCOUNT ON
  
--Default FK for the Fact table
/*
exec [stp_IU_LoadGrProfitabiltyOverhead]
	@ImportStartDate	= ''1900-01-01'',
	@ImportEndDate		= ''2010-12-31'',
	@DataPriorToDate	= ''2010-12-31''
*/  
     
SET @GlAccountKeyUnknown			= (SELECT GlAccountKey FROM GrReporting.dbo.GlAccount WHERE Code = ''UNKNOWN'')
--SET @OverheadGlAccountKeyUnknown	= (SELECT GlAccountKey FROM GrReporting.dbo.GlAccount WHERE Code = ''5002950000  '') -- Only log against header account (This might be changed back so only commented out)
SET @FunctionalDepartmentKeyUnknown	= (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = ''UNKNOWN'')
SET @ReimbursableKeyUnknown			= (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = ''UNKNOWN'')
SET @ActivityTypeKeyUnknown			= (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = ''UNKNOWN'')
SET @SourceKeyUnknown				= (SELECT SourceKey FROM GrReporting.dbo.Source WHERE SourceName = ''UNKNOWN'')
SET @OriginatingRegionKeyUnknown	= (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = ''UNKNOWN'')
SET @AllocationRegionKeyUnknown		= (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = ''UNKNOWN'')
SET @PropertyFundKeyUnknown			= (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = ''UNKNOWN'')
--SET @CurrencyKey					= (SELECT CurrencyKey FROM GrReporting.dbo.Currency WHERE CurrencyCode = ''UNK'')

SET @EUFundGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Fund Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @EUCorporateGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Corporate Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @EUPropertyGlAccountCategoryKeyUnknown  = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Property Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @USFundGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Fund Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @USPropertyGlAccountCategoryKeyUnknown  = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Property Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @USCorporateGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Corporate Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @DevelopmentGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''Development Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @GlobalGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global'' AND TranslationSubTypeName = ''Global'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')

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

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Create the temp tables used on the "active" records for optimization
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #AllocationRegion(
	ImportKey INT NOT NULL,
	AllocationRegionGlobalRegionId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	ProjectCodePortion VARCHAR(2) NOT NULL,
	DefaultCurrencyCode CHAR(3) NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)
CREATE TABLE #AllocationSubRegion(
	ImportKey INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	ProjectCodePortion VARCHAR(2) NOT NULL,
	AllocationRegionGlobalRegionId INT NULL,
	DefaultCurrencyCode CHAR(3) NOT NULL,
	CountryId INT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #BillingUpload(
	ImportKey INT  NOT NULL,
	BillingUploadId INT NOT NULL,
	BillingUploadBatchId INT NULL,
	BillingUploadTypeId INT NOT NULL,
	TimeAllocationId INT NOT NULL,
	CostTypeId INT NOT NULL,
	RegionId INT NOT NULL,
	ExternalRegionId INT NOT NULL,
	ExternalSubRegionId INT NOT NULL,
	PayrollId INT NULL,
	OverheadId INT NULL,
	PayGroupId INT NULL,
	UnionCodeId INT NULL,
	OverheadRegionId INT NULL,
	HREmployeeId INT NOT NULL,
	ProjectId INT NOT NULL,
	SubDepartmentId INT NOT NULL,
	ExpensePeriod INT NOT NULL,
	PayrollDescription NVARCHAR(100) NULL,
	OverheadDescription NVARCHAR(100) NULL,
	ProjectCode VARCHAR(50) NOT NULL,
	ReversalPeriod INT NULL,
	AllocationPeriod INT NOT NULL,
	AllocationValue DECIMAL(18, 9) NOT NULL,
	IsReversable BIT NOT NULL,
	IsReversed BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	HasNoInactiveProjects BIT NOT NULL,
	LocationId INT NOT NULL,
	ProjectGroupAllocationAdjustmentId INT NULL,
	AdjustedTimeAllocationDetailId INT NULL,
	PayrollPayDate DATETIME NULL,
	PayrollFromDate DATETIME NULL,
	PayrollToDate DATETIME NULL,
	FunctionalDepartmentId INT NOT NULL,
	ActivityTypeId INT NOT NULL,
	OverheadFunctionalDepartmentId INT NULL,
)

CREATE TABLE #BillingUploadDetail(
	ImportKey INT NOT NULL,
	BillingUploadDetailId INT NOT NULL,
	BillingUploadBatchId INT NOT NULL,
	BillingUploadId INT NOT NULL,
	BillingUploadDetailTypeId INT NOT NULL,
	ExpenseTypeId INT NULL,
	GLAccountCode VARCHAR(15) NOT NULL,
	CorporateEntityRef VARCHAR(6) NULL,
	CorporateDepartmentCode VARCHAR(8) NOT NULL,
	CorporateDepartmentIsRechargedToAr BIT NOT NULL,
	CorporateSourceCode VARCHAR(2) NOT NULL,
	AllocationAmount DECIMAL(18, 9) NOT NULL,
	CurrencyCode CHAR(3) NOT NULL,
	IsUnion BIT NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	CorporateDepartmentIsRechargedToAp BIT NOT NULL
)

CREATE TABLE #Overhead(
	ImportKey INT NOT NULL,
	OverheadId INT NOT NULL,
	RegionId INT NOT NULL,
	ExpensePeriod INT NOT NULL,
	AllocationStartPeriod INT NOT NULL,
	AllocationEndPeriod INT NULL,
	[Description] NVARCHAR(60) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	InsertedByStaffId INT NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	InvoiceNumber VARCHAR(13) NULL
)

CREATE TABLE #FunctionalDepartment(
	ImportKey INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	Code VARCHAR(20) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	GlobalCode CHAR(3) NULL
)

CREATE TABLE #Project(
	ImportKey INT NOT NULL,
	ProjectId INT NOT NULL,
	RegionId INT NOT NULL,
	ActivityTypeId INT NOT NULL,
	ProjectOwnerId INT NULL,
	CorporateDepartmentCode VARCHAR(8) NOT NULL,
	CorporateSourceCode CHAR(2) NOT NULL,
	Code VARCHAR(50) NOT NULL,
	Name VARCHAR(100) NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	PropertyOverheadGLAccountCode VARCHAR(15) NULL,
	PropertyOverheadDepartmentCode VARCHAR(6) NULL,
	PropertyOverheadJobCode VARCHAR(15) NULL,
	PropertyOverheadSourceCode CHAR(2) NULL,
	CorporateUnionPayrollIncomeCategoryCode VARCHAR(6) NULL,
	CorporateNonUnionPayrollIncomeCategoryCode VARCHAR(6) NULL,
	CorporateOverheadIncomeCategoryCode VARCHAR(6) NULL,
	PropertyFundId INT NOT NULL,
	MarkUpPercentage DECIMAL(5, 4) NULL,
	HistoricalProjectCode VARCHAR(50) NULL,
	IsTSCost BIT NOT NULL,
	CanAllocateOverheads BIT NOT NULL,
	AllocateOverheadsProjectId INT NULL
)

CREATE TABLE #PropertyFund( -- GDM 2.0 change
	ImportKey INT NOT NULL,
	PropertyFundId INT NOT NULL,
	RelatedFundId INT NULL,
	EntityTypeId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	BudgetOwnerStaffId INT NOT NULL,
	RegionalOwnerStaffId INT NOT NULL,
	DefaultGLTranslationSubTypeId INT NULL,
	[Name] VARCHAR(100) NOT NULL,
	IsReportingEntity BIT NOT NULL,
	IsPropertyFund BIT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #PropertyFundMapping(
	ImportKey INT NOT NULL,
	PropertyFundMappingId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode char(2) NOT NULL,
	PropertyFundCode VARCHAR(8) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL,
	ActivityTypeId INT NULL
)

CREATE TABLE #ReportingEntityCorporateDepartment( -- GDM 2.0 addition - used to be AllocationRegionMapping
	ImportKey INT NOT NULL,
	ReportingEntityCorporateDepartmentId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	CorporateDepartmentCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsDeleted BIT NOT NULL,
)

CREATE TABLE #ReportingEntityPropertyEntity( -- GDM 2.0 addition - used to be AllocationRegionMapping
	ImportKey INT NOT NULL,
	ReportingEntityPropertyEntityId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	PropertyEntityCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsDeleted BIT NOT NULL
)

CREATE TABLE #OriginatingRegionCorporateEntity( -- GDM 2.0 addition - used to be OriginatingRegionMapping
	ImportKey INT NOT NULL,
	OriginatingRegionCorporateEntityId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	CorporateEntityCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL	
)

CREATE TABLE #OriginatingRegionPropertyDepartment( -- GDM 2.0 addition - used to be OriginatingRegionMapping
	ImportKey INT NOT NULL,
	OriginatingRegionPropertyDepartmentId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	PropertyDepartmentCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL	
)

CREATE TABLE #GLGlobalAccount(
	ImportKey INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	ActivityTypeId INT NULL,
	GLStatutoryTypeId INT NULL,
	ParentGLGlobalAccountId INT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(150) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsGR BIT NOT NULL,
	IsGbs BIT NOT NULL,
	IsRegionalOverheadCost BIT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #ActivityType(
	ImportKey INT NOT NULL,
	ActivityTypeId INT NOT NULL,
	ActivityTypeCode VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	GLSuffix CHAR(2) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

CREATE TABLE #OverheadRegion(
	ImportKey INT NOT NULL,
	OverheadRegionId INT NOT NULL,
	RegionId INT NOT NULL,
	CorporateEntityRef VARCHAR(6) NULL,
	CorporateSourceCode VARCHAR(2) NULL,
	Name VARCHAR(50) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLTranslationType(
	ImportKey INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLTranslationSubType(
	ImportKey INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsGRDefault BIT NOT NULL
)

CREATE TABLE #GLGlobalAccountTranslationType(
	ImportKey INT NOT NULL,
	GLGlobalAccountTranslationTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLGlobalAccountTranslationSubType(
	ImportKey INT NOT NULL,
	GLGlobalAccountTranslationSubTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	PostingPropertyGLAccountCode VARCHAR(14) NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMajorCategory(
	ImportKey INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMinorCategory(
	ImportKey INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

--======================================================================================================================================

INSERT INTO #BillingUpload (
	ImportKey,
	BillingUploadId,
	BillingUploadBatchId,
	BillingUploadTypeId,
	TimeAllocationId,
	CostTypeId,
	RegionId,
	ExternalRegionId,
	ExternalSubRegionId,
	PayrollId,
	OverheadId,
	PayGroupId,
	UnionCodeId,
	OverheadRegionId,
	HREmployeeId,
	ProjectId,
	SubDepartmentId,
	ExpensePeriod,
	PayrollDescription,
	OverheadDescription,
	ProjectCode,
	ReversalPeriod,
	AllocationPeriod,
	AllocationValue,
	IsReversable,
	IsReversed,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	HasNoInactiveProjects,
	LocationId,
	ProjectGroupAllocationAdjustmentId,
	AdjustedTimeAllocationDetailId,
	PayrollPayDate,
	PayrollFromDate,
	PayrollToDate,
	FunctionalDepartmentId,
	ActivityTypeId,
	OverheadFunctionalDepartmentId
)
SELECT 
	Bu.ImportKey,
	Bu.BillingUploadId,
	Bu.BillingUploadBatchId,
	Bu.BillingUploadTypeId,
	Bu.TimeAllocationId,
	Bu.CostTypeId,
	Bu.RegionId,
	Bu.ExternalRegionId,
	Bu.ExternalSubRegionId,
	Bu.PayrollId,
	Bu.OverheadId,
	Bu.PayGroupId,
	Bu.UnionCodeId,
	Bu.OverheadRegionId,
	Bu.HREmployeeId,
	Bu.ProjectId,
	Bu.SubDepartmentId,
	Bu.ExpensePeriod,
	Bu.PayrollDescription,
	Bu.OverheadDescription,
	Bu.ProjectCode,
	Bu.ReversalPeriod,
	Bu.AllocationPeriod,
	Bu.AllocationValue,
	Bu.IsReversable,
	Bu.IsReversed,
	Bu.InsertedDate,
	Bu.UpdatedDate,
	Bu.UpdatedByStaffId,
	Bu.HasNoInactiveProjects,
	Bu.LocationId,
	Bu.ProjectGroupAllocationAdjustmentId,
	Bu.AdjustedTimeAllocationDetailId,
	Bu.PayrollPayDate,
	Bu.PayrollFromDate,
	Bu.PayrollToDate,
	Bu.FunctionalDepartmentId,
	Bu.ActivityTypeId,
	Bu.OverheadFunctionalDepartmentId
FROM
	TapasGlobal.BillingUpload	Bu
	INNER JOIN TapasGlobal.BillingUploadActive(@DataPriorToDate) BuA ON
		BuA.ImportKey = Bu.ImportKey

------------

INSERT INTO #BillingUploadDetail (
	ImportKey,
	BillingUploadDetailId,
	BillingUploadBatchId,
	BillingUploadId,
	BillingUploadDetailTypeId,
	ExpenseTypeId,
	GLAccountCode,
	CorporateEntityRef,
	CorporateDepartmentCode,
	CorporateDepartmentIsRechargedToAr,
	CorporateSourceCode,
	AllocationAmount,
	CurrencyCode,
	IsUnion,
	UpdatedByStaffId,
	InsertedDate,
	UpdatedDate,
	CorporateDepartmentIsRechargedToAp
)
SELECT 
	Bud.ImportKey,
	Bud.BillingUploadDetailId,
	Bud.BillingUploadBatchId,
	Bud.BillingUploadId,
	Bud.BillingUploadDetailTypeId,
	Bud.ExpenseTypeId,
	Bud.GLAccountCode,
	Bud.CorporateEntityRef,
	Bud.CorporateDepartmentCode,
	Bud.CorporateDepartmentIsRechargedToAr,
	Bud.CorporateSourceCode,
	Bud.AllocationAmount,
	Bud.CurrencyCode,
	Bud.IsUnion,
	Bud.UpdatedByStaffId,
	Bud.InsertedDate,
	Bud.UpdatedDate,
	Bud.CorporateDepartmentIsRechargedToAp
FROM
	TapasGlobal.BillingUploadDetail Bud
	INNER JOIN TapasGlobal.BillingUploadDetailActive(@DataPriorToDate) BudA ON
		BudA.ImportKey = Bud.ImportKey

----------

INSERT INTO #Overhead (
	ImportKey,
	OverheadId,
	RegionId,
	ExpensePeriod,
	AllocationStartPeriod,
	AllocationEndPeriod,
	[Description],
	InsertedDate,
	InsertedByStaffId,
	UpdatedDate,
	UpdatedByStaffId,
	InvoiceNumber
)
SELECT 
	 Oh.ImportKey,
	 Oh.OverheadId,
	 Oh.RegionId,
	 Oh.ExpensePeriod,
	 Oh.AllocationStartPeriod,
	 Oh.AllocationEndPeriod,
	 Oh.[Description],
	 Oh.InsertedDate,
	 Oh.InsertedByStaffId,
	 Oh.UpdatedDate,
	 Oh.UpdatedByStaffId,
	 Oh.InvoiceNumber
FROM
	TapasGlobal.Overhead Oh 
	INNER JOIN TapasGlobal.OverheadActive(@DataPriorToDate) OhA ON
		OhA.ImportKey = Oh.ImportKey

----------

INSERT INTO #FunctionalDepartment (
	ImportKey,
	FunctionalDepartmentId,
	Name,
	Code,
	IsActive,
	InsertedDate,
	UpdatedDate,
	GlobalCode
)
SELECT
	Fd.ImportKey,
	Fd.FunctionalDepartmentId,
	Fd.Name,
	Fd.Code,
	Fd.IsActive,
	Fd.InsertedDate,
	Fd.UpdatedDate,
	Fd.GlobalCode
FROM
	HR.FunctionalDepartment Fd 
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FdA ON
		FdA.ImportKey = Fd.ImportKey

----------

INSERT INTO #Project (
	ImportKey,
	ProjectId,
	RegionId,
	ActivityTypeId,
	ProjectOwnerId,
	CorporateDepartmentCode,
	CorporateSourceCode,
	Code,
	Name,
	StartPeriod,
	EndPeriod,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	PropertyOverheadGLAccountCode,
	PropertyOverheadDepartmentCode,
	PropertyOverheadJobCode,
	PropertyOverheadSourceCode,
	CorporateUnionPayrollIncomeCategoryCode,
	CorporateNonUnionPayrollIncomeCategoryCode,
	CorporateOverheadIncomeCategoryCode,
	PropertyFundId,
	MarkUpPercentage,
	HistoricalProjectCode,
	IsTSCost,
	CanAllocateOverheads,
	AllocateOverheadsProjectId
)
SELECT 
	P2.ImportKey,
	P2.ProjectId,
	P2.RegionId,
	P2.ActivityTypeId,
	P2.ProjectOwnerId,
	P2.CorporateDepartmentCode,
	P2.CorporateSourceCode,
	P2.Code,
	P2.Name,
	P2.StartPeriod,
	P2.EndPeriod,
	P2.InsertedDate,
	P2.UpdatedDate,
	P2.UpdatedByStaffId,
	P2.PropertyOverheadGLAccountCode,
	P2.PropertyOverheadDepartmentCode,
	P2.PropertyOverheadJobCode,
	P2.PropertyOverheadSourceCode,
	P2.CorporateUnionPayrollIncomeCategoryCode,
	P2.CorporateNonUnionPayrollIncomeCategoryCode,
	P2.CorporateOverheadIncomeCategoryCode,
	P2.PropertyFundId,
	P2.MarkUpPercentage,
	P2.HistoricalProjectCode,
	P2.IsTSCost,
	P2.CanAllocateOverheads,
	P2.AllocateOverheadsProjectId
FROM
	TapasGlobal.Project P2
	INNER JOIN TapasGlobal.ProjectActive(@DataPriorToDate) P2A ON
		P2A.ImportKey = P2.ImportKey

----------------------------------------------------------------------------------------------

-- #AllocationRegion

INSERT INTO #AllocationRegion(
	ImportKey,
	AllocationRegionGlobalRegionId,
	Code,
	[Name],
	ProjectCodePortion,
	DefaultCurrencyCode,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	AR.ImportKey,
	AR.AllocationRegionGlobalRegionId,
	AR.Code,
	AR.[Name],
	AR.ProjectCodePortion,
	AR.DefaultCurrencyCode,
	AR.IsActive,
	AR.InsertedDate,
	AR.UpdatedDate,
	AR.UpdatedByStaffId
FROM
	Gdm.AllocationRegion AR
	INNER JOIN Gdm.AllocationRegionActive(@DataPriorToDate) ARA ON
		ARA.ImportKey = AR.ImportKey

-- #AllocationSubRegion

INSERT INTO #AllocationSubRegion(
	ImportKey,
	AllocationSubRegionGlobalRegionId,
	Code,
	[Name],
	ProjectCodePortion,
	AllocationRegionGlobalRegionId,
	DefaultCurrencyCode,
	CountryId,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	ASR.ImportKey,
	ASR.AllocationSubRegionGlobalRegionId,
	ASR.Code,
	ASR.[Name],
	ASR.ProjectCodePortion,
	ASR.AllocationRegionGlobalRegionId,
	ASR.DefaultCurrencyCode,
	ASR.CountryId,
	ASR.IsActive,
	ASR.InsertedDate,
	ASR.UpdatedDate,
	ASR.UpdatedByStaffId
FROM
	Gdm.AllocationSubRegion ASR
	INNER JOIN	Gdm.AllocationSubRegionActive(@DataPriorToDate) ASRA ON ASRA.ImportKey = ASR.ImportKey

-- #PropertyFund
	
INSERT INTO #PropertyFund(
	ImportKey,
	PropertyFundId,
	RelatedFundId,
	EntityTypeId,
	AllocationSubRegionGlobalRegionId,
	BudgetOwnerStaffId,
	RegionalOwnerStaffId,
	DefaultGLTranslationSubTypeId,
	[Name],
	IsReportingEntity,
	IsPropertyFund,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	PF.ImportKey,
	PF.PropertyFundId,
	PF.RelatedFundId,
	PF.EntityTypeId,
	PF.AllocationSubRegionGlobalRegionId,
	PF.BudgetOwnerStaffId,
	PF.RegionalOwnerStaffId,
	PF.DefaultGLTranslationSubTypeId,
	PF.[Name],
	PF.IsReportingEntity,
	PF.IsPropertyFund,
	PF.IsActive,
	PF.InsertedDate,
	PF.UpdatedDate,
	PF.UpdatedByStaffId
FROM
	Gdm.PropertyFund PF 
	INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PFA ON
		PFA.ImportKey = PF.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #PropertyFund (PropertyFundId)

-- #PropertyFundMapping

INSERT INTO #PropertyFundMapping(
	ImportKey,
	PropertyFundMappingId,
	PropertyFundId,
	SourceCode,
	PropertyFundCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted,
	ActivityTypeId
)
SELECT
	Pfm.ImportKey,
	Pfm.PropertyFundMappingId,
	Pfm.PropertyFundId,
	Pfm.SourceCode,
	Pfm.PropertyFundCode,
	Pfm.InsertedDate,
	Pfm.UpdatedDate,
	Pfm.IsDeleted,
	Pfm.ActivityTypeId
FROM
	Gdm.PropertyFundMapping Pfm 
	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PfmA ON
		PfmA.ImportKey = Pfm.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #PropertyFundMapping (PropertyFundCode, SourceCode, IsDeleted, PropertyFundId, PropertyFundMappingId, ActivityTypeId)

-- #ReportingEntityCorporateDepartment

INSERT INTO #ReportingEntityCorporateDepartment(
	ImportKey,
	ReportingEntityCorporateDepartmentId,
	PropertyFundId,
	SourceCode,
	CorporateDepartmentCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsDeleted
)
SELECT
	RECD.ImportKey,
	RECD.ReportingEntityCorporateDepartmentId,
	RECD.PropertyFundId,
	RECD.SourceCode,
	RECD.CorporateDepartmentCode,
	RECD.InsertedDate,
	RECD.UpdatedDate,
	RECD.UpdatedByStaffId,
	RECD.IsDeleted
FROM
	Gdm.ReportingEntityCorporateDepartment RECD
	INNER JOIN Gdm.ReportingEntityCorporateDepartmentActive(@DataPriorToDate) RECDA ON
		RECDA.ImportKey = RECD.ImportKey

-- #ReportingEntityPropertyEntity

INSERT INTO #ReportingEntityPropertyEntity(
	ImportKey,
	ReportingEntityPropertyEntityId,
	PropertyFundId,
	SourceCode,
	PropertyEntityCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsDeleted
)
SELECT
	REPE.ImportKey,
	REPE.ReportingEntityPropertyEntityId,
	REPE.PropertyFundId,
	REPE.SourceCode,
	REPE.PropertyEntityCode,
	REPE.InsertedDate,
	REPE.UpdatedDate,
	REPE.UpdatedByStaffId,
	REPE.IsDeleted
FROM
	Gdm.ReportingEntityPropertyEntity REPE
	INNER JOIN Gdm.ReportingEntityPropertyEntityActive(@DataPriorToDate) REPEA ON
		REPEA.ImportKey = REPE.ImportKey

-- #OriginatingRegionCorporateEntity

INSERT INTO #OriginatingRegionCorporateEntity(
	ImportKey,
	OriginatingRegionCorporateEntityId,
	GlobalRegionId,
	CorporateEntityCode,
	SourceCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted
)
SELECT
	ORCE.ImportKey,
	ORCE.OriginatingRegionCorporateEntityId,
	ORCE.GlobalRegionId,
	ORCE.CorporateEntityCode,
	ORCE.SourceCode,
	ORCE.InsertedDate,
	ORCE.UpdatedDate,
	ORCE.IsDeleted	
FROM
	Gdm.OriginatingRegionCorporateEntity ORCE
	INNER JOIN Gdm.OriginatingRegionCorporateEntityActive (@DataPriorToDate) ORCEA ON
		ORCEA.ImportKey = ORCE.ImportKey

-- #OriginatingRegionPropertyDepartment

INSERT INTO #OriginatingRegionPropertyDepartment(
	ImportKey,
	OriginatingRegionPropertyDepartmentId,
	GlobalRegionId,
	PropertyDepartmentCode,
	SourceCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted
)
SELECT
	ORPD.ImportKey,
	ORPD.OriginatingRegionPropertyDepartmentId,
	ORPD.GlobalRegionId,
	ORPD.PropertyDepartmentCode,
	ORPD.SourceCode,
	ORPD.InsertedDate,
	ORPD.UpdatedDate,
	ORPD.IsDeleted
FROM
	Gdm.OriginatingRegionPropertyDepartment ORPD
	INNER JOIN Gdm.OriginatingRegionPropertyDepartmentActive(@DataPriorToDate) ORPDA ON
		ORPDA.ImportKey = ORPD.ImportKey

-- #ActivityType

INSERT INTO #ActivityType(
	ImportKey,
	ActivityTypeId,
	ActivityTypeCode,
	[Name],
	GLSuffix,
	InsertedDate,
	UpdatedDate
)
SELECT
	At.ImportKey,
	At.ActivityTypeId,
	At.ActivityTypeCode,
	At.Name,
	At.GLSuffix,
	At.InsertedDate,
	At.UpdatedDate
FROM
	Gdm.ActivityType At
	INNER JOIN Gdm.ActivityTypeActive(@DataPriorToDate) Ata ON
		Ata.ImportKey = At.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ActivityType (ActivityTypeId)

-- #GLGlobalAccount

INSERT INTO #GLGlobalAccount(
	ImportKey,
	GLGlobalAccountId,
	ActivityTypeId,
	GLStatutoryTypeId,
	ParentGLGlobalAccountId,
	Code,
	[Name],
	[Description],
	IsGR,
	IsGbs,
	IsRegionalOverheadCost,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	GLA.ImportKey,
	GLA.GLGlobalAccountId,
	GLA.ActivityTypeId,
	GLA.GLStatutoryTypeId,
	GLA.ParentGLGlobalAccountId,
	GLA.Code,
	GLA.[Name], 
	GLA.[Description],
	GLA.IsGR,
	GLA.IsGbs,
	GLA.IsRegionalOverheadCost,
	GLA.IsActive,
	GLA.InsertedDate,
	GLA.UpdatedDate,
	GLA.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccount GLA
	INNER JOIN Gdm.GLGlobalAccountActive(@DataPriorToDate) GLAA ON
		GLAA.ImportKey = GLA.ImportKey
	
CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #GLGlobalAccount (GLGlobalAccountId, ActivityTypeId)

INSERT INTO #OverheadRegion(
	ImportKey,
	OverheadRegionId,
	RegionId,
	CorporateEntityRef,
	CorporateSourceCode,
	Name,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	Ovr.ImportKey,
	Ovr.OverheadRegionId,
	Ovr.RegionId,
	Ovr.CorporateEntityRef,
	Ovr.CorporateSourceCode,
	Ovr.Name,
	Ovr.InsertedDate,
	Ovr.UpdatedDate,
	Ovr.UpdatedByStaffId
FROM	TapasGlobal.OverheadRegion Ovr 
		INNER JOIN TapasGlobal.OverheadRegionActive(@DataPriorToDate) OvrA ON
			OvrA.ImportKey = Ovr.ImportKey

-- #GLGlobalAccountTranslationType

INSERT INTO #GLGlobalAccountTranslationType(
	ImportKey,
	GLGlobalAccountTranslationTypeId,
	GLGlobalAccountId,
	GLTranslationTypeId,
	GLAccountTypeId,
	GLAccountSubTypeId,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	GATT.ImportKey,
	GATT.GLGlobalAccountTranslationTypeId,
	GATT.GLGlobalAccountId,
	GATT.GLTranslationTypeId,
	GATT.GLAccountTypeId,
	GATT.GLAccountSubTypeId,
	GATT.IsActive,
	GATT.InsertedDate,
	GATT.UpdatedDate,
	GATT.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccountTranslationType GATT
	INNER JOIN Gdm.GLGlobalAccountTranslationTypeActive(@DataPriorToDate) GATTA ON
		GATTA.ImportKey = GATT.ImportKey

-- #GLGlobalAccountTranslationSubType

INSERT INTO #GLGlobalAccountTranslationSubType(
	ImportKey,
	GLGlobalAccountTranslationSubTypeId,
	GLGlobalAccountId,
	GLTranslationSubTypeId,
	GLMinorCategoryId,
	PostingPropertyGLAccountCode,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	GATST.ImportKey,
	GATST.GLGlobalAccountTranslationSubTypeId,
	GATST.GLGlobalAccountId,
	GATST.GLTranslationSubTypeId,
	GATST.GLMinorCategoryId,
	GATST.PostingPropertyGLAccountCode,
	GATST.IsActive,
	GATST.InsertedDate,
	GATST.UpdatedDate,
	GATST.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccountTranslationSubType GATST
	INNER JOIN Gdm.GLGlobalAccountTranslationSubTypeActive(@DataPriorToDate) GATSTA ON
		GATSTA.ImportKey = GATST.ImportKey

-- #GLTranslationType

INSERT INTO #GLTranslationType(
	ImportKey,
	GLTranslationTypeId,
	Code,
	[Name],
	[Description],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	TT.ImportKey,
	TT.GLTranslationTypeId,
	TT.Code,
	TT.[Name],
	TT.[Description],
	TT.IsActive,
	TT.InsertedDate,
	TT.UpdatedDate,
	TT.UpdatedByStaffId
FROM
	Gdm.GLTranslationType TT
	INNER JOIN Gdm.GLTranslationTypeActive(@DataPriorToDate) TTA ON
		TTA.ImportKey = TT.ImportKey

-- #GLTranslationSubType

INSERT INTO #GLTranslationSubType(
	ImportKey,
	GLTranslationSubTypeId,
	GLTranslationTypeId,
	Code,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsGRDefault
)
SELECT
	TST.ImportKey,
	TST.GLTranslationSubTypeId,
	TST.GLTranslationTypeId,
	TST.Code,
	TST.[Name],
	TST.IsActive,
	TST.InsertedDate,
	TST.UpdatedDate,
	TST.UpdatedByStaffId,
	TST.IsGRDefault
FROM
	Gdm.GLTranslationSubType TST
	INNER JOIN Gdm.GLTranslationSubTypeActive(@DataPriorToDate) TSTA ON
		TSTA.ImportKey = TST.ImportKey

-- #GLMajorCategory

INSERT INTO #GLMajorCategory(
	ImportKey,
	GLMajorCategoryId,
	GLTranslationSubTypeId,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	MajC.ImportKey,
	MajC.GLMajorCategoryId,
	MajC.GLTranslationSubTypeId,
	MajC.[Name],
	MajC.IsActive,
	MajC.InsertedDate,
	MajC.UpdatedDate,
	MajC.UpdatedByStaffId
FROM
	Gdm.GLMajorCategory MajC
	INNER JOIN Gdm.GLMajorCategoryActive(@DataPriorToDate) MajCA ON
		MajC.ImportKey = MajCA.ImportKey

-- #GLMinorCategory

INSERT INTO #GLMinorCategory(
	ImportKey,
	GLMinorCategoryId,
	GLMajorCategoryId,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	Minc.ImportKey,
	Minc.GLMinorCategoryId,
	Minc.GLMajorCategoryId,
	Minc.[Name],
	Minc.IsActive,
	Minc.InsertedDate,
	Minc.UpdatedDate,
	Minc.UpdatedByStaffId
FROM
	Gdm.GLMinorCategory MinC
	INNER JOIN Gdm.GLMinorCategoryActive(@DataPriorToDate) MinCA ON
		MinCA.ImportKey = MinC.ImportKey

PRINT ''Completed inserting Active records into temp table''
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Now use the temp tables and load the #ProfitabilityOverhead
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityOverhead(
	BillingUploadDetailId INT NOT NULL,
	CorporateDepartmentCode VARCHAR(8)  NULL,
	CorporateSourceCode VARCHAR(2)  NULL,
	CanAllocateOverheads Bit NOT NULL,
	ExpensePeriod INT NOT NULL,
	AllocationRegionCode VARCHAR(6) NULL,
	OriginatingRegionCode VARCHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	PropertyFundId INT NOT NULL,
	FunctionalDepartmentCode CHAR(3) NULL,
	ActivityTypeCode VARCHAR(10) NULL,
	ExpenseType VARCHAR(8) NOT NULL,
	LocalCurrency CHAR(3) NOT NULL,
	LocalActual DECIMAL(18,12) NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	InsertedDate DATETIME NOT NULL
)

INSERT INTO #ProfitabilityOverhead(
	BillingUploadDetailId,
	CorporateDepartmentCode,
	CorporateSourceCode,
	CanAllocateOverheads,
	ExpensePeriod,
	AllocationRegionCode,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	PropertyFundId,
	FunctionalDepartmentCode,
	ActivityTypeCode,
	ExpenseType,
	LocalCurrency,
	LocalActual,
	UpdatedDate,
	InsertedDate
)
SELECT 
	Bud.BillingUploadDetailId,
	
	CASE
		WHEN P1.AllocateOverheadsProjectId IS NULL THEN Bud.CorporateDepartmentCode
		ELSE P2.CorporateDepartmentCode
	END AS CorporateDepartmentCode,
	
	Bud.CorporateSourceCode,
	
	CASE
		WHEN P1.AllocateOverheadsProjectId IS NULL THEN P1.CanAllocateOverheads
		ELSE P2.CanAllocateOverheads
	END AS CanAllocateOverheads,
	
	Bu.ExpensePeriod,
	GrAr.RegionCode AllocationRegionCode, --Pr.Code AllocationRegionCode,
	Ovr.CorporateEntityRef OriginatingRegionCode,
	Ovr.CorporateSourceCode OriginatingRegionSourceCode,
	
	CASE
		WHEN (P1.AllocateOverheadsProjectId IS NULL OR P1.AllocateOverheadsProjectId = 0) THEN 
			ISNULL(DepartmentPropertyFund.PropertyFundId, -1)
		ELSE
			ISNULL(OverheadPropertyFund.PropertyFundId, -1)
	END AS PropertyFundId, --This is seen as the Gdm.Gr.GlobalPropertyFundId
	
	Fd.GlobalCode FunctionalDepartmentCode,
	At.ActivityTypeCode,
	''Overhead'' ExpenseType,
	Bud.CurrencyCode ForeignCurrency,
	Bud.AllocationAmount ForeignActual,
	Bud.UpdatedDate,
	Bud.InsertedDate
FROM
	#BillingUpload Bu
		
	INNER JOIN #BillingUploadDetail Bud ON
		Bud.BillingUploadId = Bu.BillingUploadId

	INNER JOIN #Overhead Oh ON
		Oh.OverheadId = Bu.OverheadId

	LEFT OUTER JOIN #FunctionalDepartment Fd ON
		Fd.FunctionalDepartmentId = Bu.OverheadFunctionalDepartmentId

	LEFT OUTER JOIN #Project P1 ON
		P1.ProjectId = Bu.ProjectId

	LEFT OUTER JOIN #Project P2 ON
		P2.ProjectId = P1.AllocateOverheadsProjectId

	-- P1 ---------------------------

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrScC ON
		GrScC.SourceCode = P1.CorporateSourceCode

	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECDC ON -- added
		GrScC.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
		RECDC.CorporateDepartmentCode = LTRIM(RTRIM(P1.CorporateDepartmentCode)) AND
		RECDC.SourceCode = P1.CorporateSourceCode AND
		Bu.ExpensePeriod >= ''201007'' AND		   
		RECDC.IsDeleted = 0
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPEC ON -- added
		GrScC.IsProperty = ''YES'' AND -- only property MRIs resolved through this
		REPEC.PropertyEntityCode = LTRIM(RTRIM(P1.CorporateDepartmentCode)) AND
		REPEC.SourceCode = P1.CorporateSourceCode AND
		Bu.ExpensePeriod >= ''201007'' AND
		REPEC.IsDeleted = 0

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		P1.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		P1.CorporateSourceCode = pfm.SourceCode AND
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

	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECDO ON -- added
		GrScO.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
		RECDO.CorporateDepartmentCode = LTRIM(RTRIM(P2.CorporateDepartmentCode)) AND
		RECDO.SourceCode = P2.CorporateSourceCode AND
		Bu.ExpensePeriod >= ''201007''  AND			   
		RECDO.IsDeleted = 0
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPEO ON -- added
		GrScO.IsProperty = ''YES'' AND -- only property MRIs resolved through this
		REPEO.PropertyEntityCode = LTRIM(RTRIM(P2.CorporateDepartmentCode)) AND
		REPEO.SourceCode = P2.CorporateSourceCode AND
		Bu.ExpensePeriod >= ''201007''  AND
		REPEO.IsDeleted = 0

	LEFT OUTER JOIN #PropertyFundMapping opfm ON
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

	LEFT OUTER JOIN #PropertyFund PF ON
		PF.PropertyFundId = (
								CASE
									WHEN (P1.PropertyFundId IS NULL OR P1.PropertyFundId = 0) THEN
										ISNULL(DepartmentPropertyFund.PropertyFundId, -1)
									ELSE
										ISNULL(OverheadPropertyFund.PropertyFundId, -1)
								END
							) AND
		PF.IsActive = 1
		
	LEFT OUTER JOIN #AllocationSubRegion ASR ON
		PF.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId AND
		ASR.IsActive = 1		

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		GrAr.GlobalRegionId = ASR.AllocationSubRegionGlobalRegionId --AND
		-- ISNULL(Gl.LastDate, EnterDate) BETWEEN GrAr.StartDate AND GrAr.EndDate ???????

	LEFT OUTER JOIN #ActivityType At ON
		At.ActivityTypeId = Bu.ActivityTypeId

	LEFT OUTER JOIN #OverheadRegion Ovr ON
		Ovr.OverheadRegionId = Bu.OverheadRegionId

WHERE
	Bu.BillingUploadBatchId IS NOT NULL AND
	Bud.BillingUploadDetailTypeId <> 2 
	--AND ISNULL(Bu.UpdatedDate, Bu.UpdatedDate) BETWEEN @ImportStartDate AND @ImportEndDate --NOTE:: GC I am note sure it can work with the date filter

--IMS 48953 - Exclude overhead mark up from the import

PRINT ''Rows Inserted into #ProfitabilityOverhead:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--------------------------------------------------------------------------------------------------------------------------------------
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Take the different sources and combine them into the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--If the join is not possible, default the link to the ''UNKNOWN'' link
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityActual(
	CalendarKey INT NOT NULL,
	GlAccountKey INT NOT NULL,
	SourceKey INT NOT NULL,
	FunctionalDepartmentKey INT NOT NULL,
	ReimbursableKey INT NOT NULL,
	ActivityTypeKey INT NOT NULL,
	OriginatingRegionKey INT NOT NULL,
	AllocationRegionKey INT NOT NULL,
	PropertyFundKey INT NOT NULL,
	ReferenceCode VARCHAR(100) NOT NULL,
	LocalCurrencyKey INT NOT NULL,
	LocalActual MONEY NOT NULL,
	ProfitabilityActualSourceTableId INT NOT NULL,
	
	EUCorporateGlAccountCategoryKey INT NULL,
	EUPropertyGlAccountCategoryKey INT NULL,
	EUFundGlAccountCategoryKey INT NULL,

	USPropertyGlAccountCategoryKey INT NULL,
	USCorporateGlAccountCategoryKey INT NULL,
	USFundGlAccountCategoryKey INT NULL,

	GlobalGlAccountCategoryKey INT NULL,
	DevelopmentGlAccountCategoryKey INT NULL
) 

INSERT INTO #ProfitabilityActual(
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	OriginatingRegionKey,
	AllocationRegionKey,
	PropertyFundKey,
	ReferenceCode,
	LocalCurrencyKey,
	LocalActual,
	ProfitabilityActualSourceTableId
)
SELECT 
	DATEDIFF(dd, ''1900-01-01'', LEFT(Gl.ExpensePeriod, 4) + ''-'' + RIGHT(Gl.ExpensePeriod, 2) + ''-01'') CalendarKey,
	--,ISNULL(@OverheadGlAccountKeyUnknown, @GlAccountKeyUnknown) GlAccountKey,
	CASE WHEN GrGa.GlAccountKey IS NULL THEN @GlAccountKeyUnknown ELSE GrGa.GlAccountKey END GlAccountKey,
	CASE WHEN GrSc.SourceKey IS NULL THEN @SourceKeyUnknown ELSE GrSc.SourceKey END SourceKey,
	CASE WHEN GrFdm.FunctionalDepartmentKey IS NULL THEN @FunctionalDepartmentKeyUnknown ELSE GrFdm.FunctionalDepartmentKey END FunctionalDepartmentKey,
	CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKeyUnknown ELSE GrRi.ReimbursableKey END ReimbursableKey,
	CASE WHEN GrAt.ActivityTypeKey IS NULL THEN @ActivityTypeKeyUnknown ELSE GrAt.ActivityTypeKey END ActivityTypeKey,
	CASE WHEN GrOr.OriginatingRegionKey IS NULL THEN @OriginatingRegionKeyUnknown ELSE GrOr.OriginatingRegionKey END OriginatingRegionKey,
	CASE WHEN GrAr.AllocationRegionKey IS NULL THEN @AllocationRegionKeyUnknown ELSE GrAr.AllocationRegionKey END AllocationRegionKey,
	CASE WHEN GrPf.PropertyFundKey IS NULL THEN @PropertyFundKeyUnknown ELSE GrPf.PropertyFundKey END PropertyFundKey,
	''BillingUploadDetailId='' + LTRIM(STR(Gl.BillingUploadDetailId, 10, 0)),
	Cu.CurrencyKey,
	Gl.LocalActual,
	3 ProfitabilityActualSourceTableId --BillingUploadDetail

FROM
	#ProfitabilityOverhead Gl

	LEFT OUTER JOIN GrReporting.dbo.Currency Cu ON
		Cu.CurrencyCode = Gl.LocalCurrency

	LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdm ON
		GrFdm.FunctionalDepartmentCode = Gl.FunctionalDepartmentCode AND
		GrFdm.SubFunctionalDepartmentCode = Gl.FunctionalDepartmentCode AND
		Gl.UpdatedDate BETWEEN GrFdm.StartDate AND ISNULL(GrFdm.EndDate, Gl.UpdatedDate)

	LEFT OUTER JOIN #ActivityType At ON
		At.ActivityTypeCode = Gl.ActivityTypeCode 
		
	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		GrAt.ActivityTypeId = At.ActivityTypeId AND
		Gl.UpdatedDate BETWEEN GrAt.StartDate AND ISNULL(GrAt.EndDate, Gl.UpdatedDate)
	
	LEFT OUTER JOIN #ActivityTypeGLAccount AtGla ON
		AtGla.ActivityTypeId = At.ActivityTypeId

	LEFT OUTER JOIN #GLGlobalAccount GA ON
		GA.Code = AtGla.GLAccountCode AND
		ISNULL(AtGla.ActivityTypeId, 0) = ISNULL(GA.ActivityTypeId, 0) -- Nulls for header (00) accounts. (Should really have an activity for this)

	LEFT OUTER JOIN GrReporting.dbo.GlAccount GrGA ON
		GrGA.GLGlobalAccountId = GA.GLGlobalAccountId AND
		Gl.UpdatedDate BETWEEN GrGA.StartDate AND GrGA.EndDate
		
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		GrSc.SourceCode = Gl.CorporateSourceCode
	
	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		GrPf.PropertyFundId = Gl.PropertyFundId AND
		Gl.UpdatedDate BETWEEN GrPf.StartDate AND ISNULL(GrPf.EndDate, Gl.UpdatedDate)

	LEFT OUTER JOIN #OriginatingRegionCorporateEntity ORCE ON
		ORCE.CorporateEntityCode = Gl.OriginatingRegionCode AND
		ORCE.SourceCode = Gl.OriginatingRegionSourceCode AND
		ORCE.IsDeleted = 0
	
	-- Overheads should only be sourced from Corporate, but the mapping for property below has been included	
	--LEFT OUTER JOIN #OriginatingRegionPropertyDepartment ORPD ON
	--	ORPD.PropertyDepartmentCode = Gl.OriginatingRegionCode AND
	--	ORPD.SourceCode = Gl.OriginatingRegionSourceCode AND
	--	ORPD.IsDeleted = 0		  
		   
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		GrOr.GlobalRegionId = ORCE.GlobalRegionId AND
		--GrOr.GlobalRegionId = ORPD.GlobalRegionId AND
		Gl.UpdatedDate BETWEEN GrOr.StartDate AND ISNULL(GrOr.EndDate, Gl.UpdatedDate)
	
	LEFT OUTER JOIN #PropertyFund PF ON
		PF.PropertyFundId = Gl.PropertyFundId AND
		PF.IsActive = 1

	LEFT OUTER JOIN #AllocationSubRegion ASR ON
		PF.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId AND
		ASR.IsActive = 1		

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		GrAr.GlobalRegionId = ASR.AllocationSubRegionGlobalRegionId AND
		Gl.UpdatedDate BETWEEN GrAr.StartDate AND ISNULL(GrAr.EndDate, Gl.UpdatedDate)

	LEFT OUTER JOIN (
						SELECT ''UC'' SOURCECODE, DEPARTMENT, NETTSCOST FROM USCorp.GDEP UNION ALL
						SELECT ''EC'' SOURCECODE, DEPARTMENT, NETTSCOST FROM EUCorp.GDEP UNION ALL
						SELECT ''IC'' SOURCECODE, DEPARTMENT, NETTSCOST FROM INCorp.GDEP UNION ALL
						SELECT ''BC'' SOURCECODE, DEPARTMENT, NETTSCOST FROM BRCorp.GDEP UNION ALL
						SELECT ''CC'' SOURCECODE, DEPARTMENT, NETTSCOST FROM CNCorp.GDEP
					) RiCo ON
		RiCo.DEPARTMENT = Gl.CorporateDepartmentCode AND
		RiCo.SOURCECODE = Gl.CorporateSourceCode	

	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		GrRi.ReimbursableCode = CASE
									WHEN Gl.CanAllocateOverheads = 1 THEN 
										CASE
											WHEN ISNULL(RiCo.NETTSCOST, ''N'') = ''Y'' THEN ''NO'' ELSE ''YES''
										END
									ELSE ''NO''
								END

WHERE
	Gl.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate

----Prepare data for later Clean-up of Key''s that have changed and 
----as such left the current record to be not required anymore	
--Update GrReporting.dbo.ProfitabilityActual
--SET 	
--Actual						= 0
--Where	SourceKey	IN (Select DISTINCT SourceKey From #ProfitabilityActual)
--AND		CalendarKey	BETWEEN DATEDIFF(dd,''1900-01-01'', @ImportStartDate) AND 
--							 DATEDIFF(dd,''1900-01-01'', @ImportEndDate)
--Transfer the updated rows
	
-------------------------------------------------------------------------------------------------------------------
--GlobalGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	GlobalGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM #ProfitabilityActual Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = ''GL'' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))


PRINT ''Completed converting all GlobalGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)


/*
-- EUCorporateGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	EUCorporateGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUCorporateGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END 
FROM
	#ProfitabilityActual Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = ''EU CORP'' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))

		
			
PRINT ''Completed converting all EUCorporateGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--EUPropertyGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	EUPropertyGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUPropertyGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityActual Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = ''EU PROP'' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))


PRINT ''Completed converting all EUPropertyGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)


--EUFundGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	EUFundGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUFundGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityActual Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = ''EU FUND'' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))

	
PRINT ''Completed converting all EUFundGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USPropertyGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	USPropertyGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USPropertyGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityActual Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = ''US PROP'' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))


PRINT ''Completed converting all USPropertyGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USCorporateGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	USCorporateGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USCorporateGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
From #ProfitabilityActual Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = ''US CORP'' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))

	
PRINT ''Completed converting all USCorporateGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USFundGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	USFundGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USFundGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityActual Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = ''US FUND'' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))


PRINT ''Completed converting all USFundGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

		
--DevelopmentGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	DevelopmentGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @DevelopmentGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM #ProfitabilityActual Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = ''DEV'' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))

	
PRINT ''Completed converting all DevelopmentGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
*/
CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProfitabilityActual (SourceKey, ReferenceCode)
PRINT ''Completed building clustered index on #ProfitabilityActual''
PRINT CONVERT(Varchar(27), getdate(), 121)

UPDATE
	GrReporting.dbo.ProfitabilityActual
SET 	
	CalendarKey						 = Pro.CalendarKey,
	GlAccountKey					 = Pro.GlAccountKey,
	FunctionalDepartmentKey			 = Pro.FunctionalDepartmentKey,
	ReimbursableKey					 = Pro.ReimbursableKey,
	ActivityTypeKey					 = Pro.ActivityTypeKey,
	OriginatingRegionKey			 = Pro.OriginatingRegionKey,
	AllocationRegionKey				 = Pro.AllocationRegionKey,
	PropertyFundKey					 = Pro.PropertyFundKey,
	LocalCurrencyKey				 = Pro.LocalCurrencyKey,
	LocalActual						 = Pro.LocalActual,
	ProfitabilityActualSourceTableId = Pro.ProfitabilityActualSourceTableId,
		
	EUCorporateGlAccountCategoryKey	 = @EUCorporateGlAccountCategoryKeyUnknown, --Pro.EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey	 = @EUPropertyGlAccountCategoryKeyUnknown, --Pro.EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey		 = @EUFundGlAccountCategoryKeyUnknown, --Pro.EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey	 = @USPropertyGlAccountCategoryKeyUnknown, --Pro.USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey	 = @USCorporateGlAccountCategoryKeyUnknown, --Pro.USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey		 = @USFundGlAccountCategoryKeyUnknown, --Pro.USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey		 = Pro.GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey	 = @DevelopmentGlAccountCategoryKeyUnknown --Pro.DevelopmentGlAccountCategoryKey
FROM
	#ProfitabilityActual Pro
WHERE
	ProfitabilityActual.SourceKey = Pro.SourceKey AND
	ProfitabilityActual.ReferenceCode = Pro.ReferenceCode

PRINT ''Rows Updated in Profitability:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--Transfer the new rows
INSERT INTO GrReporting.dbo.ProfitabilityActual(
	CalendarKey,
	GlAccountKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	SourceKey,
	OriginatingRegionKey,
	AllocationRegionKey,
	PropertyFundKey,
	ReferenceCode,
	LocalCurrencyKey,
	LocalActual,
	ProfitabilityActualSourceTableId,
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,
	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,
	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
)
SELECT
	Pro.CalendarKey,
	Pro.GlAccountKey,
	Pro.FunctionalDepartmentKey,
	Pro.ReimbursableKey,
	Pro.ActivityTypeKey,
	Pro.SourceKey,Pro.OriginatingRegionKey,Pro.AllocationRegionKey,Pro.PropertyFundKey,
	Pro.ReferenceCode, Pro.LocalCurrencyKey, Pro.LocalActual,
	Pro.ProfitabilityActualSourceTableId, --BillingUploadDetail

	@EUCorporateGlAccountCategoryKeyUnknown, --Pro.EUCorporateGlAccountCategoryKey,
	@EUPropertyGlAccountCategoryKeyUnknown, --Pro.EUPropertyGlAccountCategoryKey,
	@EUFundGlAccountCategoryKeyUnknown, --Pro.EUFundGlAccountCategoryKey,

	@USPropertyGlAccountCategoryKeyUnknown, --Pro.USPropertyGlAccountCategoryKey,
	@USCorporateGlAccountCategoryKeyUnknown, ----Pro.USCorporateGlAccountCategoryKey,
	@USFundGlAccountCategoryKeyUnknown, --Pro.USFundGlAccountCategoryKey,

	Pro.GlobalGlAccountCategoryKey,
	@DevelopmentGlAccountCategoryKeyUnknown --Pro.DevelopmentGlAccountCategoryKey
									
FROM
	#ProfitabilityActual Pro
	LEFT OUTER JOIN GrReporting.dbo.ProfitabilityActual ProExists ON
		ProExists.SourceKey	= Pro.SourceKey AND
		ProExists.ReferenceCode	= Pro.ReferenceCode

WHERE
	ProExists.SourceKey IS NULL

PRINT ''Rows Inserted in Profitability:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
--Uploaded BillingUploads should never be deleted ....
--hence we should never have to delete records

DROP TABLE #ActivityTypeGLAccount
DROP TABLE #AllocationRegion
DROP TABLE #AllocationSubRegion
DROP TABLE #BillingUpload
DROP TABLE #BillingUploadDetail
DROP TABLE #Overhead
DROP TABLE #FunctionalDepartment
DROP TABLE #Project
DROP TABLE #PropertyFund
DROP TABLE #PropertyFundMapping
DROP TABLE #ReportingEntityCorporateDepartment
DROP TABLE #ReportingEntityPropertyEntity
DROP TABLE #OriginatingRegionCorporateEntity
DROP TABLE #OriginatingRegionPropertyDepartment
DROP TABLE #GLGlobalAccount
DROP TABLE #ActivityType
DROP TABLE #OverheadRegion
DROP TABLE #GLTranslationType
DROP TABLE #GLTranslationSubType
DROP TABLE #GLGlobalAccountTranslationType
DROP TABLE #GLGlobalAccountTranslationSubType
DROP TABLE #GLMajorCategory
DROP TABLE #GLMinorCategory
DROP TABLE #ProfitabilityOverhead
DROP TABLE #ProfitabilityActual

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]    Script Date: 08/05/2010 15:16:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]

	@ImportStartDate	DateTime,
	@ImportEndDate		DateTime,
	@DataPriorToDate	DateTime=NULL
AS

SET NOCOUNT ON
IF @DataPriorToDate IS NULL 
	SET @DataPriorToDate = GETDATE()

PRINT ''####''
PRINT ''stp_IU_LoadGrProfitabiltyPayrollReforecast''
PRINT ''####''


	
/*
[stp_IU_LoadGrProfitabiltyPayrollReforecast]
	@ImportStartDate	= ''1900-01-01'',
	@ImportEndDate		= ''2010-12-31'',
	@DataPriorToDate	= ''2010-12-31''
*/ 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Setup mapping variables
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--/*
-- Setup Bonus Cap Excess Project Setting

CREATE TABLE #SystemSettingRegion
(
	SystemSettingId INT NOT NULL,
	SystemSettingName VARCHAR(50) NOT NULL,
	SystemSettingRegionId INT NOT NULL,
	RegionId INT,
	SourceCode VARCHAR(2),
	BonusCapExcessProjectId INT
)
INSERT INTO #SystemSettingRegion
(
	SystemSettingId,
	SystemSettingName,
	SystemSettingRegionId,
	RegionId,
	SourceCode,
	BonusCapExcessProjectId
)

SELECT 
	ss.SystemSettingId,
	ss.Name,
	ssr.SystemSettingRegionId,
	ssr.RegionId,
	ssr.SourceCode,
	ssr.BonusCapExcessProjectId
FROM
	(SELECT 
		ssr.* 
	 FROM TapasGlobal.SystemSettingRegion ssr
		INNER JOIN TapasGlobal.SystemSettingRegionActive(@DataPriorToDate) ssrA
			ON ssr.ImportKey = ssrA.ImportKey
	 ) ssr
	INNER JOIN
		(SELECT
			ss.SystemSettingId,
			ss.Name
		 FROM
			(SELECT	
				ss.*
			 FROM TapasGlobal.SystemSetting ss
					INNER JOIN TapasGlobal.SystemSettingActive(@DataPriorToDate) ssA 
						ON ss.ImportKey = ssA.ImportKey
			 ) ss

		  ) ss ON ssr.SystemSettingId = ss.SystemSettingId
PRINT ''Completed getting system settings''
PRINT CONVERT(Varchar(27), getdate(), 121)

--*/
-- Setup account categories and default to UNKNOWN.
DECLARE 
	@SalariesTaxesBenefitsMajorGlAccountCategoryId INT = -1,
	@BaseSalaryMinorGlAccountCategoryId INT = -1,
	@BenefitsMinorGlAccountCategoryId INT = -1,
	@BonusMinorGlAccountCategoryId INT = -1,
	@ProfitShareMinorGlAccountCategoryId INT = -1,
	@OccupancyCostsMajorGlAccountCategoryId INT = -1,
	@OverheadMinorGlAccountCategoryId INT = -1

DECLARE 
	@GlAccountKeyUnknown			INT = (SELECT GlAccountKey FROM GrReporting.dbo.GlAccount WHERE Code = ''UNKNOWN''),
	@SourceKeyUnknown				INT = (SELECT SourceKey FROM GrReporting.dbo.[Source] WHERE SourceName = ''UNKNOWN''),
	@FunctionalDepartmentKeyUnknown INT = (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = ''UNKNOWN''),
	@ReimbursableKeyUnknown			INT = (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = ''UNKNOWN''),
	@ActivityTypeKeyUnknown			INT = (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = ''UNKNOWN''),
	@PropertyFundKeyUnknown			INT = (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = ''UNKNOWN''),
	@AllocationRegionKeyUnknown		INT = (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = ''UNKNOWN''),
	@OriginatingRegionKeyUnknown	INT = (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = ''UNKNOWN''),
	@LocalCurrencyKeyUnknown		INT = (SELECT CurrencyKey FROM GrReporting.dbo.Currency WHERE CurrencyCode = ''UNKNOWN'')

DECLARE
	@EUFundGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Fund Profit & Loss''      AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN''),
	@EUCorporateGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Corporate Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN''),
	@EUPropertyGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Property Profit & Loss''  AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN''),
	@USFundGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Fund Profit & Loss''      AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN''),
	@USPropertyGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Property Profit & Loss''  AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN''),
	@USCorporateGlAccountCategoryKeyUnknown INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Corporate Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN''),
	@DevelopmentGlAccountCategoryKeyUnknown INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''Development Profit & Loss''  AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN''),
	@GlobalGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global'' AND TranslationSubTypeName = ''Global'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')

		
-- Set gl account categories
SELECT TOP 1
	@SalariesTaxesBenefitsMajorGlAccountCategoryId = GLMajorCategoryId
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryName = ''Salaries/Taxes/Benefits''

print (@SalariesTaxesBenefitsMajorGlAccountCategoryId)
--NB!!!!!!!
--The roll up to payroll is very sensitive information. It is crutial that information regarding payroll not get 
--communicated to TS employees on certain reports. Changing the category name here will have ramifications because 
--some reports check for this name.
--NB!!!!!!!

SELECT
	@BaseSalaryMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	GLMinorCategoryName = ''Base Salary''

SELECT
	@BenefitsMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	GLMinorCategoryName = ''Benefits''

SELECT
	@BonusMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	GLMinorCategoryName = ''Bonus''

SELECT
	@ProfitShareMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	GLMinorCategoryName = ''Benefits'' -- Yes benefit is correct (Just incase they want to split profit share out again)

SELECT TOP 1
	@OccupancyCostsMajorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMinorCategoryName = ''General Overhead''

SELECT
	@OverheadMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @OccupancyCostsMajorGlAccountCategoryId AND
	GLMinorCategoryName = ''External General Overhead''

DECLARE @SourceSystemId int
SET @SourceSystemId = 2 -- Tapas budgeting source system

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Source Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--/*

CREATE TABLE #GLTranslationType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLTranslationSubType(
	ImportKey INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsGRDefault BIT NOT NULL
)

CREATE TABLE #GLMajorCategory(
	ImportKey INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMinorCategory(
	ImportKey INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLAccountType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLAccountSubType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	GLAccountSubTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

-- #GLTranslationType

INSERT INTO #GLTranslationType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	GLTranslationTypeId,
	Code,
	Name,
	[Description],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	TT.ImportKey,
	TT.ImportBatchId,
	TT.ImportDate,
	TT.GLTranslationTypeId,
	TT.Code,
	TT.Name,
	TT.[Description],
	TT.IsActive,
	TT.InsertedDate,
	TT.UpdatedDate,
	TT.UpdatedByStaffId
FROM
	Gdm.GLTranslationType TT
	INNER JOIN Gdm.GLTranslationTypeActive(@DataPriorToDate) TTA ON
		TTA.ImportKey = TT.ImportKey

-- #GLTranslationSubType

INSERT INTO #GLTranslationSubType(
	ImportKey,
	GLTranslationSubTypeId,
	GLTranslationTypeId,
	Code,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsGRDefault
)
SELECT
	TST.ImportKey,
	TST.GLTranslationSubTypeId,
	TST.GLTranslationTypeId,
	TST.Code,
	TST.[Name],
	TST.IsActive,
	TST.InsertedDate,
	TST.UpdatedDate,
	TST.UpdatedByStaffId,
	TST.IsGRDefault
FROM
	Gdm.GLTranslationSubType TST
	INNER JOIN Gdm.GLTranslationSubTypeActive(@DataPriorToDate) TSTA ON
		TSTA.ImportKey = TST.ImportKey

-- #GLMajorCategory

INSERT INTO #GLMajorCategory(
	ImportKey,
	GLMajorCategoryId,
	GLTranslationSubTypeId,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	MajC.ImportKey,
	MajC.GLMajorCategoryId,
	MajC.GLTranslationSubTypeId,
	MajC.[Name],
	MajC.IsActive,
	MajC.InsertedDate,
	MajC.UpdatedDate,
	MajC.UpdatedByStaffId
FROM
	Gdm.GLMajorCategory MajC
	INNER JOIN Gdm.GLMajorCategoryActive(@DataPriorToDate) MajCA ON
		MajC.ImportKey = MajCA.ImportKey

-- #GLMinorCategory

INSERT INTO #GLMinorCategory(
	ImportKey,
	GLMinorCategoryId,
	GLMajorCategoryId,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	Minc.ImportKey,
	Minc.GLMinorCategoryId,
	Minc.GLMajorCategoryId,
	Minc.[Name],
	Minc.IsActive,
	Minc.InsertedDate,
	Minc.UpdatedDate,
	Minc.UpdatedByStaffId
FROM
	Gdm.GLMinorCategory MinC
	INNER JOIN Gdm.GLMinorCategoryActive(@DataPriorToDate) MinCA ON
		MinCA.ImportKey = MinC.ImportKey

-- #GLAccountType

INSERT INTO #GLAccountType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	GLAccountTypeId,
	GLTranslationTypeId,
	Code,
	Name,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	AT.ImportKey,
	AT.ImportBatchId,
	AT.ImportDate,
	AT.GLAccountTypeId,
	AT.GLTranslationTypeId,
	AT.Code,
	AT.Name,
	AT.IsActive,
	AT.InsertedDate,
	AT.UpdatedDate,
	AT.UpdatedByStaffId	
FROM
	Gdm.GLAccountType AT
	INNER JOIN Gdm.GLAccountTypeActive(@DataPriorToDate) ATA ON
		AT.ImportKey = ATA.ImportKey
	
-- #GLAccountSubType

INSERT INTO #GLAccountSubType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	GLAccountSubTypeId,
	GLTranslationTypeId,
	Code,
	Name,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	AST.ImportKey,
	AST.ImportBatchId,
	AST.ImportDate,
	AST.GLAccountSubTypeId,
	AST.GLTranslationTypeId,
	AST.Code,
	AST.Name,
	AST.IsActive,
	AST.InsertedDate,
	AST.UpdatedDate,
	AST.UpdatedByStaffId
FROM
	Gdm.GLAccountSubType AST
	INNER JOIN Gdm.GLAccountSubTypeActive(@DataPriorToDate) ASTA ON
		AST.ImportKey = ASTA.ImportKey

-- Get GLTranslationType, GLTranslationSubType, GLAccountType(either expense type), and GLAccountSubType(either payroll type) data
-- This table is used when inserts are made to the TranslationSubType CategoryLookup tables: search for ''Map account categories'' section
CREATE TABLE #GLAccountCategoryTranslations(
	GLTranslationTypeId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationSubTypeCode VARCHAR(10) NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL
)

INSERT INTO #GLAccountCategoryTranslations(
	GLTranslationTypeId,
	GLTranslationSubTypeId,
	GLTranslationSubTypeCode,
	GLAccountTypeId,
	GLAccountSubTypeId
)
SELECT
	TST.GLTranslationTypeId,
	TST.GLTranslationSubTypeId,
	TST.Code,
	AT.GLAccountTypeId,
	AST.GLAccountSubTypeId
FROM
	#GLTranslationSubType TST

	INNER JOIN #GLTranslationType TT ON
		TT.GLTranslationTypeId = TST.GLTranslationTypeId

	INNER JOIN #GLAccountType AT ON
		TST.GLTranslationTypeId = AT.GLTranslationTypeId AND
		AT.IsActive = 1

	INNER JOIN #GLAccountSubType AST ON
		TST.GLTranslationTypeId = AST.GLTranslationTypeId AND
		AST.IsActive = 1
	
WHERE
	AST.Code LIKE ''%PYR'' AND -- This stored procedure exclusively looks at payroll. Only consider Account SubTypes related to payroll.
	AT.Code LIKE ''%EXP'' AND -- Only consider expense-related account types: Payroll is always considered as an expense.
	TT.IsActive = 1 AND
	TST.IsActive = 1 AND
	AT.IsActive = 1 AND
	AST.IsActive = 1

PRINT ''Completed getting GlAccountCategory records''
PRINT CONVERT(Varchar(27), getdate(), 121)
------------------------------------------------------------------------------------------------------
--Source and identify report grouping records
------------------------------------------------------------------------------------------------------

-- Source budget report group detail. 



CREATE TABLE #BudgetReportGroupDetail(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetReportGroupDetailId INT NOT NULL,
	BudgetReportGroupId INT NOT NULL,
	RegionId INT NOT NULL,
	BudgetId INT NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)


INSERT INTO #BudgetReportGroupDetail(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetReportGroupDetailId,
	BudgetReportGroupId,
	RegionId,
	BudgetId,
	IsDeleted,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	brgd.*
FROM 
	TapasGlobalBudgeting.BudgetReportGroupDetail brgd
	INNER JOIN TapasGlobalBudgeting.BudgetReportGroupDetailActive(@DataPriorToDate) brgdA ON
		brgd.ImportKey = brgdA.ImportKey

--select * from #BudgetReportGroupDetail
		
PRINT ''Completed inserting records from BudgetReportGroupDetail:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget report group.

CREATE TABLE #BudgetReportGroup(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetReportGroupId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	BudgetExchangeRateId INT NOT NULL,
	IsReforecast BIT NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NOT NULL,
	FirstProjectedPeriod INT NULL,
	IsDeleted BIT NOT NULL,
	GRChangedDate DATETIME NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	BudgetReportGroupPeriodId INT NULL
)

INSERT INTO #BudgetReportGroup(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetReportGroupId,
	Name,
	BudgetExchangeRateId,
	IsReforecast,
	StartPeriod,
	EndPeriod,
	FirstProjectedPeriod,
	IsDeleted,
	GRChangedDate,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	BudgetReportGroupPeriodId
)
SELECT 
	brg.* 
FROM 
	TapasGlobalBudgeting.BudgetReportGroup brg
	INNER JOIN TapasGlobalBudgeting.BudgetReportGroupActive(@DataPriorToDate) brgA ON
		brg.ImportKey = brgA.ImportKey

--select * from #BudgetReportGroup
	
PRINT ''Completed inserting records from BudgetReportGroup:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source report group period mapping.

CREATE TABLE #BudgetReportGroupPeriod(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetReportGroupPeriodId INT NOT NULL,
	BudgetExchangeRateId INT NOT NULL,
	[Year] INT NOT NULL,
	Period INT NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetReportGroupPeriod(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetReportGroupPeriodId,
	BudgetExchangeRateId,
	[Year],
	Period,
	IsDeleted,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	brgp.*
FROM
	Gdm.BudgetReportGroupPeriod brgp
	INNER JOIN Gdm.BudgetReportGroupPeriodActive(@DataPriorToDate) brgpA ON
		brgp.ImportKey = brgpA.ImportKey

--select * from #BudgetReportGroupPeriod

PRINT ''Completed inserting records from GRBudgetReportGroupPeriod:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget status

CREATE TABLE #BudgetStatus(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetStatusId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	[Description] VARCHAR(100) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetStatus(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetStatusId,
	Name,
	[Description],
	InsertedDate,
	UpdatedByStaffId
)
SELECT 
	BudgetStatus.* 
FROM
	TapasGlobalBudgeting.BudgetStatus BudgetStatus
	INNER JOIN TapasGlobalBudgeting.BudgetStatusActive(@DataPriorToDate) BudgetStatusA ON
		BudgetStatus.ImportKey = BudgetStatusA.ImportKey
		
PRINT ''Completed inserting records from BudgetStatus:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source all active budget

CREATE TABLE #AllActiveBudget(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetId INT NOT NULL,
	RegionId INT NOT NULL,
	BudgetTypeId INT NOT NULL,
	BudgetStatusId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NOT NULL,
	FirstProjectedPeriod INT NULL,
	CurrencyCode VARCHAR(3) NOT NULL,
	CanEmployeesViewBudget BIT NOT NULL,
	IsReforecast BIT NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	LastLockedDate DATETIME NULL,
	BudgetAllocationSetId INT NULL,
	LastAMUpdateDate DATETIME NULL
)

INSERT INTO #AllActiveBudget(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetId,
	RegionId,
	BudgetTypeId,
	BudgetStatusId,
	Name,
	StartPeriod,
	EndPeriod,
	FirstProjectedPeriod,
	CurrencyCode,
	CanEmployeesViewBudget,
	IsReforecast,
	IsDeleted,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	LastLockedDate,
	BudgetAllocationSetId,
	LastAMUpdateDate
)
SELECT 
	Budget.*
FROM
	TapasGlobalBudgeting.Budget Budget
	INNER JOIN TapasGlobalBudgeting.BudgetActive(@DataPriorToDate) BudgetA ON
		Budget.ImportKey = BudgetA.ImportKey
		
PRINT ''Completed inserting records from Budget:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Modified new or modified budget or report group setup.

CREATE TABLE #AllModifiedReportBudget(
	BudgetId INT NOT NULL,
	BudgetReportGroupId INT NOT NULL,
	BudgetReportGroupPeriodId INT NOT NULL,
	IsBudgetDeleted BIT NOT NULL,
	IsBugetReforecast BIT NOT NULL,
	BudgetStatusId INT NOT NULL,
	BudgetFirstProjectedPeriod INT NULL,
	IsDetailDeleted BIT NOT NULL,
	IsGroupReforecast BIT NOT NULL,
	GroupStartPeriod INT NOT NULL,
	GroupEndPeriod INT NOT NULL,
	IsGroupDeleted BIT NOT NULL,
	IsPeriodDeleted BIT NOT NULL
)

INSERT INTO #AllModifiedReportBudget(
	BudgetId, 
	BudgetReportGroupId,
	BudgetReportGroupPeriodId,
	IsBudgetDeleted,
	IsBugetReforecast,
	BudgetStatusId, 
	BudgetFirstProjectedPeriod,
	IsDetailDeleted, 
	IsGroupReforecast, 
	GroupStartPeriod, 
	GroupEndPeriod, 
	IsGroupDeleted,
	IsPeriodDeleted
)
SELECT 
	brgd.BudgetId, 
	brgd.BudgetReportGroupId,
	brgp.BudgetReportGroupPeriodId,
	Budget.IsDeleted AS IsBudgetDeleted,
	Budget.IsReforecast AS IsBugetReforecast,
	Budget.BudgetStatusId, 
	Budget.FirstProjectedPeriod AS BudgetFirstProjectedPeriod,
	brgd.IsDeleted AS IsDetailDeleted, 
	brg.IsReforecast AS IsGroupReforecast, 
	brg.StartPeriod AS GroupStartPeriod, 
	brg.EndPeriod AS GroupEndPeriod, 
	brg.IsDeleted AS IsGroupDeleted,
	brgp.IsDeleted AS IsPeriodDeleted
FROM
	#AllActiveBudget Budget

    INNER JOIN #BudgetReportGroupDetail brgd ON
		Budget.BudgetId = brgd.BudgetId
    
    INNER JOIN #BudgetReportGroup brg ON
		brgd.BudgetReportGroupId = brg.BudgetReportGroupId
    
    INNER JOIN #BudgetReportGroupPeriod brgp ON
		brg.BudgetReportGroupPeriodId = brgp.BudgetReportGroupPeriodId 
		
WHERE
	(brgd.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
	(brg.GRChangedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
	(brgp.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
	(Budget.LastLockedDate IS NOT NULL AND Budget.LastLockedDate BETWEEN @ImportStartDate AND @ImportEndDate)

--select * from #AllModifiedReportBudget

PRINT ''Completed inserting records into #AllModifiedReportBudget:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Filtered budget and setup report group setup

CREATE TABLE #LockedModifiedReportGroup(
	BudgetReportGroupId INT NOT NULL
)

INSERT INTO #LockedModifiedReportGroup(
	BudgetReportGroupId
)
SELECT
	amrb.BudgetReportGroupId
FROM
	#AllModifiedReportBudget amrb
	
	INNER JOIN #BudgetStatus bs ON
		amrb.BudgetStatusId = bs.BudgetStatusId
GROUP BY
	amrb.BudgetReportGroupId
HAVING
	COUNT(*) = SUM(CASE WHEN bs.[Name] = ''Locked'' THEN 1 ELSE 0 END) 

PRINT ''Completed inserting records into #LockedModifiedReportGroup:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source filtered budget information

CREATE TABLE #FilteredModifiedReportBudget(
	BudgetId INT NOT NULL,
	BudgetReportGroupId INT NOT NULL,
	BudgetReportGroupPeriodId INT NOT NULL,
	IsBudgetDeleted BIT NOT NULL,
	IsBugetReforecast BIT NOT NULL,
	BudgetStatusId INT NOT NULL,
	BudgetFirstProjectedPeriod INT NULL,
	IsDetailDeleted BIT NOT NULL,
	IsGroupReforecast BIT NOT NULL,
	GroupStartPeriod INT NOT NULL,
	GroupEndPeriod INT NOT NULL,
	IsGroupDeleted BIT NOT NULL,
	IsPeriodDeleted BIT NOT NULL,
	BudgetReportGroupPeriod INT NOT NULL
)

INSERT INTO #FilteredModifiedReportBudget(
	BudgetId,
	BudgetReportGroupId,
	BudgetReportGroupPeriodId,
	IsBudgetDeleted,
	IsBugetReforecast,
	BudgetStatusId,
	BudgetFirstProjectedPeriod,
	IsDetailDeleted,
	IsGroupReforecast,
	GroupStartPeriod,
	GroupEndPeriod,
	IsGroupDeleted,
	IsPeriodDeleted,
	BudgetReportGroupPeriod 
)
SELECT
	amrb.*,
	brgp.Period BudgetReportGroupPeriod
FROM
	#LockedModifiedReportGroup lmrg
	
	INNER JOIN #AllModifiedReportBudget amrb ON
		lmrg.BudgetReportGroupId = amrb.BudgetReportGroupId

	INNER JOIN #BudgetReportGroupPeriod brgp ON
		brgp.BudgetReportGroupPeriodId = amrb.BudgetReportGroupPeriodId
		
WHERE
	amrb.IsBudgetDeleted = 0 AND
	amrb.IsBugetReforecast = 1 AND
	amrb.IsDetailDeleted = 0 AND
	amrb.IsGroupReforecast = 1 AND
	amrb.IsGroupDeleted = 0 AND
	amrb.IsPeriodDeleted = 0 AND
	brgp.IsDeleted = 0

PRINT ''Completed inserting records into #FilteredModifiedReportBudget:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--select * from #FilteredModifiedReportBudget

-- Source budget information that meet criteria

CREATE TABLE #Budget(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetId INT NOT NULL,
	RegionId INT NOT NULL,
	BudgetTypeId INT NOT NULL,
	BudgetStatusId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NOT NULL,
	FirstProjectedPeriod INT NULL,
	CurrencyCode VARCHAR(3) NOT NULL,
	CanEmployeesViewBudget BIT NOT NULL,
	IsReforecast BIT NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	LastLockedDate DATETIME NULL,
	BudgetAllocationSetId INT NULL,
	LastAMUpdateDate DATETIME NULL
)

INSERT INTO #Budget(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetId,
	RegionId,
	BudgetTypeId,
	BudgetStatusId,
	Name,
	StartPeriod,
	EndPeriod,
	FirstProjectedPeriod,
	CurrencyCode,
	CanEmployeesViewBudget,
	IsReforecast,
	IsDeleted,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	LastLockedDate,
	BudgetAllocationSetId,
	LastAMUpdateDate
)
SELECT 
	Budget.*
FROM
	#AllActiveBudget Budget
	
	INNER JOIN #FilteredModifiedReportBudget fmrb ON
		Budget.BudgetId = fmrb.BudgetId
PRINT ''Completed inserting records into #Budget:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetID ON #Budget (BudgetId)
PRINT ''Completed creating indexes on #Budget''
PRINT CONVERT(Varchar(27), getdate(), 121)

--select * from #Budget

--*/
------------------------------------------------------------------------------------------------------
--Source associated records
------------------------------------------------------------------------------------------------------

--/*
-- Source budget project

CREATE TABLE #BudgetProject(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetProjectId INT NOT NULL,
	BudgetId INT NOT NULL,
	ProjectId INT NULL,
	RegionId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	ActivityTypeId INT NOT NULL,
	Code VARCHAR(50) NULL,
	Name VARCHAR(100) NULL,
	CorporateDepartmentCode VARCHAR(6) NULL,
	CorporateSourceCode VARCHAR(2) NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NULL,
	IsReimbursable BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetProjectId INT NULL,
	IsTsCost BIT NOT NULL,
	CanAllocateOverheads BIT NOT NULL,
	AllocateOverheadsProjectId INT NULL,
	MarkUpPercentage DECIMAL(5, 4) NULL,
	ProjectOwnerStaffId INT NULL,
	AMBudgetProjectId INT NULL
)

INSERT INTO #BudgetProject(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetProjectId,
	BudgetId,
	ProjectId,
	RegionId,
	PropertyFundId,
	ActivityTypeId,
	Code,
	Name,
	CorporateDepartmentCode,
	CorporateSourceCode,
	StartPeriod,
	EndPeriod,
	IsReimbursable,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetProjectId,
	IsTsCost,
	CanAllocateOverheads,
	AllocateOverheadsProjectId,
	MarkUpPercentage,
	ProjectOwnerStaffId,
	AMBudgetProjectId
)
SELECT 
	BudgetProject.*
FROM 
	TapasGlobalBudgeting.BudgetProject BudgetProject
	INNER JOIN TapasGlobalBudgeting.BudgetProjectActive(@DataPriorToDate) BudgetProjectA ON
		BudgetProject.ImportKey = BudgetProjectA.ImportKey
		
	-- data limiting join
	INNER JOIN #Budget b ON
		BudgetProject.BudgetId = b.BudgetId

--select * from #BudgetProject

PRINT ''Completed inserting records into #BudgetProject:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetID ON #BudgetProject (BudgetId)
PRINT ''Completed creating indexes on #BudgetProject''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source region

CREATE TABLE #Region(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	RegionId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	PayCode VARCHAR(5) NULL,
	EnrollmentTypeId INT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

INSERT INTO #Region(
	ImportKey,
	ImportBatchId,
	ImportDate,
	RegionId,
	SourceCode,
	Code,
	Name,
	PayCode,
	EnrollmentTypeId,
	InsertedDate,
	UpdatedDate
)
SELECT 
	SourceRegion.*
FROM 
	HR.Region SourceRegion
	INNER JOIN HR.RegionActive(@DataPriorToDate) SourceRegionA ON
		SourceRegion.ImportKey = SourceRegionA.ImportKey
PRINT ''Completed inserting records into #Region:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Budget Employee

CREATE TABLE #BudgetEmployee(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	BudgetId INT NOT NULL,
	HrEmployeeId INT NULL,
	PayGroupId INT NOT NULL,
	JobTitleId INT NOT NULL,
	LocationId INT NOT NULL,
	StateId INT NULL,
	OverheadRegionId INT NOT NULL,
	ApproverStaffId INT NULL,
	Name VARCHAR(255) NOT NULL,
	IsUnion BIT NOT NULL,
	RehirePeriod INT NOT NULL,
	RehireDate DATETIME NOT NULL,
	TerminatePeriod INT NULL,
	TerminateDate DATETIME NULL,
	EmployeeHistoryEffectivePeriod INT NOT NULL,
	EmployeeHistoryEffectiveDate DATETIME NOT NULL,
	EmployeePayrollEffectiveDate DATETIME NULL,
	CurrentAnnualSalary DECIMAL(18, 2) NULL,
	PreviousYearSalary DECIMAL(18, 2) NULL,
	SalaryYear INT NOT NULL,
	PreviousYearBonus DECIMAL(18, 2) NULL,
	BonusYear INT NULL,
	IsActualEmployee BIT NOT NULL,
	IsReviewed BIT NOT NULL,
	IsPartTime BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetEmployeeId INT NULL
)

INSERT INTO #BudgetEmployee(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeeId,
	BudgetId,
	HrEmployeeId,
	PayGroupId,
	JobTitleId,
	LocationId,
	StateId,
	OverheadRegionId ,
	ApproverStaffId,
	Name,
	IsUnion,
	RehirePeriod,
	RehireDate,
	TerminatePeriod,
	TerminateDate,
	EmployeeHistoryEffectivePeriod,
	EmployeeHistoryEffectiveDate,
	EmployeePayrollEffectiveDate,
	CurrentAnnualSalary,
	PreviousYearSalary,
	SalaryYear,
	PreviousYearBonus,
	BonusYear,
	IsActualEmployee,
	IsReviewed,
	IsPartTime,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetEmployeeId
)
SELECT 
	BudgetEmployee.* 
FROM 
	TapasGlobalBudgeting.BudgetEmployee BudgetEmployee
	INNER JOIN TapasGlobalBudgeting.BudgetEmployeeActive(@DataPriorToDate) BudgetEmployeeA ON
		BudgetEmployee.ImportKey = BudgetEmployeeA.ImportKey

	--data limiting join
	INNER JOIN #Budget b ON
		BudgetEmployee.BudgetId = b.BudgetId

PRINT ''Completed inserting records into #Region:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeeID ON #BudgetEmployee (BudgetEmployeeId)
CREATE INDEX IX_BudgetId ON #BudgetEmployee (BudgetId)

PRINT ''Completed creating indexes on ##BudgetEmployee''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Budget Employee Functional Department

CREATE TABLE #BudgetEmployeeFunctionalDepartment(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeeFunctionalDepartmentId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	SubDepartmentId INT NOT NULL,
	EffectivePeriod INT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL
)

INSERT INTO #BudgetEmployeeFunctionalDepartment(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeeFunctionalDepartmentId,
	BudgetEmployeeId,
	SubDepartmentId,
	EffectivePeriod,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	FunctionalDepartmentId
)
SELECT 
	efd.* 
FROM 
	TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment efd
	INNER JOIN TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartmentActive(@DataPriorToDate) efdA ON
		efd.ImportKey = efdA.ImportKey

	-- data limiting join
	INNER JOIN #BudgetEmployee be ON
		efd.BudgetEmployeeId = be.BudgetEmployeeId

PRINT ''Completed inserting records into #BudgetEmployeeFunctionalDepartment:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeeId ON #BudgetEmployeeFunctionalDepartment (BudgetEmployeeId)
PRINT ''Completed creating indexes on #BudgetEmployeeFunctionalDepartment''
PRINT CONVERT(Varchar(27), getdate(), 121)



-- Source Functional Department

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
	HR.FunctionalDepartment fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) fdA ON
		fd.ImportKey = fdA.ImportKey

PRINT ''Completed inserting records into #FunctionalDepartment:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_FunctionalDepartmentId ON #FunctionalDepartment (FunctionalDepartmentId)
PRINT ''Completed creating indexes on #FunctionalDepartment''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Property Fund

CREATE TABLE #PropertyFund(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	PropertyFundId INT NOT NULL,
	RelatedFundId INT NULL,
	EntityTypeId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	BudgetOwnerStaffId INT NOT NULL,
	RegionalOwnerStaffId INT NOT NULL,
	DefaultGLTranslationSubTypeId INT NULL,
	Name VARCHAR(100) NOT NULL,
	IsReportingEntity BIT NOT NULL,
	IsPropertyFund BIT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #PropertyFund(
	ImportKey,
	ImportBatchId,
	ImportDate,
	PropertyFundId,
	RelatedFundId,
	EntityTypeId,
	AllocationSubRegionGlobalRegionId,
	BudgetOwnerStaffId,
	RegionalOwnerStaffId,
	DefaultGLTranslationSubTypeId,
	Name,
	IsReportingEntity,
	IsPropertyFund,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT 
	PropertyFund.*
FROM 
	Gdm.PropertyFund PropertyFund
	INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PropertyFundA ON
		PropertyFund.ImportKey = PropertyFundA.ImportKey 

PRINT ''Completed inserting records into #PropertyFund:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFund (PropertyFundId)
PRINT ''Completed creating indexes on #PropertyFund''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Property Fund Mapping

CREATE TABLE #PropertyFundMapping(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	PropertyFundMappingId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	PropertyFundCode VARCHAR(8) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL,
	ActivityTypeId INT NULL
)

INSERT INTO #PropertyFundMapping(
	ImportKey,
	ImportBatchId,
	ImportDate,
	PropertyFundMappingId,
	PropertyFundId,
	SourceCode,
	PropertyFundCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted,
	ActivityTypeId
)
SELECT 
	PropertyFundMapping.* 
FROM 
	Gdm.PropertyFundMapping PropertyFundMapping
	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PropertyFundMappingA ON
		PropertyFundMapping.ImportKey = PropertyFundMappingA.ImportKey 

PRINT ''Completed inserting records into #PropertyFundMapping:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFundMapping (PropertyFundCode,SourceCode,IsDeleted,PropertyFundId,ActivityTypeId)
PRINT ''Completed creating indexes on #PropertyFundMapping''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source ReportingEntityCorporateDepartment

CREATE TABLE #ReportingEntityCorporateDepartment( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	ReportingEntityCorporateDepartmentId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	CorporateDepartmentCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsDeleted BIT NOT NULL,
)

INSERT INTO	#ReportingEntityCorporateDepartment(
	ImportKey,
	ReportingEntityCorporateDepartmentId,
	PropertyFundId,
	SourceCode,
	CorporateDepartmentCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsDeleted
)
SELECT
	RECD.ImportKey,
	RECD.ReportingEntityCorporateDepartmentId,
	RECD.PropertyFundId,
	RECD.SourceCode,
	RECD.CorporateDepartmentCode,
	RECD.InsertedDate,
	RECD.UpdatedDate,
	RECD.UpdatedByStaffId,
	RECD.IsDeleted
FROM
	Gdm.ReportingEntityCorporateDepartment RECD
	INNER JOIN Gdm.ReportingEntityCorporateDepartmentActive(@DataPriorToDate) RECDA ON
		RECDA.ImportKey = RECD.ImportKey

PRINT ''Completed creating indexes on #ReportingEntityCorporateDepartment''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source ReportingEntityPropertyEntity

CREATE TABLE #ReportingEntityPropertyEntity( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	ReportingEntityPropertyEntityId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	PropertyEntityCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsDeleted BIT NOT NULL
)

INSERT INTO #ReportingEntityPropertyEntity(
	ImportKey,
	ReportingEntityPropertyEntityId,
	PropertyFundId,
	SourceCode,
	PropertyEntityCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsDeleted
)
SELECT
	REPE.ImportKey,
	REPE.ReportingEntityPropertyEntityId,
	REPE.PropertyFundId,
	REPE.SourceCode,
	REPE.PropertyEntityCode,
	REPE.InsertedDate,
	REPE.UpdatedDate,
	REPE.UpdatedByStaffId,
	REPE.IsDeleted
FROM
	Gdm.ReportingEntityPropertyEntity REPE
	INNER JOIN Gdm.ReportingEntityPropertyEntityActive(@DataPriorToDate) REPEA ON
		REPEA.ImportKey = REPE.ImportKey

PRINT ''Completed creating indexes on #ReportingEntityPropertyEntity''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Location

CREATE TABLE #Location(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	LocationId INT NOT NULL,
	ExternalSubRegionId INT NOT NULL,
	StateId INT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

INSERT INTO #Location(
	ImportKey,
	ImportBatchId,
	ImportDate,
	LocationId,
	ExternalSubRegionId,
	StateId,
	Code,
	Name,
	IsActive,
	InsertedDate,
	UpdatedDate
)
SELECT 
	Location.* 
FROM 
	HR.Location Location
	INNER JOIN HR.LocationActive(@DataPriorToDate) LocationA ON
		Location.ImportKey = LocationA.ImportKey
	
PRINT ''Completed inserting records into #Location:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_LocationId ON #Location (LocationId)
PRINT ''Completed creating indexes on #Location''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source region extended

CREATE TABLE #RegionExtended(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	RegionId INT NOT NULL,
	RegionalAdministratorId INT NOT NULL,
	CountryId INT NOT NULL,
	HasEmployees BIT NOT NULL,
	CanChargeMarkupOnProject BIT NOT NULL,
	CanChargeMarkupOnPayrollOverhead BIT NOT NULL,
	CanUploadOverheadJournal BIT NOT NULL,
	ProjectRef VARCHAR(8) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OverheadFunctionalDepartmentId INT NOT NULL,
	CanRegionBillInArrears BIT NOT NULL
)

INSERT INTO #RegionExtended(
	ImportKey,
	ImportBatchId,
	ImportDate,
	RegionId,
	RegionalAdministratorId,
	CountryId,
	HasEmployees,
	CanChargeMarkupOnProject,
	CanChargeMarkupOnPayrollOverhead,
	CanUploadOverheadJournal,
	ProjectRef,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OverheadFunctionalDepartmentId,
	CanRegionBillInArrears
)
SELECT 
	RegionExtended.*
FROM 
	TapasGlobal.RegionExtended RegionExtended
	INNER JOIN TapasGlobal.RegionExtendedActive(@DataPriorToDate) RegionExtendedA ON
		RegionExtended.ImportKey = RegionExtendedA.ImportKey

PRINT ''Completed inserting records into #RegionExtended:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_RegionId ON #RegionExtended (RegionId)
PRINT ''Completed creating indexes on #RegionExtended''
PRINT CONVERT(Varchar(27), getdate(), 121)


-- Source Payroll Originating Region

CREATE TABLE #PayrollRegion(
	ImportKey INT NOT NULL,
	PayrollRegionId INT NOT NULL,
	RegionId INT NOT NULL,
	ExternalSubRegionId INT NOT NULL,
	CorporateEntityRef VARCHAR(6) NOT NULL,
	CorporateSourceCode VARCHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #PayrollRegion(
	ImportKey,
	PayrollRegionId,
	RegionId,
	ExternalSubRegionId,
	CorporateEntityRef,
	CorporateSourceCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT 
	PayrollRegion.*
FROM 
	TapasGlobal.PayrollRegion PayrollRegion
	INNER JOIN TapasGlobal.PayrollRegionActive(@DataPriorToDate) PayrollRegionA ON
		PayrollRegion.ImportKey = PayrollRegionA.ImportKey
	
PRINT ''Completed inserting records into #PayrollRegion:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PayrollRegionId ON #PayrollRegion (PayrollRegionId)
PRINT ''Completed creating indexes on #PayrollRegion''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Overhead Originating Region

CREATE TABLE #OverheadRegion(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	OverheadRegionId INT NOT NULL,
	RegionId INT NOT NULL,
	CorporateEntityRef VARCHAR(6) NULL,
	CorporateSourceCode VARCHAR(2) NULL,
	Name VARCHAR(50) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #OverheadRegion(
	ImportKey,
	ImportBatchId,
	ImportDate,
	OverheadRegionId,
	RegionId,
	CorporateEntityRef,
	CorporateSourceCode,
	Name,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)

SELECT 
	OverheadRegion.*
FROM 
	TapasGlobal.OverheadRegion OverheadRegion
	INNER JOIN TapasGlobal.OverheadRegionActive(@DataPriorToDate) OverheadRegionA ON
		OverheadRegion.ImportKey = OverheadRegionA.ImportKey
	
PRINT ''Completed inserting records into #OverheadRegion:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_OverheadRegionId ON #OverheadRegion (OverheadRegionId)
PRINT ''Completed creating indexes on #OverheadRegion''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source project

CREATE TABLE #Project(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	ProjectId INT NOT NULL,
	RegionId INT NOT NULL,
	ActivityTypeId INT NOT NULL,
	ProjectOwnerId INT NULL,
	CorporateDepartmentCode VARCHAR(8) NOT NULL,
	CorporateSourceCode CHAR(2) NOT NULL,
	Code VARCHAR(50) NOT NULL,
	Name VARCHAR(100) NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	PropertyOverheadGLAccountCode VARCHAR(15) NULL,
	PropertyOverheadDepartmentCode VARCHAR(6) NULL,
	PropertyOverheadJobCode VARCHAR(15) NULL,
	PropertyOverheadSourceCode CHAR(2) NULL,
	CorporateUnionPayrollIncomeCategoryCode VARCHAR(6) NULL,
	CorporateNonUnionPayrollIncomeCategoryCode VARCHAR(6) NULL,
	CorporateOverheadIncomeCategoryCode VARCHAR(6) NULL,
	PropertyFundId INT NOT NULL,
	MarkUpPercentage DECIMAL(5, 4) NULL,
	HistoricalProjectCode VARCHAR(50) NULL,
	IsTSCost BIT NOT NULL,
	CanAllocateOverheads BIT NOT NULL,
	AllocateOverheadsProjectId INT NULL
)

INSERT INTO #Project(
	ImportKey,
	ImportBatchId,
	ImportDate,
	ProjectId,
	RegionId,
	ActivityTypeId,
	ProjectOwnerId,
	CorporateDepartmentCode,
	CorporateSourceCode,
	Code,
	Name,
	StartPeriod,
	EndPeriod,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	PropertyOverheadGLAccountCode,
	PropertyOverheadDepartmentCode,
	PropertyOverheadJobCode,
	PropertyOverheadSourceCode,
	CorporateUnionPayrollIncomeCategoryCode,
	CorporateNonUnionPayrollIncomeCategoryCode,
	CorporateOverheadIncomeCategoryCode,
	PropertyFundId,
	MarkUpPercentage,
	HistoricalProjectCode,
	IsTSCost,
	CanAllocateOverheads,
	AllocateOverheadsProjectId
)
SELECT 
	Project.*
FROM 
	TapasGlobal.Project Project
	INNER JOIN TapasGlobal.ProjectActive(@DataPriorToDate) ProjectA ON
		Project.ImportKey = ProjectA.ImportKey 

PRINT ''Completed inserting records into #Project:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_ProjectId ON #Project (ProjectId)
PRINT ''Completed creating indexes on #Project''
PRINT CONVERT(Varchar(27), getdate(), 121)


------------------------------------------------------------------------------------------------------
--Source allocation records
------------------------------------------------------------------------------------------------------

-- Source payroll allocation

CREATE TABLE #BudgetEmployeePayrollAllocation(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	BudgetProjectId INT NOT NULL,
	BudgetProjectGroupId INT NULL,
	Period INT NOT NULL,
	SalaryAllocationValue DECIMAL(18, 9) NOT NULL,
	BonusAllocationValue DECIMAL(18, 9) NULL,
	BonusCapAllocationValue DECIMAL(18, 9) NULL,
	ProfitShareAllocationValue DECIMAL(18, 9) NULL,
	PreTaxSalaryAmount DECIMAL(18, 2) NOT NULL,
	PreTaxBonusAmount DECIMAL(18, 2) NULL,
	PreTaxBonusCapExcessAmount DECIMAL(18, 2) NULL,
	PreTaxProfitShareAmount DECIMAL(18, 2) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetEmployeePayrollAllocationId INT NULL
)

INSERT INTO #BudgetEmployeePayrollAllocation(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeePayrollAllocationId,
	BudgetEmployeeId,
	BudgetProjectId,
	BudgetProjectGroupId,
	Period,
	SalaryAllocationValue,
	BonusAllocationValue,
	BonusCapAllocationValue,
	ProfitShareAllocationValue,
	PreTaxSalaryAmount,
	PreTaxBonusAmount,
	PreTaxBonusCapExcessAmount,
	PreTaxProfitShareAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetEmployeePayrollAllocationId
)
SELECT
	Allocation.*
FROM
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocation Allocation

	INNER JOIN TapasGlobalBudgeting.BudgetEmployeePayrollAllocationActive(@DataPriorToDate) AllocationA ON
		Allocation.ImportKey = AllocationA.ImportKey

	--data limiting join
	INNER JOIN #BudgetProject bp ON
		Allocation.BudgetProjectId = bp.BudgetProjectId

PRINT ''Completed inserting records into #BudgetEmployeePayrollAllocation:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationId ON #BudgetEmployeePayrollAllocation (BudgetEmployeePayrollAllocationId)
PRINT ''Completed creating indexes on #BudgetEmployeePayrollAllocation''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source payroll tax detail
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Using the ''active'' function here cause serious performance issues and the only way around it, was to extract the logic from the is active function 
--to seperate peaces of code.
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #BudgetEmployeePayrollAllocationDetailBatches(
	BudgetEmployeePayrollAllocationDetailId int NOT NULL,
	ImportBatchId INT NOT NULL
)

INSERT INTO #BudgetEmployeePayrollAllocationDetailBatches(
	BudgetEmployeePayrollAllocationDetailId,
	ImportBatchId
)
SELECT 
	B2.BudgetEmployeePayrollAllocationDetailId,
	MAX(B2.ImportBatchId) AS ImportBatchId
FROM 
	[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B2
		
	INNER JOIN Batch ON
		B2.ImportBatchId = batch.BatchId		
WHERE	
	batch.BatchEndDate IS NOT NULL AND
	batch.PackageName = ''ETL.Staging.TapasGlobalBudgeting'' AND
	batch.ImportEndDate <= @DataPriorToDate		
GROUP BY
	B2.BudgetEmployeePayrollAllocationDetailId

PRINT ''Completed inserting records into #BudgetEmployeePayrollAllocationDetailBatches:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE TABLE #BEPADa(
	ImportKey INT NOT NULL
)

INSERT INTO #BEPADa(
	ImportKey
)
SELECT
	MAX(B1.ImportKey) ImportKey
FROM
	[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B1

	INNER JOIN #BudgetEmployeePayrollAllocationDetailBatches t1 ON 
		t1.BudgetEmployeePayrollAllocationDetailId = B1.BudgetEmployeePayrollAllocationDetailId AND
		t1.ImportBatchId = B1.ImportBatchId

GROUP BY
	B1.BudgetEmployeePayrollAllocationDetailId

PRINT ''Completed inserting records into #BEPADa:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #BudgetEmployeePayrollAllocationDetail(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	BenefitOptionId INT NULL,
	BudgetTaxTypeId INT NULL,
	SalaryAmount DECIMAL(18, 2) NULL,
	BonusAmount DECIMAL(18, 2) NULL,
	ProfitShareAmount DECIMAL(18, 2) NULL,
	BonusCapExcessAmount DECIMAL(18, 2) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetEmployeePayrollAllocationDetail(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeePayrollAllocationDetailId,
	BudgetEmployeePayrollAllocationId,
	BenefitOptionId,
	BudgetTaxTypeId,
	SalaryAmount,
	BonusAmount,
	ProfitShareAmount,
	BonusCapExcessAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	TaxDetail.*
FROM
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocationDetail TaxDetail
	
	INNER JOIN #BEPADa TaxDetailA ON
		TaxDetail.ImportKey = TaxDetailA.ImportKey

	--data limiting join
	INNER JOIN #BudgetEmployeePayrollAllocation Allocation ON
		TaxDetail.BudgetEmployeePayrollAllocationId = Allocation.BudgetEmployeePayrollAllocationId

PRINT ''Completed inserting records into #BudgetEmployeePayrollAllocationDetail:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationDetailId ON #BudgetEmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationDetailId)
PRINT ''Completed creating indexes on #BudgetEmployeePayrollAllocationDetail''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget tax type

CREATE TABLE #BudgetTaxType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetTaxTypeId INT NOT NULL,
	BudgetId INT NOT NULL,
	TaxTypeId INT NOT NULL,
	FixedTaxTypeId INT NOT NULL,
	RateCalculationMethodId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetTaxTypeId INT NULL
)

INSERT INTO #BudgetTaxType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetTaxTypeId,
	BudgetId,
	TaxTypeId,
	FixedTaxTypeId,
	RateCalculationMethodId,
	Name,
	InsertedDate,
	UpdatedByStaffId,
	OriginalBudgetTaxTypeId
)
SELECT 
	BudgetTaxType.* 
FROM 
	TapasGlobalBudgeting.BudgetTaxType BudgetTaxType
	INNER JOIN TapasGlobalBudgeting.BudgetTaxTypeActive(@DataPriorToDate) BudgetTaxTypeA ON
		BudgetTaxType.ImportKey = BudgetTaxTypeA.ImportKey

	-- data limiting join
	INNER JOIN #Budget b ON
		BudgetTaxType.BudgetId = b.BudgetId

PRINT ''Completed inserting records into #BudgetTaxType:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetTaxTypeId ON #BudgetTaxType (BudgetTaxTypeId)
PRINT ''Completed creating indexes on #BudgetTaxType''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source tax type

CREATE TABLE #TaxType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	TaxTypeId INT NOT NULL,
	RegionId INT NOT NULL,
	FixedTaxTypeId INT NOT NULL,
	RateCalculationMethodId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL
)

INSERT INTO #TaxType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	TaxTypeId,
	RegionId,
	FixedTaxTypeId,
	RateCalculationMethodId,
	Name,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	MinorGlAccountCategoryId
)
SELECT 
	TaxType.*
FROM 
	TapasGlobalBudgeting.TaxType TaxType
	INNER JOIN TapasGlobalBudgeting.TaxTypeActive(@DataPriorToDate) TaxTypeA ON
		TaxType.ImportKey = TaxTypeA.ImportKey

PRINT ''Completed inserting records into #TaxType:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source payroll allocation Tax detail
CREATE TABLE #EmployeePayrollAllocationDetail
(
	ImportKey INT NOT NULL,
	BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	MinorGlAccountCategoryId INT NULL,
	BudgetTaxTypeId INT NULL,
	SalaryAmount DECIMAL(18, 2) NULL,
	BonusAmount DECIMAL(18, 2) NULL,
	ProfitShareAmount DECIMAL(18, 2) NULL,
	BonusCapExcessAmount DECIMAL(18, 2) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #EmployeePayrollAllocationDetail
(
	ImportKey,
	BudgetEmployeePayrollAllocationDetailId,
	BudgetEmployeePayrollAllocationId,
	MinorGlAccountCategoryId,
	BudgetTaxTypeId,
	SalaryAmount,
	BonusAmount,
	ProfitShareAmount,
	BonusCapExcessAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	TaxDetail.ImportKey,
	TaxDetail.BudgetEmployeePayrollAllocationDetailId,
	TaxDetail.BudgetEmployeePayrollAllocationId,
	CASE WHEN (TaxDetail.BenefitOptionId IS NOT NULL) THEN @BenefitsMinorGlAccountCategoryId ELSE TaxType.MinorGlAccountCategoryId END AS MinorGlAccountCategoryId,
	TaxDetail.BudgetTaxTypeId,
	TaxDetail.SalaryAmount,
	TaxDetail.BonusAmount,
	TaxDetail.ProfitShareAmount,
	TaxDetail.BonusCapExcessAmount,
	TaxDetail.InsertedDate,
	TaxDetail.UpdatedDate,
	TaxDetail.UpdatedByStaffId
FROM

	-- Joining on allocation to limit amount of data
	#BudgetEmployeePayrollAllocation Allocation
	
	INNER JOIN #BudgetEmployeePayrollAllocationDetail TaxDetail ON
		Allocation.BudgetEmployeePayrollAllocationId = TaxDetail.BudgetEmployeePayrollAllocationId 
			
	LEFT OUTER JOIN #BudgetTaxType BudgetTaxType ON
		TaxDetail.BudgetTaxTypeId = BudgetTaxType.BudgetTaxTypeId
				
	LEFT OUTER JOIN #TaxType TaxType ON
		BudgetTaxType.TaxTypeId = TaxType.TaxTypeId	
			
PRINT ''Completed inserting records into #EmployeePayrollAllocationDetail:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #EmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationDetailId,BudgetEmployeePayrollAllocationId)
PRINT ''Completed creating indexes on #EmployeePayrollAllocationDetail''
PRINT CONVERT(Varchar(27), getdate(), 121)

--*/
-- Source payroll overhead allocation

CREATE TABLE #BudgetOverheadAllocation(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetOverheadAllocationId INT NOT NULL,
	BudgetId INT NOT NULL,
	OverheadRegionId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	BudgetPeriod INT NOT NULL,
	AllocationAmount DECIMAL(18, 2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetOverheadAllocationId INT NULL
)

INSERT INTO #BudgetOverheadAllocation(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetOverheadAllocationId,
	BudgetId,
	OverheadRegionId,
	BudgetEmployeeId,
	BudgetPeriod,
	AllocationAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetOverheadAllocationId
)
SELECT
	OverheadAllocation.*
FROM
	TapasGlobalBudgeting.BudgetOverheadAllocation OverheadAllocation
	
	INNER JOIN TapasGlobalBudgeting.BudgetOverheadAllocationActive(@DataPriorToDate) OverheadAllocationA ON
		OverheadAllocation.ImportKey = OverheadAllocationA.ImportKey

	-- data limiting join
	INNER JOIN #Budget b ON
		OverheadAllocation.BudgetId = b.BudgetId

PRINT ''Completed inserting records into #BudgetOverheadAllocation:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocation (BudgetOverheadAllocationId,BudgetId,OverheadRegionId,BudgetEmployeeId)
PRINT ''Completed creating indexes on #BudgetOverheadAllocation''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source overhead allocation detail

CREATE TABLE #BudgetOverheadAllocationDetail(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetOverheadAllocationDetailId INT NOT NULL,
	BudgetOverheadAllocationId INT NOT NULL,
	BudgetProjectId INT NOT NULL,
	AllocationValue DECIMAL(18, 9) NOT NULL,
	AllocationAmount DECIMAL(18, 2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetOverheadAllocationDetail(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetOverheadAllocationDetailId,
	BudgetOverheadAllocationId,
	BudgetProjectId,
	AllocationValue,
	AllocationAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT 
	OverheadDetail.*
FROM			
	TapasGlobalBudgeting.BudgetOverheadAllocationDetail OverheadDetail
	
	INNER JOIN TapasGlobalBudgeting.BudgetOverheadAllocationDetailActive(@DataPriorToDate) OverheadDetailA ON
		OverheadDetail.ImportKey = OverheadDetailA.ImportKey

	-- data limiting join
	INNER JOIN #BudgetProject b ON
		OverheadDetail.BudgetProjectId = b.BudgetProjectId

PRINT ''Completed inserting records into #BudgetOverheadAllocationDetail:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
PRINT ''Completed creating indexes on #BudgetOverheadAllocationDetail''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source payroll overhead allocation detail

CREATE TABLE #OverheadAllocationDetail
(
	ImportKey INT NOT NULL,
	BudgetOverheadAllocationDetailId INT NOT NULL,
	BudgetOverheadAllocationId INT NOT NULL,
	BudgetProjectId INT NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL,
	AllocationValue DECIMAL(18, 9) NOT NULL,
	AllocationAmount DECIMAL(18, 2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #OverheadAllocationDetail
(
	ImportKey,
	BudgetOverheadAllocationDetailId,
	BudgetOverheadAllocationId,
	BudgetProjectId,
	MinorGlAccountCategoryId,
	AllocationValue,
	AllocationAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	OverheadDetail.ImportKey,
	OverheadDetail.BudgetOverheadAllocationDetailId,
	OverheadDetail.BudgetOverheadAllocationId,
	OverheadDetail.BudgetProjectId,
	@OverheadMinorGlAccountCategoryId AS MinorGlAccountCategoryId,
	OverheadDetail.AllocationValue,
	OverheadDetail.AllocationAmount,
	OverheadDetail.InsertedDate,
	OverheadDetail.UpdatedDate,
	OverheadDetail.UpdatedByStaffId
FROM

	-- Joining on allocation to limit amount of data
	#BudgetOverheadAllocation OverheadAllocation
	
	INNER JOIN #BudgetOverheadAllocationDetail OverheadDetail ON
		OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId 

PRINT ''Completed inserting records into #OverheadAllocationDetail:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #OverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
PRINT ''Completed creating indexes on #OverheadAllocationDetail''
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Map Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

--Calculate effective functional department

CREATE TABLE #EffectiveFunctionalDepartment(
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL
)

INSERT INTO #EffectiveFunctionalDepartment(
	BudgetEmployeePayrollAllocationId,
	BudgetEmployeeId,
	FunctionalDepartmentId
)
SELECT 
	Allocation.BudgetEmployeePayrollAllocationId,
	Allocation.BudgetEmployeeId,
	(
		SELECT 
			EFD.FunctionalDepartmentId
		FROM 
			(
				SELECT 
					Allocation2.BudgetEmployeeId,
					MAX(EFD.EffectivePeriod) AS EffectivePeriod
				FROM
					#BudgetEmployeePayrollAllocation Allocation2

					INNER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
						Allocation2.BudgetEmployeeId = EFD.BudgetEmployeeId
				
				WHERE
					Allocation.BudgetEmployeePayrollAllocationId = Allocation2.BudgetEmployeePayrollAllocationId AND
					EFD.EffectivePeriod <= Allocation.Period
					  
				GROUP BY
					Allocation2.BudgetEmployeeId
			) EFDo
		
			LEFT OUTER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
				EFD.BudgetEmployeeId = EFDo.BudgetEmployeeId AND
				EFD.EffectivePeriod = EFDo.EffectivePeriod
				
	 ) AS FunctionalDepartmentId
FROM
	#BudgetEmployeePayrollAllocation Allocation

	INNER JOIN #BudgetProject BudgetProject ON 
		Allocation.BudgetProjectId = BudgetProject.BudgetProjectId

PRINT ''Completed inserting records into #EffectiveFunctionalDepartment:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Pre Tax Amounts
CREATE TABLE #ProfitabilityPreTaxSource
(
	BudgetId INT NOT NULL,
	BudgetRegionId INT NOT NULL,
	FirstProjectedPeriod char(6) NOT NULL,
	ProjectId INT NOT NULL,
	HrEmployeeId INT NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	ExpensePeriod CHAR(6) NOT NULL,	
	SourceCode VARCHAR(2) NULL,
	SalaryPreTaxAmount MONEY NOT NULL,
	ProfitSharePreTaxAmount MONEY NOT NULL,
	BonusPreTaxAmount MONEY NOT NULL,
	BonusCapExcessPreTaxAmount MONEY NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	FunctionalDepartmentCode VARCHAR(31) NULL,
	Reimbursable BIT NULL,
	ActivityTypeId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	OriginatingRegionCode CHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	AllocationUpdatedDate DATETIME NOT NULL,
	BudgetReportGroupPeriod INT NOT NULL
)
-- Insert original budget amounts
INSERT INTO #ProfitabilityPreTaxSource
(
	BudgetId,
	BudgetRegionId,
	FirstProjectedPeriod,
	ProjectId,
	HrEmployeeId,
	BudgetEmployeePayrollAllocationId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	SalaryPreTaxAmount,
	ProfitSharePreTaxAmount,
	BonusPreTaxAmount,
	BonusCapExcessPreTaxAmount,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate,
	BudgetReportGroupPeriod
)
SELECT 
	Budget.BudgetId AS BudgetId,
	Budget.RegionId AS BudgetRegionId,
	Budget.FirstProjectedPeriod,
	ISNULL(BudgetProject.ProjectId,0) AS ProjectId,
	ISNULL(BudgetEmployee.HrEmployeeId,0) AS HrEmployeeId,
	Allocation.BudgetEmployeePayrollAllocationId,
	''TGB:BudgetId='' + CONVERT(varchar,Budget.BudgetId) + ''&ProjectId='' + CONVERT(varchar,ISNULL(BudgetProject.ProjectId,0)) + ''&HrEmployeeId='' + CONVERT(varchar,ISNULL(BudgetEmployee.HrEmployeeId,0)) + ''&BudgetEmployeePayrollAllocationId='' + CONVERT(varchar,Allocation.BudgetEmployeePayrollAllocationId) + ''&BudgetEmployeePayrollAllocationDetailId=0&BudgetOverheadAllocationDetailId=0'' + ''&ImportKey='' + CONVERT(varchar, Allocation.ImportKey) AS ReferenceCode,
	Allocation.Period AS ExpensePeriod,
	SourceRegion.SourceCode,
	ISNULL(Allocation.PreTaxSalaryAmount,0) AS SalaryPreTaxAmount,
	ISNULL(Allocation.PreTaxProfitShareAmount, 0) AS ProfitSharePreTaxAmount,
	ISNULL(Allocation.PreTaxBonusAmount,0) AS BonusPreTaxAmount, 
	ISNULL(Allocation.PreTaxBonusCapExcessAmount,0) AS BonusCapExcessPreTaxAmount,
	ISNULL(EFD.FunctionalDepartmentId, -1),
	fd.GlobalCode AS FunctionalDepartmentCode, 
	CASE WHEN BudgetProject.IsTsCost = 0 THEN 1 ELSE 0 END AS Reimbursable,
	BudgetProject.ActivityTypeId,
	
	ISNULL(CASE
				WHEN (BudgetProject.CorporateDepartmentCode = ''@'' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.PropertyFundId
				ELSE
					DepartmentPropertyFund.PropertyFundId 
			END, -1) AS PropertyFundId,
	-- Same case logic AS above
	
	ISNULL(CASE -- Same case logic as above
				WHEN (BudgetProject.CorporateDepartmentCode = ''@'' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,
			
	OriginatingRegion.CorporateEntityRef,
	OriginatingRegion.CorporateSourceCode,
	Budget.CurrencyCode AS LocalCurrencyCode,
	Allocation.UpdatedDate,
	fmrb.BudgetReportGroupPeriod
FROM
	#BudgetEmployeePayrollAllocation Allocation

	INNER JOIN #BudgetProject BudgetProject ON 
		Allocation.BudgetProjectId = BudgetProject.BudgetProjectId
			
	INNER JOIN  #FilteredModifiedReportBudget fmrb ON
		BudgetProject.BudgetId = fmrb.BudgetId
			
	INNER JOIN #Budget Budget ON 
		fmrb.BudgetId = Budget.BudgetId 
		
	LEFT OUTER JOIN #Region SourceRegion ON 
		Budget.RegionId = SourceRegion.RegionId

	LEFT OUTER JOIN #EffectiveFunctionalDepartment efd ON
		Allocation.BudgetEmployeePayrollAllocationId = efd.BudgetEmployeePayrollAllocationId

	LEFT OUTER JOIN #FunctionalDepartment fd ON 
		efd.FunctionalDepartmentId = fd.FunctionalDepartmentId

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON GrSc.SourceCode = BudgetProject.CorporateSourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		BudgetProject.CorporateSourceCode = pfm.SourceCode AND
		pfm.IsDeleted = 0 AND 
		(
			(GrSc.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId = BudgetProject.ActivityTypeId)
				OR
				(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
			)
		) AND
		fmrb.BudgetReportGroupPeriod < 201007
	
	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		RECD.SourceCode = BudgetProject.CorporateSourceCode AND
		fmrb.BudgetReportGroupPeriod >= 201007 AND			   
		RECD.IsDeleted = 0
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = ''YES'' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		REPE.SourceCode = BudgetProject.CorporateSourceCode AND
		fmrb.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0	
	
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN fmrb.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = ''YES'' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END

	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId

	LEFT OUTER JOIN #BudgetEmployee BudgetEmployee ON
		Allocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId
		
	LEFT OUTER JOIN #Location Location ON 
		Location.LocationId = BudgetEmployee.LocationId
		
	LEFT OUTER JOIN #PayrollRegion OriginatingRegion ON 
		Location.ExternalSubRegionId = OriginatingRegion.ExternalSubRegionId AND
		Budget.RegionId = OriginatingRegion.RegionId

WHERE
	Allocation.Period BETWEEN fmrb.BudgetFirstProjectedPeriod AND fmrb.GroupEndPeriod AND
	BudgetProject.ActivityTypeId <> 99 -- exclude Corporate Overhead

PRINT ''Completed inserting records into #ProfitabilityPreTaxSource:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE INDEX IX_SalaryPreTaxAmount ON #ProfitabilityPreTaxSource (SalaryPreTaxAmount)
CREATE INDEX IX_ProfitSharePreTaxAmount ON #ProfitabilityPreTaxSource (ProfitSharePreTaxAmount)
CREATE INDEX IX_BonusPreTaxAmount ON #ProfitabilityPreTaxSource (BonusPreTaxAmount)
CREATE INDEX IX_BonusCapExcessPreTaxAmount ON #ProfitabilityPreTaxSource (BonusCapExcessPreTaxAmount)

PRINT ''Completed creating indexes on #ProfitabilityPreTaxSource''
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Tax Amounts

CREATE TABLE #ProfitabilityTaxSource
(
	BudgetId INT NOT NULL,
	BudgetRegionId INT NOT NULL,
	FirstProjectedPeriod CHAR(6) NOT NULL,
	ProjectId INT NOT NULL,
	HrEmployeeId INT NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	ExpensePeriod CHAR(6) NOT NULL,	
	SourceCode VARCHAR(2) NULL,
	SalaryTaxAmount MONEY NOT NULL,
	ProfitShareTaxAmount MONEY NOT NULL,
	BonusTaxAmount MONEY NOT NULL,
	BonusCapExcessTaxAmount MONEY NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	FunctionalDepartmentCode VARCHAR(31) NULL,
	Reimbursable BIT NULL,
	ActivityTypeId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	OriginatingRegionCode CHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	AllocationUpdatedDate DATETIME NOT NULL,
	BudgetReportGroupPeriod INT NOT NULL,
)
--/*
-- Insert original budget amounts
INSERT INTO #ProfitabilityTaxSource
(
	BudgetId,
	BudgetRegionId,
	FirstProjectedPeriod,
	ProjectId,
	HrEmployeeId,
	BudgetEmployeePayrollAllocationId,
	BudgetEmployeePayrollAllocationDetailId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	SalaryTaxAmount,
	ProfitShareTaxAmount,
	BonusTaxAmount,
	BonusCapExcessTaxAmount,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate,
	BudgetReportGroupPeriod
)
SELECT 
	pts.BudgetId,
	pts.BudgetRegionId,
	pts.FirstProjectedPeriod,
	ISNULL(pts.ProjectId,0) AS ProjectId,
	ISNULL(pts.HrEmployeeId,0) AS HrEmployeeId,
	pts.BudgetEmployeePayrollAllocationId,
	TaxDetail.BudgetEmployeePayrollAllocationDetailId,
	''TGB:BudgetId='' + CONVERT(varchar,pts.BudgetId) + ''&ProjectId='' + CONVERT(varchar,ISNULL(pts.ProjectId,0)) + ''&HrEmployeeId='' + CONVERT(varchar,ISNULL(pts.HrEmployeeId,0)) + ''&BudgetEmployeePayrollAllocationId='' + CONVERT(varchar,pts.BudgetEmployeePayrollAllocationId) + ''&BudgetEmployeePayrollAllocationDetailId='' + CONVERT(varchar,TaxDetail.BudgetEmployeePayrollAllocationDetailId) + ''&BudgetOverheadAllocationDetailId=0'' + ''&ImportKey='' + CONVERT(varchar, TaxDetail.ImportKey) AS ReferenceCode,
	pts.ExpensePeriod,
	pts.SourceCode,
	ISNULL(TaxDetail.SalaryAmount, 0) AS SalaryTaxAmount,
	ISNULL(TaxDetail.ProfitShareAmount, 0) AS ProfitShareTaxAmount,
	ISNULL(TaxDetail.BonusAmount, 0) AS BonusTaxAmount,
	ISNULL(TaxDetail.BonusCapExcessAmount, 0) AS BonusCapExcessTaxAmount,
	TaxDetail.MinorGlAccountCategoryId,
	ISNULL(pts.FunctionalDepartmentId, -1),
	pts.FunctionalDepartmentCode, 
	pts.Reimbursable,
	pts.ActivityTypeId,
	pts.PropertyFundId,
	ISNULL(PF.AllocationSubRegionGlobalRegionId, -1) AS AllocationSubRegionGlobalRegionId,
	pts.OriginatingRegionCode,
	pts.OriginatingRegionSourceCode,
	pts.LocalCurrencyCode,
	pts.AllocationUpdatedDate,
	pts.BudgetReportGroupPeriod
FROM
	#EmployeePayrollAllocationDetail TaxDetail

	INNER JOIN #ProfitabilityPreTaxSource pts ON
		TaxDetail.BudgetEmployeePayrollAllocationId = pts.BudgetEmployeePayrollAllocationId
		
	LEFT OUTER JOIN #PropertyFund PF ON
		pts.PropertyFundId = PF.PropertyFundId

PRINT ''Completed inserting records into #ProfitabilityTaxSource:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Overhead Amounts

CREATE TABLE #ProfitabilityOverheadSource
(
	BudgetId INT NOT NULL,
	FirstProjectedPeriod CHAR(6) NOT NULL,
	ProjectId INT NOT NULL,
	HrEmployeeId INT NOT NULL,
	BudgetOverheadAllocationDetailId INT NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	ExpensePeriod CHAR(6) NOT NULL,	
	SourceCode VARCHAR(2) NULL,
	OverheadAllocationAmount MONEY NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	FunctionalDepartmentCode VARCHAR(31) NULL,
	Reimbursable BIT NULL,
	ActivityTypeId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	OriginatingRegionCode CHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	OverheadUpdatedDate DATETIME NOT NULL
)
-- Insert original overhead amounts
INSERT INTO #ProfitabilityOverheadSource
(
	BudgetId,
	FirstProjectedPeriod,
	ProjectId,
	HrEmployeeId,
	BudgetOverheadAllocationDetailId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	OverheadAllocationAmount,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,	
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	OverheadUpdatedDate
)
SELECT
	Budget.BudgetId AS BudgetId,
	Budget.FirstProjectedPeriod,
	ISNULL(BudgetProject.ProjectId,0) AS ProjectId,
	ISNULL(BudgetEmployee.HrEmployeeId,0) AS HrEmployeeId,
	OverheadDetail.BudgetOverheadAllocationDetailId,
	''TGB:BudgetId='' + CONVERT(varchar,Budget.BudgetId) + ''&ProjectId='' + CONVERT(varchar,ISNULL(BudgetProject.ProjectId,0)) + ''&HrEmployeeId='' + CONVERT(varchar,ISNULL(BudgetEmployee.HrEmployeeId,0)) + ''&BudgetEmployeePayrollAllocationId=0&BudgetEmployeePayrollAllocationDetailId=0'' + ''&BudgetOverheadAllocationDetailId='' + CONVERT(varchar,OverheadDetail.BudgetOverheadAllocationDetailId) + ''&ImportKey='' + CONVERT(varchar, OverheadDetail.ImportKey) AS ReferenceCode,
	OverheadAllocation.BudgetPeriod AS ExpensePeriod,
	SourceRegion.SourceCode,
	ISNULL(OverheadDetail.AllocationAmount,0) AS OverheadAllocationAmount,
	OverheadDetail.MinorGlAccountCategoryId,
	ISNULL(RegionExtended.OverheadFunctionalDepartmentId, -1) AS FunctionalDepartmentId,
	fd.GlobalCode AS FunctionalDepartmentCode, 
	
	CASE
		WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
			CASE
				WHEN (BudgetProject.IsTsCost = 0) THEN -- Where ISTSCost is False the cost will be reimbursable
					1 
				ELSE
					0
			END
		ELSE
			0  --Where the BudgetProject.OverheadAllocationProjectID is populated: non-reimbursable
	END AS Reimbursable,
	
	BudgetProject.ActivityTypeId,
	
	CASE WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
		ISNULL(CASE WHEN (BudgetProject.CorporateDepartmentCode = ''@'' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.PropertyFundId
				ELSE 
					DepartmentPropertyFund.PropertyFundId 
				END, -1) 
	ELSE 
		ISNULL(OverheadPropertyFund.PropertyFundId, -1) 
	END AS PropertyFundId,
	
	ISNULL(CASE -- Same case logic as above
				WHEN (BudgetProject.CorporateDepartmentCode = ''@'' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,		
	
	OriginatingRegion.CorporateEntityRef,
	OriginatingRegion.CorporateSourceCode,
	Budget.CurrencyCode AS LocalCurrencyCode,
	OverheadDetail.UpdatedDate

FROM
	#BudgetOverheadAllocation OverheadAllocation 

	INNER JOIN #BudgetEmployee BudgetEmployee ON
		OverheadAllocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId

	INNER JOIN #OverheadAllocationDetail OverheadDetail ON
		OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId
			
	INNER JOIN #BudgetProject BudgetProject ON 
		OverheadDetail.BudgetProjectId = BudgetProject.BudgetProjectId
		
	INNER JOIN #FilteredModifiedReportBudget fmrb ON
		BudgetProject.BudgetId = fmrb.BudgetId
		
	INNER JOIN #Budget Budget ON 
		fmrb.BudgetId = Budget.BudgetId
		
	LEFT OUTER JOIN #Region SourceRegion ON 
		Budget.RegionId = SourceRegion.RegionId
		
	LEFT OUTER JOIN #RegionExtended RegionExtended ON 
		SourceRegion.RegionId = RegionExtended.RegionId

	LEFT OUTER JOIN #FunctionalDepartment fd ON 
		RegionExtended.OverheadFunctionalDepartmentId = fd.FunctionalDepartmentId

	LEFT OUTER JOIN	#Project OverheadProject ON
		BudgetProject.AllocateOverheadsProjectId = OverheadProject.ProjectId

	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId
	
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON GrSc.SourceCode = BudgetProject.CorporateSourceCode
	
	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		BudgetProject.CorporateSourceCode = pfm.SourceCode AND
		--ISNULL(BudgetProject.ActivityTypeId, -1) = ISNULL(pfm.ActivityTypeId, -1) AND 
		pfm.IsDeleted = 0 AND 
		(
			(GrSc.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId = BudgetProject.ActivityTypeId)
				OR
				(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
			)
		) AND
		fmrb.BudgetReportGroupPeriod < 201007
	
	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		RECD.SourceCode = BudgetProject.CorporateSourceCode AND
		fmrb.BudgetReportGroupPeriod >= 201007 AND
		RECD.IsDeleted = 0
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = ''YES'' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		REPE.SourceCode = BudgetProject.CorporateSourceCode AND
		fmrb.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0	
	
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN fmrb.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = ''YES'' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrScO ON GrScO.SourceCode = OverheadProject.CorporateSourceCode

	LEFT OUTER JOIN #PropertyFundMapping opfm ON
		OverheadProject.CorporateDepartmentCode = opfm.PropertyFundCode AND -- Combination of entity and corporate department
		OverheadProject.CorporateSourceCode = opfm.SourceCode AND
		--ISNULL(BudgetProject.ActivityTypeId, -1) = ISNULL(opfm.ActivityTypeId, -1) AND 
		opfm.IsDeleted = 0 AND 
		(
			(GrScO.IsProperty = ''YES'' AND opfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrScO.IsCorporate = ''YES'' AND opfm.ActivityTypeId = BudgetProject.ActivityTypeId)
				OR
				(GrScO.IsCorporate = ''YES'' AND opfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
			)
		) AND
		fmrb.BudgetReportGroupPeriod < 201007
	
	LEFT OUTER JOIN #PropertyFund OverheadPropertyFund ON
		OverheadPropertyFund.PropertyFundId =	
			CASE
				WHEN fmrb.BudgetReportGroupPeriod < 201007 THEN opfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = ''YES'' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END
	
	LEFT OUTER JOIN #OverheadRegion OriginatingRegion ON 
		OverheadAllocation.OverheadRegionId = OriginatingRegion.OverheadRegionId
		
WHERE
	OverheadAllocation.BudgetPeriod BETWEEN fmrb.BudgetFirstProjectedPeriod AND fmrb.GroupEndPeriod
		
PRINT ''Completed inserting records into #ProfitabilityOverheadSource:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Generate mapping records
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


CREATE TABLE #ProfitabilityPayrollMapping
(
	BudgetId INT NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	FirstProjectedPeriod CHAR(6) NOT NULL,
	ExpensePeriod CHAR(6) NOT NULL,	
	SourceCode VARCHAR(2) NULL,
	BudgetAmount MONEY NOT NULL,
	MajorGlAccountCategoryId INT NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	FunctionalDepartmentCode VARCHAR(31) NULL,
	Reimbursable BIT NOT NULL,
	ActivityTypeId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	OriginatingRegionCode CHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	AllocationUpdatedDate DATETIME NOT NULL
)

INSERT INTO #ProfitabilityPayrollMapping
(
	BudgetId,
	ReferenceCode,
	FirstProjectedPeriod,
	ExpensePeriod,
	SourceCode,
	BudgetAmount,
	MajorGlAccountCategoryId,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate
)
-- Get Base Salary Payroll pre tax mappings and budget
SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=SalaryPreTax'' AS ReferenceCode,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.SalaryPreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MinorGlAccountCategoryId,
	@BaseSalaryMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityPreTaxSource pps
WHERE
	pps.SalaryPreTaxAmount <> 0

-- Get Profit Share Benefit pre tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=ProfitSharePreTax'' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.ProfitSharePreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MinorGlAccountCategoryId,
	@ProfitShareMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityPreTaxSource pps
WHERE
	pps.ProfitSharePreTaxAmount <> 0

-- Get Bonus pre tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=BonusPreTax'' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusPreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MinorGlAccountCategoryId,
	@BonusMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityPreTaxSource pps
WHERE
	pps.BonusPreTaxAmount <> 0

--Get bonus cap pre tax mappings
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=BonusCapExcessPreTax'' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusCapExcessPreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MinorGlAccountCategoryId,
	@BonusMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	0 AS Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
	ISNULL(p.ActivityTypeId, -1) AS ActivityTypeId,

	ISNULL(CASE
				WHEN (p.CorporateDepartmentCode = ''@'' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.PropertyFundId
				ELSE
					DepartmentPropertyFund.PropertyFundId 
			END, -1) AS PropertyFundId,
	-- Same case logic AS above

	ISNULL(CASE -- Same case logic as above
				WHEN (p.CorporateDepartmentCode = ''@'' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,

	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityPreTaxSource pps
	
	LEFT OUTER JOIN #SystemSettingRegion ssr ON
		pps.SourceCode = ssr.SourceCode AND
		pps.BudgetRegionId = ssr.RegionId AND
		ssr.SystemSettingName = ''BonusCapExcess''
		
	LEFT OUTER JOIN #Project p ON
		ssr.BonusCapExcessProjectId = p.ProjectId
			
	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		p.PropertyFundId = ProjectPropertyFund.PropertyFundId
		
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		GrSc.SourceCode = p.CorporateSourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		p.CorporateSourceCode = pfm.SourceCode AND
		pfm.IsDeleted = 0 AND 
		(
			(GrSc.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId = p.ActivityTypeId)
				OR
				(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
			)
		) AND
		pps.BudgetReportGroupPeriod < 201007

	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		RECD.SourceCode = p.CorporateSourceCode AND
		pps.BudgetReportGroupPeriod >= 201007 AND			   
		RECD.IsDeleted = 0

	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = ''YES'' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		REPE.SourceCode = p.CorporateSourceCode AND
		pps.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0	

	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN pps.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = ''YES'' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END
		
WHERE
	pps.BonusCapExcessPreTaxAmount <> 0

UNION ALL

-- Get Base Salary Payroll Tax mappings and budget
SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=SalaryTax'' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.SalaryTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.SalaryTaxAmount <> 0

-- Get Profit Share Benefit Tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=ProfitShareTax'' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.ProfitShareTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.ProfitShareTaxAmount <> 0

-- Get Bonus Tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=BonusTax'' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.BonusTaxAmount <> 0

-- Get Bonus cap Tax mappings 
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=BonusCapExcessTax'' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusCapExcessTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	0 AS Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
	ISNULL(p.ActivityTypeId, -1) AS ActivityTypeId,
	
	ISNULL(CASE
				WHEN (p.CorporateDepartmentCode = ''@'' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.PropertyFundId
				ELSE
					DepartmentPropertyFund.PropertyFundId 
			END, -1) AS PropertyFundId,
	-- Same case logic AS above

	ISNULL(CASE -- Same case logic as above
				WHEN (p.CorporateDepartmentCode = ''@'' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,

	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityTaxSource pps

	LEFT OUTER JOIN #SystemSettingRegion ssr ON
		pps.SourceCode = ssr.SourceCode AND
		pps.BudgetRegionId = ssr.RegionId AND
		ssr.SystemSettingName = ''BonusCapExcess''

	LEFT OUTER JOIN #Project p ON
		ssr.BonusCapExcessProjectId = p.ProjectId

	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		p.PropertyFundId = ProjectPropertyFund.PropertyFundId

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		GrSc.SourceCode = p.CorporateSourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		p.CorporateSourceCode = pfm.SourceCode AND
		pfm.IsDeleted = 0 AND 
		(
			(GrSc.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId = p.ActivityTypeId)
				OR
				(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
			)
		) AND
		pps.BudgetReportGroupPeriod < 201007

	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		RECD.SourceCode = p.CorporateSourceCode AND
		pps.BudgetReportGroupPeriod >= 201007 AND			   
		RECD.IsDeleted = 0
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = ''YES'' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		REPE.SourceCode = p.CorporateSourceCode AND
		pps.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0

	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN pps.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = ''YES'' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END

WHERE
	pps.BonusCapExcessTaxAmount <> 0
	
-- Get Overhead mappings	
UNION ALL

SELECT
	pos.BudgetId,
	pos.ReferenceCode + ''&Type=OverheadAllocation'' AS ReferenceCod,
	pos.FirstProjectedPeriod,
	pos.ExpensePeriod,
	pos.SourceCode,
	pos.OverheadAllocationAmount AS BudgetAmount,
	@OccupancyCostsMajorGlAccountCategoryId AS MinorGlAccountCategoryId,
	pos.MinorGlAccountCategoryId, 
	pos.FunctionalDepartmentId,
	pos.FunctionalDepartmentCode,
	pos.Reimbursable,  
	pos.ActivityTypeId,
	pos.PropertyFundId,
	pos.AllocationSubRegionGlobalRegionId,
	pos.OriginatingRegionCode,
	pos.OriginatingRegionSourceCode,
	pos.LocalCurrencyCode,
	pos.OverheadUpdatedDate
FROM
	#ProfitabilityOverheadSource pos
WHERE
	pos.OverheadAllocationAmount <> 0

PRINT ''Completed inserting records into #ProfitabilityPayrollMapping:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_AllocationUpdatedDate ON #ProfitabilityPayrollMapping(ReferenceCode,AllocationUpdatedDate)
PRINT ''Completed creating indexes on #ProfitabilityPayrollMapping''
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Map mapped source data into the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

------------------------------------------------------------------------------------------------------
-- Additional required mappings
------------------------------------------------------------------------------------------------------

-- #OriginatingRegionCorporateEntity

CREATE TABLE #OriginatingRegionCorporateEntity( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	OriginatingRegionCorporateEntityId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	CorporateEntityCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL	
)

INSERT INTO #OriginatingRegionCorporateEntity(
	ImportKey,
	OriginatingRegionCorporateEntityId,
	GlobalRegionId,
	CorporateEntityCode,
	SourceCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted
)
SELECT
	ORCE.ImportKey,
	ORCE.OriginatingRegionCorporateEntityId,
	ORCE.GlobalRegionId,
	ORCE.CorporateEntityCode,
	ORCE.SourceCode,
	ORCE.InsertedDate,
	ORCE.UpdatedDate,
	ORCE.IsDeleted	
FROM
	Gdm.OriginatingRegionCorporateEntity ORCE
	INNER JOIN Gdm.OriginatingRegionCorporateEntityActive (@DataPriorToDate) ORCEA ON
		ORCEA.ImportKey = ORCE.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #OriginatingRegionCorporateEntity (CorporateEntityCode, SourceCode, IsDeleted, GlobalRegionId)

PRINT ''Completed creating indexes on #OriginatingRegionCorporateEntity''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- #OriginatingRegionPropertyDepartment

CREATE TABLE #OriginatingRegionPropertyDepartment( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	OriginatingRegionPropertyDepartmentId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	PropertyDepartmentCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL	
)

INSERT INTO #OriginatingRegionPropertyDepartment(
	ImportKey,
	OriginatingRegionPropertyDepartmentId,
	GlobalRegionId,
	PropertyDepartmentCode,
	SourceCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted
)
SELECT
	ORPD.ImportKey,
	ORPD.OriginatingRegionPropertyDepartmentId,
	ORPD.GlobalRegionId,
	ORPD.PropertyDepartmentCode,
	ORPD.SourceCode,
	ORPD.InsertedDate,
	ORPD.UpdatedDate,
	ORPD.IsDeleted
FROM
	Gdm.OriginatingRegionPropertyDepartment ORPD
	INNER JOIN Gdm.OriginatingRegionPropertyDepartmentActive(@DataPriorToDate) ORPDA ON
		ORPDA.ImportKey = ORPD.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #OriginatingRegionPropertyDepartment (PropertyDepartmentCode, SourceCode, IsDeleted, GlobalRegionId)

PRINT ''Completed inserting records into #OriginatingRegionMapping:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Allocation Region Mappings

CREATE TABLE #AllocationSubRegion(
	ImportKey INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	ProjectCodePortion VARCHAR(2) NOT NULL,
	AllocationRegionGlobalRegionId INT NULL,
	DefaultCurrencyCode CHAR(3) NOT NULL,
	CountryId INT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

-- #AllocationSubRegion

INSERT INTO #AllocationSubRegion(
	ImportKey,
	AllocationSubRegionGlobalRegionId,
	Code,
	[Name],
	ProjectCodePortion,
	AllocationRegionGlobalRegionId,
	DefaultCurrencyCode,
	CountryId,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	ASR.ImportKey,
	ASR.AllocationSubRegionGlobalRegionId,
	ASR.Code,
	ASR.[Name],
	ASR.ProjectCodePortion,
	ASR.AllocationRegionGlobalRegionId,
	ASR.DefaultCurrencyCode,
	ASR.CountryId,
	ASR.IsActive,
	ASR.InsertedDate,
	ASR.UpdatedDate,
	ASR.UpdatedByStaffId
FROM
	Gdm.AllocationSubRegion ASR
	INNER JOIN	Gdm.AllocationSubRegionActive(@DataPriorToDate) ASRA ON
		ASRA.ImportKey = ASR.ImportKey

PRINT ''Completed inserting records into #AllocationRegionMapping:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

------------------------------------------------------------------------------------------------------
-- Map to the fact
------------------------------------------------------------------------------------------------------
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--If the join is not possible, default the link to the ''UNKNOWN'' link
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityReforecast(
	CalendarKey INT NOT NULL,
	ReforecastKey INT NOT NULL,
	GlAccountKey INT NOT NULL,
	SourceKey INT NOT NULL,
	FunctionalDepartmentKey INT NOT NULL,
	ReimbursableKey INT NOT NULL,
	ActivityTypeKey INT NOT NULL,
	PropertyFundKey INT NOT NULL,	
	AllocationRegionKey INT NOT NULL,
	OriginatingRegionKey INT NOT NULL,
	LocalCurrencyKey INT NOT NULL,
	LocalReforecast MONEY NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	BudgetId INT NOT NULL,
	SourceSystemId INT NOT NULL,
	
	EUCorporateGlAccountCategoryKey INT NULL,
	EUPropertyGlAccountCategoryKey INT NULL,
	EUFundGlAccountCategoryKey INT NULL,

	USPropertyGlAccountCategoryKey INT NULL,
	USCorporateGlAccountCategoryKey INT NULL,
	USFundGlAccountCategoryKey INT NULL,

	GlobalGlAccountCategoryKey INT NULL,
	DevelopmentGlAccountCategoryKey INT NULL
) 

INSERT INTO #ProfitabilityReforecast 
(
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	SourceSystemId
)
SELECT
	DATEDIFF(dd, ''1900-01-01'', LEFT(pbm.ExpensePeriod,4)+''-''+RIGHT(pbm.ExpensePeriod,2)+''-01'') AS CalendarKey,
	DATEDIFF(dd, ''1900-01-01'', LEFT(pbm.FirstProjectedPeriod,4)+''-''+RIGHT(pbm.FirstProjectedPeriod,2)+''-01'') AS ReforecastKey,
	@GlAccountKeyUnknown GlAccountKey,
	CASE WHEN GrSc.[SourceKey] IS NULL THEN @SourceKeyUnknown ELSE GrSc.[SourceKey] END SourceKey,
	CASE WHEN GrFdm.[FunctionalDepartmentKey] IS NULL THEN @FunctionalDepartmentKeyUnknown ELSE GrFdm.[FunctionalDepartmentKey] END FunctionalDepartmentKey,
	CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKeyUnknown ELSE GrRi.ReimbursableKey END ReimbursableKey,
	CASE WHEN GrAt.[ActivityTypeKey] IS NULL THEN @ActivityTypeKeyUnknown ELSE GrAt.[ActivityTypeKey] END ActivityTypeKey,
	CASE WHEN GrPf.[PropertyFundKey] IS NULL THEN @PropertyFundKeyUnknown ELSE GrPf.[PropertyFundKey] END PropertyFundKey,
	CASE WHEN GrAr.[AllocationRegionKey] IS NULL THEN @AllocationRegionKeyUnknown ELSE GrAr.[AllocationRegionKey] END AllocationRegionKey,
	CASE WHEN GrOr.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKeyUnknown ELSE GrOr.[OriginatingRegionKey] END OriginatingRegionKey,
	CASE WHEN GrCu.[CurrencyKey] IS NULL THEN @LocalCurrencyKeyUnknown ELSE GrCu.[CurrencyKey] END LocalCurrencyKey,
	pbm.BudgetAmount,
	pbm.ReferenceCode,
	pbm.BudgetId,
	@SourceSystemId
FROM
	#ProfitabilityPayrollMapping pbm
	
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		pbm.SourceCode = GrSc.SourceCode

	--Parent Level (No job code for payroll)
	LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdm ON
		GrFdm.ReferenceCode LIKE pbm.FunctionalDepartmentCode +'':%'' AND
		pbm.AllocationUpdatedDate BETWEEN GrFdm.StartDate AND GrFdm.EndDate AND
		GrFdm.SubFunctionalDepartmentCode = GrFdm.FunctionalDepartmentCode

	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		CASE WHEN pbm.Reimbursable = 1 THEN ''YES'' ELSE ''NO'' END = GrRi.ReimbursableCode

	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		pbm.ActivityTypeId = GrAt.ActivityTypeId AND
		pbm.AllocationUpdatedDate BETWEEN GrAt.StartDate AND GrAt.EndDate

	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		pbm.PropertyFundId = GrPf.PropertyFundId AND
		pbm.AllocationUpdatedDate BETWEEN GrPf.StartDate AND GrPf.EndDate

	-- HACK: At some point tapas was supposed to pull project region out of GDM. 
	-- Now allocation regions are source based??? So I use the code because it is built up from the ProjectRegionId since there is only data for one source anyway.
	-- I don''t check source because actuals also don''t check source. 
	--LEFT OUTER JOIN #AllocationRegionMapping Arm ON
	--	Arm.RegionCode = pbm.ProjectRegionId AND -- TODO: Pull the RegionCode through from the top.
	--	Arm.IsDeleted = 0
	
	LEFT OUTER JOIN #AllocationSubRegion ASR ON
		pbm.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId		

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		ASR.AllocationSubRegionGlobalRegionId = GrAr.GlobalRegionId AND
		pbm.AllocationUpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate

/* -- At some point Allocation region in GDM was going to become the master list
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		pbm.ProjectRegionId = GrAr.GlobalRegionId AND
		pbm.AllocationUpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate
*/

	--LEFT OUTER JOIN #OriginatingRegionMapping Orm ON
	--	Orm.RegionCode = CASE WHEN RIGHT(pbm.OriginatingRegionSourceCode,1) = ''C'' THEN LTRIM(RTRIM(pbm.OriginatingRegionCode))
	--							ELSE LTRIM(RTRIM(pbm.OriginatingRegionCode)) + LTRIM(RTRIM(pbm.FunctionalDepartmentCode)) END AND
	--	Orm.SourceCode = pbm.OriginatingRegionSourceCode AND
	--	Orm.IsDeleted = 0
		
	LEFT OUTER JOIN #OriginatingRegionCorporateEntity ORCE ON
		ORCE.CorporateEntityCode = LTRIM(RTRIM(pbm.OriginatingRegionCode)) AND
		ORCE.SourceCode = pbm.OriginatingRegionSourceCode AND
		ORCE.IsDeleted = 0
		   
	LEFT OUTER JOIN #OriginatingRegionPropertyDepartment ORPD ON
		ORPD.PropertyDepartmentCode = LTRIM(RTRIM(pbm.OriginatingRegionCode)) AND
		ORPD.SourceCode = pbm.OriginatingRegionSourceCode AND
		ORPD.IsDeleted = 0			
		
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		GrOr.GlobalRegionId = ISNULL(ORCE.GlobalRegionId, ORPD.GlobalRegionId) AND
		pbm.AllocationUpdatedDate BETWEEN GrOr.StartDate AND GrOr.EndDate
	
	LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
		pbm.LocalCurrencyCode = GrCu.CurrencyCode 

PRINT ''Completed inserting records into #ProfitabilityReforecast:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProfitabilityReforecast (ReferenceCode)
CREATE INDEX IX_CalendarKey ON #ProfitabilityReforecast (CalendarKey)

PRINT ''Completed creating indexes on #OriginatingRegionMapping''
PRINT CONVERT(Varchar(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Remove existing data for modified budget projects
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #DeletingBudget
(
	BudgetId INT NOT NULL
)

INSERT INTO #DeletingBudget
(
	BudgetId
)
SELECT DISTINCT 
	BudgetId
FROM
	#Budget

DECLARE @BudgetId INT = -1
DECLARE @LoopCount INT = 0 -- Infinite loop safe guard

WHILE (EXISTS (SELECT TOP 1 BudgetId FROM #DeletingBudget) AND @LoopCount < 100000)
BEGIN
	
	SET @LoopCount = @LoopCount + 1
	SET @BudgetId = (SELECT TOP 1 BudgetId FROM #DeletingBudget)

	-- Remove old facts
	DELETE 
	FROM
		GrReporting.dbo.ProfitabilityReforecast 
	WHERE
		BudgetId = @BudgetId AND
		SourceSystemId = @SourceSystemId
	
	PRINT ''Completed deleting records from ProfitabilityReforecast:''+CONVERT(char(10),@@rowcount)
	PRINT CONVERT(Varchar(27), getdate(), 121)

	DELETE FROM #DeletingBudget WHERE BudgetId = @BudgetId
END

print ''Cleaned up rows in ProfitabilityReforecast''

------------------------------------------------------------------------------------------------------
-- Map account categories
------------------------------------------------------------------------------------------------------

--GlobalGlAccountCategoryKey

CREATE TABLE #GlobalCategoryLookup(
	GlAccountCategoryKey INT NULL,
	ReferenceCode VARCHAR(300) NOT NULL
)

INSERT INTO #GlobalCategoryLookup(
	GlAccountCategoryKey,
	ReferenceCode
)
SELECT 
	GlAcGlobal.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT 
			GlAcHg.GLTranslationTypeId,
			GlAcHg.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			GlAcHg.GLAccountTypeId,
			GlAcHg.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode
		 FROM	
			#ProfitabilityPayrollMapping Gl				
			CROSS JOIN (
							SELECT
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#GLAccountCategoryTranslations ACT
							WHERE
								ACT.GLTranslationSubTypeCode = ''GL''

						) GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcGlobal ON GlAcGlobal.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0)))

			AND Gl.AllocationUpdatedDate BETWEEN GlAcGlobal.StartDate AND GlAcGlobal.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #GlobalCategoryLookup (ReferenceCode)

UPDATE
	#ProfitabilityReforecast
SET
	GlobalGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END
FROM
	#GlobalCategoryLookup t1
WHERE
	t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode

PRINT ''Completed converting all GlobalGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


/*--EUCorporateGlAccountCategoryKey

CREATE TABLE #EUCorpCategoryLookup(
	GlAccountCategoryKey INT NULL,
	ReferenceCode varchar(300) NOT NULL
)

INSERT INTO #EUCorpCategoryLookup(
	GlAccountCategoryKey,
	ReferenceCode
)
SELECT 
	GlAcEUCorp.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT
			GlAcHg.GLTranslationTypeId,
			GlAcHg.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			GlAcHg.GLAccountTypeId,
			GlAcHg.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode
			
		FROM	
			#ProfitabilityPayrollMapping Gl
			CROSS JOIN (
							SELECT
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#GLAccountCategoryTranslations ACT
							WHERE
								ACT.GLTranslationSubTypeCode = ''EU CORP''

						) GlAcHg
	) Gl
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUCorp ON GlAcEUCorp.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0)))
								 
			AND Gl.AllocationUpdatedDate BETWEEN GlAcEUCorp.StartDate AND GlAcEUCorp.EndDate	
				
CREATE UNIQUE CLUSTERED INDEX IX ON #EUCorpCategoryLookup (ReferenceCode)

UPDATE
	#ProfitabilityReforecast
SET
	EUCorporateGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @EUCorporateGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END 
FROM
	#EUCorpCategoryLookup t1
WHERE
	t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode

PRINT ''Completed converting all EUCorporateGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--EUPropertyGlAccountCategoryKey

CREATE TABLE #EUPropCategoryLookup(
	GlAccountCategoryKey INT NULL,
	ReferenceCode varchar(300) NOT NULL
)

INSERT INTO #EUPropCategoryLookup(
	GlAccountCategoryKey,
	ReferenceCode
)
SELECT
	GlAcEUProp.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT 
			GlAcHg.GLTranslationTypeId,
			GlAcHg.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			GlAcHg.GLAccountTypeId,
			GlAcHg.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode
		 FROM	
			#ProfitabilityPayrollMapping Gl				
			CROSS JOIN (
							SELECT
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#GLAccountCategoryTranslations ACT
							WHERE
								ACT.GLTranslationSubTypeCode = ''EU PROP''

						) GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUProp ON GlAcEUProp.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0)))

			AND Gl.AllocationUpdatedDate BETWEEN GlAcEUProp.StartDate AND GlAcEUProp.EndDate
			
CREATE UNIQUE CLUSTERED INDEX IX ON #EUPropCategoryLookup (ReferenceCode)

UPDATE
	#ProfitabilityReforecast
SET
	EUPropertyGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @EUPropertyGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END
FROM
	#EUPropCategoryLookup t1
WHERE
	t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode


PRINT ''Completed converting all EUPropertyGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--EUFundGlAccountCategoryKey

CREATE TABLE #EUFundCategoryLookup(
	GlAccountCategoryKey INT NULL,
	ReferenceCode varchar(300) NOT NULL
)

INSERT INTO #EUFundCategoryLookup(
	GlAccountCategoryKey,
	ReferenceCode
)
SELECT 
	GlAcEUFund.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT 
			GlAcHg.GLTranslationTypeId,
			GlAcHg.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			GlAcHg.GLAccountTypeId,
			GlAcHg.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode
		 FROM	
			#ProfitabilityPayrollMapping Gl				
			CROSS JOIN (
							SELECT
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#GLAccountCategoryTranslations ACT
							WHERE
								ACT.GLTranslationSubTypeCode = ''EU FUND''

						) GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUFund ON GlAcEUFund.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0)))

			AND Gl.AllocationUpdatedDate BETWEEN GlAcEUFund.StartDate AND GlAcEUFund.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #EUFundCategoryLookup (ReferenceCode)

UPDATE
	#ProfitabilityReforecast
SET
	EUFundGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @EUFundGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END
FROM
	#EUFundCategoryLookup t1
WHERE
	t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode

PRINT ''Completed converting all EUFundGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--USPropertyGlAccountCategoryKey

CREATE TABLE #USPropCategoryLookup(
	GlAccountCategoryKey INT NULL,
	ReferenceCode VARCHAR(300) NOT NULL
)

INSERT INTO #USPropCategoryLookup(
	GlAccountCategoryKey,
	ReferenceCode
)
SELECT 
	GlAcUSProp.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT 
			GlAcHg.GLTranslationTypeId,
			GlAcHg.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			GlAcHg.GLAccountTypeId,
			GlAcHg.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode
		 FROM	
			#ProfitabilityPayrollMapping Gl				
			CROSS JOIN (
							SELECT
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#GLAccountCategoryTranslations ACT
							WHERE
								ACT.GLTranslationSubTypeCode = ''US PROP''

						) GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSProp ON GlAcUSProp.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0)))

			AND Gl.AllocationUpdatedDate BETWEEN GlAcUSProp.StartDate AND GlAcUSProp.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #USPropCategoryLookup (ReferenceCode)

UPDATE
	#ProfitabilityReforecast
SET
	USPropertyGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @USPropertyGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END
FROM
	#USPropCategoryLookup t1
WHERE
	t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode

PRINT ''Completed converting all USPropertyGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


--USCorporateGlAccountCategoryKey

CREATE TABLE #USCorpCategoryLookup(
	GlAccountCategoryKey INT NULL,
	ReferenceCode varchar(300) NOT NULL
)

INSERT INTO #USCorpCategoryLookup(
	GlAccountCategoryKey,
	ReferenceCode
)
SELECT 
	GlAcUSCorp.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT 
			GlAcHg.GLTranslationTypeId,
			GlAcHg.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			GlAcHg.GLAccountTypeId,
			GlAcHg.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode
		 FROM	
			#ProfitabilityPayrollMapping Gl				
			CROSS JOIN (
							SELECT
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#GLAccountCategoryTranslations ACT
							WHERE
								ACT.GLTranslationSubTypeCode = ''US CORP''

						) GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSCorp ON GlAcUSCorp.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0)))

			AND Gl.AllocationUpdatedDate BETWEEN GlAcUSCorp.StartDate AND GlAcUSCorp.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #USCorpCategoryLookup (ReferenceCode)

UPDATE
	#ProfitabilityReforecast
SET
	USCorporateGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @USCorporateGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END
FROM
	#USCorpCategoryLookup t1
WHERE
	t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode


PRINT ''Completed converting all USCorporateGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--USFundGlAccountCategoryKey

CREATE TABLE #USFundCategoryLookup(
	GlAccountCategoryKey INT NULL,
	ReferenceCode VARCHAR(300) NOT NULL
)

INSERT INTO #USFundCategoryLookup(
	GlAccountCategoryKey,
	ReferenceCode
)
SELECT 
	GlAcUSFund.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT 
			GlAcHg.GLTranslationTypeId,
			GlAcHg.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			GlAcHg.GLAccountTypeId,
			GlAcHg.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode
		 FROM	
			#ProfitabilityPayrollMapping Gl				
			CROSS JOIN (
							SELECT
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#GLAccountCategoryTranslations ACT
							WHERE
								ACT.GLTranslationSubTypeCode = ''US FUND''

						) GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSFund ON GlAcUSFund.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0)))

			AND Gl.AllocationUpdatedDate BETWEEN GlAcUSFund.StartDate AND GlAcUSFund.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #USFundCategoryLookup (ReferenceCode)

UPDATE
	#ProfitabilityReforecast
SET
	USFundGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @USFundGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END
FROM
	#USFundCategoryLookup t1
WHERE
	t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode

PRINT ''Completed converting all USFundGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
	

--DevelopmentGlAccountCategoryKey

CREATE TABLE #DevelCategoryLookup(
	GlAccountCategoryKey INT NULL,
	ReferenceCode varchar(300) NOT NULL
)

INSERT INTO #DevelCategoryLookup(
	GlAccountCategoryKey,
	ReferenceCode
)
SELECT 
	GlAcDevel.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT 
			GlAcHg.GLTranslationTypeId,
			GlAcHg.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			GlAcHg.GLAccountTypeId,
			GlAcHg.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode
		 FROM	
			#ProfitabilityPayrollMapping Gl				
			CROSS JOIN (
							SELECT
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#GLAccountCategoryTranslations ACT
							WHERE
								ACT.GLTranslationSubTypeCode = ''DEV''

						) GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcDevel ON GlAcDevel.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0)))

			AND Gl.AllocationUpdatedDate BETWEEN GlAcDevel.StartDate AND GlAcDevel.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #DevelCategoryLookup (ReferenceCode)

UPDATE
	#ProfitabilityReforecast
SET
	DevelopmentGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @DevelopmentGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END
FROM
	#DevelCategoryLookup t1
WHERE
	t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode

PRINT ''Completed converting all DevelopmentGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
*/

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Insert modified and new data 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

INSERT INTO GrReporting.dbo.ProfitabilityReforecast
(
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
)
SELECT
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	@EUCorporateGlAccountCategoryKeyUnknown, --EUCorporateGlAccountCategoryKey,
	@EUPropertyGlAccountCategoryKeyUnknown, --EUPropertyGlAccountCategoryKey,
	@EUFundGlAccountCategoryKeyUnknown, --EUFundGlAccountCategoryKey,

	@USPropertyGlAccountCategoryKeyUnknown, --USPropertyGlAccountCategoryKey,
	@USCorporateGlAccountCategoryKeyUnknown, ----USCorporateGlAccountCategoryKey,
	@USFundGlAccountCategoryKeyUnknown, --USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	@DevelopmentGlAccountCategoryKeyUnknown --DevelopmentGlAccountCategoryKey
FROM 
	#ProfitabilityReforecast

print ''Rows Inserted in ProfitabilityReforecast:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Clean up
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

DROP TABLE #SystemSettingRegion
DROP TABLE #GLTranslationType
DROP TABLE #GLTranslationSubType
DROP TABLE #GLMajorCategory
DROP TABLE #GLMinorCategory
DROP TABLE #GLAccountType
DROP TABLE #GLAccountSubType
DROP TABLE #GLAccountCategoryTranslations
DROP TABLE #BudgetReportGroupDetail
DROP TABLE #BudgetReportGroup
DROP TABLE #BudgetReportGroupPeriod
DROP TABLE #BudgetStatus
DROP TABLE #AllActiveBudget
DROP TABLE #AllModifiedReportBudget
DROP TABLE #LockedModifiedReportGroup
DROP TABLE #FilteredModifiedReportBudget
DROP TABLE #Budget
DROP TABLE #BudgetProject
DROP TABLE #Region
DROP TABLE #BudgetEmployee
DROP TABLE #BudgetEmployeeFunctionalDepartment
DROP TABLE #FunctionalDepartment
DROP TABLE #PropertyFund
DROP TABLE #PropertyFundMapping
DROP TABLE #ReportingEntityCorporateDepartment
DROP TABLE #ReportingEntityPropertyEntity
DROP TABLE #Location
DROP TABLE #RegionExtended
DROP TABLE #PayrollRegion
DROP TABLE #OverheadRegion
DROP TABLE #Project
DROP TABLE #BudgetEmployeePayrollAllocation
DROP TABLE #BudgetEmployeePayrollAllocationDetailBatches
DROP TABLE #BEPADa
DROP TABLE #BudgetEmployeePayrollAllocationDetail
DROP TABLE #BudgetTaxType
DROP TABLE #TaxType
DROP TABLE #EmployeePayrollAllocationDetail
DROP TABLE #BudgetOverheadAllocation
DROP TABLE #BudgetOverheadAllocationDetail
DROP TABLE #OverheadAllocationDetail
DROP TABLE #EffectiveFunctionalDepartment
DROP TABLE #ProfitabilityPreTaxSource
DROP TABLE #ProfitabilityTaxSource
DROP TABLE #ProfitabilityOverheadSource
DROP TABLE #ProfitabilityPayrollMapping
DROP TABLE #OriginatingRegionCorporateEntity
DROP TABLE #OriginatingRegionPropertyDepartment
DROP TABLE #AllocationSubRegion
DROP TABLE #ProfitabilityReforecast
DROP TABLE #DeletingBudget
--DROP TABLE #EUCorpCategoryLookup
--DROP TABLE #EUPropCategoryLookup
--DROP TABLE #EUFundCategoryLookup
--DROP TABLE #USPropCategoryLookup
--DROP TABLE #USCorpCategoryLookup
--DROP TABLE #USFundCategoryLookup
DROP TABLE #GlobalCategoryLookup
--DROP TABLE #DevelCategoryLookup

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]    Script Date: 08/05/2010 15:16:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]

	@ImportStartDate	DateTime,
	@ImportEndDate		DateTime,
	@DataPriorToDate	DateTime=NULL
AS

SET NOCOUNT ON
IF @DataPriorToDate IS NULL 
	SET @DataPriorToDate = GETDATE()

PRINT ''####''
PRINT ''stp_IU_LoadGrProfitabiltyPayrollOriginalBudget''
PRINT ''####''
	
/*
[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]
	@ImportStartDate	= ''1900-01-01'',
	@ImportEndDate		= ''2010-12-31'',
	@DataPriorToDate	= ''2010-12-31''
*/ 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Setup mapping variables
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--/*
-- Setup Bonus Cap Excess Project Setting

CREATE TABLE #SystemSettingRegion(
	SystemSettingId INT NOT NULL,
	SystemSettingName VARCHAR(50) NOT NULL,
	SystemSettingRegionId INT NOT NULL,
	RegionId INT,
	SourceCode VARCHAR(2),
	BonusCapExcessProjectId INT
)
INSERT INTO #SystemSettingRegion(
	SystemSettingId,
	SystemSettingName,
	SystemSettingRegionId,
	RegionId,
	SourceCode,
	BonusCapExcessProjectId
)

SELECT
	ss.SystemSettingId,
	ss.Name,
	ssr.SystemSettingRegionId,
	ssr.RegionId,
	ssr.SourceCode,
	ssr.BonusCapExcessProjectId
FROM
	(SELECT 
		ssr.* 
	 FROM
		TapasGlobal.SystemSettingRegion ssr
		INNER JOIN TapasGlobal.SystemSettingRegionActive(@DataPriorToDate) ssrA ON
			ssr.ImportKey = ssrA.ImportKey
	 ) ssr
	INNER JOIN
		(SELECT
			ss.SystemSettingId,
			ss.Name
		 FROM
			(SELECT	
				ss.*
			 FROM
				TapasGlobal.SystemSetting ss
				INNER JOIN TapasGlobal.SystemSettingActive(@DataPriorToDate) ssA ON
					ss.ImportKey = ssA.ImportKey
			 ) ss

		  ) ss ON
		ssr.SystemSettingId = ss.SystemSettingId
		
PRINT ''Completed getting system settings''
PRINT CONVERT(Varchar(27), getdate(), 121)

--*/
-- Setup account categories and default to UNKNOWN.
DECLARE 
	@SalariesTaxesBenefitsGLMajorCategoryId INT = -1,
	@BaseSalaryMinorGlAccountCategoryId INT = -1,
	@BenefitsMinorGlAccountCategoryId INT = -1,
	@BonusMinorGlAccountCategoryId INT = -1,
	@ProfitShareMinorGlAccountCategoryId INT = -1,
	@OccupancyCostsMajorGlAccountCategoryId INT = -1,
	@OverheadMinorGlAccountCategoryId INT = -1
	
DECLARE 
	@GlAccountKey			 INT = (SELECT GlAccountKey FROM GrReporting.dbo.GlAccount WHERE Code = ''UNKNOWN''),
	@SourceKey				 INT = (SELECT SourceKey FROM GrReporting.dbo.[Source] WHERE SourceName = ''UNKNOWN''),
	@FunctionalDepartmentKey INT = (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = ''UNKNOWN''),
	@ReimbursableKey		 INT = (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = ''UNKNOWN''),
	@ActivityTypeKey		 INT = (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = ''UNKNOWN''),
	@PropertyFundKey		 INT = (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = ''UNKNOWN''),
	@AllocationRegionKey	 INT = (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = ''UNKNOWN''),
	@OriginatingRegionKey	 INT = (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = ''UNKNOWN''),
	@LocalCurrencyKey		 INT = (SELECT CurrencyKey FROM GrReporting.dbo.Currency WHERE CurrencyCode = ''UNKNOWN'')

DECLARE
	@EUFundGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Fund Profit & Loss''      AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN''),
	@EUCorporateGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Corporate Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN''),
	@EUPropertyGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Property Profit & Loss''  AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN''),
	@USFundGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Fund Profit & Loss''      AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN''),
	@USPropertyGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Property Profit & Loss''  AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN''),
	@USCorporateGlAccountCategoryKeyUnknown INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Corporate Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN''),
	@DevelopmentGlAccountCategoryKeyUnknown INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''Development Profit & Loss''  AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN''),
	@GlobalGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global'' AND TranslationSubTypeName = ''Global'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')



-- Set gl account categories
SELECT TOP 1
	@SalariesTaxesBenefitsGLMajorCategoryId = GLMajorCategoryId
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryName = ''Salaries/Taxes/Benefits''

print (@SalariesTaxesBenefitsGLMajorCategoryId)

--NB!!!!!!!
--The roll up to payroll is very sensitive information. It is crutial that information regarding payroll not get 
--communicated to TS employees on certain reports. Changing the category name here will have ramifications because 
--some reports check for this name.
--NB!!!!!!!

SELECT
	@BaseSalaryMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsGLMajorCategoryId AND
	GLMinorCategoryName = ''Base Salary''

SELECT
	@BenefitsMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsGLMajorCategoryId AND
	GLMinorCategoryName = ''Benefits''

SELECT
	@BonusMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsGLMajorCategoryId AND
	GLMinorCategoryName = ''Bonus''

SELECT
	@ProfitShareMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsGLMajorCategoryId AND
	GLMinorCategoryName = ''Benefits'' -- Yes benefit is correct (Just incase they want to split profit share out again)

SELECT TOP 1
	@OccupancyCostsMajorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMinorCategoryName = ''General Overhead''

SELECT
	@OverheadMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @OccupancyCostsMajorGlAccountCategoryId AND
	GLMinorCategoryName = ''External General Overhead''

DECLARE @SourceSystemId int
SET @SourceSystemId = 2 -- Tapas budgeting source system

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Source Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--/*

CREATE TABLE #GLTranslationType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLTranslationSubType(
	ImportKey INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsGRDefault BIT NOT NULL
)

CREATE TABLE #GLMajorCategory(
	ImportKey INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMinorCategory(
	ImportKey INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLAccountType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLAccountSubType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	GLAccountSubTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

-- #GLTranslationType

INSERT INTO #GLTranslationType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	GLTranslationTypeId,
	Code,
	Name,
	[Description],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	TT.ImportKey,
	TT.ImportBatchId,
	TT.ImportDate,
	TT.GLTranslationTypeId,
	TT.Code,
	TT.Name,
	TT.[Description],
	TT.IsActive,
	TT.InsertedDate,
	TT.UpdatedDate,
	TT.UpdatedByStaffId
FROM
	Gdm.GLTranslationType TT
	INNER JOIN Gdm.GLTranslationTypeActive(@DataPriorToDate) TTA ON
		TTA.ImportKey = TT.ImportKey


-- #GLTranslationSubType

INSERT INTO #GLTranslationSubType(
	ImportKey,
	GLTranslationSubTypeId,
	GLTranslationTypeId,
	Code,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsGRDefault
)
SELECT
	TST.ImportKey,
	TST.GLTranslationSubTypeId,
	TST.GLTranslationTypeId,
	TST.Code,
	TST.[Name],
	TST.IsActive,
	TST.InsertedDate,
	TST.UpdatedDate,
	TST.UpdatedByStaffId,
	TST.IsGRDefault
FROM
	Gdm.GLTranslationSubType TST
	INNER JOIN Gdm.GLTranslationSubTypeActive(@DataPriorToDate) TSTA ON
		TSTA.ImportKey = TST.ImportKey

-- #GLAccountType

INSERT INTO #GLAccountType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	GLAccountTypeId,
	GLTranslationTypeId,
	Code,
	Name,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	AT.ImportKey,
	AT.ImportBatchId,
	AT.ImportDate,
	AT.GLAccountTypeId,
	AT.GLTranslationTypeId,
	AT.Code,
	AT.Name,
	AT.IsActive,
	AT.InsertedDate,
	AT.UpdatedDate,
	AT.UpdatedByStaffId	
FROM
	Gdm.GLAccountType AT
	INNER JOIN Gdm.GLAccountTypeActive(@DataPriorToDate) ATA ON
		AT.ImportKey = ATA.ImportKey
	
-- #GLAccountSubType

INSERT INTO #GLAccountSubType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	GLAccountSubTypeId,
	GLTranslationTypeId,
	Code,
	Name,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	AST.ImportKey,
	AST.ImportBatchId,
	AST.ImportDate,
	AST.GLAccountSubTypeId,
	AST.GLTranslationTypeId,
	AST.Code,
	AST.Name,
	AST.IsActive,
	AST.InsertedDate,
	AST.UpdatedDate,
	AST.UpdatedByStaffId
FROM
	Gdm.GLAccountSubType AST
	INNER JOIN Gdm.GLAccountSubTypeActive(@DataPriorToDate) ASTA ON
		AST.ImportKey = ASTA.ImportKey

-- #GLMajorCategory

INSERT INTO #GLMajorCategory(
	ImportKey,
	GLMajorCategoryId,
	GLTranslationSubTypeId,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	MajC.ImportKey,
	MajC.GLMajorCategoryId,
	MajC.GLTranslationSubTypeId,
	MajC.[Name],
	MajC.IsActive,
	MajC.InsertedDate,
	MajC.UpdatedDate,
	MajC.UpdatedByStaffId
FROM
	Gdm.GLMajorCategory MajC
	INNER JOIN Gdm.GLMajorCategoryActive(@DataPriorToDate) MajCA ON
		MajC.ImportKey = MajCA.ImportKey

-- #GLMinorCategory

INSERT INTO #GLMinorCategory(
	ImportKey,
	GLMinorCategoryId,
	GLMajorCategoryId,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	MinC.ImportKey,
	MinC.GLMinorCategoryId,
	MinC.GLMajorCategoryId,
	MinC.[Name],
	MinC.IsActive,
	MinC.InsertedDate,
	MinC.UpdatedDate,
	MinC.UpdatedByStaffId
FROM
	Gdm.GLMinorCategory MinC
	INNER JOIN Gdm.GLMinorCategoryActive(@DataPriorToDate) MinCA ON
		MinCA.ImportKey = MinC.ImportKey

-- Get GLTranslationType, GLTranslationSubType, GLAccountType(either expense type), and GLAccountSubType(either payroll type) data
-- This table is used when inserts are made to the TranslationSubType CategoryLookup tables: search for ''Map account categories'' section
CREATE TABLE #GLAccountCategoryTranslations(
	GLTranslationTypeId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationSubTypeCode VARCHAR(10) NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL
)

INSERT INTO #GLAccountCategoryTranslations(
	GLTranslationTypeId,
	GLTranslationSubTypeId,
	GLTranslationSubTypeCode,
	GLAccountTypeId,
	GLAccountSubTypeId
)
SELECT
	TST.GLTranslationTypeId,
	TST.GLTranslationSubTypeId,
	TST.Code,
	AT.GLAccountTypeId,
	AST.GLAccountSubTypeId
FROM
	#GLTranslationSubType TST

	INNER JOIN #GLTranslationType TT ON
		TT.GLTranslationTypeId = TST.GLTranslationTypeId

	INNER JOIN #GLAccountType AT ON
		TST.GLTranslationTypeId = AT.GLTranslationTypeId AND
		AT.IsActive = 1

	INNER JOIN #GLAccountSubType AST ON
		TST.GLTranslationTypeId = AST.GLTranslationTypeId AND
		AST.IsActive = 1
	
WHERE
	AST.Code LIKE ''%PYR'' AND -- This stored procedure exclusively looks at payroll. Only consider Account SubTypes related to payroll.
	AT.Code LIKE ''%EXP'' AND -- Only consider expense-related account types: Payroll is always considered as an expense.
	TT.IsActive = 1 AND
	TST.IsActive = 1 AND
	AT.IsActive = 1 AND
	AST.IsActive = 1

PRINT ''Completed getting GlAccountCategory records''
PRINT CONVERT(Varchar(27), getdate(), 121)
------------------------------------------------------------------------------------------------------
--Source and identify report grouping records
------------------------------------------------------------------------------------------------------

-- Source budget report group detail. 

CREATE TABLE #BudgetReportGroupDetail(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetReportGroupDetailId INT NOT NULL,
	BudgetReportGroupId INT NOT NULL,
	RegionId INT NOT NULL,
	BudgetId INT NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetReportGroupDetail(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetReportGroupDetailId,
	BudgetReportGroupId,
	RegionId,
	BudgetId,
	IsDeleted,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	brgd.*
FROM 
	TapasGlobalBudgeting.BudgetReportGroupDetail brgd
	INNER JOIN TapasGlobalBudgeting.BudgetReportGroupDetailActive(@DataPriorToDate) brgdA ON
		brgd.ImportKey = brgdA.ImportKey
		
PRINT ''Completed inserting records from BudgetReportGroupDetail:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget report group. 

CREATE TABLE #BudgetReportGroup(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetReportGroupId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	BudgetExchangeRateId INT NOT NULL,
	IsReforecast BIT NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NOT NULL,
	FirstProjectedPeriod INT NULL,
	IsDeleted BIT NOT NULL,
	GRChangedDate DATETIME NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	BudgetReportGroupPeriodId INT NULL
)

INSERT INTO #BudgetReportGroup(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetReportGroupId,
	Name,
	BudgetExchangeRateId,
	IsReforecast,
	StartPeriod,
	EndPeriod,
	FirstProjectedPeriod,
	IsDeleted,
	GRChangedDate,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	BudgetReportGroupPeriodId
)
SELECT 
	brg.* 
FROM 
	TapasGlobalBudgeting.BudgetReportGroup brg
	INNER JOIN TapasGlobalBudgeting.BudgetReportGroupActive(@DataPriorToDate) brgA ON
		brg.ImportKey = brgA.ImportKey
		
PRINT ''Completed inserting records from BudgetReportGroup:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source report group period mapping.

CREATE TABLE #BudgetReportGroupPeriod(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetReportGroupPeriodId INT NOT NULL,
	BudgetExchangeRateId INT NOT NULL,
	[Year] INT NOT NULL,
	Period INT NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetReportGroupPeriod(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetReportGroupPeriodId,
	BudgetExchangeRateId,
	[Year],
	Period,
	IsDeleted,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	brgp.*
FROM
	Gdm.BudgetReportGroupPeriod brgp
	INNER JOIN Gdm.BudgetReportGroupPeriodActive(@DataPriorToDate) brgpA ON
		brgp.ImportKey = brgpA.ImportKey
		
PRINT ''Completed inserting records from GRBudgetReportGroupPeriod:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget status

CREATE TABLE #BudgetStatus(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetStatusId INT NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	[Description] VARCHAR(100) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetStatus(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetStatusId,
	[Name],
	[Description],
	InsertedDate,
	UpdatedByStaffId
)
SELECT 
	BudgetStatus.* 
FROM
	TapasGlobalBudgeting.BudgetStatus BudgetStatus
	INNER JOIN TapasGlobalBudgeting.BudgetStatusActive(@DataPriorToDate) BudgetStatusA ON
		BudgetStatus.ImportKey = BudgetStatusA.ImportKey
		
PRINT ''Completed inserting records from BudgetStatus:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source all active budget

CREATE TABLE #AllActiveBudget(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetId INT NOT NULL,
	RegionId INT NOT NULL,
	BudgetTypeId INT NOT NULL,
	BudgetStatusId INT NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NOT NULL,
	FirstProjectedPeriod INT NULL,
	CurrencyCode VARCHAR(3) NOT NULL,
	CanEmployeesViewBudget BIT NOT NULL,
	IsReforecast BIT NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	LastLockedDate DATETIME NULL,
	BudgetAllocationSetId INT NULL,
	LastAMUpdateDate DATETIME NULL
)

INSERT INTO #AllActiveBudget(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetId,
	RegionId,
	BudgetTypeId,
	BudgetStatusId,
	Name,
	StartPeriod,
	EndPeriod,
	FirstProjectedPeriod,
	CurrencyCode,
	CanEmployeesViewBudget,
	IsReforecast,
	IsDeleted,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	LastLockedDate,
	BudgetAllocationSetId,
	LastAMUpdateDate
)
SELECT 
	Budget.*
FROM
	TapasGlobalBudgeting.Budget Budget
	INNER JOIN TapasGlobalBudgeting.BudgetActive(@DataPriorToDate) BudgetA ON
		Budget.ImportKey = BudgetA.ImportKey
		
PRINT ''Completed inserting records from Budget:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Modified new or modified budget or report group setup.

CREATE TABLE #AllModifiedReportBudget(
	BudgetId INT NOT NULL,
	BudgetReportGroupId INT NOT NULL,
	BudgetReportGroupPeriodId INT NOT NULL,
	IsBudgetDeleted BIT NOT NULL,
	IsBugetReforecast BIT NOT NULL,
	BudgetStatusId INT NOT NULL,
	IsDetailDeleted BIT NOT NULL,
	IsGroupReforecast BIT NOT NULL,
	GroupStartPeriod INT NOT NULL,
	GroupEndPeriod INT NOT NULL,
	IsGroupDeleted BIT NOT NULL,
	IsPeriodDeleted BIT NOT NULL
)

INSERT INTO #AllModifiedReportBudget(
	BudgetId,
	BudgetReportGroupId,
	BudgetReportGroupPeriodId,
	IsBudgetDeleted,
	IsBugetReforecast,
	BudgetStatusId,
	IsDetailDeleted,
	IsGroupReforecast,
	GroupStartPeriod,
	GroupEndPeriod,
	IsGroupDeleted,
	IsPeriodDeleted
)

SELECT 
	brgd.BudgetId, 
	brgd.BudgetReportGroupId,
	brgp.BudgetReportGroupPeriodId,
	Budget.IsDeleted AS IsBudgetDeleted,
	Budget.IsReforecast AS IsBugetReforecast,
	Budget.BudgetStatusId, 
	brgd.IsDeleted AS IsDetailDeleted, 
	brg.IsReforecast AS IsGroupReforecast, 
	brg.StartPeriod AS GroupStartPeriod, 
	brg.EndPeriod AS GroupEndPeriod, 
	brg.IsDeleted AS IsGroupDeleted,
	brgp.IsDeleted AS IsPeriodDeleted
FROM
	#AllActiveBudget Budget -- Active TapasGlobalBudgeting.Budget ''s

	INNER JOIN #BudgetReportGroupDetail brgd ON
		Budget.BudgetId = brgd.BudgetId

	INNER JOIN #BudgetReportGroup brg ON
		brgd.BudgetReportGroupId = brg.BudgetReportGroupId

	INNER JOIN #BudgetReportGroupPeriod brgp ON
		brgp.BudgetReportGroupPeriodId = brg.BudgetReportGroupPeriodId

WHERE -- Only pull budgets that were modified
	(brgd.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
	(brg.GRChangedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
	(brgp.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
	(Budget.LastLockedDate IS NOT NULL AND Budget.LastLockedDate BETWEEN @ImportStartDate AND @ImportEndDate)

PRINT ''Completed inserting records into #AllModifiedReportBudget:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Filtered budget and setup report group setup

CREATE TABLE #LockedModifiedReportGroup( -- All budgets in a particular group need to be locked before the group can be pulled
	BudgetReportGroupId INT NOT NULL
)

INSERT INTO #LockedModifiedReportGroup(
	BudgetReportGroupId
)

SELECT
	amrb.BudgetReportGroupId
FROM
	#AllModifiedReportBudget amrb
	
	INNER JOIN #BudgetStatus bs ON
		amrb.BudgetStatusId = bs.BudgetStatusId
GROUP BY
	amrb.BudgetReportGroupId
HAVING
	COUNT(*) = SUM(CASE WHEN bs.[Name] = ''Locked'' THEN 1 ELSE 0 END) -- Are all budgets locked within this group? If not, no budgets get imported 

PRINT ''Completed inserting records into #LockedModifiedReportGroup:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source filtered budget information

CREATE TABLE #FilteredModifiedReportBudget(
	BudgetId INT NOT NULL,
	BudgetReportGroupId INT NOT NULL,
	BudgetReportGroupPeriodId INT NOT NULL,
	IsBudgetDeleted BIT NOT NULL,
	IsBugetReforecast BIT NOT NULL,
	BudgetStatusId INT NOT NULL,
	IsDetailDeleted BIT NOT NULL,
	IsGroupReforecast BIT NOT NULL,
	GroupStartPeriod INT NOT NULL,
	GroupEndPeriod INT NOT NULL,
	IsGroupDeleted BIT NOT NULL,
	IsPeriodDeleted BIT NOT NULL,
	BudgetReportGroupPeriod INT NOT NULL
)

INSERT INTO #FilteredModifiedReportBudget(
	BudgetId,
	BudgetReportGroupId,
	BudgetReportGroupPeriodId,
	IsBudgetDeleted,
	IsBugetReforecast,
	BudgetStatusId,
	IsDetailDeleted,
	IsGroupReforecast,
	GroupStartPeriod,
	GroupEndPeriod,
	IsGroupDeleted,
	IsPeriodDeleted,
	BudgetReportGroupPeriod 
)
SELECT
	amrb.*,
	brgp.Period BudgetReportGroupPeriod
FROM
	#LockedModifiedReportGroup lmrg
	
	INNER JOIN #AllModifiedReportBudget amrb ON
		lmrg.BudgetReportGroupId = amrb.BudgetReportGroupId

	INNER JOIN #BudgetReportGroupPeriod brgp ON
		brgp.BudgetReportGroupPeriodId = amrb.BudgetReportGroupPeriodId
		
WHERE
	amrb.IsBudgetDeleted = 0 AND
	amrb.IsBugetReforecast = 0 AND
	amrb.IsDetailDeleted = 0 AND
	amrb.IsGroupReforecast = 0 AND
	amrb.IsGroupDeleted = 0 AND
	amrb.IsPeriodDeleted = 0 AND
	brgp.IsDeleted = 0

PRINT ''Completed inserting records into #FilteredModifiedReportBudget:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget information that meet criteria

CREATE TABLE #Budget(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetId INT NOT NULL,
	RegionId INT NOT NULL,
	BudgetTypeId INT NOT NULL,
	BudgetStatusId INT NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NOT NULL,
	FirstProjectedPeriod INT NULL,
	CurrencyCode VARCHAR(3) NOT NULL,
	CanEmployeesViewBudget BIT NOT NULL,
	IsReforecast BIT NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	LastLockedDate DATETIME NULL,
	BudgetAllocationSetId INT NULL,
	LastAMUpdateDate DATETIME NULL
)

INSERT INTO #Budget(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetId,
	RegionId,
	BudgetTypeId,
	BudgetStatusId,
	[Name],
	StartPeriod,
	EndPeriod,
	FirstProjectedPeriod,
	CurrencyCode,
	CanEmployeesViewBudget,
	IsReforecast,
	IsDeleted,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	LastLockedDate,
	BudgetAllocationSetId,
	LastAMUpdateDate
)
SELECT 
	Budget.* 
FROM
	#AllActiveBudget Budget
	
	INNER JOIN #FilteredModifiedReportBudget fmrb ON
		Budget.BudgetId = fmrb.BudgetId

PRINT ''Completed inserting records into #Budget:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetID ON #Budget (BudgetId)
PRINT ''Completed creating indexes on #Budget''
PRINT CONVERT(Varchar(27), getdate(), 121)

--*/
------------------------------------------------------------------------------------------------------
--Source associated records
------------------------------------------------------------------------------------------------------

--/*
-- Source budget project
-- Get all the budget projects that are associated with the budgets that will be pulled, as per code above
CREATE TABLE #BudgetProject(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetProjectId INT NOT NULL,
	BudgetId INT NOT NULL,
	ProjectId INT NULL,
	RegionId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	ActivityTypeId INT NOT NULL,
	Code VARCHAR(50) NULL,
	[Name] VARCHAR(100) NULL,
	CorporateDepartmentCode VARCHAR(6) NULL,
	CorporateSourceCode VARCHAR(2) NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NULL,
	IsReimbursable BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetProjectId INT NULL,
	IsTsCost BIT NOT NULL,
	CanAllocateOverheads BIT NOT NULL,
	AllocateOverheadsProjectId INT NULL,
	MarkUpPercentage DECIMAL(5, 4) NULL,
	ProjectOwnerStaffId INT NULL,
	AMBudgetProjectId INT NULL
)

INSERT INTO #BudgetProject(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetProjectId,
	BudgetId,
	ProjectId,
	RegionId,
	PropertyFundId,
	ActivityTypeId,
	Code,
	[Name],
	CorporateDepartmentCode,
	CorporateSourceCode,
	StartPeriod,
	EndPeriod,
	IsReimbursable,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetProjectId,
	IsTsCost,
	CanAllocateOverheads,
	AllocateOverheadsProjectId,
	MarkUpPercentage,
	ProjectOwnerStaffId,
	AMBudgetProjectId
)
SELECT 
	BudgetProject.* 
FROM 
	TapasGlobalBudgeting.BudgetProject BudgetProject
	INNER JOIN TapasGlobalBudgeting.BudgetProjectActive(@DataPriorToDate) BudgetProjectA ON
		BudgetProject.ImportKey = BudgetProjectA.ImportKey
		
	-- data limiting join
	INNER JOIN #Budget b ON
		BudgetProject.BudgetId = b.BudgetId

PRINT ''Completed inserting records into #BudgetProject:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetID ON #BudgetProject (BudgetId)
PRINT ''Completed creating indexes on #BudgetProject''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source region

CREATE TABLE #Region(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	RegionId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	PayCode VARCHAR(5) NULL,
	EnrollmentTypeId INT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

INSERT INTO #Region(
	ImportKey,
	ImportBatchId,
	ImportDate,
	RegionId,
	SourceCode,
	Code,
	[Name],
	PayCode,
	EnrollmentTypeId,
	InsertedDate,
	UpdatedDate
)
SELECT 
	SourceRegion.* 
FROM 
	HR.Region SourceRegion
	INNER JOIN HR.RegionActive(@DataPriorToDate) SourceRegionA ON
		SourceRegion.ImportKey = SourceRegionA.ImportKey
PRINT ''Completed inserting records into #Region:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Budget Employee

CREATE TABLE #BudgetEmployee(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	BudgetId INT NOT NULL,
	HrEmployeeId INT NULL,
	PayGroupId INT NOT NULL,
	JobTitleId INT NOT NULL,
	LocationId INT NOT NULL,
	StateId INT NULL,
	OverheadRegionId INT NOT NULL,
	ApproverStaffId INT NULL,
	[Name] VARCHAR(255) NOT NULL,
	IsUnion BIT NOT NULL,
	RehirePeriod INT NOT NULL,
	RehireDate DATETIME NOT NULL,
	TerminatePeriod INT NULL,
	TerminateDate DATETIME NULL,
	EmployeeHistoryEffectivePeriod INT NOT NULL,
	EmployeeHistoryEffectiveDate DATETIME NOT NULL,
	EmployeePayrollEffectiveDate DATETIME NULL,
	CurrentAnnualSalary DECIMAL(18, 2) NULL,
	PreviousYearSalary DECIMAL(18, 2) NULL,
	SalaryYear INT NOT NULL,
	PreviousYearBonus DECIMAL(18, 2) NULL,
	BonusYear INT NULL,
	IsActualEmployee BIT NOT NULL,
	IsReviewed BIT NOT NULL,
	IsPartTime BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetEmployeeId INT NULL
)

INSERT INTO #BudgetEmployee(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeeId,
	BudgetId,
	HrEmployeeId,
	PayGroupId,
	JobTitleId,
	LocationId,
	StateId,
	OverheadRegionId ,
	ApproverStaffId,
	[Name],
	IsUnion,
	RehirePeriod,
	RehireDate,
	TerminatePeriod,
	TerminateDate,
	EmployeeHistoryEffectivePeriod,
	EmployeeHistoryEffectiveDate,
	EmployeePayrollEffectiveDate,
	CurrentAnnualSalary,
	PreviousYearSalary,
	SalaryYear,
	PreviousYearBonus,
	BonusYear,
	IsActualEmployee,
	IsReviewed,
	IsPartTime,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetEmployeeId
)
SELECT 
	BudgetEmployee.* 
FROM 
	TapasGlobalBudgeting.BudgetEmployee BudgetEmployee
	INNER JOIN TapasGlobalBudgeting.BudgetEmployeeActive(@DataPriorToDate) BudgetEmployeeA ON
		BudgetEmployee.ImportKey = BudgetEmployeeA.ImportKey

	--data limiting join
	INNER JOIN #Budget b ON
		BudgetEmployee.BudgetId = b.BudgetId

PRINT ''Completed inserting records into #Region:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeeID ON #BudgetEmployee (BudgetEmployeeId)
CREATE INDEX IX_BudgetId ON #BudgetEmployee (BudgetId)
PRINT ''Completed creating indexes on ##BudgetEmployee''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Budget Employee Functional Department

CREATE TABLE #BudgetEmployeeFunctionalDepartment(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeeFunctionalDepartmentId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	SubDepartmentId INT NOT NULL,
	EffectivePeriod INT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL
)

INSERT INTO #BudgetEmployeeFunctionalDepartment(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeeFunctionalDepartmentId,
	BudgetEmployeeId,
	SubDepartmentId,
	EffectivePeriod,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	FunctionalDepartmentId
)

SELECT 
	efd.* 
FROM 
	TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment efd
	INNER JOIN TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartmentActive(@DataPriorToDate) efdA ON
		efd.ImportKey = efdA.ImportKey

	-- data limiting join
	INNER JOIN #BudgetEmployee be ON
		efd.BudgetEmployeeId = be.BudgetEmployeeId

PRINT ''Completed inserting records into #BudgetEmployeeFunctionalDepartment:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeeId ON #BudgetEmployeeFunctionalDepartment (BudgetEmployeeId)
PRINT ''Completed creating indexes on #BudgetEmployeeFunctionalDepartment''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Functional Department

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
	HR.FunctionalDepartment fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) fdA ON
		fd.ImportKey = fdA.ImportKey

PRINT ''Completed inserting records into #FunctionalDepartment:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_FunctionalDepartmentId ON #FunctionalDepartment (FunctionalDepartmentId)
PRINT ''Completed creating indexes on #FunctionalDepartment''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Property Fund

CREATE TABLE #PropertyFund(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	PropertyFundId INT NOT NULL,
	RelatedFundId INT NULL,
	EntityTypeId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	BudgetOwnerStaffId INT NOT NULL,
	RegionalOwnerStaffId INT NOT NULL,
	DefaultGLTranslationSubTypeId INT NULL,
	Name VARCHAR(100) NOT NULL,
	IsReportingEntity BIT NOT NULL,
	IsPropertyFund BIT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #PropertyFund(
	ImportKey,
	ImportBatchId,
	ImportDate,
	PropertyFundId,
	RelatedFundId,
	EntityTypeId,
	AllocationSubRegionGlobalRegionId,
	BudgetOwnerStaffId,
	RegionalOwnerStaffId,
	DefaultGLTranslationSubTypeId,
	Name,
	IsReportingEntity,
	IsPropertyFund,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT 
	PropertyFund.* 
FROM 
	Gdm.PropertyFund PropertyFund
	INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PropertyFundA ON
		PropertyFund.ImportKey = PropertyFundA.ImportKey 

PRINT ''Completed inserting records into #PropertyFund:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFund (PropertyFundId)
PRINT ''Completed creating indexes on #PropertyFund''
PRINT CONVERT(Varchar(27), getdate(), 121)


-- Source Property Fund Mapping

CREATE TABLE #PropertyFundMapping(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	PropertyFundMappingId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	PropertyFundCode VARCHAR(8) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL,
	ActivityTypeId INT NULL
)

INSERT INTO #PropertyFundMapping(
	ImportKey,
	ImportBatchId,
	ImportDate,
	PropertyFundMappingId,
	PropertyFundId,
	SourceCode,
	PropertyFundCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted,
	ActivityTypeId
)
SELECT 
	PropertyFundMapping.* 
FROM 
	Gdm.PropertyFundMapping PropertyFundMapping
	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PropertyFundMappingA ON
		PropertyFundMapping.ImportKey = PropertyFundMappingA.ImportKey 

PRINT ''Completed inserting records into #PropertyFundMapping:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFundMapping (PropertyFundCode,SourceCode,IsDeleted,PropertyFundId,ActivityTypeId)
PRINT ''Completed creating indexes on #PropertyFundMapping''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source ReportingEntityCorporateDepartment

CREATE TABLE #ReportingEntityCorporateDepartment( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	ReportingEntityCorporateDepartmentId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	CorporateDepartmentCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsDeleted BIT NOT NULL,
)

INSERT INTO	#ReportingEntityCorporateDepartment(
	ImportKey,
	ReportingEntityCorporateDepartmentId,
	PropertyFundId,
	SourceCode,
	CorporateDepartmentCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsDeleted
)
SELECT
	RECD.ImportKey,
	RECD.ReportingEntityCorporateDepartmentId,
	RECD.PropertyFundId,
	RECD.SourceCode,
	RECD.CorporateDepartmentCode,
	RECD.InsertedDate,
	RECD.UpdatedDate,
	RECD.UpdatedByStaffId,
	RECD.IsDeleted
FROM
	Gdm.ReportingEntityCorporateDepartment RECD
	INNER JOIN Gdm.ReportingEntityCorporateDepartmentActive(@DataPriorToDate) RECDA ON
		RECDA.ImportKey = RECD.ImportKey

PRINT ''Completed creating indexes on #ReportingEntityCorporateDepartment''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source ReportingEntityPropertyEntity

CREATE TABLE #ReportingEntityPropertyEntity( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	ReportingEntityPropertyEntityId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	PropertyEntityCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsDeleted BIT NOT NULL
)

INSERT INTO #ReportingEntityPropertyEntity(
	ImportKey,
	ReportingEntityPropertyEntityId,
	PropertyFundId,
	SourceCode,
	PropertyEntityCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsDeleted
)
SELECT
	REPE.ImportKey,
	REPE.ReportingEntityPropertyEntityId,
	REPE.PropertyFundId,
	REPE.SourceCode,
	REPE.PropertyEntityCode,
	REPE.InsertedDate,
	REPE.UpdatedDate,
	REPE.UpdatedByStaffId,
	REPE.IsDeleted
FROM
	Gdm.ReportingEntityPropertyEntity REPE
	INNER JOIN Gdm.ReportingEntityPropertyEntityActive(@DataPriorToDate) REPEA ON
		REPEA.ImportKey = REPE.ImportKey

PRINT ''Completed creating indexes on #ReportingEntityPropertyEntity''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Location

CREATE TABLE #Location(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	LocationId INT NOT NULL,
	ExternalSubRegionId INT NOT NULL,
	StateId INT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

INSERT INTO #Location(
	ImportKey,
	ImportBatchId,
	ImportDate,
	LocationId,
	ExternalSubRegionId,
	StateId,
	Code,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate
)
SELECT 
	Location.* 
FROM 
	HR.Location Location
	INNER JOIN HR.LocationActive(@DataPriorToDate) LocationA ON
		Location.ImportKey = LocationA.ImportKey
	
PRINT ''Completed inserting records into #Location:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_LocationId ON #Location (LocationId)
PRINT ''Completed creating indexes on #Location''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source region extended

CREATE TABLE #RegionExtended(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	RegionId INT NOT NULL,
	RegionalAdministratorId INT NOT NULL,
	CountryId INT NOT NULL,
	HasEmployees BIT NOT NULL,
	CanChargeMarkupOnProject BIT NOT NULL,
	CanChargeMarkupOnPayrollOverhead BIT NOT NULL,
	CanUploadOverheadJournal BIT NOT NULL,
	ProjectRef VARCHAR(8) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OverheadFunctionalDepartmentId INT NOT NULL,
	CanRegionBillInArrears BIT NOT NULL
)

INSERT INTO #RegionExtended(
	ImportKey,
	ImportBatchId,
	ImportDate,
	RegionId,
	RegionalAdministratorId,
	CountryId,
	HasEmployees,
	CanChargeMarkupOnProject,
	CanChargeMarkupOnPayrollOverhead,
	CanUploadOverheadJournal,
	ProjectRef,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OverheadFunctionalDepartmentId,
	CanRegionBillInArrears
)
SELECT 
	RegionExtended.* 
FROM 
	TapasGlobal.RegionExtended RegionExtended
	INNER JOIN TapasGlobal.RegionExtendedActive(@DataPriorToDate) RegionExtendedA ON
		RegionExtended.ImportKey = RegionExtendedA.ImportKey

PRINT ''Completed inserting records into #RegionExtended:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_RegionId ON #RegionExtended (RegionId)
PRINT ''Completed creating indexes on #RegionExtended''
PRINT CONVERT(Varchar(27), getdate(), 121)


-- Source Payroll Originating Region

CREATE TABLE #PayrollRegion(
	ImportKey INT NOT NULL,
	PayrollRegionId INT NOT NULL,
	RegionId INT NOT NULL,
	ExternalSubRegionId INT NOT NULL,
	CorporateEntityRef VARCHAR(6) NOT NULL,
	CorporateSourceCode VARCHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #PayrollRegion(
	ImportKey,
	PayrollRegionId,
	RegionId,
	ExternalSubRegionId,
	CorporateEntityRef,
	CorporateSourceCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT 
	PayrollRegion.* 
FROM 
	TapasGlobal.PayrollRegion PayrollRegion
	INNER JOIN TapasGlobal.PayrollRegionActive(@DataPriorToDate) PayrollRegionA ON
		PayrollRegion.ImportKey = PayrollRegionA.ImportKey
	
PRINT ''Completed inserting records into #PayrollRegion:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PayrollRegionId ON #PayrollRegion (PayrollRegionId)
PRINT ''Completed creating indexes on #PayrollRegion''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Overhead Originating Region

CREATE TABLE #OverheadRegion(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	OverheadRegionId INT NOT NULL,
	RegionId INT NOT NULL,
	CorporateEntityRef VARCHAR(6) NULL,
	CorporateSourceCode VARCHAR(2) NULL,
	[Name] VARCHAR(50) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #OverheadRegion(
	ImportKey,
	ImportBatchId,
	ImportDate,
	OverheadRegionId,
	RegionId,
	CorporateEntityRef,
	CorporateSourceCode,
	[Name],
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT 
	OverheadRegion.* 
FROM 
	TapasGlobal.OverheadRegion OverheadRegion
	INNER JOIN TapasGlobal.OverheadRegionActive(@DataPriorToDate) OverheadRegionA ON
		OverheadRegion.ImportKey = OverheadRegionA.ImportKey
	
PRINT ''Completed inserting records into #OverheadRegion:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_OverheadRegionId ON #OverheadRegion (OverheadRegionId)
PRINT ''Completed creating indexes on #OverheadRegion''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source project

CREATE TABLE #Project(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	ProjectId INT NOT NULL,
	RegionId INT NOT NULL,
	ActivityTypeId INT NOT NULL,
	ProjectOwnerId INT NULL,
	CorporateDepartmentCode VARCHAR(8) NOT NULL,
	CorporateSourceCode CHAR(2) NOT NULL,
	Code VARCHAR(50) NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	PropertyOverheadGLAccountCode VARCHAR(15) NULL,
	PropertyOverheadDepartmentCode VARCHAR(6) NULL,
	PropertyOverheadJobCode VARCHAR(15) NULL,
	PropertyOverheadSourceCode CHAR(2) NULL,
	CorporateUnionPayrollIncomeCategoryCode VARCHAR(6) NULL,
	CorporateNonUnionPayrollIncomeCategoryCode VARCHAR(6) NULL,
	CorporateOverheadIncomeCategoryCode VARCHAR(6) NULL,
	PropertyFundId INT NOT NULL,
	MarkUpPercentage DECIMAL(5, 4) NULL,
	HistoricalProjectCode VARCHAR(50) NULL,
	IsTSCost BIT NOT NULL,
	CanAllocateOverheads BIT NOT NULL,
	AllocateOverheadsProjectId INT NULL
)

INSERT INTO #Project(
	ImportKey,
	ImportBatchId,
	ImportDate,
	ProjectId,
	RegionId,
	ActivityTypeId,
	ProjectOwnerId,
	CorporateDepartmentCode,
	CorporateSourceCode,
	Code,
	[Name],
	StartPeriod,
	EndPeriod,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	PropertyOverheadGLAccountCode,
	PropertyOverheadDepartmentCode,
	PropertyOverheadJobCode,
	PropertyOverheadSourceCode,
	CorporateUnionPayrollIncomeCategoryCode,
	CorporateNonUnionPayrollIncomeCategoryCode,
	CorporateOverheadIncomeCategoryCode,
	PropertyFundId,
	MarkUpPercentage,
	HistoricalProjectCode,
	IsTSCost,
	CanAllocateOverheads,
	AllocateOverheadsProjectId
)
SELECT 
	Project.*
FROM 
	TapasGlobal.Project Project
	INNER JOIN TapasGlobal.ProjectActive(@DataPriorToDate) ProjectA ON
		Project.ImportKey = ProjectA.ImportKey 

PRINT ''Completed inserting records into #Project:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_ProjectId ON #Project (ProjectId)
PRINT ''Completed creating indexes on #Project''
PRINT CONVERT(Varchar(27), getdate(), 121)


------------------------------------------------------------------------------------------------------
--Source allocation records
------------------------------------------------------------------------------------------------------

-- Source payroll allocation

CREATE TABLE #BudgetEmployeePayrollAllocation(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	BudgetProjectId INT NOT NULL,
	BudgetProjectGroupId INT NULL,
	Period INT NOT NULL,
	SalaryAllocationValue DECIMAL(18, 9) NOT NULL,
	BonusAllocationValue DECIMAL(18, 9) NULL,
	BonusCapAllocationValue DECIMAL(18, 9) NULL,
	ProfitShareAllocationValue DECIMAL(18, 9) NULL,
	PreTaxSalaryAmount DECIMAL(18, 2) NOT NULL,
	PreTaxBonusAmount DECIMAL(18, 2) NULL,
	PreTaxBonusCapExcessAmount DECIMAL(18, 2) NULL,
	PreTaxProfitShareAmount DECIMAL(18, 2) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetEmployeePayrollAllocationId INT NULL
)

INSERT INTO #BudgetEmployeePayrollAllocation(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeePayrollAllocationId,
	BudgetEmployeeId,
	BudgetProjectId,
	BudgetProjectGroupId,
	Period,
	SalaryAllocationValue,
	BonusAllocationValue,
	BonusCapAllocationValue,
	ProfitShareAllocationValue,
	PreTaxSalaryAmount,
	PreTaxBonusAmount,
	PreTaxBonusCapExcessAmount,
	PreTaxProfitShareAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetEmployeePayrollAllocationId
)
SELECT
	Allocation.*
FROM
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocation Allocation

	INNER JOIN TapasGlobalBudgeting.BudgetEmployeePayrollAllocationActive(@DataPriorToDate) AllocationA ON
		Allocation.ImportKey = AllocationA.ImportKey

	--data limiting join
	INNER JOIN #BudgetProject bp ON
		Allocation.BudgetProjectId = bp.BudgetProjectId

PRINT ''Completed inserting records into #BudgetEmployeePayrollAllocation:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationId ON #BudgetEmployeePayrollAllocation (BudgetEmployeePayrollAllocationId)
PRINT ''Completed creating indexes on #BudgetEmployeePayrollAllocation''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source payroll tax detail
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Using the ''active'' function here cause serious performance issues and the only way around it, was to extract the logic from the is active function 
--to seperate peaces of code.
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #BudgetEmployeePayrollAllocationDetailBatches(
	BudgetEmployeePayrollAllocationDetailId int NOT NULL,
	ImportBatchId INT NOT NULL
)

INSERT INTO #BudgetEmployeePayrollAllocationDetailBatches(
	BudgetEmployeePayrollAllocationDetailId,
	ImportBatchId
)
SELECT 
	B2.BudgetEmployeePayrollAllocationDetailId,
	MAX(B2.ImportBatchId) AS ImportBatchId
FROM 
	[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B2
		
	INNER JOIN Batch ON
		B2.ImportBatchId = batch.BatchId
		
WHERE	
	batch.BatchEndDate IS NOT NULL AND
	batch.PackageName = ''ETL.Staging.TapasGlobalBudgeting'' AND
	batch.ImportEndDate <= @DataPriorToDate
		
GROUP BY
	B2.BudgetEmployeePayrollAllocationDetailId

PRINT ''Completed inserting records into #BudgetEmployeePayrollAllocationDetailBatches:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

----------

CREATE TABLE #BEPADa(
	ImportKey INT NOT NULL
)

INSERT INTO #BEPADa(
	ImportKey
)
SELECT
	MAX(B1.ImportKey) ImportKey
FROM
	[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B1

	INNER JOIN #BudgetEmployeePayrollAllocationDetailBatches t1 ON 
		t1.BudgetEmployeePayrollAllocationDetailId = B1.BudgetEmployeePayrollAllocationDetailId AND
		t1.ImportBatchId = B1.ImportBatchId

GROUP BY
	B1.BudgetEmployeePayrollAllocationDetailId

PRINT ''Completed inserting records into #BEPADa:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #BudgetEmployeePayrollAllocationDetail(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	BenefitOptionId INT NULL,
	BudgetTaxTypeId INT NULL,
	SalaryAmount DECIMAL(18, 2) NULL,
	BonusAmount DECIMAL(18, 2) NULL,
	ProfitShareAmount DECIMAL(18, 2) NULL,
	BonusCapExcessAmount DECIMAL(18, 2) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetEmployeePayrollAllocationDetail(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeePayrollAllocationDetailId,
	BudgetEmployeePayrollAllocationId,
	BenefitOptionId,
	BudgetTaxTypeId,
	SalaryAmount,
	BonusAmount,
	ProfitShareAmount,
	BonusCapExcessAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	TaxDetail.*
FROM
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocationDetail TaxDetail
	
	INNER JOIN #BEPADa TaxDetailA ON
		TaxDetail.ImportKey = TaxDetailA.ImportKey

	--data limiting join
	INNER JOIN #BudgetEmployeePayrollAllocation Allocation ON -- Only get tax details for the pre-tax amounts we are looking at
		TaxDetail.BudgetEmployeePayrollAllocationId = Allocation.BudgetEmployeePayrollAllocationId

PRINT ''Completed inserting records into #BudgetEmployeePayrollAllocationDetail:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationDetailId ON #BudgetEmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationDetailId)
PRINT ''Completed creating indexes on #BudgetEmployeePayrollAllocationDetail''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget tax type

CREATE TABLE #BudgetTaxType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetTaxTypeId INT NOT NULL,
	BudgetId INT NOT NULL,
	TaxTypeId INT NOT NULL,
	FixedTaxTypeId INT NOT NULL,
	RateCalculationMethodId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetTaxTypeId INT NULL
)

INSERT INTO #BudgetTaxType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetTaxTypeId,
	BudgetId,
	TaxTypeId,
	FixedTaxTypeId,
	RateCalculationMethodId,
	Name,
	InsertedDate,
	UpdatedByStaffId,
	OriginalBudgetTaxTypeId
)
SELECT 
	BudgetTaxType.* 
FROM 
	TapasGlobalBudgeting.BudgetTaxType BudgetTaxType
	INNER JOIN TapasGlobalBudgeting.BudgetTaxTypeActive(@DataPriorToDate) BudgetTaxTypeA ON
		BudgetTaxType.ImportKey = BudgetTaxTypeA.ImportKey

	-- data limiting join
	INNER JOIN #Budget b ON
		BudgetTaxType.BudgetId = b.BudgetId

PRINT ''Completed inserting records into #BudgetTaxType:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetTaxTypeId ON #BudgetTaxType (BudgetTaxTypeId)
PRINT ''Completed creating indexes on #BudgetTaxType''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source tax type

CREATE TABLE #TaxType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	TaxTypeId INT NOT NULL,
	RegionId INT NOT NULL,
	FixedTaxTypeId INT NOT NULL,
	RateCalculationMethodId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL
)

INSERT INTO #TaxType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	TaxTypeId,
	RegionId,
	FixedTaxTypeId,
	RateCalculationMethodId,
	Name,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	MinorGlAccountCategoryId
)
SELECT 
	TaxType.* 
FROM 
	TapasGlobalBudgeting.TaxType TaxType
	INNER JOIN TapasGlobalBudgeting.TaxTypeActive(@DataPriorToDate) TaxTypeA ON
		TaxType.ImportKey = TaxTypeA.ImportKey

PRINT ''Completed inserting records into #TaxType:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source payroll allocation Tax detail
CREATE TABLE #EmployeePayrollAllocationDetail
(
	ImportKey INT NOT NULL,
	BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	MinorGlAccountCategoryId INT NULL,
	BudgetTaxTypeId INT NULL,
	SalaryAmount DECIMAL(18, 2) NULL,
	BonusAmount DECIMAL(18, 2) NULL,
	ProfitShareAmount DECIMAL(18, 2) NULL,
	BonusCapExcessAmount DECIMAL(18, 2) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

-- Classifies tax types into minor categories, see CASE statement; gets set here because it can be overwritten later in the stored procedure

INSERT INTO #EmployeePayrollAllocationDetail
(
	ImportKey,
	BudgetEmployeePayrollAllocationDetailId,
	BudgetEmployeePayrollAllocationId,
	MinorGlAccountCategoryId,
	BudgetTaxTypeId,
	SalaryAmount,
	BonusAmount,
	ProfitShareAmount,
	BonusCapExcessAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	TaxDetail.ImportKey,
	TaxDetail.BudgetEmployeePayrollAllocationDetailId,
	TaxDetail.BudgetEmployeePayrollAllocationId,
	CASE WHEN (TaxDetail.BenefitOptionId IS NOT NULL) THEN @BenefitsMinorGlAccountCategoryId ELSE TaxType.MinorGlAccountCategoryId END AS MinorGlAccountCategoryId,
	TaxDetail.BudgetTaxTypeId,
	TaxDetail.SalaryAmount,
	TaxDetail.BonusAmount,
	TaxDetail.ProfitShareAmount,
	TaxDetail.BonusCapExcessAmount,
	TaxDetail.InsertedDate,
	TaxDetail.UpdatedDate,
	TaxDetail.UpdatedByStaffId
FROM

	-- Joining on allocation to limit amount of data
	#BudgetEmployeePayrollAllocation Allocation
	
	INNER JOIN #BudgetEmployeePayrollAllocationDetail TaxDetail ON
		Allocation.BudgetEmployeePayrollAllocationId = TaxDetail.BudgetEmployeePayrollAllocationId 
			
	LEFT OUTER JOIN #BudgetTaxType BudgetTaxType ON -- rather pull through as unknown than exclude, therefore LEFT JOIN
		TaxDetail.BudgetTaxTypeId = BudgetTaxType.BudgetTaxTypeId
				
	LEFT OUTER JOIN #TaxType TaxType ON
		BudgetTaxType.TaxTypeId = TaxType.TaxTypeId	
			
PRINT ''Completed inserting records into #EmployeePayrollAllocationDetail:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #EmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationDetailId,BudgetEmployeePayrollAllocationId)
PRINT ''Completed creating indexes on #EmployeePayrollAllocationDetail''
PRINT CONVERT(Varchar(27), getdate(), 121)

--*/
-- Source payroll overhead allocation

CREATE TABLE #BudgetOverheadAllocation(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetOverheadAllocationId INT NOT NULL,
	BudgetId INT NOT NULL,
	OverheadRegionId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	BudgetPeriod INT NOT NULL,
	AllocationAmount DECIMAL(18, 2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetOverheadAllocationId INT NULL
)

INSERT INTO #BudgetOverheadAllocation(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetOverheadAllocationId,
	BudgetId,
	OverheadRegionId,
	BudgetEmployeeId,
	BudgetPeriod,
	AllocationAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetOverheadAllocationId
)
SELECT
	OverheadAllocation.*
FROM
	TapasGlobalBudgeting.BudgetOverheadAllocation OverheadAllocation
	
	INNER JOIN TapasGlobalBudgeting.BudgetOverheadAllocationActive(@DataPriorToDate) OverheadAllocationA ON
		OverheadAllocation.ImportKey = OverheadAllocationA.ImportKey

	-- data limiting join
	INNER JOIN #Budget b ON
		OverheadAllocation.BudgetId = b.BudgetId

PRINT ''Completed inserting records into #BudgetOverheadAllocation:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocation (BudgetOverheadAllocationId,BudgetId,OverheadRegionId,BudgetEmployeeId)
PRINT ''Completed creating indexes on #BudgetOverheadAllocation''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source overhead allocation detail

CREATE TABLE #BudgetOverheadAllocationDetail(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetOverheadAllocationDetailId INT NOT NULL,
	BudgetOverheadAllocationId INT NOT NULL,
	BudgetProjectId INT NOT NULL,
	AllocationValue DECIMAL(18, 9) NOT NULL,
	AllocationAmount DECIMAL(18, 2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetOverheadAllocationDetail(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetOverheadAllocationDetailId,
	BudgetOverheadAllocationId,
	BudgetProjectId,
	AllocationValue,
	AllocationAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT 
	OverheadDetail.*
FROM			
	TapasGlobalBudgeting.BudgetOverheadAllocationDetail OverheadDetail
	
	INNER JOIN TapasGlobalBudgeting.BudgetOverheadAllocationDetailActive(@DataPriorToDate) OverheadDetailA ON
		OverheadDetail.ImportKey = OverheadDetailA.ImportKey

	-- data limiting join
	INNER JOIN #BudgetProject b ON
		OverheadDetail.BudgetProjectId = b.BudgetProjectId

PRINT ''Completed inserting records into #BudgetOverheadAllocationDetail:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
PRINT ''Completed creating indexes on #BudgetOverheadAllocationDetail''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source payroll overhead allocation detail
CREATE TABLE #OverheadAllocationDetail
(
	ImportKey INT NOT NULL,
	BudgetOverheadAllocationDetailId INT NOT NULL,
	BudgetOverheadAllocationId INT NOT NULL,
	BudgetProjectId INT NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL,
	AllocationValue DECIMAL(18, 9) NOT NULL,
	AllocationAmount DECIMAL(18, 2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #OverheadAllocationDetail
(
	ImportKey,
	BudgetOverheadAllocationDetailId,
	BudgetOverheadAllocationId,
	BudgetProjectId,
	MinorGlAccountCategoryId,
	AllocationValue,
	AllocationAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	OverheadDetail.ImportKey,
	OverheadDetail.BudgetOverheadAllocationDetailId,
	OverheadDetail.BudgetOverheadAllocationId,
	OverheadDetail.BudgetProjectId,
	@OverheadMinorGlAccountCategoryId AS MinorGlAccountCategoryId, -- Hardcode to a specific minor category, could be changed later in the stored proc
	OverheadDetail.AllocationValue,
	OverheadDetail.AllocationAmount,
	OverheadDetail.InsertedDate,
	OverheadDetail.UpdatedDate,
	OverheadDetail.UpdatedByStaffId
FROM

	-- Joining on allocation to limit amount of data
	#BudgetOverheadAllocation OverheadAllocation
	
	INNER JOIN #BudgetOverheadAllocationDetail OverheadDetail ON -- Only pull allocationDetails for the allocations we are pulling
		OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId 
			
PRINT ''Completed inserting records into #OverheadAllocationDetail:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #OverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
PRINT ''Completed creating indexes on #OverheadAllocationDetail''
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Map Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

--Calculate effective functional department
-- What was the last period before an employee changed her functional department, finds all functional departments that an employee is associated with
CREATE TABLE #EffectiveFunctionalDepartment(
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL
)

INSERT INTO #EffectiveFunctionalDepartment(
	BudgetEmployeePayrollAllocationId,
	BudgetEmployeeId,
	FunctionalDepartmentId
)
SELECT 
	Allocation.BudgetEmployeePayrollAllocationId,
	Allocation.BudgetEmployeeId,
	(
		SELECT 
			EFD.FunctionalDepartmentId
		FROM 
			(
				SELECT 
					Allocation2.BudgetEmployeeId,
					MAX(EFD.EffectivePeriod) AS EffectivePeriod
				FROM
					#BudgetEmployeePayrollAllocation Allocation2

					INNER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
						Allocation2.BudgetEmployeeId = EFD.BudgetEmployeeId
		
				WHERE
					Allocation.BudgetEmployeePayrollAllocationId = Allocation2.BudgetEmployeePayrollAllocationId AND
					EFD.EffectivePeriod <= Allocation.Period
			  
				GROUP BY
					Allocation2.BudgetEmployeeId
			) EFDo
		
			LEFT OUTER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
				EFD.BudgetEmployeeId = EFDo.BudgetEmployeeId AND
				EFD.EffectivePeriod = EFDo.EffectivePeriod
	 ) AS FunctionalDepartmentId
FROM
	#BudgetEmployeePayrollAllocation Allocation

	INNER JOIN #BudgetProject BudgetProject ON 
		Allocation.BudgetProjectId = BudgetProject.BudgetProjectId

PRINT ''Completed inserting records into #EffectiveFunctionalDepartment:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Pre Tax Amounts
CREATE TABLE #ProfitabilityPreTaxSource
(
	BudgetId INT NOT NULL,
	BudgetRegionId INT NOT NULL,
	ProjectId INT NOT NULL,
	HrEmployeeId INT NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	ExpensePeriod CHAR(6) NOT NULL,	
	SourceCode VARCHAR(2) NULL,
	SalaryPreTaxAmount MONEY NOT NULL,
	ProfitSharePreTaxAmount MONEY NOT NULL,
	BonusPreTaxAmount MONEY NOT NULL,
	BonusCapExcessPreTaxAmount MONEY NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	FunctionalDepartmentCode VARCHAR(31) NULL,
	Reimbursable BIT NULL,
	ActivityTypeId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	OriginatingRegionCode CHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	AllocationUpdatedDate DATETIME NOT NULL,
	BudgetReportGroupPeriod INT NOT NULL
)
-- Insert original budget amounts
-- links everything that we have pulled above (applying linking logic to tax, pre-tax and overhead data)
INSERT INTO #ProfitabilityPreTaxSource
(
	BudgetId,
	BudgetRegionId,
	ProjectId,
	HrEmployeeId,
	BudgetEmployeePayrollAllocationId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	SalaryPreTaxAmount,
	ProfitSharePreTaxAmount,
	BonusPreTaxAmount,
	BonusCapExcessPreTaxAmount,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate,
	BudgetReportGroupPeriod
)
SELECT 
	Budget.BudgetId AS BudgetId,
	Budget.RegionId AS BudgetRegionId,
	ISNULL(BudgetProject.ProjectId,0) AS ProjectId,
	ISNULL(BudgetEmployee.HrEmployeeId,0) AS HrEmployeeId,
	Allocation.BudgetEmployeePayrollAllocationId,
	''TGB:BudgetId='' + CONVERT(varchar,Budget.BudgetId) + ''&ProjectId='' + CONVERT(varchar,ISNULL(BudgetProject.ProjectId,0)) + ''&HrEmployeeId='' + CONVERT(varchar,ISNULL(BudgetEmployee.HrEmployeeId,0)) + ''&BudgetEmployeePayrollAllocationId='' + CONVERT(varchar,Allocation.BudgetEmployeePayrollAllocationId) + ''&BudgetEmployeePayrollAllocationDetailId=0&BudgetOverheadAllocationDetailId=0'' + ''&ImportKey='' + CONVERT(varchar, Allocation.ImportKey) AS ReferenceCode,
	Allocation.Period AS ExpensePeriod,
	SourceRegion.SourceCode,
	ISNULL(Allocation.PreTaxSalaryAmount,0) AS SalaryPreTaxAmount,
	ISNULL(Allocation.PreTaxProfitShareAmount, 0) AS ProfitSharePreTaxAmount,
	ISNULL(Allocation.PreTaxBonusAmount,0) AS BonusPreTaxAmount, 
	ISNULL(Allocation.PreTaxBonusCapExcessAmount,0) AS BonusCapExcessPreTaxAmount,
	ISNULL(EFD.FunctionalDepartmentId, -1),
	fd.GlobalCode AS FunctionalDepartmentCode, 
	CASE WHEN BudgetProject.IsTsCost = 0 THEN 1 ELSE 0 END AS Reimbursable,
	BudgetProject.ActivityTypeId,
	
	ISNULL(CASE
				WHEN (BudgetProject.CorporateDepartmentCode = ''@'' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN -- which property fund are we looking at 
					ProjectPropertyFund.PropertyFundId -- fall back
				ELSE -- else it is not @ or null, so use the mapping below (joining property fund from department to source)
					DepartmentPropertyFund.PropertyFundId 
			END, -1) AS PropertyFundId, -- else use -1, which is UNKNOWN
	
	ISNULL(CASE -- Same case logic as above
				WHEN (BudgetProject.CorporateDepartmentCode = ''@'' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,
		
	OriginatingRegion.CorporateEntityRef,
	OriginatingRegion.CorporateSourceCode,
	Budget.CurrencyCode AS LocalCurrencyCode,
	Allocation.UpdatedDate,
	fmrb.BudgetReportGroupPeriod
	
FROM
	#BudgetEmployeePayrollAllocation Allocation -- tax amount

	INNER JOIN #BudgetProject BudgetProject ON 
		Allocation.BudgetProjectId = BudgetProject.BudgetProjectId
			
	INNER JOIN #FilteredModifiedReportBudget fmrb ON
		BudgetProject.BudgetId = fmrb.BudgetId
			
	INNER JOIN #Budget Budget ON 
		fmrb.BudgetId = Budget.BudgetId 
		
	LEFT OUTER JOIN #Region SourceRegion ON 
		Budget.RegionId = SourceRegion.RegionId

	LEFT OUTER JOIN #EffectiveFunctionalDepartment efd ON
		Allocation.BudgetEmployeePayrollAllocationId = efd.BudgetEmployeePayrollAllocationId

	LEFT OUTER JOIN #FunctionalDepartment fd ON 
		efd.FunctionalDepartmentId = fd.FunctionalDepartmentId

	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON GrSc.SourceCode = SourceRegion.SourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		BudgetProject.CorporateSourceCode = pfm.SourceCode AND
						
		pfm.IsDeleted = 0 AND 
		(
			(GrSc.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId = BudgetProject.ActivityTypeId)
				OR
				(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
			)
		) AND
		fmrb.BudgetReportGroupPeriod < 201007	
	
	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		RECD.SourceCode = BudgetProject.CorporateSourceCode AND
		fmrb.BudgetReportGroupPeriod >= 201007 AND			   
		RECD.IsDeleted = 0
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = ''YES'' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		REPE.SourceCode = BudgetProject.CorporateSourceCode AND
		fmrb.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0

	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON -- property fund could be coming from multiple sources
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN fmrb.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = ''YES'' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END

	LEFT OUTER JOIN #BudgetEmployee BudgetEmployee ON
		Allocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId
		
	LEFT OUTER JOIN #Location Location ON 
		Location.LocationId = BudgetEmployee.LocationId
		
	LEFT OUTER JOIN #PayrollRegion OriginatingRegion ON 
		Location.ExternalSubRegionId = OriginatingRegion.ExternalSubRegionId AND
		Budget.RegionId = OriginatingRegion.RegionId

WHERE
	Allocation.Period BETWEEN fmrb.GroupStartPeriod AND fmrb.GroupEndPeriod AND
	BudgetProject.ActivityTypeId <> 99 -- exclude Corporate Overhead

PRINT ''Completed inserting records into #ProfitabilityPreTaxSource:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE INDEX IX_SalaryPreTaxAmount ON #ProfitabilityPreTaxSource (SalaryPreTaxAmount)
CREATE INDEX IX_ProfitSharePreTaxAmount ON #ProfitabilityPreTaxSource (ProfitSharePreTaxAmount)
CREATE INDEX IX_BonusPreTaxAmount ON #ProfitabilityPreTaxSource (BonusPreTaxAmount)

CREATE INDEX IX_BonusCapExcessPreTaxAmount ON #ProfitabilityPreTaxSource (BonusCapExcessPreTaxAmount)
PRINT ''Completed creating indexes on #ProfitabilityPreTaxSource''
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Tax Amounts

CREATE TABLE #ProfitabilityTaxSource
(
	BudgetId INT NOT NULL,
	BudgetRegionId INT NOT NULL,
	ProjectId INT NOT NULL,
	HrEmployeeId INT NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	ExpensePeriod CHAR(6) NOT NULL,	
	SourceCode VARCHAR(2) NULL,
	SalaryTaxAmount MONEY NOT NULL,
	ProfitShareTaxAmount MONEY NOT NULL,
	BonusTaxAmount MONEY NOT NULL,
	BonusCapExcessTaxAmount MONEY NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	FunctionalDepartmentCode VARCHAR(31) NULL,
	Reimbursable BIT NULL,
	ActivityTypeId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	OriginatingRegionCode CHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	AllocationUpdatedDate DATETIME NOT NULL,
	BudgetReportGroupPeriod INT NOT NULL
)
-- Insert original budget amounts
INSERT INTO #ProfitabilityTaxSource
(
	BudgetId,
	BudgetRegionId,
	ProjectId,
	HrEmployeeId,
	BudgetEmployeePayrollAllocationId,
	BudgetEmployeePayrollAllocationDetailId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	SalaryTaxAmount,
	ProfitShareTaxAmount,
	BonusTaxAmount,
	BonusCapExcessTaxAmount,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate,
	BudgetReportGroupPeriod
)
SELECT
	pts.BudgetId,
	pts.BudgetRegionId,
	ISNULL(pts.ProjectId,0) AS ProjectId,
	ISNULL(pts.HrEmployeeId,0) AS HrEmployeeId,
	pts.BudgetEmployeePayrollAllocationId,
	TaxDetail.BudgetEmployeePayrollAllocationDetailId,
	''TGB:BudgetId='' + CONVERT(varchar,pts.BudgetId) + ''&ProjectId='' + CONVERT(varchar,ISNULL(pts.ProjectId,0)) + ''&HrEmployeeId='' + CONVERT(varchar,ISNULL(pts.HrEmployeeId,0)) + ''&BudgetEmployeePayrollAllocationId='' + CONVERT(varchar,pts.BudgetEmployeePayrollAllocationId) + ''&BudgetEmployeePayrollAllocationDetailId='' + CONVERT(varchar,TaxDetail.BudgetEmployeePayrollAllocationDetailId) + ''&BudgetOverheadAllocationDetailId=0'' + ''&ImportKey='' + CONVERT(varchar, TaxDetail.ImportKey) AS ReferenceCode,
	pts.ExpensePeriod,
	pts.SourceCode,
	ISNULL(TaxDetail.SalaryAmount, 0) AS SalaryTaxAmount,
	ISNULL(TaxDetail.ProfitShareAmount, 0) AS ProfitShareTaxAmount,
	ISNULL(TaxDetail.BonusAmount, 0) AS BonusTaxAmount,
	ISNULL(TaxDetail.BonusCapExcessAmount, 0) AS BonusCapExcessTaxAmount,
	TaxDetail.MinorGlAccountCategoryId,
	ISNULL(pts.FunctionalDepartmentId, -1),
	pts.FunctionalDepartmentCode, 
	pts.Reimbursable,
	pts.ActivityTypeId,
	pts.PropertyFundId,
	pts.AllocationSubRegionGlobalRegionId,
	pts.OriginatingRegionCode,
	pts.OriginatingRegionSourceCode,
	pts.LocalCurrencyCode,
	pts.AllocationUpdatedDate,
	pts.BudgetReportGroupPeriod
FROM
	#EmployeePayrollAllocationDetail TaxDetail 

	INNER JOIN #ProfitabilityPreTaxSource pts ON -- pre tax has already been resolved, above, so join to limit taxdetail
		TaxDetail.BudgetEmployeePayrollAllocationId = pts.BudgetEmployeePayrollAllocationId

PRINT ''Completed inserting records into #ProfitabilityTaxSource:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Overhead Amounts

CREATE TABLE #ProfitabilityOverheadSource
(
	BudgetId INT NOT NULL,
	ProjectId INT NOT NULL,
	HrEmployeeId INT NOT NULL,
	BudgetOverheadAllocationId INT NOT NULL,
	BudgetOverheadAllocationDetailId INT NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	ExpensePeriod CHAR(6) NOT NULL,	
	SourceCode VARCHAR(2) NULL,
	OverheadAllocationAmount MONEY NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	FunctionalDepartmentCode VARCHAR(31) NULL,
	Reimbursable BIT NULL,
	ActivityTypeId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	OriginatingRegionCode CHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	OverheadUpdatedDate DATETIME NOT NULL
)
-- Insert original overhead amounts
INSERT INTO #ProfitabilityOverheadSource
(
	BudgetId,
	ProjectId,
	HrEmployeeId,
	BudgetOverheadAllocationId,
	BudgetOverheadAllocationDetailId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	OverheadAllocationAmount,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	OverheadUpdatedDate
)
SELECT
	Budget.BudgetId AS BudgetId,
	ISNULL(BudgetProject.ProjectId,0) AS ProjectId,
	ISNULL(BudgetEmployee.HrEmployeeId,0) AS HrEmployeeId,
	OverheadDetail.BudgetOverheadAllocationId,
	OverheadDetail.BudgetOverheadAllocationDetailId,
	''TGB:BudgetId='' + CONVERT(varchar,Budget.BudgetId) + ''&ProjectId='' + CONVERT(varchar,ISNULL(BudgetProject.ProjectId,0)) + ''&HrEmployeeId='' + CONVERT(varchar,ISNULL(BudgetEmployee.HrEmployeeId,0)) + ''&BudgetEmployeePayrollAllocationId=0&BudgetEmployeePayrollAllocationDetailId=0'' + ''&BudgetOverheadAllocationDetailId='' + CONVERT(varchar,OverheadDetail.BudgetOverheadAllocationDetailId) + ''&ImportKey='' + CONVERT(varchar, OverheadDetail.ImportKey) AS ReferenceCode,
	OverheadAllocation.BudgetPeriod AS ExpensePeriod,
	SourceRegion.SourceCode,
	ISNULL(OverheadDetail.AllocationAmount,0) AS OverheadAllocationAmount,
	OverheadDetail.MinorGlAccountCategoryId,
	ISNULL(RegionExtended.OverheadFunctionalDepartmentId, -1) AS FunctionalDepartmentId,
	fd.GlobalCode AS FunctionalDepartmentCode,
	 
	CASE
		WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
			CASE
				WHEN (BudgetProject.IsTsCost = 0) THEN -- Where ISTSCost is False the cost will be reimbursable
					1
				ELSE
					0
			END
		ELSE
			0  --Where the BudgetProject.OverheadAllocationProjectID is populated: non-reimbursable
	END AS Reimbursable,
	
	BudgetProject.ActivityTypeId,
	
	CASE -- allocation region gets sourced from property fund, project region = allocation region
		WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
			ISNULL(CASE
						WHEN (BudgetProject.CorporateDepartmentCode = ''@'' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
							ProjectPropertyFund.PropertyFundId
						ELSE
							DepartmentPropertyFund.PropertyFundId 
				   END, -1) 
		ELSE
			ISNULL(OverheadPropertyFund.PropertyFundId, -1)
	END AS PropertyFundId,
	
	ISNULL(CASE -- Same case logic as above
				WHEN (BudgetProject.CorporateDepartmentCode = ''@'' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,	
	
	OriginatingRegion.CorporateEntityRef,
	OriginatingRegion.CorporateSourceCode,
	Budget.CurrencyCode AS LocalCurrencyCode,
	OverheadDetail.UpdatedDate

FROM
	#BudgetOverheadAllocation OverheadAllocation 

	INNER JOIN #BudgetEmployee BudgetEmployee ON
		OverheadAllocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId

	INNER JOIN #OverheadAllocationDetail OverheadDetail ON -- where overhead amount sits
		OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId
			
	INNER JOIN #BudgetProject BudgetProject ON 
		OverheadDetail.BudgetProjectId = BudgetProject.BudgetProjectId
		
	INNER JOIN #FilteredModifiedReportBudget fmrb ON
		BudgetProject.BudgetId = fmrb.BudgetId
		
	INNER JOIN #Budget Budget ON 
		fmrb.BudgetId = Budget.BudgetId
		
	LEFT OUTER JOIN #Region SourceRegion ON 
		Budget.RegionId = SourceRegion.RegionId
		
	LEFT OUTER JOIN #RegionExtended RegionExtended ON 
		SourceRegion.RegionId = RegionExtended.RegionId

	LEFT OUTER JOIN #FunctionalDepartment fd ON 
		RegionExtended.OverheadFunctionalDepartmentId = fd.FunctionalDepartmentId

	LEFT OUTER JOIN	#Project OverheadProject ON
		BudgetProject.AllocateOverheadsProjectId = OverheadProject.ProjectId

	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId
	
	---------------
	
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrScC ON
		GrScC.SourceCode = BudgetProject.CorporateSourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		BudgetProject.CorporateSourceCode = pfm.SourceCode AND
		pfm.IsDeleted = 0 AND 
		(
			(GrScC.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrScC.IsCorporate = ''YES'' AND pfm.ActivityTypeId = BudgetProject.ActivityTypeId)
				OR
				(GrScC.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
			)
		) AND
		fmrb.BudgetReportGroupPeriod < 201007
	
	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECDC ON
		GrScC.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
		RECDC.CorporateDepartmentCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		RECDC.SourceCode = BudgetProject.CorporateSourceCode AND
		fmrb.BudgetReportGroupPeriod >= 201007 AND
		RECDC.IsDeleted = 0
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPEC ON
		GrScC.IsProperty = ''YES'' AND -- only property MRIs resolved through this
		REPEC.PropertyEntityCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		REPEC.SourceCode = BudgetProject.CorporateSourceCode AND
		fmrb.BudgetReportGroupPeriod >= 201007 AND
		REPEC.IsDeleted = 0	
	
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN fmrb.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrScC.IsCorporate = ''YES'' THEN RECDC.PropertyFundId
						ELSE REPEC.PropertyFundId
					END
			END

	---------------

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrScO ON
		GrScO.SourceCode = OverheadProject.CorporateSourceCode

	LEFT OUTER JOIN #PropertyFundMapping opfm ON
		OverheadProject.CorporateDepartmentCode = opfm.PropertyFundCode AND -- Combination of entity and corporate department
		OverheadProject.CorporateSourceCode = opfm.SourceCode AND
		opfm.IsDeleted = 0 AND 
		(
			(GrScO.IsProperty = ''YES'' AND opfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrScO.IsCorporate = ''YES'' AND opfm.ActivityTypeId = BudgetProject.ActivityTypeId)
				OR
				(GrScO.IsCorporate = ''YES'' AND opfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
			)
		) AND
		fmrb.BudgetReportGroupPeriod < 201007

	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECDO ON
		GrScO.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
		RECDO.CorporateDepartmentCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		RECDO.SourceCode = BudgetProject.CorporateSourceCode AND
		fmrb.BudgetReportGroupPeriod >= 201007 AND
		RECDO.IsDeleted = 0
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPEO ON
		GrScO.IsProperty = ''YES'' AND -- only property MRIs resolved through this
		REPEO.PropertyEntityCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		REPEO.SourceCode = BudgetProject.CorporateSourceCode AND
		fmrb.BudgetReportGroupPeriod >= 201007 AND
		REPEO.IsDeleted = 0	

	LEFT OUTER JOIN #PropertyFund OverheadPropertyFund ON
		OverheadPropertyFund.PropertyFundId =
			CASE
				WHEN fmrb.BudgetReportGroupPeriod < 201007 THEN opfm.PropertyFundId
				ELSE
					CASE
						WHEN GrScO.IsCorporate = ''YES'' THEN RECDO.PropertyFundId
						ELSE REPEO.PropertyFundId
					END
			END

	---------------

	LEFT OUTER JOIN #OverheadRegion OriginatingRegion ON 
		OverheadAllocation.OverheadRegionId = OriginatingRegion.OverheadRegionId
		
WHERE
	OverheadAllocation.BudgetPeriod BETWEEN fmrb.GroupStartPeriod AND fmrb.GroupEndPeriod
		
PRINT ''Completed inserting records into #ProfitabilityOverheadSource:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Generate mapping records
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityPayrollMapping
(
	BudgetId int NOT NULL,
	ReferenceCode varchar(300) NOT NULL,
	ExpensePeriod char(6) NOT NULL,	
	SourceCode varchar(2) NULL,
	BudgetAmount money NOT NULL,
	MajorGlAccountCategoryId int NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	FunctionalDepartmentId int NOT NULL,
	FunctionalDepartmentCode varchar(31) NULL,
	Reimbursable bit NOT NULL,
	ActivityTypeId int NOT NULL,
	PropertyFundId int NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	OriginatingRegionCode char(6) NULL,
	OriginatingRegionSourceCode varchar(2) NULL,
	LocalCurrencyCode char(3) NOT NULL,
	AllocationUpdatedDate datetime NOT NULL
)

INSERT INTO #ProfitabilityPayrollMapping
(
	BudgetId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	BudgetAmount,
	MajorGlAccountCategoryId,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate
)
-- Get Base Salary Payroll pre tax mappings and budget
SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=SalaryPreTax'' AS ReferenceCode,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.SalaryPreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	@BaseSalaryMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityPreTaxSource pps -- pull all pre-tax amounts that are not zero
WHERE
	pps.SalaryPreTaxAmount <> 0

-- Get Profit Share Benefit pre tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=ProfitSharePreTax'' AS ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.ProfitSharePreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	@ProfitShareMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityPreTaxSource pps
WHERE
	pps.ProfitSharePreTaxAmount <> 0

-- Get Bonus pre tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=BonusPreTax'' AS ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusPreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	@BonusMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityPreTaxSource pps
WHERE
	pps.BonusPreTaxAmount <> 0

--Get bonus cap pre tax mappings
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=BonusCapExcessPreTax'' AS ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusCapExcessPreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	@BonusMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	0 AS Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
	ISNULL(p.ActivityTypeId, -1) AS ActivityTypeId,
	
	ISNULL(CASE
				WHEN (p.CorporateDepartmentCode = ''@'' OR p.CorporateDepartmentCode IS NULL) THEN -- settings logic for bonus cap, override property fund
					ProjectPropertyFund.PropertyFundId
				ELSE 
					DepartmentPropertyFund.PropertyFundId 
		   END, -1) AS PropertyFundId,

	ISNULL(CASE -- Same case logic as above
				WHEN (p.CorporateDepartmentCode = ''@'' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,

	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityPreTaxSource pps
	
	LEFT OUTER JOIN #SystemSettingRegion ssr ON
		pps.SourceCode = ssr.SourceCode AND
		pps.BudgetRegionId = ssr.RegionId AND
		ssr.SystemSettingName = ''BonusCapExcess''
		
	LEFT OUTER JOIN #Project p ON
		ssr.BonusCapExcessProjectId = p.ProjectId
			
	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		p.PropertyFundId = ProjectPropertyFund.PropertyFundId
	
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		GrSc.SourceCode = pps.SourceCode
		
	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		p.CorporateSourceCode = pfm.SourceCode AND
		--This is a bypass for the ''NULL'' scenario, for only CORP have ActivityTypeId''s set
		ISNULL(p.ActivityTypeId, -1) = ISNULL(pfm.ActivityTypeId, -1) AND --This is a bypass for the ''NULL'' scenario, for only CORP have ActivityTypeId''s set
		pfm.IsDeleted = 0 AND 
		(
			(GrSc.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId = p.ActivityTypeId)
				OR
				(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
			)
		) AND
		pps.BudgetReportGroupPeriod < 201007
	
	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		RECD.SourceCode = p.CorporateSourceCode AND
		pps.BudgetReportGroupPeriod >= 201007 AND			   
		RECD.IsDeleted = 0
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = ''YES'' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		REPE.SourceCode = p.CorporateSourceCode AND
		pps.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0	
	
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN pps.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = ''YES'' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END
		
WHERE
	pps.BonusCapExcessPreTaxAmount <> 0

UNION ALL

-- Get Base Salary Payroll Tax mappings and budget
SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=SalaryTax'' AS ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.SalaryTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.SalaryTaxAmount <> 0

-- Get Profit Share Benefit Tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=ProfitShareTax'' AS ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.ProfitShareTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.ProfitShareTaxAmount <> 0

-- Get Bonus Tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=BonusTax'' AS ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.BonusTaxAmount <> 0

-- Get Bonus cap Tax mappings 
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=BonusCapExcessTax'' AS ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusCapExcessTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	0 AS Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
	ISNULL(p.ActivityTypeId, -1) AS ActivityTypeId,
	
	ISNULL(CASE
				WHEN (p.CorporateDepartmentCode = ''@'' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.PropertyFundId
				ELSE 
					DepartmentPropertyFund.PropertyFundId 
		   END, -1) AS PropertyFundId,
		   
	ISNULL(CASE -- Same case logic as above
				WHEN (p.CorporateDepartmentCode = ''@'' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,		   

	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityTaxSource pps

	LEFT OUTER JOIN #SystemSettingRegion ssr ON
		pps.SourceCode = ssr.SourceCode AND
		pps.BudgetRegionId = ssr.RegionId AND
		ssr.SystemSettingName = ''BonusCapExcess''

	LEFT OUTER JOIN #Project p ON
		ssr.BonusCapExcessProjectId = p.ProjectId

	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		p.PropertyFundId = ProjectPropertyFund.PropertyFundId

	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON GrSc.SourceCode = pps.SourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		p.CorporateSourceCode = pfm.SourceCode AND
		pfm.IsDeleted = 0 AND 
		(
			(GrSc.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId = p.ActivityTypeId)
				OR
				(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
			)
		) AND
		pps.BudgetReportGroupPeriod < 201007
	
	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		RECD.SourceCode = p.CorporateSourceCode AND
		pps.BudgetReportGroupPeriod >= 201007 AND			   
		RECD.IsDeleted = 0
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = ''YES'' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		REPE.SourceCode = p.CorporateSourceCode AND
		pps.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0		
	
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN pps.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = ''YES'' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END

WHERE
	pps.BonusCapExcessTaxAmount <> 0
	
-- Get Overhead mappings	
UNION ALL

SELECT
	pos.BudgetId,
	pos.ReferenceCode + ''&Type=OverheadAllocation'' AS ReferenceCod,
	pos.ExpensePeriod,
	pos.SourceCode,
	pos.OverheadAllocationAmount AS BudgetAmount,
	@OccupancyCostsMajorGlAccountCategoryId AS MinorGlAccountCategoryId,
	pos.MinorGlAccountCategoryId, 
	pos.FunctionalDepartmentId,
	pos.FunctionalDepartmentCode,
	pos.Reimbursable,  
	pos.ActivityTypeId,
	pos.PropertyFundId,
	pos.AllocationSubRegionGlobalRegionId,
	pos.OriginatingRegionCode,
	pos.OriginatingRegionSourceCode,
	pos.LocalCurrencyCode,
	pos.OverheadUpdatedDate
FROM
	#ProfitabilityOverheadSource pos
WHERE
	pos.OverheadAllocationAmount <> 0


PRINT ''Completed inserting records into #ProfitabilityPayrollMapping:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_AllocationUpdatedDate ON #ProfitabilityPayrollMapping(ReferenceCode,AllocationUpdatedDate)
PRINT ''Completed creating indexes on #ProfitabilityPayrollMapping''
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Map mapped source data into the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

------------------------------------------------------------------------------------------------------
-- Additional required mappings
------------------------------------------------------------------------------------------------------

-- Originating region mapping

CREATE TABLE #OriginatingRegionCorporateEntity( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	OriginatingRegionCorporateEntityId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	CorporateEntityCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL	
)

CREATE TABLE #OriginatingRegionPropertyDepartment( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	OriginatingRegionPropertyDepartmentId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	PropertyDepartmentCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL	
)

-- #OriginatingRegionCorporateEntity

INSERT INTO #OriginatingRegionCorporateEntity(
	ImportKey,
	OriginatingRegionCorporateEntityId,
	GlobalRegionId,
	CorporateEntityCode,
	SourceCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted
)
SELECT
	ORCE.ImportKey,
	ORCE.OriginatingRegionCorporateEntityId,
	ORCE.GlobalRegionId,
	ORCE.CorporateEntityCode,
	ORCE.SourceCode,
	ORCE.InsertedDate,
	ORCE.UpdatedDate,
	ORCE.IsDeleted	
FROM
	Gdm.OriginatingRegionCorporateEntity ORCE
	INNER JOIN Gdm.OriginatingRegionCorporateEntityActive (@DataPriorToDate) ORCEA ON
		ORCEA.ImportKey = ORCE.ImportKey

PRINT ''Completed inserting records into #OriginatingRegionCorporateEntity:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #OriginatingRegionCorporateEntity (CorporateEntityCode, SourceCode, IsDeleted, GlobalRegionId)
PRINT ''Completed creating indexes on #OriginatingRegionCorporateEntity''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- #OriginatingRegionPropertyDepartment

INSERT INTO #OriginatingRegionPropertyDepartment(
	ImportKey,
	OriginatingRegionPropertyDepartmentId,
	GlobalRegionId,
	PropertyDepartmentCode,
	SourceCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted
)
SELECT
	ORPD.ImportKey,
	ORPD.OriginatingRegionPropertyDepartmentId,
	ORPD.GlobalRegionId,
	ORPD.PropertyDepartmentCode,
	ORPD.SourceCode,
	ORPD.InsertedDate,
	ORPD.UpdatedDate,
	ORPD.IsDeleted
FROM
	Gdm.OriginatingRegionPropertyDepartment ORPD
	INNER JOIN Gdm.OriginatingRegionPropertyDepartmentActive(@DataPriorToDate) ORPDA ON
		ORPDA.ImportKey = ORPD.ImportKey

PRINT ''Completed inserting records into #OriginatingRegionPropertyDepartment:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #OriginatingRegionPropertyDepartment (PropertyDepartmentCode, SourceCode, IsDeleted, GlobalRegionId)
PRINT ''Completed creating indexes on #OriginatingRegionPropertyDepartment''
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE TABLE #AllocationSubRegion(
	ImportKey INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	ProjectCodePortion VARCHAR(2) NOT NULL,
	AllocationRegionGlobalRegionId INT NULL,
	DefaultCurrencyCode CHAR(3) NOT NULL,
	CountryId INT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

-- #AllocationSubRegion

INSERT INTO #AllocationSubRegion(
	ImportKey,
	AllocationSubRegionGlobalRegionId,
	Code,
	[Name],
	ProjectCodePortion,
	AllocationRegionGlobalRegionId,
	DefaultCurrencyCode,
	CountryId,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	ASR.ImportKey,
	ASR.AllocationSubRegionGlobalRegionId,
	ASR.Code,
	ASR.[Name],
	ASR.ProjectCodePortion,
	ASR.AllocationRegionGlobalRegionId,
	ASR.DefaultCurrencyCode,
	ASR.CountryId,
	ASR.IsActive,
	ASR.InsertedDate,
	ASR.UpdatedDate,
	ASR.UpdatedByStaffId
FROM
	Gdm.AllocationSubRegion ASR
	INNER JOIN	Gdm.AllocationSubRegionActive(@DataPriorToDate) ASRA ON ASRA.ImportKey = ASR.ImportKey

PRINT ''Completed inserting records into #AllocationRegionMapping:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


------------------------------------------------------------------------------------------------------
-- Map to the fact
------------------------------------------------------------------------------------------------------
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--If the join is not possible, default the link to the ''UNKNOWN'' link
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityBudget(
	CalendarKey int NOT NULL,
	GlAccountKey int NOT NULL,
	SourceKey int NOT NULL,
	FunctionalDepartmentKey int NOT NULL,
	ReimbursableKey int NOT NULL,
	ActivityTypeKey int NOT NULL,
	PropertyFundKey int NOT NULL,	
	AllocationRegionKey int NOT NULL,
	OriginatingRegionKey int NOT NULL,
	LocalCurrencyKey int NOT NULL,
	LocalBudget money NOT NULL,
	ReferenceCode Varchar(300) NOT NULL,
	BudgetId int NOT NULL,
	SourceSystemId int NOT NULL,
	
	EUCorporateGlAccountCategoryKey int NULL,
	EUPropertyGlAccountCategoryKey int NULL,
	EUFundGlAccountCategoryKey int NULL,

	USPropertyGlAccountCategoryKey int NULL,
	USCorporateGlAccountCategoryKey int NULL,
	USFundGlAccountCategoryKey int NULL,

	GlobalGlAccountCategoryKey int NULL,
	DevelopmentGlAccountCategoryKey int NULL
) 

INSERT INTO #ProfitabilityBudget 
(
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId
)
SELECT
	DATEDIFF(dd, ''1900-01-01'', LEFT(pbm.ExpensePeriod,4)+''-''+RIGHT(pbm.ExpensePeriod,2)+''-01'') AS CalendarKey,
	@GlAccountKey GlAccountKey,
	CASE WHEN GrSc.[SourceKey] IS NULL THEN @SourceKey ELSE GrSc.[SourceKey] END SourceKey,
	CASE WHEN GrFdm.[FunctionalDepartmentKey] IS NULL THEN @FunctionalDepartmentKey ELSE GrFdm.[FunctionalDepartmentKey] END FunctionalDepartmentKey,
	CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKey ELSE GrRi.ReimbursableKey END ReimbursableKey,
	CASE WHEN GrAt.[ActivityTypeKey] IS NULL THEN @ActivityTypeKey ELSE GrAt.[ActivityTypeKey] END ActivityTypeKey,
	CASE WHEN GrPf.[PropertyFundKey] IS NULL THEN @PropertyFundKey ELSE GrPf.[PropertyFundKey] END PropertyFundKey,
	CASE WHEN GrAr.[AllocationRegionKey] IS NULL THEN @AllocationRegionKey ELSE GrAr.[AllocationRegionKey] END AllocationRegionKey,
	CASE WHEN GrOr.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKey ELSE GrOr.[OriginatingRegionKey] END OriginatingRegionKey,
	CASE WHEN GrCu.[CurrencyKey] IS NULL THEN @LocalCurrencyKey ELSE GrCu.[CurrencyKey] END LocalCurrencyKey,
	pbm.BudgetAmount,
	pbm.ReferenceCode,
	pbm.BudgetId,
	@SourceSystemId
FROM
	#ProfitabilityPayrollMapping pbm
	
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON
		pbm.SourceCode = GrSc.SourceCode

	--Parent Level (No job code for payroll)
	LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdm ON
		pbm.AllocationUpdatedDate BETWEEN GrFdm.StartDate AND GrFdm.EndDate AND
		GrFdm.SubFunctionalDepartmentCode = GrFdm.FunctionalDepartmentCode AND
		--GrFdm.ReferenceCode LIKE pbm.FunctionalDepartmentCode +'':%'' AND --replaced by new logic below
		GrFdm.FunctionalDepartmentCode = pbm.FunctionalDepartmentCode
		
	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		CASE WHEN pbm.Reimbursable = 1 THEN ''YES'' ELSE ''NO'' END = GrRi.ReimbursableCode

	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		pbm.ActivityTypeId = GrAt.ActivityTypeId AND
		pbm.AllocationUpdatedDate BETWEEN GrAt.StartDate AND GrAt.EndDate

	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		pbm.PropertyFundId = GrPf.PropertyFundId AND
		pbm.AllocationUpdatedDate BETWEEN GrPf.StartDate AND GrPf.EndDate

	-- HACK: At some point tapas was supposed to pull project region out of GDM. 
	-- Now allocation regions are source based??? So I use the code because it is built up from the ProjectRegionId since there is only data for one source anyway.
	-- I don''t check source because actuals also don''t check source. 
	--LEFT OUTER JOIN #AllocationRegionMapping Arm ON
	--	Arm.RegionCode = pbm.ProjectRegionId AND -- TODO: Pull the RegionCode through from the top.
	--	Arm.IsDeleted = 0

	LEFT OUTER JOIN #AllocationSubRegion ASR ON
		pbm.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId AND
		ASR.IsActive = 1		

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		ASR.AllocationSubRegionGlobalRegionId = GrAr.GlobalRegionId AND
		pbm.AllocationUpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate

/* -- At some point Allocation region in GDM was going to become the master list
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		pbm.ProjectRegionId = GrAr.GlobalRegionId AND
		pbm.AllocationUpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate
*/

	--LEFT OUTER JOIN #OriginatingRegionMapping Orm ON
	--	Orm.RegionCode = CASE WHEN RIGHT(pbm.OriginatingRegionSourceCode,1) = ''C'' THEN LTRIM(RTRIM(pbm.OriginatingRegionCode))
	--							ELSE LTRIM(RTRIM(pbm.OriginatingRegionCode)) + LTRIM(RTRIM(pbm.FunctionalDepartmentCode)) END AND
	--	Orm.SourceCode = pbm.OriginatingRegionSourceCode AND
	--	Orm.IsDeleted = 0

	LEFT OUTER JOIN #OriginatingRegionCorporateEntity ORCE ON
		ORCE.CorporateEntityCode = pbm.OriginatingRegionCode AND
		ORCE.SourceCode = pbm.OriginatingRegionSourceCode AND
		ORCE.IsDeleted = 0
		   
	LEFT OUTER JOIN #OriginatingRegionPropertyDepartment ORPD ON
		ORPD.PropertyDepartmentCode = pbm.OriginatingRegionCode AND
		ORPD.SourceCode = pbm.OriginatingRegionSourceCode AND
		ORPD.IsDeleted = 0		
		
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		GrOr.GlobalRegionId = ISNULL(ORCE.GlobalRegionId, ORPD.GlobalRegionId) AND
		pbm.AllocationUpdatedDate BETWEEN GrOr.StartDate AND GrOr.EndDate
	
	LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
		pbm.LocalCurrencyCode = GrCu.CurrencyCode 

PRINT ''Completed inserting records into #ProfitabilityBudget:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProfitabilityBudget (ReferenceCode)
CREATE INDEX IX_CalendarKey ON #ProfitabilityBudget (CalendarKey)

PRINT ''Completed creating indexes on #OriginatingRegionMapping''
PRINT CONVERT(Varchar(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Remove existing data for modified budget projects
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #DeletingBudget
(
	BudgetId INT NOT NULL
)

INSERT INTO #DeletingBudget
(
	BudgetId
)
SELECT DISTINCT 
	BudgetId
FROM
	#Budget

DECLARE @BudgetId int = -1
DECLARE @LoopCount int = 0 -- Infinite loop safe guard

WHILE (EXISTS (SELECT TOP 1 BudgetId FROM #DeletingBudget) AND @LoopCount < 100000)
BEGIN
	
	SET @LoopCount = @LoopCount + 1
	SET @BudgetId = (SELECT TOP 1 BudgetId FROM #DeletingBudget)

	-- Remove old facts
	DELETE 
	FROM
		GrReporting.dbo.ProfitabilityBudget 
	WHERE
		BudgetId = @BudgetId and SourceSystemId = @SourceSystemId
	
	PRINT ''Completed deleting records from ProfitabilityBudget:BudgetId=''+CONVERT(varchar,@BudgetId)
	PRINT CONVERT(Varchar(27), getdate(), 121)

	DELETE
	FROM
		#DeletingBudget
	WHERE
		BudgetId = @BudgetId
END

print ''Cleaned up rows in ProfitabilityBudget''

------------------------------------------------------------------------------------------------------
-- Map account categories
------------------------------------------------------------------------------------------------------

--GlobalGlAccountCategoryKey

CREATE TABLE #GlobalCategoryLookup(
	GlAccountCategoryKey INT NULL,
	ReferenceCode VARCHAR(300) NOT NULL
)

INSERT INTO #GlobalCategoryLookup(
	GlAccountCategoryKey,
	ReferenceCode
)

SELECT 
	GlAcGlobal.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT 
			GlAcHg.GLTranslationTypeId,
			GlAcHg.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			GlAcHg.GLAccountTypeId,
			GlAcHg.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode
		 FROM	
			#ProfitabilityPayrollMapping Gl				
			CROSS JOIN (
							SELECT
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#GLAccountCategoryTranslations ACT
							WHERE
								ACT.GLTranslationSubTypeCode = ''GL''

						) GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcGlobal ON GlAcGlobal.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0)))

			AND Gl.AllocationUpdatedDate  BETWEEN GlAcGlobal.StartDate AND GlAcGlobal.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #GlobalCategoryLookup (ReferenceCode)

UPDATE
	#ProfitabilityBudget
SET
	GlobalGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END
FROM
	#GlobalCategoryLookup t1
WHERE
	t1.ReferenceCode = #ProfitabilityBudget.ReferenceCode



PRINT ''Completed converting all GlobalGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


/*
--EUCorporateGlAccountCategoryKey

CREATE TABLE #EUCorpCategoryLookup(
	GlAccountCategoryKey INT NULL,
	ReferenceCode VARCHAR(300) NOT NULL
)

INSERT INTO #EUCorpCategoryLookup(
	GlAccountCategoryKey,
	ReferenceCode
)
SELECT
	GlAcEUCorp.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT
			GlAcHg.GLTranslationTypeId,
			GlAcHg.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			GlAcHg.GLAccountTypeId,
			GlAcHg.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode
			
		FROM	
			#ProfitabilityPayrollMapping Gl
			CROSS JOIN (
							SELECT
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#GLAccountCategoryTranslations ACT
							WHERE
								ACT.GLTranslationSubTypeCode = ''EU CORP''

						) GlAcHg
	) Gl
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUCorp ON GlAcEUCorp.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0)))
								 
			AND Gl.AllocationUpdatedDate  BETWEEN GlAcEUCorp.StartDate AND GlAcEUCorp.EndDate
				
CREATE UNIQUE CLUSTERED INDEX IX ON #EUCorpCategoryLookup (ReferenceCode)

UPDATE
	#ProfitabilityBudget
SET
	EUCorporateGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @EUCorporateGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END 
FROM
	#EUCorpCategoryLookup t1
WHERE
	t1.ReferenceCode = #ProfitabilityBudget.ReferenceCode


PRINT ''Completed converting all EUCorporateGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--EUPropertyGlAccountCategoryKey

CREATE TABLE #EUPropCategoryLookup(
	GlAccountCategoryKey INT NULL,
	ReferenceCode VARCHAR(300) NOT NULL
)

INSERT INTO #EUPropCategoryLookup(
	GlAccountCategoryKey,
	ReferenceCode
)
SELECT 
	GlAcGlobal.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT 
			GlAcHg.GLTranslationTypeId,
			GlAcHg.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			GlAcHg.GLAccountTypeId,
			GlAcHg.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode
		 FROM	
			#ProfitabilityPayrollMapping Gl				
			CROSS JOIN (
							SELECT
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#GLAccountCategoryTranslations ACT
							WHERE
								ACT.GLTranslationSubTypeCode = ''EU PROP''

						) GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcGlobal ON GlAcGlobal.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0)))

			AND Gl.AllocationUpdatedDate  BETWEEN GlAcGlobal.StartDate AND GlAcGlobal.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #EUPropCategoryLookup (ReferenceCode)

UPDATE
	#ProfitabilityBudget
SET
	EUPropertyGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @EUPropertyGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END
FROM
	#EUPropCategoryLookup t1
WHERE
	t1.ReferenceCode = #ProfitabilityBudget.ReferenceCode


PRINT ''Completed converting all EUPropertyGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--EUFundGlAccountCategoryKey

CREATE TABLE #EUFundCategoryLookup(
	GlAccountCategoryKey INT NULL,
	ReferenceCode VARCHAR(300) NOT NULL
)

INSERT INTO #EUFundCategoryLookup(
	GlAccountCategoryKey,
	ReferenceCode
)
SELECT 
	GlAcGlobal.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT 
			GlAcHg.GLTranslationTypeId,
			GlAcHg.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			GlAcHg.GLAccountTypeId,
			GlAcHg.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode
		 FROM	
			#ProfitabilityPayrollMapping Gl				
			CROSS JOIN (
							SELECT
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#GLAccountCategoryTranslations ACT
							WHERE
								ACT.GLTranslationSubTypeCode = ''EU FUND''

						) GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcGlobal ON GlAcGlobal.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0)))

			AND Gl.AllocationUpdatedDate  BETWEEN GlAcGlobal.StartDate AND GlAcGlobal.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #EUFundCategoryLookup (ReferenceCode)

UPDATE
	#ProfitabilityBudget
SET
	EUFundGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @EUFundGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END
FROM
	#EUFundCategoryLookup t1
WHERE
	t1.ReferenceCode = #ProfitabilityBudget.ReferenceCode

	
PRINT ''Completed converting all EUFundGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--USPropertyGlAccountCategoryKey

CREATE TABLE #USPropCategoryLookup(
	GlAccountCategoryKey INT NULL,
	ReferenceCode VARCHAR(300) NOT NULL
)

INSERT INTO #USPropCategoryLookup(
	GlAccountCategoryKey,
	ReferenceCode
)
SELECT 
	GlAcGlobal.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT 
			GlAcHg.GLTranslationTypeId,
			GlAcHg.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			GlAcHg.GLAccountTypeId,
			GlAcHg.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode
		 FROM	
			#ProfitabilityPayrollMapping Gl				
			CROSS JOIN (
							SELECT
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#GLAccountCategoryTranslations ACT
							WHERE
								ACT.GLTranslationSubTypeCode = ''US PROP''

						) GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcGlobal ON GlAcGlobal.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0)))

			AND Gl.AllocationUpdatedDate  BETWEEN GlAcGlobal.StartDate AND GlAcGlobal.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #USPropCategoryLookup (ReferenceCode)

UPDATE
	#ProfitabilityBudget
SET
	USPropertyGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @USPropertyGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END
FROM
	#USPropCategoryLookup t1
WHERE
	t1.ReferenceCode = #ProfitabilityBudget.ReferenceCode

PRINT ''Completed converting all USPropertyGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--USCorporateGlAccountCategoryKey

CREATE TABLE #USCorpCategoryLookup(
	GlAccountCategoryKey INT NULL,
	ReferenceCode VARCHAR(300) NOT NULL
)

INSERT INTO #USCorpCategoryLookup(
	GlAccountCategoryKey,
	ReferenceCode
)
SELECT 
	GlAcGlobal.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT 
			GlAcHg.GLTranslationTypeId,
			GlAcHg.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			GlAcHg.GLAccountTypeId,
			GlAcHg.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode
		 FROM	
			#ProfitabilityPayrollMapping Gl				
			CROSS JOIN (
							SELECT
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#GLAccountCategoryTranslations ACT
							WHERE
								ACT.GLTranslationSubTypeCode = ''US CORP''

						) GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcGlobal ON GlAcGlobal.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0)))

			AND Gl.AllocationUpdatedDate  BETWEEN GlAcGlobal.StartDate AND GlAcGlobal.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #USCorpCategoryLookup (ReferenceCode)

UPDATE #ProfitabilityBudget
SET	USCorporateGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @USCorporateGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END
FROM #USCorpCategoryLookup t1
WHERE t1.ReferenceCode = #ProfitabilityBudget.ReferenceCode

PRINT ''Completed converting all USCorporateGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--USFundGlAccountCategoryKey

CREATE TABLE #USFundCategoryLookup(
	GlAccountCategoryKey INT NULL,
	ReferenceCode VARCHAR(300) NOT NULL
)

INSERT INTO #USFundCategoryLookup(
	GlAccountCategoryKey,
	ReferenceCode
)
SELECT 
	GlAcGlobal.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT 
			GlAcHg.GLTranslationTypeId,
			GlAcHg.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			GlAcHg.GLAccountTypeId,
			GlAcHg.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode
		 FROM	
			#ProfitabilityPayrollMapping Gl				
			CROSS JOIN (
							SELECT
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#GLAccountCategoryTranslations ACT
							WHERE
								ACT.GLTranslationSubTypeCode = ''US FUND''

						) GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcGlobal ON GlAcGlobal.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0)))

			AND Gl.AllocationUpdatedDate  BETWEEN GlAcGlobal.StartDate AND GlAcGlobal.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #USFundCategoryLookup (ReferenceCode)

UPDATE
	#ProfitabilityBudget
SET
	USFundGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @USFundGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END
FROM
	#USFundCategoryLookup t1
WHERE
	t1.ReferenceCode = #ProfitabilityBudget.ReferenceCode

PRINT ''Completed converting all USFundGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
		
--DevelopmentGlAccountCategoryKey

CREATE TABLE #DevelCategoryLookup(
	GlAccountCategoryKey INT NULL,
	ReferenceCode VARCHAR(300) NOT NULL
)

INSERT INTO #DevelCategoryLookup(
	GlAccountCategoryKey,
	ReferenceCode
)
SELECT 
	GlAcGlobal.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT 
			GlAcHg.GLTranslationTypeId,
			GlAcHg.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			GlAcHg.GLAccountTypeId,
			GlAcHg.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode
		 FROM	
			#ProfitabilityPayrollMapping Gl				
			CROSS JOIN (
							SELECT
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#GLAccountCategoryTranslations ACT
							WHERE
								ACT.GLTranslationSubTypeCode = ''DEV''

						) GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcGlobal ON GlAcGlobal.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0)))

			AND Gl.AllocationUpdatedDate  BETWEEN GlAcGlobal.StartDate AND GlAcGlobal.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #DevelCategoryLookup (ReferenceCode)

UPDATE
	#ProfitabilityBudget
SET
	DevelopmentGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @DevelopmentGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END
FROM
	#DevelCategoryLookup t1
WHERE
	t1.ReferenceCode = #ProfitabilityBudget.ReferenceCode

PRINT ''Completed converting all DevelopmentGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
*/

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Insert modified and new data 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

INSERT INTO GrReporting.dbo.ProfitabilityBudget
(
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
)
SELECT 
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	@EUCorporateGlAccountCategoryKeyUnknown, --EUCorporateGlAccountCategoryKey,
	@EUPropertyGlAccountCategoryKeyUnknown, --EUPropertyGlAccountCategoryKey,
	@EUFundGlAccountCategoryKeyUnknown, --EUFundGlAccountCategoryKey,

	@USPropertyGlAccountCategoryKeyUnknown, --USPropertyGlAccountCategoryKey,
	@USCorporateGlAccountCategoryKeyUnknown, ----USCorporateGlAccountCategoryKey,
	@USFundGlAccountCategoryKeyUnknown, --USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	@DevelopmentGlAccountCategoryKeyUnknown --DevelopmentGlAccountCategoryKey

FROM 
	#ProfitabilityBudget

print ''Rows Inserted in ProfitabilityBudget:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Clean up
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

DROP TABLE #SystemSettingRegion
DROP TABLE #GLAccountType
DROP TABLE #GLAccountSubType
DROP TABLE #GLTranslationType
DROP TABLE #GLTranslationSubType
DROP TABLE #GLMajorCategory
DROP TABLE #GLMinorCategory
DROP TABLE #GLAccountCategoryTranslations
DROP TABLE #BudgetReportGroupDetail
DROP TABLE #BudgetReportGroup
DROP TABLE #BudgetReportGroupPeriod
DROP TABLE #BudgetStatus
DROP TABLE #AllActiveBudget
DROP TABLE #AllModifiedReportBudget
DROP TABLE #LockedModifiedReportGroup
DROP TABLE #FilteredModifiedReportBudget
DROP TABLE #Budget
DROP TABLE #BudgetProject
DROP TABLE #Region
DROP TABLE #BudgetEmployee
DROP TABLE #BudgetEmployeeFunctionalDepartment
DROP TABLE #FunctionalDepartment
DROP TABLE #PropertyFund
DROP TABLE #PropertyFundMapping
DROP TABLE #ReportingEntityCorporateDepartment
DROP TABLE #ReportingEntityPropertyEntity
DROP TABLE #Location
DROP TABLE #RegionExtended
DROP TABLE #PayrollRegion
DROP TABLE #OverheadRegion
DROP TABLE #Project
DROP TABLE #BudgetEmployeePayrollAllocation
DROP TABLE #BudgetEmployeePayrollAllocationDetailBatches
DROP TABLE #BEPADa
DROP TABLE #BudgetEmployeePayrollAllocationDetail
DROP TABLE #BudgetTaxType
DROP TABLE #TaxType
DROP TABLE #EmployeePayrollAllocationDetail
DROP TABLE #BudgetOverheadAllocation
DROP TABLE #BudgetOverheadAllocationDetail
DROP TABLE #OverheadAllocationDetail
DROP TABLE #EffectiveFunctionalDepartment
DROP TABLE #ProfitabilityPreTaxSource
DROP TABLE #ProfitabilityTaxSource
DROP TABLE #ProfitabilityOverheadSource
DROP TABLE #ProfitabilityPayrollMapping
DROP TABLE #OriginatingRegionCorporateEntity
DROP TABLE #OriginatingRegionPropertyDepartment
DROP TABLE #AllocationSubRegion
DROP TABLE #ProfitabilityBudget
DROP TABLE #DeletingBudget
--DROP TABLE #EUCorpCategoryLookup
--DROP TABLE #EUPropCategoryLookup
--DROP TABLE #EUFundCategoryLookup
--DROP TABLE #USPropCategoryLookup
--DROP TABLE #USCorpCategoryLookup
--DROP TABLE #USFundCategoryLookup
DROP TABLE #GlobalCategoryLookup
--DROP TABLE #DevelCategoryLookup

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]    Script Date: 08/05/2010 15:16:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]
	@ImportStartDate DATETIME,
	@ImportEndDate	 DATETIME,
	@DataPriorToDate DATETIME
AS

DECLARE 
		@GlAccountKeyUnknown INT,
		@GlAccountCategoryKey INT,
		@FunctionalDepartmentKeyUnknown INT,
		@ReimbursableKeyUnknown INT,
		@ActivityTypeKeyUnknown INT,
		@SourceKeyUnknown INT,
		@OriginatingRegionKeyUnknown INT,
		@AllocationRegionKeyUnknown INT,
		@PropertyFundKeyUnknown INT,
		-- @CurrencyKey	INT,
		@EUFundGlAccountCategoryKeyUnknown	INT,
		@EUCorporateGlAccountCategoryKeyUnknown INT,
		@EUPropertyGlAccountCategoryKeyUnknown	INT,
		@USFundGlAccountCategoryKeyUnknown INT,
		@USPropertyGlAccountCategoryKeyUnknown	INT,
		@USCorporateGlAccountCategoryKeyUnknown INT,
		@DevelopmentGlAccountCategoryKeyUnknown INT,
		@GlobalGlAccountCategoryKeyUnknown INT
      
--Default FK for the Fact table
/*
[stp_IU_LoadGrProfitabiltyGeneralLedgerVer2]
	@ImportStartDate	= ''1900-01-01'',
	@ImportEndDate		= ''2010-12-31'',
	@DataPriorToDate	= ''2010-12-31''
*/       
SET @GlAccountKeyUnknown			= (SELECT GlAccountKey FROM GrReporting.dbo.GlAccount WHERE Code = ''UNKNOWN'') -- GDM: changed GlAccountCode to Code
SET @FunctionalDepartmentKeyUnknown = (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = ''UNKNOWN'')
SET @ReimbursableKeyUnknown		    = (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = ''UNKNOWN'')
SET @ActivityTypeKeyUnknown		    = (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = ''UNKNOWN'')
SET @SourceKeyUnknown				= (SELECT SourceKey FROM GrReporting.dbo.Source WHERE SourceName = ''UNKNOWN'')
SET @OriginatingRegionKeyUnknown	= (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = ''UNKNOWN'')
SET @AllocationRegionKeyUnknown	    = (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = ''UNKNOWN'')
SET @PropertyFundKeyUnknown		    = (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = ''UNKNOWN'')
--SET @CurrencyKey			 = (Select CurrencyKey From GrReporting.dbo.Currency Where CurrencyCode = ''UNK'')

SET @EUFundGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Fund Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @EUCorporateGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Corporate Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @EUPropertyGlAccountCategoryKeyUnknown  = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Property Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @USFundGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Fund Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @USPropertyGlAccountCategoryKeyUnknown  = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Property Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @USCorporateGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Corporate Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @DevelopmentGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''Development Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @GlobalGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global'' AND TranslationSubTypeName = ''Global'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')

IF (@DataPriorToDate IS NULL)
	SET @DataPriorToDate = GETDATE()

IF 	(@DataPriorToDate < ''2010-01-01'')
	SET @DataPriorToDate = ''2010-01-01''
	
SET NOCOUNT ON
PRINT ''####''
PRINT ''stp_IU_LoadGrProfitabiltyGeneralLedger''
PRINT CONVERT(VARCHAR(27), getdate(), 121)
PRINT ''####''

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Master Temp table for the combined ledger results from MRI Sources
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityGeneralLedger(
	SourcePrimaryKey VARCHAR(100) NULL,
	SourceTableId INT NOT NULL,
	SourceCode VARCHAR(2) NOT NULL,
	Period CHAR(6) NOT NULL,
	OriginatingRegionCode CHAR(6) NOT NULL,
	PropertyFundCode CHAR(12) NOT NULL,
	FunctionalDepartmentCode CHAR(15) NULL,
	JobCode CHAR(15) NULL,
	GlAccountCode CHAR(12) NOT NULL,
	LocalCurrency CHAR(3) NOT NULL,
	LocalActual MONEY NOT NULL,
	EnterDate DATETIME NULL,
	[User] NVARCHAR(20) NULL,
	[Description] NCHAR(60) NULL,
	AdditionalDescription NVARCHAR(4000) NULL,
	Basis CHAR(1) NOT NULL,
	LastDate DATETIME NULL,
	GlAccountSuffix VARCHAR(2) NULL,
	NetTSCost CHAR(1) NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--US PROP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO
	#ProfitabilityGeneralLedger (SourcePrimaryKey, SourceTableId, SourceCode, Period, OriginatingRegionCode, PropertyFundCode,
	FunctionalDepartmentCode, JobCode, GlAccountCode, LocalCurrency, LocalActual,EnterDate, [User], [Description], AdditionalDescription, Basis,
	LastDate, GlAccountSuffix, NetTSCost, UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	''USD'' ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '''')),
	RTRIM(ISNULL(Gl.[Description], '''')),
	RTRIM(CONVERT(NVARCHAR(4000), ISNULL(Gl.AdditionalDescription, ''''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	''N'',
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM 
	USProp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					USProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					USProp.ENTITY En
					INNER JOIN USProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	INNER JOIN (
				SELECT
					Ga.*
				FROM
					USProp.GACC Ga
					INNER JOIN USProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode

WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN (''A'',''B'') AND
	En.Name	NOT LIKE ''%Intercompany%'' AND
	ISNULL(Ga.IsGR, 0) = ''Y'' AND
	ISNULL(Gl.CorporateDepartmentCode, ''N'') = ''N'' AND
	Gl.BALFOR <> ''B'' AND
	RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)), 2) <> ''99''

PRINT ''US PROP:Rows Inserted Into #ProfitabilityGeneralLedger:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--US CORP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO #ProfitabilityGeneralLedger(
	SourcePrimaryKey,
	SourceTableId,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,

	''USD'' ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '''')),
	RTRIM(ISNULL(Gl.[Description], '''')),
	RTRIM(CONVERT(NVARCHAR(4000), ISNULL(Gl.AdditionalDescription, ''''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	ISNULL(Gd.NETTSCOST, ''N'') NetTSCost,
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM USCorp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					USCorp.GeneralLedger Gl
				GROUP BY
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					USCorp.ENTITY En
					INNER JOIN USCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.RegionCode
			
	INNER JOIN (
				SELECT
					Ga.*
				FROM
					USCorp.GACC Ga
					INNER JOIN USCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
				
	INNER JOIN (
				SELECT
					Gd.*
				FROM
					USCorp.GDEP Gd
					INNER JOIN USCorp.GDepActive(@DataPriorToDate) GdA ON
						GdA.ImportKey = Gd.ImportKey
				) Gd ON
		Gd.DEPARTMENT = Gl.PropertyFundCode
										
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN (''A'',''B'') AND
	En.Name	NOT LIKE ''%Intercompany%'' AND
	ISNULL(Ga.IsGR,0) = ''Y'' AND
	Gl.BALFOR <> ''B'' AND
	RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)),2) <> ''99''

PRINT ''US CORP:Rows Inserted Into #ProfitabilityGeneralLedger:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--EU PROP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO #ProfitabilityGeneralLedger(
	SourcePrimaryKey,
	SourceTableId,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	CASE WHEN ISNULL(Gl.OcurrCode, En.CurrCode) = ''PLZ'' THEN ''PLN'' ELSE ISNULL(Gl.OcurrCode, En.CurrCode) END ForeignCurrency,
	ISNULL(Gl.Amount,0) ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '''')),
	RTRIM(ISNULL(Gl.Description, '''')),
	RTRIM(CONVERT(NVARCHAR(4000), ISNULL(Gl.AdditionalDescription, ''''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	''N'',
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM EUProp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					EUProp.GeneralLedger Gl
				GROUP BY
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					EUProp.ENTITY En
					INNER JOIN EUProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode

	INNER JOIN (
				SELECT
					Ga.*
				FROM
					EUProp.GACC Ga
					INNER JOIN EUProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode

WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN (''A'',''B'') AND
	En.Name	NOT LIKE ''%Intercompany%'' AND
	ISNULL(Ga.IsGR, 0) = ''Y'' AND
	ISNULL(Gl.CorporateDepartmentCode, ''N'') = ''N'' AND
	Gl.BALFOR <> ''B'' AND
	RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)), 2) <> ''99''

PRINT ''EU PROP:Rows Inserted Into #ProfitabilityGeneralLedger:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--EU CORP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO #ProfitabilityGeneralLedger(
	SourcePrimaryKey,
	SourceTableId,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode, 
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription, 
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	CASE WHEN ISNULL(Gl.OcurrCode, En.CurrCode) = ''PLZ'' THEN ''PLN'' ELSE ISNULL(Gl.OcurrCode, En.CurrCode) END ForeignCurrency,
	ISNULL(Gl.Amount, 0) ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '''')),
	RTRIM(ISNULL(Gl.[Description], '''')),
	RTRIM(CONVERT(NVARCHAR(4000), ISNULL(Gl.AdditionalDescription, ''''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	ISNULL(Gd.NETTSCOST, ''N'') NetTSCost,
	ISNULL(Gl.LastDate, Gl.EnterDate)
	
FROM EUCorp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					EUCorp.GeneralLedger Gl
				GROUP BY
						SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					EUCorp.ENTITY En
					INNER JOIN EUCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.RegionCode
				
	INNER JOIN (
				SELECT
					Ga.*
				FROM
					EUCorp.GACC Ga
					INNER JOIN EUCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode

	INNER JOIN (
				SELECT
					Gd.*
				FROM
					EUCorp.GDEP Gd
					INNER JOIN EUCorp.GDepActive(@DataPriorToDate) GdA ON
						GdA.ImportKey = Gd.ImportKey
				) Gd ON
		Gd.DEPARTMENT = Gl.PropertyFundCode

WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN (''A'',''B'') AND
	En.Name	NOT LIKE ''%Intercompany%'' AND
	ISNULL(Ga.IsGR, 0) = ''Y'' AND
	Gl.BALFOR <> ''B'' AND
	RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)),2) <> ''99''

PRINT ''EU CORP:Rows Inserted Into #ProfitabilityGeneralLedger:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--BR PROP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO #ProfitabilityGeneralLedger(
	SourcePrimaryKey,
	SourceTableId,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	Gl.OcurrCode ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '''')),
	RTRIM(ISNULL(Gl.Description, '''')),
	RTRIM(CONVERT(NVARCHAR(4000), ISNULL(Gl.AdditionalDescription, ''''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	''N'',
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM
	BRProp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					BRProp.GeneralLedger Gl
				GROUP BY
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					BRProp.ENTITY En
					INNER JOIN BRProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	INNER JOIN (
				SELECT
					Ga.*
				FROM
					BRProp.GACC Ga
					INNER JOIN BRProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
					
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN (''A'',''B'') AND
	En.Name	NOT LIKE ''%Intercompany%'' AND
	ISNULL(Ga.IsGR, 0) = ''Y'' AND
	ISNULL(Gl.CorporateDepartmentCode, ''N'') = ''N'' AND
	Gl.BALFOR <> ''B'' AND
	Gl.[Source]	= ''GR'' AND
	RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)), 2) <> ''99''

PRINT ''BR PROP:Rows Inserted Into #ProfitabilityGeneralLedger:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--BR CORP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO #ProfitabilityGeneralLedger(
	SourcePrimaryKey,
	SourceTableId,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	''BRL'' ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(IsNull(Gl.[User], '''')),
	RTRIM(IsNull(Gl.[Description], '''')),
	RTRIM(CONVERT(NVARCHAR(4000),IsNull(Gl.AdditionalDescription, ''''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	ISNULL(Gd.NETTSCOST, ''N'') NetTSCost,
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM BRCorp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
						SourcePrimaryKey,
						MAX(SourceTableId) SourceTableId
				FROM
						BRCorp.GeneralLedger Gl
				GROUP BY
						SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					BRCorp.ENTITY En
					INNER JOIN BRCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.RegionCode
			
	INNER JOIN (
				SELECT
					Ga.*
				FROM
					BRCorp.GACC Ga
					INNER JOIN BRCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode

	INNER JOIN (
				SELECT
					Gd.*
				FROM
					BRCorp.GDEP Gd
					INNER JOIN BRCorp.GDepActive(@DataPriorToDate) GdA ON
						GdA.ImportKey = Gd.ImportKey
				) Gd ON
		Gd.DEPARTMENT = Gl.PropertyFundCode
															
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN (''A'',''B'') AND
	En.Name	NOT LIKE ''%Intercompany%'' AND
	ISNULL(Ga.IsGR,0) = ''Y'' AND
	Gl.BALFOR <> ''B'' AND
	Gl.[Source] = ''GR'' AND
	RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)),2) <> ''99''


PRINT ''BR CORP:Rows Inserted Into #ProfitabilityGeneralLedger:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--CH PROP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO #ProfitabilityGeneralLedger(
	SourcePrimaryKey,
	SourceTableId,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	ISNULL(Em.LocalEntityRef, Gl.PropertyFundCode) PropertyFundCode, --Generic convert 7char to 6char EntityID
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	Gl.OcurrCode ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(IsNull(Gl.[User], '''')),
	RTRIM(IsNull(Gl.[Description], '''')),
	RTRIM(CONVERT(NVARCHAR(4000),IsNull(Gl.AdditionalDescription, ''''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	''N'',
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM
	CNProp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					CNProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					CNProp.ENTITY En
					INNER JOIN CNProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	INNER JOIN (
				SELECT
					Em.*
				FROM
					GACS.EntityMapping Em
					INNER JOIN GACS.EntityMappingActive(@DataPriorToDate) EmA ON
						EmA.ImportKey = Em.ImportKey
				) Em ON
		Em.OriginalEntityRef = Gl.PropertyFundCode AND
		Em.[Source] = Gl.SourceCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					CNProp.GACC Ga
					INNER JOIN CNProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
					
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN (''A'',''B'') AND
	En.Name	NOT LIKE ''%Intercompany%'' AND
	ISNULL(Ga.IsGR, 0) = ''Y'' AND
	ISNULL(Gl.CorporateDepartmentCode, ''N'') = ''N'' AND
	Gl.BALFOR <> ''B'' AND
	RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)), 2) <> ''99''

PRINT ''CH PROP:Rows Inserted Into #ProfitabilityGeneralLedger:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--CH CORP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO #ProfitabilityGeneralLedger(
	SourcePrimaryKey,
	SourceTableId,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	Gl.OcurrCode ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '''')),
	RTRIM(ISNULL(Gl.[Description], '''')),
	RTRIM(CONVERT(NVARCHAR(4000),ISNULL(Gl.AdditionalDescription, ''''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	ISNULL(Gd.NETTSCOST, ''N'') NetTSCost,
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM
	CNCorp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					CNCorp.GeneralLedger Gl
				GROUP BY
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					CNCorp.ENTITY En
					INNER JOIN CNCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.RegionCode
			
	INNER JOIN (
				SELECT
					Ga.*
				FROM
					CNCorp.GACC Ga
					INNER JOIN CNCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode

	INNER JOIN (
				SELECT
					Gd.*
				FROM
					CNCorp.GDEP Gd
					INNER JOIN CNCorp.GDepActive(@DataPriorToDate) GdA ON
						GdA.ImportKey = Gd.ImportKey
				) Gd ON
		Gd.DEPARTMENT = Gl.PropertyFundCode
															
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN (''A'',''B'') AND
	En.Name	NOT LIKE ''%Intercompany%'' AND
	ISNULL(Ga.IsGR,0) = ''Y'' AND
	Gl.BALFOR <> ''B'' AND
	RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)),2) <> ''99''

PRINT ''CH CORP:Rows Inserted Into #ProfitabilityGeneralLedger:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--IN PROP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO #ProfitabilityGeneralLedger(
	SourcePrimaryKey,
	SourceTableId,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	Gl.OcurrCode ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '''')),
	RTRIM(ISNULL(Gl.[Description], '''')),
	RTRIM(CONVERT(NVARCHAR(4000),ISNULL(Gl.AdditionalDescription, ''''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	''N'',
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM
	INProp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					INProp.GeneralLedger Gl
				GROUP BY
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					INProp.ENTITY En
					INNER JOIN INProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	INNER JOIN (
				SELECT
					Ga.*
				FROM
					INProp.GACC Ga
					INNER JOIN INProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
					
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN (''A'',''B'') AND
	En.Name	NOT LIKE ''%Intercompany%'' AND
	ISNULL(Ga.IsGR, 0) = ''Y'' AND
	ISNULL(Gl.CorporateDepartmentCode, ''N'') = ''N'' AND
	Gl.BALFOR <> ''B'' AND
	Gl.[Source] = ''GR'' AND
	RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)) ,2) <> ''99''

PRINT ''IN PROP:Rows Inserted Into #ProfitabilityGeneralLedger:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--IN CORP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO #ProfitabilityGeneralLedger(
	SourcePrimaryKey,
	SourceTableId,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	Gl.OcurrCode ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '''')),
	RTRIM(ISNULL(Gl.[Description], '''')),
	RTRIM(CONVERT(NVARCHAR(4000),ISNULL(Gl.AdditionalDescription, ''''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	ISNULL(Gd.NETTSCOST,''N'') NetTSCost,
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM
	INCorp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					INCorp.GeneralLedger Gl
				GROUP BY
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					INCorp.ENTITY En
					INNER JOIN INCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.RegionCode
			
	INNER JOIN (
				SELECT
					Ga.*
				FROM
					INCorp.GACC Ga
					INNER JOIN INCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
				
	INNER JOIN (
				SELECT
					Gd.*
				FROM
					INCorp.GDEP Gd
					INNER JOIN INCorp.GDepActive(@DataPriorToDate) GdA ON
						GdA.ImportKey = Gd.ImportKey
				) Gd ON
		Gd.DEPARTMENT = Gl.PropertyFundCode
										
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN (''A'',''B'') AND
	En.Name	NOT LIKE ''%Intercompany%'' AND
	ISNULL(Ga.IsGR, 0) = ''Y'' AND
	Gl.BALFOR <> ''B'' AND
	Gl.[Source] = ''GR'' AND
	RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)), 2) <> ''99''

PRINT ''IN CORP:Rows Inserted Into #ProfitabilityGeneralLedger:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)


CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProfitabilityGeneralLedger (UpdatedDate, FunctionalDepartmentCode, JobCode, GlAccountCode, SourceCode, Period, OriginatingRegionCode, PropertyFundCode, SourcePrimaryKey)

PRINT ''Completed building clustered index on #ProfitabilityGeneralLedger''
PRINT CONVERT(VARCHAR(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Take the different sources and combine them INTo the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Prepare the # tables used for performance optimization
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
CREATE TABLE #FunctionalDepartment(
	ImportKey INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	Code VARCHAR(31) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	GlobalCode CHAR(3) NULL
)

CREATE TABLE #Department(
	ImportKey INT NOT NULL,
	Department CHAR(8) NOT NULL,
	[Description] VARCHAR(50) NULL,
	LastDate DATETIME NULL,
	MRIUserID CHAR(20) NULL,
	[Source] CHAR(2) NOT NULL,
	IsActive BIT NOT NULL,
	FunctionalDepartmentId INT NULL,
	UpdatedDate DATETIME NOT NULL
)

CREATE TABLE #JobCode(
	ImportKey INT NOT NULL,
	JobCode VARCHAR(15) NOT NULL,
	[Source] CHAR(2) NOT NULL,
	JobType VARCHAR(15) NOT NULL,
	BuildingRef VARCHAR(6) NULL,
	LastDate DATETIME NOT NULL,
	IsActive BIT NOT NULL,
	Reference VARCHAR(50) NOT NULL,
	MRIUserID CHAR(20) NOT NULL,
	[Description] VARCHAR(50) NULL,
	StartDate DATETIME NULL,
	EndDate DATETIME NULL,
	AccountingComment VARCHAR(5000) NULL,
	PMComment VARCHAR(5000) NULL,
	LeaseRef VARCHAR(20) NULL,
	Area INT NULL,
	AreaType VARCHAR(20) NULL,
	RMPropertyRef VARCHAR(6) NULL,
	IsAssumption BIT NOT NULL,
	FunctionalDepartmentId INT NULL
) 

CREATE TABLE #ActivityType(
	ImportKey INT NOT NULL,
	ActivityTypeId INT NOT NULL,
	ActivityTypeCode VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	GLSuffix char(2) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

CREATE TABLE #GLGlobalAccount(
	ImportKey INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	ActivityTypeId INT NULL,
	GLStatutoryTypeId INT NULL,
	ParentGLGlobalAccountId INT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(150) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsGR BIT NOT NULL,
	IsGbs BIT NOT NULL,
	IsRegionalOverheadCost BIT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLGlobalAccountGLAccount( -- used to be #GlAccountMapping in GDM 1.2
	ImportKey INT NOT NULL,
	GLGlobalAccountGLAccountId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	Code VARCHAR(12) NOT NULL,
	[Name] NVARCHAR(50) NOT NULL,
	[Description] NVARCHAR(255) NOT NULL,
	PreGlobalAccountCode VARCHAR(50) NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #OriginatingRegionCorporateEntity( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	OriginatingRegionCorporateEntityId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	CorporateEntityCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL	
)

CREATE TABLE #OriginatingRegionPropertyDepartment( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	OriginatingRegionPropertyDepartmentId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	PropertyDepartmentCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL	
)

CREATE TABLE #PropertyFundMapping(
	ImportKey INT NOT NULL,
	PropertyFundMappingId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode char(2) NOT NULL,
	PropertyFundCode VARCHAR(8) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL,
	ActivityTypeId INT NULL
)

CREATE TABLE #PropertyFund( -- GDM 2.0 change
	ImportKey INT NOT NULL,
	PropertyFundId INT NOT NULL,
	RelatedFundId INT NULL,
	EntityTypeId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	BudgetOwnerStaffId INT NOT NULL,
	RegionalOwnerStaffId INT NOT NULL,
	DefaultGLTranslationSubTypeId INT NULL,
	[Name] VARCHAR(100) NOT NULL,
	IsReportingEntity BIT NOT NULL,
	IsPropertyFund BIT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #ReportingEntityCorporateDepartment( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	ReportingEntityCorporateDepartmentId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	CorporateDepartmentCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsDeleted BIT NOT NULL,
)

CREATE TABLE #ReportingEntityPropertyEntity( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	ReportingEntityPropertyEntityId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	PropertyEntityCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsDeleted BIT NOT NULL
)


CREATE TABLE #AllocationSubRegion(
	ImportKey INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	ProjectCodePortion VARCHAR(2) NOT NULL,
	AllocationRegionGlobalRegionId INT NULL,
	DefaultCurrencyCode CHAR(3) NOT NULL,
	CountryId INT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #JobCodeFunctionalDepartment(
	FunctionalDepartmentKey INT NOT NULL,
	ReferenceCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentName VARCHAR(50) NOT NULL,
	SubFunctionalDepartmentCode VARCHAR(20) NOT NULL,
	SubFunctionalDepartmentName VARCHAR(100) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL
)

CREATE TABLE #ParentFunctionalDepartment(
	FunctionalDepartmentKey INT NOT NULL,
	ReferenceCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentName VARCHAR(50) NOT NULL,
	SubFunctionalDepartmentCode VARCHAR(20) NOT NULL,
	SubFunctionalDepartmentName VARCHAR(100) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL
)

-- #FunctionalDepartment

INSERT INTO #FunctionalDepartment(
	ImportKey,
	FunctionalDepartmentId,
	[Name],
	Code,
	IsActive,
	InsertedDate,
	UpdatedDate,
	GlobalCode
)
SELECT
	Fd.ImportKey,
	Fd.FunctionalDepartmentId,
	Fd.Name,
	Fd.Code,
	Fd.IsActive,
	Fd.InsertedDate,
	Fd.UpdatedDate,
	Fd.GlobalCode
FROM
	HR.FunctionalDepartment Fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FdA ON
		FdA.ImportKey = Fd.ImportKey

-- #Department

INSERT INTO #Department(
	ImportKey,
	Department,
	[Description],
	LastDate,
	MRIUserID,
	[Source],
	IsActive,
	FunctionalDepartmentId,
	UpdatedDate
)
SELECT
	Dpt.ImportKey,
	Dpt.Department,
	Dpt.[Description],
	Dpt.LastDate,
	Dpt.MRIUserID,
	Dpt.[Source],
	Dpt.IsActive,
	Dpt.FunctionalDepartmentId,
	Dpt.UpdatedDate
FROM GACS.Department Dpt
	INNER JOIN GACS.DepartmentActive(@DataPriorToDate) DptA ON
		DptA.ImportKey = Dpt.ImportKey
WHERE
	Dpt.FunctionalDepartmentId IS NOT NULL

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #Department (Department, [Source])

-- #JobCode

INSERT INTO #JobCode(
	ImportKey,
	JobCode,
	[Source],
	JobType,
	BuildingRef,
	LastDate,
	IsActive,
	Reference,
	MRIUserID,
	[Description],
	StartDate,
	EndDate,
	AccountingComment,
	PMComment,
	LeaseRef,
	Area,
	AreaType,
	RMPropertyRef,
	IsAssumption,
	FunctionalDepartmentId
)
SELECT
	Jc.ImportKey,
	Jc.JobCode,
	Jc.[Source],
	Jc.JobType,
	Jc.BuildingRef,
	Jc.LastDate,
	Jc.IsActive,
	Jc.Reference,
	Jc.MRIUserID,
	Jc.[Description],
	Jc.StartDate,
	Jc.EndDate,
	Jc.AccountingComment,
	Jc.PMComment,
	Jc.LeaseRef,
	Jc.Area,
	Jc.AreaType,
	Jc.RMPropertyRef,
	Jc.IsAssumption,
	Jc.FunctionalDepartmentId
FROM
	GACS.JobCode Jc
	INNER JOIN GACS.JobCodeActive(@DataPriorToDate) JcA ON
		JcA.ImportKey = Jc.ImportKey
WHERE
	Jc.FunctionalDepartmentId IS NOT NULL

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #JobCode (JobCode, [Source])

-- #ActivityType

INSERT INTO #ActivityType(
	ImportKey,
	ActivityTypeId,
	ActivityTypeCode,
	[Name],
	GLSuffix,
	InsertedDate,
	UpdatedDate
)
SELECT
	At.ImportKey,
	At.ActivityTypeId,
	At.ActivityTypeCode,
	At.Name,
	At.GLSuffix,
	At.InsertedDate,
	At.UpdatedDate
FROM
	Gdm.ActivityType At
	INNER JOIN Gdm.ActivityTypeActive(@DataPriorToDate) Ata ON
		Ata.ImportKey = At.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ActivityType (ActivityTypeId)

-- #GLGlobalAccount

INSERT INTO #GLGlobalAccount(
	ImportKey,
	GLGlobalAccountId,
	ActivityTypeId,
	GLStatutoryTypeId,
	ParentGLGlobalAccountId,
	Code,
	[Name],
	[Description],
	IsGR,
	IsGbs,
	IsRegionalOverheadCost,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	GLA.ImportKey,
	GLA.GLGlobalAccountId,
	GLA.ActivityTypeId,
	GLA.GLStatutoryTypeId,
	GLA.ParentGLGlobalAccountId,
	GLA.Code,
	GLA.[Name], 
	GLA.[Description],
	GLA.IsGR,
	GLA.IsGbs,
	GLA.IsRegionalOverheadCost,
	GLA.IsActive,
	GLA.InsertedDate,
	GLA.UpdatedDate,
	GLA.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccount GLA
	INNER JOIN Gdm.GLGlobalAccountActive(@DataPriorToDate) GLAA ON
		GLAA.ImportKey = GLA.ImportKey
	
CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #GLGlobalAccount (GLGlobalAccountId, ActivityTypeId)

-- #GLGlobalAccountGLAccount

INSERT INTO #GLGlobalAccountGLAccount(
	ImportKey,
	GLGlobalAccountGLAccountId,
	GLGlobalAccountId,
	SourceCode,
	Code,
	[Name],
	[Description],
	PreGlobalAccountCode,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	GAGLA.ImportKey,
	GAGLA.GLGlobalAccountGLAccountId,
	GAGLA.GLGlobalAccountId,
	GAGLA.SourceCode,
	GAGLA.Code,
	GAGLA.[Name],
	GAGLA.[Description],
	GAGLA.PreGlobalAccountCode,
	GAGLA.IsActive,
	GAGLA.InsertedDate,
	GAGLA.UpdatedDate,
	GAGLA.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccountGLAccount GAGLA
	INNER JOIN Gdm.GLGlobalAccountGLAccountActive(@DataPriorToDate) GlA ON
		GlA.ImportKey = GAGLA.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #GLGlobalAccountGLAccount (Code, SourceCode, GLGlobalAccountGLAccountId)

-- #PropertyFundMapping

INSERT INTO #PropertyFundMapping(
	ImportKey,
	PropertyFundMappingId,
	PropertyFundId,
	SourceCode,
	PropertyFundCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted,
	ActivityTypeId)
SELECT
	Pfm.ImportKey,
	Pfm.PropertyFundMappingId,
	Pfm.PropertyFundId,
	Pfm.SourceCode,
	Pfm.PropertyFundCode,
	Pfm.InsertedDate,
	Pfm.UpdatedDate,
	Pfm.IsDeleted,
	Pfm.ActivityTypeId
FROM
	Gdm.PropertyFundMapping Pfm 
	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PfmA ON
		PfmA.ImportKey = Pfm.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #PropertyFundMapping (PropertyFundCode, SourceCode, IsDeleted, PropertyFundId, PropertyFundMappingId, ActivityTypeId)

-- #OriginatingRegionCorporateEntity

INSERT INTO #OriginatingRegionCorporateEntity(
	ImportKey,
	OriginatingRegionCorporateEntityId,
	GlobalRegionId,
	CorporateEntityCode,
	SourceCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted
)
SELECT
	ORCE.ImportKey,
	ORCE.OriginatingRegionCorporateEntityId,
	ORCE.GlobalRegionId,
	ORCE.CorporateEntityCode,
	ORCE.SourceCode,
	ORCE.InsertedDate,
	ORCE.UpdatedDate,
	ORCE.IsDeleted	
FROM
	Gdm.OriginatingRegionCorporateEntity ORCE
	INNER JOIN Gdm.OriginatingRegionCorporateEntityActive (@DataPriorToDate) ORCEA ON
		ORCEA.ImportKey = ORCE.ImportKey

-- #OriginatingRegionPropertyDepartment

INSERT INTO #OriginatingRegionPropertyDepartment(
	ImportKey,
	OriginatingRegionPropertyDepartmentId,
	GlobalRegionId,
	PropertyDepartmentCode,
	SourceCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted
)
SELECT
	ORPD.ImportKey,
	ORPD.OriginatingRegionPropertyDepartmentId,
	ORPD.GlobalRegionId,
	ORPD.PropertyDepartmentCode,
	ORPD.SourceCode,
	ORPD.InsertedDate,
	ORPD.UpdatedDate,
	ORPD.IsDeleted
FROM
	Gdm.OriginatingRegionPropertyDepartment ORPD
	INNER JOIN Gdm.OriginatingRegionPropertyDepartmentActive(@DataPriorToDate) ORPDA ON
		ORPDA.ImportKey = ORPD.ImportKey

-- #PropertyFund

INSERT INTO #PropertyFund(
	ImportKey,
	PropertyFundId,
	RelatedFundId,
	EntityTypeId,
	AllocationSubRegionGlobalRegionId,
	BudgetOwnerStaffId,
	RegionalOwnerStaffId,
	DefaultGLTranslationSubTypeId,
	[Name],
	IsReportingEntity,
	IsPropertyFund,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	PF.ImportKey,
	PF.PropertyFundId,
	PF.RelatedFundId,
	PF.EntityTypeId,
	PF.AllocationSubRegionGlobalRegionId,
	PF.BudgetOwnerStaffId,
	PF.RegionalOwnerStaffId,
	PF.DefaultGLTranslationSubTypeId,
	PF.[Name],
	PF.IsReportingEntity,
	PF.IsPropertyFund,
	PF.IsActive,
	PF.InsertedDate,
	PF.UpdatedDate,
	PF.UpdatedByStaffId
FROM
	Gdm.PropertyFund PF 
	INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PFA ON
		PFA.ImportKey = PF.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #PropertyFund (PropertyFundId)

-- #ReportingEntityCorporateDepartment

INSERT INTO	#ReportingEntityCorporateDepartment(
	ImportKey,
	ReportingEntityCorporateDepartmentId,
	PropertyFundId,
	SourceCode,
	CorporateDepartmentCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsDeleted
)
SELECT
	RECD.ImportKey,
	RECD.ReportingEntityCorporateDepartmentId,
	RECD.PropertyFundId,
	RECD.SourceCode,
	RECD.CorporateDepartmentCode,
	RECD.InsertedDate,
	RECD.UpdatedDate,
	RECD.UpdatedByStaffId,
	RECD.IsDeleted
FROM
	Gdm.ReportingEntityCorporateDepartment RECD
	INNER JOIN Gdm.ReportingEntityCorporateDepartmentActive(@DataPriorToDate) RECDA ON
		RECDA.ImportKey = RECD.ImportKey

-- #ReportingEntityPropertyEntity

INSERT INTO #ReportingEntityPropertyEntity(
	ImportKey,
	ReportingEntityPropertyEntityId,
	PropertyFundId,
	SourceCode,
	PropertyEntityCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsDeleted
)
SELECT
	REPE.ImportKey,
	REPE.ReportingEntityPropertyEntityId,
	REPE.PropertyFundId,
	REPE.SourceCode,
	REPE.PropertyEntityCode,
	REPE.InsertedDate,
	REPE.UpdatedDate,
	REPE.UpdatedByStaffId,
	REPE.IsDeleted
FROM
	Gdm.ReportingEntityPropertyEntity REPE
	INNER JOIN Gdm.ReportingEntityPropertyEntityActive(@DataPriorToDate) REPEA ON
		REPEA.ImportKey = REPE.ImportKey

-- #AllocationSubRegion

INSERT INTO #AllocationSubRegion(
	ImportKey,
	AllocationSubRegionGlobalRegionId,
	Code,
	[Name],
	ProjectCodePortion,
	AllocationRegionGlobalRegionId,
	DefaultCurrencyCode,
	CountryId,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	ASR.ImportKey,
	ASR.AllocationSubRegionGlobalRegionId,
	ASR.Code,
	ASR.[Name],
	ASR.ProjectCodePortion,
	ASR.AllocationRegionGlobalRegionId,
	ASR.DefaultCurrencyCode,
	ASR.CountryId,
	ASR.IsActive,
	ASR.InsertedDate,
	ASR.UpdatedDate,
	ASR.UpdatedByStaffId
FROM
	Gdm.AllocationSubRegion ASR
	INNER JOIN	Gdm.AllocationSubRegionActive(@DataPriorToDate) ASRA ON ASRA.ImportKey = ASR.ImportKey

-- #JobCodeFunctionalDepartment
INSERT INTO #JobCodeFunctionalDepartment(
	FunctionalDepartmentKey,
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	StartDate,
	EndDate
)
SELECT
	FunctionalDepartmentKey,
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	StartDate,
	EndDate
FROM
	GrReporting.dbo.FunctionalDepartment
WHERE
	FunctionalDepartmentCode <> SubFunctionalDepartmentCode

-- Parent Level
INSERT INTO #ParentFunctionalDepartment(
	FunctionalDepartmentKey,
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	StartDate,
	EndDate
)
SELECT
	FunctionalDepartmentKey,
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	StartDate,
	EndDate
FROM
	GrReporting.dbo.FunctionalDepartment
WHERE (
		FunctionalDepartmentCode = SubFunctionalDepartmentCode
		OR 
		ReferenceCode = FunctionalDepartmentCode+'':UNKNOWN''
	  )

-----------------------------------------------------------------------------------------------------------

CREATE TABLE #GLTranslationType(
	ImportKey INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLTranslationSubType(
	ImportKey INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsGRDefault BIT NOT NULL
)

CREATE TABLE #GLGlobalAccountTranslationType(
	ImportKey INT NOT NULL,
	GLGlobalAccountTranslationTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLGlobalAccountTranslationSubType(
	ImportKey INT NOT NULL,
	GLGlobalAccountTranslationSubTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	PostingPropertyGLAccountCode VARCHAR(14) NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMajorCategory(
	ImportKey INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMinorCategory(
	ImportKey INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

-- #GLGlobalAccountTranslationType

INSERT INTO #GLGlobalAccountTranslationType(
	ImportKey,
	GLGlobalAccountTranslationTypeId,
	GLGlobalAccountId,
	GLTranslationTypeId,
	GLAccountTypeId,
	GLAccountSubTypeId,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	GATT.ImportKey,
	GATT.GLGlobalAccountTranslationTypeId,
	GATT.GLGlobalAccountId,
	GATT.GLTranslationTypeId,
	GATT.GLAccountTypeId,
	GATT.GLAccountSubTypeId,
	GATT.IsActive,
	GATT.InsertedDate,
	GATT.UpdatedDate,
	GATT.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccountTranslationType GATT
	INNER JOIN Gdm.GLGlobalAccountTranslationTypeActive(@DataPriorToDate) GATTA ON
		GATTA.ImportKey = GATT.ImportKey

-- #GLGlobalAccountTranslationSubType

INSERT INTO #GLGlobalAccountTranslationSubType(
	ImportKey,
	GLGlobalAccountTranslationSubTypeId,
	GLGlobalAccountId,
	GLTranslationSubTypeId,
	GLMinorCategoryId,
	PostingPropertyGLAccountCode,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	GATST.ImportKey,
	GATST.GLGlobalAccountTranslationSubTypeId,
	GATST.GLGlobalAccountId,
	GATST.GLTranslationSubTypeId,
	GATST.GLMinorCategoryId,
	GATST.PostingPropertyGLAccountCode,
	GATST.IsActive,
	GATST.InsertedDate,
	GATST.UpdatedDate,
	GATST.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccountTranslationSubType GATST
	INNER JOIN Gdm.GLGlobalAccountTranslationSubTypeActive(@DataPriorToDate) GATSTA ON
		GATSTA.ImportKey = GATST.ImportKey

-- #GLTranslationType

INSERT INTO #GLTranslationType(
	ImportKey,
	GLTranslationTypeId,
	Code,
	[Name],
	[Description],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	TT.ImportKey,
	TT.GLTranslationTypeId,
	TT.Code,
	TT.[Name],
	TT.[Description],
	TT.IsActive,
	TT.InsertedDate,
	TT.UpdatedDate,
	TT.UpdatedByStaffId
FROM
	Gdm.GLTranslationType TT
	INNER JOIN Gdm.GLTranslationTypeActive(@DataPriorToDate) TTA ON
		TTA.ImportKey = TT.ImportKey

-- #GLTranslationSubType

INSERT INTO #GLTranslationSubType(
	ImportKey,
	GLTranslationSubTypeId,
	GLTranslationTypeId,
	Code,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsGRDefault
)
SELECT
	TST.ImportKey,
	TST.GLTranslationSubTypeId,
	TST.GLTranslationTypeId,
	TST.Code,
	TST.[Name],
	TST.IsActive,
	TST.InsertedDate,
	TST.UpdatedDate,
	TST.UpdatedByStaffId,
	TST.IsGRDefault
FROM
	Gdm.GLTranslationSubType TST
	INNER JOIN Gdm.GLTranslationSubTypeActive(@DataPriorToDate) TSTA ON
		TSTA.ImportKey = TST.ImportKey

-- #GLMajorCategory

INSERT INTO #GLMajorCategory(
	ImportKey,
	GLMajorCategoryId,
	GLTranslationSubTypeId,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	MajC.ImportKey,
	MajC.GLMajorCategoryId,
	MajC.GLTranslationSubTypeId,
	MajC.[Name],
	MajC.IsActive,
	MajC.InsertedDate,
	MajC.UpdatedDate,
	MajC.UpdatedByStaffId
FROM
	Gdm.GLMajorCategory MajC
	INNER JOIN Gdm.GLMajorCategoryActive(@DataPriorToDate) MajCA ON
		MajC.ImportKey = MajCA.ImportKey

-- #GLMinorCategory

INSERT INTO #GLMinorCategory(
	ImportKey,
	GLMinorCategoryId,
	GLMajorCategoryId,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	Minc.ImportKey,
	Minc.GLMinorCategoryId,
	Minc.GLMajorCategoryId,
	Minc.[Name],
	Minc.IsActive,
	Minc.InsertedDate,
	Minc.UpdatedDate,
	Minc.UpdatedByStaffId
FROM
	Gdm.GLMinorCategory MinC
	INNER JOIN Gdm.GLMinorCategoryActive(@DataPriorToDate) MinCA ON
		MinCA.ImportKey = MinC.ImportKey

-- drop table #ProfitabilityActual

PRINT ''Completed inserting Active records INTo temp table''
PRINT CONVERT(VARCHAR(27), getdate(), 121)
-- drop table #ProfitabilityActual

CREATE TABLE #ProfitabilityActual(
	CalendarKey INT NOT NULL,
	GlAccountKey INT NOT NULL,
	SourceKey INT NOT NULL,
	FunctionalDepartmentKey INT NOT NULL,
	ReimbursableKey INT NOT NULL,
	ActivityTypeKey INT NOT NULL,
	OriginatingRegionKey INT NOT NULL,
	AllocationRegionKey INT NOT NULL,
	PropertyFundKey INT NOT NULL,
	ReferenceCode VARCHAR(100) NOT NULL,
	LocalCurrencyKey INT NOT NULL,
	LocalActual MONEY NOT NULL,
	ProfitabilityActualSourceTableId INT NOT NULL,
	
	EUCorporateGlAccountCategoryKey INT NULL,
	EUPropertyGlAccountCategoryKey INT NULL,
	EUFundGlAccountCategoryKey INT NULL,

	USPropertyGlAccountCategoryKey INT NULL,
	USCorporateGlAccountCategoryKey INT NULL,
	USFundGlAccountCategoryKey INT NULL,

	GlobalGlAccountCategoryKey INT NULL,
	DevelopmentGlAccountCategoryKey INT NULL,
	
	EntryDate DATETIME NULL,
	[User] NVARCHAR(20) NULL,
	[Description] NCHAR(60) NULL,
	AdditionalDescription NVARCHAR(4000) NULL
) 

INSERT INTO #ProfitabilityActual(
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	OriginatingRegionKey,
	AllocationRegionKey,
	PropertyFundKey,
	ReferenceCode,
	LocalCurrencyKey,
	LocalActual,
	ProfitabilityActualSourceTableId,
	EntryDate,
	[User],
	[Description],
	AdditionalDescription
)

SELECT 
	DATEDIFF(dd, ''1900-01-01'', LEFT(Gl.PERIOD, 4)+''-''+RIGHT(Gl.PERIOD, 2)+''-01'') CalendarKey,
	CASE WHEN GrGa.GlAccountKey IS NULL THEN @GlAccountKeyUnknown ELSE GrGa.GlAccountKey END GlAccountKey,
	CASE WHEN GrSc.SourceKey IS NULL THEN @SourceKeyUnknown ELSE GrSc.SourceKey END SourceKey,
	CASE WHEN ISNULL(GrFdm1.FunctionalDepartmentKey, GrFdm2.FunctionalDepartmentKey) IS NULL THEN @FunctionalDepartmentKeyUnknown ELSE ISNULL(GrFdm1.FunctionalDepartmentKey, GrFdm2.FunctionalDepartmentKey) END FunctionalDepartmentKey,
	CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKeyUnknown ELSE GrRi.ReimbursableKey END ReimbursableKey,
	CASE WHEN GrAt.ActivityTypeKey IS NULL THEN @ActivityTypeKeyUnknown ELSE GrAt.ActivityTypeKey END ActivityTypeKey,
	CASE WHEN OrR.OriginatingRegionKey IS NULL THEN @OriginatingRegionKeyUnknown ELSE OrR.OriginatingRegionKey END OriginatingRegionKey,
	CASE WHEN GrAr.AllocationRegionKey IS NULL THEN @AllocationRegionKeyUnknown ELSE GrAr.AllocationRegionKey END AllocationRegionKey,
	CASE WHEN GrPf.PropertyFundKey IS NULL THEN @PropertyFundKeyUnknown ELSE GrPf.PropertyFundKey END PropertyFundKey,
	Gl.SourcePrimaryKey,
	Cu.CurrencyKey,
	Gl.LocalActual,
	Gl.SourceTableId,
	Gl.EnterDate,
	Gl.[User],
	Gl.[Description],
	Gl.AdditionalDescription

FROM
	#ProfitabilityGeneralLedger Gl
		
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		GrSc.SourceCode = Gl.SourceCode

	LEFT OUTER JOIN GrReporting.dbo.Currency Cu ON
		Cu.CurrencyCode = Gl.LocalCurrency

	LEFT OUTER JOIN #JobCode Jc ON --The JobCodes is FunctionalDepartment in Corp
		Jc.JobCode = Gl.JobCode AND
		Jc.Source = Gl.SourceCode AND
		GrSc.IsCorporate = ''YES''
	
	LEFT OUTER JOIN #Department Dp ON --The Department (Region+FunctionalDept) is FunctionalDepartment in Prop
		Dp.Department = LTRIM(RTRIM(Gl.OriginatingRegionCode)) + LTRIM(RTRIM(Gl.FunctionalDepartmentCode)) AND
		Dp.Source = Gl.SourceCode AND
		GrSc.IsProperty = ''YES''

	LEFT OUTER JOIN #FunctionalDepartment Fd ON
		Fd.FunctionalDepartmentId = ISNULL(Jc.FunctionalDepartmentId, Dp.FunctionalDepartmentId)

	LEFT OUTER JOIN #JobCodeFunctionalDepartment GrFdm1 ON --Detail/Sub Level : JobCode
		ISNULL(Gl.LastDate, EnterDate)  BETWEEN GrFdm1.StartDate AND GrFdm1.EndDate AND
		GrFdm1.ReferenceCode = CASE WHEN Gl.JobCode IS NOT NULL THEN Fd.GlobalCode + '':''+ LTRIM(RTRIM(Gl.JobCode))
									ELSE Fd.GlobalCode + '':UNKNOWN'' END

	--Parent Level: Determine the default FunctionalDepartment (FunctionalDepartment:XX, JobCode:UNKNOWN)
	--that will be used, should the JobCode not match, but the FunctionalDepartment does match
	LEFT OUTER JOIN #ParentFunctionalDepartment GrFdm2 ON
		ISNULL(Gl.LastDate, EnterDate)  BETWEEN GrFdm2.StartDate AND GrFdm2.EndDate AND
		GrFdm2.ReferenceCode = Fd.GlobalCode +'':'' 
		
	LEFT OUTER JOIN #GLGlobalAccountGLAccount GAGLA ON --#GlAccountMapping Gam
		GAGLA.Code = Gl.GlAccountCode AND
		GAGLA.SourceCode = Gl.SourceCode AND
		GAGLA.IsActive = 1
		
	LEFT OUTER JOIN GrReporting.dbo.GlAccount GrGa ON
		GrGa.GLGlobalAccountId = GAGLA.GLGlobalAccountId AND --Gam.GlobalGlAccountId AND
		ISNULL(Gl.LastDate, EnterDate) BETWEEN GrGa.StartDate AND GrGa.EndDate

	LEFT OUTER JOIN #GLGlobalAccount GA ON --#GlobalGlAccount Glo
		GA.GLGlobalAccountId = GAGLA.GLGlobalAccountId
		--ON Glo.GlobalGlAccountId = Gam.GlobalGlAccountId

	LEFT OUTER JOIN #ActivityType At ON
		At.ActivityTypeId = GA.ActivityTypeId

	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		GrAt.ActivityTypeId = At.ActivityTypeId AND
		ISNULL(Gl.LastDate, EnterDate) BETWEEN GrAt.StartDate AND GrAt.EndDate
		
	LEFT OUTER JOIN #PropertyFundMapping Pfm ON
		Pfm.PropertyFundCode = LTRIM(RTRIM(Gl.PropertyFundCode)) AND
		Pfm.SourceCode = Gl.SourceCode AND
		Pfm.IsDeleted = 0 AND
		(
			(GrSc.IsProperty = ''YES'' AND Pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = ''YES'' AND Pfm.ActivityTypeId = GA.ActivityTypeId)
				OR
				(GrSc.IsCorporate = ''YES'' AND Pfm.ActivityTypeId IS NULL AND GA.ActivityTypeId IS NULL)
			)
		) AND
		(Gl.Period < ''201007'')

	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(Gl.PropertyFundCode)) AND
		RECD.SourceCode = Gl.SourceCode AND
		Gl.Period >= ''201007'' AND			   
		RECD.IsDeleted = 0
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = ''YES'' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(Gl.PropertyFundCode)) AND
		REPE.SourceCode = Gl.SourceCode AND
		Gl.Period >= ''201007'' AND
		REPE.IsDeleted = 0			   
	
	LEFT OUTER JOIN #OriginatingRegionCorporateEntity ORCE ON
		ORCE.CorporateEntityCode = Gl.OriginatingRegionCode AND
		ORCE.SourceCode = Gl.SourceCode AND
		ORCE.IsDeleted = 0
		   
	LEFT OUTER JOIN #OriginatingRegionPropertyDepartment ORPD ON
		ORPD.PropertyDepartmentCode = Gl.OriginatingRegionCode AND
		ORPD.SourceCode = Gl.SourceCode AND
		ORPD.IsDeleted = 0

	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion OrR ON
		OrR.GlobalRegionId = ISNULL(ORCE.GlobalRegionId, ORPD.GlobalRegionId) AND
		--OrR.GlobalRegionId = ORPD.GlobalRegionId AND
		ISNULL(Gl.LastDate, EnterDate) BETWEEN OrR.StartDate AND OrR.EndDate
	
	LEFT OUTER JOIN #PropertyFund PF ON
		PF.PropertyFundId =
			CASE
				WHEN Gl.Period < ''201007'' THEN Pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = ''YES'' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END
			
	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		GrPf.PropertyFundId = PF.PropertyFundId AND 
		ISNULL(Gl.LastDate, EnterDate) BETWEEN GrPf.StartDate AND GrPf.EndDate

	LEFT OUTER JOIN #AllocationSubRegion ASR ON
		PF.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId
		
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		GrAr.GlobalRegionId = ASR.AllocationSubRegionGlobalRegionId AND
		--ON GrAr.GlobalRegionId = Arm.GlobalRegionId AND
		ISNULL(Gl.LastDate, EnterDate) BETWEEN GrAr.StartDate AND GrAr.EndDate

	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		GrRi.ReimbursableCode = CASE WHEN Gl.NetTSCost = ''Y'' THEN ''NO'' ELSE ''YES'' END
			
--This is NOT needed for the temp table selects at the top already filter the inserts!
--/*Where ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate*/

PRINT ''Completed converting all transactional data to star schema keys''
PRINT CONVERT(VARCHAR(27), getdate(), 121)

-----------------------------------------------------------------------------------------------------------
--GlobalGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	GlobalGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM #ProfitabilityActual Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = ''GL'' AND -- filter on Code because it is indexed and guaranteed to be unique
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND -- this join isn''t necessary but including it for completeness
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT ''Completed converting all GlobalGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
/*
-- EUCorporateGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	EUCorporateGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUCorporateGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END 
FROM
	#ProfitabilityActual Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = ''EU CORP'' AND -- filter on Code because it is indexed and guaranteed to be unique
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND -- this join isn''t necessary but including it for completeness
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))
		
			
PRINT ''Completed converting all EUCorporateGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--EUPropertyGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	EUPropertyGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUPropertyGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityActual Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = ''EU PROP'' AND -- filter on Code because it is indexed and guaranteed to be unique
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND -- this join isn''t necessary but including it for completeness
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT ''Completed converting all EUPropertyGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)


--EUFundGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	EUFundGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUFundGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityActual Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = ''EU FUND'' AND -- filter on Code because it is indexed and guaranteed to be unique
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND -- this join isn''t necessary but including it for completeness
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))
	
PRINT ''Completed converting all EUFundGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USPropertyGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	USPropertyGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USPropertyGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityActual Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = ''US PROP'' AND -- filter on Code because it is indexed and guaranteed to be unique
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND -- this join isn''t necessary but including it for completeness
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT ''Completed converting all USPropertyGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USCorporateGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	USCorporateGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USCorporateGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
From #ProfitabilityActual Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = ''US CORP'' AND -- filter on Code because it is indexed and guaranteed to be unique
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND -- this join isn''t necessary but including it for completeness
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT ''Completed converting all USCorporateGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USFundGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	USFundGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USFundGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityActual Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = ''US FUND'' AND -- filter on Code because it is indexed and guaranteed to be unique
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND -- this join isn''t necessary but including it for completeness
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT ''Completed converting all USFundGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

		


--DevelopmentGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	DevelopmentGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @DevelopmentGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM #ProfitabilityActual Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = ''DEV'' AND -- filter on Code because it is indexed and guaranteed to be unique
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND -- this join isn''t necessary but including it for completeness
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT ''Completed converting all DevelopmentGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
*/
CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProfitabilityActual (SourceKey, ReferenceCode)
PRINT ''Completed building clustered index on #ProfitabilityActual''
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--Transfer the updated rows
UPDATE
	GrReporting.dbo.ProfitabilityActual
SET	
	CalendarKey						 = Pro.CalendarKey,
	GlAccountKey					 = Pro.GlAccountKey,
	FunctionalDepartmentKey			 = Pro.FunctionalDepartmentKey,
	ReimbursableKey					 = Pro.ReimbursableKey,
	ActivityTypeKey					 = Pro.ActivityTypeKey,
	OriginatingRegionKey			 = Pro.OriginatingRegionKey,
	AllocationRegionKey				 = Pro.AllocationRegionKey,
	PropertyFundKey					 = Pro.PropertyFundKey,
	LocalCurrencyKey				 = Pro.LocalCurrencyKey,
	LocalActual						 = Pro.LocalActual,
	ProfitabilityActualSourceTableId = Pro.ProfitabilityActualSourceTableId,
	
	EUCorporateGlAccountCategoryKey	 = @EUCorporateGlAccountCategoryKeyUnknown, --Pro.EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey	 = @EUPropertyGlAccountCategoryKeyUnknown, --Pro.EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey		 = @EUFundGlAccountCategoryKeyUnknown, --Pro.EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey	 = @USPropertyGlAccountCategoryKeyUnknown, --Pro.USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey	 = @USCorporateGlAccountCategoryKeyUnknown, --Pro.USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey		 = @USFundGlAccountCategoryKeyUnknown, --Pro.USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey		 = Pro.GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey	 = @DevelopmentGlAccountCategoryKeyUnknown, --Pro.DevelopmentGlAccountCategoryKey

	
	EntryDate						 = Pro.EntryDate,
	[User]							 = Pro.[User],
	[Description]					 = Pro.[Description],
	AdditionalDescription			 = Pro.AdditionalDescription
FROM
	#ProfitabilityActual Pro
WHERE
	ProfitabilityActual.SourceKey = Pro.SourceKey AND
	ProfitabilityActual.ReferenceCode = Pro.ReferenceCode

PRINT ''Rows Updated in Profitability:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
	
--Transfer the new rows
INSERT INTO
	GrReporting.dbo.ProfitabilityActual (CalendarKey, GlAccountKey, FunctionalDepartmentKey, ReimbursableKey, ActivityTypeKey, SourceKey,
	OriginatingRegionKey, AllocationRegionKey, PropertyFundKey, ReferenceCode, LocalCurrencyKey, LocalActual, ProfitabilityActualSourceTableId,
	EUCorporateGlAccountCategoryKey, EUPropertyGlAccountCategoryKey, EUFundGlAccountCategoryKey, USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey, USFundGlAccountCategoryKey, GlobalGlAccountCategoryKey, DevelopmentGlAccountCategoryKey, EntryDate, [User],
	[Description], AdditionalDescription )
	
SELECT
	Pro.CalendarKey,
	Pro.GlAccountKey,
	Pro.FunctionalDepartmentKey,
	Pro.ReimbursableKey,
	Pro.ActivityTypeKey,
	Pro.SourceKey,
	Pro.OriginatingRegionKey,
	Pro.AllocationRegionKey,
	Pro.PropertyFundKey,
	Pro.ReferenceCode,
	Pro.LocalCurrencyKey,
	Pro.LocalActual,
	Pro.ProfitabilityActualSourceTableId,
	
	@EUCorporateGlAccountCategoryKeyUnknown, --Pro.EUCorporateGlAccountCategoryKey,
	@EUPropertyGlAccountCategoryKeyUnknown, --Pro.EUPropertyGlAccountCategoryKey,
	@EUFundGlAccountCategoryKeyUnknown, --Pro.EUFundGlAccountCategoryKey,

	@USPropertyGlAccountCategoryKeyUnknown, --Pro.USPropertyGlAccountCategoryKey,
	@USCorporateGlAccountCategoryKeyUnknown, ----Pro.USCorporateGlAccountCategoryKey,
	@USFundGlAccountCategoryKeyUnknown, --Pro.USFundGlAccountCategoryKey,

	Pro.GlobalGlAccountCategoryKey,
	@DevelopmentGlAccountCategoryKeyUnknown, --Pro.DevelopmentGlAccountCategoryKey
	
	Pro.EntryDate,
	Pro.[User],
	Pro.[Description],
	Pro.AdditionalDescription
											
FROM
	#ProfitabilityActual Pro
	
	LEFT OUTER JOIN GrReporting.dbo.ProfitabilityActual ProExists
		ON ProExists.SourceKey = Pro.SourceKey AND
		   ProExists.ReferenceCode = Pro.ReferenceCode
		   
WHERE
	ProExists.SourceKey IS NULL

PRINT ''Rows Inserted in Profitability:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--MRI should never delete rows from the GeneralLedger....
--hence we should never have to delete records
--PRINT ''Orphan Rows Delete in Profitability:''+CONVERT(char(10),@@rowcount)
--PRINT CONVERT(VARCHAR(27), getdate(), 121)

DROP TABLE #ProfitabilityGeneralLedger
DROP TABLE #FunctionalDepartment
DROP TABLE #Department
DROP TABLE #JobCode
DROP TABLE #ActivityType
DROP TABLE #GLGlobalAccount
DROP TABLE #GLGlobalAccountGLAccount
DROP TABLE #OriginatingRegionCorporateEntity
DROP TABLE #OriginatingRegionPropertyDepartment
DROP TABLE #PropertyFundMapping
DROP TABLE #PropertyFund
DROP TABLE #ReportingEntityCorporateDepartment
DROP TABLE #ReportingEntityPropertyEntity
DROP TABLE #AllocationSubRegion
DROP TABLE #JobCodeFunctionalDepartment
DROP TABLE #ParentFunctionalDepartment
DROP TABLE #GLTranslationType
DROP TABLE #GLTranslationSubType
DROP TABLE #GLGlobalAccountTranslationType
DROP TABLE #GLGlobalAccountTranslationSubType
DROP TABLE #GLMajorCategory
DROP TABLE #GLMinorCategory
DROP TABLE #ProfitabilityActual

' 
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]
GO

CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]

	@ImportStartDate	DateTime,
	@ImportEndDate		DateTime,
	@DataPriorToDate	DateTime=NULL
AS

SET NOCOUNT ON
IF @DataPriorToDate IS NULL 
	SET @DataPriorToDate = GETDATE()

PRINT '####'
PRINT 'stp_IU_LoadGrProfitabiltyPayrollReforecast'
PRINT '####'


	
/*
[stp_IU_LoadGrProfitabiltyPayrollReforecast]
	@ImportStartDate	= '1900-01-01',
	@ImportEndDate		= '2010-12-31',
	@DataPriorToDate	= '2010-12-31'
*/ 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Setup mapping variables
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--/*
-- Setup Bonus Cap Excess Project Setting

CREATE TABLE #SystemSettingRegion
(
	SystemSettingId INT NOT NULL,
	SystemSettingName VARCHAR(50) NOT NULL,
	SystemSettingRegionId INT NOT NULL,
	RegionId INT,
	SourceCode VARCHAR(2),
	BonusCapExcessProjectId INT
)
INSERT INTO #SystemSettingRegion
(
	SystemSettingId,
	SystemSettingName,
	SystemSettingRegionId,
	RegionId,
	SourceCode,
	BonusCapExcessProjectId
)

SELECT 
	ss.SystemSettingId,
	ss.Name,
	ssr.SystemSettingRegionId,
	ssr.RegionId,
	ssr.SourceCode,
	ssr.BonusCapExcessProjectId
FROM
	(SELECT 
		ssr.* 
	 FROM TapasGlobal.SystemSettingRegion ssr
		INNER JOIN TapasGlobal.SystemSettingRegionActive(@DataPriorToDate) ssrA
			ON ssr.ImportKey = ssrA.ImportKey
	 ) ssr
	INNER JOIN
		(SELECT
			ss.SystemSettingId,
			ss.Name
		 FROM
			(SELECT	
				ss.*
			 FROM TapasGlobal.SystemSetting ss
					INNER JOIN TapasGlobal.SystemSettingActive(@DataPriorToDate) ssA 
						ON ss.ImportKey = ssA.ImportKey
			 ) ss

		  ) ss ON ssr.SystemSettingId = ss.SystemSettingId
PRINT 'Completed getting system settings'
PRINT CONVERT(Varchar(27), getdate(), 121)

--*/
-- Setup account categories and default to UNKNOWN.
DECLARE 
	@SalariesTaxesBenefitsMajorGlAccountCategoryId INT = -1,
	@BaseSalaryMinorGlAccountCategoryId INT = -1,
	@BenefitsMinorGlAccountCategoryId INT = -1,
	@BonusMinorGlAccountCategoryId INT = -1,
	@ProfitShareMinorGlAccountCategoryId INT = -1,
	@OccupancyCostsMajorGlAccountCategoryId INT = -1,
	@OverheadMinorGlAccountCategoryId INT = -1

DECLARE 
	@GlAccountKeyUnknown			INT = (SELECT GlAccountKey FROM GrReporting.dbo.GlAccount WHERE Code = 'UNKNOWN'),
	@SourceKeyUnknown				INT = (SELECT SourceKey FROM GrReporting.dbo.[Source] WHERE SourceName = 'UNKNOWN'),
	@FunctionalDepartmentKeyUnknown INT = (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = 'UNKNOWN'),
	@ReimbursableKeyUnknown			INT = (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = 'UNKNOWN'),
	@ActivityTypeKeyUnknown			INT = (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = 'UNKNOWN'),
	@PropertyFundKeyUnknown			INT = (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = 'UNKNOWN'),
	@AllocationRegionKeyUnknown		INT = (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = 'UNKNOWN'),
	@OriginatingRegionKeyUnknown	INT = (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = 'UNKNOWN'),
	@LocalCurrencyKeyUnknown		INT = (SELECT CurrencyKey FROM GrReporting.dbo.Currency WHERE CurrencyCode = 'UNKNOWN')

DECLARE
	@EUFundGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Fund Profit & Loss'      AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@EUCorporateGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@EUPropertyGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Property Profit & Loss'  AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@USFundGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Fund Profit & Loss'      AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@USPropertyGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Property Profit & Loss'  AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@USCorporateGlAccountCategoryKeyUnknown INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@DevelopmentGlAccountCategoryKeyUnknown INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'Development Profit & Loss'  AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@GlobalGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global' AND TranslationSubTypeName = 'Global' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')

		
-- Set gl account categories
SELECT TOP 1
	@SalariesTaxesBenefitsMajorGlAccountCategoryId = GLMajorCategoryId
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryName = 'Salaries/Taxes/Benefits'

print (@SalariesTaxesBenefitsMajorGlAccountCategoryId)
--NB!!!!!!!
--The roll up to payroll is very sensitive information. It is crutial that information regarding payroll not get 
--communicated to TS employees on certain reports. Changing the category name here will have ramifications because 
--some reports check for this name.
--NB!!!!!!!

SELECT
	@BaseSalaryMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	GLMinorCategoryName = 'Base Salary'

SELECT
	@BenefitsMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	GLMinorCategoryName = 'Benefits'

SELECT
	@BonusMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	GLMinorCategoryName = 'Bonus'

SELECT
	@ProfitShareMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	GLMinorCategoryName = 'Benefits' -- Yes benefit is correct (Just incase they want to split profit share out again)

SELECT TOP 1
	@OccupancyCostsMajorGlAccountCategoryId = GLMajorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryName = 'General Overhead'

SELECT
	@OverheadMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @OccupancyCostsMajorGlAccountCategoryId AND
	GLMinorCategoryName = 'External General Overhead'

DECLARE @SourceSystemId int
SET @SourceSystemId = 2 -- Tapas budgeting source system

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Source Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--/*

CREATE TABLE #GLTranslationType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLTranslationSubType(
	ImportKey INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsGRDefault BIT NOT NULL
)

CREATE TABLE #GLMajorCategory(
	ImportKey INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMinorCategory(
	ImportKey INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLAccountType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLAccountSubType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	GLAccountSubTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

-- #GLTranslationType

INSERT INTO #GLTranslationType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	GLTranslationTypeId,
	Code,
	Name,
	[Description],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	TT.ImportKey,
	TT.ImportBatchId,
	TT.ImportDate,
	TT.GLTranslationTypeId,
	TT.Code,
	TT.Name,
	TT.[Description],
	TT.IsActive,
	TT.InsertedDate,
	TT.UpdatedDate,
	TT.UpdatedByStaffId
FROM
	Gdm.GLTranslationType TT
	INNER JOIN Gdm.GLTranslationTypeActive(@DataPriorToDate) TTA ON
		TTA.ImportKey = TT.ImportKey

-- #GLTranslationSubType

INSERT INTO #GLTranslationSubType(
	ImportKey,
	GLTranslationSubTypeId,
	GLTranslationTypeId,
	Code,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsGRDefault
)
SELECT
	TST.ImportKey,
	TST.GLTranslationSubTypeId,
	TST.GLTranslationTypeId,
	TST.Code,
	TST.[Name],
	TST.IsActive,
	TST.InsertedDate,
	TST.UpdatedDate,
	TST.UpdatedByStaffId,
	TST.IsGRDefault
FROM
	Gdm.GLTranslationSubType TST
	INNER JOIN Gdm.GLTranslationSubTypeActive(@DataPriorToDate) TSTA ON
		TSTA.ImportKey = TST.ImportKey

-- #GLMajorCategory

INSERT INTO #GLMajorCategory(
	ImportKey,
	GLMajorCategoryId,
	GLTranslationSubTypeId,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	MajC.ImportKey,
	MajC.GLMajorCategoryId,
	MajC.GLTranslationSubTypeId,
	MajC.[Name],
	MajC.IsActive,
	MajC.InsertedDate,
	MajC.UpdatedDate,
	MajC.UpdatedByStaffId
FROM
	Gdm.GLMajorCategory MajC
	INNER JOIN Gdm.GLMajorCategoryActive(@DataPriorToDate) MajCA ON
		MajC.ImportKey = MajCA.ImportKey

-- #GLMinorCategory

INSERT INTO #GLMinorCategory(
	ImportKey,
	GLMinorCategoryId,
	GLMajorCategoryId,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	Minc.ImportKey,
	Minc.GLMinorCategoryId,
	Minc.GLMajorCategoryId,
	Minc.[Name],
	Minc.IsActive,
	Minc.InsertedDate,
	Minc.UpdatedDate,
	Minc.UpdatedByStaffId
FROM
	Gdm.GLMinorCategory MinC
	INNER JOIN Gdm.GLMinorCategoryActive(@DataPriorToDate) MinCA ON
		MinCA.ImportKey = MinC.ImportKey

-- #GLAccountType

INSERT INTO #GLAccountType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	GLAccountTypeId,
	GLTranslationTypeId,
	Code,
	Name,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	AT.ImportKey,
	AT.ImportBatchId,
	AT.ImportDate,
	AT.GLAccountTypeId,
	AT.GLTranslationTypeId,
	AT.Code,
	AT.Name,
	AT.IsActive,
	AT.InsertedDate,
	AT.UpdatedDate,
	AT.UpdatedByStaffId	
FROM
	Gdm.GLAccountType AT
	INNER JOIN Gdm.GLAccountTypeActive(@DataPriorToDate) ATA ON
		AT.ImportKey = ATA.ImportKey
	
-- #GLAccountSubType

INSERT INTO #GLAccountSubType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	GLAccountSubTypeId,
	GLTranslationTypeId,
	Code,
	Name,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	AST.ImportKey,
	AST.ImportBatchId,
	AST.ImportDate,
	AST.GLAccountSubTypeId,
	AST.GLTranslationTypeId,
	AST.Code,
	AST.Name,
	AST.IsActive,
	AST.InsertedDate,
	AST.UpdatedDate,
	AST.UpdatedByStaffId
FROM
	Gdm.GLAccountSubType AST
	INNER JOIN Gdm.GLAccountSubTypeActive(@DataPriorToDate) ASTA ON
		AST.ImportKey = ASTA.ImportKey

-- Get GLTranslationType, GLTranslationSubType, GLAccountType(either expense type), and GLAccountSubType(either payroll type) data
-- This table is used when inserts are made to the TranslationSubType CategoryLookup tables: search for 'Map account categories' section
CREATE TABLE #GLAccountCategoryTranslations(
	GLTranslationTypeId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationSubTypeCode VARCHAR(10) NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL
)

INSERT INTO #GLAccountCategoryTranslations(
	GLTranslationTypeId,
	GLTranslationSubTypeId,
	GLTranslationSubTypeCode,
	GLAccountTypeId,
	GLAccountSubTypeId
)
SELECT
	TST.GLTranslationTypeId,
	TST.GLTranslationSubTypeId,
	TST.Code,
	AT.GLAccountTypeId,
	AST.GLAccountSubTypeId
FROM
	#GLTranslationSubType TST

	INNER JOIN #GLTranslationType TT ON
		TT.GLTranslationTypeId = TST.GLTranslationTypeId

	INNER JOIN #GLAccountType AT ON
		TST.GLTranslationTypeId = AT.GLTranslationTypeId AND
		AT.IsActive = 1

	INNER JOIN #GLAccountSubType AST ON
		TST.GLTranslationTypeId = AST.GLTranslationTypeId AND
		AST.IsActive = 1
	
WHERE
	AST.Code LIKE '%PYR' AND -- This stored procedure exclusively looks at payroll. Only consider Account SubTypes related to payroll.
	AT.Code LIKE '%EXP' AND -- Only consider expense-related account types: Payroll is always considered as an expense.
	TT.IsActive = 1 AND
	TST.IsActive = 1 AND
	AT.IsActive = 1 AND
	AST.IsActive = 1

PRINT 'Completed getting GlAccountCategory records'
PRINT CONVERT(Varchar(27), getdate(), 121)
------------------------------------------------------------------------------------------------------
--Source and identify report grouping records
------------------------------------------------------------------------------------------------------

-- Source budget report group detail. 



CREATE TABLE #BudgetReportGroupDetail(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetReportGroupDetailId INT NOT NULL,
	BudgetReportGroupId INT NOT NULL,
	RegionId INT NOT NULL,
	BudgetId INT NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)


INSERT INTO #BudgetReportGroupDetail(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetReportGroupDetailId,
	BudgetReportGroupId,
	RegionId,
	BudgetId,
	IsDeleted,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	brgd.*
FROM 
	TapasGlobalBudgeting.BudgetReportGroupDetail brgd
	INNER JOIN TapasGlobalBudgeting.BudgetReportGroupDetailActive(@DataPriorToDate) brgdA ON
		brgd.ImportKey = brgdA.ImportKey

--select * from #BudgetReportGroupDetail
		
PRINT 'Completed inserting records from BudgetReportGroupDetail:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget report group.

CREATE TABLE #BudgetReportGroup(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetReportGroupId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	BudgetExchangeRateId INT NOT NULL,
	IsReforecast BIT NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NOT NULL,
	FirstProjectedPeriod INT NULL,
	IsDeleted BIT NOT NULL,
	GRChangedDate DATETIME NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	BudgetReportGroupPeriodId INT NULL
)

INSERT INTO #BudgetReportGroup(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetReportGroupId,
	Name,
	BudgetExchangeRateId,
	IsReforecast,
	StartPeriod,
	EndPeriod,
	FirstProjectedPeriod,
	IsDeleted,
	GRChangedDate,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	BudgetReportGroupPeriodId
)
SELECT 
	brg.* 
FROM 
	TapasGlobalBudgeting.BudgetReportGroup brg
	INNER JOIN TapasGlobalBudgeting.BudgetReportGroupActive(@DataPriorToDate) brgA ON
		brg.ImportKey = brgA.ImportKey

--select * from #BudgetReportGroup
	
PRINT 'Completed inserting records from BudgetReportGroup:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source report group period mapping.

CREATE TABLE #BudgetReportGroupPeriod(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetReportGroupPeriodId INT NOT NULL,
	BudgetExchangeRateId INT NOT NULL,
	[Year] INT NOT NULL,
	Period INT NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetReportGroupPeriod(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetReportGroupPeriodId,
	BudgetExchangeRateId,
	[Year],
	Period,
	IsDeleted,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	brgp.*
FROM
	Gdm.BudgetReportGroupPeriod brgp
	INNER JOIN Gdm.BudgetReportGroupPeriodActive(@DataPriorToDate) brgpA ON
		brgp.ImportKey = brgpA.ImportKey

--select * from #BudgetReportGroupPeriod

PRINT 'Completed inserting records from GRBudgetReportGroupPeriod:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget status

CREATE TABLE #BudgetStatus(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetStatusId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	[Description] VARCHAR(100) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetStatus(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetStatusId,
	Name,
	[Description],
	InsertedDate,
	UpdatedByStaffId
)
SELECT 
	BudgetStatus.* 
FROM
	TapasGlobalBudgeting.BudgetStatus BudgetStatus
	INNER JOIN TapasGlobalBudgeting.BudgetStatusActive(@DataPriorToDate) BudgetStatusA ON
		BudgetStatus.ImportKey = BudgetStatusA.ImportKey
		
PRINT 'Completed inserting records from BudgetStatus:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source all active budget

CREATE TABLE #AllActiveBudget(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetId INT NOT NULL,
	RegionId INT NOT NULL,
	BudgetTypeId INT NOT NULL,
	BudgetStatusId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NOT NULL,
	FirstProjectedPeriod INT NULL,
	CurrencyCode VARCHAR(3) NOT NULL,
	CanEmployeesViewBudget BIT NOT NULL,
	IsReforecast BIT NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	LastLockedDate DATETIME NULL,
	BudgetAllocationSetId INT NULL,
	LastAMUpdateDate DATETIME NULL
)

INSERT INTO #AllActiveBudget(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetId,
	RegionId,
	BudgetTypeId,
	BudgetStatusId,
	Name,
	StartPeriod,
	EndPeriod,
	FirstProjectedPeriod,
	CurrencyCode,
	CanEmployeesViewBudget,
	IsReforecast,
	IsDeleted,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	LastLockedDate,
	BudgetAllocationSetId,
	LastAMUpdateDate
)
SELECT 
	Budget.*
FROM
	TapasGlobalBudgeting.Budget Budget
	INNER JOIN TapasGlobalBudgeting.BudgetActive(@DataPriorToDate) BudgetA ON
		Budget.ImportKey = BudgetA.ImportKey
		
PRINT 'Completed inserting records from Budget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Modified new or modified budget or report group setup.

CREATE TABLE #AllModifiedReportBudget(
	BudgetId INT NOT NULL,
	BudgetReportGroupId INT NOT NULL,
	BudgetReportGroupPeriodId INT NOT NULL,
	IsBudgetDeleted BIT NOT NULL,
	IsBugetReforecast BIT NOT NULL,
	BudgetStatusId INT NOT NULL,
	BudgetFirstProjectedPeriod INT NULL,
	IsDetailDeleted BIT NOT NULL,
	IsGroupReforecast BIT NOT NULL,
	GroupStartPeriod INT NOT NULL,
	GroupEndPeriod INT NOT NULL,
	IsGroupDeleted BIT NOT NULL,
	IsPeriodDeleted BIT NOT NULL
)

INSERT INTO #AllModifiedReportBudget(
	BudgetId, 
	BudgetReportGroupId,
	BudgetReportGroupPeriodId,
	IsBudgetDeleted,
	IsBugetReforecast,
	BudgetStatusId, 
	BudgetFirstProjectedPeriod,
	IsDetailDeleted, 
	IsGroupReforecast, 
	GroupStartPeriod, 
	GroupEndPeriod, 
	IsGroupDeleted,
	IsPeriodDeleted
)
SELECT 
	brgd.BudgetId, 
	brgd.BudgetReportGroupId,
	brgp.BudgetReportGroupPeriodId,
	Budget.IsDeleted AS IsBudgetDeleted,
	Budget.IsReforecast AS IsBugetReforecast,
	Budget.BudgetStatusId, 
	Budget.FirstProjectedPeriod AS BudgetFirstProjectedPeriod,
	brgd.IsDeleted AS IsDetailDeleted, 
	brg.IsReforecast AS IsGroupReforecast, 
	brg.StartPeriod AS GroupStartPeriod, 
	brg.EndPeriod AS GroupEndPeriod, 
	brg.IsDeleted AS IsGroupDeleted,
	brgp.IsDeleted AS IsPeriodDeleted
FROM
	#AllActiveBudget Budget

    INNER JOIN #BudgetReportGroupDetail brgd ON
		Budget.BudgetId = brgd.BudgetId
    
    INNER JOIN #BudgetReportGroup brg ON
		brgd.BudgetReportGroupId = brg.BudgetReportGroupId
    
    INNER JOIN #BudgetReportGroupPeriod brgp ON
		brg.BudgetReportGroupPeriodId = brgp.BudgetReportGroupPeriodId 
		
WHERE
	(brgd.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
	(brg.GRChangedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
	(brgp.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
	(Budget.LastLockedDate IS NOT NULL AND Budget.LastLockedDate BETWEEN @ImportStartDate AND @ImportEndDate)

--select * from #AllModifiedReportBudget

PRINT 'Completed inserting records into #AllModifiedReportBudget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Filtered budget and setup report group setup

CREATE TABLE #LockedModifiedReportGroup(
	BudgetReportGroupId INT NOT NULL
)

INSERT INTO #LockedModifiedReportGroup(
	BudgetReportGroupId
)
SELECT
	amrb.BudgetReportGroupId
FROM
	#AllModifiedReportBudget amrb
	
	INNER JOIN #BudgetStatus bs ON
		amrb.BudgetStatusId = bs.BudgetStatusId
GROUP BY
	amrb.BudgetReportGroupId
HAVING
	COUNT(*) = SUM(CASE WHEN bs.[Name] = 'Locked' THEN 1 ELSE 0 END) 

PRINT 'Completed inserting records into #LockedModifiedReportGroup:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source filtered budget information

CREATE TABLE #FilteredModifiedReportBudget(
	BudgetId INT NOT NULL,
	BudgetReportGroupId INT NOT NULL,
	BudgetReportGroupPeriodId INT NOT NULL,
	IsBudgetDeleted BIT NOT NULL,
	IsBugetReforecast BIT NOT NULL,
	BudgetStatusId INT NOT NULL,
	BudgetFirstProjectedPeriod INT NULL,
	IsDetailDeleted BIT NOT NULL,
	IsGroupReforecast BIT NOT NULL,
	GroupStartPeriod INT NOT NULL,
	GroupEndPeriod INT NOT NULL,
	IsGroupDeleted BIT NOT NULL,
	IsPeriodDeleted BIT NOT NULL,
	BudgetReportGroupPeriod INT NOT NULL
)

INSERT INTO #FilteredModifiedReportBudget(
	BudgetId,
	BudgetReportGroupId,
	BudgetReportGroupPeriodId,
	IsBudgetDeleted,
	IsBugetReforecast,
	BudgetStatusId,
	BudgetFirstProjectedPeriod,
	IsDetailDeleted,
	IsGroupReforecast,
	GroupStartPeriod,
	GroupEndPeriod,
	IsGroupDeleted,
	IsPeriodDeleted,
	BudgetReportGroupPeriod 
)
SELECT
	amrb.*,
	brgp.Period BudgetReportGroupPeriod
FROM
	#LockedModifiedReportGroup lmrg
	
	INNER JOIN #AllModifiedReportBudget amrb ON
		lmrg.BudgetReportGroupId = amrb.BudgetReportGroupId

	INNER JOIN #BudgetReportGroupPeriod brgp ON
		brgp.BudgetReportGroupPeriodId = amrb.BudgetReportGroupPeriodId
		
WHERE
	amrb.IsBudgetDeleted = 0 AND
	amrb.IsBugetReforecast = 1 AND
	amrb.IsDetailDeleted = 0 AND
	amrb.IsGroupReforecast = 1 AND
	amrb.IsGroupDeleted = 0 AND
	amrb.IsPeriodDeleted = 0 AND
	brgp.IsDeleted = 0

PRINT 'Completed inserting records into #FilteredModifiedReportBudget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--select * from #FilteredModifiedReportBudget

-- Source budget information that meet criteria

CREATE TABLE #Budget(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetId INT NOT NULL,
	RegionId INT NOT NULL,
	BudgetTypeId INT NOT NULL,
	BudgetStatusId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NOT NULL,
	FirstProjectedPeriod INT NULL,
	CurrencyCode VARCHAR(3) NOT NULL,
	CanEmployeesViewBudget BIT NOT NULL,
	IsReforecast BIT NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	LastLockedDate DATETIME NULL,
	BudgetAllocationSetId INT NULL,
	LastAMUpdateDate DATETIME NULL
)

INSERT INTO #Budget(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetId,
	RegionId,
	BudgetTypeId,
	BudgetStatusId,
	Name,
	StartPeriod,
	EndPeriod,
	FirstProjectedPeriod,
	CurrencyCode,
	CanEmployeesViewBudget,
	IsReforecast,
	IsDeleted,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	LastLockedDate,
	BudgetAllocationSetId,
	LastAMUpdateDate
)
SELECT 
	Budget.*
FROM
	#AllActiveBudget Budget
	
	INNER JOIN #FilteredModifiedReportBudget fmrb ON
		Budget.BudgetId = fmrb.BudgetId
PRINT 'Completed inserting records into #Budget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetID ON #Budget (BudgetId)
PRINT 'Completed creating indexes on #Budget'
PRINT CONVERT(Varchar(27), getdate(), 121)

--select * from #Budget

--*/
------------------------------------------------------------------------------------------------------
--Source associated records
------------------------------------------------------------------------------------------------------

--/*
-- Source budget project

CREATE TABLE #BudgetProject(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetProjectId INT NOT NULL,
	BudgetId INT NOT NULL,
	ProjectId INT NULL,
	RegionId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	ActivityTypeId INT NOT NULL,
	Code VARCHAR(50) NULL,
	Name VARCHAR(100) NULL,
	CorporateDepartmentCode VARCHAR(6) NULL,
	CorporateSourceCode VARCHAR(2) NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NULL,
	IsReimbursable BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetProjectId INT NULL,
	IsTsCost BIT NOT NULL,
	CanAllocateOverheads BIT NOT NULL,
	AllocateOverheadsProjectId INT NULL,
	MarkUpPercentage DECIMAL(5, 4) NULL,
	ProjectOwnerStaffId INT NULL,
	AMBudgetProjectId INT NULL
)

INSERT INTO #BudgetProject(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetProjectId,
	BudgetId,
	ProjectId,
	RegionId,
	PropertyFundId,
	ActivityTypeId,
	Code,
	Name,
	CorporateDepartmentCode,
	CorporateSourceCode,
	StartPeriod,
	EndPeriod,
	IsReimbursable,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetProjectId,
	IsTsCost,
	CanAllocateOverheads,
	AllocateOverheadsProjectId,
	MarkUpPercentage,
	ProjectOwnerStaffId,
	AMBudgetProjectId
)
SELECT 
	BudgetProject.*
FROM 
	TapasGlobalBudgeting.BudgetProject BudgetProject
	INNER JOIN TapasGlobalBudgeting.BudgetProjectActive(@DataPriorToDate) BudgetProjectA ON
		BudgetProject.ImportKey = BudgetProjectA.ImportKey
		
	-- data limiting join
	INNER JOIN #Budget b ON
		BudgetProject.BudgetId = b.BudgetId

--select * from #BudgetProject

PRINT 'Completed inserting records into #BudgetProject:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetID ON #BudgetProject (BudgetId)
PRINT 'Completed creating indexes on #BudgetProject'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source region

CREATE TABLE #Region(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	RegionId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	PayCode VARCHAR(5) NULL,
	EnrollmentTypeId INT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

INSERT INTO #Region(
	ImportKey,
	ImportBatchId,
	ImportDate,
	RegionId,
	SourceCode,
	Code,
	Name,
	PayCode,
	EnrollmentTypeId,
	InsertedDate,
	UpdatedDate
)
SELECT 
	SourceRegion.*
FROM 
	HR.Region SourceRegion
	INNER JOIN HR.RegionActive(@DataPriorToDate) SourceRegionA ON
		SourceRegion.ImportKey = SourceRegionA.ImportKey
PRINT 'Completed inserting records into #Region:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Budget Employee

CREATE TABLE #BudgetEmployee(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	BudgetId INT NOT NULL,
	HrEmployeeId INT NULL,
	PayGroupId INT NOT NULL,
	JobTitleId INT NOT NULL,
	LocationId INT NOT NULL,
	StateId INT NULL,
	OverheadRegionId INT NOT NULL,
	ApproverStaffId INT NULL,
	Name VARCHAR(255) NOT NULL,
	IsUnion BIT NOT NULL,
	RehirePeriod INT NOT NULL,
	RehireDate DATETIME NOT NULL,
	TerminatePeriod INT NULL,
	TerminateDate DATETIME NULL,
	EmployeeHistoryEffectivePeriod INT NOT NULL,
	EmployeeHistoryEffectiveDate DATETIME NOT NULL,
	EmployeePayrollEffectiveDate DATETIME NULL,
	CurrentAnnualSalary DECIMAL(18, 2) NULL,
	PreviousYearSalary DECIMAL(18, 2) NULL,
	SalaryYear INT NOT NULL,
	PreviousYearBonus DECIMAL(18, 2) NULL,
	BonusYear INT NULL,
	IsActualEmployee BIT NOT NULL,
	IsReviewed BIT NOT NULL,
	IsPartTime BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetEmployeeId INT NULL
)

INSERT INTO #BudgetEmployee(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeeId,
	BudgetId,
	HrEmployeeId,
	PayGroupId,
	JobTitleId,
	LocationId,
	StateId,
	OverheadRegionId ,
	ApproverStaffId,
	Name,
	IsUnion,
	RehirePeriod,
	RehireDate,
	TerminatePeriod,
	TerminateDate,
	EmployeeHistoryEffectivePeriod,
	EmployeeHistoryEffectiveDate,
	EmployeePayrollEffectiveDate,
	CurrentAnnualSalary,
	PreviousYearSalary,
	SalaryYear,
	PreviousYearBonus,
	BonusYear,
	IsActualEmployee,
	IsReviewed,
	IsPartTime,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetEmployeeId
)
SELECT 
	BudgetEmployee.* 
FROM 
	TapasGlobalBudgeting.BudgetEmployee BudgetEmployee
	INNER JOIN TapasGlobalBudgeting.BudgetEmployeeActive(@DataPriorToDate) BudgetEmployeeA ON
		BudgetEmployee.ImportKey = BudgetEmployeeA.ImportKey

	--data limiting join
	INNER JOIN #Budget b ON
		BudgetEmployee.BudgetId = b.BudgetId

PRINT 'Completed inserting records into #Region:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeeID ON #BudgetEmployee (BudgetEmployeeId)
CREATE INDEX IX_BudgetId ON #BudgetEmployee (BudgetId)

PRINT 'Completed creating indexes on ##BudgetEmployee'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Budget Employee Functional Department

CREATE TABLE #BudgetEmployeeFunctionalDepartment(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeeFunctionalDepartmentId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	SubDepartmentId INT NOT NULL,
	EffectivePeriod INT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL
)

INSERT INTO #BudgetEmployeeFunctionalDepartment(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeeFunctionalDepartmentId,
	BudgetEmployeeId,
	SubDepartmentId,
	EffectivePeriod,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	FunctionalDepartmentId
)
SELECT 
	efd.* 
FROM 
	TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment efd
	INNER JOIN TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartmentActive(@DataPriorToDate) efdA ON
		efd.ImportKey = efdA.ImportKey

	-- data limiting join
	INNER JOIN #BudgetEmployee be ON
		efd.BudgetEmployeeId = be.BudgetEmployeeId

PRINT 'Completed inserting records into #BudgetEmployeeFunctionalDepartment:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeeId ON #BudgetEmployeeFunctionalDepartment (BudgetEmployeeId)
PRINT 'Completed creating indexes on #BudgetEmployeeFunctionalDepartment'
PRINT CONVERT(Varchar(27), getdate(), 121)



-- Source Functional Department

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
	HR.FunctionalDepartment fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) fdA ON
		fd.ImportKey = fdA.ImportKey

PRINT 'Completed inserting records into #FunctionalDepartment:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_FunctionalDepartmentId ON #FunctionalDepartment (FunctionalDepartmentId)
PRINT 'Completed creating indexes on #FunctionalDepartment'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Property Fund

CREATE TABLE #PropertyFund(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	PropertyFundId INT NOT NULL,
	RelatedFundId INT NULL,
	EntityTypeId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	BudgetOwnerStaffId INT NOT NULL,
	RegionalOwnerStaffId INT NOT NULL,
	DefaultGLTranslationSubTypeId INT NULL,
	Name VARCHAR(100) NOT NULL,
	IsReportingEntity BIT NOT NULL,
	IsPropertyFund BIT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #PropertyFund(
	ImportKey,
	ImportBatchId,
	ImportDate,
	PropertyFundId,
	RelatedFundId,
	EntityTypeId,
	AllocationSubRegionGlobalRegionId,
	BudgetOwnerStaffId,
	RegionalOwnerStaffId,
	DefaultGLTranslationSubTypeId,
	Name,
	IsReportingEntity,
	IsPropertyFund,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT 
	PropertyFund.*
FROM 
	Gdm.PropertyFund PropertyFund
	INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PropertyFundA ON
		PropertyFund.ImportKey = PropertyFundA.ImportKey 

PRINT 'Completed inserting records into #PropertyFund:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFund (PropertyFundId)
PRINT 'Completed creating indexes on #PropertyFund'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Property Fund Mapping

CREATE TABLE #PropertyFundMapping(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	PropertyFundMappingId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	PropertyFundCode VARCHAR(8) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL,
	ActivityTypeId INT NULL
)

INSERT INTO #PropertyFundMapping(
	ImportKey,
	ImportBatchId,
	ImportDate,
	PropertyFundMappingId,
	PropertyFundId,
	SourceCode,
	PropertyFundCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted,
	ActivityTypeId
)
SELECT 
	PropertyFundMapping.* 
FROM 
	Gdm.PropertyFundMapping PropertyFundMapping
	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PropertyFundMappingA ON
		PropertyFundMapping.ImportKey = PropertyFundMappingA.ImportKey 

PRINT 'Completed inserting records into #PropertyFundMapping:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFundMapping (PropertyFundCode,SourceCode,IsDeleted,PropertyFundId,ActivityTypeId)
PRINT 'Completed creating indexes on #PropertyFundMapping'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source ReportingEntityCorporateDepartment

CREATE TABLE #ReportingEntityCorporateDepartment( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	ReportingEntityCorporateDepartmentId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	CorporateDepartmentCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsDeleted BIT NOT NULL,
)

INSERT INTO	#ReportingEntityCorporateDepartment(
	ImportKey,
	ReportingEntityCorporateDepartmentId,
	PropertyFundId,
	SourceCode,
	CorporateDepartmentCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsDeleted
)
SELECT
	RECD.ImportKey,
	RECD.ReportingEntityCorporateDepartmentId,
	RECD.PropertyFundId,
	RECD.SourceCode,
	RECD.CorporateDepartmentCode,
	RECD.InsertedDate,
	RECD.UpdatedDate,
	RECD.UpdatedByStaffId,
	RECD.IsDeleted
FROM
	Gdm.ReportingEntityCorporateDepartment RECD
	INNER JOIN Gdm.ReportingEntityCorporateDepartmentActive(@DataPriorToDate) RECDA ON
		RECDA.ImportKey = RECD.ImportKey

PRINT 'Completed creating indexes on #ReportingEntityCorporateDepartment'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source ReportingEntityPropertyEntity

CREATE TABLE #ReportingEntityPropertyEntity( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	ReportingEntityPropertyEntityId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	PropertyEntityCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsDeleted BIT NOT NULL
)

INSERT INTO #ReportingEntityPropertyEntity(
	ImportKey,
	ReportingEntityPropertyEntityId,
	PropertyFundId,
	SourceCode,
	PropertyEntityCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsDeleted
)
SELECT
	REPE.ImportKey,
	REPE.ReportingEntityPropertyEntityId,
	REPE.PropertyFundId,
	REPE.SourceCode,
	REPE.PropertyEntityCode,
	REPE.InsertedDate,
	REPE.UpdatedDate,
	REPE.UpdatedByStaffId,
	REPE.IsDeleted
FROM
	Gdm.ReportingEntityPropertyEntity REPE
	INNER JOIN Gdm.ReportingEntityPropertyEntityActive(@DataPriorToDate) REPEA ON
		REPEA.ImportKey = REPE.ImportKey

PRINT 'Completed creating indexes on #ReportingEntityPropertyEntity'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Location

CREATE TABLE #Location(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	LocationId INT NOT NULL,
	ExternalSubRegionId INT NOT NULL,
	StateId INT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

INSERT INTO #Location(
	ImportKey,
	ImportBatchId,
	ImportDate,
	LocationId,
	ExternalSubRegionId,
	StateId,
	Code,
	Name,
	IsActive,
	InsertedDate,
	UpdatedDate
)
SELECT 
	Location.* 
FROM 
	HR.Location Location
	INNER JOIN HR.LocationActive(@DataPriorToDate) LocationA ON
		Location.ImportKey = LocationA.ImportKey
	
PRINT 'Completed inserting records into #Location:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_LocationId ON #Location (LocationId)
PRINT 'Completed creating indexes on #Location'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source region extended

CREATE TABLE #RegionExtended(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	RegionId INT NOT NULL,
	RegionalAdministratorId INT NOT NULL,
	CountryId INT NOT NULL,
	HasEmployees BIT NOT NULL,
	CanChargeMarkupOnProject BIT NOT NULL,
	CanChargeMarkupOnPayrollOverhead BIT NOT NULL,
	CanUploadOverheadJournal BIT NOT NULL,
	ProjectRef VARCHAR(8) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OverheadFunctionalDepartmentId INT NOT NULL,
	CanRegionBillInArrears BIT NOT NULL
)

INSERT INTO #RegionExtended(
	ImportKey,
	ImportBatchId,
	ImportDate,
	RegionId,
	RegionalAdministratorId,
	CountryId,
	HasEmployees,
	CanChargeMarkupOnProject,
	CanChargeMarkupOnPayrollOverhead,
	CanUploadOverheadJournal,
	ProjectRef,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OverheadFunctionalDepartmentId,
	CanRegionBillInArrears
)
SELECT 
	RegionExtended.*
FROM 
	TapasGlobal.RegionExtended RegionExtended
	INNER JOIN TapasGlobal.RegionExtendedActive(@DataPriorToDate) RegionExtendedA ON
		RegionExtended.ImportKey = RegionExtendedA.ImportKey

PRINT 'Completed inserting records into #RegionExtended:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_RegionId ON #RegionExtended (RegionId)
PRINT 'Completed creating indexes on #RegionExtended'
PRINT CONVERT(Varchar(27), getdate(), 121)


-- Source Payroll Originating Region

CREATE TABLE #PayrollRegion(
	ImportKey INT NOT NULL,
	PayrollRegionId INT NOT NULL,
	RegionId INT NOT NULL,
	ExternalSubRegionId INT NOT NULL,
	CorporateEntityRef VARCHAR(6) NOT NULL,
	CorporateSourceCode VARCHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #PayrollRegion(
	ImportKey,
	PayrollRegionId,
	RegionId,
	ExternalSubRegionId,
	CorporateEntityRef,
	CorporateSourceCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT 
	PayrollRegion.*
FROM 
	TapasGlobal.PayrollRegion PayrollRegion
	INNER JOIN TapasGlobal.PayrollRegionActive(@DataPriorToDate) PayrollRegionA ON
		PayrollRegion.ImportKey = PayrollRegionA.ImportKey
	
PRINT 'Completed inserting records into #PayrollRegion:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PayrollRegionId ON #PayrollRegion (PayrollRegionId)
PRINT 'Completed creating indexes on #PayrollRegion'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Overhead Originating Region

CREATE TABLE #OverheadRegion(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	OverheadRegionId INT NOT NULL,
	RegionId INT NOT NULL,
	CorporateEntityRef VARCHAR(6) NULL,
	CorporateSourceCode VARCHAR(2) NULL,
	Name VARCHAR(50) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #OverheadRegion(
	ImportKey,
	ImportBatchId,
	ImportDate,
	OverheadRegionId,
	RegionId,
	CorporateEntityRef,
	CorporateSourceCode,
	Name,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)

SELECT 
	OverheadRegion.*
FROM 
	TapasGlobal.OverheadRegion OverheadRegion
	INNER JOIN TapasGlobal.OverheadRegionActive(@DataPriorToDate) OverheadRegionA ON
		OverheadRegion.ImportKey = OverheadRegionA.ImportKey
	
PRINT 'Completed inserting records into #OverheadRegion:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_OverheadRegionId ON #OverheadRegion (OverheadRegionId)
PRINT 'Completed creating indexes on #OverheadRegion'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source project

CREATE TABLE #Project(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	ProjectId INT NOT NULL,
	RegionId INT NOT NULL,
	ActivityTypeId INT NOT NULL,
	ProjectOwnerId INT NULL,
	CorporateDepartmentCode VARCHAR(8) NOT NULL,
	CorporateSourceCode CHAR(2) NOT NULL,
	Code VARCHAR(50) NOT NULL,
	Name VARCHAR(100) NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	PropertyOverheadGLAccountCode VARCHAR(15) NULL,
	PropertyOverheadDepartmentCode VARCHAR(6) NULL,
	PropertyOverheadJobCode VARCHAR(15) NULL,
	PropertyOverheadSourceCode CHAR(2) NULL,
	CorporateUnionPayrollIncomeCategoryCode VARCHAR(6) NULL,
	CorporateNonUnionPayrollIncomeCategoryCode VARCHAR(6) NULL,
	CorporateOverheadIncomeCategoryCode VARCHAR(6) NULL,
	PropertyFundId INT NOT NULL,
	MarkUpPercentage DECIMAL(5, 4) NULL,
	HistoricalProjectCode VARCHAR(50) NULL,
	IsTSCost BIT NOT NULL,
	CanAllocateOverheads BIT NOT NULL,
	AllocateOverheadsProjectId INT NULL
)

INSERT INTO #Project(
	ImportKey,
	ImportBatchId,
	ImportDate,
	ProjectId,
	RegionId,
	ActivityTypeId,
	ProjectOwnerId,
	CorporateDepartmentCode,
	CorporateSourceCode,
	Code,
	Name,
	StartPeriod,
	EndPeriod,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	PropertyOverheadGLAccountCode,
	PropertyOverheadDepartmentCode,
	PropertyOverheadJobCode,
	PropertyOverheadSourceCode,
	CorporateUnionPayrollIncomeCategoryCode,
	CorporateNonUnionPayrollIncomeCategoryCode,
	CorporateOverheadIncomeCategoryCode,
	PropertyFundId,
	MarkUpPercentage,
	HistoricalProjectCode,
	IsTSCost,
	CanAllocateOverheads,
	AllocateOverheadsProjectId
)
SELECT 
	Project.*
FROM 
	TapasGlobal.Project Project
	INNER JOIN TapasGlobal.ProjectActive(@DataPriorToDate) ProjectA ON
		Project.ImportKey = ProjectA.ImportKey 

PRINT 'Completed inserting records into #Project:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_ProjectId ON #Project (ProjectId)
PRINT 'Completed creating indexes on #Project'
PRINT CONVERT(Varchar(27), getdate(), 121)


------------------------------------------------------------------------------------------------------
--Source allocation records
------------------------------------------------------------------------------------------------------

-- Source payroll allocation

CREATE TABLE #BudgetEmployeePayrollAllocation(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	BudgetProjectId INT NOT NULL,
	BudgetProjectGroupId INT NULL,
	Period INT NOT NULL,
	SalaryAllocationValue DECIMAL(18, 9) NOT NULL,
	BonusAllocationValue DECIMAL(18, 9) NULL,
	BonusCapAllocationValue DECIMAL(18, 9) NULL,
	ProfitShareAllocationValue DECIMAL(18, 9) NULL,
	PreTaxSalaryAmount DECIMAL(18, 2) NOT NULL,
	PreTaxBonusAmount DECIMAL(18, 2) NULL,
	PreTaxBonusCapExcessAmount DECIMAL(18, 2) NULL,
	PreTaxProfitShareAmount DECIMAL(18, 2) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetEmployeePayrollAllocationId INT NULL
)

INSERT INTO #BudgetEmployeePayrollAllocation(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeePayrollAllocationId,
	BudgetEmployeeId,
	BudgetProjectId,
	BudgetProjectGroupId,
	Period,
	SalaryAllocationValue,
	BonusAllocationValue,
	BonusCapAllocationValue,
	ProfitShareAllocationValue,
	PreTaxSalaryAmount,
	PreTaxBonusAmount,
	PreTaxBonusCapExcessAmount,
	PreTaxProfitShareAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetEmployeePayrollAllocationId
)
SELECT
	Allocation.*
FROM
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocation Allocation

	INNER JOIN TapasGlobalBudgeting.BudgetEmployeePayrollAllocationActive(@DataPriorToDate) AllocationA ON
		Allocation.ImportKey = AllocationA.ImportKey

	--data limiting join
	INNER JOIN #BudgetProject bp ON
		Allocation.BudgetProjectId = bp.BudgetProjectId

PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocation:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationId ON #BudgetEmployeePayrollAllocation (BudgetEmployeePayrollAllocationId)
PRINT 'Completed creating indexes on #BudgetEmployeePayrollAllocation'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source payroll tax detail
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Using the 'active' function here cause serious performance issues and the only way around it, was to extract the logic from the is active function 
--to seperate peaces of code.
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #BudgetEmployeePayrollAllocationDetailBatches(
	BudgetEmployeePayrollAllocationDetailId int NOT NULL,
	ImportBatchId INT NOT NULL
)

INSERT INTO #BudgetEmployeePayrollAllocationDetailBatches(
	BudgetEmployeePayrollAllocationDetailId,
	ImportBatchId
)
SELECT 
	B2.BudgetEmployeePayrollAllocationDetailId,
	MAX(B2.ImportBatchId) AS ImportBatchId
FROM 
	[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B2
		
	INNER JOIN Batch ON
		B2.ImportBatchId = batch.BatchId		
WHERE	
	batch.BatchEndDate IS NOT NULL AND
	batch.PackageName = 'ETL.Staging.TapasGlobalBudgeting' AND
	batch.ImportEndDate <= @DataPriorToDate		
GROUP BY
	B2.BudgetEmployeePayrollAllocationDetailId

PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocationDetailBatches:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE TABLE #BEPADa(
	ImportKey INT NOT NULL
)

INSERT INTO #BEPADa(
	ImportKey
)
SELECT
	MAX(B1.ImportKey) ImportKey
FROM
	[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B1

	INNER JOIN #BudgetEmployeePayrollAllocationDetailBatches t1 ON 
		t1.BudgetEmployeePayrollAllocationDetailId = B1.BudgetEmployeePayrollAllocationDetailId AND
		t1.ImportBatchId = B1.ImportBatchId

GROUP BY
	B1.BudgetEmployeePayrollAllocationDetailId

PRINT 'Completed inserting records into #BEPADa:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #BudgetEmployeePayrollAllocationDetail(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	BenefitOptionId INT NULL,
	BudgetTaxTypeId INT NULL,
	SalaryAmount DECIMAL(18, 2) NULL,
	BonusAmount DECIMAL(18, 2) NULL,
	ProfitShareAmount DECIMAL(18, 2) NULL,
	BonusCapExcessAmount DECIMAL(18, 2) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetEmployeePayrollAllocationDetail(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeePayrollAllocationDetailId,
	BudgetEmployeePayrollAllocationId,
	BenefitOptionId,
	BudgetTaxTypeId,
	SalaryAmount,
	BonusAmount,
	ProfitShareAmount,
	BonusCapExcessAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	TaxDetail.*
FROM
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocationDetail TaxDetail
	
	INNER JOIN #BEPADa TaxDetailA ON
		TaxDetail.ImportKey = TaxDetailA.ImportKey

	--data limiting join
	INNER JOIN #BudgetEmployeePayrollAllocation Allocation ON
		TaxDetail.BudgetEmployeePayrollAllocationId = Allocation.BudgetEmployeePayrollAllocationId

PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocationDetail:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationDetailId ON #BudgetEmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationDetailId)
PRINT 'Completed creating indexes on #BudgetEmployeePayrollAllocationDetail'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget tax type

CREATE TABLE #BudgetTaxType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetTaxTypeId INT NOT NULL,
	BudgetId INT NOT NULL,
	TaxTypeId INT NOT NULL,
	FixedTaxTypeId INT NOT NULL,
	RateCalculationMethodId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetTaxTypeId INT NULL
)

INSERT INTO #BudgetTaxType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetTaxTypeId,
	BudgetId,
	TaxTypeId,
	FixedTaxTypeId,
	RateCalculationMethodId,
	Name,
	InsertedDate,
	UpdatedByStaffId,
	OriginalBudgetTaxTypeId
)
SELECT 
	BudgetTaxType.* 
FROM 
	TapasGlobalBudgeting.BudgetTaxType BudgetTaxType
	INNER JOIN TapasGlobalBudgeting.BudgetTaxTypeActive(@DataPriorToDate) BudgetTaxTypeA ON
		BudgetTaxType.ImportKey = BudgetTaxTypeA.ImportKey

	-- data limiting join
	INNER JOIN #Budget b ON
		BudgetTaxType.BudgetId = b.BudgetId

PRINT 'Completed inserting records into #BudgetTaxType:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetTaxTypeId ON #BudgetTaxType (BudgetTaxTypeId)
PRINT 'Completed creating indexes on #BudgetTaxType'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source tax type

CREATE TABLE #TaxType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	TaxTypeId INT NOT NULL,
	RegionId INT NOT NULL,
	FixedTaxTypeId INT NOT NULL,
	RateCalculationMethodId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL
)

INSERT INTO #TaxType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	TaxTypeId,
	RegionId,
	FixedTaxTypeId,
	RateCalculationMethodId,
	Name,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	MinorGlAccountCategoryId
)
SELECT 
	TaxType.*
FROM 
	TapasGlobalBudgeting.TaxType TaxType
	INNER JOIN TapasGlobalBudgeting.TaxTypeActive(@DataPriorToDate) TaxTypeA ON
		TaxType.ImportKey = TaxTypeA.ImportKey

PRINT 'Completed inserting records into #TaxType:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source payroll allocation Tax detail
CREATE TABLE #EmployeePayrollAllocationDetail
(
	ImportKey INT NOT NULL,
	BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	MinorGlAccountCategoryId INT NULL,
	BudgetTaxTypeId INT NULL,
	SalaryAmount DECIMAL(18, 2) NULL,
	BonusAmount DECIMAL(18, 2) NULL,
	ProfitShareAmount DECIMAL(18, 2) NULL,
	BonusCapExcessAmount DECIMAL(18, 2) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #EmployeePayrollAllocationDetail
(
	ImportKey,
	BudgetEmployeePayrollAllocationDetailId,
	BudgetEmployeePayrollAllocationId,
	MinorGlAccountCategoryId,
	BudgetTaxTypeId,
	SalaryAmount,
	BonusAmount,
	ProfitShareAmount,
	BonusCapExcessAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	TaxDetail.ImportKey,
	TaxDetail.BudgetEmployeePayrollAllocationDetailId,
	TaxDetail.BudgetEmployeePayrollAllocationId,
	CASE WHEN (TaxDetail.BenefitOptionId IS NOT NULL) THEN @BenefitsMinorGlAccountCategoryId ELSE TaxType.MinorGlAccountCategoryId END AS MinorGlAccountCategoryId,
	TaxDetail.BudgetTaxTypeId,
	TaxDetail.SalaryAmount,
	TaxDetail.BonusAmount,
	TaxDetail.ProfitShareAmount,
	TaxDetail.BonusCapExcessAmount,
	TaxDetail.InsertedDate,
	TaxDetail.UpdatedDate,
	TaxDetail.UpdatedByStaffId
FROM

	-- Joining on allocation to limit amount of data
	#BudgetEmployeePayrollAllocation Allocation
	
	INNER JOIN #BudgetEmployeePayrollAllocationDetail TaxDetail ON
		Allocation.BudgetEmployeePayrollAllocationId = TaxDetail.BudgetEmployeePayrollAllocationId 
			
	LEFT OUTER JOIN #BudgetTaxType BudgetTaxType ON
		TaxDetail.BudgetTaxTypeId = BudgetTaxType.BudgetTaxTypeId
				
	LEFT OUTER JOIN #TaxType TaxType ON
		BudgetTaxType.TaxTypeId = TaxType.TaxTypeId	
			
PRINT 'Completed inserting records into #EmployeePayrollAllocationDetail:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #EmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationDetailId,BudgetEmployeePayrollAllocationId)
PRINT 'Completed creating indexes on #EmployeePayrollAllocationDetail'
PRINT CONVERT(Varchar(27), getdate(), 121)

--*/
-- Source payroll overhead allocation

CREATE TABLE #BudgetOverheadAllocation(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetOverheadAllocationId INT NOT NULL,
	BudgetId INT NOT NULL,
	OverheadRegionId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	BudgetPeriod INT NOT NULL,
	AllocationAmount DECIMAL(18, 2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetOverheadAllocationId INT NULL
)

INSERT INTO #BudgetOverheadAllocation(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetOverheadAllocationId,
	BudgetId,
	OverheadRegionId,
	BudgetEmployeeId,
	BudgetPeriod,
	AllocationAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetOverheadAllocationId
)
SELECT
	OverheadAllocation.*
FROM
	TapasGlobalBudgeting.BudgetOverheadAllocation OverheadAllocation
	
	INNER JOIN TapasGlobalBudgeting.BudgetOverheadAllocationActive(@DataPriorToDate) OverheadAllocationA ON
		OverheadAllocation.ImportKey = OverheadAllocationA.ImportKey

	-- data limiting join
	INNER JOIN #Budget b ON
		OverheadAllocation.BudgetId = b.BudgetId

PRINT 'Completed inserting records into #BudgetOverheadAllocation:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocation (BudgetOverheadAllocationId,BudgetId,OverheadRegionId,BudgetEmployeeId)
PRINT 'Completed creating indexes on #BudgetOverheadAllocation'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source overhead allocation detail

CREATE TABLE #BudgetOverheadAllocationDetail(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetOverheadAllocationDetailId INT NOT NULL,
	BudgetOverheadAllocationId INT NOT NULL,
	BudgetProjectId INT NOT NULL,
	AllocationValue DECIMAL(18, 9) NOT NULL,
	AllocationAmount DECIMAL(18, 2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetOverheadAllocationDetail(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetOverheadAllocationDetailId,
	BudgetOverheadAllocationId,
	BudgetProjectId,
	AllocationValue,
	AllocationAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT 
	OverheadDetail.*
FROM			
	TapasGlobalBudgeting.BudgetOverheadAllocationDetail OverheadDetail
	
	INNER JOIN TapasGlobalBudgeting.BudgetOverheadAllocationDetailActive(@DataPriorToDate) OverheadDetailA ON
		OverheadDetail.ImportKey = OverheadDetailA.ImportKey

	-- data limiting join
	INNER JOIN #BudgetProject b ON
		OverheadDetail.BudgetProjectId = b.BudgetProjectId

PRINT 'Completed inserting records into #BudgetOverheadAllocationDetail:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
PRINT 'Completed creating indexes on #BudgetOverheadAllocationDetail'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source payroll overhead allocation detail

CREATE TABLE #OverheadAllocationDetail
(
	ImportKey INT NOT NULL,
	BudgetOverheadAllocationDetailId INT NOT NULL,
	BudgetOverheadAllocationId INT NOT NULL,
	BudgetProjectId INT NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL,
	AllocationValue DECIMAL(18, 9) NOT NULL,
	AllocationAmount DECIMAL(18, 2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #OverheadAllocationDetail
(
	ImportKey,
	BudgetOverheadAllocationDetailId,
	BudgetOverheadAllocationId,
	BudgetProjectId,
	MinorGlAccountCategoryId,
	AllocationValue,
	AllocationAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	OverheadDetail.ImportKey,
	OverheadDetail.BudgetOverheadAllocationDetailId,
	OverheadDetail.BudgetOverheadAllocationId,
	OverheadDetail.BudgetProjectId,
	@OverheadMinorGlAccountCategoryId AS MinorGlAccountCategoryId,
	OverheadDetail.AllocationValue,
	OverheadDetail.AllocationAmount,
	OverheadDetail.InsertedDate,
	OverheadDetail.UpdatedDate,
	OverheadDetail.UpdatedByStaffId
FROM

	-- Joining on allocation to limit amount of data
	#BudgetOverheadAllocation OverheadAllocation
	
	INNER JOIN #BudgetOverheadAllocationDetail OverheadDetail ON
		OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId 

PRINT 'Completed inserting records into #OverheadAllocationDetail:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #OverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
PRINT 'Completed creating indexes on #OverheadAllocationDetail'
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Map Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

--Calculate effective functional department

CREATE TABLE #EffectiveFunctionalDepartment(
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL
)

INSERT INTO #EffectiveFunctionalDepartment(
	BudgetEmployeePayrollAllocationId,
	BudgetEmployeeId,
	FunctionalDepartmentId
)
SELECT 
	Allocation.BudgetEmployeePayrollAllocationId,
	Allocation.BudgetEmployeeId,
	(
		SELECT 
			EFD.FunctionalDepartmentId
		FROM 
			(
				SELECT 
					Allocation2.BudgetEmployeeId,
					MAX(EFD.EffectivePeriod) AS EffectivePeriod
				FROM
					#BudgetEmployeePayrollAllocation Allocation2

					INNER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
						Allocation2.BudgetEmployeeId = EFD.BudgetEmployeeId
				
				WHERE
					Allocation.BudgetEmployeePayrollAllocationId = Allocation2.BudgetEmployeePayrollAllocationId AND
					EFD.EffectivePeriod <= Allocation.Period
					  
				GROUP BY
					Allocation2.BudgetEmployeeId
			) EFDo
		
			LEFT OUTER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
				EFD.BudgetEmployeeId = EFDo.BudgetEmployeeId AND
				EFD.EffectivePeriod = EFDo.EffectivePeriod
				
	 ) AS FunctionalDepartmentId
FROM
	#BudgetEmployeePayrollAllocation Allocation

	INNER JOIN #BudgetProject BudgetProject ON 
		Allocation.BudgetProjectId = BudgetProject.BudgetProjectId

PRINT 'Completed inserting records into #EffectiveFunctionalDepartment:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Pre Tax Amounts
CREATE TABLE #ProfitabilityPreTaxSource
(
	BudgetId INT NOT NULL,
	BudgetRegionId INT NOT NULL,
	FirstProjectedPeriod char(6) NOT NULL,
	ProjectId INT NOT NULL,
	HrEmployeeId INT NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	ExpensePeriod CHAR(6) NOT NULL,	
	SourceCode VARCHAR(2) NULL,
	SalaryPreTaxAmount MONEY NOT NULL,
	ProfitSharePreTaxAmount MONEY NOT NULL,
	BonusPreTaxAmount MONEY NOT NULL,
	BonusCapExcessPreTaxAmount MONEY NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	FunctionalDepartmentCode VARCHAR(31) NULL,
	Reimbursable BIT NULL,
	ActivityTypeId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	OriginatingRegionCode CHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	AllocationUpdatedDate DATETIME NOT NULL,
	BudgetReportGroupPeriod INT NOT NULL
)
-- Insert original budget amounts
INSERT INTO #ProfitabilityPreTaxSource
(
	BudgetId,
	BudgetRegionId,
	FirstProjectedPeriod,
	ProjectId,
	HrEmployeeId,
	BudgetEmployeePayrollAllocationId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	SalaryPreTaxAmount,
	ProfitSharePreTaxAmount,
	BonusPreTaxAmount,
	BonusCapExcessPreTaxAmount,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate,
	BudgetReportGroupPeriod
)
SELECT 
	Budget.BudgetId AS BudgetId,
	Budget.RegionId AS BudgetRegionId,
	Budget.FirstProjectedPeriod,
	ISNULL(BudgetProject.ProjectId,0) AS ProjectId,
	ISNULL(BudgetEmployee.HrEmployeeId,0) AS HrEmployeeId,
	Allocation.BudgetEmployeePayrollAllocationId,
	'TGB:BudgetId=' + CONVERT(varchar,Budget.BudgetId) + '&ProjectId=' + CONVERT(varchar,ISNULL(BudgetProject.ProjectId,0)) + '&HrEmployeeId=' + CONVERT(varchar,ISNULL(BudgetEmployee.HrEmployeeId,0)) + '&BudgetEmployeePayrollAllocationId=' + CONVERT(varchar,Allocation.BudgetEmployeePayrollAllocationId) + '&BudgetEmployeePayrollAllocationDetailId=0&BudgetOverheadAllocationDetailId=0' + '&ImportKey=' + CONVERT(varchar, Allocation.ImportKey) AS ReferenceCode,
	Allocation.Period AS ExpensePeriod,
	SourceRegion.SourceCode,
	ISNULL(Allocation.PreTaxSalaryAmount,0) AS SalaryPreTaxAmount,
	ISNULL(Allocation.PreTaxProfitShareAmount, 0) AS ProfitSharePreTaxAmount,
	ISNULL(Allocation.PreTaxBonusAmount,0) AS BonusPreTaxAmount, 
	ISNULL(Allocation.PreTaxBonusCapExcessAmount,0) AS BonusCapExcessPreTaxAmount,
	ISNULL(EFD.FunctionalDepartmentId, -1),
	fd.GlobalCode AS FunctionalDepartmentCode, 
	CASE WHEN BudgetProject.IsTsCost = 0 THEN 1 ELSE 0 END AS Reimbursable,
	BudgetProject.ActivityTypeId,
	
	ISNULL(CASE
				WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.PropertyFundId
				ELSE
					DepartmentPropertyFund.PropertyFundId 
			END, -1) AS PropertyFundId,
	-- Same case logic AS above
	
	ISNULL(CASE -- Same case logic as above
				WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,
			
	OriginatingRegion.CorporateEntityRef,
	OriginatingRegion.CorporateSourceCode,
	Budget.CurrencyCode AS LocalCurrencyCode,
	Allocation.UpdatedDate,
	fmrb.BudgetReportGroupPeriod
FROM
	#BudgetEmployeePayrollAllocation Allocation

	INNER JOIN #BudgetProject BudgetProject ON 
		Allocation.BudgetProjectId = BudgetProject.BudgetProjectId
			
	INNER JOIN  #FilteredModifiedReportBudget fmrb ON
		BudgetProject.BudgetId = fmrb.BudgetId
			
	INNER JOIN #Budget Budget ON 
		fmrb.BudgetId = Budget.BudgetId 
		
	LEFT OUTER JOIN #Region SourceRegion ON 
		Budget.RegionId = SourceRegion.RegionId

	LEFT OUTER JOIN #EffectiveFunctionalDepartment efd ON
		Allocation.BudgetEmployeePayrollAllocationId = efd.BudgetEmployeePayrollAllocationId

	LEFT OUTER JOIN #FunctionalDepartment fd ON 
		efd.FunctionalDepartmentId = fd.FunctionalDepartmentId

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON GrSc.SourceCode = BudgetProject.CorporateSourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		BudgetProject.CorporateSourceCode = pfm.SourceCode AND
		pfm.IsDeleted = 0 AND 
		(
			(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = BudgetProject.ActivityTypeId)
				OR
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
			)
		) AND
		fmrb.BudgetReportGroupPeriod < 201007
	
	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		RECD.SourceCode = BudgetProject.CorporateSourceCode AND
		fmrb.BudgetReportGroupPeriod >= 201007 AND			   
		RECD.IsDeleted = 0
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		REPE.SourceCode = BudgetProject.CorporateSourceCode AND
		fmrb.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0	
	
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN fmrb.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END

	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId

	LEFT OUTER JOIN #BudgetEmployee BudgetEmployee ON
		Allocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId
		
	LEFT OUTER JOIN #Location Location ON 
		Location.LocationId = BudgetEmployee.LocationId
		
	LEFT OUTER JOIN #PayrollRegion OriginatingRegion ON 
		Location.ExternalSubRegionId = OriginatingRegion.ExternalSubRegionId AND
		Budget.RegionId = OriginatingRegion.RegionId

WHERE
	Allocation.Period BETWEEN fmrb.BudgetFirstProjectedPeriod AND fmrb.GroupEndPeriod AND
	BudgetProject.ActivityTypeId <> 99 -- exclude Corporate Overhead

PRINT 'Completed inserting records into #ProfitabilityPreTaxSource:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE INDEX IX_SalaryPreTaxAmount ON #ProfitabilityPreTaxSource (SalaryPreTaxAmount)
CREATE INDEX IX_ProfitSharePreTaxAmount ON #ProfitabilityPreTaxSource (ProfitSharePreTaxAmount)
CREATE INDEX IX_BonusPreTaxAmount ON #ProfitabilityPreTaxSource (BonusPreTaxAmount)
CREATE INDEX IX_BonusCapExcessPreTaxAmount ON #ProfitabilityPreTaxSource (BonusCapExcessPreTaxAmount)

PRINT 'Completed creating indexes on #ProfitabilityPreTaxSource'
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Tax Amounts

CREATE TABLE #ProfitabilityTaxSource
(
	BudgetId INT NOT NULL,
	BudgetRegionId INT NOT NULL,
	FirstProjectedPeriod CHAR(6) NOT NULL,
	ProjectId INT NOT NULL,
	HrEmployeeId INT NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	ExpensePeriod CHAR(6) NOT NULL,	
	SourceCode VARCHAR(2) NULL,
	SalaryTaxAmount MONEY NOT NULL,
	ProfitShareTaxAmount MONEY NOT NULL,
	BonusTaxAmount MONEY NOT NULL,
	BonusCapExcessTaxAmount MONEY NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	FunctionalDepartmentCode VARCHAR(31) NULL,
	Reimbursable BIT NULL,
	ActivityTypeId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	OriginatingRegionCode CHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	AllocationUpdatedDate DATETIME NOT NULL,
	BudgetReportGroupPeriod INT NOT NULL,
)
--/*
-- Insert original budget amounts
INSERT INTO #ProfitabilityTaxSource
(
	BudgetId,
	BudgetRegionId,
	FirstProjectedPeriod,
	ProjectId,
	HrEmployeeId,
	BudgetEmployeePayrollAllocationId,
	BudgetEmployeePayrollAllocationDetailId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	SalaryTaxAmount,
	ProfitShareTaxAmount,
	BonusTaxAmount,
	BonusCapExcessTaxAmount,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate,
	BudgetReportGroupPeriod
)
SELECT 
	pts.BudgetId,
	pts.BudgetRegionId,
	pts.FirstProjectedPeriod,
	ISNULL(pts.ProjectId,0) AS ProjectId,
	ISNULL(pts.HrEmployeeId,0) AS HrEmployeeId,
	pts.BudgetEmployeePayrollAllocationId,
	TaxDetail.BudgetEmployeePayrollAllocationDetailId,
	'TGB:BudgetId=' + CONVERT(varchar,pts.BudgetId) + '&ProjectId=' + CONVERT(varchar,ISNULL(pts.ProjectId,0)) + '&HrEmployeeId=' + CONVERT(varchar,ISNULL(pts.HrEmployeeId,0)) + '&BudgetEmployeePayrollAllocationId=' + CONVERT(varchar,pts.BudgetEmployeePayrollAllocationId) + '&BudgetEmployeePayrollAllocationDetailId=' + CONVERT(varchar,TaxDetail.BudgetEmployeePayrollAllocationDetailId) + '&BudgetOverheadAllocationDetailId=0' + '&ImportKey=' + CONVERT(varchar, TaxDetail.ImportKey) AS ReferenceCode,
	pts.ExpensePeriod,
	pts.SourceCode,
	ISNULL(TaxDetail.SalaryAmount, 0) AS SalaryTaxAmount,
	ISNULL(TaxDetail.ProfitShareAmount, 0) AS ProfitShareTaxAmount,
	ISNULL(TaxDetail.BonusAmount, 0) AS BonusTaxAmount,
	ISNULL(TaxDetail.BonusCapExcessAmount, 0) AS BonusCapExcessTaxAmount,
	TaxDetail.MinorGlAccountCategoryId,
	ISNULL(pts.FunctionalDepartmentId, -1),
	pts.FunctionalDepartmentCode, 
	pts.Reimbursable,
	pts.ActivityTypeId,
	pts.PropertyFundId,
	ISNULL(PF.AllocationSubRegionGlobalRegionId, -1) AS AllocationSubRegionGlobalRegionId,
	pts.OriginatingRegionCode,
	pts.OriginatingRegionSourceCode,
	pts.LocalCurrencyCode,
	pts.AllocationUpdatedDate,
	pts.BudgetReportGroupPeriod
FROM
	#EmployeePayrollAllocationDetail TaxDetail

	INNER JOIN #ProfitabilityPreTaxSource pts ON
		TaxDetail.BudgetEmployeePayrollAllocationId = pts.BudgetEmployeePayrollAllocationId
		
	LEFT OUTER JOIN #PropertyFund PF ON
		pts.PropertyFundId = PF.PropertyFundId

PRINT 'Completed inserting records into #ProfitabilityTaxSource:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Overhead Amounts

CREATE TABLE #ProfitabilityOverheadSource
(
	BudgetId INT NOT NULL,
	FirstProjectedPeriod CHAR(6) NOT NULL,
	ProjectId INT NOT NULL,
	HrEmployeeId INT NOT NULL,
	BudgetOverheadAllocationDetailId INT NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	ExpensePeriod CHAR(6) NOT NULL,	
	SourceCode VARCHAR(2) NULL,
	OverheadAllocationAmount MONEY NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	FunctionalDepartmentCode VARCHAR(31) NULL,
	Reimbursable BIT NULL,
	ActivityTypeId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	OriginatingRegionCode CHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	OverheadUpdatedDate DATETIME NOT NULL
)
-- Insert original overhead amounts
INSERT INTO #ProfitabilityOverheadSource
(
	BudgetId,
	FirstProjectedPeriod,
	ProjectId,
	HrEmployeeId,
	BudgetOverheadAllocationDetailId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	OverheadAllocationAmount,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,	
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	OverheadUpdatedDate
)
SELECT
	Budget.BudgetId AS BudgetId,
	Budget.FirstProjectedPeriod,
	ISNULL(BudgetProject.ProjectId,0) AS ProjectId,
	ISNULL(BudgetEmployee.HrEmployeeId,0) AS HrEmployeeId,
	OverheadDetail.BudgetOverheadAllocationDetailId,
	'TGB:BudgetId=' + CONVERT(varchar,Budget.BudgetId) + '&ProjectId=' + CONVERT(varchar,ISNULL(BudgetProject.ProjectId,0)) + '&HrEmployeeId=' + CONVERT(varchar,ISNULL(BudgetEmployee.HrEmployeeId,0)) + '&BudgetEmployeePayrollAllocationId=0&BudgetEmployeePayrollAllocationDetailId=0' + '&BudgetOverheadAllocationDetailId=' + CONVERT(varchar,OverheadDetail.BudgetOverheadAllocationDetailId) + '&ImportKey=' + CONVERT(varchar, OverheadDetail.ImportKey) AS ReferenceCode,
	OverheadAllocation.BudgetPeriod AS ExpensePeriod,
	SourceRegion.SourceCode,
	ISNULL(OverheadDetail.AllocationAmount,0) AS OverheadAllocationAmount,
	OverheadDetail.MinorGlAccountCategoryId,
	ISNULL(RegionExtended.OverheadFunctionalDepartmentId, -1) AS FunctionalDepartmentId,
	fd.GlobalCode AS FunctionalDepartmentCode, 
	
	CASE
		WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
			CASE
				WHEN (BudgetProject.IsTsCost = 0) THEN -- Where ISTSCost is False the cost will be reimbursable
					1 
				ELSE
					0
			END
		ELSE
			0  --Where the BudgetProject.OverheadAllocationProjectID is populated: non-reimbursable
	END AS Reimbursable,
	
	BudgetProject.ActivityTypeId,
	
	CASE WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
		ISNULL(CASE WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.PropertyFundId
				ELSE 
					DepartmentPropertyFund.PropertyFundId 
				END, -1) 
	ELSE 
		ISNULL(OverheadPropertyFund.PropertyFundId, -1) 
	END AS PropertyFundId,
	
	ISNULL(CASE -- Same case logic as above
				WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,		
	
	OriginatingRegion.CorporateEntityRef,
	OriginatingRegion.CorporateSourceCode,
	Budget.CurrencyCode AS LocalCurrencyCode,
	OverheadDetail.UpdatedDate

FROM
	#BudgetOverheadAllocation OverheadAllocation 

	INNER JOIN #BudgetEmployee BudgetEmployee ON
		OverheadAllocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId

	INNER JOIN #OverheadAllocationDetail OverheadDetail ON
		OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId
			
	INNER JOIN #BudgetProject BudgetProject ON 
		OverheadDetail.BudgetProjectId = BudgetProject.BudgetProjectId
		
	INNER JOIN #FilteredModifiedReportBudget fmrb ON
		BudgetProject.BudgetId = fmrb.BudgetId
		
	INNER JOIN #Budget Budget ON 
		fmrb.BudgetId = Budget.BudgetId
		
	LEFT OUTER JOIN #Region SourceRegion ON 
		Budget.RegionId = SourceRegion.RegionId
		
	LEFT OUTER JOIN #RegionExtended RegionExtended ON 
		SourceRegion.RegionId = RegionExtended.RegionId

	LEFT OUTER JOIN #FunctionalDepartment fd ON 
		RegionExtended.OverheadFunctionalDepartmentId = fd.FunctionalDepartmentId

	LEFT OUTER JOIN	#Project OverheadProject ON
		BudgetProject.AllocateOverheadsProjectId = OverheadProject.ProjectId

	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId
	
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON GrSc.SourceCode = BudgetProject.CorporateSourceCode
	
	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		BudgetProject.CorporateSourceCode = pfm.SourceCode AND
		--ISNULL(BudgetProject.ActivityTypeId, -1) = ISNULL(pfm.ActivityTypeId, -1) AND 
		pfm.IsDeleted = 0 AND 
		(
			(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = BudgetProject.ActivityTypeId)
				OR
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
			)
		) AND
		fmrb.BudgetReportGroupPeriod < 201007
	
	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		RECD.SourceCode = BudgetProject.CorporateSourceCode AND
		fmrb.BudgetReportGroupPeriod >= 201007 AND
		RECD.IsDeleted = 0
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		REPE.SourceCode = BudgetProject.CorporateSourceCode AND
		fmrb.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0	
	
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN fmrb.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrScO ON GrScO.SourceCode = OverheadProject.CorporateSourceCode

	LEFT OUTER JOIN #PropertyFundMapping opfm ON
		OverheadProject.CorporateDepartmentCode = opfm.PropertyFundCode AND -- Combination of entity and corporate department
		OverheadProject.CorporateSourceCode = opfm.SourceCode AND
		--ISNULL(BudgetProject.ActivityTypeId, -1) = ISNULL(opfm.ActivityTypeId, -1) AND 
		opfm.IsDeleted = 0 AND 
		(
			(GrScO.IsProperty = 'YES' AND opfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrScO.IsCorporate = 'YES' AND opfm.ActivityTypeId = BudgetProject.ActivityTypeId)
				OR
				(GrScO.IsCorporate = 'YES' AND opfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
			)
		) AND
		fmrb.BudgetReportGroupPeriod < 201007
	
	LEFT OUTER JOIN #PropertyFund OverheadPropertyFund ON
		OverheadPropertyFund.PropertyFundId =	
			CASE
				WHEN fmrb.BudgetReportGroupPeriod < 201007 THEN opfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END
	
	LEFT OUTER JOIN #OverheadRegion OriginatingRegion ON 
		OverheadAllocation.OverheadRegionId = OriginatingRegion.OverheadRegionId
		
WHERE
	OverheadAllocation.BudgetPeriod BETWEEN fmrb.BudgetFirstProjectedPeriod AND fmrb.GroupEndPeriod
		
PRINT 'Completed inserting records into #ProfitabilityOverheadSource:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Generate mapping records
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


CREATE TABLE #ProfitabilityPayrollMapping
(
	BudgetId INT NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	FirstProjectedPeriod CHAR(6) NOT NULL,
	ExpensePeriod CHAR(6) NOT NULL,	
	SourceCode VARCHAR(2) NULL,
	BudgetAmount MONEY NOT NULL,
	MajorGlAccountCategoryId INT NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	FunctionalDepartmentCode VARCHAR(31) NULL,
	Reimbursable BIT NOT NULL,
	ActivityTypeId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	OriginatingRegionCode CHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	AllocationUpdatedDate DATETIME NOT NULL
)

INSERT INTO #ProfitabilityPayrollMapping
(
	BudgetId,
	ReferenceCode,
	FirstProjectedPeriod,
	ExpensePeriod,
	SourceCode,
	BudgetAmount,
	MajorGlAccountCategoryId,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate
)
-- Get Base Salary Payroll pre tax mappings and budget
SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=SalaryPreTax' AS ReferenceCode,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.SalaryPreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MinorGlAccountCategoryId,
	@BaseSalaryMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityPreTaxSource pps
WHERE
	pps.SalaryPreTaxAmount <> 0

-- Get Profit Share Benefit pre tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=ProfitSharePreTax' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.ProfitSharePreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MinorGlAccountCategoryId,
	@ProfitShareMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityPreTaxSource pps
WHERE
	pps.ProfitSharePreTaxAmount <> 0

-- Get Bonus pre tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusPreTax' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusPreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MinorGlAccountCategoryId,
	@BonusMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityPreTaxSource pps
WHERE
	pps.BonusPreTaxAmount <> 0

--Get bonus cap pre tax mappings
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusCapExcessPreTax' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusCapExcessPreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MinorGlAccountCategoryId,
	@BonusMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	0 AS Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
	ISNULL(p.ActivityTypeId, -1) AS ActivityTypeId,

	ISNULL(CASE
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.PropertyFundId
				ELSE
					DepartmentPropertyFund.PropertyFundId 
			END, -1) AS PropertyFundId,
	-- Same case logic AS above

	ISNULL(CASE -- Same case logic as above
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,

	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityPreTaxSource pps
	
	LEFT OUTER JOIN #SystemSettingRegion ssr ON
		pps.SourceCode = ssr.SourceCode AND
		pps.BudgetRegionId = ssr.RegionId AND
		ssr.SystemSettingName = 'BonusCapExcess'
		
	LEFT OUTER JOIN #Project p ON
		ssr.BonusCapExcessProjectId = p.ProjectId
			
	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		p.PropertyFundId = ProjectPropertyFund.PropertyFundId
		
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		GrSc.SourceCode = p.CorporateSourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		p.CorporateSourceCode = pfm.SourceCode AND
		pfm.IsDeleted = 0 AND 
		(
			(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = p.ActivityTypeId)
				OR
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
			)
		) AND
		pps.BudgetReportGroupPeriod < 201007

	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		RECD.SourceCode = p.CorporateSourceCode AND
		pps.BudgetReportGroupPeriod >= 201007 AND			   
		RECD.IsDeleted = 0

	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		REPE.SourceCode = p.CorporateSourceCode AND
		pps.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0	

	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN pps.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END
		
WHERE
	pps.BonusCapExcessPreTaxAmount <> 0

UNION ALL

-- Get Base Salary Payroll Tax mappings and budget
SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=SalaryTax' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.SalaryTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.SalaryTaxAmount <> 0

-- Get Profit Share Benefit Tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=ProfitShareTax' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.ProfitShareTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.ProfitShareTaxAmount <> 0

-- Get Bonus Tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusTax' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.BonusTaxAmount <> 0

-- Get Bonus cap Tax mappings 
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusCapExcessTax' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusCapExcessTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	0 AS Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
	ISNULL(p.ActivityTypeId, -1) AS ActivityTypeId,
	
	ISNULL(CASE
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.PropertyFundId
				ELSE
					DepartmentPropertyFund.PropertyFundId 
			END, -1) AS PropertyFundId,
	-- Same case logic AS above

	ISNULL(CASE -- Same case logic as above
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,

	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityTaxSource pps

	LEFT OUTER JOIN #SystemSettingRegion ssr ON
		pps.SourceCode = ssr.SourceCode AND
		pps.BudgetRegionId = ssr.RegionId AND
		ssr.SystemSettingName = 'BonusCapExcess'

	LEFT OUTER JOIN #Project p ON
		ssr.BonusCapExcessProjectId = p.ProjectId

	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		p.PropertyFundId = ProjectPropertyFund.PropertyFundId

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		GrSc.SourceCode = p.CorporateSourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		p.CorporateSourceCode = pfm.SourceCode AND
		pfm.IsDeleted = 0 AND 
		(
			(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = p.ActivityTypeId)
				OR
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
			)
		) AND
		pps.BudgetReportGroupPeriod < 201007

	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		RECD.SourceCode = p.CorporateSourceCode AND
		pps.BudgetReportGroupPeriod >= 201007 AND			   
		RECD.IsDeleted = 0
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		REPE.SourceCode = p.CorporateSourceCode AND
		pps.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0

	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN pps.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END

WHERE
	pps.BonusCapExcessTaxAmount <> 0
	
-- Get Overhead mappings	
UNION ALL

SELECT
	pos.BudgetId,
	pos.ReferenceCode + '&Type=OverheadAllocation' AS ReferenceCod,
	pos.FirstProjectedPeriod,
	pos.ExpensePeriod,
	pos.SourceCode,
	pos.OverheadAllocationAmount AS BudgetAmount,
	@OccupancyCostsMajorGlAccountCategoryId AS MinorGlAccountCategoryId,
	pos.MinorGlAccountCategoryId, 
	pos.FunctionalDepartmentId,
	pos.FunctionalDepartmentCode,
	pos.Reimbursable,  
	pos.ActivityTypeId,
	pos.PropertyFundId,
	pos.AllocationSubRegionGlobalRegionId,
	pos.OriginatingRegionCode,
	pos.OriginatingRegionSourceCode,
	pos.LocalCurrencyCode,
	pos.OverheadUpdatedDate
FROM
	#ProfitabilityOverheadSource pos
WHERE
	pos.OverheadAllocationAmount <> 0

PRINT 'Completed inserting records into #ProfitabilityPayrollMapping:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_AllocationUpdatedDate ON #ProfitabilityPayrollMapping(ReferenceCode,AllocationUpdatedDate)
PRINT 'Completed creating indexes on #ProfitabilityPayrollMapping'
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Map mapped source data into the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

------------------------------------------------------------------------------------------------------
-- Additional required mappings
------------------------------------------------------------------------------------------------------

-- #OriginatingRegionCorporateEntity

CREATE TABLE #OriginatingRegionCorporateEntity( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	OriginatingRegionCorporateEntityId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	CorporateEntityCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL	
)

INSERT INTO #OriginatingRegionCorporateEntity(
	ImportKey,
	OriginatingRegionCorporateEntityId,
	GlobalRegionId,
	CorporateEntityCode,
	SourceCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted
)
SELECT
	ORCE.ImportKey,
	ORCE.OriginatingRegionCorporateEntityId,
	ORCE.GlobalRegionId,
	ORCE.CorporateEntityCode,
	ORCE.SourceCode,
	ORCE.InsertedDate,
	ORCE.UpdatedDate,
	ORCE.IsDeleted	
FROM
	Gdm.OriginatingRegionCorporateEntity ORCE
	INNER JOIN Gdm.OriginatingRegionCorporateEntityActive (@DataPriorToDate) ORCEA ON
		ORCEA.ImportKey = ORCE.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #OriginatingRegionCorporateEntity (CorporateEntityCode, SourceCode, IsDeleted, GlobalRegionId)

PRINT 'Completed creating indexes on #OriginatingRegionCorporateEntity'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- #OriginatingRegionPropertyDepartment

CREATE TABLE #OriginatingRegionPropertyDepartment( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	OriginatingRegionPropertyDepartmentId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	PropertyDepartmentCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL	
)

INSERT INTO #OriginatingRegionPropertyDepartment(
	ImportKey,
	OriginatingRegionPropertyDepartmentId,
	GlobalRegionId,
	PropertyDepartmentCode,
	SourceCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted
)
SELECT
	ORPD.ImportKey,
	ORPD.OriginatingRegionPropertyDepartmentId,
	ORPD.GlobalRegionId,
	ORPD.PropertyDepartmentCode,
	ORPD.SourceCode,
	ORPD.InsertedDate,
	ORPD.UpdatedDate,
	ORPD.IsDeleted
FROM
	Gdm.OriginatingRegionPropertyDepartment ORPD
	INNER JOIN Gdm.OriginatingRegionPropertyDepartmentActive(@DataPriorToDate) ORPDA ON
		ORPDA.ImportKey = ORPD.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #OriginatingRegionPropertyDepartment (PropertyDepartmentCode, SourceCode, IsDeleted, GlobalRegionId)

PRINT 'Completed inserting records into #OriginatingRegionMapping:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Allocation Region Mappings

CREATE TABLE #AllocationSubRegion(
	ImportKey INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	ProjectCodePortion VARCHAR(2) NOT NULL,
	AllocationRegionGlobalRegionId INT NULL,
	DefaultCurrencyCode CHAR(3) NOT NULL,
	CountryId INT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

-- #AllocationSubRegion

INSERT INTO #AllocationSubRegion(
	ImportKey,
	AllocationSubRegionGlobalRegionId,
	Code,
	[Name],
	ProjectCodePortion,
	AllocationRegionGlobalRegionId,
	DefaultCurrencyCode,
	CountryId,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	ASR.ImportKey,
	ASR.AllocationSubRegionGlobalRegionId,
	ASR.Code,
	ASR.[Name],
	ASR.ProjectCodePortion,
	ASR.AllocationRegionGlobalRegionId,
	ASR.DefaultCurrencyCode,
	ASR.CountryId,
	ASR.IsActive,
	ASR.InsertedDate,
	ASR.UpdatedDate,
	ASR.UpdatedByStaffId
FROM
	Gdm.AllocationSubRegion ASR
	INNER JOIN	Gdm.AllocationSubRegionActive(@DataPriorToDate) ASRA ON
		ASRA.ImportKey = ASR.ImportKey

PRINT 'Completed inserting records into #AllocationRegionMapping:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

------------------------------------------------------------------------------------------------------
-- Map to the fact
------------------------------------------------------------------------------------------------------
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--If the join is not possible, default the link to the 'UNKNOWN' link
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityReforecast(
	CalendarKey INT NOT NULL,
	ReforecastKey INT NOT NULL,
	GlAccountKey INT NOT NULL,
	SourceKey INT NOT NULL,
	FunctionalDepartmentKey INT NOT NULL,
	ReimbursableKey INT NOT NULL,
	ActivityTypeKey INT NOT NULL,
	PropertyFundKey INT NOT NULL,	
	AllocationRegionKey INT NOT NULL,
	OriginatingRegionKey INT NOT NULL,
	LocalCurrencyKey INT NOT NULL,
	LocalReforecast MONEY NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	BudgetId INT NOT NULL,
	SourceSystemId INT NOT NULL,
	
	EUCorporateGlAccountCategoryKey INT NULL,
	EUPropertyGlAccountCategoryKey INT NULL,
	EUFundGlAccountCategoryKey INT NULL,

	USPropertyGlAccountCategoryKey INT NULL,
	USCorporateGlAccountCategoryKey INT NULL,
	USFundGlAccountCategoryKey INT NULL,

	GlobalGlAccountCategoryKey INT NULL,
	DevelopmentGlAccountCategoryKey INT NULL
) 

INSERT INTO #ProfitabilityReforecast 
(
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	SourceSystemId
)
SELECT
	DATEDIFF(dd, '1900-01-01', LEFT(pbm.ExpensePeriod,4)+'-'+RIGHT(pbm.ExpensePeriod,2)+'-01') AS CalendarKey,
	DATEDIFF(dd, '1900-01-01', LEFT(pbm.FirstProjectedPeriod,4)+'-'+RIGHT(pbm.FirstProjectedPeriod,2)+'-01') AS ReforecastKey,
	@GlAccountKeyUnknown GlAccountKey,
	CASE WHEN GrSc.[SourceKey] IS NULL THEN @SourceKeyUnknown ELSE GrSc.[SourceKey] END SourceKey,
	CASE WHEN GrFdm.[FunctionalDepartmentKey] IS NULL THEN @FunctionalDepartmentKeyUnknown ELSE GrFdm.[FunctionalDepartmentKey] END FunctionalDepartmentKey,
	CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKeyUnknown ELSE GrRi.ReimbursableKey END ReimbursableKey,
	CASE WHEN GrAt.[ActivityTypeKey] IS NULL THEN @ActivityTypeKeyUnknown ELSE GrAt.[ActivityTypeKey] END ActivityTypeKey,
	CASE WHEN GrPf.[PropertyFundKey] IS NULL THEN @PropertyFundKeyUnknown ELSE GrPf.[PropertyFundKey] END PropertyFundKey,
	CASE WHEN GrAr.[AllocationRegionKey] IS NULL THEN @AllocationRegionKeyUnknown ELSE GrAr.[AllocationRegionKey] END AllocationRegionKey,
	CASE WHEN GrOr.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKeyUnknown ELSE GrOr.[OriginatingRegionKey] END OriginatingRegionKey,
	CASE WHEN GrCu.[CurrencyKey] IS NULL THEN @LocalCurrencyKeyUnknown ELSE GrCu.[CurrencyKey] END LocalCurrencyKey,
	pbm.BudgetAmount,
	pbm.ReferenceCode,
	pbm.BudgetId,
	@SourceSystemId
FROM
	#ProfitabilityPayrollMapping pbm
	
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		pbm.SourceCode = GrSc.SourceCode

	--Parent Level (No job code for payroll)
	LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdm ON
		GrFdm.ReferenceCode LIKE pbm.FunctionalDepartmentCode +':%' AND
		pbm.AllocationUpdatedDate BETWEEN GrFdm.StartDate AND GrFdm.EndDate AND
		GrFdm.SubFunctionalDepartmentCode = GrFdm.FunctionalDepartmentCode

	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		CASE WHEN pbm.Reimbursable = 1 THEN 'YES' ELSE 'NO' END = GrRi.ReimbursableCode

	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		pbm.ActivityTypeId = GrAt.ActivityTypeId AND
		pbm.AllocationUpdatedDate BETWEEN GrAt.StartDate AND GrAt.EndDate

	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		pbm.PropertyFundId = GrPf.PropertyFundId AND
		pbm.AllocationUpdatedDate BETWEEN GrPf.StartDate AND GrPf.EndDate

	-- HACK: At some point tapas was supposed to pull project region out of GDM. 
	-- Now allocation regions are source based??? So I use the code because it is built up from the ProjectRegionId since there is only data for one source anyway.
	-- I don't check source because actuals also don't check source. 
	--LEFT OUTER JOIN #AllocationRegionMapping Arm ON
	--	Arm.RegionCode = pbm.ProjectRegionId AND -- TODO: Pull the RegionCode through from the top.
	--	Arm.IsDeleted = 0
	
	LEFT OUTER JOIN #AllocationSubRegion ASR ON
		pbm.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId		

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		ASR.AllocationSubRegionGlobalRegionId = GrAr.GlobalRegionId AND
		pbm.AllocationUpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate

/* -- At some point Allocation region in GDM was going to become the master list
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		pbm.ProjectRegionId = GrAr.GlobalRegionId AND
		pbm.AllocationUpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate
*/

	--LEFT OUTER JOIN #OriginatingRegionMapping Orm ON
	--	Orm.RegionCode = CASE WHEN RIGHT(pbm.OriginatingRegionSourceCode,1) = 'C' THEN LTRIM(RTRIM(pbm.OriginatingRegionCode))
	--							ELSE LTRIM(RTRIM(pbm.OriginatingRegionCode)) + LTRIM(RTRIM(pbm.FunctionalDepartmentCode)) END AND
	--	Orm.SourceCode = pbm.OriginatingRegionSourceCode AND
	--	Orm.IsDeleted = 0
		
	LEFT OUTER JOIN #OriginatingRegionCorporateEntity ORCE ON
		ORCE.CorporateEntityCode = LTRIM(RTRIM(pbm.OriginatingRegionCode)) AND
		ORCE.SourceCode = pbm.OriginatingRegionSourceCode AND
		ORCE.IsDeleted = 0
		   
	LEFT OUTER JOIN #OriginatingRegionPropertyDepartment ORPD ON
		ORPD.PropertyDepartmentCode = LTRIM(RTRIM(pbm.OriginatingRegionCode)) AND
		ORPD.SourceCode = pbm.OriginatingRegionSourceCode AND
		ORPD.IsDeleted = 0			
		
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		GrOr.GlobalRegionId = ISNULL(ORCE.GlobalRegionId, ORPD.GlobalRegionId) AND
		pbm.AllocationUpdatedDate BETWEEN GrOr.StartDate AND GrOr.EndDate
	
	LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
		pbm.LocalCurrencyCode = GrCu.CurrencyCode 

PRINT 'Completed inserting records into #ProfitabilityReforecast:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProfitabilityReforecast (ReferenceCode)
CREATE INDEX IX_CalendarKey ON #ProfitabilityReforecast (CalendarKey)

PRINT 'Completed creating indexes on #OriginatingRegionMapping'
PRINT CONVERT(Varchar(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Remove existing data for modified budget projects
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #DeletingBudget
(
	BudgetId INT NOT NULL
)

INSERT INTO #DeletingBudget
(
	BudgetId
)
SELECT DISTINCT 
	BudgetId
FROM
	#Budget

DECLARE @BudgetId INT = -1
DECLARE @LoopCount INT = 0 -- Infinite loop safe guard

WHILE (EXISTS (SELECT TOP 1 BudgetId FROM #DeletingBudget) AND @LoopCount < 100000)
BEGIN
	
	SET @LoopCount = @LoopCount + 1
	SET @BudgetId = (SELECT TOP 1 BudgetId FROM #DeletingBudget)


	DECLARE @row Int = 1
	DECLARE @deleteCnt Int = 0
	WHILE (@row > 0)
		BEGIN
		-- Remove old facts
		DELETE TOP (100000)
		FROM GrReporting.dbo.ProfitabilityReforecast 
		Where BudgetId = @BudgetId and SourceSystemId = @SourceSystemId
		
		SET @row = @@rowcount
		SET @deleteCnt = @deleteCnt + @row
		
		PRINT '>>>:'+CONVERT(char(10),@row)
		PRINT CONVERT(Varchar(27), getdate(), 121)
		
		END
		
	PRINT 'Rows Deleted from ProfitabilityReforecast:'+CONVERT(char(10),@deleteCnt)
	PRINT CONVERT(Varchar(27), getdate(), 121)
	
	

	DELETE FROM #DeletingBudget WHERE BudgetId = @BudgetId
END

print 'Cleaned up rows in ProfitabilityReforecast'

------------------------------------------------------------------------------------------------------
-- Map account categories
------------------------------------------------------------------------------------------------------

--GlobalGlAccountCategoryKey

CREATE TABLE #GlobalCategoryLookup(
	GlAccountCategoryKey INT NULL,
	ReferenceCode VARCHAR(300) NOT NULL
)

INSERT INTO #GlobalCategoryLookup(
	GlAccountCategoryKey,
	ReferenceCode
)
SELECT 
	GlAcGlobal.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT 
			GlAcHg.GLTranslationTypeId,
			GlAcHg.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			GlAcHg.GLAccountTypeId,
			GlAcHg.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode
		 FROM	
			#ProfitabilityPayrollMapping Gl				
			CROSS JOIN (
							SELECT
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#GLAccountCategoryTranslations ACT
							WHERE
								ACT.GLTranslationSubTypeCode = 'GL'

						) GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcGlobal ON GlAcGlobal.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0)))

			AND Gl.AllocationUpdatedDate BETWEEN GlAcGlobal.StartDate AND GlAcGlobal.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #GlobalCategoryLookup (ReferenceCode)

UPDATE
	#ProfitabilityReforecast
SET
	GlobalGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END
FROM
	#GlobalCategoryLookup t1
WHERE
	t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode

PRINT 'Completed converting all GlobalGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


/*--EUCorporateGlAccountCategoryKey

CREATE TABLE #EUCorpCategoryLookup(
	GlAccountCategoryKey INT NULL,
	ReferenceCode varchar(300) NOT NULL
)

INSERT INTO #EUCorpCategoryLookup(
	GlAccountCategoryKey,
	ReferenceCode
)
SELECT 
	GlAcEUCorp.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT
			GlAcHg.GLTranslationTypeId,
			GlAcHg.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			GlAcHg.GLAccountTypeId,
			GlAcHg.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode
			
		FROM	
			#ProfitabilityPayrollMapping Gl
			CROSS JOIN (
							SELECT
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#GLAccountCategoryTranslations ACT
							WHERE
								ACT.GLTranslationSubTypeCode = 'EU CORP'

						) GlAcHg
	) Gl
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUCorp ON GlAcEUCorp.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0)))
								 
			AND Gl.AllocationUpdatedDate BETWEEN GlAcEUCorp.StartDate AND GlAcEUCorp.EndDate	
				
CREATE UNIQUE CLUSTERED INDEX IX ON #EUCorpCategoryLookup (ReferenceCode)

UPDATE
	#ProfitabilityReforecast
SET
	EUCorporateGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @EUCorporateGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END 
FROM
	#EUCorpCategoryLookup t1
WHERE
	t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode

PRINT 'Completed converting all EUCorporateGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--EUPropertyGlAccountCategoryKey

CREATE TABLE #EUPropCategoryLookup(
	GlAccountCategoryKey INT NULL,
	ReferenceCode varchar(300) NOT NULL
)

INSERT INTO #EUPropCategoryLookup(
	GlAccountCategoryKey,
	ReferenceCode
)
SELECT
	GlAcEUProp.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT 
			GlAcHg.GLTranslationTypeId,
			GlAcHg.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			GlAcHg.GLAccountTypeId,
			GlAcHg.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode
		 FROM	
			#ProfitabilityPayrollMapping Gl				
			CROSS JOIN (
							SELECT
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#GLAccountCategoryTranslations ACT
							WHERE
								ACT.GLTranslationSubTypeCode = 'EU PROP'

						) GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUProp ON GlAcEUProp.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0)))

			AND Gl.AllocationUpdatedDate BETWEEN GlAcEUProp.StartDate AND GlAcEUProp.EndDate
			
CREATE UNIQUE CLUSTERED INDEX IX ON #EUPropCategoryLookup (ReferenceCode)

UPDATE
	#ProfitabilityReforecast
SET
	EUPropertyGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @EUPropertyGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END
FROM
	#EUPropCategoryLookup t1
WHERE
	t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode


PRINT 'Completed converting all EUPropertyGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--EUFundGlAccountCategoryKey

CREATE TABLE #EUFundCategoryLookup(
	GlAccountCategoryKey INT NULL,
	ReferenceCode varchar(300) NOT NULL
)

INSERT INTO #EUFundCategoryLookup(
	GlAccountCategoryKey,
	ReferenceCode
)
SELECT 
	GlAcEUFund.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT 
			GlAcHg.GLTranslationTypeId,
			GlAcHg.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			GlAcHg.GLAccountTypeId,
			GlAcHg.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode
		 FROM	
			#ProfitabilityPayrollMapping Gl				
			CROSS JOIN (
							SELECT
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#GLAccountCategoryTranslations ACT
							WHERE
								ACT.GLTranslationSubTypeCode = 'EU FUND'

						) GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUFund ON GlAcEUFund.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0)))

			AND Gl.AllocationUpdatedDate BETWEEN GlAcEUFund.StartDate AND GlAcEUFund.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #EUFundCategoryLookup (ReferenceCode)

UPDATE
	#ProfitabilityReforecast
SET
	EUFundGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @EUFundGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END
FROM
	#EUFundCategoryLookup t1
WHERE
	t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode

PRINT 'Completed converting all EUFundGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--USPropertyGlAccountCategoryKey

CREATE TABLE #USPropCategoryLookup(
	GlAccountCategoryKey INT NULL,
	ReferenceCode VARCHAR(300) NOT NULL
)

INSERT INTO #USPropCategoryLookup(
	GlAccountCategoryKey,
	ReferenceCode
)
SELECT 
	GlAcUSProp.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT 
			GlAcHg.GLTranslationTypeId,
			GlAcHg.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			GlAcHg.GLAccountTypeId,
			GlAcHg.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode
		 FROM	
			#ProfitabilityPayrollMapping Gl				
			CROSS JOIN (
							SELECT
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#GLAccountCategoryTranslations ACT
							WHERE
								ACT.GLTranslationSubTypeCode = 'US PROP'

						) GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSProp ON GlAcUSProp.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0)))

			AND Gl.AllocationUpdatedDate BETWEEN GlAcUSProp.StartDate AND GlAcUSProp.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #USPropCategoryLookup (ReferenceCode)

UPDATE
	#ProfitabilityReforecast
SET
	USPropertyGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @USPropertyGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END
FROM
	#USPropCategoryLookup t1
WHERE
	t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode

PRINT 'Completed converting all USPropertyGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


--USCorporateGlAccountCategoryKey

CREATE TABLE #USCorpCategoryLookup(
	GlAccountCategoryKey INT NULL,
	ReferenceCode varchar(300) NOT NULL
)

INSERT INTO #USCorpCategoryLookup(
	GlAccountCategoryKey,
	ReferenceCode
)
SELECT 
	GlAcUSCorp.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT 
			GlAcHg.GLTranslationTypeId,
			GlAcHg.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			GlAcHg.GLAccountTypeId,
			GlAcHg.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode
		 FROM	
			#ProfitabilityPayrollMapping Gl				
			CROSS JOIN (
							SELECT
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#GLAccountCategoryTranslations ACT
							WHERE
								ACT.GLTranslationSubTypeCode = 'US CORP'

						) GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSCorp ON GlAcUSCorp.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0)))

			AND Gl.AllocationUpdatedDate BETWEEN GlAcUSCorp.StartDate AND GlAcUSCorp.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #USCorpCategoryLookup (ReferenceCode)

UPDATE
	#ProfitabilityReforecast
SET
	USCorporateGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @USCorporateGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END
FROM
	#USCorpCategoryLookup t1
WHERE
	t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode


PRINT 'Completed converting all USCorporateGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--USFundGlAccountCategoryKey

CREATE TABLE #USFundCategoryLookup(
	GlAccountCategoryKey INT NULL,
	ReferenceCode VARCHAR(300) NOT NULL
)

INSERT INTO #USFundCategoryLookup(
	GlAccountCategoryKey,
	ReferenceCode
)
SELECT 
	GlAcUSFund.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT 
			GlAcHg.GLTranslationTypeId,
			GlAcHg.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			GlAcHg.GLAccountTypeId,
			GlAcHg.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode
		 FROM	
			#ProfitabilityPayrollMapping Gl				
			CROSS JOIN (
							SELECT
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#GLAccountCategoryTranslations ACT
							WHERE
								ACT.GLTranslationSubTypeCode = 'US FUND'

						) GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSFund ON GlAcUSFund.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0)))

			AND Gl.AllocationUpdatedDate BETWEEN GlAcUSFund.StartDate AND GlAcUSFund.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #USFundCategoryLookup (ReferenceCode)

UPDATE
	#ProfitabilityReforecast
SET
	USFundGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @USFundGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END
FROM
	#USFundCategoryLookup t1
WHERE
	t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode

PRINT 'Completed converting all USFundGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
	

--DevelopmentGlAccountCategoryKey

CREATE TABLE #DevelCategoryLookup(
	GlAccountCategoryKey INT NULL,
	ReferenceCode varchar(300) NOT NULL
)

INSERT INTO #DevelCategoryLookup(
	GlAccountCategoryKey,
	ReferenceCode
)
SELECT 
	GlAcDevel.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT 
			GlAcHg.GLTranslationTypeId,
			GlAcHg.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			GlAcHg.GLAccountTypeId,
			GlAcHg.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode
		 FROM	
			#ProfitabilityPayrollMapping Gl				
			CROSS JOIN (
							SELECT
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#GLAccountCategoryTranslations ACT
							WHERE
								ACT.GLTranslationSubTypeCode = 'DEV'

						) GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcDevel ON GlAcDevel.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0)))

			AND Gl.AllocationUpdatedDate BETWEEN GlAcDevel.StartDate AND GlAcDevel.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #DevelCategoryLookup (ReferenceCode)

UPDATE
	#ProfitabilityReforecast
SET
	DevelopmentGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @DevelopmentGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END
FROM
	#DevelCategoryLookup t1
WHERE
	t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode

PRINT 'Completed converting all DevelopmentGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
*/

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Insert modified and new data 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

INSERT INTO GrReporting.dbo.ProfitabilityReforecast
(
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
)
SELECT
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	@EUCorporateGlAccountCategoryKeyUnknown, --EUCorporateGlAccountCategoryKey,
	@EUPropertyGlAccountCategoryKeyUnknown, --EUPropertyGlAccountCategoryKey,
	@EUFundGlAccountCategoryKeyUnknown, --EUFundGlAccountCategoryKey,

	@USPropertyGlAccountCategoryKeyUnknown, --USPropertyGlAccountCategoryKey,
	@USCorporateGlAccountCategoryKeyUnknown, ----USCorporateGlAccountCategoryKey,
	@USFundGlAccountCategoryKeyUnknown, --USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	@DevelopmentGlAccountCategoryKeyUnknown --DevelopmentGlAccountCategoryKey
FROM 
	#ProfitabilityReforecast

print 'Rows Inserted in ProfitabilityReforecast:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Clean up
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

DROP TABLE #SystemSettingRegion
DROP TABLE #GLTranslationType
DROP TABLE #GLTranslationSubType
DROP TABLE #GLMajorCategory
DROP TABLE #GLMinorCategory
DROP TABLE #GLAccountType
DROP TABLE #GLAccountSubType
DROP TABLE #GLAccountCategoryTranslations
DROP TABLE #BudgetReportGroupDetail
DROP TABLE #BudgetReportGroup
DROP TABLE #BudgetReportGroupPeriod
DROP TABLE #BudgetStatus
DROP TABLE #AllActiveBudget
DROP TABLE #AllModifiedReportBudget
DROP TABLE #LockedModifiedReportGroup
DROP TABLE #FilteredModifiedReportBudget
DROP TABLE #Budget
DROP TABLE #BudgetProject
DROP TABLE #Region
DROP TABLE #BudgetEmployee
DROP TABLE #BudgetEmployeeFunctionalDepartment
DROP TABLE #FunctionalDepartment
DROP TABLE #PropertyFund
DROP TABLE #PropertyFundMapping
DROP TABLE #ReportingEntityCorporateDepartment
DROP TABLE #ReportingEntityPropertyEntity
DROP TABLE #Location
DROP TABLE #RegionExtended
DROP TABLE #PayrollRegion
DROP TABLE #OverheadRegion
DROP TABLE #Project
DROP TABLE #BudgetEmployeePayrollAllocation
DROP TABLE #BudgetEmployeePayrollAllocationDetailBatches
DROP TABLE #BEPADa
DROP TABLE #BudgetEmployeePayrollAllocationDetail
DROP TABLE #BudgetTaxType
DROP TABLE #TaxType
DROP TABLE #EmployeePayrollAllocationDetail
DROP TABLE #BudgetOverheadAllocation
DROP TABLE #BudgetOverheadAllocationDetail
DROP TABLE #OverheadAllocationDetail
DROP TABLE #EffectiveFunctionalDepartment
DROP TABLE #ProfitabilityPreTaxSource
DROP TABLE #ProfitabilityTaxSource
DROP TABLE #ProfitabilityOverheadSource
DROP TABLE #ProfitabilityPayrollMapping
DROP TABLE #OriginatingRegionCorporateEntity
DROP TABLE #OriginatingRegionPropertyDepartment
DROP TABLE #AllocationSubRegion
DROP TABLE #ProfitabilityReforecast
DROP TABLE #DeletingBudget
--DROP TABLE #EUCorpCategoryLookup
--DROP TABLE #EUPropCategoryLookup
--DROP TABLE #EUFundCategoryLookup
--DROP TABLE #USPropCategoryLookup
--DROP TABLE #USCorpCategoryLookup
--DROP TABLE #USFundCategoryLookup
DROP TABLE #GlobalCategoryLookup
--DROP TABLE #DevelCategoryLookup

GO

