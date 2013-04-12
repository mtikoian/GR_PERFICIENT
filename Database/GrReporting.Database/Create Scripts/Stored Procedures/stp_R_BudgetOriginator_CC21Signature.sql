 USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginator_CC21Signature]    Script Date: 11/11/2011 11:00:30 ******/
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
			2011-10-24		: SNothling	:	CC21 - Rewrite script to incorporate new hierarchy logic replacing 
											translation types etc. Please see CC21 Functional Specification for 
											further details.
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_R_BudgetOriginator_CC21Signature]
	@ReportExpensePeriod INT,
	@ReforecastQuarterName VARCHAR(2), --'Q0' or 'Q1' or 'Q2' or 'Q3'
	@DestinationCurrency VARCHAR(3),
	@EntityList TEXT,
	@DontSensitizeMRIPayrollData BIT,
	@CalculationMethod VARCHAR(50),
	@OriginatingSubRegionList TEXT,
	@AllocationSubRegionList TEXT,
	@HierarchyReportParameter dbo.ReportParameterGLCategorizationHierarchyDetail READONLY
AS
BEGIN

	--------------------------------------------------------------------------
	/*	Declare local variables - this makes debugging and testing easier	*/
	--------------------------------------------------------------------------

	--DECLARE @HierarchyReportParameter dbo.ReportParameterGLCategorizationHierarchyDetail  
	--INSERT INTO @HierarchyReportParameter 
	--VALUES(
	--	N'7',
	--	N'Budget Owner Report',
	--	N'374',
	--	N'Budget Owner: Marnix',
	--	N'233',
	--	N'Global',
	--	N'0',
	--	N'All',
	--	N'0',
	--	N'All',
	--	N'0',
	--	N'All',
	--	NULL,
	--	NULL,
	--	N''
	--) 

	DECLARE
		@_ReportExpensePeriod INT = @ReportExpensePeriod,
		@_ReforecastQuarterName VARCHAR(10) = @ReforecastQuarterName,
		@_DestinationCurrency VARCHAR(3) = @DestinationCurrency,
		@_EntityList VARCHAR(max) = @EntityList,
		@_DontSensitizeMRIPayrollData BIT = @DontSensitizeMRIPayrollData,
		@_CalculationMethod VARCHAR(max) = @CalculationMethod,
		@_OriginatingSubRegionList VARCHAR(max)=@OriginatingSubRegionList,
		@_AllocationSubRegionList  VARCHAR(max)=@AllocationSubRegionList
		
		--@_ReportExpensePeriod INT = 201101,
		--@_ReforecastQuarterName VARCHAR(10) = 'Q1',
		--@_DestinationCurrency VARCHAR(3) = 'USD',
		--@_EntityList VARCHAR(max) = 'All',
		--@_SensitizeMRIPayrollData BIT = 0,
		--@_CalculationMethod VARCHAR(max) = 'Gross',
		--@_OriginatingSubRegionList VARCHAR(max)='All',
		--@_AllocationSubRegionList  VARCHAR(max)='All'	
																																																																																																																																																																																																																																																																																																			
	------------------------------------------------------------------------
	/*	Set up the Report Filter Variable defaults							*/
	------------------------------------------------------------------------
	
	-- Calculate default report expense period if none specified
	IF @_ReportExpensePeriod IS NULL
	SET @_ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + REPLACE(STR(MONTH(GETDATE()),2 ),' ','0')AS INT)

	-- Pre-format Report Expense period string
	DECLARE @ReportExpensePeriodParameter VARCHAR(6)
	SET @ReportExpensePeriodParameter = STR(@_ReportExpensePeriod, 6, 0)

	-- Calculate destination currency if none specified
	IF @_DestinationCurrency IS NULL
	SET @_DestinationCurrency = 'USD'
	
	-- Calculate default calendar year if none specified
	DECLARE @CalendarYear AS VARCHAR(10)
	SET @CalendarYear = SUBSTRING(CAST(@_ReportExpensePeriod AS VARCHAR(10)), 1, 4)

	-- Calculate default reforecast quarter name if not specified
	IF @_ReforecastQuarterName IS NULL OR 
	   @_ReforecastQuarterName NOT IN ('Q0', 'Q1', 'Q2', 'Q3')
		SET @_ReforecastQuarterName = (
			SELECT TOP 1
				ReforecastQuarterName 
			FROM 
				dbo.Reforecast 
			WHERE
				ReforecastEffectivePeriod <= @_ReportExpensePeriod AND 
				ReforecastEffectiveYear = LEFT(CAST(@_ReportExpensePeriod AS VARCHAR(6)),4)
			ORDER BY 
				ReforecastEffectivePeriod DESC
		)

	---- Calculate reforecast effective period from reforecast name
	DECLARE @ReforecastEffectivePeriod INT

	SET @ReforecastEffectivePeriod = (
		SELECT TOP 1
			ReforecastEffectivePeriod 
		FROM 
			dbo.Reforecast 
		WHERE
			ReforecastEffectiveYear = LEFT(CAST(@_ReportExpensePeriod AS VARCHAR(6)),4) AND 
			ReforecastQuarterName = @_ReforecastQuarterName
		ORDER BY
			ReforecastEffectivePeriod
	)
			
	-- Determine the ReforecastKey of the reforecast that is currently active (i.e.: 2011 Q1, 2011 Q2, 2012 Q0 etc)
	DECLARE @ActiveReforecastKey INT
	
	SET @ActiveReforecastKey = (
		SELECT 
			ReforecastKey 
		FROM 
			dbo.GetReforecastRecord(@_ReportExpensePeriod, @_ReforecastQuarterName)
	)

	-- Safeguard against NULL ReforecastKey returned from previous statement
	IF (@ActiveReforecastKey IS NULL) 
	BEGIN
		SET @ActiveReforecastKey = (
			SELECT 
				MAX(ReforecastKey) 
			FROM 
				dbo.ExchangeRate
		)
		PRINT ('Near disaster: @ActiveReforecastKey is NULL, so reverting to the largest/most recent ReforecastKey in dbo.ExchangeRate: ' + CONVERT(VARCHAR(10), @ActiveReforecastKey))
	END 
	
	-- Get the GLCategorizationHierarchy to join on
	DECLARE @GLCategorizationParameter VARCHAR(50)
	SET @GLCategorizationParameter = 
		(
			SELECT DISTINCT 
				GLCategorizationName 
			FROM 
				@HierarchyReportParameter
		)
			
	--SELECT @GLCategorizationParameter

	--------------------------------------------------------------------------
	/*	Determine Report Exchange Rates	*/
	--------------------------------------------------------------------------

	SELECT
		SourceCurrencyKey,
		DestinationCurrencyKey,
		CalendarKey,
		Rate
	INTO #ExchangeRate
	FROM
		dbo.ExchangeRate
	WHERE
		ReforecastKey = @ActiveReforecastKey -- We will use the exchange rate set that is active for the current reforecast.

	--SELECT @ActiveReforecastKey
	--SELECT
	--*
	--FROM #ExchangeRate

	--------------------------------------------------------------------------
	--/*    Set Up Direct/Indirect Mapping Data            */
	--------------------------------------------------------------------------

	-- Change Control 14. CC Ref 5.4 Create Direct or Indirect field and map Direct to all the properties, and Indirect to all the Corporates	
	CREATE TABLE #DirectIndirectMapping
	(
		SourceName varchar(50) PRIMARY KEY ,
		DirectIndirect varchar (10),
	)
	
	INSERT INTO #DirectIndirectMapping
	SELECT 
		SourceName, 
		'Direct' AS 'DirectIndirect' 
	FROM Source 
	WHERE 
		IsProperty = 'YES'
	UNION
	SELECT 
		SourceName, 
		'Indirect' AS 'DirectIndirect' 
	FROM Source 
	WHERE 
		IsCorporate = 'YES'	
	UNION
	SELECT 
		SourceName, 
		'-' AS 'DirectIndirect'
	FROM Source 
	WHERE 
		IsCorporate = 'NO' AND 
		IsProperty = 'NO'

	------------------------------------------------------------------------
	/*	Set up the Report Filter Tables										*/
	--------------------------------------------------------------------------

	-- Reporting Entities
	CREATE TABLE #EntityFilterTable	
	(
	PropertyFundKey INT NOT NULL,
	PropertyFundName VARCHAR(MAX) NOT NULL
	)

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable (PropertyFundKey)

	IF (@_EntityList IS NOT NULL)
	BEGIN	
		IF (@_EntityList <> 'All')
		BEGIN
			INSERT INTO #EntityFilterTable
			SELECT 
				PropertyFund.PropertyFundKey,
				PropertyFund.PropertyFundName
			FROM 
				dbo.Split(@_EntityList) EntityListParameters
			INNER JOIN PropertyFund ON 
				PropertyFund.PropertyFundName = EntityListParameters.item
		END
		ELSE IF (@_EntityList = 'All')
		BEGIN
			INSERT INTO #EntityFilterTable
			SELECT 
				PropertyFund.PropertyFundKey,
				PropertyFund.PropertyFundName
			FROM 
				PropertyFund
		END
	END
	
	--SELECT @_EntityList
	--SELECT
	--*
	--FROM #EntityFilterTable
	
	-- Originating Sub Regions
	CREATE TABLE #OriginatingSubRegionFilterTable 
	(
		OriginatingRegionKey INT NOT NULL,
		OriginatingRegionName VARCHAR(MAX) NOT NULL
	)	

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable (OriginatingRegionKey)
	
	IF (@_OriginatingSubRegionList IS NOT NULL)
	BEGIN	
		IF (@_OriginatingSubRegionList <> 'All')
		BEGIN
			INSERT INTO #OriginatingSubRegionFilterTable
			SELECT 
				OriginatingRegion.OriginatingRegionKey,
				OriginatingRegion.SubRegionName
			FROM 
				dbo.Split(@_OriginatingSubRegionList) OriginatingSubRegionParameters
			INNER JOIN OriginatingRegion ON 
				OriginatingRegion.SubRegionName = OriginatingSubRegionParameters.item
		END
		ELSE IF (@_OriginatingSubRegionList = 'All')
		BEGIN
			INSERT INTO #OriginatingSubRegionFilterTable
			SELECT 
				OriginatingRegion.OriginatingRegionKey,
				OriginatingRegion.SubRegionName
			FROM 
				OriginatingRegion
		END
	END
	
	--SELECT @_OriginatingSubRegionList
	--SELECT
	--*
	--FROM #OriginatingSubRegionFilterTable
	
	-- Allocation Sub Regions
	CREATE TABLE #AllocationSubRegionFilterTable 
	(
		AllocationRegionKey INT NOT NULL,
		AllocationRegionName VARCHAR(MAX) NOT NULL
	)
	
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)
	
	IF (@_AllocationSubRegionList IS NOT NULL)
	BEGIN	
		IF (@_AllocationSubRegionList <> 'All')
		BEGIN
			INSERT INTO #AllocationSubRegionFilterTable
			SELECT
				AllocationRegion.AllocationRegionKey,
				AllocationRegion.SubRegionName
			FROM 
				dbo.Split(@_AllocationSubRegionList) AllocationSubRegionParameters
			INNER JOIN AllocationRegion ON
				AllocationRegion.SubRegionName = AllocationSubRegionParameters.item		
		END
		ELSE IF (@_AllocationSubRegionList = 'All')
		BEGIN
			INSERT INTO #AllocationSubRegionFilterTable
			SELECT 
				AllocationRegion.AllocationRegionKey,
				AllocationRegion.SubRegionName
			FROM 
				AllocationRegion
		END
	END
	
	--SELECT @_AllocationSubRegionList
	--SELECT
	--*
	--FROM #AllocationSubRegionFilterTable

	-- Categorization Hierarchy
	CREATE TABLE #CategorizationHierarchyFilterTable
	(
		CategorizationHierarchyKey INT NOT NULL,
		GLCategorizationName VARCHAR(50) NOT NULL,
		GLFinancialCategoryName VARCHAR(50) NOT NULL,
		GLMajorCategoryName VARCHAR(50) NOT NULL,
		GLMinorCategoryName VARCHAR(50) NOT NULL,
		GLAccountCode VARCHAR(15) NOT NULL,
		GLAccountName VARCHAR(300) NOT NULL
	)
	
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #CategorizationHierarchyFilterTable (CategorizationHierarchyKey)
	
	INSERT INTO #CategorizationHierarchyFilterTable
	SELECT
		GLCategorizationHierarchy.GLCategorizationHierarchyKey,
		GLCategorizationHierarchy.GLCategorizationName,
		GLCategorizationHierarchy.GLFinancialCategoryName,
		GLCategorizationHierarchy.GLMajorCategoryName,
		GLCategorizationHierarchy.GLMinorCategoryName,
		GLCategorizationHierarchy.GLAccountCode,
		GLCategorizationHierarchy.GlAccountName
	FROM 
		@HierarchyReportParameter HierarchyReportParameter
	INNER JOIN GLCategorizationHierarchy ON
		(
			HierarchyReportParameter.FinancialCategoryName = 'All' OR
			HierarchyReportParameter.FinancialCategoryName = GLCategorizationHierarchy.GLFinancialCategoryName
		) AND
		(
			HierarchyReportParameter.GLMajorCategoryName = 'All' OR
			HierarchyReportParameter.GLMajorCategoryName = GLCategorizationHierarchy.GLMajorCategoryName
		) AND
		(
			HierarchyReportParameter.GLMinorCategoryName = 'All' OR
			HierarchyReportParameter.GLMinorCategoryName = GLCategorizationHierarchy.GLMinorCategoryName
		)
	WHERE
		-- IMS 51655
		GLCategorizationHierarchy.GLMinorCategoryName <> 'Architects & Engineering' AND	
		InflowOutflow = 'Outflow'
		
	--SELECT
	--*
	--FROM @HierarchyReportParameter
	
	--SELECT
	--*
	--FROM #CategorizationHierarchyFilterTable
	
	--------------------------------------------------------------------------
	/*	Create results temp table											*/
	--------------------------------------------------------------------------

	CREATE TABLE #BudgetOriginatorEntity
	(
		ActivityTypeKey					INT,	
		GLCategorizationHierarchyKey	INT,
		AllocationRegionKey				INT,
		OriginatingRegionKey			INT,
		FunctionalDepartmentKey			INT,
		PropertyFundKey					INT,
		SourceName						VARCHAR(50),
		EntryDate						VARCHAR(10),
		[User]							NVARCHAR(20),
		[Description]					NVARCHAR(60),
		AdditionalDescription			NVARCHAR(4000),
		PropertyFundCode				VARCHAR(11) DEFAULT(''), --VARCHAR, for this helps to keep reports size smaller
		OriginatingRegionCode			VARCHAR(30) DEFAULT(''), --VARCHAR, for this helps to keep reports size smaller
		FunctionalDepartmentCode		VARCHAR(15) DEFAULT(''),
		GlAccountCode					VARCHAR(15) DEFAULT(''),
		GlAccountName					VARCHAR(250) DEFAULT(''),
		CalendarPeriod					VARCHAR(6) DEFAULT(''),

		--Month to date	
		MtdGrossActual					MONEY,
		MtdGrossBudget					MONEY,
		MtdGrossReforecast				MONEY,
		
		MtdNetActual					MONEY,
		MtdNetBudget					MONEY,
		MtdNetReforecast				MONEY,
		
		--Year to date
		YtdGrossActual					MONEY,	
		YtdGrossBudget					MONEY, 
		YtdGrossReforecast				MONEY,
		
		YtdNetActual					MONEY, 
		YtdNetBudget					MONEY, 
		YtdNetReforecast				MONEY, 

		--Annual	
		AnnualGrossBudget				MONEY,
		AnnualGrossReforecast			MONEY,
		AnnualNetBudget					MONEY,
		AnnualNetReforecast				MONEY,

		--Annual estimated
		AnnualEstGrossBudget			MONEY,
		AnnualEstGrossReforecast		MONEY,
		AnnualEstNetBudget				MONEY,
		AnnualEstNetReforecast			MONEY
	)
	
	--------------------------------------------------------------------------
	/*	Get Profitability Actual Data										*/
	--------------------------------------------------------------------------
	
	INSERT INTO #BudgetOriginatorEntity
	SELECT
		ProfitabilityActual.ActivityTypeKey,
		GlHierarchy.CategorizationHierarchyKey AS 'GLCategorizationHierarchyKey',
		ProfitabilityActual.AllocationRegionKey,
		ProfitabilityActual.OriginatingRegionKey,
		ProfitabilityActual.FunctionalDepartmentKey,
		ProfitabilityActual.PropertyFundKey,
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
			ELSE Source.SourceName
		END AS 'SourceName',
		--Source.SourceName,
		CONVERT(varchar(10),ISNULL(ProfitabilityActual.EntryDate,''), 101) AS EntryDate,
		ProfitabilityActual.[User],
		ProfitabilityActual.Description,
		ProfitabilityActual.AdditionalDescription,
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
			ELSE ProfitabilityActual.PropertyFundCode
		END AS 'PropertyFundCode',
		--ProfitabilityActual.PropertyFundCode,
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
			ELSE ProfitabilityActual.OriginatingRegionCode
		END AS 'OriginatingRegionCode',
		--ProfitabilityActual.OriginatingRegionCode,
		ProfitabilityActual.FunctionalDepartmentCode,
		GlHierarchy.GlAccountCode,
		GlHierarchy.GlAccountName,
		Calendar.CalendarPeriod,

		SUM (
			#ExchangeRate.Rate *
			CASE
				WHEN Calendar.CalendarPeriod = @ReportExpensePeriodParameter THEN ProfitabilityActual.LocalActual
				ELSE 0.0
			END
		) AS 'MtdGrossActual',
		NULL AS 'MtdGrossBudget',
		NULL AS 'MtdGrossReforecast',
		
		SUM (
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE 
				WHEN Calendar.CalendarPeriod = @ReportExpensePeriodParameter THEN ProfitabilityActual.LocalActual
				ELSE 0.0
			END
		) AS 'MtdNetActual',
		NULL AS 'MtdNetBudget',
		NULL AS 'MtdNetReforecast',
		
		SUM (
			#ExchangeRate.Rate * 
			CASE 
				WHEN Calendar.CalendarPeriod <= @ReportExpensePeriodParameter THEN ProfitabilityActual.LocalActual
				ELSE 0.0
			END
		) AS 'YtdGrossActual',
		NULL AS 'YtdGrossBudget',
		NULL AS 'YtdGrossReforecast',
		
		SUM (
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE
				WHEN Calendar.CalendarPeriod <= @ReportExpensePeriodParameter THEN ProfitabilityActual.LocalActual
				ELSE 0.0
			END
		) AS 'YtdNetActual',
		NULL AS 'YtdNetBudget',
		NULL AS 'YtdNetReforecast',
		
		NULL AS 'AnnualGrossBudget',
		NULL AS 'AnnualGrossReforecast',
		
		NULL AS 'AnnualNetBudget',
		NULL AS 'AnnualNetReforecast',
		
		SUM (
			#ExchangeRate.Rate *
			CASE
				WHEN Calendar.CalendarPeriod <= @ReportExpensePeriodParameter THEN ProfitabilityActual.LocalActual
				ELSE 0.0
			END
		) AS 'AnnualEstGrossBudget',
		NULL AS 'AnnualEstGrossReforecast',
		
		SUM (
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE
				WHEN Calendar.CalendarPeriod <= @ReportExpensePeriodParameter THEN ProfitabilityActual.LocalActual
				ELSE 0.0
			END
		) AS 'AnnualEstNetBudget',
		NULL AS 'AnnualEstNetReforecast'
		
	FROM 
		ProfitabilityActual 
	
	INNER JOIN #EntityFilterTable ON
		ProfitabilityActual.PropertyFundKey = #EntityFilterTable.PropertyFundKey
		
	INNER JOIN #OriginatingSubRegionFilterTable ON
		ProfitabilityActual.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey
		
	INNER JOIN #AllocationSubRegionFilterTable ON
		ProfitabilityActual.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey
		
	INNER JOIN #ExchangeRate ON
		ProfitabilityActual.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
		ProfitabilityActual.CalendarKey = #ExchangeRate.CalendarKey
		
	INNER JOIN Currency ON
		#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey
		
	INNER JOIN Overhead ON
		ProfitabilityActual.Overheadkey = Overhead.OverheadKey
		
	INNER JOIN Calendar ON
		ProfitabilityActual.CalendarKey = Calendar.CalendarKey
	
	INNER JOIN Source ON
		ProfitabilityActual.SourceKey = Source.SourceKey
	
	INNER JOIN Reimbursable ON
		ProfitabilityActual.ReimbursableKey = Reimbursable.ReimbursableKey

	INNER JOIN GLCategorizationHierarchy GlobalGLCategorizationHierarchy ON
		ProfitabilityActual.GlobalGLCategorizationHierarchyKey = GlobalGLCategorizationHierarchy.GLCategorizationHierarchyKey
					
	LEFT OUTER JOIN #CategorizationHierarchyFilterTable GlHierarchy ON GlHierarchy.CategorizationHierarchyKey = 
	CASE
		WHEN @GLCategorizationParameter = 'Global' THEN ProfitabilityActual.GlobalGLCategorizationHierarchyKey 
		WHEN @GLCategorizationParameter = 'US Property' THEN ProfitabilityActual.USPropertyGLCategorizationHierarchyKey
		WHEN @GLCategorizationParameter = 'US Fund' THEN ProfitabilityActual.USFundGLCategorizationHierarchyKey 
		WHEN @GLCategorizationParameter = 'US Development' THEN ProfitabilityActual.USDevelopmentGLCategorizationHierarchyKey
		WHEN @GLCategorizationParameter = 'EU Property' THEN ProfitabilityActual.EUPropertyGLCategorizationHierarchyKey 
		WHEN @GLCategorizationParameter = 'EU Fund' THEN ProfitabilityActual.EUFundGLCategorizationHierarchyKey 
		WHEN @GLCategorizationParameter = 'EU Development' THEN ProfitabilityActual.EUDevelopmentGLCategorizationHierarchyKey
		ELSE NULL
	END
	
	WHERE 

		Overhead.OverheadName IN 
		(
			'Unallocated',
			'UNKNOWN'
		) AND
		Calendar.CalendarYear = STR(@CalendarYear, 10, 0) AND
		Currency.CurrencyCode = @_DestinationCurrency AND
		GlobalGLCategorizationHierarchy.GLMinorCategoryName <> 'Bonus'
		
	GROUP BY
		ProfitabilityActual.ActivityTypeKey,
		GlHierarchy.CategorizationHierarchyKey,
		ProfitabilityActual.AllocationRegionKey,
		ProfitabilityActual.OriginatingRegionKey,
		ProfitabilityActual.FunctionalDepartmentKey,
		ProfitabilityActual.PropertyFundKey,
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
			ELSE Source.SourceName
		END,
		--Source.SourceName,
		CONVERT(varchar(10),ISNULL(ProfitabilityActual.EntryDate,''), 101),
		ProfitabilityActual.[User],
		ProfitabilityActual.Description,
		ProfitabilityActual.AdditionalDescription,
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
			ELSE ProfitabilityActual.PropertyFundCode
		END,
		--ProfitabilityActual.PropertyFundCode,
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
			ELSE ProfitabilityActual.OriginatingRegionCode
		END,
		--ProfitabilityActual.OriginatingRegionCode,
		ProfitabilityActual.FunctionalDepartmentCode,
		GlHierarchy.GlAccountCode,
		GlHierarchy.GlAccountName,
		Calendar.CalendarPeriod		
	
	--------------------------------------------------------------------------
	/*	Get Profitability Budget Data										*/
	--------------------------------------------------------------------------
	
	INSERT INTO #BudgetOriginatorEntity	
	SELECT
		ProfitabilityBudget.ActivityTypeKey,
		GlHierarchy.CategorizationHierarchyKey AS 'GLCategorizationHierarchyKey',
		ProfitabilityBudget.AllocationRegionKey,
		ProfitabilityBudget.OriginatingRegionKey,
		ProfitabilityBudget.FunctionalDepartmentKey,
		ProfitabilityBudget.PropertyFundKey,
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
			ELSE Source.SourceName
		END AS 'SourceName',
		'' AS 'EntryDate',
		'' AS 'User',
		'' AS 'Description',
		'' AS 'AdditionalDescription',
		'' AS 'PropertyFundCode',
		'' AS 'OriginatingRegionCode',
		'' AS 'FunctionalDepartmentCode',
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN NULL
			ELSE GlHierarchy.GlAccountCode
		END AS 'GlAccountCode',
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN NULL
			ELSE GlHierarchy.GlAccountName
		END AS 'GlAccountName',	
		'' AS 'CalendarPeriod',	
		NULL AS 'MtdGrossActual',
		SUM (
			#ExchangeRate.Rate *
			CASE
				WHEN Calendar.CalendarPeriod = @ReportExpensePeriodParameter THEN ProfitabilityBudget.LocalBudget
				ELSE 0.0
			END
		) AS 'MtdGrossBudget',
		NULL AS 'MtdGrossReforecast',
		
		NULL AS 'MtdNetActual',
		SUM (
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE
				WHEN Calendar.CalendarPeriod = @ReportExpensePeriodParameter THEN ProfitabilityBudget.LocalBudget
				ELSE 0.0
			END
		) AS 'MtdNetBudget',
		NULL AS 'MtdNetReforecast',
		
		NULL AS 'YtdGrossActual',
		SUM (
			#ExchangeRate.Rate *
			CASE
				WHEN Calendar.CalendarPeriod <= @ReportExpensePeriodParameter THEN ProfitabilityBudget.LocalBudget
				ELSE 0.0
			END
		) AS 'YtdGrossBudget',	
		NULL AS 'YtdGrossReforecast',
		
		NULL AS 'YtdNetActual', 
		SUM (
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE
				WHEN Calendar.CalendarPeriod <= @ReportExpensePeriodParameter THEN ProfitabilityBudget.LocalBudget
				ELSE 0.0
			END
		) AS 'YtdNetBudget',
		NULL AS 'YtdnetReforecast',
		
		SUM (
			#ExchangeRate.Rate *
			ProfitabilityBudget.LocalBudget
		) AS 'AnnualGrossBudget',
		NULL AS 'AnnualGrossReforecast',
		
		SUM (
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			ProfitabilityBudget.LocalBudget
		) AS 'AnnualNetBudget',
		NULL AS 'AnnualNetReforeCast',
		
		SUM (
			#ExchangeRate.Rate *
			CASE
				WHEN Calendar.CalendarPeriod > @ReportExpensePeriodParameter THEN ProfitabilityBudget.LocalBudget
				ELSE 0.0
			END
		) AS 'AnnualEstGrossBudget',
		NULL AS 'AnnualEstGrossReforecast',
		
		SUM (
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE 
				WHEN Calendar.CalendarPeriod > @ReportExpensePeriodParameter THEN ProfitabilityBudget.LocalBudget
				ELSE 0.0
			END
		) AS 'AnnualEstNetBudget',
		NULL AS 'AnnualEstNetReforecast'
		
	FROM ProfitabilityBudget 
	
	INNER JOIN #EntityFilterTable ON
		ProfitabilityBudget.PropertyFundKey = #EntityFilterTable.PropertyFundKey
		
	INNER JOIN #OriginatingSubRegionFilterTable ON
		ProfitabilityBudget.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey
		
	INNER JOIN #AllocationSubRegionFilterTable ON
		ProfitabilityBudget.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey
		
	INNER JOIN #ExchangeRate ON
		ProfitabilityBudget.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
		ProfitabilityBudget.CalendarKey = #ExchangeRate.CalendarKey
		
	INNER JOIN Currency ON
		#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey
		
	INNER JOIN Overhead ON
		ProfitabilityBudget.Overheadkey = Overhead.OverheadKey
		
	INNER JOIN Calendar ON
		ProfitabilityBudget.CalendarKey = Calendar.CalendarKey
	
	INNER JOIN Source ON
		ProfitabilityBudget.SourceKey = Source.SourceKey
	
	INNER JOIN Reimbursable ON
		ProfitabilityBudget.ReimbursableKey = Reimbursable.ReimbursableKey
	
	INNER JOIN GLCategorizationHierarchy GlobalGLCategorizationHierarchy ON
		ProfitabilityBudget.GlobalGLCategorizationHierarchyKey = GlobalGLCategorizationHierarchy.GLCategorizationHierarchyKey
					
	LEFT OUTER JOIN #CategorizationHierarchyFilterTable GlHierarchy ON GlHierarchy.CategorizationHierarchyKey = 
	CASE
		WHEN @GLCategorizationParameter = 'Global' THEN ProfitabilityBudget.GlobalGLCategorizationHierarchyKey 
		WHEN @GLCategorizationParameter = 'US Property' THEN ProfitabilityBudget.USPropertyGLCategorizationHierarchyKey
		WHEN @GLCategorizationParameter = 'US Fund' THEN ProfitabilityBudget.USFundGLCategorizationHierarchyKey 
		WHEN @GLCategorizationParameter = 'US Development' THEN ProfitabilityBudget.USDevelopmentGLCategorizationHierarchyKey
		WHEN @GLCategorizationParameter = 'EU Property' THEN ProfitabilityBudget.EUPropertyGLCategorizationHierarchyKey 
		WHEN @GLCategorizationParameter = 'EU Fund' THEN ProfitabilityBudget.EUFundGLCategorizationHierarchyKey 
		WHEN @GLCategorizationParameter = 'EU Development' THEN ProfitabilityBudget.EUDevelopmentGLCategorizationHierarchyKey
		ELSE NULL
	END
		
	WHERE 
		Overhead.OverheadName IN 
		(
			'Unallocated',
			'UNKNOWN'
		) AND
		Calendar.CalendarYear = STR(@CalendarYear, 10, 0) AND
		Currency.CurrencyCode = @_DestinationCurrency AND
		GlobalGLCategorizationHierarchy.GLMinorCategoryName <> 'Bonus'
	
	GROUP BY
		ProfitabilityBudget.ActivityTypeKey,
		GlHierarchy.CategorizationHierarchyKey,
		ProfitabilityBudget.AllocationRegionKey,
		ProfitabilityBudget.OriginatingRegionKey,
		ProfitabilityBudget.FunctionalDepartmentKey,
		ProfitabilityBudget.PropertyFundKey,
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
			ELSE Source.SourceName
		END,
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN NULL
			ELSE GlHierarchy.GlAccountCode
		END,
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN NULL
			ELSE GlHierarchy.GlAccountName
		END	

	--------------------------------------------------------------------------
	/*	Get Profitability Reforecast Data										*/
	--------------------------------------------------------------------------
	IF @_ReforecastQuarterName IN ('Q1', 'Q2', 'Q3')
	BEGIN
	
		INSERT INTO #BudgetOriginatorEntity
		SELECT
			ProfitabilityReforecast.ActivityTypeKey,
			GlHierarchy.CategorizationHierarchyKey AS 'GLCategorizationHierarchyKey',
			ProfitabilityReforecast.AllocationRegionKey,
			ProfitabilityReforecast.OriginatingRegionKey,
			ProfitabilityReforecast.FunctionalDepartmentKey,
			ProfitabilityReforecast.PropertyFundKey,
			CASE
				WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
				ELSE Source.SourceName
			END AS 'SourceName',
			--Source.SourceName,
			'' AS 'EntryDate',
			'',
			'',
			'',
			'' AS 'PropertyFundCode',
			--ProfitabilityReforecast.PropertyFundCode,
			'' AS 'OriginatingRegionCode',
			--ProfitabilityReforecast.OriginatingRegionCode,
			'' AS 'FunctionalDepartmentCode',
			CASE
				WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN NULL	
				ELSE GlHierarchy.GlAccountCode
			END AS 'GLAccountCode',
			CASE
				WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN NULL	
				ELSE GlHierarchy.GlAccountName
			END AS 'GlAccountName',
			'' AS 'CalendarPeriod',
			
			NULL AS 'MtdGrossActual',
			NULL AS 'MtdGrossBudget',
		
			SUM(
			#ExchangeRate.Rate *
			CASE 
				WHEN Calendar.CalendarPeriod = @ReportExpensePeriodParameter THEN ProfitabilityReforecast.LocalReforecast
			ELSE
				0.0
			END
		) AS 'MtdGrossReforecast',
		
		NULL AS 'MtdNetActual',
		NULL AS 'MtdNetBudget',
		
		SUM(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor * 
			CASE 
				WHEN Calendar.CalendarPeriod = @ReportExpensePeriodParameter THEN ProfitabilityReforecast.LocalReforecast
			ELSE 0.0
			END
		) AS 'MtdNetReforecast',
		
		NULL AS 'YtdGrossActual',	
		NULL AS 'YtdGrossBudget',
		
		SUM(
			#ExchangeRate.Rate * 
			CASE 
				WHEN Calendar.CalendarPeriod <= @ReportExpensePeriodParameter THEN ProfitabilityReforecast.LocalReforecast
				ELSE 0.0
			END
		) AS 'YtdGrossReforecast',
		
		NULL AS 'YtdNetActual', 
		NULL AS 'YtdNetBudget',
		
		SUM(
			#ExchangeRate.Rate *Reimbursable.MultiplicationFactor * 
			CASE 
				WHEN Calendar.CalendarPeriod <= @ReportExpensePeriodParameter THEN ProfitabilityReforecast.LocalReforecast
				ELSE 0.0
			END
		) AS 'YtdNetReforecast',
	    
		NULL AS 'AnnualGrossBudget', 
		SUM(
			#ExchangeRate.Rate * 
			ProfitabilityReforecast.LocalReforecast
		) AS 'AnnualGrossReforecast',

		NULL AS 'AnnualNetBudget', 
		SUM (
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor * 
			ProfitabilityReforecast.LocalReforecast
		) AS 'AnnualNetReforecast',

		NULL AS 'AnnualEstGrossBudget',
		SUM(
			#ExchangeRate.Rate *
			CASE 
				WHEN (
					Calendar.CalendarPeriod > @ReportExpensePeriodParameter OR 
					(
						LEFT (ProfitabilityReforecast.ReferenceCode, 3) = 'BC:' AND
						STR(@ReforecastEffectivePeriod,6,0) IN 
						(
							201003, 
							201006, 
							201009
						)
					)
				) THEN ProfitabilityReforecast.LocalReforecast
				ELSE 0.0
			END
		) AS 'AnnualEstGrossReforecast',

		NULL AS 'AnnualEstNetBudget',
		SUM (
			#ExchangeRate.Rate *
			CASE
				WHEN (
					Calendar.CalendarPeriod > @ReportExpensePeriodParameter OR 
					(
						LEFT (ProfitabilityReforecast.ReferenceCode, 3) = 'BC:' AND
						STR(@ReforecastEffectivePeriod,6,0) IN 
						(
							201003, 
							201006, 
							201009
						)
					)
				) THEN ProfitabilityReforecast.LocalReforecast
				ELSE 0.0
			END 
		) AS 'AnnualEstNetReforecast'

		FROM ProfitabilityReforecast 
		
		INNER JOIN #EntityFilterTable ON
			ProfitabilityReforecast.PropertyFundKey = #EntityFilterTable.PropertyFundKey
			
		INNER JOIN #OriginatingSubRegionFilterTable ON
			ProfitabilityReforecast.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey
			
		INNER JOIN #AllocationSubRegionFilterTable ON
			ProfitabilityReforecast.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey
			
		INNER JOIN #ExchangeRate ON
			ProfitabilityReforecast.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
			ProfitabilityReforecast.CalendarKey = #ExchangeRate.CalendarKey
			
		INNER JOIN Currency ON
			#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey
			
		INNER JOIN Overhead ON
			ProfitabilityReforecast.Overheadkey = Overhead.OverheadKey
			
		INNER JOIN Calendar ON
			ProfitabilityReforecast.CalendarKey = Calendar.CalendarKey
		
		INNER JOIN Source ON
			ProfitabilityReforecast.SourceKey = Source.SourceKey
		
		INNER JOIN Reimbursable ON
			ProfitabilityReforecast.ReimbursableKey = Reimbursable.ReimbursableKey
			
		INNER JOIN GLCategorizationHierarchy GlobalGLCategorizationHierarchy ON
			ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey = GlobalGLCategorizationHierarchy.GLCategorizationHierarchyKey
						
		LEFT OUTER JOIN #CategorizationHierarchyFilterTable GlHierarchy ON GlHierarchy.CategorizationHierarchyKey = 
		CASE
			WHEN @GLCategorizationParameter = 'Global' THEN ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey 
			WHEN @GLCategorizationParameter = 'US Property' THEN ProfitabilityReforecast.USPropertyGLCategorizationHierarchyKey
			WHEN @GLCategorizationParameter = 'US Fund' THEN ProfitabilityReforecast.USFundGLCategorizationHierarchyKey 
			WHEN @GLCategorizationParameter = 'US Development' THEN ProfitabilityReforecast.USDevelopmentGLCategorizationHierarchyKey
			WHEN @GLCategorizationParameter = 'EU Property' THEN ProfitabilityReforecast.EUPropertyGLCategorizationHierarchyKey 
			WHEN @GLCategorizationParameter = 'EU Fund' THEN ProfitabilityReforecast.EUFundGLCategorizationHierarchyKey 
			WHEN @GLCategorizationParameter = 'EU Development' THEN ProfitabilityReforecast.EUDevelopmentGLCategorizationHierarchyKey
			ELSE NULL
		END
				
		WHERE 
			Overhead.OverheadName IN 
			(
				'Unallocated',
				'UNKNOWN'
			) AND
			Calendar.CalendarYear = STR(@CalendarYear, 10, 0) AND
			Currency.CurrencyCode = @_DestinationCurrency AND
		GlobalGLCategorizationHierarchy.GLMinorCategoryName <> 'Bonus'
			
		GROUP BY
			ProfitabilityReforecast.ActivityTypeKey,
			GlHierarchy.CategorizationHierarchyKey,
			ProfitabilityReforecast.AllocationRegionKey,
			ProfitabilityReforecast.OriginatingRegionKey,
			ProfitabilityReforecast.FunctionalDepartmentKey,
			ProfitabilityReforecast.PropertyFundKey,
			CASE
				WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
				ELSE Source.SourceName
			END,
			CASE
				WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN NULL	
				ELSE GlHierarchy.GlAccountCode
			END,
			CASE
				WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN NULL	
				ELSE GlHierarchy.GlAccountName
			END

	END
	
	--SELECT
	--*
	--FROM #BudgetOriginatorEntity
	
	------------------------------------------------------------------------
	/*    ENTITY MODE					    						         */
	--------------------------------------------------------------------------

	SELECT
		ActivityType.ActivityTypeName,
		ActivityType.ActivityTypeName AS 'ActivityTypeFilterName',
		CategorizationHierarchyInWarehouse.GLFinancialCategoryName AS 'GLFinancialCategory',
		CategorizationHierarchyInWarehouse.GLMajorCategoryName AS 'GLMajorExpenseCategoryName',
		CategorizationHierarchyInWarehouse.GLMinorCategoryName AS 'GLMinorExpenseCategoryName',
		AllocationRegion.RegionName AS 'AllocationRegionName',
		AllocationRegion.SubRegionName AS 'AllocationSubRegionName',
		AllocationRegion.SubRegionName AS 'AllocationSubRegionFilterName',
		OriginatingRegion.RegionName AS 'OriginatingRegionName',
		OriginatingRegion.SubRegionName AS 'OriginatingSubRegionName',
		OriginatingRegion.SubRegionName AS 'OriginatingSubRegionFilterName',
		PropertyFund.PropertyFundType AS 'PropertyFundType',
		PropertyFund.PropertyFundName AS 'PropertyFundName',
		FunctionalDepartment.FunctionalDepartmentName AS 'FunctionalDepartmentName',
		#BudgetOriginatorEntity.CalendarPeriod AS 'ActualsExpensePeriod',
		#BudgetOriginatorEntity.EntryDate AS 'EntryDate',
		#BudgetOriginatorEntity.[User] AS 'User',
		#BudgetOriginatorEntity.Description AS 'Description',
		#BudgetOriginatorEntity.AdditionalDescription AS 'AdditionalDescription',
		#BudgetOriginatorEntity.SourceName AS 'SourceName',
		#BudgetOriginatorEntity.PropertyFundCode AS 'PropertyFundCode',
		CASE 
			WHEN SUBSTRING(#BudgetOriginatorEntity.SourceName, CHARINDEX(' ', #BudgetOriginatorEntity.SourceName) +1, 8) = 'Property' THEN RTRIM(#BudgetOriginatorEntity.OriginatingRegionCode) + LTRIM(#BudgetOriginatorEntity.FunctionalDepartmentCode) 
			ELSE #BudgetOriginatorEntity.OriginatingRegionCode 
		END AS 'OriginatingRegionCode',
		ISNULL (#BudgetOriginatorEntity.GlAccountCode, '') AS 'GlAccountCode',
		ISNULL (#BudgetOriginatorEntity.GlAccountName, '') AS 'GlAccountName',
		
		--Month to date    
		SUM(
			CASE 
				WHEN (@_CalculationMethod = 'Gross') THEN ISNULL(MtdGrossActual,0) 
				ELSE ISNULL(MtdNetActual,0) 
			END
		) AS 'MtdActual',
		SUM(
			CASE 
				WHEN @_CalculationMethod = 'Gross' THEN ISNULL(MtdGrossBudget,0) 
				ELSE ISNULL(MtdNetBudget,0) 
			END
		) AS 'MtdOriginalBudget',

		
		SUM(
			CASE 
				WHEN @_CalculationMethod = 'Gross' THEN ISNULL(
						CASE 
							WHEN @_ReforecastQuarterName = 'Q0' THEN MtdGrossBudget 
							ELSE MtdGrossReforecast
						END,
						0
					) 
				ELSE ISNULL(
						CASE 
							WHEN @_ReforecastQuarterName = 'Q0' THEN MtdNetBudget 
							ELSE MtdNetReforecast
						END,
						0
					) 
				END
			) 
		AS 'MtdReforecast',
		
		SUM(
			CASE 
				WHEN @_CalculationMethod = 'Gross' THEN ISNULL(
						CASE 
							WHEN @_ReforecastQuarterName = 'Q0' THEN MtdGrossBudget 
							ELSE MtdGrossReforecast
						END, 
						0
					) - ISNULL(MtdGrossActual, 0) 
				ELSE ISNULL(
						CASE 
							WHEN @_ReforecastQuarterName = 'Q0' THEN MtdNetBudget 
							ELSE MtdNetReforecast 
						END, 
						0
					) - ISNULL(MtdNetActual, 0) 
				END
			) 
		AS 'MtdVariance',
		
		--Year to date
		SUM(
			CASE 
				WHEN @_CalculationMethod = 'Gross' THEN ISNULL(YtdGrossActual,0) 
				ELSE ISNULL(YtdNetActual,0) 
			END
		) AS 'YtdActual',	
		
		SUM(
			CASE 
				WHEN @_CalculationMethod = 'Gross' THEN ISNULL(YtdGrossBudget,0) 
				ELSE ISNULL(YtdNetBudget,0) 
			END
		) AS 'YtdOriginalBudget',
		
		SUM(
			CASE 
			WHEN @_CalculationMethod = 'Gross' THEN ISNULL(
				CASE 
					WHEN @_ReforecastQuarterName = 'Q0' THEN YtdGrossBudget 
					ELSE YtdGrossReforecast
				END,
				0
			) 
			ELSE ISNULL(
				CASE 
					WHEN @_ReforecastQuarterName = 'Q0' THEN YtdNetBudget 
					ELSE YtdNetReforecast
				END,
				0
			) 
			END
		) 
		AS 'YtdReforecast',
		
		SUM(
			CASE 
				WHEN @_CalculationMethod = 'Gross' THEN ISNULL(
						CASE 
							WHEN @_ReforecastQuarterName = 'Q0' THEN YtdGrossBudget 
							ELSE YtdGrossReforecast
						END, 
					0
					) - ISNULL(YtdGrossActual, 0) 
				ELSE ISNULL(
					CASE 
						WHEN @_ReforecastQuarterName = 'Q0' THEN YtdNetBudget 
						ELSE YtdNetReforecast 
					END,
					 0
					) - ISNULL(YtdNetActual, 0) 
			END
		) 
		AS 'YtdVariance',
			
		--Annual
		SUM(
			CASE 
				WHEN @_CalculationMethod = 'Gross' THEN ISNULL(AnnualGrossBudget,0) 
				ELSE ISNULL(AnnualNetBudget,0) 
			END
		) AS 'AnnualOriginalBudget',
		
		SUM(
			CASE 
				WHEN @_CalculationMethod = 'Gross' THEN ISNULL(
					CASE 
						WHEN @_ReforecastQuarterName = 'Q0' THEN 0 
						ELSE AnnualGrossReforecast
					END,
					0
				) 
				ELSE ISNULL(
					CASE 
						WHEN @_ReforecastQuarterName = 'Q0' THEN 0 
						ELSE AnnualNetReforecast
					END,
					0
				) 
			END
		) AS 'AnnualReforecast',
		#DirectIndirectMapping.DirectIndirect AS 'DirectIndirect'
		
	INTO #Output

	FROM
		#BudgetOriginatorEntity
		
		INNER JOIN AllocationRegion ON 
			#BudgetOriginatorEntity.AllocationRegionKey = AllocationRegion.AllocationRegionKey
			
		INNER JOIN OriginatingRegion ON 
			#BudgetOriginatorEntity.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey
			
		INNER JOIN FunctionalDepartment ON 
			#BudgetOriginatorEntity.FunctionalDepartmentKey = FunctionalDepartment.FunctionalDepartmentKey
			
		INNER JOIN GLCategorizationHierarchy CategorizationHierarchyInWarehouse ON
			#BudgetOriginatorEntity.GLCategorizationHierarchyKey = CategorizationHierarchyInWarehouse.GLCategorizationHierarchyKey
						
		INNER JOIN PropertyFund ON 
			#BudgetOriginatorEntity.PropertyFundKey = PropertyFund.PropertyFundKey
			
		INNER JOIN ActivityType ON 
			#BudgetOriginatorEntity.ActivityTypeKey = ActivityType.ActivityTypeKey
		
		INNER JOIN #DirectIndirectMapping ON
			#BudgetOriginatorEntity.SourceName = #DirectIndirectMapping.SourceName
			
	GROUP BY
		ActivityType.ActivityTypeName,
		ActivityType.ActivityTypeName,
		CategorizationHierarchyInWarehouse.GLFinancialCategoryName,
		CategorizationHierarchyInWarehouse.GLMajorCategoryName,
		CategorizationHierarchyInWarehouse.GLMinorCategoryName,
		AllocationRegion.RegionName,
		AllocationRegion.SubRegionName,
		AllocationRegion.SubRegionName,
		OriginatingRegion.RegionName,
		OriginatingRegion.SubRegionName,
		OriginatingRegion.SubRegionName,
		PropertyFund.PropertyFundType,
		PropertyFund.PropertyFundName,
		FunctionalDepartment.FunctionalDepartmentName,
		#BudgetOriginatorEntity.CalendarPeriod,
		#BudgetOriginatorEntity.EntryDate,
		#BudgetOriginatorEntity.[User],
		#BudgetOriginatorEntity.Description,
		#BudgetOriginatorEntity.AdditionalDescription,
		#BudgetOriginatorEntity.SourceName,
		#BudgetOriginatorEntity.PropertyFundCode,
		CASE 
			WHEN SUBSTRING(#BudgetOriginatorEntity.SourceName, CHARINDEX(' ', #BudgetOriginatorEntity.SourceName) +1, 8) = 'Property' THEN RTRIM(#BudgetOriginatorEntity.OriginatingRegionCode) + LTRIM(#BudgetOriginatorEntity.FunctionalDepartmentCode) 
			ELSE #BudgetOriginatorEntity.OriginatingRegionCode 
		END,
		ISNULL (#BudgetOriginatorEntity.GlAccountCode, ''),
		ISNULL (#BudgetOriginatorEntity.GlAccountName, ''),
		#DirectIndirectMapping.DirectIndirect
		
	--------------------------------------------------------------------------
	/*    SELECT FINAL OUTPUT			    						         */
	--------------------------------------------------------------------------

	SELECT
		ActivityTypeName,
		ActivityTypeFilterName,
		GLFinancialCategory,
		GLMajorExpenseCategoryName,
		GLMinorExpenseCategoryName,
		AllocationRegionName,
		AllocationSubRegionName,
		AllocationSubRegionFilterName,
		OriginatingRegionName,
		OriginatingSubRegionName,
		OriginatingSubRegionFilterName,
		PropertyFundType AS 'EntityType',
		PropertyFundName AS 'EntityName',
		FunctionalDepartmentName,
		ActualsExpensePeriod,
		EntryDate,
		[User] AS 'User',
		CASE 
			WHEN (
					AnnualOriginalBudget <> 0 OR 
					AnnualReforecast <> 0
				) AND  
				(
					MtdActual = 0 OR 
					YtdActual = 0
				) THEN '[BUDGET/REFORECAST]' 
			ELSE Description 
		END AS 'Description',
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
		DirectIndirect AS 'DirectIndirect'
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
	
--SELECT 'Acquisitions' AS 'ActivityTypeName', 'Acquisitions' AS 'ActivityTypeFilterName', 'Non-Payroll' AS 'ExpenseType', 'Brazil' AS 'AllocationRegionName', 'Brazil' AS 'AllocationSubRegionName', 'Brazil' AS 'AllocationSubRegionFilterName', 'Brazil' AS 'OriginatingRegionName', 'Brazil' AS 'OriginatingSubRegionName', 'Brazil' AS 'OriginatingSubRegionFilterName', 'Employee Training & Seminars' AS 'MajorExpenseCategoryName', 'Education External' AS 'MinorExpenseCategoryName', 'Fund' AS 'EntityType', 'Brazil Fund I_LP' AS 'EntityName', 'Accounting' AS 'FunctionalDepartmentName', '201004' AS 'ActualsExpensePeriod', '04/19/2010' AS 'EntryDate', '000387' AS 'User', 'EDUCATION EXTERNAL                                          ' AS 'Description', '' AS 'AdditionalDescription', 'Brazil Corporate' AS 'SourceName', '012035     ' AS 'PropertyFundCode', 'BRAZIL' AS 'OriginatingRegionCode', '5310000002' AS 'GlAccountCode', 'Education - External Program (ACQ)' AS 'GlAccountName', 0.00 AS 'MtdActual', 0.00 AS 'MtdOriginalBudget', 0.00 AS 'MtdReforecast', 0.00 AS 'MtdVariance', 13.3698 AS 'YtdActual', 0.00 AS 'YtdOriginalBudget', 0.00 AS 'YtdReforecast', -13.3698 AS 'YtdVariance', 0.00 AS 'AnnualOriginalBudget', 0.00 AS 'AnnualReforecast', '' AS 'DirectIndirect' UNION ALL
--SELECT 'Acquisitions', 'Acquisitions', 'Non-Payroll', 'Brazil', 'Brazil', 'Brazil', 'Brazil', 'Brazil', 'Brazil', 'Legal & Professional Fees', 'Legal Advisory', 'Development', 'Faria Lima', 'Acquisitions & Development', '201003', '03/15/2010', '000000', 'Legal Fees (ACQ)                                            ', '', 'Brazil Property', 'BRZFAR     ', 'BRAAND            ', '6041000002', 'Legal Fees (ACQ)', 0.00, 0.00, 0.00, 0.00, 15295.8374, 0.00, 0.00, -15295.8374, 0.00, 0.00, 'Direct' UNION ALL
--SELECT 'Acquisitions', 'Acquisitions', 'Non-Payroll', 'Brazil', 'Brazil', 'Brazil', 'Brazil', 'Brazil', 'Brazil', 'Legal & Professional Fees', 'Legal Advisory', 'Development', 'Faria Lima', 'Legal, Risk & Records', '201004', '04/27/2010', '000387', 'Legal Fees (ACQ)                                            ', '', 'Brazil Property', 'BRZFAR     ', 'BRALGL            ', '6041000002', 'Legal Fees (ACQ)', 0.00, 0.00, 0.00, 0.00, 3879.8473, 0.00, 0.00, -3879.8473, 0.00, 0.00, 'Direct'


	--------------------------------------------------------------------------
	/*    CLEAN UP TEMP TABLES			    						         */
	--------------------------------------------------------------------------

	IF OBJECT_ID('tempdb..#EntityFilterTable') IS NOT NULL
		DROP TABLE #EntityFilterTable

	IF OBJECT_ID('tempdb..#ExchangeRate') IS NOT NULL
		DROP TABLE #ExchangeRate
		
	IF OBJECT_ID('tempdb..#OriginatingSubRegionFilterTable') IS NOT NULL
		DROP TABLE #OriginatingSubRegionFilterTable

	IF OBJECT_ID('tempdb..#AllocationSubRegionFilterTable') IS NOT NULL
		DROP TABLE #AllocationSubRegionFilterTable

	IF OBJECT_ID('tempdb..#CategorizationHierarchyFilterTable') IS NOT NULL
		DROP TABLE #CategorizationHierarchyFilterTable

	IF 	OBJECT_ID('tempdb..#BudgetOriginatorEntity') IS NOT NULL
		DROP TABLE #BudgetOriginatorEntity
		
	IF  OBJECT_ID('tempdb..#DirectIndirectMapping') IS NOT NULL
		DROP TABLE #DirectIndirectMapping

	IF  OBJECT_ID('tempdb..#Output') IS NOT NULL
		DROP TABLE #Output

END










GO


