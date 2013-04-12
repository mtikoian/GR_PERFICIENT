USE [GrReportingStaging]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyGBSReforecast]    Script Date: 11/22/2011 09:39:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyGBSReforecast]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyGBSReforecast]
GO


/*********************************************************************************************************************
Description
	This stored procedure processes non-payroll and fee budget reforecast information and uploads it to the
	ProfitabilityReforecast table in the data warehouse (GrReporting.dbo.ProfitabilityReforecast)
	
		1.	Get Budgets to Process
		2.	Declare local variables and create common tables
		3.	Source Budget data from GBS.Budget
		4.	Source Snapshot mapping data from GDM
		5.	Create master GL Account Category mapping table
		6.	Create the temporary source table into which Non-Payroll Expense and Fee budgets are to be inserted
		7.	Get Non-Payroll Expense BUDGET items from GBS 
		8.	Get Fee BUDGET items from GBS 
		9.	Get Fee Income and Non-Payroll Expense ACTUALS from GBS.BudgetProfitabilityActual 
		10.	Join to dimension tables in GrReporting and attempt to resolve keys, otherwise default to UNKNOWN if NULL
		11.	Update #ProfitibilityReforecast.GlobalGlCategorizationHierarchyKey
		12.	Delete budgets to insert that have UNKNOWNS in their mapping
		13.	Insert, Update and Delete records from Fact table
		14.	Mark budgets as being successfully processed into the warehouse
		15.	Clean up	
	
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-06-23		: PKayongo	:	Added ConsolidationRegion mapping as per CC16. Added the field to the 
											data inserted into the warehouse. 	
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyGBSReforecast]
		@DataPriorToDate	DateTime=NULL
AS

SET NOCOUNT ON

PRINT '####'
PRINT 'stp_IU_LoadGrProfitabiltyGBSReforecast'
PRINT '####'

IF (CONVERT(INT, (SELECT TOP 1 ConfiguredValue FROM GrReportingStaging.dbo.SSISConfigurations WHERE ConfigurationFilter = 'CanImportGBSReforecast')) <> 1)
BEGIN
	PRINT ('Import of GBS Reforecasts is not scheduled in GrReportingStaging.dbo.SSISConfigurations')
	RETURN
END

DECLARE @StartTime DATETIME = GETDATE()

/* ==============================================================================================================================================
	1.	Get Budgets to Process
   =========================================================================================================================================== */
BEGIN

	SELECT 
		BTPC.*, 
		Reforecast.ReforecastKey
	INTO 
		#BudgetsToProcess 
	FROM 
		dbo.BudgetsToProcess BTPC
		INNER JOIN 
		(
			SELECT
				MIN(ReforecastKey) AS ReforecastKey,
				ReforecastQuarterName,
				ReforecastEffectiveYear
			FROM
				GrReporting.dbo.Reforecast
			GROUP BY
				ReforecastQuarterName,
				ReforecastEffectiveYear

		) Reforecast ON
			BTPC.BudgetYear = Reforecast.ReforecastEffectiveYear AND
			BTPC.BudgetQuarter = Reforecast.ReforecastQuarterName
	WHERE
		BTPC.IsCurrentBatch = 1 AND
		BTPC.BudgetReforecastTypeName = 'GBS Budget/Reforecast' AND
		IsReforecast = 1

	DECLARE @BTPRowCount INT = @@rowcount
	PRINT ('Rows inserted into #BudgetsToProcess: ' + CONVERT(VARCHAR(10),@BTPRowCount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	IF (@BTPRowCount = 0)
	BEGIN
		PRINT ('stp_IU_LoadGrProfitabiltyGBSBudget is quitting because there are no GBS BudgetsToProcess set to be imported.')
		RETURN
	END

END

/* ==============================================================================================================================================
	2.	Declare local variables and create common tables
   =========================================================================================================================================== */
BEGIN

	DECLARE @ReasonsForFailure VARCHAR(500) = ''
	DECLARE	@SourceKeyUnknown					 INT = (SELECT SourceKey FROM GrReporting.dbo.Source WHERE SourceName = 'UNKNOWN')
	DECLARE	@FunctionalDepartmentKeyUnknown		 INT = (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = 'UNKNOWN')
	DECLARE	@ReimbursableKeyUnknown				 INT = (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = 'UNKNOWN')
	DECLARE	@ActivityTypeKeyUnknown				 INT = (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = 'UNKNOWN')
	DECLARE	@PropertyFundKeyUnknown				 INT = (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = 'UNKNOWN')
	DECLARE	@AllocationRegionKeyUnknown			 INT = (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = 'UNKNOWN')
	DECLARE	@OriginatingRegionKeyUnknown		 INT = (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = 'UNKNOWN')
	DECLARE	@OverheadKeyUnknown					 INT = (SELECT OverheadKey FROM GrReporting.dbo.Overhead WHERE OverheadCode = 'UNKNOWN')
	DECLARE	@LocalCurrencyKeyUnknown			 INT = (SELECT CurrencyKey FROM GrReporting.dbo.Currency WHERE CurrencyCode = 'UNK')
	DECLARE @GLCategorizationHierarchyKeyUnknown INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'UNKNOWN' AND SnapshotId = 0)


	DECLARE	@FeeAdjustmentKeyUnknown			 INT = (SELECT FeeAdjustmentKey FROM GrReporting.dbo.FeeAdjustment WHERE FeeAdjustmentCode = 'UNKNOWN')--,
	DECLARE @ReforecastTypeIsGBSBUDKey			 INT = (SELECT BudgetReforecastTypeKey FROM GrReporting.dbo.BudgetReforecastType WHERE BudgetReforecastTypeCode = 'GBSBUD')
	DECLARE @ReforecastTypeIsGBSACTKey			 INT = (SELECT BudgetReforecastTypeKey FROM GrReporting.dbo.BudgetReforecastType WHERE BudgetReforecastTypeCode = 'GBSACT')
	--DECLARE	@OverheadTypeIdUnAllocated INT = (Select [OverheadTypeId] From GrReportingStaging.GBS.OverheadType Where [Code] = 'UNALLOC' AND ImportBatchID = @ImportBatchId)

DECLARE
	@UnknownUSPropertyGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'US Property' AND SnapshotId = 0),
	@UnknownUSFundGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'US Fund' AND SnapshotId = 0),
	@UnknownEUPropertyGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'EU Property' AND SnapshotId = 0),
	@UnknownEUFundGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'EU Fund' AND SnapshotId = 0),
	@UnknownUSDevelopmentGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'US Development' AND SnapshotId = 0),
	@UnknownGlobalGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'Global' AND SnapshotId = 0)


-- Corporate Property Sources

	CREATE TABLE #CorporatePropertySourceCodes (
		CorporateSourceCode CHAR(2) NOT NULL,
		PropertySourceCode CHAR(2) NOT NULL
	)
	INSERT INTO #CorporatePropertySourceCodes
	VALUES
		('UC', 'US'),
		('EC', 'EU'),
		('IC', 'IN'),
		('BC', 'BR'),
		('CC', 'CN')

	IF (@DataPriorToDate IS NULL)
		BEGIN
		SET @DataPriorToDate = CONVERT(DateTime,(SELECT ConfiguredValue FROM SSISConfigurations WHERE ConfigurationFilter = 'ActualDataPriorToDate'))
		END
END

/* ==============================================================================================================================================
	3.	Source Budget data from GBS.Budget
   =========================================================================================================================================== */
