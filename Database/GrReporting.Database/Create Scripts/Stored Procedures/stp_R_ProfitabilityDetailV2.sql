USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ProfitabilityDetailV2]    Script Date: 01/23/2012 16:29:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ProfitabilityDetailV2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ProfitabilityDetailV2]
GO

USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ProfitabilityDetailV2]    Script Date: 01/23/2012 16:29:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE [dbo].[stp_R_ProfitabilityDetailV2]
	@ReportExpensePeriod INT,
	@ReforecastQuarterName VARCHAR(2), --'Q0' or 'Q1' or 'Q2' or 'Q3'
	@DestinationCurrency VARCHAR(3),
	@EntityList NVARCHAR(MAX),
	@DontSensitizeMRIPayrollData BIT,
	@IncludeGrossNonPayrollExpenses BIT,
	@IncludeFeeAdjustments BIT,
	@DisplayOverheadBy NVARCHAR(MAX),
	@ConsolidationRegionList NVARCHAR(MAX),
	@OriginatingSubRegionList NVARCHAR(MAX),
	@ActivityTypeList NVARCHAR(MAX),
	@GLCategorizationName VARCHAR(50)

AS

/* =============================================================================================================================================
	Declare Variables
   =========================================================================================================================================== */
BEGIN

	DECLARE
		@ErrorSeverity                     INT = ERROR_SEVERITY(), 
		@ErrorMessage            NVARCHAR(4000),
		@_ReforecastQuarterName     VARCHAR(10) = @ReforecastQuarterName,
		@_DestinationCurrency        VARCHAR(3) = @DestinationCurrency,
		@_EntityList               VARCHAR(MAX) = @EntityList,
		@_ActivityTypeList         VARCHAR(MAX) = @ActivityTypeList,
		@_DontSensitizeMRIPayrollData       BIT = @DontSensitizeMRIPayrollData,
		@_ReportExpensePeriod               INT = @ReportExpensePeriod,
		@_AllocationSubRegionList  VARCHAR(MAX) = @ConsolidationRegionList,
		@_OriginatingSubRegionList VARCHAR(MAX) = @OriginatingSubRegionList,
		@_DisplayOverheadBy        VARCHAR(255) = @DisplayOverheadBy,
		@ReportExpensePeriodParameter       INT = @ReportExpensePeriod -- The period for which the report is being generated

	DECLARE @InflowOutflowExpense VARCHAR(20) = 'Outflow'
	DECLARE @InflowOutflowIncome  VARCHAR(20) = 'Inflow'
	DECLARE @ActiveReforecastKey          INT = (SELECT ReforecastKey FROM dbo.GetReforecastRecord(@ReportExpensePeriodParameter, @_ReforecastQuarterName))
	DECLARE @FeeAdjustmentKey             INT = (SELECT FeeAdjustmentKey From FeeAdjustment Where FeeAdjustmentCode = 'NORMAL')

	DECLARE @CalendarYear SMALLINT = CONVERT(SMALLINT, (SUBSTRING(CAST(@_ReportExpensePeriod AS VARCHAR(10)), 1, 4)))

	-- The year for which the report is generated (the YYYY part of the report period: YYYYMM)
	DECLARE @EffectiveYear SMALLINT = CONVERT(SMALLINT, LEFT(CAST(@_ReportExpensePeriod AS VARCHAR(6)),4))

	DECLARE @Q1ReforecastKey INT = (SELECT MIN(ReforecastKey) FROM dbo.Reforecast where ReforecastQuarterName = 'Q1' AND ReforecastEffectiveYear = @EffectiveYear)
	DECLARE @Q2ReforecastKey INT = (SELECT MIN(ReforecastKey) FROM dbo.Reforecast where ReforecastQuarterName = 'Q2' AND ReforecastEffectiveYear = @EffectiveYear)
	DECLARE @Q3ReforecastKey INT = (SELECT MIN(ReforecastKey) FROM dbo.Reforecast where ReforecastQuarterName = 'Q3' AND ReforecastEffectiveYear = @EffectiveYear)

	-- Get the earliest period (YYYYMM) from the dbo.Reforecast dimension for which the dbo.Reforecast.ReforecastEffectiveYear is equal to the
	--		year of the report period and the dbo.Reforecast.ReforecastQuarterName is equal to the reforecast quarter.
	DECLARE @ReforecastEffectivePeriod INT = (SELECT TOP 1 ReforecastEffectivePeriod FROM dbo.Reforecast WHERE ReforecastEffectiveYear = LEFT(CAST(@_ReportExpensePeriod AS VARCHAR(6)),4) AND ReforecastQuarterName = @_ReforecastQuarterName ORDER BY ReforecastEffectivePeriod)

	DECLARE @GrOverheadCode VARCHAR(20)
	DECLARE @GrOverheadCodeAlloc   VARCHAR(10) = 'ALLOC'
	DECLARE @GrOverheadCodeUnAlloc VARCHAR(10) = 'UNALLOC'
	DECLARE @GrOverheadCodeNA      VARCHAR(10) = 'N/A'

	DECLARE @DisplayOverheadByUnallocatedOverhead BIT = 0
	DECLARE @DisplayOverheadByAllocatedOverhead BIT = 0

	IF (@_DisplayOverheadBy = 'Allocated Overhead') 
	BEGIN
		SET @GrOverheadCode = @GrOverheadCodeAlloc
		SET @DisplayOverheadByAllocatedOverhead = 1
	END
	ELSE IF (@_DisplayOverheadBy = 'Unallocated Overhead')
	BEGIN
		SET @GrOverheadCode = @GrOverheadCodeUnAlloc
		SET @DisplayOverheadByUnallocatedOverhead = 1
	END
	ELSE
	BEGIN
		SET @ErrorSeverity = ERROR_SEVERITY()
		SET @ErrorMessage = 'Error in display overhead By: ' + CONVERT(VARCHAR(10), ERROR_NUMBER()) + ':' + ERROR_MESSAGE() 	
		RAISERROR ( @ErrorMessage, @ErrorSeverity, 1)
	END

END

/* ==============================================================================================================================================
	Create filter tables based on the values of the parameters passed to this stored procedure.
   =========================================================================================================================================== */
BEGIN

	--------------------------------------------------------------------------
	-- AllocationSubRegion
	--------------------------------------------------------------------------

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

	--------------------------------------------------------------------------
	-- Overhead
	--------------------------------------------------------------------------

	CREATE TABLE #OverheadFilterTable
	(
		OverheadKey INT NOT NULL
	)

	INSERT INTO #OverheadFilterTable
	SELECT 
		OverheadKey
	FROM 
		dbo.Overhead 
	WHERE
		OverheadCode IN (@GrOverheadCode, 'N/A')

	--------------------------------------------------------------------------
	-- ActivityType
	--------------------------------------------------------------------------

	CREATE TABLE #ActivityTypeFilterTable
	(
		ActivityTypeKey INT NOT NULL,
	)

	IF (@_ActivityTypeList IS NOT NULL)
	BEGIN

		IF (@_ActivityTypeList <> 'All')
		BEGIN

			INSERT INTO #ActivityTypeFilterTable
			SELECT 
				ActivityType.ActivityTypeKey
			FROM 
				dbo.Split(@_ActivityTypeList) ActivityTypeParameters
				INNER JOIN dbo.ActivityType ON
					ActivityType.ActivityTypeName = ActivityTypeParameters.item

		END
		ELSE IF (@_ActivityTypeList = 'All')
		BEGIN

			INSERT INTO #ActivityTypeFilterTable
			SELECT
				ActivityType.ActivityTypeKey
			FROM
				dbo.ActivityType

		END

	END

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable (ActivityTypeKey)

	--------------------------------------------------------------------------
	-- Entity
	--------------------------------------------------------------------------

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
					INNER JOIN PropertyFundLatestState ON
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

	--------------------------------------------------------------------------
	-- OriginatingSubRegion
	--------------------------------------------------------------------------

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

	--------------------------------------------------------------------------
	-- ExchangeRate
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
	-- FeeAdjustment
	--------------------------------------------------------------------------

	CREATE TABLE #FeeAdjustmentFilterTable 
	(
		FeeAdjustmentKey INT NOT NULL
	)

	IF (@IncludeFeeAdjustments = 1)
	BEGIN

		INSERT INTO #FeeAdjustmentFilterTable
		SELECT 
			FeeAdjustmentKey
		FROM 
			dbo.FeeAdjustment 
		WHERE
			FeeAdjustmentCode IN ('NORMAL', 'FEEADJUST')

	END
	ELSE
	BEGIN

		INSERT INTO #FeeAdjustmentFilterTable
		SELECT 
			FeeAdjustmentKey
		FROM 
			dbo.FeeAdjustment 
		WHERE
			FeeAdjustmentCode = 'NORMAL'

	END

END

/* ==============================================================================================================================================
	Create the main temporary table that will be used to contain Actual, Budget, and Reforecast data
   =========================================================================================================================================== */
