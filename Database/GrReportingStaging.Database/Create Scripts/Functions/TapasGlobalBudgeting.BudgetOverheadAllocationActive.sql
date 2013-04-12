
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetOverheadAllocationActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetOverheadAllocationActive]
GO
CREATE FUNCTION [TapasGlobalBudgeting].[BudgetOverheadAllocationActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BudgetOverheadAllocation] B1

		INNER JOIN (
		
			SELECT 
				B2.BudgetOverheadAllocationId,
				MAX(B2.ImportBatchId) as ImportBatchId
			FROM 
				[TapasGlobalBudgeting].[BudgetOverheadAllocation] B2
					
				INNER JOIN Batch ON
					B2.ImportBatchId = batch.BatchId
					
			WHERE	
				batch.BatchEndDate IS NOT NULL AND
				batch.PackageName = 'ETL.Staging.TapasGlobalBudgeting' AND
				batch.ImportEndDate <= @DataPriorToDate
					
			GROUP BY B2.BudgetOverheadAllocationId
			
		) t1 ON 
			t1.BudgetOverheadAllocationId = B1.BudgetOverheadAllocationId AND
			t1.ImportBatchId = B1.ImportBatchId
	
	GROUP BY B1.BudgetOverheadAllocationId
)

GO
 