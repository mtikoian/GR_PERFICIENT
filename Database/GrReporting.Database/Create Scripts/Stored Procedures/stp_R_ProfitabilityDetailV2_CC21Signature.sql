 USE [GrReporting]
GO

USE GrReporting
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--/*
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ProfitabilityDetailV2_CC21Signature]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ProfitabilityDetailV2_CC21Signature]
GO

CREATE PROCEDURE [dbo].[stp_R_ProfitabilityDetailV2_CC21Signature]
	@ReportExpensePeriod INT,
	@ReforecastQuarterName VARCHAR(2), --'Q0' or 'Q1' or 'Q2' or 'Q3'
	@DestinationCurrency VARCHAR(3),
	@EntityList TEXT,	
	@DontSensitizeMRIPayrollData BIT = 1,
	@IncludeGrossNonPayrollExpenses BIT = 1,
	@IncludeFeeAdjustments BIT = 1,
	@DisplayOverheadBy TEXT,
--	@OverheadOriginatingSubRegionList TEXT,
	@ConsolidationRegionList TEXT,
	@OriginatingSubRegionList TEXT,
	@ActivityTypeList TEXT,
	@GLCategorizationName VARCHAR(50)
	--@HierarchyReportParameter dbo.ReportParameterGLCategorizationHierarchyDetail READONLY
	
AS


--SELECT 0 AS 'NumberOfSpacesToPad', 'REVENUE' AS 'GroupDisplayCode', 'REVENUE' AS 'GroupDisplayName', 100 AS 'DisplayOrderNumber', 0.00 AS 'MtdActual', 0.00 AS 'MtdOriginalBudget', 0.00 AS 'MtdReforecastQ1', 0.00 AS 'MtdReforecastQ2', 0.00 AS 'MtdReforecastQ3', 0.00 AS 'MtdVarianceQ0', 0.00 AS 'MtdVarianceQ1', 0.00 AS 'MtdVarianceQ2', 0.00 AS 'MtdVarianceQ3', 0.00 AS 'MtdVariancePercentageQ0', 0.00 AS 'MtdVariancePercentageQ1', 0.00 AS 'MtdVariancePercentageQ2', 0.00 AS 'MtdVariancePercentageQ3', 0.00 AS 'YtdActual', 0.00 AS 'YtdOriginalBudget', 0.00 AS 'YtdReforecastQ1', 0.00 AS 'YtdReforecastQ2', 0.00 AS 'YtdReforecastQ3', 0.00 AS 'YtdVarianceQ0', 0.00 AS 'YtdVarianceQ1', 0.00 AS 'YtdVarianceQ2', 0.00 AS 'YtdVarianceQ3', 0.00 AS 'YtdVariancePercentageQ0', 0.00 AS 'YtdVariancePercentageQ1', 0.00 AS 'YtdVariancePercentageQ2', 0.00 AS 'YtdVariancePercentageQ3', 0.00 AS 'AnnualOriginalBudget', 0.00 AS 'AnnualReforecastQ1', 0.00 AS 'AnnualReforecastQ2', 0.00 AS 'AnnualReforecastQ3' UNION ALL
--SELECT 0, 'FEEREVENUE', 'Fee Revenue', 200, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00
--SELECT 'Non-Payroll' AS 'ExpenseType', 'EXPENSE' AS 'FeeOrExpense', 'Charitable Contributions' AS 'MajorExpenseCategoryName', 'Charitable Contributions' AS 'MinorExpenseCategoryName', '6301000012' AS 'GlobalGlAccountCode', 'Charitable Contributions (CORP)  ' AS 'GlobalGlAccountName', 'Corporate' AS 'BusinessLine', 'Corporate' AS 'ActivityType', 'TSP Corporate' AS 'ReportingEntityName', 'Corporate' AS 'ReportingEntityType', '001000     ' AS 'PropertyFundCode', 'DNC            ' AS 'FunctionalDepartmentCode', 'US Corporate' AS 'AllocationSubRegionName', 'New York' AS 'OriginatingSubRegionName', '201101' AS 'ActualsExpensePeriod', '01/01/1900' AS 'EntryDate', 'DRUSCING' AS 'User', 'Reverse JE 22974L 2010 ACC                                   ' AS 'Description', '' AS 'AdditionalDescription', 'Not Reimbursable' AS 'ReimbursableName', 'NORMAL' AS 'FeeAdjustmentCode', 'USA Corporate' AS 'SourceName', '989' AS 'GlAccountCategoryKey', 10000.00 AS 'MtdActual', 0.00 AS 'MtdOriginalBudget', 0.00 AS 'MtdReforecastQ1', 0.00 AS 'MtdReforecastQ2', 0.00 AS 'MtdReforecastQ3', -10000.00 AS 'MtdVarianceQ0', 0.00 AS 'MtdVarianceQ1', 0.00 AS 'MtdVarianceQ2', 0.00 AS 'MtdVarianceQ3', 10000.00 AS 'YtdActual', 0.00 AS 'YtdOriginalBudget', 0.00 AS 'YtdReforecastQ1', 0.00 AS 'YtdReforecastQ2', 0.00 AS 'YtdReforecastQ3', -10000.00 AS 'YtdVarianceQ0', 0.00 AS 'YtdVarianceQ1', 0.00 AS 'YtdVarianceQ2', 0.00 AS 'YtdVarianceQ3', 0.00 AS 'AnnualOriginalBudget', 0.00 AS 'AnnualReforecastQ1', 0.00 AS 'AnnualReforecastQ2', 0.00 AS 'AnnualReforecastQ3', 'US Corporate' AS 'ConsolidationSubRegionName' UNION ALL
--SELECT 'Non-Payroll', 'EXPENSE', 'Charitable Contributions', 'Charitable Contributions', '6301000012', 'Charitable Contributions (CORP)  ', 'Corporate', 'Corporate', 'TSP Corporate', 'Corporate', '001000     ', 'CEX            ', 'US Corporate', 'New York', '201101', '01/25/2011', 'JASHTON', '    10014 1/19/2011 IN LIEU 1/20 CELEBRA SCHNEIDERMAN FOR   ', 'ATTORNEY GENERAL  ', 'Not Reimbursable', 'NORMAL', 'USA Corporate', '989', -10000.00, 0.00, 0.00, 0.00, 0.00, 10000.00, 0.00, 0.00, 0.00, -10000.00, 0.00, 0.00, 0.00, 0.00, 10000.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 'US Corporate' UNION ALL
--SELECT 'Non-Payroll', 'EXPENSE', 'Charitable Contributions', 'Charitable Contributions', '6301000012', 'Charitable Contributions (CORP)  ', 'Corporate', 'Corporate', 'TSP Corporate', 'Corporate', '001000     ', 'CEX            ', 'US Corporate', 'New York', '201101', '01/25/2011', 'JASHTON', '    60893 1/1/2011 02/1/11-01/31/12DUES COUNCIL ON FOREIGN  ', 'RELATIONS  ', 'Not Reimbursable', 'NORMAL', 'USA Corporate', '989', -30000.00, 0.00, 0.00, 0.00, 0.00, 30000.00, 0.00, 0.00, 0.00, -30000.00, 0.00, 0.00, 0.00, 0.00, 30000.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 'US Corporate' UNION ALL
--SELECT 'Non-Payroll', 'EXPENSE', 'Charitable Contributions', 'Charitable Contributions', '6301000012', 'Charitable Contributions (CORP)  ', 'Corporate', 'Corporate', 'TSP Corporate', 'Corporate', '001000     ', 'CEX            ', 'US Corporate', 'New York', '201101', '01/25/2011', 'JASHTON', '    60908 1/5/2011 InLieu2/28/11Benefit GRACIE MANSION      ', 'CONSERVANCY  ', 'Not Reimbursable', 'NORMAL', 'USA Corporate', '989', -25000.00, 0.00, 0.00, 0.00, 0.00, 25000.00, 0.00, 0.00, 0.00, -25000.00, 0.00, 0.00, 0.00, 0.00, 25000.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 'US Corporate' UNION ALL
--SELECT 'Non-Payroll', 'EXPENSE', 'Charitable Contributions', 'Charitable Contributions', '6301000012', 'Charitable Contributions (CORP)  ', 'Corporate', 'Corporate', 'TSP Corporate', 'Corporate', '001000     ', 'CEX            ', 'US Corporate', 'New York', '201101', '01/25/2011', 'JASHTON', '    60909 1/7/2011 IN LIEU 3/10/11EVENT AMERICAN FRIENDS OF ', '', 'Not Reimbursable', 'NORMAL', 'USA Corporate', '989', -6000.00, 0.00, 0.00, 0.00, 0.00, 6000.00, 0.00, 0.00, 0.00, -6000.00, 0.00, 0.00, 0.00, 0.00, 6000.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 'US Corporate'
--*/