BEGIN

	CREATE TABLE #ProfitabilityReport
	(
		GLCategorizationHierarchyKey INT,
		OverheadCode VARCHAR(20),
		ActivityTypeKey INT,
		PropertyFundKey INT,
		AllocationRegionKey INT,
		ConsolidationRegionKey INT,
		OriginatingRegionKey INT,
		SourceName VARCHAR(50),
		SourceKey INT,
		GlAccountCode VARCHAR(15) NOT NULL,
		GLAccountName VARCHAR(300) NOT NULL,
		GLFinancialCategoryName VARCHAR(300) NOT NULL,
		InflowOutflow VARCHAR(20),
		ReimbursableKey INT,
		FeeAdjustmentKey INT,
		FunctionalDepartmentKey INT,
		OverheadKey INT,
		CalendarPeriod VARCHAR(6) DEFAULT(''),
		
		EntryDate VARCHAR(10),
		[User] NVARCHAR(20),
		[Description] NVARCHAR(60),
		AdditionalDescription NVARCHAR(4000),
		PropertyFundCode VARCHAR(11) DEFAULT(''),
		OriginatingRegionCode VARCHAR(15) DEFAULT(''),
		FunctionalDepartmentCode VARCHAR(15) DEFAULT(''),

		--Month to date	
		MtdActual MONEY,
		MtdBudget MONEY,
		MtdReforecastQ1 MONEY,
		MtdReforecastQ2 MONEY,
		MtdReforecastQ3 MONEY,

		--Year to date
		YtdActual MONEY,	
		YtdBudget MONEY, 
		YtdReforecastQ1 MONEY, 
		YtdReforecastQ2 MONEY, 
		YtdReforecastQ3 MONEY, 

		--Annual
		AnnualBudget MONEY,
		AnnualReforecastQ1 MONEY,
		AnnualReforecastQ2 MONEY,
		AnnualReforecastQ3 MONEY
	)

END


/* ==============================================================================================================================================
	Get the Actual portion of the data by selecting from the GrReporting.dbo.ProfitabilityActual fact
   =========================================================================================================================================== */
BEGIN

	INSERT INTO #ProfitabilityReport
	SELECT
		GlCategorizationHierarchy.GLCategorizationHierarchyKey AS GLCategorizationHierarchyKey,
		Overhead.OverheadCode,
		ProfitabilityActual.ActivityTypeKey,
		ProfitabilityActual.PropertyFundKey,
		ProfitabilityActual.AllocationRegionKey,
		ProfitabilityActual.ConsolidationRegionKey,
		ProfitabilityActual.OriginatingRegionKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'	
			ELSE
				[Source].SourceName
		END AS SourceName,
		ProfitabilityActual.SourceKey AS SourceKey,
		GlCategorizationHierarchy.LatestGlAccountCode,
		GlCategorizationHierarchy.LatestGLAccountName,
		CASE 
			WHEN 
				(GlCategorizationHierarchy.LatestGLFinancialCategoryName = 'Payroll' AND Overhead.OverheadCode = 'UNALLOC') OR
				(GlCategorizationHierarchy.LatestGLFinancialCategoryName = 'Non-Payroll' AND Overhead.OverheadCode = 'UNALLOC') 
			THEN 
				'Overhead' 
			ELSE  
				GlCategorizationHierarchy.LatestGLFinancialCategoryName 
		END AS GLFinancialCategoryName,
		GlCategorizationHierarchy.LatestInflowOutflow,
		ProfitabilityActual.ReimbursableKey,
		@FeeAdjustmentKey AS FeeAdjustmentKey,
		ProfitabilityActual.FunctionalDepartmentKey,
		ProfitabilityActual.OverheadKey,
		Calendar.CalendarPeriod,	
		CONVERT(VARCHAR(10), ISNULL(ProfitabilityActual.LastDate, ''), 101) AS EntryDate,
		ProfitabilityActual.[User],
		ProfitabilityActual.[Description],
		ProfitabilityActual.AdditionalDescription,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'
			ELSE
				ISNULL(ProfitabilityActual.PropertyFundCode, '')
		END AS PropertyFundCode,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'	
			ELSE
				ISNULL(ProfitabilityActual.OriginatingRegionCode, '')
		END AS OriginatingRegionCode,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'	
			ELSE
				ISNULL(ProfitabilityActual.FunctionalDepartmentCode, '')
		END AS FunctionalDepartmentCode,

		-- MonthToDate -------
		SUM
		(
			#ExchangeRate.Rate * -1 * -- Expenses must be displayed as negative as Income is saved in MRI as negative
			CASE
				WHEN -- If the period of the transaction record is the same as the period for which the report is being generated
					Calendar.CalendarPeriod = @ReportExpensePeriodParameter
				THEN -- Then include it
					ProfitabilityActual.LocalActual
				ELSE -- Else exclude it by adding zero
					0.0
			END
		) AS MtdActual,
		NULL AS MtdBudget,			-- NULL because we're selecting from dbo.ProfitabilityActual: budget data is sourced from dbo.ProfitabilityBudget
		NULL AS MtdReforecastQ1,	-- NULL because we're selecting from dbo.ProfitabilityActual: reforecast data is sourced from dbo.ProfitabilityReforecast
		NULL AS MtdReforecastQ2,	-- See above
		NULL AS MtdReforecastQ3,	-- See above

		-- YearToDate --------
		SUM
		(
			#ExchangeRate.Rate * -1 *
			CASE
				WHEN -- If the period of the transaction record is less than the period for which the report is being generated
					Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
				THEN -- Then include it
					ProfitabilityActual.LocalActual
				ELSE -- Else exclude it by adding zero
					0
			END
		) AS YtdActual,
		NULL AS YtdBudget,			-- NULL because we're selecting from dbo.ProfitabilityActual: budget data is sourced from dbo.ProfitabilityBudget
		NULL AS YtdReforecastQ1,	-- NULL because we're selecting from dbo.ProfitabilityActual: reforecast data is sourced from dbo.ProfitabilityReforecast
		NULL AS YtdReforecastQ2,	-- See above
		NULL AS YtdReforecastQ3,	-- See above

		-- Annual
		NULL AS AnnualBudget,		-- NULL because we're selecting from dbo.ProfitabilityActual: budget data is sourced from dbo.ProfitabilityBudget
		NULL AS AnnualReforecastQ1,	-- NULL because we're selecting from dbo.ProfitabilityActual: reforecast data is sourced from dbo.ProfitabilityReforecast
		NULL AS AnnualReforecastQ2,	-- See above
		NULL AS AnnualReforecastQ3	-- See above
	FROM
		dbo.ProfitabilityActual

		INNER JOIN dbo.Overhead ON
			ProfitabilityActual.Overheadkey = Overhead.OverheadKey

		INNER JOIN #ExchangeRate ON
			ProfitabilityActual.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
			ProfitabilityActual.CalendarKey = #ExchangeRate.CalendarKey

		INNER JOIN #EntityFilterTable ON
			ProfitabilityActual.PropertyFundKey = #EntityFilterTable.PropertyFundKey

		INNER JOIN dbo.Currency ON
			#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey

		INNER JOIN dbo.Reimbursable ON
			ProfitabilityActual.ReimbursableKey = Reimbursable.ReimbursableKey

		INNER JOIN dbo.Calendar ON
			ProfitabilityActual.CalendarKey = Calendar.CalendarKey

		INNER JOIN dbo.[Source] ON 
			[Source].SourceKey = ProfitabilityActual.SourceKey

		INNER JOIN #OverheadFilterTable ON
			ProfitabilityActual.OverheadKey = #OverheadFilterTable.OverheadKey

		INNER JOIN #ActivityTypeFilterTable ON
			ProfitabilityActual.ActivityTypeKey = #ActivityTypeFilterTable.ActivityTypeKey

		LEFT OUTER JOIN #OriginatingSubRegionFilterTable ON
			ProfitabilityActual.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey

		LEFT OUTER JOIN #AllocationSubRegionFilterTable ON	
			ProfitabilityActual.ConsolidationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey    

		INNER JOIN dbo.GlCategorizationHierarchyLatestState GlCategorizationHierarchy ON GlCategorizationHierarchy.GLCategorizationHierarchyKey = 
			CASE
				WHEN @GLCategorizationName = 'Global' THEN ProfitabilityActual.GlobalGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = 'US Property' THEN ProfitabilityActual.USPropertyGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = 'US Fund' THEN ProfitabilityActual.USFundGLCategorizationHierarchyKey 
				WHEN @GLCategorizationName = 'US Development' THEN ProfitabilityActual.USDevelopmentGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = 'EU Property' THEN ProfitabilityActual.EUPropertyGLCategorizationHierarchyKey 
				WHEN @GLCategorizationName = 'EU Fund' THEN ProfitabilityActual.EUFundGLCategorizationHierarchyKey 
				WHEN @GLCategorizationName = 'EU Development' THEN ProfitabilityActual.EUDevelopmentGLCategorizationHierarchyKey
				ELSE NULL
			END
	WHERE
		Calendar.CalendarYear = @CalendarYear AND -- We only want to pull data that is for the year for which the report is being generated
		Currency.CurrencyCode = @_DestinationCurrency AND
		GlCategorizationHierarchy.LatestGLMinorCategoryName <> 'Architects & Engineering' /* IMS 51655 */	AND
		(
			(	-- Retrieve transactions that are not overhead transactions, or transactions that are but are allocated overhead
				Overhead.OverheadCode IN (@GrOverheadCodeAlloc, @GrOverheadCodeNA) AND
				#AllocationSubRegionFilterTable.AllocationRegionKey IS NOT NULL
			) OR
			(	-- Retrieve transactions that are overhead transactions that are unallocated
				Overhead.OverheadCode IN (@GrOverheadCodeUnAlloc) AND
				#OriginatingSubRegionFilterTable.OriginatingRegionKey IS NOT NULL
			)
		)
	GROUP BY
		GlCategorizationHierarchy.GLCategorizationHierarchyKey,
		Overhead.OverheadCode,
		ProfitabilityActual.ActivityTypeKey,
		ProfitabilityActual.PropertyFundKey,
		ProfitabilityActual.AllocationRegionKey,
		ProfitabilityActual.ConsolidationRegionKey,
		ProfitabilityActual.OriginatingRegionKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'	
			ELSE
				[Source].SourceName
		END,
		GlCategorizationHierarchy.LatestGlAccountCode,
		GlCategorizationHierarchy.LatestGLAccountName,
		GlCategorizationHierarchy.LatestGLFinancialCategoryName,
		GlCategorizationHierarchy.LatestInflowOutflow,
		ProfitabilityActual.SourceKey,
		ProfitabilityActual.ReimbursableKey,
		ProfitabilityActual.FunctionalDepartmentKey,
		ProfitabilityActual.OverheadKey,
		Calendar.CalendarPeriod,	
		CONVERT(VARCHAR(10), ISNULL(ProfitabilityActual.LastDate, ''), 101),
		ProfitabilityActual.[User],
		ProfitabilityActual.[Description],
		ProfitabilityActual.AdditionalDescription,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'
			ELSE
				ISNULL(ProfitabilityActual.PropertyFundCode, '')
		END,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'
			ELSE
				ISNULL(ProfitabilityActual.OriginatingRegionCode, '')
		END,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'	
			ELSE
				ISNULL(ProfitabilityActual.FunctionalDepartmentCode, '')
		END
