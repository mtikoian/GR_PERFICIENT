USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOriginator]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[stp_R_BudgetOriginator]
GO

USE [GrReporting]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[stp_R_BudgetOriginator]
	@ReportExpensePeriod INT,
	@ReforecastQuarterName VARCHAR(2), -- 'Q0', 'Q1', 'Q2', or 'Q3'
	@DestinationCurrency VARCHAR(3),
	@EntityList VARCHAR(MAX),
	@DontSensitizeMRIPayrollData BIT,
	@CalculationMethod VARCHAR(50),
	@OriginatingSubRegionList VARCHAR(MAX),
	@AllocationSubRegionList VARCHAR(MAX),
	@FunctionalDepartmentList VARCHAR(MAX),	
	@HierarchyReportParameter dbo.ReportParameterGLCategorizationHierarchyDetail READONLY
AS

/* =============================================================================================================================================
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
   =========================================================================================================================================== */
BEGIN

/* =============================================================================================================================================
	STEP 1: Declare local variables - this makes debugging and testing easier	
	
	NOTE: We do not specify parameter defaults. We assume that all parameters have been saved correctly and completely in GRP, and we want the
		stored procedure to break if an expected parameter is not passed through. This prevents unexpected behaviour.
   =========================================================================================================================================== */
BEGIN

	DECLARE
		@_ReportExpensePeriod               INT = @ReportExpensePeriod,
		@_ReforecastQuarterName     VARCHAR(10) = @ReforecastQuarterName,
		@_DestinationCurrency        VARCHAR(3) = @DestinationCurrency,
		@_EntityList               VARCHAR(MAX) = @EntityList,
		@_DontSensitizeMRIPayrollData       BIT = @DontSensitizeMRIPayrollData,
		@_CalculationMethod        VARCHAR(MAX) = @CalculationMethod,
		@_FunctionalDepartmentList VARCHAR(MAX) = @FunctionalDepartmentList,
		@_OriginatingSubRegionList VARCHAR(MAX) = @OriginatingSubRegionList,
		@_AllocationSubRegionList  VARCHAR(MAX) = @AllocationSubRegionList
			
END
																																																																																																																																																																																																																																																																																																		
/* =============================================================================================================================================
	STEP 2: Set up the Report Filter Variable defaults		
	
		1. The report expense period defaults to the current report expense period
		2. The report expense period parameter is a pre-formatted string used in the select statements of the results
		3. The default destination currency is USD
		4. The calendar year defaults to the year of the expense period
		5. The reforecast quarter name defaults to the latest reforecast quarter name in the database
		   for the given period
		6. If there is no active reforecast for that period - reforecast name combination, get the latest active
		   reforecast
		7. Get the exchange rate set of the selected active reforecast
   =========================================================================================================================================== */
BEGIN

	-- Calculate default report expense period if none specified
	IF @_ReportExpensePeriod IS NULL
		SET @_ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + REPLACE(STR(MONTH(GETDATE()),2 ),' ','0')AS INT)

	-- Pre-format Report Expense period string
	DECLARE @ReportExpensePeriodParameter VARCHAR(6) = STR(@_ReportExpensePeriod, 6, 0)

	-- Calculate destination currency if none specified
	IF @_DestinationCurrency IS NULL
		SET @_DestinationCurrency = 'USD'

	-- Calculate default calendar year if none specified
	DECLARE @CalendarYear AS SMALLINT = CAST(SUBSTRING(CAST(@_ReportExpensePeriod AS VARCHAR(10)), 1, 4) AS SMALLINT)

	-- Calculate default reforecast quarter name if not specified
	IF @_ReforecastQuarterName IS NULL OR @_ReforecastQuarterName NOT IN ('Q0', 'Q1', 'Q2', 'Q3')
		SET @_ReforecastQuarterName = (
			SELECT TOP 1
				ReforecastQuarterName 
			FROM
				dbo.Reforecast
			WHERE
				ReforecastEffectivePeriod <= @_ReportExpensePeriod AND
				ReforecastEffectiveYear = LEFT(CAST(@_ReportExpensePeriod AS VARCHAR(6)),4)
			ORDER BY
				ReforecastEffectivePeriod DESC )

	---- Calculate reforecast effective period from reforecast name
	DECLARE @ReforecastEffectivePeriod INT = (
			SELECT TOP 1
				ReforecastEffectivePeriod
			FROM
				dbo.Reforecast
			WHERE
				ReforecastEffectiveYear = LEFT(CAST(@_ReportExpensePeriod AS VARCHAR(6)),4) AND
				ReforecastQuarterName = @_ReforecastQuarterName
			ORDER BY
				ReforecastEffectivePeriod )
			
	-- Determine the ReforecastKey of the reforecast that is currently active (i.e.: 2011 Q1, 2011 Q2, 2012 Q0 etc)
	DECLARE @ActiveReforecastKey INT = (
			SELECT 
				ReforecastKey
			FROM
				dbo.GetReforecastRecord(@_ReportExpensePeriod, @_ReforecastQuarterName) )

	-- Safeguard against NULL ReforecastKey returned from previous statement
	IF (@ActiveReforecastKey IS NULL)
	BEGIN
		SET @ActiveReforecastKey = (
			SELECT
				MAX(ReforecastKey)
			FROM
				dbo.ExchangeRate )
		PRINT ('Near disaster: @ActiveReforecastKey is NULL, so reverting to the largest/most recent ReforecastKey in dbo.ExchangeRate: ' + CONVERT(VARCHAR(10), @ActiveReforecastKey))
	END 

	-- Get the GLCategorizationHierarchy to join on
	DECLARE @GLCategorizationParameter VARCHAR(50) = (
			SELECT DISTINCT
				GLCategorizationName
			FROM
				@HierarchyReportParameter )
			
	-- Determine Report Exchange Rates: get the exchange rate set for the specified reforecast
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

END

