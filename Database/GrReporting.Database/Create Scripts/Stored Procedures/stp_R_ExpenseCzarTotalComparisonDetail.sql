USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzarTotalComparisonDetail]    Script Date: 01/23/2012 15:49:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzarTotalComparisonDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ExpenseCzarTotalComparisonDetail]
GO

USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzarTotalComparisonDetail]    Script Date: 01/23/2012 15:49:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[stp_R_ExpenseCzarTotalComparisonDetail]
	@ReportExpensePeriod INT,
	@ReforecastQuarterName VARCHAR(2), --'Q0' or 'Q1' or 'Q2' or 'Q3'
	@DestinationCurrency VARCHAR(3),
	@EntityList TEXT,
	@DontSensitizeMRIPayrollData BIT = 1,
	@FunctionalDepartmentList TEXT,
	@AllocationSubRegionList TEXT,
	@HierarchyReportParameter dbo.ReportParameterGLCategorizationHierarchyDetail READONLY
AS

DECLARE
	@_ReforecastQuarterName       VARCHAR(2) = @ReforecastQuarterName,
	@_DestinationCurrency         VARCHAR(3) = @DestinationCurrency,
	@_EntityList                VARCHAR(MAX) = @EntityList,
	@_FunctionalDepartmentList VARCHAR (MAX) = @FunctionalDepartmentList,
	@_DontSensitizeMRIPayrollData        BIT = @DontSensitizeMRIPayrollData,
	@_AllocationSubRegionList   VARCHAR(MAX) = @AllocationSubRegionList,
	@ReportExpensePeriodParameter        INT = @ReportExpensePeriod

/* ==============================================================================================================================================
	Setup Variables
   =========================================================================================================================================== */	
BEGIN

	DECLARE @CalculationMethod VARCHAR(50) = 'USD'
	DECLARE @CalendarYear SMALLINT = CONVERT(SMALLINT, (SUBSTRING(CAST(@ReportExpensePeriodParameter AS VARCHAR(10)), 1, 4)))	

	DECLARE @ActiveReforecastKey INT =
		(
			SELECT
				ReforecastKey
			FROM 
				dbo.GetReforecastRecord(@ReportExpensePeriodParameter, @ReforecastQuarterName)
		)

	---- Calculate reforecast effective period from reforecast name
	DECLARE @ReforecastEffectivePeriod INT =
		(
			SELECT TOP 1
				ReforecastEffectivePeriod
			FROM
				dbo.Reforecast
			WHERE
				ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriodParameter AS VARCHAR(6)),4) AND
				ReforecastQuarterName = @ReforecastQuarterName
			ORDER BY
				ReforecastEffectivePeriod
		)

END
	
/* ======================================================================================================================================
	Mapping Tables
========================================================================================================================================= */	
BEGIN

	----------------------------------------------------------------------------
	-- Functional Departments
	----------------------------------------------------------------------------

	CREATE TABLE #FunctionalDepartmentFilterTable 
	(
		FunctionalDepartmentKey INT NOT NULL,
		FunctionalDepartmentName VARCHAR(MAX) NOT NULL,
		SubFunctionalDepartmentName VARCHAR(MAX) NOT NULL
	)

	IF (@_FunctionalDepartmentList IS NOT NULL)
	BEGIN	

		IF (@_FunctionalDepartmentList <> 'All')
		BEGIN

			INSERT INTO #FunctionalDepartmentFilterTable
			SELECT DISTINCT
				FunctionalDepartmentLatestState.FunctionalDepartmentKey,
				FunctionalDepartmentLatestState.LatestFunctionalDepartmentName,
				FunctionalDepartmentLatestState.LatestSubFunctionalDepartmentName
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
				FunctionalDepartmentLatestState.LatestFunctionalDepartmentName,
				FunctionalDepartmentLatestState.LatestSubFunctionalDepartmentName
			FROM 
				dbo.FunctionalDepartmentLatestState

		END

	END

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
	
	----------------------------------------------------------------------------
	-- Exchange Rate
	----------------------------------------------------------------------------

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

	CREATE INDEX IX_SourceCurrencyKey ON #ExchangeRate (SourceCurrencyKey)
	CREATE INDEX IX_CalendarKey ON #ExchangeRate (CalendarKey)

	----------------------------------------------------------------------------
	-- Reporting Entity / Property Fund
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
	-- GL Categorization Hierarchy
	----------------------------------------------------------------------------

	CREATE TABLE #CategorizationHierarchyFilterTable
	(
		CategorizationHierarchyKey INT NOT NULL,
		GLCategorizationName VARCHAR(50) NOT NULL,
		GLFinancialCategoryName VARCHAR(50) NOT NULL,
		GLMajorCategoryName VARCHAR(400) NOT NULL,
		GLMinorCategoryName VARCHAR(400) NOT NULL,
		GLAccountCode VARCHAR(15) NOT NULL,
		GLAccountName VARCHAR(300) NOT NULL,
		ActivityTypeId INT NOT NULL,
		ActivityTypeKey INT NOT NULL
	)

	INSERT INTO #CategorizationHierarchyFilterTable
	SELECT DISTINCT
		GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey,
		GLCategorizationHierarchyLatestState.LatestGLCategorizationName,
		GLCategorizationHierarchyLatestState.LatestGLFinancialCategoryName,
		GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName,
		GLCategorizationHierarchyLatestState.LatestGLMinorCategoryName,
		GLCategorizationHierarchyLatestState.LatestGLAccountCode,
		GLCategorizationHierarchyLatestState.LatestGlAccountName,
		HierarchyReportParameter.ActivityTypeId,
		ActivityType.ActivityTypeKey
	FROM 
		@HierarchyReportParameter HierarchyReportParameter

		INNER JOIN dbo.ActivityType ON
			HierarchyReportParameter.ActivityTypeId = 0 OR
			HierarchyReportParameter.ActivityTypeId = ActivityType.ActivityTypeId 
		
		INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
			(
				HierarchyReportParameter.FinancialCategoryName = 'All' OR
				HierarchyReportParameter.FinancialCategoryName = GLCategorizationHierarchyLatestState.LatestGLFinancialCategoryName
			) 
			AND
			(
				HierarchyReportParameter.GLMajorCategoryName = 'All' OR
				HierarchyReportParameter.GLMajorCategoryName = GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName
			) 
			AND
			(
				HierarchyReportParameter.GLMinorCategoryName = 'All' OR
				HierarchyReportParameter.GLMinorCategoryName = GLCategorizationHierarchyLatestState.LatestGLMinorCategoryName
			) 
	WHERE -- IMS 51655
		GLCategorizationHierarchyLatestState.LatestGLMinorCategoryName <> 'Architects & Engineering' AND	
		GLCategorizationHierarchyLatestState.LatestInflowOutflow = 'Outflow'

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #CategorizationHierarchyFilterTable (CategorizationHierarchyKey, ActivityTypeKey)

