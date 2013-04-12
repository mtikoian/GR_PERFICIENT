USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ProfitabilityV2]    Script Date: 01/17/2012 10:19:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ProfitabilityV2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ProfitabilityV2]
GO

USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ProfitabilityV2]    Script Date: 01/17/2012 10:19:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE [dbo].[stp_R_ProfitabilityV2]
	@ReportExpensePeriod INT,
	@ReforecastQuarterName VARCHAR(2), --'Q0' or 'Q1' or 'Q2' or 'Q3'
	@DestinationCurrency VARCHAR(3),
	@EntityList NVARCHAR(MAX),
	@ActivityTypeList VARCHAR(MAX),
	@DontSensitizeMRIPayrollData BIT,
	@IncludeGrossNonPayrollExpenses BIT,
	@IncludeFeeAdjustments BIT,
	@DisplayOverheadBy VARCHAR(32),
	@OverheadOriginatingSubRegionList NVARCHAR(MAX),
	@ConsolidationRegionList NVARCHAR(MAX),
	@CategorizationName VARCHAR(250)
AS 

/* =============================================================================================================================================
	1. Setup Variables
   =========================================================================================================================================== */	
BEGIN

	DECLARE
		@_DisplayOverheadBy VARCHAR(250) = @DisplayOverheadBy,
		@AllocatedOverhead VARCHAR(50) = 'Allocated Overhead',
		@UnAllocatedOverhead VARCHAR(50) = 'Unallocated Overhead',
		@OtherExpensesExpenseType VARCHAR(50) = 'Other Expenses'	

	IF (ISNULL(@_DisplayOverheadBy,'') NOT IN (@AllocatedOverhead,@UnAllocatedOverhead))
	BEGIN
		RAISERROR ('@DisplayOverheadBy have invalid value (Must be one of:Allocated,Unallocated)',18,1)
		RETURN
	END
			
	IF (@ReforecastQuarterName IS NULL OR @ReforecastQuarterName NOT IN ('Q0', 'Q1', 'Q2', 'Q3'))
		SET @ReforecastQuarterName = (SELECT TOP 1
										ReforecastQuarterName 
									 FROM
										dbo.Reforecast 
									 WHERE
										ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
										ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)), 4)
									 ORDER BY
										ReforecastEffectivePeriod DESC)

END

/* =============================================================================================================================================
	2. Execute the 'Details' stored procedure
	
		The stored procedure that follows returns Actual, Original Budget, and Reforecast (Q1, Q2, and Q3) data that has been combined into a
			single dataset. This is returned by the stored procedure and inserted into the temp table below.
	
   =========================================================================================================================================== */
BEGIN

	CREATE TABLE #DetailResult
	(
		ExpenseType VARCHAR(50) NULL,
		InflowOutflow VARCHAR(50) NULL,
		MajorExpenseCategoryName VARCHAR(400) NULL,
		MinorExpenseCategoryName VARCHAR(400) NULL,
		GlobalGlAccountCode VARCHAR(50) NULL,
		GlobalGlAccountName VARCHAR(300) NULL,
		BusinessLine VARCHAR(50) NULL,
		ActivityType VARCHAR(50) NULL,
		ReportingEntityName VARCHAR(100) NULL,
		ReportingEntityType VARCHAR(50) NULL,
		PropertyFundCode VARCHAR(11) NULL,
		FunctionalDepartmentCode VARCHAR(15) NULL,
		AllocationSubRegionName VARCHAR(50) NULL,
		OriginatingSubRegionName VARCHAR(50) NULL,

		ActualsExpensePeriod VARCHAR(6) NULL,
		EntryDate VARCHAR(10) NULL,
		[User] NVARCHAR(20) NULL,
		[Description] NVARCHAR(60) NULL,
		AdditionalDescription NVARCHAR(4000) NULL,
		ReimbursableName VARCHAR(50) NULL,
		FeeAdjustmentCode VARCHAR(10) NULL,
		SourceName VARCHAR(50) NULL,
		GLCategorizationHierarchyKey INT not null,

		MtdActual MONEY NULL,
		MtdOriginalBudget MONEY NULL,
		MtdReforecastQ1 MONEY NULL,
		MtdReforecastQ2 MONEY NULL,
		MtdReforecastQ3 MONEY NULL,
		MtdVarianceQ0 MONEY NULL,
		MtdVarianceQ1 MONEY NULL,
		MtdVarianceQ2 MONEY NULL,
		MtdVarianceQ3 MONEY NULL,
		YtdActual MONEY NULL,
		YtdOriginalBudget MONEY NULL,
		YtdReforecastQ1 MONEY NULL,
		YtdReforecastQ2 MONEY NULL,
		YtdReforecastQ3 MONEY NULL,
		YtdVarianceQ0 MONEY NULL,
		YtdVarianceQ1 MONEY NULL,
		YtdVarianceQ2 MONEY NULL,
		YtdVarianceQ3 MONEY NULL,
		AnnualOriginalBudget MONEY NULL,
		AnnualReforecastQ1 MONEY NULL,
		AnnualReforecastQ2 MONEY NULL,
		AnnualReforecastQ3 MONEY NULL,
		ConsolidationSubRegionName VARCHAR(50) NULL
	)
	INSERT INTO #DetailResult
	(
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

		-- Gross
		-- Month to Date    
		MtdActual,
		MtdOriginalBudget,
		MtdReforecastQ1,
		MtdReforecastQ2,
		MtdReforecastQ3,

		MtdVarianceQ0,
		MtdVarianceQ1,
		MtdVarianceQ2,
		MtdVarianceQ3,
		
		--Year to Date
		YtdActual,	
		YtdOriginalBudget,
		YtdReforecastQ1,
		YtdReforecastQ2,
		YtdReforecastQ3,

		-- Year to Date Variance
		YtdVarianceQ0,
		YtdVarianceQ1,
		YtdVarianceQ2,
		YtdVarianceQ3,
		
		-- Annual
		AnnualOriginalBudget,	
		AnnualReforecastQ1,
		AnnualReforecastQ2,
		AnnualReforecastQ3,
		ConsolidationSubRegionName
	)
	EXEC stp_R_ProfitabilityDetailV2
			@ReportExpensePeriod = @ReportExpensePeriod,
			@ReforecastQuarterName = @ReforecastQuarterName,
			@DestinationCurrency = @DestinationCurrency,
			@GLCategorizationName = @CategorizationName,
			@ActivityTypeList = @ActivityTypeList,
			@EntityList = @EntityList,
			@ConsolidationRegionList = @ConsolidationRegionList,
			@OriginatingSubRegionList = @OverheadOriginatingSubRegionList,
			@DisplayOverheadBy = @DisplayOverheadBy,
			@IncludeFeeAdjustments = @IncludeFeeAdjustments,
			@DontSensitizeMRIPayrollData = @DontSensitizeMRIPayrollData,
			@IncludeGrossNonPayrollExpenses = @IncludeGrossNonPayrollExpenses

	PRINT ('Detail stored procedure finished executing')

END

/* =============================================================================================================================================
	3. Create Result


		┌────────────────────┬────────────────────────────────────────────────────────┐
		│ DisplayOrderNumber │ GroupDisplayName                                       │
		├────────────────────┼────────────────────────────────────────────────────────┤
		│                100 │		REVENUE                                           │
		│                200 │			Fee Revenue                                   │
		│                201 │				Acquisition Fees                          │
		│                202 │					Atlanda Adjustment                    │
		│                202 │					New York Adjustment                   │
		│                201 │              Management Fees                           │
		│                203 │			Total Fee Revenue                             │
		│                210 │			Other Revenue                                 │
		│                211 │				Miscellaneous Income                      │
		│                211 │				Investment Income                         │
		│                212 │			Total Other Income                            │
		│                220 │		TOTAL REVENUE                                     │
		│                230 │	<-BLANK ROW->                                         │
		│                240 │		EXPENSES                                          │
		│                241 │			Payroll Expenses                              │
		│                242 │				Gross Salaries/Bonus/Taxes/Benefits       │
		│                243 │				Reimbursed Salaries/Bonus/Taxes/Benefits  │
		│                244 │			Total Net Salary/Taxes/Benefits               │
		│                245 │			Payroll Reimbursement Rate                    │
		│                250 │	<-BLANK ROW->                                         │
		│                260 │			Overhead Expenses                             │
		│                262 │				Equipment Rental                          │
		│                262 │				Office Rental                             │
		│                271 │				Equipment Rental                          │
		│                271 │				Office Rental                             │
		│                273 │			Total Net Overhead Expenses                   │
		│                274 │			Overhead Reimbursement Rate                   │
		│                280 │	<-BLANK ROW->                                         │
		│                290 │			Non-Payroll Expenses                          │
		│                291 │			Gross Non-Payroll Expenses                    │
		│                292 │				Dues & Subscriptions                      │
		│                292 │				Storage Costs                             │
		│                293 │			Total Gross Non-Payroll Expenses              │
		│                301 │			Net Non-Payroll Expenses                      │
		│                302 │				Dues & Subscriptions                      │
		│                302 │				Storage Costs                             │
		│                303 │			Total Net Non-Payroll Expenses                │
		│                310 │	<-BLANK ROW->                                         │
		│                320 │		TOTAL NET EXPENSES                                │
		│                321 │	<-BLANK ROW->                                         │
		│                322 │		INCOME/(LOSS) Before Taxes & Depreciation         │
		│                323 │	<-BLANK ROW->                                         │
		│                324 │			Depreciation Expenses                         │
		│                325 │		INCOME/(LOSS) Before Taxes                        │
		│                326 │	<-BLANK ROW->                                         │
		│                327 │			Unrealized (Gain)/Loss                        │
		│                327 │			Realized (Gain)/Loss                          │
		│                327 │			Corporate Tax                                 │
		│                330 │		NET INCOME/(LOSS)                                 │
		│                331 │			Profit Margin (Profit / Total Revenue)        │
		│                340 │	<-BLANK ROW->                                         │
		│                341 │		UNKNOWN	                                          │
		└────────────────────┴────────────────────────────────────────────────────────┘

   =========================================================================================================================================== */	
