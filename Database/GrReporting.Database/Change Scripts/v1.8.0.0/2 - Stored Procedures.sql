 /*
 1. stp_R_BudgetJobCodeDetail.sql
 2. stp_R_BudgetOriginator.sql
 3. stp_R_BudgetOwner.sql
 4. stp_R_ExpenseCzarTotalComparisonDetail.sql
 5. stp_R_ProfitabilityDetailV2.sql
 6. stp_R_ProfitabilityV2.sql
 
 7.  csp_IU_SCDActivityType
 8.  csp_IU_SCDAllocationRegion
 9.  csp_IU_SCDFunctionalDepartment
 10. csp_IU_SCDGlAccount
 11. csp_IU_SCDGlAccountCategory
 12. csp_IU_SCDOriginatingRegion
 13. csp_IU_SCDPropertyFund
 
  */
  
-- 1. stp_R_BudgetJobCodeDetail.sql
USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_BudgetJobCodeDetail]    Script Date: 08/08/2011 20:32:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetJobCodeDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_BudgetJobCodeDetail]
GO

USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_BudgetJobCodeDetail]    Script Date: 08/08/2011 20:32:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/*********************************************************************************************************************
Description
	The stored procedure is used for generating the data for the Budget Originator Job Code Details Report.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-07-08		: PKayongo	:	Sensitized payroll data for the MRI Source, Originating Region Code and 
											Property Fund fields. (CC20)
			2011-07-11		: PKayongo	:	Allowed reforecast values to be dynamically selected from the 
											@ReforecastQuarterName variable. Only 1 reforecast dynamic query remained
											and only the different reforecast fields at the end (i.e. Q1, Q2, Q3)
											were consolidated into 1.
			2011-08-08		: PKayongo	:	Annual Reforecast = 0 when ReforecastQuarterName = "Q0"
			2011-08-08		: SNothling	:	Set sensitized strings to 'Sensitized' instead of ''
**********************************************************************************************************************/


CREATE PROCEDURE [dbo].[stp_R_BudgetJobCodeDetail]
	@ReportExpensePeriod INT = NULL,
	@ReforecastQuarterName CHAR(2) = NULL, --'Q0' or 'Q1' or 'Q2' or 'Q3'
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
	@OverheadCode Varchar(10)='UNALLOC'
AS

DECLARE
	@_ReportExpensePeriod INT = @ReportExpensePeriod,
	@_ReforecastQuarterName VARCHAR(10) = @ReforecastQuarterName,
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


--------------------------------------------------------------------------

IF @ReforecastQuarterName IS NULL OR @ReforecastQuarterName NOT IN ('Q0', 'Q1', 'Q2', 'Q3')
	SET @ReforecastQuarterName = (SELECT TOP 1
									ReforecastQuarterName 
								 FROM
									dbo.Reforecast 
								 WHERE
									ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
									ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
								 ORDER BY ReforecastEffectivePeriod DESC)
-- Compute Reforecast Effective Periods

DECLARE @ReforecastEffectivePeriod INT

SET @ReforecastEffectivePeriod = (SELECT TOP 1
										ReforecastEffectivePeriod 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										ReforecastQuarterName = @ReforecastQuarterName
									ORDER BY
										ReforecastEffectivePeriod)	
										
--------------------------------------------------------------------------

-- Determine the ReforecastKey of the reforecast that is currently active (i.e.: 2011 Q1, 2011 Q2, 2012 Q0 etc)
DECLARE @ActiveReforecastKey INT = (SELECT ReforecastKey FROM dbo.GetReforecastRecord(@ReportExpensePeriod, @ReforecastQuarterName))

IF (@ActiveReforecastKey IS NULL) -- Safeguard against NULL ReforecastKey returned from previous statement
BEGIN
	SET @ActiveReforecastKey = (SELECT MAX(ReforecastKey) FROM dbo.ExchangeRate)
	PRINT ('Near disaster: @ActiveReforecastKey is NULL, so reverting to the largest/most recent ReforecastKey in dbo.ExchangeRate: ' + @ActiveReforecastKey)
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
	
