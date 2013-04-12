
USE [GrReporting]
GO

/****** Object:  UserDefinedFunction [dbo].[SPLIT]    Script Date: 12/10/2009 09:58:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualGlAccountCategoryBridgeVirtual]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ProfitabilityActualGlAccountCategoryBridgeVirtual]
GO

/********************************************************************/
--Description:  Split comma seperated varchar
--History: 
--         [yyyy-mm-dd]	: [Person]	: [Details of changes made] 
--  This function return all the virtual rows, to include in joins.
--	Logic: if a GlAccount is not mapped to ANY GlAccountCategoryHierarchy, then it must be shown as a UNKNOWN record
--	on each Group, unitl the GlobalGlAccount is mapped to 1 or more GlAccountCategoryHierarchyGroup
/********************************************************************/
/*
CREATE FUNCTION [dbo].[ProfitabilityActualGlAccountCategoryBridgeVirtual]
(
@CalendarYear Int,
@ReportExpensePeriod Int,
@HierarchyName VARCHAR(50)
)
RETURNS @ProfitabilityActualGlAccountCategoryBridgeVirtual TABLE 
(
	ProfitabilityActualKey Int NOT NULL, 
	GlAccountCategoryKey Int NOT NULL ,
	PRIMARY KEY CLUSTERED 
	(
		ProfitabilityActualKey,
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

	Insert Into @ProfitabilityActualGlAccountCategoryBridgeVirtual
	(ProfitabilityActualKey, GlAccountCategoryKey)
	Select 
			Pa.ProfitabilityActualKey,
			@GlAccountCategoryKey
	From 
			dbo.ProfitabilityActual Pa 
				INNER JOIN dbo.Calendar Ca ON Ca.CalendarKey = Pa.CalendarKey
				LEFT OUTER JOIN dbo.ProfitabilityActualGlAccountCategoryBridge GlB ON GlB.ProfitabilityActualKey = Pa.ProfitabilityActualKey
	Where GlB.ProfitabilityActualKey IS NULL
	AND Ca.CalendarYear = @CalendarYear
	AND Ca.CalendarPeriod <= @ReportExpensePeriod
	
	RETURN
END
*/