/* =============================================================================================================================================
	STEP 3: Set up Direct/Indirect Mapping
	
		Change Control 14. CC Ref 5.4 Create Direct or Indirect field and map Direct to all the properties, 
		and Indirect to all the Corporates	
		
		8.	As per Change Control 14 , the following logic will be used to determine the values of the direct/indirect 
		column in the budget owner and budget originator reports :
		
		Source			Indirect/Direct
		
		EU Property		Direct
		US Property		Direct
		IN Property		Direct
		CN Property		Direct
		BR Property		Direct
		EU Corporate	Indirect
		US Corporate	Indirect
		IN Corporate	Indirect
		CN Corporate	Indirect
		BR Corporate	Indirect
		Unknown			—

	========================================================================================================================================== */
BEGIN

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
	FROM
		dbo.[Source]
	WHERE
		IsProperty = 'YES'
	UNION
	SELECT
		SourceName,
		'Indirect' AS 'DirectIndirect'
	FROM
		dbo.[Source]
	WHERE
		IsCorporate = 'YES'
	UNION
	SELECT
		SourceName,
		'-' AS 'DirectIndirect'
	FROM
		dbo.[Source]
	WHERE
		IsCorporate = 'NO' AND
		IsProperty = 'NO'

END

/* =============================================================================================================================================
	STEP 5: Set up the Report Filter Tables
	
		1. Reporting Entities - Get a table containing all the reporting entities specified in the filter parameter
		2. Originating Sub Regions - Get a table containing all the originating sub regions specified in the filter parameter
		3. Allocation Sub Regions - Get a table containing all the allocation sub regions specified in the filter parameter
	========================================================================================================================================== */