CREATE TABLE #EntityFilterTable (PropertyFundKey Int NOT NULL)
CREATE TABLE #FunctionalDepartmentFilterTable (FunctionalDepartmentKey Int NOT NULL)
CREATE TABLE #ActivityTypeFilterTable (ActivityTypeKey Int NOT NULL)
CREATE TABLE #AllocationRegionFilterTable (AllocationRegionKey Int NOT NULL)
CREATE TABLE #AllocationSubRegionFilterTable (AllocationRegionKey Int NOT NULL)
CREATE TABLE #MajorAccountCategoryFilterTable (GlAccountCategoryKey Int NOT NULL)	
CREATE TABLE #MinorAccountCategoryFilterTable (GlAccountCategoryKey Int NOT NULL)	
CREATE TABLE #OriginatingRegionFilterTable (OriginatingRegionKey Int NOT NULL)
CREATE TABLE #OriginatingSubRegionFilterTable (OriginatingRegionKey Int NOT NULL)	
	
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable (PropertyFundKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable (ActivityTypeKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationRegionFilterTable	(AllocationRegionKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable (AllocationRegionKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MajorAccountCategoryFilterTable (GlAccountCategoryKey)	
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MinorAccountCategoryFilterTable (GlAccountCategoryKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingRegionFilterTable (OriginatingRegionKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable (OriginatingRegionKey)
	
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
	PropertyFundCode			Varchar(11) DEFAULT(''), --Varchar, for this helps to keep reports size smaller
	OriginatingRegionCode		Varchar(30) DEFAULT(''), --Varchar, for this helps to keep reports size smaller
	FunctionalDepartmentCode	Varchar(15) DEFAULT(''),
	GlAccountKey				Int  NULL,
	
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
	AnnualNetBudget				MONEY,
	AnnualNetReforecast			MONEY,
	
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
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE s.SourceName END,
    CONVERT(varchar(10),ISNULL(pa.EntryDate,''''), 101) as EntryDate,
    ISNULL(pa.[User], '''') [User],
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.Description ELSE '''' END as Description,
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.AdditionalDescription ELSE '''' END as AdditionalDescription,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE ISNULL(pa.PropertyFundCode, '''') END PropertyFundCode,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE ISNULL(pa.OriginatingRegionCode, '''') END OriginatingRegionCode,
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
	
	NULL as MtdGrossReforecast,
	
	
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
	
	NULL as MtdNetReforecast,	
	
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
	
	' + /*-- YtdGrossReforecast --------------------------*/ + '
	
	NULL as YtdGrossReforecast,			
	
	' + /*-- YtdGrossReforecast End --------------------------*/ + '
	
	')
	DECLARE @cmdString2 VARCHAR(8000)
	SET @cmdString2 = (SELECT '		
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdNetActual,
	NULL as YtdNetBudget,
	
	' + /*-- YtdNetReforecast End --------------------------*/ + '
	
	NULL as YtdNetReforecast,

	' + /*-- YtdNetReforecast End --------------------------*/ + '
	
	NULL as AnnualGrossBudget,
	
	' + /*-- AnnualGrossReforecast --------------------------*/ + '
	
	NULL as AnnualGrossReforecast,

	' + /*-- AnnualGrossReforecast End --------------------------*/ + '

	NULL as AnnualNetBudget,
		
	' + /*-- AnnualNetReforecast --------------------------*/ + '
	
    NULL as AnnualNetReforecast,		
	
	' + /*-- AnnualNetReforecast End --------------------------*/ + '
	
		')
	DECLARE @cmdString3 VARCHAR(8000)
	SET @cmdString3 = (SELECT '	
	
	SUM(
        er.Rate *
        CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pa.LocalActual
        ELSE 
			0
        END
	) as AnnualEstGrossBudget,
	
	' + /*-- AnnualEstGrossReforecast --------------------------*/ + '
	
	NULL as AnnualEstGrossReforecast,

	' + /*-- AnnualEstGrossReforecast End --------------------------*/ + '

    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
    
    ' + /*-- AnnualEstNetReforecast --------------------------*/ + '
    
	NULL as AnnualEstNetReforecast	
	
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
			
    INNER JOIN #ExchangeRate er ON er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
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
GROUP BY
	gac.GlAccountCategoryKey,
	pa.AllocationRegionKey,
	pa.OriginatingRegionKey,
	pa.FunctionalDepartmentKey,
	pa.PropertyFundKey,
	c.CalendarPeriod,
	CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE s.SourceName END,
	CONVERT(varchar(10),ISNULL(pa.EntryDate,''''), 101),
	ISNULL(pa.[User], ''''),
	CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.Description ELSE '''' END,
	CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.AdditionalDescription ELSE '''' END,
	CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE ISNULL(pa.PropertyFundCode, '''') END,
	CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE ISNULL(pa.OriginatingRegionCode, '''') END,
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

-----------------------------------------------------------------------------------------------------
-- Get budget information
SET @cmdString = (SELECT '
INSERT INTO #BudgetOriginator
SELECT 	
	gac.GlAccountCategoryKey,
    pb.AllocationRegionKey,
    pb.OriginatingRegionKey,
    pb.FunctionalDepartmentKey,
    pb.PropertyFundKey,
    c.CalendarPeriod,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE s.SourceName END,
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' OriginatingRegionCode,
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

	SUM(er.Rate * r.MultiplicationFactor * pb.LocalBudget) as AnnualNetBudget,
	
	NULL as AnnualNetReforecast,

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

	INNER JOIN #ExchangeRate er ON er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey
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
GROUP BY
    gac.GlAccountCategoryKey,
    pb.AllocationRegionKey,
    pb.OriginatingRegionKey,
    pb.FunctionalDepartmentKey,
    pb.PropertyFundKey,
    c.CalendarPeriod,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE s.SourceName END,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN NULL ELSE pb.GlAccountKey END
')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR('The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...',9,1)
END

PRINT ('Total dynamic sql statement size: ' + STR(LEN(@cmdString)))

print @cmdString
EXEC (@cmdString)

IF @ReforecastQuarterName IN ('Q1', 'Q2', 'Q3')

BEGIN

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
		CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE s.SourceName END,
		'''' as EntryDate,
		'''' as [User],
		'''' as Description,
		'''' as AdditionalDescription,
		'''' as PropertyFundCode,
		'''' as OriginatingRegionCode,
		'''' as FunctionalDepartmentCode,
		CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN NULL ELSE pr.GlAccountKey END,
	    
		NULL as MtdGrossActual,
		NULL as MtdGrossBudget,
		
		' + /*-- MtdGrossReforecast --------------------------*/ + '
		
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
		
		' + /*-- MtdGrossReforecast End --------------------------*/ + '
		
		NULL as MtdNetActual,
		NULL as MtdNetBudget,
		
		' + /*-- MtdNetReforecast --------------------------*/ + '
		
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
		
		' + /*-- MtdNetReforecast End --------------------------*/ + '
		
		NULL as YtdGrossActual,
		NULL as YtdGrossBudget,
		
		' + /*-- YtdGrossReforecast --------------------------*/ + '
		
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
		
		' + /*-- YtdGrossReforecast End --------------------------*/ + '
		
		NULL as YtdNetActual,
		NULL as YtdNetBudget,
		
		' + /*-- YtdNetReforecast --------------------------*/ + '
		
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
		
		' + /*-- YtdNetReforecast End --------------------------*/ + '
		
		NULL as AnnualGrossBudget,
		
		' + /*-- AnnualGrossReforecast --------------------------*/ + '
			
		SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecast,

		' + /*-- AnnualGrossReforecast End --------------------------*/ + '

		NULL as AnnualNetBudget,
		
		' + /*-- AnnualNetReforecast --------------------------*/ + '
		
		SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecast,

		' + /*-- AnnualNetReforecast End --------------------------*/ + '

		NULL as AnnualEstGrossBudget,
		
		' + /*-- AnnualEstGrossReforecast --------------------------*/ + '
		
		SUM(
			er.Rate *
			CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + 
				/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
				/*Don't use the category mapping here like for actual exclude because we want unknowns to come through*/
				'
					 OR (
							LEFT(pr.ReferenceCode,3) = ''BC:''
							AND ' + STR(@ReforecastEffectivePeriod,6,0) + ' IN (201003, 201006, 201009)
						)
					 ) THEN 
				pr.LocalReforecast
			ELSE
				0
			END
		) as AnnualEstGrossReforecast,	
		
		' + /*-- AnnualEstGrossReforecast End --------------------------*/ + '
		
		NULL as AnnualEstNetBudget,
		
		' + /*-- AnnualEstNetReforecast --------------------------*/ + '
		
		SUM(
			er.Rate * r.MultiplicationFactor *
			CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + 
				/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
				/*Don't use the category mapping here like for actual exclude because we want unknowns to come through*/
				'
					 OR (
							LEFT(pr.ReferenceCode,3) = ''BC:''
							AND ' + STR(@ReforecastEffectivePeriod,6,0) + ' IN (201003, 201006, 201009)
						)
					 ) THEN 
				pr.LocalReforecast
			ELSE 
				0
			END
		) as AnnualEstNetReforecast 
	    
		' + /*-- AnnualEstNetReforecast End --------------------------*/ + '
	    
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

		INNER JOIN #ExchangeRate er ON er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
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
	GROUP BY
		gac.GlAccountCategoryKey,
		pr.AllocationRegionKey,
		pr.OriginatingRegionKey,
		pr.FunctionalDepartmentKey,
		pr.PropertyFundKey,
		c.CalendarPeriod,
		CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE s.SourceName END,
		CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN NULL ELSE pr.GlAccountKey END
		
	')

	IF (LEN(@cmdString)) > 7995
	BEGIN
		RAISERROR('The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...',9,1)
	END

	PRINT ('Total dynamic sql statement size: ' + STR(LEN(@cmdString)) + '')

	PRINT @cmdString
	EXEC (@cmdString)

END



-----------------------------------------------------------------------------------------------------------------------    
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
    CASE WHEN (SUBSTRING(res.SourceName, CHARINDEX(' ', res.SourceName) +1, 8) = 'Property') THEN RTRIM(res.OriginatingRegionCode) + LTRIM(res.FunctionalDepartmentCode) ELSE res.OriginatingRegionCode END AS OriginatingRegionCode,
    --res.OriginatingRegionCode OriginatingRegionCode,
    ISNULL(ga.Code, '') GlAccountCode,
    ISNULL(ga.Name, '') GlAccountName,
    
	--Month to date    
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossActual,0) ELSE ISNULL(MtdNetActual,0) END) AS MtdActual,
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossBudget,0) ELSE ISNULL(MtdNetBudget,0) END) AS MtdOriginalBudget,
	
	----- MtdReforecast
	SUM(CASE WHEN (@IsGross = 1) THEN
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast
		END,0) 
	END) 
	AS MtdReforecast,
	
	
	----- MtdVariance
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast
		END, 0) - ISNULL(MtdNetActual, 0) 
	END) 
	AS MtdVariance,		

	
	--Year to date
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossActual,0) ELSE ISNULL(YtdNetActual,0) END) AS YtdActual,	
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossBudget,0) ELSE ISNULL(YtdNetBudget,0) END) AS YtdOriginalBudget,
	
	----- YtdReforecast
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast
		END,0) 
	END) 
	AS YtdReforecast,
	
	----- YtdVariance
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast 
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) 
	AS YtdVariance,

	
	--Annual
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(AnnualGrossBudget,0) ELSE ISNULL(AnnualNetBudget,0) END) AS AnnualOriginalBudget,	
	
	----- AnnualReforecast
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			0 
		ELSE 
			AnnualGrossReforecast
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			0 
		ELSE 
			AnnualNetReforecast 
		END,0) 
	END) 
	AS AnnualReforecast

	----- AnnualReforecast End
	
	--SUM(CASE WHEN (@IsGross = 1) THEN 
	--	ISNULL(CASE WHEN @PreviousReforecastQuarterName = 'Q1' THEN 
	--		AnnualGrossReforecastQ1 		
	--	END,0) 
	--ELSE 
	--	ISNULL(CASE WHEN @PreviousReforecastQuarterName = 'Q1' THEN 
	--		AnnualNetReforecastQ1	
	--	END,0) 
	--END) 
	--AS AnnualReforecastQ1

INTO
	#Output
FROM
	#BudgetOriginator res
	INNER JOIN AllocationRegion ar ON ar.AllocationRegionKey = res.AllocationRegionKey
	INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = res.OriginatingRegionKey
	INNER JOIN PropertyFund pf ON pf.PropertyFundKey = res.PropertyFundKey
	INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentKey = res.FunctionalDepartmentKey
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = res.GlAccountCategoryKey 
	LEFT OUTER JOIN GlAccount ga ON ga.GlAccountKey = res.GlAccountKey 
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
    CASE WHEN (SUBSTRING(res.SourceName, CHARINDEX(' ', res.SourceName) +1, 8) = 'Property') THEN RTRIM(res.OriginatingRegionCode) + LTRIM(res.FunctionalDepartmentCode) ELSE res.OriginatingRegionCode END,
    --res.OriginatingRegionCode,
    ISNULL(ga.Code, ''),
    ISNULL(ga.Name, '')
	
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
    GlAccountCode,
    GlAccountName,
    
	--Month to date    
	MtdActual,
	MtdOriginalBudget,
	MtdReforecast,
	MtdVariance,
	
	YtdActual,	
	YtdOriginalBudget,
	YtdReforecast,
	YtdVariance,
	AnnualOriginalBudget,
	AnnualReforecast

	
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
	--MtdVarianceQ2 <> 0.00 OR
	--MtdVarianceQ3 <> 0.00 OR
			

	YtdActual <> 0.00 OR	
	YtdOriginalBudget <> 0.00 OR
	YtdReforecast <> 0.00 OR
	YtdVariance <> 0.00 OR
	--YtdVarianceQ2 <> 0.00 OR
	--YtdVarianceQ3 <> 0.00 OR
		
	--Annual
	AnnualOriginalBudget <> 0.00 OR
	AnnualReforecast <> 0.00
	--AnnualReforecastQ2 <> 0.00 OR
	--AnnualReforecastQ3 <> 0.00
	
	
	--Annual Estimated
	--AnnualEstimatedActual <> 0.00 OR	
	--AnnualEstimatedVariance <> 0.00
	
IF OBJECT_ID('tempdb..#BudgetOriginator') IS NOT NULL
    DROP TABLE #BudgetOriginator

IF 	OBJECT_ID('tempdb..#Output') IS NOT NULL
    DROP TABLE #Output

IF 	OBJECT_ID('tempdb..#EntityFilterTable') IS NOT NULL
	DROP TABLE #EntityFilterTable

IF 	OBJECT_ID('tempdb..#FunctionalDepartmentFilterTable') IS NOT NULL
	DROP TABLE #FunctionalDepartmentFilterTable

IF 	OBJECT_ID('tempdb..#ActivityTypeFilterTable') IS NOT NULL
	DROP TABLE #ActivityTypeFilterTable

IF 	OBJECT_ID('tempdb..#AllocationRegionFilterTable') IS NOT NULL
	DROP TABLE #AllocationRegionFilterTable

IF 	OBJECT_ID('tempdb..#AllocationSubRegionFilterTable') IS NOT NULL
	DROP TABLE #AllocationSubRegionFilterTable

IF 	OBJECT_ID('tempdb..#MajorAccountCategoryFilterTable') IS NOT NULL
	DROP TABLE #MajorAccountCategoryFilterTable

IF 	OBJECT_ID('tempdb..#MinorAccountCategoryFilterTable') IS NOT NULL
	DROP TABLE #MinorAccountCategoryFilterTable

IF 	OBJECT_ID('tempdb..#OriginatingRegionFilterTable') IS NOT NULL
	DROP TABLE #OriginatingRegionFilterTable

IF 	OBJECT_ID('tempdb..#OriginatingSubRegionFilterTable') IS NOT NULL
	DROP TABLE #OriginatingSubRegionFilterTable





GO


-- 2. stp_R_BudgetOriginator.sql
USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginator]    Script Date: 08/08/2011 20:32:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOriginator]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_BudgetOriginator]
GO

USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginator]    Script Date: 08/08/2011 20:32:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/*********************************************************************************************************************
Description
	The stored procedure is used for generating the data for the Budget Originator report.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-07-08		: PKayongo	:	Sensitized payroll data for the MRI Source, Originating Region Code and 
											Property Fund fields. (CC20)
			2011-07-11		: PKayongo	:	Allowed reforecast values to be dynamically selected from the 
											@ReforecastQuarterName variable. Only 1 reforecast dynamic query remained
											and only the different reforecast fields at the end (i.e. Q1, Q2, Q3)
											were consolidated into 1.
			2011-08-08		: SNothling	:	Set sensitized strings to 'Sensitized' instead of ''
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_R_BudgetOriginator]
	@ReportExpensePeriod INT = NULL,
	@ReforecastQuarterName CHAR(2) = NULL, --'Q0' or 'Q1' or 'Q2' or 'Q3'
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
	@OverheadCode Varchar(10)='UNALLOC'

AS

DECLARE
	@_ReportExpensePeriod INT = @ReportExpensePeriod,
	@_ReforecastQuarterName VARCHAR(10) = @ReforecastQuarterName,
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
/*	SETUP MAPPING DATA		*/
--------------------------------------------------------------------------
-- Change Control 14. CC Ref 5.4 Create Direct or Indirect field and map Direct to all the properties, and Indirect to all the Corporates
IF 	OBJECT_ID('tempdb..#DirectIndirectMappings') IS NOT NULL
    DROP TABLE #DirectIndirectMappings

CREATE TABLE #DirectIndirectMappings
(
	SourceName varchar(50) PRIMARY KEY ,
	DirectIndirect varchar (10),
)	
INSERT INTO #DirectIndirectMappings
SELECT
	SourceName,
	'Direct' AS DirectIndirect
FROM
	dbo.[Source]
WHERE
	IsProperty = 'YES'

UNION

SELECT
	SourceName,
	'Indirect' AS DirectIndirect
FROM
	dbo.[Source]
WHERE
	IsCorporate = 'YES'

UNION

SELECT
	SourceName,
	'-' AS DirectIndirect
FROM
	dbo.[Source]
WHERE
	IsCorporate = 'NO' AND
	IsProperty = 'NO'

--------------------------------------------------------------------------
/*	END SETUP MAPPING DATA		*/
--------------------------------------------------------------------------

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



--------------------------------------------------------------------------
-- let latest reforecast (it will be zero if there is no data for the reforecast)
IF @ReforecastQuarterName IS NULL OR @ReforecastQuarterName NOT IN ('Q0', 'Q1', 'Q2', 'Q3')
	SET @ReforecastQuarterName = (SELECT TOP 1
									ReforecastQuarterName 
								 FROM
									dbo.Reforecast 
								 WHERE
									ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
									ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
								 ORDER BY ReforecastEffectivePeriod DESC)
--------------------------------------------------------------------------
-- Compute Reforecast Effective Periods

DECLARE @ReforecastEffectivePeriod	INT


SET @ReforecastEffectivePeriod	= (SELECT TOP 1
										ReforecastEffectivePeriod 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										ReforecastQuarterName = @ReforecastQuarterName
									ORDER BY
										ReforecastEffectivePeriod)								

-- Determine the ReforecastKey of the reforecast that is currently active (i.e.: 2011 Q1, 2011 Q2, 2012 Q0 etc)
DECLARE @ActiveReforecastKey INT = (SELECT ReforecastKey FROM dbo.GetReforecastRecord(@ReportExpensePeriod, @ReforecastQuarterName))

IF (@ActiveReforecastKey IS NULL) -- Safeguard against NULL ReforecastKey returned from previous statement
BEGIN
	SET @ActiveReforecastKey = (SELECT MAX(ReforecastKey) FROM dbo.ExchangeRate)
	PRINT ('Near disaster: @ActiveReforecastKey is NULL, so reverting to the largest/most recent ReforecastKey in dbo.ExchangeRate: ' + @ActiveReforecastKey)
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
	ActivityTypeKey			INT,
	AllocationRegionKey		INT,
	OriginatingRegionKey	INT,
    PropertyFundKey			INT,
    FunctionalDepartmentKey INT,    
	GlAccountCategoryKey	INT,
	SourceName				VARCHAR(50),
	EntryDate				VARCHAR(10),
	[User]					NVARCHAR(20),
	[Description]			NVARCHAR(60),
	AdditionalDescription	NVARCHAR(4000),
	PropertyFundCode		VARCHAR(11) DEFAULT(''), --Varchar, for this helps to keep reports size smaller
	OriginatingRegionCode	VARCHAR(30) DEFAULT(''), --Varchar, for this helps to keep reports size smaller
	FunctionalDepartmentCode VARCHAR(15) DEFAULT(''),
	GlAccountKey			INT NULL,
	CalendarPeriod			Varchar(6) DEFAULT(''),

	--Month to date	
	MtdGrossActual			MONEY,
	MtdGrossBudget			MONEY,
	MtdGrossReforecast		MONEY,
	MtdNetActual			MONEY,
	MtdNetBudget			MONEY,
	MtdNetReforecast		MONEY,
	
	--Year to date
	YtdGrossActual			MONEY,	
	YtdGrossBudget			MONEY, 
	YtdGrossReforecast		MONEY,
	YtdNetActual			MONEY, 
	YtdNetBudget			MONEY, 
	YtdNetReforecast		MONEY,
	
	--Annual
	AnnualGrossBudget		MONEY,
	AnnualGrossReforecast	MONEY,
	AnnualNetBudget			MONEY,
	AnnualNetReforecast		MONEY,

	--Annual estimated
	AnnualEstGrossBudget		MONEY,
	AnnualEstGrossReforecast	MONEY,
	AnnualEstNetBudget			MONEY,
	AnnualEstNetReforecast		MONEY
)

DECLARE @cmdString Varchar(MAX)

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
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE s.SourceName END,
    CONVERT(varchar(10),ISNULL(pa.EntryDate,''''), 101) as EntryDate,
    ISNULL(pa.[User], '''') [User],
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.Description ELSE '''' END as Description,
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.AdditionalDescription ELSE '''' END as AdditionalDescription,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE ISNULL(pa.PropertyFundCode, '''') END PropertyFundCode,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE ISNULL(pa.OriginatingRegionCode, '''') END OriginatingRegionCode,
    ISNULL(pa.FunctionalDepartmentCode, '''') FunctionalDepartmentCode,
    pa.GLAccountKey,
    c.CalendarPeriod,
    
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdGrossActual,
	NULL as MtdGrossBudget,
	
	' + /*-- ReforecastEffectivePeriod --------------------------*/ + '
	
	NULL as MtdGrossReforecast,
	
	' + /*-- ReforecastEffectivePeriod End ----------------------*/ + '
	
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
	
	NULL as MtdNetReforecast,
	
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
	
	' + /*-- YTDGrossReforecast --------------------------*/ + '
	
	NULL as YtdGrossReforecast,

	' + /*-- YTDGrossReforecast End ----------------------*/ + '
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdNetActual,
	NULL as YtdNetBudget,
	')
	
	DECLARE @cmdString2 Varchar(MAX)
	SET @cmdString2 = (Select '
	
	
	' + /*-- YtdNetReforecast ----------------------*/ + '
	
	NULL as YtdNetReforecast,

	' +
	
	/*-- YtdNetReforecast End ------------------*/ + '
	

	NULL as AnnualGrossBudget,
	
	' + /*-- AnnualGrossReforecast ------------------*/ + '
	
	NULL as AnnualGrossReforecast,

	' + /*-- AnnualGrossReforecast End ------------------*/ + '

	')

	DECLARE @cmdString3 Varchar(MAX)
	SET @cmdString3 = (Select '

	NULL as AnnualNetBudget,
	
	' + /*-- AnnualNetReforecast ------------------*/ + '
	
    NULL as AnnualNetReforecast,

	' + /*-- AnnualNetReforecast End ------------------*/ + '
	
	SUM(
        er.Rate *
        CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pa.LocalActual
        ELSE 
			0
        END
	) as AnnualEstGrossBudget,
	
	' + /*-- AnnualEstGrossReforecast ------------------*/ + '
	
	NULL as AnnualEstGrossReforecast,

	' + /*-- AnnualEstGrossReforecast End ------------------*/ + '

    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
    
    ' + /*-- AnnualEstNetReforecast ------------------*/ + '
    
	NULL as AnnualEstNetReforecast
	' + /*-- AnnualEstNetReforecast End ------------------*/ + '
	
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
GROUP BY
	pa.ActivityTypeKey,
	pa.AllocationRegionKey,
	pa.OriginatingRegionKey,
    pa.PropertyFundKey,
    pa.FunctionalDepartmentKey,
	gac.GlAccountCategoryKey,
	CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE s.SourceName END,
	CONVERT(varchar(10),ISNULL(pa.EntryDate,''''), 101),
	ISNULL(pa.[User], '''') ,
	CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.Description ELSE '''' END,
	CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.AdditionalDescription ELSE '''' END,
	CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE ISNULL(pa.PropertyFundCode, '''') END,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE ISNULL(pa.OriginatingRegionCode, '''') END,
    ISNULL(pa.FunctionalDepartmentCode, ''''),
	pa.GlAccountKey,
	c.CalendarPeriod
	
	')

IF (LEN(@cmdString) > 7995 OR LEN(@cmdString2) > 7995 OR LEN(@cmdString3) > 7995)
BEGIN
	RAISERROR('The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...',9,1)
END

PRINT ('Total dynamic sql statement size: ' + STR(LTRIM(RTRIM(LEN(@cmdString)))) + ' + ' + STR(LTRIM(RTRIM(LEN(@cmdString2)))) + ' + ' + STR(LTRIM(RTRIM(LEN(@cmdString3)))))

PRINT (@cmdString)
PRINT (@cmdString2)
PRINT (@cmdString3)

EXEC (@cmdString + @cmdString2 + @cmdString3)

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
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE s.SourceName END,
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' as OriginatingRegionCode,
    '''' as FunctionalDepartmentCode,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN NULL ELSE pb.GlAccountKey END,
    '''' as CalendarPeriod,
    
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

	SUM(er.Rate * r.MultiplicationFactor * pb.LocalBudget) as AnnualNetBudget,
	
	NULL as AnnualNetReforecast,
	
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

    INNER JOIN #ExchangeRate er ON er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey 
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
	CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE s.SourceName END,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN NULL ELSE pb.GlAccountKey END
    
')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR('The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...',9,1)
END

PRINT ('Total dynamic sql statement size: ' + STR(LEN(@cmdString)) + '')

PRINT @cmdString
EXEC (@cmdString)

-- Get reforecast information -------------------------------------------------------------------------------------------------
IF @ReforecastQuarterName IN ('Q1', 'Q2', 'Q3')
BEGIN

-- CC20: All reforecast data is now gathered from one dynamic sql query now that the quarter name is passed in.

	SET @cmdString = (Select '
	INSERT INTO #BudgetOriginatorOwner
	SELECT 
		pr.ActivityTypeKey,
		pr.AllocationRegionKey,
		pr.OriginatingRegionKey,
		pr.PropertyFundKey,
		pr.FunctionalDepartmentKey,
		gac.GlAccountCategoryKey,
		CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE s.SourceName END,
		'''' as EntryDate,
		'''' as [User],
		'''' as Description,
		'''' as AdditionalDescription,
		'''' as PropertyFundCode,
		'''' as OriginatingRegionCode,
		'''' as FunctionalDepartmentCode,
		CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN NULL ELSE pr.GlAccountKey END,
		'''' as CalendarPeriod,
	    
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

		NULL as AnnualNetBudget, ' +
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
		'SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecast,

		NULL as AnnualEstGrossBudget,
		SUM(
			er.Rate *
			CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + 
				/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
				/*Don't use the category mapping here like for actual exclude because we want unknowns to come through*/
				'
					 OR (
							LEFT(pr.ReferenceCode,3) = ''BC:''
							AND ' + STR(@ReforecastEffectivePeriod,6,0) + ' IN (201003, 201006, 201009)
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
							AND ' + STR(@ReforecastEffectivePeriod,6,0) + ' IN (201003, 201006, 201009)
						)
					 ) THEN
				pr.LocalReforecast
			ELSE 
				0
			END
		) as AnnualEstNetReforecast
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

		INNER JOIN #ExchangeRate er ON er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey 
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
		CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE s.SourceName END,
		CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN NULL ELSE pr.GlAccountKey END
	    
	')

	IF (LEN(@cmdString)) > 7995
	BEGIN
		RAISERROR('The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...',9,1)
	END

	PRINT ('Total dynamic sql statement size: ' + STR(LEN(@cmdString)) + '')

	PRINT @cmdString
	EXEC (@cmdString)

END

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
    res.CalendarPeriod AS ActualsExpensePeriod,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
	res.SourceName AS SourceName,
	res.PropertyFundCode,
	CASE WHEN (SUBSTRING(res.SourceName, CHARINDEX(' ', res.SourceName) +1, 8) = 'Property') THEN RTRIM(res.OriginatingRegionCode) + LTRIM(res.FunctionalDepartmentCode) ELSE res.OriginatingRegionCode END AS OriginatingRegionCode,
    --res.OriginatingRegionCode,
    ISNULL(ga.Code, '') GlAccountCode,
    ISNULL(ga.Name, '') GlAccountName,
    
	--Month to date    
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossActual,0) ELSE ISNULL(MtdNetActual,0) END) AS MtdActual,
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossBudget,0) ELSE ISNULL(MtdNetBudget,0) END) AS MtdOriginalBudget,
	--
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast
		END,0) 
	END) 
	AS MtdReforecast,

	--
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast 
		END, 0) - ISNULL(MtdNetActual, 0) 
	END) 
	AS MtdVariance,
	
	--Year to date
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossActual,0) ELSE ISNULL(YtdNetActual,0) END) AS YtdActual,	
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossBudget,0) ELSE ISNULL(YtdNetBudget,0) END) AS YtdOriginalBudget,
	
	--
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast
		END,0) 
	END) 
	AS YtdReforecast,
	
	--
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) 
	AS YtdVariance,
		
	--Annual
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(AnnualGrossBudget,0) ELSE ISNULL(AnnualNetBudget,0) END) AS AnnualOriginalBudget,

	--
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			0 
		ELSE 
			AnnualGrossReforecast
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			0 
		ELSE 
			AnnualNetReforecast
		END,0) 
	END) 
	AS AnnualReforecast
	
	--

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
		LEFT OUTER JOIN GlAccount ga ON ga.GlAccountKey = res.GlAccountKey 
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
	res.CalendarPeriod,
	res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
	res.SourceName,
	res.PropertyFundCode,
	CASE WHEN (SUBSTRING(res.SourceName, CHARINDEX(' ', res.SourceName) +1, 8) = 'Property') THEN RTRIM(res.OriginatingRegionCode) + LTRIM(res.FunctionalDepartmentCode) ELSE res.OriginatingRegionCode END,
    --res.OriginatingRegionCode,
    ISNULL(ga.Code, ''),
    ISNULL(ga.Name, '')

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
	ActualsExpensePeriod,
    EntryDate,
    [User],
    CASE WHEN ((AnnualOriginalBudget <> 0)OR (AnnualReforecast <> 0)) AND  ((MtdActual = 0) OR (YtdActual = 0)) THEN '          [BUDGET/REFORECAST]' ELSE [Description] END as [Description],
    AdditionalDescription,
	SourceName,
	PropertyFundCode,
    OriginatingRegionCode,   
    GlAccountCode,
    GlAccountName,
	
	--Month to date    
	MtdActual,
	MtdOriginalBudget,
	MtdReforecast,
	MtdVariance,

	YtdActual,	
	YtdOriginalBudget,
	YtdReforecast,
	YtdVariance,

	AnnualOriginalBudget,
	AnnualReforecast,
		
	(select DirectIndirect from #DirectIndirectMappings where SourceName = #Output.SourceName) as DirectIndirect

FROM
	#Output
WHERE
	--Month to date    
	MtdActual <> 0.00 OR

	MtdVariance <> 0.00 OR
	
	--Year to date
	YtdActual <> 0.00 OR

	YtdVariance <> 0.00 OR
	
	AnnualOriginalBudget <> 0.00 OR
	AnnualReforecast <> 0.00 


IF 	OBJECT_ID('tempdb..#BudgetOriginatorOwner') IS NOT NULL
    DROP TABLE #BudgetOriginatorOwner

IF 	OBJECT_ID('tempdb..#Output') IS NOT NULL
    DROP TABLE #Output

IF 	OBJECT_ID('tempdb..#ReforecastsEffectivePeriods') IS NOT NULL
	DROP TABLE #ReforecastsEffectivePeriods

IF 	OBJECT_ID('tempdb..#EntityFilterTable') IS NOT NULL
	DROP TABLE #EntityFilterTable
	
IF 	OBJECT_ID('tempdb..#FunctionalDepartmentFilterTable') IS NOT NULL	
	DROP TABLE #FunctionalDepartmentFilterTable
	
IF 	OBJECT_ID('tempdb..#ActivityTypeFilterTable') IS NOT NULL	
	DROP TABLE #ActivityTypeFilterTable

IF 	OBJECT_ID('tempdb..#AllocationRegionFilterTable') IS NOT NULL	
	DROP TABLE #AllocationRegionFilterTable
	
IF 	OBJECT_ID('tempdb..#AllocationSubRegionFilterTable') IS NOT NULL	
	DROP TABLE #AllocationSubRegionFilterTable
	
IF 	OBJECT_ID('tempdb..#MajorAccountCategoryFilterTable') IS NOT NULL	
	DROP TABLE #MajorAccountCategoryFilterTable
	
IF 	OBJECT_ID('tempdb..#MinorAccountCategoryFilterTable') IS NOT NULL	
	DROP TABLE #MinorAccountCategoryFilterTable
	
IF 	OBJECT_ID('tempdb..#OriginatingRegionFilterTable') IS NOT NULL	
	DROP TABLE #OriginatingRegionFilterTable
	
IF 	OBJECT_ID('tempdb..#OriginatingSubRegionFilterTable') IS NOT NULL	
	DROP TABLE #OriginatingSubRegionFilterTable


IF 	OBJECT_ID('tempdb..#DirectIndirectMappings') IS NOT NULL
    DROP TABLE #DirectIndirectMappings




GO


-- 3. stp_R_BudgetOwner.sql

USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOwner]    Script Date: 08/08/2011 20:34:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOwner]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_BudgetOwner]
GO

USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOwner]    Script Date: 08/08/2011 20:34:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/*********************************************************************************************************************
Description
	The stored procedure is used for generating the data for the Budget Owner Report.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-07-08		: PKayongo	:	Sensitized payroll data for the MRI Source, Originating Region Code and 
											Property Fund fields. (CC20)
			2011-07-11		: PKayongo	:	Allowed reforecast values to be dynamically selected from the 
											@ReforecastQuarterName variable. Only 1 reforecast dynamic query remained
											and only the different reforecast fields at the end (i.e. Q1, Q2, Q3)
											were consolidated into 1.
			2011-08-08		: SNothling	:	Set sensitized strings to 'Sensitized' instead of ''

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_R_BudgetOwner]
	@ReportExpensePeriod INT = NULL,
	@ReforecastQuarterName CHAR(2) = NULL, --'Q0' or 'Q1' or 'Q2' or 'Q3'
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
	@OverheadCode Varchar(10)='ALLOC'
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
	@_ReforecastQuarterName VARCHAR(10) = @ReforecastQuarterName,
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



--------------------------------------------------------------------------

DECLARE @CalendarYear AS INT
SET @CalendarYear = CAST(SUBSTRING(CAST(@ReportExpensePeriod AS VARCHAR(10)), 1, 4) AS INT)

--------------------------------------------------------------------------
IF @ReforecastQuarterName IS NULL OR @ReforecastQuarterName NOT IN ('Q0', 'Q1', 'Q2', 'Q3')
	SET @ReforecastQuarterName = (SELECT TOP 1
									ReforecastQuarterName 
								 FROM
									dbo.Reforecast 
								 WHERE
									ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
									ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
								 ORDER BY ReforecastEffectivePeriod DESC)
-- Compute Reforecast Effective Periods

DECLARE @ReforecastEffectivePeriod INT

SET @ReforecastEffectivePeriod = (SELECT TOP 1
										ReforecastEffectivePeriod 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										ReforecastQuarterName = @ReforecastQuarterName
									ORDER BY
										ReforecastEffectivePeriod)								

-- Determine the ReforecastKey of the reforecast that is currently active (i.e.: 2011 Q1, 2011 Q2, 2012 Q0 etc)
DECLARE @ActiveReforecastKey INT = (SELECT ReforecastKey FROM dbo.GetReforecastRecord(@ReportExpensePeriod, @ReforecastQuarterName))

IF (@ActiveReforecastKey IS NULL) -- Safeguard against NULL ReforecastKey returned from previous statement
BEGIN
	SET @ActiveReforecastKey = (SELECT MAX(ReforecastKey) FROM dbo.ExchangeRate)
	PRINT ('Near disaster: @ActiveReforecastKey is NULL, so reverting to the largest/most recent ReforecastKey in dbo.ExchangeRate: ' + @ActiveReforecastKey)
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
	
	--------------------------------------------------------------------------
/*    SETUP DIRECT/INDIRECT MAPPING DATA            */
--------------------------------------------------------------------------

-- Change Control 14. CC Ref 5.4 Create Direct or Indirect field and map Direct to all the properties, and Indirect to all the Corporates
IF  OBJECT_ID('tempdb..#DirectIndirectMappings') IS NOT NULL
		DROP TABLE #DirectIndirectMappings
	
CREATE TABLE #DirectIndirectMappings
	(
      SourceName varchar(50) PRIMARY KEY ,
      DirectIndirect varchar (10),
	)
	
INSERT INTO #DirectIndirectMappings
	SELECT SourceName, 'Direct' AS DirectIndirect FROM Source WHERE IsProperty = 'YES'
	UNION
	SELECT SourceName, 'Indirect' AS DirectIndirect FROM Source WHERE IsCorporate = 'YES'
	UNION
	SELECT SourceName, '-' AS DirectIndirect FROM Source WHERE IsCorporate = 'NO' AND IsProperty = 'NO'

--------------------------------------------------------------------------
/*    END SETUP DIRECT/INDIRECT MAPPING DATA        */
--------------------------------------------------------------------------

	
--------------------------------------------------------------------------
/*    SETUP LOCAL/NON-LOCAL MAPPING DATA            */
--------------------------------------------------------------------------

-- Change Control 14. CC Ref 4.1 Create Direct or Indirect field and map Direct to all the properties, and Indirect to all the Corporates
IF  OBJECT_ID('tempdb..#LocalNonLocalMappings') IS NOT NULL
		DROP TABLE #LocalNonLocalMappings
	
CREATE TABLE #LocalNonLocalMapping
	(
      OriginatingRegionName varchar (50),
      OriginatingSubRegionName varchar(50),
      AllocationRegionName varchar (50),
      AllocationSubRegionName varchar(50),
      LocalNonLocal varchar (10),
	)
	
INSERT INTO #LocalNonLocalMapping
	SELECT [OR].RegionName, [OR].SubRegionName, AR.RegionName, AR.SubRegionName, 'Local' 
	FROM ProfitabilityActual PA
		INNER JOIN OriginatingRegion [OR] ON PA.OriginatingRegionKey = [OR].OriginatingRegionKey 
		INNER JOIN AllocationRegion AR ON PA.AllocationRegionKey = AR.AllocationRegionKey
	WHERE
		([OR].SubRegionName = AR.SubRegionName AND AR.RegionName <> 'China' AND [OR].RegionName <> 'China')
		OR (AR.RegionName = 'China' AND [OR].RegionName = 'China')
	
	UNION
	
	SELECT [OR].RegionName, [OR].SubRegionName, AR.RegionName, AR.SubRegionName, 'Non-Local' 
	FROM ProfitabilityActual PA
		INNER JOIN OriginatingRegion [OR] ON PA.OriginatingRegionKey = [OR].OriginatingRegionKey 
		INNER JOIN AllocationRegion AR ON PA.AllocationRegionKey = AR.AllocationRegionKey
	WHERE
		([OR].SubRegionName <> AR.SubRegionName AND AR.RegionName <> 'China' AND [OR].RegionName <> 'China')
		OR ([OR].SubRegionName <> AR.SubRegionName AND AR.RegionName = 'China' AND [OR].RegionName <> 'China')
		OR ([OR].SubRegionName <> AR.SubRegionName AND AR.RegionName <> 'China' AND [OR].RegionName = 'China')
		
	UNION
	
	SELECT [OR].RegionName, [OR].SubRegionName, AR.RegionName, AR.SubRegionName, 'Local' 
	FROM ProfitabilityBudget PB
		INNER JOIN OriginatingRegion [OR] ON PB.OriginatingRegionKey = [OR].OriginatingRegionKey 
		INNER JOIN AllocationRegion AR ON PB.AllocationRegionKey = AR.AllocationRegionKey
	WHERE
		([OR].SubRegionName = AR.SubRegionName AND AR.RegionName <> 'China' AND [OR].RegionName <> 'China')
		OR (AR.RegionName = 'China' AND [OR].RegionName = 'China')
	
	UNION
	
	SELECT [OR].RegionName, [OR].SubRegionName, AR.RegionName, AR.SubRegionName, 'Non-Local' 
	FROM ProfitabilityBudget PB
		INNER JOIN OriginatingRegion [OR] ON PB.OriginatingRegionKey = [OR].OriginatingRegionKey 
		INNER JOIN AllocationRegion AR ON PB.AllocationRegionKey = AR.AllocationRegionKey
	WHERE
		([OR].SubRegionName <> AR.SubRegionName AND AR.RegionName <> 'China' AND [OR].RegionName <> 'China')
		OR ([OR].SubRegionName <> AR.SubRegionName AND AR.RegionName = 'China' AND [OR].RegionName <> 'China')
		OR ([OR].SubRegionName <> AR.SubRegionName AND AR.RegionName <> 'China' AND [OR].RegionName = 'China')
		
			UNION
	
	SELECT [OR].RegionName, [OR].SubRegionName, AR.RegionName, AR.SubRegionName, 'Local' 
	FROM ProfitabilityReforecast PR
		INNER JOIN OriginatingRegion [OR] ON PR.OriginatingRegionKey = [OR].OriginatingRegionKey 
		INNER JOIN AllocationRegion AR ON PR.AllocationRegionKey = AR.AllocationRegionKey
	WHERE
		([OR].SubRegionName = AR.SubRegionName AND AR.RegionName <> 'China' AND [OR].RegionName <> 'China')
		OR (AR.RegionName = 'China' AND [OR].RegionName = 'China')
	
	UNION
	
	SELECT [OR].RegionName, [OR].SubRegionName, AR.RegionName, AR.SubRegionName, 'Non-Local' 
	FROM ProfitabilityReforecast PR
		INNER JOIN OriginatingRegion [OR] ON PR.OriginatingRegionKey = [OR].OriginatingRegionKey 
		INNER JOIN AllocationRegion AR ON PR.AllocationRegionKey = AR.AllocationRegionKey
	WHERE
		([OR].SubRegionName <> AR.SubRegionName AND AR.RegionName <> 'China' AND [OR].RegionName <> 'China')
		OR ([OR].SubRegionName <> AR.SubRegionName AND AR.RegionName = 'China' AND [OR].RegionName <> 'China')
		OR ([OR].SubRegionName <> AR.SubRegionName AND AR.RegionName <> 'China' AND [OR].RegionName = 'China')


--------------------------------------------------------------------------
/*    END SETUP LOCAL/NON-LOCAL MAPPING DATA        */
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
	PropertyFundCode			Varchar(11) DEFAULT(''), --Varchar, for this helps to keep reports size smaller
	OriginatingRegionCode		Varchar(30) DEFAULT(''), --Varchar, for this helps to keep reports size smaller
	FunctionalDepartmentCode	Varchar(15) DEFAULT(''),
	GlAccountKey				Int NULL,
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
	AnnualNetBudget				MONEY,
	AnnualNetReforecast			MONEY,

	--Annual estimated
	AnnualEstGrossBudget		MONEY,
	AnnualEstGrossReforecast	MONEY,
	AnnualEstNetBudget			MONEY,
	AnnualEstNetReforecast		MONEY
)

DECLARE @cmdString	VARCHAR(MAX)
DECLARE @cmdString2	VARCHAR(MAX)
DECLARE @cmdString3	VARCHAR(MAX)

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
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE s.SourceName END,
    CONVERT(varchar(10),ISNULL(pa.EntryDate,''''), 101) as EntryDate,
    ISNULL(pa.[User], '''') [User],
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.Description ELSE '''' END as Description,
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.AdditionalDescription ELSE '''' END as AdditionalDescription,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE ISNULL(pa.PropertyFundCode, '''') END as PropertyFundCode,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE ISNULL(pa.OriginatingRegionCode, '''') END as OriginatingRegionCode,
    ISNULL(pa.FunctionalDepartmentCode, '''') FunctionalDepartmentCode,
    pa.GlAccountKey,
    c.CalendarPeriod,
    
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
	
	NULL as MtdGrossReforecast,
	
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
	
	NULL as MtdNetReforecast,	

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
	
	' + /*-- YtdGrossReforecast --------------------------*/ + '
	
	NULL as YtdGrossReforecast,	
	
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
	
	')
	
	SET @cmdString2 = (Select '	
	
	NULL as YtdNetReforecast,

	' + /*-- YtdNetReforecast End --------------------------*/ + '
	
	NULL as AnnualGrossBudget,
	
	' + /*-- AnnualGrossReforecast --------------------------*/ + '
	
	NULL as AnnualGrossReforecast,

	' + /*-- AnnualGrossReforecast End --------------------------*/ + '

	NULL as AnnualNetBudget,
	
	' + /*-- AnnualNetReforecast --------------------------*/ + '
	
    NULL as AnnualNetReforecast,

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
	
	NULL as AnnualEstGrossReforecast,

	' + /*-- AnnualEstGrossReforecast End --------------------------*/ + '

	')
	
	SET @cmdString3 = (Select '

    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
    
    ' + /*-- AnnualEstNetReforecast --------------------------*/ + '
    
	NULL as AnnualEstNetReforecast	
	
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
    
    INNER JOIN #ExchangeRate er ON er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
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
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE s.SourceName END,
	CONVERT(varchar(10),ISNULL(pa.EntryDate,''''), 101),
	ISNULL(pa.[User], '''') ,
	CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.Description ELSE '''' END,
	CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.AdditionalDescription ELSE '''' END,
	CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE ISNULL(pa.PropertyFundCode, '''') END,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE ISNULL(pa.OriginatingRegionCode, '''') END,
    ISNULL(pa.FunctionalDepartmentCode, ''''),
	pa.GlAccountKey,
	c.CalendarPeriod
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
INSERT INTO #BudgetOriginatorOwnerEntity
SELECT 
	pb.ActivityTypeKey,
    gac.GlAccountCategoryKey,
    pb.AllocationRegionKey,
    pb.OriginatingRegionKey,
    pb.FunctionalDepartmentKey,
    pb.PropertyFundKey,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE s.SourceName END,
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' as OriginatingRegionCode,
    '''' as FunctionalDepartmentCode,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN NULL ELSE pb.GlAccountKey END,
    '''' as CalendarPeriod,
    
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

	SUM(er.Rate * r.MultiplicationFactor * pb.LocalBudget) as AnnualNetBudget,
	
	NULL as AnnualNetReforecast,

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
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE s.SourceName END,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN NULL ELSE pb.GlAccountKey END
')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR('The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...',9,1)
END

PRINT ('Total dynamic sql statement size: ' + STR(LEN(@cmdString)) + '')

PRINT @cmdString
EXEC (@cmdString)

-- Get reforecast information
IF @ReforecastQuarterName IN ('Q1', 'Q2', 'Q3')
BEGIN

	SET @cmdString = (Select '
	INSERT INTO #BudgetOriginatorOwnerEntity
	SELECT
		pr.ActivityTypeKey, 
		gac.GlAccountCategoryKey,
		pr.AllocationRegionKey,
		pr.OriginatingRegionKey,
		pr.FunctionalDepartmentKey,
		pr.PropertyFundKey,
		CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE s.SourceName END,
		'''' as EntryDate,
		'''' as [User],
		'''' as Description,
		'''' as AdditionalDescription,
		'''' as PropertyFundCode,
		'''' as OriginatingRegionCode,
		'''' as FunctionalDepartmentCode,
		CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN NULL ELSE pr.GlAccountKey END,
		'''' as CalendarPeriod,
	    
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
		
		NULL as AnnualNetBudget,' +
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
		'SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecast,

		NULL as AnnualEstGrossBudget,	
		
		SUM(
			er.Rate *
			CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + 
				/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
				/*Don't use the category mapping here like for actual exclude because we want unknowns to come through*/
				'
					 OR (
							LEFT(pr.ReferenceCode,3) = ''BC:''
							AND ' + STR(@ReforecastEffectivePeriod,6,0) + ' IN (201003, 201006, 201009)
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
							AND ' + STR(@ReforecastEffectivePeriod,6,0) + ' IN (201003, 201006, 201009)
						)
					 ) THEN
				pr.LocalReforecast
			ELSE 
				0
			END
		) as AnnualEstNetReforecast

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
	GROUP BY
		pr.ActivityTypeKey,
		gac.GlAccountCategoryKey,
		pr.AllocationRegionKey,
		pr.OriginatingRegionKey,
		pr.FunctionalDepartmentKey,
		pr.PropertyFundKey,
		CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE s.SourceName END,
		CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN NULL ELSE pr.GlAccountKey END
	')

	IF (LEN(@cmdString)) > 7995
	BEGIN
		RAISERROR('The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...',9,1)
	END

	PRINT ('Total dynamic sql statement size: ' + STR(LEN(@cmdString)) + '')

	PRINT @cmdString
	EXEC (@cmdString)

END

-------------------------------------------------------------------------------------------------------


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
    res.CalendarPeriod AS ActualsExpensePeriod,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
	res.SourceName AS SourceName,
	res.PropertyFundCode,
    CASE WHEN (SUBSTRING(res.SourceName, CHARINDEX(' ', res.SourceName) +1, 8) = 'Property') THEN RTRIM(res.OriginatingRegionCode) + LTRIM(res.FunctionalDepartmentCode) ELSE res.OriginatingRegionCode END AS OriginatingRegionCode,
    --res.OriginatingRegionCode,
    
	ISNULL(ga.Code, '') GlAccountCode,
    ISNULL(ga.Name, '') GlAccountName,
	
	--Month to date    
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossActual,0) ELSE ISNULL(MtdNetActual,0) END) AS MtdActual,
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossBudget,0) ELSE ISNULL(MtdNetBudget,0) END) AS MtdOriginalBudget,
	
	----------
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast
		END,0) 
	END) AS MtdReforecast,
	
	----------
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast
		END, 0) - ISNULL(MtdNetActual, 0) 
	END) AS MtdVariance,	
	
	----------
	
	--Year to date
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossActual,0) ELSE ISNULL(YtdNetActual,0) END) AS YtdActual,	
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossBudget,0) ELSE ISNULL(YtdNetBudget,0) END) AS YtdOriginalBudget,
	
	----------
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast
		END,0) 
	END) AS YtdReforecast,

	----------
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) AS YtdVariance,

	----------
	
	--Annual
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(AnnualGrossBudget,0) ELSE ISNULL(AnnualNetBudget,0) END) AS AnnualOriginalBudget,	
	----------
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			0 
		ELSE 
			AnnualGrossReforecast
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			0 
		ELSE 
			AnnualNetReforecast
		END,0) 
	END) AS AnnualReforecast
	
	--
	
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
		LEFT OUTER JOIN GlAccount ga ON ga.GlAccountKey = res.GlAccountKey 
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
    res.CalendarPeriod,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
    res.SourceName,
    res.PropertyFundCode,
    CASE WHEN (SUBSTRING(res.SourceName, CHARINDEX(' ', res.SourceName) +1, 8) = 'Property') THEN RTRIM(res.OriginatingRegionCode) + LTRIM(res.FunctionalDepartmentCode) ELSE res.OriginatingRegionCode END,
    --res.OriginatingRegionCode,
    ISNULL(ga.Code, ''),
    ISNULL(ga.Name, '')

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
    ActualsExpensePeriod,
    EntryDate,
    [User],
    CASE WHEN ((AnnualOriginalBudget <> 0)OR (AnnualReforecast <> 0)) AND  ((MtdActual = 0) OR (YtdActual = 0)) THEN '          [BUDGET/REFORECAST]' ELSE [Description] END as [Description],
    AdditionalDescription,
	SourceName,
	PropertyFundCode,
    OriginatingRegionCode,
    GlAccountCode,
    GlAccountName,
	
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
	
	--Annual Estimated
	--AnnualEstimatedActual,
	--AnnualEstimatedVariance

	-- Change Control 14. CC Ref 4.1 Create Direct or Indirect field and map Direct to all the properties, and Indirect to all the Corporates
	(SELECT LocalNonLocal FROM #LocalNonLocalMapping
	WHERE #LocalNonLocalMapping.AllocationSubRegionName = #Output.AllocationSubRegionName  
	AND #LocalNonLocalMapping.AllocationRegionName = #Output.AllocationRegionName
	AND #LocalNonLocalMapping.OriginatingSubRegionName = #Output.OriginatingSubRegionName
	AND #LocalNonLocalMapping.OriginatingRegionName = #Output.OriginatingRegionName)
	AS LocalNonLocal,
	
	-- Change Control 14. CC Ref 5.4 Create Direct or Indirect field and map Direct to all the properties, and Indirect to all the Corporates
	(SELECT DirectIndirect FROM #DirectIndirectMappings WHERE SourceName = #Output.SourceName) AS DirectIndirect
	
FROM
	#Output
WHERE
	--Month to date    
	MtdActual <> 0.00 OR
	MtdOriginalBudget <> 0.00 OR
	MtdReforecast <> 0.00 OR
	MtdVariance <> 0.00 OR
	
	YtdActual <> 0.00 OR
	YtdOriginalBudget <> 0.00 OR
	YtdReforecast <> 0.00 OR
	YtdVariance <> 0.00 OR

	AnnualOriginalBudget <> 0.00 OR
	AnnualReforecast <> 0.00 
	--AnnualReforecastQ2 <> 0.00 OR
	--AnnualReforecastQ3 <> 0.00
	--Annual Estimated
	--AnnualEstimatedActual <> 0.00 OR
	--AnnualEstimatedVariance <> 0.00

IF 	OBJECT_ID('tempdb..#BudgetOriginatorOwnerEntity') IS NOT NULL
    DROP TABLE #BudgetOriginatorOwnerEntity

IF 	OBJECT_ID('tempdb..#Output') IS NOT NULL
    DROP TABLE #Output

IF 	OBJECT_ID('tempdb..#EntityFilterTable') IS NOT NULL
	DROP TABLE	#EntityFilterTable

IF 	OBJECT_ID('tempdb..#FunctionalDepartmentFilterTable') IS NOT NULL
	DROP TABLE	#FunctionalDepartmentFilterTable
	
IF 	OBJECT_ID('tempdb..#ActivityTypeFilterTable') IS NOT NULL	
	DROP TABLE	#ActivityTypeFilterTable
	
IF 	OBJECT_ID('tempdb..#AllocationRegionFilterTable') IS NOT NULL	
	DROP TABLE	#AllocationRegionFilterTable
	
IF 	OBJECT_ID('tempdb..#AllocationSubRegionFilterTable') IS NOT NULL	
	DROP TABLE	#AllocationSubRegionFilterTable
	
IF 	OBJECT_ID('tempdb..#MajorAccountCategoryFilterTable') IS NOT NULL	
	DROP TABLE	#MajorAccountCategoryFilterTable

IF 	OBJECT_ID('tempdb..#MinorAccountCategoryFilterTable') IS NOT NULL	
	DROP TABLE	#MinorAccountCategoryFilterTable
	
IF 	OBJECT_ID('tempdb..#OriginatingRegionFilterTable') IS NOT NULL	
	DROP TABLE	#OriginatingRegionFilterTable

IF 	OBJECT_ID('tempdb..#OriginatingSubRegionFilterTable') IS NOT NULL	
	DROP TABLE	#OriginatingSubRegionFilterTable

IF 	OBJECT_ID('tempdb..#ReforecastsEffectivePeriods') IS NOT NULL	
	DROP TABLE #ReforecastsEffectivePeriods
	
-- Change Control 14. CC Ref 5.4 Create Direct or Indirect field and map Direct to all the properties, and Indirect to all the Corporates
IF  OBJECT_ID('tempdb..#DirectIndirectMappings') IS NOT NULL
    DROP TABLE #DirectIndirectMappings
    
-- Change Control 14. CC Ref 4.1 Create Direct or Indirect field and map Direct to all the properties, and Indirect to all the Corporates
IF  OBJECT_ID('tempdb..#LocalNonLocalMappings') IS NOT NULL
    DROP TABLE #LocalNonLocalMapping

GO

-- 4. stp_R_ExpenseCzarTotalComparisonDetail.sql
USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzarTotalComparisonDetail]    Script Date: 08/08/2011 20:35:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzarTotalComparisonDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ExpenseCzarTotalComparisonDetail]
GO

USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzarTotalComparisonDetail]    Script Date: 08/08/2011 20:35:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/*********************************************************************************************************************
Description
	The stored procedure is used for generating the data for the Expense Czar Report.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-07-08		: PKayongo	:	Sensitized payroll data for the MRI Source, Originating Region Code and 
											Property Fund fields. (CC20)
			2011-07-11		: PKayongo	:	Allowed reforecast values to be dynamically selected from the 
											@ReforecastQuarterName variable. Only 1 reforecast dynamic query remained
											and only the different reforecast fields at the end (i.e. Q1, Q2, Q3)
											were consolidated into 1.
			2011-07-18		: PKayongo	:	The Expense Czar Detail report was renamed to the Expense Czar report.
			2011-08-08		: PKayongo	:	Annual Reforecast = 0 when ReforecastQuarterName = "Q0"
			2011-08-08		: SNothling	:	Set sensitized strings to 'Sensitized' instead of ''
										
**********************************************************************************************************************/


CREATE PROCEDURE [dbo].[stp_R_ExpenseCzarTotalComparisonDetail]
	@ReportExpensePeriod INT = NULL,
	@ReforecastQuarterName CHAR(2) = NULL, --'Q0' or 'Q1' or 'Q2' or 'Q3'
	@PreviousReforecastQuarterName VARCHAR(10) = 'Q1', -- or 'Q2' or 'Q3'
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
	@_ReforecastQuarterName VARCHAR(10) = @ReforecastQuarterName,
	@_PreviousReforecastQuarterName VARCHAR(10) = @PreviousReforecastQuarterName,
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
	
-- let latest reforecast (it will be zero if there is no data for the reforecast)
IF @ReforecastQuarterName IS NULL OR @ReforecastQuarterName NOT IN ('Q0', 'Q1', 'Q2', 'Q3')
	SET @ReforecastQuarterName = (SELECT TOP 1
									ReforecastQuarterName 
								 FROM
									dbo.Reforecast 
								 WHERE
									ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
									ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
								 ORDER BY
									ReforecastEffectivePeriod DESC)

-- Compute Reforecast Effective Periods

DECLARE @ReforecastEffectivePeriod INT

SET @ReforecastEffectivePeriod = (SELECT TOP 1
										ReforecastEffectivePeriod 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										ReforecastQuarterName = @ReforecastQuarterName
									ORDER BY
										ReforecastEffectivePeriod)		
										
-----------------------------------------------------------------------------------
										
-- Determine the ReforecastKey of the reforecast that is currently active (i.e.: 2011 Q1, 2011 Q2, 2012 Q0 etc)
DECLARE @ActiveReforecastKey INT = (SELECT ReforecastKey FROM dbo.GetReforecastRecord(@ReportExpensePeriod, @ReforecastQuarterName))

IF (@ActiveReforecastKey IS NULL) -- Safeguard against NULL ReforecastKey returned from previous statement
BEGIN
	SET @ActiveReforecastKey = (SELECT MAX(ReforecastKey) FROM dbo.ExchangeRate)
	PRINT ('Near disaster: @ActiveReforecastKey is NULL, so reverting to the largest/most recent ReforecastKey in dbo.ExchangeRate: ' + @ActiveReforecastKey)
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
	
CREATE TABLE #EntityFilterTable (PropertyFundKey Int NOT NULL)
CREATE TABLE #FunctionalDepartmentFilterTable (FunctionalDepartmentKey Int NOT NULL)
CREATE TABLE #ActivityTypeFilterTable (ActivityTypeKey Int NOT NULL)
CREATE TABLE #AllocationRegionFilterTable (AllocationRegionKey Int NOT NULL)
CREATE TABLE #AllocationSubRegionFilterTable	(AllocationRegionKey Int NOT NULL)
CREATE TABLE #MajorAccountCategoryFilterTable (GlAccountCategoryKey Int NOT NULL)	
CREATE TABLE #MinorAccountCategoryFilterTable (GlAccountCategoryKey Int NOT NULL)	
CREATE TABLE #OriginatingRegionFilterTable (OriginatingRegionKey Int NOT NULL)
CREATE TABLE #OriginatingSubRegionFilterTable (OriginatingRegionKey Int NOT NULL)	
CREATE TABLE #CategoryActivityGroupFilterTable (GlAccountCategoryKey Int NOT NULL, ActivityTypeKey Int NULL)	

CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable (PropertyFundKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable (FunctionalDepartmentKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable (ActivityTypeKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationRegionFilterTable (AllocationRegionKey)
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
	INSERT INTO #OriginatingSubRegionFilterTable
	SELECT orr.OriginatingRegionKey  
	From dbo.Split(@OriginatingSubRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.SubRegionName = t1.item
	END		
	
IF EXISTS(SELECT * FROM @CategoryActivityGroups)
	BEGIN
	INSERT INTO #CategoryActivityGroupFilterTable
	SELECT gl.GlAccountCategoryKey, at.ActivityTypeKey 
	FROM @CategoryActivityGroups cag
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
	GlAccountCategoryKey	INT,
    FunctionalDepartmentKey	INT,
    AllocationRegionKey		INT,
	OriginatingRegionKey	INT,    
    PropertyFundKey			INT,
	SourceName				VARCHAR(50),
	EntryDate				VARCHAR(10),
	[User]					NVARCHAR(20),
	[Description]			NVARCHAR(60),
	AdditionalDescription	NVARCHAR(4000),
	PropertyFundCode		VARCHAR(11) DEFAULT(''), --Varchar, for this helps to keep reports size smaller
	OriginatingRegionCode	VARCHAR(30) DEFAULT(''), --Varchar, for this helps to keep reports size smaller
	OriginatingRegionName   VARCHAR(250) DEFAULT(''),
	FunctionalDepartmentCode VARCHAR(15) DEFAULT(''),
	GlAccountKey			INT NULL,
	CalendarPeriod			Varchar(6) DEFAULT(''),

	--Month to date	
	MtdGrossActual			MONEY,
	MtdGrossBudget			MONEY,
	MtdGrossReforecast		MONEY,
	MtdNetActual			MONEY,
	MtdNetBudget			MONEY,
	MtdNetReforecast		MONEY,
	
	--Year to date
	YtdGrossActual			MONEY,	
	YtdGrossBudget			MONEY, 
	YtdGrossReforecast		MONEY,
	YtdNetActual			MONEY, 
	YtdNetBudget			MONEY, 
	YtdNetReforecast		MONEY,

	--Annual	
	AnnualGrossBudget		MONEY,
	AnnualGrossReforecast	MONEY,

	AnnualNetBudget			MONEY,
	AnnualNetReforecast		MONEY,


	--Annual estimated
	AnnualEstGrossBudget	MONEY,
	AnnualEstGrossReforecast MONEY,
	
	AnnualEstNetBudget		MONEY,
	AnnualEstNetReforecast	MONEY
)

DECLARE @cmdString VARCHAR(8000)

--Get actual information
SET @cmdString = (SELECT '
	
INSERT INTO #ExpenseCzarTotalComparisonDetail
SELECT 
	gac.GlAccountCategoryKey,
    pa.FunctionalDepartmentKey,
    pa.AllocationRegionKey,
    pa.OriginatingRegionKey,
    pa.PropertyFundKey,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE s.SourceName END,
    CONVERT(varchar(10),ISNULL(pa.EntryDate,''''), 101) as EntryDate,
    ISNULL(pa.[User], '''') [User],
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.Description ELSE '''' END as Description,
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.AdditionalDescription ELSE '''' END as AdditionalDescription,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE ISNULL(pa.PropertyFundCode, '''') END PropertyFundCode,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE ISNULL(pa.OriginatingRegionCode, '''') END OriginatingRegionCode,
    ISNULL(ORR.SubRegionName, '''') AS OriginatingRegionName,
    
    ISNULL(pa.FunctionalDepartmentCode, '''') FunctionalDepartmentCode,
    pa.GlAccountKey,
    c.CalendarPeriod,
    
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdGrossActual,
	NULL as MtdGrossBudget,
	
	' + /*--  --------------------------*/ + '
	
	NULL as MtdGrossReforecast,
	
	' + /*--  --------------------------*/ + '
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdNetActual,
	NULL as MtdNetBudget,
	
	' + /*--  --------------------------*/ + '
	
	NULL as MtdNetReforecast,

	' + /*--  --------------------------*/ + '
	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdGrossActual,
	NULL as YtdGrossBudget,
	
	' + /*--  --------------------------*/ + '
	
	NULL as YtdGrossReforecast,

	')
	
	DECLARE @cmdString2 VARCHAR(8000)
	SET @cmdString2 = (SELECT '

	' + /*--  --------------------------*/ + '
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdNetActual,
	NULL as YtdNetBudget,
	
	' + /*--  --------------------------*/ + '
	
	NULL as YtdNetReforecast,
	
	' + /*--  --------------------------*/ + '
	
	NULL as AnnualGrossBudget,
	
	' + /*--  --------------------------*/ + '
	
	NULL as AnnualGrossReforecast,

	' + /*--  --------------------------*/ + '

	NULL as AnnualNetBudget,
	
	' + /*--  --------------------------*/ + '
	
    NULL as AnnualNetReforecast,

	' + /*--  --------------------------*/ + '
		
	SUM(
        er.Rate *
        CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pa.LocalActual
        ELSE 
			0
        END
	) as AnnualEstGrossBudget,
	
	' + /*--  --------------------------*/ + '
	
	')
	
	DECLARE @cmdString3 VARCHAR(8000)
	SET @cmdString3 = (SELECT '
	
	NULL as AnnualEstGrossReforecast,

	' + /*--  --------------------------*/ + '

    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
    
    ' + /*--  --------------------------*/ + '
    
	NULL as AnnualEstNetReforecast
	
	' + /*--  --------------------------*/ + '
	
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
				ELSE 'break:not valid TranslationTypeName' END + '
				AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')
				
	    INNER JOIN #ExchangeRate er ON  er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
	    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
	    INNER JOIN Calendar c ON  c.CalendarKey = pa.CalendarKey
	    INNER JOIN Source s ON s.SourceKey = pa.SourceKey
	    INNER JOIN OriginatingRegion ORR ON
			ORR.OriginatingRegionKey = PA.OriginatingRegionKey
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
GROUP BY
	gac.GlAccountCategoryKey,
    pa.FunctionalDepartmentKey,
    pa.AllocationRegionKey,
    pa.OriginatingRegionKey,
    pa.PropertyFundKey,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE s.SourceName END,
	CONVERT(varchar(10),ISNULL(pa.EntryDate,''''), 101),
	pa.[User],
	CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.Description ELSE '''' END,
	CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.AdditionalDescription ELSE '''' END,
	CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE ISNULL(pa.PropertyFundCode, '''') END,
	CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE ISNULL(pa.OriginatingRegionCode, '''') END,
	ISNULL(ORR.SubRegionName, ''''),
	ISNULL(pa.FunctionalDepartmentCode, ''''),
	pa.GlAccountKey,
	c.CalendarPeriod

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

INSERT INTO #ExpenseCzarTotalComparisonDetail
SELECT 
	gac.GlAccountCategoryKey,
	pb.FunctionalDepartmentKey,
	pb.AllocationRegionKey,
	pb.OriginatingRegionKey,
	pb.PropertyFundKey,
	CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE s.SourceName END,
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' as OriginatingRegionCode,
    '''' as OriginatingRegionName,
    '''' as FunctionalDepartmentCode,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN NULL ELSE pb.GlAccountKey END,
	'''' as CalendarPeriod,
    
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

	SUM(er.Rate * r.MultiplicationFactor * pb.LocalBudget) as AnnualNetBudget,
	NULL as AnnualNetReforecast,

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
		ELSE 'break:not valid TranslationTypeName' END + '
		AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')	

    INNER JOIN #ExchangeRate er ON  er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey
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
GROUP BY
	gac.GlAccountCategoryKey,
    pb.FunctionalDepartmentKey,
    pb.AllocationRegionKey,
    pb.OriginatingRegionKey,
    pb.PropertyFundKey,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE s.SourceName END,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN NULL ELSE pb.GlAccountKey END
')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR('The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...',9,1)
END

PRINT ('Total dynamic sql statement size: ' + STR(LEN(@cmdString)) + '')

PRINT @cmdString
EXEC (@cmdString)

IF @ReforecastQuarterName in ('Q1', 'Q2', 'Q3')
BEGIN
----------------------------------------------------------------------------------------------------
-- Get Q1 reforecast information
	SET @cmdString = (Select '	

	INSERT INTO #ExpenseCzarTotalComparisonDetail
	SELECT 
		gac.GlAccountCategoryKey,
		pr.FunctionalDepartmentKey,
		pr.AllocationRegionKey,
		pr.OriginatingRegionKey,
		pr.PropertyFundKey,
		CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE s.SourceName END,
		'''' as EntryDate,
		'''' as [User],
		'''' as Description,
		'''' as AdditionalDescription,
		'''' as PropertyFundCode,
		'''' as OriginatingRegionCode,
		'''' as OriginatingRegionName,
		'''' as FunctionalDepartmentCode,
		CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN NULL ELSE pr.GlAccountKey END,
		'''' as CalendarPeriod,
	    
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

		NULL as AnnualNetBudget, ' +
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
		'SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecast,

		NULL as AnnualEstGrossBudget,
		SUM(
			er.Rate *
			CASE WHEN (c.CalendarPeriod > ' + STR(@ReportExpensePeriod,6,0) + 
				/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
				/*Don't use the category mapping here like for actual exclude because we want unknowns to come through*/
				'
					 OR (
							LEFT(pr.ReferenceCode,3) = ''BC:''
							AND ' + STR(@ReforecastEffectivePeriod,6,0) + ' IN (201003, 201006, 201009)
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
							AND ' + STR(@ReforecastEffectivePeriod,6,0) + ' IN (201003, 201006, 201009)
						)
					 ) THEN
				pr.LocalReforecast
			ELSE 
				0
			END
		) as AnnualEstNetReforecast

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
				ELSE 'break:not valid TranslationTypeName' END + '
				AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')	

		INNER JOIN #ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
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
	GROUP BY
		gac.GlAccountCategoryKey,
		pr.FunctionalDepartmentKey,
		pr.AllocationRegionKey,
		pr.OriginatingRegionKey,
		pr.PropertyFundKey,
		CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN ''Sensitized'' ELSE s.SourceName END,
		CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN NULL ELSE pr.GlAccountKey END

	')

	IF (LEN(@cmdString)) > 7995
	BEGIN
		RAISERROR('The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...',9,1)
	END

	PRINT ('Total dynamic sql statement size: ' + STR(LEN(@cmdString)) + '')

	PRINT @cmdString
	EXEC (@cmdString)

END

------------------------------------------------------------------------------------------------------------------------------------

CREATE CLUSTERED INDEX IX ON #ExpenseCzarTotalComparisonDetail(
	PropertyFundKey,
	AllocationRegionKey,
	FunctionalDepartmentKey,
	GlAccountCategoryKey
)

SELECT 
	gac.AccountSubTypeName AS ExpenseType,
	gac.MajorCategoryName AS MajorExpenseCategoryName,
    gac.MinorCategoryName AS MinorExpenseCategoryName,    
    fd.FunctionalDepartmentName AS FunctionalDepartmentName,
    fd.FunctionalDepartmentName AS FunctionalDepartmentFilterName,
    ar.SubRegionName AS AllocationSubRegionName,
    ar.SubRegionName AS AllocationSubRegionFilterName,
    CASE WHEN gac.MajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized' ELSE pf.PropertyFundName END AS EntityName,
    CASE WHEN gac.MajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized' ELSE pf.PropertyFundName END AS EntityFilterName,
    pf.PropertyFundType AS EntityType,
    res.CalendarPeriod AS ActualsExpensePeriod,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
    res.SourceName AS SourceName,
    res.PropertyFundCode,
    CASE WHEN (SUBSTRING(res.SourceName, CHARINDEX(' ', res.SourceName) +1, 8) = 'Property') THEN RTRIM(res.OriginatingRegionCode) + LTRIM(res.FunctionalDepartmentCode) ELSE res.OriginatingRegionCode END AS OriginatingRegionCode,
    oreg.SubRegionName AS OriginatingRegionName, 
    oreg.SubRegionName AS OriginatingRegionFilterName,
    
    --res.OriginatingRegionCode,
    ISNULL(ga.Code, '') GlAccountCode,
    ISNULL(ga.Name, '') GlAccountName,    

	--Month to date    
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossActual,0) ELSE ISNULL(MtdNetActual,0) END) AS MtdActual,
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossBudget,0) ELSE ISNULL(MtdNetBudget,0) END) AS MtdOriginalBudget,
	
	-------------------------------
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecast
		END,0) 
	END) 
	AS MtdReforecast,

	-------------------------------
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecast
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
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
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecast
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecast
		END,0) 
	END) 
	AS YtdReforecast,

	-------------------------------
	
	-------------------------------
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			YtdGrossBudget
		ELSE 
			YtdGrossReforecast
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN 
			YtdNetBudget
		ELSE 
			YtdNetReforecast
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) 
	AS YtdVariance,


	
	--Annual
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(AnnualGrossBudget,0) ELSE ISNULL(AnnualNetBudget,0) END) AS AnnualOriginalBudget,	

	SUM(CASE WHEN (@IsGross = 1) THEN
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN
			0
		ELSE
			AnnualGrossReforecast
		END,0)
	ELSE
		ISNULL(CASE WHEN @ReforecastQuarterName = 'Q0' THEN
			0
		ELSE
			AnnualNetReforecast
		END,0)
	END)
	AS AnnualReforecast

	-------------------------------
INTO
	#Output	
FROM
	#ExpenseCzarTotalComparisonDetail res
	INNER JOIN PropertyFund pf ON pf.PropertyFundKey = res.PropertyFundKey
	INNER JOIN AllocationRegion ar ON ar.AllocationRegionKey = res.AllocationRegionKey
	INNER JOIN OriginatingRegion oreg ON oreg.OriginatingRegionKey = res.OriginatingRegionKey
	INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentKey = res.FunctionalDepartmentKey
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = res.GlAccountCategoryKey 
	LEFT OUTER JOIN GlAccount ga ON ga.GlAccountKey = res.GlAccountKey 
GROUP BY
	gac.AccountSubTypeName,
	gac.MajorCategoryName,
    gac.MinorCategoryName,
    fd.FunctionalDepartmentName,
    ar.SubRegionName,
    CASE WHEN gac.MajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized' ELSE pf.PropertyFundName END,
    pf.PropertyFundType,
    res.CalendarPeriod,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
    res.SourceName,
    res.PropertyFundCode,
    CASE WHEN (SUBSTRING(res.SourceName, CHARINDEX(' ', res.SourceName) +1, 8) = 'Property') THEN RTRIM(res.OriginatingRegionCode) + LTRIM(res.FunctionalDepartmentCode) ELSE res.OriginatingRegionCode END,
    oreg.SubRegionName,

    --res.OriginatingRegionCode,
    ISNULL(ga.Code, ''),
    ISNULL(ga.Name, '')
	
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
    EntityType,
    ActualsExpensePeriod,
    EntryDate,
    [User],
    CASE WHEN ((AnnualOriginalBudget <> 0)OR (AnnualReforecast <> 0)) AND  ((MtdActual = 0) OR (YtdActual = 0)) THEN '          [BUDGET/REFORECAST]' ELSE [Description] END as [Description],
    --[Description],
    AdditionalDescription,
    SourceName,
    PropertyFundCode,
    OriginatingRegionCode,
    OriginatingRegionName as ORiginatingRegionName,
    GlAccountCode,
    GlAccountName,    
    
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
	EntityName AS EntityFilterName,
	OriginatingRegionName AS OriginatingRegionFilterName
FROM
	#Output
WHERE
	--Month to date    
	MtdActual <> 0.00 OR
	MtdOriginalBudget <> 0.00 OR
	MTDReforecast <> 0.00 OR
	MtdVariance <> 0.00 OR
	
	--Year to date
	YtdActual <> 0.00 OR
	YtdOriginalBudget <> 0.00 OR
	YTDReforecast <> 0.00 OR
	YtdVariance <> 0.00 OR
	
	--Annual
	AnnualOriginalBudget <> 0.00 OR
	AnnualReforecast <> 0.00 


IF 	OBJECT_ID('tempdb..#ExpenseCzarTotalComparisonDetail') IS NOT NULL
    DROP TABLE #ExpenseCzarTotalComparisonDetail

IF 	OBJECT_ID('tempdb..#Output') IS NOT NULL
    DROP TABLE #Output

IF 	OBJECT_ID('tempdb..#EntityFilterTable') IS NOT NULL
	DROP TABLE #EntityFilterTable
	
IF 	OBJECT_ID('tempdb..#FunctionalDepartmentFilterTable') IS NOT NULL
	DROP TABLE #FunctionalDepartmentFilterTable
	
IF 	OBJECT_ID('tempdb..#ActivityTypeFilterTable') IS NOT NULL
	DROP TABLE #ActivityTypeFilterTable
	
IF 	OBJECT_ID('tempdb..#AllocationRegionFilterTable') IS NOT NULL
	DROP TABLE #AllocationRegionFilterTable
	
IF 	OBJECT_ID('tempdb..#AllocationSubRegionFilterTable') IS NOT NULL
	DROP TABLE #AllocationSubRegionFilterTable
	
IF 	OBJECT_ID('tempdb..#MajorAccountCategoryFilterTable') IS NOT NULL
	DROP TABLE #MajorAccountCategoryFilterTable
	
IF 	OBJECT_ID('tempdb..#MinorAccountCategoryFilterTable') IS NOT NULL
	DROP TABLE #MinorAccountCategoryFilterTable
	
IF 	OBJECT_ID('tempdb..#OriginatingRegionFilterTable') IS NOT NULL
	DROP TABLE #OriginatingRegionFilterTable
	
IF 	OBJECT_ID('tempdb..#OriginatingSubRegionFilterTable') IS NOT NULL
	DROP TABLE #OriginatingSubRegionFilterTable
	
IF 	OBJECT_ID('tempdb..#CategoryActivityGroupFilterTable') IS NOT NULL
	DROP TABLE #CategoryActivityGroupFilterTable





GO

-- 5. stp_R_ProfitabilityDetailV2.sql
USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ProfitabilityDetailV2]    Script Date: 08/08/2011 20:36:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ProfitabilityDetailV2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ProfitabilityDetailV2]
GO

USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ProfitabilityDetailV2]    Script Date: 08/08/2011 20:36:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




/*********************************************************************************************************************
Description
	The stored procedure is used for generating the data for detail tab of the Profitability report and to generate
	data for the stp_R_ProfitabilityV2 stored procedure.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-07-08		: PKayongo	:	Sensitized payroll data for the MRI Source, Originating Region Code and 
											Property Fund fields. (CC20)
			2011-07-11		: PKayongo	:	Allowed reforecast values to be dynamically selected from the 
											@ReforecastQuarterName variable. Only 1 reforecast dynamic query remained
											and only the different reforecast fields at the end (i.e. Q1, Q2, Q3)
											were consolidated into 1.
			2011-08-08		: SNothling	:	Set sensitized strings to 'Sensitized' instead of ''

**********************************************************************************************************************/


CREATE PROCEDURE [dbo].[stp_R_ProfitabilityDetailV2]
	@ReportExpensePeriod INT = NULL,
	@DestinationCurrency VARCHAR(3) = NULL,
	@TranslationTypeName VARCHAR(50) = NULL,

	@FunctionalDepartmentList TEXT = NULL,
	@ActivityTypeList TEXT = NULL,
	@EntityList TEXT = NULL,
	@MajorAccountCategoryList TEXT = NULL,
	@MinorAccountCategoryList TEXT = NULL,
	@AllocationRegionList TEXT = NULL,
	@AllocationSubRegionList TEXT = NULL,
	@OriginatingRegionList TEXT = NULL,
	@OriginatingSubRegionList TEXT = NULL,
	@DisplayOverheadBy Varchar(12),
	
	--Customized Filter Logic Specific to this Report
	@IncludeFeeAdjustments TinyInt = NULL,
	@OverheadOriginatingSubRegionList TEXT = NULL,
	@ConsolidationSubRegionList TEXT = NULL
	
	
	
AS

IF ISNULL(@DisplayOverheadBy,'') NOT IN ('Allocated','Unallocated')
	BEGIN
	RAISERROR ('@DisplayOverheadBy have invalid value (Must be one of:Allocated,Unallocated)',18,1)
	RETURN
	END
	
DECLARE

	@_ReportExpensePeriod INT = @ReportExpensePeriod,
	@_DestinationCurrency VARCHAR(3) = @DestinationCurrency,
	@_TranslationTypeName VARCHAR(50) = @TranslationTypeName,
	@_FunctionalDepartmentList VARCHAR(8000) = @FunctionalDepartmentList,
	@_ActivityTypeList VARCHAR(8000) = @ActivityTypeList,
	@_EntityList VARCHAR(8000) = @EntityList,
	@_MajorAccountCategoryList VARCHAR(8000) = @MajorAccountCategoryList,
	@_MinorAccountCategoryList VARCHAR(8000) = @MinorAccountCategoryList,
	@_AllocationRegionList VARCHAR(8000) = @AllocationRegionList,
	@_AllocationSubRegionList VARCHAR(8000) = @AllocationSubRegionList,
	@_ConsolidationSubRegionList VARCHAR(8000) = @ConsolidationSubRegionList,
	@_OriginatingRegionList VARCHAR(8000) = @OriginatingRegionList,
	@_OriginatingSubRegionList VARCHAR(8000) = @OriginatingSubRegionList,
	@_OverheadOriginatingSubRegionList VARCHAR(8000) = @OverheadOriginatingSubRegionList	
			
--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Variable defaults		*/
--------------------------------------------------------------------------

IF @ReportExpensePeriod IS NULL
	SET @ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + REPLACE(STR(MONTH(GETDATE()),2 ),' ','0')AS INT)

IF @DestinationCurrency IS NULL
	SET @DestinationCurrency = 'USD'

IF 	@TranslationTypeName IS NULL
	SET @TranslationTypeName = 'Global'

--------------------------------------------------------------------------

-- Determine the ReforecastKey of the reforecast that is currently active (i.e.: 2011 Q1, 2011 Q2, 2012 Q0 etc)
DECLARE @ActiveReforecastKey INT = (SELECT ReforecastKey FROM dbo.GetCurrentReforecastRecord())

IF (@ActiveReforecastKey IS NULL) -- Safeguard against NULL ReforecastKey returned from previous statement
BEGIN
	SET @ActiveReforecastKey = (SELECT MAX(ReforecastKey) FROM dbo.ExchangeRate)
	PRINT ('Near disaster: @ActiveReforecastKey is NULL, so reverting to the largest/most recent ReforecastKey in dbo.ExchangeRate: ' + @ActiveReforecastKey)
END

--------------------------------------------------------------------------

DECLARE @CalendarYear AS INT
SET @CalendarYear = CAST(SUBSTRING(CAST(@ReportExpensePeriod AS VARCHAR(10)), 1, 4) AS INT)				

DECLARE @ReforecastQuarterName VARCHAR(10)
SET @ReforecastQuarterName = (SELECT TOP 1
								ReforecastQuarterName 
							 FROM
								dbo.Reforecast 
							 WHERE
								ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
								ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
							 ORDER BY ReforecastEffectivePeriod DESC)

DECLARE @ReforecastEffectivePeriodQ1 INT
SET @ReforecastEffectivePeriodQ1 = (SELECT TOP 1 ReforecastEffectivePeriod 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										  ReforecastQuarterName = 'Q1'
									ORDER BY ReforecastEffectivePeriod)								

DECLARE @ReforecastEffectivePeriodQ2 INT
SET @ReforecastEffectivePeriodQ2 = (SELECT TOP 1 ReforecastEffectivePeriod 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										  ReforecastQuarterName = 'Q2'
									ORDER BY ReforecastEffectivePeriod)								

DECLARE @ReforecastEffectivePeriodQ3 INT
SET @ReforecastEffectivePeriodQ3 = (SELECT TOP 1 ReforecastEffectivePeriod 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										  ReforecastQuarterName = 'Q3'
									ORDER BY ReforecastEffectivePeriod)								

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
	
	CREATE TABLE	#EntityFilterTable	(PropertyFundKey Int NOT NULL)
	CREATE TABLE	#FunctionalDepartmentFilterTable	(FunctionalDepartmentKey Int NOT NULL)
	CREATE TABLE	#ActivityTypeFilterTable(ActivityTypeKey Int NOT NULL)
	CREATE TABLE	#AllocationRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#AllocationSubRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#ConsolidationSubRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#MajorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#MinorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#OriginatingRegionFilterTable	(OriginatingRegionKey Int NOT NULL)
	CREATE TABLE	#OriginatingSubRegionFilterTable	(OriginatingRegionKey Int NOT NULL)	
	CREATE TABLE	#OverheadOriginatingSubRegionFilterTable	(OriginatingRegionKey Int NOT NULL)	
		
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable	(PropertyFundKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable(ActivityTypeKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ConsolidationSubRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MajorAccountCategoryFilterTable(GlAccountCategoryKey)	
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MinorAccountCategoryFilterTable(GlAccountCategoryKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingRegionFilterTable	(OriginatingRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable	(OriginatingRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OverheadOriginatingSubRegionFilterTable	(OriginatingRegionKey)
	
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

IF (@ConsolidationSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #ConsolidationSubRegionFilterTable
	Select ar.AllocationRegionKey
	From dbo.Split(@_ConsolidationSubRegionList) t1
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
	
IF (@OverheadOriginatingSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #OverheadOriginatingSubRegionFilterTable
	Select orr.OriginatingRegionKey  
	From dbo.Split(@OverheadOriginatingSubRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.SubRegionName = t1.item
	END	
--------------------------------------------------------------------------
/*	COMMON END															*/
--------------------------------------------------------------------------

IF 	OBJECT_ID('tempdb..#ProfitabilityReport') IS NOT NULL
    DROP TABLE #ProfitabilityReport

CREATE TABLE #ProfitabilityReport
(	
	GlAccountCategoryKey		Int,
    ActivityTypeKey				Int,
    PropertyFundKey				Int,
    AllocationRegionKey			Int,
    ConsolidationRegionKey			Int,
    OriginatingRegionKey		Int,
    SourceKey					Int,
    GlAccountKey				Int,
	ReimbursableKey				Int,
	FeeAdjustmentKey			Int,
	FunctionalDepartmentKey		Int,
	OverheadKey					Int,
	CalendarPeriod				Varchar(6) DEFAULT(''),
	
	EntryDate					VARCHAR(10),
	[User]						NVARCHAR(20),
	[Description]				NVARCHAR(60),
	AdditionalDescription		NVARCHAR(4000),
	PropertyFundCode			Varchar(11) DEFAULT(''), --Varchar, for this helps to keep reports size smaller
	OriginatingRegionCode		Varchar(15) DEFAULT(''), --Varchar, for this helps to keep reports size smaller
	FunctionalDepartmentCode	Varchar(15) DEFAULT(''), --Varchar, for this helps to keep reports size smaller

	--Month to date	
	MtdActual				MONEY,
	MtdBudget				MONEY,
	MtdReforecastQ1		MONEY,
	MtdReforecastQ2		MONEY,
	MtdReforecastQ3		MONEY,
	
	--Year to date
	YtdActual				MONEY,	
	YtdBudget				MONEY, 
	YtdReforecastQ1		MONEY, 
	YtdReforecastQ2		MONEY, 
	YtdReforecastQ3		MONEY, 

	--Annual	
	AnnualBudget			MONEY,
	AnnualReforecastQ1		MONEY,
	AnnualReforecastQ2		MONEY,
	AnnualReforecastQ3		MONEY
)

DECLARE @cmdString Varchar(8000)
DECLARE @cmdString2 Varchar(8000)




--Get actual information
SET @cmdString = (Select '

INSERT INTO #ProfitabilityReport
SELECT 	
	pa.GlobalGlAccountCategoryKey,
    pa.ActivityTypeKey,
    pa.PropertyFundKey,
    pa.AllocationRegionKey,
    pa.ConsolidationRegionKey,
    pa.OriginatingRegionKey,
    pa.SourceKey,
    pa.GlAccountKey,
	pa.ReimbursableKey,
	(Select FeeAdjustmentKey From FeeAdjustment Where FeeAdjustmentCode = ''NORMAL'') FeeAdjustmentKey,
	pa.FunctionalDepartmentKey,
	pa.OverheadKey,
	c.CalendarPeriod,
	
    CONVERT(varchar(10),ISNULL(pa.EntryDate,''''), 101) as EntryDate,
    ISNULL(pa.[User], '''') [User],
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.Description ELSE '''' END as Description,
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.AdditionalDescription ELSE '''' END as AdditionalDescription,
    CASE WHEN (gac.MajorCategoryName = ''Salaries/Taxes/Benefits'') THEN ''Sensitized'' ELSE ISNULL(pa.PropertyFundCode, '''') END as PropertyFundCode,
    CASE WHEN (gac.MajorCategoryName = ''Salaries/Taxes/Benefits'') THEN ''Sensitized'' ELSE ISNULL(pa.OriginatingRegionCode, '''') END OriginatingRegionCode,
	ISNULL(pa.FunctionalDepartmentCode, '''') FunctionalDepartmentCode,
	
    -- Expenses must be displayed as negative an Income is saved in MRI as negative
	SUM(
		er.Rate * -1 *
		CASE WHEN (c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdActual,
	NULL as MtdBudget,
	NULL as MtdReforecastQ1,
	NULL as MtdReforecastQ2,
	NULL as MtdReforecastQ3,
	
	SUM(
		er.Rate * -1 *
		CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdActual,
	NULL as YtdBudget,
	NULL as YtdReforecastQ1,
	NULL as YtdReforecastQ2,
	NULL as YtdReforecastQ3,
	
	NULL as AnnualBudget,
	NULL as AnnualReforecastQ1,
	NULL as AnnualReforecastQ2,
	NULL as AnnualReforecastQ3
FROM
	ProfitabilityActual pa

	INNER JOIN Overhead oh ON oh.OverheadKey = pa.OverheadKey

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
		
    INNER JOIN #ExchangeRate er ON  er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
    INNER JOIN Currency dc ON  dc.CurrencyKey = er.DestinationCurrencyKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pa.ReimbursableKey
    INNER JOIN Calendar c ON  c.CalendarKey = pa.CalendarKey
    INNER JOIN Source s ON s.SourceKey = pa.SourceKey

    INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pa.AllocationRegionKey
    INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey
    INNER JOIN ActivityType a ON  a.ActivityTypeKey = pa.ActivityTypeKey
    INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pa.PropertyFundKey
    INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey
')

SET @cmdString2 = (Select '
WHERE  1 = 1
    AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
'
+ CASE WHEN @DisplayOverheadBy = 'Unallocated' THEN 
			'
		AND (
				(
					gac.AccountSubTypeName	= ''Overhead''
				and	Oh.OverHeadCode			IN (''UNKNOWN'',''UNALLOC'')
				' +
				CASE WHEN @OverheadOriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OverheadOriginatingSubRegionFilterTable t1) ' END +
				'
				)
			OR	(
				gac.AccountSubTypeName		<> ''Overhead''
				'+
				+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable) ' END +
				--+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable) ' END +
				+ CASE WHEN @ConsolidationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #ConsolidationSubRegionFilterTable) ' END +
				'
				)
			)
			'

		ELSE --ALLOC
			'
		AND (
				(
					gac.AccountSubTypeName	<> ''Overhead''
				)
			OR	(
					gac.AccountSubTypeName	= ''Overhead''
				and	Oh.OverHeadCode			IN (''UNKNOWN'',''ALLOC'')
				)
			)
			'
		+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable) ' END +
		--+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable) ' END
		+ CASE WHEN @ConsolidationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #ConsolidationSubRegionFilterTable) ' END

		END +
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select t1.FunctionalDepartmentKey From #FunctionalDepartmentFilterTable t1)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select t1.ActivityTypeKey From #ActivityTypeFilterTable t1)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select t1.PropertyFundKey From #EntityFilterTable t1)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MajorAccountCategoryFilterTable t1)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MinorAccountCategoryFilterTable t1)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingRegionFilterTable t1)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingSubRegionFilterTable t1)' END +
'
Group By
	pa.GlobalGlAccountCategoryKey,
    pa.ActivityTypeKey,
    pa.PropertyFundKey,
    pa.AllocationRegionKey,
    pa.ConsolidationRegionKey,
    pa.OriginatingRegionKey,
    pa.SourceKey,
    pa.GlAccountKey,
	pa.ReimbursableKey,
	pa.FunctionalDepartmentKey,
	pa.OverheadKey,
	c.CalendarPeriod,
	
    CONVERT(varchar(10),ISNULL(pa.EntryDate,''''), 101),
    ISNULL(pa.[User], ''''),
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.Description ELSE '''' END,
    CASE WHEN gac.AccountSubTypeName = ''Non-Payroll'' THEN pa.AdditionalDescription ELSE '''' END,
    CASE WHEN (gac.MajorCategoryName = ''Salaries/Taxes/Benefits'') THEN ''Sensitized'' ELSE ISNULL(pa.PropertyFundCode, '''') END,
    CASE WHEN (gac.MajorCategoryName = ''Salaries/Taxes/Benefits'') THEN ''Sensitized'' ELSE ISNULL(pa.OriginatingRegionCode, '''') END,
	ISNULL(pa.FunctionalDepartmentCode, '''')
	
')
print @cmdString
print @cmdString2
IF LEN(@cmdString) > 7990
	RAISERROR ('Dynamic SQL to large',16,1)
IF LEN(@cmdString2) > 7990
	RAISERROR ('Dynamic SQL to large',16,1)

	
EXEC (@cmdString+@cmdString2)



--Get budget information
SET @cmdString = (Select '

INSERT INTO #ProfitabilityReport
SELECT 
	pb.GlobalGlAccountCategoryKey,
    pb.ActivityTypeKey,
    pb.PropertyFundKey,
    pb.AllocationRegionKey,
    pb.ConsolidationRegionKey,
    pb.OriginatingRegionKey,
    pb.SourceKey,
    pb.GlAccountKey,
	pb.ReimbursableKey,
	pb.FeeAdjustmentKey,
	pb.FunctionalDepartmentKey,
	pb.OverheadKey,
	'''' as CalendarPeriod,
	
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' as OriginatingRegionCode,
	'''' as FunctionalDepartmentCode,
	
    --Expenses must be displayed as negative
    NULL as MtdActual,
	SUM(
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
	) as MtdBudget,
	NULL as MtdReforecastQ1,
	NULL as MtdReforecastQ2,
	NULL as MtdReforecastQ3,
	
	NULL as YtdActual,	
	SUM(
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
	) as YtdBudget, 
	NULL as YtdReforecastQ1, 
	NULL as YtdReforecastQ2, 
	NULL as YtdReforecastQ3, 
	
	SUM(er.Rate * pb.LocalBudget * (CASE WHEN gac.FeeOrExpense = ''INCOME'' THEN
									1
								  ELSE
									-1 
								  END)) as AnnualBudget,
	NULL as AnnualReforecastQ1,
	NULL as AnnualReforecastQ2,
	NULL as AnnualReforecastQ3
	
FROM
	ProfitabilityBudget pb --WITH (INDEX=IX_Clustered)

	INNER JOIN Overhead oh ON oh.OverheadKey = pb.OverheadKey
	
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
			
    INNER JOIN #ExchangeRate er ON er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey
    INNER JOIN Currency dc ON er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pb.CalendarKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pb.ReimbursableKey
    INNER JOIN Source s ON s.SourceKey = pb.SourceKey

    INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey
    INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey
    INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey
    INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey
    INNER JOIN ActivityType a ON a.ActivityTypeKey = pb.ActivityTypeKey
    INNER JOIN FeeAdjustment Fa ON Fa.FeeAdjustmentKey = pb.FeeAdjustmentKey

WHERE  1 = 1
    AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */'
	
+ CASE WHEN @DisplayOverheadBy = 'Unallocated' THEN 
			'
		AND (
				(
					gac.AccountSubTypeName	= ''Overhead''
				and	Oh.OverHeadCode			IN (''UNKNOWN'',''UNALLOC'')
				' +
				CASE WHEN @OverheadOriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OverheadOriginatingSubRegionFilterTable t1) ' END +
				'
				)
			OR	(
				gac.AccountSubTypeName		<> ''Overhead''
				'+
				+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable) ' END +
				--+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable) ' END +
				+ CASE WHEN @ConsolidationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #ConsolidationSubRegionFilterTable) ' END +
				'
				)
			)
			'

		ELSE --ALLOC
			'
		AND (
				(
					gac.AccountSubTypeName	<> ''Overhead''
				)
			OR	(
					gac.AccountSubTypeName	= ''Overhead''
				and	Oh.OverHeadCode			IN (''UNKNOWN'',''ALLOC'')
				)
			)
			'
		+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable) ' END +
		--+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable) ' END
		+ CASE WHEN @ConsolidationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #ConsolidationSubRegionFilterTable) ' END

		END +
	
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
+ CASE WHEN @IncludeFeeAdjustments = 1 THEN ' AND Fa.FeeAdjustmentCode IN (''NORMAL'',''FEEADJUST'')' ELSE ' AND Fa.FeeAdjustmentCode IN (''NORMAL'')' END +
'
Group By
	pb.GlobalGlAccountCategoryKey,
    pb.ActivityTypeKey,
    pb.PropertyFundKey,
    pb.AllocationRegionKey,
    pb.ConsolidationRegionKey,
    pb.OriginatingRegionKey,
    pb.SourceKey,
    pb.GlAccountKey,
	pb.ReimbursableKey,
	pb.FeeAdjustmentKey,
	pb.FunctionalDepartmentKey,
	pb.OverheadKey

')
print @cmdString
IF LEN(@cmdString) > 7990
	RAISERROR ('Dynamic SQL to large',16,1)
	
EXEC (@cmdString)



--Get reforecast information
--Q1
SET @cmdString = (Select '

INSERT INTO #ProfitabilityReport
SELECT 
	pr.GlobalGlAccountCategoryKey,
    pr.ActivityTypeKey,
    pr.PropertyFundKey,
    pr.AllocationRegionKey,
    pr.ConsolidationRegionKey,
    pr.OriginatingRegionKey,
    pr.SourceKey,
    pr.GlAccountKey,
	pr.ReimbursableKey,
	pr.FeeAdjustmentKey,
	pr.FunctionalDepartmentKey,
	pr.OverheadKey,
	'''' as CalendarPeriod,
	
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' as OriginatingRegionCode,
    '''' as FunctionalDepartmentCode,
    
    --Expenses must be displayed as negative
	NULL as MtdActual,
	NULL as MtdBudget,
	SUM(
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
	) as MtdReforecastQ1,
	NULL as MtdReforecastQ2,
	NULL as MtdReforecastQ3,
	
	NULL as YtdActual,	
	NULL as YtdBudget, 
	SUM(
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
	) as YtdReforecastQ1, 
	NULL as YtdReforecastQ2, 
	NULL as YtdReforecastQ3, 
	
	NULL as AnnualBudget, ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
    '
     SUM(er.Rate * pr.LocalReforecast * (CASE WHEN gac.FeeOrExpense = ''INCOME'' THEN
										  1
									    ELSE
										 -1 
									    END)) as AnnualReforecastQ1,								    
	 
     NULL as AnnualReforecastQ2,								    
     NULL as AnnualReforecastQ3

FROM
	ProfitabilityReforecast pr --WITH (INDEX=IX_Clustered)

	INNER JOIN Overhead oh ON oh.OverheadKey = pr.OverheadKey
	
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
			
    INNER JOIN #ExchangeRate er ON er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
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
    INNER JOIN FeeAdjustment Fa ON Fa.FeeAdjustmentKey = pr.FeeAdjustmentKey

WHERE  1 = 1
    AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
	AND ref.ReforecastEffectivePeriod = ' + STR(@ReforecastEffectivePeriodQ1,10,0) + '
'
+ CASE WHEN @DisplayOverheadBy = 'Unallocated' THEN 
			'
		AND (
				(
					gac.AccountSubTypeName	= ''Overhead''
				and	Oh.OverHeadCode			IN (''UNKNOWN'',''UNALLOC'')
				' +
				CASE WHEN @OverheadOriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OverheadOriginatingSubRegionFilterTable t1) ' END +
				'
				)
			OR	(
				gac.AccountSubTypeName		<> ''Overhead''
				'+
				+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable) ' END +
				--+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable) ' END +
				+ CASE WHEN @ConsolidationSubRegionList IS NULL THEN '' ELSE ' AND ar.ConsolidationRegionKey IN (Select ConsolidationRegionKey From #ionSubRegionFilterTable) ' END +
				'
				)
			)
			'

		ELSE --ALLOC
			'
		AND (
				(
					gac.AccountSubTypeName	<> ''Overhead''
				)
			OR	(
					gac.AccountSubTypeName	= ''Overhead''
				and	Oh.OverHeadCode			IN (''UNKNOWN'',''ALLOC'')
				)
			)
			'
		+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable) ' END +
		+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable) ' END

		END +
		
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
+ CASE WHEN @IncludeFeeAdjustments = 1 THEN ' AND Fa.FeeAdjustmentCode IN (''NORMAL'',''FEEADJUST'')' ELSE ' AND Fa.FeeAdjustmentCode IN (''NORMAL'')' END +
'
Group By
	pr.GlobalGlAccountCategoryKey,
    pr.ActivityTypeKey,
    pr.PropertyFundKey,
    pr.AllocationRegionKey,
    pr.ConsolidationRegionKey,
    pr.OriginatingRegionKey,
    pr.SourceKey,
    pr.GlAccountKey,
	pr.ReimbursableKey,
	pr.FeeAdjustmentKey,
	pr.FunctionalDepartmentKey,
	pr.OverheadKey

')
print @cmdString
IF LEN(@cmdString) > 7990
	RAISERROR ('Dynamic SQL to large',16,1)

EXEC (@cmdString)


--Q2



--Get reforecast information
SET @cmdString = (Select '

INSERT INTO #ProfitabilityReport
SELECT 
	pr.GlobalGlAccountCategoryKey,
    pr.ActivityTypeKey,
    pr.PropertyFundKey,
    pr.AllocationRegionKey,
    pr.ConsolidationRegionKey,
    pr.OriginatingRegionKey,
    pr.SourceKey,
    pr.GlAccountKey,
	pr.ReimbursableKey,
	pr.FeeAdjustmentKey,
	pr.FunctionalDepartmentKey,
	pr.OverheadKey,
	'''' as CalendarPeriod,
	
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' as OriginatingRegionCode,
    '''' as FunctionalDepartmentCode,
    
    --Expenses must be displayed as negative
	NULL as MtdActual,
	NULL as MtdBudget,
	NULL as MtdReforecastQ1,
	SUM(
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
	) as MtdReforecastQ2,
	NULL as MtdReforecastQ3,
	
	NULL as YtdActual,	
	NULL as YtdBudget, 
	NULL as YtdReforecastQ1, 
	SUM(
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
	) as YtdReforecastQ2, 
	NULL as YtdReforecastQ3, 
	
	NULL as AnnualBudget, ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
    '
     NULL as AnnualReforecastQ1,								    
	 
     SUM(er.Rate * pr.LocalReforecast * (CASE WHEN gac.FeeOrExpense = ''INCOME'' THEN
										  1
									    ELSE
										 -1 
									    END)) as AnnualReforecastQ2,								    
	 
     NULL as AnnualReforecastQ3

FROM
	ProfitabilityReforecast pr --WITH (INDEX=IX_Clustered)

	INNER JOIN Overhead oh ON oh.OverheadKey = pr.OverheadKey
	
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
			
    INNER JOIN #ExchangeRate er ON er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
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
    INNER JOIN FeeAdjustment Fa ON Fa.FeeAdjustmentKey = pr.FeeAdjustmentKey

WHERE  1 = 1
    AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
	AND ref.ReforecastEffectivePeriod = ' + STR(@ReforecastEffectivePeriodQ2,10,0) + '
'
+ CASE WHEN @DisplayOverheadBy = 'Unallocated' THEN 
			'
		AND (
				(
					gac.AccountSubTypeName	= ''Overhead''
				and	Oh.OverHeadCode			IN (''UNKNOWN'',''UNALLOC'')
				' +
				CASE WHEN @OverheadOriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OverheadOriginatingSubRegionFilterTable t1) ' END +
				'
				)
			OR	(
				gac.AccountSubTypeName		<> ''Overhead''
				'+
				+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable) ' END +
				+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable) ' END +
				'
				)
			)
			'

		ELSE --ALLOC
			'
		AND (
				(
					gac.AccountSubTypeName	<> ''Overhead''
				)
			OR	(
					gac.AccountSubTypeName	= ''Overhead''
				and	Oh.OverHeadCode			IN (''UNKNOWN'',''ALLOC'')
				)
			)
			'
		+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable) ' END +
		+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable) ' END

		END +
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
+ CASE WHEN @IncludeFeeAdjustments = 1 THEN ' AND Fa.FeeAdjustmentCode IN (''NORMAL'',''FEEADJUST'')' ELSE ' AND Fa.FeeAdjustmentCode IN (''NORMAL'')' END +
'
Group By
	pr.GlobalGlAccountCategoryKey,
    pr.ActivityTypeKey,
    pr.PropertyFundKey,
    pr.AllocationRegionKey,
    pr.ConsolidationRegionKey,
    pr.OriginatingRegionKey,
    pr.SourceKey,
    pr.GlAccountKey,
	pr.ReimbursableKey,
	pr.FeeAdjustmentKey,
	pr.FunctionalDepartmentKey,
	pr.OverheadKey
')
print @cmdString
IF LEN(@cmdString) > 7990
	RAISERROR ('Dynamic SQL to large',16,1)

EXEC (@cmdString)

--Q3



--Get reforecast information
SET @cmdString = (Select '

INSERT INTO #ProfitabilityReport
SELECT 
	pr.GlobalGlAccountCategoryKey,
    pr.ActivityTypeKey,
    pr.PropertyFundKey,
    pr.AllocationRegionKey,
    pr.ConsolidationRegionKey,
    pr.OriginatingRegionKey,
    pr.SourceKey,
    pr.GlAccountKey,
	pr.ReimbursableKey,
	pr.FeeAdjustmentKey,
	pr.FunctionalDepartmentKey,
	pr.OverheadKey,
	'''' as CalendarPeriod,
	
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' as OriginatingRegionCode,
    '''' as FunctionalDepartmentCode,
    
    --Expenses must be displayed as negative
	NULL as MtdActual,
	NULL as MtdBudget,
	NULL as MtdReforecastQ1,
	NULL as MtdReforecastQ2,
	SUM(
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
	) as MtdReforecastQ3,
	
	NULL as YtdActual,	
	NULL as YtdBudget, 
	NULL as YtdReforecastQ1, 
	NULL as YtdReforecastQ2, 
	SUM(
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
	) as YtdReforecastQ3, 
	
	NULL as AnnualBudget, ' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
    '
     NULL as AnnualReforecastQ1,								    
	 NULL as AnnualReforecastQ2,								    
	 
     SUM(er.Rate * pr.LocalReforecast * (CASE WHEN gac.FeeOrExpense = ''INCOME'' THEN
										  1
									    ELSE
										 -1 
									    END)) as AnnualReforecastQ3

FROM
	ProfitabilityReforecast pr --WITH (INDEX=IX_Clustered)

	INNER JOIN Overhead oh ON oh.OverheadKey = pr.OverheadKey
	
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
			
    INNER JOIN #ExchangeRate er ON er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
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
    INNER JOIN FeeAdjustment Fa ON Fa.FeeAdjustmentKey = pr.FeeAdjustmentKey

WHERE  1 = 1
    AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND gac.MinorCategoryName <> ''Architects & Engineering'' /* IMS 51655 */
	AND ref.ReforecastEffectivePeriod = ' + STR(@ReforecastEffectivePeriodQ3,10,0) + '
'
+ CASE WHEN @DisplayOverheadBy = 'Unallocated' THEN 
			'
		AND (
				(
					gac.AccountSubTypeName	= ''Overhead''
				and	Oh.OverHeadCode			IN (''UNKNOWN'',''UNALLOC'')
				' +
				CASE WHEN @OverheadOriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OverheadOriginatingSubRegionFilterTable t1) ' END +
				'
				)
			OR	(
				gac.AccountSubTypeName		<> ''Overhead''
				'+
				+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable) ' END +
				+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable) ' END +
				'
				)
			)
			'

		ELSE --ALLOC
			'
		AND (
				(
					gac.AccountSubTypeName	<> ''Overhead''
				)
			OR	(
					gac.AccountSubTypeName	= ''Overhead''
				and	Oh.OverHeadCode			IN (''UNKNOWN'',''ALLOC'')
				)
			)
			'
		+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable) ' END +
		+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable) ' END

		END +
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
+ CASE WHEN @IncludeFeeAdjustments = 1 THEN ' AND Fa.FeeAdjustmentCode IN (''NORMAL'',''FEEADJUST'')' ELSE ' AND Fa.FeeAdjustmentCode IN (''NORMAL'')' END +

'
Group By
	pr.GlobalGlAccountCategoryKey,
    pr.ActivityTypeKey,
    pr.PropertyFundKey,
    pr.AllocationRegionKey,
    pr.ConsolidationRegionKey,
    pr.OriginatingRegionKey,
    pr.SourceKey,
    pr.GlAccountKey,
	pr.ReimbursableKey,
	pr.FeeAdjustmentKey,
	pr.FunctionalDepartmentKey,
	pr.OverheadKey
')
print @cmdString
IF LEN(@cmdString) > 7990
	RAISERROR ('Dynamic SQL to large',16,1)
	
EXEC (@cmdString)


SELECT 
	gac.AccountSubTypeName AS ExpenseType, 
	gac.FeeOrExpense AS FeeOrExpense,
	CASE WHEN (gac.MajorCategoryName = 'Salaries/Taxes/Benefits') THEN 'Salaries/Bonus/Taxes/Benefits' ELSE gac.MajorCategoryName END AS MajorExpenseCategoryName,
    --gac.MajorCategoryName AS MajorExpenseCategoryName,
    gac.MinorCategoryName AS MinorExpenseCategoryName,
	a.BusinessLineName AS BusinessLine,
    a.ActivityTypeName AS ActivityType,
	CASE WHEN (gac.MajorCategoryName = 'Salaries/Taxes/Benefits') THEN 'Sensitized' ELSE pf.PropertyFundName END AS ReportingEntityName,
	pf.PropertyFundType AS ReportingEntityType,
	ar.SubRegionName AS AllocationSubRegionName,
	CR.SubRegionName as ConsolidationSubRegionName,
    orr.SubRegionName as OriginatingSubRegionName,
	CASE WHEN (gac.MajorCategoryName = 'Salaries/Taxes/Benefits') THEN 'Sensitized' ELSE ga.Code END AS GlobalGlAccountCode,
    CASE WHEN (gac.MajorCategoryName = 'Salaries/Taxes/Benefits') THEN 'Sensitized' ELSE ga.Name END AS GlobalGlAccountName,    
	r.ReimbursableName,
	fa.FeeAdjustmentCode,
	CASE WHEN (gac.MajorCategoryName = 'Salaries/Taxes/Benefits') THEN 'Sensitized' ELSE s.SourceName END AS SourceName,
	gac.GlAccountCategoryKey,
	
	res.CalendarPeriod AS ActualsExpensePeriod,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
	res.PropertyFundCode,
	res.FunctionalDepartmentCode,
    res.OriginatingRegionCode,

	--Gross
	--Month to date    
	SUM(ISNULL(res.MtdActual,0)) AS MtdActual,
	SUM(ISNULL(res.MtdBudget,0)) AS MtdOriginalBudget,
	
	SUM(ISNULL(res.MtdReforecastQ1,0))AS MtdReforecastQ1,
	SUM(ISNULL(res.MtdReforecastQ2,0))AS MtdReforecastQ2,
	SUM(ISNULL(res.MtdReforecastQ3,0))AS MtdReforecastQ3,

	/* Enhanced case statement: IMS 58120 */

	CASE WHEN gac.FeeOrExpense = 'EXPENSE' AND NOT ( r.ReimbursableName = 'Reimbursable' AND (gac.AccountSubTypeName = 'Payroll' OR gac.AccountSubTypeName = 'Overhead') ) THEN SUM(ISNULL(MtdBudget,0)) - SUM(ISNULL(MtdActual,0)) ELSE SUM(ISNULL(res.MtdActual,0)) - SUM(ISNULL(MtdBudget,0)) END AS MtdVarianceQ0,
	CASE WHEN gac.FeeOrExpense = 'EXPENSE' AND NOT ( r.ReimbursableName = 'Reimbursable' AND (gac.AccountSubTypeName = 'Payroll' OR gac.AccountSubTypeName = 'Overhead') ) THEN SUM(ISNULL(res.MtdReforecastQ1,0)) - SUM(ISNULL(MtdActual,0)) ELSE SUM(ISNULL(MtdActual,0)) - SUM(ISNULL(res.MtdReforecastQ1,0)) END AS MtdVarianceQ1,
	CASE WHEN gac.FeeOrExpense = 'EXPENSE' AND NOT ( r.ReimbursableName = 'Reimbursable' AND (gac.AccountSubTypeName = 'Payroll' OR gac.AccountSubTypeName = 'Overhead') ) THEN SUM(ISNULL(res.MtdReforecastQ2,0)) - SUM(ISNULL(MtdActual,0)) ELSE SUM(ISNULL(MtdActual,0)) - SUM(ISNULL(res.MtdReforecastQ2,0)) END AS MtdVarianceQ2,
	CASE WHEN gac.FeeOrExpense = 'EXPENSE' AND NOT ( r.ReimbursableName = 'Reimbursable' AND (gac.AccountSubTypeName = 'Payroll' OR gac.AccountSubTypeName = 'Overhead') ) THEN SUM(ISNULL(res.MtdReforecastQ3,0)) - SUM(ISNULL(MtdActual,0)) ELSE SUM(ISNULL(MtdActual,0)) - SUM(ISNULL(res.MtdReforecastQ3,0)) END AS MtdVarianceQ3,
	
	--Year to date
	SUM(ISNULL(res.YtdActual,0)) AS YtdActual,	
	SUM(ISNULL(res.YtdBudget,0)) AS YtdOriginalBudget,
	
	SUM(ISNULL(res.YtdReforecastQ1,0)) AS YtdReforecastQ1,
	SUM(ISNULL(res.YtdReforecastQ2,0)) YtdReforecastQ2,
	SUM(ISNULL(res.YtdReforecastQ3,0)) YtdReforecastQ3,
	
	/* Enhanced case statement: IMS 58120 */

	CASE WHEN gac.FeeOrExpense = 'EXPENSE' AND NOT ( r.ReimbursableName = 'Reimbursable' AND (gac.AccountSubTypeName = 'Payroll' OR gac.AccountSubTypeName = 'Overhead') ) THEN SUM(ISNULL(YtdBudget,0)) - SUM(ISNULL(YtdActual,0)) ELSE SUM(ISNULL(res.YtdActual,0)) - SUM(ISNULL(YtdBudget,0)) END AS YtdVarianceQ0,
	CASE WHEN gac.FeeOrExpense = 'EXPENSE' AND NOT ( r.ReimbursableName = 'Reimbursable' AND (gac.AccountSubTypeName = 'Payroll' OR gac.AccountSubTypeName = 'Overhead') ) THEN SUM(ISNULL(res.YtdReforecastQ1,0)) - SUM(ISNULL(YtdActual,0)) ELSE SUM(ISNULL(YtdActual,0)) - SUM(ISNULL(res.YtdReforecastQ1,0)) END AS YtdVarianceQ1,
	CASE WHEN gac.FeeOrExpense = 'EXPENSE' AND NOT ( r.ReimbursableName = 'Reimbursable' AND (gac.AccountSubTypeName = 'Payroll' OR gac.AccountSubTypeName = 'Overhead') ) THEN SUM(ISNULL(res.YtdReforecastQ2,0)) - SUM(ISNULL(YtdActual,0)) ELSE SUM(ISNULL(YtdActual,0)) - SUM(ISNULL(res.YtdReforecastQ2,0)) END AS YtdVarianceQ2,
	CASE WHEN gac.FeeOrExpense = 'EXPENSE' AND NOT ( r.ReimbursableName = 'Reimbursable' AND (gac.AccountSubTypeName = 'Payroll' OR gac.AccountSubTypeName = 'Overhead') ) THEN SUM(ISNULL(res.YtdReforecastQ3,0)) - SUM(ISNULL(YtdActual,0)) ELSE SUM(ISNULL(YtdActual,0)) - SUM(ISNULL(res.YtdReforecastQ3,0)) END AS YtdVarianceQ3,
	
	--Annual
	SUM(ISNULL(res.AnnualBudget,0)) AS AnnualOriginalBudget,	
	SUM(ISNULL(res.AnnualReforecastQ1,0)) AS AnnualReforecastQ1,
	SUM(ISNULL(res.AnnualReforecastQ2,0)) AS AnnualReforecastQ2,
	SUM(ISNULL(res.AnnualReforecastQ3,0)) AS AnnualReforecastQ3

INTO
	[#Output]
FROM
	#ProfitabilityReport res
	
	INNER JOIN Overhead oh ON oh.OverheadKey = res.OverheadKey

	INNER JOIN GlAccount ga on ga.GlAccountKey = res.GlAccountKey
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = res.GlAccountCategoryKey
		
    INNER JOIN Reimbursable r ON r.ReimbursableKey = res.ReimbursableKey
    INNER JOIN Source s ON s.SourceKey = res.SourceKey

    LEFT OUTER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = res.AllocationRegionKey
    LEFT OUTER JOIN AllocationRegion CR ON  CR.AllocationRegionKey = res.ConsolidationRegionKey
    
    INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = res.OriginatingRegionKey
    INNER JOIN ActivityType a ON  a.ActivityTypeKey = res.ActivityTypeKey
    INNER JOIN PropertyFund pf ON pf.PropertyFundKey = res.PropertyFundKey
    INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = res.FunctionalDepartmentKey
    INNER JOIN FeeAdjustment fa ON fa.FeeAdjustmentKey = res.FeeAdjustmentKey

	
GROUP BY
	gac.AccountSubTypeName, 
	gac.FeeOrExpense,
    CASE WHEN (gac.MajorCategoryName = 'Salaries/Taxes/Benefits') THEN 'Salaries/Bonus/Taxes/Benefits' ELSE gac.MajorCategoryName END,
    gac.MinorCategoryName,
    a.BusinessLineName,
    a.ActivityTypeName,
	CASE WHEN (gac.MajorCategoryName = 'Salaries/Taxes/Benefits') THEN 'Sensitized' ELSE pf.PropertyFundName END,
	pf.PropertyFundType,
	ar.SubRegionName,
	CR.SubRegionName,
    orr.SubRegionName,
	CASE WHEN (gac.MajorCategoryName = 'Salaries/Taxes/Benefits') THEN 'Sensitized' ELSE ga.Code END,
    CASE WHEN (gac.MajorCategoryName = 'Salaries/Taxes/Benefits') THEN 'Sensitized' ELSE ga.Name END,
	r.ReimbursableName,
	fa.FeeAdjustmentCode,
	CASE WHEN (gac.MajorCategoryName = 'Salaries/Taxes/Benefits') THEN 'Sensitized' ELSE s.SourceName END,
	gac.GlAccountCategoryKey,
	
	res.CalendarPeriod,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
	res.PropertyFundCode,
	res.FunctionalDepartmentCode,
    res.OriginatingRegionCode




--Eliminate any rows, that all calcs product a 0 value, this is to reduce the report size
------------------------------------------------------------------------------------------------------------------------------------------
-- <<< NOTE !!!!!!! >>>
--Any changes to this resultset must be applied to the [stp_R_Profitability] for this stp is used in a insert into xxx exec xxx there
------------------------------------------------------------------------------------------------------------------------------------------
SELECT
	ExpenseType, 
	FeeOrExpense,
    MajorExpenseCategoryName,
    MinorExpenseCategoryName,
	GlobalGlAccountCode,
	GlobalGlAccountName,
    BusinessLine,
    ActivityType,
	ReportingEntityName,
	ReportingEntityType,
	PropertyFundCode,
	FunctionalDepartmentCode,
	AllocationSubRegionName,
	OriginatingSubRegionName,
	ActualsExpensePeriod,
    EntryDate,
    [User],
    [Description],
    AdditionalDescription,
	ReimbursableName,
	FeeAdjustmentCode,
	SourceName,
	GlAccountCategoryKey,
	
	--Gross
	--Month to date    
	MtdActual,
	MtdOriginalBudget,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE MtdReforecastQ1 END AS MtdReforecastQ1,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE MtdReforecastQ2 END AS MtdReforecastQ2,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE MtdReforecastQ3 END AS MtdReforecastQ3,

	MtdVarianceQ0,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE MtdVarianceQ1 END AS MtdVarianceQ1,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE MtdVarianceQ2 END AS MtdVarianceQ2,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE MtdVarianceQ3 END AS MtdVarianceQ3,
	
	--Year to date
	YtdActual,	
	YtdOriginalBudget,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE YtdReforecastQ1 END AS YtdReforecastQ1,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE YtdReforecastQ2 END AS YtdReforecastQ2,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE YtdReforecastQ3 END AS YtdReforecastQ3,

	YtdVarianceQ0,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE YtdVarianceQ1 END AS YtdVarianceQ1,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE YtdVarianceQ2 END AS YtdVarianceQ2,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE YtdVarianceQ3 END AS YtdVarianceQ3,

	--Annual
	AnnualOriginalBudget,	
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE AnnualReforecastQ1 END AS AnnualReforecastQ1,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE AnnualReforecastQ2 END AS AnnualReforecastQ2,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE AnnualReforecastQ3 END AS AnnualReforecastQ3,
	ConsolidationSubRegionName
FROM
	[#Output]
--WHERE
	----Gross
	----Month to date    
	--MtdActual <> 0.00 OR
	--MtdOriginalBudget <> 0.00 OR
	--MtdReforecastQ1 <> 0.00 OR
	--MtdReforecastQ2 <> 0.00 OR
	--MtdReforecastQ3 <> 0.00 OR
	--MtdVarianceQ0 <> 0.00 OR
	--MtdVarianceQ1 <> 0.00 OR
	--MtdVarianceQ2 <> 0.00 OR
	--MtdVarianceQ3 <> 0.00 OR
	
	----Year to date
	--YtdActual <> 0.00 OR
	--YtdOriginalBudget <> 0.00 OR
	--YtdReforecastQ1 <> 0.00 OR
	--YtdReforecastQ2 <> 0.00 OR
	--YtdReforecastQ3 <> 0.00 OR
	--YtdVarianceQ0 <> 0.00 OR
	--YtdVarianceQ1 <> 0.00 OR
	--YtdVarianceQ2 <> 0.00 OR
	--YtdVarianceQ3 <> 0.00 OR
	
	----Annual
	--AnnualOriginalBudget <> 0.00 OR
	--AnnualReforecastQ1 <> 0.00 OR
	--AnnualReforecastQ2 <> 0.00 OR
	--AnnualReforecastQ3 <> 0.00

IF 	OBJECT_ID('tempdb..#ProfitabilityReport') IS NOT NULL
    DROP TABLE #ProfitabilityReport

IF 	OBJECT_ID('tempdb..#Output') IS NOT NULL
    DROP TABLE #Output
    
IF 	OBJECT_ID('tempdb..#ProfitabilityReport') IS NOT NULL
    DROP TABLE #ProfitabilityReport




GO


-- 6. stp_R_ProfitabilityV2.sql

USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ProfitabilityV2]    Script Date: 08/08/2011 20:36:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ProfitabilityV2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ProfitabilityV2]
GO

USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ProfitabilityV2]    Script Date: 08/08/2011 20:36:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



/*********************************************************************************************************************
Description
	The stored procedure is used for generating the data for summary tab of the Profitability report.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-07-08		: PKayongo	:	Sensitized payroll data for the MRI Source, Originating Region and Property
											Fund fields. (CC20)
			2011-08-08		: SNothling	:	Set sensitized strings to 'Sensitized' instead of ''

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_R_ProfitabilityV2]
	@ReportExpensePeriod INT = NULL,
	@ReforecastQuarterName VARCHAR(10) = NULL, --'Q1' or 'Q2' or 'Q3'
	@DestinationCurrency VARCHAR(3) = NULL,
	@TranslationTypeName VARCHAR(50) = 'Global',
	@IsGross Bit=NULL, --not used, just placeholder
	@FunctionalDepartmentList TEXT = NULL,
	@ActivityTypeList TEXT = NULL,
	@EntityList TEXT = NULL,
	@MajorAccountCategoryList TEXT = NULL,
	@MinorAccountCategoryList TEXT = NULL,
	@AllocationRegionList TEXT = NULL,
	@AllocationSubRegionList TEXT = NULL,
	@OriginatingRegionList TEXT = NULL,
	@OriginatingSubRegionList TEXT = NULL,
	@DisplayOverheadBy Varchar(12)='Allocated', --alloc / unalloc

	--Customized Filter Logic Specific to this Report
	@IncludeGrossNonPayrollExpenses TinyInt = NULL,
	@IncludeFeeAdjustments TinyInt = NULL,
	@DisplayFeeAdjustmentsBy Varchar(20) = NULL,
	@OverheadOriginatingSubRegionList TEXT = NULL,
	@ConsolidationRegionList TEXT = NULL

AS


IF ISNULL(@DisplayOverheadBy,'') NOT IN ('Allocated','Unallocated')
	BEGIN
	RAISERROR ('@DisplayOverheadBy have invalid value (Must be one of:Allocated,Unallocated)',18,1)
	RETURN
	END

IF (@IncludeFeeAdjustments = 1 AND ISNULL(@DisplayFeeAdjustmentsBy,'') NOT IN ('AllocationRegion','ReportingEntity'))
	BEGIN
	RAISERROR ('@DisplayFeeAdjustmentsBy have invalid value (Must be one of:AllocationRegion,ReportingEntity)',18,1)
	RETURN
	END
	
IF @ReforecastQuarterName IS NULL OR @ReforecastQuarterName NOT IN ('Q0', 'Q1', 'Q2', 'Q3')
	SET @ReforecastQuarterName = (SELECT TOP 1
									ReforecastQuarterName 
								 FROM
									dbo.Reforecast 
								 WHERE
									ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
									ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
								 ORDER BY
									ReforecastEffectivePeriod DESC)

CREATE TABLE #DetailResult(
	ExpenseType varchar(50) NULL,
	FeeOrExpense varchar(50) NULL,
	MajorExpenseCategoryName varchar(100) NULL,
	MinorExpenseCategoryName varchar(100) NULL,
	GlobalGlAccountCode varchar(50) NULL,
	GlobalGlAccountName varchar(150) NULL,
	BusinessLine varchar(50) NULL,
	ActivityType varchar(50) NULL,
	ReportingEntityName varchar(100) NULL,
	ReportingEntityType varchar(50) NULL,
	PropertyFundCode varchar(11) NULL,
	FunctionalDepartmentCode varchar(15) NULL,
	AllocationSubRegionName varchar(50) NULL,
	OriginatingSubRegionName varchar(50) NULL,

	ActualsExpensePeriod Varchar(6) NULL,
	EntryDate varchar(10) NULL,
	[User] nvarchar(20) NULL,
	Description nvarchar(60) NULL,
	AdditionalDescription nvarchar(4000) NULL,
	ReimbursableName varchar(50) NULL,
	FeeAdjustmentCode varchar(10) NULL,
	SourceName varchar(50) NULL,
	GlAccountCategoryKey int not null,
	
	MtdActual money NULL,
	MtdOriginalBudget money NULL,
	MtdReforecastQ1 money NULL,
	MtdReforecastQ2 money NULL,
	MtdReforecastQ3 money NULL,
	MtdVarianceQ0 money NULL,
	MtdVarianceQ1 money NULL,
	MtdVarianceQ2 money NULL,
	MtdVarianceQ3 money NULL,
	YtdActual money NULL,
	YtdOriginalBudget money NULL,
	YtdReforecastQ1 money NULL,
	YtdReforecastQ2 money NULL,
	YtdReforecastQ3 money NULL,
	YtdVarianceQ0 money NULL,
	YtdVarianceQ1 money NULL,
	YtdVarianceQ2 money NULL,
	YtdVarianceQ3 money NULL,
	AnnualOriginalBudget money NULL,
	AnnualReforecastQ1 money NULL,
	AnnualReforecastQ2 money NULL,
	AnnualReforecastQ3 money NULL,
	ConsolidationSubRegionName varchar(50) NULL
)

Insert Into #DetailResult
(	ExpenseType, 
	FeeOrExpense,
    MajorExpenseCategoryName,
    MinorExpenseCategoryName,
	GlobalGlAccountCode,
	GlobalGlAccountName,
    BusinessLine,
    ActivityType,
	ReportingEntityName,
	ReportingEntityType,
	PropertyFundCode,
	FunctionalDepartmentCode,
	AllocationSubRegionName,
	OriginatingSubRegionName,
	ActualsExpensePeriod,
    EntryDate,
    [User],
    [Description],
    AdditionalDescription,
	ReimbursableName,
	FeeAdjustmentCode,
	SourceName,
	GlAccountCategoryKey,

	--Gross
	--Month to date    
	MtdActual,
	MtdOriginalBudget,
	MtdReforecastQ1,
	MtdReforecastQ2,
	MtdReforecastQ3,

	MtdVarianceQ0,
	MtdVarianceQ1,
	MtdVarianceQ2,
	MtdVarianceQ3,
	
	--Year to date
	YtdActual,	
	YtdOriginalBudget,
	YtdReforecastQ1,
	YtdReforecastQ2,
	YtdReforecastQ3,

	YtdVarianceQ0,
	YtdVarianceQ1,
	YtdVarianceQ2,
	YtdVarianceQ3,
	
	--Annual
	AnnualOriginalBudget,	
	AnnualReforecastQ1,
	AnnualReforecastQ2,
	AnnualReforecastQ3,
	ConsolidationSubRegionName)
	
exec [stp_R_ProfitabilityDetailV2]
	@ReportExpensePeriod = @ReportExpensePeriod,
	@DestinationCurrency = @DestinationCurrency,
	@TranslationTypeName = @TranslationTypeName,
	@FunctionalDepartmentList = @FunctionalDepartmentList,
	@ActivityTypeList = @ActivityTypeList,
	@EntityList = @EntityList,
	@MajorAccountCategoryList = @MajorAccountCategoryList,
	@MinorAccountCategoryList = @MinorAccountCategoryList,
	@AllocationRegionList = @AllocationRegionList,
	@AllocationSubRegionList = @AllocationSubRegionList,
	@OriginatingRegionList = @OriginatingRegionList,
	@OriginatingSubRegionList = @OriginatingSubRegionList,
	@DisplayOverheadBy = @DisplayOverheadBy,
	@OverheadOriginatingSubRegionList = @OverheadOriginatingSubRegionList,
	@IncludeFeeAdjustments = @IncludeFeeAdjustments


		
CREATE TABLE #Result (
	NumberOfSpacesToPad TinyInt NOT NULL,
	GroupDisplayCode Varchar(500) NOT NULL,
	GroupDisplayName Varchar(500) NOT NULL,
	DisplayOrderNumber Int NOT NULL,
	MtdActual money NOT NULL DEFAULT(0),
	MtdOriginalBudget money NOT NULL DEFAULT(0),
	MtdReforecastQ1 money NOT NULL DEFAULT(0),
	MtdReforecastQ2 money NOT NULL DEFAULT(0),
	MtdReforecastQ3 money NOT NULL DEFAULT(0),
	
	MtdVarianceQ0 money NOT NULL DEFAULT(0),
	MtdVarianceQ1 money NOT NULL DEFAULT(0),
	MtdVarianceQ2 money NOT NULL DEFAULT(0),
	MtdVarianceQ3 money NOT NULL DEFAULT(0),

	MtdVariancePercentageQ0 money NOT NULL DEFAULT(0),
	MtdVariancePercentageQ1 money NOT NULL DEFAULT(0),
	MtdVariancePercentageQ2 money NOT NULL DEFAULT(0),
	MtdVariancePercentageQ3 money NOT NULL DEFAULT(0),
	
	YtdActual money NOT NULL DEFAULT(0),
	YtdOriginalBudget money NOT NULL DEFAULT(0),
	YtdReforecastQ1 money NOT NULL DEFAULT(0),
	YtdReforecastQ2 money NOT NULL DEFAULT(0),
	YtdReforecastQ3 money NOT NULL DEFAULT(0),
	
	YtdVarianceQ0 money NOT NULL DEFAULT(0),
	YtdVarianceQ1 money NOT NULL DEFAULT(0),
	YtdVarianceQ2 money NOT NULL DEFAULT(0),
	YtdVarianceQ3 money NOT NULL DEFAULT(0),
	
	YtdVariancePercentageQ0 money NOT NULL DEFAULT(0),
	YtdVariancePercentageQ1 money NOT NULL DEFAULT(0),
	YtdVariancePercentageQ2 money NOT NULL DEFAULT(0),
	YtdVariancePercentageQ3 money NOT NULL DEFAULT(0),
	
	AnnualOriginalBudget money NOT NULL DEFAULT(0),
	AnnualReforecastQ1 money NOT NULL DEFAULT(0),
	AnnualReforecastQ2 money NOT NULL DEFAULT(0),
	AnnualReforecastQ3 money NOT NULL DEFAULT(0),
	
)

Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
VALUES(0,'REVENUE','REVENUE',100)

Insert Into #Result
(NumberOfSpacesToPad,GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
VALUES(0, 'FEEREVENUE', 'Fee Revenue',200)


Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		gac.MinorCategoryName GroupDisplayCode,
		gac.MinorCategoryName,
		201 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0),
		ISNULL(SUM(t1.MtdOriginalBudget),0),
		ISNULL(SUM(t1.MtdReforecastQ1),0),
		ISNULL(SUM(t1.MtdReforecastQ2),0),
		ISNULL(SUM(t1.MtdReforecastQ3),0),
		ISNULL(SUM(t1.MtdVarianceQ0),0),
		ISNULL(SUM(t1.MtdVarianceQ1),0),
		ISNULL(SUM(t1.MtdVarianceQ2),0),
		ISNULL(SUM(t1.MtdVarianceQ3),0),
		ISNULL(SUM(t1.YtdActual),0),
		ISNULL(SUM(t1.YtdOriginalBudget),0),
		ISNULL(SUM(t1.YtdReforecastQ1),0),
		ISNULL(SUM(t1.YtdReforecastQ2),0),
		ISNULL(SUM(t1.YtdReforecastQ3),0),
		ISNULL(SUM(t1.YtdVarianceQ0),0),
		ISNULL(SUM(t1.YtdVarianceQ1),0),
		ISNULL(SUM(t1.YtdVarianceQ2),0),
		ISNULL(SUM(t1.YtdVarianceQ3),0),
		ISNULL(SUM(t1.AnnualOriginalBudget),0),
		ISNULL(SUM(t1.AnnualReforecastQ1),0),
		ISNULL(SUM(t1.AnnualReforecastQ2),0),
		ISNULL(SUM(t1.AnnualReforecastQ3),0)

From 
		GlAccountCategory gac
			LEFT OUTER JOIN (Select * 
							From #DetailResult t1
							Where t1.FeeAdjustmentCode		= 'NORMAL'
							) t1 ON gac.GlAccountCategoryKey = t1.GlAccountCategoryKey


Where	gac.FeeOrExpense		= 'INCOME'
AND		gac.MajorCategoryName	= 'Fee Income'
AND		gac.TranslationSubTypeName	= @TranslationTypeName
Group By 
		gac.MinorCategoryName
		
-- Fee adjustment Insert queries removed as per Change Request 13

Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		'TOTALFEEREVENUE' GroupDisplayCode,
		'Total Fee Revenue',
		203 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0),
		ISNULL(SUM(t1.MtdOriginalBudget),0),
		ISNULL(SUM(t1.MtdReforecastQ1),0),
		ISNULL(SUM(t1.MtdReforecastQ2),0),
		ISNULL(SUM(t1.MtdReforecastQ3),0),
		ISNULL(SUM(t1.MtdVarianceQ0),0),
		ISNULL(SUM(t1.MtdVarianceQ1),0),
		ISNULL(SUM(t1.MtdVarianceQ2),0),
		ISNULL(SUM(t1.MtdVarianceQ3),0),
		ISNULL(SUM(t1.YtdActual),0),
		ISNULL(SUM(t1.YtdOriginalBudget),0),
		ISNULL(SUM(t1.YtdReforecastQ1),0),
		ISNULL(SUM(t1.YtdReforecastQ2),0),
		ISNULL(SUM(t1.YtdReforecastQ3),0),
		ISNULL(SUM(t1.YtdVarianceQ0),0),
		ISNULL(SUM(t1.YtdVarianceQ1),0),
		ISNULL(SUM(t1.YtdVarianceQ2),0),
		ISNULL(SUM(t1.YtdVarianceQ3),0),
		ISNULL(SUM(t1.AnnualOriginalBudget),0),
		ISNULL(SUM(t1.AnnualReforecastQ1),0),
		ISNULL(SUM(t1.AnnualReforecastQ2),0),
		ISNULL(SUM(t1.AnnualReforecastQ3),0)

From #DetailResult t1


Where	t1.FeeOrExpense				= 'INCOME'
AND		t1.MajorExpenseCategoryName = 'Fee Income'	

Insert Into #Result
(NumberOfSpacesToPad,GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
VALUES(0, 'OTHERREVENUE', 'Other Revenue',210)
	
	
Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		gac.MajorCategoryName GroupDisplayCode,
		gac.MajorCategoryName,
		211 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0),
		ISNULL(SUM(t1.MtdOriginalBudget),0),
		ISNULL(SUM(t1.MtdReforecastQ1),0),
		ISNULL(SUM(t1.MtdReforecastQ2),0),
		ISNULL(SUM(t1.MtdReforecastQ3),0),
		ISNULL(SUM(t1.MtdVarianceQ0),0),
		ISNULL(SUM(t1.MtdVarianceQ1),0),
		ISNULL(SUM(t1.MtdVarianceQ2),0),
		ISNULL(SUM(t1.MtdVarianceQ3),0),
		ISNULL(SUM(t1.YtdActual),0),
		ISNULL(SUM(t1.YtdOriginalBudget),0),
		ISNULL(SUM(t1.YtdReforecastQ1),0),
		ISNULL(SUM(t1.YtdReforecastQ2),0),
		ISNULL(SUM(t1.YtdReforecastQ3),0),
		ISNULL(SUM(t1.YtdVarianceQ0),0),
		ISNULL(SUM(t1.YtdVarianceQ1),0),
		ISNULL(SUM(t1.YtdVarianceQ2),0),
		ISNULL(SUM(t1.YtdVarianceQ3),0),
		ISNULL(SUM(t1.AnnualOriginalBudget),0),
		ISNULL(SUM(t1.AnnualReforecastQ1),0),
		ISNULL(SUM(t1.AnnualReforecastQ2),0),
		ISNULL(SUM(t1.AnnualReforecastQ3),0)

From GlAccountCategory gac

			LEFT OUTER JOIN #DetailResult t1 ON gac.GlAccountCategoryKey = t1.GlAccountCategoryKey


Where	gac.FeeOrExpense		= 'INCOME'
AND		gac.MajorCategoryName	<> 'Fee Income'
AND		gac.MajorCategoryName	<> 'Realized (Gain)/Loss' --IMS #61973
AND		gac.TranslationSubTypeName	= @TranslationTypeName
Group By 
		gac.MajorCategoryName
	

Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		'TOTALOTHERREVENUE' GroupDisplayCode,
		'Total Other Revenue',
		212 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0),
		ISNULL(SUM(t1.MtdOriginalBudget),0),
		ISNULL(SUM(t1.MtdReforecastQ1),0),
		ISNULL(SUM(t1.MtdReforecastQ2),0),
		ISNULL(SUM(t1.MtdReforecastQ3),0),
		ISNULL(SUM(t1.MtdVarianceQ0),0),
		ISNULL(SUM(t1.MtdVarianceQ1),0),
		ISNULL(SUM(t1.MtdVarianceQ2),0),
		ISNULL(SUM(t1.MtdVarianceQ3),0),
		ISNULL(SUM(t1.YtdActual),0),
		ISNULL(SUM(t1.YtdOriginalBudget),0),
		ISNULL(SUM(t1.YtdReforecastQ1),0),
		ISNULL(SUM(t1.YtdReforecastQ2),0),
		ISNULL(SUM(t1.YtdReforecastQ3),0),
		ISNULL(SUM(t1.YtdVarianceQ0),0),
		ISNULL(SUM(t1.YtdVarianceQ1),0),
		ISNULL(SUM(t1.YtdVarianceQ2),0),
		ISNULL(SUM(t1.YtdVarianceQ3),0),
		ISNULL(SUM(t1.AnnualOriginalBudget),0),
		ISNULL(SUM(t1.AnnualReforecastQ1),0),
		ISNULL(SUM(t1.AnnualReforecastQ2),0),
		ISNULL(SUM(t1.AnnualReforecastQ3),0)

From #DetailResult t1


Where	t1.FeeOrExpense				= 'INCOME'
AND		t1.MajorExpenseCategoryName	<> 'Realized (Gain)/Loss' --IMS #61973
AND		t1.MajorExpenseCategoryName <> 'Fee Income'	


Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		'TOTALREVENUE' GroupDisplayCode,
		'Total Revenue',
		220 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0),
		ISNULL(SUM(t1.MtdOriginalBudget),0),
		ISNULL(SUM(t1.MtdReforecastQ1),0),
		ISNULL(SUM(t1.MtdReforecastQ2),0),
		ISNULL(SUM(t1.MtdReforecastQ3),0),
		ISNULL(SUM(t1.MtdVarianceQ0),0),
		ISNULL(SUM(t1.MtdVarianceQ1),0),
		ISNULL(SUM(t1.MtdVarianceQ2),0),
		ISNULL(SUM(t1.MtdVarianceQ3),0),
		ISNULL(SUM(t1.YtdActual),0),
		ISNULL(SUM(t1.YtdOriginalBudget),0),
		ISNULL(SUM(t1.YtdReforecastQ1),0),
		ISNULL(SUM(t1.YtdReforecastQ2),0),
		ISNULL(SUM(t1.YtdReforecastQ3),0),
		ISNULL(SUM(t1.YtdVarianceQ0),0),
		ISNULL(SUM(t1.YtdVarianceQ1),0),
		ISNULL(SUM(t1.YtdVarianceQ2),0),
		ISNULL(SUM(t1.YtdVarianceQ3),0),
		ISNULL(SUM(t1.AnnualOriginalBudget),0),
		ISNULL(SUM(t1.AnnualReforecastQ1),0),
		ISNULL(SUM(t1.AnnualReforecastQ2),0),
		ISNULL(SUM(t1.AnnualReforecastQ3),0)

From #DetailResult t1
Where	t1.FeeOrExpense				= 'INCOME'
AND		t1.MajorExpenseCategoryName	<> 'Realized (Gain)/Loss' --IMS #61973


Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
		0 NumberOfSpacesToPad,
		'BLANK' GroupDisplayCode,
		'',
		230 DisplayOrderNumber


Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
		0 NumberOfSpacesToPad,
		'EXPENSES' GroupDisplayCode,
		'EXPENSES',
		240 DisplayOrderNumber
		
		
Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
		0 NumberOfSpacesToPad,
		'PAYROLLEXPENSES' GroupDisplayCode,
		'Payroll Expenses',
		241 DisplayOrderNumber


		
Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		'Gross ' + t1.MajorExpenseCategoryName GroupDisplayCode,
		'Gross ' + t1.MajorExpenseCategoryName,
		242 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0) * -1,
		ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
		
		-- Variance amounts adjusted as per IMS 61749
		ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.MtdVarianceQ0 * -1) ELSE t1.MtdVarianceQ0 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.MtdVarianceQ1 * -1) ELSE t1.MtdVarianceQ1 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.MtdVarianceQ2 * -1) ELSE t1.MtdVarianceQ2 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.MtdVarianceQ3 * -1) ELSE t1.MtdVarianceQ3 END),0) * -1,
		ISNULL(SUM(t1.YtdActual),0) * -1,
		ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
		ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.YtdVarianceQ0 * -1) ELSE t1.YtdVarianceQ0 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.YtdVarianceQ1 * -1) ELSE t1.YtdVarianceQ1 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.YtdVarianceQ2 * -1) ELSE t1.YtdVarianceQ2 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.YtdVarianceQ3 * -1) ELSE t1.YtdVarianceQ3 END),0) * -1,
		ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

From #DetailResult t1
Where	t1.FeeOrExpense				= 'EXPENSE'
AND		t1.MajorExpenseCategoryName = 'Salaries/Bonus/Taxes/Benefits'
AND		t1.ExpenseType				<> 'Overhead'
Group By 
		t1.MajorExpenseCategoryName
		
		
Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		'Reimbursed ' + t1.MajorExpenseCategoryName GroupDisplayCode,
		'Reimbursed ' + t1.MajorExpenseCategoryName,
		243 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0) * -1,
		ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.YtdActual),0) * -1,
		ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

From #DetailResult t1
Where	t1.FeeOrExpense				= 'EXPENSE'
AND		t1.MajorExpenseCategoryName = 'Salaries/Bonus/Taxes/Benefits'
AND		t1.ReimbursableName			= 'Reimbursable'
AND		t1.ExpenseType				<> 'Overhead'
Group By 
		t1.MajorExpenseCategoryName	

		
Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		'Total Net ' + t1.MajorExpenseCategoryName GroupDisplayCode,
		'Total Net ' + t1.MajorExpenseCategoryName,
		244 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0) * -1,
		ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.YtdActual),0) * -1,
		ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

From #DetailResult t1
Where	t1.FeeOrExpense				= 'EXPENSE'
AND		t1.MajorExpenseCategoryName = 'Salaries/Bonus/Taxes/Benefits'
AND		t1.ReimbursableName			= 'Not Reimbursable'
AND		t1.ExpenseType				<> 'Overhead'
Group By 
		t1.MajorExpenseCategoryName	
		
Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		'Payroll Reimbursement Rate' GroupDisplayCode,
		'% Recovery',
		245 DisplayOrderNumber,
		ISNULL(Reimbursed.MtdActual / CASE WHEN Gross.MtdActual = 0 THEN NULL ELSE Gross.MtdActual END,0),
		ISNULL(Reimbursed.MtdOriginalBudget / CASE WHEN Gross.MtdOriginalBudget = 0 THEN NULL ELSE Gross.MtdOriginalBudget END,0),
		ISNULL(Reimbursed.MtdReforecastQ1 / CASE WHEN Gross.MtdReforecastQ1 = 0 THEN NULL ELSE Gross.MtdReforecastQ1 END,0),
		ISNULL(Reimbursed.MtdReforecastQ2 / CASE WHEN Gross.MtdReforecastQ2 = 0 THEN NULL ELSE Gross.MtdReforecastQ2 END,0),
		ISNULL(Reimbursed.MtdReforecastQ3 / CASE WHEN Gross.MtdReforecastQ3 = 0 THEN NULL ELSE Gross.MtdReforecastQ3 END,0),
		0,
		0,
		0,
		0,
		ISNULL(Reimbursed.YtdActual / CASE WHEN Gross.YtdActual = 0 THEN NULL ELSE Gross.YtdActual END,0),
		ISNULL(Reimbursed.YtdOriginalBudget / CASE WHEN Gross.YtdOriginalBudget = 0 THEN NULL ELSE Gross.YtdOriginalBudget END,0),
		ISNULL(Reimbursed.YtdReforecastQ1 / CASE WHEN Gross.YtdReforecastQ1 = 0 THEN NULL ELSE Gross.YtdReforecastQ1 END,0),
		ISNULL(Reimbursed.YtdReforecastQ2 / CASE WHEN Gross.YtdReforecastQ2 = 0 THEN NULL ELSE Gross.YtdReforecastQ2 END,0),
		ISNULL(Reimbursed.YtdReforecastQ3 / CASE WHEN Gross.YtdReforecastQ3 = 0 THEN NULL ELSE Gross.YtdReforecastQ3 END,0),
		0,
		0,
		0,
		0,
		ISNULL(Reimbursed.AnnualOriginalBudget / CASE WHEN Gross.AnnualOriginalBudget = 0 THEN NULL ELSE Gross.AnnualOriginalBudget END,0),
		ISNULL(Reimbursed.AnnualReforecastQ1 / CASE WHEN Gross.AnnualReforecastQ1 = 0 THEN NULL ELSE Gross.AnnualReforecastQ1 END,0),
		ISNULL(Reimbursed.AnnualReforecastQ2 / CASE WHEN Gross.AnnualReforecastQ2 = 0 THEN NULL ELSE Gross.AnnualReforecastQ2 END,0),
		ISNULL(Reimbursed.AnnualReforecastQ3 / CASE WHEN Gross.AnnualReforecastQ3 = 0 THEN NULL ELSE Gross.AnnualReforecastQ3 END,0)
From 
	(
		Select 
					ISNULL(SUM(t1.MtdActual),0) MtdActual,
					ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
					ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
					ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
					ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
					ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
					ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
					ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
					ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
					ISNULL(SUM(t1.YtdActual),0) YtdActual,
					ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
					ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
					ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
					ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
					ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
					ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
					ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
					ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
					ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
					ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
					ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
					ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

		From #DetailResult t1
		Where	t1.FeeOrExpense				= 'EXPENSE'
		AND		t1.MajorExpenseCategoryName = 'Salaries/Bonus/Taxes/Benefits'
		AND		t1.ReimbursableName			= 'Reimbursable'
		AND		t1.ExpenseType				<> 'Overhead'
		) Reimbursed
		CROSS JOIN 
			(
				Select 
					ISNULL(SUM(t1.MtdActual),0) MtdActual,
					ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
					ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
					ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
					ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
					ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
					ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
					ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
					ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
					ISNULL(SUM(t1.YtdActual),0) YtdActual,
					ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
					ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
					ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
					ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
					ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
					ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
					ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
					ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
					ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
					ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
					ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
					ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

				From #DetailResult t1
				Where	t1.FeeOrExpense				= 'EXPENSE'
				AND		t1.MajorExpenseCategoryName = 'Salaries/Bonus/Taxes/Benefits'
				AND		t1.ExpenseType				<> 'Overhead'
			
			) Gross 
	
--Calculate the Payroll Reimbursement Rate Variance Columns
Update 		#Result
Set			
			MtdVarianceQ0 = (MtdActual - MtdOriginalBudget),
			MtdVarianceQ1 = (MtdActual - MtdReforecastQ1),
			MtdVarianceQ2 = (MtdActual - MtdReforecastQ2),
			MtdVarianceQ3 = (MtdActual - MtdReforecastQ3),
			YtdVarianceQ0 = (YtdActual - YtdOriginalBudget),
			YtdVarianceQ1 = (YtdActual - YtdReforecastQ1),
			YtdVarianceQ2 = (YtdActual - YtdReforecastQ2),
			YtdVarianceQ3 = (YtdActual - YtdReforecastQ3)

Where	GroupDisplayCode = 'Payroll Reimbursement Rate'
AND		DisplayOrderNumber = 245	

	
Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
		0 NumberOfSpacesToPad,
		'BLANK' GroupDisplayCode,
		'',
		250 DisplayOrderNumber
		
Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
		0 NumberOfSpacesToPad,
		'OVERHEADEXPENSE' GroupDisplayCode,
		'Overhead  Expenses',
		260 DisplayOrderNumber

--Removed due to IMS #62074 
/*
Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
		0 NumberOfSpacesToPad,
		'GROSSOVERHEADEXPENSE' GroupDisplayCode,
		'Gross Overhead  Expenses',
		261 DisplayOrderNumber
*/

IF @DisplayOverheadBy = 'Unallocated'
	BEGIN

	Insert Into #Result
	(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
	MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
	MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
	YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
	YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
	AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

	Select 
			0 NumberOfSpacesToPad,
			'Gross ' + gac.MajorCategoryName GroupDisplayCode,
			'Gross ' + gac.MajorCategoryName,
			262 DisplayOrderNumber,
			ISNULL(SUM(t1.MtdActual),0) * -1,
			ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
			
			-- Variance amounts adjusted as per IMS 61749
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.MtdVarianceQ0 * -1) ELSE t1.MtdVarianceQ0 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.MtdVarianceQ1 * -1) ELSE t1.MtdVarianceQ1 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.MtdVarianceQ2 * -1) ELSE t1.MtdVarianceQ2 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.MtdVarianceQ3 * -1) ELSE t1.MtdVarianceQ3 END),0) * -1,
			ISNULL(SUM(t1.YtdActual),0) * -1,
			ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.YtdVarianceQ0 * -1) ELSE t1.YtdVarianceQ0 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.YtdVarianceQ1 * -1) ELSE t1.YtdVarianceQ1 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.YtdVarianceQ2 * -1) ELSE t1.YtdVarianceQ2 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.YtdVarianceQ3 * -1) ELSE t1.YtdVarianceQ3 END),0) * -1,
			ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

	From GlAccountCategory gac

				LEFT OUTER JOIN (Select * 
				From #DetailResult t1 
				Where t1.ExpenseType = 'Overhead') t1 ON gac.GlAccountCategoryKey = t1.GlAccountCategoryKey
				
	Where	gac.FeeOrExpense			= 'Expense'
	AND		gac.TranslationSubTypeName	= @TranslationTypeName
	AND		gac.AccountSubTypeName		= 'Overhead'
	AND		gac.MajorCategoryName		<> 'Corporate Tax'
	Group By 
			gac.MajorCategoryName	
				
	END
ELSE
	BEGIN

	Insert Into #Result
	(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
	MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
	MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
	YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
	YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
	AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

	Select 
			0 NumberOfSpacesToPad,
			'Gross ' + gac.MajorCategoryName GroupDisplayCode,
			'Gross ' + gac.MajorCategoryName,
			262 DisplayOrderNumber,
			ISNULL(SUM(t1.MtdActual),0) * -1,
			ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
			-- Variance amounts adjusted as per IMS 61749
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.MtdVarianceQ0 * -1) ELSE t1.MtdVarianceQ0 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.MtdVarianceQ1 * -1) ELSE t1.MtdVarianceQ1 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.MtdVarianceQ2 * -1) ELSE t1.MtdVarianceQ2 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.MtdVarianceQ3 * -1) ELSE t1.MtdVarianceQ3 END),0) * -1,
			ISNULL(SUM(t1.YtdActual),0) * -1,
			ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.YtdVarianceQ0 * -1) ELSE t1.YtdVarianceQ0 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.YtdVarianceQ1 * -1) ELSE t1.YtdVarianceQ1 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.YtdVarianceQ2 * -1) ELSE t1.YtdVarianceQ2 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.YtdVarianceQ3 * -1) ELSE t1.YtdVarianceQ3 END),0) * -1,
			ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

	From GlAccountCategory gac

				INNER JOIN (Select * 
				From #DetailResult t1 
				Where t1.ExpenseType = 'Overhead') t1 ON gac.GlAccountCategoryKey = t1.GlAccountCategoryKey
				
	Where	gac.FeeOrExpense		= 'Expense'
	AND		gac.TranslationSubTypeName	= @TranslationTypeName
	AND		gac.AccountSubTypeName		= 'Overhead'
	AND		gac.MajorCategoryName		<> 'Corporate Tax'
	Group By 
			gac.MajorCategoryName	
	END

