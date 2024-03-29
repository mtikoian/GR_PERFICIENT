USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_FTEBudgetOwner]    Script Date: 07/11/2012 23:31:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_FTEBudgetOwner]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_FTEBudgetOwner]
GO

USE [GrReporting]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_FTEBudgetOwner]    Script Date: 06/18/2012 23:11:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_R_FTEBudgetOwner]
	@ReportExpensePeriod INT,
	@ReforecastQuarterName VARCHAR(2), --'Q0' or 'Q1' or 'Q2' or 'Q3'
	@DestinationCurrency VARCHAR(3),
	@EntityList VARCHAR(max),
	@DontSensitizeMRIPayrollData BIT,
	@CalculationMethod VARCHAR(50),
	@OriginatingSubRegionList VARCHAR(max),
	@AllocationSubRegionList VARCHAR(max),
	@FunctionalDepartmentList VARCHAR(max),	
	--@HierarchyReportParameter dbo.ReportParameterGLCategorizationHierarchyDetail READONLY,
	@ActivityTypeList  VARCHAR(max),
	@IsOwner int = 1, --	0-Originator; 1-Owner
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

	STEP 3: Set up the Report Filter Tables - We create temp tables containing the records of each parameter dimention
											  We can easily filter our data by inner joining onto these tables
											  
											  Note that we pass through the names of these parameters. If the name of the 
											  record was changed, we still want to return results for all it's related transactions.
											  Therefore we use views which return the latest state in a dimension to get all the 
											  records related to that entity.
	STEP 4: Create results temp table
	STEP 5: Get Profitability Actual Data - NOTE: we group the transactions here to get a total amount for each type of transaction
	STEP 6: Get Profitability Budget Data
	STEP 7: Get Profitability Reforecast Data
	STEP 8: Sensitization
	STEP 9: Get Final Results

	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2012-07-11		: MChen		:	Created.
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
		@_ActivityTypeList VARCHAR(MAX)	         = @ActivityTypeList,  
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
	-- Activity Type
	----------------------------------------------------------------------------

		CREATE TABLE #ActivityTypeFilterTable	
		(
			[ActivityTypeKey] [int]  NOT NULL,
			[ActivityTypeId] [int] NOT NULL,
			[ActivityTypeCode] [varchar](50) NOT NULL,
			[ActivityTypeName] [varchar](50) NOT NULL
		)

		IF (@_ActivityTypeList IS NOT NULL)
		BEGIN

				INSERT INTO #ActivityTypeFilterTable
				SELECT DISTINCT 
					AT.[ActivityTypeKey],
					AT.[ActivityTypeId],
					AT.[ActivityTypeCode],
					AT.[ActivityTypeName]

				FROM 
					dbo.Split(@_ActivityTypeList) ActivityTypeListParameters
					INNER JOIN dbo.ActivityType AT ON AT.ActivityTypeName=ActivityTypeListParameters.item 
					OR ActivityTypeListParameters.item='All'


		END

	CREATE UNIQUE CLUSTERED INDEX IX_AT ON #ActivityTypeFilterTable ([ActivityTypeKey])
	
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
	-- Employee
	----------------------------------------------------------------------------

	CREATE TABLE #EmployeeFilterTable 
	(
		EmployeeKey INT NOT NULL,
		EmployeeName VARCHAR(255) NOT NULL
	)
	Insert #EmployeeFilterTable
	select EmployeeKey,EmployeeName from dbo.Employee
	Where  Employee.PayGroupCode<>'TS9'
		AND Employee.SubDepartmentName<>'Property Operations - Engineering'

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EmployeeFilterTable	(EmployeeKey)

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
		ProjectKey						INT,
		ProjectGroupKey					INT,
		EmployeeKey						INT,
		ActivityTypeKey					INT,	
		ConsolidationRegionKey			INT,
		BudgetOwnerStaff				VARCHAR(255),
		ApprovedByStaff					VARCHAR(255),
		AllocationRegionKey				INT,
		OriginatingRegionKey			INT,
		FunctionalDepartmentKey			INT,
		PropertyFundKey					INT,
		ReportingEntityKey				INT,
		ReimbursableKey					INT,
		LocalNonLocal					VARCHAR(20),
		SourceKey						INT,
		CalendarKey						INT,

		RecordType						VARCHAR(20),
		
		--measure	for datatab
		ActualAllocatedFTE				Decimal(18,12),
		BilledAmount					MONEY,
		BilledFTE						Decimal(18,12),
		AdjustmentsAmount				MONEY,
		AdjustmentsFTE					Decimal(18,12),
		
		CurrentBudgetReforecastAllocatedAmount	MONEY,
		CurrentBudgetReforecastAllocatedFTE		Decimal(18,12),

		OriginalBudgetAllocatedAmount	MONEY,
		OriginalBudgetAllocatedFTE		Decimal(18,12),

		
		--measure for pivot table, should be hide in datatab

		YTDActual                       Decimal(18,12),
		YTDBudget                       Decimal(18,12),
		VariancesPriorMonth             Decimal(18,12),
		VariancesMTDBudget              Decimal(18,12),
		VariancesYTDBudget              Decimal(18,12),
		FullYearBudgetReforecast		Decimal(18,12),
		FullYearOriginalBudget			Decimal(18,12)

	)

END

/* ===============================================================================================================================================
	STEP 7: Get TimeAllocation Actual Data

		Budget Owner data is only 'Allocated', 'Not Overhead', 'UNKNOWN'
		'Outflow', 'UNKNOWN' only, they only look at expenses, not income
		Exclude 'Architects & Engineering', was re-classified, as per Martin's request
    ============================================================================================================================================ */
