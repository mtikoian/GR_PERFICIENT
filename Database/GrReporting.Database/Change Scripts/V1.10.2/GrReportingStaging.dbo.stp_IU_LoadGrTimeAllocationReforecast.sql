USE [GrReportingStaging]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrTimeAllocationReforecast]    Script Date: 07/19/2012 03:09:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrTimeAllocationReforecast]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrTimeAllocationReforecast]
GO

USE [GrReportingStaging]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrTimeAllocationReforecast]    Script Date: 07/19/2012 03:09:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/***************************************************************************************************************************************
Description
	This stored procedure processes payroll original budget data and uploads it to the
	TimeAllocationReforecast table in the data warehouse (GrReporting.dbo.TimeAllocationReforecast). 
	The stored procedure works as follows:
	1.	Source budgets that are to be processed from the BudgetsToProcessTable
	2.	Source Budgets from TapasGlobalBudgeting.Budget table
	3.	Source records associated to the Payroll Allocation data (e.g. BudgetProject and BudgetEmployee)
	4.	Source Payroll Allocation Data from TAPAS Global Budgeting
	5.	Map the Pre-Tax, Tax and Overhead data to their associated records (step 4) from Tapas Global Budgeting

	8.	Map table to the #TimeAllocationReforecast table with the same structure as the GrReporting.dbo.TimeAllocationReforecast table
	--9.	Insert records with unknowns into the ProfitabilityBudgetUnknowns table.
	10. Insert budget records into the GrReporting.dbo.TimeAllocationReforecast table
	--11. Mark budgets as being successfully processed into the warehouse
	12. Clean Up
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-07-06		: MChen		:	Create. 	
****************************************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_LoadGrTimeAllocationReforecast]	
	@DataPriorToDate	DateTime=NULL
AS

SET NOCOUNT ON

--declare @DataPriorToDate	DateTime=NULL
PRINT '####'
PRINT 'stp_IU_LoadGrTimeAllocationReforecast'

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

	IF ((SELECT ConfiguredValue FROM GrReportingStaging.dbo.SSISConfigurations WHERE ConfigurationFilter = 'CanImportTimeAllocationReforecast') = 0)
	BEGIN
		PRINT ('Import Tapas Time Allocation Reforecast not scheduled in SSISConfigurations')
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
		
		BTPC.IsReforecast = 1 AND
		BTPC.IsCurrentBatch = 1 AND  
		BTPC.BudgetReforecastTypeName = 'TGB Budget/Reforecast'

	PRINT 'Completed inserting records into #BudgetsToProcess: '+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	-- If there are no TAPAS budgets from the BudgetsToProcess table, the stored procedure ends.

	IF NOT EXISTS (SELECT 1 FROM #BudgetsToProcess)
	BEGIN
		PRINT ('*******************************************************')
		PRINT ('	stp_IU_LoadGrTimeAllocationReforecast is quitting because there are no TAPAS budgets set to be imported.')
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
		@PropertyFundKey		 INT = (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFundFTE WHERE PropertyFundName = 'UNKNOWN'),
		@ReportingEntityKey		 INT = (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = 'UNKNOWN'),
		@AllocationRegionKey	 INT = (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = 'UNKNOWN'),
		@OriginatingRegionKey	 INT = (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = 'UNKNOWN'),
		--@OverheadKey			 INT = (SELECT OverheadKey From GrReporting.dbo.Overhead Where OverheadCode = 'UNKNOWN'),
		@LocalCurrencyKey		 INT = (SELECT CurrencyKey FROM GrReporting.dbo.Currency WHERE CurrencyCode = 'UNK'),
		--@NormalFeeAdjustmentKey	 INT = (SELECT FeeAdjustmentKey FROM GrReporting.dbo.FeeAdjustment WHERE FeeAdjustmentCode = 'NORMAL'),
		--@GLCategorizationHierarchyKeyUnknown INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'UNKNOWN' AND SnapshotId = 0)
		@ProjectKey				INT = -1,
		@ProjectGroupKey		INT = -1,
		@EmployeeKey			INT = -1
	

		
	DECLARE @BudgetReforecastTypeKey INT = 
		(
			SELECT 
				BudgetReforecastTypeKey 
			FROM 
				GrReporting.dbo.BudgetReforecastType 
			WHERE 
				BudgetReforecastTypeCode = 'TGBBUD'
		)
	DECLARE @ReforecastTypeIsTGBBUDKey INT = (SELECT BudgetReforecastTypeKey from GrReporting.dbo.BudgetReforecastType WHERE BudgetReforecastTypeCode = 'TGBBUD')
	DECLARE @ReforecastTypeIsTGBACTKey INT = (SELECT BudgetReforecastTypeKey from GrReporting.dbo.BudgetReforecastType WHERE BudgetReforecastTypeCode = 'TGBACT')


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
		FirstProjectedPeriod INT NULL,
		CurrencyCode VARCHAR(3) NOT NULL,
		BudgetReportGroupId INT NOT NULL,
		BudgetReportGroupPeriod	INT NOT NULL,
		GroupStartPeriod INT NOT NULL,
		GroupEndPeriod INT NOT NULL,
		MustImportAllActualsIntoWarehouse BIT NOT NULL,
		ReforecastKey INT NOT NULL
	)

	INSERT INTO #Budget
	(
		SnapshotId,	
		ImportKey,
		ImportBatchId,
		BudgetId,
		RegionId,	
		FirstProjectedPeriod,
		CurrencyCode,
		BudgetReportGroupId,
		BudgetReportGroupPeriod,
		GroupStartPeriod,
		GroupEndPeriod,
		MustImportAllActualsIntoWarehouse,
		ReforecastKey
		
	)
	SELECT 		
		btp.SnapshotId,
		Budget.ImportKey,
		Budget.ImportBatchId,
		Budget.BudgetId,
		Budget.RegionId,
		Budget.FirstProjectedPeriod,
		Budget.CurrencyCode,		
		brg.BudgetReportGroupId,
		brgp.Period AS BudgetReportGroupPeriod,
		brg.StartPeriod AS GroupStartPeriod,
		brg.EndPeriod AS GroupEndPeriod,
		btp.MustImportAllActualsIntoWarehouse,
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
	3.	Source records associated to the Payroll Allocation data (e.g. BudgetProject, BudgetEmployee, BudgetPrjectGroup)
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


	-------------------------------------------------------------------------------------------
	
	CREATE TABLE #BudgetProjectGroup
	(
		ImportBatchId INT NOT NULL,
		BudgetProjectGroupId INT NOT NULL,
		BudgetId INT NOT NULL,
		ProjectGroupId INT NULL
	)

	INSERT INTO #BudgetProjectGroup
	(
		ImportBatchId,
		BudgetProjectGroupId,
		BudgetId,
		ProjectGroupId
	)
	SELECT 
		BudgetProjectGroup.ImportBatchId,
		BudgetProjectGroup.BudgetProjectGroupId,
		BudgetProjectGroup.BudgetId,
		BudgetProjectGroup.ProjectGroupId
	
	FROM 
		TapasGlobalBudgeting.BudgetProjectGroup BudgetProjectGroup
			
		-- Limits records to those associated with budgets currently being processed
		INNER JOIN #Budget Budget ON
			BudgetProjectGroup.BudgetId = Budget.BudgetId AND
			BudgetProjectGroup.ImportBatchId = Budget.ImportBatchId

	PRINT 'Completed inserting records into #BudgetProjectGroup: '+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE CLUSTERED INDEX IX_ImportBatchId_BudgetID ON #BudgetProjectGroup (ImportBatchId, BudgetId)
	PRINT 'Completed creating indexes on #BudgetProjectGroup'
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
		case when BudgetEmployee.HrEmployeeId is null 
		then BudgetEmployee.BudgetEmployeeId else BudgetEmployee.HrEmployeeId end,

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
		The #Project table is used to get Property Fund and Activity Type information 
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

	

END

/* ===============================================================================================================================================
	4.	Source Payroll Data from TAPAS Global Budgeting
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
		SalaryAllocationValue DECIMAL(18, 12) NOT NULL,
		BonusAllocationValue DECIMAL(18, 12) NULL,
		BonusCapAllocationValue DECIMAL(18, 12) NULL,
		ProfitShareAllocationValue DECIMAL(18, 12) NULL,
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

	--CREATE UNIQUE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationId ON #BudgetEmployeePayrollAllocation (ImportBatchId, BudgetEmployeePayrollAllocationId)
	CREATE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocation_BudgetProject ON #BudgetEmployeePayrollAllocation(BudgetProjectId, ImportBatchId, Period)

	PRINT 'Completed creating indexes on #BudgetEmployeePayrollAllocation'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

    --debug
    --select * into debug._BudgetEmployeePayrollAllocation from #BudgetEmployeePayrollAllocation
	---------------------------------------------------------------------
	-- Source payroll tax detail
		
	SET @StartTime = GETDATE()

	CREATE TABLE #BudgetEmployeePayrollAllocationDetail
	(
		--ImportKey INT NOT NULL,
		--ImportBatchId INT NOT NULL,
		--ImportDate DATETIME NOT NULL,
		--BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
		BudgetEmployeePayrollAllocationId INT NOT NULL,
		TaxBenefitAmount DECIMAL(18, 2) NULL,
		--BenefitOptionId INT NULL,
		--BudgetTaxTypeId INT NULL,
		--SalaryAmount DECIMAL(18, 2) NULL,
		--BonusAmount DECIMAL(18, 2) NULL,
		--ProfitShareAmount DECIMAL(18, 2) NULL,
		--BonusCapExcessAmount DECIMAL(18, 2) NULL,
		--InsertedDate DATETIME NOT NULL,
		--UpdatedDate DATETIME NOT NULL,
		--UpdatedByStaffId INT NOT NULL,
		SnapshotId INT NOT NULL
	)

	INSERT INTO #BudgetEmployeePayrollAllocationDetail
	(
		--ImportKey,
		--ImportBatchId,
		--ImportDate,
		--BudgetEmployeePayrollAllocationDetailId,
		BudgetEmployeePayrollAllocationId,
		TaxBenefitAmount,
		--BenefitOptionId,
		--BudgetTaxTypeId,
		--SalaryAmount,
		--BonusAmount,
		--ProfitShareAmount,
		--BonusCapExcessAmount,
		--InsertedDate,
		--UpdatedDate,
		--UpdatedByStaffId,
		SnapshotId
	)
	SELECT
		--TaxDetail.ImportKey,
		--TaxDetail.ImportBatchId,
		--TaxDetail.ImportDate,
		--TaxDetail.BudgetEmployeePayrollAllocationDetailId,
		Allocation.BudgetEmployeePayrollAllocationId,
		SUM(ISNULL(TaxDetail.SalaryAmount,0.0)+
			ISNULL(TaxDetail.ProfitShareAmount, 0.0)+
			ISNULL(TaxDetail.BonusAmount,0.0) +
			ISNULL(TaxDetail.BonusCapExcessAmount,0.0)
		),
		--TaxDetail.BenefitOptionId,
		--TaxDetail.BudgetTaxTypeId,
		--TaxDetail.SalaryAmount,
		--TaxDetail.BonusAmount,
		--TaxDetail.ProfitShareAmount,
		--TaxDetail.BonusCapExcessAmount,
		--TaxDetail.InsertedDate,
		--TaxDetail.UpdatedDate,
		--TaxDetail.UpdatedByStaffId,
		Allocation.SnapshotId
	FROM
		TapasGlobalBudgeting.BudgetEmployeePayrollAllocationDetail TaxDetail
		
		-- Limits the data to records associated with the budgets currently being processed.
		INNER JOIN #BudgetEmployeePayrollAllocation Allocation ON
			TaxDetail.ImportBatchId = Allocation.ImportBatchId AND
			TaxDetail.BudgetEmployeePayrollAllocationId = Allocation.BudgetEmployeePayrollAllocationId  
	Group by Allocation.SnapshotId , Allocation.BudgetEmployeePayrollAllocationId


	PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocationDetail: '+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	--CREATE UNIQUE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationDetailId ON #BudgetEmployeePayrollAllocationDetail (ImportBatchId, BudgetEmployeePayrollAllocationDetailId)

CREATE UNIQUE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationId
ON #BudgetEmployeePayrollAllocationDetail  ([BudgetEmployeePayrollAllocationId])
--INCLUDE ([SalaryAmount],[BonusAmount],[ProfitShareAmount],[BonusCapExcessAmount])
	PRINT 'Completed creating indexes on #BudgetEmployeePayrollAllocationDetail'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	
	

END

/* ===============================================================================================================================================
	5.	Map the Pre-Tax, Tax data to their associated records (step 4) from Tapas Global Budgeting
   ============================================================================================================================================= */