--IMS #62074
/*
IF @DisplayOverheadBy = 'Unallocated'
	BEGIN
	Insert Into #Result
	(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
	MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
	MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
	YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
	YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
	AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

	Select 
			0 NumberOfSpacesToPad,
			'Total Gross Overhead Expense' GroupDisplayCode,
			'Total Gross Overhead Expense',
			263 DisplayOrderNumber,
			ISNULL(SUM(t1.MtdActual),0) * -1,
			ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
			-- Variance amounts adjusted as per IMS 61749
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.MtdVarianceQ0 * -1) ELSE t1.MtdVarianceQ0 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.MtdVarianceQ1 * -1) ELSE t1.MtdVarianceQ1 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.MtdVarianceQ2 * -1) ELSE t1.MtdVarianceQ2 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.MtdVarianceQ3 * -1) ELSE t1.MtdVarianceQ3 END),0) * -1,
			ISNULL(SUM(t1.YtdActual),0) * -1,
			ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.YtdVarianceQ0 * -1) ELSE t1.YtdVarianceQ0 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.YtdVarianceQ1 * -1) ELSE t1.YtdVarianceQ1 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.YtdVarianceQ2 * -1) ELSE t1.YtdVarianceQ2 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.YtdVarianceQ3 * -1) ELSE t1.YtdVarianceQ3 END),0) * -1,
			ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

	From #DetailResult t1
	Where	t1.FeeOrExpense		= 'Expense'
	AND		t1.ExpenseType		= 'Overhead'
	AND		t1.MajorExpenseCategoryName <>  'Corporate Tax'

END
*/