BEGIN

	INSERT INTO #BudgetOwnerEntity
	SELECT
		
		TimeAllocationActual.ProjectKey						,
		TimeAllocationActual.ProjectGroupKey					,
		TimeAllocationActual.EmployeeKey						,
		TimeAllocationActual.ActivityTypeKey					,
		TimeAllocationActual.ConsolidationRegionKey			,
		TimeAllocationActual.BudgetOwnerStaff					,
		TimeAllocationActual.ApprovedByStaff				,
		TimeAllocationActual.AllocationRegionKey				,
		TimeAllocationActual.OriginatingRegionKey			,
		TimeAllocationActual.FunctionalDepartmentKey			,
		TimeAllocationActual.PropertyFundKey					,
		TimeAllocationActual.ReportingEntityKey,
		TimeAllocationActual.ReimbursableKey					,
		TimeAllocationActual.Local_NonLocal	AS LocalNonLocal				,
		TimeAllocationActual.SourceKey						,


		Calendar.CalendarKey,
		'Actual' AS RecordType,		
		--measure	for datatab
		TimeAllocationActual.ActualAllocatedFTE AS ActualAllocatedFTE,
		#ExchangeRate.Rate * TimeAllocationActual.BilledAmount AS BilledAmount,
		TimeAllocationActual.BilledFTE AS BilledFTE,
		#ExchangeRate.Rate * TimeAllocationActual.AdjustmentsAmount AS AdjustmentsAmount,
		TimeAllocationActual.AdjustmentsFTE AS AdjustmentsFTE,
		
		NULL as CurrentBudgetReforecastAllocatedAmount,
		NULL as CurrentBudgetReforecastAllocatedFTE,
		NULL as OriginalBudgetAllocatedAmount,
		NULL as OriginalBudgetAllocatedFTE,
		
		
		--measure for pivot table, should be hide in datatab
		--remove the Period dimension

		SUM(ActualAllocatedFTE) over (partition by 		TimeAllocationActual.ProjectKey						,
					TimeAllocationActual.ProjectGroupKey					,
					TimeAllocationActual.EmployeeKey						,
					TimeAllocationActual.ActivityTypeKey					,
					TimeAllocationActual.ConsolidationRegionKey			,
					TimeAllocationActual.BudgetOwnerStaff					,
					TimeAllocationActual.ApprovedByStaff				,
					TimeAllocationActual.AllocationRegionKey				,
					TimeAllocationActual.OriginatingRegionKey			,
					TimeAllocationActual.FunctionalDepartmentKey			,
					TimeAllocationActual.PropertyFundKey					,
					TimeAllocationActual.ReportingEntityKey,
					TimeAllocationActual.ReimbursableKey					,
					TimeAllocationActual.Local_NonLocal					,
					TimeAllocationActual.SourceKey)
			/(@ReportExpensePeriodParameter % 100)
			/COUNT(CalendarPeriod) over (partition by TimeAllocationActual.ProjectKey						,
					TimeAllocationActual.ProjectGroupKey					,
					TimeAllocationActual.EmployeeKey						,
					TimeAllocationActual.ActivityTypeKey					,
					TimeAllocationActual.ConsolidationRegionKey			,
					TimeAllocationActual.BudgetOwnerStaff					,
					TimeAllocationActual.ApprovedByStaff				,
					TimeAllocationActual.AllocationRegionKey				,
					TimeAllocationActual.OriginatingRegionKey			,
					TimeAllocationActual.FunctionalDepartmentKey			,
					TimeAllocationActual.PropertyFundKey					,
					TimeAllocationActual.ReportingEntityKey,
					TimeAllocationActual.ReimbursableKey					,
					TimeAllocationActual.Local_NonLocal					,
					TimeAllocationActual.SourceKey) as YTDActual,
		NULL as YTDBudget,
		
		case when Calendar.CalendarPeriod = @ReportExpensePeriodParameter-1 then TimeAllocationActual.ActualAllocatedFTE else 0 end
		- case when Calendar.CalendarPeriod = @ReportExpensePeriodParameter then TimeAllocationActual.ActualAllocatedFTE else 0 end
		 as VariancesPriorMonth,
		 
		0 - case when Calendar.CalendarPeriod = @ReportExpensePeriodParameter then TimeAllocationActual.ActualAllocatedFTE else 0 end
		 as VariancesMTDBudget,
		 
		0 - SUM(ActualAllocatedFTE) over (partition by TimeAllocationActual.ProjectKey						,
					TimeAllocationActual.ProjectGroupKey					,
					TimeAllocationActual.EmployeeKey						,
					TimeAllocationActual.ActivityTypeKey					,
					TimeAllocationActual.ConsolidationRegionKey			,
					TimeAllocationActual.BudgetOwnerStaff					,
					TimeAllocationActual.ApprovedByStaff				,
					TimeAllocationActual.AllocationRegionKey				,
					TimeAllocationActual.OriginatingRegionKey			,
					TimeAllocationActual.FunctionalDepartmentKey			,
					TimeAllocationActual.PropertyFundKey					,
					TimeAllocationActual.ReportingEntityKey,
					TimeAllocationActual.ReimbursableKey					,
					TimeAllocationActual.Local_NonLocal					,
					TimeAllocationActual.SourceKey)
			/(@ReportExpensePeriodParameter % 100)
			/COUNT(CalendarPeriod) over (partition by TimeAllocationActual.ProjectKey						,
					TimeAllocationActual.ProjectGroupKey					,
					TimeAllocationActual.EmployeeKey						,
					TimeAllocationActual.ActivityTypeKey					,
					TimeAllocationActual.ConsolidationRegionKey			,
					TimeAllocationActual.BudgetOwnerStaff					,
					TimeAllocationActual.ApprovedByStaff				,
					TimeAllocationActual.AllocationRegionKey				,
					TimeAllocationActual.OriginatingRegionKey			,
					TimeAllocationActual.FunctionalDepartmentKey			,
					TimeAllocationActual.PropertyFundKey					,
					TimeAllocationActual.ReportingEntityKey,
					TimeAllocationActual.ReimbursableKey					,
					TimeAllocationActual.Local_NonLocal					,
					TimeAllocationActual.SourceKey)
		 as VariancesYTDBudget,
		
		NULL as FullYearBudgetReforecast,
		NULL as FullYearOriginalBudget
		
	FROM 
		dbo.TimeAllocationActual 
		
		INNER JOIN #EntityFilterTable ON
			TimeAllocationActual.ReportingEntityKey = #EntityFilterTable.PropertyFundKey
			
		INNER JOIN #ActivityTypeFilterTable ON
			TimeAllocationActual.ActivityTypeKey = #ActivityTypeFilterTable.ActivityTypeKey
			
		INNER JOIN #OriginatingSubRegionFilterTable ON
			TimeAllocationActual.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey
			
		INNER JOIN #AllocationSubRegionFilterTable ON
			TimeAllocationActual.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey
			
		INNER JOIN #FunctionalDepartmentFilterTable ON
			TimeAllocationActual.FunctionalDepartmentKey = #FunctionalDepartmentFilterTable.FunctionalDepartmentKey
			
		LEFT JOIN #ExchangeRate ON
			TimeAllocationActual.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
			TimeAllocationActual.CalendarKey = #ExchangeRate.CalendarKey
			
		LEFT JOIN dbo.Currency ON
			#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey
			and Currency.CurrencyCode = @_DestinationCurrency
			
		--INNER JOIN dbo.Overhead ON
		--	TimeAllocationActual.Overheadkey = Overhead.OverheadKey
			
			
			--select * from dbo.TimeAllocationActual 
		INNER JOIN dbo.Calendar ON
			TimeAllocationActual.CalendarKey = Calendar.CalendarKey
			
		INNER JOIN #EmployeeFilterTable Employee ON 
			TimeAllocationActual.EmployeeKey = Employee.EmployeeKey
			
		
	WHERE

		Calendar.CalendarYear = @CalendarYear AND
		Calendar.CalendarPeriod <=@_ReportExpensePeriod AND
		Currency.CurrencyCode = @_DestinationCurrency

		--ANd TimeAllocationActual.EmployeeKey in (14904,16340,17840)
		
	PRINT 'Completed inserting records into #BudgetOwnerEntity: '+CONVERT(char(10),@@rowcount)	