BEGIN
	
	----------------------------------------------------------------------------
	-- Reporting Entities
	----------------------------------------------------------------------------

		CREATE TABLE #EntityFilterTable	
		(
			PropertyFundKey INT NOT NULL,
			PropertyFundName VARCHAR(MAX) NOT NULL,
			PropertyFundType VARCHAR(MAX) NOT NULL
		)

		IF (@_EntityList IS NOT NULL)
		BEGIN

			IF (@_EntityList <> 'All')
			BEGIN

				INSERT INTO #EntityFilterTable
				SELECT DISTINCT 
					PropertyFundLatestState.PropertyFundKey,
					PropertyFundLatestState.LatestPropertyFundName,
					PropertyFundLatestState.LatestPropertyFundType
				FROM 
					dbo.Split(@_EntityList) EntityListParameters
					INNER JOIN dbo.PropertyFund ON 
						PropertyFund.PropertyFundName = EntityListParameters.item
					INNER JOIN dbo.PropertyFundLatestState ON
						PropertyFund.PropertyFundId = PropertyFundLatestState.PropertyFundId AND
						PropertyFund.SnapshotId = PropertyFundLatestState.PropertyFundSnapshotId
			END
			ELSE IF (@_EntityList = 'All')
			BEGIN

				INSERT INTO #EntityFilterTable
				SELECT DISTINCT
					PropertyFundLatestState.PropertyFundKey,
					PropertyFundLatestState.LatestPropertyFundName AS PropertyFundName,
					PropertyFundLatestState.LatestPropertyFundType AS PropertyFundType
				FROM 
					dbo.PropertyFundLatestState

			END

		END

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable (PropertyFundKey)

	----------------------------------------------------------------------------
	-- Originating Sub Region
	----------------------------------------------------------------------------

	CREATE TABLE #OriginatingSubRegionFilterTable 
	(
		OriginatingRegionKey INT NOT NULL,
		OriginatingRegionName VARCHAR(MAX) NOT NULL,
		OriginatingSubRegionName VARCHAR(MAX) NOT NULL
	)

	IF (@_OriginatingSubRegionList IS NOT NULL)
	BEGIN

		IF (@_OriginatingSubRegionList <> 'All')

		BEGIN
		
			INSERT INTO #OriginatingSubRegionFilterTable
			SELECT DISTINCT
				OriginatingRegionLatestState.OriginatingRegionKey,
				OriginatingRegionLatestState.LatestOriginatingRegionName,
				OriginatingRegionLatestState.LatestOriginatingSubRegionName
			FROM 
				dbo.Split(@_OriginatingSubRegionList) OriginatingSubRegionParameters
				INNER JOIN dbo.OriginatingRegion ON 
					OriginatingRegion.SubRegionName = OriginatingSubRegionParameters.item
				INNER JOIN dbo.OriginatingRegionLatestState ON
					OriginatingRegion.GlobalRegionId = OriginatingRegionLatestState.OriginatingRegionGlobalRegionId AND
					OriginatingRegion.SnapshotId = OriginatingRegionLatestState.OriginatingRegionSnapshotId
		END

		ELSE IF (@_OriginatingSubRegionList = 'All')
		BEGIN

			INSERT INTO #OriginatingSubRegionFilterTable
			SELECT DISTINCT
				OriginatingRegionLatestState.OriginatingRegionKey,
				OriginatingRegionLatestState.LatestOriginatingRegionName,
				OriginatingRegionLatestState.LatestOriginatingSubRegionName
			FROM 
				dbo.OriginatingRegionLatestState
		END

	END

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable (OriginatingRegionKey)

	----------------------------------------------------------------------------
	-- Allocation Sub Region
	----------------------------------------------------------------------------

	CREATE TABLE #AllocationSubRegionFilterTable 
	(
		AllocationRegionKey INT NOT NULL,
		AllocationRegionName VARCHAR(MAX) NOT NULL,
		AllocationSubRegionName VARCHAR(MAX) NOT NULL
	)

	IF (@_AllocationSubRegionList IS NOT NULL)
	BEGIN

		IF (@_AllocationSubRegionList <> 'All')
		BEGIN

			INSERT INTO #AllocationSubRegionFilterTable
			SELECT DISTINCT
				AllocationRegionLatestState.AllocationRegionKey,
				AllocationRegionLatestState.LatestAllocationRegionName,
				AllocationRegionLatestState.LatestAllocationSubRegionName
			FROM 
				dbo.Split(@_AllocationSubRegionList) AllocationSubRegionParameters
				INNER JOIN dbo.AllocationRegion ON
					AllocationRegion.SubRegionName = AllocationSubRegionParameters.item
				INNER JOIN dbo.AllocationRegionLatestState ON
					AllocationRegion.GlobalRegionId = AllocationRegionLatestState.AllocationRegionGlobalRegionId AND
					AllocationRegion.SnapshotId = AllocationRegionLatestState.AllocationRegionSnapshotId
					
		END
		ELSE IF (@_AllocationSubRegionList = 'All')
		BEGIN

			INSERT INTO #AllocationSubRegionFilterTable
			SELECT DISTINCT
				AllocationRegionLatestState.AllocationRegionKey,
				AllocationRegionLatestState.LatestAllocationRegionName,
				AllocationRegionLatestState.LatestAllocationSubRegionName
			FROM
				dbo.AllocationRegionLatestState

		END

	END

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)


	----------------------------------------------------------------------------
	-- Functional Departments
	----------------------------------------------------------------------------

	CREATE TABLE #FunctionalDepartmentFilterTable 
	(
		FunctionalDepartmentKey INT NOT NULL,
		FunctionalDepartmentName VARCHAR(MAX) NOT NULL
	)

	IF (@_FunctionalDepartmentList IS NOT NULL)
	BEGIN	

		IF (@_FunctionalDepartmentList <> 'All')
		BEGIN

			INSERT INTO #FunctionalDepartmentFilterTable
			SELECT DISTINCT
				FunctionalDepartmentLatestState.FunctionalDepartmentKey,
				FunctionalDepartmentLatestState.LatestFunctionalDepartmentName
			FROM
				dbo.Split(@_FunctionalDepartmentList) FunctionalDepartmentParameters
				INNER JOIN dbo.FunctionalDepartment ON
					FunctionalDepartment.FunctionalDepartmentName = FunctionalDepartmentParameters.item	
				INNER JOIN FunctionalDepartmentLatestState ON
					FunctionalDepartment.ReferenceCode = FunctionalDepartmentLatestState.FunctionalDepartmentReferenceCode

		END
		ELSE IF (@_FunctionalDepartmentList = 'All')
		BEGIN

			INSERT INTO #FunctionalDepartmentFilterTable
			SELECT DISTINCT
				FunctionalDepartmentLatestState.FunctionalDepartmentKey,
				FunctionalDepartmentLatestState.LatestFunctionalDepartmentName
			FROM 
				dbo.FunctionalDepartmentLatestState

		END

	END

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)

	----------------------------------------------------------------------------
	-- Categorization Hierarchy
	----------------------------------------------------------------------------

	CREATE TABLE #CategorizationHierarchyFilterTable
	(
		CategorizationHierarchyKey INT NOT NULL,
		GLCategorizationName VARCHAR(50) NOT NULL,
		GLFinancialCategoryName VARCHAR(400) NOT NULL,
		GLMajorCategoryName VARCHAR(400) NOT NULL,
		GLMinorCategoryName VARCHAR(400) NOT NULL,
		GLAccountCode VARCHAR(15) NOT NULL,
		GLAccountName VARCHAR(300) NOT NULL
	)
	
	INSERT INTO #CategorizationHierarchyFilterTable
	SELECT DISTINCT
		GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey,
		GLCategorizationHierarchyLatestState.LatestGLCategorizationName,
		GLCategorizationHierarchyLatestState.LatestGLFinancialCategoryName,
		GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName,
		GLCategorizationHierarchyLatestState.LatestGLMinorCategoryName,
		GLCategorizationHierarchyLatestState.LatestGLAccountCode,
		GLCategorizationHierarchyLatestState.LatestGlAccountName
	FROM 
		@HierarchyReportParameter HierarchyReportParameter
		INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
			(
				HierarchyReportParameter.FinancialCategoryName = 'All' OR
				HierarchyReportParameter.FinancialCategoryName = GLCategorizationHierarchyLatestState.LatestGLFinancialCategoryName
			) AND
			(
				HierarchyReportParameter.GLMajorCategoryName = 'All' OR
				HierarchyReportParameter.GLMajorCategoryName = GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName
			) AND
			(
				HierarchyReportParameter.GLMinorCategoryName = 'All' OR
				HierarchyReportParameter.GLMinorCategoryName = GLCategorizationHierarchyLatestState.LatestGLMinorCategoryName
			)
	WHERE
		GLCategorizationHierarchyLatestState.LatestInflowOutflow <> 'Inflow' AND
		GLCategorizationHierarchyLatestState.LatestGLMinorCategoryName <> 'Architects & Engineering' AND	-- IMS 51655
		GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName NOT IN
			(
				'Corporate Tax',
				'Depreciation Expense',
				'Realized (Gain)/Loss',
				'Unrealized (Gain)/Loss',
				'Miscellaneous Expense',
				'Miscellaneous Income', -- Should be excluded by virtue of the fact that we are excluding 'Inflow' above, but do it again here
				'Interest & Penalties',
				'Guaranteed Payment'
			)
		

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #CategorizationHierarchyFilterTable (CategorizationHierarchyKey)

END
		
/* ==============================================================================================================================================
	STEP 6: Create results temp table

		We will insert all the resulting transaction data into this result temp table:

		1. Actuals transactions
		2. Budget transactions
		3. Reforecast transactions
   =========================================================================================================================================== */
BEGIN
	
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
		GlAccountName					VARCHAR(300) DEFAULT(''),
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
	
END
	
/* ==============================================================================================================================================
	STEP 7: Get Profitability Actual Data
		
		Budget Owner data is only 'Allocated','Not Applicable', 'UNKNOWN'
		'Outflow', 'UNKNOWN' only, they only look at expenses, not income
		Exclude 'Architects & Engineering', was re-classified, as per Martin's request
   =========================================================================================================================================== */
