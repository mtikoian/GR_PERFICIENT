USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]
GO


/***************************************************************************************************************************************
Description
	This stored procedure processes payroll reforecast data and uploads it to the
	ProfitabilityReforecast table in the data warehouse (GrReporting.dbo.ProfitabilityReforecast). 
	The stored procedure works as follows:
	1.	Source budgets that are to be processed from the BudgetsToProcessTable
	2.	Source Budgets from TapasGlobalBudgeting.Budget table
	3.	Source records associated to the Payroll Allocation data (e.g. BudgetProject and BudgetEmployee)
	4.	Source Payroll and Overhead Allocation Data from TAPAS Global Budgeting
	5.	Map the Pre-Tax, Tax and Overhead data to their associated records (step 4) from Tapas Global Budgeting
	6.	Combine tables into #ProfitabilityPayrollMapping table and map to GDM data
	7.	Create Global and Local Categorization mapping table
	8.	Map table to the #ProfitabilityReforecast table with the same structure as the GrReporting.dbo.ProfitabilityReforecast table
	9.	Insert Actuals from the Budget Profitability Actual table in GBS
	10.	Insert records with unknowns into the ProfitabilityReforecastUnknowns table.
	11. Insert budget records into the GrReporting.dbo.ProfitabilityReforecast table
	12. Mark budgets as being successfully processed into the warehouse
	13. Clean up
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-06-07		: PKayongo	:	Added ConsolidationRegion mapping as per CC16. Added the field to the 
											data inserted into the warehouse. 	
****************************************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]
	@DataPriorToDate DATETIME=NULL
AS

BEGIN

PRINT '####'
PRINT 'stp_IU_LoadGrProfitabiltyPayrollReforecast'
PRINT '####'

SET NOCOUNT ON

DECLARE
	@RowCount INT,
	@StartTime DATETIME

IF (@DataPriorToDate IS NULL)
BEGIN
	SET @DataPriorToDate = CONVERT(DATETIME, (SELECT ConfiguredValue FROM GrReportingStaging.dbo.SSISConfigurations WHERE ConfigurationFilter = 'ActualDataPriorToDate'))
END

	/*
		Check to see if the TAPAS reforecasts are scheduled to be run.
	*/

DECLARE @CanImportTapasReforecast INT = (SELECT ConfiguredValue FROM GrReportingStaging.dbo.SSISConfigurations WHERE ConfigurationFilter = 'CanImportTAPASReforecast')

IF (@CanImportTapasReforecast <> 1)
BEGIN
	PRINT ('Import of TAPAS Reforecasts is not scheduled in GrReportingStaging.dbo.SSISConfigurations')
	RETURN
END
	
/* ================================================================================================================================================
	 1. Get Budgets to Process
   ============================================================================================================================================= */
BEGIN

	CREATE TABLE #BudgetsToProcess
	(
		BudgetsToProcessId INT NOT NULL,
		ImportBatchId INT NOT NULL,
		BudgetReforecastTypeName VARCHAR(50) NOT NULL,
		BudgetId INT NOT NULL,
		BudgetExchangeRateId INT NOT NULL,
		BudgetReportGroupPeriodId INT NOT NULL,
		ImportBudgetFromSourceSystem BIT NOT NULL,
		IsReforecast BIT NOT NULL,
		SnapshotId INT NOT NULL,
		ImportSnapshotFromSourceSystem BIT NOT NULL,
		InsertedDate DATETIME NOT NULL,
		MustImportAllActualsIntoWarehouse BIT NULL,
		OriginalBudgetProcessedIntoWarehouse SMALLINT NULL,
		ReforecastActualsProcessedIntoWarehouse SMALLINT NULL,
		ReforecastBudgetsProcessedIntoWarehouse SMALLINT NULL,
		ReasonForFailure VARCHAR(512) NULL,
		DateBudgetProcessedIntoWarehouse DATETIME NULL,
		ReforecastKey INT NOT NULL
	)

	INSERT #BudgetsToProcess
	SELECT 
		BudgetsToProcessId,
		ImportBatchId,
		BudgetReforecastTypeName,
		BudgetId,
		BudgetExchangeRateId,
		BudgetReportGroupPeriodId,
		ImportBudgetFromSourceSystem,
		IsReforecast,
		SnapshotId,
		ImportSnapshotFromSourceSystem,
		InsertedDate,
		MustImportAllActualsIntoWarehouse,
		OriginalBudgetProcessedIntoWarehouse,
		ReforecastActualsProcessedIntoWarehouse,
		ReforecastBudgetsProcessedIntoWarehouse,
		ReasonForFailure,
		DateBudgetProcessedIntoWarehouse,
		RR.ReforecastKey
	FROM
		dbo.BudgetsToProcess BTPC

		INNER JOIN
		(
			SELECT
				MIN(ReforecastEffectiveMonth) AS ReforecastEffectiveMonth,
				ReforecastQuarterName,
				ReforecastEffectiveYear
			FROM
				Grreporting.dbo.Reforecast
			GROUP BY
				ReforecastQuarterName,
				ReforecastEffectiveYear
		) CRR ON
			CRR.ReforecastEffectiveYear = BTPC.BudgetYear AND
			CRR.ReforecastQuarterName = BTPC.BudgetQuarter
		
		INNER JOIN Grreporting.dbo.Reforecast RR ON
			CRR.ReforecastEffectiveMonth = RR.ReforecastEffectiveMonth AND
			CRR.ReforecastQuarterName =  RR.ReforecastQuarterName AND
			CRR.ReforecastEffectiveYear = RR.ReforecastEffectiveYear
	WHERE 
		IsReforecast = 1 AND
		BTPC.IsCurrentBatch = 1 AND
		BTPC.BudgetReforecastTypeName = 'TGB Budget/Reforecast'

	DECLARE @BTPRowCount INT = @@rowcount

	PRINT ('Rows inserted into #BudgetsToProcess: ' + CONVERT(VARCHAR(10),@BTPRowCount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	IF (@BTPRowCount = 0)
	BEGIN
		PRINT ('*******************************************************')
		PRINT ('	stp_IU_LoadGrProfitabiltyPayrollReforecast is quitting because BudgetsToProcess returned no budgets to import.')
		PRINT ('*******************************************************')
		RETURN
	END

END
	
/* ===============================================================================================================================================
	Setup Variables 
   ============================================================================================================================================= */
BEGIN

	DECLARE 
		@SourceKeyUnknown				INT = (SELECT SourceKey FROM GrReporting.dbo.[Source] WHERE SourceName = 'UNKNOWN'),
		@FunctionalDepartmentKeyUnknown INT = (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = 'UNKNOWN'),
		@ReimbursableKeyUnknown			INT = (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = 'UNKNOWN'),
		@ActivityTypeKeyUnknown			INT = (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = 'UNKNOWN'),
		@PropertyFundKeyUnknown			INT = (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = 'UNKNOWN'),
		@AllocationRegionKeyUnknown		INT = (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = 'UNKNOWN'),
		@OriginatingRegionKeyUnknown	INT = (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = 'UNKNOWN'),
		@OverheadKeyUnknown				INT = (Select OverheadKey From GrReporting.dbo.Overhead Where OverheadCode = 'UNKNOWN'),
		@LocalCurrencyKeyUnknown		INT = (SELECT CurrencyKey FROM GrReporting.dbo.Currency WHERE CurrencyCode =  'UNK' ),
		@NormalFeeAdjustmentKey			INT = (SELECT FeeAdjustmentKey FROM GrReporting.dbo.FeeAdjustment WHERE FeeAdjustmentCode = 'NORMAL'),
		@GLCategorizationHierarchyKeyUnknown	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'UNKNOWN' AND SnapshotId = 0)

	DECLARE
		@UnknownUSPropertyGLCategorizationKey	 INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'US Property' AND SnapshotId = 0),
		@UnknownUSFundGLCategorizationKey		 INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'US Fund' AND SnapshotId = 0),
		@UnknownEUPropertyGLCategorizationKey	 INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'EU Property' AND SnapshotId = 0),
		@UnknownEUFundGLCategorizationKey		 INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'EU Fund' AND SnapshotId = 0),
		@UnknownUSDevelopmentGLCategorizationKey INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'US Development' AND SnapshotId = 0),
		@UnknownGlobalGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'Global' AND SnapshotId = 0)


	DECLARE @FeeAdjustmentKey		   INT = (SELECT FeeAdjustmentKey FROM GrReporting.dbo.FeeAdjustment WHERE FeeAdjustmentCode = 'NORMAL')
	DECLARE @ReforecastTypeIsTGBBUDKey INT = (SELECT BudgetReforecastTypeKey from GrReporting.dbo.BudgetReforecastType WHERE BudgetReforecastTypeCode = 'TGBBUD')
	DECLARE @ReforecastTypeIsTGBACTKey INT = (SELECT BudgetReforecastTypeKey from GrReporting.dbo.BudgetReforecastType WHERE BudgetReforecastTypeCode = 'TGBACT')
		
	DECLARE @ImportErrorTable TABLE
	(
		Error varchar(50)
	);

END

/* ================================================================================================================================================
	2. Source Budgets
   ============================================================================================================================================= */
BEGIN

	SET @StartTime = GETDATE()

	-- Get the last GBS budgets that were imported into the warehouse.

	CREATE TABLE #LastImportedGBSBudgets
	(
		ImportBatchId INT NOT NULL,
		BudgetId INT NOT NULL,
		BudgetReportGroupPeriodId INT NOT NULL
	)
	INSERT INTO #LastImportedGBSBudgets
	(
		ImportBatchId,
		BudgetId,
		BudgetReportGroupPeriodId
	)
	SELECT 
		B.ImportBatchId,
		B.BudgetId,
		B.BudgetReportGroupPeriodId
	FROM
		GBS.Budget B
		INNER JOIN
		(
			SELECT 
				MAX(ImportBatchId) AS ImportBatchId
			FROM
				GBS.Budget
			WHERE 
				IsReforecast = 1
		) MB ON
			B.ImportBatchId = MB.ImportBatchId

	SET @RowCount = @@ROWCOUNT

	PRINT 'Completed inserting records into #LastImportedGBSBudgets:'+CONVERT(char(10),@RowCount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	IF (@RowCount = 0)
	BEGIN
		PRINT 'WARNING: No GBS budgets found, so no actuals will be imported'
	END

	SET @StartTime = GETDATE()

	CREATE TABLE #NewBudgets
	(
		ImportBatchId INT NOT NULL,
		ImportKey INT NOT NULL,
		SnapshotId INT NOT NULL,
		BudgetId INT NOT NULL,
		RegionId INT NOT NULL,
		FirstProjectedPeriod INT NULL,
		CurrencyCode VARCHAR(3) NOT NULL,
		BudgetReportGroupPeriodId INT NOT NULL,
		BudgetReportGroupPeriod INT NOT NULL,
		GroupEndPeriod INT NOT NULL,
		GBSBudgetId INT NULL, -- CAN BE NULL IN WHICH CASE NO ACTUALS WILL BE IMPORTED
		MustImportAllActualsIntoWarehouse BIT NOT NULL,
		ReforecastKey INT NOT NULL,
		BudgetReportGroupId INT NOT NULL
	)
	INSERT INTO #NewBudgets
	(
		ImportBatchId,
		ImportKey,
		SnapshotId,
		BudgetId,
		RegionId,
		FirstProjectedPeriod,
		CurrencyCode,
		BudgetReportGroupPeriodId,
		BudgetReportGroupPeriod,
		GroupEndPeriod,
		GBSBudgetId,
		MustImportAllActualsIntoWarehouse,
		ReforecastKey,
		BudgetReportGroupId
	)
	SELECT 
		BTP.ImportBatchId,
		Budget.ImportKey,
		BTP.SnapshotId AS SnapshotId,	
		Budget.BudgetId, 
		Budget.RegionId,
		Budget.FirstProjectedPeriod,
		Budget.CurrencyCode,
		brg.BudgetReportGroupPeriodId,
		brgp.Period AS BudgetReportGroupPeriod,
		brg.EndPeriod AS GroupEndPeriod,
		GBSBudget.BudgetId AS GBSBudgetId,
		BTP.MustImportAllActualsIntoWarehouse,
		BTP.ReforecastKey, 
		BRGD.BudgetReportGroupId
	FROM
		TapasGlobalBudgeting.Budget Budget

		INNER JOIN #BudgetsToProcess BTP ON -- All TAPAS budgets in dbo.BudgetsToProcess must be considered because they are to be processed into the warehouse
			Budget.BudgetId = BTP.BudgetId AND
			Budget.ImportBatchId = BTP.ImportBatchId

		INNER JOIN TapasGlobalBudgeting.BudgetReportGroupDetail BRGD ON
			Budget.BudgetId = BRGD.BudgetId AND
			BTP.ImportBatchId = BRGD.ImportBatchId

		INNER JOIN TapasGlobalBudgeting.BudgetReportGroup BRG ON
			BRGD.BudgetReportGroupId = BRG.BudgetReportGroupId	 AND
			BTP.ImportBatchId = BRG.ImportBatchId

		INNER JOIN Gdm.BudgetReportGroupPeriod BRGP ON
			BRG.BudgetReportGroupPeriodId = BRGP.BudgetReportGroupPeriodId

		INNER JOIN Gdm.BudgetReportGroupPeriodActive(@DataPriorToDate) brgpA ON
			BRGP.ImportKey = BRGPA.ImportKey
		/*
			Actuals are imported from GBS. These actuals have GBS Budget Ids. To determine the corresponding GBS Budget Id of a TAPAS budget,
			the BudgetReportGroupPeriod is used. 
		*/			   
		LEFT OUTER JOIN #LastImportedGBSBudgets LIGB ON
			BRG.BudgetReportGroupPeriodId = LIGB.BudgetReportGroupPeriodId  

		LEFT OUTER JOIN GBS.Budget GBSBudget ON
		   LIGB.BudgetReportGroupPeriodId = GBSBudget.BudgetReportGroupPeriodId AND
		   LIGB.BudgetId = GBSBudget.BudgetId AND
		   LIGB.ImportBatchId = GBSBudget.ImportBatchId
			
	DECLARE @NumberOfBudgets INT = @@rowcount
			
	PRINT 'Completed inserting records into #NewBudgets:'+CONVERT(char(10),@NumberOfBudgets)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	IF (@NumberOfBudgets = 0)
	BEGIN
		PRINT '#NewBudgets: Found NO Budgets to import. Nothing to do. Quitting...'
		RETURN
	END

	SET @StartTime = GETDATE()

	CREATE UNIQUE CLUSTERED INDEX IX_BudgetID ON #NewBudgets (SnapshotId, BudgetId)

	PRINT 'Completed creating indexes on #Budget'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	----------------------------------------------------------------------------------------------
	-- Source the GBS Budget
	SET @StartTime = GETDATE()

	-- Source GBS Budgets which will be used for the Actuals
	;WITH CteDistinctTapasBudgets
	AS
	(
	   SELECT 
			B.SnapshotId, 
			B.GBSBudgetId AS BudgetId, 
			B.FirstProjectedPeriod,
			B.MustImportAllActualsIntoWarehouse,
			B.ReforecastKey
		FROM 
			#NewBudgets B
			INNER JOIN 
			(	
				SELECT 
					MIN(BudgetId) AS BudgetId,
					MIN(SnapshotId) AS SnapshotId
				FROM 
					#NewBudgets 
				WHERE
					MustImportAllActualsIntoWarehouse = 1
				GROUP BY
					GBSBudgetId,
					SnapshotId
			) DB ON
				DB.BudgetId = B.BudgetId AND
				DB.SnapshotId = B.SnapshotId
	)
	SELECT
		LIGB.ImportBatchId,
		TB.SnapshotId as SnapshotId,
		TB.BudgetId as TapasBudgetId,
		TB.FirstProjectedPeriod as FirstProjectedPeriod,
		TB.MustImportAllActualsIntoWarehouse,
		TB.ReforecastKey,
		GB.BudgetId AS BudgetId,
		GB.ImportKey
	INTO
		#GBSBudgets
	FROM
		GBS.Budget GB

		INNER JOIN CteDistinctTapasBudgets TB ON
			GB.BudgetId = TB.BudgetId 

		INNER JOIN #LastImportedGBSBudgets LIGB ON
			GB.ImportBatchId = LIGB.ImportBatchId AND
			GB.BudgetReportGroupPeriodId = LIGB.BudgetReportGroupPeriodId AND
			GB.BudgetId = LIGB.BudgetId		

	PRINT 'Completed inserting records into #GBSBudgets:'+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	BEGIN TRY		
		CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #GBSBudgets (SnapshotId, BudgetId, FirstProjectedPeriod)
		PRINT 'Completed creating indexes on #GBSBudgets'
		PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
	END TRY
	BEGIN CATCH
		DECLARE @ErrorSeverity  INT = ERROR_SEVERITY(), @ErrorMessage   NVARCHAR(4000) =
			'Error creating indexes on #GBSBudgets: ' + CONVERT(VARCHAR(10), ERROR_NUMBER()) + ':' + ERROR_MESSAGE() 
		SELECT * FROM #GBSBudgets
		RAISERROR ( @ErrorMessage, @ErrorSeverity, 1)
	END CATCH

	----------------------------------------------------------------------------------------------
	-- All combined Budgets GBS + Tapas
	----------------------------------------------------------------------------------------------

	SELECT DISTINCT
		ImportBatchId
	INTO
		#DistinctImports
	FROM 
		#BudgetsToProcess BTP
		
	SELECT 
		SnapshotId, 
		BudgetId,
		ImportKey
	INTO
		#AllBudgets	
	FROM
		#NewBudgets
	UNION ALL 
	SELECT 
		SnapshotId, 
		BudgetId,
		ImportKey 
	FROM
		#GBSBudgets

END

/* ===============================================================================================================================================
	3.	Source records associated to the Payroll Allocation data (e.g. BudgetProject and BudgetEmployee)
   ============================================================================================================================================= */
BEGIN
	/*
		-------------------------------------------------------------------------------------------------------------------------------
		BudgetProject
		
		In TAPAS Budgeting, when a Budget is created, projects are copied from the Budget Allocation set to the BudgetProject table where
		the project is in the same source as the budget's region and the project is set up for payroll usage.
		
		The #BudgetProject table gets all the budget projects that are associated with the budgets that will be pulled, as per code above.
		The Projects are used to determine the Property Funds which records are assigned to (either using the Corporate Department Code 
		and SourceCode combination, or the PropertyFund associated to the project if there is no Corporate Department assigned).
		The #Budget table is also used to determine the Activity Type to assign to records.
		The IsTsCost is used to determine if budgeted amounts are reimbursable or not.
		The project to be used for Overhead records is determined by the AllocateOverheadsProjectId
	*/
	
	SET @StartTime = GETDATE()

	CREATE TABLE #BudgetProject
	(
		BudgetProjectId INT NOT NULL,
		BudgetId INT NOT NULL,
		ProjectId INT NULL,
		PropertyFundId INT NOT NULL,
		ActivityTypeId INT NOT NULL,
		CorporateDepartmentCode VARCHAR(6) NULL,
		CorporateSourceCode VARCHAR(2) NULL,
		IsReimbursable BIT NOT NULL,
		IsTsCost BIT NOT NULL,
		CanAllocateOverheads BIT NOT NULL,
		AllocateOverheadsProjectId INT NULL
	)
	INSERT INTO #BudgetProject
	(
		BudgetProjectId,
		BudgetId,
		ProjectId,
		PropertyFundId,
		ActivityTypeId,
		CorporateDepartmentCode,
		CorporateSourceCode,
		IsReimbursable,
		IsTsCost,
		CanAllocateOverheads,
		AllocateOverheadsProjectId
	)
	SELECT 
		BudgetProject.BudgetProjectId,
		BudgetProject.BudgetId,
		BudgetProject.ProjectId,
		BudgetProject.PropertyFundId,
		BudgetProject.ActivityTypeId,
		BudgetProject.CorporateDepartmentCode,
		BudgetProject.CorporateSourceCode,
		BudgetProject.IsReimbursable,
		BudgetProject.IsTsCost,
		BudgetProject.CanAllocateOverheads,
		BudgetProject.AllocateOverheadsProjectId
	FROM 
		TapasGlobalBudgeting.BudgetProject BudgetProject

		INNER JOIN #BudgetsToProcess BTP ON
			BudgetProject.ImportBatchId = BTP.ImportBatchId AND
			BudgetProject.BudgetId = BTP.BudgetId

	PRINT 'Completed inserting records into #BudgetProject:'+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	CREATE CLUSTERED INDEX IX_BudgetID ON #BudgetProject (BudgetId)
	CREATE INDEX IX_BudgetProjectId ON #BudgetProject (BudgetProjectId)

	PRINT 'Completed creating indexes on #BudgetProject'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	--------------------------------------------------------------------------------------------
		/*
			The #Region table is used to determine the Source Codes of budgets (using the RegionId field in the Budget table).
		*/
		
	SET @StartTime = GETDATE()

	CREATE TABLE #Region
	(
		RegionId INT NOT NULL,
		SourceCode CHAR(2) NOT NULL
	)
	INSERT INTO #Region
	(
		RegionId,
		SourceCode
	)
	SELECT 
		SourceRegion.RegionId,
		SourceRegion.SourceCode
	FROM 
		HR.Region SourceRegion

		INNER JOIN HR.RegionActive(@DataPriorToDate) SourceRegionA ON
			SourceRegion.ImportKey = SourceRegionA.ImportKey

	PRINT 'Completed inserting records into #Region:'+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	--------------------------------------------------------------------------------------------
		/*
			The #BudgetEmployee table holds details of employees which are allocated to a specified budget.
			The table is also used to determine the Location (from the LocationId field) of the employee, which will determine 
			the Originating Region of Budget records.
		*/	
		
	SET @StartTime = GETDATE()

	CREATE TABLE #BudgetEmployee
	(
		BudgetEmployeeId INT NOT NULL,
		BudgetId INT NOT NULL,
		HrEmployeeId INT NULL,
		LocationId INT NOT NULL
	)
	INSERT INTO #BudgetEmployee(
		BudgetEmployeeId,
		BudgetId,
		HrEmployeeId,
		LocationId
	)
	SELECT 
		BudgetEmployee.BudgetEmployeeId,
		BudgetEmployee.BudgetId,
		BudgetEmployee.HrEmployeeId,
		BudgetEmployee.LocationId
	FROM
		TapasGlobalBudgeting.BudgetEmployee BudgetEmployee

		INNER JOIN #BudgetsToProcess BTP ON
			BudgetEmployee.BudgetId = BTP.BudgetId AND
			BudgetEmployee.ImportBatchId = BTP.ImportBatchId

	PRINT 'Completed inserting records into #BudgetEmployee:'+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	CREATE CLUSTERED INDEX IX_BudgetEmployeeID ON #BudgetEmployee (BudgetEmployeeId)
	CREATE INDEX IX_BudgetId ON #BudgetEmployee (BudgetId)

	PRINT 'Completed creating indexes on ##BudgetEmployee'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

		/*
			--------------------------------------------------------------------------------------------

			The #BudgetEmployeeFunctionalDepartment table stores the combination of Employees included in a Budget, and 
			the Functional Departments they belong to.
		*/

	SET @StartTime = GETDATE()

	CREATE TABLE #BudgetEmployeeFunctionalDepartment
	(
		ImportBatchId INT NOT NULL,
		BudgetEmployeeFunctionalDepartmentId INT NOT NULL,
		BudgetEmployeeId INT NOT NULL,
		EffectivePeriod INT NOT NULL,
		FunctionalDepartmentId INT NOT NULL
	)

	INSERT INTO #BudgetEmployeeFunctionalDepartment
	(
		ImportBatchId,
		BudgetEmployeeFunctionalDepartmentId,
		BudgetEmployeeId,
		EffectivePeriod,
		FunctionalDepartmentId
	)
	SELECT 
		EFD.ImportBatchId,
		EFD.BudgetEmployeeFunctionalDepartmentId,
		EFD.BudgetEmployeeId,
		EFD.EffectivePeriod,
		EFD.FunctionalDepartmentId
	FROM 
		TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment EFD
		
		INNER JOIN #DistinctImports DI ON
			EFD.ImportBatchId = DI.ImportBatchId
		
		-- data limiting join
		INNER JOIN #BudgetEmployee BE ON
			EFD.BudgetEmployeeId = BE.BudgetEmployeeId

	PRINT 'Completed inserting records into #BudgetEmployeeFunctionalDepartment:'+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	CREATE CLUSTERED INDEX IX_BudgetEmployeeId ON #BudgetEmployeeFunctionalDepartment (ImportBatchId, BudgetEmployeeId)
	CREATE INDEX IX_BudgetEmployeeFunctionalDepartment2 ON #BudgetEmployeeFunctionalDepartment (ImportBatchId, BudgetEmployeeId, EffectivePeriod)

	PRINT 'Completed creating indexes on #BudgetEmployeeFunctionalDepartment'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

		/*
			--------------------------------------------------------------------------------------------

			The #Location table is used to determine the OriginatingRegion of a Budget record.
			Each BudgetEmployee record has a LocationId to determine where an employee is based.
		*/
		
	SET @StartTime = GETDATE()

	CREATE TABLE #Location
	(
		LocationId INT NOT NULL,
		ExternalSubRegionId INT NOT NULL
	)

	INSERT INTO #Location
	(
		LocationId,
		ExternalSubRegionId
	)
	SELECT 
		Location.LocationId,
		Location.ExternalSubRegionId 
	FROM 
		HR.Location Location

		INNER JOIN HR.LocationActive(@DataPriorToDate) LocationA ON
			Location.ImportKey = LocationA.ImportKey

	PRINT 'Completed inserting records into #Location:'+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE CLUSTERED INDEX IX_LocationId ON #Location (LocationId)

	PRINT 'Completed creating indexes on #Location'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

		/*
			--------------------------------------------------------------------------------------------

			The #FunctionalDepartment table is used to determine the Functional Department of a Budget record.
		*/

	CREATE TABLE #FunctionalDepartment
	(
		FunctionalDepartmentId INT NOT NULL,
		GlobalCode CHAR(3) NULL
	)
	INSERT INTO #FunctionalDepartment
	(
		FunctionalDepartmentId,
		GlobalCode
	)
	SELECT
		FunctionalDepartmentId,
		GlobalCode
	FROM
		HR.FunctionalDepartment FD
		
		INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FDa ON
			FD.ImportKey = FDa.ImportKey
	WHERE
		FD.IsActive = 1

	PRINT 'Completed inserting records into #FunctionalDepartment: '+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE CLUSTERED INDEX IX_FunctionalDepartmentId ON #FunctionalDepartment (FunctionalDepartmentId)

	PRINT 'Completed creating indexes on #FunctionalDepartment'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

		/*
			--------------------------------------------------------------------------------------------
			
			The #RegionExtended table is used to determine the Functional Department of Overhead transactions.
		*/
		
	SET @StartTime = GETDATE()

	CREATE TABLE #RegionExtended
	(
		RegionId INT NOT NULL,
		OverheadFunctionalDepartmentId INT NOT NULL
	)

	INSERT INTO #RegionExtended
	(
		RegionId,
		OverheadFunctionalDepartmentId
	)
	SELECT 
		RegionExtended.RegionId,
		RegionExtended.OverheadFunctionalDepartmentId
	FROM 
		TapasGlobal.RegionExtended RegionExtended

		INNER JOIN TapasGlobal.RegionExtendedActive(@DataPriorToDate) RegionExtendedA ON
			RegionExtended.ImportKey = RegionExtendedA.ImportKey

	PRINT 'Completed inserting records into #RegionExtended:'+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE CLUSTERED INDEX IX_RegionId ON #RegionExtended (RegionId)

	PRINT 'Completed creating indexes on #RegionExtended'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	-------------------------------------------------------------------------------------------
		/*
			The #Project table is used to get Property Fund and Activity Type information for Overhead projects, and default projects where
			the Bonus Cap has been exceeded.
		*/

	SET @StartTime = GETDATE()

	CREATE TABLE #Project
	(
		ProjectId INT NOT NULL,
		ActivityTypeId INT NOT NULL,
		CorporateDepartmentCode VARCHAR(8) NOT NULL,
		CorporateSourceCode CHAR(2) NOT NULL,
		PropertyFundId INT NOT NULL
	)

	INSERT INTO #Project
	(
		ProjectId,
		ActivityTypeId,
		CorporateDepartmentCode,
		CorporateSourceCode,
		PropertyFundId
	)
	SELECT 
		Project.ProjectId,
		Project.ActivityTypeId,
		Project.CorporateDepartmentCode,
		Project.CorporateSourceCode,
		Project.PropertyFundId
	FROM 
		TapasGlobal.Project Project

		INNER JOIN TapasGlobal.ProjectActive(@DataPriorToDate) ProjectA ON
			Project.ImportKey = ProjectA.ImportKey 

	PRINT 'Completed inserting records into #Project:'+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	CREATE TABLE #SystemSettingRegion
	(
		SystemSettingId INT NOT NULL,
		SystemSettingName VARCHAR(50) NOT NULL,
		SystemSettingRegionId INT NOT NULL,
		RegionId INT,
		SourceCode VARCHAR(2),
		BonusCapExcessProjectId INT
	)

		/*
			-------------------------------------------------------------------------------------------------
			System Setting Region - Bonus Cap Excess
			If a project exceeds its Bonus Cap amount, a single project is selected in place of that project.
			The project Id is determined by the System Setting Region table.
		*/

	SET @StartTime = GETDATE()

	INSERT INTO #SystemSettingRegion
	(
		SystemSettingId,
		SystemSettingName,
		SystemSettingRegionId,
		RegionId,
		SourceCode,
		BonusCapExcessProjectId
	)
	SELECT 
		ss.SystemSettingId,
		ss.Name,
		ssr.SystemSettingRegionId,
		ssr.RegionId,
		ssr.SourceCode,
		ssr.BonusCapExcessProjectId
	FROM
		(
			SELECT 
				ssr.SystemSettingRegionId,
				ssr.RegionId,
				ssr.SourceCode,
				ssr.BonusCapExcessProjectId,
				ssr.SystemSettingId
			FROM
				TapasGlobal.SystemSettingRegion ssr

				INNER JOIN TapasGlobal.SystemSettingRegionActive(@DataPriorToDate) ssrA ON
					ssr.ImportKey = ssrA.ImportKey
		 ) ssr

		INNER JOIN
		(
			SELECT
				ss.SystemSettingId,
				ss.Name
			FROM
			(
				SELECT	
					ss.SystemSettingId,
					ss.Name
				FROM
					TapasGlobal.SystemSetting ss
					INNER JOIN TapasGlobal.SystemSettingActive(@DataPriorToDate) ssA ON
						ss.ImportKey = ssA.ImportKey
				WHERE
					ss.Name = 'BonusCapExcess' -- Previously this was done in the joins, but it's now being done here to limit the data being processed.
			 ) ss
		) ss ON 
			ssr.SystemSettingId = ss.SystemSettingId

	PRINT 'Completed inserting #SystemSettingRegion'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE CLUSTERED INDEX IX_ProjectId ON #Project (ProjectId)

	PRINT 'Completed creating indexes on #Project'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

		/*	-------------------------------------------------------------------------------------------------------------------------
			Global Categorization Payroll Mappings
			
			The following table is used to store Minor Category and Major Category Ids which records will be associated with.
			The reason it's stored as a table and not as variables is because there may be more than one Snapshot being processed at the
			time, and different snapshots may have different Ids.
			
			NB!!!!!!!
			The roll up to payroll is very sensitive information. It is crutial that information regarding payroll not get 
			communicated to TS employees on certain reports. Changing the category mappings to the data below will have ramifications because 
			some reports check for this name.
		*/

	CREATE TABLE #PayrollGlobalMappings
	(
		GLMinorCategoryName VARCHAR(120) NOT NULL,
		GLMinorCategoryId INT NOT NULL,
		GLMajorCategoryName VARCHAR(120) NOT NULL,
		GLMajorCategoryId INT NOT NULL,
		SnapshotId INT NOT NULL	
	)

	INSERT INTO #PayrollGlobalMappings
	(
		GLMinorCategoryName,
		GLMinorCategoryId,
		GLMajorCategoryName,
		GLMajorCategoryId,
		SnapshotId
	)
	SELECT DISTINCT
		GLMinorCategoryName,
		GLMinorCategoryId,
		GLMajorCategoryName,
		GLMajorCategoryId,
		SnapshotId
	FROM
		Gr.GetSnapshotGLCategorizationHierarchyExpanded()
	WHERE
		(
			GLMajorCategoryName = 'Salaries/Taxes/Benefits' OR
			(
				GLMinorCategoryName = 'External General Overhead' AND
				GLMajorCategoryName = 'General Overhead'
			)
		) AND
		GLCategorizationName = 'Global'

	SET @StartTime = GETDATE()