print '@CalendarYear='+@CalendarYear
print '@_ReportExpensePeriod='+cast(@_ReportExpensePeriod as varchar)
print '@_DestinationCurrency='+cast(@_DestinationCurrency as varchar)

--select * from ErpHR.dbo.SubDepartment where Name like 'Property Operations%'

END

/* ===============================================================================================================================================
	STEP 8: Get TimeAllocation Budget Data
			
	
    ============================================================================================================================================ */
BEGIN

	INSERT INTO #BudgetOwnerEntity
	SELECT
		
		TimeAllocationBudget.ProjectKey						,
		TimeAllocationBudget.ProjectGroupKey					,
		TimeAllocationBudget.EmployeeKey						,
		TimeAllocationBudget.ActivityTypeKey					,
		TimeAllocationBudget.ConsolidationRegionKey			,
		TimeAllocationBudget.BudgetOwnerStaff					,
		TimeAllocationBudget.ApprovedByStaff				,
		TimeAllocationBudget.AllocationRegionKey				,
		TimeAllocationBudget.OriginatingRegionKey			,
		TimeAllocationBudget.FunctionalDepartmentKey			,
		TimeAllocationBudget.PropertyFundKey					,
		TimeAllocationBudget.ReportingEntityKey,
		TimeAllocationBudget.ReimbursableKey					,
		TimeAllocationBudget.Local_NonLocal	AS LocalNonLocal					,
		TimeAllocationBudget.SourceKey						,


		Calendar.CalendarKey,
		'Budget/Reforecast' AS RecordType,
		--measure	for datatab
		NULL AS ActualAllocatedFTE,
		NULL AS BilledAmount,
		NULL AS BilledFTE,
		NULL AS AdjustmentsAmount,
		NULL AS AdjustmentsFTE,
		
		case when @_ReforecastQuarterName='Q0' then #ExchangeRate.Rate * TimeAllocationBudget.LocalBudgetAllocatedAmount else 0 end 
		 as CurrentBudgetReforecastAllocatedAmount,
		case when @_ReforecastQuarterName='Q0' then TimeAllocationBudget.BudgetAllocatedFTE else 0 end 
		 as CurrentBudgetReforecastAllocatedFTE,
		#ExchangeRate.Rate * TimeAllocationBudget.LocalBudgetAllocatedAmount as OriginalBudgetAllocatedAmount,
		TimeAllocationBudget.BudgetAllocatedFTE as OriginalBudgetAllocatedFTE,
		
		
		--measure for pivot table, should be hide in datatab
		--remove the Period dimension
		
		NULL as YTDActual,
		case when @_ReforecastQuarterName='Q0' then 
			SUM(case when CalendarPeriod<=@ReportExpensePeriodParameter then BudgetAllocatedFTE else NULL end) 
				over (partition by 					TimeAllocationBudget.ProjectKey						,
					TimeAllocationBudget.ProjectGroupKey					,
					TimeAllocationBudget.EmployeeKey						,
					TimeAllocationBudget.ActivityTypeKey					,
					TimeAllocationBudget.ConsolidationRegionKey			,
					TimeAllocationBudget.BudgetOwnerStaff					,
					TimeAllocationBudget.ApprovedByStaff				,
					TimeAllocationBudget.AllocationRegionKey				,
					TimeAllocationBudget.OriginatingRegionKey			,
					TimeAllocationBudget.FunctionalDepartmentKey			,
					TimeAllocationBudget.PropertyFundKey					,
					TimeAllocationBudget.ReportingEntityKey,
					TimeAllocationBudget.ReimbursableKey					,
					TimeAllocationBudget.Local_NonLocal					,
					TimeAllocationBudget.SourceKey)
				/(@ReportExpensePeriodParameter % 100)
				/COUNT(CalendarPeriod) over (partition by 					TimeAllocationBudget.ProjectKey						,
					TimeAllocationBudget.ProjectGroupKey					,
					TimeAllocationBudget.EmployeeKey						,
					TimeAllocationBudget.ActivityTypeKey					,
					TimeAllocationBudget.ConsolidationRegionKey			,
					TimeAllocationBudget.BudgetOwnerStaff					,
					TimeAllocationBudget.ApprovedByStaff				,
					TimeAllocationBudget.AllocationRegionKey				,
					TimeAllocationBudget.OriginatingRegionKey			,
					TimeAllocationBudget.FunctionalDepartmentKey			,
					TimeAllocationBudget.PropertyFundKey					,
					TimeAllocationBudget.ReportingEntityKey,
					TimeAllocationBudget.ReimbursableKey					,
					TimeAllocationBudget.Local_NonLocal					,
					TimeAllocationBudget.SourceKey) 
		 else 0 end 
			as YTDBudget,
		
		NULL as VariancesPriorMonth,
		 
		case when @_ReforecastQuarterName='Q0' then 
			case when Calendar.CalendarPeriod = @ReportExpensePeriodParameter then TimeAllocationBudget.BudgetAllocatedFTE else 0 end - 0
		else 0 end
			as VariancesMTDBudget,
		 
		case when @_ReforecastQuarterName='Q0' then 
		SUM(case when CalendarPeriod<=@ReportExpensePeriodParameter then BudgetAllocatedFTE else NULL end) 
			over (partition by 					TimeAllocationBudget.ProjectKey						,
					TimeAllocationBudget.ProjectGroupKey					,
					TimeAllocationBudget.EmployeeKey						,
					TimeAllocationBudget.ActivityTypeKey					,
					TimeAllocationBudget.ConsolidationRegionKey			,
					TimeAllocationBudget.BudgetOwnerStaff					,
					TimeAllocationBudget.ApprovedByStaff				,
					TimeAllocationBudget.AllocationRegionKey				,
					TimeAllocationBudget.OriginatingRegionKey			,
					TimeAllocationBudget.FunctionalDepartmentKey			,
					TimeAllocationBudget.PropertyFundKey					,
					TimeAllocationBudget.ReportingEntityKey,
					TimeAllocationBudget.ReimbursableKey					,
					TimeAllocationBudget.Local_NonLocal					,
					TimeAllocationBudget.SourceKey)
			/(@ReportExpensePeriodParameter % 100)
			/COUNT(CalendarPeriod) over (partition by 					TimeAllocationBudget.ProjectKey						,
					TimeAllocationBudget.ProjectGroupKey					,
					TimeAllocationBudget.EmployeeKey						,
					TimeAllocationBudget.ActivityTypeKey					,
					TimeAllocationBudget.ConsolidationRegionKey			,
					TimeAllocationBudget.BudgetOwnerStaff					,
					TimeAllocationBudget.ApprovedByStaff				,
					TimeAllocationBudget.AllocationRegionKey				,
					TimeAllocationBudget.OriginatingRegionKey			,
					TimeAllocationBudget.FunctionalDepartmentKey			,
					TimeAllocationBudget.PropertyFundKey					,
					TimeAllocationBudget.ReportingEntityKey,
					TimeAllocationBudget.ReimbursableKey					,
					TimeAllocationBudget.Local_NonLocal					,
					TimeAllocationBudget.SourceKey) - 0
		else 0 end
			as VariancesYTDBudget,
		
		case when @_ReforecastQuarterName = 'Q0' then
			SUM(BudgetAllocatedFTE) over (partition by 					TimeAllocationBudget.ProjectKey						,
					TimeAllocationBudget.ProjectGroupKey					,
					TimeAllocationBudget.EmployeeKey						,
					TimeAllocationBudget.ActivityTypeKey					,
					TimeAllocationBudget.ConsolidationRegionKey			,
					TimeAllocationBudget.BudgetOwnerStaff					,
					TimeAllocationBudget.ApprovedByStaff				,
					TimeAllocationBudget.AllocationRegionKey				,
					TimeAllocationBudget.OriginatingRegionKey			,
					TimeAllocationBudget.FunctionalDepartmentKey			,
					TimeAllocationBudget.PropertyFundKey					,
					TimeAllocationBudget.ReportingEntityKey,
					TimeAllocationBudget.ReimbursableKey					,
					TimeAllocationBudget.Local_NonLocal					,
					TimeAllocationBudget.SourceKey)
			/12
				/COUNT(CalendarPeriod) over (partition by 					TimeAllocationBudget.ProjectKey						,
					TimeAllocationBudget.ProjectGroupKey					,
					TimeAllocationBudget.EmployeeKey						,
					TimeAllocationBudget.ActivityTypeKey					,
					TimeAllocationBudget.ConsolidationRegionKey			,
					TimeAllocationBudget.BudgetOwnerStaff					,
					TimeAllocationBudget.ApprovedByStaff				,
					TimeAllocationBudget.AllocationRegionKey				,
					TimeAllocationBudget.OriginatingRegionKey			,
					TimeAllocationBudget.FunctionalDepartmentKey			,
					TimeAllocationBudget.PropertyFundKey					,
					TimeAllocationBudget.ReportingEntityKey,
					TimeAllocationBudget.ReimbursableKey					,
					TimeAllocationBudget.Local_NonLocal					,
					TimeAllocationBudget.SourceKey)
		else 0 end
			as FullYearBudgetReforecast,
			
		SUM(BudgetAllocatedFTE) over (partition by 					TimeAllocationBudget.ProjectKey						,
					TimeAllocationBudget.ProjectGroupKey					,
					TimeAllocationBudget.EmployeeKey						,
					TimeAllocationBudget.ActivityTypeKey					,
					TimeAllocationBudget.ConsolidationRegionKey			,
					TimeAllocationBudget.BudgetOwnerStaff					,
					TimeAllocationBudget.ApprovedByStaff				,
					TimeAllocationBudget.AllocationRegionKey				,
					TimeAllocationBudget.OriginatingRegionKey			,
					TimeAllocationBudget.FunctionalDepartmentKey			,
					TimeAllocationBudget.PropertyFundKey					,
					TimeAllocationBudget.ReportingEntityKey,
					TimeAllocationBudget.ReimbursableKey					,
					TimeAllocationBudget.Local_NonLocal					,
					TimeAllocationBudget.SourceKey)
			/12
			/COUNT(CalendarPeriod) over (partition by 					TimeAllocationBudget.ProjectKey						,
					TimeAllocationBudget.ProjectGroupKey					,
					TimeAllocationBudget.EmployeeKey						,
					TimeAllocationBudget.ActivityTypeKey					,
					TimeAllocationBudget.ConsolidationRegionKey			,
					TimeAllocationBudget.BudgetOwnerStaff					,
					TimeAllocationBudget.ApprovedByStaff				,
					TimeAllocationBudget.AllocationRegionKey				,
					TimeAllocationBudget.OriginatingRegionKey			,
					TimeAllocationBudget.FunctionalDepartmentKey			,
					TimeAllocationBudget.PropertyFundKey					,
					TimeAllocationBudget.ReportingEntityKey,
					TimeAllocationBudget.ReimbursableKey					,
					TimeAllocationBudget.Local_NonLocal					,
					TimeAllocationBudget.SourceKey)
			as FullYearOriginalBudget
		
	FROM
		dbo.TimeAllocationBudget 

		INNER JOIN #EntityFilterTable ON
			TimeAllocationBudget.ReportingEntityKey = #EntityFilterTable.PropertyFundKey
		INNER JOIN #ActivityTypeFilterTable ON
			TimeAllocationBudget.ActivityTypeKey = #ActivityTypeFilterTable.ActivityTypeKey
			
		INNER JOIN #OriginatingSubRegionFilterTable ON
			TimeAllocationBudget.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey
			
		INNER JOIN #AllocationSubRegionFilterTable ON
			TimeAllocationBudget.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey
			
		INNER JOIN #FunctionalDepartmentFilterTable ON
			TimeAllocationBudget.FunctionalDepartmentKey = #FunctionalDepartmentFilterTable.FunctionalDepartmentKey
			
		INNER JOIN #ExchangeRate ON
			TimeAllocationBudget.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
			TimeAllocationBudget.CalendarKey = #ExchangeRate.CalendarKey
			
		INNER JOIN dbo.Currency ON
			#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey
			
		--INNER JOIN dbo.Overhead ON
		--	TimeAllocationBudget.Overheadkey = Overhead.OverheadKey
			
		INNER JOIN dbo.Calendar ON
			TimeAllocationBudget.CalendarKey = Calendar.CalendarKey
		INNER JOIN #EmployeeFilterTable Employee ON 
			TimeAllocationBudget.EmployeeKey = Employee.EmployeeKey

	WHERE 

		Calendar.CalendarYear = @CalendarYear AND
		Currency.CurrencyCode = @_DestinationCurrency	
		--ANd TimeAllocationBudget.EmployeeKey in (14904,16340,17840)
		/*		AND	TimeAllocationBudget.ActivityTypeKey			<>-1	
				AND	TimeAllocationBudget.ConsolidationRegionKey		<>-1	
				AND	TimeAllocationBudget.AllocationRegionKey		<>-1	
				AND	TimeAllocationBudget.OriginatingRegionKey		<>-1	
				AND	TimeAllocationBudget.FunctionalDepartmentKey	<>-1	
				AND	TimeAllocationBudget.PropertyFundKey			<>-1	
				AND	TimeAllocationBudget.ReportingEntityKey         <>-1	
				*/				
