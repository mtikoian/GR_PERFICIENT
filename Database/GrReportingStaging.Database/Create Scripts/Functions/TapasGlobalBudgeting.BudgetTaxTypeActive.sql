
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetTaxTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetTaxTypeActive]
GO
CREATE FUNCTION [TapasGlobalBudgeting].[BudgetTaxTypeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BudgetTaxType] B1

		INNER JOIN (
		
			SELECT 
				B2.BudgetTaxTypeId,
				MAX(B2.ImportBatchId) as ImportBatchId
			FROM 
				[TapasGlobalBudgeting].[BudgetTaxType] B2
				
				INNER JOIN Batch ON
					B2.ImportBatchId = batch.BatchId
					
			WHERE	
				batch.BatchEndDate IS NOT NULL AND
				batch.PackageName = 'ETL.Staging.TapasGlobalBudgeting' AND
				batch.ImportEndDate <= @DataPriorToDate
					
			GROUP BY B2.BudgetTaxTypeId
			
		) t1 ON 
			t1.BudgetTaxTypeId = B1.BudgetTaxTypeId AND
			t1.ImportBatchId = B1.ImportBatchId
	
	GROUP BY B1.BudgetTaxTypeId
)

GO
 