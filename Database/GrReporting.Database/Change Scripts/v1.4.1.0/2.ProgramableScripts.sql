/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginatorOwnerEntity]    Script Date: 12/21/2009 12:46:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOriginatorOwnerEntity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_BudgetOriginatorOwnerEntity]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginatorOwnerEntity]    Script Date: 12/21/2009 12:46:22 ******/
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
    pa.[User],
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.Description ELSE '''' END as Description,
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.AdditionalDescription ELSE '''' END as AdditionalDescription,
    
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
	pa.[User],
	CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.Description ELSE '''' END,
	CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.AdditionalDescription ELSE '''' END

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
    res.SourceName

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


 