END		

		/*	-------------------------------------------------------------------------------------------------------------------------

			The MRI Server Source table is used to link Corporate Source codes to Property Source codes. This is for actuals from
			GBS which only use Corporate source codes.
		*/


CREATE TABLE #MRIServerSource
(
	SourceCode CHAR(2) NOT NULL,
	MappingSourceCode CHAR(2) NULL
)
INSERT INTO #MRIServerSource
(
	SourceCode,
	MappingSourceCode
)
SELECT
	SourceCode,
	MappingSourceCode
FROM
	Gdm.MRIServerSource MSS
	
	INNER JOIN Gdm.MRIServerSourceActive(@DataPriorToDate) MSSa ON
		MSS.ImportKey = MSSa.ImportKey
		
/* ===============================================================================================================================================
	4.	Source Payroll and Overhead Allocation Data from TAPAS Global Budgeting
   ============================================================================================================================================= */
BEGIN
	/*
		---------------------------------------------------------------------
		BudgetEmployeePayrollAllocation
		The #BudgetEmployeePayrollAllocation table stores budget payroll allocations for employees.
		The table is used to determine the Base Salary, the Bonus and the Profit Share amounts for each employee.
	*/

	SET @StartTime = GETDATE()

	CREATE TABLE #BudgetEmployeePayrollAllocation
	(
		ImportKey INT NOT NULL,
		ImportBatchId INT NOT NULL,
		ImportDate DATETIME NOT NULL,
		BudgetEmployeePayrollAllocationId INT NOT NULL,
		BudgetEmployeeId INT NOT NULL,
		BudgetProjectId INT NOT NULL,
		BudgetProjectGroupId INT NULL,
		Period INT NOT NULL,
		SalaryAllocationValue DECIMAL(18, 9) NOT NULL,
		BonusAllocationValue DECIMAL(18, 9) NULL,
		BonusCapAllocationValue DECIMAL(18, 9) NULL,
		ProfitShareAllocationValue DECIMAL(18, 9) NULL,
		PreTaxSalaryAmount DECIMAL(18, 2) NOT NULL,
		PreTaxBonusAmount DECIMAL(18, 2) NULL,
		PreTaxBonusCapExcessAmount DECIMAL(18, 2) NULL,
		PreTaxProfitShareAmount DECIMAL(18, 2) NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL,
		UpdatedByStaffId INT NOT NULL,
		OriginalBudgetEmployeePayrollAllocationId INT NULL,
		SnapshotId INT NOT NULL
	)

	INSERT INTO #BudgetEmployeePayrollAllocation
	(
		ImportKey,
		ImportBatchId,
		ImportDate,
		BudgetEmployeePayrollAllocationId,
		BudgetEmployeeId,
		BudgetProjectId,
		BudgetProjectGroupId,
		Period,
		SalaryAllocationValue,
		BonusAllocationValue,
		BonusCapAllocationValue,
		ProfitShareAllocationValue,
		PreTaxSalaryAmount,
		PreTaxBonusAmount,
		PreTaxBonusCapExcessAmount,
		PreTaxProfitShareAmount,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId,
		OriginalBudgetEmployeePayrollAllocationId,
		SnapshotId
	)
	SELECT
		Allocation.ImportKey,
		Allocation.ImportBatchId,
		Allocation.ImportDate,
		Allocation.BudgetEmployeePayrollAllocationId,
		Allocation.BudgetEmployeeId,
		Allocation.BudgetProjectId,
		Allocation.BudgetProjectGroupId,
		Allocation.Period,
		Allocation.SalaryAllocationValue,
		Allocation.BonusAllocationValue,
		Allocation.BonusCapAllocationValue,
		Allocation.ProfitShareAllocationValue,
		Allocation.PreTaxSalaryAmount,
		Allocation.PreTaxBonusAmount,
		Allocation.PreTaxBonusCapExcessAmount,
		Allocation.PreTaxProfitShareAmount,
		Allocation.InsertedDate,
		Allocation.UpdatedDate,
		Allocation.UpdatedByStaffId,
		Allocation.OriginalBudgetEmployeePayrollAllocationId,
		B.SnapshotId
	FROM
		TapasGlobalBudgeting.BudgetEmployeePayrollAllocation Allocation

		INNER JOIN #DistinctImports DI ON
			Allocation.ImportBatchId = DI.ImportBatchId

		--data limiting join
		INNER JOIN #BudgetProject BP ON
			Allocation.BudgetProjectId = bp.BudgetProjectId 
		
		-- Used to get the snapshot from the budgets currently being processed.	
		INNER JOIN #NewBudgets B ON
			BP.BudgetId = B.BudgetId

	PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocation:'+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE UNIQUE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationId ON #BudgetEmployeePayrollAllocation (ImportBatchId, BudgetEmployeePayrollAllocationId)

	PRINT 'Completed creating indexes on #BudgetEmployeePayrollAllocation'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	---------------------------------------------------------------------
	-- Source payroll tax detail
		/*
			The #BudgetEmployeePayrollDetail table stores budget payroll allocations for employee taxes.
		*/
	SET @StartTime = GETDATE()

	CREATE TABLE #BudgetEmployeePayrollAllocationDetail
	(
		ImportKey INT NOT NULL,
		ImportBatchId INT NOT NULL,
		ImportDate DATETIME NOT NULL,
		BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
		BudgetEmployeePayrollAllocationId INT NOT NULL,
		BenefitOptionId INT NULL,
		BudgetTaxTypeId INT NULL,
		SalaryAmount DECIMAL(18, 2) NULL,
		BonusAmount DECIMAL(18, 2) NULL,
		ProfitShareAmount DECIMAL(18, 2) NULL,
		BonusCapExcessAmount DECIMAL(18, 2) NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL,
		UpdatedByStaffId INT NOT NULL,
		SnapshotId INT NOT NULL
	)

	INSERT INTO #BudgetEmployeePayrollAllocationDetail
	(
		ImportKey,
		ImportBatchId,
		ImportDate,
		BudgetEmployeePayrollAllocationDetailId,
		BudgetEmployeePayrollAllocationId,
		BenefitOptionId,
		BudgetTaxTypeId,
		SalaryAmount,
		BonusAmount,
		ProfitShareAmount,
		BonusCapExcessAmount,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId,
		SnapshotId
	)
	SELECT
		TaxDetail.ImportKey,
		TaxDetail.ImportBatchId,
		TaxDetail.ImportDate,
		TaxDetail.BudgetEmployeePayrollAllocationDetailId,
		TaxDetail.BudgetEmployeePayrollAllocationId,
		TaxDetail.BenefitOptionId,
		TaxDetail.BudgetTaxTypeId,
		TaxDetail.SalaryAmount,
		TaxDetail.BonusAmount,
		TaxDetail.ProfitShareAmount,
		TaxDetail.BonusCapExcessAmount,
		TaxDetail.InsertedDate,
		TaxDetail.UpdatedDate,
		TaxDetail.UpdatedByStaffId,
		Allocation.SnapshotId
	FROM
		TapasGlobalBudgeting.BudgetEmployeePayrollAllocationDetail TaxDetail

		--data limiting join
		INNER JOIN #BudgetEmployeePayrollAllocation Allocation ON
			TaxDetail.ImportBatchId = Allocation.ImportBatchId AND
			TaxDetail.BudgetEmployeePayrollAllocationId = Allocation.BudgetEmployeePayrollAllocationId

	PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocationDetail:'+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE UNIQUE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationDetailId ON #BudgetEmployeePayrollAllocationDetail (ImportBatchId, BudgetEmployeePayrollAllocationDetailId)

	PRINT 'Completed creating indexes on #BudgetEmployeePayrollAllocationDetail'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

		/*
			The #BudgetTaxType determines the tax types associated with budgets.
		*/

	SET @StartTime = GETDATE()

	CREATE TABLE #BudgetTaxType
	(
		ImportKey INT NOT NULL,
		ImportBatchId INT NOT NULL,
		ImportDate DATETIME NOT NULL,
		BudgetTaxTypeId INT NOT NULL,
		BudgetId INT NOT NULL,
		TaxTypeId INT NOT NULL,
		FixedTaxTypeId INT NOT NULL,
		RateCalculationMethodId INT NOT NULL,
		Name VARCHAR(100) NOT NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedByStaffId INT NOT NULL,
		OriginalBudgetTaxTypeId INT NULL
	)

	INSERT INTO #BudgetTaxType
	(
		ImportKey,
		ImportBatchId,
		ImportDate,
		BudgetTaxTypeId,
		BudgetId,
		TaxTypeId,
		FixedTaxTypeId,
		RateCalculationMethodId,
		Name,
		InsertedDate,
		UpdatedByStaffId,
		OriginalBudgetTaxTypeId
	)
	SELECT 
		BudgetTaxType.ImportKey,
		BudgetTaxType.ImportBatchId,
		BudgetTaxType.ImportDate,
		BudgetTaxType.BudgetTaxTypeId,
		BudgetTaxType.BudgetId,
		BudgetTaxType.TaxTypeId,
		BudgetTaxType.FixedTaxTypeId,
		BudgetTaxType.RateCalculationMethodId,
		BudgetTaxType.Name,
		BudgetTaxType.InsertedDate,
		BudgetTaxType.UpdatedByStaffId,
		BudgetTaxType.OriginalBudgetTaxTypeId 
	FROM
		TapasGlobalBudgeting.BudgetTaxType BudgetTaxType

		INNER JOIN #BudgetsToProcess BTP ON
			BudgetTaxType.ImportBatchId = BTP.ImportBatchId AND
			BudgetTaxType.BudgetId = BTP.BudgetId
		
	PRINT 'Completed inserting records into #BudgetTaxType:'+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE CLUSTERED INDEX IX_BudgetTaxTypeId ON #BudgetTaxType (BudgetTaxTypeId)

	PRINT 'Completed creating indexes on #BudgetTaxType'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

			/*
				The #TaxType table is used to determine the Minor Category for the tax records sourced from the #BudgetEmployeePayrollAllocationDetail
				table.
			*/

	SET @StartTime = GETDATE()

	CREATE TABLE #TaxType
	(
		ImportBatchId INT NOT NULL,
		TaxTypeId INT NOT NULL,
		MinorGlAccountCategoryId INT NOT NULL
	)

	INSERT INTO #TaxType
	(
		ImportBatchId,
		TaxTypeId,
		MinorGlAccountCategoryId
	)
	SELECT 
		TaxType.ImportBatchId,
		TaxType.TaxTypeId,
		TaxType.MinorGlAccountCategoryId
	FROM 
		TapasGlobalBudgeting.TaxType TaxType

		INNER JOIN #DistinctImports DI ON
			TaxType.ImportBatchId = DI.ImportBatchId

	PRINT 'Completed inserting records into #TaxType:'+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE CLUSTERED INDEX IX_TaxType ON #TaxType (ImportBatchId, TaxTypeId)

	PRINT 'Completed creating indexes on #TaxType'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	-- Source payroll allocation Tax detail
		/*
			The #EmployeePayrollAllocationDetail table stores budget payroll allocations for employees for taxes and employee benefits.
			This adds to the #BudgetEmployeePayrollAllocation table by adding the Minor Category mapping.
		*/

	CREATE TABLE #EmployeePayrollAllocationDetail
	(
		ImportKey INT NOT NULL,
		BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
		BudgetEmployeePayrollAllocationId INT NOT NULL,
		MinorGlAccountCategoryId INT NULL,
		BudgetTaxTypeId INT NULL,
		SalaryAmount DECIMAL(18, 2) NULL,
		BonusAmount DECIMAL(18, 2) NULL,
		ProfitShareAmount DECIMAL(18, 2) NULL,
		BonusCapExcessAmount DECIMAL(18, 2) NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL,
		UpdatedByStaffId INT NOT NULL,
		SnapshotId INT NOT NULL
	)

	INSERT INTO #EmployeePayrollAllocationDetail
	(
		ImportKey,
		BudgetEmployeePayrollAllocationDetailId,
		BudgetEmployeePayrollAllocationId,
		MinorGlAccountCategoryId,
		BudgetTaxTypeId,
		SalaryAmount,
		BonusAmount,
		ProfitShareAmount,
		BonusCapExcessAmount,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId,
		SnapshotId
	)
	SELECT
		TaxDetail.ImportKey,
		TaxDetail.BudgetEmployeePayrollAllocationDetailId,
		TaxDetail.BudgetEmployeePayrollAllocationId,
		CASE WHEN (TaxDetail.BenefitOptionId IS NOT NULL) THEN GlCategory.GLMinorCategoryId ELSE TaxType.MinorGlAccountCategoryId END AS MinorGlAccountCategoryId,
		TaxDetail.BudgetTaxTypeId,
		TaxDetail.SalaryAmount,
		TaxDetail.BonusAmount,
		TaxDetail.ProfitShareAmount,
		TaxDetail.BonusCapExcessAmount,
		TaxDetail.InsertedDate,
		TaxDetail.UpdatedDate,
		TaxDetail.UpdatedByStaffId,
		TaxDetail.SnapshotId
	FROM
		-- Joining on allocation to limit amount of data
		#BudgetEmployeePayrollAllocation Allocation

		INNER JOIN #BudgetEmployeePayrollAllocationDetail TaxDetail ON
			Allocation.BudgetEmployeePayrollAllocationId = TaxDetail.BudgetEmployeePayrollAllocationId AND
			Allocation.ImportBatchId = TaxDetail.ImportBatchId

		-- This join is used to determine the Minor Category if the Benefit Option is not specified.
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			Allocation.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = 'Benefits'

		LEFT OUTER JOIN #BudgetTaxType BudgetTaxType ON
			TaxDetail.BudgetTaxTypeId = BudgetTaxType.BudgetTaxTypeId AND
			Allocation.ImportBatchId = BudgetTaxType.ImportBatchId

		-- Used to determine the Minor Category
		LEFT OUTER JOIN #TaxType TaxType ON
			BudgetTaxType.TaxTypeId = TaxType.TaxTypeId	AND
			BudgetTaxType.ImportBatchId = TaxType.ImportBatchId

	PRINT 'Completed inserting records into #EmployeePayrollAllocationDetail:'+CONVERT(char(10),@@rowcount)

	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #EmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationDetailId,  BudgetEmployeePayrollAllocationId)
	CREATE INDEX IX_EmployeePayrollAllocationDetail2 ON #EmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationId)

	PRINT 'Completed creating indexes on #EmployeePayrollAllocationDetail'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	--------------------------------------------------------------------------------------------------
	-- Source overhead allocations

		/*
			The #BudgetOverheadAllocation table stores overhead budget data.
		*/

	SET @StartTime = GETDATE()

	CREATE TABLE #BudgetOverheadAllocation
	(
		ImportKey INT NOT NULL,
		ImportBatchId INT NOT NULL,
		ImportDate DATETIME NOT NULL,
		BudgetOverheadAllocationId INT NOT NULL,
		BudgetId INT NOT NULL,
		OverheadRegionId INT NOT NULL,
		BudgetEmployeeId INT NOT NULL,
		BudgetPeriod INT NOT NULL,
		AllocationAmount DECIMAL(18, 2) NOT NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL,
		UpdatedByStaffId INT NOT NULL,
		OriginalBudgetOverheadAllocationId INT NULL,
		SnapshotId INT NOT NULL
	)

	INSERT INTO #BudgetOverheadAllocation
	(
		ImportKey,
		ImportBatchId,
		ImportDate,
		BudgetOverheadAllocationId,
		BudgetId,
		OverheadRegionId,
		BudgetEmployeeId,
		BudgetPeriod,
		AllocationAmount,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId,
		OriginalBudgetOverheadAllocationId,
		SnapshotId
	)
	SELECT
		OverheadAllocation.ImportKey,
		OverheadAllocation.ImportBatchId,
		OverheadAllocation.ImportDate,
		OverheadAllocation.BudgetOverheadAllocationId,
		OverheadAllocation.BudgetId,
		OverheadAllocation.OverheadRegionId,
		OverheadAllocation.BudgetEmployeeId,
		OverheadAllocation.BudgetPeriod,
		OverheadAllocation.AllocationAmount,
		OverheadAllocation.InsertedDate,
		OverheadAllocation.UpdatedDate,
		OverheadAllocation.UpdatedByStaffId,
		OverheadAllocation.OriginalBudgetOverheadAllocationId,
		BTP.SnapshotId
	FROM
		TapasGlobalBudgeting.BudgetOverheadAllocation OverheadAllocation

		INNER JOIN #BudgetsToProcess BTP ON
			OverheadAllocation.ImportBatchId = BTP.ImportBatchId AND
			OverheadAllocation.BudgetId = BTP.BudgetId

	PRINT 'Completed inserting records into #BudgetOverheadAllocation:'+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocation (BudgetOverheadAllocationId,BudgetId,OverheadRegionId,BudgetEmployeeId)

	PRINT 'Completed creating indexes on #BudgetOverheadAllocation'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

		/*
			The #BudgetOverheadAllocationDetail table stores overhead budget data for the individual projects.
		*/

	SET @StartTime = GETDATE()

	CREATE TABLE #BudgetOverheadAllocationDetail(
		ImportKey INT NOT NULL,
		ImportBatchId INT NOT NULL,
		ImportDate DATETIME NOT NULL,
		BudgetOverheadAllocationDetailId INT NOT NULL,
		BudgetOverheadAllocationId INT NOT NULL,
		BudgetProjectId INT NOT NULL,
		AllocationValue DECIMAL(18, 9) NOT NULL,
		AllocationAmount DECIMAL(18, 2) NOT NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL,
		UpdatedByStaffId INT NOT NULL,
		SnapshotId INT NOT NULL
	)

	INSERT INTO #BudgetOverheadAllocationDetail
	(
		ImportKey,
		ImportBatchId,
		ImportDate,
		BudgetOverheadAllocationDetailId,
		BudgetOverheadAllocationId,
		BudgetProjectId,
		AllocationValue,
		AllocationAmount,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId,
		SnapshotId
	)
	SELECT 
		OverheadDetail.ImportKey,
		OverheadDetail.ImportBatchId,
		OverheadDetail.ImportDate,
		OverheadDetail.BudgetOverheadAllocationDetailId,
		OverheadDetail.BudgetOverheadAllocationId,
		OverheadDetail.BudgetProjectId,
		OverheadDetail.AllocationValue,
		OverheadDetail.AllocationAmount,
		OverheadDetail.InsertedDate,
		OverheadDetail.UpdatedDate,
		OverheadDetail.UpdatedByStaffId,
		B.SnapshotId
	FROM
		TapasGlobalBudgeting.BudgetOverheadAllocationDetail OverheadDetail

		INNER JOIN #DistinctImports DI ON
			OverheadDetail.ImportBatchId = DI.ImportBatchId

		-- Limits the data to records associated with budgets currently being processed.
		INNER JOIN #BudgetProject BP ON
			OverheadDetail.BudgetProjectId = BP.BudgetProjectId

		-- Used to determine the snapshot the records are associated with.	
		INNER JOIN #NewBudgets B ON
			BP.BudgetId = B.BudgetId	

	PRINT 'Completed inserting records into #BudgetOverheadAllocationDetail:'+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
	CREATE INDEX IX_BudgetOverheadAllocationDetail2 ON #BudgetOverheadAllocationDetail (BudgetOverheadAllocationId)

	PRINT 'Completed creating indexes on #BudgetOverheadAllocationDetail'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

		/*
			The #OverheadAllocationDetail table stores overhead budget data for the individual projects, and includes the GL Minor Category
			mapping.
		*/
		
	SET @StartTime = GETDATE()

	CREATE TABLE #OverheadAllocationDetail
	(
		ImportKey INT NOT NULL,
		BudgetOverheadAllocationDetailId INT NOT NULL,
		BudgetOverheadAllocationId INT NOT NULL,
		BudgetProjectId INT NOT NULL,
		MinorGlAccountCategoryId INT NOT NULL,
		AllocationValue DECIMAL(18, 9) NOT NULL,
		AllocationAmount DECIMAL(18, 2) NOT NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL,
		UpdatedByStaffId INT NOT NULL,
		SnapshotId INT NOT NULL
	)

	INSERT INTO #OverheadAllocationDetail
	(
		ImportKey,
		BudgetOverheadAllocationDetailId,
		BudgetOverheadAllocationId,
		BudgetProjectId,
		MinorGlAccountCategoryId,
		AllocationValue,
		AllocationAmount,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId,
		SnapshotId
	)
	SELECT
		OverheadDetail.ImportKey,
		OverheadDetail.BudgetOverheadAllocationDetailId,
		OverheadDetail.BudgetOverheadAllocationId,
		OverheadDetail.BudgetProjectId,
		GlCategory.GLMinorCategoryId AS MinorGlAccountCategoryId,
		OverheadDetail.AllocationValue,
		OverheadDetail.AllocationAmount,
		OverheadDetail.InsertedDate,
		OverheadDetail.UpdatedDate,
		OverheadDetail.UpdatedByStaffId,
		OverheadDetail.SnapshotId
	FROM
		-- Joining on allocation to limit amount of data
		#BudgetOverheadAllocation OverheadAllocation

		INNER JOIN #BudgetOverheadAllocationDetail OverheadDetail ON -- Only pull allocationDetails for the allocations we are pulling
			OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId 

		-- Used to determine the Minor Category of the records
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			OverheadDetail.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = 'External General Overhead'

	PRINT 'Completed inserting records into #OverheadAllocationDetail:'+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE CLUSTERED INDEX IX_Clustered ON #OverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
	CREATE INDEX IX_OverheadAllocationDetail2 ON #OverheadAllocationDetail (BudgetOverheadAllocationId)

	PRINT 'Completed creating indexes on #OverheadAllocationDetail'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END

