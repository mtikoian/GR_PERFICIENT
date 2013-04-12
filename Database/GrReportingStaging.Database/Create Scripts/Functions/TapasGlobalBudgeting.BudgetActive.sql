
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetActive]
GO
CREATE FUNCTION [TapasGlobalBudgeting].[BudgetActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[Budget] B1
	
		INNER JOIN (
		
			SELECT 
				Budget.BudgetId,
				MAX(Budget.ImportBatchId) as ImportBatchId
			FROM 
				[TapasGlobalBudgeting].[Budget] budget
					
				INNER JOIN Batch ON
					Budget.ImportBatchId = batch.BatchId
					
			WHERE	
				batch.BatchEndDate IS NOT NULL AND
				batch.PackageName = 'ETL.Staging.TapasGlobalBudgeting' AND
				batch.ImportEndDate <= @DataPriorToDate
					
			GROUP BY Budget.BudgetId
		
		) t1 ON 
			t1.BudgetId = B1.BudgetId AND
			t1.ImportBatchId = B1.ImportBatchId
	
	GROUP BY B1.BudgetId	
)

GO