END

/* ==============================================================================================================================================
	Get the Budget portion of the data by selecting from the GrReporting.dbo.ProfitabilityBudget fact
   =========================================================================================================================================== */
BEGIN

	INSERT INTO #ProfitabilityReport
	SELECT
		GlCategorizationHierarchy.GLCategorizationHierarchyKey AS 'GLCategorizationHierarchyKey',
		Overhead.OverheadCode,
		ProfitabilityBudget.ActivityTypeKey,
		ProfitabilityBudget.PropertyFundKey,
		ProfitabilityBudget.AllocationRegionKey,
		ProfitabilityBudget.ConsolidationRegionKey,
		ProfitabilityBudget.OriginatingRegionKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'	
			ELSE
				[Source].SourceName
		END AS 'SourceName',    
		ProfitabilityBudget.SourceKey AS SourceKey,
		GlCategorizationHierarchy.LatestGlAccountCode,
		GlCategorizationHierarchy.LatestGLAccountName,
		CASE
			WHEN
				(GlCategorizationHierarchy.LatestGLFinancialCategoryName = 'Payroll' AND Overhead.OverheadCode = 'UNALLOC') OR
				(GlCategorizationHierarchy.LatestGLFinancialCategoryName = 'Non-Payroll' AND Overhead.OverheadCode = 'UNALLOC')
			THEN
				'Overhead'
			ELSE
				GlCategorizationHierarchy.LatestGLFinancialCategoryName
		END AS 'GLFinancialCategoryName',
		GlCategorizationHierarchy.LatestInflowOutflow,
		ProfitabilityBudget.ReimbursableKey,
		ProfitabilityBudget.FeeAdjustmentKey,
		ProfitabilityBudget.FunctionalDepartmentKey,
		ProfitabilityBudget.OverheadKey,
		'''' AS CalendarPeriod,
		'''' AS EntryDate,
		'''' AS [User],
		'''' AS [Description],
		'''' AS AdditionalDescription,
		'''' AS PropertyFundCode,
		'''' AS OriginatingRegionCode,
		'''' AS FunctionalDepartmentCode,

		--Expenses must be displayed as negative
		NULL as MtdActual, -- NULL because we're selecting from dbo.ProfitabilityBudget: actual data has already been sourced from dbo.ProfitabilityActual in the previous SELECT
		SUM
		(
			#ExchangeRate.Rate *
			(
				CASE
					WHEN
						GlCategorizationHierarchy.LatestInflowOutflow = @InflowOutflowIncome
					THEN
						1
					ELSE
						-1
				END
			) *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod = @ReportExpensePeriodParameter
					THEN
						ProfitabilityBudget.LocalBudget
					ELSE
						0
				END
			)
		) AS MtdBudget,
		NULL as MtdReforecastQ1, -- NULL because we're selecting from dbo.ProfitabilityActual: reforecast data is sourced from dbo.ProfitabilityReforecast
		NULL as MtdReforecastQ2, -- See above
		NULL as MtdReforecastQ3, -- See above
		
		NULL as YtdActual, -- NULL because we're selecting from dbo.ProfitabilityBudget: actual data has already been sourced from dbo.ProfitabilityActual in the previous SELECT
		SUM
		(
			#ExchangeRate.Rate *
			(
				CASE
					WHEN
						GlCategorizationHierarchy.LatestInflowOutflow = @InflowOutflowIncome
					THEN
						1
					ELSE
						-1 
				END
			) * 
			(
				CASE
					WHEN
						Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
					THEN
						ProfitabilityBudget.LocalBudget
					ELSE
						0
				END
			)
		) AS YtdBudget, -- NULL because we're selecting from dbo.ProfitabilityActual: reforecast data is sourced from dbo.ProfitabilityReforecast
		NULL AS YtdReforecastQ1, -- NULL because we're selecting from dbo.ProfitabilityActual: reforecast data is sourced from dbo.ProfitabilityReforecast
		NULL AS YtdReforecastQ2, -- See above
		NULL AS YtdReforecastQ3, -- See above

		SUM
		(
			#ExchangeRate.Rate *
			ProfitabilityBudget.LocalBudget *
			(
				CASE
					WHEN
						GlCategorizationHierarchy.LatestInflowOutflow = @InflowOutflowIncome
					THEN
						1
					ELSE
						-1 
				END
			)
		) AS AnnualBudget,
		NULL as AnnualReforecastQ1, -- NULL because we're selecting from dbo.ProfitabilityActual: reforecast data is sourced from dbo.ProfitabilityReforecast
		NULL as AnnualReforecastQ2, -- See above
		NULL as AnnualReforecastQ3  -- See above
	FROM
		dbo.ProfitabilityBudget

		INNER JOIN dbo.Overhead ON
			ProfitabilityBudget.Overheadkey = Overhead.OverheadKey

		INNER JOIN #ExchangeRate ON
			ProfitabilityBudget.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
			ProfitabilityBudget.CalendarKey = #ExchangeRate.CalendarKey    

		INNER JOIN #EntityFilterTable ON
			ProfitabilityBudget.PropertyFundKey = #EntityFilterTable.PropertyFundKey

		INNER JOIN dbo.Currency ON
			#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey

		INNER JOIN dbo.Reimbursable ON
			ProfitabilityBudget.ReimbursableKey = Reimbursable.ReimbursableKey

		LEFT OUTER JOIN #OriginatingSubRegionFilterTable ON
			ProfitabilityBudget.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey

		INNER JOIN dbo.Calendar ON
			ProfitabilityBudget.CalendarKey = Calendar.CalendarKey

		INNER JOIN dbo.[Source] ON
			[Source].SourceKey = ProfitabilityBudget.SourceKey

		INNER JOIN #OverheadFilterTable ON
			ProfitabilityBudget.OverheadKey = #OverheadFilterTable.OverheadKey

		INNER JOIN #ActivityTypeFilterTable ON
			ProfitabilityBudget.ActivityTypeKey = #ActivityTypeFilterTable.ActivityTypeKey

		LEFT OUTER JOIN #AllocationSubRegionFilterTable ON
			-- ProfitabilityActual.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey
			-- Profitibility uses Consolidation regions instead of allocation regions
			ProfitabilityBudget.ConsolidationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey

		INNER JOIN #FeeAdjustmentFilterTable ON
			ProfitabilityBudget.FeeAdjustmentKey = #FeeAdjustmentFilterTable.FeeAdjustmentKey

		INNER JOIN dbo.GlCategorizationHierarchyLatestState GlCategorizationHierarchy ON GlCategorizationHierarchy.GLCategorizationHierarchyKey = 
			CASE
				WHEN @GLCategorizationName = 'Global' THEN ProfitabilityBudget.GlobalGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = 'US Property' THEN ProfitabilityBudget.USPropertyGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = 'US Fund' THEN ProfitabilityBudget.USFundGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = 'US Development' THEN ProfitabilityBudget.USDevelopmentGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = 'EU Property' THEN ProfitabilityBudget.EUPropertyGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = 'EU Fund' THEN ProfitabilityBudget.EUFundGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = 'EU Development' THEN ProfitabilityBudget.EUDevelopmentGLCategorizationHierarchyKey
				ELSE NULL
			END
	WHERE
		Calendar.CalendarYear = @CalendarYear AND
		Currency.CurrencyCode = @_DestinationCurrency AND
		GlCategorizationHierarchy.LatestGLMinorCategoryName <> 'Architects & Engineering' /* IMS 51655 */	AND
		(
			(
				Overhead.OverheadCode IN (@GrOverheadCodeAlloc, @GrOverheadCodeNA) AND
				#AllocationSubRegionFilterTable.AllocationRegionKey IS NOT NULL
			) OR
			(
				Overhead.OverheadCode IN (@GrOverheadCodeUnAlloc) AND
				#OriginatingSubRegionFilterTable.OriginatingRegionKey IS NOT NULL
			)
		)
	GROUP BY
		GlCategorizationHierarchy.GLCategorizationHierarchyKey,
		Overhead.OverheadCode,
		ProfitabilityBudget.ActivityTypeKey,
		ProfitabilityBudget.PropertyFundKey,
		ProfitabilityBudget.AllocationRegionKey,
		ProfitabilityBudget.ConsolidationRegionKey,
		ProfitabilityBudget.OriginatingRegionKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'
			ELSE
				[Source].SourceName
		END,
		GlCategorizationHierarchy.LatestGlAccountCode,
		GlCategorizationHierarchy.LatestGLAccountName,
		GlCategorizationHierarchy.LatestGLFinancialCategoryName,
		GlCategorizationHierarchy.LatestInflowOutflow,
		ProfitabilityBudget.SourceKey,
		ProfitabilityBudget.ReimbursableKey,
		ProfitabilityBudget.FeeAdjustmentKey,
		ProfitabilityBudget.FunctionalDepartmentKey,
		ProfitabilityBudget.OverheadKey,
		Calendar.CalendarPeriod