PRINT 'Completed inserting Budget records into #BudgetOwnerEntity: '+CONVERT(char(10),@@rowcount)
		
END
	
/* ===============================================================================================================================================
	STEP 9: Get TimeAllocation Reforecast Data

		There are only reforecast transactions for Q1, Q2, Q3
				
	
    =========================================================================================================================================== */

BEGIN

	IF @_ReforecastQuarterName IN ('Q1', 'Q2', 'Q3')
	BEGIN
		INSERT INTO #BudgetOwnerEntity
	SELECT
		
		TimeAllocationReforecast.ProjectKey						,
		TimeAllocationReforecast.ProjectGroupKey					,
		TimeAllocationReforecast.EmployeeKey						,
		TimeAllocationReforecast.ActivityTypeKey					,
		TimeAllocationReforecast.ConsolidationRegionKey			,
		TimeAllocationReforecast.BudgetOwnerStaff					,
		TimeAllocationReforecast.ApprovedByStaff				,
		TimeAllocationReforecast.AllocationRegionKey				,
		TimeAllocationReforecast.OriginatingRegionKey			,
		TimeAllocationReforecast.FunctionalDepartmentKey			,
		TimeAllocationReforecast.PropertyFundKey					,
		TimeAllocationReforecast.ReportingEntityKey,
		TimeAllocationReforecast.ReimbursableKey					,
		TimeAllocationReforecast.Local_NonLocal	AS LocalNonLocal					,
		TimeAllocationReforecast.SourceKey						,


		Calendar.CalendarKey,
		'Budget/Reforecast' AS RecordType,
		--measure	for datatab
		NULL AS ActualAllocatedFTE,
		NULL AS BilledAmount,
		NULL AS BilledFTE,
		NULL AS AdjustmentsAmount,
		NULL AS AdjustmentsFTE,
		
		#ExchangeRate.Rate * TimeAllocationReforecast.LocalBudgetAllocatedAmount 
		 as CurrentBudgetReforecastAllocatedAmount,
		TimeAllocationReforecast.BudgetAllocatedFTE 
		 as CurrentBudgetReforecastAllocatedFTE,
		0 as OriginalBudgetAllocatedAmount,
		0 as OriginalBudgetAllocatedFTE,
		
		
		--measure for pivot table, should be hide in datatab
		--remove the Period dimension
		
		NULL as YTDActual,
		
		SUM(case when CalendarPeriod<=@ReportExpensePeriodParameter then BudgetAllocatedFTE else NULL end) 
				over (partition by 					TimeAllocationReforecast.ProjectKey						,
					TimeAllocationReforecast.ProjectGroupKey					,
					TimeAllocationReforecast.EmployeeKey						,
					TimeAllocationReforecast.ActivityTypeKey					,
					TimeAllocationReforecast.ConsolidationRegionKey			,
					TimeAllocationReforecast.BudgetOwnerStaff					,
					TimeAllocationReforecast.ApprovedByStaff				,
					TimeAllocationReforecast.AllocationRegionKey				,
					TimeAllocationReforecast.OriginatingRegionKey			,
					TimeAllocationReforecast.FunctionalDepartmentKey			,
					TimeAllocationReforecast.PropertyFundKey					,
					TimeAllocationReforecast.ReportingEntityKey,
					TimeAllocationReforecast.ReimbursableKey					,
					TimeAllocationReforecast.Local_NonLocal					,
					TimeAllocationReforecast.SourceKey)
				/(@ReportExpensePeriodParameter % 100)
				/COUNT(CalendarPeriod) over (partition by 					TimeAllocationReforecast.ProjectKey						,
					TimeAllocationReforecast.ProjectGroupKey					,
					TimeAllocationReforecast.EmployeeKey						,
					TimeAllocationReforecast.ActivityTypeKey					,
					TimeAllocationReforecast.ConsolidationRegionKey			,
					TimeAllocationReforecast.BudgetOwnerStaff					,
					TimeAllocationReforecast.ApprovedByStaff				,
					TimeAllocationReforecast.AllocationRegionKey				,
					TimeAllocationReforecast.OriginatingRegionKey			,
					TimeAllocationReforecast.FunctionalDepartmentKey			,
					TimeAllocationReforecast.PropertyFundKey					,
					TimeAllocationReforecast.ReportingEntityKey,
					TimeAllocationReforecast.ReimbursableKey					,
					TimeAllocationReforecast.Local_NonLocal					,
					TimeAllocationReforecast.SourceKey) 
		 
			as YTDBudget,
		
		NULL as VariancesPriorMonth,
		 
		
		case when Calendar.CalendarPeriod = @ReportExpensePeriodParameter then TimeAllocationReforecast.BudgetAllocatedFTE else 0 end - 0
		
			as VariancesMTDBudget,
		 
		 
		SUM(case when CalendarPeriod<=@ReportExpensePeriodParameter then BudgetAllocatedFTE else NULL end) 
			over (partition by 					TimeAllocationReforecast.ProjectKey						,
					TimeAllocationReforecast.ProjectGroupKey					,
					TimeAllocationReforecast.EmployeeKey						,
					TimeAllocationReforecast.ActivityTypeKey					,
					TimeAllocationReforecast.ConsolidationRegionKey			,
					TimeAllocationReforecast.BudgetOwnerStaff					,
					TimeAllocationReforecast.ApprovedByStaff				,
					TimeAllocationReforecast.AllocationRegionKey				,
					TimeAllocationReforecast.OriginatingRegionKey			,
					TimeAllocationReforecast.FunctionalDepartmentKey			,
					TimeAllocationReforecast.PropertyFundKey					,
					TimeAllocationReforecast.ReportingEntityKey,
					TimeAllocationReforecast.ReimbursableKey					,
					TimeAllocationReforecast.Local_NonLocal					,
					TimeAllocationReforecast.SourceKey)
			/(@ReportExpensePeriodParameter % 100)
			/COUNT(CalendarPeriod) over (partition by 					TimeAllocationReforecast.ProjectKey						,
					TimeAllocationReforecast.ProjectGroupKey					,
					TimeAllocationReforecast.EmployeeKey						,
					TimeAllocationReforecast.ActivityTypeKey					,
					TimeAllocationReforecast.ConsolidationRegionKey			,
					TimeAllocationReforecast.BudgetOwnerStaff					,
					TimeAllocationReforecast.ApprovedByStaff				,
					TimeAllocationReforecast.AllocationRegionKey				,
					TimeAllocationReforecast.OriginatingRegionKey			,
					TimeAllocationReforecast.FunctionalDepartmentKey			,
					TimeAllocationReforecast.PropertyFundKey					,
					TimeAllocationReforecast.ReportingEntityKey,
					TimeAllocationReforecast.ReimbursableKey					,
					TimeAllocationReforecast.Local_NonLocal					,
					TimeAllocationReforecast.SourceKey) - 0
		
			as VariancesYTDBudget,
		
		
		SUM(BudgetAllocatedFTE) over (partition by 					TimeAllocationReforecast.ProjectKey						,
					TimeAllocationReforecast.ProjectGroupKey					,
					TimeAllocationReforecast.EmployeeKey						,
					TimeAllocationReforecast.ActivityTypeKey					,
					TimeAllocationReforecast.ConsolidationRegionKey			,
					TimeAllocationReforecast.BudgetOwnerStaff					,
					TimeAllocationReforecast.ApprovedByStaff				,
					TimeAllocationReforecast.AllocationRegionKey				,
					TimeAllocationReforecast.OriginatingRegionKey			,
					TimeAllocationReforecast.FunctionalDepartmentKey			,
					TimeAllocationReforecast.PropertyFundKey					,
					TimeAllocationReforecast.ReportingEntityKey,
					TimeAllocationReforecast.ReimbursableKey					,
					TimeAllocationReforecast.Local_NonLocal					,
					TimeAllocationReforecast.SourceKey)
			/12
				/COUNT(CalendarPeriod) over (partition by 					TimeAllocationReforecast.ProjectKey						,
					TimeAllocationReforecast.ProjectGroupKey					,
					TimeAllocationReforecast.EmployeeKey						,
					TimeAllocationReforecast.ActivityTypeKey					,
					TimeAllocationReforecast.ConsolidationRegionKey			,
					TimeAllocationReforecast.BudgetOwnerStaff					,
					TimeAllocationReforecast.ApprovedByStaff				,
					TimeAllocationReforecast.AllocationRegionKey				,
					TimeAllocationReforecast.OriginatingRegionKey			,
					TimeAllocationReforecast.FunctionalDepartmentKey			,
					TimeAllocationReforecast.PropertyFundKey					,
					TimeAllocationReforecast.ReportingEntityKey,
					TimeAllocationReforecast.ReimbursableKey					,
					TimeAllocationReforecast.Local_NonLocal					,
					TimeAllocationReforecast.SourceKey)
		
			as FullYearBudgetReforecast,
			
		0 as FullYearOriginalBudget
		
	FROM
		dbo.TimeAllocationReforecast 

		INNER JOIN #EntityFilterTable ON
			TimeAllocationReforecast.ReportingEntityKey = #EntityFilterTable.PropertyFundKey
		INNER JOIN #ActivityTypeFilterTable ON
			TimeAllocationReforecast.ActivityTypeKey = #ActivityTypeFilterTable.ActivityTypeKey
			
		INNER JOIN #OriginatingSubRegionFilterTable ON
			TimeAllocationReforecast.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey
			
		INNER JOIN #AllocationSubRegionFilterTable ON
			TimeAllocationReforecast.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey
			
		INNER JOIN #FunctionalDepartmentFilterTable ON
			TimeAllocationReforecast.FunctionalDepartmentKey = #FunctionalDepartmentFilterTable.FunctionalDepartmentKey
			
		INNER JOIN #ExchangeRate ON
			TimeAllocationReforecast.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
			TimeAllocationReforecast.CalendarKey = #ExchangeRate.CalendarKey
			
		INNER JOIN dbo.Currency ON
			#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey
			
		--INNER JOIN dbo.Overhead ON
		--	TimeAllocationReforecast.Overheadkey = Overhead.OverheadKey
			
		INNER JOIN dbo.Calendar ON
			TimeAllocationReforecast.CalendarKey = Calendar.CalendarKey
		INNER JOIN #EmployeeFilterTable Employee ON 
			TimeAllocationReforecast.EmployeeKey = Employee.EmployeeKey

	WHERE 

		Calendar.CalendarYear = @CalendarYear AND
		Currency.CurrencyCode = @_DestinationCurrency	
		--ANd TimeAllocationReforecast.EmployeeKey in (14904,16340,17840)
		/*		AND	TimeAllocationReforecast.ActivityTypeKey			<>-1	
				AND	TimeAllocationReforecast.ConsolidationRegionKey		<>-1	
				AND	TimeAllocationReforecast.AllocationRegionKey		<>-1	
				AND	TimeAllocationReforecast.OriginatingRegionKey		<>-1	
				AND	TimeAllocationReforecast.FunctionalDepartmentKey	<>-1	
				AND	TimeAllocationReforecast.PropertyFundKey			<>-1	
				AND	TimeAllocationReforecast.ReportingEntityKey         <>-1
				*/