/*
DECLARE	
	@ReportExpensePeriod INT = 201101,
	@ReforecastQuarterName VARCHAR(2) = 'Q0', --'Q0' or 'Q1' or 'Q2' or 'Q3'
	@DestinationCurrency VARCHAR(3) = 'USD',
	@EntityList VARCHAR(255) = 'All',
	@DontSensitizeMRIPayrollData BIT = 1,
	@FunctionalDepartmentList VARCHAR(255) = 'All',
	@ConsolidationRegionList VARCHAR(255) = 'Atlanta',
	@DisplayOverheadBy VARCHAR(255) = 'Allocated Overhead',
	@ActivityTypeList VARCHAR(255) = 'All',
	@OriginatingSubRegionList VARCHAR(255) = 'Atlanta',
	@GLCategorizationName VARCHAR(50) = 'Global'
	/*@HierarchyReportParameter dbo.ReportParameterGLCategorizationHierarchyDetail 
	--SELECT * FROM @HierarchyReportParameter 
	
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
	  1*/
*/
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
    
    
/* ============================================================================================================================
	Variables
============================================================================================================================= */
BEGIN

	DECLARE
			@ErrorSeverity  INT = ERROR_SEVERITY(), 
			@ErrorMessage NVARCHAR(4000),
			@_ReforecastQuarterName VARCHAR(10) = @ReforecastQuarterName,
			@_DestinationCurrency VARCHAR(3) = @DestinationCurrency,
			@_EntityList VARCHAR(max) = @EntityList,
			@_ActivityTypeList VARCHAR(MAX) = @ActivityTypeList,
			@_DontSensitizeMRIPayrollData BIT = @DontSensitizeMRIPayrollData,
			@_ReportExpensePeriod INT = @ReportExpensePeriod,
			@_AllocationSubRegionList  VARCHAR(max)=@ConsolidationRegionList,
			@_OriginatingSubRegionList VARCHAR(max)=@OriginatingSubRegionList,
			@_DisplayOverheadBy VARCHAR(255)=@DisplayOverheadBy,
			@ReportExpensePeriodParameter INT = @ReportExpensePeriod    
			

	DECLARE @ActiveReforecastKey INT
		
		SET @ActiveReforecastKey = (
			SELECT 
				ReforecastKey 
			FROM 
				dbo.GetReforecastRecord(@ReportExpensePeriodParameter, @_ReforecastQuarterName)
		)		

	DECLARE @GLCategorizationParameter VARCHAR(50)
	/*SET @GLCategorizationParameter = 
		(
			SELECT DISTINCT 
				GLCategorizationName 
			FROM 
				@HierarchyReportParameter
		)*/

	DECLARE @FeeAdjustmentKey AS INT =
		(SELECT FeeAdjustmentKey From FeeAdjustment Where FeeAdjustmentCode = 'NORMAL')
			
			
	DECLARE @CalendarYear AS VARCHAR(10)

	SET @CalendarYear = SUBSTRING(CAST(@_ReportExpensePeriod AS VARCHAR(10)), 1, 4)
	
	DECLARE @InflowOutflowExpense VARCHAR(20) = 'Outflow'
	DECLARE @InflowOutflowIncome VARCHAR(20) = 'Inflow'
	

