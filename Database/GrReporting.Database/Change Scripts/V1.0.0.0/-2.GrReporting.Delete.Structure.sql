USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ExchangeRate_Calendar]') AND parent_object_id = OBJECT_ID(N'[dbo].[ExchangeRate]'))
ALTER TABLE [dbo].[ExchangeRate] DROP CONSTRAINT [FK_ExchangeRate_Calendar]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ExchangeRate_DestinationCurrency]') AND parent_object_id = OBJECT_ID(N'[dbo].[ExchangeRate]'))
ALTER TABLE [dbo].[ExchangeRate] DROP CONSTRAINT [FK_ExchangeRate_DestinationCurrency]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ExchangeRate_SourceCurrency]') AND parent_object_id = OBJECT_ID(N'[dbo].[ExchangeRate]'))
ALTER TABLE [dbo].[ExchangeRate] DROP CONSTRAINT [FK_ExchangeRate_SourceCurrency]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GlAccount_AccountType]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[GlAccount] DROP CONSTRAINT [DF_GlAccount_AccountType]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TypeHierarchy_AccountSubCategory]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[GlAccountCategory] DROP CONSTRAINT [DF_TypeHierarchy_AccountSubCategory]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_OriginatingRegion_SubRegionCode]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OriginatingRegion] DROP CONSTRAINT [DF_OriginatingRegion_SubRegionCode]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_OriginatingRegion_SubRegionName]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OriginatingRegion] DROP CONSTRAINT [DF_OriginatingRegion_SubRegionName]
END

GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_ActivityType]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_ActivityType]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_AllocationRegion]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_AllocationRegion]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_Calendar]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_Calendar]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_Currency]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_Currency]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_FunctionalDepartment]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_FunctionalDepartment]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_GlAccount]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_GlAccount]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_OriginatingRegion]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_OriginatingRegion]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_PropertyFund]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_PropertyFund]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_Reimbursable]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_Reimbursable]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_Source]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_Source]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualGlAccountCategoryBridge_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualGlAccountCategoryBridge]'))
ALTER TABLE [dbo].[ProfitabilityActualGlAccountCategoryBridge] DROP CONSTRAINT [FK_ProfitabilityActualGlAccountCategoryBridge_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualGlAccountCategoryBridge_ProfitabilityActual]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualGlAccountCategoryBridge]'))
ALTER TABLE [dbo].[ProfitabilityActualGlAccountCategoryBridge] DROP CONSTRAINT [FK_ProfitabilityActualGlAccountCategoryBridge_ProfitabilityActual]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_Activity]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_Activity]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_AllocationRegion]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_AllocationRegion]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_Calendar]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_Calendar]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_Currency]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_Currency]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_FunctionalDepartment]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_FunctionalDepartment]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_GlAccount]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_GlAccount]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_OriginatingRegion]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_OriginatingRegion]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_PropertyFund]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_PropertyFund]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_Reforecast]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_Reforecast]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_Reimbursable]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_Reimbursable]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_Source]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_Source]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ProfitabilityBudget_LocalCurrencyKey]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [DF_ProfitabilityBudget_LocalCurrencyKey]
END

GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudgetGlAccountCategoryBridge_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudgetGlAccountCategoryBridge]'))
ALTER TABLE [dbo].[ProfitabilityBudgetGlAccountCategoryBridge] DROP CONSTRAINT [FK_ProfitabilityBudgetGlAccountCategoryBridge_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudgetGlAccountCategoryBridge_ProfitabilityBudget]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudgetGlAccountCategoryBridge]'))
ALTER TABLE [dbo].[ProfitabilityBudgetGlAccountCategoryBridge] DROP CONSTRAINT [FK_ProfitabilityBudgetGlAccountCategoryBridge_ProfitabilityBudget]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Reimbursable_ReimbursableName]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Reimbursable] DROP CONSTRAINT [DF_Reimbursable_ReimbursableName]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Source_IsCorporate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Source] DROP CONSTRAINT [DF_Source_IsCorporate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Source_IsProperty]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Source] DROP CONSTRAINT [DF_Source_IsProperty]
END

