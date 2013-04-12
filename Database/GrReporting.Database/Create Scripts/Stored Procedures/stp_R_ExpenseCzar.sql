USE [GrReporting]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzar]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ExpenseCzar]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************************************************************
Description
	The stored procedure is used for generating the data for the Expense Czar Expense Type report.
	[This report is no longer used in GRP].
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-07-08		: PKayongo	:	Sensitized payroll data for the MRI Source, Originating Region and Property
											Fund fields. (CC20)
			2011-07-18		: PKayongo	:	The Expense Czar Expense Type report is no longer used in GRP.
			
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_R_ExpenseCzar]
	@ReportExpensePeriod INT = NULL,
	@ReforecastQuaterName VARCHAR(10) = NULL, --'Q1' or 'Q2' or 'Q3'
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
	@CategoryActivityGroups dbo.CategoryActivityGroup READONLY,
	@OverheadCode Varchar(10)='UNALLOC'
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
	SET @ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + CAST(MONTH(GETDATE()) AS VARCHAR(2))AS INT)

IF @DestinationCurrency IS NULL
	SET @DestinationCurrency = 'USD'

IF 	@TranslationTypeName IS NULL
	SET @TranslationTypeName = 'Global'

	DECLARE @CalendarYear AS INT
	SET @CalendarYear = CAST(SUBSTRING(CAST(@ReportExpensePeriod AS VARCHAR(10)), 1, 4) AS INT)		

--------------------------------------------------------------------------

-- Determine the ReforecastKey of the reforecast that is currently active (i.e.: 2011 Q1, 2011 Q2, 2012 Q0 etc)
DECLARE @ActiveReforecastKey INT = (SELECT ReforecastKey FROM dbo.GetCurrentReforecastRecord())

IF (@ActiveReforecastKey IS NULL) -- Safeguard against NULL ReforecastKey returned from previous statement
BEGIN
	SET @ActiveReforecastKey = (SELECT MAX(ReforecastKey) FROM dbo.ExchangeRate)
	PRINT ('Near disaster: @ActiveReforecastKey is NULL, so reverting to the largest/most recent ReforecastKey in dbo.ExchangeRate: ' + @ActiveReforecastKey)
END

--------------------------------------------------------------------------

-- let latest reforecast (it will be zero if there is no data for the reforecast)
IF @ReforecastQuaterName IS NULL OR @ReforecastQuaterName NOT IN ('Q0', 'Q1', 'Q2', 'Q3')
	SET @ReforecastQuaterName = (SELECT TOP 1 ReforecastQuarterName 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
										  ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
									ORDER BY ReforecastEffectivePeriod DESC)

-- Compute Reforecast Effective Periods

DECLARE @ReforecastEffectivePeriodQ1 INT
DECLARE @ReforecastEffectivePeriodQ2 INT
DECLARE @ReforecastEffectivePeriodQ3 INT

SET @ReforecastEffectivePeriodQ1 = (SELECT TOP 1
										ReforecastEffectivePeriod 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										ReforecastQuarterName = 'Q1'
									ORDER BY
										ReforecastEffectivePeriod)								

SET @ReforecastEffectivePeriodQ2 = (SELECT TOP 1
										ReforecastEffectivePeriod 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										ReforecastQuarterName = 'Q2'
									ORDER BY
										ReforecastEffectivePeriod)								

SET @ReforecastEffectivePeriodQ3 = (SELECT TOP 1
										ReforecastEffectivePeriod 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										ReforecastQuarterName = 'Q3'
									ORDER BY
										ReforecastEffectivePeriod)

-- Retrieve Reforecast Quarter Name

DECLARE @ReforecastQuarterNameQ1 CHAR(2)
DECLARE @ReforecastQuarterNameQ2 CHAR(2)
DECLARE @ReforecastQuarterNameQ3 CHAR(2)

IF (@ReforecastEffectivePeriodQ1 IS NOT NULL)
BEGIN
	SET @ReforecastQuarterNameQ1 = (SELECT TOP 1
										ReforecastQuarterName 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectivePeriod = @ReforecastEffectivePeriodQ1)
END
ELSE
BEGIN
	PRINT ('@ReforecastEffectivePeriodQ1 is NULL - cannot determine Q1 reforecast quarter name.')
END


IF (@ReforecastEffectivePeriodQ2 IS NOT NULL)
BEGIN
	SET @ReforecastQuarterNameQ2 = (SELECT TOP 1
											ReforecastQuarterName 
										FROM
											dbo.Reforecast 
										WHERE
											ReforecastEffectivePeriod = @ReforecastEffectivePeriodQ2)
END
ELSE
BEGIN
	PRINT ('@ReforecastEffectivePeriodQ2 is NULL - cannot determine Q2 reforecast quarter name.')
END


IF (@ReforecastEffectivePeriodQ3 IS NOT NULL)
BEGIN
	SET @ReforecastQuarterNameQ3 = (SELECT TOP 1
											ReforecastQuarterName 
										FROM
											dbo.Reforecast 
										WHERE
											ReforecastEffectivePeriod = @ReforecastEffectivePeriodQ3)
END
ELSE
BEGIN
	PRINT ('@ReforecastEffectivePeriodQ3 is NULL - cannot determine Q3 reforecast quarter name.')
END

--------------------------------------------------------------------------
/*	Determine Report Exchange Rates	*/
--------------------------------------------------------------------------

SELECT
	SourceCurrencyKey,
	DestinationCurrencyKey,
	CalendarKey,
	Rate
INTO
	#ExchangeRate
FROM
	dbo.ExchangeRate
