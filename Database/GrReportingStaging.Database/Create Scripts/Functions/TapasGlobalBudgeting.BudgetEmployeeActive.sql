
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetEmployeeActive]
GO
CREATE FUNCTION [TapasGlobalBudgeting].[BudgetEmployeeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BudgetEmployee] B1

		INNER JOIN (
		
			SELECT 
				B2.BudgetEmployeeId,
				MAX(B2.ImportBatchId) as ImportBatchId
			FROM 
				[TapasGlobalBudgeting].[BudgetEmployee] B2
					
				INNER JOIN Batch ON
					B2.ImportBatchId = batch.BatchId
					
			WHERE	
				batch.BatchEndDate IS NOT NULL AND
				batch.PackageName = 'ETL.Staging.TapasGlobalBudgeting' AND
				batch.ImportEndDate <= @DataPriorToDate
					
			GROUP BY B2.BudgetEmployeeId
		
		) t1 ON 
			t1.BudgetEmployeeId = B1.BudgetEmployeeId AND
			t1.ImportBatchId = B1.ImportBatchId
	
	GROUP BY B1.BudgetEmployeeId
)

GO
