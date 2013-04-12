USE [GrReporting]
GO

/****** Object:  UserDefinedFunction [dbo].[ProfitabilityActualGlAccountCategoryBridgeVirtual]    Script Date: 12/28/2009 16:19:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/********************************************************************/
--Description:  Split comma seperated varchar
--History: 
--         [yyyy-mm-dd]	: [Person]	: [Details of changes made] 
--  This function return all the virtual rows, to include in joins.
--	Logic: if a GlAccount is not mapped to ANY GlAccountCategoryHierarchy, then it must be shown as a UNKNOWN record
--	on each Group, unitl the GlobalGlAccount is mapped to 1 or more GlAccountCategoryHierarchyGroup
/********************************************************************/

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
GO

/****** Object:  UserDefinedFunction [dbo].[ProfitabilityBudgetGlAccountCategoryBridgeVirtual]    Script Date: 12/28/2009 16:19:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/********************************************************************/
--Description:  Split comma seperated varchar
--History: 
--         [yyyy-mm-dd]	: [Person]	: [Details of changes made] 
--	Logic: if a GlAccount is not mapped to ANY GlAccountCategoryHierarchy, then it must be shown as a UNKNOWN record
--	on each Group, unitl the GlobalGlAccount is mapped to 1 or more GlAccountCategoryHierarchyGroup
/********************************************************************/

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
GO

/****** Object:  UserDefinedFunction [dbo].[SPLIT]    Script Date: 12/28/2009 16:19:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/********************************************************************/
--Description:  Split comma seperated varchar
--History: 
--         [yyyy-mm-dd]	: [Person]	: [Details of changes made] 
/********************************************************************/

CREATE FUNCTION [dbo].[SPLIT]
(
@itemList TEXT
)
RETURNS @ReturnTable TABLE (item varchar(100) NOT NULL)

AS
BEGIN

	DECLARE	@CommaIndexLen int,
		@IdCounter int,
		@CurrentChar varchar(1),
		@Id varchar(100),
		@TerminateIn int

	DECLARE	@itemTable TABLE (item varchar(100) NOT NULL)

	SET @TerminateIn = 0
	SET @IdCounter = 1
	SET @Id = ''

	-- @TerminateIn var is for catching infinite loops. If this is not returning all data, then increase the number
	WHILE  @IdCounter <= DATALENGTH(@itemList) AND @TerminateIn <= 500000
	BEGIN
		SET @CurrentChar = SUBSTRING(@itemList,@IdCounter, 1)

		IF @CurrentChar = '|'
		BEGIN
			INSERT INTO @itemTable (item)
			SELECT LTRIM(RTRIM(@Id))
			-- Clear the Id variable
			SET @Id = ''
		END
		ELSE
		BEGIN
			SET @Id = @Id + @CurrentChar
		END

		--Move to next Char
		SET @IdCounter = @IdCounter + 1
		SET @TerminateIn = @TerminateIn + 1
	END

	INSERT INTO @itemTable (item)
	SELECT @Id

	INSERT INTO @ReturnTable (item)
	SELECT DISTINCT item FROM @itemTable

	RETURN
	
END 


GO