/*DECLARE @HierarchyReportParameterCount INT = (SELECT COUNT(*) FROM @HierarchyReportParameter)
IF (@HierarchyReportParameterCount = 0)
BEGIN
	SET @ErrorSeverity  = ERROR_SEVERITY()
	SET @ErrorMessage =
			'Hierarchy parameter is empty: ' + CONVERT(VARCHAR(10), ERROR_NUMBER()) + ':' + ERROR_MESSAGE() 	
	RAISERROR ( @ErrorMessage, @ErrorSeverity, 1)

END
ELSE BEGIN
  PRINT '@HierarchyReportParameterCount: ' + CONVERT(VARCHAR(10), @HierarchyReportParameterCount)
END*/
	
	
   /* PRINT @ReportExpensePeriod 
	PRINT @ReforecastQuarterName
	PRINT @DestinationCurrency
	PRINT @EntityList
	PRINT @DontSensitizeMRIPayrollData
	PRINT @IncludeGrossNonPayrollExpenses
	PRINT @IncludeFeeAdjustments
	PRINT @DisplayOverheadBy
	PRINT 'Consolidation:'
    PRINT @ConsolidationRegionList
	PRINT @OriginatingSubRegionList
	PRINT @ActivityTypeList*/
	--PRINT @HierarchyReportParameter dbo.ReportParameterGLCategorizationHierarchyDetail	
	
END			
			
/* ============================================================================================================================
	Start of Mapping Table Block
============================================================================================================================= */

/* ============================================================================================================================
	Mapping: #AllocationSubRegionFilterTable
============================================================================================================================= */

BEGIN
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
END

/* ============================================================================================================================
	Mapping: #OverheadFilterTable
============================================================================================================================= */

BEGIN
	CREATE TABLE #OverheadFilterTable
	(
		OverheadKey INT NOT NULL
	)

	DECLARE @GrOverheadName VARCHAR(50)

	IF (@_DisplayOverheadBy = 'Allocated Overhead') 
	BEGIN
		SET @GrOverheadName = 'Allocated'
	END
	ELSE IF (@_DisplayOverheadBy = 'Unallocated Overhead')
	BEGIN
		SET @GrOverheadName = 'Unallocated'
	END
	ELSE BEGIN
			SET @ErrorSeverity  = ERROR_SEVERITY()
			SET @ErrorMessage =
				'Error in display overhead By: ' + CONVERT(VARCHAR(10), ERROR_NUMBER()) + ':' + ERROR_MESSAGE() 	
		RAISERROR ( @ErrorMessage, @ErrorSeverity, 1)
	END
	INSERT INTO #OverheadFilterTable
	SELECT 
		OverheadKey
	FROM 
		Overhead 
	WHERE
		OverheadName = @GrOverheadName OR
		OverheadCode = 'UNKNOWN' -- Include Unknowns
END

/* ============================================================================================================================
	Mapping: #ActivityTypeFilterTable
============================================================================================================================= */

BEGIN
	CREATE TABLE #ActivityTypeFilterTable
	(
		ActivityTypeKey INT NOT NULL,
	)

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable (ActivityTypeKey)

	IF (@_ActivityTypeList IS NOT NULL)
	BEGIN	
		IF (@_ActivityTypeList <> 'All')
		BEGIN
			INSERT INTO #ActivityTypeFilterTable
			SELECT 
				ActivityType.ActivityTypeKey
			FROM 
				dbo.Split(@_ActivityTypeList) ActivityTypeParameters
				
			INNER JOIN ActivityType ON 
				ActivityType.ActivityTypeName = ActivityTypeParameters.item
		END
		ELSE IF (@_ActivityTypeList = 'All')
		BEGIN
			INSERT INTO #ActivityTypeFilterTable
			SELECT 
				ActivityType.ActivityTypeKey
			FROM 
				ActivityType
		END
	END
END	

/* ============================================================================================================================
	Mapping: #EntityFilterTable
============================================================================================================================= */

BEGIN
	CREATE TABLE #EntityFilterTable	
	(
		PropertyFundKey INT NOT NULL
	)

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable (PropertyFundKey)

	IF (@_EntityList IS NOT NULL)
	BEGIN	
		IF (@_EntityList <> 'All')
		BEGIN
			INSERT INTO #EntityFilterTable
			SELECT 
				PropertyFund.PropertyFundKey
			FROM 
				dbo.Split(@_EntityList) EntityListParameters
			INNER JOIN PropertyFund ON 
				PropertyFund.PropertyFundName = EntityListParameters.item
		END
		ELSE IF (@_EntityList = 'All')
		BEGIN
			INSERT INTO #EntityFilterTable
			SELECT 
				PropertyFund.PropertyFundKey
			FROM 
				PropertyFund
		END
	END
END

/* ============================================================================================================================
	Mapping: #OriginatingSubRegionFilterTable
============================================================================================================================= */

BEGIN
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
END

/* ============================================================================================================================
	Mapping: #CategorizationHierarchyFilterTable
============================================================================================================================= */

/*BEGIN
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
END		*/

/* ============================================================================================================================
	Mapping: #ExchangeRate
============================================================================================================================= */
BEGIN
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
END

/* ============================================================================================================================
	End of Mapping Table Block
============================================================================================================================= */

--SELECT DISTINCT GLFinancialCategoryName FROM GLCategorizationHierarchy ORDER BY GLFinancialCategoryName
--SELECT * FROM GLCategorizationHierarchy ORDER BY GLFinancialCategoryName

/* ============================================================================================================================
	Create Temp Table
============================================================================================================================= */