/* ================================================================================================================================================
	5.	Map the Pre-Tax, Tax and Overhead data to their associated records (step 4) from Tapas Global Budgeting
   ============================================================================================================================================= */
BEGIN
	/*
		Calculate effective functional department.
		Finds the last period before an employee changed her functional department, and finds all functional departments 
		that an employee is associated with.
	*/

	SET @StartTime = GETDATE()

	CREATE TABLE #EffectiveFunctionalDepartment
	(
		BudgetEmployeePayrollAllocationId INT NOT NULL,
		BudgetEmployeeId INT NOT NULL,
		FunctionalDepartmentId INT NOT NULL
	)

	INSERT INTO #EffectiveFunctionalDepartment
	(
		BudgetEmployeePayrollAllocationId,
		BudgetEmployeeId,
		FunctionalDepartmentId
	)
	SELECT 
		Allocation.BudgetEmployeePayrollAllocationId,
		Allocation.BudgetEmployeeId,
		(
			SELECT 
				EFD.FunctionalDepartmentId
			FROM 
				(
					SELECT 
						Allocation2.ImportBatchId,
						Allocation2.BudgetEmployeeId,
						MAX(EFD.EffectivePeriod) AS EffectivePeriod
					FROM
						#BudgetEmployeePayrollAllocation Allocation2

						INNER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
							Allocation2.BudgetEmployeeId = EFD.BudgetEmployeeId AND
							Allocation2.ImportBatchId = EFD.ImportBatchId
					
					WHERE
						Allocation.BudgetEmployeePayrollAllocationId = Allocation2.BudgetEmployeePayrollAllocationId AND
						Allocation.ImportBatchId = Allocation2.ImportBatchId AND
						EFD.EffectivePeriod <= Allocation.Period

					GROUP BY
						Allocation2.ImportBatchId,
						Allocation2.BudgetEmployeeId
				) EFDo
			
				LEFT OUTER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
					EFD.ImportBatchId = EFDo.ImportBatchId AND
					EFD.BudgetEmployeeId = EFDo.BudgetEmployeeId AND
					EFD.EffectivePeriod = EFDo.EffectivePeriod

		 ) AS FunctionalDepartmentId
	FROM
		#BudgetEmployeePayrollAllocation Allocation

		INNER JOIN #BudgetProject BudgetProject ON 
			Allocation.BudgetProjectId = BudgetProject.BudgetProjectId

	PRINT 'Completed inserting records into #EffectiveFunctionalDepartment:'+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE INDEX IX_EffectiveFunctionalDepartment_AllocId ON #EffectiveFunctionalDepartment (BudgetEmployeePayrollAllocationId)

	PRINT 'Completed creating indexes on #EffectiveFunctionalDepartment'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	-------------------------------------------------------------------------------------------------------
	-- Map Payroll data

		/*
			--------------------------------------------
			Pre-Tax Payroll Data
			Map Pre-Tax payroll budget amounts from the #BudgetEmployeePayrollAllocation table to GDM and HR data
		*/

	SET @StartTime = GETDATE()

	CREATE TABLE #ProfitabilityPreTaxSource
	(
		ImportBatchId INT NOT NULL,
		BudgetId INT NOT NULL,
		BudgetRegionId INT NOT NULL,
		FirstProjectedPeriod char(6) NOT NULL,
		ProjectId INT NOT NULL,
		HrEmployeeId INT NOT NULL,
		BudgetEmployeePayrollAllocationId INT NOT NULL,
		ReferenceCode VARCHAR(300) NOT NULL,
		ExpensePeriod CHAR(6) NOT NULL,	
		SourceCode VARCHAR(2) NULL,
		SalaryPreTaxAmount MONEY NOT NULL,
		ProfitSharePreTaxAmount MONEY NOT NULL,
		BonusPreTaxAmount MONEY NOT NULL,
		BonusCapExcessPreTaxAmount MONEY NOT NULL,
		FunctionalDepartmentId INT NOT NULL,
		FunctionalDepartmentCode VARCHAR(31) NULL,
		Reimbursable BIT NULL,
		ActivityTypeId INT NOT NULL,
		ActivityTypeCode VARCHAR(50) NOT NULL,
		PropertyFundId INT NOT NULL,
		AllocationSubRegionGlobalRegionId INT NOT NULL,
		ConsolidationSubRegionGlobalRegionId INT NOT NULL,
		OriginatingRegionCode CHAR(6) NULL,
		OriginatingRegionSourceCode VARCHAR(2) NULL,
		LocalCurrencyCode CHAR(3) NOT NULL,
		AllocationUpdatedDate DATETIME NOT NULL,
		BudgetReportGroupPeriod INT NOT NULL,
		SnapshotId INT NOT NULL,
		
		SourceTableName VARCHAR(128)
	)
	-- Insert original budget amounts
	INSERT INTO #ProfitabilityPreTaxSource
	(
		ImportBatchId,
		BudgetId,
		BudgetRegionId,
		FirstProjectedPeriod,
		ProjectId,
		HrEmployeeId,
		BudgetEmployeePayrollAllocationId,
		ReferenceCode,
		ExpensePeriod,
		SourceCode,
		SalaryPreTaxAmount,
		ProfitSharePreTaxAmount,
		BonusPreTaxAmount,
		BonusCapExcessPreTaxAmount,
		FunctionalDepartmentId,
		FunctionalDepartmentCode,
		Reimbursable,
		ActivityTypeId,
		ActivityTypeCode,
		PropertyFundId,
		AllocationSubRegionGlobalRegionId,
		ConsolidationSubRegionGlobalRegionId,
		OriginatingRegionCode,
		OriginatingRegionSourceCode,
		LocalCurrencyCode,
		AllocationUpdatedDate,
		BudgetReportGroupPeriod,
		SnapshotId,
		
		SourceTableName
	)
	SELECT 
		Budget.ImportBatchId,
		Budget.BudgetId AS BudgetId,
		Budget.RegionId AS BudgetRegionId,
		Budget.FirstProjectedPeriod,
		ISNULL(BudgetProject.ProjectId,0) AS ProjectId,
		ISNULL(BudgetEmployee.HrEmployeeId,0) AS HrEmployeeId,
		Allocation.BudgetEmployeePayrollAllocationId,
		(
			'TGB:BudgetId=' + CONVERT(VARCHAR, Budget.BudgetId) +
			'&ProjectId=' + CONVERT(VARCHAR, ISNULL(BudgetProject.ProjectId, 0)) +
			'&HrEmployeeId=' + CONVERT(VARCHAR, ISNULL(BudgetEmployee.HrEmployeeId, 0)) +
			'&BudgetEmployeePayrollAllocationId=' + CONVERT(VARCHAR, Allocation.BudgetEmployeePayrollAllocationId) +
			'&BudgetEmployeePayrollAllocationDetailId=0&BudgetOverheadAllocationDetailId=0'
		) AS ReferenceCode,
		Allocation.Period AS ExpensePeriod,
		SourceRegion.SourceCode,
		ISNULL(Allocation.PreTaxSalaryAmount,0) AS SalaryPreTaxAmount,
		ISNULL(Allocation.PreTaxProfitShareAmount, 0) AS ProfitSharePreTaxAmount,
		ISNULL(Allocation.PreTaxBonusAmount,0) AS BonusPreTaxAmount,
		ISNULL(Allocation.PreTaxBonusCapExcessAmount,0) AS BonusCapExcessPreTaxAmount,
		ISNULL(EFD.FunctionalDepartmentId, -1),
		fd.GlobalCode AS FunctionalDepartmentCode, 
		CASE WHEN Dept.IsTsCost = 0 THEN 1 ELSE 0 END Reimbursable,
		BudgetProject.ActivityTypeId,
		Att.ActivityTypeCode,
			/*
				When selecting a Property Fund, the first option is is the Property Fund assigned to the Corporate Department of
				the Project - DepartmentPropertyFund. If the CorporateDepartmentCode field of the project is NULL or '@', the
				next option is the project's PropertyFundId field - the ProjectPropertyFund.
			*/
		COALESCE(DepartmentPropertyFund.PropertyFundId, ProjectPropertyFund.PropertyFundId, -1) AS PropertyFundId,
		COALESCE(DepartmentPropertyFund.AllocationSubRegionGlobalRegionId, ProjectPropertyFund.AllocationSubRegionGlobalRegionId, -1) AS AllocationSubRegionGlobalRegionId,
		ISNULL(ConsolidationRegion.GlobalRegionId, -1) AS ConsolidationSubRegionGlobalRegionId,
		OriginatingRegion.CorporateEntityRef,
		OriginatingRegion.CorporateSourceCode,
		Budget.CurrencyCode AS LocalCurrencyCode,
		Allocation.UpdatedDate,
		Budget.BudgetReportGroupPeriod,
		Allocation.SnapshotId,
		
		'BudgetEmployeePayrollAllocation'
	FROM
		#BudgetEmployeePayrollAllocation Allocation

		INNER JOIN #BudgetProject BudgetProject ON
			Allocation.BudgetProjectId = BudgetProject.BudgetProjectId

		INNER JOIN #NewBudgets Budget ON 
			BudgetProject.BudgetId = Budget.BudgetId 

		LEFT OUTER JOIN #Region SourceRegion ON 
			SourceRegion.RegionId = Budget.RegionId 

		-- Maps the Functional Department 
		LEFT OUTER JOIN #EffectiveFunctionalDepartment EFD ON
			Allocation.BudgetEmployeePayrollAllocationId = EFD.BudgetEmployeePayrollAllocationId

		-- Resolves the Functional Department Code
		LEFT OUTER JOIN #FunctionalDepartment FD ON 
			EFD.FunctionalDepartmentId = FD.FunctionalDepartmentId

		-- Maps the source of the record
		LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON 
			BudgetProject.CorporateSourceCode = GrSc.SourceCode 
		/*
			A Property Fund can either be mapped using the PropertyFundId in the BudgetProject table, or using the CorporateDepartmentCode and
			SourceCode combination in the BudgetProject table to determine the PropertyFundId through the ReportingEntityCorproateDepartment table
			or the ReportingEntityPropertyEntity table.
			The Property Fund using the CorporateDepartmentCode and SourceCode is the first option, but if this is null, the PropertyFundId is used
			directly from the BudgetProject table.
		*/
		-- Gets the Property Fund a Project's Corporate Department is mapped to for transaction before period 201007
		LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping PFM ON
			BudgetProject.CorporateDepartmentCode = PFM.PropertyFundCode AND -- Combination of entity and corporate department
			BudgetProject.CorporateSourceCode = PFM.SourceCode AND
			PFM.IsDeleted = 0 AND 
			(
				(GrSc.IsProperty = 'YES' AND PFM.ActivityTypeId IS NULL) 
				OR
				(
					(GrSc.IsCorporate = 'YES' AND PFM.ActivityTypeId = BudgetProject.ActivityTypeId)
					OR
					(GrSc.IsCorporate = 'YES' AND PFM.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
				)
			) AND
			Budget.BudgetReportGroupPeriod < 201007 AND
			Budget.SnapshotId = PFM.SnapshotId

		-- Used to resolve the Property Fund a Project's Corporate Department is mapped to.
		LEFT OUTER JOIN	Gdm.SnapshotReportingEntityCorporateDepartment RECD ON
			GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = RECD.CorporateDepartmentCode AND
			BudgetProject.CorporateSourceCode = RECD.SourceCode AND
			Budget.BudgetReportGroupPeriod >= 201007 AND			   
			Budget.SnapshotId = RECD.SnapshotId

		-- Used to resolve the Property Fund a Project's Property Entity is mapped to.	   
		LEFT OUTER JOIN Gdm.SnapshotReportingEntityPropertyEntity REPE ON
			GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = REPE.PropertyEntityCode AND
			BudgetProject.CorporateSourceCode  = REPE.SourceCode AND
			Budget.BudgetReportGroupPeriod >= 201007 AND
			Budget.SnapshotId = REPE.SnapshotId

		-- Maps the Property Fund a Project's Corporate Department / Reporting Entity is mapped to.
		LEFT OUTER JOIN Gdm.SnapshotPropertyFund DepartmentPropertyFund ON
			Budget.SnapshotId = DepartmentPropertyFund.SnapshotId AND
			DepartmentPropertyFund.PropertyFundId =
				CASE
					WHEN
						Budget.BudgetReportGroupPeriod < 201007
					THEN
						PFM.PropertyFundId
					ELSE
						CASE
							WHEN
								GrSc.IsCorporate = 'YES'
							THEN
								RECD.PropertyFundId
							ELSE
								REPE.PropertyFundId
						END
				END AND
			DepartmentPropertyFund.IsActive = 1
			
		-- Gets the Property Fund a Project is mapped to
		LEFT OUTER JOIN Gdm.SnapshotPropertyFund ProjectPropertyFund ON
			BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
			Budget.SnapshotId = ProjectPropertyFund.SnapshotId AND
			ProjectPropertyFund.IsActive = 1
			
		-- 	Used to resolve the Consolidation Sub Region a Project's Corporate Department is mapped to.	
		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD ON -- (CC16)
			GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = CRCD.CorporateDepartmentCode AND
			BudgetProject.CorporateSourceCode = CRCD.SourceCode AND
			Budget.SnapshotId = CRCD.SnapshotId AND
			Budget.BudgetReportGroupPeriod >= 201101

		-- 	Used to resolve the Consolidation Sub Region a Project's Property Entity is mapped to.		
		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionPropertyEntity CRPE ON -- (CC16)
			GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = CRPE.PropertyEntityCode  AND
			BudgetProject.CorporateSourceCode  = CRPE.SourceCode AND
			Budget.SnapshotId = CRPE.SnapshotId AND
			Budget.BudgetReportGroupPeriod >= 201101

		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion ConsolidationRegion ON
			ProjectPropertyFund.AllocationSubRegionGlobalRegionId = ConsolidationRegion.GlobalRegionId AND
			Budget.SnapshotId = ConsolidationRegion.SnapshotId AND
			ConsolidationRegion.IsConsolidationRegion = 1 AND
			ConsolidationRegion.IsActive = 1

		LEFT OUTER JOIN #BudgetEmployee BudgetEmployee ON
			Allocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId

		LEFT OUTER JOIN #Location Location ON 
			BudgetEmployee.LocationId = Location.LocationId

		-- Used to dtermine the Originating Region Code and Source Code	
		LEFT OUTER JOIN Gdm.SnapshotPayrollRegion OriginatingRegion ON 
			Location.ExternalSubRegionId = OriginatingRegion.ExternalSubRegionId AND
			Budget.RegionId = OriginatingRegion.RegionId AND
			Budget.SnapshotId = OriginatingRegion.SnapshotId

		INNER JOIN GrReporting.dbo.ActivityType Att ON 
			BudgetProject.ActivityTypeId = Att.ActivityTypeId AND
			Budget.SnapshotId = Att.SnapshotId

		LEFT OUTER JOIN Gdm.SnapshotCorporateDepartment Dept ON
			BudgetProject.CorporateDepartmentCode = Dept.Code AND 
			SourceRegion.SourceCode = Dept.SourceCode AND
			Budget.SnapshotId = Dept.SnapshotId
	WHERE
		Allocation.Period BETWEEN Budget.FirstProjectedPeriod AND Budget.GroupEndPeriod
		--Change Control 1 : GC 2010-09-01
		--BudgetProject.ActivityTypeId <> 99 -- exclude Corporate Overhead

	PRINT 'Completed inserting records into #ProfitabilityPreTaxSource:'+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE INDEX IX_SalaryPreTaxAmount ON #ProfitabilityPreTaxSource (SalaryPreTaxAmount)
	CREATE INDEX IX_ProfitSharePreTaxAmount ON #ProfitabilityPreTaxSource (ProfitSharePreTaxAmount)
	CREATE INDEX IX_BonusPreTaxAmount ON #ProfitabilityPreTaxSource (BonusPreTaxAmount)
	CREATE INDEX IX_BonusCapExcessPreTaxAmount ON #ProfitabilityPreTaxSource (BonusCapExcessPreTaxAmount)
	CREATE INDEX IX_ProfitabilityPreTaxSource5 ON #ProfitabilityPreTaxSource (BudgetEmployeePayrollAllocationId)

	PRINT 'Completed creating indexes on #ProfitabilityPreTaxSource'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	--Map Tax Amounts
	SET @StartTime = GETDATE()

	CREATE TABLE #ProfitabilityTaxSource
	(
		ImportBatchId INT NOT NULL,
		BudgetId INT NOT NULL,
		BudgetRegionId INT NOT NULL,
		FirstProjectedPeriod CHAR(6) NOT NULL,
		ProjectId INT NOT NULL,
		HrEmployeeId INT NOT NULL,
		BudgetEmployeePayrollAllocationId INT NOT NULL,
		BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
		ReferenceCode VARCHAR(300) NOT NULL,
		ExpensePeriod CHAR(6) NOT NULL,	
		SourceCode VARCHAR(2) NULL,
		SalaryTaxAmount MONEY NOT NULL,
		ProfitShareTaxAmount MONEY NOT NULL,
		BonusTaxAmount MONEY NOT NULL,
		BonusCapExcessTaxAmount MONEY NOT NULL,
		MinorGlAccountCategoryId INT NOT NULL,
		FunctionalDepartmentId INT NOT NULL,
		FunctionalDepartmentCode VARCHAR(31) NULL,
		Reimbursable BIT NULL,
		ActivityTypeId INT NOT NULL,
		ActivityTypeCode VARCHAR(50) NOT NULL,
		PropertyFundId INT NOT NULL,
		AllocationSubRegionGlobalRegionId INT NOT NULL,
		ConsolidationSubRegionGlobalRegionId INT NOT NULL,
		OriginatingRegionCode CHAR(6) NULL,
		OriginatingRegionSourceCode VARCHAR(2) NULL,
		LocalCurrencyCode CHAR(3) NOT NULL,
		AllocationUpdatedDate DATETIME NOT NULL,
		BudgetReportGroupPeriod INT NOT NULL,
		SnapshotId INT NOT NULL,
		
		SourceTableName VARCHAR(128)
	)
	--/*
	-- Insert original budget amounts
	INSERT INTO #ProfitabilityTaxSource
	(
		ImportBatchId,
		BudgetId,
		BudgetRegionId,
		FirstProjectedPeriod,
		ProjectId,
		HrEmployeeId,
		BudgetEmployeePayrollAllocationId,
		BudgetEmployeePayrollAllocationDetailId,
		ReferenceCode,
		ExpensePeriod,
		SourceCode,
		SalaryTaxAmount,
		ProfitShareTaxAmount,
		BonusTaxAmount,
		BonusCapExcessTaxAmount,
		MinorGlAccountCategoryId,
		FunctionalDepartmentId,
		FunctionalDepartmentCode,
		Reimbursable,
		ActivityTypeId,
		ActivityTypeCode,
		PropertyFundId,
		AllocationSubRegionGlobalRegionId,
		ConsolidationSubRegionGlobalRegionId,
		OriginatingRegionCode,
		OriginatingRegionSourceCode,
		LocalCurrencyCode,
		AllocationUpdatedDate,
		BudgetReportGroupPeriod,
		SnapshotId,
		
		SourceTableName
	)
	SELECT 
		B.ImportBatchId,
		pts.BudgetId,
		pts.BudgetRegionId,
		pts.FirstProjectedPeriod,
		ISNULL(pts.ProjectId,0) AS ProjectId,
		ISNULL(pts.HrEmployeeId,0) AS HrEmployeeId,
		pts.BudgetEmployeePayrollAllocationId,
		TaxDetail.BudgetEmployeePayrollAllocationDetailId,
		'TGB:BudgetId=' + CONVERT(varchar,pts.BudgetId) + '&ProjectId=' + CONVERT(varchar,ISNULL(pts.ProjectId,0)) + '&HrEmployeeId=' + CONVERT(varchar,ISNULL(pts.HrEmployeeId,0)) + '&BudgetEmployeePayrollAllocationId=' + CONVERT(varchar,pts.BudgetEmployeePayrollAllocationId) + '&BudgetEmployeePayrollAllocationDetailId=' + CONVERT(varchar,TaxDetail.BudgetEmployeePayrollAllocationDetailId) + '&BudgetOverheadAllocationDetailId=0' AS ReferenceCode,
		pts.ExpensePeriod,
		pts.SourceCode,
		ISNULL(TaxDetail.SalaryAmount, 0) AS SalaryTaxAmount,
		ISNULL(TaxDetail.ProfitShareAmount, 0) AS ProfitShareTaxAmount,
		ISNULL(TaxDetail.BonusAmount, 0) AS BonusTaxAmount,
		ISNULL(TaxDetail.BonusCapExcessAmount, 0) AS BonusCapExcessTaxAmount,
		TaxDetail.MinorGlAccountCategoryId,
		ISNULL(pts.FunctionalDepartmentId, -1),
		pts.FunctionalDepartmentCode, 
		pts.Reimbursable,
		pts.ActivityTypeId,
		pts.ActivityTypeCode,
		pts.PropertyFundId,
		ISNULL(PF.AllocationSubRegionGlobalRegionId, -1) AS AllocationSubRegionGlobalRegionId,
		pts.ConsolidationSubRegionGlobalRegionId,
		pts.OriginatingRegionCode,
		pts.OriginatingRegionSourceCode,
		pts.LocalCurrencyCode,
		pts.AllocationUpdatedDate,
		pts.BudgetReportGroupPeriod,
		TaxDetail.SnapshotId,
		
		'BudgetEmployeePayrollAllocationDetail'
	FROM
		#EmployeePayrollAllocationDetail TaxDetail

		INNER JOIN #ProfitabilityPreTaxSource PTS ON
			TaxDetail.BudgetEmployeePayrollAllocationId = pts.BudgetEmployeePayrollAllocationId

		INNER JOIN #NewBudgets B ON
			PTS.BudgetId = B.BudgetId 

		LEFT OUTER JOIN Gdm.SnapshotPropertyFund PF ON
			PTS.PropertyFundId = PF.PropertyFundId AND
			B.SnapshotId = PF.SnapshotId AND
			PF.IsActive = 1

	PRINT 'Completed inserting records into #ProfitabilityTaxSource:'+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE INDEX IX_ProfitabilityTaxSource_SalaryTaxAmount ON #ProfitabilityTaxSource (SalaryTaxAmount)
	CREATE INDEX IX_ProfitabilityTaxSource_ProfitShareTaxAmount ON #ProfitabilityTaxSource  (ProfitShareTaxAmount)
	CREATE INDEX IX_ProfitabilityTaxSource_BonusTaxAmount ON #ProfitabilityTaxSource  (BonusTaxAmount)
	CREATE INDEX IX_ProfitabilityTaxSource_BonusCapExcessTaxAmount ON #ProfitabilityTaxSource  (BonusCapExcessTaxAmount)
	CREATE INDEX IX_ProfitabilityTaxSource_BudgetEmployeePayrollAllocationId ON #ProfitabilityTaxSource  (BudgetEmployeePayrollAllocationId)

	PRINT 'Completed creating indexes on #ProfitabilityPreTaxSource'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

		/*
			------------------------------------------------------------------------------------------
			Overhead data
			Map Tax Overhead budget amounts to GDM and HR data
		*/

	SET @StartTime = GETDATE()

	CREATE TABLE #ProfitabilityOverheadSource
	(
		ImportBatchId INT NOT NULL,
		BudgetId INT NOT NULL,
		FirstProjectedPeriod CHAR(6) NOT NULL,
		ProjectId INT NOT NULL,
		HrEmployeeId INT NOT NULL,
		BudgetOverheadAllocationDetailId INT NOT NULL,
		ReferenceCode VARCHAR(300) NOT NULL,
		ExpensePeriod CHAR(6) NOT NULL,	
		SourceCode VARCHAR(2) NULL,
		OverheadAllocationAmount MONEY NOT NULL,
		MinorGlAccountCategoryId INT NOT NULL,
		FunctionalDepartmentId INT NOT NULL,
		FunctionalDepartmentCode VARCHAR(31) NULL,
		Reimbursable BIT NULL,
		ActivityTypeId INT NOT NULL,
		PropertyFundId INT NOT NULL,
		AllocationSubRegionGlobalRegionId INT NOT NULL,
		ConsolidationSubRegionGlobalRegionId INT NOT NULL,
		OriginatingRegionCode CHAR(6) NULL,
		OriginatingRegionSourceCode VARCHAR(2) NULL,
		LocalCurrencyCode CHAR(3) NOT NULL,
		OverheadUpdatedDate DATETIME NOT NULL,
		SnapshotId INT NOT NULL,
		
		SourceTableName VARCHAR(128)
	)
	-- Insert original overhead amounts
	INSERT INTO #ProfitabilityOverheadSource
	(
		ImportBatchId,
		BudgetId,
		FirstProjectedPeriod,
		ProjectId,
		HrEmployeeId,
		BudgetOverheadAllocationDetailId,
		ReferenceCode,
		ExpensePeriod,
		SourceCode,
		OverheadAllocationAmount,
		MinorGlAccountCategoryId,
		FunctionalDepartmentId,
		FunctionalDepartmentCode,
		Reimbursable,
		ActivityTypeId,
		PropertyFundId,
		AllocationSubRegionGlobalRegionId,	
		ConsolidationSubRegionGlobalRegionId,
		OriginatingRegionCode,
		OriginatingRegionSourceCode,
		LocalCurrencyCode,
		OverheadUpdatedDate,
		SnapshotId,
		
		SourceTableName
	)
	SELECT
		Budget.ImportBatchId,
		Budget.BudgetId AS BudgetId,
		Budget.FirstProjectedPeriod,
		ISNULL(BudgetProject.ProjectId,0) AS ProjectId,
		ISNULL(BudgetEmployee.HrEmployeeId,0) AS HrEmployeeId,
		OverheadDetail.BudgetOverheadAllocationDetailId,
		'TGB:BudgetId=' + CONVERT(varchar,Budget.BudgetId) + '&ProjectId=' + CONVERT(varchar,ISNULL(BudgetProject.ProjectId,0)) + '&HrEmployeeId=' + CONVERT(varchar,ISNULL(BudgetEmployee.HrEmployeeId,0)) + '&BudgetEmployeePayrollAllocationId=0&BudgetEmployeePayrollAllocationDetailId=0' + '&BudgetOverheadAllocationDetailId=' + CONVERT(varchar,OverheadDetail.BudgetOverheadAllocationDetailId) AS ReferenceCode,
		OverheadAllocation.BudgetPeriod AS ExpensePeriod,
		SourceRegion.SourceCode,
		ISNULL(OverheadDetail.AllocationAmount,0) AS OverheadAllocationAmount,
		OverheadDetail.MinorGlAccountCategoryId,
		ISNULL(RegionExtended.OverheadFunctionalDepartmentId, -1) AS FunctionalDepartmentId,
		fd.GlobalCode AS FunctionalDepartmentCode,
		CASE
			WHEN
				(BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0)
			THEN 
				CASE
					WHEN -- Where ISTSCost is False the cost will be reimbursable
						(BudgetProject.IsTsCost = 0)
					THEN
						1
					ELSE
						0
				END
			ELSE
				0  --Where the BudgetProject.OverheadAllocationProjectID is populated: non-reimbursable
		END AS Reimbursable,
		BudgetProject.ActivityTypeId,
			/*
				When selecting a Property Fund, the first option is is the Property Fund assigned to the Corporate Department of
				the Project - DepartmentPropertyFund. If the CorporateDepartmentCode field of the project is NULL or '@', the
				next option is the project's PropertyFundId field - the ProjectPropertyFund.
			*/
		COALESCE(OverheadPropertyFund.PropertyFundId, DepartmentPropertyFund.PropertyFundId, ProjectPropertyFund.PropertyFundId, -1) AS PropertyFundId,
		COALESCE(DepartmentPropertyFund.AllocationSubRegionGlobalRegionId, ProjectPropertyFund.AllocationSubRegionGlobalRegionId, -1) AS AllocationSubRegionGlobalRegionId,
		ISNULL(ConsolidationRegion.GlobalRegionId, -1) AS ConsolidationSubRegionGlobalRegionId,
		OriginatingRegion.CorporateEntityRef,
		OriginatingRegion.CorporateSourceCode,
		Budget.CurrencyCode AS LocalCurrencyCode,
		OverheadDetail.UpdatedDate,
		OverheadAllocation.SnapshotId,
		
		'BudgetOverheadAllocation'
	FROM
		#BudgetOverheadAllocation OverheadAllocation 

		INNER JOIN #BudgetEmployee BudgetEmployee ON
			OverheadAllocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId

		INNER JOIN #OverheadAllocationDetail OverheadDetail ON
			OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId

		INNER JOIN #BudgetProject BudgetProject ON 
			OverheadDetail.BudgetProjectId = BudgetProject.BudgetProjectId

		INNER JOIN #NewBudgets Budget ON 
			BudgetProject.BudgetId = Budget.BudgetId

		LEFT OUTER JOIN #Region SourceRegion ON 
			Budget.RegionId = SourceRegion.RegionId

		LEFT OUTER JOIN #RegionExtended RegionExtended ON 
			SourceRegion.RegionId = RegionExtended.RegionId

		LEFT OUTER JOIN #FunctionalDepartment FD ON 
			RegionExtended.OverheadFunctionalDepartmentId = FD.FunctionalDepartmentId

		LEFT OUTER JOIN	#Project OverheadProject ON
			BudgetProject.AllocateOverheadsProjectId = OverheadProject.ProjectId

		-- Maps the Property Fund based on the BudgetProject mapping
		LEFT OUTER JOIN Gdm.SnapshotPropertyFund ProjectPropertyFund ON
			BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
			Budget.SnapshotId = ProjectPropertyFund.SnapshotId AND
			ProjectPropertyFund.IsActive = 1

		-- Maps the Source of the Budget Project
		LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON 
			BudgetProject.CorporateSourceCode = GrSc.SourceCode

		-- Maps the Property Fund of the Budget Project based on the CorporateDepartmentCode and SourceCode for transactions before 201007
		LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping PFM ON
			BudgetProject.CorporateDepartmentCode = PFM.PropertyFundCode AND -- Combination of entity and corporate department
			BudgetProject.CorporateSourceCode = PFM.SourceCode AND
			PFM.IsDeleted = 0 AND 
			(
				(GrSc.IsProperty = 'YES' AND PFM.ActivityTypeId IS NULL) 
				OR
				(
					(GrSc.IsCorporate = 'YES' AND PFM.ActivityTypeId = BudgetProject.ActivityTypeId)
					OR
					(GrSc.IsCorporate = 'YES' AND PFM.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
				)
			) AND
			Budget.BudgetReportGroupPeriod < 201007 AND
			Budget.SnapshotId = PFM.SnapshotId

		-- Maps the Budget Project to a Property Fund using the Corporate Department Code and Corporate Source Code combinations.
		LEFT OUTER JOIN	Gdm.SnapshotReportingEntityCorporateDepartment RECD ON
			GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = RECD.CorporateDepartmentCode AND
			BudgetProject.CorporateSourceCode = RECD.SourceCode AND
			Budget.BudgetReportGroupPeriod >= 201007 AND
			Budget.SnapshotId = RECD.SnapshotId 

		LEFT OUTER JOIN Gdm.SnapshotReportingEntityPropertyEntity REPE ON
			GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = REPE.PropertyEntityCode AND
			BudgetProject.CorporateSourceCode = REPE.SourceCode AND
			Budget.BudgetReportGroupPeriod >= 201007 AND
			Budget.SnapshotId = REPE.SnapshotId

		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD ON -- (CC16)
			GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = CRCD.CorporateDepartmentCode  AND
			BudgetProject.CorporateSourceCode = CRCD.SourceCode  AND
			Budget.SnapshotId = CRCD.SnapshotId AND
			Budget.BudgetReportGroupPeriod >= 201101

		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionPropertyEntity CRPE ON -- (CC16)
			GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = CRPE.PropertyEntityCode AND
			BudgetProject.CorporateSourceCode = CRPE.SourceCode AND
			Budget.SnapshotId = CRPE.SnapshotId AND
			Budget.BudgetReportGroupPeriod >= 201101

		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion ConsolidationRegion ON
			Budget.SnapshotId = ConsolidationRegion.SnapshotId AND
			ConsolidationRegion.GlobalRegionId = COALESCE(CRCD.GlobalRegionId, CRPE.GlobalRegionId, ProjectPropertyFund.AllocationSubRegionGlobalRegionId) AND
			ConsolidationRegion.IsConsolidationRegion = 1 AND
			ConsolidationRegion.IsActive = 1

		LEFT OUTER JOIN Gdm.SnapshotPropertyFund DepartmentPropertyFund ON
			DepartmentPropertyFund.PropertyFundId =
				CASE
					WHEN
						Budget.BudgetReportGroupPeriod < 201007
					THEN
						PFM.PropertyFundId
					ELSE
						CASE
							WHEN
								GrSc.IsCorporate = 'YES'
							THEN
								RECD.PropertyFundId
							ELSE
								REPE.PropertyFundId
						END
				END
			AND Budget.SnapshotId = DepartmentPropertyFund.SnapshotId AND
			DepartmentPropertyFund.IsActive = 1

		LEFT OUTER JOIN GrReporting.dbo.[Source] GrScO ON
			OverheadProject.CorporateSourceCode = GrScO.SourceCode

		LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping OPFM ON
			OverheadProject.CorporateDepartmentCode = OPFM.PropertyFundCode AND -- Combination of entity and corporate department
			OverheadProject.CorporateSourceCode = OPFM.SourceCode AND
			OPFM.IsDeleted = 0 AND
			(
				(GrScO.IsProperty = 'YES' AND OPFM.ActivityTypeId IS NULL)
				OR
				(
					(GrScO.IsCorporate = 'YES' AND OPFM.ActivityTypeId = BudgetProject.ActivityTypeId)
					OR
					(GrScO.IsCorporate = 'YES' AND OPFM.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
				)
			) AND
			Budget.BudgetReportGroupPeriod < 201007 AND
			Budget.SnapshotId = OPFM.SnapshotId

		LEFT OUTER JOIN Gdm.SnapshotPropertyFund OverheadPropertyFund ON
			OverheadPropertyFund.PropertyFundId =	
				CASE
					WHEN
						Budget.BudgetReportGroupPeriod < 201007
					THEN
						OPFM.PropertyFundId
					ELSE
						CASE
							WHEN
								GrSc.IsCorporate = 'YES'
							THEN
								RECD.PropertyFundId
							ELSE
								REPE.PropertyFundId
						END
				END AND 
			OverheadPropertyFund.SnapshotId = Budget.SnapshotId AND
			OverheadPropertyFund.IsActive = 1
			
		LEFT OUTER JOIN Gdm.SnapshotOverheadRegion OriginatingRegion ON 
			OverheadAllocation.OverheadRegionId = OriginatingRegion.OverheadRegionId AND
			Budget.SnapshotId = OriginatingRegion.SnapshotId
	WHERE
		OverheadAllocation.BudgetPeriod BETWEEN Budget.FirstProjectedPeriod AND Budget.GroupEndPeriod
			
	PRINT 'Completed inserting records into #ProfitabilityOverheadSource:'+CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE INDEX IX_ProfitabilityOverheadSource_OverheadAllocationAmount ON #ProfitabilityOverheadSource (OverheadAllocationAmount)

	PRINT 'Completed creating indexes on #ProfitabilityOverheadSource'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END

/* ===============================================================================================================================================
	6.	Combine tables into #ProfitabilityPayrollMapping table and map to GDM data
   ============================================================================================================================================= */
BEGIN

	SET @StartTime = GETDATE()
			
	CREATE TABLE #ProfitabilityPayrollMapping
	(
		ImportBatchId INT NOT NULL,
		SourceName varchar(50),
		BudgetId INT NOT NULL,
		ReferenceCode VARCHAR(300) NOT NULL,
		FirstProjectedPeriod CHAR(6) NOT NULL,
		ExpensePeriod CHAR(6) NOT NULL,	
		SourceCode VARCHAR(2) NULL,
		BudgetAmount MONEY NOT NULL,
		MajorGlAccountCategoryId INT NOT NULL,
		MinorGlAccountCategoryId INT NOT NULL,
		FunctionalDepartmentId INT NOT NULL,
		FunctionalDepartmentCode VARCHAR(31) NULL,
		Reimbursable BIT NOT NULL,
		FeeOrExpense  Varchar(20) NOT NULL,
		ActivityTypeId INT NOT NULL,
		PropertyFundId INT NOT NULL,
		AllocationSubRegionGlobalRegionId INT NOT NULL,
		ConsolidationSubRegionGlobalRegionId INT NOT NULL,
		OriginatingRegionCode CHAR(6) NULL,
		OriginatingRegionSourceCode VARCHAR(2) NULL,
		LocalCurrencyCode CHAR(3) NOT NULL,
		AllocationUpdatedDate DATETIME NOT NULL,
		GlobalGlAccountCode Varchar(10) NULL,
		IsCorporateOverhead BIT NOT NULL,
		
		SourceTableName VARCHAR(128)
	)
	 
	INSERT INTO #ProfitabilityPayrollMapping
	(
		ImportBatchId,
		SourceName, 
		BudgetId,
		ReferenceCode,
		FirstProjectedPeriod,
		ExpensePeriod,
		SourceCode,
		BudgetAmount,
		MajorGlAccountCategoryId,
		MinorGlAccountCategoryId,
		FunctionalDepartmentId,
		FunctionalDepartmentCode,
		Reimbursable,
		FeeOrExpense,
		ActivityTypeId,
		PropertyFundId,
		AllocationSubRegionGlobalRegionId,
		ConsolidationSubRegionGlobalRegionId,
		OriginatingRegionCode,
		OriginatingRegionSourceCode,
		LocalCurrencyCode,
		AllocationUpdatedDate,
		GlobalGlAccountCode,
		IsCorporateOverhead,
		
		SourceTableName
	)
	-- Get Base Salary Payroll pre tax mappings and budget
	SELECT
		PPS.ImportBatchId,
		'Budget-SalaryPreTaxAmount' as SourceName,
		PPS.BudgetId,
		PPS.ReferenceCode + '&Type=SalaryPreTax' AS ReferenceCode,
		PPS.FirstProjectedPeriod,
		PPS.ExpensePeriod,
		PPS.SourceCode,
		PPS.SalaryPreTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		GlCategory.GLMinorCategoryId AS MinorGlAccountCategoryId, 
		PPS.FunctionalDepartmentId,
		PPS.FunctionalDepartmentCode,
		PPS.Reimbursable,  
		'SalaryPreTax' FeeOrExpense,
		PPS.ActivityTypeId,
		PPS.PropertyFundId,
		PPS.AllocationSubRegionGlobalRegionId,
		PPS.ConsolidationSubRegionGlobalRegionId,
		PPS.OriginatingRegionCode,
		PPS.OriginatingRegionSourceCode,
		PPS.LocalCurrencyCode,
		PPS.AllocationUpdatedDate,
		
		'N/A' GlobalGlAccountCode,
		CASE
			WHEN
				PPS.ActivityTypeCode = 'CORPOH'
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverhead,
		
		PPS.SourceTableName
	FROM
		#ProfitabilityPreTaxSource PPS

		-- Used to map the Major and Minor Category Ids based on the SnapshotId
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			PPS.SnapshotId  = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = 'Base Salary'
	WHERE
		PPS.SalaryPreTaxAmount <> 0

	-- Get Profit Share Benefit pre tax mappings and budget
	UNION ALL

	SELECT
		PPS.ImportBatchId,
		'Budget-ProfitSharePreTaxAmount' as SourceName,
		PPS.BudgetId,
		PPS.ReferenceCode + '&Type=ProfitSharePreTax' AS ReferenceCod,
		PPS.FirstProjectedPeriod,
		PPS.ExpensePeriod,
		PPS.SourceCode,
		PPS.ProfitSharePreTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		GlCategory.GLMinorCategoryId AS MinorGlAccountCategoryId, 
		PPS.FunctionalDepartmentId,
		PPS.FunctionalDepartmentCode,
		PPS.Reimbursable,  
		'ProfitSharePreTax' FeeOrExpense,
		PPS.ActivityTypeId,
		PPS.PropertyFundId,
		PPS.AllocationSubRegionGlobalRegionId,
		PPS.ConsolidationSubRegionGlobalRegionId,
		PPS.OriginatingRegionCode,
		PPS.OriginatingRegionSourceCode,
		PPS.LocalCurrencyCode,
		PPS.AllocationUpdatedDate,
		--General Allocated Overhead Account :: CC8
		'N/A' AS GlobalGlAccountCode,
		CASE
			WHEN
				PPS.ActivityTypeCode = 'CORPOH'
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverhead,
		
		PPS.SourceTableName
	FROM
		#ProfitabilityPreTaxSource PPS

		-- Used to map the Major and Minor Category Ids based on the SnapshotId	
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			PPS.SnapshotId  = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = 'Benefits' -- Profit Share maps to the Benefits GL Minor Category	
	WHERE
		PPS.ProfitSharePreTaxAmount <> 0

	-- Get Bonus pre tax mappings and budget
	UNION ALL

	SELECT
		PPS.ImportBatchId,
		'Budget-BonusPreTaxAmount' as SourceName,
		PPS.BudgetId,
		PPS.ReferenceCode + '&Type=BonusPreTax' AS ReferenceCod,
		PPS.FirstProjectedPeriod,
		PPS.ExpensePeriod,
		PPS.SourceCode,
		PPS.BonusPreTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		GlCategory.GLMinorCategoryId AS MinorGlAccountCategoryId, 
		PPS.FunctionalDepartmentId,
		PPS.FunctionalDepartmentCode,
		PPS.Reimbursable,  
		'BonusPreTax' FeeOrExpense,
		PPS.ActivityTypeId,
		PPS.PropertyFundId,
		PPS.AllocationSubRegionGlobalRegionId,
		PPS.ConsolidationSubRegionGlobalRegionId,
		PPS.OriginatingRegionCode,
		PPS.OriginatingRegionSourceCode,
		PPS.LocalCurrencyCode,
		PPS.AllocationUpdatedDate,
		--General Allocated Overhead Account :: CC8
		'N/A' AS GlobalGlAccountCode,
		CASE
			WHEN
				PPS.ActivityTypeCode = 'CORPOH'
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverhead,
		
		PPS.SourceTableName
	FROM
		#ProfitabilityPreTaxSource PPS

		-- Used to map the Major and Minor Category Ids based on the SnapshotId		
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			PPS.SnapshotId  = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = 'Bonus'
	WHERE
		PPS.BonusPreTaxAmount <> 0

	--Get bonus cap pre tax mappings
	UNION ALL

	SELECT
		PPS.ImportBatchId,
		'Budget-BonusCapExcessPreTaxAmount' AS SourceName,	
		PPS.BudgetId,
		PPS.ReferenceCode + '&Type=BonusCapExcessPreTax' AS ReferenceCod,
		PPS.FirstProjectedPeriod,
		PPS.ExpensePeriod,
		PPS.SourceCode,
		PPS.BonusCapExcessPreTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		GlCategory.GLMinorCategoryId AS MinorGlAccountCategoryId, 
		PPS.FunctionalDepartmentId,
		PPS.FunctionalDepartmentCode,
		0 AS Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
		'BonusCapExcessPreTax' AS FeeOrExpense,
		ISNULL(p.ActivityTypeId, -1) AS ActivityTypeId,
			/*
				When selecting a Property Fund, the first option is is the Property Fund assigned to the Corporate Department of
				the Project - DepartmentPropertyFund. If the CorporateDepartmentCode field of the project is NULL or '@', the
				next option is the project's PropertyFundId field - the ProjectPropertyFund.
			*/
		COALESCE(DepartmentPropertyFund.PropertyFundId, ProjectPropertyFund.PropertyFundId, -1) AS PropertyFundId,
		COALESCE(DepartmentPropertyFund.AllocationSubRegionGlobalRegionId, ProjectPropertyFund.AllocationSubRegionGlobalRegionId -1) AS AllocationSubRegionGlobalRegionId,	
		ISNULL(ConsolidationRegion.GlobalRegionId, -1) AS ConsolidationSubRegionGlobalRegionId,
		PPS.OriginatingRegionCode,
		PPS.OriginatingRegionSourceCode,
		PPS.LocalCurrencyCode,
		PPS.AllocationUpdatedDate,
		--General Allocated Overhead Account :: CC8
		'N/A' AS GlobalGlAccountCode,
		CASE
			WHEN
				PPS.ActivityTypeCode = 'CORPOH'
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverhead,
		
		PPS.SourceTableName
	FROM
		#ProfitabilityPreTaxSource PPS

		INNER JOIN #NewBudgets Budget on
		  PPS.BudgetId = Budget.BudgetId

		-- Used to determine the Major and Minor Categories of records
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			PPS.SnapshotId  = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = 'Bonus'

		LEFT OUTER JOIN #SystemSettingRegion ssr ON
			PPS.SourceCode = ssr.SourceCode AND
			PPS.BudgetRegionId = ssr.RegionId AND
			ssr.SystemSettingName = 'BonusCapExcess'

		LEFT OUTER JOIN #Project P ON
			ssr.BonusCapExcessProjectId = P.ProjectId

		LEFT OUTER JOIN Gdm.SnapshotPropertyFund ProjectPropertyFund ON
			P.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
			Budget.SnapshotId = ProjectPropertyFund.SnapshotId AND
			ProjectPropertyFund.IsActive = 1

		LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
			P.CorporateSourceCode = GrSc.SourceCode

		LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping PFM ON
			P.CorporateDepartmentCode = PFM.PropertyFundCode AND -- Combination of entity and corporate department
			P.CorporateSourceCode = PFM.SourceCode AND
			PFM.IsDeleted = 0 AND 
			(
				(GrSc.IsProperty = 'YES' AND PFM.ActivityTypeId IS NULL) 
				OR
				(
					(GrSc.IsCorporate = 'YES' AND PFM.ActivityTypeId = p.ActivityTypeId)
					OR
					(GrSc.IsCorporate = 'YES' AND PFM.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
				)
			) AND
			PPS.BudgetReportGroupPeriod < 201007 AND
			Budget.SnapshotId = PFM.SnapshotId

		LEFT OUTER JOIN	Gdm.SnapshotReportingEntityCorporateDepartment RECD ON
			GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
			LTRIM(RTRIM(p.CorporateDepartmentCode)) = RECD.CorporateDepartmentCode  AND
			p.CorporateSourceCode  = RECD.SourceCode AND
			PPS.BudgetReportGroupPeriod >= 201007 AND
			Budget.SnapshotId = RECD.SnapshotId  

		LEFT OUTER JOIN Gdm.SnapshotReportingEntityPropertyEntity REPE ON
			GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(p.CorporateDepartmentCode)) = REPE.PropertyEntityCode  AND
			p.CorporateSourceCode = REPE.SourceCode AND
			PPS.BudgetReportGroupPeriod >= 201007 AND
			Budget.SnapshotId = REPE.SnapshotId  

		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD ON -- (CC16)
			GrSc.IsCorporate = 'YES' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(p.CorporateDepartmentCode)) = CRCD.CorporateDepartmentCode AND
			p.CorporateSourceCode = CRCD.SourceCode AND
			Budget.SnapshotId = CRCD.SnapshotId AND
			PPS.BudgetReportGroupPeriod >= 201101

		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionPropertyEntity CRPE ON
			GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(p.CorporateDepartmentCode))  = CRPE.PropertyEntityCode AND
			p.CorporateSourceCode = CRPE.SourceCode AND
			Budget.SnapshotId = CRPE.SnapshotId AND
			PPS.BudgetReportGroupPeriod >= 201101

		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion ConsolidationRegion ON
			PPS.SnapshotId = ConsolidationRegion.SnapshotId AND
			ConsolidationRegion.GlobalRegionId = COALESCE(CRCD.GlobalRegionId, CRPE.GlobalRegionId, ProjectPropertyFund.AllocationSubRegionGlobalRegionId) AND
			ConsolidationRegion.IsConsolidationRegion = 1 AND
			ConsolidationRegion.IsActive = 1

		LEFT OUTER JOIN Gdm.SnapshotPropertyFund DepartmentPropertyFund ON
			Budget.SnapshotId = DepartmentPropertyFund.SnapshotId AND
			DepartmentPropertyFund.PropertyFundId =
				CASE
					WHEN
						PPS.BudgetReportGroupPeriod < 201007
					THEN
						PFM.PropertyFundId
					ELSE
						CASE
							WHEN
								GrSc.IsCorporate = 'YES'
							THEN
								RECD.PropertyFundId
							ELSE
								REPE.PropertyFundId
						END
				END AND
			DepartmentPropertyFund.IsActive = 1
	WHERE
		PPS.BonusCapExcessPreTaxAmount <> 0

	UNION ALL

	-- Get Base Salary Payroll Tax mappings and budget
	SELECT
		TaxSource.ImportBatchId,
		'Budget-SalaryTaxAmount' AS SourceName,
		TaxSource.BudgetId,
		TaxSource.ReferenceCode + '&Type=SalaryTax' AS ReferenceCod,
		TaxSource.FirstProjectedPeriod,
		TaxSource.ExpensePeriod,
		TaxSource.SourceCode,
		TaxSource.SalaryTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		TaxSource.MinorGlAccountCategoryId, 
		TaxSource.FunctionalDepartmentId,
		TaxSource.FunctionalDepartmentCode,
		TaxSource.Reimbursable,  
		'SalaryTaxTax' FeeOrExpense,
		TaxSource.ActivityTypeId,
		TaxSource.PropertyFundId,
		TaxSource.AllocationSubRegionGlobalRegionId,
		TaxSource.ConsolidationSubRegionGlobalRegionId,
		TaxSource.OriginatingRegionCode,
		TaxSource.OriginatingRegionSourceCode,
		TaxSource.LocalCurrencyCode,
		TaxSource.AllocationUpdatedDate,
		--General Allocated Overhead Account :: CC8
		'N/A' AS GlobalGlAccountCode,
		CASE
			WHEN
				TaxSource.ActivityTypeCode = 'CORPOH'
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverhead,
		
		TaxSource.SourceTableName
	FROM
		#ProfitabilityTaxSource TaxSource
		
		-- Used to map the Major and Minor Category Ids based on the SnapshotId
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			TaxSource.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = 'Benefits'
	WHERE
		TaxSource.SalaryTaxAmount <> 0

	-- Get Profit Share Benefit Tax mappings and budget
	UNION ALL

	SELECT
		TaxSource.ImportBatchId,
		'Budget-ProfitShareTaxAmount' AS SourceName,
		TaxSource.BudgetId,
		TaxSource.ReferenceCode + '&Type=ProfitShareTax' AS ReferenceCod,
		TaxSource.FirstProjectedPeriod,
		TaxSource.ExpensePeriod,
		TaxSource.SourceCode,
		TaxSource.ProfitShareTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		TaxSource.MinorGlAccountCategoryId, 
		TaxSource.FunctionalDepartmentId,
		TaxSource.FunctionalDepartmentCode,
		TaxSource.Reimbursable,  
		'ProfitShareTax' FeeOrExpense,
		TaxSource.ActivityTypeId,
		TaxSource.PropertyFundId,
		TaxSource.AllocationSubRegionGlobalRegionId,
		TaxSource.ConsolidationSubRegionGlobalRegionId,
		TaxSource.OriginatingRegionCode,
		TaxSource.OriginatingRegionSourceCode,
		TaxSource.LocalCurrencyCode,
		TaxSource.AllocationUpdatedDate,
		
		'N/A' AS GlobalGlAccountCode,
		CASE
			WHEN
				TaxSource.ActivityTypeCode = 'CORPOH'
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverhead,
		
		TaxSource.SourceTableName
	FROM
		#ProfitabilityTaxSource TaxSource

		-- Used to map the Major and Minor Category Ids based on the SnapshotId						
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			TaxSource.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = 'Benefits'
	WHERE
		TaxSource.ProfitShareTaxAmount <> 0

	-- Get Bonus Tax mappings and budget
	UNION ALL

	SELECT
		TaxSource.ImportBatchId,
		'Budget-BonusTaxAmount' AS SourceName,
		TaxSource.BudgetId,
		TaxSource.ReferenceCode + '&Type=BonusTax' AS ReferenceCod,
		TaxSource.FirstProjectedPeriod,
		TaxSource.ExpensePeriod,
		TaxSource.SourceCode,
		TaxSource.BonusTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		TaxSource.MinorGlAccountCategoryId, 
		TaxSource.FunctionalDepartmentId,
		TaxSource.FunctionalDepartmentCode,
		TaxSource.Reimbursable,  
		'BonusTax' FeeOrExpense,
		TaxSource.ActivityTypeId,
		TaxSource.PropertyFundId,
		TaxSource.AllocationSubRegionGlobalRegionId,
		TaxSource.ConsolidationSubRegionGlobalRegionId,
		TaxSource.OriginatingRegionCode,
		TaxSource.OriginatingRegionSourceCode,
		TaxSource.LocalCurrencyCode,
		TaxSource.AllocationUpdatedDate,
		--General Allocated Overhead Account :: CC8
		'N/A' AS GlobalGlAccountCode,
		CASE
			WHEN
				TaxSource.ActivityTypeCode = 'CORPOH'
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverhead,
		
		TaxSource.SourceTableName
	FROM
		#ProfitabilityTaxSource TaxSource

		INNER JOIN #NewBudgets Budget ON
		  TaxSource.BudgetId = Budget.BudgetId

		-- Used to map the Major and Minor Category Ids based on the SnapshotId  					
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			TaxSource.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = 'Benefits'
	WHERE
		TaxSource.BonusTaxAmount <> 0

	-- Get Bonus cap Tax mappings 
	UNION ALL

	SELECT
		TaxSource.ImportBatchId,
		'Budget-BonusCapExcessTaxAmount' AS SourceName,
		TaxSource.BudgetId,
		TaxSource.ReferenceCode + '&Type=BonusCapExcessTax' AS ReferenceCod,
		TaxSource.FirstProjectedPeriod,
		TaxSource.ExpensePeriod,
		TaxSource.SourceCode,
		TaxSource.BonusCapExcessTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		TaxSource.MinorGlAccountCategoryId, 
		TaxSource.FunctionalDepartmentId,
		TaxSource.FunctionalDepartmentCode,
		0 AS Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
		'BonusCapExcessTax' AS FeeOrExpense,
		ISNULL(BonusCapExcessProject.ActivityTypeId, -1) AS ActivityTypeId,
		COALESCE(DepartmentPropertyFund.PropertyFundId, ProjectPropertyFund.PropertyFundId, -1) AS PropertyFundId,
		COALESCE(DepartmentPropertyFund.AllocationSubRegionGlobalRegionId, ProjectPropertyFund.AllocationSubRegionGlobalRegionId -1) AS AllocationSubRegionGlobalRegionId,	
		ISNULL(ConsolidationRegion.GlobalRegionId, -1) AS ConsolidationSubRegionGlobalRegionId,
		TaxSource.OriginatingRegionCode,
		TaxSource.OriginatingRegionSourceCode,
		TaxSource.LocalCurrencyCode,
		TaxSource.AllocationUpdatedDate,
		'N/A' AS GlobalGlAccountCode,
		CASE
			WHEN
				TaxSource.ActivityTypeCode = 'CORPOH'
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverhead,
		
		TaxSource.SourceTableName
	FROM
		#ProfitabilityTaxSource TaxSource

		INNER JOIN #NewBudgets Budget on
			TaxSource.BudgetId = Budget.BudgetId 

		-- Used to map the Major and Minor Category Ids based on the SnapshotId
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			TaxSource.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = 'Benefits'

		LEFT OUTER JOIN #SystemSettingRegion ssr ON
			TaxSource.SourceCode = ssr.SourceCode AND
			TaxSource.BudgetRegionId = ssr.RegionId AND
			ssr.SystemSettingName = 'BonusCapExcess'

		LEFT OUTER JOIN #Project BonusCapExcessProject ON
			ssr.BonusCapExcessProjectId = BonusCapExcessProject.ProjectId

		LEFT OUTER JOIN Gdm.SnapshotPropertyFund ProjectPropertyFund ON
			BonusCapExcessProject.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
			Budget.SnapshotId = ProjectPropertyFund.SnapshotId AND
			ProjectPropertyFund.IsActive = 1

		LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
			BonusCapExcessProject.CorporateSourceCode = GrSc.SourceCode  

		LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping PFM ON
			BonusCapExcessProject.CorporateDepartmentCode = PFM.PropertyFundCode AND -- Combination of entity and corporate department
			BonusCapExcessProject.CorporateSourceCode = PFM.SourceCode AND
			PFM.IsDeleted = 0 AND 
			(
				(GrSc.IsProperty = 'YES' AND PFM.ActivityTypeId IS NULL) 
				OR
				(
					(GrSc.IsCorporate = 'YES' AND PFM.ActivityTypeId = BonusCapExcessProject.ActivityTypeId)
					OR
					(GrSc.IsCorporate = 'YES' AND PFM.ActivityTypeId IS NULL AND BonusCapExcessProject.ActivityTypeId IS NULL)
				)
			) AND
			TaxSource.BudgetReportGroupPeriod < 201007 AND
			Budget.SnapshotId = PFM.SnapshotId

		LEFT OUTER JOIN	Gdm.SnapshotReportingEntityCorporateDepartment RECD ON
			GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
			LTRIM(RTRIM(BonusCapExcessProject.CorporateDepartmentCode)) = RECD.CorporateDepartmentCode AND
			BonusCapExcessProject.CorporateSourceCode  = RECD.SourceCode AND
			TaxSource.BudgetReportGroupPeriod >= 201007 AND			   
			Budget.SnapshotId = RECD.SnapshotId  

		LEFT OUTER JOIN Gdm.SnapshotReportingEntityPropertyEntity REPE ON
			GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(BonusCapExcessProject.CorporateDepartmentCode))  = REPE.PropertyEntityCode AND
			BonusCapExcessProject.CorporateSourceCode  = REPE.SourceCode AND
			TaxSource.BudgetReportGroupPeriod >= 201007 AND
			Budget.SnapshotId = REPE.SnapshotId

		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD ON -- (CC16)
			GrSc.IsCorporate = 'YES' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(BonusCapExcessProject.CorporateDepartmentCode)) = CRCD.CorporateDepartmentCode AND
			BonusCapExcessProject.CorporateSourceCode = CRCD.SourceCode AND
			Budget.SnapshotId  = CRCD.SnapshotId AND
			TaxSource.BudgetReportGroupPeriod >= 201101

		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionPropertyEntity CRPE ON
			GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(BonusCapExcessProject.CorporateDepartmentCode)) = CRPE.PropertyEntityCode AND
			BonusCapExcessProject.CorporateSourceCode = CRPE.SourceCode AND
			Budget.SnapshotId = CRPE.SnapshotId AND
			TaxSource.BudgetReportGroupPeriod >= 201101

		LEFT OUTER JOIN Gdm.SnapshotPropertyFund DepartmentPropertyFund ON
			Budget.SnapshotId = DepartmentPropertyFund.SnapshotId AND
			DepartmentPropertyFund.PropertyFundId =
				CASE
					WHEN
						TaxSource.BudgetReportGroupPeriod < 201007
					THEN
						PFM.PropertyFundId
					ELSE
						CASE
							WHEN
								GrSc.IsCorporate = 'YES'
							THEN
								RECD.PropertyFundId
							ELSE
								REPE.PropertyFundId
						END
				END AND
			DepartmentPropertyFund.IsActive = 1

		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion ConsolidationRegion ON
			TaxSource.SnapshotId = ConsolidationRegion.SnapshotId AND
			ConsolidationRegion.GlobalRegionId = COALESCE(CRCD.GlobalRegionId, CRPE.GlobalRegionId, ProjectPropertyFund.AllocationSubRegionGlobalRegionId) AND
			ConsolidationRegion.IsConsolidationRegion = 1 AND
			ConsolidationRegion.IsActive = 1
	WHERE
		TaxSource.BonusCapExcessTaxAmount <> 0
		
	-- Get Overhead mappings
	UNION ALL

	SELECT
		OverheadSource.ImportBatchId,
		'Budget-OverheadAllocationAmount' AS SourceName,
		OverheadSource.BudgetId,
		OverheadSource.ReferenceCode + '&Type=OverheadAllocation' AS ReferenceCod,
		OverheadSource.FirstProjectedPeriod,
		OverheadSource.ExpensePeriod,
		OverheadSource.SourceCode,
		OverheadSource.OverheadAllocationAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MinorGlAccountCategoryId,
		OverheadSource.MinorGlAccountCategoryId,
		OverheadSource.FunctionalDepartmentId,
		OverheadSource.FunctionalDepartmentCode,
		OverheadSource.Reimbursable,
		'Overhead' FeeOrExpense,
		OverheadSource.ActivityTypeId,
		OverheadSource.PropertyFundId,
		OverheadSource.AllocationSubRegionGlobalRegionId,
		OverheadSource.ConsolidationSubRegionGlobalRegionId,
		OverheadSource.OriginatingRegionCode,
		OverheadSource.OriginatingRegionSourceCode,
		OverheadSource.LocalCurrencyCode,
		OverheadSource.OverheadUpdatedDate,
		--General Allocated Overhead Account :: CC8
		'50029500' + RIGHT('0' + LTRIM(STR(OverheadSource.ActivityTypeId, 3, 0)), 2) AS GlobalGlAccountCode,
		1 AS IsCorporateOverhead,
		
		OverheadSource.SourceTableName
	FROM
		#ProfitabilityOverheadSource OverheadSource

		INNER JOIN #NewBudgets Budget ON
			Budget.BudgetId = OverheadSource.BudgetId

		-- Maps the Major Category of the Overhead transaction
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			OverheadSource.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = 'External General Overhead'
	WHERE
		OverheadSource.OverheadAllocationAmount <> 0

	PRINT 'Completed inserting records into #ProfitabilityPayrollMapping:'+CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	CREATE CLUSTERED INDEX IX_AllocationUpdatedDate ON #ProfitabilityPayrollMapping(ReferenceCode,AllocationUpdatedDate)

	PRINT 'Completed creating indexes on #ProfitabilityPayrollMapping'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END