BEGIN
	
	INSERT INTO #BudgetOriginatorEntity
	SELECT
		ProfitabilityActual.ActivityTypeKey,
		GlHierarchy.CategorizationHierarchyKey AS 'GLCategorizationHierarchyKey',
		ProfitabilityActual.AllocationRegionKey,
		ProfitabilityActual.OriginatingRegionKey,
		ProfitabilityActual.FunctionalDepartmentKey,
		ProfitabilityActual.PropertyFundKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND
				GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'
			ELSE
				[Source].SourceName
		END AS 'SourceName',
		CONVERT(VARCHAR(10),ISNULL(ProfitabilityActual.LastDate,''), 101) AS EntryDate,
		ProfitabilityActual.[User],
		ProfitabilityActual.[Description],
		ProfitabilityActual.AdditionalDescription,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND
				GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'
			ELSE
				ProfitabilityActual.PropertyFundCode
		END AS 'PropertyFundCode',
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND
				GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'
			ELSE
				ProfitabilityActual.OriginatingRegionCode
		END AS 'OriginatingRegionCode',
		ProfitabilityActual.FunctionalDepartmentCode,
		GlHierarchy.GlAccountCode,
		GlHierarchy.GlAccountName,
		Calendar.CalendarPeriod,

		SUM
		(
			#ExchangeRate.Rate *
			CASE
				WHEN
					Calendar.CalendarPeriod = @ReportExpensePeriodParameter
				THEN
					ProfitabilityActual.LocalActual
				ELSE
					0.0
			END
		) AS 'MtdGrossActual',
		NULL AS 'MtdGrossBudget',
		NULL AS 'MtdGrossReforecast',
		
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE 
				WHEN
					Calendar.CalendarPeriod = @ReportExpensePeriodParameter
				THEN
					ProfitabilityActual.LocalActual
				ELSE
					0.0
			END
		) AS 'MtdNetActual',
		NULL AS 'MtdNetBudget',
		NULL AS 'MtdNetReforecast',
		
		SUM
		(
			#ExchangeRate.Rate * 
			CASE 
				WHEN
					Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
				THEN
					ProfitabilityActual.LocalActual
				ELSE
					0.0
			END
		) AS 'YtdGrossActual',
		NULL AS 'YtdGrossBudget',
		NULL AS 'YtdGrossReforecast',
		
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE
				WHEN
					Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
				THEN
					ProfitabilityActual.LocalActual
				ELSE
					0.0
			END
		) AS 'YtdNetActual',
		NULL AS 'YtdNetBudget',
		NULL AS 'YtdNetReforecast',
		
		NULL AS 'AnnualGrossBudget',
		NULL AS 'AnnualGrossReforecast',
		
		NULL AS 'AnnualNetBudget',
		NULL AS 'AnnualNetReforecast',
		
		SUM
		(
			#ExchangeRate.Rate *
			CASE
				WHEN
					Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
				THEN
					ProfitabilityActual.LocalActual
				ELSE
					0.0
			END
		) AS 'AnnualEstGrossBudget',
		NULL AS 'AnnualEstGrossReforecast',
		
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE
				WHEN
					Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
				THEN
					ProfitabilityActual.LocalActual
				ELSE
					0.0
			END
		) AS 'AnnualEstNetBudget',
		NULL AS 'AnnualEstNetReforecast'
	FROM 
		dbo.ProfitabilityActual 
	
		INNER JOIN #EntityFilterTable ON
			ProfitabilityActual.PropertyFundKey = #EntityFilterTable.PropertyFundKey
			
		INNER JOIN #OriginatingSubRegionFilterTable ON
			ProfitabilityActual.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey
			
		INNER JOIN #AllocationSubRegionFilterTable ON
			ProfitabilityActual.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey
			
		INNER JOIN #FunctionalDepartmentFilterTable ON
			ProfitabilityActual.FunctionalDepartmentKey = #FunctionalDepartmentFilterTable.FunctionalDepartmentKey
			
		INNER JOIN #ExchangeRate ON
			ProfitabilityActual.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
			ProfitabilityActual.CalendarKey = #ExchangeRate.CalendarKey
			
		INNER JOIN dbo.Currency ON
			#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey
			
		INNER JOIN dbo.Overhead ON
			ProfitabilityActual.Overheadkey = Overhead.OverheadKey
			
		INNER JOIN dbo.Calendar ON
			ProfitabilityActual.CalendarKey = Calendar.CalendarKey
		
		INNER JOIN dbo.[Source] ON
			ProfitabilityActual.SourceKey = [Source].SourceKey
		
		INNER JOIN dbo.Reimbursable ON
			ProfitabilityActual.ReimbursableKey = Reimbursable.ReimbursableKey

		INNER JOIN dbo.GLCategorizationHierarchy GlobalGLCategorizationHierarchy ON
			ProfitabilityActual.GlobalGLCategorizationHierarchyKey = GlobalGLCategorizationHierarchy.GLCategorizationHierarchyKey
						
		INNER JOIN #CategorizationHierarchyFilterTable GlHierarchy ON 
			GlHierarchy.CategorizationHierarchyKey = 
				CASE
					WHEN
						@GLCategorizationParameter = 'Global'
					THEN
						ProfitabilityActual.GlobalGLCategorizationHierarchyKey 
					ELSE
						ProfitabilityActual.ReportingGLCategorizationHierarchyKey
				END AND
			GlHierarchy.GLCategorizationName = @GLCategorizationParameter
	WHERE
		Overhead.OverheadCode IN
		(
			'UNALLOC', -- Unallocated Overhead
			'UNKNOWN', -- Unknown (overhead type could not be resolved when loading the warehouse)
			'N/A'      -- Not an overhead transaction
		) AND
		Calendar.CalendarYear = @CalendarYear AND
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
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND
				GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'	
			ELSE
				[Source].SourceName
		END,
		CONVERT(VARCHAR(10),ISNULL(ProfitabilityActual.LastDate,''), 101),
		ProfitabilityActual.[User],
		ProfitabilityActual.[Description],
		ProfitabilityActual.AdditionalDescription,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND
				GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'	
			ELSE
				ProfitabilityActual.PropertyFundCode
		END,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND
				GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'	
			ELSE
				ProfitabilityActual.OriginatingRegionCode
		END,
		ProfitabilityActual.FunctionalDepartmentCode,
		GlHierarchy.GlAccountCode,
		GlHierarchy.GlAccountName,
		Calendar.CalendarPeriod		
		
END
	
