/*
	We need:
	
		stp_IU_LoadGrProfitabiltyPayrollReforecast
		stp_I_BudgetsToProcess
*/



--BEGIN TRAN

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.stp_IU_LoadGrProfitabiltyPayrollReforecast') AND type in (N'P', N'PC'))
	DROP PROCEDURE dbo.stp_IU_LoadGrProfitabiltyPayrollReforecast
GO

/*********************************************************************************************************************
Description
	This stored procedure processes payroll reforecast data and uploads it to the
	ProfitabilityReforecast table in the data warehouse (GrReporting.dbo.ProfitabilityReforecast)
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-06-23		: PKayongo	:	Added ConsolidationRegion mapping as per CC16. Added the field to the 
											data inserted into the warehouse. 	
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]
AS

PRINT '####'
PRINT 'stp_IU_LoadGrProfitabiltyPayrollReforecast'
PRINT '####'

SET NOCOUNT ON

DECLARE @RowCount INT


DECLARE @StartTime DATETIME
DECLARE @DebugMode BIT = 1 --- Running some extra test queries for debugging purposes. Start comment DEBUG MODE for search and check this variable.



DECLARE @DataPriorToDate DATETIME=NULL
IF (@DataPriorToDate IS NULL)
BEGIN
	SET @DataPriorToDate = CONVERT(DATETIME, (SELECT ConfiguredValue FROM SSISConfigurations WHERE ConfigurationFilter = 'PayrollBudgetDataPriorToDate'))
END

DECLARE @CanImportTapasReforecast INT = (SELECT ConfiguredValue FROM [GrReportingStaging].[dbo].[SSISConfigurations] WHERE ConfigurationFilter = 'CanImportTAPASReforecast')

IF (@CanImportTapasReforecast <> 1)
BEGIN
	PRINT ('Import of TAPAS Reforecasts is not scheduled in GrReportingStaging.dbo.SSISConfigurations')
	RETURN
END
	
--DECLARE @SourceSystemName varchar(50) = 'Tapas Budgeting'
--DECLARE @SourceSystemNameGBS varchar(50) = 'Global Budgeting System'
DECLARE
	@EUFundGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Fund Profit & Loss'      AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@EUCorporateGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@EUPropertyGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Property Profit & Loss'  AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@USFundGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Fund Profit & Loss'      AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@USPropertyGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Property Profit & Loss'  AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@USCorporateGlAccountCategoryKeyUnknown INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@DevelopmentGlAccountCategoryKeyUnknown INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'Development Profit & Loss'  AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@GlobalGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global' AND TranslationSubTypeName = 'Global' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
	
-- Setup account categories and default to UNKNOWN.
DECLARE 
	@SalariesTaxesBenefitsMajorGlAccountCategoryId INT = -1,
	@BaseSalaryMinorGlAccountCategoryId INT = -1,
	@BenefitsMinorGlAccountCategoryId INT = -1,
	@BonusMinorGlAccountCategoryId INT = -1,
	@ProfitShareMinorGlAccountCategoryId INT = -1,
	@OccupancyCostsMajorGlAccountCategoryId INT = -1,
	@OverheadMinorGlAccountCategoryId INT = -1

DECLARE 
	@GlAccountKeyUnknown			INT = (SELECT GlAccountKey FROM GrReporting.dbo.GlAccount WHERE Code = 'UNKNOWN'),
	@SourceKeyUnknown				INT = (SELECT SourceKey FROM GrReporting.dbo.[Source] WHERE SourceName = 'UNKNOWN'),
	@FunctionalDepartmentKeyUnknown INT = (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = 'UNKNOWN'),
	@ReimbursableKeyUnknown			INT = (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = 'UNKNOWN'),
	@ActivityTypeKeyUnknown			INT = (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = 'UNKNOWN'),
	@PropertyFundKeyUnknown			INT = (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = 'UNKNOWN'),
	@AllocationRegionKeyUnknown		INT = (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = 'UNKNOWN'),
	@OriginatingRegionKeyUnknown	INT = (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = 'UNKNOWN'),
	@OverheadKeyUnknown				INT = (Select OverheadKey From GrReporting.dbo.Overhead Where OverheadCode = 'UNKNOWN'),
    @LocalCurrencyKeyUnknown		INT = (SELECT CurrencyKey FROM GrReporting.dbo.Currency WHERE CurrencyCode =  'UNK' )

IF @LocalCurrencyKeyUnknown IS NULL
BEGIN
	PRINT '@LocalCurrencyKeyUnknown is null. No unknown currency key found'
	RETURN
END    
   
DECLARE @ReforecastTypeIsTGBBUDKey INT = (SELECT BudgetReforecastTypeKey from GrReporting.dbo.BudgetReforecastType where BudgetReforecastTypeCode = 'TGBBUD')
DECLARE @ReforecastTypeIsTGBACTKey INT = (SELECT BudgetReforecastTypeKey from GrReporting.dbo.BudgetReforecastType where BudgetReforecastTypeCode = 'TGBACT')
	
DECLARE @ImportErrorTable TABLE (
	Error varchar(50)
);
	
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Setup mapping variables
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


-- Set gl account categories
SELECT TOP 1
	@SalariesTaxesBenefitsMajorGlAccountCategoryId = GLMajorCategoryId
FROM
	Gr.GetSnapshotGlobalGlAccountCategoryTranslation()
WHERE
	GLMajorCategoryName = 'Salaries/Taxes/Benefits'

print (@SalariesTaxesBenefitsMajorGlAccountCategoryId)
--NB!!!!!!!
--The roll up to payroll is very sensitive information. It is crutial that information regarding payroll not get 
--communicated to TS employees on certain reports. Changing the category name here will have ramifications because 
--some reports check for this name.
--NB!!!!!!!

SELECT
	@BaseSalaryMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetSnapshotGlobalGlAccountCategoryTranslation()
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	GLMinorCategoryName = 'Base Salary'

SELECT
	@BenefitsMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetSnapshotGlobalGlAccountCategoryTranslation()
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	GLMinorCategoryName = 'Benefits'

SELECT
	@BonusMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetSnapshotGlobalGlAccountCategoryTranslation()
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	GLMinorCategoryName = 'Bonus'

SELECT
	@ProfitShareMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetSnapshotGlobalGlAccountCategoryTranslation()
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	GLMinorCategoryName = 'Benefits' -- Yes benefit is correct (Just incase they want to split profit share out again)

SELECT TOP 1
	@OccupancyCostsMajorGlAccountCategoryId = GLMajorCategoryId 
FROM
	Gr.GetSnapshotGlobalGlAccountCategoryTranslation()
WHERE
	GLMajorCategoryName = 'General Overhead'

SELECT
	@OverheadMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetSnapshotGlobalGlAccountCategoryTranslation()
WHERE
	GLMajorCategoryId = @OccupancyCostsMajorGlAccountCategoryId AND
	GLMinorCategoryName = 'External General Overhead'

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Source Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--
-- Setup Bonus Cap Excess Project Setting
--

-- ==============================================================================================================================================
-- Get Budgets to Process
-- ==============================================================================================================================================

SELECT 
	BTPC.*,
	CRR.ReforecastKey
INTO 
	#BudgetsToProcess 
FROM 
	dbo.BudgetsToProcessCurrent('TGB Budget/Reforecast') BTPC
	INNER JOIN GrReporting.dbo.GetCurrentReforecastRecord() CRR ON
		BTPC.BudgetYear = CRR.ReforecastEffectiveYear AND
		BTPC.BudgetQuarter = CRR.ReforecastQuarterName	
WHERE 
	IsReforecast = 1

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

-- ==============================================================================================================================================
-- Get Budgets
-- ==============================================================================================================================================



SET @StartTime = GETDATE()

SELECT 
	B.ImportBatchId,
	B.BudgetId,
	B.BudgetReportGroupPeriodId
INTO
	#LastImportedGBSBudgets
FROM
	GBS.Budget B
	INNER JOIN (
		SELECT 
			MAX(ImportBatchId) AS ImportBatchId
		FROM
			GBS.Budget
		WHERE 
			IsReforecast = 1
		) MB ON
		MB.ImportBatchId = B.ImportBatchId


SET @RowCount = @@ROWCOUNT
PRINT 'Completed inserting records into #LastImportedGBSBudgets:'+CONVERT(char(10),@RowCount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
IF (@RowCount = 0)
BEGIN
	PRINT 'WARNING: No GBS budgets found, so no actuals will be imported'
END

SET @StartTime = GETDATE()

--DECLARE @TempGBSImportBatchId INT = (SELECT MAX(BatchId) FROM dbo.Batch WHERE PackageName = 'ETL.Staging.GBS')

CREATE TABLE #NewBudgets(
	ImportBatchId INT NOT NULL,
	ImportKey INT NOT NULL,
	SnapshotId INT NOT NULL,
	BudgetId INT NOT NULL,
	RegionId INT NOT NULL,
	BudgetTypeId INT NOT NULL,
	BudgetStatusId INT NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NOT NULL,
	FirstProjectedPeriod INT NULL,
	CurrencyCode VARCHAR(3) NOT NULL,
	CanEmployeesViewBudget BIT NOT NULL,
	IsReforecast BIT NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	LastLockedDate DATETIME NULL,
	BudgetAllocationSetId INT NULL,
	LastAMUpdateDate DATETIME NULL,
	BudgetReportGroupPeriodId INT NOT NULL,
	BudgetReportGroupPeriod INT NOT NULL,
	GroupEndPeriod INT NOT NULL,
	GBSBudgetId INT NULL, -- CAN BE NULL IN WHICH CASE NO ACTUALS WILL BE IMPORTED
	MustImportAllActualsIntoWarehouse BIT NOT NULL,
	ReforecastKey INT NOT NULL,
	BudgetReportGroupId INT NOT NULL
)
INSERT INTO #NewBudgets(
	ImportBatchId,
	ImportKey,
	SnapshotId,
	BudgetId,
	RegionId,
	BudgetTypeId,
	BudgetStatusId,
	[Name],
	StartPeriod,
	EndPeriod,
	FirstProjectedPeriod,
	CurrencyCode,
	CanEmployeesViewBudget,
	IsReforecast,
	IsDeleted,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	LastLockedDate,
	BudgetAllocationSetId,
	LastAMUpdateDate,
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
	Budget.BudgetTypeId,
	Budget.BudgetStatusId,
	Budget.Name,
	Budget.StartPeriod,
	Budget.EndPeriod,
	Budget.FirstProjectedPeriod,
	Budget.CurrencyCode,
	Budget.CanEmployeesViewBudget,
	Budget.IsReforecast,
	Budget.IsDeleted,
	Budget.InsertedDate,
	Budget.UpdatedDate,
	Budget.UpdatedByStaffId,
	Budget.LastLockedDate,
	Budget.BudgetAllocationSetId,
	Budget.LastAMUpdateDate,
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
		Budget.BudgetId = brgd.BudgetId AND
		BRGD.ImportBatchId = BTP.ImportBatchId
		
	INNER JOIN TapasGlobalBudgeting.BudgetReportGroup brg ON
		brgd.BudgetReportGroupId = brg.BudgetReportGroupId	 AND
		BRG.ImportBatchId = BTP.ImportBatchId
		
	INNER JOIN Gdm.BudgetReportGroupPeriod brgp ON
		brgp.BudgetReportGroupPeriodId = brg.BudgetReportGroupPeriodId
		
	INNER JOIN Gdm.BudgetReportGroupPeriodActive(@DataPriorToDate) brgpA ON
		brgp.ImportKey = brgpA.ImportKey
				   
	LEFT OUTER JOIN #LastImportedGBSBudgets LIGB ON
		LIGB.BudgetReportGroupPeriodId = BRG.BudgetReportGroupPeriodId

	LEFT OUTER JOIN GBS.Budget GBSBudget ON
	   GBSBudget.BudgetReportGroupPeriodId = LIGB.BudgetReportGroupPeriodId AND
	   GBSBudget.BudgetId = LIGB.BudgetId AND
	   GBSBudget.ImportBatchId = LIGB.ImportBatchId
		
DECLARE @NumberOfBudgets INT = @@rowcount
		
PRINT 'Completed inserting records into #NewBudgets:'+CONVERT(char(10),@NumberOfBudgets)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

IF @NumberOfBudgets = 0 BEGIN
	PRINT '#NewBudgets: Found NO Budgets to import. Nothing to do. Quitting...'
	--PRINT 'GBSBudget ImportID: ' + STR(LTRIM(@TempGBSImportBatchId))
	RETURN
END

SET @StartTime = GETDATE()

CREATE UNIQUE CLUSTERED INDEX IX_BudgetID ON #newBudgets (SnapshotId, BudgetId)

PRINT 'Completed creating indexes on #Budget'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


----------------------------------------------------------------------------------------------
-- Source the GBS Budget
SET @StartTime = GETDATE()

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
		TB.BudgetId = GB.BudgetId 
		
	INNER JOIN #LastImportedGBSBudgets LIGB ON
		LIGB.ImportBatchId = GB.ImportBatchId AND
		LIGB.BudgetReportGroupPeriodId = GB.BudgetReportGroupPeriodId AND
		LIGB.BudgetId = GB.BudgetId		
		
--WHERE 
--	GB.ImportBatchId = @TempGBSImportBatchId				
		
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
-- DISTINCT Snapshots
----------------------------------------------------------------------------------------------
-- Source the Distinct snapshots

SELECT DISTINCT 
	SnapshotId 
INTO 
	#DistinctSnapshots 
FROM 
	#NewBudgets
	
SELECT DISTINCT
	ImportBatchId
INTO
	#DistinctImports
FROM 
	#BudgetsToProcess BTP

----------------------------------------------------------------------------------------------
-- All combined Budgets GBS + Tapas
----------------------------------------------------------------------------------------------

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

--SELECT * FROM #AllBudgets

CREATE TABLE #SystemSettingRegion
(
	SystemSettingId INT NOT NULL,
	SystemSettingName VARCHAR(50) NOT NULL,
	SystemSettingRegionId INT NOT NULL,
	RegionId INT,
	SourceCode VARCHAR(2),
	BonusCapExcessProjectId INT
)

SET @StartTime = GETDATE()

-- #GLTranslationType
CREATE TABLE #SnapshotGLTranslationType(
	SnapshotId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

SET @StartTime = GETDATE()

INSERT INTO #SnapshotGLTranslationType(
	SnapshotId,
	GLTranslationTypeId,
	Code,
	[Name],
	[Description],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	DS.SnapshotId,
	TT.GLTranslationTypeId,
	TT.Code,
	TT.Name,
	TT.[Description],
	TT.IsActive,
	TT.InsertedDate,
	TT.UpdatedDate,
	TT.UpdatedByStaffId
FROM
	Gdm.SnapshotGLTranslationType TT 
	INNER JOIN #DistinctSnapshots DS ON
		DS.SnapShotId = TT.SnapshotId

PRINT 'Completed inserting records into #SnapshotGLTranslationType:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

CREATE TABLE #SnapshotGLAccountType(
	SnapshotId INT NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

-- #SystemSettingRegion
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
			ssr.* 
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
					ss.*
				FROM
					TapasGlobal.SystemSetting ss
					INNER JOIN TapasGlobal.SystemSettingActive(@DataPriorToDate) ssA ON
						ss.ImportKey = ssA.ImportKey
			 ) ss
		) ss ON ssr.SystemSettingId = ss.SystemSettingId

PRINT 'Completed inserting #SystemSettingRegion'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

-- #GLTranslationSubType
CREATE TABLE #SnapshotGLTranslationSubType(
	SnapshotId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsGRDefault BIT NOT NULL
)
INSERT INTO #SnapshotGLTranslationSubType(
	SnapshotId,
	GLTranslationSubTypeId,
	GLTranslationTypeId,
	Code,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsGRDefault
)
SELECT
	DS.SnapshotId,
	TST.GLTranslationSubTypeId,
	TST.GLTranslationTypeId,
	TST.Code,
	TST.[Name],
	TST.IsActive,
	TST.InsertedDate,
	TST.UpdatedDate,
	TST.UpdatedByStaffId,
	TST.IsGRDefault
FROM
	Gdm.SnapshotGLTranslationSubType TST
	INNER JOIN #DistinctSnapshots DS ON
	  TST.SnapshotId = DS.SnapshotId
WHERE
    TST.Code = 'GL'	  AND
    TST.IsActive = 1

SET @RowCount = @@ROWCOUNT
IF @RowCount = 0
BEGIN
	RAISERROR('#SnapshotGLTranslationSubType: NO Records inserted, please check there are rows in Gdm.SnapshotGLTranslationSubType for the Snapshots in BudgetsToProcess', 16, -1)
	RETURN
END

PRINT 'Completed inserting records to #SnapshotGLTranslationSubType:'+CONVERT(char(10),@RowCount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

CREATE INDEX IX_SnapshotGLTranslationSubType1 ON #SnapshotGLTranslationSubType (SnapshotId)

PRINT 'Completed creating indexes on #SnapshotGLTranslationSubType'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE TABLE #SnapshotGLGlobalAccount(
	GLGlobalAccountId INT NOT NULL,
	ActivityTypeId INT NULL,
	GLStatutoryTypeId INT NOT NULL,
	ParentGLGlobalAccountId INT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] NVARCHAR(150) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsGR BIT NOT NULL,
	IsGbs BIT NOT NULL,
	IsRegionalOverheadCost BIT NOT NULL,
	ExpenseCzarStaffId INT NOT NULL,
	ParentCode AS (left(Code,(8))),
	SnapshotId INT NOT NULL
)
INSERT INTO #SnapshotGLGlobalAccount (
	GLGlobalAccountId,
	ActivityTypeId,
	GLStatutoryTypeId,
	ParentGLGlobalAccountId,
	Code,
	[Name],
	[Description],
	IsGR,
	IsGbs,
	IsRegionalOverheadCost,
	ExpenseCzarStaffId,
	SnapshotId
)
SELECT
	GLGA.GLGlobalAccountId,
	GLGA.ActivityTypeId,
	GLGA.GLStatutoryTypeId,
	GLGA.ParentGLGlobalAccountId,
	GLGA.Code,
	GLGA.Name,
	GLGA.[Description],
	GLGA.IsGR,
	GLGA.IsGbs,
	GLGA.IsRegionalOverheadCost,
	GLGA.ExpenseCzarStaffId,
	GLGA.SnapshotId
FROM
	Gdm.SnapshotGLGlobalAccount GLGA
	INNER JOIN #DistinctSnapshots DS ON
		GLGA.SnapshotId = DS.SnapshotId
WHERE
	GLGA.IsActive = 1

PRINT ('Rows inserted into #SnapshotGLGlobalAccount: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))	

SET @StartTime = GETDATE()

CREATE UNIQUE CLUSTERED INDEX IX_SnapshotGLGlobalAccount1 ON #SnapshotGLGlobalAccount (SnapshotId, GLGlobalAccountId)

PRINT 'Completed creating indexes on #SnapshotGLGlobalAccount'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))



-- AllocationSubRegion --------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #SnapshotAllocationSubRegion (
	SnapshotId int NOT NULL,
	AllocationSubRegionGlobalRegionId int NOT NULL,
	Code varchar(10) NOT NULL,
	[Name] varchar(50) NOT NULL,
	AllocationRegionGlobalRegionId int NULL,
	DefaultCorporateSourceCode char(2) NOT NULL
)
INSERT INTO #SnapshotAllocationSubRegion
SELECT
	ASR.SnapshotId,
	ASR.AllocationSubRegionGlobalRegionId,
	ASR.Code,
	ASR.Name,
	ASR.AllocationRegionGlobalRegionId,
	ASR.DefaultCorporateSourceCode
FROM
	Gdm.SnapshotAllocationSubRegion ASR
	INNER JOIN #DistinctSnapshots DS ON
		ASR.SnapshotId = DS.SnapshotId
WHERE
	ASR.IsActive = 1

PRINT ('Rows inserted into #AllocationSubRegion: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- ConsolidationSubRegion --------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #SnapshotConsolidationSubRegion (
	SnapshotId int NOT NULL,
	ConsolidationSubRegionGlobalRegionId int NOT NULL,
	ConsolidationSubRegionGlobalRegionCode varchar(10) NOT NULL,
	[Name] varchar(50) NOT NULL,
	AllocationRegionGlobalRegionId int NULL,
	DefaultCorporateSourceCode char(2) NOT NULL
)
INSERT INTO #SnapshotConsolidationSubRegion
SELECT
	CSR.SnapshotId,
	CSR.ConsolidationSubRegionGlobalRegionId,
	CSR.ConsolidationSubRegionGlobalRegionCode,
	CSR.Name,
	CSR.ConsolidationRegionGlobalRegionId,
	CSR.DefaultCorporateSourceCode
FROM
	Gdm.SnapshotConsolidationSubRegion CSR
	INNER JOIN #DistinctSnapshots DS ON
		CSR.SnapshotId = DS.SnapshotId
WHERE
	CSR.IsActive = 1

PRINT ('Rows inserted into #AllocationSubRegion: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- #GLMajorCategory

CREATE TABLE #SnapshotGLMajorCategory(
	SnapshotId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)
SET @StartTime = GETDATE()

INSERT INTO #SnapshotGLMajorCategory(
	SnapshotId,
	GLMajorCategoryId,
	GLTranslationSubTypeId,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	DS.SnapshotId,
	MajC.GLMajorCategoryId,
	MajC.GLTranslationSubTypeId,
	MajC.[Name],
	MajC.IsActive,
	MajC.InsertedDate,
	MajC.UpdatedDate,
	MajC.UpdatedByStaffId
FROM
	Gdm.SnapshotGLMajorCategory MajC
	INNER JOIN #DistinctSnapshots DS ON
		DS.SnapShotId = MajC.SnapshotId


PRINT ('Rows inserted into #SnapshotGLMajorCategory: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))



SET @StartTime = GETDATE()

CREATE UNIQUE CLUSTERED INDEX IX_SnapshotGLMajorCategory ON #SnapshotGLMajorCategory (SnapshotId, GLMajorCategoryId)

PRINT 'Completed creating indexes on #SnapshotGLMajorCategory'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- #GLMinorCategory

CREATE TABLE #SnapshotGLMinorCategory(
	SnapshotId INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)
SET @StartTime = GETDATE()

INSERT INTO #SnapshotGLMinorCategory(
	SnapshotId,
	GLMinorCategoryId,
	GLMajorCategoryId,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	DS.SnapshotId,
	Minc.GLMinorCategoryId,
	Minc.GLMajorCategoryId,
	Minc.[Name],
	Minc.IsActive,
	Minc.InsertedDate,
	Minc.UpdatedDate,
	Minc.UpdatedByStaffId
FROM
	Gdm.SnapshotGLMinorCategory MinC
	INNER JOIN #DistinctSnapshots DS ON
		DS.SnapShotId = MinC.SnapshotId
		
PRINT ('Rows inserted into #SnapshotGLMinorCategory: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
		
		
SET @StartTime = GETDATE()

CREATE UNIQUE CLUSTERED INDEX IX_SnapshotGLMinorCategory1 ON #SnapshotGLMinorCategory (SnapshotId, GLMinorCategoryId)

PRINT 'Completed creating indexes on #SnapshotGLMinorCategory'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
		
		
-- #GLAccountType
SET @StartTime = GETDATE()

INSERT INTO #SnapshotGLAccountType(
	SnapshotId,
	GLAccountTypeId,
	GLTranslationTypeId,
	Code,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	DS.SnapshotId,
	AT.GLAccountTypeId,
	AT.GLTranslationTypeId,
	AT.Code,
	AT.Name,
	AT.IsActive,
	AT.InsertedDate,
	AT.UpdatedDate,
	AT.UpdatedByStaffId	
FROM
	Gdm.SnapshotGLAccountType AT
	INNER JOIN #DistinctSnapshots DS ON
		DS.SnapShotId = AT.SnapshotId

PRINT ('Rows inserted into #SnapshotGLAccountType: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
	
-- #GLAccountSubType

SET @StartTime = GETDATE()

CREATE TABLE #SnapshotGLAccountSubType(
	SnapshotId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)
INSERT INTO #SnapshotGLAccountSubType(
	SnapshotId,
	GLAccountSubTypeId,
	GLTranslationTypeId,
	Code,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	DS.SnapshotId,
	AST.GLAccountSubTypeId,
	AST.GLTranslationTypeId,
	AST.Code,
	AST.Name,
	AST.IsActive,
	AST.InsertedDate,
	AST.UpdatedDate,
	AST.UpdatedByStaffId
FROM
	Gdm.SnapshotGLAccountSubType AST
	INNER JOIN #DistinctSnapshots DS ON
		DS.SnapShotId = AST.SnapshotId

PRINT ('Rows inserted into #SnapshotGLAccountSubType: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- GLGlobalAccount --------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #SnapshotGLGlobalAccountTranslationSubType (
	SnapshotId INT NOT NULL,
	GLGlobalAccountTranslationSubTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLMinorCategoryId INT NOT NULL
)
INSERT INTO #SnapshotGLGlobalAccountTranslationSubType
SELECT
	GATST.SnapshotId,
	GATST.GLGlobalAccountTranslationSubTypeId,
	GATST.GLGlobalAccountId,
	GATST.GLTranslationSubTypeId,
	GATST.GLMinorCategoryId
FROM
	Gdm.SnapshotGLGlobalAccountTranslationSubType GATST
	INNER JOIN #DistinctSnapshots B ON
		GATST.SnapshotId = B.SnapshotId
WHERE
	GATST.IsActive = 1

PRINT ('Rows inserted into #SnapshotGLGlobalAccountTranslationSubType: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- GLGlobalAccountTranslationType --------------------------------------------------

CREATE INDEX IX_SnapshotGLGlobalAccountTranslationSubType1 ON #SnapshotGLGlobalAccountTranslationSubType (GLGlobalAccountId, SnapshotId)

PRINT 'Completed creating indexes on #SnapshotGLGlobalAccountTranslationSubType'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE TABLE #SnapshotGLGlobalAccountTranslationType(
	GLGlobalAccountTranslationTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL,
	SnapshotId INT NOT NULL
)

INSERT INTO #SnapshotGLGlobalAccountTranslationType
SELECT
	GATT.GLGlobalAccountTranslationTypeId, 
	GATT.GLGlobalAccountId, 
	GATT.GLTranslationTypeId, 
	GATT.GLAccountTypeId,	
	CASE WHEN
			GA.ActivityTypeId = 99
		 THEN 
				-- GC :: CC1 >>
				-- Unallocated overhead expenses will be grouped under the “Overhead” expense 
				-- type and not “Non-Payroll”. This will be based on the activity of the 
				-- transaction; all transactions that have a corporate overhead activity 
				-- will have an expense type of “Overhead”.
			
			AST.GLAccountSubTypeId
			
				--(
				--	SELECT
				--		*--GST.GLAccountSubTypeId 
				--	FROM
				--		Gdm.SnapshotGLAccountSubType GST 
				--		INNER JOIN Gdm.SnapshotGLTranslationType GTT ON
				--			GTT.GLTranslationTypeId = GST.GLTranslationTypeId
				--		INNER JOIN #Budget B ON
				--			GST.SnapshotId = B.SnapshotId AND
				--			GTT.SnapshotId = B.SnapshotId
				--	WHERE
				--		GTT.Code = 'GL' AND
				--		GST.Code = 'GRPOHD'	AND
				--		GST.IsActive = 1 AND
				--		GTT.IsActive = 1
				--)				
		 ELSE
			GATT.GLAccountSubTypeId
	END AS GLAccountSubTypeId,
	GATT.SnapshotId
FROM
	Gdm.SnapshotGLGlobalAccountTranslationType GATT
	
	INNER JOIN #GBSBudgets DS ON
		GATT.SnapshotId = DS.SnapshotId	

	LEFT OUTER JOIN (
						SELECT
							GA.*
						FROM
							#SnapshotGLGlobalAccount GA

					 ) GA ON
							GA.GLGlobalAccountId = GATT.GLGlobalAccountId AND
							GA.SnapshotId = GATT.SnapshotId

	LEFT OUTER JOIN (
						SELECT
							GST.GLAccountSubTypeId,
							B.BudgetId,
							GST.SnapshotId
						FROM
							Gdm.SnapshotGLAccountSubType GST 
							INNER JOIN Gdm.SnapshotGLTranslationType GTT ON
								GTT.GLTranslationTypeId = GST.GLTranslationTypeId
							INNER JOIN #GBSBudgets B ON
								GST.SnapshotId = B.SnapshotId AND
								GTT.SnapshotId = B.SnapshotId 
						WHERE
							GTT.Code = 'GL' AND
							GST.Code = 'GRPOHD'	AND
							GST.IsActive = 1 AND
							GTT.IsActive = 1
					) AST ON
							GATT.SnapshotId = AST.SnapshotId AND
							DS.BudgetId = AST.BudgetId

WHERE
	GATT.IsActive = 1

PRINT ('Rows inserted into #GLGlobalAccountTranslationType: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

------------------------------------------------------------------------------
-- Master GL Account Category mapping table GBS
------------------------------------------------------------------------------
SET @StartTime = GETDATE()

CREATE TABLE #GLAccountCategoryMapping (
	SnapshotId INT NOT NULL,
	GLAccountKey INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL
)
INSERT INTO #GLAccountCategoryMapping
SELECT
	DS.SnapshotId,
	Gla.GlAccountKey,
	TST.GLTranslationTypeId,
	TST.GLTranslationSubTypeId,
	MinC.GLMajorCategoryId,
	GLATST.GLMinorCategoryId,
	GLATT.GLAccountTypeId,
	GLATT.GLAccountSubTypeId
FROM
	#DistinctSnapshots DS

	INNER JOIN #SnapshotGLTranslationSubType TST ON
		DS.SnapshotId = TST.SnapshotId

	INNER JOIN #SnapshotGLGlobalAccountTranslationSubType GLATST ON
		TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
		DS.SnapshotId = GLATST.SnapshotId
	
	INNER JOIN #SnapshotGLGlobalAccountTranslationType GLATT ON
		GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
		TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
		DS.SnapshotId = GLATT.SnapshotId

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId AND
		DS.SnapshotId = GLA.SnapshotId

	INNER JOIN #SnapshotGLMinorCategory MinC ON
		GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		DS.SnapshotId = MinC.SnapshotId

	INNER JOIN #SnapshotGLMajorCategory MajC ON
		MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
		DS.SnapshotId = MajC.SnapshotId

PRINT ('Rows inserted into #GLAccountCategoryMapping: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


SET @StartTime = GETDATE()

-- Get GLTranslationType, GLTranslationSubType, GLAccountType(either expense type), and GLAccountSubType(either payroll type) data
-- This table is used when inserts are made to the TranslationSubType CategoryLookup tables: search for 'Map account categories' section

CREATE TABLE #SnapshotGLAccountCategoryTranslationsPayroll(
	SnapshotId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationSubTypeCode VARCHAR(10) NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL
)

INSERT INTO #SnapshotGLAccountCategoryTranslationsPayroll(
	SnapshotId,
	GLTranslationTypeId,
	GLTranslationSubTypeId,
	GLTranslationSubTypeCode,
	GLAccountTypeId,
	GLAccountSubTypeId
)
SELECT
    TST.SnapshotId,
	TST.GLTranslationTypeId,
	TST.GLTranslationSubTypeId,
	TST.Code,
	AT.GLAccountTypeId,
	AST.GLAccountSubTypeId
FROM
	#SnapshotGLTranslationSubType TST

	INNER JOIN #SnapshotGLTranslationType TT ON
		TT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		TST.SnapshotId = TT.SnapshotId

	INNER JOIN #SnapshotGLAccountType AT ON
		TST.GLTranslationTypeId = AT.GLTranslationTypeId AND
		AT.IsActive = 1 AND
		AT.SnapshotId = TST.SnapshotId

	INNER JOIN #SnapshotGLAccountSubType AST ON
		TST.GLTranslationTypeId = AST.GLTranslationTypeId AND
		AST.IsActive = 1 AND
		AST.SnapshotId = TST.SnapshotId
	
WHERE
	AST.Code LIKE '%PYR' AND -- This stored procedure exclusively looks at payroll. Only consider Account SubTypes related to payroll.
	AT.Code LIKE '%EXP' AND -- Only consider expense-related account types: Payroll is always considered as an expense.
	TT.IsActive = 1 AND
	TST.IsActive = 1 AND
	AT.IsActive = 1 AND
	AST.IsActive = 1

PRINT 'Completed inserting records to #SnapshotGLAccountCategoryTranslationsPayroll:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE TABLE #SnapshotGLAccountCategoryTranslationsOverhead(
    SnapshotId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationSubTypeCode VARCHAR(10) NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL
)

INSERT INTO #SnapshotGLAccountCategoryTranslationsOverhead(
	SnapshotId,
	GLTranslationTypeId,
	GLTranslationSubTypeId,
	GLTranslationSubTypeCode,
	GLAccountTypeId,
	GLAccountSubTypeId
)
SELECT
    TST.SnapshotId,
	TST.GLTranslationTypeId,
	TST.GLTranslationSubTypeId,
	TST.Code,
	AT.GLAccountTypeId,
	AST.GLAccountSubTypeId
FROM
	#SnapshotGLTranslationSubType TST

	INNER JOIN #SnapshotGLTranslationType TT ON
		TT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		TT.SnapshotId = TST.SnapshotId

	INNER JOIN #SnapshotGLAccountType AT ON
		TST.GLTranslationTypeId = AT.GLTranslationTypeId AND
		AT.IsActive = 1 AND
		AT.SnapshotId = TST.SnapshotId

	INNER JOIN #SnapshotGLAccountSubType AST ON
		TST.GLTranslationTypeId = AST.GLTranslationTypeId AND
		AST.IsActive = 1 AND
		AST.SnapshotId = TST.SnapshotId
	
WHERE
	AST.Code LIKE '%OHD' AND -- This stored procedure exclusively looks at payroll. Only consider Account SubTypes related to payroll.
	AT.Code LIKE '%EXP' AND -- Only consider expense-related account types: Payroll is always considered as an expense.
	TT.IsActive = 1 AND
	TST.IsActive = 1 AND
	AT.IsActive = 1 AND
	AST.IsActive = 1

PRINT 'Completed inserting records to #SnapshotGLAccountCategoryTranslationsOverhead:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

------------------------------------------------------------------------------------------------------
--Source and identify report grouping records
------------------------------------------------------------------------------------------------------

-- Source tax type
SET @StartTime = GETDATE()


CREATE TABLE #TaxType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	TaxTypeId INT NOT NULL,
	RegionId INT NOT NULL,
	FixedTaxTypeId INT NOT NULL,
	RateCalculationMethodId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL
)

INSERT INTO #TaxType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	TaxTypeId,
	RegionId,
	FixedTaxTypeId,
	RateCalculationMethodId,
	Name,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	MinorGlAccountCategoryId
)
SELECT 
	TaxType.*
FROM 
	TapasGlobalBudgeting.TaxType TaxType
	
	INNER JOIN #DistinctImports DI ON
		DI.ImportBatchId = TaxType.ImportBatchId
	
	
PRINT 'Completed inserting records into #TaxType:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_TaxType ON #TaxType (ImportBatchId, TaxTypeId)

PRINT 'Completed creating indexes on #TaxType'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


-- Source budget report group detail. 

SET @StartTime = GETDATE()

CREATE TABLE #BudgetReportGroupDetail(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetReportGroupDetailId INT NOT NULL,
	BudgetReportGroupId INT NOT NULL,
	RegionId INT NOT NULL,
	BudgetId INT NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)
INSERT INTO #BudgetReportGroupDetail(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetReportGroupDetailId,
	BudgetReportGroupId,
	RegionId,
	BudgetId,
	IsDeleted,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	brgd.*
FROM 
	TapasGlobalBudgeting.BudgetReportGroupDetail brgd

	INNER JOIN #BudgetsToProcess BTP ON
		BRGD.ImportBatchId = BTP.ImportBatchId AND
		BRGD.BudgetId = BTP.BudgetId
	
--select * from #BudgetReportGroupDetail
		
PRINT 'Completed inserting records into #BudgetReportGroupDetail:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source budget report group.
SET @StartTime = GETDATE()

CREATE TABLE #BudgetReportGroup(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetReportGroupId INT NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	BudgetExchangeRateId INT NOT NULL,
	IsReforecast BIT NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NOT NULL,
	FirstProjectedPeriod INT NULL,
	IsDeleted BIT NOT NULL,
	GRChangedDate DATETIME NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	BudgetReportGroupPeriodId INT NULL
)

INSERT INTO #BudgetReportGroup(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetReportGroupId,
	[Name],
	BudgetExchangeRateId,
	IsReforecast,
	StartPeriod,
	EndPeriod,
	FirstProjectedPeriod,
	IsDeleted,
	GRChangedDate,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	BudgetReportGroupPeriodId
)
SELECT 
	brg.* 
FROM 
	TapasGlobalBudgeting.BudgetReportGroup brg
	INNER JOIN #BudgetsToProcess BTP ON
		BRG.ImportBatchId = BTP.ImportBatchId
		
	INNER JOIN #NewBudgets B ON
		B.BudgetId = BTP.BudgetId AND
		B.ImportBatchId = BTP.ImportBatchId AND
		B.BudgetReportGroupId = BRG.BudgetReportGroupId
	
--select * from #BudgetReportGroup
	
PRINT 'Completed inserting records into #BudgetReportGroup:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source report group period mapping.
SET @StartTime = GETDATE()

CREATE TABLE #BudgetReportGroupPeriod(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetReportGroupPeriodId INT NOT NULL,
	BudgetExchangeRateId INT NOT NULL,
	[Year] INT NOT NULL,
	Period INT NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetReportGroupPeriod(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetReportGroupPeriodId,
	BudgetExchangeRateId,
	[Year],
	Period,
	IsDeleted,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	brgp.*
FROM    
	Gdm.BudgetReportGroupPeriod brgp -- THIS TABLE HAS NO SNAPSHOT
	

	INNER JOIN Gdm.BudgetReportGroupPeriodActive(@DataPriorToDate) brgpA ON
		brgp.ImportKey = brgpA.ImportKey
			
--select * from #BudgetReportGroupPeriod

PRINT 'Completed inserting records into #BudgetReportGroupPeriod:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source budget status
SET @StartTime = GETDATE()

CREATE TABLE #BudgetStatus(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetStatusId INT NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	[Description] VARCHAR(100) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)
INSERT INTO #BudgetStatus(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetStatusId,
	[Name],
	[Description],
	InsertedDate,
	UpdatedByStaffId
)
SELECT 
	BudgetStatus.* 
FROM
	TapasGlobalBudgeting.BudgetStatus BudgetStatus
	
	INNER JOIN #DistinctImports DI ON
		DI.ImportBatchId = BudgetStatus.ImportBatchId
	
	
PRINT 'Completed inserting records into #BudgetStatus:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

------------------------------------------------------------------------------------------------------
--Source associated records
------------------------------------------------------------------------------------------------------

-- Source budget project
SET @StartTime = GETDATE()

CREATE TABLE #BudgetProject(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetProjectId INT NOT NULL,
	BudgetId INT NOT NULL,
	ProjectId INT NULL,
	RegionId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	ActivityTypeId INT NOT NULL,
	Code VARCHAR(50) NULL,
	[Name] VARCHAR(100) NULL,
	CorporateDepartmentCode VARCHAR(6) NULL,
	CorporateSourceCode VARCHAR(2) NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NULL,
	IsReimbursable BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetProjectId INT NULL,
	IsTsCost BIT NOT NULL,
	CanAllocateOverheads BIT NOT NULL,
	AllocateOverheadsProjectId INT NULL,
	MarkUpPercentage DECIMAL(5, 4) NULL,
	ProjectOwnerStaffId INT NULL,
	AMBudgetProjectId INT NULL
)
INSERT INTO #BudgetProject(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetProjectId,
	BudgetId,
	ProjectId,
	RegionId,
	PropertyFundId,
	ActivityTypeId,
	Code,
	[Name],
	CorporateDepartmentCode,
	CorporateSourceCode,
	StartPeriod,
	EndPeriod,
	IsReimbursable,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetProjectId,
	IsTsCost,
	CanAllocateOverheads,
	AllocateOverheadsProjectId,
	MarkUpPercentage,
	ProjectOwnerStaffId,
	AMBudgetProjectId
)
SELECT 
	BudgetProject.*
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

-- Source region
SET @StartTime = GETDATE()

CREATE TABLE #Region(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	RegionId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	PayCode VARCHAR(5) NULL,
	EnrollmentTypeId INT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)
INSERT INTO #Region(
	ImportKey,
	ImportBatchId,
	ImportDate,
	RegionId,
	SourceCode,
	Code,
	[Name],
	PayCode,
	EnrollmentTypeId,
	InsertedDate,
	UpdatedDate
)
SELECT 
	SourceRegion.*
FROM 
	HR.Region SourceRegion
	INNER JOIN HR.RegionActive(@DataPriorToDate) SourceRegionA ON
		SourceRegion.ImportKey = SourceRegionA.ImportKey

PRINT 'Completed inserting records into #Region:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source Budget Employee
SET @StartTime = GETDATE()

CREATE TABLE #BudgetEmployee(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	BudgetId INT NOT NULL,
	HrEmployeeId INT NULL,
	PayGroupId INT NOT NULL,
	JobTitleId INT NOT NULL,
	LocationId INT NOT NULL,
	StateId INT NULL,
	OverheadRegionId INT NOT NULL,
	ApproverStaffId INT NULL,
	[Name] VARCHAR(255) NOT NULL,
	IsUnion BIT NOT NULL,
	RehirePeriod INT NOT NULL,
	RehireDate DATETIME NOT NULL,
	TerminatePeriod INT NULL,
	TerminateDate DATETIME NULL,
	EmployeeHistoryEffectivePeriod INT NOT NULL,
	EmployeeHistoryEffectiveDate DATETIME NOT NULL,
	EmployeePayrollEffectiveDate DATETIME NULL,
	CurrentAnnualSalary DECIMAL(18, 2) NULL,
	PreviousYearSalary DECIMAL(18, 2) NULL,
	SalaryYear INT NOT NULL,
	PreviousYearBonus DECIMAL(18, 2) NULL,
	BonusYear INT NULL,
	IsActualEmployee BIT NOT NULL,
	IsReviewed BIT NOT NULL,
	IsPartTime BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetEmployeeId INT NULL
)
INSERT INTO #BudgetEmployee(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeeId,
	BudgetId,
	HrEmployeeId,
	PayGroupId,
	JobTitleId,
	LocationId,
	StateId,
	OverheadRegionId ,
	ApproverStaffId,
	[Name],
	IsUnion,
	RehirePeriod,
	RehireDate,
	TerminatePeriod,
	TerminateDate,
	EmployeeHistoryEffectivePeriod,
	EmployeeHistoryEffectiveDate,
	EmployeePayrollEffectiveDate,
	CurrentAnnualSalary,
	PreviousYearSalary,
	SalaryYear,
	PreviousYearBonus,
	BonusYear,
	IsActualEmployee,
	IsReviewed,
	IsPartTime,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetEmployeeId
)
SELECT 
	BudgetEmployee.* 
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

-- Source Budget Employee Functional Department
SET @StartTime = GETDATE()

CREATE TABLE #BudgetEmployeeFunctionalDepartment(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeeFunctionalDepartmentId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	SubDepartmentId INT NOT NULL,
	EffectivePeriod INT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL
)

INSERT INTO #BudgetEmployeeFunctionalDepartment(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeeFunctionalDepartmentId,
	BudgetEmployeeId,
	SubDepartmentId,
	EffectivePeriod,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	FunctionalDepartmentId
)
SELECT 
	efd.* 
FROM 
	TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment efd
	
	INNER JOIN #DistinctImports DI ON
		EFD.ImportBatchId = DI.ImportBatchId
	
	-- data limiting join
	INNER JOIN #BudgetEmployee be ON
		efd.BudgetEmployeeId = be.BudgetEmployeeId

PRINT 'Completed inserting records into #BudgetEmployeeFunctionalDepartment:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

CREATE CLUSTERED INDEX IX_BudgetEmployeeId ON #BudgetEmployeeFunctionalDepartment (ImportBatchId, BudgetEmployeeId)
CREATE INDEX IX_BudgetEmployeeFunctionalDepartment2 ON #BudgetEmployeeFunctionalDepartment (ImportBatchId, BudgetEmployeeId, EffectivePeriod)


PRINT 'Completed creating indexes on #BudgetEmployeeFunctionalDepartment'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


-- FunctionalDepartment --------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #SnapshotFunctionalDepartment (
    SnapshotId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	Code VARCHAR(20) NULL,
	GlobalCode VARCHAR(30) NULL
)

INSERT INTO #SnapshotFunctionalDepartment
SELECT
    DS.SnapshotId,
	FunctionalDepartmentId,
	Code,
	GlobalCode
FROM
	Gdm.SnapshotFunctionalDepartment FD
	INNER JOIN #DistinctSnapshots DS ON
		FD.SnapshotId = DS.SnapshotId
WHERE
	FD.IsActive = 1

PRINT ('Rows inserted into #FunctionalDepartment: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


-- Source Property Fund
SET @StartTime = GETDATE()

CREATE TABLE #SnapshotPropertyFund(
--	ImportKey INT NOT NULL,
--	ImportBatchId INT NOT NULL,
--	ImportDate DATETIME NOT NULL,
	SnapshotId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	RelatedFundId INT NULL,
	EntityTypeId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	BudgetOwnerStaffId INT NOT NULL,
	RegionalOwnerStaffId INT NOT NULL,
	DefaultGLTranslationSubTypeId INT NULL,
	Name VARCHAR(100) NOT NULL,
	IsReportingEntity BIT NOT NULL,
	IsPropertyFund BIT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
--	SnapshotId INT NOT NULL
)

INSERT INTO #SnapshotPropertyFund(
	--ImportKey,
	--ImportBatchId,
	--ImportDate,
	SnapshotId,
	PropertyFundId,
	RelatedFundId,
	EntityTypeId,
	AllocationSubRegionGlobalRegionId,
	BudgetOwnerStaffId,
	RegionalOwnerStaffId,
	DefaultGLTranslationSubTypeId,
	Name,
	IsReportingEntity,
	IsPropertyFund,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
	--SnapshotId
)
SELECT 
	DS.SnapshotId,
	PropertyFund.PropertyFundId,
	PropertyFund.RelatedFundId,
	PropertyFund.EntityTypeId,
	PropertyFund.AllocationSubRegionGlobalRegionId,
	PropertyFund.BudgetOwnerStaffId,
	PropertyFund.RegionalOwnerStaffId,
	PropertyFund.DefaultGLTranslationSubTypeId,
	PropertyFund.Name,
	PropertyFund.IsReportingEntity,
	PropertyFund.IsPropertyFund,
	PropertyFund.IsActive,
	PropertyFund.InsertedDate,
	PropertyFund.UpdatedDate,
	PropertyFund.UpdatedByStaffId
	--PropertyFund.SnapshotId as SnapshotId
FROM 
	Gdm.SnapshotPropertyFund PropertyFund
	INNER JOIN #DistinctSnapshots DS ON
		DS.SnapShotId = PropertyFund.SnapshotId
	
	--INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PropertyFundA ON
	--	PropertyFund.ImportKey = PropertyFundA.ImportKey 

PRINT 'Completed inserting records into #SnapshotPropertyFund:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_PropertyFundId ON #SnapshotPropertyFund (SnapshotId, PropertyFundId)

PRINT 'Completed creating indexes on #SnapshotPropertyFund'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source Property Fund Mapping
SET @StartTime = GETDATE()

CREATE TABLE #SnapshotPropertyFundMapping(
	--ImportKey INT NOT NULL,
	--ImportBatchId INT NOT NULL,
	--ImportDate DATETIME NOT NULL,
	SnapshotId INT NOT NULL,
	PropertyFundMappingId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	PropertyFundCode VARCHAR(8) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL,
	ActivityTypeId INT NULL
)

INSERT INTO #SnapshotPropertyFundMapping(
	--ImportKey,
	--ImportBatchId,
	--ImportDate,
	SnapshotId,
	PropertyFundMappingId,
	PropertyFundId,
	SourceCode,
	PropertyFundCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted,
	ActivityTypeId
)
SELECT 
	DS.SnapshotId,
	PropertyFundMapping.PropertyFundMappingId,
	PropertyFundMapping.PropertyFundId,
	PropertyFundMapping.SourceCode,
	PropertyFundMapping.PropertyFundCode,
	PropertyFundMapping.InsertedDate,
	PropertyFundMapping.UpdatedDate,
	PropertyFundMapping.IsDeleted,
	PropertyFundMapping.ActivityTypeId
FROM 
	Gdm.SnapshotPropertyFundMapping PropertyFundMapping
	INNER JOIN #DistinctSnapshots DS ON
		DS.SnapShotId = PropertyFundMapping.SnapshotId
	
PRINT 'Completed inserting records into #PropertyFundMapping:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_PropertyFundId ON #SnapshotPropertyFundMapping (SnapshotId, PropertyFundCode, SourceCode, IsDeleted, ActivityTypeId)
CREATE INDEX IX_PropertyFundMapping2 ON #SnapshotPropertyFundMapping (PropertyFundId) -- create as a seperate index as this is how its used.

 -- remove property fund id PropertyFundId,

PRINT 'Completed creating indexes on #PropertyFundMapping'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source ReportingEntityCorporateDepartment
SET @StartTime = GETDATE()

CREATE TABLE #SnapshotReportingEntityCorporateDepartment( -- GDM 2.0 addition
	--ImportKey INT NOT NULL,
	SnapshotId INT NOT NULL,
	ReportingEntityCorporateDepartmentId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	CorporateDepartmentCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsDeleted BIT NOT NULL,
)

INSERT INTO	#SnapshotReportingEntityCorporateDepartment(
	--ImportKey,
	SnapshotId,
	ReportingEntityCorporateDepartmentId,
	PropertyFundId,
	SourceCode,
	CorporateDepartmentCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsDeleted
)
SELECT
	--RECD.ImportKey,
	DS.SnapshotId,
	RECD.ReportingEntityCorporateDepartmentId,
	RECD.PropertyFundId,
	RECD.SourceCode,
	RECD.CorporateDepartmentCode,
	RECD.InsertedDate,
	RECD.UpdatedDate,
	RECD.UpdatedByStaffId,
	RECD.IsDeleted
FROM
	Gdm.SnapshotReportingEntityCorporateDepartment RECD
	INNER JOIN #DistinctSnapshots DS ON
		DS.SnapShotId = RECD.SnapshotId
		
PRINT 'Completed inserting records into #SnapshotReportingEntityCorporateDepartment:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()


CREATE CLUSTERED INDEX IX_SnapshotReportingEntityCorporateDepartment1 ON #SnapshotReportingEntityCorporateDepartment 
	(CorporateDepartmentCode, SourceCode, IsDeleted, SnapshotId)


PRINT 'Completed creating indexes on #SnapshotReportingEntityCorporateDepartment'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source ReportingEntityPropertyEntity
SET @StartTime = GETDATE()

CREATE TABLE #SnapshotReportingEntityPropertyEntity( -- GDM 2.0 addition
	--ImportKey INT NOT NULL,
	SnapshotId INT NOT NULL,
	ReportingEntityPropertyEntityId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	PropertyEntityCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsDeleted BIT NOT NULL
)

INSERT INTO #SnapshotReportingEntityPropertyEntity(
	--ImportKey,
	SnapshotId,
	ReportingEntityPropertyEntityId,
	PropertyFundId,
	SourceCode,
	PropertyEntityCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsDeleted
)
SELECT
	--REPE.ImportKey,
	DS.SnapshotId,
	REPE.ReportingEntityPropertyEntityId,
	REPE.PropertyFundId,
	REPE.SourceCode,
	REPE.PropertyEntityCode,
	REPE.InsertedDate,
	REPE.UpdatedDate,
	REPE.UpdatedByStaffId,
	REPE.IsDeleted
FROM
	Gdm.SnapshotReportingEntityPropertyEntity REPE
	INNER JOIN #DistinctSnapshots DS ON
		DS.SnapShotId = REPE.SnapshotId
	
PRINT 'Completed inserting records into #SnapshotReportingEntityPropertyEntity:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_SnapshotReportingEntityPropertyEntity1 ON #SnapshotReportingEntityPropertyEntity (PropertyEntityCode, SourceCode, IsDeleted, SnapshotId)

PRINT 'Completed creating indexes on #SnapshotReportingEntityPropertyEntity'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source ConsolidationRegionCorporateDepartment

SET @StartTime = GETDATE()

CREATE TABLE #SnapshotConsolidationRegionCorporateDepartment( -- CC 16
	--ImportKey INT NOT NULL,
	SnapshotId INT NOT NULL,
	ConsolidationRegionCorporateDepartmentId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	CorporateDepartmentCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO	#SnapshotConsolidationRegionCorporateDepartment(
	--ImportKey,
	SnapshotId,
	ConsolidationRegionCorporateDepartmentId,
	GlobalRegionId,
	SourceCode,
	CorporateDepartmentCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	--RECD.ImportKey,
	DS.SnapshotId,
	CRCD.ConsolidationRegionCorporateDepartmentId,
	CRCD.GlobalRegionId,
	CRCD.SourceCode,
	CRCD.CorporateDepartmentCode,
	CRCD.InsertedDate,
	CRCD.UpdatedDate,
	CRCD.UpdatedByStaffId
FROM
	Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD
	INNER JOIN #DistinctSnapshots DS ON
		DS.SnapShotId = CRCD.SnapshotId
		
PRINT 'Completed inserting records into #SnapshotConsolidationRegionCorporateDepartment:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()


CREATE CLUSTERED INDEX IX_SnapshotConsolidationRegionCorporateDepartment1 ON #SnapshotConsolidationRegionCorporateDepartment 
	(CorporateDepartmentCode, SourceCode, SnapshotId)


PRINT 'Completed creating indexes on #SnapshotConsolidationRegionCorporateDepartment'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source ConsolidationRegionPropertyEntity
SET @StartTime = GETDATE()

CREATE TABLE #SnapshotConsolidationRegionPropertyEntity( -- GDM 2.0 addition
	--ImportKey INT NOT NULL,
	SnapshotId INT NOT NULL,
	ConsolidationRegionPropertyEntityId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	PropertyEntityCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #SnapshotConsolidationRegionPropertyEntity(
	--ImportKey,
	SnapshotId,
	ConsolidationRegionPropertyEntityId,
	GlobalRegionId,
	SourceCode,
	PropertyEntityCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	--REPE.ImportKey,
	DS.SnapshotId,
	CRPE.ConsolidationRegionPropertyEntityId,
	CRPE.GlobalRegionId,
	CRPE.SourceCode,
	CRPE.PropertyEntityCode,
	CRPE.InsertedDate,
	CRPE.UpdatedDate,
	CRPE.UpdatedByStaffId
FROM
	Gdm.SnapshotConsolidationRegionPropertyEntity CRPE
	INNER JOIN #DistinctSnapshots DS ON
		DS.SnapShotId = CRPE.SnapshotId
	
PRINT 'Completed inserting records into #SnapshotConsolidationRegionPropertyEntity:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_SnapshotConsolidationRegionPropertyEntity1 ON #SnapshotConsolidationRegionPropertyEntity (PropertyEntityCode, SourceCode, SnapshotId)

PRINT 'Completed creating indexes on #SnapshotConsolidationRegionPropertyEntity'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source Location
SET @StartTime = GETDATE()

CREATE TABLE #Location(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	LocationId INT NOT NULL,
	ExternalSubRegionId INT NOT NULL,
	StateId INT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

INSERT INTO #Location(
	ImportKey,
	ImportBatchId,
	ImportDate,
	LocationId,
	ExternalSubRegionId,
	StateId,
	Code,
	Name,
	IsActive,
	InsertedDate,
	UpdatedDate
)
SELECT 
	Location.* 
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

-- Source region extended
SET @StartTime = GETDATE()

CREATE TABLE #RegionExtended(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	RegionId INT NOT NULL,
	RegionalAdministratorId INT NOT NULL,
	CountryId INT NOT NULL,
	HasEmployees BIT NOT NULL,
	CanChargeMarkupOnProject BIT NOT NULL,
	CanChargeMarkupOnPayrollOverhead BIT NOT NULL,
	CanUploadOverheadJournal BIT NOT NULL,
	ProjectRef VARCHAR(8) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OverheadFunctionalDepartmentId INT NOT NULL,
	CanRegionBillInArrears BIT NOT NULL
)

INSERT INTO #RegionExtended(
	ImportKey,
	ImportBatchId,
	ImportDate,
	RegionId,
	RegionalAdministratorId,
	CountryId,
	HasEmployees,
	CanChargeMarkupOnProject,
	CanChargeMarkupOnPayrollOverhead,
	CanUploadOverheadJournal,
	ProjectRef,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OverheadFunctionalDepartmentId,
	CanRegionBillInArrears
)
SELECT 
	RegionExtended.*
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


-- Source Payroll Originating Region
SET @StartTime = GETDATE()

CREATE TABLE #PayrollRegion(
	ImportKey INT NOT NULL,
	PayrollRegionId INT NOT NULL,
	RegionId INT NOT NULL,
	ExternalSubRegionId INT NOT NULL,
	CorporateEntityRef VARCHAR(6) NOT NULL,
	CorporateSourceCode VARCHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #PayrollRegion(
	ImportKey,
	PayrollRegionId,
	RegionId,
	ExternalSubRegionId,
	CorporateEntityRef,
	CorporateSourceCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT 
	PayrollRegion.*
FROM 
	TapasGlobal.PayrollRegion PayrollRegion
	INNER JOIN TapasGlobal.PayrollRegionActive(@DataPriorToDate) PayrollRegionA ON
		PayrollRegion.ImportKey = PayrollRegionA.ImportKey
	
PRINT 'Completed inserting records into #PayrollRegion:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_PayrollRegionId ON #PayrollRegion (PayrollRegionId)

PRINT 'Completed creating indexes on #PayrollRegion'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source Overhead Originating Region
SET @StartTime = GETDATE()

CREATE TABLE #OverheadRegion(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	OverheadRegionId INT NOT NULL,
	RegionId INT NOT NULL,
	CorporateEntityRef VARCHAR(6) NULL,
	CorporateSourceCode VARCHAR(2) NULL,
	Name VARCHAR(50) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #OverheadRegion(
	ImportKey,
	ImportBatchId,
	ImportDate,
	OverheadRegionId,
	RegionId,
	CorporateEntityRef,
	CorporateSourceCode,
	Name,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)

SELECT 
	OverheadRegion.*
FROM 
	TapasGlobal.OverheadRegion OverheadRegion
	INNER JOIN TapasGlobal.OverheadRegionActive(@DataPriorToDate) OverheadRegionA ON
		OverheadRegion.ImportKey = OverheadRegionA.ImportKey
	
PRINT 'Completed inserting records into #OverheadRegion:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_OverheadRegionId ON #OverheadRegion (OverheadRegionId)

PRINT 'Completed creating indexes on #OverheadRegion'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source project
SET @StartTime = GETDATE()

CREATE TABLE #Project(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	ProjectId INT NOT NULL,
	RegionId INT NOT NULL,
	ActivityTypeId INT NOT NULL,
	ProjectOwnerId INT NULL,
	CorporateDepartmentCode VARCHAR(8) NOT NULL,
	CorporateSourceCode CHAR(2) NOT NULL,
	Code VARCHAR(50) NOT NULL,
	Name VARCHAR(100) NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	PropertyOverheadGLAccountCode VARCHAR(15) NULL,
	PropertyOverheadDepartmentCode VARCHAR(6) NULL,
	PropertyOverheadJobCode VARCHAR(15) NULL,
	PropertyOverheadSourceCode CHAR(2) NULL,
	CorporateUnionPayrollIncomeCategoryCode VARCHAR(6) NULL,
	CorporateNonUnionPayrollIncomeCategoryCode VARCHAR(6) NULL,
	CorporateOverheadIncomeCategoryCode VARCHAR(6) NULL,
	PropertyFundId INT NOT NULL,
	MarkUpPercentage DECIMAL(5, 4) NULL,
	HistoricalProjectCode VARCHAR(50) NULL,
	IsTSCost BIT NOT NULL,
	CanAllocateOverheads BIT NOT NULL,
	AllocateOverheadsProjectId INT NULL
)

INSERT INTO #Project(
	ImportKey,
	ImportBatchId,
	ImportDate,
	ProjectId,
	RegionId,
	ActivityTypeId,
	ProjectOwnerId,
	CorporateDepartmentCode,
	CorporateSourceCode,
	Code,
	Name,
	StartPeriod,
	EndPeriod,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	PropertyOverheadGLAccountCode,
	PropertyOverheadDepartmentCode,
	PropertyOverheadJobCode,
	PropertyOverheadSourceCode,
	CorporateUnionPayrollIncomeCategoryCode,
	CorporateNonUnionPayrollIncomeCategoryCode,
	CorporateOverheadIncomeCategoryCode,
	PropertyFundId,
	MarkUpPercentage,
	HistoricalProjectCode,
	IsTSCost,
	CanAllocateOverheads,
	AllocateOverheadsProjectId
)
SELECT 
	Project.*
FROM 
	TapasGlobal.Project Project
	INNER JOIN TapasGlobal.ProjectActive(@DataPriorToDate) ProjectA ON
		Project.ImportKey = ProjectA.ImportKey 

PRINT 'Completed inserting records into #Project:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_ProjectId ON #Project (ProjectId)

PRINT 'Completed creating indexes on #Project'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- #Department
SET @StartTime = GETDATE()


-- #OriginatingRegionPropertyDepartment

CREATE TABLE #SnapshotOriginatingRegionPropertyDepartment( -- GDM 2.0 addition
	--ImportKey INT NOT NULL,
	SnapshotId INT NOT NULL,
	OriginatingRegionPropertyDepartmentId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	PropertyDepartmentCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL	
)


------------------------------------------------------------------------------------------------------
-- Additional required mappings
------------------------------------------------------------------------------------------------------

-- #OriginatingRegionCorporateEntity
SET @StartTime = GETDATE()

CREATE TABLE #SnapshotOriginatingRegionCorporateEntity( -- GDM 2.0 addition
--	ImportKey INT NOT NULL,
	SnapshotId INT NOT NULL,
	OriginatingRegionCorporateEntityId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	CorporateEntityCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL	
)

INSERT INTO #SnapshotOriginatingRegionCorporateEntity(
	--ImportKey,
	SnapshotId,
	OriginatingRegionCorporateEntityId,
	GlobalRegionId,
	CorporateEntityCode,
	SourceCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted
)
SELECT
--	ORCE.ImportKey,
	DS.SnapshotId,
	ORCE.OriginatingRegionCorporateEntityId,
	ORCE.GlobalRegionId,
	ORCE.CorporateEntityCode,
	ORCE.SourceCode,
	ORCE.InsertedDate,
	ORCE.UpdatedDate,
	ORCE.IsDeleted	
FROM
	Gdm.SnapshotOriginatingRegionCorporateEntity ORCE
	INNER JOIN #DistinctSnapshots DS ON
		DS.SnapShotId = ORCE.SnapshotId

PRINT 'Completed inserting into #OriginatingRegionCorporateEntity'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #SnapshotOriginatingRegionCorporateEntity (SnapshotId, CorporateEntityCode, 
	SourceCode, IsDeleted) -- remove GlobalRegionId

PRINT 'Completed creating indexes on #OriginatingRegionCorporateEntity'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()


INSERT INTO #SnapshotOriginatingRegionPropertyDepartment(
	--ImportKey,
	SnapshotId,
	OriginatingRegionPropertyDepartmentId,
	GlobalRegionId,
	PropertyDepartmentCode,
	SourceCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted
)
SELECT
	--ORPD.ImportKey,
	DS.SnapshotId,
	ORPD.OriginatingRegionPropertyDepartmentId,
	ORPD.GlobalRegionId,
	ORPD.PropertyDepartmentCode,
	ORPD.SourceCode,
	ORPD.InsertedDate,
	ORPD.UpdatedDate,
	ORPD.IsDeleted
FROM
	Gdm.SnapshotOriginatingRegionPropertyDepartment ORPD
	INNER JOIN #DistinctSnapshots DS ON
		DS.SnapShotId = ORPD.SnapshotId

PRINT 'Completed inserting records into #SnapshotOriginatingRegionPropertyDepartment:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()
	
CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #SnapshotOriginatingRegionPropertyDepartment (SnapshotId, PropertyDepartmentCode, 
	SourceCode, IsDeleted) --, GlobalRegionId) -- not needed?

PRINT 'Completed Creating Indexes on #SnapshotOriginatingRegionPropertyDepartment'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


SET @StartTime = GETDATE()

-- #Department


CREATE TABLE #Department(
	[ImportKey] [int] NOT NULL,
	[Department] [char](8) NOT NULL,
	[Description] [varchar](50) NULL,
	[LastDate] [datetime] NULL,
	[MRIUserID] [char](20) NULL,
	[Source] [char](2) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[FunctionalDepartmentId] [int] NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsTsCost] [bit] NOT NULL
)


INSERT INTO	#Department 
(ImportKey, Department,Description,LastDate,MRIUserID,Source,IsActive,FunctionalDepartmentId,UpdatedDate,IsTsCost)
SELECT
	Dept.ImportKey, Dept.Department, Dept.Description, Dept.LastDate, Dept.MRIUserID, Dept.Source,
	Dept.IsActive, Dept.FunctionalDepartmentId, Dept.UpdatedDate, Dept.IsTsCost
FROM
	Gacs.Department Dept
	
	INNER JOIN Gacs.DepartmentActive(@DataPriorToDate) DeptA ON
		DeptA.ImportKey = Dept.ImportKey
	

PRINT 'Completed inserting records into #Department:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
	
SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_Department ON #Department (Department, [Source])

PRINT 'Completed creating indexes on #Department'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
	
		
------------------------------------------------------------------------------------------------------
--Source allocation records
------------------------------------------------------------------------------------------------------

-- Source payroll allocation
SET @StartTime = GETDATE()

CREATE TABLE #BudgetEmployeePayrollAllocation(
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
	OriginalBudgetEmployeePayrollAllocationId INT NULL
)

INSERT INTO #BudgetEmployeePayrollAllocation(
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
	OriginalBudgetEmployeePayrollAllocationId
)
SELECT
	Allocation.*
FROM
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocation Allocation

	INNER JOIN #DistinctImports DI ON
		Allocation.ImportBatchId = DI.ImportBatchId

	--data limiting join
	INNER JOIN #BudgetProject BP ON
		Allocation.BudgetProjectId = bp.BudgetProjectId 
		


PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocation:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE UNIQUE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationId ON #BudgetEmployeePayrollAllocation (ImportBatchId, BudgetEmployeePayrollAllocationId)


PRINT 'Completed creating indexes on #BudgetEmployeePayrollAllocation'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source payroll tax detail
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Using the 'active' function here cause serious performance issues and the only way around it, was to extract the logic from the is active function 
--to seperate peaces of code.
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
SET @StartTime = GETDATE()

CREATE TABLE #BudgetEmployeePayrollAllocationDetailBatches(
	BudgetEmployeePayrollAllocationDetailId int NOT NULL,
	ImportBatchId INT NOT NULL
)

INSERT INTO #BudgetEmployeePayrollAllocationDetailBatches(
	BudgetEmployeePayrollAllocationDetailId,
	ImportBatchId
)
SELECT
	B2.BudgetEmployeePayrollAllocationDetailId,
	MAX(B2.ImportBatchId) AS ImportBatchId
FROM 
	[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B2
	
	INNER JOIN #DistinctImports DI ON
		DI.ImportBatchId = B2.ImportBatchId

GROUP BY
	B2.BudgetEmployeePayrollAllocationDetailId		
		
/*WHERE	
	batch.BatchEndDate IS NOT NULL AND
	batch.PackageName = 'ETL.Staging.TapasGlobalBudgeting' AND
	batch.ImportEndDate <= @DataPriorToDate		
GROUP BY
	B2.BudgetEmployeePayrollAllocationDetailId*/

PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocationDetailBatches:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE UNIQUE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationDetailBatches ON #BudgetEmployeePayrollAllocationDetailBatches (ImportBatchId, BudgetEmployeePayrollAllocationDetailId)

PRINT 'Completed creating indexes IX_BudgetEmployeePayrollAllocationDetailBatches:'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE TABLE #BEPADa(
	ImportKey INT NOT NULL
)

INSERT INTO #BEPADa(
	ImportKey
)
SELECT
	MAX(B1.ImportKey) ImportKey
FROM
	(
		SELECT
			ImportKey,
			ImportBatchId,
			BudgetEmployeePayrollAllocationDetailId
		FROM
			[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail]
		WHERE
			ImportBatchId = (SELECT TOP 1 ImportBatchId FROM #BudgetsToProcess) -- This needs to be revised
	) B1

	INNER JOIN #BudgetEmployeePayrollAllocationDetailBatches t1 ON 
		t1.ImportBatchId = B1.ImportBatchId AND
		t1.BudgetEmployeePayrollAllocationDetailId = B1.BudgetEmployeePayrollAllocationDetailId
GROUP BY
	B1.BudgetEmployeePayrollAllocationDetailId

PRINT 'Completed inserting records into #BEPADa:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE INDEX IX_BEPADa1 ON #BEPADa (ImportKey)

PRINT 'Completed creating indexes on #Budget'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))



