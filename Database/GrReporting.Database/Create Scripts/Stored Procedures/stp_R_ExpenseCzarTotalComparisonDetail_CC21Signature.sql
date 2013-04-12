 USE [GrReporting]
GO

USE GrReporting
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--/*

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzarTotalComparisonDetail_CC21Signature]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ExpenseCzarTotalComparisonDetail_CC21Signature]
GO

CREATE PROCEDURE [dbo].[stp_R_ExpenseCzarTotalComparisonDetail_CC21Signature]
	@ReportExpensePeriod INT = NULL,
	@ReforecastQuarterName VARCHAR(2) = NULL, --'Q0' or 'Q1' or 'Q2' or 'Q3'
	@DestinationCurrency VARCHAR(3) = NULL,
	@EntityList TEXT = NULL,
	@DontSensitizeMRIPayrollData BIT = 1,
	@FunctionalDepartmentList TEXT = NULL,
	@AllocationSubRegionList TEXT = NULL,
	@HierarchyReportParameter dbo.ReportParameterGLCategorizationHierarchyDetail READONLY
AS
--*/

/*
DECLARE	
	@ReportExpensePeriod INT = 201101,
	@ReforecastQuarterName VARCHAR(2) = 'Q0', --'Q0' or 'Q1' or 'Q2' or 'Q3'
	@DestinationCurrency VARCHAR(3) = 'USD',
	@EntityList VARCHAR(255) = 'All',
	@DontSensitizeMRIPayrollData BIT = 1,
	@FunctionalDepartmentList VARCHAR(255) = 'Accounting',
	@AllocationSubRegionList VARCHAR(255) = 'Atlanta',
	@HierarchyReportParameter dbo.ReportParameterGLCategorizationHierarchyDetail 
	INSERT INTO @HierarchyReportParameter 
	SELECT 
	  2,
	  'Expense Czar Report',
	  -1,
	  '',
	  233,
	  'Global',
	  -1, -- finc
	  'Payroll',
	  -1, --majc
	  'All',
	  -1, -- minc
	  'All',
	  2, -- activity typeid
	  'Activity type',
	  1
	
	
*/

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

/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzarTotalComparisonDetail_CC21Signature]    Script Date: 11/04/2011 11:47:01 ******/


DECLARE
		@_ReforecastQuarterName VARCHAR(10) = @ReforecastQuarterName,
		@_DestinationCurrency VARCHAR(3) = @DestinationCurrency,
		@_EntityList VARCHAR(max) = @EntityList,
		@_DontSensitizeMRIPayrollData BIT = @DontSensitizeMRIPayrollData,
		@_AllocationSubRegionList  VARCHAR(max)=@AllocationSubRegionList,
		@ReportExpensePeriodParameter INT = @ReportExpensePeriod




