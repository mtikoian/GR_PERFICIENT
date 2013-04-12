USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetProjectGroupActive]    Script Date: 08/07/2012 23:03:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetProjectGroupActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetProjectGroupActive]
GO

USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetProjectGroupActive]    Script Date: 08/07/2012 23:03:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   FUNCTION [TapasGlobalBudgeting].[BudgetProjectGroupActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Pg1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BudgetProjectGroup] Pg1
		INNER JOIN (
			SELECT 
				BudgetProjectGroupId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobalBudgeting].[BudgetProjectGroup]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY BudgetProjectGroupId
		) t1 ON t1.BudgetProjectGroupId = Pg1.BudgetProjectGroupId AND
				t1.UpdatedDate = Pg1.UpdatedDate
	WHERE Pg1.UpdatedDate <= @DataPriorToDate
	GROUP BY Pg1.BudgetProjectGroupId	
)



GO


