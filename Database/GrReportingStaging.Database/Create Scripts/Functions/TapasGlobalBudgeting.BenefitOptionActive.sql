
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BenefitOptionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BenefitOptionActive]
GO
CREATE FUNCTION [TapasGlobalBudgeting].[BenefitOptionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BenefitOption] B1
		INNER JOIN (
		
			SELECT 
				BenefitOptionId,
				MAX(InsertedDate) InsertedDate
			FROM 
				[TapasGlobalBudgeting].[BenefitOption]
			WHERE	InsertedDate <= @DataPriorToDate
			GROUP BY BenefitOptionId
		
		) t1 ON t1.BenefitOptionId = B1.BenefitOptionId AND
				t1.InsertedDate = B1.InsertedDate
	WHERE B1.InsertedDate <= @DataPriorToDate
	GROUP BY B1.BenefitOptionId	
)

GO