CREATE TABLE #ProfitabilityReport
(	
	GLCategorizationHierarchyKey Int,
    ActivityTypeKey				Int,
    PropertyFundKey				Int,
    AllocationRegionKey			Int,
    ConsolidationRegionKey			Int,
    OriginatingRegionKey		Int,
	SourceName						VARCHAR(50),
	SourceKey						INT,
	GlAccountCode					VARCHAR(15) NOT NULL,
	GLAccountName VARCHAR(300) NOT NULL,
	GLFinancialCategoryName VARCHAR(300) NOT NULL,
	InflowOutflow VARCHAR(20),
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

/* ============================================================================================================================
	Add Actuals
============================================================================================================================= */

INSERT INTO #ProfitabilityReport
SELECT 	-- TOP 0
	GlCategorizationHierarchy.GLCategorizationHierarchyKey AS 'GLCategorizationHierarchyKey',
    ProfitabilityActual.ActivityTypeKey,
    ProfitabilityActual.PropertyFundKey,
    ProfitabilityActual.AllocationRegionKey,
    ProfitabilityActual.ConsolidationRegionKey,
    ProfitabilityActual.OriginatingRegionKey,
	CASE
		WHEN @_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
		ELSE Source.SourceName
	END AS 'SourceName',
	ProfitabilityActual.SourceKey AS SourceKey,
	GlCategorizationHierarchy.GlAccountCode,
	GlCategorizationHierarchy.GLAccountName,
	GlCategorizationHierarchy.GLFinancialCategoryName,
	GlCategorizationHierarchy.InflowOutflow,
	ProfitabilityActual.ReimbursableKey,
	@FeeAdjustmentKey AS FeeAdjustmentKey,
	ProfitabilityActual.FunctionalDepartmentKey,
	ProfitabilityActual.OverheadKey,
	Calendar.CalendarPeriod,	
    CONVERT(varchar(10),ISNULL(ProfitabilityActual.EntryDate,''), 101) AS EntryDate,
    ProfitabilityActual.[User],
    ProfitabilityActual.Description,
    ProfitabilityActual.AdditionalDescription,
    CASE
		WHEN @_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
		ELSE ProfitabilityActual.PropertyFundCode
	END AS 'PropertyFundCode',
	CASE
		WHEN @_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
		ELSE ProfitabilityActual.OriginatingRegionCode
	END AS 'OriginatingRegionCode',
	ProfitabilityActual.FunctionalDepartmentCode,
	
    -- Expenses must be displayed as negative an Income is saved in MRI as negative
	SUM (
			#ExchangeRate.Rate * -1 *
			CASE
				WHEN Calendar.CalendarPeriod = @ReportExpensePeriodParameter THEN ProfitabilityActual.LocalActual
				ELSE 0.0
			END
		) AS MtdActual,
	NULL as MtdBudget,
	NULL as MtdReforecastQ1,
	NULL as MtdReforecastQ2,
	NULL as MtdReforecastQ3,
	
	SUM(
		#ExchangeRate.Rate * -1 *
		CASE WHEN (Calendar.CalendarPeriod <= @ReportExpensePeriodParameter) THEN
			ProfitabilityActual.LocalActual
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
	ProfitabilityActual
	
	INNER JOIN Overhead ON
		ProfitabilityActual.Overheadkey = Overhead.OverheadKey
	
	INNER JOIN #ExchangeRate ON
		ProfitabilityActual.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
		ProfitabilityActual.CalendarKey = #ExchangeRate.CalendarKey    
    
	INNER JOIN #EntityFilterTable ON
		ProfitabilityActual.PropertyFundKey = #EntityFilterTable.PropertyFundKey

	INNER JOIN Currency ON
		#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey
		
	INNER JOIN Reimbursable ON
		ProfitabilityActual.ReimbursableKey = Reimbursable.ReimbursableKey

	INNER JOIN #OriginatingSubRegionFilterTable ON
		ProfitabilityActual.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey

	INNER JOIN Calendar ON
		ProfitabilityActual.CalendarKey = Calendar.CalendarKey
    
    INNER JOIN [Source] ON 
		[Source].SourceKey = ProfitabilityActual.SourceKey

	INNER JOIN #OverheadFilterTable ON
		ProfitabilityActual.OverheadKey = #OverheadFilterTable.OverheadKey
		
	INNER JOIN #ActivityTypeFilterTable ON
		ProfitabilityActual.ActivityTypeKey = #ActivityTypeFilterTable.ActivityTypeKey
		
	INNER JOIN #AllocationSubRegionFilterTable ON	
		ProfitabilityActual.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey    
    			
    			
	INNER JOIN GlCategorizationHierarchy ON GlCategorizationHierarchy.GLCategorizationHierarchyKey = 
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
	Calendar.CalendarYear = STR(@CalendarYear, 10, 0) AND
	Currency.CurrencyCode = @_DestinationCurrency AND
	GlCategorizationHierarchy.GLMinorCategoryName <> 'Architects & Engineering' /* IMS 51655 */ 
	
	
GROUP BY
	GlCategorizationHierarchy.GLCategorizationHierarchyKey,
	ProfitabilityActual.GlobalGlAccountCategoryKey,
    ProfitabilityActual.ActivityTypeKey,
    ProfitabilityActual.PropertyFundKey,
    ProfitabilityActual.AllocationRegionKey,
    ProfitabilityActual.ConsolidationRegionKey,
    ProfitabilityActual.OriginatingRegionKey,
	CASE
		WHEN @_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
		ELSE Source.SourceName
	END,
	GlCategorizationHierarchy.GlAccountCode,
	GlCategorizationHierarchy.GLAccountName,
	GlCategorizationHierarchy.GLFinancialCategoryName,
	GlCategorizationHierarchy.InflowOutflow,
    ProfitabilityActual.SourceKey,
    ProfitabilityActual.GlAccountKey,
	ProfitabilityActual.ReimbursableKey,
	ProfitabilityActual.FunctionalDepartmentKey,
	ProfitabilityActual.OverheadKey,
	Calendar.CalendarPeriod,	
    CONVERT(varchar(10),ISNULL(ProfitabilityActual.EntryDate,''), 101),
    ProfitabilityActual.[User],
    ProfitabilityActual.Description,
    ProfitabilityActual.AdditionalDescription,
    CASE
		WHEN @_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
		ELSE ProfitabilityActual.PropertyFundCode
	END,
    CASE
		WHEN @_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
		ELSE ProfitabilityActual.OriginatingRegionCode
	END,
	ProfitabilityActual.FunctionalDepartmentCode
	
/* ============================================================================================================================
	Add Budgets
============================================================================================================================= */
	
INSERT INTO #ProfitabilityReport
SELECT -- TOP 0
	GlCategorizationHierarchy.GLCategorizationHierarchyKey AS 'GLCategorizationHierarchyKey',
    ProfitabilityBudget.ActivityTypeKey,
    ProfitabilityBudget.PropertyFundKey,
    ProfitabilityBudget.AllocationRegionKey,
    ProfitabilityBudget.ConsolidationRegionKey,
    ProfitabilityBudget.OriginatingRegionKey,
	CASE
		WHEN @_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
		ELSE Source.SourceName
	END AS 'SourceName',    
	ProfitabilityBudget.SourceKey AS SourceKey,
	GlCategorizationHierarchy.GlAccountCode,
	GlCategorizationHierarchy.GLAccountName,
	GlCategorizationHierarchy.GLFinancialCategoryName,
	GlCategorizationHierarchy.InflowOutflow,
	ProfitabilityBudget.ReimbursableKey,
	ProfitabilityBudget.FeeAdjustmentKey,
	ProfitabilityBudget.FunctionalDepartmentKey,
	ProfitabilityBudget.OverheadKey,
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
		#ExchangeRate.Rate * (CASE WHEN GlCategorizationHierarchy.InflowOutflow = @InflowOutflowIncome THEN
					1
				   ELSE
					-1 
				   END) *
		CASE WHEN (Calendar.CalendarPeriod = @ReportExpensePeriodParameter) THEN
			ProfitabilityBudget.LocalBudget
		ELSE
			0
		END
	) as MtdBudget,
	NULL as MtdReforecastQ1,
	NULL as MtdReforecastQ2,
	NULL as MtdReforecastQ3,
	
	NULL as YtdActual,	
	SUM(
		#ExchangeRate.Rate * (CASE WHEN GlCategorizationHierarchy.InflowOutflow = @InflowOutflowIncome THEN
					1
				   ELSE
					-1 
				   END) * 
		CASE WHEN (Calendar.CalendarPeriod <= @ReportExpensePeriodParameter) THEN
			ProfitabilityBudget.LocalBudget
		ELSE
			0
		END
	) as YtdBudget, 
	NULL as YtdReforecastQ1, 
	NULL as YtdReforecastQ2, 
	NULL as YtdReforecastQ3, 
	
	SUM(#ExchangeRate.Rate * ProfitabilityBudget.LocalBudget * (CASE WHEN GlCategorizationHierarchy.InflowOutflow = @InflowOutflowIncome THEN
									1
								  ELSE
									-1 
								  END)) as AnnualBudget,
	NULL as AnnualReforecastQ1,
	NULL as AnnualReforecastQ2,
	NULL as AnnualReforecastQ3
	