WHERE
	ReforecastKey = @ActiveReforecastKey -- We will use the exchange rate set that is active for the current reforecast.


--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Tables		*/
--------------------------------------------------------------------------
	
CREATE TABLE #EntityFilterTable	(PropertyFundKey Int NOT NULL)
CREATE TABLE #FunctionalDepartmentFilterTable (FunctionalDepartmentKey Int NOT NULL)
CREATE TABLE #ActivityTypeFilterTable (ActivityTypeKey Int NOT NULL)
CREATE TABLE #AllocationRegionFilterTable (AllocationRegionKey Int NOT NULL)
CREATE TABLE #AllocationSubRegionFilterTable (AllocationRegionKey Int NOT NULL)
CREATE TABLE #MajorAccountCategoryFilterTable (GlAccountCategoryKey Int NOT NULL)	
CREATE TABLE #MinorAccountCategoryFilterTable (GlAccountCategoryKey Int NOT NULL)	
CREATE TABLE #OriginatingRegionFilterTable (OriginatingRegionKey Int NOT NULL)
CREATE TABLE #OriginatingSubRegionFilterTable (OriginatingRegionKey Int NOT NULL)	
CREATE TABLE #CategoryActivityGroupFilterTable (GlAccountCategoryKey Int NOT NULL, ActivityTypeKey Int NULL)	
	
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable (PropertyFundKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable (ActivityTypeKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationRegionFilterTable	(AllocationRegionKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable (AllocationRegionKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MajorAccountCategoryFilterTable (GlAccountCategoryKey)	
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MinorAccountCategoryFilterTable (GlAccountCategoryKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingRegionFilterTable (OriginatingRegionKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable (OriginatingRegionKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #CategoryActivityGroupFilterTable (GlAccountCategoryKey, ActivityTypeKey)
	
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
	OriginatingRegionCode		Varchar(30) DEFAULT(''), --Varchar, for this helps to keep reports size smaller
	OriginatingRegionName		Varchar(50) DEFAULT(''),
	FunctionalDepartmentCode	Varchar(15) DEFAULT(''),
	GlAccountKey				Int  NULL,
	
	--Month to date	
	MtdGrossActual				MONEY,
	MtdGrossBudget				MONEY,
	
	MtdGrossReforecastQ1		MONEY,
	MtdGrossReforecastQ2		MONEY,
	MtdGrossReforecastQ3		MONEY,
	
	MtdNetActual				MONEY,
	MtdNetBudget				MONEY,
	
	MtdNetReforecastQ1			MONEY,
	MtdNetReforecastQ2			MONEY,
	MtdNetReforecastQ3			MONEY,
	
	--Year to date
	YtdGrossActual				MONEY,	
	YtdGrossBudget				MONEY,
	 
	YtdGrossReforecastQ1		MONEY,
	YtdGrossReforecastQ2		MONEY,
	YtdGrossReforecastQ3		MONEY,
	
	YtdNetActual				MONEY, 
	YtdNetBudget				MONEY, 
	
	YtdNetReforecastQ1			MONEY,
	YtdNetReforecastQ2			MONEY,
	YtdNetReforecastQ3			MONEY,

	--Annual	
	AnnualGrossBudget			MONEY,
	
	AnnualGrossReforecastQ1		MONEY,
	AnnualGrossReforecastQ2		MONEY,
	AnnualGrossReforecastQ3		MONEY,
	
	AnnualNetBudget				MONEY,
	
	AnnualNetReforecastQ1		MONEY,
	AnnualNetReforecastQ2		MONEY,
	AnnualNetReforecastQ3		MONEY,
	
	--Annual estimated
	AnnualEstGrossBudget		MONEY,
	
	AnnualEstGrossReforecastQ1	MONEY,
	AnnualEstGrossReforecastQ2	MONEY,
	AnnualEstGrossReforecastQ3	MONEY,
	
	AnnualEstNetBudget			MONEY,
	
	AnnualEstNetReforecastQ1	MONEY,
	AnnualEstNetReforecastQ2	MONEY,
	AnnualEstNetReforecastQ3	MONEY
)

DECLARE @cmdString VARCHAR(8000)

--Get actual information
SET @cmdString = (SELECT '

INSERT INTO #ExpenseCzar
SELECT 
	gac.GlAccountCategoryKey,
	pa.AllocationRegionKey,
    pa.FunctionalDepartmentKey,    
    pa.PropertyFundKey,
    c.CalendarPeriod,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN '''' ELSE s.SourceName END,
    CONVERT(varchar(10),ISNULL(pa.EntryDate,''''), 101) as EntryDate,
    ISNULL(pa.[User], '''') [User],
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.Description ELSE '''' END as Description,
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.AdditionalDescription ELSE '''' END as AdditionalDescription,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN '''' ELSE ISNULL(pa.PropertyFundCode, '''') END PropertyFundCode,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN '''' ELSE ISNULL(pa.OriginatingRegionCode, '''') END OriginatingRegionCode,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN '''' ELSE ISNULL(Oreg.SubRegionName, '''') END OriginatingRegionName,
    ISNULL(pa.FunctionalDepartmentCode, '''') FunctionalDepartmentCode,
    pa.GlAccountKey,
    
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdGrossActual,
	NULL as MtdGrossBudget,
	
	' + /*-- MtdGrossReforecast --------------------------*/ + '
	
	NULL as MtdGrossReforecastQ1,
	NULL as MtdGrossReforecastQ2,
	NULL as MtdGrossReforecastQ3,
	
	' + /*-- MtdGrossReforecast End --------------------------*/ + '
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdNetActual,
	NULL as MtdNetBudget,
	
	' + /*-- MtdNetReforecast --------------------------*/ + '
	
	NULL as MtdNetReforecastQ1,
	NULL as MtdNetReforecastQ2,
	NULL as MtdNetReforecastQ3,
	
	' + /*-- MtdNetReforecast End --------------------------*/ + '
	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdGrossActual,
	NULL as YtdGrossBudget,
	
	')
	
	DECLARE @cmdString2 VARCHAR(8000)
	SET @cmdString2 = (SELECT '
	
	
	' + /*-- YtdGrossReforecast --------------------------*/ + '
	
	NULL as YtdGrossReforecastQ1,
	NULL as YtdGrossReforecastQ2,
	NULL as YtdGrossReforecastQ3,

	' + /*-- YtdGrossReforecast End --------------------------*/ + '
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdNetActual,
	NULL as YtdNetBudget,
	
	' + /*-- YtdNetReforecast --------------------------*/ + '
	
	NULL as YtdNetReforecastQ1,
	NULL as YtdNetReforecastQ2,
	NULL as YtdNetReforecastQ3,
	
	' + /*-- YtdNetReforecast End --------------------------*/ + '
	
	NULL as AnnualGrossBudget,
	
	' + /*-- AnnualGrossReforecast --------------------------*/ + '
	
	NULL as AnnualGrossReforecastQ1,
	NULL as AnnualGrossReforecastQ2,
	NULL as AnnualGrossReforecastQ3,

	' + /*-- AnnualGrossReforecast End --------------------------*/ + '

	NULL as AnnualNetBudget,
	
	' + /*-- AnnualNetReforecast --------------------------*/ + '
	
    NULL as AnnualNetReforecastQ1,
    NULL as AnnualNetReforecastQ2,
    NULL as AnnualNetReforecastQ3,
	
	' + /*-- AnnualNetReforecast End --------------------------*/ + '
		
	SUM(
        er.Rate *
        CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pa.LocalActual
        ELSE 
			0
        END
	) as AnnualEstGrossBudget,
	
	' + /*-- AnnualEstGrossReforecast --------------------------*/ + '
	
	NULL as AnnualEstGrossReforecastQ1,
	NULL as AnnualEstGrossReforecastQ2,
	NULL as AnnualEstGrossReforecastQ3,

	')
	
	DECLARE @cmdString3 VARCHAR(8000)
	SET @cmdString3 = (SELECT '


	' + /*-- AnnualEstGrossReforecast End --------------------------*/ + '

    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
    
    ' + /*-- AnnualEstNetReforecast End --------------------------*/ + '
    
	NULL as AnnualEstNetReforecastQ1,
	NULL as AnnualEstNetReforecastQ2,
	NULL as AnnualEstNetReforecastQ3
	
	' + /*-- AnnualEstNetReforecast End --------------------------*/ + '
FROM
	ProfitabilityActual pa

	INNER JOIN Overhead oh ON oh.OverheadKey = pa.OverheadKey
		AND OverHeadCode IN (''UNKNOWN'', ''' + @OverheadCode + ''') -- GC :: Change Control 1

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

    INNER JOIN #ExchangeRate er ON  er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
	INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
	INNER JOIN Calendar c ON  c.CalendarKey = pa.CalendarKey
	INNER JOIN Source s ON s.SourceKey = pa.SourceKey
	INNER JOIN OriginatingRegion Oreg ON Oreg.OriginatingRegionKey = pa.OriginatingRegionKey
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
GROUP BY
	gac.GlAccountCategoryKey,
	pa.AllocationRegionKey,
	pa.FunctionalDepartmentKey,		
	pa.PropertyFundKey,
	c.CalendarPeriod,
	CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN '''' ELSE s.SourceName END,
	CONVERT(varchar(10),ISNULL(pa.EntryDate,''''), 101),
	ISNULL(pa.[User], '''') ,
	CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.Description ELSE '''' END,
	CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.AdditionalDescription ELSE '''' END,
	CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN '''' ELSE ISNULL(pa.PropertyFundCode, '''') END,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN '''' ELSE ISNULL(pa.OriginatingRegionCode, '''') END,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN '''' ELSE ISNULL(Oreg.SubRegionName, '''') END,
	ISNULL(pa.FunctionalDepartmentCode, ''''),
	pa.GlAccountKey
')

IF (LEN(@cmdString) > 7995 OR LEN(@cmdString2) > 7995 OR LEN(@cmdString3) > 7995)
BEGIN
	RAISERROR('The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...',9,1)
END

PRINT ('Total dynamic sql statement size: ' + STR(LTRIM(RTRIM(LEN(@cmdString)))) + ' + ' + STR(LTRIM(RTRIM(LEN(@cmdString2)))) + ' + ' + STR(LTRIM(RTRIM(LEN(@cmdString3)))))

PRINT @cmdString
PRINT @cmdString2
PRINT @cmdString3

EXEC (@cmdString + @cmdString2 + @cmdString3)

-- Get budget information
SET @cmdString = (Select '
INSERT INTO #ExpenseCzar
SELECT 
	gac.GlAccountCategoryKey,
	pb.AllocationRegionKey,
	pb.FunctionalDepartmentKey,	
	pb.PropertyFundKey,
	c.CalendarPeriod,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN '''' ELSE s.SourceName END,
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' as OriginatingRegionCode,
    '''' as OriginatingRegionName,
    '''' as FunctionalDepartmentCode,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN NULL ELSE pb.GlAccountKey END,
    
   NULL as MtdGrossActual,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as MtdGrossBudget,	
	NULL as MtdGrossReforecastQ1,
	NULL as MtdGrossReforecastQ2,
	NULL as MtdGrossReforecastQ3,
	
	NULL as MtdNetActual,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as MtdNetBudget,
	NULL as MtdNetReforecastQ1,
	NULL as MtdNetReforecastQ2,
	NULL as MtdNetReforecastQ3,
	
	NULL as YtdGrossActual,	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as YtdGrossBudget, 
	NULL as YtdGrossReforecastQ1,
	NULL as YtdGrossReforecastQ2,
	NULL as YtdGrossReforecastQ3,
	
	NULL as YtdNetActual, 
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as YtdNetBudget, 
	NULL as YtdNetReforecastQ1,
	NULL as YtdNetReforecastQ2,
	NULL as YtdNetReforecastQ3,
	
	SUM(er.Rate * pb.LocalBudget) as AnnualGrossBudget,
	NULL as AnnualGrossReforecastQ1,
	NULL as AnnualGrossReforecastQ2,
	NULL as AnnualGrossReforecastQ3,
	

	SUM(er.Rate * r.MultiplicationFactor * pb.LocalBudget) as AnnualNetBudget,
	NULL as AnnualNetReforecastQ1,
	NULL as AnnualNetReforecastQ2,
	NULL as AnnualNetReforecastQ3,
	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as AnnualEstGrossBudget,
	NULL as AnnualEstGrossReforecastQ1,
	NULL as AnnualEstGrossReforecastQ2,
	NULL as AnnualEstGrossReforecastQ3,

	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
	NULL as AnnualEstNetReforecastQ1,
	NULL as AnnualEstNetReforecastQ2,
	NULL as AnnualEstNetReforecastQ3
FROM
	ProfitabilityBudget pb

	INNER JOIN Overhead oh ON oh.OverheadKey = pb.OverheadKey
		AND OverHeadCode IN (''UNKNOWN'', ''' + @OverheadCode + ''') -- GC :: Change Control 1
    
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

    INNER JOIN #ExchangeRate er ON  er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey
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
GROUP BY
	gac.GlAccountCategoryKey,
	pb.AllocationRegionKey,
	pb.FunctionalDepartmentKey,
	pb.PropertyFundKey,
	c.CalendarPeriod,
	CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN '''' ELSE s.SourceName END,
	CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN NULL ELSE pb.GlAccountKey END
')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR('The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...',9,1)
END

PRINT ('Total dynamic sql statement size: ' + STR(LEN(@cmdString)) + '')

PRINT @cmdString
EXEC (@cmdString)

----------------------------------------------------------------------------------------------------------------------------------
-- Get Q1 reforecast information
SET @cmdString = (SELECT '
INSERT INTO #ExpenseCzar
SELECT 
	gac.GlAccountCategoryKey,
	pr.AllocationRegionKey,
	pr.FunctionalDepartmentKey,	
	pr.PropertyFundKey,
	c.CalendarPeriod,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN '''' ELSE s.SourceName END,
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' as OriginatingRegionCode,
    '''' as OriginatingRegionName,
    '''' as FunctionalDepartmentCode,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN NULL ELSE pr.GlAccountKey END,
    
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
	) as MtdGrossReforecastQ1,
	NULL as MtdGrossReforecastQ2,
	NULL as MtdGrossReforecastQ3,
	
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
    ) as MtdNetReforecastQ1,
	NULL as MtdNetReforecastQ2,
	NULL as MtdNetReforecastQ3,
	
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
	) as YtdGrossReforecastQ1,
	NULL as YtdGrossReforecastQ2,
	NULL as YtdGrossReforecastQ3,
	
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
    ) as YtdNetReforecastQ1,
    NULL as YtdNetReforecastQ2,
    NULL as YtdNetReforecastQ3,
	
	NULL as AnnualGrossBudget, ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
    'SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ1,
    NULL as AnnualGrossReforecastQ2,
	NULL as AnnualGrossReforecastQ3,

	NULL as AnnualNetBudget, ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
    'SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast) as AnnualNetReforecastQ1,
    NULL as AnnualNetReforecastQ2,
    NULL as AnnualNetReforecastQ3,

	NULL as AnnualEstGrossBudget,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don't use the category mapping here like for actual exclude because we want unknowns to come through*/
			'
				 OR (
						LEFT(pr.ReferenceCode,3) = ''BC:''
						AND ' + STR(@ReforecastEffectivePeriodQ1,6,0) + ' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstGrossReforecastQ1,
    NULL as AnnualEstGrossReforecastQ2,
    NULL as AnnualEstGrossReforecastQ3,

	NULL as AnnualEstNetBudget,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don't use the category mapping here like for actual exclude because we want unknowns to come through*/
			'
				 OR (
						LEFT(pr.ReferenceCode,3) = ''BC:''
						AND ' + STR(@ReforecastEffectivePeriodQ1,6,0) + ' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE
			0
        END
    ) as AnnualEstNetReforecastQ1,
    NULL as AnnualEstNetReforecastQ2,
    NULL as AnnualEstNetReforecastQ3
    
FROM
	ProfitabilityReforecast pr

	INNER JOIN Overhead oh ON oh.OverheadKey = pr.OverheadKey
		AND OverHeadCode IN (''UNKNOWN'', ''' + @OverheadCode + ''') -- GC :: Change Control 1
    
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

    INNER JOIN #ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
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
	AND ref.ReforecastEffectivePeriod = ' + STR(@ReforecastEffectivePeriodQ1,10,0) + '
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
GROUP BY
	gac.GlAccountCategoryKey,
	pr.AllocationRegionKey,
	pr.FunctionalDepartmentKey,			
	pr.PropertyFundKey,
	c.CalendarPeriod,
	CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN '''' ELSE s.SourceName END,
	CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN NULL ELSE pr.GlAccountKey END
')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR('The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...',9,1)
END

PRINT ('Total dynamic sql statement size: ' + STR(LEN(@cmdString)) + '')

PRINT @cmdString
EXEC (@cmdString)

----------------------------------------------------------------------------------------------------------------------------------
-- Get Q2 reforecast information
SET @cmdString = (SELECT '
INSERT INTO #ExpenseCzar
SELECT 
	gac.GlAccountCategoryKey,
	pr.AllocationRegionKey,
	pr.FunctionalDepartmentKey,	
	pr.PropertyFundKey,
	c.CalendarPeriod,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN '''' ELSE s.SourceName END,
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' as OriginatingRegionCode,
    '''' as OriginatingRegionName,
    '''' as FunctionalDepartmentCode,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN NULL ELSE pr.GlAccountKey END,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	
	NULL as MtdGrossReforecastQ1,
	SUM(
		er.Rate * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecastQ2,
	NULL as MtdGrossReforecastQ3,
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
	
	NULL as MtdNetReforecastQ1,
    SUM(
        er.Rate * r.MultiplicationFactor * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecastQ2,
	NULL as MtdNetReforecastQ3,
	
	NULL as YtdGrossActual,	
	NULL as YtdGrossBudget,
	
	NULL as YtdGrossReforecastQ1,
	SUM(
		er.Rate * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecastQ2,
	NULL as YtdGrossReforecastQ3,
	
	NULL as YtdNetActual, 
	NULL as YtdNetBudget,
	
	NULL as YtdNetReforecastQ1,
    SUM(
        er.Rate * r.MultiplicationFactor * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecastQ2,
    NULL as YtdNetReforecastQ3,
	
	NULL as AnnualGrossBudget, ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
    '
    NULL as AnnualGrossReforecastQ1,
    SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ2,
	NULL as AnnualGrossReforecastQ3,

	NULL as AnnualNetBudget, ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
    '
    NULL as AnnualNetReforecastQ1,
    SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast) as AnnualNetReforecastQ2,
    NULL as AnnualNetReforecastQ3,

	NULL as AnnualEstGrossBudget,
	
	NULL as AnnualEstGrossReforecastQ1,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don't use the category mapping here like for actual exclude because we want unknowns to come through*/
			'
				 OR (
						LEFT(pr.ReferenceCode,3) = ''BC:''
						AND ' + STR(@ReforecastEffectivePeriodQ2,6,0) + ' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstGrossReforecastQ2,
    NULL as AnnualEstGrossReforecastQ3,

	NULL as AnnualEstNetBudget,
	NULL as AnnualEstNetReforecastQ1,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don't use the category mapping here like for actual exclude because we want unknowns to come through*/
			'
				 OR (
						LEFT(pr.ReferenceCode,3) = ''BC:''
						AND ' + STR(@ReforecastEffectivePeriodQ2,6,0) + ' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE
			0
        END
    ) as AnnualEstNetReforecastQ2,
    NULL as AnnualEstNetReforecastQ3
    
FROM
	ProfitabilityReforecast pr

	INNER JOIN Overhead oh ON oh.OverheadKey = pr.OverheadKey
		AND OverHeadCode IN (''UNKNOWN'', ''' + @OverheadCode + ''') -- GC :: Change Control 1
    
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

    INNER JOIN #ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
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
	AND ref.ReforecastEffectivePeriod = ' + STR(@ReforecastEffectivePeriodQ2,10,0) + '
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
GROUP BY
	gac.GlAccountCategoryKey,
	pr.AllocationRegionKey,
	pr.FunctionalDepartmentKey,			
	pr.PropertyFundKey,
	c.CalendarPeriod,
	CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN '''' ELSE s.SourceName END,
	CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN NULL ELSE pr.GlAccountKey END
')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR('The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...',9,1)
END

PRINT ('Total dynamic sql statement size: ' + STR(LEN(@cmdString)) + '')

PRINT @cmdString
EXEC (@cmdString)



----------------------------------------------------------------------------------------------------------------------------------
-- Get Q3 reforecast information
SET @cmdString = (SELECT '
INSERT INTO #ExpenseCzar
SELECT 
	gac.GlAccountCategoryKey,
	pr.AllocationRegionKey,
	pr.FunctionalDepartmentKey,	
	pr.PropertyFundKey,
	c.CalendarPeriod,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN '''' ELSE s.SourceName END,
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' as OriginatingRegionCode,
    '''' as OriginatingRegionName,
    '''' as FunctionalDepartmentCode,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN NULL ELSE pr.GlAccountKey END,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	
	NULL as MtdGrossReforecastQ1,
	NULL as MtdGrossReforecastQ2,
	SUM(
		er.Rate * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecastQ3,
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
	
	NULL as MtdNetReforecastQ1,
	NULL as MtdNetReforecastQ2,
    SUM(
        er.Rate * r.MultiplicationFactor * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecastQ3,
	
	NULL as YtdGrossActual,	
	NULL as YtdGrossBudget,
	
	NULL as YtdGrossReforecastQ1,
	NULL as YtdGrossReforecastQ2,
	SUM(
		er.Rate * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecastQ3,
	
	NULL as YtdNetActual, 
	NULL as YtdNetBudget,
	
	NULL as YtdNetReforecastQ1,
	NULL as YtdNetReforecastQ2,
    SUM(
        er.Rate * r.MultiplicationFactor * ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        'CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecastQ3,
	
	NULL as AnnualGrossBudget, ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
    '
    NULL as AnnualGrossReforecastQ1,
    NULL as AnnualGrossReforecastQ2,
    SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ3,

	NULL as AnnualNetBudget, ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
    '
    NULL as AnnualNetReforecastQ1,
    NULL as AnnualNetReforecastQ2,    
    SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast) as AnnualNetReforecastQ3,

	NULL as AnnualEstGrossBudget,
	
	NULL as AnnualEstGrossReforecastQ1,
	NULL as AnnualEstGrossReforecastQ2,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don't use the category mapping here like for actual exclude because we want unknowns to come through*/
			'
				 OR (
						LEFT(pr.ReferenceCode,3) = ''BC:''
						AND ' + STR(@ReforecastEffectivePeriodQ3,6,0) + ' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstGrossReforecastQ3,

	NULL as AnnualEstNetBudget,
	NULL as AnnualEstNetReforecastQ1,
	NULL as AnnualEstNetReforecastQ2,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don't use the category mapping here like for actual exclude because we want unknowns to come through*/
			'
				 OR (
						LEFT(pr.ReferenceCode,3) = ''BC:''
						AND ' + STR(@ReforecastEffectivePeriodQ3,6,0) + ' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE
			0
        END
    ) as AnnualEstNetReforecastQ3
    
FROM
	ProfitabilityReforecast pr

	INNER JOIN Overhead oh ON oh.OverheadKey = pr.OverheadKey
		AND OverHeadCode IN (''UNKNOWN'', ''' + @OverheadCode + ''') -- GC :: Change Control 1
    
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

    INNER JOIN #ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
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
	AND ref.ReforecastEffectivePeriod = ' + STR(@ReforecastEffectivePeriodQ3,10,0) + '
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
GROUP BY
	gac.GlAccountCategoryKey,
	pr.AllocationRegionKey,
	pr.FunctionalDepartmentKey,			
	pr.PropertyFundKey,
	c.CalendarPeriod,
	CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN '''' ELSE s.SourceName END,
	CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN NULL ELSE pr.GlAccountKey END
')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR('The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...',9,1)
END

PRINT ('Total dynamic sql statement size: ' + STR(LEN(@cmdString)) + '')

PRINT @cmdString
EXEC (@cmdString)

---------------------------------------------------------------------------------------------------
SELECT 
	gac.AccountSubTypeName AS ExpenseType,
	ar.RegionName AS AllocationRegionName,
    fd.FunctionalDepartmentName AS FunctionalDepartmentName,    
    gac.MajorCategoryName AS MajorExpenseCategoryName,
    gac.MinorCategoryName AS MinorExpenseCategoryName,
    CASE WHEN gac.MajorCategoryName = 'Salaries/Taxes/Benefits' THEN '' ELSE pf.PropertyFundName END AS EntityName,
    res.CalendarPeriod AS ExpensePeriod,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
    res.SourceName AS SourceName,
    CASE WHEN gac.MajorCategoryName = 'Salaries/Taxes/Benefits' THEN '' ELSE res.PropertyFundCode END AS PropertyFundCode,
    CASE WHEN (SUBSTRING(res.SourceName, (CHARINDEX(' ', res.SourceName) + 1), 8) = 'Property') THEN (RTRIM(res.OriginatingRegionCode) + LTRIM(res.FunctionalDepartmentCode)) ELSE res.OriginatingRegionCode END AS OriginatingRegionCode,
    res.OriginatingRegionName,
	ISNULL(ga.Code, '') GlAccountCode,
    ISNULL(ga.Name, '') GlAccountName,
	pf.PropertyFundType AS EntityType,
	--Gross
	--Month to date    
	SUM(ISNULL(MtdGrossActual,0)) AS MtdGrossActual,
	SUM(ISNULL(MtdGrossBudget,0)) AS MtdGrossOriginalBudget,
	
	-----
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ1 
	END,0)) AS MtdGrossReforecastQ1,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ2 
	END,0)) AS MtdGrossReforecastQ2,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ3 
	END,0)) AS MtdGrossReforecastQ3,		
	-----
	
	-----
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ1 
	END, 0) - ISNULL(MtdGrossActual, 0)) 
	AS MtdGrossVarianceQ1,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ2 
	END, 0) - ISNULL(MtdGrossActual, 0)) 
	AS MtdGrossVarianceQ2,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ3 
	END, 0) - ISNULL(MtdGrossActual, 0)) 
	AS MtdGrossVarianceQ3,			
	-----
		
	--Year to date
	SUM(ISNULL(YtdGrossActual,0)) AS YtdGrossActual,	
	SUM(ISNULL(YtdGrossBudget,0)) AS YtdGrossOriginalBudget,
	
	-----
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ1 
	END,0)) AS YtdGrossReforecastQ1,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ2 
	END,0)) AS YtdGrossReforecastQ2,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ3 
	END,0)) AS YtdGrossReforecastQ3,			
	-----
	
	-----
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ1
		END, 0) - ISNULL(YtdGrossActual, 0)) 
	AS YtdGrossVarianceQ1,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ2
		END, 0) - ISNULL(YtdGrossActual, 0)) 
	AS YtdGrossVarianceQ2,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ3
		END, 0) - ISNULL(YtdGrossActual, 0)) 
	AS YtdGrossVarianceQ3,
	-----
	--Annual
	SUM(ISNULL(AnnualGrossBudget,0)) AS AnnualGrossOriginalBudget,	
	
	-----
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecastQ1 
		END,0)) 
	AS AnnualGrossReforecastQ1,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecastQ2 
		END,0)) 
	AS AnnualGrossReforecastQ2,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecastQ3 
		END,0)) 
	AS AnnualGrossReforecastQ3,		
	-----

	--Net
	--Month to date    
	SUM(ISNULL(MtdNetActual,0)) AS MtdNetActual,
	SUM(ISNULL(MtdNetBudget,0)) AS MtdNetOriginalBudget,
	
	-----
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ1
		END,0)) 
	AS MtdNetReforecastQ1,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ2
		END,0)) 
	AS MtdNetReforecastQ2,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ3
		END,0)) 
	AS MtdNetReforecastQ3,	
	-----
	
	-----
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ1
		END, 0) - ISNULL(MtdNetActual, 0)) 
	AS MtdNetVarianceQ1,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ2
		END, 0) - ISNULL(MtdNetActual, 0)) 
	AS MtdNetVarianceQ2,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ3
		END, 0) - ISNULL(MtdNetActual, 0)) 
	AS MtdNetVarianceQ3,	
	-----
		
	--Year to date
	SUM(ISNULL(YtdNetActual,0)) AS YtdNetActual,	
	SUM(ISNULL(YtdNetBudget,0)) AS YtdNetOriginalBudget,
	
	-----
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ1
		END,0)) 
	AS YtdNetReforecastQ1,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ2
		END,0)) 
	AS YtdNetReforecastQ2,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ3
		END,0)) 
	AS YtdNetReforecastQ3,
	-----
	
	-----
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ1
		END, 0) - ISNULL(YtdNetActual, 0)) 
	AS YtdNetVarianceQ1,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ2
		END, 0) - ISNULL(YtdNetActual, 0)) 
	AS YtdNetVarianceQ2,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ3
		END, 0) - ISNULL(YtdNetActual, 0)) 
	AS YtdNetVarianceQ3,
	-----
	
	--Annual
	SUM(ISNULL(AnnualNetBudget,0)) AS AnnualNetOriginalBudget,	

	-----
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecastQ1
		END,0)) 
	AS AnnualNetReforecastQ1,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecastQ2
		END,0)) 
	AS AnnualNetReforecastQ2,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecastQ3
		END,0)) 
	AS AnnualNetReforecastQ3
	-----
