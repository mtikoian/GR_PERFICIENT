USE [GrReportingStaging]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyGBSBudget]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyGBSBudget]
GO



/*********************************************************************************************************************
	Description
	
	This stored procedure processes non-payroll and fee original budget information and uploads it to the
	ProfitabilityBudget table in the data warehouse (GrReporting.dbo.ProfitabilityBudget)
	
		1. Get Budgets to Process
		2. Declare local variables and create common tables
		3. Source budget data from GrReportingStaging.GBS.Budget
		4. Source Snapshot mapping data from GDM
		5. Create master GL Account Category mapping table
		6. Create the temporary source table into which Non-Payroll Expense and Fee budgets are to be inserted
		7. Insert Non-Payroll Expense budget items into the temporary source table
		8. Insert Fee budget items into the temporary source table
		9. Create a temporary 'staging' table that matches the schema of the GrReporting.dbo.ProfitabilityBudget fact
		10. Update the GL Categorization Hierarchy fields in the 'staging' temporary table
		11. Delete budgets to insert that have UNKNOWNS in their mapping
		12. Delete existing budgets from GrReporting.dbo.ProfitabilityBudget that we are about to reinsert
		13. Insert budget records into GrReporting.dbo.ProfitabilityBudget from the 'staging' temporary table
		14. Mark budgets as being successfully processed into the warehouse
		15. Clean up: drop temporary tables

	History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

				2011-06-23		: PKayongo	:	Added ConsolidationRegion mapping as per CC16. Added the field to the 
											data inserted into the warehouse. 	
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyGBSBudget]
	@DataPriorToDate	DateTime=NULL
AS

PRINT '####'
PRINT 'stp_IU_LoadGrProfitabiltyGBSBudget'
PRINT '####'

IF ((SELECT TOP 1 CONVERT(INT, ConfiguredValue) FROM GrReportingStaging.dbo.SSISConfigurations WHERE ConfigurationFilter = 'CanImportGBSBudget') <> 1)
BEGIN
	PRINT ('Import of GBS Budget is not scheduled in GrReportingStaging.dbo.SSISConfigurations. Aborting ...')
	RETURN
END

DECLARE @RowCount INT
DECLARE @StartTime DATETIME = GETDATE()

/* ==============================================================================================================================================
	1. Get Budgets to Process [perhaps move this to BudgetsToProcess stored procedure?]
   =========================================================================================================================================== */
BEGIN

	SELECT 
		BTPC.BudgetsToProcessId,
		BTPC.BudgetId,
		BTPC.ImportBatchId,
		BTPC.SnapshotId, 
		Reforecast.ReforecastKey
	INTO 
		#BudgetsToProcess 
	FROM 
		dbo.BudgetsToProcess BTPC

		INNER JOIN
		(
			SELECT
				MIN(ReforecastKey) AS ReforecastKey, -- ReforecastKey and ReforecastEffectivePeriod have the same ordering. ReforecastKey is computed
				ReforecastEffectiveYear				 -- the same as CalendarKey, and is therefore date-based
			FROM
				GrReporting.dbo.Reforecast
			WHERE
				ReforecastQuarterName = 'Q0' -- This is the original budget stored procedure; we can therefore hard-code 'Q0'
			GROUP BY
				ReforecastEffectiveYear

		) Reforecast ON
			BTPC.BudgetYear = Reforecast.ReforecastEffectiveYear
	WHERE 
		BTPC.IsCurrentBatch = 1 AND
		BTPC.BudgetReforecastTypeName = 'GBS Budget/Reforecast' AND
		BTPC.IsReforecast = 0 -- This stored procedure handles original GBS budgets only (and not reforecasts)

	------------------------

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
	2. Declare local variables and create common tables
   =========================================================================================================================================== */
BEGIN

DECLARE
	@UnknownSourceKey					 INT = (SELECT TOP 1 SourceKey FROM GrReporting.dbo.[Source] WHERE SourceName = 'UNKNOWN'),
	@UnknownFunctionalDepartmentKey		 INT = (SELECT TOP 1 FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = 'UNKNOWN'),
	@UnknownActivityTypeKey				 INT = (SELECT TOP 1 ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = 'UNKNOWN'),
	@UnknownPropertyFundKey				 INT = (SELECT TOP 1 PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = 'UNKNOWN'),
	@UnknownAllocationRegionKey			 INT = (SELECT TOP 1 AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = 'UNKNOWN'),
	@UnknownOriginatingRegionKey		 INT = (SELECT TOP 1 OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = 'UNKNOWN'),
	@UnknownOverheadKey					 INT = (SELECT TOP 1 OverheadKey FROM GrReporting.dbo.Overhead WHERE OverheadCode = 'UNKNOWN'),
	@UnknownLocalCurrencyKey			 INT = (SELECT TOP 1 CurrencyKey FROM GrReporting.dbo.Currency WHERE CurrencyCode = 'UNKNOWN'),
	@UnknownGLCategorizationHierarchyKey INT = (SELECT TOP 1 GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'UNKNOWN' AND SnapshotId = 0),
	@GBSBudgetReforecastTypeKey			 INT = (SELECT TOP 1 BudgetReforecastTypeKey FROM GrReporting.dbo.BudgetReforecastType WHERE BudgetReforecastTypeCode = 'GBSBUD'),

	@FEEADJUSTFeeAdjustmentKey			 INT = (SELECT TOP 1 FeeAdjustmentKey FROM GrReporting.dbo.FeeAdjustment WHERE FeeAdjustmentCode = 'FEEADJUST'),
	@NORMALFeeAdjustmentKey				 INT = (SELECT TOP 1 FeeAdjustmentKey FROM GrReporting.dbo.FeeAdjustment WHERE FeeAdjustmentCode = 'NORMAL'),

	@ALLOCOverheadKey					 INT = (SELECT TOP 1 OverheadKey FROM GrReporting.dbo.Overhead WHERE OverheadCode = 'ALLOC'),
	@UNALLOCOverheadKey					 INT = (SELECT TOP 1 OverheadKey FROM GrReporting.dbo.Overhead WHERE OverheadCode = 'UNALLOC'),
	@NAOverheadKey						 INT = (SELECT TOP 1 OverheadKey FROM GrReporting.dbo.Overhead WHERE OverheadCode = 'N/A'),

	@NOReimbursableKey					 INT = (SELECT TOP 1 ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = 'NO'),
	@YESReimbursableKey					 INT = (SELECT TOP 1 ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = 'YES')