/* ===============================================================================================================================================
	7.	Create Global and Local Categorization mapping tables
   ============================================================================================================================================= */
BEGIN

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		Global Categorization Mapping

		The table below is used to map Gl Accounts to their Categorization Hierarchies for the Global Categorization.
		The GlobalGL Accounts used are the list from the #ActivityTypeGLAccount table created earlier.
	*/

	CREATE TABLE #GlGlobalAccount
	(
		GLGlobalAccountId INT NOT NULL,
		Code VARCHAR(10) NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #GlGlobalAccount
	(
		GLGlobalAccountId,
		Code,
		SnapshotId
	)
	SELECT 
		GGA.GLGlobalAccountId,
		GGA.Code,
		GGA.SnapshotId
	FROM
		Gdm.SnapshotGLGlobalAccount GGA
	WHERE
		GGA.Code LIKE '50029500%' AND
		GGA.IsActive = 1
		
	UNION
	SELECT -- This is the record to be used for Payroll transactions.
		0,
		'N/A',
		S.SnapshotId
	FROM
		Gdm.[Snapshot] S

	CREATE TABLE #GlobalGLCategorizationMapping
	(
		GlobalGLCategorizationHierarchyKey VARCHAR(50) NULL,
		GLMajorCategoryId INT NOT NULL,
		GLMinorCategoryId INT NOT NULL,
		GlGlobalAccountCode VARCHAR(10) NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #GlobalGLCategorizationMapping
	(
		GlobalGLCategorizationHierarchyKey,
		GLMajorCategoryId,
		GLMinorCategoryId,
		GlGlobalAccountCode,
		SnapshotId	
	)
	SELECT
		DIM.GLCategorizationHierarchyKey,
		GdmMappings.GLMajorCategoryId,
		GdmMappings.GLMinorCategoryId,
		GGA.Code AS GlGlobalAccountCode,
		GdmMappings.SnapshotId		
	FROM
		#GlGlobalAccount GGA
		INNER JOIN
		(
			SELECT
				GCT.GLCategorizationTypeId,
				GC.GLCategorizationId,
				GFC.GLFinancialCategoryId,
				MajC.GLMajorCategoryId GLMajorCategoryId,
				MinC.GLMinorCategoryId GLMinorCategoryId,
				GCT.SnapshotId
			FROM
				Gdm.SnapshotGLMinorCategory MinC
					
				INNER JOIN Gdm.SnapshotGLMajorCategory MajC ON
					MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
					MinC.SnapshotId = MajC.SnapshotId AND
					MajC.IsActive = 1
					
				INNER JOIN Gdm.SnapshotGLFinancialCategory GFC ON
					MajC.GLFinancialCategoryId = GFC.GLFinancialCategoryId AND
					MajC.SnapshotId  = GFC.SnapshotId  
					
				INNER JOIN Gdm.SnapshotGLCategorization GC ON
					GFC.GLCategorizationId = GC.GLCategorizationId AND
					GFC.SnapshotId = GC.SnapshotId AND
					GC.GLCategorizationId = 233
					
				INNER JOIN Gdm.SnapshotGLCategorizationType GCT ON
					GC.GLCategorizationTypeId = GCT.GLCategorizationTypeId AND
					GC.SnapshotId = GCT.SnapshotId 
			WHERE -- Limits it to the major categories and minor categories that are relevant to the budgets being processed
				(	
					MajC.Name = 'Salaries/Taxes/Benefits' OR
					(
						MinC.Name = 'External General Overhead' AND
						MajC.Name = 'General Overhead'
					)
				) AND
				MinC.IsActive = 1
				
		) GdmMappings ON
			GGA.SnapshotId = GdmMappings.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy DIM ON
			GdmMappings.SnapshotId = DIM.SnapshotId AND
			DIM.GLCategorizationHierarchyCode = CONVERT(VARCHAR(32),
				LTRIM(STR(GdmMappings.GLCategorizationTypeId, 10, 0)) + ':' + 
				LTRIM(STR(GdmMappings.GLCategorizationId, 10, 0)) + ':' +
				LTRIM(STR(GdmMappings.GLFinancialCategoryId, 10, 0)) + ':' +
				LTRIM(STR(GdmMappings.GLMajorCategoryId, 10, 0)) + ':' + 
				LTRIM(STR(GdmMappings.GLMinorCategoryId, 10, 0)) + ':' +
				LTRIM(STR(ISNULL(GGA.GLGlobalAccountId, 0), 10, 0)))

	CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #GlobalGLCategorizationMapping(SnapshotId, GlGlobalAccountCode, GLMajorCategoryId, GLMinorCategoryId)

		/*  ----------------------------------------------------------------------------------------------------------------------------------------
			Local Payroll Categorization Mappings

			The #LocalPayrollGLCategorizationMapping table below is used to determine the local GLCategorizationHierchy Codes.
			The table is pivoted (i.e. each of the GLCategorizationHierchy Codes for each GLCategorization appear as a separate column for each
				ActivityType-FunctionalDepartment combination)so that it only joins to the #ProfitabilityActual table below once.
			The Businss Logic for how Local Categorizations can be found at GR Change Control 21 [3.4.3.3]		
		*/

	CREATE TABLE #LocalPayrollGLCategorizationMapping
	(
		FunctionalDepartmentId INT NULL,
		ActivityTypeId INT NULL,
		PayrollTypeId INT NULL,
		GlobalGLMinorCategoryId INT NULL,
		SnapshotId INT NOT NULL,
		USPropertyGLCategorizationHierarchyKey VARCHAR(50) NULL,
		USFundGLCategorizationHierarchyKey VARCHAR(50) NULL,
		EUPropertyGLCategorizationHierarchyKey VARCHAR(50) NULL,
		EUFundGLCategorizationHierarchyKey VARCHAR(50) NULL,
		USDevelopmentGLCategorizationHierarchyKey VARCHAR(50) NULL,
		EUDevelopmentGLCategorizationHierarchyKey VARCHAR(50) NULL
	)
	INSERT INTO #LocalPayrollGLCategorizationMapping(
		FunctionalDepartmentId,
		ActivityTypeId,
		PayrollTypeId,
		GlobalGLMinorCategoryId,
		SnapshotId,
		USPropertyGLCategorizationHierarchyKey,
		USFundGLCategorizationHierarchyKey,
		EUPropertyGLCategorizationHierarchyKey,
		EUFundGLCategorizationHierarchyKey,
		USDevelopmentGLCategorizationHierarchyKey,
		EUDevelopmentGLCategorizationHierarchyKey
	)
	SELECT
		PivotTable.FunctionalDepartmentId,
		PivotTable.ActivityTypeId,
		PivotTable.PayrollTypeId,
		PivotTable.GLMinorCategoryId,
		PivotTable.SnapshotId,
		PivotTable.[US Property] AS USPropertyGLCategorizationHierarchyKey,
		PivotTable.[US Fund] AS USFundGLCategorizationHierarchyKey,
		PivotTable.[EU Property] AS EUPropertyGLCategorizationHierarchyKey,
		PivotTable.[EU Fund] AS EUFundGLCategorizationHierarchyKey,
		PivotTable.[US Development] AS USDevelopmentGLCategorizationHierarchyKey,
		PivotTable.[EU Development] AS EUDevelopmentGLCategorizationHierarchyKey
	FROM
		(
			SELECT DISTINCT
				FD.FunctionalDepartmentId,
				AType.ActivityTypeId,
				PPPGA.PayrollTypeId,
				MinCa.GLMinorCategoryId,
				PPPGA.SnapshotId,
				GC.Name AS GLCategorizationName,
				ISNULL(DIM.GLCategorizationHierarchyKey, UnknownDIM.GLCategorizationHierarchyKey) AS GLCategorizationHierarchyKey
			FROM
				Gdm.SnapshotPropertyPayrollPropertyGLAccount PPPGA

				INNER JOIN Gdm.SnapshotActivityType AType ON
					ISNULL(PPPGA.ActivityTypeId, 0) = CASE WHEN PPPGA.ActivityTypeId IS NULL THEN 0 ELSE AType.ActivityTypeId END AND
					PPPGA.SnapshotId = AType.SnapshotId AND
					AType.IsActive = 1

				INNER JOIN Gdm.SnapshotFunctionalDepartment FD ON
					ISNULL(PPPGA.FunctionalDepartmentId, 0) = CASE WHEN PPPGA.FunctionalDepartmentId IS NULL THEN 0 ELSE FD.FunctionalDepartmentId END AND
					PPPGA.SnapshotId = FD.SnapshotId AND
					FD.IsActive = 1

				INNER JOIN Gdm.SnapshotGLMinorCategory MinCa ON
					MinCa.GLMinorCategoryId IN (SELECT GLMinorCategoryId FROM #PayrollGlobalMappings) AND
					ISNULL(PPPGA.GLMinorCategoryId, 0) = CASE WHEN PPPGA.GLMinorCategoryId IS NULL THEN 0 ELSE MinCa.GLMinorCategoryId END AND
					PPPGA.SnapshotId = MinCa.SnapshotId AND
					MinCa.IsActive = 1

				INNER JOIN Gdm.SnapshotGLCategorization GC ON
					PPPGA.GLCategorizationId = GC.GLCategorizationId AND
					PPPGA.SnapshotId = GC.SnapshotId AND
					GC.IsActive = 1

				INNER JOIN Gdm.SnapshotGLAccount GA ON
					PPPGA.PropertyGLAccountId = GA.GLAccountId AND
					PPPGA.SnapshotId = GA.SnapshotID AND
					GA.IsActive = 1
				/*
					If the local Categorization is configured for recharge, the Global account is determined through the PropertyGLAccount 
						local account
					If the local Categorization is not configured for recharge, the Global account is determined directly from the 
						#PropertyPayrollPropertyGLAccount table
				*/
				INNER JOIN Gdm.SnapshotGLGlobalAccount GGA ON
					PPPGA.SnapshotId = GGA.SnapshotId AND
					GGA.GLGlobalAccountId = 
						CASE 
							WHEN
								GC.RechargeSourceCode IS NOT NULL AND GC.IsConfiguredForRecharge = 1
							THEN
								GA.GLGlobalAccountId
							ELSE
								PPPGA.GLGlobalAccountId
						END AND
					GGA.IsActive = 1

				LEFT OUTER JOIN Gdm.SnapshotGLGlobalAccountCategorization GGAC ON
					GGA.GLGlobalAccountId = GGAC.GLGlobalAccountId AND
					PPPGA.GLCategorizationId = GGAC.GLCategorizationId AND
					GGA.SnapshotId = GGAC.SnapshotId 

				/*
					If the local Categorization is configured for recharge, the Minor Category is determined through the CoAGLMinorCategoryId field
						in the #GLGlobalAccountCategorization table.
					If the local Categorization is not configured for recharge, the Minor Category is determined through the IndirectGLMinorCategoryId 
						field in the #GLGlobalAccountCategorization table.
				*/	
				LEFT OUTER JOIN Gdm.SnapshotGLMinorCategory MinC ON
					GGAC.SnapshotId = MinC.SnapshotId AND
					MinC.GLMinorCategoryId =
						CASE 
							WHEN
								GC.RechargeSourceCode IS NOT NULL AND GC.IsConfiguredForRecharge = 1
							THEN
								GGAC.CoAGLMinorCategoryId
							ELSE
								GGAC.DirectGLMinorCategoryId
						END	AND
					MinC.IsActive = 1	

				LEFT OUTER JOIN Gdm.SnapshotGLMajorCategory MajC ON
					MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
					MinC.SnapshotId = MajC.SnapshotId AND
					MajC.IsActive = 1

				LEFT OUTER JOIN Gdm.SnapshotGLFinancialCategory FinC ON
					MajC.GLFinancialCategoryId  = FinC.GLFinancialCategoryId AND
					MajC.SnapshotId = FinC.SnapshotId AND
					GC.GLCategorizationId  = FinC.GLCategorizationId

				LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy DIM ON
					FinC.SnapshotId = DIM.SnapshotId AND
					DIM.GLCategorizationHierarchyCode = 
						CONVERT(VARCHAR(2), GC.GLCategorizationTypeId ) + ':' +
						CONVERT(VARCHAR(10), GC.GLCategorizationId) + ':' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE FinC.GLFinancialCategoryId END) + ':' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE MajC.GLMajorCategoryId END) + ':' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE MinC.GLMinorCategoryId END) + ':' +
						CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1))
				
				LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy UnknownDIM ON
					UnknownDIM.GLCategorizationHierarchyCode = 
						CONVERT(VARCHAR(2), GC.GLCategorizationTypeId) + ':' +
						CONVERT(VARCHAR(10), GC.GLCategorizationId) + ':' +
						':-1:-1:-1:' + CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1)) AND
					PPPGA.SnapshotId = UnknownDIM.SnapshotId
			WHERE
				ISNULL(PPPGA.IsActive, 1) = 1
		) LocalMappings
		PIVOT
		(
			MAX(GLCategorizationHierarchyKey)
			FOR GLCategorizationName IN ([US Property], [US Fund], [EU Property], [EU Fund], [US Development], [EU Development])
		) AS PivotTable

	CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #LocalPayrollGLCategorizationMapping(FunctionalDepartmentId, ActivityTypeId, PayrollTypeId, GlobalGLMinorCategoryId,	SnapshotId)

		/*
			Overhead Budget transactions are mapped differently from the Payroll transactions.
			Overhead transactions use the SnapshotPropertyOverheadPropertyGLAccount table instead of the SnapshotPropertyPayrollPropertyGLAccount
			table. They are mapped in the same way as overhead actuals except Snapshot tables are used.
			The details of the Overhead mappings can be found in Change Control 21 [3.4.3.3.3]
		*/

	CREATE TABLE #LocalOverheadGLCategorizationMapping
	(
		FunctionalDepartmentId INT NULL,
		ActivityTypeId INT NULL,
		SnapshotId INT NULL,
		USPropertyGLCategorizationHierarchyKey VARCHAR(50) NULL,
		USFundGLCategorizationHierarchyKey VARCHAR(50) NULL,
		EUPropertyGLCategorizationHierarchyKey VARCHAR(50) NULL,
		EUFundGLCategorizationHierarchyKey VARCHAR(50) NULL,
		USDevelopmentGLCategorizationHierarchyKey VARCHAR(50) NULL,
		EUDevelopmentGLCategorizationHierarchyKey VARCHAR(50) NULL
	)
	INSERT INTO #LocalOverheadGLCategorizationMapping
	(
		FunctionalDepartmentId,
		ActivityTypeId,
		SnapshotId,
		USPropertyGLCategorizationHierarchyKey,
		USFundGLCategorizationHierarchyKey,
		EUPropertyGLCategorizationHierarchyKey,
		EUFundGLCategorizationHierarchyKey,
		USDevelopmentGLCategorizationHierarchyKey,
		EUDevelopmentGLCategorizationHierarchyKey
	)
	SELECT
		PivotTable.FunctionalDepartmentId,
		PivotTable.ActivityTypeId,
		PivotTable.SnapshotId,
		PivotTable.[US Property] AS USPropertyGLCategorizationHierarchyKey,
		PivotTable.[US Fund] AS USFundGLCategorizationHierarchyKey,
		PivotTable.[EU Property] AS EUPropertyGLCategorizationHierarchyKey,
		PivotTable.[EU Fund] AS EUFundGLCategorizationHierarchyKey,
		PivotTable.[US Development] AS USDevelopmentGLCategorizationHierarchyKey,
		PivotTable.[EU Development] AS EUDevelopmentGLCategorizationHierarchyKey
	FROM
		(
			SELECT DISTINCT
				FD.FunctionalDepartmentId,
				AType.ActivityTypeId,
				POPGA.SnapshotId,
				GC.Name as GLCategorizationName,
				ISNULL(DIM.GLCategorizationHierarchyKey, UnknownDIM.GLCategorizationHierarchyKey) AS GLCategorizationHierarchyKey
			FROM
				Gdm.SnapshotPropertyOverheadPropertyGLAccount POPGA

				INNER JOIN Gdm.SnapshotGLCategorization GC ON
					POPGA.GLCategorizationId = GC.GLCategorizationId AND
					POPGA.SnapshotId = GC.SnapshotId AND
					GC.IsActive = 1

				INNER JOIN Gdm.SnapshotActivityType AType ON
					ISNULL(POPGA.ActivityTypeId, 0) = CASE WHEN POPGA.ActivityTypeId IS NULL THEN 0 ELSE AType.ActivityTypeId END AND
					POPGA.SnapshotId = AType.SnapshotId AND
					AType.IsActive = 1

				INNER JOIN Gdm.SnapshotFunctionalDepartment FD ON
					ISNULL(POPGA.FunctionalDepartmentId, 0) = CASE WHEN POPGA.FunctionalDepartmentId IS NULL THEN 0 ELSE FD.FunctionalDepartmentId END AND
					POPGA.SnapshotId = FD.SnapshotId AND
					FD.IsActive = 1

				INNER JOIN Gdm.SnapshotGLAccount GA ON
					POPGA.PropertyGLAccountId = GA.GLAccountId AND
					POPGA.SnapshotId = GA.SnapshotId AND
					GA.IsActive = 1
				/*
					If the local Categorization is configured for recharge, the Global account is determined through the PropertyGLAccount local account
					If the local Categorization is not configured for recharge, the Global account is determined directly from the 
						#PropertyOverheadPropertyGLAccount table
				*/
				INNER JOIN Gdm.SnapshotGLGlobalAccount GGA ON
					POPGA.SnapshotId = GGA.SnapshotId AND
					GGA.GLGlobalAccountId = 
						CASE
							WHEN
								GC.RechargeSourceCode IS NOT NULL AND GC.IsConfiguredForRecharge = 1
							THEN
								GA.GLGlobalAccountId
							ELSE
								POPGA.GLGlobalAccountId
						END AND
					GGA.IsActive = 1

				LEFT OUTER JOIN Gdm.SnapshotGLGlobalAccountCategorization GGAC ON
					GGA.GLGlobalAccountId = GGAC.GLGlobalAccountId AND
					POPGA.GLCategorizationId = GGAC.GLCategorizationId AND
					GGA.SnapshotId = GGAC.SnapshotId AND
					GGA.IsActive = 1
				/*
					If the local Categorization is configured for recharge, the Minor Category is determined through the CoAGLMinorCategoryId field
						in the #GLGlobalAccountCategorization table.
					If the local Categorization is not configured for recharge, the Minor Category is determined through the IndirectGLMinorCategoryId 
						field in the #GLGlobalAccountCategorization table.
				*/	
				LEFT OUTER JOIN Gdm.SnapshotGLMinorCategory MinC ON
					GGAC.SnapshotId = MinC.SnapshotId AND
					MinC.IsActive = 1 AND
					MinC.GLMinorCategoryId =
						CASE 
							WHEN
								GC.RechargeSourceCode IS NOT NULL AND GC.IsConfiguredForRecharge = 1
							THEN
								GGAC.CoAGLMinorCategoryId
							ELSE
								GGAC.DirectGLMinorCategoryId
						END 

				LEFT OUTER JOIN Gdm.SnapshotGLMajorCategory MajC ON
					MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
					MinC.SnapshotId = MajC.SnapshotId AND
					MajC.IsActive = 1 

				LEFT OUTER JOIN Gdm.SnapshotGLFinancialCategory FinC ON
					MajC.GLFinancialCategoryId = FinC.GLFinancialCategoryId AND
					GC.GLCategorizationId  = FinC.GLCategorizationId AND
					GC.SnapshotId = FinC.SnapshotId  

				LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy DIM ON
					FinC.SnapshotId = DIM.SnapshotId AND
					DIM.GLCategorizationHierarchyCode = 
						CONVERT(VARCHAR(2), GC.GLCategorizationTypeId) + ':' +
						CONVERT(VARCHAR(10), GC.GLCategorizationId) + ':' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE FinC.GLFinancialCategoryId END) + ':' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE MajC.GLMajorCategoryId END) + ':' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE MinC.GLMinorCategoryId END) + ':' +
						CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1))
						
				LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy UnknownDIM ON
					UnknownDIM.GLCategorizationHierarchyCode = 
						CONVERT(VARCHAR(2), GC.GLCategorizationTypeId) + ':' +
						CONVERT(VARCHAR(10), GC.GLCategorizationId) + ':' +
						'-1:-1:-1:' + CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1)) AND
					POPGA.SnapshotId = UnknownDIM.SnapshotId

			WHERE
				ISNULL(POPGA.IsActive, 1) = 1

		) LocalMappings
		PIVOT
		(
			MAX(GLCategorizationHierarchyKey)
			FOR GLCategorizationName IN ([US Property], [US Fund], [EU Property], [EU Fund], [US Development], [EU Development])
		) AS PivotTable

	CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #LocalOverheadGLCategorizationMapping(FunctionalDepartmentId, ActivityTypeId, SnapshotId)