/*
SELECT 'Non-Payroll' AS 'ExpenseType', 'Insurance' AS 'MajorExpenseCategoryName', 'Workers Comp Insurance' AS 'MinorExpenseCategoryName', 'Risk Management' AS 'FunctionalDepartmentName', 'Risk Management' AS 'FunctionalDepartmentFilterName', 'Southern California' AS 'AllocationSubRegionName', 'Southern California' AS 'AllocationSubRegionFilterName', 'Beverly Mercedes' AS 'EntityName', 'Property' AS 'EntityType', '' AS 'ActualsExpensePeriod', '' AS 'EntryDate', '' AS 'User', '          [BUDGET/REFORECAST]' AS 'Description', '' AS 'AdditionalDescription', 'USA Corporate' AS 'SourceName', '' AS 'PropertyFundCode', '' AS 'OriginatingRegionCode', 'New York' AS 'ORiginatingRegionName', '6010000005' AS 'GlAccountCode', 'Workers Comp Insurance (PME)' AS 'GlAccountName', 0.00 AS 'MtdActual', 341.00 AS 'MtdOriginalBudget', 0.00 AS 'MtdReforecast', 0.00 AS 'MtdVariance', 0.00 AS 'YtdActual', 2046.00 AS 'YtdOriginalBudget', 1314.00 AS 'YtdReforecast', 1314.00 AS 'YtdVariance', 4092.00 AS 'AnnualOriginalBudget', 1828.00 AS 'AnnualReforecast', 'Beverly Mercedes' AS 'EntityFilterName', 'New York' 'AS OriginatingRegionFilterName' UNION ALL
SELECT 'Non-Payroll', 'Insurance', 'Insurance - General Liability', 'UNKNOWN', 'UNKNOWN', 'Northern California', 'Northern California', '595 Market', 'Property', '', '', '', '          [BUDGET/REFORECAST]', '', 'USA Corporate', '', '', 'UNKNOWN', '6001000005', 'Insurance - General Liability (PME)', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 1012.25, 1012.25, 0.00, 1012.25, '595 Market', 'UNKNOWN' UNION ALL
SELECT 'Non-Payroll', 'Insurance', 'Insurance - Pollution/Environmental', 'UNKNOWN', 'UNKNOWN', 'Virginia/DC', 'Virginia/DC', '1919 Penn Ave', 'Property', '201102', '02/21/2011', '', 'Pollution Insurance Amort.                                  ', '', 'USA Property', 'DC1400     ', 'NYSRSK            ', 'UNKNOWN', '6007000005', 'Insurance - Pollution/Environmental (PME)', 0.00, 0.00, 0.00, 0.00, 216.39, 0.00, 0.00, -216.39, 0.00, 0.00, '1919 Penn Ave', 'UNKNOWN'
END
*/

