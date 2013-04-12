 USE GrReportingStaging
GO

DECLARE @BatchId INT = (SELECT MAX(BatchId) FROM dbo.BudgetsToProcess) + 1

DECLARE @GBSQ0ImportBatchId INT = (SELECT MAX(ImportBatchId) FROM dbo.BudgetsToProcess WHERE BudgetReforecastTypeName = 'GBS Budget/Reforecast' AND BudgetYear = 2011 AND BudgetQuarter = 'Q0')
DECLARE @GBSQ1ImportBatchId INT = (SELECT MAX(ImportBatchId) FROM dbo.BudgetsToProcess WHERE BudgetReforecastTypeName = 'GBS Budget/Reforecast' AND BudgetYear = 2011 AND BudgetQuarter = 'Q1')
DECLARE @TGBQ0ImportBatchId INT = (SELECT MAX(ImportBatchId) FROM dbo.BudgetsToProcess WHERE BudgetReforecastTypeName = 'TGB Budget/Reforecast' AND BudgetYear = 2011 AND BudgetQuarter = 'Q0')
DECLARE @TGBQ1ImportBatchId INT = (SELECT MAX(ImportBatchId) FROM dbo.BudgetsToProcess WHERE BudgetReforecastTypeName = 'TGB Budget/Reforecast' AND BudgetYear = 2011 AND BudgetQuarter = 'Q1')


INSERT INTO dbo.BudgetsToProcess
(
	BatchId,
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
	MustImportAllActualsIntoWarehouse
	
)
SELECT @BatchId, @TGBQ0ImportBatchId, 'TGB Budget/Reforecast', 97, 3, 5, 1, 0, 2011, 'Q0', 1, 1, NULL UNION ALL
SELECT @BatchId, @TGBQ0ImportBatchId, 'TGB Budget/Reforecast', 98, 3, 5, 1, 0, 2011, 'Q0', 1, 1, NULL UNION ALL
SELECT @BatchId, @TGBQ0ImportBatchId, 'TGB Budget/Reforecast', 99, 3, 5, 1, 0, 2011, 'Q0', 1, 1, NULL UNION ALL
SELECT @BatchId, @TGBQ0ImportBatchId, 'TGB Budget/Reforecast', 100, 3, 5, 1, 0, 2011, 'Q0', 1, 1, NULL UNION ALL
SELECT @BatchId, @TGBQ0ImportBatchId, 'TGB Budget/Reforecast', 101, 3, 5, 1, 0, 2011, 'Q0', 1, 1, NULL UNION ALL
SELECT @BatchId, @TGBQ0ImportBatchId, 'TGB Budget/Reforecast', 102, 3, 5, 1, 0, 2011, 'Q0', 1, 1, NULL UNION ALL
SELECT @BatchId, @TGBQ0ImportBatchId, 'TGB Budget/Reforecast', 104, 3, 5, 1, 0, 2011, 'Q0', 1, 1, NULL UNION ALL
SELECT @BatchId, @TGBQ0ImportBatchId, 'TGB Budget/Reforecast', 105, 3, 5, 1, 0, 2011, 'Q0', 1, 1, NULL UNION ALL
SELECT @BatchId, @TGBQ0ImportBatchId, 'TGB Budget/Reforecast', 106, 3, 5, 1, 0, 2011, 'Q0', 1, 1, NULL UNION ALL
SELECT @BatchId, @TGBQ0ImportBatchId, 'TGB Budget/Reforecast', 107, 3, 5, 1, 0, 2011, 'Q0', 1, 1, NULL UNION ALL
SELECT @BatchId, @TGBQ0ImportBatchId, 'TGB Budget/Reforecast', 108, 3, 5, 1, 0, 2011, 'Q0', 1, 1, NULL UNION ALL
SELECT @BatchId, @TGBQ0ImportBatchId, 'TGB Budget/Reforecast', 111, 3, 5, 1, 0, 2011, 'Q0', 1, 1, NULL UNION ALL
SELECT @BatchId, @TGBQ0ImportBatchId, 'TGB Budget/Reforecast', 129, 3, 5, 1, 0, 2011, 'Q0', 1, 1, NULL UNION ALL

SELECT @BatchId, @TGBQ1ImportBatchId, 'TGB Budget/Reforecast', 139, 5, 7, 1, 1, 2011, 'Q1', 8, 1, 1 UNION ALL
SELECT @BatchId, @TGBQ1ImportBatchId, 'TGB Budget/Reforecast', 140, 5, 7, 1, 1, 2011, 'Q1', 8, 1, 1 UNION ALL
SELECT @BatchId, @TGBQ1ImportBatchId, 'TGB Budget/Reforecast', 141, 5, 7, 1, 1, 2011, 'Q1', 8, 1, 1 UNION ALL
SELECT @BatchId, @TGBQ1ImportBatchId, 'TGB Budget/Reforecast', 142, 5, 7, 1, 1, 2011, 'Q1', 8, 1, 1 UNION ALL
SELECT @BatchId, @TGBQ1ImportBatchId, 'TGB Budget/Reforecast', 144, 5, 7, 1, 1, 2011, 'Q1', 8, 1, 1 UNION ALL
SELECT @BatchId, @TGBQ1ImportBatchId, 'TGB Budget/Reforecast', 145, 5, 7, 1, 1, 2011, 'Q1', 8, 1, 1 UNION ALL
SELECT @BatchId, @TGBQ1ImportBatchId, 'TGB Budget/Reforecast', 146, 5, 7, 1, 1, 2011, 'Q1', 8, 1, 1 UNION ALL
SELECT @BatchId, @TGBQ1ImportBatchId, 'TGB Budget/Reforecast', 147, 5, 7, 1, 1, 2011, 'Q1', 8, 1, 1 UNION ALL
SELECT @BatchId, @TGBQ1ImportBatchId, 'TGB Budget/Reforecast', 150, 5, 7, 1, 1, 2011, 'Q1', 8, 1, 1 UNION ALL
SELECT @BatchId, @TGBQ1ImportBatchId, 'TGB Budget/Reforecast', 151, 5, 7, 1, 1, 2011, 'Q1', 8, 1, 1 UNION ALL
SELECT @BatchId, @TGBQ1ImportBatchId, 'TGB Budget/Reforecast', 152, 5, 7, 1, 1, 2011, 'Q1', 8, 1, 1 UNION ALL
SELECT @BatchId, @TGBQ1ImportBatchId, 'TGB Budget/Reforecast', 153, 5, 7, 1, 1, 2011, 'Q1', 8, 1, 1 UNION ALL
SELECT @BatchId, @TGBQ1ImportBatchId, 'TGB Budget/Reforecast', 154, 5, 7, 1, 1, 2011, 'Q1', 8, 1, 1 UNION ALL

SELECT @BatchId, @GBSQ0ImportBatchId, 'GBS Budget/Reforecast', 1, 3, 5, 1, 0, 2011, 'Q0', 1, 1, NULL UNION ALL
SELECT @BatchId, @GBSQ1ImportBatchId, 'GBS Budget/Reforecast', 3, 5, 7, 1, 1, 2011, 'Q1', 8, 1, 1 