/* =============================================================================================================================================
	STEP 8: Get Profitability Budget Data
		
		Budget Owner data is only 'Allocated','Not Applicable', 'UNKNOWN'
		'Outflow', 'UNKNOWN' only, they only look at expenses, not income
		Exclude 'Architects & Engineering', was re-classified, as per Martin's request
   =========================================================================================================================================== */
BEGIN

	INSERT INTO #BudgetOriginatorEntity	
	SELECT
		ProfitabilityBudget.ActivityTypeKey,
		GlHierarchy.CategorizationHierarchyKey AS 'GLCategorizationHierarchyKey',
		ProfitabilityBudget.AllocationRegionKey,
		ProfitabilityBudget.OriginatingRegionKey,
		ProfitabilityBudget.FunctionalDepartmentKey,
		ProfitabilityBudget.PropertyFundKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND
				GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'
			ELSE
				[Source].SourceName
		END AS 'SourceName',
		'' AS 'EntryDate',
		'' AS 'User',
		'' AS 'Description',
		'' AS 'AdditionalDescription',
		'' AS 'PropertyFundCode',
		'' AS 'OriginatingRegionCode',
		'' AS 'FunctionalDepartmentCode',
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND
				GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				NULL
			ELSE
				GlHierarchy.GlAccountCode
		END AS 'GlAccountCode',
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND
				GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				NULL
			ELSE
				GlHierarchy.GlAccountName
		END AS 'GlAccountName',	
		'' AS 'CalendarPeriod',	
		NULL AS 'MtdGrossActual',
		SUM
		(
			#ExchangeRate.Rate *
			CASE
				WHEN
					Calendar.CalendarPeriod = @ReportExpensePeriodParameter
				THEN
					ProfitabilityBudget.LocalBudget
				ELSE
					0.0
			END
		) AS 'MtdGrossBudget',
		NULL AS 'MtdGrossReforecast',
		
		NULL AS 'MtdNetActual',
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE
				WHEN
					Calendar.CalendarPeriod = @ReportExpensePeriodParameter
				THEN
					ProfitabilityBudget.LocalBudget
				ELSE
					0.0
			END
		) AS 'MtdNetBudget',
		NULL AS 'MtdNetReforecast',
		
		NULL AS 'YtdGrossActual',
		SUM
		(
			#ExchangeRate.Rate *
			CASE
				WHEN
					Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
				THEN
					ProfitabilityBudget.LocalBudget
				ELSE
					0.0
			END
		) AS 'YtdGrossBudget',	
		NULL AS 'YtdGrossReforecast',
		
		NULL AS 'YtdNetActual', 
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE
				WHEN
					Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
				THEN
					ProfitabilityBudget.LocalBudget
				ELSE
					0.0
			END
		) AS 'YtdNetBudget',
		NULL AS 'YtdnetReforecast',
		
		SUM
		(
			#ExchangeRate.Rate *
			ProfitabilityBudget.LocalBudget
		) AS 'AnnualGrossBudget',
		NULL AS 'AnnualGrossReforecast',
		
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			ProfitabilityBudget.LocalBudget
		) AS 'AnnualNetBudget',
		NULL AS 'AnnualNetReforeCast',
		
		SUM
		(
			#ExchangeRate.Rate *
			CASE
				WHEN
					Calendar.CalendarPeriod > @ReportExpensePeriodParameter
				THEN
					ProfitabilityBudget.LocalBudget
				ELSE
					0.0
			END
		) AS 'AnnualEstGrossBudget',
		NULL AS 'AnnualEstGrossReforecast',
		
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE 
				WHEN
					Calendar.CalendarPeriod > @ReportExpensePeriodParameter
				THEN
					ProfitabilityBudget.LocalBudget
				ELSE
					0.0
			END
		) AS 'AnnualEstNetBudget',
		NULL AS 'AnnualEstNetReforecast'
		
	FROM 
		dbo.ProfitabilityBudget 
	
		INNER JOIN #EntityFilterTable ON
			ProfitabilityBudget.PropertyFundKey = #EntityFilterTable.PropertyFundKey
			
		INNER JOIN #OriginatingSubRegionFilterTable ON
			ProfitabilityBudget.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey
			
		INNER JOIN #AllocationSubRegionFilterTable ON
			ProfitabilityBudget.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey
			
		INNER JOIN #FunctionalDepartmentFilterTable ON
			ProfitabilityBudget.FunctionalDepartmentKey = #FunctionalDepartmentFilterTable.FunctionalDepartmentKey
			
		INNER JOIN #ExchangeRate ON
			ProfitabilityBudget.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
			ProfitabilityBudget.CalendarKey = #ExchangeRate.CalendarKey
			
		INNER JOIN dbo.Currency ON
			#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey
			
		INNER JOIN dbo.Overhead ON
			ProfitabilityBudget.Overheadkey = Overhead.OverheadKey
			
		INNER JOIN dbo.Calendar ON
			ProfitabilityBudget.CalendarKey = Calendar.CalendarKey
		
		INNER JOIN dbo.[Source] ON
			ProfitabilityBudget.SourceKey = [Source].SourceKey
		
		INNER JOIN dbo.Reimbursable ON
			ProfitabilityBudget.ReimbursableKey = Reimbursable.ReimbursableKey
		
		INNER JOIN dbo.GLCategorizationHierarchy GlobalGLCategorizationHierarchy ON
			ProfitabilityBudget.GlobalGLCategorizationHierarchyKey = GlobalGLCategorizationHierarchy.GLCategorizationHierarchyKey
						
		INNER JOIN #CategorizationHierarchyFilterTable GlHierarchy ON GlHierarchy.CategorizationHierarchyKey = 
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
		Overhead.OverheadCode IN 
		(
			'UNALLOC',
			'UNKNOWN',
			'N/A'
		) AND
		Calendar.CalendarYear = @CalendarYear AND
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
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND
				GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'	
			ELSE
				[Source].SourceName
		END,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND
				GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				NULL
			ELSE
				GlHierarchy.GlAccountCode
		END,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND
				GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				NULL
			ELSE
				GlHierarchy.GlAccountName
		END	
		
END