PRINT 'Completed inserting Reforecast records into #BudgetOwnerEntity: '+CONVERT(char(10),@@rowcount)
		
	END
END


--drop table debug.FTEOutput
--SELECT * into debug.FTEOutput from #BudgetOwnerEntity
/* ===============================================================================================================================================
	STEP 10: Get Total Summary Per cost point

		We are now combining the results for actuals, budgets and reforecasts, thus creating total amounts per:

		
		ProjectName,
		ProjectGroupName,
		ProjectCode,
		CorporateDepartmentCode,
		CorporateDepartmentName,
		CorporateSourceCode,
		EntityType,
		ReportingEntity,		
		TAPASRegionName, 
		ConsolidationRegion,
		
		BudgetOwnerName,
		PropertyFundName,
		
		AllocationRegionName,
		AllocationSubRegionName,
		LocalNonLocal,
		OriginatingRegionName,
		OriginatingSubRegionName,
		
		FunctionalDepartmentName,
		SubDepartmentName,
		
		EmployeeName,
		ApproverName,
		
		ActivityTypeName,


		Period,
		IsTSCost,
		RecordType,

		
			--measure	for datatab
		ActualAllocatedFTE,	
		BilledAmount					
		BilledFTE						
		AdjustmentsAmount				
		AdjustmentsFTE					
		
		CurrentBudgetReforecastAllocatedAmount	
		CurrentBudgetReforecastAllocatedFTE		
        
		OriginalBudgetAllocatedAmount	
		OriginalBudgetAllocatedFTE		
        
		                                                     
		--measure for pivot table, should be hide in datatab    
                                                             
		YTDActual                       
		YTDBudget                       
		VariancesPriorMonth             
		VariancesMTDBudget              
		VariancesYTDBudget              
		FullYearBudgetReforecast		
		FullYearOriginalBudget			
		

		
   ============================================================================================================================================ */