FROM
	ProfitabilityBudget		

	INNER JOIN Overhead ON
		ProfitabilityBudget.Overheadkey = Overhead.OverheadKey
	
	INNER JOIN #ExchangeRate ON
		ProfitabilityBudget.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
		ProfitabilityBudget.CalendarKey = #ExchangeRate.CalendarKey    
    
	INNER JOIN #EntityFilterTable ON
		ProfitabilityBudget.PropertyFundKey = #EntityFilterTable.PropertyFundKey

	INNER JOIN Currency ON
		#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey
		
	INNER JOIN Reimbursable ON
		ProfitabilityBudget.ReimbursableKey = Reimbursable.ReimbursableKey

	INNER JOIN #OriginatingSubRegionFilterTable ON
		ProfitabilityBudget.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey

	INNER JOIN Calendar ON
		ProfitabilityBudget.CalendarKey = Calendar.CalendarKey
    
    INNER JOIN [Source] ON 
		[Source].SourceKey = ProfitabilityBudget.SourceKey

	INNER JOIN #OverheadFilterTable ON
		ProfitabilityBudget.OverheadKey = #OverheadFilterTable.OverheadKey
		
	INNER JOIN #ActivityTypeFilterTable ON
		ProfitabilityBudget.ActivityTypeKey = #ActivityTypeFilterTable.ActivityTypeKey
		
	INNER JOIN #AllocationSubRegionFilterTable ON	
		ProfitabilityBudget.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey    
    			
	  			
	INNER JOIN GlCategorizationHierarchy ON GlCategorizationHierarchy.GLCategorizationHierarchyKey = 
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
	
	--INNER JOIN GLCategorizationHierarchy GlobalGLCategorizationHierarchy ON
	--	ProfitabilityBudget.GlobalGLCategorizationHierarchyKey = GlobalGLCategorizationHierarchy.GLCategorizationHierarchyKey	
		
WHERE  
	Calendar.CalendarYear = STR(@CalendarYear, 10, 0) AND
	Currency.CurrencyCode = @_DestinationCurrency AND
	GlCategorizationHierarchy.GLMinorCategoryName <> 'Architects & Engineering' /* IMS 51655 */
GROUP BY
	GlCategorizationHierarchy.GLCategorizationHierarchyKey,
	ProfitabilityBudget.GlobalGlAccountCategoryKey,
    ProfitabilityBudget.ActivityTypeKey,
    ProfitabilityBudget.PropertyFundKey,
    ProfitabilityBudget.AllocationRegionKey,
    ProfitabilityBudget.ConsolidationRegionKey,
    ProfitabilityBudget.OriginatingRegionKey,
	CASE
		WHEN @_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
		ELSE Source.SourceName
	END,
	GlCategorizationHierarchy.GlAccountCode,
	GlCategorizationHierarchy.GLAccountName,
	GlCategorizationHierarchy.GLFinancialCategoryName,
	GlCategorizationHierarchy.InflowOutflow,
    ProfitabilityBudget.SourceKey,
    ProfitabilityBudget.GlAccountKey,
	ProfitabilityBudget.ReimbursableKey,
	ProfitabilityBudget.FeeAdjustmentKey,
	ProfitabilityBudget.FunctionalDepartmentKey,
	ProfitabilityBudget.OverheadKey,
	Calendar.CalendarPeriod
   
   
/* ============================================================================================================================
	Add Reforecasts
============================================================================================================================= */
   