BEGIN  --todo
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
		BudgetProjectId INT NOT NULL,
		BudgetProjectGroupId INT NOT NULL,
		BudgetEmployeeId INT NOT NULL,
		BudgetEmployeePayrollAllocationId INT NOT NULL,
		ReferenceCode VARCHAR(300) NOT NULL,
		ExpensePeriod CHAR(6) NOT NULL,	
		ExpenseDate datetime NOT NULL,
		SourceCode VARCHAR(2) NULL,
		BudgetAllocatedAmount MONEY NOT NULL,
		BudgetAllocatedFTE decimal(18,12) NOT NULL,
		FunctionalDepartmentId INT NOT NULL,
		FunctionalDepartmentCode VARCHAR(31) NULL,
		Reimbursable BIT NULL,
		ActivityTypeId INT NOT NULL,
		ActivityTypeCode Varchar(50) NOT NULL,
		PropertyFundId INT NOT NULL,
		ReportingEntityId INT NOT NULL,
		BudgetOwnerStaffId INT NOT NULL,
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
		BudgetProjectId,
		BudgetProjectGroupId,
		BudgetEmployeeId,
		BudgetEmployeePayrollAllocationId,
		ReferenceCode,
		ExpensePeriod,
		ExpenseDate,
		SourceCode,
		BudgetAllocatedAmount,
		BudgetAllocatedFTE,

		FunctionalDepartmentId,
		FunctionalDepartmentCode,
		Reimbursable,
		ActivityTypeId,
		ActivityTypeCode,
		PropertyFundId,
		ReportingEntityId,
		BudgetOwnerStaffId,
		AllocationSubRegionGlobalRegionId,
		ConsolidationSubRegionGlobalRegionId,
		OriginatingRegionCode,
		OriginatingRegionSourceCode,
		LocalCurrencyCode,
		AllocationUpdatedDate,
		BudgetReportGroupPeriod,
		
		SourceTableName

	)
	--declare @BudgetReforecastTypeKey int =1
	SELECT 
		Budget.ImportBatchId,
		@BudgetReforecastTypeKey,
		Budget.ReforecastKey,
		Budget.SnapshotId,
		Budget.BudgetId AS BudgetId,
		Budget.RegionId AS BudgetRegionId,
		ISNULL(BudgetProject.BudgetProjectId,-1) AS BudgetProjectId,
		ISNULL(BudgetProjectGroup.BudgetProjectGroupId,-1) AS BudgetProjectGroupId,
		BudgetEmployee.BudgetEmployeeId,

		Allocation.BudgetEmployeePayrollAllocationId,
		'TGB:BudgetId=' + CONVERT(varchar,Budget.BudgetId) + 
		'&BudgetProjectId=' + CONVERT(varchar,ISNULL(BudgetProject.BudgetProjectId,-1)) + 
		'&BudgetEmployeeId=' + CONVERT(varchar,ISNULL(BudgetEmployee.BudgetEmployeeId,-1)) + 
		'&BudgetEmployeePayrollAllocationId=' + CONVERT(varchar,Allocation.BudgetEmployeePayrollAllocationId)  AS ReferenceCode,
		Allocation.Period AS ExpensePeriod,
		LEFT(Allocation.Period, 4) + '-' + RIGHT(Allocation.Period, 2) + '-01' AS ExpenseDate,
		SourceRegion.SourceCode,

		--PretaxAmount
		ISNULL(Allocation.PreTaxSalaryAmount,0.0)+
		ISNULL(Allocation.PreTaxProfitShareAmount, 0.0)+
		ISNULL(Allocation.PreTaxBonusAmount,0.0) +
		ISNULL(Allocation.PreTaxBonusCapExcessAmount,0.0)+
		--TaxAmount+benefit
		ISNULL(AllocationDetail.TaxBenefitAmount,0.0) AS BudgetAllocatedAmount,

		ISNULL(Allocation.SalaryAllocationValue,0.0)
		--+ISNULL(Allocation.ProfitShareAllocationValue, 0.0)
		--+ISNULL(Allocation.BonusAllocationValue,0.0) 
		--+ISNULL(Allocation.BonusCapAllocationValue,0.0) 
			AS BudgetAllocatedFTE,
		
		
		ISNULL(EFD.FunctionalDepartmentId, -1),
		fd.GlobalCode AS FunctionalDepartmentCode, 
		CASE WHEN BudgetProject.IsTsCost = 0 THEN 1 ELSE 0 END AS Reimbursable, -- CC 4 :: GC
		--CASE WHEN Dept.IsTsCost = 0 THEN 1 ELSE 0 END Reimbursable,
		BudgetProject.ActivityTypeId,
		Att.ActivityTypeCode,
		
			/*
				When selecting a Property Fund, the first option is is the Property Fund assigned to the Corporate Department of
				the Project - DepartmentPropertyFund. If the CorporateDepartmentCode field of the project is NULL or '@', the
				next option is the project's PropertyFundId field - the ProjectPropertyFund.
			*/
			
		ISNULL( ProjectPropertyFund.PropertyFundId, -1) AS PropertyFundId,
		ISNULL( RECD.PropertyFundId , -1) AS ReportingEntityId,
		ISNULL( ReportingEntity.BudgetOwnerStaffId, -1) AS BudgetOwnerStaffId,
		--Allocation Region is related to ReportingEntity
		ISNULL( ReportingEntity.AllocationSubRegionGlobalRegionId, -1) AS AllocationSubRegionGlobalRegionId,
		ISNULL(ConsolidationRegion.GlobalRegionId, -1) AS ConsolidationSubRegionGlobalRegionId,
		OriginatingRegion.CorporateEntityRef,
		OriginatingRegion.CorporateSourceCode,
		Budget.CurrencyCode AS LocalCurrencyCode,
		Allocation.UpdatedDate,
		Budget.BudgetReportGroupPeriod,
		
		'BudgetEmployeePayrollAllocation'

	FROM
	--select * from #BudgetEmployeePayrollAllocation 
		#BudgetEmployeePayrollAllocation Allocation -- tax amount

		INNER JOIN #BudgetProject BudgetProject ON 
			Allocation.BudgetProjectId = BudgetProject.BudgetProjectId 
			AND
			Allocation.ImportBatchId = BudgetProject.ImportBatchId

		LEFT JOIN #BudgetProjectGroup BudgetProjectGroup ON 
			Allocation.BudgetProjectGroupId = BudgetProjectGroup.BudgetProjectGroupId 
			AND
			Allocation.ImportBatchId = BudgetProjectGroup.ImportBatchId

		INNER JOIN #Budget Budget ON
			BudgetProject.ImportBatchId = Budget.ImportBatchId AND
			BudgetProject.BudgetId = Budget.BudgetId
		--there are some allocations that have no detail
		LEFT JOIN #BudgetEmployeePayrollAllocationDetail 	AllocationDetail ON
		    Allocation.BudgetEmployeePayrollAllocationId=AllocationDetail.BudgetEmployeePayrollAllocationId
				

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
/*		LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping pfm ON
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
*/
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
		-- Moony: seems the Budget.RegionId equals to PayGroup.RegionId
		-- Used to determine the Originating Region Code and Source Code
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
			
		LEFT JOIN GDM.SnapshotReportingEntityCorporateDepartment RECD ON
			BudgetProject.CorporateDepartmentCode = RECD.CorporateDepartmentCode AND
			BudgetProject.CorporateSourceCode = RECD.SourceCode AND
			Budget.SnapshotId = RECD.SnapshotId
			
			
		LEFT OUTER JOIN Gdm.SnapshotPropertyFund ReportingEntity ON
			RECD.PropertyFundId = ReportingEntity.PropertyFundId AND
			Budget.SnapshotId = ReportingEntity.SnapshotId AND
			ReportingEntity.IsActive = 1
	WHERE
		Allocation.Period BETWEEN Budget.FirstProjectedPeriod AND Budget.GroupEndPeriod 
	/*	
	GROUP BY
		Budget.ImportBatchId,
		Budget.ReforecastKey,
		Budget.SnapshotId,
		Budget.BudgetId,
		Budget.RegionId,
		ISNULL(BudgetProject.BudgetProjectId,-1),
		ISNULL(BudgetEmployee.HrEmployeeId,-1),
		ISNULL(BudgetProjectGroup.BudgetProjectGroupId,-1),
		Allocation.BudgetEmployeePayrollAllocationId,
		'TGB:BudgetId=' + CONVERT(varchar,Budget.BudgetId) + '&BudgetProjectId=' + CONVERT(varchar,ISNULL(BudgetProject.BudgetProjectId,-1)) + '&BudgetEmployeeId=' + CONVERT(varchar,ISNULL(BudgetEmployee.BudgetEmployeeId,-1)) + '&BudgetEmployeePayrollAllocationId=' + CONVERT(varchar,Allocation.BudgetEmployeePayrollAllocationId),
		Allocation.Period ,
		SourceRegion.SourceCode,
		
		--PretaxAmount
		ISNULL(Allocation.PreTaxSalaryAmount,0.0)+
		ISNULL(Allocation.PreTaxProfitShareAmount, 0.0)+
		ISNULL(Allocation.PreTaxBonusAmount,0.0) +
		ISNULL(Allocation.PreTaxBonusCapExcessAmount,0.0),

		ISNULL(Allocation.SalaryAllocationValue,0.0)+
		ISNULL(Allocation.ProfitShareAllocationValue, 0.0)+
		ISNULL(Allocation.BonusAllocationValue,0.0) +
		ISNULL(Allocation.BonusCapAllocationValue,0.0),

		ISNULL(EFD.FunctionalDepartmentId, -1),
		fd.GlobalCode, 
		CASE WHEN BudgetProject.IsTsCost = 0 THEN 1 ELSE 0 END AS Reimbursable, -- CC 4 :: GC
		--CASE WHEN Dept.IsTsCost = 0 THEN 1 ELSE 0 END ,
		BudgetProject.ActivityTypeId,
		Att.ActivityTypeCode,
		ISNULL( ProjectPropertyFund.PropertyFundId, -1),
		ISNULL( RECD.PropertyFundId , -1) ,
		ISNULL( ProjectPropertyFund.AllocationSubRegionGlobalRegionId, -1),
		ISNULL(ConsolidationRegion.GlobalRegionId, -1) ,

		OriginatingRegion.CorporateEntityRef,
		OriginatingRegion.CorporateSourceCode,
		Budget.CurrencyCode ,
		Allocation.UpdatedDate,
		Budget.BudgetReportGroupPeriod
		*/
		
	PRINT 'Completed inserting records into #ProfitabilityPreTaxSource: '+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()


	--CREATE INDEX IX_ProfitabilityPreTaxSource5 ON #ProfitabilityPreTaxSource (BudgetEmployeePayrollAllocationId)

	--PRINT 'Completed creating indexes on #ProfitabilityPreTaxSource'
	--PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

    --debug
 --   select * into debug._ProfitabilityPreTaxSource from #ProfitabilityPreTaxSource
	--return 0
