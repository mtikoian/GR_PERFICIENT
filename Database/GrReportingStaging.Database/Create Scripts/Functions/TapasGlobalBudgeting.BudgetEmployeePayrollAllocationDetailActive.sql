
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetailActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetailActive]
GO
CREATE FUNCTION [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetailActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B1

		INNER JOIN (
		
			SELECT 
				B2.BudgetEmployeePayrollAllocationDetailId,
				MAX(B2.ImportBatchId) as ImportBatchId
			FROM 
				[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B2
					
				INNER JOIN Batch ON
					B2.ImportBatchId = batch.BatchId
					
			WHERE	
				batch.BatchEndDate IS NOT NULL AND
				batch.PackageName = 'ETL.Staging.TapasGlobalBudgeting' AND
				batch.ImportEndDate <= @DataPriorToDate
					
			GROUP BY B2.BudgetEmployeePayrollAllocationDetailId
			
		) t1 ON 
			t1.BudgetEmployeePayrollAllocationDetailId = B1.BudgetEmployeePayrollAllocationDetailId AND
			t1.ImportBatchId = B1.ImportBatchId
	
	GROUP BY B1.BudgetEmployeePayrollAllocationDetailId
)

GO