DECLARE
	@UnknownUSPropertyGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'US Property' AND SnapshotId = 0),
	@UnknownUSFundGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'US Fund' AND SnapshotId = 0),
	@UnknownEUPropertyGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'EU Property' AND SnapshotId = 0),
	@UnknownEUFundGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'EU Fund' AND SnapshotId = 0),
	@UnknownUSDevelopmentGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'US Development' AND SnapshotId = 0),
	@UnknownGlobalGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'Global' AND SnapshotId = 0)


	-- There could be up to three copies of the same GBS data due to three seperate imports, so work with latest GBS import which should have the
	-- highest ImportBatchId.

	IF (@DataPriorToDate IS NULL)
		BEGIN
		SET @DataPriorToDate = CONVERT(DateTime,(SELECT ConfiguredValue FROM SSISConfigurations WHERE ConfigurationFilter = 'ActualDataPriorToDate'))
		END
	
	CREATE TABLE #BudgetsWithUnknownBudgets(
		ImportKey INT NOT NULL,
		ImportBatchId INT NOT NULL,
		BudgetId INT NOT NULL
	)

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

END

/* ==============================================================================================================================================
	3. Source budget data from GrReportingStaging.GBS.Budget [not sure whether this is still necessary] [!!]
   =========================================================================================================================================== */
