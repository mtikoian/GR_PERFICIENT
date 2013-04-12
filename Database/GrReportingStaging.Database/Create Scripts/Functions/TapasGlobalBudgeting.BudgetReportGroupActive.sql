
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetReportGroupActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetReportGroupActive]
GO
CREATE FUNCTION [TapasGlobalBudgeting].[BudgetReportGroupActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BudgetReportGroup] B1
		INNER JOIN (
			SELECT 
				BudgetReportGroupId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobalBudgeting].[BudgetReportGroup]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY BudgetReportGroupId
		) t1 ON t1.BudgetReportGroupId = B1.BudgetReportGroupId AND
				t1.UpdatedDate = B1.UpdatedDate
	WHERE B1.UpdatedDate <= @DataPriorToDate
	GROUP BY B1.BudgetReportGroupId	
)

GO
 