BEGIN

	CREATE TABLE #Result
	(
		NumberOfSpacesToPad TINYINT NOT NULL,
		GroupDisplayCode VARCHAR(500) NOT NULL,
		GroupDisplayName VARCHAR(500) NOT NULL,
		DisplayOrderNumber INT NOT NULL,
		MtdActual MONEY NOT NULL DEFAULT(0),
		MtdOriginalBudget MONEY NOT NULL DEFAULT(0),
		MtdReforecastQ1 MONEY NOT NULL DEFAULT(0),
		MtdReforecastQ2 MONEY NOT NULL DEFAULT(0),
		MtdReforecastQ3 MONEY NOT NULL DEFAULT(0),

		MtdVarianceQ0 MONEY NOT NULL DEFAULT(0),
		MtdVarianceQ1 MONEY NOT NULL DEFAULT(0),
		MtdVarianceQ2 MONEY NOT NULL DEFAULT(0),
		MtdVarianceQ3 MONEY NOT NULL DEFAULT(0),

		MtdVariancePercentageQ0 MONEY NOT NULL DEFAULT(0),
		MtdVariancePercentageQ1 MONEY NOT NULL DEFAULT(0),
		MtdVariancePercentageQ2 MONEY NOT NULL DEFAULT(0),
		MtdVariancePercentageQ3 MONEY NOT NULL DEFAULT(0),

		YtdActual MONEY NOT NULL DEFAULT(0),
		YtdOriginalBudget MONEY NOT NULL DEFAULT(0),
		YtdReforecastQ1 MONEY NOT NULL DEFAULT(0),
		YtdReforecastQ2 MONEY NOT NULL DEFAULT(0),
		YtdReforecastQ3 MONEY NOT NULL DEFAULT(0),

		YtdVarianceQ0 MONEY NOT NULL DEFAULT(0),
		YtdVarianceQ1 MONEY NOT NULL DEFAULT(0),
		YtdVarianceQ2 MONEY NOT NULL DEFAULT(0),
		YtdVarianceQ3 MONEY NOT NULL DEFAULT(0),

		YtdVariancePercentageQ0 MONEY NOT NULL DEFAULT(0),
		YtdVariancePercentageQ1 MONEY NOT NULL DEFAULT(0),
		YtdVariancePercentageQ2 MONEY NOT NULL DEFAULT(0),
		YtdVariancePercentageQ3 MONEY NOT NULL DEFAULT(0),

		AnnualOriginalBudget MONEY NOT NULL DEFAULT(0),
		AnnualReforecastQ1 MONEY NOT NULL DEFAULT(0),
		AnnualReforecastQ2 MONEY NOT NULL DEFAULT(0),
		AnnualReforecastQ3 MONEY NOT NULL DEFAULT(0)
	)

	---------------------------------------------------------------------------------------------
	-- REVENUE (100) -> Fee Revenue (200)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber
		)
		VALUES
			(0, 'REVENUE', 'REVENUE', 100),
			(0, 'FEEREVENUE', 'Fee Revenue', 200)

	END

	---------------------------------------------------------------------------------------------
	-- REVENUE (100) -> Fee Revenue (200) -> Acquisition Fees (201)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
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
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			GLCategorizationHierarchyLatestState.LatestGLMinorCategoryName AS GroupDisplayCode,
			GLCategorizationHierarchyLatestState.LatestGLMinorCategoryName AS GroupDisplayName,
			201 AS DisplayOrderNumber,
			ISNULL(SUM(t1.MtdActual), 0),
			ISNULL(SUM(t1.MtdOriginalBudget), 0),
			ISNULL(SUM(t1.MtdReforecastQ1), 0),
			ISNULL(SUM(t1.MtdReforecastQ2), 0),
			ISNULL(SUM(t1.MtdReforecastQ3), 0),
			ISNULL(SUM(t1.MtdVarianceQ0), 0),
			ISNULL(SUM(t1.MtdVarianceQ1) , 0),
			ISNULL(SUM(t1.MtdVarianceQ2), 0),
			ISNULL(SUM(t1.MtdVarianceQ3), 0),
			ISNULL(SUM(t1.YtdActual), 0),
			ISNULL(SUM(t1.YtdOriginalBudget), 0),
			ISNULL(SUM(t1.YtdReforecastQ1), 0),
			ISNULL(SUM(t1.YtdReforecastQ2), 0),
			ISNULL(SUM(t1.YtdReforecastQ3), 0),
			ISNULL(SUM(t1.YtdVarianceQ0), 0),
			ISNULL(SUM(t1.YtdVarianceQ1), 0),
			ISNULL(SUM(t1.YtdVarianceQ2), 0),
			ISNULL(SUM(t1.YtdVarianceQ3), 0),
			ISNULL(SUM(t1.AnnualOriginalBudget), 0),
			ISNULL(SUM(t1.AnnualReforecastQ1), 0),
			ISNULL(SUM(t1.AnnualReforecastQ2), 0),
			ISNULL(SUM(t1.AnnualReforecastQ3), 0)
		FROM 
			dbo.GLCategorizationHierarchy
			
			INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey

			LEFT OUTER JOIN 
			(
				SELECT 
					* 
				FROM 
					#DetailResult
				WHERE 
					@IncludeFeeAdjustments = 1 OR FeeAdjustmentCode = 'NORMAL'
			) t1 ON 
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = t1.GLCategorizationHierarchyKey
		WHERE	
			GLCategorizationHierarchy.InflowOutflow	= 'Inflow' AND
			GLCategorizationHierarchy.GLFinancialCategoryName = 'Fee Income' AND
			GLCategorizationHierarchy.GLCategorizationName = @CategorizationName
		GROUP BY
			GLCategorizationHierarchyLatestState.LatestGLMinorCategoryName
				
		-- Fee adjustment Insert queries removed as per Change Request 13
	END

	---------------------------------------------------------------------------------------------
	-- REVENUE (100) -> Total Fee Revenue (203)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
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
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			'TOTALFEEREVENUE' AS GroupDisplayCode,
			'Total Fee Revenue' AS GroupDisplayName,
			203 AS DisplayOrderNumber,
			ISNULL(SUM(MtdActual), 0),
			ISNULL(SUM(MtdOriginalBudget), 0),
			ISNULL(SUM(MtdReforecastQ1), 0),
			ISNULL(SUM(MtdReforecastQ2), 0),
			ISNULL(SUM(MtdReforecastQ3), 0),
			ISNULL(SUM(MtdVarianceQ0), 0),
			ISNULL(SUM(MtdVarianceQ1), 0),
			ISNULL(SUM(MtdVarianceQ2), 0),
			ISNULL(SUM(MtdVarianceQ3), 0),
			ISNULL(SUM(YtdActual), 0),
			ISNULL(SUM(YtdOriginalBudget), 0),
			ISNULL(SUM(YtdReforecastQ1), 0),
			ISNULL(SUM(YtdReforecastQ2), 0),
			ISNULL(SUM(YtdReforecastQ3), 0),
			ISNULL(SUM(YtdVarianceQ0), 0),
			ISNULL(SUM(YtdVarianceQ1), 0),
			ISNULL(SUM(YtdVarianceQ2), 0),
			ISNULL(SUM(YtdVarianceQ3), 0),
			ISNULL(SUM(AnnualOriginalBudget), 0),
			ISNULL(SUM(AnnualReforecastQ1), 0),
			ISNULL(SUM(AnnualReforecastQ2), 0),
			ISNULL(SUM(AnnualReforecastQ3), 0)
		FROM
			#DetailResult
		WHERE
			InflowOutflow = 'Inflow' AND
			ExpenseType = 'Fee Income'

	END

	---------------------------------------------------------------------------------------------
	-- REVENUE (100) -> Other Revenue (210)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad,
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber
		)
		VALUES
			(0, 'OTHERREVENUE', 'Other Revenue', 210)
	
	END

	---------------------------------------------------------------------------------------------
	-- REVENUE (100) -> Other Revenue (210) -> Miscellaneous Income / Investment Income (211)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
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
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayCode,
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayName,
			211 AS DisplayOrderNumber,
			ISNULL(SUM(DetailResult.MtdActual), 0),
			ISNULL(SUM(DetailResult.MtdOriginalBudget), 0),
			ISNULL(SUM(DetailResult.MtdReforecastQ1), 0),
			ISNULL(SUM(DetailResult.MtdReforecastQ2), 0),
			ISNULL(SUM(DetailResult.MtdReforecastQ3), 0),
			ISNULL(SUM(DetailResult.MtdVarianceQ0), 0),
			ISNULL(SUM(DetailResult.MtdVarianceQ1), 0),
			ISNULL(SUM(DetailResult.MtdVarianceQ2), 0),
			ISNULL(SUM(DetailResult.MtdVarianceQ3), 0),
			ISNULL(SUM(DetailResult.YtdActual), 0),
			ISNULL(SUM(DetailResult.YtdOriginalBudget), 0),
			ISNULL(SUM(DetailResult.YtdReforecastQ1), 0),
			ISNULL(SUM(DetailResult.YtdReforecastQ2), 0),
			ISNULL(SUM(DetailResult.YtdReforecastQ3), 0),
			ISNULL(SUM(DetailResult.YtdVarianceQ0), 0),
			ISNULL(SUM(DetailResult.YtdVarianceQ1), 0),
			ISNULL(SUM(DetailResult.YtdVarianceQ2), 0),
			ISNULL(SUM(DetailResult.YtdVarianceQ3), 0),
			ISNULL(SUM(DetailResult.AnnualOriginalBudget), 0),
			ISNULL(SUM(DetailResult.AnnualReforecastQ1), 0),
			ISNULL(SUM(DetailResult.AnnualReforecastQ2), 0),
			ISNULL(SUM(DetailResult.AnnualReforecastQ3), 0)
		FROM 
			dbo.GLCategorizationHierarchy
			
			INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey

			LEFT OUTER JOIN #DetailResult DetailResult ON 
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = DetailResult.GLCategorizationHierarchyKey
		WHERE
			GLCategorizationHierarchy.InflowOutflow	= 'Inflow' AND
			GLCategorizationHierarchy.GLFinancialCategoryName = 'Other Revenue' AND
			GLCategorizationHierarchy.GLMajorCategoryName <> 'Realized (Gain)/Loss' AND --IMS #61973
			GLCategorizationHierarchy.GLCategorizationName = @CategorizationName
		GROUP BY
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName

	END

	---------------------------------------------------------------------------------------------
	-- REVENUE (100) -> Total Other Income (212)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
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
			AnnualReforecastQ3
		)
		SELECT 
			0 AS NumberOfSpacesToPad,
			'TOTALOTHERREVENUE' AS GroupDisplayCode,
			'Total Other Revenue' AS GroupDisplayName,
			212 AS DisplayOrderNumber,
			ISNULL(SUM(MtdActual), 0),
			ISNULL(SUM(MtdOriginalBudget), 0),
			ISNULL(SUM(MtdReforecastQ1), 0),
			ISNULL(SUM(MtdReforecastQ2), 0),
			ISNULL(SUM(MtdReforecastQ3), 0),
			ISNULL(SUM(MtdVarianceQ0), 0),
			ISNULL(SUM(MtdVarianceQ1), 0),
			ISNULL(SUM(MtdVarianceQ2), 0),
			ISNULL(SUM(MtdVarianceQ3), 0),
			ISNULL(SUM(YtdActual), 0),
			ISNULL(SUM(YtdOriginalBudget), 0),
			ISNULL(SUM(YtdReforecastQ1), 0),
			ISNULL(SUM(YtdReforecastQ2), 0),
			ISNULL(SUM(YtdReforecastQ3), 0),
			ISNULL(SUM(YtdVarianceQ0), 0),
			ISNULL(SUM(YtdVarianceQ1), 0),
			ISNULL(SUM(YtdVarianceQ2), 0),
			ISNULL(SUM(YtdVarianceQ3), 0),
			ISNULL(SUM(AnnualOriginalBudget), 0),
			ISNULL(SUM(AnnualReforecastQ1), 0),
			ISNULL(SUM(AnnualReforecastQ2), 0),
			ISNULL(SUM(AnnualReforecastQ3), 0)
		FROM 
			#DetailResult 
		WHERE
			InflowOutflow = 'Inflow' AND
			MajorExpenseCategoryName <> 'Realized (Gain)/Loss' AND --IMS #61973
			ExpenseType = 'Other Revenue'

	END

	---------------------------------------------------------------------------------------------
	-- TOTAL REVENUE (220)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
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
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			'TOTALREVENUE' AS GroupDisplayCode,
			'Total Revenue' AS GroupDisplayName,
			220 AS DisplayOrderNumber,
			ISNULL(SUM(MtdActual), 0),
			ISNULL(SUM(MtdOriginalBudget), 0),
			ISNULL(SUM(MtdReforecastQ1), 0),
			ISNULL(SUM(MtdReforecastQ2), 0),
			ISNULL(SUM(MtdReforecastQ3), 0),
			ISNULL(SUM(MtdVarianceQ0), 0),
			ISNULL(SUM(MtdVarianceQ1), 0),
			ISNULL(SUM(MtdVarianceQ2), 0),
			ISNULL(SUM(MtdVarianceQ3), 0),
			ISNULL(SUM(YtdActual), 0),
			ISNULL(SUM(YtdOriginalBudget), 0),
			ISNULL(SUM(YtdReforecastQ1), 0),
			ISNULL(SUM(YtdReforecastQ2), 0),
			ISNULL(SUM(YtdReforecastQ3), 0),
			ISNULL(SUM(YtdVarianceQ0), 0),
			ISNULL(SUM(YtdVarianceQ1), 0),
			ISNULL(SUM(YtdVarianceQ2), 0),
			ISNULL(SUM(YtdVarianceQ3), 0),
			ISNULL(SUM(AnnualOriginalBudget), 0),
			ISNULL(SUM(AnnualReforecastQ1), 0),
			ISNULL(SUM(AnnualReforecastQ2), 0),
			ISNULL(SUM(AnnualReforecastQ3), 0)
		FROM 
			#DetailResult
		WHERE
			InflowOutflow = 'Inflow' AND
			MajorExpenseCategoryName <> 'Realized (Gain)/Loss' --IMS #61973

	END

	---------------------------------------------------------------------------------------------
	-- EXPENSES (240) -> Payroll Expenses (241)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad,
			GroupDisplayCode,
			GroupDisplayName,
			DisplayOrderNumber
		)
		VALUES
			(0, 'BLANK', '', 230),
			(0, 'EXPENSES', 'EXPENSES', 240),
			(0, 'PAYROLLEXPENSES', 'Payroll Expenses', 241)

	END

	---------------------------------------------------------------------------------------------
	-- EXPENSES (240) -> Payroll Expenses (241) -> Gross Salaries/Bonus/Taxes/Benefits (242)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
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
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			'Gross ' + MajorExpenseCategoryName AS GroupDisplayCode,
			'Gross ' + MajorExpenseCategoryName AS GroupDisplayName,
			242 AS DisplayOrderNumber,
			ISNULL(SUM(MtdActual), 0) * -1,
			ISNULL(SUM(MtdOriginalBudget), 0) * -1,
			ISNULL(SUM(MtdReforecastQ1), 0) * -1,
			ISNULL(SUM(MtdReforecastQ2), 0) * -1,
			ISNULL(SUM(MtdReforecastQ3), 0) * -1,
			
			-- Variance amounts adjusted as per IMS 61749
			ISNULL(SUM(CASE WHEN ReimbursableName = 'Reimbursable' THEN (MtdVarianceQ0 * -1) ELSE MtdVarianceQ0 END), 0) * -1,
			ISNULL(SUM(CASE WHEN ReimbursableName = 'Reimbursable' THEN (MtdVarianceQ1 * -1) ELSE MtdVarianceQ1 END), 0) * -1,
			ISNULL(SUM(CASE WHEN ReimbursableName = 'Reimbursable' THEN (MtdVarianceQ2 * -1) ELSE MtdVarianceQ2 END), 0) * -1,
			ISNULL(SUM(CASE WHEN ReimbursableName = 'Reimbursable' THEN (MtdVarianceQ3 * -1) ELSE MtdVarianceQ3 END), 0) * -1,
			ISNULL(SUM(YtdActual), 0) * -1,
			ISNULL(SUM(YtdOriginalBudget), 0) * -1,
			ISNULL(SUM(YtdReforecastQ1), 0) * -1,
			ISNULL(SUM(YtdReforecastQ2), 0) * -1,
			ISNULL(SUM(YtdReforecastQ3), 0) * -1,
			ISNULL(SUM(CASE WHEN ReimbursableName = 'Reimbursable' THEN (YtdVarianceQ0 * -1) ELSE YtdVarianceQ0 END), 0) * -1,
			ISNULL(SUM(CASE WHEN ReimbursableName = 'Reimbursable' THEN (YtdVarianceQ1 * -1) ELSE YtdVarianceQ1 END), 0) * -1,
			ISNULL(SUM(CASE WHEN ReimbursableName = 'Reimbursable' THEN (YtdVarianceQ2 * -1) ELSE YtdVarianceQ2 END), 0) * -1,
			ISNULL(SUM(CASE WHEN ReimbursableName = 'Reimbursable' THEN (YtdVarianceQ3 * -1) ELSE YtdVarianceQ3 END), 0) * -1,
			ISNULL(SUM(AnnualOriginalBudget), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ1), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ2), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ3), 0) * -1
		FROM 
			#DetailResult
		WHERE
			InflowOutflow = 'Outflow' AND
			ExpenseType = 'Payroll'
		GROUP BY
			MajorExpenseCategoryName	

	END

	---------------------------------------------------------------------------------------------
	-- EXPENSES (240) -> Payroll Expenses (241) -> Reimbursed Salaries/Bonus/Taxes/Benefits (243)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
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
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			'Reimbursed ' + MajorExpenseCategoryName AS GroupDisplayCode,
			'Reimbursed ' + MajorExpenseCategoryName AS GroupDisplayName,
			243 AS DisplayOrderNumber,
			ISNULL(SUM(MtdActual), 0) * -1,
			ISNULL(SUM(MtdOriginalBudget), 0) * -1,
			ISNULL(SUM(MtdReforecastQ1), 0) * -1,
			ISNULL(SUM(MtdReforecastQ2), 0) * -1,
			ISNULL(SUM(MtdReforecastQ3), 0) * -1,
			ISNULL(SUM(MtdVarianceQ0), 0) * -1,
			ISNULL(SUM(MtdVarianceQ1), 0) * -1,
			ISNULL(SUM(MtdVarianceQ2), 0) * -1,
			ISNULL(SUM(MtdVarianceQ3), 0) * -1,
			ISNULL(SUM(YtdActual), 0) * -1,
			ISNULL(SUM(YtdOriginalBudget), 0) * -1,
			ISNULL(SUM(YtdReforecastQ1), 0) * -1,
			ISNULL(SUM(YtdReforecastQ2), 0) * -1,
			ISNULL(SUM(YtdReforecastQ3), 0) * -1,
			ISNULL(SUM(YtdVarianceQ0), 0) * -1,
			ISNULL(SUM(YtdVarianceQ1), 0) * -1,
			ISNULL(SUM(YtdVarianceQ2), 0) * -1,
			ISNULL(SUM(YtdVarianceQ3), 0) * -1,
			ISNULL(SUM(AnnualOriginalBudget), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ1), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ2), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ3), 0) * -1
		FROM 
			#DetailResult
		WHERE	
			InflowOutflow = 'Outflow' AND
			ExpenseType = 'Payroll' AND
			ReimbursableName = 'Reimbursable'
		GROUP BY
			#DetailResult.MajorExpenseCategoryName	

	END

	---------------------------------------------------------------------------------------------
	-- EXPENSES (240) -> Total Net Salary/Taxes/Benefits (244)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
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
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			'Total Net ' + MajorExpenseCategoryName AS GroupDisplayCode,
			'Total Net ' + MajorExpenseCategoryName AS GroupDisplayName,
			244 AS DisplayOrderNumber,
			ISNULL(SUM(MtdActual), 0) * -1,
			ISNULL(SUM(MtdOriginalBudget), 0) * -1,
			ISNULL(SUM(MtdReforecastQ1), 0) * -1,
			ISNULL(SUM(MtdReforecastQ2), 0) * -1,
			ISNULL(SUM(MtdReforecastQ3), 0) * -1,
			ISNULL(SUM(MtdVarianceQ0), 0) * -1,
			ISNULL(SUM(MtdVarianceQ1), 0) * -1,
			ISNULL(SUM(MtdVarianceQ2), 0) * -1,
			ISNULL(SUM(MtdVarianceQ3), 0) * -1,
			ISNULL(SUM(YtdActual), 0) * -1,
			ISNULL(SUM(YtdOriginalBudget), 0) * -1,
			ISNULL(SUM(YtdReforecastQ1), 0) * -1,
			ISNULL(SUM(YtdReforecastQ2), 0) * -1,
			ISNULL(SUM(YtdReforecastQ3), 0) * -1,
			ISNULL(SUM(YtdVarianceQ0), 0) * -1,
			ISNULL(SUM(YtdVarianceQ1), 0) * -1,
			ISNULL(SUM(YtdVarianceQ2), 0) * -1,
			ISNULL(SUM(YtdVarianceQ3), 0) * -1,
			ISNULL(SUM(AnnualOriginalBudget), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ1), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ2), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ3), 0) * -1
		FROM
			#DetailResult
		WHERE	
			#DetailResult.InflowOutflow	= 'Outflow' AND
			#DetailResult.ReimbursableName = 'Not Reimbursable' AND
			#DetailResult.ExpenseType = 'Payroll'
		GROUP BY
			#DetailResult.MajorExpenseCategoryName

	END

	---------------------------------------------------------------------------------------------
	-- EXPENSES (240) -> Payroll Reimbursement Rate (245)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
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
			AnnualReforecastQ3
		)
		SELECT 
			0 AS NumberOfSpacesToPad,
			'Payroll Reimbursement Rate' AS GroupDisplayCode,
			'% Recovery' AS GroupDisplayName,
			245 AS DisplayOrderNumber,
			ISNULL(Reimbursed.MtdActual / CASE WHEN Gross.MtdActual = 0 THEN NULL ELSE Gross.MtdActual END, 0),
			ISNULL(Reimbursed.MtdOriginalBudget / CASE WHEN Gross.MtdOriginalBudget = 0 THEN NULL ELSE Gross.MtdOriginalBudget END, 0),
			ISNULL(Reimbursed.MtdReforecastQ1 / CASE WHEN Gross.MtdReforecastQ1 = 0 THEN NULL ELSE Gross.MtdReforecastQ1 END, 0),
			ISNULL(Reimbursed.MtdReforecastQ2 / CASE WHEN Gross.MtdReforecastQ2 = 0 THEN NULL ELSE Gross.MtdReforecastQ2 END, 0),
			ISNULL(Reimbursed.MtdReforecastQ3 / CASE WHEN Gross.MtdReforecastQ3 = 0 THEN NULL ELSE Gross.MtdReforecastQ3 END, 0),
			0,
			0,
			0,
			0,
			ISNULL(Reimbursed.YtdActual / CASE WHEN Gross.YtdActual = 0 THEN NULL ELSE Gross.YtdActual END, 0),
			ISNULL(Reimbursed.YtdOriginalBudget / CASE WHEN Gross.YtdOriginalBudget = 0 THEN NULL ELSE Gross.YtdOriginalBudget END, 0),
			ISNULL(Reimbursed.YtdReforecastQ1 / CASE WHEN Gross.YtdReforecastQ1 = 0 THEN NULL ELSE Gross.YtdReforecastQ1 END, 0),
			ISNULL(Reimbursed.YtdReforecastQ2 / CASE WHEN Gross.YtdReforecastQ2 = 0 THEN NULL ELSE Gross.YtdReforecastQ2 END, 0),
			ISNULL(Reimbursed.YtdReforecastQ3 / CASE WHEN Gross.YtdReforecastQ3 = 0 THEN NULL ELSE Gross.YtdReforecastQ3 END, 0),
			0,
			0,
			0,
			0,
			ISNULL(Reimbursed.AnnualOriginalBudget / CASE WHEN Gross.AnnualOriginalBudget = 0 THEN NULL ELSE Gross.AnnualOriginalBudget END, 0),
			ISNULL(Reimbursed.AnnualReforecastQ1 / CASE WHEN Gross.AnnualReforecastQ1 = 0 THEN NULL ELSE Gross.AnnualReforecastQ1 END, 0),
			ISNULL(Reimbursed.AnnualReforecastQ2 / CASE WHEN Gross.AnnualReforecastQ2 = 0 THEN NULL ELSE Gross.AnnualReforecastQ2 END, 0),
			ISNULL(Reimbursed.AnnualReforecastQ3 / CASE WHEN Gross.AnnualReforecastQ3 = 0 THEN NULL ELSE Gross.AnnualReforecastQ3 END, 0)
		FROM 
		(
			SELECT 
				ISNULL(SUM(MtdActual), 0) AS MtdActual,
				ISNULL(SUM(MtdOriginalBudget), 0) AS MtdOriginalBudget,
				ISNULL(SUM(MtdReforecastQ1), 0) AS MtdReforecastQ1,
				ISNULL(SUM(MtdReforecastQ2), 0) AS MtdReforecastQ2,
				ISNULL(SUM(MtdReforecastQ3), 0) AS MtdReforecastQ3,
				ISNULL(SUM(MtdVarianceQ0), 0) AS MtdVarianceQ0,
				ISNULL(SUM(MtdVarianceQ1), 0) AS MtdVarianceQ1,
				ISNULL(SUM(MtdVarianceQ2), 0) AS MtdVarianceQ2,
				ISNULL(SUM(MtdVarianceQ3), 0) AS MtdVarianceQ3,
				ISNULL(SUM(YtdActual), 0) AS YtdActual,
				ISNULL(SUM(YtdOriginalBudget), 0) AS YtdOriginalBudget,
				ISNULL(SUM(YtdReforecastQ1), 0) AS YtdReforecastQ1,
				ISNULL(SUM(YtdReforecastQ2), 0) AS YtdReforecastQ2,
				ISNULL(SUM(YtdReforecastQ3), 0) AS YtdReforecastQ3,
				ISNULL(SUM(YtdVarianceQ0), 0) AS YtdVarianceQ0,
				ISNULL(SUM(YtdVarianceQ1), 0) AS YtdVarianceQ1,
				ISNULL(SUM(YtdVarianceQ2), 0) AS YtdVarianceQ2,
				ISNULL(SUM(YtdVarianceQ3), 0) AS YtdVarianceQ3,
				ISNULL(SUM(AnnualOriginalBudget), 0) AS AnnualOriginalBudget,
				ISNULL(SUM(AnnualReforecastQ1), 0) AS AnnualReforecastQ1,
				ISNULL(SUM(AnnualReforecastQ2), 0) AS AnnualReforecastQ2,
				ISNULL(SUM(AnnualReforecastQ3), 0) AS AnnualReforecastQ3
			FROM 
				#DetailResult
			WHERE
				InflowOutflow = 'Outflow' AND
				ReimbursableName = 'Reimbursable' AND
				ExpenseType = 'Payroll'
		) Reimbursed

		CROSS JOIN
		(
			SELECT 
				ISNULL(SUM(MtdActual), 0) MtdActual,
				ISNULL(SUM(MtdOriginalBudget), 0) MtdOriginalBudget,
				ISNULL(SUM(MtdReforecastQ1), 0) MtdReforecastQ1,
				ISNULL(SUM(MtdReforecastQ2), 0) MtdReforecastQ2,
				ISNULL(SUM(MtdReforecastQ3), 0) MtdReforecastQ3,
				ISNULL(SUM(MtdVarianceQ0), 0) MtdVarianceQ0,
				ISNULL(SUM(MtdVarianceQ1), 0) MtdVarianceQ1,
				ISNULL(SUM(MtdVarianceQ2), 0) MtdVarianceQ2,
				ISNULL(SUM(MtdVarianceQ3), 0) MtdVarianceQ3,
				ISNULL(SUM(YtdActual), 0) YtdActual,
				ISNULL(SUM(YtdOriginalBudget), 0) YtdOriginalBudget,
				ISNULL(SUM(YtdReforecastQ1), 0) YtdReforecastQ1,
				ISNULL(SUM(YtdReforecastQ2), 0) YtdReforecastQ2,
				ISNULL(SUM(YtdReforecastQ3), 0) YtdReforecastQ3,
				ISNULL(SUM(YtdVarianceQ0), 0) YtdVarianceQ0,
				ISNULL(SUM(YtdVarianceQ1), 0) YtdVarianceQ1,
				ISNULL(SUM(YtdVarianceQ2), 0) YtdVarianceQ2,
				ISNULL(SUM(YtdVarianceQ3), 0) YtdVarianceQ3,
				ISNULL(SUM(AnnualOriginalBudget), 0) AnnualOriginalBudget,
				ISNULL(SUM(AnnualReforecastQ1), 0) AnnualReforecastQ1,
				ISNULL(SUM(AnnualReforecastQ2), 0) AnnualReforecastQ2,
				ISNULL(SUM(AnnualReforecastQ3), 0) AnnualReforecastQ3
			FROM 
				#DetailResult
			WHERE
				InflowOutflow = 'Outflow' AND
				ExpenseType = 'Payroll'
		) Gross 

		UPDATE -- Calculate the Payroll Reimbursement Rate Variance Columns
			#Result
		SET
			MtdVarianceQ0 = (MtdActual - MtdOriginalBudget),
			MtdVarianceQ1 = (MtdActual - MtdReforecastQ1),
			MtdVarianceQ2 = (MtdActual - MtdReforecastQ2),
			MtdVarianceQ3 = (MtdActual - MtdReforecastQ3),
			YtdVarianceQ0 = (YtdActual - YtdOriginalBudget),
			YtdVarianceQ1 = (YtdActual - YtdReforecastQ1),
			YtdVarianceQ2 = (YtdActual - YtdReforecastQ2),
			YtdVarianceQ3 = (YtdActual - YtdReforecastQ3)
		WHERE
			GroupDisplayCode = 'Payroll Reimbursement Rate' AND
			DisplayOrderNumber = 245

	END

	---------------------------------------------------------------------------------------------
	-- EXPENSES (240) -> Overhead Expenses (260)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad,
			GroupDisplayCode,
			GroupDisplayName,
			DisplayOrderNumber
		)
		VALUES
			(0, 'BLANK', '', 250),
			(0, 'OVERHEADEXPENSE', 'Overhead  Expenses', 260)

	END

	--Removed GROSS OVERHEAD Expense header due to IMS #62074 

	IF (@_DisplayOverheadBy = @UnAllocatedOverhead)
	BEGIN
		---------------------------------------------------------------------------------------------
		-- EXPENSES (240) -> Overhead Expenses (260) -> Equipment Rental / Office Rental (262)
		---------------------------------------------------------------------------------------------
		BEGIN

			INSERT INTO #Result
			(
				NumberOfSpacesToPad, 
				GroupDisplayCode, 
				GroupDisplayName, 
				DisplayOrderNumber,
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
				AnnualReforecastQ3
			)
			SELECT 
				0 AS NumberOfSpacesToPad,
				'Gross ' + GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayCode,
				'Gross ' + GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayName,
				262 AS DisplayOrderNumber,
				ISNULL(SUM(OverheadDetailResults.MtdActual), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.MtdOriginalBudget), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.MtdReforecastQ1), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.MtdReforecastQ2), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.MtdReforecastQ3), 0) * -1,
				
				-- Variance amounts adjusted as per IMS 61749
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = 'Reimbursable' THEN (OverheadDetailResults.MtdVarianceQ0 * -1) ELSE OverheadDetailResults.MtdVarianceQ0 END), 0) * -1,
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = 'Reimbursable' THEN (OverheadDetailResults.MtdVarianceQ1 * -1) ELSE OverheadDetailResults.MtdVarianceQ1 END), 0) * -1,
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = 'Reimbursable' THEN (OverheadDetailResults.MtdVarianceQ2 * -1) ELSE OverheadDetailResults.MtdVarianceQ2 END), 0) * -1,
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = 'Reimbursable' THEN (OverheadDetailResults.MtdVarianceQ3 * -1) ELSE OverheadDetailResults.MtdVarianceQ3 END), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.YtdActual), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.YtdOriginalBudget), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.YtdReforecastQ1), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.YtdReforecastQ2), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.YtdReforecastQ3), 0) * -1,
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = 'Reimbursable' THEN (OverheadDetailResults.YtdVarianceQ0 * -1) ELSE OverheadDetailResults.YtdVarianceQ0 END), 0) * -1,
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = 'Reimbursable' THEN (OverheadDetailResults.YtdVarianceQ1 * -1) ELSE OverheadDetailResults.YtdVarianceQ1 END), 0) * -1,
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = 'Reimbursable' THEN (OverheadDetailResults.YtdVarianceQ2 * -1) ELSE OverheadDetailResults.YtdVarianceQ2 END), 0) * -1,
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = 'Reimbursable' THEN (OverheadDetailResults.YtdVarianceQ3 * -1) ELSE OverheadDetailResults.YtdVarianceQ3 END), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.AnnualOriginalBudget), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.AnnualReforecastQ1), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.AnnualReforecastQ2), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.AnnualReforecastQ3), 0) * -1
			FROM 
				dbo.GLCategorizationHierarchy
				
				INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
					GLCategorizationHierarchy.GLCategorizationHierarchyKey = GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey

				LEFT OUTER JOIN
				(
					SELECT
						* 
					FROM 
						#DetailResult
					WHERE 
						ExpenseType = 'Overhead'
				) OverheadDetailResults ON 
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = OverheadDetailResults.GLCategorizationHierarchyKey
			WHERE
				GLCategorizationHierarchy.InflowOutflow	= 'Outflow' AND
				GLCategorizationHierarchy.GLCategorizationName = @CategorizationName AND
				GLCategorizationHierarchy.GLFinancialCategoryName IN ('Overhead', 'Non-Payroll', 'Payroll')  AND
				GLCategorizationHierarchy.GLMajorCategoryName <> 'Corporate Tax'
			GROUP BY
				GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName

		END

	END
	ELSE
	BEGIN
		---------------------------------------------------------------------------------------------
		-- EXPENSES (240) -> Overhead Expenses (260) -> Equipment Rental / Office Rental (262)
		---------------------------------------------------------------------------------------------
		BEGIN

			INSERT INTO #Result
			(
				NumberOfSpacesToPad, 
				GroupDisplayCode, 
				GroupDisplayName, 
				DisplayOrderNumber,
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
				AnnualReforecastQ3
			)
			SELECT 
				0 AS NumberOfSpacesToPad,
				'Gross ' + GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayCode,
				'Gross ' + GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayName,
				262 DisplayOrderNumber,
				ISNULL(SUM(OverheadDetailResults.MtdActual), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.MtdOriginalBudget), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.MtdReforecastQ1), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.MtdReforecastQ2), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.MtdReforecastQ3), 0) * -1,
				-- Variance amounts adjusted as per IMS 61749
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = 'Reimbursable' THEN (OverheadDetailResults.MtdVarianceQ0 * -1) ELSE OverheadDetailResults.MtdVarianceQ0 END), 0) * -1,
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = 'Reimbursable' THEN (OverheadDetailResults.MtdVarianceQ1 * -1) ELSE OverheadDetailResults.MtdVarianceQ1 END), 0) * -1,
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = 'Reimbursable' THEN (OverheadDetailResults.MtdVarianceQ2 * -1) ELSE OverheadDetailResults.MtdVarianceQ2 END), 0) * -1,
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = 'Reimbursable' THEN (OverheadDetailResults.MtdVarianceQ3 * -1) ELSE OverheadDetailResults.MtdVarianceQ3 END), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.YtdActual), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.YtdOriginalBudget), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.YtdReforecastQ1), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.YtdReforecastQ2), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.YtdReforecastQ3), 0) * -1,
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = 'Reimbursable' THEN (OverheadDetailResults.YtdVarianceQ0 * -1) ELSE OverheadDetailResults.YtdVarianceQ0 END), 0) * -1,
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = 'Reimbursable' THEN (OverheadDetailResults.YtdVarianceQ1 * -1) ELSE OverheadDetailResults.YtdVarianceQ1 END), 0) * -1,
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = 'Reimbursable' THEN (OverheadDetailResults.YtdVarianceQ2 * -1) ELSE OverheadDetailResults.YtdVarianceQ2 END), 0) * -1,
				ISNULL(SUM(CASE WHEN OverheadDetailResults.ReimbursableName = 'Reimbursable' THEN (OverheadDetailResults.YtdVarianceQ3 * -1) ELSE OverheadDetailResults.YtdVarianceQ3 END), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.AnnualOriginalBudget), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.AnnualReforecastQ1), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.AnnualReforecastQ2), 0) * -1,
				ISNULL(SUM(OverheadDetailResults.AnnualReforecastQ3), 0) * -1
			FROM 
				dbo.GLCategorizationHierarchy
				
				INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
					GLCategorizationHierarchy.GLCategorizationHierarchyKey = GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey

				INNER JOIN
				(
					SELECT
						* 
					FROM 
						#DetailResult
					WHERE
						ExpenseType = 'Overhead'
				) OverheadDetailResults ON 
					GLCategorizationHierarchy.GLCategorizationHierarchyKey = OverheadDetailResults.GLCategorizationHierarchyKey
			WHERE
				GLCategorizationHierarchy.InflowOutflow	= 'Outflow' AND
				GLCategorizationHierarchy.GLCategorizationName = @CategorizationName AND
				GLCategorizationHierarchy.GLFinancialCategoryName = 'Overhead' AND
				GLCategorizationHierarchy.GLMajorCategoryName <> 'Corporate Tax' 
			GROUP BY
				GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName

		END

	END

	--IMS #62074 Removed logic for Displayoverheadby .Removed due to IMS #62074 - REIMBERSEDOVERHEADEXPENSE header

	IF (@_DisplayOverheadBy = @UnAllocatedOverhead)
	BEGIN
		---------------------------------------------------------------------------------------------
		-- EXPENSES (240) -> Overhead Expenses (260) -> Equipment Rental / Office Rental (271)
		---------------------------------------------------------------------------------------------
		BEGIN
	
			INSERT INTO #Result
			(
				NumberOfSpacesToPad, 
				GroupDisplayCode, 
				GroupDisplayName, 
				DisplayOrderNumber,
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
				AnnualReforecastQ3
			)
			SELECT 
				0 AS NumberOfSpacesToPad,
				'Reimbursed ' + GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayCode,
				'Reimbursed ' + GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayName,
				271 AS DisplayOrderNumber,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdActual), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdOriginalBudget), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdReforecastQ1), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdReforecastQ2), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdReforecastQ3), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdVarianceQ0), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdVarianceQ1), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdVarianceQ2), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdVarianceQ3), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdActual), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdOriginalBudget), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdReforecastQ1), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdReforecastQ2), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdReforecastQ3), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdVarianceQ0), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdVarianceQ1), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdVarianceQ2), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdVarianceQ3), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.AnnualOriginalBudget), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.AnnualReforecastQ1), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.AnnualReforecastQ2), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.AnnualReforecastQ3), 0) * -1
			FROM
				dbo.GLCategorizationHierarchy
				
				INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
					GLCategorizationHierarchy.GLCategorizationHierarchyKey = GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey

				LEFT OUTER JOIN
				(
					SELECT
						*
					FROM
						#DetailResult
					WHERE
						ExpenseType = 'Overhead' AND
						ReimbursableName = 'Reimbursable'
				) OverheadReimbursableDetailResults ON
					GLCategorizationHierarchy.GLCategorizationHierarchyKey = OverheadReimbursableDetailResults.GLCategorizationHierarchyKey
			WHERE
				GLCategorizationHierarchy.InflowOutflow	= 'Outflow' AND
				GLCategorizationHierarchy.GLCategorizationName = @CategorizationName AND
				GLCategorizationHierarchy.GLFinancialCategoryName IN ('Overhead', 'Non-Payroll', 'Payroll') AND
				GLCategorizationHierarchy.GLMajorCategoryName <> 'Corporate Tax'
			GROUP BY
				GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName

		END

	END
	ELSE
	BEGIN
		---------------------------------------------------------------------------------------------
		-- EXPENSES (240) -> Overhead Expenses (260) -> Equipment Rental / Office Rental (271)
		---------------------------------------------------------------------------------------------
		BEGIN

			INSERT INTO #Result
			(
				NumberOfSpacesToPad, 
				GroupDisplayCode, 
				GroupDisplayName, 
				DisplayOrderNumber,
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
				AnnualReforecastQ3
			)
			SELECT 
				0 AS NumberOfSpacesToPad,
				'Reimbursed ' + GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayCode,
				'Reimbursed ' + GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayName,
				271 AS DisplayOrderNumber,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdActual), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdOriginalBudget), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdReforecastQ1), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdReforecastQ2), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdReforecastQ3), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdVarianceQ0), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdVarianceQ1), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdVarianceQ2), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.MtdVarianceQ3), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdActual), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdOriginalBudget), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdReforecastQ1), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdReforecastQ2), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdReforecastQ3), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdVarianceQ0), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdVarianceQ1), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdVarianceQ2), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.YtdVarianceQ3), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.AnnualOriginalBudget), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.AnnualReforecastQ1), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.AnnualReforecastQ2), 0) * -1,
				ISNULL(SUM(OverheadReimbursableDetailResults.AnnualReforecastQ3), 0) * -1
			FROM 
				dbo.GLCategorizationHierarchy
				
				INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
					GLCategorizationHierarchy.GLCategorizationHierarchyKey = GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey

				INNER JOIN
				(
					SELECT 
						* 
					FROM 
						#DetailResult
					WHERE	
						ExpenseType = 'Overhead' AND
						ReimbursableName	= 'Reimbursable'
				) OverheadReimbursableDetailResults ON
					GLCategorizationHierarchy.GLCategorizationHierarchyKey = OverheadReimbursableDetailResults.GLCategorizationHierarchyKey
			WHERE
				GLCategorizationHierarchy.InflowOutflow = 'Outflow' AND
				GLCategorizationHierarchy.GLCategorizationName	= @CategorizationName AND
				GLCategorizationHierarchy.GLFinancialCategoryName = 'Overhead' AND
				GLCategorizationHierarchy.GLMajorCategoryName <> 'Corporate Tax'
			GROUP BY
				GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName

		END

	END

	--IMS #62074 - removed logic for unallocated displayoverheadby

	---------------------------------------------------------------------------------------------
	-- EXPENSES (240) -> Total Net Overhead Expenses (273)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
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
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			'Total Net Overhead Expense' AS GroupDisplayCode,
			'Total Net Overhead Expense' AS GroupDisplayName,
			273 AS DisplayOrderNumber,
			ISNULL(SUM(MtdActual), 0) * -1,
			ISNULL(SUM(MtdOriginalBudget), 0) * -1,
			ISNULL(SUM(MtdReforecastQ1), 0) * -1,
			ISNULL(SUM(MtdReforecastQ2), 0) * -1,
			ISNULL(SUM(MtdReforecastQ3), 0) * -1,
			ISNULL(SUM(MtdVarianceQ0), 0) * -1,
			ISNULL(SUM(MtdVarianceQ1), 0) * -1,
			ISNULL(SUM(MtdVarianceQ2), 0) * -1,
			ISNULL(SUM(MtdVarianceQ3), 0) * -1,
			ISNULL(SUM(YtdActual), 0) * -1,
			ISNULL(SUM(YtdOriginalBudget), 0) * -1,
			ISNULL(SUM(YtdReforecastQ1), 0) * -1,
			ISNULL(SUM(YtdReforecastQ2), 0) * -1,
			ISNULL(SUM(YtdReforecastQ3), 0) * -1,
			ISNULL(SUM(YtdVarianceQ0), 0) * -1,
			ISNULL(SUM(YtdVarianceQ1), 0) * -1,
			ISNULL(SUM(YtdVarianceQ2), 0) * -1,
			ISNULL(SUM(YtdVarianceQ3), 0) * -1,
			ISNULL(SUM(AnnualOriginalBudget), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ1), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ2), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ3), 0) * -1
		FROM
			#DetailResult
		WHERE
			InflowOutflow = 'Outflow' AND
			ExpenseType = 'Overhead' AND
			ReimbursableName = 'Not Reimbursable' AND
			MajorExpenseCategoryName <> 'Corporate Tax'

	END

	---------------------------------------------------------------------------------------------
	-- EXPENSES (240) -> Overhead Reimbursement Rate (274)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
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
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			'Overhead Reimbursement Rate' AS GroupDisplayCode,
			'% Recovery' AS GroupDisplayName,
			274 AS DisplayOrderNumber,
			ISNULL(Reimbursed.MtdActual / CASE WHEN Gross.MtdActual = 0 THEN NULL ELSE Gross.MtdActual END, 0),
			ISNULL(Reimbursed.MtdOriginalBudget / CASE WHEN Gross.MtdOriginalBudget = 0 THEN NULL ELSE Gross.MtdOriginalBudget END, 0),
			ISNULL(Reimbursed.MtdReforecastQ1 / CASE WHEN Gross.MtdReforecastQ1 = 0 THEN NULL ELSE Gross.MtdReforecastQ1 END, 0),
			ISNULL(Reimbursed.MtdReforecastQ2 / CASE WHEN Gross.MtdReforecastQ2 = 0 THEN NULL ELSE Gross.MtdReforecastQ2 END, 0),
			ISNULL(Reimbursed.MtdReforecastQ3 / CASE WHEN Gross.MtdReforecastQ3 = 0 THEN NULL ELSE Gross.MtdReforecastQ3 END, 0),
			0,
			0,
			0,
			0,
			ISNULL(Reimbursed.YtdActual / CASE WHEN Gross.YtdActual = 0 THEN NULL ELSE Gross.YtdActual END, 0),
			ISNULL(Reimbursed.YtdOriginalBudget / CASE WHEN Gross.YtdOriginalBudget = 0 THEN NULL ELSE Gross.YtdOriginalBudget END, 0),
			ISNULL(Reimbursed.YtdReforecastQ1 / CASE WHEN Gross.YtdReforecastQ1 = 0 THEN NULL ELSE Gross.YtdReforecastQ1 END, 0),
			ISNULL(Reimbursed.YtdReforecastQ2 / CASE WHEN Gross.YtdReforecastQ2 = 0 THEN NULL ELSE Gross.YtdReforecastQ2 END, 0),
			ISNULL(Reimbursed.YtdReforecastQ3 / CASE WHEN Gross.YtdReforecastQ3 = 0 THEN NULL ELSE Gross.YtdReforecastQ3 END, 0),
			0,
			0,
			0,
			0,
			ISNULL(Reimbursed.AnnualOriginalBudget / CASE WHEN Gross.AnnualOriginalBudget = 0 THEN NULL ELSE Gross.AnnualOriginalBudget END, 0),
			ISNULL(Reimbursed.AnnualReforecastQ1 / CASE WHEN Gross.AnnualReforecastQ1 = 0 THEN NULL ELSE Gross.AnnualReforecastQ1 END, 0),
			ISNULL(Reimbursed.AnnualReforecastQ2 / CASE WHEN Gross.AnnualReforecastQ2 = 0 THEN NULL ELSE Gross.AnnualReforecastQ2 END, 0),
			ISNULL(Reimbursed.AnnualReforecastQ3 / CASE WHEN Gross.AnnualReforecastQ3 = 0 THEN NULL ELSE Gross.AnnualReforecastQ3 END, 0)
		FROM
		(
			SELECT 
				ISNULL(SUM(MtdActual), 0) MtdActual,
				ISNULL(SUM(MtdOriginalBudget), 0) MtdOriginalBudget,
				ISNULL(SUM(MtdReforecastQ1), 0) MtdReforecastQ1,
				ISNULL(SUM(MtdReforecastQ2), 0) MtdReforecastQ2,
				ISNULL(SUM(MtdReforecastQ3), 0) MtdReforecastQ3,
				ISNULL(SUM(MtdVarianceQ0), 0) MtdVarianceQ0,
				ISNULL(SUM(MtdVarianceQ1), 0) MtdVarianceQ1,
				ISNULL(SUM(MtdVarianceQ2), 0) MtdVarianceQ2,
				ISNULL(SUM(MtdVarianceQ3), 0) MtdVarianceQ3,
				ISNULL(SUM(YtdActual), 0) YtdActual,
				ISNULL(SUM(YtdOriginalBudget), 0) YtdOriginalBudget,
				ISNULL(SUM(YtdReforecastQ1), 0) YtdReforecastQ1,
				ISNULL(SUM(YtdReforecastQ2), 0) YtdReforecastQ2,
				ISNULL(SUM(YtdReforecastQ3), 0) YtdReforecastQ3,
				ISNULL(SUM(YtdVarianceQ0), 0) YtdVarianceQ0,
				ISNULL(SUM(YtdVarianceQ1), 0) YtdVarianceQ1,
				ISNULL(SUM(YtdVarianceQ2), 0) YtdVarianceQ2,
				ISNULL(SUM(YtdVarianceQ3), 0) YtdVarianceQ3,
				ISNULL(SUM(AnnualOriginalBudget), 0) AnnualOriginalBudget,
				ISNULL(SUM(AnnualReforecastQ1), 0) AnnualReforecastQ1,
				ISNULL(SUM(AnnualReforecastQ2), 0) AnnualReforecastQ2,
				ISNULL(SUM(AnnualReforecastQ3), 0) AnnualReforecastQ3
			FROM
				#DetailResult
			WHERE	
				InflowOutflow = 'Outflow' AND
				ExpenseType = 'Overhead' AND
				ReimbursableName = 'Reimbursable' AND
				MajorExpenseCategoryName <> 'Corporate Tax'
		) Reimbursed

		CROSS JOIN
		(
			SELECT
				ISNULL(SUM(MtdActual), 0) MtdActual,
				ISNULL(SUM(MtdOriginalBudget), 0) MtdOriginalBudget,
				ISNULL(SUM(MtdReforecastQ1), 0) MtdReforecastQ1,
				ISNULL(SUM(MtdReforecastQ2), 0) MtdReforecastQ2,
				ISNULL(SUM(MtdReforecastQ3), 0) MtdReforecastQ3,
				ISNULL(SUM(MtdVarianceQ0), 0) MtdVarianceQ0,
				ISNULL(SUM(MtdVarianceQ1), 0) MtdVarianceQ1,
				ISNULL(SUM(MtdVarianceQ2), 0) MtdVarianceQ2,
				ISNULL(SUM(MtdVarianceQ3), 0) MtdVarianceQ3,
				ISNULL(SUM(YtdActual), 0) YtdActual,
				ISNULL(SUM(YtdOriginalBudget), 0) YtdOriginalBudget,
				ISNULL(SUM(YtdReforecastQ1), 0) YtdReforecastQ1,
				ISNULL(SUM(YtdReforecastQ2), 0) YtdReforecastQ2,
				ISNULL(SUM(YtdReforecastQ3), 0) YtdReforecastQ3,
				ISNULL(SUM(YtdVarianceQ0), 0) YtdVarianceQ0,
				ISNULL(SUM(YtdVarianceQ1), 0) YtdVarianceQ1,
				ISNULL(SUM(YtdVarianceQ2), 0) YtdVarianceQ2,
				ISNULL(SUM(YtdVarianceQ3), 0) YtdVarianceQ3,
				ISNULL(SUM(AnnualOriginalBudget), 0) AnnualOriginalBudget,
				ISNULL(SUM(AnnualReforecastQ1), 0) AnnualReforecastQ1,
				ISNULL(SUM(AnnualReforecastQ2), 0) AnnualReforecastQ2,
				ISNULL(SUM(AnnualReforecastQ3), 0) AnnualReforecastQ3
			FROM
				#DetailResult
			WHERE
				InflowOutflow = 'Outflow' AND
				ExpenseType = 'Overhead' AND
				MajorExpenseCategoryName <> 'Corporate Tax'
		) Gross

		--Calculate the Overhead Reimbursement Rate Variance Columns
		UPDATE
			#Result
		SET
			MtdVarianceQ0 = (MtdActual - MtdOriginalBudget),
			MtdVarianceQ1 = (MtdActual - MtdReforecastQ1),
			MtdVarianceQ2 = (MtdActual - MtdReforecastQ2),
			MtdVarianceQ3 = (MtdActual - MtdReforecastQ3),
			YtdVarianceQ0 = (YtdActual - YtdOriginalBudget),
			YtdVarianceQ1 = (YtdActual - YtdReforecastQ1),
			YtdVarianceQ2 = (YtdActual - YtdReforecastQ2),
			YtdVarianceQ3 = (YtdActual - YtdReforecastQ3)
		WHERE
			GroupDisplayCode = 'Overhead Reimbursement Rate' AND
			DisplayOrderNumber = 274

	END

	---------------------------------------------------------------------------------------------
	-- EXPENSES (240) -> Non-Payroll Expenses (290)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber
		)
		VALUES
			(0, 'BLANK', '', 280),
			(0, 'NONPAYROLLEXPENSE', 'Non-Payroll Expenses', 290)

	END

	---------------------------------------------------------------------------------------------
	-- 
	---------------------------------------------------------------------------------------------

	IF (@IncludeGrossNonPayrollExpenses = 1)
	BEGIN
		---------------------------------------------------------------------------------------------
		-- EXPENSES (240) -> Gross Non-Payroll Expenses (291)
		---------------------------------------------------------------------------------------------
		BEGIN

			INSERT INTO #Result
			(
				NumberOfSpacesToPad,
				GroupDisplayCode,
				GroupDisplayName,
				DisplayOrderNumber
			)
			VALUES
				(0, 'GROSSNONPAYROLLEXPENSE', 'Gross Non-Payroll  Expenses', 291)

		END

		---------------------------------------------------------------------------------------------
		-- EXPENSES (240) -> Gross Non-Payroll Expenses (291) - > Storage Costs (292)
		---------------------------------------------------------------------------------------------
		BEGIN

			INSERT INTO #Result
			(
				NumberOfSpacesToPad, 
				GroupDisplayCode, 
				GroupDisplayName, 
				DisplayOrderNumber,
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
				AnnualReforecastQ3
			)
			SELECT 
				0 AS NumberOfSpacesToPad,
				CASE WHEN (GLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits') THEN 'Salaries/Bonus/Taxes/Benefits' ELSE GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName END as GroupDisplayCode,
				--gac.MajorCategoryName GroupDisplayCode,
				CASE WHEN (GLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits') THEN 'Salaries/Bonus/Taxes/Benefits' ELSE GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName END as MajorCategoryName,
				--gac.MajorCategoryName,
				292 AS DisplayOrderNumber,
				ISNULL(SUM(NonPayrollDetailResults.MtdActual), 0) * -1,
				ISNULL(SUM(NonPayrollDetailResults.MtdOriginalBudget), 0) * -1,
				ISNULL(SUM(NonPayrollDetailResults.MtdReforecastQ1), 0) * -1,
				ISNULL(SUM(NonPayrollDetailResults.MtdReforecastQ2), 0) * -1,
				ISNULL(SUM(NonPayrollDetailResults.MtdReforecastQ3), 0) * -1,

				--IMS #61973
				ISNULL(SUM(CASE WHEN NonPayrollDetailResults.InflowOutflow = 'Inflow' THEN (NonPayrollDetailResults.MtdVarianceQ0 * -1) ELSE NonPayrollDetailResults.MtdVarianceQ0 END), 0) * -1,
				ISNULL(SUM(CASE WHEN NonPayrollDetailResults.InflowOutflow = 'Inflow' THEN (NonPayrollDetailResults.MtdVarianceQ1 * -1) ELSE NonPayrollDetailResults.MtdVarianceQ1 END), 0) * -1,
				ISNULL(SUM(CASE WHEN NonPayrollDetailResults.InflowOutflow = 'Inflow' THEN (NonPayrollDetailResults.MtdVarianceQ2 * -1) ELSE NonPayrollDetailResults.MtdVarianceQ2 END), 0) * -1,
				ISNULL(SUM(CASE WHEN NonPayrollDetailResults.InflowOutflow = 'Inflow' THEN (NonPayrollDetailResults.MtdVarianceQ3 * -1) ELSE NonPayrollDetailResults.MtdVarianceQ3 END), 0) * -1,

				ISNULL(SUM(NonPayrollDetailResults.YtdActual), 0) * -1,			
				ISNULL(SUM(NonPayrollDetailResults.YtdOriginalBudget), 0) * -1,
				ISNULL(SUM(NonPayrollDetailResults.YtdReforecastQ1), 0) * -1,
				ISNULL(SUM(NonPayrollDetailResults.YtdReforecastQ2), 0) * -1,
				ISNULL(SUM(NonPayrollDetailResults.YtdReforecastQ3), 0) * -1,

				--IMS #61973
				ISNULL(SUM(CASE WHEN NonPayrollDetailResults.InflowOutflow = 'Inflow' THEN (NonPayrollDetailResults.YtdVarianceQ0 * -1) ELSE NonPayrollDetailResults.YtdVarianceQ0 END), 0) * -1,
				ISNULL(SUM(CASE WHEN NonPayrollDetailResults.InflowOutflow = 'Inflow' THEN (NonPayrollDetailResults.YtdVarianceQ1 * -1) ELSE NonPayrollDetailResults.YtdVarianceQ1 END), 0) * -1,
				ISNULL(SUM(CASE WHEN NonPayrollDetailResults.InflowOutflow = 'Inflow' THEN (NonPayrollDetailResults.YtdVarianceQ2 * -1) ELSE NonPayrollDetailResults.YtdVarianceQ2 END), 0) * -1,
				ISNULL(SUM(CASE WHEN NonPayrollDetailResults.InflowOutflow = 'Inflow' THEN (NonPayrollDetailResults.YtdVarianceQ3 * -1) ELSE NonPayrollDetailResults.YtdVarianceQ3 END), 0) * -1,		

				ISNULL(SUM(NonPayrollDetailResults.AnnualOriginalBudget), 0) * -1,
				ISNULL(SUM(NonPayrollDetailResults.AnnualReforecastQ1), 0) * -1,
				ISNULL(SUM(NonPayrollDetailResults.AnnualReforecastQ2), 0) * -1,
				ISNULL(SUM(NonPayrollDetailResults.AnnualReforecastQ3), 0) * -1
			FROM
				dbo.GLCategorizationHierarchy
				
				INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
					GLCategorizationHierarchy.GLCategorizationHierarchyKey = GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey

				LEFT OUTER JOIN
				(
					SELECT
						*
					FROM
						#DetailResult
					WHERE
						ExpenseType = 'Non-Payroll'
				) NonPayrollDetailResults ON
					GLCategorizationHierarchy.GLCategorizationHierarchyKey = NonPayrollDetailResults.GLCategorizationHierarchyKey
			WHERE			
				GLCategorizationHierarchy.GLCategorizationName = @CategorizationName AND
				GLCategorizationHierarchy.GLFinancialCategoryName = 'Non-Payroll'
			GROUP BY
				CASE
					WHEN
						GLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
					THEN
						'Salaries/Bonus/Taxes/Benefits'
					ELSE
						GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName
				END

		END

		---------------------------------------------------------------------------------------------
		-- EXPENSES (240) -> Gross Non-Payroll Expenses (291) - > Total Gross Non-Payroll Expenses (293)
		---------------------------------------------------------------------------------------------
		BEGIN

			INSERT INTO #Result
			(
				NumberOfSpacesToPad, 
				GroupDisplayCode, 
				GroupDisplayName, 
				DisplayOrderNumber,
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
				AnnualReforecastQ3
			)
			SELECT 
				0 AS NumberOfSpacesToPad,
				'Total Gross Non-Payroll Expense' AS GroupDisplayCode,
				'Total Gross Non-Payroll Expense' AS GroupDisplayName,
				293 AS DisplayOrderNumber,
				ISNULL(SUM(MtdActual), 0) * -1,
				ISNULL(SUM(MtdOriginalBudget), 0) * -1,
				ISNULL(SUM(MtdReforecastQ1), 0) * -1,
				ISNULL(SUM(MtdReforecastQ2), 0) * -1,
				ISNULL(SUM(MtdReforecastQ3), 0) * -1,

				--IMS #61973
				ISNULL(SUM(CASE WHEN InflowOutflow = 'Inflow' THEN (MtdVarianceQ0 * -1) ELSE MtdVarianceQ0 END), 0) * -1,
				ISNULL(SUM(CASE WHEN InflowOutflow = 'Inflow' THEN (MtdVarianceQ1 * -1) ELSE MtdVarianceQ1 END), 0) * -1,
				ISNULL(SUM(CASE WHEN InflowOutflow = 'Inflow' THEN (MtdVarianceQ2 * -1) ELSE MtdVarianceQ2 END), 0) * -1,
				ISNULL(SUM(CASE WHEN InflowOutflow = 'Inflow' THEN (MtdVarianceQ3 * -1) ELSE MtdVarianceQ3 END), 0) * -1,

				ISNULL(SUM(YtdActual), 0) * -1,
				ISNULL(SUM(YtdOriginalBudget), 0) * -1,
				ISNULL(SUM(YtdReforecastQ1), 0) * -1,
				ISNULL(SUM(YtdReforecastQ2), 0) * -1,
				ISNULL(SUM(YtdReforecastQ3), 0) * -1,

				--IMS #61973
				ISNULL(SUM(CASE WHEN InflowOutflow = 'Inflow' THEN (YtdVarianceQ0 * -1) ELSE YtdVarianceQ0 END), 0) * -1,
				ISNULL(SUM(CASE WHEN InflowOutflow = 'Inflow' THEN (YtdVarianceQ1 * -1) ELSE YtdVarianceQ1 END), 0) * -1,
				ISNULL(SUM(CASE WHEN InflowOutflow = 'Inflow' THEN (YtdVarianceQ2 * -1) ELSE YtdVarianceQ2 END), 0) * -1,
				ISNULL(SUM(CASE WHEN InflowOutflow = 'Inflow' THEN (YtdVarianceQ3 * -1) ELSE YtdVarianceQ3 END), 0) * -1,	

				ISNULL(SUM(AnnualOriginalBudget), 0) * -1,
				ISNULL(SUM(AnnualReforecastQ1), 0) * -1,
				ISNULL(SUM(AnnualReforecastQ2), 0) * -1,
				ISNULL(SUM(AnnualReforecastQ3), 0) * -1
			FROM
				 #DetailResult
			WHERE			
				ExpenseType = 'Non-Payroll'
		END

	END

	---------------------------------------------------------------------------------------------
	-- EXPENSES (240) -> Net Non-Payroll Expenses (301)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber
		)
		VALUES
			(0, 'NETNONPAYROLLEXPENSE', 'Net Non-Payroll  Expenses', 301)

	END

	---------------------------------------------------------------------------------------------
	-- EXPENSES (240) -> Net Non-Payroll Expenses (301) - > Dues & Subscriptions (302)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
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
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			CASE WHEN (GLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits') THEN 'Salaries/Bonus/Taxes/Benefits' ELSE GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName END as GroupDisplayCode,
			CASE WHEN (GLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits') THEN 'Salaries/Bonus/Taxes/Benefits' ELSE GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName END as MajorCategoryName,
			302 AS DisplayOrderNumber,
			ISNULL(SUM(NonPayrollNonReimbursableDetailResults.MtdActual), 0) * -1,
			ISNULL(SUM(NonPayrollNonReimbursableDetailResults.MtdOriginalBudget), 0) * -1,
			ISNULL(SUM(NonPayrollNonReimbursableDetailResults.MtdReforecastQ1), 0) * -1,
			ISNULL(SUM(NonPayrollNonReimbursableDetailResults.MtdReforecastQ2), 0) * -1,
			ISNULL(SUM(NonPayrollNonReimbursableDetailResults.MtdReforecastQ3), 0) * -1,

			--IMS #61973
			ISNULL(SUM(CASE WHEN NonPayrollNonReimbursableDetailResults.InflowOutflow = 'Inflow' THEN (NonPayrollNonReimbursableDetailResults.MtdVarianceQ0 * -1) ELSE NonPayrollNonReimbursableDetailResults.MtdVarianceQ0 END), 0) * -1,
			ISNULL(SUM(CASE WHEN NonPayrollNonReimbursableDetailResults.InflowOutflow = 'Inflow' THEN (NonPayrollNonReimbursableDetailResults.MtdVarianceQ1 * -1) ELSE NonPayrollNonReimbursableDetailResults.MtdVarianceQ1 END), 0) * -1,
			ISNULL(SUM(CASE WHEN NonPayrollNonReimbursableDetailResults.InflowOutflow = 'Inflow' THEN (NonPayrollNonReimbursableDetailResults.MtdVarianceQ2 * -1) ELSE NonPayrollNonReimbursableDetailResults.MtdVarianceQ2 END), 0) * -1,
			ISNULL(SUM(CASE WHEN NonPayrollNonReimbursableDetailResults.InflowOutflow = 'Inflow' THEN (NonPayrollNonReimbursableDetailResults.MtdVarianceQ3 * -1) ELSE NonPayrollNonReimbursableDetailResults.MtdVarianceQ3 END), 0) * -1,

			ISNULL(SUM(NonPayrollNonReimbursableDetailResults.YtdActual), 0) * -1,
			ISNULL(SUM(NonPayrollNonReimbursableDetailResults.YtdOriginalBudget), 0) * -1,
			ISNULL(SUM(NonPayrollNonReimbursableDetailResults.YtdReforecastQ1), 0) * -1,
			ISNULL(SUM(NonPayrollNonReimbursableDetailResults.YtdReforecastQ2), 0) * -1,
			ISNULL(SUM(NonPayrollNonReimbursableDetailResults.YtdReforecastQ3), 0) * -1,

			--IMS #61973
			ISNULL(SUM(CASE WHEN NonPayrollNonReimbursableDetailResults.InflowOutflow = 'Inflow' THEN (NonPayrollNonReimbursableDetailResults.YtdVarianceQ0 * -1) ELSE NonPayrollNonReimbursableDetailResults.YtdVarianceQ0 END), 0) * -1,
			ISNULL(SUM(CASE WHEN NonPayrollNonReimbursableDetailResults.InflowOutflow = 'Inflow' THEN (NonPayrollNonReimbursableDetailResults.YtdVarianceQ1 * -1) ELSE NonPayrollNonReimbursableDetailResults.YtdVarianceQ1 END), 0) * -1,
			ISNULL(SUM(CASE WHEN NonPayrollNonReimbursableDetailResults.InflowOutflow = 'Inflow' THEN (NonPayrollNonReimbursableDetailResults.YtdVarianceQ2 * -1) ELSE NonPayrollNonReimbursableDetailResults.YtdVarianceQ2 END), 0) * -1,
			ISNULL(SUM(CASE WHEN NonPayrollNonReimbursableDetailResults.InflowOutflow = 'Inflow' THEN (NonPayrollNonReimbursableDetailResults.YtdVarianceQ3 * -1) ELSE NonPayrollNonReimbursableDetailResults.YtdVarianceQ3 END), 0) * -1,

			ISNULL(SUM(NonPayrollNonReimbursableDetailResults.AnnualOriginalBudget), 0) * -1,
			ISNULL(SUM(NonPayrollNonReimbursableDetailResults.AnnualReforecastQ1), 0) * -1,
			ISNULL(SUM(NonPayrollNonReimbursableDetailResults.AnnualReforecastQ2), 0) * -1,
			ISNULL(SUM(NonPayrollNonReimbursableDetailResults.AnnualReforecastQ3), 0) * -1
		FROM
			dbo.GLCategorizationHierarchy
			
			INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey

			LEFT OUTER JOIN
			(
				SELECT 
					* 
				FROM 
					#DetailResult
				WHERE
					ExpenseType	= 'Non-Payroll' AND
					ReimbursableName = 'Not Reimbursable'
			) NonPayrollNonReimbursableDetailResults ON 
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = NonPayrollNonReimbursableDetailResults.GLCategorizationHierarchyKey
		WHERE
			GLCategorizationHierarchy.GLCategorizationName	= @CategorizationName AND
			GLCategorizationHierarchy.GLFinancialCategoryName = 'Non-Payroll'
		GROUP BY
			CASE
				WHEN
					GLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
				THEN
					'Salaries/Bonus/Taxes/Benefits'
				ELSE
					GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName
			END

	END

	---------------------------------------------------------------------------------------------
	-- EXPENSES (240) -> Total Net Non-Payroll Expenses (303)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode,
			GroupDisplayName, 
			DisplayOrderNumber,
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
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			'Total Net Non-Payroll Expense' AS GroupDisplayCode,
			'Total Net Non-Payroll Expense' AS GroupDisplayName,
			303 AS DisplayOrderNumber,
			ISNULL(SUM(MtdActual), 0) * -1,
			ISNULL(SUM(MtdOriginalBudget), 0) * -1,
			ISNULL(SUM(MtdReforecastQ1), 0) * -1,
			ISNULL(SUM(MtdReforecastQ2), 0) * -1,
			ISNULL(SUM(MtdReforecastQ3), 0) * -1,

			--IMS #61973
			ISNULL(SUM(CASE WHEN InflowOutflow = 'Inflow' THEN (MtdVarianceQ0 * -1) ELSE MtdVarianceQ0 END), 0) * -1,
			ISNULL(SUM(CASE WHEN InflowOutflow = 'Inflow' THEN (MtdVarianceQ1 * -1) ELSE MtdVarianceQ1 END), 0) * -1,
			ISNULL(SUM(CASE WHEN InflowOutflow = 'Inflow' THEN (MtdVarianceQ2 * -1) ELSE MtdVarianceQ2 END), 0) * -1,
			ISNULL(SUM(CASE WHEN InflowOutflow = 'Inflow' THEN (MtdVarianceQ3 * -1) ELSE MtdVarianceQ3 END), 0) * -1,

			ISNULL(SUM(YtdActual), 0) * -1,
			ISNULL(SUM(YtdOriginalBudget), 0) * -1,
			ISNULL(SUM(YtdReforecastQ1), 0) * -1,
			ISNULL(SUM(YtdReforecastQ2), 0) * -1,
			ISNULL(SUM(YtdReforecastQ3), 0) * -1,

			--IMS #61973
			ISNULL(SUM(CASE WHEN InflowOutflow = 'Inflow' THEN (YtdVarianceQ0 * -1) ELSE YtdVarianceQ0 END), 0) * -1,
			ISNULL(SUM(CASE WHEN InflowOutflow = 'Inflow' THEN (YtdVarianceQ1 * -1) ELSE YtdVarianceQ1 END), 0) * -1,
			ISNULL(SUM(CASE WHEN InflowOutflow = 'Inflow' THEN (YtdVarianceQ2 * -1) ELSE YtdVarianceQ2 END), 0) * -1,
			ISNULL(SUM(CASE WHEN InflowOutflow = 'Inflow' THEN (YtdVarianceQ3 * -1) ELSE YtdVarianceQ3 END), 0) * -1,

			ISNULL(SUM(AnnualOriginalBudget), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ1), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ2), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ3), 0) * -1
		FROM
			 #DetailResult
		WHERE
			ExpenseType = 'Non-Payroll' AND
			ReimbursableName = 'Not Reimbursable'

	END

	---------------------------------------------------------------------------------------------
	-- BLANK-ROW
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad,
			GroupDisplayCode,
			GroupDisplayName,
			DisplayOrderNumber)
		VALUES
			(0, 'BLANK', '', 310)

	END

	---------------------------------------------------------------------------------------------
	-- TOTAL NET EXPENSES (320)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
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
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			'TOTALNETEXPENSE' AS GroupDisplayCode,
			'Total Net Expenses' AS GroupDisplayName,
			320 AS DisplayOrderNumber,

			-- MTD Actuals/Q0/Q1/Q2/Q3
			ISNULL(SUM(MtdActual), 0) * -1,
			ISNULL(SUM(MtdOriginalBudget), 0) * -1,
			ISNULL(SUM(MtdReforecastQ1), 0) * -1,
			ISNULL(SUM(MtdReforecastQ2), 0) * -1,
			ISNULL(SUM(MtdReforecastQ3), 0) * -1,

			--IMS #61973
			-- MTD Variance Q0/Q1/Q2/Q3
			ISNULL(SUM(CASE WHEN InflowOutflow = 'Inflow' THEN (MtdVarianceQ0 * -1) ELSE MtdVarianceQ0 END), 0) * -1,
			ISNULL(SUM(CASE WHEN InflowOutflow = 'Inflow' THEN (MtdVarianceQ1 * -1) ELSE MtdVarianceQ1 END), 0) * -1,
			ISNULL(SUM(CASE WHEN InflowOutflow = 'Inflow' THEN (MtdVarianceQ2 * -1) ELSE MtdVarianceQ2 END), 0) * -1,
			ISNULL(SUM(CASE WHEN InflowOutflow = 'Inflow' THEN (MtdVarianceQ3 * -1) ELSE MtdVarianceQ3 END), 0) * -1,

			-- YTD Actual/Q0/Q1/Q2/Q3
			ISNULL(SUM(YtdActual), 0) * -1,
			ISNULL(SUM(YtdOriginalBudget), 0) * -1,
			ISNULL(SUM(YtdReforecastQ1), 0) * -1,
			ISNULL(SUM(YtdReforecastQ2), 0) * -1,
			ISNULL(SUM(YtdReforecastQ3), 0) * -1,

			--IMS #61973
			-- YTD Variance Q0/Q1/Q2/Q3
			ISNULL(SUM(CASE WHEN InflowOutflow = 'Inflow' THEN (YtdVarianceQ0 * -1) ELSE YtdVarianceQ0 END), 0) * -1,
			ISNULL(SUM(CASE WHEN InflowOutflow = 'Inflow' THEN (YtdVarianceQ1 * -1) ELSE YtdVarianceQ1 END), 0) * -1,
			ISNULL(SUM(CASE WHEN InflowOutflow = 'Inflow' THEN (YtdVarianceQ2 * -1) ELSE YtdVarianceQ2 END), 0) * -1,
			ISNULL(SUM(CASE WHEN InflowOutflow = 'Inflow' THEN (YtdVarianceQ3 * -1) ELSE YtdVarianceQ3 END), 0) * -1,

			-- Annual Q0/Q1/Q2/Q3
			ISNULL(SUM(AnnualOriginalBudget), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ1), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ2), 0) * -1,
			ISNULL(SUM(AnnualReforecastQ3), 0) * -1
		FROM
			 #DetailResult
		WHERE
			ReimbursableName = 'Not Reimbursable' AND -- We only want NET amounts only
			ExpenseType <> 'Other Expenses' AND
			InflowOutflow = 'Outflow' -- To prevent unknown and income from being added.

	END

	---------------------------------------------------------------------------------------------
	-- BLANK-ROW
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad,
			GroupDisplayCode,
			GroupDisplayName,
			DisplayOrderNumber
		)
		VALUES
			(0, 'BLANK', '', 321)

	END

	---------------------------------------------------------------------------------------------
	-- INCOME/(LOSS) Before Taxes & Depreciation (322)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
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
			AnnualReforecastQ3
		)
		SELECT 
			0 AS NumberOfSpacesToPad,
			'INCOMELOSSBEFOREDEPRECIATIONANDTAX' AS GroupDisplayCode,
			'Income / (Loss) Before Taxes and Depreciation' AS GroupDisplayName,
			322 AS DisplayOrderNumber,
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
		FROM
		(
			SELECT 
				ISNULL(SUM(MtdActual), 0) AS MtdActual,
				ISNULL(SUM(MtdOriginalBudget), 0) AS MtdOriginalBudget,
				ISNULL(SUM(MtdReforecastQ1), 0) AS MtdReforecastQ1,
				ISNULL(SUM(MtdReforecastQ2), 0) AS MtdReforecastQ2,
				ISNULL(SUM(MtdReforecastQ3), 0) AS MtdReforecastQ3,
				ISNULL(SUM(MtdVarianceQ0), 0) AS MtdVarianceQ0,
				ISNULL(SUM(MtdVarianceQ1), 0) AS MtdVarianceQ1,
				ISNULL(SUM(MtdVarianceQ2), 0) AS MtdVarianceQ2,
				ISNULL(SUM(MtdVarianceQ3), 0) AS MtdVarianceQ3,
				ISNULL(SUM(YtdActual), 0) AS YtdActual,
				ISNULL(SUM(YtdOriginalBudget), 0) AS YtdOriginalBudget,
				ISNULL(SUM(YtdReforecastQ1), 0) AS YtdReforecastQ1,
				ISNULL(SUM(YtdReforecastQ2), 0) AS YtdReforecastQ2,
				ISNULL(SUM(YtdReforecastQ3), 0) AS YtdReforecastQ3,
				ISNULL(SUM(YtdVarianceQ0), 0) AS YtdVarianceQ0,
				ISNULL(SUM(YtdVarianceQ1), 0) AS YtdVarianceQ1,
				ISNULL(SUM(YtdVarianceQ2), 0) AS YtdVarianceQ2,
				ISNULL(SUM(YtdVarianceQ3), 0) AS YtdVarianceQ3,
				ISNULL(SUM(AnnualOriginalBudget), 0) AS AnnualOriginalBudget,
				ISNULL(SUM(AnnualReforecastQ1), 0) AS AnnualReforecastQ1,
				ISNULL(SUM(AnnualReforecastQ2), 0) AS AnnualReforecastQ2,
				ISNULL(SUM(AnnualReforecastQ3), 0) AS AnnualReforecastQ3
			FROM
				#DetailResult
			WHERE
				InflowOutflow = 'Inflow'
		) INC

		CROSS JOIN 
		(
			SELECT 
				ISNULL(SUM(MtdActual), 0) AS MtdActual,
				ISNULL(SUM(MtdOriginalBudget), 0) AS MtdOriginalBudget,
				ISNULL(SUM(MtdReforecastQ1), 0) AS MtdReforecastQ1,
				ISNULL(SUM(MtdReforecastQ2), 0) AS MtdReforecastQ2,
				ISNULL(SUM(MtdReforecastQ3), 0) AS MtdReforecastQ3,
				ISNULL(SUM(MtdVarianceQ0), 0) AS MtdVarianceQ0,
				ISNULL(SUM(MtdVarianceQ1), 0) AS MtdVarianceQ1,
				ISNULL(SUM(MtdVarianceQ2), 0) AS MtdVarianceQ2,
				ISNULL(SUM(MtdVarianceQ3), 0) AS MtdVarianceQ3,
				ISNULL(SUM(YtdActual), 0) AS YtdActual,
				ISNULL(SUM(YtdOriginalBudget), 0) AS YtdOriginalBudget,
				ISNULL(SUM(YtdReforecastQ1), 0) AS YtdReforecastQ1,
				ISNULL(SUM(YtdReforecastQ2), 0) AS YtdReforecastQ2,
				ISNULL(SUM(YtdReforecastQ3), 0) AS YtdReforecastQ3,
				ISNULL(SUM(YtdVarianceQ0), 0) AS YtdVarianceQ0,
				ISNULL(SUM(YtdVarianceQ1), 0) AS YtdVarianceQ1,
				ISNULL(SUM(YtdVarianceQ2), 0) AS YtdVarianceQ2,
				ISNULL(SUM(YtdVarianceQ3), 0) AS YtdVarianceQ3,
				ISNULL(SUM(AnnualOriginalBudget), 0) AS AnnualOriginalBudget,
				ISNULL(SUM(AnnualReforecastQ1), 0) AS AnnualReforecastQ1,
				ISNULL(SUM(AnnualReforecastQ2), 0) AS AnnualReforecastQ2,
				ISNULL(SUM(AnnualReforecastQ3), 0) AS AnnualReforecastQ3
			FROM
				#DetailResult
			WHERE 
				InflowOutflow = 'Outflow' AND
				ReimbursableName = 'Not Reimbursable' AND
				ExpenseType <> 'Other Expenses'
		) EP

	END

	---------------------------------------------------------------------------------------------
	-- BLANK-ROW
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad,
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber
		)
		VALUES
			(0, 'BLANK', '', 323)

	END

	---------------------------------------------------------------------------------------------
	-- INCOME/(LOSS) Before Taxes & Depreciation (322) -> Depreciation Expenses (324)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
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
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayCode,
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayName,
			324 AS DisplayOrderNumber,
			ISNULL(SUM(NotReimbursableDetailResults.MtdActual), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdOriginalBudget), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdReforecastQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdReforecastQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdReforecastQ3), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdVarianceQ0), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdVarianceQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdVarianceQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdVarianceQ3), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdActual), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdOriginalBudget), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdReforecastQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdReforecastQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdReforecastQ3), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdVarianceQ0), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdVarianceQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdVarianceQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdVarianceQ3), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.AnnualOriginalBudget), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.AnnualReforecastQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.AnnualReforecastQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.AnnualReforecastQ3), 0) * -1
		FROM
			dbo.GLCategorizationHierarchy
			
			INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey

			LEFT OUTER JOIN
			(
				SELECT
					*
				FROM
					#DetailResult
				WHERE -- IMS 69602 - Information not being displaying in the Profitability report
					ExpenseType = @OtherExpensesExpenseType AND
					ReimbursableName = 'Not Reimbursable'
			) NotReimbursableDetailResults ON
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = NotReimbursableDetailResults.GLCategorizationHierarchyKey
		WHERE
			GLCategorizationHierarchy.GLCategorizationName = @CategorizationName AND
			GLCategorizationHierarchy.GLMinorCategoryName = 'Depreciation Expense'
			/* IMS 69602 - Information not being displaying in the Profitability report
				Remove Non Payroll from the filter it is now actually Other Expenses, so actually just exclude the financial category
				-- GLCategorizationHierarchy.GLFinancialCategoryName = 'Non-Payroll' AND */
		GROUP BY
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName

	END

	---------------------------------------------------------------------------------------------
	-- INCOME/(LOSS) Before Taxes (325)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
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
			AnnualReforecastQ3
		)
		SELECT 
			0 AS NumberOfSpacesToPad,
			'INCOMELOSSBEFORETAX' AS GroupDisplayCode,
			'Income / (Loss) Before Taxes' AS GroupDisplayName,
			325 AS DisplayOrderNumber,
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
		FROM
		(
			SELECT
				ISNULL(SUM(MtdActual), 0) AS MtdActual,
				ISNULL(SUM(MtdOriginalBudget), 0) AS MtdOriginalBudget,
				ISNULL(SUM(MtdReforecastQ1), 0) AS MtdReforecastQ1,
				ISNULL(SUM(MtdReforecastQ2), 0) AS MtdReforecastQ2,
				ISNULL(SUM(MtdReforecastQ3), 0) AS MtdReforecastQ3,
				ISNULL(SUM(MtdVarianceQ0), 0) AS MtdVarianceQ0,
				ISNULL(SUM(MtdVarianceQ1), 0) AS MtdVarianceQ1,
				ISNULL(SUM(MtdVarianceQ2), 0) AS MtdVarianceQ2,
				ISNULL(SUM(MtdVarianceQ3), 0) AS MtdVarianceQ3,
				ISNULL(SUM(YtdActual), 0) AS YtdActual,
				ISNULL(SUM(YtdOriginalBudget), 0) AS YtdOriginalBudget,
				ISNULL(SUM(YtdReforecastQ1), 0) AS YtdReforecastQ1,
				ISNULL(SUM(YtdReforecastQ2), 0) AS YtdReforecastQ2,
				ISNULL(SUM(YtdReforecastQ3), 0) AS YtdReforecastQ3,
				ISNULL(SUM(YtdVarianceQ0), 0) AS YtdVarianceQ0,
				ISNULL(SUM(YtdVarianceQ1), 0) AS YtdVarianceQ1,
				ISNULL(SUM(YtdVarianceQ2), 0) AS YtdVarianceQ2,
				ISNULL(SUM(YtdVarianceQ3), 0) AS YtdVarianceQ3,
				ISNULL(SUM(AnnualOriginalBudget), 0) AS AnnualOriginalBudget,
				ISNULL(SUM(AnnualReforecastQ1), 0) AS AnnualReforecastQ1,
				ISNULL(SUM(AnnualReforecastQ2), 0) AS AnnualReforecastQ2,
				ISNULL(SUM(AnnualReforecastQ3), 0) AS AnnualReforecastQ3
		FROM
			 #DetailResult
		WHERE
			InflowOutflow = 'Inflow'
		) INC

		CROSS JOIN
		(
			SELECT
				ISNULL(SUM(MtdActual), 0) AS MtdActual,
				ISNULL(SUM(MtdOriginalBudget), 0) AS MtdOriginalBudget,
				ISNULL(SUM(MtdReforecastQ1), 0) AS MtdReforecastQ1,
				ISNULL(SUM(MtdReforecastQ2), 0) AS MtdReforecastQ2,
				ISNULL(SUM(MtdReforecastQ3), 0) AS MtdReforecastQ3,
				ISNULL(SUM(MtdVarianceQ0), 0) AS MtdVarianceQ0,
				ISNULL(SUM(MtdVarianceQ1), 0) AS MtdVarianceQ1,
				ISNULL(SUM(MtdVarianceQ2), 0) AS MtdVarianceQ2,
				ISNULL(SUM(MtdVarianceQ3), 0) AS MtdVarianceQ3,
				ISNULL(SUM(YtdActual), 0) AS YtdActual,
				ISNULL(SUM(YtdOriginalBudget), 0) AS YtdOriginalBudget,
				ISNULL(SUM(YtdReforecastQ1), 0) AS YtdReforecastQ1,
				ISNULL(SUM(YtdReforecastQ2), 0) AS YtdReforecastQ2,
				ISNULL(SUM(YtdReforecastQ3), 0) AS YtdReforecastQ3,
				ISNULL(SUM(YtdVarianceQ0), 0) AS YtdVarianceQ0,
				ISNULL(SUM(YtdVarianceQ1), 0) AS YtdVarianceQ1,
				ISNULL(SUM(YtdVarianceQ2), 0) AS YtdVarianceQ2,
				ISNULL(SUM(YtdVarianceQ3), 0) AS YtdVarianceQ3,
				ISNULL(SUM(AnnualOriginalBudget), 0) AS AnnualOriginalBudget,
				ISNULL(SUM(AnnualReforecastQ1), 0) AS AnnualReforecastQ1,
				ISNULL(SUM(AnnualReforecastQ2), 0) AS AnnualReforecastQ2,
				ISNULL(SUM(AnnualReforecastQ3), 0) AS AnnualReforecastQ3
			FROM
				 #DetailResult
			WHERE
				InflowOutflow = 'Outflow' AND
				ReimbursableName = 'Not Reimbursable' AND
				MajorExpenseCategoryName NOT IN ('Corporate Tax', 'Unrealized (Gain)/Loss', 'Realized (Gain)/Loss')
		) EP

	END

	---------------------------------------------------------------------------------------------
	-- BLANK-ROW
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad,
			GroupDisplayCode,
			GroupDisplayName,
			DisplayOrderNumber
		)
		VALUES
			(0, 'BLANK', '', 326)

	END

	---------------------------------------------------------------------------------------------
	-- INCOME/(LOSS) Before Taxes (325) -> Unrealized (Gain)/Loss (327)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
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
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayCode,
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayName,
			327 AS DisplayOrderNumber,
			ISNULL(SUM(NotReimbursableDetailResults.MtdActual), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdOriginalBudget), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdReforecastQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdReforecastQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdReforecastQ3), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdVarianceQ0), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdVarianceQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdVarianceQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdVarianceQ3), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdActual), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdOriginalBudget), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdReforecastQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdReforecastQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdReforecastQ3), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdVarianceQ0), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdVarianceQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdVarianceQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdVarianceQ3), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.AnnualOriginalBudget), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.AnnualReforecastQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.AnnualReforecastQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.AnnualReforecastQ3), 0) * -1
		FROM
			dbo.GLCategorizationHierarchy
			
			INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey

			LEFT OUTER JOIN
			(
				SELECT
					*
				FROM
					#DetailResult
				WHERE
					ExpenseType = @OtherExpensesExpenseType AND
					ReimbursableName = 'Not Reimbursable'
			) NotReimbursableDetailResults ON
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = NotReimbursableDetailResults.GLCategorizationHierarchyKey
		WHERE
			GLCategorizationHierarchy.InflowOutflow	= 'Outflow' AND
			GLCategorizationHierarchy.GLCategorizationName = @CategorizationName AND
			GLCategorizationHierarchy.GLMinorCategoryName = 'Unrealized (Gain)/Loss'
			/* IMS 69602 - Information not being displaying in the Profitability report
				Remove Non Payroll from the filter it is now actually Other Expenses, so actually just exclude the financial category
				-- GLCategorizationHierarchy.GLFinancialCategoryName = 'Non-Payroll' AND */
		GROUP BY
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName

	END

	---------------------------------------------------------------------------------------------
	-- INCOME/(LOSS) Before Taxes (325) -> Realized (Gain)/Loss (327)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
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
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayCode,
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayName,
			327 AS DisplayOrderNumber,
			ISNULL(SUM(NonReimbursableDetailResults.MtdActual), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.MtdOriginalBudget), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.MtdReforecastQ1), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.MtdReforecastQ2), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.MtdReforecastQ3), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.MtdVarianceQ0), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.MtdVarianceQ1), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.MtdVarianceQ2), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.MtdVarianceQ3), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.YtdActual), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.YtdOriginalBudget), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.YtdReforecastQ1), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.YtdReforecastQ2), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.YtdReforecastQ3), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.YtdVarianceQ0), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.YtdVarianceQ1), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.YtdVarianceQ2), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.YtdVarianceQ3), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.AnnualOriginalBudget), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.AnnualReforecastQ1), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.AnnualReforecastQ2), 0) * -1,
			ISNULL(SUM(NonReimbursableDetailResults.AnnualReforecastQ3), 0) * -1
		FROM
			dbo.GLCategorizationHierarchy
			
			INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey

			LEFT OUTER JOIN
			(
				SELECT
					* 
				FROM
					#DetailResult
				WHERE
					ExpenseType = @OtherExpensesExpenseType AND
					ReimbursableName = 'Not Reimbursable'
			) NonReimbursableDetailResults ON
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = NonReimbursableDetailResults.GLCategorizationHierarchyKey
		WHERE
			GLCategorizationHierarchy.InflowOutflow	= 'Outflow' AND
			GLCategorizationHierarchy.GLCategorizationName = @CategorizationName AND
			GLCategorizationHierarchy.GLMinorCategoryName = 'Realized (Gain)/Loss'
			/* IMS 69602 - Information not being displaying in the Profitability report
				Remove Non Payroll from the filter it is now actually Other Expenses, so actually just exclude the financial category
				-- GLCategorizationHierarchy.GLFinancialCategoryName = 'Non-Payroll' AND */
		GROUP BY
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName

	END

	---------------------------------------------------------------------------------------------
	-- INCOME/(LOSS) Before Taxes (325) -> Corporate Tax (327)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
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
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayCode,
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName AS GroupDisplayName,
			327 AS DisplayOrderNumber,
			ISNULL(SUM(NotReimbursableDetailResults.MtdActual), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdOriginalBudget), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdReforecastQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdReforecastQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdReforecastQ3), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdVarianceQ0), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdVarianceQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdVarianceQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.MtdVarianceQ3), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdActual), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdOriginalBudget), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdReforecastQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdReforecastQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdReforecastQ3), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdVarianceQ0), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdVarianceQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdVarianceQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.YtdVarianceQ3), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.AnnualOriginalBudget), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.AnnualReforecastQ1), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.AnnualReforecastQ2), 0) * -1,
			ISNULL(SUM(NotReimbursableDetailResults.AnnualReforecastQ3), 0) * -1
		FROM
			dbo.GLCategorizationHierarchy
			
			INNER JOIN dbo.GLCategorizationHierarchyLatestState ON
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = GLCategorizationHierarchyLatestState.GLCategorizationHierarchyKey

			LEFT OUTER JOIN
			(
				SELECT
					*
				FROM
					#DetailResult
				WHERE
					ExpenseType = @OtherExpensesExpenseType AND
					ReimbursableName = 'Not Reimbursable'
			) NotReimbursableDetailResults ON
				GLCategorizationHierarchy.GLCategorizationHierarchyKey = NotReimbursableDetailResults.GLCategorizationHierarchyKey
		WHERE
			GLCategorizationHierarchy.InflowOutflow	= 'Outflow' AND
			GLCategorizationHierarchy.GLCategorizationName = @CategorizationName AND
			GLCategorizationHierarchy.GLMinorCategoryName = 'Corporate Tax'
			/* IMS 69602 - Information not being displaying in the Profitability report
				Remove Non Payroll from the filter it is now actually Other Expenses, so actually just exclude the financial category
				-- GLCategorizationHierarchy.GLFinancialCategoryName = 'Non-Payroll' AND */
		GROUP BY
			GLCategorizationHierarchyLatestState.LatestGLMajorCategoryName

	END

	---------------------------------------------------------------------------------------------
	-- NET INCOME/(LOSS) (330)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
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
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			'NETINCOMELOSS' AS GroupDisplayCode,
			'NET INCOME / (LOSS)' AS GroupDisplayName,
			330 AS DisplayOrderNumber,
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
		FROM
		(
			SELECT
				ISNULL(SUM(MtdActual), 0) AS MtdActual,
				ISNULL(SUM(MtdOriginalBudget), 0) AS MtdOriginalBudget,
				ISNULL(SUM(MtdReforecastQ1), 0) AS MtdReforecastQ1,
				ISNULL(SUM(MtdReforecastQ2), 0) AS MtdReforecastQ2,
				ISNULL(SUM(MtdReforecastQ3), 0) AS MtdReforecastQ3,
				ISNULL(SUM(MtdVarianceQ0), 0) AS MtdVarianceQ0,
				ISNULL(SUM(MtdVarianceQ1), 0) AS MtdVarianceQ1,
				ISNULL(SUM(MtdVarianceQ2), 0) AS MtdVarianceQ2,
				ISNULL(SUM(MtdVarianceQ3), 0) AS MtdVarianceQ3,
				ISNULL(SUM(YtdActual), 0) AS YtdActual,
				ISNULL(SUM(YtdOriginalBudget), 0) AS YtdOriginalBudget,
				ISNULL(SUM(YtdReforecastQ1), 0) AS YtdReforecastQ1,
				ISNULL(SUM(YtdReforecastQ2), 0) AS YtdReforecastQ2,
				ISNULL(SUM(YtdReforecastQ3), 0) AS YtdReforecastQ3,
				ISNULL(SUM(YtdVarianceQ0), 0) AS YtdVarianceQ0,
				ISNULL(SUM(YtdVarianceQ1), 0) AS YtdVarianceQ1,
				ISNULL(SUM(YtdVarianceQ2), 0) AS YtdVarianceQ2,
				ISNULL(SUM(YtdVarianceQ3), 0) AS YtdVarianceQ3,
				ISNULL(SUM(AnnualOriginalBudget), 0) AS AnnualOriginalBudget,
				ISNULL(SUM(AnnualReforecastQ1), 0) AS AnnualReforecastQ1,
				ISNULL(SUM(AnnualReforecastQ2), 0) AS AnnualReforecastQ2,
				ISNULL(SUM(AnnualReforecastQ3), 0) AS AnnualReforecastQ3
			FROM
				 #DetailResult
			WHERE
				InflowOutflow = 'Inflow'
		) INC

		CROSS JOIN
		(
			SELECT
				ISNULL(SUM(MtdActual), 0) AS MtdActual,
				ISNULL(SUM(MtdOriginalBudget), 0) AS MtdOriginalBudget,
				ISNULL(SUM(MtdReforecastQ1), 0) AS MtdReforecastQ1,
				ISNULL(SUM(MtdReforecastQ2), 0) AS MtdReforecastQ2,
				ISNULL(SUM(MtdReforecastQ3), 0) AS MtdReforecastQ3,
				ISNULL(SUM(MtdVarianceQ0), 0) AS MtdVarianceQ0,
				ISNULL(SUM(MtdVarianceQ1), 0) AS MtdVarianceQ1,
				ISNULL(SUM(MtdVarianceQ2), 0) AS MtdVarianceQ2,
				ISNULL(SUM(MtdVarianceQ3), 0) AS MtdVarianceQ3,
				ISNULL(SUM(YtdActual), 0) AS YtdActual,
				ISNULL(SUM(YtdOriginalBudget), 0) AS YtdOriginalBudget,
				ISNULL(SUM(YtdReforecastQ1), 0) AS YtdReforecastQ1,
				ISNULL(SUM(YtdReforecastQ2), 0) AS YtdReforecastQ2,
				ISNULL(SUM(YtdReforecastQ3), 0) AS YtdReforecastQ3,
				ISNULL(SUM(YtdVarianceQ0), 0) AS YtdVarianceQ0,
				ISNULL(SUM(YtdVarianceQ1), 0) AS YtdVarianceQ1,
				ISNULL(SUM(YtdVarianceQ2), 0) AS YtdVarianceQ2,
				ISNULL(SUM(YtdVarianceQ3), 0) AS YtdVarianceQ3,
				ISNULL(SUM(AnnualOriginalBudget), 0) AS AnnualOriginalBudget,
				ISNULL(SUM(AnnualReforecastQ1), 0) AS AnnualReforecastQ1,
				ISNULL(SUM(AnnualReforecastQ2), 0) AS AnnualReforecastQ2,
				ISNULL(SUM(AnnualReforecastQ3), 0) AS AnnualReforecastQ3
			FROM
				#DetailResult
			WHERE
				InflowOutflow = 'Outflow' AND
				ReimbursableName = 'Not Reimbursable'
		) EP

	END

	---------------------------------------------------------------------------------------------
	-- NET INCOME/(LOSS) (330) -> Profit Margin (Profit / Total Revenue) (331)
	---------------------------------------------------------------------------------------------
	BEGIN

		INSERT INTO #Result
		(
			NumberOfSpacesToPad, 
			GroupDisplayCode, 
			GroupDisplayName, 
			DisplayOrderNumber,
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
			AnnualReforecastQ3
		)
		SELECT
			0 AS NumberOfSpacesToPad,
			'PROFITMARGIN' AS GroupDisplayCode,
			'Profit Margin (Net Income/(Loss)/ Total Revenue)' AS GroupDisplayName,
			331 AS DisplayOrderNumber,
			ISNULL(((INC.MtdActual + EP.MtdActual) / CASE WHEN INC.MtdActual <> 0 THEN INC.MtdActual ELSE NULL END), 0) AS MtdActual,
			ISNULL(((INC.MtdOriginalBudget + EP.MtdOriginalBudget) / CASE WHEN INC.MtdOriginalBudget <> 0 THEN INC.MtdOriginalBudget ELSE NULL END), 0) AS MtdOriginalBudget,
			ISNULL(((INC.MtdReforecastQ1 + EP.MtdReforecastQ1) / CASE WHEN INC.MtdReforecastQ1 <> 0 THEN INC.MtdReforecastQ1 ELSE NULL END), 0) AS MtdReforecastQ1,
			ISNULL(((INC.MtdReforecastQ2 + EP.MtdReforecastQ2) / CASE WHEN INC.MtdReforecastQ2 <> 0 THEN INC.MtdReforecastQ2 ELSE NULL END), 0) AS MtdReforecastQ2,
			ISNULL(((INC.MtdReforecastQ3 + EP.MtdReforecastQ3) / CASE WHEN INC.MtdReforecastQ3 <> 0 THEN INC.MtdReforecastQ3 ELSE NULL END), 0) AS MtdReforecastQ3,
			0 AS MtdVarianceQ0, --Done Below for it use these results to sub calculate
			0 AS MtdVarianceQ1, --Done Below for it use these results to sub calculate
			0 AS MtdVarianceQ2, --Done Below for it use these results to sub calculate
			0 AS MtdVarianceQ3, --Done Below for it use these results to sub calculate
			ISNULL(((INC.YtdActual + EP.YtdActual) / CASE WHEN INC.YtdActual <> 0 THEN INC.YtdActual ELSE NULL END), 0) AS YtdActual,
			ISNULL(((INC.YtdOriginalBudget + EP.YtdOriginalBudget) / CASE WHEN INC.YtdOriginalBudget <> 0 THEN INC.YtdOriginalBudget ELSE NULL END), 0) AS YtdOriginalBudget,
			ISNULL(((INC.YtdReforecastQ1 + EP.YtdReforecastQ1) / CASE WHEN INC.YtdReforecastQ1 <> 0 THEN INC.YtdReforecastQ1 ELSE NULL END), 0) AS YtdReforecastQ1,
			ISNULL(((INC.YtdReforecastQ2 + EP.YtdReforecastQ2) / CASE WHEN INC.YtdReforecastQ2 <> 0 THEN INC.YtdReforecastQ2 ELSE NULL END), 0) AS YtdReforecastQ2,
			ISNULL(((INC.YtdReforecastQ3 + EP.YtdReforecastQ3) / CASE WHEN INC.YtdReforecastQ3 <> 0 THEN INC.YtdReforecastQ3 ELSE NULL END), 0) AS YtdReforecastQ3,
			0 AS YtdVarianceQ0, --Done Below for it use these results to sub calculate
			0 AS YtdVarianceQ1, --Done Below for it use these results to sub calculate
			0 AS YtdVarianceQ2, --Done Below for it use these results to sub calculate
			0 AS YtdVarianceQ3, --Done Below for it use these results to sub calculate
			ISNULL(((INC.AnnualOriginalBudget + EP.AnnualOriginalBudget) / CASE WHEN INC.AnnualOriginalBudget <> 0 THEN INC.AnnualOriginalBudget ELSE NULL END), 0) AS AnnualOriginalBudget,
			ISNULL(((INC.AnnualReforecastQ1 + EP.AnnualReforecastQ1) / CASE WHEN INC.AnnualReforecastQ1 <> 0 THEN INC.AnnualReforecastQ1 ELSE NULL END), 0) AS AnnualReforecastQ1,
			ISNULL(((INC.AnnualReforecastQ2 + EP.AnnualReforecastQ2) / CASE WHEN INC.AnnualReforecastQ2 <> 0 THEN INC.AnnualReforecastQ2 ELSE NULL END), 0) AS AnnualReforecastQ2,
			ISNULL(((INC.AnnualReforecastQ3 + EP.AnnualReforecastQ3) / CASE WHEN INC.AnnualReforecastQ3 <> 0 THEN INC.AnnualReforecastQ3 ELSE NULL END), 0) AS AnnualReforecastQ3
		FROM
		(
			SELECT
				ISNULL(SUM(MtdActual), 0) AS MtdActual,
				ISNULL(SUM(MtdOriginalBudget), 0) AS MtdOriginalBudget,
				ISNULL(SUM(MtdReforecastQ1), 0) AS MtdReforecastQ1,
				ISNULL(SUM(MtdReforecastQ2), 0) AS MtdReforecastQ2,
				ISNULL(SUM(MtdReforecastQ3), 0) AS MtdReforecastQ3,
				ISNULL(SUM(MtdVarianceQ0), 0) AS MtdVarianceQ0,
				ISNULL(SUM(MtdVarianceQ1), 0) AS MtdVarianceQ1,
				ISNULL(SUM(MtdVarianceQ2), 0) AS MtdVarianceQ2,
				ISNULL(SUM(MtdVarianceQ3), 0) AS MtdVarianceQ3,
				ISNULL(SUM(YtdActual), 0) AS YtdActual,
				ISNULL(SUM(YtdOriginalBudget), 0) AS YtdOriginalBudget,
				ISNULL(SUM(YtdReforecastQ1), 0) AS YtdReforecastQ1,
				ISNULL(SUM(YtdReforecastQ2), 0) AS YtdReforecastQ2,
				ISNULL(SUM(YtdReforecastQ3), 0) AS YtdReforecastQ3,
				ISNULL(SUM(YtdVarianceQ0), 0) AS YtdVarianceQ0,
				ISNULL(SUM(YtdVarianceQ1), 0) AS YtdVarianceQ1,
				ISNULL(SUM(YtdVarianceQ2), 0) AS YtdVarianceQ2,
				ISNULL(SUM(YtdVarianceQ3), 0) AS YtdVarianceQ3,
				ISNULL(SUM(AnnualOriginalBudget), 0) AS AnnualOriginalBudget,
				ISNULL(SUM(AnnualReforecastQ1), 0) AS AnnualReforecastQ1,
				ISNULL(SUM(AnnualReforecastQ2), 0) AS AnnualReforecastQ2,
				ISNULL(SUM(AnnualReforecastQ3), 0) AS AnnualReforecastQ3
		FROM
			 #DetailResult
		WHERE
			InflowOutflow = 'Inflow'
		) INC

		CROSS JOIN
		(
			SELECT
				ISNULL(SUM(MtdActual), 0) AS MtdActual,
				ISNULL(SUM(MtdOriginalBudget), 0) AS MtdOriginalBudget,
				ISNULL(SUM(MtdReforecastQ1), 0) AS MtdReforecastQ1,
				ISNULL(SUM(MtdReforecastQ2), 0) AS MtdReforecastQ2,
				ISNULL(SUM(MtdReforecastQ3), 0) AS MtdReforecastQ3,
				ISNULL(SUM(MtdVarianceQ0), 0) AS MtdVarianceQ0,
				ISNULL(SUM(MtdVarianceQ1), 0) AS MtdVarianceQ1,
				ISNULL(SUM(MtdVarianceQ2), 0) AS MtdVarianceQ2,
				ISNULL(SUM(MtdVarianceQ3), 0) AS MtdVarianceQ3,
				ISNULL(SUM(YtdActual), 0) AS YtdActual,
				ISNULL(SUM(YtdOriginalBudget), 0) AS YtdOriginalBudget,
				ISNULL(SUM(YtdReforecastQ1), 0) AS YtdReforecastQ1,
				ISNULL(SUM(YtdReforecastQ2), 0) AS YtdReforecastQ2,
				ISNULL(SUM(YtdReforecastQ3), 0) AS YtdReforecastQ3,
				ISNULL(SUM(YtdVarianceQ0), 0) AS YtdVarianceQ0,
				ISNULL(SUM(YtdVarianceQ1), 0) AS YtdVarianceQ1,
				ISNULL(SUM(YtdVarianceQ2), 0) AS YtdVarianceQ2,
				ISNULL(SUM(YtdVarianceQ3), 0) AS YtdVarianceQ3,
				ISNULL(SUM(AnnualOriginalBudget), 0) AS AnnualOriginalBudget,
				ISNULL(SUM(AnnualReforecastQ1), 0) AS AnnualReforecastQ1,
				ISNULL(SUM(AnnualReforecastQ2), 0) AS AnnualReforecastQ2,
				ISNULL(SUM(AnnualReforecastQ3), 0) AS AnnualReforecastQ3
			FROM
				#DetailResult
			WHERE
				InflowOutflow = 'Outflow' AND
				ReimbursableName = 'Not Reimbursable'
		) EP

		--Calculate the Profit Variance Columns
		UPDATE
			#Result
		SET		
			MtdVarianceQ0 = MtdActual - MtdOriginalBudget,
			MtdVarianceQ1 = MtdActual - MtdReforecastQ1,
			MtdVarianceQ2 = MtdActual - MtdReforecastQ2,
			MtdVarianceQ3 = MtdActual - MtdReforecastQ3,
			YtdVarianceQ0 = YtdActual - YtdOriginalBudget,
			YtdVarianceQ1 = YtdActual - YtdReforecastQ1,
			YtdVarianceQ2 = YtdActual - YtdReforecastQ2,
			YtdVarianceQ3 = YtdActual - YtdReforecastQ3
		WHERE
			GroupDisplayCode = 'PROFITMARGIN' AND
			DisplayOrderNumber = 331

	END

