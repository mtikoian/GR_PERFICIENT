 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[TaxTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[TaxTypeActive]
GO
CREATE FUNCTION [TapasGlobalBudgeting].[TaxTypeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[TaxType] B1
		INNER JOIN (
			SELECT 
				TaxTypeId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobalBudgeting].[TaxType]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY TaxTypeId
		) t1 ON t1.TaxTypeId = B1.TaxTypeId AND
				t1.UpdatedDate = B1.UpdatedDate
	WHERE B1.UpdatedDate <= @DataPriorToDate
	GROUP BY B1.TaxTypeId	
)

GO
 