-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
SET @StartTime = GETDATE()

CREATE TABLE #BudgetEmployeePayrollAllocationDetail(
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
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetEmployeePayrollAllocationDetail(
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
	UpdatedByStaffId
)
SELECT
	TaxDetail.*
FROM
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocationDetail TaxDetail
	
	/*
	INNER JOIN #DistinctImports DI ON
		DI.ImportBatchId = TaxDetail.ImportBatchId*/
	
    --data limiting join
	INNER JOIN #BudgetEmployeePayrollAllocation Allocation ON
		Allocation.ImportBatchId = TaxDetail.ImportBatchId AND
		Allocation.BudgetEmployeePayrollAllocationId = TaxDetail.BudgetEmployeePayrollAllocationId
		
	INNER JOIN #BEPADa TaxDetailA ON
		TaxDetail.ImportKey = TaxDetailA.ImportKey
		

PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocationDetail:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE UNIQUE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationDetailId ON #BudgetEmployeePayrollAllocationDetail (ImportBatchId, BudgetEmployeePayrollAllocationDetailId)

PRINT 'Completed creating indexes on #BudgetEmployeePayrollAllocationDetail'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source budget tax type
SET @StartTime = GETDATE()

CREATE TABLE #BudgetTaxType(
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

INSERT INTO #BudgetTaxType(
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
	BudgetTaxType.* 
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


