-------------------------------------------
-- TapasGlobalBudgeting.ExchangeRateActive
-------------------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[ExchangeRateActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [TapasGlobalBudgeting].[ExchangeRateActive]
GO

-------------------------------------------------
-- TapasGlobalBudgeting.ExchangeRateDetailActive
-------------------------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[ExchangeRateDetailActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [TapasGlobalBudgeting].[ExchangeRateDetailActive]
GO

--------------------------------------------------------
-- TapasGlobalBudgeting.GRBudgetReportGroupPeriodActive
--------------------------------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[GRBudgetReportGroupPeriodActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [TapasGlobalBudgeting].[GRBudgetReportGroupPeriodActive]
GO