END

/* =============================================================================================================================================
	Create temporary table into which data for this report will be inserted
   =========================================================================================================================================== */	
BEGIN

	CREATE TABLE #ExpenseCzarTotalComparisonDetail
	(	
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
		PropertyFundCode				VARCHAR(11) DEFAULT(''),
		OriginatingRegionCode			VARCHAR(30) DEFAULT(''),
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
	CREATE INDEX IX_AllocationRegionKey ON #ExpenseCzarTotalComparisonDetail (AllocationRegionKey)
	CREATE INDEX IX_OriginatingRegionKey ON #ExpenseCzarTotalComparisonDetail (OriginatingRegionKey)
	CREATE INDEX IX_PropertyFundKey ON #ExpenseCzarTotalComparisonDetail (PropertyFundKey)
	CREATE INDEX IX_FunctionalDepartmentKey ON #ExpenseCzarTotalComparisonDetail (FunctionalDepartmentKey)
	CREATE INDEX IX_GLCategorizationHierarchyKey ON #ExpenseCzarTotalComparisonDetail (GLCategorizationHierarchyKey)

END

/* ======================================================================================================================================
	Add Actuals
========================================================================================================================================= */	
BEGIN

	INSERT INTO #ExpenseCzarTotalComparisonDetail
	(
		GLCategorizationHierarchyKey,
		AllocationRegionKey,
		OriginatingRegionKey,
		FunctionalDepartmentKey,
		PropertyFundKey,
		SourceName,
		EntryDate,
		[User],
		[Description],
		AdditionalDescription,
		PropertyFundCode,
		OriginatingRegionCode,
		FunctionalDepartmentCode,
		GlAccountCode,
		GlAccountName,
		CalendarPeriod,
		
		--Month to date	
		MtdGrossActual,
		MtdGrossBudget,
		MtdGrossReforecast,
		MtdNetActual,
		MtdNetBudget,
		MtdNetReforecast,
		
		--Year to date
		YtdGrossActual,
		YtdGrossBudget, 
		YtdGrossReforecast,
		YtdNetActual, 
		YtdNetBudget,
		YtdNetReforecast,

		--Annual	
		AnnualGrossBudget,
		AnnualGrossReforecast,
		AnnualNetBudget,
		AnnualNetReforecast,
		
		--Annual estimated
		AnnualEstGrossBudget,
		AnnualEstGrossReforecast,
		AnnualEstNetBudget,
		AnnualEstNetReforecast		

	)
	SELECT --TOP 0
		ProfitabilityActual.GlobalGLCategorizationHierarchyKey AS 'GLCategorizationHierarchyKey',
		ProfitabilityActual.AllocationRegionKey,
		ProfitabilityActual.OriginatingRegionKey,
		ProfitabilityActual.FunctionalDepartmentKey,
		ProfitabilityActual.PropertyFundKey,	
		CASE
			WHEN
				@DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.LatestGLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'
			ELSE
				[Source].SourceName
		END AS 'SourceName',
		CONVERT(VARCHAR(10), ISNULL(ProfitabilityActual.LastDate, ''), 101) AS 'EntryDate',
		ProfitabilityActual.[User],
		ProfitabilityActual.[Description],
		ProfitabilityActual.AdditionalDescription,
		CASE
			WHEN
				@DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.LatestGLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'
			ELSE
				ProfitabilityActual.PropertyFundCode
		END AS 'PropertyFundCode',
		CASE
			WHEN
				@DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.LatestGLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'
			ELSE
				ProfitabilityActual.OriginatingRegionCode
		END AS 'OriginatingRegionCode',
		ProfitabilityActual.FunctionalDepartmentCode,
		GlobalGLCategorizationHierarchy.LatestGlAccountCode,
		GlobalGLCategorizationHierarchy.LatestGlAccountName,
		Calendar.CalendarPeriod,

		-- MTD Gross
		SUM
		(
			#ExchangeRate.Rate *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod = @ReportExpensePeriodParameter
					THEN
						ProfitabilityActual.LocalActual
					ELSE
						0.0
				END
			)
		) AS 'MtdGrossActual',
		NULL AS 'MtdGrossBudget',
		NULL AS 'MtdGrossReforecast',

		-- MTD Net
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod = @ReportExpensePeriodParameter
					THEN
						ProfitabilityActual.LocalActual
					ELSE
						0.0
				END
			)
		) AS 'MtdNetActual',
		NULL AS 'MtdNetBudget',
		NULL AS 'MtdNetReforecast',

		SUM
		(
			#ExchangeRate.Rate *
			(
				CASE 
					WHEN
						Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
					THEN
						ProfitabilityActual.LocalActual
					ELSE
						0.0
				END
			)
		) AS 'YtdGrossActual',
		NULL AS 'YtdGrossBudget',
		NULL AS 'YtdGrossReforecast',

		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
					THEN
						ProfitabilityActual.LocalActual
					ELSE
						0.0
				END
			)
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
			(
				CASE
					WHEN
						Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
					THEN
						ProfitabilityActual.LocalActual
					ELSE
						0.0
				END
			)
		) AS 'AnnualEstGrossBudget',
		NULL AS 'AnnualEstGrossReforecast',
		NULL AS 'AnnualEstNetBudget',
		NULL AS 'AnnualEstNetReforecast'
	FROM
		dbo.ProfitabilityActual

		INNER JOIN #EntityFilterTable ON
			ProfitabilityActual.PropertyFundKey = #EntityFilterTable.PropertyFundKey

		INNER JOIN GLCategorizationHierarchyLatestState GlobalGLCategorizationHierarchy ON 
			GlobalGLCategorizationHierarchy.GLCategorizationHierarchyKey = ProfitabilityActual.GlobalGLCategorizationHierarchyKey 	

		INNER JOIN #CategorizationHierarchyFilterTable GlHierarchy ON 
			GlHierarchy.CategorizationHierarchyKey = ProfitabilityActual.GlobalGLCategorizationHierarchyKey AND
			(GlHierarchy.ActivityTypeKey = ProfitabilityActual.ActivityTypeKey)

		INNER JOIN #AllocationSubRegionFilterTable ON
			ProfitabilityActual.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey			

		INNER JOIN #FunctionalDepartmentFilterTable ON
			ProfitabilityActual.FunctionalDepartmentKey = #FunctionalDepartmentFilterTable.FunctionalDepartmentKey

		INNER JOIN dbo.[Source] ON
			ProfitabilityActual.SourceKey = Source.SourceKey

		INNER JOIN dbo.Reimbursable ON
			ProfitabilityActual.ReimbursableKey = Reimbursable.ReimbursableKey

		INNER JOIN dbo.Overhead ON
			ProfitabilityActual.OverheadKey = Overhead.OverheadKey

		INNER JOIN dbo.Calendar ON
			ProfitabilityActual.CalendarKey = Calendar.CalendarKey

		INNER JOIN #ExchangeRate ON
			ProfitabilityActual.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
			ProfitabilityActual.CalendarKey = #ExchangeRate.CalendarKey

		INNER JOIN dbo.Currency ON
			#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey
	WHERE
		GlobalGLCategorizationHierarchy.LatestInflowOutflow IN
		(
			'Outflow',
			'UNKNOWN'
		) AND
		Calendar.CalendarYear = @CalendarYear AND
		Currency.CurrencyCode = @_DestinationCurrency
	GROUP BY
		ProfitabilityActual.GlobalGLCategorizationHierarchyKey,
		ProfitabilityActual.AllocationRegionKey,
		ProfitabilityActual.OriginatingRegionKey,
		ProfitabilityActual.FunctionalDepartmentKey,
		ProfitabilityActual.PropertyFundKey,
		Calendar.CalendarPeriod,
		CASE
			WHEN
				@DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.LatestGLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'	
			ELSE
				[Source].SourceName
		END,
		CONVERT(VARCHAR(10), ISNULL(ProfitabilityActual.LastDate,''), 101),
		ProfitabilityActual.[User],
		ProfitabilityActual.[Description],
		ProfitabilityActual.AdditionalDescription,
		CASE
			WHEN
				@DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.LatestGLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'
			ELSE
				ProfitabilityActual.PropertyFundCode
		END,
		CASE
			WHEN
				@DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.LatestGLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'
			ELSE
				ProfitabilityActual.OriginatingRegionCode
		END,
		ProfitabilityActual.FunctionalDepartmentCode,
		GlobalGLCategorizationHierarchy.LatestGlAccountCode,
		GlobalGLCategorizationHierarchy.LatestGlAccountName

