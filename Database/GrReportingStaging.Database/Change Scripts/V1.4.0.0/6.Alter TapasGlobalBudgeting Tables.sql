
USE [GrReportingStaging]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[Budget]') AND type in (N'U'))
BEGIN

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'TapasGlobalBudgeting' AND TABLE_NAME = 'Budget' AND COLUMN_NAME = 'BudgetAllocationSetId')
	BEGIN
		ALTER TABLE [TapasGlobalBudgeting].[Budget] ADD BudgetAllocationSetId INT NULL
			PRINT ('Column [BudgetAllocationSetId] added to [TapasGlobalBudgeting].[Budget]')
	END
	ELSE
	BEGIN
		PRINT ('Can''t add column [BudgetAllocationSetId] to [TapasGlobalBudgeting].[Budget] because it already exists.')
	END

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'TapasGlobalBudgeting' AND TABLE_NAME = 'Budget' AND COLUMN_NAME = 'LastAMUpdateDate')
	BEGIN
		ALTER TABLE [TapasGlobalBudgeting].[Budget] ADD LastAMUpdateDate DATETIME NULL
			PRINT ('Column [LastAMUpdateDate] added to [TapasGlobalBudgeting].[Budget]')
	END
	ELSE
	BEGIN
		PRINT ('Can''t add column [LastAMUpdateDate] to [TapasGlobalBudgeting].[Budget] because it already exists.')
	END
	
END

GO

USE [GrReportingStaging]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetProject]') AND type in (N'U'))
BEGIN

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'TapasGlobalBudgeting' AND TABLE_NAME = 'BudgetProject' AND COLUMN_NAME = 'AMBudgetProjectId')
	BEGIN
		ALTER TABLE [TapasGlobalBudgeting].[BudgetProject] ADD AMBudgetProjectId INT NULL
			PRINT ('Column [AMBudgetProjectId] added to [TapasGlobalBudgeting].[BudgetProject]')
	END
	ELSE
	BEGIN
		PRINT ('Can''t add column [AMBudgetProjectId] to [TapasGlobalBudgeting].[BudgetProject] because it already exists.')
	END
	
END

GO

USE [GrReportingStaging]

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'TapasGlobalBudgeting' AND TABLE_NAME = 'BudgetReportGroup' AND COLUMN_NAME = 'ExchangeRateId')
BEGIN
	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'TapasGlobalBudgeting' AND  TABLE_NAME = 'BudgetReportGroup' AND COLUMN_NAME = 'BudgetExchangeRateId')
	BEGIN    
		EXEC sp_rename '[TapasGlobalBudgeting].[BudgetReportGroup].ExchangeRateId', 'BudgetExchangeRateId', 'COLUMN'
		PRINT ('[TapasGlobalBudgeting].[BudgetReportGroup].ExchangeRateId renamed to BudgetExchangeRateId')
	END
	ELSE
	BEGIN
		PRINT ('Can''t rename [TapasGlobalBudgeting].[BudgetReportGroup].ExchangeRateId to [BudgetExchangeRateId] because column with this name already exists')
	END
END    
	
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'TapasGlobalBudgeting' AND  TABLE_NAME = 'BudgetReportGroup' AND COLUMN_NAME = 'BudgetReportGroupPeriodId')
BEGIN
	ALTER TABLE [TapasGlobalBudgeting].[BudgetReportGroup] ADD BudgetReportGroupPeriodId INT NULL
		PRINT ('Column [BudgetReportGroupPeriodId] added to [TapasGlobalBudgeting].[BudgetReportGroup]')
END
ELSE
BEGIN
	PRINT ('Can''t add column [BudgetReportGroupPeriodId] to [TapasGlobalBudgeting].[BudgetReportGroup] because it already exists.')
END

GO