/* =============================================================================================================================================
	STEP 9: Get Profitability Reforecast Data 
		
		There are only reforecast transactions for Q1, Q2, Q3
				
		Budget Owner data is only 'Allocated', 'UNKNOWN'
		'Outflow', 'UNKNOWN' only, they only look at expenses, not income
		Exclude 'Architects & Engineering', was re-classified, as per Martin's request
   =========================================================================================================================================== */
BEGIN

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
				WHEN
					@_DontSensitizeMRIPayrollData = 0 AND
					GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
				THEN
					'Sensitized'	
				ELSE
					[Source].SourceName
			END AS 'SourceName',
			'' AS 'EntryDate',
			'',
			'',
			'',
			'' AS 'PropertyFundCode',
			'' AS 'OriginatingRegionCode',
			'' AS 'FunctionalDepartmentCode',
			CASE
				WHEN
					@_DontSensitizeMRIPayrollData = 0 AND
					GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
				THEN
					NULL	
				ELSE
					GlHierarchy.GlAccountCode
			END AS 'GLAccountCode',
			CASE
				WHEN
					@_DontSensitizeMRIPayrollData = 0 AND
					GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
				THEN
					NULL	
				ELSE
					GlHierarchy.GlAccountName
			END AS 'GlAccountName',
			'' AS 'CalendarPeriod',
			
			NULL AS 'MtdGrossActual',
			NULL AS 'MtdGrossBudget',
		
			SUM
			(
				#ExchangeRate.Rate *
				CASE 
					WHEN
						Calendar.CalendarPeriod = @ReportExpensePeriodParameter
					THEN
						ProfitabilityReforecast.LocalReforecast
				ELSE
					0.0
				END
			) AS 'MtdGrossReforecast',

			NULL AS 'MtdNetActual',
			NULL AS 'MtdNetBudget',
		
			SUM
			(
				#ExchangeRate.Rate *
				Reimbursable.MultiplicationFactor * 
				CASE 
					WHEN
						Calendar.CalendarPeriod = @ReportExpensePeriodParameter
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0.0
				END
			) AS 'MtdNetReforecast',

			NULL AS 'YtdGrossActual',
			NULL AS 'YtdGrossBudget',
		
			SUM
			(
				#ExchangeRate.Rate * 
				CASE 
					WHEN
						Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0.0
				END
			) AS 'YtdGrossReforecast',

			NULL AS 'YtdNetActual',
			NULL AS 'YtdNetBudget',

			SUM
			(
				#ExchangeRate.Rate *Reimbursable.MultiplicationFactor * 
				CASE 
					WHEN
						Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0.0
				END
			) AS 'YtdNetReforecast',

			NULL AS 'AnnualGrossBudget', 
			SUM
			(
				#ExchangeRate.Rate *
				ProfitabilityReforecast.LocalReforecast
			) AS 'AnnualGrossReforecast',

			NULL AS 'AnnualNetBudget',
			SUM
			(
				#ExchangeRate.Rate *
				Reimbursable.MultiplicationFactor *
				ProfitabilityReforecast.LocalReforecast
			) AS 'AnnualNetReforecast',

			NULL AS 'AnnualEstGrossBudget',
			SUM
			(
				#ExchangeRate.Rate *
				CASE
					WHEN
					(
						Calendar.CalendarPeriod > @ReportExpensePeriodParameter OR 
						(
							LEFT (ProfitabilityReforecast.ReferenceCode, 3) = 'BC:' AND
							STR(@ReforecastEffectivePeriod,6,0) IN (201003, 
																	201006, 
																	201009)
						)
					)
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0.0
				END
			) AS 'AnnualEstGrossReforecast',

			NULL AS 'AnnualEstNetBudget',
			SUM
			(
				#ExchangeRate.Rate *
				CASE
					WHEN
					(
						Calendar.CalendarPeriod > @ReportExpensePeriodParameter OR 
						(
							LEFT (ProfitabilityReforecast.ReferenceCode, 3) = 'BC:' AND
							STR(@ReforecastEffectivePeriod,6,0) IN (201003,
																	201006,
																	201009)
						)
					)
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0.0
				END 
			) AS 'AnnualEstNetReforecast'
			FROM 
				dbo.ProfitabilityReforecast 
			
				INNER JOIN #EntityFilterTable ON
					ProfitabilityReforecast.PropertyFundKey = #EntityFilterTable.PropertyFundKey
					
				INNER JOIN #OriginatingSubRegionFilterTable ON
					ProfitabilityReforecast.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey
					
				INNER JOIN #AllocationSubRegionFilterTable ON
					ProfitabilityReforecast.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey
					
				INNER JOIN #FunctionalDepartmentFilterTable ON
					ProfitabilityReforecast.FunctionalDepartmentKey = #FunctionalDepartmentFilterTable.FunctionalDepartmentKey
				
				INNER JOIN #ExchangeRate ON
					ProfitabilityReforecast.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
					ProfitabilityReforecast.CalendarKey = #ExchangeRate.CalendarKey
					
				INNER JOIN dbo.Currency ON
					#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey
					
				INNER JOIN dbo.Overhead ON
					ProfitabilityReforecast.Overheadkey = Overhead.OverheadKey
					
				INNER JOIN dbo.Calendar ON
					ProfitabilityReforecast.CalendarKey = Calendar.CalendarKey
				
				INNER JOIN dbo.[Source] ON
					ProfitabilityReforecast.SourceKey = [Source].SourceKey
				
				INNER JOIN dbo.Reimbursable ON
					ProfitabilityReforecast.ReimbursableKey = Reimbursable.ReimbursableKey
					
				INNER JOIN dbo.Reforecast ON
					ProfitabilityReforecast.ReforecastKey = Reforecast.ReforecastKey
			
				INNER JOIN dbo.GLCategorizationHierarchy GlobalGLCategorizationHierarchy ON
					ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey = GlobalGLCategorizationHierarchy.GLCategorizationHierarchyKey
								
				INNER JOIN #CategorizationHierarchyFilterTable GlHierarchy ON GlHierarchy.CategorizationHierarchyKey = 
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
				Overhead.OverheadCode IN 
				(
					'UNALLOC',
					'UNKNOWN',
					'N/A'
				) AND
				Reforecast.ReforecastEffectivePeriod = @ReforecastEffectivePeriod AND
				Calendar.CalendarYear = @CalendarYear AND
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
					WHEN
						@_DontSensitizeMRIPayrollData = 0 AND
						GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
					THEN
						'Sensitized'	
					ELSE
						[Source].SourceName
				END,
				CASE
					WHEN
						@_DontSensitizeMRIPayrollData = 0 AND
						GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
					THEN
						NULL	
					ELSE
						GlHierarchy.GlAccountCode
				END,
				CASE
					WHEN
						@_DontSensitizeMRIPayrollData = 0 AND
						GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
					THEN
						NULL
					ELSE
						GlHierarchy.GlAccountName
				END

	END