END

/* ======================================================================================================================================
	Add Budgets
========================================================================================================================================= */	
BEGIN

	INSERT INTO #ExpenseCzarTotalComparisonDetail
	(
		GLCategorizationHierarchyKey,
		AllocationRegionKey,
		OriginatingRegionKey,
		FunctionalDepartmentKey,
		PropertyFundKey,
		SourceName,
		EntryDate,
		[User],
		[Description],
		AdditionalDescription,
		PropertyFundCode,
		OriginatingRegionCode,
		FunctionalDepartmentCode,
		GlAccountCode,
		GlAccountName,
		CalendarPeriod,

		-- MTD Gross
		MtdGrossActual,
		MtdGrossBudget,
		MtdGrossReforecast,

		-- MTD Net
		MtdNetActual,
		MtdNetBudget,
		MtdNetReforecast,

		-- YTD Gross
		YtdGrossActual,
		YtdGrossBudget, 
		YtdGrossReforecast,

		-- YTD Net
		YtdNetActual, 
		YtdNetBudget,
		YtdNetReforecast,

		-- Annual Gross
		AnnualGrossBudget,
		AnnualGrossReforecast,

		-- Annual Net
		AnnualNetBudget,
		AnnualNetReforecast,

		-- Annual Estimated Gross
		AnnualEstGrossBudget,
		AnnualEstGrossReforecast,

		-- Annual Estimated Net
		AnnualEstNetBudget,
		AnnualEstNetReforecast
	)
	SELECT
		ProfitabilityBudget.GlobalGLCategorizationHierarchyKey AS 'GLCategorizationHierarchyKey',
		ProfitabilityBudget.AllocationRegionKey,
		ProfitabilityBudget.OriginatingRegionKey,
		ProfitabilityBudget.FunctionalDepartmentKey,
		ProfitabilityBudget.PropertyFundKey,	
		CASE
			WHEN
				@DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.LatestGLMajorCategoryName = 'Salaries/Taxes/Benefits'
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
		GlHierarchy.GlAccountCode,
		GlHierarchy.GlAccountName,
		Calendar.CalendarPeriod,

		-- Gross MTD Actuals
		NULL AS 'MtdGrossActual',
		SUM
		(
			#ExchangeRate.Rate *
			(
				CASE 
					WHEN
						Calendar.CalendarPeriod = @ReportExpensePeriodParameter
					THEN
						ProfitabilityBudget.LocalBudget
					ELSE
						0.0
				END
			)
		) AS 'MtdGrossBudget',
		NULL AS 'MtdGrossReforecast',

		-- MTD Net Actuals
		NULL AS 'MtdNetActual',
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod = @ReportExpensePeriodParameter
					THEN
						ProfitabilityBudget.LocalBudget
					ELSE
						0.0
				END
			)
		) AS 'MtdNetBudget',
		NULL AS 'MtdNetReforecast',
		
		-- YTD Gross
		NULL AS 'YtdGrossActual',
		SUM
		(
			#ExchangeRate.Rate *
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
		) AS 'YtdGrossBudget',
		NULL AS 'YtdGrossReforecast',

		-- YTD Net
		NULL AS 'YtdNetActual',
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
					THEN
						ProfitabilityBudget.LocalBudget
					ELSE
						0.0
				END
			)
		) AS 'YtdNetBudget',
		NULL AS 'YtdNetReforecast',

		-- Annual
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
		NULL AS 'AnnualNetReforecast',
		
		--Annual estimated
		SUM
		(
			#ExchangeRate.Rate *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
					THEN
						ProfitabilityBudget.LocalBudget
					ELSE
						0.0
			END
			)
		) AS 'AnnualEstGrossBudget',		
		NULL AS 'AnnualEstGrossReforecast',	
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			(
				CASE
					WHEN
						Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
					THEN
						ProfitabilityBudget.LocalBudget
					ELSE
						0.0
				END
			)
		) AS 'AnnualEstNetBudget',
		NULL AS 'AnnualEstNetReforecast'
	FROM
		dbo.ProfitabilityBudget

		INNER JOIN #EntityFilterTable ON
			ProfitabilityBudget.PropertyFundKey = #EntityFilterTable.PropertyFundKey

		INNER JOIN dbo.GLCategorizationHierarchyLatestState GlobalGLCategorizationHierarchy ON 
			GlobalGLCategorizationHierarchy.GLCategorizationHierarchyKey = ProfitabilityBudget.GlobalGLCategorizationHierarchyKey

		INNER JOIN #CategorizationHierarchyFilterTable GlHierarchy ON 
			GlHierarchy.CategorizationHierarchyKey = ProfitabilityBudget.GlobalGLCategorizationHierarchyKey AND
			(GlHierarchy.ActivityTypeKey = ProfitabilityBudget.ActivityTypeKey)

		INNER JOIN #AllocationSubRegionFilterTable ON
			ProfitabilityBudget.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey			

		INNER JOIN #FunctionalDepartmentFilterTable ON
			ProfitabilityBudget.FunctionalDepartmentKey = #FunctionalDepartmentFilterTable.FunctionalDepartmentKey

		INNER JOIN dbo.[Source] ON
			ProfitabilityBudget.SourceKey = Source.SourceKey

		INNER JOIN dbo.Reimbursable ON
			ProfitabilityBudget.ReimbursableKey = Reimbursable.ReimbursableKey

		INNER JOIN dbo.Calendar ON
			ProfitabilityBudget.CalendarKey = Calendar.CalendarKey

		INNER JOIN #ExchangeRate ON
			ProfitabilityBudget.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
			ProfitabilityBudget.CalendarKey = #ExchangeRate.CalendarKey

		INNER JOIN dbo.Currency ON
			#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey

		INNER JOIN dbo.Overhead ON
			ProfitabilityBudget.OverheadKey = Overhead.OverheadKey		
	WHERE 
		GlobalGLCategorizationHierarchy.LatestInflowOutflow IN
		(
				'Outflow', 
				'UNKNOWN'
		) AND
		Calendar.CalendarYear = @CalendarYear AND
		Currency.CurrencyCode = @_DestinationCurrency	
	GROUP BY
		ProfitabilityBudget.GlobalGLCategorizationHierarchyKey,
		ProfitabilityBudget.AllocationRegionKey,
		ProfitabilityBudget.OriginatingRegionKey,
		ProfitabilityBudget.FunctionalDepartmentKey,
		ProfitabilityBudget.PropertyFundKey,
		Calendar.CalendarPeriod,
		CASE
			WHEN
				@DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.LatestGLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN 
				'Sensitized'
			ELSE
				[Source].SourceName
		END,
		GlHierarchy.GlAccountCode,
		GlHierarchy.GlAccountName

