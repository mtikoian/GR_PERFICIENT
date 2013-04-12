USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOwner]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[stp_R_BudgetOwner]
GO

USE [GrReporting]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[stp_R_BudgetOwner]
	@ReportExpensePeriod INT,
	@ReforecastQuarterName VARCHAR(2), --'Q0' or 'Q1' or 'Q2' or 'Q3'
	@DestinationCurrency VARCHAR(3),
	@EntityList VARCHAR(8000),
	@DontSensitizeMRIPayrollData BIT,
	@CalculationMethod VARCHAR(50),
	@OriginatingSubRegionList VARCHAR(8000),
	@AllocationSubRegionList VARCHAR(8000),
	@FunctionalDepartmentList VARCHAR(8000),	
	@HierarchyReportParameter dbo.ReportParameterGLCategorizationHierarchyDetail READONLY,
	@IncludeLocalCategorization BIT

AS

/*********************************************************************************************************************
Description
	The stored procedure is used for generating the data for the Budget Owner Report.
	
	Gross Mode: Includes all transactions
	Net Mode: Include only reimbursable costs
	
	MRI Source Sensitization: We need to sensitize source data that we group on for payroll transactions. For
	regions where there is one or two employees, the employee salary can be deduced from a payroll amount for that
	region. we therefore need to sensitize various fields like minor/major category, mri source and originating region. 
	This is controlled by the @DontSensitizeMRIPayrollData parameter.
	
	STEPS:
	
	STEP 1: Declare local variables - use this to easily set up test script
	STEP 2: Set up the Report Filter Variable defaults
	STEP 3: Set up Direct/Indirect Mapping
	STEP 4: Set up Local/Non-Local Mapping
	STEP 5: Set up the Report Filter Tables - We create temp tables containing the records of each parameter dimention
											  We can easily filter our data by inner joining onto these tables
											  
											  Note that we pass through the names of these parameters. If the name of the 
											  record was changed, we still want to return results for all it's related transactions.
											  Therefore we use views which return the latest state in a dimension to get all the 
											  records related to that entity.
	STEP 6: Create results temp table
	STEP 7: Get Profitability Actual Data - NOTE: we group the transactions here to get a total amount for each type of transaction
	STEP 8: Get Profitability Budget Data
	STEP 9: Get Profitability Reforecast Data
	STEP 10: Get Total Summary Per cost point
	STEP 11: Get Final Results

	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-07-08		: PKayongo	:	Sensitized payroll data for the MRI Source, Originating Region Code and 
											Property Fund fields. (CC20)
			2011-07-11		: PKayongo	:	Allowed reforecast values to be dynamically selected from the 
											@ReforecastQuarterName variable. Only 1 reforecast dynamic query remained
											and only the different reforecast fields at the end (i.e. Q1, Q2, Q3)
											were consolidated into 1.
			2011-08-08		: SNothling	:	Set sensitized strings to 'Sensitized' instead of ''

**********************************************************************************************************************/

BEGIN

/* ===============================================================================================================================================
	STEP 1: Declare local variables - this makes debugging and testing easier	

		NOTE: We do not specify parameter defaults. We assume that all parameters have been saved correctly and completely in GRP, and we want the
			stored procedure to break if an expected parameter is not passed through. This prevents unexpected behaviour.
   ============================================================================================================================================= */

BEGIN 

	DECLARE
		@_ReportExpensePeriod INT				 = @ReportExpensePeriod,
		@_ReforecastQuarterName CHAR(2)			 = @ReforecastQuarterName,
		@_DestinationCurrency CHAR(3)			 = @DestinationCurrency,
		@_EntityList VARCHAR(MAX)				 = @EntityList,
		@_DontSensitizeMRIPayrollData BIT		 = @DontSensitizeMRIPayrollData,
		@_CalculationMethod VARCHAR(MAX)		 = @CalculationMethod,
		@_FunctionalDepartmentList VARCHAR (MAX) = @FunctionalDepartmentList,
		@_OriginatingSubRegionList VARCHAR(MAX)  = @OriginatingSubRegionList,
		@_AllocationSubRegionList  VARCHAR(MAX)  = @AllocationSubRegionList,
		@_IncludeLocalCategorization BIT		 = @IncludeLocalCategorization
	
END
			
/* ===============================================================================================================================================
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
   ============================================================================================================================================= */

