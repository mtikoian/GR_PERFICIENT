/*
	dbo.BudgetsToProcessCurrent()
*/

USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [dbo].[BudgetsToProcessCurrent]    Script Date: 05/02/2011 09:17:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BudgetsToProcessCurrent]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[BudgetsToProcessCurrent]
GO

USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [dbo].[BudgetsToProcessCurrent]    Script Date: 05/02/2011 09:17:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



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

GO