SET @StartTime = GETDATE()

-- Source payroll allocation Tax detail
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
	UpdatedByStaffId INT NOT NULL
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
	UpdatedByStaffId
)
SELECT
	TaxDetail.ImportKey,
	TaxDetail.BudgetEmployeePayrollAllocationDetailId,
	TaxDetail.BudgetEmployeePayrollAllocationId,
	CASE WHEN (TaxDetail.BenefitOptionId IS NOT NULL) THEN @BenefitsMinorGlAccountCategoryId ELSE TaxType.MinorGlAccountCategoryId END AS MinorGlAccountCategoryId,
	TaxDetail.BudgetTaxTypeId,
	TaxDetail.SalaryAmount,
	TaxDetail.BonusAmount,
	TaxDetail.ProfitShareAmount,
	TaxDetail.BonusCapExcessAmount,
	TaxDetail.InsertedDate,
	TaxDetail.UpdatedDate,
	TaxDetail.UpdatedByStaffId
FROM

	-- Joining on allocation to limit amount of data
	#BudgetEmployeePayrollAllocation Allocation


	INNER JOIN #BudgetEmployeePayrollAllocationDetail TaxDetail ON
		Allocation.BudgetEmployeePayrollAllocationId = TaxDetail.BudgetEmployeePayrollAllocationId  AND
		Allocation.ImportBatchId = TaxDetail.ImportBatchId
			
	LEFT OUTER JOIN #BudgetTaxType BudgetTaxType ON
		TaxDetail.BudgetTaxTypeId = BudgetTaxType.BudgetTaxTypeId AND
		BudgetTaxType.ImportBatchId = Allocation.ImportBatchId
				
	LEFT OUTER JOIN #TaxType TaxType ON
		BudgetTaxType.TaxTypeId = TaxType.TaxTypeId	AND
		BudgetTaxType.ImportBatchId = TaxType.ImportBatchId
			
PRINT 'Completed inserting records into #EmployeePayrollAllocationDetail:'+CONVERT(char(10),@@rowcount)

PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #EmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationDetailId,  BudgetEmployeePayrollAllocationId)
CREATE INDEX IX_EmployeePayrollAllocationDetail2 ON #EmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationId)


PRINT 'Completed creating indexes on #EmployeePayrollAllocationDetail'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

--*/
-- Source payroll overhead allocation

SET @StartTime = GETDATE()

CREATE TABLE #BudgetOverheadAllocation(
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
	OriginalBudgetOverheadAllocationId INT NULL
)

INSERT INTO #BudgetOverheadAllocation(
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
	OriginalBudgetOverheadAllocationId
)
SELECT
	OverheadAllocation.*
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

-- Source overhead allocation detail
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
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetOverheadAllocationDetail(
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
	UpdatedByStaffId
)
SELECT 
	OverheadDetail.*
FROM			
	TapasGlobalBudgeting.BudgetOverheadAllocationDetail OverheadDetail
	
	INNER JOIN #DistinctImports DI ON
		OverheadDetail.ImportBatchId = DI.ImportBatchId
	
	-- data limiting join
	INNER JOIN #BudgetProject B ON
		OverheadDetail.BudgetProjectId = b.BudgetProjectId

PRINT 'Completed inserting records into #BudgetOverheadAllocationDetail:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
CREATE INDEX IX_BudgetOverheadAllocationDetail2 ON #BudgetOverheadAllocationDetail (BudgetOverheadAllocationId)


PRINT 'Completed creating indexes on #BudgetOverheadAllocationDetail'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source payroll overhead allocation detail
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
	UpdatedByStaffId INT NOT NULL
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
	UpdatedByStaffId
)
SELECT
	OverheadDetail.ImportKey,
	OverheadDetail.BudgetOverheadAllocationDetailId,
	OverheadDetail.BudgetOverheadAllocationId,
	OverheadDetail.BudgetProjectId,
	@OverheadMinorGlAccountCategoryId AS MinorGlAccountCategoryId,
	OverheadDetail.AllocationValue,
	OverheadDetail.AllocationAmount,
	OverheadDetail.InsertedDate,
	OverheadDetail.UpdatedDate,
	OverheadDetail.UpdatedByStaffId
FROM

	-- Joining on allocation to limit amount of data
	#BudgetOverheadAllocation OverheadAllocation
	
	INNER JOIN #BudgetOverheadAllocationDetail OverheadDetail ON
		OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId 

PRINT 'Completed inserting records into #OverheadAllocationDetail:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_Clustered ON #OverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
CREATE INDEX IX_OverheadAllocationDetail2 ON #OverheadAllocationDetail (BudgetOverheadAllocationId)

PRINT 'Completed creating indexes on #OverheadAllocationDetail'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Map Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

--Calculate effective functional department
SET @StartTime = GETDATE()

CREATE TABLE #EffectiveFunctionalDepartment(
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL
)

INSERT INTO #EffectiveFunctionalDepartment(
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
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


SET @StartTime = GETDATE()

CREATE INDEX IX_EffectiveFunctionalDepartment_AllocId ON #EffectiveFunctionalDepartment (BudgetEmployeePayrollAllocationId)

PRINT 'Completed creating indexes on #EffectiveFunctionalDepartment'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


SET @StartTime = GETDATE()

--Map Pre Tax Amounts
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
	BudgetReportGroupPeriod INT NOT NULL
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
	BudgetReportGroupPeriod
)
SELECT 
	Budget.ImportBatchId,
	Budget.BudgetId AS BudgetId,
	Budget.RegionId AS BudgetRegionId,
	Budget.FirstProjectedPeriod,
	ISNULL(BudgetProject.ProjectId,0) AS ProjectId,
	ISNULL(BudgetEmployee.HrEmployeeId,0) AS HrEmployeeId,
	Allocation.BudgetEmployeePayrollAllocationId,
	'TGB:BudgetId=' + CONVERT(varchar,Budget.BudgetId) + '&ProjectId=' + CONVERT(varchar,ISNULL(BudgetProject.ProjectId,0)) + '&HrEmployeeId=' + CONVERT(varchar,ISNULL(BudgetEmployee.HrEmployeeId,0)) + '&BudgetEmployeePayrollAllocationId=' + CONVERT(varchar,Allocation.BudgetEmployeePayrollAllocationId) + '&BudgetEmployeePayrollAllocationDetailId=0&BudgetOverheadAllocationDetailId=0' + '&ImportKey=' + CONVERT(varchar, Allocation.ImportKey) AS ReferenceCode,
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
	ISNULL(CASE
				WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.PropertyFundId
				ELSE
					DepartmentPropertyFund.PropertyFundId 
			END, -1) AS PropertyFundId,
	-- Same case logic AS above
	
	ISNULL(CASE -- Same case logic as above
				WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,
			
	ISNULL(CASE -- (CC16)
				-- Use the allocation region if there is no CorporateDepartmentCode, unless its not a Consolidation Region, then it will be null
				WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ConsolidationSubRegion.ConsolidationSubRegionGlobalRegionId
				ELSE
					CASE WHEN (GrSc.IsProperty = 'YES') THEN 
						CRPE.GlobalRegionId
					ELSE 
						CRCD.GlobalRegionId
					END
			END, -1) AS ConsolidationSubRegionGlobalRegionId,
			
	OriginatingRegion.CorporateEntityRef,
	OriginatingRegion.CorporateSourceCode,
	Budget.CurrencyCode AS LocalCurrencyCode,
	Allocation.UpdatedDate,
	Budget.BudgetReportGroupPeriod
FROM
	#BudgetEmployeePayrollAllocation Allocation

	INNER JOIN #BudgetProject BudgetProject ON 
		Allocation.BudgetProjectId = BudgetProject.BudgetProjectId
			
	--INNER JOIN  #FilteredModifiedReportBudget fmrb ON
		--BudgetProject.BudgetId = fmrb.BudgetId
			
	INNER JOIN #NewBudgets Budget ON 
		BudgetProject.BudgetId = Budget.BudgetId 
		
	LEFT OUTER JOIN #Region SourceRegion ON 
		Budget.RegionId = SourceRegion.RegionId 
		

	LEFT OUTER JOIN #EffectiveFunctionalDepartment efd ON
		Allocation.BudgetEmployeePayrollAllocationId = efd.BudgetEmployeePayrollAllocationId

	LEFT OUTER JOIN #SnapshotFunctionalDepartment fd ON 
		efd.FunctionalDepartmentId = fd.FunctionalDepartmentId and
		fd.SnapshotId = Budget.SnapshotId

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON 
		GrSc.SourceCode = BudgetProject.CorporateSourceCode 

	LEFT OUTER JOIN #SnapshotPropertyFundMapping pfm ON
		BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		BudgetProject.CorporateSourceCode = pfm.SourceCode AND
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
		Budget.BudgetReportGroupPeriod < 201007 AND
		Budget.SnapshotId = pfm.SnapshotId
	
	LEFT OUTER JOIN	#SnapshotReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		RECD.SourceCode = BudgetProject.CorporateSourceCode AND
		Budget.BudgetReportGroupPeriod >= 201007 AND			   
		RECD.IsDeleted = 0 AND
		RECD.SnapshotId = Budget.SnapshotId
		   
	LEFT OUTER JOIN #SnapshotReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		REPE.SourceCode = BudgetProject.CorporateSourceCode AND
		Budget.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0	 AND
		REPE.SnapshotId = Budget.SnapshotId
		
	LEFT OUTER JOIN #SnapshotConsolidationRegionCorporateDepartment CRCD ON -- (CC16)
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		CRCD.CorporateDepartmentCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		CRCD.SourceCode = BudgetProject.CorporateSourceCode AND
		CRCD.SnapshotId = Budget.SnapshotId AND
		Budget.BudgetReportGroupPeriod >= 201101
		
	LEFT OUTER JOIN #SnapshotConsolidationRegionPropertyEntity CRPE ON -- (CC16)
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		CRPE.PropertyEntityCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		CRPE.SourceCode = BudgetProject.CorporateSourceCode AND
		CRPE.SnapshotId = Budget.SnapshotId  AND
		Budget.BudgetReportGroupPeriod >= 201101
	
	LEFT OUTER JOIN #SnapshotPropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN Budget.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END
		AND DepartmentPropertyFund.SnapshotId = Budget.SnapshotId

	LEFT OUTER JOIN #SnapshotPropertyFund ProjectPropertyFund ON
		BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
		ProjectPropertyFund.SnapshotId = Budget.SnapshotId
		
	LEFT OUTER JOIN #SnapshotConsolidationSubRegion ConsolidationSubRegion ON
		ProjectPropertyFund.AllocationSubRegionGlobalRegionId = ConsolidationSubRegion.ConsolidationSubRegionGlobalRegionId AND
		ConsolidationSubRegion.SnapshotId = Budget.SnapshotId	
		
	LEFT OUTER JOIN #BudgetEmployee BudgetEmployee ON
		Allocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId
		
	LEFT OUTER JOIN #Location Location ON 
		Location.LocationId = BudgetEmployee.LocationId
		
	LEFT OUTER JOIN #PayrollRegion OriginatingRegion ON 
		Location.ExternalSubRegionId = OriginatingRegion.ExternalSubRegionId AND
		Budget.RegionId = OriginatingRegion.RegionId

	INNER JOIN GrReporting.dbo.ActivityType Att ON 
		Att.ActivityTypeId = BudgetProject.ActivityTypeId and
		Att.SnapshotId = Budget.SnapshotId
	
	LEFT OUTER JOIN #Department Dept ON
		Dept.DEPARTMENT = BudgetProject.CorporateDepartmentCode AND 
		Dept.[Source] = SourceRegion.SourceCode
		
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
	BudgetReportGroupPeriod
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
	'TGB:BudgetId=' + CONVERT(varchar,pts.BudgetId) + '&ProjectId=' + CONVERT(varchar,ISNULL(pts.ProjectId,0)) + '&HrEmployeeId=' + CONVERT(varchar,ISNULL(pts.HrEmployeeId,0)) + '&BudgetEmployeePayrollAllocationId=' + CONVERT(varchar,pts.BudgetEmployeePayrollAllocationId) + '&BudgetEmployeePayrollAllocationDetailId=' + CONVERT(varchar,TaxDetail.BudgetEmployeePayrollAllocationDetailId) + '&BudgetOverheadAllocationDetailId=0' + '&ImportKey=' + CONVERT(varchar, TaxDetail.ImportKey) AS ReferenceCode,
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
	pts.BudgetReportGroupPeriod
FROM
	#EmployeePayrollAllocationDetail TaxDetail

	INNER JOIN #ProfitabilityPreTaxSource pts ON
		TaxDetail.BudgetEmployeePayrollAllocationId = pts.BudgetEmployeePayrollAllocationId
		
	INNER JOIN #NewBudgets B on 
		B.BudgetId = pts.BudgetId
		
	LEFT OUTER JOIN #SnapshotPropertyFund PF ON
		pts.PropertyFundId = PF.PropertyFundId AND
		B.SnapshotId = PF.SnapshotId

PRINT 'Completed inserting records into #ProfitabilityTaxSource:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))



SET @StartTime = GETDATE()

CREATE INDEX IX_ProfitabilityTaxSource1 ON #ProfitabilityTaxSource (SalaryTaxAmount)
CREATE INDEX IX_ProfitabilityTaxSource2 ON #ProfitabilityTaxSource  (ProfitShareTaxAmount)
CREATE INDEX IX_ProfitabilityTaxSource3 ON #ProfitabilityTaxSource  (BonusTaxAmount)
CREATE INDEX IX_ProfitabilityTaxSource4 ON #ProfitabilityTaxSource  (BonusCapExcessTaxAmount)
CREATE INDEX IX_ProfitabilityTaxSource5 ON #ProfitabilityTaxSource  (BudgetEmployeePayrollAllocationId)


PRINT 'Completed creating indexes on #ProfitabilityPreTaxSource'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


--Map Overhead Amounts
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
	OverheadUpdatedDate DATETIME NOT NULL
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
	OverheadUpdatedDate
)
SELECT
	Budget.ImportBatchId,
	Budget.BudgetId AS BudgetId,
	Budget.FirstProjectedPeriod,
	ISNULL(BudgetProject.ProjectId,0) AS ProjectId,
	ISNULL(BudgetEmployee.HrEmployeeId,0) AS HrEmployeeId,
	OverheadDetail.BudgetOverheadAllocationDetailId,
	'TGB:BudgetId=' + CONVERT(varchar,Budget.BudgetId) + '&ProjectId=' + CONVERT(varchar,ISNULL(BudgetProject.ProjectId,0)) + '&HrEmployeeId=' + CONVERT(varchar,ISNULL(BudgetEmployee.HrEmployeeId,0)) + '&BudgetEmployeePayrollAllocationId=0&BudgetEmployeePayrollAllocationDetailId=0' + '&BudgetOverheadAllocationDetailId=' + CONVERT(varchar,OverheadDetail.BudgetOverheadAllocationDetailId) + '&ImportKey=' + CONVERT(varchar, OverheadDetail.ImportKey) AS ReferenceCode,
	OverheadAllocation.BudgetPeriod AS ExpensePeriod,
	SourceRegion.SourceCode,
	ISNULL(OverheadDetail.AllocationAmount,0) AS OverheadAllocationAmount,
	OverheadDetail.MinorGlAccountCategoryId,
	ISNULL(RegionExtended.OverheadFunctionalDepartmentId, -1) AS FunctionalDepartmentId,
	fd.GlobalCode AS FunctionalDepartmentCode, 
	
	CASE
		WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
			CASE
				WHEN (BudgetProject.IsTsCost = 0) THEN -- Where ISTSCost is False the cost will be reimbursable
					1 
				ELSE
					0
			END
		ELSE
			0  --Where the BudgetProject.OverheadAllocationProjectID is populated: non-reimbursable
	END AS Reimbursable,
	
	BudgetProject.ActivityTypeId,
	
	CASE WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
		ISNULL(CASE WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.PropertyFundId
				ELSE 
					DepartmentPropertyFund.PropertyFundId 
				END, -1) 
	ELSE 
		ISNULL(OverheadPropertyFund.PropertyFundId, -1) 
	END AS PropertyFundId,
	
	ISNULL(CASE -- Same case logic as above
				WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,		
	
	ISNULL(CASE -- (CC16)
				-- Use the allocation region if there is no CorporateDepartmentCode, unless its not a Consolidation Region, then it will be null
				WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ConsolidationSubRegion.ConsolidationSubRegionGlobalRegionId
				ELSE
					CASE WHEN (GrSc.IsProperty = 'YES') THEN 
						CRPE.GlobalRegionId
					ELSE 
						CRCD.GlobalRegionId
					END
			END, -1) AS ConsolidationSubRegionGlobalRegionId,	
	
	OriginatingRegion.CorporateEntityRef,
	OriginatingRegion.CorporateSourceCode,
	Budget.CurrencyCode AS LocalCurrencyCode,
	OverheadDetail.UpdatedDate

FROM
	#BudgetOverheadAllocation OverheadAllocation 

	INNER JOIN #BudgetEmployee BudgetEmployee ON
		OverheadAllocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId

	INNER JOIN #OverheadAllocationDetail OverheadDetail ON
		OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId
			
	INNER JOIN #BudgetProject BudgetProject ON 
		OverheadDetail.BudgetProjectId = BudgetProject.BudgetProjectId
		
	--INNER JOIN #FilteredModifiedReportBudget fmrb ON
	--	BudgetProject.BudgetId = fmrb.BudgetId
		
	INNER JOIN #NewBudgets Budget ON 
		BudgetProject.BudgetId = Budget.BudgetId
		
	LEFT OUTER JOIN #Region SourceRegion ON 
		Budget.RegionId = SourceRegion.RegionId
		
	LEFT OUTER JOIN #RegionExtended RegionExtended ON 
		SourceRegion.RegionId = RegionExtended.RegionId

	LEFT OUTER JOIN #SnapshotFunctionalDepartment fd ON 
		RegionExtended.OverheadFunctionalDepartmentId = fd.FunctionalDepartmentId and
		fd.SnapshotId = Budget.SnapshotId

	LEFT OUTER JOIN	#Project OverheadProject ON
		BudgetProject.AllocateOverheadsProjectId = OverheadProject.ProjectId

	LEFT OUTER JOIN #SnapshotPropertyFund ProjectPropertyFund ON
		BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
		Budget.SnapshotId = ProjectPropertyFund.SnapshotId
		
	LEFT OUTER JOIN #SnapshotConsolidationSubRegion ConsolidationSubRegion ON
		ProjectPropertyFund.AllocationSubRegionGlobalRegionId = ConsolidationSubRegion.ConsolidationSubRegionGlobalRegionId AND
		ConsolidationSubRegion.SnapshotId = Budget.SnapshotId	
	
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON GrSc.SourceCode = BudgetProject.CorporateSourceCode
	
	LEFT OUTER JOIN #SnapshotPropertyFundMapping pfm ON
		BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		BudgetProject.CorporateSourceCode = pfm.SourceCode AND
		--ISNULL(BudgetProject.ActivityTypeId, -1) = ISNULL(pfm.ActivityTypeId, -1) AND 
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
		Budget.BudgetReportGroupPeriod < 201007 AND
		Budget.SnapshotId = pfm.SnapshotId
	
	LEFT OUTER JOIN	#SnapshotReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		RECD.SourceCode = BudgetProject.CorporateSourceCode AND
		Budget.BudgetReportGroupPeriod >= 201007 AND
		RECD.IsDeleted = 0 AND
		RECD.SnapshotID = Budget.SnapshotId
		   
	LEFT OUTER JOIN #SnapshotReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		REPE.SourceCode = BudgetProject.CorporateSourceCode AND
		Budget.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0	 AND
		Budget.SnapshotId = REPE.SnapshotId

	LEFT OUTER JOIN #SnapshotConsolidationRegionCorporateDepartment CRCD ON -- (CC16)
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		CRCD.CorporateDepartmentCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		CRCD.SourceCode = BudgetProject.CorporateSourceCode AND
		CRCD.SnapshotId = Budget.SnapshotId AND
		Budget.BudgetReportGroupPeriod >= 201101
		
	LEFT OUTER JOIN #SnapshotConsolidationRegionPropertyEntity CRPE ON -- (CC16)
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		CRPE.PropertyEntityCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		CRPE.SourceCode = BudgetProject.CorporateSourceCode AND
		CRPE.SnapshotId = Budget.SnapshotId  AND
		Budget.BudgetReportGroupPeriod >= 201101
		
	LEFT OUTER JOIN #SnapshotPropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN Budget.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END
		AND DepartmentPropertyFund.SnapshotId = Budget.SnapshotId

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrScO ON GrScO.SourceCode = OverheadProject.CorporateSourceCode

	LEFT OUTER JOIN #SnapshotPropertyFundMapping opfm ON
		OverheadProject.CorporateDepartmentCode = opfm.PropertyFundCode AND -- Combination of entity and corporate department
		OverheadProject.CorporateSourceCode = opfm.SourceCode AND
		--ISNULL(BudgetProject.ActivityTypeId, -1) = ISNULL(opfm.ActivityTypeId, -1) AND 
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
		Budget.BudgetReportGroupPeriod < 201007 AND
		Budget.SnapshotId = opfm.SnapshotId
	
	LEFT OUTER JOIN #SnapshotPropertyFund OverheadPropertyFund ON
		OverheadPropertyFund.PropertyFundId =	
			CASE
				WHEN Budget.BudgetReportGroupPeriod < 201007 THEN opfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END
		AND OverheadPropertyFund.SnapshotId = Budget.SnapshotId
	
	LEFT OUTER JOIN #OverheadRegion OriginatingRegion ON 
		OverheadAllocation.OverheadRegionId = OriginatingRegion.OverheadRegionId
		
WHERE
	OverheadAllocation.BudgetPeriod BETWEEN Budget.FirstProjectedPeriod AND Budget.GroupEndPeriod
		
PRINT 'Completed inserting records into #ProfitabilityOverheadSource:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


SET @StartTime = GETDATE()

CREATE INDEX IX_ProfitabilityOverheadSource1 ON #ProfitabilityOverheadSource (OverheadAllocationAmount)

PRINT 'Completed creating indexes on #ProfitabilityOverheadSource'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Generate mapping records
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

 /*
;WITH CTE_GetGLAccountOverheadSubIds(SnapshotId, BudgetId, GLAccountSubTypeId, GLTranslationSubTypeCode)
AS
(
	SELECT B.SnapshotId, BudgetId, GLAccountSubTypeId, GLTranslationSubTypeCode From #SnapshotGLAccountCategoryTranslationsOverhead GLCTO	
		INNER JOIN #NewBudgets B ON
			B.SnapshotId = GLCTO.SnapshotId
	WHERE 
		GLTranslationSubTypeCode = 'GL'
),
CTE_GetGLAccountPayrollSubIds(SnapshotId, BudgetId, GLAccountSubTypeId, GLTranslationSubTypeCode)
AS
(
	Select B.SnapshotId, BudgetId, GLAccountSubTypeId, GLTranslationSubTypeCode From #SnapshotGLAccountCategoryTranslationsPayroll GLCTP
		INNER JOIN #NewBudgets B ON
			B.SnapshotId = GLCTP.SnapshotId
	WHERE 
		GLTranslationSubTypeCode = 'GL'
)
select top 1000
     '#ProfitabilityPreTaxSource' as Source, CASE WHEN PTS.ActivityTypeCode = 'CORPOH' 
		--THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		--ELSE  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		THEN (SELECT GLAccountSubTypeId from CTE_GetGLAccountOverheadSubIds CTE_SIDO WHERE CTE_SIDO.BudgetId = PTS.BudgetId)
		ELSE  (Select GLAccountSubTypeId From CTE_GetGLAccountPayrollSubIds CTE_SIDP WHERE CTE_SIDP.BudgetId = PTS.BudgetId)
		END GLAccountSubTypeId, *
   from #ProfitabilityPreTaxSource PTS		
	*/	
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
	GLAccountSubTypeIdGlobal INT NOT NULL,
	GlobalGlAccountCode Varchar(10) NULL
);
 