--Removed due to IMS #62074 
/*
Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
		0 NumberOfSpacesToPad,
		'REIMBERSEDOVERHEADEXPENSE' GroupDisplayCode,
		'Reimbursed Overhead  Expenses',
		270 DisplayOrderNumber
*/

IF @DisplayOverheadBy = 'Unallocated'
	BEGIN
		
	Insert Into #Result
	(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
	MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
	MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
	YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
	YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
	AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

	Select 
			0 NumberOfSpacesToPad,
			'Reimbursed ' + gac.MajorCategoryName GroupDisplayCode,
			'Reimbursed ' + gac.MajorCategoryName,
			271 DisplayOrderNumber,
			ISNULL(SUM(t1.MtdActual),0) * -1,
			ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
			ISNULL(SUM(t1.YtdActual),0) * -1,
			ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
			ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

	From GlAccountCategory gac

				LEFT OUTER JOIN (Select * 
								From #DetailResult t1
								Where	t1.ExpenseType		= 'Overhead'
								AND		t1.ReimbursableName	= 'Reimbursable'
								) t1
								 ON gac.GlAccountCategoryKey = t1.GlAccountCategoryKey
				
	Where	gac.FeeOrExpense		= 'Expense'
	AND		gac.TranslationSubTypeName	= @TranslationTypeName
	AND		gac.AccountSubTypeName		= 'Overhead'
	AND		gac.MajorCategoryName		<> 'Corporate Tax'
	Group By 
			gac.MajorCategoryName	
	END
ELSE
	BEGIN
	Insert Into #Result
	(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
	MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
	MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
	YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
	YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
	AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

	Select 
			0 NumberOfSpacesToPad,
			'Reimbursed ' + gac.MajorCategoryName GroupDisplayCode,
			'Reimbursed ' + gac.MajorCategoryName,
			271 DisplayOrderNumber,
			ISNULL(SUM(t1.MtdActual),0) * -1,
			ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
			ISNULL(SUM(t1.YtdActual),0) * -1,
			ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
			ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

	From GlAccountCategory gac

				INNER JOIN (Select * 
								From #DetailResult t1
								Where	t1.ExpenseType		= 'Overhead'
								AND		t1.ReimbursableName	= 'Reimbursable'
								) t1
								 ON gac.GlAccountCategoryKey = t1.GlAccountCategoryKey
				
	Where	gac.FeeOrExpense		= 'Expense'
	AND		gac.TranslationSubTypeName	= @TranslationTypeName
	AND		gac.AccountSubTypeName		= 'Overhead'
	AND		gac.MajorCategoryName		<> 'Corporate Tax'
	Group By 
			gac.MajorCategoryName	
	END

--IMS #62074
/*			
IF @DisplayOverheadBy = 'Unallocated'
	BEGIN

	Insert Into #Result
	(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
	MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
	MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
	YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
	YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
	AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

	Select 
			0 NumberOfSpacesToPad,
			'Total Reimbursed Overhead Expense' GroupDisplayCode,
			'Total Reimbursed Overhead Expense',
			272 DisplayOrderNumber,
			ISNULL(SUM(t1.MtdActual),0) * -1,
			ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
			ISNULL(SUM(t1.YtdActual),0) * -1,
			ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
			ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

	From #DetailResult t1
	Where	t1.FeeOrExpense		= 'Expense'
	AND		t1.ExpenseType		= 'Overhead'
	AND		ReimbursableName	= 'Reimbursable'
	AND		t1.MajorExpenseCategoryName <> 'Corporate Tax'
END
*/
		
Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		'Total Net Overhead Expense' GroupDisplayCode,
		'Total Net Overhead Expense',
		273 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0) * -1,
		ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.YtdActual),0) * -1,
		ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