END

/* ================================================================================================================================================
	8.	Map table to the #ProfitabilityBudget table with the same structure as the GrReporting.dbo.ProfitabilityBudget table
   ============================================================================================================================================= */
BEGIN

	SET @StartTime = GETDATE()

	CREATE TABLE #ProfitabilityReforecast
	(
		ImportBatchId INT NOT NULL,
		SourceName VARCHAR(50),
		BudgetReforecastTypeKey INT NOT NULL,
		SnapshotId INT NOT NULL,
		CalendarKey INT NOT NULL,
		ReforecastKey INT NOT NULL,
		SourceKey INT NOT NULL,
		FunctionalDepartmentKey INT NOT NULL,
		ReimbursableKey INT NOT NULL,
		ActivityTypeKey INT NOT NULL,
		PropertyFundKey INT NOT NULL,	
		AllocationRegionKey INT NOT NULL,
		ConsolidationRegionKey INT NOT NULL,
		OriginatingRegionKey INT NOT NULL,
		OverheadKey INT NOT NULL,
		LocalCurrencyKey INT NOT NULL,
		LocalReforecast MONEY NOT NULL,
		ReferenceCode VARCHAR(300) NOT NULL,
		BudgetId INT NOT NULL,
		
		GlobalGLCategorizationHierarchyKey INT NOT NULL,
		USPropertyGLCategorizationHierarchyKey INT NOT NULL,
		USFundGLCategorizationHierarchyKey INT NOT NULL,
		EUPropertyGLCategorizationHierarchyKey INT NOT NULL,
		EUFundGLCategorizationHierarchyKey INT NOT NULL,
		USDevelopmentGLCategorizationHierarchyKey INT NOT NULL,
		EUDevelopmentGLCategorizationHierarchyKey INT NOT NULL,
		ReportingGLCategorizationHierarchyKey INT NOT NULL,
		
		SourceSystemKey INT NOT NULL
	) 

	INSERT INTO #ProfitabilityReforecast 
	(
		ImportBatchId,
		SourceName,
		BudgetReforecastTypeKey,
		SnapshotId,
		CalendarKey,
		ReforecastKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		PropertyFundKey,
		AllocationRegionKey,
		ConsolidationRegionKey,
		OriginatingRegionKey,
		OverheadKey,
		LocalCurrencyKey,
		LocalReforecast,
		ReferenceCode,
		BudgetId,
		
		GlobalGLCategorizationHierarchyKey,
		USPropertyGLCategorizationHierarchyKey,
		USFundGLCategorizationHierarchyKey,
		EUPropertyGLCategorizationHierarchyKey,
		EUFundGLCategorizationHierarchyKey,
		USDevelopmentGLCategorizationHierarchyKey,
		EUDevelopmentGLCategorizationHierarchyKey,
		ReportingGLCategorizationHierarchyKey,
		
		SourceSystemKey
	)
	SELECT
		PBM.ImportBatchId,
		pbm.SourceName,
		@ReforecastTypeIsTGBBUDKey,
		Budget.SnapshotId,
		DATEDIFF(dd, '1900-01-01', LEFT(pbm.ExpensePeriod, 4) + '-' + RIGHT(pbm.ExpensePeriod, 2) + '-01') AS CalendarKey,
		Budget.ReforecastKey AS ReforecastKey,
		ISNULL(GrSc.SourceKey, @SourceKeyUnknown) SourceKey,
		ISNULL(GrFdm.FunctionalDepartmentKey, @FunctionalDepartmentKeyUnknown) FunctionalDepartmentKey,
		ISNULL(GrRi.ReimbursableKey, @ReimbursableKeyUnknown) ReimbursableKey,
		ISNULL(GrAt.ActivityTypeKey, @ActivityTypeKeyUnknown) ActivityTypeKey,
		ISNULL(GrPf.PropertyFundKey, @PropertyFundKeyUnknown) PropertyFundKey,
		ISNULL(GrAr.AllocationRegionKey, @AllocationRegionKeyUnknown) AllocationRegionKey,
		ISNULL(GrCr.AllocationRegionKey, @AllocationRegionKeyUnknown) ConsolidationRegionKey, -- CC16: Consolidation Region Key
		ISNULL(GrOr.OriginatingRegionKey, @OriginatingRegionKeyUnknown) OriginatingRegionKey,
		ISNULL(GrOh.OverheadKey, @OverheadKeyUnknown) OverheadKey,
		ISNULL(GrCu.CurrencyKey, @LocalCurrencyKeyUnknown) LocalCurrencyKey,
		pbm.BudgetAmount,
		pbm.ReferenceCode,
		pbm.BudgetId,

		COALESCE(GlobalMapping.GlobalGLCategorizationHierarchyKey, UnknownMapping.GLCategorizationHierarchyKey, @UnknownGlobalGLCategorizationKey), -- GlobalGLCategorizationHierarchyKey
			/*
				For local categorizations, if it is an overhead transaction, it maps to the #LocalOverheadGLCategorizationMapping table. If it
				is a payroll budget record, it maps to the #LocalPayrollGLCategorizationMapping table.
				THe Global Account Code is used to determine if a transaction is an overhead transaction or not. It will have a Global Account
				code if it's an overhead transaction. If it is a payroll transaction, it will have a placeholder('N/A') as the Global Account.
			*/
		COALESCE(LocalPayrollMapping.USPropertyGLCategorizationHierarchyKey, LocalOverheadMapping.USPropertyGLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey), -- USPropertyGLCategorizationHierarchyKey
		COALESCE(LocalPayrollMapping.USFundGLCategorizationHierarchyKey, LocalOverheadMapping.USFundGLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey), -- USFundGLCategorizationHierarchyKey
		COALESCE(LocalPayrollMapping.EUPropertyGLCategorizationHierarchyKey, LocalOverheadMapping.EUPropertyGLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey), -- EUPropertyGLCategorizationHierarchyKey
		COALESCE(LocalPayrollMapping.EUFundGLCategorizationHierarchyKey, LocalOverheadMapping.EUFundGLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey), -- EUFundGLCategorizationHierarchyKey
		COALESCE(LocalPayrollMapping.USDevelopmentGLCategorizationHierarchyKey, LocalOverheadMapping.USDevelopmentGLCategorizationHierarchyKey, @UnknownUSDevelopmentGLCategorizationKey), -- USDevelopmentGLCategorizationHierarchyKey
		COALESCE(LocalPayrollMapping.EUDevelopmentGLCategorizationHierarchyKey, LocalOverheadMapping.EUDevelopmentGLCategorizationHierarchyKey, @GLCategorizationHierarchyKeyUnknown), -- EUDevelopmentGLCategorizationHierarchyKey
		/*
			The purpose of the ReportingGLCategorizationHierarchy field is to define the default GL Categorization that will be used
			when a local report is generated.
		*/

		CASE
			WHEN
				ReportingGC.GLCategorizationId IS NOT NULL
			THEN
				CASE
					WHEN
						ReportingGC.Name = 'US Property' 
					THEN
						COALESCE(LocalPayrollMapping.USPropertyGLCategorizationHierarchyKey, LocalOverheadMapping.USPropertyGLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey)
					WHEN
						ReportingGC.Name = 'US Fund' 
					THEN
						COALESCE(LocalPayrollMapping.USFundGLCategorizationHierarchyKey, LocalOverheadMapping.USFundGLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey)
					WHEN
						ReportingGC.Name = 'EU Property' 
					THEN
						COALESCE(LocalPayrollMapping.EUPropertyGLCategorizationHierarchyKey, LocalOverheadMapping.EUPropertyGLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey)
					WHEN
						ReportingGC.Name = 'EU Fund' 
					THEN
						COALESCE(LocalPayrollMapping.EUFundGLCategorizationHierarchyKey, LocalOverheadMapping.EUFundGLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey)
					WHEN
						ReportingGC.Name = 'US Development' 
					THEN
						COALESCE(LocalPayrollMapping.USDevelopmentGLCategorizationHierarchyKey, LocalOverheadMapping.USDevelopmentGLCategorizationHierarchyKey, @UnknownUSDevelopmentGLCategorizationKey)
					WHEN
						ReportingGC.Name = 'EU Development' 
					THEN
						COALESCE(LocalPayrollMapping.EUDevelopmentGLCategorizationHierarchyKey, LocalOverheadMapping.EUDevelopmentGLCategorizationHierarchyKey, @GLCategorizationHierarchyKeyUnknown)
					WHEN
						ReportingGC.Name = 'Global'
					THEN
						COALESCE(GlobalMapping.GlobalGLCategorizationHierarchyKey, UnknownMapping.GLCategorizationHierarchyKey, @UnknownGlobalGLCategorizationKey)
					ELSE
						@GLCategorizationHierarchyKeyUnknown
				END
			ELSE
				@GLCategorizationHierarchyKeyUnknown
		END, --  ReportingGLCategorizationHierarchyKey
		
		SSystem.SourceSystemKey
	FROM
		#ProfitabilityPayrollMapping pbm

		INNER JOIN #NewBudgets Budget on
			Budget.BudgetId = pbm.BudgetId 

		LEFT OUTER JOIN Gdm.[Snapshot] SShot ON
			Budget.SnapshotId = SShot.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
			pbm.SourceCode = GrSc.SourceCode 

		LEFT OUTER JOIN GrReporting.dbo.SourceSystem SSystem ON
			pbm.SourceTableName = SSystem.SourceTableName AND
			SSystem.SourceSystemName = 'TapasGlobalBudgeting'

		--Parent Level (No job code for payroll)
		LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdm ON
			GrFdm.ReferenceCode LIKE pbm.FunctionalDepartmentCode +':%' AND
			SShot.LastSyncDate BETWEEN GrFdm.StartDate AND GrFdm.EndDate AND
			GrFdm.SubFunctionalDepartmentCode = GrFdm.FunctionalDepartmentCode 

		LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
			CASE WHEN pbm.Reimbursable = 1 THEN 'YES' ELSE 'NO' END = GrRi.ReimbursableCode

		LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
			pbm.ActivityTypeId = GrAt.ActivityTypeId AND
			Budget.SnapshotId = GrAt.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.Overhead GrOh ON
			--GC :: Change Control 1
			GrOh.OverheadCode =
				CASE
					WHEN
						pbm.FeeOrExpense = 'Overhead'
					THEN
						'ALLOC' 
					WHEN
						GrAt.ActivityTypeCode = 'CORPOH'
					THEN
						'UNALLOC' 
					ELSE
						'N/A'
				END	

		LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
			pbm.PropertyFundId = GrPf.PropertyFundId AND
			Budget.SnapshotId = GrPf.SnapshotId

		LEFT OUTER JOIN Gdm.SnapshotAllocationSubRegion ASR ON
			pbm.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId AND
			Budget.SnapshotId = ASR.SnapshotId AND
			ASR.IsActive = 1

		LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
			ASR.AllocationSubRegionGlobalRegionId = GrAr.GlobalRegionId AND
			Budget.SnapshotId = GrAr.SnapshotId

		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion CSR ON
			pbm.ConsolidationSubRegionGlobalRegionId = CSR.GlobalRegionId AND
			CSR.IsConsolidationRegion = 1 AND
			Budget.SnapshotId = CSR.SnapshotId AND
			CSR.IsActive = 1

		LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrCr ON
			CSR.GlobalRegionId = GrCr.GlobalRegionId AND
			Budget.SnapshotId = GrCr.SnapshotId

		LEFT OUTER JOIN Gdm.SnapshotOriginatingRegionCorporateEntity ORCE ON
			Budget.SnapshotId  = ORCE.SnapshotId AND
			LTRIM(RTRIM(pbm.OriginatingRegionCode)) = ORCE.CorporateEntityCode AND
			pbm.OriginatingRegionSourceCode = ORCE.SourceCode

		LEFT OUTER JOIN Gdm.SnapshotOriginatingRegionPropertyDepartment ORPD ON
			Budget.SnapshotId = ORPD.SnapshotId	AND
			LTRIM(RTRIM(pbm.OriginatingRegionCode)) = ORPD.PropertyDepartmentCode AND
			pbm.OriginatingRegionSourceCode = ORPD.SourceCode

		LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
			ISNULL(ORCE.GlobalRegionId, ORPD.GlobalRegionId) = GrOr.GlobalRegionId AND
			Budget.SnapshotId = GrOr.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
			pbm.LocalCurrencyCode = GrCu.CurrencyCode

		LEFT OUTER JOIN Gdm.SnapshotGLMinorCategoryPayrollType MCPT ON
			pbm.MinorGlAccountCategoryId = MCPT.GLMinorCategoryId AND
			Budget.SnapshotId = MCPT.SnapshotId

		LEFT OUTER JOIN #GlobalGLCategorizationMapping GlobalMapping ON
			Budget.SnapshotId = GlobalMapping.SnapshotId AND
			pbm.GlobalGlAccountCode  = GlobalMapping.GlGlobalAccountCode AND
			pbm.MinorGlAccountCategoryId = GlobalMapping.GLMinorCategoryId AND
			pbm.MajorGlAccountCategoryId = GlobalMapping.GLMajorCategoryId

		LEFT OUTER JOIN #LocalPayrollGLCategorizationMapping LocalPayrollMapping ON
			pbm.FunctionalDepartmentId = LocalPayrollMapping.FunctionalDepartmentId AND
			pbm.ActivityTypeId  = LocalPayrollMapping.ActivityTypeId AND
			MCPT.PayrollTypeId  = LocalPayrollMapping.PayrollTypeId AND
			pbm.MinorGlAccountCategoryId = LocalPayrollMapping.GlobalGLMinorCategoryId AND
			Budget.SnapshotId = LocalPayrollMapping.SnapshotId AND
			pbm.IsCorporateOverhead = 0

		LEFT OUTER JOIN #LocalOverheadGLCategorizationMapping LocalOverheadMapping ON
			pbm.FunctionalDepartmentId  = LocalOverheadMapping.FunctionalDepartmentId AND
			pbm.ActivityTypeId = LocalOverheadMapping.ActivityTypeId AND
			Budget.SnapshotId = LocalOverheadMapping.SnapshotId AND
			pbm.IsCorporateOverhead = 1

		LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy UnknownMapping ON
			Budget.SnapshotId  = UnknownMapping.SnapshotId AND
			pbm.GlobalGlAccountCode = UnknownMapping.GLAccountCode AND
			UnknownMapping.GLCategorizationName = 'Global' AND
			UnknownMapping.GLMajorCategoryName = 'UNKNOWN'

		LEFT OUTER JOIN Gdm.SnapshotPropertyFund PF ON
			Budget.SnapshotId  = PF.SnapshotID AND
			pbm.PropertyFundId = PF.PropertyFundId  

		LEFT OUTER JOIN Gdm.SnapshotReportingCategorization RC ON
			Budget.SnapshotId  = RC.SnapshotId AND
			pbm.AllocationSubRegionGlobalRegionId = RC.AllocationSubRegionGlobalRegionId AND
			PF.EntityTypeId = RC.EntityTypeId  

		LEFT OUTER JOIN Gdm.SnapshotGLCategorization ReportingGC ON
			RC.SnapshotId = ReportingGC.SnapshotId AND
			RC.GLCategorizationId = ReportingGC.GLCategorizationId




	PRINT 'Completed inserting budget portions into #ProfitabilityReforecast:'+CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END