GO

/****** Object:  Table [dbo].[ActivityType]    Script Date: 12/18/2009 16:12:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ActivityType]') AND type in (N'U'))
DROP TABLE [dbo].[ActivityType]
GO

/****** Object:  Table [dbo].[AllocationRegion]    Script Date: 12/18/2009 16:12:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AllocationRegion]') AND type in (N'U'))
DROP TABLE [dbo].[AllocationRegion]
GO

/****** Object:  Table [dbo].[Calendar]    Script Date: 12/18/2009 16:12:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Calendar]') AND type in (N'U'))
DROP TABLE [dbo].[Calendar]
GO

/****** Object:  Table [dbo].[Currency]    Script Date: 12/18/2009 16:12:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Currency]') AND type in (N'U'))
DROP TABLE [dbo].[Currency]
GO

/****** Object:  Table [dbo].[ExchangeRate]    Script Date: 12/18/2009 16:12:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ExchangeRate]') AND type in (N'U'))
DROP TABLE [dbo].[ExchangeRate]
GO

/****** Object:  Table [dbo].[FunctionalDepartment]    Script Date: 12/18/2009 16:12:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FunctionalDepartment]') AND type in (N'U'))
DROP TABLE [dbo].[FunctionalDepartment]
GO

/****** Object:  Table [dbo].[GlAccount]    Script Date: 12/18/2009 16:12:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GlAccount]') AND type in (N'U'))
DROP TABLE [dbo].[GlAccount]
GO

/****** Object:  Table [dbo].[GlAccountCategory]    Script Date: 12/18/2009 16:12:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GlAccountCategory]') AND type in (N'U'))
DROP TABLE [dbo].[GlAccountCategory]
GO

/****** Object:  Table [dbo].[OriginatingRegion]    Script Date: 12/18/2009 16:12:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OriginatingRegion]') AND type in (N'U'))
DROP TABLE [dbo].[OriginatingRegion]
GO

/****** Object:  Table [dbo].[ProfitabilityActual]    Script Date: 12/18/2009 16:12:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND type in (N'U'))
DROP TABLE [dbo].[ProfitabilityActual]
GO

/****** Object:  Table [dbo].[ProfitabilityActualGlAccountCategoryBridge]    Script Date: 12/18/2009 16:12:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualGlAccountCategoryBridge]') AND type in (N'U'))
DROP TABLE [dbo].[ProfitabilityActualGlAccountCategoryBridge]
GO

/****** Object:  Table [dbo].[ProfitabilityBudget]    Script Date: 12/18/2009 16:12:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND type in (N'U'))
DROP TABLE [dbo].[ProfitabilityBudget]
GO

/****** Object:  Table [dbo].[ProfitabilityBudgetGlAccountCategoryBridge]    Script Date: 12/18/2009 16:12:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudgetGlAccountCategoryBridge]') AND type in (N'U'))
DROP TABLE [dbo].[ProfitabilityBudgetGlAccountCategoryBridge]
GO

/****** Object:  Table [dbo].[PropertyFund]    Script Date: 12/18/2009 16:12:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PropertyFund]') AND type in (N'U'))
DROP TABLE [dbo].[PropertyFund]
GO

/****** Object:  Table [dbo].[Reforecast]    Script Date: 12/18/2009 16:12:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Reforecast]') AND type in (N'U'))
DROP TABLE [dbo].[Reforecast]
GO

/****** Object:  Table [dbo].[Reimbursable]    Script Date: 12/18/2009 16:12:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Reimbursable]') AND type in (N'U'))
DROP TABLE [dbo].[Reimbursable]
GO

/****** Object:  Table [dbo].[Source]    Script Date: 12/18/2009 16:12:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Source]') AND type in (N'U'))
DROP TABLE [dbo].[Source]
GO