END
   
/* ==============================================================================================================================================
	Get the Q1 Reforecast portion of the data by selecting from the GrReporting.dbo.ProfitabilityReforecast fact
   =========================================================================================================================================== */
BEGIN

	INSERT INTO #ProfitabilityReport
	SELECT
		GlCategorizationHierarchy.GLCategorizationHierarchyKey,
		Overhead.OverheadCode,
		ProfitabilityReforecast.ActivityTypeKey,
		ProfitabilityReforecast.PropertyFundKey,
		ProfitabilityReforecast.AllocationRegionKey,
		ProfitabilityReforecast.ConsolidationRegionKey,
		ProfitabilityReforecast.OriginatingRegionKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'	
			ELSE
				[Source].SourceName
		END AS 'SourceName',        
		ProfitabilityReforecast.SourceKey,
		GlCategorizationHierarchy.LatestGlAccountCode,
		GlCategorizationHierarchy.LatestGLAccountName,
		CASE 
			WHEN 
				(GlCategorizationHierarchy.LatestGLFinancialCategoryName = 'Payroll' AND Overhead.OverheadCode = 'UNALLOC') OR
				(GlCategorizationHierarchy.LatestGLFinancialCategoryName = 'Non-Payroll' AND Overhead.OverheadCode = 'UNALLOC') 
			THEN 
				'Overhead' 
			ELSE  
				GlCategorizationHierarchy.LatestGLFinancialCategoryName 
		END AS 'GLFinancialCategoryName',
		GlCategorizationHierarchy.LatestInflowOutflow,
		ProfitabilityReforecast.ReimbursableKey,
		ProfitabilityReforecast.FeeAdjustmentKey,
		ProfitabilityReforecast.FunctionalDepartmentKey,
		ProfitabilityReforecast.OverheadKey,
		'''' AS CalendarPeriod,
		
		'''' AS EntryDate,
		'''' AS [User],
		'''' AS [Description],
		'''' AS AdditionalDescription,
		'''' AS PropertyFundCode,
		'''' AS OriginatingRegionCode,
		'''' AS FunctionalDepartmentCode,

		NULL AS MtdActual, -- NULL because we're selecting from dbo.ProfitabilityReforecast: actual data has already been sourced from dbo.ProfitabilityActual in a previous SELECT
		NULL AS MtdBudget, -- NULL because we're selecting from dbo.ProfitabilityReforecast: budget data has already been sourced from dbo.ProfitabilityBudget in a previous SELECT
		SUM
		(
			#ExchangeRate.Rate *
			(	--Expenses must be displayed as negative
				CASE
					WHEN
						GlCategorizationHierarchy.LatestInflowOutflow = @InflowOutflowIncome
					THEN
						1
					ELSE
						-1
				END
			) *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod = @ReportExpensePeriodParameter
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0
				END
			)
		) AS MtdReforecastQ1,
		NULL AS MtdReforecastQ2, -- NULL because we're selecting only Q1 reforecast data from dbo.ProfitabilityReforecast: Q2 reforecast data will be select later on
		NULL AS MtdReforecastQ3, -- NULL because we're selecting only Q1 reforecast data from dbo.ProfitabilityReforecast: Q3 reforecast data will be select later on

		NULL AS YtdActual, -- NULL because we're selecting from dbo.ProfitabilityReforecast: actual data has already been sourced from dbo.ProfitabilityActual in a previous SELECT
		NULL AS YtdBudget, -- NULL because we're selecting from dbo.ProfitabilityReforecast: budget data has already been sourced from dbo.ProfitabilityBudget in a previous SELECT
		SUM
		(
			#ExchangeRate.Rate *
			(
				CASE
					WHEN
						GlCategorizationHierarchy.LatestInflowOutflow = @InflowOutflowIncome
					THEN
						1
					ELSE
					-1
				END
			) *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0
				END
			)
		) AS YtdReforecastQ1, 
		NULL AS YtdReforecastQ2, -- NULL because we're selecting only Q1 reforecast data from dbo.ProfitabilityReforecast: Q2 reforecast data will be select later on
		NULL AS YtdReforecastQ3, -- NULL because we're selecting only Q1 reforecast data from dbo.ProfitabilityReforecast: Q3 reforecast data will be select later on
		
		NULL AS AnnualBudget, -- NULL because we're selecting from dbo.ProfitabilityReforecast: budget data has already been sourced from dbo.ProfitabilityBudget in a previous SELECT
		SUM
		(
			#ExchangeRate.Rate *
			ProfitabilityReforecast.LocalReforecast * 
			(
				CASE
					WHEN
						GlCategorizationHierarchy.LatestInflowOutflow = @InflowOutflowIncome
					THEN
						1
					ELSE
						-1 
				END
			)
		) AS AnnualReforecastQ1,
		NULL AS AnnualReforecastQ2, -- NULL because we're selecting only Q1 reforecast data from dbo.ProfitabilityReforecast: Q2 reforecast data will be select later on
		NULL AS AnnualReforecastQ3  -- NULL because we're selecting only Q1 reforecast data from dbo.ProfitabilityReforecast: Q3 reforecast data will be select later on
	FROM
		dbo.ProfitabilityReforecast

		INNER JOIN dbo.Overhead ON
			ProfitabilityReforecast.Overheadkey = Overhead.OverheadKey

		INNER JOIN #ExchangeRate ON
			ProfitabilityReforecast.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
			ProfitabilityReforecast.CalendarKey = #ExchangeRate.CalendarKey    

		INNER JOIN #EntityFilterTable ON
			ProfitabilityReforecast.PropertyFundKey = #EntityFilterTable.PropertyFundKey

		INNER JOIN dbo.Currency ON
			#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey

		INNER JOIN dbo.Reimbursable ON
			ProfitabilityReforecast.ReimbursableKey = Reimbursable.ReimbursableKey

		INNER JOIN dbo.Calendar ON
			ProfitabilityReforecast.CalendarKey = Calendar.CalendarKey

		INNER JOIN dbo.[Source] ON
			[Source].SourceKey = ProfitabilityReforecast.SourceKey

		INNER JOIN #OverheadFilterTable ON
			ProfitabilityReforecast.OverheadKey = #OverheadFilterTable.OverheadKey

		INNER JOIN #ActivityTypeFilterTable ON
			ProfitabilityReforecast.ActivityTypeKey = #ActivityTypeFilterTable.ActivityTypeKey	

		INNER JOIN Reforecast ON
			ProfitabilityReforecast.ReforecastKey = Reforecast.ReforecastKey

		INNER JOIN #FeeAdjustmentFilterTable ON
			ProfitabilityReforecast.FeeAdjustmentKey = #FeeAdjustmentFilterTable.FeeAdjustmentKey		

		INNER JOIN dbo.GlCategorizationHierarchyLatestState GlCategorizationHierarchy ON GlCategorizationHierarchy.GLCategorizationHierarchyKey = 
			CASE
				WHEN @GLCategorizationName = 'Global' THEN ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey 
				WHEN @GLCategorizationName = 'US Property' THEN ProfitabilityReforecast.USPropertyGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = 'US Fund' THEN ProfitabilityReforecast.USFundGLCategorizationHierarchyKey 
				WHEN @GLCategorizationName = 'US Development' THEN ProfitabilityReforecast.USDevelopmentGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = 'EU Property' THEN ProfitabilityReforecast.EUPropertyGLCategorizationHierarchyKey 
				WHEN @GLCategorizationName = 'EU Fund' THEN ProfitabilityReforecast.EUFundGLCategorizationHierarchyKey 
				WHEN @GLCategorizationName = 'EU Development' THEN ProfitabilityReforecast.EUDevelopmentGLCategorizationHierarchyKey
				ELSE NULL
			END

		LEFT OUTER JOIN #OriginatingSubRegionFilterTable ON
			ProfitabilityReforecast.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey

		LEFT OUTER JOIN #AllocationSubRegionFilterTable ON	
			ProfitabilityReforecast.ConsolidationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey    		
	WHERE
		Reforecast.ReforecastKey = @Q1ReforecastKey AND -- Limit to Q1 data
		Calendar.CalendarYear = @CalendarYear AND
		Currency.CurrencyCode = @_DestinationCurrency AND
		GlCategorizationHierarchy.LatestGLMinorCategoryName <> 'Architects & Engineering' /* IMS 51655 */	AND
		(
			(
				Overhead.OverheadCode IN (@GrOverheadCodeAlloc, @GrOverheadCodeNA) AND #AllocationSubRegionFilterTable.AllocationRegionKey IS NOT NULL
			) OR
			(
				Overhead.OverheadCode IN (@GrOverheadCodeUnAlloc) AND #OriginatingSubRegionFilterTable.OriginatingRegionKey IS NOT NULL
			)
		)
	GROUP BY
		GlCategorizationHierarchy.GLCategorizationHierarchyKey,
		Overhead.OverheadCode,
		ProfitabilityReforecast.ActivityTypeKey,
		ProfitabilityReforecast.PropertyFundKey,
		ProfitabilityReforecast.AllocationRegionKey,
		ProfitabilityReforecast.ConsolidationRegionKey,
		ProfitabilityReforecast.OriginatingRegionKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'
			ELSE
				[Source].SourceName
		END,
		GlCategorizationHierarchy.LatestGlAccountCode,
		GlCategorizationHierarchy.LatestGLAccountName,
		GlCategorizationHierarchy.LatestGLFinancialCategoryName,
		GlCategorizationHierarchy.LatestInflowOutflow,
		ProfitabilityReforecast.SourceKey,
		ProfitabilityReforecast.ReimbursableKey,
		ProfitabilityReforecast.FeeAdjustmentKey,
		ProfitabilityReforecast.FunctionalDepartmentKey,
		ProfitabilityReforecast.OverheadKey,
		Calendar.CalendarPeriod

