USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_U_SyncBudgetsProcessed]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[stp_U_SyncBudgetsProcessed]
GO

CREATE PROCEDURE [dbo].[stp_U_SyncBudgetsProcessed]	

AS

-- Update GBS.dbo.Budget  

UPDATE
	Budget
SET
	Budget.CanImportBudgetIntoGR = 0,
	Budget.LastImportBudgetIntoGRDate = BTP.DateBudgetProcessedIntoWarehouse
FROM
	SERVER3.GBS.dbo.Budget Budget
	INNER JOIN dbo.BudgetsToProcess BTP ON
		Budget.BudgetId = BTP.BudgetId

WHERE
	BTP.BudgetReforecastTypeName = 'GBS Budget/Reforecast' AND
	BTP.IsCurrentBatch = 1 AND
	Budget.IsActive = 1

-- Update GBS.dbo.Budget  

UPDATE
	TAPAS
SET
	TAPAS.ImportBudgetIntoGR = 0,
	TAPAS.LastImportBudgetIntoGRDate = BTP.DateBudgetProcessedIntoWarehouse
FROM
	SERVER3.TAPASUS_Budgeting.Budget.Budget TAPAS
	INNER JOIN dbo.BudgetsToProcess BTP ON
		TAPAS.BudgetId = BTP.BudgetId

WHERE
	BTP.BudgetReforecastTypeName = 'TGB Budget/Reforecast' AND
	BTP.IsCurrentBatch = 1 AND
	TAPAS.IsDeleted = 0

-- Update GrReportingStaging.dbo.BudgetsToProcess

UPDATE
	dbo.BudgetsToProcess
SET
	BudgetSourceSystemSyncd = 1
WHERE
	BudgetSourceSystemSyncd IS NULL AND
	IsCurrentBatch = 1

GO