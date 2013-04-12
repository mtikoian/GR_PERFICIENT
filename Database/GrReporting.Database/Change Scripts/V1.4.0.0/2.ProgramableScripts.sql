USE [GrReporting]
GO
/****** Object:  UserDefinedFunction [dbo].[ProfitabilityBudgetGlAccountCategoryBridgeVirtual]    Script Date: 08/05/2010 15:11:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudgetGlAccountCategoryBridgeVirtual]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ProfitabilityBudgetGlAccountCategoryBridgeVirtual]
GO
/****** Object:  View [dbo].[ProfitabilityFact]    Script Date: 08/05/2010 15:11:41 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityFact]'))
DROP VIEW [dbo].[ProfitabilityFact]
GO
/****** Object:  UserDefinedFunction [dbo].[ProfitabilityActualGlAccountCategoryBridgeVirtual]    Script Date: 08/05/2010 15:11:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualGlAccountCategoryBridgeVirtual]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ProfitabilityActualGlAccountCategoryBridgeVirtual]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]    Script Date: 08/05/2010 15:11:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyCorporateReforecast]    Script Date: 08/05/2010 15:11:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyCorporateReforecast]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyCorporateReforecast]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]    Script Date: 08/05/2010 15:11:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]    Script Date: 08/05/2010 15:11:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_MissingExchangeRates]    Script Date: 08/05/2010 15:11:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_MissingExchangeRates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_MissingExchangeRates]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_Profitability]    Script Date: 08/05/2010 15:11:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_Profitability]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_Profitability]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginatorJobCodeDetail]    Script Date: 08/05/2010 15:11:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOriginatorJobCodeDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_BudgetOriginatorJobCodeDetail]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginatorOwnerEntity]    Script Date: 08/05/2010 15:11:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOriginatorOwnerEntity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_BudgetOriginatorOwnerEntity]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginatorOwnerFunctionalDepartment]    Script Date: 08/05/2010 15:11:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOriginatorOwnerFunctionalDepartment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_BudgetOriginatorOwnerFunctionalDepartment]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzar]    Script Date: 08/05/2010 15:11:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzar]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ExpenseCzar]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzarDetail]    Script Date: 08/05/2010 15:11:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzarDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ExpenseCzarDetail]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzarTotalComparison]    Script Date: 08/05/2010 15:11:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzarTotalComparison]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ExpenseCzarTotalComparison]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzarTotalComparisonDetail]    Script Date: 08/05/2010 15:11:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzarTotalComparisonDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ExpenseCzarTotalComparisonDetail]
GO
/****** Object:  UserDefinedFunction [dbo].[SPLIT]    Script Date: 08/05/2010 15:11:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPLIT]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[SPLIT]
GO
/****** Object:  UserDefinedFunction [dbo].[SPLIT]    Script Date: 08/05/2010 15:11:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPLIT]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/********************************************************************/
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
	SET @Id = ''''

	-- @TerminateIn var is for catching infinite loops. If this is not returning all data, then increase the number
	WHILE  @IdCounter <= DATALENGTH(@itemList) AND @TerminateIn <= 500000
	BEGIN
		SET @CurrentChar = SUBSTRING(@itemList,@IdCounter, 1)

		IF @CurrentChar = ''|''
		BEGIN
			INSERT INTO @itemTable (item)
			SELECT LTRIM(RTRIM(@Id))
			-- Clear the Id variable
			SET @Id = ''''
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
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzarTotalComparisonDetail]    Script Date: 08/05/2010 15:11:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzarTotalComparisonDetail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[stp_R_ExpenseCzarTotalComparisonDetail]
	@ReportExpensePeriod INT = NULL,
	@ReforecastQuaterName VARCHAR(10) = NULL, --''Q1'' or ''Q2'' or ''Q3''
	@PreviousReforecastQuaterName VARCHAR(10) = ''Q1'', -- or ''Q2'' or ''Q3''
	@DestinationCurrency VARCHAR(3) = NULL,
	@TranslationTypeName VARCHAR(50) = ''Global'',
	@IsGross bit = 1,
	@FunctionalDepartmentList TEXT = NULL,
	@ActivityTypeList TEXT = NULL,
	@EntityList TEXT = NULL,
	@MajorAccountCategoryList TEXT = NULL,
	@MinorAccountCategoryList TEXT = NULL,
	@AllocationRegionList TEXT = NULL,
	@AllocationSubRegionList TEXT = NULL,
	@OriginatingRegionList TEXT = NULL,
	@OriginatingSubRegionList TEXT = NULL

AS
/*
	DECLARE @ReportExpensePeriod   INT,
	@AccountCategoryList   VARCHAR(8000),
	@DestinationCurrency   VARCHAR(3),
	@TranslationTypeName         VARCHAR(50),
	@FunctionalDepartmentList VARCHAR(8000),
	@AllocationRegionList VARCHAR(8000),
	@EntityList VARCHAR(8000)
	
	
	SET @ReportExpensePeriod = 201011
	SET @AccountCategoryList = ''IT Costs & Telecommunications''
	SET @DestinationCurrency =''USD''
	SET @TranslationTypeName = ''Global''
	SET @FunctionalDepartmentList = ''Information Technologies''
	SET @AllocationRegionList = NULL
	SET @EntityList = NULL
	
EXEC stp_R_ExpenseCzarTotalComparisonDetail
	@ReportExpensePeriod = 201011,
	@TranslationTypeName = ''Global'',
	@DestinationCurrency = ''USD'',

	@FunctionalDepartmentList = ''Information Technologies'',
	@AllocationRegionList = ''CHICAGO'',
	@EntityList = ''Aldgate|Centrium (St Cathrine House/Pegasus)''
	
*/
DECLARE

	@_ReportExpensePeriod INT = @ReportExpensePeriod,
	@_ReforecastQuaterName VARCHAR(10) = @ReforecastQuaterName,
	@_PreviousReforecastQuaterName VARCHAR(10) = @PreviousReforecastQuaterName,
	@_DestinationCurrency VARCHAR(3) = @DestinationCurrency,
	@_TranslationTypeName VARCHAR(50) = @TranslationTypeName,
	@_IsGross bit = @IsGross,
	@_FunctionalDepartmentList VARCHAR(8000) = @FunctionalDepartmentList,
	@_ActivityTypeList VARCHAR(8000) = @ActivityTypeList,
	@_EntityList VARCHAR(8000) = @EntityList,
	@_MajorAccountCategoryList VARCHAR(8000) = @MajorAccountCategoryList,
	@_MinorAccountCategoryList VARCHAR(8000) = @MinorAccountCategoryList,
	@_AllocationRegionList VARCHAR(8000) = @AllocationRegionList,
	@_AllocationSubRegionList VARCHAR(8000) = @AllocationSubRegionList,
	@_OriginatingRegionList VARCHAR(8000) = @OriginatingRegionList,
	@_OriginatingSubRegionList VARCHAR(8000) = @OriginatingSubRegionList
--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Variable defaults		*/
--------------------------------------------------------------------------

IF @ReportExpensePeriod IS NULL
	SET @ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + REPLACE(STR(MONTH(GETDATE()),2 ),'' '',''0'')AS INT)

IF @DestinationCurrency IS NULL
	SET @DestinationCurrency = ''USD''

IF 	@TranslationTypeName IS NULL
	SET @TranslationTypeName = ''Global''

	DECLARE @CalendarYear AS INT
	SET @CalendarYear = CAST(SUBSTRING(CAST(@ReportExpensePeriod AS VARCHAR(10)), 1, 4) AS INT)				

-- let latest reforecast (it will be zero if there is no data for the reforecast)
IF @ReforecastQuaterName IS NULL
	SET @ReforecastQuaterName = (SELECT TOP 1 ReforecastQuarterName 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
										  ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
									ORDER BY ReforecastEffectivePeriod DESC)

DECLARE @ReforecastEffectivePeriod INT
SET @ReforecastEffectivePeriod = (SELECT TOP 1 ReforecastEffectivePeriod 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										  ReforecastQuarterName = @ReforecastQuaterName
									ORDER BY ReforecastEffectivePeriod)
									
-- set Q1 reforecast									
IF @PreviousReforecastQuaterName IS NULL
		SET @PreviousReforecastQuaterName = (SELECT TOP 1 ReforecastQuarterName 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
										  ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
									ORDER BY ReforecastEffectivePeriod DESC)
									
DECLARE @PreviousReforecastEffectivePeriod INT																
SET @PreviousReforecastEffectivePeriod = (SELECT TOP 1 ReforecastEffectivePeriod  
									FROM dbo.Reforecast 
									WHERE ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										  ReforecastQuarterName = @PreviousReforecastQuaterName
									ORDER BY ReforecastEffectivePeriod)									

--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Tables		*/
--------------------------------------------------------------------------
	
	CREATE TABLE	#EntityFilterTable	(PropertyFundKey Int NOT NULL)
	CREATE TABLE	#FunctionalDepartmentFilterTable	(FunctionalDepartmentKey Int NOT NULL)
	CREATE TABLE	#ActivityTypeFilterTable(ActivityTypeKey Int NOT NULL)
	CREATE TABLE	#AllocationRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#AllocationSubRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#MajorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#MinorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#OriginatingRegionFilterTable	(OriginatingRegionKey Int NOT NULL)
	CREATE TABLE	#OriginatingSubRegionFilterTable	(OriginatingRegionKey Int NOT NULL)	
		
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable	(PropertyFundKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable(ActivityTypeKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MajorAccountCategoryFilterTable(GlAccountCategoryKey)	
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MinorAccountCategoryFilterTable(GlAccountCategoryKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingRegionFilterTable	(OriginatingRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable	(OriginatingRegionKey)
	
IF (@EntityList IS NOT NULL)
	BEGIN
	Insert Into #EntityFilterTable
	Select pf.PropertyFundKey
	From dbo.Split(@_EntityList) t1
		INNER JOIN PropertyFund pf ON pf.PropertyFundName = t1.item
	
	END
	
IF (@FunctionalDepartmentList IS NOT NULL)
	BEGIN
	Insert Into #FunctionalDepartmentFilterTable
	Select fd.FunctionalDepartmentKey 
	From dbo.Split(@_FunctionalDepartmentList) t1
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentName = t1.item
	END

IF 	(@ActivityTypeList IS NOT NULL)
	BEGIN
    INSERT INTO #ActivityTypeFilterTable
    SELECT at.ActivityTypeKey 
    FROM dbo.Split(@_ActivityTypeList) t1
		INNER JOIN ActivityType at ON at.ActivityTypeName = t1.item
	END
	
IF (@AllocationRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationRegionFilterTable
	Select ar.AllocationRegionKey 
	From dbo.Split(@_AllocationRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.RegionName = t1.item
	END

IF (@AllocationSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationSubRegionFilterTable
	Select ar.AllocationRegionKey
	From dbo.Split(@_AllocationSubRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.SubRegionName = t1.item
	END

IF (@MajorAccountCategoryList IS NOT NULL)
	BEGIN
	Insert Into #MajorAccountCategoryFilterTable
	Select gl.GlAccountCategoryKey 
	From dbo.Split(@_MajorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MajorCategoryName = t1.item
	END
	
IF 	(@MinorAccountCategoryList IS NOT NULL)
	BEGIN
    INSERT INTO #MinorAccountCategoryFilterTable
    SELECT gl.GlAccountCategoryKey 
    FROM dbo.Split(@MinorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MinorCategoryName = t1.item
	END	

IF (@OriginatingRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingRegionFilterTable
	Select orr.OriginatingRegionKey 
	From dbo.Split(@_OriginatingRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.RegionName = t1.item
	END

IF (@OriginatingSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingSubRegionFilterTable
	Select orr.OriginatingRegionKey  
	From dbo.Split(@OriginatingSubRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.SubRegionName = t1.item
	END		
--------------------------------------------------------------------------
/*	COMMON END															*/
--------------------------------------------------------------------------

IF 	OBJECT_ID(''tempdb..#ExpenseCzarTotalComparisonDetail'') IS NOT NULL
    DROP TABLE #ExpenseCzarTotalComparisonDetail

CREATE TABLE #ExpenseCzarTotalComparisonDetail
(
	GlAccountCategoryKey	Int,
    FunctionalDepartmentKey	Int,
    AllocationRegionKey		Int,
    PropertyFundKey			Int,
	SourceName				VarChar(50),
	EntryDate				VARCHAR(10),
	[User]					NVARCHAR(20),
	[Description]			NVARCHAR(60),
	AdditionalDescription	NVARCHAR(4000),
	
	--Month to date	
	MtdGrossActual				MONEY,
	MtdGrossBudget				MONEY,
	MtdGrossReforecast			MONEY,
	MtdNetActual				MONEY,
	MtdNetBudget				MONEY,
	MtdNetReforecast			MONEY,
	
	--Year to date
	YtdGrossActual				MONEY,	
	YtdGrossBudget				MONEY, 
	YtdGrossReforecast			MONEY, 
	YtdNetActual				MONEY, 
	YtdNetBudget				MONEY, 
	YtdNetReforecast			MONEY, 

	--Annual	
	AnnualGrossBudget			MONEY,
	AnnualGrossReforecast		MONEY,
	AnnualGrossReforecastQ1		MONEY,
	AnnualNetBudget				MONEY,
	AnnualNetReforecast			MONEY,
	AnnualNetReforecastQ1		MONEY,

	--Annual estimated
	AnnualEstGrossBudget		MONEY,
	AnnualEstGrossReforecast	MONEY,
	AnnualEstNetBudget			MONEY,
	AnnualEstNetReforecast		MONEY
)

DECLARE @cmdString Varchar(8000)

--Get actual information
SET @cmdString = (Select ''
	
INSERT INTO #ExpenseCzarTotalComparisonDetail
SELECT 
	gac.GlAccountCategoryKey,
    pa.FunctionalDepartmentKey,
    pa.AllocationRegionKey,
    pa.PropertyFundKey,
    s.SourceName,
    CONVERT(varchar(10),ISNULL(pa.EntryDate,''''''''), 101) as EntryDate,
    pa.[User],
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.Description ELSE '''''''' END as Description,
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.AdditionalDescription ELSE '''''''' END as AdditionalDescription,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdGrossActual,
	NULL as MtdGrossBudget,
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdGrossReforecast,
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdNetActual,
	NULL as MtdNetBudget,
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdNetReforecast,
	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdGrossActual,
	NULL as YtdGrossBudget,
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as YtdGrossReforecast,
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdNetActual,
	NULL as YtdNetBudget,
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as YtdNetReforecast,
	
	NULL as AnnualGrossBudget,
	SUM(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualGrossReforecast,
	SUM(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@PreviousReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualGrossReforecastQ1,

	NULL as AnnualNetBudget,
    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecast,
    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@PreviousReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ1,
	
	SUM(
        er.Rate *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pa.LocalActual
        ELSE 
			0
        END
	) as AnnualEstGrossBudget,
	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecast,

    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstNetReforecast
	FROM
		ProfitabilityActual pa

		INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
				WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pa.EUCorporateGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''US Property'' THEN ''pa.USPropertyGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''US Fund'' THEN ''pa.USFundGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''EU Property'' THEN ''pa.EUPropertyGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''US Corporate'' THEN ''pa.USCorporateGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''Development'' THEN ''pa.DevelopmentGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''EU Fund'' THEN ''pa.EUFundGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''Global'' THEN ''pa.GlobalGlAccountCategoryKey'' 
				ELSE ''break:not valid TranslationTypeName'' END + ''
				AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')
				
	    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
	    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
	    INNER JOIN Calendar c ON  c.CalendarKey = pa.CalendarKey
	    INNER JOIN Source s ON s.SourceKey = pa.SourceKey
	    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pa.ReimbursableKey ''
	    
    + CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pa.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pa.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pa.PropertyFundKey'' ELSE '''' END + ''
			
WHERE  1 = 1
    AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select t1.FunctionalDepartmentKey From #FunctionalDepartmentFilterTable t1)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select t1.ActivityTypeKey From #ActivityTypeFilterTable t1)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select t1.PropertyFundKey From #EntityFilterTable t1)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationRegionFilterTable t1)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationSubRegionFilterTable t1)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MajorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MinorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingRegionFilterTable t1)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingSubRegionFilterTable t1)'' END +
''
	Group By
		gac.GlAccountCategoryKey,
	    pa.FunctionalDepartmentKey,
	    pa.AllocationRegionKey,
	    pa.PropertyFundKey,
	    s.SourceName,
		CONVERT(varchar(10),ISNULL(pa.EntryDate,''''''''), 101),
		pa.[User],
		CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.Description ELSE '''''''' END,
		CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.AdditionalDescription ELSE '''''''' END
'')
print @cmdString
EXEC (@cmdString)

-- Get budget information
SET @cmdString = (Select ''	

INSERT INTO #ExpenseCzarTotalComparisonDetail
SELECT 
	gac.GlAccountCategoryKey,
	pb.FunctionalDepartmentKey,
	pb.AllocationRegionKey,
	pb.PropertyFundKey,
	s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    
   NULL as MtdGrossActual,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as MtdGrossBudget,
	NULL as MtdGrossReforecast,
	
	NULL as MtdNetActual,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as MtdNetBudget,
	NULL as MtdNetReforecast,
	
	NULL as YtdGrossActual,	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as YtdGrossBudget, 
	NULL as YtdGrossReforecast, 
	
	NULL as YtdNetActual, 
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as YtdNetBudget, 
	NULL as YtdNetReforecast, 
	
	SUM(er.Rate * pb.LocalBudget) as AnnualGrossBudget,
	NULL as AnnualGrossReforecast,
	NULL as AnnualGrossReforecastQ1,

	SUM(er.Rate * r.MultiplicationFactor * pb.LocalBudget) as AnnualNetBudget,
	NULL as AnnualNetReforecast,
	NULL as AnnualNetReforecastQ1,

	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as AnnualEstGrossBudget,
	NULL as AnnualEstGrossReforecast,

	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
	NULL as AnnualEstNetReforecast
	
	FROM
		ProfitabilityBudget pb
		
		INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
				WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pb.EUCorporateGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''US Property'' THEN ''pb.USPropertyGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''US Fund'' THEN ''pb.USFundGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''EU Property'' THEN ''pb.EUPropertyGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''US Corporate'' THEN ''pb.USCorporateGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''Development'' THEN ''pb.DevelopmentGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''EU Fund'' THEN ''pb.EUFundGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''Global'' THEN ''pb.GlobalGlAccountCategoryKey'' 
				ELSE ''break:not valid TranslationTypeName'' END + ''
				AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')	

	    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey
	    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
	    INNER JOIN Calendar c ON  c.CalendarKey = pb.CalendarKey
	    INNER JOIN Source s ON s.SourceKey = pb.SourceKey
	    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pb.ReimbursableKey ''
	    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pb.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey'' ELSE '''' END + ''
		

WHERE  1 = 1 
    AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
	Group By
		gac.GlAccountCategoryKey,
	    pb.FunctionalDepartmentKey,
	    pb.AllocationRegionKey,
	    pb.PropertyFundKey,
	    s.SourceName
	    '')

print @cmdString
EXEC (@cmdString)

-- Get reforecast information
SET @cmdString = (Select ''	

INSERT INTO #ExpenseCzarTotalComparisonDetail
SELECT 
	gac.GlAccountCategoryKey,
    pr.FunctionalDepartmentKey,
    pr.AllocationRegionKey,
    pr.PropertyFundKey,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecast,
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecast,
	
	NULL as YtdGrossActual,	
	NULL as YtdGrossBudget, 
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecast, 
	
	NULL as YtdNetActual, 
	NULL as YtdNetBudget, 
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecast, 
	
	NULL as AnnualGrossBudget, '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecast,
    NULL as AnnualGrossReforecastQ1,

	NULL as AnnualNetBudget, '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecast,
    NULL as AnnualNetReforecastQ1,

	NULL as AnnualEstGrossBudget,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriod,6,0) + '' IN (201003,201006)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstGrossReforecast,

	NULL as AnnualEstNetBudget,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriod,6,0) + '' IN (201003,201006)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstNetReforecast
	FROM
		ProfitabilityReforecast pr
		
		INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
				WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
				ELSE ''break:not valid TranslationTypeName'' END + ''
				AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')	

	    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
	    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
	    INNER JOIN Calendar c ON  c.CalendarKey = pr.CalendarKey
	    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
	    INNER JOIN Source s ON s.SourceKey = pr.SourceKey
	    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pr.ReimbursableKey ''
	    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + ''
		

WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND ref.ReforecastEffectivePeriod = '' + STR(@ReforecastEffectivePeriod,10,0) + ''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
	Group By
		gac.GlAccountCategoryKey,
	    pr.FunctionalDepartmentKey,
	    pr.AllocationRegionKey,
	    pr.PropertyFundKey,
	    s.SourceName
	    '')

print @cmdString
EXEC (@cmdString)

-- Get reforecastQ1 information
SET @cmdString = (Select ''	

INSERT INTO #ExpenseCzarTotalComparisonDetail
SELECT 
	gac.GlAccountCategoryKey,
    pr.FunctionalDepartmentKey,
    pr.AllocationRegionKey,
    pr.PropertyFundKey,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	NULL as MtdGrossReforecast,
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
    NULL as MtdNetReforecast,
	
	NULL as YtdGrossActual,	
	NULL as YtdGrossBudget, 
	NULL as YtdGrossReforecast, 
	
	NULL as YtdNetActual, 
	NULL as YtdNetBudget, 
    NULL as YtdNetReforecast, 
	
	NULL as AnnualGrossBudget,
	NULL as AnnualGrossReforecast,
    SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ1,

	NULL as AnnualNetBudget, 
	NULL as AnnualNetReforecast,
    SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast) as AnnualNetReforecastQ1,

	NULL as AnnualEstGrossBudget,
	NULL as AnnualEstGrossReforecast,

	NULL as AnnualEstNetBudget,
	NULL as AnnualEstNetReforecast
	FROM
		ProfitabilityReforecast pr
		
		INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
				WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
				ELSE ''break:not valid TranslationTypeName'' END + ''
				AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')	

	    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
	    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
	    INNER JOIN Calendar c ON  c.CalendarKey = pr.CalendarKey
	    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
	    INNER JOIN Source s ON s.SourceKey = pr.SourceKey
	    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pr.ReimbursableKey ''
	    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + ''
		

WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND ref.ReforecastEffectivePeriod = '' + STR(@PreviousReforecastEffectivePeriod,10,0) + ''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
	Group By
		gac.GlAccountCategoryKey,
	    pr.FunctionalDepartmentKey,
	    pr.AllocationRegionKey,
	    pr.PropertyFundKey,
	    s.SourceName
'')

print @cmdString
EXEC (@cmdString)

CREATE CLUSTERED INDEX IX ON #ExpenseCzarTotalComparisonDetail(PropertyFundKey,AllocationRegionKey,FunctionalDepartmentKey,GlAccountCategoryKey)

SELECT 
	gac.AccountSubTypeName AS ExpenseType,
	gac.MajorCategoryName AS MajorExpenseCategoryName,
    gac.MinorCategoryName AS MinorExpenseCategoryName,
    fd.FunctionalDepartmentName AS FunctionalDepartmentName,
    fd.FunctionalDepartmentName AS FunctionalDepartmentFilterName,
    ar.SubRegionName AS AllocationSubRegionName,
    ar.SubRegionName AS AllocationSubRegionFilterName,
    pf.PropertyFundName AS EntityName,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
    res.SourceName AS SourceName,
	--Month to date    
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossActual,0) ELSE ISNULL(MtdNetActual,0) END) AS MtdActual,
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossBudget,0) ELSE ISNULL(MtdNetBudget,0) END) AS MtdOriginalBudget,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast 
		END,0) 
	END) 
	AS MtdReforecast,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast 
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast 
		END, 0) - ISNULL(MtdNetActual, 0) 
	END) 
	AS MtdVariance,
	
	--Year to date
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossActual,0) ELSE ISNULL(YtdNetActual,0) END) AS YtdActual,	
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossBudget,0) ELSE ISNULL(YtdNetBudget,0) END) AS YtdOriginalBudget,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast 
		END,0) 
	END) 
	AS YtdReforecast,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast 
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) 
	AS YtdVariance,
	
	--Annual
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(AnnualGrossBudget,0) ELSE ISNULL(AnnualNetBudget,0) END) AS AnnualOriginalBudget,	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecast 
		END,0) 
	END) 
	AS AnnualReforecast,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @PreviousReforecastQuaterName = ''Q1'' THEN 
			AnnualGrossReforecastQ1 		
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @PreviousReforecastQuaterName = ''Q1'' THEN 
			AnnualNetReforecastQ1	
		END,0) 
	END) 
	AS AnnualReforecastQ1
	
	--Annual Estimated
	--SUM(CASE WHEN (@IsGross = 1) THEN 
	--	ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
	--		AnnualEstGrossBudget 
	--	ELSE 
	--		AnnualEstGrossReforecast 
	--	END,0) 
	--ELSE 
	--	ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
	--		AnnualEstNetBudget 
	--	ELSE 
	--		AnnualEstNetReforecast 
	--	END,0) 
	--END) 
	--AS AnnualEstimatedActual,	
	
	--SUM(CASE WHEN (@IsGross = 1) THEN 
	--	ISNULL(AnnualGrossBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
	--											AnnualEstGrossBudget 
	--										ELSE 
	--											AnnualEstGrossReforecast 
	--										END,0) 
	--	ELSE 
	--		ISNULL(AnnualNetBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
	--										AnnualEstNetBudget 
	--									ELSE 
	--										AnnualEstNetReforecast 
	--									END,0) 
	--	END) 
	--AS AnnualEstimatedVariance
INTO
	#Output	
FROM
	#ExpenseCzarTotalComparisonDetail res
			INNER JOIN PropertyFund pf ON pf.PropertyFundKey = res.PropertyFundKey
			INNER JOIN AllocationRegion ar ON ar.AllocationRegionKey = res.AllocationRegionKey
			INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentKey = res.FunctionalDepartmentKey
			INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = res.GlAccountCategoryKey 
GROUP BY
	gac.AccountSubTypeName,
	gac.MajorCategoryName,
    gac.MinorCategoryName,
    fd.FunctionalDepartmentName,
    ar.SubRegionName,
    pf.PropertyFundName,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
    res.SourceName
	
--Output
SELECT
	ExpenseType,
	MajorExpenseCategoryName,
    MinorExpenseCategoryName,
    FunctionalDepartmentName,
    FunctionalDepartmentFilterName,
    AllocationSubRegionName,
    AllocationSubRegionFilterName,
    EntityName,
    EntryDate,
    [User],
    [Description],
    AdditionalDescription,
    SourceName,
	--Month to date    
	MtdActual,
	MtdOriginalBudget,
	MtdReforecast,
	MtdVariance,
	
	--Year to date
	YtdActual,	
	YtdOriginalBudget,
	YtdReforecast,
	YtdVariance,
	
	--Annual
	AnnualOriginalBudget,	
	AnnualReforecast,
	AnnualReforecastQ1
	
	--Annual Estimated
	--AnnualEstimatedActual,	
	--AnnualEstimatedVariance
FROM
	#Output
WHERE
	--Month to date    
	MtdActual <> 0.00 OR
	MtdOriginalBudget <> 0.00 OR
	MtdReforecast <> 0.00 OR
	MtdVariance <> 0.00 OR
	
	--Year to date
	YtdActual <> 0.00 OR
	YtdOriginalBudget <> 0.00 OR
	YtdReforecast <> 0.00 OR
	YtdVariance <> 0.00 OR
	
	--Annual
	AnnualOriginalBudget <> 0.00 OR
	AnnualReforecast <> 0.00 OR
	AnnualReforecastQ1 <> 0.00 --OR
	
	--Annual Estimated
	--AnnualEstimatedActual <> 0.00 OR
	--AnnualEstimatedVariance <> 0.00


IF 	OBJECT_ID(''tempdb..#ExpenseCzarTotalComparisonDetail'') IS NOT NULL
    DROP TABLE #ExpenseCzarTotalComparisonDetail

IF 	OBJECT_ID(''tempdb..#Output'') IS NOT NULL
    DROP TABLE #Output

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzarTotalComparison]    Script Date: 08/05/2010 15:11:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzarTotalComparison]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_R_ExpenseCzarTotalComparison]
	@ReportExpensePeriod INT = NULL,
	@ReforecastQuaterName VARCHAR(10) = NULL, --''Q1'' or ''Q2'' or ''Q3''
	@PreviousReforecastQuaterName VARCHAR(10) = ''Q1'', -- or ''Q2'' or ''Q3''
	@DestinationCurrency VARCHAR(3) = NULL,
	@TranslationTypeName VARCHAR(50) = ''Global'',
	@IsGross bit = 1,-- Dummy code required by common parameter code in DL
	@FunctionalDepartmentList TEXT = NULL,
	@ActivityTypeList TEXT = NULL,
	@EntityList TEXT = NULL,
	@MajorAccountCategoryList TEXT = NULL,
	@MinorAccountCategoryList TEXT = NULL,
	@AllocationRegionList TEXT = NULL,
	@AllocationSubRegionList TEXT = NULL,
	@OriginatingRegionList TEXT = NULL,
	@OriginatingSubRegionList TEXT = NULL
AS
 
DECLARE

	@_ReportExpensePeriod INT = @ReportExpensePeriod,
	@_DestinationCurrency VARCHAR(3) = @DestinationCurrency,
	@_TranslationTypeName VARCHAR(50) = @TranslationTypeName,
	@_IsGross bit = @IsGross,
	@_FunctionalDepartmentList VARCHAR(8000) = @FunctionalDepartmentList,
	@_ActivityTypeList VARCHAR(8000) = @ActivityTypeList,
	@_EntityList VARCHAR(8000) = @EntityList,
	@_MajorAccountCategoryList VARCHAR(8000) = @MajorAccountCategoryList,
	@_MinorAccountCategoryList VARCHAR(8000) = @MinorAccountCategoryList,
	@_AllocationRegionList VARCHAR(8000) = @AllocationRegionList,
	@_AllocationSubRegionList VARCHAR(8000) = @AllocationSubRegionList,
	@_OriginatingRegionList VARCHAR(8000) = @OriginatingRegionList,
	@_OriginatingSubRegionList VARCHAR(8000) = @OriginatingSubRegionList
	
-- TODO: Remove test
/*
DECLARE @ReportExpensePeriod   INT,
        @DestinationCurrency   VARCHAR(3),
        @MajorGlAccountCategoryList VARCHAR(8000),
        @TranslationTypeName         VARCHAR(50)

SET @ReportExpensePeriod = 201002
SET @DestinationCurrency = ''USD''
SET @MajorGlAccountCategoryList = ''Salaries/Taxes/Benefits,Occupancy Costs''
SET @TranslationTypeName = ''Global''
*/ 
/*
EXEC stp_R_ExpenseCzarTotalComparison
	@ReportExpensePeriod = 201011,
	@TranslationTypeName = ''Global'',
	@DestinationCurrency = ''USD'',

	@FunctionalDepartmentList = ''Information Technologies'',
	@AllocationRegionList = ''CHICAGO'',
	@EntityList = ''Aldgate|Centrium (St Cathrine House/Pegasus)''
*/

--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Variable defaults		*/
--------------------------------------------------------------------------

IF @ReportExpensePeriod IS NULL
	SET @ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + REPLACE(STR(MONTH(GETDATE()),2 ),'' '',''0'')AS INT)

IF @DestinationCurrency IS NULL
	SET @DestinationCurrency = ''USD''

IF 	@TranslationTypeName IS NULL
	SET @TranslationTypeName = ''Global''

	DECLARE @CalendarYear AS INT
	SET @CalendarYear = CAST(SUBSTRING(CAST(@ReportExpensePeriod AS VARCHAR(10)), 1, 4) AS INT)				

-- let latest reforecast (it will be zero if there is no data for the reforecast)
IF @ReforecastQuaterName IS NULL
	SET @ReforecastQuaterName = (SELECT TOP 1 ReforecastQuarterName 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
										  ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
									ORDER BY ReforecastEffectivePeriod DESC)

DECLARE @ReforecastEffectivePeriod INT
SET @ReforecastEffectivePeriod = (SELECT TOP 1 ReforecastEffectivePeriod 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										  ReforecastQuarterName = @ReforecastQuaterName
									ORDER BY ReforecastEffectivePeriod)
									

-- set Q1 reforecast									
IF @PreviousReforecastQuaterName IS NULL
		SET @PreviousReforecastQuaterName = (SELECT TOP 1 ReforecastQuarterName 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
										  ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
									ORDER BY ReforecastEffectivePeriod DESC)
									
DECLARE @PreviousReforecastEffectivePeriod INT																
SET @PreviousReforecastEffectivePeriod = (SELECT TOP 1 ReforecastEffectivePeriod  
									FROM dbo.Reforecast 
									WHERE ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										  ReforecastQuarterName = @PreviousReforecastQuaterName
									ORDER BY ReforecastEffectivePeriod)
									
--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Tables		*/
--------------------------------------------------------------------------
	
	CREATE TABLE	#EntityFilterTable	(PropertyFundKey Int NOT NULL)
	CREATE TABLE	#FunctionalDepartmentFilterTable	(FunctionalDepartmentKey Int NOT NULL)
	CREATE TABLE	#ActivityTypeFilterTable(ActivityTypeKey Int NOT NULL)
	CREATE TABLE	#AllocationRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#AllocationSubRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#MajorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#MinorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#OriginatingRegionFilterTable	(OriginatingRegionKey Int NOT NULL)
	CREATE TABLE	#OriginatingSubRegionFilterTable	(OriginatingRegionKey Int NOT NULL)	
		
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable	(PropertyFundKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable(ActivityTypeKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MajorAccountCategoryFilterTable(GlAccountCategoryKey)	
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MinorAccountCategoryFilterTable(GlAccountCategoryKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingRegionFilterTable	(OriginatingRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable	(OriginatingRegionKey)
	
IF (@EntityList IS NOT NULL)
	BEGIN
	Insert Into #EntityFilterTable
	Select pf.PropertyFundKey
	From dbo.Split(@_EntityList) t1
		INNER JOIN PropertyFund pf ON pf.PropertyFundName = t1.item
	
	END
	
IF (@FunctionalDepartmentList IS NOT NULL)
	BEGIN
	Insert Into #FunctionalDepartmentFilterTable
	Select fd.FunctionalDepartmentKey 
	From dbo.Split(@_FunctionalDepartmentList) t1
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentName = t1.item
	END

IF 	(@ActivityTypeList IS NOT NULL)
	BEGIN
    INSERT INTO #ActivityTypeFilterTable
    SELECT at.ActivityTypeKey 
    FROM dbo.Split(@_ActivityTypeList) t1
		INNER JOIN ActivityType at ON at.ActivityTypeName = t1.item
	END
	
IF (@AllocationRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationRegionFilterTable
	Select ar.AllocationRegionKey 
	From dbo.Split(@_AllocationRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.RegionName = t1.item
	END

IF (@AllocationSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationSubRegionFilterTable
	Select ar.AllocationRegionKey
	From dbo.Split(@_AllocationSubRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.SubRegionName = t1.item
	END

IF (@MajorAccountCategoryList IS NOT NULL)
	BEGIN
	Insert Into #MajorAccountCategoryFilterTable
	Select gl.GlAccountCategoryKey 
	From dbo.Split(@_MajorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MajorCategoryName = t1.item
	END
	
IF 	(@MinorAccountCategoryList IS NOT NULL)
	BEGIN
    INSERT INTO #MinorAccountCategoryFilterTable
    SELECT gl.GlAccountCategoryKey 
    FROM dbo.Split(@MinorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MinorCategoryName = t1.item
	END	

IF (@OriginatingRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingRegionFilterTable
	Select orr.OriginatingRegionKey 
	From dbo.Split(@_OriginatingRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.RegionName = t1.item
	END

IF (@OriginatingSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingSubRegionFilterTable
	Select orr.OriginatingRegionKey  
	From dbo.Split(@OriginatingSubRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.SubRegionName = t1.item
	END		
--------------------------------------------------------------------------
/*	COMMON END															*/
--------------------------------------------------------------------------
	
 
 -- Combine budget and actual values
IF OBJECT_ID(''tempdb..#TotalComparison'') IS NOT NULL
    DROP TABLE #TotalComparison

CREATE TABLE #TotalComparison
(
	AccountSubTypeName              VARCHAR(50),
	TranslationTypeName            VARCHAR(50),
	MajorCategoryName                VARCHAR(100),
	MinorCategoryName                VARCHAR(100),
	CalendarPeriod           INT,
	SourceName				 VarChar(50),
	EntryDate				 VARCHAR(10),
	[User]					 NVARCHAR(20),
	[Description]			 NVARCHAR(60),
	AdditionalDescription	 NVARCHAR(4000),
	
	--Month to date
	MtdGrossActual           MONEY,
	MtdGrossBudget           MONEY,
	MtdGrossReforecast       MONEY,
	MtdNetActual			 MONEY,
	MtdNetBudget			 MONEY,
	MtdNetReforecast		 MONEY,
	
	--Year to date
	YtdGrossActual           MONEY,
	YtdGrossBudget           MONEY,
	YtdGrossReforecast       MONEY,
	YtdNetActual			 MONEY,
	YtdNetBudget			 MONEY,
	YtdNetReforecast		 MONEY,

	--Annual
	AnnualGrossBudget		 MONEY,
	AnnualGrossReforecast	 MONEY,
	AnnualGrossReforecastQ1	 MONEY,
	AnnualNetBudget			 MONEY,	
	AnnualNetReforecast		 MONEY,
	AnnualNetReforecastQ1	 MONEY,

	--Annual estimated
	AnnualEstGrossBudget     MONEY,
	AnnualEstGrossReforecast MONEY,
	AnnualEstNetBudget		 MONEY,
	AnnualEstNetReforecast	 MONEY
)

DECLARE @cmdString Varchar(8000)

--Get actual information
SET @cmdString = (Select ''
INSERT INTO #TotalComparison
SELECT 
	gac.AccountSubTypeName,
    gac.TranslationTypeName,
    gac.MajorCategoryName,
    gac.MinorCategoryName,
    c.CalendarPeriod,
    s.SourceName,
    CONVERT(varchar(10),ISNULL(pa.EntryDate,''''''''), 101) as EntryDate,
    pa.[User],
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.Description ELSE '''''''' END as Description,
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.AdditionalDescription ELSE '''''''' END as AdditionalDescription,
    (
		er.Rate *
		CASE WHEN (c.CalendarPeriod = ''+STR(@ReportExpensePeriod,10,0)+'') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdGrossActual,
	NULL as MtdGrossBudget,
	(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdGrossReforecast,	
    (
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod = ''+STR(@ReportExpensePeriod,10,0)+'') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as MtdNetActual,
	NULL as MtdNetBudget,
	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod = ''+STR(@ReportExpensePeriod,10,0)+''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdNetReforecast,
    (
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+'') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdGrossActual,    
    NULL as YtdGrossBudget,
	(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as YtdGrossReforecast,    
	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+'') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as YtdNetActual,
	NULL as YtdNetBudget,
   
	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as YtdNetReforecast,
    NULL as AnnualGrossBudget,
	(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualGrossReforecast,
	(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+''
			  AND c.CalendarPeriod < '' + STR(@PreviousReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualGrossReforecastQ1,
	NULL as AnnualNetBudget,
	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecast,
    (
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+''
			  AND c.CalendarPeriod < '' + STR(@PreviousReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ1,
	(
        er.Rate *
        CASE WHEN (c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0) + '') THEN 
			pa.LocalActual
        ELSE 
			0
        END
	) as AnnualEstGrossBudget,
    (
        er.Rate *
        CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecast,	
	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0) + '') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,	
	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstNetReforecast
FROM
	ProfitabilityActual pa

	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pa.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pa.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pa.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pa.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pa.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pa.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pa.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pa.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid TranslationTypeName'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')
			
    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pa.CalendarKey
    INNER JOIN Source s ON s.SourceKey = pa.SourceKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pa.ReimbursableKey ''
		
    + CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pa.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pa.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pa.PropertyFundKey'' ELSE '''' END + ''
		
WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select t1.FunctionalDepartmentKey From #FunctionalDepartmentFilterTable t1)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select t1.ActivityTypeKey From #ActivityTypeFilterTable t1)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select t1.PropertyFundKey From #EntityFilterTable t1)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationRegionFilterTable t1)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationSubRegionFilterTable t1)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MajorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MinorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingRegionFilterTable t1)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingSubRegionFilterTable t1)'' END +
''    
'')
print @cmdString
EXEC (@cmdString)

--Get budget information
SET @cmdString = (Select ''
INSERT INTO #TotalComparison
SELECT 
	gac.AccountSubTypeName,
    gac.TranslationTypeName,
    gac.MajorCategoryName,
    gac.MinorCategoryName,
    c.CalendarPeriod,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    NULL as MtdGrossActual,    
    (
		er.Rate *
		CASE WHEN (c.CalendarPeriod = ''+STR(@ReportExpensePeriod,10,0)+'') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as MtdGrossBudget,
	NULL as MtdGrossReforecast,
    NULL as MtdNetActual,
	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod = ''+STR(@ReportExpensePeriod,10,0)+'') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as MtdNetBudget,
	NULL as MtdNetReforecast,
    NULL as YtdGrossActual,	
	(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+'') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as YtdGrossBudget,
	NULL as YtdGrossReforecast,
	NULL as YtdNetActual,	
	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+'') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as YtdNetBudget,
	NULL as YtdNetReforecast,
	(
		er.Rate * pb.LocalBudget
	) as AnnualGrossBudget,
	NULL as AnnualGrossReforecast,
	NULL as AnnualGrossReforecastQ1,
	(
		er.Rate * r.MultiplicationFactor * pb.LocalBudget
    ) as AnnualNetBudget,
	NULL as AnnualNetReforecast,
	NULL as AnnualNetReforecastQ1,
	(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > ''+STR(@ReportExpensePeriod,10,0)+'') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as AnnualEstGrossBudget,
	NULL as AnnualEstGrossReforecast,
    (
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > ''+STR(@ReportExpensePeriod,10,0)+'') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as AnnualEstNetBudget, 
	NULL as AnnualEstNetReforecast
    
FROM
	ProfitabilityBudget pb

	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pb.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pb.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pb.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pb.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pb.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pb.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pb.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pb.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid TranslationTypeName'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')
	
    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON c.CalendarKey = pb.CalendarKey
    INNER JOIN Source s ON s.SourceKey = pb.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pb.ReimbursableKey	''
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pb.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey'' ELSE '''' END + ''

WHERE  1 = 1  
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''

'')

print @cmdString
EXEC (@cmdString)

--Get reforecast information
SET @cmdString = (Select ''
INSERT INTO #TotalComparison
SELECT 
	gac.AccountSubTypeName,
    gac.TranslationTypeName,
    gac.MajorCategoryName,
    gac.MinorCategoryName,
    c.CalendarPeriod,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    NULL as MtdGrossActual,
    NULL as MtdGrossBudget,
    (
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = ''+STR(@ReportExpensePeriod,10,0)+'') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecast,
    NULL as MtdNetActual,
	NULL as MtdNetBudget,
	(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = ''+STR(@ReportExpensePeriod,10,0)+'') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecast,
    NULL as YtdGrossActual,    
    NULL as YtdGrossBudget,
	(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+'') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecast,
	NULL as YtdNetActual,
	NULL as YtdNetBudget,
	(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+'') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecast,
   	NULL as AnnualGrossBudget,'' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''(er.Rate * pr.LocalReforecast) as AnnualGrossReforecast,
     NULL as AnnualGrossReforecastQ1,
	NULL as AnnualNetBudget,'' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''(er.Rate * r.MultiplicationFactor * pr.LocalReforecast) as AnnualNetReforecast,
    NULL as AnnualNetReforecastQ1,
    NULL as AnnualEstGrossBudget,
	(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' +STR(@ReportExpensePeriod,10,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriod,6,0) + '' IN (201003,201006)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstGrossReforecast,
	NULL as AnnualEstNetBudget,
	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' +STR(@ReportExpensePeriod,10,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriod,6,0) + '' IN (201003,201006)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstNetReforecast
FROM
	ProfitabilityReforecast pr

	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid TranslationTypeName'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')
	
    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON c.CalendarKey = pr.CalendarKey
    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
    INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey	''
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + ''

WHERE  1 = 1  
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND ref.ReforecastEffectivePeriod = '' + STR(@ReforecastEffectivePeriod,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''

'')

print @cmdString
EXEC (@cmdString)

--Get reforecast information
SET @cmdString = (Select ''
INSERT INTO #TotalComparison
SELECT 
	gac.AccountSubTypeName,
    gac.TranslationTypeName,
    gac.MajorCategoryName,
    gac.MinorCategoryName,
    c.CalendarPeriod,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    NULL as MtdGrossActual,
    NULL as MtdGrossBudget,
    NULL as MtdGrossReforecast,
    
    NULL as MtdNetActual,
	NULL as MtdNetBudget,
	NULL as MtdNetReforecast,
	
    NULL as YtdGrossActual,    
    NULL as YtdGrossBudget,
	NULL as YtdGrossReforecast,
	
	NULL as YtdNetActual,
	NULL as YtdNetBudget,
	NULL as YtdNetReforecast,
	
   	NULL as AnnualGrossBudget,
   	NULL as AnnualGrossReforecast,
   	(er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ1,
   	
	NULL as AnnualNetBudget,
	NULL as AnnualNetReforecast,
	(er.Rate * r.MultiplicationFactor * pr.LocalReforecast) as AnnualNetReforecastQ1,
	
    NULL as AnnualEstGrossBudget,
	NULL as AnnualEstGrossReforecast,
	NULL as AnnualEstNetBudget,
	NULL as AnnualEstNetReforecast
FROM
	ProfitabilityReforecast pr

	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid TranslationTypeName'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')
	
    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON c.CalendarKey = pr.CalendarKey
    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
    INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey	''
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + ''

WHERE  1 = 1  
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND ref.ReforecastEffectivePeriod = '' + STR(@PreviousReforecastEffectivePeriod,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''

'')

print @cmdString
EXEC (@cmdString)

-- Return results
SELECT
	AccountSubTypeName AS ExpenseType,
	TranslationTypeName AS AccountCategoryMappingName,
    MajorCategoryName AS MajorAccountCategoryName,
	MajorCategoryName AS MajorAccountCategoryFilterName,
    MinorCategoryName AS MinorAccountCategoryName,
    CalendarPeriod AS ExpensePeriod,
    EntryDate,
    [User],
    [Description],
    AdditionalDescription,
	SourceName AS SourceName,
	--Month to date
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossActual,0) ELSE ISNULL(MtdNetActual,0) END) AS MtdActual,
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossBudget,0) ELSE ISNULL(MtdNetBudget,0) END) AS MtdOriginalBudget,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast 
		END,0) 
	END) 
	AS MtdReforecast,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast 
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast 
		END, 0) - ISNULL(MtdNetActual, 0) 
	END) 
	AS MtdVariance,
	
	-- Year to date
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossActual,0) ELSE ISNULL(YtdNetActual,0) END) AS YtdActual,	
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossBudget,0) ELSE ISNULL(YtdNetBudget,0) END) AS YtdOriginalBudget,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast 
		END,0) 
	END) 
	AS YtdReforecast,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast 
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) 
	AS YtdVariance,
	
	--Annual
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(AnnualGrossBudget,0) ELSE ISNULL(AnnualNetBudget,0) END) AS AnnualOriginalBudget,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecast 
		END,0) 
	END) 
	AS AnnualReforecast,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @PreviousReforecastQuaterName = ''Q1'' THEN 
			AnnualGrossReforecastQ1 		
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @PreviousReforecastQuaterName = ''Q1'' THEN 
			AnnualNetReforecastQ1	
		END,0) 
	END) 
	AS AnnualReforecastQ1,
	
	--Annual Estimated
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualEstGrossBudget 
		ELSE 
			AnnualEstGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualEstNetBudget 
		ELSE 
			AnnualEstNetReforecast 
		END,0) 
	END) 
	AS AnnualEstimatedActual,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(AnnualGrossBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
												AnnualEstGrossBudget 
											ELSE 
												AnnualEstGrossReforecast 
											END,0) 
		ELSE 
			ISNULL(AnnualNetBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
											AnnualEstNetBudget 
										ELSE 
											AnnualEstNetReforecast 
										END,0) 
		END) 
	AS AnnualEstimatedVariance
INTO
	#Output
FROM
	#TotalComparison
GROUP BY
	AccountSubTypeName,
	TranslationTypeName,
    MajorCategoryName,
    MinorCategoryName,
    CalendarPeriod,
    EntryDate,
    [User],
    [Description],
    AdditionalDescription,
    SourceName

--Output
SELECT
	ExpenseType,
	AccountCategoryMappingName,
    MajorAccountCategoryName,
	MajorAccountCategoryFilterName,
    MinorAccountCategoryName,
    ExpensePeriod,
    EntryDate,
    [User],
    [Description],
    AdditionalDescription,
	SourceName,
	
	--Month to date
	MtdActual,
	MtdOriginalBudget,
	MtdReforecast,
	MtdVariance,
	
	-- Year to date
	YtdActual,	
	YtdOriginalBudget,
	YtdReforecast,
	YtdVariance,
	
	--Annual
	AnnualOriginalBudget,
	AnnualReforecast,
	AnnualReforecastQ1,
	
	--Annual Estimated
	AnnualEstimatedActual,
	AnnualEstimatedVariance
FROM
	#Output
WHERE
	--Month to date
	MtdActual <> 0.00 OR
	MtdOriginalBudget <> 0.00 OR
	MtdReforecast <> 0.00 OR
	MtdVariance <> 0.00 OR
	
	-- Year to date
	YtdActual <> 0.00 OR
	YtdOriginalBudget <> 0.00 OR
	YtdReforecast <> 0.00 OR
	YtdVariance <> 0.00 OR
	
	--Annual
	AnnualOriginalBudget <> 0.00 OR
	AnnualReforecast <> 0.00 OR
	AnnualReforecastQ1 <> 0.00 OR
	
	--Annual Estimated
	AnnualEstimatedActual <> 0.00 OR
	AnnualEstimatedVariance <> 0.00


IF 	OBJECT_ID(''tempdb..#Output'') IS NOT NULL
    DROP TABLE #Output


' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzarDetail]    Script Date: 08/05/2010 15:11:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzarDetail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[stp_R_ExpenseCzarDetail]
	@ReportExpensePeriod INT = NULL,
	@DestinationCurrency VARCHAR(3) = NULL,
	@HierarchyName VARCHAR(50) = NULL,
	@IsGross bit = 1,
	@FunctionalDepartmentList TEXT = NULL,
	@ActivityTypeList TEXT = NULL,
	@EntityList TEXT = NULL,
	@MajorAccountCategoryList TEXT = NULL,
	@MinorAccountCategoryList TEXT = NULL,
	@AllocationRegionList TEXT = NULL,
	@AllocationSubRegionList TEXT = NULL,
	@OriginatingRegionList TEXT = NULL,
	@OriginatingSubRegionList TEXT = NULL

AS
/*
	DECLARE @ReportExpensePeriod   INT,
	@AccountCategoryList   VARCHAR(8000),
	@DestinationCurrency   VARCHAR(3),
	@HierarchyName         VARCHAR(50),
	@FunctionalDepartmentList VARCHAR(8000),
	@AllocationRegionList VARCHAR(8000),
	@EntityList VARCHAR(8000)
	
	
	SET @ReportExpensePeriod = 201011
	SET @AccountCategoryList = ''IT Costs & Telecommunications''
	SET @DestinationCurrency =''USD''
	SET @HierarchyName = ''Global''
	SET @FunctionalDepartmentList = ''Information Technologies''
	SET @AllocationRegionList = NULL
	SET @EntityList = NULL
	
EXEC stp_R_ExpenseCzarDetail
		@ReportExpensePeriod = 201011,
		@AccountCategoryList = ''IT Costs & Telecommunications|Legal & Professional Fees|Marketing'',
		@DestinationCurrency = ''USD'',
		@HierarchyName = ''Global'',
		@FunctionalDepartmentList = ''Information Technology'',
		@AllocationRegionList = null,
		@EntityList = NULL,
		@MinorAccountCategoryList = ''Architects & Engineering|Legal - Immigration'',
		@ActivityTypeList = ''Corporate Overhead|Corporate''
	
*/
DECLARE

	@_ReportExpensePeriod INT = @ReportExpensePeriod,
	@_DestinationCurrency VARCHAR(3) = @DestinationCurrency,
	@_HierarchyName VARCHAR(50) = @HierarchyName,
	@_IsGross bit = @IsGross,
	@_FunctionalDepartmentList VARCHAR(8000) = @FunctionalDepartmentList,
	@_ActivityTypeList VARCHAR(8000) = @ActivityTypeList,
	@_EntityList VARCHAR(8000) = @EntityList,
	@_MajorAccountCategoryList VARCHAR(8000) = @MajorAccountCategoryList,
	@_MinorAccountCategoryList VARCHAR(8000) = @MinorAccountCategoryList,
	@_AllocationRegionList VARCHAR(8000) = @AllocationRegionList,
	@_AllocationSubRegionList VARCHAR(8000) = @AllocationSubRegionList,
	@_OriginatingRegionList VARCHAR(8000) = @OriginatingRegionList,
	@_OriginatingSubRegionList VARCHAR(8000) = @OriginatingSubRegionList
--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Variable defaults		*/
--------------------------------------------------------------------------

IF @ReportExpensePeriod IS NULL
	SET @ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + REPLACE(STR(MONTH(GETDATE()),2 ),'' '',''0'')AS INT)

IF @DestinationCurrency IS NULL
	SET @DestinationCurrency = ''USD''

IF 	@HierarchyName IS NULL
	SET @HierarchyName = ''Global''

	DECLARE @CalendarYear AS INT
	SET @CalendarYear = CAST(SUBSTRING(CAST(@ReportExpensePeriod AS VARCHAR(10)), 1, 4) AS INT)				

--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Tables		*/
--------------------------------------------------------------------------
	
	CREATE TABLE	#EntityFilterTable	(PropertyFundKey Int NOT NULL)
	CREATE TABLE	#FunctionalDepartmentFilterTable	(FunctionalDepartmentKey Int NOT NULL)
	CREATE TABLE	#ActivityTypeFilterTable(ActivityTypeKey Int NOT NULL)
	CREATE TABLE	#AllocationRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#AllocationSubRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#MajorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#MinorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#OriginatingRegionFilterTable	(OriginatingRegionKey Int NOT NULL)
	CREATE TABLE	#OriginatingSubRegionFilterTable	(OriginatingRegionKey Int NOT NULL)	
		
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable	(PropertyFundKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable(ActivityTypeKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MajorAccountCategoryFilterTable(GlAccountCategoryKey)	
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MinorAccountCategoryFilterTable(GlAccountCategoryKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingRegionFilterTable	(OriginatingRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable	(OriginatingRegionKey)
	
IF (@EntityList IS NOT NULL)
	BEGIN
	Insert Into #EntityFilterTable
	Select pf.PropertyFundKey
	From dbo.Split(@_EntityList) t1
		INNER JOIN PropertyFund pf ON pf.PropertyFundName = t1.item
	
	END
	
IF (@FunctionalDepartmentList IS NOT NULL)
	BEGIN
	Insert Into #FunctionalDepartmentFilterTable
	Select fd.FunctionalDepartmentKey 
	From dbo.Split(@_FunctionalDepartmentList) t1
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentName = t1.item
	END

IF 	(@ActivityTypeList IS NOT NULL)
	BEGIN
    INSERT INTO #ActivityTypeFilterTable
    SELECT at.ActivityTypeKey 
    FROM dbo.Split(@_ActivityTypeList) t1
		INNER JOIN ActivityType at ON at.ActivityTypeName = t1.item
	END
	
IF (@AllocationRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationRegionFilterTable
	Select ar.AllocationRegionKey 
	From dbo.Split(@_AllocationRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.RegionName = t1.item
	END

IF (@AllocationSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationSubRegionFilterTable
	Select ar.AllocationRegionKey
	From dbo.Split(@_AllocationSubRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.SubRegionName = t1.item
	END

IF (@MajorAccountCategoryList IS NOT NULL)
	BEGIN
	Insert Into #MajorAccountCategoryFilterTable
	Select gl.GlAccountCategoryKey 
	From dbo.Split(@_MajorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MajorName = t1.item
	END
	
IF 	(@MinorAccountCategoryList IS NOT NULL)
	BEGIN
    INSERT INTO #MinorAccountCategoryFilterTable
    SELECT gl.GlAccountCategoryKey 
    FROM dbo.Split(@MinorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MinorName = t1.item
	END	

IF (@OriginatingRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingRegionFilterTable
	Select orr.OriginatingRegionKey 
	From dbo.Split(@_OriginatingRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.RegionName = t1.item
	END

IF (@OriginatingSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingSubRegionFilterTable
	Select orr.OriginatingRegionKey  
	From dbo.Split(@OriginatingSubRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.SubRegionName = t1.item
	END		
--------------------------------------------------------------------------
/*	COMMON END															*/
--------------------------------------------------------------------------

IF 	OBJECT_ID(''tempdb..#ExpenseCzarTotalComparisonDetail'') IS NOT NULL
    DROP TABLE #ExpenseCzarTotalComparisonDetail

CREATE TABLE #ExpenseCzarTotalComparisonDetail
(
	GlAccountCategoryKey	Int,
    FunctionalDepartmentKey	Int,
    AllocationRegionKey		Int,
    PropertyFundKey			Int,
	SourceName				VarChar(50),
	MtdGrossBudget           MONEY,
	MtdGrossActual           MONEY,
	MtdNetBudget			 MONEY,
	MtdNetActual			 MONEY,
	YtdGrossBudget           MONEY,
	YtdGrossActual           MONEY,
	YtdNetBudget			 MONEY,
	YtdNetActual			 MONEY,
	AnualGrossBudget		 MONEY,
	AnualEstGrossActual      MONEY,
	AnualNetBudget			 MONEY,
	AnualEstNetActual		 MONEY
)

CREATE TABLE #Gac (GlAccountCategoryKey Int NOT NULL)

DECLARE @cmdString Varchar(8000)


SET @cmdString = (Select ''
	Select GlAccountCategoryKey
	From GlAccountCategory gac
	Where 1 = 1
	AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')
	AND gac.HierarchyName = '''''' + @HierarchyName + ''''''
	'')

print @cmdString
Insert Into #Gac
EXEC (@cmdString)

SET @cmdString = (Select ''
	
	INSERT INTO #ExpenseCzarTotalComparisonDetail
	SELECT 
		pagacb.GlAccountCategoryKey,
	    pa.FunctionalDepartmentKey,
	    pa.AllocationRegionKey,
	    pa.PropertyFundKey,
	    s.SourceName,
		NULL as MtdGrossBudget,
		SUM(
			(
				er.Rate *
				CASE WHEN (c.CalendarPeriod = ''+STR(@ReportExpensePeriod,10,0)+'') THEN
					pa.LocalActual
				ELSE
					0
				END
			)
		) as MtdGrossActual,
		NULL as MtdNetBudget,
		SUM(
			(
				er.Rate *
				CASE WHEN (r.ReimbursableCode = ''''NO'''' AND c.CalendarPeriod = ''+STR(@ReportExpensePeriod,10,0)+'') THEN 
					pa.LocalActual
				ELSE 
					0
				END
			)
		) as MtdNetActual,
		NULL as YtdGrossBudget,
		SUM(
			(
				er.Rate *
				CASE WHEN (c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+'') THEN
					pa.LocalActual
				ELSE
					0
				END
			)
			
		) as YtdGrossActual,
		NULL as YtdNetBudget,
		SUM(
			(
				er.Rate *
				CASE WHEN (r.ReimbursableCode = ''''NO'''' AND c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+'') THEN 
					pa.LocalActual
				ELSE 
					0
				END
			)
		) as YtdNetActual,
		NULL as AnualGrossBudget,
		SUM(
				er.Rate *
				CASE WHEN (c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+'') THEN 
					pa.LocalActual
				ELSE 
					0
				END
		) as AnualEstGrossActual,
		NULL as AnualNetBudget,
		SUM(
			(
				er.Rate *
				CASE WHEN (r.ReimbursableCode = ''''NO'''' AND c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+'') THEN 
					pa.LocalActual
				ELSE 
					0
				END
			)
		) as AnualEstNetActual
	FROM
		ProfitabilityActual pa
		INNER JOIN (
				Select pagacb.* From dbo.ProfitabilityActualGlAccountCategoryBridge pagacb
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pagacb.GlAccountCategoryKey
				UNION ALL
				Select pagacb.* From dbo.ProfitabilityActualGlAccountCategoryBridgeVirtual(''+STR(@CalendarYear,10,0)+'',''+STR(@ReportExpensePeriod,10,0)+'',''''''+ @HierarchyName + '''''') pagacb
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pagacb.GlAccountCategoryKey
				) pagacb ON  
		pa.ProfitabilityActualKey = pagacb.ProfitabilityActualKey'' +	

    + CASE WHEN @MajorAccountCategoryList IS NOT NULL OR @MinorAccountCategoryList IS NOT NULL THEN '' INNER JOIN GlAccountCategory gac ON  gac.GlAccountCategoryKey = pagacb.GlAccountCategoryKey '' ELSE '''' END +
    + CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pa.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pa.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pa.PropertyFundKey'' ELSE '''' END + ''

	    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
	    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
	    INNER JOIN Calendar c ON  c.CalendarKey = pa.CalendarKey
	    INNER JOIN Source s ON s.SourceKey = pa.SourceKey
	    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pa.ReimbursableKey
			
WHERE  1 = 1
	AND c.CalendarPeriod >= '' + LEFT(LTRIM(STR(@ReportExpensePeriod,10,0)),4)+''01'' + ''
	AND c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select t1.FunctionalDepartmentKey From #FunctionalDepartmentFilterTable t1)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select t1.ActivityTypeKey From #ActivityTypeFilterTable t1)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select t1.PropertyFundKey From #EntityFilterTable t1)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationRegionFilterTable t1)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationSubRegionFilterTable t1)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MajorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MinorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingRegionFilterTable t1)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingSubRegionFilterTable t1)'' END +
''
	Group By
		pagacb.GlAccountCategoryKey,
	    pa.FunctionalDepartmentKey,
	    pa.AllocationRegionKey,
	    pa.PropertyFundKey,
	    s.SourceName
'')
print @cmdString
EXEC (@cmdString)


SET @cmdString = (Select ''	

	INSERT INTO #ExpenseCzarTotalComparisonDetail
	SELECT 
		pbgacb.GlAccountCategoryKey,
	    pb.FunctionalDepartmentKey,
	    pb.AllocationRegionKey,
	    pb.PropertyFundKey,
	    s.SourceName,
		SUM(
			(
				er.Rate *
				CASE WHEN (c.CalendarPeriod = ''+STR(@ReportExpensePeriod,10,0)+'') THEN
					pb.LocalBudget
				ELSE
					0
				END
			)
		) as MtdGrossBudget,
		NULL as MtdGrossActual,
		SUM(
			(
				er.Rate *
				CASE WHEN (r.ReimbursableCode = ''''NO'''' AND c.CalendarPeriod = ''+STR(@ReportExpensePeriod,10,0)+'') THEN 
					pb.LocalBudget
				ELSE 
					0
				END
			)
		) as MtdNetBudget,
		NULL as MtdNetActual,
		SUM(
			(
				er.Rate *
				CASE WHEN (c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+'') THEN
					pb.LocalBudget
				ELSE
					0
				END
			)
		) as YtdGrossBudget,
		NULL as YtdGrossActual,
		SUM(
			(
				er.Rate *
				CASE WHEN (r.ReimbursableCode = ''''NO'''' AND c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+'') THEN 
					pb.LocalBudget
				ELSE 
					0
				END
			)
		) as YtdNetBudget,
		NULL as YtdNetActual,
		SUM(
			(
				er.Rate * pb.LocalBudget
			)
		) as AnualGrossBudget,
		SUM(
			(
				er.Rate *
				CASE WHEN (c.CalendarPeriod > ''+STR(@ReportExpensePeriod,10,0)+'') THEN
					pb.LocalBudget
				ELSE
					0
				END
			)
		) as AnualEstGrossActual,
		SUM(
			(
				er.Rate *
				CASE WHEN (r.ReimbursableCode = ''''NO'''') THEN 
					pb.LocalBudget
				ELSE 
					0
				END
			)
		) as AnualNetBudget,
		SUM(
			(
				er.Rate *
				CASE WHEN (r.ReimbursableCode = ''''NO'''' AND c.CalendarPeriod > ''+STR(@ReportExpensePeriod,10,0)+'') THEN 
					pb.LocalBudget
				ELSE 
					0
				END
			)
		) as AnualEstNetActual
		
	FROM
		ProfitabilityBudget pb
		INNER JOIN (
				Select pbgacb.* From dbo.ProfitabilityBudgetGlAccountCategoryBridge pbgacb
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pbgacb.GlAccountCategoryKey
				UNION ALL
				Select pbgacbv.* From dbo.ProfitabilityBudgetGlAccountCategoryBridgeVirtual(''+STR(@CalendarYear,10,0)+'',''+STR(@ReportExpensePeriod,10,0)+'',''''''+ @HierarchyName + '''''') pbgacbv
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pbgacbv.GlAccountCategoryKey
				) pbgacb ON  
		pb.ProfitabilityBudgetKey = pbgacb.ProfitabilityBudgetKey'' +	

    + CASE WHEN @MajorAccountCategoryList IS NOT NULL OR @MinorAccountCategoryList IS NOT NULL THEN '' INNER JOIN GlAccountCategory gac ON  gac.GlAccountCategoryKey = pbgacb.GlAccountCategoryKey '' ELSE '''' END +
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pb.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey'' ELSE '''' END + ''
		
	    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey
	    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
	    INNER JOIN Calendar c ON  c.CalendarKey = pb.CalendarKey
	    INNER JOIN Source s ON s.SourceKey = pb.SourceKey
	    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pb.ReimbursableKey
WHERE  1 = 1 
	AND c.CalendarPeriod >= '' + LEFT(LTRIM(STR(@ReportExpensePeriod,10,0)),4)+''01'' + ''
	AND c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
	Group By
		pbgacb.GlAccountCategoryKey,
	    pb.FunctionalDepartmentKey,
	    pb.AllocationRegionKey,
	    pb.PropertyFundKey,
	    s.SourceName
	    '')

print @cmdString
EXEC (@cmdString)

CREATE CLUSTERED INDEX IX ON #ExpenseCzarTotalComparisonDetail(PropertyFundKey,AllocationRegionKey,FunctionalDepartmentKey,GlAccountCategoryKey)

	SELECT 

		gac.ExpenseType,
		gac.MajorName MajorExpenseCategory,
	    gac.MinorName MinorExpenseCategory,
	    fd.FunctionalDepartmentName FunctionalDepartment,
	    fd.FunctionalDepartmentName FunctionalDepartmentFilter,
	    ar.SubRegionName AllocationSubRegion,
	    ar.SubRegionName AllocationSubRegionFilter,
	    pf.PropertyFundName Entity,
	    res.SourceName SourceName,
    
		SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossBudget,0) ELSE ISNULL(MtdNetBudget,0) END) AS MTDOriginalBudget,
		SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossActual,0) ELSE ISNULL(MtdNetActual,0) END) AS MTDActual,
		SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossBudget,0) - ISNULL(MtdGrossActual,0) ELSE ISNULL(MtdNetBudget,0) - ISNULL(MtdNetActual,0) END) AS MTDVariance,
		
		SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossBudget,0) ELSE ISNULL(YtdNetBudget,0) END) AS YTDOriginalBudget,
		SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossActual,0) ELSE ISNULL(YtdNetActual,0) END) AS YTDActual,
		SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossBudget,0) - ISNULL(YtdGrossActual,0) ELSE ISNULL(YtdNetBudget,0) - ISNULL(YtdNetActual,0) END) AS YTDVariance,
		
		SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(AnualGrossBudget,0) ELSE ISNULL(AnualNetBudget,0) END) AS AnualBudget,
		SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(AnualEstGrossActual,0) ELSE ISNULL(AnualEstNetActual,0) END) AS AnualEstimatedActual,
		SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(AnualGrossBudget,0) - ISNULL(AnualEstGrossActual,0) ELSE ISNULL(AnualNetBudget,0) - ISNULL(AnualEstNetActual,0) END) AS AnualEstimatedVariance

	FROM
		#ExpenseCzarTotalComparisonDetail res
				INNER JOIN PropertyFund pf ON pf.PropertyFundKey = res.PropertyFundKey
				INNER JOIN AllocationRegion ar ON ar.AllocationRegionKey = res.AllocationRegionKey
				INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentKey = res.FunctionalDepartmentKey
				INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = res.GlAccountCategoryKey 
		
	GROUP BY
		gac.ExpenseType,
		gac.MajorName,
	    gac.MinorName,
	    fd.FunctionalDepartmentName,
	    ar.SubRegionName,
	    pf.PropertyFundName,
	    res.SourceName
	
	IF 	OBJECT_ID(''tempdb..#ExpenseCzarTotalComparisonDetail'') IS NOT NULL
	    DROP TABLE #ExpenseCzarTotalComparisonDetail
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzar]    Script Date: 08/05/2010 15:11:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzar]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[stp_R_ExpenseCzar]
	@ReportExpensePeriod INT = NULL,
	@ReforecastQuaterName VARCHAR(10) = NULL, --''Q1'' or ''Q2'' or ''Q3''
	@PreviousReforecastQuaterName VARCHAR(10) = ''Q1'',-- or ''Q2'' or ''Q3''
	@DestinationCurrency VARCHAR(3) = NULL,
	@TranslationTypeName VARCHAR(50) = ''Global'',
	@IsGross bit = 1,-- Dummy code required by common parameter code in DL
	@FunctionalDepartmentList TEXT = NULL,
	@ActivityTypeList TEXT = NULL,
	@EntityList TEXT = NULL,
	@MajorAccountCategoryList TEXT = NULL,
	@MinorAccountCategoryList TEXT = NULL,
	@AllocationRegionList TEXT = NULL,
	@AllocationSubRegionList TEXT = NULL,
	@OriginatingRegionList TEXT = NULL,
	@OriginatingSubRegionList TEXT = NULL
AS
	/*
	DECLARE @ReportExpensePeriod	AS INT,
	@AccountCategoryList	AS TEXT,
	@DestinationCurrency	AS VARCHAR(3),
	@TranslationTypeName			VARCHAR(50)
	
	SET @ReportExpensePeriod = 201011
	SET @AccountCategoryList = ''IT Costs & Telecommunications|Legal & Professional Fees|Marketing''
	SET @DestinationCurrency =''USD''
	SET @TranslationTypeName = ''Global''
	
EXEC stp_R_ExpenseCzar
	@ReportExpensePeriod = 201011,
	@TranslationTypeName = ''Global'',
	@DestinationCurrency = ''USD'',

	@FunctionalDepartmentList = ''Information Technologies'',
	@AllocationRegionList = ''CHICAGO'',
	@EntityList = ''Aldgate|Centrium (St Cathrine House/Pegasus)''


*/
	DECLARE

	@_ReportExpensePeriod INT = @ReportExpensePeriod,
	@_ReforecastQuaterName VARCHAR(10) = @ReforecastQuaterName,
	@_PreviousReforecastQuaterName VARCHAR(10) = @PreviousReforecastQuaterName,
	@_DestinationCurrency VARCHAR(3) = @DestinationCurrency,
	@_TranslationTypeName VARCHAR(50) = @TranslationTypeName,
	@_FunctionalDepartmentList VARCHAR(8000) = @FunctionalDepartmentList,
	@_ActivityTypeList VARCHAR(8000) = @ActivityTypeList,
	@_EntityList VARCHAR(8000) = @EntityList,
	@_MajorAccountCategoryList VARCHAR(8000) = @MajorAccountCategoryList,
	@_MinorAccountCategoryList VARCHAR(8000) = @MinorAccountCategoryList,
	@_AllocationRegionList VARCHAR(8000) = @AllocationRegionList,
	@_AllocationSubRegionList VARCHAR(8000) = @AllocationSubRegionList,
	@_OriginatingRegionList VARCHAR(8000) = @OriginatingRegionList,
	@_OriginatingSubRegionList VARCHAR(8000) = @OriginatingSubRegionList
--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Variable defaults		*/
--------------------------------------------------------------------------

IF @ReportExpensePeriod IS NULL
	SET @ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + CAST(MONTH(GETDATE()) AS VARCHAR(2))AS INT)

IF @DestinationCurrency IS NULL
	SET @DestinationCurrency = ''USD''

IF 	@TranslationTypeName IS NULL
	SET @TranslationTypeName = ''Global''

	DECLARE @CalendarYear AS INT
	SET @CalendarYear = CAST(SUBSTRING(CAST(@ReportExpensePeriod AS VARCHAR(10)), 1, 4) AS INT)		
	
-- let latest reforecast (it will be zero if there is no data for the reforecast)
IF @ReforecastQuaterName IS NULL
	SET @ReforecastQuaterName = (SELECT TOP 1 ReforecastQuarterName 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
										  ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
									ORDER BY ReforecastEffectivePeriod DESC)

DECLARE @ReforecastEffectivePeriod INT
SET @ReforecastEffectivePeriod = (SELECT TOP 1 ReforecastEffectivePeriod 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										  ReforecastQuarterName = @ReforecastQuaterName
									ORDER BY ReforecastEffectivePeriod)
									
-- set Q1 reforecast									
IF @PreviousReforecastQuaterName IS NULL
		SET @PreviousReforecastQuaterName = (SELECT TOP 1 ReforecastQuarterName 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
										  ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
									ORDER BY ReforecastEffectivePeriod DESC)
									
DECLARE @PreviousReforecastEffectivePeriod INT																
SET @PreviousReforecastEffectivePeriod = (SELECT TOP 1 ReforecastEffectivePeriod  
									FROM dbo.Reforecast 
									WHERE ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										  ReforecastQuarterName = @PreviousReforecastQuaterName
									ORDER BY ReforecastEffectivePeriod)

--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Tables		*/
--------------------------------------------------------------------------
	
	CREATE TABLE	#EntityFilterTable	(PropertyFundKey Int NOT NULL)
	CREATE TABLE	#FunctionalDepartmentFilterTable	(FunctionalDepartmentKey Int NOT NULL)
	CREATE TABLE	#ActivityTypeFilterTable(ActivityTypeKey Int NOT NULL)
	CREATE TABLE	#AllocationRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#AllocationSubRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#MajorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#MinorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#OriginatingRegionFilterTable	(OriginatingRegionKey Int NOT NULL)
	CREATE TABLE	#OriginatingSubRegionFilterTable	(OriginatingRegionKey Int NOT NULL)	
		
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable	(PropertyFundKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable(ActivityTypeKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MajorAccountCategoryFilterTable(GlAccountCategoryKey)	
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MinorAccountCategoryFilterTable(GlAccountCategoryKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingRegionFilterTable	(OriginatingRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable	(OriginatingRegionKey)
	
IF (@EntityList IS NOT NULL)
	BEGIN
	Insert Into #EntityFilterTable
	Select pf.PropertyFundKey
	From dbo.Split(@_EntityList) t1
		INNER JOIN PropertyFund pf ON pf.PropertyFundName = t1.item
	
	END
	
IF (@FunctionalDepartmentList IS NOT NULL)
	BEGIN
	Insert Into #FunctionalDepartmentFilterTable
	Select fd.FunctionalDepartmentKey 
	From dbo.Split(@_FunctionalDepartmentList) t1
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentName = t1.item
	END

IF 	(@ActivityTypeList IS NOT NULL)
	BEGIN
    INSERT INTO #ActivityTypeFilterTable
    SELECT at.ActivityTypeKey 
    FROM dbo.Split(@_ActivityTypeList) t1
		INNER JOIN ActivityType at ON at.ActivityTypeName = t1.item
	END
	
IF (@AllocationRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationRegionFilterTable
	Select ar.AllocationRegionKey 
	From dbo.Split(@_AllocationRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.RegionName = t1.item
	END

IF (@AllocationSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationSubRegionFilterTable
	Select ar.AllocationRegionKey
	From dbo.Split(@_AllocationSubRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.SubRegionName = t1.item
	END

IF (@MajorAccountCategoryList IS NOT NULL)
	BEGIN
	Insert Into #MajorAccountCategoryFilterTable
	Select gl.GlAccountCategoryKey 
	From dbo.Split(@_MajorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MajorCategoryName = t1.item
	END
	
IF 	(@MinorAccountCategoryList IS NOT NULL)
	BEGIN
    INSERT INTO #MinorAccountCategoryFilterTable
    SELECT gl.GlAccountCategoryKey 
    FROM dbo.Split(@MinorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MinorCategoryName = t1.item
	END	

IF (@OriginatingRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingRegionFilterTable
	Select orr.OriginatingRegionKey 
	From dbo.Split(@_OriginatingRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.RegionName = t1.item
	END

IF (@OriginatingSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingSubRegionFilterTable
	Select orr.OriginatingRegionKey  
	From dbo.Split(@OriginatingSubRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.SubRegionName = t1.item
	END		
--------------------------------------------------------------------------
/*	COMMON END															*/
--------------------------------------------------------------------------
		
IF 	OBJECT_ID(''tempdb..#ExpenseCzar'') IS NOT NULL
    DROP TABLE #ExpenseCzar
		
CREATE TABLE #ExpenseCzar
(
	GlAccountCategoryKey		Int,
	AllocationRegionKey			Int,
	FunctionalDepartmentKey		Int,
	PropertyFundKey				Int,
	CalendarPeriod				INT,
	SourceName					VarChar(50),
	EntryDate					VARCHAR(10),
	[User]						NVARCHAR(20),
	[Description]				NVARCHAR(60),
	AdditionalDescription		NVARCHAR(4000),
	
	--Month to date	
	MtdGrossActual				MONEY,
	MtdGrossBudget				MONEY,
	MtdGrossReforecast			MONEY,
	MtdNetActual				MONEY,
	MtdNetBudget				MONEY,
	MtdNetReforecast			MONEY,
	
	--Year to date
	YtdGrossActual				MONEY,	
	YtdGrossBudget				MONEY, 
	YtdGrossReforecast			MONEY, 
	YtdNetActual				MONEY, 
	YtdNetBudget				MONEY, 
	YtdNetReforecast			MONEY, 

	--Annual	
	AnnualGrossBudget			MONEY,
	AnnualGrossReforecast		MONEY,
	AnnualGrossReforecastQ1		MONEY,
	AnnualNetBudget				MONEY,
	AnnualNetReforecast			MONEY,
	AnnualNetReforecastQ1		MONEY,

	--Annual estimated
	AnnualEstGrossBudget		MONEY,
	AnnualEstGrossReforecast	MONEY,
	AnnualEstNetBudget			MONEY,
	AnnualEstNetReforecast		MONEY
)

DECLARE @cmdString Varchar(8000)

--Get actual information
SET @cmdString = (Select ''

INSERT INTO #ExpenseCzar
SELECT 
	gac.GlAccountCategoryKey,
	pa.AllocationRegionKey,
    pa.FunctionalDepartmentKey,
    pa.PropertyFundKey,
    c.CalendarPeriod,
    s.SourceName,
    CONVERT(varchar(10),ISNULL(pa.EntryDate,''''''''), 101) as EntryDate,
    pa.[User],
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.Description ELSE '''''''' END as Description,
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.AdditionalDescription ELSE '''''''' END as AdditionalDescription,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdGrossActual,
	NULL as MtdGrossBudget,
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdGrossReforecast,
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdNetActual,
	NULL as MtdNetBudget,
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdNetReforecast,
	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdGrossActual,
	NULL as YtdGrossBudget,
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as YtdGrossReforecast,
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdNetActual,
	NULL as YtdNetBudget,
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as YtdNetReforecast,
	
	NULL as AnnualGrossBudget,
	SUM(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualGrossReforecast,
	SUM(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@PreviousReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualGrossReforecastQ1,

	NULL as AnnualNetBudget,
    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecast,
    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@PreviousReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ1,
	
	SUM(
        er.Rate *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pa.LocalActual
        ELSE 
			0
        END
	) as AnnualEstGrossBudget,
	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecast,

    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstNetReforecast
FROM
	ProfitabilityActual pa

	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pa.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pa.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pa.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pa.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pa.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pa.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pa.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pa.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
	INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
	INNER JOIN Calendar c ON  c.CalendarKey = pa.CalendarKey
	INNER JOIN Source s ON s.SourceKey = pa.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pa.ReimbursableKey ''
    			    
    + CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pa.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pa.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pa.PropertyFundKey'' ELSE '''' END + ''
		
WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select t1.FunctionalDepartmentKey From #FunctionalDepartmentFilterTable t1)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select t1.ActivityTypeKey From #ActivityTypeFilterTable t1)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select t1.PropertyFundKey From #EntityFilterTable t1)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationRegionFilterTable t1)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationSubRegionFilterTable t1)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MajorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MinorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingRegionFilterTable t1)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingSubRegionFilterTable t1)'' END +
''	
	Group By
		gac.GlAccountCategoryKey,
		pa.AllocationRegionKey,
		pa.FunctionalDepartmentKey,
		pa.PropertyFundKey,
		c.CalendarPeriod,
		s.SourceName,
		CONVERT(varchar(10),ISNULL(pa.EntryDate,''''''''), 101),
		pa.[User],
		CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.Description ELSE '''''''' END,
		CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.AdditionalDescription ELSE '''''''' END
'')
print @cmdString
EXEC (@cmdString)

-- Get budget information
SET @cmdString = (Select ''
INSERT INTO #ExpenseCzar
SELECT 
	gac.GlAccountCategoryKey,
	pb.AllocationRegionKey,
	pb.FunctionalDepartmentKey,
	pb.PropertyFundKey,
	c.CalendarPeriod,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    
   NULL as MtdGrossActual,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as MtdGrossBudget,
	NULL as MtdGrossReforecast,
	
	NULL as MtdNetActual,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as MtdNetBudget,
	NULL as MtdNetReforecast,
	
	NULL as YtdGrossActual,	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as YtdGrossBudget, 
	NULL as YtdGrossReforecast, 
	
	NULL as YtdNetActual, 
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as YtdNetBudget, 
	NULL as YtdNetReforecast, 
	
	SUM(er.Rate * pb.LocalBudget) as AnnualGrossBudget,
	NULL as AnnualGrossReforecast,
	NULL as AnnualGrossReforecastQ1,

	SUM(er.Rate * r.MultiplicationFactor * pb.LocalBudget) as AnnualNetBudget,
	NULL as AnnualNetReforecast,
	NULL as AnnualNetReforecastQ1,

	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as AnnualEstGrossBudget,
	NULL as AnnualEstGrossReforecast,

	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
	NULL as AnnualEstNetReforecast
FROM
	ProfitabilityBudget pb
    
    	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pb.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pb.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pb.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pb.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pb.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pb.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pb.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pb.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON c.CalendarKey = pb.CalendarKey
    INNER JOIN Source s ON s.SourceKey = pb.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pb.ReimbursableKey ''
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pb.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey'' ELSE '''' END + ''

		
WHERE  1 = 1 
    AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''    
	Group By
			gac.GlAccountCategoryKey,
			pb.AllocationRegionKey,
			pb.FunctionalDepartmentKey,
			pb.PropertyFundKey,
			c.CalendarPeriod,
			s.SourceName
'')
print @cmdString
EXEC (@cmdString)

-- Get reforecast information
SET @cmdString = (Select ''
INSERT INTO #ExpenseCzar
SELECT 
	gac.GlAccountCategoryKey,
	pr.AllocationRegionKey,
	pr.FunctionalDepartmentKey,
	pr.PropertyFundKey,
	c.CalendarPeriod,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecast,
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecast,
	
	NULL as YtdGrossActual,	
	NULL as YtdGrossBudget, 
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecast, 
	
	NULL as YtdNetActual, 
	NULL as YtdNetBudget, 
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecast, 
	
	NULL as AnnualGrossBudget, '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecast,
    NULL as AnnualGrossReforecastQ1,

	NULL as AnnualNetBudget, '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecast,
    NULL as AnnualNetReforecastQ1,

	NULL as AnnualEstGrossBudget,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriod,6,0) + '' IN (201003,201006)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstGrossReforecast,

	NULL as AnnualEstNetBudget,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriod,6,0) + '' IN (201003,201006)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstNetReforecast
FROM
	ProfitabilityReforecast pr
    
    	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON c.CalendarKey = pr.CalendarKey
    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
    INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey ''
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + ''

		
WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND ref.ReforecastEffectivePeriod = '' + STR(@ReforecastEffectivePeriod,10,0) + ''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''    
	Group By
			gac.GlAccountCategoryKey,
			pr.AllocationRegionKey,
			pr.FunctionalDepartmentKey,
			pr.PropertyFundKey,
			c.CalendarPeriod,
			s.SourceName
'')
print @cmdString
EXEC (@cmdString)

-- Get reforecastQ1 information
SET @cmdString = (Select ''
INSERT INTO #ExpenseCzar
SELECT 
	gac.GlAccountCategoryKey,
	pr.AllocationRegionKey,
	pr.FunctionalDepartmentKey,
	pr.PropertyFundKey,
	c.CalendarPeriod,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	NULL as MtdGrossReforecast,
	  
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
	NULL as MtdNetReforecast,
	  
	NULL as YtdGrossActual, 
	NULL as YtdGrossBudget, 
	NULL as YtdGrossReforecast, 
	  
	NULL as YtdNetActual, 
	NULL as YtdNetBudget, 
	NULL as YtdNetReforecast, 
	 
	NULL as AnnualGrossBudget,
	NULL as AnnualGrossReforecast,
	SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ1,
	  

	NULL as AnnualNetBudget,
	NULL as AnnualNetReforecast,
	SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecastQ1,
	 
	NULL as AnnualEstGrossBudget,
	NULL as AnnualEstGrossReforecast,

	NULL as AnnualEstNetBudget,
	NULL as AnnualEstNetReforecast
FROM
	ProfitabilityReforecast pr
    
    	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON c.CalendarKey = pr.CalendarKey
    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
    INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey ''
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + ''

		
WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND ref.ReforecastEffectivePeriod = '' + STR(@PreviousReforecastEffectivePeriod,10,0) + ''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''    
	Group By
			gac.GlAccountCategoryKey,
			pr.AllocationRegionKey,
			pr.FunctionalDepartmentKey,
			pr.PropertyFundKey,
			c.CalendarPeriod,
			s.SourceName
'')
print @cmdString
EXEC (@cmdString)


SELECT 
	gac.AccountSubTypeName AS ExpenseType,
	ar.RegionName AS AllocationRegionName,
    fd.FunctionalDepartmentName AS FunctionalDepartmentName,
    gac.MajorCategoryName AS MajorExpenseCategoryName,
    gac.MinorCategoryName AS MinorExpenseCategoryName,
    pf.PropertyFundName AS EntityName,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
    res.SourceName AS SourceName,
	--Gross
	--Month to date    
	SUM(ISNULL(MtdGrossActual,0)) AS MtdGrossActual,
	SUM(ISNULL(MtdGrossBudget,0)) AS MtdGrossOriginalBudget,
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast 
		END,0)) AS MtdGrossReforecast,
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast 
		END, 0) - ISNULL(MtdGrossActual, 0)) 
	AS MtdGrossVariance,
		
	--Year to date
	SUM(ISNULL(YtdGrossActual,0)) AS YtdGrossActual,	
	SUM(ISNULL(YtdGrossBudget,0)) AS YtdGrossOriginalBudget,
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END,0)) AS YtdGrossReforecast,
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END, 0) - ISNULL(YtdGrossActual, 0)) 
	AS YtdGrossVariance,
		
	--Annual
	SUM(ISNULL(AnnualGrossBudget,0)) AS AnnualGrossOriginalBudget,	
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecast 
		END,0)) 
		AS AnnualGrossReforecast,
		
	SUM (ISNULL(CASE WHEN @PreviousReforecastQuaterName = ''Q1'' THEN 
			AnnualGrossReforecastQ1 		
		END,0)) 
	AS AnnualGrossReforecastQ1,		
	--Annual Estimated
	--SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
	--		AnnualEstGrossBudget 
	--	ELSE 
	--		AnnualEstGrossReforecast 
	--	END,0)) 
	--	AS AnnualGrossEstimatedActual,	
		
	--SUM(ISNULL(AnnualGrossBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
	--											AnnualEstGrossBudget 
	--										ELSE 
	--											AnnualEstGrossReforecast 
	--										END,0)) 
	--AS AnnualGrossEstimatedVariance,
	
	--Net
	--Month to date    
	SUM(ISNULL(MtdNetActual,0)) AS MtdNetActual,
	SUM(ISNULL(MtdNetBudget,0)) AS MtdNetOriginalBudget,
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast 
		END,0)) 
	AS MtdNetReforecast,
	
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast 
		END, 0) - ISNULL(MtdNetActual, 0)) 
	AS MtdNetVariance,
		
	--Year to date
	SUM(ISNULL(YtdNetActual,0)) AS YtdNetActual,	
	SUM(ISNULL(YtdNetBudget,0)) AS YtdNetOriginalBudget,
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast 
		END,0)) 
	AS YtdNetReforecast,
		
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast 
		END, 0) - ISNULL(YtdNetActual, 0)) 
	AS YtdNetVariance,
		
	--Annual
	SUM(ISNULL(AnnualNetBudget,0)) AS AnnualNetOriginalBudget,	
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecast 
		END,0)) 
	AS AnnualNetReforecast,
	
	SUM (ISNULL(CASE WHEN @PreviousReforecastQuaterName = ''Q1'' THEN 
			AnnualNetReforecastQ1 		
		END,0)) 
	AS AnnualNetReforecastQ1
		
	--Annual Estimated
	--SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
	--		AnnualEstNetBudget 
	--	ELSE 
	--		AnnualEstNetReforecast 
	--	END,0)) 
	--AS AnnualNetEstimatedActual,	
		
	--SUM(ISNULL(AnnualNetBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
	--										AnnualEstNetBudget 
	--									ELSE 
	--										AnnualEstNetReforecast 
	--									END,0)) 
	--AS AnnualNetEstimatedVariance    
INTO
	#Output
FROM
	#ExpenseCzar res
		INNER JOIN PropertyFund pf ON pf.PropertyFundKey = res.PropertyFundKey
		INNER JOIN AllocationRegion ar ON ar.AllocationRegionKey = res.AllocationRegionKey
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentKey = res.FunctionalDepartmentKey
		INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = res.GlAccountCategoryKey 
GROUP BY
	gac.AccountSubTypeName,
	ar.RegionName,
    fd.FunctionalDepartmentName,
    gac.MajorCategoryName,
    gac.MinorCategoryName,
    pf.PropertyFundName,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
    res.SourceName

--Output
SELECT
	ExpenseType,
	AllocationRegionName,
    FunctionalDepartmentName,
    MajorExpenseCategoryName,
    MinorExpenseCategoryName,
    EntityName,
    EntryDate,
    [User],
    [Description],
    AdditionalDescription,
    SourceName,
	--Gross
	--Month to date    
	MtdGrossActual,
	MtdGrossOriginalBudget,

	MtdGrossReforecast,
	MtdGrossVariance,
		
	--Year to date
	YtdGrossActual,	
	YtdGrossOriginalBudget,

	YtdGrossReforecast,
	YtdGrossVariance,

	--Annual
	AnnualGrossOriginalBudget,	
	AnnualGrossReforecast,
	AnnualGrossReforecastQ1,

	--Annual Estimated
	--AnnualGrossEstimatedActual,
	--AnnualGrossEstimatedVariance,

	--Net
	--Month to date    
	MtdNetActual,
	MtdNetOriginalBudget,
	MtdNetReforecast,
	MtdNetVariance,

	--Year to date
	YtdNetActual,	
	YtdNetOriginalBudget,
	YtdNetReforecast,
	YtdNetVariance,

	--Annual
	AnnualNetOriginalBudget,	
	AnnualNetReforecast,
	AnnualNetReforecastQ1

	--Annual Estimated
	--AnnualNetEstimatedActual,	
	--AnnualNetEstimatedVariance
FROM
	#Output
WHERE
	--Gross
	--Month to date    
	MtdGrossActual <> 0.00 OR
	MtdGrossOriginalBudget <> 0.00 OR

	MtdGrossReforecast <> 0.00 OR
	MtdGrossVariance <> 0.00 OR
		
	--Year to date
	YtdGrossActual <> 0.00 OR
	YtdGrossOriginalBudget <> 0.00 OR

	YtdGrossReforecast <> 0.00 OR
	YtdGrossVariance <> 0.00 OR

	--Annual
	AnnualGrossOriginalBudget <> 0.00 OR
	AnnualGrossReforecast <> 0.00 OR
	AnnualGrossReforecastQ1 <> 0.00 OR

	--Annual Estimated
	--AnnualGrossEstimatedActual <> 0.00 OR
	--AnnualGrossEstimatedVariance <> 0.00 OR

	--Net
	--Month to date
	MtdNetActual <> 0.00 OR
	MtdNetOriginalBudget <> 0.00 OR
	MtdNetReforecast <> 0.00 OR
	MtdNetVariance <> 0.00 OR

	--Year to date
	YtdNetActual <> 0.00 OR
	YtdNetOriginalBudget <> 0.00 OR
	YtdNetReforecast <> 0.00 OR
	YtdNetVariance <> 0.00 OR

	--Annual
	AnnualNetOriginalBudget <> 0.00 OR
	AnnualNetReforecast <> 0.00 OR
	AnnualNetReforecastQ1 <> 0.00 --OR

	--Annual Estimated
	--AnnualNetEstimatedActual <> 0.00 OR
	--AnnualNetEstimatedVariance <> 0.00


	IF 	OBJECT_ID(''tempdb..#AccountCategoryFilterTable'') IS NOT NULL
	    DROP TABLE #AccountCategoryFilterTable
	    
	IF 	OBJECT_ID(''tempdb..#ActivityTypeFilterTable'') IS NOT NULL
	    DROP TABLE #ActivityTypeFilterTable
	    
	IF 	OBJECT_ID(''tempdb..#MinorAccountCategoryFilterTable'') IS NOT NULL
		DROP TABLE #MinorAccountCategoryFilterTable

	IF 	OBJECT_ID(''tempdb..#ExpenseCzar'') IS NOT NULL
	    DROP TABLE #ExpenseCzar
	    
	IF 	OBJECT_ID(''tempdb..#Output'') IS NOT NULL
		DROP TABLE #Output
		
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginatorOwnerFunctionalDepartment]    Script Date: 08/05/2010 15:11:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOriginatorOwnerFunctionalDepartment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[stp_R_BudgetOriginatorOwnerFunctionalDepartment]
	@ReportExpensePeriod INT = NULL,
	@ReforecastQuaterName VARCHAR(10) = NULL, --''Q1'' or ''Q2'' or ''Q3''
	@PreviousReforecastQuaterName VARCHAR(10) =''Q1'',
	@DestinationCurrency VARCHAR(3) = NULL,
	@TranslationTypeName VARCHAR(50) = ''Global'',
	@IsGross bit = 1,
	@FunctionalDepartmentList TEXT = NULL,
	@ActivityTypeList TEXT = NULL,
	@EntityList TEXT = NULL,
	@MajorAccountCategoryList TEXT = NULL,
	@MinorAccountCategoryList TEXT = NULL,
	@AllocationRegionList TEXT = NULL,
	@AllocationSubRegionList TEXT = NULL,
	@OriginatingRegionList TEXT = NULL,
	@OriginatingSubRegionList TEXT = NULL

AS

DECLARE

	@_ReportExpensePeriod INT = @ReportExpensePeriod,
	@_ReforecastQuaterName VARCHAR(10) = @ReforecastQuaterName,
	@_PreviousReforecastQuaterName VARCHAR(10) = @PreviousReforecastQuaterName,
	@_DestinationCurrency VARCHAR(3) = @DestinationCurrency,
	@_TranslationTypeName VARCHAR(50) = @TranslationTypeName,
	@_IsGross bit = @IsGross,
	@_FunctionalDepartmentList VARCHAR(8000) = @FunctionalDepartmentList,
	@_ActivityTypeList VARCHAR(8000) = @ActivityTypeList,
	@_EntityList VARCHAR(8000) = @EntityList,
	@_MajorAccountCategoryList VARCHAR(8000) = @MajorAccountCategoryList,
	@_MinorAccountCategoryList VARCHAR(8000) = @MinorAccountCategoryList,
	@_AllocationRegionList VARCHAR(8000) = @AllocationRegionList,
	@_AllocationSubRegionList VARCHAR(8000) = @AllocationSubRegionList,
	@_OriginatingRegionList VARCHAR(8000) = @OriginatingRegionList,
	@_OriginatingSubRegionList VARCHAR(8000) = @OriginatingSubRegionList
	
if LEN(@_FunctionalDepartmentList) > 7998 OR
	LEN(@_ActivityTypeList) > 7998 OR
	LEN(@_EntityList) > 7998 OR
	LEN(@_MajorAccountCategoryList) > 7998 OR
	LEN(@_MinorAccountCategoryList) > 7998 OR
	LEN(@_AllocationRegionList) > 7998 OR
	LEN(@_AllocationSubRegionList) > 7998 OR
	LEN(@_OriginatingRegionList) > 7998 OR
	LEN(@_OriginatingSubRegionList) > 7998
	BEGIN
	RAISERROR(''Filter List parameter is to big'',19,1)
	END
	
/*
DECLARE @ReportExpensePeriod		AS INT,
        @FunctionalDepartmentList  AS VARCHAR(8000),
        @DestinationCurrency		AS VARCHAR(3),
        @TranslationTypeName				VARCHAR(50)
				
		
SET @ReportExpensePeriod = 201011
SET @FunctionalDepartmentList = ''Information Technologies''
SET @DestinationCurrency = ''USD''
SET @TranslationTypeName = ''Global''

EXEC stp_R_BudgetOriginatorOwnerFunctionalDepartment
	@ReportExpensePeriod = 201011,
	@TranslationTypeName = ''Global'',
	@DestinationCurrency = ''USD'',

	@FunctionalDepartmentList = ''Information Technologies'',
	@AllocationRegionList = ''CHICAGO'',
	@EntityList = ''Aldgate|Centrium (St Cathrine House/Pegasus)''

*/

--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Variable defaults		*/
--------------------------------------------------------------------------

IF @ReportExpensePeriod IS NULL
	SET @ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + REPLACE(STR(MONTH(GETDATE()),2 ),'' '',''0'')AS INT)

IF @DestinationCurrency IS NULL
	SET @DestinationCurrency = ''USD''

IF 	@TranslationTypeName IS NULL
	SET @TranslationTypeName = ''Global''

	DECLARE @CalendarYear AS INT
	SET @CalendarYear = CAST(SUBSTRING(CAST(@ReportExpensePeriod AS VARCHAR(10)), 1, 4) AS INT)				

-- let latest reforecast (it will be zero if there is no data for the reforecast)
IF @ReforecastQuaterName IS NULL
	SET @ReforecastQuaterName = (SELECT TOP 1 ReforecastQuarterName 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
										  ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
									ORDER BY ReforecastEffectivePeriod DESC)

DECLARE @ReforecastEffectivePeriod INT
SET @ReforecastEffectivePeriod = (SELECT TOP 1 ReforecastEffectivePeriod 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										  ReforecastQuarterName = @ReforecastQuaterName
									ORDER BY ReforecastEffectivePeriod)
									
-- Q2 reforecasts									
IF @PreviousReforecastQuaterName IS NULL
		SET @PreviousReforecastQuaterName = (SELECT TOP 1 ReforecastQuarterName 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
										  ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
									ORDER BY ReforecastEffectivePeriod DESC)
									
DECLARE @PreviousReforecastEffectivePeriod INT																
SET @PreviousReforecastEffectivePeriod = (SELECT TOP 1 ReforecastEffectivePeriod  
									FROM dbo.Reforecast 
									WHERE ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										  ReforecastQuarterName = @PreviousReforecastQuaterName
									ORDER BY ReforecastEffectivePeriod)

--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Tables		*/
--------------------------------------------------------------------------
	
	CREATE TABLE	#EntityFilterTable	(PropertyFundKey Int NOT NULL)
	CREATE TABLE	#FunctionalDepartmentFilterTable	(FunctionalDepartmentKey Int NOT NULL)
	CREATE TABLE	#ActivityTypeFilterTable(ActivityTypeKey Int NOT NULL)
	CREATE TABLE	#AllocationRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#AllocationSubRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#MajorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#MinorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#OriginatingRegionFilterTable	(OriginatingRegionKey Int NOT NULL)
	CREATE TABLE	#OriginatingSubRegionFilterTable	(OriginatingRegionKey Int NOT NULL)	
		
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable	(PropertyFundKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable(ActivityTypeKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MajorAccountCategoryFilterTable(GlAccountCategoryKey)	
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MinorAccountCategoryFilterTable(GlAccountCategoryKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingRegionFilterTable	(OriginatingRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable	(OriginatingRegionKey)
	
IF (@EntityList IS NOT NULL)
	BEGIN
	Insert Into #EntityFilterTable
	Select pf.PropertyFundKey
	From dbo.Split(@_EntityList) t1
		INNER JOIN PropertyFund pf ON pf.PropertyFundName = t1.item
	
	END
	
IF (@FunctionalDepartmentList IS NOT NULL)
	BEGIN
	Insert Into #FunctionalDepartmentFilterTable
	Select fd.FunctionalDepartmentKey 
	From dbo.Split(@_FunctionalDepartmentList) t1
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentName = t1.item
	END

IF 	(@ActivityTypeList IS NOT NULL)
	BEGIN
    INSERT INTO #ActivityTypeFilterTable
    SELECT at.ActivityTypeKey 
    FROM dbo.Split(@_ActivityTypeList) t1
		INNER JOIN ActivityType at ON at.ActivityTypeName = t1.item
	END
	
IF (@AllocationRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationRegionFilterTable
	Select ar.AllocationRegionKey 
	From dbo.Split(@_AllocationRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.RegionName = t1.item
	END

IF (@AllocationSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationSubRegionFilterTable
	Select ar.AllocationRegionKey
	From dbo.Split(@_AllocationSubRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.SubRegionName = t1.item
	END

IF (@MajorAccountCategoryList IS NOT NULL)
	BEGIN
	Insert Into #MajorAccountCategoryFilterTable
	Select gl.GlAccountCategoryKey 
	From dbo.Split(@_MajorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MajorCategoryName = t1.item
	END
	
IF 	(@MinorAccountCategoryList IS NOT NULL)
	BEGIN
    INSERT INTO #MinorAccountCategoryFilterTable
    SELECT gl.GlAccountCategoryKey 
    FROM dbo.Split(@MinorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MinorCategoryName = t1.item
	END	

IF (@OriginatingRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingRegionFilterTable
	Select orr.OriginatingRegionKey 
	From dbo.Split(@_OriginatingRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.RegionName = t1.item
	END

IF (@OriginatingSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingSubRegionFilterTable
	Select orr.OriginatingRegionKey  
	From dbo.Split(@OriginatingSubRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.SubRegionName = t1.item
	END		
--------------------------------------------------------------------------
/*	COMMON END															*/
--------------------------------------------------------------------------
	
IF 	OBJECT_ID(''tempdb..#BudgetOriginatorOwner'') IS NOT NULL
    DROP TABLE #BudgetOriginatorOwner

CREATE TABLE #BudgetOriginatorOwner
(
	AllocationRegionKey		Int,
	OriginatingRegionKey	INT,
    PropertyFundKey			Int,
    FunctionalDepartmentKey Int,
	GlAccountCategoryKey	Int,
	SourceName				VarChar(50),
	EntryDate				VARCHAR(10),
	[User]					NVARCHAR(20),
	[Description]			NVARCHAR(60),
	AdditionalDescription	NVARCHAR(4000),
	
	--Month to date	
	MtdGrossActual				MONEY,
	MtdGrossBudget				MONEY,
	MtdGrossReforecast			MONEY,
	MtdNetActual				MONEY,
	MtdNetBudget				MONEY,
	MtdNetReforecast			MONEY,
	
	--Year to date
	YtdGrossActual				MONEY,	
	YtdGrossBudget				MONEY, 
	YtdGrossReforecast			MONEY, 
	YtdNetActual				MONEY, 
	YtdNetBudget				MONEY, 
	YtdNetReforecast			MONEY,
	
	--Annual
	AnnualGrossBudget			MONEY,
	AnnualGrossReforecast		MONEY,
	AnnualGrossReforecastQ1		MONEY,
	AnnualNetBudget				MONEY,
	AnnualNetReforecast			MONEY,
	AnnualNetReforecastQ1		MONEY,

	--Annual estimated
	AnnualEstGrossBudget		MONEY,
	AnnualEstGrossReforecast	MONEY,
	AnnualEstNetBudget			MONEY,
	AnnualEstNetReforecast		MONEY
)

DECLARE @cmdString Varchar(8000)

--Get actual information
SET @cmdString = (Select ''

INSERT INTO #BudgetOriginatorOwner
SELECT 
	pa.AllocationRegionKey,
	pa.OriginatingRegionKey,
    pa.PropertyFundKey,
    pa.FunctionalDepartmentKey,
	gac.GlAccountCategoryKey,
    s.SourceName,
    CONVERT(varchar(10),ISNULL(pa.EntryDate,''''''''), 101) as EntryDate,
    pa.[User],
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.Description ELSE '''''''' END as Description,
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.AdditionalDescription ELSE '''''''' END as AdditionalDescription,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdGrossActual,
	NULL as MtdGrossBudget,
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdGrossReforecast,
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdNetActual,
	NULL as MtdNetBudget,
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdNetReforecast,
	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdGrossActual,
	NULL as YtdGrossBudget,
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as YtdGrossReforecast,
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdNetActual,
	NULL as YtdNetBudget,
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as YtdNetReforecast,
	
	NULL as AnnualGrossBudget,
	SUM(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualGrossReforecast,
	SUM(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@PreviousReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualGrossReforecastQ1,

	NULL as AnnualNetBudget,
    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecast,
    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@PreviousReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ1,
	
	SUM(
        er.Rate *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pa.LocalActual
        ELSE 
			0
        END
	) as AnnualEstGrossBudget,
	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecast,

    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstNetReforecast
FROM
	ProfitabilityActual pa

	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pa.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pa.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pa.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pa.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pa.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pa.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pa.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pa.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')
	
    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pa.CalendarKey
    INNER JOIN Source s ON s.SourceKey = pa.SourceKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pa.ReimbursableKey ''
    		
    + CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pa.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pa.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pa.PropertyFundKey'' ELSE '''' END + ''

WHERE  1 = 1
    AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
 	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
 	AND gac.MinorCategoryName <> ''''Bonus''''
 	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select t1.FunctionalDepartmentKey From #FunctionalDepartmentFilterTable t1)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select t1.ActivityTypeKey From #ActivityTypeFilterTable t1)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select t1.PropertyFundKey From #EntityFilterTable t1)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationRegionFilterTable t1)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationSubRegionFilterTable t1)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MajorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MinorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingRegionFilterTable t1)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingSubRegionFilterTable t1)'' END +
''
Group By
	pa.AllocationRegionKey,
	pa.OriginatingRegionKey,
    pa.PropertyFundKey,
    pa.FunctionalDepartmentKey,
	gac.GlAccountCategoryKey,
	s.SourceName,
	CONVERT(varchar(10),ISNULL(pa.EntryDate,''''''''), 101),
	pa.[User],
	CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.Description ELSE '''''''' END,
	CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.AdditionalDescription ELSE '''''''' END
	'')
print @cmdString
EXEC (@cmdString)

-- Get budget information
SET @cmdString = (Select ''
INSERT INTO #BudgetOriginatorOwner
SELECT 
	pb.AllocationRegionKey,
	pb.OriginatingRegionKey,
    pb.PropertyFundKey,
    pb.FunctionalDepartmentKey,
	gac.GlAccountCategoryKey,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    
    NULL as MtdGrossActual,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as MtdGrossBudget,
	NULL as MtdGrossReforecast,
	
	NULL as MtdNetActual,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as MtdNetBudget,
	NULL as MtdNetReforecast,
	
	NULL as YtdGrossActual,	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as YtdGrossBudget, 
	NULL as YtdGrossReforecast, 
	
	NULL as YtdNetActual, 
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as YtdNetBudget, 
	NULL as YtdNetReforecast,
	
	SUM(er.Rate * pb.LocalBudget) as AnnualGrossBudget,
	NULL as AnnualGrossReforecast,
	NULL as AnnualGrossReforecastQ1,

	SUM(er.Rate * r.MultiplicationFactor * pb.LocalBudget) as AnnualNetBudget,
	NULL as AnnualNetReforecast,
	NULL as AnnualNetReforecastQ1,

	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as AnnualEstGrossBudget,
	NULL as AnnualEstGrossReforecast,

	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
	NULL as AnnualEstNetReforecast
FROM
    ProfitabilityBudget pb
    	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pb.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pb.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pb.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pb.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pb.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pb.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pb.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pb.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

    INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey 
	INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey    
	INNER JOIN Calendar c ON  c.CalendarKey = pb.CalendarKey
	INNER JOIN Source s ON s.SourceKey = pb.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pb.ReimbursableKey ''
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pb.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey'' ELSE '''' END + ''
		
WHERE  1 = 1 
    AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Bonus''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
Group By
	pb.AllocationRegionKey,
	pb.OriginatingRegionKey,
    pb.PropertyFundKey,
    pb.FunctionalDepartmentKey,
	gac.GlAccountCategoryKey,
	s.SourceName'')

print @cmdString
EXEC (@cmdString)

-- Get reforecast information
SET @cmdString = (Select ''
INSERT INTO #BudgetOriginatorOwner
SELECT 
	pr.AllocationRegionKey,
	pr.OriginatingRegionKey,
    pr.PropertyFundKey,
    pr.FunctionalDepartmentKey,
	gac.GlAccountCategoryKey,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecast,
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecast,
	
	NULL as YtdGrossActual,	
	NULL as YtdGrossBudget, 
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecast, 
	
	NULL as YtdNetActual, 
	NULL as YtdNetBudget, 
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecast,
    
    NULL as AnnualGrossBudget, '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecast,
     NULL as AnnualGrossReforecastQ1,

	NULL as AnnualNetBudget, '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecast,
    NULL as AnnualNetReforecastQ1,

	NULL as AnnualEstGrossBudget,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriod,6,0) + '' IN (201003,201006)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstGrossReforecast,

	NULL as AnnualEstNetBudget,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriod,6,0) + '' IN (201003,201006)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstNetReforecast
FROM
    ProfitabilityReforecast pr
    	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

    INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey 
	INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey    
	INNER JOIN Calendar c ON  c.CalendarKey = pr.CalendarKey
	INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
	INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey ''
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + ''
		
WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND ref.ReforecastEffectivePeriod = '' + STR(@ReforecastEffectivePeriod,6,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Bonus''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
Group By
	pr.AllocationRegionKey,
	pr.OriginatingRegionKey,
    pr.PropertyFundKey,
    pr.FunctionalDepartmentKey,
	gac.GlAccountCategoryKey,
	s.SourceName'')

print @cmdString
EXEC (@cmdString)

-- Get reforecastQ1 information
SET @cmdString = (Select ''
INSERT INTO #BudgetOriginatorOwner
SELECT 
	pr.AllocationRegionKey,
	pr.OriginatingRegionKey,
    pr.PropertyFundKey,
    pr.FunctionalDepartmentKey,
	gac.GlAccountCategoryKey,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    
	NULL as MtdGrossActual,
      NULL as MtdGrossBudget,
      NULL as MtdGrossReforecast,
      
      NULL as MtdNetActual,
      NULL as MtdNetBudget,
	  NULL as MtdNetReforecast,
      
      NULL as YtdGrossActual, 
      NULL as YtdGrossBudget, 
      NULL as YtdGrossReforecast, 
      
      NULL as YtdNetActual, 
      NULL as YtdNetBudget, 
      NULL as YtdNetReforecast, 
      
      NULL as AnnualGrossBudget,
      NULL as AnnualGrossReforecast,
      SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ1,
      

      NULL as AnnualNetBudget,
      NULL as AnnualNetReforecast,
      SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecastQ1,
      
      NULL as AnnualEstGrossBudget,
      NULL as AnnualEstGrossReforecast,

      NULL as AnnualEstNetBudget,
      NULL as AnnualEstNetReforecast
FROM
    ProfitabilityReforecast pr
    	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

    INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey 
	INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey    
	INNER JOIN Calendar c ON  c.CalendarKey = pr.CalendarKey
	INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
	INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey ''
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + ''
		
WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND ref.ReforecastEffectivePeriod = '' + STR(@PreviousReforecastEffectivePeriod,6,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Bonus''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
Group By
	pr.AllocationRegionKey,
	pr.OriginatingRegionKey,
    pr.PropertyFundKey,
    pr.FunctionalDepartmentKey,
	gac.GlAccountCategoryKey,
	s.SourceName'')	

print @cmdString
EXEC (@cmdString)

--Functional Department Mode
SELECT 
	gac.AccountSubTypeName AS ExpenseType,
	ar.RegionName AS AllocationRegionName,
    ar.SubRegionName AS AllocationSubRegionName,
    ar.SubRegionName AS AllocationSubRegionFilterName,
    orr.RegionName AS OriginatingRegionName,
    orr.SubRegionName AS OriginatingSubRegionName,
    orr.SubRegionName AS OriginatingSubRegionFilterName,
	gac.MajorCategoryName AS MajorExpenseCategoryName,
	gac.MinorCategoryName AS MinorExpenseCategoryName,
	pf.PropertyFundType AS EntityType,
	pf.PropertyFundName AS EntityName,
	fd.FunctionalDepartmentName as FunctionalDepartmentName,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
	res.SourceName AS SourceName,
	
	--Month to date    
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossActual,0) ELSE ISNULL(MtdNetActual,0) END) AS MtdActual,
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossBudget,0) ELSE ISNULL(MtdNetBudget,0) END) AS MtdOriginalBudget,
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast 
		END,0) 
	END) 
	AS MtdReforecast,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast 
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast 
		END, 0) - ISNULL(MtdNetActual, 0) 
	END) 
	AS MtdVariance,
	
	--Year to date
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossActual,0) ELSE ISNULL(YtdNetActual,0) END) AS YtdActual,	
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossBudget,0) ELSE ISNULL(YtdNetBudget,0) END) AS YtdOriginalBudget,
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast 
		END,0) 
	END) 
	AS YtdReforecast,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast 
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) 
	AS YtdVariance,
	
	--Annual
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(AnnualGrossBudget,0) ELSE ISNULL(AnnualNetBudget,0) END) AS AnnualOriginalBudget,	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecast 
		END,0) 
	END) 
	AS AnnualReforecast,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @PreviousReforecastQuaterName = ''Q1'' THEN 
			AnnualGrossReforecastQ1 		
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @PreviousReforecastQuaterName = ''Q1'' THEN 
			AnnualNetReforecastQ1	
		END,0) 
	END) 
	AS AnnualReforecastQ1
	--Annual Estimated
	--SUM(CASE WHEN (@IsGross = 1) THEN 
	--	ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
	--		AnnualEstGrossBudget 
	--	ELSE 
	--		AnnualEstGrossReforecast 
	--	END,0) 
	--ELSE 
	--	ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
	--		AnnualEstNetBudget 
	--	ELSE 
	--		AnnualEstNetReforecast 
	--	END,0) 
	--END) 
	--AS AnnualEstimatedActual,	
	
	--SUM(CASE WHEN (@IsGross = 1) THEN 
	--	ISNULL(AnnualGrossBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
	--											AnnualEstGrossBudget 
	--										ELSE 
	--											AnnualEstGrossReforecast 
	--										END,0) 
	--	ELSE 
	--		ISNULL(AnnualNetBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
	--										AnnualEstNetBudget 
	--									ELSE 
	--										AnnualEstNetReforecast 
	--									END,0) 
	--	END) 
	--	AS AnnualEstimatedVariance
INTO
	#Output
FROM
	#BudgetOriginatorOwner res
		INNER JOIN AllocationRegion ar ON ar.AllocationRegionKey = res.AllocationRegionKey
		INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = res.OriginatingRegionKey
		INNER JOIN PropertyFund pf ON pf.PropertyFundKey = res.PropertyFundKey
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentKey = res.FunctionalDepartmentKey
		INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = res.GlAccountCategoryKey
GROUP BY
	gac.AccountSubTypeName,
	ar.RegionName,
    ar.SubRegionName, 
    orr.RegionName,
    orr.SubRegionName,
	gac.MajorCategoryName,
	gac.MinorCategoryName,
	pf.PropertyFundType,
	pf.PropertyFundName,
	fd.FunctionalDepartmentName,
	res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
	res.SourceName

--Output
SELECT
	ExpenseType,
	AllocationRegionName,
    AllocationSubRegionName,
    AllocationSubRegionFilterName,
    OriginatingRegionName,
    OriginatingSubRegionName,
    OriginatingSubRegionFilterName,
	MajorExpenseCategoryName,
	MinorExpenseCategoryName,
	EntityType,
	EntityName,
	FunctionalDepartmentName,
    EntryDate,
    [User],
    [Description],
    AdditionalDescription,
	SourceName,
	
	--Month to date    
	MtdActual,
	MtdOriginalBudget,
	MtdReforecast,
	MtdVariance,
	
	--Year to date
	YtdActual,	
	YtdOriginalBudget,
	YtdReforecast,
	YtdVariance,
	
	--Annual
	AnnualOriginalBudget,	
	AnnualReforecast,
	AnnualReforecastQ1
	
	--Annual Estimated
	--AnnualEstimatedActual,
	--AnnualEstimatedVariance
FROM
	#Output
WHERE
	--Month to date    
	MtdActual <> 0.00 OR
	MtdOriginalBudget <> 0.00 OR
	MtdReforecast <> 0.00 OR
	MtdVariance <> 0.00 OR
	
	--Year to date
	YtdActual <> 0.00 OR
	YtdOriginalBudget <> 0.00 OR
	YtdReforecast <> 0.00 OR
	YtdVariance <> 0.00 OR
	
	--Annual
	AnnualOriginalBudget <> 0.00 OR
	AnnualReforecast <> 0.00 OR
	AnnualReforecastQ1 <> 0.00 --OR

	--Annual Estimated
	--AnnualEstimatedActual <> 0.00 OR
	--AnnualEstimatedVariance <> 0.00


IF 	OBJECT_ID(''tempdb..#BudgetOriginatorOwner'') IS NOT NULL
    DROP TABLE #BudgetOriginatorOwner

IF 	OBJECT_ID(''tempdb..#Output'') IS NOT NULL
    DROP TABLE #Output

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginatorOwnerEntity]    Script Date: 08/05/2010 15:11:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOriginatorOwnerEntity]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [dbo].[stp_R_BudgetOriginatorOwnerEntity]
	@ReportExpensePeriod INT = NULL,
	@ReforecastQuaterName VARCHAR(10) = NULL, --''Q1'' or ''Q2'' or ''Q3''
	@PreviousReforecastQuaterName VARCHAR(10) =''Q1'',
	@DestinationCurrency VARCHAR(3) = NULL,
	@TranslationTypeName VARCHAR(50) = ''Global'',
	@IsGross bit = 1,
	@FunctionalDepartmentList TEXT = NULL,
	@ActivityTypeList TEXT = NULL,
	@EntityList TEXT = NULL,
	@MajorAccountCategoryList TEXT = NULL,
	@MinorAccountCategoryList TEXT = NULL,
	@AllocationRegionList TEXT = NULL,
	@AllocationSubRegionList TEXT = NULL,
	@OriginatingRegionList TEXT = NULL,
	@OriginatingSubRegionList TEXT = NULL
AS

/*
DECLARE @ReportExpensePeriod		AS INT,
        @DestinationCurrency		AS VARCHAR(3),
        @TranslationTypeName				VARCHAR(50)
				
SET @ReportExpensePeriod = 201011
SET @DestinationCurrency = ''USD''
SET @EntityList = ''Aldgate|Centrium (St Cathrine House/Pegasus)''
SET @TranslationTypeName = ''Global''

EXEC stp_R_BudgetOriginatorOwnerEntity
	@ReportExpensePeriod = 201011,
	@TranslationTypeName = ''Global'',
	@DestinationCurrency = ''USD'',

	@FunctionalDepartmentList = ''Information Technologies'',
	@AllocationRegionList = ''CHICAGO'',
	@EntityList = ''Aldgate|Centrium (St Cathrine House/Pegasus)''
*/
DECLARE

	@_ReportExpensePeriod INT = @ReportExpensePeriod,
	@_ReforecastQuaterName VARCHAR(10) = @ReforecastQuaterName,
	@_PreviousReforecastQuaterName VARCHAR(10) = @PreviousReforecastQuaterName,
	@_DestinationCurrency VARCHAR(3) = @DestinationCurrency,
	@_TranslationTypeName VARCHAR(50) = @TranslationTypeName,
	@_IsGross bit = @IsGross,
	@_FunctionalDepartmentList VARCHAR(8000) = @FunctionalDepartmentList,
	@_ActivityTypeList VARCHAR(8000) = @ActivityTypeList,
	@_EntityList VARCHAR(8000) = @EntityList,
	@_MajorAccountCategoryList VARCHAR(8000) = @MajorAccountCategoryList,
	@_MinorAccountCategoryList VARCHAR(8000) = @MinorAccountCategoryList,
	@_AllocationRegionList VARCHAR(8000) = @AllocationRegionList,
	@_AllocationSubRegionList VARCHAR(8000) = @AllocationSubRegionList,
	@_OriginatingRegionList VARCHAR(8000) = @OriginatingRegionList,
	@_OriginatingSubRegionList VARCHAR(8000) = @OriginatingSubRegionList

--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Variable defaults		*/
--------------------------------------------------------------------------

IF @ReportExpensePeriod IS NULL
	SET @ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + REPLACE(STR(MONTH(GETDATE()),2 ),'' '',''0'')AS INT)

IF @DestinationCurrency IS NULL
	SET @DestinationCurrency = ''USD''

IF 	@TranslationTypeName IS NULL
	SET @TranslationTypeName = ''Global''

DECLARE @CalendarYear AS INT
SET @CalendarYear = CAST(SUBSTRING(CAST(@ReportExpensePeriod AS VARCHAR(10)), 1, 4) AS INT)

-- let latest reforecast (it will be zero if there is no data for the reforecast)
IF @ReforecastQuaterName IS NULL
	SET @ReforecastQuaterName = (SELECT TOP 1 ReforecastQuarterName 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
										  ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
									ORDER BY ReforecastEffectivePeriod DESC)

DECLARE @ReforecastEffectivePeriod INT
SET @ReforecastEffectivePeriod = (SELECT TOP 1 ReforecastEffectivePeriod 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										  ReforecastQuarterName = @ReforecastQuaterName
									ORDER BY ReforecastEffectivePeriod)
									

IF @PreviousReforecastQuaterName IS NULL
		SET @PreviousReforecastQuaterName = (SELECT TOP 1 ReforecastQuarterName 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
										  ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
									ORDER BY ReforecastEffectivePeriod DESC)
									
DECLARE @PreviousReforecastEffectivePeriod INT																
SET @PreviousReforecastEffectivePeriod = (SELECT TOP 1 ReforecastEffectivePeriod  
									FROM dbo.Reforecast 
									WHERE ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										  ReforecastQuarterName = @PreviousReforecastQuaterName
									ORDER BY ReforecastEffectivePeriod)
									
--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Tables		*/
--------------------------------------------------------------------------
	
	CREATE TABLE	#EntityFilterTable	(PropertyFundKey Int NOT NULL)
	CREATE TABLE	#FunctionalDepartmentFilterTable	(FunctionalDepartmentKey Int NOT NULL)
	CREATE TABLE	#ActivityTypeFilterTable(ActivityTypeKey Int NOT NULL)
	CREATE TABLE	#AllocationRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#AllocationSubRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#MajorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#MinorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#OriginatingRegionFilterTable	(OriginatingRegionKey Int NOT NULL)
	CREATE TABLE	#OriginatingSubRegionFilterTable	(OriginatingRegionKey Int NOT NULL)	
		
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable	(PropertyFundKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable(ActivityTypeKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MajorAccountCategoryFilterTable(GlAccountCategoryKey)	
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MinorAccountCategoryFilterTable(GlAccountCategoryKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingRegionFilterTable	(OriginatingRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable	(OriginatingRegionKey)
	
IF (@EntityList IS NOT NULL)
	BEGIN
	Insert Into #EntityFilterTable
	Select pf.PropertyFundKey
	From dbo.Split(@_EntityList) t1
		INNER JOIN PropertyFund pf ON pf.PropertyFundName = t1.item
	
	END
	
IF (@FunctionalDepartmentList IS NOT NULL)
	BEGIN
	Insert Into #FunctionalDepartmentFilterTable
	Select fd.FunctionalDepartmentKey 
	From dbo.Split(@_FunctionalDepartmentList) t1
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentName = t1.item
	END

IF 	(@ActivityTypeList IS NOT NULL)
	BEGIN
    INSERT INTO #ActivityTypeFilterTable
    SELECT at.ActivityTypeKey 
    FROM dbo.Split(@_ActivityTypeList) t1
		INNER JOIN ActivityType at ON at.ActivityTypeName = t1.item
	END
	
IF (@AllocationRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationRegionFilterTable
	Select ar.AllocationRegionKey 
	From dbo.Split(@_AllocationRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.RegionName = t1.item
	END

IF (@AllocationSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationSubRegionFilterTable
	Select ar.AllocationRegionKey
	From dbo.Split(@_AllocationSubRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.SubRegionName = t1.item
	END

IF (@MajorAccountCategoryList IS NOT NULL)
	BEGIN
	Insert Into #MajorAccountCategoryFilterTable
	Select gl.GlAccountCategoryKey 
	From dbo.Split(@_MajorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MajorCategoryName = t1.item
	END
	
IF 	(@MinorAccountCategoryList IS NOT NULL)
	BEGIN
    INSERT INTO #MinorAccountCategoryFilterTable
    SELECT gl.GlAccountCategoryKey 
    FROM dbo.Split(@MinorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MinorCategoryName = t1.item
	END	

IF (@OriginatingRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingRegionFilterTable
	Select orr.OriginatingRegionKey 
	From dbo.Split(@_OriginatingRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.RegionName = t1.item
	END

IF (@OriginatingSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingSubRegionFilterTable
	Select orr.OriginatingRegionKey  
	From dbo.Split(@OriginatingSubRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.SubRegionName = t1.item
	END		
--------------------------------------------------------------------------
/*	COMMON END															*/
--------------------------------------------------------------------------
	

IF 	OBJECT_ID(''tempdb..#BudgetOriginatorOwnerEntity'') IS NOT NULL
    DROP TABLE #BudgetOriginatorOwnerEntity

CREATE TABLE #BudgetOriginatorOwnerEntity
(
    GlAccountCategoryKey		Int,
    AllocationRegionKey			Int,
    OriginatingRegionKey		Int,
    FunctionalDepartmentKey		Int,
    PropertyFundKey				INT,
	SourceName					VarChar(50),
	EntryDate					VARCHAR(10),
	[User]						NVARCHAR(20),
	[Description]				NVARCHAR(60),
	AdditionalDescription		NVARCHAR(4000),
	
	--Month to date	
	MtdGrossActual				MONEY,
	MtdGrossBudget				MONEY,
	MtdGrossReforecast			MONEY,
	MtdNetActual				MONEY,
	MtdNetBudget				MONEY,
	MtdNetReforecast			MONEY,
	
	--Year to date
	YtdGrossActual				MONEY,	
	YtdGrossBudget				MONEY, 
	YtdGrossReforecast			MONEY, 
	YtdNetActual				MONEY, 
	YtdNetBudget				MONEY, 
	YtdNetReforecast			MONEY, 

	--Annual	
	AnnualGrossBudget			MONEY,
	AnnualGrossReforecast		MONEY,
	AnnualGrossReforecastQ1		MONEY,
	AnnualNetBudget				MONEY,
	AnnualNetReforecast			MONEY,
	AnnualNetReforecastQ1		MONEY,

	--Annual estimated
	AnnualEstGrossBudget		MONEY,
	AnnualEstGrossReforecast	MONEY,
	AnnualEstNetBudget			MONEY,
	AnnualEstNetReforecast		MONEY
)

DECLARE @cmdString	Varchar(8000)

--Get actual information
SET @cmdString = (Select ''

INSERT INTO #BudgetOriginatorOwnerEntity
SELECT 
    gac.GlAccountCategoryKey,
    pa.AllocationRegionKey,
    pa.OriginatingRegionKey,
    pa.FunctionalDepartmentKey,
    pa.PropertyFundKey,
    s.SourceName,
    CONVERT(varchar(10),ISNULL(pa.EntryDate,''''''''), 101) as EntryDate,
    pa.[User],
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.Description ELSE '''''''' END as Description,
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.AdditionalDescription ELSE '''''''' END as AdditionalDescription,
    
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdGrossActual,
	NULL as MtdGrossBudget,
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdGrossReforecast,
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdNetActual,
	NULL as MtdNetBudget,
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) +  
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdNetReforecast,
	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdGrossActual,
	NULL as YtdGrossBudget,
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) +  
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as YtdGrossReforecast,
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdNetActual,
	NULL as YtdNetBudget,
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) +  
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as YtdNetReforecast,
	
	NULL as AnnualGrossBudget,
	SUM(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualGrossReforecast,
	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@PreviousReforecastEffectivePeriod,6,0) + 
                  /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
                  /*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
                  '' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualGrossReforecastQ1,

	NULL as AnnualNetBudget,
    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecast,
    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@PreviousReforecastEffectivePeriod,6,0) + 
                  /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
                  /*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
                  '' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ1,
	
	SUM(
        er.Rate *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pa.LocalActual
        ELSE 
			0
        END
	) as AnnualEstGrossBudget,
	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecast,

    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstNetReforecast
FROM
	ProfitabilityActual pa
	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pa.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pa.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pa.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pa.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pa.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pa.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pa.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pa.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')
    
    INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
    INNER JOIN Currency dc ON er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON c.CalendarKey = pa.CalendarKey
    INNER JOIN Source s ON s.SourceKey = pa.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pa.ReimbursableKey ''
    
    + CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pa.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pa.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pa.PropertyFundKey'' ELSE '''' END + ''

WHERE  1 = 1
    AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select t1.FunctionalDepartmentKey From #FunctionalDepartmentFilterTable t1)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select t1.ActivityTypeKey From #ActivityTypeFilterTable t1)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select t1.PropertyFundKey From #EntityFilterTable t1)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationRegionFilterTable t1)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationSubRegionFilterTable t1)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MajorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MinorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingRegionFilterTable t1)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingSubRegionFilterTable t1)'' END +
''
Group by
    gac.GlAccountCategoryKey,
    pa.AllocationRegionKey,
    pa.OriginatingRegionKey,
    pa.FunctionalDepartmentKey,
    pa.PropertyFundKey,
    s.SourceName,
	CONVERT(varchar(10),ISNULL(pa.EntryDate,''''''''), 101),
	pa.[User],
	CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.Description ELSE '''''''' END,
	CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.AdditionalDescription ELSE '''''''' END

'')

print @cmdString
EXEC (@cmdString)

-- Get budget information
SET @cmdString = (Select ''
INSERT INTO #BudgetOriginatorOwnerEntity
SELECT 
    gac.GlAccountCategoryKey,
    pb.AllocationRegionKey,
    pb.OriginatingRegionKey,
    pb.FunctionalDepartmentKey,
    pb.PropertyFundKey,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    
    NULL as MtdGrossActual,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as MtdGrossBudget,
	NULL as MtdGrossReforecast,
	
	NULL as MtdNetActual,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as MtdNetBudget,
	NULL as MtdNetReforecast,
	
	NULL as YtdGrossActual,	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as YtdGrossBudget, 
	NULL as YtdGrossReforecast, 
	
	NULL as YtdNetActual, 
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as YtdNetBudget, 
	NULL as YtdNetReforecast, 
	
	SUM(er.Rate * pb.LocalBudget) as AnnualGrossBudget,
	NULL as AnnualGrossReforecast,
	NULL as AnnualGrossReforecastQ1,

	SUM(er.Rate * r.MultiplicationFactor * pb.LocalBudget) as AnnualNetBudget,
	NULL as AnnualNetReforecast,
	NULL as AnnualNetReforecastQ1,

	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as AnnualEstGrossBudget,
	NULL as AnnualEstGrossReforecast,

	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
	NULL as AnnualEstNetReforecast
FROM
	ProfitabilityBudget pb
	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pb.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pb.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pb.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pb.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pb.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pb.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pb.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pb.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

	INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pb.CalendarKey
    INNER JOIN Source s ON s.SourceKey = pb.SourceKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pb.ReimbursableKey ''
        
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pb.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey'' ELSE '''' END + ''
	
WHERE  1 = 1 
    AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
 	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
 	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
	Group By
    gac.GlAccountCategoryKey,
    pb.AllocationRegionKey,
    pb.OriginatingRegionKey,
    pb.FunctionalDepartmentKey,
    pb.PropertyFundKey,
    s.SourceName
'')
	
print @cmdString
EXEC (@cmdString)

-- Get reforecast information
SET @cmdString = (Select ''
INSERT INTO #BudgetOriginatorOwnerEntity
SELECT 
    gac.GlAccountCategoryKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.FunctionalDepartmentKey,
    pr.PropertyFundKey,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecast,
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecast,
	
	NULL as YtdGrossActual,	
	NULL as YtdGrossBudget, 
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecast, 
	
	NULL as YtdNetActual, 
	NULL as YtdNetBudget, 
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecast, 
	
	NULL as AnnualGrossBudget,'' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecast,
    NULL as AnnualGrossReforecastQ1,

	NULL as AnnualNetBudget,'' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecast,
    NULL as AnnualNetReforecastQ1,

	NULL as AnnualEstGrossBudget,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriod,6,0) + '' IN (201003,201006)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstGrossReforecast,

	NULL as AnnualEstNetBudget,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriod,6,0) + '' IN (201003,201006)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstNetReforecast
FROM
	ProfitabilityReforecast pr
	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

	INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pr.CalendarKey
    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
    INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pr.ReimbursableKey ''
        
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + ''
	
WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND ref.ReforecastEffectivePeriod = '' + STR(@ReforecastEffectivePeriod,10,0) + ''
 	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
 	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
	Group By
    gac.GlAccountCategoryKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.FunctionalDepartmentKey,
    pr.PropertyFundKey,
    s.SourceName
'')
	
print @cmdString
EXEC (@cmdString)

-- Get reforecastQ1 information
SET @cmdString = (Select ''
INSERT INTO #BudgetOriginatorOwnerEntity
SELECT 
    gac.GlAccountCategoryKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.FunctionalDepartmentKey,
    pr.PropertyFundKey,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    
	NULL as MtdGrossActual,
      NULL as MtdGrossBudget,
      NULL as MtdGrossReforecast,
      
      NULL as MtdNetActual,
      NULL as MtdNetBudget,
	  NULL as MtdNetReforecast,
      
      NULL as YtdGrossActual, 
      NULL as YtdGrossBudget, 
      NULL as YtdGrossReforecast, 
      
      NULL as YtdNetActual, 
      NULL as YtdNetBudget, 
      NULL as YtdNetReforecast, 
      
      NULL as AnnualGrossBudget,
      NULL as AnnualGrossReforecast,
      SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ1,
      

      NULL as AnnualNetBudget,
      NULL as AnnualNetReforecast,
      SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecastQ1,
      
      NULL as AnnualEstGrossBudget,
      NULL as AnnualEstGrossReforecast,

      NULL as AnnualEstNetBudget,
      NULL as AnnualEstNetReforecast
FROM
	ProfitabilityReforecast pr
	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

	INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pr.CalendarKey
    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
    INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pr.ReimbursableKey ''
        
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + ''
	
WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND ref.ReforecastEffectivePeriod = '' + STR(@PreviousReforecastEffectivePeriod,10,0) + ''
 	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
 	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
	Group By
    gac.GlAccountCategoryKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.FunctionalDepartmentKey,
    pr.PropertyFundKey,
    s.SourceName
'')
	
print @cmdString
EXEC (@cmdString)

--Entity Mode
SELECT 
    gac.AccountSubTypeName as ExpenseType,
    ar.RegionName AS AllocationRegionName,
    ar.SubRegionName AS AllocationSubRegionName,
    ar.SubRegionName AS AllocationSubRegionFilterName,
    orr.RegionName AS OriginatingRegionName,
    orr.SubRegionName AS OriginatingSubRegionName,
    orr.SubRegionName AS OriginatingSubRegionFilterName,
    --NB!!!!!!!
    --The roll up to payroll is very sensitive information. It is crutial that information regarding payroll not 
    --get communicated to TS employees.
    CASE WHEN (gac.MajorCategoryName = ''Salaries/Taxes/Benefits'') THEN ''Payroll'' ELSE fd.FunctionalDepartmentName END AS FunctionalDepartmentName,
    gac.MajorCategoryName AS MajorExpenseCategoryName,
    gac.MinorCategoryName AS MinorExpenseCategoryName,
    pf.PropertyFundType AS EntityType,
    pf.PropertyFundName AS EntityName,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
	res.SourceName AS SourceName,
	--Month to date    
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossActual,0) ELSE ISNULL(MtdNetActual,0) END) AS MtdActual,
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossBudget,0) ELSE ISNULL(MtdNetBudget,0) END) AS MtdOriginalBudget,
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast 
		END,0) 
	END) AS MtdReforecast,
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast 
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast 
		END, 0) - ISNULL(MtdNetActual, 0) 
	END) AS MtdVariance,
	--Year to date
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossActual,0) ELSE ISNULL(YtdNetActual,0) END) AS YtdActual,	
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossBudget,0) ELSE ISNULL(YtdNetBudget,0) END) AS YtdOriginalBudget,
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast 
		END,0) 
	END) AS YtdReforecast,
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast 
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) AS YtdVariance,
	--Annual
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(AnnualGrossBudget,0) ELSE ISNULL(AnnualNetBudget,0) END) AS AnnualOriginalBudget,	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecast 
		END,0) 
	END) AS AnnualReforecast,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @PreviousReforecastQuaterName = ''Q1'' THEN 
			AnnualGrossReforecastQ1 		
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @PreviousReforecastQuaterName = ''Q1'' THEN 
			AnnualNetReforecastQ1	
		END,0) 
	END) 
	AS AnnualReforecastQ1
	--Annual Estimated
	--SUM(CASE WHEN (@IsGross = 1) THEN 
	--	ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
	--		AnnualEstGrossBudget 
	--	ELSE 
	--		AnnualEstGrossReforecast 
	--	END,0) 
	--ELSE 
	--	ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
	--		AnnualEstNetBudget 
	--	ELSE 
	--		AnnualEstNetReforecast 
	--	END,0) 
	--END) AS AnnualEstimatedActual,	
	--SUM(CASE WHEN (@IsGross = 1) THEN 
	--	ISNULL(AnnualGrossBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
	--											AnnualEstGrossBudget 
	--										ELSE 
	--											AnnualEstGrossReforecast 
	--										END,0) 
	--	ELSE 
	--		ISNULL(AnnualNetBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
	--										AnnualEstNetBudget 
	--									ELSE 
	--										AnnualEstNetReforecast 
	--									END,0) 
	--	END) AS AnnualEstimatedVariance
INTO
	#Output
FROM
	#BudgetOriginatorOwnerEntity res
		INNER JOIN AllocationRegion ar ON ar.AllocationRegionKey = res.AllocationRegionKey
		INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = res.OriginatingRegionKey
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentKey = res.FunctionalDepartmentKey
		INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = res.GlAccountCategoryKey
		INNER JOIN PropertyFund pf ON pf.PropertyFundKey = res.PropertyFundKey
GROUP BY
    gac.AccountSubTypeName,
    ar.RegionName,
    ar.SubRegionName,
    orr.RegionName,
    orr.SubRegionName,
    --NB!!!!!!!
    --The roll up to payroll is very sensitive information. It is crutial that information regarding payroll not 
    --get communicated to TS employees.
    CASE WHEN (gac.MajorCategoryName = ''Salaries/Taxes/Benefits'') THEN ''Payroll'' ELSE fd.FunctionalDepartmentName END,
    gac.MajorCategoryName,
    gac.MinorCategoryName,
    pf.PropertyFundType,
    pf.PropertyFundName,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
    res.SourceName

--Output
SELECT
    ExpenseType,
    AllocationRegionName,
    AllocationSubRegionName,
    AllocationSubRegionFilterName,
    OriginatingRegionName,
    OriginatingSubRegionName,
    OriginatingSubRegionFilterName,
    FunctionalDepartmentName,
    MajorExpenseCategoryName,
    MinorExpenseCategoryName,
    EntityType,
    EntityName,
    EntryDate,
    [User],
    [Description],
    AdditionalDescription,
	SourceName,
	--Month to date    
	MtdActual,
	MtdOriginalBudget,
	MtdReforecast,
	MtdVariance,
	--Year to date
	YtdActual,
	YtdOriginalBudget,
	YtdReforecast,
	YtdVariance,
	--Annual
	AnnualOriginalBudget,
	AnnualReforecast,
	AnnualReforecastQ1
	--Annual Estimated
	--AnnualEstimatedActual,
	--AnnualEstimatedVariance
FROM
	#Output
WHERE
	--Month to date    
	MtdActual <> 0.00 OR
	MtdOriginalBudget <> 0.00 OR
	MtdReforecast <> 0.00 OR
	MtdVariance <> 0.00 OR
	--Year to date
	YtdActual <> 0.00 OR
	YtdOriginalBudget <> 0.00 OR
	YtdReforecast <> 0.00 OR
	YtdVariance <> 0.00 OR
	--Annual
	AnnualOriginalBudget <> 0.00 OR
	AnnualReforecast <> 0.00 OR
	AnnualReforecastQ1 <> 0.00 --OR
	--Annual Estimated
	--AnnualEstimatedActual <> 0.00 OR
	--AnnualEstimatedVariance <> 0.00

IF 	OBJECT_ID(''tempdb..#BudgetOriginatorOwnerEntity'') IS NOT NULL
    DROP TABLE #BudgetOriginatorOwnerEntity

IF 	OBJECT_ID(''tempdb..#Output'') IS NOT NULL
    DROP TABLE #Output

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginatorJobCodeDetail]    Script Date: 08/05/2010 15:11:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOriginatorJobCodeDetail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE [dbo].[stp_R_BudgetOriginatorJobCodeDetail]
	@ReportExpensePeriod INT = NULL,
	@ReforecastQuaterName VARCHAR(10) = NULL, --''Q1'' or ''Q2'' or ''Q3''
	@PreviousReforecastQuaterName VARCHAR(10) =''Q1'',
	@DestinationCurrency VARCHAR(3) = NULL,
	@TranslationTypeName VARCHAR(50) = ''Global'',
	@IsGross bit = 1,
	@FunctionalDepartmentList TEXT = NULL,
	@ActivityTypeList TEXT = NULL,
	@EntityList TEXT = NULL,
	@MajorAccountCategoryList TEXT = NULL,
	@MinorAccountCategoryList TEXT = NULL,
	@AllocationRegionList TEXT = NULL,
	@AllocationSubRegionList TEXT = NULL,
	@OriginatingRegionList TEXT = NULL,
	@OriginatingSubRegionList TEXT = NULL
AS


/*
DECLARE @ReportExpensePeriod   AS INT,
        @FunctionalDepartment  AS VARCHAR(50),
        @DestinationCurrency   AS VARCHAR(3),
        @AllocationRegion      AS VARCHAR(50),
        @TranslationTypeName         VARCHAR(50)
				
		
SET @ReportExpensePeriod = 201011
SET @FunctionalDepartment = ''Information Technologies''
SET @DestinationCurrency = ''USD''
SET @AllocationRegion = ''CHICAGO''
SET @EntityList = ''Aldgate|Centrium (St Cathrine House/Pegasus)''
SET @TranslationTypeName = ''Global''


EXEC stp_R_BudgetOriginatorJobCodeDetail1
	@ReportExpensePeriod = 201011,
	@TranslationTypeName = ''Global'',
	@DestinationCurrency = ''USD'',

	@FunctionalDepartmentList = ''Information Technologies'',
	@AllocationRegionList = ''CHICAGO'',
	@EntityList = ''Aldgate|Centrium (St Cathrine House/Pegasus)''
*/
DECLARE

	@_ReportExpensePeriod INT = @ReportExpensePeriod,
	@_ReforecastQuaterName VARCHAR(10) = @ReforecastQuaterName,
	@_PreviousReforecastQuaterName VARCHAR(10) = @PreviousReforecastQuaterName,
	@_DestinationCurrency VARCHAR(3) = @DestinationCurrency,
	@_TranslationTypeName VARCHAR(50) = @TranslationTypeName,
	@_IsGross bit = @IsGross,
	@_FunctionalDepartmentList VARCHAR(8000) = @FunctionalDepartmentList,
	@_ActivityTypeList VARCHAR(8000) = @ActivityTypeList,
	@_EntityList VARCHAR(8000) = @EntityList,
	@_MajorAccountCategoryList VARCHAR(8000) = @MajorAccountCategoryList,
	@_MinorAccountCategoryList VARCHAR(8000) = @MinorAccountCategoryList,
	@_AllocationRegionList VARCHAR(8000) = @AllocationRegionList,
	@_AllocationSubRegionList VARCHAR(8000) = @AllocationSubRegionList,
	@_OriginatingRegionList VARCHAR(8000) = @OriginatingRegionList,
	@_OriginatingSubRegionList VARCHAR(8000) = @OriginatingSubRegionList
--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Variable defaults		*/
--------------------------------------------------------------------------

IF @ReportExpensePeriod IS NULL
	SET @ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + REPLACE(STR(MONTH(GETDATE()),2 ),'' '',''0'')AS INT)

IF @DestinationCurrency IS NULL
	SET @DestinationCurrency = ''USD''

IF 	@TranslationTypeName IS NULL
	SET @TranslationTypeName = ''Global''

	DECLARE @CalendarYear AS INT
	SET @CalendarYear = CAST(SUBSTRING(CAST(@ReportExpensePeriod AS VARCHAR(10)), 1, 4) AS INT)				

-- let latest reforecast (it will be zero if there is no data for the reforecast)
IF @ReforecastQuaterName IS NULL
	SET @ReforecastQuaterName = (SELECT TOP 1 ReforecastQuarterName 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
										  ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
									ORDER BY ReforecastEffectivePeriod DESC)

DECLARE @ReforecastEffectivePeriod INT
SET @ReforecastEffectivePeriod = (SELECT TOP 1 ReforecastEffectivePeriod 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										  ReforecastQuarterName = @ReforecastQuaterName
									ORDER BY ReforecastEffectivePeriod)
									
IF @PreviousReforecastQuaterName IS NULL
		SET @PreviousReforecastQuaterName = (SELECT TOP 1 ReforecastQuarterName 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
										  ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
									ORDER BY ReforecastEffectivePeriod DESC)
									
DECLARE @PreviousReforecastEffectivePeriod INT																
SET @PreviousReforecastEffectivePeriod = (SELECT TOP 1 ReforecastEffectivePeriod  
									FROM dbo.Reforecast 
									WHERE ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										  ReforecastQuarterName = @PreviousReforecastQuaterName
									ORDER BY ReforecastEffectivePeriod)

--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Tables		*/
--------------------------------------------------------------------------
	
	CREATE TABLE	#EntityFilterTable	(PropertyFundKey Int NOT NULL)
	CREATE TABLE	#FunctionalDepartmentFilterTable	(FunctionalDepartmentKey Int NOT NULL)
	CREATE TABLE	#ActivityTypeFilterTable(ActivityTypeKey Int NOT NULL)
	CREATE TABLE	#AllocationRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#AllocationSubRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#MajorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#MinorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#OriginatingRegionFilterTable	(OriginatingRegionKey Int NOT NULL)
	CREATE TABLE	#OriginatingSubRegionFilterTable	(OriginatingRegionKey Int NOT NULL)	
		
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable	(PropertyFundKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable(ActivityTypeKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MajorAccountCategoryFilterTable(GlAccountCategoryKey)	
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MinorAccountCategoryFilterTable(GlAccountCategoryKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingRegionFilterTable	(OriginatingRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable	(OriginatingRegionKey)
	
IF (@EntityList IS NOT NULL)
	BEGIN
	Insert Into #EntityFilterTable
	Select pf.PropertyFundKey
	From dbo.Split(@_EntityList) t1
		INNER JOIN PropertyFund pf ON pf.PropertyFundName = t1.item
	
	END
	
IF (@FunctionalDepartmentList IS NOT NULL)
	BEGIN
	Insert Into #FunctionalDepartmentFilterTable
	Select fd.FunctionalDepartmentKey 
	From dbo.Split(@_FunctionalDepartmentList) t1
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentName = t1.item
	END

IF 	(@ActivityTypeList IS NOT NULL)
	BEGIN
    INSERT INTO #ActivityTypeFilterTable
    SELECT at.ActivityTypeKey 
    FROM dbo.Split(@_ActivityTypeList) t1
		INNER JOIN ActivityType at ON at.ActivityTypeName = t1.item
	END
	
IF (@AllocationRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationRegionFilterTable
	Select ar.AllocationRegionKey 
	From dbo.Split(@_AllocationRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.RegionName = t1.item
	END

IF (@AllocationSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationSubRegionFilterTable
	Select ar.AllocationRegionKey
	From dbo.Split(@_AllocationSubRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.SubRegionName = t1.item
	END

IF (@MajorAccountCategoryList IS NOT NULL)
	BEGIN
	Insert Into #MajorAccountCategoryFilterTable
	Select gl.GlAccountCategoryKey 
	From dbo.Split(@_MajorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MajorCategoryName = t1.item
	END
	
IF 	(@MinorAccountCategoryList IS NOT NULL)
	BEGIN
    INSERT INTO #MinorAccountCategoryFilterTable
    SELECT gl.GlAccountCategoryKey 
    FROM dbo.Split(@MinorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MinorCategoryName = t1.item
	END	

IF (@OriginatingRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingRegionFilterTable
	Select orr.OriginatingRegionKey 
	From dbo.Split(@_OriginatingRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.RegionName = t1.item
	END

IF (@OriginatingSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingSubRegionFilterTable
	Select orr.OriginatingRegionKey  
	From dbo.Split(@OriginatingSubRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.SubRegionName = t1.item
	END		
--------------------------------------------------------------------------
/*	COMMON END															*/
--------------------------------------------------------------------------
	

IF 	OBJECT_ID(''tempdb..#BudgetOriginator'') IS NOT NULL
    DROP TABLE #BudgetOriginator

CREATE TABLE #BudgetOriginator
(
	GlAccountCategoryKey		INT,
    AllocationRegionKey			INT,
    OriginatingRegionKey		INT,
    FunctionalDepartmentKey		INT,
    PropertyFundKey				INT,
	CalendarPeriod				INT,
	SourceName					VARCHAR(50),
	EntryDate					VARCHAR(10),
	[User]						NVARCHAR(20),
	[Description]				NVARCHAR(60),
	AdditionalDescription		NVARCHAR(4000),

	--Month to date	
	MtdGrossActual				MONEY,
	MtdGrossBudget				MONEY,
	MtdGrossReforecast			MONEY,
	MtdNetActual				MONEY,
	MtdNetBudget				MONEY,
	MtdNetReforecast			MONEY,
	
	--Year to date
	YtdGrossActual				MONEY,	
	YtdGrossBudget				MONEY, 
	YtdGrossReforecast			MONEY, 
	YtdNetActual				MONEY, 
	YtdNetBudget				MONEY, 
	YtdNetReforecast			MONEY, 

	--Annual	
	AnnualGrossBudget			MONEY,
	AnnualGrossReforecast		MONEY,
	AnnualGrossReforecastQ1		MONEY,
	AnnualNetBudget				MONEY,
	AnnualNetReforecast			MONEY,
	AnnualNetReforecastQ1		MONEY,

	--Annual estimated
	AnnualEstGrossBudget		MONEY,
	AnnualEstGrossReforecast	MONEY,
	AnnualEstNetBudget			MONEY,
	AnnualEstNetReforecast		MONEY
)
DECLARE @cmdString Varchar(8000)

-- Get actual information
SET @cmdString = (Select ''
INSERT INTO #BudgetOriginator
SELECT 
	gac.GlAccountCategoryKey,
    pa.AllocationRegionKey,
    pa.OriginatingRegionKey,
    pa.FunctionalDepartmentKey,
    pa.PropertyFundKey,
    c.CalendarPeriod,
    s.SourceName,
    CONVERT(varchar(10),ISNULL(pa.EntryDate,''''''''), 101) as EntryDate,
    pa.[User],
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.Description ELSE '''''''' END as Description,
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.AdditionalDescription ELSE '''''''' END as AdditionalDescription,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdGrossActual,
	NULL as MtdGrossBudget,
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + 
				'' AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdGrossReforecast,
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdNetActual,
	NULL as MtdNetBudget,
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + 
		'' AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdNetReforecast,
	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdGrossActual,
	NULL as YtdGrossBudget,
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			'' AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
		) as YtdGrossReforecast,
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdNetActual,
	NULL as YtdNetBudget,
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
		) as YtdNetReforecast,
	
	NULL as AnnualGrossBudget,
	SUM(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualGrossReforecast,
	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
				 AND c.CalendarPeriod < '' + STR(@PreviousReforecastEffectivePeriod,6,0) + 
                  /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
                  /*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
            '' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualGrossReforecastQ1,

	NULL as AnnualNetBudget,
    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecast,
    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@PreviousReforecastEffectivePeriod,6,0) + 
                  /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
                  /*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
                  '' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ1,
	
	SUM(
        er.Rate *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pa.LocalActual
        ELSE 
			0
        END
	) as AnnualEstGrossBudget,
	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecast,

    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstNetReforecast

FROM
	ProfitabilityActual pa

	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pa.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pa.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pa.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pa.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pa.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pa.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pa.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pa.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')
			
    INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
	INNER JOIN Currency dc ON er.DestinationCurrencyKey = dc.CurrencyKey
	INNER JOIN Calendar c ON c.CalendarKey = pa.CalendarKey
	INNER JOIN Source s ON s.SourceKey = pa.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pa.ReimbursableKey ''

    + CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pa.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pa.ActivityTypeKey'' ELSE '''' END +
    + CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pa.PropertyFundKey'' ELSE '''' END + ''

WHERE  1 = 1
	AND c.CalendarYear = '' + STR(@CalendarYear,4,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select t1.FunctionalDepartmentKey From #FunctionalDepartmentFilterTable t1)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select t1.ActivityTypeKey From #ActivityTypeFilterTable t1)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select t1.PropertyFundKey From #EntityFilterTable t1)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationRegionFilterTable t1)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationSubRegionFilterTable t1)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MajorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MinorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingRegionFilterTable t1)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingSubRegionFilterTable t1)'' END +
''
	
	Group By
			gac.GlAccountCategoryKey,
			pa.AllocationRegionKey,
			pa.OriginatingRegionKey,
			pa.FunctionalDepartmentKey,
			pa.PropertyFundKey,
			c.CalendarPeriod,
			s.SourceName,
			CONVERT(varchar(10),ISNULL(pa.EntryDate,''''''''), 101),
			pa.[User],
			CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.Description ELSE '''''''' END,
			CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.AdditionalDescription ELSE '''''''' END
'')

print @cmdString
EXEC (@cmdString)

-- Get budget information
SET @cmdString = (Select ''
INSERT INTO #BudgetOriginator
SELECT 
	gac.GlAccountCategoryKey,
    pb.AllocationRegionKey,
    pb.OriginatingRegionKey,
    pb.FunctionalDepartmentKey,
    pb.PropertyFundKey,
    c.CalendarPeriod,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    
    NULL as MtdGrossActual,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as MtdGrossBudget,
	NULL as MtdGrossReforecast,
	
	NULL as MtdNetActual,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as MtdNetBudget,
	NULL as MtdNetReforecast,
	
	NULL as YtdGrossActual,	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as YtdGrossBudget, 
	NULL as YtdGrossReforecast, 
	
	NULL as YtdNetActual, 
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as YtdNetBudget, 
	NULL as YtdNetReforecast, 
	
	SUM(er.Rate * pb.LocalBudget) as AnnualGrossBudget,
	NULL as AnnualGrossReforecast,
	NULL as AnnualGrossReforecastQ1,

	SUM(er.Rate * r.MultiplicationFactor * pb.LocalBudget) as AnnualNetBudget,
	NULL as AnnualNetReforecast,
	NULL as AnnualNetReforecastQ1,

	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as AnnualEstGrossBudget,
	NULL as AnnualEstGrossReforecast,

	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
	NULL as AnnualEstNetReforecast
    
FROM
	ProfitabilityBudget pb 
	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pb.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pb.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pb.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pb.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pb.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pb.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pb.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pb.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

	INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey
	INNER JOIN Currency dc ON er.DestinationCurrencyKey = dc.CurrencyKey
	INNER JOIN Calendar c ON c.CalendarKey = pb.CalendarKey
	INNER JOIN Source s ON s.SourceKey = pb.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pb.ReimbursableKey ''
    			
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pb.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey'' ELSE '''' END + ''
    
WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,4,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
Group by
    gac.GlAccountCategoryKey,
    pb.AllocationRegionKey,
    pb.OriginatingRegionKey,
    pb.FunctionalDepartmentKey,
    pb.PropertyFundKey,
    c.CalendarPeriod,
    s.SourceName
	
'')

print @cmdString
EXEC (@cmdString)

-- Get reforecast information
SET @cmdString = (Select ''
INSERT INTO #BudgetOriginator
SELECT 
	gac.GlAccountCategoryKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.FunctionalDepartmentKey,
    pr.PropertyFundKey,
    c.CalendarPeriod,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecast,
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecast,
	
	NULL as YtdGrossActual,	
	NULL as YtdGrossBudget, 
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecast, 
	
	NULL as YtdNetActual, 
	NULL as YtdNetBudget, 
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecast, 
	
	NULL as AnnualGrossBudget,
	SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecast,
	NULL as AnnualGrossReforecastQ1,

	NULL as AnnualNetBudget,
	SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecast,
	NULL as AnnualNetReforecastQ1,

	NULL as AnnualEstGrossBudget,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriod,6,0) + '' IN (201003,201006)
					)
				 ) THEN 
			pr.LocalReforecast
		ELSE
			0
		END
	) as AnnualEstGrossReforecast,

	NULL as AnnualEstNetBudget,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriod,6,0) + '' IN (201003,201006)
					)
				 ) THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstNetReforecast
    
FROM
	ProfitabilityReforecast pr 
	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

	INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
	INNER JOIN Currency dc ON er.DestinationCurrencyKey = dc.CurrencyKey
	INNER JOIN Calendar c ON c.CalendarKey = pr.CalendarKey
	INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
	INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey ''
    			
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + ''
    
WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,4,0) + ''
	AND ref.ReforecastEffectivePeriod = '' + STR(@ReforecastEffectivePeriod,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
Group by
    gac.GlAccountCategoryKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.FunctionalDepartmentKey,
    pr.PropertyFundKey,
    c.CalendarPeriod,
    s.SourceName
	
'')

print @cmdString
EXEC (@cmdString)

-- Get reforecastQ1 information
SET @cmdString = (Select ''
INSERT INTO #BudgetOriginator
SELECT 
      gac.GlAccountCategoryKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.FunctionalDepartmentKey,
    pr.PropertyFundKey,
    c.CalendarPeriod,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    
      NULL as MtdGrossActual,
      NULL as MtdGrossBudget,
      NULL as MtdGrossReforecast,
      
      NULL as MtdNetActual,
      NULL as MtdNetBudget,
	  NULL as MtdNetReforecast,
      
      NULL as YtdGrossActual, 
      NULL as YtdGrossBudget, 
      NULL as YtdGrossReforecast, 
      
      NULL as YtdNetActual, 
      NULL as YtdNetBudget, 
      NULL as YtdNetReforecast, 
      
      NULL as AnnualGrossBudget,
      NULL as AnnualGrossReforecast,
      SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ1,
      

      NULL as AnnualNetBudget,
      NULL as AnnualNetReforecast,
      SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecastQ1,
      
      NULL as AnnualEstGrossBudget,
      NULL as AnnualEstGrossReforecast,

      NULL as AnnualEstNetBudget,
      NULL as AnnualEstNetReforecast
    
FROM
      ProfitabilityReforecast pr 
      
      INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
                  WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
                  WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
                  WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
                  WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
                  WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
                  WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
                  WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
                  WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
                  ELSE ''break:not valid hierarchyname'' END + ''
                  AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

      INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
      INNER JOIN Currency dc ON er.DestinationCurrencyKey = dc.CurrencyKey
      INNER JOIN Calendar c ON c.CalendarKey = pr.CalendarKey
      INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
      INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey ''
                  
      + CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
      + CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + ''
    
WHERE  1 = 1 
      AND c.CalendarYear = '' + STR(@CalendarYear,4,0) + ''
      AND ref.ReforecastEffectivePeriod = '' + STR(@PreviousReforecastEffectivePeriod,10,0) + ''
      AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
      AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
Group by
    gac.GlAccountCategoryKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.FunctionalDepartmentKey,
    pr.PropertyFundKey,
    c.CalendarPeriod,
    s.SourceName      
'')

print @cmdString
EXEC (@cmdString)
    
SELECT 
	gac.AccountSubTypeName ExpenseType,
    ar.RegionName AS AllocationRegionName,
    ar.SubRegionName AS AllocationSubRegionName,
    orr.RegionName AS OriginatingRegionName,
    orr.SubRegionName AS OriginatingSubRegionName,
    fd.FunctionalDepartmentName AS FunctionalDepartmentName,
    fd.SubFunctionalDepartmentName AS JobCode,
    gac.MajorCategoryName AS MajorExpenseCategoryName,
    gac.MinorCategoryName AS MinorExpenseCategoryName,
    pf.PropertyFundType AS EntityType,
    pf.PropertyFundName AS EntityName,
    res.CalendarPeriod AS ExpensePeriod,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
    res.SourceName AS SourceName,
	--Month to date    
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossActual,0) ELSE ISNULL(MtdNetActual,0) END) AS MtdActual,
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossBudget,0) ELSE ISNULL(MtdNetBudget,0) END) AS MtdOriginalBudget,
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast 
		END,0) 
	END) 
	AS MtdReforecast,
		
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast 
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast 
		END, 0) - ISNULL(MtdNetActual, 0) 
	END) 
	AS MtdVariance,
		
	--Year to date
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossActual,0) ELSE ISNULL(YtdNetActual,0) END) AS YtdActual,	
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossBudget,0) ELSE ISNULL(YtdNetBudget,0) END) AS YtdOriginalBudget,
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast 
		END,0) 
	END) 
	AS YtdReforecast,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast 
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) 
	AS YtdVariance,
	
	--Annual
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(AnnualGrossBudget,0) ELSE ISNULL(AnnualNetBudget,0) END) AS AnnualOriginalBudget,	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecast 
		END,0) 
	END) 
	AS AnnualReforecast,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @PreviousReforecastQuaterName = ''Q1'' THEN 
			AnnualGrossReforecastQ1 		
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @PreviousReforecastQuaterName = ''Q1'' THEN 
			AnnualNetReforecastQ1	
		END,0) 
	END) 
	AS AnnualReforecastQ1
	
	--Annual Estimated
	--SUM(CASE WHEN (@IsGross = 1) THEN 
	--	ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
	--		AnnualEstGrossBudget 
	--	ELSE 
	--		AnnualEstGrossReforecast 
	--	END,0) 
	--ELSE 
	--	ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
	--		AnnualEstNetBudget 
	--	ELSE 
	--		AnnualEstNetReforecast 
	--	END,0) 
	--END) 
	--AS AnnualEstimatedActual,	
	
	--SUM(CASE WHEN (@IsGross = 1) THEN 
	--	ISNULL(AnnualGrossBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
	--											AnnualEstGrossBudget 
	--										ELSE 
	--											AnnualEstGrossReforecast 
	--										END,0) 
	--	ELSE 
	--		ISNULL(AnnualNetBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
	--										AnnualEstNetBudget 
	--									ELSE 
	--										AnnualEstNetReforecast 
	--									END,0) 
	--	END) 
	--	AS AnnualEstimatedVariance
INTO
	#Output
FROM
	#BudgetOriginator res
		INNER JOIN AllocationRegion ar ON ar.AllocationRegionKey = res.AllocationRegionKey
		INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = res.OriginatingRegionKey
		INNER JOIN PropertyFund pf ON pf.PropertyFundKey = res.PropertyFundKey
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentKey = res.FunctionalDepartmentKey
		INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = res.GlAccountCategoryKey 
GROUP BY
	gac.AccountSubTypeName,
    ar.RegionName,
    ar.SubRegionName,
    orr.RegionName,
    orr.SubRegionName,
    fd.FunctionalDepartmentName,
    fd.SubFunctionalDepartmentName,
    gac.MajorCategoryName,
    gac.MinorCategoryName,
    pf.PropertyFundType,
    pf.PropertyFundName,
    res.CalendarPeriod,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
    res.SourceName
	
--Output
SELECT
	ExpenseType,
    AllocationRegionName,
    AllocationSubRegionName,
    OriginatingRegionName,
    OriginatingSubRegionName,
    FunctionalDepartmentName,
    JobCode,
    MajorExpenseCategoryName,
    MinorExpenseCategoryName,
    EntityType,
    EntityName,
    ExpensePeriod,
    EntryDate,
    [User],
    [Description],
    AdditionalDescription,
    SourceName,
	--Month to date    
	MtdActual,
	MtdOriginalBudget,
	MtdReforecast,
	MtdVariance,
		
	--Year to date
	YtdActual,	
	YtdOriginalBudget,
	YtdReforecast,
	YtdVariance,
	
	--Annual
	AnnualOriginalBudget,	
	AnnualReforecast,
	AnnualReforecastQ1
	
	--Annual Estimated
	--AnnualEstimatedActual,	
	--AnnualEstimatedVariance
FROM
	#Output
WHERE
	--Month to date    
	MtdActual <> 0.00 OR
	MtdOriginalBudget <> 0.00 OR
	MtdReforecast <> 0.00 OR
	MtdVariance <> 0.00 OR
		
	--Year to date
	YtdActual <> 0.00 OR	
	YtdOriginalBudget <> 0.00 OR
	YtdReforecast <> 0.00 OR
	YtdVariance <> 0.00 OR
	
	--Annual
	AnnualOriginalBudget <> 0.00 OR	
	AnnualReforecast <> 0.00 OR
	AnnualReforecastQ1 <> 0.00 --OR
	
	--Annual Estimated
	--AnnualEstimatedActual <> 0.00 OR	
	--AnnualEstimatedVariance <> 0.00
	
IF OBJECT_ID(''tempdb..#BudgetOriginator'') IS NOT NULL
    DROP TABLE #BudgetOriginator

IF 	OBJECT_ID(''tempdb..#Output'') IS NOT NULL
    DROP TABLE #Output

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_R_Profitability]    Script Date: 08/05/2010 15:11:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_Profitability]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE [dbo].[stp_R_Profitability]
	@ReportExpensePeriod INT = NULL,
	@ReforecastQuaterName VARCHAR(10) = NULL, --''Q1'' or ''Q2'' or ''Q3''
	@PreviousReforecastQuaterName VARCHAR(10) = ''Q1'', --or ''Q2'' or ''Q3''
	@DestinationCurrency VARCHAR(3) = NULL,
	@TranslationTypeName VARCHAR(50) = ''Global'',
	@IsGross bit = 1,-- Dummy code required by common parameter code in DL
	@FunctionalDepartmentList TEXT = NULL,
	@ActivityTypeList TEXT = NULL,
	@EntityList TEXT = NULL,
	@MajorAccountCategoryList TEXT = NULL,
	@MinorAccountCategoryList TEXT = NULL,
	@AllocationRegionList TEXT = NULL,
	@AllocationSubRegionList TEXT = NULL,
	@OriginatingRegionList TEXT = NULL,
	@OriginatingSubRegionList TEXT = NULL
AS

/*
DECLARE @ReportExpensePeriod  AS INT,
        @DestinationCurrency  AS VARCHAR(3),
        @TranslationTypeName        VARCHAR(50),
        @ActivityType         VARCHAR(50),
        @Entity               VARCHAR(100),
        @@AllocationSubRegion     VARCHAR(50)
				
		
SET @ReportExpensePeriod = 201011
SET @DestinationCurrency = ''USD''
SET @TranslationTypeName = ''Global''
SET @ActivityType = NULL
SET @Entity = NULL
SET @AllocationSubRegion = NULL

EXEC stp_R_Profitability
	@ReportExpensePeriod = 201011,
	@TranslationTypeName = ''Global'',
	@DestinationCurrency = ''USD'',

	@FunctionalDepartmentList = ''Information Technologies'',
	@AllocationRegionList = ''CHICAGO'',
	@EntityList = ''Aldgate|Centrium (St Cathrine House/Pegasus)''
*/

DECLARE

	@_ReportExpensePeriod INT = @ReportExpensePeriod,
	@_ReforecastQuaterName VARCHAR(10) = @ReforecastQuaterName,
	@_PreviousReforecastQuaterName VARCHAR(10) = @PreviousReforecastQuaterName,
	@_DestinationCurrency VARCHAR(3) = @DestinationCurrency,
	@_TranslationTypeName VARCHAR(50) = @TranslationTypeName,
	@_FunctionalDepartmentList VARCHAR(8000) = @FunctionalDepartmentList,
	@_ActivityTypeList VARCHAR(8000) = @ActivityTypeList,
	@_EntityList VARCHAR(8000) = @EntityList,
	@_MajorAccountCategoryList VARCHAR(8000) = @MajorAccountCategoryList,
	@_MinorAccountCategoryList VARCHAR(8000) = @MinorAccountCategoryList,
	@_AllocationRegionList VARCHAR(8000) = @AllocationRegionList,
	@_AllocationSubRegionList VARCHAR(8000) = @AllocationSubRegionList,
	@_OriginatingRegionList VARCHAR(8000) = @OriginatingRegionList,
	@_OriginatingSubRegionList VARCHAR(8000) = @OriginatingSubRegionList
--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Variable defaults		*/
--------------------------------------------------------------------------

IF @ReportExpensePeriod IS NULL
	SET @ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + REPLACE(STR(MONTH(GETDATE()),2 ),'' '',''0'')AS INT)

IF @DestinationCurrency IS NULL
	SET @DestinationCurrency = ''USD''

IF 	@TranslationTypeName IS NULL
	SET @TranslationTypeName = ''Global''

	DECLARE @CalendarYear AS INT
	SET @CalendarYear = CAST(SUBSTRING(CAST(@ReportExpensePeriod AS VARCHAR(10)), 1, 4) AS INT)				

-- let latest reforecast (it will be zero if there is no data for the reforecast)
IF @ReforecastQuaterName IS NULL
	SET @ReforecastQuaterName = (SELECT TOP 1 ReforecastQuarterName 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
										  ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
									ORDER BY ReforecastEffectivePeriod DESC)

DECLARE @ReforecastEffectivePeriod INT
SET @ReforecastEffectivePeriod = (SELECT TOP 1 ReforecastEffectivePeriod 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										  ReforecastQuarterName = @ReforecastQuaterName
									ORDER BY ReforecastEffectivePeriod)
									
-- set Q1 reforecast									
IF @PreviousReforecastQuaterName IS NULL
		SET @PreviousReforecastQuaterName = (SELECT TOP 1 ReforecastQuarterName 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
										  ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
									ORDER BY ReforecastEffectivePeriod DESC)
									
DECLARE @PreviousReforecastEffectivePeriod INT																
SET @PreviousReforecastEffectivePeriod = (SELECT TOP 1 ReforecastEffectivePeriod  
									FROM dbo.Reforecast 
									WHERE ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										  ReforecastQuarterName = @PreviousReforecastQuaterName
									ORDER BY ReforecastEffectivePeriod)									

--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Tables		*/
--------------------------------------------------------------------------
	
	CREATE TABLE	#EntityFilterTable	(PropertyFundKey Int NOT NULL)
	CREATE TABLE	#FunctionalDepartmentFilterTable	(FunctionalDepartmentKey Int NOT NULL)
	CREATE TABLE	#ActivityTypeFilterTable(ActivityTypeKey Int NOT NULL)
	CREATE TABLE	#AllocationRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#AllocationSubRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#MajorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#MinorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#OriginatingRegionFilterTable	(OriginatingRegionKey Int NOT NULL)
	CREATE TABLE	#OriginatingSubRegionFilterTable	(OriginatingRegionKey Int NOT NULL)	
		
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable	(PropertyFundKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable(ActivityTypeKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MajorAccountCategoryFilterTable(GlAccountCategoryKey)	
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MinorAccountCategoryFilterTable(GlAccountCategoryKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingRegionFilterTable	(OriginatingRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable	(OriginatingRegionKey)
	
IF (@EntityList IS NOT NULL)
	BEGIN
	Insert Into #EntityFilterTable
	Select pf.PropertyFundKey
	From dbo.Split(@_EntityList) t1
		INNER JOIN PropertyFund pf ON pf.PropertyFundName = t1.item
	
	END
	
IF (@FunctionalDepartmentList IS NOT NULL)
	BEGIN
	Insert Into #FunctionalDepartmentFilterTable
	Select fd.FunctionalDepartmentKey 
	From dbo.Split(@_FunctionalDepartmentList) t1
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentName = t1.item
	END

IF 	(@ActivityTypeList IS NOT NULL)
	BEGIN
    INSERT INTO #ActivityTypeFilterTable
    SELECT at.ActivityTypeKey 
    FROM dbo.Split(@_ActivityTypeList) t1
		INNER JOIN ActivityType at ON at.ActivityTypeName = t1.item
	END
	
IF (@AllocationRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationRegionFilterTable
	Select ar.AllocationRegionKey 
	From dbo.Split(@_AllocationRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.RegionName = t1.item
	END

IF (@AllocationSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationSubRegionFilterTable
	Select ar.AllocationRegionKey
	From dbo.Split(@_AllocationSubRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.SubRegionName = t1.item
	END

IF (@MajorAccountCategoryList IS NOT NULL)
	BEGIN
	Insert Into #MajorAccountCategoryFilterTable
	Select gl.GlAccountCategoryKey 
	From dbo.Split(@_MajorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MajorCategoryName = t1.item
	END
	
IF 	(@MinorAccountCategoryList IS NOT NULL)
	BEGIN
    INSERT INTO #MinorAccountCategoryFilterTable
    SELECT gl.GlAccountCategoryKey 
    FROM dbo.Split(@MinorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MinorCategoryName = t1.item
	END	

IF (@OriginatingRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingRegionFilterTable
	Select orr.OriginatingRegionKey 
	From dbo.Split(@_OriginatingRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.RegionName = t1.item
	END

IF (@OriginatingSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingSubRegionFilterTable
	Select orr.OriginatingRegionKey  
	From dbo.Split(@OriginatingSubRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.SubRegionName = t1.item
	END		
--------------------------------------------------------------------------
/*	COMMON END															*/
--------------------------------------------------------------------------

IF 	OBJECT_ID(''tempdb..#ProfitabilityReport'') IS NOT NULL
    DROP TABLE #ProfitabilityReport

CREATE TABLE #ProfitabilityReport
(
	AccountSubTypeName                 VARCHAR(50),
	FeeOrExpense				VARCHAR(50),
	MajorCategoryName					VARCHAR(100),
	MinorCategoryName					VARCHAR(100),
	ActivityTypeName			VARCHAR(50),
	PropertyFundName			VARCHAR(100),
	AllocationSubRegionName		VARCHAR(50),
	SourceName					VarChar(50),
	EntryDate					VARCHAR(10),
	[User]						NVARCHAR(20),
	[Description]				NVARCHAR(60),
	AdditionalDescription		NVARCHAR(4000),
	
	--Month to date	
	MtdGrossActual				MONEY,
	MtdGrossBudget				MONEY,
	MtdGrossReforecast			MONEY,
	MtdNetActual				MONEY,
	MtdNetBudget				MONEY,
	MtdNetReforecast			MONEY,
	
	--Year to date
	YtdGrossActual				MONEY,	
	YtdGrossBudget				MONEY, 
	YtdGrossReforecast			MONEY, 
	YtdNetActual				MONEY, 
	YtdNetBudget				MONEY, 
	YtdNetReforecast			MONEY, 

	--Annual	
	AnnualGrossBudget			MONEY,
	AnnualGrossReforecast		MONEY,
	AnnualGrossReforecastQ1		MONEY,
	AnnualNetBudget				MONEY,
	AnnualNetReforecast			MONEY,
	AnnualNetReforecastQ1		MONEY,

	--Annual estimated
	AnnualEstGrossBudget		MONEY,
	AnnualEstGrossReforecast	MONEY,
	AnnualEstNetBudget			MONEY,
	AnnualEstNetReforecast		MONEY
)

DECLARE @cmdString Varchar(8000)

--Get actual information
SET @cmdString = (Select ''

INSERT INTO #ProfitabilityReport
SELECT 
	gac.AccountSubTypeName,
	gac.FeeOrExpense,
    gac.MajorCategoryName,
    gac.MinorCategoryName,
    a.ActivityTypeName,
    pf.PropertyFundName,
    ar.SubRegionName AS AllocationSubRegionName,
    s.SourceName,
    CONVERT(varchar(10),ISNULL(pa.EntryDate,''''''''), 101) as EntryDate,
    pa.[User],
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.Description ELSE '''''''' END as Description,
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.AdditionalDescription ELSE '''''''' END as AdditionalDescription,
    -- Expenses must be displayed as negative an Income is saved in MRI as negative
	(
		er.Rate * -1 *
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdGrossActual,
	NULL as MtdGrossBudget,
	(
		er.Rate * -1 *
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdGrossReforecast,
	
	(
		er.Rate * r.MultiplicationFactor * -1 *
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdNetActual,
	NULL as MtdNetBudget,
	(
		er.Rate * r.MultiplicationFactor * -1 *
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdNetReforecast,
	
	(
		er.Rate * -1 *
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdGrossActual,
	NULL as YtdGrossBudget,
	(
		er.Rate * -1 *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as YtdGrossReforecast,
	
	(
		er.Rate * r.MultiplicationFactor * -1 *
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdNetActual,
	NULL as YtdNetBudget,
	(
		er.Rate * r.MultiplicationFactor * -1 *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as YtdNetReforecast,
	
	NULL as AnnualGrossBudget,
	(
		er.Rate * -1 *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualGrossReforecast,
	(
		er.Rate * -1 *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@PreviousReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualGrossReforecastQ1,
	

	NULL as AnnualNetBudget,
    (
        er.Rate * r.MultiplicationFactor * -1 *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecast,
    (
        er.Rate * r.MultiplicationFactor * -1 *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@PreviousReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ1,
	
	(
        er.Rate * -1 *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pa.LocalActual
        ELSE 
			0
        END
	) as AnnualEstGrossBudget,
	(
            er.Rate * -1 *
            CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecast,

    (
        er.Rate * r.MultiplicationFactor * -1 *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
	(
        er.Rate * r.MultiplicationFactor * -1 *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriod,6,0) + '' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstNetReforecast
FROM
	ProfitabilityActual pa

	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pa.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pa.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pa.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pa.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pa.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pa.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pa.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pa.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
		
    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
    INNER JOIN Currency dc ON  dc.CurrencyKey = er.DestinationCurrencyKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pa.ReimbursableKey
    INNER JOIN Calendar c ON  c.CalendarKey = pa.CalendarKey
    INNER JOIN Source s ON s.SourceKey = pa.SourceKey

    INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pa.AllocationRegionKey
    INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey
    INNER JOIN ActivityType a ON  a.ActivityTypeKey = pa.ActivityTypeKey
    INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pa.PropertyFundKey
    INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey

WHERE  1 = 1
    AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select t1.FunctionalDepartmentKey From #FunctionalDepartmentFilterTable t1)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select t1.ActivityTypeKey From #ActivityTypeFilterTable t1)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select t1.PropertyFundKey From #EntityFilterTable t1)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationRegionFilterTable t1)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationSubRegionFilterTable t1)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MajorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MinorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingRegionFilterTable t1)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingSubRegionFilterTable t1)'' END +
''
'')
print @cmdString
EXEC (@cmdString)

--Get budget information
SET @cmdString = (Select ''

INSERT INTO #ProfitabilityReport
SELECT 
	gac.AccountSubTypeName,
	gac.FeeOrExpense,
    gac.MajorCategoryName,
    gac.MinorCategoryName,
    a.ActivityTypeName,
    pf.PropertyFundName,
    ar.SubRegionName AS AllocationSubRegionName,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    
    --Expenses must be displayed as negative
    NULL as MtdGrossActual,
	(
		er.Rate * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
					1
				   ELSE
					-1 
				   END) *
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as MtdGrossBudget,
	NULL as MtdGrossReforecast,
	
	NULL as MtdNetActual,
	(
        er.Rate * r.MultiplicationFactor * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
											 1
										    ELSE
											 -1 
										    END) * 
        CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as MtdNetBudget,
	NULL as MtdNetReforecast,
	
	NULL as YtdGrossActual,	
	(
		er.Rate * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
					1
				   ELSE
					-1 
				   END) * 
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as YtdGrossBudget, 
	NULL as YtdGrossReforecast, 
	
	NULL as YtdNetActual, 
	(
        er.Rate * r.MultiplicationFactor * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
											 1
										    ELSE
											 -1 
										    END) * 
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as YtdNetBudget, 
	NULL as YtdNetReforecast, 
	
	(er.Rate * pb.LocalBudget * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
									1
								  ELSE
									-1 
								  END)) as AnnualGrossBudget,
	NULL as AnnualGrossReforecast,
	NULL as AnnualGrossReforecastQ1,

	(er.Rate * r.MultiplicationFactor * pb.LocalBudget * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
																1
															 ELSE
																-1 
															 END)) as AnnualNetBudget,
	NULL as AnnualNetReforecast,
	NULL as AnnualNetReforecastQ1,


	(
		er.Rate * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
					1
				   ELSE
					-1 
				   END) * 
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as AnnualEstGrossBudget,
	NULL as AnnualEstGrossReforecast,

	(
        er.Rate * r.MultiplicationFactor * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
											 1
										    ELSE
											 -1 
										    END) * 
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
	NULL as AnnualEstNetReforecast
	
FROM
	ProfitabilityBudget pb
	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pb.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pb.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pb.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pb.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pb.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pb.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pb.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pb.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			
    INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey
    INNER JOIN Currency dc ON er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pb.CalendarKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pb.ReimbursableKey
    INNER JOIN Source s ON s.SourceKey = pb.SourceKey

    INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey
    INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey
    INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey
    INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey
    INNER JOIN ActivityType a ON a.ActivityTypeKey = pb.ActivityTypeKey

WHERE  1 = 1
    AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
'')
print @cmdString
EXEC (@cmdString)

--Get reforecast information
SET @cmdString = (Select ''

INSERT INTO #ProfitabilityReport
SELECT 
	gac.AccountSubTypeName,
	gac.FeeOrExpense,
    gac.MajorCategoryName,
    gac.MinorCategoryName,
    a.ActivityTypeName,
    pf.PropertyFundName,
    ar.SubRegionName AS AllocationSubRegionName,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    
    --Expenses must be displayed as negative
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	(
		er.Rate * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
					1
				   ELSE
					-1 
				   END) * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecast,
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
    (
        er.Rate * r.MultiplicationFactor * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
											 1
										    ELSE
											 -1 
										    END) * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecast,
	
	NULL as YtdGrossActual,	
	NULL as YtdGrossBudget, 
	(
		er.Rate * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
					1
				   ELSE
					-1 
				   END) * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecast, 
	
	NULL as YtdNetActual, 
	NULL as YtdNetBudget, 
    (
        er.Rate * r.MultiplicationFactor * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
											 1
										    ELSE
											 -1 
										    END) * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecast, 
	
	NULL as AnnualGrossBudget, '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''(er.Rate * pr.LocalReforecast * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
										  1
									    ELSE
										 -1 
									    END)) as AnnualGrossReforecast,
	NULL as AnnualGrossReforecastQ1,								    

	NULL as AnnualNetBudget, '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''(er.Rate * r.MultiplicationFactor * pr.LocalReforecast * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
																	1
																  ELSE
																	-1 
																  END))as AnnualNetReforecast,
	NULL as AnnualNetReforecastQ1,															  

	NULL as AnnualEstGrossBudget,
	(
		er.Rate * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
					1
				   ELSE
					-1 
				   END) *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			'' OR (
					LEFT(pr.ReferenceCode,3) = ''''BC:'''' 
					AND '' + STR(@ReforecastEffectivePeriod,6,0) + '' IN (201003,201006))
				)
		THEN 
			pr.LocalReforecast
		ELSE
			0
		END
	) as AnnualEstGrossReforecast,

	NULL as AnnualEstNetBudget,
	(
        er.Rate * r.MultiplicationFactor * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
											 1
										    ELSE
											 -1 
										    END) *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''  OR (
					LEFT(pr.ReferenceCode,3) = ''''BC:'''' 
					AND '' + STR(@ReforecastEffectivePeriod,6,0) + '' IN (201003,201006))
				)
		THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstNetReforecast
FROM
	ProfitabilityReforecast pr
	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			
    INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
    INNER JOIN Currency dc ON er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pr.CalendarKey
    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey
    INNER JOIN Source s ON s.SourceKey = pr.SourceKey

    INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey
    INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey
    INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey
    INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey
    INNER JOIN ActivityType a ON a.ActivityTypeKey = pr.ActivityTypeKey

WHERE  1 = 1
    AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND ref.ReforecastEffectivePeriod = '' + STR(@ReforecastEffectivePeriod,10,0) + ''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
'')
print @cmdString
EXEC (@cmdString)

--Get reforecastQ1 information
SET @cmdString = (Select ''

INSERT INTO #ProfitabilityReport
SELECT 
	gac.AccountSubTypeName,
	gac.FeeOrExpense,
    gac.MajorCategoryName,
    gac.MinorCategoryName,
    a.ActivityTypeName,
    pf.PropertyFundName,
    ar.SubRegionName AS AllocationSubRegionName,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    
    --Expenses must be displayed as negative
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	NULL as MtdGrossReforecast,
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
    NULL as MtdNetReforecast,
	
	NULL as YtdGrossActual,	
	NULL as YtdGrossBudget, 
	NULL as YtdGrossReforecast, 
	
	NULL as YtdNetActual, 
	NULL as YtdNetBudget, 
    NULL as YtdNetReforecast, 
	
	NULL as AnnualGrossBudget, 
	NULL as AnnualGrossReforecast,
	(er.Rate * pr.LocalReforecast * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
										  1
									    ELSE
										 -1 
									    END)) as AnnualGrossReforecastQ1,

	NULL as AnnualNetBudget, 
	NULL as AnnualNetReforecast,
	(er.Rate * r.MultiplicationFactor * pr.LocalReforecast * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
																	1
																  ELSE
																	-1 
																  END)) as AnnualNetReforecastQ1,

	NULL as AnnualEstGrossBudget,
	NULL as AnnualEstGrossReforecast,

	NULL as AnnualEstNetBudget,
	NULL as AnnualEstNetReforecast
FROM
	ProfitabilityReforecast pr
	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			
    INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
    INNER JOIN Currency dc ON er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pr.CalendarKey
    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey
    INNER JOIN Source s ON s.SourceKey = pr.SourceKey

    INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey
    INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey
    INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey
    INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey
    INNER JOIN ActivityType a ON a.ActivityTypeKey = pr.ActivityTypeKey

WHERE  1 = 1
    AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND ref.ReforecastEffectivePeriod = '' + STR(@PreviousReforecastEffectivePeriod,10,0) + ''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
'')
print @cmdString
EXEC (@cmdString)

SELECT 
	AccountSubTypeName AS ExpenseType, 
	FeeOrExpense AS FeeOrExpense,
    MajorCategoryName AS MajorExpenseCategoryName,
    MinorCategoryName AS MinorExpenseCategoryName,
    ActivityTypeName AS ActivityType,
	PropertyFundName AS EntityName,
	AllocationSubRegionName AS AllocationSubRegionName,
    EntryDate,
    [User],
    [Description],
    AdditionalDescription,
	SourceName AS SourceName,
	--Gross
	--Month to date    
	SUM(ISNULL(MtdGrossActual,0)) AS MtdGrossActual,
	SUM(ISNULL(MtdGrossBudget,0)) AS MtdGrossOriginalBudget,
	
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast 
		END,0)) 
	AS MtdGrossReforecast,
	
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast 
		END, 0) - ISNULL(MtdGrossActual, 0)) 
	AS MtdGrossVariance,
	
	--Year to date
	SUM(ISNULL(YtdGrossActual,0)) AS YtdGrossActual,	
	SUM(ISNULL(YtdGrossBudget,0)) AS YtdGrossOriginalBudget,
	
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END,0))
	AS YtdGrossReforecast,
	
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END, 0) - ISNULL(YtdGrossActual, 0))
	AS YtdGrossVariance,
	
	--Annual
	SUM(ISNULL(AnnualGrossBudget,0)) AS AnnualGrossOriginalBudget,	
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecast 
		END,0)) 
	AS AnnualGrossReforecast,
	
	SUM (ISNULL(CASE WHEN @PreviousReforecastQuaterName = ''Q1'' THEN 
			AnnualGrossReforecastQ1 		
		END,0)) 
	AS AnnualGrossReforecastQ1,
	
	--Annual Estimated
	--SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
	--		AnnualEstGrossBudget 
	--	ELSE 
	--		AnnualEstGrossReforecast 
	--	END,0)) 
	--AS AnnualGrossEstimatedActual,	
	
	--SUM(ISNULL(AnnualGrossBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
	--											AnnualEstGrossBudget 
	--										ELSE 
	--											AnnualEstGrossReforecast 
	--										END,0))
	--AS AnnualGrossEstimatedVariance,
	
	--Net
	--Month to date    
	SUM(ISNULL(MtdNetActual,0)) AS MtdNetActual,
	SUM(ISNULL(MtdNetBudget,0)) AS MtdNetOriginalBudget,
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast 
		END,0)) AS MtdNetReforecast,
		
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast 
		END, 0) - ISNULL(MtdNetActual, 0))
	AS MtdNetVariance,
	
	--Year to date
	SUM(ISNULL(YtdNetActual,0)) AS YtdNetActual,	
	SUM(ISNULL(YtdNetBudget,0)) AS YtdNetOriginalBudget,
	
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast 
		END,0))
	AS YtdNetReforecast,
	
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast 
		END, 0) - ISNULL(YtdNetActual, 0)) 
	AS YtdNetVariance,
	
	--Annual
	SUM(ISNULL(AnnualNetBudget,0)) AS AnnualNetOriginalBudget,	
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecast 
		END,0))
	AS AnnualNetReforecast,
	SUM (ISNULL(CASE WHEN @PreviousReforecastQuaterName = ''Q1'' THEN 
			AnnualNetReforecastQ1 		
		END,0)) 
	AS AnnualNetReforecastQ1
	
	--Annual Estimated
	--SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
	--		AnnualEstNetBudget 
	--	ELSE 
	--		AnnualEstNetReforecast 
	--	END,0))
	--AS AnnualNetEstimatedActual,
	
	--SUM(ISNULL(AnnualNetBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
	--										AnnualEstNetBudget 
	--									ELSE 
	--										AnnualEstNetReforecast 
	--									END,0)) 
	--AS AnnualNetEstimatedVariance 
INTO
	#Output
FROM
	#ProfitabilityReport
GROUP BY
    AccountSubTypeName,
    FeeOrExpense,
    MajorCategoryName,
    MinorCategoryName,
    ActivityTypeName,
    PropertyFundName,
    AllocationSubRegionName,
    EntryDate,
    [User],
    [Description],
    AdditionalDescription,
    SourceName
ORDER BY
	CASE WHEN FeeOrExpense = ''INCOME'' THEN 1 WHEN FeeOrExpense = ''EXPENSE'' THEN 2 ELSE 3 END

--Output
SELECT
	ExpenseType, 
	FeeOrExpense,
    MajorExpenseCategoryName,
    MinorExpenseCategoryName,
    ActivityType,
	EntityName,
	AllocationSubRegionName,
    EntryDate,
    [User],
    [Description],
    AdditionalDescription,
	SourceName AS SourceName,
	--Gross
	--Month to date    
	MtdGrossActual,
	MtdGrossOriginalBudget,
	
	MtdGrossReforecast,
	MtdGrossVariance,
	
	--Year to date
	YtdGrossActual,	
	YtdGrossOriginalBudget,
	
	YtdGrossReforecast,
	YtdGrossVariance,
	
	--Annual
	AnnualGrossOriginalBudget,	
	AnnualGrossReforecast,
	AnnualGrossReforecastQ1,
	
	--Annual Estimated
	--AnnualGrossEstimatedActual,	
	--AnnualGrossEstimatedVariance,
	
	--Net
	--Month to date    
	MtdNetActual,
	MtdNetOriginalBudget,
	MtdNetReforecast,
	MtdNetVariance,
	
	--Year to date
	YtdNetActual,	
	YtdNetOriginalBudget,
	YtdNetReforecast,
	YtdNetVariance,
	--Annual
	AnnualNetOriginalBudget,	
	AnnualNetReforecast,
	AnnualNetReforecastQ1
	
	--Annual Estimated
	--AnnualNetEstimatedActual 
	--AnnualNetEstimatedVariance 
FROM
	#Output
WHERE
	--Gross
	--Month to date    
	MtdGrossActual <> 0.00 OR
	MtdGrossOriginalBudget <> 0.00 OR
	MtdGrossReforecast <> 0.00 OR
	MtdGrossVariance <> 0.00 OR
	
	--Year to date
	YtdGrossActual <> 0.00 OR
	YtdGrossOriginalBudget <> 0.00 OR
	YtdGrossReforecast <> 0.00 OR
	YtdGrossVariance <> 0.00 OR
	
	--Annual
	AnnualGrossOriginalBudget <> 0.00 OR
	AnnualGrossReforecast <> 0.00 OR
	AnnualGrossReforecastQ1 <> 0.00 OR
	
	--Annual Estimated
	--AnnualGrossEstimatedActual <> 0.00 OR
	--AnnualGrossEstimatedVariance <> 0.00 OR
	
	--Net
	--Month to date    
	MtdNetActual <> 0.00 OR
	MtdNetOriginalBudget <> 0.00 OR
	MtdNetReforecast <> 0.00 OR
	MtdNetVariance <> 0.00 OR
	
	--Year to date
	YtdNetActual <> 0.00 OR
	YtdNetOriginalBudget <> 0.00 OR
	YtdNetReforecast <> 0.00 OR
	YtdNetVariance <> 0.00 OR
	--Annual
	AnnualNetOriginalBudget <> 0.00 OR
	AnnualNetReforecast <> 0.00 OR
	AnnualNetReforecastQ1 <> 0.00 --OR
	
	--Annual Estimated
	--AnnualNetEstimatedActual <> 0.00 OR
	--AnnualNetEstimatedVariance <> 0.00 

	
	--Annual Estimated
	--AnnualNetEstimatedActual <> 0.00 OR
	--AnnualNetEstimatedVariance <> 0.00 

IF 	OBJECT_ID(''tempdb..#ProfitabilityReport'') IS NOT NULL
    DROP TABLE #ProfitabilityReport

IF 	OBJECT_ID(''tempdb..#Output'') IS NOT NULL
    DROP TABLE #Output


' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_R_MissingExchangeRates]    Script Date: 08/05/2010 15:11:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_MissingExchangeRates]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_R_MissingExchangeRates]
 
AS 
DECLARE @CurrencyCount Int

Select	DISTINCT
		''Actual'' DataSource,
		Ca.CalendarDate,
		Scu.CurrencyCode LocalCurrencyCode,
		0 NumberOfCurrencies,
		0 NumberOfDestinationCurrencies
From
		ProfitabilityActual Pa
			INNER JOIN Calendar Ca ON Ca.CalendarKey = Pa.CalendarKey
			INNER JOIN Currency Scu ON Scu.CurrencyKey = Pa.LocalCurrencyKey
			LEFT OUTER JOIN ExchangeRate Ex ON pa.LocalCurrencyKey = Ex.SourceCurrencyKey
								AND pa.CalendarKey = Ex.CalendarKey
Where Ex.SourceCurrencyKey IS NULL
UNION ALL
Select	''Budget'',
		Ca.CalendarDate,
		Scu.CurrencyCode LocalCurrencyCode,
		0 NumberOfCurrencies,
		0 NumberOfDestinationCurrencies
From
		ProfitabilityBudget Pb
			INNER JOIN Calendar Ca ON Ca.CalendarKey = Pb.CalendarKey
			INNER JOIN Currency Scu ON Scu.CurrencyKey = Pb.LocalCurrencyKey
			LEFT OUTER JOIN ExchangeRate Ex ON pb.LocalCurrencyKey = Ex.SourceCurrencyKey
								AND pb.CalendarKey = Ex.CalendarKey
Where Ex.SourceCurrencyKey IS NULL
Order By 1,2,3

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]    Script Date: 08/05/2010 15:11:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]

	@ImportStartDate	DateTime,
	@ImportEndDate		DateTime,
	@DataPriorToDate	DateTime=NULL
AS

SET NOCOUNT ON
IF @DataPriorToDate IS NULL 
	SET @DataPriorToDate = GETDATE()

PRINT ''####''
PRINT ''stp_IU_LoadGrProfitabiltyPayrollReforecast''
PRINT ''####''


	
/*
[stp_IU_LoadGrProfitabiltyPayrollReforecast]
	@ImportStartDate	= ''1900-01-01'',
	@ImportEndDate		= ''2010-12-31'',
	@DataPriorToDate	= ''2010-12-31''
*/ 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Setup mapping variables
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--/*
-- Setup Bonus Cap Excess Project Setting

CREATE TABLE #SystemSettingRegion
(
	SystemSettingId int NOT NULL,
	SystemSettingName varchar(50) NOT NULL,
	SystemSettingRegionId int NOT NULL,
	RegionId int,
	SourceCode varchar(2),
	BonusCapExcessProjectId int
)
INSERT INTO #SystemSettingRegion
(
	SystemSettingId,
	SystemSettingName,
	SystemSettingRegionId,
	RegionId,
	SourceCode,
	BonusCapExcessProjectId
)

SELECT 
	ss.SystemSettingId,
	ss.Name,
	ssr.SystemSettingRegionId,
	ssr.RegionId,
	ssr.SourceCode,
	ssr.BonusCapExcessProjectId
FROM
	(SELECT 
		ssr.* 
	 FROM TapasGlobal.SystemSettingRegion ssr
		INNER JOIN TapasGlobal.SystemSettingRegionActive(@DataPriorToDate) ssrA
			ON ssr.ImportKey = ssrA.ImportKey
	 ) ssr
	INNER JOIN
		(SELECT
			ss.SystemSettingId,
			ss.Name
		 FROM
			(SELECT	
				ss.*
			 FROM TapasGlobal.SystemSetting ss
					INNER JOIN TapasGlobal.SystemSettingActive(@DataPriorToDate) ssA 
						ON ss.ImportKey = ssA.ImportKey
			 ) ss

		  ) ss ON ssr.SystemSettingId = ss.SystemSettingId
PRINT ''Completed getting system settings''
PRINT CONVERT(Varchar(27), getdate(), 121)

--*/
-- Setup account categories and default to UNKNOWN.
DECLARE 
		@SalariesTaxesBenefitsMajorGlAccountCategoryId	 int = -1,
		@BaseSalaryMinorGlAccountCategoryId				 int = -1,
		@BenefitsMinorGlAccountCategoryId				 int = -1,
		@BonusMinorGlAccountCategoryId					 int = -1,
		@ProfitShareMinorGlAccountCategoryId			 int = -1,
		@OccupancyCostsMajorGlAccountCategoryId			 int = -1,
		@OverheadMinorGlAccountCategoryId				 int = -1

DECLARE 
      @GlAccountKey				Int = (Select GlAccountKey From GrReporting.dbo.GlAccount Where GlAccountCode = ''UNKNOWN''),
      @SourceKey				Int = (Select SourceKey From GrReporting.dbo.Source Where SourceName = ''UNKNOWN''),
      @FunctionalDepartmentKey	Int = (Select FunctionalDepartmentKey From GrReporting.dbo.FunctionalDepartment Where FunctionalDepartmentCode = ''UNKNOWN''),
      @ReimbursableKey			Int = (Select ReimbursableKey From GrReporting.dbo.Reimbursable Where ReimbursableCode = ''UNKNOWN''),
      @ActivityTypeKey			Int = (Select ActivityTypeKey From GrReporting.dbo.ActivityType Where ActivityTypeCode = ''UNKNOWN''),
      @PropertyFundKey			Int = (Select PropertyFundKey From GrReporting.dbo.PropertyFund Where PropertyFundName = ''UNKNOWN''),
      @AllocationRegionKey		Int = (Select AllocationRegionKey From GrReporting.dbo.AllocationRegion Where RegionCode = ''UNKNOWN''),
      @OriginatingRegionKey		Int = (Select OriginatingRegionKey From GrReporting.dbo.OriginatingRegion Where RegionCode = ''UNKNOWN''),
      @LocalCurrencyKey			Int = (Select CurrencyKey From GrReporting.dbo.Currency Where CurrencyCode = ''UNKNOWN'')

DECLARE	@EUFundGlAccountCategoryKey						Int,
		@EUCorporateGlAccountCategoryKey				Int,
		@EUPropertyGlAccountCategoryKey					Int,
		@USFundGlAccountCategoryKey						Int,
		@USPropertyGlAccountCategoryKey					Int,
		@USCorporateGlAccountCategoryKey				Int,
		@DevelopmentGlAccountCategoryKey				Int,
		@GlobalGlAccountCategoryKey						Int

SET @EUFundGlAccountCategoryKey			= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = ''EU Fund'' AND MajorName = ''UNKNOWN'' AND MinorName = ''UNKNOWN'')
SET @EUCorporateGlAccountCategoryKey	= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = ''EU Corporate'' AND MajorName = ''UNKNOWN'' AND MinorName = ''UNKNOWN'')
SET @EUPropertyGlAccountCategoryKey		= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = ''EU Property'' AND MajorName = ''UNKNOWN'' AND MinorName = ''UNKNOWN'')
SET @USFundGlAccountCategoryKey			= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = ''US Fund'' AND MajorName = ''UNKNOWN'' AND MinorName = ''UNKNOWN'')
SET @USPropertyGlAccountCategoryKey		= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = ''US Property'' AND MajorName = ''UNKNOWN'' AND MinorName = ''UNKNOWN'')
SET @USCorporateGlAccountCategoryKey	= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = ''US Corporate'' AND MajorName = ''UNKNOWN'' AND MinorName = ''UNKNOWN'')
SET @DevelopmentGlAccountCategoryKey	= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = ''Development'' AND MajorName = ''UNKNOWN'' AND MinorName = ''UNKNOWN'')
SET @GlobalGlAccountCategoryKey			= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = ''Global'' AND MajorName = ''UNKNOWN'' AND MinorName = ''UNKNOWN'')
		
-- Set gl account categories
SELECT TOP 1 @SalariesTaxesBenefitsMajorGlAccountCategoryId = MajorGlAccountCategoryId 
FROM Gr.GetGlobalGlAccountCategoryHierarchy(@DataPriorToDate) 
WHERE MajorGlAccountCategoryName = ''Salaries/Taxes/Benefits''
--NB!!!!!!!
--The roll up to payroll is very sensitive information. It is crutial that information regarding payroll not get 
--communicated to TS employees on certain reports. Changing the category name here will have ramifications because 
--some reports check for this name.
--NB!!!!!!!

SELECT @BaseSalaryMinorGlAccountCategoryId = MinorGlAccountCategoryId 
FROM Gr.GetGlobalGlAccountCategoryHierarchy(@DataPriorToDate) 
WHERE MajorGlAccountCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	  MinorGlAccountCategoryName = ''Base Salary''

SELECT @BenefitsMinorGlAccountCategoryId = MinorGlAccountCategoryId 
FROM Gr.GetGlobalGlAccountCategoryHierarchy(@DataPriorToDate) 
WHERE MajorGlAccountCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	  MinorGlAccountCategoryName = ''Benefits''

SELECT @BonusMinorGlAccountCategoryId = MinorGlAccountCategoryId 
FROM Gr.GetGlobalGlAccountCategoryHierarchy(@DataPriorToDate) 
WHERE MajorGlAccountCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	  MinorGlAccountCategoryName = ''Bonus''

SELECT @ProfitShareMinorGlAccountCategoryId = MinorGlAccountCategoryId 
FROM Gr.GetGlobalGlAccountCategoryHierarchy(@DataPriorToDate) 
WHERE MajorGlAccountCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	  MinorGlAccountCategoryName = ''Benefits'' -- Yes benefit is correct (Just incase they want to split profit share out again)

SELECT TOP 1 @OccupancyCostsMajorGlAccountCategoryId = MajorGlAccountCategoryId 
FROM Gr.GetGlobalGlAccountCategoryHierarchy(@DataPriorToDate) 
WHERE MajorGlAccountCategoryName = ''General Overhead''

SELECT @OverheadMinorGlAccountCategoryId = MinorGlAccountCategoryId 
FROM Gr.GetGlobalGlAccountCategoryHierarchy(@DataPriorToDate) 
WHERE MajorGlAccountCategoryId = @OccupancyCostsMajorGlAccountCategoryId AND
	  MinorGlAccountCategoryName = ''External General Overhead''

DECLARE @SourceSystemId int
SET @SourceSystemId = 2 -- Tapas budgeting source system

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Source Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--/*
CREATE TABLE #GlobalGlAccountCategoryHierarchyGroup
(
	ImportKey int NOT NULL,
	GlobalGlAccountCategoryHierarchyGroupId int NOT NULL,
	Name varchar(50) NOT NULL,
	IsDefault bit NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
)

CREATE TABLE #MajorGlAccountCategory(
	ImportKey int NOT NULL,
	MajorGlAccountCategoryId int NOT NULL,
	Name varchar(100) NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
)

CREATE TABLE #MinorGlAccountCategory(
	ImportKey int NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	Name varchar(100) NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
)

INSERT INTO #GlobalGlAccountCategoryHierarchyGroup
(ImportKey,GlobalGlAccountCategoryHierarchyGroupId,Name,IsDefault,InsertedDate,UpdatedDate)
Select GlHg.ImportKey,GlHg.GlobalGlAccountCategoryHierarchyGroupId,GlHg.Name,GlHg.IsDefault,GlHg.InsertedDate,GlHg.UpdatedDate
From Gdm.GlobalGlAccountCategoryHierarchyGroup GlHg
		INNER JOIN Gdm.GlobalGlAccountCategoryHierarchyGroupActive(@DataPriorToDate) GlHga ON GlHga.ImportKey = GlHg.ImportKey

INSERT INTO #MajorGlAccountCategory
(ImportKey,MajorGlAccountCategoryId,Name,InsertedDate,UpdatedDate)
Select MaGlAc.ImportKey,MaGlAc.MajorGlAccountCategoryId,MaGlAc.Name,MaGlAc.InsertedDate,MaGlAc.UpdatedDate
From	Gdm.MajorGlAccountCategory MaGlAc
		INNER JOIN Gdm.MajorGlAccountCategoryActive(@DataPriorToDate) MaGlAcA ON MaGlAcA.ImportKey = MaGlAc.ImportKey

INSERT INTO #MinorGlAccountCategory
(ImportKey,MinorGlAccountCategoryId,Name,InsertedDate,UpdatedDate)
Select MiGlAc.ImportKey,MiGlAc.MinorGlAccountCategoryId,MiGlAc.Name,MiGlAc.InsertedDate,MiGlAc.UpdatedDate
From	Gdm.MinorGlAccountCategory MiGlAc
		INNER JOIN Gdm.MinorGlAccountCategoryActive(@DataPriorToDate) MiGlAcA ON MiGlAcA.ImportKey = MiGlAc.ImportKey

PRINT ''Completed getting GlAccountCategory records''
PRINT CONVERT(Varchar(27), getdate(), 121)
------------------------------------------------------------------------------------------------------
--Source and identify report grouping records
------------------------------------------------------------------------------------------------------

-- Source budget report group detail. 
SELECT
	brgd.*
INTO
	#BudgetReportGroupDetail
FROM 
	TapasGlobalBudgeting.BudgetReportGroupDetail brgd
	INNER JOIN TapasGlobalBudgeting.BudgetReportGroupDetailActive(@DataPriorToDate) brgdA ON
		brgd.ImportKey = brgdA.ImportKey
PRINT ''Completed inserting records from BudgetReportGroupDetail:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget report group. 
SELECT 
	brg.* 
INTO
	#BudgetReportGroup
FROM 
	TapasGlobalBudgeting.BudgetReportGroup brg
	INNER JOIN TapasGlobalBudgeting.BudgetReportGroupActive(@DataPriorToDate) brgA ON
		brg.ImportKey = brgA.ImportKey
PRINT ''Completed inserting records from BudgetReportGroup:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source report group period mapping.
SELECT
	brgp.*
INTO
	#BudgetReportGroupPeriod
FROM
	TapasGlobalBudgeting.GRBudgetReportGroupPeriod brgp
	INNER JOIN TapasGlobalBudgeting.GRBudgetReportGroupPeriodActive(@DataPriorToDate) brgpA ON
		brgp.ImportKey = brgpA.ImportKey
PRINT ''Completed inserting records from GRBudgetReportGroupPeriod:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget status
SELECT 
	BudgetStatus.* 
INTO
	#BudgetStatus
FROM
	TapasGlobalBudgeting.BudgetStatus BudgetStatus
	INNER JOIN TapasGlobalBudgeting.BudgetStatusActive(@DataPriorToDate) BudgetStatusA ON
		BudgetStatus.ImportKey = BudgetStatusA.ImportKey
PRINT ''Completed inserting records from BudgetStatus:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source all active budget
SELECT 
	Budget.*
INTO
	#AllActiveBudget
FROM
	TapasGlobalBudgeting.Budget Budget
	INNER JOIN TapasGlobalBudgeting.BudgetActive(@DataPriorToDate) BudgetA ON
		Budget.ImportKey = BudgetA.ImportKey
PRINT ''Completed inserting records from Budget:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Modified new or modified budget or report group setup.
SELECT 
	brgd.BudgetId, 
	brgd.BudgetReportGroupId,
	brgp.GRBudgetReportGroupPeriodId,
	Budget.IsDeleted as IsBudgetDeleted,
	Budget.IsReforecast as IsBugetReforecast,
	Budget.BudgetStatusId, 
	Budget.FirstProjectedPeriod as BudgetFirstProjectedPeriod,
	brgd.IsDeleted as IsDetailDeleted, 
	brg.IsReforecast as IsGroupReforecast, 
	brg.StartPeriod as GroupStartPeriod, 
	brg.EndPeriod as GroupEndPeriod, 
	brg.IsDeleted as IsGroupDeleted,
	brgp.IsDeleted as IsPeriodDeleted
INTO
	#AllModifiedReportBudget
FROM

	#AllActiveBudget Budget

    INNER JOIN #BudgetReportGroupDetail brgd ON
		Budget.BudgetId = brgd.BudgetId
    
    INNER JOIN #BudgetReportGroup brg ON
		brgd.BudgetReportGroupId = brg.BudgetReportGroupId
    
    INNER JOIN #BudgetReportGroupPeriod brgp ON
		brg.BudgetReportGroupId = brgp.BudgetReportGroupId 
		
WHERE
	(brgd.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
	(brg.GRChangedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
	(brgp.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
	(Budget.LastLockedDate IS NOT NULL AND Budget.LastLockedDate BETWEEN @ImportStartDate AND @ImportEndDate)

PRINT ''Completed inserting records into #AllModifiedReportBudget:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Filtered budget and setup report group setup

SELECT
	amrb.BudgetReportGroupId
INTO
	#LockedModifiedReportGroup
FROM

	#AllModifiedReportBudget amrb
	
	INNER JOIN #BudgetStatus bs ON
		amrb.BudgetStatusId = bs.BudgetStatusId
GROUP BY
	amrb.BudgetReportGroupId
HAVING COUNT(*) = SUM(CASE WHEN bs.[Name] = ''Locked'' THEN 1 ELSE 0 END) 

PRINT ''Completed inserting records into #LockedModifiedReportGroup:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source filtered budget information
SELECT
	amrb.*
INTO
	#FilteredModifiedReportBudget
FROM
	#LockedModifiedReportGroup lmrg
	
	INNER JOIN #AllModifiedReportBudget amrb ON
		lmrg.BudgetReportGroupId = amrb.BudgetReportGroupId
WHERE
	amrb.IsBudgetDeleted = 0 AND
	amrb.IsBugetReforecast = 1 AND
	amrb.IsDetailDeleted = 0 AND
	amrb.IsGroupReforecast = 1 AND
	amrb.IsGroupDeleted = 0 AND
	amrb.IsPeriodDeleted = 0

PRINT ''Completed inserting records into #FilteredModifiedReportBudget:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget information that meet criteria
SELECT 
	Budget.* 
INTO
	#Budget
FROM
	#AllActiveBudget Budget
	
	INNER JOIN #FilteredModifiedReportBudget fmrb ON
		Budget.BudgetId = fmrb.BudgetId
PRINT ''Completed inserting records into #Budget:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetID ON #Budget (BudgetId)
PRINT ''Completed creating indexes on #Budget''
PRINT CONVERT(Varchar(27), getdate(), 121)

--*/
------------------------------------------------------------------------------------------------------
--Source associated records
------------------------------------------------------------------------------------------------------

--/*
-- Source budget project
SELECT 
	BudgetProject.* 
INTO 
	#BudgetProject
FROM 
	TapasGlobalBudgeting.BudgetProject BudgetProject
	INNER JOIN TapasGlobalBudgeting.BudgetProjectActive(@DataPriorToDate) BudgetProjectA ON
		BudgetProject.ImportKey = BudgetProjectA.ImportKey
		
	-- data limiting join
	INNER JOIN #Budget b ON
		BudgetProject.BudgetId = b.BudgetId

PRINT ''Completed inserting records into #BudgetProject:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetID ON #BudgetProject (BudgetId)
PRINT ''Completed creating indexes on #BudgetProject''
PRINT CONVERT(Varchar(27), getdate(), 121)


-- Source region
SELECT 
	SourceRegion.* 
INTO
	#Region
FROM 
	HR.Region SourceRegion
	INNER JOIN HR.RegionActive(@DataPriorToDate) SourceRegionA ON
		SourceRegion.ImportKey = SourceRegionA.ImportKey
PRINT ''Completed inserting records into #Region:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Budget Employee
SELECT 
	BudgetEmployee.* 
INTO
	#BudgetEmployee
FROM 
	TapasGlobalBudgeting.BudgetEmployee BudgetEmployee
	INNER JOIN TapasGlobalBudgeting.BudgetEmployeeActive(@DataPriorToDate) BudgetEmployeeA ON
		BudgetEmployee.ImportKey = BudgetEmployeeA.ImportKey

	--data limiting join
	INNER JOIN #Budget b ON
		BudgetEmployee.BudgetId = b.BudgetId

PRINT ''Completed inserting records into #Region:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeeID ON #BudgetEmployee (BudgetEmployeeId)
CREATE INDEX IX_BudgetId ON #BudgetEmployee (BudgetId)
PRINT ''Completed creating indexes on ##BudgetEmployee''
PRINT CONVERT(Varchar(27), getdate(), 121)


-- Source Budget Employee Functional Department
SELECT 
	efd.* 
INTO
	#BudgetEmployeeFunctionalDepartment
FROM 
	TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment efd
	INNER JOIN TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartmentActive(@DataPriorToDate) efdA ON
		efd.ImportKey = efdA.ImportKey

	-- data limiting join
	INNER JOIN #BudgetEmployee be ON
		efd.BudgetEmployeeId = be.BudgetEmployeeId

PRINT ''Completed inserting records into #BudgetEmployeeFunctionalDepartment:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeeId ON #BudgetEmployeeFunctionalDepartment (BudgetEmployeeId)
PRINT ''Completed creating indexes on #BudgetEmployeeFunctionalDepartment''
PRINT CONVERT(Varchar(27), getdate(), 121)



-- Source Functional Department
SELECT 
	fd.* 
INTO
	#FunctionalDepartment
FROM 
	HR.FunctionalDepartment fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) fdA ON
		fd.ImportKey = fdA.ImportKey

PRINT ''Completed inserting records into #FunctionalDepartment:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_FunctionalDepartmentId ON #FunctionalDepartment (FunctionalDepartmentId)
PRINT ''Completed creating indexes on #FunctionalDepartment''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Property Fund
SELECT 
	PropertyFund.* 
INTO
	#PropertyFund
FROM 
	Gdm.PropertyFund PropertyFund
	INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PropertyFundA ON
		PropertyFund.ImportKey = PropertyFundA.ImportKey 

PRINT ''Completed inserting records into #PropertyFund:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFund (PropertyFundId)
PRINT ''Completed creating indexes on #PropertyFund''
PRINT CONVERT(Varchar(27), getdate(), 121)


-- Source Property Fund Mapping

SELECT 
	PropertyFundMapping.* 
INTO
	#PropertyFundMapping
FROM 
	Gdm.PropertyFundMapping PropertyFundMapping
	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PropertyFundMappingA ON
		PropertyFundMapping.ImportKey = PropertyFundMappingA.ImportKey 

PRINT ''Completed inserting records into #PropertyFundMapping:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFundMapping (PropertyFundCode,SourceCode,IsDeleted,PropertyFundId,ActivityTypeId)
PRINT ''Completed creating indexes on #PropertyFundMapping''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Location
SELECT 
	Location.* 
INTO
	#Location
FROM 
	HR.Location Location
	INNER JOIN HR.LocationActive(@DataPriorToDate) LocationA ON
		Location.ImportKey = LocationA.ImportKey
	
PRINT ''Completed inserting records into #Location:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_LocationId ON #Location (LocationId)
PRINT ''Completed creating indexes on #Location''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source region extended
SELECT 
	RegionExtended.* 
INTO
	#RegionExtended
FROM 
	TapasGlobal.RegionExtended RegionExtended
	INNER JOIN TapasGlobal.RegionExtendedActive(@DataPriorToDate) RegionExtendedA ON
		RegionExtended.ImportKey = RegionExtendedA.ImportKey

PRINT ''Completed inserting records into #RegionExtended:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_RegionId ON #RegionExtended (RegionId)
PRINT ''Completed creating indexes on #RegionExtended''
PRINT CONVERT(Varchar(27), getdate(), 121)


-- Source Payroll Originating Region
SELECT 
	PayrollRegion.* 
INTO
	#PayrollRegion
FROM 
	TapasGlobal.PayrollRegion PayrollRegion
	INNER JOIN TapasGlobal.PayrollRegionActive(@DataPriorToDate) PayrollRegionA ON
		PayrollRegion.ImportKey = PayrollRegionA.ImportKey
	
PRINT ''Completed inserting records into #PayrollRegion:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PayrollRegionId ON #PayrollRegion (PayrollRegionId)
PRINT ''Completed creating indexes on #PayrollRegion''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Overhead Originating Region
SELECT 
	OverheadRegion.* 
INTO
	#OverheadRegion
FROM 
	TapasGlobal.OverheadRegion OverheadRegion
	INNER JOIN TapasGlobal.OverheadRegionActive(@DataPriorToDate) OverheadRegionA ON
		OverheadRegion.ImportKey = OverheadRegionA.ImportKey
	
PRINT ''Completed inserting records into #OverheadRegion:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_OverheadRegionId ON #OverheadRegion (OverheadRegionId)
PRINT ''Completed creating indexes on #OverheadRegion''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source project
SELECT 
	Project.* 
INTO
	#Project
FROM 
	TapasGlobal.Project Project
	INNER JOIN TapasGlobal.ProjectActive(@DataPriorToDate) ProjectA ON
		Project.ImportKey = ProjectA.ImportKey 

PRINT ''Completed inserting records into #Project:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_ProjectId ON #Project (ProjectId)
PRINT ''Completed creating indexes on #Project''
PRINT CONVERT(Varchar(27), getdate(), 121)


------------------------------------------------------------------------------------------------------
--Source allocation records
------------------------------------------------------------------------------------------------------

-- Source payroll allocation
SELECT
	Allocation.*
INTO
	#BudgetEmployeePayrollAllocation
FROM
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocation Allocation

	INNER JOIN TapasGlobalBudgeting.BudgetEmployeePayrollAllocationActive(@DataPriorToDate) AllocationA ON
		Allocation.ImportKey = AllocationA.ImportKey

	--data limiting join
	INNER JOIN #BudgetProject bp ON
		Allocation.BudgetProjectId = bp.BudgetProjectId

PRINT ''Completed inserting records into #BudgetEmployeePayrollAllocation:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationId ON #BudgetEmployeePayrollAllocation (BudgetEmployeePayrollAllocationId)
PRINT ''Completed creating indexes on #BudgetEmployeePayrollAllocation''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source payroll tax detail
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Using the ''active'' function here cause serious performance issues and the only way around it, was to extract the logic from the is active function 
--to seperate peaces of code.
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
SELECT 
	B2.BudgetEmployeePayrollAllocationDetailId,
	MAX(B2.ImportBatchId) as ImportBatchId
Into #BudgetEmployeePayrollAllocationDetailBatches
FROM 
	[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B2
		
	INNER JOIN Batch ON
		B2.ImportBatchId = batch.BatchId
		
WHERE	
	batch.BatchEndDate IS NOT NULL AND
	batch.PackageName = ''ETL.Staging.TapasGlobalBudgeting'' AND
	batch.ImportEndDate <= @DataPriorToDate
		
GROUP BY B2.BudgetEmployeePayrollAllocationDetailId

PRINT ''Completed inserting records into #BudgetEmployeePayrollAllocationDetailBatches:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

SELECT 
	MAX(B1.ImportKey) ImportKey
Into #BEPADa
FROM
	[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B1

	INNER JOIN #BudgetEmployeePayrollAllocationDetailBatches t1 ON 
		t1.BudgetEmployeePayrollAllocationDetailId = B1.BudgetEmployeePayrollAllocationDetailId AND
		t1.ImportBatchId = B1.ImportBatchId

GROUP BY B1.BudgetEmployeePayrollAllocationDetailId

PRINT ''Completed inserting records into #BEPADa:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


SELECT 
	TaxDetail.*
INTO
	#BudgetEmployeePayrollAllocationDetail
FROM
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocationDetail TaxDetail
	
	INNER JOIN #BEPADa TaxDetailA ON
		TaxDetail.ImportKey = TaxDetailA.ImportKey

	--data limiting join
	INNER JOIN #BudgetEmployeePayrollAllocation Allocation ON
		TaxDetail.BudgetEmployeePayrollAllocationId = Allocation.BudgetEmployeePayrollAllocationId

PRINT ''Completed inserting records into #BudgetEmployeePayrollAllocationDetail:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationDetailId ON #BudgetEmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationDetailId)
PRINT ''Completed creating indexes on #BudgetEmployeePayrollAllocationDetail''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget tax type
SELECT 
	BudgetTaxType.* 
INTO
	#BudgetTaxType
FROM 
	TapasGlobalBudgeting.BudgetTaxType BudgetTaxType
	INNER JOIN TapasGlobalBudgeting.BudgetTaxTypeActive(@DataPriorToDate) BudgetTaxTypeA ON
		BudgetTaxType.ImportKey = BudgetTaxTypeA.ImportKey

	-- data limiting join
	INNER JOIN #Budget b ON
		BudgetTaxType.BudgetId = b.BudgetId

PRINT ''Completed inserting records into #BudgetTaxType:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetTaxTypeId ON #BudgetTaxType (BudgetTaxTypeId)
PRINT ''Completed creating indexes on #BudgetTaxType''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source tax type
SELECT 
	TaxType.* 
INTO
	#TaxType
FROM 
	TapasGlobalBudgeting.TaxType TaxType
	INNER JOIN TapasGlobalBudgeting.TaxTypeActive(@DataPriorToDate) TaxTypeA ON
		TaxType.ImportKey = TaxTypeA.ImportKey

PRINT ''Completed inserting records into #TaxType:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source payroll allocation Tax detail
CREATE TABLE #EmployeePayrollAllocationDetail
(
	ImportKey int NOT NULL,
	BudgetEmployeePayrollAllocationDetailId int NOT NULL,
	BudgetEmployeePayrollAllocationId int NOT NULL,
	MinorGlAccountCategoryId int NULL,
	BudgetTaxTypeId int NULL,
	SalaryAmount decimal(18, 2) NULL,
	BonusAmount decimal(18, 2) NULL,
	ProfitShareAmount decimal(18, 2) NULL,
	BonusCapExcessAmount decimal(18, 2) NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	UpdatedByStaffId int NOT NULL
)

INSERT INTO #EmployeePayrollAllocationDetail
(
	ImportKey,
	BudgetEmployeePayrollAllocationDetailId,
	BudgetEmployeePayrollAllocationId,
	MinorGlAccountCategoryId,
	BudgetTaxTypeId,
	SalaryAmount,
	BonusAmount,
	ProfitShareAmount,
	BonusCapExcessAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	TaxDetail.ImportKey,
	TaxDetail.BudgetEmployeePayrollAllocationDetailId,
	TaxDetail.BudgetEmployeePayrollAllocationId,
	CASE WHEN (TaxDetail.BenefitOptionId IS NOT NULL) THEN @BenefitsMinorGlAccountCategoryId ELSE TaxType.MinorGlAccountCategoryId END as MinorGlAccountCategoryId,
	TaxDetail.BudgetTaxTypeId,
	TaxDetail.SalaryAmount,
	TaxDetail.BonusAmount,
	TaxDetail.ProfitShareAmount,
	TaxDetail.BonusCapExcessAmount,
	TaxDetail.InsertedDate,
	TaxDetail.UpdatedDate,
	TaxDetail.UpdatedByStaffId
FROM

	-- Joining on allocation to limit amount of data
	#BudgetEmployeePayrollAllocation Allocation
	
	INNER JOIN 	
		#BudgetEmployeePayrollAllocationDetail TaxDetail ON
			Allocation.BudgetEmployeePayrollAllocationId = TaxDetail.BudgetEmployeePayrollAllocationId 
			
	LEFT OUTER JOIN 
		#BudgetTaxType BudgetTaxType ON
				TaxDetail.BudgetTaxTypeId = BudgetTaxType.BudgetTaxTypeId
				
	LEFT OUTER JOIN 
		#TaxType TaxType ON
			BudgetTaxType.TaxTypeId = TaxType.TaxTypeId	
			
PRINT ''Completed inserting records into #EmployeePayrollAllocationDetail:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #EmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationDetailId,BudgetEmployeePayrollAllocationId)
PRINT ''Completed creating indexes on #EmployeePayrollAllocationDetail''
PRINT CONVERT(Varchar(27), getdate(), 121)

--*/
-- Source payroll overhead allocation
SELECT
	OverheadAllocation.*
INTO
	#BudgetOverheadAllocation
FROM
	TapasGlobalBudgeting.BudgetOverheadAllocation OverheadAllocation
	
	INNER JOIN TapasGlobalBudgeting.BudgetOverheadAllocationActive(@DataPriorToDate) OverheadAllocationA ON
		OverheadAllocation.ImportKey = OverheadAllocationA.ImportKey

	-- data limiting join
	INNER JOIN #Budget b ON
		OverheadAllocation.BudgetId = b.BudgetId

PRINT ''Completed inserting records into #BudgetOverheadAllocation:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocation (BudgetOverheadAllocationId,BudgetId,OverheadRegionId,BudgetEmployeeId)
PRINT ''Completed creating indexes on #BudgetOverheadAllocation''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source overhead allocation detail
SELECT 
	OverheadDetail.*
INTO
	#BudgetOverheadAllocationDetail
FROM			
	TapasGlobalBudgeting.BudgetOverheadAllocationDetail OverheadDetail
	
	INNER JOIN TapasGlobalBudgeting.BudgetOverheadAllocationDetailActive(@DataPriorToDate) OverheadDetailA ON
		OverheadDetail.ImportKey = OverheadDetailA.ImportKey

	-- data limiting join
	INNER JOIN #BudgetProject b ON
		OverheadDetail.BudgetProjectId = b.BudgetProjectId

PRINT ''Completed inserting records into #BudgetOverheadAllocationDetail:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
PRINT ''Completed creating indexes on #BudgetOverheadAllocationDetail''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source payroll overhead allocation detail
CREATE TABLE #OverheadAllocationDetail
(
	ImportKey int NOT NULL,
	BudgetOverheadAllocationDetailId int NOT NULL,
	BudgetOverheadAllocationId int NOT NULL,
	BudgetProjectId int NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	AllocationValue decimal(18, 9) NOT NULL,
	AllocationAmount decimal(18, 2) NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	UpdatedByStaffId int NOT NULL
)

INSERT INTO #OverheadAllocationDetail
(
	ImportKey,
	BudgetOverheadAllocationDetailId,
	BudgetOverheadAllocationId,
	BudgetProjectId,
	MinorGlAccountCategoryId,
	AllocationValue,
	AllocationAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	OverheadDetail.ImportKey,
	OverheadDetail.BudgetOverheadAllocationDetailId,
	OverheadDetail.BudgetOverheadAllocationId,
	OverheadDetail.BudgetProjectId,
	@OverheadMinorGlAccountCategoryId as MinorGlAccountCategoryId,
	OverheadDetail.AllocationValue,
	OverheadDetail.AllocationAmount,
	OverheadDetail.InsertedDate,
	OverheadDetail.UpdatedDate,
	OverheadDetail.UpdatedByStaffId
FROM

	-- Joining on allocation to limit amount of data
	#BudgetOverheadAllocation OverheadAllocation
	
	INNER JOIN 	
		#BudgetOverheadAllocationDetail OverheadDetail ON
			OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId 

PRINT ''Completed inserting records into #OverheadAllocationDetail:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #OverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
PRINT ''Completed creating indexes on #OverheadAllocationDetail''
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Map Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

--Calculate effective functional department
SELECT 
	Allocation.BudgetEmployeePayrollAllocationId,
	Allocation.BudgetEmployeeId,
	(SELECT 
		EFD.FunctionalDepartmentId
	 FROM 
		(SELECT 
			Allocation2.BudgetEmployeeId,
			MAX(EFD.EffectivePeriod) as EffectivePeriod
		 FROM
			#BudgetEmployeePayrollAllocation Allocation2

			INNER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
				Allocation2.BudgetEmployeeId = EFD.BudgetEmployeeId
		
			WHERE
			  Allocation.BudgetEmployeePayrollAllocationId = Allocation2.BudgetEmployeePayrollAllocationId AND
			  EFD.EffectivePeriod <= Allocation.Period
			  
			GROUP BY
				Allocation2.BudgetEmployeeId
		) EFDo
		
			LEFT OUTER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
				EFD.BudgetEmployeeId = EFDo.BudgetEmployeeId AND
				EFD.EffectivePeriod = EFDo.EffectivePeriod
	 ) as FunctionalDepartmentId
INTO
	#EffectiveFunctionalDepartment
FROM
	#BudgetEmployeePayrollAllocation Allocation

	INNER JOIN #BudgetProject BudgetProject ON 
		Allocation.BudgetProjectId = BudgetProject.BudgetProjectId

PRINT ''Completed inserting records into #EffectiveFunctionalDepartment:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Pre Tax Amounts
CREATE TABLE #ProfitabilityPreTaxSource
(
	BudgetId int NOT NULL,
	BudgetRegionId int NOT NULL,
	FirstProjectedPeriod char(6) NOT NULL,
	ProjectId int NOT NULL,
	HrEmployeeId int NOT NULL,
	BudgetEmployeePayrollAllocationId int NOT NULL,
	ReferenceCode varchar(300) NOT NULL,
	ExpensePeriod char(6) NOT NULL,	
	SourceCode varchar(2) NULL,
	SalaryPreTaxAmount money NOT NULL,
	ProfitSharePreTaxAmount money NOT NULL,
	BonusPreTaxAmount money NOT NULL,
	BonusCapExcessPreTaxAmount money NOT NULL,
	FunctionalDepartmentId int NOT NULL,
	FunctionalDepartmentCode varchar(31) NULL,
	Reimbursable bit NULL,
	ActivityTypeId int NOT NULL,
	PropertyFundId int NOT NULL,
	ProjectRegionId int NOT NULL,
	OriginatingRegionCode char(6) NULL,
	OriginatingRegionSourceCode varchar(2) NULL,
	LocalCurrencyCode char(3) NOT NULL,
	AllocationUpdatedDate datetime NOT NULL
)
-- Insert original budget amounts
INSERT INTO #ProfitabilityPreTaxSource
(
	BudgetId,
	BudgetRegionId,
	FirstProjectedPeriod,
	ProjectId,
	HrEmployeeId,
	BudgetEmployeePayrollAllocationId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	SalaryPreTaxAmount,
	ProfitSharePreTaxAmount,
	BonusPreTaxAmount,
	BonusCapExcessPreTaxAmount,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	ProjectRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate
)
SELECT 
	Budget.BudgetId as BudgetId,
	Budget.RegionId as BudgetRegionId,
	Budget.FirstProjectedPeriod,
	IsNull(BudgetProject.ProjectId,0) as ProjectId,
	IsNull(BudgetEmployee.HrEmployeeId,0) as HrEmployeeId,
	Allocation.BudgetEmployeePayrollAllocationId,
	''TGB:BudgetId='' + CONVERT(varchar,Budget.BudgetId) + ''&ProjectId='' + CONVERT(varchar,IsNull(BudgetProject.ProjectId,0)) + ''&HrEmployeeId='' + CONVERT(varchar,IsNull(BudgetEmployee.HrEmployeeId,0)) + ''&BudgetEmployeePayrollAllocationId='' + CONVERT(varchar,Allocation.BudgetEmployeePayrollAllocationId) + ''&BudgetEmployeePayrollAllocationDetailId=0&BudgetOverheadAllocationDetailId=0'' + ''&ImportKey='' + CONVERT(varchar, Allocation.ImportKey) as ReferenceCode,
	Allocation.Period as ExpensePeriod,
	SourceRegion.SourceCode,
	IsNull(Allocation.PreTaxSalaryAmount,0) as SalaryPreTaxAmount,
	IsNull(Allocation.PreTaxProfitShareAmount, 0) as ProfitSharePreTaxAmount,
	IsNull(Allocation.PreTaxBonusAmount,0) as BonusPreTaxAmount, 
	IsNull(Allocation.PreTaxBonusCapExcessAmount,0) as BonusCapExcessPreTaxAmount,
	IsNull(EFD.FunctionalDepartmentId, -1),
	fd.GlobalCode as FunctionalDepartmentCode, 
	CASE WHEN BudgetProject.IsTsCost = 0 THEN 1 ELSE 0 END as Reimbursable,
	BudgetProject.ActivityTypeId,
	IsNull(CASE WHEN (BudgetProject.CorporateDepartmentCode = ''@'' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
				ProjectPropertyFund.PropertyFundId
			ELSE 
				DepartmentPropertyFund.PropertyFundId 
			END, -1) as PropertyFundId,
	-- Same case logic as above
	IsNull(CASE WHEN (BudgetProject.CorporateDepartmentCode = ''@'' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
				ProjectPropertyFund.ProjectRegionId
			ELSE 
				DepartmentPropertyFund.ProjectRegionId 
			END, -1) as ProjectRegionId,
	OriginatingRegion.CorporateEntityRef,
	OriginatingRegion.CorporateSourceCode,
	Budget.CurrencyCode as LocalCurrencyCode,
	Allocation.UpdatedDate
FROM
	#BudgetEmployeePayrollAllocation Allocation

	INNER JOIN #BudgetProject BudgetProject ON 
		Allocation.BudgetProjectId = BudgetProject.BudgetProjectId
			
	INNER JOIN #FilteredModifiedReportBudget fmrb ON
		BudgetProject.BudgetId = fmrb.BudgetId
			
	INNER JOIN #Budget Budget ON 
		fmrb.BudgetId = Budget.BudgetId 
		
	LEFT OUTER JOIN #Region SourceRegion ON 
		Budget.RegionId = SourceRegion.RegionId

	LEFT OUTER JOIN #EffectiveFunctionalDepartment efd ON
		Allocation.BudgetEmployeePayrollAllocationId = efd.BudgetEmployeePayrollAllocationId

	LEFT OUTER JOIN #FunctionalDepartment fd ON 
		efd.FunctionalDepartmentId = fd.FunctionalDepartmentId

	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId

	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON GrSc.SourceCode = BudgetProject.CorporateSourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		BudgetProject.CorporateSourceCode = pfm.SourceCode AND
		--ISNULL(BudgetProject.ActivityTypeId, -1) = ISNULL(pfm.ActivityTypeId, -1) AND 
		pfm.IsDeleted = 0 AND 
		(
		(GrSc.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL) 
		OR
		(
		(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId = BudgetProject.ActivityTypeId)
		OR
		(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
		)
		) 
	
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		pfm.PropertyFundId = DepartmentPropertyFund.PropertyFundId
	
	LEFT OUTER JOIN #BudgetEmployee BudgetEmployee ON
		Allocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId
		
	LEFT OUTER JOIN #Location Location ON 
		Location.LocationId = BudgetEmployee.LocationId
		
	LEFT OUTER JOIN #PayrollRegion OriginatingRegion ON 
		Location.ExternalSubRegionId = OriginatingRegion.ExternalSubRegionId AND
		Budget.RegionId = OriginatingRegion.RegionId

WHERE
	Allocation.Period BETWEEN fmrb.BudgetFirstProjectedPeriod AND fmrb.GroupEndPeriod AND
	BudgetProject.ActivityTypeId <> 99 -- exclude Corporate Overhead

PRINT ''Completed inserting records into #ProfitabilityPreTaxSource:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE INDEX IX_SalaryPreTaxAmount ON #ProfitabilityPreTaxSource (SalaryPreTaxAmount)
CREATE INDEX IX_ProfitSharePreTaxAmount ON #ProfitabilityPreTaxSource (ProfitSharePreTaxAmount)
CREATE INDEX IX_BonusPreTaxAmount ON #ProfitabilityPreTaxSource (BonusPreTaxAmount)
CREATE INDEX IX_BonusCapExcessPreTaxAmount ON #ProfitabilityPreTaxSource (BonusCapExcessPreTaxAmount)
PRINT ''Completed creating indexes on #ProfitabilityPreTaxSource''
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Tax Amounts

CREATE TABLE #ProfitabilityTaxSource
(
	BudgetId int NOT NULL,
	BudgetRegionId int NOT NULL,
	FirstProjectedPeriod char(6) NOT NULL,
	ProjectId int NOT NULL,
	HrEmployeeId int NOT NULL,
	BudgetEmployeePayrollAllocationId int NOT NULL,
	BudgetEmployeePayrollAllocationDetailId int NOT NULL,
	ReferenceCode varchar(300) NOT NULL,
	ExpensePeriod char(6) NOT NULL,	
	SourceCode varchar(2) NULL,
	SalaryTaxAmount money NOT NULL,
	ProfitShareTaxAmount money NOT NULL,
	BonusTaxAmount money NOT NULL,
	BonusCapExcessTaxAmount money NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	FunctionalDepartmentId int NOT NULL,
	FunctionalDepartmentCode varchar(31) NULL,
	Reimbursable bit NULL,
	ActivityTypeId int NOT NULL,
	PropertyFundId int NOT NULL,
	ProjectRegionId int NOT NULL,
	OriginatingRegionCode char(6) NULL,
	OriginatingRegionSourceCode varchar(2) NULL,
	LocalCurrencyCode char(3) NOT NULL,
	AllocationUpdatedDate datetime NOT NULL
)
--/*
-- Insert original budget amounts
INSERT INTO #ProfitabilityTaxSource
(
	BudgetId,
	BudgetRegionId,
	FirstProjectedPeriod,
	ProjectId,
	HrEmployeeId,
	BudgetEmployeePayrollAllocationId,
	BudgetEmployeePayrollAllocationDetailId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	SalaryTaxAmount,
	ProfitShareTaxAmount,
	BonusTaxAmount,
	BonusCapExcessTaxAmount,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	ProjectRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate
)
SELECT 
	pts.BudgetId,
	pts.BudgetRegionId,
	pts.FirstProjectedPeriod,
	IsNull(pts.ProjectId,0) as ProjectId,
	IsNull(pts.HrEmployeeId,0) as HrEmployeeId,
	pts.BudgetEmployeePayrollAllocationId,
	TaxDetail.BudgetEmployeePayrollAllocationDetailId,
	''TGB:BudgetId='' + CONVERT(varchar,pts.BudgetId) + ''&ProjectId='' + CONVERT(varchar,IsNull(pts.ProjectId,0)) + ''&HrEmployeeId='' + CONVERT(varchar,IsNull(pts.HrEmployeeId,0)) + ''&BudgetEmployeePayrollAllocationId='' + CONVERT(varchar,pts.BudgetEmployeePayrollAllocationId) + ''&BudgetEmployeePayrollAllocationDetailId='' + CONVERT(varchar,TaxDetail.BudgetEmployeePayrollAllocationDetailId) + ''&BudgetOverheadAllocationDetailId=0'' + ''&ImportKey='' + CONVERT(varchar, TaxDetail.ImportKey) as ReferenceCode,
	pts.ExpensePeriod,
	pts.SourceCode,
	IsNull(TaxDetail.SalaryAmount, 0) as SalaryTaxAmount,
	IsNull(TaxDetail.ProfitShareAmount, 0) as ProfitShareTaxAmount,
	IsNull(TaxDetail.BonusAmount, 0) as BonusTaxAmount,
	IsNull(TaxDetail.BonusCapExcessAmount, 0) as BonusCapExcessTaxAmount,
	TaxDetail.MinorGlAccountCategoryId,
	IsNull(pts.FunctionalDepartmentId, -1),
	pts.FunctionalDepartmentCode, 
	pts.Reimbursable,
	pts.ActivityTypeId,
	pts.PropertyFundId,
	IsNull(pts.ProjectRegionId, -1),
	pts.OriginatingRegionCode,
	pts.OriginatingRegionSourceCode,
	pts.LocalCurrencyCode,
	pts.AllocationUpdatedDate

FROM

	#EmployeePayrollAllocationDetail TaxDetail 

	INNER JOIN #ProfitabilityPreTaxSource pts ON
		TaxDetail.BudgetEmployeePayrollAllocationId = pts.BudgetEmployeePayrollAllocationId

PRINT ''Completed inserting records into #ProfitabilityTaxSource:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Overhead Amounts

CREATE TABLE #ProfitabilityOverheadSource
(
	BudgetId int NOT NULL,
	FirstProjectedPeriod char(6) NOT NULL,
	ProjectId int NOT NULL,
	HrEmployeeId int NOT NULL,
	BudgetOverheadAllocationDetailId int NOT NULL,
	ReferenceCode varchar(300) NOT NULL,
	ExpensePeriod char(6) NOT NULL,	
	SourceCode varchar(2) NULL,
	OverheadAllocationAmount money NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	FunctionalDepartmentId int NOT NULL,
	FunctionalDepartmentCode varchar(31) NULL,
	Reimbursable bit NULL,
	ActivityTypeId int NOT NULL,
	PropertyFundId int NOT NULL,
	ProjectRegionId int NOT NULL,
	OriginatingRegionCode char(6) NULL,
	OriginatingRegionSourceCode varchar(2) NULL,
	LocalCurrencyCode char(3) NOT NULL,
	OverheadUpdatedDate datetime NOT NULL
)
-- Insert original overhead amounts
INSERT INTO #ProfitabilityOverheadSource
(
	BudgetId,
	FirstProjectedPeriod,
	ProjectId,
	HrEmployeeId,
	BudgetOverheadAllocationDetailId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	OverheadAllocationAmount,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	ProjectRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	OverheadUpdatedDate
)
SELECT
	Budget.BudgetId as BudgetId,
	Budget.FirstProjectedPeriod,
	IsNull(BudgetProject.ProjectId,0) as ProjectId,
	IsNull(BudgetEmployee.HrEmployeeId,0) as HrEmployeeId,
	OverheadDetail.BudgetOverheadAllocationDetailId,
	''TGB:BudgetId='' + CONVERT(varchar,Budget.BudgetId) + ''&ProjectId='' + CONVERT(varchar,IsNull(BudgetProject.ProjectId,0)) + ''&HrEmployeeId='' + CONVERT(varchar,IsNull(BudgetEmployee.HrEmployeeId,0)) + ''&BudgetEmployeePayrollAllocationId=0&BudgetEmployeePayrollAllocationDetailId=0'' + ''&BudgetOverheadAllocationDetailId='' + CONVERT(varchar,OverheadDetail.BudgetOverheadAllocationDetailId) + ''&ImportKey='' + CONVERT(varchar, OverheadDetail.ImportKey) as ReferenceCode,
	OverheadAllocation.BudgetPeriod as ExpensePeriod,
	SourceRegion.SourceCode,
	IsNull(OverheadDetail.AllocationAmount,0) as OverheadAllocationAmount,
	OverheadDetail.MinorGlAccountCategoryId,
	IsNull(RegionExtended.OverheadFunctionalDepartmentId, -1) as FunctionalDepartmentId,
	fd.GlobalCode as FunctionalDepartmentCode, 
	CASE WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
		CASE WHEN (BudgetProject.IsTsCost = 0) THEN -- Where ISTSCost is False the cost will be reimbursable
			1 
		ELSE 
			0
		END
	ELSE 
		0  --Where the BudgetProject.OverheadAllocationProjectID is populated: non-reimbursable
	END as Reimbursable,
	BudgetProject.ActivityTypeId,
	
	CASE WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
		IsNull(CASE WHEN (BudgetProject.CorporateDepartmentCode = ''@'' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.PropertyFundId
				ELSE 
					DepartmentPropertyFund.PropertyFundId 
				END, -1) 
	ELSE 
		IsNull(OverheadPropertyFund.PropertyFundId, -1) 
	END as PropertyFundId,
	-- Same case logic as above
	CASE WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
		IsNull(CASE WHEN (BudgetProject.CorporateDepartmentCode = ''@'' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.ProjectRegionId
				ELSE 
					DepartmentPropertyFund.ProjectRegionId 
				END, -1) 
	ELSE 
		IsNull(OverheadPropertyFund.ProjectRegionId, -1) 
	END as ProjectRegionId,
	
	OriginatingRegion.CorporateEntityRef,
	OriginatingRegion.CorporateSourceCode,
	Budget.CurrencyCode as LocalCurrencyCode,
	OverheadDetail.UpdatedDate

FROM

	#BudgetOverheadAllocation OverheadAllocation 

	INNER JOIN #BudgetEmployee BudgetEmployee ON
		OverheadAllocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId

	INNER JOIN #OverheadAllocationDetail OverheadDetail ON
		OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId
			
	INNER JOIN #BudgetProject BudgetProject ON 
		OverheadDetail.BudgetProjectId = BudgetProject.BudgetProjectId
		
	INNER JOIN #FilteredModifiedReportBudget fmrb ON
		BudgetProject.BudgetId = fmrb.BudgetId
		
	INNER JOIN #Budget Budget ON 
		fmrb.BudgetId = Budget.BudgetId
		
	LEFT OUTER JOIN #Region SourceRegion ON 
		Budget.RegionId = SourceRegion.RegionId
		
	LEFT OUTER JOIN #RegionExtended RegionExtended ON 
		SourceRegion.RegionId = RegionExtended.RegionId

	LEFT OUTER JOIN #FunctionalDepartment fd ON 
		RegionExtended.OverheadFunctionalDepartmentId = fd.FunctionalDepartmentId

	LEFT OUTER JOIN	#Project OverheadProject ON
		BudgetProject.AllocateOverheadsProjectId = OverheadProject.ProjectId

	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId
	
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON GrSc.SourceCode = BudgetProject.CorporateSourceCode
	
	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		BudgetProject.CorporateSourceCode = pfm.SourceCode AND
		--ISNULL(BudgetProject.ActivityTypeId, -1) = ISNULL(pfm.ActivityTypeId, -1) AND 
		pfm.IsDeleted = 0 AND 
		(
		(GrSc.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL) 
		OR
		(
		(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId = BudgetProject.ActivityTypeId)
		OR
		(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
		)
		) 
	
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		pfm.PropertyFundId = DepartmentPropertyFund.PropertyFundId

	LEFT OUTER JOIN GrReporting.dbo.Source GrScO ON GrScO.SourceCode = OverheadProject.CorporateSourceCode

	LEFT OUTER JOIN #PropertyFundMapping opfm ON
		OverheadProject.CorporateDepartmentCode = opfm.PropertyFundCode AND -- Combination of entity and corporate department
		OverheadProject.CorporateSourceCode = opfm.SourceCode AND
		--ISNULL(BudgetProject.ActivityTypeId, -1) = ISNULL(opfm.ActivityTypeId, -1) AND 
		opfm.IsDeleted = 0 AND 
		(
		(GrScO.IsProperty = ''YES'' AND opfm.ActivityTypeId IS NULL) 
		OR
		(
		(GrScO.IsCorporate = ''YES'' AND opfm.ActivityTypeId = BudgetProject.ActivityTypeId)
		OR
		(GrScO.IsCorporate = ''YES'' AND opfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
		)
		) 
	
	LEFT OUTER JOIN 
		#PropertyFund OverheadPropertyFund ON
				opfm.PropertyFundId = OverheadPropertyFund.PropertyFundId
	
	LEFT OUTER JOIN #OverheadRegion OriginatingRegion ON 
		OverheadAllocation.OverheadRegionId = OriginatingRegion.OverheadRegionId
		
WHERE
	OverheadAllocation.BudgetPeriod BETWEEN fmrb.BudgetFirstProjectedPeriod AND fmrb.GroupEndPeriod
		
PRINT ''Completed inserting records into #ProfitabilityOverheadSource:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Generate mapping records
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


CREATE TABLE #ProfitabilityPayrollMapping
(
	BudgetId int NOT NULL,
	ReferenceCode varchar(300) NOT NULL,
	FirstProjectedPeriod char(6) NOT NULL,
	ExpensePeriod char(6) NOT NULL,	
	SourceCode varchar(2) NULL,
	BudgetAmount money NOT NULL,
	MajorGlAccountCategoryId int NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	FunctionalDepartmentId int NOT NULL,
	FunctionalDepartmentCode varchar(31) NULL,
	Reimbursable bit NOT NULL,
	ActivityTypeId int NOT NULL,
	PropertyFundId int NOT NULL,
	ProjectRegionId int NOT NULL,
	OriginatingRegionCode char(6) NULL,
	OriginatingRegionSourceCode varchar(2) NULL,
	LocalCurrencyCode char(3) NOT NULL,
	AllocationUpdatedDate datetime NOT NULL
)

INSERT INTO #ProfitabilityPayrollMapping
(
	BudgetId,
	ReferenceCode,
	FirstProjectedPeriod,
	ExpensePeriod,
	SourceCode,
	BudgetAmount,
	MajorGlAccountCategoryId,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	ProjectRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate
)
-- Get Base Salary Payroll pre tax mappings and budget
SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=SalaryPreTax'' as ReferenceCode,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.SalaryPreTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	@BaseSalaryMinorGlAccountCategoryId as MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityPreTaxSource pps
WHERE
	pps.SalaryPreTaxAmount <> 0

-- Get Profit Share Benefit pre tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=ProfitSharePreTax'' as ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.ProfitSharePreTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	@ProfitShareMinorGlAccountCategoryId as MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityPreTaxSource pps
WHERE
	pps.ProfitSharePreTaxAmount <> 0

-- Get Bonus pre tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=BonusPreTax'' as ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusPreTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	@BonusMinorGlAccountCategoryId as MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityPreTaxSource pps
WHERE
	pps.BonusPreTaxAmount <> 0

--Get bonus cap pre tax mappings
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=BonusCapExcessPreTax'' as ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusCapExcessPreTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	@BonusMinorGlAccountCategoryId as MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	0 as Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
	IsNull(p.ActivityTypeId, -1) as ActivityTypeId,
	IsNull(CASE WHEN (p.CorporateDepartmentCode = ''@'' OR p.CorporateDepartmentCode IS NULL) THEN 
				ProjectPropertyFund.PropertyFundId
			ELSE 
				DepartmentPropertyFund.PropertyFundId 
			END, -1) as PropertyFundId,
	-- Same case logic as above
	IsNull(CASE WHEN (p.CorporateDepartmentCode = ''@'' OR p.CorporateDepartmentCode IS NULL) THEN 
				ProjectPropertyFund.ProjectRegionId
			ELSE 
				DepartmentPropertyFund.ProjectRegionId 
			END, -1) as ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityPreTaxSource pps
	
	LEFT OUTER JOIN #SystemSettingRegion ssr ON
		pps.SourceCode = ssr.SourceCode AND
		pps.BudgetRegionId = ssr.RegionId AND
		ssr.SystemSettingName = ''BonusCapExcess''
		
	LEFT OUTER JOIN 
		#Project p ON
			ssr.BonusCapExcessProjectId = p.ProjectId
			
	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		p.PropertyFundId = ProjectPropertyFund.PropertyFundId
		
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON GrSc.SourceCode = p.CorporateSourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		p.CorporateSourceCode = pfm.SourceCode AND
		--ISNULL(p.ActivityTypeId, -1) = ISNULL(pfm.ActivityTypeId, -1) AND 
		pfm.IsDeleted = 0 AND 
		(
		(GrSc.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL) 
		OR
		(
		(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId = p.ActivityTypeId)
		OR
		(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
		)
		) 
	
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		pfm.PropertyFundId = DepartmentPropertyFund.PropertyFundId
		
WHERE
	pps.BonusCapExcessPreTaxAmount <> 0

UNION ALL

-- Get Base Salary Payroll Tax mappings and budget
SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=SalaryTax'' as ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.SalaryTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.SalaryTaxAmount <> 0

-- Get Profit Share Benefit Tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=ProfitShareTax'' as ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.ProfitShareTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.ProfitShareTaxAmount <> 0

-- Get Bonus Tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=BonusTax'' as ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.BonusTaxAmount <> 0

-- Get Bonus cap Tax mappings 
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=BonusCapExcessTax'' as ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusCapExcessTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	0 as Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
	IsNull(p.ActivityTypeId, -1) as ActivityTypeId,
	IsNull(CASE WHEN (p.CorporateDepartmentCode = ''@'' OR p.CorporateDepartmentCode IS NULL) THEN 
				ProjectPropertyFund.PropertyFundId
			ELSE 
				DepartmentPropertyFund.PropertyFundId 
			END, -1) as PropertyFundId,
	-- Same case logic as above
	IsNull(CASE WHEN (p.CorporateDepartmentCode = ''@'' OR p.CorporateDepartmentCode IS NULL) THEN 
				ProjectPropertyFund.ProjectRegionId
			ELSE 
				DepartmentPropertyFund.ProjectRegionId 
			END, -1) as ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityTaxSource pps

	LEFT OUTER JOIN #SystemSettingRegion ssr ON
		pps.SourceCode = ssr.SourceCode AND
		pps.BudgetRegionId = ssr.RegionId AND
		ssr.SystemSettingName = ''BonusCapExcess''

	LEFT OUTER JOIN #Project p ON
		ssr.BonusCapExcessProjectId = p.ProjectId

	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		p.PropertyFundId = ProjectPropertyFund.PropertyFundId

	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON GrSc.SourceCode = p.CorporateSourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		p.CorporateSourceCode = pfm.SourceCode AND
		--ISNULL(p.ActivityTypeId, -1) = ISNULL(pfm.ActivityTypeId, -1) AND 
		pfm.IsDeleted = 0 AND 
		(
		(GrSc.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL) 
		OR
		(
		(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId = p.ActivityTypeId)
		OR
		(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
		)
		) 
	
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		pfm.PropertyFundId = DepartmentPropertyFund.PropertyFundId

WHERE
	pps.BonusCapExcessTaxAmount <> 0
	
-- Get Overhead mappings	
UNION ALL

SELECT
	pos.BudgetId,
	pos.ReferenceCode + ''&Type=OverheadAllocation'' as ReferenceCod,
	pos.FirstProjectedPeriod,
	pos.ExpensePeriod,
	pos.SourceCode,
	pos.OverheadAllocationAmount as BudgetAmount,
	@OccupancyCostsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	pos.MinorGlAccountCategoryId, 
	pos.FunctionalDepartmentId,
	pos.FunctionalDepartmentCode,
	pos.Reimbursable,  
	pos.ActivityTypeId,
	pos.PropertyFundId,
	pos.ProjectRegionId,
	pos.OriginatingRegionCode,
	pos.OriginatingRegionSourceCode,
	pos.LocalCurrencyCode,
	pos.OverheadUpdatedDate
FROM
	#ProfitabilityOverheadSource pos
WHERE
	pos.OverheadAllocationAmount <> 0

PRINT ''Completed inserting records into #ProfitabilityPayrollMapping:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_AllocationUpdatedDate ON #ProfitabilityPayrollMapping(ReferenceCode,AllocationUpdatedDate)
PRINT ''Completed creating indexes on #ProfitabilityPayrollMapping''
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Map mapped source data into the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

------------------------------------------------------------------------------------------------------
-- Additional required mappings
------------------------------------------------------------------------------------------------------

-- Originating region mapping
Select Orm.ImportKey,Orm.OriginatingRegionMappingId,Orm.GlobalRegionId,Orm.SourceCode,Orm.RegionCode,Orm.InsertedDate,Orm.UpdatedDate,Orm.IsDeleted
Into #OriginatingRegionMapping
From Gdm.OriginatingRegionMapping Orm 
		INNER JOIN Gdm.OriginatingRegionMappingActive(@DataPriorToDate) OrmA ON OrmA.ImportKey = Orm.ImportKey


PRINT ''Completed inserting records into #OriginatingRegionMapping:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #OriginatingRegionMapping (RegionCode,SourceCode,IsDeleted,GlobalRegionId)
PRINT ''Completed creating indexes on #OriginatingRegionMapping''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- See hack below. 
Select Arm.ImportKey,Arm.AllocationRegionMappingId,Arm.GlobalRegionId,Arm.SourceCode,Arm.RegionCode,Arm.InsertedDate,Arm.UpdatedDate,Arm.IsDeleted
Into #AllocationRegionMapping
From Gdm.AllocationRegionMapping Arm 
	INNER JOIN Gdm.AllocationRegionMappingActive(@DataPriorToDate) ArmA ON ArmA.ImportKey = Arm.ImportKey

PRINT ''Completed inserting records into #AllocationRegionMapping:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


------------------------------------------------------------------------------------------------------
-- Map to the fact
------------------------------------------------------------------------------------------------------
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--If the join is not possible, default the link to the ''UNKNOWN'' link
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityReforecast(
	CalendarKey int NOT NULL,
	ReforecastKey int NOT NULL,
	GlAccountKey int NOT NULL,
	SourceKey int NOT NULL,
	FunctionalDepartmentKey int NOT NULL,
	ReimbursableKey int NOT NULL,
	ActivityTypeKey int NOT NULL,
	PropertyFundKey int NOT NULL,	
	AllocationRegionKey int NOT NULL,
	OriginatingRegionKey int NOT NULL,
	LocalCurrencyKey int NOT NULL,
	LocalReforecast money NOT NULL,
	ReferenceCode Varchar(300) NOT NULL,
	BudgetId int NOT NULL,
	SourceSystemId int NOT NULL,
	
	EUCorporateGlAccountCategoryKey int NULL,
	EUPropertyGlAccountCategoryKey int NULL,
	EUFundGlAccountCategoryKey int NULL,

	USPropertyGlAccountCategoryKey int NULL,
	USCorporateGlAccountCategoryKey int NULL,
	USFundGlAccountCategoryKey int NULL,

	GlobalGlAccountCategoryKey int NULL,
	DevelopmentGlAccountCategoryKey int NULL
) 

INSERT INTO #ProfitabilityReforecast 
(
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	SourceSystemId
)
SELECT
		DATEDIFF(dd, ''1900-01-01'', LEFT(pbm.ExpensePeriod,4)+''-''+RIGHT(pbm.ExpensePeriod,2)+''-01'') as CalendarKey
		,DATEDIFF(dd, ''1900-01-01'', LEFT(pbm.FirstProjectedPeriod,4)+''-''+RIGHT(pbm.FirstProjectedPeriod,2)+''-01'') as ReforecastKey
		,@GlAccountKey GlAccountKey
		,CASE WHEN GrSc.[SourceKey] IS NULL THEN @SourceKey ELSE GrSc.[SourceKey] END SourceKey
		,CASE WHEN GrFdm.[FunctionalDepartmentKey] IS NULL THEN @FunctionalDepartmentKey ELSE GrFdm.[FunctionalDepartmentKey] END FunctionalDepartmentKey
		,CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKey ELSE GrRi.ReimbursableKey END ReimbursableKey
		,CASE WHEN GrAt.[ActivityTypeKey] IS NULL THEN @ActivityTypeKey ELSE GrAt.[ActivityTypeKey] END ActivityTypeKey
		,CASE WHEN GrPf.[PropertyFundKey] IS NULL THEN @PropertyFundKey ELSE GrPf.[PropertyFundKey] END PropertyFundKey
		,CASE WHEN GrAr.[AllocationRegionKey] IS NULL THEN @AllocationRegionKey ELSE GrAr.[AllocationRegionKey] END AllocationRegionKey
		,CASE WHEN GrOr.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKey ELSE GrOr.[OriginatingRegionKey] END OriginatingRegionKey
		,CASE WHEN GrCu.[CurrencyKey] IS NULL THEN @LocalCurrencyKey ELSE GrCu.[CurrencyKey] END LocalCurrencyKey
		,pbm.BudgetAmount
		,pbm.ReferenceCode
		,pbm.BudgetId
		,@SourceSystemId
FROM
	#ProfitabilityPayrollMapping pbm
	
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON
		pbm.SourceCode = GrSc.SourceCode

	--Parent Level (No job code for payroll)
	LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdm ON
		GrFdm.ReferenceCode LIKE pbm.FunctionalDepartmentCode +'':%'' AND
		pbm.AllocationUpdatedDate BETWEEN GrFdm.StartDate AND GrFdm.EndDate AND
		GrFdm.SubFunctionalDepartmentCode = GrFdm.FunctionalDepartmentCode

	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		CASE WHEN pbm.Reimbursable = 1 THEN ''YES'' ELSE ''NO'' END = GrRi.ReimbursableCode

	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		pbm.ActivityTypeId = GrAt.ActivityTypeId AND
		pbm.AllocationUpdatedDate BETWEEN GrAt.StartDate AND GrAt.EndDate

	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		pbm.PropertyFundId = GrPf.PropertyFundId AND
		pbm.AllocationUpdatedDate BETWEEN GrPf.StartDate AND GrPf.EndDate

	-- HACK: At some point tapas was supposed to pull project region out of GDM. 
	-- Now allocation regions are source based??? So I use the code because it is built up from the ProjectRegionId since there is only data for one source anyway.
	-- I don''t check source because actuals also don''t check source. 
	LEFT OUTER JOIN #AllocationRegionMapping Arm ON
		Arm.RegionCode = pbm.ProjectRegionId AND -- TODO: Pull the RegionCode through from the top.
		Arm.IsDeleted = 0

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		Arm.GlobalRegionId = GrAr.GlobalRegionId AND
		pbm.AllocationUpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate

/* -- At some point Allocation region in GDM was going to become the master list
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		pbm.ProjectRegionId = GrAr.GlobalRegionId AND
		pbm.AllocationUpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate
*/

	LEFT OUTER JOIN #OriginatingRegionMapping Orm ON
		Orm.RegionCode = CASE WHEN RIGHT(pbm.OriginatingRegionSourceCode,1) = ''C'' THEN LTRIM(RTRIM(pbm.OriginatingRegionCode))
								ELSE LTRIM(RTRIM(pbm.OriginatingRegionCode)) + LTRIM(RTRIM(pbm.FunctionalDepartmentCode)) END AND
		Orm.SourceCode = pbm.OriginatingRegionSourceCode AND
		Orm.IsDeleted = 0
		
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		GrOr.GlobalRegionId = Orm.GlobalRegionId AND
		pbm.AllocationUpdatedDate BETWEEN GrOr.StartDate AND GrOr.EndDate
	
	LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
		pbm.LocalCurrencyCode = GrCu.CurrencyCode 

PRINT ''Completed inserting records into #ProfitabilityReforecast:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProfitabilityReforecast (ReferenceCode)
CREATE INDEX IX_CalendarKey ON #ProfitabilityReforecast (CalendarKey)

PRINT ''Completed creating indexes on #OriginatingRegionMapping''
PRINT CONVERT(Varchar(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Remove existing data for modified budget projects
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #DeletingBudget
(
	BudgetId int NOT NULL
)

INSERT INTO #DeletingBudget
(
	BudgetId
)
SELECT DISTINCT 
	BudgetId
FROM
	#Budget

DECLARE @BudgetId int = -1
DECLARE @LoopCount int = 0 -- Infinite loop safe guard
WHILE (EXISTS (SELECT TOP 1 BudgetId FROM #DeletingBudget) AND @LoopCount < 100000)
BEGIN
	
	SET @LoopCount = @LoopCount + 1
	
	SET @BudgetId = (SELECT TOP 1 BudgetId FROM #DeletingBudget)

	-- Remove old facts
	DELETE 
	FROM GrReporting.dbo.ProfitabilityReforecast 
	Where BudgetId = @BudgetId and SourceSystemId = @SourceSystemId
	
	PRINT ''Completed deleting records from ProfitabilityReforecast:''+CONVERT(char(10),@@rowcount)
	PRINT CONVERT(Varchar(27), getdate(), 121)

	DELETE FROM #DeletingBudget WHERE BudgetId = @BudgetId
END

print ''Cleaned up rows in ProfitabilityReforecast''

------------------------------------------------------------------------------------------------------
-- Map account categories
------------------------------------------------------------------------------------------------------
--EUCorporateGlAccountCategoryKey

Select 
		GlAcEUCorp.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #EUCorpCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl
				CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = ''EU Corporate'') GlAcHg
		) Gl
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUCorp ON GlAcEUCorp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+'':''+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+'':''+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate  BETWEEN GlAcEUCorp.StartDate AND GlAcEUCorp.EndDate
				
CREATE UNIQUE CLUSTERED INDEX IX ON #EUCorpCategoryLookup (ReferenceCode)

Update #ProfitabilityReforecast
SET	EUCorporateGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @EUCorporateGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END 
From #EUCorpCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode


PRINT ''Completed converting all EUCorporateGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--EUPropertyGlAccountCategoryKey
Select 
		GlAcEUProp.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #EUPropCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl
				CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = ''EU Property'') GlAcHg
		) Gl
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUProp ON GlAcEUProp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+'':''+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+'':''+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate  BETWEEN GlAcEUProp.StartDate AND GlAcEUProp.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #EUPropCategoryLookup (ReferenceCode)

Update #ProfitabilityReforecast
SET	EUPropertyGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @EUPropertyGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END
From #EUPropCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode


PRINT ''Completed converting all EUPropertyGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--EUFundGlAccountCategoryKey
Select 
		GlAcEUFund.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #EUFundCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl
				CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = ''EU Fund'') GlAcHg
		) Gl
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUFund ON GlAcEUFund.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+'':''+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+'':''+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate BETWEEN GlAcEUFund.StartDate AND GlAcEUFund.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #EUFundCategoryLookup (ReferenceCode)

Update #ProfitabilityReforecast
SET EUFundGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @EUFundGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END
From #EUFundCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode

	
PRINT ''Completed converting all EUFundGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--USPropertyGlAccountCategoryKey
Select 
		GlAcUSProp.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #USPropCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl
				CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = ''US Property'') GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSProp ON GlAcUSProp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+'':''+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+'':''+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate  BETWEEN GlAcUSProp.StartDate AND GlAcUSProp.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #USPropCategoryLookup (ReferenceCode)

Update #ProfitabilityReforecast
SET	USPropertyGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @USPropertyGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END
From #USPropCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode

PRINT ''Completed converting all USPropertyGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


--USCorporateGlAccountCategoryKey
Select 
		GlAcUSCorp.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #USCorpCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl				
			CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = ''US Corporate'') GlAcHg
		) Gl

		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSCorp ON GlAcUSCorp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+'':''+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+'':''+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate  BETWEEN GlAcUSCorp.StartDate AND GlAcUSCorp.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #USCorpCategoryLookup (ReferenceCode)

Update #ProfitabilityReforecast
SET	USCorporateGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @USCorporateGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END
From #USCorpCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode


PRINT ''Completed converting all USCorporateGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--USFundGlAccountCategoryKey
Select 
		GlAcUSFund.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #USFundCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl				
				CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = ''US Fund'') GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSFund ON GlAcUSFund.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+'':''+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+'':''+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate  BETWEEN GlAcUSFund.StartDate AND GlAcUSFund.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #USFundCategoryLookup (ReferenceCode)

Update #ProfitabilityReforecast
SET	USFundGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @USFundGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END
From #USFundCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode


PRINT ''Completed converting all USFundGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

		
--GlobalGlAccountCategoryKey
Select 
		GlAcGlobal.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #GlobalCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl				
				CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = ''Global'') GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcGlobal ON GlAcGlobal.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+'':''+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+'':''+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate  BETWEEN GlAcGlobal.StartDate AND GlAcGlobal.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #GlobalCategoryLookup (ReferenceCode)

Update #ProfitabilityReforecast
SET	GlobalGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END
From #GlobalCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode



PRINT ''Completed converting all GlobalGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--DevelopmentGlAccountCategoryKey
Select 
		GlAcDevel.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #DevelCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl				
				CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = ''Development'') GlAcHg
		) Gl

		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcDevel ON GlAcDevel.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+'':''+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+'':''+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate  BETWEEN GlAcDevel.StartDate AND GlAcDevel.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #DevelCategoryLookup (ReferenceCode)

Update #ProfitabilityReforecast
SET	DevelopmentGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @DevelopmentGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END
From #DevelCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode


PRINT ''Completed converting all DevelopmentGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Insert modified and new data 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

INSERT INTO GrReporting.dbo.ProfitabilityReforecast
(
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
)
SELECT
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
FROM 
	#ProfitabilityReforecast

print ''Rows Inserted in ProfitabilityReforecast:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Clean up
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Setup data
DROP TABLE #SystemSettingRegion
DROP TABLE #AllActiveBudget
DROP TABLE #AllModifiedReportBudget
DROP TABLE #FilteredModifiedReportBudget
DROP TABLE #LockedModifiedReportGroup
DROP TABLE #Budget
DROP TABLE #BudgetStatus
DROP TABLE #BudgetReportGroupPeriod
DROP TABLE #BudgetReportGroupDetail
DROP TABLE #BudgetReportGroup
-- Source data
DROP TABLE #BudgetEmployeePayrollAllocation
DROP TABLE #BEPADa
drop table #BudgetEmployeePayrollAllocationDetailBatches
DROP TABLE #BudgetEmployeePayrollAllocationDetail
DROP TABLE #BudgetTaxType
DROP TABLE #TaxType
DROP TABLE #EmployeePayrollAllocationDetail
DROP TABLE #BudgetOverheadAllocation
DROP TABLE #BudgetOverheadAllocationDetail
DROP TABLE #OverheadAllocationDetail
DROP TABLE #BudgetProject
DROP TABLE #Region
DROP TABLE #BudgetEmployeeFunctionalDepartment
DROP TABLE #BudgetEmployee
DROP TABLE #FunctionalDepartment
DROP TABLE #PropertyFund
DROP TABLE #PropertyFundMapping
DROP TABLE #Location
DROP TABLE #RegionExtended
DROP TABLE #PayrollRegion
DROP TABLE #OverheadRegion
DROP TABLE #Project
-- Mapping mapping
DROP TABLE #EffectiveFunctionalDepartment
DROP TABLE #ProfitabilityPreTaxSource
DROP TABLE #ProfitabilityTaxSource
DROP TABLE #ProfitabilityOverheadSource
DROP TABLE #ProfitabilityPayrollMapping
DROP TABLE #ProfitabilityReforecast
DROP TABLE #DeletingBudget
-- Account Category Mapping
DROP TABLE #GlobalGlAccountCategoryHierarchyGroup
DROP TABLE #MajorGlAccountCategory
DROP TABLE #MinorGlAccountCategory
-- Additional Mappings
DROP TABLE #OriginatingRegionMapping
DROP TABLE #AllocationRegionMapping
-- Hierarchy Lookups
DROP TABLE #EUCorpCategoryLookup
DROP TABLE #EUPropCategoryLookup
DROP TABLE #EUFundCategoryLookup
DROP TABLE #USCorpCategoryLookup
DROP TABLE #USPropCategoryLookup
DROP TABLE #USFundCategoryLookup
DROP TABLE #GlobalCategoryLookup
DROP TABLE #DevelCategoryLookup

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]    Script Date: 08/05/2010 15:11:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]

	@ImportStartDate	DateTime,
	@ImportEndDate		DateTime,
	@DataPriorToDate	DateTime=NULL
AS

SET NOCOUNT ON
IF @DataPriorToDate IS NULL 
	SET @DataPriorToDate = GETDATE()

PRINT ''####''
PRINT ''stp_IU_LoadGrProfitabiltyPayrollOriginalBudget''
PRINT ''####''

	
/*
[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]
	@ImportStartDate	= ''1900-01-01'',
	@ImportEndDate		= ''2010-12-31'',
	@DataPriorToDate	= ''2010-12-31''
*/ 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Setup mapping variables
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--/*
-- Setup Bonus Cap Excess Project Setting

CREATE TABLE #SystemSettingRegion
(
	SystemSettingId int NOT NULL,
	SystemSettingName varchar(50) NOT NULL,
	SystemSettingRegionId int NOT NULL,
	RegionId int,
	SourceCode varchar(2),
	BonusCapExcessProjectId int
)
INSERT INTO #SystemSettingRegion
(
	SystemSettingId,
	SystemSettingName,
	SystemSettingRegionId,
	RegionId,
	SourceCode,
	BonusCapExcessProjectId
)

SELECT 
	ss.SystemSettingId,
	ss.Name,
	ssr.SystemSettingRegionId,
	ssr.RegionId,
	ssr.SourceCode,
	ssr.BonusCapExcessProjectId
FROM
	(SELECT 
		ssr.* 
	 FROM TapasGlobal.SystemSettingRegion ssr
		INNER JOIN TapasGlobal.SystemSettingRegionActive(@DataPriorToDate) ssrA
			ON ssr.ImportKey = ssrA.ImportKey
	 ) ssr
	INNER JOIN
		(SELECT
			ss.SystemSettingId,
			ss.Name
		 FROM
			(SELECT	
				ss.*
			 FROM TapasGlobal.SystemSetting ss
					INNER JOIN TapasGlobal.SystemSettingActive(@DataPriorToDate) ssA 
						ON ss.ImportKey = ssA.ImportKey
			 ) ss

		  ) ss ON ssr.SystemSettingId = ss.SystemSettingId
PRINT ''Completed getting system settings''
PRINT CONVERT(Varchar(27), getdate(), 121)

--*/
-- Setup account categories and default to UNKNOWN.
DECLARE 
		@SalariesTaxesBenefitsMajorGlAccountCategoryId	 int = -1,
		@BaseSalaryMinorGlAccountCategoryId				 int = -1,
		@BenefitsMinorGlAccountCategoryId				 int = -1,
		@BonusMinorGlAccountCategoryId					 int = -1,
		@ProfitShareMinorGlAccountCategoryId			 int = -1,
		@OccupancyCostsMajorGlAccountCategoryId			 int = -1,
		@OverheadMinorGlAccountCategoryId				 int = -1

DECLARE 
      @GlAccountKey				Int = (Select GlAccountKey From GrReporting.dbo.GlAccount Where GlAccountCode = ''UNKNOWN''),
      @SourceKey				Int = (Select SourceKey From GrReporting.dbo.Source Where SourceName = ''UNKNOWN''),
      @FunctionalDepartmentKey	Int = (Select FunctionalDepartmentKey From GrReporting.dbo.FunctionalDepartment Where FunctionalDepartmentCode = ''UNKNOWN''),
      @ReimbursableKey			Int = (Select ReimbursableKey From GrReporting.dbo.Reimbursable Where ReimbursableCode = ''UNKNOWN''),
      @ActivityTypeKey			Int = (Select ActivityTypeKey From GrReporting.dbo.ActivityType Where ActivityTypeCode = ''UNKNOWN''),
      @PropertyFundKey			Int = (Select PropertyFundKey From GrReporting.dbo.PropertyFund Where PropertyFundName = ''UNKNOWN''),
      @AllocationRegionKey		Int = (Select AllocationRegionKey From GrReporting.dbo.AllocationRegion Where RegionCode = ''UNKNOWN''),
      @OriginatingRegionKey		Int = (Select OriginatingRegionKey From GrReporting.dbo.OriginatingRegion Where RegionCode = ''UNKNOWN''),
      @LocalCurrencyKey			Int = (Select CurrencyKey From GrReporting.dbo.Currency Where CurrencyCode = ''UNKNOWN'')

DECLARE	@EUFundGlAccountCategoryKey						Int,
		@EUCorporateGlAccountCategoryKey				Int,
		@EUPropertyGlAccountCategoryKey					Int,
		@USFundGlAccountCategoryKey						Int,
		@USPropertyGlAccountCategoryKey					Int,
		@USCorporateGlAccountCategoryKey				Int,
		@DevelopmentGlAccountCategoryKey				Int,
		@GlobalGlAccountCategoryKey						Int

SET @EUFundGlAccountCategoryKey			= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = ''EU Fund'' AND MajorName = ''UNKNOWN'' AND MinorName = ''UNKNOWN'')
SET @EUCorporateGlAccountCategoryKey	= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = ''EU Corporate'' AND MajorName = ''UNKNOWN'' AND MinorName = ''UNKNOWN'')
SET @EUPropertyGlAccountCategoryKey		= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = ''EU Property'' AND MajorName = ''UNKNOWN'' AND MinorName = ''UNKNOWN'')
SET @USFundGlAccountCategoryKey			= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = ''US Fund'' AND MajorName = ''UNKNOWN'' AND MinorName = ''UNKNOWN'')
SET @USPropertyGlAccountCategoryKey		= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = ''US Property'' AND MajorName = ''UNKNOWN'' AND MinorName = ''UNKNOWN'')
SET @USCorporateGlAccountCategoryKey	= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = ''US Corporate'' AND MajorName = ''UNKNOWN'' AND MinorName = ''UNKNOWN'')
SET @DevelopmentGlAccountCategoryKey	= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = ''Development'' AND MajorName = ''UNKNOWN'' AND MinorName = ''UNKNOWN'')
SET @GlobalGlAccountCategoryKey			= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = ''Global'' AND MajorName = ''UNKNOWN'' AND MinorName = ''UNKNOWN'')
		
-- Set gl account categories
SELECT TOP 1 @SalariesTaxesBenefitsMajorGlAccountCategoryId = MajorGlAccountCategoryId 
FROM Gr.GetGlobalGlAccountCategoryHierarchy(@DataPriorToDate) 
WHERE MajorGlAccountCategoryName = ''Salaries/Taxes/Benefits''
--NB!!!!!!!
--The roll up to payroll is very sensitive information. It is crutial that information regarding payroll not get 
--communicated to TS employees on certain reports. Changing the category name here will have ramifications because 
--some reports check for this name.
--NB!!!!!!!

SELECT @BaseSalaryMinorGlAccountCategoryId = MinorGlAccountCategoryId 
FROM Gr.GetGlobalGlAccountCategoryHierarchy(@DataPriorToDate) 
WHERE MajorGlAccountCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	  MinorGlAccountCategoryName = ''Base Salary''

SELECT @BenefitsMinorGlAccountCategoryId = MinorGlAccountCategoryId 
FROM Gr.GetGlobalGlAccountCategoryHierarchy(@DataPriorToDate) 
WHERE MajorGlAccountCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	  MinorGlAccountCategoryName = ''Benefits''

SELECT @BonusMinorGlAccountCategoryId = MinorGlAccountCategoryId 
FROM Gr.GetGlobalGlAccountCategoryHierarchy(@DataPriorToDate) 
WHERE MajorGlAccountCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	  MinorGlAccountCategoryName = ''Bonus''

SELECT @ProfitShareMinorGlAccountCategoryId = MinorGlAccountCategoryId 
FROM Gr.GetGlobalGlAccountCategoryHierarchy(@DataPriorToDate) 
WHERE MajorGlAccountCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	  MinorGlAccountCategoryName = ''Benefits'' -- Yes benefit is correct (Just incase they want to split profit share out again)

SELECT TOP 1 @OccupancyCostsMajorGlAccountCategoryId = MajorGlAccountCategoryId 
FROM Gr.GetGlobalGlAccountCategoryHierarchy(@DataPriorToDate) 
WHERE MajorGlAccountCategoryName = ''General Overhead''

SELECT @OverheadMinorGlAccountCategoryId = MinorGlAccountCategoryId 
FROM Gr.GetGlobalGlAccountCategoryHierarchy(@DataPriorToDate) 
WHERE MajorGlAccountCategoryId = @OccupancyCostsMajorGlAccountCategoryId AND
	  MinorGlAccountCategoryName = ''External General Overhead''

DECLARE @SourceSystemId int
SET @SourceSystemId = 2 -- Tapas budgeting source system

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Source Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--/*
CREATE TABLE #GlobalGlAccountCategoryHierarchyGroup
(
	ImportKey int NOT NULL,
	GlobalGlAccountCategoryHierarchyGroupId int NOT NULL,
	Name varchar(50) NOT NULL,
	IsDefault bit NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
)

CREATE TABLE #MajorGlAccountCategory(
	ImportKey int NOT NULL,
	MajorGlAccountCategoryId int NOT NULL,
	Name varchar(100) NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
)

CREATE TABLE #MinorGlAccountCategory(
	ImportKey int NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	Name varchar(100) NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
)

INSERT INTO #GlobalGlAccountCategoryHierarchyGroup
(ImportKey,GlobalGlAccountCategoryHierarchyGroupId,Name,IsDefault,InsertedDate,UpdatedDate)
Select GlHg.ImportKey,GlHg.GlobalGlAccountCategoryHierarchyGroupId,GlHg.Name,GlHg.IsDefault,GlHg.InsertedDate,GlHg.UpdatedDate
From Gdm.GlobalGlAccountCategoryHierarchyGroup GlHg
		INNER JOIN Gdm.GlobalGlAccountCategoryHierarchyGroupActive(@DataPriorToDate) GlHga ON GlHga.ImportKey = GlHg.ImportKey

INSERT INTO #MajorGlAccountCategory
(ImportKey,MajorGlAccountCategoryId,Name,InsertedDate,UpdatedDate)
Select MaGlAc.ImportKey,MaGlAc.MajorGlAccountCategoryId,MaGlAc.Name,MaGlAc.InsertedDate,MaGlAc.UpdatedDate
From	Gdm.MajorGlAccountCategory MaGlAc
		INNER JOIN Gdm.MajorGlAccountCategoryActive(@DataPriorToDate) MaGlAcA ON MaGlAcA.ImportKey = MaGlAc.ImportKey

INSERT INTO #MinorGlAccountCategory
(ImportKey,MinorGlAccountCategoryId,Name,InsertedDate,UpdatedDate)
Select MiGlAc.ImportKey,MiGlAc.MinorGlAccountCategoryId,MiGlAc.Name,MiGlAc.InsertedDate,MiGlAc.UpdatedDate
From	Gdm.MinorGlAccountCategory MiGlAc
		INNER JOIN Gdm.MinorGlAccountCategoryActive(@DataPriorToDate) MiGlAcA ON MiGlAcA.ImportKey = MiGlAc.ImportKey

PRINT ''Completed getting GlAccountCategory records''
PRINT CONVERT(Varchar(27), getdate(), 121)
------------------------------------------------------------------------------------------------------
--Source and identify report grouping records
------------------------------------------------------------------------------------------------------

-- Source budget report group detail. 
SELECT
	brgd.*
INTO
	#BudgetReportGroupDetail
FROM 
	TapasGlobalBudgeting.BudgetReportGroupDetail brgd
	INNER JOIN TapasGlobalBudgeting.BudgetReportGroupDetailActive(@DataPriorToDate) brgdA ON
		brgd.ImportKey = brgdA.ImportKey
PRINT ''Completed inserting records from BudgetReportGroupDetail:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget report group. 
SELECT 
	brg.* 
INTO
	#BudgetReportGroup
FROM 
	TapasGlobalBudgeting.BudgetReportGroup brg
	INNER JOIN TapasGlobalBudgeting.BudgetReportGroupActive(@DataPriorToDate) brgA ON
		brg.ImportKey = brgA.ImportKey
PRINT ''Completed inserting records from BudgetReportGroup:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source report group period mapping.
SELECT
	brgp.*
INTO
	#BudgetReportGroupPeriod
FROM
	TapasGlobalBudgeting.GRBudgetReportGroupPeriod brgp
	INNER JOIN TapasGlobalBudgeting.GRBudgetReportGroupPeriodActive(@DataPriorToDate) brgpA ON
		brgp.ImportKey = brgpA.ImportKey
PRINT ''Completed inserting records from GRBudgetReportGroupPeriod:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget status
SELECT 
	BudgetStatus.* 
INTO
	#BudgetStatus
FROM
	TapasGlobalBudgeting.BudgetStatus BudgetStatus
	INNER JOIN TapasGlobalBudgeting.BudgetStatusActive(@DataPriorToDate) BudgetStatusA ON
		BudgetStatus.ImportKey = BudgetStatusA.ImportKey
PRINT ''Completed inserting records from BudgetStatus:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source all active budget
SELECT 
	Budget.*
INTO
	#AllActiveBudget
FROM
	TapasGlobalBudgeting.Budget Budget
	INNER JOIN TapasGlobalBudgeting.BudgetActive(@DataPriorToDate) BudgetA ON
		Budget.ImportKey = BudgetA.ImportKey
PRINT ''Completed inserting records from Budget:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Modified new or modified budget or report group setup.
SELECT 
	brgd.BudgetId, 
	brgd.BudgetReportGroupId,
	brgp.GRBudgetReportGroupPeriodId,
	Budget.IsDeleted as IsBudgetDeleted,
	Budget.IsReforecast as IsBugetReforecast,
	Budget.BudgetStatusId, 
	brgd.IsDeleted as IsDetailDeleted, 
	brg.IsReforecast as IsGroupReforecast, 
	brg.StartPeriod as GroupStartPeriod, 
	brg.EndPeriod as GroupEndPeriod, 
	brg.IsDeleted as IsGroupDeleted,
	brgp.IsDeleted as IsPeriodDeleted
INTO
	#AllModifiedReportBudget
FROM

	#AllActiveBudget Budget

    INNER JOIN #BudgetReportGroupDetail brgd ON
		Budget.BudgetId = brgd.BudgetId
    
    INNER JOIN #BudgetReportGroup brg ON
		brgd.BudgetReportGroupId = brg.BudgetReportGroupId
    
    INNER JOIN #BudgetReportGroupPeriod brgp ON
		brg.BudgetReportGroupId = brgp.BudgetReportGroupId 
		
WHERE
	(brgd.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
	(brg.GRChangedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
	(brgp.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
	(Budget.LastLockedDate IS NOT NULL AND Budget.LastLockedDate BETWEEN @ImportStartDate AND @ImportEndDate)

PRINT ''Completed inserting records into #AllModifiedReportBudget:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Filtered budget and setup report group setup

SELECT
	amrb.BudgetReportGroupId
INTO
	#LockedModifiedReportGroup
FROM

	#AllModifiedReportBudget amrb
	
	INNER JOIN #BudgetStatus bs ON
		amrb.BudgetStatusId = bs.BudgetStatusId
GROUP BY
	amrb.BudgetReportGroupId
HAVING COUNT(*) = SUM(CASE WHEN bs.[Name] = ''Locked'' THEN 1 ELSE 0 END) 

PRINT ''Completed inserting records into #LockedModifiedReportGroup:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source filtered budget information
SELECT
	amrb.*
INTO
	#FilteredModifiedReportBudget
FROM
	#LockedModifiedReportGroup lmrg
	
	INNER JOIN #AllModifiedReportBudget amrb ON
		lmrg.BudgetReportGroupId = amrb.BudgetReportGroupId
WHERE
	amrb.IsBudgetDeleted = 0 AND
	amrb.IsBugetReforecast = 0 AND
	amrb.IsDetailDeleted = 0 AND
	amrb.IsGroupReforecast = 0 AND
	amrb.IsGroupDeleted = 0 AND
	amrb.IsPeriodDeleted = 0

PRINT ''Completed inserting records into #FilteredModifiedReportBudget:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget information that meet criteria
SELECT 
	Budget.* 
INTO
	#Budget
FROM
	#AllActiveBudget Budget
	
	INNER JOIN #FilteredModifiedReportBudget fmrb ON
		Budget.BudgetId = fmrb.BudgetId
PRINT ''Completed inserting records into #Budget:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetID ON #Budget (BudgetId)
PRINT ''Completed creating indexes on #Budget''
PRINT CONVERT(Varchar(27), getdate(), 121)

--*/
------------------------------------------------------------------------------------------------------
--Source associated records
------------------------------------------------------------------------------------------------------

--/*
-- Source budget project
SELECT 
	BudgetProject.* 
INTO 
	#BudgetProject
FROM 
	TapasGlobalBudgeting.BudgetProject BudgetProject
	INNER JOIN TapasGlobalBudgeting.BudgetProjectActive(@DataPriorToDate) BudgetProjectA ON
		BudgetProject.ImportKey = BudgetProjectA.ImportKey
		
	-- data limiting join
	INNER JOIN #Budget b ON
		BudgetProject.BudgetId = b.BudgetId

PRINT ''Completed inserting records into #BudgetProject:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetID ON #BudgetProject (BudgetId)
PRINT ''Completed creating indexes on #BudgetProject''
PRINT CONVERT(Varchar(27), getdate(), 121)


-- Source region
SELECT 
	SourceRegion.* 
INTO
	#Region
FROM 
	HR.Region SourceRegion
	INNER JOIN HR.RegionActive(@DataPriorToDate) SourceRegionA ON
		SourceRegion.ImportKey = SourceRegionA.ImportKey
PRINT ''Completed inserting records into #Region:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Budget Employee
SELECT 
	BudgetEmployee.* 
INTO
	#BudgetEmployee
FROM 
	TapasGlobalBudgeting.BudgetEmployee BudgetEmployee
	INNER JOIN TapasGlobalBudgeting.BudgetEmployeeActive(@DataPriorToDate) BudgetEmployeeA ON
		BudgetEmployee.ImportKey = BudgetEmployeeA.ImportKey

	--data limiting join
	INNER JOIN #Budget b ON
		BudgetEmployee.BudgetId = b.BudgetId

PRINT ''Completed inserting records into #Region:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeeID ON #BudgetEmployee (BudgetEmployeeId)
CREATE INDEX IX_BudgetId ON #BudgetEmployee (BudgetId)
PRINT ''Completed creating indexes on ##BudgetEmployee''
PRINT CONVERT(Varchar(27), getdate(), 121)


-- Source Budget Employee Functional Department
SELECT 
	efd.* 
INTO
	#BudgetEmployeeFunctionalDepartment
FROM 
	TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment efd
	INNER JOIN TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartmentActive(@DataPriorToDate) efdA ON
		efd.ImportKey = efdA.ImportKey

	-- data limiting join
	INNER JOIN #BudgetEmployee be ON
		efd.BudgetEmployeeId = be.BudgetEmployeeId

PRINT ''Completed inserting records into #BudgetEmployeeFunctionalDepartment:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeeId ON #BudgetEmployeeFunctionalDepartment (BudgetEmployeeId)
PRINT ''Completed creating indexes on #BudgetEmployeeFunctionalDepartment''
PRINT CONVERT(Varchar(27), getdate(), 121)



-- Source Functional Department
SELECT 
	fd.* 
INTO
	#FunctionalDepartment
FROM 
	HR.FunctionalDepartment fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) fdA ON
		fd.ImportKey = fdA.ImportKey

PRINT ''Completed inserting records into #FunctionalDepartment:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_FunctionalDepartmentId ON #FunctionalDepartment (FunctionalDepartmentId)
PRINT ''Completed creating indexes on #FunctionalDepartment''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Property Fund
SELECT 
	PropertyFund.* 
INTO
	#PropertyFund
FROM 
	Gdm.PropertyFund PropertyFund
	INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PropertyFundA ON
		PropertyFund.ImportKey = PropertyFundA.ImportKey 

PRINT ''Completed inserting records into #PropertyFund:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFund (PropertyFundId)
PRINT ''Completed creating indexes on #PropertyFund''
PRINT CONVERT(Varchar(27), getdate(), 121)


-- Source Property Fund Mapping

SELECT 
	PropertyFundMapping.* 
INTO
	#PropertyFundMapping
FROM 
	Gdm.PropertyFundMapping PropertyFundMapping
	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PropertyFundMappingA ON
		PropertyFundMapping.ImportKey = PropertyFundMappingA.ImportKey 

PRINT ''Completed inserting records into #PropertyFundMapping:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFundMapping (PropertyFundCode,SourceCode,IsDeleted,PropertyFundId,ActivityTypeId)
PRINT ''Completed creating indexes on #PropertyFundMapping''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Location
SELECT 
	Location.* 
INTO
	#Location
FROM 
	HR.Location Location
	INNER JOIN HR.LocationActive(@DataPriorToDate) LocationA ON
		Location.ImportKey = LocationA.ImportKey
	
PRINT ''Completed inserting records into #Location:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_LocationId ON #Location (LocationId)
PRINT ''Completed creating indexes on #Location''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source region extended
SELECT 
	RegionExtended.* 
INTO
	#RegionExtended
FROM 
	TapasGlobal.RegionExtended RegionExtended
	INNER JOIN TapasGlobal.RegionExtendedActive(@DataPriorToDate) RegionExtendedA ON
		RegionExtended.ImportKey = RegionExtendedA.ImportKey

PRINT ''Completed inserting records into #RegionExtended:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_RegionId ON #RegionExtended (RegionId)
PRINT ''Completed creating indexes on #RegionExtended''
PRINT CONVERT(Varchar(27), getdate(), 121)


-- Source Payroll Originating Region
SELECT 
	PayrollRegion.* 
INTO
	#PayrollRegion
FROM 
	TapasGlobal.PayrollRegion PayrollRegion
	INNER JOIN TapasGlobal.PayrollRegionActive(@DataPriorToDate) PayrollRegionA ON
		PayrollRegion.ImportKey = PayrollRegionA.ImportKey
	
PRINT ''Completed inserting records into #PayrollRegion:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PayrollRegionId ON #PayrollRegion (PayrollRegionId)
PRINT ''Completed creating indexes on #PayrollRegion''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Overhead Originating Region
SELECT 
	OverheadRegion.* 
INTO
	#OverheadRegion
FROM 
	TapasGlobal.OverheadRegion OverheadRegion
	INNER JOIN TapasGlobal.OverheadRegionActive(@DataPriorToDate) OverheadRegionA ON
		OverheadRegion.ImportKey = OverheadRegionA.ImportKey
	
PRINT ''Completed inserting records into #OverheadRegion:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_OverheadRegionId ON #OverheadRegion (OverheadRegionId)
PRINT ''Completed creating indexes on #OverheadRegion''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source project
SELECT 
	Project.* 
INTO
	#Project
FROM 
	TapasGlobal.Project Project
	INNER JOIN TapasGlobal.ProjectActive(@DataPriorToDate) ProjectA ON
		Project.ImportKey = ProjectA.ImportKey 

PRINT ''Completed inserting records into #Project:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_ProjectId ON #Project (ProjectId)
PRINT ''Completed creating indexes on #Project''
PRINT CONVERT(Varchar(27), getdate(), 121)


------------------------------------------------------------------------------------------------------
--Source allocation records
------------------------------------------------------------------------------------------------------

-- Source payroll allocation
SELECT
	Allocation.*
INTO
	#BudgetEmployeePayrollAllocation
FROM
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocation Allocation

	INNER JOIN TapasGlobalBudgeting.BudgetEmployeePayrollAllocationActive(@DataPriorToDate) AllocationA ON
		Allocation.ImportKey = AllocationA.ImportKey

	--data limiting join
	INNER JOIN #BudgetProject bp ON
		Allocation.BudgetProjectId = bp.BudgetProjectId

PRINT ''Completed inserting records into #BudgetEmployeePayrollAllocation:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationId ON #BudgetEmployeePayrollAllocation (BudgetEmployeePayrollAllocationId)
PRINT ''Completed creating indexes on #BudgetEmployeePayrollAllocation''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source payroll tax detail
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Using the ''active'' function here cause serious performance issues and the only way around it, was to extract the logic from the is active function 
--to seperate peaces of code.
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
SELECT 
	B2.BudgetEmployeePayrollAllocationDetailId,
	MAX(B2.ImportBatchId) as ImportBatchId
Into #BudgetEmployeePayrollAllocationDetailBatches
FROM 
	[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B2
		
	INNER JOIN Batch ON
		B2.ImportBatchId = batch.BatchId
		
WHERE	
	batch.BatchEndDate IS NOT NULL AND
	batch.PackageName = ''ETL.Staging.TapasGlobalBudgeting'' AND
	batch.ImportEndDate <= @DataPriorToDate
		
GROUP BY B2.BudgetEmployeePayrollAllocationDetailId

PRINT ''Completed inserting records into #BudgetEmployeePayrollAllocationDetailBatches:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

SELECT 
	MAX(B1.ImportKey) ImportKey
Into #BEPADa
FROM
	[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B1

	INNER JOIN #BudgetEmployeePayrollAllocationDetailBatches t1 ON 
		t1.BudgetEmployeePayrollAllocationDetailId = B1.BudgetEmployeePayrollAllocationDetailId AND
		t1.ImportBatchId = B1.ImportBatchId

GROUP BY B1.BudgetEmployeePayrollAllocationDetailId

PRINT ''Completed inserting records into #BEPADa:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


SELECT 
	TaxDetail.*
INTO
	#BudgetEmployeePayrollAllocationDetail
FROM
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocationDetail TaxDetail
	
	INNER JOIN #BEPADa TaxDetailA ON
		TaxDetail.ImportKey = TaxDetailA.ImportKey

	--data limiting join
	INNER JOIN #BudgetEmployeePayrollAllocation Allocation ON
		TaxDetail.BudgetEmployeePayrollAllocationId = Allocation.BudgetEmployeePayrollAllocationId

PRINT ''Completed inserting records into #BudgetEmployeePayrollAllocationDetail:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationDetailId ON #BudgetEmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationDetailId)
PRINT ''Completed creating indexes on #BudgetEmployeePayrollAllocationDetail''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget tax type
SELECT 
	BudgetTaxType.* 
INTO
	#BudgetTaxType
FROM 
	TapasGlobalBudgeting.BudgetTaxType BudgetTaxType
	INNER JOIN TapasGlobalBudgeting.BudgetTaxTypeActive(@DataPriorToDate) BudgetTaxTypeA ON
		BudgetTaxType.ImportKey = BudgetTaxTypeA.ImportKey

	-- data limiting join
	INNER JOIN #Budget b ON
		BudgetTaxType.BudgetId = b.BudgetId

PRINT ''Completed inserting records into #BudgetTaxType:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetTaxTypeId ON #BudgetTaxType (BudgetTaxTypeId)
PRINT ''Completed creating indexes on #BudgetTaxType''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source tax type
SELECT 
	TaxType.* 
INTO
	#TaxType
FROM 
	TapasGlobalBudgeting.TaxType TaxType
	INNER JOIN TapasGlobalBudgeting.TaxTypeActive(@DataPriorToDate) TaxTypeA ON
		TaxType.ImportKey = TaxTypeA.ImportKey

PRINT ''Completed inserting records into #TaxType:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source payroll allocation Tax detail
CREATE TABLE #EmployeePayrollAllocationDetail
(
	ImportKey int NOT NULL,
	BudgetEmployeePayrollAllocationDetailId int NOT NULL,
	BudgetEmployeePayrollAllocationId int NOT NULL,
	MinorGlAccountCategoryId int NULL,
	BudgetTaxTypeId int NULL,
	SalaryAmount decimal(18, 2) NULL,
	BonusAmount decimal(18, 2) NULL,
	ProfitShareAmount decimal(18, 2) NULL,
	BonusCapExcessAmount decimal(18, 2) NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	UpdatedByStaffId int NOT NULL
)

INSERT INTO #EmployeePayrollAllocationDetail
(
	ImportKey,
	BudgetEmployeePayrollAllocationDetailId,
	BudgetEmployeePayrollAllocationId,
	MinorGlAccountCategoryId,
	BudgetTaxTypeId,
	SalaryAmount,
	BonusAmount,
	ProfitShareAmount,
	BonusCapExcessAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	TaxDetail.ImportKey,
	TaxDetail.BudgetEmployeePayrollAllocationDetailId,
	TaxDetail.BudgetEmployeePayrollAllocationId,
	CASE WHEN (TaxDetail.BenefitOptionId IS NOT NULL) THEN @BenefitsMinorGlAccountCategoryId ELSE TaxType.MinorGlAccountCategoryId END as MinorGlAccountCategoryId,
	TaxDetail.BudgetTaxTypeId,
	TaxDetail.SalaryAmount,
	TaxDetail.BonusAmount,
	TaxDetail.ProfitShareAmount,
	TaxDetail.BonusCapExcessAmount,
	TaxDetail.InsertedDate,
	TaxDetail.UpdatedDate,
	TaxDetail.UpdatedByStaffId
FROM

	-- Joining on allocation to limit amount of data
	#BudgetEmployeePayrollAllocation Allocation
	
	INNER JOIN 	
		#BudgetEmployeePayrollAllocationDetail TaxDetail ON
			Allocation.BudgetEmployeePayrollAllocationId = TaxDetail.BudgetEmployeePayrollAllocationId 
			
	LEFT OUTER JOIN 
		#BudgetTaxType BudgetTaxType ON
				TaxDetail.BudgetTaxTypeId = BudgetTaxType.BudgetTaxTypeId
				
	LEFT OUTER JOIN 
		#TaxType TaxType ON
			BudgetTaxType.TaxTypeId = TaxType.TaxTypeId	
			
PRINT ''Completed inserting records into #EmployeePayrollAllocationDetail:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #EmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationDetailId,BudgetEmployeePayrollAllocationId)
PRINT ''Completed creating indexes on #EmployeePayrollAllocationDetail''
PRINT CONVERT(Varchar(27), getdate(), 121)

--*/
-- Source payroll overhead allocation
SELECT
	OverheadAllocation.*
INTO
	#BudgetOverheadAllocation
FROM
	TapasGlobalBudgeting.BudgetOverheadAllocation OverheadAllocation
	
	INNER JOIN TapasGlobalBudgeting.BudgetOverheadAllocationActive(@DataPriorToDate) OverheadAllocationA ON
		OverheadAllocation.ImportKey = OverheadAllocationA.ImportKey

	-- data limiting join
	INNER JOIN #Budget b ON
		OverheadAllocation.BudgetId = b.BudgetId

PRINT ''Completed inserting records into #BudgetOverheadAllocation:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocation (BudgetOverheadAllocationId,BudgetId,OverheadRegionId,BudgetEmployeeId)
PRINT ''Completed creating indexes on #BudgetOverheadAllocation''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source overhead allocation detail
SELECT 
	OverheadDetail.*
INTO
	#BudgetOverheadAllocationDetail
FROM			
	TapasGlobalBudgeting.BudgetOverheadAllocationDetail OverheadDetail
	
	INNER JOIN TapasGlobalBudgeting.BudgetOverheadAllocationDetailActive(@DataPriorToDate) OverheadDetailA ON
		OverheadDetail.ImportKey = OverheadDetailA.ImportKey

	-- data limiting join
	INNER JOIN #BudgetProject b ON
		OverheadDetail.BudgetProjectId = b.BudgetProjectId

PRINT ''Completed inserting records into #BudgetOverheadAllocationDetail:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
PRINT ''Completed creating indexes on #BudgetOverheadAllocationDetail''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source payroll overhead allocation detail
CREATE TABLE #OverheadAllocationDetail
(
	ImportKey int NOT NULL,
	BudgetOverheadAllocationDetailId int NOT NULL,
	BudgetOverheadAllocationId int NOT NULL,
	BudgetProjectId int NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	AllocationValue decimal(18, 9) NOT NULL,
	AllocationAmount decimal(18, 2) NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	UpdatedByStaffId int NOT NULL
)

INSERT INTO #OverheadAllocationDetail
(
	ImportKey,
	BudgetOverheadAllocationDetailId,
	BudgetOverheadAllocationId,
	BudgetProjectId,
	MinorGlAccountCategoryId,
	AllocationValue,
	AllocationAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	OverheadDetail.ImportKey,
	OverheadDetail.BudgetOverheadAllocationDetailId,
	OverheadDetail.BudgetOverheadAllocationId,
	OverheadDetail.BudgetProjectId,
	@OverheadMinorGlAccountCategoryId as MinorGlAccountCategoryId,
	OverheadDetail.AllocationValue,
	OverheadDetail.AllocationAmount,
	OverheadDetail.InsertedDate,
	OverheadDetail.UpdatedDate,
	OverheadDetail.UpdatedByStaffId
FROM

	-- Joining on allocation to limit amount of data
	#BudgetOverheadAllocation OverheadAllocation
	
	INNER JOIN 	
		#BudgetOverheadAllocationDetail OverheadDetail ON
			OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId 
			
PRINT ''Completed inserting records into #OverheadAllocationDetail:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #OverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
PRINT ''Completed creating indexes on #OverheadAllocationDetail''
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Map Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

--Calculate effective functional department
SELECT 
	Allocation.BudgetEmployeePayrollAllocationId,
	Allocation.BudgetEmployeeId,
	(SELECT 
		EFD.FunctionalDepartmentId
	 FROM 
		(SELECT 
			Allocation2.BudgetEmployeeId,
			MAX(EFD.EffectivePeriod) as EffectivePeriod
		 FROM
			#BudgetEmployeePayrollAllocation Allocation2

			INNER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
				Allocation2.BudgetEmployeeId = EFD.BudgetEmployeeId
		
			WHERE
			  Allocation.BudgetEmployeePayrollAllocationId = Allocation2.BudgetEmployeePayrollAllocationId AND
			  EFD.EffectivePeriod <= Allocation.Period
			  
			GROUP BY
				Allocation2.BudgetEmployeeId
		) EFDo
		
			LEFT OUTER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
				EFD.BudgetEmployeeId = EFDo.BudgetEmployeeId AND
				EFD.EffectivePeriod = EFDo.EffectivePeriod
	 ) as FunctionalDepartmentId
INTO
	#EffectiveFunctionalDepartment
FROM
	#BudgetEmployeePayrollAllocation Allocation

	INNER JOIN #BudgetProject BudgetProject ON 
		Allocation.BudgetProjectId = BudgetProject.BudgetProjectId

PRINT ''Completed inserting records into #EffectiveFunctionalDepartment:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Pre Tax Amounts
CREATE TABLE #ProfitabilityPreTaxSource
(
	BudgetId int NOT NULL,
	BudgetRegionId int NOT NULL,
	ProjectId int NOT NULL,
	HrEmployeeId int NOT NULL,
	BudgetEmployeePayrollAllocationId int NOT NULL,
	ReferenceCode varchar(300) NOT NULL,
	ExpensePeriod char(6) NOT NULL,	
	SourceCode varchar(2) NULL,
	SalaryPreTaxAmount money NOT NULL,
	ProfitSharePreTaxAmount money NOT NULL,
	BonusPreTaxAmount money NOT NULL,
	BonusCapExcessPreTaxAmount money NOT NULL,
	FunctionalDepartmentId int NOT NULL,
	FunctionalDepartmentCode varchar(31) NULL,
	Reimbursable bit NULL,
	ActivityTypeId int NOT NULL,
	PropertyFundId int NOT NULL,
	ProjectRegionId int NOT NULL,
	OriginatingRegionCode char(6) NULL,
	OriginatingRegionSourceCode varchar(2) NULL,
	LocalCurrencyCode char(3) NOT NULL,
	AllocationUpdatedDate datetime NOT NULL
)
-- Insert original budget amounts
INSERT INTO #ProfitabilityPreTaxSource
(
	BudgetId,
	BudgetRegionId,
	ProjectId,
	HrEmployeeId,
	BudgetEmployeePayrollAllocationId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	SalaryPreTaxAmount,
	ProfitSharePreTaxAmount,
	BonusPreTaxAmount,
	BonusCapExcessPreTaxAmount,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	ProjectRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate
)
SELECT 
	Budget.BudgetId as BudgetId,
	Budget.RegionId as BudgetRegionId,
	IsNull(BudgetProject.ProjectId,0) as ProjectId,
	IsNull(BudgetEmployee.HrEmployeeId,0) as HrEmployeeId,
	Allocation.BudgetEmployeePayrollAllocationId,
	''TGB:BudgetId='' + CONVERT(varchar,Budget.BudgetId) + ''&ProjectId='' + CONVERT(varchar,IsNull(BudgetProject.ProjectId,0)) + ''&HrEmployeeId='' + CONVERT(varchar,IsNull(BudgetEmployee.HrEmployeeId,0)) + ''&BudgetEmployeePayrollAllocationId='' + CONVERT(varchar,Allocation.BudgetEmployeePayrollAllocationId) + ''&BudgetEmployeePayrollAllocationDetailId=0&BudgetOverheadAllocationDetailId=0'' + ''&ImportKey='' + CONVERT(varchar, Allocation.ImportKey) as ReferenceCode,
	Allocation.Period as ExpensePeriod,
	SourceRegion.SourceCode,
	IsNull(Allocation.PreTaxSalaryAmount,0) as SalaryPreTaxAmount,
	IsNull(Allocation.PreTaxProfitShareAmount, 0) as ProfitSharePreTaxAmount,
	IsNull(Allocation.PreTaxBonusAmount,0) as BonusPreTaxAmount, 
	IsNull(Allocation.PreTaxBonusCapExcessAmount,0) as BonusCapExcessPreTaxAmount,
	IsNull(EFD.FunctionalDepartmentId, -1),
	fd.GlobalCode as FunctionalDepartmentCode, 
	CASE WHEN BudgetProject.IsTsCost = 0 THEN 1 ELSE 0 END as Reimbursable,
	BudgetProject.ActivityTypeId,
	IsNull(CASE WHEN (BudgetProject.CorporateDepartmentCode = ''@'' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
				ProjectPropertyFund.PropertyFundId
			ELSE 
				DepartmentPropertyFund.PropertyFundId 
			END, -1) as PropertyFundId,
	-- Same case logic as above
	IsNull(CASE WHEN (BudgetProject.CorporateDepartmentCode = ''@'' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
				ProjectPropertyFund.ProjectRegionId
			ELSE 
				DepartmentPropertyFund.ProjectRegionId 
			END, -1) as ProjectRegionId,
	OriginatingRegion.CorporateEntityRef,
	OriginatingRegion.CorporateSourceCode,
	Budget.CurrencyCode as LocalCurrencyCode,
	Allocation.UpdatedDate
FROM
	#BudgetEmployeePayrollAllocation Allocation

	INNER JOIN #BudgetProject BudgetProject ON 
		Allocation.BudgetProjectId = BudgetProject.BudgetProjectId
			
	INNER JOIN #FilteredModifiedReportBudget fmrb ON
		BudgetProject.BudgetId = fmrb.BudgetId
			
	INNER JOIN #Budget Budget ON 
		fmrb.BudgetId = Budget.BudgetId 
		
	LEFT OUTER JOIN #Region SourceRegion ON 
		Budget.RegionId = SourceRegion.RegionId

	LEFT OUTER JOIN #EffectiveFunctionalDepartment efd ON
		Allocation.BudgetEmployeePayrollAllocationId = efd.BudgetEmployeePayrollAllocationId

	LEFT OUTER JOIN #FunctionalDepartment fd ON 
		efd.FunctionalDepartmentId = fd.FunctionalDepartmentId

	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId

	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON GrSc.SourceCode = SourceRegion.SourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		BudgetProject.CorporateSourceCode = pfm.SourceCode AND
		--ISNULL(BudgetProject.ActivityTypeId, -1) = ISNULL(pfm.ActivityTypeId, -1) AND 
		pfm.IsDeleted = 0 AND 
		(
		(GrSc.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL) 
		OR
		(
		(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId = BudgetProject.ActivityTypeId)
		OR
		(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
		)
		)
	
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		pfm.PropertyFundId = DepartmentPropertyFund.PropertyFundId
	
	LEFT OUTER JOIN #BudgetEmployee BudgetEmployee ON
		Allocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId
		
	LEFT OUTER JOIN #Location Location ON 
		Location.LocationId = BudgetEmployee.LocationId
		
	LEFT OUTER JOIN #PayrollRegion OriginatingRegion ON 
		Location.ExternalSubRegionId = OriginatingRegion.ExternalSubRegionId AND
		Budget.RegionId = OriginatingRegion.RegionId

WHERE
	Allocation.Period BETWEEN fmrb.GroupStartPeriod AND fmrb.GroupEndPeriod AND
	BudgetProject.ActivityTypeId <> 99 -- exclude Corporate Overhead

PRINT ''Completed inserting records into #ProfitabilityPreTaxSource:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


CREATE INDEX IX_SalaryPreTaxAmount ON #ProfitabilityPreTaxSource (SalaryPreTaxAmount)
CREATE INDEX IX_ProfitSharePreTaxAmount ON #ProfitabilityPreTaxSource (ProfitSharePreTaxAmount)
CREATE INDEX IX_BonusPreTaxAmount ON #ProfitabilityPreTaxSource (BonusPreTaxAmount)
CREATE INDEX IX_BonusCapExcessPreTaxAmount ON #ProfitabilityPreTaxSource (BonusCapExcessPreTaxAmount)
PRINT ''Completed creating indexes on #ProfitabilityPreTaxSource''
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Tax Amounts

CREATE TABLE #ProfitabilityTaxSource
(
	BudgetId int NOT NULL,
	BudgetRegionId int NOT NULL,
	ProjectId int NOT NULL,
	HrEmployeeId int NOT NULL,
	BudgetEmployeePayrollAllocationId int NOT NULL,
	BudgetEmployeePayrollAllocationDetailId int NOT NULL,
	ReferenceCode varchar(300) NOT NULL,
	ExpensePeriod char(6) NOT NULL,	
	SourceCode varchar(2) NULL,
	SalaryTaxAmount money NOT NULL,
	ProfitShareTaxAmount money NOT NULL,
	BonusTaxAmount money NOT NULL,
	BonusCapExcessTaxAmount money NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	FunctionalDepartmentId int NOT NULL,
	FunctionalDepartmentCode varchar(31) NULL,
	Reimbursable bit NULL,
	ActivityTypeId int NOT NULL,
	PropertyFundId int NOT NULL,
	ProjectRegionId int NOT NULL,
	OriginatingRegionCode char(6) NULL,
	OriginatingRegionSourceCode varchar(2) NULL,
	LocalCurrencyCode char(3) NOT NULL,
	AllocationUpdatedDate datetime NOT NULL
)
--/*
-- Insert original budget amounts
INSERT INTO #ProfitabilityTaxSource
(
	BudgetId,
	BudgetRegionId,
	ProjectId,
	HrEmployeeId,
	BudgetEmployeePayrollAllocationId,
	BudgetEmployeePayrollAllocationDetailId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	SalaryTaxAmount,
	ProfitShareTaxAmount,
	BonusTaxAmount,
	BonusCapExcessTaxAmount,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	ProjectRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate
)
SELECT 
	pts.BudgetId,
	pts.BudgetRegionId,
	IsNull(pts.ProjectId,0) as ProjectId,
	IsNull(pts.HrEmployeeId,0) as HrEmployeeId,
	pts.BudgetEmployeePayrollAllocationId,
	TaxDetail.BudgetEmployeePayrollAllocationDetailId,
	''TGB:BudgetId='' + CONVERT(varchar,pts.BudgetId) + ''&ProjectId='' + CONVERT(varchar,IsNull(pts.ProjectId,0)) + ''&HrEmployeeId='' + CONVERT(varchar,IsNull(pts.HrEmployeeId,0)) + ''&BudgetEmployeePayrollAllocationId='' + CONVERT(varchar,pts.BudgetEmployeePayrollAllocationId) + ''&BudgetEmployeePayrollAllocationDetailId='' + CONVERT(varchar,TaxDetail.BudgetEmployeePayrollAllocationDetailId) + ''&BudgetOverheadAllocationDetailId=0'' + ''&ImportKey='' + CONVERT(varchar, TaxDetail.ImportKey) as ReferenceCode,
	pts.ExpensePeriod,
	pts.SourceCode,
	IsNull(TaxDetail.SalaryAmount, 0) as SalaryTaxAmount,
	IsNull(TaxDetail.ProfitShareAmount, 0) as ProfitShareTaxAmount,
	IsNull(TaxDetail.BonusAmount, 0) as BonusTaxAmount,
	IsNull(TaxDetail.BonusCapExcessAmount, 0) as BonusCapExcessTaxAmount,
	TaxDetail.MinorGlAccountCategoryId,
	IsNull(pts.FunctionalDepartmentId, -1),
	pts.FunctionalDepartmentCode, 
	pts.Reimbursable,
	pts.ActivityTypeId,
	pts.PropertyFundId,
	IsNull(pts.ProjectRegionId, -1),
	pts.OriginatingRegionCode,
	pts.OriginatingRegionSourceCode,
	pts.LocalCurrencyCode,
	pts.AllocationUpdatedDate

FROM

	#EmployeePayrollAllocationDetail TaxDetail 

	INNER JOIN #ProfitabilityPreTaxSource pts ON
		TaxDetail.BudgetEmployeePayrollAllocationId = pts.BudgetEmployeePayrollAllocationId

PRINT ''Completed inserting records into #ProfitabilityTaxSource:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Overhead Amounts

CREATE TABLE #ProfitabilityOverheadSource
(
	BudgetId int NOT NULL,
	ProjectId int NOT NULL,
	HrEmployeeId int NOT NULL,
	BudgetOverheadAllocationId int NOT NULL,
	BudgetOverheadAllocationDetailId int NOT NULL,
	ReferenceCode varchar(300) NOT NULL,
	ExpensePeriod char(6) NOT NULL,	
	SourceCode varchar(2) NULL,
	OverheadAllocationAmount money NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	FunctionalDepartmentId int NOT NULL,
	FunctionalDepartmentCode varchar(31) NULL,
	Reimbursable bit NULL,
	ActivityTypeId int NOT NULL,
	PropertyFundId int NOT NULL,
	ProjectRegionId int NOT NULL,
	OriginatingRegionCode char(6) NULL,
	OriginatingRegionSourceCode varchar(2) NULL,
	LocalCurrencyCode char(3) NOT NULL,
	OverheadUpdatedDate datetime NOT NULL
)
-- Insert original overhead amounts
INSERT INTO #ProfitabilityOverheadSource
(
	BudgetId,
	ProjectId,
	HrEmployeeId,
	BudgetOverheadAllocationId,
	BudgetOverheadAllocationDetailId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	OverheadAllocationAmount,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	ProjectRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	OverheadUpdatedDate
)
SELECT
	Budget.BudgetId as BudgetId,
	IsNull(BudgetProject.ProjectId,0) as ProjectId,
	IsNull(BudgetEmployee.HrEmployeeId,0) as HrEmployeeId,
	OverheadDetail.BudgetOverheadAllocationId,
	OverheadDetail.BudgetOverheadAllocationDetailId,
	''TGB:BudgetId='' + CONVERT(varchar,Budget.BudgetId) + ''&ProjectId='' + CONVERT(varchar,IsNull(BudgetProject.ProjectId,0)) + ''&HrEmployeeId='' + CONVERT(varchar,IsNull(BudgetEmployee.HrEmployeeId,0)) + ''&BudgetEmployeePayrollAllocationId=0&BudgetEmployeePayrollAllocationDetailId=0'' + ''&BudgetOverheadAllocationDetailId='' + CONVERT(varchar,OverheadDetail.BudgetOverheadAllocationDetailId) + ''&ImportKey='' + CONVERT(varchar, OverheadDetail.ImportKey) as ReferenceCode,
	OverheadAllocation.BudgetPeriod as ExpensePeriod,
	SourceRegion.SourceCode,
	IsNull(OverheadDetail.AllocationAmount,0) as OverheadAllocationAmount,
	OverheadDetail.MinorGlAccountCategoryId,
	IsNull(RegionExtended.OverheadFunctionalDepartmentId, -1) as FunctionalDepartmentId,
	fd.GlobalCode as FunctionalDepartmentCode, 
	CASE WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
		CASE WHEN (BudgetProject.IsTsCost = 0) THEN -- Where ISTSCost is False the cost will be reimbursable
			1 
		ELSE 
			0
		END
	ELSE 
		0  --Where the BudgetProject.OverheadAllocationProjectID is populated: non-reimbursable
	END as Reimbursable,
	BudgetProject.ActivityTypeId,
	
	CASE WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
		IsNull(CASE WHEN (BudgetProject.CorporateDepartmentCode = ''@'' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.PropertyFundId
				ELSE 
					DepartmentPropertyFund.PropertyFundId 
				END, -1) 
	ELSE 
		IsNull(OverheadPropertyFund.PropertyFundId, -1) 
	END as PropertyFundId,
	-- Same case logic as above
	CASE WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
		IsNull(CASE WHEN (BudgetProject.CorporateDepartmentCode = ''@'' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.ProjectRegionId
				ELSE 
					DepartmentPropertyFund.ProjectRegionId 
				END, -1) 
	ELSE 
		IsNull(OverheadPropertyFund.ProjectRegionId, -1) 
	END as ProjectRegionId,
	
	OriginatingRegion.CorporateEntityRef,
	OriginatingRegion.CorporateSourceCode,
	Budget.CurrencyCode as LocalCurrencyCode,
	OverheadDetail.UpdatedDate

FROM

	#BudgetOverheadAllocation OverheadAllocation 

	INNER JOIN #BudgetEmployee BudgetEmployee ON
		OverheadAllocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId

	INNER JOIN #OverheadAllocationDetail OverheadDetail ON
		OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId
			
	INNER JOIN #BudgetProject BudgetProject ON 
		OverheadDetail.BudgetProjectId = BudgetProject.BudgetProjectId
		
	INNER JOIN #FilteredModifiedReportBudget fmrb ON
		BudgetProject.BudgetId = fmrb.BudgetId
		
	INNER JOIN #Budget Budget ON 
		fmrb.BudgetId = Budget.BudgetId
		
	LEFT OUTER JOIN #Region SourceRegion ON 
		Budget.RegionId = SourceRegion.RegionId
		
	LEFT OUTER JOIN #RegionExtended RegionExtended ON 
		SourceRegion.RegionId = RegionExtended.RegionId

	LEFT OUTER JOIN #FunctionalDepartment fd ON 
		RegionExtended.OverheadFunctionalDepartmentId = fd.FunctionalDepartmentId

	LEFT OUTER JOIN	#Project OverheadProject ON
		BudgetProject.AllocateOverheadsProjectId = OverheadProject.ProjectId

	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId
	
	LEFT OUTER JOIN GrReporting.dbo.Source GrScC ON GrScC.SourceCode = BudgetProject.CorporateSourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		BudgetProject.CorporateSourceCode = pfm.SourceCode AND
		--ISNULL(BudgetProject.ActivityTypeId, -1) = ISNULL(pfm.ActivityTypeId, -1) AND 
		pfm.IsDeleted = 0 AND 
		(
		(GrScC.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL) 
		OR
		(
		(GrScC.IsCorporate = ''YES'' AND pfm.ActivityTypeId = BudgetProject.ActivityTypeId)
		OR
		(GrScC.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
		)
		)
	
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		pfm.PropertyFundId = DepartmentPropertyFund.PropertyFundId

	LEFT OUTER JOIN GrReporting.dbo.Source GrScO ON GrScO.SourceCode = OverheadProject.CorporateSourceCode

	LEFT OUTER JOIN #PropertyFundMapping opfm ON
		OverheadProject.CorporateDepartmentCode = opfm.PropertyFundCode AND -- Combination of entity and corporate department
		OverheadProject.CorporateSourceCode = opfm.SourceCode AND
		--ISNULL(BudgetProject.ActivityTypeId, -1) = ISNULL(opfm.ActivityTypeId, -1) AND 
		opfm.IsDeleted = 0 AND 
		(
		(GrScO.IsProperty = ''YES'' AND opfm.ActivityTypeId IS NULL) 
		OR
		(
		(GrScO.IsCorporate = ''YES'' AND opfm.ActivityTypeId = BudgetProject.ActivityTypeId)
		OR
		(GrScO.IsCorporate = ''YES'' AND opfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
		)
		)
	
	LEFT OUTER JOIN 
		#PropertyFund OverheadPropertyFund ON
				opfm.PropertyFundId = OverheadPropertyFund.PropertyFundId
	
	LEFT OUTER JOIN #OverheadRegion OriginatingRegion ON 
		OverheadAllocation.OverheadRegionId = OriginatingRegion.OverheadRegionId
		
WHERE
	OverheadAllocation.BudgetPeriod BETWEEN fmrb.GroupStartPeriod AND fmrb.GroupEndPeriod
		
PRINT ''Completed inserting records into #ProfitabilityOverheadSource:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Generate mapping records
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


CREATE TABLE #ProfitabilityPayrollMapping
(
	BudgetId int NOT NULL,
	ReferenceCode varchar(300) NOT NULL,
	ExpensePeriod char(6) NOT NULL,	
	SourceCode varchar(2) NULL,
	BudgetAmount money NOT NULL,
	MajorGlAccountCategoryId int NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	FunctionalDepartmentId int NOT NULL,
	FunctionalDepartmentCode varchar(31) NULL,
	Reimbursable bit NOT NULL,
	ActivityTypeId int NOT NULL,
	PropertyFundId int NOT NULL,
	ProjectRegionId int NOT NULL,
	OriginatingRegionCode char(6) NULL,
	OriginatingRegionSourceCode varchar(2) NULL,
	LocalCurrencyCode char(3) NOT NULL,
	AllocationUpdatedDate datetime NOT NULL
)

INSERT INTO #ProfitabilityPayrollMapping
(
	BudgetId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	BudgetAmount,
	MajorGlAccountCategoryId,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	ProjectRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate
)
-- Get Base Salary Payroll pre tax mappings and budget
SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=SalaryPreTax'' as ReferenceCode,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.SalaryPreTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	@BaseSalaryMinorGlAccountCategoryId as MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityPreTaxSource pps
WHERE
	pps.SalaryPreTaxAmount <> 0

-- Get Profit Share Benefit pre tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=ProfitSharePreTax'' as ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.ProfitSharePreTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	@ProfitShareMinorGlAccountCategoryId as MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityPreTaxSource pps
WHERE
	pps.ProfitSharePreTaxAmount <> 0

-- Get Bonus pre tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=BonusPreTax'' as ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusPreTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	@BonusMinorGlAccountCategoryId as MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityPreTaxSource pps
WHERE
	pps.BonusPreTaxAmount <> 0

--Get bonus cap pre tax mappings
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=BonusCapExcessPreTax'' as ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusCapExcessPreTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	@BonusMinorGlAccountCategoryId as MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	0 as Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
	IsNull(p.ActivityTypeId, -1) as ActivityTypeId,
	IsNull(CASE WHEN (p.CorporateDepartmentCode = ''@'' OR p.CorporateDepartmentCode IS NULL) THEN 
				ProjectPropertyFund.PropertyFundId
			ELSE 
				DepartmentPropertyFund.PropertyFundId 
			END, -1) as PropertyFundId,
	-- Same case logic as above
	IsNull(CASE WHEN (p.CorporateDepartmentCode = ''@'' OR p.CorporateDepartmentCode IS NULL) THEN 
				ProjectPropertyFund.ProjectRegionId
			ELSE 
				DepartmentPropertyFund.ProjectRegionId 
			END, -1) as ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityPreTaxSource pps
	
	LEFT OUTER JOIN #SystemSettingRegion ssr ON
		pps.SourceCode = ssr.SourceCode AND
		pps.BudgetRegionId = ssr.RegionId AND
		ssr.SystemSettingName = ''BonusCapExcess''
		
	LEFT OUTER JOIN 
		#Project p ON
			ssr.BonusCapExcessProjectId = p.ProjectId
			
	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		p.PropertyFundId = ProjectPropertyFund.PropertyFundId
	
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON GrSc.SourceCode = pps.SourceCode
		
	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		p.CorporateSourceCode = pfm.SourceCode AND
		--This is a bypass for the ''NULL'' scenario, for only CORP have ActivityTypeId''s set
		ISNULL(p.ActivityTypeId, -1) = ISNULL(pfm.ActivityTypeId, -1) AND 
		pfm.IsDeleted = 0 AND 
		(
		(GrSc.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL) 
		OR
		(
		(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId = p.ActivityTypeId)
		OR
		(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
		)
		) 
	
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		pfm.PropertyFundId = DepartmentPropertyFund.PropertyFundId
		
WHERE
	pps.BonusCapExcessPreTaxAmount <> 0

UNION ALL

-- Get Base Salary Payroll Tax mappings and budget
SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=SalaryTax'' as ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.SalaryTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.SalaryTaxAmount <> 0

-- Get Profit Share Benefit Tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=ProfitShareTax'' as ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.ProfitShareTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.ProfitShareTaxAmount <> 0

-- Get Bonus Tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=BonusTax'' as ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.BonusTaxAmount <> 0

-- Get Bonus cap Tax mappings 
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=BonusCapExcessTax'' as ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusCapExcessTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	0 as Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
	IsNull(p.ActivityTypeId, -1) as ActivityTypeId,
	IsNull(CASE WHEN (p.CorporateDepartmentCode = ''@'' OR p.CorporateDepartmentCode IS NULL) THEN 
				ProjectPropertyFund.PropertyFundId
			ELSE 
				DepartmentPropertyFund.PropertyFundId 
			END, -1) as PropertyFundId,
	-- Same case logic as above
	IsNull(CASE WHEN (p.CorporateDepartmentCode = ''@'' OR p.CorporateDepartmentCode IS NULL) THEN 
				ProjectPropertyFund.ProjectRegionId
			ELSE 
				DepartmentPropertyFund.ProjectRegionId 
			END, -1) as ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityTaxSource pps

	LEFT OUTER JOIN #SystemSettingRegion ssr ON
		pps.SourceCode = ssr.SourceCode AND
		pps.BudgetRegionId = ssr.RegionId AND
		ssr.SystemSettingName = ''BonusCapExcess''

	LEFT OUTER JOIN #Project p ON
		ssr.BonusCapExcessProjectId = p.ProjectId

	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		p.PropertyFundId = ProjectPropertyFund.PropertyFundId

	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON GrSc.SourceCode = pps.SourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		p.CorporateSourceCode = pfm.SourceCode AND
		--ISNULL(p.ActivityTypeId, -1) = ISNULL(pfm.ActivityTypeId, -1) AND 
		pfm.IsDeleted = 0 AND 
		(
		(GrSc.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL) 
		OR
		(
		(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId = p.ActivityTypeId)
		OR
		(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
		)
		)
	
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		pfm.PropertyFundId = DepartmentPropertyFund.PropertyFundId

WHERE
	pps.BonusCapExcessTaxAmount <> 0
	
-- Get Overhead mappings	
UNION ALL

SELECT
	pos.BudgetId,
	pos.ReferenceCode + ''&Type=OverheadAllocation'' as ReferenceCod,
	pos.ExpensePeriod,
	pos.SourceCode,
	pos.OverheadAllocationAmount as BudgetAmount,
	@OccupancyCostsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	pos.MinorGlAccountCategoryId, 
	pos.FunctionalDepartmentId,
	pos.FunctionalDepartmentCode,
	pos.Reimbursable,  
	pos.ActivityTypeId,
	pos.PropertyFundId,
	pos.ProjectRegionId,
	pos.OriginatingRegionCode,
	pos.OriginatingRegionSourceCode,
	pos.LocalCurrencyCode,
	pos.OverheadUpdatedDate
FROM
	#ProfitabilityOverheadSource pos
WHERE
	pos.OverheadAllocationAmount <> 0


PRINT ''Completed inserting records into #ProfitabilityPayrollMapping:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_AllocationUpdatedDate ON #ProfitabilityPayrollMapping(ReferenceCode,AllocationUpdatedDate)
PRINT ''Completed creating indexes on #ProfitabilityPayrollMapping''
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Map mapped source data into the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

------------------------------------------------------------------------------------------------------
-- Additional required mappings
------------------------------------------------------------------------------------------------------

-- Originating region mapping
Select Orm.ImportKey,Orm.OriginatingRegionMappingId,Orm.GlobalRegionId,Orm.SourceCode,Orm.RegionCode,Orm.InsertedDate,Orm.UpdatedDate,Orm.IsDeleted
Into #OriginatingRegionMapping
From Gdm.OriginatingRegionMapping Orm 
		INNER JOIN Gdm.OriginatingRegionMappingActive(@DataPriorToDate) OrmA ON OrmA.ImportKey = Orm.ImportKey


PRINT ''Completed inserting records into #OriginatingRegionMapping:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #OriginatingRegionMapping (RegionCode,SourceCode,IsDeleted,GlobalRegionId)
PRINT ''Completed creating indexes on #OriginatingRegionMapping''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- See hack below. 
Select Arm.ImportKey,Arm.AllocationRegionMappingId,Arm.GlobalRegionId,Arm.SourceCode,Arm.RegionCode,Arm.InsertedDate,Arm.UpdatedDate,Arm.IsDeleted
Into #AllocationRegionMapping
From Gdm.AllocationRegionMapping Arm 
	INNER JOIN Gdm.AllocationRegionMappingActive(@DataPriorToDate) ArmA ON ArmA.ImportKey = Arm.ImportKey

PRINT ''Completed inserting records into #AllocationRegionMapping:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


------------------------------------------------------------------------------------------------------
-- Map to the fact
------------------------------------------------------------------------------------------------------
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--If the join is not possible, default the link to the ''UNKNOWN'' link
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityBudget(
	CalendarKey int NOT NULL,
	GlAccountKey int NOT NULL,
	SourceKey int NOT NULL,
	FunctionalDepartmentKey int NOT NULL,
	ReimbursableKey int NOT NULL,
	ActivityTypeKey int NOT NULL,
	PropertyFundKey int NOT NULL,	
	AllocationRegionKey int NOT NULL,
	OriginatingRegionKey int NOT NULL,
	LocalCurrencyKey int NOT NULL,
	LocalBudget money NOT NULL,
	ReferenceCode Varchar(300) NOT NULL,
	BudgetId int NOT NULL,
	SourceSystemId int NOT NULL,
	
	EUCorporateGlAccountCategoryKey int NULL,
	EUPropertyGlAccountCategoryKey int NULL,
	EUFundGlAccountCategoryKey int NULL,

	USPropertyGlAccountCategoryKey int NULL,
	USCorporateGlAccountCategoryKey int NULL,
	USFundGlAccountCategoryKey int NULL,

	GlobalGlAccountCategoryKey int NULL,
	DevelopmentGlAccountCategoryKey int NULL
) 

INSERT INTO #ProfitabilityBudget 
(
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId
)
SELECT
		DATEDIFF(dd, ''1900-01-01'', LEFT(pbm.ExpensePeriod,4)+''-''+RIGHT(pbm.ExpensePeriod,2)+''-01'') as CalendarKey
		,@GlAccountKey GlAccountKey
		,CASE WHEN GrSc.[SourceKey] IS NULL THEN @SourceKey ELSE GrSc.[SourceKey] END SourceKey
		,CASE WHEN GrFdm.[FunctionalDepartmentKey] IS NULL THEN @FunctionalDepartmentKey ELSE GrFdm.[FunctionalDepartmentKey] END FunctionalDepartmentKey
		,CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKey ELSE GrRi.ReimbursableKey END ReimbursableKey
		,CASE WHEN GrAt.[ActivityTypeKey] IS NULL THEN @ActivityTypeKey ELSE GrAt.[ActivityTypeKey] END ActivityTypeKey
		,CASE WHEN GrPf.[PropertyFundKey] IS NULL THEN @PropertyFundKey ELSE GrPf.[PropertyFundKey] END PropertyFundKey
		,CASE WHEN GrAr.[AllocationRegionKey] IS NULL THEN @AllocationRegionKey ELSE GrAr.[AllocationRegionKey] END AllocationRegionKey
		,CASE WHEN GrOr.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKey ELSE GrOr.[OriginatingRegionKey] END OriginatingRegionKey
		,CASE WHEN GrCu.[CurrencyKey] IS NULL THEN @LocalCurrencyKey ELSE GrCu.[CurrencyKey] END LocalCurrencyKey
		,pbm.BudgetAmount
		,pbm.ReferenceCode
		,pbm.BudgetId
		,@SourceSystemId
FROM
	#ProfitabilityPayrollMapping pbm
	
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON
		pbm.SourceCode = GrSc.SourceCode

	--Parent Level (No job code for payroll)
	LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdm ON
		pbm.AllocationUpdatedDate BETWEEN GrFdm.StartDate AND GrFdm.EndDate AND
		GrFdm.SubFunctionalDepartmentCode = GrFdm.FunctionalDepartmentCode AND
		--GrFdm.ReferenceCode LIKE pbm.FunctionalDepartmentCode +'':%'' AND --replaced by new logic below
		GrFdm.FunctionalDepartmentCode = pbm.FunctionalDepartmentCode
		
	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		CASE WHEN pbm.Reimbursable = 1 THEN ''YES'' ELSE ''NO'' END = GrRi.ReimbursableCode

	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		pbm.ActivityTypeId = GrAt.ActivityTypeId AND
		pbm.AllocationUpdatedDate BETWEEN GrAt.StartDate AND GrAt.EndDate

	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		pbm.PropertyFundId = GrPf.PropertyFundId AND
		pbm.AllocationUpdatedDate BETWEEN GrPf.StartDate AND GrPf.EndDate

	-- HACK: At some point tapas was supposed to pull project region out of GDM. 
	-- Now allocation regions are source based??? So I use the code because it is built up from the ProjectRegionId since there is only data for one source anyway.
	-- I don''t check source because actuals also don''t check source. 
	LEFT OUTER JOIN #AllocationRegionMapping Arm ON
		Arm.RegionCode = pbm.ProjectRegionId AND -- TODO: Pull the RegionCode through from the top.
		Arm.IsDeleted = 0

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		Arm.GlobalRegionId = GrAr.GlobalRegionId AND
		pbm.AllocationUpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate

/* -- At some point Allocation region in GDM was going to become the master list
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		pbm.ProjectRegionId = GrAr.GlobalRegionId AND
		pbm.AllocationUpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate
*/

	LEFT OUTER JOIN #OriginatingRegionMapping Orm ON
		Orm.RegionCode = CASE WHEN RIGHT(pbm.OriginatingRegionSourceCode,1) = ''C'' THEN LTRIM(RTRIM(pbm.OriginatingRegionCode))
								ELSE LTRIM(RTRIM(pbm.OriginatingRegionCode)) + LTRIM(RTRIM(pbm.FunctionalDepartmentCode)) END AND
		Orm.SourceCode = pbm.OriginatingRegionSourceCode AND
		Orm.IsDeleted = 0
		
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		GrOr.GlobalRegionId = Orm.GlobalRegionId AND
		pbm.AllocationUpdatedDate BETWEEN GrOr.StartDate AND GrOr.EndDate
	
	LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
		pbm.LocalCurrencyCode = GrCu.CurrencyCode 

PRINT ''Completed inserting records into #ProfitabilityBudget:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProfitabilityBudget (ReferenceCode)
CREATE INDEX IX_CalendarKey ON #ProfitabilityBudget (CalendarKey)

PRINT ''Completed creating indexes on #OriginatingRegionMapping''
PRINT CONVERT(Varchar(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Remove existing data for modified budget projects
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #DeletingBudget
(
	BudgetId int NOT NULL
)

INSERT INTO #DeletingBudget
(
	BudgetId
)
SELECT DISTINCT 
	BudgetId
FROM
	#Budget

DECLARE @BudgetId int = -1
DECLARE @LoopCount int = 0 -- Infinite loop safe guard
WHILE (EXISTS (SELECT TOP 1 BudgetId FROM #DeletingBudget) AND @LoopCount < 100000)
BEGIN
	
	SET @LoopCount = @LoopCount + 1
	
	SET @BudgetId = (SELECT TOP 1 BudgetId FROM #DeletingBudget)

	-- Remove old facts
	DELETE 
	FROM GrReporting.dbo.ProfitabilityBudget 
	Where BudgetId = @BudgetId and SourceSystemId = @SourceSystemId
	
	PRINT ''Completed deleting records from ProfitabilityBudget:BudgetId=''+CONVERT(varchar,@BudgetId)
	PRINT CONVERT(Varchar(27), getdate(), 121)

	DELETE FROM #DeletingBudget WHERE BudgetId = @BudgetId
END

print ''Cleaned up rows in ProfitabilityBudget''

------------------------------------------------------------------------------------------------------
-- Map account categories
------------------------------------------------------------------------------------------------------
--EUCorporateGlAccountCategoryKey

Select 
		GlAcEUCorp.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #EUCorpCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl
				CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = ''EU Corporate'') GlAcHg
		) Gl
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUCorp ON GlAcEUCorp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+'':''+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+'':''+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate  BETWEEN GlAcEUCorp.StartDate AND GlAcEUCorp.EndDate
				
CREATE UNIQUE CLUSTERED INDEX IX ON #EUCorpCategoryLookup (ReferenceCode)

Update #ProfitabilityBudget
SET	EUCorporateGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @EUCorporateGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END 
From #EUCorpCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityBudget.ReferenceCode


PRINT ''Completed converting all EUCorporateGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--EUPropertyGlAccountCategoryKey
Select 
		GlAcEUProp.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #EUPropCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl
				CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = ''EU Property'') GlAcHg
		) Gl
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUProp ON GlAcEUProp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+'':''+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+'':''+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate  BETWEEN GlAcEUProp.StartDate AND GlAcEUProp.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #EUPropCategoryLookup (ReferenceCode)

Update #ProfitabilityBudget
SET	EUPropertyGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @EUPropertyGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END
From #EUPropCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityBudget.ReferenceCode


PRINT ''Completed converting all EUPropertyGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--EUFundGlAccountCategoryKey
Select 
		GlAcEUFund.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #EUFundCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl
				CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = ''EU Fund'') GlAcHg
		) Gl
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUFund ON GlAcEUFund.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+'':''+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+'':''+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate BETWEEN GlAcEUFund.StartDate AND GlAcEUFund.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #EUFundCategoryLookup (ReferenceCode)

Update #ProfitabilityBudget
SET EUFundGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @EUFundGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END
From #EUFundCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityBudget.ReferenceCode

	
PRINT ''Completed converting all EUFundGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--USPropertyGlAccountCategoryKey
Select 
		GlAcUSProp.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #USPropCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl
				CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = ''US Property'') GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSProp ON GlAcUSProp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+'':''+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+'':''+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate  BETWEEN GlAcUSProp.StartDate AND GlAcUSProp.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #USPropCategoryLookup (ReferenceCode)

Update #ProfitabilityBudget
SET	USPropertyGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @USPropertyGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END
From #USPropCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityBudget.ReferenceCode

PRINT ''Completed converting all USPropertyGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


--USCorporateGlAccountCategoryKey
Select 
		GlAcUSCorp.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #USCorpCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl				
			CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = ''US Corporate'') GlAcHg
		) Gl

		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSCorp ON GlAcUSCorp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+'':''+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+'':''+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate  BETWEEN GlAcUSCorp.StartDate AND GlAcUSCorp.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #USCorpCategoryLookup (ReferenceCode)

Update #ProfitabilityBudget
SET	USCorporateGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @USCorporateGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END
From #USCorpCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityBudget.ReferenceCode


PRINT ''Completed converting all USCorporateGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--USFundGlAccountCategoryKey
Select 
		GlAcUSFund.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #USFundCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl				
				CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = ''US Fund'') GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSFund ON GlAcUSFund.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+'':''+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+'':''+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate  BETWEEN GlAcUSFund.StartDate AND GlAcUSFund.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #USFundCategoryLookup (ReferenceCode)

Update #ProfitabilityBudget
SET	USFundGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @USFundGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END
From #USFundCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityBudget.ReferenceCode


PRINT ''Completed converting all USFundGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

		
--GlobalGlAccountCategoryKey
Select 
		GlAcGlobal.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #GlobalCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl				
				CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = ''Global'') GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcGlobal ON GlAcGlobal.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+'':''+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+'':''+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate  BETWEEN GlAcGlobal.StartDate AND GlAcGlobal.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #GlobalCategoryLookup (ReferenceCode)

Update #ProfitabilityBudget
SET	GlobalGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END
From #GlobalCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityBudget.ReferenceCode



PRINT ''Completed converting all GlobalGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--DevelopmentGlAccountCategoryKey
Select 
		GlAcDevel.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #DevelCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl				
				CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = ''Development'') GlAcHg
		) Gl

		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcDevel ON GlAcDevel.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+'':''+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+'':''+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate  BETWEEN GlAcDevel.StartDate AND GlAcDevel.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #DevelCategoryLookup (ReferenceCode)

Update #ProfitabilityBudget
SET	DevelopmentGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @DevelopmentGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END
From #DevelCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityBudget.ReferenceCode


PRINT ''Completed converting all DevelopmentGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Insert modified and new data 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

INSERT INTO GrReporting.dbo.ProfitabilityBudget
(
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
)
SELECT
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
FROM 
	#ProfitabilityBudget

print ''Rows Inserted in ProfitabilityBudget:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Clean up
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Setup data
DROP TABLE #SystemSettingRegion
DROP TABLE #AllActiveBudget
DROP TABLE #AllModifiedReportBudget
DROP TABLE #FilteredModifiedReportBudget
DROP TABLE #LockedModifiedReportGroup
DROP TABLE #Budget
DROP TABLE #BudgetStatus
DROP TABLE #BudgetReportGroupPeriod
DROP TABLE #BudgetReportGroupDetail
DROP TABLE #BudgetReportGroup
-- Source data
DROP TABLE #BudgetEmployeePayrollAllocation
DROP TABLE #BEPADa
drop table #BudgetEmployeePayrollAllocationDetailBatches
DROP TABLE #BudgetEmployeePayrollAllocationDetail
DROP TABLE #BudgetTaxType
DROP TABLE #TaxType
DROP TABLE #EmployeePayrollAllocationDetail
DROP TABLE #BudgetOverheadAllocation
DROP TABLE #BudgetOverheadAllocationDetail
DROP TABLE #OverheadAllocationDetail
DROP TABLE #BudgetProject
DROP TABLE #Region
DROP TABLE #BudgetEmployeeFunctionalDepartment
DROP TABLE #BudgetEmployee
DROP TABLE #FunctionalDepartment
DROP TABLE #PropertyFund
DROP TABLE #PropertyFundMapping
DROP TABLE #Location
DROP TABLE #RegionExtended
DROP TABLE #PayrollRegion
DROP TABLE #OverheadRegion
DROP TABLE #Project
-- Mapping mapping
DROP TABLE #EffectiveFunctionalDepartment
DROP TABLE #ProfitabilityPreTaxSource
DROP TABLE #ProfitabilityTaxSource
DROP TABLE #ProfitabilityOverheadSource
DROP TABLE #ProfitabilityPayrollMapping
DROP TABLE #ProfitabilityBudget
DROP TABLE #DeletingBudget
-- Account Category Mapping
DROP TABLE #GlobalGlAccountCategoryHierarchyGroup
DROP TABLE #MajorGlAccountCategory
DROP TABLE #MinorGlAccountCategory
-- Additional Mappings
DROP TABLE #OriginatingRegionMapping
DROP TABLE #AllocationRegionMapping
-- Hierarchy Lookups
DROP TABLE #EUCorpCategoryLookup
DROP TABLE #EUPropCategoryLookup
DROP TABLE #EUFundCategoryLookup
DROP TABLE #USCorpCategoryLookup
DROP TABLE #USPropCategoryLookup
DROP TABLE #USFundCategoryLookup
DROP TABLE #GlobalCategoryLookup
DROP TABLE #DevelCategoryLookup

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyCorporateReforecast]    Script Date: 08/05/2010 15:11:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyCorporateReforecast]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyCorporateReforecast]
	@ImportStartDate	DateTime,
	@ImportEndDate		DateTime,
	@DataPriorToDate	DateTime=NULL
AS

SET NOCOUNT ON
IF @DataPriorToDate IS NULL 
	SET @DataPriorToDate = GETDATE()

PRINT ''####''
PRINT ''stp_IU_LoadGrProfitabiltyCorporateReforecast''
PRINT ''####''
--*/

/*
[stp_IU_LoadGrProfitabiltyCorporateReforecast]
	@ImportStartDate	= ''1900-01-01'',
	@ImportEndDate		= ''2010-12-31'',
	@DataPriorToDate	= ''2010-12-31''
*/ 

DECLARE 
      @GlAccountKey				Int = (Select GlAccountKey From GrReporting.dbo.GlAccount WHERE Code = ''UNKNOWN''),
      @SourceKey				Int = (Select SourceKey From GrReporting.dbo.Source Where SourceName = ''UNKNOWN''),
      @FunctionalDepartmentKey	Int = (Select FunctionalDepartmentKey From GrReporting.dbo.FunctionalDepartment Where FunctionalDepartmentCode = ''UNKNOWN''),
      @ReimbursableKey			Int = (Select ReimbursableKey From GrReporting.dbo.Reimbursable Where ReimbursableCode = ''UNKNOWN''),
      @ActivityTypeKey			Int = (Select ActivityTypeKey From GrReporting.dbo.ActivityType Where ActivityTypeCode = ''UNKNOWN''),
      @PropertyFundKey			Int = (Select PropertyFundKey From GrReporting.dbo.PropertyFund Where PropertyFundName = ''UNKNOWN''),
      @AllocationRegionKey		Int = (Select AllocationRegionKey From GrReporting.dbo.AllocationRegion Where RegionCode = ''UNKNOWN''),
      @OriginatingRegionKey		Int = (Select OriginatingRegionKey From GrReporting.dbo.OriginatingRegion Where RegionCode = ''UNKNOWN''),
      @LocalCurrencyKey			Int = (Select CurrencyKey From GrReporting.dbo.Currency Where CurrencyCode = ''UNKNOWN'')

DECLARE
		@EUFundGlAccountCategoryKeyUnknown				Int,
		@EUCorporateGlAccountCategoryKeyUnknown			Int,
		@EUPropertyGlAccountCategoryKeyUnknown			Int,
		@USFundGlAccountCategoryKeyUnknown				Int,
		@USPropertyGlAccountCategoryKeyUnknown			Int,
		@USCorporateGlAccountCategoryKeyUnknown			Int,
		@DevelopmentGlAccountCategoryKeyUnknown			Int,
		@GlobalGlAccountCategoryKeyUnknown				Int
		
SET @EUFundGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Fund'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND AccountTypeName = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @EUCorporateGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Corporate'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND AccountTypeName = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @EUPropertyGlAccountCategoryKeyUnknown  = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Property'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND AccountTypeName = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @USFundGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Fund'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND AccountTypeName = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @USPropertyGlAccountCategoryKeyUnknown  = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Property'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND AccountTypeName = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @USCorporateGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Corporate'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND AccountTypeName = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @DevelopmentGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''Development'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND AccountTypeName = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @GlobalGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global'' AND TranslationSubTypeName = ''Global'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND AccountTypeName = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')

DECLARE @SourceSystemId int
SET @SourceSystemId = 1 -- Corporate budgeting source system

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Source Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

------------------------------------------------------------------------------------------------------
--Source allocation records
------------------------------------------------------------------------------------------------------

PRINT ''Start''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget line item.
SELECT
	CAST(Budget.BudgetYear AS VARCHAR(4)) + CASE Budget.BudgetPeriodCode 
												WHEN ''Q1'' THEN CASE WHEN Budget.BudgetYear = 2010 THEN ''03'' /*March isn Q1 start in 2010 - Ask Mike Caracciolo why*/ ELSE ''04'' END --Q1 - April (04)
												WHEN ''Q2'' THEN ''06'' --Q2 - June (06)
												WHEN ''Q3'' THEN ''10'' --Q3 - Oct (10)
												ELSE ''01'' -- Default to Q0 Jan (01)
											END as FirstProjectedPeriod,
	Budget.*
INTO
	#Budget
FROM
	BudgetingCorp.GlobalReportingCorporateBudget Budget
	INNER JOIN BudgetingCorp.GlobalReportingCorporateBudgetActive(@DataPriorToDate) BudgetA ON
		Budget.ImportKey = BudgetA.ImportKey
WHERE
	Budget.LockedDate IS NOT NULL AND
	Budget.LockedDate BETWEEN @ImportStartDate AND @ImportEndDate AND
	Budget.BudgetPeriodCode <> ''Q0'' -- Reforecast budget values only

PRINT ''Rows Inserted into #Budget::''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
------------------------------------------------------------------------------------------------------
--Source associated records
------------------------------------------------------------------------------------------------------

-- Source Gl Account
SELECT
	gla.*
INTO
	#GlAccount
FROM
	Gdm.GlGlobalAccount gla
	INNER JOIN Gdm.GlGlobalAccountActive(@DataPriorToDate) glaA ON
		gla.ImportKey = glaA.ImportKey 

PRINT ''Rows Inserted into #GlAccount::''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Functional Department
SELECT 
	fd.* 
INTO
	#FunctionalDepartment
FROM 
	HR.FunctionalDepartment fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) fdA ON
		fd.ImportKey = fdA.ImportKey

PRINT ''Rows Inserted into #FunctionalDepartment:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Activity Type
SELECT
	at.*
INTO
	#ActivityType
FROM
	Gdm.ActivityType at
	INNER JOIN Gdm.ActivityTypeActive(@DataPriorToDate) atA ON
		at.ImportKey = atA.ImportKey

PRINT ''Rows Inserted into #ActvityType:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source originating region
SELECT
	gr.*
INTO
	#GlobalRegion
FROM
	Gdm.GlobalRegion gr
	INNER JOIN Gdm.GlobalRegionActive(@DataPriorToDate) grA ON
		gr.ImportKey = grA.ImportKey 

PRINT ''Rows Inserted into #GlobalRegion:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Property Fund Mapping (untill the switch over to GBS all budgets sourced from the grinder will use old mappings)
SELECT 
	PropertyFundMapping.* 
INTO
	#PropertyFundMapping
FROM 
	Gdm.PropertyFundMapping PropertyFundMapping
	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PropertyFundMappingA ON
		PropertyFundMapping.ImportKey = PropertyFundMappingA.ImportKey 

PRINT ''Rows Inserted into #PropertyFundMapping:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFundMapping (PropertyFundCode,SourceCode,IsDeleted,PropertyFundId,ActivityTypeId)

-- Source Property Fund
SELECT 
	PropertyFund.* 
INTO
	#PropertyFund
FROM 
	Gdm.PropertyFund PropertyFund
	INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PropertyFundA ON
		PropertyFund.ImportKey = PropertyFundA.ImportKey 

PRINT ''Completed inserting records into #PropertyFund:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFund (PropertyFundId)
PRINT ''Completed creating indexes on #PropertyFund''
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE TABLE #GLTranslationType(
	ImportKey INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLTranslationSubType(
	ImportKey INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsGRDefault BIT NOT NULL
)

CREATE TABLE #GLGlobalAccountTranslationType(
	ImportKey INT NOT NULL,
	GLGlobalAccountTranslationTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLGlobalAccountTranslationSubType(
	ImportKey INT NOT NULL,
	GLGlobalAccountTranslationSubTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	PostingPropertyGLAccountCode VARCHAR(14) NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMajorCategory(
	ImportKey INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMinorCategory(
	ImportKey INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

-- #GLGlobalAccountTranslationType

INSERT INTO
	#GLGlobalAccountTranslationType (ImportKey, GLGlobalAccountTranslationTypeId, GLGlobalAccountId, GLTranslationTypeId, GLAccountTypeId,
	GLAccountSubTypeId, IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	GATT.ImportKey, GATT.GLGlobalAccountTranslationTypeId, GATT.GLGlobalAccountId, GATT.GLTranslationTypeId, GATT.GLAccountTypeId,
	GATT.GLAccountSubTypeId, GATT.IsActive, GATT.InsertedDate, GATT.UpdatedDate, GATT.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccountTranslationType GATT
	INNER JOIN Gdm.GLGlobalAccountGLAccountActive(@DataPriorToDate) GATTA ON
		GATTA.ImportKey = GATT.ImportKey

-- #GLGlobalAccountTranslationSubType

INSERT INTO
	#GLGlobalAccountTranslationSubType (ImportKey, GLGlobalAccountTranslationSubTypeId, GLGlobalAccountId, GLTranslationSubTypeId, GLMinorCategoryId,
	PostingPropertyGLAccountCode, IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	GATST.ImportKey, GATST.GLGlobalAccountTranslationSubTypeId, GATST.GLGlobalAccountId, GATST.GLTranslationSubTypeId, GATST.GLMinorCategoryId,
	GATST.PostingPropertyGLAccountCode, GATST.IsActive, GATST.InsertedDate, GATST.UpdatedDate, GATST.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccountTranslationSubType GATST
	INNER JOIN Gdm.GLGlobalAccountTranslationSubTypeActive(@DataPriorToDate) GATSTA ON
		GATSTA.ImportKey = GATST.ImportKey

-- #GLTranslationType

INSERT INTO
	#GLTranslationType (ImportKey, GLTranslationTypeId, Code, [Name], [Description], IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	TT.ImportKey, TT.GLTranslationTypeId, TT.Code, TT.[Name], TT.[Description], TT.IsActive, TT.InsertedDate, TT.UpdatedDate, TT.UpdatedByStaffId
FROM
	Gdm.GLTranslationType TT
	INNER JOIN Gdm.GLTranslationTypeActive(@DataPriorToDate) TTA ON
		TTA.ImportKey = TT.ImportKey

-- #GLTranslationSubType

INSERT INTO
	#GLTranslationSubType (ImportKey, GLTranslationSubTypeId, GLTranslationTypeId, Code, [Name], IsActive, InsertedDate, UpdatedDate,
	UpdatedByStaffId, IsGRDefault)
SELECT
	TST.ImportKey, TST.GLTranslationSubTypeId, TST.GLTranslationTypeId, TST.Code, TST.[Name], TST.IsActive, TST.InsertedDate, TST.UpdatedDate,
	TST.UpdatedByStaffId, TST.IsGRDefault
FROM
	Gdm.GLTranslationSubType TST
	INNER JOIN Gdm.GLTranslationSubTypeActive(@DataPriorToDate) TSTA ON
		TSTA.ImportKey = TST.ImportKey

-- #GLMajorCategory

INSERT INTO
	#GLMajorCategory (ImportKey, GLMajorCategoryId, GLTranslationSubTypeId, [Name], IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	MajC.ImportKey, MajC.GLMajorCategoryId, MajC.GLTranslationSubTypeId, MajC.[Name], MajC.IsActive, MajC.InsertedDate, MajC.UpdatedDate, MajC.UpdatedByStaffId
FROM
	Gdm.GLMajorCategory MajC
	INNER JOIN Gdm.GLMajorCategoryActive(@DataPriorToDate) MajCA ON
		MajC.ImportKey = MajCA.ImportKey

-- #GLMinorCategory

INSERT INTO
	#GLMinorCategory (ImportKey, GLMinorCategoryId, GLMajorCategoryId, [Name], IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	Minc.ImportKey, Minc.GLMinorCategoryId, Minc.GLMajorCategoryId, Minc.[Name], Minc.IsActive, Minc.InsertedDate, Minc.UpdatedDate, Minc.UpdatedByStaffId
FROM
	Gdm.GLMinorCategory MinC
	INNER JOIN Gdm.GLMinorCategoryActive(@DataPriorToDate) MinCA ON
		MinCA.ImportKey = MinC.ImportKey


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Map Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

--Map reforecast budget Amounts
CREATE TABLE #ProfitabilitySource
(
	BudgetId int NOT NULL,
	ReferenceCode varchar(300) NOT NULL,
	FirstProjectedPeriod char(6) NOT NULL,
	ExpensePeriod char(6) NOT NULL,	
	SourceCode varchar(2) NULL,
	ReforecastAmount money NOT NULL,
	GlGlobalAccountCode varchar(21) NOT NULL,
	GlGlobalAccountId int NOT NULL,
	FunctionalDepartmentCode varchar(31) NULL,
	FunctionalDepartmentId int NULL,
	JobCode varchar(20) NULL,
	Reimbursable bit NULL,
	ActivityTypeCode varchar(10) NULL,
	ActivityTypeId int NOT NULL,
	PropertyFundId int NULL,
	AllocationSubRegionGlobalRegionId int NOT NULL,
	OriginatingRegionCode char(6) NULL,
	OriginatingGlobalRegionId int NULL,
	LocalCurrencyCode char(3) NOT NULL,
	LockedDate datetime NOT NULL,
	IsExpense bit NOT NULL
)
-- Insert reforecast budget amounts
INSERT INTO #ProfitabilitySource
(
	BudgetId,
	ReferenceCode,
	FirstProjectedPeriod,
	ExpensePeriod,
	SourceCode,
	ReforecastAmount,
	GlGlobalAccountCode,
	GlGlobalAccountId,
	FunctionalDepartmentCode,
	FunctionalDepartmentId,
	JobCode,
	Reimbursable,
	ActivityTypeCode,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingGlobalRegionId,
	LocalCurrencyCode,
	LockedDate,
	IsExpense
)

SELECT 
	b.BudgetId,
	''BC:'' + b.SourceUniqueKey + ''&ImportKey='' + CONVERT(varchar, b.ImportKey) as ReferenceCode,
	b.FirstProjectedPeriod,
	b.Period as ExpensePeriod,
	b.SourceCode,
	b.LocalAmount as ReforecastAmount,
	CONVERT(varchar,b.GlobalGlAccountCode) as GlGlobalAccountCode,
	IsNull(gla.GLGlobalAccountId,-1) as GlGlobalAccountId,
	b.FunctionalDepartmentGlobalCode as FunctionalDepartmentCode,
	IsNull(fd.FunctionalDepartmentId,-1),
	b.JobCode,
	b.IsReimbursable as Reimbursable,
	at.ActivityTypeCode,
	IsNull(at.ActivityTypeId,-1),
	pfm.PropertyFundId,
	IsNull(DepartmentPropertyFund.AllocationSubRegionGlobalRegionId,-1) as ProjectRegionId,
	b.OriginatingSubRegionCode as OriginatingRegionCode,
	IsNull(gr.GlobalRegionId,-1) as OriginatingGlobalRegionId,
	b.InternationalCurrencyCode as LocalCurrencyCode,
	b.LockedDate,
	b.IsExpense
FROM
	#Budget b 
	
	LEFT OUTER JOIN #GlAccount gla ON
		b.GlobalGlAccountCode = gla.Code
		
	LEFT OUTER JOIN #FunctionalDepartment fd ON
		b.FunctionalDepartmentGlobalCode = fd.GlobalCode
		
	LEFT OUTER JOIN #ActivityType at ON
		gla.ActivityTypeId = at.ActivityTypeId
		
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON GrSc.SourceCode = b.SourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		b.NonPayrollCorporateMRIDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		b.SourceCode = pfm.SourceCode AND 
		(
			(GrSc.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL) OR
			(
				(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId = at.ActivityTypeId) OR
				(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND at.ActivityTypeId IS NULL)
			)
		) AND
		pfm.IsDeleted = 0
		
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		pfm.PropertyFundId = DepartmentPropertyFund.PropertyFundId
		
	LEFT OUTER JOIN #GlobalRegion gr ON
		b.OriginatingSubRegionCode = gr.Code

WHERE
	b.LocalAmount <> 0 --AND
	--(b.Period >= b.FirstProjectedPeriod OR b.FirstProjectedPeriod = ''201003'') -- Get only reforecasted budgeted amounts 
	--(UPDATED: Hack the planet: Now also source actuals for non payroll (including fees) for reforecast Q1, 201003 from the grinder (Yes Q1 201003 - Ask MikeC))


PRINT ''Rows Inserted into #ProfitabilitySource:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)



-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Map mapped source data into the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

------------------------------------------------------------------------------------------------------
-- Additional required mappings
------------------------------------------------------------------------------------------------------

-- See hack below. 
SELECT
	asr.*
INTO
	#AllocationSubRegion
FROM
	Gdm.AllocationSubRegion asr
	INNER JOIN Gdm.AllocationSubRegionActive(@DataPriorToDate) asrA ON
		asr.ImportKey = asrA.ImportKey
		
PRINT ''Rows Inserted into #AllocationSubRegion''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--If the join is not possible, default the link to the ''UNKNOWN'' link
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityReforecast(
	CalendarKey int NOT NULL,
	ReforecastKey int NOT NULL,
	GlAccountKey int NOT NULL,
	SourceKey int NOT NULL,
	FunctionalDepartmentKey int NOT NULL,
	ReimbursableKey int NOT NULL,
	ActivityTypeKey int NOT NULL,
	PropertyFundKey int NOT NULL,	
	AllocationRegionKey int NOT NULL,
	OriginatingRegionKey int NOT NULL,
	LocalCurrencyKey int NOT NULL,
	LocalReforecast money NOT NULL,
	ReferenceCode Varchar(300) NOT NULL,
	BudgetId int NOT NULL,
	SourceSystemId int NOT NULL,

	EUCorporateGlAccountCategoryKey int NULL,
	EUPropertyGlAccountCategoryKey int NULL,
	EUFundGlAccountCategoryKey int NULL,

	USPropertyGlAccountCategoryKey int NULL,
	USCorporateGlAccountCategoryKey int NULL,
	USFundGlAccountCategoryKey int NULL,

	GlobalGlAccountCategoryKey int NULL,
	DevelopmentGlAccountCategoryKey int NULL
) 

INSERT INTO #ProfitabilityReforecast 
(
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	SourceSystemId
)
SELECT
		DATEDIFF(dd, ''1900-01-01'', LEFT(ps.ExpensePeriod,4)+''-''+RIGHT(ps.ExpensePeriod,2)+''-01'') as CalendarKey
		,DATEDIFF(dd, ''1900-01-01'', LEFT(ps.FirstProjectedPeriod,4)+''-''+RIGHT(ps.FirstProjectedPeriod,2)+''-01'') as ReforecastKey
		,CASE WHEN GrGl.[GlAccountKey] IS NULL THEN @GlAccountKey ELSE GrGl.[GlAccountKey] END GlAccountKey
		,CASE WHEN GrSc.[SourceKey] IS NULL THEN @SourceKey ELSE GrSc.[SourceKey] END SourceKey
		,CASE WHEN ISNULL(GrFdmD.[FunctionalDepartmentKey], GrFdmP.[FunctionalDepartmentKey]) IS NULL THEN @FunctionalDepartmentKey ELSE ISNULL(GrFdmD.[FunctionalDepartmentKey], GrFdmP.[FunctionalDepartmentKey]) END FunctionalDepartmentKey
		,CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKey ELSE GrRi.ReimbursableKey END ReimbursableKey
		,CASE WHEN GrAt.[ActivityTypeKey] IS NULL THEN @ActivityTypeKey ELSE GrAt.[ActivityTypeKey] END ActivityTypeKey
		,CASE WHEN GrPf.[PropertyFundKey] IS NULL THEN @PropertyFundKey ELSE GrPf.[PropertyFundKey] END PropertyFundKey
		,CASE WHEN GrAr.[AllocationRegionKey] IS NULL THEN @AllocationRegionKey ELSE GrAr.[AllocationRegionKey] END AllocationRegionKey
		,CASE WHEN IsNull(ps.IsExpense,-1) = 0 THEN 
			CASE WHEN GrOrFee.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKey ELSE GrOrFee.[OriginatingRegionKey] END 
		 ELSE 
			CASE WHEN GrOr.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKey ELSE GrOr.[OriginatingRegionKey] END 
		 END OriginatingRegionKey
		,CASE WHEN GrCu.[CurrencyKey] IS NULL THEN @LocalCurrencyKey ELSE GrCu.[CurrencyKey] END LocalCurrencyKey
		,ps.ReforecastAmount
		,ps.ReferenceCode
		,ps.BudgetId
		,@SourceSystemId
FROM
	#ProfitabilitySource ps
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccount GrGl ON
		ps.GlGlobalAccountId = GrGl.GlGlobalAccountId AND
		ps.LockedDate BETWEEN GrGl.StartDate AND GrGl.EndDate
	
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON
		ps.SourceCode = GrSc.SourceCode

	--Detail/Sub Level (job level)
	LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdmD ON
		ps.LockedDate  BETWEEN GrFdmD.StartDate AND GrFdmD.EndDate AND
		GrFdmD.SubFunctionalDepartmentCode <> GrFdmD.FunctionalDepartmentCode AND
		--GrFdmD.ReferenceCode LIKE ''%:''+ ps.JobCode --new substitude below
		GrFdmD.SubFunctionalDepartmentCode = ps.JobCode
			
	--Parent Level
	LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdmP ON
		ps.LockedDate  BETWEEN GrFdmP.StartDate AND GrFdmP.EndDate AND
		GrFdmP.SubFunctionalDepartmentCode = GrFdmP.FunctionalDepartmentCode AND
		--GrFdmP.ReferenceCode LIKE ps.FunctionalDepartmentCode +'':%'' --new substitude below
		GrFdmP.FunctionalDepartmentCode = ps.FunctionalDepartmentCode
		
	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		CASE WHEN ps.Reimbursable = 1 THEN ''YES'' ELSE ''NO'' END = GrRi.ReimbursableCode

	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		ps.ActivityTypeId = GrAt.ActivityTypeId AND
		ps.LockedDate BETWEEN GrAt.StartDate AND GrAt.EndDate

	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		ps.PropertyFundId = GrPf.PropertyFundId AND
		ps.LockedDate BETWEEN GrPf.StartDate AND GrPf.EndDate

	LEFT OUTER JOIN #AllocationSubRegion Asr ON
		ps.AllocationSubRegionGlobalRegionId = Asr.AllocationSubRegionGlobalRegionId AND
		Asr.IsActive = 1

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		Asr.AllocationSubRegionGlobalRegionId = GrAr.GlobalRegionId AND
		ps.LockedDate BETWEEN GrAr.StartDate AND GrAr.EndDate

	-- This is only used for fees. It sets the originating region to the allocation region
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOrFee ON
		Asr.AllocationSubRegionGlobalRegionId = GrOrFee.GlobalRegionId AND
		ps.LockedDate BETWEEN GrOrFee.StartDate AND GrOrFee.EndDate


	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		ps.OriginatingRegionCode = GrOr.SubRegionCode AND
		ps.LockedDate BETWEEN GrOr.StartDate AND GrOr.EndDate

	LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
		ps.LocalCurrencyCode = GrCu.CurrencyCode 


PRINT ''Rows Inserted into #ProfitabilityReforecast:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_GlAcocuntKey ON #ProfitabilityReforecast (GlAccountKey)
PRINT ''Created Index on GlAccountKey #ProfitabilityReforecast''
PRINT CONVERT(Varchar(27), getdate(), 121)

-------------------------------------------------------------------------------------------------------------------

-- EUCorporateGlAccountCategoryKey
UPDATE
	#ProfitabilityReforecast
SET
	EUCorporateGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUCorporateGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END 
FROM
	#ProfitabilityReforecast Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = ''EU CORP'' AND 
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND 
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))
		
			
PRINT ''Completed converting all EUCorporateGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--EUPropertyGlAccountCategoryKey
UPDATE
	#ProfitabilityReforecast
SET
	EUPropertyGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUPropertyGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityReforecast Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = ''EU PROP'' AND
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT ''Completed converting all EUPropertyGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)


--EUFundGlAccountCategoryKey
UPDATE
	#ProfitabilityReforecast
SET
	EUFundGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUFundGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityReforecast Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = ''EU FUND'' AND 
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND 
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))
	
PRINT ''Completed converting all EUFundGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USPropertyGlAccountCategoryKey
UPDATE
	#ProfitabilityReforecast
SET
	USPropertyGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USPropertyGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityReforecast Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = ''US PROP'' AND 
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND 
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT ''Completed converting all USPropertyGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USCorporateGlAccountCategoryKey
UPDATE
	#ProfitabilityReforecast
SET
	USCorporateGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USCorporateGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
From #ProfitabilityReforecast Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = ''US CORP'' AND 
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND 
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT ''Completed converting all USCorporateGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USFundGlAccountCategoryKey
UPDATE
	#ProfitabilityReforecast
SET
	USFundGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USFundGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityReforecast Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = ''US FUND'' AND 
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND 
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT ''Completed converting all USFundGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

		
--GlobalGlAccountCategoryKey
UPDATE
	#ProfitabilityReforecast
SET
	GlobalGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM #ProfitabilityReforecast Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = ''GL'' AND 
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND 
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT ''Completed converting all GlobalGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--DevelopmentGlAccountCategoryKey
UPDATE
	#ProfitabilityReforecast
SET
	DevelopmentGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @DevelopmentGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM #ProfitabilityReforecast Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = ''DEV'' AND 
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND 
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT ''Completed converting all DevelopmentGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)



-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Remove existing data for modified reforecast budget projects
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #DeletingBudget
(
	BudgetId int NOT NULL
)

INSERT INTO #DeletingBudget
(
	BudgetId
)
SELECT DISTINCT 
	BudgetId
FROM
	#ProfitabilityReforecast

PRINT ''Rows Inserted into #DeletingReforecast:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Remove 
DECLARE @BudgetId int = -1
DECLARE @LoopCount int = 0 -- Infinite loop safe guard
WHILE (EXISTS (SELECT TOP 1 BudgetId FROM #DeletingBudget) AND @LoopCount < 100000)
BEGIN
	
	SET @LoopCount = @LoopCount + 1
	
	SET @BudgetId = (SELECT TOP 1 BudgetId FROM #DeletingBudget)

	-- Remove old facts
	DELETE 
	FROM GrReporting.dbo.ProfitabilityReforecast 
	Where BudgetId = @BudgetId and SourceSystemId = @SourceSystemId
		
	PRINT ''Rows Deleted from ProfitabilityReforecast:''+CONVERT(char(10),@@rowcount)
	PRINT CONVERT(Varchar(27), getdate(), 121)
	
	DELETE FROM #DeletingBudget WHERE BudgetId = @BudgetId
	
	PRINT ''Rows Deleted from #DeletingBudget:''+CONVERT(char(10),@@rowcount)
	PRINT CONVERT(Varchar(27), getdate(), 121)
	
END

print ''Cleaned up rows in ProfitabilityReforecast''


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Insert modified and new fact data 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

INSERT INTO GrReporting.dbo.ProfitabilityReforecast
(
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
)
SELECT
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
FROM 
	#ProfitabilityReforecast


PRINT ''Rows Inserted into #ProfitabilityReforecast:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)



	
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Clean up
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Source data
DROP TABLE #Budget
DROP TABLE #GlAccount
DROP TABLE #FunctionalDepartment
DROP TABLE #ActivityType
DROP TABLE #GlobalRegion
DROP TABLE #PropertyFundMapping
DROP TABLE #PropertyFund
DROP TABLE #AllocationSubRegion
-- Mapping mapping
DROP TABLE #ProfitabilitySource
DROP TABLE #DeletingBudget
DROP TABLE #ProfitabilityReforecast
-- Account Category Mapping
DROP TABLE #GLTranslationType
DROP TABLE #GLTranslationSubType
DROP TABLE #GLGlobalAccountTranslationType
DROP TABLE #GLGlobalAccountTranslationSubType
DROP TABLE #GLMajorCategory
DROP TABLE #GLMinorCategory


' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]    Script Date: 08/05/2010 15:11:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]
	@ImportStartDate	DateTime,
	@ImportEndDate		DateTime,
	@DataPriorToDate	DateTime=NULL
AS

SET NOCOUNT ON
IF @DataPriorToDate IS NULL 
	SET @DataPriorToDate = GETDATE()

PRINT ''####''
PRINT ''stp_IU_LoadGrProfitabiltyCorporateOriginalBudget''
PRINT ''####''
--*/

/*
[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]
	@ImportStartDate	= ''1900-01-01'',
	@ImportEndDate		= ''2010-12-31'',
	@DataPriorToDate	= ''2010-12-31''
*/ 

DECLARE 
      @GlAccountKey				Int = (SELECT GlAccountKey FROM GrReporting.dbo.GlAccount WHERE Code = ''UNKNOWN''),
      @SourceKey				Int = (Select SourceKey From GrReporting.dbo.Source Where SourceName = ''UNKNOWN''),
      @FunctionalDepartmentKey	Int = (Select FunctionalDepartmentKey From GrReporting.dbo.FunctionalDepartment Where FunctionalDepartmentCode = ''UNKNOWN''),
      @ReimbursableKey			Int = (Select ReimbursableKey From GrReporting.dbo.Reimbursable Where ReimbursableCode = ''UNKNOWN''),
      @ActivityTypeKey			Int = (Select ActivityTypeKey From GrReporting.dbo.ActivityType Where ActivityTypeCode = ''UNKNOWN''),
      @PropertyFundKey			Int = (Select PropertyFundKey From GrReporting.dbo.PropertyFund Where PropertyFundName = ''UNKNOWN''),
      @AllocationRegionKey		Int = (Select AllocationRegionKey From GrReporting.dbo.AllocationRegion Where RegionCode = ''UNKNOWN''),
      @OriginatingRegionKey		Int = (Select OriginatingRegionKey From GrReporting.dbo.OriginatingRegion Where RegionCode = ''UNKNOWN''),
      @LocalCurrencyKey			Int = (Select CurrencyKey From GrReporting.dbo.Currency Where CurrencyCode = ''UNKNOWN'')

DECLARE
		@EUFundGlAccountCategoryKeyUnknown				Int,
		@EUCorporateGlAccountCategoryKeyUnknown			Int,
		@EUPropertyGlAccountCategoryKeyUnknown			Int,
		@USFundGlAccountCategoryKeyUnknown				Int,
		@USPropertyGlAccountCategoryKeyUnknown			Int,
		@USCorporateGlAccountCategoryKeyUnknown			Int,
		@DevelopmentGlAccountCategoryKeyUnknown			Int,
		@GlobalGlAccountCategoryKeyUnknown				Int
	
SET @EUFundGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Fund'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND AccountTypeName = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @EUCorporateGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Corporate'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND AccountTypeName = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @EUPropertyGlAccountCategoryKeyUnknown  = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Property'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND AccountTypeName = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @USFundGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Fund'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND AccountTypeName = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @USPropertyGlAccountCategoryKeyUnknown  = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Property'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND AccountTypeName = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @USCorporateGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Corporate'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND AccountTypeName = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @DevelopmentGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''Development'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND AccountTypeName = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
SET @GlobalGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global'' AND TranslationSubTypeName = ''Global'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND AccountTypeName = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')

DECLARE @SourceSystemId int
SET @SourceSystemId = 1 -- Corporate budgeting source system

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Source Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

------------------------------------------------------------------------------------------------------
--Source allocation records
------------------------------------------------------------------------------------------------------

PRINT ''Start''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget line item.
SELECT	
	Budget.*
INTO
	#Budget
FROM
	BudgetingCorp.GlobalReportingCorporateBudget Budget
	INNER JOIN BudgetingCorp.GlobalReportingCorporateBudgetActive(@DataPriorToDate) BudgetA ON
		Budget.ImportKey = BudgetA.ImportKey
WHERE
	Budget.LockedDate IS NOT NULL AND
	Budget.LockedDate BETWEEN @ImportStartDate AND @ImportEndDate AND
	Budget.BudgetPeriodCode = ''Q0'' -- Original budget values only

PRINT ''Rows Inserted into #Budget::''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
------------------------------------------------------------------------------------------------------
--Source associated records
------------------------------------------------------------------------------------------------------

-- Source Gl Account
SELECT
	gla.*
INTO
	#GlAccount
FROM
	Gdm.GLGlobalAccount gla
	INNER JOIN Gdm.GLGlobalAccountActive(@DataPriorToDate) glaA ON
		gla.ImportKey = glaA.ImportKey 

PRINT ''Rows Inserted into #GlAccount::''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Functional Department
SELECT 
	fd.* 
INTO
	#FunctionalDepartment
FROM 
	HR.FunctionalDepartment fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) fdA ON
		fd.ImportKey = fdA.ImportKey

PRINT ''Rows Inserted into #FunctionalDepartment:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Activity Type
SELECT
	at.*
INTO
	#ActivityType
FROM
	Gdm.ActivityType at
	INNER JOIN Gdm.ActivityTypeActive(@DataPriorToDate) atA ON
		at.ImportKey = atA.ImportKey

PRINT ''Rows Inserted into #ActvityType:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source originating region
SELECT
	gr.*
INTO
	#GlobalRegion
FROM
	Gdm.GlobalRegion gr
	INNER JOIN Gdm.GlobalRegionActive(@DataPriorToDate) grA ON
		gr.ImportKey = grA.ImportKey 

PRINT ''Rows Inserted into #GlobalRegion:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Property Fund Mappings (untill the switch over to GBS all budgets sourced from the grinder will use old mappings)
SELECT
	pfm.*
INTO
	#PropertyFundMapping
FROM
	Gdm.PropertyFundMapping Pfm 
	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PfmA ON
		PfmA.ImportKey = Pfm.ImportKey
		
PRINT ''Rows Inserted into #PropertyFundMapping''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFundMapping (PropertyFundCode, SourceCode, IsDeleted, PropertyFundId, PropertyFundMappingId, ActivityTypeId)

-- Source Property Fund
SELECT 
	PropertyFund.* 
INTO
	#PropertyFund
FROM 
	Gdm.PropertyFund PropertyFund
	INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PropertyFundA ON
		PropertyFund.ImportKey = PropertyFundA.ImportKey 

PRINT ''Completed inserting records into #PropertyFund:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFund (PropertyFundId)
PRINT ''Completed creating indexes on #PropertyFund''
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE TABLE #GLTranslationType(
	ImportKey INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLTranslationSubType(
	ImportKey INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsGRDefault BIT NOT NULL
)

CREATE TABLE #GLGlobalAccountTranslationType(
	ImportKey INT NOT NULL,
	GLGlobalAccountTranslationTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLGlobalAccountTranslationSubType(
	ImportKey INT NOT NULL,
	GLGlobalAccountTranslationSubTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	PostingPropertyGLAccountCode VARCHAR(14) NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMajorCategory(
	ImportKey INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMinorCategory(
	ImportKey INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

-- #GLGlobalAccountTranslationType

INSERT INTO
	#GLGlobalAccountTranslationType (ImportKey, GLGlobalAccountTranslationTypeId, GLGlobalAccountId, GLTranslationTypeId, GLAccountTypeId,
	GLAccountSubTypeId, IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	GATT.ImportKey, GATT.GLGlobalAccountTranslationTypeId, GATT.GLGlobalAccountId, GATT.GLTranslationTypeId, GATT.GLAccountTypeId,
	GATT.GLAccountSubTypeId, GATT.IsActive, GATT.InsertedDate, GATT.UpdatedDate, GATT.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccountTranslationType GATT
	INNER JOIN Gdm.GLGlobalAccountGLAccountActive(@DataPriorToDate) GATTA ON
		GATTA.ImportKey = GATT.ImportKey

-- #GLGlobalAccountTranslationSubType

INSERT INTO
	#GLGlobalAccountTranslationSubType (ImportKey, GLGlobalAccountTranslationSubTypeId, GLGlobalAccountId, GLTranslationSubTypeId, GLMinorCategoryId,
	PostingPropertyGLAccountCode, IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	GATST.ImportKey, GATST.GLGlobalAccountTranslationSubTypeId, GATST.GLGlobalAccountId, GATST.GLTranslationSubTypeId, GATST.GLMinorCategoryId,
	GATST.PostingPropertyGLAccountCode, GATST.IsActive, GATST.InsertedDate, GATST.UpdatedDate, GATST.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccountTranslationSubType GATST
	INNER JOIN Gdm.GLGlobalAccountTranslationSubTypeActive(@DataPriorToDate) GATSTA ON
		GATSTA.ImportKey = GATST.ImportKey

-- #GLTranslationType

INSERT INTO
	#GLTranslationType (ImportKey, GLTranslationTypeId, Code, [Name], [Description], IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	TT.ImportKey, TT.GLTranslationTypeId, TT.Code, TT.[Name], TT.[Description], TT.IsActive, TT.InsertedDate, TT.UpdatedDate, TT.UpdatedByStaffId
FROM
	Gdm.GLTranslationType TT
	INNER JOIN Gdm.GLTranslationTypeActive(@DataPriorToDate) TTA ON
		TTA.ImportKey = TT.ImportKey

-- #GLTranslationSubType

INSERT INTO
	#GLTranslationSubType (ImportKey, GLTranslationSubTypeId, GLTranslationTypeId, Code, [Name], IsActive, InsertedDate, UpdatedDate,
	UpdatedByStaffId, IsGRDefault)
SELECT
	TST.ImportKey, TST.GLTranslationSubTypeId, TST.GLTranslationTypeId, TST.Code, TST.[Name], TST.IsActive, TST.InsertedDate, TST.UpdatedDate,
	TST.UpdatedByStaffId, TST.IsGRDefault
FROM
	Gdm.GLTranslationSubType TST
	INNER JOIN Gdm.GLTranslationSubTypeActive(@DataPriorToDate) TSTA ON
		TSTA.ImportKey = TST.ImportKey

-- #GLMajorCategory

INSERT INTO
	#GLMajorCategory (ImportKey, GLMajorCategoryId, GLTranslationSubTypeId, [Name], IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	MajC.ImportKey, MajC.GLMajorCategoryId, MajC.GLTranslationSubTypeId, MajC.[Name], MajC.IsActive, MajC.InsertedDate, MajC.UpdatedDate, MajC.UpdatedByStaffId
FROM
	Gdm.GLMajorCategory MajC
	INNER JOIN Gdm.GLMajorCategoryActive(@DataPriorToDate) MajCA ON
		MajC.ImportKey = MajCA.ImportKey

-- #GLMinorCategory

INSERT INTO
	#GLMinorCategory (ImportKey, GLMinorCategoryId, GLMajorCategoryId, [Name], IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	Minc.ImportKey, Minc.GLMinorCategoryId, Minc.GLMajorCategoryId, Minc.[Name], Minc.IsActive, Minc.InsertedDate, Minc.UpdatedDate, Minc.UpdatedByStaffId
FROM
	Gdm.GLMinorCategory MinC
	INNER JOIN Gdm.GLMinorCategoryActive(@DataPriorToDate) MinCA ON
		MinCA.ImportKey = MinC.ImportKey


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Map Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

--Map budget Amounts
CREATE TABLE #ProfitabilitySource
(
	BudgetId int NOT NULL,
	ReferenceCode varchar(300) NOT NULL,
	ExpensePeriod char(6) NOT NULL,	
	SourceCode varchar(2) NULL,
	BudgetAmount money NOT NULL,
	GlGlobalAccountCode varchar(21) NOT NULL,
	GLGlobalAccountId int NOT NULL,
	FunctionalDepartmentCode varchar(31) NULL,
	FunctionalDepartmentId int NULL,
	JobCode varchar(20) NULL,
	Reimbursable bit NULL,
	ActivityTypeCode varchar(10) NULL,
	ActivityTypeId int NOT NULL,
	PropertyFundId int NULL,
	AllocationSubRegionGlobalRegionId int NOT NULL,
	OriginatingRegionCode char(6) NULL,
	OriginatingGlobalRegionId int NULL,
	LocalCurrencyCode char(3) NOT NULL,
	LockedDate datetime NOT NULL,
	IsExpense bit NOT NULL
)
-- Insert original budget amounts
INSERT INTO #ProfitabilitySource
(
	BudgetId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	BudgetAmount,
	GlGlobalAccountCode,
	GLGlobalAccountId,
	FunctionalDepartmentCode,
	FunctionalDepartmentId,
	JobCode,
	Reimbursable,
	ActivityTypeCode,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingGlobalRegionId,
	LocalCurrencyCode,
	LockedDate,
	IsExpense
)

SELECT 
	b.BudgetId,
	''BC:'' + b.SourceUniqueKey + ''&ImportKey='' + CONVERT(varchar, b.ImportKey) as ReferenceCode,
	b.Period as ExpensePeriod,
	b.SourceCode,
	b.LocalAmount as BudgetAmount,
	CONVERT(varchar,b.GlobalGlAccountCode) as GlGlobalAccountCode,
	IsNull(gla.GLGlobalAccountId,-1) as GlGlobalAccountId,
	b.FunctionalDepartmentGlobalCode as FunctionalDepartmentCode,
	IsNull(fd.FunctionalDepartmentId,-1),
	b.JobCode,
	b.IsReimbursable as Reimbursable,
	at.ActivityTypeCode,
	IsNull(at.ActivityTypeId,-1),
	pfm.PropertyFundId,
	IsNull(DepartmentPropertyFund.AllocationSubRegionGlobalRegionId,-1) as AllocationSubRegionGlobalRegionId,
	b.OriginatingSubRegionCode as OriginatingRegionCode,
	IsNull(gr.GlobalRegionId,-1) as OriginatingGlobalRegionId,
	b.InternationalCurrencyCode as LocalCurrencyCode,
	b.LockedDate,
	b.IsExpense
FROM
	#Budget b 
	
	LEFT OUTER JOIN #GlAccount gla ON
		b.GlobalGlAccountCode = gla.Code
		
	LEFT OUTER JOIN #FunctionalDepartment fd ON
		b.FunctionalDepartmentGlobalCode = fd.GlobalCode
		
	LEFT OUTER JOIN #ActivityType at ON
		gla.ActivityTypeId = at.ActivityTypeId
		
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON GrSc.SourceCode = b.SourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		b.NonPayrollCorporateMRIDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		b.SourceCode = pfm.SourceCode AND 
		(
			(GrSc.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL) OR
			(
			 (GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId = at.ActivityTypeId) OR
			 (GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND at.ActivityTypeId IS NULL)
			)
		) AND
		pfm.IsDeleted = 0

	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		pfm.PropertyFundId = DepartmentPropertyFund.PropertyFundId

	LEFT OUTER JOIN #GlobalRegion gr ON
		b.OriginatingSubRegionCode = gr.Code

WHERE
	b.LocalAmount <> 0

PRINT ''Rows Inserted into #ProfitabilitySource:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


CREATE NONCLUSTERED INDEX IX_LocalAmount ON [#Budget] ([LocalAmount])
INCLUDE ([ImportKey],[SourceUniqueKey],[BudgetId],[SourceCode],[LockedDate],[Period],[InternationalCurrencyCode],[GlobalGlAccountCode],[FunctionalDepartmentGlobalCode],[OriginatingSubRegionCode],[NonPayrollCorporateMRIDepartmentCode],[AllocationSubRegionProjectRegionId],[IsReimbursable],[JobCode])

PRINT ''Created Index on GlAccountKey #ProfitabilitySource''
PRINT CONVERT(Varchar(27), getdate(), 121)


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Map mapped source data into the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

------------------------------------------------------------------------------------------------------
-- Additional required mappings
------------------------------------------------------------------------------------------------------
SELECT
	asr.*
INTO
	#AllocationSubRegion
FROM
	Gdm.AllocationSubRegion asr
	INNER JOIN Gdm.AllocationSubRegionActive(@DataPriorToDate) asrA ON
		asr.ImportKey = asrA.ImportKey
		
PRINT ''Rows Inserted into #AllocationSubRegion''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--If the join is not possible, default the link to the ''UNKNOWN'' link
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityBudget(
	CalendarKey int NOT NULL,
	GlAccountKey int NOT NULL,
	SourceKey int NOT NULL,
	FunctionalDepartmentKey int NOT NULL,
	ReimbursableKey int NOT NULL,
	ActivityTypeKey int NOT NULL,
	PropertyFundKey int NOT NULL,	
	AllocationRegionKey int NOT NULL,
	OriginatingRegionKey int NOT NULL,
	LocalCurrencyKey int NOT NULL,
	LocalBudget money NOT NULL,
	ReferenceCode Varchar(300) NOT NULL,
	BudgetId int NOT NULL,
	SourceSystemId int NOT NULL,

	EUCorporateGlAccountCategoryKey int NULL,
	EUPropertyGlAccountCategoryKey int NULL,
	EUFundGlAccountCategoryKey int NULL,

	USPropertyGlAccountCategoryKey int NULL,
	USCorporateGlAccountCategoryKey int NULL,
	USFundGlAccountCategoryKey int NULL,

	GlobalGlAccountCategoryKey int NULL,
	DevelopmentGlAccountCategoryKey int NULL
) 

INSERT INTO #ProfitabilityBudget 
(
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId
)
SELECT
		DATEDIFF(dd, ''1900-01-01'', LEFT(ps.ExpensePeriod,4)+''-''+RIGHT(ps.ExpensePeriod,2)+''-01'') as CalendarKey
		,CASE WHEN GrGl.[GlAccountKey] IS NULL THEN @GlAccountKey ELSE GrGl.[GlAccountKey] END GlAccountKey
		,CASE WHEN GrSc.[SourceKey] IS NULL THEN @SourceKey ELSE GrSc.[SourceKey] END SourceKey
		,CASE WHEN ISNULL(GrFdmD.[FunctionalDepartmentKey], GrFdmP.[FunctionalDepartmentKey]) IS NULL THEN @FunctionalDepartmentKey ELSE ISNULL(GrFdmD.[FunctionalDepartmentKey], GrFdmP.[FunctionalDepartmentKey]) END FunctionalDepartmentKey
		,CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKey ELSE GrRi.ReimbursableKey END ReimbursableKey
		,CASE WHEN GrAt.[ActivityTypeKey] IS NULL THEN @ActivityTypeKey ELSE GrAt.[ActivityTypeKey] END ActivityTypeKey
		,CASE WHEN GrPf.[PropertyFundKey] IS NULL THEN @PropertyFundKey ELSE GrPf.[PropertyFundKey] END PropertyFundKey
		,CASE WHEN GrAr.[AllocationRegionKey] IS NULL THEN @AllocationRegionKey ELSE GrAr.[AllocationRegionKey] END AllocationRegionKey
		,CASE WHEN IsNull(ps.IsExpense,-1) = 0 THEN 
			CASE WHEN GrOrFee.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKey ELSE GrOrFee.[OriginatingRegionKey] END 
		 ELSE 
			CASE WHEN GrOr.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKey ELSE GrOr.[OriginatingRegionKey] END 
		 END OriginatingRegionKey
		,CASE WHEN GrCu.[CurrencyKey] IS NULL THEN @LocalCurrencyKey ELSE GrCu.[CurrencyKey] END LocalCurrencyKey
		,ps.BudgetAmount
		,ps.ReferenceCode
		,ps.BudgetId
		,@SourceSystemId 
FROM
	#ProfitabilitySource ps
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccount GrGl ON
		ps.GlGlobalAccountId = GrGl.GlGlobalAccountId AND
		ps.LockedDate BETWEEN GrGl.StartDate AND GrGl.EndDate
	
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON
		ps.SourceCode = GrSc.SourceCode

	--Detail/Sub Level (job level)
	LEFT OUTER JOIN (
				Select 
					*
				From GrReporting.dbo.FunctionalDepartment
				Where SubFunctionalDepartmentCode <> FunctionalDepartmentCode
				) GrFdmD ON
		ps.LockedDate  BETWEEN GrFdmD.StartDate AND GrFdmD.EndDate AND
		--GrFdmD.ReferenceCode LIKE ''%:''+ ps.JobCode --new substitude below
		GrFdmD.SubFunctionalDepartmentCode = ps.JobCode
			
	--Parent Level
	LEFT OUTER JOIN (
			Select 
				* 
			From 
			GrReporting.dbo.FunctionalDepartment
			Where SubFunctionalDepartmentCode = FunctionalDepartmentCode
			) GrFdmP ON
		ps.LockedDate  BETWEEN GrFdmP.StartDate AND GrFdmP.EndDate AND
		--GrFdmP.ReferenceCode LIKE ps.FunctionalDepartmentCode +'':%'' --new substitude below
		GrFdmP.FunctionalDepartmentCode = ps.FunctionalDepartmentCode

	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		CASE WHEN ps.Reimbursable = 1 THEN ''YES'' ELSE ''NO'' END = GrRi.ReimbursableCode

	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		ps.ActivityTypeId = GrAt.ActivityTypeId AND
		ps.LockedDate BETWEEN GrAt.StartDate AND GrAt.EndDate

	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		ps.PropertyFundId = GrPf.PropertyFundId AND
		ps.LockedDate BETWEEN GrPf.StartDate AND GrPf.EndDate

	LEFT OUTER JOIN #AllocationSubRegion Asr ON
		Asr.AllocationSubRegionGlobalRegionId = ps.AllocationSubRegionGlobalRegionId AND 
		Asr.IsActive = 1

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		Asr.AllocationSubRegionGlobalRegionId = GrAr.GlobalRegionId AND
		ps.LockedDate BETWEEN GrAr.StartDate AND GrAr.EndDate

	-- This is only used for fees. It sets the originating region to the allocation region
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOrFee ON
		Asr.AllocationSubRegionGlobalRegionId = GrOrFee.GlobalRegionId AND
		ps.LockedDate BETWEEN GrOrFee.StartDate AND GrOrFee.EndDate

	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		ps.OriginatingGlobalRegionId = GrOr.GlobalRegionId AND
		ps.LockedDate BETWEEN GrOr.StartDate AND GrOr.EndDate

	LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
		ps.LocalCurrencyCode = GrCu.CurrencyCode 


PRINT ''Rows Inserted into #ProfitabilityBudget:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_GlAcocuntKey ON #ProfitabilityBudget (GlAccountKey)
PRINT ''Created Index on GlAccountKey #ProfitabilityBudget''
PRINT CONVERT(Varchar(27), getdate(), 121)

-------------------------------------------------------------------------------------------------------------------

-- EUCorporateGlAccountCategoryKey
UPDATE
	#ProfitabilityBudget
SET
	EUCorporateGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUCorporateGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END 
FROM
	#ProfitabilityBudget Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = ''EU CORP'' AND 
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND 
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))
		
			
PRINT ''Completed converting all EUCorporateGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--EUPropertyGlAccountCategoryKey
UPDATE
	#ProfitabilityBudget
SET
	EUPropertyGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUPropertyGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityBudget Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = ''EU PROP'' AND
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT ''Completed converting all EUPropertyGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)


--EUFundGlAccountCategoryKey
UPDATE
	#ProfitabilityBudget
SET
	EUFundGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUFundGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityBudget Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = ''EU FUND'' AND 
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND 
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))
	
PRINT ''Completed converting all EUFundGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USPropertyGlAccountCategoryKey
UPDATE
	#ProfitabilityBudget
SET
	USPropertyGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USPropertyGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityBudget Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = ''US PROP'' AND 
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND 
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT ''Completed converting all USPropertyGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USCorporateGlAccountCategoryKey
UPDATE
	#ProfitabilityBudget
SET
	USCorporateGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USCorporateGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
From #ProfitabilityBudget Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = ''US CORP'' AND 
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND 
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT ''Completed converting all USCorporateGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USFundGlAccountCategoryKey
UPDATE
	#ProfitabilityBudget
SET
	USFundGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USFundGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityBudget Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = ''US FUND'' AND 
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND 
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT ''Completed converting all USFundGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

		
--GlobalGlAccountCategoryKey
UPDATE
	#ProfitabilityBudget
SET
	GlobalGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM #ProfitabilityBudget Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = ''GL'' AND 
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND 
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT ''Completed converting all GlobalGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--DevelopmentGlAccountCategoryKey
UPDATE
	#ProfitabilityBudget
SET
	DevelopmentGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @DevelopmentGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM #ProfitabilityBudget Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = ''DEV'' AND 
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND 
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT ''Completed converting all DevelopmentGlAccountCategoryKey keys:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Remove existing data for modified budget projects
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #DeletingBudget
(
	BudgetId int NOT NULL
)

INSERT INTO #DeletingBudget
(
	BudgetId
)
SELECT DISTINCT 
	BudgetId
FROM
	#ProfitabilityBudget

PRINT ''Rows Inserted into #DeletingBudget:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Remove 
DECLARE @BudgetId int = -1
DECLARE @LoopCount int = 0 -- Infinite loop safe guard
WHILE (EXISTS (SELECT TOP 1 BudgetId FROM #DeletingBudget) AND @LoopCount < 100000)
BEGIN
	
	SET @LoopCount = @LoopCount + 1
	
	SET @BudgetId = (SELECT TOP 1 BudgetId FROM #DeletingBudget)

	-- Remove old facts
	DELETE 
	FROM GrReporting.dbo.ProfitabilityBudget 
	Where BudgetId = @BudgetId and SourceSystemId = @SourceSystemId
		
	PRINT ''Rows Deleted from ProfitabilityBudget:''+CONVERT(char(10),@@rowcount)
	PRINT CONVERT(Varchar(27), getdate(), 121)
	
	DELETE FROM #DeletingBudget WHERE BudgetId = @BudgetId
	
	PRINT ''Rows Deleted from #DeletingBudget:''+CONVERT(char(10),@@rowcount)
	PRINT CONVERT(Varchar(27), getdate(), 121)
	
END

print ''Cleaned up rows in ProfitabilityBudget''


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Insert modified and new fact data 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

INSERT INTO GrReporting.dbo.ProfitabilityBudget
(
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
)
SELECT
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
FROM 
	#ProfitabilityBudget


PRINT ''Rows Inserted into ProfitabilityBudget:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)



	
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Clean up
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Source data
DROP TABLE #Budget
DROP TABLE #GlAccount
DROP TABLE #FunctionalDepartment
DROP TABLE #ActivityType
DROP TABLE #GlobalRegion
DROP TABLE #PropertyFundMapping
DROP TABLE #PropertyFund
DROP TABLE #AllocationSubRegion
-- Mapping mapping
DROP TABLE #ProfitabilitySource
DROP TABLE #DeletingBudget
DROP TABLE #ProfitabilityBudget
-- Account Category Mapping
DROP TABLE #GLTranslationType
DROP TABLE #GLTranslationSubType
DROP TABLE #GLGlobalAccountTranslationType
DROP TABLE #GLGlobalAccountTranslationSubType
DROP TABLE #GLMajorCategory
DROP TABLE #GLMinorCategory


' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[ProfitabilityActualGlAccountCategoryBridgeVirtual]    Script Date: 08/05/2010 15:11:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualGlAccountCategoryBridgeVirtual]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/********************************************************************/
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
	Where GlobalGlAccountCategoryCode like ''%-1%'' 
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
' 
END
GO
/****** Object:  View [dbo].[ProfitabilityFact]    Script Date: 08/05/2010 15:11:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityFact]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [dbo].[ProfitabilityFact]
AS
Select
		CalendarKey
      ,GlAccountKey
      ,SourceKey
      ,FunctionalDepartmentKey
      ,ReimbursableKey
      ,ActivityTypeKey
      ,PropertyFundKey
      ,AllocationRegionKey
      ,OriginatingRegionKey
      ,USCorporateGlAccountCategoryKey
      ,USPropertyGlAccountCategoryKey
      ,USFundGlAccountCategoryKey
      ,EUCorporateGlAccountCategoryKey
      ,EUPropertyGlAccountCategoryKey
      ,EUFundGlAccountCategoryKey
      ,GlobalGlAccountCategoryKey
      ,DevelopmentGlAccountCategoryKey
      
      ,SUM(ActualLocal) ActualLocal
      ,SUM(ActualUSD) ActualUSD
      ,SUM(ActualBRL) ActualBRL
      ,SUM(ActualCNY) ActualCNY
      ,SUM(ActualINR) ActualINR
      ,SUM(ActualAUD) ActualAUD
      ,SUM(ActualCHF) ActualCHF
      ,SUM(ActualEUR) ActualEUR
      ,SUM(ActualGBP) ActualGBP
      ,SUM(ActualHUF) ActualHUF
      ,SUM(ActualKRW) ActualKRW
      ,SUM(ActualOMR) ActualOMR
      ,SUM(ActualPLN) ActualPLN
      ,SUM(ActualTLR) ActualTLR
      ,SUM(ActualDEF) ActualDEF
      ,SUM(ActualZAR) ActualZAR
      
      ,SUM(NetActualLocal) NetActualLocal
      ,SUM(NetActualUSD) NetActualUSD
      ,SUM(NetActualBRL) NetActualBRL
      ,SUM(NetActualCNY) NetActualCNY
      ,SUM(NetActualINR) NetActualINR
      ,SUM(NetActualAUD) NetActualAUD
      ,SUM(NetActualCHF) NetActualCHF
      ,SUM(NetActualEUR) NetActualEUR
      ,SUM(NetActualGBP) NetActualGBP
      ,SUM(NetActualHUF) NetActualHUF
      ,SUM(NetActualKRW) NetActualKRW
      ,SUM(NetActualOMR) NetActualOMR
      ,SUM(NetActualPLN) NetActualPLN
      ,SUM(NetActualTLR) NetActualTLR
      ,SUM(NetActualDEF) NetActualDEF
      ,SUM(NetActualZAR) NetActualZAR

      ,SUM(BudgetLocal) BudgetLocal
      ,SUM(BudgetUSD) BudgetUSD
      ,SUM(BudgetBRL) BudgetBRL
      ,SUM(BudgetCNY) BudgetCNY
      ,SUM(BudgetINR) BudgetINR
      ,SUM(BudgetAUD) BudgetAUD
      ,SUM(BudgetCHF) BudgetCHF
      ,SUM(BudgetEUR) BudgetEUR
      ,SUM(BudgetGBP) BudgetGBP
      ,SUM(BudgetHUF) BudgetHUF
      ,SUM(BudgetKRW) BudgetKRW
      ,SUM(BudgetOMR) BudgetOMR
      ,SUM(BudgetPLN) BudgetPLN
      ,SUM(BudgetTLR) BudgetTLR
      ,SUM(BudgetDEF) BudgetDEF
      ,SUM(BudgetZAR) BudgetZAR
      
      ,SUM(NetBudgetLocal) NetBudgetLocal
      ,SUM(NetBudgetUSD) NetBudgetUSD
      ,SUM(NetBudgetBRL) NetBudgetBRL
      ,SUM(NetBudgetCNY) NetBudgetCNY
      ,SUM(NetBudgetINR) NetBudgetINR
      ,SUM(NetBudgetAUD) NetBudgetAUD
      ,SUM(NetBudgetCHF) NetBudgetCHF
      ,SUM(NetBudgetEUR) NetBudgetEUR
      ,SUM(NetBudgetGBP) NetBudgetGBP
      ,SUM(NetBudgetHUF) NetBudgetHUF
      ,SUM(NetBudgetKRW) NetBudgetKRW
      ,SUM(NetBudgetOMR) NetBudgetOMR
      ,SUM(NetBudgetPLN) NetBudgetPLN
      ,SUM(NetBudgetTLR) NetBudgetTLR
      ,SUM(NetBudgetDEF) NetBudgetDEF
      ,SUM(NetBudgetZAR) NetBudgetZAR
From
	(
	SELECT 
		  pa.CalendarKey
		  ,pa.GlAccountKey
		  ,pa.SourceKey
		  ,pa.FunctionalDepartmentKey
		  ,pa.ReimbursableKey
		  ,pa.ActivityTypeKey
		  ,pa.PropertyFundKey
		  ,pa.AllocationRegionKey
		  ,pa.OriginatingRegionKey
		  ,pa.USCorporateGlAccountCategoryKey
		  ,pa.USPropertyGlAccountCategoryKey
		  ,pa.USFundGlAccountCategoryKey
		  ,pa.EUCorporateGlAccountCategoryKey
		  ,pa.EUPropertyGlAccountCategoryKey
		  ,pa.EUFundGlAccountCategoryKey
		  ,pa.GlobalGlAccountCategoryKey
		  ,pa.DevelopmentGlAccountCategoryKey
	      
		  ,SUM(pa.LocalActual) ActualLocal
		  ,SUM(pa.LocalActual * ExchangeRateUSD.Rate) ActualUSD
		  ,SUM(pa.LocalActual * ExchangeRateBRL.Rate) ActualBRL
		  ,SUM(pa.LocalActual * ExchangeRateCNY.Rate) ActualCNY
		  ,SUM(pa.LocalActual * ExchangeRateINR.Rate) ActualINR
		  ,SUM(pa.LocalActual * ExchangeRateAUD.Rate) ActualAUD
		  ,SUM(pa.LocalActual * ExchangeRateCHF.Rate) ActualCHF
		  ,SUM(pa.LocalActual * ExchangeRateEUR.Rate) ActualEUR
		  ,SUM(pa.LocalActual * ExchangeRateGBP.Rate) ActualGBP
		  ,SUM(pa.LocalActual * ExchangeRateHUF.Rate) ActualHUF
		  ,SUM(pa.LocalActual * ExchangeRateKRW.Rate) ActualKRW
		  ,SUM(pa.LocalActual * ExchangeRateOMR.Rate) ActualOMR
		  ,SUM(pa.LocalActual * ExchangeRatePLN.Rate) ActualPLN
		  ,SUM(pa.LocalActual * ExchangeRateTLR.Rate) ActualTLR
		  ,SUM(pa.LocalActual * ExchangeRateDEF.Rate) ActualDEF
		  ,SUM(pa.LocalActual * ExchangeRateZAR.Rate) ActualZAR
		  
		  ,SUM(pa.LocalActual * r.MultiplicationFactor) NetActualLocal
		  ,SUM(pa.LocalActual * ExchangeRateUSD.Rate * r.MultiplicationFactor) NetActualUSD
		  ,SUM(pa.LocalActual * ExchangeRateBRL.Rate * r.MultiplicationFactor) NetActualBRL
		  ,SUM(pa.LocalActual * ExchangeRateCNY.Rate * r.MultiplicationFactor) NetActualCNY
		  ,SUM(pa.LocalActual * ExchangeRateINR.Rate * r.MultiplicationFactor) NetActualINR
		  ,SUM(pa.LocalActual * ExchangeRateAUD.Rate * r.MultiplicationFactor) NetActualAUD
		  ,SUM(pa.LocalActual * ExchangeRateCHF.Rate * r.MultiplicationFactor) NetActualCHF
		  ,SUM(pa.LocalActual * ExchangeRateEUR.Rate * r.MultiplicationFactor) NetActualEUR
		  ,SUM(pa.LocalActual * ExchangeRateGBP.Rate * r.MultiplicationFactor) NetActualGBP
		  ,SUM(pa.LocalActual * ExchangeRateHUF.Rate * r.MultiplicationFactor) NetActualHUF
		  ,SUM(pa.LocalActual * ExchangeRateKRW.Rate * r.MultiplicationFactor) NetActualKRW
		  ,SUM(pa.LocalActual * ExchangeRateOMR.Rate * r.MultiplicationFactor) NetActualOMR
		  ,SUM(pa.LocalActual * ExchangeRatePLN.Rate * r.MultiplicationFactor) NetActualPLN
		  ,SUM(pa.LocalActual * ExchangeRateTLR.Rate * r.MultiplicationFactor) NetActualTLR
		  ,SUM(pa.LocalActual * ExchangeRateDEF.Rate * r.MultiplicationFactor) NetActualDEF
		  ,SUM(pa.LocalActual * ExchangeRateZAR.Rate * r.MultiplicationFactor) NetActualZAR

		  ,0.00 BudgetLocal
		  ,0.00 BudgetUSD
		  ,0.00 BudgetBRL
		  ,0.00 BudgetCNY
		  ,0.00 BudgetINR
		  ,0.00 BudgetAUD
		  ,0.00 BudgetCHF
		  ,0.00 BudgetEUR
		  ,0.00 BudgetGBP
		  ,0.00 BudgetHUF
		  ,0.00 BudgetKRW
		  ,0.00 BudgetOMR
		  ,0.00 BudgetPLN
		  ,0.00 BudgetTLR
		  ,0.00 BudgetDEF
		  ,0.00 BudgetZAR
	      
	      ,0.00 NetBudgetLocal
		  ,0.00 NetBudgetUSD
		  ,0.00 NetBudgetBRL
		  ,0.00 NetBudgetCNY
		  ,0.00 NetBudgetINR
		  ,0.00 NetBudgetAUD
		  ,0.00 NetBudgetCHF
		  ,0.00 NetBudgetEUR
		  ,0.00 NetBudgetGBP
		  ,0.00 NetBudgetHUF
		  ,0.00 NetBudgetKRW
		  ,0.00 NetBudgetOMR
		  ,0.00 NetBudgetPLN
		  ,0.00 NetBudgetTLR
		  ,0.00 NetBudgetDEF
		  ,0.00 NetBudgetZAR
		  
	FROM  dbo.ProfitabilityActual pa
	  
			LEFT OUTER JOIN Reimbursable r ON r.ReimbursableKey = pa.ReimbursableKey
	
			LEFT OUTER JOIN ExchangeRate ExchangeRateUSD ON  ExchangeRateUSD.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateUSD.CalendarKey = pa.CalendarKey AND ExchangeRateUSD.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''USD'')

			LEFT OUTER JOIN ExchangeRate ExchangeRateBRL ON  ExchangeRateBRL.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateBRL.CalendarKey = pa.CalendarKey AND ExchangeRateBRL.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''BRL'')

			LEFT OUTER JOIN ExchangeRate ExchangeRateCNY ON  ExchangeRateCNY.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateCNY.CalendarKey = pa.CalendarKey AND ExchangeRateCNY.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''CNY'')

			LEFT OUTER JOIN ExchangeRate ExchangeRateINR ON  ExchangeRateINR.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateINR.CalendarKey = pa.CalendarKey AND ExchangeRateINR.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''INR'')

			LEFT OUTER JOIN ExchangeRate ExchangeRateAUD ON  ExchangeRateAUD.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateAUD.CalendarKey = pa.CalendarKey AND ExchangeRateAUD.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''AUD'')

			LEFT OUTER JOIN ExchangeRate ExchangeRateCAD ON  ExchangeRateCAD.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateCAD.CalendarKey = pa.CalendarKey AND ExchangeRateCAD.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''CAD'')

			LEFT OUTER JOIN ExchangeRate ExchangeRateCHF ON  ExchangeRateCHF.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateCHF.CalendarKey = pa.CalendarKey AND ExchangeRateCHF.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''CHF'')

			LEFT OUTER JOIN ExchangeRate ExchangeRateEUR ON  ExchangeRateEUR.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateEUR.CalendarKey = pa.CalendarKey AND ExchangeRateEUR.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''EUR'')

			LEFT OUTER JOIN ExchangeRate ExchangeRateGBP ON  ExchangeRateGBP.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateGBP.CalendarKey = pa.CalendarKey AND ExchangeRateGBP.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''GBP'')

			LEFT OUTER JOIN ExchangeRate ExchangeRateHUF ON  ExchangeRateHUF.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateHUF.CalendarKey = pa.CalendarKey AND ExchangeRateHUF.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''HUF'')

			LEFT OUTER JOIN ExchangeRate ExchangeRateKRW ON  ExchangeRateKRW.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateKRW.CalendarKey = pa.CalendarKey AND ExchangeRateKRW.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''KRW'')

			LEFT OUTER JOIN ExchangeRate ExchangeRateOMR ON  ExchangeRateOMR.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateOMR.CalendarKey = pa.CalendarKey AND ExchangeRateOMR.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''OMR'')

			LEFT OUTER JOIN ExchangeRate ExchangeRatePLN ON  ExchangeRatePLN.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRatePLN.CalendarKey = pa.CalendarKey AND ExchangeRatePLN.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''PLN'')

			LEFT OUTER JOIN ExchangeRate ExchangeRateTLR ON  ExchangeRateTLR.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateTLR.CalendarKey = pa.CalendarKey AND ExchangeRateTLR.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''TLR'')

			LEFT OUTER JOIN ExchangeRate ExchangeRateDEF ON  ExchangeRateDEF.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateDEF.CalendarKey = pa.CalendarKey AND ExchangeRateDEF.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''DEF'')

			LEFT OUTER JOIN ExchangeRate ExchangeRateZAR ON  ExchangeRateZAR.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateZAR.CalendarKey = pa.CalendarKey AND ExchangeRateZAR.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''ZAR'')
			
Group By
		pa.CalendarKey
	  ,pa.GlAccountKey
	  ,pa.SourceKey
	  ,pa.FunctionalDepartmentKey
	  ,pa.ReimbursableKey
	  ,pa.ActivityTypeKey
	  ,pa.PropertyFundKey
	  ,pa.AllocationRegionKey
	  ,pa.OriginatingRegionKey
	  ,pa.USCorporateGlAccountCategoryKey
	  ,pa.USPropertyGlAccountCategoryKey
	  ,pa.USFundGlAccountCategoryKey
	  ,pa.EUCorporateGlAccountCategoryKey
	  ,pa.EUPropertyGlAccountCategoryKey
	  ,pa.EUFundGlAccountCategoryKey
	  ,pa.GlobalGlAccountCategoryKey
	  ,pa.DevelopmentGlAccountCategoryKey

	UNION ALL

	SELECT 
			pb.CalendarKey
		  ,pb.GlAccountKey
		  ,pb.SourceKey
		  ,pb.FunctionalDepartmentKey
		  ,pb.ReimbursableKey
		  ,pb.ActivityTypeKey
		  ,pb.PropertyFundKey
		  ,pb.AllocationRegionKey
		  ,pb.OriginatingRegionKey
		  ,pb.USCorporateGlAccountCategoryKey
		  ,pb.USPropertyGlAccountCategoryKey
		  ,pb.USFundGlAccountCategoryKey
		  ,pb.EUCorporateGlAccountCategoryKey
		  ,pb.EUPropertyGlAccountCategoryKey
		  ,pb.EUFundGlAccountCategoryKey
		  ,pb.GlobalGlAccountCategoryKey
		  ,pb.DevelopmentGlAccountCategoryKey
	      
		  ,NULL ActualLocal
		  ,NULL ActualUSD
		  ,NULL ActualBRL
		  ,NULL ActualCNY
		  ,NULL ActualINR
		  ,NULL ActualAUD
		  ,NULL ActualCHF
		  ,NULL ActualEUR
		  ,NULL ActualGBP
		  ,NULL ActualHUF
		  ,NULL ActualKRW
		  ,NULL ActualOMR
		  ,NULL ActualPLN
		  ,NULL ActualTLR
		  ,NULL ActualDEF
		  ,NULL ActualZAR
	      
	      ,NULL NetActualLocal
		  ,NULL NetActualUSD
		  ,NULL NetActualBRL
		  ,NULL NetActualCNY
		  ,NULL NetActualINR
		  ,NULL NetActualAUD
		  ,NULL NetActualCHF
		  ,NULL NetActualEUR
		  ,NULL NetActualGBP
		  ,NULL NetActualHUF
		  ,NULL NetActualKRW
		  ,NULL NetActualOMR
		  ,NULL NetActualPLN
		  ,NULL NetActualTLR
		  ,NULL NetActualDEF
		  ,NULL NetActualZAR
		  
		  ,SUM(pb.LocalBudget) BudgetLocal
		  ,SUM(pb.LocalBudget * ExchangeRateUSD.Rate) BudgetUSD
		  ,SUM(pb.LocalBudget * ExchangeRateBRL.Rate) BudgetBRL
		  ,SUM(pb.LocalBudget * ExchangeRateCNY.Rate) BudgetCNY
		  ,SUM(pb.LocalBudget * ExchangeRateINR.Rate) BudgetINR
		  ,SUM(pb.LocalBudget * ExchangeRateAUD.Rate) BudgetAUD
		  ,SUM(pb.LocalBudget * ExchangeRateCHF.Rate) BudgetCHF
		  ,SUM(pb.LocalBudget * ExchangeRateEUR.Rate) BudgetEUR
		  ,SUM(pb.LocalBudget * ExchangeRateGBP.Rate) BudgetGBP
		  ,SUM(pb.LocalBudget * ExchangeRateHUF.Rate) BudgetHUF
		  ,SUM(pb.LocalBudget * ExchangeRateKRW.Rate) BudgetKRW
		  ,SUM(pb.LocalBudget * ExchangeRateOMR.Rate) BudgetOMR
		  ,SUM(pb.LocalBudget * ExchangeRatePLN.Rate) BudgetPLN
		  ,SUM(pb.LocalBudget * ExchangeRateTLR.Rate) BudgetTLR
		  ,SUM(pb.LocalBudget * ExchangeRateDEF.Rate) BudgetDEF
		  ,SUM(pb.LocalBudget * ExchangeRateZAR.Rate) BudgetZAR
		  
		  ,SUM(pb.LocalBudget * r.MultiplicationFactor) NetBudgetLocal
		  ,SUM(pb.LocalBudget * ExchangeRateUSD.Rate * r.MultiplicationFactor) NetBudgetUSD
		  ,SUM(pb.LocalBudget * ExchangeRateBRL.Rate * r.MultiplicationFactor) NetBudgetBRL
		  ,SUM(pb.LocalBudget * ExchangeRateCNY.Rate * r.MultiplicationFactor) NetBudgetCNY
		  ,SUM(pb.LocalBudget * ExchangeRateINR.Rate * r.MultiplicationFactor) NetBudgetINR
		  ,SUM(pb.LocalBudget * ExchangeRateAUD.Rate * r.MultiplicationFactor) NetBudgetAUD
		  ,SUM(pb.LocalBudget * ExchangeRateCHF.Rate * r.MultiplicationFactor) NetBudgetCHF
		  ,SUM(pb.LocalBudget * ExchangeRateEUR.Rate * r.MultiplicationFactor) NetBudgetEUR
		  ,SUM(pb.LocalBudget * ExchangeRateGBP.Rate * r.MultiplicationFactor) NetBudgetGBP
		  ,SUM(pb.LocalBudget * ExchangeRateHUF.Rate * r.MultiplicationFactor) NetBudgetHUF
		  ,SUM(pb.LocalBudget * ExchangeRateKRW.Rate * r.MultiplicationFactor) NetBudgetKRW
		  ,SUM(pb.LocalBudget * ExchangeRateOMR.Rate * r.MultiplicationFactor) NetBudgetOMR
		  ,SUM(pb.LocalBudget * ExchangeRatePLN.Rate * r.MultiplicationFactor) NetBudgetPLN
		  ,SUM(pb.LocalBudget * ExchangeRateTLR.Rate * r.MultiplicationFactor) NetBudgetTLR
		  ,SUM(pb.LocalBudget * ExchangeRateDEF.Rate * r.MultiplicationFactor) NetBudgetDEF
		  ,SUM(pb.LocalBudget * ExchangeRateZAR.Rate * r.MultiplicationFactor) NetBudgetZAR
	      
	  FROM dbo.ProfitabilityBudget pb
	  
			LEFT OUTER JOIN Reimbursable r ON r.ReimbursableKey = pb.ReimbursableKey
	  
			LEFT OUTER JOIN ExchangeRate ExchangeRateUSD ON  ExchangeRateUSD.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateUSD.CalendarKey = pb.CalendarKey AND ExchangeRateUSD.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''USD'')

			LEFT OUTER JOIN ExchangeRate ExchangeRateBRL ON  ExchangeRateBRL.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateBRL.CalendarKey = pb.CalendarKey AND ExchangeRateBRL.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''BRL'')

			LEFT OUTER JOIN ExchangeRate ExchangeRateCNY ON  ExchangeRateCNY.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateCNY.CalendarKey = pb.CalendarKey AND ExchangeRateCNY.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''CNY'')

			LEFT OUTER JOIN ExchangeRate ExchangeRateINR ON  ExchangeRateINR.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateINR.CalendarKey = pb.CalendarKey AND ExchangeRateINR.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''INR'')

			LEFT OUTER JOIN ExchangeRate ExchangeRateAUD ON  ExchangeRateAUD.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateAUD.CalendarKey = pb.CalendarKey AND ExchangeRateAUD.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''AUD'')

			LEFT OUTER JOIN ExchangeRate ExchangeRateCAD ON  ExchangeRateCAD.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateCAD.CalendarKey = pb.CalendarKey AND ExchangeRateCAD.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''CAD'')

			LEFT OUTER JOIN ExchangeRate ExchangeRateCHF ON  ExchangeRateCHF.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateCHF.CalendarKey = pb.CalendarKey AND ExchangeRateCHF.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''CHF'')

			LEFT OUTER JOIN ExchangeRate ExchangeRateEUR ON  ExchangeRateEUR.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateEUR.CalendarKey = pb.CalendarKey AND ExchangeRateEUR.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''EUR'')

			LEFT OUTER JOIN ExchangeRate ExchangeRateGBP ON  ExchangeRateGBP.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateGBP.CalendarKey = pb.CalendarKey AND ExchangeRateGBP.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''GBP'')

			LEFT OUTER JOIN ExchangeRate ExchangeRateHUF ON  ExchangeRateHUF.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateHUF.CalendarKey = pb.CalendarKey AND ExchangeRateHUF.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''HUF'')

			LEFT OUTER JOIN ExchangeRate ExchangeRateKRW ON  ExchangeRateKRW.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateKRW.CalendarKey = pb.CalendarKey AND ExchangeRateKRW.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''KRW'')

			LEFT OUTER JOIN ExchangeRate ExchangeRateOMR ON  ExchangeRateOMR.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateOMR.CalendarKey = pb.CalendarKey AND ExchangeRateOMR.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''OMR'')

			LEFT OUTER JOIN ExchangeRate ExchangeRatePLN ON  ExchangeRatePLN.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRatePLN.CalendarKey = pb.CalendarKey AND ExchangeRatePLN.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''PLN'')

			LEFT OUTER JOIN ExchangeRate ExchangeRateTLR ON  ExchangeRateTLR.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateTLR.CalendarKey = pb.CalendarKey AND ExchangeRateTLR.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''TLR'')

			LEFT OUTER JOIN ExchangeRate ExchangeRateDEF ON  ExchangeRateDEF.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateDEF.CalendarKey = pb.CalendarKey AND ExchangeRateDEF.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''DEF'')

			LEFT OUTER JOIN ExchangeRate ExchangeRateZAR ON  ExchangeRateZAR.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateZAR.CalendarKey = pb.CalendarKey AND ExchangeRateZAR.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = ''ZAR'')

		Group By
			  pb.CalendarKey
			  ,pb.GlAccountKey
			  ,pb.SourceKey
			  ,pb.FunctionalDepartmentKey
			  ,pb.ReimbursableKey
			  ,pb.ActivityTypeKey
			  ,pb.PropertyFundKey
			  ,pb.AllocationRegionKey
			  ,pb.OriginatingRegionKey
			  ,pb.USCorporateGlAccountCategoryKey
			  ,pb.USPropertyGlAccountCategoryKey
			  ,pb.USFundGlAccountCategoryKey
			  ,pb.EUCorporateGlAccountCategoryKey
			  ,pb.EUPropertyGlAccountCategoryKey
			  ,pb.EUFundGlAccountCategoryKey
			  ,pb.GlobalGlAccountCategoryKey
			  ,pb.DevelopmentGlAccountCategoryKey

	) Summary

	Group By
		CalendarKey
      ,GlAccountKey
      ,SourceKey
      ,FunctionalDepartmentKey
      ,ReimbursableKey
      ,ActivityTypeKey
      ,PropertyFundKey
      ,AllocationRegionKey
      ,OriginatingRegionKey
      ,USCorporateGlAccountCategoryKey
      ,USPropertyGlAccountCategoryKey
      ,USFundGlAccountCategoryKey
      ,EUCorporateGlAccountCategoryKey
      ,EUPropertyGlAccountCategoryKey
      ,EUFundGlAccountCategoryKey
      ,GlobalGlAccountCategoryKey
      ,DevelopmentGlAccountCategoryKey


'
GO
/****** Object:  UserDefinedFunction [dbo].[ProfitabilityBudgetGlAccountCategoryBridgeVirtual]    Script Date: 08/05/2010 15:11:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudgetGlAccountCategoryBridgeVirtual]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/********************************************************************/
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
	Where GlobalGlAccountCategoryCode like ''%-1%'' 
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
' 
END
GO
