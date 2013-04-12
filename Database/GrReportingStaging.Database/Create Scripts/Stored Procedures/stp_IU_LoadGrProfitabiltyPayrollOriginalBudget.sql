USE [GrReportingStaging]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]    Script Date: 11/22/2011 09:38:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]
GO



/***************************************************************************************************************************************
Description
	This stored procedure processes payroll original budget data and uploads it to the
	ProfitabilityBudget table in the data warehouse (GrReporting.dbo.ProfitabilityBudget). 
	The stored procedure works as follows:
	1.	Source budgets that are to be processed from the BudgetsToProcessTable
	2.	Source Budgets from TapasGlobalBudgeting.Budget table
	3.	Source records associated to the Payroll Allocation data (e.g. BudgetProject and BudgetEmployee)
	4.	Source Payroll and Overhead Allocation Data from TAPAS Global Budgeting
	5.	Map the Pre-Tax, Tax and Overhead data to their associated records (step 4) from Tapas Global Budgeting
	6.	Combine tables into #ProfitabilityPayrollMapping table and map to GDM data
	7.	Create Global and Local Categorization mapping table
	8.	Map table to the #ProfitabilityBudget table with the same structure as the GrReporting.dbo.ProfitabilityBudget table
	9.	Insert records with unknowns into the ProfitabilityBudgetUnknowns table.
	10. Insert budget records into the GrReporting.dbo.ProfitabilityBudget table
	11. Mark budgets as being successfully processed into the warehouse
	12. Clean Up
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-06-07		: PKayongo	:	Added ConsolidationRegion mapping as per CC16. Added the field to the 
											data inserted into the warehouse. 	
****************************************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]	
	@DataPriorToDate	DateTime=NULL
AS

SET NOCOUNT ON

PRINT '####'
PRINT 'stp_IU_LoadGrProfitabiltyPayrollOriginalBudget'
PRINT '####'


-- Check whether the stored procedure should be run
DECLARE @StartTime DATETIME
DECLARE @StartTime2 DATETIME
DECLARE @RowCount INT
DECLARE @ImportErrorTable TABLE (
	Error varchar(50)
);

/* ===============================================================================================================================================
  1.	Source budgets that are to be processed from the BudgetsToProcessTable
   ============================================================================================================================================= */
BEGIN
	-- If the budget is not scheduled to be run according to the SSIS configurations, the stored procedure ends.

	IF ((SELECT ConfiguredValue FROM GrReportingStaging.dbo.SSISConfigurations WHERE ConfigurationFilter = 'CanImportTapasBudget') = 0)
	BEGIN
		PRINT ('Import TapasBudget not scheduled in SSISConfigurations')
		RETURN
	END

	CREATE TABLE #BudgetsToProcess
	(
		BudgetsToProcessId INT NOT NULL,
		ImportBatchId INT NOT NULL,
		BudgetReforecastTypeName VARCHAR(50) NOT NULL,
		BudgetId INT NOT NULL,
		BudgetExchangeRateId INT NOT NULL,
		BudgetReportGroupPeriodId INT NOT NULL,
		ImportBudgetFromSourceSystem bit NOT NULL,
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
		BTPC.BudgetsToProcessId,
		BTPC.ImportBatchId,
		BTPC.BudgetReforecastTypeName,
		BTPC.BudgetId,
		BTPC.BudgetExchangeRateId,
		BTPC.BudgetReportGroupPeriodId,
		BTPC.ImportBudgetFromSourceSystem,
		BTPC.IsReforecast,
		BTPC.SnapshotId,
		BTPC.ImportSnapshotFromSourceSystem,
		BTPC.InsertedDate,
		BTPC.MustImportAllActualsIntoWarehouse,
		BTPC.OriginalBudgetProcessedIntoWarehouse,
		BTPC.ReforecastActualsProcessedIntoWarehouse,
		BTPC.ReforecastBudgetsProcessedIntoWarehouse,
		BTPC.ReasonForFailure,
		BTPC.DateBudgetProcessedIntoWarehouse,
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
		BTPC.BudgetYear = CRR.ReforecastEffectiveYear AND
		BTPC.BudgetQuarter = CRR.ReforecastQuarterName
		
		INNER JOIN Grreporting.dbo.Reforecast RR ON
			CRR.ReforecastEffectiveMonth = RR.ReforecastEffectiveMonth  AND
			CRR.ReforecastQuarterName = RR.ReforecastQuarterName  AND
			CRR.ReforecastEffectiveYear = RR.ReforecastEffectiveYear 
	WHERE 
		BTPC.IsReforecast = 0 AND
		BTPC.IsCurrentBatch = 1 AND
		BTPC.BudgetReforecastTypeName = 'TGB Budget/Reforecast'

	PRINT 'Completed inserting records into #BudgetsToProcess: '+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	-- If there are no TAPAS budgets from the BudgetsToProcess table, the stored procedure ends.

	IF NOT EXISTS (SELECT 1 FROM #BudgetsToProcess)
	BEGIN
		PRINT ('*******************************************************')
		PRINT ('	stp_IU_LoadGrProfitabiltyPayrollOriginalBudget is quitting because there are no TAPAS budgets set to be imported.')
		PRINT ('*******************************************************')
		RETURN
	END

	IF (@DataPriorToDate IS NULL)
	BEGIN
		SET @DataPriorToDate = 
			CONVERT
				(
					DATETIME,
					(
						SELECT 
							ConfiguredValue 
						FROM 
							dbo.SSISConfigurations 
						WHERE 
							ConfigurationFilter = 'ActualDataPriorToDate'
					)
				)
	END

END

/* ===============================================================================================================================================
	Setup Variables
   ============================================================================================================================================= */
BEGIN
	
	DECLARE 
		@SourceKey				 INT = (SELECT SourceKey FROM GrReporting.dbo.[Source] WHERE SourceName = 'UNKNOWN'),
		@FunctionalDepartmentKey INT = (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = 'UNKNOWN'),
		@ReimbursableKey		 INT = (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = 'UNKNOWN'),
		@ActivityTypeKey		 INT = (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = 'UNKNOWN'),
		@PropertyFundKey		 INT = (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = 'UNKNOWN'),
		@AllocationRegionKey	 INT = (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = 'UNKNOWN'),
		@OriginatingRegionKey	 INT = (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = 'UNKNOWN'),
		@OverheadKey			 INT = (SELECT OverheadKey From GrReporting.dbo.Overhead Where OverheadCode = 'UNKNOWN'),
		@LocalCurrencyKey		 INT = (SELECT CurrencyKey FROM GrReporting.dbo.Currency WHERE CurrencyCode = 'UNK'),
		@NormalFeeAdjustmentKey	 INT = (SELECT FeeAdjustmentKey FROM GrReporting.dbo.FeeAdjustment WHERE FeeAdjustmentCode = 'NORMAL'),
		@GLCategorizationHierarchyKeyUnknown INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'UNKNOWN' AND SnapshotId = 0)

	DECLARE
		@UnknownUSPropertyGLCategorizationKey		INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'US Property' AND SnapshotId = 0),
		@UnknownUSFundGLCategorizationKey			INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'US Fund' AND SnapshotId = 0),
		@UnknownEUPropertyGLCategorizationKey		INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'EU Property' AND SnapshotId = 0),
		@UnknownEUFundGLCategorizationKey			INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'EU Fund' AND SnapshotId = 0),
		@UnknownUSDevelopmentGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'US Development' AND SnapshotId = 0),
		@UnknownGlobalGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'Global' AND SnapshotId = 0)

		
	DECLARE @BudgetReforecastTypeKey INT = 
		(
			SELECT 
				BudgetReforecastTypeKey 
			FROM 
				GrReporting.dbo.BudgetReforecastType 
			WHERE 
				BudgetReforecastTypeCode = 'TGBBUD'
		)

	DECLARE @FeeAdjustmentKey INT = 
		(
			SELECT 
				FeeAdjustmentKey 
			FROM 
				GrReporting.dbo.FeeAdjustment 
			WHERE 
				FeeAdjustmentCode = 'NORMAL'
		)

END

/* ===============================================================================================================================================
	2. Source Budgets from TapasGlobalBudgeting.Budget table
   ============================================================================================================================================= */
BEGIN

	CREATE TABLE #DistinctImports
	(
		ImportBatchId INT NOT NULL
	)
	INSERT INTO #DistinctImports
	SELECT DISTINCT
		ImportBatchId
	FROM 
		#BudgetsToProcess BTP

	SET @StartTime = GETDATE()

		/*
			The #Budget table stored the budgets that are going to be processed from Tapas Global Budgeting
		*/

	CREATE TABLE #Budget(	
		SnapshotId INT NOT NULL,
		ImportKey INT NOT NULL,
		ImportBatchId INT NOT NULL,
		BudgetId INT NOT NULL,
		RegionId INT NOT NULL,	
		CurrencyCode VARCHAR(3) NOT NULL,
		BudgetReportGroupId INT NOT NULL,
		BudgetReportGroupPeriod	INT NOT NULL,
		GroupStartPeriod INT NOT NULL,
		GroupEndPeriod INT NOT NULL,
		ReforecastKey INT NOT NULL
	)

	INSERT INTO #Budget
	(
		SnapshotId,	
		ImportKey,
		ImportBatchId,
		BudgetId,
		RegionId,	
		CurrencyCode,
		BudgetReportGroupId,
		BudgetReportGroupPeriod,
		GroupStartPeriod,
		GroupEndPeriod,
		ReforecastKey
		
	)
	SELECT 		
		btp.SnapshotId,
		Budget.ImportKey,
		Budget.ImportBatchId,
		Budget.BudgetId,
		Budget.RegionId,
		Budget.CurrencyCode,		
		brg.BudgetReportGroupId,
		brgp.Period AS BudgetReportGroupPeriod,
		brg.StartPeriod AS GroupStartPeriod,
		brg.EndPeriod AS GroupEndPeriod,
		BTP.ReforecastKey
	FROM
		#BudgetsToProcess btp 
		
		INNER JOIN TapasGlobalBudgeting.Budget Budget ON
			btp.BudgetId = Budget.BudgetId AND
			btp.ImportBatchId = Budget.ImportBatchId  

		INNER JOIN TapasGlobalBudgeting.BudgetReportGroupDetail brgd ON
			Budget.BudgetId = brgd.BudgetId AND
			Budget.ImportBatchId = brgd.ImportBatchId
			
		INNER JOIN TapasGlobalBudgeting.BudgetReportGroup brg ON
			brgd.BudgetReportGroupId = brg.BudgetReportGroupId AND
			brgd.ImportBatchId = brg.ImportBatchId	
		
		INNER JOIN Gdm.BudgetReportGroupPeriod brgp ON
			brg.BudgetReportGroupPeriodId = brgp.BudgetReportGroupPeriodId  
			
		INNER JOIN Gdm.BudgetReportGroupPeriodActive(@DataPriorToDate) brgpA ON
			brgp.ImportKey = brgpA.ImportKey

	PRINT 'Completed inserting records into #Budget: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	CREATE CLUSTERED INDEX UX_#Budget_SnapshotId_BudgetId ON #Budget (SnapshotId, BudgetId)
	PRINT 'Completed creating indexes on #Budget'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

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
		ImportBatchId INT NOT NULL,
		BudgetProjectId INT NOT NULL,
		BudgetId INT NOT NULL,
		ProjectId INT NULL,
		PropertyFundId INT NOT NULL,
		ActivityTypeId INT NOT NULL,
		CorporateDepartmentCode VARCHAR(6) NULL,
		CorporateSourceCode VARCHAR(2) NULL,
		IsTsCost BIT NOT NULL,
		CanAllocateOverheads BIT NOT NULL,
		AllocateOverheadsProjectId INT NULL
	)

	INSERT INTO #BudgetProject
	(
		ImportBatchId,
		BudgetProjectId,
		BudgetId,
		ProjectId,
		PropertyFundId,
		ActivityTypeId,
		CorporateDepartmentCode,
		CorporateSourceCode,
		IsTsCost,
		CanAllocateOverheads,
		AllocateOverheadsProjectId
	)
	SELECT 
		BudgetProject.ImportBatchId,
		BudgetProject.BudgetProjectId,
		BudgetProject.BudgetId,
		BudgetProject.ProjectId,
		BudgetProject.PropertyFundId,
		BudgetProject.ActivityTypeId,
		BudgetProject.CorporateDepartmentCode,
		BudgetProject.CorporateSourceCode,
		BudgetProject.IsTsCost,
		BudgetProject.CanAllocateOverheads,
		BudgetProject.AllocateOverheadsProjectId
	FROM 
		TapasGlobalBudgeting.BudgetProject BudgetProject
			
		-- Limits records to those associated with budgets currently being processed
		INNER JOIN #Budget Budget ON
			BudgetProject.BudgetId = Budget.BudgetId AND
			BudgetProject.ImportBatchId = Budget.ImportBatchId

	PRINT 'Completed inserting records into #BudgetProject: '+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE CLUSTERED INDEX IX_ImportBatchId_BudgetID ON #BudgetProject (ImportBatchId, BudgetId)
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

	PRINT 'Completed inserting records into #Region: '+CONVERT(char(10),@@rowcount)
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
		ImportBatchId INT NOT NULL,
		BudgetEmployeeId INT NOT NULL,
		BudgetId INT NOT NULL,
		HrEmployeeId INT NULL,
		LocationId INT NOT NULL
	)

	INSERT INTO #BudgetEmployee
	(
		ImportBatchId,
		BudgetEmployeeId,
		BudgetId,
		HrEmployeeId,
		LocationId
	)
	SELECT 
		BudgetEmployee.ImportBatchId,
		BudgetEmployee.BudgetEmployeeId,
		BudgetEmployee.BudgetId,
		BudgetEmployee.HrEmployeeId,
		BudgetEmployee.LocationId
	FROM 
		TapasGlobalBudgeting.BudgetEmployee BudgetEmployee

		-- Limits records to those associated with budgets currently being processed
		INNER JOIN #Budget b ON
			BudgetEmployee.BudgetId = b.BudgetId AND
			BudgetEmployee.ImportBatchId = b.ImportBatchId

	PRINT 'Completed inserting records into #BudgetEmployee: '+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE CLUSTERED INDEX UX_#BudgetEmployee_BudgetEmployeeID ON #BudgetEmployee (BudgetEmployeeId)
	CREATE INDEX IX_#BudgetEmployee_BudgetId ON #BudgetEmployee (BudgetId)

	PRINT 'Completed creating indexes on #BudgetEmployee'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	/*
		--------------------------------------------------------------------------------------------

		The #BudgetEmployeeFunctionalDepartment table stores the combination of Employees included in a Budget, and 
		the Functional Departments they belong to.
	*/
		
	SET @StartTime = GETDATE()

	CREATE TABLE #BudgetEmployeeFunctionalDepartment(
		ImportBatchId INT NOT NULL,
		BudgetEmployeeFunctionalDepartmentId INT NOT NULL,
		BudgetEmployeeId INT NOT NULL,
		EffectivePeriod INT NOT NULL,
		FunctionalDepartmentId INT NOT NULL
	)

	INSERT INTO #BudgetEmployeeFunctionalDepartment(
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

		-- Limits the data to those associated with the budget currently being processed
		INNER JOIN #BudgetEmployee BE ON
			EFD.BudgetEmployeeId = BE.BudgetEmployeeId AND
			EFD.ImportBatchId = BE.ImportBatchId

	PRINT 'Completed inserting records into #BudgetEmployeeFunctionalDepartment: '+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE CLUSTERED INDEX IX_#BudgetEmployeeFunctionalDepartment_BudgetEmployeeId ON #BudgetEmployeeFunctionalDepartment (BudgetEmployeeId)
	CREATE INDEX IX_#BudgetEmployeeFunctionalDepartment_EffectivePeriod ON #BudgetEmployeeFunctionalDepartment (ImportBatchId, BudgetEmployeeId, EffectivePeriod)

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
		
	PRINT 'Completed inserting records into #Location: '+CONVERT(char(10),@@rowcount)
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

	--------------------------------------------------------------------------------------------
	/*
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

	PRINT 'Completed inserting records into #RegionExtended: '+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE CLUSTERED INDEX IX_RegionId ON #RegionExtended (RegionId)

	PRINT 'Completed creating indexes on #RegionExtended'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	--------------------------------------------------------------------------------------------
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

	PRINT 'Completed inserting records into #Project: '+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE CLUSTERED INDEX IX_ProjectId ON #Project (ProjectId)

	PRINT 'Completed creating indexes on #Project'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	-------------------------------------------------------------------------------------------------
	/*
		System Setting Region - Bonus Cap Excess
		If a project exceeds its Bonus Cap amount, a single project is selected in place of that project.
		The project Id is determined by the System Setting Region table.
	*/

	CREATE TABLE #SystemSettingRegion
	(
		SystemSettingId INT NOT NULL,
		SystemSettingName VARCHAR(50) NOT NULL,
		SystemSettingRegionId INT NOT NULL,
		RegionId INT,
		SourceCode VARCHAR(2),
		BonusCapExcessProjectId INT
	)
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
					TapasGlobal.SystemSetting ss
					INNER JOIN TapasGlobal.SystemSettingActive(@DataPriorToDate) ssA ON
						ss.ImportKey = ssA.ImportKey
				WHERE
					ss.Name = 'BonusCapExcess' -- Previously this was done in the joins, but it's now being done here to limit the data being processed.
			) ss ON
				ssr.SystemSettingId = ss.SystemSettingId
			
	PRINT 'Completed getting system settings'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

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