-- #region Setup Variables
-----------------------------------------------------------------------------------------------
-- Setup Variables
-----------------------------------------------------------------------------------------------

	DECLARE @CalculationMethod VARCHAR(50) = 'USD'
	
	DECLARE @ActiveReforecastKey INT
	
	SET @ActiveReforecastKey = (
		SELECT 
			ReforecastKey 
		FROM 
			dbo.GetReforecastRecord(@ReportExpensePeriodParameter, @ReforecastQuarterName)
	)
	
	
	---- Calculate reforecast effective period from reforecast name
	DECLARE @ReforecastEffectivePeriod INT

	SET @ReforecastEffectivePeriod = (
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
	
	DECLARE @CalendarYear AS VARCHAR(10)
	SET @CalendarYear = SUBSTRING(CAST(@ReportExpensePeriodParameter AS VARCHAR(10)), 1, 4)
	
	
-- #endregion


-- #region Setup Mapping Tables
----------------------------------------------------------------------------------------------
-- Mapping Tables
----------------------------------------------------------------------------------------------

-- Exchange Rate
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

CREATE INDEX IX_SourceCurrencyKey ON #ExchangeRate (SourceCurrencyKey)
CREATE INDEX IX_CalendarKey ON #ExchangeRate (CalendarKey)

-- #region Mapping Table - EntityFilterTable
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
			dbo.Split(@EntityList) EntityListParameters
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
-- #endregion Mapping Table: EntityFilterTable

----------------------------------------------------------------------------------------
-- #region Mapping Table - EntityFilterTable
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
-- #endregion Mapping Table - EntityFilterTable


-- #endregion Mapping tables

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
	PropertyFundCode				Varchar(11) DEFAULT(''),
	OriginatingRegionCode			Varchar(30) DEFAULT(''),
	FunctionalDepartmentCode		Varchar(15) DEFAULT(''),
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
CREATE INDEX IX_AllocationRegionKey ON #ExpenseCzarTotalComparisonDetail (AllocationRegionKey)
CREATE INDEX IX_OriginatingRegionKey ON #ExpenseCzarTotalComparisonDetail (OriginatingRegionKey)
CREATE INDEX IX_PropertyFundKey ON #ExpenseCzarTotalComparisonDetail (PropertyFundKey)
CREATE INDEX IX_FunctionalDepartmentKey ON #ExpenseCzarTotalComparisonDetail (FunctionalDepartmentKey)
CREATE INDEX IX_GLCategorizationHierarchyKey ON #ExpenseCzarTotalComparisonDetail (GLCategorizationHierarchyKey)


CREATE TABLE #CategorizationHierarchyFilterTable
(
	CategorizationHierarchyKey INT NOT NULL,
	GLCategorizationName VARCHAR(50) NOT NULL,
	GLFinancialCategoryName VARCHAR(50) NOT NULL,
	GLMajorCategoryName VARCHAR(50) NOT NULL,
	GLMinorCategoryName VARCHAR(50) NOT NULL,
	GLAccountCode VARCHAR(15) NOT NULL,
	GLAccountName VARCHAR(300) NOT NULL,
	ActivityTypeId INT NOT NULL
)

CREATE UNIQUE CLUSTERED INDEX IX_CL ON #CategorizationHierarchyFilterTable (CategorizationHierarchyKey)
CREATE INDEX IX_ActivityTypeId ON #CategorizationHierarchyFilterTable (ActivityTypeId)

INSERT INTO #CategorizationHierarchyFilterTable
SELECT
	GLCategorizationHierarchy.GLCategorizationHierarchyKey,
	GLCategorizationHierarchy.GLCategorizationName,
	GLCategorizationHierarchy.GLFinancialCategoryName,
	GLCategorizationHierarchy.GLMajorCategoryName,
	GLCategorizationHierarchy.GLMinorCategoryName,
	GLCategorizationHierarchy.GLAccountCode,
	GLCategorizationHierarchy.GlAccountName,
	HierarchyReportParameter.ActivityTypeId
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
	
	
--IF (@_DisplayOverheadBy == 'Un	

-- #region Query Actuals
----------------------------------------------------------------------------------------------
-- Add Actuals
----------------------------------------------------------------------------------------------

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
	ProfitabilityActual.GlobalGLCategorizationHierarchyKey AS GLCategorizationHierarchyKey,
	ProfitabilityActual.AllocationRegionKey,
	ProfitabilityActual.OriginatingRegionKey,
	ProfitabilityActual.FunctionalDepartmentKey,
	ProfitabilityActual.PropertyFundKey,	
	CASE
			WHEN @DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
			ELSE Source.SourceName
	END AS 'SourceName',
	CONVERT(varchar(10),ISNULL(ProfitabilityActual.EntryDate,''), 101) AS 'EntryDate',
			ProfitabilityActual.[User],
			ProfitabilityActual.Description,
			ProfitabilityActual.AdditionalDescription,
	CASE
			WHEN @DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
			ELSE ProfitabilityActual.PropertyFundCode
	END AS 'PropertyFundCode',
	CASE
		WHEN @DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
		ELSE ProfitabilityActual.OriginatingRegionCode
	END AS 'OriginatingRegionCode',
	ProfitabilityActual.FunctionalDepartmentCode,
	GlobalGLCategorizationHierarchy.GlAccountCode,
	GlobalGLCategorizationHierarchy.GlAccountName,
	Calendar.CalendarPeriod,
	SUM (
			#ExchangeRate.Rate *
			CASE
				WHEN Calendar.CalendarPeriod = @ReportExpensePeriodParameter THEN ProfitabilityActual.LocalActual
				ELSE 0.0
			END
		) AS 'MtdGrossActual',
	NULL as MtdGrossBudget,
	NULL as MtdGrossReforecast,
	NULL AS 'MtdGrossBudget',
	NULL AS 'MtdGrossReforecast',
	
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
	NULL as MtdNetBudget,
	NULL as MtdNetReforecast,
	
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
	NULL as AnnualEstGrossReforecast,	
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
		
	INNER JOIN GlCategorizationHierarchy GlobalGLCategorizationHierarchy ON 
		GlobalGLCategorizationHierarchy.GLCategorizationHierarchyKey = ProfitabilityActual.GlobalGLCategorizationHierarchyKey 	

	INNER JOIN #CategorizationHierarchyFilterTable GlHierarchy ON 
		GlHierarchy.CategorizationHierarchyKey = ProfitabilityActual.GlobalGLCategorizationHierarchyKey AND
		(GlHierarchy.ActivityTypeId = 0 OR GlHierarchy.ActivityTypeId = ProfitabilityActual.ActivityTypeKey)
	
	INNER JOIN #AllocationSubRegionFilterTable ON
		ProfitabilityActual.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey			
	
	INNER JOIN Source ON
		ProfitabilityActual.SourceKey = Source.SourceKey

	INNER JOIN Reimbursable ON
		ProfitabilityActual.ReimbursableKey = Reimbursable.ReimbursableKey

	INNER JOIN Overhead ON
		ProfitabilityActual.OverheadKey = Overhead.OverheadKey

	INNER JOIN Calendar ON
		ProfitabilityActual.CalendarKey = Calendar.CalendarKey		

	INNER JOIN #ExchangeRate ON
		ProfitabilityActual.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
		ProfitabilityActual.CalendarKey = #ExchangeRate.CalendarKey
		
	INNER JOIN Currency ON
		#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey
		
WHERE 
		/*Overhead.OverheadName IN 
		(
			'Unallocated',
			'UNKNOWN'
		) AND*/
		GlobalGLCategorizationHierarchy.InflowOutflow IN (
				'Outflow', 
				'UNKNOWN'
			) AND
		Calendar.CalendarYear = STR(@CalendarYear, 10, 0) AND
		Currency.CurrencyCode = @_DestinationCurrency AND
		GlHierarchy.GLMinorCategoryName <> 'Bonus'		
		
GROUP BY
		ProfitabilityActual.GlobalGLCategorizationHierarchyKey,
		ProfitabilityActual.AllocationRegionKey,
		ProfitabilityActual.OriginatingRegionKey,
		ProfitabilityActual.FunctionalDepartmentKey,
		ProfitabilityActual.PropertyFundKey,
		Calendar.CalendarPeriod,
		CASE
			WHEN @DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
			ELSE Source.SourceName
		END,
		CONVERT(varchar(10),ISNULL(ProfitabilityActual.EntryDate,''), 101),
		ProfitabilityActual.[User],
		ProfitabilityActual.Description,
		ProfitabilityActual.AdditionalDescription,
		CASE
			WHEN @DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
			ELSE ProfitabilityActual.PropertyFundCode
		END,
		CASE
			WHEN @DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
			ELSE ProfitabilityActual.OriginatingRegionCode
		END,
		ProfitabilityActual.FunctionalDepartmentCode,
		GlobalGLCategorizationHierarchy.GlAccountCode,
		GlobalGLCategorizationHierarchy.GlAccountName		


--#endregion


-- #region Query Budgets
----------------------------------------------------------------------------------------------
-- Add Budgets
----------------------------------------------------------------------------------------------

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
	ProfitabilityBudget.GlobalGLCategorizationHierarchyKey AS GLCategorizationHierarchyKey,
	ProfitabilityBudget.AllocationRegionKey,
	ProfitabilityBudget.OriginatingRegionKey,
	ProfitabilityBudget.FunctionalDepartmentKey,
	ProfitabilityBudget.PropertyFundKey,	
	CASE
			WHEN @DontSensitizeMRIPayrollData = 0 AND GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
			ELSE Source.SourceName
	END AS 'SourceName',
	'''' as EntryDate,
	'''' as [User],
	'''' as Description,
	'''' as AdditionalDescription,
	'' AS PropertyFundCode,
	'' AS OriginatingRegionCode,
	'' AS FunctionalDepartmentCode,
	GlHierarchy.GlAccountCode,
	GlHierarchy.GlAccountName,
	Calendar.CalendarPeriod,
	SUM (
			#ExchangeRate.Rate *
			CASE
				WHEN Calendar.CalendarPeriod = @ReportExpensePeriodParameter THEN ProfitabilityBudget.LocalBudget
				ELSE 0.0
			END
		) AS 'MtdGrossActual',
	SUM (
			#ExchangeRate.Rate *
			CASE 
				WHEN Calendar.CalendarPeriod = @ReportExpensePeriodParameter THEN ProfitabilityBudget.LocalBudget
				ELSE 0.0
			END
		) AS 'MtdGrossBudget',
	NULL as MtdGrossReforecast,
	
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
	
	--Year to date
	SUM (
		#ExchangeRate.Rate * 
		CASE 
			WHEN Calendar.CalendarPeriod <= @ReportExpensePeriodParameter THEN ProfitabilityBudget.LocalBudget
			ELSE 0.0
		END
	) AS 'YtdGrossActual',
	NULL AS 'YtdGrossBudget',
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
	NULL as YtdNetReforecast,
		
		
	SUM (
			#ExchangeRate.Rate *
			ProfitabilityBudget.LocalBudget 
		) AS 'AnnualGrossBudget',
	NULL AS AnnualGrossReforecast,	
	SUM (
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			ProfitabilityBudget.LocalBudget
		) AS 'AnnualNetBudget',
	NULL AS AnnualNetReforecast,
	
	--Annual estimated
	SUM (
		#ExchangeRate.Rate *
		CASE
			WHEN Calendar.CalendarPeriod <= @ReportExpensePeriodParameter THEN ProfitabilityBudget.LocalBudget
			ELSE 0.0
		END
	) AS 'AnnualEstGrossBudget',		
	NULL AS 'AnnualEstGrossReforecast',	
	SUM (
		#ExchangeRate.Rate *
		Reimbursable.MultiplicationFactor *
		CASE
			WHEN Calendar.CalendarPeriod <= @ReportExpensePeriodParameter THEN ProfitabilityBudget.LocalBudget
			ELSE 0.0
		END
	) AS 'AnnualEstNetBudget',
	NULL AS 'AnnualEstNetReforecast'	
FROM
	ProfitabilityBudget
	
	INNER JOIN #EntityFilterTable ON
		ProfitabilityBudget.PropertyFundKey = #EntityFilterTable.PropertyFundKey
	
	INNER JOIN GlCategorizationHierarchy GlobalGLCategorizationHierarchy ON 
		GlobalGLCategorizationHierarchy.GLCategorizationHierarchyKey = ProfitabilityBudget.GlobalGLCategorizationHierarchyKey

	INNER JOIN #CategorizationHierarchyFilterTable GlHierarchy ON 
		GlHierarchy.CategorizationHierarchyKey = ProfitabilityBudget.GlobalGLCategorizationHierarchyKey  AND
		(GlHierarchy.ActivityTypeId = 0 OR GlHierarchy.ActivityTypeId = ProfitabilityBudget.ActivityTypeKey)
	
	INNER JOIN #AllocationSubRegionFilterTable ON
		ProfitabilityBudget.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey			
	
	INNER JOIN Source ON
		ProfitabilityBudget.SourceKey = Source.SourceKey

	INNER JOIN Reimbursable ON
		ProfitabilityBudget.ReimbursableKey = Reimbursable.ReimbursableKey

	INNER JOIN Calendar ON
		ProfitabilityBudget.CalendarKey = Calendar.CalendarKey
		
	INNER JOIN #ExchangeRate ON
		ProfitabilityBudget.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
		ProfitabilityBudget.CalendarKey = #ExchangeRate.CalendarKey
		
	INNER JOIN Currency ON
		#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey
		
	INNER JOIN Overhead ON
		ProfitabilityBudget.OverheadKey = Overhead.OverheadKey		
WHERE 
		/*Overhead.OverheadName IN 
		(
			'Unallocated',
			'UNKNOWN'
		) AND*/
		GlobalGLCategorizationHierarchy.InflowOutflow IN (
				'Outflow', 
				'UNKNOWN'
			) AND
		Calendar.CalendarYear = STR(@CalendarYear, 10, 0) AND
		Currency.CurrencyCode = @_DestinationCurrency AND
		GlHierarchy.GLMinorCategoryName <> 'Bonus'		
GROUP BY
		ProfitabilityBudget.GlobalGLCategorizationHierarchyKey,
		ProfitabilityBudget.AllocationRegionKey,
		ProfitabilityBudget.OriginatingRegionKey,
		ProfitabilityBudget.FunctionalDepartmentKey,
		ProfitabilityBudget.PropertyFundKey,
		Calendar.CalendarPeriod,
		CASE
			WHEN @DontSensitizeMRIPayrollData = 0 AND 
					GlobalGLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 
				'Sensitized'	
			ELSE Source.SourceName
		END,
		GlHierarchy.GlAccountCode,
		GlHierarchy.GlAccountName

--#endregion Query Budgets

-- #region Query Reforecasts
----------------------------------------------------------------------------------------------
-- Add Reforecasts
----------------------------------------------------------------------------------------------

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
	SELECT --TOP 0
		ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey AS GLCategorizationHierarchyKey,
		ProfitabilityReforecast.AllocationRegionKey,
		ProfitabilityReforecast.OriginatingRegionKey,
		ProfitabilityReforecast.FunctionalDepartmentKey,
		ProfitabilityReforecast.PropertyFundKey,	
		CASE
				WHEN @DontSensitizeMRIPayrollData = 0 AND GlHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
				ELSE Source.SourceName
		END AS 'SourceName',
		'''' as EntryDate,
		'''' as [User],
		'''' as Description,
		'''' as AdditionalDescription,
		'' AS PropertyFundCode,
		'' AS OriginatingRegionCode,
		'' AS FunctionalDepartmentCode,
		GlHierarchy.GlAccountCode,
		GlHierarchy.GlAccountName,
		Calendar.CalendarPeriod,
		NULL AS 'MtdGrossActual',
		NULL AS 'MtdGrossBudget',
		SUM (
				#ExchangeRate.Rate *
				CASE
					WHEN Calendar.CalendarPeriod = @ReportExpensePeriodParameter THEN ProfitabilityReforecast.LocalReforecast
					ELSE 0.0
				END
			) AS 'MtdGrossReforecast',			
		NULL AS 'MtdNetActual',
		NULL AS 'MtdNetBudget',			
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
		NULL as MtdNetBudget,
		SUM(
				#ExchangeRate.Rate *Reimbursable.MultiplicationFactor * 
				CASE 
					WHEN Calendar.CalendarPeriod <= @ReportExpensePeriodParameter THEN ProfitabilityReforecast.LocalReforecast
					ELSE 0.0
				END
			) AS 'YtdNetReforecast',
		NULL AS AnnualGrossBudget,
					SUM(
				#ExchangeRate.Rate * 
				ProfitabilityReforecast.LocalReforecast
			) AS 'AnnualGrossReforecast',
		NULL AS AnnualNetBudget,
		SUM (
				#ExchangeRate.Rate *
				Reimbursable.MultiplicationFactor * 
				ProfitabilityReforecast.LocalReforecast
			) AS 'AnnualNetReforecast',
		NULL AS 'AnnualEstGrossBudget',		
		NULL AS 'AnnualEstGrossReforecast',	
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
	FROM
		ProfitabilityReforecast
		INNER JOIN #EntityFilterTable ON
			ProfitabilityReforecast.PropertyFundKey = #EntityFilterTable.PropertyFundKey
	
		INNER JOIN GlCategorizationHierarchy GlobalGLCategorizationHierarchy ON 
			GlobalGLCategorizationHierarchy.GLCategorizationHierarchyKey = ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey

		INNER JOIN #CategorizationHierarchyFilterTable GlHierarchy ON 
			GlHierarchy.CategorizationHierarchyKey = ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey  AND
			(GlHierarchy.ActivityTypeId = 0 OR GlHierarchy.ActivityTypeId = ProfitabilityReforecast.ActivityTypeKey)
		
		INNER JOIN #AllocationSubRegionFilterTable ON
			ProfitabilityReforecast.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey			
			
		INNER JOIN #ExchangeRate ON
			ProfitabilityReforecast.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
			ProfitabilityReforecast.CalendarKey = #ExchangeRate.CalendarKey
			
		INNER JOIN Currency ON
			#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey
			
		INNER JOIN Overhead ON
			ProfitabilityReforecast.OverheadKey = Overhead.OverheadKey
								
		INNER JOIN Calendar ON
			ProfitabilityReforecast.CalendarKey = Calendar.CalendarKey
		
		INNER JOIN Source ON
			ProfitabilityReforecast.SourceKey = Source.SourceKey
		
		INNER JOIN Reimbursable ON
			ProfitabilityReforecast.ReimbursableKey = Reimbursable.ReimbursableKey

	WHERE 
	/*	Overhead.OverheadName IN 
		(
			'Unallocated',
			'UNKNOWN'
		) AND*/
		GlobalGLCategorizationHierarchy.InflowOutflow IN (
				'Outflow', 
				'UNKNOWN'
			) AND
		Calendar.CalendarYear = STR(@CalendarYear, 10, 0) AND
		Currency.CurrencyCode = @_DestinationCurrency AND
		GlHierarchy.GLMinorCategoryName <> 'Bonus'
		
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
			WHEN @DontSensitizeMRIPayrollData = 0 AND GlHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
			ELSE Source.SourceName
		END,
		CASE
			WHEN @DontSensitizeMRIPayrollData = 0 AND GlHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN NULL	
			ELSE GlHierarchy.GlAccountCode
		END,
		CASE
			WHEN @DontSensitizeMRIPayrollData = 0 AND GlHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN NULL	
			ELSE GlHierarchy.GlAccountName
		END


END

--SELECT * from #ExpenseCzarTotalComparisonDetail


-- #region Output
SELECT
		AllocationRegion.RegionName AS 'AllocationRegionName',
		AllocationRegion.SubRegionName AS 'AllocationSubRegionName',
		OriginatingRegion.RegionName AS 'OriginatingRegionName',
		OriginatingRegion.SubRegionName AS 'OriginatingSubRegionName',
		FunctionalDepartment.FunctionalDepartmentName AS 'FunctionalDepartmentName',
		FunctionalDepartment.SubFunctionalDepartmentName AS 'JobCode',
		GLCategorizationHierarchy.GLFinancialCategoryName AS 'FinancialCategoryName',
		GLCategorizationHierarchy.GLMajorCategoryName AS 'MajorExpenseCategoryName',
		GLCategorizationHierarchy.GLMinorCategoryName AS 'MinorExpenseCategoryName',
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
		GLCategorizationHierarchy.GLFinancialCategoryName AS FinancialCategory
	
	INTO
		#Output

FROM 
	#ExpenseCzarTotalComparisonDetail 
	INNER JOIN AllocationRegion ON
		#ExpenseCzarTotalComparisonDetail.AllocationRegionKey = AllocationRegion.AllocationRegionKey
		
	INNER JOIN OriginatingRegion ON
		#ExpenseCzarTotalComparisonDetail.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey
		
	INNER JOIN PropertyFund On
		#ExpenseCzarTotalComparisonDetail.PropertyFundKey = PropertyFund.PropertyFundKey
		
	INNER JOIN FunctionalDepartment ON
		#ExpenseCzarTotalComparisonDetail.FunctionalDepartmentKey = FunctionalDepartment.FunctionalDepartmentKey
		
	INNER JOIN GLCategorizationHierarchy ON
		#ExpenseCzarTotalComparisonDetail.GLCategorizationHierarchyKey = GLCategorizationHierarchy.GLCategorizationHierarchyKey
		
	GROUP BY
		GLCategorizationHierarchy.InflowOutflow,
		AllocationRegion.RegionName,
		AllocationRegion.SubRegionName,
		OriginatingRegion.RegionName,
		OriginatingRegion.SubRegionName,
		FunctionalDepartment.FunctionalDepartmentName,
		FunctionalDepartment.SubFunctionalDepartmentName,
		GLCategorizationHierarchy.GLFinancialCategoryName,
		GLCategorizationHierarchy.GLMajorCategoryName,
		GLCategorizationHierarchy.GLMinorCategoryName,
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

-- #endregion

--------------------------------------------------------------------------
	/*    SELECT FINAL OUTPUT			    						         */
	--------------------------------------------------------------------------

	SELECT --TOP 9000
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
--SELECT * FROM #Output

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




