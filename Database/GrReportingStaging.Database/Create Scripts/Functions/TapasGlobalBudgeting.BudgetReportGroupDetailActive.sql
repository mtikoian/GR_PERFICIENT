
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetReportGroupDetailActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobalBudgeting].[BudgetReportGroupDetailActive]
GO
CREATE FUNCTION [TapasGlobalBudgeting].[BudgetReportGroupDetailActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BudgetReportGroupDetail] B1
		INNER JOIN (
			SELECT 
				BudgetReportGroupDetailId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobalBudgeting].[BudgetReportGroupDetail]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY BudgetReportGroupDetailId
		) t1 ON t1.BudgetReportGroupDetailId = B1.BudgetReportGroupDetailId AND
				t1.UpdatedDate = B1.UpdatedDate
	WHERE B1.UpdatedDate <= @DataPriorToDate
	GROUP BY B1.BudgetReportGroupDetailId	
)

GO
 