BEGIN

	SELECT 
		Project.ProjectName,
		ProjectGroup.ProjectGroupName,
		Project.ProjectCode,
		Project.CorporateDepartmentCode,
		Project.CorporateDepartmentName,
		Project.CorporateSourceCode,
		ReportingEntity.PropertyFundType AS 'EntityType',
		ReportingEntity.PropertyFundName AS 'ReportingEntity',		
		Project.RegionName as 'TAPASRegionName', 
		ConsolidationRegion.SubRegionName AS 'ConsolidationRegion',
		
		#BudgetOwnerEntity.BudgetOwnerStaff AS 'BudgetOwnerName',
		PropertyFund.PropertyFundName AS 'PropertyFundName',
		
		AllocationRegion.AllocationRegionName AS 'AllocationRegionName',
		AllocationRegion.AllocationSubRegionName AS 'AllocationSubRegionName',
		#BudgetOwnerEntity.LocalNonLocal,
		OriginatingRegion.OriginatingRegionName AS 'OriginatingRegionName',
		OriginatingRegion.OriginatingSubRegionName AS 'OriginatingSubRegionName',
		
		FunctionalDepartment.FunctionalDepartmentName,
		Employee.SubDepartmentName AS 'SubDepartmentName',
		
		Employee.EmployeeName,
		#BudgetOwnerEntity.ApprovedByStaff AS 'ApproverName',
		
		ActivityType.ActivityTypeName,


		Calendar.CalendarDate AS Period,
		case when Reimbursable.ReimbursableCode='NO' then 'YES' else 'NO' end AS 'IsTSCost',
		#BudgetOwnerEntity.RecordType,

		
			--measure	for datatab
		Sum(#BudgetOwnerEntity.ActualAllocatedFTE) 										AS ActualAllocatedFTE,	
		Sum(CASE WHEN (@_CalculationMethod = 'Gross') 
			then #BudgetOwnerEntity.BilledAmount 
			else Reimbursable.MultiplicationFactor * #BudgetOwnerEntity.BilledAmount 
			end)				                 									    AS BilledAmount,					
		Sum(#BudgetOwnerEntity.BilledFTE)						                        AS BilledFTE,						
		Sum(CASE WHEN (@_CalculationMethod = 'Gross') 
			then #BudgetOwnerEntity.AdjustmentsAmount 
			else Reimbursable.MultiplicationFactor * #BudgetOwnerEntity.AdjustmentsAmount 
			end)																		AS AdjustmentsAmount,				
		Sum(#BudgetOwnerEntity.AdjustmentsFTE)					                        AS AdjustmentsFTE,					
		                                              
		Sum(CASE WHEN (@_CalculationMethod = 'Gross') 
			then #BudgetOwnerEntity.CurrentBudgetReforecastAllocatedAmount
			else Reimbursable.MultiplicationFactor * #BudgetOwnerEntity.CurrentBudgetReforecastAllocatedAmount 
			end)																		AS CurrentBudgetReforecastAllocatedAmount,	
		Sum(#BudgetOwnerEntity.CurrentBudgetReforecastAllocatedFTE)		                AS CurrentBudgetReforecastAllocatedFTE,		
                                                      
		Sum(CASE WHEN (@_CalculationMethod = 'Gross') 
			then #BudgetOwnerEntity.OriginalBudgetAllocatedAmount
			else Reimbursable.MultiplicationFactor * #BudgetOwnerEntity.OriginalBudgetAllocatedAmount 
			end)																		AS OriginalBudgetAllocatedAmount,	
		Sum(#BudgetOwnerEntity.OriginalBudgetAllocatedFTE)		                        AS OriginalBudgetAllocatedFTE,		
                                                           
		                                                     
		--measure for pivot table, should be hide in datatab    
                                                             
		Sum(#BudgetOwnerEntity.YTDActual)                                               AS YTDActual,                       
		Sum(#BudgetOwnerEntity.YTDBudget)                                               AS YTDBudget,                       
		Sum(#BudgetOwnerEntity.VariancesPriorMonth)                                     AS VariancesPriorMonth ,            
		Sum(#BudgetOwnerEntity.VariancesMTDBudget)                                      AS VariancesMTDBudget,              
		Sum(#BudgetOwnerEntity.VariancesYTDBudget)                                      AS VariancesYTDBudget,              
		Sum(#BudgetOwnerEntity.FullYearBudgetReforecast)		                        AS FullYearBudgetReforecast	,	
		Sum(#BudgetOwnerEntity.FullYearOriginalBudget)			                        AS FullYearOriginalBudget			
	
	
	INTO
		#Output
	FROM
		#BudgetOwnerEntity

		INNER JOIN GrReporting.dbo.Project ON Project.ProjectKey = #BudgetOwnerEntity.ProjectKey
		
		INNER JOIN GrReporting.dbo.ProjectGroup ON ProjectGroup.ProjectGroupKey = #BudgetOwnerEntity.ProjectGroupKey
		
		INNER JOIN GrReporting.dbo.Employee ON Employee.EmployeeKey = #BudgetOwnerEntity.EmployeeKey
		
		INNER JOIN GrReporting.dbo.AllocationRegion ConsolidationRegion on 
			ConsolidationRegion.AllocationRegionKey = #BudgetOwnerEntity.ConsolidationRegionKey
			
		--LEFT JOIN GrReporting.dbo.Employee BudgetOwner ON BudgetOwner.EmployeeKey = #BudgetOwnerEntity.BudgetOwnerKey
		--LEFT JOIN GrReporting.dbo.Employee Approver ON Approver.EmployeeKey = #BudgetOwnerEntity.ApprovedByStaffKey

		LEFT JOIN #AllocationSubRegionFilterTable AllocationRegion ON 
			#BudgetOwnerEntity.AllocationRegionKey = AllocationRegion.AllocationRegionKey


		INNER JOIN #OriginatingSubRegionFilterTable OriginatingRegion ON 
			#BudgetOwnerEntity.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey


		INNER JOIN GrReporting.dbo.FunctionalDepartment ON 
			#BudgetOwnerEntity.FunctionalDepartmentKey = FunctionalDepartment.FunctionalDepartmentKey


		LEFT JOIN GrReporting.dbo.PropertyFundFTE PropertyFund ON 
			#BudgetOwnerEntity.PropertyFundKey = PropertyFund.PropertyFundKey

		LEFT JOIN #EntityFilterTable ReportingEntity ON 
			#BudgetOwnerEntity.ReportingEntityKey = ReportingEntity.PropertyFundKey
			
		INNER JOIN dbo.ActivityType ON 
			#BudgetOwnerEntity.ActivityTypeKey = ActivityType.ActivityTypeKey
			
		INNER JOIN dbo.Reimbursable ON
			#BudgetOwnerEntity.ReimbursableKey = Reimbursable.ReimbursableKey
			
		INNER JOIN dbo.Calendar ON 
			#BudgetOwnerEntity.CalendarKey=Calendar.CalendarKey		

	GROUP BY
		Project.ProjectName,
		ProjectGroup.ProjectGroupName,
		Project.ProjectCode,
		Project.CorporateDepartmentCode,
		Project.CorporateDepartmentName,
		Project.CorporateSourceCode,
		ReportingEntity.PropertyFundType,
		ReportingEntity.PropertyFundName,		
		Project.RegionName,
		ConsolidationRegion.SubRegionName,
		
		#BudgetOwnerEntity.BudgetOwnerStaff,
		PropertyFund.PropertyFundName,
		
		AllocationRegion.AllocationRegionName,
		AllocationRegion.AllocationSubRegionName,
		#BudgetOwnerEntity.LocalNonLocal,
		OriginatingRegion.OriginatingRegionName,
		OriginatingRegion.OriginatingSubRegionName,
		
		FunctionalDepartment.FunctionalDepartmentName,
		Employee.SubDepartmentName,
		
		Employee.EmployeeName,
		#BudgetOwnerEntity.ApprovedByStaff,
		
		ActivityType.ActivityTypeName,


		Calendar.CalendarDate,
		case when Reimbursable.ReimbursableCode='NO' then 'YES' else 'NO' end,
		#BudgetOwnerEntity.RecordType
	
END

/* ===============================================================================================================================================
	STEP 8: Sensitization
	
	3.5.1	Budget Owner FTE Report
	1.	Where there is only one employee allocating to a single reporting entity and activity type for either the actuals, projections or prior budget range, that employee’s details will be sensitized as follows:
		a.	Employee name will be replaced with the text “Active Employee 1 (Sensitized)”, “Active Employee 2 (Sensitized)”, etc.
		b.	Employee functional department will be replaced with the text “Sensitized”.
		c.	Employee originating region will be replaced with the text “Sensitized”.
		d.	Employee sub department will be replaced with the text “Sensitized”.
	2.	If the ‘Show Sensitive Information’ checkbox is NOT checked, Budget Allocated Amount, Billed Amount and Billed Adjustment Amounts will be replaced with $0.  Only percentage values will be provided.

	3.5.2	Budget Originator FTE Report
	1.	Where there is only one employee allocating to an Originating Region, Originating SubRegion, Functional Department and period, for either the actuals or budget range, that employee’s details will be sensitized as follows:
		a.	Employee name will be replaced with the text “Active Employee 1 (Sensitized)”, “Active Employee 2 (Sensitized)”, etc.
	2.	If the ‘Show Sensitive Information’ checkbox is NOT checked, Budget Allocated Amount, Billed Amount and Billed Adjustment Amounts will be replaced with $0.  Only percentage values will be provided.

   ============================================================================================================================================= */
IF @DontSensitizeMRIPayrollData=0 
BEGIN
--1. all the dollar amount will be zeroed.
	Update #Output
	set BilledAmount=0,										
		AdjustmentsAmount	=0,								
		CurrentBudgetReforecastAllocatedAmount	=0,		     
		OriginalBudgetAllocatedAmount	=0
--2. if is BudgetOwner Report

IF @IsOwner=1
BEGIN
	SELECT ROW_NUMBER ( ) over (
		order by s.ReportingEntity,s.EntityType,s.Period,s.EmployeeName
	) as ROWNUMBER, s.*
	INTO #SensitivityOwner
	FROM	
	(
		Select ReportingEntity,EntityType,Period
		FROM #Output
		GROUP BY ReportingEntity,EntityType,Period
		HAVING COUNT(Distinct EmployeeName)=1
	) o join (
		Select EmployeeName,ReportingEntity,EntityType,Period
		FROM #Output
		GROUP BY EmployeeName,ReportingEntity,EntityType,Period
	) s on (o.ReportingEntity=s.ReportingEntity
		and o.EntityType=s.EntityType and o.Period=s.Period)
	
	Update #Output
	set EmployeeName='Active Employee '+CAST(ROWNUMBER as varchar)+' (Sensitized)',
	    FunctionalDepartmentName='Sensitized',
	    SubDepartmentName='Sensitized',
	    OriginatingRegionName='Sensitized'
	FROM #Output o join #SensitivityOwner s on (o.ReportingEntity=s.ReportingEntity
		and o.EntityType=s.EntityType and o.Period=s.Period and o.EmployeeName=s.EmployeeName)


END

--2. if is BudgetOriginator Report
IF @IsOwner=0
BEGIN
	SELECT ROW_NUMBER ( )  over (
		order by s.FunctionalDepartmentName,s.OriginatingRegionName,s.OriginatingSubRegionName,s.Period,s.EmployeeName
		) as ROWNUMBER, s.*
	INTO #SensitivityOriginator
	FROM	
	(
		Select FunctionalDepartmentName,OriginatingRegionName,OriginatingSubRegionName,Period
		FROM #Output
		GROUP BY FunctionalDepartmentName,OriginatingRegionName,OriginatingSubRegionName,Period
		HAVING COUNT(Distinct EmployeeName)=1
	) o join (
		Select EmployeeName,FunctionalDepartmentName,OriginatingRegionName,OriginatingSubRegionName,Period
		FROM #Output
		GROUP BY EmployeeName,FunctionalDepartmentName,OriginatingRegionName,OriginatingSubRegionName,Period
	) s on (o.FunctionalDepartmentName=s.FunctionalDepartmentName and o.OriginatingRegionName=s.OriginatingRegionName 
		and o.OriginatingSubRegionName=s.OriginatingSubRegionName and o.Period=s.Period)
	
	Update #Output
	set EmployeeName='Active Employee '+CAST(ROWNUMBER as varchar)+' (Sensitized)'
	FROM #Output o join #SensitivityOriginator s on (o.FunctionalDepartmentName=s.FunctionalDepartmentName and o.OriginatingRegionName=s.OriginatingRegionName 
		and o.OriginatingSubRegionName=s.OriginatingSubRegionName and o.Period=s.Period and o.EmployeeName=s.EmployeeName)


END


END	
	
/* ===============================================================================================================================================
	STEP 11: Get Final Results
   ============================================================================================================================================= */
BEGIN


	SELECT * from #Output
/*
	--DECLARE @MaximumRecordsInExcel INT = (1048576 - 2) -- 1,048,576 is the maximum, but we need a row for the header and one as a safe-guard
	DECLARE @MaximumRecordsInExcel INT = 1000000
	DECLARE @DescriptionLength INT = 17

	IF ((SELECT COUNT(*) FROM #FinalResultsGlobal) > @MaximumRecordsInExcel) -- If we are over the limit
	BEGIN

		-- If the data IS sensitised, only return the first '@DescriptionLength' characters of the description to help it roll up more
		-- If the data IS NOT sensitised, remove the description completely (replace with '')

	END
*/
END
	
/* ===============================================================================================================================================
	STEP 12: Clean Up
   ============================================================================================================================================= */
BEGIN

	IF OBJECT_ID('tempdb..#EntityFilterTable') IS NOT NULL
		DROP TABLE #EntityFilterTable
	IF OBJECT_ID('tempdb..#ActivityTypeFilterTable') IS NOT NULL
		DROP TABLE #ActivityTypeFilterTable
	IF OBJECT_ID('tempdb..#EmployeeFilterTable') IS NOT NULL
		DROP TABLE #EmployeeFilterTable
	IF OBJECT_ID('tempdb..#ExchangeRate') IS NOT NULL
		DROP TABLE #ExchangeRate
		
	IF OBJECT_ID('tempdb..#OriginatingSubRegionFilterTable') IS NOT NULL
		DROP TABLE #OriginatingSubRegionFilterTable

	IF OBJECT_ID('tempdb..#AllocationSubRegionFilterTable') IS NOT NULL
		DROP TABLE #AllocationSubRegionFilterTable

	IF OBJECT_ID('tempdb..#FunctionalDepartmentFilterTable') IS NOT NULL
		DROP TABLE #FunctionalDepartmentFilterTable


	IF 	OBJECT_ID('tempdb..#BudgetOwnerEntity') IS NOT NULL
		DROP TABLE #BudgetOwnerEntity


	IF  OBJECT_ID('tempdb..#Output') IS NOT NULL
		DROP TABLE #Output


END
	
END -- End Stored Procedure
GO
