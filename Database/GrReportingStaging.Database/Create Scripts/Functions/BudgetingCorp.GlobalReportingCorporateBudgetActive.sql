
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BudgetingCorp].[GlobalReportingCorporateBudgetActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [BudgetingCorp].[GlobalReportingCorporateBudgetActive]
GO

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
				batch.PackageName = 'ETL.Staging.BudgetingCorp' AND
				batch.ImportEndDate <= @DataPriorToDate
				
		GROUP BY Budget.BudgetId
		) t1 ON 
			t1.BudgetId = B1.BudgetId AND
			t1.ImportBatchId = B1.ImportBatchId

)

GO
