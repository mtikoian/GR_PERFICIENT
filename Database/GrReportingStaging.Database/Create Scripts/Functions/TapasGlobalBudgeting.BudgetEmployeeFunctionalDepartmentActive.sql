
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartmentActive]
GO
CREATE FUNCTION [TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartmentActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartment] B1

		INNER JOIN (
		
			SELECT 
				B2.BudgetEmployeeFunctionalDepartmentId,
				MAX(B2.ImportBatchId) as ImportBatchId
			FROM 
				[TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartment] B2
				
				INNER JOIN Batch ON
					B2.ImportBatchId = batch.BatchId
					
			WHERE	
				batch.BatchEndDate IS NOT NULL AND
				batch.PackageName = 'ETL.Staging.TapasGlobalBudgeting' AND
				batch.ImportEndDate <= @DataPriorToDate
					
			GROUP BY B2.BudgetEmployeeFunctionalDepartmentId
			
		) t1 ON 
			t1.BudgetEmployeeFunctionalDepartmentId = B1.BudgetEmployeeFunctionalDepartmentId AND
			t1.ImportBatchId = B1.ImportBatchId
	
	GROUP BY B1.BudgetEmployeeFunctionalDepartmentId
)

GO