END
		
	--------------------------------------------------------------------------------------------------------------------------------------	
	--Final Common block to set the Variance% columns, and cater for UNKNOWNS
	--------------------------------------------------------------------------------------------------------------------------------------	
	BEGIN

		UPDATE
			#Result
		SET
			MtdVariancePercentageQ0 = ISNULL(MtdVarianceQ0 / CASE WHEN MtdOriginalBudget <> 0 THEN MtdOriginalBudget ELSE NULL END, 0) ,
			MtdVariancePercentageQ1 = ISNULL(MtdVarianceQ1 / CASE WHEN MtdReforecastQ1 <> 0 THEN MtdReforecastQ1 ELSE NULL END, 0) ,
			MtdVariancePercentageQ2 = ISNULL(MtdVarianceQ2 / CASE WHEN MtdReforecastQ2 <> 0 THEN MtdReforecastQ2 ELSE NULL END, 0) ,
			MtdVariancePercentageQ3 = ISNULL(MtdVarianceQ3 / CASE WHEN MtdReforecastQ3 <> 0 THEN MtdReforecastQ3 ELSE NULL END, 0) ,

			YtdVariancePercentageQ0 = ISNULL(YtdVarianceQ0 / CASE WHEN YtdOriginalBudget <> 0 THEN YtdOriginalBudget ELSE NULL END, 0) ,
			YtdVariancePercentageQ1 = ISNULL(YtdVarianceQ1 / CASE WHEN YtdReforecastQ1 <> 0 THEN YtdReforecastQ1 ELSE NULL END, 0) ,
			YtdVariancePercentageQ2 = ISNULL(YtdVarianceQ2 / CASE WHEN YtdReforecastQ2 <> 0 THEN YtdReforecastQ2 ELSE NULL END, 0) ,
			YtdVariancePercentageQ3 = ISNULL(YtdVarianceQ3 / CASE WHEN YtdReforecastQ3 <> 0 THEN YtdReforecastQ3 ELSE NULL END, 0) 
		WHERE
			GroupDisplayCode NOT IN('Payroll Reimbursement Rate','Overhead Reimbursement Rate','PROFITMARGIN')

		--UNKNOWN MajorCategory

		---------------------------------------------------------------------------------------------
		-- BLANK-ROW
		---------------------------------------------------------------------------------------------
		BEGIN

			INSERT INTO #Result
			(
				NumberOfSpacesToPad,
				GroupDisplayCode, 
				GroupDisplayName, 
				DisplayOrderNumber
			)
			VALUES
				(0, 'BLANK', '', 340)

		END

		---------------------------------------------------------------------------------------------
		-- UNKNOWN (341)
		---------------------------------------------------------------------------------------------
		BEGIN

			INSERT INTO #Result
			(
				NumberOfSpacesToPad, 
				GroupDisplayCode, 
				GroupDisplayName, 
				DisplayOrderNumber,
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
				AnnualReforecastQ3
			)
			SELECT
				0 AS NumberOfSpacesToPad,
				'UNKNOWN' AS GroupDisplayCode,
				'Unknown' AS GroupDisplayName,
				341 AS DisplayOrderNumber,
				ISNULL(SUM(MtdActual), 0),
				ISNULL(SUM(MtdOriginalBudget), 0),
				ISNULL(SUM(MtdReforecastQ1), 0),
				ISNULL(SUM(MtdReforecastQ2), 0),
				ISNULL(SUM(MtdReforecastQ3), 0),
				ISNULL(SUM(MtdVarianceQ0), 0),
				ISNULL(SUM(MtdVarianceQ1), 0),
				ISNULL(SUM(MtdVarianceQ2), 0),
				ISNULL(SUM(MtdVarianceQ3), 0),
				ISNULL(SUM(YtdActual), 0),
				ISNULL(SUM(YtdOriginalBudget), 0),
				ISNULL(SUM(YtdReforecastQ1), 0),
				ISNULL(SUM(YtdReforecastQ2), 0),
				ISNULL(SUM(YtdReforecastQ3), 0),
				ISNULL(SUM(YtdVarianceQ0), 0),
				ISNULL(SUM(YtdVarianceQ1), 0),
				ISNULL(SUM(YtdVarianceQ2), 0),
				ISNULL(SUM(YtdVarianceQ3), 0),
				ISNULL(SUM(AnnualOriginalBudget), 0),
				ISNULL(SUM(AnnualReforecastQ1), 0),
				ISNULL(SUM(AnnualReforecastQ2), 0),
				ISNULL(SUM(AnnualReforecastQ3), 0)
			FROM
				#DetailResult
			WHERE
				MajorExpenseCategoryName = 'UNKNOWN'
			HAVING
				(
					ISNULL(SUM(MtdActual), 0) <> 0 OR
					ISNULL(SUM(MtdOriginalBudget), 0) <> 0 OR
					ISNULL(SUM(MtdReforecastQ1), 0) <> 0 OR
					ISNULL(SUM(MtdReforecastQ2), 0) <> 0 OR
					ISNULL(SUM(MtdReforecastQ3), 0) <> 0 OR
					ISNULL(SUM(MtdVarianceQ0), 0) <> 0 OR
					ISNULL(SUM(MtdVarianceQ1), 0) <> 0 OR
					ISNULL(SUM(MtdVarianceQ2), 0) <> 0 OR
					ISNULL(SUM(MtdVarianceQ3), 0) <> 0 OR
					ISNULL(SUM(YtdActual), 0) <> 0 OR
					ISNULL(SUM(YtdOriginalBudget), 0) <> 0 OR
					ISNULL(SUM(YtdReforecastQ1), 0) <> 0 OR
					ISNULL(SUM(YtdReforecastQ2), 0) <> 0 OR
					ISNULL(SUM(YtdReforecastQ3), 0) <> 0 OR
					ISNULL(SUM(YtdVarianceQ0), 0) <> 0 OR
					ISNULL(SUM(YtdVarianceQ1), 0) <> 0 OR
					ISNULL(SUM(YtdVarianceQ2), 0) <> 0 OR
					ISNULL(SUM(YtdVarianceQ3), 0) <> 0 OR
					ISNULL(SUM(AnnualOriginalBudget), 0) <> 0 OR
					ISNULL(SUM(AnnualReforecastQ1), 0) <> 0 OR
					ISNULL(SUM(AnnualReforecastQ2), 0) <> 0 OR
					ISNULL(SUM(AnnualReforecastQ3), 0) <> 0
				)

		END

	END

/* ====================================================================================================================================	
	Final Result
   ================================================================================================================================= */	
BEGIN

	SELECT
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
	FROM
		#Result
	ORDER BY
		DisplayOrderNumber,
		#Result.GroupDisplayCode

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

END

/* =============================================================================================================================================
	Clean Up
   =========================================================================================================================================== */
BEGIN

	IF 	OBJECT_ID('tempdb..#DetailResult') IS NOT NULL
		DROP TABLE #DetailResult

	IF 	OBJECT_ID('tempdb..#Result') IS NOT NULL
		DROP TABLE #Result

END



GO


