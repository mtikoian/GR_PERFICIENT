--------------------------------------------------
-- TapasGlobalBudgeting.GRBudgetReportGroupPeriod
--------------------------------------------------

USE [GrReportingStaging]
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

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[GRBudgetReportGroupPeriod]') AND type in (N'U'))
DROP TABLE [TapasGlobalBudgeting].[GRBudgetReportGroupPeriod]
GO

-------------------------------------------
-- TapasGlobalBudgeting.ExchangeRateDetail
-------------------------------------------

USE [GrReportingStaging]
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

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[ExchangeRateDetail]') AND type in (N'U'))
DROP TABLE [TapasGlobalBudgeting].[ExchangeRateDetail]
GO

-------------------------------------------
-- TapasGlobalBudgeting.ExchangeRate
-------------------------------------------

USE [GrReportingStaging]
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

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[ExchangeRate]') AND type in (N'U'))
DROP TABLE [TapasGlobalBudgeting].[ExchangeRate]
GO