INSERT INTO #ProfitabilityReport
SELECT --TOP 100
	ProfitabilityReforecast.GlobalGlAccountCategoryKey,
    ProfitabilityReforecast.ActivityTypeKey,
    ProfitabilityReforecast.PropertyFundKey,
    ProfitabilityReforecast.AllocationRegionKey,
    ProfitabilityReforecast.ConsolidationRegionKey,
    ProfitabilityReforecast.OriginatingRegionKey,
	CASE
		WHEN @_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
		ELSE Source.SourceName
	END AS 'SourceName',        
    ProfitabilityReforecast.SourceKey,
	GlCategorizationHierarchy.GlAccountCode,
	GlCategorizationHierarchy.GLAccountName,
	GlCategorizationHierarchy.GLFinancialCategoryName,
	GlCategorizationHierarchy.InflowOutflow,
	ProfitabilityReforecast.ReimbursableKey,
	ProfitabilityReforecast.FeeAdjustmentKey,
	ProfitabilityReforecast.FunctionalDepartmentKey,
	ProfitabilityReforecast.OverheadKey,
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
		#ExchangeRate.Rate * (CASE WHEN  GlCategorizationHierarchy.InflowOutflow = @InflowOutflowIncome THEN
					1
				   ELSE
					-1 
				   END) * 
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        CASE WHEN (Calendar.CalendarPeriod = @ReportExpensePeriodParameter) THEN
			ProfitabilityReforecast.LocalReforecast
		ELSE
			0
		END
	) as MtdReforecastQ1,
	NULL as MtdReforecastQ2,
	NULL as MtdReforecastQ3,
	
	NULL as YtdActual,	
	NULL as YtdBudget, 
	SUM(
		#ExchangeRate.Rate * (CASE WHEN GlCategorizationHierarchy.InflowOutflow = @InflowOutflowIncome THEN
					1
				   ELSE
					-1 
				   END) * 
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
        CASE WHEN (Calendar.CalendarPeriod <= @ReportExpensePeriodParameter) THEN
			ProfitabilityReforecast.LocalReforecast
		ELSE
			0
		END
	) as YtdReforecastQ1, 
	NULL as YtdReforecastQ2, 
	NULL as YtdReforecastQ3, 
	
	NULL as AnnualBudget, 
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it's available (i.e we import it)*/
    
     SUM(#ExchangeRate.Rate * ProfitabilityReforecast.LocalReforecast * (CASE WHEN GlCategorizationHierarchy.InflowOutflow = @InflowOutflowIncome THEN
										  1
									    ELSE
										 -1 
									    END)) as AnnualReforecastQ1,								    
	 
     NULL as AnnualReforecastQ2,								    
     NULL as AnnualReforecastQ3

FROM
	ProfitabilityReforecast
	
	INNER JOIN Overhead ON
		ProfitabilityReforecast.Overheadkey = Overhead.OverheadKey
	
	INNER JOIN #ExchangeRate ON
		ProfitabilityReforecast.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
		ProfitabilityReforecast.CalendarKey = #ExchangeRate.CalendarKey    
    
	INNER JOIN #EntityFilterTable ON
		ProfitabilityReforecast.PropertyFundKey = #EntityFilterTable.PropertyFundKey

	INNER JOIN Currency ON
		#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey
		
	INNER JOIN Reimbursable ON
		ProfitabilityReforecast.ReimbursableKey = Reimbursable.ReimbursableKey

	INNER JOIN #OriginatingSubRegionFilterTable ON
		ProfitabilityReforecast.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey

	INNER JOIN Calendar ON
		ProfitabilityReforecast.CalendarKey = Calendar.CalendarKey
    
    INNER JOIN [Source] ON 
		[Source].SourceKey = ProfitabilityReforecast.SourceKey

	INNER JOIN #OverheadFilterTable ON
		ProfitabilityReforecast.OverheadKey = #OverheadFilterTable.OverheadKey
		
	INNER JOIN #ActivityTypeFilterTable ON
		ProfitabilityReforecast.ActivityTypeKey = #ActivityTypeFilterTable.ActivityTypeKey
		
	INNER JOIN #AllocationSubRegionFilterTable ON	
		ProfitabilityReforecast.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey    
    			
	INNER JOIN GlCategorizationHierarchy ON GlCategorizationHierarchy.GLCategorizationHierarchyKey = 
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
		
WHERE  
	Calendar.CalendarYear = STR(@CalendarYear, 10, 0) AND
	Currency.CurrencyCode = @_DestinationCurrency AND
	GlCategorizationHierarchy.GLMinorCategoryName <> 'Architects & Engineering' /* IMS 51655 */
GROUP BY
	GlCategorizationHierarchy.GLCategorizationHierarchyKey,
	ProfitabilityReforecast.GlobalGlAccountCategoryKey,
    ProfitabilityReforecast.ActivityTypeKey,
    ProfitabilityReforecast.PropertyFundKey,
    ProfitabilityReforecast.AllocationRegionKey,
    ProfitabilityReforecast.ConsolidationRegionKey,
    ProfitabilityReforecast.OriginatingRegionKey,
	CASE
		WHEN @_DontSensitizeMRIPayrollData = 0 AND GlCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
		ELSE Source.SourceName
	END,
	GlCategorizationHierarchy.GlAccountCode,
	GlCategorizationHierarchy.GLAccountName,
	GlCategorizationHierarchy.GLFinancialCategoryName,
	GlCategorizationHierarchy.InflowOutflow,
    ProfitabilityReforecast.SourceKey,
    ProfitabilityReforecast.GlAccountKey,
	ProfitabilityReforecast.ReimbursableKey,
	ProfitabilityReforecast.FeeAdjustmentKey,
	ProfitabilityReforecast.FunctionalDepartmentKey,
	ProfitabilityReforecast.OverheadKey,
	Calendar.CalendarPeriod	
	

/* ============================================================================================================================
	Add Output
============================================================================================================================= */