From #DetailResult t1
Where	t1.FeeOrExpense		= 'Expense'
AND		t1.ExpenseType		= 'Overhead'
AND		t1.ReimbursableName = 'Not Reimbursable'
AND		t1.MajorExpenseCategoryName <> 'Corporate Tax'


Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		'Overhead Reimbursement Rate' GroupDisplayCode,
		'% Recovery',
		274 DisplayOrderNumber,
		ISNULL(Reimbursed.MtdActual / CASE WHEN Gross.MtdActual = 0 THEN NULL ELSE Gross.MtdActual END,0),
		ISNULL(Reimbursed.MtdOriginalBudget / CASE WHEN Gross.MtdOriginalBudget = 0 THEN NULL ELSE Gross.MtdOriginalBudget END,0),
		ISNULL(Reimbursed.MtdReforecastQ1 / CASE WHEN Gross.MtdReforecastQ1 = 0 THEN NULL ELSE Gross.MtdReforecastQ1 END,0),
		ISNULL(Reimbursed.MtdReforecastQ2 / CASE WHEN Gross.MtdReforecastQ2 = 0 THEN NULL ELSE Gross.MtdReforecastQ2 END,0),
		ISNULL(Reimbursed.MtdReforecastQ3 / CASE WHEN Gross.MtdReforecastQ3 = 0 THEN NULL ELSE Gross.MtdReforecastQ3 END,0),
		0,
		0,
		0,
		0,
		ISNULL(Reimbursed.YtdActual / CASE WHEN Gross.YtdActual = 0 THEN NULL ELSE Gross.YtdActual END,0),
		ISNULL(Reimbursed.YtdOriginalBudget / CASE WHEN Gross.YtdOriginalBudget = 0 THEN NULL ELSE Gross.YtdOriginalBudget END,0),
		ISNULL(Reimbursed.YtdReforecastQ1 / CASE WHEN Gross.YtdReforecastQ1 = 0 THEN NULL ELSE Gross.YtdReforecastQ1 END,0),
		ISNULL(Reimbursed.YtdReforecastQ2 / CASE WHEN Gross.YtdReforecastQ2 = 0 THEN NULL ELSE Gross.YtdReforecastQ2 END,0),
		ISNULL(Reimbursed.YtdReforecastQ3 / CASE WHEN Gross.YtdReforecastQ3 = 0 THEN NULL ELSE Gross.YtdReforecastQ3 END,0),
		0,
		0,
		0,
		0,
		ISNULL(Reimbursed.AnnualOriginalBudget / CASE WHEN Gross.AnnualOriginalBudget = 0 THEN NULL ELSE Gross.AnnualOriginalBudget END,0),
		ISNULL(Reimbursed.AnnualReforecastQ1 / CASE WHEN Gross.AnnualReforecastQ1 = 0 THEN NULL ELSE Gross.AnnualReforecastQ1 END,0),
		ISNULL(Reimbursed.AnnualReforecastQ2 / CASE WHEN Gross.AnnualReforecastQ2 = 0 THEN NULL ELSE Gross.AnnualReforecastQ2 END,0),
		ISNULL(Reimbursed.AnnualReforecastQ3 / CASE WHEN Gross.AnnualReforecastQ3 = 0 THEN NULL ELSE Gross.AnnualReforecastQ3 END,0)

