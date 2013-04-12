
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationActive]
GO
CREATE FUNCTION [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	Select 
		MAX(B1.ImportKey) ImportKey
	From
		[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocation] B1

		INNER JOIN (
		
			SELECT 
				B2.BudgetEmployeePayrollAllocationId,
				MAX(B2.ImportBatchId) as ImportBatchId
			FROM 
				[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocation] B2
					
				INNER JOIN Batch ON
					B2.ImportBatchId = batch.BatchId
					
			WHERE	
				batch.BatchEndDate IS NOT NULL AND
				batch.PackageName = 'ETL.Staging.TapasGlobalBudgeting' AND
				batch.ImportEndDate <= @DataPriorToDate
					
			GROUP BY B2.BudgetEmployeePayrollAllocationId
			
		) t1 ON 
			t1.BudgetEmployeePayrollAllocationId = B1.BudgetEmployeePayrollAllocationId AND
			t1.ImportBatchId = B1.ImportBatchId
	
	GROUP BY B1.BudgetEmployeePayrollAllocationId
)

GO