WITH CTE_GetGLAccountOverheadSubIds(SnapshotId, BudgetId, GLAccountSubTypeId, GLTranslationSubTypeCode)
AS
(
	SELECT B.SnapshotId, BudgetId, GLAccountSubTypeId, GLTranslationSubTypeCode From #SnapshotGLAccountCategoryTranslationsOverhead GLCTO	
		INNER JOIN #NewBudgets B ON
			B.SnapshotId = GLCTO.SnapshotId
	WHERE 
		GLTranslationSubTypeCode = 'GL'
),
CTE_GetGLAccountPayrollSubIds(SnapshotId, BudgetId, GLAccountSubTypeId, GLTranslationSubTypeCode)
AS
(
	Select B.SnapshotId, BudgetId, GLAccountSubTypeId, GLTranslationSubTypeCode From #SnapshotGLAccountCategoryTranslationsPayroll GLCTP
		INNER JOIN #NewBudgets B ON
			B.SnapshotId = GLCTP.SnapshotId
	WHERE 
		GLTranslationSubTypeCode = 'GL'
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
	GLAccountSubTypeIdGlobal,
	GlobalGlAccountCode
)
-- Get Base Salary Payroll pre tax mappings and budget
SELECT
	pps.ImportBatchId,
	'Budget-SalaryPreTaxAmount' as SourceName,
	pps.BudgetId,
	pps.ReferenceCode + '&Type=SalaryPreTax' AS ReferenceCode,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.SalaryPreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MajorGlAccountCategoryId,
	@BaseSalaryMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
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
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		--THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		--ELSE  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		THEN (SELECT GLAccountSubTypeId from CTE_GetGLAccountOverheadSubIds CTE_SIDO WHERE CTE_SIDO.BudgetId = pps.BudgetId)
		ELSE  (Select GLAccountSubTypeId From CTE_GetGLAccountPayrollSubIds CTE_SIDP WHERE CTE_SIDP.BudgetId = pps.BudgetId)
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityPreTaxSource pps
WHERE
	pps.SalaryPreTaxAmount <> 0

-- Get Profit Share Benefit pre tax mappings and budget
UNION ALL

SELECT
	pps.ImportBatchId,
	'Budget-ProfitSharePreTaxAmount' as SourceName,
	pps.BudgetId,
	pps.ReferenceCode + '&Type=ProfitSharePreTax' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.ProfitSharePreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MajorGlAccountCategoryId,
	@ProfitShareMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
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
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		--THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		---ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		THEN (SELECT GLAccountSubTypeId from CTE_GetGLAccountOverheadSubIds CTE_SIDO WHERE CTE_SIDO.BudgetId = pps.BudgetId)
		ELSE  (Select GLAccountSubTypeId From CTE_GetGLAccountPayrollSubIds CTE_SIDP WHERE CTE_SIDP.BudgetId = pps.BudgetId)
		
		
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityPreTaxSource pps
WHERE
	pps.ProfitSharePreTaxAmount <> 0

-- Get Bonus pre tax mappings and budget
UNION ALL

SELECT
	pps.ImportBatchId,
    'Budget-BonusPreTaxAmount' as SourceName,
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusPreTax' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusPreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MajorGlAccountCategoryId,
	@BonusMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
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
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		--THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		--ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		THEN (SELECT GLAccountSubTypeId from CTE_GetGLAccountOverheadSubIds CTE_SIDO WHERE CTE_SIDO.BudgetId = pps.BudgetId)
		ELSE  (Select GLAccountSubTypeId From CTE_GetGLAccountPayrollSubIds CTE_SIDP WHERE CTE_SIDP.BudgetId = pps.BudgetId)
		
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityPreTaxSource pps
WHERE
	pps.BonusPreTaxAmount <> 0

--Get bonus cap pre tax mappings
UNION ALL