END
		
/* =============================================================================================================================================
	STEP 10: Get Total Summary Per cost point

		We are now combining the results for actuals, budgets and reforecasts, thus creating total amounts per:

		ActivityType,

		Global Categorization GLFinancialCategory,
		Global Categorization GLMajorCategory,
		Global Categorization GLMinorCategory,

		Default Reporting Categorization GLFinancialCategory,
		Default Reporting Categorization GLMajorCategory,
		Default Reporting Categorization GLMinorCategory,

		AllocationRegion,
		OriginatingRegion,
		FunctionalDepartmentName,
		PropertyFund,
		CalendarPeriod,
		EntryDate,
		[User],
		[Description],
		AdditionalDescription,
		SourceName,
		GLAccountCode,
		GLAccountName,
		LocalNonLocal,
		DirectIndirect
    ========================================================================================================================================== */
BEGIN

	SELECT
		ActivityType.ActivityTypeName,
		ActivityType.ActivityTypeName AS 'ActivityTypeFilterName',
		CategorizationHierarchyInWarehouse.LatestGLFinancialCategoryName AS 'GLFinancialCategory',
		CategorizationHierarchyInWarehouse.LatestGLMajorCategoryName AS 'GLMajorExpenseCategoryName',
		CategorizationHierarchyInWarehouse.LatestGLMinorCategoryName AS 'GLMinorExpenseCategoryName',
		AllocationRegion.AllocationRegionName AS 'AllocationRegionName',
		AllocationRegion.AllocationSubRegionName AS 'AllocationSubRegionName',
		AllocationRegion.AllocationSubRegionName AS 'AllocationSubRegionFilterName',
		OriginatingRegion.OriginatingRegionName AS 'OriginatingRegionName',
		OriginatingRegion.OriginatingSubRegionName AS 'OriginatingSubRegionName',
		OriginatingRegion.OriginatingSubRegionName AS 'OriginatingSubRegionFilterName',
		PropertyFund.PropertyFundType AS 'PropertyFundType',
		PropertyFund.PropertyFundName AS 'PropertyFundName',
		FunctionalDepartment.FunctionalDepartmentName AS 'FunctionalDepartmentName',
		#BudgetOriginatorEntity.CalendarPeriod AS 'ActualsExpensePeriod',
		#BudgetOriginatorEntity.EntryDate AS 'EntryDate',
		#BudgetOriginatorEntity.[User] AS 'User',
		#BudgetOriginatorEntity.[Description] AS 'Description',
		#BudgetOriginatorEntity.AdditionalDescription AS 'AdditionalDescription',
		#BudgetOriginatorEntity.SourceName AS 'SourceName',
		#BudgetOriginatorEntity.PropertyFundCode AS 'PropertyFundCode',
		CASE 
			WHEN
				SUBSTRING(#BudgetOriginatorEntity.SourceName, CHARINDEX(' ', #BudgetOriginatorEntity.SourceName) +1, 8) = 'Property'
			THEN
				RTRIM(#BudgetOriginatorEntity.OriginatingRegionCode) + LTRIM(#BudgetOriginatorEntity.FunctionalDepartmentCode) 
			ELSE
				#BudgetOriginatorEntity.OriginatingRegionCode 
		END AS 'OriginatingRegionCode',
		ISNULL (#BudgetOriginatorEntity.GlAccountCode, '') AS 'GlAccountCode',
		ISNULL (#BudgetOriginatorEntity.GlAccountName, '') AS 'GlAccountName',
		
		--Month to date    
		SUM
		(
			CASE 
				WHEN
					(@_CalculationMethod = 'Gross')
				THEN
					ISNULL(MtdGrossActual, 0) 
				ELSE
					ISNULL(MtdNetActual, 0) 
			END
		) AS 'MtdActual',
		SUM
		(
			CASE 
				WHEN
					@_CalculationMethod = 'Gross'
				THEN
					ISNULL(MtdGrossBudget, 0) 
				ELSE
					ISNULL(MtdNetBudget, 0) 
			END
		) AS 'MtdOriginalBudget',

		SUM
		(
			CASE 
				WHEN
					@_CalculationMethod = 'Gross'
				THEN
					ISNULL
					(
						CASE 
							WHEN
								@_ReforecastQuarterName = 'Q0'
							THEN
								MtdGrossBudget 
							ELSE
								MtdGrossReforecast
						END,
						0
					) 
				ELSE
					ISNULL
					(
						CASE 
							WHEN
								@_ReforecastQuarterName = 'Q0'
							THEN
								MtdNetBudget 
							ELSE
								MtdNetReforecast
						END,
						0
					) 
				END
			) 
		AS 'MtdReforecast',
		
		SUM
		(
			CASE 
				WHEN
					@_CalculationMethod = 'Gross'
				THEN
					ISNULL
					(
						CASE 
							WHEN
								@_ReforecastQuarterName = 'Q0'
							THEN
								MtdGrossBudget 
							ELSE
								MtdGrossReforecast
						END, 
						0
					) - ISNULL(MtdGrossActual, 0) 
				ELSE
					ISNULL
					(
						CASE 
							WHEN
								@_ReforecastQuarterName = 'Q0'
							THEN
								MtdNetBudget 
							ELSE
								MtdNetReforecast 
						END,
						0
					) - ISNULL(MtdNetActual, 0) 
				END
		) AS 'MtdVariance',
		
		--Year to date
		SUM
		(
			CASE 
				WHEN
					@_CalculationMethod = 'Gross'
				THEN
					ISNULL(YtdGrossActual, 0) 
				ELSE
					ISNULL(YtdNetActual, 0) 
			END
		) AS 'YtdActual',	
		
		SUM
		(
			CASE 
				WHEN
					@_CalculationMethod = 'Gross'
				THEN
					ISNULL(YtdGrossBudget, 0) 
				ELSE
					ISNULL(YtdNetBudget, 0) 
			END
		) AS 'YtdOriginalBudget',
		
		SUM
		(
			CASE 
				WHEN
					@_CalculationMethod = 'Gross'
				THEN
					ISNULL
					(
						CASE 
							WHEN
								@_ReforecastQuarterName = 'Q0'
							THEN
								YtdGrossBudget 
							ELSE
								YtdGrossReforecast
						END,
						0
					)
				ELSE
					ISNULL
					(
						CASE 
							WHEN
								@_ReforecastQuarterName = 'Q0'
							THEN
								YtdNetBudget 
							ELSE
								YtdNetReforecast
						END,
						0
					)
			END
		) AS 'YtdReforecast',
		
		SUM
		(
			CASE 
				WHEN
					@_CalculationMethod = 'Gross'
				THEN
					ISNULL
					(
						CASE 
							WHEN
								@_ReforecastQuarterName = 'Q0'
							THEN
								YtdGrossBudget 
							ELSE
								YtdGrossReforecast
						END,
						0
					) - ISNULL(YtdGrossActual, 0) 
				ELSE
					ISNULL
					(
						CASE
							WHEN
								@_ReforecastQuarterName = 'Q0'
							THEN
								YtdNetBudget
							ELSE
								YtdNetReforecast
						END,
						0
					) - ISNULL(YtdNetActual, 0)
			END
		) AS 'YtdVariance',
			
		--Annual
		SUM
		(
			CASE
				WHEN
					@_CalculationMethod = 'Gross'
				THEN
					ISNULL(AnnualGrossBudget,0)
				ELSE
					ISNULL(AnnualNetBudget,0)
			END
		) AS 'AnnualOriginalBudget',
		
		SUM
		(
			CASE
				WHEN
					@_CalculationMethod = 'Gross'
				THEN
					ISNULL
					(
						CASE
							WHEN
								@_ReforecastQuarterName = 'Q0'
							THEN
								0
							ELSE
								AnnualGrossReforecast
						END,
						0
					)
				ELSE
					ISNULL
					(
					CASE 
						WHEN @_ReforecastQuarterName = 'Q0' THEN 0 
						ELSE AnnualNetReforecast
					END,
					0
				) 
			END
		) AS 'AnnualReforecast',
		ISNULL(#DirectIndirectMapping.DirectIndirect, '-') AS 'DirectIndirect'
	INTO
		#Output
	FROM
		#BudgetOriginatorEntity
		
		INNER JOIN #AllocationSubRegionFilterTable AllocationRegion ON 
			#BudgetOriginatorEntity.AllocationRegionKey = AllocationRegion.AllocationRegionKey
			
		INNER JOIN #OriginatingSubRegionFilterTable OriginatingRegion ON 
			#BudgetOriginatorEntity.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey
			
		INNER JOIN #FunctionalDepartmentFilterTable FunctionalDepartment ON 
			#BudgetOriginatorEntity.FunctionalDepartmentKey = FunctionalDepartment.FunctionalDepartmentKey
			
		INNER JOIN dbo.GLCategorizationHierarchyLatestState CategorizationHierarchyInWarehouse ON
			#BudgetOriginatorEntity.GLCategorizationHierarchyKey = CategorizationHierarchyInWarehouse.GLCategorizationHierarchyKey
						
		INNER JOIN #EntityFilterTable PropertyFund ON 
			#BudgetOriginatorEntity.PropertyFundKey = PropertyFund.PropertyFundKey
			
		INNER JOIN dbo.ActivityType ON 
			#BudgetOriginatorEntity.ActivityTypeKey = ActivityType.ActivityTypeKey
		
		LEFT OUTER JOIN #DirectIndirectMapping ON
			#BudgetOriginatorEntity.SourceName = #DirectIndirectMapping.SourceName
	GROUP BY
		ActivityType.ActivityTypeName,
		ActivityType.ActivityTypeName,
		CategorizationHierarchyInWarehouse.LatestGLFinancialCategoryName,
		CategorizationHierarchyInWarehouse.LatestGLMajorCategoryName,
		CategorizationHierarchyInWarehouse.LatestGLMinorCategoryName,
		AllocationRegion.AllocationRegionName,
		AllocationRegion.AllocationSubRegionName,
		AllocationRegion.AllocationSubRegionName,
		OriginatingRegion.OriginatingRegionName,
		OriginatingRegion.OriginatingSubRegionName,
		OriginatingRegion.OriginatingSubRegionName,
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
			WHEN
				SUBSTRING(#BudgetOriginatorEntity.SourceName, CHARINDEX(' ', #BudgetOriginatorEntity.SourceName) +1, 8) = 'Property'
			THEN
				RTRIM(#BudgetOriginatorEntity.OriginatingRegionCode) + LTRIM(#BudgetOriginatorEntity.FunctionalDepartmentCode) 
			ELSE
				#BudgetOriginatorEntity.OriginatingRegionCode 
		END,
		ISNULL (#BudgetOriginatorEntity.GlAccountCode, ''),
		ISNULL (#BudgetOriginatorEntity.GlAccountName, ''),
		ISNULL(#DirectIndirectMapping.DirectIndirect, '-')

END
		
/* =============================================================================================================================================
	STEP 11: Get Final Results
   ========================================================================================================================================== */
BEGIN

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
			WHEN
			(
				AnnualOriginalBudget <> 0 OR 
				AnnualReforecast <> 0
			) AND  
			(
				MtdActual = 0 OR 
				YtdActual = 0
			)
			THEN
				'[BUDGET/REFORECAST]' 
			ELSE
				[Description]
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

END
	
/* =============================================================================================================================================
	CLEAN UP TEMP TABLES
   =========================================================================================================================================== */
BEGIN

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

END

GO