From 
	(
		Select 
					ISNULL(SUM(t1.MtdActual),0) MtdActual,
					ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
					ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
					ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
					ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
					ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
					ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
					ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
					ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
					ISNULL(SUM(t1.YtdActual),0) YtdActual,
					ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
					ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
					ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
					ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
					ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
					ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
					ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
					ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
					ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
					ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
					ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
					ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

		From #DetailResult t1
		Where	t1.FeeOrExpense		= 'Expense'
		AND		t1.ExpenseType		= 'Overhead'
		AND		t1.ReimbursableName	= 'Reimbursable'
		AND		t1.MajorExpenseCategoryName <> 'Corporate Tax'
		) Reimbursed
		CROSS JOIN 
			(
				Select 
					ISNULL(SUM(t1.MtdActual),0) MtdActual,
					ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
					ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
					ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
					ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
					ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
					ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
					ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
					ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
					ISNULL(SUM(t1.YtdActual),0) YtdActual,
					ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
					ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
					ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
					ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
					ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
					ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
					ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
					ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
					ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
					ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
					ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
					ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

				From #DetailResult t1
				Where	t1.FeeOrExpense		= 'Expense'
				AND		t1.ExpenseType		= 'Overhead'
				AND		t1.MajorExpenseCategoryName <> 'Corporate Tax'
			) Gross 

--Calculate the Overhead Reimbursement Rate Variance Columns
Update 		#Result
Set			
			MtdVarianceQ0 = (MtdActual - MtdOriginalBudget),
			MtdVarianceQ1 = (MtdActual - MtdReforecastQ1),
			MtdVarianceQ2 = (MtdActual - MtdReforecastQ2),
			MtdVarianceQ3 = (MtdActual - MtdReforecastQ3),
			YtdVarianceQ0 = (YtdActual - YtdOriginalBudget),
			YtdVarianceQ1 = (YtdActual - YtdReforecastQ1),
			YtdVarianceQ2 = (YtdActual - YtdReforecastQ2),
			YtdVarianceQ3 = (YtdActual - YtdReforecastQ3)

Where	GroupDisplayCode = 'Overhead Reimbursement Rate'
AND		DisplayOrderNumber = 274

	
Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
		0 NumberOfSpacesToPad,
		'BLANK' GroupDisplayCode,
		'',
		280 DisplayOrderNumber
		
Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
		0 NumberOfSpacesToPad,
		'NONPAYROLLEXPENSE' GroupDisplayCode,
		'Non-Payroll Expenses',
		290 DisplayOrderNumber

IF @IncludeGrossNonPayrollExpenses = 1
	BEGIN
	
	Insert Into #Result
	(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
	Select 
		0 NumberOfSpacesToPad,
		'GROSSNONPAYROLLEXPENSE' GroupDisplayCode,
		'Gross Non-Payroll  Expenses',
		291 DisplayOrderNumber

	Insert Into #Result
	(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
	MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
	MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
	YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
	YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
	AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

	Select 
			0 NumberOfSpacesToPad,
			CASE WHEN (gac.MajorCategoryName = 'Salaries/Taxes/Benefits') THEN 'Salaries/Bonus/Taxes/Benefits' ELSE gac.MajorCategoryName END as GroupDisplayCode,
			--gac.MajorCategoryName GroupDisplayCode,
			CASE WHEN (gac.MajorCategoryName = 'Salaries/Taxes/Benefits') THEN 'Salaries/Bonus/Taxes/Benefits' ELSE gac.MajorCategoryName END as MajorCategoryName,
			--gac.MajorCategoryName,
			292 DisplayOrderNumber,
			ISNULL(SUM(t1.MtdActual),0) * -1,
			ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
			
			--IMS #61973
			ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.MtdVarianceQ0 * -1) ELSE t1.MtdVarianceQ0 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.MtdVarianceQ1 * -1) ELSE t1.MtdVarianceQ1 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.MtdVarianceQ2 * -1) ELSE t1.MtdVarianceQ2 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.MtdVarianceQ3 * -1) ELSE t1.MtdVarianceQ3 END),0) * -1,
			
			--ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
			--ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
			--ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
			--ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
			
			ISNULL(SUM(t1.YtdActual),0) * -1,			
			ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
			
			--IMS #61973
			ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.YtdVarianceQ0 * -1) ELSE t1.YtdVarianceQ0 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.YtdVarianceQ1 * -1) ELSE t1.YtdVarianceQ1 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.YtdVarianceQ2 * -1) ELSE t1.YtdVarianceQ2 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.YtdVarianceQ3 * -1) ELSE t1.YtdVarianceQ3 END),0) * -1,
			
			--ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
			--ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
			--ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
			--ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
			
			ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

	From GlAccountCategory gac

			LEFT OUTER JOIN (Select *
							From	#DetailResult t1
							Where	t1.ExpenseType		= 'Non-Payroll'
							) t1 ON gac.GlAccountCategoryKey = t1.GlAccountCategoryKey
			
	Where	gac.FeeOrExpense		= (CASE WHEN gac.MajorCategoryName <> 'Realized (Gain)/Loss' THEN 'Expense' ELSE gac.FeeOrExpense END) --IMS #61973
	AND		gac.TranslationSubTypeName	= @TranslationTypeName
	AND		gac.AccountSubTypeName		= 'Non-Payroll'
	AND		gac.MajorCategoryName NOT IN ('Depreciation Expense', 'Corporate Tax', 'Unrealized (Gain)/Loss')

	Group By 
			CASE WHEN (gac.MajorCategoryName = 'Salaries/Taxes/Benefits') THEN 'Salaries/Bonus/Taxes/Benefits' ELSE gac.MajorCategoryName END	
					

	Insert Into #Result
	(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
	MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
	MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
	YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
	YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
	AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

	Select 
			0 NumberOfSpacesToPad,
			'Total Gross Non-Payroll Expense' GroupDisplayCode,
			'Total Gross Non-Payroll Expense',
			293 DisplayOrderNumber,
			ISNULL(SUM(t1.MtdActual),0) * -1,
			ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
			
			--IMS #61973
			ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.MtdVarianceQ0 * -1) ELSE t1.MtdVarianceQ0 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.MtdVarianceQ1 * -1) ELSE t1.MtdVarianceQ1 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.MtdVarianceQ2 * -1) ELSE t1.MtdVarianceQ2 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.MtdVarianceQ3 * -1) ELSE t1.MtdVarianceQ3 END),0) * -1,
			
			--ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
			--ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
			--ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
			--ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
			
			ISNULL(SUM(t1.YtdActual),0) * -1,
			ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
			
			--IMS #61973
			ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.YtdVarianceQ0 * -1) ELSE t1.YtdVarianceQ0 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.YtdVarianceQ1 * -1) ELSE t1.YtdVarianceQ1 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.YtdVarianceQ2 * -1) ELSE t1.YtdVarianceQ2 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.YtdVarianceQ3 * -1) ELSE t1.YtdVarianceQ3 END),0) * -1,
			
			--ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
			--ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
			--ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
			--ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
			
			ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

	From #DetailResult t1
	Where	t1.FeeOrExpense		= (CASE WHEN t1.MajorExpenseCategoryName <> 'Realized (Gain)/Loss' THEN 'Expense' ELSE t1.FeeOrExpense END) --IMS #61973
	AND		t1.ExpenseType		= 'Non-Payroll'
	AND		t1.MajorExpenseCategoryName NOT IN ('Depreciation Expense', 'Corporate Tax', 'Unrealized (Gain)/Loss')


	END


Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
	0 NumberOfSpacesToPad,
	'NETNONPAYROLLEXPENSE' GroupDisplayCode,
	'Net Non-Payroll  Expenses',
	301 DisplayOrderNumber

Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		CASE WHEN (gac.MajorCategoryName = 'Salaries/Taxes/Benefits') THEN 'Salaries/Bonus/Taxes/Benefits' ELSE gac.MajorCategoryName END as GroupDisplayCode,
		--gac.MajorCategoryName GroupDisplayCode,
		CASE WHEN (gac.MajorCategoryName = 'Salaries/Taxes/Benefits') THEN 'Salaries/Bonus/Taxes/Benefits' ELSE gac.MajorCategoryName END as MajorCategoryName,
		--gac.MajorCategoryName,
		302 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0) * -1,
		ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
		
		--IMS #61973
		ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.MtdVarianceQ0 * -1) ELSE t1.MtdVarianceQ0 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.MtdVarianceQ1 * -1) ELSE t1.MtdVarianceQ1 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.MtdVarianceQ2 * -1) ELSE t1.MtdVarianceQ2 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.MtdVarianceQ3 * -1) ELSE t1.MtdVarianceQ3 END),0) * -1,
			
		--ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
		--ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
		--ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
		--ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
		
		ISNULL(SUM(t1.YtdActual),0) * -1,
		ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
		
		
		--IMS #61973
		ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.YtdVarianceQ0 * -1) ELSE t1.YtdVarianceQ0 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.YtdVarianceQ1 * -1) ELSE t1.YtdVarianceQ1 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.YtdVarianceQ2 * -1) ELSE t1.YtdVarianceQ2 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.YtdVarianceQ3 * -1) ELSE t1.YtdVarianceQ3 END),0) * -1,
			
		--ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
		--ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
		--ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
		--ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
		
		ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

From GlAccountCategory gac

			LEFT OUTER JOIN (Select * 
							From	#DetailResult t1
							Where
									t1.ExpenseType		= 'Non-Payroll'
							AND		t1.ReimbursableName = 'Not Reimbursable'

							) t1 ON gac.GlAccountCategoryKey = t1.GlAccountCategoryKey
			
Where	gac.FeeOrExpense			= (CASE WHEN gac.MajorCategoryName <> 'Realized (Gain)/Loss' THEN 'Expense' ELSE gac.FeeOrExpense END) --IMS #61973
AND		gac.TranslationSubTypeName	= @TranslationTypeName
AND		gac.AccountSubTypeName		= 'Non-Payroll'
AND		gac.MinorCategoryName NOT IN ('Depreciation Expense', 'Corporate Tax', 'Unrealized (Gain)/Loss')

Group By 
		CASE WHEN (gac.MajorCategoryName = 'Salaries/Taxes/Benefits') THEN 'Salaries/Bonus/Taxes/Benefits' ELSE gac.MajorCategoryName END	
				

Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		'Total Net Non-Payroll Expense' GroupDisplayCode,
		'Total Net Non-Payroll Expense',
		303 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0) * -1,
		ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
		
		
		--IMS #61973
		ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.MtdVarianceQ0 * -1) ELSE t1.MtdVarianceQ0 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.MtdVarianceQ1 * -1) ELSE t1.MtdVarianceQ1 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.MtdVarianceQ2 * -1) ELSE t1.MtdVarianceQ2 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.MtdVarianceQ3 * -1) ELSE t1.MtdVarianceQ3 END),0) * -1,
		
		--ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
		--ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
		--ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
		--ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
		
		ISNULL(SUM(t1.YtdActual),0) * -1,
		ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
		
		--IMS #61973
		ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.YtdVarianceQ0 * -1) ELSE t1.YtdVarianceQ0 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.YtdVarianceQ1 * -1) ELSE t1.YtdVarianceQ1 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.YtdVarianceQ2 * -1) ELSE t1.YtdVarianceQ2 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.YtdVarianceQ3 * -1) ELSE t1.YtdVarianceQ3 END),0) * -1,
		
		--ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
		--ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
		--ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
		--ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
		
		ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

From #DetailResult t1
Where	t1.FeeOrExpense		= (CASE WHEN t1.MajorExpenseCategoryName <> 'Realized (Gain)/Loss' THEN 'Expense' ELSE t1.FeeOrExpense END) --IMS #61973
AND		t1.ExpenseType		= 'Non-Payroll'
AND		t1.ReimbursableName = 'Not Reimbursable'
AND		t1.MajorExpenseCategoryName NOT IN ('Depreciation Expense', 'Corporate Tax', 'Unrealized (Gain)/Loss')




Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
		0 NumberOfSpacesToPad,
		'BLANK' GroupDisplayCode,
		'',
		310 DisplayOrderNumber
		
Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		'TOTALNETEXPENSE' GroupDisplayCode,
		'Total Net Expenses',
		320 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0) * -1,
		ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
		
		--IMS #61973
		ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.MtdVarianceQ0 * -1) ELSE t1.MtdVarianceQ0 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.MtdVarianceQ1 * -1) ELSE t1.MtdVarianceQ1 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.MtdVarianceQ2 * -1) ELSE t1.MtdVarianceQ2 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.MtdVarianceQ3 * -1) ELSE t1.MtdVarianceQ3 END),0) * -1,
		
		--ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
		--ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
		--ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
		--ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
		
		ISNULL(SUM(t1.YtdActual),0) * -1,
		ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
		
		--IMS #61973
		ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.YtdVarianceQ0 * -1) ELSE t1.YtdVarianceQ0 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.YtdVarianceQ1 * -1) ELSE t1.YtdVarianceQ1 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.YtdVarianceQ2 * -1) ELSE t1.YtdVarianceQ2 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.FeeOrExpense = 'Income' THEN (t1.YtdVarianceQ3 * -1) ELSE t1.YtdVarianceQ3 END),0) * -1,
		
		--ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
		--ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
		--ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
		--ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
		
		ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

From #DetailResult t1
Where	t1.FeeOrExpense		= (CASE WHEN t1.MajorExpenseCategoryName <> 'Realized (Gain)/Loss' THEN 'Expense' ELSE t1.FeeOrExpense END) --IMS #61973
AND		t1.ReimbursableName = 'Not Reimbursable'
AND		t1.MajorExpenseCategoryName NOT IN ('Depreciation Expense', 'Corporate Tax', 'Unrealized (Gain)/Loss')

Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
		0 NumberOfSpacesToPad,
		'BLANK' GroupDisplayCode,
		'',
		321 DisplayOrderNumber

Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)
Select 
		0 NumberOfSpacesToPad,
		'INCOMELOSSBEFOREDEPRECIATIONANDTAX' GroupDisplayCode,
		'Income / (Loss) Before Taxes and Depreciation',
		322 DisplayOrderNumber,
		(INC.MtdActual + EP.MtdActual) AS MtdActual,
		(INC.MtdOriginalBudget + EP.MtdOriginalBudget) AS MtdOriginalBudget,
		(INC.MtdReforecastQ1 + EP.MtdReforecastQ1) AS MtdReforecastQ1,
		(INC.MtdReforecastQ2 + EP.MtdReforecastQ2) AS MtdReforecastQ2,
		(INC.MtdReforecastQ3 + EP.MtdReforecastQ3) AS MtdReforecastQ3,
		(INC.MtdVarianceQ0 - EP.MtdVarianceQ0) AS MtdVarianceQ0,
		(INC.MtdVarianceQ1 - EP.MtdVarianceQ1) AS MtdVarianceQ1,
		(INC.MtdVarianceQ2 - EP.MtdVarianceQ2) AS MtdVarianceQ2,
		(INC.MtdVarianceQ3 - EP.MtdVarianceQ3) AS MtdVarianceQ3,
		(INC.YtdActual + EP.YtdActual) AS YtdActual,
		(INC.YtdOriginalBudget + EP.YtdOriginalBudget) AS YtdOriginalBudget,
		(INC.YtdReforecastQ1 + EP.YtdReforecastQ1) AS YtdReforecastQ1,
		(INC.YtdReforecastQ2 + EP.YtdReforecastQ2) AS YtdReforecastQ2,
		(INC.YtdReforecastQ3 + EP.YtdReforecastQ3) AS YtdReforecastQ3,
		(INC.YtdVarianceQ0 - EP.YtdVarianceQ0) AS YtdVarianceQ0,
		(INC.YtdVarianceQ1 - EP.YtdVarianceQ1) AS YtdVarianceQ1,
		(INC.YtdVarianceQ2 - EP.YtdVarianceQ2) AS YtdVarianceQ2,
		(INC.YtdVarianceQ3 - EP.YtdVarianceQ3) AS YtdVarianceQ3,
		(INC.AnnualOriginalBudget + EP.AnnualOriginalBudget) AS AnnualOriginalBudget,
		(INC.AnnualReforecastQ1 + EP.AnnualReforecastQ1) AS AnnualReforecastQ1,
		(INC.AnnualReforecastQ2 + EP.AnnualReforecastQ2) AS AnnualReforecastQ2,
		(INC.AnnualReforecastQ3 + EP.AnnualReforecastQ3) AS AnnualReforecastQ3
		
		
FROM	(
		Select 
				ISNULL(SUM(t1.MtdActual),0) MtdActual,
				ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
				ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
				ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
				ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
				ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
				ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
				ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
				ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
				ISNULL(SUM(t1.YtdActual),0) YtdActual,
				ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
				ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
				ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
				ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
				ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
				ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
				ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
				ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
				ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
				ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
				ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
				ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

		From #DetailResult t1
		Where	t1.FeeOrExpense				= 'INCOME'
		) INC
		CROSS JOIN (
		Select 
				ISNULL(SUM(t1.MtdActual),0) MtdActual,
				ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
				ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
				ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
				ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
				ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
				ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
				ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
				ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
				ISNULL(SUM(t1.YtdActual),0) YtdActual,
				ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
				ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
				ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
				ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
				ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
				ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
				ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
				ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
				ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
				ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
				ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
				ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

			From #DetailResult t1
			Where	t1.FeeOrExpense		= 'Expense'
			AND		t1.ReimbursableName = 'Not Reimbursable'
			AND		t1.MajorExpenseCategoryName NOT IN ('Depreciation Expense', 'Corporate Tax', 'Unrealized (Gain)/Loss')
		) EP
		
		Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
		0 NumberOfSpacesToPad,
		'BLANK' GroupDisplayCode,
		'',
		323 DisplayOrderNumber



Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		gac.MajorCategoryName GroupDisplayCode,
		gac.MajorCategoryName,
		324 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0) * -1,
		ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.YtdActual),0) * -1,
		ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

From GlAccountCategory gac

			LEFT OUTER JOIN (Select * 
							From	#DetailResult t1
							Where
									t1.ExpenseType		= 'Non-Payroll'
							AND		t1.ReimbursableName = 'Not Reimbursable'

							) t1 ON gac.GlAccountCategoryKey = t1.GlAccountCategoryKey
			
Where	gac.FeeOrExpense			= 'Expense'
AND		gac.TranslationSubTypeName	= @TranslationTypeName
AND		gac.AccountSubTypeName		= 'Non-Payroll'
AND		gac.MinorCategoryName = 'Depreciation Expense'
Group By 
		gac.MajorCategoryName	
		
		Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)
Select 
		0 NumberOfSpacesToPad,
		'INCOMELOSSBEFORETAX' GroupDisplayCode,
		'Income / (Loss) Before Taxes',
		325 DisplayOrderNumber,
		(INC.MtdActual + EP.MtdActual) AS MtdActual,
		(INC.MtdOriginalBudget + EP.MtdOriginalBudget) AS MtdOriginalBudget,
		(INC.MtdReforecastQ1 + EP.MtdReforecastQ1) AS MtdReforecastQ1,
		(INC.MtdReforecastQ2 + EP.MtdReforecastQ2) AS MtdReforecastQ2,
		(INC.MtdReforecastQ3 + EP.MtdReforecastQ3) AS MtdReforecastQ3,
		(INC.MtdVarianceQ0 - EP.MtdVarianceQ0) AS MtdVarianceQ0,
		(INC.MtdVarianceQ1 - EP.MtdVarianceQ1) AS MtdVarianceQ1,
		(INC.MtdVarianceQ2 - EP.MtdVarianceQ2) AS MtdVarianceQ2,
		(INC.MtdVarianceQ3 - EP.MtdVarianceQ3) AS MtdVarianceQ3,
		(INC.YtdActual + EP.YtdActual) AS YtdActual,
		(INC.YtdOriginalBudget + EP.YtdOriginalBudget) AS YtdOriginalBudget,
		(INC.YtdReforecastQ1 + EP.YtdReforecastQ1) AS YtdReforecastQ1,
		(INC.YtdReforecastQ2 + EP.YtdReforecastQ2) AS YtdReforecastQ2,
		(INC.YtdReforecastQ3 + EP.YtdReforecastQ3) AS YtdReforecastQ3,
		(INC.YtdVarianceQ0 - EP.YtdVarianceQ0) AS YtdVarianceQ0,
		(INC.YtdVarianceQ1 - EP.YtdVarianceQ1) AS YtdVarianceQ1,
		(INC.YtdVarianceQ2 - EP.YtdVarianceQ2) AS YtdVarianceQ2,
		(INC.YtdVarianceQ3 - EP.YtdVarianceQ3) AS YtdVarianceQ3,
		(INC.AnnualOriginalBudget + EP.AnnualOriginalBudget) AS AnnualOriginalBudget,
		(INC.AnnualReforecastQ1 + EP.AnnualReforecastQ1) AS AnnualReforecastQ1,
		(INC.AnnualReforecastQ2 + EP.AnnualReforecastQ2) AS AnnualReforecastQ2,
		(INC.AnnualReforecastQ3 + EP.AnnualReforecastQ3) AS AnnualReforecastQ3
		
		