BEGIN

	SET @StartTime = GETDATE()

	CREATE TABLE #Budget(
		ReforecastKey INT NOT NULL,
		ImportKey INT NOT NULL,
		ImportBatchId INT NOT NULL,
		BudgetId INT NOT NULL,
		Name VARCHAR(50) NOT NULL,
		LastLockedDate DATETIME NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #Budget
	SELECT
		BTP.ReforecastKey,
		Budget.ImportKey,
		Budget.ImportBatchId,
		Budget.BudgetId,
		Budget.Name,
		Budget.LastLockedDate,
		BTP.SnapshotId
	FROM
		GBS.Budget Budget
		
		INNER JOIN #BudgetsToProcess BTP ON -- All GBS budgets in dbo.BudgetsToProcess must be considered because they are to be processed into the warehouse
			Budget.BudgetId = BTP.BudgetId AND
			Budget.ImportBatchId = BTP.ImportBatchId	
	WHERE
		Budget.IsActive = 1
	
	DECLARE @BudgetRowCount INT = @@rowcount
	
	IF (@BudgetRowCount = 0)
	BEGIN
		PRINT ('stp_IU_LoadGrProfitabiltyGBSBudget is quitting because there are no GBS budgets set to be imported.')
		RETURN
	END

	CREATE UNIQUE CLUSTERED INDEX IX_Budget ON #Budget (SnapshotId, BudgetId)

	PRINT ('Rows inserted into #Budget: ' + CONVERT(VARCHAR(10),@BudgetRowCount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END

/* ==============================================================================================================================================
	4. Source Snapshot mapping data from GDM
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

	CREATE UNIQUE CLUSTERED INDEX UX_GLGlobalAccount_GLGlobalAccountId ON #GLGlobalAccount(GLGlobalAccountId, SnapshotId)
-- SnapshotGLGlobalAccountCategorization -------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #GLGlobalAccountCategorization(
		GLGlobalAccountId INT NOT NULL,
		GLCategorizationId INT NOT NULL,
		DirectGLMinorCategoryId INT NULL,
		IndirectGLMinorCategoryId INT NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #GLGlobalAccountCategorization(
		GLGlobalAccountId,
		GLCategorizationId,
		DirectGLMinorCategoryId,
		IndirectGLMinorCategoryId,
		SnapshotId
	)
	SELECT DISTINCT
		GGAC.GLGlobalAccountId,
		GGAC.GLCategorizationId,
		GGAC.DirectGLMinorCategoryId,
		GGAC.IndirectGLMinorCategoryId,
		GGAC.SnapshotId
	FROM
		Gdm.SnapshotGLGlobalAccountCategorization GGAC
		INNER JOIN #Budget B ON
			GGAC.SnapshotId = B.SnapshotId

	PRINT ('Rows inserted into #GLGlobalAccountCategorization ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- GLMinorCategory -----------------------------------------------------------

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

-- GLMajorCategory ---------------------------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #GLMajorCategory (
		SnapshotId INT NOT NULL,
		GLMajorCategoryId INT NOT NULL,
		GLFinancialCategoryId INT NOT NULL,
		GLCategorizationId INT NOT NULL
	)
	INSERT INTO #GLMajorCategory
	SELECT DISTINCT
		MajC.SnapshotId,
		MajC.GLMajorCategoryId,
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

-- GLFinancialCategory ---------------------------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #GLFinancialCategory(
		SnapshotId INT NOT NULL,
		GLFinancialCategoryId INT NOT NULL,
		GLCategorizationId INT NOT NULL
	)
	INSERT INTO #GLFinancialCategory(
		SnapshotId,
		GLFinancialCategoryId,
		GLCategorizationId
	)
	SELECT DISTINCT
		FinC.SnapshotId,
		FinC.GLFinancialCategoryId,
		FinC.GLCategorizationId
	FROM
		Gdm.SnapshotGLFinancialCategory FinC
		INNER JOIN #Budget B ON
			FinC.SnapshotId = B.SnapshotId

	PRINT ('Rows inserted into #GLFinancialCategory ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- GLCategorization ---------------------------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #GLCategorization(
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

	CREATE TABLE #ReportingCategorization(
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
	
	CREATE UNIQUE CLUSTERED INDEX UX_ReportingCategorization_Clustered ON #ReportingCategorization(AllocationSubRegionGlobalRegionId, EntityTypeId, SnapshotId)

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
	
	CREATE UNIQUE CLUSTERED INDEX UX_ConsolidationRegionCorporateDepartment_CorporateDepartmentCode ON #ConsolidationRegionCorporateDepartment(CorporateDepartmentCode, SourceCode, SnapshotId)

-- PropertyFund --------------------------------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #PropertyFund(
		PropertyFundId INT NOT NULL,
		EntityTypeId INT NOT NULL,
		AllocationSubRegionGlobalRegionId INT NOT NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #PropertyFund
	SELECT DISTINCT
		PF.PropertyFundId,
		PF.EntityTypeId,
		PF.AllocationSubRegionGlobalRegionId,
		PF.SnapshotId
	FROM
		Gdm.SnapshotPropertyFund PF
		INNER JOIN #Budget B ON
			PF.SnapshotId = B.SnapshotId  
	WHERE
		PF.IsActive = 1

	PRINT ('Rows inserted into #PropertyFund: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
	
	CREATE UNIQUE CLUSTERED INDEX UX_PropertyFund_PropertyFundId ON #PropertyFund(PropertyFundId, SnapshotId)

-- Global Region ---------------------------------------------------------------------------------

	SET @StartTime = GETDATE()
	
	CREATE TABLE #GlobalRegion
	(
		SnapshotId INT NOT NULL,
		GlobalRegionId INT NOT NULL,
		IsAllocationRegion BIT NOT NULL,
		IsOriginatingRegion BIT NOT NULL,
		IsConsolidationRegion BIT NOT NULL,
		DefaultCorporateSourceCode CHAR(2) NOT NULL
	)
	INSERT INTO #GlobalRegion
	(
		SnapshotId,
		GlobalRegionId,
		IsAllocationRegion,
		IsOriginatingRegion,
		IsConsolidationRegion,
		DefaultCorporateSourceCode
	)
	SELECT DISTINCT
		GR.SnapshotId,
		GR.GlobalRegionId,
		GR.IsAllocationRegion,
		GR.IsOriginatingRegion,
		GR.IsConsolidationRegion,
		GR.DefaultCorporateSourceCode
	FROM
		Gdm.SnapshotGlobalRegion GR
		INNER JOIN #Budget B ON
			GR.SnapshotId = B.SnapshotId
	WHERE
		IsActive = 1
		
	PRINT ('Rows inserted into #GlobalRegion: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
	
	CREATE UNIQUE CLUSTERED INDEX UX_GlobalRegion_GlobalRegionId ON #GlobalRegion(GlobalRegionId, SnapshotId)	
	
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

-- Department -----------------------------------------------------------------------------------------

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
	
	CREATE UNIQUE CLUSTERED INDEX UX_CorporateDepartment_Code ON #CorporateDepartment(Code, SourceCode, SnapshotId)

-- FunctionalDepartment -------------------------------------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #FunctionalDepartment (
		FunctionalDepartmentId INT NOT NULL,
		Code VARCHAR(20) NULL,
		GlobalCode VARCHAR(30) NULL
	)

	INSERT INTO #FunctionalDepartment
	SELECT
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
-- AllocationSubRegion -----------------------------------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #AllocationSubRegion (
		SnapshotId int NOT NULL,
		AllocationSubRegionGlobalRegionId int NOT NULL,
		Code varchar(10) NOT NULL,
		Name varchar(50) NOT NULL,
		AllocationRegionGlobalRegionId int NULL,
		DefaultCorporateSourceCode char(2) NOT NULL
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

END

/* ==============================================================================================================================================
	5. Create master GL Account Category mapping table
   ============================================================================================================================================ */
BEGIN

	SET @StartTime = GETDATE()

	/*
		The following table gets the Global Account Categorization mapping data from GDM, and pivots the data so that the first row has the 
			Global Account Id and each column represents the a GL Categorization Hierarchy code for one of the GL Categorizations.

		The purpose of having the table like this is to avoid joining onto the fact table multiple times.
	*/

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
			SELECT DISTINCT
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
			SELECT DISTINCT
				GGA.SnapshotId,
				GGA.GLGlobalAccountId,
				GLC.Name AS GLCategorizationName,
				ISNULL(GCH.GLCategorizationHierarchyKey, UnknownGCH.GLCategorizationHierarchyKey) AS GLCategorizationHierarchyKey,
				1 AS IsDirectCost
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
	6. Create the temporary source table into which Non-Payroll Expense and Fee budgets are to be inserted
   =========================================================================================================================================== */
BEGIN

	CREATE TABLE #ProfitabilitySource (
		ImportBatchId INT NOT NULL,
		ReforecastKey INT NOT NULL,
		SnapshotId INT NOT NULL,
		BudgetId INT NOT NULL,
		ReferenceCode VARCHAR(300) NOT NULL,
		ExpensePeriod CHAR(6) NOT NULL,	
		SourceCode VARCHAR(2) NULL,
		BudgetAmount MONEY NOT NULL,
		GLGlobalAccountId INT NULL,
		FunctionalDepartmentCode VARCHAR(20) NULL,
		JobCode VARCHAR(20) NULL,
		ReimbursableKey INT NOT NULL,
		ActivityTypeId INT NULL,                       -- NULL because for Fees this field is determined via an outer join
		PropertyFundId INT NULL,                       -- NULL because this field is determined via an outer join
		AllocationSubRegionGlobalRegionId INT NULL,    -- NULL because this field is determined via an outer join
		ConsolidationSubRegionGlobalRegionId INT NULL, -- NULL because this field is determined via an outer join
		OriginatingGlobalRegionId INT NULL,
		LocalCurrencyCode CHAR(3) NOT NULL,
		LockedDate DATETIME NULL,
		IsExpense BIT NOT NULL,
		OverheadKey INT NOT NULL,
		FeeAdjustmentKey INT NOT NULL,
		IsDirectCost BIT NULL,
		DefaultGLCategorizationId INT NULL,
		SourceTableName VARCHAR(255) NOT NULL
	)

END

/* ==============================================================================================================================================
	7. Insert Non-Payroll Expense budget items into the temporary source table
   =========================================================================================================================================== */
BEGIN

	-- These are disputed items which are to be exluded
	
	CREATE TABLE #NonPayrollExpenseDispute
	(
		ImportBatchId INT NOT NULL,
		NonPayrollExpenseId INT NOT NULL,
		BudgetProjectId INT NOT NULL
	)
	INSERT INTO #NonPayrollExpenseDispute
	(
		ImportBatchId,
		NonPayrollExpenseId,
		BudgetProjectId
	)
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
		
	CREATE UNIQUE CLUSTERED INDEX UX_NonPayrollExpenseDispute_Clustered ON #NonPayrollExpenseDispute(NonPayrollExpenseId, ImportBatchId, BudgetProjectId)
	
				
	SET @StartTime = GETDATE()

	-- Insert original budget amounts
	
	INSERT INTO #ProfitabilitySource (
		ImportBatchId,
		ReforecastKey,
		SnapshotId,
		BudgetId,
		ReferenceCode,
		ExpensePeriod,
		SourceCode,
		BudgetAmount,
		GLGlobalAccountId,
		FunctionalDepartmentCode,
		JobCode,
		ReimbursableKey,
		ActivityTypeId,
		PropertyFundId,
		AllocationSubRegionGlobalRegionId,
		ConsolidationSubRegionGlobalRegionId,
		OriginatingGlobalRegionId,
		LocalCurrencyCode,
		LockedDate,
		IsExpense,
		OverheadKey,
		FeeAdjustmentKey,
		IsDirectCost,
		DefaultGLCategorizationId,
		SourceTableName
	)
	SELECT
		Budget.ImportBatchId,
		Budget.ReforecastKey,
		Budget.SnapshotId,
		Budget.BudgetId,                         -- BudgetId
		'GBS:BudgetId=' + LTRIM(RTRIM(STR(Budget.BudgetId))) + 
			'&NonPayrollExpenseBreakdownId=' + LTRIM(RTRIM(STR(NPEB.NonPayrollExpenseBreakdownId))) + 
			'&SnapshotId=' + LTRIM(RTRIM(STR(Budget.SnapshotId))), -- ReferenceCode
		NPEB.Period,                             -- ExpensePeriod: Period is actually a foreign key to PeriodExtended but is also the implied
												 --		period value, e.g.: 201009
		CASE WHEN NPEB.IsDirectCost = 1 THEN CPSC.PropertySourceCode ELSE NPEB.CorporateSourceCode END AS CorporateSourceCode,	
		NPEB.Amount,                             -- BudgetAmount
		ISNULL(NPEB.ActivitySpecificGLGlobalAccountId, NPEB.GLGlobalAccountId), -- GLGlobalAccountId
		FD.GlobalCode,                           -- FunctionalDepartmentCode
		NPEB.JobCode,                            -- JobCode
		CASE WHEN CD.IsTsCost = 0 THEN @YESReimbursableKey ELSE @NOReimbursableKey END, -- Reimbursable
		NPEB.ActivityTypeId,                     -- ActivityTypeId: this Id should correspond to the correct Id in GDM
		PF.PropertyFundId,						 -- PropertyFundId
		PF.AllocationSubRegionGlobalRegionId,    -- AllocationSubRegionGlobalRegionId
		CRCD.GlobalRegionId,                     -- Consolidation Sub-Region GlobalRegionId (CC16)
		NPEB.OriginatingSubRegionGlobalRegionId, -- OriginatingGlobalRegionId
		NPEB.CurrencyCode,                       -- LocalCurrencyCode
		Budget.LastLockedDate,                   -- LockedDate
		1,                                       -- IsExpense
		CASE WHEN AT.Code = 'CORPOH' THEN @UNALLOCOverheadKey ELSE @NAOverheadKey END, -- UnallocatedOverhead
		@NORMALFeeAdjustmentKey,                 -- FeeAdjustment
		NPEB.IsDirectCost,                       -- IsDirectCost
		RC.GLCategorizationId,                    -- DefaultGLCategorizationId
		'NonPayrollExpenseBreakdown'
	FROM
	
		#Budget Budget
		
		INNER JOIN GBS.NonPayrollExpenseBreakdown NPEB ON
			Budget.BudgetId = NPEB.BudgetId AND
			Budget.ImportBatchId = NPEB.ImportBatchId
		
		INNER JOIN GBS.NonPayrollExpense NPE ON
			NPEB.NonPayrollExpenseId = NPE.NonPayrollExpenseId AND
			NPEB.ImportBatchId = NPE.ImportBatchId
		
		INNER JOIN #CorporatePropertySourceCodes CPSC ON
			NPEB.CorporateSourceCode = CPSC.CorporateSourceCode
	
			/* Disputes are created at the level of a budget project. A budget project will dispute the portion of a non-payroll expense that is
			   allocated to them (via the NonPayrollExpenseBreakdown table, which includes the NonPayrollExpenseId and BudgetProjectId fields,
			   allowing for the portion of the non-payroll expense that has been allocated to the budget project to be determined).
			   
			   If, for example, a non-payroll expense is split between two budget projects, and one of these budget projects is disputing their
			   allocation, the portion of the non-payroll expense that is allocated to the budget project that is not disputing must still be
			   included. Only thet portion of the non-payroll expense that is currently being disputed must be excluded.	   
			*/
		
		LEFT OUTER JOIN #NonPayrollExpenseDispute DisputedNonPayrollExpenseItems ON -- these NonPayrollExpenses need to be excluded because they are in dispute
			NPEB.NonPayrollExpenseId = DisputedNonPayrollExpenseItems.NonPayrollExpenseId AND
			NPEB.BudgetProjectId = DisputedNonPayrollExpenseItems.BudgetProjectId AND
			NPEB.ImportBatchId = DisputedNonPayrollExpenseItems.ImportBatchId

		-- Consolidation Sub Region GlobalRegionId (CC16)
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
			
		LEFT OUTER JOIN #ReportingCategorization RC ON
			PF.AllocationSubRegionGlobalRegionId  = RC.AllocationSubRegionGlobalRegionId AND
			PF.EntityTypeId = RC.EntityTypeId AND
			Budget.SnapshotId = RC.SnapshotId  
	WHERE
		DisputedNonPayrollExpenseItems.NonPayrollExpenseId IS NULL AND -- Exclude all disputed items 
		NPE.IsDeleted = 0

	PRINT ('Rows inserted into #ProfitabilitySource: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END

/* ==============================================================================================================================================
	8. Insert Fee budget items into the temporary source table
   =========================================================================================================================================== */
BEGIN

	SET @StartTime = GETDATE()

	INSERT INTO #ProfitabilitySource (
		ImportBatchId,
		ReforecastKey,
		SnapshotId,
		BudgetId,
		ReferenceCode,
		ExpensePeriod,
		SourceCode,
		BudgetAmount,
		GLGlobalAccountId,
		FunctionalDepartmentCode,
		JobCode,
		ReimbursableKey,
		ActivityTypeId,
		PropertyFundId,
		AllocationSubRegionGlobalRegionId,
		ConsolidationSubRegionGlobalRegionId,
		OriginatingGlobalRegionId,
		LocalCurrencyCode,
		LockedDate,
		IsExpense,
		OverheadKey,
		FeeAdjustmentKey,
		IsDirectCost,
		DefaultGLCategorizationId,
		SourceTableName
	)
	SELECT
		Budget.ImportBatchId,
		Budget.ReforecastKey,
		Budget.SnapshotId,
		Budget.BudgetId,                       -- BudgetId
		'GBS:BudgetId=' + LTRIM(RTRIM(STR(Budget.BudgetId))) +
			'&FeeId=' + LTRIM(RTRIM(STR(Fee.FeeId))) +
			'&FeeDetailId=' + LTRIM(RTRIM(STR(FeeDetail.FeeDetailId))) +
			'&SnapshotId=' + LTRIM(RTRIM(STR(Budget.SnapshotId))), -- ReferenceCode
		FeeDetail.Period,
		AllocationSubRegion.DefaultCorporateSourceCode,        -- SourceCode
		FeeDetail.Amount,
		GA.GLGlobalAccountId,                  -- GLGlobalAccountId
		NULL,                                  -- FunctionalDepartmentId
		NULL,                                  -- JobCode
		@NOReimbursableKey,                    -- Reimbursable
		GA.ActivityTypeId,                     -- ActivityType: determined by finding Fee.GLGlobalAccountId on GrReportingStaging.dbo.GLGlobalAccount
		Fee.PropertyFundId,                    -- PropertyFundId
		AllocationSubRegion.GlobalRegionId, -- AllocationSubRegionGlobalRegionId
		AllocationSubRegion.GlobalRegionId, -- Assumption is that there will be no EU Funds for Fee Data so Allocation and Consolidation region would be the same
		AllocationSubRegion.GlobalRegionId, -- OriginatingGlobalRegionId: allocation region = originating region for fee income
		Fee.CurrencyCode,
		Budget.LastLockedDate,                 -- LockedDate
		0,                                     -- IsExpense
		@NAOverheadKey,                   -- IsUnallocatedOverhead: defaults to UNKNOWN for fees
		CASE WHEN FeeDetail.IsAdjustment = 1 THEN @FEEADJUSTFeeAdjustmentKey ELSE @NORMALFeeAdjustmentKey END, -- IsFeeAdjustment, field isn't NULLABLE
		NULL,                                  -- IsDirectCost
		RC.GLCategorizationId,                  -- DefaultGLCategorizationId
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

		LEFT OUTER JOIN #PropertyFund PF ON
			Fee.PropertyFundId = PF.PropertyFundId AND
			Budget.SnapshotId = PF.SnapshotId  
		
		LEFT OUTER JOIN #GlobalRegion AllocationSubRegion ON
			PF.AllocationSubRegionGlobalRegionId = AllocationSubRegion.GlobalRegionId AND
			Budget.SnapshotId = AllocationSubRegion.SnapshotId
		
		LEFT OUTER JOIN #ReportingCategorization RC ON
			PF.AllocationSubRegionGlobalRegionId = RC.AllocationSubRegionGlobalRegionId AND
			PF.EntityTypeId = RC.EntityTypeId AND
			Budget.SnapshotId = RC.SnapshotId 
	WHERE
		Fee.IsDeleted = 0 AND
		FeeDetail.Amount <> 0

	PRINT ('Rows inserted into #ProfitabilitySource: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	--select distinct COUNT(*) from #ProfitabilitySource
	RAISERROR( 'Completed inserting budget portions into #ProfitabilitySource',0,1) WITH NOWAIT

	------------------------------------------------------------------------------------------------------------------
	RAISERROR( 'Starting to update #ProfitabilitySource GLGlobalAccountId',0,1) WITH NOWAIT

	SET @StartTime = GETDATE()

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

END

/* ==============================================================================================================================================
	9. Create a temporary 'staging' table that matches the schema of the GrReporting.dbo.ProfitabilityBudget fact
   =========================================================================================================================================== */
BEGIN

	CREATE TABLE #ProfitabilityBudget(
		ImportBatchId INT NOT NULL,
		ReforecastKey INT NOT NULL,
		SnapshotId INT NOT NULL,
		CalendarKey int NOT NULL,
		SourceKey int NOT NULL,
		FunctionalDepartmentKey int NOT NULL,
		ReimbursableKey int NOT NULL,
		ActivityTypeKey int NOT NULL,
		PropertyFundKey int NOT NULL,	
		AllocationRegionKey int NOT NULL,
		ConsolidationRegionKey INT NOT NULL,
		OriginatingRegionKey int NOT NULL,
		OverheadKey int NOT NULL,
		FeeAdjustmentKey int NOT NULL,
		LocalCurrencyKey int NOT NULL,
		LocalBudget money NOT NULL,
		ReferenceCode Varchar(300) NOT NULL,
		BudgetId int NOT NULL,
		IsExpense BIT NOT NULL,
		IsDirectCost BIT NULL,
		GlGlobalAccountId INT NOT NULL,
		DefaultGLCategorizationId INT NULL, -- [!!]
		
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

END

/* ====================================================================================================================================
	Join the temporary source table to the dimension tables in GrReporting and attempt to resolve keys, defaulting to UNKNOWN if NULL.
	The result of these joins will be inserted into the 'staging' temporary table
   ==================================================================================================================================== */
BEGIN

	RAISERROR( 'Starting to insert into #ProfitabilityBudget', 0, 1) WITH NOWAIT

	SET @StartTime = GETDATE()

	INSERT INTO #ProfitabilityBudget 
	(
		ImportBatchId,
		ReforecastKey,
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
		LocalBudget,
		ReferenceCode,
		BudgetId,
		IsExpense,
		IsDirectCost,
		GlGlobalAccountId,
		DefaultGLCategorizationId,
		SourceSystemKey
	)
	SELECT
		PS.ImportBatchId,
		PS.ReforecastKey,
		PS.SnapshotId,
		DATEDIFF(DD, '1900-01-01', LEFT(PS.ExpensePeriod, 4)+'-' + RIGHT(PS.ExpensePeriod, 2) + '-01'), -- CalendarKey,
		ISNULL(S.SourceKey, @UnknownSourceKey), -- SourceKey
		COALESCE(FDJobCode.FunctionalDepartmentKey, FD.FunctionalDepartmentKey, @UnknownFunctionalDepartmentKey), -- FunctionalDepartmentKey
		PS.ReimbursableKey,
		ISNULL(AT.ActivityTypeKey, @UnknownActivityTypeKey),-- ActivityTypeKey
		ISNULL(PF.PropertyFundKey, @UnknownPropertyFundKey), -- PropertyFundKey
		ISNULL(AR.AllocationRegionKey, @UnknownAllocationRegionKey), -- AllocationRegionKey
		ISNULL(CR.AllocationRegionKey, @UnknownAllocationRegionKey), -- ConsolidationRegionKey
		CASE
			WHEN PS.IsExpense = 1
			THEN
				ISNULL(ORR.OriginatingRegionKey, @UnknownOriginatingRegionKey)
			ELSE
				ISNULL(ORRFee.OriginatingRegionKey, @UnknownOriginatingRegionKey)
		END, -- OriginatingRegionKey
		PS.OverheadKey,
		PS.FeeAdjustmentKey,
		ISNULL(C.CurrencyKey, @UnknownLocalCurrencyKey), -- LocalCurrencyKey
		PS.BudgetAmount, -- LocalBudget,
		PS.ReferenceCode, -- ReferenceCode,
		PS.BudgetId, -- BudgetId,
		PS.IsExpense,
		ps.IsDirectCost,
		PS.GLGlobalAccountId,
		PS.DefaultGLCategorizationId,
		SourceSystem.SourceSystemKey
	FROM
		#ProfitabilitySource PS

		LEFT OUTER JOIN GrReporting.dbo.SourceSystem SourceSystem ON
			PS.SourceTableName = SourceSystem.SourceTableName AND
			SourceSystem.SourceSystemName = 'GBS'

		LEFT OUTER JOIN GrReporting.dbo.[Source] S ON -- dbo.Source is not snapshotted; this is why there's no join on a SnapshotId field
			PS.SourceCode = S.SourceCode	

		LEFT OUTER JOIN GrReporting.dbo.ActivityType AT ON
			PS.ActivityTypeId = AT.ActivityTypeId AND
			PS.SnapshotId = AT.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.PropertyFund PF ON
			PS.PropertyFundId = PF.PropertyFundId AND
			PS.SnapshotId = PF.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.AllocationRegion AR ON
			PS.AllocationSubRegionGlobalRegionId = AR.GlobalRegionId AND 
			PS.SnapshotId = AR.SnapshotId
			
		LEFT OUTER JOIN GrReporting.dbo.AllocationRegion CR ON -- Consolidation Regions are the same as allocation regions, therefore join to the same table (CC16)
			PS.ConsolidationSubRegionGlobalRegionId = CR.GlobalRegionId AND
			PS.SnapshotId = CR.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion ORRFee ON -- For fee income, allocation region = originating region
			PS.AllocationSubRegionGlobalRegionId = ORRFee.GlobalRegionId AND
			PS.SnapshotId = ORRFee.SnapshotId
		
		LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion ORR ON
			PS.OriginatingGlobalRegionId = ORR.GlobalRegionId AND
			PS.SnapshotId = ORR.SnapshotId
		
		LEFT OUTER JOIN GrReporting.dbo.Currency C ON -- dbo.Currency is not snapshotted; this is why there's no join on a SnapshotId field
			PS.LocalCurrencyCode = C.CurrencyCode
		
		LEFT OUTER JOIN Gdm.[Snapshot] SShot ON
			PS.SnapshotId = SShot.SnapshotId
		
		-- Detail/Sub Level (Job Code) -- job code is stored as SubFunctionalDepartment in GrReporting.dbo.FunctionalDepartment
		LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment FDJobCode ON
			PS.JobCode = FDJobCode.SubFunctionalDepartmentCode AND
			PS.FunctionalDepartmentCode = FDJobCode.FunctionalDepartmentCode AND
			FDJobCode.FunctionalDepartmentCode <> FDJobCode.SubFunctionalDepartmentCode AND
			Sshot.LastSyncDate BETWEEN FDJobCode.StartDate AND FDJobCode.EndDate
			
			-- Parent Level
		LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment FD ON
			PS.FunctionalDepartmentCode = FD.FunctionalDepartmentCode AND
			FD.FunctionalDepartmentCode = FD.SubFunctionalDepartmentCode AND
			Sshot.LastSyncDate BETWEEN FD.StartDate AND FD.EndDate
	WHERE
		PS.BudgetAmount <> 0

	PRINT ('Rows inserted into #ProfitabilityBudget: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE UNIQUE CLUSTERED INDEX IX_ProfitabilityBudget ON #ProfitabilityBudget (ReferenceCode)

	PRINT ('Created Unique INDEX  IX_ProfitabilityBudget on #ProfitabilityBudget')
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END

/* ==============================================================================================================================================
	10. Update the GL Categorization Hierarchy fields in the 'staging' temporary table
   =========================================================================================================================================== */
BEGIN

-- Global Categorization Mapping

	UPDATE
		#ProfitabilityBudget
	SET
		GlobalGLCategorizationHierarchyKey = 
			COALESCE(GLACM.GlobalGLCategorizationHierarchyKey, @UnknownGlobalGLCategorizationKey)
	FROM
		#ProfitabilityBudget PB
		
		LEFT OUTER JOIN #GLAccountCategoryMapping GLACM ON
			PB.GLGlobalAccountId  = GLACM.GLGlobalAccountId AND
			PB.SnapshotId = GLACM.SnapshotId AND
			GLACM.IsDirect = CASE
								WHEN PB.IsExpense = 0 -- If the transaction is a 'Fee' ...
								THEN
									0                 -- ... Then map to the indirect allocation [3.4.3.2: 1]
								ELSE                  -- Else it must be a Non-Payroll Expense ...
									PB.IsDirectCost   -- ... so use the allocation that the transaction has been assigned in NonPayrollExpenseBreakdown
													  -- [3.4.3.2: 4]
							 END

		LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy UnknownGCH ON
			UnknownGCH.GLCategorizationHierarchyCode = '-1:-1:-1:-1:-1:' + CONVERT(VARCHAR(10), PB.GLGlobalAccountId) AND
			PB.SnapshotId = UnknownGCH.SnapshotId 

	RAISERROR( 'Updating #ProfitabilityBudget Global categorization mapping',0,1) WITH NOWAIT

-- Local Categorization Mapping

	UPDATE
		#ProfitabilityBudget
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
			COALESCE(GLACM.EUDevelopmentGLCategorizationHierarchyKey, @UnknownGLCategorizationHierarchyKey),

		ReportingGLCategorizationHierarchyKey =
			CASE 
				WHEN GC.GLCategorizationId IS NOT NULL
				THEN
					CASE
						WHEN GC.Name = 'US Property'	THEN ISNULL(GLACM.USPropertyGLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey)
						WHEN GC.Name = 'US Fund'		THEN ISNULL(GLACM.USFundGLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey)
						WHEN GC.Name = 'EU Property'	THEN ISNULL(GLACM.EUPropertyGLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey)
						WHEN GC.Name = 'EU Fund'		THEN ISNULL(GLACM.EUFundGLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey)
						WHEN GC.Name = 'US Development' THEN ISNULL(GLACM.USDevelopmentGLCategorizationHierarchyKey, @UnknownUSDevelopmentGLCategorizationKey)
						WHEN GC.Name = 'EU Development' THEN ISNULL (GLACM.EUDevelopmentGLCategorizationHierarchyKey, @UnknownGLCategorizationHierarchyKey)
						WHEN GC.Name = 'Global' THEN Gl.GlobalGLCategorizationHierarchyKey
						ELSE
							ISNULL(UnknownGCH.GLCategorizationHierarchyKey, @UnknownGLCategorizationHierarchyKey)
					END
				ELSE
					ISNULL(UnknownGCH.GLCategorizationHierarchyKey, @UnknownGLCategorizationHierarchyKey)
			END
	FROM
		#ProfitabilityBudget Gl
		
		LEFT OUTER JOIN #GLAccountCategoryMapping GLACM ON
			Gl.GLGlobalAccountId  = GLACM.GLGlobalAccountId AND
			Gl.SnapshotId  = GLACM.SnapshotId AND
			GLACM.IsDirect = CASE
								WHEN Gl.IsExpense = 0 -- If the transaction is a 'Fee' ... 
								THEN
									1                 -- ... Then map to the direct allocation [3.4.3.2: 2]
								ELSE                  -- Else it must be a Non-Payroll Expense ...
									Gl.IsDirectCost   -- ... so use the allocation that the transaction has been assigned in NonPayrollExpenseBreakdown
													  -- [3.4.3.2: 4]
							 END
				
		LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy UnknownGCH ON
			UnknownGCH.GLCategorizationHierarchyCode = '-1:-1:-1:-1:-1:' + CONVERT(VARCHAR(10), Gl.GLGlobalAccountId) AND
			Gl.SnapshotId = UnknownGCH.SnapshotId 

		LEFT OUTER JOIN #GLCategorization GC ON
			Gl.DefaultGLCategorizationId = GC.GLCategorizationId AND
			Gl.SnapshotId = GC.SnapshotId  
				
	RAISERROR( 'Updating #ProfitabilityBudget Local categorization mapping',0,1) WITH NOWAIT

	PRINT ('Rows updated from #ProfitabilityBudget: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END

/* ==============================================================================================================================================
	11. Delete budgets to insert that have UNKNOWNS in their mapping
   =========================================================================================================================================== */
BEGIN

-- Delete all existing GBS records from dbo.ProfitabilityBudgetUnknowns
	DELETE
	FROM
		dbo.ProfitabilityBudgetUnknowns
	WHERE
		BudgetReforecastTypeKey = @GBSBudgetReforecastTypeKey -- Only delete GBS records, leave TAPAS records

	INSERT INTO dbo.ProfitabilityBudgetUnknowns (
		ImportBatchId,
		CalendarKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		PropertyFundKey,
		AllocationRegionKey,
		ConsolidationRegionKey, -- (CC 16)
		OriginatingRegionKey,
		LocalCurrencyKey,
		LocalBudget,
		ReferenceCode,
		BudgetId,
		BudgetReforecastTypeKey,
		OverheadKey,
		FeeAdjustmentKey,
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
		ConsolidationRegionKey, -- (CC16)
		OriginatingRegionKey,
		LocalCurrencyKey,
		LocalBudget,
		ReferenceCode,
		BudgetId,
		@GBSBudgetReforecastTypeKey,
		OverheadKey,
		FeeAdjustmentKey,
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
		#ProfitabilityBudget
	WHERE
		SourceKey = @UnknownSourceKey OR
		(FunctionalDepartmentKey = @UnknownFunctionalDepartmentKey AND IsExpense = 1) OR	
		ActivityTypeKey = @UnknownActivityTypeKey OR
		PropertyFundKey = @UnknownPropertyFundKey OR
		AllocationRegionKey = @UnknownAllocationRegionKey OR 
		OriginatingRegionKey = @UnknownOriginatingRegionKey OR
		LocalCurrencyKey = @UnknownLocalCurrencyKey OR
		GlobalGLCategorizationHierarchyKey = @UnknownGLCategorizationHierarchyKey 
		
		-- LocalBudget
		-- OverheadKey: always UNKNOWN for Fees, UNKNOWN from non-payroll if Activity Type code <> CORPOH
		-- CalendarKey: not required to check if UNKNOWN or NULL because CalendarKey is hard-coded	
		-- ReferenceCode: not required to check if UNKNOWN or NULL because CalendarKey is hard-coded
		-- BudgetId: This field is sourced directly from GBS.Budget and cannot be NULL (has a 'not null' dbase constraint in source system)
		-- SourceSystemId
		
END

/* ==============================================================================================================================================
	12. Delete existing budgets from GrReporting.dbo.ProfitabilityBudget that we are about to reinsert
   =========================================================================================================================================== */
BEGIN

	CREATE TABLE #BudgetsToImportOriginal( -- an original copy of the budgets that are to be imported is kept here - the budgets in the table below will be deleted during insertion into the warehouse
		BudgetId INT NOT NULL
	)

	CREATE TABLE #BudgetsToImport(
		BudgetId INT NOT NULL
	)

	INSERT INTO #BudgetsToImportOriginal
	SELECT DISTINCT
		BudgetId
	FROM
		#ProfitabilityBudget

	INSERT INTO #BudgetsToImport
	SELECT DISTINCT
		BudgetId
	FROM
		#BudgetsToImportOriginal

SET @StartTime = GETDATE()

CREATE TABLE #SummaryOfChanges
(
	Change VARCHAR(20)
)

MERGE
	GrReporting.dbo.ProfitabilityBudget FACT
USING
	#ProfitabilityBudget AS SRC ON
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
		FACT.LocalBudget <> SRC.LocalBudget OR
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
		ISNULL(FACT.ReportingGLCategorizationHierarchyKey, '') <> SRC.ReportingGLCategorizationHierarchyKey OR 
		FACT.UpdatedDate IS NULL
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
		FACT.LocalBudget = SRC.LocalBudget,
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
		@GBSBudgetReforecastTypeKey,
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
WHEN NOT MATCHED BY SOURCE AND
	FACT.BudgetId IN (SELECT BudgetId FROM #BudgetsToImport) AND
	FACT.BudgetReforecastTypeKey = @GBSBudgetReforecastTypeKey THEN
	DELETE
OUTPUT
		$action
	INTO
		#SummaryOfChanges;

CREATE NONCLUSTERED INDEX UX_SummaryOfChanges_Change ON #SummaryOfChanges(Change)

DECLARE @InsertedRows INT = (SELECT COUNT(*) FROM #SummaryOfChanges WHERE Change = 'INSERT')
DECLARE @UpdatedRows INT = (SELECT COUNT(*) FROM #SummaryOfChanges WHERE Change = 'UPDATE')
DECLARE @DeletedRows INT = (SELECT COUNT(*) FROM #SummaryOfChanges WHERE Change = 'DELETE')

PRINT 'Rows added to ProfitabilityBudget: '+ CONVERT(char(10), @InsertedRows)
PRINT 'Rows updated in ProfitabilityBudget: '+ CONVERT(char(10),@UpdatedRows)
PRINT 'Rows deleted from ProfitabilityBudget: '+ CONVERT(char(10),@DeletedRows)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


	
END

/* ==============================================================================================================================================
	14. Mark budgets as being successfully processed into the warehouse
   =========================================================================================================================================== */
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

/* ==============================================================================================================================================
	15. Clean up: drop temporary tables
   =========================================================================================================================================== */
BEGIN

	IF 	OBJECT_ID('tempdb..#Budget') IS NOT NULL
		DROP TABLE #Budget

	IF 	OBJECT_ID('tempdb..#BudgetsToProcess') IS NOT NULL
		DROP TABLE #BudgetsToProcess

	IF 	OBJECT_ID('tempdb..#BudgetsWithUnknownBudgets') IS NOT NULL
		DROP TABLE #BudgetsWithUnknownBudgets

	IF 	OBJECT_ID('tempdb..#GLGlobalAccount') IS NOT NULL
		DROP TABLE #GLGlobalAccount

	IF 	OBJECT_ID('tempdb..#GLMinorCategory') IS NOT NULL
		DROP TABLE #GLMinorCategory
	    
	IF 	OBJECT_ID('tempdb..#GLMajorCategory') IS NOT NULL
		DROP TABLE #GLMajorCategory

	IF 	OBJECT_ID('tempdb..#GLFinancialCategory') IS NOT NULL
		DROP TABLE #GLFinancialCategory

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

	IF 	OBJECT_ID('tempdb..#PreviousBudgetsLastLockedDate') IS NOT NULL
		DROP TABLE #PreviousBudgetsLastLockedDate

	IF 	OBJECT_ID('tempdb..#BudgetsToProcess') IS NOT NULL
		DROP TABLE #BudgetsToProcess

	IF 	OBJECT_ID('tempdb..#BudgetsWithUnknownBudgets') IS NOT NULL
		DROP TABLE #BudgetsWithUnknownBudgets
	    
	IF 	OBJECT_ID('tempdb..#ConsolidatonRegionCorporateDepartment') IS NOT NULL
		DROP TABLE #ConsolidatonRegionCorporateDepartment

	IF 	OBJECT_ID('tempdb..#CategorizationType') IS NOT NULL
		DROP TABLE #CategorizationType
	    
	IF 	OBJECT_ID('tempdb..#Categorization') IS NOT NULL
		DROP TABLE #Categorization
	    
	IF 	OBJECT_ID('tempdb..#FinancialCategory') IS NOT NULL
		DROP TABLE #FinancialCategory
	    
	IF 	OBJECT_ID('tempdb..#GLGlobalAccountCategorization') IS NOT NULL
		DROP TABLE #GLGlobalAccountCategorization
	    
	IF 	OBJECT_ID('tempdb..#ReportingCategorization') IS NOT NULL
		DROP TABLE #ReportingCategorization

	IF 	OBJECT_ID('tempdb..#BudgetsToProcessToUpdate') IS NOT NULL
		DROP TABLE #BudgetsToProcessToUpdate

END


GO