SELECT
	pps.ImportBatchId,
    'Budget-BonusCapExcessPreTaxAmount' as SourceName,	
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusCapExcessPreTax' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusCapExcessPreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MajorGlAccountCategoryId,
	@BonusMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	0 AS Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
	'BonusCapExcessPreTax' FeeOrExpense,
	ISNULL(p.ActivityTypeId, -1) AS ActivityTypeId,

	ISNULL(CASE
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.PropertyFundId
				ELSE
					DepartmentPropertyFund.PropertyFundId 
			END, -1) AS PropertyFundId,
	-- Same case logic AS above

	ISNULL(CASE -- Same case logic as above
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,

	ISNULL(CASE -- (CC16)
				-- Use the allocation region if there is no CorporateDepartmentCode, unless its not a Consolidation Region, then it will be null
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
					ConsolidationSubRegion.ConsolidationSubRegionGlobalRegionId
				ELSE
					CASE WHEN (GrSc.IsProperty = 'YES') THEN 
						CRPE.GlobalRegionId
					ELSE 
						CRCD.GlobalRegionId
					END
			END, -1) AS ConsolidationSubRegionGlobalRegionId,
			
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		--THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		--ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		THEN (SELECT GLAccountSubTypeId from CTE_GetGLAccountOverheadSubIds CTE_SIDO WHERE CTE_SIDO.BudgetId = pps.BudgetId)
		ELSE  (Select GLAccountSubTypeId From CTE_GetGLAccountPayrollSubIds CTE_SIDP WHERE CTE_SIDP.BudgetId = pps.BudgetId)
		
		
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityPreTaxSource pps
	INNER JOIN #NewBudgets B on
	  PPS.BudgetId = B.BudgetId
	LEFT OUTER JOIN #SystemSettingRegion ssr ON
		pps.SourceCode = ssr.SourceCode AND
		pps.BudgetRegionId = ssr.RegionId AND
		ssr.SystemSettingName = 'BonusCapExcess'
		
	LEFT OUTER JOIN #Project p ON
		ssr.BonusCapExcessProjectId = p.ProjectId
			
	LEFT OUTER JOIN #SnapshotPropertyFund ProjectPropertyFund ON
		p.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
		B.SnapshotId = ProjectPropertyFund.SnapshotId
		
	LEFT OUTER JOIN #SnapshotConsolidationSubRegion ConsolidationSubRegion ON
		ProjectPropertyFund.AllocationSubRegionGlobalRegionId = ConsolidationSubRegion.ConsolidationSubRegionGlobalRegionId AND
		ProjectPropertyFund.SnapshotId = ConsolidationSubRegion.SnapshotId
		
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		GrSc.SourceCode = p.CorporateSourceCode

	LEFT OUTER JOIN #SnapshotPropertyFundMapping pfm ON
		p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		p.CorporateSourceCode = pfm.SourceCode AND
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
		pps.BudgetReportGroupPeriod < 201007 AND
		B.SnapshotId = pfm.SnapshotId

	LEFT OUTER JOIN	#SnapshotReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		RECD.SourceCode = p.CorporateSourceCode AND
		pps.BudgetReportGroupPeriod >= 201007 AND			   
		RECD.IsDeleted = 0 AND
		RECD.SnapshotId = B.SnapshotId

	LEFT OUTER JOIN #SnapshotReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		REPE.SourceCode = p.CorporateSourceCode AND
		pps.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0	 AND
		REPE.SnapshotId = B.SnapshotId
		
	LEFT OUTER JOIN #SnapshotConsolidationRegionCorporateDepartment CRCD ON -- (CC16)
		GrSc.IsCorporate = 'YES' AND -- only property MRIs resolved through this
		CRCD.CorporateDepartmentCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		CRCD.SourceCode = p.CorporateSourceCode AND
		CRCD.SnapshotId = B.SnapshotId AND
		pps.BudgetReportGroupPeriod >= 201101
	
	LEFT OUTER JOIN #SnapshotConsolidationRegionPropertyEntity CRPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		CRPE.PropertyEntityCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		CRPE.SourceCode = p.CorporateSourceCode AND
		CRPE.SnapshotId = B.SnapshotId AND
		pps.BudgetReportGroupPeriod >= 201101

	LEFT OUTER JOIN #SnapshotPropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN pps.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END
			AND DepartmentPropertyFund.SnapshotId = B.SnapshotId
			
	
		
WHERE
	pps.BonusCapExcessPreTaxAmount <> 0

UNION ALL

-- Get Base Salary Payroll Tax mappings and budget
SELECT
    pps.ImportBatchId,
    'Budget-SalaryTaxAmount' as SourceName,
	pps.BudgetId,
	pps.ReferenceCode + '&Type=SalaryTax' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.SalaryTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MajorGlAccountCategoryId,
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
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		--THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		--ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		THEN (SELECT GLAccountSubTypeId from CTE_GetGLAccountOverheadSubIds CTE_SIDO WHERE CTE_SIDO.BudgetId = pps.BudgetId)
		ELSE  (Select GLAccountSubTypeId From CTE_GetGLAccountPayrollSubIds CTE_SIDP WHERE CTE_SIDP.BudgetId = pps.BudgetId)
		
		
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.SalaryTaxAmount <> 0

-- Get Profit Share Benefit Tax mappings and budget
UNION ALL

SELECT
    pps.ImportBatchId,
	'Budget-ProfitShareTaxAmount' as SourceName,
	pps.BudgetId,
	pps.ReferenceCode + '&Type=ProfitShareTax' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.ProfitShareTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MajorGlAccountCategoryId,
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
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		--THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		--ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		THEN (SELECT GLAccountSubTypeId from CTE_GetGLAccountOverheadSubIds CTE_SIDO WHERE CTE_SIDO.BudgetId = pps.BudgetId)
		ELSE  (Select GLAccountSubTypeId From CTE_GetGLAccountPayrollSubIds CTE_SIDP WHERE CTE_SIDP.BudgetId = pps.BudgetId)
		
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.ProfitShareTaxAmount <> 0

-- Get Bonus Tax mappings and budget
UNION ALL

SELECT
    pps.ImportBatchId,
	'Budget-BonusTaxAmount' as SourceName,
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusTax' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MajorGlAccountCategoryId,
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
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		--THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		--ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		THEN (SELECT GLAccountSubTypeId from CTE_GetGLAccountOverheadSubIds CTE_SIDO WHERE CTE_SIDO.BudgetId = pps.BudgetId)
		ELSE  (Select GLAccountSubTypeId From CTE_GetGLAccountPayrollSubIds CTE_SIDP WHERE CTE_SIDP.BudgetId = pps.BudgetId)
		
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityTaxSource pps
	INNER JOIN #NewBudgets B on
	  PPS.BudgetId = B.BudgetId
WHERE
	pps.BonusTaxAmount <> 0

-- Get Bonus cap Tax mappings 
UNION ALL

SELECT
    pps.ImportBatchId,
	'Budget-BonusCapExcessTaxAmount' as SourceName,
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusCapExcessTax' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusCapExcessTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MajorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	0 AS Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
	'BonusCapExcessTax' FeeOrExpense,
	ISNULL(p.ActivityTypeId, -1) AS ActivityTypeId,
	
	ISNULL(CASE
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.PropertyFundId
				ELSE
					DepartmentPropertyFund.PropertyFundId 
			END, -1) AS PropertyFundId,
	-- Same case logic AS above

	ISNULL(CASE -- Same case logic as above
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,

	ISNULL(CASE -- (CC16)
				-- Use the allocation region if there is no CorporateDepartmentCode, unless its not a Consolidation Region, then it will be null
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
					ConsolidationSubRegion.ConsolidationSubRegionGlobalRegionId
				ELSE
					CASE WHEN (GrSc.IsProperty = 'YES') THEN 
						CRPE.GlobalRegionId
					ELSE 
						CRCD.GlobalRegionId
					END
			END, -1) AS ConsolidationSubRegionGlobalRegionId,

	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		--THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		--ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		THEN (SELECT GLAccountSubTypeId from CTE_GetGLAccountOverheadSubIds CTE_SIDO WHERE CTE_SIDO.BudgetId = pps.BudgetId)
		ELSE  (Select GLAccountSubTypeId From CTE_GetGLAccountPayrollSubIds CTE_SIDP WHERE CTE_SIDP.BudgetId = pps.BudgetId)
		
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityTaxSource pps
	INNER JOIN #NewBudgets B on
		b.BudgetId = pps.BudgetId
		
	LEFT OUTER JOIN #SystemSettingRegion ssr ON
		pps.SourceCode = ssr.SourceCode AND
		pps.BudgetRegionId = ssr.RegionId AND
		ssr.SystemSettingName = 'BonusCapExcess'

	LEFT OUTER JOIN #Project p ON
		ssr.BonusCapExcessProjectId = p.ProjectId

	LEFT OUTER JOIN #SnapshotPropertyFund ProjectPropertyFund ON
		p.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
		b.SnapshotId = ProjectPropertyFund.SnapshotId
		
	LEFT OUTER JOIN #SnapshotConsolidationSubRegion ConsolidationSubRegion ON
		ProjectPropertyFund.AllocationSubRegionGlobalRegionId = ConsolidationSubRegion.ConsolidationSubRegionGlobalRegionId AND
		ProjectPropertyFund.SnapshotId = ConsolidationSubRegion.SnapshotId

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		GrSc.SourceCode = p.CorporateSourceCode

	LEFT OUTER JOIN #SnapshotPropertyFundMapping pfm ON
		p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		p.CorporateSourceCode = pfm.SourceCode AND
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
		pps.BudgetReportGroupPeriod < 201007 AND
		b.SnapshotId = pfm.SnapshotId

	LEFT OUTER JOIN	#SnapshotReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		RECD.SourceCode = p.CorporateSourceCode AND
		pps.BudgetReportGroupPeriod >= 201007 AND			   
		RECD.IsDeleted = 0 AND
		RECD.SnapshotId = B.SnapshotId
		   
	LEFT OUTER JOIN #SnapshotReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		REPE.SourceCode = p.CorporateSourceCode AND
		pps.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0 AND
		B.SnapshotId = REPE.SnapshotId
		
	LEFT OUTER JOIN #SnapshotConsolidationRegionCorporateDepartment CRCD ON -- (CC16)
		GrSc.IsCorporate = 'YES' AND -- only property MRIs resolved through this
		CRCD.CorporateDepartmentCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		CRCD.SourceCode = p.CorporateSourceCode AND
		CRCD.SnapshotId = B.SnapshotId AND
		pps.BudgetReportGroupPeriod >= 201101
	
	LEFT OUTER JOIN #SnapshotConsolidationRegionPropertyEntity CRPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		CRPE.PropertyEntityCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		CRPE.SourceCode = p.CorporateSourceCode AND
		CRPE.SnapshotId = B.SnapshotId AND
		pps.BudgetReportGroupPeriod >= 201101

	LEFT OUTER JOIN #SnapshotPropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN pps.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END
		AND DepartmentPropertyFund.SnapshotId = B.SnapshotId

WHERE
	pps.BonusCapExcessTaxAmount <> 0
	
-- Get Overhead mappings	
UNION ALL

SELECT
    pos.ImportBatchId,
	'Budget-OverheadAllocationAmount' as SourceName,
	pos.BudgetId,
	pos.ReferenceCode + '&Type=OverheadAllocation' AS ReferenceCod,
	pos.FirstProjectedPeriod,
	pos.ExpensePeriod,
	pos.SourceCode,
	pos.OverheadAllocationAmount AS BudgetAmount,
	@OccupancyCostsMajorGlAccountCategoryId AS MajorGlAccountCategoryId,
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
	--(Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL'),
	(SELECT GLAccountSubTypeId from CTE_GetGLAccountOverheadSubIds CTE_SIDO WHERE CTE_SIDO.BudgetId = pos.BudgetId),
	--General Allocated Overhead Account :: CC8
	'50029500'+RIGHT('0'+LTRIM(STR(pos.ActivityTypeId,3,0)),2) as GlobalGlAccountCode
FROM
	#ProfitabilityOverheadSource pos
	INNER JOIN #NewBudgets B on
		b.BudgetId = pos.BudgetId
	
WHERE
	pos.OverheadAllocationAmount <> 0

PRINT 'Completed inserting records into #ProfitabilityPayrollMapping:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

CREATE CLUSTERED INDEX IX_AllocationUpdatedDate ON #ProfitabilityPayrollMapping(ReferenceCode,AllocationUpdatedDate)

PRINT 'Completed creating indexes on #ProfitabilityPayrollMapping'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Map mapped source data into the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
------------------------------------------------------------------------------------------------------
-- Map to the fact
------------------------------------------------------------------------------------------------------
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--If the join is not possible, default the link to the 'UNKNOWN' link
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

SET @StartTime = GETDATE()

CREATE TABLE #ProfitabilityReforecast(
	ImportBatchId INT NOT NULL,
    SourceName varchar(50),
    BudgetReforecastTypeKey INT NOT NULL,
    SnapshotId INT NOT NULL,
	CalendarKey INT NOT NULL,
	ReforecastKey INT NOT NULL,
	GlAccountKey INT NOT NULL,
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
	
	EUCorporateGlAccountCategoryKey INT NULL,
	EUPropertyGlAccountCategoryKey INT NULL,
	EUFundGlAccountCategoryKey INT NULL,

	USPropertyGlAccountCategoryKey INT NULL,
	USCorporateGlAccountCategoryKey INT NULL,
	USFundGlAccountCategoryKey INT NULL,

	GlobalGlAccountCategoryKey INT NULL,
	DevelopmentGlAccountCategoryKey INT NULL
) 



INSERT INTO #ProfitabilityReforecast 
(
	ImportBatchId,
    SourceName,
    BudgetReforecastTypeKey,
	SnapshotId,
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
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
	BudgetId
)
SELECT
	PBM.ImportBatchId,
    pbm.SourceName,
    @ReforecastTypeIsTGBBUDKey,
    B.SnapshotId,
	DATEDIFF(dd, '1900-01-01', LEFT(pbm.ExpensePeriod,4)+'-'+RIGHT(pbm.ExpensePeriod,2)+'-01') AS CalendarKey,
	--DATEDIFF(dd, '1900-01-01', LEFT(pbm.FirstProjectedPeriod,4)+'-'+RIGHT(pbm.FirstProjectedPeriod,2)+'-01') AS ReforecastKey,
	B.ReforecastKey AS ReforecastKey,
	CASE WHEN GrGa.GlAccountKey IS NULL THEN @GlAccountKeyUnknown ELSE GrGa.GlAccountKey END GlAccountKey,
	CASE WHEN GrSc.[SourceKey] IS NULL THEN @SourceKeyUnknown ELSE GrSc.[SourceKey] END SourceKey,
	CASE WHEN GrFdm.[FunctionalDepartmentKey] IS NULL THEN @FunctionalDepartmentKeyUnknown ELSE GrFdm.[FunctionalDepartmentKey] END FunctionalDepartmentKey,
	CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKeyUnknown ELSE GrRi.ReimbursableKey END ReimbursableKey,
	CASE WHEN GrAt.[ActivityTypeKey] IS NULL THEN @ActivityTypeKeyUnknown ELSE GrAt.[ActivityTypeKey] END ActivityTypeKey,
	CASE WHEN GrPf.[PropertyFundKey] IS NULL THEN @PropertyFundKeyUnknown ELSE GrPf.[PropertyFundKey] END PropertyFundKey,
	CASE WHEN GrAr.[AllocationRegionKey] IS NULL THEN @AllocationRegionKeyUnknown ELSE GrAr.[AllocationRegionKey] END AllocationRegionKey,
	CASE WHEN GrCr.[AllocationRegionKey] IS NULL THEN @AllocationRegionKeyUnknown ELSE GrCr.[AllocationRegionKey] END ConsolidationRegionKey, -- CC16: Consolidation Region Key
	CASE WHEN GrOr.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKeyUnknown ELSE GrOr.[OriginatingRegionKey] END OriginatingRegionKey,
	CASE WHEN GrOh.[OverheadKey] IS NULL THEN @OverheadKeyUnknown ELSE GrOh.[OverheadKey] END OverheadKey,
	CASE WHEN GrCu.[CurrencyKey] IS NULL THEN @LocalCurrencyKeyUnknown ELSE GrCu.[CurrencyKey] END LocalCurrencyKey,
	pbm.BudgetAmount,
	pbm.ReferenceCode,
	pbm.BudgetId
FROM
	#ProfitabilityPayrollMapping pbm
	
	INNER JOIN #NewBudgets B on
		B.BudgetId = pbm.BudgetId 
	
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		pbm.SourceCode = GrSc.SourceCode 

	LEFT OUTER JOIN GrReporting.dbo.GlAccount GrGa ON
		GrGa.Code = pbm.GlobalGlAccountCode AND
		--pbm.AllocationUpdatedDate BETWEEN GrGa.StartDate AND GrGa.EndDate AND
		GrGa.SnapshotId = B.SnapshotId		
		
	--Parent Level (No job code for payroll)
	LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdm ON
		GrFdm.ReferenceCode LIKE pbm.FunctionalDepartmentCode +':%' AND
		pbm.AllocationUpdatedDate BETWEEN GrFdm.StartDate AND GrFdm.EndDate AND
		GrFdm.SubFunctionalDepartmentCode = GrFdm.FunctionalDepartmentCode 
		

	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		CASE WHEN pbm.Reimbursable = 1 THEN 'YES' ELSE 'NO' END = GrRi.ReimbursableCode 		

	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		pbm.ActivityTypeId = GrAt.ActivityTypeId AND
		-- THIS IS NO LONGER NEEDED?
		--pbm.AllocationUpdatedDate BETWEEN GrAt.StartDate AND GrAt.EndDate AND
		GrAt.SnapshotId = B.SnapshotId		

	LEFT OUTER JOIN GrReporting.dbo.Overhead GrOh ON
		--GC :: Change Control 1
		GrOh.OverheadCode = CASE WHEN pbm.FeeOrExpense = 'Overhead' THEN 'ALLOC' 
									WHEN GrAt.ActivityTypeCode = 'CORPOH' THEN 'UNALLOC' 
									ELSE 'UNKNOWN' END 
		--AND GrOh.SnapshotId = B.SnapshotId										
								
									
	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		pbm.PropertyFundId = GrPf.PropertyFundId AND
		--pbm.AllocationUpdatedDate BETWEEN GrPf.StartDate AND GrPf.EndDate 
		GrPf.SnapshotId = B.SnapshotId

	-- HACK: At some point tapas was supposed to pull project region out of GDM. 
	-- Now allocation regions are source based??? So I use the code because it is built up from the ProjectRegionId since there is only data for one source anyway.
	-- I don't check source because actuals also don't check source. 
	--LEFT OUTER JOIN #AllocationRegionMapping Arm ON
	--	Arm.RegionCode = pbm.ProjectRegionId AND -- TODO: Pull the RegionCode through from the top.
	--	Arm.IsDeleted = 0
	
		
	LEFT OUTER JOIN #SnapshotAllocationSubRegion ASR ON
		pbm.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId AND
		B.SnapshotId = ASR.SnapshotId

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		ASR.AllocationSubRegionGlobalRegionId = GrAr.GlobalRegionId AND
		--pbm.AllocationUpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate
		GrAr.SnapshotId = B.SnapshotId
		
	LEFT OUTER JOIN #SnapshotConsolidationSubRegion CSR ON
		pbm.ConsolidationSubRegionGlobalRegionId = CSR.ConsolidationSubRegionGlobalRegionId AND
		B.SnapshotId = CSR.SnapshotId
		
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrCr ON
		CSR.ConsolidationSubRegionGlobalRegionId = GrCr.GlobalRegionId AND
		GrCr.SnapshotId = B.SnapshotId

/* -- At some point Allocation region in GDM was going to become the master list
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		pbm.ProjectRegionId = GrAr.GlobalRegionId AND
		pbm.AllocationUpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate
*/

	--LEFT OUTER JOIN #OriginatingRegionMapping Orm ON
	--	Orm.RegionCode = CASE WHEN RIGHT(pbm.OriginatingRegionSourceCode,1) = 'C' THEN LTRIM(RTRIM(pbm.OriginatingRegionCode))
	--							ELSE LTRIM(RTRIM(pbm.OriginatingRegionCode)) + LTRIM(RTRIM(pbm.FunctionalDepartmentCode)) END AND
	--	Orm.SourceCode = pbm.OriginatingRegionSourceCode AND
	--	Orm.IsDeleted = 0
		
				
	LEFT OUTER JOIN #SnapshotOriginatingRegionCorporateEntity ORCE ON
		ORCE.SnapshotId = B.SnapshotId AND
		ORCE.CorporateEntityCode = LTRIM(RTRIM(pbm.OriginatingRegionCode)) AND
		ORCE.SourceCode = pbm.OriginatingRegionSourceCode AND
		ORCE.IsDeleted = 0
		
		   
	LEFT OUTER JOIN #SnapshotOriginatingRegionPropertyDepartment ORPD ON
		B.SnapshotId = ORPD.SnapshotId	AND
		ORPD.PropertyDepartmentCode = LTRIM(RTRIM(pbm.OriginatingRegionCode)) AND
		ORPD.SourceCode = pbm.OriginatingRegionSourceCode AND
		ORPD.IsDeleted = 0
		
		
		
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		GrOr.GlobalRegionId = ISNULL(ORCE.GlobalRegionId, ORPD.GlobalRegionId) AND
		--pbm.AllocationUpdatedDate BETWEEN GrOr.StartDate AND GrOr.EndDate
		GrOr.SnapshotId = B.SnapshotId
	
	LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
		pbm.LocalCurrencyCode = GrCu.CurrencyCode


PRINT 'Completed inserting budget portions into #ProfitabilityReforecast:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

------------------------------------------------------------------------------------------------------
-- INSERT ACTUALS
------------------------------------------------------------------------------------------------------
SET @StartTime = GETDATE()

CREATE TABLE #ProfitabilityActualSource
(
	ImportBatchId INT NOT NULL,
    SourceName VARCHAR(50),
    BudgetReforecastTypeKey INT NOT NULL,
	SnapshotId INT NOT NULL,
	CalendarKey INT NOT NULL,
	ReforecastKey INT NOT NULL,
	GlAccountKey INT NOT NULL,
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
)
INSERT INTO #ProfitabilityActualSource
(
	ImportBatchId,
    SourceName,
    BudgetReforecastTypeKey,
	SnapshotId,
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
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
	BudgetId
)
SELECT  
	BPA.ImportBatchId AS ImportBatchId,
	'Actuals' as SourceName,
	@ReforecastTypeIsTGBACTKey as BudgetReforecastTypeKey,
    B.SnapshotId,
    DATEDIFF(dd, '1900-01-01', LEFT(BPA.Period,4)+'-'+RIGHT(BPA.Period,2)+'-01') AS CalendarKey,
	--DATEDIFF(dd, '1900-01-01', LEFT(BPA.Period,4)+'-'+RIGHT(BPA.Period,2)+'-01') AS ReforecastKey,
	B.ReforecastKey AS ReforecastKey,
	CASE WHEN GrGa.GlAccountKey IS NULL THEN @GlAccountKeyUnknown ELSE GrGa.GlAccountKey END GlAccountKey,
	CASE WHEN GrSc.[SourceKey] IS NULL THEN @SourceKeyUnknown ELSE GrSc.[SourceKey] END SourceKey,
	--CASE WHEN GrFdm.[FunctionalDepartmentKey] IS NULL THEN @FunctionalDepartmentKeyUnknown ELSE GrFdm.[FunctionalDepartmentKey] END FunctionalDepartmentKey,
	-- New logic use GBS logic instead as this is actuals and from GBS
	CASE WHEN
		ISNULL(FDJobCode.FunctionalDepartmentKey, GrFdm.FunctionalDepartmentKey) IS NULL
		THEN
			@FunctionalDepartmentKeyUnknown
		ELSE
			ISNULL(FDJobCode.FunctionalDepartmentKey, GrFdm.FunctionalDepartmentKey) END AS FunctionalDepartmentKey,	
	
	
	CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKeyUnknown ELSE GrRi.ReimbursableKey END ReimbursableKey,
	CASE WHEN GrAt.[ActivityTypeKey] IS NULL THEN @ActivityTypeKeyUnknown ELSE GrAt.[ActivityTypeKey] END ActivityTypeKey,
	CASE WHEN GrPf.[PropertyFundKey] IS NULL THEN @PropertyFundKeyUnknown ELSE GrPf.[PropertyFundKey] END PropertyFundKey,
	
	CASE WHEN GrAr.[AllocationRegionKey] IS NULL THEN @AllocationRegionKeyUnknown ELSE GrAr.[AllocationRegionKey] END AllocationRegionKey,
	CASE WHEN GrCr.AllocationRegionKey IS NULL THEN @AllocationRegionKeyUnknown ELSE GrCr.AllocationRegionKey END ConsolidationRegionKey, -- CC16: ConsolidationRegionKey
	CASE WHEN GrOr.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKeyUnknown ELSE GrOr.[OriginatingRegionKey] END OriginatingRegionKey,
	CASE WHEN GrOh.[OverheadKey] IS NULL THEN @OverheadKeyUnknown ELSE GrOh.[OverheadKey] END OverheadKey,
	CASE WHEN GrCu.[CurrencyKey] IS NULL THEN @LocalCurrencyKeyUnknown ELSE GrCu.[CurrencyKey] END LocalCurrencyKey,	
	BPA.Amount AS LocalReforecast,
   'TGB:GBSBudgetId=' + LTRIM(RTRIM(STR(B.BudgetId))) + '&BudgetProfitabilityActualId=' + LTRIM(RTRIM(STR(bpa.BudgetProfitabilityActualId))) + '&SnapshotId=' + LTRIM(RTRIM(STR(b.SnapshotId))) as ReferenceCode, -- ReferenceCode
	B.BudgetId
FROM 
    GBS.BudgetProfitabilityActual BPA 
    INNER JOIN  #GBSBudgets B ON 
		B.BudgetId = BPA.BudgetId AND 
		B.MustImportAllActualsIntoWarehouse = 1 AND
		B.ImportBatchId = BPA.ImportBatchId
    
	INNER JOIN #SnapshotGLTranslationSubType TST ON
		B.SnapshotId = TST.SnapshotId	

  		
	LEFT OUTER JOIN #SnapshotGLGlobalAccount GA ON
		BPA.GLGlobalAccountId = GA.GLGlobalAccountId AND
		B.SnapshotId = GA.SnapshotId
		
    LEFT OUTER JOIN GBS.OverheadType OHT ON
		BPA.OverheadTypeId = OHT.OverheadTypeId AND
		OHT.ImportBatchId = B.ImportBatchId

	LEFT OUTER JOIN GrReporting.dbo.GlAccount GrGa ON
		GrGa.GLGlobalAccountId = BPA.GLGlobalAccountId AND		
		GrGa.SnapshotId = B.SnapshotId		
		
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON 
		GrSc.SourceCode = BPA.SourceCode


	-- FunctionalDepartmentCode
	LEFT OUTER JOIN #SnapshotFunctionalDepartment FD ON
		BPA.FunctionalDepartmentId = FD.FunctionalDepartmentId and
		B.SnapshotId = FD.SnapshotId


	-- Detail/Sub Level (Job Code) -- job code is stored as SubFunctionalDepartment in GrReporting.dbo.FunctionalDepartment
	LEFT OUTER JOIN (
						SELECT
							FunctionalDepartmentKey,
							FunctionalDepartmentCode,
							FunctionalDepartmentName,
							SubFunctionalDepartmentCode,
							SubFunctionalDepartmentName
						FROM
							GrReporting.dbo.FunctionalDepartment
						WHERE
							FunctionalDepartmentCode <> SubFunctionalDepartmentCode
							
	) FDJobCode ON
		FD.GlobalCode = FDJobCode.SubFunctionalDepartmentCode AND
		FD.GlobalCode = FDJobCode.FunctionalDepartmentCode 
		

	-- Parent Level
	LEFT OUTER JOIN (
						SELECT
							FunctionalDepartmentKey,
							FunctionalDepartmentCode,
							FunctionalDepartmentName,
							SubFunctionalDepartmentCode,
							SubFunctionalDepartmentName
						FROM
							GrReporting.dbo.FunctionalDepartment
						WHERE
							SubFunctionalDepartmentCode = FunctionalDepartmentCode
	) GrFdm ON
		FD.GlobalCode = GrFdm.FunctionalDepartmentCode

	/* --- Because this is tapas actuals this wont work i think so lets try the logic above from GBS
	LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdm ON
		GrFdm.ReferenceCode LIKE FD.Code +':%' AND
		BPA.UpdatedDate BETWEEN GrFdm.StartDate AND GrFdm.EndDate AND
		GrFdm.SubFunctionalDepartmentCode = GrFdm.FunctionalDepartmentCode 
		--and GrFdm.SnapshotId = B.SnapshotId			*/
	


	LEFT OUTER JOIN #SnapshotAllocationSubRegion ASR ON
		BPA.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId AND 
		B.SnapshotId = ASR.SnapshotId
		
		
		
		
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		ASR.AllocationSubRegionGlobalRegionId = GrAr.GlobalRegionId AND
		--BPA.UpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate
		GrAr.SnapshotId = B.SnapshotId		
		
	LEFT OUTER JOIN #SnapshotConsolidationSubRegion CSR ON
		BPA.ConsolidationSubRegionGlobalRegionId = CSR.ConsolidationSubRegionGlobalRegionId AND 
		B.SnapshotId = CSR.SnapshotId
		
		
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrCr ON -- CC16: ConsolidationRegions
		CSR.ConsolidationSubRegionGlobalRegionId = GrCr.GlobalRegionId AND
		--BPA.UpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate
		GrCr.SnapshotId = B.SnapshotId		

    LEFT OUTER JOIN  #SnapshotPropertyFund PF ON
		PF.PropertyFundId = BPA.ReportingEntityPropertyFundId AND
		B.SnapshotId = PF.SnapshotId
		
	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON	
	    GrPf.PropertyFundId = BPA.ReportingEntityPropertyFundId AND
	    Grpf.SnapshotId = PF.SnapshotId	      
		
	
	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		BPA.ActivityTypeId = GrAt.ActivityTypeId AND
		--BPA.UpdatedDate BETWEEN GrAt.StartDate AND GrAt.EndDate AND
		GrAt.SnapshotId = B.SnapshotId		
		
		
	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
	     GrRi.ReimbursableCode = CASE WHEN BPA.IsTsCost = 0 THEN 'YES' ELSE 'NO' END
	    
    LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON 
		BPA.OriginatingSubRegionGlobalRegionId = GrOr.GlobalRegionId and
		GrOr.SnapshotId = B.SnapshotId
	    
	  
	
	LEFT OUTER JOIN GrReporting.dbo.Overhead GrOh ON
		OHT.Code = GrOh.OverheadCode
		--GC :: Change Control 1
		--GrOh.OverheadCode =  CASE WHEN GrAt.ActivityTypeCode = 'CORPOH' THEN 'UNALLOC' ELSE 'UNKNOWN' END    
		--GrOh.OverheadCode = 'ALLOC'
		--AND GrOh.SnapshotId = B.SnapshotId					
	
	LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
		BPA.CurrencyCode = GrCu.CurrencyCode	
		
	LEFT OUTER JOIN #SnapshotGLGlobalAccountTranslationSubType GLATST ON
		GLATST.GLGlobalAccountId = GA.GLGlobalAccountId AND
		B.SnapshotId = GLATST.SnapshotId		

	LEFT OUTER JOIN #SnapshotGLMinorCategory MinC ON
		GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		B.SnapshotId = MinC.SnapshotId

	LEFT OUTER JOIN #SnapshotGLMajorCategory MajC ON
		MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
		B.SnapshotId = MajC.SnapshotId

WHERE 
	BPA.Period < B.FirstProjectedPeriod AND		
	MajC.Name in ('Salaries/Taxes/Benefits', 'General Overhead') AND
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
	GlAccountKey,
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
	BudgetId
)
SELECT
	ImportBatchId,
    SourceName,
    BudgetReforecastTypeKey,
	SnapshotId,
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
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
	BudgetId
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
	#NewBudgets
UNION ALL
SELECT DISTINCT 
	BudgetId
FROM
	#GBSBudgets	

DECLARE @BudgetId INT = -1
DECLARE @LoopCount INT = 0 -- Infinite loop safe guard
DECLARE @TotalDeleteCount INT = 0
WHILE (EXISTS (SELECT TOP 1 BudgetId FROM #DeletingBudget) AND @LoopCount < 100000)
BEGIN
	
	SET @LoopCount = @LoopCount + 1
	SET @BudgetId = (SELECT TOP 1 BudgetId FROM #DeletingBudget)


	DECLARE @row Int = 1
	DECLARE @deleteCnt Int = 0
	WHILE (@row > 0)
		BEGIN
		-- Remove old facts
		DELETE TOP (100000)
		FROM 
			GrReporting.dbo.ProfitabilityReforecast 
		WHERE 
			BudgetId = @BudgetId AND
			BudgetReforecastTypeKey in (@ReforecastTypeIsTGBBUDKey, @ReforecastTypeIsTGBACTKey)
		
		
		SET @row = @@rowcount
		SET @deleteCnt = @deleteCnt + @row
		SET @TotalDeleteCount = @TotalDeleteCount + @row
		PRINT '>>>:'+CONVERT(char(10),@row)
		PRINT CONVERT(Varchar(27), getdate(), 121)
		
		END
		
	PRINT 'Rows Deleted FOR BudgetID (' + STR(@BudgetId) + ') FROM  ProfitabilityReforecast:'+CONVERT(VARCHAR(10),@deleteCnt)		
	--PRINT 'Rows Deleted from ProfitabilityReforecast:'+CONVERT(char(10),@deleteCnt)
	PRINT CONVERT(Varchar(27), getdate(), 121)

	DELETE FROM #DeletingBudget WHERE BudgetId = @BudgetId
END
PRINT 'TOTAL Rows Deleted from ProfitabilityReforecast:'+CONVERT(char(10),@TotalDeleteCount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

print 'Cleaned up rows in ProfitabilityReforecast'

------------------------------------------------------------------------------------------------------
-- Map account categories
------------------------------------------------------------------------------------------------------

--GlobalGlAccountCategoryKey
SET @StartTime = GETDATE()

CREATE TABLE #GlobalCategoryLookup(
    SnapshotId INT NOT NULL,
	GlAccountCategoryKey INT NULL,
	ReferenceCode VARCHAR(300) NOT NULL
)

INSERT INTO #GlobalCategoryLookup(
    SnapshotId,
	GlAccountCategoryKey,
	ReferenceCode
)
SELECT 
	 Gl.SnapshotId,
	GlAcGlobal.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT 
		    B.SnapshotId,
			GlAcHg.GLTranslationTypeId,
			GlAcHg.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			GlAcHg.GLAccountTypeId,
			GlAcHg.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode
		 FROM	
			#ProfitabilityPayrollMapping Gl		
			INNER JOIN #NewBudgets B ON
				B.BudgetId = GL.BudgetId 
				
			LEFT OUTER JOIN (
							SELECT
								ACT.SnapshotId,
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#SnapshotGLAccountCategoryTranslationsPayroll ACT
							WHERE
								ACT.GLTranslationSubTypeCode = 'GL' 
							UNION ALL
							SELECT
								ACT.SnapshotId,
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#SnapshotGLAccountCategoryTranslationsOverhead ACT
							WHERE
								ACT.GLTranslationSubTypeCode = 'GL' 

						) GlAcHg ON 
						GlAcHg.GLAccountSubTypeId = Gl.GLAccountSubTypeIdGlobal AND
						GlAcHg.SnapshotId = B.SnapshotId
						
		 
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcGlobal ON GlAcGlobal.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0)))

			--AND Gl.AllocationUpdatedDate BETWEEN GlAcGlobal.StartDate AND GlAcGlobal.EndDate
			AND GlAcGlobal.SnapshotId = Gl.SnapshotId

PRINT 'Completed inserting #GlobalCategoryLookup:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
			
SET @StartTime = GETDATE()

CREATE UNIQUE CLUSTERED INDEX IX ON #GlobalCategoryLookup (SnapshotId, ReferenceCode)

UPDATE
	#ProfitabilityReforecast
SET
	GlobalGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END
FROM
	#GlobalCategoryLookup t1
WHERE
	t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode AND
	#ProfitabilityReforecast.BudgetReforecastTypeKey <> @ReforecastTypeIsTGBACTKey


PRINT 'Completed converting all GlobalGlAccountCategoryKey keys for Budgets:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))








-- ==============================================================================================================================================
-- Update #ProfitibilityReforecast.GlobalGlAccountCategoryKey for Actuals
-- ==============================================================================================================================================

--select * from #ProfitabilitySource

SET @StartTime = GETDATE()

UPDATE
	#ProfitabilityReforecast
SET
	GlobalGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM #ProfitabilityReforecast Gl

	LEFT OUTER JOIN #GLAccountCategoryMapping GLACM ON
		Gl.GlAccountKey = GLACM.GlAccountKey AND
		Gl.SnapshotId = GLACM.SnapshotId
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		--Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode =  CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLACM.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), GLACM.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), GLACM.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLACM.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLACM.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GLACM.GLAccountSubTypeId)) AND
		Gl.SnapshotId = GLAC.SnapshotId

where
	Gl.BudgetReforecastTypeKey = @ReforecastTypeIsTGBACTKey
	
