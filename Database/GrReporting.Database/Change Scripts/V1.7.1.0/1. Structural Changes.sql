USE GrReporting
GO
 
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ProfitabilityActual' AND COLUMN_NAME = 'ConsolidationRegionKey')
BEGIN
ALTER TABLE [dbo].ProfitabilityActual
	ADD ConsolidationRegionKey INT NULL
END 
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ProfitabilityBudget' AND COLUMN_NAME = 'ConsolidationRegionKey')
BEGIN
ALTER TABLE [dbo].ProfitabilityBudget
	ADD ConsolidationRegionKey INT NULL
END 
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ProfitabilityReforecast' AND COLUMN_NAME = 'ConsolidationRegionKey')
BEGIN
ALTER TABLE [dbo].ProfitabilityReforecast
	ADD ConsolidationRegionKey INT NULL
END 
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ProfitabilityActualArchive' AND COLUMN_NAME = 'ConsolidationRegionKey')
BEGIN
ALTER TABLE [dbo].ProfitabilityActualArchive
	ADD ConsolidationRegionKey INT NULL
END 
GO