
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetOverheadAllocationDetailActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetOverheadAllocationDetailActive]
GO
CREATE FUNCTION [TapasGlobalBudgeting].[BudgetOverheadAllocationDetailActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BudgetOverheadAllocationDetail] B1

		INNER JOIN (
		
			SELECT 
				B2.BudgetOverheadAllocationDetailId,
				MAX(B2.ImportBatchId) as ImportBatchId
			FROM 
				[TapasGlobalBudgeting].[BudgetOverheadAllocationDetail] B2
				
				INNER JOIN Batch ON
					B2.ImportBatchId = batch.BatchId
					
			WHERE	
				batch.BatchEndDate IS NOT NULL AND
				batch.PackageName = 'ETL.Staging.TapasGlobalBudgeting' AND
				batch.ImportEndDate <= @DataPriorToDate
					
			GROUP BY B2.BudgetOverheadAllocationDetailId
			
		) t1 ON 
			t1.BudgetOverheadAllocationDetailId = B1.BudgetOverheadAllocationDetailId AND
			t1.ImportBatchId = B1.ImportBatchId
	
	GROUP BY B1.BudgetOverheadAllocationDetailId
)

GO
 