END

/* ======================================================================================================================================
	Add Reforecasts
========================================================================================================================================= */	
BEGIN

	IF @ReforecastQuarterName IN ('Q1', 'Q2', 'Q3')
	BEGIN
		INSERT INTO #ExpenseCzarTotalComparisonDetail
		(
			GLCategorizationHierarchyKey,
			AllocationRegionKey,
			OriginatingRegionKey,
			FunctionalDepartmentKey,
			PropertyFundKey,
			SourceName,
			EntryDate,
			[User],
			[Description],
			AdditionalDescription,
			PropertyFundCode,
			OriginatingRegionCode,
			FunctionalDepartmentCode,
			GlAccountCode,
			GlAccountName,
			CalendarPeriod,

			--Month to date	
			MtdGrossActual,
			MtdGrossBudget,
			MtdGrossReforecast,

			MtdNetActual,
			MtdNetBudget,
			MtdNetReforecast,

			--Year to date
			YtdGrossActual,
			YtdGrossBudget,
			YtdGrossReforecast,

			YtdNetActual,
			YtdNetBudget,
			YtdNetReforecast,

			--Annual
			AnnualGrossBudget,
			AnnualGrossReforecast,
			AnnualNetBudget,
			AnnualNetReforecast,
			
			--Annual estimated
			AnnualEstGrossBudget,
			AnnualEstGrossReforecast,
			AnnualEstNetBudget,
			AnnualEstNetReforecast
		)
		SELECT
			ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey AS 'GLCategorizationHierarchyKey',
			ProfitabilityReforecast.AllocationRegionKey,
			ProfitabilityReforecast.OriginatingRegionKey,
			ProfitabilityReforecast.FunctionalDepartmentKey,
			ProfitabilityReforecast.PropertyFundKey,
			CASE
				WHEN
					@DontSensitizeMRIPayrollData = 0 AND GlHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
				THEN
					'Sensitized'
				ELSE
					[Source].SourceName
			END AS 'SourceName',
			'' AS 'EntryDate',
			'' AS 'User',
			'' AS 'Description',
			'' as 'AdditionalDescription',
			'' AS 'PropertyFundCode',
			'' AS 'OriginatingRegionCode',
			'' AS 'FunctionalDepartmentCode',
			GlHierarchy.GlAccountCode,
			GlHierarchy.GlAccountName,
			Calendar.CalendarPeriod,

			-- MTD Gross
			NULL AS 'MtdGrossActual',
			NULL AS 'MtdGrossBudget',
			SUM
			(
				#ExchangeRate.Rate *
				(
					CASE
						WHEN
							Calendar.CalendarPeriod = @ReportExpensePeriodParameter
						THEN
							ProfitabilityReforecast.LocalReforecast
						ELSE
							0.0
					END
				)
			) AS 'MtdGrossReforecast',		

			-- MTD Net		
			NULL AS 'MtdNetActual',
			NULL AS 'MtdNetBudget',		
			SUM
			(
				#ExchangeRate.Rate *
				Reimbursable.MultiplicationFactor *
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
			) AS 'MtdNetReforecast',

			-- YTD Gross
			NULL AS 'YtdGrossActual',
			NULL AS 'YtdGrossBudget',
			SUM
			(
				#ExchangeRate.Rate *
				(
					CASE
						WHEN
							Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
						THEN
							ProfitabilityReforecast.LocalReforecast
						ELSE
							0.0
					END
				)
			) AS 'YtdGrossReforecast',

			-- YTD Net
			NULL AS 'YtdNetActual', 	
			NULL AS 'YtdNetBudget',
			SUM
			(
				#ExchangeRate.Rate *
				Reimbursable.MultiplicationFactor *
				(
					CASE
						WHEN
							Calendar.CalendarPeriod <= @ReportExpensePeriodParameter
						THEN
							ProfitabilityReforecast.LocalReforecast
						ELSE
							0.0
					END
				)
			) AS 'YtdNetReforecast',

			-- Annual Gross
			NULL AS AnnualGrossBudget,
			SUM
			(
				#ExchangeRate.Rate *
				ProfitabilityReforecast.LocalReforecast
			) AS 'AnnualGrossReforecast',		

			-- Annual Net
			NULL AS AnnualNetBudget,
			SUM
			(
				#ExchangeRate.Rate *
				Reimbursable.MultiplicationFactor *
				ProfitabilityReforecast.LocalReforecast
			) AS 'AnnualNetReforecast',

			-- Annual Estimated Gross
			NULL AS 'AnnualEstGrossBudget',
			SUM
			(
				#ExchangeRate.Rate *
				(
					CASE
						WHEN
						(
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
						)
						THEN
							ProfitabilityReforecast.LocalReforecast
						ELSE
							0.0
					END
				)
			) AS 'AnnualEstGrossReforecast',

			-- Annual Estimated Gross	
			NULL AS 'AnnualEstNetBudget',
			SUM
			(
				#ExchangeRate.Rate *
				(
					CASE
						WHEN
						(
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
						)
						THEN
							ProfitabilityReforecast.LocalReforecast
						ELSE
							0.0
					END
				)
			) AS 'AnnualEstNetReforecast'
		FROM
			dbo.ProfitabilityReforecast

			INNER JOIN #EntityFilterTable ON
				ProfitabilityReforecast.PropertyFundKey = #EntityFilterTable.PropertyFundKey

			INNER JOIN dbo.GLCategorizationHierarchyLatestState GlobalGLCategorizationHierarchy ON 
				GlobalGLCategorizationHierarchy.GLCategorizationHierarchyKey = ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey

			INNER JOIN #CategorizationHierarchyFilterTable GlHierarchy ON 
				GlHierarchy.CategorizationHierarchyKey = ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey AND
				(GlHierarchy.ActivityTypeKey = ProfitabilityReforecast.ActivityTypeKey)

			INNER JOIN #AllocationSubRegionFilterTable ON
				ProfitabilityReforecast.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey

			INNER JOIN #ExchangeRate ON
				ProfitabilityReforecast.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
				ProfitabilityReforecast.CalendarKey = #ExchangeRate.CalendarKey

			INNER JOIN #FunctionalDepartmentFilterTable ON
				ProfitabilityReforecast.FunctionalDepartmentKey = #FunctionalDepartmentFilterTable.FunctionalDepartmentKey

			INNER JOIN dbo.Currency ON
				#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey

			INNER JOIN dbo.Overhead ON
				ProfitabilityReforecast.OverheadKey = Overhead.OverheadKey

			INNER JOIN dbo.Calendar ON
				ProfitabilityReforecast.CalendarKey = Calendar.CalendarKey

			INNER JOIN dbo.Reforecast ON
				ProfitabilityReforecast.ReforecastKey = Reforecast.ReforecastKey

			INNER JOIN dbo.[Source] ON
				ProfitabilityReforecast.SourceKey = [Source].SourceKey

			INNER JOIN dbo.Reimbursable ON
				ProfitabilityReforecast.ReimbursableKey = Reimbursable.ReimbursableKey
		WHERE 
			GlobalGLCategorizationHierarchy.LatestInflowOutflow IN
			(
				'Outflow',
				'UNKNOWN'
			) AND
			Reforecast.ReforecastEffectivePeriod = @ReforecastEffectivePeriod AND
			Calendar.CalendarYear = @CalendarYear AND
			Currency.CurrencyCode = @_DestinationCurrency
		GROUP BY
			GlHierarchy.GlAccountCode,
			GlHierarchy.GlAccountName,
			Calendar.CalendarPeriod,
			ProfitabilityReforecast.ActivityTypeKey,
			ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey,
			ProfitabilityReforecast.AllocationRegionKey,
			ProfitabilityReforecast.OriginatingRegionKey,
			ProfitabilityReforecast.FunctionalDepartmentKey,
			ProfitabilityReforecast.PropertyFundKey,			
			CASE
				WHEN
					@DontSensitizeMRIPayrollData = 0 AND GlHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
				THEN
					'Sensitized'
				ELSE
					[Source].SourceName
			END,
			CASE
				WHEN
					@DontSensitizeMRIPayrollData = 0 AND GlHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
				THEN
					NULL
				ELSE
					GlHierarchy.GlAccountCode
			END,
			CASE
				WHEN
					@DontSensitizeMRIPayrollData = 0 AND GlHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
				THEN
					NULL	
				ELSE
					GlHierarchy.GlAccountName
			END

	END -- END IF