FROM	(
		Select 
				ISNULL(SUM(t1.MtdActual),0) MtdActual,
				ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
				ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
				ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
				ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
				ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
				ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
				ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
				ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
				ISNULL(SUM(t1.YtdActual),0) YtdActual,
				ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
				ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
				ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
				ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
				ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
				ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
				ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
				ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
				ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
				ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
				ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
				ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

		From #DetailResult t1
		Where	t1.FeeOrExpense				= 'INCOME'
		) INC
		CROSS JOIN (
		Select 
				ISNULL(SUM(t1.MtdActual),0) MtdActual,
				ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
				ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
				ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
				ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
				ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
				ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
				ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
				ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
				ISNULL(SUM(t1.YtdActual),0) YtdActual,
				ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
				ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
				ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
				ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
				ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
				ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
				ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
				ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
				ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
				ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
				ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
				ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

			From #DetailResult t1
			Where	t1.FeeOrExpense		= 'Expense'
			AND		t1.ReimbursableName = 'Not Reimbursable'
			AND		t1.MajorExpenseCategoryName NOT IN ('Corporate Tax', 'Unrealized (Gain)/Loss')
			
		) EP
		
		Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
		0 NumberOfSpacesToPad,
		'BLANK' GroupDisplayCode,
		'',
		326 DisplayOrderNumber

Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		gac.MajorCategoryName GroupDisplayCode,
		gac.MajorCategoryName,
		327 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0) * -1,
		ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.YtdActual),0) * -1,
		ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

From GlAccountCategory gac

			LEFT OUTER JOIN (Select * 
							From	#DetailResult t1
							Where
									t1.ExpenseType		= 'Non-Payroll'
							AND		t1.ReimbursableName = 'Not Reimbursable'

							) t1 ON gac.GlAccountCategoryKey = t1.GlAccountCategoryKey
			
Where	gac.FeeOrExpense			= 'Expense'
AND		gac.TranslationSubTypeName	= @TranslationTypeName
AND		gac.AccountSubTypeName		= 'Non-Payroll'
AND		gac.MinorCategoryName = 'Unrealized (Gain)/Loss'
Group By 
		gac.MajorCategoryName
	
Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		gac.MajorCategoryName GroupDisplayCode,
		gac.MajorCategoryName,
		328 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0) * -1,
		ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.YtdActual),0) * -1,
		ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

From GlAccountCategory gac

			LEFT OUTER JOIN (Select * 
							From	#DetailResult t1
							Where
									t1.ExpenseType		= 'Non-Payroll'
							AND		t1.ReimbursableName = 'Not Reimbursable'

							) t1 ON gac.GlAccountCategoryKey = t1.GlAccountCategoryKey
			
Where	gac.FeeOrExpense			= 'Expense'
AND		gac.TranslationSubTypeName	= @TranslationTypeName
AND		gac.AccountSubTypeName		= 'Non-Payroll'
AND		gac.MinorCategoryName = 'Corporate Tax'
Group By 
		gac.MajorCategoryName

--Insert Into #Result
--(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
--Select 
--		0 NumberOfSpacesToPad,
--		'BLANK' GroupDisplayCode,
--		'',
--		321 DisplayOrderNumber

Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)
Select 
		0 NumberOfSpacesToPad,
		'NETINCOMELOSS' GroupDisplayCode,
		'NET INCOME / (LOSS)',
		330 DisplayOrderNumber,
		(INC.MtdActual + EP.MtdActual) AS MtdActual,
		(INC.MtdOriginalBudget + EP.MtdOriginalBudget) AS MtdOriginalBudget,
		(INC.MtdReforecastQ1 + EP.MtdReforecastQ1) AS MtdReforecastQ1,
		(INC.MtdReforecastQ2 + EP.MtdReforecastQ2) AS MtdReforecastQ2,
		(INC.MtdReforecastQ3 + EP.MtdReforecastQ3) AS MtdReforecastQ3,
		(INC.MtdVarianceQ0 - EP.MtdVarianceQ0) AS MtdVarianceQ0,
		(INC.MtdVarianceQ1 - EP.MtdVarianceQ1) AS MtdVarianceQ1,
		(INC.MtdVarianceQ2 - EP.MtdVarianceQ2) AS MtdVarianceQ2,
		(INC.MtdVarianceQ3 - EP.MtdVarianceQ3) AS MtdVarianceQ3,
		(INC.YtdActual + EP.YtdActual) AS YtdActual,
		(INC.YtdOriginalBudget + EP.YtdOriginalBudget) AS YtdOriginalBudget,
		(INC.YtdReforecastQ1 + EP.YtdReforecastQ1) AS YtdReforecastQ1,
		(INC.YtdReforecastQ2 + EP.YtdReforecastQ2) AS YtdReforecastQ2,
		(INC.YtdReforecastQ3 + EP.YtdReforecastQ3) AS YtdReforecastQ3,
		(INC.YtdVarianceQ0 - EP.YtdVarianceQ0) AS YtdVarianceQ0,
		(INC.YtdVarianceQ1 - EP.YtdVarianceQ1) AS YtdVarianceQ1,
		(INC.YtdVarianceQ2 - EP.YtdVarianceQ2) AS YtdVarianceQ2,
		(INC.YtdVarianceQ3 - EP.YtdVarianceQ3) AS YtdVarianceQ3,
		(INC.AnnualOriginalBudget + EP.AnnualOriginalBudget) AS AnnualOriginalBudget,
		(INC.AnnualReforecastQ1 + EP.AnnualReforecastQ1) AS AnnualReforecastQ1,
		(INC.AnnualReforecastQ2 + EP.AnnualReforecastQ2) AS AnnualReforecastQ2,
		(INC.AnnualReforecastQ3 + EP.AnnualReforecastQ3) AS AnnualReforecastQ3
		
		
FROM	(
		Select 
				ISNULL(SUM(t1.MtdActual),0) MtdActual,
				ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
				ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
				ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
				ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
				ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
				ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
				ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
				ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
				ISNULL(SUM(t1.YtdActual),0) YtdActual,
				ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
				ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
				ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
				ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
				ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
				ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
				ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
				ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
				ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
				ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
				ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
				ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

		From #DetailResult t1
		Where	t1.FeeOrExpense				= 'INCOME'
		) INC
		CROSS JOIN (
		Select 
				ISNULL(SUM(t1.MtdActual),0) MtdActual,
				ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
				ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
				ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
				ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
				ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
				ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
				ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
				ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
				ISNULL(SUM(t1.YtdActual),0) YtdActual,
				ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
				ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
				ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
				ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
				ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
				ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
				ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
				ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
				ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
				ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
				ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
				ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

			From #DetailResult t1
			Where	t1.FeeOrExpense		= 'Expense'
			AND		t1.ReimbursableName = 'Not Reimbursable'
		) EP


Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)
Select 
		0 NumberOfSpacesToPad,
		'PROFITMARGIN' GroupDisplayCode,
		'Profit Margin (Net Income/(Loss)/ Total Revenue)',
		331 DisplayOrderNumber,
		ISNULL(((INC.MtdActual + EP.MtdActual) / CASE WHEN INC.MtdActual <> 0 THEN INC.MtdActual ELSE NULL END),0) AS MtdActual,
		ISNULL(((INC.MtdOriginalBudget + EP.MtdOriginalBudget) / CASE WHEN INC.MtdOriginalBudget <> 0 THEN INC.MtdOriginalBudget ELSE NULL END),0) AS MtdOriginalBudget,
		ISNULL(((INC.MtdReforecastQ1 + EP.MtdReforecastQ1) / CASE WHEN INC.MtdReforecastQ1 <> 0 THEN INC.MtdReforecastQ1 ELSE NULL END),0) AS MtdReforecastQ1,
		ISNULL(((INC.MtdReforecastQ2 + EP.MtdReforecastQ2) / CASE WHEN INC.MtdReforecastQ2 <> 0 THEN INC.MtdReforecastQ2 ELSE NULL END),0) AS MtdReforecastQ2,
		ISNULL(((INC.MtdReforecastQ3 + EP.MtdReforecastQ3) / CASE WHEN INC.MtdReforecastQ3 <> 0 THEN INC.MtdReforecastQ3 ELSE NULL END),0) AS MtdReforecastQ3,
		0 AS MtdVarianceQ0, --Done Below for it use these results to sub calculate
		0 AS MtdVarianceQ1, --Done Below for it use these results to sub calculate
		0 AS MtdVarianceQ2, --Done Below for it use these results to sub calculate
		0 AS MtdVarianceQ3, --Done Below for it use these results to sub calculate
		ISNULL(((INC.YtdActual + EP.YtdActual) / CASE WHEN INC.YtdActual <> 0 THEN INC.YtdActual ELSE NULL END),0) AS YtdActual,
		ISNULL(((INC.YtdOriginalBudget + EP.YtdOriginalBudget) / CASE WHEN INC.YtdOriginalBudget <> 0 THEN INC.YtdOriginalBudget ELSE NULL END),0) AS YtdOriginalBudget,
		ISNULL(((INC.YtdReforecastQ1 + EP.YtdReforecastQ1) / CASE WHEN INC.YtdReforecastQ1 <> 0 THEN INC.YtdReforecastQ1 ELSE NULL END),0) AS YtdReforecastQ1,
		ISNULL(((INC.YtdReforecastQ2 + EP.YtdReforecastQ2) / CASE WHEN INC.YtdReforecastQ2 <> 0 THEN INC.YtdReforecastQ2 ELSE NULL END),0) AS YtdReforecastQ2,
		ISNULL(((INC.YtdReforecastQ3 + EP.YtdReforecastQ3) / CASE WHEN INC.YtdReforecastQ3 <> 0 THEN INC.YtdReforecastQ3 ELSE NULL END),0) AS YtdReforecastQ3,
		0 AS YtdVarianceQ0, --Done Below for it use these results to sub calculate
		0 AS YtdVarianceQ1, --Done Below for it use these results to sub calculate
		0 AS YtdVarianceQ2, --Done Below for it use these results to sub calculate
		0 AS YtdVarianceQ3, --Done Below for it use these results to sub calculate
		ISNULL(((INC.AnnualOriginalBudget + EP.AnnualOriginalBudget) / CASE WHEN INC.AnnualOriginalBudget <> 0 THEN INC.AnnualOriginalBudget ELSE NULL END),0) AS AnnualOriginalBudget,
		ISNULL(((INC.AnnualReforecastQ1 + EP.AnnualReforecastQ1) / CASE WHEN INC.AnnualReforecastQ1 <> 0 THEN INC.AnnualReforecastQ1 ELSE NULL END),0) AS AnnualReforecastQ1,
		ISNULL(((INC.AnnualReforecastQ2 + EP.AnnualReforecastQ2) / CASE WHEN INC.AnnualReforecastQ2 <> 0 THEN INC.AnnualReforecastQ2 ELSE NULL END),0) AS AnnualReforecastQ2,
		ISNULL(((INC.AnnualReforecastQ3 + EP.AnnualReforecastQ3) / CASE WHEN INC.AnnualReforecastQ3 <> 0 THEN INC.AnnualReforecastQ3 ELSE NULL END),0) AS AnnualReforecastQ3
		
FROM	(
		Select 
				ISNULL(SUM(t1.MtdActual),0) MtdActual,
				ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
				ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
				ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
				ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
				ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
				ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
				ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
				ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
				ISNULL(SUM(t1.YtdActual),0) YtdActual,
				ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
				ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
				ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
				ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
				ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
				ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
				ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
				ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
				ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
				ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
				ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
				ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

		From #DetailResult t1
		Where	t1.FeeOrExpense				= 'INCOME'
		) INC
		CROSS JOIN (
		Select 
				ISNULL(SUM(t1.MtdActual),0) MtdActual,
				ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
				ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
				ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
				ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
				ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
				ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
				ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
				ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
				ISNULL(SUM(t1.YtdActual),0) YtdActual,
				ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
				ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
				ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
				ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
				ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
				ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
				ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
				ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
				ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
				ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
				ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
				ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

			From #DetailResult t1
			Where	t1.FeeOrExpense		= 'Expense'
			AND		t1.ReimbursableName = 'Not Reimbursable'
		) EP

--Calculate the Profit Variance Columns
Update 		#Result
Set			
			MtdVarianceQ0 = MtdActual - MtdOriginalBudget,
			MtdVarianceQ1 = MtdActual - MtdReforecastQ1,
			MtdVarianceQ2 = MtdActual - MtdReforecastQ2,
			MtdVarianceQ3 = MtdActual - MtdReforecastQ3,
			YtdVarianceQ0 = YtdActual - YtdOriginalBudget,
			YtdVarianceQ1 = YtdActual - YtdReforecastQ1,
			YtdVarianceQ2 = YtdActual - YtdReforecastQ2,
			YtdVarianceQ3 = YtdActual - YtdReforecastQ3

Where	GroupDisplayCode = 'PROFITMARGIN'
AND		DisplayOrderNumber = 331	
		
		
--------------------------------------------------------------------------------------------------------------------------------------	
--Final Common block to set the Variance% columns
--------------------------------------------------------------------------------------------------------------------------------------	
		
Update #Result
Set		
	MtdVariancePercentageQ0 = ISNULL(MtdVarianceQ0 / CASE WHEN MtdOriginalBudget <> 0 THEN MtdOriginalBudget ELSE NULL END,0) ,
	MtdVariancePercentageQ1 = ISNULL(MtdVarianceQ1 / CASE WHEN MtdReforecastQ1 <> 0 THEN MtdReforecastQ1 ELSE NULL END,0) ,
	MtdVariancePercentageQ2 = ISNULL(MtdVarianceQ2 / CASE WHEN MtdReforecastQ2 <> 0 THEN MtdReforecastQ2 ELSE NULL END,0) ,
	MtdVariancePercentageQ3 = ISNULL(MtdVarianceQ3 / CASE WHEN MtdReforecastQ3 <> 0 THEN MtdReforecastQ3 ELSE NULL END,0) ,

	YtdVariancePercentageQ0 = ISNULL(YtdVarianceQ0 / CASE WHEN YtdOriginalBudget <> 0 THEN YtdOriginalBudget ELSE NULL END,0) ,
	YtdVariancePercentageQ1 = ISNULL(YtdVarianceQ1 / CASE WHEN YtdReforecastQ1 <> 0 THEN YtdReforecastQ1 ELSE NULL END,0) ,
	YtdVariancePercentageQ2 = ISNULL(YtdVarianceQ2 / CASE WHEN YtdReforecastQ2 <> 0 THEN YtdReforecastQ2 ELSE NULL END,0) ,
	YtdVariancePercentageQ3 = ISNULL(YtdVarianceQ3 / CASE WHEN YtdReforecastQ3 <> 0 THEN YtdReforecastQ3 ELSE NULL END,0) 
Where GroupDisplayCode NOT IN('Payroll Reimbursement Rate','Overhead Reimbursement Rate','PROFITMARGIN')

--UNKNOWN MajorCategory

Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
		0 NumberOfSpacesToPad,
		'BLANK' GroupDisplayCode,
		'',
		340 DisplayOrderNumber

Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		'UNKNOWN' GroupDisplayCode,
		'Unknown',
		341 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0),
		ISNULL(SUM(t1.MtdOriginalBudget),0),
		ISNULL(SUM(t1.MtdReforecastQ1),0),
		ISNULL(SUM(t1.MtdReforecastQ2),0),
		ISNULL(SUM(t1.MtdReforecastQ3),0),
		ISNULL(SUM(t1.MtdVarianceQ0),0),
		ISNULL(SUM(t1.MtdVarianceQ1),0),
		ISNULL(SUM(t1.MtdVarianceQ2),0),
		ISNULL(SUM(t1.MtdVarianceQ3),0),
		ISNULL(SUM(t1.YtdActual),0),
		ISNULL(SUM(t1.YtdOriginalBudget),0),
		ISNULL(SUM(t1.YtdReforecastQ1),0),
		ISNULL(SUM(t1.YtdReforecastQ2),0),
		ISNULL(SUM(t1.YtdReforecastQ3),0),
		ISNULL(SUM(t1.YtdVarianceQ0),0),
		ISNULL(SUM(t1.YtdVarianceQ1),0),
		ISNULL(SUM(t1.YtdVarianceQ2),0),
		ISNULL(SUM(t1.YtdVarianceQ3),0),
		ISNULL(SUM(t1.AnnualOriginalBudget),0),
		ISNULL(SUM(t1.AnnualReforecastQ1),0),
		ISNULL(SUM(t1.AnnualReforecastQ2),0),
		ISNULL(SUM(t1.AnnualReforecastQ3),0)

From #DetailResult t1
Where	t1.MajorExpenseCategoryName	= 'UNKNOWN'
Having (
		ISNULL(SUM(t1.MtdActual),0) <> 0 OR 
		ISNULL(SUM(t1.MtdOriginalBudget),0) <> 0 OR 
		ISNULL(SUM(t1.MtdReforecastQ1),0) <> 0 OR 
		ISNULL(SUM(t1.MtdReforecastQ2),0) <> 0 OR 
		ISNULL(SUM(t1.MtdReforecastQ3),0) <> 0 OR 
		ISNULL(SUM(t1.MtdVarianceQ0),0) <> 0 OR 
		ISNULL(SUM(t1.MtdVarianceQ1),0) <> 0 OR 
		ISNULL(SUM(t1.MtdVarianceQ2),0) <> 0 OR 
		ISNULL(SUM(t1.MtdVarianceQ3),0) <> 0 OR 
		ISNULL(SUM(t1.YtdActual),0) <> 0 OR 
		ISNULL(SUM(t1.YtdOriginalBudget),0) <> 0 OR 
		ISNULL(SUM(t1.YtdReforecastQ1),0) <> 0 OR 
		ISNULL(SUM(t1.YtdReforecastQ2),0) <> 0 OR 
		ISNULL(SUM(t1.YtdReforecastQ3),0) <> 0 OR 
		ISNULL(SUM(t1.YtdVarianceQ0),0) <> 0 OR 
		ISNULL(SUM(t1.YtdVarianceQ1),0) <> 0 OR 
		ISNULL(SUM(t1.YtdVarianceQ2),0) <> 0 OR 
		ISNULL(SUM(t1.YtdVarianceQ3),0) <> 0 OR 
		ISNULL(SUM(t1.AnnualOriginalBudget),0) <> 0 OR 
		ISNULL(SUM(t1.AnnualReforecastQ1),0) <> 0 OR 
		ISNULL(SUM(t1.AnnualReforecastQ2),0) <> 0 OR 
		ISNULL(SUM(t1.AnnualReforecastQ3),0) <> 0
	)




--------------------------------------------------------------------------------------------------------------------------------------	
--Final Result
--------------------------------------------------------------------------------------------------------------------------------------	

Select 
	NumberOfSpacesToPad,
	GroupDisplayCode,
	REPLICATE(' ', NumberOfSpacesToPad) + GroupDisplayName AS GroupDisplayName,
	DisplayOrderNumber,
	MtdActual,
	MtdOriginalBudget,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE MtdReforecastQ1 END AS MtdReforecastQ1,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE MtdReforecastQ2 END AS MtdReforecastQ2,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE MtdReforecastQ3 END AS MtdReforecastQ3,
	
	MtdVarianceQ0,
	MtdVarianceQ1,
	MtdVarianceQ2,
	MtdVarianceQ3,

	MtdVariancePercentageQ0,
	MtdVariancePercentageQ1,
	MtdVariancePercentageQ2,
	MtdVariancePercentageQ3,
	
	YtdActual,
	YtdOriginalBudget,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE YtdReforecastQ1 END AS YtdReforecastQ1,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE YtdReforecastQ2 END AS YtdReforecastQ2,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE YtdReforecastQ3 END AS YtdReforecastQ3,
	
	YtdVarianceQ0,
	YtdVarianceQ1,
	YtdVarianceQ2,
	YtdVarianceQ3,

	YtdVariancePercentageQ0,
	YtdVariancePercentageQ1,
	YtdVariancePercentageQ2,
	YtdVariancePercentageQ3,
		
	AnnualOriginalBudget,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE AnnualReforecastQ1 END AS AnnualReforecastQ1,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE AnnualReforecastQ2 END AS AnnualReforecastQ2,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE AnnualReforecastQ3 END AS AnnualReforecastQ3
From #Result
Order By 
	DisplayOrderNumber,
	#Result.GroupDisplayCode

--Second Resultset for Excel
--Select * From #DetailResult



SELECT
	ExpenseType,
	FeeOrExpense,
	MajorExpenseCategoryName,
	MinorExpenseCategoryName,
	GlobalGlAccountCode,
	GlobalGlAccountName,
	BusinessLine,
	ActivityType,
	ReportingEntityName,
	ReportingEntityType,
	PropertyFundCode,
	FunctionalDepartmentCode,
	AllocationSubRegionName,
	OriginatingSubRegionName,

	ActualsExpensePeriod,
	EntryDate,
	[User],
	Description,
	AdditionalDescription,
	ReimbursableName,
	FeeAdjustmentCode,
	SourceName,
	GlAccountCategoryKey,
	
	MtdActual,
	MtdOriginalBudget,
	MtdReforecastQ1,
	MtdReforecastQ2,
	MtdReforecastQ3,
	MtdVarianceQ0,
	MtdVarianceQ1,
	MtdVarianceQ2,
	MtdVarianceQ3,
	YtdActual,
	YtdOriginalBudget,
	YtdReforecastQ1,
	YtdReforecastQ2,
	YtdReforecastQ3,
	YtdVarianceQ0,
	YtdVarianceQ1,
	YtdVarianceQ2,
	YtdVarianceQ3,
	AnnualOriginalBudget,
	AnnualReforecastQ1,
	AnnualReforecastQ2,
	AnnualReforecastQ3,
	ConsolidationSubRegionName
FROM
	#DetailResult



GO
























































































































































USE [GrReporting]
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDActivityType]    Script Date: 08/12/2011 18:27:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDActivityType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDActivityType]
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDAllocationRegion]    Script Date: 08/12/2011 18:27:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDAllocationRegion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDAllocationRegion]
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDFunctionalDepartment]    Script Date: 08/12/2011 18:27:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDFunctionalDepartment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDFunctionalDepartment]
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDGlAccount]    Script Date: 08/12/2011 18:27:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDGlAccount]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDGlAccount]
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDGlAccountCategory]    Script Date: 08/12/2011 18:27:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDGlAccountCategory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDGlAccountCategory]
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDOriginatingRegion]    Script Date: 08/12/2011 18:27:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDOriginatingRegion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDOriginatingRegion]
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDPropertyFund]    Script Date: 08/12/2011 18:27:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDPropertyFund]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDPropertyFund]
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDPropertyFund]    Script Date: 08/12/2011 18:27:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDPropertyFund]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_IU_SCDPropertyFund]
	@DataPriorToDate DATETIME

AS

/*	There is a bug in SQL Server 2008 that prevents the use of the MERGE statement when the table that is being merged to is referenced by
	other tables using FKs. [http://connect.microsoft.com/SQLServer/feedback/details/435031/]
	A work-around is to insert the result of the merge into a temp table, and to then insert data from this temp table into the dimension.
*/

DECLARE @NewEndDate DATETIME = GETDATE()
DECLARE @MaximumEndDate DATETIME = ''9999-12-31 00:00:00.000''

CREATE TABLE #PropertyFund (
	PropertyFundId INT NOT NULL,
	PropertyFundName NVARCHAR(100) NOT NULL,
	PropertyFundType VARCHAR(50) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL,
	SnapshotId INT NOT NULL,
	ReasonForChange NVARCHAR(1024) NULL
)
INSERT INTO #PropertyFund (
	PropertyFundId,
	PropertyFundName,
	PropertyFundType,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	PropertyFundId,
	PropertyFundName,
	PropertyFundType,
	UpdatedDate,
	@MaximumEndDate,
	0 AS SnapshotId,
	ReasonForChange
FROM
(
	MERGE INTO
		dbo.PropertyFund DIM
	USING
	(
		SELECT
			S.PropertyFundId,
			S.Name AS PropertyFundName,
			ET.Name AS PropertyFundType,
			S.IsActive,
			S.InsertedDate,
			S.UpdatedDate,
			0 AS SnapshotId
		FROM
			GrReportingStaging.GDM.PropertyFund S

			INNER JOIN GrReportingStaging.GDM.PropertyFundActive(''2011-12-31'') SA ON
				S.ImportKey = SA.ImportKey

			INNER JOIN GrReportingStaging.GDM.EntityType ET ON
				S.EntityTypeId = ET.EntityTypeId
		WHERE
			S.IsPropertyFund = 1

	) AS SRC ON
		SRC.PropertyFundId = DIM.PropertyFundId AND
		SRC.SnapshotId = DIM.SnapshotId AND
		DIM.SnapshotId = 0 -- hardcode 0 as this stored procedure handles only LIVE GDM data, not snapshotted data

	---------
	
	WHEN MATCHED AND -- When a record exists in [Target] and [Source] and is active in [TARGET] but has been updated/deactivated in [SOURCE], end the record in the dimension.
		 DIM.EndDate = @MaximumEndDate AND -- IF the record in the Dimension is currently active AND ...
		(											   -- ... a field has changed OR the record has been deactivated in [SOURCE] ...
			DIM.PropertyFundName <> SRC.PropertyFundName OR
			DIM.PropertyFundType <> SRC.PropertyFundType OR
			SRC.IsActive = 0
		)
	THEN
		UPDATE
		SET
			DIM.EndDate = SRC.UpdatedDate,  -- ... THEN deactivate the dimension record by updating its EndDate
											-- Note that other changes that might have been made to the record in [SOURCE] during its deactivation
											-- will not be reflected here.
			DIM.ReasonForChange = (CASE WHEN SRC.IsActive = 0 THEN ''Record deactivated in source'' ELSE ''Record updated in source'' END)
											

	-----------
	
	WHEN NOT MATCHED BY SOURCE AND -- When a record exists in [Target] that doesn''t exist in [Source], ''end'' it
		 DIM.SnapshotId = 0 AND
		 DIM.PropertyFundKey <> -1
	THEN
		UPDATE
		SET
			DIM.EndDate = @NewEndDate,
			ReasonForChange = ''Record no longer exists in source''

	-----------
	
	WHEN NOT MATCHED BY TARGET THEN -- When a record exists in [Source] that doesn''t exist in [Target], insert it
		INSERT (
			PropertyFundId,
			PropertyFundName,
			PropertyFundType,
			StartDate,
			EndDate,
			SnapshotId,
			ReasonForChange
		)
		VALUES (
			SRC.PropertyFundId,
			SRC.PropertyFundName,
			SRC.PropertyFundType,
			SRC.InsertedDate,
			@MaximumEndDate,
			SRC.SnapshotId,
			''New record in source''	
		)

	-----------

	OUTPUT
		SRC.PropertyFundId,
		SRC.PropertyFundName,
		SRC.PropertyFundType,
		SRC.SnapshotId,
		SRC.IsActive,
		''Record updated in source'' AS ReasonForChange,
		DATEADD(ms, 10, SRC.UpdatedDate) AS UpdatedDate,
		$Action AS MergeAction

) AS MergedData
WHERE
	MergedData.MergeAction = ''UPDATE'' AND  -- This bit is important: Only insert a new record into the dimension if the merge triggered an update 
	IsActive = 1                           -- AND the dimension record that was updated is still active. If the record was deactivated in [SOURCE]
										   -- we don''t want to create a new record for it - we only need to ''end'' its existing record in [TARGET]

---------------------------------

INSERT INTO dbo.PropertyFund (
	PropertyFundId,
	PropertyFundName,
	PropertyFundType,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	PropertyFundId,
	PropertyFundName,
	PropertyFundType,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
FROM
	#PropertyFund


' 
END
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDOriginatingRegion]    Script Date: 08/12/2011 18:27:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDOriginatingRegion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_IU_SCDOriginatingRegion]
	@DataPriorToDate DATETIME

AS

/*	There is a bug in SQL Server 2008 that prevents the use of the MERGE statement when the table that is being merged to is referenced by
	other tables using FKs. [http://connect.microsoft.com/SQLServer/feedback/details/435031/]
	A work-around is to insert the result of the merge into a temp table, and to then insert data from this temp table into the dimension.
*/

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record needs to be ended, use this date
DECLARE @MaximumEndDate DATETIME = ''9999-12-31 00:00:00.000''

CREATE TABLE #OriginatingRegion (
	GlobalRegionId INT NOT NULL,
	RegionCode NVARCHAR(10) NOT NULL,
	RegionName NVARCHAR(50) NOT NULL,
	SubRegionCode NVARCHAR(10) NOT NULL,
	SubRegionName NVARCHAR(50) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL,
	SnapshotId INT NOT NULL,
	ReasonForChange NVARCHAR(1024) NULL
)
INSERT INTO #OriginatingRegion( -- Dimension
	GlobalRegionId,
	RegionCode,
	RegionName,
	SubRegionCode,
	SubRegionName,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	GlobalRegionId,
	RegionCode,
	RegionName,
	SubRegionCode,
	SubRegionName,
	UpdatedDate AS StartDate,
	@MaximumEndDate AS EndDate,
	SnapshotId,
	ReasonForChange
FROM
(
	MERGE INTO
		dbo.OriginatingRegion DIM
	USING
	(
		SELECT
			GlobalRegionId,
			RegionCode,
			RegionName,
			ISNULL(SubRegionCode, ''UNKNOWN'') AS SubRegionCode,
			ISNULL(SubRegionName, ''UNKNOWN'') AS SubRegionName,
			InsertedDate,
			UpdatedDate,
			IsActive,
			0 AS SnapshotId
		FROM
			GrReportingStaging.Gr.GetGlobalRegionExpanded(@DataPriorToDate)
		WHERE
			IsOriginatingRegion = 1

	) AS SRC ON
		SRC.GlobalRegionId = DIM.GlobalRegionId AND
		SRC.SnapshotId = DIM.SnapshotId AND
		DIM.SnapshotId = 0 -- hardcode 0 as this stored procedure handles only LIVE GDM data, not snapshotted data

	--------

	WHEN MATCHED AND -- When a record exists in [Target] and [Source] and is active in [TARGET] but has been updated/deactivated in [SOURCE], end the record in the dimension.
		 DIM.EndDate = @MaximumEndDate AND					-- IF the record in the Dimension is currently active AND ...
		(										            -- ... a field has changed OR the record has been deactivated in [SOURCE] ...
			DIM.RegionCode <> SRC.RegionCode OR
			DIM.RegionName <> SRC.RegionName OR
			DIM.SubRegionCode <> SRC.SubRegionCode OR
			DIM.SubRegionName <> SRC.SubRegionName OR
			SRC.IsActive = 0
		)
	THEN
		UPDATE
		SET
			DIM.EndDate = SRC.UpdatedDate,                  -- ... THEN deactivate the dimension record by updating its EndDate
															-- Note that other changes that might have been made to the record in [SOURCE] during
															-- its deactivation will not be reflected here.
			DIM.ReasonForChange = (CASE WHEN SRC.IsActive = 0 THEN ''Record deactivated in source'' ELSE ''Record updated in source'' END)

	--------

	WHEN NOT MATCHED BY TARGET THEN -- When a record exists in [Source] that doesn''t exist in [Target], insert it
		INSERT (
			GlobalRegionId,
			RegionCode,
			RegionName,
			SubRegionCode,
			SubRegionName,
			StartDate,
			EndDate,
			SnapshotId,
			ReasonForChange
		)
		VALUES (
			SRC.GlobalRegionId,
			SRC.RegionCode,
			SRC.RegionName,
			SRC.SubRegionCode,
			SRC.SubRegionName,
			SRC.InsertedDate,
			@MaximumEndDate,
			SRC.SnapshotId,
			''New record in source''
		)

	--------

	WHEN NOT MATCHED BY SOURCE AND -- When a record exists in [Target] that doesn''t exist in [Source], ''end'' it
		 DIM.SnapshotId = 0 AND
		 DIM.OriginatingRegionKey <> -1 -- do not update the ''UNKNOWN'' record; this will not be matched in SOURCE
	THEN
		UPDATE
		SET
			DIM.EndDate = @NewEndDate,
			ReasonForChange = ''Record no longer exists in source''			

	--------

	OUTPUT -- Dimension
		SRC.GlobalRegionId,
		SRC.RegionCode,
		SRC.RegionName,
		SRC.SubRegionCode,
		SRC.SubRegionName,
		SRC.IsActive,
		SRC.SnapshotId,
		''Record updated in source'' AS ReasonForChange,
		DATEADD(ms, 10, SRC.UpdatedDate) AS UpdatedDate,
		$Action AS MergeAction

) AS MergedData
WHERE
	MergedData.MergeAction = ''UPDATE'' AND
	MergedData.IsActive = 1					-- Only insert records that are still active into the dimension. Without this check, deactivated
											-- records will be reinserted into the dimension after having been deactivated.