END

/* ===============================================================================================================================================
	8.	Map table to the #TimeAllocationReforecast table with the same structure as the GrReporting.dbo.TimeAllocationReforecast table
   ============================================================================================================================================= */
BEGIN

	SET @StartTime = GETDATE()

	CREATE TABLE #TimeAllocationReforecast

	(
		ImportBatchId INT NOT NULL,
		BudgetReforecastTypeKey INT NOT NULL,
		ReforecastKey INT NOT NULL,
		CalendarKey INT NOT NULL,
		EmployeeKey INT NOT NULL,
		[BudgetOwnerStaff] varchar(255) NULL,
		[ApprovedByStaff] varchar(255) NULL,
		ProjectKey INT NOT NULL,
		ProjectGroupKey INT NOT NULL,
		SourceKey INT NOT NULL,
		FunctionalDepartmentKey INT NOT NULL,
		ReimbursableKey INT NOT NULL,
		ActivityTypeKey INT NOT NULL,
		PropertyFundKey INT NOT NULL,	
		ReportingEntityKey INT NOT NULL,
		AllocationRegionKey INT NOT NULL,
		ConsolidationRegionKey INT NOT NULL,
		OriginatingRegionKey INT NOT NULL,
		Local_NonLocal varchar(10) NOT NULL,
		LocalCurrencyKey INT NOT NULL,
		LocalBudgetAllocatedAmount MONEY NOT NULL,
		BudgetAllocatedFTE decimal(18,12) NOT NULL,
		ReferenceCode Varchar(300) NOT NULL,
		BudgetId INT NOT NULL,
		SnapshotId INT NOT NULL,
	
		SourceSystemKey INT NOT NULL
	
	) 

	INSERT INTO #TimeAllocationReforecast 

	(
		ImportBatchId, 
		BudgetReforecastTypeKey,
		ReforecastKey,
		CalendarKey,
		EmployeeKey,
		BudgetOwnerStaff,
		ApprovedByStaff,
		ProjectKey ,
		ProjectGroupKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		PropertyFundKey,
		ReportingEntityKey,
		AllocationRegionKey,
		ConsolidationRegionKey,
		OriginatingRegionKey,
		Local_NonLocal,
		LocalCurrencyKey,
		LocalBudgetAllocatedAmount,
		BudgetAllocatedFTE,

		ReferenceCode,
		BudgetId,
		SnapshotId,
	
		SourceSystemKey
	)
	SELECT
				
		pbm.ImportBatchId,
		pbm.BudgetReforecastTypeKey,
		pbm.ReforecastKey,
		DATEDIFF(dd, '1900-01-01', LEFT(pbm.ExpensePeriod, 4) + '-' + RIGHT(pbm.ExpensePeriod, 2) + '-01') AS CalendarKey,
		ISNULL(e.EmployeeKey, @EmployeeKey) EmployeeKey,
		ISNULL(BudgetOwner.DisplayName, '') BudgetOwnerStaff,
		'' ApprovedByStaff,
		ISNULL(p.ProjectKey, @ProjectKey) ProjectKey,
		ISNULL(pg.ProjectGroupKey, @ProjectGroupKey) ProjectGroupKey,

		ISNULL(GrSc.SourceKey, @SourceKey) SourceKey,
		ISNULL(GrFdm.FunctionalDepartmentKey, @FunctionalDepartmentKey) FunctionalDepartmentKey,
		ISNULL(GrRi.ReimbursableKey, @ReimbursableKey) ReimbursableKey,
		ISNULL(GrAt.ActivityTypeKey, @ActivityTypeKey) ActivityTypeKey,
		ISNULL(GrPf.PropertyFundKey, @PropertyFundKey) PropertyFundKey,
		ISNULL(GrRe.PropertyFundKey, @ReportingEntityKey) ReportingEntityKey,
		ISNULL(GrAr.AllocationRegionKey, @AllocationRegionKey) AllocationRegionKey,
		ISNULL(Grcr.AllocationRegionKey, @AllocationRegionKey) ConsolidationRegionKey,
		ISNULL(GrOr.OriginatingRegionKey, @OriginatingRegionKey) OriginatingRegionKey,
		ISNULL(GrReporting.dbo.GetLocalNonLocalStr(GrOr.RegionName,GrOr.SubRegionName,GrAr.RegionName,GrAr.SubRegionName),'')  Local_NonLocal,
		ISNULL(GrCu.CurrencyKey, @LocalCurrencyKey) LocalCurrencyKey,
		pbm.BudgetAllocatedAmount,
		pbm.BudgetAllocatedFTE,

		pbm.ReferenceCode,
		pbm.BudgetId,
		pbm.SnapshotId,
		
		SSystem.SourceSystemKey		

	

	FROM
		#ProfitabilityPreTaxSource pbm

		LEFT OUTER JOIN Gdm.[Snapshot] SShot ON
			pbm.SnapshotId = SSHot.SnapshotId
			
			

		LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON
			pbm.SourceCode = GrSc.SourceCode  

		LEFT OUTER JOIN GrReporting.dbo.SourceSystem SSystem ON
			pbm.SourceTableName = SSystem.SourceTableName AND
			SSystem.SourceSystemName = 'TapasGlobalBudgeting'
		
		LEFT JOIN GrReporting.dbo.Project p ON
			pbm.BudgetProjectId=p.BudgetProjectId and pbm.BudgetId=p.BudgetId
			and pbm.AllocationUpdatedDate>=p.StartDate and pbm.AllocationUpdatedDate<p.EndDate
			
			
			
		LEFT JOIN GrReporting.dbo.ProjectGroup pg ON
			pbm.BudgetProjectGroupId=pg.BudgetProjectGroupId and pbm.BudgetId=pg.BudgetId
			and pbm.AllocationUpdatedDate>=pg.StartDate and pbm.AllocationUpdatedDate<pg.EndDate	
					
		LEFT JOIN GrReporting.dbo.Employee e ON
			pbm.BudgetEmployeeId=e.BudgetEmployeeId and pbm.ExpenseDate>=e.StartDate and pbm.ExpenseDate<e.EndDate
			
		LEFT JOIN GrReportingStaging.GACS.Staff BudgetOwner ON
			pbm.BudgetOwnerStaffId=BudgetOwner.StaffId --and  BudgetOwner.StaffId<>-1
			
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


		LEFT OUTER JOIN GrReporting.dbo.PropertyFundFTE GrPf ON
			pbm.PropertyFundId = GrPf.PropertyFundId AND
			pbm.SnapshotId = GrPf.SnapshotId  
			
		LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrRe ON
			pbm.ReportingEntityId = GrRe.PropertyFundId AND
			pbm.SnapshotId = GrRe.SnapshotId  				

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


		LEFT OUTER JOIN #FunctionalDepartment FD ON
			pbm.FunctionalDepartmentCode = FD.GlobalCode 


		LEFT OUTER JOIN Gdm.SnapshotPropertyFund PF ON
			pbm.SnapshotId = PF.SnapshotID AND
			pbm.PropertyFundId = PF.PropertyFundId 