END

/* ==============================================================================================================================================
	Get the Q2 Reforecast portion of the data by selecting from the GrReporting.dbo.ProfitabilityReforecast fact
   =========================================================================================================================================== */
BEGIN

	INSERT INTO #ProfitabilityReport
	SELECT
		GlCategorizationHierarchy.GLCategorizationHierarchyKey,
		Overhead.OverheadCode,
		ProfitabilityReforecast.ActivityTypeKey,
		ProfitabilityReforecast.PropertyFundKey,
		ProfitabilityReforecast.AllocationRegionKey,
		ProfitabilityReforecast.ConsolidationRegionKey,
		ProfitabilityReforecast.OriginatingRegionKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'	
			ELSE
				[Source].SourceName
		END AS 'SourceName',        
		ProfitabilityReforecast.SourceKey,
		GlCategorizationHierarchy.LatestGlAccountCode,
		GlCategorizationHierarchy.LatestGLAccountName,
		CASE 
			WHEN 
				(GlCategorizationHierarchy.LatestGLFinancialCategoryName = 'Payroll' AND Overhead.OverheadCode = 'UNALLOC') OR
				(GlCategorizationHierarchy.LatestGLFinancialCategoryName = 'Non-Payroll' AND Overhead.OverheadCode = 'UNALLOC') 
			THEN 
				'Overhead' 
			ELSE  
				GlCategorizationHierarchy.LatestGLFinancialCategoryName 
		END AS 'GLFinancialCategoryName',
		GlCategorizationHierarchy.LatestInflowOutflow,
		ProfitabilityReforecast.ReimbursableKey,
		ProfitabilityReforecast.FeeAdjustmentKey,
		ProfitabilityReforecast.FunctionalDepartmentKey,
		ProfitabilityReforecast.OverheadKey,
		'''' AS CalendarPeriod,
		
		'''' AS EntryDate,
		'''' AS [User],
		'''' AS [Description],
		'''' AS AdditionalDescription,
		'''' AS PropertyFundCode,
		'''' AS OriginatingRegionCode,
		'''' AS FunctionalDepartmentCode,

		NULL AS MtdActual,		 -- NULL because we're selecting from dbo.ProfitabilityReforecast: actual data has already been sourced from dbo.ProfitabilityActual in a previous SELECT
		NULL AS MtdBudget,		 -- NULL because we're selecting from dbo.ProfitabilityReforecast: budget data has already been sourced from dbo.ProfitabilityBudget in a previous SELECT
		NULL AS MtdReforecastQ1, -- NULL because we're selecting only Q2 reforecast data from dbo.ProfitabilityReforecast: Q1 reforecast data has already been sourced from dbo.ProfitabilityReforecast in a previous SELECT
		SUM
		(
			#ExchangeRate.Rate *
			(	--Expenses must be displayed as negative
				CASE
					WHEN
						GlCategorizationHierarchy.LatestInflowOutflow = @InflowOutflowIncome
					THEN
						1
					ELSE
						-1 
				END
			) *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod = @ReportExpensePeriodParameter
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0
				END
			)
		) AS MtdReforecastQ2,		
		NULL AS MtdReforecastQ3, -- NULL because we're selecting only Q2 reforecast data from dbo.ProfitabilityReforecast: Q3 reforecast data will be select later on
		
		NULL AS YtdActual,		 -- NULL because we're selecting from dbo.ProfitabilityReforecast: actual data has already been sourced from dbo.ProfitabilityActual in a previous SELECT
		NULL AS YtdBudget,		 -- NULL because we're selecting from dbo.ProfitabilityReforecast: budget data has already been sourced from dbo.ProfitabilityBudget in a previous SELECT
		NULL AS YtdReforecastQ1, -- NULL because we're selecting only Q2 reforecast data from dbo.ProfitabilityReforecast: Q1 reforecast data has already been sourced from dbo.ProfitabilityReforecast in a previous SELECT
		SUM
		(
			#ExchangeRate.Rate *
			(
				CASE
					WHEN
						GlCategorizationHierarchy.LatestInflowOutflow = @InflowOutflowIncome
					THEN
						1
					ELSE
						-1
				END
			) *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0
				END
			)
		) AS YtdReforecastQ2,
		NULL AS YtdReforecastQ3,	-- NULL because we're selecting only Q2 reforecast data from dbo.ProfitabilityReforecast: Q3 reforecast data will be select later on
		
		NULL AS AnnualBudget,		-- NULL because we're selecting from dbo.ProfitabilityReforecast: budget data has already been sourced from dbo.ProfitabilityBudget in a previous SELECT
		NULL as AnnualReforecastQ1, -- NULL because we're selecting only Q2 reforecast data from dbo.ProfitabilityReforecast: Q1 reforecast data has already been sourced from dbo.ProfitabilityReforecast in a previous SELECT
		SUM
		(
			#ExchangeRate.Rate *
			ProfitabilityReforecast.LocalReforecast *
			(
				CASE
					WHEN
						GlCategorizationHierarchy.LatestInflowOutflow = @InflowOutflowIncome
					THEN
						1
					ELSE
						-1 
				END
			)
		) AS AnnualReforecastQ2,
		NULL AS AnnualReforecastQ3 -- NULL because we're selecting only Q2 reforecast data from dbo.ProfitabilityReforecast: Q3 reforecast data will be select later on
	FROM
		dbo.ProfitabilityReforecast

		INNER JOIN dbo.Overhead ON
			ProfitabilityReforecast.Overheadkey = Overhead.OverheadKey

		INNER JOIN #ExchangeRate ON
			ProfitabilityReforecast.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
			ProfitabilityReforecast.CalendarKey = #ExchangeRate.CalendarKey

		INNER JOIN #EntityFilterTable ON
			ProfitabilityReforecast.PropertyFundKey = #EntityFilterTable.PropertyFundKey

		INNER JOIN dbo.Currency ON
			#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey

		INNER JOIN dbo.Reimbursable ON
			ProfitabilityReforecast.ReimbursableKey = Reimbursable.ReimbursableKey

		INNER JOIN dbo.Calendar ON
			ProfitabilityReforecast.CalendarKey = Calendar.CalendarKey

		INNER JOIN dbo.[Source] ON 
			[Source].SourceKey = ProfitabilityReforecast.SourceKey

		INNER JOIN #OverheadFilterTable ON
			ProfitabilityReforecast.OverheadKey = #OverheadFilterTable.OverheadKey

		INNER JOIN #ActivityTypeFilterTable ON
			ProfitabilityReforecast.ActivityTypeKey = #ActivityTypeFilterTable.ActivityTypeKey		

		INNER JOIN Reforecast ON
			ProfitabilityReforecast.ReforecastKey = Reforecast.ReforecastKey

		INNER JOIN #FeeAdjustmentFilterTable ON
			ProfitabilityReforecast.FeeAdjustmentKey = #FeeAdjustmentFilterTable.FeeAdjustmentKey

		INNER JOIN dbo.GlCategorizationHierarchyLatestState GlCategorizationHierarchy ON GlCategorizationHierarchy.GLCategorizationHierarchyKey = 
			CASE
				WHEN @GLCategorizationName = 'Global' THEN ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey 
				WHEN @GLCategorizationName = 'US Property' THEN ProfitabilityReforecast.USPropertyGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = 'US Fund' THEN ProfitabilityReforecast.USFundGLCategorizationHierarchyKey 
				WHEN @GLCategorizationName = 'US Development' THEN ProfitabilityReforecast.USDevelopmentGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = 'EU Property' THEN ProfitabilityReforecast.EUPropertyGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = 'EU Fund' THEN ProfitabilityReforecast.EUFundGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = 'EU Development' THEN ProfitabilityReforecast.EUDevelopmentGLCategorizationHierarchyKey
				ELSE NULL
			END

		LEFT OUTER JOIN #OriginatingSubRegionFilterTable ON
			ProfitabilityReforecast.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey

		LEFT OUTER JOIN #AllocationSubRegionFilterTable ON	
			ProfitabilityReforecast.ConsolidationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey
	WHERE  
		Calendar.CalendarYear = @CalendarYear AND
		Currency.CurrencyCode = @_DestinationCurrency AND
		Reforecast.ReforecastKey = @Q2ReforecastKey AND -- Limit to Q2 data
		GlCategorizationHierarchy.LatestGLMinorCategoryName <> 'Architects & Engineering' /* IMS 51655 */ AND
		(
			(
				Overhead.OverheadCode IN (@GrOverheadCodeAlloc, @GrOverheadCodeNA) AND
				#AllocationSubRegionFilterTable.AllocationRegionKey IS NOT NULL
			) OR
			(
				Overhead.OverheadCode IN (@GrOverheadCodeUnAlloc) AND
				#OriginatingSubRegionFilterTable.OriginatingRegionKey IS NOT NULL
			)
		)
	GROUP BY
		GlCategorizationHierarchy.GLCategorizationHierarchyKey,
		Overhead.OverheadCode,
		ProfitabilityReforecast.ActivityTypeKey,
		ProfitabilityReforecast.PropertyFundKey,
		ProfitabilityReforecast.AllocationRegionKey,
		ProfitabilityReforecast.ConsolidationRegionKey,
		ProfitabilityReforecast.OriginatingRegionKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'
			ELSE
				[Source].SourceName
		END,
		GlCategorizationHierarchy.LatestGlAccountCode,
		GlCategorizationHierarchy.LatestGLAccountName,
		GlCategorizationHierarchy.LatestGLFinancialCategoryName,
		GlCategorizationHierarchy.LatestInflowOutflow,
		ProfitabilityReforecast.SourceKey,
		ProfitabilityReforecast.ReimbursableKey,
		ProfitabilityReforecast.FeeAdjustmentKey,
		ProfitabilityReforecast.FunctionalDepartmentKey,
		ProfitabilityReforecast.OverheadKey,
		Calendar.CalendarPeriod	