BEGIN

	-- Calculate default report expense period if none specified
	IF @_ReportExpensePeriod IS NULL
		SET @_ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + REPLACE(STR(MONTH(GETDATE()),2 ),' ','0')AS INT)

	-- Calculate destination currency if none specified
	IF @_DestinationCurrency IS NULL
		SET @_DestinationCurrency = 'USD'

	-- Pre-format Report Expense period string
	DECLARE @ReportExpensePeriodParameter VARCHAR(6) = STR(@_ReportExpensePeriod, 6, 0)

	-- Calculate default calendar year if none specified
	DECLARE @CalendarYear AS VARCHAR(10) = SUBSTRING(CAST(@_ReportExpensePeriod AS VARCHAR(6)), 1, 4)

	-- Calculate default reforecast quarter name if not specified
	IF @_ReforecastQuarterName IS NULL OR @_ReforecastQuarterName NOT IN ('Q0', 'Q1', 'Q2', 'Q3')
		SET @_ReforecastQuarterName =
			(	
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
	DECLARE @ReforecastEffectivePeriod INT =
			(
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
	DECLARE @ActiveReforecastKey INT =
			(
				SELECT
					ReforecastKey
				FROM
					dbo.GetReforecastRecord(@_ReportExpensePeriod, @_ReforecastQuarterName)
			)

	-- Safeguard against NULL ReforecastKey returned from previous statement

	IF (@ActiveReforecastKey IS NULL)
	BEGIN
		SET @ActiveReforecastKey =
			(
				SELECT
					MAX(ReforecastKey)
				FROM
					dbo.ExchangeRate
			)
		PRINT ('Near disaster: @ActiveReforecastKey is NULL, so reverting to the largest/most recent ReforecastKey in dbo.ExchangeRate: ' + CONVERT(VARCHAR(10), @ActiveReforecastKey))
	END

	-- Determine Report Exchange Rates	
	-- get the exchange rate set for the specified reforecast

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

/* ===============================================================================================================================================
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
   ============================================================================================================================================= */
BEGIN

	CREATE TABLE #DirectIndirectMapping
	(
		SourceName VARCHAR(50) PRIMARY KEY,
		DirectIndirect VARCHAR(10),
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

/* ===============================================================================================================================================
	STEP 4: Set up Local/Non-Local Mapping
	
		a.	The Local/Non-local field will read “local” when the allocation sub region and the originating sub-region are the same (except for
				China).
		b.	The Local/Non-local field will read “non-local” when the allocation sub region and originating sub-region differ (except for China).
		c.	For China, the four regions of China (Beijing, Shanghai, Tianjin and Chengdu) will be treated as local (i.e. if the allocation region
				is China and the originating region is Beijing, then the Local/Non-local field will be “local” however, if the allocation region
				is China and the originating region is New York, then the Local/Non-local field will be “non-local”).
   ============================================================================================================================================ */
BEGIN

	CREATE TABLE #LocalNonLocalMapping
	(
	  OriginatingRegionName VARCHAR (50),
	  OriginatingSubRegionName VARCHAR(50),
	  AllocationRegionName VARCHAR (50),
	  AllocationSubRegionName VARCHAR(50),
	  LocalNonLocal VARCHAR (10),
	)
	INSERT INTO #LocalNonLocalMapping
	SELECT
		OriginatingRegion.RegionName,
		OriginatingRegion.SubRegionName,
		AllocationRegion.RegionName,
		AllocationRegion.SubRegionName,
		'Local'
	FROM
		dbo.ProfitabilityActual
		INNER JOIN dbo.OriginatingRegion ON
			ProfitabilityActual.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey
		INNER JOIN dbo.AllocationRegion ON
			ProfitabilityActual.AllocationRegionKey = AllocationRegion.AllocationRegionKey
	WHERE
		(
			OriginatingRegion.SubRegionName = AllocationRegion.SubRegionName AND
			AllocationRegion.RegionName <> 'China' AND
			OriginatingRegion.RegionName <> 'China'
		)
		OR
		(
			AllocationRegion.RegionName = 'China' AND
			OriginatingRegion.RegionName = 'China'
		)

	UNION

	SELECT
		OriginatingRegion.RegionName,
		OriginatingRegion.SubRegionName,
		AllocationRegion.RegionName,
		AllocationRegion.SubRegionName,
		'Non-Local'
	FROM
		dbo.ProfitabilityActual
		INNER JOIN dbo.OriginatingRegion ON
			ProfitabilityActual.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey
		INNER JOIN dbo.AllocationRegion ON
			ProfitabilityActual.AllocationRegionKey = AllocationRegion.AllocationRegionKey
	WHERE
		(
			OriginatingRegion.SubRegionName <> AllocationRegion.SubRegionName AND
			AllocationRegion.RegionName <> 'China' AND
			OriginatingRegion.RegionName <> 'China'
		)
		OR
		(
			OriginatingRegion.SubRegionName <> AllocationRegion.SubRegionName AND
			AllocationRegion.RegionName = 'China' AND
			OriginatingRegion.RegionName <> 'China'
		)
		OR
		(
			OriginatingRegion.SubRegionName <> AllocationRegion.SubRegionName AND
			AllocationRegion.RegionName <> 'China' AND
			OriginatingRegion.RegionName = 'China'
		)

	UNION

	SELECT 
		OriginatingRegion.RegionName,
		OriginatingRegion.SubRegionName,
		AllocationRegion.RegionName,
		AllocationRegion.SubRegionName,
		'Local'
	FROM
		dbo.ProfitabilityBudget
		INNER JOIN dbo.OriginatingRegion ON
			ProfitabilityBudget.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey
		INNER JOIN dbo.AllocationRegion ON
			ProfitabilityBudget.AllocationRegionKey = AllocationRegion.AllocationRegionKey
	WHERE
		(
			OriginatingRegion.SubRegionName = AllocationRegion.SubRegionName AND
			AllocationRegion.RegionName <> 'China' AND
			OriginatingRegion.RegionName <> 'China'
		)
		OR
		(
			AllocationRegion.RegionName = 'China' AND
			OriginatingRegion.RegionName = 'China'
		)

	UNION

	SELECT 
		OriginatingRegion.RegionName,
		OriginatingRegion.SubRegionName,
		AllocationRegion.RegionName,
		AllocationRegion.SubRegionName,
		'Non-Local'
	FROM
		dbo.ProfitabilityBudget
		INNER JOIN dbo.OriginatingRegion ON
			ProfitabilityBudget.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey
		INNER JOIN dbo.AllocationRegion ON
			ProfitabilityBudget.AllocationRegionKey = AllocationRegion.AllocationRegionKey
	WHERE
		(
			OriginatingRegion.SubRegionName <> AllocationRegion.SubRegionName AND
			AllocationRegion.RegionName <> 'China' AND
			OriginatingRegion.RegionName <> 'China'
		)
		OR
		(
			OriginatingRegion.SubRegionName <> AllocationRegion.SubRegionName AND
			AllocationRegion.RegionName = 'China' AND
			OriginatingRegion.RegionName <> 'China'
		)
		OR
		(
			OriginatingRegion.SubRegionName <> AllocationRegion.SubRegionName AND
			AllocationRegion.RegionName <> 'China' AND
			OriginatingRegion.RegionName = 'China'
		)

	UNION

	SELECT 
		OriginatingRegion.RegionName, 
		OriginatingRegion.SubRegionName, 
		AllocationRegion.RegionName, 
		AllocationRegion.SubRegionName, 
		'Local'
	FROM
		dbo.ProfitabilityReforecast
		INNER JOIN dbo.OriginatingRegion ON 
			ProfitabilityReforecast.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey
		INNER JOIN dbo.AllocationRegion ON 
			ProfitabilityReforecast.AllocationRegionKey = AllocationRegion.AllocationRegionKey
	WHERE
		(
			OriginatingRegion.SubRegionName = AllocationRegion.SubRegionName AND
			AllocationRegion.RegionName <> 'China' AND
			OriginatingRegion.RegionName <> 'China'
		)
		OR
		(
			AllocationRegion.RegionName = 'China' AND
			OriginatingRegion.RegionName = 'China'
		)

	UNION

	SELECT
		OriginatingRegion.RegionName,
		OriginatingRegion.SubRegionName,
		AllocationRegion.RegionName,
		AllocationRegion.SubRegionName,
		'Non-Local'
	FROM
		dbo.ProfitabilityReforecast
		INNER JOIN dbo.OriginatingRegion ON 
			ProfitabilityReforecast.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey 
		INNER JOIN dbo.AllocationRegion ON 
			ProfitabilityReforecast.AllocationRegionKey = AllocationRegion.AllocationRegionKey
	WHERE
		(
			OriginatingRegion.SubRegionName <> AllocationRegion.SubRegionName AND 
			AllocationRegion.RegionName <> 'China' AND 
			OriginatingRegion.RegionName <> 'China'
		)
		OR
		(
			OriginatingRegion.SubRegionName <> AllocationRegion.SubRegionName AND 
			AllocationRegion.RegionName = 'China' AND 
			OriginatingRegion.RegionName <> 'China'
		)
		OR
		(
			OriginatingRegion.SubRegionName <> AllocationRegion.SubRegionName AND 
			AllocationRegion.RegionName <> 'China' AND 
			OriginatingRegion.RegionName = 'China'
		)

END
	
/* ===============================================================================================================================================
	STEP 5: Set up the Report Filter Tables
	
		Note that we pass through the names of these parameters. If the name of the 
		record was changed, we still want to return results for all it's related transactions.
		Therefore we use views which return the latest state in a dimension to get all the 
		records related to that entity.
	
		1. Reporting Entities - Get a table containing all the reporting entities specified in the filter parameter
		2. Originating Sub Regions - Get a table containing all the originating sub regions specified in the filter parameter
		3. Allocation Sub Regions - Get a table containing all the allocation sub regions specified in the filter parameter
   ============================================================================================================================================ */
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
		GLCategorizationHierarchyLatestState.LatestGLMinorCategoryName <> 'Architects & Engineering' AND -- IMS 51655
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
	
/* ===============================================================================================================================================
	STEP 6: Create results temp table

		We will insert all the resulting transaction data into this result temp table:
		
		1. Actuals transactions
		2. Budget transactions
		3. Reforecast transactions
    ============================================================================================================================================ */
BEGIN 

	CREATE TABLE #BudgetOwnerEntity
	(
		ActivityTypeKey					INT,	
		GlobalGLCategorizationKey		INT,
		ReportingGLCategorizationKey	INT,
		AllocationRegionKey				INT,
		OriginatingRegionKey			INT,
		FunctionalDepartmentKey			INT,
		PropertyFundKey					INT,
		ReimbursableKey					INT,
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

/* ===============================================================================================================================================
	STEP 7: Get Profitability Actual Data

		Budget Owner data is only 'Allocated', 'Not Overhead', 'UNKNOWN'
		'Outflow', 'UNKNOWN' only, they only look at expenses, not income
		Exclude 'Architects & Engineering', was re-classified, as per Martin's request
    ============================================================================================================================================ */
BEGIN

	INSERT INTO #BudgetOwnerEntity
	SELECT
		ProfitabilityActual.ActivityTypeKey,
		ProfitabilityActual.GlobalGLCategorizationHierarchyKey,
		ProfitabilityActual.ReportingGLCategorizationHierarchyKey,
		ProfitabilityActual.AllocationRegionKey,
		ProfitabilityActual.OriginatingRegionKey,
		ProfitabilityActual.FunctionalDepartmentKey,
		ProfitabilityActual.PropertyFundKey,
		ProfitabilityActual.ReimbursableKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'
			ELSE
				Source.SourceName
		END AS 'SourceName',
		CONVERT(VARCHAR(10),ISNULL(ProfitabilityActual.LastDate,''), 101) AS EntryDate,
		ProfitabilityActual.[User],
		ProfitabilityActual.Description,
		ProfitabilityActual.AdditionalDescription,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'	
			ELSE
				ProfitabilityActual.PropertyFundCode
		END AS 'PropertyFundCode',
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'	
			ELSE
				ProfitabilityActual.OriginatingRegionCode
		END AS 'OriginatingRegionCode',
		ProfitabilityActual.FunctionalDepartmentCode,
		GlobalHierarchy.GLAccountCode,
		GlobalHierarchy.GLAccountName,
		Calendar.CalendarPeriod,
		SUM
		(
			#ExchangeRate.Rate *
			CASE
				WHEN
					(Calendar.CalendarPeriod = @ReportExpensePeriodParameter)
				THEN
					ProfitabilityActual.LocalActual
				ELSE
					0.0
			END
		) AS 'MtdGrossActual',
		NULL AS 'MtdGrossBudget',
		NULL AS 'MtdGrossReforeCast',
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE
				WHEN
					(Calendar.CalendarPeriod = @ReportExpensePeriodParameter)
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
					(Calendar.CalendarPeriod <= @ReportExpensePeriodParameter)
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
					(Calendar.CalendarPeriod <= @ReportExpensePeriodParameter)
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
					(Calendar.CalendarPeriod <= @ReportExpensePeriodParameter)
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
					(Calendar.CalendarPeriod <= @ReportExpensePeriodParameter)
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
			ProfitabilityActual.SourceKey = Source.SourceKey
		
		INNER JOIN dbo.Reimbursable ON
			ProfitabilityActual.ReimbursableKey = Reimbursable.ReimbursableKey
						
		INNER JOIN #CategorizationHierarchyFilterTable GlobalHierarchy ON
			ProfitabilityActual.GlobalGLCategorizationHierarchyKey = GlobalHierarchy.CategorizationHierarchyKey
	WHERE
		Overhead.OverheadCode IN 
		(
			'ALLOC',
			'UNKNOWN',
			'N/A'
		) AND
		Calendar.CalendarYear = STR(@CalendarYear, 10, 0) AND
		Currency.CurrencyCode = @_DestinationCurrency
	GROUP BY
		ProfitabilityActual.ActivityTypeKey,
		ProfitabilityActual.GlobalGLCategorizationHierarchyKey,
		ProfitabilityActual.ReportingGLCategorizationHierarchyKey,
		ProfitabilityActual.AllocationRegionKey,
		ProfitabilityActual.OriginatingRegionKey,
		ProfitabilityActual.FunctionalDepartmentKey,
		ProfitabilityActual.PropertyFundKey,
		ProfitabilityActual.ReimbursableKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'
			ELSE
				Source.SourceName
		END,
		CONVERT(VARCHAR(10), ISNULL(ProfitabilityActual.LastDate, ''), 101),
		ProfitabilityActual.[User],
		ProfitabilityActual.Description,
		ProfitabilityActual.AdditionalDescription,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'	
			ELSE
				ProfitabilityActual.PropertyFundCode
		END,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'	
			ELSE
				ProfitabilityActual.OriginatingRegionCode
		END,
		ProfitabilityActual.FunctionalDepartmentCode,
		GlobalHierarchy.GLAccountCode,
		GlobalHierarchy.GLAccountName,
		Calendar.CalendarPeriod

END

/* ===============================================================================================================================================
	STEP 8: Get Profitability Budget Data
			
		Budget Owner data is only 'Allocated', 'UNKNOWN'
		'Outflow', 'UNKNOWN' only, they only look at expenses, not income
		Exclude 'Architects & Engineering', was re-classified, as per Martin's request
    ============================================================================================================================================ */
BEGIN

	INSERT INTO #BudgetOwnerEntity
	SELECT
		ProfitabilityBudget.ActivityTypeKey,
		ProfitabilityBudget.GlobalGLCategorizationHierarchyKey,
		ProfitabilityBudget.ReportingGLCategorizationHierarchyKey,
		ProfitabilityBudget.AllocationRegionKey,
		ProfitabilityBudget.OriginatingRegionKey,
		ProfitabilityBudget.FunctionalDepartmentKey,
		ProfitabilityBudget.PropertyFundKey,
		ProfitabilityBudget.ReimbursableKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'
			ELSE
				Source.SourceName
		END AS 'SourceName',
		'' AS 'EntryDate',
		'' AS 'User',
		'' AS 'Description',
		'' AS 'AdditionalDescription',
		'' AS 'PropertyFundCode',
		'' AS 'OriginatingRegionCode',
		'' AS 'FunctionalDepartmentCode',
		GlobalHierarchy.GLAccountCode AS 'GLAccountCode',
		GlobalHierarchy.GLAccountName AS 'GLAccountName',	
		Calendar.CalendarPeriod,
		NULL AS 'MtdGrossActual',
		SUM
		(
			#ExchangeRate.Rate *
			CASE
				WHEN
					(Calendar.CalendarPeriod = @ReportExpensePeriodParameter)
				THEN
					ProfitabilityBudget.LocalBudget
				ELSE
					0.0
			END
		) AS 'MtdGrossBudget',
		NULL AS 'MtdGrossReforeCast',
		NULL AS 'MtdNetActual',
		SUM
		(
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE
				WHEN
					(Calendar.CalendarPeriod = @ReportExpensePeriodParameter)
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
					(Calendar.CalendarPeriod <= @ReportExpensePeriodParameter)
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
					(Calendar.CalendarPeriod <= @ReportExpensePeriodParameter)
				THEN
					ProfitabilityBudget.LocalBudget
				ELSE
					0.0
			END
		) AS 'YtdNetBudget',
		NULL AS 'YtdNetReforecast',
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
		SUM
		(
			#ExchangeRate.Rate *
			CASE
				WHEN
					(Calendar.CalendarPeriod > @ReportExpensePeriodParameter)
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
					(Calendar.CalendarPeriod > @ReportExpensePeriodParameter)
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
		
		INNER JOIN dbo.Source ON
			ProfitabilityBudget.SourceKey = Source.SourceKey
		
		INNER JOIN dbo.Reimbursable ON
			ProfitabilityBudget.ReimbursableKey = Reimbursable.ReimbursableKey
						
		INNER JOIN #CategorizationHierarchyFilterTable GlobalHierarchy ON
			ProfitabilityBudget.GlobalGLCategorizationHierarchyKey = GlobalHierarchy.CategorizationHierarchyKey
	WHERE 
		Overhead.OverheadCode IN 
		(
			'ALLOC',
			'UNKNOWN',
			'N/A'
		) AND
		Calendar.CalendarYear = @CalendarYear AND
		Currency.CurrencyCode = @_DestinationCurrency	
	GROUP BY
		ProfitabilityBudget.ActivityTypeKey,
		ProfitabilityBudget.GlobalGLCategorizationHierarchyKey,
		ProfitabilityBudget.ReportingGLCategorizationHierarchyKey,
		ProfitabilityBudget.AllocationRegionKey,
		ProfitabilityBudget.OriginatingRegionKey,
		ProfitabilityBudget.FunctionalDepartmentKey,
		ProfitabilityBudget.PropertyFundKey,
		ProfitabilityBudget.ReimbursableKey,
		CASE
			WHEN
				@_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
			THEN
				'Sensitized'	
			ELSE
				Source.SourceName
		END,
		GlobalHierarchy.GLAccountCode,
		GlobalHierarchy.GLAccountName,	
		Calendar.CalendarPeriod
		
END
	
/* ===============================================================================================================================================
	STEP 9: Get Profitability Reforecast Data

		There are only reforecast transactions for Q1, Q2, Q3
				
		Budget Owner data is only 'Allocated', 'UNKNOWN'
		'Outflow', 'UNKNOWN' only, they only look at expenses, not income
		Exclude 'Architects & Engineering', was re-classified, as per Martin's request
    =========================================================================================================================================== */
BEGIN

	IF @_ReforecastQuarterName IN ('Q1', 'Q2', 'Q3')
	BEGIN

		INSERT INTO #BudgetOwnerEntity
		SELECT
			ProfitabilityReforecast.ActivityTypeKey,
			ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey,
			ProfitabilityReforecast.ReportingGLCategorizationHierarchyKey,
			ProfitabilityReforecast.AllocationRegionKey,
			ProfitabilityReforecast.OriginatingRegionKey,
			ProfitabilityReforecast.FunctionalDepartmentKey,
			ProfitabilityReforecast.PropertyFundKey,
			ProfitabilityReforecast.ReimbursableKey,
			CASE
				WHEN
					@_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
				THEN
					'Sensitized'	
				ELSE
					Source.SourceName
			END AS 'SourceName',
			'' AS 'EntryDate',
			'' AS 'User',
			'' AS 'Description',
			'' AS 'AdditionalDescription',
			'' AS 'PropertyFundCode',
			'' AS 'OriginatingRegionCode',
			'' AS 'FunctionalDepartmentCode',
			GlobalHierarchy.GLAccountCode AS 'GLAccountCode',
			GlobalHierarchy.GLAccountName AS 'GLAccountName',	
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
			) AS 'MtdGrossReforeCast',
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
				#ExchangeRate.Rate *
				Reimbursable.MultiplicationFactor *
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
				ProfitabilityReforecast.SourceKey = Source.SourceKey
				
			INNER JOIN dbo.Reimbursable ON
				ProfitabilityReforecast.ReimbursableKey = Reimbursable.ReimbursableKey
							
			INNER JOIN  #CategorizationHierarchyFilterTable GlobalHierarchy ON
				ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey = GlobalHierarchy.CategorizationHierarchyKey
			
			INNER JOIN dbo.Reforecast ON
				ProfitabilityReforecast.ReforecastKey = Reforecast.ReforecastKey
		WHERE 
			Overhead.OverheadCode IN 
			(
				'ALLOC',
				'UNKNOWN',
				'N/A'
			) AND
			Reforecast.ReforecastEffectivePeriod = @ReforecastEffectivePeriod AND
			Calendar.CalendarYear = @CalendarYear AND
			Currency.CurrencyCode = @_DestinationCurrency
		GROUP BY
			ProfitabilityReforecast.ActivityTypeKey,
			ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey,
			ProfitabilityReforecast.ReportingGLCategorizationHierarchyKey,
			ProfitabilityReforecast.AllocationRegionKey,
			ProfitabilityReforecast.OriginatingRegionKey,
			ProfitabilityReforecast.FunctionalDepartmentKey,
			ProfitabilityReforecast.PropertyFundKey,
			ProfitabilityReforecast.ReimbursableKey,
			CASE
				WHEN
					@_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
				THEN
					'Sensitized'	
				ELSE
					Source.SourceName
			END,
			GlobalHierarchy.GLAccountCode,
			GlobalHierarchy.GLAccountName,
			Calendar.CalendarPeriod

	END

END

/* ===============================================================================================================================================
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
   ============================================================================================================================================ */
BEGIN

	SELECT 
		ActivityType.ActivityTypeName,
		ActivityType.ActivityTypeName AS 'ActivityTypeFilterName',
		GlobalHierarchyInWarehouse.LatestGLCategorizationName AS 'GlobalCategorization',
		GlobalHierarchyInWarehouse.LatestGLFinancialCategoryName AS 'GlobalFinancialCategory',
		GlobalHierarchyInWarehouse.LatestGLMajorCategoryName AS 'GlobalMajorExpenseCategoryName',
		GlobalHierarchyInWarehouse.LatestGLMinorCategoryName AS 'GlobalMinorExpenseCategoryName',
		ReportingHierarchyInWarehouse.LatestGLCategorizationName AS 'ReportingCategorization',
		ReportingHierarchyInWarehouse.LatestGLFinancialCategoryName AS 'ReportingFinancialCategory',
		ReportingHierarchyInWarehouse.LatestGLMajorCategoryName AS 'ReportingMajorExpenseCategoryName',
		ReportingHierarchyInWarehouse.LatestGLMinorCategoryName AS 'ReportingMinorExpenseCategoryName',
		AllocationRegion.AllocationRegionName AS 'AllocationRegionName',
		AllocationRegion.AllocationSubRegionName AS 'AllocationSubRegionName',
		AllocationRegion.AllocationSubRegionName AS 'AllocationSubRegionFilterName',
		OriginatingRegion.OriginatingRegionName AS 'OriginatingRegionName',
		OriginatingRegion.OriginatingSubRegionName AS 'OriginatingSubRegionName',
		OriginatingRegion.OriginatingSubRegionName AS 'OriginatingSubRegionFilterName',
		/* IMPORTANT
			The roll up to payroll is very sensitive information. It is crutial that information regarding payroll does not get communicated to
				TS employees.
		*/
		CASE 
			WHEN 
				@_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchyInWarehouse.LatestGLMajorCategoryName = 'Salaries/Taxes/Benefits' 
			THEN
				'Payroll' 
			ELSE
				FunctionalDepartment.FunctionalDepartmentName 
		END AS 'FunctionalDepartmentName',
		PropertyFund.PropertyFundType AS 'EntityType',
		PropertyFund.PropertyFundName AS 'EntityName',
		#BudgetOwnerEntity.CalendarPeriod AS 'ActualsExpensePeriod',
		#BudgetOwnerEntity.EntryDate AS 'EntryDate',
		#BudgetOwnerEntity.[User],
		#BudgetOwnerEntity.[Description],
		#BudgetOwnerEntity.AdditionalDescription,
		#BudgetOwnerEntity.SourceName,
		#BudgetOwnerEntity.PropertyFundCode,
		CASE 
			WHEN 
				(SUBSTRING(#BudgetOwnerEntity.SourceName, CHARINDEX(' ', #BudgetOwnerEntity.SourceName) +1, 8) = 'Property') 
			THEN
				RTRIM(#BudgetOwnerEntity.OriginatingRegionCode) + LTRIM(#BudgetOwnerEntity.FunctionalDepartmentCode) 
			ELSE
				#BudgetOwnerEntity.OriginatingRegionCode 
		END AS 'OriginatingRegionCode',	    
		ISNULL(#BudgetOwnerEntity.GLAccountCode, '') AS 'GlAccountCode',
		ISNULL(#BudgetOwnerEntity.GLAccountName, '') AS 'GlAccountName',
		Reimbursable.ReimbursableName AS 'ReimbursableName',
		
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
					(@_CalculationMethod = 'Gross')
				THEN
					ISNULL(MtdGrossBudget, 0) 
				ELSE
					ISNULL(MtdNetBudget, 0) 
			END
		) AS 'MtdOriginalBudget',

		----------

		SUM
		(
			CASE 
				WHEN
					(@_CalculationMethod = 'Gross') 
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
		) AS 'MtdReforecast',

		----------

		SUM
		(
			CASE 
				WHEN
					(@_CalculationMethod = 'Gross') 
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
					(@_CalculationMethod = 'Gross')
				THEN
					ISNULL(YtdGrossActual,0) 
				ELSE
					ISNULL(YtdNetActual,0) 
			END
		) AS 'YtdActual',

		SUM
		(
			CASE
				WHEN
					(@_CalculationMethod = 'Gross')
				THEN
					ISNULL(YtdGrossBudget, 0)
				ELSE
					ISNULL(YtdNetBudget, 0)
			END
		) AS 'YtdOriginalBudget',

		----------

		SUM
		(
			CASE
				WHEN
					(@_CalculationMethod = 'Gross')
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

		----------

		SUM
		(
			CASE
				WHEN
					(@_CalculationMethod = 'Gross')
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

		----------

		--Annual
		SUM
		(
			CASE
				WHEN
					(@_CalculationMethod = 'Gross')
				THEN
					ISNULL(AnnualGrossBudget, 0)
				ELSE
					ISNULL(AnnualNetBudget, 0)
			END
		) AS 'AnnualOriginalBudget',	

		----------

		SUM
		(
			CASE
				WHEN
					(@_CalculationMethod = 'Gross')
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
							WHEN
								@_ReforecastQuarterName = 'Q0'
							THEN
								0
							ELSE
								AnnualNetReforecast
						END,
						0
					)
			END
		) AS 'AnnualReforecast',
		#LocalNonLocalMapping.LocalNonLocal,
		ISNULL(#DirectIndirectMapping.DirectIndirect, '-') AS 'DirectIndirect'
	INTO
		#Output
	FROM
		#BudgetOwnerEntity

		-- we want to return the latest allocation region name regardless of what the 
		-- name was at the point that the transaction was incurred, otherwise it is treated as multiple entities
		-- and grouped wrong
		INNER JOIN #AllocationSubRegionFilterTable AllocationRegion ON 
			#BudgetOwnerEntity.AllocationRegionKey = AllocationRegion.AllocationRegionKey

		-- we want to return the latest originating region name regardless of what the 
		-- name was at the point that the transaction was incurred, otherwise it is treated as multiple entities
		-- and grouped wrong
		INNER JOIN #OriginatingSubRegionFilterTable OriginatingRegion ON 
			#BudgetOwnerEntity.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey

		-- we want to return the latest functional department name regardless of what the 
		-- name was at the point that the transaction was incurred, otherwise it is treated as multiple entities
		-- and grouped wrong
		INNER JOIN #FunctionalDepartmentFilterTable FunctionalDepartment ON 
			#BudgetOwnerEntity.FunctionalDepartmentKey = FunctionalDepartment.FunctionalDepartmentKey

		INNER JOIN dbo.GLCategorizationHierarchyLatestState GlobalHierarchyInWarehouse ON
			#BudgetOwnerEntity.GlobalGLCategorizationKey = GlobalHierarchyInWarehouse.GLCategorizationHierarchyKey

		INNER JOIN dbo.GLCategorizationHierarchyLatestState ReportingHierarchyInWarehouse ON
			#BudgetOwnerEntity.ReportingGLCategorizationKey = ReportingHierarchyInWarehouse.GLCategorizationHierarchyKey

		-- we want to return the latest property fund name regardless of what the 
		-- name was at the point that the transaction was incurred, otherwise it is treated as multiple entities
		-- and grouped wrong
		INNER JOIN #EntityFilterTable PropertyFund ON 
			#BudgetOwnerEntity.PropertyFundKey = PropertyFund.PropertyFundKey

		INNER JOIN dbo.ActivityType ON 
			#BudgetOwnerEntity.ActivityTypeKey = ActivityType.ActivityTypeKey
			
		INNER JOIN dbo.Reimbursable ON
			#BudgetOwnerEntity.ReimbursableKey = Reimbursable.ReimbursableKey
		
		INNER JOIN #LocalNonLocalMapping ON
			AllocationRegion.AllocationSubRegionName = #LocalNonLocalMapping.AllocationSubRegionName AND
			AllocationRegion.AllocationRegionName = #LocalNonLocalMapping.AllocationRegionName AND
			OriginatingRegion.OriginatingSubRegionName = #LocalNonLocalMapping.OriginatingSubRegionName AND
			OriginatingRegion.OriginatingRegionName = #LocalNonLocalMapping.OriginatingRegionName

		LEFT OUTER JOIN #DirectIndirectMapping ON
			#BudgetOwnerEntity.SourceName = #DirectIndirectMapping.SourceName
	GROUP BY
		ActivityType.ActivityTypeName,
		ActivityType.ActivityTypeName,
		GlobalHierarchyInWarehouse.LatestGLCategorizationName,
		GlobalHierarchyInWarehouse.LatestGLFinancialCategoryName,
		GlobalHierarchyInWarehouse.LatestGLMajorCategoryName,
		GlobalHierarchyInWarehouse.LatestGLMinorCategoryName,
		ReportingHierarchyInWarehouse.LatestGLCategorizationName,
		ReportingHierarchyInWarehouse.LatestGLFinancialCategoryName,
		ReportingHierarchyInWarehouse.LatestGLMajorCategoryName,
		ReportingHierarchyInWarehouse.LatestGLMinorCategoryName,
		AllocationRegion.AllocationRegionName,
		AllocationRegion.AllocationSubRegionName,
		AllocationRegion.AllocationSubRegionName,
		OriginatingRegion.OriginatingRegionName,
		OriginatingRegion.OriginatingSubRegionName,
		OriginatingRegion.OriginatingSubRegionName,
		/* IMPORTANT
			The roll up to payroll is very sensitive information. It is crutial that information regarding payroll does not get communicated to
				TS employees.
		*/
		CASE 
			WHEN 
				@_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchyInWarehouse.LatestGLMajorCategoryName = 'Salaries/Taxes/Benefits' 
			THEN
				'Payroll' 
			ELSE
				FunctionalDepartment.FunctionalDepartmentName 
		END,
		PropertyFund.PropertyFundType,
		PropertyFund.PropertyFundName,
		#BudgetOwnerEntity.CalendarPeriod,
		#BudgetOwnerEntity.EntryDate,
		#BudgetOwnerEntity.[User],
		#BudgetOwnerEntity.[Description],
		#BudgetOwnerEntity.AdditionalDescription,
		#BudgetOwnerEntity.SourceName,
		#BudgetOwnerEntity.PropertyFundCode,
		CASE 
			WHEN 
				(SUBSTRING(#BudgetOwnerEntity.SourceName, CHARINDEX(' ', #BudgetOwnerEntity.SourceName) +1, 8) = 'Property') 
			THEN
				RTRIM(#BudgetOwnerEntity.OriginatingRegionCode) + LTRIM(#BudgetOwnerEntity.FunctionalDepartmentCode) 
			ELSE
				#BudgetOwnerEntity.OriginatingRegionCode 
		END,	    
		ISNULL(#BudgetOwnerEntity.GLAccountCode, ''),
		ISNULL(#BudgetOwnerEntity.GLAccountName, ''),
		Reimbursable.ReimbursableName,
		#LocalNonLocalMapping.LocalNonLocal,
		ISNULL(#DirectIndirectMapping.DirectIndirect, '-')
	
END
				
/* ===============================================================================================================================================
	STEP 11: Get Final Results
   ============================================================================================================================================= */
BEGIN
	
	--------------------------------------------------------------------
	-- Insert the Global and Local results into temporary tables so that we can check whether there's less than a million (or so) records in each
	--------------------------------------------------------------------

	-- The dataset for the Global categorization mappings
	SELECT
		ActivityTypeName,
		ActivityTypeFilterName,
		GlobalCategorization AS 'Categorization',
		GlobalFinancialCategory AS 'FinancialCategory',
		GlobalMajorExpenseCategoryName AS 'MajorExpenseCategoryName',
		GlobalMinorExpenseCategoryName AS 'MinorExpenseCategoryName',
		AllocationRegionName,
		AllocationSubRegionName,
		AllocationSubRegionFilterName,
		OriginatingRegionName,
		OriginatingSubRegionName,
		OriginatingSubRegionFilterName,
		FunctionalDepartmentName,
		EntityType,
		EntityName,
		ActualsExpensePeriod,
		--EntryDate,
		'' AS EntryDate,
		--[User] AS 'User',
		'' AS 'User',
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
				LTRIM(RTRIM([Description]))
		END AS 'Description',
		'' AS AdditionalDescription,
		SourceName,
		PropertyFundCode,
		OriginatingRegionCode,
		GlAccountCode,
		GlAccountName,
		ReimbursableName,
		OriginatingSubRegionName + ' : ' + FunctionalDepartmentName AS 'OriginatingSubRegionFunctionlDepartment',
		
		--Month to date    
		SUM(MtdActual) AS 'MtdActual',
		SUM(MtdOriginalBudget) AS 'MtdOriginalBudget',
		SUM(MtdReforecast) AS 'MtdReforecast',
		SUM(MtdVariance) AS 'MtdVariance',
		
		--Year to date
		SUM(YtdActual) AS 'YtdActual',
		SUM(YtdOriginalBudget) AS 'YtdOriginalBudget',
		SUM(YtdReforecast) AS 'YtdReforecast',
		SUM(YtdVariance) AS 'YtdVariance',

		--Annual
		SUM(AnnualOriginalBudget) AS 'AnnualOriginalBudget',
		SUM(AnnualReforecast) AS 'AnnualReforecast',

		LocalNonLocal,
		DirectIndirect
	INTO
		#FinalResultsGlobal
	FROM 
		#Output
	WHERE
		--Month to date    
		MtdActual <> 0.00 OR
		-- MtdOriginalBudget <> 0.00 OR
		MtdReforecast <> 0.00 OR
		MtdVariance <> 0.00 OR
		
		YtdActual <> 0.00 OR
		-- YtdOriginalBudget <> 0.00 OR
		YtdReforecast <> 0.00 OR
		YtdVariance <> 0.00 OR

		AnnualOriginalBudget <> 0.00 OR
		AnnualReforecast <> 0.00 
	GROUP BY
		  ActivityTypeName,
		ActivityTypeFilterName,
		GlobalCategorization,
		GlobalFinancialCategory,
		GlobalMajorExpenseCategoryName,
		GlobalMinorExpenseCategoryName,
		AllocationRegionName,
		AllocationSubRegionName,
		AllocationSubRegionFilterName,
		OriginatingRegionName,
		OriginatingSubRegionName,
		OriginatingSubRegionFilterName,
		FunctionalDepartmentName,
		EntityType,
		EntityName,
		ActualsExpensePeriod,
		--EntryDate,
		--[User],
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
				LTRIM(RTRIM([Description]))
		END,
		--AdditionalDescription,
		SourceName,
		PropertyFundCode,
		OriginatingRegionCode,
		GlAccountCode,
		GlAccountName,
		ReimbursableName,

		LocalNonLocal,
		DirectIndirect

	-- The dataset for the default Local categorization mappings
	SELECT
		ActivityTypeName,
		ActivityTypeFilterName,
		ReportingCategorization AS 'Categorization',
		ReportingFinancialCategory AS 'FinancialCategory',
		ReportingMajorExpenseCategoryName AS 'MajorExpenseCategoryName',
		ReportingMinorExpenseCategoryName AS 'MinorExpenseCategoryName',
		AllocationRegionName,
		AllocationSubRegionName,
		AllocationSubRegionFilterName,
		OriginatingRegionName,
		OriginatingSubRegionName,
		OriginatingSubRegionFilterName,
		FunctionalDepartmentName,
		EntityType,
		EntityName,
		ActualsExpensePeriod,
		--EntryDate,
		'' AS EntryDate,
		--[User] AS 'User',
		'' AS 'User',
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
				LTRIM(RTRIM([Description]))
		END AS 'Description',																							  
		'' AS AdditionalDescription,
		SourceName,
		PropertyFundCode,
		OriginatingRegionCode,
		GlAccountCode,
		GlAccountName,
		ReimbursableName,
		OriginatingSubRegionName + ' : ' + FunctionalDepartmentName AS 'OriginatingSubRegionFunctionlDepartment',
		
		--Month to date    
		SUM(MtdActual) AS 'MtdActual',
		SUM(MtdOriginalBudget) AS 'MtdOriginalBudget',
		SUM(MtdReforecast) AS 'MtdReforecast',
		SUM(MtdVariance) AS 'MtdVariance',
		
		--Year to date
		SUM(YtdActual) AS 'YtdActual',
		SUM(YtdOriginalBudget) AS 'YtdOriginalBudget',
		SUM(YtdReforecast) AS 'YtdReforecast',
		SUM(YtdVariance) AS 'YtdVariance',

		--Annual
		SUM(AnnualOriginalBudget) AS 'AnnualOriginalBudget',
		SUM(AnnualReforecast) AS 'AnnualReforecast',
		
		LocalNonLocal,
		DirectIndirect
	INTO
		#FinalResultsLocal
	FROM 
		#Output
	WHERE
		/*
			If local categorizations are not set to be reported, this makes sure they aren't include in the report
		*/
		1 = @_IncludeLocalCategorization AND  
		(    
			MtdActual <> 0.00 OR
			-- MtdOriginalBudget <> 0.00 OR
			MtdReforecast <> 0.00 OR
			MtdVariance <> 0.00 OR
			
			YtdActual <> 0.00 OR
			-- YtdOriginalBudget <> 0.00 OR
			YtdReforecast <> 0.00 OR
			YtdVariance <> 0.00 OR

			AnnualOriginalBudget <> 0.00 OR
			AnnualReforecast <> 0.00 
		)
	GROUP BY
		ActivityTypeName,
		ActivityTypeFilterName,
		ReportingCategorization,
		ReportingFinancialCategory,
		ReportingMajorExpenseCategoryName,
		ReportingMinorExpenseCategoryName,
		AllocationRegionName,
		AllocationSubRegionName,
		AllocationSubRegionFilterName,
		OriginatingRegionName,
		OriginatingSubRegionName,
		OriginatingSubRegionFilterName,
		FunctionalDepartmentName,
		EntityType,
		EntityName,
		ActualsExpensePeriod,
		--EntryDate,
		--[User],
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
				LTRIM(RTRIM([Description]))
		END,
		--AdditionalDescription,
		SourceName,
		PropertyFundCode,
		OriginatingRegionCode,
		GlAccountCode,
		GlAccountName,
		ReimbursableName,
		LocalNonLocal,
		DirectIndirect

	-------------------------------------------------------------
	-- GLOBAL
	-------------------------------------------------------------

	DECLARE @MaximumRecordsInExcel INT = (1048576 - 2) -- 1,048,576 is the maximum, but we need a row for the header and one as a safe-guard
	DECLARE @DescriptionLength INT = 17

	IF ((SELECT COUNT(*) FROM #FinalResultsGlobal) > @MaximumRecordsInExcel) -- If we are over the limit
	BEGIN

		-- If the data IS sensitised, only return the first '@DescriptionLength' characters of the description to help it roll up more
		-- If the data IS NOT sensitised, remove the description completely (replace with '')

		SELECT
			ActivityTypeName,
			ActivityTypeFilterName,
			Categorization,
			FinancialCategory,
			MajorExpenseCategoryName,
			MinorExpenseCategoryName,
			AllocationRegionName,
			AllocationSubRegionName,
			AllocationSubRegionFilterName,
			OriginatingRegionName,
			OriginatingSubRegionName,
			OriginatingSubRegionFilterName,
			FunctionalDepartmentName,
			EntityType,
			EntityName,
			ActualsExpensePeriod,
			EntryDate,
			[User],
			CASE
				WHEN
					@_DontSensitizeMRIPayrollData = 1 -- Data IS NOT sensitised
				THEN
					'' -- remove the Description field completely because trimming the Description will not reduce the number of records by enough
				ELSE -- Data IS sensitised	
					CASE
						WHEN
							[Description] <> '[BUDGET/REFORECAST]'
						THEN
							LEFT([Description], @DescriptionLength)
						ELSE
							[Description]
					END
			END AS [Description],
			AdditionalDescription,
			SourceName,
			PropertyFundCode,
			OriginatingRegionCode,
			GlAccountCode,
			GlAccountName,
			
			ReimbursableName,
			OriginatingSubRegionFunctionlDepartment,

			--Month to date
			SUM(MtdActual) AS 'MtdActual',
			SUM(MtdOriginalBudget) AS 'MtdOriginalBudget',
			SUM(MtdReforecast) AS 'MtdReforecast',
			SUM(MtdVariance) AS 'MtdVariance',

			--Year to date
			SUM(YtdActual) AS 'YtdActual',
			SUM(YtdOriginalBudget) AS 'YtdOriginalBudget',
			SUM(YtdReforecast) AS 'YtdReforecast',
			SUM(YtdVariance) AS 'YtdVariance',

			--Annual
			SUM(AnnualOriginalBudget) AS 'AnnualOriginalBudget',
			SUM(AnnualReforecast) AS 'AnnualReforecast',

			LocalNonLocal,
			DirectIndirect
		FROM
			#FinalResultsGlobal
		GROUP BY
			ActivityTypeName,
			ActivityTypeFilterName,
			Categorization,
			FinancialCategory,
			MajorExpenseCategoryName,
			MinorExpenseCategoryName,
			AllocationRegionName,
			AllocationSubRegionName,
			AllocationSubRegionFilterName,
			OriginatingRegionName,
			OriginatingSubRegionName,
			OriginatingSubRegionFilterName,
			FunctionalDepartmentName,
			EntityType,
			EntityName,
			ActualsExpensePeriod,
			EntryDate,
			[User],
			CASE
				WHEN
					@_DontSensitizeMRIPayrollData = 1 -- Data IS NOT sensitised
				THEN
					'' -- remove the Description field completely because trimming the Description will not reduce the number of records by enough
				ELSE -- Data IS sensitised	
					CASE
						WHEN
							[Description] <> '[BUDGET/REFORECAST]'
						THEN
							LEFT([Description], @DescriptionLength)
						ELSE
							[Description]
					END
			END,
			AdditionalDescription,
			SourceName,
			PropertyFundCode,
			OriginatingRegionCode,
			GlAccountCode,
			GlAccountName,
			ReimbursableName,
			OriginatingSubRegionFunctionlDepartment,
			LocalNonLocal,
			DirectIndirect
		HAVING
			SUM(MtdActual) <> 0.00 OR
			SUM(MtdOriginalBudget) <> 0.00 OR
			SUM(MtdReforecast) <> 0.00 OR
			SUM(MtdVariance) <> 0.00 OR

			--Year to date
			SUM(YtdActual) <> 0.00 OR
			SUM(YtdOriginalBudget) <> 0.00 OR
			SUM(YtdReforecast) <> 0.00 OR
			SUM(YtdVariance) <> 0.00 OR

			--Annual
			SUM(AnnualOriginalBudget) <> 0.00 OR
			SUM(AnnualReforecast) <> 0.00
	END
	ELSE -- Else we are under the limit: just select the results as-is
	BEGIN

		SELECT
			ActivityTypeName,
			ActivityTypeFilterName,
			Categorization,
			FinancialCategory,
			MajorExpenseCategoryName,
			MinorExpenseCategoryName,
			AllocationRegionName,
			AllocationSubRegionName,
			AllocationSubRegionFilterName,
			OriginatingRegionName,
			OriginatingSubRegionName,
			OriginatingSubRegionFilterName,
			FunctionalDepartmentName,
			EntityType,
			EntityName,
			ActualsExpensePeriod,
			EntryDate,
			[User],
			[Description],
			AdditionalDescription,
			SourceName,
			PropertyFundCode,
			OriginatingRegionCode,
			GlAccountCode,
			GlAccountName,
			
			ReimbursableName,
			OriginatingSubRegionFunctionlDepartment,

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

			LocalNonLocal,
			DirectIndirect
		FROM
			#FinalResultsGlobal
		WHERE
			--Month to date    
			MtdActual <> 0.00 OR
			-- MtdOriginalBudget <> 0.00 OR
			MtdReforecast <> 0.00 OR
			MtdVariance <> 0.00 OR
			
			YtdActual <> 0.00 OR
			-- YtdOriginalBudget <> 0.00 OR
			YtdReforecast <> 0.00 OR
			YtdVariance <> 0.00 OR

			AnnualOriginalBudget <> 0.00 OR
			AnnualReforecast <> 0.00

	END

	-------------------------------------------------------------
	-- LOCAL
	-------------------------------------------------------------

	IF ((SELECT COUNT(*) FROM #FinalResultsGlobal) > @MaximumRecordsInExcel) -- If we are over the limit
	BEGIN

		-- If the data IS sensitised, only return the first '@DescriptionLength' characters of the description to help it roll up more
		-- If the data IS NOT sensitised, remove the description completely (replace with '')

		SELECT
			ActivityTypeName,
			ActivityTypeFilterName,
			Categorization,
			FinancialCategory,
			MajorExpenseCategoryName,
			MinorExpenseCategoryName,
			AllocationRegionName,
			AllocationSubRegionName,
			AllocationSubRegionFilterName,
			OriginatingRegionName,
			OriginatingSubRegionName,
			OriginatingSubRegionFilterName,
			FunctionalDepartmentName,
			EntityType,
			EntityName,
			ActualsExpensePeriod,
			EntryDate,
			[User],
			CASE
				WHEN
					@_DontSensitizeMRIPayrollData = 1 -- Data IS NOT sensitised
				THEN
					'' -- remove the Description field completely because trimming the Description will not reduce the number of records by enough
				ELSE -- Data IS sensitised	
					CASE
						WHEN
							[Description] <> '[BUDGET/REFORECAST]'
						THEN
							LEFT([Description], @DescriptionLength)
						ELSE
							[Description]
					END
			END AS [Description],
			AdditionalDescription,
			SourceName,
			PropertyFundCode,
			OriginatingRegionCode,
			GlAccountCode,
			GlAccountName,
			ReimbursableName,
			OriginatingSubRegionFunctionlDepartment,

			--Month to date    
			SUM(MtdActual) AS 'MtdActual',
			SUM(MtdOriginalBudget) AS 'MtdOriginalBudget',
			SUM(MtdReforecast) AS 'MtdReforecast',
			SUM(MtdVariance) AS 'MtdVariance',

			--Year to date
			SUM(YtdActual) AS 'YtdActual',
			SUM(YtdOriginalBudget) AS 'YtdOriginalBudget',
			SUM(YtdReforecast) AS 'YtdReforecast',
			SUM(YtdVariance) AS 'YtdVariance',

			--Annual
			SUM(AnnualOriginalBudget) AS 'AnnualOriginalBudget',
			SUM(AnnualReforecast) AS 'AnnualReforecast',

			LocalNonLocal,
			DirectIndirect
		FROM
			#FinalResultsLocal
		GROUP BY
			ActivityTypeName,
			ActivityTypeFilterName,
			Categorization,
			FinancialCategory,
			MajorExpenseCategoryName,
			MinorExpenseCategoryName,
			AllocationRegionName,
			AllocationSubRegionName,
			AllocationSubRegionFilterName,
			OriginatingRegionName,
			OriginatingSubRegionName,
			OriginatingSubRegionFilterName,
			FunctionalDepartmentName,
			EntityType,
			EntityName,
			ActualsExpensePeriod,
			EntryDate,
			[User],
			CASE
				WHEN
					@_DontSensitizeMRIPayrollData = 1 -- Data IS NOT sensitised
				THEN
					'' -- remove the Description field completely because trimming the Description will not reduce the number of records by enough
				ELSE -- Data IS sensitised	
					CASE
						WHEN
							[Description] <> '[BUDGET/REFORECAST]'
						THEN
							LEFT([Description], @DescriptionLength)
						ELSE
							[Description]
					END
			END,
			AdditionalDescription,
			SourceName,
			PropertyFundCode,
			OriginatingRegionCode,
			GlAccountCode,
			GlAccountName,
			ReimbursableName,
			OriginatingSubRegionFunctionlDepartment,
			LocalNonLocal,
			DirectIndirect
		HAVING
			SUM(MtdActual) <> 0.00 OR
			SUM(MtdOriginalBudget) <> 0.00 OR
			SUM(MtdReforecast) <> 0.00 OR
			SUM(MtdVariance) <> 0.00 OR

			--Year to date
			SUM(YtdActual) <> 0.00 OR
			SUM(YtdOriginalBudget) <> 0.00 OR
			SUM(YtdReforecast) <> 0.00 OR
			SUM(YtdVariance) <> 0.00 OR

			--Annual
			SUM(AnnualOriginalBudget) <> 0.00 OR
			SUM(AnnualReforecast) <> 0.00

	END
	ELSE -- Else we are under the limit: just select the results as-is
	BEGIN

		SELECT
			ActivityTypeName,
			ActivityTypeFilterName,
			Categorization,
			FinancialCategory,
			MajorExpenseCategoryName,
			MinorExpenseCategoryName,
			AllocationRegionName,
			AllocationSubRegionName,
			AllocationSubRegionFilterName,
			OriginatingRegionName,
			OriginatingSubRegionName,
			OriginatingSubRegionFilterName,
			FunctionalDepartmentName,
			EntityType,
			EntityName,
			ActualsExpensePeriod,
			EntryDate,
			[User],
			[Description],
			AdditionalDescription,
			SourceName,
			PropertyFundCode,
			OriginatingRegionCode,
			GlAccountCode,
			GlAccountName,
			ReimbursableName,
			OriginatingSubRegionFunctionlDepartment,
			
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
			
			LocalNonLocal,
			DirectIndirect			
		FROM
			#FinalResultsLocal
		WHERE
			--Month to date    
			MtdActual <> 0.00 OR
			-- MtdOriginalBudget <> 0.00 OR
			MtdReforecast <> 0.00 OR
			MtdVariance <> 0.00 OR
			
			YtdActual <> 0.00 OR
			-- YtdOriginalBudget <> 0.00 OR
			YtdReforecast <> 0.00 OR
			YtdVariance <> 0.00 OR

			AnnualOriginalBudget <> 0.00 OR
			AnnualReforecast <> 0.00

	END

END
	
/* ===============================================================================================================================================
	STEP 12: Clean Up
   ============================================================================================================================================= */
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

	IF 	OBJECT_ID('tempdb..#BudgetOwnerEntity') IS NOT NULL
		DROP TABLE #BudgetOwnerEntity

	IF  OBJECT_ID('tempdb..#LocalNonLocalMapping') IS NOT NULL
		DROP TABLE #LocalNonLocalMapping
		
	IF  OBJECT_ID('tempdb..#DirectIndirectMapping') IS NOT NULL
		DROP TABLE #DirectIndirectMapping

	IF  OBJECT_ID('tempdb..#Output') IS NOT NULL
		DROP TABLE #Output

	IF  OBJECT_ID('tempdb..#FinalResultsGlobal') IS NOT NULL
		DROP TABLE #FinalResultsGlobal

	IF  OBJECT_ID('tempdb..#FinalResultsLocal') IS NOT NULL
		DROP TABLE #FinalResultsLocal

END
	
END -- End Stored Procedure

GO
