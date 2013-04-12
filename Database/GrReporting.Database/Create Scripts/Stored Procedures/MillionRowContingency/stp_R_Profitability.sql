USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_Profitability]    Script Date: 04/08/2010 18:01:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_Profitability]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_Profitability]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_Profitability]    Script Date: 12/29/2009 11:20:09 ******/
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
	@OriginatingSubRegionList TEXT = NULL,
	@OverheadCode Varchar(10)='ALLOC'
AS

-- Determines if report includes all data
DECLARE @IsAllReport bit = CASE WHEN 		
		(@FunctionalDepartmentList IS NULL OR CAST(@FunctionalDepartmentList AS VARCHAR(MAX)) = 'Information Technology') AND
		@ActivityTypeList IS NULL AND		
		@EntityList IS NULL AND
		@MajorAccountCategoryList IS NULL AND
		@AllocationRegionList IS NULL AND
		@OriginatingRegionList IS NULL
	THEN 1 ELSE 0 END 

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

IF LEN(@_FunctionalDepartmentList) > 7998 OR
	LEN(@_ActivityTypeList) > 7998 OR
	LEN(@_EntityList) > 7998 OR
	LEN(@_MajorAccountCategoryList) > 7998 OR
	LEN(@_MinorAccountCategoryList) > 7998 OR
	LEN(@_AllocationRegionList) > 7998 OR
	LEN(@_AllocationSubRegionList) > 7998 OR
	LEN(@_OriginatingRegionList) > 7998 OR
	LEN(@_OriginatingSubRegionList) > 7998
BEGIN
	RAISERROR('Filter List parameter is too big',9,1)
END
	
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
	AccountSubTypeName          VARCHAR(50),
	FeeOrExpense				VARCHAR(50),
	MajorCategoryName			VARCHAR(100),
	MinorCategoryName			VARCHAR(100),
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
	GlAccountCode				VARCHAR(50),
	GlAccountName				VARCHAR(150),
	CalendarPeriod				Varchar(6) DEFAULT(''),
	
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
    ga.Code,
    ga.Name,
    c.CalendarPeriod,
	
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

	INNER JOIN Overhead oh ON oh.OverheadKey = pa.OverheadKey
		AND OverHeadCode IN (''UNKNOWN'', ''' + @OverheadCode + ''') -- GC :: Change Control 1

	INNER JOIN GlAccount ga on ga.GlAccountKey = pa.GlAccountKey
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

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR('The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...',9,1)
END

PRINT ('Total dynamic sql statement size: ' + STR(LEN(@cmdString)) + '')

PRINT (@cmdString)
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
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN '''' ELSE ga.Code END,
	CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN '''' ELSE ga.Name END,
	'''' as CalendarPeriod,
	
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

	INNER JOIN Overhead oh ON oh.OverheadKey = pb.OverheadKey
		AND OverHeadCode IN (''UNKNOWN'', ''' + @OverheadCode + ''') -- GC :: Change Control 1
	
	INNER JOIN GlAccount ga on ga.GlAccountKey = pb.GlAccountKey
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

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR('The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...',9,1)
END

PRINT ('Total dynamic sql statement size: ' + STR(LEN(@cmdString)) + '')

PRINT (@cmdString)
EXEC (@cmdString)

--Get reforecast information
SET @cmdString = (SELECT '

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
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN '''' ELSE ga.Code END,
	CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN '''' ELSE ga.Name END,
    '''' as CalendarPeriod,
    
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

	INNER JOIN Overhead oh ON oh.OverheadKey = pr.OverheadKey
		AND OverHeadCode IN (''UNKNOWN'', ''' + @OverheadCode + ''') -- GC :: Change Control 1
	
	INNER JOIN GlAccount ga on ga.GlAccountKey = pr.GlAccountKey
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

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR('The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...',9,1)
END

PRINT ('Total dynamic sql statement size: ' + STR(LEN(@cmdString)) + '')

PRINT (@cmdString)
EXEC (@cmdString)

--Get reforecastQ1 information
SET @cmdString = (SELECT '

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
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN '''' ELSE ga.Code END,
	CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN '''' ELSE ga.Name END,
    '''' as CalendarPeriod,
    
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

	INNER JOIN Overhead oh ON oh.OverheadKey = pr.OverheadKey
		AND OverHeadCode IN (''UNKNOWN'', ''' + @OverheadCode + ''') -- GC :: Change Control 1
	
	INNER JOIN GlAccount ga on ga.GlAccountKey = pr.GlAccountKey
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

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR('The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...',9,1)
END

PRINT ('Total dynamic sql statement size: ' + STR(LEN(@cmdString)) + '')

PRINT (@cmdString)
EXEC (@cmdString)

SELECT 
	AccountSubTypeName AS ExpenseType, 
	FeeOrExpense AS FeeOrExpense,
    MajorCategoryName AS MajorExpenseCategoryName,
    MinorCategoryName AS MinorExpenseCategoryName,
    ActivityTypeName AS ActivityType,
	PropertyFundName AS EntityName,
	AllocationSubRegionName AS AllocationSubRegionName,
	CalendarPeriod AS ActualsExpensePeriod,
    CASE WHEN @IsAllReport = 1 THEN '1900-01-01' ELSE EntryDate END AS EntryDate,
    [User],
    CASE WHEN @IsAllReport = 1 THEN '' ELSE [Description] END AS [Description],
    CASE WHEN @IsAllReport = 1 THEN '' ELSE AdditionalDescription END AS AdditionalDescription,
	SourceName AS SourceName,
	PropertyFundCode,
    OriginatingRegionCode,
	GlAccountCode,
    GlAccountName,

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
    CalendarPeriod,
    CASE WHEN @IsAllReport = 1 THEN '1900-01-01' ELSE EntryDate END,
    [User],
    CASE WHEN @IsAllReport = 1 THEN '' ELSE [Description] END,
    CASE WHEN @IsAllReport = 1 THEN '' ELSE AdditionalDescription END,
    SourceName,
    PropertyFundCode,
    OriginatingRegionCode,
	GlAccountCode,
    GlAccountName
    
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
	ActualsExpensePeriod,
    EntryDate,
    [User],
    [Description],
    AdditionalDescription,
	SourceName AS SourceName,
	PropertyFundCode,
    OriginatingRegionCode,
	GlAccountCode,
	GlAccountName,
	
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

