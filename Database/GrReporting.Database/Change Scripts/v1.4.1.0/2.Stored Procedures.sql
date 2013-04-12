
/*

All stp_R_* stored procedures must be deployed : GC





*/

USE [GrReporting]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginatorJobCodeDetail]    Script Date: 09/06/2010 12:57:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOriginatorJobCodeDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_BudgetOriginatorJobCodeDetail]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginatorOwnerEntity]    Script Date: 09/06/2010 12:57:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOriginatorOwnerEntity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_BudgetOriginatorOwnerEntity]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginatorOwnerFunctionalDepartment]    Script Date: 09/06/2010 12:57:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOriginatorOwnerFunctionalDepartment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_BudgetOriginatorOwnerFunctionalDepartment]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzar]    Script Date: 09/06/2010 12:57:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzar]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ExpenseCzar]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzarTotalComparison]    Script Date: 09/06/2010 12:57:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzarTotalComparison]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ExpenseCzarTotalComparison]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzarTotalComparisonDetail]    Script Date: 09/06/2010 12:57:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzarTotalComparisonDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ExpenseCzarTotalComparisonDetail]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_Profitability]    Script Date: 09/06/2010 12:57:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_Profitability]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_Profitability]
GO
-----------------------------------------------------------------------------------------------------------


USE [GrReporting]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_Profitability]    Script Date: 09/06/2010 12:58:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[stp_R_Profitability]
	@ReportExpensePeriod INT = NULL,
	@ReforecastQuaterName VARCHAR(10) = NULL, --'Q1' or 'Q2' or 'Q3'
	@PreviousReforecastQuaterName VARCHAR(10) = 'Q1', --or 'Q2' or 'Q3'
	@DestinationCurrency VARCHAR(3) = NULL,
	@TranslationTypeName VARCHAR(50) = 'Global',
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
SET @DestinationCurrency = 'USD'
SET @TranslationTypeName = 'Global'
SET @ActivityType = NULL
SET @Entity = NULL
SET @AllocationSubRegion = NULL

EXEC stp_R_Profitability
	@ReportExpensePeriod = 201011,
	@TranslationTypeName = 'Global',
	@DestinationCurrency = 'USD',

	@FunctionalDepartmentList = 'Information Technologies',
	@AllocationRegionList = 'CHICAGO',
	@EntityList = 'Aldgate|Centrium (St Cathrine House/Pegasus)'
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
	SET @ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + REPLACE(STR(MONTH(GETDATE()),2 ),' ','0')AS INT)

IF @DestinationCurrency IS NULL
	SET @DestinationCurrency = 'USD'

IF 	@TranslationTypeName IS NULL
	SET @TranslationTypeName = 'Global'

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