BEGIN

	CREATE TABLE #Budget(
		ImportBatchId INT NOT NULL,
		BudgetId INT NOT NULL,
		BudgetStatusId INT NOT NULL,
		LastLockedDate DATETIME NULL,
		SnapshotId INT NOT NULL,
		FirstProjectedPeriodFees INT NOT NULL,
		FirstProjectedPeriodNonPayroll INT NOT NULL,
		ReforecastKey INT NOT NULL
	)
	INSERT INTO #Budget
	SELECT
		BTP.ImportBatchId,
		Budget.BudgetId,
		Budget.BudgetStatusId,
		Budget.LastLockedDate,
		BTP.SnapshotId,
		FirstProjectedPeriodFees.ProjectedPeriod AS FirstProjectedPeriodFees,
		FirstProjectedPeriodNonPayRoll.ProjectedPeriod AS FirstProjectedPeriodNonPayroll,
		BTP.ReforecastKey
	FROM
		GBS.Budget Budget

		INNER JOIN #BudgetsToProcess BTP ON -- All GBS budgets in dbo.BudgetsToProcess must be considered because they are to be processed into the warehouse
			Budget.BudgetId = BTP.BudgetId AND
			Budget.ImportBatchId = BTP.ImportBatchId

		INNER JOIN GDM.BudgetReportGroupPeriod BRGP ON
			Budget.BudgetReportGroupPeriodId  = BRGP.BudgetReportGroupPeriodId

		INNER JOIN GDM.BudgetReportGroupPeriodActive(@DataPriorToDate) BRGPA ON
			BRGP.ImportKey = BRGPA.ImportKey	

		-- Join on ImportBatchId below because there could be multiple copies of the same budget in the GrReportingStaging.GBS.xxx tables

		INNER JOIN
		(
			SELECT
				BudgetId,
				Period AS ProjectedPeriod,
				ImportBatchId
			FROM
				GBS.BudgetPeriod
			WHERE
				IsFeeFirstProjectedPeriod = 1

		) FirstProjectedPeriodFees ON
			Budget.BudgetId = FirstProjectedPeriodFees.BudgetId AND
			BTP.ImportBatchId = FirstProjectedPeriodFees.ImportBatchId 

		INNER JOIN
		(
			SELECT
				BudgetId,
				Period AS ProjectedPeriod,
				ImportBatchId
			FROM
				GBS.BudgetPeriod
			WHERE
				IsNonPayrollFirstProjectedPeriod = 1

		) FirstProjectedPeriodNonPayRoll ON
			Budget.BudgetId = FirstProjectedPeriodNonPayRoll.BudgetId AND
			BTP.ImportBatchId = FirstProjectedPeriodNonPayRoll.ImportBatchId
	WHERE
		Budget.IsActive = 1 
		
	DECLARE @BudgetRowCount INT = @@rowcount
	PRINT ('Rows inserted into #Budget: ' + CONVERT(VARCHAR(10),@BudgetRowCount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	IF (@BudgetRowCount = 0)
	BEGIN
		PRINT ('stp_IU_LoadGrProfitabiltyGBSBudget is quitting because there are no GBS budgets set to be imported.')
		RETURN
	END

	CREATE UNIQUE CLUSTERED INDEX IX_Budget ON #Budget (SnapshotId, BudgetId)

END

/* ==============================================================================================================================================
	4.	Source Snapshot mapping data from GDM
   =========================================================================================================================================== */
BEGIN

-- GLGlobalAccount --------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #GLGlobalAccount(
		GLGlobalAccountId INT NOT NULL,
		ActivityTypeId INT NULL,
		Code VARCHAR(10) NOT NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #GLGlobalAccount (
		GLGlobalAccountId,
		ActivityTypeId,
		Code,
		SnapshotId
	)
	SELECT DISTINCT
		GLGA.GLGlobalAccountId,
		GLGA.ActivityTypeId,
		GLGA.Code,
		GLGA.SnapshotId
	FROM
		Gdm.SnapshotGLGlobalAccount GLGA
		INNER JOIN #Budget B ON
			GLGA.SnapshotId = B.SnapshotId
	WHERE
		GLGA.IsActive = 1

	PRINT ('Rows inserted into #GLGlobalAccount: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_GLGlobalAccount_GLGlobalAccountId ON #GLGlobalAccount
	(
		GLGlobalAccountId,
		SnapshotId
	)

-- GLGlobalAccountCategorization -------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #GLGlobalAccountCategorization(
		GLGlobalAccountId INT NOT NULL,
		DirectGLMinorCategoryId INT NULL,
		IndirectGLMinorCategoryId INT NULL,
		GLCategorizationId INT NOT NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #GLGlobalAccountCategorization(
		GLGlobalAccountId,
		DirectGLMinorCategoryId,
		IndirectGLMinorCategoryId,
		GLCategorizationId,
		SnapshotId
	)
	SELECT DISTINCT
		GGAC.GLGlobalAccountId,
		GGAC.DirectGLMinorCategoryId,
		GGAC.IndirectGLMinorCategoryId,
		GGAC.GLCategorizationId,
		GGAC.SnapshotId
	FROM
		Gdm.SnapshotGLGlobalAccountCategorization GGAC
		INNER JOIN #Budget B ON
			GGAC.SnapshotId = B.SnapshotId

	PRINT ('Rows inserted into #GLGlobalAccountCategorization ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_GLGlobalAccountCategorization_GLGlobalAccountId_GLCategorizationId ON #GLGlobalAccountCategorization
	(
		GLGlobalAccountId,
		GLCategorizationId,
		SnapshotId
	)

-- GLMinorCategory -------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #GLMinorCategory (
		SnapshotId INT NOT NULL,
		GLMinorCategoryId INT NOT NULL,
		GLMajorCategoryId INT NOT NULL
	)
	INSERT INTO #GLMinorCategory
	SELECT DISTINCT
		MinC.SnapshotId,
		MinC.GLMinorCategoryId,
		MinC.GLMajorCategoryId
	FROM
		Gdm.SnapshotGLMinorCategory MinC
		INNER JOIN #Budget B ON
			MinC.SnapshotId = B.SnapshotId
	WHERE
		MinC.IsActive = 1

	PRINT ('Rows inserted into #GLMinorCategory: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_GLMinorCategory_GLMinorCategoryId ON #GLMinorCategory(SnapshotId, GLMinorCategoryId)

-- GLMajorCategory -------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #GLMajorCategory (
		[SnapshotId] INT NOT NULL,
		[GLMajorCategoryId] INT NOT NULL,
		Name VARCHAR(400) NOT NULL,
		GLFinancialCategoryId INT NULL,
		GLCategorizationId INT NOT NULL
	)
	INSERT INTO #GLMajorCategory
	(
		SnapshotId,
		GLMajorCategoryId,
		Name,
		GLFinancialCategoryId,
		GLCategorizationId
	)
	SELECT DISTINCT
		MajC.SnapshotId,
		MajC.GLMajorCategoryId,
		Name,
		MajC.GLFinancialCategoryId,
		MajC.GLCategorizationId
	FROM
		Gdm.SnapshotGLMajorCategory MajC
		INNER JOIN #Budget B ON
			MajC.SnapshotId = B.SnapshotId
	WHERE
		MajC.IsActive = 1

	PRINT ('Rows inserted into #GLMajorCategory: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_GLMajorCategory_GLMajorCategoryId ON #GLMajorCategory(SnapshotId, GLMajorCategoryId)

-- GLFinancialCategory ---------------------------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #GLFinancialCategory
	(
		SnapshotId INT NOT NULL,
		GLFinancialCategoryId INT NOT NULL,
		Name VARCHAR(50) NOT NULL,
		GLCategorizationId INT NOT NULL,
		InflowOutflow VARCHAR(7) NOT NULL
	)
	INSERT INTO #GLFinancialCategory(
		SnapshotId,
		GLFinancialCategoryId,
		Name,
		GLCategorizationId,
		InflowOutflow
	)
	SELECT DISTINCT
		FinC.SnapshotId,
		FinC.GLFinancialCategoryId,
		FinC.Name,
		FinC.GLCategorizationId,
		FinC.InflowOutflow
	FROM
		Gdm.SnapshotGLFinancialCategory FinC
		INNER JOIN #Budget B ON
			FinC.SnapshotId = B.SnapshotId

	PRINT ('Rows inserted into #GLFinancialCategory ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_GLFinancialCategory_GLFinancialCategoryId ON #GLFinancialCategory(SnapshotId, GLFinancialCategoryId)

-- GLCategorization ---------------------------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #GLCategorization
	(
		SnapshotId INT NOT NULL,
		GLCategorizationId INT NOT NULL,
		GLCategorizationTypeId INT NOT NULL,
		Name VARCHAR(50) NOT NULL
	)
	INSERT INTO #GLCategorization(
		SnapshotId,
		GLCategorizationId,
		GLCategorizationTypeId,
		Name
	)
	SELECT DISTINCT
		GC.SnapshotId,
		GC.GLCategorizationId,
		GC.GLCategorizationTypeId,
		GC.Name
	FROM
		Gdm.SnapshotGLCategorization GC
		INNER JOIN #Budget B ON
			GC.SnapshotId = B.SnapshotId
	WHERE
		GC.IsActive = 1	

	PRINT ('Rows inserted into #GLCategorization ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- GLCategorizationType ---------------------------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #GLCategorizationType(
		SnapshotId INT NOT NULL,
		GLCategorizationTypeId INT NOT NULL
	)
	INSERT INTO #GLCategorizationType(
		SnapshotId,
		GLCategorizationTypeId
	)
	SELECT DISTINCT
		GCT.SnapshotId,
		GCT.GLCategorizationTypeId
	FROM
		Gdm.SnapshotGLCategorizationType GCT
		INNER JOIN #Budget B ON
			GCT.SnapshotId = B.SnapshotId
	WHERE
		GCT.IsActive = 1	

	PRINT ('Rows inserted into #GLCategorizationType ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- ReportingCategorization ---------------------------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #ReportingCategorization
	(
		SnapshotId INT NOT NULL,
		EntityTypeId INT NOT NULL,
		AllocationSubRegionGlobalRegionId INT NOT NULL,
		GLCategorizationId INT NOT NULL
	)
	INSERT INTO #ReportingCategorization(
		SnapshotId,
		EntityTypeId,
		AllocationSubRegionGlobalRegionId,
		GLCategorizationId
	)
	SELECT DISTINCT
		RC.SnapshotId,
		RC.EntityTypeId,
		RC.AllocationSubRegionGlobalRegionId,
		RC.GLCategorizationId
	FROM
		Gdm.SnapshotReportingCategorization RC
		INNER JOIN #Budget B ON
			RC.SnapshotId = B.SnapshotId

	PRINT ('Rows inserted into #ReportingCategorization ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_ReportingCategorization_EntityTypeId_AllocationSubRegionGlobalRegionId ON #ReportingCategorization
	(
		SnapshotId,
		EntityTypeId,
		AllocationSubRegionGlobalRegionId
	)

-- ConsolidationRegionCorporateDepartment (CC16) -----------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #ConsolidationRegionCorporateDepartment
	(
		ConsolidationRegionCorporateDepartmentId INT NOT NULL,
		CorporateDepartmentCode VARCHAR(10) NOT NULL,
		SourceCode VARCHAR(2) NOT NULL,
		GlobalRegionId INT NOT NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #ConsolidationRegionCorporateDepartment
	SELECT DISTINCT
		CRCD.ConsolidationRegionCorporateDepartmentId,
		CRCD.CorporateDepartmentCode,
		CRCD.SourceCode,
		CRCD.GlobalRegionId,
		CRCD.SnapshotId
	FROM
		Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD
		INNER JOIN #Budget B ON
			CRCD.SnapshotId = B.SnapshotId

	PRINT ('Rows inserted into #ConsolidationRegionCorporateDepartment: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_ConsolidationRegionCorporateDepartment_CorporateDepartmentCode ON #ConsolidationRegionCorporateDepartment
	(
		CorporateDepartmentCode,
		SourceCode,
		SnapshotId
		
	)
	
-- ConsolidationRegionPropertyEntity (CC16) -----------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #ConsolidationRegionPropertyEntity
	(
		ConsolidationRegionPropertyEntityId INT NOT NULL,
		PropertyEntityCode VARCHAR(10) NOT NULL,
		SourceCode VARCHAR(2) NOT NULL,
		GlobalRegionId INT NOT NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #ConsolidationRegionPropertyEntity
	SELECT DISTINCT
		CRPE.ConsolidationRegionPropertyEntityId,
		CRPE.PropertyEntityCode,
		CRPE.SourceCode,
		CRPE.GlobalRegionId,
		CRPE.SnapshotId
	FROM
		Gdm.SnapshotConsolidationRegionPropertyEntity CRPE
		INNER JOIN #Budget B ON
			CRPE.SnapshotId = B.SnapshotId

	PRINT ('Rows inserted into #ConsolidationRegionCorporateDepartment: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_ConsolidationRegionPropertyEntity_PropertyEntityCode ON #ConsolidationRegionPropertyEntity
	(
		PropertyEntityCode,
		SourceCode,
		SnapshotId
		
	)
-- PropertyFund --------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #PropertyFund
	(
		PropertyFundId INT NOT NULL,
		EntityTypeId INT NOT NULL,
		AllocationSubRegionGlobalRegionId INT NOT NULL,
		IsReportingEntity BIT NOT NULL,
		IsPropertyFund BIT NOT NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #PropertyFund
	SELECT DISTINCT
		PF.PropertyFundId,
		PF.EntityTypeId,
		PF.AllocationSubRegionGlobalRegionId,
		PF.IsReportingEntity,
		PF.IsPropertyFund,
		PF.SnapshotId
	FROM
		Gdm.SnapshotPropertyFund PF
		INNER JOIN #Budget B ON
			B.SnapshotId = PF.SnapshotId
	WHERE
		PF.IsActive = 1

	PRINT ('Rows inserted into #PropertyFund: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_PropertyFund_PropertyFundId ON #PropertyFund(PropertyFundId, SnapshotId)

-- ActivityType --------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #ActivityType(
		ActivityTypeId INT NOT NULL,
		Code VARCHAR(10) NOT NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #ActivityType
	SELECT DISTINCT
		ActivityTypeId,
		Code,
		AT.SnapshotId
	FROM
		Gdm.SnapshotActivityType AT
		INNER JOIN #Budget B ON
			AT.SnapshotId = B.SnapshotId
	WHERE
		AT.IsActive = 1

	PRINT ('Rows inserted into #ActivityType: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_ActivityType_ActivityTypeId ON #ActivityType(ActivityTypeId, SnapshotId)

-- Department --------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #CorporateDepartment(
		Code CHAR(8) NOT NULL,
		SourceCode CHAR(2) NOT NULL,
		FunctionalDepartmentId INT NULL,
		IsTsCost BIT NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO	#CorporateDepartment
	SELECT DISTINCT
		D.Code,
		D.SourceCode,
		D.FunctionalDepartmentId,
		D.IsTsCost,
		D.SnapshotId
	FROM
		Gdm.SnapshotCorporateDepartment D
		INNER JOIN #Budget B ON
			D.SnapshotId = B.SnapshotId
	WHERE
		D.IsActive = 1

	PRINT ('Rows inserted into #CorporateDepartment: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_CorporateDeparment_Code ON #CorporateDepartment(Code, SourceCode, SnapshotId)

-- FunctionalDepartment --------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #FunctionalDepartment
	(
		FunctionalDepartmentId INT NOT NULL,
		Code VARCHAR(20) NULL,
		GlobalCode VARCHAR(30) NULL
	)

	INSERT INTO #FunctionalDepartment
	SELECT DISTINCT
		FunctionalDepartmentId,
		Code,
		GlobalCode
	FROM
		HR.FunctionalDepartment FD
	
		INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FDa ON
			FD.ImportKey = FDa.ImportKey
	WHERE
		FD.IsActive = 1

	PRINT ('Rows inserted into #FunctionalDepartment: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_FunctionalDepartment_FunctionalDepartmentId ON #FunctionalDepartment(FunctionalDepartmentId)

-- AllocationSubRegion --------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #AllocationSubRegion
	(
		SnapshotId INT NOT NULL,
		AllocationSubRegionGlobalRegionId INT NOT NULL,
		Code VARCHAR(10) NOT NULL,
		Name VARCHAR(50) NOT NULL,
		AllocationRegionGlobalRegionId INT NULL,
		DefaultCorporateSourceCode CHAR(2) NOT NULL
	)
	INSERT INTO #AllocationSubRegion
	SELECT DISTINCT
		ASR.SnapshotId,
		ASR.AllocationSubRegionGlobalRegionId,
		ASR.Code,
		ASR.Name,
		ASR.AllocationRegionGlobalRegionId,
		ASR.DefaultCorporateSourceCode
	FROM
		Gdm.SnapshotAllocationSubRegion ASR
		INNER JOIN #Budget B ON
			ASR.SnapshotId = B.SnapshotId
	WHERE
		ASR.IsActive = 1

	PRINT ('Rows inserted into #AllocationSubRegion: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_AllocationSubRegion_AllocationSubRegionGlobalRegionId ON #AllocationSubRegion
	(
		AllocationSubRegionGlobalRegionId,
		SnapshotId
	)

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
			
END


/* ==============================================================================================================================================
	5.	Create master GL Account Category mapping table
   ============================================================================================================================================ */
BEGIN

	-- Should only relate to the snapshot associated with the budget that is currently being processed

	SET @StartTime = GETDATE()

	CREATE TABLE #GlAccountCategoryMapping (
		SnapshotId INT NOT NULL,
		GLGlobalAccountId INT NOT NULL,
		IsDirect BIT NOT NULL,
		GlobalGLCategorizationHierarchyKey VARCHAR(50) NULL,
		USPropertyGLCategorizationHierarchyKey VARCHAR(50) NULL,
		USFundGLCategorizationHierarchyKey VARCHAR(50) NULL,
		EUPropertyGLCategorizationHierarchyKey VARCHAR(50) NULL,
		EUFundGLCategorizationHierarchyKey VARCHAR(50) NULL,
		USDevelopmentGLCategorizationHierarchyKey VARCHAR(50) NULL,
		EUDevelopmentGLCategorizationHierarchyKey VARCHAR(50) NULL		
	)
	INSERT INTO #GlAccountCategoryMapping
	(
		SnapshotId,
		GLGlobalAccountId,
		IsDirect,
		GlobalGLCategorizationHierarchyKey,
		USPropertyGLCategorizationHierarchyKey,
		USFundGLCategorizationHierarchyKey,
		EUPropertyGLCategorizationHierarchyKey,
		EUFundGLCategorizationHierarchyKey,
		USDevelopmentGLCategorizationHierarchyKey,
		EUDevelopmentGLCategorizationHierarchyKey
	)
	SELECT
		PivotTable.SnapshotId,
		PivotTable.GLGlobalAccountId,
		PivotTable.IsDirectCost,
		PivotTable.[Global] AS GlobalGLCategorizationHierarchyKey,
		PivotTable.[US Property] AS USPropertyGLCategorizationHierarchyKey,
		PivotTable.[US Fund] AS USFundGLCategorizationHierarchyKey,
		PivotTable.[EU Property] AS EUPropertyGLCategorizationHierarchyKey,
		PivotTable.[EU Fund] AS EUFundGLCategorizationHierarchyKey,
		PivotTable.[US Development] AS USDevelopmentGLCategorizationHierarchyKey,
		PivotTable.[EU Development] AS EUDevelopmentGLCategorizationHierarchyKey
	FROM
		(	
			-- Indirect Minor Categories
			SELECT
				GGA.SnapshotId,
				GGA.GLGlobalAccountId,
				GLC.Name AS GLCategorizationName,
				ISNULL(GCH.GLCategorizationHierarchyKey, UnknownGCH.GLCategorizationHierarchyKey) AS GLCategorizationHierarchyKey,
				0 AS IsDirectCost
			FROM
				#GLGlobalAccount GGA
				
				INNER JOIN #GLCategorization GLC ON
					GGA.SnapshotId = GLC.SnapshotId  
				
				INNER JOIN #GLCategorizationType GLCT ON
					GLC.GLCategorizationTypeId = GLCT.GLCategorizationTypeId AND
					GLC.SnapshotId = GLCT.SnapshotId 			
				
				LEFT OUTER JOIN #GLGlobalAccountCategorization GLGAC ON
					GGA.GLGlobalAccountId = GLGAC.GLGlobalAccountId   AND
					GGA.SnapshotId = GLGAC.SnapshotId  AND
					GLC.GLCategorizationId = GLGAC.GLCategorizationId					

				LEFT OUTER JOIN #GLMinorCategory MinC ON
					GLGAC.IndirectGLMinorCategoryId = MinC.GLMinorCategoryId AND
					GLGAC.SnapshotId  = MinC.SnapshotId  
					
				LEFT OUTER JOIN #GLMajorCategory MajC ON
					MinC.GLMajorCategoryId = MajC.GLMajorCategoryId	AND
					MinC.SnapshotId = MajC.SnapshotId
				
				LEFT OUTER JOIN #GLFinancialCategory FinC ON
					MajC.GLFinancialCategoryId = FinC.GLFinancialCategoryId  AND
					MajC.SnapshotId = FinC.SnapshotId  
				
 				LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy GCH ON
					GCH.GLCategorizationHierarchyCode = 
						CONVERT(VARCHAR(2),  GLCT.GLCategorizationTypeId) + ':' +
						CONVERT(VARCHAR(10), GLC.GLCategorizationId) + ':' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE FinC.GLFinancialCategoryId END) + ':' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE MajC.GLMajorCategoryId END) + ':' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE MinC.GLMinorCategoryId END) + ':' +
						CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1)) AND
					GLCT.SnapshotId = GCH.SnapshotId
					
				LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy UnknownGCH ON
					UnknownGCH.GLCategorizationHierarchyCode = 
						CONVERT(VARCHAR(2),  GLCT.GLCategorizationTypeId) + ':' +
						CONVERT(VARCHAR(10), GLC.GLCategorizationId) + ':-1:-1:-1:' +
						CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1)) AND
					GGA.SnapshotId = UnknownGCH.SnapshotId
					
			UNION

			-- Direct Minor Categories
			SELECT
				GGA.SnapshotId,
				GGA.GLGlobalAccountId,
				GLC.Name AS GLCategorizationName,
				ISNULL(GCH.GLCategorizationHierarchyKey, UnknownGCH.GLCategorizationHierarchyKey) AS GLCategorizationHierarchyKey,
				1 AS IsDirectCost
			FROM
				#GLGlobalAccount GGA
				
				INNER JOIN #GLCategorization GLC ON
					GGA.SnapshotId = GLC.SnapshotId  
				
				LEFT OUTER JOIN #GLCategorizationType GLCT ON
					GLC.GLCategorizationTypeId = GLCT.GLCategorizationTypeId AND
					GLC.SnapshotId = GLCT.SnapshotId 			
				
				LEFT OUTER JOIN #GLGlobalAccountCategorization GLGAC ON
					GGA.GLGlobalAccountId = GLGAC.GLGlobalAccountId   AND
					GGA.SnapshotId = GLGAC.SnapshotId  AND
					GLC.GLCategorizationId = GLGAC.GLCategorizationId					

				LEFT OUTER JOIN #GLMinorCategory MinC ON
					GLGAC.DirectGLMinorCategoryId = MinC.GLMinorCategoryId AND
					GLGAC.SnapshotId  = MinC.SnapshotId  
					
				LEFT OUTER JOIN #GLMajorCategory MajC ON
					MinC.GLMajorCategoryId = MajC.GLMajorCategoryId	AND
					MinC.SnapshotId = MajC.SnapshotId
				
				LEFT OUTER JOIN #GLFinancialCategory FinC ON
					MajC.GLFinancialCategoryId = FinC.GLFinancialCategoryId  AND
					MajC.SnapshotId = FinC.SnapshotId  
				
 				LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy GCH ON
					GCH.GLCategorizationHierarchyCode = 
						CONVERT(VARCHAR(2),  GLCT.GLCategorizationTypeId) + ':' +
						CONVERT(VARCHAR(10), GLC.GLCategorizationId) + ':' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE FinC.GLFinancialCategoryId END) + ':' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE MajC.GLMajorCategoryId END) + ':' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE MinC.GLMinorCategoryId END) + ':' +
						CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1)) AND
					GLCT.SnapshotId = GCH.SnapshotId
					
				LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy UnknownGCH ON
					UnknownGCH.GLCategorizationHierarchyCode = 
						CONVERT(VARCHAR(2),  GLCT.GLCategorizationTypeId) + ':' +
						CONVERT(VARCHAR(10), GLC.GLCategorizationId) + ':-1:-1:-1:' +
						CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1)) AND
					GGA.SnapshotId = UnknownGCH.SnapshotId
		) Mappings

		PIVOT
		(
			MAX(GLCategorizationHierarchyKey)
			FOR
				GLCategorizationName IN ([Global], [US Property], [US Fund], [EU Property], [EU Fund], [US Development], [EU Development])
		) AS PivotTable

	PRINT ('Rows inserted into #GLAccountCategoryMapping: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_GlAccountCategoryMapping_GLGlobalAccountId ON #GlAccountCategoryMapping(GLGlobalAccountId, SnapshotId, IsDirect)

END

/* ==============================================================================================================================================
	6.	Create the temporary source table into which Non-Payroll Expense and Fee budgets are to be inserted
   =========================================================================================================================================== */
BEGIN

	SET @StartTime = GETDATE()

	CREATE TABLE #ProfitabilitySource
	(
		ImportBatchId INT NOT NULL,
		SourceName varchar(20),
		BudgetReforecastTypeKey INT NOT NULL,
		SnapshotId INT NOT NULL,
		BudgetId INT NOT NULL,
		ReferenceCode VARCHAR(300) NOT NULL,
		ExpensePeriod CHAR(6) NOT NULL,	
		SourceCode VARCHAR(2) NULL,
		BudgetAmount MONEY NOT NULL,
		GLGlobalAccountId INT NULL,
		FunctionalDepartmentCode VARCHAR(20) NULL,
		JobCode VARCHAR(20) NULL,
		Reimbursable VARCHAR(3) NULL, -- NULL because this field is determined via an outer join
		ActivityTypeId INT NULL, -- NULL because for Fees this field is determined via an outer join
		PropertyFundId INT NULL, -- NULL because this field is determined via an outer join
		AllocationSubRegionGlobalRegionId INT NULL, -- NULL because this field is determined via an outer join
		ConsolidationSubRegionGlobalRegionId INT NULL,
		OriginatingGlobalRegionId INT NULL,
		LocalCurrencyCode CHAR(3) NOT NULL,
		LockedDate DATETIME NULL,
		IsExpense BIT NOT NULL,
		UnallocatedOverhead CHAR(7) NULL, -- NULL because this field is determined via an outer join
		FeeAdjustment VARCHAR(9) NOT NULL,
		ReforecastKey INT NOT NULL,
		IsDirectCost BIT NULL,
		DefaultGLCategorizationId INT NULL,
		SourceTableName VARCHAR(255) NOT NULL
	)

END

/* ==============================================================================================================================================
	7.	Get Non-Payroll Expense BUDGET items from GBS (NB: these are BUDGET figures only, not ACTUAL figures)
   =========================================================================================================================================== */
BEGIN

-- Insert original budget amounts ------------

	INSERT INTO #ProfitabilitySource
	(
		ImportBatchId,
		SourceName,
		BudgetReforecastTypeKey,
		SnapshotId,
		BudgetId,
		ReferenceCode,
		ExpensePeriod,
		SourceCode,
		BudgetAmount,
		GLGlobalAccountId,
		FunctionalDepartmentCode,
		JobCode,
		Reimbursable,
		ActivityTypeId,
		PropertyFundId,
		AllocationSubRegionGlobalRegionId,
		ConsolidationSubRegionGlobalRegionId,
		OriginatingGlobalRegionId,
		LocalCurrencyCode,
		LockedDate,
		IsExpense,
		UnallocatedOverhead,
		FeeAdjustment,
		ReforecastKey,
		IsDirectCost,
		DefaultGLCategorizationId,
		SourceTableName
	)
	SELECT
		Budget.ImportBatchId,
		'NPEB' as SourceName,
		@ReforecastTypeIsGBSBUDKey,
		Budget.SnapshotId,
		Budget.BudgetId,                                                        -- BudgetId
		'GBS:BudgetId=' + LTRIM(RTRIM(STR(Budget.BudgetId))) +
			'&NonPayrollExpenseBreakdownId=' + LTRIM(RTRIM(STR(NPEB.NonPayrollExpenseBreakdownId))) +
			'&SnapshotId=' + LTRIM(RTRIM(STR(Budget.SnapshotId))),              -- ReferenceCode
		NPEB.Period,                                                            -- ExpensePeriod: Period is actually a foreign key to
		                                                                        --    PeriodExtended but is also the implied period value,
		                                                                        --    e.g.: 201009
		CASE WHEN NPEB.IsDirectCost = 1 THEN CPSC.PropertySourceCode ELSE NPEB.CorporateSourceCode END AS CorporateSourceCode,	
		NPEB.Amount,                                                            -- BudgetAmount
		ISNULL(NPEB.ActivitySpecificGLGlobalAccountId, NPEB.GLGlobalAccountId), -- GLGlobalAccountId
		FD.GlobalCode,                                                          -- FunctionalDepartmentCode
		NPEB.JobCode,                                                           -- JobCode
		CASE WHEN CD.IsTsCost = 0 THEN 'YES' ELSE 'NO' END,                     -- Reimbursable
		NPEB.ActivityTypeId,                                                    -- ActivityTypeId: this Id should correspond to the correct Id
		                                                                        --     in GDM
		PF.PropertyFundId,                                                      -- PropertyFundId
		PF.AllocationSubRegionGlobalRegionId,                                   -- AllocationSubRegionGlobalRegionId
		CRCD.GlobalRegionId,                                                    -- ConsolidationSubRegionGlobalRegionId,
		NPEB.OriginatingSubRegionGlobalRegionId,                                -- OriginatingGlobalRegionId
		NPEB.CurrencyCode,                                                      -- LocalCurrencyCode
		Budget.LastLockedDate,                                                  -- LockedDate
		1,                                                                      -- IsExpense
		CASE WHEN AT.Code = 'CORPOH' THEN 'UNALLOC' ELSE 'N/A' END,         -- UnallocatedOverhead
		'NORMAL',                                                               -- FeeAdjustment,
		Budget.ReforecastKey,
		NPEB.IsDirectCost,
		RC.GLCategorizationId,
		'NonPayrollExpenseBreakdown'
	FROM
		#Budget Budget

		INNER JOIN GBS.NonPayrollExpenseBreakdown NPEB ON
			Budget.BudgetId = NPEB.BudgetId AND
			Budget.ImportBatchId = NPEB.ImportBatchId
			
		INNER JOIN GBS.NonPayrollExpense NPE ON
			NPEB.NonPayrollExpenseId = NPE.NonPayrollExpenseId AND
			NPEB.ImportBatchId = NPE.ImportBatchId

		-- Corporate and Property MRI source codes
		INNER JOIN #CorporatePropertySourceCodes CPSC ON
			NPEB.CorporateSourceCode = CPSC.CorporateSourceCode

		LEFT OUTER JOIN
		(	-- these NonPayrollExpenses need to be excluded because they are in dispute

			/* Disputes are created at the level of a budget project. A budget project will dispute the portion of a non-payroll expense that is
			   allocated to them (via the NonPayrollExpenseBreakdown table, which includes the NonPayrollExpenseId and BudgetProjectId fields,
			   allowing for the portion of the non-payroll expense that has been allocated to the budget project to be determined).
			   
			   If, for example, a non-payroll expense is split between two budget projects, and one of these budget projects is disputing their
			   allocation, the portion of the non-payroll expense that is allocated to the budget project that is not disputing must still be
			   included. Only thet portion of the non-payroll expense that is currently being disputed must be excluded.	   
			*/

			SELECT DISTINCT
				NPED.ImportBatchId,
				NPED.NonPayrollExpenseId,
				NPED.BudgetProjectId
			FROM
				GBS.NonPayrollExpenseDispute NPED
				INNER JOIN GBS.DisputeStatus DS ON
					NPED.DisputeStatusId = DS.DisputeStatusId AND
					NPED.ImportBatchId = DS.ImportBatchId
			WHERE
				DS.Name <> 'Resolved' AND
				DS.IsActive = 1
				
		) DisputedNonPayrollExpenseItems ON
			NPEB.NonPayrollExpenseId = DisputedNonPayrollExpenseItems.NonPayrollExpenseId AND
			NPEB.BudgetProjectId = DisputedNonPayrollExpenseItems.BudgetProjectId AND
			NPEB.ImportBatchId = DisputedNonPayrollExpenseItems.ImportBatchId

		LEFT OUTER JOIN #ConsolidationRegionCorporateDepartment CRCD ON
			NPEB.CorporateDepartmentCode = CRCD.CorporateDepartmentCode AND
			NPEB.CorporateSourceCode = CRCD.SourceCode AND
			Budget.SnapshotId = CRCD.SnapshotId

		-- AllocationRegionId
		LEFT OUTER JOIN #PropertyFund PF ON
			NPEB.ReportingEntityPropertyFundId = PF.PropertyFundId AND
			Budget.SnapshotId = PF.SnapshotId

		-- Overhead Type
		LEFT OUTER JOIN #ActivityType AT ON
			NPEB.ActivityTypeId = AT.ActivityTypeId AND
			Budget.SnapshotId = AT.SnapshotId -- 

		-- Reimbursable
		LEFT OUTER JOIN #CorporateDepartment CD ON
			NPEB.CorporateSourceCode = CD.SourceCode AND
			NPEB.CorporateDepartmentCode = CD.Code AND
			Budget.SnapshotId = CD.SnapshotId --

		-- FunctionalDepartmentCode
		LEFT OUTER JOIN #FunctionalDepartment FD ON
			NPEB.FunctionalDepartmentId = FD.FunctionalDepartmentId

		-- 	ReportingCategorization
		LEFT OUTER JOIN #ReportingCategorization RC ON
			PF.AllocationSubRegionGlobalRegionId = RC.AllocationSubRegionGlobalRegionId AND
			PF.EntityTypeId = RC.EntityTypeId AND
			Budget.SnapshotId = RC.SnapshotId  
	WHERE
		DisputedNonPayrollExpenseItems.NonPayrollExpenseId IS NULL AND -- Exclude all disputed items
		NPEB.Period >= Budget.FirstProjectedPeriodNonPayroll AND
		NPE.IsDeleted = 0

	PRINT ('Rows inserted into #ProfitabilitySource: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END

/* ==============================================================================================================================================
	8.	Get Fee BUDGET items from GBS (NB: these are BUDGET figures only, not ACTUAL figures)
============================================================================================================================================== */
BEGIN

	SET @StartTime = GETDATE()

	INSERT INTO #ProfitabilitySource
	(
		ImportBatchId,
		SourceName, -- [!!]
		BudgetReforecastTypeKey,
		SnapshotId,
		BudgetId,
		ReferenceCode,
		ExpensePeriod,
		SourceCode,
		BudgetAmount,
		GLGlobalAccountId,
		FunctionalDepartmentCode,
		JobCode,
		Reimbursable,
		ActivityTypeId,
		PropertyFundId,
		AllocationSubRegionGlobalRegionId,
		ConsolidationSubRegionGlobalRegionId,
		OriginatingGlobalRegionId,
		LocalCurrencyCode,
		LockedDate,
		IsExpense,
		UnallocatedOverhead,
		FeeAdjustment,
		ReforecastKey,
		IsDirectCost,
		DefaultGLCategorizationId,
		SourceTableName
	)
	SELECT
		Budget.ImportBatchId,
		'Fees' as SourceName,
		@ReforecastTypeIsGBSBUDKey,
		Budget.Snapshotid,
		Budget.BudgetId,                                                         -- BudgetId
		'GBS:BudgetId=' + LTRIM(RTRIM(STR(Budget.BudgetId))) +
			'&FeeId=' + LTRIM(RTRIM(STR(Fee.FeeId))) +
			'&FeeDetailId=' + LTRIM(RTRIM(STR(FeeDetail.FeeDetailId))) +
			'&SnapshotId=' + LTRIM(RTRIM(STR(Budget.SnapshotId))),               -- ReferenceCode
		FeeDetail.Period,                                                        -- ExpensePeriod
		ASR.DefaultCorporateSourceCode,                                          -- SourceCode
		FeeDetail.Amount,
		GA.GLGlobalAccountId,                                                    -- GLGlobalAccountId
		NULL,                                                                    -- FunctionalDepartmentId
		NULL,                                                                    -- JobCode
		'NO',                                                                    -- Reimbursable
		GA.ActivityTypeId,                                                       -- ActivityType: determined by finding Fee.GLGlobalAccountId
		                                                                         --     on GrReportingStaging.dbo.GLGlobalAccount
		Fee.PropertyFundId,                                                      -- PropertyFundId
		PF.AllocationSubRegionGlobalRegionId,                                   -- AllocationSubRegionGlobalRegionId
		PF.AllocationSubRegionGlobalRegionId,                                   -- ConsolidationSubRegionGlobalRegionId (CC16)
		PF.AllocationSubRegionGlobalRegionId,                                   -- OriginatingGlobalRegionId: allocation region = originating
                                                                                 --     region for Fee Income
		Fee.CurrencyCode,
		Budget.LastLockedDate,                                                   -- LockedDate
		0,                                                                       -- IsExpense
		'N/A',                                                               -- IsUnallocatedOverhead: defaults to UNKNOWN for fees
		CASE WHEN FeeDetail.IsAdjustment = 1 THEN 'FEEADJUST' ELSE 'NORMAL' END, -- IsFeeAdjustment, field isn't NULLABLE
		Budget.ReforecastKey,
		NULL,                                                                    -- IsDirectCost
		RC.GLCategorizationId,                                                    -- DefaultGLCategorizationId
		'Fee'
	FROM
		#Budget Budget

		INNER JOIN GBS.Fee Fee ON
			Budget.BudgetId = Fee.BudgetId AND
			Budget.ImportBatchId = Fee.ImportBatchId

		INNER JOIN GBS.FeeDetail FeeDetail ON
			Fee.FeeId = FeeDetail.FeeId AND
			Fee.ImportBatchId = FeeDetail.ImportBatchId

		LEFT OUTER JOIN #GLGlobalAccount GA ON
			Fee.GLGlobalAccountId = GA.GLGlobalAccountId AND
			Budget.SnapshotId = GA.SnapshotId

		-- SourceCode


		LEFT OUTER JOIN #PropertyFund PF ON
			Fee.PropertyFundId  = PF.PropertyFundId AND
			Budget.SnapshotId = PF.SnapshotId  

		LEFT OUTER JOIN #AllocationSubRegion ASR ON
			PF.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId AND
			Budget.SnapshotID = ASR.SnapshotId
			
		LEFT OUTER JOIN #ReportingCategorization RC ON
			ASR.AllocationSubRegionGlobalRegionId = RC.AllocationSubRegionGlobalRegionId AND
			PF.EntityTypeId = RC.EntityTypeId AND
			Budget.SnapshotId = RC.SnapshotId  
	WHERE
		Fee.IsDeleted = 0 AND
		FeeDetail.Amount <> 0 AND
		FeeDetail.Period >= Budget.FirstProjectedPeriodFees

	PRINT ('Fee Budgets inserted into #ProfitabilitySource: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END

/* ==============================================================================================================================================
	9.	Get Fee Income and Non-Payroll Expense ACTUALS from GBS.BudgetProfitabilityActual (NB: these are ACTUAL figures only, not BUDGET figures)
   =========================================================================================================================================== */
BEGIN

	SET @StartTime = GETDATE()

-- Filter the GBS.BudgetProfitabilityActual table so that only Fee Income and Non-Payroll Expense transactions that are for a period that is
--     before their associated first projected periods are considered

	CREATE TABLE #BudgetProfitabilityActual
	(
		ImportBatchId INT NOT NULL,
		BudgetProfitabilityActualId INT NOT NULL,
		BudgetId INT NOT NULL,
		Period INT NOT NULL,
		GLGlobalAccountId INT NOT NULL,
		SourceCode CHAR(2) NOT NULL, -- ?????
		FunctionalDepartmentId INT NOT NULL,
		CorporateJobCode VARCHAR(20) NULL,
		IsTsCost BIT NOT NULL,
		ActivityTypeId INT NOT NULL,
		ReportingEntityPropertyFundId INT NOT NULL,
		OriginatingSubRegionGlobalRegionId INT NOT NULL,
		AllocationSubRegionGlobalRegionId INT NOT NULL,
		CurrencyCode CHAR(3) NOT NULL,
		Amount MONEY NOT NULL,
		ConsolidationSubRegionGlobalRegionId INT NULL,
		IsDirectCost BIT NULL,
		SnapshotId INT NOT NULL,
		IsExpense BIT NOT NULL, -- 0 if Fee Income, 1 if Non-Payroll Expense
		OverheadTypeCode VARCHAR(20) NULL,
		IsGBS BIT NULL,
		PropertyFundCode CHAR(12),
		SourceTableName VARCHAR(255) NOT NULL
	)
	INSERT INTO #BudgetProfitabilityActual
	SELECT DISTINCT
		BPA.ImportBatchId,
		BPA.BudgetProfitabilityActualId,
		BPA.BudgetId,
		BPA.Period,
		BPA.GLGlobalAccountId,
		BPA.SourceCode,
		BPA.FunctionalDepartmentId,
		BPA.CorporateJobCode,
		BPA.IsTsCost,
		BPA.ActivityTypeId,
		BPA.ReportingEntityPropertyFundId,
		BPA.OriginatingSubRegionGlobalRegionId,
		BPA.AllocationSubRegionGlobalRegionId,
		BPA.CurrencyCode,
		BPA.Amount,
		BPA.ConsolidationSubRegionGlobalRegionId,
		BPA.IsDirectCost,
		B.SnapshotId,
		CASE WHEN FinC.InflowOutflow = 'Inflow' THEN 0 ELSE 1 END, -- IF 'Inflow' THEN Income/Not Expense, ELSE Expense
		ISNULL(OHT.Code, 'N/A'), -- OverheadTypeCode
		BPA.IsGBS,
		BPA.PropertyFundCode,
		'BudgetProfitabilityActual'
	FROM
		GBS.BudgetProfitabilityActual BPA

		INNER JOIN #Budget B ON
			BPA.BudgetId = B.BudgetId AND
			BPA.ImportBatchId = B.ImportBatchId
		
		LEFT OUTER JOIN GBS.OverheadType OHT ON
			BPA.OverheadTypeId = OHT.OverheadTypeId AND
			BPA.ImportBatchId = OHT.ImportBatchId
		
		LEFT OUTER JOIN #GLGlobalAccountCategorization GGAC ON
			BPA.GLGlobalAccountId = GGAC.GLGlobalAccountId AND
			B.SnapshotId = GGAC.SnapshotId AND
			GGAC.GLCategorizationId = 233 -- This is just used to find the Global Financial Category, so limit it to Global
		
		LEFT OUTER JOIN #GLMinorCategory MinC ON
			GGAC.SnapshotId = MinC.SnapshotId AND
			GLMinorCategoryId = CASE WHEN BPA.IsDirectCost = 1 THEN GGAC.DirectGLMinorCategoryId ELSE GGAC.IndirectGLMinorCategoryId END
			
		LEFT OUTER JOIN #GLMajorCategory MajC ON
			MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
			MinC.SnapshotId = MajC.SnapshotId
			
		LEFT OUTER JOIN #GLFinancialCategory FinC ON
			MajC.GLFinancialCategoryId = FinC.GLFinancialCategoryId AND
			MajC.SnapshotId = FinC.SnapshotId

	WHERE
		BPA.IsDeleted = 0 AND
		(
			(-- Fee Income
				FinC.InflowOutflow  = 'Inflow' AND
				BPA.Period < B.FirstProjectedPeriodFees
			)
			OR
			(-- Non-Payroll Expenses
				FinC.InflowOutflow = 'Outflow' AND
				MajC.Name NOT IN ('Salaries/Taxes/Benefits', 'General Overhead') AND
				BPA.Period < B.FirstProjectedPeriodNonPayroll
			)
		) AND
		(OHT.Code IS NULL OR OHT.Code = 'UNALLOC')

	PRINT ('Actuals for Fee Income and Non-Payroll inserted: ' + CONVERT(NVARCHAR, @@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	INSERT INTO #ProfitabilitySource (
		ImportBatchId,
		BudgetReforecastTypeKey,
		SnapshotId,
		BudgetId,
		ReferenceCode,
		ExpensePeriod,
		SourceCode,
		BudgetAmount,
		GLGlobalAccountId,
		FunctionalDepartmentCode,
		JobCode,
		Reimbursable,
		ActivityTypeId,
		PropertyFundId,
		AllocationSubRegionGlobalRegionId,
		ConsolidationSubRegionGlobalRegionId,
		OriginatingGlobalRegionId,
		LocalCurrencyCode,
		LockedDate,
		IsExpense,
		UnallocatedOverhead,
		FeeAdjustment,
		ReforecastKey,
		IsDirectCost,
		DefaultGLCategorizationId,
		SourceTableName
	)
	SELECT
		B.ImportBatchId,
		@ReforecastTypeIsGBSACTKey,
		B.SnapshotId,
		B.BudgetId, 
		'GBS:BudgetId=' + LTRIM(RTRIM(STR(B.BudgetId))) +
			'&BudgetProfitabilityActualId=' + LTRIM(RTRIM(STR(BPA.BudgetProfitabilityActualId))) +
			'&IsGBS=' + LTRIM(RTRIM(STR(BPA.IsGBS))) +
			'&SnapshotId=' + LTRIM(RTRIM(STR(b.SnapshotId))) AS ReferenceCode, -- ReferenceCode
		BPA.Period,
		ASR.DefaultCorporateSourceCode, -- SourceCode
		BPA.Amount,
		BPA.GLGlobalAccountId, -- GLGlobalAccountId
		FD.GlobalCode,
		BPA.CorporateJobCode,
		CASE WHEN BPA.IsTsCost = 0 THEN 'YES' ELSE 'NO' END,
		BPA.ActivityTypeId,
		PF.PropertyFundId,
		PF.AllocationSubRegionGlobalRegionId,
		ISNULL(CRCD.GlobalRegionId, CRPE.GlobalRegionId) AS ConsolidationSubRegionGlobalRegionId, -- ConsolidationSubRegionGlobalRegionId (CC16)
		BPA.OriginatingSubRegionGlobalRegionId,	
		BPA.CurrencyCode,
		B.LastLockedDate,
		BPA.IsExpense,
		BPA.OverheadTypeCode, -- UnallocatedOverhead
		'Normal' AS FeeAdjustment,
		B.ReforecastKey,
		BPA.IsDirectCost,
		RC.GLCategorizationId, -- DefaultGLCategorizationId
		BPA.SourceTableName
	FROM 
		#BudgetProfitabilityActual BPA

		INNER JOIN  #Budget B ON
			BPA.BudgetId = B.BudgetId
	
			/*
				GBS only uses the corporate sources. It may have transactions mapped to Property Entities which should have Property 
				source codes. To handle this, we use the #MRIServerSource table to find the associated Property source code of the mapped 
				Corporate source code
			*/
		LEFT OUTER JOIN #MRIServerSource MSS ON
			BPA.SourceCode = MSS.SourceCode
	
		LEFT OUTER JOIN  #PropertyFund PF ON
			BPA.ReportingEntityPropertyFundId = PF.PropertyFundId AND
			B.SnapshotId = PF.SnapshotId
			
		LEFT OUTER JOIN #AllocationSubRegion ASR ON
			PF.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId AND
			B.SnapshotId = ASR.SnapshotId

		LEFT OUTER JOIN #ConsolidationRegionCorporateDepartment CRCD ON
			LTRIM(RTRIM(BPA.PropertyFundCode)) = LTRIM(RTRIM(CRCD.CorporateDepartmentCode)) AND
			BPA.SourceCode = CRCD.SourceCode AND
			B.SnapshotId = CRCD.SnapshotId	
			
		LEFT OUTER JOIN #ConsolidationRegionPropertyEntity CRPE ON
			LTRIM(RTRIM(BPA.PropertyFundCode)) = LTRIM(RTRIM(CRPE.PropertyEntityCode)) AND		
			MSS.MappingSourceCode = CRPE.SourceCode AND
			B.SnapshotId = CRPE.SnapshotId

		-- FunctionalDepartmentCode -> FD.GlobalCode
		LEFT OUTER JOIN #FunctionalDepartment FD ON 
			BPA.FunctionalDepartmentId = FD.FunctionalDepartmentId

		-- Overhead Type
		LEFT OUTER JOIN #ActivityType AT ON
			BPA.ActivityTypeId = AT.ActivityTypeId AND
			B.SnapshotId = AT.SnapshotId -- 

		LEFT OUTER JOIN #ReportingCategorization RC ON
			PF.AllocationSubRegionGlobalRegionId = RC.AllocationSubRegionGlobalRegionId AND
			PF.EntityTypeId = RC.EntityTypeId AND
			B.SnapshotId = RC.SnapshotId

	PRINT ('ProfitibilityActuals Rows inserted into #ProfitabilitySource: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	-- GBS budgets against header accounts, but specifies an activity type for each record.
	-- Use this header account / activity type combination to determine the correct activity type-specific account

	UPDATE
		PS
	SET
		PS.GLGlobalAccountId = GLGA2.GLGlobalAccountId
	FROM
		#ProfitabilitySource PS

		INNER JOIN #GLGlobalAccount GLGA1 ON
			PS.GLGlobalAccountId = GLGA1.GLGlobalAccountId

		INNER JOIN #GLGlobalAccount GLGA2 ON
			(LEFT(GLGA1.Code, 10 - LEN(PS.ActivityTypeId)) + LTRIM(RTRIM(STR(PS.ActivityTypeId)))) = GLGA2.Code
	WHERE
		LEN(GLGA1.Code) = 10 AND -- A code of 10 characters excludes the account prefix (CP, TS) and includes the activity type code, i.e.: 5020100012
		RIGHT(GLGA1.Code, 2) = '00' -- where the header account has been budgeted against

	PRINT ('Rows updated in #ProfitabilitySource (GLAccount update from head to activity-specific GL Account: ' + LTRIM(RTRIM(STR(@@rowcount))))

	CREATE NONCLUSTERED INDEX IX_ProfitabilitySource ON
		#ProfitabilitySource
		(
			PropertyFundId,
			AllocationSubRegionGlobalRegionId,
			ConsolidationSubRegionGlobalRegionId,
			OriginatingGlobalRegionId,
			JobCode,
			FunctionalDepartmentCode,
			ExpensePeriod
		)

END

/* ==============================================================================================================================================
	10.	Join to dimension tables in GrReporting and attempt to resolve keys, otherwise default to UNKNOWN if NULL
   =========================================================================================================================================== */
BEGIN

	SET @StartTime = GETDATE()

	CREATE TABLE #ProfitabilityReforecast(
		ImportBatchId INT NOT NULL,
		SourceName varchar(20),
		BudgetReforecastTypeKey INT NOT NULL,
		SnapshotId INT NOT NULL,
		CalendarKey int NOT NULL,
		SourceKey int NOT NULL,
		FunctionalDepartmentKey int NOT NULL,
		ReimbursableKey int NOT NULL,
		ActivityTypeKey int NOT NULL,
		PropertyFundKey int NOT NULL,	
		AllocationRegionKey int NOT NULL,
		ConsolidationRegionKey int NOT NULL,
		OriginatingRegionKey int NOT NULL,
		OverheadKey int NOT NULL,
		FeeAdjustmentKey int NOT NULL,
		LocalCurrencyKey int NOT NULL,
		LocalReforecast money NOT NULL,
		ReferenceCode Varchar(300) NOT NULL,
		BudgetId int NOT NULL,
		--SourceSystemId int NOT NULL,
		IsExpense BIT NOT NULL,
		ReforecastKey INT NOT NULL,
		IsDirectCost BIT NULL,
		GlGlobalAccountId INT NULL,
		DefaultGLCategorizationId INT NULL,
		
		GlobalGLCategorizationHierarchyKey			INT NULL,
		USPropertyGLCategorizationHierarchyKey		INT NULL,
		USFundGLCategorizationHierarchyKey			INT NULL,
		EUPropertyGLCategorizationHierarchyKey		INT NULL,
		EUFundGLCategorizationHierarchyKey			INT NULL,
		USDevelopmentGLCategorizationHierarchyKey	INT NULL,
		EUDevelopmentGLCategorizationHierarchyKey	INT NULL,
		ReportingGLCategorizationHierarchyKey		INT NULL,
		
		SourceSystemKey INT NOT NULL
	)
	INSERT INTO #ProfitabilityReforecast 
	(
		ImportBatchId,
		SourceName,
		BudgetReforecastTypeKey,
		SnapshotId,
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
		--SourceSystemId,
		IsExpense,
		PS.ReforecastKey,
		IsDirectCost,
		GlGlobalAccountId,
		DefaultGLCategorizationId,
		
		SourceSystemKey
	)

	SELECT
		PS.ImportBatchId,
		PS.SourceName,
		PS.BudgetReforecastTypeKey,
		PS.SnapshotId,
		DATEDIFF(DD, '1900-01-01', LEFT(PS.ExpensePeriod, 4)+'-' + RIGHT(PS.ExpensePeriod, 2) + '-01'), -- CalendarKey,
		ISNULL(S.SourceKey, @SourceKeyUnknown),-- SourceKey,
		COALESCE(FDJobCode.FunctionalDepartmentKey, FD.FunctionalDepartmentKey, @FunctionalDepartmentKeyUnknown), -- FunctionalDepartmentKey,                        
		ISNULL(R.ReimbursableKey, @ReimbursableKeyUnknown),                    -- ReimbursableKey,
		ISNULL(AT.ActivityTypeKey, @ActivityTypeKeyUnknown),                   -- ActivityTypeKey,
		ISNULL(PF.PropertyFundKey, @PropertyFundKeyUnknown),                   -- PropertyFundKey,
		ISNULL(AR.AllocationRegionKey, @AllocationRegionKeyUnknown),       -- AllocationRegionKey,
		ISNULL(CR.AllocationRegionKey, @AllocationRegionKeyUnknown),       -- ConsolidationRegionKey,
		CASE
			WHEN PS.IsExpense = 1
			THEN
				ISNULL(ORR.OriginatingRegionKey, @OriginatingRegionKeyUnknown)
			ELSE
				ISNULL(ORRFee.OriginatingRegionKey, @OriginatingRegionKeyUnknown)
		END,                                                                                            -- OriginatingRegionKey,
		ISNULL(O.OverheadKey, @OverheadKeyUnknown),                                -- OverheadKey,
		ISNULL(FA.FeeAdjustmentKey, @FeeAdjustmentKeyUnknown),                -- FeeAdjustmentKey,
		ISNULL(C.CurrencyKey, @LocalCurrencyKeyUnknown),                            -- LocalCurrencyKey,
		PS.BudgetAmount,                                                                                -- LocalBudget,
		PS.ReferenceCode,                                                                               -- ReferenceCode,
		PS.BudgetId,                                                                                    -- BudgetId,
		--@SourceSystemId,                                                                              -- SourceSystemId
		PS.IsExpense,
		PS.ReforecastKey,
		PS.IsDirectCost,
		PS.GLGlobalAccountId,
		PS.DefaultGLCategorizationId,
		
		SSystem.SourceSystemKey
	FROM
		#ProfitabilitySource PS

		LEFT OUTER JOIN GrReporting.dbo.[Source] S ON
			PS.SourceCode = S.SourceCode 

		LEFT OUTER JOIN GrReporting.dbo.SourceSystem SSystem ON
			PS.SourceTableName = SSystem.SourceTableName AND
			SSystem.SourceSystemName = 'GBS'
			
		LEFT OUTER JOIN GrReporting.dbo.Reimbursable R ON
			PS.Reimbursable = R.ReimbursableCode 

		LEFT OUTER JOIN GrReporting.dbo.ActivityType AT ON
			PS.ActivityTypeId = AT.ActivityTypeId AND
			PS.SnapshotId = AT.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.PropertyFund PF ON
			PS.PropertyFundId = PF.PropertyFundId AND
			PS.SnapshotId = PF.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.AllocationRegion AR ON
			PS.AllocationSubRegionGlobalRegionId = AR.GlobalRegionId AND 
			PS.SnapshotId = AR.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.AllocationRegion CR ON
			PS.ConsolidationSubRegionGlobalRegionId = CR.GlobalRegionId AND
			PS.SnapshotId = CR.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion ORRFee ON -- For fee income, allocation region = originating region
			PS.AllocationSubRegionGlobalRegionId = ORRFee.GlobalRegionId AND
			PS.SnapshotId = ORRFee.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion ORR ON
			PS.OriginatingGlobalRegionId = ORR.GlobalRegionId AND
			PS.SnapshotId = ORR.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.Currency C ON
			PS.LocalCurrencyCode = C.CurrencyCode

		LEFT OUTER JOIN GrReporting.dbo.Overhead O ON
			PS.UnallocatedOverhead = O.OverheadCode 


		LEFT OUTER JOIN GrReporting.dbo.FeeAdjustment FA ON
			PS.FeeAdjustment = FA.FeeAdjustmentCode 

		LEFT OUTER JOIN Gdm.[Snapshot] SShot ON
			PS.SnapshotId = SShot.SnapshotId
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
			PS.JobCode = FDJobCode.SubFunctionalDepartmentCode AND
			PS.FunctionalDepartmentCode = FDJobCode.FunctionalDepartmentCode AND
			SShot.LastSyncDate BETWEEN FDJobCode.StartDate AND FDJobCode.EndDate -- Use the Snapshot Last Sync Date since Functional Department is not snapshoted		

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

		) FD ON
			PS.FunctionalDepartmentCode = FD.FunctionalDepartmentCode AND
			SShot.LastSyncDate BETWEEN FD.StartDate AND FD.EndDate -- Use the Snapshot Last Sync Date since Functional Department is not snapshoted
	WHERE
		PS.BudgetAmount <> 0



	PRINT ('Rows inserted into #ProfitabilityReforecast: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	CREATE NONCLUSTERED INDEX IX_ProfitabilityReforecast ON
		#ProfitabilityReforecast
		(
			GLGlobalAccountId,
			SnapshotId
		)
END

/* ==============================================================================================================================================
	11.	Update #ProfitibilityReforecast.GlobalGlCategorizationHierarchyKey
   =========================================================================================================================================== */
BEGIN

	SET @StartTime = GETDATE()

	-- Global Categorization Mapping

	UPDATE #ProfitabilityReforecast
	SET
		GlobalGLCategorizationHierarchyKey = 
			COALESCE(GLACM.GlobalGLCategorizationHierarchyKey, @UnknownGlobalGLCategorizationKey)
	FROM
		#ProfitabilityReforecast Gl
		
		LEFT OUTER JOIN #GLAccountCategoryMapping GLACM ON
			GLACM.GLGlobalAccountId = Gl.GLGlobalAccountId AND
			GLACM.SnapshotId = Gl.SnapshotId AND
			GLACM.IsDirect = CASE
								WHEN Gl.IsExpense = 0
								THEN
									0
								ELSE
									Gl.IsDirectCost
							END

	RAISERROR( 'Updating #ProfitabilityReforecast GlobalGlCategorizationHierarchyKey',0,1) WITH NOWAIT

	-- Local Categorization Mapping

	UPDATE
		#ProfitabilityReforecast
	SET
		USPropertyGLCategorizationHierarchyKey = 
			COALESCE(GLACM.USPropertyGLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey),
			
		USFundGLCategorizationHierarchyKey = 
			COALESCE(GLACM.USFundGLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey),
						
		EUPropertyGLCategorizationHierarchyKey = 
			COALESCE(GLACM.EUPropertyGLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey),
			
		EUFundGLCategorizationHierarchyKey = 
			COALESCE(GLACM.EUFundGLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey),
			
		USDevelopmentGLCategorizationHierarchyKey = 
			COALESCE(GLACM.USDevelopmentGLCategorizationHierarchyKey, @UnknownUSDevelopmentGLCategorizationKey),
					
		EUDevelopmentGLCategorizationHierarchyKey = 
			COALESCE(GLACM.EUDevelopmentGLCategorizationHierarchyKey, @GLCategorizationHierarchyKeyUnknown),

		ReportingGLCategorizationHierarchyKey =
			CASE 
				WHEN GC.GLCategorizationId IS NOT NULL
				THEN
					CASE
						WHEN GC.Name = 'US Property' THEN ISNULL(GLACM.USPropertyGLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey)
						WHEN GC.Name = 'US Fund' THEN ISNULL(GLACM.USFundGLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey)
						WHEN GC.Name = 'EU Property' THEN ISNULL(GLACM.EUPropertyGLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey)
						WHEN GC.Name = 'EU Fund' THEN ISNULL(GLACM.EUFundGLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey)
						WHEN GC.Name = 'US Development' THEN ISNULL(GLACM.USDevelopmentGLCategorizationHierarchyKey, @UnknownUSDevelopmentGLCategorizationKey)
						WHEN GC.Name = 'EU Development' THEN ISNULL(GLACM.EUDevelopmentGLCategorizationHierarchyKey, @GLCategorizationHierarchyKeyUnknown)
						WHEN GC.Name = 'Global' THEN Gl.GlobalGLCategorizationHierarchyKey
						ELSE
							ISNULL(UnknownGCH.GLCategorizationHierarchyKey, @GLCategorizationHierarchyKeyUnknown)
					END
				ELSE
					ISNULL(UnknownGCH.GLCategorizationHierarchyKey, @GLCategorizationHierarchyKeyUnknown)
			END
	FROM
		#ProfitabilityReforecast Gl
		
		LEFT OUTER JOIN #GLAccountCategoryMapping GLACM ON
			GLACM.GLGlobalAccountId = Gl.GLGlobalAccountId AND
			GLACM.SnapshotId = Gl.SnapshotId AND
			GLACM.IsDirect = CASE
								WHEN Gl.IsExpense = 0
								THEN 1
								ELSE Gl.IsDirectCost
							END
		
		LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy UnknownGCH ON
			UnknownGCH.GLCategorizationHierarchyCode = '-1:-1:-1:-1:-1:' + CONVERT(VARCHAR(10), Gl.GLGlobalAccountId) AND
			UnknownGCH.SnapshotId = Gl.SnapshotId

		LEFT OUTER JOIN #GLCategorization GC ON
			GC.GLCategorizationId = Gl.DefaultGLCategorizationId AND
			GC.SnapshotId = Gl.SnapshotId
				
	PRINT ('Rows updated from #ProfitabilityReforecast: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	PRINT ('Creating Unique INDEX  IX_ProfitibilityRecforecast1 on #ProfitabilityReforecast on ReferenceCode')
	
	SET @StartTime = GETDATE()
	
	CREATE UNIQUE CLUSTERED INDEX IX_ProfitibilityRecforecast ON
		#ProfitabilityReforecast
		(
			ReferenceCode
		)

	PRINT ('Created Unique INDEX  IX_ProfitibilityRecforecast1 on #ProfitabilityReforecast ')
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END

/* ==============================================================================================================================================
	12.	Delete budgets to insert that have UNKNOWNS in their mapping
   =========================================================================================================================================== */
BEGIN

	SET @StartTime = GETDATE()

-- Delete all existing GBS records from dbo.ProfitabilityBudgetUnknowns

	DELETE
	FROM
		dbo.ProfitabilityReforecastUnknowns
	WHERE
		BudgetReforecastTypeKey IN (@ReforecastTypeIsGBSBUDKey, @ReforecastTypeIsGBSActKey) -- Only delete GBS records, leave TAPAS records

	PRINT ('Rows deleted from ProfitabilityReforecastUnknowns: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	INSERT INTO dbo.ProfitabilityReforecastUnknowns (
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
		BudgetId,
		OverheadKey,
		FeeAdjustmentKey,
		BudgetReforecastTypeKey,
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
		BudgetId,
		OverheadKey,
		FeeAdjustmentKey,
		BudgetReforecastTypeKey,
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
	FROM
		#ProfitabilityReforecast
	WHERE
		SourceKey = @SourceKeyUnknown OR
		(FunctionalDepartmentKey = @FunctionalDepartmentKeyUnknown AND IsExpense = 1) OR	
		ReimbursableKey = @ReimbursableKeyUnknown OR
		ActivityTypeKey = @ActivityTypeKeyUnknown OR
		PropertyFundKey = @PropertyFundKeyUnknown OR
		AllocationRegionKey = @AllocationRegionKeyUnknown OR
		OriginatingRegionKey = @OriginatingRegionKeyUnknown OR
		FeeAdjustmentKey = @FeeAdjustmentKeyUnknown OR
		LocalCurrencyKey = @LocalCurrencyKeyUnknown OR
		GlobalGLCategorizationHierarchyKey = @GLCategorizationHierarchyKeyUnknown

		/*
			OverheadKey: always UNKNOWN for Fees, UNKNOWN from non-payroll if Activity Type code <> CORPOH
			CalendarKey: not required to check if UNKNOWN or NULL because CalendarKey is hard-coded	
			ReferenceCode: not required to check if UNKNOWN or NULL because CalendarKey is hard-coded
			BudgetId: This field is sourced directly from GBS.Budget and cannot be NULL (has a 'not null' dbase constraint in source system)
		*/

	DECLARE @RowsInserted INT = @@rowcount
	PRINT ('Rows inserted into ProfitabilitReforecastUnknowns: ' + CONVERT(VARCHAR(10),@RowsInserted))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END

/* ==============================================================================================================================================
	13.	Insert, Update and Delete records from Fact table
============================================================================================================================================== */
BEGIN


	CREATE TABLE #ReforecastsToImport
	(
		BudgetId INT NOT NULL
	)
	INSERT INTO #ReforecastsToImport
	SELECT DISTINCT
		BudgetId
	FROM
		#ProfitabilityReforecast

	SET @StartTime = GETDATE()

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
WHEN MATCHED AND
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
		FACT.FeeAdjustmentKey <> SRC.FeeAdjustmentKey OR
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
		ISNULL(FACT.ReportingGLCategorizationHierarchyKey, '') <> SRC.ReportingGLCategorizationHierarchyKey
	) THEN
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
		FACT.FeeAdjustmentKey = SRC.FeeAdjustmentKey,
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
WHEN NOT MATCHED BY TARGET THEN
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
		SRC.FeeAdjustmentKey,
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
WHEN NOT MATCHED BY SOURCE AND
	FACT.BudgetId IN (SELECT BudgetId FROM #ReforecastsToImport) AND
	FACT.BudgetReforecastTypeKey IN (@ReforecastTypeIsGBSBUDKey, @ReforecastTypeIsGBSACTKey) 
THEN
	DELETE
OUTPUT
		$action AS Change
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

/* ==============================================================================================================================================
	14.	Mark budgets as being successfully processed into the warehouse
============================================================================================================================================== */
BEGIN

	UPDATE
		dbo.BudgetsToProcess
	SET
		ReforecastBudgetsProcessedIntoWarehouse = 1,
		ReforecastActualsProcessedIntoWarehouse = 1,
		DateBudgetProcessedIntoWarehouse = GETDATE()
	WHERE
		IsCurrentBatch = 1 AND
		IsReforecast = 1 AND
		BudgetReforecastTypeName = 'GBS Budget/Reforecast'

	PRINT ('Rows updated from dbo.BudgetsToProcess: ' + CONVERT(VARCHAR(10),@@rowcount))

END


/* ==============================================================================================================================================
	15.	Clean up
   =========================================================================================================================================== */
BEGIN

	IF 	OBJECT_ID('tempdb..#Budget') IS NOT NULL
		DROP TABLE #Budget

	IF 	OBJECT_ID('tempdb..#GLGlobalAccount') IS NOT NULL
		DROP TABLE #GLGlobalAccount

	IF 	OBJECT_ID('tempdb..#GLTranslationSubType') IS NOT NULL
		DROP TABLE #GLTranslationSubType

	IF 	OBJECT_ID('tempdb..#GLGlobalAccountTranslationSubType') IS NOT NULL
		DROP TABLE #GLGlobalAccountTranslationSubType
	    
	IF 	OBJECT_ID('tempdb..#GLMinorCategory') IS NOT NULL
		DROP TABLE #GLMinorCategory
	    
	IF 	OBJECT_ID('tempdb..#GLMajorCategory') IS NOT NULL
		DROP TABLE #GLMajorCategory

	IF 	OBJECT_ID('tempdb..#GLGlobalAccountTranslationType') IS NOT NULL
		DROP TABLE #GLGlobalAccountTranslationType

	IF 	OBJECT_ID('tempdb..#ReportingEntityCorporateDepartment') IS NOT NULL
		DROP TABLE #ReportingEntityCorporateDepartment

	IF 	OBJECT_ID('tempdb..#PropertyFund') IS NOT NULL
		DROP TABLE #PropertyFund

	IF 	OBJECT_ID('tempdb..#ActivityType') IS NOT NULL
		DROP TABLE #ActivityType

	IF 	OBJECT_ID('tempdb..#CorporateDepartment') IS NOT NULL
		DROP TABLE #CorporateDepartment

	IF 	OBJECT_ID('tempdb..#FunctionalDepartment') IS NOT NULL
		DROP TABLE #FunctionalDepartment

	IF 	OBJECT_ID('tempdb..#AllocationSubRegion') IS NOT NULL
		DROP TABLE #AllocationSubRegion

	IF 	OBJECT_ID('tempdb..#GLAccountCategoryMapping') IS NOT NULL
		DROP TABLE #GLAccountCategoryMapping

	IF 	OBJECT_ID('tempdb..#ProfitabilitySource') IS NOT NULL
		DROP TABLE #ProfitabilitySource

	IF 	OBJECT_ID('tempdb..#ProfitabilityBudget') IS NOT NULL
		DROP TABLE #ProfitabilityBudget

	IF 	OBJECT_ID('tempdb..#BudgetsToImport') IS NOT NULL
		DROP TABLE #BudgetsToImport

	IF 	OBJECT_ID('tempdb..#BudgetsToImportOriginal') IS NOT NULL
		DROP TABLE #BudgetsToImportOriginal

	IF 	OBJECT_ID('tempdb..#BudgetsToDelete') IS NOT NULL
		DROP TABLE #BudgetsToDelete

	IF 	OBJECT_ID('tempdb..#CorporatePropertySourceCodes') IS NOT NULL
		DROP TABLE #CorporatePropertySourceCodes

	IF 	OBJECT_ID('tempdb..#BudgetsWithUnknowns') IS NOT NULL
		DROP TABLE #BudgetsWithUnknowns

	IF 	OBJECT_ID('tempdb..#FunctionalDepartment') IS NOT NULL
		DROP TABLE #FunctionalDepartment

	IF 	OBJECT_ID('tempdb..#Actuals') IS NOT NULL
		DROP TABLE #Actuals

	IF 	OBJECT_ID('tempdb..#BudgetsWithUnknownBudgets') IS NOT NULL
		DROP TABLE #BudgetsWithUnknownBudgets

	IF 	OBJECT_ID('tempdb..#BudgetsWithUnknownActuals') IS NOT NULL
		DROP TABLE #BudgetsWithUnknownActuals

	IF 	OBJECT_ID('tempdb..#AllUnknownBudgets') IS NOT NULL
		DROP TABLE #AllUnknownBudgets

	IF 	OBJECT_ID('tempdb..#BudgetsToProcess') IS NOT NULL
		DROP TABLE #BudgetsToProcess

	IF 	OBJECT_ID('tempdb..#BudgetsToProcessToUpdate') IS NOT NULL
		DROP TABLE #BudgetsToProcessToUpdate
	    
	IF 	OBJECT_ID('tempdb..#ConsolidationRegionCorporateDepartment') IS NOT NULL
		DROP TABLE #ConsolidationRegionCorporateDepartment

END


GO