PRINT ('Rows updated from #ProfitibilityReforecast.GlobalGlAccountCategoryKey for Actuals: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- ==============================================================================================================================================







---------------------------------------------------------------------------------------------
----  Register Unknowns
---------------------------------------------------------------------------------------------

--- Smoke All OLD TAPAS Unknowns were about to insert new ones (Reforecast Budget + Reforecast Actuals from [dbo].[ProfitabilityBudgetUnknowns])
SET @StartTime = GETDATE()

DELETE 
    PRU
FROM    
	[dbo].[ProfitabilityReforecastUnknowns] PRU
WHERE
  PRU.BudgetReforecastTypeKey IN (@ReforecastTypeIsTGBBUDKey, @ReforecastTypeIsTGBACTKey)

PRINT ('Rows Deleted that was OLD from ProfitabilitReforecastUnknowns: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-------------


SET @StartTime = GETDATE()

INSERT INTO [dbo].[ProfitabilityReforecastUnknowns]
	(
		ImportBatchId,
		CalendarKey,
		GlAccountKey,
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
		EUCorporateGlAccountCategoryKey,
		USPropertyGlAccountCategoryKey,
		USFundGlAccountCategoryKey,
		EUPropertyGlAccountCategoryKey,
		USCorporateGlAccountCategoryKey,
		DevelopmentGlAccountCategoryKey,
		EUFundGlAccountCategoryKey,
		GlobalGlAccountCategoryKey,	
		BudgetId,
		OverheadKey,
		FeeAdjustmentKey,
		BudgetReforecastTypeKey,
		SnapshotId
	)
SELECT
	PR.ImportBatchId,
	PR.CalendarKey,
	PR.GlAccountKey,
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
	@EUCorporateGlAccountCategoryKeyUnknown,
	@USPropertyGlAccountCategoryKeyUnknown,	
	@USFundGlAccountCategoryKeyUnknown, 	
	@EUPropertyGlAccountCategoryKeyUnknown,
	@USCorporateGlAccountCategoryKeyUnknown, 
	@DevelopmentGlAccountCategoryKeyUnknown,
	@EUFundGlAccountCategoryKeyUnknown, 
	PR.GlobalGlAccountCategoryKey,	
	PR.BudgetId,
	PR.OverheadKey,
	(SELECT FeeAdjustmentKey FROM GrReporting.dbo.FeeAdjustment WHERE FeeAdjustmentCode = 'NORMAL'),
	BudgetReforecastTypeKey,
	AB.SnapshotId
	
FROM 
	#ProfitabilityReforecast PR
	INNER JOIN #AllBudgets AB ON
		AB.BudgetId = PR.BudgetId AND
		AB.SnapshotId = PR.SnapshotId
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


--------------------------------------------------------------------------------------------
---  BUILD Unknown Budgets - Get all the budgets for Budget rows that have unknowns
-------------------------------------------------------------------------------------------
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

----------------------------------------------------------------------------------------------------
---  BUILD Unknown Actuals - Get all the budgets for Budget rows that have unknowns
----------------------------------------------------------------------------------------------------

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


------------------------------------------------------------------------------------------------------------------------------------------------------
---  BUILD ALL Unknown Budgets - Now merge them into one unique budget set and these are all budgets that need deleting
------------------------------------------------------------------------------------------------------------------------------------------------------
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
	
	IF @RowsToDeleteFromPRBudgets > 0 BEGIN
	    INSERT INTO @ImportErrorTable (Error) SELECT 'Unknown Budgets'
	END
	IF @RowsToDeleteFromPRActuals > 0 BEGIN
	    INSERT INTO @ImportErrorTable (Error) SELECT 'Unknown Actuals'
	END	
	
	
	/**************************************************** DELETIONS COMMENTED OUT FOR NOW, DELETE THIS COMMENT **************************
	
	---------------- Delete the unknown budget portions
	SET @StartTime = GETDATE()

	DELETE
		PR
	FROM
		#ProfitabilityReforecast PR
		INNER JOIN #BudgetsWithUnknownBudgets AUB ON
		  PR.BudgetId = AUB.BudgetId AND
		  PR.SnapshotId = AUB.SnapshotId AND
		  PR.BudgetReforecastTypeKey = AUB.BudgetReforecastTypeKey
	  
	PRINT ('Rows DELETED from #ProfitabilityReforecast that have Unknown Budgets: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	---------------- Delete the unknown actual portions
	SET @StartTime = GETDATE()

	DELETE
		PR
	FROM
		#ProfitabilityReforecast PR
		INNER JOIN #BudgetsWithUnknownActuals AUB ON
		  PR.BudgetId = AUB.BudgetId AND
		  PR.SnapshotId = AUB.SnapshotId AND
		  PR.BudgetReforecastTypeKey = AUB.BudgetReforecastTypeKey		  
	
	
	PRINT ('Rows DELETED from #ProfitabilityReforecast that have Unknown Actuals: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

			SET @StartTime = GETDATE()
			DELETE x
			FROM TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment x
			INNER JOIN #BudgetEmployeeFunctionalDepartment xh ON
				xh.ImportKey = x.ImportKey
			INNER JOIN #BudgetEmployee be ON
				be.BudgetEmployeeId = xh.BudgetEmployeeId
			INNER JOIN #AllUnknownBudgets d ON
				d.BudgetId = be.BudgetId

			PRINT 'Deleted from BudgetEmployeeFunctionalDepartment: ' + CONVERT(CHAR(10), @@ROWCOUNT)
			PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

			DELETE x
			FROM TapasGlobalBudgeting.BudgetEmployee x
			INNER JOIN #BudgetEmployee xh ON
				xh.ImportKey = x.ImportKey
			INNER JOIN #AllUnknownBudgets d ON
				d.BudgetId = xh.BudgetId

			PRINT 'Deleted from BudgetEmployee: ' + CONVERT(CHAR(10), @@ROWCOUNT)
			PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

			DELETE x
			FROM TapasGlobalBudgeting.BudgetEmployeePayrollAllocationDetail x
			INNER JOIN #BudgetEmployeePayrollAllocationDetail xh ON
				xh.ImportKey = x.ImportKey
			INNER JOIN #BudgetEmployeePayrollAllocation bpa ON
				bpa.BudgetEmployeePayrollAllocationId = xh.BudgetEmployeePayrollAllocationId
			INNER JOIN #BudgetProject bp ON
				bp.BudgetProjectId = bpa.BudgetProjectId
			INNER JOIN #AllUnknownBudgets d ON
				d.BudgetId = bp.BudgetId

			PRINT 'Deleted from BudgetEmployeePayrollAllocationDetail: ' + CONVERT(CHAR(10), @@ROWCOUNT)
			PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

			DELETE x
			FROM TapasGlobalBudgeting.BudgetEmployeePayrollAllocation x
			INNER JOIN #BudgetEmployeePayrollAllocation xh ON
				xh.ImportKey = x.ImportKey
			INNER JOIN #BudgetProject bp ON
				bp.BudgetProjectId = xh.BudgetProjectId
			INNER JOIN #AllUnknownBudgets d ON
				d.BudgetId = bp.BudgetId

			PRINT 'Deleted from BudgetEmployeePayrollAllocation: ' + CONVERT(CHAR(10), @@ROWCOUNT)
			PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

			DELETE x
			FROM TapasGlobalBudgeting.BudgetOverheadAllocationDetail x
			INNER JOIN #BudgetOverheadAllocationDetail xh ON
				xh.ImportKey = x.ImportKey
			INNER JOIN #BudgetProject bp ON
				bp.BudgetProjectId = xh.BudgetProjectId
			INNER JOIN #AllUnknownBudgets d ON
				d.BudgetId = bp.BudgetId

			PRINT 'Deleted from BudgetOverheadAllocationDetail: ' + CONVERT(CHAR(10), @@ROWCOUNT)
			PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

			DELETE x
			FROM TapasGlobalBudgeting.BudgetProject x
			INNER JOIN #BudgetProject xh ON
				xh.ImportKey = x.ImportKey
			INNER JOIN #AllUnknownBudgets d ON
				d.BudgetId = xh.BudgetId
				
			PRINT 'Deleted from BudgetProject: ' + CONVERT(CHAR(10), @@ROWCOUNT)
			PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

			DELETE x
			FROM TapasGlobalBudgeting.BudgetTaxType x
			INNER JOIN #BudgetTaxType xh ON
				xh.ImportKey = x.ImportKey
			INNER JOIN #AllUnknownBudgets d ON
				d.BudgetId = xh.BudgetId

			PRINT 'Deleted from BudgetTaxType: ' + CONVERT(CHAR(10), @@ROWCOUNT)
			PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

			DELETE x
			FROM TapasGlobalBudgeting.BudgetReportGroupDetail x
			INNER JOIN #AllUnknownBudgets b ON
				b.BudgetId = x.BudgetId 
				--b.ImportBatchId = x.ImportBatchId
			INNER JOIN #AllUnknownBudgets d ON
				d.BudgetId = b.BudgetId

			PRINT 'Deleted from BudgetReportGroupDetail: ' + CONVERT(CHAR(10), @@ROWCOUNT)
			PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

			DELETE x
			FROM TapasGlobalBudgeting.Budget x
			INNER JOIN #AllUnknownBudgets xh ON
				xh.ImportKey = x.ImportKey
			INNER JOIN #AllUnknownBudgets d ON
				d.BudgetId = xh.BudgetId

			PRINT 'Deleted from Budget: ' + CONVERT(CHAR(10), @@ROWCOUNT)
			PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
			
			
	**************************************************** DELETIONS COMMENTED OUT FOR NOW, DELETE THIS COMMENT **************************/








-- ==============================================================================================================================================












-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Insert modified and new data 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

SET @StartTime = GETDATE()

INSERT INTO GrReporting.dbo.ProfitabilityReforecast
(
	SnapshotId,
	BudgetReforecastTypeKey,
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
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
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
)
SELECT
    SnapshotId,
    BudgetReforecastTypeKey,
	CalendarKey,
	ReforecastKey, 
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	ConsolidationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	(Select FeeAdjustmentKey From GrReporting.dbo.FeeAdjustment Where FeeAdjustmentCode = 'NORMAL'),
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	
	@EUCorporateGlAccountCategoryKeyUnknown, --EUCorporateGlAccountCategoryKey,
	@EUPropertyGlAccountCategoryKeyUnknown, --EUPropertyGlAccountCategoryKey,
	@EUFundGlAccountCategoryKeyUnknown, --EUFundGlAccountCategoryKey,

	@USPropertyGlAccountCategoryKeyUnknown, --USPropertyGlAccountCategoryKey,
	@USCorporateGlAccountCategoryKeyUnknown, ----USCorporateGlAccountCategoryKey,
	@USFundGlAccountCategoryKeyUnknown, --USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	@DevelopmentGlAccountCategoryKeyUnknown --DevelopmentGlAccountCategoryKey
FROM 
	#ProfitabilityReforecast
DECLARE @RowsInsertedIntoProfitabilityReforecastWH INT = @@ROWCOUNT

print 'Rows Inserted in GrReporting.dbo.ProfitabilityReforecast:'+CONVERT(char(10),@RowsInsertedIntoProfitabilityReforecastWH)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


-- ==============================================================================================================================================
-- Mark budgets as being successfully processed into the warehouse
-- ==============================================================================================================================================

DECLARE @ImportErrorText VARCHAR(500)
SELECT @ImportErrorText = COALESCE(@ImportErrorText + ', ', '') + Error from @ImportErrorTable

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



-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Clean up
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
SET @StartTime = GETDATE()

DROP TABLE #SystemSettingRegion
DROP TABLE #SnapshotGLTranslationType
DROP TABLE #SnapshotGLTranslationSubType
DROP TABLE #SnapshotGLMajorCategory
DROP TABLE #SnapshotGLMinorCategory
DROP TABLE #SnapshotGLAccountType
DROP TABLE #SnapshotGLAccountSubType
DROP TABLE #SnapshotGLAccountCategoryTranslationsPayroll
DROP TABLE #BudgetReportGroupDetail
DROP TABLE #BudgetReportGroup
DROP TABLE #BudgetReportGroupPeriod
DROP TABLE #BudgetStatus
DROP TABLE #NewBudgets
--DROP TABLE #AllModifiedReportBudget
--DROP TABLE #LockedModifiedReportGroup
--DROP TABLE #FilteredModifiedReportBudget
--DROP TABLE #NewBudgets
DROP TABLE #BudgetProject
DROP TABLE #Region
DROP TABLE #BudgetEmployee
DROP TABLE #BudgetEmployeeFunctionalDepartment
DROP TABLE #SnapshotFunctionalDepartment
DROP TABLE #SnapshotPropertyFund
DROP TABLE #SnapshotPropertyFundMapping
DROP TABLE #SnapshotReportingEntityCorporateDepartment
DROP TABLE #SnapshotReportingEntityPropertyEntity
DROP TABLE #Location
DROP TABLE #RegionExtended
DROP TABLE #PayrollRegion
DROP TABLE #OverheadRegion
DROP TABLE #Project
DROP TABLE #BudgetEmployeePayrollAllocation
DROP TABLE #BudgetEmployeePayrollAllocationDetailBatches
DROP TABLE #BEPADa
DROP TABLE #BudgetEmployeePayrollAllocationDetail
DROP TABLE #BudgetTaxType
DROP TABLE #TaxType
DROP TABLE #EmployeePayrollAllocationDetail
DROP TABLE #BudgetOverheadAllocation
DROP TABLE #BudgetOverheadAllocationDetail
DROP TABLE #OverheadAllocationDetail
DROP TABLE #EffectiveFunctionalDepartment
DROP TABLE #ProfitabilityPreTaxSource
DROP TABLE #ProfitabilityTaxSource
DROP TABLE #ProfitabilityOverheadSource
DROP TABLE #ProfitabilityPayrollMapping
DROP TABLE #SnapshotOriginatingRegionCorporateEntity
DROP TABLE #SnapshotOriginatingRegionPropertyDepartment
DROP TABLE #SnapshotAllocationSubRegion
DROP TABLE #ProfitabilityReforecast
DROP TABLE #DeletingBudget

DROP TABLE #GLAccountCategoryMapping
DROP TABLE #SnapshotGLGlobalAccountTranslationType
DROP TABLE #SnapshotGLGlobalAccount
DROP TABLE #SnapshotGLGlobalAccountTranslationSubType


--DROP TABLE #EUCorpCategoryLookup
--DROP TABLE #EUPropCategoryLookup
--DROP TABLE #EUFundCategoryLookup
--DROP TABLE #USPropCategoryLookup
--DROP TABLE #USCorpCategoryLookup
--DROP TABLE #USFundCategoryLookup
DROP TABLE #GlobalCategoryLookup
--DROP TABLE #DevelCategoryLookup

DROP TABLE #BudgetsToProcess 

print 'Cleanup Completed:'+CONVERT(char(10),@RowsInsertedIntoProfitabilityReforecastWH)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
PRINT 'ALL DONE'

GO
--ROLLBACK



































































































USE [GrReportingStaging]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_I_BudgetsToProcess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_I_BudgetsToProcess]
GO

CREATE PROCEDURE [dbo].[stp_I_BudgetsToProcess]
	@IsTestExecution BIT = 0
AS

IF (@IsTestExecution = 1)
BEGIN
	PRINT ('dbo.stp_I_BudgetsToProcess is executing in test mode ...')
END

----============================================================================================================================================
-- ||||||||||||||||||||||||||||||||||||| Perform validity check on dbo.BudgetsToProcess table ||||||||||||||||||||||||||||||||||||||||||||||| --
----============================================================================================================================================

/*
	The 'BudgetProcessedIntoWarehouse' and 'DateBudgetProcessedIntoWarehouse' fields for all records in dbo.BudgetsToProcess
	should no longer be null. 'BudgetProcessedIntoWarehouse' should be either:
		- -1: The import of the budget failed because of a technical error (stored procedure failure etc)
		-  0: The budget was not imported because of unknowns
		-  1: The budget was imported successfully
		
	If any of the records still have 'BudgetProcessedIntoWarehouse' or 'DateBudgetProcessedIntoWarehouse' set to null, then
	it is likely that there was some sort of failure during the previous import that was not handled correctly. As such,
	set: 'BudgetProcessedIntoWarehouse' = -1, and 'DateBudgetProcessedIntoWarehouse' = current time [GetDate()]
*/

IF (@IsTestExecution = 0)
BEGIN

	IF EXISTS (SELECT * FROM dbo.BudgetsToProcess WHERE IsReforecast = 0 AND (
																				OriginalBudgetProcessedIntoWarehouse IS NULL OR
																				DateBudgetProcessedIntoWarehouse IS NULL OR
																				ImportBatchId IS NULL OR
																				BudgetSourceSystemSyncd IS NULL
																			))
	BEGIN

		PRINT ('Problems during the previous import were not handled correctly as ("OriginalBudgetProcessedIntoWarehouse" IS NULL OR "DateBudgetProcessedIntoWarehouse" IS NULL)')
		
		UPDATE
			dbo.BudgetsToProcess
		SET
			OriginalBudgetProcessedIntoWarehouse = CASE WHEN OriginalBudgetProcessedIntoWarehouse IS NULL THEN -1 ELSE OriginalBudgetProcessedIntoWarehouse END,
			ImportBatchId = CASE WHEN ImportBatchId IS NULL THEN -1 ELSE ImportBatchId END,
			BudgetSourceSystemSyncd = CASE WHEN BudgetSourceSystemSyncd IS NULL THEN 0 ELSE BudgetSourceSystemSyncd END,
			DateBudgetProcessedIntoWarehouse = CASE WHEN DateBudgetProcessedIntoWarehouse IS NULL THEN GETDATE() ELSE DateBudgetProcessedIntoWarehouse END,
			
			ReasonForFailure = CASE WHEN ReasonForFailure IS NULL THEN '' ELSE ReasonForFailure END +
								'Validity check in stp_I_BudgetsToProcess failed|' + -- NULL + string returns NULL, which is not what we want
								CASE WHEN OriginalBudgetProcessedIntoWarehouse IS NULL THEN 'OriginalBudgetProcessedIntoWarehouse IS NULL|' ELSE '' END +
								CASE WHEN ImportBatchId IS NULL THEN 'ImportBatchId IS NULL|' ELSE '' END +
								CASE WHEN BudgetSourceSystemSyncd IS NULL THEN 'BudgetSourceSystemSyncd IS NULL|' ELSE '' END +
								CASE WHEN DateBudgetProcessedIntoWarehouse IS NULL THEN 'DateBudgetProcessedIntoWarehouse IS NULL|' ELSE '' END
								
		WHERE
			IsReforecast = 0 AND
			(
				OriginalBudgetProcessedIntoWarehouse IS NULL OR
				DateBudgetProcessedIntoWarehouse IS NULL OR
				ImportBatchId IS NULL OR
				BudgetSourceSystemSyncd IS NULL
			)
		
		PRINT ('dbo.BudgetsToProcess Original Budget records updated.')
	END

	IF EXISTS (SELECT * FROM dbo.BudgetsToProcess WHERE IsReforecast = 1 AND (
																				ReforecastBudgetsProcessedIntoWarehouse IS NULL OR
																				ReforecastActualsProcessedIntoWarehouse IS NULL OR
																				DateBudgetProcessedIntoWarehouse IS NULL OR
																				ImportBatchId IS NULL OR
																				BudgetSourceSystemSyncd IS NULL
																			  ))
	BEGIN

		PRINT ('Problems during the previous import were not handled correctly as ("ReforecastBudgetsProcessedIntoWarehouse" IS NULL OR "ReforecastActualsProcessedIntoWarehouse" IS NULL OR "DateBudgetProcessedIntoWarehouse" IS NULL)')
		
		UPDATE
			dbo.BudgetsToProcess
		SET
			ReforecastActualsProcessedIntoWarehouse = CASE WHEN ReforecastActualsProcessedIntoWarehouse IS NULL THEN -1 ELSE ReforecastActualsProcessedIntoWarehouse END,
			ReforecastBudgetsProcessedIntoWarehouse = CASE WHEN ReforecastBudgetsProcessedIntoWarehouse IS NULL THEN -1 ELSE ReforecastBudgetsProcessedIntoWarehouse END,
			DateBudgetProcessedIntoWarehouse = CASE WHEN DateBudgetProcessedIntoWarehouse IS NULL THEN GETDATE() ELSE DateBudgetProcessedIntoWarehouse END,
			ImportBatchId = CASE WHEN ImportBatchId IS NULL THEN -1 ELSE ImportBatchId END,
			BudgetSourceSystemSyncd = CASE WHEN BudgetSourceSystemSyncd IS NULL THEN 0 ELSE BudgetSourceSystemSyncd END,

			ReasonForFailure = CASE WHEN ReasonForFailure IS NULL THEN '' ELSE ReasonForFailure END + 'Validity check in stp_I_BudgetsToProcess failed|' + -- NULL + string returns NULL, which is not what we want
								CASE WHEN ReforecastActualsProcessedIntoWarehouse IS NULL THEN 'ReforecastActualsProcessedIntoWarehouse IS NULL|' ELSE '' END +
								CASE WHEN ReforecastBudgetsProcessedIntoWarehouse IS NULL THEN 'ReforecastBudgetsProcessedIntoWarehouse IS NULL|' ELSE '' END +
								CASE WHEN DateBudgetProcessedIntoWarehouse IS NULL THEN 'DateBudgetProcessedIntoWarehouse IS NULL|' ELSE '' END +
								CASE WHEN ImportBatchId IS NULL THEN 'ImportBatchId IS NULL|' ELSE '' END +
								CASE WHEN BudgetSourceSystemSyncd IS NULL THEN 'BudgetSourceSystemSyncd IS NULL|' ELSE '' END
			
		WHERE
			IsReforecast = 1 AND
			(
				ReforecastBudgetsProcessedIntoWarehouse IS NULL OR
				ReforecastActualsProcessedIntoWarehouse IS NULL OR
				DateBudgetProcessedIntoWarehouse IS NULL OR
				ImportBatchId IS NULL OR
				BudgetSourceSystemSyncd IS NULL
			)
		
		PRINT ('"ReforecastActualsProcessedIntoWarehouse" and "ReforecastBudgetsProcessedIntoWarehouse" updated to -1 and "DateBudgetProcessedIntoWarehouse" updated to GETDATE() where either is currently NULL.')
	END

END


----============================================================================================================================================
-- ||||||||||||||||||||||||||||||||||||||||||| Declare variables and create common tables ||||||||||||||||||||||||||||||||||||||||||||||||||| --
----============================================================================================================================================

-- At present there is no way to determine which GBS or TAPAS budget is used for a given reforecast. In other words, there's no absolute way to
-- determine which GBS and TAPAS budgets are used for the 2011 Q1 reforecast, for instance.
-- To help determine which budgets/reforecasts are linked to a given reforecast (Q0 -> Q3), a mapping between reforecasts and BudgetAllocationSet
-- is created.

CREATE TABLE #BudgetAllocationSetYearQuarterMapping (
	BudgetAllocationSetId INT NOT NULL,
	BudgetYear INT NOT NULL,
	BudgetQuarter CHAR(2) NOT NULL
)

INSERT INTO #BudgetAllocationSetYearQuarterMapping
SELECT
	1 AS BudgetAllocationSetId,
	2011 AS BudgetYear,
	'Q0' AS BudgetQuarter
UNION
SELECT
	9 AS BudgetAllocationSetId,
	2011 AS BudgetYear,
	'Q1' AS BudgetQuarter
UNION
SELECT
	10 AS BudgetAllocationSetId,
	2011 AS BudgetYear,
	'Q2' AS BudgetQuarter
------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE #BudgetSnapshotMapping ( -- #BudgetSnapshotMapping: contains all possible Budget to Snapshot mappings
	BudgetSnapshotMappingId INT IDENTITY(1,1) NOT NULL,
	[Year] INT NOT NULL,
	Period INT NOT NULL,
	BudgetReforecastTypeName VARCHAR(32) NOT NULL,
	BudgetId INT NOT NULL,
	Name VARCHAR (100) NOT NULL,
	IsReforecast BIT NOT NULL,
	LastLockedDate DATETIME NULL,
	LastImportBudgetIntoGRDate DATETIME NULL,
	ImportBudgetIntoGR BIT NOT NULL,
	BudgetReportGroupId INT NULL,
	BudgetExchangeRateId INT NOT NULL,
	BudgetReportGroupPeriodId INT NOT NULL,
	BudgetAllocationSetId INT NOT NULL,
	SnapshotId INT NOT NULL,
	SnapshotIsLocked BIT NOT NULL,
	SnapshotLastSyncDate DATETIME NULL,
	SnapshotManualUpdatedDate DATETIME NULL
	
)
INSERT INTO #BudgetSnapshotMapping (
	[Year],
	Period,
	BudgetReforecastTypeName,
	BudgetId,
	Name,
	IsReforecast,
	LastLockedDate,
	LastImportBudgetIntoGRDate,
	ImportBudgetIntoGR,
	BudgetReportGroupId,
	BudgetExchangeRateId,
	BudgetReportGroupPeriodId,
	BudgetAllocationSetId,
	SnapshotId,
	SnapshotIsLocked,
	SnapshotLastSyncDate,
	SnapshotManualUpdatedDate
)
SELECT
	BRGP.[Year],
	BRGP.Period,
	TAPASGBSBudgets.BudgetReforecastTypeName,
	TAPASGBSBudgets.BudgetId,
	TAPASGBSBudgets.Name,
	TAPASGBSBudgets.IsReforecast,
	TAPASGBSBudgets.LastLockedDate,
	TAPASGBSBudgets.LastImportBudgetIntoGRDate,
	TAPASGBSBudgets.ImportBudgetIntoGR,
	TAPASGBSBudgets.BudgetReportGroupId,
	TAPASGBSBudgets.BudgetExchangeRateId,
	TAPASGBSBudgets.BudgetReportGroupPeriodId,
	TAPASGBSBudgets.BudgetAllocationSetId,
	S.SnapshotId,
	S.IsLocked,
	S.LastSyncDate,
	S.ManualUpdatedDate