---------------------------------

INSERT INTO dbo.OriginatingRegion( -- Dimension
	GlobalRegionId,
	RegionCode,
	RegionName,
	SubRegionCode,
	SubRegionName,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	GlobalRegionId,
	RegionCode,
	RegionName,
	SubRegionCode,
	SubRegionName,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
FROM
	#OriginatingRegion

' 
END
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDGlAccountCategory]    Script Date: 08/12/2011 18:27:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDGlAccountCategory]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_IU_SCDGlAccountCategory]
	@DataPriorToDate DATETIME

AS

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record needs to be ended, use this date
DECLARE @MaximumEndDate DATETIME = ''9999-12-31 00:00:00.000''

/*	There is a bug in SQL Server 2008 that prevents the use of the MERGE statement when the table that is being merged to is referenced by
	other tables using FKs. [http://connect.microsoft.com/SQLServer/feedback/details/435031/]
	A work-around is to insert the result of the merge into a temp table, and to then insert data from this temp table into the dimension.
*/

CREATE TABLE #GLAccountCategory (
	GlobalGlAccountCategoryCode NVARCHAR(32) NOT NULL,
	TranslationTypeName NVARCHAR(50) NOT NULL,
	TranslationSubTypeName NVARCHAR(50) NOT NULL,
	MajorCategoryName NVARCHAR(50) NOT NULL,
	MinorCategoryName NVARCHAR(100) NOT NULL,
	FeeOrExpense NVARCHAR(50) NOT NULL,
	AccountSubTypeName NVARCHAR(50) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL,
	SnapshotId INT NOT NULL,
	ReasonForChange NVARCHAR(1024) NULL
)
INSERT INTO #GlAccountCategory( -- Dimension
	GlobalGlAccountCategoryCode,
	TranslationTypeName,
	TranslationSubTypeName,
	MajorCategoryName,
	MinorCategoryName,
	FeeOrExpense,
	AccountSubTypeName,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	GlobalGlAccountCategoryCode,
	TranslationTypeName,
	TranslationSubTypeName,
	MajorCategoryName,
	MinorCategoryName,
	FeeOrExpense,
	AccountSubTypeName,
	UpdatedDate AS StartDate,
	@MaximumEndDate AS EndDate,
	0 AS SnapshotId,
	ReasonForChange
FROM
(
	MERGE INTO
		dbo.GlAccountCategory DIM
	USING
	(
		SELECT
			GlobalAccountCategoryCode AS GlobalGlAccountCategoryCode,
			TranslationTypeName,
			TranslationSubTypeName,
			GLMajorCategoryName AS MajorCategoryName,
			GLMinorCategoryName AS MinorCategoryName,
			FeeOrExpense,
			GLAccountSubTypeName AS AccountSubTypeName,
			IsActive,
			InsertedDate,
			UpdatedDate,
			0 AS SnapshotId
		FROM
			GrReportingStaging.GR.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate) S -- S stands for SOURCE

	) AS SRC ON
		SRC.GlobalGlAccountCategoryCode = DIM.GlobalGlAccountCategoryCode AND
		SRC.SnapshotId = DIM.SnapshotId AND
		DIM.SnapshotId = 0 -- hardcode 0 as this stored procedure handles only LIVE GDM data, not snapshotted data

	--------

	WHEN MATCHED AND -- When a record exists in [Target] and [Source] and is active in [TARGET] but has been updated/deactivated in [SOURCE], end the record in the dimension.
		 DIM.EndDate = @MaximumEndDate AND					-- IF the record in the Dimension is currently active AND ...
		(										            -- ... a field has changed OR !the record has been deactivated in [SOURCE]! ...
			DIM.TranslationTypeName <> SRC.TranslationTypeName OR
			DIM.TranslationSubTypeName <> SRC.TranslationSubTypeName OR
			DIM.MajorCategoryName <> SRC.MajorCategoryName OR
			DIM.MinorCategoryName <> SRC.MinorCategoryName OR
			DIM.FeeOrExpense <> SRC.FeeOrExpense OR
			DIM.AccountSubTypeName <> SRC.AccountSubTypeName OR
			SRC.IsActive = 0
		)
	THEN
		UPDATE
		SET
			DIM.EndDate = SRC.UpdatedDate,                   -- ... THEN deactivate the dimension record by updating its EndDate
			DIM.ReasonForChange = (CASE WHEN SRC.IsActive = 0 THEN ''Record deactivated in source'' ELSE ''Record updated in source'' END)

				-- Note that other changes that might have been made to the record in [SOURCE] during its deactivation will not be reflected here.	

	--------

	WHEN NOT MATCHED BY TARGET THEN -- When a record exists in [Source] that doesn''t exist in [Target], insert it
		INSERT (
			GlobalGlAccountCategoryCode,
			TranslationTypeName,
			TranslationSubTypeName,
			MajorCategoryName,
			MinorCategoryName,
			FeeOrExpense,
			AccountSubTypeName,
			StartDate,
			EndDate,
			SnapshotId,
			ReasonForChange
		)
		VALUES (
			SRC.GlobalGlAccountCategoryCode,
			SRC.TranslationTypeName,
			SRC.TranslationSubTypeName,
			SRC.MajorCategoryName,
			SRC.MinorCategoryName,
			SRC.FeeOrExpense,
			SRC.AccountSubTypeName,
			@NewEndDate,--SRC.InsertedDate,
			@MaximumEndDate,
			SRC.SnapshotId,
			''New record in source''
		)

	--------

	WHEN NOT MATCHED BY SOURCE AND -- When a record exists in [Target] that doesn''t exist in [Source], ''end'' it
		 DIM.SnapshotId = 0 AND
		 DIM.GlAccountCategoryKey <> -1 -- do not update the ''UNKNOWN'' record; this will not be matched in SOURCE
	THEN
		UPDATE
		SET
			DIM.EndDate = @NewEndDate,
			ReasonForChange = ''Record no longer exists in source''

	--------

	OUTPUT -- Dimension
		SRC.GlobalGlAccountCategoryCode,
		SRC.TranslationTypeName,
		SRC.TranslationSubTypeName,
		SRC.MajorCategoryName,
		SRC.MinorCategoryName,
		SRC.FeeOrExpense,
		SRC.AccountSubTypeName,
		SRC.SnapshotId,
		SRC.IsActive,
		@NewEndDate AS UpdatedDate, --DATEADD(ms, 10, SRC.UpdatedDate) AS UpdatedDate,
		''Record updated in source'' AS ReasonForChange,
		$Action AS MergeAction

) AS MergedData
WHERE
	MergedData.MergeAction = ''UPDATE'' AND
	MergedData.IsActive = 1 AND						   -- Only insert records into the dimension that are active.
	MergedData.GlobalGlAccountCategoryCode IS NOT NULL -- This NOT NULL check is needed to prevent an empty record being inserted into the
													   -- dimension. It seems that hardcoding the EndDate to ''9999-12-31 00:00:00.000'' in the
													   -- outer INSERT statement triggers an INSERT that failes because every field besides the
													   -- hardcoded EndDate is NULL.

-----------------------------------------------

INSERT INTO dbo.GlAccountCategory( -- Dimension
	GlobalGlAccountCategoryCode,
	TranslationTypeName,
	TranslationSubTypeName,
	MajorCategoryName,
	MinorCategoryName,
	FeeOrExpense,
	AccountSubTypeName,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	GlobalGlAccountCategoryCode,
	TranslationTypeName,
	TranslationSubTypeName,
	MajorCategoryName,
	MinorCategoryName,
	FeeOrExpense,
	AccountSubTypeName,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
FROM
	#GLAccountCategory



' 
END
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDGlAccount]    Script Date: 08/12/2011 18:27:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDGlAccount]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_IU_SCDGlAccount]
	@DataPriorToDate DATETIME

AS

/*	There is a bug in SQL Server 2008 that prevents the use of the MERGE statement when the table that is being merged to is referenced by
	other tables using FKs. [http://connect.microsoft.com/SQLServer/feedback/details/435031/]
	A work-around is to insert the result of the merge into a temp table, and to then insert data from this temp table into the dimension.
*/

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record needs to be ended, use this date
DECLARE @MaximumEndDate DATETIME = ''9999-12-31 00:00:00.000''

CREATE TABLE #GlAccount (
	GLGlobalAccountId INT NOT NULL,
	Code NVARCHAR(10) NULL,
	Name NVARCHAR(150) NULL,
	AccountType NVARCHAR(50) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL,
	SnapshotId INT NOT NULL,
	ReasonForChange NVARCHAR(1024) NULL
)
INSERT INTO #GlAccount( -- Dimension
	GLGlobalAccountId,
	Code,
	Name,
	AccountType,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	GLGlobalAccountId,
	Code,
	Name,
	AccountType,
	UpdatedDate AS StartDate,
	@MaximumEndDate AS EndDate,
	SnapshotId,
	ReasonForChange
FROM
(
	MERGE INTO
		dbo.GlAccount DIM
	USING
	(
		SELECT
			GLGLobalAccountId,
			Code,
			Name,
			'''' AS AccountType,
			InsertedDate,
			UpdatedDate,
			IsActive,
			0 AS SnapshotId
		FROM
			GrReportingStaging.Gdm.GLGLobalAccount S -- S stands for SOURCE
			
			INNER JOIN GrReportingStaging.Gdm.GLGlobalAccountActive(''2011-12-31'') SA ON
				S.ImportKey = SA.ImportKey

	) AS SRC ON
		SRC.GLGlobalAccountId = DIM.GLGlobalAccountId AND
		SRC.SnapshotId = DIM.SnapshotId AND
		DIM.SnapshotId = 0 -- hardcode 0 as this stored procedure handles only LIVE GDM data, not snapshotted data

	--------

	WHEN MATCHED AND -- When a record exists in [Target] and [Source] and is active in [TARGET] but has been updated/deactivated in [SOURCE], end the record in the dimension.
		 DIM.EndDate = @MaximumEndDate AND					-- IF the record in the Dimension is currently active AND ...
		(										            -- ... a field has changed OR the record has been deactivated in [SOURCE] ...
			DIM.Code <> SRC.Code OR
			DIM.Name <> SRC.Name OR
			DIM.AccountType <> SRC.AccountType OR
			SRC.IsActive = 0
		)
	THEN
		UPDATE
		SET
			DIM.EndDate = SRC.UpdatedDate,                  -- ... THEN deactivate the dimension record by updating its EndDate
															-- Note that other changes that might have been made to the record in [SOURCE] during
															-- its deactivation will not be reflected here.
			DIM.ReasonForChange = (CASE WHEN SRC.IsActive = 0 THEN ''Record deactivated in source'' ELSE ''Record updated in source'' END)

	--------

	WHEN NOT MATCHED BY TARGET -- When a record exists in [Source] that doesn''t exist in [Target], insert it
	THEN 
		INSERT (
			GLGlobalAccountId,
			Code,
			Name,
			AccountType,
			StartDate,
			EndDate,
			SnapshotId,
			ReasonForChange
		)
		VALUES (
			SRC.GLGlobalAccountId,
			SRC.Code,
			SRC.Name,
			SRC.AccountType,
			SRC.InsertedDate,
			@MaximumEndDate,
			SRC.SnapshotId,
			''New record in source''	
		)

	--------

	WHEN NOT MATCHED BY SOURCE AND -- When a record exists in [Target] that doesn''t exist in [Source], ''end'' it
		 DIM.SnapshotId = 0 AND
		 DIM.GlAccountKey <> -1 -- do not update the ''UNKNOWN'' record; this will not be matched in SOURCE
	THEN
		UPDATE
		SET
			DIM.EndDate = @NewEndDate,
			ReasonForChange = ''Record no longer exists in source''			

	--------

	OUTPUT -- Dimension
		SRC.GLGlobalAccountId,
		SRC.Code,
		SRC.Name,
		SRC.AccountType,
		SRC.IsActive,
		SRC.SnapshotId,
		''Record updated in source'' AS ReasonForChange,
		DATEADD(ms, 10, SRC.UpdatedDate) AS UpdatedDate,
		$Action AS MergeAction

) AS MergedData
WHERE
	MergedData.MergeAction = ''UPDATE'' AND
	MergedData.IsActive = 1					-- Only insert records that are still active into the dimension. Without this check, deactivated
											-- records will be reinserted into the dimension after having been deactivated.

----------------------------------

INSERT INTO dbo.GlAccount( -- Dimension
	GLGlobalAccountId,
	Code,
	Name,
	AccountType,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	GLGlobalAccountId,
	Code,
	Name,
	AccountType,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange

FROM
	#GlAccount

' 
END
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDFunctionalDepartment]    Script Date: 08/12/2011 18:27:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDFunctionalDepartment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_IU_SCDFunctionalDepartment]
	@DataPriorToDate DATETIME

AS

/*	There is a bug in SQL Server 2008 that prevents the use of the MERGE statement when the table that is being merged to is referenced by
	other tables using FKs. [http://connect.microsoft.com/SQLServer/feedback/details/435031/]
	A work-around is to insert the result of the merge into a temp table, and to then insert data from this temp table into the dimension.
*/

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record needs to be ended, use this date
DECLARE @MaximumEndDate DATETIME = ''9999-12-31 00:00:00.000''

CREATE TABLE #FunctionalDepartment ( -- Dimension
	ReferenceCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentName VARCHAR(100) NOT NULL,
	SubFunctionalDepartmentCode VARCHAR(20) NOT NULL,
	SubFunctionalDepartmentName VARCHAR(100) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL,
	ReasonForChange NVARCHAR(1024) NULL
)

INSERT INTO #FunctionalDepartment ( -- Dimension
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	StartDate,
	EndDate,
	ReasonForChange
)
SELECT
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	UpdatedDate AS StartDate,
	@MaximumEndDate AS EndDate,
	ReasonForChange
FROM
(
	MERGE INTO
		dbo.FunctionalDepartment DIM
	USING
	(
		SELECT
			ReferenceCode,
			FunctionalDepartmentCode,
			FunctionalDepartmentName,
			SubFunctionalDepartmentCode,
			SubFunctionalDepartmentName,
			UpdatedDate,
			IsActive
		FROM
			GrReportingStaging.Gr.GetFunctionalDepartmentExpanded(''2011-12-31'')	

	) AS SRC ON
		SRC.ReferenceCode = DIM.ReferenceCode

	--------

	WHEN MATCHED AND -- When a record exists in [Target] and [Source] and is active in [TARGET] but has been updated/deactivated in [SOURCE], end the record in the dimension.
		 DIM.EndDate = @MaximumEndDate AND					-- IF the record in the Dimension is currently active AND ...
		(										            -- ... a field has changed OR the record has been deactivated in [SOURCE] ...
			DIM.FunctionalDepartmentCode <> SRC.FunctionalDepartmentCode OR
			DIM.FunctionalDepartmentName <> SRC.FunctionalDepartmentName OR
			DIM.SubFunctionalDepartmentCode <> SRC.SubFunctionalDepartmentCode OR
			DIM.SubFunctionalDepartmentName <> SRC.SubFunctionalDepartmentName OR
			SRC.IsActive = 0
		) AND
		DIM.ReferenceCode NOT IN (''LGL:'', ''LGL:UNKNOWN'', ''LGL:RSK'', ''LGL:RIM'')
	THEN
		UPDATE
		SET
			DIM.EndDate = (CASE WHEN SRC.UpdatedDate < DIM.StartDate THEN @NewEndDate ELSE SRC.UpdatedDate END),
										                    -- ... THEN deactivate the dimension record by updating its EndDate
															-- Note that other changes that might have been made to the record in [SOURCE] during
															-- its deactivation will not be reflected here.
			DIM.ReasonForChange = (CASE WHEN SRC.IsActive = 0 THEN ''Record deactivated in source'' ELSE ''Record updated in source'' END)
															
	--------

	WHEN NOT MATCHED BY TARGET THEN -- When a record exists in [Source] that doesn''t exist in [Target], insert it
		INSERT (
			ReferenceCode,
			FunctionalDepartmentCode,
			FunctionalDepartmentName,
			SubFunctionalDepartmentCode,
			SubFunctionalDepartmentName,
			StartDate,
			EndDate,
			ReasonForChange
		)
		VALUES (
			SRC.ReferenceCode,
			SRC.FunctionalDepartmentCode,
			SRC.FunctionalDepartmentName,
			SRC.SubFunctionalDepartmentCode,
			SRC.SubFunctionalDepartmentName,
			SRC.UpdatedDate, -- InsertedDate is not available: use UpdatedDate instead.
			@MaximumEndDate,
			''New record in source''
		)

	--------

	WHEN NOT MATCHED BY SOURCE AND -- When a record exists in [Target] that doesn''t exist in [Source], ''end'' it
		 DIM.FunctionalDepartmentKey <> -1 AND -- do not update the ''UNKNOWN'' record; this will not be matched in SOURCE
		 DIM.ReferenceCode NOT IN (''LGL:'', ''LGL:UNKNOWN'', ''LGL:RSK'', ''LGL:RIM'')
	THEN
		UPDATE
		SET
			DIM.EndDate = @NewEndDate,
			ReasonForChange = ''Record no longer exists in source''


	--------

	OUTPUT -- Dimension
		SRC.ReferenceCode,
		SRC.FunctionalDepartmentCode,
		SRC.FunctionalDepartmentName,
		SRC.SubFunctionalDepartmentCode,
		SRC.SubFunctionalDepartmentName,
		SRC.IsActive,
		''Record updated in source'' AS ReasonForChange,
		DATEADD(ms, 10, SRC.UpdatedDate) AS UpdatedDate,
		$Action AS MergeAction

) AS MergedData
WHERE
	MergedData.MergeAction = ''UPDATE'' AND
	MergedData.IsActive = 1					-- Only insert records that are still active into the dimension. Without this check, deactivated
											-- records will be reinserted into the dimension after having been deactivated.


------------------------------

INSERT INTO dbo.FunctionalDepartment( -- Dimension
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	StartDate,
	EndDate,
	ReasonForChange
)
SELECT
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	StartDate,
	EndDate,
	ReasonForChange
FROM
	#FunctionalDepartment

-----------

UPDATE
	dbo.FunctionalDepartment
SET
	EndDate = ''2010-12-31 23:59:59.000''
WHERE
	FunctionalDepartmentName = ''Legal, Risk & Records''


' 
END
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDAllocationRegion]    Script Date: 08/12/2011 18:27:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDAllocationRegion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_IU_SCDAllocationRegion]
	@DataPriorToDate DATETIME

AS

/*	There is a bug in SQL Server 2008 that prevents the use of the MERGE statement when the table that is being merged to is referenced by
	other tables using FKs. [http://connect.microsoft.com/SQLServer/feedback/details/435031/]
	A work-around is to insert the result of the merge into a temp table, and to then insert data from this temp table into the dimension.
*/

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record needs to be ended, use this date
DECLARE @MaximumEndDate DATETIME = ''9999-12-31 00:00:00.000''

CREATE TABLE #AllocationRegion (
	GlobalRegionId INT NOT NULL,
	RegionCode VARCHAR(50) NOT NULL,
	RegionName VARCHAR(50) NOT NULL,
	SubRegionCode VARCHAR(10) NOT NULL,
	SubRegionName VARCHAR(50) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL,
	SnapshotId INT NOT NULL,
	ReasonForChange NVARCHAR(1024) NULL
)

INSERT INTO #AllocationRegion( -- Dimension
	GlobalRegionId,
	RegionCode,
	RegionName,
	SubRegionCode,
	SubRegionName,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	GlobalRegionId,
	RegionCode,
	RegionName,
	SubRegionCode,
	SubRegionName,
	UpdatedDate AS StartDate,
	@MaximumEndDate AS EndDate,
	SnapshotId,
	ReasonForChange
FROM
(
	MERGE INTO
		dbo.AllocationRegion DIM
	USING
	(
		SELECT
			GlobalRegionId,
			RegionCode,
			RegionName,
			ISNULL(SubRegionCode, ''UNKNOWN'') AS SubRegionCode,
			ISNULL(SubRegionName, ''UNKNOWN'') AS SubRegionName,
			InsertedDate,
			UpdatedDate,
			IsActive,
			0 AS SnapshotId
		FROM
			GrReportingStaging.Gr.GetGlobalRegionExpanded(@DataPriorToDate) -- [VIEW] S stands for SOURCE
		WHERE
			IsAllocationRegion = 1

	) AS SRC ON
		SRC.GlobalRegionId = DIM.GlobalRegionId AND
		SRC.SnapshotId = DIM.SnapshotId AND
		DIM.SnapshotId = 0 -- hardcode 0 as this stored procedure handles only LIVE GDM data, not snapshotted data

	--------

	WHEN MATCHED AND -- When a record exists in [Target] and [Source] and is active in [TARGET] but has been updated/deactivated in [SOURCE], end the record in the dimension.
		 DIM.EndDate = @MaximumEndDate AND					-- IF the record in the Dimension is currently active AND ...
		(										            -- ... a field has changed OR the record has been deactivated in [SOURCE] ...
			DIM.RegionCode <> SRC.RegionCode OR
			DIM.RegionName <> SRC.RegionName OR
			DIM.SubRegionCode <> SRC.SubRegionCode OR
			DIM.SubRegionName <> SRC.SubRegionName OR
			SRC.IsActive = 0
		)
	THEN
		UPDATE
		SET
			DIM.EndDate = SRC.UpdatedDate,                  -- ... THEN deactivate the dimension record by updating its EndDate
															-- Note that other changes that might have been made to the record in [SOURCE] during
															-- its deactivation will not be reflected here.
			DIM.ReasonForChange = (CASE WHEN SRC.IsActive = 0 THEN ''Record deactivated in source'' ELSE ''Record updated in source'' END)

	--------

	WHEN NOT MATCHED BY TARGET THEN -- When a record exists in [Source] that doesn''t exist in [Target], insert it
		INSERT (
			GlobalRegionId,
			RegionCode,
			RegionName,
			SubRegionCode,
			SubRegionName,
			StartDate,
			EndDate,
			SnapshotId,
			ReasonForChange
		)
		VALUES (
			SRC.GlobalRegionId,
			SRC.RegionCode,
			SRC.RegionName,
			SRC.SubRegionCode,
			SRC.SubRegionName,
			SRC.InsertedDate,
			@MaximumEndDate,
			SRC.SnapshotId,
			''New record in source''	
		)

	--------

	WHEN NOT MATCHED BY SOURCE AND -- When a record exists in [Target] that doesn''t exist in [Source], ''end'' it
		 DIM.SnapshotId = 0 AND
		 DIM.AllocationRegionKey <> -1 -- do not update the ''UNKNOWN'' record; this will not be matched in SOURCE
	THEN
		UPDATE
		SET
			DIM.EndDate = @NewEndDate,
			ReasonForChange = ''Record no longer exists in source''

	--------

	OUTPUT -- Dimension
		SRC.GlobalRegionId,
		SRC.RegionCode,
		SRC.RegionName,
		SRC.SubRegionCode,
		SRC.SubRegionName,
		SRC.IsActive,
		SRC.SnapshotId,
		''Record updated in source'' AS ReasonForChange,
		DATEADD(ms, 10, SRC.UpdatedDate) AS UpdatedDate,
		$Action AS MergeAction

) AS MergedData
WHERE
	MergedData.MergeAction = ''UPDATE'' AND
	MergedData.IsActive = 1					-- Only insert records that are still active into the dimension. Without this check, deactivated
											-- records will be reinserted into the dimension after having been deactivated.

---------------------------------------

INSERT INTO dbo.AllocationRegion( -- Dimension
	GlobalRegionId,
	RegionCode,
	RegionName,
	SubRegionCode,
	SubRegionName,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	GlobalRegionId,
	RegionCode,
	RegionName,
	SubRegionCode,
	SubRegionName,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
FROM
	#AllocationRegion


' 
END
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDActivityType]    Script Date: 08/12/2011 18:27:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDActivityType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_IU_SCDActivityType]
	@DataPriorToDate DATETIME

AS

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record needs to be ended, use this date
DECLARE @MaximumEndDate DATETIME = ''9999-12-31 00:00:00.000''


/* IMPORTANT: There is no single business key that we can use to match dimension records with source records: we match using ActivityTypeId and
			  BusinessLineId. For this reason it''s difficult to distinguish between new dimension records and dimension records that have been
			  updated. As such, the UpdatedDate of a record can''t be used as the dimension record''s StartDate or EndDate with any certainty.
			  For this reason, @NewEndDate is used to set a record''s EndDate for a deactivation, as well as to set the StartDate of a new
			  dimension record. */


/*	There is a bug in SQL Server 2008 that prevents the use of the MERGE statement when the table that is being merged to is referenced by
	other tables using FKs. [http://connect.microsoft.com/SQLServer/feedback/details/435031/]
	A work-around is to insert the result of the merge into a temp table, and to then insert data from this temp table into the dimension.
*/

CREATE TABLE #ActivityType (
	ActivityTypeId INT NOT NULL,
	ActivityTypeName VARCHAR(50) NOT NULL,
	ActivityTypeCode VARCHAR(50) NOT NULL,
	BusinessLineId INT NOT NULL,
	BusinessLineName VARCHAR(50) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL,
	SnapshotId INT NOT NULL,
	ReasonForChange  VARCHAR(1024) NOT NULL
)
INSERT INTO #ActivityType (
	ActivityTypeId,
	ActivityTypeName,
	ActivityTypeCode,
	BusinessLineId,
	BusinessLineName,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	ActivityTypeId,
	ActivityTypeName,
	ActivityTypeCode,
	BusinessLineId,
	BusinessLineName,
	UpdatedDate AS StartDate,
	@MaximumEndDate AS EndDate,
	0 AS SnapshotId,
	ReasonForChange
FROM
(
	MERGE INTO
		dbo.ActivityType DIM
	USING
	(
		SELECT
			ActivityTypeId,
			ActivityTypeName,
			ActivityTypeCode,
			BusinessLineId,
			BusinessLineName,
			InsertedDate,
			UpdatedDate,
			IsActive,
			0 AS SnapshotId
		FROM
			GrReportingStaging.GR.GetActivityTypeBusinessLineExpanded(@DataPriorToDate)

	) AS SRC ON
		SRC.ActivityTypeId = DIM.ActivityTypeId AND
		SRC.BusinessLineId = DIM.BusinessLineID AND
		SRC.SnapshotId = DIM.SnapshotId AND
		DIM.SnapshotId = 0 -- hardcode 0 as this stored procedure handles only LIVE GDM data, not snapshotted data

	--------

	WHEN MATCHED AND -- When a record exists in [Target] and [Source] and is active in [TARGET] but has been updated/deactivated in [SOURCE], end the record in the dimension.
		 DIM.EndDate = @MaximumEndDate AND					-- IF the record in the Dimension is currently active AND ...
		(										            -- ... a field has changed OR !the record has been deactivated in [SOURCE]! ...
			DIM.ActivityTypeId <> SRC.ActivityTypeId OR
			DIM.BusinessLineId <> SRC.BusinessLineId OR
			DIM.ActivityTypeName <> SRC.ActivityTypeName OR
			DIM.ActivityTypeCode <> SRC.ActivityTypeCode OR
			DIM.BusinessLineName <> SRC.BusinessLineName OR
			SRC.IsActive = 0
		)
	THEN
		UPDATE
		SET
			DIM.EndDate = SRC.UpdatedDate,                   -- ... THEN deactivate the dimension record by updating its EndDate
			DIM.ReasonForChange = (CASE WHEN SRC.IsActive = 0 THEN ''Record deactivated in source'' ELSE ''Record updated in source'' END)


				-- Note that other changes that might have been made to the record in [SOURCE] during its deactivation will not be reflected here.	

	--------

	WHEN NOT MATCHED BY TARGET THEN -- When a record exists in [Source] that doesn''t exist in [Target], insert it
		INSERT (
			ActivityTypeId,
			ActivityTypeName,
			ActivityTypeCode,
			BusinessLineId,
			BusinessLineName,
			StartDate,
			EndDate,
			SnapshotId,
			ReasonForChange
		)
		VALUES (
			SRC.ActivityTypeId,
			SRC.ActivityTypeName,
			SRC.ActivityTypeCode,
			SRC.BusinessLineId,
			SRC.BusinessLineName,
			@NewEndDate,--SRC.InsertedDate,
			@MaximumEndDate,
			SRC.SnapshotId,
			''New record in source''
		)

	--------

	WHEN NOT MATCHED BY SOURCE AND -- When a record exists in [Target] that doesn''t exist in [Source], ''end'' it
		 DIM.SnapshotId = 0 AND
		 DIM.ActivityTypeKey <> -1 -- do not update the ''UNKNOWN'' record; this will not be matched in SOURCE
	THEN
		UPDATE
		SET
			DIM.EndDate = @NewEndDate,
			ReasonForChange = ''Record no longer exists in source''

	--------

	OUTPUT -- Dimension
		SRC.ActivityTypeId,
		SRC.ActivityTypeName,
		SRC.ActivityTypeCode,
		SRC.BusinessLineId,
		SRC.BusinessLineName,
		SRC.SnapshotId,
		SRC.IsActive,
		@NewEndDate AS UpdatedDate, --DATEADD(ms, 10, SRC.UpdatedDate) AS UpdatedDate,
		''Record updated in source'' AS ReasonForChange,
		$Action AS MergeAction

) AS MergedData
WHERE
	MergedData.MergeAction = ''UPDATE'' AND
	MergedData.IsActive = 1				  -- Only active records should be inserted into the dimension - the insert would be initiated because
										  -- the field(s) of an active record have been updated in SOURCE.


-----------------------------------

INSERT INTO dbo.ActivityType( -- Dimension
	ActivityTypeId,
	ActivityTypeName,
	ActivityTypeCode,
	BusinessLineId,
	BusinessLineName,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	ActivityTypeId,
	ActivityTypeName,
	ActivityTypeCode,
	BusinessLineId,
	BusinessLineName,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
FROM
	#ActivityType

' 
END
GO