END

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

		-- Used to limit to the budgets currently being processed.
		INNER JOIN #BudgetProject bp ON
			Allocation.BudgetProjectId = bp.BudgetProjectId
		
		-- Used to get the snapshot from the budgets currently being processed.
		INNER JOIN #Budget B ON
			BP.BudgetId = B.BudgetId

	PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocation: '+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE UNIQUE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationId ON #BudgetEmployeePayrollAllocation (ImportBatchId, BudgetEmployeePayrollAllocationId)
	CREATE NONCLUSTERED INDEX IX_BudgetEmployeePayrollAllocation_BudgetProject ON #BudgetEmployeePayrollAllocation(ImportBatchId, BudgetProjectId)

	PRINT 'Completed creating indexes on #BudgetEmployeePayrollAllocation'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	---------------------------------------------------------------------
	-- Source payroll tax detail
		
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
		
		-- Limits the data to records associated with the budgets currently being processed.
		INNER JOIN #BudgetEmployeePayrollAllocation Allocation ON
			TaxDetail.ImportBatchId = Allocation.ImportBatchId AND
			TaxDetail.BudgetEmployeePayrollAllocationId = Allocation.BudgetEmployeePayrollAllocationId  


	PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocationDetail: '+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationDetailId ON #BudgetEmployeePayrollAllocationDetail (ImportBatchId, BudgetEmployeePayrollAllocationDetailId)

	PRINT 'Completed creating indexes on #BudgetEmployeePayrollAllocationDetail'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	/*
		The #BudgetTaxType determines the tax types associated with budgets.
	*/

	-- Source budget tax type
	SET @StartTime = GETDATE()

	CREATE TABLE #BudgetTaxType
	(
		ImportBatchId INT NOT NULL,
		BudgetTaxTypeId INT NOT NULL,
		BudgetId INT NOT NULL,
		TaxTypeId INT NOT NULL
	)

	INSERT INTO #BudgetTaxType
	(
		ImportBatchId,
		BudgetTaxTypeId,
		BudgetId,
		TaxTypeId
	)
	SELECT 
		BudgetTaxType.ImportBatchId,
		BudgetTaxType.BudgetTaxTypeId,
		BudgetTaxType.BudgetId,
		BudgetTaxType.TaxTypeId 
	FROM 
		TapasGlobalBudgeting.BudgetTaxType BudgetTaxType

		-- Limits to the data to the those associated with the budgets currently being processed.
		INNER JOIN #Budget b ON
			BudgetTaxType.BudgetId = b.BudgetId AND
			BudgetTaxType.ImportBatchId = b.ImportBatchId

	PRINT 'Completed inserting records into #BudgetTaxType: '+CONVERT(char(10),@@rowcount)
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

	PRINT 'Completed inserting records into #TaxType: '+CONVERT(char(10),@@rowcount)
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

	-- Classifies tax types into minor categories, see CASE statement; gets set here because it can be overwritten later in the stored procedure

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
		-- Joining on allocation to limit amount of data to that associated with bugets urrently being prcessed.
		#BudgetEmployeePayrollAllocation Allocation

		INNER JOIN #BudgetEmployeePayrollAllocationDetail TaxDetail ON
			Allocation.BudgetEmployeePayrollAllocationId = TaxDetail.BudgetEmployeePayrollAllocationId AND
			Allocation.ImportBatchId = TaxDetail.ImportBatchId

		-- This join is used to determine the Minor Category if the Benefit Option is not specified.		
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			Allocation.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = 'Benefits'	

		LEFT OUTER JOIN #BudgetTaxType BudgetTaxType ON -- rather pull through as unknown than exclude, therefore LEFT JOIN
			TaxDetail.BudgetTaxTypeId = BudgetTaxType.BudgetTaxTypeId AND
			TaxDetail.ImportBatchId = BudgetTaxType.ImportBatchId

		-- Used to determine the Minor Category
		LEFT OUTER JOIN #TaxType TaxType ON
			BudgetTaxType.TaxTypeId = TaxType.TaxTypeId	AND
			BudgetTaxType.ImportBatchId = TaxType.ImportBatchId

	PRINT 'Completed inserting records into #EmployeePayrollAllocationDetail: '+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #EmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationDetailId,  BudgetEmployeePayrollAllocationId)
	CREATE INDEX IX_EmployeePayrollAllocationDetail2 ON #EmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationId)

	PRINT 'Completed creating indexes on #EmployeePayrollAllocationDetail'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

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
		b.SnapshotId
	FROM
		TapasGlobalBudgeting.BudgetOverheadAllocation OverheadAllocation

		-- Limits the data to records associated with budgets currently being processed.
		INNER JOIN #Budget b ON
			OverheadAllocation.BudgetId = b.BudgetId AND
			OverheadAllocation.ImportBatchId = b.ImportBatchId

	PRINT 'Completed inserting records into #BudgetOverheadAllocation: '+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocation (BudgetOverheadAllocationId,BudgetId,OverheadRegionId,BudgetEmployeeId)
	PRINT 'Completed creating indexes on #BudgetOverheadAllocation'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	-- Source overhead allocation detail

		/*
			The #BudgetOverheadAllocationDetail table stores overhead budget data for the individual projects.
		*/

	SET @StartTime = GETDATE()

	CREATE TABLE #BudgetOverheadAllocationDetail
	(
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
		INNER JOIN #Budget B ON
			BP.BudgetId = B.BudgetId  

	PRINT 'Completed inserting records into #BudgetOverheadAllocationDetail: '+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
	CREATE INDEX IX_BudgetOverheadAllocationDetail2 ON #BudgetOverheadAllocationDetail (BudgetOverheadAllocationId)

	PRINT 'Completed creating indexes on #BudgetOverheadAllocationDetail'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

		/*
			The #OverheadAllocationDetail table stores overhead budget data for the individual projects, and includes the GL Minor Category
			mapping.
		*/

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
		GlCategory.GLMinorCategoryId AS MinorGlAccountCategoryId, -- Hardcode to a specific minor category, could be changed later in the stored proc
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
			OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId AND
			OverheadAllocation.ImportBatchId = OverheadDetail.ImportBatchId

		-- Used to determine the Minor Category of the records	
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			OverheadDetail.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = 'External General Overhead'

	PRINT 'Completed inserting records into #OverheadAllocationDetail: '+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	CREATE CLUSTERED INDEX IX_Clustered ON #OverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
	CREATE INDEX IX_OverheadAllocationDetail2 ON #OverheadAllocationDetail (BudgetOverheadAllocationId)

	PRINT 'Completed creating indexes on #OverheadAllocationDetail'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END

/* ===============================================================================================================================================
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
		ISNULL
		(
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
								Allocation2.ImportBatchId = EFD.ImportBatchId AND
								Allocation2.BudgetEmployeeId = EFD.BudgetEmployeeId
						WHERE
							Allocation.BudgetEmployeePayrollAllocationId = Allocation2.BudgetEmployeePayrollAllocationId AND
							Allocation.ImportBatchId = Allocation2.ImportBatchId AND
							EFD.EffectivePeriod <= Allocation.Period

						GROUP BY
							Allocation2.ImportBatchId,
							Allocation2.BudgetEmployeeId
					) EFDo

					LEFT OUTER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
						EFDo.ImportBatchId = EFD.ImportBatchId AND
						EFDo.BudgetEmployeeId = EFD.BudgetEmployeeId AND
						EFDo.EffectivePeriod = EFD.EffectivePeriod
			),
			-1
		) AS FunctionalDepartmentId
	FROM
		#BudgetEmployeePayrollAllocation Allocation

		INNER JOIN #BudgetProject BudgetProject ON 
			Allocation.ImportBatchId = BudgetProject.ImportBatchId AND
			Allocation.BudgetProjectId = BudgetProject.BudgetProjectId

	PRINT 'Completed inserting records into #EffectiveFunctionalDepartment: '+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE INDEX IX_EffectiveFunctionalDepartment_AllocId ON #EffectiveFunctionalDepartment (BudgetEmployeePayrollAllocationId)

	PRINT 'Completed creating indexes on #EffectiveFunctionalDepartment'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

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
		BudgetReforecastTypeKey INT NOT NULL,
		ReforecastKey INT NOT NULL,
		SnapshotId INT NOT NULL,
		BudgetId INT NOT NULL,
		BudgetRegionId INT NOT NULL,
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
		ActivityTypeCode Varchar(50) NOT NULL,
		PropertyFundId INT NOT NULL,
		AllocationSubRegionGlobalRegionId INT NOT NULL,
		ConsolidationSubRegionGlobalRegionId INT NOT NULL,
		OriginatingRegionCode CHAR(6) NULL,
		OriginatingRegionSourceCode VARCHAR(2) NULL,
		LocalCurrencyCode CHAR(3) NOT NULL,
		AllocationUpdatedDate DATETIME NOT NULL,
		BudgetReportGroupPeriod INT NOT NULL,
		SourceTableName VARCHAR(128) NOT NULL
	)
	-- Insert original budget amounts
	-- links everything that we have pulled above (applying linking logic to tax, pre-tax and overhead data)
	INSERT INTO #ProfitabilityPreTaxSource
	(
		ImportBatchId,
		BudgetReforecastTypeKey,
		ReforecastKey,
		SnapshotId,
		BudgetId,
		BudgetRegionId,
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
		
		SourceTableName
	)
	SELECT 
		Budget.ImportBatchId,
		@BudgetReforecastTypeKey,
		Budget.ReforecastKey,
		Budget.SnapshotId,
		Budget.BudgetId AS BudgetId,
		Budget.RegionId AS BudgetRegionId,
		ISNULL(BudgetProject.ProjectId,0) AS ProjectId,
		ISNULL(BudgetEmployee.HrEmployeeId,0) AS HrEmployeeId,
		Allocation.BudgetEmployeePayrollAllocationId,
		'TGB:BudgetId=' + CONVERT(varchar,Budget.BudgetId) + '&ProjectId=' + CONVERT(varchar,ISNULL(BudgetProject.ProjectId,0)) + '&HrEmployeeId=' + CONVERT(varchar,ISNULL(BudgetEmployee.HrEmployeeId,0)) + '&BudgetEmployeePayrollAllocationId=' + CONVERT(varchar,Allocation.BudgetEmployeePayrollAllocationId) + '&BudgetEmployeePayrollAllocationDetailId=0&BudgetOverheadAllocationDetailId=0' AS ReferenceCode,
		Allocation.Period AS ExpensePeriod,
		SourceRegion.SourceCode,
		ISNULL(Allocation.PreTaxSalaryAmount,0) AS SalaryPreTaxAmount,
		ISNULL(Allocation.PreTaxProfitShareAmount, 0) AS ProfitSharePreTaxAmount,
		ISNULL(Allocation.PreTaxBonusAmount,0) AS BonusPreTaxAmount, 
		ISNULL(Allocation.PreTaxBonusCapExcessAmount,0) AS BonusCapExcessPreTaxAmount,
		ISNULL(EFD.FunctionalDepartmentId, -1),
		fd.GlobalCode AS FunctionalDepartmentCode, 
		--CASE WHEN BudgetProject.IsTsCost = 0 THEN 1 ELSE 0 END AS Reimbursable, -- CC 4 :: GC
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
		
		'BudgetEmployeePayrollAllocation'
	FROM
		#BudgetEmployeePayrollAllocation Allocation -- tax amount

		INNER JOIN #BudgetProject BudgetProject ON 
			Allocation.BudgetProjectId = BudgetProject.BudgetProjectId AND
			Allocation.ImportBatchId = BudgetProject.ImportBatchId

		INNER JOIN #Budget Budget ON
			BudgetProject.ImportBatchId = Budget.ImportBatchId AND
			BudgetProject.BudgetId = Budget.BudgetId

		LEFT OUTER JOIN #Region SourceRegion ON
			Budget.RegionId = SourceRegion.RegionId

		-- Maps the source of the record
		LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
			SourceRegion.SourceCode = GrSc.SourceCode

		-- Maps the Functional Department
		LEFT OUTER JOIN #EffectiveFunctionalDepartment efd ON
			Allocation.BudgetEmployeePayrollAllocationId = efd.BudgetEmployeePayrollAllocationId

		-- Resolves the Functional Department Code
		LEFT OUTER JOIN #FunctionalDepartment fd ON
			efd.FunctionalDepartmentId = fd.FunctionalDepartmentId

		/*
			A Property Fund can either be mapped using the PropertyFundId in the BudgetProject table, or using the CorporateDepartmentCode and
			SourceCode combination in the BudgetProject table to determine the PropertyFundId through the ReportingEntityCorproateDepartment table
			or the ReportingEntityPropertyEntity table.
			The Property Fund using the CorporateDepartmentCode and SourceCode is the first option, but if this is null, the PropertyFundId is used
			directly from the BudgetProject table.
		*/

		-- Gets the Property Fund a Project is mapped to
		LEFT OUTER JOIN Gdm.SnapshotPropertyFund ProjectPropertyFund ON
			BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
			Budget.SnapshotId = ProjectPropertyFund.SnapshotId AND
			ProjectPropertyFund.IsActive = 1

		-- Gets the Allocation Region from the Property Fund a project is mapped to
		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion GlobalRegion ON
			ProjectPropertyFund.AllocationSubRegionGlobalRegionId = GlobalRegion.GlobalRegionId AND
			ProjectPropertyFund.SnapshotId = GlobalRegion.SnapshotId AND
			GlobalRegion.IsActive = 1

		-- Gets the Property Fund a Project's Corporate Department is mapped to for transaction before period 201007
		LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping pfm ON
			BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
			BudgetProject.CorporateSourceCode = pfm.SourceCode AND
			pfm.SnapshotId = Budget.SnapshotId  AND
			pfm.IsDeleted = 0 AND
			(
				(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL)
				OR
				(
					(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = BudgetProject.ActivityTypeId)
					OR
					(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
				)
			) AND
			Budget.BudgetReportGroupPeriod < 201007

		-- Used to resolve the Property Fund a Project's Corporate Department is mapped to.
		LEFT OUTER JOIN	Gdm.SnapshotReportingEntityCorporateDepartment RECD ON
			GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = RECD.CorporateDepartmentCode AND
			BudgetProject.CorporateSourceCode = RECD.SourceCode  AND
			Budget.SnapshotId  = RECD.SnapshotId AND
			Budget.BudgetReportGroupPeriod >= 201007

		-- Used to resolve the Property Fund a Project's Property Entity is mapped to.				   
		LEFT OUTER JOIN Gdm.SnapshotReportingEntityPropertyEntity REPE ON
			GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = REPE.PropertyEntityCode AND
			BudgetProject.CorporateSourceCode  = REPE.SourceCode AND
			Budget.SnapshotId  = REPE.SnapshotId AND
			Budget.BudgetReportGroupPeriod >= 201007

		-- Maps the Property Fund a Project's Corporate Department / Reporting Entity is mapped to.
		LEFT OUTER JOIN Gdm.SnapshotPropertyFund DepartmentPropertyFund ON -- property fund could be coming from multiple sources
			DepartmentPropertyFund.PropertyFundId =
				CASE
					WHEN Budget.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
					ELSE
						CASE
							WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
							ELSE REPE.PropertyFundId
						END
				END AND
			DepartmentPropertyFund.SnapshotId = Budget.SnapshotId AND
			DepartmentPropertyFund.IsActive = 1

		-- 	Used to resolve the Consolidation Sub Region a Project's Corporate Department is mapped to.			
		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD ON -- (CC16)
			GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = CRCD.CorporateDepartmentCode AND
			BudgetProject.CorporateSourceCode = CRCD.SourceCode AND
			Budget.SnapshotId = CRCD.SnapshotId  AND
			Budget.BudgetReportGroupPeriod >= 201101

		-- 	Used to resolve the Consolidation Sub Region a Project's Property Entity is mapped to.			
		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionPropertyEntity CRPE ON -- (CC16)
			GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = CRPE.PropertyEntityCode AND
			BudgetProject.CorporateSourceCode = CRPE.SourceCode AND
			Budget.SnapshotId  = CRPE.SnapshotId AND
			Budget.BudgetReportGroupPeriod >= 201101

		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion ConsolidationRegion ON
			Budget.SnapshotId = ConsolidationRegion.SnapshotId AND
			ConsolidationRegion.GlobalRegionId = COALESCE(CRCD.GlobalRegionId, CRPE.GlobalRegionId, ProjectPropertyFund.AllocationSubRegionGlobalRegionId) AND
			ConsolidationRegion.IsConsolidationRegion = 1 AND
			ConsolidationRegion.IsActive = 1

		/*
			The Originating Region of a budget record is detrmined through the Location of an Employee (LocationId of BudgetEmployee table).
		*/	
		LEFT OUTER JOIN #BudgetEmployee BudgetEmployee ON
			Allocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId

		-- Used to determine the Location an employee is based in
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
		Allocation.Period BETWEEN Budget.GroupStartPeriod AND Budget.GroupEndPeriod --AND
		--Change Control 1 : GC 2010-09-01
		--BudgetProject.ActivityTypeId <> 99 -- exclude Corporate Overhead

	PRINT 'Completed inserting records into #ProfitabilityPreTaxSource: '+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE INDEX IX_SalaryPreTaxAmount ON #ProfitabilityPreTaxSource (SalaryPreTaxAmount)
	CREATE INDEX IX_ProfitSharePreTaxAmount ON #ProfitabilityPreTaxSource (ProfitSharePreTaxAmount)
	CREATE INDEX IX_BonusPreTaxAmount ON #ProfitabilityPreTaxSource (BonusPreTaxAmount)
	CREATE INDEX IX_BonusCapExcessPreTaxAmount ON #ProfitabilityPreTaxSource (BonusCapExcessPreTaxAmount)
	CREATE INDEX IX_ProfitabilityPreTaxSource5 ON #ProfitabilityPreTaxSource (BudgetEmployeePayrollAllocationId)

	PRINT 'Completed creating indexes on #ProfitabilityPreTaxSource'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

		/*
			----------------------------------------------------------------------------------------
			Tax Data
			Map Tax (includes Benefits) payroll budget amounts to GDM and HR data
		*/

	SET @StartTime = GETDATE()

	CREATE TABLE #ProfitabilityTaxSource
	(
		ImportBatchId INT NOT NULL,
		BudgetReforecastTypeKey INT NOT NULL,
		ReforecastKey INT NOT NULL,
		SnapshotId INT NOT NULL,
		BudgetId INT NOT NULL,
		BudgetRegionId INT NOT NULL,
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
		ActivityTypeCode Varchar(50) NOT NULL,
		PropertyFundId INT NOT NULL,
		AllocationSubRegionGlobalRegionId INT NOT NULL,
		ConsolidationSubRegionGlobalRegionId INT NOT NULL,
		OriginatingRegionCode CHAR(6) NULL,
		OriginatingRegionSourceCode VARCHAR(2) NULL,
		LocalCurrencyCode CHAR(3) NOT NULL,
		AllocationUpdatedDate DATETIME NOT NULL,
		BudgetReportGroupPeriod INT NOT NULL,
		
		SourceTableName VARCHAR(128) NOT NULL
	)
	-- Insert original budget amounts
	INSERT INTO #ProfitabilityTaxSource
	(
		ImportBatchId,
		BudgetReforecastTypeKey,
		ReforecastKey,
		SnapshotId,
		BudgetId,
		BudgetRegionId,
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
		
		SourceTableName
	)
	SELECT
		pts.ImportBatchId,
		pts.BudgetReforecastTypeKey,
		pts.ReforecastKey,
		pts.SnapshotId,
		pts.BudgetId,
		pts.BudgetRegionId,
		ISNULL(pts.ProjectId,0) AS ProjectId,
		ISNULL(pts.HrEmployeeId,0) AS HrEmployeeId,
		pts.BudgetEmployeePayrollAllocationId,
		TaxDetail.BudgetEmployeePayrollAllocationDetailId,
		(
			'TGB:BudgetId=' + CONVERT(VARCHAR, pts.BudgetId) +
			'&ProjectId=' + CONVERT(VARCHAR, ISNULL(pts.ProjectId, 0)) +
			'&HrEmployeeId=' + CONVERT(VARCHAR, ISNULL(pts.HrEmployeeId, 0)) +
			'&BudgetEmployeePayrollAllocationId=' + CONVERT(VARCHAR, pts.BudgetEmployeePayrollAllocationId) +
			'&BudgetEmployeePayrollAllocationDetailId=' + CONVERT(VARCHAR, TaxDetail.BudgetEmployeePayrollAllocationDetailId) +
			'&BudgetOverheadAllocationDetailId=0'
		) AS ReferenceCode,
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
		pts.AllocationSubRegionGlobalRegionId,
		pts.ConsolidationSubRegionGlobalRegionId,
		pts.OriginatingRegionCode,
		pts.OriginatingRegionSourceCode,
		pts.LocalCurrencyCode,
		pts.AllocationUpdatedDate,
		pts.BudgetReportGroupPeriod,
		
		'BudgetEmployeePayrollAllocationDetail'
	FROM
		#EmployeePayrollAllocationDetail TaxDetail

		INNER JOIN #ProfitabilityPreTaxSource pts ON -- pre tax has already been resolved, above, so join to limit taxdetail
			TaxDetail.BudgetEmployeePayrollAllocationId = pts.BudgetEmployeePayrollAllocationId

	PRINT 'Completed inserting records into #ProfitabilityTaxSource: '+CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE INDEX IX_ProfitabilityTaxSource1 ON #ProfitabilityTaxSource (SalaryTaxAmount)
	CREATE INDEX IX_ProfitabilityTaxSource2 ON #ProfitabilityTaxSource (ProfitShareTaxAmount)
	CREATE INDEX IX_ProfitabilityTaxSource3 ON #ProfitabilityTaxSource (BonusTaxAmount)
	CREATE INDEX IX_ProfitabilityTaxSource4 ON #ProfitabilityTaxSource (BonusCapExcessTaxAmount)
	CREATE INDEX IX_ProfitabilityTaxSource5 ON #ProfitabilityTaxSource (BudgetEmployeePayrollAllocationId)

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
		BudgetReforecastTypeKey INT NOT NULL,
		ReforecastKey INT NOT NULL,
		SnapshotId INT NOT NULL,
		BudgetId INT NOT NULL,
		ProjectId INT NOT NULL,
		HrEmployeeId INT NOT NULL,
		BudgetOverheadAllocationId INT NOT NULL,
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
		
		SourceTableName VARCHAR(128) NOT NULL
	)
	-- Insert original overhead amounts
	INSERT INTO #ProfitabilityOverheadSource
	(
		ImportBatchId,
		BudgetReforecastTypeKey,
		ReforecastKey,
		SnapshotId,
		BudgetId,
		ProjectId,
		HrEmployeeId,
		BudgetOverheadAllocationId,
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
		
		SourceTableName
	)
	SELECT
		Budget.ImportBatchId,
		@BudgetReforecastTypeKey,
		Budget.ReforecastKey,
		Budget.SnapshotId,
		Budget.BudgetId AS BudgetId,
		ISNULL(BudgetProject.ProjectId,0) AS ProjectId,
		ISNULL(BudgetEmployee.HrEmployeeId,0) AS HrEmployeeId,
		OverheadDetail.BudgetOverheadAllocationId,
		OverheadDetail.BudgetOverheadAllocationDetailId,
		'TGB:BudgetId=' + CONVERT(varchar,Budget.BudgetId) + '&ProjectId=' + CONVERT(varchar,ISNULL(BudgetProject.ProjectId,0)) + '&HrEmployeeId=' + CONVERT(varchar,ISNULL(BudgetEmployee.HrEmployeeId,0)) + '&BudgetEmployeePayrollAllocationId=0&BudgetEmployeePayrollAllocationDetailId=0' + '&BudgetOverheadAllocationDetailId=' + CONVERT(varchar,OverheadDetail.BudgetOverheadAllocationDetailId) AS ReferenceCode,
		OverheadAllocation.BudgetPeriod AS ExpensePeriod,
		SourceRegion.SourceCode,
		ISNULL(OverheadDetail.AllocationAmount,0) AS OverheadAllocationAmount,
		OverheadDetail.MinorGlAccountCategoryId,
		ISNULL(RegionExtended.OverheadFunctionalDepartmentId, -1) AS FunctionalDepartmentId,
		fd.GlobalCode AS FunctionalDepartmentCode,
		CASE
			WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
				CASE
					WHEN
						BudgetProject.IsTsCost = 0 -- Where ISTSCost is False the cost will be reimbursable
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
		
		'BudgetOverheadAllocation'
	FROM
		#BudgetOverheadAllocation OverheadAllocation 

		INNER JOIN #BudgetEmployee BudgetEmployee ON
			OverheadAllocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId

		INNER JOIN #OverheadAllocationDetail OverheadDetail ON -- where overhead amount sits
			OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId

		INNER JOIN #BudgetProject BudgetProject ON 
			OverheadDetail.BudgetProjectId = BudgetProject.BudgetProjectId

		INNER JOIN #Budget Budget ON 
			BudgetProject.BudgetId = Budget.BudgetId AND
			BudgetProject.ImportBatchId = Budget.ImportBatchId		

		LEFT OUTER JOIN #Region SourceRegion ON 
			Budget.RegionId = SourceRegion.RegionId

		LEFT OUTER JOIN #RegionExtended RegionExtended ON 
			SourceRegion.RegionId = RegionExtended.RegionId

		LEFT OUTER JOIN #FunctionalDepartment fd ON
			RegionExtended.OverheadFunctionalDepartmentId = fd.FunctionalDepartmentId 

		-- Maps the Property Fund based on the BudgetProject mapping
		LEFT OUTER JOIN Gdm.SnapshotPropertyFund ProjectPropertyFund ON
			BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
			Budget.SnapshotId  = ProjectPropertyFund.SnapshotId  AND
			ProjectPropertyFund.IsActive = 1

		-- Maps the Allocation Sub Region of the Budget Project's property fund
		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion GlobalRegion ON
			ProjectPropertyFund.AllocationSubRegionGlobalRegionId = GlobalRegion.GlobalRegionId AND
			ProjectPropertyFund.SnapshotId = GlobalRegion.SnapshotId AND
			GlobalRegion.IsActive = 1
			
		-- Maps the Source of the Budget Project
		LEFT OUTER JOIN GrReporting.dbo.[Source] GrScC ON
			BudgetProject.CorporateSourceCode = GrScC.SourceCode  

		-- Maps the Property Fund of the Budget Project based on the CorporateDepartmentCode and SourceCode for transactions before 201007
		LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping pfm ON
			BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
			BudgetProject.CorporateSourceCode = pfm.SourceCode AND
			Budget.SnapshotId = pfm.SnapshotId AND

			pfm.IsDeleted = 0 AND 
			(
				(GrScC.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
				OR
				(
					(GrScC.IsCorporate = 'YES' AND pfm.ActivityTypeId = BudgetProject.ActivityTypeId)
					OR
					(GrScC.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
				)
			) AND
			Budget.BudgetReportGroupPeriod < 201007

		-- Maps the Budget Project to a Property Fund using the Corporate Department Code and Corporate Source Code combinations.
		LEFT OUTER JOIN	Gdm.SnapshotReportingEntityCorporateDepartment RECDC ON
			GrScC.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = RECDC.CorporateDepartmentCode AND
			BudgetProject.CorporateSourceCode = RECDC.SourceCode AND
			Budget.SnapshotId = RECDC.SnapshotId AND
			Budget.BudgetReportGroupPeriod >= 201007

		LEFT OUTER JOIN Gdm.SnapshotReportingEntityPropertyEntity REPEC ON
			GrScC.IsProperty = 'YES' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = REPEC.PropertyEntityCode AND
			BudgetProject.CorporateSourceCode = REPEC.SourceCode AND
			Budget.SnapshotId = REPEC.SnapshotId AND
			Budget.BudgetReportGroupPeriod >= 201007

		-- Maps the Budget Project to a Proeprty Fund
		LEFT OUTER JOIN Gdm.SnapshotPropertyFund DepartmentPropertyFund ON
			DepartmentPropertyFund.SnapshotId = Budget.SnapshotId AND
			DepartmentPropertyFund.PropertyFundId =
				CASE
					WHEN
						Budget.BudgetReportGroupPeriod < 201007
					THEN
						pfm.PropertyFundId
					ELSE
						ISNULL(RECDC.PropertyFundId, REPEC.PropertyFundId)
				END AND
			DepartmentPropertyFund.IsActive = 1
		/*
			Some BudgetProjects which overehead budget records are assigned to assign the overhead transactions to other projects to determine
			the Property Fund and the Allocation Sub Region of the project. This Overhead Specific project is determined using the 
			AllocateOverheadsProjectId from the BudgetProject table.
		*/

		LEFT OUTER JOIN	#Project OverheadProject ON
			BudgetProject.AllocateOverheadsProjectId = OverheadProject.ProjectId 

		-- Gets the Source of the Overhead Project
		LEFT OUTER JOIN GrReporting.dbo.[Source] GrScO ON
			OverheadProject.CorporateSourceCode = GrScO.SourceCode  

		-- Maps the Property Fund of the Overhead Project for transactions before 201007
		LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping opfm ON
			OverheadProject.CorporateDepartmentCode = opfm.PropertyFundCode AND -- Combination of entity and corporate department
			OverheadProject.CorporateSourceCode = opfm.SourceCode AND
			opfm.SnapshotId = Budget.SnapshotId AND
			
			opfm.IsDeleted = 0 AND 
			(
				(GrScO.IsProperty = 'YES' AND opfm.ActivityTypeId IS NULL) 
				OR
				(
					(GrScO.IsCorporate = 'YES' AND opfm.ActivityTypeId = BudgetProject.ActivityTypeId)
					OR
					(GrScO.IsCorporate = 'YES' AND opfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
				)
			) AND
			Budget.BudgetReportGroupPeriod < 201007

		/*
			The SnapshotReportingEntityCorporateDepartment and SnapshotReportingEntityPropertyEntity tables map the Overhead Project to a 
			Property Fund using the Corporate Department Code and Corporate Source Code combinations.
			This previously BudgetProject.CorporateDepartmentCode and BudgetProject.CorporateSourceCode but was changed to OverheadProject.xx 
			to show that it's the Property Fund that the Overhead Project is mapped to.
		*/	

		LEFT OUTER JOIN	Gdm.SnapshotReportingEntityCorporateDepartment RECDO ON
			GrScO.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
			LTRIM(RTRIM(OverheadProject.CorporateDepartmentCode)) = RECDO.CorporateDepartmentCode AND 
			OverheadProject.CorporateSourceCode = RECDO.SourceCode AND
			Budget.SnapshotId = RECDO.SnapshotId AND
			Budget.BudgetReportGroupPeriod >= 201007

		LEFT OUTER JOIN Gdm.SnapshotReportingEntityPropertyEntity REPEO ON
			GrScO.IsProperty = 'YES' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(OverheadProject.CorporateDepartmentCode)) = REPEO.PropertyEntityCode AND
			OverheadProject.CorporateSourceCode = REPEO.SourceCode AND
			Budget.SnapshotId = REPEO.SnapshotId AND
			Budget.BudgetReportGroupPeriod >= 201007

		-- Maps the Property Fund for the Overhead Project for transactions before 201007
		LEFT OUTER JOIN Gdm.SnapshotPropertyFund OverheadPropertyFund ON
			OverheadPropertyFund.PropertyFundId =
				CASE
					WHEN Budget.BudgetReportGroupPeriod < 201007 THEN opfm.PropertyFundId
					ELSE
						CASE
							WHEN GrScO.IsCorporate = 'YES' THEN RECDO.PropertyFundId
							ELSE REPEO.PropertyFundId
						END
				END AND
			OverheadPropertyFund.SnapshotId = Budget.SnapshotId AND
			OverheadPropertyFund.IsActive = 1

		-- Maps the Consolidaiton Reigon of the Budget Project's Corporate Department
		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD ON -- (CC16)
			GrScC.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = CRCD.CorporateDepartmentCode AND
			BudgetProject.CorporateSourceCode = CRCD.SourceCode AND
			Budget.SnapshotId = CRCD.SnapshotId AND
			Budget.BudgetReportGroupPeriod >= 201101

		-- Maps the Consolidaiton region of the Budget Project's Property Entity
		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionPropertyEntity CRPE ON -- (CC16)
			GrScC.IsProperty = 'YES' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = CRPE.PropertyEntityCode AND
			BudgetProject.CorporateSourceCode = CRPE.SourceCode  AND
			Budget.SnapshotId  = CRPE.SnapshotId AND
			Budget.BudgetReportGroupPeriod >= 201101

		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion ConsolidationRegion ON
			Budget.SnapshotId = ConsolidationRegion.SnapshotId AND
			ConsolidationRegion.GlobalRegionId = COALESCE(CRCD.GlobalRegionId, CRPE.GlobalRegionId, ProjectPropertyFund.AllocationSubRegionGlobalRegionId) AND
			ConsolidationRegion.IsConsolidationRegion = 1 AND
			ConsolidationRegion.IsActive = 1

		LEFT OUTER JOIN Gdm.SnapshotOverheadRegion OriginatingRegion ON 
			OverheadAllocation.OverheadRegionId = OriginatingRegion.OverheadRegionId AND
			Budget.SnapshotId = OriginatingRegion.SnapshotId  
	WHERE
		OverheadAllocation.BudgetPeriod BETWEEN Budget.GroupStartPeriod AND Budget.GroupEndPeriod

	PRINT 'Completed inserting records into #ProfitabilityOverheadSource: '+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE INDEX IX_ProfitabilityOverheadSource1 ON #ProfitabilityOverheadSource (OverheadAllocationAmount)

	PRINT 'Completed creating indexes on #ProfitabilityOverheadSource'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END

/* ===============================================================================================================================================
		6.	Combine tables into #ProfitabilityPayrollMapping table and map to GDM data
   ============================================================================================================================================ */
BEGIN

	SET @StartTime = GETDATE()

	CREATE TABLE #ProfitabilityPayrollMapping
	(
		ImportBatchId INT NOT NULL,
		BudgetReforecastTypeKey INT NOT NULL,
		ReforecastKey INT NOT NULL,
		SnapshotId INT NOT NULL,
		BudgetId INT NOT NULL,
		ReferenceCode VARCHAR(300) NOT NULL,
		ExpensePeriod CHAR(6) NOT NULL,	
		SourceCode VARCHAR(2) NULL,
		BudgetAmount MONEY NOT NULL,
		MajorGlAccountCategoryId INT NOT NULL,
		MinorGlAccountCategoryId INT NOT NULL,
		FunctionalDepartmentId INT NOT NULL,
		FunctionalDepartmentCode VARCHAR(31) NULL,
		Reimbursable BIT NOT NULL,
		FeeOrExpense  VARCHAR(20) NOT NULL,
		ActivityTypeId INT NOT NULL,
		PropertyFundId INT NOT NULL,
		AllocationSubRegionGlobalRegionId INT NOT NULL,
		ConsolidationSubRegionGlobalRegionId INT NOT NULL,
		OriginatingRegionCode CHAR(6) NULL,
		OriginatingRegionSourceCode VARCHAR(2) NULL,
		LocalCurrencyCode CHAR(3) NOT NULL,
		AllocationUpdatedDate DATETIME NOT NULL,
		GlobalGlAccountCode VARCHAR(10) NULL,
		IsCorporateOverheadOverhead BIT NOT NULL,
		
		SourceTableName VARCHAR(128) NOT NULL
	)

	INSERT INTO #ProfitabilityPayrollMapping
	(
		ImportBatchId,
		BudgetReforecastTypeKey,
		ReforecastKey,
		SnapshotId,
		BudgetId,
		ReferenceCode,
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
		IsCorporateOverheadOverhead,
		
		SourceTableName
	)
	-- Get Base Salary Payroll pre tax mappings and budget
	SELECT
		pps.ImportBatchId,
		pps.BudgetReforecastTypeKey,
		pps.ReforecastKey,
		pps.SnapshotId,
		pps.BudgetId,
		pps.ReferenceCode + '&Type=SalaryPreTax' AS ReferenceCode,
		pps.ExpensePeriod,
		pps.SourceCode,
		pps.SalaryPreTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		GlCategory.GLMinorCategoryId AS MinorGlAccountCategoryId, 
		pps.FunctionalDepartmentId,
		pps.FunctionalDepartmentCode,
		pps.Reimbursable,  
		'SalaryPreTax' FeeOrExpense,
		pps.ActivityTypeId,
		pps.PropertyFundId,
		pps.AllocationSubRegionGlobalRegionId,
		pps.ConsolidationSubRegionGlobalRegionId,
		pps.OriginatingRegionCode,
		pps.OriginatingRegionSourceCode,
		pps.LocalCurrencyCode,
		pps.AllocationUpdatedDate,

		'N/A' AS GlobalGlAccountCode, -- No GL Global Accounts for Payroll Data 
		
		CASE
			WHEN
				pps.ActivityTypeCode = 'CORPOH'
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverheadOverhead,
		
		pps.SourceTableName
	FROM
		#ProfitabilityPreTaxSource pps -- pull all pre-tax amounts that are not zero

		-- Used to map the Major and Minor Category Ids based on the SnapshotId
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			GlCategory.SnapshotId = pps.SnapshotId AND
			GlCategory.GLMinorCategoryName = 'Base Salary'
	WHERE
		pps.SalaryPreTaxAmount <> 0 -- Records which have a Base Salary amount

	-- Get Profit Share Benefit pre tax mappings and budget
	UNION ALL

	SELECT
		pps.ImportBatchId,
		pps.BudgetReforecastTypeKey,
		pps.ReforecastKey,
		pps.SnapshotId,
		pps.BudgetId,
		pps.ReferenceCode + '&Type=ProfitSharePreTax' AS ReferenceCode,
		pps.ExpensePeriod,
		pps.SourceCode,
		pps.ProfitSharePreTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		GlCategory.GLMinorCategoryId AS MinorGlAccountCategoryId, 
		pps.FunctionalDepartmentId,
		pps.FunctionalDepartmentCode,
		pps.Reimbursable,  
		'ProfitSharePreTax' FeeOrExpense,
		pps.ActivityTypeId,
		pps.PropertyFundId,
		pps.AllocationSubRegionGlobalRegionId,
		pps.ConsolidationSubRegionGlobalRegionId,
		pps.OriginatingRegionCode,
		pps.OriginatingRegionSourceCode,
		pps.LocalCurrencyCode,
		pps.AllocationUpdatedDate,
		
		'N/A' AS GlobalGlAccountCode,
		
		CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
			1
		ELSE
			0
		END AS IsCorporateOverheadOverhead ,
		
		pps.SourceTableName
	FROM
		#ProfitabilityPreTaxSource pps

		INNER JOIN GrReporting.dbo.ActivityType Att ON 
			pps.ActivityTypeId = Att.ActivityTypeId AND
			pps.SnapshotId = Att.SnapshotId  

		INNER JOIN #PayrollGlobalMappings GlCategory ON
			pps.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = 'Benefits' -- Profit Share maps to the Benefits GL Minor Category
	WHERE
		pps.ProfitSharePreTaxAmount <> 0 -- Records which have a Profit Share Amount

	-- Get Bonus pre tax mappings and budget
	UNION ALL

	SELECT
		pps.ImportBatchId,
		pps.BudgetReforecastTypeKey,
		pps.ReforecastKey,
		pps.SnapshotId,
		pps.BudgetId,
		pps.ReferenceCode + '&Type=BonusPreTax' AS ReferenceCode,
		pps.ExpensePeriod,
		pps.SourceCode,
		pps.BonusPreTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		GlCategory.GLMinorCategoryId AS MinorGlAccountCategoryId, 
		pps.FunctionalDepartmentId,
		pps.FunctionalDepartmentCode,
		pps.Reimbursable,  
		'BonusPreTax' FeeOrExpense,
		pps.ActivityTypeId,
		pps.PropertyFundId,
		pps.AllocationSubRegionGlobalRegionId,
		pps.ConsolidationSubRegionGlobalRegionId,
		pps.OriginatingRegionCode,
		pps.OriginatingRegionSourceCode,
		pps.LocalCurrencyCode,
		pps.AllocationUpdatedDate,

		'N/A' AS GlobalGlAccountCode,
		
		CASE
			WHEN
				pps.ActivityTypeCode = 'CORPOH'
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverheadOverhead,
		
		pps.SourceTableName
	FROM
		#ProfitabilityPreTaxSource pps

		INNER JOIN GrReporting.dbo.ActivityType Att ON 
			pps.ActivityTypeId = Att.ActivityTypeId AND
			pps.SnapshotId = Att.SnapshotId

		INNER JOIN #PayrollGlobalMappings GlCategory ON
			pps.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = 'Bonus'
	WHERE
		pps.BonusPreTaxAmount <> 0 -- Records which have a bonus amount

	UNION ALL

	SELECT
		pps.ImportBatchId,
		pps.BudgetReforecastTypeKey,
		pps.ReforecastKey,
		pps.SnapshotId,
		pps.BudgetId,
		pps.ReferenceCode + '&Type=BonusCapExcessPreTax' AS ReferenceCode,
		pps.ExpensePeriod,
		pps.SourceCode,
		pps.BonusCapExcessPreTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		GlCategory.GLMinorCategoryId AS MinorGlAccountCategoryId, 
		pps.FunctionalDepartmentId,
		pps.FunctionalDepartmentCode,
		0 AS Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
		'BonusCapExcessPreTax' FeeOrExpense,
		ISNULL(p.ActivityTypeId, -1) AS ActivityTypeId,
			/*
				When selecting a Property Fund, the first option is is the Property Fund assigned to the Corporate Department of
				the Project - DepartmentPropertyFund. If the CorporateDepartmentCode field of the project is NULL or '@', the
				next option is the project's PropertyFundId field - the ProjectPropertyFund.
			*/
		COALESCE(DepartmentPropertyFund.PropertyFundId, ProjectPropertyFund.PropertyFundId, -1) AS PropertyFundId,
		COALESCE(DepartmentPropertyFund.AllocationSubRegionGlobalRegionId, ProjectPropertyFund.AllocationSubRegionGlobalRegionId -1) AS AllocationSubRegionGlobalRegionId,	
		ISNULL(ConsolidationRegion.GlobalRegionId, -1) AS ConsolidationSubRegionGlobalRegionId,
		pps.OriginatingRegionCode,
		pps.OriginatingRegionSourceCode,
		pps.LocalCurrencyCode,
		pps.AllocationUpdatedDate,
		
		'N/A' AS GlobalGlAccountCode,
		CASE
			WHEN
				pps.ActivityTypeCode = 'CORPOH'
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverheadOverhead,
		
		pps.SourceTableName
	FROM
		#ProfitabilityPreTaxSource pps	

		INNER JOIN GrReporting.dbo.ActivityType Att ON 
			pps.ActivityTypeId = Att.ActivityTypeId AND
			pps.SnapshotId = Att.SnapshotId  

		-- Used to determine the Major and Minor Categories of records
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			pps.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = 'Bonus'

		/* If a project exceeds its Bonus Cap amount, a single project is selected in place of that project.
			The project Id is determined by the System Setting Region table.*/		
		LEFT OUTER JOIN #SystemSettingRegion ssr ON
			pps.SourceCode = ssr.SourceCode AND
			pps.BudgetRegionId = ssr.RegionId

		LEFT OUTER JOIN #Project p ON
			ssr.BonusCapExcessProjectId = p.ProjectId

		-- Maps the Property Fund of the Bonus Cap Excess project		
		LEFT OUTER JOIN Gdm.SnapshotPropertyFund ProjectPropertyFund ON
			p.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
			pps.SnapshotId = ProjectPropertyFund.SnapshotId AND
			ProjectPropertyFund.IsActive = 1

		-- Maps the Allocation Sub Region of the Bonus Cap Excess project
		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion AllocationRegion ON
			ProjectPropertyFund.AllocationSubRegionGlobalRegionId = AllocationRegion.GlobalRegionId AND
			ProjectPropertyFund.SnapshotId = AllocationRegion.SnapshotId AND
			AllocationRegion.IsActive = 1

		-- Maps the Source of the record
		LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
			pps.SourceCode = GrSc.SourceCode  

		-- Maps the Property Fund for records with a period of before 201007	
		LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping pfm ON
			p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
			p.CorporateSourceCode = pfm.SourceCode AND
			pps.SnapshotId = pfm.SnapshotId AND
			--This is a bypass for the 'NULL' scenario, for only CORP have ActivityTypeId's set
			ISNULL(p.ActivityTypeId, -1) = ISNULL(pfm.ActivityTypeId, -1) AND --This is a bypass for the 'NULL' scenario, for only CORP have ActivityTypeId's set
			pfm.IsDeleted = 0 AND 
			(
				(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
				OR
				(
					(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = p.ActivityTypeId)
					OR
					(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
				)
			) AND
			pps.BudgetReportGroupPeriod < 201007

		-- Maps the Property Fund of the project based on the Corporate Department of the project.
		LEFT OUTER JOIN	Gdm.SnapshotReportingEntityCorporateDepartment RECD ON
			GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
			LTRIM(RTRIM(p.CorporateDepartmentCode)) = RECD.CorporateDepartmentCode AND
			p.CorporateSourceCode = RECD.SourceCode  AND
			pps.SnapshotId = RECD.SnapshotId AND
			pps.BudgetReportGroupPeriod >= 201007

		LEFT OUTER JOIN Gdm.SnapshotReportingEntityPropertyEntity REPE ON
			GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(p.CorporateDepartmentCode)) = REPE.PropertyEntityCode AND
			p.CorporateSourceCode = REPE.SourceCode AND
			pps.SnapshotId = REPE.SnapshotId AND
			pps.BudgetReportGroupPeriod >= 201007

		LEFT OUTER JOIN Gdm.SnapshotPropertyFund DepartmentPropertyFund ON
			DepartmentPropertyFund.PropertyFundId =
				CASE
					WHEN pps.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
					ELSE
						CASE
							WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
							ELSE REPE.PropertyFundId
						END
				END AND
			DepartmentPropertyFund.SnapshotId = pps.SnapshotId AND 
			DepartmentPropertyFund.IsActive = 1
			
		-- Maps the Consolidation Region of a project based on the Corporate Department of the project
		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD ON -- (CC16)
			GrSc.IsCorporate = 'YES' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(p.CorporateDepartmentCode)) = CRCD.CorporateDepartmentCode AND
			p.CorporateSourceCode = CRCD.SourceCode  AND
			pps.SnapshotId  = CRCD.SnapshotId AND
			pps.BudgetReportGroupPeriod >= 201101

		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionPropertyEntity CRPE ON
			GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(p.CorporateDepartmentCode)) = CRPE.PropertyEntityCode AND
			p.CorporateSourceCode = CRPE.SourceCode AND
			pps.SnapshotId  = CRPE.SnapshotId AND
			pps.BudgetReportGroupPeriod >= 201101	

		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion ConsolidationRegion ON
			PPS.SnapshotId = ConsolidationRegion.SnapshotId AND
			ConsolidationRegion.GlobalRegionId = COALESCE(CRCD.GlobalRegionId, CRPE.GlobalRegionId, AllocationRegion.GlobalRegionId) AND
			ConsolidationRegion.IsConsolidationRegion = 1 AND
			ConsolidationRegion.IsActive = 1
	WHERE
		pps.BonusCapExcessPreTaxAmount <> 0

	UNION ALL

	-- Get Base Salary Payroll Tax mappings and budget
	SELECT
		pps.ImportBatchId,
		pps.BudgetReforecastTypeKey,
		pps.ReforecastKey,
		pps.SnapshotId,
		pps.BudgetId,
		pps.ReferenceCode + '&Type=SalaryTax' AS ReferenceCode,
		pps.ExpensePeriod,
		pps.SourceCode,
		pps.SalaryTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		pps.MinorGlAccountCategoryId, 
		pps.FunctionalDepartmentId,
		pps.FunctionalDepartmentCode,
		pps.Reimbursable,  
		'SalaryTaxTax' FeeOrExpense,
		pps.ActivityTypeId,
		pps.PropertyFundId,
		pps.AllocationSubRegionGlobalRegionId,
		pps.ConsolidationSubRegionGlobalRegionId,
		pps.OriginatingRegionCode,
		pps.OriginatingRegionSourceCode,
		pps.LocalCurrencyCode,
		pps.AllocationUpdatedDate,
	
		'N/A' AS GlobalGlAccountCode,
		CASE
			WHEN
				pps.ActivityTypeCode = 'CORPOH'
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverheadOverhead,
		
		pps.SourceTableName
	FROM
		#ProfitabilityTaxSource pps

		INNER JOIN GrReporting.dbo.ActivityType Att ON
			pps.ActivityTypeId = Att.ActivityTypeId AND
			pps.SnapshotId = Att.SnapshotId

		INNER JOIN #PayrollGlobalMappings GlCategory ON
			pps.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = 'Benefits'
	WHERE
		pps.SalaryTaxAmount <> 0

	-- Get Profit Share Benefit Tax mappings and budget
	UNION ALL

	SELECT
		pps.ImportBatchId,
		pps.BudgetReforecastTypeKey,
		pps.ReforecastKey,
		pps.SnapshotId,
		pps.BudgetId,
		pps.ReferenceCode + '&Type=ProfitShareTax' AS ReferenceCode,
		pps.ExpensePeriod,
		pps.SourceCode,
		pps.ProfitShareTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		pps.MinorGlAccountCategoryId, 
		pps.FunctionalDepartmentId,
		pps.FunctionalDepartmentCode,
		pps.Reimbursable,  
		'ProfitShareTax' FeeOrExpense,
		pps.ActivityTypeId,
		pps.PropertyFundId,
		pps.AllocationSubRegionGlobalRegionId,
		pps.ConsolidationSubRegionGlobalRegionId,
		pps.OriginatingRegionCode,
		pps.OriginatingRegionSourceCode,
		pps.LocalCurrencyCode,
		pps.AllocationUpdatedDate,
		
		'N/A' AS GlobalGlAccountCode,
		CASE
			WHEN
				pps.ActivityTypeCode = 'CORPOH'
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverheadOverhead,
		
		pps.SourceTableName
	FROM
		#ProfitabilityTaxSource pps

		INNER JOIN GrReporting.dbo.ActivityType Att ON 
			pps.ActivityTypeId = Att.ActivityTypeId AND
			pps.SnapshotId = Att.SnapshotId 

		INNER JOIN #PayrollGlobalMappings GlCategory ON
			pps.SnapshotId  = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = 'Benefits'
	WHERE
		pps.ProfitShareTaxAmount <> 0

	-- Get Bonus Tax mappings and budget
	UNION ALL

	SELECT
		pps.ImportBatchId,
		pps.BudgetReforecastTypeKey,
		pps.ReforecastKey,
		pps.SnapshotId,
		pps.BudgetId,
		pps.ReferenceCode + '&Type=BonusTax' AS ReferenceCode,
		pps.ExpensePeriod,
		pps.SourceCode,
		pps.BonusTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		pps.MinorGlAccountCategoryId, 
		pps.FunctionalDepartmentId,
		pps.FunctionalDepartmentCode,
		pps.Reimbursable,  
		'BonusTax' FeeOrExpense,
		pps.ActivityTypeId,
		pps.PropertyFundId,
		pps.AllocationSubRegionGlobalRegionId,
		pps.ConsolidationSubRegionGlobalRegionId,
		pps.OriginatingRegionCode,
		pps.OriginatingRegionSourceCode,
		pps.LocalCurrencyCode,
		pps.AllocationUpdatedDate,
		
		'N/A' AS GlobalGlAccountCode,
		CASE
			WHEN
				pps.ActivityTypeCode = 'CORPOH'
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverheadOverhead,
		
		pps.SourceTableName 
	FROM
		#ProfitabilityTaxSource pps
	
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			pps.SnapshotId = GlCategory.SnapshotId  AND
			GlCategory.GLMinorCategoryName = 'Benefits'
	WHERE
		pps.BonusTaxAmount <> 0

	-- Get Bonus cap Tax mappings 
	UNION ALL

	SELECT
		pps.ImportBatchId,
		pps.BudgetReforecastTypeKey,
		pps.ReforecastKey,
		pps.SnapshotId,
		pps.BudgetId,
		pps.ReferenceCode + '&Type=BonusCapExcessTax' AS ReferenceCode,
		pps.ExpensePeriod,
		pps.SourceCode,
		pps.BonusCapExcessTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		pps.MinorGlAccountCategoryId, 
		pps.FunctionalDepartmentId,
		pps.FunctionalDepartmentCode,
		0 AS Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
		'BonusCapExcessTax' FeeOrExpense,
		ISNULL(p.ActivityTypeId, -1) AS ActivityTypeId,
			/*
				When selecting a Property Fund, the first option is is the Property Fund assigned to the Corporate Department of
				the Project - DepartmentPropertyFund. If the CorporateDepartmentCode field of the project is NULL or '@', the
				next option is the project's PropertyFundId field - the ProjectPropertyFund.
			*/
		COALESCE(DepartmentPropertyFund.PropertyFundId, ProjectPropertyFund.PropertyFundId, -1) AS PropertyFundId,
		COALESCE(DepartmentPropertyFund.AllocationSubRegionGlobalRegionId, ProjectPropertyFund.AllocationSubRegionGlobalRegionId -1) AS AllocationSubRegionGlobalRegionId,	
		ISNULL(ConsolidationRegion.GlobalRegionId, -1) AS ConsolidationSubRegionGlobalRegionId,
		pps.OriginatingRegionCode,
		pps.OriginatingRegionSourceCode,
		pps.LocalCurrencyCode,
		pps.AllocationUpdatedDate,
		
		'N/A' AS GlobalGlAccountCode,
		CASE
			WHEN
				pps.ActivityTypeCode = 'CORPOH'
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverheadOverhead,
		
		pps.SourceTableName
	FROM
		#ProfitabilityTaxSource pps	

		INNER JOIN #PayrollGlobalMappings GlCategory ON
			pps.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = 'Benefits'
			
		-- This follows the same Bonus Cap Excess logic as before
					
		LEFT OUTER JOIN #SystemSettingRegion ssr ON
			pps.SourceCode = ssr.SourceCode AND
			pps.BudgetRegionId = ssr.RegionId

		LEFT OUTER JOIN #Project p ON
			ssr.BonusCapExcessProjectId = p.ProjectId

		LEFT OUTER JOIN Gdm.SnapshotPropertyFund ProjectPropertyFund ON
			p.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
			pps.SnapshotId = ProjectPropertyFund.SnapshotId AND
			ProjectPropertyFund.IsActive = 1
			
		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion AllocationRegion ON
			ProjectPropertyFund.AllocationSubRegionGlobalRegionId = AllocationRegion.GlobalRegionId  AND
			ProjectPropertyFund.SnapshotId = AllocationRegion.SnapshotId  AND
			AllocationRegion.IsActive = 1

		LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON 
			pps.SourceCode = GrSc.SourceCode 

		LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping pfm ON
			p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
			p.CorporateSourceCode = pfm.SourceCode AND
			pps.SnapshotId = pfm.SnapshotId  AND
			pfm.IsDeleted = 0 AND 
			(
				(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
				OR
				(
					(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = p.ActivityTypeId)
					OR
					(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
				)
			) AND
			pps.BudgetReportGroupPeriod < 201007
		
		LEFT OUTER JOIN	Gdm.SnapshotReportingEntityCorporateDepartment RECD ON
			GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
			LTRIM(RTRIM(p.CorporateDepartmentCode)) = RECD.CorporateDepartmentCode AND
			p.CorporateSourceCode = RECD.SourceCode AND
			pps.SnapshotId = RECD.SnapshotId AND
			pps.BudgetReportGroupPeriod >= 201007
			   
		LEFT OUTER JOIN Gdm.SnapshotReportingEntityPropertyEntity REPE ON
			GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(p.CorporateDepartmentCode)) = REPE.PropertyEntityCode AND
			p.CorporateSourceCode = REPE.SourceCode AND
			pps.SnapshotId = REPE.SnapshotId AND
			pps.BudgetReportGroupPeriod >= 201007	
		
		LEFT OUTER JOIN Gdm.SnapshotPropertyFund DepartmentPropertyFund ON
			DepartmentPropertyFund.PropertyFundId =
				CASE
					WHEN pps.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
					ELSE
						CASE
							WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
							ELSE REPE.PropertyFundId
						END
				END AND
			DepartmentPropertyFund.SnapshotId = pps.SnapshotId AND
			DepartmentPropertyFund.IsActive = 1
			
		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD ON
			GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
			LTRIM(RTRIM(p.CorporateDepartmentCode)) = CRCD.CorporateDepartmentCode AND
			p.CorporateSourceCode  = CRCD.SourceCode AND
			pps.SnapshotId = CRCD.SnapshotId  
			
		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionPropertyEntity CRPE ON
			GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(p.CorporateDepartmentCode)) = CRPE.PropertyEntityCode  AND
			p.CorporateSourceCode = CRPE.SourceCode  AND
			pps.SnapshotId = CRPE.SnapshotId  
			
		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion ConsolidationRegion ON
			PPS.SnapshotId = ConsolidationRegion.SnapshotId AND
			ConsolidationRegion.GlobalRegionId = COALESCE(CRCD.GlobalRegionId, CRPE.GlobalRegionId, AllocationRegion.GlobalRegionId) AND
			ConsolidationRegion.IsConsolidationRegion = 1 AND
			ConsolidationRegion.IsActive = 1
	WHERE
		pps.BonusCapExcessTaxAmount <> 0
		
	-- Get Overhead mappings	
	UNION ALL

	SELECT
		pos.ImportBatchId,
		pos.BudgetReforecastTypeKey,
		pos.ReforecastKey,
		pos.SnapshotId,
		pos.BudgetId,
		pos.ReferenceCode + '&Type=OverheadAllocation' AS ReferenceCode,
		pos.ExpensePeriod,
		pos.SourceCode,
		pos.OverheadAllocationAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MinorGlAccountCategoryId,
		pos.MinorGlAccountCategoryId, 
		pos.FunctionalDepartmentId,
		pos.FunctionalDepartmentCode,
		pos.Reimbursable,  
		'Overhead' FeeOrExpense,
		pos.ActivityTypeId,
		pos.PropertyFundId,
		pos.AllocationSubRegionGlobalRegionId,
		pos.ConsolidationSubRegionGlobalRegionId,
		pos.OriginatingRegionCode,
		pos.OriginatingRegionSourceCode,
		pos.LocalCurrencyCode,
		pos.OverheadUpdatedDate,
		--General Allocated Overhead Account :: CC8
		'50029500'+RIGHT('0'+LTRIM(STR(pos.ActivityTypeId,3,0)),2),
		1 AS IsCorporateOverhead,
		
		pos.SourceTableName
	FROM
		#ProfitabilityOverheadSource pos
		
		-- Maps the Major Category of the Overhead transaction
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			pos.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = 'External General Overhead'
	WHERE
		pos.OverheadAllocationAmount <> 0

	PRINT 'Completed inserting records into #ProfitabilityPayrollMapping: '+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE UNIQUE CLUSTERED INDEX UX_ProfitabilityPayrollMapping_ReferenceCode ON #ProfitabilityPayrollMapping(ReferenceCode)
	CREATE NONCLUSTERED INDEX IX_ProfitabilityPayrollMapping_AllocationUpdatedDate ON #ProfitabilityPayrollMapping(AllocationUpdatedDate)

	PRINT 'Completed creating indexes on #ProfitabilityPayrollMapping'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END

/* ================================================================================================================================================
		7.	Create Global and Local Categorization mapping table
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
	SELECT
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
					MinC.GLMajorCategoryId  = MajC.GLMajorCategoryId AND
					MinC.SnapshotId = MajC.SnapshotId AND
					MajC.IsActive = 1 
					
				INNER JOIN Gdm.SnapshotGLFinancialCategory GFC ON
					MajC.GLFinancialCategoryId  = GFC.GLFinancialCategoryId AND
					MajC.SnapshotId  = GFC.SnapshotId  
					
				INNER JOIN Gdm.SnapshotGLCategorization GC ON
					GFC.GLCategorizationId = GC.GLCategorizationId AND
					GFC.SnapshotId = GC.SnapshotId AND
					GC.GLCategorizationId = 233
					
				INNER JOIN Gdm.SnapshotGLCategorizationType GCT ON
					GC.GLCategorizationTypeId = GCT.GLCategorizationTypeId  AND
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
			DIM.GLCategorizationHierarchyCode = 
				CONVERT(VARCHAR(32),
					LTRIM(STR(GdmMappings.GLCategorizationTypeId, 10, 0)) + ':' + 
					LTRIM(STR(GdmMappings.GLCategorizationId, 10, 0)) + ':' +
					LTRIM(STR(GdmMappings.GLFinancialCategoryId, 10, 0)) + ':' +
					LTRIM(STR(GdmMappings.GLMajorCategoryId, 10, 0)) + ':' + 
					LTRIM(STR(GdmMappings.GLMinorCategoryId, 10, 0)) + ':' +
					LTRIM(STR(ISNULL(GGA.GLGlobalAccountId, 0), 10, 0))) AND
			DIM.SnapshotId = GdmMappings.SnapshotId

	CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #GlobalGLCategorizationMapping(SnapshotId, GlGlobalAccountCode, GLMajorCategoryId, GLMinorCategoryId)

		/*  ----------------------------------------------------------------------------------------------------------------------------------------
			Local Payroll Categorization Mappings

			The #LocalPayrollGLCategorizationMapping table below is used to determine the local GLCategorizationHierchy Codes.
			The table is pivoted (i.e. each of the GLCategorizationHierchy Codes for each GLCategorization appear as a separate column for each
				ActivityType-FunctionalDepartment combination)so that it only joins to the #ProfitabilityActual table below once.
			The Businss Logic for how Local Categorizations can be found at GR Change Control 21 [3.4.3.3]		
		*/

	CREATE TABLE #LocalPayrollGLCategorizationMapping(
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
	INSERT INTO #LocalPayrollGLCategorizationMapping
	(
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
				GC.Name as GLCategorizationName,
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
					PPPGA.PropertyGLAccountId = GA.GLAccountId  AND
					PPPGA.SnapshotId = GA.SnapshotID  AND
					GA.IsActive = 1
				/*
					If the local Categorization is configured for recharge, the Global account is determined through the PropertyGLAccount 
						local account
					If the local Categorization is not configured for recharge, the Global account is determined directly from the 
						#PropertyPayrollPropertyGLAccount table
				*/
				INNER JOIN Gdm.SnapshotGLGlobalAccount GGA ON
					GGA.GLGlobalAccountId = 
						CASE 
							WHEN (GC.RechargeSourceCode IS NOT NULL AND GC.IsConfiguredForRecharge = 1) THEN
								GA.GLGlobalAccountId
							ELSE
								PPPGA.GLGlobalAccountId
						END AND
					PPPGA.SnapshotId = GGA.SnapshotId  AND
					GGA.IsActive = 1

				LEFT OUTER JOIN Gdm.SnapshotGLGlobalAccountCategorization GGAC ON
					GGA.GLGlobalAccountId = GGAC.GLGlobalAccountId   AND
					PPPGA.GLCategorizationId = GGAC.GLCategorizationId AND
					GGA.SnapshotId = GGAC.SnapshotId  
				/*
					If the local Categorization is configured for recharge, the Minor Category is determined through the CoAGLMinorCategoryId field
						in the #GLGlobalAccountCategorization table.
					If the local Categorization is not configured for recharge, the Minor Category is determined through the IndirectGLMinorCategoryId 
						field in the #GLGlobalAccountCategorization table.
				*/	
				LEFT OUTER JOIN Gdm.SnapshotGLMinorCategory MinC ON
					MinC.GLMinorCategoryId =
						CASE 
							WHEN (GC.RechargeSourceCode IS NOT NULL AND GC.IsConfiguredForRecharge = 1) THEN
								GGAC.CoAGLMinorCategoryId
							ELSE
								GGAC.DirectGLMinorCategoryId
						END AND
					GGAC.SnapshotId = MinC.SnapshotId AND
					MinC.IsActive = 1  

				LEFT OUTER JOIN Gdm.SnapshotGLMajorCategory MajC ON
					MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
					MinC.SnapshotId = MajC.SnapshotId AND
					MajC.IsActive = 1  

				LEFT OUTER JOIN Gdm.SnapshotGLFinancialCategory FinC ON
					MajC.GLFinancialCategoryId = FinC.GLFinancialCategoryId AND
					GC.GLCategorizationId  = FinC.GLCategorizationId AND
					MajC.SnapshotId = FinC.SnapshotId  

				LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy DIM ON
					DIM.GLCategorizationHierarchyCode = 
						CONVERT(VARCHAR(2), GC.GLCategorizationTypeId) + ':' +
						CONVERT(VARCHAR(10), GC.GLCategorizationId) + ':' +
						CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN '-1' ELSE CONVERT(VARCHAR(10), FinC.GLFinancialCategoryId) END + ':' +
						CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN '-1' ELSE CONVERT(VARCHAR(10), MajC.GLMajorCategoryId) END + ':' +
						CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN '-1' ELSE CONVERT(VARCHAR(10), MinC.GLMinorCategoryId) END + ':' +
						(CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1))) AND
					FinC.SnapshotId = DIM.SnapshotId 

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

				INNER JOIN Gdm.SnapshotActivityType AType ON
					ISNULL(POPGA.ActivityTypeId, 0) = CASE WHEN POPGA.ActivityTypeId IS NULL THEN 0 ELSE AType.ActivityTypeId END AND
					POPGA.SnapshotId = AType.SnapshotId AND
					AType.IsActive = 1

				INNER JOIN Gdm.SnapshotFunctionalDepartment FD ON
					ISNULL(POPGA.FunctionalDepartmentId, 0) = CASE WHEN POPGA.FunctionalDepartmentId IS NULL THEN 0 ELSE FD.FunctionalDepartmentId END AND
					POPGA.SnapshotId = FD.SnapshotId AND
					FD.IsActive = 1

				INNER JOIN Gdm.SnapshotGLCategorization GC ON
					POPGA.GLCategorizationId = GC.GLCategorizationId AND
					POPGA.SnapshotId = GC.SnapshotId AND
					GC.IsActive = 1

				INNER JOIN Gdm.SnapshotGLAccount GA ON
					POPGA.PropertyGLAccountId = GA.GLAccountId  AND
					POPGA.SnapshotId = GA.SnapshotId  AND
					GA.IsActive = 1
				/*
					If the local Categorization is configured for recharge, the Global account is determined through the PropertyGLAccount local account
					If the local Categorization is not configured for recharge, the Global account is determined directly from the 
						#PropertyOverheadPropertyGLAccount table
				*/
				INNER JOIN Gdm.SnapshotGLGlobalAccount GGA ON
					GGA.GLGlobalAccountId = 
						CASE 
							WHEN (GC.RechargeSourceCode IS NOT NULL AND GC.IsConfiguredForRecharge = 1) THEN
								GA.GLGlobalAccountId
							ELSE
								POPGA.GLGlobalAccountId
						END AND
					GGA.SnapshotId = POPGA.SnapshotId AND
					GGA.IsActive = 1

				LEFT OUTER JOIN Gdm.SnapshotGLGlobalAccountCategorization GGAC ON
					GGA.GLGlobalAccountId = GGAC.GLGlobalAccountId AND
					POPGA.GLCategorizationId = GGAC.GLCategorizationId AND
					GGA.SnapshotId = GGAC.SnapshotId  
				/*
					If the local Categorization is configured for recharge, the Minor Category is determined through the CoAGLMinorCategoryId field
						in the #GLGlobalAccountCategorization table.
					If the local Categorization is not configured for recharge, the Minor Category is determined through the IndirectGLMinorCategoryId 
						field in the #GLGlobalAccountCategorization table.
				*/	
				LEFT OUTER JOIN Gdm.SnapshotGLMinorCategory MinC ON
					MinC.GLMinorCategoryId =
						CASE 
							WHEN (GC.RechargeSourceCode IS NOT NULL AND GC.IsConfiguredForRecharge = 1) THEN
								GGAC.CoAGLMinorCategoryId
							ELSE
								GGAC.DirectGLMinorCategoryId
						END AND
					GGAC.SnapshotId = MinC.SnapshotId AND
					MinC.IsActive = 1

				LEFT OUTER JOIN Gdm.SnapshotGLMajorCategory MajC ON
					MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
					MinC.SnapshotId = MajC.SnapshotId AND
					MajC.IsActive = 1

				LEFT OUTER JOIN Gdm.SnapshotGLFinancialCategory FinC ON
					MajC.GLFinancialCategoryId = FinC.GLFinancialCategoryId  AND
					GC.GLCategorizationId = FinC.GLCategorizationId AND
					GC.SnapshotId = FinC.SnapshotId  

				LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy DIM ON
					DIM.GLCategorizationHierarchyCode = 
						CONVERT(VARCHAR(2), GC.GLCategorizationTypeId) + ':' +
						CONVERT(VARCHAR(10), GC.GLCategorizationId) + ':' +
						CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN '-1' ELSE CONVERT(VARCHAR(10), FinC.GLFinancialCategoryId) END + ':' +
						CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN '-1' ELSE CONVERT(VARCHAR(10), MajC.GLMajorCategoryId) END + ':' +
						CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN '-1' ELSE CONVERT(VARCHAR(10), MinC.GLMinorCategoryId) END + ':' +
						CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1)) AND
					FinC.SnapshotId = DIM.SnapshotId 

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