FROM
	SERVER3.GDM.dbo.BudgetReportGroupPeriod BRGP
	
	INNER JOIN (
	
		SELECT DISTINCT
			'TGB Budget/Reforecast' AS BudgetReforecastTypeName,
			BudgetTAPAS.BudgetId,
			BudgetTAPAS.Name,
			BudgetTAPAS.IsReforecast,
			BudgetTAPAS.LastLockedDate,
			BudgetTAPAS.LastImportBudgetIntoGRDate,
			BudgetTAPAS.ImportBudgetIntoGR,
			BudgetTAPAS.BudgetAllocationSetId,
			BRG.BudgetReportGroupId,
			BRG.BudgetReportGroupPeriodId,
			BRG.BudgetExchangeRateId
		FROM
			SERVER3.TAPASUS_Budgeting.Budget.Budget BudgetTAPAS
			INNER JOIN SERVER3.TAPASUS_Budgeting.[Admin].BudgetReportGroupDetail BRGD ON
				BudgetTAPAS.BudgetId = BRGD.BudgetId
			INNER JOIN SERVER3.TAPASUS_Budgeting.[Admin].BudgetReportGroup BRG ON
				BRGD.BudgetReportGroupId = BRG.BudgetReportGroupId
			INNER JOIN SERVER3.GDM.dbo.BudgetReportGroupPeriod BRGP ON
				BRG.BudgetReportGroupPeriodId = BRGP.BudgetReportGroupPeriodId
		WHERE
			BudgetTAPAS.IsDeleted = 0 AND
			BRGD.IsDeleted = 0 AND
			BRG.IsDeleted = 0 AND
			BRGP.IsDeleted = 0 AND
			BRGP.[Year] > 2010
	
		UNION ALL

		SELECT
			'GBS Budget/Reforecast' AS BudgetReforecastTypeName,
			BudgetGBS.BudgetId,
			BudgetGBS.Name,
			BudgetGBS.IsReforecast,
			BudgetGBS.LastLockedDate,
			BudgetGBS.LastImportBudgetIntoGRDate,
			BudgetGBS.ImportBudgetIntoGR,
			BudgetGBS.BudgetAllocationSetId,
			NULL As BudgetReportGroupId,
			BudgetGBS.BudgetReportGroupPeriodId,
			BudgetGBS.BudgetExchangeRateId
		FROM
			SERVER3.GBS.dbo.Budget BudgetGBS			
		WHERE
			BudgetGBS.IsActive = 1
	
	) TAPASGBSBudgets ON
		BRGP.BudgetReportGroupPeriodId = TAPASGBSBudgets.BudgetReportGroupPeriodId
		
	INNER JOIN SERVER3.GDM.dbo.[Snapshot] S ON
		TAPASGBSBudgets.BudgetAllocationSetId = S.GroupKey
	
WHERE
	BRGP.[Year] > 2010 AND
	BRGP.IsDeleted = 0 AND
	S.GroupName = 'BudgetAllocationSet'

------------------------

-- Find all budgets and reforecasts for 2011 that have been processed into the warehouse
-- drop table #ExistingBudgetsReforecasts

CREATE TABLE #ExistingBudgetsReforecasts (
	BudgetId INT NOT NULL,
	BudgetReforecastTypeName VARCHAR(32) NOT NULL,
	IsReforecast BIT NOT NULL,
	SnapshotId INT NOT NULL
)
INSERT INTO #ExistingBudgetsReforecasts

SELECT
	ExistingBudgetsReforecasts.BudgetId,
	BRT.BudgetReforecastTypeName,
	ExistingBudgetsReforecasts.IsReforecast,
	ExistingBudgetsReforecasts.SnapshotId
FROM
(
	-- Get 2011 Original Budgets in the warehouse
	SELECT DISTINCT
		PB.BudgetId,
		PB.BudgetReforecastTypeKey,
		0 AS IsReforecast,
		PB.SnapshotId
	FROM
		GrReporting.dbo.ProfitabilityBudget PB
		INNER JOIN GrReporting.dbo.Calendar C ON
			PB.CalendarKey = C.CalendarKey
	WHERE
		C.CalendarYear = 2011
		
	UNION ALL

	-- Get 2011 Reforecasts in the warehouse	
	SELECT DISTINCT
		PR.BudgetId,
		PR.BudgetReforecastTypeKey,
		1 AS IsReforecast,
		PR.SnapshotId
	FROM
		GrReporting.dbo.ProfitabilityReforecast PR
		INNER JOIN GrReporting.dbo.Calendar C ON
			PR.CalendarKey = C.CalendarKey
	WHERE
		C.CalendarYear = 2011

)	ExistingBudgetsReforecasts
	INNER JOIN GrReporting.dbo.BudgetReforecastType BRT ON
		ExistingBudgetsReforecasts.BudgetReforecastTypeKey = BRT.BudgetReforecastTypeKey

/*
================================================================================================================================================
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
	A: Find all budgets that are to be processed into the warehouse because they have been flagged to be imported:
		1. An unlocked budget's ImportBudgetIntoGR field is set to 1
		2. A locked budget's LastLockedDate in GBS/TAPAS is greater than the budget's LastLockedDate in GrReportingStaging.GBS/TAPAS
			(or if the budget has been locked for the first time)
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
==============================================================================================================================================
*/

/*	The ImportBudgetFromSourceSystem and ImportSnapshotFromSourceSystem fields are of data type INT and not BIT because aggregate functions are
		to be applied to them. */

CREATE TABLE #BudgetsToProcess (
	BudgetReforecastTypeName VARCHAR(32) NOT NULL, -- 'GBS Budget/Reforecast' or 'TGB Budget/Reforecast'
	BudgetId INT NOT NULL,						   -- either the GBS or TAPAS budget id	
	BudgetExchangeRateId INT NOT NULL,
	BudgetReportGroupPeriodId INT NOT NULL,
	BudgetAllocationSetId INT NOT NULL,
	ImportBudgetFromSourceSystem INT NOT NULL,	   -- true if the budget is required to be imported/reimported from GBS AND reprocessed into the
												   -- warehouse because of changes to the budget. If False, then the budget only requires
												   -- reprocessing into the warehouse, and not reimporting from the source system as well.
	IsReforecast BIT NOT NULL,				       -- will be set to 1 when reforecasts are processed
	SnapshotId INT NULL,
	ImportSnapshotFromSourceSystem INT NOT NULL,
	MustImportAllActualsIntoWarehouse INT NULL     -- Initially set to null because we will determine whether actuals need to be imported later
)

/* These include:
		1. All locked _budgets_ that have been processed into the warehouse whose LastLockedDates have changed since they were last imported
		2. All locked _budgets_ that have never been processed into the warehouse before
		3. All unlocked _budgets_ whose ImportBudgetIntoGR fields are set to 1 */

INSERT INTO #BudgetsToProcess
SELECT
	BSM.BudgetReforecastTypeName,			  -- SourceSystemId
	BSM.BudgetId,							  -- BudgetId
	BSM.BudgetExchangeRateId,				  -- BudgetExchangeRateId
	BSM.BudgetReportGroupPeriodId,			  -- BudgetReportGroupPeriodId
	BSM.BudgetAllocationSetId,				  -- BudgetAllocationSet
	1 AS ImportBudgetFromSourceSystem,		  -- ImportBudgetFromSourceSystem: the budget needs to be reimported from GBS because the budget has changed since it was last imported
	BSM.IsReforecast,						  -- IsReforecast: budget is not a reforecast
	BSM.SnapshotId,							  -- SnapshotId
	0 AS ImportSnapshotFromSourceSystem,	  -- ImportSnapshotFromSourceSystem: don't know whether the snapshot has changed and needs repimporting - assume it doesn't
	
	CASE WHEN
		BSM.IsReforecast = 1			-- If the budget is a reforecast ...
	THEN
		
		CASE WHEN
			BSM.LastLockedDate IS NULL			  -- If the budget is not locked ...
		THEN
			1									  --  ... keep reimporting all of its actuals
		ELSE
			0									  -- if the budget is locked, assume that all of its actuals have already been imported
		END
		
	ELSE
		NULL							-- Else the budget must be an original budget, so is NULL because of the check constraint
											  
	END	AS MustImportAllActualsIntoWarehouse  -- MustImportAllActualsIntoWarehouse: don't know whether all actuals need importing, assume they don't (i.e.: only import fee actuals)	

FROM
	#BudgetSnapshotMapping BSM
WHERE
	--BSM.BudgetReforecastTypeName = 'GBS Budget/Reforecast' AND
	(	-- if the budget has been relocked since it was originally processed into the warehouse, or it has never been imported (point 2. above)
		-- (i.e.: LastImportBudgetIntoGR is NULL), then import it
		(
			BSM.LastLockedDate IS NOT NULL AND
			BSM.LastLockedDate > ISNULL(BSM.LastImportBudgetIntoGRDate, '1900-01-01')
		)
		OR
		(
			BSM.LastLockedDate IS NULL AND
			BSM.ImportBudgetIntoGR = 1
		)
	)

/*
--==============================================================================================================================================
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
	 B: Find all budgets in the warehouse that are associated with snapshots that have been resync'd (if the snapshot is unlocked) or manually
		changed (if the snapshot is locked) since these budgets were last imported.
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --		
--==============================================================================================================================================
*/

/*
	But first ...
		For all snapshots that are linked to budgets that are to be processed into the warehosue, set these snapshots to be imported
		(set ImportSnapshotFromSourceSystem = 1) where the snapshot has never been used before to processed a budget into either
		dbo.ProfitabilityBudget or dbo.ProfitabilityReforecast
*/

UPDATE
	BTP
SET
	BTP.ImportSnapshotFromSourceSystem = 1
FROM
	#BudgetsToProcess BTP
	
	LEFT OUTER JOIN #ExistingBudgetsReforecasts ExistingBudgetsReforecasts ON
		BTP.SnapshotId = ExistingBudgetsReforecasts.SnapshotId
		--BTP.BudgetReforecastTypeName = ExistingBudgetsReforecasts.BudgetReforecastTypeName AND
		--BTP.BudgetId = ExistingBudgetsReforecasts.BudgetId AND
		--BTP.IsReforecast = ExistingBudgetsReforecasts.IsReforecast
WHERE
	ExistingBudgetsReforecasts.BudgetId IS NULL

/* If an unlocked snapshot has changed it is only reimported if it is used by a budget that is to be imported */

-- Determine which snapshots (that are used by budgets in the warehouse) require reimporting and which budgets (that have previously been
--		processed into the warehouse) require reprocessing as a result.

INSERT INTO #BudgetsToProcess
SELECT DISTINCT
	BSM.BudgetReforecastTypeName,		   -- SourceSystemId
	BSM.BudgetId,						   -- BudgetId: The Budgets that are linked to the snapshots that have changed [from 2]. 
	BSM.BudgetExchangeRateId,			   -- BudgetExchangeRateId,
	BSM.BudgetReportGroupPeriodId,		   -- BudgetReportGroupPeriodId
	BSM.BudgetAllocationSetId,			   -- BudgetAllocationSetId	
	0 AS ImportBudgetFromSourceSystem,	   -- ImportBudgetFromSourceSystem: Assume that the budget doesn't require importing. If it does it should have been identified in [A] above
	BSM.IsReforecast,					   -- IsReforecast
	BSM.SnapshotId,						   -- SnapshotId
	1 AS ImportSnapshotFromSourceSystem,   -- ImportSnapshotFromSourceSystem: we know from the joins below that these snapshots have been modified and need to be reimported

	CASE WHEN
		BSM.IsReforecast = 0
	THEN
		NULL							   -- NULL because of the check constraint on the dbo.BudgetsToProcess
	ELSE
		0
	END AS MustImportAllActualsIntoWarehouse -- MustImportAllActualsIntoWarehouse: changes in snapshot should not have any affect on the budget
										     -- If a budget is locked, its snapshot has to be locked
FROM
	#ExistingBudgetsReforecasts ExistingBudgetsReforecasts
	
	INNER JOIN #BudgetSnapshotMapping BSM ON
		ExistingBudgetsReforecasts.BudgetId = BSM.BudgetId AND
		ExistingBudgetsReforecasts.BudgetReforecastTypeName = BSM.BudgetReforecastTypeName AND
		ExistingBudgetsReforecasts.IsReforecast = BSM.IsReforecast
		
	INNER JOIN GrReportingStaging.GDM.[Snapshot] SnapshotStaging ON
		BSM.SnapshotId = SnapshotStaging.SnapshotId

WHERE	
	-- If the snapshot is unlocked and GDM_Support.dbo.Snapshot.LastSyncDate > GrReportingStaging.GDM.Snapshot.LastSyncDate (i.e.: has changed),
	-- AND the snapshot is being used by a budget that is to be imported, the snapshot must be reimported and the budgets in the
	-- warehouse that use it must be reprocessed.
	-- This is because a budget must not be reprocessed purely because the unlocked snapshot that it uses has changed. Only if the
	-- snapshot is being used by a budget that is set to be imported must the budgets in the warehouse that use this snapshot be
	-- reprocessed.
	(
		BSM.SnapshotIsLocked = 0 AND
		ISNULL(BSM.SnapshotLastSyncDate, '1900-01-01') > ISNULL(SnapshotStaging.LastSyncDate, '1900-01-01')
		--AND BSM.SnapshotId IN (SELECT DISTINCT SnapshotId FROM #BudgetSnapshotMapping)
	)

	OR
	-- If the snapshot is unlocked in Staging but has since been locked in GDM_Support.dbo.Snapshot 
	(
		BSM.SnapshotIsLocked <> SnapshotStaging.IsLocked
	)

	------------------------------------------------------------------------------------------------------------------------

--==============================================================================================================================================
-- ||||||||||||||||||||| C: For reforecasts, determine whether reforecast actuals require processing into the warehouse ||||||||||||||||||||| --
--==============================================================================================================================================

-- Import actuals 

UPDATE
	BTP
SET
	BTP.MustImportAllActualsIntoWarehouse = 1
FROM
	#BudgetsToProcess BTP
	
	LEFT OUTER JOIN (
		-- Find all reforecasts that have previously been processed whose actuals were marked for import (MustImportAllActualsIntoWarehouse = 1),
		-- and were subsequently processed successfully into the warehouse (ReforecastActualsProcessedIntoWarehouse = 1)
		-- We don't want to import these budgets' actuals again (hence the left outer join and where clause below)
		SELECT
			BudgetReforecastTypeName,
			BudgetId
		FROM
			GrReportingStaging.dbo.BudgetsToProcess			
		WHERE
			IsReforecast = 1 AND -- Only consider reforecast as original budgets do not have 'Actual' components
			(
				MustImportAllActualsIntoWarehouse = 1 AND
				ReforecastActualsProcessedIntoWarehouse = 1
			)

	) ReforecastActualsPreviouslyProcessed ON
		BTP.BudgetReforecastTypeName = ReforecastActualsPreviouslyProcessed.BudgetReforecastTypeName AND
		BTP.BudgetId = ReforecastActualsPreviouslyProcessed.BudgetId

WHERE
	ReforecastActualsPreviouslyProcessed.BudgetId IS NULL AND
	BTP.IsReforecast = 1


--==============================================================================================================================================
-- ||||||||||||||||||||||| D: Determine whether budget and snapshot data require importing from the source system ||||||||||||||||||||||||||| --
--==============================================================================================================================================

CREATE TABLE #BudgetsToProcessPreInsert (
	BudgetReforecastTypeName VARCHAR(32) NOT NULL, -- 'GBS Budget/Reforecast' or 'Tapas Budgeting'
	BudgetId INT NOT NULL,						   -- Either the GBS or TAPAS budget id	
	BudgetExchangeRateId INT NOT NULL,
	BudgetReportGroupPeriodId INT NOT NULL,
	BudgetAllocationSetId INT NOT NULL,
	ImportBudgetFromSourceSystem INT NOT NULL,	   -- True if the budget is required to be imported/reimported from GBS because of changes to the budget
	IsReforecast BIT NOT NULL,					   -- Will be set to 1 when reforecasts are processed
	SnapshotId INT NULL,
	ImportSnapshotFromSourceSystem INT NOT NULL,
	MustImportAllActualsIntoWarehouse INT NULL	   -- Initially set to 0 because we will determine whether actuals need to be imported in D
)

INSERT INTO #BudgetsToProcessPreInsert
SELECT
	BTP.BudgetReforecastTypeName,
	BTP.BudgetId,
	BTP.BudgetExchangeRateId,
	BTP.BudgetReportGroupPeriodId,
	BTP.BudgetAllocationSetId,
	BTPBudgets.ImportBudgetFromSourceSystem, --CAST(MAX(BTP.ImportBudgetFromSourceSystem) AS BIT) AS ImportBudgetFromSourceSystem,
	BTP.IsReforecast,
	BTP.SnapshotId,
	BTPSnapshot.ImportSnapshotFromSourceSystem, --CAST(MAX(BTP.ImportSnapshotFromSourceSystem) AS BIT) AS ImportSnapshotFromSourceSystem,
	BTPBudgets.MustImportAllActualsIntoWarehouse --CAST(MAX(BTP.MustImportAllActualsIntoWarehouse) AS BIT) AS MustImportAllActualsIntoWarehouse
FROM
	#BudgetsToProcess BTP
	
	INNER JOIN
	(
		SELECT
			SnapshotId,
			CAST(MAX(ImportSnapshotFromSourceSystem) AS BIT) AS ImportSnapshotFromSourceSystem
		FROM
			#BudgetsToProcess
		GROUP BY
			SnapshotId

	) BTPSnapshot ON
		BTP.SnapshotId = BTPSnapshot.SnapshotId

	INNER JOIN
	(
		SELECT
			BudgetReforecastTypeName,
			--BudgetId,
			BudgetReportGroupPeriodId,	
			CAST(MAX(MustImportAllActualsIntoWarehouse) AS BIT) AS MustImportAllActualsIntoWarehouse,
			CAST(MAX(ImportBudgetFromSourceSystem) AS BIT) AS ImportBudgetFromSourceSystem
		FROM
			#BudgetsToProcess
		GROUP BY
			BudgetReforecastTypeName,
			--BudgetId,
			BudgetReportGroupPeriodId

	) BTPBudgets ON
		BTP.BudgetReforecastTypeName = BTPBudgets.BudgetReforecastTypeName AND
		--BTP.BudgetId = BTPBudgets.BudgetId AND
		BTP.BudgetReportGroupPeriodId = BTPBudgets.BudgetReportGroupPeriodId



--==============================================================================================================================================
-- ||||||||||||||||||||||||||||||||||||||| E: Insert data into GrReportingStaging.dbo.BudgetsToProcess |||||||||||||||||||||||||||||||||||||| --
--==============================================================================================================================================

DECLARE @NextBatchId INT = (ISNULL((SELECT MAX(BatchId) FROM dbo.BudgetsToProcess), 0) + 1)

	SELECT DISTINCT
		@NextBatchId AS BatchId,

		-------
		CASE WHEN
			BTP.ImportBudgetFromSourceSystem = 1
			/* If the budget is to be imported from the source system, the ImportBatchId for that import will be determine after the budget data
			   has been imported by the SSIS package(s) (the final step of the GBS and TAPAS master packages updates the ImportBatchId field in
			   dbo.BudgetsToProcess - the step before this finalizes the entry into dbo.Batch) */
		THEN
			NULL
		ELSE
			/* If the budget does not need importing from the budget source system, then this implies that a budget batch that already exists in
			   either GrReportingStaging.GBS... or GrReportingStaging.TapasGlobalBudgeting will be used and reprocessed into the warehouse. The
			   last budget set to be imported into GrReportingStaging will be used for reprocessing into the warehouse, as this is the last
			   budget set to be processed (into the warehouse).
			*/			
			CASE WHEN
				BTP.BudgetReforecastTypeName = 'GBS Budget/Reforecast'
			THEN
				(SELECT MAX(ImportBatchId) FROM GrReportingStaging.GBS.Budget WHERE BudgetId = BTP.BudgetId)
			ELSE -- BTP.BudgetReforecastTypeName must be 'TGB Budget/Reforecast'
				(SELECT MAX(ImportBatchId) FROM GrReportingStaging.TapasGlobalBudgeting.Budget WHERE BudgetId = BTP.BudgetId)
			END
			
		END AS ImportBatchId,
		-------
		
		BTP.BudgetReforecastTypeName,
		BTP.BudgetId,
		BTP.BudgetExchangeRateId,
		BTP.BudgetReportGroupPeriodId,
		BTP.ImportBudgetFromSourceSystem,
		BTP.IsReforecast,
		BTP.SnapshotId,
		BTP.ImportSnapshotFromSourceSystem,
		BTP.MustImportAllActualsIntoWarehouse,
		BASYQM.BudgetYear,
		BASYQM.BudgetQuarter
	INTO
		#BudgetsToProcessToInsert
	FROM
		#BudgetsToProcessPreInsert BTP
		LEFT OUTER JOIN #BudgetAllocationSetYearQuarterMapping BASYQM ON
			BTP.BudgetAllocationSetId = BASYQM.BudgetAllocationSetId

-----------------------------------------------------------------------------------------------------

IF (@IsTestExecution = 1)
BEGIN

	SELECT
		BatchId,
		ImportBatchId,
		BudgetReforecastTypeName,
		BudgetId,
		BudgetExchangeRateId,
		BudgetReportGroupPeriodId,
		ImportBudgetFromSourceSystem,
		IsReforecast,
		SnapshotId,
		ImportSnapshotFromSourceSystem,
		MustImportAllActualsIntoWarehouse,
		BudgetYear,
		BudgetQuarter	
	FROM
		#BudgetsToProcessToInsert

END
ELSE
BEGIN

	INSERT INTO dbo.BudgetsToProcess (
		BatchId,
		ImportBatchId,
		BudgetReforecastTypeName,
		BudgetId,
		BudgetExchangeRateId,
		BudgetReportGroupPeriodId,
		ImportBudgetFromSourceSystem,
		IsReforecast,
		SnapshotId,
		ImportSnapshotFromSourceSystem,
		MustImportAllActualsIntoWarehouse,
		BudgetYear,
		BudgetQuarter
	)
	SELECT
		BatchId,
		ImportBatchId,
		BudgetReforecastTypeName,
		BudgetId,
		BudgetExchangeRateId,
		BudgetReportGroupPeriodId,
		ImportBudgetFromSourceSystem,
		IsReforecast,
		SnapshotId,
		ImportSnapshotFromSourceSystem,
		MustImportAllActualsIntoWarehouse,
		BudgetYear,
		BudgetQuarter	
	FROM
		#BudgetsToProcessToInsert

END

--==============================================================================================================================================
-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| F: Clean up |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--==============================================================================================================================================

IF 	OBJECT_ID('tempdb..#BudgetsToProcess') IS NOT NULL
	DROP TABLE #BudgetsToProcess

IF 	OBJECT_ID('tempdb..#BudgetSnapshotMapping') IS NOT NULL
	DROP TABLE #BudgetSnapshotMapping
	
IF 	OBJECT_ID('tempdb..#BudgetsToProcessPreInsert') IS NOT NULL
	DROP TABLE #BudgetsToProcessPreInsert

IF 	OBJECT_ID('tempdb..#ExistingBudgetsReforecasts') IS NOT NULL	
	DROP TABLE #ExistingBudgetsReforecasts

IF 	OBJECT_ID('tempdb..#BudgetAllocationSetYearQuarterMapping') IS NOT NULL	
	DROP TABLE #BudgetAllocationSetYearQuarterMapping