END

/* ==============================================================================================================================================
	Select Output
   =========================================================================================================================================== */	

SELECT
	AllocationRegion.AllocationRegionName AS 'AllocationRegionName',
	AllocationRegion.AllocationSubRegionName AS 'AllocationSubRegionName',
	OriginatingRegion.RegionName AS 'OriginatingRegionName',
	OriginatingRegion.SubRegionName AS 'OriginatingSubRegionName',
	FunctionalDepartment.FunctionalDepartmentName AS 'FunctionalDepartmentName',
	FunctionalDepartment.SubFunctionalDepartmentName AS 'JobCode',
	GLCategorizationHierarchyLatestState.LatestGLFinancialCategoryName AS 'FinancialCategoryName',
	GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS 'MajorExpenseCategoryName',
	GLCategorizationHierarchyLatestState.LatestGLMinorCategoryName AS 'MinorExpenseCategoryName',
	PropertyFund.PropertyFundType AS 'EntityType',
	PropertyFund.PropertyFundName AS 'EntityName',
	#ExpenseCzarTotalComparisonDetail.CalendarPeriod AS 'ExpensePeriod',
	#ExpenseCzarTotalComparisonDetail.EntryDate AS 'EntryDate',
	#ExpenseCzarTotalComparisonDetail.[User] AS 'User',
	#ExpenseCzarTotalComparisonDetail.[Description] AS 'Description',
	#ExpenseCzarTotalComparisonDetail.[AdditionalDescription] AS 'AdditionalDescription',
	#ExpenseCzarTotalComparisonDetail.SourceName AS 'SourceName',
	#ExpenseCzarTotalComparisonDetail.PropertyFundCode AS 'PropertyFundCode',
	CASE 
		WHEN (SUBSTRING(#ExpenseCzarTotalComparisonDetail.SourceName, CHARINDEX(' ', #ExpenseCzarTotalComparisonDetail.SourceName) +1, 8) = 'Property') THEN RTRIM(#ExpenseCzarTotalComparisonDetail.OriginatingRegionCode) + LTRIM(#ExpenseCzarTotalComparisonDetail.FunctionalDepartmentCode) 
		ELSE #ExpenseCzarTotalComparisonDetail.OriginatingRegionCode 
	END AS 'OriginatingRegionCode',
	ISNULL (#ExpenseCzarTotalComparisonDetail.GlAccountCode, '') AS 'GlAccountCode',
	ISNULL (#ExpenseCzarTotalComparisonDetail.GlAccountName, '') AS 'GlAccountName',
			
	--Month to date    
	SUM(
		ISNULL(MtdGrossActual,0) 
		
	) AS 'MtdActual',
	SUM(
		ISNULL(MtdGrossBudget,0) 
	) AS 'MtdOriginalBudget',
	
	SUM(
			ISNULL(
					CASE 
						WHEN @ReforecastQuarterName = 'Q0' THEN MtdGrossBudget 
						ELSE MtdGrossReforecast
					END,
					0
				) 
			
		) 
	AS 'MtdReforecast',
	
	SUM(
		ISNULL(
			CASE 
				WHEN @ReforecastQuarterName = 'Q0' THEN MtdGrossBudget 
				ELSE MtdGrossReforecast
			END, 
			0
		) - ISNULL(MtdGrossActual, 0) 
	) 
	AS 'MtdVariance',
	
	--Year to date
	SUM(
		ISNULL(YtdGrossActual,0) 
		
	) AS 'YtdActual',	
	
	SUM(
			ISNULL(YtdGrossBudget,0) 
			
	) AS 'YtdOriginalBudget',
	
	SUM(
		ISNULL(
			CASE 
				WHEN @ReforecastQuarterName = 'Q0' THEN YtdGrossBudget 
				ELSE YtdGrossReforecast
			END,
			0
		) 
		
	) 
	AS 'YtdReforecast',
	
	SUM(
		ISNULL(
			CASE 
				WHEN @ReforecastQuarterName = 'Q0' THEN YtdGrossBudget 
				ELSE YtdGrossReforecast
			END, 
		0
		) - ISNULL(YtdGrossActual, 0) 			
	) 
	AS 'YtdVariance',
		
	--Annual
	SUM(
		ISNULL(AnnualGrossBudget,0) 			
	) AS 'AnnualOriginalBudget',
	
	SUM(			
		ISNULL(
			CASE 
				WHEN @ReforecastQuarterName = 'Q0' THEN 0 
				ELSE AnnualGrossReforecast
			END,
			0
		)			
	) AS 'AnnualReforecast',
	GLCategorizationHierarchyLatestState.LatestGLFinancialCategoryName AS FinancialCategory

INTO
	#Output

FROM 
	#ExpenseCzarTotalComparisonDetail 
	INNER JOIN #AllocationSubRegionFilterTable AllocationRegion ON
		#ExpenseCzarTotalComparisonDetail.AllocationRegionKey = AllocationRegion.AllocationRegionKey
		
	INNER JOIN OriginatingRegion ON
		#ExpenseCzarTotalComparisonDetail.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey
		
	INNER JOIN #EntityFilterTable PropertyFund On
		#ExpenseCzarTotalComparisonDetail.PropertyFundKey = PropertyFund.PropertyFundKey
		
	INNER JOIN #FunctionalDepartmentFilterTable FunctionalDepartment ON
		#ExpenseCzarTotalComparisonDetail.FunctionalDepartmentKey = FunctionalDepartment.FunctionalDepartmentKey
		
	INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
		#ExpenseCzarTotalComparisonDetail.GLCategorizationHierarchyKey = GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey
		
	GROUP BY
		GLCategorizationHierarchyLatestState.LatestInflowOutflow,
		AllocationRegion.AllocationRegionName,
		AllocationRegion.AllocationSubRegionName,
		OriginatingRegion.RegionName,
		OriginatingRegion.SubRegionName,
		FunctionalDepartment.FunctionalDepartmentName,
		FunctionalDepartment.SubFunctionalDepartmentName,
		GLCategorizationHierarchyLatestState.LatestGLFinancialCategoryName,
		GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName,
		GLCategorizationHierarchyLatestState.LatestGLMinorCategoryName,
		PropertyFund.PropertyFundType,
		PropertyFund.PropertyFundName,
		#ExpenseCzarTotalComparisonDetail.CalendarPeriod,
		#ExpenseCzarTotalComparisonDetail.EntryDate,
		#ExpenseCzarTotalComparisonDetail.[User],
		#ExpenseCzarTotalComparisonDetail.[Description],
		#ExpenseCzarTotalComparisonDetail.[AdditionalDescription],
		#ExpenseCzarTotalComparisonDetail.SourceName,
		#ExpenseCzarTotalComparisonDetail.PropertyFundCode,
		CASE 
			WHEN (SUBSTRING(#ExpenseCzarTotalComparisonDetail.SourceName, CHARINDEX(' ', #ExpenseCzarTotalComparisonDetail.SourceName) +1, 8) = 'Property') THEN RTRIM(#ExpenseCzarTotalComparisonDetail.OriginatingRegionCode) + LTRIM(#ExpenseCzarTotalComparisonDetail.FunctionalDepartmentCode) 
			ELSE #ExpenseCzarTotalComparisonDetail.OriginatingRegionCode 
		END,
		ISNULL (#ExpenseCzarTotalComparisonDetail.GlAccountCode, ''),
		ISNULL (#ExpenseCzarTotalComparisonDetail.GlAccountName, '')

/* ======================================================================================================================================
	SELECT FINAL OUTPUT
========================================================================================================================================= */	

	SELECT
		FinancialCategory,
		MajorExpenseCategoryName,
		MinorExpenseCategoryName,
		AllocationSubRegionName,
		AllocationSubRegionName AS AllocationSubRegionFilterName,
		OriginatingRegionName,
		OriginatingSubRegionName,
		OriginatingSubRegionName AS OriginatingRegionFilterName,
		EntityType AS 'EntityType',
		EntityName AS 'EntityName',
		EntityName AS EntityFilterName,
		FunctionalDepartmentName,
		FunctionalDepartmentName AS FunctionalDepartmentFilterName,
		ExpensePeriod AS ActualsExpensePeriod,
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
		AnnualReforecast
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

/* ======================================================================================================================================
	CleanUp
========================================================================================================================================= */	

IF 	OBJECT_ID('tempdb..#Output') IS NOT NULL
    DROP TABLE #Output

IF 	OBJECT_ID('tempdb..#ExpenseCzarTotalComparisonDetail') IS NOT NULL
    DROP TABLE #ExpenseCzarTotalComparisonDetail

IF 	OBJECT_ID('tempdb..#ExchangeRate') IS NOT NULL
    DROP TABLE #ExchangeRate

IF 	OBJECT_ID('tempdb..#EntityFilterTable') IS NOT NULL
    DROP TABLE #EntityFilterTable

IF 	OBJECT_ID('tempdb..#AllocationSubRegionFilterTable') IS NOT NULL
    DROP TABLE #AllocationSubRegionFilterTable

IF 	OBJECT_ID('tempdb..#CategorizationHierarchyFilterTable') IS NOT NULL
    DROP TABLE #CategorizationHierarchyFilterTable

IF 	OBJECT_ID('tempdb..#FunctionalDepartmentFilterTable') IS NOT NULL
    DROP TABLE #FunctionalDepartmentFilterTable




GO


