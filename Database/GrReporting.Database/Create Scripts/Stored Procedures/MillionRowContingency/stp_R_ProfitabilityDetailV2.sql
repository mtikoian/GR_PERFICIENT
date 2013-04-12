USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_Profitability]    Script Date: 04/08/2010 18:01:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ProfitabilityDetailV2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ProfitabilityDetailV2]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_Profitability]    Script Date: 12/29/2009 11:20:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



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
	@OverheadOriginatingSubRegionList TEXT = NULL 
	
	
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

DECLARE @CalendarYear AS INT
SET @CalendarYear = CAST(SUBSTRING(CAST(@ReportExpensePeriod AS VARCHAR(10)), 1, 4) AS INT)				

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
	CREATE TABLE	#OverheadOriginatingSubRegionFilterTable	(OriginatingRegionKey Int NOT NULL)	
		
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable	(PropertyFundKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable(ActivityTypeKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)
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
	PropertyFundCode			Varchar(6) DEFAULT(''), --Varchar, for this helps to keep reports size smaller
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
    ISNULL(pa.PropertyFundCode, '''') PropertyFundCode,
    ISNULL(pa.OriginatingRegionCode, '''') OriginatingRegionCode,
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
	SUM(
		er.Rate * -1 *
		CASE WHEN c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/'
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ1,6,0) + ' NOT IN (201003,201006,201009)
				 )
			THEN
				'+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				'
				CASE WHEN gac.MajorCategoryName <> ''Salaries/Taxes/Benefits'' AND oh.OverheadCode = ''UNALLOC'' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdReforecastQ1,
	SUM(
		er.Rate * -1 *
		CASE WHEN c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ2,6,0) + ' NOT IN (201003,201006,201009)
				 )
			THEN
				'+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				'
				CASE WHEN gac.MajorCategoryName <> ''Salaries/Taxes/Benefits'' AND oh.OverheadCode = ''UNALLOC'' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdReforecastQ2,
	SUM(
		er.Rate * -1 *
		CASE WHEN c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ3,6,0) + ' NOT IN (201003,201006,201009)
				 )
			THEN
				'+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				'
				CASE WHEN gac.MajorCategoryName <> ''Salaries/Taxes/Benefits'' AND oh.OverheadCode = ''UNALLOC'' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdReforecastQ3,
	
	SUM(
		er.Rate * -1 *
		CASE WHEN (c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + ') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdActual,
	NULL as YtdBudget,
	SUM(
		er.Rate * -1 *
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ1,6,0) + ' NOT IN (201003,201006,201009)
				 )
			THEN
				'+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				'
				CASE WHEN gac.MajorCategoryName <> ''Salaries/Taxes/Benefits'' AND oh.OverheadCode = ''UNALLOC'' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdReforecastQ1,
	SUM(
		er.Rate * -1 *
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ2,6,0) + ' NOT IN (201003,201006,201009)
				 )
			THEN
				'+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				'
				CASE WHEN gac.MajorCategoryName <> ''Salaries/Taxes/Benefits'' AND oh.OverheadCode = ''UNALLOC'' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdReforecastQ2,
	SUM(
		er.Rate * -1 *
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ3,6,0) + ' NOT IN (201003,201006,201009)
				 )
			THEN
				'+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				'
				CASE WHEN gac.MajorCategoryName <> ''Salaries/Taxes/Benefits'' AND oh.OverheadCode = ''UNALLOC'' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdReforecastQ3,
	
	NULL as AnnualBudget,
	SUM(
		er.Rate * -1 *
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ1,6,0) + ' NOT IN (201003,201006,201009)
				 )
			THEN
				'+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				'
				CASE WHEN gac.MajorCategoryName <> ''Salaries/Taxes/Benefits'' AND oh.OverheadCode = ''UNALLOC'' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualReforecastQ1,
	SUM(
		er.Rate * -1 *
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ2,6,0) + ' NOT IN (201003,201006,201009)
				 )
			THEN
				'+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				'
				CASE WHEN gac.MajorCategoryName <> ''Salaries/Taxes/Benefits'' AND oh.OverheadCode = ''UNALLOC'' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualReforecastQ2,
	SUM(
		er.Rate * -1 *
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ3,6,0) + ' NOT IN (201003,201006,201009)
				 )
			THEN
				'+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				'
				CASE WHEN gac.MajorCategoryName <> ''Salaries/Taxes/Benefits'' AND oh.OverheadCode = ''UNALLOC'' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualReforecastQ3
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
    ISNULL(pa.PropertyFundCode, ''''),
    ISNULL(pa.OriginatingRegionCode, ''''),
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
	pb.GlobalGlAccountCategoryKey,
    pb.ActivityTypeKey,
    pb.PropertyFundKey,
    pb.AllocationRegionKey,
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
    gac.MajorCategoryName AS MajorExpenseCategoryName,
    gac.MinorCategoryName AS MinorExpenseCategoryName,
    a.ActivityTypeName AS ActivityType,
	pf.PropertyFundName AS ReportingEntityName,
	ar.SubRegionName AS AllocationSubRegionName,
    orr.SubRegionName AS OriginatingSubRegionName,
	CASE WHEN (gac.MajorCategoryName = 'Salaries/Taxes/Benefits') THEN '' ELSE ga.Code END GlobalGlAccountCode,
    CASE WHEN (gac.MajorCategoryName = 'Salaries/Taxes/Benefits') THEN '' ELSE ga.Name END GlobalGlAccountName,    
	r.ReimbursableName,
	fa.FeeAdjustmentCode,
	s.SourceName,
	gac.GlAccountCategoryKey,
	
	res.CalendarPeriod AS ActualsExpensePeriod,
    CASE WHEN @IsAllReport = 1 THEN '1900-01-01' ELSE res.EntryDate END AS EntryDate,
    res.[User],
    CASE WHEN @IsAllReport = 1 THEN '' ELSE res.[Description] END AS [Description],
    CASE WHEN @IsAllReport = 1 THEN '' ELSE res.AdditionalDescription END AS AdditionalDescription,
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

	CASE WHEN gac.FeeOrExpense = 'EXPENSE' THEN SUM(ISNULL(MtdBudget,0)) - SUM(ISNULL(MtdActual,0)) ELSE SUM(ISNULL(res.MtdActual,0)) - SUM(ISNULL(MtdBudget,0)) END AS MtdVarianceQ0,
	CASE WHEN gac.FeeOrExpense = 'EXPENSE' THEN SUM(ISNULL(res.MtdReforecastQ1,0)) - SUM(ISNULL(MtdActual,0)) ELSE SUM(ISNULL(MtdActual,0)) - SUM(ISNULL(res.MtdReforecastQ1,0)) END AS MtdVarianceQ1,
	CASE WHEN gac.FeeOrExpense = 'EXPENSE' THEN SUM(ISNULL(res.MtdReforecastQ2,0)) - SUM(ISNULL(MtdActual,0)) ELSE SUM(ISNULL(MtdActual,0)) - SUM(ISNULL(res.MtdReforecastQ2,0)) END AS MtdVarianceQ2,
	CASE WHEN gac.FeeOrExpense = 'EXPENSE' THEN SUM(ISNULL(res.MtdReforecastQ3,0)) - SUM(ISNULL(MtdActual,0)) ELSE SUM(ISNULL(MtdActual,0)) - SUM(ISNULL(res.MtdReforecastQ3,0)) END AS MtdVarianceQ3,
	
	--Year to date
	SUM(ISNULL(res.YtdActual,0)) AS YtdActual,	
	SUM(ISNULL(res.YtdBudget,0)) AS YtdOriginalBudget,
	
	SUM(ISNULL(res.YtdReforecastQ1,0)) AS YtdReforecastQ1,
	SUM(ISNULL(res.YtdReforecastQ2,0)) YtdReforecastQ2,
	SUM(ISNULL(res.YtdReforecastQ3,0)) YtdReforecastQ3,
	

	CASE WHEN gac.FeeOrExpense = 'EXPENSE' THEN SUM(ISNULL(YtdBudget,0)) - SUM(ISNULL(YtdActual,0)) ELSE SUM(ISNULL(res.YtdActual,0)) - SUM(ISNULL(YtdBudget,0)) END AS YtdVarianceQ0,
	CASE WHEN gac.FeeOrExpense = 'EXPENSE' THEN SUM(ISNULL(res.YtdReforecastQ1,0)) - SUM(ISNULL(YtdActual,0)) ELSE SUM(ISNULL(YtdActual,0)) - SUM(ISNULL(res.YtdReforecastQ1,0)) END AS YtdVarianceQ1,
	CASE WHEN gac.FeeOrExpense = 'EXPENSE' THEN SUM(ISNULL(res.YtdReforecastQ2,0)) - SUM(ISNULL(YtdActual,0)) ELSE SUM(ISNULL(YtdActual,0)) - SUM(ISNULL(res.YtdReforecastQ2,0)) END AS YtdVarianceQ2,
	CASE WHEN gac.FeeOrExpense = 'EXPENSE' THEN SUM(ISNULL(res.YtdReforecastQ3,0)) - SUM(ISNULL(YtdActual,0)) ELSE SUM(ISNULL(YtdActual,0)) - SUM(ISNULL(res.YtdReforecastQ3,0)) END AS YtdVarianceQ3,
	
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
		
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = res.ReimbursableKey
    INNER JOIN Source s ON s.SourceKey = res.SourceKey

    INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = res.AllocationRegionKey
    INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = res.OriginatingRegionKey
    INNER JOIN ActivityType a ON  a.ActivityTypeKey = res.ActivityTypeKey
    INNER JOIN PropertyFund pf ON pf.PropertyFundKey = res.PropertyFundKey
    INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = res.FunctionalDepartmentKey
    INNER JOIN FeeAdjustment fa ON  fa.FeeAdjustmentKey = res.FeeAdjustmentKey
	
GROUP BY
	gac.AccountSubTypeName, 
	gac.FeeOrExpense,
    gac.MajorCategoryName,
    gac.MinorCategoryName,
    a.ActivityTypeName,
	pf.PropertyFundName,
	ar.SubRegionName,
    orr.SubRegionName,
	CASE WHEN (gac.MajorCategoryName = 'Salaries/Taxes/Benefits') THEN '' ELSE ga.Code END,
    CASE WHEN (gac.MajorCategoryName = 'Salaries/Taxes/Benefits') THEN '' ELSE ga.Name END,
	r.ReimbursableName,
	fa.FeeAdjustmentCode,
	s.SourceName,
	gac.GlAccountCategoryKey,
	
	res.CalendarPeriod,
    CASE WHEN @IsAllReport = 1 THEN '1900-01-01' ELSE res.EntryDate END,
    res.[User],
    CASE WHEN @IsAllReport = 1 THEN '' ELSE res.[Description] END,
    CASE WHEN @IsAllReport = 1 THEN '' ELSE res.AdditionalDescription END,
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
    ActivityType,
	ReportingEntityName,
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
	AnnualReforecastQ3

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


GO

