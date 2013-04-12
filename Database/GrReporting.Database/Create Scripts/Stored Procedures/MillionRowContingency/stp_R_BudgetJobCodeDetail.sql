﻿USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOriginatorJobCodeDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_BudgetOriginatorJobCodeDetail]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetJobCodeDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_BudgetJobCodeDetail]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[stp_R_BudgetJobCodeDetail]
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
	@OverheadCode Varchar(10)='UNALLOC'
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

DECLARE
	@_ReportExpensePeriod INT = @ReportExpensePeriod,
	@_ReforecastQuaterName VARCHAR(10) = @ReforecastQuaterName,
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
IF @ReforecastQuaterName IS NULL OR @ReforecastQuaterName NOT IN ('Q0', 'Q1', 'Q2', 'Q3')
	SET @ReforecastQuaterName = (SELECT TOP 1
									ReforecastQuarterName 
								 FROM
									dbo.Reforecast 
								 WHERE
									ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
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
	PropertyFundCode			Varchar(6) DEFAULT(''), --Varchar, for this helps to keep reports size smaller
	OriginatingRegionCode		Varchar(15) DEFAULT(''), --Varchar, for this helps to keep reports size smaller
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
	
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + 
				' AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ1,6,0) + ' NOT IN (201003, 201006, 201009)
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
	) as MtdGrossReforecastQ1,
	
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + 
				' AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ2,6,0) + ' NOT IN (201003, 201006, 201009)
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
	) as MtdGrossReforecastQ2,
	
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + 
				' AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ3,6,0) + ' NOT IN (201003, 201006, 201009)
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
	) as MtdGrossReforecastQ3,		
	
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
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + 
		' AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ1,6,0) + ' NOT IN (201003, 201006, 201009)
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
	) as MtdNetReforecastQ1,
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + 
		' AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ2,6,0) + ' NOT IN (201003, 201006, 201009)
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
	) as MtdNetReforecastQ2,
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod = ' + STR(@ReportExpensePeriod,6,0) + 
		' AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ3,6,0) + ' NOT IN (201003, 201006, 201009)
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
	) as MtdNetReforecastQ3,		
	
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
	
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + 
			' AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ1,6,0) + ' NOT IN (201003, 201006, 201009)
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
		) as YtdGrossReforecastQ1,
		
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + 
			' AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ2,6,0) + ' NOT IN (201003, 201006, 201009)
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
		) as YtdGrossReforecastQ2,
		
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + 
			' AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ3,6,0) + ' NOT IN (201003, 201006, 201009)
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
		) as YtdGrossReforecastQ3,				
	
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
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ1,6,0) + ' NOT IN (201003, 201006, 201009)
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
		) as YtdNetReforecastQ1,

	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ2,6,0) + ' NOT IN (201003, 201006, 201009)
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
		) as YtdNetReforecastQ2,

	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			 AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ3,6,0) + ' NOT IN (201003, 201006, 201009)
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
		) as YtdNetReforecastQ3,

	' + /*-- YtdNetReforecast End --------------------------*/ + '
	
	NULL as AnnualGrossBudget,
	
	' + /*-- AnnualGrossReforecast --------------------------*/ + '
	
	SUM(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ1,6,0) + ' NOT IN (201003, 201006, 201009)
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
	) as AnnualGrossReforecastQ1,

	SUM(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ2,6,0) + ' NOT IN (201003, 201006, 201009)
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
	) as AnnualGrossReforecastQ2,

	SUM(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ3,6,0) + ' NOT IN (201003, 201006, 201009)
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
	) as AnnualGrossReforecastQ3,

	' + /*-- AnnualGrossReforecast End --------------------------*/ + '

	NULL as AnnualNetBudget,
		
	' + /*-- AnnualNetReforecast --------------------------*/ + '
	
    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ1,6,0) + ' NOT IN (201003, 201006, 201009)
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
	) as AnnualNetReforecastQ1,
	
    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ2,6,0) + ' NOT IN (201003, 201006, 201009)
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
	) as AnnualNetReforecastQ2,
	
    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + '
			  AND c.CalendarPeriod < ' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ3,6,0) + ' NOT IN (201003, 201006, 201009)
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
	) as AnnualNetReforecastQ3,		
	
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
	
	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ1,6,0) + ' NOT IN (201003, 201006, 201009)
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
	) as AnnualEstGrossReforecastQ1,

	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ2,6,0) + ' NOT IN (201003, 201006, 201009)
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
	) as AnnualEstGrossReforecastQ2,

	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ3,6,0) + ' NOT IN (201003, 201006, 201009)
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
	) as AnnualEstGrossReforecastQ3,

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
    
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ1,6,0) + ' NOT IN (201003, 201006, 201009)
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
	) as AnnualEstNetReforecastQ1,
	
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ2,6,0) + ' NOT IN (201003, 201006, 201009)
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
	) as AnnualEstNetReforecastQ2,
	
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don't double count on the grinder actuals*/
			' 
			AND (
					gac.AccountSubTypeName <> ''Non-Payroll''
				 OR	' + STR(@ReforecastEffectivePeriodQ3,6,0) + ' NOT IN (201003, 201006, 201009)
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
	) as AnnualEstNetReforecastQ3		
	
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
GROUP BY
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
	ISNULL(pa.OriginatingRegionCode, ''''),
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
    s.SourceName,
    '''' as EntryDate,
    '''' as [User],
    '''' as Description,
    '''' as AdditionalDescription,
    '''' as PropertyFundCode,
    '''' OriginatingRegionCode,
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
GROUP BY
    gac.GlAccountCategoryKey,
    pb.AllocationRegionKey,
    pb.OriginatingRegionKey,
    pb.FunctionalDepartmentKey,
    pb.PropertyFundKey,
    c.CalendarPeriod,
    s.SourceName,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN NULL ELSE pb.GlAccountKey END
')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR('The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...',9,1)
END

PRINT ('Total dynamic sql statement size: ' + STR(LEN(@cmdString)))

print @cmdString
EXEC (@cmdString)

--------------------------------------------------------------------------------------------------------------------------
-- Get Q1 reforecast information
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
	) as MtdGrossReforecastQ1,
	NULL  as MtdGrossReforecastQ2,
	NULL  as MtdGrossReforecastQ3,
	
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
    ) as MtdNetReforecastQ1,
    NULL as MtdNetReforecastQ2,
    NULL as MtdNetReforecastQ3,    
	
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
	) as YtdGrossReforecastQ1, 
	NULL as YtdGrossReforecastQ2,
	NULL as YtdGrossReforecastQ3,
	
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
    ) as YtdNetReforecastQ1,
	NULL  as YtdNetReforecastQ2,
	NULL  as YtdNetReforecastQ3,
	
	' + /*-- YtdNetReforecast End --------------------------*/ + '
	
	NULL as AnnualGrossBudget,
	
	' + /*-- AnnualGrossReforecast --------------------------*/ + '
		
	SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ1,
	NULL as AnnualGrossReforecastQ2,
	NULL as AnnualGrossReforecastQ3,

	' + /*-- AnnualGrossReforecast End --------------------------*/ + '

	NULL as AnnualNetBudget,
	
	' + /*-- AnnualNetReforecast --------------------------*/ + '
	
	SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecastQ1,
	NULL as AnnualNetReforecastQ2,
	NULL as AnnualNetReforecastQ3,

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
	AND ref.ReforecastEffectivePeriod = ' + STR(@ReforecastEffectivePeriodQ1,10,0) + '
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
    s.SourceName,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN NULL ELSE pr.GlAccountKey END
	
')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR('The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...',9,1)
END

PRINT ('Total dynamic sql statement size: ' + STR(LEN(@cmdString)) + '')

PRINT @cmdString
EXEC (@cmdString)


--------------------------------------------------------------------------------------------------------------------------
-- Get Q2 reforecast information
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
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN NULL ELSE pr.GlAccountKey END,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	
	' + /*-- MtdGrossReforecast --------------------------*/ + '
	
	NULL  as MtdGrossReforecastQ1,
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
	NULL  as MtdGrossReforecastQ3,
	
	' + /*-- MtdGrossReforecast End --------------------------*/ + '
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
	
	' + /*-- MtdNetReforecast --------------------------*/ + '
	
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
	
	' + /*-- MtdNetReforecast End --------------------------*/ + '
	
	NULL as YtdGrossActual,
	NULL as YtdGrossBudget,
	
	' + /*-- YtdGrossReforecast --------------------------*/ + '
	
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
	
	' + /*-- YtdGrossReforecast End --------------------------*/ + '
	
	NULL as YtdNetActual,
	NULL as YtdNetBudget,
	
	' + /*-- YtdNetReforecast --------------------------*/ + '
	
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
	
	' + /*-- YtdNetReforecast End --------------------------*/ + '
	
	NULL as AnnualGrossBudget,
	
	' + /*-- AnnualGrossReforecast --------------------------*/ + '
		
	NULL as AnnualGrossReforecastQ1,
	SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ2,
	NULL as AnnualGrossReforecastQ3,

	' + /*-- AnnualGrossReforecast End --------------------------*/ + '

	NULL as AnnualNetBudget,
	
	' + /*-- AnnualNetReforecast --------------------------*/ + '
	
	NULL as AnnualNetReforecastQ1,
	SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecastQ2,
	NULL as AnnualNetReforecastQ3,
	
	' + /*-- AnnualNetReforecast End --------------------------*/ + '
	
	NULL as AnnualEstGrossBudget,
	
	' + /*-- AnnualEstGrossReforecast --------------------------*/ + '
	
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
	
	' + /*-- AnnualEstGrossReforecast End --------------------------*/ + '
	
	NULL as AnnualEstNetBudget,
	
	' + /*-- AnnualEstNetReforecast --------------------------*/ + '
	
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
	AND ref.ReforecastEffectivePeriod = ' + STR(@ReforecastEffectivePeriodQ2,10,0) + '
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
    s.SourceName,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN NULL ELSE pr.GlAccountKey END
	
')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR('The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...',9,1)
END

PRINT ('Total dynamic sql statement size: ' + STR(LEN(@cmdString)) + '')

PRINT @cmdString
EXEC (@cmdString)

--------------------------------------------------------------------------------------------------------------------------
-- Get Q3 reforecast information
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
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN NULL ELSE pr.GlAccountKey END,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	
	' + /*-- MtdGrossReforecast --------------------------*/ + '
	
	NULL  as MtdGrossReforecastQ1,
	NULL  as MtdGrossReforecastQ2,
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
	
	' + /*-- MtdGrossReforecast End --------------------------*/ + '
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
	
	' + /*-- MtdNetReforecast --------------------------*/ + '
	
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
	
	' + /*-- MtdNetReforecast End --------------------------*/ + '
	
	NULL as YtdGrossActual,
	NULL as YtdGrossBudget,
	
	' + /*-- YtdGrossReforecast --------------------------*/ + '
	
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
	
	' + /*-- YtdGrossReforecast End --------------------------*/ + '
	
	NULL as YtdNetActual,
	NULL as YtdNetBudget,
	
	' + /*-- YtdNetReforecast --------------------------*/ + '
	
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
	
	' + /*-- YtdNetReforecast End --------------------------*/ + '
	
	NULL as AnnualGrossBudget,
	
	' + /*-- AnnualGrossReforecast --------------------------*/ + '
		
	NULL as AnnualGrossReforecastQ1,
	NULL as AnnualGrossReforecastQ2,
	SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ3,

	' + /*-- AnnualGrossReforecast End --------------------------*/ + '

	NULL as AnnualNetBudget,
	
	' + /*-- AnnualNetReforecast --------------------------*/ + '
	
	NULL as AnnualNetReforecastQ1,
	NULL as AnnualNetReforecastQ2,
	SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecastQ3,
	
	' + /*-- AnnualNetReforecast End --------------------------*/ + '
	
	NULL as AnnualEstGrossBudget,
	
	' + /*-- AnnualEstGrossReforecast --------------------------*/ + '
	
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
	
	' + /*-- AnnualEstGrossReforecast End --------------------------*/ + '
	
	NULL as AnnualEstNetBudget,
	
	' + /*-- AnnualEstNetReforecast --------------------------*/ + '
	
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
	AND ref.ReforecastEffectivePeriod = ' + STR(@ReforecastEffectivePeriodQ3,10,0) + '
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
    s.SourceName,
    CASE WHEN gac.MajorCategoryName = ''Salaries/Taxes/Benefits'' THEN NULL ELSE pr.GlAccountKey END
	
')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR('The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...',9,1)
END

PRINT ('Total dynamic sql statement size: ' + STR(LEN(@cmdString)) + '')

PRINT @cmdString
EXEC (@cmdString)

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
    CASE WHEN @IsAllReport = 1 THEN '1900-01-01' ELSE res.EntryDate END AS EntryDate,
    res.[User],
    CASE WHEN @IsAllReport = 1 THEN '' ELSE res.[Description] END AS [Description],
    CASE WHEN @IsAllReport = 1 THEN '' ELSE res.AdditionalDescription END AS AdditionalDescription,
    res.SourceName AS SourceName,
    res.PropertyFundCode PropertyFundCode,
    res.OriginatingRegionCode OriginatingRegionCode,
    ISNULL(ga.Code, '') GlAccountCode,
    ISNULL(ga.Name, '') GlAccountName,
    
	--Month to date    
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossActual,0) ELSE ISNULL(MtdNetActual,0) END) AS MtdActual,
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossBudget,0) ELSE ISNULL(MtdNetBudget,0) END) AS MtdOriginalBudget,
	
	----- MtdReforecast
	SUM(CASE WHEN (@IsGross = 1) THEN
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ1 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ1
		END,0) 
	END) 
	AS MtdReforecastQ1,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ2 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ2 
		END,0) 
	END) 
	AS MtdReforecastQ2,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ3 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ3 
		END,0) 
	END) 
	AS MtdReforecastQ3,		
	----- MtdReforecast End
	
	----- MtdVariance
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ1 
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ1 
		END, 0) - ISNULL(MtdNetActual, 0) 
	END) 
	AS MtdVarianceQ1,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ2 
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ2 
		END, 0) - ISNULL(MtdNetActual, 0) 
	END) 
	AS MtdVarianceQ2,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ3 
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ3 
		END, 0) - ISNULL(MtdNetActual, 0) 
	END) 
	AS MtdVarianceQ3,		
	----- MtdVariance End
	
	--Year to date
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossActual,0) ELSE ISNULL(YtdNetActual,0) END) AS YtdActual,	
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossBudget,0) ELSE ISNULL(YtdNetBudget,0) END) AS YtdOriginalBudget,
	
	----- YtdReforecast
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ1 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ1 
		END,0) 
	END) 
	AS YtdReforecastQ1,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ2 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ2 
		END,0) 
	END) 
	AS YtdReforecastQ2,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ3 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ3 
		END,0) 
	END) 
	AS YtdReforecastQ3,		
	----- YtdReforecast End
	
	----- YtdVariance
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ1 
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ1 
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) 
	AS YtdVarianceQ1,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ2 
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ2 
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) 
	AS YtdVarianceQ2,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ3 
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ3 
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) 
	AS YtdVarianceQ3,		
	----- YtdVariance End
	
	--Annual
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(AnnualGrossBudget,0) ELSE ISNULL(AnnualNetBudget,0) END) AS AnnualOriginalBudget,	
	
	----- AnnualReforecast
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecastQ1 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecastQ1 
		END,0) 
	END) 
	AS AnnualReforecastQ1,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecastQ2 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecastQ2 
		END,0) 
	END)
	AS AnnualReforecastQ2,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN
			AnnualGrossBudget
		ELSE
			AnnualGrossReforecastQ3
		END,0)
	ELSE
		ISNULL(CASE WHEN @ReforecastQuaterName = 'Q0' THEN
			AnnualNetBudget
		ELSE
			AnnualNetReforecastQ3
		END,0)
	END)
	AS AnnualReforecastQ3	
	----- AnnualReforecast End
	
	--SUM(CASE WHEN (@IsGross = 1) THEN 
	--	ISNULL(CASE WHEN @PreviousReforecastQuaterName = 'Q1' THEN 
	--		AnnualGrossReforecastQ1 		
	--	END,0) 
	--ELSE 
	--	ISNULL(CASE WHEN @PreviousReforecastQuaterName = 'Q1' THEN 
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
    CASE WHEN @IsAllReport = 1 THEN '1900-01-01' ELSE res.EntryDate END,
    res.[User],
    CASE WHEN @IsAllReport = 1 THEN '' ELSE res.[Description] END,
    CASE WHEN @IsAllReport = 1 THEN '' ELSE res.AdditionalDescription END,
    res.SourceName,
    res.PropertyFundCode,
    res.OriginatingRegionCode,
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
	
	--MtdReforecastQ1,
	--MtdReforecastQ2,
	MtdReforecastQ3,
	
	--MtdVarianceQ1,
	--MtdVarianceQ2,
	MtdVarianceQ3,
		
	--Year to date
	YtdActual,	
	YtdOriginalBudget,
	
	--YtdReforecastQ1,
	--YtdReforecastQ2,
	YtdReforecastQ3,
	
	--YtdVarianceQ1,
	--YtdVarianceQ2,
	YtdVarianceQ3,
	
	--Annual
	AnnualOriginalBudget,
	
	AnnualReforecastQ1,
	AnnualReforecastQ2,
	AnnualReforecastQ3
	
	--Annual Estimated
	--AnnualEstimatedActual,	
	--AnnualEstimatedVariance
FROM
	#Output
WHERE
	--Month to date    
	MtdActual <> 0.00 OR
	MtdOriginalBudget <> 0.00 OR
	
	--MtdReforecastQ1 <> 0.00 OR
	--MtdReforecastQ2 <> 0.00 OR
	MtdReforecastQ3 <> 0.00 OR
	
	--MtdVarianceQ1 <> 0.00 OR
	--MtdVarianceQ2 <> 0.00 OR
	MtdVarianceQ3 <> 0.00 OR
		
	--Year to date
	YtdActual <> 0.00 OR	
	YtdOriginalBudget <> 0.00 OR
	
	--YtdReforecastQ1 <> 0.00 OR
	--YtdReforecastQ2 <> 0.00 OR
	YtdReforecastQ3 <> 0.00 OR
	
	--YtdVarianceQ1 <> 0.00 OR
	--YtdVarianceQ2 <> 0.00 OR
	YtdVarianceQ3 <> 0.00 OR
	
	--Annual
	AnnualOriginalBudget <> 0.00 OR
	
	AnnualReforecastQ1 <> 0.00 OR
	AnnualReforecastQ2 <> 0.00 OR
	AnnualReforecastQ3 <> 0.00
	
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