IF 	OBJECT_ID('tempdb..#ProfitabilityReport') IS NOT NULL
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
	PropertyFundCode			Varchar(6) DEFAULT(''), --Varchar, for this helps to keep reports size smaller
	OriginatingRegionCode		Varchar(15) DEFAULT(''), --Varchar, for this helps to keep reports size smaller

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
SET @cmdString = (Select '

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
    CONVERT(varchar(10),ISNULL(pa.EntryDate,''''), 101) as EntryDate,
    ISNULL(pa.[User], '''') [User],
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.Description ELSE '''' END as Description,
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.AdditionalDescription ELSE '''' END as AdditionalDescription,
    ISNULL(pa.PropertyFundCode, '''') PropertyFundCode,
    ISNULL(pa.OriginatingRegionCode, '''') OriginatingRegionCode,
    
    -- Expenses must be displayed as negative an Income is saved in MRI as negative
	(
		er.Rate * -1 *
		CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdGrossActual,
	NULL as MtdGrossBudget,
	(
		er.Rate * -1 *
		CASE WHEN c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdGrossReforecast,
	
	(
		er.Rate * r.MultiplicationFactor * -1 *
		CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdNetActual,
	NULL as MtdNetBudget,
	(
		er.Rate * r.MultiplicationFactor * -1 *
		CASE WHEN c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdNetReforecast,
	
	(
		er.Rate * -1 *
		CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdGrossActual,
	NULL as YtdGrossBudget,
	(
		er.Rate * -1 *
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as YtdGrossReforecast,
	
	(
		er.Rate * r.MultiplicationFactor * -1 *
		CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdNetActual,
	NULL as YtdNetBudget,
	(
		er.Rate * r.MultiplicationFactor * -1 *
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
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
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualGrossReforecast,
	(
		er.Rate * -1 *
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@PreviousReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
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
        CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecast,
    (
        er.Rate * r.MultiplicationFactor * -1 *
        CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@PreviousReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ1,
	
	(
        er.Rate * -1 *
        CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pa.LocalActual
        ELSE 
			0
        END
	) as AnnualEstGrossBudget,
	(
            er.Rate * -1 *
            CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecast,

    (
        er.Rate * r.MultiplicationFactor * -1 *
        CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
	(
        er.Rate * r.MultiplicationFactor * -1 *
        CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstNetReforecast
FROM
	ProfitabilityActual pa

	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = ' + CASE 
			WHEN @TranslationTypeName = 'EU Corporate' THEN 'pa.EUCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Property' THEN 'pa.USPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Fund' THEN 'pa.USFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Property' THEN 'pa.EUPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Corporate' THEN 'pa.USCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Development' THEN 'pa.DevelopmentGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Fund' THEN 'pa.EUFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Global' THEN 'pa.GlobalGlAccountCategoryKey' 
			ELSE 'break:not valid hierarchyname' END + '
		
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
    AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select t1.FunctionalDepartmentKey From #FunctionalDepartmentFilterTable t1)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select t1.ActivityTypeKey From #ActivityTypeFilterTable t1)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select t1.PropertyFundKey From #EntityFilterTable t1)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationRegionFilterTable t1)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationSubRegionFilterTable t1)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MajorAccountCategoryFilterTable t1)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MinorAccountCategoryFilterTable t1)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingRegionFilterTable t1)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingSubRegionFilterTable t1)' END +
'
')
print @cmdString
EXEC (@cmdString)

--Get budget information
SET @cmdString = (Select '

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
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' as OriginatingRegionCode,
    
    --Expenses must be displayed as negative
    NULL as MtdGrossActual,
	(
		er.Rate * (CASE WHEN gac.FeeOrExpense = ''INCOME'' THEN
					1
				   ELSE
					-1 
				   END) *
		CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as MtdGrossBudget,
	NULL as MtdGrossReforecast,
	
	NULL as MtdNetActual,
	(
        er.Rate * r.MultiplicationFactor * (CASE WHEN gac.FeeOrExpense = ''INCOME'' THEN
											 1
										    ELSE
											 -1 
										    END) * 
        CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as MtdNetBudget,
	NULL as MtdNetReforecast,
	
	NULL as YtdGrossActual,	
	(
		er.Rate * (CASE WHEN gac.FeeOrExpense = ''INCOME'' THEN
					1
				   ELSE
					-1 
				   END) * 
		CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as YtdGrossBudget, 
	NULL as YtdGrossReforecast, 
	
	NULL as YtdNetActual, 
	(
        er.Rate * r.MultiplicationFactor * (CASE WHEN gac.FeeOrExpense = ''INCOME'' THEN
											 1
										    ELSE
											 -1 
										    END) * 
        CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as YtdNetBudget, 
	NULL as YtdNetReforecast, 
	
	(er.Rate * pb.LocalBudget * (CASE WHEN gac.FeeOrExpense = ''INCOME'' THEN
									1
								  ELSE
									-1 
								  END)) as AnnualGrossBudget,
	NULL as AnnualGrossReforecast,
	NULL as AnnualGrossReforecastQ1,

	(er.Rate * r.MultiplicationFactor * pb.LocalBudget * (CASE WHEN gac.FeeOrExpense = ''INCOME'' THEN
																1
															 ELSE
																-1 
															 END)) as AnnualNetBudget,
	NULL as AnnualNetReforecast,
	NULL as AnnualNetReforecastQ1,


	(
		er.Rate * (CASE WHEN gac.FeeOrExpense = ''INCOME'' THEN
					1
				   ELSE
					-1 
				   END) * 
		CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as AnnualEstGrossBudget,
	NULL as AnnualEstGrossReforecast,

	(
        er.Rate * r.MultiplicationFactor * (CASE WHEN gac.FeeOrExpense = ''INCOME'' THEN
											 1
										    ELSE
											 -1 
										    END) * 
        CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
	NULL as AnnualEstNetReforecast
	
FROM
	ProfitabilityBudget pb
	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = ' + CASE 
			WHEN @TranslationTypeName = 'EU Corporate' THEN 'pb.EUCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Property' THEN 'pb.USPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Fund' THEN 'pb.USFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Property' THEN 'pb.EUPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Corporate' THEN 'pb.USCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Development' THEN 'pb.DevelopmentGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Fund' THEN 'pb.EUFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Global' THEN 'pb.GlobalGlAccountCategoryKey' 
			ELSE 'break:not valid hierarchyname' END + '
			
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
    AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
'
')
print @cmdString
EXEC (@cmdString)

--Get reforecast information
SET @cmdString = (Select '

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
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' as OriginatingRegionCode,
    
    --Expenses must be displayed as negative
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	(
		er.Rate * (CASE WHEN gac.FeeOrExpense = ''INCOME'' THEN
					1
				   ELSE
					-1 
				   END) * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecast,
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
    (
        er.Rate * r.MultiplicationFactor * (CASE WHEN gac.FeeOrExpense = ''INCOME'' THEN
											 1
										    ELSE
											 -1 
										    END) * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecast,
	
	NULL as YtdGrossActual,	
	NULL as YtdGrossBudget, 
	(
		er.Rate * (CASE WHEN gac.FeeOrExpense = ''INCOME'' THEN
					1
				   ELSE
					-1 
				   END) * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecast, 
	
	NULL as YtdNetActual, 
	NULL as YtdNetBudget, 
    (
        er.Rate * r.MultiplicationFactor * (CASE WHEN gac.FeeOrExpense = ''INCOME'' THEN
											 1
										    ELSE
											 -1 
										    END) * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecast, 
	
	NULL as AnnualGrossBudget, ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
    '(er.Rate * pr.LocalReforecast * (CASE WHEN gac.FeeOrExpense = ''INCOME'' THEN
										  1
									    ELSE
										 -1 
									    END)) as AnnualGrossReforecast,
	NULL as AnnualGrossReforecastQ1,								    

	NULL as AnnualNetBudget, ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
    '(er.Rate * r.MultiplicationFactor * pr.LocalReforecast * (CASE WHEN gac.FeeOrExpense = ''INCOME'' THEN
																	1
																  ELSE
																	-1 
																  END))as AnnualNetReforecast,
	NULL as AnnualNetReforecastQ1,															  

	NULL as AnnualEstGrossBudget,
	(
		er.Rate * (CASE WHEN gac.FeeOrExpense = ''INCOME'' THEN
					1
				   ELSE
					-1 
				   END) *
		CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don't use the category mapping here like for actual exclude because we want unknowns to come through*/
			' OR (
					LEFT(pr.ReferenceCode,3) = ''BC:'' 
					AND ' + STR(@ReforecastEffectivePeriod,6,0) + ' IN (201003,201006))
				)
		THEN 
			pr.LocalReforecast
		ELSE
			0
		END
	) as AnnualEstGrossReforecast,

	NULL as AnnualEstNetBudget,
	(
        er.Rate * r.MultiplicationFactor * (CASE WHEN gac.FeeOrExpense = ''INCOME'' THEN
											 1
										    ELSE
											 -1 
										    END) *
        CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don't use the category mapping here like for actual exclude because we want unknowns to come through*/
			'  OR (
					LEFT(pr.ReferenceCode,3) = ''BC:'' 
					AND ' + STR(@ReforecastEffectivePeriod,6,0) + ' IN (201003,201006))
				)
		THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstNetReforecast
FROM
	ProfitabilityReforecast pr
	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = ' + CASE 
			WHEN @TranslationTypeName = 'EU Corporate' THEN 'pr.EUCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Property' THEN 'pr.USPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Fund' THEN 'pr.USFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Property' THEN 'pr.EUPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Corporate' THEN 'pr.USCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Development' THEN 'pr.DevelopmentGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Fund' THEN 'pr.EUFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Global' THEN 'pr.GlobalGlAccountCategoryKey' 
			ELSE 'break:not valid hierarchyname' END + '
			
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
    AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND ref.ReforecastEffectivePeriod = ' + STR(@ReforecastEffectivePeriod,10,0) + '
	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
'
')
print @cmdString
EXEC (@cmdString)

--Get reforecastQ1 information
SET @cmdString = (Select '

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
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' as OriginatingRegionCode,
    
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
	(er.Rate * pr.LocalReforecast * (CASE WHEN gac.FeeOrExpense = ''INCOME'' THEN
										  1
									    ELSE
										 -1 
									    END)) as AnnualGrossReforecastQ1,

	NULL as AnnualNetBudget, 
	NULL as AnnualNetReforecast,
	(er.Rate * r.MultiplicationFactor * pr.LocalReforecast * (CASE WHEN gac.FeeOrExpense = ''INCOME'' THEN
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
	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = ' + CASE 
			WHEN @TranslationTypeName = 'EU Corporate' THEN 'pr.EUCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Property' THEN 'pr.USPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Fund' THEN 'pr.USFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Property' THEN 'pr.EUPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Corporate' THEN 'pr.USCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Development' THEN 'pr.DevelopmentGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Fund' THEN 'pr.EUFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Global' THEN 'pr.GlobalGlAccountCategoryKey' 
			ELSE 'break:not valid hierarchyname' END + '
			
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
    AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND ref.ReforecastEffectivePeriod = ' + STR(@PreviousReforecastEffectivePeriod,10,0) + '
	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
'
')
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
	PropertyFundCode,
    OriginatingRegionCode,
	
	--Gross
	--Month to date    
	SUM(ISNULL(MtdGrossActual,0)) AS MtdGrossActual,
	SUM(ISNULL(MtdGrossBudget,0)) AS MtdGrossOriginalBudget,
	
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast 
		END,0)) 
	AS MtdGrossReforecast,
	
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast 
		END, 0) - ISNULL(MtdGrossActual, 0)) 
	AS MtdGrossVariance,
	
	--Year to date
	SUM(ISNULL(YtdGrossActual,0)) AS YtdGrossActual,	
	SUM(ISNULL(YtdGrossBudget,0)) AS YtdGrossOriginalBudget,
	
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END,0))
	AS YtdGrossReforecast,
	
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END, 0) - ISNULL(YtdGrossActual, 0))
	AS YtdGrossVariance,
	
	--Annual
	SUM(ISNULL(AnnualGrossBudget,0)) AS AnnualGrossOriginalBudget,	
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecast 
		END,0)) 
	AS AnnualGrossReforecast,
	
	SUM (ISNULL(CASE WHEN @PreviousReforecastQuaterName = 'Q1' THEN 
			AnnualGrossReforecastQ1 		
		END,0)) 
	AS AnnualGrossReforecastQ1,
	
	--Annual Estimated
	--SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
	--		AnnualEstGrossBudget 
	--	ELSE 
	--		AnnualEstGrossReforecast 
	--	END,0)) 
	--AS AnnualGrossEstimatedActual,	
	
	--SUM(ISNULL(AnnualGrossBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
	--											AnnualEstGrossBudget 
	--										ELSE 
	--											AnnualEstGrossReforecast 
	--										END,0))
	--AS AnnualGrossEstimatedVariance,
	
	--Net
	--Month to date    
	SUM(ISNULL(MtdNetActual,0)) AS MtdNetActual,
	SUM(ISNULL(MtdNetBudget,0)) AS MtdNetOriginalBudget,
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast 
		END,0)) AS MtdNetReforecast,
		
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast 
		END, 0) - ISNULL(MtdNetActual, 0))
	AS MtdNetVariance,
	
	--Year to date
	SUM(ISNULL(YtdNetActual,0)) AS YtdNetActual,	
	SUM(ISNULL(YtdNetBudget,0)) AS YtdNetOriginalBudget,
	
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast 
		END,0))
	AS YtdNetReforecast,
	
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast 
		END, 0) - ISNULL(YtdNetActual, 0)) 
	AS YtdNetVariance,
	
	--Annual
	SUM(ISNULL(AnnualNetBudget,0)) AS AnnualNetOriginalBudget,	
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecast 
		END,0))
	AS AnnualNetReforecast,
	SUM (ISNULL(CASE WHEN @PreviousReforecastQuaterName = 'Q1' THEN 
			AnnualNetReforecastQ1 		
		END,0)) 
	AS AnnualNetReforecastQ1
	
	--Annual Estimated
	--SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
	--		AnnualEstNetBudget 
	--	ELSE 
	--		AnnualEstNetReforecast 
	--	END,0))
	--AS AnnualNetEstimatedActual,
	
	--SUM(ISNULL(AnnualNetBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
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
    SourceName,
    PropertyFundCode,
    OriginatingRegionCode
ORDER BY
	CASE WHEN FeeOrExpense = 'INCOME' THEN 1 WHEN FeeOrExpense = 'EXPENSE' THEN 2 ELSE 3 END

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
	PropertyFundCode,
    OriginatingRegionCode,
	
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

IF 	OBJECT_ID('tempdb..#ProfitabilityReport') IS NOT NULL
    DROP TABLE #ProfitabilityReport

IF 	OBJECT_ID('tempdb..#Output') IS NOT NULL
    DROP TABLE #Output
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzarTotalComparisonDetail]    Script Date: 09/06/2010 12:58:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_R_ExpenseCzarTotalComparisonDetail]
	@ReportExpensePeriod INT = NULL,
	@ReforecastQuaterName VARCHAR(10) = NULL, --'Q1' or 'Q2' or 'Q3'
	@PreviousReforecastQuaterName VARCHAR(10) = 'Q1', -- or 'Q2' or 'Q3'
	@DestinationCurrency VARCHAR(3) = NULL,
	@TranslationTypeName VARCHAR(50) = 'Global',
	@IsGross bit = 1,
	@FunctionalDepartmentList TEXT = NULL,
	@ActivityTypeList TEXT = NULL,
	@EntityList TEXT = NULL,
	@MajorAccountCategoryList TEXT = NULL,
	@MinorAccountCategoryList TEXT = NULL,
	@AllocationRegionList TEXT = NULL,
	@AllocationSubRegionList TEXT = NULL,
	@OriginatingRegionList TEXT = NULL,
	@OriginatingSubRegionList TEXT = NULL,
	@CategoryActivityGroups dbo.CategoryActivityGroup READONLY
AS

/*
DECLARE @ReportExpensePeriod   INT,
	@AccountCategoryList   VARCHAR(8000),
	@DestinationCurrency   VARCHAR(3),
	@TranslationTypeName   VARCHAR(50),
	@FunctionalDepartmentList VARCHAR(8000),
	@AllocationRegionList VARCHAR(8000),
	@EntityList VARCHAR(8000)
	
	
	SET @ReportExpensePeriod = 201011
	SET @AccountCategoryList = 'IT Costs & Telecommunications'
	SET @DestinationCurrency ='USD'
	SET @TranslationTypeName = 'Global'
	SET @FunctionalDepartmentList = 'Information Technologies'
	SET @AllocationRegionList = NULL
	SET @EntityList = NULL
	
EXEC stp_R_ExpenseCzarTotalComparisonDetail
	@ReportExpensePeriod = 201011,
	@TranslationTypeName = 'Global',
	@DestinationCurrency = 'USD',

	@FunctionalDepartmentList = 'Information Technologies',
	@AllocationRegionList = 'CHICAGO',
	@EntityList = 'Aldgate|Centrium (St Cathrine House/Pegasus)'
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
	SET @ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + REPLACE(STR(MONTH(GETDATE()),2 ),' ','0')AS INT)

IF @DestinationCurrency IS NULL
	SET @DestinationCurrency = 'USD'

IF 	@TranslationTypeName IS NULL
	SET @TranslationTypeName = 'Global'

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
	CREATE TABLE	#CategoryActivityGroupFilterTable	(GlAccountCategoryKey Int NOT NULL, ActivityTypeKey Int NULL)	
		
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable	(PropertyFundKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable(ActivityTypeKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MajorAccountCategoryFilterTable(GlAccountCategoryKey)	
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MinorAccountCategoryFilterTable(GlAccountCategoryKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingRegionFilterTable	(OriginatingRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable	(OriginatingRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #CategoryActivityGroupFilterTable	(GlAccountCategoryKey, ActivityTypeKey)
	
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
	
IF EXISTS(SELECT * FROM @CategoryActivityGroups)
	BEGIN
	Insert Into #CategoryActivityGroupFilterTable
	Select gl.GlAccountCategoryKey, at.ActivityTypeKey 
	From @CategoryActivityGroups cag
		CROSS APPLY dbo.Split(cag.MinorAccountCategoryList) t1
		OUTER APPLY dbo.Split(cag.ActivityTypeList) t2
		INNER JOIN GlAccountCategory gl ON gl.MinorCategoryName = t1.item 
		LEFT OUTER JOIN ActivityType at ON at.ActivityTypeName = t2.item
	END
--------------------------------------------------------------------------
/*	COMMON END															*/
--------------------------------------------------------------------------

IF 	OBJECT_ID('tempdb..#ExpenseCzarTotalComparisonDetail') IS NOT NULL
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
	PropertyFundCode			Varchar(6) DEFAULT(''), --Varchar, for this helps to keep reports size smaller
	OriginatingRegionCode		Varchar(15) DEFAULT(''), --Varchar, for this helps to keep reports size smaller

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
SET @cmdString = (Select '
	
INSERT INTO #ExpenseCzarTotalComparisonDetail
SELECT 
	gac.GlAccountCategoryKey,
    pa.FunctionalDepartmentKey,
    pa.AllocationRegionKey,
    pa.PropertyFundKey,
    s.SourceName,
    CONVERT(varchar(10),ISNULL(pa.EntryDate,''''), 101) as EntryDate,
    ISNULL(pa.[User], '''') [User],
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.Description ELSE '''' END as Description,
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.AdditionalDescription ELSE '''' END as AdditionalDescription,
    ISNULL(pa.PropertyFundCode, '''') PropertyFundCode,
    ISNULL(pa.OriginatingRegionCode, '''') OriginatingRegionCode,
    
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdGrossActual,
	NULL as MtdGrossBudget,
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdGrossReforecast,
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdNetActual,
	NULL as MtdNetBudget,
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdNetReforecast,
	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdGrossActual,
	NULL as YtdGrossBudget,
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as YtdGrossReforecast,
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdNetActual,
	NULL as YtdNetBudget,
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
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
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualGrossReforecast,
	SUM(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@PreviousReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
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
        CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecast,
    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@PreviousReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ1,
	
	SUM(
        er.Rate *
        CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pa.LocalActual
        ELSE 
			0
        END
	) as AnnualEstGrossBudget,
	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecast,

    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstNetReforecast
	FROM
		ProfitabilityActual pa

		INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = ' + CASE 
				WHEN @TranslationTypeName = 'EU Corporate' THEN 'pa.EUCorporateGlAccountCategoryKey' 
				WHEN @TranslationTypeName = 'US Property' THEN 'pa.USPropertyGlAccountCategoryKey' 
				WHEN @TranslationTypeName = 'US Fund' THEN 'pa.USFundGlAccountCategoryKey' 
				WHEN @TranslationTypeName = 'EU Property' THEN 'pa.EUPropertyGlAccountCategoryKey' 
				WHEN @TranslationTypeName = 'US Corporate' THEN 'pa.USCorporateGlAccountCategoryKey' 
				WHEN @TranslationTypeName = 'Development' THEN 'pa.DevelopmentGlAccountCategoryKey' 
				WHEN @TranslationTypeName = 'EU Fund' THEN 'pa.EUFundGlAccountCategoryKey' 
				WHEN @TranslationTypeName = 'Global' THEN 'pa.GlobalGlAccountCategoryKey' 
				ELSE 'break:not valid TranslationTypeName' END + '
				AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')
				
	    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
	    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
	    INNER JOIN Calendar c ON  c.CalendarKey = pa.CalendarKey
	    INNER JOIN Source s ON s.SourceKey = pa.SourceKey
	    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pa.ReimbursableKey '
	    
    + CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pa.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pa.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pa.PropertyFundKey' ELSE '' END + 
	+ CASE WHEN EXISTS(SELECT * FROM @CategoryActivityGroups) THEN ' INNER JOIN #CategoryActivityGroupFilterTable cag ON cag.GlAccountCategoryKey = gac.GlAccountCategoryKey AND (cag.ActivityTypeKey IS NULL OR cag.ActivityTypeKey = pa.ActivityTypeKey)' ELSE '' END + '
			
WHERE  1 = 1
    AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select t1.FunctionalDepartmentKey From #FunctionalDepartmentFilterTable t1)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select t1.ActivityTypeKey From #ActivityTypeFilterTable t1)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select t1.PropertyFundKey From #EntityFilterTable t1)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationRegionFilterTable t1)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationSubRegionFilterTable t1)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MajorAccountCategoryFilterTable t1)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MinorAccountCategoryFilterTable t1)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingRegionFilterTable t1)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingSubRegionFilterTable t1)' END +
'
	Group By
		gac.GlAccountCategoryKey,
	    pa.FunctionalDepartmentKey,
	    pa.AllocationRegionKey,
	    pa.PropertyFundKey,
	    s.SourceName,
		CONVERT(varchar(10),ISNULL(pa.EntryDate,''''), 101),
		pa.[User],
		CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.Description ELSE '''' END,
		CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.AdditionalDescription ELSE '''' END,
		ISNULL(pa.PropertyFundCode, ''''),
		ISNULL(pa.OriginatingRegionCode, '''')
		
')
print @cmdString
EXEC (@cmdString)

-- Get budget information
SET @cmdString = (Select '	

INSERT INTO #ExpenseCzarTotalComparisonDetail
SELECT 
	gac.GlAccountCategoryKey,
	pb.FunctionalDepartmentKey,
	pb.AllocationRegionKey,
	pb.PropertyFundKey,
	s.SourceName,
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' as OriginatingRegionCode,
    
   NULL as MtdGrossActual,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as MtdGrossBudget,
	NULL as MtdGrossReforecast,
	
	NULL as MtdNetActual,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as MtdNetBudget,
	NULL as MtdNetReforecast,
	
	NULL as YtdGrossActual,	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as YtdGrossBudget, 
	NULL as YtdGrossReforecast, 
	
	NULL as YtdNetActual, 
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
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
		CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as AnnualEstGrossBudget,
	NULL as AnnualEstGrossReforecast,

	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
	NULL as AnnualEstNetReforecast
	
	FROM
		ProfitabilityBudget pb
		
		INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = ' + CASE 
				WHEN @TranslationTypeName = 'EU Corporate' THEN 'pb.EUCorporateGlAccountCategoryKey' 
				WHEN @TranslationTypeName = 'US Property' THEN 'pb.USPropertyGlAccountCategoryKey' 
				WHEN @TranslationTypeName = 'US Fund' THEN 'pb.USFundGlAccountCategoryKey' 
				WHEN @TranslationTypeName = 'EU Property' THEN 'pb.EUPropertyGlAccountCategoryKey' 
				WHEN @TranslationTypeName = 'US Corporate' THEN 'pb.USCorporateGlAccountCategoryKey' 
				WHEN @TranslationTypeName = 'Development' THEN 'pb.DevelopmentGlAccountCategoryKey' 
				WHEN @TranslationTypeName = 'EU Fund' THEN 'pb.EUFundGlAccountCategoryKey' 
				WHEN @TranslationTypeName = 'Global' THEN 'pb.GlobalGlAccountCategoryKey' 
				ELSE 'break:not valid TranslationTypeName' END + '
				AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')	

	    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey
	    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
	    INNER JOIN Calendar c ON  c.CalendarKey = pb.CalendarKey
	    INNER JOIN Source s ON s.SourceKey = pb.SourceKey
	    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pb.ReimbursableKey '
	    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pb.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey' ELSE '' END + 
	+ CASE WHEN EXISTS(SELECT * FROM @CategoryActivityGroups) THEN ' INNER JOIN #CategoryActivityGroupFilterTable cag ON cag.GlAccountCategoryKey = gac.GlAccountCategoryKey AND (cag.ActivityTypeKey IS NULL OR cag.ActivityTypeKey = pb.ActivityTypeKey)' ELSE '' END + '
		

WHERE  1 = 1 
    AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
'
	Group By
		gac.GlAccountCategoryKey,
	    pb.FunctionalDepartmentKey,
	    pb.AllocationRegionKey,
	    pb.PropertyFundKey,
	    s.SourceName
	    ')

print @cmdString
EXEC (@cmdString)

-- Get reforecast information
SET @cmdString = (Select '	

INSERT INTO #ExpenseCzarTotalComparisonDetail
SELECT 
	gac.GlAccountCategoryKey,
    pr.FunctionalDepartmentKey,
    pr.AllocationRegionKey,
    pr.PropertyFundKey,
    s.SourceName,
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' as OriginatingRegionCode,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	SUM(
		er.Rate * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecast,
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
    SUM(
        er.Rate * r.MultiplicationFactor * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecast,
	
	NULL as YtdGrossActual,	
	NULL as YtdGrossBudget, 
	SUM(
		er.Rate * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecast, 
	
	NULL as YtdNetActual, 
	NULL as YtdNetBudget, 
    SUM(
        er.Rate * r.MultiplicationFactor * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecast, 
	
	NULL as AnnualGrossBudget, ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
    'SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecast,
    NULL as AnnualGrossReforecastQ1,

	NULL as AnnualNetBudget, ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
    'SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecast,
    NULL as AnnualNetReforecastQ1,

	NULL as AnnualEstGrossBudget,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don't use the category mapping here like for actual exclude because we want unknowns to come through*/
			'
				 OR (
						LEFT(pr.ReferenceCode,3) = ''BC:''
						AND ' + STR(@ReforecastEffectivePeriod,6,0) + ' IN (201003,201006)
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
        CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don't use the category mapping here like for actual exclude because we want unknowns to come through*/
			'
				 OR (
						LEFT(pr.ReferenceCode,3) = ''BC:''
						AND ' + STR(@ReforecastEffectivePeriod,6,0) + ' IN (201003,201006)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstNetReforecast
	FROM
		ProfitabilityReforecast pr
		
		INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = ' + CASE 
				WHEN @TranslationTypeName = 'EU Corporate' THEN 'pr.EUCorporateGlAccountCategoryKey' 
				WHEN @TranslationTypeName = 'US Property' THEN 'pr.USPropertyGlAccountCategoryKey' 
				WHEN @TranslationTypeName = 'US Fund' THEN 'pr.USFundGlAccountCategoryKey' 
				WHEN @TranslationTypeName = 'EU Property' THEN 'pr.EUPropertyGlAccountCategoryKey' 
				WHEN @TranslationTypeName = 'US Corporate' THEN 'pr.USCorporateGlAccountCategoryKey' 
				WHEN @TranslationTypeName = 'Development' THEN 'pr.DevelopmentGlAccountCategoryKey' 
				WHEN @TranslationTypeName = 'EU Fund' THEN 'pr.EUFundGlAccountCategoryKey' 
				WHEN @TranslationTypeName = 'Global' THEN 'pr.GlobalGlAccountCategoryKey' 
				ELSE 'break:not valid TranslationTypeName' END + '
				AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')	

	    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
	    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
	    INNER JOIN Calendar c ON  c.CalendarKey = pr.CalendarKey
	    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
	    INNER JOIN Source s ON s.SourceKey = pr.SourceKey
	    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pr.ReimbursableKey '
	    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey' ELSE '' END + 
	+ CASE WHEN EXISTS(SELECT * FROM @CategoryActivityGroups) THEN ' INNER JOIN #CategoryActivityGroupFilterTable cag ON cag.GlAccountCategoryKey = gac.GlAccountCategoryKey AND (cag.ActivityTypeKey IS NULL OR cag.ActivityTypeKey = pr.ActivityTypeKey)' ELSE '' END + '
		

WHERE  1 = 1 
	AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND ref.ReforecastEffectivePeriod = ' + STR(@ReforecastEffectivePeriod,10,0) + '
	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
'
	Group By
		gac.GlAccountCategoryKey,
	    pr.FunctionalDepartmentKey,
	    pr.AllocationRegionKey,
	    pr.PropertyFundKey,
	    s.SourceName
	    ')

print @cmdString
EXEC (@cmdString)

-- Get reforecastQ1 information
SET @cmdString = (Select '	

INSERT INTO #ExpenseCzarTotalComparisonDetail
SELECT 
	gac.GlAccountCategoryKey,
    pr.FunctionalDepartmentKey,
    pr.AllocationRegionKey,
    pr.PropertyFundKey,
    s.SourceName,
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' as OriginatingRegionCode,
    
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
		
		INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = ' + CASE 
				WHEN @TranslationTypeName = 'EU Corporate' THEN 'pr.EUCorporateGlAccountCategoryKey' 
				WHEN @TranslationTypeName = 'US Property' THEN 'pr.USPropertyGlAccountCategoryKey' 
				WHEN @TranslationTypeName = 'US Fund' THEN 'pr.USFundGlAccountCategoryKey' 
				WHEN @TranslationTypeName = 'EU Property' THEN 'pr.EUPropertyGlAccountCategoryKey' 
				WHEN @TranslationTypeName = 'US Corporate' THEN 'pr.USCorporateGlAccountCategoryKey' 
				WHEN @TranslationTypeName = 'Development' THEN 'pr.DevelopmentGlAccountCategoryKey' 
				WHEN @TranslationTypeName = 'EU Fund' THEN 'pr.EUFundGlAccountCategoryKey' 
				WHEN @TranslationTypeName = 'Global' THEN 'pr.GlobalGlAccountCategoryKey' 
				ELSE 'break:not valid TranslationTypeName' END + '
				AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')	

	    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
	    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
	    INNER JOIN Calendar c ON  c.CalendarKey = pr.CalendarKey
	    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
	    INNER JOIN Source s ON s.SourceKey = pr.SourceKey
	    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pr.ReimbursableKey '
	    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey' ELSE '' END + 
	+ CASE WHEN EXISTS(SELECT * FROM @CategoryActivityGroups) THEN ' INNER JOIN #CategoryActivityGroupFilterTable cag ON cag.GlAccountCategoryKey = gac.GlAccountCategoryKey AND (cag.ActivityTypeKey IS NULL OR cag.ActivityTypeKey = pr.ActivityTypeKey)' ELSE '' END + '
		

WHERE  1 = 1 
	AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND ref.ReforecastEffectivePeriod = ' + STR(@PreviousReforecastEffectivePeriod,10,0) + '
	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
'
	Group By
		gac.GlAccountCategoryKey,
	    pr.FunctionalDepartmentKey,
	    pr.AllocationRegionKey,
	    pr.PropertyFundKey,
	    s.SourceName
')

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
    res.PropertyFundCode,
    res.OriginatingRegionCode,
    
	--Month to date    
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossActual,0) ELSE ISNULL(MtdNetActual,0) END) AS MtdActual,
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossBudget,0) ELSE ISNULL(MtdNetBudget,0) END) AS MtdOriginalBudget,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast 
		END,0) 
	END) 
	AS MtdReforecast,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast 
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
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
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast 
		END,0) 
	END) 
	AS YtdReforecast,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast 
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) 
	AS YtdVariance,
	
	--Annual
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(AnnualGrossBudget,0) ELSE ISNULL(AnnualNetBudget,0) END) AS AnnualOriginalBudget,	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecast 
		END,0) 
	END) 
	AS AnnualReforecast,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @PreviousReforecastQuaterName = 'Q1' THEN 
			AnnualGrossReforecastQ1 		
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @PreviousReforecastQuaterName = 'Q1' THEN 
			AnnualNetReforecastQ1	
		END,0) 
	END) 
	AS AnnualReforecastQ1
	
	--Annual Estimated
	--SUM(CASE WHEN (@IsGross = 1) THEN 
	--	ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
	--		AnnualEstGrossBudget 
	--	ELSE 
	--		AnnualEstGrossReforecast 
	--	END,0) 
	--ELSE 
	--	ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
	--		AnnualEstNetBudget 
	--	ELSE 
	--		AnnualEstNetReforecast 
	--	END,0) 
	--END) 
	--AS AnnualEstimatedActual,	
	
	--SUM(CASE WHEN (@IsGross = 1) THEN 
	--	ISNULL(AnnualGrossBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
	--											AnnualEstGrossBudget 
	--										ELSE 
	--											AnnualEstGrossReforecast 
	--										END,0) 
	--	ELSE 
	--		ISNULL(AnnualNetBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
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
    res.SourceName,
    res.PropertyFundCode,
    res.OriginatingRegionCode
	
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
    PropertyFundCode,
    OriginatingRegionCode,
    
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


IF 	OBJECT_ID('tempdb..#ExpenseCzarTotalComparisonDetail') IS NOT NULL
    DROP TABLE #ExpenseCzarTotalComparisonDetail

IF 	OBJECT_ID('tempdb..#Output') IS NOT NULL
    DROP TABLE #Output
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzarTotalComparison]    Script Date: 09/06/2010 12:58:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_R_ExpenseCzarTotalComparison]
	@ReportExpensePeriod INT = NULL,
	@ReforecastQuaterName VARCHAR(10) = NULL, --'Q1' or 'Q2' or 'Q3'
	@PreviousReforecastQuaterName VARCHAR(10) = 'Q1', -- or 'Q2' or 'Q3'
	@DestinationCurrency VARCHAR(3) = NULL,
	@TranslationTypeName VARCHAR(50) = 'Global',
	@IsGross bit = 1,
	@FunctionalDepartmentList TEXT = NULL,
	@ActivityTypeList TEXT = NULL,
	@EntityList TEXT = NULL,
	@MajorAccountCategoryList TEXT = NULL,
	@MinorAccountCategoryList TEXT = NULL,
	@AllocationRegionList TEXT = NULL,
	@AllocationSubRegionList TEXT = NULL,
	@OriginatingRegionList TEXT = NULL,
	@OriginatingSubRegionList TEXT = NULL,
	@CategoryActivityGroups dbo.CategoryActivityGroup READONLY
AS
 
/*
DECLARE @ReportExpensePeriod   INT,
    @DestinationCurrency   VARCHAR(3),
    @MajorGlAccountCategoryList VARCHAR(8000),
    @TranslationTypeName         VARCHAR(50)

	SET @ReportExpensePeriod = 201002
	SET @DestinationCurrency = 'USD'
	SET @MajorGlAccountCategoryList = 'Salaries/Taxes/Benefits,Occupancy Costs'
	SET @TranslationTypeName = 'Global'
*/ 
/*
EXEC stp_R_ExpenseCzarTotalComparison
	@ReportExpensePeriod = 201011,
	@TranslationTypeName = 'Global',
	@DestinationCurrency = 'USD',

	@FunctionalDepartmentList = 'Information Technologies',
	@AllocationRegionList = 'CHICAGO',
	@EntityList = 'Aldgate|Centrium (St Cathrine House/Pegasus)'
*/

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

--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Variable defaults		*/
--------------------------------------------------------------------------

IF @ReportExpensePeriod IS NULL
	SET @ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + REPLACE(STR(MONTH(GETDATE()),2 ),' ','0')AS INT)

IF @DestinationCurrency IS NULL
	SET @DestinationCurrency = 'USD'

IF 	@TranslationTypeName IS NULL
	SET @TranslationTypeName = 'Global'

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
	CREATE TABLE	#CategoryActivityGroupFilterTable	(GlAccountCategoryKey Int NOT NULL, ActivityTypeKey Int NULL)	
		
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable	(PropertyFundKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable(ActivityTypeKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MajorAccountCategoryFilterTable(GlAccountCategoryKey)	
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MinorAccountCategoryFilterTable(GlAccountCategoryKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingRegionFilterTable	(OriginatingRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable	(OriginatingRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #CategoryActivityGroupFilterTable	(GlAccountCategoryKey, ActivityTypeKey)
	
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
	
IF EXISTS(SELECT * FROM @CategoryActivityGroups)
	BEGIN
	Insert Into #CategoryActivityGroupFilterTable
	Select gl.GlAccountCategoryKey, at.ActivityTypeKey 
	From @CategoryActivityGroups cag
		CROSS APPLY dbo.Split(cag.MinorAccountCategoryList) t1
		OUTER APPLY dbo.Split(cag.ActivityTypeList) t2
		INNER JOIN GlAccountCategory gl ON gl.MinorCategoryName = t1.item 
		LEFT OUTER JOIN ActivityType at ON at.ActivityTypeName = t2.item
	END	
--------------------------------------------------------------------------
/*	COMMON END															*/
--------------------------------------------------------------------------
	
 
 -- Combine budget and actual values
IF OBJECT_ID('tempdb..#TotalComparison') IS NOT NULL
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
	PropertyFundCode			Varchar(6) DEFAULT(''), --Varchar, for this helps to keep reports size smaller
	OriginatingRegionCode		Varchar(15) DEFAULT(''), --Varchar, for this helps to keep reports size smaller

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
SET @cmdString = (Select '
INSERT INTO #TotalComparison
SELECT 
	gac.AccountSubTypeName,
    gac.TranslationTypeName,
    gac.MajorCategoryName,
    gac.MinorCategoryName,
    c.CalendarPeriod,
    s.SourceName,
    CONVERT(varchar(10),ISNULL(pa.EntryDate,''''), 101) as EntryDate,
    ISNULL(pa.[User], '''') [User],
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.Description ELSE '''' END as Description,
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.AdditionalDescription ELSE '''' END as AdditionalDescription,
    ISNULL(pa.PropertyFundCode, '''') PropertyFundCode,
    ISNULL(pa.OriginatingRegionCode, '''') OriginatingRegionCode,
    
    (
		er.Rate *
		CASE WHEN (c.CalendarPeriod = '+STR(@ReportExpensePeriod,10,0)+') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdGrossActual,
	NULL as MtdGrossBudget,
	(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= '+STR(@ReportExpensePeriod,10,0)+'
			 AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdGrossReforecast,	
    (
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod = '+STR(@ReportExpensePeriod,10,0)+') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as MtdNetActual,
	NULL as MtdNetBudget,
	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod = '+STR(@ReportExpensePeriod,10,0)+'
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdNetReforecast,
    (
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= '+STR(@ReportExpensePeriod,10,0)+') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdGrossActual,    
    NULL as YtdGrossBudget,
	(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= '+STR(@ReportExpensePeriod,10,0)+'
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as YtdGrossReforecast,    
	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= '+STR(@ReportExpensePeriod,10,0)+') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as YtdNetActual,
	NULL as YtdNetBudget,
   
	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '+STR(@ReportExpensePeriod,10,0)+'
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
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
		CASE WHEN c.CalendarPeriod <= '+STR(@ReportExpensePeriod,10,0)+'
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualGrossReforecast,
	(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= '+STR(@ReportExpensePeriod,10,0)+'
			  AND c.CalendarPeriod < ' + STR(@PreviousReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
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
        CASE WHEN c.CalendarPeriod <= '+STR(@ReportExpensePeriod,10,0)+'
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecast,
    (
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '+STR(@ReportExpensePeriod,10,0)+'
			  AND c.CalendarPeriod < ' + STR(@PreviousReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ1,
	(
        er.Rate *
        CASE WHEN (c.CalendarPeriod <= '+STR(@ReportExpensePeriod,10,0) + ') THEN 
			pa.LocalActual
        ELSE 
			0
        END
	) as AnnualEstGrossBudget,
    (
        er.Rate *
        CASE WHEN c.CalendarPeriod <= '+STR(@ReportExpensePeriod,10,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecast,	
	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= '+STR(@ReportExpensePeriod,10,0) + ') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,	
	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '+STR(@ReportExpensePeriod,10,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstNetReforecast
FROM
	ProfitabilityActual pa

	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = ' + CASE 
			WHEN @TranslationTypeName = 'EU Corporate' THEN 'pa.EUCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Property' THEN 'pa.USPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Fund' THEN 'pa.USFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Property' THEN 'pa.EUPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Corporate' THEN 'pa.USCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Development' THEN 'pa.DevelopmentGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Fund' THEN 'pa.EUFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Global' THEN 'pa.GlobalGlAccountCategoryKey' 
			ELSE 'break:not valid TranslationTypeName' END + '
			AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')
			
    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pa.CalendarKey
    INNER JOIN Source s ON s.SourceKey = pa.SourceKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pa.ReimbursableKey '
		
    + CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pa.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pa.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pa.PropertyFundKey' ELSE '' END + 
	+ CASE WHEN EXISTS(SELECT * FROM @CategoryActivityGroups) THEN ' INNER JOIN #CategoryActivityGroupFilterTable cag ON cag.GlAccountCategoryKey = gac.GlAccountCategoryKey AND (cag.ActivityTypeKey IS NULL OR cag.ActivityTypeKey = pa.ActivityTypeKey)' ELSE '' END + '
		
WHERE  1 = 1 
	AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select t1.FunctionalDepartmentKey From #FunctionalDepartmentFilterTable t1)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select t1.ActivityTypeKey From #ActivityTypeFilterTable t1)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select t1.PropertyFundKey From #EntityFilterTable t1)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationRegionFilterTable t1)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationSubRegionFilterTable t1)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MajorAccountCategoryFilterTable t1)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MinorAccountCategoryFilterTable t1)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingRegionFilterTable t1)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingSubRegionFilterTable t1)' END +
'    
')
print @cmdString
EXEC (@cmdString)

--Get budget information
SET @cmdString = (Select '
INSERT INTO #TotalComparison
SELECT 
	gac.AccountSubTypeName,
    gac.TranslationTypeName,
    gac.MajorCategoryName,
    gac.MinorCategoryName,
    c.CalendarPeriod,
    s.SourceName,
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' as OriginatingRegionCode,
    
    NULL as MtdGrossActual,    
    (
		er.Rate *
		CASE WHEN (c.CalendarPeriod = '+STR(@ReportExpensePeriod,10,0)+') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as MtdGrossBudget,
	NULL as MtdGrossReforecast,
    NULL as MtdNetActual,
	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod = '+STR(@ReportExpensePeriod,10,0)+') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as MtdNetBudget,
	NULL as MtdNetReforecast,
    NULL as YtdGrossActual,	
	(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= '+STR(@ReportExpensePeriod,10,0)+') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as YtdGrossBudget,
	NULL as YtdGrossReforecast,
	NULL as YtdNetActual,	
	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= '+STR(@ReportExpensePeriod,10,0)+') THEN 
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
		CASE WHEN (c.CalendarPeriod > '+STR(@ReportExpensePeriod,10,0)+') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as AnnualEstGrossBudget,
	NULL as AnnualEstGrossReforecast,
    (
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '+STR(@ReportExpensePeriod,10,0)+') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as AnnualEstNetBudget, 
	NULL as AnnualEstNetReforecast
    
FROM
	ProfitabilityBudget pb

	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = ' + CASE 
			WHEN @TranslationTypeName = 'EU Corporate' THEN 'pb.EUCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Property' THEN 'pb.USPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Fund' THEN 'pb.USFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Property' THEN 'pb.EUPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Corporate' THEN 'pb.USCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Development' THEN 'pb.DevelopmentGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Fund' THEN 'pb.EUFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Global' THEN 'pb.GlobalGlAccountCategoryKey' 
			ELSE 'break:not valid TranslationTypeName' END + '
			AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')
	
    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON c.CalendarKey = pb.CalendarKey
    INNER JOIN Source s ON s.SourceKey = pb.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pb.ReimbursableKey	'
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pb.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey' ELSE '' END + 
	+ CASE WHEN EXISTS(SELECT * FROM @CategoryActivityGroups) THEN ' INNER JOIN #CategoryActivityGroupFilterTable cag ON cag.GlAccountCategoryKey = gac.GlAccountCategoryKey AND (cag.ActivityTypeKey IS NULL OR cag.ActivityTypeKey = pb.ActivityTypeKey)' ELSE '' END + '

WHERE  1 = 1  
	AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
'

')

print @cmdString
EXEC (@cmdString)

--Get reforecast information
SET @cmdString = (Select '
INSERT INTO #TotalComparison
SELECT 
	gac.AccountSubTypeName,
    gac.TranslationTypeName,
    gac.MajorCategoryName,
    gac.MinorCategoryName,
    c.CalendarPeriod,
    s.SourceName,
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' as OriginatingRegionCode,
    
    NULL as MtdGrossActual,
    NULL as MtdGrossBudget,
    (
		er.Rate * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod = '+STR(@ReportExpensePeriod,10,0)+') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecast,
    NULL as MtdNetActual,
	NULL as MtdNetBudget,
	(
        er.Rate * r.MultiplicationFactor * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod = '+STR(@ReportExpensePeriod,10,0)+') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecast,
    NULL as YtdGrossActual,    
    NULL as YtdGrossBudget,
	(
		er.Rate * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod <= '+STR(@ReportExpensePeriod,10,0)+') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecast,
	NULL as YtdNetActual,
	NULL as YtdNetBudget,
	(
        er.Rate * r.MultiplicationFactor * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod <= '+STR(@ReportExpensePeriod,10,0)+') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecast,
   	NULL as AnnualGrossBudget,' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
    '(er.Rate * pr.LocalReforecast) as AnnualGrossReforecast,
     NULL as AnnualGrossReforecastQ1,
	NULL as AnnualNetBudget,' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
    '(er.Rate * r.MultiplicationFactor * pr.LocalReforecast) as AnnualNetReforecast,
    NULL as AnnualNetReforecastQ1,
    NULL as AnnualEstGrossBudget,
	(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > ' +STR(@ReportExpensePeriod,10,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don't use the category mapping here like for actual exclude because we want unknowns to come through*/
			'
				 OR (
						LEFT(pr.ReferenceCode,3) = ''BC:''
						AND ' + STR(@ReforecastEffectivePeriod,6,0) + ' IN (201003,201006)
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
        CASE WHEN (c.CalendarPeriod > ' +STR(@ReportExpensePeriod,10,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don't use the category mapping here like for actual exclude because we want unknowns to come through*/
			'
				 OR (
						LEFT(pr.ReferenceCode,3) = ''BC:''
						AND ' + STR(@ReforecastEffectivePeriod,6,0) + ' IN (201003,201006)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstNetReforecast
FROM
	ProfitabilityReforecast pr

	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = ' + CASE 
			WHEN @TranslationTypeName = 'EU Corporate' THEN 'pr.EUCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Property' THEN 'pr.USPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Fund' THEN 'pr.USFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Property' THEN 'pr.EUPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Corporate' THEN 'pr.USCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Development' THEN 'pr.DevelopmentGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Fund' THEN 'pr.EUFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Global' THEN 'pr.GlobalGlAccountCategoryKey' 
			ELSE 'break:not valid TranslationTypeName' END + '
			AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')
	
    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON c.CalendarKey = pr.CalendarKey
    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
    INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey	'
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey' ELSE '' END + 
	+ CASE WHEN EXISTS(SELECT * FROM @CategoryActivityGroups) THEN ' INNER JOIN #CategoryActivityGroupFilterTable cag ON cag.GlAccountCategoryKey = gac.GlAccountCategoryKey AND (cag.ActivityTypeKey IS NULL OR cag.ActivityTypeKey = pr.ActivityTypeKey)' ELSE '' END + '

WHERE  1 = 1  
	AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
	AND ref.ReforecastEffectivePeriod = ' + STR(@ReforecastEffectivePeriod,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
'

')

print @cmdString
EXEC (@cmdString)

--Get reforecast information
SET @cmdString = (Select '
INSERT INTO #TotalComparison
SELECT 
	gac.AccountSubTypeName,
    gac.TranslationTypeName,
    gac.MajorCategoryName,
    gac.MinorCategoryName,
    c.CalendarPeriod,
    s.SourceName,
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' as OriginatingRegionCode,
    
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

	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = ' + CASE 
			WHEN @TranslationTypeName = 'EU Corporate' THEN 'pr.EUCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Property' THEN 'pr.USPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Fund' THEN 'pr.USFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Property' THEN 'pr.EUPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Corporate' THEN 'pr.USCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Development' THEN 'pr.DevelopmentGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Fund' THEN 'pr.EUFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Global' THEN 'pr.GlobalGlAccountCategoryKey' 
			ELSE 'break:not valid TranslationTypeName' END + '
			AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')
	
    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON c.CalendarKey = pr.CalendarKey
    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
    INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey	'
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey' ELSE '' END + 
	+ CASE WHEN EXISTS(SELECT * FROM @CategoryActivityGroups) THEN ' INNER JOIN #CategoryActivityGroupFilterTable cag ON cag.GlAccountCategoryKey = gac.GlAccountCategoryKey AND (cag.ActivityTypeKey IS NULL OR cag.ActivityTypeKey = pr.ActivityTypeKey)' ELSE '' END + '

WHERE  1 = 1  
	AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
	AND ref.ReforecastEffectivePeriod = ' + STR(@PreviousReforecastEffectivePeriod,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
'

')

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
	PropertyFundCode,
    OriginatingRegionCode,
	
	--Month to date
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossActual,0) ELSE ISNULL(MtdNetActual,0) END) AS MtdActual,
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossBudget,0) ELSE ISNULL(MtdNetBudget,0) END) AS MtdOriginalBudget,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast 
		END,0) 
	END) 
	AS MtdReforecast,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast 
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
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
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast 
		END,0) 
	END) 
	AS YtdReforecast,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast 
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) 
	AS YtdVariance,
	
	--Annual
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(AnnualGrossBudget,0) ELSE ISNULL(AnnualNetBudget,0) END) AS AnnualOriginalBudget,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecast 
		END,0) 
	END) 
	AS AnnualReforecast,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @PreviousReforecastQuaterName = 'Q1' THEN 
			AnnualGrossReforecastQ1 		
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @PreviousReforecastQuaterName = 'Q1' THEN 
			AnnualNetReforecastQ1	
		END,0) 
	END) 
	AS AnnualReforecastQ1,
	
	--Annual Estimated
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			AnnualEstGrossBudget 
		ELSE 
			AnnualEstGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			AnnualEstNetBudget 
		ELSE 
			AnnualEstNetReforecast 
		END,0) 
	END) 
	AS AnnualEstimatedActual,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(AnnualGrossBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
												AnnualEstGrossBudget 
											ELSE 
												AnnualEstGrossReforecast 
											END,0) 
		ELSE 
			ISNULL(AnnualNetBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
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
    SourceName,
    PropertyFundCode,
    OriginatingRegionCode

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
	PropertyFundCode,
    OriginatingRegionCode,
	
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


IF 	OBJECT_ID('tempdb..#Output') IS NOT NULL
    DROP TABLE #Output
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzar]    Script Date: 09/06/2010 12:58:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_R_ExpenseCzar]
	@ReportExpensePeriod INT = NULL,
	@ReforecastQuaterName VARCHAR(10) = NULL, --'Q1' or 'Q2' or 'Q3'
	@PreviousReforecastQuaterName VARCHAR(10) = 'Q1',-- or 'Q2' or 'Q3'
	@DestinationCurrency VARCHAR(3) = NULL,
	@TranslationTypeName VARCHAR(50) = 'Global',
	@IsGross bit = 1,
	@FunctionalDepartmentList TEXT = NULL,
	@ActivityTypeList TEXT = NULL,
	@EntityList TEXT = NULL,
	@MajorAccountCategoryList TEXT = NULL,
	@MinorAccountCategoryList TEXT = NULL,
	@AllocationRegionList TEXT = NULL,
	@AllocationSubRegionList TEXT = NULL,
	@OriginatingRegionList TEXT = NULL,
	@OriginatingSubRegionList TEXT = NULL,
	@CategoryActivityGroups dbo.CategoryActivityGroup READONLY
AS

/*
DECLARE @ReportExpensePeriod	AS INT,
	@AccountCategoryList	AS TEXT,
	@DestinationCurrency	AS VARCHAR(3),
	@TranslationTypeName	VARCHAR(50)
	
	SET @ReportExpensePeriod = 201011
	SET @AccountCategoryList = 'IT Costs & Telecommunications|Legal & Professional Fees|Marketing'
	SET @DestinationCurrency ='USD'
	SET @TranslationTypeName = 'Global'
	
EXEC stp_R_ExpenseCzar
	@ReportExpensePeriod = 201011,
	@TranslationTypeName = 'Global',
	@DestinationCurrency = 'USD',

	@FunctionalDepartmentList = 'Information Technologies',
	@AllocationRegionList = 'CHICAGO',
	@EntityList = 'Aldgate|Centrium (St Cathrine House/Pegasus)'
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
	SET @DestinationCurrency = 'USD'

IF 	@TranslationTypeName IS NULL
	SET @TranslationTypeName = 'Global'

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
	CREATE TABLE	#CategoryActivityGroupFilterTable	(GlAccountCategoryKey Int NOT NULL, ActivityTypeKey Int NULL)	
		
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable	(PropertyFundKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable(ActivityTypeKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MajorAccountCategoryFilterTable(GlAccountCategoryKey)	
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MinorAccountCategoryFilterTable(GlAccountCategoryKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingRegionFilterTable	(OriginatingRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable	(OriginatingRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #CategoryActivityGroupFilterTable	(GlAccountCategoryKey, ActivityTypeKey)
	
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
	
IF EXISTS(SELECT * FROM @CategoryActivityGroups)
	BEGIN
	Insert Into #CategoryActivityGroupFilterTable
	Select gl.GlAccountCategoryKey, at.ActivityTypeKey 
	From @CategoryActivityGroups cag
		CROSS APPLY dbo.Split(cag.MinorAccountCategoryList) t1
		OUTER APPLY dbo.Split(cag.ActivityTypeList) t2
		INNER JOIN GlAccountCategory gl ON gl.MinorCategoryName = t1.item 
		LEFT OUTER JOIN ActivityType at ON at.ActivityTypeName = t2.item
	END
--------------------------------------------------------------------------
/*	COMMON END															*/
--------------------------------------------------------------------------
		
IF 	OBJECT_ID('tempdb..#ExpenseCzar') IS NOT NULL
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
	PropertyFundCode			Varchar(6) DEFAULT(''), --Varchar, for this helps to keep reports size smaller
	OriginatingRegionCode		Varchar(15) DEFAULT(''), --Varchar, for this helps to keep reports size smaller

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
SET @cmdString = (Select '

INSERT INTO #ExpenseCzar
SELECT 
	gac.GlAccountCategoryKey,
	pa.AllocationRegionKey,
    pa.FunctionalDepartmentKey,    
    pa.PropertyFundKey,
    c.CalendarPeriod,
    s.SourceName,
    CONVERT(varchar(10),ISNULL(pa.EntryDate,''''), 101) as EntryDate,
    ISNULL(pa.[User], '''') [User],
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.Description ELSE '''' END as Description,
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.AdditionalDescription ELSE '''' END as AdditionalDescription,
    ISNULL(pa.PropertyFundCode, '''') PropertyFundCode,
    ISNULL(pa.OriginatingRegionCode, '''') OriginatingRegionCode,
    
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdGrossActual,
	NULL as MtdGrossBudget,
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdGrossReforecast,
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdNetActual,
	NULL as MtdNetBudget,
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdNetReforecast,
	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdGrossActual,
	NULL as YtdGrossBudget,
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as YtdGrossReforecast,
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdNetActual,
	NULL as YtdNetBudget,
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
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
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualGrossReforecast,
	SUM(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@PreviousReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
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
        CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecast,
    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@PreviousReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ1,
	
	SUM(
        er.Rate *
        CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pa.LocalActual
        ELSE 
			0
        END
	) as AnnualEstGrossBudget,
	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecast,

    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstNetReforecast
FROM
	ProfitabilityActual pa

	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = ' + CASE 
			WHEN @TranslationTypeName = 'EU Corporate' THEN 'pa.EUCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Property' THEN 'pa.USPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Fund' THEN 'pa.USFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Property' THEN 'pa.EUPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Corporate' THEN 'pa.USCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Development' THEN 'pa.DevelopmentGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Fund' THEN 'pa.EUFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Global' THEN 'pa.GlobalGlAccountCategoryKey' 
			ELSE 'break:not valid hierarchyname' END + '
			AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')

    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
	INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
	INNER JOIN Calendar c ON  c.CalendarKey = pa.CalendarKey
	INNER JOIN Source s ON s.SourceKey = pa.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pa.ReimbursableKey '
    			    
    + CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pa.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pa.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pa.PropertyFundKey' ELSE '' END + 
	+ CASE WHEN EXISTS(SELECT * FROM @CategoryActivityGroups) THEN ' INNER JOIN #CategoryActivityGroupFilterTable cag ON cag.GlAccountCategoryKey = gac.GlAccountCategoryKey AND (cag.ActivityTypeKey IS NULL OR cag.ActivityTypeKey = pa.ActivityTypeKey)' ELSE '' END + '
		
WHERE  1 = 1 
	AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select t1.FunctionalDepartmentKey From #FunctionalDepartmentFilterTable t1)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select t1.ActivityTypeKey From #ActivityTypeFilterTable t1)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select t1.PropertyFundKey From #EntityFilterTable t1)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationRegionFilterTable t1)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationSubRegionFilterTable t1)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MajorAccountCategoryFilterTable t1)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MinorAccountCategoryFilterTable t1)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingRegionFilterTable t1)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingSubRegionFilterTable t1)' END +
'	
	Group By
		gac.GlAccountCategoryKey,
		pa.AllocationRegionKey,
		pa.FunctionalDepartmentKey,		
		pa.PropertyFundKey,
		c.CalendarPeriod,
		s.SourceName,
		CONVERT(varchar(10),ISNULL(pa.EntryDate,''''), 101),
		ISNULL(pa.[User], '''') ,
		CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.Description ELSE '''' END,
		CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.AdditionalDescription ELSE '''' END,
		ISNULL(pa.PropertyFundCode, ''''),
		ISNULL(pa.OriginatingRegionCode, '''')
		
')
print @cmdString
EXEC (@cmdString)

-- Get budget information
SET @cmdString = (Select '
INSERT INTO #ExpenseCzar
SELECT 
	gac.GlAccountCategoryKey,
	pb.AllocationRegionKey,
	pb.FunctionalDepartmentKey,	
	pb.PropertyFundKey,
	c.CalendarPeriod,
    s.SourceName,
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' as OriginatingRegionCode,
    
   NULL as MtdGrossActual,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as MtdGrossBudget,
	NULL as MtdGrossReforecast,
	
	NULL as MtdNetActual,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as MtdNetBudget,
	NULL as MtdNetReforecast,
	
	NULL as YtdGrossActual,	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as YtdGrossBudget, 
	NULL as YtdGrossReforecast, 
	
	NULL as YtdNetActual, 
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
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
		CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as AnnualEstGrossBudget,
	NULL as AnnualEstGrossReforecast,

	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
	NULL as AnnualEstNetReforecast
FROM
	ProfitabilityBudget pb
    
    	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = ' + CASE 
			WHEN @TranslationTypeName = 'EU Corporate' THEN 'pb.EUCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Property' THEN 'pb.USPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Fund' THEN 'pb.USFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Property' THEN 'pb.EUPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Corporate' THEN 'pb.USCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Development' THEN 'pb.DevelopmentGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Fund' THEN 'pb.EUFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Global' THEN 'pb.GlobalGlAccountCategoryKey' 
			ELSE 'break:not valid hierarchyname' END + '
			AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')

    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON c.CalendarKey = pb.CalendarKey
    INNER JOIN Source s ON s.SourceKey = pb.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pb.ReimbursableKey '
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pb.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey' ELSE '' END + 
	+ CASE WHEN EXISTS(SELECT * FROM @CategoryActivityGroups) THEN ' INNER JOIN #CategoryActivityGroupFilterTable cag ON cag.GlAccountCategoryKey = gac.GlAccountCategoryKey AND (cag.ActivityTypeKey IS NULL OR cag.ActivityTypeKey = pb.ActivityTypeKey)' ELSE '' END + '
		
WHERE  1 = 1 
    AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
'    
	Group By
			gac.GlAccountCategoryKey,
			pb.AllocationRegionKey,
			pb.FunctionalDepartmentKey,			
			pb.PropertyFundKey,
			c.CalendarPeriod,
			s.SourceName
')
print @cmdString
EXEC (@cmdString)

-- Get reforecast information
SET @cmdString = (Select '
INSERT INTO #ExpenseCzar
SELECT 
	gac.GlAccountCategoryKey,
	pr.AllocationRegionKey,
	pr.FunctionalDepartmentKey,	
	pr.PropertyFundKey,
	c.CalendarPeriod,
    s.SourceName,
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' as OriginatingRegionCode,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	SUM(
		er.Rate * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecast,
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
    SUM(
        er.Rate * r.MultiplicationFactor * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecast,
	
	NULL as YtdGrossActual,	
	NULL as YtdGrossBudget, 
	SUM(
		er.Rate * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecast, 
	
	NULL as YtdNetActual, 
	NULL as YtdNetBudget, 
    SUM(
        er.Rate * r.MultiplicationFactor * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecast, 
	
	NULL as AnnualGrossBudget, ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
    'SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecast,
    NULL as AnnualGrossReforecastQ1,

	NULL as AnnualNetBudget, ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
    'SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecast,
    NULL as AnnualNetReforecastQ1,

	NULL as AnnualEstGrossBudget,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don't use the category mapping here like for actual exclude because we want unknowns to come through*/
			'
				 OR (
						LEFT(pr.ReferenceCode,3) = ''BC:''
						AND ' + STR(@ReforecastEffectivePeriod,6,0) + ' IN (201003,201006)
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
        CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don't use the category mapping here like for actual exclude because we want unknowns to come through*/
			'
				 OR (
						LEFT(pr.ReferenceCode,3) = ''BC:''
						AND ' + STR(@ReforecastEffectivePeriod,6,0) + ' IN (201003,201006)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstNetReforecast
FROM
	ProfitabilityReforecast pr
    
    	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = ' + CASE 
			WHEN @TranslationTypeName = 'EU Corporate' THEN 'pr.EUCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Property' THEN 'pr.USPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Fund' THEN 'pr.USFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Property' THEN 'pr.EUPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Corporate' THEN 'pr.USCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Development' THEN 'pr.DevelopmentGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Fund' THEN 'pr.EUFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Global' THEN 'pr.GlobalGlAccountCategoryKey' 
			ELSE 'break:not valid hierarchyname' END + '
			AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')

    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON c.CalendarKey = pr.CalendarKey
    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
    INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey '
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey' ELSE '' END + 
	+ CASE WHEN EXISTS(SELECT * FROM @CategoryActivityGroups) THEN ' INNER JOIN #CategoryActivityGroupFilterTable cag ON cag.GlAccountCategoryKey = gac.GlAccountCategoryKey AND (cag.ActivityTypeKey IS NULL OR cag.ActivityTypeKey = pr.ActivityTypeKey)' ELSE '' END + '

		
WHERE  1 = 1 
	AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND ref.ReforecastEffectivePeriod = ' + STR(@ReforecastEffectivePeriod,10,0) + '
	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
'    
	Group By
			gac.GlAccountCategoryKey,
			pr.AllocationRegionKey,
			pr.FunctionalDepartmentKey,			
			pr.PropertyFundKey,
			c.CalendarPeriod,
			s.SourceName
')
print @cmdString
EXEC (@cmdString)

-- Get reforecastQ1 information
SET @cmdString = (Select '
INSERT INTO #ExpenseCzar
SELECT 
	gac.GlAccountCategoryKey,
	pr.AllocationRegionKey,
	pr.FunctionalDepartmentKey,	
	pr.PropertyFundKey,
	c.CalendarPeriod,
    s.SourceName,
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' as OriginatingRegionCode,
    
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
    
    	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = ' + CASE 
			WHEN @TranslationTypeName = 'EU Corporate' THEN 'pr.EUCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Property' THEN 'pr.USPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Fund' THEN 'pr.USFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Property' THEN 'pr.EUPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Corporate' THEN 'pr.USCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Development' THEN 'pr.DevelopmentGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Fund' THEN 'pr.EUFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Global' THEN 'pr.GlobalGlAccountCategoryKey' 
			ELSE 'break:not valid hierarchyname' END + '
			AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')

    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON c.CalendarKey = pr.CalendarKey
    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
    INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey '
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey' ELSE '' END + 
	+ CASE WHEN EXISTS(SELECT * FROM @CategoryActivityGroups) THEN ' INNER JOIN #CategoryActivityGroupFilterTable cag ON cag.GlAccountCategoryKey = gac.GlAccountCategoryKey AND (cag.ActivityTypeKey IS NULL OR cag.ActivityTypeKey = pr.ActivityTypeKey)' ELSE '' END + '
		
WHERE  1 = 1 
	AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND ref.ReforecastEffectivePeriod = ' + STR(@PreviousReforecastEffectivePeriod,10,0) + '
	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
'    
	Group By
			gac.GlAccountCategoryKey,
			pr.AllocationRegionKey,
			pr.FunctionalDepartmentKey,			
			pr.PropertyFundKey,
			c.CalendarPeriod,
			s.SourceName
')
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
    res.PropertyFundCode,
    res.OriginatingRegionCode,
    
	--Gross
	--Month to date    
	SUM(ISNULL(MtdGrossActual,0)) AS MtdGrossActual,
	SUM(ISNULL(MtdGrossBudget,0)) AS MtdGrossOriginalBudget,
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast 
		END,0)) AS MtdGrossReforecast,
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast 
		END, 0) - ISNULL(MtdGrossActual, 0)) 
	AS MtdGrossVariance,
		
	--Year to date
	SUM(ISNULL(YtdGrossActual,0)) AS YtdGrossActual,	
	SUM(ISNULL(YtdGrossBudget,0)) AS YtdGrossOriginalBudget,
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END,0)) AS YtdGrossReforecast,
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END, 0) - ISNULL(YtdGrossActual, 0)) 
	AS YtdGrossVariance,
		
	--Annual
	SUM(ISNULL(AnnualGrossBudget,0)) AS AnnualGrossOriginalBudget,	
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecast 
		END,0)) 
		AS AnnualGrossReforecast,
		
	SUM (ISNULL(CASE WHEN @PreviousReforecastQuaterName = 'Q1' THEN 
			AnnualGrossReforecastQ1 		
		END,0)) 
	AS AnnualGrossReforecastQ1,		
	--Annual Estimated
	--SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
	--		AnnualEstGrossBudget 
	--	ELSE 
	--		AnnualEstGrossReforecast 
	--	END,0)) 
	--	AS AnnualGrossEstimatedActual,	
		
	--SUM(ISNULL(AnnualGrossBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
	--											AnnualEstGrossBudget 
	--										ELSE 
	--											AnnualEstGrossReforecast 
	--										END,0)) 
	--AS AnnualGrossEstimatedVariance,
	
	--Net
	--Month to date    
	SUM(ISNULL(MtdNetActual,0)) AS MtdNetActual,
	SUM(ISNULL(MtdNetBudget,0)) AS MtdNetOriginalBudget,
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast 
		END,0)) 
	AS MtdNetReforecast,
	
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast 
		END, 0) - ISNULL(MtdNetActual, 0)) 
	AS MtdNetVariance,
		
	--Year to date
	SUM(ISNULL(YtdNetActual,0)) AS YtdNetActual,	
	SUM(ISNULL(YtdNetBudget,0)) AS YtdNetOriginalBudget,
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast 
		END,0)) 
	AS YtdNetReforecast,
		
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast 
		END, 0) - ISNULL(YtdNetActual, 0)) 
	AS YtdNetVariance,
		
	--Annual
	SUM(ISNULL(AnnualNetBudget,0)) AS AnnualNetOriginalBudget,	
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecast 
		END,0)) 
	AS AnnualNetReforecast,
	
	SUM (ISNULL(CASE WHEN @PreviousReforecastQuaterName = 'Q1' THEN 
			AnnualNetReforecastQ1 		
		END,0)) 
	AS AnnualNetReforecastQ1
		
	--Annual Estimated
	--SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
	--		AnnualEstNetBudget 
	--	ELSE 
	--		AnnualEstNetReforecast 
	--	END,0)) 
	--AS AnnualNetEstimatedActual,	
		
	--SUM(ISNULL(AnnualNetBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
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
    res.SourceName,
    res.PropertyFundCode,
    res.OriginatingRegionCode
    

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
    PropertyFundCode,
    OriginatingRegionCode,
    
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


	IF 	OBJECT_ID('tempdb..#AccountCategoryFilterTable') IS NOT NULL
	    DROP TABLE #AccountCategoryFilterTable
	    
	IF 	OBJECT_ID('tempdb..#ActivityTypeFilterTable') IS NOT NULL
	    DROP TABLE #ActivityTypeFilterTable
	    
	IF 	OBJECT_ID('tempdb..#MinorAccountCategoryFilterTable') IS NOT NULL
		DROP TABLE #MinorAccountCategoryFilterTable

	IF 	OBJECT_ID('tempdb..#CategoryActivityGroupFilterTable') IS NOT NULL
		DROP TABLE #CategoryActivityGroupFilterTable

	IF 	OBJECT_ID('tempdb..#ExpenseCzar') IS NOT NULL
	    DROP TABLE #ExpenseCzar
	    
	IF 	OBJECT_ID('tempdb..#Output') IS NOT NULL
		DROP TABLE #Output
GO
/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginatorOwnerFunctionalDepartment]    Script Date: 09/06/2010 12:58:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_R_BudgetOriginatorOwnerFunctionalDepartment]
	@ReportExpensePeriod INT = NULL,
	@ReforecastQuaterName VARCHAR(10) = NULL, --'Q1' or 'Q2' or 'Q3'
	@PreviousReforecastQuaterName VARCHAR(10) ='Q1',
	@DestinationCurrency VARCHAR(3) = NULL,
	@TranslationTypeName VARCHAR(50) = 'Global',
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
	RAISERROR('Filter List parameter is to big',19,1)
	END
	
/*
DECLARE @ReportExpensePeriod		AS INT,
        @FunctionalDepartmentList  AS VARCHAR(8000),
        @DestinationCurrency		AS VARCHAR(3),
        @TranslationTypeName				VARCHAR(50)
				
		
SET @ReportExpensePeriod = 201011
SET @FunctionalDepartmentList = 'Information Technologies'
SET @DestinationCurrency = 'USD'
SET @TranslationTypeName = 'Global'

EXEC stp_R_BudgetOriginatorOwnerFunctionalDepartment
	@ReportExpensePeriod = 201011,
	@TranslationTypeName = 'Global',
	@DestinationCurrency = 'USD',

	@FunctionalDepartmentList = 'Information Technologies',
	@AllocationRegionList = 'CHICAGO',
	@EntityList = 'Aldgate|Centrium (St Cathrine House/Pegasus)'

*/

--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Variable defaults		*/
--------------------------------------------------------------------------

IF @ReportExpensePeriod IS NULL
	SET @ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + REPLACE(STR(MONTH(GETDATE()),2 ),' ','0')AS INT)

IF @DestinationCurrency IS NULL
	SET @DestinationCurrency = 'USD'

IF 	@TranslationTypeName IS NULL
	SET @TranslationTypeName = 'Global'

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
	
IF 	OBJECT_ID('tempdb..#BudgetOriginatorOwner') IS NOT NULL
    DROP TABLE #BudgetOriginatorOwner

CREATE TABLE #BudgetOriginatorOwner
(
	ActivityTypeKey			Int,
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
	PropertyFundCode			Varchar(6) DEFAULT(''), --Varchar, for this helps to keep reports size smaller
	OriginatingRegionCode		Varchar(15) DEFAULT(''), --Varchar, for this helps to keep reports size smaller

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
SET @cmdString = (Select '

INSERT INTO #BudgetOriginatorOwner
SELECT 
	pa.ActivityTypeKey,
	pa.AllocationRegionKey,
	pa.OriginatingRegionKey,
    pa.PropertyFundKey,
    pa.FunctionalDepartmentKey,
	gac.GlAccountCategoryKey,
    s.SourceName,
    CONVERT(varchar(10),ISNULL(pa.EntryDate,''''), 101) as EntryDate,
    ISNULL(pa.[User], '''') [User],
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.Description ELSE '''' END as Description,
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.AdditionalDescription ELSE '''' END as AdditionalDescription,
    ISNULL(pa.PropertyFundCode, '''') PropertyFundCode,
    ISNULL(pa.OriginatingRegionCode, '''') OriginatingRegionCode,
    
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdGrossActual,
	NULL as MtdGrossBudget,
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdGrossReforecast,
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdNetActual,
	NULL as MtdNetBudget,
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdNetReforecast,
	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdGrossActual,
	NULL as YtdGrossBudget,
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as YtdGrossReforecast,
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdNetActual,
	NULL as YtdNetBudget,
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
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
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualGrossReforecast,
	SUM(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@PreviousReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
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
        CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecast,
    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@PreviousReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ1,
	
	SUM(
        er.Rate *
        CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pa.LocalActual
        ELSE 
			0
        END
	) as AnnualEstGrossBudget,
	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecast,

    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstNetReforecast
FROM
	ProfitabilityActual pa

	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = ' + CASE 
			WHEN @TranslationTypeName = 'EU Corporate' THEN 'pa.EUCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Property' THEN 'pa.USPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Fund' THEN 'pa.USFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Property' THEN 'pa.EUPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Corporate' THEN 'pa.USCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Development' THEN 'pa.DevelopmentGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Fund' THEN 'pa.EUFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Global' THEN 'pa.GlobalGlAccountCategoryKey' 
			ELSE 'break:not valid hierarchyname' END + '
			AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')
	
    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pa.CalendarKey
    INNER JOIN Source s ON s.SourceKey = pa.SourceKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pa.ReimbursableKey '
    		
    + CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pa.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pa.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pa.PropertyFundKey' ELSE '' END + '

WHERE  1 = 1
    AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
 	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
 	AND gac.MinorCategoryName <> ''Bonus''
 	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select t1.FunctionalDepartmentKey From #FunctionalDepartmentFilterTable t1)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select t1.ActivityTypeKey From #ActivityTypeFilterTable t1)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select t1.PropertyFundKey From #EntityFilterTable t1)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationRegionFilterTable t1)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationSubRegionFilterTable t1)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MajorAccountCategoryFilterTable t1)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MinorAccountCategoryFilterTable t1)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingRegionFilterTable t1)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingSubRegionFilterTable t1)' END +
'
Group By
	pa.ActivityTypeKey,
	pa.AllocationRegionKey,
	pa.OriginatingRegionKey,
    pa.PropertyFundKey,
    pa.FunctionalDepartmentKey,
	gac.GlAccountCategoryKey,
	s.SourceName,
	CONVERT(varchar(10),ISNULL(pa.EntryDate,''''), 101),
	ISNULL(pa.[User], '''') ,
	CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.Description ELSE '''' END,
	CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.AdditionalDescription ELSE '''' END,
	ISNULL(pa.PropertyFundCode, ''''),
    ISNULL(pa.OriginatingRegionCode, '''')
	
	')
print @cmdString
EXEC (@cmdString)

-- Get budget information
SET @cmdString = (Select '
INSERT INTO #BudgetOriginatorOwner
SELECT 
	pb.ActivityTypeKey,
	pb.AllocationRegionKey,
	pb.OriginatingRegionKey,
    pb.PropertyFundKey,
    pb.FunctionalDepartmentKey,
	gac.GlAccountCategoryKey,
    s.SourceName,
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' as OriginatingRegionCode,
    
    NULL as MtdGrossActual,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as MtdGrossBudget,
	NULL as MtdGrossReforecast,
	
	NULL as MtdNetActual,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as MtdNetBudget,
	NULL as MtdNetReforecast,
	
	NULL as YtdGrossActual,	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as YtdGrossBudget, 
	NULL as YtdGrossReforecast, 
	
	NULL as YtdNetActual, 
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
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
		CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as AnnualEstGrossBudget,
	NULL as AnnualEstGrossReforecast,

	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
	NULL as AnnualEstNetReforecast
FROM
    ProfitabilityBudget pb
    	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = ' + CASE 
			WHEN @TranslationTypeName = 'EU Corporate' THEN 'pb.EUCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Property' THEN 'pb.USPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Fund' THEN 'pb.USFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Property' THEN 'pb.EUPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Corporate' THEN 'pb.USCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Development' THEN 'pb.DevelopmentGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Fund' THEN 'pb.EUFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Global' THEN 'pb.GlobalGlAccountCategoryKey' 
			ELSE 'break:not valid hierarchyname' END + '
			AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')

    INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey 
	INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey    
	INNER JOIN Calendar c ON  c.CalendarKey = pb.CalendarKey
	INNER JOIN Source s ON s.SourceKey = pb.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pb.ReimbursableKey '
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pb.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey' ELSE '' END + '
		
WHERE  1 = 1 
    AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND gac.MinorCategoryName <> ''Bonus''
	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
'
Group By
	pb.ActivityTypeKey,
	pb.AllocationRegionKey,
	pb.OriginatingRegionKey,
    pb.PropertyFundKey,
    pb.FunctionalDepartmentKey,
	gac.GlAccountCategoryKey,
	s.SourceName')

print @cmdString
EXEC (@cmdString)

-- Get reforecast information
SET @cmdString = (Select '
INSERT INTO #BudgetOriginatorOwner
SELECT 
	pr.ActivityTypeKey,
	pr.AllocationRegionKey,
	pr.OriginatingRegionKey,
    pr.PropertyFundKey,
    pr.FunctionalDepartmentKey,
	gac.GlAccountCategoryKey,
    s.SourceName,
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' as OriginatingRegionCode,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	SUM(
		er.Rate * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecast,
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
    SUM(
        er.Rate * r.MultiplicationFactor * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecast,
	
	NULL as YtdGrossActual,	
	NULL as YtdGrossBudget, 
	SUM(
		er.Rate * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecast, 
	
	NULL as YtdNetActual, 
	NULL as YtdNetBudget, 
    SUM(
        er.Rate * r.MultiplicationFactor * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecast,
    
    NULL as AnnualGrossBudget, ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
    'SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecast,
     NULL as AnnualGrossReforecastQ1,

	NULL as AnnualNetBudget, ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
    'SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecast,
    NULL as AnnualNetReforecastQ1,

	NULL as AnnualEstGrossBudget,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don't use the category mapping here like for actual exclude because we want unknowns to come through*/
			'
				 OR (
						LEFT(pr.ReferenceCode,3) = ''BC:''
						AND ' + STR(@ReforecastEffectivePeriod,6,0) + ' IN (201003,201006)
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
        CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don't use the category mapping here like for actual exclude because we want unknowns to come through*/
			'
				 OR (
						LEFT(pr.ReferenceCode,3) = ''BC:''
						AND ' + STR(@ReforecastEffectivePeriod,6,0) + ' IN (201003,201006)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstNetReforecast
FROM
    ProfitabilityReforecast pr
    	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = ' + CASE 
			WHEN @TranslationTypeName = 'EU Corporate' THEN 'pr.EUCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Property' THEN 'pr.USPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Fund' THEN 'pr.USFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Property' THEN 'pr.EUPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Corporate' THEN 'pr.USCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Development' THEN 'pr.DevelopmentGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Fund' THEN 'pr.EUFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Global' THEN 'pr.GlobalGlAccountCategoryKey' 
			ELSE 'break:not valid hierarchyname' END + '
			AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')

    INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey 
	INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey    
	INNER JOIN Calendar c ON  c.CalendarKey = pr.CalendarKey
	INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
	INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey '
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey' ELSE '' END + '
		
WHERE  1 = 1 
	AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
	AND ref.ReforecastEffectivePeriod = ' + STR(@ReforecastEffectivePeriod,6,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND gac.MinorCategoryName <> ''Bonus''
	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
'
Group By
	pr.ActivityTypeKey,
	pr.AllocationRegionKey,
	pr.OriginatingRegionKey,
    pr.PropertyFundKey,
    pr.FunctionalDepartmentKey,
	gac.GlAccountCategoryKey,
	s.SourceName')

print @cmdString
EXEC (@cmdString)

-- Get reforecastQ1 information
SET @cmdString = (Select '
INSERT INTO #BudgetOriginatorOwner
SELECT 
	pr.ActivityTypeKey,
	pr.AllocationRegionKey,
	pr.OriginatingRegionKey,
    pr.PropertyFundKey,
    pr.FunctionalDepartmentKey,
	gac.GlAccountCategoryKey,
    s.SourceName,
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' as OriginatingRegionCode,
    
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
    	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = ' + CASE 
			WHEN @TranslationTypeName = 'EU Corporate' THEN 'pr.EUCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Property' THEN 'pr.USPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Fund' THEN 'pr.USFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Property' THEN 'pr.EUPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Corporate' THEN 'pr.USCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Development' THEN 'pr.DevelopmentGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Fund' THEN 'pr.EUFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Global' THEN 'pr.GlobalGlAccountCategoryKey' 
			ELSE 'break:not valid hierarchyname' END + '
			AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')

    INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey 
	INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey    
	INNER JOIN Calendar c ON  c.CalendarKey = pr.CalendarKey
	INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
	INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey '
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey' ELSE '' END + '
		
WHERE  1 = 1 
	AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
	AND ref.ReforecastEffectivePeriod = ' + STR(@PreviousReforecastEffectivePeriod,6,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND gac.MinorCategoryName <> ''Bonus''
	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
'
Group By
	pr.ActivityTypeKey,
	pr.AllocationRegionKey,
	pr.OriginatingRegionKey,
    pr.PropertyFundKey,
    pr.FunctionalDepartmentKey,
	gac.GlAccountCategoryKey,
	s.SourceName')	

print @cmdString
EXEC (@cmdString)

--Functional Department Mode
SELECT 
	aty.ActivityTypeName,
	aty.ActivityTypeName AS ActivityTypeFilterName,
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
	res.PropertyFundCode,
    res.OriginatingRegionCode,
	
	--Month to date    
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossActual,0) ELSE ISNULL(MtdNetActual,0) END) AS MtdActual,
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossBudget,0) ELSE ISNULL(MtdNetBudget,0) END) AS MtdOriginalBudget,
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast 
		END,0) 
	END) 
	AS MtdReforecast,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast 
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
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
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast 
		END,0) 
	END) 
	AS YtdReforecast,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast 
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) 
	AS YtdVariance,
	
	--Annual
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(AnnualGrossBudget,0) ELSE ISNULL(AnnualNetBudget,0) END) AS AnnualOriginalBudget,	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecast 
		END,0) 
	END) 
	AS AnnualReforecast,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @PreviousReforecastQuaterName = 'Q1' THEN 
			AnnualGrossReforecastQ1 		
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @PreviousReforecastQuaterName = 'Q1' THEN 
			AnnualNetReforecastQ1	
		END,0) 
	END) 
	AS AnnualReforecastQ1
	--Annual Estimated
	--SUM(CASE WHEN (@IsGross = 1) THEN 
	--	ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
	--		AnnualEstGrossBudget 
	--	ELSE 
	--		AnnualEstGrossReforecast 
	--	END,0) 
	--ELSE 
	--	ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
	--		AnnualEstNetBudget 
	--	ELSE 
	--		AnnualEstNetReforecast 
	--	END,0) 
	--END) 
	--AS AnnualEstimatedActual,	
	
	--SUM(CASE WHEN (@IsGross = 1) THEN 
	--	ISNULL(AnnualGrossBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
	--											AnnualEstGrossBudget 
	--										ELSE 
	--											AnnualEstGrossReforecast 
	--										END,0) 
	--	ELSE 
	--		ISNULL(AnnualNetBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
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
		INNER JOIN ActivityType aty ON aty.ActivityTypeKey = res.ActivityTypeKey
GROUP BY
	aty.ActivityTypeName,
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
	res.SourceName,
	res.PropertyFundCode,
    res.OriginatingRegionCode

--Output
SELECT
	ActivityTypeName,
	ActivityTypeFilterName,
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
	PropertyFundCode,
    OriginatingRegionCode,
	
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


IF 	OBJECT_ID('tempdb..#BudgetOriginatorOwner') IS NOT NULL
    DROP TABLE #BudgetOriginatorOwner

IF 	OBJECT_ID('tempdb..#Output') IS NOT NULL
    DROP TABLE #Output
GO
/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginatorOwnerEntity]    Script Date: 09/06/2010 12:58:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_R_BudgetOriginatorOwnerEntity]
	@ReportExpensePeriod INT = NULL,
	@ReforecastQuaterName VARCHAR(10) = NULL, --'Q1' or 'Q2' or 'Q3'
	@PreviousReforecastQuaterName VARCHAR(10) ='Q1',
	@DestinationCurrency VARCHAR(3) = NULL,
	@TranslationTypeName VARCHAR(50) = 'Global',
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
SET @DestinationCurrency = 'USD'
SET @EntityList = 'Aldgate|Centrium (St Cathrine House/Pegasus)'
SET @TranslationTypeName = 'Global'

EXEC stp_R_BudgetOriginatorOwnerEntity
	@ReportExpensePeriod = 201011,
	@TranslationTypeName = 'Global',
	@DestinationCurrency = 'USD',

	@FunctionalDepartmentList = 'Information Technologies',
	@AllocationRegionList = 'CHICAGO',
	@EntityList = 'Aldgate|Centrium (St Cathrine House/Pegasus)'
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
	SET @ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + REPLACE(STR(MONTH(GETDATE()),2 ),' ','0')AS INT)

IF @DestinationCurrency IS NULL
	SET @DestinationCurrency = 'USD'

IF 	@TranslationTypeName IS NULL
	SET @TranslationTypeName = 'Global'

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
	

IF 	OBJECT_ID('tempdb..#BudgetOriginatorOwnerEntity') IS NOT NULL
    DROP TABLE #BudgetOriginatorOwnerEntity

CREATE TABLE #BudgetOriginatorOwnerEntity
(
	ActivityTypeKey				Int,
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
	PropertyFundCode			Varchar(6) DEFAULT(''), --Varchar, for this helps to keep reports size smaller
	OriginatingRegionCode		Varchar(15) DEFAULT(''), --Varchar, for this helps to keep reports size smaller

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
SET @cmdString = (Select '

INSERT INTO #BudgetOriginatorOwnerEntity
SELECT 
	pa.ActivityTypeKey,
    gac.GlAccountCategoryKey,
    pa.AllocationRegionKey,
    pa.OriginatingRegionKey,
    pa.FunctionalDepartmentKey,
    pa.PropertyFundKey,
    s.SourceName,
    CONVERT(varchar(10),ISNULL(pa.EntryDate,''''), 101) as EntryDate,
    ISNULL(pa.[User], '''') [User],
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.Description ELSE '''' END as Description,
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.AdditionalDescription ELSE '''' END as AdditionalDescription,
    ISNULL(pa.PropertyFundCode, '''') PropertyFundCode,
    ISNULL(pa.OriginatingRegionCode, '''') OriginatingRegionCode,
    
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdGrossActual,
	NULL as MtdGrossBudget,
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdGrossReforecast,
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdNetActual,
	NULL as MtdNetBudget,
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) +  
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdNetReforecast,
	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdGrossActual,
	NULL as YtdGrossBudget,
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) +  
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as YtdGrossReforecast,
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdNetActual,
	NULL as YtdNetBudget,
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) +  
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
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
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualGrossReforecast,
	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@PreviousReforecastEffectivePeriod,6,0) + 
                  /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
                  /*Exclude actual... actuals here so we don't double count on the grinder actuals*/
                  ' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
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
        CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecast,
    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@PreviousReforecastEffectivePeriod,6,0) + 
                  /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
                  /*Exclude actual... actuals here so we don't double count on the grinder actuals*/
                  ' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ1,
	
	SUM(
        er.Rate *
        CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pa.LocalActual
        ELSE 
			0
        END
	) as AnnualEstGrossBudget,
	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecast,

    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstNetReforecast
FROM
	ProfitabilityActual pa
	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = ' + CASE 
			WHEN @TranslationTypeName = 'EU Corporate' THEN 'pa.EUCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Property' THEN 'pa.USPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Fund' THEN 'pa.USFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Property' THEN 'pa.EUPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Corporate' THEN 'pa.USCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Development' THEN 'pa.DevelopmentGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Fund' THEN 'pa.EUFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Global' THEN 'pa.GlobalGlAccountCategoryKey' 
			ELSE 'break:not valid hierarchyname' END + '
			AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')
    
    INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
    INNER JOIN Currency dc ON er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON c.CalendarKey = pa.CalendarKey
    INNER JOIN Source s ON s.SourceKey = pa.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pa.ReimbursableKey '
    
    + CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pa.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pa.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pa.PropertyFundKey' ELSE '' END + '

WHERE  1 = 1
    AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select t1.FunctionalDepartmentKey From #FunctionalDepartmentFilterTable t1)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select t1.ActivityTypeKey From #ActivityTypeFilterTable t1)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select t1.PropertyFundKey From #EntityFilterTable t1)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationRegionFilterTable t1)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationSubRegionFilterTable t1)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MajorAccountCategoryFilterTable t1)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MinorAccountCategoryFilterTable t1)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingRegionFilterTable t1)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingSubRegionFilterTable t1)' END +
'
Group by
	pa.ActivityTypeKey,
    gac.GlAccountCategoryKey,
    pa.AllocationRegionKey,
    pa.OriginatingRegionKey,
    pa.FunctionalDepartmentKey,
    pa.PropertyFundKey,
    s.SourceName,
	CONVERT(varchar(10),ISNULL(pa.EntryDate,''''), 101),
	ISNULL(pa.[User], '''') ,
	CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.Description ELSE '''' END,
	CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.AdditionalDescription ELSE '''' END,
	ISNULL(pa.PropertyFundCode, ''''),
    ISNULL(pa.OriginatingRegionCode, '''')
')

print @cmdString
EXEC (@cmdString)

-- Get budget information
SET @cmdString = (Select '
INSERT INTO #BudgetOriginatorOwnerEntity
SELECT 
	pb.ActivityTypeKey,
    gac.GlAccountCategoryKey,
    pb.AllocationRegionKey,
    pb.OriginatingRegionKey,
    pb.FunctionalDepartmentKey,
    pb.PropertyFundKey,
    s.SourceName,
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' as OriginatingRegionCode,
    
    NULL as MtdGrossActual,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as MtdGrossBudget,
	NULL as MtdGrossReforecast,
	
	NULL as MtdNetActual,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as MtdNetBudget,
	NULL as MtdNetReforecast,
	
	NULL as YtdGrossActual,	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as YtdGrossBudget, 
	NULL as YtdGrossReforecast, 
	
	NULL as YtdNetActual, 
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
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
		CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as AnnualEstGrossBudget,
	NULL as AnnualEstGrossReforecast,

	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
	NULL as AnnualEstNetReforecast
FROM
	ProfitabilityBudget pb
	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = ' + CASE 
			WHEN @TranslationTypeName = 'EU Corporate' THEN 'pb.EUCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Property' THEN 'pb.USPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Fund' THEN 'pb.USFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Property' THEN 'pb.EUPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Corporate' THEN 'pb.USCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Development' THEN 'pb.DevelopmentGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Fund' THEN 'pb.EUFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Global' THEN 'pb.GlobalGlAccountCategoryKey' 
			ELSE 'break:not valid hierarchyname' END + '
			AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')

	INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pb.CalendarKey
    INNER JOIN Source s ON s.SourceKey = pb.SourceKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pb.ReimbursableKey '
        
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pb.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey' ELSE '' END + '
	
WHERE  1 = 1 
    AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
 	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
 	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
'
Group By
	pb.ActivityTypeKey,
    gac.GlAccountCategoryKey,
    pb.AllocationRegionKey,
    pb.OriginatingRegionKey,
    pb.FunctionalDepartmentKey,
    pb.PropertyFundKey,
    s.SourceName
')
	
print @cmdString
EXEC (@cmdString)

-- Get reforecast information
SET @cmdString = (Select '
INSERT INTO #BudgetOriginatorOwnerEntity
SELECT
	pr.ActivityTypeKey, 
    gac.GlAccountCategoryKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.FunctionalDepartmentKey,
    pr.PropertyFundKey,
    s.SourceName,
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' as OriginatingRegionCode,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	SUM(
		er.Rate * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecast,
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
    SUM(
        er.Rate * r.MultiplicationFactor * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecast,
	
	NULL as YtdGrossActual,	
	NULL as YtdGrossBudget, 
	SUM(
		er.Rate * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecast, 
	
	NULL as YtdNetActual, 
	NULL as YtdNetBudget, 
    SUM(
        er.Rate * r.MultiplicationFactor * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecast, 
	
	NULL as AnnualGrossBudget,' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
    'SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecast,
    NULL as AnnualGrossReforecastQ1,

	NULL as AnnualNetBudget,' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
    'SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecast,
    NULL as AnnualNetReforecastQ1,

	NULL as AnnualEstGrossBudget,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don't use the category mapping here like for actual exclude because we want unknowns to come through*/
			'
				 OR (
						LEFT(pr.ReferenceCode,3) = ''BC:''
						AND ' + STR(@ReforecastEffectivePeriod,6,0) + ' IN (201003,201006)
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
        CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don't use the category mapping here like for actual exclude because we want unknowns to come through*/
			'
				 OR (
						LEFT(pr.ReferenceCode,3) = ''BC:''
						AND ' + STR(@ReforecastEffectivePeriod,6,0) + ' IN (201003,201006)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstNetReforecast
FROM
	ProfitabilityReforecast pr
	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = ' + CASE 
			WHEN @TranslationTypeName = 'EU Corporate' THEN 'pr.EUCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Property' THEN 'pr.USPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Fund' THEN 'pr.USFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Property' THEN 'pr.EUPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Corporate' THEN 'pr.USCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Development' THEN 'pr.DevelopmentGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Fund' THEN 'pr.EUFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Global' THEN 'pr.GlobalGlAccountCategoryKey' 
			ELSE 'break:not valid hierarchyname' END + '
			AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')

	INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pr.CalendarKey
    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
    INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pr.ReimbursableKey '
        
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey' ELSE '' END + '
	
WHERE  1 = 1 
	AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
	AND ref.ReforecastEffectivePeriod = ' + STR(@ReforecastEffectivePeriod,10,0) + '
 	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
 	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
'
Group By
	pr.ActivityTypeKey,
    gac.GlAccountCategoryKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.FunctionalDepartmentKey,
    pr.PropertyFundKey,
    s.SourceName
')
	
print @cmdString
EXEC (@cmdString)

-- Get reforecastQ1 information
SET @cmdString = (Select '
INSERT INTO #BudgetOriginatorOwnerEntity
SELECT 
	pr.ActivityTypeKey,
    gac.GlAccountCategoryKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.FunctionalDepartmentKey,
    pr.PropertyFundKey,
    s.SourceName,
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' as OriginatingRegionCode,
    
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
	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = ' + CASE 
			WHEN @TranslationTypeName = 'EU Corporate' THEN 'pr.EUCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Property' THEN 'pr.USPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Fund' THEN 'pr.USFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Property' THEN 'pr.EUPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Corporate' THEN 'pr.USCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Development' THEN 'pr.DevelopmentGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Fund' THEN 'pr.EUFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Global' THEN 'pr.GlobalGlAccountCategoryKey' 
			ELSE 'break:not valid hierarchyname' END + '
			AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')

	INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pr.CalendarKey
    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
    INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pr.ReimbursableKey '
        
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey' ELSE '' END + '
	
WHERE  1 = 1 
	AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
	AND ref.ReforecastEffectivePeriod = ' + STR(@PreviousReforecastEffectivePeriod,10,0) + '
 	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
 	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
'
Group By
	pr.ActivityTypeKey,
    gac.GlAccountCategoryKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.FunctionalDepartmentKey,
    pr.PropertyFundKey,
    s.SourceName
')
	
print @cmdString
EXEC (@cmdString)

--Entity Mode
SELECT 
	aty.ActivityTypeName as ActivityTypeName,
	aty.ActivityTypeName as ActivityTypeFilterName,
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
    CASE WHEN (gac.MajorCategoryName = 'Salaries/Taxes/Benefits') THEN 'Payroll' ELSE fd.FunctionalDepartmentName END AS FunctionalDepartmentName,
    gac.MajorCategoryName AS MajorExpenseCategoryName,
    gac.MinorCategoryName AS MinorExpenseCategoryName,
    pf.PropertyFundType AS EntityType,
    pf.PropertyFundName AS EntityName,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
	res.SourceName AS SourceName,
	res.PropertyFundCode,
    res.OriginatingRegionCode,
	
	--Month to date    
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossActual,0) ELSE ISNULL(MtdNetActual,0) END) AS MtdActual,
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossBudget,0) ELSE ISNULL(MtdNetBudget,0) END) AS MtdOriginalBudget,
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast 
		END,0) 
	END) AS MtdReforecast,
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast 
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast 
		END, 0) - ISNULL(MtdNetActual, 0) 
	END) AS MtdVariance,
	--Year to date
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossActual,0) ELSE ISNULL(YtdNetActual,0) END) AS YtdActual,	
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossBudget,0) ELSE ISNULL(YtdNetBudget,0) END) AS YtdOriginalBudget,
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast 
		END,0) 
	END) AS YtdReforecast,
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast 
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) AS YtdVariance,
	--Annual
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(AnnualGrossBudget,0) ELSE ISNULL(AnnualNetBudget,0) END) AS AnnualOriginalBudget,	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecast 
		END,0) 
	END) AS AnnualReforecast,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @PreviousReforecastQuaterName = 'Q1' THEN 
			AnnualGrossReforecastQ1 		
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @PreviousReforecastQuaterName = 'Q1' THEN 
			AnnualNetReforecastQ1	
		END,0) 
	END) 
	AS AnnualReforecastQ1
	--Annual Estimated
	--SUM(CASE WHEN (@IsGross = 1) THEN 
	--	ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
	--		AnnualEstGrossBudget 
	--	ELSE 
	--		AnnualEstGrossReforecast 
	--	END,0) 
	--ELSE 
	--	ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
	--		AnnualEstNetBudget 
	--	ELSE 
	--		AnnualEstNetReforecast 
	--	END,0) 
	--END) AS AnnualEstimatedActual,	
	--SUM(CASE WHEN (@IsGross = 1) THEN 
	--	ISNULL(AnnualGrossBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
	--											AnnualEstGrossBudget 
	--										ELSE 
	--											AnnualEstGrossReforecast 
	--										END,0) 
	--	ELSE 
	--		ISNULL(AnnualNetBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
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
		INNER JOIN ActivityType aty ON aty.ActivityTypeKey = res.ActivityTypeKey
GROUP BY
	aty.ActivityTypeName,
    gac.AccountSubTypeName,
    ar.RegionName,
    ar.SubRegionName,
    orr.RegionName,
    orr.SubRegionName,
    --NB!!!!!!!
    --The roll up to payroll is very sensitive information. It is crutial that information regarding payroll not 
    --get communicated to TS employees.
    CASE WHEN (gac.MajorCategoryName = 'Salaries/Taxes/Benefits') THEN 'Payroll' ELSE fd.FunctionalDepartmentName END,
    gac.MajorCategoryName,
    gac.MinorCategoryName,
    pf.PropertyFundType,
    pf.PropertyFundName,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
    res.SourceName,
    res.PropertyFundCode,
    res.OriginatingRegionCode

--Output
SELECT
	ActivityTypeName,
	ActivityTypeFilterName,
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
	PropertyFundCode,
    OriginatingRegionCode,
	
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

IF 	OBJECT_ID('tempdb..#BudgetOriginatorOwnerEntity') IS NOT NULL
    DROP TABLE #BudgetOriginatorOwnerEntity

IF 	OBJECT_ID('tempdb..#Output') IS NOT NULL
    DROP TABLE #Output
GO
/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginatorJobCodeDetail]    Script Date: 09/06/2010 12:58:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_R_BudgetOriginatorJobCodeDetail]
	@ReportExpensePeriod INT = NULL,
	@ReforecastQuaterName VARCHAR(10) = NULL, --'Q1' or 'Q2' or 'Q3'
	@PreviousReforecastQuaterName VARCHAR(10) ='Q1',
	@DestinationCurrency VARCHAR(3) = NULL,
	@TranslationTypeName VARCHAR(50) = 'Global',
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
SET @FunctionalDepartment = 'Information Technologies'
SET @DestinationCurrency = 'USD'
SET @AllocationRegion = 'CHICAGO'
SET @EntityList = 'Aldgate|Centrium (St Cathrine House/Pegasus)'
SET @TranslationTypeName = 'Global'


EXEC stp_R_BudgetOriginatorJobCodeDetail1
	@ReportExpensePeriod = 201011,
	@TranslationTypeName = 'Global',
	@DestinationCurrency = 'USD',

	@FunctionalDepartmentList = 'Information Technologies',
	@AllocationRegionList = 'CHICAGO',
	@EntityList = 'Aldgate|Centrium (St Cathrine House/Pegasus)'
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
	SET @ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + REPLACE(STR(MONTH(GETDATE()),2 ),' ','0')AS INT)

IF @DestinationCurrency IS NULL
	SET @DestinationCurrency = 'USD'

IF 	@TranslationTypeName IS NULL
	SET @TranslationTypeName = 'Global'

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
	

IF 	OBJECT_ID('tempdb..#BudgetOriginator') IS NOT NULL
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
	PropertyFundCode			Varchar(6) DEFAULT(''), --Varchar, for this helps to keep reports size smaller
	OriginatingRegionCode		Varchar(15) DEFAULT(''), --Varchar, for this helps to keep reports size smaller
	
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
SET @cmdString = (Select '
INSERT INTO #BudgetOriginator
SELECT 
	gac.GlAccountCategoryKey,
    pa.AllocationRegionKey,
    pa.OriginatingRegionKey,
    pa.FunctionalDepartmentKey,
    pa.PropertyFundKey,
    c.CalendarPeriod,
    s.SourceName,
    CONVERT(varchar(10),ISNULL(pa.EntryDate,''''), 101) as EntryDate,
    ISNULL(pa.[User], '''') [User],
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.Description ELSE '''' END as Description,
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.AdditionalDescription ELSE '''' END as AdditionalDescription,
    ISNULL(pa.PropertyFundCode, '''') PropertyFundCode,
    ISNULL(pa.OriginatingRegionCode, '''') OriginatingRegionCode,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdGrossActual,
	NULL as MtdGrossBudget,
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + 
				' AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdGrossReforecast,
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdNetActual,
	NULL as MtdNetBudget,
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + 
		' AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdNetReforecast,
	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdGrossActual,
	NULL as YtdGrossBudget,
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + 
			' AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
		) as YtdGrossReforecast,
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdNetActual,
	NULL as YtdNetBudget,
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
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
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualGrossReforecast,
	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
				 AND c.CalendarPeriod < ' + STR(@PreviousReforecastEffectivePeriod,6,0) + 
                  /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
                  /*Exclude actual... actuals here so we don't double count on the grinder actuals*/
            ' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
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
        CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecast,
    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@PreviousReforecastEffectivePeriod,6,0) + 
                  /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
                  /*Exclude actual... actuals here so we don't double count on the grinder actuals*/
                  ' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ1,
	
	SUM(
        er.Rate *
        CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pa.LocalActual
        ELSE 
			0
        END
	) as AnnualEstGrossBudget,
	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecast,

    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriod,6,0) + ' NOT IN (201003,201006)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstNetReforecast

FROM
	ProfitabilityActual pa

	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = ' + CASE 
			WHEN @TranslationTypeName = 'EU Corporate' THEN 'pa.EUCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Property' THEN 'pa.USPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Fund' THEN 'pa.USFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Property' THEN 'pa.EUPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Corporate' THEN 'pa.USCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Development' THEN 'pa.DevelopmentGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Fund' THEN 'pa.EUFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Global' THEN 'pa.GlobalGlAccountCategoryKey' 
			ELSE 'break:not valid hierarchyname' END + '
			AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')
			
    INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
	INNER JOIN Currency dc ON er.DestinationCurrencyKey = dc.CurrencyKey
	INNER JOIN Calendar c ON c.CalendarKey = pa.CalendarKey
	INNER JOIN Source s ON s.SourceKey = pa.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pa.ReimbursableKey '

    + CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pa.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pa.ActivityTypeKey' ELSE '' END +
    + CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pa.PropertyFundKey' ELSE '' END + '

WHERE  1 = 1
	AND c.CalendarYear = ' + STR(@CalendarYear,4,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select t1.FunctionalDepartmentKey From #FunctionalDepartmentFilterTable t1)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select t1.ActivityTypeKey From #ActivityTypeFilterTable t1)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select t1.PropertyFundKey From #EntityFilterTable t1)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationRegionFilterTable t1)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationSubRegionFilterTable t1)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MajorAccountCategoryFilterTable t1)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MinorAccountCategoryFilterTable t1)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingRegionFilterTable t1)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingSubRegionFilterTable t1)' END +
'
	
	Group By
			gac.GlAccountCategoryKey,
			pa.AllocationRegionKey,
			pa.OriginatingRegionKey,
			pa.FunctionalDepartmentKey,
			pa.PropertyFundKey,
			c.CalendarPeriod,
			s.SourceName,
			CONVERT(varchar(10),ISNULL(pa.EntryDate,''''), 101),
			ISNULL(pa.[User], ''''),
			CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.Description ELSE '''' END,
			CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.AdditionalDescription ELSE '''' END,
			ISNULL(pa.PropertyFundCode, ''''),
			ISNULL(pa.OriginatingRegionCode, '''')
')

print @cmdString
EXEC (@cmdString)

-- Get budget information
SET @cmdString = (Select '
INSERT INTO #BudgetOriginator
SELECT 
	gac.GlAccountCategoryKey,
    pb.AllocationRegionKey,
    pb.OriginatingRegionKey,
    pb.FunctionalDepartmentKey,
    pb.PropertyFundKey,
    c.CalendarPeriod,
    s.SourceName,
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' OriginatingRegionCode,
    
    NULL as MtdGrossActual,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as MtdGrossBudget,
	NULL as MtdGrossReforecast,
	
	NULL as MtdNetActual,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as MtdNetBudget,
	NULL as MtdNetReforecast,
	
	NULL as YtdGrossActual,	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as YtdGrossBudget, 
	NULL as YtdGrossReforecast, 
	
	NULL as YtdNetActual, 
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
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
		CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as AnnualEstGrossBudget,
	NULL as AnnualEstGrossReforecast,

	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
	NULL as AnnualEstNetReforecast
    
FROM
	ProfitabilityBudget pb 
	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = ' + CASE 
			WHEN @TranslationTypeName = 'EU Corporate' THEN 'pb.EUCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Property' THEN 'pb.USPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Fund' THEN 'pb.USFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Property' THEN 'pb.EUPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Corporate' THEN 'pb.USCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Development' THEN 'pb.DevelopmentGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Fund' THEN 'pb.EUFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Global' THEN 'pb.GlobalGlAccountCategoryKey' 
			ELSE 'break:not valid hierarchyname' END + '
			AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')

	INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey
	INNER JOIN Currency dc ON er.DestinationCurrencyKey = dc.CurrencyKey
	INNER JOIN Calendar c ON c.CalendarKey = pb.CalendarKey
	INNER JOIN Source s ON s.SourceKey = pb.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pb.ReimbursableKey '
    			
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pb.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey' ELSE '' END + '
    
WHERE  1 = 1 
	AND c.CalendarYear = ' + STR(@CalendarYear,4,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
'
Group by
    gac.GlAccountCategoryKey,
    pb.AllocationRegionKey,
    pb.OriginatingRegionKey,
    pb.FunctionalDepartmentKey,
    pb.PropertyFundKey,
    c.CalendarPeriod,
    s.SourceName
	
')

print @cmdString
EXEC (@cmdString)

-- Get reforecast information
SET @cmdString = (Select '
INSERT INTO #BudgetOriginator
SELECT 
	gac.GlAccountCategoryKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.FunctionalDepartmentKey,
    pr.PropertyFundKey,
    c.CalendarPeriod,
    s.SourceName,
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' OriginatingRegionCode,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	SUM(
		er.Rate * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecast,
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
    SUM(
        er.Rate * r.MultiplicationFactor * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecast,
	
	NULL as YtdGrossActual,	
	NULL as YtdGrossBudget, 
	SUM(
		er.Rate * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecast, 
	
	NULL as YtdNetActual, 
	NULL as YtdNetBudget, 
    SUM(
        er.Rate * r.MultiplicationFactor * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
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
		CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don't use the category mapping here like for actual exclude because we want unknowns to come through*/
			'
				 OR (
						LEFT(pr.ReferenceCode,3) = ''BC:''
						AND ' + STR(@ReforecastEffectivePeriod,6,0) + ' IN (201003,201006)
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
        CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don't use the category mapping here like for actual exclude because we want unknowns to come through*/
			'
				 OR (
						LEFT(pr.ReferenceCode,3) = ''BC:''
						AND ' + STR(@ReforecastEffectivePeriod,6,0) + ' IN (201003,201006)
					)
				 ) THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstNetReforecast
    
FROM
	ProfitabilityReforecast pr 
	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = ' + CASE 
			WHEN @TranslationTypeName = 'EU Corporate' THEN 'pr.EUCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Property' THEN 'pr.USPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Fund' THEN 'pr.USFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Property' THEN 'pr.EUPropertyGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'US Corporate' THEN 'pr.USCorporateGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Development' THEN 'pr.DevelopmentGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'EU Fund' THEN 'pr.EUFundGlAccountCategoryKey' 
			WHEN @TranslationTypeName = 'Global' THEN 'pr.GlobalGlAccountCategoryKey' 
			ELSE 'break:not valid hierarchyname' END + '
			AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')

	INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
	INNER JOIN Currency dc ON er.DestinationCurrencyKey = dc.CurrencyKey
	INNER JOIN Calendar c ON c.CalendarKey = pr.CalendarKey
	INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
	INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey '
    			
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey' ELSE '' END + '
    
WHERE  1 = 1 
	AND c.CalendarYear = ' + STR(@CalendarYear,4,0) + '
	AND ref.ReforecastEffectivePeriod = ' + STR(@ReforecastEffectivePeriod,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
'
Group by
    gac.GlAccountCategoryKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.FunctionalDepartmentKey,
    pr.PropertyFundKey,
    c.CalendarPeriod,
    s.SourceName
	
')

print @cmdString
EXEC (@cmdString)

-- Get reforecastQ1 information
SET @cmdString = (Select '
INSERT INTO #BudgetOriginator
SELECT 
      gac.GlAccountCategoryKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.FunctionalDepartmentKey,
    pr.PropertyFundKey,
    c.CalendarPeriod,
    s.SourceName,
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' OriginatingRegionCode,
    
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
      
      INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = ' + CASE 
                  WHEN @TranslationTypeName = 'EU Corporate' THEN 'pr.EUCorporateGlAccountCategoryKey' 
                  WHEN @TranslationTypeName = 'US Property' THEN 'pr.USPropertyGlAccountCategoryKey' 
                  WHEN @TranslationTypeName = 'US Fund' THEN 'pr.USFundGlAccountCategoryKey' 
                  WHEN @TranslationTypeName = 'EU Property' THEN 'pr.EUPropertyGlAccountCategoryKey' 
                  WHEN @TranslationTypeName = 'US Corporate' THEN 'pr.USCorporateGlAccountCategoryKey' 
                  WHEN @TranslationTypeName = 'Development' THEN 'pr.DevelopmentGlAccountCategoryKey' 
                  WHEN @TranslationTypeName = 'EU Fund' THEN 'pr.EUFundGlAccountCategoryKey' 
                  WHEN @TranslationTypeName = 'Global' THEN 'pr.GlobalGlAccountCategoryKey' 
                  ELSE 'break:not valid hierarchyname' END + '
                  AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')

      INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
      INNER JOIN Currency dc ON er.DestinationCurrencyKey = dc.CurrencyKey
      INNER JOIN Calendar c ON c.CalendarKey = pr.CalendarKey
      INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
      INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey '
                  
      + CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey' ELSE '' END +
      + CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey' ELSE '' END + '
    
WHERE  1 = 1 
      AND c.CalendarYear = ' + STR(@CalendarYear,4,0) + '
      AND ref.ReforecastEffectivePeriod = ' + STR(@PreviousReforecastEffectivePeriod,10,0) + '
      AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
      AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
'
Group by
    gac.GlAccountCategoryKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.FunctionalDepartmentKey,
    pr.PropertyFundKey,
    c.CalendarPeriod,
    s.SourceName      
')

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
    res.PropertyFundCode PropertyFundCode,
    res.OriginatingRegionCode OriginatingRegionCode,
    
	--Month to date    
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossActual,0) ELSE ISNULL(MtdNetActual,0) END) AS MtdActual,
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossBudget,0) ELSE ISNULL(MtdNetBudget,0) END) AS MtdOriginalBudget,
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast 
		END,0) 
	END) 
	AS MtdReforecast,
		
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast 
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
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
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast 
		END,0) 
	END) 
	AS YtdReforecast,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast 
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) 
	AS YtdVariance,
	
	--Annual
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(AnnualGrossBudget,0) ELSE ISNULL(AnnualNetBudget,0) END) AS AnnualOriginalBudget,	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecast 
		END,0) 
	END) 
	AS AnnualReforecast,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @PreviousReforecastQuaterName = 'Q1' THEN 
			AnnualGrossReforecastQ1 		
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @PreviousReforecastQuaterName = 'Q1' THEN 
			AnnualNetReforecastQ1	
		END,0) 
	END) 
	AS AnnualReforecastQ1
	
	--Annual Estimated
	--SUM(CASE WHEN (@IsGross = 1) THEN 
	--	ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
	--		AnnualEstGrossBudget 
	--	ELSE 
	--		AnnualEstGrossReforecast 
	--	END,0) 
	--ELSE 
	--	ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
	--		AnnualEstNetBudget 
	--	ELSE 
	--		AnnualEstNetReforecast 
	--	END,0) 
	--END) 
	--AS AnnualEstimatedActual,	
	
	--SUM(CASE WHEN (@IsGross = 1) THEN 
	--	ISNULL(AnnualGrossBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
	--											AnnualEstGrossBudget 
	--										ELSE 
	--											AnnualEstGrossReforecast 
	--										END,0) 
	--	ELSE 
	--		ISNULL(AnnualNetBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
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
    res.SourceName,
    res.PropertyFundCode,
    res.OriginatingRegionCode
	
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
    PropertyFundCode,
    OriginatingRegionCode,
    
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
	
IF OBJECT_ID('tempdb..#BudgetOriginator') IS NOT NULL
    DROP TABLE #BudgetOriginator

IF 	OBJECT_ID('tempdb..#Output') IS NOT NULL
    DROP TABLE #Output
GO
USE GrReporting
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.stp_R_UnknownActivityType') AND type in (N'P', N'PC'))
DROP PROCEDURE dbo.stp_R_UnknownActivityType
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.stp_R_UnknownActivityType
@StartPeriod Varchar(6),
@StopPeriod  Varchar(6)
AS

DECLARE @DataPriorToDate DateTime

SET @DataPriorToDate = GETDATE()

CREATE TABLE #Result(
	SourceSystem Varchar(50) NOT NULL,
	SourceTable varchar(50) NOT NULL,
	ActivityTypeName varchar(50) NOT NULL,
	FunctionalDepartmentUnknown varchar(3) NOT NULL,
	OriginatingRegionUnknown varchar(3) NOT NULL,
	GLAccountUnknown varchar(3) NOT NULL,
	GlPeriod char(6) NOT NULL,
	GlRef char(8) NOT NULL,
	GlSource char(2) NOT NULL,
	GlSiteID char(2) NOT NULL,
	GlItem smallint NOT NULL,
	GlEntityID char(7) NOT NULL,
	EntityName varchar(80) NULL,
	GlAccountNumber char(14) NOT NULL,
	GlAccountName varchar(60) NULL,
	PropertyFundCode char(7) NOT NULL,
	DepartmentDescription varchar(50) NULL,
	Jobcode char(15) NULL,
	JobCodeDescription varchar(50) NULL,
	GlAmount money NULL,
	GlDescription char(60) NULL,
	GlEntrDate datetime NULL,
	GlReversal varchar(1) NOT NULL,
	GlStatus varchar(1) NOT NULL,
	GlBasis char(1) NOT NULL,
	GlLastDate datetime NULL,
	GlUser varchar(20) NULL
)

--USProp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.USProp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.USProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.USProp.ENTITY En
					INNER JOIN GrReportingStaging.USProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.USProp.GACC Ga
					INNER JOIN GrReportingStaging.USProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.ActivityTypeKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--USCorp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.USCorp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.USCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.USCorp.ENTITY En
					INNER JOIN GrReportingStaging.USCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.USCorp.GACC Ga
					INNER JOIN GrReportingStaging.USCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.ActivityTypeKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--EUProp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.EUProp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.EUProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.EUProp.ENTITY En
					INNER JOIN GrReportingStaging.EUProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.EUProp.GACC Ga
					INNER JOIN GrReportingStaging.EUProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.ActivityTypeKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--EUCorp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.EUCorp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.EUCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.EUCorp.ENTITY En
					INNER JOIN GrReportingStaging.EUCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.EUCorp.GACC Ga
					INNER JOIN GrReportingStaging.EUCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.ActivityTypeKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod


--INProp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.Ref GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.INProp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.INProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.INProp.ENTITY En
					INNER JOIN GrReportingStaging.INProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.INProp.GACC Ga
					INNER JOIN GrReportingStaging.INProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.ActivityTypeKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--INCorp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.INCorp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.INCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.INCorp.ENTITY En
					INNER JOIN GrReportingStaging.INCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.INCorp.GACC Ga
					INNER JOIN GrReportingStaging.INCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.ActivityTypeKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod


--BRProp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.BRProp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.BRProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.BRProp.ENTITY En
					INNER JOIN GrReportingStaging.BRProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.BRProp.GACC Ga
					INNER JOIN GrReportingStaging.BRProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.ActivityTypeKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--BRCorp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.BRCorp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.BRCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.BRCorp.ENTITY En
					INNER JOIN GrReportingStaging.BRCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.BRCorp.GACC Ga
					INNER JOIN GrReportingStaging.BRCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.ActivityTypeKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod


--CNProp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.CNProp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.CNProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.CNProp.ENTITY En
					INNER JOIN GrReportingStaging.CNProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.CNProp.GACC Ga
					INNER JOIN GrReportingStaging.CNProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.ActivityTypeKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--CNCorp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.CNCorp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.CNCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.CNCorp.ENTITY En
					INNER JOIN GrReportingStaging.CNCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.CNCorp.GACC Ga
					INNER JOIN GrReportingStaging.CNCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.ActivityTypeKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

CREATE CLUSTERED INDEX IX_Clustered ON #Result (SourceSystem, GlPeriod, GlEntrDate)

Select * From #Result ORder By SourceSystem, GlPeriod, GlEntrDate
GO
USE GrReporting
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.stp_R_UnknownFunctionalDepartment') AND type in (N'P', N'PC'))
DROP PROCEDURE dbo.stp_R_UnknownFunctionalDepartment
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.stp_R_UnknownFunctionalDepartment
@StartPeriod Varchar(6),
@StopPeriod  Varchar(6)
AS

DECLARE @DataPriorToDate DateTime

SET @DataPriorToDate = GETDATE()

CREATE TABLE #Result(
	SourceSystem Varchar(50) NOT NULL,
	SourceTable varchar(50) NOT NULL,
	ActivityTypeName varchar(50) NOT NULL,
	FunctionalDepartmentUnknown varchar(3) NOT NULL,
	OriginatingRegionUnknown varchar(3) NOT NULL,
	GLAccountUnknown varchar(3) NOT NULL,
	GlPeriod char(6) NOT NULL,
	GlRef char(8) NOT NULL,
	GlSource char(2) NOT NULL,
	GlSiteID char(2) NOT NULL,
	GlItem smallint NOT NULL,
	GlEntityID char(7) NOT NULL,
	EntityName varchar(80) NULL,
	GlAccountNumber char(14) NOT NULL,
	GlAccountName varchar(60) NULL,
	PropertyFundCode char(7) NOT NULL,
	DepartmentDescription varchar(50) NULL,
	Jobcode char(15) NULL,
	JobCodeDescription varchar(50) NULL,
	GlAmount money NULL,
	GlDescription char(60) NULL,
	GlEntrDate datetime NULL,
	GlReversal varchar(1) NOT NULL,
	GlStatus varchar(1) NOT NULL,
	GlBasis char(1) NOT NULL,
	GlLastDate datetime NULL,
	GlUser varchar(20) NULL
)

--USProp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.USProp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.USProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.USProp.ENTITY En
					INNER JOIN GrReportingStaging.USProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.USProp.GACC Ga
					INNER JOIN GrReportingStaging.USProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.FunctionalDepartmentKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--USCorp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.USCorp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.USCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.USCorp.ENTITY En
					INNER JOIN GrReportingStaging.USCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.USCorp.GACC Ga
					INNER JOIN GrReportingStaging.USCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.FunctionalDepartmentKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--EUProp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.EUProp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.EUProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.EUProp.ENTITY En
					INNER JOIN GrReportingStaging.EUProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.EUProp.GACC Ga
					INNER JOIN GrReportingStaging.EUProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.FunctionalDepartmentKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--EUCorp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.EUCorp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.EUCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.EUCorp.ENTITY En
					INNER JOIN GrReportingStaging.EUCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.EUCorp.GACC Ga
					INNER JOIN GrReportingStaging.EUCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.FunctionalDepartmentKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod


--INProp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.Ref GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.INProp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.INProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.INProp.ENTITY En
					INNER JOIN GrReportingStaging.INProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.INProp.GACC Ga
					INNER JOIN GrReportingStaging.INProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.FunctionalDepartmentKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--INCorp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.INCorp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.INCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.INCorp.ENTITY En
					INNER JOIN GrReportingStaging.INCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.INCorp.GACC Ga
					INNER JOIN GrReportingStaging.INCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.FunctionalDepartmentKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod


--BRProp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.BRProp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.BRProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.BRProp.ENTITY En
					INNER JOIN GrReportingStaging.BRProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.BRProp.GACC Ga
					INNER JOIN GrReportingStaging.BRProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.FunctionalDepartmentKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--BRCorp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.BRCorp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.BRCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.BRCorp.ENTITY En
					INNER JOIN GrReportingStaging.BRCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.BRCorp.GACC Ga
					INNER JOIN GrReportingStaging.BRCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.FunctionalDepartmentKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod


--CNProp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.CNProp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.CNProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.CNProp.ENTITY En
					INNER JOIN GrReportingStaging.CNProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.CNProp.GACC Ga
					INNER JOIN GrReportingStaging.CNProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.FunctionalDepartmentKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--CNCorp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.CNCorp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.CNCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.CNCorp.ENTITY En
					INNER JOIN GrReportingStaging.CNCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.CNCorp.GACC Ga
					INNER JOIN GrReportingStaging.CNCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.FunctionalDepartmentKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

CREATE CLUSTERED INDEX IX_Clustered ON #Result (SourceSystem, GlPeriod, GlEntrDate)

Select * From #Result ORder By SourceSystem, GlPeriod, GlEntrDate 
GO
USE GrReporting
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.stp_R_UnknownGlAccount') AND type in (N'P', N'PC'))
DROP PROCEDURE dbo.stp_R_UnknownGlAccount
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.stp_R_UnknownGlAccount
@StartPeriod Varchar(6),
@StopPeriod  Varchar(6)
AS

DECLARE @DataPriorToDate DateTime

SET @DataPriorToDate = GETDATE()

CREATE TABLE #Result(
	SourceSystem Varchar(50) NOT NULL,
	SourceTable varchar(50) NOT NULL,
	ActivityTypeName varchar(50) NOT NULL,
	FunctionalDepartmentUnknown varchar(3) NOT NULL,
	OriginatingRegionUnknown varchar(3) NOT NULL,
	GLAccountUnknown varchar(3) NOT NULL,
	GlPeriod char(6) NOT NULL,
	GlRef char(8) NOT NULL,
	GlSource char(2) NOT NULL,
	GlSiteID char(2) NOT NULL,
	GlItem smallint NOT NULL,
	GlEntityID char(7) NOT NULL,
	EntityName varchar(80) NULL,
	GlAccountNumber char(14) NOT NULL,
	GlAccountName varchar(60) NULL,
	PropertyFundCode char(7) NOT NULL,
	DepartmentDescription varchar(50) NULL,
	Jobcode char(15) NULL,
	JobCodeDescription varchar(50) NULL,
	GlAmount money NULL,
	GlDescription char(60) NULL,
	GlEntrDate datetime NULL,
	GlReversal varchar(1) NOT NULL,
	GlStatus varchar(1) NOT NULL,
	GlBasis char(1) NOT NULL,
	GlLastDate datetime NULL,
	GlUser varchar(20) NULL
)

--USProp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.USProp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.USProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.USProp.ENTITY En
					INNER JOIN GrReportingStaging.USProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.USProp.GACC Ga
					INNER JOIN GrReportingStaging.USProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.GlAccountKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--USCorp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.USCorp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.USCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.USCorp.ENTITY En
					INNER JOIN GrReportingStaging.USCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.USCorp.GACC Ga
					INNER JOIN GrReportingStaging.USCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.GlAccountKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--EUProp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.EUProp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.EUProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.EUProp.ENTITY En
					INNER JOIN GrReportingStaging.EUProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.EUProp.GACC Ga
					INNER JOIN GrReportingStaging.EUProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.GlAccountKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--EUCorp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.EUCorp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.EUCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.EUCorp.ENTITY En
					INNER JOIN GrReportingStaging.EUCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.EUCorp.GACC Ga
					INNER JOIN GrReportingStaging.EUCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.GlAccountKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod


--INProp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.Ref GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.INProp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.INProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.INProp.ENTITY En
					INNER JOIN GrReportingStaging.INProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.INProp.GACC Ga
					INNER JOIN GrReportingStaging.INProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.GlAccountKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--INCorp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.INCorp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.INCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.INCorp.ENTITY En
					INNER JOIN GrReportingStaging.INCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.INCorp.GACC Ga
					INNER JOIN GrReportingStaging.INCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.GlAccountKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod


--BRProp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.BRProp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.BRProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.BRProp.ENTITY En
					INNER JOIN GrReportingStaging.BRProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.BRProp.GACC Ga
					INNER JOIN GrReportingStaging.BRProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.GlAccountKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--BRCorp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.BRCorp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.BRCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.BRCorp.ENTITY En
					INNER JOIN GrReportingStaging.BRCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.BRCorp.GACC Ga
					INNER JOIN GrReportingStaging.BRCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.GlAccountKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod


--CNProp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.CNProp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.CNProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.CNProp.ENTITY En
					INNER JOIN GrReportingStaging.CNProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.CNProp.GACC Ga
					INNER JOIN GrReportingStaging.CNProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.GlAccountKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--CNCorp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.CNCorp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.CNCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.CNCorp.ENTITY En
					INNER JOIN GrReportingStaging.CNCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.CNCorp.GACC Ga
					INNER JOIN GrReportingStaging.CNCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.GlAccountKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

CREATE CLUSTERED INDEX IX_Clustered ON #Result (SourceSystem, GlPeriod, GlEntrDate)

Select * From #Result ORder By SourceSystem, GlPeriod, GlEntrDate  
GO
USE GrReporting
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.stp_R_UnknownOriginatingRegion') AND type in (N'P', N'PC'))
DROP PROCEDURE dbo.stp_R_UnknownOriginatingRegion
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.stp_R_UnknownOriginatingRegion
@StartPeriod Varchar(6),
@StopPeriod  Varchar(6)
AS

DECLARE @DataPriorToDate DateTime

SET @DataPriorToDate = GETDATE()

CREATE TABLE #Result(
	SourceSystem Varchar(50) NOT NULL,
	SourceTable varchar(50) NOT NULL,
	ActivityTypeName varchar(50) NOT NULL,
	FunctionalDepartmentUnknown varchar(3) NOT NULL,
	OriginatingRegionUnknown varchar(3) NOT NULL,
	GLAccountUnknown varchar(3) NOT NULL,
	GlPeriod char(6) NOT NULL,
	GlRef char(8) NOT NULL,
	GlSource char(2) NOT NULL,
	GlSiteID char(2) NOT NULL,
	GlItem smallint NOT NULL,
	GlEntityID char(7) NOT NULL,
	EntityName varchar(80) NULL,
	GlAccountNumber char(14) NOT NULL,
	GlAccountName varchar(60) NULL,
	PropertyFundCode char(7) NOT NULL,
	DepartmentDescription varchar(50) NULL,
	Jobcode char(15) NULL,
	JobCodeDescription varchar(50) NULL,
	GlAmount money NULL,
	GlDescription char(60) NULL,
	GlEntrDate datetime NULL,
	GlReversal varchar(1) NOT NULL,
	GlStatus varchar(1) NOT NULL,
	GlBasis char(1) NOT NULL,
	GlLastDate datetime NULL,
	GlUser varchar(20) NULL
)

--USProp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.USProp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.USProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.USProp.ENTITY En
					INNER JOIN GrReportingStaging.USProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.USProp.GACC Ga
					INNER JOIN GrReportingStaging.USProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.OriginatingRegionKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--USCorp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.USCorp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.USCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.USCorp.ENTITY En
					INNER JOIN GrReportingStaging.USCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.USCorp.GACC Ga
					INNER JOIN GrReportingStaging.USCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.OriginatingRegionKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--EUProp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.EUProp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.EUProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.EUProp.ENTITY En
					INNER JOIN GrReportingStaging.EUProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.EUProp.GACC Ga
					INNER JOIN GrReportingStaging.EUProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.OriginatingRegionKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--EUCorp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.EUCorp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.EUCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.EUCorp.ENTITY En
					INNER JOIN GrReportingStaging.EUCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.EUCorp.GACC Ga
					INNER JOIN GrReportingStaging.EUCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.OriginatingRegionKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod


--INProp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.Ref GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.INProp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.INProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.INProp.ENTITY En
					INNER JOIN GrReportingStaging.INProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.INProp.GACC Ga
					INNER JOIN GrReportingStaging.INProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.OriginatingRegionKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--INCorp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.INCorp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.INCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.INCorp.ENTITY En
					INNER JOIN GrReportingStaging.INCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.INCorp.GACC Ga
					INNER JOIN GrReportingStaging.INCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.OriginatingRegionKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod


--BRProp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.BRProp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.BRProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.BRProp.ENTITY En
					INNER JOIN GrReportingStaging.BRProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.BRProp.GACC Ga
					INNER JOIN GrReportingStaging.BRProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.OriginatingRegionKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--BRCorp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.BRCorp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.BRCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.BRCorp.ENTITY En
					INNER JOIN GrReportingStaging.BRCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.BRCorp.GACC Ga
					INNER JOIN GrReportingStaging.BRCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.OriginatingRegionKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod


--CNProp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.CNProp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.CNProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.CNProp.ENTITY En
					INNER JOIN GrReportingStaging.CNProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.CNProp.GACC Ga
					INNER JOIN GrReportingStaging.CNProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.OriginatingRegionKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--CNCorp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.CNCorp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.CNCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.CNCorp.ENTITY En
					INNER JOIN GrReportingStaging.CNCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.CNCorp.GACC Ga
					INNER JOIN GrReportingStaging.CNCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
		
	LEFT OUTER JOIN (
				SELECT
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.OriginatingRegionKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

CREATE CLUSTERED INDEX IX_Clustered ON #Result (SourceSystem, GlPeriod, GlEntrDate)

Select * From #Result ORder By SourceSystem, GlPeriod, GlEntrDate   
GO