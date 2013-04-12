 /****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetStatusActive]    Script Date: 11/09/2009 09:53:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetStatusActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetStatusActive]
GO

/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetStatusActive]    Script Date: 11/09/2009 09:53:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [TapasGlobalBudgeting].[BudgetStatusActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
	[TapasGlobalBudgeting].[BudgetStatus] B1
		INNER JOIN (
			SELECT 
				BudgetStatusId,
				MAX(InsertedDate) InsertedDate
			FROM 
				[TapasGlobalBudgeting].[BudgetStatus]
			WHERE	InsertedDate <= @DataPriorToDate
			GROUP BY BudgetStatusId
		) t1 ON t1.BudgetStatusId = B1.BudgetStatusId AND
				t1.InsertedDate = B1.InsertedDate
	WHERE B1.InsertedDate <= @DataPriorToDate
	GROUP BY B1.BudgetStatusId	
)

GO