/* ===============================================================================================================================================
	8.	Map table to the #ProfitabilityBudget table with the same structure as the GrReporting.dbo.ProfitabilityBudget table
   ============================================================================================================================================= */
BEGIN

	SET @StartTime = GETDATE()

	CREATE TABLE #ProfitabilityBudget
	(
		ImportBatchId INT NOT NULL,
		BudgetReforecastTypeKey INT NOT NULL,
		ReforecastKey INT NOT NULL,
		CalendarKey INT NOT NULL,
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
		LocalBudget MONEY NOT NULL,
		ReferenceCode Varchar(300) NOT NULL,
		BudgetId INT NOT NULL,
		SnapshotId INT NOT NULL,
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

	INSERT INTO #ProfitabilityBudget 
	(
		ImportBatchId, 
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
		LocalCurrencyKey,
		LocalBudget,
		ReferenceCode,
		BudgetId,
		SnapshotId,
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
		pbm.ImportBatchId,
		pbm.BudgetReforecastTypeKey,
		pbm.ReforecastKey,
		DATEDIFF(dd, '1900-01-01', LEFT(pbm.ExpensePeriod, 4) + '-' + RIGHT(pbm.ExpensePeriod, 2) + '-01') AS CalendarKey,
		ISNULL(GrSc.SourceKey, @SourceKey) SourceKey,
		ISNULL(GrFdm.FunctionalDepartmentKey, @FunctionalDepartmentKey) FunctionalDepartmentKey,
		ISNULL(GrRi.ReimbursableKey, @ReimbursableKey) ReimbursableKey,
		ISNULL(GrAt.ActivityTypeKey, @ActivityTypeKey) ActivityTypeKey,
		ISNULL(GrPf.PropertyFundKey, @PropertyFundKey)PropertyFundKey,
		ISNULL(GrAr.AllocationRegionKey, @AllocationRegionKey) AllocationRegionKey,
		ISNULL(Grcr.AllocationRegionKey, @AllocationRegionKey) ConsolidationRegionRegionKey,
		ISNULL(GrOr.OriginatingRegionKey, @OriginatingRegionKey) OriginatingRegionKey,
		ISNULL(GrOh.OverheadKey, @OverheadKey) OverheadKey,
		ISNULL(GrCu.CurrencyKey, @LocalCurrencyKey) LocalCurrencyKey,
		pbm.BudgetAmount,
		pbm.ReferenceCode,
		pbm.BudgetId,
		pbm.SnapshotId,
		COALESCE(GlobalMapping.GlobalGLCategorizationHierarchyKey, UnknownMapping.GLCategorizationHierarchyKey, @UnknownGlobalGLCategorizationKey), -- GlobalGLCategorizationHierarchyKey
			/*
				For local categorizations, if it is an overhead transaction, it maps to the #LocalOverheadGLCategorizationMapping table. If it
				is a payroll budget record, it maps to the #LocalPayrollGLCategorizationMapping table.
				A record will only join to the #LocalOverheadGLCategorizationMapping table if it's an Overhead transaction (and therefore
				be NULL if its a Payroll transaction). Similarly, a record will only join to the #LocalPayrollGLCategorizationMapping table
				if its an Overhead transaction.
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
				GC.GLCategorizationId IS NOT NULL
			THEN
				CASE
					WHEN
						GC.Name = 'US Property' 
					THEN
						COALESCE(LocalPayrollMapping.USPropertyGLCategorizationHierarchyKey, LocalOverheadMapping.USPropertyGLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey)
					WHEN
						GC.Name = 'US Fund' 
					THEN
						COALESCE(LocalPayrollMapping.USFundGLCategorizationHierarchyKey, LocalOverheadMapping.USFundGLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey)
					WHEN
						GC.Name = 'EU Property' 
					THEN
						COALESCE(LocalPayrollMapping.EUPropertyGLCategorizationHierarchyKey, LocalOverheadMapping.EUPropertyGLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey)
					WHEN
						GC.Name = 'EU Fund' 
					THEN
						COALESCE(LocalPayrollMapping.EUFundGLCategorizationHierarchyKey, LocalOverheadMapping.EUFundGLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey)
					WHEN
						GC.Name = 'US Development' 
					THEN
						COALESCE(LocalPayrollMapping.USDevelopmentGLCategorizationHierarchyKey, LocalOverheadMapping.USDevelopmentGLCategorizationHierarchyKey, @UnknownUSDevelopmentGLCategorizationKey)
					WHEN
						GC.Name = 'EU Development' 
					THEN
						COALESCE(LocalPayrollMapping.EUDevelopmentGLCategorizationHierarchyKey, LocalOverheadMapping.EUDevelopmentGLCategorizationHierarchyKey, @GLCategorizationHierarchyKeyUnknown)
					WHEN
						GC.Name = 'Global'
					THEN
						COALESCE(GlobalMapping.GlobalGLCategorizationHierarchyKey, UnknownMapping.GLCategorizationHierarchyKey, @UnknownGlobalGLCategorizationKey)
					ELSE
						@GLCategorizationHierarchyKeyUnknown
				END
				
			ELSE @GLCategorizationHierarchyKeyUnknown
		END, --  ReportingGLCategorizationHierarchyKey
		
		SSystem.SourceSystemKey
	FROM
		#ProfitabilityPayrollMapping pbm

		LEFT OUTER JOIN Gdm.[Snapshot] SShot ON
			pbm.SnapshotId = SSHot.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON
			pbm.SourceCode = GrSc.SourceCode  

		LEFT OUTER JOIN GrReporting.dbo.SourceSystem SSystem ON
			pbm.SourceTableName = SSystem.SourceTableName AND
			SSystem.SourceSystemName = 'TapasGlobalBudgeting'

		--Parent Level (No job code for payroll)
		LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdm ON
			SShot.LastSyncDate BETWEEN GrFdm.StartDate AND GrFdm.EndDate AND
			GrFdm.SubFunctionalDepartmentCode = GrFdm.FunctionalDepartmentCode AND
			pbm.FunctionalDepartmentCode = GrFdm.FunctionalDepartmentCode  

		LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
			CASE WHEN pbm.Reimbursable = 1 THEN 'YES' ELSE 'NO' END = GrRi.ReimbursableCode

		LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
			pbm.ActivityTypeId = GrAt.ActivityTypeId AND
			pbm.SnapshotId = GrAt.SnapshotId  

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
			pbm.SnapshotId = GrPf.SnapshotId  

		LEFT OUTER JOIN Gdm.SnapshotAllocationSubRegion ASR ON
			pbm.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId AND
			pbm.SnapshotId  = ASR.SnapshotId AND
			ASR.IsActive = 1  

		LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
			ASR.AllocationSubRegionGlobalRegionId = GrAr.GlobalRegionId AND
			pbm.SnapshotId = GrAr.SnapshotId  

		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion CSR ON -- CC16
			pbm.ConsolidationSubRegionGlobalRegionId = CSR.GlobalRegionId AND
			pbm.SnapshotId = CSR.SnapshotId AND
			CSR.IsConsolidationRegion = 1 AND
			CSR.IsActive = 1

		LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrCr ON -- CC16
			CSR.GlobalRegionId = GrCr.GlobalRegionId AND
			pbm.SnapshotId = GrCr.SnapshotId  

		LEFT OUTER JOIN Gdm.SnapshotOriginatingRegionCorporateEntity ORCE ON
			pbm.OriginatingRegionCode = ORCE.CorporateEntityCode  AND
			pbm.OriginatingRegionSourceCode = ORCE.SourceCode  AND
			pbm.SnapshotId  = ORCE.SnapshotId

		LEFT OUTER JOIN Gdm.SnapshotOriginatingRegionPropertyDepartment ORPD ON
			pbm.OriginatingRegionCode = ORPD.PropertyDepartmentCode AND
			pbm.OriginatingRegionSourceCode = ORPD.SourceCode AND
			pbm.SnapshotId = ORPD.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
			ISNULL(ORCE.GlobalRegionId, ORPD.GlobalRegionId) = GrOr.GlobalRegionId AND
			pbm.SnapshotId = GrOr.SnapshotId  

		LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
			pbm.LocalCurrencyCode = GrCu.CurrencyCode

		LEFT OUTER JOIN Gdm.SnapshotGLMinorCategoryPayrollType MCPT ON
			pbm.MinorGlAccountCategoryId = MCPT.GLMinorCategoryId AND
			pbm.SnapshotId = MCPT.SnapshotId  

		LEFT OUTER JOIN #FunctionalDepartment FD ON
			pbm.FunctionalDepartmentCode = FD.GlobalCode 

		LEFT OUTER JOIN #GlobalGLCategorizationMapping GlobalMapping ON
			pbm.SnapshotId = GlobalMapping.SnapshotId  AND
			pbm.GlobalGlAccountCode = GlobalMapping.GlGlobalAccountCode AND
			pbm.MinorGlAccountCategoryId = GlobalMapping.GLMinorCategoryId AND
			pbm.MajorGlAccountCategoryId = GlobalMapping.GLMajorCategoryId  

		LEFT OUTER JOIN  #LocalPayrollGLCategorizationMapping LocalPayrollMapping ON
			FD.FunctionalDepartmentId = LocalPayrollMapping.FunctionalDepartmentId AND
			pbm.ActivityTypeId = LocalPayrollMapping.ActivityTypeId AND
			MCPT.PayrollTypeId = LocalPayrollMapping.PayrollTypeId AND
			pbm.MinorGlAccountCategoryId  = LocalPayrollMapping.GlobalGLMinorCategoryId AND
			pbm.SnapshotId = LocalPayrollMapping.SnapshotId AND
			pbm.IsCorporateOverheadOverhead = 0 -- Only records that aren't Corporate Overhead records

		LEFT OUTER JOIN #LocalOverheadGLCategorizationMapping LocalOverheadMapping ON
			FD.FunctionalDepartmentId = LocalOverheadMapping.FunctionalDepartmentId  AND
			pbm.ActivityTypeId = LocalOverheadMapping.ActivityTypeId AND
			pbm.SnapshotId = LocalOverheadMapping.SnapshotId AND
			pbm.IsCorporateOverheadOverhead = 1 -- Corporate Overhead records only

		LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy UnknownMapping ON
			pbm.SnapshotId = UnknownMapping.SnapshotId AND
			pbm.GlobalGlAccountCode = UnknownMapping.GLAccountCode AND
			UnknownMapping.GLCategorizationName = 'Global' AND
			UnknownMapping.GLMajorCategoryName = 'UNKNOWN'

		LEFT OUTER JOIN Gdm.SnapshotPropertyFund PF ON
			pbm.SnapshotId = PF.SnapshotID AND
			pbm.PropertyFundId = PF.PropertyFundId 

		LEFT OUTER JOIN Gdm.SnapshotReportingCategorization RC ON
			pbm.SnapshotId = RC.SnapshotId AND
			pbm.AllocationSubRegionGlobalRegionId = RC.AllocationSubRegionGlobalRegionId AND
			PF.EntityTypeId = RC.EntityTypeId  

		LEFT OUTER JOIN Gdm.SnapshotGLCategorization GC ON
			RC.SnapshotId = GC.SnapshotId AND
			RC.GLCategorizationId = GC.GLCategorizationId  

	PRINT 'Completed inserting records into #ProfitabilityBudget: '+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProfitabilityBudget (ReferenceCode)

	PRINT 'Completed creating indexes on #OriginatingRegionMapping'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END

/* ===============================================================================================================================================
	9.	Insert records with unknowns into the ProfitabilityBudgetUnknowns table.
   ============================================================================================================================================= */
BEGIN

	SET @StartTime = GETDATE()

	DELETE
		dbo.ProfitabilityBudgetUnknowns
	WHERE
		BudgetReforecastTypeKey = @BudgetReforecastTypeKey

	INSERT INTO dbo.ProfitabilityBudgetUnknowns
	(
		ImportBatchId,
		CalendarKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		PropertyFundKey,
		AllocationRegionKey,
		ConsolidationRegionKey, -- CC16
		OriginatingRegionKey,
		LocalCurrencyKey,
		LocalBudget,
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
		b.ImportBatchId,
		pb.CalendarKey,
		pb.SourceKey,
		pb.FunctionalDepartmentKey,
		pb.ReimbursableKey,
		pb.ActivityTypeKey,
		pb.PropertyFundKey,
		pb.AllocationRegionKey,
		pb.ConsolidationRegionKey,
		pb.OriginatingRegionKey,
		pb.LocalCurrencyKey,
		pb.LocalBudget,
		pb.ReferenceCode,
		
		pb.GlobalGLCategorizationHierarchyKey,
		pb.USPropertyGLCategorizationHierarchyKey,
		pb.USFundGLCategorizationHierarchyKey,
		pb.EUPropertyGLCategorizationHierarchyKey,
		pb.EUFundGLCategorizationHierarchyKey,
		pb.USDevelopmentGLCategorizationHierarchyKey,
		pb.EUDevelopmentGLCategorizationHierarchyKey,
		pb.ReportingGLCategorizationHierarchyKey,
		
		pb.BudgetId,
		pb.OverheadKey,
		@NormalFeeAdjustmentKey AS FeeAdjustmentKey,	
		BudgetReforecastTypeKey,
		pb.SnapshotId,
		
		pb.SourceSystemKey
	FROM 
		#ProfitabilityBudget pb
		INNER JOIN #Budget b ON
			pb.BudgetId = b.BudgetId	
	WHERE	
		@SourceKey = pb.SourceKey OR
		@FunctionalDepartmentKey = pb.FunctionalDepartmentKey OR
		@ReimbursableKey = pb.ReimbursableKey OR
		@ActivityTypeKey = pb.ActivityTypeKey OR
		@PropertyFundKey = pb.PropertyFundKey OR
		@AllocationRegionKey = pb.AllocationRegionKey OR
		@OriginatingRegionKey = pb.OriginatingRegionKey OR
		@LocalCurrencyKey = pb.LocalCurrencyKey OR
		@GLCategorizationHierarchyKeyUnknown = GlobalGLCategorizationHierarchyKey

	PRINT 'Completed inserting records into ProfitabilityBudgetUnknowns: ' + CONVERT(CHAR(10), @@ROWCOUNT)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	/******* Remove rows from staging import batch which are associated with budgets with unknowns ******/
	SET @StartTime = GETDATE()

	CREATE TABLE #DeletingBudget
	(
		BudgetId INT NOT NULL
	)

	INSERT INTO #DeletingBudget
	(
		BudgetId
	)
	SELECT DISTINCT 
		BudgetId
	FROM
		dbo.ProfitabilityBudgetUnknowns

	SET @RowCount = @@ROWCOUNT
	PRINT 'Completed inserting records into #DeletingBudget: ' + CONVERT(CHAR(10), @RowCount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	IF (@RowCount > 0)
	BEGIN
		INSERT INTO @ImportErrorTable (Error) SELECT 'Unknowns found in budget'
	END

	CREATE TABLE #BudgetsToImportOriginal
	(   -- we keep an original copy of the budgets to insert because #BudgetsToImport will always be empty after the loop below
		BudgetId INT NOT NULL
	)
	INSERT INTO #BudgetsToImportOriginal
	(
		BudgetId
	)
	SELECT DISTINCT 
		BudgetId
	FROM
		#ProfitabilityBudget

	CREATE TABLE #BudgetsToImport
	(
		BudgetId INT NOT NULL
	)
	INSERT INTO #BudgetsToImport
	(
		BudgetId
	)
	SELECT
		BudgetId
	FROM
		#BudgetsToImportOriginal

END

/* ================================================================================================================================================
	10. Insert budget records into the GrReporting.dbo.ProfitabilityBudget table
   ============================================================================================================================================= */
BEGIN

	SET @StartTime = GETDATE()

	CREATE TABLE #SummaryOfChanges
	(
		Change VARCHAR(20)
	)
	INSERT INTO #SummaryOfChanges
	(
		Change
	)
	SELECT
		Change
	FROM
	(
		MERGE 
			GrReporting.dbo.ProfitabilityBudget FACT
		USING
			#ProfitabilityBudget AS SRC ON
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
				FACT.LocalBudget <> SRC.LocalBudget OR
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
				FACT.LocalBudget = SRC.LocalBudget,
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
				LocalBudget,
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
				SRC.LocalBudget,
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
			FACT.BudgetId IN (SELECT BudgetId FROM #BudgetsToImport) AND
			FACT.BudgetReforecastTypeKey = @BudgetReforecastTypeKey
		THEN
			DELETE
		OUTPUT
				$action AS Change
	) AS InsertedData

	CREATE NONCLUSTERED INDEX UX_SummaryOfChanges_Change ON #SummaryOfChanges(Change)

	DECLARE @InsertedRows INT = (SELECT COUNT(*) FROM #SummaryOfChanges WHERE Change = 'INSERT')
	DECLARE @UpdatedRows INT = (SELECT COUNT(*) FROM #SummaryOfChanges WHERE Change = 'UPDATE')
	DECLARE @DeletedRows INT = (SELECT COUNT(*) FROM #SummaryOfChanges WHERE Change = 'DELETE')

	PRINT 'Rows added to ProfitabilityBudget: '+ CONVERT(char(10), @InsertedRows)
	PRINT 'Rows updated in ProfitabilityBudget: '+ CONVERT(char(10),@UpdatedRows)
	PRINT 'Rows deleted from ProfitabilityBudget: '+ CONVERT(char(10),@DeletedRows)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END

/* ================================================================================================================================================
	11. Mark budgets as being successfully processed into the warehouse
   ============================================================================================================================================= */
BEGIN

	UPDATE
		BTP
	SET
		OriginalBudgetProcessedIntoWarehouse = 1,
		DateBudgetProcessedIntoWarehouse = GETDATE()
	FROM
		dbo.BudgetsToProcess BTP
		INNER JOIN #BudgetsToProcess BTPTemp ON
			BTP.BudgetsToProcessId = BTPTemp.BudgetsToProcessId		
	
	PRINT ('Rows updated from dbo.BudgetsToProcess: ' + CONVERT(VARCHAR(10), @@rowcount))

END

/* ================================================================================================================================================
	12. Clean Up
   ============================================================================================================================================= */
BEGIN

	IF OBJECT_ID('tempdb..#BudgetsToProcess') IS NOT NULL
		DROP TABLE #BudgetsToProcess

	IF OBJECT_ID('tempdb..#SystemSettingRegion') IS NOT NULL
		DROP TABLE #SystemSettingRegion

	IF OBJECT_ID('tempdb..#BudgetAllocationSetSnapshots') IS NOT NULL
		DROP TABLE #BudgetAllocationSetSnapshots

	IF OBJECT_ID('tempdb..#Budget') IS NOT NULL
		DROP TABLE #Budget

	IF OBJECT_ID('tempdb..#BudgetProject') IS NOT NULL
		DROP TABLE #BudgetProject

	IF OBJECT_ID('tempdb..#Region') IS NOT NULL
		DROP TABLE #Region

	IF OBJECT_ID('tempdb..#BudgetEmployee') IS NOT NULL
		DROP TABLE #BudgetEmployee

	IF OBJECT_ID('tempdb..#BudgetEmployeeFunctionalDepartment') IS NOT NULL
		DROP TABLE #BudgetEmployeeFunctionalDepartment

	IF OBJECT_ID('tempdb..#Location') IS NOT NULL
		DROP TABLE #Location

	IF OBJECT_ID('tempdb..#RegionExtended') IS NOT NULL
		DROP TABLE #RegionExtended

	IF OBJECT_ID('tempdb..#Project') IS NOT NULL
		DROP TABLE #Project

	IF OBJECT_ID('tempdb..#BudgetEmployeePayrollAllocation') IS NOT NULL
		DROP TABLE #BudgetEmployeePayrollAllocation

	IF OBJECT_ID('tempdb..#BudgetEmployeePayrollAllocationDetail') IS NOT NULL
		DROP TABLE #BudgetEmployeePayrollAllocationDetail

	IF OBJECT_ID('tempdb..#BudgetTaxType') IS NOT NULL
		DROP TABLE #BudgetTaxType

	IF OBJECT_ID('tempdb..#TaxType') IS NOT NULL
		DROP TABLE #TaxType

	IF OBJECT_ID('tempdb..#EmployeePayrollAllocationDetail') IS NOT NULL
		DROP TABLE #EmployeePayrollAllocationDetail

	IF OBJECT_ID('tempdb..#BudgetOverheadAllocation') IS NOT NULL
		DROP TABLE #BudgetOverheadAllocation

	IF OBJECT_ID('tempdb..#BudgetOverheadAllocationDetail') IS NOT NULL
		DROP TABLE #BudgetOverheadAllocationDetail

	IF OBJECT_ID('tempdb..#OverheadAllocationDetail') IS NOT NULL
		DROP TABLE #OverheadAllocationDetail

	IF OBJECT_ID('tempdb..#EffectiveFunctionalDepartment') IS NOT NULL
		DROP TABLE #EffectiveFunctionalDepartment

	IF OBJECT_ID('tempdb..#ProfitabilityPreTaxSource') IS NOT NULL
		DROP TABLE #ProfitabilityPreTaxSource

	IF OBJECT_ID('tempdb..#ProfitabilityTaxSource') IS NOT NULL
		DROP TABLE #ProfitabilityTaxSource

	IF OBJECT_ID('tempdb..#ProfitabilityOverheadSource') IS NOT NULL
		DROP TABLE #ProfitabilityOverheadSource

	IF OBJECT_ID('tempdb..#ProfitabilityPayrollMapping') IS NOT NULL
		DROP TABLE #ProfitabilityPayrollMapping

	IF OBJECT_ID('tempdb..#ProfitabilityBudget') IS NOT NULL
		DROP TABLE #ProfitabilityBudget

	IF OBJECT_ID('tempdb..#DeletingBudget') IS NOT NULL
		DROP TABLE #DeletingBudget

	IF OBJECT_ID('tempdb..#BudgetsToImportOriginal') IS NOT NULL
		DROP TABLE #BudgetsToImportOriginal

	IF OBJECT_ID('tempdb..#GlobalCategoryLookup') IS NOT NULL
		DROP TABLE #GlobalCategoryLookup

	IF OBJECT_ID('tempdb..#BudgetsToProcess') IS NOT NULL
		DROP TABLE #BudgetsToProcess

	IF OBJECT_ID('tempdb..#DistinctImports') IS NOT NULL
		DROP TABLE #DistinctImports

	IF OBJECT_ID('tempdb..#GlGlobalAccount') IS NOT NULL
		DROP TABLE #GlGlobalAccount

END

GO