--where pbm.BudgetEmployeePayrollAllocationId=22851789	


    --debug
    --select  * into debug._TimeAllocationReforecast from #TimeAllocationReforecast


--return 0
	PRINT 'Completed inserting reforecast records into #TimeAllocationReforecast: '+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	--CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #TimeAllocationReforecast (ReferenceCode)

	--PRINT 'Completed creating indexes on #TimeAllocationReforecast'
	--PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END



/* ===============================================================================================================================================
	9.	Insert Actuals from the TapasGlobalBudgeting.ReforecastActualBilledPayroll table
   ============================================================================================================================================= */
BEGIN

--declare @DataPriorToDate datetime ='2012-07-31',@StartTime datetime
/*

-------------#ProjectGroupAllocation----------------	
SET @StartTime = GETDATE()
CREATE TABLE #ProjectGroupAllocation
(
	[ProjectGroupAllocationId] [int] NOT NULL,
	[ProjectGroupId] [int] NOT NULL,
	[EffectivePeriod] [int] NOT NULL
)
INSERT #ProjectGroupAllocation
SELECT P.ProjectGroupAllocationId,P.ProjectGroupId,P.EffectivePeriod
FROM TapasGlobal.ProjectGroupAllocation P join TapasGlobal.ProjectGroupAllocationActive(@DataPriorToDate) A 
ON P.ImportKey = A.ImportKey

	PRINT 'Completed inserting records into #ProjectGroupAllocation: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))



CREATE CLUSTERED INDEX IX_#ProjectGroupAllocation_ProjectGroupId ON #ProjectGroupAllocation (ProjectGroupId,EffectivePeriod)

PRINT 'Completed creating indexes on #ProjectGroupAllocation'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-------------#AllocationWeight----------------	
SET @StartTime = GETDATE()
CREATE TABLE #AllocationWeight
(
	[AllocationWeightId] [int] NOT NULL,
	[ProjectGroupAllocationId] [int] NOT NULL,
	[ProjectId] [int] NOT NULL,
	[Weight] [numeric](18, 12) NOT NULL
)

INSERT #AllocationWeight
SELECT O.AllocationWeightId,O.ProjectGroupAllocationId,O.ProjectId,O.Weight
FROM TapasGlobal.AllocationWeight O join TapasGlobal.AllocationWeightActive(@DataPriorToDate) A
ON O.ImportKey = A.ImportKey

	PRINT 'Completed inserting records into #AllocationWeight: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


CREATE CLUSTERED INDEX IX_#AllocationWeight_ProjectGroupAllocationId 
   ON #AllocationWeight (ProjectGroupAllocationId)


PRINT 'Completed creating indexes on #AllocationWeight'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))	



-------------#ProjectGroup-Project Mapping----------------	
	SET @StartTime = GETDATE()
CREATE TABLE #ProjectGroupProjectMapping
(
	ProjectId INT NOT NULL,
	ProjectGroupId INT NOT NULL,
	HrEmployeeId INT NOT NULL,
	Period int NOT NULL	
)

INSERT #ProjectGroupProjectMapping

--declare @DataPriorToDate datetime = '2012-07-31'
SELECT  distinct
AW.ProjectId,
TD.ProjectGroupId,
T.Period,
T.HREmployeeId
FROM GrReportingStaging.TapasGlobal.TimeAllocation T
	INNER JOIN TapasGlobal.TimeAllocationActive(@DataPriorToDate) A on T.ImportKey=A.ImportKey
INNER JOIN GrReportingStaging.TapasGlobal.TimeAllocationDetail TD ON T.TimeAllocationId = TD.TimeAllocationId
	INNER JOIN TapasGlobal.TimeAllocationDetailActive(@DataPriorToDate) TDA on TD.ImportKey=TDA.ImportKey
Cross join (
select MAX(FirstProjectedPeriod) as EndPeriod, MIN(GroupStartPeriod) AS StartPeriod
from #Budget
) B
INNER JOIN #ProjectGroupAllocation PGA ON TD.ProjectGroupId=PGA.ProjectGroupId and T.Period=PGA.EffectivePeriod
INNER JOIN #AllocationWeight AW ON PGA.ProjectGroupAllocationId = AW.ProjectGroupAllocationId	
--Where T.Period>= 201201 and T.Period<201204 and TD.ProjectId is nul

Where T.Period>= B.StartPeriod and T.Period<B.EndPeriod and TD.ProjectId is null


	PRINT 'Completed inserting records into #ProjectGroupProjectMapping: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


CREATE CLUSTERED INDEX IX_#ProjectGroupProjectMapping
   ON #ProjectGroupProjectMapping (HrEmployeeId,ProjectId,Period)


PRINT 'Completed creating indexes on #ProjectGroupProjectMapping'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))	


*/


