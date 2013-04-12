USE [GrReporting]
GO

/****** Object:  UserDefinedFunction [dbo].[SPLIT]    Script Date: 12/10/2009 09:58:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudgetGlAccountCategoryBridgeVirtual]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ProfitabilityBudgetGlAccountCategoryBridgeVirtual]
GO

/********************************************************************/
--Description:  Split comma seperated varchar
--History: 
--         [yyyy-mm-dd]	: [Person]	: [Details of changes made] 
--	Logic: if a GlAccount is not mapped to ANY GlAccountCategoryHierarchy, then it must be shown as a UNKNOWN record
--	on each Group, unitl the GlobalGlAccount is mapped to 1 or more GlAccountCategoryHierarchyGroup
/********************************************************************/
/*
CREATE FUNCTION [dbo].[ProfitabilityBudgetGlAccountCategoryBridgeVirtual]
(
@CalendarYear Int,
@ReportExpensePeriod Int,
@HierarchyName VARCHAR(50)
)
RETURNS @ProfitabilityBudgetGlAccountCategoryBridgeVirtual TABLE 
(
	ProfitabilityBudgetKey Int NOT NULL, 
	GlAccountCategoryKey Int NOT NULL ,
	PRIMARY KEY CLUSTERED 
	(
		ProfitabilityBudgetKey,
		GlAccountCategoryKey
	)
)

AS
BEGIN
	DECLARE @GlAccountCategoryKey Int 		
	SET @GlAccountCategoryKey = (
	Select GlAccountCategoryKey 
	From GlAccountCategory 
	Where GlobalGlAccountCategoryCode like '%-1%' 
	And HierarchyName = @HierarchyName)

	Insert Into @ProfitabilityBudgetGlAccountCategoryBridgeVirtual
	(ProfitabilityBudgetKey, GlAccountCategoryKey)
	Select 
			Pb.ProfitabilityBudgetKey,
			@GlAccountCategoryKey
	From 
			dbo.ProfitabilityBudget Pb 
				INNER JOIN dbo.Calendar Ca ON Ca.CalendarKey = Pb.CalendarKey
				LEFT OUTER JOIN dbo.ProfitabilityBudgetGlAccountCategoryBridge GlB ON GlB.ProfitabilityBudgetKey = Pb.ProfitabilityBudgetKey
	Where GlB.ProfitabilityBudgetKey IS NULL
	AND Ca.CalendarYear = @CalendarYear
	AND Ca.CalendarPeriod <= @ReportExpensePeriod
	
	RETURN
END
*/