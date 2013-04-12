--TODO: Remember that SSISConfigurations and Batch tables aren't being dropped here 
--because we don't want to loose the information if we are smoking the DW for a re-load.
--Un comment all commented constraints for these tables if you want to smoke everyting!

USE [GrReportingStaging]
GO

/****** Object:  Table [dbo].[SSISConfigurations]    Script Date: 12/15/2009 13:18:17 ******/
/*
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSISConfigurations]') AND type in (N'U'))
DROP TABLE [dbo].[SSISConfigurations]
GO
*/

/*
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Batch_BatchDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Batch] DROP CONSTRAINT [DF_Batch_BatchDate]
END

GO
*/

/****** Object:  Table [dbo].[Batch]    Script Date: 12/18/2009 16:07:10 ******/
/*
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Batch]') AND type in (N'U'))
DROP TABLE [dbo].[Batch]
GO
*/

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ActivityType_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[ActivityType] DROP CONSTRAINT [DF_ActivityType_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AllocationRegionMapping_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[AllocationRegionMapping] DROP CONSTRAINT [DF_AllocationRegionMapping_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_BenefitOption_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobalBudgeting].[BenefitOption] DROP CONSTRAINT [DF_BenefitOption_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_BillingUpload_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobal].[BillingUpload] DROP CONSTRAINT [DF_BillingUpload_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_BillingUploadDetail_ImpoertDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobal].[BillingUploadDetail] DROP CONSTRAINT [DF_BillingUploadDetail_ImpoertDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Budget_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobalBudgeting].[Budget] DROP CONSTRAINT [DF_Budget_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_BudgetEmployee_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobalBudgeting].[BudgetEmployee] DROP CONSTRAINT [DF_BudgetEmployee_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_BudgetEmployeeFunctionalDepartment_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartment] DROP CONSTRAINT [DF_BudgetEmployeeFunctionalDepartment_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_BudgetEmployeePayrollAllocation_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocation] DROP CONSTRAINT [DF_BudgetEmployeePayrollAllocation_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_BudgetEmployeePayrollAllocationDetail_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] DROP CONSTRAINT [DF_BudgetEmployeePayrollAllocationDetail_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_BudgetOverheadAllocation_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobalBudgeting].[BudgetOverheadAllocation] DROP CONSTRAINT [DF_BudgetOverheadAllocation_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_BudgetOverheadAllocationDetail_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobalBudgeting].[BudgetOverheadAllocationDetail] DROP CONSTRAINT [DF_BudgetOverheadAllocationDetail_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_BudgetProject_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobalBudgeting].[BudgetProject] DROP CONSTRAINT [DF_BudgetProject_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_BudgetReportGroup_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobalBudgeting].[BudgetReportGroup] DROP CONSTRAINT [DF_BudgetReportGroup_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_BudgetReportGroupDetail_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobalBudgeting].[BudgetReportGroupDetail] DROP CONSTRAINT [DF_BudgetReportGroupDetail_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_BudgetStatus_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobalBudgeting].[BudgetStatus] DROP CONSTRAINT [DF_BudgetStatus_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_BudgetTaxType_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobalBudgeting].[BudgetTaxType] DROP CONSTRAINT [DF_BudgetTaxType_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Department_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [GACS].[Department] DROP CONSTRAINT [DF_Department_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ENTITY_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [INProp].[ENTITY] DROP CONSTRAINT [DF_ENTITY_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ENTITY_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [INCorp].[ENTITY] DROP CONSTRAINT [DF_ENTITY_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ENTITY_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [EUCorp].[ENTITY] DROP CONSTRAINT [DF_ENTITY_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ENTITY_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [EUProp].[ENTITY] DROP CONSTRAINT [DF_ENTITY_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ENTITY_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [CNProp].[ENTITY] DROP CONSTRAINT [DF_ENTITY_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ENTITY_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [BRProp].[ENTITY] DROP CONSTRAINT [DF_ENTITY_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ENTITY_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [USCorp].[ENTITY] DROP CONSTRAINT [DF_ENTITY_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ENTITY_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [BRCorp].[ENTITY] DROP CONSTRAINT [DF_ENTITY_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ENTITY_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [CNCorp].[ENTITY] DROP CONSTRAINT [DF_ENTITY_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ENTITY_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [USProp].[ENTITY] DROP CONSTRAINT [DF_ENTITY_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ExchangeRate_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobalBudgeting].[ExchangeRate] DROP CONSTRAINT [DF_ExchangeRate_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ExchangeRate_InsertedDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobalBudgeting].[ExchangeRate] DROP CONSTRAINT [DF_ExchangeRate_InsertedDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ExchangeRate_UpdatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobalBudgeting].[ExchangeRate] DROP CONSTRAINT [DF_ExchangeRate_UpdatedDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ExchangeRateDetail_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobalBudgeting].[ExchangeRateDetail] DROP CONSTRAINT [DF_ExchangeRateDetail_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ExchangeRateDetail_InsertedDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobalBudgeting].[ExchangeRateDetail] DROP CONSTRAINT [DF_ExchangeRateDetail_InsertedDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ExchangeRateDetail_UpdatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobalBudgeting].[ExchangeRateDetail] DROP CONSTRAINT [DF_ExchangeRateDetail_UpdatedDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_FunctionalDepartment_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [HR].[FunctionalDepartment] DROP CONSTRAINT [DF_FunctionalDepartment_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GACC_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [USProp].[GACC] DROP CONSTRAINT [DF_GACC_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GACC_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [BRCorp].[GACC] DROP CONSTRAINT [DF_GACC_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GACC_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [CNProp].[GACC] DROP CONSTRAINT [DF_GACC_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GACC_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [EUCorp].[GACC] DROP CONSTRAINT [DF_GACC_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GACC_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [INCorp].[GACC] DROP CONSTRAINT [DF_GACC_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GACC_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [BRProp].[GACC] DROP CONSTRAINT [DF_GACC_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GACC_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [CNCorp].[GACC] DROP CONSTRAINT [DF_GACC_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GACC_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [EUProp].[GACC] DROP CONSTRAINT [DF_GACC_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GACC_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [INProp].[GACC] DROP CONSTRAINT [DF_GACC_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GACC_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [USCorp].[GACC] DROP CONSTRAINT [DF_GACC_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GDEP_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [USCorp].[GDEP] DROP CONSTRAINT [DF_GDEP_ImportDate]
END

GO
/*
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GDEP_ImportBatchId]') AND type = 'D')
BEGIN
ALTER TABLE [INProp].[GDEP] DROP CONSTRAINT [DF_GDEP_ImportBatchId]
END

GO
*/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GDEP_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [INProp].[GDEP] DROP CONSTRAINT [DF_GDEP_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GDEP_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [BRProp].[GDEP] DROP CONSTRAINT [DF_GDEP_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GDEP_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [BRCorp].[GDEP] DROP CONSTRAINT [DF_GDEP_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GDEP_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [INCorp].[GDEP] DROP CONSTRAINT [DF_GDEP_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GDEP_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [CNCorp].[GDEP] DROP CONSTRAINT [DF_GDEP_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GDEP_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [USProp].[GDEP] DROP CONSTRAINT [DF_GDEP_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GDEP_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [EUProp].[GDEP] DROP CONSTRAINT [DF_GDEP_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GDEP_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [EUCorp].[GDEP] DROP CONSTRAINT [DF_GDEP_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GDEP_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [CNProp].[GDEP] DROP CONSTRAINT [DF_GDEP_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GHIS_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [USCorp].[GHIS] DROP CONSTRAINT [DF_GHIS_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GHIS_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [USProp].[GHIS] DROP CONSTRAINT [DF_GHIS_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GHIS_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [EUProp].[GHIS] DROP CONSTRAINT [DF_GHIS_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GHIS_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [CNProp].[GHIS] DROP CONSTRAINT [DF_GHIS_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GHIS_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [EUCorp].[GHIS] DROP CONSTRAINT [DF_GHIS_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GHIS_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [CNCorp].[GHIS] DROP CONSTRAINT [DF_GHIS_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GJOB_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [USCorp].[GJOB] DROP CONSTRAINT [DF_GJOB_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GJOB_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [CNProp].[GJOB] DROP CONSTRAINT [DF_GJOB_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GJOB_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [EUCorp].[GJOB] DROP CONSTRAINT [DF_GJOB_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GJOB_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [BRCorp].[GJOB] DROP CONSTRAINT [DF_GJOB_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GJOB_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [USProp].[GJOB] DROP CONSTRAINT [DF_GJOB_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GJOB_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [CNCorp].[GJOB] DROP CONSTRAINT [DF_GJOB_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GJOB_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [INCorp].[GJOB] DROP CONSTRAINT [DF_GJOB_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GJOB_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [EUProp].[GJOB] DROP CONSTRAINT [DF_GJOB_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GlAccountMapping_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[GlAccountMapping] DROP CONSTRAINT [DF_GlAccountMapping_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GlAccountMapping_UpdatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[GlAccountMapping] DROP CONSTRAINT [DF_GlAccountMapping_UpdatedDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GlAccountMapping_IsDeleted]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[GlAccountMapping] DROP CONSTRAINT [DF_GlAccountMapping_IsDeleted]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GlobalAllocationRegionMapping_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[GlobalAllocationRegionMapping] DROP CONSTRAINT [DF_GlobalAllocationRegionMapping_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GlobalGlAccount_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[GlobalGlAccount] DROP CONSTRAINT [DF_GlobalGlAccount_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GlobalGlAccount_AccountType]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[GlobalGlAccount] DROP CONSTRAINT [DF_GlobalGlAccount_AccountType]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GlobalGlAccountCategoryHieranchy_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[GlobalGlAccountCategoryHierarchy] DROP CONSTRAINT [DF_GlobalGlAccountCategoryHieranchy_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GlobalGlAccountCategoryHieranchy_AccountType]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[GlobalGlAccountCategoryHierarchy] DROP CONSTRAINT [DF_GlobalGlAccountCategoryHieranchy_AccountType]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GlobalGlAccountCategoryHieranchyGroup_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[GlobalGlAccountCategoryHierarchyGroup] DROP CONSTRAINT [DF_GlobalGlAccountCategoryHieranchyGroup_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GlobalRegion_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[GlobalRegion] DROP CONSTRAINT [DF_GlobalRegion_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GlobalRegion_IsAllocationRegion]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[GlobalRegion] DROP CONSTRAINT [DF_GlobalRegion_IsAllocationRegion]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GlobalRegion_IsOriginatingRegion]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[GlobalRegion] DROP CONSTRAINT [DF_GlobalRegion_IsOriginatingRegion]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GlobalReportingCorporateBudget_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [BudgetingCorp].[GlobalReportingCorporateBudget] DROP CONSTRAINT [DF_GlobalReportingCorporateBudget_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GRBudgetReportGroupPeriod_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobalBudgeting].[GRBudgetReportGroupPeriod] DROP CONSTRAINT [DF_GRBudgetReportGroupPeriod_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GRBudgetReportGroupPeriod_InsertedDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobalBudgeting].[GRBudgetReportGroupPeriod] DROP CONSTRAINT [DF_GRBudgetReportGroupPeriod_InsertedDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GRBudgetReportGroupPeriod_UpdatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobalBudgeting].[GRBudgetReportGroupPeriod] DROP CONSTRAINT [DF_GRBudgetReportGroupPeriod_UpdatedDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_JobCode_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [GACS].[JobCode] DROP CONSTRAINT [DF_JobCode_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_JOURNAL_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [USCorp].[JOURNAL] DROP CONSTRAINT [DF_JOURNAL_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_JOURNAL_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [USProp].[JOURNAL] DROP CONSTRAINT [DF_JOURNAL_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_JOURNAL_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [BRProp].[JOURNAL] DROP CONSTRAINT [DF_JOURNAL_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_JOURNAL_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [INProp].[JOURNAL] DROP CONSTRAINT [DF_JOURNAL_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_JOURNAL_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [INCorp].[JOURNAL] DROP CONSTRAINT [DF_JOURNAL_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_JOURNAL_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [CNCorp].[JOURNAL] DROP CONSTRAINT [DF_JOURNAL_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_JOURNAL_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [CNProp].[JOURNAL] DROP CONSTRAINT [DF_JOURNAL_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_JOURNAL_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [BRCorp].[JOURNAL] DROP CONSTRAINT [DF_JOURNAL_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_JOURNAL_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [EUProp].[JOURNAL] DROP CONSTRAINT [DF_JOURNAL_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_JOURNAL_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [EUCorp].[JOURNAL] DROP CONSTRAINT [DF_JOURNAL_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Location_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [HR].[Location] DROP CONSTRAINT [DF_Location_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MajorGlAccountCategory_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[MajorGlAccountCategory] DROP CONSTRAINT [DF_MajorGlAccountCategory_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MinorGlAccountCategory_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[MinorGlAccountCategory] DROP CONSTRAINT [DF_MinorGlAccountCategory_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_OriginatingRegionMapping_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[OriginatingRegionMapping] DROP CONSTRAINT [DF_OriginatingRegionMapping_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Overhead_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobal].[Overhead] DROP CONSTRAINT [DF_Overhead_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_OverheadRegion_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobal].[OverheadRegion] DROP CONSTRAINT [DF_OverheadRegion_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Project_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobal].[Project] DROP CONSTRAINT [DF_Project_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ProjectRegion_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobal].[ProjectRegion] DROP CONSTRAINT [DF_ProjectRegion_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ProjectType_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobal].[ProjectType] DROP CONSTRAINT [DF_ProjectType_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PropertyFund_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[PropertyFund] DROP CONSTRAINT [DF_PropertyFund_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PropertyFund_ProjectTypeId]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[PropertyFund] DROP CONSTRAINT [DF_PropertyFund_ProjectTypeId]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PropertyFundMapping_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[PropertyFundMapping] DROP CONSTRAINT [DF_PropertyFundMapping_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PropertyFundMapping_UpdatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[PropertyFundMapping] DROP CONSTRAINT [DF_PropertyFundMapping_UpdatedDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PropertyFundMapping_IsDeleted]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[PropertyFundMapping] DROP CONSTRAINT [DF_PropertyFundMapping_IsDeleted]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ReforecastActualBilledPayroll_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobalBudgeting].[ReforecastActualBilledPayroll] DROP CONSTRAINT [DF_ReforecastActualBilledPayroll_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Region_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [HR].[Region] DROP CONSTRAINT [DF_Region_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_RegionExtended_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobal].[RegionExtended] DROP CONSTRAINT [DF_RegionExtended_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_SystemSetting_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobal].[SystemSetting] DROP CONSTRAINT [DF_SystemSetting_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_SystemSettingRegion_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobal].[SystemSettingRegion] DROP CONSTRAINT [DF_SystemSettingRegion_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TaxType_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [TapasGlobalBudgeting].[TaxType] DROP CONSTRAINT [DF_TaxType_ImportDate]
END

GO

/****** Object:  Table [Gdm].[ActivityType]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ActivityType]') AND type in (N'U'))
DROP TABLE [Gdm].[ActivityType]
GO

/****** Object:  Table [Gdm].[AllocationRegionMapping]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[AllocationRegionMapping]') AND type in (N'U'))
DROP TABLE [Gdm].[AllocationRegionMapping]
GO

/****** Object:  Table [TapasGlobalBudgeting].[BenefitOption]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BenefitOption]') AND type in (N'U'))
DROP TABLE [TapasGlobalBudgeting].[BenefitOption]
GO

/****** Object:  Table [TapasGlobal].[BillingUpload]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[BillingUpload]') AND type in (N'U'))
DROP TABLE [TapasGlobal].[BillingUpload]
GO

/****** Object:  Table [TapasGlobal].[BillingUploadDetail]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[BillingUploadDetail]') AND type in (N'U'))
DROP TABLE [TapasGlobal].[BillingUploadDetail]
GO

/****** Object:  Table [TapasGlobalBudgeting].[Budget]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[Budget]') AND type in (N'U'))
DROP TABLE [TapasGlobalBudgeting].[Budget]
GO

/****** Object:  Table [TapasGlobalBudgeting].[BudgetEmployee]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployee]') AND type in (N'U'))
DROP TABLE [TapasGlobalBudgeting].[BudgetEmployee]
GO

/****** Object:  Table [TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartment]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartment]') AND type in (N'U'))
DROP TABLE [TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartment]
GO

/****** Object:  Table [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocation]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocation]') AND type in (N'U'))
DROP TABLE [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocation]
GO

/****** Object:  Table [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail]') AND type in (N'U'))
DROP TABLE [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail]
GO

/****** Object:  Table [TapasGlobalBudgeting].[BudgetOverheadAllocation]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetOverheadAllocation]') AND type in (N'U'))
DROP TABLE [TapasGlobalBudgeting].[BudgetOverheadAllocation]
GO

/****** Object:  Table [TapasGlobalBudgeting].[BudgetOverheadAllocationDetail]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetOverheadAllocationDetail]') AND type in (N'U'))
DROP TABLE [TapasGlobalBudgeting].[BudgetOverheadAllocationDetail]
GO

/****** Object:  Table [TapasGlobalBudgeting].[BudgetProject]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetProject]') AND type in (N'U'))
DROP TABLE [TapasGlobalBudgeting].[BudgetProject]
GO

/****** Object:  Table [TapasGlobalBudgeting].[BudgetReportGroup]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetReportGroup]') AND type in (N'U'))
DROP TABLE [TapasGlobalBudgeting].[BudgetReportGroup]
GO

/****** Object:  Table [TapasGlobalBudgeting].[BudgetReportGroupDetail]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetReportGroupDetail]') AND type in (N'U'))
DROP TABLE [TapasGlobalBudgeting].[BudgetReportGroupDetail]
GO

/****** Object:  Table [TapasGlobalBudgeting].[BudgetStatus]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetStatus]') AND type in (N'U'))
DROP TABLE [TapasGlobalBudgeting].[BudgetStatus]
GO

/****** Object:  Table [TapasGlobalBudgeting].[BudgetTaxType]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetTaxType]') AND type in (N'U'))
DROP TABLE [TapasGlobalBudgeting].[BudgetTaxType]
GO

/****** Object:  Table [GACS].[Department]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GACS].[Department]') AND type in (N'U'))
DROP TABLE [GACS].[Department]
GO

/****** Object:  Table [INProp].[ENTITY]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INProp].[ENTITY]') AND type in (N'U'))
DROP TABLE [INProp].[ENTITY]
GO

/****** Object:  Table [INCorp].[ENTITY]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INCorp].[ENTITY]') AND type in (N'U'))
DROP TABLE [INCorp].[ENTITY]
GO

/****** Object:  Table [EUCorp].[ENTITY]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUCorp].[ENTITY]') AND type in (N'U'))
DROP TABLE [EUCorp].[ENTITY]
GO

/****** Object:  Table [EUProp].[ENTITY]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUProp].[ENTITY]') AND type in (N'U'))
DROP TABLE [EUProp].[ENTITY]
GO

/****** Object:  Table [CNProp].[ENTITY]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNProp].[ENTITY]') AND type in (N'U'))
DROP TABLE [CNProp].[ENTITY]
GO

/****** Object:  Table [BRProp].[ENTITY]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRProp].[ENTITY]') AND type in (N'U'))
DROP TABLE [BRProp].[ENTITY]
GO

/****** Object:  Table [USCorp].[ENTITY]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USCorp].[ENTITY]') AND type in (N'U'))
DROP TABLE [USCorp].[ENTITY]
GO

/****** Object:  Table [BRCorp].[ENTITY]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRCorp].[ENTITY]') AND type in (N'U'))
DROP TABLE [BRCorp].[ENTITY]
GO

/****** Object:  Table [CNCorp].[ENTITY]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNCorp].[ENTITY]') AND type in (N'U'))
DROP TABLE [CNCorp].[ENTITY]
GO

/****** Object:  Table [USProp].[ENTITY]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USProp].[ENTITY]') AND type in (N'U'))
DROP TABLE [USProp].[ENTITY]
GO

/****** Object:  Table [TapasGlobalBudgeting].[ExchangeRate]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[ExchangeRate]') AND type in (N'U'))
DROP TABLE [TapasGlobalBudgeting].[ExchangeRate]
GO

/****** Object:  Table [TapasGlobalBudgeting].[ExchangeRateDetail]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[ExchangeRateDetail]') AND type in (N'U'))
DROP TABLE [TapasGlobalBudgeting].[ExchangeRateDetail]
GO

/****** Object:  Table [HR].[FunctionalDepartment]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[HR].[FunctionalDepartment]') AND type in (N'U'))
DROP TABLE [HR].[FunctionalDepartment]
GO

/****** Object:  Table [USProp].[GACC]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USProp].[GACC]') AND type in (N'U'))
DROP TABLE [USProp].[GACC]
GO

/****** Object:  Table [BRCorp].[GACC]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRCorp].[GACC]') AND type in (N'U'))
DROP TABLE [BRCorp].[GACC]
GO

/****** Object:  Table [CNProp].[GACC]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNProp].[GACC]') AND type in (N'U'))
DROP TABLE [CNProp].[GACC]
GO

/****** Object:  Table [EUCorp].[GACC]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUCorp].[GACC]') AND type in (N'U'))
DROP TABLE [EUCorp].[GACC]
GO

/****** Object:  Table [INCorp].[GACC]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INCorp].[GACC]') AND type in (N'U'))
DROP TABLE [INCorp].[GACC]
GO

/****** Object:  Table [BRProp].[GACC]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRProp].[GACC]') AND type in (N'U'))
DROP TABLE [BRProp].[GACC]
GO

/****** Object:  Table [CNCorp].[GACC]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNCorp].[GACC]') AND type in (N'U'))
DROP TABLE [CNCorp].[GACC]
GO

/****** Object:  Table [EUProp].[GACC]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUProp].[GACC]') AND type in (N'U'))
DROP TABLE [EUProp].[GACC]
GO

/****** Object:  Table [INProp].[GACC]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INProp].[GACC]') AND type in (N'U'))
DROP TABLE [INProp].[GACC]
GO

/****** Object:  Table [USCorp].[GACC]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USCorp].[GACC]') AND type in (N'U'))
DROP TABLE [USCorp].[GACC]
GO

/****** Object:  Table [USCorp].[GDEP]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USCorp].[GDEP]') AND type in (N'U'))
DROP TABLE [USCorp].[GDEP]
GO

/****** Object:  Table [INProp].[GDEP]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INProp].[GDEP]') AND type in (N'U'))
DROP TABLE [INProp].[GDEP]
GO

/****** Object:  Table [BRProp].[GDEP]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRProp].[GDEP]') AND type in (N'U'))
DROP TABLE [BRProp].[GDEP]
GO

/****** Object:  Table [BRCorp].[GDEP]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRCorp].[GDEP]') AND type in (N'U'))
DROP TABLE [BRCorp].[GDEP]
GO

/****** Object:  Table [INCorp].[GDEP]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INCorp].[GDEP]') AND type in (N'U'))
DROP TABLE [INCorp].[GDEP]
GO

/****** Object:  Table [CNCorp].[GDEP]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNCorp].[GDEP]') AND type in (N'U'))
DROP TABLE [CNCorp].[GDEP]
GO

/****** Object:  Table [USProp].[GDEP]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USProp].[GDEP]') AND type in (N'U'))
DROP TABLE [USProp].[GDEP]
GO

/****** Object:  Table [EUProp].[GDEP]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUProp].[GDEP]') AND type in (N'U'))
DROP TABLE [EUProp].[GDEP]
GO

/****** Object:  Table [EUCorp].[GDEP]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUCorp].[GDEP]') AND type in (N'U'))
DROP TABLE [EUCorp].[GDEP]
GO

/****** Object:  Table [CNProp].[GDEP]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNProp].[GDEP]') AND type in (N'U'))
DROP TABLE [CNProp].[GDEP]
GO

/****** Object:  Table [USCorp].[GHIS]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USCorp].[GHIS]') AND type in (N'U'))
DROP TABLE [USCorp].[GHIS]
GO

/****** Object:  Table [USProp].[GHIS]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USProp].[GHIS]') AND type in (N'U'))
DROP TABLE [USProp].[GHIS]
GO

/****** Object:  Table [EUProp].[GHIS]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUProp].[GHIS]') AND type in (N'U'))
DROP TABLE [EUProp].[GHIS]
GO

/****** Object:  Table [CNProp].[GHIS]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNProp].[GHIS]') AND type in (N'U'))
DROP TABLE [CNProp].[GHIS]
GO

/****** Object:  Table [EUCorp].[GHIS]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUCorp].[GHIS]') AND type in (N'U'))
DROP TABLE [EUCorp].[GHIS]
GO

/****** Object:  Table [CNCorp].[GHIS]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNCorp].[GHIS]') AND type in (N'U'))
DROP TABLE [CNCorp].[GHIS]
GO

/****** Object:  Table [USCorp].[GJOB]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USCorp].[GJOB]') AND type in (N'U'))
DROP TABLE [USCorp].[GJOB]
GO

/****** Object:  Table [CNProp].[GJOB]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNProp].[GJOB]') AND type in (N'U'))
DROP TABLE [CNProp].[GJOB]
GO

/****** Object:  Table [EUCorp].[GJOB]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUCorp].[GJOB]') AND type in (N'U'))
DROP TABLE [EUCorp].[GJOB]
GO

/****** Object:  Table [BRCorp].[GJOB]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRCorp].[GJOB]') AND type in (N'U'))
DROP TABLE [BRCorp].[GJOB]
GO

/****** Object:  Table [USProp].[GJOB]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USProp].[GJOB]') AND type in (N'U'))
DROP TABLE [USProp].[GJOB]
GO

/****** Object:  Table [CNCorp].[GJOB]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNCorp].[GJOB]') AND type in (N'U'))
DROP TABLE [CNCorp].[GJOB]
GO

/****** Object:  Table [INCorp].[GJOB]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INCorp].[GJOB]') AND type in (N'U'))
DROP TABLE [INCorp].[GJOB]
GO

/****** Object:  Table [EUProp].[GJOB]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUProp].[GJOB]') AND type in (N'U'))
DROP TABLE [EUProp].[GJOB]
GO

/****** Object:  Table [Gdm].[GlAccountMapping]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GlAccountMapping]') AND type in (N'U'))
DROP TABLE [Gdm].[GlAccountMapping]
GO

/****** Object:  Table [Gdm].[GlobalAllocationRegionMapping]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalAllocationRegionMapping]') AND type in (N'U'))
DROP TABLE [Gdm].[GlobalAllocationRegionMapping]
GO

/****** Object:  Table [Gdm].[GlobalGlAccount]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalGlAccount]') AND type in (N'U'))
DROP TABLE [Gdm].[GlobalGlAccount]
GO

/****** Object:  Table [Gdm].[GlobalGlAccountCategoryHierarchy]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalGlAccountCategoryHierarchy]') AND type in (N'U'))
DROP TABLE [Gdm].[GlobalGlAccountCategoryHierarchy]
GO

/****** Object:  Table [Gdm].[GlobalGlAccountCategoryHierarchyGroup]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalGlAccountCategoryHierarchyGroup]') AND type in (N'U'))
DROP TABLE [Gdm].[GlobalGlAccountCategoryHierarchyGroup]
GO

/****** Object:  Table [Gdm].[GlobalRegion]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalRegion]') AND type in (N'U'))
DROP TABLE [Gdm].[GlobalRegion]
GO

/****** Object:  Table [BudgetingCorp].[GlobalReportingCorporateBudget]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BudgetingCorp].[GlobalReportingCorporateBudget]') AND type in (N'U'))
DROP TABLE [BudgetingCorp].[GlobalReportingCorporateBudget]
GO

/****** Object:  Table [TapasGlobalBudgeting].[GRBudgetReportGroupPeriod]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[GRBudgetReportGroupPeriod]') AND type in (N'U'))
DROP TABLE [TapasGlobalBudgeting].[GRBudgetReportGroupPeriod]
GO

/****** Object:  Table [GACS].[JobCode]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GACS].[JobCode]') AND type in (N'U'))
DROP TABLE [GACS].[JobCode]
GO

/****** Object:  Table [USCorp].[JOURNAL]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USCorp].[JOURNAL]') AND type in (N'U'))
DROP TABLE [USCorp].[JOURNAL]
GO

/****** Object:  Table [USProp].[JOURNAL]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USProp].[JOURNAL]') AND type in (N'U'))
DROP TABLE [USProp].[JOURNAL]
GO

/****** Object:  Table [BRProp].[JOURNAL]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRProp].[JOURNAL]') AND type in (N'U'))
DROP TABLE [BRProp].[JOURNAL]
GO

/****** Object:  Table [INProp].[JOURNAL]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INProp].[JOURNAL]') AND type in (N'U'))
DROP TABLE [INProp].[JOURNAL]
GO

/****** Object:  Table [INCorp].[JOURNAL]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INCorp].[JOURNAL]') AND type in (N'U'))
DROP TABLE [INCorp].[JOURNAL]
GO

/****** Object:  Table [CNCorp].[JOURNAL]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNCorp].[JOURNAL]') AND type in (N'U'))
DROP TABLE [CNCorp].[JOURNAL]
GO

/****** Object:  Table [CNProp].[JOURNAL]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNProp].[JOURNAL]') AND type in (N'U'))
DROP TABLE [CNProp].[JOURNAL]
GO

/****** Object:  Table [BRCorp].[JOURNAL]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BRCorp].[JOURNAL]') AND type in (N'U'))
DROP TABLE [BRCorp].[JOURNAL]
GO

/****** Object:  Table [EUProp].[JOURNAL]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUProp].[JOURNAL]') AND type in (N'U'))
DROP TABLE [EUProp].[JOURNAL]
GO

/****** Object:  Table [EUCorp].[JOURNAL]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUCorp].[JOURNAL]') AND type in (N'U'))
DROP TABLE [EUCorp].[JOURNAL]
GO

/****** Object:  Table [HR].[Location]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[HR].[Location]') AND type in (N'U'))
DROP TABLE [HR].[Location]
GO

/****** Object:  Table [Gdm].[MajorGlAccountCategory]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[MajorGlAccountCategory]') AND type in (N'U'))
DROP TABLE [Gdm].[MajorGlAccountCategory]
GO

/****** Object:  Table [Gdm].[MinorGlAccountCategory]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[MinorGlAccountCategory]') AND type in (N'U'))
DROP TABLE [Gdm].[MinorGlAccountCategory]
GO

/****** Object:  Table [Gdm].[OriginatingRegionMapping]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[OriginatingRegionMapping]') AND type in (N'U'))
DROP TABLE [Gdm].[OriginatingRegionMapping]
GO

/****** Object:  Table [TapasGlobal].[Overhead]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[Overhead]') AND type in (N'U'))
DROP TABLE [TapasGlobal].[Overhead]
GO

/****** Object:  Table [TapasGlobal].[OverheadRegion]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[OverheadRegion]') AND type in (N'U'))
DROP TABLE [TapasGlobal].[OverheadRegion]
GO

/****** Object:  Table [TapasGlobal].[PayrollRegion]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[PayrollRegion]') AND type in (N'U'))
DROP TABLE [TapasGlobal].[PayrollRegion]
GO

/****** Object:  Table [TapasGlobal].[Project]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[Project]') AND type in (N'U'))
DROP TABLE [TapasGlobal].[Project]
GO

/****** Object:  Table [TapasGlobal].[ProjectRegion]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[ProjectRegion]') AND type in (N'U'))
DROP TABLE [TapasGlobal].[ProjectRegion]
GO

/****** Object:  Table [TapasGlobal].[ProjectType]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[ProjectType]') AND type in (N'U'))
DROP TABLE [TapasGlobal].[ProjectType]
GO

/****** Object:  Table [Gdm].[PropertyFund]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[PropertyFund]') AND type in (N'U'))
DROP TABLE [Gdm].[PropertyFund]
GO

/****** Object:  Table [Gdm].[PropertyFundMapping]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[PropertyFundMapping]') AND type in (N'U'))
DROP TABLE [Gdm].[PropertyFundMapping]
GO

/****** Object:  Table [TapasGlobalBudgeting].[ReforecastActualBilledPayroll]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[ReforecastActualBilledPayroll]') AND type in (N'U'))
DROP TABLE [TapasGlobalBudgeting].[ReforecastActualBilledPayroll]
GO

/****** Object:  Table [HR].[Region]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[HR].[Region]') AND type in (N'U'))
DROP TABLE [HR].[Region]
GO

/****** Object:  Table [TapasGlobal].[RegionExtended]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[RegionExtended]') AND type in (N'U'))
DROP TABLE [TapasGlobal].[RegionExtended]
GO

/****** Object:  Table [TapasGlobal].[SystemSetting]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[SystemSetting]') AND type in (N'U'))
DROP TABLE [TapasGlobal].[SystemSetting]
GO

/****** Object:  Table [TapasGlobal].[SystemSettingRegion]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[SystemSettingRegion]') AND type in (N'U'))
DROP TABLE [TapasGlobal].[SystemSettingRegion]
GO

/****** Object:  Table [TapasGlobalBudgeting].[TaxType]    Script Date: 12/18/2009 16:07:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[TaxType]') AND type in (N'U'))
DROP TABLE [TapasGlobalBudgeting].[TaxType]
GO