SET @StartTime = GETDATE()

	CREATE TABLE #ProfitabilityPreTaxSourceActual
	(
		ImportBatchId INT NOT NULL,
		BudgetReforecastTypeKey INT NOT NULL,
		ReforecastKey INT NOT NULL,
		SnapshotId INT NOT NULL,
		BudgetId INT NOT NULL,
		RegionId INT NOT NULL,
		ProjectId INT NOT NULL,
		ProjectGroupId INT NOT NULL,
		HrEmployeeId INT NOT NULL,
		BudgetOwnerStaffId INT NOT NULL,
		--ReforecastActualBilledPayrollId INT NOT NULL,
		ReferenceCode VARCHAR(300) NOT NULL,
		ExpensePeriod CHAR(6) NOT NULL,	
		SourceCode VARCHAR(2) NULL,
		BudgetAllocatedAmount MONEY NOT NULL,
		BudgetAllocatedFTE decimal(18,12) NOT NULL,
		FunctionalDepartmentId INT NOT NULL,
		FunctionalDepartmentCode VARCHAR(31) NULL,
		Reimbursable BIT NULL,
		ActivityTypeId INT NOT NULL,
		ActivityTypeCode Varchar(50) NOT NULL,
		PropertyFundId INT NOT NULL,
		ReportingEntityId INT NOT NULL,
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
	INSERT INTO #ProfitabilityPreTaxSourceActual
	(
		ImportBatchId,
		BudgetReforecastTypeKey,
		ReforecastKey,
		SnapshotId,
		BudgetId,
		RegionId,
		ProjectId,
		ProjectGroupId,
		HrEmployeeId,
		BudgetOwnerStaffId,
		--ReforecastActualBilledPayrollId,
		ReferenceCode,
		ExpensePeriod,
		SourceCode,
		BudgetAllocatedAmount,
		BudgetAllocatedFTE,

		FunctionalDepartmentId,
		FunctionalDepartmentCode,
		Reimbursable,
		ActivityTypeId,
		ActivityTypeCode,
		PropertyFundId,
		ReportingEntityId,
		AllocationSubRegionGlobalRegionId,
		ConsolidationSubRegionGlobalRegionId,
		OriginatingRegionCode,
		OriginatingRegionSourceCode,
		LocalCurrencyCode,
		AllocationUpdatedDate,
		BudgetReportGroupPeriod,
		
		SourceTableName

	)
	--declare @ReforecastTypeIsTGBACTKey int =1
	SELECT 
		Budget.ImportBatchId,
		@ReforecastTypeIsTGBACTKey,
		Budget.ReforecastKey,
		Budget.SnapshotId,
		Budget.BudgetId AS BudgetId,
		Budget.RegionId AS BudgetRegionId,
		Allocation.ProjectId AS ProjectId,
		-1 AS ProjectGroupId,
		--ISNULL(PGM.ProjectGroupId,-1) AS ProjectGroupId, 
		Allocation.HrEmployeeId AS HrEmployeeId,
		ISNULL(ReportingEntity.BudgetOwnerStaffId,-1) AS BudgetOwnerStaffId,

		'TGB:BudgetId=' + CONVERT(varchar,Budget.BudgetId) + 
		'&ProjectId=' + CONVERT(varchar,ISNULL(Allocation.ProjectId,-1)) + 
		'&HrEmployeeId=' + CONVERT(varchar,ISNULL(Allocation.HrEmployeeId,-1)) + 
		'&Period=' + CONVERT(varchar,ISNULL(Allocation.ExpensePeriod,-1)) + 
		'&ReforecastActualBilledPayrollId=' + CONVERT(varchar,min(Allocation.ReforecastActualBilledPayrollId))  
		AS ReferenceCode,
		Allocation.ExpensePeriod,
		SourceRegion.SourceCode,


		Sum(Allocation.AllocationAmount) AS BudgetAllocatedAmount,

		Allocation.AllocationPercentage AS BudgetAllocatedFTE,
		
		
		Allocation.FunctionalDepartmentId,
		fd.GlobalCode AS FunctionalDepartmentCode, 
		Allocation.isReimbursable,
		Allocation.ActivityTypeId,
		Att.ActivityTypeCode,
		
			/*
				When selecting a Property Fund, the first option is is the Property Fund assigned to the Corporate Department of
				the Project - DepartmentPropertyFund. If the CorporateDepartmentCode field of the project is NULL or '@', the
				next option is the project's PropertyFundId field - the ProjectPropertyFund.
			*/
			
		ISNULL( ProjectPropertyFund.PropertyFundId, -1) AS PropertyFundId,
		ISNULL( RECD.PropertyFundId , -1) AS ReportingEntityId,
		--AllocationRegion is related to ReportingEntity
		ISNULL( ReportingEntity.AllocationSubRegionGlobalRegionId, -1) AS AllocationSubRegionGlobalRegionId,
		ISNULL(ConsolidationRegion.GlobalRegionId, -1) AS ConsolidationSubRegionGlobalRegionId,
		OriginatingRegion.CorporateEntityRef,
		OriginatingRegion.CorporateSourceCode,
		Budget.CurrencyCode AS LocalCurrencyCode,
		dateadd(dd,-1,dateadd(mm,1, LEFT(Allocation.ExpensePeriod, 4) + '-' + RIGHT(Allocation.ExpensePeriod, 2) + '-01')
			) AS AllocationUpdatedDate,
		Budget.BudgetReportGroupPeriod,
		
		'BudgetEmployeePayrollAllocation'

	FROM
	
		TapasGlobalBudgeting.ReforecastActualBilledPayroll Allocation
		
		INNER JOIN #DistinctImports DI ON
			Allocation.ImportBatchId = DI.ImportBatchId
		

		LEFT JOIN #Budget Budget ON
			Allocation.ImportBatchId = Budget.ImportBatchId AND
			Allocation.BudgetId = Budget.BudgetId
			
		INNER JOIN #Project Project ON 
			Allocation.ProjectId = Project.ProjectId 
			
		--LEFT JOIN #ProjectGroupProjectMapping PGM ON (PGM.HrEmployeeId = Allocation.HrEmployeeId 
		--	 and PGM.ProjectId=Allocation.ProjectId and PGM.Period=Allocation.ExpensePeriod)


		LEFT OUTER JOIN #Region SourceRegion ON
			Budget.RegionId = SourceRegion.RegionId

		-- Maps the source of the record
		LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
			SourceRegion.SourceCode = GrSc.SourceCode


		/*
			A Property Fund can either be mapped using the PropertyFundId in the BudgetProject table, or using the CorporateDepartmentCode and
			SourceCode combination in the BudgetProject table to determine the PropertyFundId through the ReportingEntityCorproateDepartment table
			or the ReportingEntityPropertyEntity table.
			The Property Fund using the CorporateDepartmentCode and SourceCode is the first option, but if this is null, the PropertyFundId is used
			directly from the BudgetProject table.
		*/

		-- Gets the Property Fund a Project is mapped to
		LEFT OUTER JOIN Gdm.SnapshotPropertyFund ProjectPropertyFund ON
			Project.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
			Budget.SnapshotId = ProjectPropertyFund.SnapshotId AND
			ProjectPropertyFund.IsActive = 1

		-- Gets the Allocation Region from the Property Fund a project is mapped to
		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion GlobalRegion ON
			ProjectPropertyFund.AllocationSubRegionGlobalRegionId = GlobalRegion.GlobalRegionId AND
			ProjectPropertyFund.SnapshotId = GlobalRegion.SnapshotId AND
			GlobalRegion.IsActive = 1


		-- 	Used to resolve the Consolidation Sub Region a Project's Corporate Department is mapped to.			
		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD ON -- (CC16)
			GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
			LTRIM(RTRIM(Project.CorporateDepartmentCode)) = CRCD.CorporateDepartmentCode AND
			Project.CorporateSourceCode = CRCD.SourceCode AND
			Budget.SnapshotId = CRCD.SnapshotId  AND
			Budget.BudgetReportGroupPeriod >= 201101

		-- 	Used to resolve the Consolidation Sub Region a Project's Property Entity is mapped to.			
		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionPropertyEntity CRPE ON -- (CC16)
			GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(Project.CorporateDepartmentCode)) = CRPE.PropertyEntityCode AND
			Project.CorporateSourceCode = CRPE.SourceCode AND
			Budget.SnapshotId  = CRPE.SnapshotId AND
			Budget.BudgetReportGroupPeriod >= 201101

		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion ConsolidationRegion ON
			Budget.SnapshotId = ConsolidationRegion.SnapshotId AND
			ConsolidationRegion.GlobalRegionId = COALESCE(CRCD.GlobalRegionId, CRPE.GlobalRegionId, ProjectPropertyFund.AllocationSubRegionGlobalRegionId) AND
			ConsolidationRegion.IsConsolidationRegion = 1 AND
			ConsolidationRegion.IsActive = 1


		-- Used to determine the Location an employee is based in
		LEFT OUTER JOIN #Location Location ON 
			Allocation.LocationId = Location.LocationId 
		-- Moony: seems the Budget.RegionId equals to PayGroup.RegionId
		-- Used to determine the Originating Region Code and Source Code
		LEFT OUTER JOIN Gdm.SnapshotPayrollRegion OriginatingRegion ON 
			Location.ExternalSubRegionId = OriginatingRegion.ExternalSubRegionId AND
			Budget.RegionId = OriginatingRegion.RegionId AND
			Budget.SnapshotId = OriginatingRegion.SnapshotId

		INNER JOIN GrReporting.dbo.ActivityType Att ON
			Allocation.ActivityTypeId = Att.ActivityTypeId AND
			Budget.SnapshotId = Att.SnapshotId
			
					-- Resolves the Functional Department Code
		LEFT OUTER JOIN #FunctionalDepartment fd ON
			Allocation.FunctionalDepartmentId = fd.FunctionalDepartmentId

		LEFT OUTER JOIN Gdm.SnapshotCorporateDepartment Dept ON
			Project.CorporateDepartmentCode = Dept.Code AND 
			SourceRegion.SourceCode = Dept.SourceCode AND
			Budget.SnapshotId = Dept.SnapshotId
			
		LEFT JOIN GDM.SnapshotReportingEntityCorporateDepartment RECD ON
			Project.CorporateDepartmentCode = RECD.CorporateDepartmentCode AND
			Project.CorporateSourceCode = RECD.SourceCode AND
			Budget.SnapshotId = RECD.SnapshotId
			
			
		LEFT OUTER JOIN Gdm.SnapshotPropertyFund ReportingEntity ON
			RECD.PropertyFundId = ReportingEntity.PropertyFundId AND
			Budget.SnapshotId = ReportingEntity.SnapshotId AND
			ReportingEntity.IsActive = 1
	WHERE
		Allocation.ExpensePeriod < Budget.FirstProjectedPeriod and Allocation.ExpensePeriod>=Budget.GroupStartPeriod
		
	Group by 
		Budget.ImportBatchId,
		
		Budget.ReforecastKey,
		Budget.SnapshotId,
		Budget.BudgetId ,
		Budget.RegionId,
		Allocation.ProjectId ,
		--ISNULL(PGM.ProjectGroupId,-1) , 
		Allocation.HrEmployeeId ,
		ReportingEntity.BudgetOwnerStaffId ,
		'TGB:BudgetId=' + CONVERT(varchar,Budget.BudgetId) + 
		'&ProjectId=' + CONVERT(varchar,ISNULL(Allocation.ProjectId,-1)) + 
		'&HrEmployeeId=' + CONVERT(varchar,ISNULL(Allocation.HrEmployeeId,-1)) + 
		'&Period=' + CONVERT(varchar,ISNULL(Allocation.ExpensePeriod,-1)) + 
		'&ReforecastActualBilledPayrollId='-- + CONVERT(varchar,Allocation.ReforecastActualBilledPayrollId)  
		,
		Allocation.ExpensePeriod,
		SourceRegion.SourceCode,



		Allocation.AllocationPercentage ,
		
		
		Allocation.FunctionalDepartmentId,
		fd.GlobalCode , 
		Allocation.isReimbursable,
		Allocation.ActivityTypeId,
		Att.ActivityTypeCode,
		
			/*
				When selecting a Property Fund, the first option is is the Property Fund assigned to the Corporate Department of
				the Project - DepartmentPropertyFund. If the CorporateDepartmentCode field of the project is NULL or '@', the
				next option is the project's PropertyFundId field - the ProjectPropertyFund.
			*/
			
		ISNULL( ProjectPropertyFund.PropertyFundId, -1) ,
		ISNULL( RECD.PropertyFundId , -1) ,
		ISNULL( ReportingEntity.AllocationSubRegionGlobalRegionId, -1) ,
		ISNULL(ConsolidationRegion.GlobalRegionId, -1),
		OriginatingRegion.CorporateEntityRef,
		OriginatingRegion.CorporateSourceCode,
		Budget.CurrencyCode ,
		LEFT(Allocation.ExpensePeriod, 4) + '-' + RIGHT(Allocation.ExpensePeriod, 2) + '-01' ,
		Budget.BudgetReportGroupPeriod
		
	PRINT 'Completed inserting records into #ProfitabilityPreTaxSourceActual:  '+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