INTO
	#Output
FROM
	#ExpenseCzar res
		INNER JOIN PropertyFund pf ON pf.PropertyFundKey = res.PropertyFundKey		
		INNER JOIN AllocationRegion ar ON ar.AllocationRegionKey = res.AllocationRegionKey
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentKey = res.FunctionalDepartmentKey
		INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = res.GlAccountCategoryKey 
		LEFT OUTER JOIN GlAccount ga ON ga.GlAccountKey = res.GlAccountKey 
GROUP BY
	gac.AccountSubTypeName,
	ar.RegionName,
    fd.FunctionalDepartmentName,    
    gac.MajorCategoryName,
    gac.MinorCategoryName,
    pf.PropertyFundName,
    res.CalendarPeriod,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
    res.SourceName,
    res.PropertyFundCode,
    CASE WHEN (SUBSTRING(res.SourceName, (CHARINDEX(' ', res.SourceName) + 1), 8) = 'Property') THEN (RTRIM(res.OriginatingRegionCode) + LTRIM(res.FunctionalDepartmentCode)) ELSE res.OriginatingRegionCode END,
    res.OriginatingRegionName,
    
    ISNULL(ga.Code, ''),
    ISNULL(ga.Name, ''),
	pf.PropertyFundType
	
--Output
SELECT
	ExpenseType,
	AllocationRegionName,
    FunctionalDepartmentName,    
    MajorExpenseCategoryName,
    MinorExpenseCategoryName,
    EntityName,
    ExpensePeriod,
    EntryDate,
    [User],
    [Description],
    AdditionalDescription,
    SourceName,
    PropertyFundCode,
    OriginatingRegionCode,
    OriginatingRegionName,
    GlAccountCode,
    GlAccountName,
    EntityType,
	--Gross
	--Month to date    
	MtdGrossActual,
	MtdGrossOriginalBudget,

	MtdGrossReforecastQ1,
	--MtdGrossReforecastQ2,
	--CASE WHEN @ReforecastQuaterName = 'Q0' THEN 0 ELSE MtdGrossReforecastQ3 END AS MtdGrossReforecastQ3,
	
	MtdGrossVarianceQ1,
	--MtdGrossVarianceQ2,
	--MtdGrossVarianceQ3,
		
	--Year to date
	YtdGrossActual,	
	YtdGrossOriginalBudget,

	YtdGrossReforecastQ1,
	--YtdGrossReforecastQ2,
	--CASE WHEN @ReforecastQuaterName = 'Q0' THEN 0 ELSE YtdGrossReforecastQ3 END AS YtdGrossReforecastQ3,
	
	YtdGrossVarianceQ1,
	--YtdGrossVarianceQ2,
	--YtdGrossVarianceQ3,

	--Annual
	AnnualGrossOriginalBudget,
	
	CASE WHEN @ReforecastQuaterName = 'Q0' THEN 0 ELSE AnnualGrossReforecastQ1 END AS AnnualGrossReforecastQ1,
	CASE WHEN @ReforecastQuaterName = 'Q0' THEN 0 ELSE AnnualGrossReforecastQ2 END AS AnnualGrossReforecastQ2,
	CASE WHEN @ReforecastQuaterName = 'Q0' THEN 0 ELSE AnnualGrossReforecastQ3 END AS AnnualGrossReforecastQ3,

	--Annual Estimated
	--AnnualGrossEstimatedActual,
	--AnnualGrossEstimatedVariance,

	--Net
	--Month to date    
	MtdNetActual,
	MtdNetOriginalBudget,
	
	MtdNetReforecastQ1,
	--MtdNetReforecastQ2,
	--CASE WHEN @ReforecastQuaterName = 'Q0' THEN 0 ELSE MtdNetReforecastQ3 END AS MtdNetReforecastQ3,
	
	MtdNetVarianceQ1,
	--MtdNetVarianceQ2,
	--MtdNetVarianceQ3,

	--Year to date
	YtdNetActual,	
	YtdNetOriginalBudget,
	
	YtdNetReforecastQ1,
	--YtdNetReforecastQ2,
	--CASE WHEN @ReforecastQuaterName = 'Q0' THEN 0 ELSE YtdNetReforecastQ3 END AS YtdNetReforecastQ3,
	
	YtdNetVarianceQ1,
	--YtdNetVarianceQ2,
	--YtdNetVarianceQ3,

	--Annual
	AnnualNetOriginalBudget,	
	AnnualNetReforecastQ1,
	--CASE WHEN @ReforecastQuaterName = 'Q0' THEN 0 ELSE AnnualNetReforecastQ1 END AS AnnualNetReforecastQ1,
	CASE WHEN @ReforecastQuaterName = 'Q0' THEN 0 ELSE AnnualNetReforecastQ2 END AS AnnualNetReforecastQ2,
	CASE WHEN @ReforecastQuaterName = 'Q0' THEN 0 ELSE AnnualNetReforecastQ3 END AS AnnualNetReforecastQ3

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

	MtdGrossReforecastQ1 <> 0.00 OR
	--MtdGrossReforecastQ2 <> 0.00 OR
	--MtdGrossReforecastQ3 <> 0.00 OR
	
	MtdGrossVarianceQ1 <> 0.00 OR
	--MtdGrossVarianceQ2 <> 0.00 OR
	--MtdGrossVarianceQ3 <> 0.00 OR
		
	--Year to date
	YtdGrossActual <> 0.00 OR
	YtdGrossOriginalBudget <> 0.00 OR

	YtdGrossReforecastQ1 <> 0.00 OR
	--YtdGrossReforecastQ2 <> 0.00 OR
	--YtdGrossReforecastQ3 <> 0.00 OR
	
	YtdGrossVarianceQ1 <> 0.00 OR
	--YtdGrossVarianceQ2 <> 0.00 OR
	--YtdGrossVarianceQ3 <> 0.00 OR

	--Annual
	AnnualGrossOriginalBudget <> 0.00 OR
	
	AnnualGrossReforecastQ1 <> 0.00 OR
	--AnnualGrossReforecastQ2 <> 0.00 OR
	--AnnualGrossReforecastQ3 <> 0.00 OR
	
	--Annual Estimated
	--AnnualGrossEstimatedActual <> 0.00 OR
	--AnnualGrossEstimatedVariance <> 0.00 OR

	--Net
	--Month to date
	MtdNetActual <> 0.00 OR
	MtdNetOriginalBudget <> 0.00 OR
	
	MtdNetReforecastQ1 <> 0.00 OR
	--MtdNetReforecastQ2 <> 0.00 OR
	--MtdNetReforecastQ3 <> 0.00 OR
	
	MtdNetVarianceQ1 <> 0.00 OR
	--MtdNetVarianceQ2 <> 0.00 OR
	--MtdNetVarianceQ3 <> 0.00 OR

	--Year to date
	YtdNetActual <> 0.00 OR
	YtdNetOriginalBudget <> 0.00 OR
	
	YtdNetReforecastQ1 <> 0.00 OR
	--YtdNetReforecastQ2 <> 0.00 OR
	--YtdNetReforecastQ3 <> 0.00 OR
	
	YtdNetVarianceQ1 <> 0.00 OR
	--YtdNetVarianceQ2 <> 0.00 OR
	--YtdNetVarianceQ3 <> 0.00 OR

	--Annual
	AnnualNetOriginalBudget <> 0.00 OR
	
	AnnualNetReforecastQ1 <> 0.00
	--AnnualNetReforecastQ2 <> 0.00 OR
	--AnnualNetReforecastQ3 <> 0.00

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

IF 	OBJECT_ID('tempdb..#EntityFilterTable') IS NOT NULL
	DROP TABLE #EntityFilterTable

IF 	OBJECT_ID('tempdb..#FunctionalDepartmentFilterTable') IS NOT NULL
	DROP TABLE #FunctionalDepartmentFilterTable

IF 	OBJECT_ID('tempdb..#AllocationRegionFilterTable') IS NOT NULL
	DROP TABLE #AllocationRegionFilterTable

IF 	OBJECT_ID('tempdb..#AllocationSubRegionFilterTable') IS NOT NULL
	DROP TABLE #AllocationSubRegionFilterTable

IF 	OBJECT_ID('tempdb..#MajorAccountCategoryFilterTable') IS NOT NULL
	DROP TABLE #MajorAccountCategoryFilterTable

IF 	OBJECT_ID('tempdb..#OriginatingRegionFilterTable') IS NOT NULL
	DROP TABLE #OriginatingRegionFilterTable

IF 	OBJECT_ID('tempdb..#OriginatingSubRegionFilterTable') IS NOT NULL
	DROP TABLE #OriginatingSubRegionFilterTable


GO