SELECT 
	#ProfitabilityReport.GLFinancialCategoryName AS ExpenseType, 
	#ProfitabilityReport.InflowOutflow AS 'InflowOutflow',
	CategorizationHierarchyInWarehouse.GLMajorCategoryName AS 'MajorExpenseCategoryName',
	CategorizationHierarchyInWarehouse.GLMinorCategoryName AS 'MinorExpenseCategoryName',
	ActivityType.BusinessLineName AS BusinessLine,
    ActivityType.ActivityTypeName AS ActivityType,
	CASE 
		WHEN (CategorizationHierarchyInWarehouse.GLMajorCategoryName = 'Salaries/Taxes/Benefits') THEN 
			'Sensitized' 
		ELSE PropertyFund.PropertyFundName END 
		AS 'ReportingEntityName',
		
	PropertyFund.PropertyFundType AS ReportingEntityType,
	AllocationRegion.SubRegionName AS AllocationSubRegionName,
	ConsolidationRegion.SubRegionName as ConsolidationSubRegionName,
    OriginatingRegion.SubRegionName as OriginatingSubRegionName,
	CASE WHEN (CategorizationHierarchyInWarehouse.GLMajorCategoryName = 'Salaries/Taxes/Benefits') THEN 
		'Sensitized' ELSE #ProfitabilityReport.GlAccountCode END AS GlobalGlAccountCode,
    CASE WHEN (CategorizationHierarchyInWarehouse.GLMajorCategoryName = 'Salaries/Taxes/Benefits') THEN 
    'Sensitized' ELSE #ProfitabilityReport.GlAccountName END AS GlobalGlAccountName,    
	Reimbursable.ReimbursableName,
	FeeAdjustment.FeeAdjustmentCode,
	#ProfitabilityReport.SourceName,
	#ProfitabilityReport.GLCategorizationHierarchyKey, -- gac.GlAccountCategoryKey,
	
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
	SUM(ISNULL(#ProfitabilityReport.MtdActual,0)) AS MtdActual,
	SUM(ISNULL(#ProfitabilityReport.MtdBudget,0)) AS MtdOriginalBudget,
	
	SUM(ISNULL(#ProfitabilityReport.MtdReforecastQ1,0))AS MtdReforecastQ1,
	SUM(ISNULL(#ProfitabilityReport.MtdReforecastQ2,0))AS MtdReforecastQ2,
	SUM(ISNULL(#ProfitabilityReport.MtdReforecastQ3,0))AS MtdReforecastQ3,

	/* Enhanced case statement: IMS 58120 */

	CASE WHEN #ProfitabilityReport.InflowOutflow = @InflowOutflowExpense AND NOT 
		( Reimbursable.ReimbursableName = 'Reimbursable' AND 
			(#ProfitabilityReport.GLFinancialCategoryName = 'Payroll' OR #ProfitabilityReport.GLFinancialCategoryName = 'Overhead') ) 
		THEN SUM(ISNULL(MtdBudget,0)) - SUM(ISNULL(MtdActual,0)) ELSE SUM(ISNULL(#ProfitabilityReport.MtdActual,0)) - SUM(ISNULL(MtdBudget,0)) END AS MtdVarianceQ0,
	CASE WHEN #ProfitabilityReport.InflowOutflow = @InflowOutflowExpense AND NOT ( Reimbursable.ReimbursableName = 'Reimbursable' AND (#ProfitabilityReport.GLFinancialCategoryName = 'Payroll' OR #ProfitabilityReport.GLFinancialCategoryName = 'Overhead') ) THEN SUM(ISNULL(#ProfitabilityReport.MtdReforecastQ1,0)) - SUM(ISNULL(MtdActual,0)) ELSE SUM(ISNULL(MtdActual,0)) - SUM(ISNULL(#ProfitabilityReport.MtdReforecastQ1,0)) END AS MtdVarianceQ1,
	CASE WHEN #ProfitabilityReport.InflowOutflow = @InflowOutflowExpense AND NOT ( Reimbursable.ReimbursableName = 'Reimbursable' AND (#ProfitabilityReport.GLFinancialCategoryName = 'Payroll' OR #ProfitabilityReport.GLFinancialCategoryName = 'Overhead') ) THEN SUM(ISNULL(#ProfitabilityReport.MtdReforecastQ2,0)) - SUM(ISNULL(MtdActual,0)) ELSE SUM(ISNULL(MtdActual,0)) - SUM(ISNULL(#ProfitabilityReport.MtdReforecastQ2,0)) END AS MtdVarianceQ2,
	CASE WHEN #ProfitabilityReport.InflowOutflow = @InflowOutflowExpense AND NOT ( Reimbursable.ReimbursableName = 'Reimbursable' AND (#ProfitabilityReport.GLFinancialCategoryName = 'Payroll' OR #ProfitabilityReport.GLFinancialCategoryName = 'Overhead') ) THEN SUM(ISNULL(#ProfitabilityReport.MtdReforecastQ3,0)) - SUM(ISNULL(MtdActual,0)) ELSE SUM(ISNULL(MtdActual,0)) - SUM(ISNULL(#ProfitabilityReport.MtdReforecastQ3,0)) END AS MtdVarianceQ3,
	
	--Year to date
	SUM(ISNULL(#ProfitabilityReport.YtdActual,0)) AS YtdActual,	
	SUM(ISNULL(#ProfitabilityReport.YtdBudget,0)) AS YtdOriginalBudget,
	
	SUM(ISNULL(#ProfitabilityReport.YtdReforecastQ1,0)) AS YtdReforecastQ1,
	SUM(ISNULL(#ProfitabilityReport.YtdReforecastQ2,0)) YtdReforecastQ2,
	SUM(ISNULL(#ProfitabilityReport.YtdReforecastQ3,0)) YtdReforecastQ3,
	
	/* Enhanced case statement: IMS 58120 */

	CASE WHEN #ProfitabilityReport.InflowOutflow = @InflowOutflowExpense AND NOT ( Reimbursable.ReimbursableName = 'Reimbursable' AND (#ProfitabilityReport.GLFinancialCategoryName = 'Payroll' OR #ProfitabilityReport.GLFinancialCategoryName = 'Overhead') ) THEN SUM(ISNULL(YtdBudget,0)) - SUM(ISNULL(YtdActual,0)) ELSE SUM(ISNULL(#ProfitabilityReport.YtdActual,0)) - SUM(ISNULL(YtdBudget,0)) END AS YtdVarianceQ0,
	CASE WHEN #ProfitabilityReport.InflowOutflow = @InflowOutflowExpense AND NOT ( Reimbursable.ReimbursableName = 'Reimbursable' AND (#ProfitabilityReport.GLFinancialCategoryName = 'Payroll' OR #ProfitabilityReport.GLFinancialCategoryName = 'Overhead') ) THEN SUM(ISNULL(#ProfitabilityReport.YtdReforecastQ1,0)) - SUM(ISNULL(YtdActual,0)) ELSE SUM(ISNULL(YtdActual,0)) - SUM(ISNULL(#ProfitabilityReport.YtdReforecastQ1,0)) END AS YtdVarianceQ1,
	CASE WHEN #ProfitabilityReport.InflowOutflow = @InflowOutflowExpense AND NOT ( Reimbursable.ReimbursableName = 'Reimbursable' AND (#ProfitabilityReport.GLFinancialCategoryName = 'Payroll' OR #ProfitabilityReport.GLFinancialCategoryName = 'Overhead') ) THEN SUM(ISNULL(#ProfitabilityReport.YtdReforecastQ2,0)) - SUM(ISNULL(YtdActual,0)) ELSE SUM(ISNULL(YtdActual,0)) - SUM(ISNULL(#ProfitabilityReport.YtdReforecastQ2,0)) END AS YtdVarianceQ2,
	CASE WHEN #ProfitabilityReport.InflowOutflow = @InflowOutflowExpense AND NOT ( Reimbursable.ReimbursableName = 'Reimbursable' AND (#ProfitabilityReport.GLFinancialCategoryName = 'Payroll' OR #ProfitabilityReport.GLFinancialCategoryName = 'Overhead') ) THEN SUM(ISNULL(#ProfitabilityReport.YtdReforecastQ3,0)) - SUM(ISNULL(YtdActual,0)) ELSE SUM(ISNULL(YtdActual,0)) - SUM(ISNULL(#ProfitabilityReport.YtdReforecastQ3,0)) END AS YtdVarianceQ3,
	
	--Annual
	SUM(ISNULL(#ProfitabilityReport.AnnualBudget,0)) AS AnnualOriginalBudget,	
	SUM(ISNULL(#ProfitabilityReport.AnnualReforecastQ1,0)) AS AnnualReforecastQ1,
	SUM(ISNULL(#ProfitabilityReport.AnnualReforecastQ2,0)) AS AnnualReforecastQ2,
	SUM(ISNULL(#ProfitabilityReport.AnnualReforecastQ3,0)) AS AnnualReforecastQ3

INTO
	[#Output]
FROM
	#ProfitabilityReport

	INNER JOIN Overhead oh ON 
		oh.OverheadKey = #ProfitabilityReport.OverheadKey	
		
	INNER JOIN Reimbursable ON
		#ProfitabilityReport.ReimbursableKey = Reimbursable.ReimbursableKey
    
    INNER JOIN [Source] ON 
		[Source].SourceKey = #ProfitabilityReport.SourceKey
		
	INNER JOIN GLCategorizationHierarchy CategorizationHierarchyInWarehouse ON
		#ProfitabilityReport.GLCategorizationHierarchyKey = CategorizationHierarchyInWarehouse.GLCategorizationHierarchyKey
		   
    INNER JOIN OriginatingRegion ON 
		OriginatingRegion.OriginatingRegionKey = #ProfitabilityReport.OriginatingRegionKey

    INNER JOIN AllocationRegion ConsolidationRegion ON 
		ConsolidationRegion.AllocationRegionKey = #ProfitabilityReport.ConsolidationRegionKey
    
    INNER JOIN AllocationRegion ON 
		AllocationRegion.AllocationRegionKey = #ProfitabilityReport.AllocationRegionKey
		
    INNER JOIN ActivityType ON  
		ActivityType.ActivityTypeKey = #ProfitabilityReport.ActivityTypeKey
		
    INNER JOIN PropertyFund ON 
		PropertyFund.PropertyFundKey = #ProfitabilityReport.PropertyFundKey
		
    INNER JOIN FeeAdjustment ON 
		FeeAdjustment.FeeAdjustmentKey = #ProfitabilityReport.FeeAdjustmentKey
		
GROUP BY
	#ProfitabilityReport.GLFinancialCategoryName, 
	#ProfitabilityReport.InflowOutflow,
	CategorizationHierarchyInWarehouse.GLMajorCategoryName,
	CategorizationHierarchyInWarehouse.GLMinorCategoryName,
	ActivityType.BusinessLineName,
    ActivityType.ActivityTypeName,
	CASE 
		WHEN (CategorizationHierarchyInWarehouse.GLMajorCategoryName = 'Salaries/Taxes/Benefits') THEN 
			'Sensitized' 
		ELSE PropertyFund.PropertyFundName END,		
	PropertyFund.PropertyFundType,
	AllocationRegion.SubRegionName,
	ConsolidationRegion.SubRegionName,
    OriginatingRegion.SubRegionName,
	CASE WHEN (CategorizationHierarchyInWarehouse.GLMajorCategoryName = 'Salaries/Taxes/Benefits') THEN 
		'Sensitized' ELSE #ProfitabilityReport.GlAccountCode END,
    CASE WHEN (CategorizationHierarchyInWarehouse.GLMajorCategoryName = 'Salaries/Taxes/Benefits') THEN 
    'Sensitized' ELSE #ProfitabilityReport.GlAccountName END,    
	Reimbursable.ReimbursableName,
	FeeAdjustment.FeeAdjustmentCode,
	#ProfitabilityReport.SourceName,
	#ProfitabilityReport.GLCategorizationHierarchyKey, -- gac.GlAccountCategoryKey,
	
	#ProfitabilityReport.CalendarPeriod,
    #ProfitabilityReport.EntryDate,
    #ProfitabilityReport.[User],
    #ProfitabilityReport.[Description],
    #ProfitabilityReport.AdditionalDescription,
	#ProfitabilityReport.PropertyFundCode,
	#ProfitabilityReport.FunctionalDepartmentCode,
    #ProfitabilityReport.OriginatingRegionCode

/* ============================================================================================================================
	Return Results
============================================================================================================================= */

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
	
	
--SELECT SUM(MtdActual) from [#output]

/* ============================================================================================================================
	Clean up Resources
============================================================================================================================= */
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
    
END
    
GO