---insert actual to final table

	SET @StartTime = GETDATE()
	
		INSERT INTO #TimeAllocationReforecast 

	(
		ImportBatchId, 
		BudgetReforecastTypeKey,
		ReforecastKey,
		CalendarKey,
		EmployeeKey,
		BudgetOwnerStaff,
		ApprovedByStaff,
		ProjectKey ,
		ProjectGroupKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		PropertyFundKey,
		ReportingEntityKey,
		AllocationRegionKey,
		ConsolidationRegionKey,
		OriginatingRegionKey,
		Local_NonLocal,
		LocalCurrencyKey,
		LocalBudgetAllocatedAmount,
		BudgetAllocatedFTE,

		ReferenceCode,
		BudgetId,
		SnapshotId,
	
		SourceSystemKey
	)
	
	
	SELECT
				
		pbm.ImportBatchId,
		pbm.BudgetReforecastTypeKey,
		pbm.ReforecastKey,
		DATEDIFF(dd, '1900-01-01', LEFT(pbm.ExpensePeriod, 4) + '-' + RIGHT(pbm.ExpensePeriod, 2) + '-01') AS CalendarKey,
		ISNULL(e.EmployeeKey, @EmployeeKey) EmployeeKey,
		ISNULL(BudgetOwner.DisplayName, '') BudgetOwnerStaff,
		'' ApprovedByStaff,
		ISNULL(p.ProjectKey, @ProjectKey) ProjectKey,
		ISNULL(pg.ProjectGroupKey, @ProjectGroupKey) ProjectGroupKey,

		ISNULL(GrSc.SourceKey, @SourceKey) SourceKey,
		ISNULL(GrFdm.FunctionalDepartmentKey, @FunctionalDepartmentKey) FunctionalDepartmentKey,
		ISNULL(GrRi.ReimbursableKey, @ReimbursableKey) ReimbursableKey,
		ISNULL(GrAt.ActivityTypeKey, @ActivityTypeKey) ActivityTypeKey,
		ISNULL(GrPf.PropertyFundKey, @PropertyFundKey) PropertyFundKey,
		ISNULL(GrRe.PropertyFundKey, @ReportingEntityKey) ReportingEntityKey,
		ISNULL(GrAr.AllocationRegionKey, @AllocationRegionKey) AllocationRegionKey,
		ISNULL(Grcr.AllocationRegionKey, @AllocationRegionKey) ConsolidationRegionKey,
		ISNULL(GrOr.OriginatingRegionKey, @OriginatingRegionKey) OriginatingRegionKey,
		ISNULL(GrReporting.dbo.GetLocalNonLocalStr(GrOr.RegionName,GrOr.SubRegionName,GrAr.RegionName,GrAr.SubRegionName),'')  Local_NonLocal,
		ISNULL(GrCu.CurrencyKey, @LocalCurrencyKey) LocalCurrencyKey,
		pbm.BudgetAllocatedAmount,
		pbm.BudgetAllocatedFTE,

		pbm.ReferenceCode,
		pbm.BudgetId,
		pbm.SnapshotId,
		
		SSystem.SourceSystemKey		

	

	FROM
		#ProfitabilityPreTaxSourceActual pbm

		LEFT OUTER JOIN Gdm.[Snapshot] SShot ON
			pbm.SnapshotId = SSHot.SnapshotId
			
			

		LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON
			pbm.SourceCode = GrSc.SourceCode  
	

		LEFT OUTER JOIN GrReporting.dbo.SourceSystem SSystem ON
			pbm.SourceTableName = SSystem.SourceTableName AND
			SSystem.SourceSystemName = 'TapasGlobalBudgeting'
		
		LEFT JOIN GrReporting.dbo.Project p ON
			pbm.ProjectId=p.ProjectId and p.BudgetId=-1
			and pbm.AllocationUpdatedDate>=p.StartDate and pbm.AllocationUpdatedDate<p.EndDate
			
			
			
		LEFT JOIN GrReporting.dbo.ProjectGroup pg ON
			pbm.ProjectGroupId=pg.ProjectGroupId and pg.BudgetId=-1
			and pbm.AllocationUpdatedDate>=pg.StartDate and pbm.AllocationUpdatedDate<pg.EndDate	
					
		LEFT JOIN GrReporting.dbo.Employee e ON
			pbm.HrEmployeeId=e.HrEmployeeId and e.StartDate<=pbm.AllocationUpdatedDate and pbm.AllocationUpdatedDate<e.EndDate
			and e.EmployeeHistoryId>-1
			
		LEFT JOIN GrReportingStaging.GACS.Staff BudgetOwner ON
			pbm.BudgetOwnerStaffId=BudgetOwner.StaffId --and BudgetOwner.StaffId<>-1			

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


		LEFT OUTER JOIN GrReporting.dbo.PropertyFundFTE GrPf ON
			pbm.PropertyFundId = GrPf.PropertyFundId AND
			pbm.SnapshotId = GrPf.SnapshotId  
			
		LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrRe ON
			pbm.ReportingEntityId = GrRe.PropertyFundId AND
			pbm.SnapshotId = GrRe.SnapshotId  				

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


		LEFT OUTER JOIN #FunctionalDepartment FD ON
			pbm.FunctionalDepartmentCode = FD.GlobalCode 


		LEFT OUTER JOIN Gdm.SnapshotPropertyFund PF ON
			pbm.SnapshotId = PF.SnapshotID AND
			pbm.PropertyFundId = PF.PropertyFundId 
