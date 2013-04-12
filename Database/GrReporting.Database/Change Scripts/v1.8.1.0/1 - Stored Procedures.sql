/*
1 - [dbo].[stp_R_ProfitabilityDetailV2]
2 - [dbo].[stp_R_ProfitabilityV2]
*/ 

USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ProfitabilityDetailV2]    Script Date: 08/23/2011 17:19:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ProfitabilityDetailV2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ProfitabilityDetailV2]
GO

USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ProfitabilityDetailV2]    Script Date: 08/23/2011 17:19:40 ******/
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
    INNER JOIN AllocationRegion ConsolidationRegion ON ConsolidationRegion.AllocationRegionKey = pa.ConsolidationRegionKey
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
				+ CASE WHEN @ConsolidationSubRegionList IS NULL THEN '' ELSE ' AND ConsolidationRegion.AllocationRegionKey IN (Select AllocationRegionKey From #ConsolidationSubRegionFilterTable) ' END +
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
		+ CASE WHEN @ConsolidationSubRegionList IS NULL THEN '' ELSE ' AND ConsolidationRegion.AllocationRegionKey IN (Select AllocationRegionKey From #ConsolidationSubRegionFilterTable) ' END

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
    INNER JOIN AllocationRegion ConsolidationRegion ON ConsolidationRegion.AllocationRegionKey = pb.ConsolidationRegionKey
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
				+ CASE WHEN @ConsolidationSubRegionList IS NULL THEN '' ELSE ' AND ConsolidationRegion.AllocationRegionKey IN (Select AllocationRegionKey From #ConsolidationSubRegionFilterTable) ' END +
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
		+ CASE WHEN @ConsolidationSubRegionList IS NULL THEN '' ELSE ' AND ConsolidationRegion.AllocationRegionKey IN (Select AllocationRegionKey From #ConsolidationSubRegionFilterTable) ' END

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
    INNER JOIN AllocationRegion ConsolidationRegion ON ConsolidationRegion.AllocationRegionKey = pr.ConsolidationRegionKey
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
				+ CASE WHEN @ConsolidationSubRegionList IS NULL THEN '' ELSE ' AND ConsolidationRegion.AllocationRegionKey IN (Select AllocationRegionKey From #ConsolidationSubRegionFilterTable) ' END +
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
		+ CASE WHEN @ConsolidationSubRegionList IS NULL THEN '' ELSE ' AND ConsolidationRegion.AllocationRegionKey IN (Select AllocationRegionKey From #ConsolidationSubRegionFilterTable) ' END 
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
    INNER JOIN AllocationRegion ConsolidationRegion ON ConsolidationRegion.AllocationRegionKey = pr.ConsolidationRegionKey
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
				--+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable) ' END +
				+ CASE WHEN @ConsolidationSubRegionList IS NULL THEN '' ELSE ' AND ConsolidationRegion.AllocationRegionKey IN (Select AllocationRegionKey From #ConsolidationSubRegionFilterTable) ' END +
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
		+ CASE WHEN @ConsolidationSubRegionList IS NULL THEN '' ELSE ' AND ConsolidationRegion.AllocationRegionKey IN (Select AllocationRegionKey From #ConsolidationSubRegionFilterTable) ' END
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
    INNER JOIN AllocationRegion ConsolidationRegion ON ConsolidationRegion.AllocationRegionKey = pr.ConsolidationRegionKey
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
				--+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable) ' END +
				+ CASE WHEN @ConsolidationSubRegionList IS NULL THEN '' ELSE ' AND ConsolidationRegion.AllocationRegionKey IN (Select AllocationRegionKey From #ConsolidationSubRegionFilterTable) ' END +
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
		+ CASE WHEN @ConsolidationSubRegionList IS NULL THEN '' ELSE ' AND ConsolidationRegion.AllocationRegionKey IN (Select AllocationRegionKey From #ConsolidationSubRegionFilterTable) ' END
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
USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ProfitabilityV2]    Script Date: 08/23/2011 17:23:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ProfitabilityV2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ProfitabilityV2]
GO

USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ProfitabilityV2]    Script Date: 08/23/2011 17:23:02 ******/
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
	@IncludeFeeAdjustments = @IncludeFeeAdjustments,
	@ConsolidationSubRegionList = @ConsolidationRegionList

		
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


