IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[BudgetExchangeRateActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [Gdm].[BudgetExchangeRateActive]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Gdm].[BudgetExchangeRateActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[Gdm].[BudgetExchangeRate] B1
		INNER JOIN (
			SELECT 
				BudgetExchangeRateId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[BudgetExchangeRate]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY BudgetExchangeRateId
		) t1 ON t1.BudgetExchangeRateId = B1.BudgetExchangeRateId AND
				t1.UpdatedDate = B1.UpdatedDate
	WHERE B1.UpdatedDate <= @DataPriorToDate
	GROUP BY B1.BudgetExchangeRateId	
)

GO