/* ================================================================================================================================================
	9.	Insert Actuals from the Budget Profitability Actual table in GBS
   ============================================================================================================================================= */
BEGIN

	SET @StartTime = GETDATE()

	CREATE TABLE #ProfitabilityActualSource
	(
		ImportBatchId INT NOT NULL,
		SourceName VARCHAR(50),
		BudgetReforecastTypeKey INT NOT NULL,
		SnapshotId INT NOT NULL,
		CalendarKey INT NOT NULL,
		ReforecastKey INT NOT NULL,
		SourceKey INT NOT NULL,
		FunctionalDepartmentKey INT NOT NULL,
		ReimbursableKey INT NOT NULL,
		ActivityTypeKey INT NOT NULL,
		PropertyFundKey INT NOT NULL,
		AllocationRegionKey INT NOT NULL,
		ConsolidationRegionKey INT NOT NULL,
		OriginatingRegionKey INT NOT NULL,
		OverheadKey INT NOT NULL,
		LocalCurrencyKey INT NOT NULL,
		LocalReforecast MONEY NOT NULL,
		ReferenceCode VARCHAR(300) NOT NULL,
		BudgetId INT NOT NULL,
		
		GlobalGLCategorizationHierarchyKey INT NOT NULL,
		USPropertyGLCategorizationHierarchyKey INT NOT NULL,
		USFundGLCategorizationHierarchyKey INT NOT NULL,
		EUPropertyGLCategorizationHierarchyKey INT NOT NULL,
		EUFundGLCategorizationHierarchyKey INT NOT NULL,
		USDevelopmentGLCategorizationHierarchyKey INT NOT NULL,
		EUDevelopmentGLCategorizationHierarchyKey INT NOT NULL,
		ReportingGLCategorizationHierarchyKey INT NOT NULL,
		
		SourceSystemKey INT NOT NULL
	)
	INSERT INTO #ProfitabilityActualSource
	(
		ImportBatchId,
		SourceName,
		BudgetReforecastTypeKey,
		SnapshotId,
		CalendarKey,
		ReforecastKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		PropertyFundKey,
		AllocationRegionKey,
		ConsolidationRegionKey,
		OriginatingRegionKey,
		OverheadKey,
		LocalCurrencyKey,
		LocalReforecast,
		ReferenceCode,
		BudgetId,
		
		GlobalGLCategorizationHierarchyKey,
		USPropertyGLCategorizationHierarchyKey,
		USFundGLCategorizationHierarchyKey,
		EUPropertyGLCategorizationHierarchyKey,
		EUFundGLCategorizationHierarchyKey,
		USDevelopmentGLCategorizationHierarchyKey,
		EUDevelopmentGLCategorizationHierarchyKey,
		ReportingGLCategorizationHierarchyKey,
		
		SourceSystemKey
	)
	SELECT  
		BPA.ImportBatchId AS ImportBatchId,
		'Actuals' as SourceName,
		@ReforecastTypeIsTGBACTKey as BudgetReforecastTypeKey,
		GBSBudget.SnapshotId,
		DATEDIFF(dd, '1900-01-01', LEFT(BPA.Period,4)+'-'+RIGHT(BPA.Period,2)+'-01') AS CalendarKey,
		GBSBudget.ReforecastKey AS ReforecastKey,
		ISNULL(GrSc.SourceKey,  @SourceKeyUnknown) SourceKey,
		COALESCE(FDJobCode.FunctionalDepartmentKey, GrFdm.FunctionalDepartmentKey, @FunctionalDepartmentKeyUnknown) AS FunctionalDepartmentKey,
		ISNULL(GrRi.ReimbursableKey, @ReimbursableKeyUnknown) ReimbursableKey,
		ISNULL(GrAt.ActivityTypeKey, @ActivityTypeKeyUnknown) ActivityTypeKey,
		ISNULL(GrPf.PropertyFundKey, @PropertyFundKeyUnknown) PropertyFundKey,
		ISNULL(GrAr.AllocationRegionKey, @AllocationRegionKeyUnknown) AllocationRegionKey,
		ISNULL(GrCr.AllocationRegionKey, @AllocationRegionKeyUnknown) ConsolidationRegionKey, -- CC16: ConsolidationRegionKey
		ISNULL(GrOr.OriginatingRegionKey, @OriginatingRegionKeyUnknown)OriginatingRegionKey,
		ISNULL(GrOh.OverheadKey, @OverheadKeyUnknown)OverheadKey,
		ISNULL(GrCu.CurrencyKey, @LocalCurrencyKeyUnknown) LocalCurrencyKey,	
		BPA.Amount AS LocalReforecast,
	    (
			'TGB:GBSBudgetId=' + LTRIM(RTRIM(STR(GBSBudget.BudgetId))) +
			'&BudgetProfitabilityActualId=' + LTRIM(RTRIM(STR(bpa.BudgetProfitabilityActualId))) +
			'&IsGBS=' + LTRIM(RTRIM(STR(BPA.IsGBS))) +
			'&SnapshotId=' + LTRIM(RTRIM(STR(GBSBudget.SnapshotId)))
		) AS ReferenceCode, -- ReferenceCode
		GBSBudget.BudgetId,
		COALESCE(GlobalMapping.GLCategorizationHierarchyKey, UnknownMapping.GLCategorizationHierarchyKey, @UnknownGlobalGLCategorizationKey), -- GlobalGLCategorizationHierarchyKey
			/*
				For local categorizations, if it is an overhead transaction, it maps to the #LocalOverheadGLCategorizationMapping table. If it
				is a payroll budget record, it maps to the #LocalPayrollGLCategorizationMapping table.
				THe Global Account Code is used to determine if a transaction is an overhead transaction or not. It will have a Global Account
				code if it's an overhead transaction. If it is a payroll transaction, it will have a placeholder('N/A') as the Global Account.
			*/
		COALESCE(LocalPayrollMapping.USPropertyGLCategorizationHierarchyKey, LocalOverheadMapping.USPropertyGLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey), -- USPropertyGLCategorizationHierarchyKey
		COALESCE(LocalPayrollMapping.USFundGLCategorizationHierarchyKey, LocalOverheadMapping.USFundGLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey), -- USFundGLCategorizationHierarchyKey
		COALESCE(LocalPayrollMapping.EUPropertyGLCategorizationHierarchyKey, LocalOverheadMapping.EUPropertyGLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey), -- EUPropertyGLCategorizationHierarchyKey
		COALESCE(LocalPayrollMapping.EUFundGLCategorizationHierarchyKey, LocalOverheadMapping.EUFundGLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey), -- EUFundGLCategorizationHierarchyKey
		COALESCE(LocalPayrollMapping.USDevelopmentGLCategorizationHierarchyKey, LocalOverheadMapping.USDevelopmentGLCategorizationHierarchyKey, @UnknownUSDevelopmentGLCategorizationKey), -- USDevelopmentGLCategorizationHierarchyKey
		COALESCE(LocalPayrollMapping.EUDevelopmentGLCategorizationHierarchyKey, LocalOverheadMapping.EUDevelopmentGLCategorizationHierarchyKey, @GLCategorizationHierarchyKeyUnknown), -- EUDevelopmentGLCategorizationHierarchyKey
		/*
			The purpose of the ReportingGLCategorizationHierarchy field is to define the default GL Categorization that will be used
			when a local report is generated.
		*/
		CASE
			WHEN
				ReportingGC.GLCategorizationId IS NOT NULL
			THEN
				CASE
					WHEN
						ReportingGC.Name = 'US Property'
					THEN
						COALESCE(LocalPayrollMapping.USPropertyGLCategorizationHierarchyKey, LocalOverheadMapping.USPropertyGLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey)
					WHEN
						ReportingGC.Name = 'US Fund' 
					THEN
						COALESCE(LocalPayrollMapping.USFundGLCategorizationHierarchyKey, LocalOverheadMapping.USFundGLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey)
					WHEN
						ReportingGC.Name = 'EU Property' 
					THEN
						COALESCE(LocalPayrollMapping.EUPropertyGLCategorizationHierarchyKey, LocalOverheadMapping.EUPropertyGLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey)
					WHEN
						ReportingGC.Name = 'EU Fund' 
					THEN
						COALESCE(LocalPayrollMapping.EUFundGLCategorizationHierarchyKey, LocalOverheadMapping.EUFundGLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey)
					WHEN
						ReportingGC.Name = 'US Development' 
					THEN
						COALESCE(LocalPayrollMapping.USDevelopmentGLCategorizationHierarchyKey, LocalOverheadMapping.USDevelopmentGLCategorizationHierarchyKey, @UnknownUSDevelopmentGLCategorizationKey)
					WHEN
						ReportingGC.Name = 'EU Development' 
					THEN
						COALESCE(LocalPayrollMapping.EUDevelopmentGLCategorizationHierarchyKey, LocalOverheadMapping.EUDevelopmentGLCategorizationHierarchyKey, @GLCategorizationHierarchyKeyUnknown)
					WHEN
						ReportingGC.Name = 'Global'
					THEN
						COALESCE(GlobalMapping.GLCategorizationHierarchyKey, UnknownMapping.GLCategorizationHierarchyKey, @UnknownGlobalGLCategorizationKey)
					ELSE
						@GLCategorizationHierarchyKeyUnknown
				END
			ELSE
				@GLCategorizationHierarchyKeyUnknown
		END, --  ReportingGLCategorizationHierarchyKey
		
		SSystem.SourceSystemKey
	FROM
		GBS.BudgetProfitabilityActual BPA

		INNER JOIN  #GBSBudgets GBSBudget ON 
			BPA.BudgetId = GBSBudget.BudgetId AND 
			GBSBudget.MustImportAllActualsIntoWarehouse = 1 AND
			BPA.ImportBatchId = GBSBudget.ImportBatchId 
		
		LEFT OUTER JOIN Gdm.[Snapshot] SShot ON
			GBSBudget.SnapshotId = SShot.SnapshotId

		LEFT OUTER JOIN GBS.OverheadType OHT ON
			BPA.OverheadTypeId = OHT.OverheadTypeId  AND
			GBSBudget.ImportBatchId = OHT.ImportBatchId  

		LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON 
			BPA.SourceCode = GrSc.SourceCode 

		LEFT OUTER JOIN #MRIServerSource MSS ON
			BPA.SourceCode = MSS.SourceCode

		LEFT OUTER JOIN GrReporting.dbo.SourceSystem SSystem ON
			SSystem.SourceSystemName = 'GBS' AND
			SSystem.SourceTableName = 'BudgetProfitabilityActual'
		
		-- FunctionalDepartmentCode
		LEFT OUTER JOIN #FunctionalDepartment FD ON
			BPA.FunctionalDepartmentId = FD.FunctionalDepartmentId

		-- Detail/Sub Level (Job Code) -- job code is stored as SubFunctionalDepartment in GrReporting.dbo.FunctionalDepartment
		LEFT OUTER JOIN
		(
			SELECT
				FunctionalDepartmentKey,
				FunctionalDepartmentCode,
				FunctionalDepartmentName,
				SubFunctionalDepartmentCode,
				SubFunctionalDepartmentName,
				StartDate,
				EndDate
			FROM
				GrReporting.dbo.FunctionalDepartment
			WHERE
				FunctionalDepartmentCode <> SubFunctionalDepartmentCode
			
		) FDJobCode ON
			FD.GlobalCode = FDJobCode.SubFunctionalDepartmentCode AND
			FD.GlobalCode = FDJobCode.FunctionalDepartmentCode AND
			SShot.LastSyncDate BETWEEN FDJobCode.StartDate AND FDJobCode.EndDate

		-- Parent Level
		LEFT OUTER JOIN
		(
			SELECT
				FunctionalDepartmentKey,
				FunctionalDepartmentCode,
				FunctionalDepartmentName,
				SubFunctionalDepartmentCode,
				SubFunctionalDepartmentName,
				StartDate,
				EndDate
			FROM
				GrReporting.dbo.FunctionalDepartment
			WHERE
				SubFunctionalDepartmentCode = FunctionalDepartmentCode
		) GrFdm ON
			FD.GlobalCode = GrFdm.FunctionalDepartmentCode AND
			SShot.LastSyncDate BETWEEN GrFdm.StartDate AND GrFdm.EndDate

		LEFT OUTER JOIN  Gdm.SnapshotPropertyFund PF ON
			BPA.ReportingEntityPropertyFundId = PF.PropertyFundId AND
			GBSBudget.SnapshotId = PF.SnapshotId AND
			PF.IsActive = 1
			
		LEFT OUTER JOIN Gdm.SnapshotAllocationSubRegion ASR ON
			PF.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId AND 
			GBSBudget.SnapshotId = ASR.SnapshotId AND
			ASR.IsActive = 1

		LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
			ASR.AllocationSubRegionGlobalRegionId = GrAr.GlobalRegionId AND
			GBSBudget.SnapshotId = GrAr.SnapshotId

		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD ON
			LTRIM(RTRIM(BPA.PropertyFundCode)) = LTRIM(RTRIM(CRCD.CorporateDepartmentCode)) AND
			BPA.SourceCode = CRCD.SourceCode AND
			GBSBudget.SnapshotId = CRCD.SnapshotId
			
		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionPropertyEntity CRPE ON
			LTRIM(RTRIM(BPA.PropertyFundCode)) = LTRIM(RTRIM(CRPE.PropertyEntityCode)) AND
			MSS.MappingSourceCode = CRPE.SourceCode AND
			GBSBudget.SnapshotId = CRPE.SnapshotId

		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion CSR ON
			ISNULL(CRCD.GlobalRegionId, CRPE.GlobalRegionId) = CSR.GlobalRegionId AND
			GBSBudget.SnapshotId = CSR.SnapshotId AND
			CSR.IsConsolidationRegion = 1 AND
			CSR.IsActive = 1

		LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrCr ON -- CC16: ConsolidationRegions
			CSR.GlobalRegionId = GrCr.GlobalRegionId AND
			GBSBudget.SnapshotId = GrCr.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON	
			PF.PropertyFundId = GrPf.PropertyFundId  AND
			PF.SnapshotId = Grpf.SnapshotId       

		LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
			BPA.ActivityTypeId = GrAt.ActivityTypeId AND
			GBSBudget.SnapshotId = GrAt.SnapshotId 		

		LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
			 GrRi.ReimbursableCode = CASE WHEN BPA.IsTsCost = 0 THEN 'YES' ELSE 'NO' END

		LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON 
			BPA.OriginatingSubRegionGlobalRegionId = GrOr.GlobalRegionId and
			GBSBudget.SnapshotId = GrOr.SnapshotId  

		LEFT OUTER JOIN GrReporting.dbo.Overhead GrOh ON
			ISNULL(OHT.Code, 'N/A') = GrOh.OverheadCode

		LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
			BPA.CurrencyCode = GrCu.CurrencyCode	

		LEFT OUTER JOIN Gdm.SnapshotGLGlobalAccountCategorization GGAC ON
			GBSBudget.SnapshotId = GGAC.SnapshotId AND
			BPA.GLGlobalAccountId  = GGAC.GLGlobalAccountId AND
			GGAC.GLCategorizationId = 233 -- Limit to the Global Categorization

		LEFT OUTER JOIN Gdm.SnapshotGLMinorCategory MinC ON
			MinC.GLMinorCategoryId = CASE WHEN BPA.IsDirectCost = 1 THEN GGAC.DirectGLMinorCategoryId ELSE GGAC.IndirectGLMinorCategoryId END AND
			GBSBudget.SnapshotId = MinC.SnapshotId AND
			MinC.IsActive = 1

		LEFT OUTER JOIN Gdm.SnapshotGLMajorCategory MajC ON
			MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
			GBSBudget.SnapshotId = MajC.SnapshotId AND
			MajC.IsActive = 1

		LEFT OUTER JOIN Gdm.SnapshotGLFinancialCategory FinC ON
			MajC.GLFinancialCategoryId = FinC.GLFinancialCategoryId AND
			MajC.SnapshotId = FinC.SnapshotId  

		LEFT OUTER JOIN Gdm.SnapshotGLCategorization GC ON
			FinC.GLCategorizationId = GC.GLCategorizationId AND
			FinC.SnapshotId = GC.SnapshotId 

		LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy GlobalMapping ON
			GC.SnapshotId = GlobalMapping.SnapshotId AND
			GlobalMapping.GLCategorizationHierarchyCode = 
				CONVERT(VARCHAR(32),
					LTRIM(STR(GC.GLCategorizationTypeId, 10, 0)) + ':' + 
					LTRIM(STR(GC.GLCategorizationId, 10, 0)) + ':' +
					LTRIM(STR(FinC.GLFinancialCategoryId, 10, 0)) + ':' +
					LTRIM(STR(MajC.GLMajorCategoryId, 10, 0)) + ':' + 
					LTRIM(STR(MinC.GLMinorCategoryId, 10, 0)) + ':' +
					LTRIM(STR(ISNULL(BPA.GLGlobalAccountId, 0), 10, 0)))

		LEFT OUTER JOIN Gdm.SnapshotGLMinorCategoryPayrollType MCPT ON
			MinC.GLMinorCategoryId = MCPT.GLMinorCategoryId AND
			MinC.SnapshotId = MCPT.SnapshotId
						
		LEFT OUTER JOIN  #LocalPayrollGLCategorizationMapping LocalPayrollMapping ON
			BPA.FunctionalDepartmentId = LocalPayrollMapping.FunctionalDepartmentId AND
			BPA.ActivityTypeId = LocalPayrollMapping.ActivityTypeId AND
			MCPT.PayrollTypeId = LocalPayrollMapping.PayrollTypeId AND
			MinC.GLMinorCategoryId = LocalPayrollMapping.GlobalGLMinorCategoryId AND
			GBSBudget.SnapshotId = LocalPayrollMapping.SnapshotId AND
			ISNULL(OHT.Code, '') <> 'ALLOC'

		LEFT OUTER JOIN #LocalOverheadGLCategorizationMapping LocalOverheadMapping ON
			BPA.FunctionalDepartmentId = LocalOverheadMapping.FunctionalDepartmentId AND
			BPA.ActivityTypeId = LocalOverheadMapping.ActivityTypeId AND
			GBSBudget.SnapshotId = LocalOverheadMapping.SnapshotId AND
			OHT.Code = 'ALLOC'

		LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy UnknownMapping ON
			GBSBudget.SnapshotId = UnknownMapping.SnapshotId AND
			UnknownMapping.GLCategorizationHierarchyCode = '1:233:-1:-1:-1:' +  LTRIM(STR(ISNULL(BPA.GLGlobalAccountId, 0), 10, 0))

		LEFT OUTER JOIN Gdm.SnapshotReportingCategorization RC ON
			GBSBudget.SnapshotId = RC.SnapshotId AND
			PF.AllocationSubRegionGlobalRegionId = RC.AllocationSubRegionGlobalRegionId AND
			PF.EntityTypeId = RC.EntityTypeId 

		LEFT OUTER JOIN Gdm.SnapshotGLCategorization ReportingGC ON
			RC.SnapshotId = ReportingGC.SnapshotId AND
			RC.GLCategorizationId = ReportingGC.GLCategorizationId AND
			ReportingGC.IsActive = 1
	WHERE 
		BPA.IsDeleted = 0 AND
		BPA.Period < GBSBudget.FirstProjectedPeriod AND
		MajC.Name in ('Salaries/Taxes/Benefits', 'General Overhead') AND -- Only want Actuals for Payroll and General Overhead transactions
		(OHT.Code IS NULL OR OHT.Code = 'ALLOC')

	PRINT 'Completed inserting Actuals into #ProfitabilityActualSource:'+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	INSERT INTO #ProfitabilityReforecast 
	(
		ImportBatchId,
		SourceName,
		BudgetReforecastTypeKey,
		SnapshotId,
		CalendarKey,
		ReforecastKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		PropertyFundKey,
		AllocationRegionKey,
		ConsolidationRegionKey,
		OriginatingRegionKey,
		OverheadKey,
		LocalCurrencyKey,
		LocalReforecast,
		ReferenceCode,
		BudgetId,
		
		GlobalGLCategorizationHierarchyKey,
		USPropertyGLCategorizationHierarchyKey,
		USFundGLCategorizationHierarchyKey,
		EUPropertyGLCategorizationHierarchyKey,
		EUFundGLCategorizationHierarchyKey,
		USDevelopmentGLCategorizationHierarchyKey,
		EUDevelopmentGLCategorizationHierarchyKey,
		ReportingGLCategorizationHierarchyKey,
		
		SourceSystemKey
	)
	SELECT
		ImportBatchId,
		SourceName,
		BudgetReforecastTypeKey,
		SnapshotId,
		CalendarKey,
		ReforecastKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		PropertyFundKey,
		AllocationRegionKey,
		ConsolidationRegionKey,
		OriginatingRegionKey,
		OverheadKey,
		LocalCurrencyKey,
		LocalReforecast,
		ReferenceCode,
		BudgetId,
		
		GlobalGLCategorizationHierarchyKey,
		USPropertyGLCategorizationHierarchyKey,
		USFundGLCategorizationHierarchyKey,
		EUPropertyGLCategorizationHierarchyKey,
		EUFundGLCategorizationHierarchyKey,
		USDevelopmentGLCategorizationHierarchyKey,
		EUDevelopmentGLCategorizationHierarchyKey,
		ReportingGLCategorizationHierarchyKey,
		
		SourceSystemKey
	FROM
		#ProfitabilityActualSource

	PRINT 'Completed inserting Actuals portions into #ProfitabilityReforecast:'+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProfitabilityReforecast (ReferenceCode)
	CREATE INDEX IX_CalendarKey ON #ProfitabilityReforecast (CalendarKey)

	PRINT 'Completed creating indexes on #OriginatingRegionMapping'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	-- Remove existing data for modified budget projects
	-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	SET @StartTime = GETDATE()

	CREATE TABLE #BudgetsToImport
	(
		BudgetId INT NOT NULL
	)

	INSERT INTO #BudgetsToImport
	(
		BudgetId
	)
	SELECT DISTINCT 
		BudgetId
	FROM
		#NewBudgets
	UNION ALL
	SELECT DISTINCT 
		BudgetId
	FROM
		#GBSBudgets	

