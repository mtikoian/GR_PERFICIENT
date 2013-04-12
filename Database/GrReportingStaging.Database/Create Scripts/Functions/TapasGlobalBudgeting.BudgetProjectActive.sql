
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetProjectActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetProjectActive]
GO
CREATE FUNCTION [TapasGlobalBudgeting].[BudgetProjectActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BudgetProject] B1

		INNER JOIN (
		
			SELECT 
				B2.BudgetProjectId,
				MAX(B2.ImportBatchId) as ImportBatchId
			FROM 
				[TapasGlobalBudgeting].[BudgetProject] B2
					
				INNER JOIN Batch ON
					B2.ImportBatchId = batch.BatchId
					
			WHERE	
				batch.BatchEndDate IS NOT NULL AND
				batch.PackageName = 'ETL.Staging.TapasGlobalBudgeting' AND
				batch.ImportEndDate <= @DataPriorToDate
					
			GROUP BY B2.BudgetProjectId
			
		) t1 ON 
			t1.BudgetProjectId = B1.BudgetProjectId AND
			t1.ImportBatchId = B1.ImportBatchId
	
	GROUP BY B1.BudgetProjectId
)

GO
