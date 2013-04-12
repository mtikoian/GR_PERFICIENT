IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[BudgetExchangeRateDetailActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [Gdm].[BudgetExchangeRateDetailActive]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Gdm].[BudgetExchangeRateDetailActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[Gdm].[BudgetExchangeRateDetail] B1
		INNER JOIN (
			SELECT 
				BudgetExchangeRateDetailId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[BudgetExchangeRateDetail]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY BudgetExchangeRateDetailId
		) t1 ON t1.BudgetExchangeRateDetailId = B1.BudgetExchangeRateDetailId AND
				t1.UpdatedDate = B1.UpdatedDate
	WHERE B1.UpdatedDate <= @DataPriorToDate
	GROUP BY B1.BudgetExchangeRateDetailId	
)

GO