--where pbm.BudgetEmployeePayrollAllocationId=22851789	


    --debug
    --select  * into debug._TimeAllocationReforecast from #TimeAllocationReforecast


--return 0
	PRINT 'Completed inserting Actual records into #TimeAllocationReforecast: '+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #TimeAllocationReforecast (ReferenceCode)

	PRINT 'Completed creating indexes on #TimeAllocationReforecast'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END

/* ================================================================================================================================================
	10. Insert budget records into the GrReporting.dbo.TimeAllocationReforecast table
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
			GrReporting.dbo.TimeAllocationReforecast FACT
		USING
			#TimeAllocationReforecast AS SRC ON

				FACT.ReferenceCode = SRC.ReferenceCode
		WHEN
			MATCHED AND
			(
				FACT.CalendarKey <> SRC.CalendarKey OR
				FACT.SourceKey <> SRC.SourceKey OR
				FACT.FunctionalDepartmentKey <> SRC.FunctionalDepartmentKey OR
				FACT.ProjectKey <> SRC.ProjectKey OR
				FACT.ProjectGroupKey <> SRC.ProjectGroupKey OR
				FACT.EmployeeKey <> SRC.EmployeeKey OR
				FACT.BudgetOwnerStaff <> SRC.BudgetOwnerStaff OR
				FACT.ApprovedByStaff <> SRC.ApprovedByStaff OR
				FACT.ReimbursableKey <> SRC.ReimbursableKey OR
				FACT.ActivityTypeKey <> SRC.ActivityTypeKey OR
				FACT.PropertyFundKey <> SRC.PropertyFundKey OR
				FACT.ReportingEntityKey <> SRC.ReportingEntityKey OR
				FACT.AllocationRegionKey <> SRC.AllocationRegionKey OR
				FACT.OriginatingRegionKey <> SRC.OriginatingRegionKey OR
				FACT.LocalCurrencyKey <> SRC.LocalCurrencyKey OR
				FACT.Local_NonLocal <> SRC.Local_NonLocal OR
				FACT.LocalBudgetAllocatedAmount <> SRC.LocalBudgetAllocatedAmount OR
				FACT.BudgetAllocatedFTE <> SRC.BudgetAllocatedFTE OR

				FACT.SnapshotId <> SRC.SnapshotId OR
				FACT.ReforecastKey <> SRC.ReforecastKey OR
				FACT.ConsolidationRegionKey <> SRC.ConsolidationRegionKey OR
				ISNULL(FACT.SourceSystemKey, '') <> SRC.SourceSystemKey
			)
		THEN
			UPDATE
			SET
				FACT.CalendarKey = SRC.CalendarKey,
				FACT.SourceKey = SRC.SourceKey,
				FACT.FunctionalDepartmentKey = SRC.FunctionalDepartmentKey,
				FACT.ProjectKey = SRC.ProjectKey ,
				FACT.ProjectGroupKey = SRC.ProjectGroupKey ,
				FACT.EmployeeKey = SRC.EmployeeKey ,
				FACT.ApprovedByStaff = SRC.ApprovedByStaff,
				FACT.BudgetOwnerStaff = SRC.BudgetOwnerStaff,
				FACT.ReimbursableKey = SRC.ReimbursableKey,
				FACT.ActivityTypeKey = SRC.ActivityTypeKey,
				FACT.PropertyFundKey = SRC.PropertyFundKey,
				FACT.ReportingEntityKey = SRC.ReportingEntityKey,
				FACT.AllocationRegionKey = SRC.AllocationRegionKey,
				FACT.OriginatingRegionKey = SRC.OriginatingRegionKey,
				FACT.LocalCurrencyKey = SRC.LocalCurrencyKey,
				FACT.Local_NonLocal = SRC.Local_NonLocal,
				FACT.LocalBudgetAllocatedAmount = SRC.LocalBudgetAllocatedAmount ,
				FACT.BudgetAllocatedFTE = SRC.BudgetAllocatedFTE ,


				FACT.SnapshotId = SRC.SnapshotId,
				FACT.ReforecastKey = SRC.ReforecastKey,
				FACT.ConsolidationRegionKey = SRC.ConsolidationRegionKey,

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
				ProjectKey,
				ProjectGroupKey,
				EmployeeKey,
				BudgetOwnerStaff,
				ApprovedByStaff,
				Local_NonLocal,
				SourceKey,
				FunctionalDepartmentKey,
				ReimbursableKey,
				ActivityTypeKey,
				PropertyFundKey,
				ReportingEntityKey,
				AllocationRegionKey,
				ConsolidationRegionKey,
				OriginatingRegionKey,
				LocalCurrencyKey,
				LocalBudgetAllocatedAmount ,
				BudgetAllocatedFTE,

				ReferenceCode,
				BudgetId,
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
				SRC.ProjectKey,
				SRC.ProjectGroupKey,
				SRC.EmployeeKey,
				SRC.BudgetOwnerStaff,
				SRC.ApprovedByStaff,
				SRC.Local_NonLocal,
				SRC.SourceKey,
				SRC.FunctionalDepartmentKey,
				SRC.ReimbursableKey,
				SRC.ActivityTypeKey,
				SRC.PropertyFundKey,
				SRC.ReportingEntityKey,
				SRC.AllocationRegionKey,
				SRC.ConsolidationRegionKey,
				SRC.OriginatingRegionKey,

				SRC.LocalCurrencyKey,
				SRC.LocalBudgetAllocatedAmount ,
				SRC.BudgetAllocatedFTE,

				SRC.ReferenceCode,
				SRC.BudgetId,

				@StartTime,
				@StartTime,
				
				SRC.SourceSystemKey

			)
		WHEN
			NOT MATCHED BY SOURCE AND
			FACT.BudgetId IN (SELECT BudgetId FROM #BudgetsToProcess) AND
			FACT.BudgetReforecastTypeKey IN (@BudgetReforecastTypeKey, @ReforecastTypeIsTGBACTKey) 
		THEN
			DELETE
		OUTPUT
				$action AS Change
	) AS InsertedData

	CREATE NONCLUSTERED INDEX UX_SummaryOfChanges_Change ON #SummaryOfChanges(Change)

	DECLARE @InsertedRows INT = (SELECT COUNT(*) FROM #SummaryOfChanges WHERE Change = 'INSERT')
	DECLARE @UpdatedRows INT = (SELECT COUNT(*) FROM #SummaryOfChanges WHERE Change = 'UPDATE')
	DECLARE @DeletedRows INT = (SELECT COUNT(*) FROM #SummaryOfChanges WHERE Change = 'DELETE')

	PRINT 'Rows added to TimeAllocationReforecast: '+ CONVERT(char(10), @InsertedRows)
	PRINT 'Rows updated in TimeAllocationReforecast: '+ CONVERT(char(10),@UpdatedRows)
	PRINT 'Rows deleted from TimeAllocationReforecast: '+ CONVERT(char(10),@DeletedRows)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END

/* ================================================================================================================================================
	11. Mark budgets as being successfully processed into the warehouse
	should be done in stp_IU_LoadGrProfitabiltyPayrollReforecast, so this stp should be run before that one.
   ============================================================================================================================================= */
/*
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
*/

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
	IF OBJECT_ID('tempdb..#BudgetProjectGroup') IS NOT NULL
		DROP TABLE #BudgetProjectGroup
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
	IF OBJECT_ID('tempdb..#FunctionalDepartment') IS NOT NULL
		DROP TABLE #FunctionalDepartment

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
		
	IF OBJECT_ID('tempdb..#ProjectGroupProjectMapping') IS NOT NULL
		DROP TABLE #ProjectGroupProjectMapping
	IF OBJECT_ID('tempdb..#AllocationWeight') IS NOT NULL
		DROP TABLE #AllocationWeight
	IF OBJECT_ID('tempdb..#ProjectGroupAllocation') IS NOT NULL
		DROP TABLE #ProjectGroupAllocation

END


GO