END
	
/* ==============================================================================================================================================
	Get the Q2 Reforecast portion of the data by selecting from the GrReporting.dbo.ProfitabilityReforecast fact
   =========================================================================================================================================== */
BEGIN

	INSERT INTO #ProfitabilityReport
	SELECT
		GlCategorizationHierarchy.GLCategorizationHierarchyKey,
		Overhead.OverheadCode,
		ProfitabilityReforecast.ActivityTypeKey,
		ProfitabilityReforecast.PropertyFundKey,
		ProfitabilityReforecast.AllocationRegionKey,
		ProfitabilityReforecast.ConsolidationRegionKey,
		ProfitabilityReforecast.OriginatingRegionKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'	
			ELSE
				[Source].SourceName
		END AS 'SourceName',
		ProfitabilityReforecast.SourceKey,
		GlCategorizationHierarchy.LatestGlAccountCode,
		GlCategorizationHierarchy.LatestGLAccountName,
		CASE
			WHEN
				(
					GlCategorizationHierarchy.LatestGLFinancialCategoryName = 'Payroll' AND Overhead.OverheadCode = 'UNALLOC'
				) OR
				(
					GlCategorizationHierarchy.LatestGLFinancialCategoryName = 'Non-Payroll' AND Overhead.OverheadCode = 'UNALLOC'
				)
			THEN 
				'Overhead'
			ELSE
				GlCategorizationHierarchy.LatestGLFinancialCategoryName 
		END AS 'GLFinancialCategoryName',
		GlCategorizationHierarchy.LatestInflowOutflow,
		ProfitabilityReforecast.ReimbursableKey,
		ProfitabilityReforecast.FeeAdjustmentKey,
		ProfitabilityReforecast.FunctionalDepartmentKey,
		ProfitabilityReforecast.OverheadKey,
		'''' AS CalendarPeriod,
		
		'''' AS EntryDate,
		'''' AS [User],
		'''' AS [Description],
		'''' AS AdditionalDescription,
		'''' AS PropertyFundCode,
		'''' AS OriginatingRegionCode,
		'''' AS FunctionalDepartmentCode,
	    
		--Expenses must be displayed as negative
		NULL AS MtdActual,		 -- NULL because we're selecting from dbo.ProfitabilityReforecast: actual data has already been sourced from dbo.ProfitabilityActual in a previous SELECT
		NULL AS MtdBudget,		 -- NULL because we're selecting from dbo.ProfitabilityReforecast: budget data has already been sourced from dbo.ProfitabilityBudget in a previous SELECT
		NULL AS MtdReforecastQ1, -- NULL because we're selecting only Q3 reforecast data from dbo.ProfitabilityReforecast: Q1 reforecast data has already been sourced from dbo.ProfitabilityReforecast in a previous SELECT
		NULL AS MtdReforecastQ2, -- NULL because we're selecting only Q3 reforecast data from dbo.ProfitabilityReforecast: Q2 reforecast data has already been sourced from dbo.ProfitabilityReforecast in a previous SELECT
		SUM
		(
			#ExchangeRate.Rate *
			(
				CASE
					WHEN
						GlCategorizationHierarchy.LatestInflowOutflow = @InflowOutflowIncome
					THEN
						1
					ELSE
						-1
				END
			) *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod = @ReportExpensePeriodParameter
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0
				END
			)
		) AS MtdReforecastQ3,
		
		NULL AS YtdActual,		 -- NULL because we're selecting from dbo.ProfitabilityReforecast: actual data has already been sourced from dbo.ProfitabilityActual in a previous SELECT
		NULL AS YtdBudget,		 -- NULL because we're selecting from dbo.ProfitabilityReforecast: budget data has already been sourced from dbo.ProfitabilityBudget in a previous SELECT
		NULL AS YtdReforecastQ1, -- NULL because we're selecting only Q3 reforecast data from dbo.ProfitabilityReforecast: Q1 reforecast data has already been sourced from dbo.ProfitabilityReforecast in a previous SELECT 
		NULL AS YtdReforecastQ2, -- NULL because we're selecting only Q3 reforecast data from dbo.ProfitabilityReforecast: Q2 reforecast data has already been sourced from dbo.ProfitabilityReforecast in a previous SELECT
		SUM
		(
			#ExchangeRate.Rate *
			(
				CASE
					WHEN
						GlCategorizationHierarchy.LatestInflowOutflow = @InflowOutflowIncome
					THEN
						1
					ELSE
						-1
				END
			) *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
					THEN
						ProfitabilityReforecast.LocalReforecast
					ELSE
						0
				END
			)
		) AS YtdReforecastQ3,

		NULL AS AnnualBudget,		-- NULL because we're selecting from dbo.ProfitabilityReforecast: budget data has already been sourced from dbo.ProfitabilityBudget in a previous SELECT
		NULL AS AnnualReforecastQ1, -- NULL because we're selecting only Q3 reforecast data from dbo.ProfitabilityReforecast: Q1 reforecast data has already been sourced from dbo.ProfitabilityReforecast in a previous SELECT
		NULL AS AnnualReforecastQ2, -- NULL because we're selecting only Q3 reforecast data from dbo.ProfitabilityReforecast: Q2 reforecast data has already been sourced from dbo.ProfitabilityReforecast in a previous SELECT
		SUM
		(
			#ExchangeRate.Rate *
			ProfitabilityReforecast.LocalReforecast *
			(
				CASE
					WHEN
						GlCategorizationHierarchy.LatestInflowOutflow = @InflowOutflowIncome
					THEN
						1
					ELSE
						-1
				END
			)
		) AS AnnualReforecastQ3
	FROM
		dbo.ProfitabilityReforecast

		INNER JOIN dbo.Overhead ON
			ProfitabilityReforecast.Overheadkey = Overhead.OverheadKey

		INNER JOIN #ExchangeRate ON
			ProfitabilityReforecast.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
			ProfitabilityReforecast.CalendarKey = #ExchangeRate.CalendarKey    

		INNER JOIN #EntityFilterTable ON
			ProfitabilityReforecast.PropertyFundKey = #EntityFilterTable.PropertyFundKey

		INNER JOIN dbo.Currency ON
			#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey

		INNER JOIN dbo.Reimbursable ON
			ProfitabilityReforecast.ReimbursableKey = Reimbursable.ReimbursableKey

		INNER JOIN dbo.Calendar ON
			ProfitabilityReforecast.CalendarKey = Calendar.CalendarKey

		INNER JOIN dbo.[Source] ON 
			[Source].SourceKey = ProfitabilityReforecast.SourceKey

		INNER JOIN #OverheadFilterTable ON
			ProfitabilityReforecast.OverheadKey = #OverheadFilterTable.OverheadKey

		INNER JOIN #ActivityTypeFilterTable ON
			ProfitabilityReforecast.ActivityTypeKey = #ActivityTypeFilterTable.ActivityTypeKey

		INNER JOIN Reforecast ON
			ProfitabilityReforecast.ReforecastKey = Reforecast.ReforecastKey

		INNER JOIN #FeeAdjustmentFilterTable ON
			ProfitabilityReforecast.FeeAdjustmentKey = #FeeAdjustmentFilterTable.FeeAdjustmentKey		

		INNER JOIN dbo.GlCategorizationHierarchyLatestState GlCategorizationHierarchy ON GlCategorizationHierarchy.GLCategorizationHierarchyKey = 
			CASE
				WHEN @GLCategorizationName = 'Global' THEN ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = 'US Property' THEN ProfitabilityReforecast.USPropertyGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = 'US Fund' THEN ProfitabilityReforecast.USFundGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = 'US Development' THEN ProfitabilityReforecast.USDevelopmentGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = 'EU Property' THEN ProfitabilityReforecast.EUPropertyGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = 'EU Fund' THEN ProfitabilityReforecast.EUFundGLCategorizationHierarchyKey
				WHEN @GLCategorizationName = 'EU Development' THEN ProfitabilityReforecast.EUDevelopmentGLCategorizationHierarchyKey
				ELSE NULL
			END

		LEFT OUTER JOIN #OriginatingSubRegionFilterTable ON
			ProfitabilityReforecast.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey

		LEFT OUTER JOIN #AllocationSubRegionFilterTable ON
			ProfitabilityReforecast.ConsolidationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey
	WHERE
		Calendar.CalendarYear = @CalendarYear AND
		Currency.CurrencyCode = @_DestinationCurrency AND
		Reforecast.ReforecastKey = @Q3ReforecastKey AND -- Limit to Q3 data
		GlCategorizationHierarchy.LatestGLMinorCategoryName <> 'Architects & Engineering' /* IMS 51655 */ AND
		(
			(
				Overhead.OverheadCode IN (@GrOverheadCodeAlloc, @GrOverheadCodeNA) AND
				#AllocationSubRegionFilterTable.AllocationRegionKey IS NOT NULL
			) OR
			(
				Overhead.OverheadCode IN (@GrOverheadCodeUnAlloc) AND
				#OriginatingSubRegionFilterTable.OriginatingRegionKey IS NOT NULL
			)
		)
	GROUP BY
		GlCategorizationHierarchy.GLCategorizationHierarchyKey,
		Overhead.OverheadCode,
		ProfitabilityReforecast.ActivityTypeKey,
		ProfitabilityReforecast.PropertyFundKey,
		ProfitabilityReforecast.AllocationRegionKey,
		ProfitabilityReforecast.ConsolidationRegionKey,
		ProfitabilityReforecast.OriginatingRegionKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.LatestGLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'
			ELSE
				[Source].SourceName
		END,
		GlCategorizationHierarchy.LatestGlAccountCode,
		GlCategorizationHierarchy.LatestGLAccountName,
		GlCategorizationHierarchy.LatestGLFinancialCategoryName,
		GlCategorizationHierarchy.LatestInflowOutflow,
		ProfitabilityReforecast.SourceKey,
		ProfitabilityReforecast.ReimbursableKey,
		ProfitabilityReforecast.FeeAdjustmentKey,
		ProfitabilityReforecast.FunctionalDepartmentKey,
		ProfitabilityReforecast.OverheadKey,
		Calendar.CalendarPeriod

