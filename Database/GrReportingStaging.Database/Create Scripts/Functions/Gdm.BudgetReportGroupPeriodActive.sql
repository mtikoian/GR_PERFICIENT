IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[BudgetReportGroupPeriodActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [Gdm].[BudgetReportGroupPeriodActive]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Gdm].[BudgetReportGroupPeriodActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[Gdm].[BudgetReportGroupPeriod] B1
		INNER JOIN (
			SELECT 
				BudgetReportGroupPeriodId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[BudgetReportGroupPeriod]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY BudgetReportGroupPeriodId
		) t1 ON t1.BudgetReportGroupPeriodId = B1.BudgetReportGroupPeriodId AND
				t1.UpdatedDate = B1.UpdatedDate
	WHERE B1.UpdatedDate <= @DataPriorToDate
	GROUP BY B1.BudgetReportGroupPeriodId	
)

GO