END

/* ================================================================================================================================================
	10.	Insert records with unknowns into the ProfitabilityBudgetUnknowns table.
   ============================================================================================================================================= */
BEGIN

	--- Smoke All OLD TAPAS Unknowns as were about to insert new ones (Reforecast Budget + Reforecast Actuals from [dbo].[ProfitabilityBudgetUnknowns])
	SET @StartTime = GETDATE()

	DELETE 
		PRU
	FROM
		dbo.ProfitabilityReforecastUnknowns PRU
	WHERE
	  PRU.BudgetReforecastTypeKey IN (@ReforecastTypeIsTGBBUDKey, @ReforecastTypeIsTGBACTKey)

	PRINT ('Rows Deleted that was OLD from ProfitabilitReforecastUnknowns: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	-------------

	SET @StartTime = GETDATE()

	INSERT INTO dbo.ProfitabilityReforecastUnknowns
	(
		ImportBatchId,
		CalendarKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		PropertyFundKey,
		AllocationRegionKey,
		ConsolidationRegionKey,
		OriginatingRegionKey,
		LocalCurrencyKey,
		LocalReforecast,
		ReferenceCode,
			
		GlobalGLCategorizationHierarchyKey,
		USPropertyGLCategorizationHierarchyKey,
		USFundGLCategorizationHierarchyKey,
		EUPropertyGLCategorizationHierarchyKey,
		EUFundGLCategorizationHierarchyKey,
		USDevelopmentGLCategorizationHierarchyKey,
		EUDevelopmentGLCategorizationHierarchyKey,
		ReportingGLCategorizationHierarchyKey,
		BudgetId,
		OverheadKey,
		FeeAdjustmentKey,
		BudgetReforecastTypeKey,
		SnapshotId,
		
		SourceSystemKey
	)
	SELECT
		PR.ImportBatchId,
		PR.CalendarKey,
		PR.SourceKey,
		PR.FunctionalDepartmentKey,
		PR.ReimbursableKey,
		PR.ActivityTypeKey,
		PR.PropertyFundKey,
		PR.AllocationRegionKey,
		PR.ConsolidationRegionKey,
		PR.OriginatingRegionKey,
		PR.LocalCurrencyKey,
		PR.LocalReforecast,
		PR.ReferenceCode,
		PR.GlobalGLCategorizationHierarchyKey,
		PR.USPropertyGLCategorizationHierarchyKey,
		PR.USFundGLCategorizationHierarchyKey,
		PR.EUPropertyGLCategorizationHierarchyKey,
		PR.EUFundGLCategorizationHierarchyKey,
		PR.USDevelopmentGLCategorizationHierarchyKey,
		PR.EUDevelopmentGLCategorizationHierarchyKey,
		PR.ReportingGLCategorizationHierarchyKey,
		PR.BudgetId,
		PR.OverheadKey,
		@NormalFeeAdjustmentKey,
		BudgetReforecastTypeKey,
		AB.SnapshotId,
		
		PR.SourceSystemKey
	FROM 
		#ProfitabilityReforecast PR

		INNER JOIN #AllBudgets AB ON
			PR.BudgetId = AB.BudgetId AND
			PR.SnapshotId = AB.SnapshotId
	WHERE
		PR.BudgetReforecastTypeKey IN (@ReforecastTypeIsTGBBUDKey, @ReforecastTypeIsTGBACTKey) AND
		(
			@FunctionalDepartmentKeyUnknown = PR.FunctionalDepartmentKey OR
			@ReimbursableKeyUnknown = PR.ReimbursableKey OR
			@ActivityTypeKeyUnknown = PR.ActivityTypeKey OR
			@PropertyFundKeyUnknown = PR.PropertyFundKey OR
			@AllocationRegionKeyUnknown = PR.AllocationRegionKey OR
			@OriginatingRegionKeyUnknown = PR.OriginatingRegionKey OR
			@LocalCurrencyKeyUnknown = PR.LocalCurrencyKey
		)

	PRINT ('Rows inserted into ProfitabilitReforecastUnknowns: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

		/*
			BUILD Unknown Budgets - Get all the budgets for Budget rows that have unknowns
		*/
		
	SET @StartTime = GETDATE()

	SELECT DISTINCT
		B.SnapshotId, 
		B.BudgetId,
		B.ImportKey,
		PRU.BudgetReforecastTypeKey	
	INTO
	   #BudgetsWithUnknownBudgets
	FROM 
	   dbo.ProfitabilityReforecastUnknowns  PRU

	   INNER JOIN #AllBudgets B ON
			B.SnapshotId = PRU.SnapshotId AND
			B.BudgetId = PRU.BudgetId 
	WHERE
	  PRU.BudgetReforecastTypeKey = @ReforecastTypeIsTGBBudKey

	DECLARE @RowsToDeleteFromPRBudgets INT = @@rowcount

	PRINT ('Rows inserted into #BudgetsWithUnknownBudgets: ' + CONVERT(VARCHAR(10),@RowsToDeleteFromPRBudgets))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

		/*
			BUILD Unknown Actuals - Get all the budgets for Budget rows that have unknowns
		*/
		
	SELECT DISTINCT
		B.SnapshotId, 
		B.BudgetId,
		B.ImportKey,
		PRU.BudgetReforecastTypeKey
	INTO
	   #BudgetsWithUnknownActuals
	FROM
	   dbo.ProfitabilityReforecastUnknowns  PRU

	   INNER JOIN #AllBudgets B ON
			B.SnapshotId = PRU.SnapshotId AND
			B.BudgetId = PRU.BudgetId 
	WHERE
	  PRU.BudgetReforecastTypeKey = @ReforecastTypeIsTGBActKey

	DECLARE @RowsToDeleteFromPRActuals INT = @@rowcount

	PRINT ('Rows inserted into #BudgetsWithUnknownActuals: ' + CONVERT(VARCHAR(10),@RowsToDeleteFromPRActuals))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	/*
		BUILD ALL Unknown Budgets - Now merge them into one unique budget set and these are all budgets that need deleting
	*/

	SET @StartTime = GETDATE()

	SELECT 
	   BUA.SnapshotId, 
	   BUA.BudgetId,
	   BUA.ImportKey
	INTO 
		#AllUnknownBudgets
	FROM 
		#BudgetsWithUnknownActuals BUA

		INNER JOIN #BudgetsWithUnknownBudgets BUB ON
			BUB.BudgetId = BUA.BudgetId AND
			BUB.SnapshotId = BUA.SnapshotId AND
			BUB.ImportKey = BUA.ImportKey		
    
	PRINT ('Rows INSERTED INTO #AllUnknownBudgets that have Unknowns: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	INSERT INTO @ImportErrorTable (Error) SELECT 'Unknowns'
	
	IF (@RowsToDeleteFromPRBudgets > 0)
	BEGIN
	    INSERT INTO @ImportErrorTable (Error) SELECT 'Unknown Budgets'
	END
	IF (@RowsToDeleteFromPRActuals > 0)
	BEGIN
	    INSERT INTO @ImportErrorTable (Error) SELECT 'Unknown Actuals'
	END	

END

/* ===============================================================================================================================================
	11.	Insert records into the GrReporting.dbo.ProfitabilityReforecast fact table.
   ============================================================================================================================================= */
BEGIN

	SET @StartTime = GETDATE()

	CREATE TABLE #SummaryOfChanges
	(
		Change VARCHAR(20)
	)

	MERGE
		GrReporting.dbo.ProfitabilityReforecast FACT
	USING
		#ProfitabilityReforecast AS SRC ON
			FACT.ReferenceCode = SRC.ReferenceCode
	WHEN
		MATCHED AND
		(
			FACT.CalendarKey <> SRC.CalendarKey OR
			FACT.SourceKey <> SRC.SourceKey OR
			FACT.FunctionalDepartmentKey <> SRC.FunctionalDepartmentKey OR
			FACT.ReimbursableKey <> SRC.ReimbursableKey OR
			FACT.ActivityTypeKey <> SRC.ActivityTypeKey OR
			FACT.PropertyFundKey <> SRC.PropertyFundKey OR
			FACT.AllocationRegionKey <> SRC.AllocationRegionKey OR
			FACT.OriginatingRegionKey <> SRC.OriginatingRegionKey OR
			FACT.LocalCurrencyKey <> SRC.LocalCurrencyKey OR
			FACT.LocalReforecast <> SRC.LocalReforecast OR
			FACT.OverheadKey <> SRC.OverheadKey OR
			FACT.FeeAdjustmentKey <> @FeeAdjustmentKey OR
			FACT.SnapshotId <> SRC.SnapshotId OR
			FACT.ReforecastKey <> SRC.ReforecastKey OR
			FACT.ConsolidationRegionKey <> SRC.ConsolidationRegionKey OR
			ISNULL(FACT.GlobalGLCategorizationHierarchyKey, '') <> SRC.GlobalGLCategorizationHierarchyKey OR
			ISNULL(FACT.EUDevelopmentGLCategorizationHierarchyKey, '') <> SRC.EUDevelopmentGLCategorizationHierarchyKey OR
			ISNULL(FACT.EUPropertyGLCategorizationHierarchyKey, '') <> SRC.EUPropertyGLCategorizationHierarchyKey OR
			ISNULL(FACT.EUFundGLCategorizationHierarchyKey, '') <> SRC.EUFundGLCategorizationHierarchyKey OR
			ISNULL(FACT.USDevelopmentGLCategorizationHierarchyKey, '') <> SRC.USDevelopmentGLCategorizationHierarchyKey OR
			ISNULL(FACT.USPropertyGLCategorizationHierarchyKey, '') <> SRC.USPropertyGLCategorizationHierarchyKey OR
			ISNULL(FACT.USFundGLCategorizationHierarchyKey, '') <> SRC.USFundGLCategorizationHierarchyKey OR
			ISNULL(FACT.ReportingGLCategorizationHierarchyKey, '') <> SRC.ReportingGLCategorizationHierarchyKey OR
			
			ISNULL(FACT.SourceSystemKey, '') <> SRC.SourceSystemKey
		)
	THEN
		UPDATE
		SET
			FACT.CalendarKey = SRC.CalendarKey,
			FACT.SourceKey = SRC.SourceKey,
			FACT.FunctionalDepartmentKey = SRC.FunctionalDepartmentKey,
			FACT.ReimbursableKey = SRC.ReimbursableKey,
			FACT.ActivityTypeKey = SRC.ActivityTypeKey,
			FACT.PropertyFundKey = SRC.PropertyFundKey,
			FACT.AllocationRegionKey = SRC.AllocationRegionKey,
			FACT.OriginatingRegionKey = SRC.OriginatingRegionKey,
			FACT.LocalCurrencyKey = SRC.LocalCurrencyKey,
			FACT.LocalReforecast = SRC.LocalReforecast,
			FACT.OverheadKey = SRC.OverheadKey,
			FACT.FeeAdjustmentKey = @FeeAdjustmentKey,
			FACT.SnapshotId = SRC.SnapshotId,
			FACT.ReforecastKey = SRC.ReforecastKey,
			FACT.ConsolidationRegionKey = SRC.ConsolidationRegionKey,
			FACT.GlobalGLCategorizationHierarchyKey = SRC.GlobalGLCategorizationHierarchyKey,
			FACT.EUDevelopmentGLCategorizationHierarchyKey = SRC.EUDevelopmentGLCategorizationHierarchyKey,
			FACT.EUPropertyGLCategorizationHierarchyKey = SRC.EUPropertyGLCategorizationHierarchyKey,
			FACT.EUFundGLCategorizationHierarchyKey = SRC.EUFundGLCategorizationHierarchyKey,
			FACT.USDevelopmentGLCategorizationHierarchyKey = SRC.USDevelopmentGLCategorizationHierarchyKey,
			FACT.USPropertyGLCategorizationHierarchyKey = SRC.USPropertyGLCategorizationHierarchyKey,
			FACT.USFundGLCategorizationHierarchyKey = SRC.USFundGLCategorizationHierarchyKey,
			FACT.ReportingGLCategorizationHierarchyKey = SRC.ReportingGLCategorizationHierarchyKey,
			FACT.UpdatedDate = @StartTime,
			FACT.SourceSystemKey = SRC.SourceSystemKey
	WHEN
		NOT MATCHED BY TARGET
	THEN
		INSERT
		(
			SnapshotId,
			BudgetReforecastTypeKey,
			ReforecastKey,
			CalendarKey,
			SourceKey,
			FunctionalDepartmentKey,
			ReimbursableKey,
			ActivityTypeKey,
			PropertyFundKey,
			AllocationRegionKey,
			ConsolidationRegionKey,
			OriginatingRegionKey,
			OverheadKey,
			FeeAdjustmentKey,
			LocalCurrencyKey,
			LocalReforecast,
			ReferenceCode,
			BudgetId,
			
			GlobalGLCategorizationHierarchyKey,
			USPropertyGLCategorizationHierarchyKey,
			USFundGLCategorizationHierarchyKey,
			EUPropertyGLCategorizationHierarchyKey,
			EUFundGLCategorizationHierarchyKey,
			USDevelopmentGLCategorizationHierarchyKey,
			EUDevelopmentGLCategorizationHierarchyKey,
			ReportingGLCategorizationHierarchyKey,
			InsertedDate,
			UpdatedDate,
			
			SourceSystemKey
		)
		VALUES
		(
			SRC.SnapshotId,
			SRC.BudgetReforecastTypeKey,
			SRC.ReforecastKey,
			SRC.CalendarKey,
			SRC.SourceKey,
			SRC.FunctionalDepartmentKey,
			SRC.ReimbursableKey,
			SRC.ActivityTypeKey,
			SRC.PropertyFundKey,
			SRC.AllocationRegionKey,
			SRC.ConsolidationRegionKey,
			SRC.OriginatingRegionKey,
			SRC.OverheadKey,
			@FeeAdjustmentKey,
			SRC.LocalCurrencyKey,
			SRC.LocalReforecast,
			SRC.ReferenceCode,
			SRC.BudgetId,
			
			SRC.GlobalGLCategorizationHierarchyKey,
			SRC.USPropertyGLCategorizationHierarchyKey,
			SRC.USFundGLCategorizationHierarchyKey,
			SRC.EUPropertyGLCategorizationHierarchyKey,
			SRC.EUFundGLCategorizationHierarchyKey,
			SRC.USDevelopmentGLCategorizationHierarchyKey,
			SRC.EUDevelopmentGLCategorizationHierarchyKey,
			SRC.ReportingGLCategorizationHierarchyKey,
			@StartTime,
			@StartTime,
			
			SRC.SourceSystemKey
		)
	WHEN
		NOT MATCHED BY SOURCE AND
		FACT.BudgetId IN (SELECT BudgetId FROM #AllBudgets) AND
		FACT.BudgetReforecastTypeKey IN (@ReforecastTypeIsTGBBUDKey, @ReforecastTypeIsTGBACTKey) THEN
		DELETE
	OUTPUT
			$action
		INTO
			#SummaryOfChanges;

	CREATE NONCLUSTERED INDEX UX_SummaryOfChanges_Change ON #SummaryOfChanges(Change)

	DECLARE @InsertedRows INT = (SELECT COUNT(*) FROM #SummaryOfChanges WHERE Change = 'INSERT')
	DECLARE @UpdatedRows INT = (SELECT COUNT(*) FROM #SummaryOfChanges WHERE Change = 'UPDATE')
	DECLARE @DeletedRows INT = (SELECT COUNT(*) FROM #SummaryOfChanges WHERE Change = 'DELETE')

	PRINT 'Rows added to ProfitabilityReforecast: '+ CONVERT(char(10), @InsertedRows)
	PRINT 'Rows updated in ProfitabilityReforecast: '+ CONVERT(char(10),@UpdatedRows)
	PRINT 'Rows deleted from ProfitabilityReforecast: '+ CONVERT(char(10),@DeletedRows)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END

/* ===============================================================================================================================================
   12. Mark budgets as being successfully processed into the warehouse
   ============================================================================================================================================= */
BEGIN

	DECLARE @ImportErrorText VARCHAR(500)
	SELECT @ImportErrorText = COALESCE(@ImportErrorText + ', ', '') + Error FROM @ImportErrorTable

	UPDATE
		BTP
	SET
		--- Note Slight reverse logic from originally, original it looked if there are anything left in the temp table, now it looks:
		--- IS THERE ANYTHING THAT WAS UNKNOWN for Budgets and Actuals Seperately
		BTP.ReforecastBudgetsProcessedIntoWarehouse = CASE WHEN BWUB.BudgetId IS NULL THEN 1 ELSE 0 END, -- 0 if import fails, 1 if import succeeds
		BTP.ReforecastActualsProcessedIntoWarehouse = CASE WHEN BWUA.BudgetId IS NULL THEN 1 ELSE 0 END, -- 0 if import fails, 1 if import succeeds
		ReasonForFailure = @ImportErrorText,
		BTP.DateBudgetProcessedIntoWarehouse = GETDATE() -- date that the buget import either failed or succeeded (depending on 0 or 1 above)
	FROM
		dbo.BudgetsToProcess BTP

		INNER JOIN #BudgetsToProcess BTPT ON
			BTP.BudgetsToProcessId = BTPT.BudgetsToProcessId	

		LEFT OUTER JOIN #BudgetsWithUnknownBudgets BWUB ON
			BTP.BudgetId = BWUB.BudgetId 

		LEFT OUTER JOIN #BudgetsWithUnknownActuals BWUA ON
			BTP.BudgetId = BWUA.BudgetId 

	PRINT ('Rows updated from dbo.BudgetsToProcess: ' + CONVERT(VARCHAR(10),@@rowcount))

END

/* ===============================================================================================================================================
	13.	Clean up
   ============================================================================================================================================= */
BEGIN

	SET @StartTime = GETDATE()

	IF 	OBJECT_ID('tempdb..#BudgetsToProcess') IS NOT NULL
		DROP TABLE #BudgetsToProcess 

	IF 	OBJECT_ID('tempdb..#LastImportedGBSBudgets') IS NOT NULL
		DROP TABLE #LastImportedGBSBudgets
			
	IF 	OBJECT_ID('tempdb..#NewBudgets') IS NOT NULL
		DROP TABLE #NewBudgets

	IF 	OBJECT_ID('tempdb..#SystemSettingRegion') IS NOT NULL
		DROP TABLE #SystemSettingRegion

	IF 	OBJECT_ID('tempdb..#AllBudgets') IS NOT NULL
		DROP TABLE #AllBudgets

	IF 	OBJECT_ID('tempdb..#GBSBudgets') IS NOT NULL
		DROP TABLE #GBSBudgets

	IF 	OBJECT_ID('tempdb..#TaxType') IS NOT NULL
		DROP TABLE #TaxType

	IF 	OBJECT_ID('tempdb..#BudgetProject') IS NOT NULL
		DROP TABLE #BudgetProject

	IF 	OBJECT_ID('tempdb..#Region') IS NOT NULL
		DROP TABLE #Region

	IF 	OBJECT_ID('tempdb..#BudgetEmployee') IS NOT NULL
		DROP TABLE #BudgetEmployee

	IF 	OBJECT_ID('tempdb..#BudgetEmployeeFunctionalDepartment') IS NOT NULL
		DROP TABLE #BudgetEmployeeFunctionalDepartment

	IF 	OBJECT_ID('tempdb..#Location') IS NOT NULL
		DROP TABLE #Location

	IF 	OBJECT_ID('tempdb..#RegionExtended') IS NOT NULL
		DROP TABLE #RegionExtended

	IF 	OBJECT_ID('tempdb..#Project') IS NOT NULL
		DROP TABLE #Project

	IF 	OBJECT_ID('tempdb..#Department') IS NOT NULL
		DROP TABLE #Department

	IF 	OBJECT_ID('tempdb..#PayrollGlobalMappings') IS NOT NULL
		DROP TABLE #PayrollGlobalMappings

	IF 	OBJECT_ID('tempdb..#BudgetEmployeePayrollAllocation') IS NOT NULL
		DROP TABLE #BudgetEmployeePayrollAllocation

	IF 	OBJECT_ID('tempdb..#BudgetEmployeePayrollAllocationDetail') IS NOT NULL
		DROP TABLE #BudgetEmployeePayrollAllocationDetail

	IF 	OBJECT_ID('tempdb..#BudgetTaxType') IS NOT NULL
		DROP TABLE #BudgetTaxType

	IF 	OBJECT_ID('tempdb..#EmployeePayrollAllocationDetail') IS NOT NULL
		DROP TABLE #EmployeePayrollAllocationDetail

	IF 	OBJECT_ID('tempdb..#BudgetOverheadAllocation') IS NOT NULL
		DROP TABLE #BudgetOverheadAllocation

	IF 	OBJECT_ID('tempdb..#BudgetOverheadAllocationDetail') IS NOT NULL
		DROP TABLE #BudgetOverheadAllocationDetail

	IF 	OBJECT_ID('tempdb..#OverheadAllocationDetail') IS NOT NULL
		DROP TABLE #OverheadAllocationDetail

	IF 	OBJECT_ID('tempdb..#EffectiveFunctionalDepartment') IS NOT NULL
		DROP TABLE #EffectiveFunctionalDepartment

	IF 	OBJECT_ID('tempdb..#ProfitabilityPreTaxSource') IS NOT NULL
		DROP TABLE #ProfitabilityPreTaxSource

	IF 	OBJECT_ID('tempdb..#ProfitabilityTaxSource') IS NOT NULL
		DROP TABLE #ProfitabilityTaxSource

	IF 	OBJECT_ID('tempdb..#ProfitabilityOverheadSource') IS NOT NULL
		DROP TABLE #ProfitabilityOverheadSource

	IF 	OBJECT_ID('tempdb..#ProfitabilityPayrollMapping') IS NOT NULL
		DROP TABLE #ProfitabilityPayrollMapping

	IF 	OBJECT_ID('tempdb..#SnapshotGLGlobalAccount') IS NOT NULL
		DROP TABLE #SnapshotGLGlobalAccount

	IF 	OBJECT_ID('tempdb..#GlobalGLCategorizationMapping') IS NOT NULL
		DROP TABLE #GlobalGLCategorizationMapping

	IF 	OBJECT_ID('tempdb..#LocalPayrollGLCategorizationMapping') IS NOT NULL
		DROP TABLE #LocalPayrollGLCategorizationMapping

	IF 	OBJECT_ID('tempdb..#LocalOverheadGLCategorizationMapping') IS NOT NULL
		DROP TABLE #LocalOverheadGLCategorizationMapping

	IF 	OBJECT_ID('tempdb..#ProfitabilityReforecast') IS NOT NULL
		DROP TABLE #ProfitabilityReforecast

	IF 	OBJECT_ID('tempdb..#ProfitabilityActualSource') IS NOT NULL
		DROP TABLE #ProfitabilityActualSource

	IF 	OBJECT_ID('tempdb..#BudgetsToImport') IS NOT NULL
		DROP TABLE #BudgetsToImport

	IF 	OBJECT_ID('tempdb..#BudgetsWithUnknownBudgets') IS NOT NULL
		DROP TABLE #BudgetsWithUnknownBudgets

	IF 	OBJECT_ID('tempdb..#BudgetsWithUnknownActuals') IS NOT NULL
		DROP TABLE #BudgetsWithUnknownActuals

	IF 	OBJECT_ID('tempdb..#AllUnknownBudgets') IS NOT NULL
		DROP TABLE #AllUnknownBudgets

	IF 	OBJECT_ID('tempdb..#AllUnknownBudgets') IS NOT NULL
		DROP TABLE #AllUnknownBudgets
				
	PRINT 'Cleanup Completed:'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
	PRINT 'ALL DONE'

END

END

GO