END

/* ==============================================================================================================================================
	Combine the Actual, Original Budget, and Reforecast (Q1, Q2, and Q3) data in a single select
   =========================================================================================================================================== */
BEGIN

	SELECT
		#ProfitabilityReport.GLFinancialCategoryName AS ExpenseType, 
		#ProfitabilityReport.InflowOutflow AS 'InflowOutflow',
		CategorizationHierarchyInWarehouse.LatestGLMajorCategoryName AS 'MajorExpenseCategoryName',
		CategorizationHierarchyInWarehouse.LatestGLMinorCategoryName AS 'MinorExpenseCategoryName',
		ActivityType.BusinessLineName AS BusinessLine,
		ActivityType.ActivityTypeName AS ActivityType,
		PropertyFund.PropertyFundName AS ReportingEntityName,
		PropertyFund.PropertyFundType AS ReportingEntityType,
		AllocationRegion.LatestAllocationSubRegionName AS AllocationSubRegionName,
		ConsolidationRegion.LatestAllocationSubRegionName as ConsolidationSubRegionName,
		OriginatingRegion.LatestOriginatingSubRegionName as OriginatingSubRegionName,
		#ProfitabilityReport.GlAccountCode AS GlobalGlAccountCode,
		#ProfitabilityReport.GlAccountName AS GlobalGlAccountName,    
		Reimbursable.ReimbursableName,
		FeeAdjustment.FeeAdjustmentCode,
		#ProfitabilityReport.SourceName,
		#ProfitabilityReport.GLCategorizationHierarchyKey,

		#ProfitabilityReport.CalendarPeriod AS ActualsExpensePeriod,
		#ProfitabilityReport.EntryDate,
		#ProfitabilityReport.[User],
		#ProfitabilityReport.[Description],
		#ProfitabilityReport.AdditionalDescription,
		#ProfitabilityReport.PropertyFundCode,
		#ProfitabilityReport.FunctionalDepartmentCode,
		#ProfitabilityReport.OriginatingRegionCode,

		--Gross
		--Month to date
		SUM(ISNULL(#ProfitabilityReport.MtdActual, 0)) AS MtdActual,
		SUM(ISNULL(#ProfitabilityReport.MtdBudget, 0)) AS MtdOriginalBudget,

		SUM(ISNULL(#ProfitabilityReport.MtdReforecastQ1, 0))AS MtdReforecastQ1,
		SUM(ISNULL(#ProfitabilityReport.MtdReforecastQ2, 0))AS MtdReforecastQ2,
		SUM(ISNULL(#ProfitabilityReport.MtdReforecastQ3, 0))AS MtdReforecastQ3,

		/* Enhanced case statement: IMS 58120 */

		CASE WHEN #ProfitabilityReport.InflowOutflow = @InflowOutflowExpense AND NOT (Reimbursable.ReimbursableName = 'Reimbursable' AND (#ProfitabilityReport.GLFinancialCategoryName = 'Payroll' OR #ProfitabilityReport.GLFinancialCategoryName = 'Overhead')) THEN SUM(ISNULL(MtdBudget, 0)) - SUM(ISNULL(MtdActual, 0)) ELSE SUM(ISNULL(#ProfitabilityReport.MtdActual, 0)) - SUM(ISNULL(MtdBudget, 0)) END AS MtdVarianceQ0,
		CASE WHEN #ProfitabilityReport.InflowOutflow = @InflowOutflowExpense AND NOT ( Reimbursable.ReimbursableName = 'Reimbursable' AND (#ProfitabilityReport.GLFinancialCategoryName = 'Payroll' OR #ProfitabilityReport.GLFinancialCategoryName = 'Overhead') ) THEN SUM(ISNULL(#ProfitabilityReport.MtdReforecastQ1, 0)) - SUM(ISNULL(MtdActual, 0)) ELSE SUM(ISNULL(MtdActual, 0)) - SUM(ISNULL(#ProfitabilityReport.MtdReforecastQ1, 0)) END AS MtdVarianceQ1,
		CASE WHEN #ProfitabilityReport.InflowOutflow = @InflowOutflowExpense AND NOT ( Reimbursable.ReimbursableName = 'Reimbursable' AND (#ProfitabilityReport.GLFinancialCategoryName = 'Payroll' OR #ProfitabilityReport.GLFinancialCategoryName = 'Overhead') ) THEN SUM(ISNULL(#ProfitabilityReport.MtdReforecastQ2, 0)) - SUM(ISNULL(MtdActual, 0)) ELSE SUM(ISNULL(MtdActual, 0)) - SUM(ISNULL(#ProfitabilityReport.MtdReforecastQ2, 0)) END AS MtdVarianceQ2,
		CASE WHEN #ProfitabilityReport.InflowOutflow = @InflowOutflowExpense AND NOT ( Reimbursable.ReimbursableName = 'Reimbursable' AND (#ProfitabilityReport.GLFinancialCategoryName = 'Payroll' OR #ProfitabilityReport.GLFinancialCategoryName = 'Overhead') ) THEN SUM(ISNULL(#ProfitabilityReport.MtdReforecastQ3, 0)) - SUM(ISNULL(MtdActual, 0)) ELSE SUM(ISNULL(MtdActual, 0)) - SUM(ISNULL(#ProfitabilityReport.MtdReforecastQ3, 0)) END AS MtdVarianceQ3,

		--Year to date
		SUM(ISNULL(#ProfitabilityReport.YtdActual, 0)) AS YtdActual,
		SUM(ISNULL(#ProfitabilityReport.YtdBudget, 0)) AS YtdOriginalBudget,

		SUM(ISNULL(#ProfitabilityReport.YtdReforecastQ1, 0)) AS YtdReforecastQ1,
		SUM(ISNULL(#ProfitabilityReport.YtdReforecastQ2, 0)) YtdReforecastQ2,
		SUM(ISNULL(#ProfitabilityReport.YtdReforecastQ3, 0)) YtdReforecastQ3,

		/* Enhanced case statement: IMS 58120 */

		CASE WHEN #ProfitabilityReport.InflowOutflow = @InflowOutflowExpense AND NOT ( Reimbursable.ReimbursableName = 'Reimbursable' AND (#ProfitabilityReport.GLFinancialCategoryName = 'Payroll' OR #ProfitabilityReport.GLFinancialCategoryName = 'Overhead') ) THEN SUM(ISNULL(YtdBudget, 0)) - SUM(ISNULL(YtdActual, 0)) ELSE SUM(ISNULL(#ProfitabilityReport.YtdActual, 0)) - SUM(ISNULL(YtdBudget, 0)) END AS YtdVarianceQ0,
		CASE WHEN #ProfitabilityReport.InflowOutflow = @InflowOutflowExpense AND NOT ( Reimbursable.ReimbursableName = 'Reimbursable' AND (#ProfitabilityReport.GLFinancialCategoryName = 'Payroll' OR #ProfitabilityReport.GLFinancialCategoryName = 'Overhead') ) THEN SUM(ISNULL(#ProfitabilityReport.YtdReforecastQ1, 0)) - SUM(ISNULL(YtdActual, 0)) ELSE SUM(ISNULL(YtdActual, 0)) - SUM(ISNULL(#ProfitabilityReport.YtdReforecastQ1, 0)) END AS YtdVarianceQ1,
		CASE WHEN #ProfitabilityReport.InflowOutflow = @InflowOutflowExpense AND NOT ( Reimbursable.ReimbursableName = 'Reimbursable' AND (#ProfitabilityReport.GLFinancialCategoryName = 'Payroll' OR #ProfitabilityReport.GLFinancialCategoryName = 'Overhead') ) THEN SUM(ISNULL(#ProfitabilityReport.YtdReforecastQ2, 0)) - SUM(ISNULL(YtdActual, 0)) ELSE SUM(ISNULL(YtdActual, 0)) - SUM(ISNULL(#ProfitabilityReport.YtdReforecastQ2, 0)) END AS YtdVarianceQ2,
		CASE WHEN #ProfitabilityReport.InflowOutflow = @InflowOutflowExpense AND NOT ( Reimbursable.ReimbursableName = 'Reimbursable' AND (#ProfitabilityReport.GLFinancialCategoryName = 'Payroll' OR #ProfitabilityReport.GLFinancialCategoryName = 'Overhead') ) THEN SUM(ISNULL(#ProfitabilityReport.YtdReforecastQ3, 0)) - SUM(ISNULL(YtdActual, 0)) ELSE SUM(ISNULL(YtdActual, 0)) - SUM(ISNULL(#ProfitabilityReport.YtdReforecastQ3, 0)) END AS YtdVarianceQ3,

		--Annual
		SUM(ISNULL(#ProfitabilityReport.AnnualBudget, 0)) AS AnnualOriginalBudget,
		SUM(ISNULL(#ProfitabilityReport.AnnualReforecastQ1, 0)) AS AnnualReforecastQ1,
		SUM(ISNULL(#ProfitabilityReport.AnnualReforecastQ2, 0)) AS AnnualReforecastQ2,
		SUM(ISNULL(#ProfitabilityReport.AnnualReforecastQ3, 0)) AS AnnualReforecastQ3
	INTO
		[#Output]
	FROM
		#ProfitabilityReport

		INNER JOIN dbo.Overhead oh ON
			oh.OverheadKey = #ProfitabilityReport.OverheadKey

		INNER JOIN dbo.Reimbursable ON
			#ProfitabilityReport.ReimbursableKey = Reimbursable.ReimbursableKey

		INNER JOIN dbo.[Source] ON
			[Source].SourceKey = #ProfitabilityReport.SourceKey

		INNER JOIN dbo.GLCategorizationHierarchyLatestState CategorizationHierarchyInWarehouse ON
			#ProfitabilityReport.GLCategorizationHierarchyKey = CategorizationHierarchyInWarehouse.GLCategorizationHierarchyKey

		INNER JOIN dbo.OriginatingRegionLatestState OriginatingRegion ON
			OriginatingRegion.OriginatingRegionKey = #ProfitabilityReport.OriginatingRegionKey

		INNER JOIN dbo.AllocationRegionLatestState ConsolidationRegion ON
			ConsolidationRegion.AllocationRegionKey = #ProfitabilityReport.ConsolidationRegionKey

		INNER JOIN dbo.AllocationRegionLatestState AllocationRegion ON
			 AllocationRegion.AllocationRegionKey = #ProfitabilityReport.AllocationRegionKey

		INNER JOIN dbo.ActivityType ON
			ActivityType.ActivityTypeKey = #ProfitabilityReport.ActivityTypeKey

		INNER JOIN #EntityFilterTable PropertyFund ON
			PropertyFund.PropertyFundKey = #ProfitabilityReport.PropertyFundKey

		INNER JOIN dbo.FeeAdjustment ON
			FeeAdjustment.FeeAdjustmentKey = #ProfitabilityReport.FeeAdjustmentKey
	GROUP BY
		#ProfitabilityReport.GLFinancialCategoryName, 
		#ProfitabilityReport.InflowOutflow,
		CategorizationHierarchyInWarehouse.LatestGLMajorCategoryName,
		CategorizationHierarchyInWarehouse.LatestGLMinorCategoryName,
		ActivityType.BusinessLineName,
		ActivityType.ActivityTypeName,
		PropertyFund.PropertyFundName,		
		PropertyFund.PropertyFundType,
		AllocationRegion.LatestAllocationSubRegionName,
		ConsolidationRegion.LatestAllocationSubRegionName,
		OriginatingRegion.LatestOriginatingSubRegionName,
		#ProfitabilityReport.GlAccountCode,
		#ProfitabilityReport.GlAccountName,    
		Reimbursable.ReimbursableName,
		FeeAdjustment.FeeAdjustmentCode,
		#ProfitabilityReport.SourceName,
		#ProfitabilityReport.GLCategorizationHierarchyKey,
		#ProfitabilityReport.CalendarPeriod,
		#ProfitabilityReport.EntryDate,
		#ProfitabilityReport.[User],
		#ProfitabilityReport.[Description],
		#ProfitabilityReport.AdditionalDescription,
		#ProfitabilityReport.PropertyFundCode,
		#ProfitabilityReport.FunctionalDepartmentCode,
		#ProfitabilityReport.OriginatingRegionCode

END

/* ==============================================================================================================================================
	Return Results
   =========================================================================================================================================== */
BEGIN

	SELECT
		ExpenseType, 
		InflowOutflow,
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
		GLCategorizationHierarchyKey,

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

END

/* ==============================================================================================================================================
	Clean Up
   =========================================================================================================================================== */
BEGIN

	IF 	OBJECT_ID('tempdb..#ProfitabilityReport') IS NOT NULL
		DROP TABLE #ProfitabilityReport

	IF 	OBJECT_ID('tempdb..#OverheadFilterTable') IS NOT NULL
		DROP TABLE #OverheadFilterTable

	IF 	OBJECT_ID('tempdb..#AllocationSubRegionFilterTable') IS NOT NULL
		DROP TABLE #AllocationSubRegionFilterTable

	IF 	OBJECT_ID('tempdb..#CategorizationHierarchyFilterTable') IS NOT NULL
		DROP TABLE #CategorizationHierarchyFilterTable

	IF 	OBJECT_ID('tempdb..#ActivityTypeFilterTable') IS NOT NULL
		DROP TABLE #ActivityTypeFilterTable

	IF 	OBJECT_ID('tempdb..#EntityFilterTable') IS NOT NULL
		DROP TABLE #EntityFilterTable

	IF 	OBJECT_ID('tempdb..#OriginatingSubRegionFilterTable') IS NOT NULL
		DROP TABLE #OriginatingSubRegionFilterTable

	IF 	OBJECT_ID('tempdb..#ExchangeRate') IS NOT NULL
		DROP TABLE #ExchangeRate

	IF 	OBJECT_ID('tempdb..#Output') IS NOT NULL
		DROP TABLE #Output

	IF 	OBJECT_ID('tempdb..#FeeAdjustmentFilterTable') IS NOT NULL
		DROP TABLE #FeeAdjustmentFilterTable

END



GO


