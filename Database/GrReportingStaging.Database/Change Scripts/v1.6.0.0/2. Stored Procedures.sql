/*

stp_D_GBSBudget
stp_I_BudgetsToProcess
stp_IU_LoadGrProfitabiltyGBSBudget
stp_IU_LoadGrProfitabiltyPayrollOriginalBudget
stp_U_SyncBudgetsProcessed

*/

USE [GrReportingStaging]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]    Script Date: 02/04/2011 18:03:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyGBSBudget]    Script Date: 02/04/2011 18:03:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyGBSBudget]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyGBSBudget]
GO
/****** Object:  StoredProcedure [dbo].[stp_U_SyncBudgetsProcessed]    Script Date: 02/04/2011 18:03:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_U_SyncBudgetsProcessed]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_U_SyncBudgetsProcessed]
GO
/****** Object:  StoredProcedure [dbo].[stp_D_GBSBudget]    Script Date: 02/04/2011 18:03:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_D_GBSBudget]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_D_GBSBudget]
GO
/****** Object:  StoredProcedure [dbo].[stp_I_BudgetsToProcess]    Script Date: 02/04/2011 18:03:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_I_BudgetsToProcess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_I_BudgetsToProcess]
GO
/****** Object:  StoredProcedure [dbo].[stp_I_BudgetsToProcess]    Script Date: 02/04/2011 18:03:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_I_BudgetsToProcess]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[stp_I_BudgetsToProcess]
AS

----========================================================================================================================
---- Declare variables and create common tables
----========================================================================================================================

DELETE
FROM
	dbo.BudgetsToProcess

DECLARE @GBSSourceSystemId INT = (SELECT SourceSystemId FROM GrReporting.dbo.SourceSystem WHERE Name = ''Global Budgeting System'')
DECLARE @TAPASSourceSystemId INT = (SELECT SourceSystemId FROM GrReporting.dbo.SourceSystem WHERE Name = ''Tapas Budgeting'')

CREATE TABLE #BudgetsToProcess (
	SourceSystemId INT NOT NULL, -- GBS or TAPAS
	BudgetId INT NOT NULL, -- either the GBS or TAPAS budget id	
	ImportBudgetFromSourceSystem INT NOT NULL, -- true if the budget is required to be imported/reimported from GBS because of changes to the budget
	IsReforecast BIT NOT NULL, -- will be set to 1 when reforecasts are processed
	SnapshotId INT NULL,
	ImportSnapshotFromSourceSystem INT NOT NULL
)

-- The ImportBudgetFromSourceSystem and ImportSnapshotFromSourceSystem fields are of data type INT and not BIT because aggregate functions are
-- to be applied to them.

CREATE TABLE #BudgetSnapshotMapping ( -- #BudgetSnapshotMapping: contains all possible Budget to Snapshot mappings
	SourceSystemId INT NOT NULL,
	BudgetId INT NOT NULL,
	SnapshotId INT NOT NULL,
	SnapshotIsLocked BIT NOT NULL,
	IsReforecast BIT NOT NULL
)
INSERT INTO #BudgetSnapshotMapping

SELECT -- GBS
	@GBSSourceSystemId,
	B.BudgetId,
	S.SnapshotId,
	S.IsLocked,
	B.IsReforecast
FROM
	SERVER3.GBS.dbo.Budget B
	INNER JOIN SERVER3.GDM.dbo.[Snapshot] S ON
		B.BudgetAllocationSetId = S.GroupKey
WHERE
	S.GroupName = ''BudgetAllocationSet''

UNION ALL

SELECT -- TAPAS
	@TAPASSourceSystemId,
	B.BudgetId,
	S.SnapshotId,
	S.IsLocked,
	B.IsReforecast
FROM
	SERVER3.TAPASUS_Budgeting.Budget.Budget B
	INNER JOIN SERVER3.GDM.dbo.[Snapshot] S ON
		B.BudgetAllocationSetId = S.GroupKey
WHERE
	S.GroupName = ''BudgetAllocationSet''


--========================================================================================================================
-- A: Find all budgets that are to be processed into the warehouse (and therefore require importing into staging)
--========================================================================================================================

-- GBS: These include:
--		1. All locked _budgets_ that have been processed into the warehouse whose LastLockedDates have changed since they were last imported
--		2. All unlocked _budgets_ whose ImportBudgetIntoGR fields are set to 1

INSERT INTO #BudgetsToProcess
SELECT
	@GBSSourceSystemId,					 -- SourceSystemId
	Budget.BudgetId,	 -- BudgetId
	1,					 -- ImportBudgetFromSourceSystem: the budget needs to be reimported from GBS because the budget has changed since it was last imported
	Budget.IsReforecast, -- IsReforecast: budget is not a reforecast
	BSM.SnapshotId,		 -- SnapshotId
	0					 -- 
FROM
	SERVER3.GBS.dbo.Budget Budget
	
	INNER JOIN #BudgetSnapshotMapping BSM ON
		Budget.BudgetId = BSM.BudgetId
WHERE
	BSM.SourceSystemId = 3 AND
	(	-- if the budget is locked and it has never been imported (i.e.: LastImportBudgetIntoGR is NULL), then import it
		(Budget.LastLockedDate IS NOT NULL AND Budget.LastLockedDate > ISNULL(Budget.LastImportBudgetIntoGRDate, ''1900-01-01'')) OR
		(Budget.LastLockedDate IS NULL AND Budget.ImportBudgetIntoGR = 1)
	)

-- TAPAS
;
WITH ImportBudgets AS
(
	SELECT 
		b.BudgetId,
		brg.BudgetReportGroupId,
		CASE WHEN 
			b.LastLockedDate > ISNULL(b.LastImportBudgetIntoGRDate, ''1900-01-01'') OR b.ImportBudgetIntoGR = 1 
		THEN
			1
		ELSE
			0
		END AS ToImport
	FROM 
		SERVER3.TAPASUS_Budgeting.Budget.Budget b
    
		INNER JOIN SERVER3.TAPASUS_Budgeting.Admin.BudgetReportGroupDetail brgd ON
			b.BudgetId = brgd.BudgetId

		INNER JOIN SERVER3.TAPASUS_Budgeting.Admin.BudgetReportGroup brg ON
			brgd.BudgetReportGroupId = brg.BudgetReportGroupId

		INNER JOIN SERVER3.GDM.dbo.BudgetReportGroupPeriod brgp ON
			brg.BudgetReportGroupPeriodId = brgp.BudgetReportGroupPeriodId
		
	WHERE    
		b.IsDeleted = 0 AND
		brgd.IsDeleted = 0 AND    
		brg.IsDeleted = 0 AND
		brgp.IsDeleted = 0
)
INSERT INTO #BudgetsToProcess
SELECT 
	@TAPASSourceSystemId, -- SourceSystemId
	b.BudgetId,			  -- BudgetId
	1,					  -- ImportBudgetFromSourceSystem
	b.IsReforecast,		  -- IsReforecast
	BSM.SnapshotId,		  -- SnapshotId
	0					  -- ImportSnapshotFromSourceSystem: don''t know whether the snapshot has changed and needs repimporting - assume it doesn''t
FROM
	SERVER3.TAPASUS_Budgeting.Budget.Budget b
  
	INNER JOIN ImportBudgets i ON
		b.BudgetId = i.BudgetId  
  
	INNER JOIN
	(
		SELECT 
		  budgetReportGroupId 
		FROM
		  ImportBudgets
		GROUP BY
		  budgetReportGroupId
		HAVING
		  COUNT(ToImport) = SUM(ToImport)
		  
	) brg ON
		i.BudgetReportGroupId = brg.BudgetReportGroupId

	INNER JOIN #BudgetSnapshotMapping BSM ON
		i.BudgetId = BSM.BudgetId

--=========================================================================================================================
-- B: Find all budget in the warehouse that are associated with snapshots that have changed since they were last imported.
--=========================================================================================================================

-- For all budgets that are to be imported and processed into the warehouse that are not currently in the warehouse, set their snapshots to be
-- imported too.

UPDATE
	BTP
SET
	BTP.ImportSnapshotFromSourceSystem = 1
FROM
	#BudgetsToProcess BTP
	
	LEFT OUTER JOIN
	(
		SELECT DISTINCT
			SourceSystemId,
			BudgetId
		FROM
			GrReporting.dbo.ProfitabilityBudget PB
			
	) WarehouseBudgets ON
		BTP.SourceSystemId = WarehouseBudgets.SourceSystemId AND
		BTP.BudgetId = WarehouseBudgets.BudgetId
		
WHERE
	WarehouseBudgets.BudgetId IS NULL



-- If locked snapshots used by budgets in the warehouse have been changed manually since they were last imported, the snapshots and the budgets
-- in the warehouse that use them need to be reimported and reprocessed.
-- If an unlocked snapshot has changed it is only reimported if it is used by a budget that is to be imported

-- determine which snapshots (that are used by budgets in the warehouse) require reimporting and which budgets require reprocessing as a result

INSERT INTO #BudgetsToProcess
SELECT DISTINCT
	PB.SourceSystemId, -- SourceSystemId
	PB.BudgetId,	   -- BudgetId: The Budgets that are linked to the snapshots that have changed [from 2]. 
	0,				   -- ImportBudgetFromSourceSystem: Assume that the budget doesn''t require importing. If it does it should have been identified in [A] above
	BSM.IsReforecast,  -- IsReforecast
	WarehouseSnapshotsChanged.SnapshotId, -- SnapshotId
	1 -- ImportSnapshotFromSourceSystem: we know from the joins below that these snapshots have been modified and need to be reimported
FROM
	GrReporting.dbo.ProfitabilityBudget PB
	
	INNER JOIN #BudgetSnapshotMapping BSM ON
		PB.BudgetId = BSM.BudgetId AND
		PB.SourceSystemId = BSM.SourceSystemId

	INNER JOIN -- 2. The snapshots that have changed since their last import and are linked to a budget(s) in the warehouse [from 1]
	(
		SELECT DISTINCT
			S.SnapshotId
		FROM
			SERVER3.GDM.dbo.[Snapshot] S
			
			INNER JOIN GrReportingStaging.Gdm.[snapshot] SS ON
				S.SnapshotId = SS.SnapshotId

			INNER JOIN
			(	-- 1. Consider all of the budgets that have been processed into the warehouse
				SELECT DISTINCT
					PB.SourceSystemId,
					PB.BudgetId,
					BSM.SnapshotId
				FROM
					GrReporting.dbo.ProfitabilityBudget PB
					INNER JOIN #BudgetSnapshotMapping BSM ON
						PB.BudgetId = BSM.BudgetId AND
						PB.SourceSystemId = BSM.SourceSystemId
					
			) WarehouseSnapshots ON
				S.SnapshotId = WarehouseSnapshots.SnapshotId AND
				SS.SnapshotId = WarehouseSnapshots.SnapshotId
		WHERE
			(	-- If the snapshot is locked and GDM.dbo.Snapshot.ManualUpdatedDate > GrReportingStaging.Gdm.Snapshot.ManualUpdatedDate, the
				-- snapshot has changed and it has to be reimported and the budgets in the warehouse that use it have to be at least reprocessed
				(
					S.IsLocked = 1 AND 
					ISNULL(S.ManualUpdatedDate, ''1900-01-01'') > ISNULL(SS.ManualUpdatedDate, ''1900-01-01'')
				)
			
				OR
				
				-- If the snapshot is unlocked and GDM.dbo.Snapshot.LastSyncDate > GrReportingStaging.Gdm.Snapshot.LastSyncDate (i.e.: has changed),
				-- AND the snapshot is being used by a budget that is to be imported, the snapshot must be reimported and the budgets in the
				-- warehouse that use it must be reprocessed.
				-- This is because a budget must not be reprocessed purely because the unlocked snapshot that it uses has changed. Only if the
				-- snapshot is being used by a budget that is set to be imported must the budgets in the warehouse that use this snapshot being
				-- reprocessed.
				(
					S.IsLocked = 0 AND
					ISNULL(S.LastSyncDate, ''1900-01-01'') > ISNULL(SS.LastSyncDate, ''1900-01-01'') AND
					S.SnapshotId IN (SELECT DISTINCT SnapshotId FROM #BudgetSnapshotMapping)
				)
			
				OR
				-- If the snapshot is unlocked in Staging but has since been locked in GDM.dbo.Snapshot 
				(
					S.IsLocked <> SS.IsLocked
				)
			
			) 
	) WarehouseSnapshotsChanged ON
		BSM.SnapshotId = WarehouseSnapshotsChanged.SnapshotId


--=========================================================================================================================
-- Consolidation
--=========================================================================================================================

DECLARE @LastImportBatchId INT = (SELECT MAX(ImportBatchId) FROM dbo.BudgetsToProcess)

IF (@LastImportBatchId IS NULL) -- If the table is empty
BEGIN
	SET @LastImportBatchId = 0
END

INSERT INTO dbo.BudgetsToProcess (
	ImportBatchId,
	SourceSystemName,
	BudgetId,
	ImportBudgetFromSourceSystem,
	IsReforecast,
	SnapshotId,
	ImportSnapshotFromSourceSystem
)
SELECT
	@LastImportBatchId + 1,
	SS.Name,
	BTP.BudgetId,
	CAST(MAX(BTP.ImportBudgetFromSourceSystem) AS BIT) ImportBudgetFromSourceSystem,
	BTP.IsReforecast,
	BTP.SnapshotId,
	CAST(MAX(BTP.ImportSnapshotFromSourceSystem) AS BIT) ImportSnapshotFromSourceSystem
FROM
	#BudgetsToProcess BTP
	INNER JOIN GrReporting.dbo.SourceSystem SS ON
		BTP.SourceSystemId = SS.SourceSystemId
WHERE
	BTP.IsReforecast = 0
GROUP BY
	SS.Name,
	BTP.BudgetId,
	BTP.IsReforecast,
	BTP.SnapshotId

--=========================================================================================================================
-- Clean up
--=========================================================================================================================

IF 	OBJECT_ID(''tempdb..#BudgetsToProcess'') IS NOT NULL
	DROP TABLE #BudgetsToProcess

IF 	OBJECT_ID(''tempdb..#BudgetSnapshotMapping'') IS NOT NULL
	DROP TABLE #BudgetSnapshotMapping
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_D_GBSBudget]    Script Date: 02/04/2011 18:03:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_D_GBSBudget]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[stp_D_GBSBudget]
	@BudgetsToDelete dbo.GBSBudgetImportBatchType READONLY

AS

--------------------------------------------------------------------------
-- delete GBS.NonPayrollExpenseBreakdown
--------------------------------------------------------------------------

DELETE
	NPEB
FROM
	GBS.NonPayrollExpenseBreakdown NPEB
	INNER JOIN @BudgetsToDelete BTD ON
		NPEB.BudgetId = BTD.BudgetId AND
		NPEB.ImportBatchId = BTD.ImportBatchId

PRINT (''	Records deleted from GBS.NonPayrollExpenseBreakdown: '' + CONVERT(VARCHAR(10),@@rowcount))

--------------------------------------------------------------------------
-- delete GBS.NonPayrollExpenseDispute
--------------------------------------------------------------------------

DELETE
	NPED
FROM
	GBS.NonPayrollExpenseDispute NPED
	
	INNER JOIN GBS.NonPayrollExpense NPE ON
		NPED.NonPayrollExpenseId = NPE.NonPayrollExpenseId AND
		NPED.ImportBatchId = NPE.ImportBatchId

	INNER JOIN @BudgetsToDelete BTD ON
		NPE.BudgetId = BTD.BudgetId AND
		NPE.ImportBatchId = BTD.ImportBatchId

PRINT (''	Records deleted from GBS.NonPayrollExpenseDispute: '' + CONVERT(VARCHAR(10),@@rowcount))

--------------------------------------------------------------------------
-- delete GBS.DisputeStatus
--------------------------------------------------------------------------

-- If there are no more disputes against the budget that is to be deleted, there is no need to keep the DisputeStatus table associated with that
-- import batch

IF NOT EXISTS (SELECT * FROM GBS.NonPayrollExpenseDispute WHERE ImportBatchId IN (SELECT ImportBatchId FROM @BudgetsToDelete))
BEGIN
	DELETE
	FROM
		GBS.DisputeStatus
	WHERE
		ImportBatchId IN (SELECT ImportBatchId FROM @BudgetsToDelete)

	PRINT (''	Records deleted from GBS.DisputeStatus: '' + CONVERT(VARCHAR(10), @@rowcount))
END

--------------------------------------------------------------------------
-- delete GBS.NonPayrollExpense
--------------------------------------------------------------------------

DELETE
	NPE
FROM
	GBS.NonPayrollExpense NPE
	
	INNER JOIN @BudgetsToDelete BTD ON
		NPE.BudgetId = BTD.BudgetId AND
		NPE.ImportBatchId = BTD.ImportBatchId

PRINT (''	Records deleted from GBS.NonPayrollExpense: '' + CONVERT(VARCHAR(10),@@rowcount))

--------------------------------------------------------------------------
-- delete GBS.FeeDetail
--------------------------------------------------------------------------

DELETE
	FD
FROM
	GBS.FeeDetail FD
	INNER JOIN GBS.Fee F ON
		FD.FeeId = F.FeeId AND
		FD.ImportBatchId = F.ImportBatchId
	
	INNER JOIN @BudgetsToDelete BTD ON
		F.BudgetId = BTD.BudgetId AND
		F.ImportBatchId = BTD.ImportBatchId

PRINT (''	Records deleted from GBS.FeeDetail: '' + CONVERT(VARCHAR(10),@@rowcount))

--------------------------------------------------------------------------
-- delete GBS.Fee
--------------------------------------------------------------------------

DELETE
	F
FROM
	GBS.Fee F
	INNER JOIN @BudgetsToDelete BTD ON
		F.BudgetId = BTD.BudgetId AND
		F.ImportBatchId = BTD.ImportBatchId

PRINT (''	Records deleted from GBS.Fee: '' + CONVERT(VARCHAR(10),@@rowcount))

--------------------------------------------------------------------------
-- delete GBS.Budget
--------------------------------------------------------------------------

DELETE
	B
FROM
	GBS.Budget B
	INNER JOIN @BudgetsToDelete BTD ON
		B.ImportKey = BTD.ImportKey

PRINT (''	Records deleted from GBS.Budget: '' + CONVERT(VARCHAR(10),@@rowcount))


' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_U_SyncBudgetsProcessed]    Script Date: 02/04/2011 18:03:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_U_SyncBudgetsProcessed]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_U_SyncBudgetsProcessed]	

AS

-- Update GBS.dbo.Budget  

UPDATE
	Budget
SET
	Budget.ImportBudgetIntoGR = 0,
	Budget.LastImportBudgetIntoGRDate = BTP.DateBudgetProcessedIntoWarehouse
FROM
	SERVER3.GBS.dbo.Budget Budget
	INNER JOIN dbo.BudgetsToProcess BTP ON
		Budget.BudgetId = BTP.BudgetId

WHERE
	BTP.BudgetProcessedIntoWarehouse = 1 AND
	BTP.DateBudgetProcessedIntoWarehouse IS NOT NULL AND
	BTP.SourceSystemName = ''Global Budgeting System'' AND
	Budget.IsActive = 1

-- Update GBS.dbo.Budget  

UPDATE
	TAPAS
SET
	TAPAS.ImportBudgetIntoGR = 0,
	TAPAS.LastImportBudgetIntoGRDate = BTP.DateBudgetProcessedIntoWarehouse
FROM
	SERVER3.TAPASUS_Budgeting.Budget.Budget TAPAS
	INNER JOIN dbo.BudgetsToProcess BTP ON
		TAPAS.BudgetId = BTP.BudgetId

WHERE
	BTP.BudgetProcessedIntoWarehouse = 1 AND
	BTP.DateBudgetProcessedIntoWarehouse IS NOT NULL AND
	BTP.SourceSystemName = ''Tapas Budgeting'' AND
	TAPAS.IsDeleted = 0

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyGBSBudget]    Script Date: 02/04/2011 18:03:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyGBSBudget]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyGBSBudget]

AS

PRINT ''####''
PRINT ''stp_IU_LoadGrProfitabiltyGBSBudget''
PRINT ''####''

DECLARE @LatestImportBatchId INT = (SELECT MAX(ImportBatchId) FROM dbo.BudgetsToProcess WHERE SourceSystemName = ''Global Budgeting System'' AND BudgetProcessedIntoWarehouse IS NULL AND DateBudgetProcessedIntoWarehouse IS NULL)

IF (@LatestImportBatchId IS NULL)
BEGIN
	PRINT (''*******************************************************'')
	PRINT (''	stp_IU_LoadGrProfitabiltyGBSBudget is quitting because there are no GBS budgets set to be imported.'')
	PRINT (''*******************************************************'')
	RETURN
END

-- ==============================================================================================================================================
-- Declare Local Variables
-- ==============================================================================================================================================

DECLARE @GlAccountKeyUnknown			INT = (SELECT GlAccountKey FROM GrReporting.dbo.GlAccount WHERE Code = ''UNKNOWN'')
DECLARE	@SourceKeyUnknown				INT = (SELECT SourceKey FROM GrReporting.dbo.Source WHERE SourceName = ''UNKNOWN'')
DECLARE	@FunctionalDepartmentKeyUnknown	INT = (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = ''UNKNOWN'')
DECLARE	@ReimbursableKeyUnknown			INT = (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = ''UNKNOWN'')
DECLARE	@ActivityTypeKeyUnknown			INT = (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = ''UNKNOWN'')
DECLARE	@PropertyFundKeyUnknown			INT = (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = ''UNKNOWN'')
DECLARE	@AllocationRegionKeyUnknown		INT = (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = ''UNKNOWN'')
DECLARE	@OriginatingRegionKeyUnknown	INT = (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = ''UNKNOWN'')
DECLARE	@OverheadKeyUnknown				INT = (SELECT OverheadKey FROM GrReporting.dbo.Overhead WHERE OverheadCode = ''UNKNOWN'')
DECLARE	@LocalCurrencyKeyUnknown		INT = (SELECT CurrencyKey FROM GrReporting.dbo.Currency WHERE CurrencyCode = ''UNKNOWN'')
DECLARE	@FeeAdjustmentKeyUnknown		INT = (SELECT FeeAdjustmentKey FROM GrReporting.dbo.FeeAdjustment WHERE FeeAdjustmentCode = ''UNKNOWN'')--,
--	@CanImportCorporateBudget	INT = (SELECT ConfiguredValue FROM GrReportingStaging.dbo.SSISConfigurations WHERE ConfigurationFilter = ''CanImportCorporateBudget'')

DECLARE @EUFundGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Fund Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
DECLARE @EUCorporateGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Corporate Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
DECLARE	@EUPropertyGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Property Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
DECLARE	@USFundGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Fund Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
DECLARE	@USPropertyGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Property Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
DECLARE	@USCorporateGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Corporate Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
DECLARE	@DevelopmentGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''Development Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')
DECLARE	@GlobalGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global'' AND TranslationSubTypeName = ''Global'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')

DECLARE @SourceSystemId INT = (SELECT SourceSystemId FROM GrReporting.dbo.SourceSystem WHERE Name = ''Global Budgeting System'')
DECLARE @StartTime DATETIME = GETDATE()

-- There could be up to three copies of the same GBS data due to three seperate imports, so work with latest GBS import which should have the
-- highest ImportBatchId.

DECLARE @ImportBatchId INT = (SELECT MAX(BatchId) FROM dbo.Batch WHERE PackageName = ''ETL.Staging.GBS'')

-- ==============================================================================================================================================
-- Source Budget data from GBS
-- ==============================================================================================================================================

CREATE TABLE #Budget(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	BudgetId INT NOT NULL,
	BudgetAllocationSetId INT NOT NULL,
	BudgetReportGroupPeriodId INT NOT NULL,
	BudgetExchangeRateId INT NOT NULL,
	BudgetStatusId INT NOT NULL,
	CreatorStaffId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	HealthyTensionStartDate DATETIME NOT NULL,
	HealthyTensionEndDate DATETIME NOT NULL,
	LastLockedDate DATETIME NULL,
	PriorBudgetId INT NULL,
	IsReforecast BIT NOT NULL,
	CopiedFromBudgetId INT NULL,
	ImportBudgetIntoGR BIT NOT NULL,
	LastImportBudgetIntoGRDate DATETIME NULL,
	SnapshotId INT NOT NULL
)
INSERT INTO #Budget

SELECT
	Budget.ImportKey,
	Budget.ImportBatchId,
	Budget.BudgetId,
	Budget.BudgetAllocationSetId,
	Budget.BudgetReportGroupPeriodId,
	Budget.BudgetExchangeRateId,
	Budget.BudgetStatusId,
	Budget.CreatorStaffId,
	Budget.Name,
	Budget.HealthyTensionStartDate,
	Budget.HealthyTensionEndDate,
	Budget.LastLockedDate,
	Budget.PriorBudgetId,
	Budget.IsReforecast,
	Budget.CopiedFromBudgetId,
	Budget.ImportBudgetIntoGR,
	Budget.LastImportBudgetIntoGRDate,
	BTP.SnapshotId
FROM
	GBS.Budget Budget
	
	INNER JOIN dbo.BudgetsToProcess BTP ON -- All GBS budgets in dbo.BudgetsToProcess must be considered because they are to be processed into the warehouse
		Budget.BudgetId = BTP.BudgetId
WHERE
	BTP.SourceSystemName = ''Global Budgeting System'' AND
	BTP.ImportBatchId = @LatestImportBatchId AND
	BTP.IsReforecast = 0 AND
	Budget.ImportBatchId = @ImportBatchId AND -- AND Budget.BudgetId = 14
	Budget.IsActive = 1 AND
	Budget.ImportKey = (SELECT MAX(ImportKey) FROM GBS.Budget WHERE ImportBatchId = @ImportBatchId)



PRINT (''Rows inserted into #Budget: '' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

-- BudgetGLGlobalAccount

--SET @StartTime = GETDATE()

--CREATE TABLE #BudgetGLGlobalAccount(
--	BudgetGLGlobalAccountId INT NOT NULL,
--	BudgetId INT NOT NULL,
--	GLGlobalAccountId INT NOT NULL
--)
--INSERT INTO #BudgetGLGlobalAccount
--SELECT
--	BGA.BudgetGLGlobalAccountId,
--	BGA.BudgetId,
--	BGA.GLGlobalAccountId
--FROM
--	GBS.BudgetGLGlobalAccount BGA
--	INNER JOIN #Budget B ON
--		BGA.BudgetId = B.BudgetId AND
--		BGA.ImportBatchId = B.ImportBatchId
--WHERE
--	BGA.IsActive = 1

--PRINT (''Rows inserted into #BudgetGLGlobalAccount: '' + CONVERT(VARCHAR(10),@@rowcount))
--PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

-- ==============================================================================================================================================
-- Source Snapshot mapping data from GDM
-- ==============================================================================================================================================

-- GLGlobalAccount --------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #GLGlobalAccount(
	GLGlobalAccountId INT NOT NULL,
	ActivityTypeId INT NULL,
	GLStatutoryTypeId INT NOT NULL,
	ParentGLGlobalAccountId INT NULL,
	Code VARCHAR(10) NOT NULL,
	Name NVARCHAR(150) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsGR BIT NOT NULL,
	IsGbs BIT NOT NULL,
	IsRegionalOverheadCost BIT NOT NULL,
	ExpenseCzarStaffId INT NOT NULL,
	ParentCode AS (left(Code,(8))),
	SnapshotId INT NOT NULL
)
INSERT INTO #GLGlobalAccount (
	GLGlobalAccountId,
	ActivityTypeId,
	GLStatutoryTypeId,
	ParentGLGlobalAccountId,
	Code,
	Name,
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
	INNER JOIN #Budget B ON
		GLGA.SnapshotId = B.SnapshotId
WHERE
	GLGA.IsActive = 1

PRINT (''Rows inserted into #GLGlobalAccount: '' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

-- GLTranslationSubType -----------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #GLTranslationSubType (
	[SnapshotId] [int] NOT NULL,
	[GLTranslationSubTypeId] [int] NOT NULL,
	[GLTranslationTypeId] [int] NOT NULL,
	[Code] [varchar](10) NOT NULL
)
INSERT INTO #GLTranslationSubType
SELECT
	TST.SnapshotId,
	GLTranslationSubTypeId,
	GLTranslationTypeId,
	Code
FROM
	Gdm.SnapshotGLTranslationSubType TST
	INNER JOIN #Budget B ON
		TST.SnapshotId = B.SnapshotId
WHERE
	TST.Code = ''GL'' AND -- This limits to the Global translation sub type; for multiple sub types remove this constraint and add TST.Code to SELECT
	TST.IsActive = 1

PRINT (''Rows inserted into ##GLTranslationSubType: '' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

-- GLGlobalAccountTranslationType --------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #GLGlobalAccountTranslationType(
	GLGlobalAccountTranslationTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL,
	SnapshotId INT NOT NULL
)

INSERT INTO #GLGlobalAccountTranslationType
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
				--		GTT.Code = ''GL'' AND
				--		GST.Code = ''GRPOHD''	AND
				--		GST.IsActive = 1 AND
				--		GTT.IsActive = 1
				--)				
		 ELSE
			GATT.GLAccountSubTypeId
	END AS GLAccountSubTypeId,
	GATT.SnapshotId
FROM
	Gdm.SnapshotGLGlobalAccountTranslationType GATT
	
	INNER JOIN #Budget B ON
		GATT.SnapshotId = B.SnapshotId	

	LEFT OUTER JOIN (
						SELECT
							GA.*
						FROM
							#GLGlobalAccount GA
							
					 ) GA ON
							GA.GLGlobalAccountId = GATT.GLGlobalAccountId AND
							GA.SnapshotId = GATT.SnapshotId
	
	LEFT OUTER JOIN (
						SELECT
							GST.GLAccountSubTypeId,
							B.BudgetId,
							gst.SnapshotId
							--GST.GLAccountSubTypeId 
						FROM
							Gdm.SnapshotGLAccountSubType GST 
							INNER JOIN Gdm.SnapshotGLTranslationType GTT ON
								GTT.GLTranslationTypeId = GST.GLTranslationTypeId
							INNER JOIN #Budget B ON
								GST.SnapshotId = B.SnapshotId AND
								GTT.SnapshotId = B.SnapshotId
						WHERE
							GTT.Code = ''GL'' AND
							GST.Code = ''GRPOHD''	AND
							GST.IsActive = 1 AND
							GTT.IsActive = 1
					) AST ON
							GATT.SnapshotId = AST.SnapshotId AND
							B.BudgetId = AST.BudgetId
	
WHERE
	GATT.IsActive = 1

PRINT (''Rows inserted into #GLGlobalAccountTranslationType: '' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

-- SnapshotGLGlobalAccountTranslationSubType -------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #GLGlobalAccountTranslationSubType (
	SnapshotId INT NOT NULL,
	GLGlobalAccountTranslationSubTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLMinorCategoryId INT NOT NULL
)
INSERT INTO #GLGlobalAccountTranslationSubType
SELECT
	GATST.SnapshotId,
	GATST.GLGlobalAccountTranslationSubTypeId,
	GATST.GLGlobalAccountId,
	GATST.GLTranslationSubTypeId,
	GATST.GLMinorCategoryId
FROM
	Gdm.SnapshotGLGlobalAccountTranslationSubType GATST
	INNER JOIN #Budget B ON
		GATST.SnapshotId = B.SnapshotId
WHERE
	GATST.IsActive = 1

PRINT (''Rows inserted into #GLGlobalAccountTranslationSubType: '' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

-- GLMinorCategory

SET @StartTime = GETDATE()

CREATE TABLE #GLMinorCategory (
	SnapshotId INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL
)
INSERT INTO #GLMinorCategory
SELECT
	MinC.SnapshotId,
	MinC.GLMinorCategoryId,
	MinC.GLMajorCategoryId
FROM
	Gdm.SnapshotGLMinorCategory MinC
	INNER JOIN #Budget B ON
		MinC.SnapshotId = B.SnapshotId
WHERE
	MinC.IsActive = 1

PRINT (''Rows inserted into #GLMinorCategory: '' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

-- GLMajorCategory

SET @StartTime = GETDATE()

CREATE TABLE #GLMajorCategory (
	[SnapshotId] [int] NOT NULL,
	[GLMajorCategoryId] [int] NOT NULL,
	[GLTranslationSubTypeId] [int] NOT NULL
)
INSERT INTO #GLMajorCategory
SELECT
	MajC.SnapshotId,
	MajC.GLMajorCategoryId,
	MajC.GLTranslationSubTypeId
FROM
	Gdm.SnapshotGLMajorCategory MajC
	INNER JOIN #Budget B ON
		MajC.SnapshotId = B.SnapshotId
WHERE
	MajC.IsActive = 1

PRINT (''Rows inserted into #GLMajorCategory: '' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

-- ReportingEntityCorporateDepartment --------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #ReportingEntityCorporateDepartment(
	ReportingEntityCorporateDepartmentId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	CorporateDepartmentCode CHAR(6) NOT NULL,
	SnapshotId INT NOT NULL
)

INSERT INTO	#ReportingEntityCorporateDepartment
SELECT
	RECD.ReportingEntityCorporateDepartmentId,
	RECD.PropertyFundId,
	RECD.SourceCode,
	RECD.CorporateDepartmentCode,
	RECD.SnapshotId
FROM
	Gdm.SnapshotReportingEntityCorporateDepartment RECD
	INNER JOIN #Budget B ON
		RECD.SnapshotId = B.SnapshotId
WHERE
	RECD.IsDeleted = 0

PRINT (''Rows inserted into #ReportingEntityCorporateDepartment: '' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

-- PropertyFund --------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #PropertyFund(
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
	SnapshotId INT NOT NULL
)

INSERT INTO #PropertyFund
SELECT
	PF.PropertyFundId,
	PF.RelatedFundId,
	PF.EntityTypeId,
	PF.AllocationSubRegionGlobalRegionId,
	PF.BudgetOwnerStaffId,
	PF.RegionalOwnerStaffId,
	PF.DefaultGLTranslationSubTypeId,
	PF.Name,
	PF.IsReportingEntity,
	PF.IsPropertyFund,
	PF.SnapshotId
FROM
	Gdm.SnapshotPropertyFund PF
	INNER JOIN #Budget B ON
		B.SnapshotId = PF.SnapshotId
WHERE
	PF.IsActive = 1

PRINT (''Rows inserted into #PropertyFund: '' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

-- ActivityType --------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #ActivityType(
	ActivityTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	SnapshotId INT NOT NULL
)

INSERT INTO #ActivityType
SELECT
	ActivityTypeId,
	Code,
	AT.SnapshotId
FROM
	Gdm.SnapshotActivityType AT
	INNER JOIN #Budget B ON
		AT.SnapshotId = B.SnapshotId
WHERE
	AT.IsActive = 1

PRINT (''Rows inserted into #ActivityType: '' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

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
SELECT
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

PRINT (''Rows inserted into #CorporateDepartment: '' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

-- FunctionalDepartment --------------------------------------------------

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
	Gdm.SnapshotFunctionalDepartment FD
	INNER JOIN #Budget B ON
		FD.SnapshotId = B.SnapshotId
WHERE
	FD.IsActive = 1

PRINT (''Rows inserted into #FunctionalDepartment: '' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

-- AllocationSubRegion --------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #AllocationSubRegion (
	[SnapshotId] [int] NOT NULL,
	[AllocationSubRegionGlobalRegionId] [int] NOT NULL,
	[Code] [varchar](10) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[AllocationRegionGlobalRegionId] [int] NULL,
	[DefaultCorporateSourceCode] [char](2) NOT NULL
)
INSERT INTO #AllocationSubRegion
SELECT
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

PRINT (''Rows inserted into #AllocationSubRegion: '' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

-- Master GL Account Category mapping table

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
	Budget.SnapshotId,
	Gla.GlAccountKey,
	TST.GLTranslationTypeId,
	TST.GLTranslationSubTypeId,
	MinC.GLMajorCategoryId,
	GLATST.GLMinorCategoryId,
	GLATT.GLAccountTypeId,
	GLATT.GLAccountSubTypeId
FROM
	#Budget Budget

	INNER JOIN #GLTranslationSubType TST ON
		Budget.SnapshotId = TST.SnapshotId

	INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
		TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
		Budget.SnapshotId = GLATST.SnapshotId
	
	INNER JOIN #GLGlobalAccountTranslationType GLATT ON
		GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
		TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
		Budget.SnapshotId = GLATT.SnapshotId

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

	INNER JOIN #GLMinorCategory MinC ON
		GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		Budget.SnapshotId = MinC.SnapshotId

	INNER JOIN #GLMajorCategory MajC ON
		MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
		Budget.SnapshotId = MajC.SnapshotId

PRINT (''Rows inserted into #GLAccountCategoryMapping: '' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

-- Corporate Property Sources

CREATE TABLE #CorporatePropertySourceCodes (
	CorporateSourceCode CHAR(2) NOT NULL,
	PropertySourceCode CHAR(2) NOT NULL
)

INSERT INTO #CorporatePropertySourceCodes
SELECT ''UC'', ''US'' UNION ALL
SELECT ''EC'', ''EU'' UNION ALL
SELECT ''IC'', ''IN'' UNION ALL
SELECT ''BC'', ''BR'' UNION ALL
SELECT ''CC'', ''CN''

-- ==============================================================================================================================================
-- Get Non-Payroll Expense Budget items from GBS
-- ==============================================================================================================================================

SET @StartTime = GETDATE()

CREATE TABLE #ProfitabilitySource (
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
	OriginatingGlobalRegionId INT NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	LockedDate DATETIME NULL,
	IsExpense BIT NOT NULL,
	UnallocatedOverhead CHAR(7) NULL, -- NULL because this field is determined via an outer join
	FeeAdjustment VARCHAR(9) NOT NULL
)

-- Insert original budget amounts
INSERT INTO #ProfitabilitySource (
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
	OriginatingGlobalRegionId,
	LocalCurrencyCode,
	LockedDate,
	IsExpense,
	UnallocatedOverhead,
	FeeAdjustment
)

SELECT
	Budget.BudgetId, -- BudgetId
	''GBS:BudgetId='' + LTRIM(RTRIM(STR(Budget.BudgetId))) + ''&NonPayrollExpenseBreakdownId='' + LTRIM(RTRIM(STR(NPEB.NonPayrollExpenseBreakdownId))) + ''&SnapshotId='' + LTRIM(RTRIM(STR(Budget.SnapshotId))), -- ReferenceCode
	NPEB.Period, -- ExpensePeriod: Period is actually a foreign key to PeriodExtended but is also the implied period value, e.g.: 201009
	CASE WHEN NPEB.IsDirectCost = 1 THEN CPSC.PropertySourceCode ELSE NPEB.CorporateSourceCode END AS CorporateSourceCode,	
	NPEB.Amount, -- BudgetAmount
	ISNULL(NPEB.ActivitySpecificGLGlobalAccountId, NPEB.GLGlobalAccountId), -- GLGlobalAccountId
	FD.GlobalCode, -- FunctionalDepartmentCode
	NPEB.JobCode, -- JobCode
	CASE WHEN CD.IsTsCost = 0 THEN ''YES'' ELSE ''NO'' END, -- Reimbursable
	NPEB.ActivityTypeId, -- ActivityTypeId: this Id should correspond to the correct Id in GDM
	RECD.PropertyFundId, -- PropertyFundId
	PF.AllocationSubRegionGlobalRegionId, -- AllocationSubRegionGlobalRegionId
	NPEB.OriginatingSubRegionGlobalRegionId, -- OriginatingGlobalRegionId
	NPEB.CurrencyCode, -- LocalCurrencyCode
	Budget.LastLockedDate, -- LockedDate
	1, -- IsExpense
	CASE WHEN AT.Code = ''CORPOH'' THEN ''UNALLOC'' ELSE ''UNKNOWN'' END, -- UnallocatedOverhead
	''NORMAL'' -- FeeAdjustment
FROM
	#Budget Budget
	
	INNER JOIN GBS.NonPayrollExpenseBreakdown NPEB ON
		Budget.BudgetId = NPEB.BudgetId AND
		Budget.ImportBatchId = NPEB.ImportBatchId
	
	INNER JOIN #CorporatePropertySourceCodes CPSC ON
		NPEB.CorporateSourceCode = CPSC.CorporateSourceCode
	
	LEFT OUTER JOIN ( -- these NonPayrollExpenses need to be excluded because they are in dispute
	
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
			DS.Name <> ''Resolved'' AND
			DS.IsActive = 1
			
	) DisputedNonPayrollExpenseItems ON
		NPEB.NonPayrollExpenseId = DisputedNonPayrollExpenseItems.NonPayrollExpenseId AND
		NPEB.BudgetProjectId = DisputedNonPayrollExpenseItems.BudgetProjectId AND
		NPEB.ImportBatchId = DisputedNonPayrollExpenseItems.ImportBatchId

	-- PropertyFundId
	LEFT OUTER JOIN #ReportingEntityCorporateDepartment RECD ON				-- Only corporate budgets should be handled by GBS, so when we map
		 NPEB.CorporateDepartmentCode = RECD.CorporateDepartmentCode AND	-- to find a Reporting Entity we assume that the source is corporate
		 NPEB.CorporateSourceCode = RECD.SourceCode AND
		 Budget.SnapshotId = RECD.SnapshotId
	
	-- AllocationRegionId
	LEFT OUTER JOIN #PropertyFund PF ON
		RECD.PropertyFundId = PF.PropertyFundId AND
		RECD.SnapshotId = PF.SnapshotId
	
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

WHERE
	NPEB.IsActive = 1 AND
	DisputedNonPayrollExpenseItems.NonPayrollExpenseId IS NULL -- Exclude all disputed items

PRINT (''Rows inserted into #ProfitabilitySource: '' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

--select * from #ProfitabilitySource

-- ==============================================================================================================================================
-- Get Fee Budget items from GBS
-- ==============================================================================================================================================

SET @StartTime = GETDATE()

INSERT INTO #ProfitabilitySource (
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
	OriginatingGlobalRegionId,
	LocalCurrencyCode,
	LockedDate,
	IsExpense,
	UnallocatedOverhead,
	FeeAdjustment
)
SELECT
	Budget.BudgetId, -- BudgetId
	''GBS:BudgetId='' + LTRIM(RTRIM(STR(Budget.BudgetId))) + ''&FeeId='' + LTRIM(RTRIM(STR(Fee.FeeId))) + ''&FeeDetailId='' + LTRIM(RTRIM(STR(FeeDetail.FeeDetailId))) + ''&SnapshotId='' + LTRIM(RTRIM(STR(Budget.SnapshotId))), -- ReferenceCode
	FeeDetail.Period,
	ASR.DefaultCorporateSourceCode, -- SourceCode
	FeeDetail.Amount,
	GA.GLGlobalAccountId, -- GLGlobalAccountId
	NULL, -- FunctionalDepartmentId
	NULL, -- JobCode
	''NO'', -- Reimbursable
	GA.ActivityTypeId, -- ActivityType: determined by finding Fee.GLGlobalAccountId on GrReportingStaging.dbo.GLGlobalAccount
	Fee.PropertyFundId, -- PropertyFundId
	Fee.AllocationSubRegionGlobalRegionId, -- AllocationSubRegionGlobalRegionId
	Fee.AllocationSubRegionGlobalRegionId, -- OriginatingGlobalRegionId: allocation region = originating region for fee income
	Fee.CurrencyCode,
	Budget.LastLockedDate, -- LockedDate
	0,  -- IsExpense
	''UNKNOWN'', -- IsUnallocatedOverhead: defaults to UNKNOWN for fees
	CASE WHEN FeeDetail.IsAdjustment = 1 THEN ''FEEADJUST'' ELSE ''NORMAL'' END -- IsFeeAdjustment, field isn''t NULLABLE
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
	LEFT OUTER JOIN #AllocationSubRegion ASR ON
		Fee.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId

WHERE
	Fee.IsDeleted = 0 AND
	FeeDetail.Amount <> 0

PRINT (''Rows inserted into #ProfitabilitySource: '' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

--select distinct COUNT(*) from #ProfitabilitySource

------------------------------------------------------------------------------------------------------------------

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
	RIGHT(GLGA1.Code, 2) = ''00'' -- where the header account has been budgeted against

PRINT (''Rows updated in #ProfitabilitySource (GLAccount update from head to activity-specific GL Account: '' + LTRIM(RTRIM(STR(@@rowcount))))

------------------------------------------------------------------------------------------------------------------

-- Perhaps create index for #ProfitabilitySource here

-- ==============================================================================================================================================
-- Join to dimension tables in GrReporting and attempt to resolve keys, otherwise default to UNKNOWN if NULL
-- ==============================================================================================================================================

SET @StartTime = GETDATE()

CREATE TABLE #ProfitabilityBudget(
	CalendarKey int NOT NULL,
	GlAccountKey int NOT NULL,
	SourceKey int NOT NULL,
	FunctionalDepartmentKey int NOT NULL,
	ReimbursableKey int NOT NULL,
	ActivityTypeKey int NOT NULL,
	PropertyFundKey int NOT NULL,	
	AllocationRegionKey int NOT NULL,
	OriginatingRegionKey int NOT NULL,
	OverheadKey int NOT NULL,
	FeeAdjustmentKey int NOT NULL,
	LocalCurrencyKey int NOT NULL,
	LocalBudget money NOT NULL,
	ReferenceCode Varchar(300) NOT NULL,
	BudgetId int NOT NULL,
	SourceSystemId int NOT NULL,
	IsExpense BIT NOT NULL,

	EUCorporateGlAccountCategoryKey int NULL,
	EUPropertyGlAccountCategoryKey int NULL,
	EUFundGlAccountCategoryKey int NULL,

	USPropertyGlAccountCategoryKey int NULL,
	USCorporateGlAccountCategoryKey int NULL,
	USFundGlAccountCategoryKey int NULL,

	GlobalGlAccountCategoryKey int NULL,
	DevelopmentGlAccountCategoryKey int NULL
)

INSERT INTO #ProfitabilityBudget 
(
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	FeeAdjustmentKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	IsExpense
)

SELECT
	DATEDIFF(DD, ''1900-01-01'', LEFT(PS.ExpensePeriod, 4)+''-'' + RIGHT(PS.ExpensePeriod, 2) + ''-01''), -- CalendarKey,
	CASE WHEN GA.GlAccountKey IS NULL THEN @GlAccountKeyUnknown ELSE GA.GlAccountKey END, -- GlAccountKey,
	CASE WHEN S.SourceKey IS NULL THEN @SourceKeyUnknown ELSE S.SourceKey END, -- SourceKey,
	CASE WHEN
		ISNULL(FDJobCode.FunctionalDepartmentKey, FD.FunctionalDepartmentKey) IS NULL
		THEN
			@FunctionalDepartmentKeyUnknown
		ELSE
			ISNULL(FDJobCode.FunctionalDepartmentKey, FD.FunctionalDepartmentKey) END,	-- FunctionalDepartmentKey,
	CASE WHEN R.ReimbursableCode IS NULL THEN @ReimbursableKeyUnknown ELSE R.ReimbursableKey END, -- ReimbursableKey,
	CASE WHEN AT.ActivityTypeKey IS NULL THEN @ActivityTypeKeyUnknown ELSE AT.ActivityTypeKey END, -- ActivityTypeKey,
	CASE WHEN PF.PropertyFundKey IS NULL THEN @PropertyFundKeyUnknown ELSE PF.PropertyFundKey END, -- PropertyFundKey,
	CASE WHEN AR.AllocationRegionKey IS NULL THEN @AllocationRegionKeyUnknown ELSE AR.AllocationRegionKey END, -- AllocationRegionKey,
	CASE WHEN
		PS.IsExpense = 1
		THEN
			CASE WHEN
				ORR.OriginatingRegionKey IS NULL
			THEN
				@OriginatingRegionKeyUnknown
			ELSE
				ORR.OriginatingRegionKey
			END
		ELSE
			CASE WHEN
				ORRFee.OriginatingRegionKey IS NULL
			THEN
				@OriginatingRegionKeyUnknown
			ELSE
				ORRFee.OriginatingRegionKey
			END
	END, -- OriginatingRegionKey,
	CASE WHEN O.OverheadKey IS NULL THEN @OverheadKeyUnknown ELSE O.OverheadKey END, -- OverheadKey,
	CASE WHEN FA.FeeAdjustmentKey IS NULL THEN @FeeAdjustmentKeyUnknown ELSE FA.FeeAdjustmentKey END, -- FeeAdjustmentKey,
	CASE WHEN C.CurrencyKey IS NULL THEN @LocalCurrencyKeyUnknown ELSE C.CurrencyKey END, -- LocalCurrencyKey,
	PS.BudgetAmount, -- LocalBudget,
	PS.ReferenceCode, -- ReferenceCode,
	PS.BudgetId, -- BudgetId,
	@SourceSystemId, -- SourceSystemId
	PS.IsExpense
FROM
	#ProfitabilitySource PS

	LEFT OUTER JOIN GrReporting.dbo.GlAccount GA ON
		PS.GLGlobalAccountId = GA.GLGlobalAccountId
	
	LEFT OUTER JOIN GrReporting.dbo.[Source] S ON
		PS.SourceCode = S.SourceCode	

	LEFT OUTER JOIN GrReporting.dbo.Reimbursable R ON
		PS.Reimbursable = R.ReimbursableCode

	LEFT OUTER JOIN GrReporting.dbo.ActivityType AT ON
		PS.ActivityTypeId = AT.ActivityTypeId

	LEFT OUTER JOIN GrReporting.dbo.PropertyFund PF ON
		PS.PropertyFundId = PF.PropertyFundId

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion AR ON
		PS.AllocationSubRegionGlobalRegionId = AR.GlobalRegionId

	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion ORRFee ON -- For fee income, allocation region = originating region
		PS.AllocationSubRegionGlobalRegionId = ORRFee.GlobalRegionId
	
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion ORR ON
		PS.OriginatingGlobalRegionId = ORR.GlobalRegionId
	
	LEFT OUTER JOIN GrReporting.dbo.Currency C ON
		PS.LocalCurrencyCode = C.CurrencyCode
	
	LEFT OUTER JOIN GrReporting.dbo.Overhead O ON
		PS.UnallocatedOverhead = O.OverheadCode
	
	LEFT OUTER JOIN GrReporting.dbo.FeeAdjustment FA ON
		PS.FeeAdjustment = FA.FeeAdjustmentCode

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
		PS.JobCode = FDJobCode.SubFunctionalDepartmentCode

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
	) FD ON
		PS.FunctionalDepartmentCode = FD.FunctionalDepartmentCode

WHERE
	PS.BudgetAmount <> 0

PRINT (''Rows inserted into #ProfitabilityBudget: '' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

-- ==============================================================================================================================================
-- Update #ProfitabilityBudget.GlobalGlAccountCategoryKey
-- ==============================================================================================================================================

--select * from #ProfitabilitySource

SET @StartTime = GETDATE()

UPDATE
	#ProfitabilityBudget
SET
	GlobalGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM #ProfitabilityBudget Gl

	LEFT OUTER JOIN #GLAccountCategoryMapping GLACM ON
		Gl.GlAccountKey = GLACM.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode =  CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLACM.GLTranslationTypeId) + '':'' + 
											CONVERT(VARCHAR(8), GLACM.GLTranslationSubTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLACM.GLMajorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLACM.GLMinorCategoryId) + '':'' +
											CONVERT(VARCHAR(8), GLACM.GLAccountTypeId) + '':'' +
											CONVERT(VARCHAR(8), GLACM.GLAccountSubTypeId))

PRINT (''Rows updated from #ProfitabilityBudget: '' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

-- ==============================================================================================================================================
-- Delete budgets to insert that have UNKNOWNS in their mapping
-- ==============================================================================================================================================

-- Delete all existing GBS records from dbo.ProfitabilityBudgetUnknowns
DELETE
FROM
	dbo.ProfitabilityBudgetUnknowns
WHERE
	SourceSystemId = @SourceSystemId -- Only delete GBS records, leave TAPAS records

INSERT INTO dbo.ProfitabilityBudgetUnknowns (
	ImportBatchId,
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalBudget,
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
	SourceSystemId,
	OverheadKey,
	FeeAdjustmentKey
)
SELECT
	@ImportBatchId,
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalBudget,
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
	SourceSystemId,
	OverheadKey,
	FeeAdjustmentKey
FROM
	#ProfitabilityBudget

WHERE
	GlAccountKey = @GlAccountKeyUnknown OR
	SourceKey = @SourceKeyUnknown OR
	(FunctionalDepartmentKey = @FunctionalDepartmentKeyUnknown AND IsExpense = 1) OR	
	ReimbursableKey = @ReimbursableKeyUnknown OR
	ActivityTypeKey = @ActivityTypeKeyUnknown OR
	PropertyFundKey = @PropertyFundKeyUnknown OR
	AllocationRegionKey = @AllocationRegionKeyUnknown OR
	OriginatingRegionKey = @OriginatingRegionKeyUnknown OR
	FeeAdjustmentKey = @FeeAdjustmentKeyUnknown OR
	LocalCurrencyKey = @LocalCurrencyKeyUnknown OR
	GlobalGlAccountCategoryKey = @GlobalGlAccountCategoryKeyUnknown
	-- LocalBudget
	-- OverheadKey: always UNKNOWN for Fees, UNKNOWN from non-payroll if Activity Type code <> CORPOH
	-- CalendarKey: not required to check if UNKNOWN or NULL because CalendarKey is hard-coded	
	-- ReferenceCode: not required to check if UNKNOWN or NULL because CalendarKey is hard-coded
	-- BudgetId: This field is sourced directly from GBS.Budget and cannot be NULL (has a ''not null'' dbase constraint in source system)
	-- SourceSystemId

DECLARE @RowsInserted INT = @@rowcount

IF (@RowsInserted > 0)
BEGIN
	PRINT (''Oh no - there are '' + CONVERT(VARCHAR(10), @RowsInserted) + '' unknowns in #ProfitabilityBudget. They have been inserted into dbo.ProfitabilityBudgetUnknowns.'')
	PRINT (''Deleting records associated with budgets that have unknowns...'')
	
	DECLARE @BudgetsWithUnknowns AS GBSBudgetImportBatchType
	
	INSERT INTO @BudgetsWithUnknowns
	SELECT DISTINCT
		Budget.ImportKey,
		Budget.BudgetId,
		Budget.ImportBatchId
	FROM
		#Budget Budget
		INNER JOIN (
			SELECT DISTINCT
				PBU.BudgetId
			FROM
				dbo.ProfitabilityBudgetUnknowns PBU
		) UnknownBudgets ON
			UnknownBudgets.BudgetId = Budget.BudgetId
	WHERE
		Budget.ImportBatchId = @ImportBatchId
	
	-- delete budgets with unknowns from #ProfitabilityBudget	
	DELETE
		PB
	FROM
		#ProfitabilityBudget PB
		INNER JOIN dbo.ProfitabilityBudgetUnknowns PBU ON
			PB.BudgetId = PBU.BudgetId
	
	PRINT (''Deleting #ProfitabilityBudget records associated with budgets that have unknowns: '' + LTRIM(RTRIM(STR(@@rowcount))) + '' (completed) '')
	
	-- delete these budgets and their associated data from GrReportingStaging
	EXEC dbo.stp_D_GBSBudget @BudgetsWithUnknowns

	PRINT (''Deleting GrReportingStaging GBS records associated with budgets that have unknowns: '' + LTRIM(RTRIM(STR(@@rowcount))) + '' (completed)'')
END

-- ==============================================================================================================================================
-- Delete existing budgets that we are about to insert
-- ==============================================================================================================================================

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


DECLARE @BudgetId int = -1
DECLARE @LoopCount int = 0 -- Infinite loop safe guard
WHILE (EXISTS (SELECT TOP 1 BudgetId FROM #BudgetsToImport) AND @LoopCount < 100000)
BEGIN
	
	SET @LoopCount = @LoopCount + 1
	
	SET @BudgetId = (SELECT TOP 1 BudgetId FROM #BudgetsToImport)

	DECLARE @row Int = 1
	DECLARE @deleteCnt Int = 0
	WHILE (@row > 0)
		BEGIN
		
			DELETE TOP (100000) -- Remove old facts
			FROM
				GrReporting.dbo.ProfitabilityBudget 
			WHERE
				BudgetId = @BudgetId AND
				SourceSystemId = @SourceSystemId
			
			SET @row = @@rowcount
			SET @deleteCnt = @deleteCnt + @row
			
			PRINT ''>>>:''+CONVERT(VARCHAR(10),@row)
			PRINT CONVERT(VARCHAR(27), getdate(), 121)
		
		END
		
	PRINT ''Rows Deleted from ProfitabilityBudget:''+CONVERT(VARCHAR(10),@deleteCnt)
	PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
	
	DELETE FROM #BudgetsToImport WHERE BudgetId = @BudgetId
	
	PRINT ''Rows Deleted from #DeletingBudget:''+CONVERT(VARCHAR(10),@@ROWCOUNT)
	PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
	
END

-- ==============================================================================================================================================
-- Insert budget records into GrReporting.dbo.ProfitabilityBudget
-- ==============================================================================================================================================

INSERT INTO GrReporting.dbo.ProfitabilityBudget
(
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	FeeAdjustmentKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
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
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	FeeAdjustmentKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	@EUCorporateGlAccountCategoryKeyUnknown, --EUCorporateGlAccountCategoryKey,
	@EUPropertyGlAccountCategoryKeyUnknown, --EUPropertyGlAccountCategoryKey,
	@EUFundGlAccountCategoryKeyUnknown, --EUFundGlAccountCategoryKey,

	@USPropertyGlAccountCategoryKeyUnknown, --USPropertyGlAccountCategoryKey,
	@USCorporateGlAccountCategoryKeyUnknown, ----USCorporateGlAccountCategoryKey,
	@USFundGlAccountCategoryKeyUnknown, --USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	@DevelopmentGlAccountCategoryKeyUnknown --DevelopmentGlAccountCategoryKey
FROM 
	#ProfitabilityBudget

-- ==============================================================================================================================================
-- Mark budgets as being successfully processed into the warehouse
-- ==============================================================================================================================================

UPDATE
	BTP
SET
	BTP.BudgetProcessedIntoWarehouse = CASE WHEN BTI.BudgetId IS NULL THEN 0 ELSE 1 END, -- 0 if import fails, 1 if import succeeds
	BTP.DateBudgetProcessedIntoWarehouse = GETDATE() -- date that the buget import either failed or succeeded (depending on 0 or 1 above)
FROM
	dbo.BudgetsToProcess BTP
	LEFT OUTER JOIN #BudgetsToImportOriginal BTI ON
		BTP.BudgetId = BTI.BudgetId
WHERE
	BTP.SourceSystemName = ''Global Budgeting System''

PRINT (''Rows updated from dbo.BudgetsToProcess: '' + CONVERT(VARCHAR(10),@@rowcount))

-- ==============================================================================================================================================
-- Delete archived budgets: only keep the last three budgets - older budgets must be deleted
-- ==============================================================================================================================================

DECLARE @BudgetsToDelete AS GBSBudgetImportBatchType

INSERT INTO @BudgetsToDelete
SELECT
	Budget.ImportKey,
	Budget.BudgetId,
	Budget.ImportBatchId
FROM
	GBS.Budget Budget
	LEFT OUTER JOIN (
						SELECT
							B1.*,
							B4.ranknum
						FROM
							GBS.Budget B1
							INNER JOIN (
								SELECT
									B2.ImportKey,
									COUNT(*) AS ranknum
								FROM
									GBS.Budget B2
									INNER JOIN GBS.Budget B3 ON
										B2.BudgetId = B3.BudgetId AND
										B2.ImportKey <= B3.ImportKey
								GROUP BY
									B2.ImportKey
								HAVING
									COUNT(*) <= 3 -- the number of version of a given budget that are to be archived (including the current budget)
							) B4 ON
								B1.ImportKey = B4.ImportKey
	) BudgetsToKeep ON
		Budget.ImportKey = BudgetsToKeep.ImportKey
WHERE
	BudgetsToKeep.ImportKey IS NULL

EXEC dbo.stp_D_GBSBudget @BudgetsToDelete

-- ==============================================================================================================================================
-- Clean up: drop temp tables
-- ==============================================================================================================================================

--select * from #ProfitabilityBudget-- WHERE FunctionalDepartmentKey = -1

IF 	OBJECT_ID(''tempdb..#Budget'') IS NOT NULL
    DROP TABLE #Budget

IF 	OBJECT_ID(''tempdb..#GLGlobalAccount'') IS NOT NULL
    DROP TABLE #GLGlobalAccount

IF 	OBJECT_ID(''tempdb..#GLTranslationSubType'') IS NOT NULL
    DROP TABLE #GLTranslationSubType

IF 	OBJECT_ID(''tempdb..#GLGlobalAccountTranslationSubType'') IS NOT NULL
    DROP TABLE #GLGlobalAccountTranslationSubType
    
IF 	OBJECT_ID(''tempdb..#GLMinorCategory'') IS NOT NULL
    DROP TABLE #GLMinorCategory
    
IF 	OBJECT_ID(''tempdb..#GLMajorCategory'') IS NOT NULL
    DROP TABLE #GLMajorCategory

IF 	OBJECT_ID(''tempdb..#GLGlobalAccountTranslationType'') IS NOT NULL
    DROP TABLE #GLGlobalAccountTranslationType

IF 	OBJECT_ID(''tempdb..#ReportingEntityCorporateDepartment'') IS NOT NULL
    DROP TABLE #ReportingEntityCorporateDepartment

IF 	OBJECT_ID(''tempdb..#PropertyFund'') IS NOT NULL
    DROP TABLE #PropertyFund

IF 	OBJECT_ID(''tempdb..#ActivityType'') IS NOT NULL
    DROP TABLE #ActivityType

IF 	OBJECT_ID(''tempdb..#CorporateDepartment'') IS NOT NULL
    DROP TABLE #CorporateDepartment

IF 	OBJECT_ID(''tempdb..#FunctionalDepartment'') IS NOT NULL
    DROP TABLE #FunctionalDepartment

IF 	OBJECT_ID(''tempdb..#AllocationSubRegion'') IS NOT NULL
    DROP TABLE #AllocationSubRegion

IF 	OBJECT_ID(''tempdb..#GLAccountCategoryMapping'') IS NOT NULL
    DROP TABLE #GLAccountCategoryMapping

IF 	OBJECT_ID(''tempdb..#ProfitabilitySource'') IS NOT NULL
    DROP TABLE #ProfitabilitySource

IF 	OBJECT_ID(''tempdb..#ProfitabilityBudget'') IS NOT NULL
    DROP TABLE #ProfitabilityBudget

IF 	OBJECT_ID(''tempdb..#BudgetsToImport'') IS NOT NULL
    DROP TABLE #BudgetsToImport

IF 	OBJECT_ID(''tempdb..#BudgetsToImportOriginal'') IS NOT NULL
	DROP TABLE #BudgetsToImportOriginal

IF 	OBJECT_ID(''tempdb..#BudgetsToDelete'') IS NOT NULL
    DROP TABLE #BudgetsToDelete

IF 	OBJECT_ID(''tempdb..#CorporatePropertySourceCodes'') IS NOT NULL
    DROP TABLE #CorporatePropertySourceCodes

IF 	OBJECT_ID(''tempdb..#BudgetsWithUnknowns'') IS NOT NULL
    DROP TABLE #BudgetsWithUnknowns

IF 	OBJECT_ID(''tempdb..#PreviousBudgetsLastLockedDate'') IS NOT NULL
    DROP TABLE #PreviousBudgetsLastLockedDate

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]    Script Date: 02/04/2011 18:03:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]	
	@DataPriorToDate	DateTime=NULL
AS

PRINT ''####''
PRINT ''stp_IU_LoadGrProfitabiltyPayrollOriginalBudget''
PRINT ''####''

-- Check whether the stored procedure should be run

DECLARE @CanImportTapasBudget INT = (SELECT ConfiguredValue FROM [GrReportingStaging].[dbo].[SSISConfigurations] WHERE ConfigurationFilter = ''CanImportTapasBudget'')

IF (@CanImportTapasBudget = 0)
BEGIN
	PRINT (''Import TapasBudget not scheduled in SSISConfigurations'')
	--RETURN
END

IF NOT EXISTS (SELECT 1 FROM dbo.BudgetsToProcess WHERE SourceSystemName = ''Tapas Budgeting'')
BEGIN
	PRINT (''*******************************************************'')
	PRINT (''	stp_IU_LoadGrProfitabiltyPayrollOriginalBudget is quitting because there are no TAPAS budgets set to be imported.'')
	PRINT (''*******************************************************'')
	RETURN
END

-- finshed checks

IF (@DataPriorToDate IS NULL)
BEGIN
	SET @DataPriorToDate = CONVERT(DateTime,(select ConfiguredValue From SSISConfigurations Where ConfigurationFilter = ''PayrollBudgetDataPriorToDate''))
END

DECLARE	 @LastImportBatchId INT = (SELECT MAX(BatchId) FROM Batch WHERE PackageName = ''ETL.Staging.TapasGlobalBudgeting'' AND BatchEndDate IS NOT NULL)

/*
exec [stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]
	@ImportStartDate	= ''1900-01-01'',
	@ImportEndDate		= ''2010-12-31'',
	@DataPriorToDate	= ''2010-12-31''
*/ 

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Setup mapping variables
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--/*
-- Setup Bonus Cap Excess Project Setting

CREATE TABLE #SystemSettingRegion(
	SystemSettingId INT NOT NULL,
	SystemSettingName VARCHAR(50) NOT NULL,
	SystemSettingRegionId INT NOT NULL,
	RegionId INT,
	SourceCode VARCHAR(2),
	BonusCapExcessProjectId INT
)
INSERT INTO #SystemSettingRegion(
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
	(SELECT 
		ssr.* 
	 FROM
		TapasGlobal.SystemSettingRegion ssr
		INNER JOIN TapasGlobal.SystemSettingRegionActive(@DataPriorToDate) ssrA ON
			ssr.ImportKey = ssrA.ImportKey
	 ) ssr
	INNER JOIN
		(SELECT
			ss.SystemSettingId,
			ss.Name
		 FROM
			(SELECT	
				ss.*
			 FROM
				TapasGlobal.SystemSetting ss
				INNER JOIN TapasGlobal.SystemSettingActive(@DataPriorToDate) ssA ON
					ss.ImportKey = ssA.ImportKey
			 ) ss

		  ) ss ON
		ssr.SystemSettingId = ss.SystemSettingId
		
PRINT ''Completed getting system settings''
PRINT CONVERT(Varchar(27), getdate(), 121)

--*/
-- Setup account categories and default to UNKNOWN.
DECLARE 
	@SalariesTaxesBenefitsGLMajorCategoryId INT = -1,
	@BaseSalaryMinorGlAccountCategoryId INT = -1,
	@BenefitsMinorGlAccountCategoryId INT = -1,
	@BonusMinorGlAccountCategoryId INT = -1,
	@ProfitShareMinorGlAccountCategoryId INT = -1,
	@OccupancyCostsMajorGlAccountCategoryId INT = -1,
	@OverheadMinorGlAccountCategoryId INT = -1
	
DECLARE 
	@GlAccountKey			 INT = (SELECT GlAccountKey FROM GrReporting.dbo.GlAccount WHERE Code = ''UNKNOWN''),
	@SourceKey				 INT = (SELECT SourceKey FROM GrReporting.dbo.[Source] WHERE SourceName = ''UNKNOWN''),
	@FunctionalDepartmentKey INT = (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = ''UNKNOWN''),
	@ReimbursableKey		 INT = (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = ''UNKNOWN''),
	@ActivityTypeKey		 INT = (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = ''UNKNOWN''),
	@PropertyFundKey		 INT = (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = ''UNKNOWN''),
	@AllocationRegionKey	 INT = (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = ''UNKNOWN''),
	@OriginatingRegionKey	 INT = (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = ''UNKNOWN''),
	@OverheadKey			 INT = (Select OverheadKey From GrReporting.dbo.Overhead Where OverheadCode = ''UNKNOWN''),
    @LocalCurrencyKey		 INT = (SELECT CurrencyKey FROM GrReporting.dbo.Currency WHERE CurrencyCode = ''UNKNOWN'')

DECLARE
	@EUFundGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Fund Profit & Loss''      AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN''),
	@EUCorporateGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Corporate Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN''),
	@EUPropertyGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''EU Property Profit & Loss''  AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN''),
	@USFundGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Fund Profit & Loss''      AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN''),
	@USPropertyGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Property Profit & Loss''  AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN''),
	@USCorporateGlAccountCategoryKeyUnknown INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''US Corporate Profit & Loss'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN''),
	@DevelopmentGlAccountCategoryKeyUnknown INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global Profit & Loss'' AND TranslationSubTypeName = ''Development Profit & Loss''  AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN''),
	@GlobalGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = ''Global'' AND TranslationSubTypeName = ''Global'' AND MajorCategoryName = ''UNKNOWN'' AND MinorCategoryName = ''UNKNOWN'' AND FeeOrExpense = ''UNKNOWN'' AND AccountSubTypeName = ''UNKNOWN'')



-- Set gl account categories
SELECT TOP 1
	@SalariesTaxesBenefitsGLMajorCategoryId = GLMajorCategoryId
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryName = ''Salaries/Taxes/Benefits''

print (@SalariesTaxesBenefitsGLMajorCategoryId)

--NB!!!!!!!
--The roll up to payroll is very sensitive information. It is crutial that information regarding payroll not get 
--communicated to TS employees on certain reports. Changing the category name here will have ramifications because 
--some reports check for this name.
--NB!!!!!!!

SELECT
	@BaseSalaryMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsGLMajorCategoryId AND
	GLMinorCategoryName = ''Base Salary''

SELECT
	@BenefitsMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsGLMajorCategoryId AND
	GLMinorCategoryName = ''Benefits''

SELECT
	@BonusMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsGLMajorCategoryId AND
	GLMinorCategoryName = ''Bonus''

SELECT
	@ProfitShareMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsGLMajorCategoryId AND
	GLMinorCategoryName = ''Benefits'' -- Yes benefit is correct (Just incase they want to split profit share out again)

SELECT TOP 1
	@OccupancyCostsMajorGlAccountCategoryId = GLMajorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryName = ''General Overhead''

SELECT
	@OverheadMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @OccupancyCostsMajorGlAccountCategoryId AND
	GLMinorCategoryName = ''External General Overhead''

DECLARE @SourceSystemId int
SET @SourceSystemId = 2 -- Tapas budgeting source system

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Source Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--/*

CREATE TABLE #BudgetAllocationSetSnapshots(
	BudgetAllocationSetId INT NOT NULL,
	SnapshotId INT NOT NULL
)

INSERT INTO #BudgetAllocationSetSnapshots(
	BudgetAllocationSetId,
	SnapshotId
)
SELECT
	CAST(GroupKey AS INT),
	SnapshotId
FROM 
	Gdm.Snapshot
WHERE
	GroupName = ''BudgetAllocationSet''
	

-- Get GLTranslationType, GLTranslationSubType, GLAccountType(either expense type), and GLAccountSubType(either payroll type) data
-- This table is used when inserts are made to the TranslationSubType CategoryLookup tables: search for ''Map account categories'' section
CREATE TABLE #GLAccountCategoryTranslations(
	SnapshotId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationSubTypeCode VARCHAR(10) NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL,
	IsPayroll BIT NOT NULL,
	IsOverhead BIT NOT NULL
)

INSERT INTO #GLAccountCategoryTranslations(
	SnapshotId,
	GLTranslationTypeId,
	GLTranslationSubTypeId,
	GLTranslationSubTypeCode,
	GLAccountTypeId,
	GLAccountSubTypeId,
	IsPayroll,
	IsOverhead
)
SELECT
	TST.SnapshotId,
	TST.GLTranslationTypeId,
	TST.GLTranslationSubTypeId,
	TST.Code,
	AT.GLAccountTypeId,
	AST.GLAccountSubTypeId,
	CASE WHEN AST.Code LIKE ''%PYR'' THEN 1 ELSE 0 END IsPayroll,
	CASE WHEN AST.Code LIKE ''%OHD'' THEN 1 ELSE 0 END IsOverhead	
FROM
	Gdm.SnapshotGLTranslationSubType TST

	INNER JOIN Gdm.SnapshotGLTranslationType TT ON
		TT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		TT.SnapshotId = TST.SnapshotId

	INNER JOIN Gdm.SnapshotGLAccountType AT ON
		TST.GLTranslationTypeId = AT.GLTranslationTypeId AND
		TST.SnapshotId = AT.SnapshotId

	INNER JOIN Gdm.SnapshotGLAccountSubType AST ON
		TST.GLTranslationTypeId = AST.GLTranslationTypeId AND
		TST.SnapshotId = AST.SnapshotId
	
WHERE	
	(AST.Code LIKE ''%PYR'' OR AST.Code LIKE ''%OHD'') AND
	TST.Code = ''GL'' AND	
	AT.Code LIKE ''%EXP'' AND
	TT.IsActive = 1 AND
	TST.IsActive = 1 AND
	AT.IsActive = 1 AND
	AST.IsActive = 1

PRINT ''Completed getting GlAccountCategory records''
PRINT CONVERT(Varchar(27), getdate(), 121)

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
	GroupEndPeriod INT NOT NULL
)

INSERT INTO #Budget(
	SnapshotId,	
	ImportKey,
	ImportBatchId,
	BudgetId,
	RegionId,	
	CurrencyCode,
	BudgetReportGroupId,
	BudgetReportGroupPeriod,
	GroupStartPeriod,
	GroupEndPeriod
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
	brg.EndPeriod AS GroupEndPeriod	
FROM
	dbo.BudgetsToProcess btp 
	
	INNER JOIN TapasGlobalBudgeting.Budget Budget ON
		Budget.BudgetId = btp.BudgetId
	INNER JOIN TapasGlobalBudgeting.BudgetActive(@DataPriorToDate) BudgetA ON
		Budget.ImportKey = BudgetA.ImportKey

	INNER JOIN TapasGlobalBudgeting.BudgetReportGroupDetail brgd ON
		Budget.BudgetId = brgd.BudgetId
	INNER JOIN TapasGlobalBudgeting.BudgetReportGroupDetailActive(@DataPriorToDate) brgdA ON
		brgd.ImportKey = brgdA.ImportKey

	INNER JOIN TapasGlobalBudgeting.BudgetReportGroup brg ON
		brgd.BudgetReportGroupId = brg.BudgetReportGroupId	
	INNER JOIN TapasGlobalBudgeting.BudgetReportGroupActive(@DataPriorToDate) brgA ON
		brg.ImportKey = brgA.ImportKey		
	
	INNER JOIN Gdm.BudgetReportGroupPeriod brgp ON
		brgp.BudgetReportGroupPeriodId = brg.BudgetReportGroupPeriodId
	INNER JOIN Gdm.BudgetReportGroupPeriodActive(@DataPriorToDate) brgpA ON
		brgp.ImportKey = brgpA.ImportKey
WHERE
	btp.SourceSystemName = ''Tapas Budgeting'' AND
	btp.IsReforecast = 0 AND		
	Budget.ImportBatchId = @LastImportBatchId

PRINT ''Completed inserting records into #Budget: ''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetID ON #Budget (BudgetId)
PRINT ''Completed creating indexes on #Budget''
PRINT CONVERT(Varchar(27), getdate(), 121)

--*/
------------------------------------------------------------------------------------------------------
--Source associated records
------------------------------------------------------------------------------------------------------

--/*
-- Source budget project
-- Get all the budget projects that are associated with the budgets that will be pulled, as per code above
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
	IsReimbursable BIT NOT NULL, --“NonPayrollReimbursable” 
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
	INNER JOIN TapasGlobalBudgeting.BudgetProjectActive(@DataPriorToDate) BudgetProjectA ON
		BudgetProject.ImportKey = BudgetProjectA.ImportKey
		
	-- data limiting join
	INNER JOIN #Budget b ON
		BudgetProject.BudgetId = b.BudgetId

PRINT ''Completed inserting records into #BudgetProject: ''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetID ON #BudgetProject (BudgetId)
PRINT ''Completed creating indexes on #BudgetProject''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source region

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
PRINT ''Completed inserting records into #Region: ''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Budget Employee

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
	INNER JOIN TapasGlobalBudgeting.BudgetEmployeeActive(@DataPriorToDate) BudgetEmployeeA ON
		BudgetEmployee.ImportKey = BudgetEmployeeA.ImportKey

	--data limiting join
	INNER JOIN #Budget b ON
		BudgetEmployee.BudgetId = b.BudgetId

PRINT ''Completed inserting records into #BudgetEmployee: ''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeeID ON #BudgetEmployee (BudgetEmployeeId)
CREATE INDEX IX_BudgetId ON #BudgetEmployee (BudgetId)
PRINT ''Completed creating indexes on #BudgetEmployee''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Budget Employee Functional Department

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
	INNER JOIN TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartmentActive(@DataPriorToDate) efdA ON
		efd.ImportKey = efdA.ImportKey

	-- data limiting join
	INNER JOIN #BudgetEmployee be ON
		efd.BudgetEmployeeId = be.BudgetEmployeeId

PRINT ''Completed inserting records into #BudgetEmployeeFunctionalDepartment: ''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeeId ON #BudgetEmployeeFunctionalDepartment (BudgetEmployeeId)
PRINT ''Completed creating indexes on #BudgetEmployeeFunctionalDepartment''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Location

CREATE TABLE #Location(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	LocationId INT NOT NULL,
	ExternalSubRegionId INT NOT NULL,
	StateId INT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
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
	[Name],
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
	
PRINT ''Completed inserting records into #Location: ''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_LocationId ON #Location (LocationId)
PRINT ''Completed creating indexes on #Location''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source region extended

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

PRINT ''Completed inserting records into #RegionExtended: ''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_RegionId ON #RegionExtended (RegionId)
PRINT ''Completed creating indexes on #RegionExtended''
PRINT CONVERT(Varchar(27), getdate(), 121)


-- Source project

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
	[Name] VARCHAR(100) NOT NULL,
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
	[Name],
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

PRINT ''Completed inserting records into #Project: ''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_ProjectId ON #Project (ProjectId)
PRINT ''Completed creating indexes on #Project''
PRINT CONVERT(Varchar(27), getdate(), 121)

------------------------------------------------------------------------------------------------------
--Source allocation records
------------------------------------------------------------------------------------------------------

-- Source payroll allocation

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

	INNER JOIN TapasGlobalBudgeting.BudgetEmployeePayrollAllocationActive(@DataPriorToDate) AllocationA ON
		Allocation.ImportKey = AllocationA.ImportKey

	--data limiting join
	INNER JOIN #BudgetProject bp ON
		Allocation.BudgetProjectId = bp.BudgetProjectId

PRINT ''Completed inserting records into #BudgetEmployeePayrollAllocation: ''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationId ON #BudgetEmployeePayrollAllocation (BudgetEmployeePayrollAllocationId)
PRINT ''Completed creating indexes on #BudgetEmployeePayrollAllocation''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source payroll tax detail
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Using the ''active'' function here cause serious performance issues and the only way around it, was to extract the logic from the is active function 
--to seperate peaces of code.
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

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
		
	INNER JOIN Batch ON
		B2.ImportBatchId = batch.BatchId
		
WHERE	
	batch.BatchEndDate IS NOT NULL AND
	batch.PackageName = ''ETL.Staging.TapasGlobalBudgeting'' AND
	batch.ImportEndDate <= @DataPriorToDate
		
GROUP BY
	B2.BudgetEmployeePayrollAllocationDetailId

PRINT ''Completed inserting records into #BudgetEmployeePayrollAllocationDetailBatches: ''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


CREATE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationDetailId ON #BudgetEmployeePayrollAllocationDetailBatches (BudgetEmployeePayrollAllocationDetailId, ImportBatchId)
PRINT ''Completed creating indexes on #BudgetEmployeePayrollAllocationDetailBatches''
PRINT CONVERT(Varchar(27), getdate(), 121)

----------

CREATE TABLE #BEPADa(
	ImportKey INT NOT NULL
)

INSERT INTO #BEPADa(
	ImportKey
)
SELECT
	MAX(B1.ImportKey) ImportKey
FROM
	[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B1

	INNER JOIN #BudgetEmployeePayrollAllocationDetailBatches t1 ON 
		t1.BudgetEmployeePayrollAllocationDetailId = B1.BudgetEmployeePayrollAllocationDetailId AND
		t1.ImportBatchId = B1.ImportBatchId

GROUP BY
	B1.BudgetEmployeePayrollAllocationDetailId

PRINT ''Completed inserting records into #BEPADa: ''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

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
	
	INNER JOIN #BEPADa TaxDetailA ON
		TaxDetail.ImportKey = TaxDetailA.ImportKey

	--data limiting join
	INNER JOIN #BudgetEmployeePayrollAllocation Allocation ON -- Only get tax details for the pre-tax amounts we are looking at
		TaxDetail.BudgetEmployeePayrollAllocationId = Allocation.BudgetEmployeePayrollAllocationId

PRINT ''Completed inserting records into #BudgetEmployeePayrollAllocationDetail: ''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationDetailId ON #BudgetEmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationDetailId)
PRINT ''Completed creating indexes on #BudgetEmployeePayrollAllocationDetail''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget tax type

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
	INNER JOIN TapasGlobalBudgeting.BudgetTaxTypeActive(@DataPriorToDate) BudgetTaxTypeA ON
		BudgetTaxType.ImportKey = BudgetTaxTypeA.ImportKey

	-- data limiting join
	INNER JOIN #Budget b ON
		BudgetTaxType.BudgetId = b.BudgetId

PRINT ''Completed inserting records into #BudgetTaxType: ''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetTaxTypeId ON #BudgetTaxType (BudgetTaxTypeId)
PRINT ''Completed creating indexes on #BudgetTaxType''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source tax type

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
	INNER JOIN TapasGlobalBudgeting.TaxTypeActive(@DataPriorToDate) TaxTypeA ON
		TaxType.ImportKey = TaxTypeA.ImportKey

PRINT ''Completed inserting records into #TaxType: ''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

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
		Allocation.BudgetEmployeePayrollAllocationId = TaxDetail.BudgetEmployeePayrollAllocationId 
			
	LEFT OUTER JOIN #BudgetTaxType BudgetTaxType ON -- rather pull through as unknown than exclude, therefore LEFT JOIN
		TaxDetail.BudgetTaxTypeId = BudgetTaxType.BudgetTaxTypeId
				
	LEFT OUTER JOIN #TaxType TaxType ON
		BudgetTaxType.TaxTypeId = TaxType.TaxTypeId	
			
PRINT ''Completed inserting records into #EmployeePayrollAllocationDetail: ''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #EmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationDetailId,BudgetEmployeePayrollAllocationId)
PRINT ''Completed creating indexes on #EmployeePayrollAllocationDetail''
PRINT CONVERT(Varchar(27), getdate(), 121)

--*/
-- Source payroll overhead allocation

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
	
	INNER JOIN TapasGlobalBudgeting.BudgetOverheadAllocationActive(@DataPriorToDate) OverheadAllocationA ON
		OverheadAllocation.ImportKey = OverheadAllocationA.ImportKey

	-- data limiting join
	INNER JOIN #Budget b ON
		OverheadAllocation.BudgetId = b.BudgetId

PRINT ''Completed inserting records into #BudgetOverheadAllocation: ''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocation (BudgetOverheadAllocationId,BudgetId,OverheadRegionId,BudgetEmployeeId)
PRINT ''Completed creating indexes on #BudgetOverheadAllocation''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source overhead allocation detail

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
	
	INNER JOIN TapasGlobalBudgeting.BudgetOverheadAllocationDetailActive(@DataPriorToDate) OverheadDetailA ON
		OverheadDetail.ImportKey = OverheadDetailA.ImportKey

	-- data limiting join
	INNER JOIN #BudgetProject b ON
		OverheadDetail.BudgetProjectId = b.BudgetProjectId

PRINT ''Completed inserting records into #BudgetOverheadAllocationDetail: ''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
PRINT ''Completed creating indexes on #BudgetOverheadAllocationDetail''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source payroll overhead allocation detail
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
	@OverheadMinorGlAccountCategoryId AS MinorGlAccountCategoryId, -- Hardcode to a specific minor category, could be changed later in the stored proc
	OverheadDetail.AllocationValue,
	OverheadDetail.AllocationAmount,
	OverheadDetail.InsertedDate,
	OverheadDetail.UpdatedDate,
	OverheadDetail.UpdatedByStaffId
FROM

	-- Joining on allocation to limit amount of data
	#BudgetOverheadAllocation OverheadAllocation
	
	INNER JOIN #BudgetOverheadAllocationDetail OverheadDetail ON -- Only pull allocationDetails for the allocations we are pulling
		OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId 
			
PRINT ''Completed inserting records into #OverheadAllocationDetail: ''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #OverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
PRINT ''Completed creating indexes on #OverheadAllocationDetail''
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Map Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

--Calculate effective functional department
-- What was the last period before an employee changed her functional department, finds all functional departments that an employee is associated with
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
	ISNULL((
		SELECT 
			EFD.FunctionalDepartmentId
		FROM 
			(
				SELECT 
					Allocation2.BudgetEmployeeId,
					MAX(EFD.EffectivePeriod) AS EffectivePeriod
				FROM
					#BudgetEmployeePayrollAllocation Allocation2

					INNER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
						Allocation2.BudgetEmployeeId = EFD.BudgetEmployeeId
		
				WHERE
					Allocation.BudgetEmployeePayrollAllocationId = Allocation2.BudgetEmployeePayrollAllocationId AND
					EFD.EffectivePeriod <= Allocation.Period
			  
				GROUP BY
					Allocation2.BudgetEmployeeId
			) EFDo
		
			LEFT OUTER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
				EFD.BudgetEmployeeId = EFDo.BudgetEmployeeId AND
				EFD.EffectivePeriod = EFDo.EffectivePeriod
	 ), -1) AS FunctionalDepartmentId
FROM
	#BudgetEmployeePayrollAllocation Allocation

	INNER JOIN #BudgetProject BudgetProject ON 
		Allocation.BudgetProjectId = BudgetProject.BudgetProjectId

PRINT ''Completed inserting records into #EffectiveFunctionalDepartment: ''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Pre Tax Amounts
CREATE TABLE #ProfitabilityPreTaxSource
(
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
	OriginatingRegionCode CHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	AllocationUpdatedDate DATETIME NOT NULL,
	BudgetReportGroupPeriod INT NOT NULL
)
-- Insert original budget amounts
-- links everything that we have pulled above (applying linking logic to tax, pre-tax and overhead data)
INSERT INTO #ProfitabilityPreTaxSource
(
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
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate,
	BudgetReportGroupPeriod
)
SELECT 
	Budget.SnapshotId,
	Budget.BudgetId AS BudgetId,
	Budget.RegionId AS BudgetRegionId,
	ISNULL(BudgetProject.ProjectId,0) AS ProjectId,
	ISNULL(BudgetEmployee.HrEmployeeId,0) AS HrEmployeeId,
	Allocation.BudgetEmployeePayrollAllocationId,
	''TGB:BudgetId='' + CONVERT(varchar,Budget.BudgetId) + ''&ProjectId='' + CONVERT(varchar,ISNULL(BudgetProject.ProjectId,0)) + ''&HrEmployeeId='' + CONVERT(varchar,ISNULL(BudgetEmployee.HrEmployeeId,0)) + ''&BudgetEmployeePayrollAllocationId='' + CONVERT(varchar,Allocation.BudgetEmployeePayrollAllocationId) + ''&BudgetEmployeePayrollAllocationDetailId=0&BudgetOverheadAllocationDetailId=0'' + ''&ImportKey='' + CONVERT(varchar, Allocation.ImportKey) AS ReferenceCode,
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
				WHEN (BudgetProject.CorporateDepartmentCode = ''@'' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN -- which property fund are we looking at 
					ProjectPropertyFund.PropertyFundId -- fall back
				ELSE -- else it is not @ or null, so use the mapping below (joining property fund from department to source)
					DepartmentPropertyFund.PropertyFundId 
			END, -1) AS PropertyFundId, -- else use -1, which is UNKNOWN
	
	ISNULL(CASE -- Same case logic as above
				WHEN (BudgetProject.CorporateDepartmentCode = ''@'' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,
		
	OriginatingRegion.CorporateEntityRef,
	OriginatingRegion.CorporateSourceCode,
	Budget.CurrencyCode AS LocalCurrencyCode,
	Allocation.UpdatedDate,
	Budget.BudgetReportGroupPeriod
	
FROM
	#BudgetEmployeePayrollAllocation Allocation -- tax amount

	INNER JOIN #BudgetProject BudgetProject ON 
		Allocation.BudgetProjectId = BudgetProject.BudgetProjectId				
			
	INNER JOIN #Budget Budget ON 
		BudgetProject.BudgetId = Budget.BudgetId 			
		
	LEFT OUTER JOIN #Region SourceRegion ON 
		Budget.RegionId = SourceRegion.RegionId

	LEFT OUTER JOIN #EffectiveFunctionalDepartment efd ON
		Allocation.BudgetEmployeePayrollAllocationId = efd.BudgetEmployeePayrollAllocationId

	LEFT OUTER JOIN Gdm.SnapshotFunctionalDepartment fd ON 
		efd.FunctionalDepartmentId = fd.FunctionalDepartmentId AND
		fd.SnapshotId = Budget.SnapshotId 

	LEFT OUTER JOIN Gdm.SnapshotPropertyFund ProjectPropertyFund ON
		BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
		ProjectPropertyFund.SnapshotId = Budget.SnapshotId 
		
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON 
		GrSc.SourceCode = SourceRegion.SourceCode

	LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping pfm ON
		BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		BudgetProject.CorporateSourceCode = pfm.SourceCode AND
		pfm.SnapshotId = Budget.SnapshotId  AND
						
		pfm.IsDeleted = 0 AND 
		(
			(GrSc.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId = BudgetProject.ActivityTypeId)
				OR
				(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
			)
		) AND
		Budget.BudgetReportGroupPeriod < 201007	
	
	LEFT OUTER JOIN	Gdm.SnapshotReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		RECD.SourceCode = BudgetProject.CorporateSourceCode AND
		RECD.SnapshotId = Budget.SnapshotId AND
		Budget.BudgetReportGroupPeriod >= 201007 AND			   
		RECD.IsDeleted = 0 
				   
	LEFT OUTER JOIN Gdm.SnapshotReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = ''YES'' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		REPE.SourceCode = BudgetProject.CorporateSourceCode AND
		REPE.SnapshotId = Budget.SnapshotId  AND
		Budget.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0

	LEFT OUTER JOIN Gdm.SnapshotPropertyFund DepartmentPropertyFund ON -- property fund could be coming from multiple sources
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN Budget.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = ''YES'' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END AND
		DepartmentPropertyFund.SnapshotId = Budget.SnapshotId

	LEFT OUTER JOIN #BudgetEmployee BudgetEmployee ON
		Allocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId
		
	LEFT OUTER JOIN #Location Location ON 
		Location.LocationId = BudgetEmployee.LocationId
		
	LEFT OUTER JOIN Gdm.SnapshotPayrollRegion OriginatingRegion ON 
		Location.ExternalSubRegionId = OriginatingRegion.ExternalSubRegionId AND
		Budget.RegionId = OriginatingRegion.RegionId AND
		OriginatingRegion.SnapshotId = Budget.SnapshotId

	INNER JOIN GrReporting.dbo.ActivityType Att ON Att.ActivityTypeId = BudgetProject.ActivityTypeId	
		
	LEFT OUTER JOIN Gdm.SnapshotCorporateDepartment Dept ON
		Dept.Code = BudgetProject.CorporateDepartmentCode AND 
		Dept.SourceCode = SourceRegion.SourceCode AND
		Dept.SnapshotId = Budget.SnapshotId

WHERE
	Allocation.Period BETWEEN Budget.GroupStartPeriod AND Budget.GroupEndPeriod --AND
	--Change Control 1 : GC 2010-09-01
	--BudgetProject.ActivityTypeId <> 99 -- exclude Corporate Overhead

PRINT ''Completed inserting records into #ProfitabilityPreTaxSource: ''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE INDEX IX_SalaryPreTaxAmount ON #ProfitabilityPreTaxSource (SalaryPreTaxAmount)
CREATE INDEX IX_ProfitSharePreTaxAmount ON #ProfitabilityPreTaxSource (ProfitSharePreTaxAmount)
CREATE INDEX IX_BonusPreTaxAmount ON #ProfitabilityPreTaxSource (BonusPreTaxAmount)

CREATE INDEX IX_BonusCapExcessPreTaxAmount ON #ProfitabilityPreTaxSource (BonusCapExcessPreTaxAmount)
PRINT ''Completed creating indexes on #ProfitabilityPreTaxSource''
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Tax Amounts

CREATE TABLE #ProfitabilityTaxSource
(
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
	OriginatingRegionCode CHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	AllocationUpdatedDate DATETIME NOT NULL,
	BudgetReportGroupPeriod INT NOT NULL	
)
-- Insert original budget amounts
INSERT INTO #ProfitabilityTaxSource
(
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
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate,
	BudgetReportGroupPeriod
)
SELECT
	pts.SnapshotId,
	pts.BudgetId,
	pts.BudgetRegionId,
	ISNULL(pts.ProjectId,0) AS ProjectId,
	ISNULL(pts.HrEmployeeId,0) AS HrEmployeeId,
	pts.BudgetEmployeePayrollAllocationId,
	TaxDetail.BudgetEmployeePayrollAllocationDetailId,
	''TGB:BudgetId='' + CONVERT(varchar,pts.BudgetId) + ''&ProjectId='' + CONVERT(varchar,ISNULL(pts.ProjectId,0)) + ''&HrEmployeeId='' + CONVERT(varchar,ISNULL(pts.HrEmployeeId,0)) + ''&BudgetEmployeePayrollAllocationId='' + CONVERT(varchar,pts.BudgetEmployeePayrollAllocationId) + ''&BudgetEmployeePayrollAllocationDetailId='' + CONVERT(varchar,TaxDetail.BudgetEmployeePayrollAllocationDetailId) + ''&BudgetOverheadAllocationDetailId=0'' + ''&ImportKey='' + CONVERT(varchar, TaxDetail.ImportKey) AS ReferenceCode,
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
	pts.OriginatingRegionCode,
	pts.OriginatingRegionSourceCode,
	pts.LocalCurrencyCode,
	pts.AllocationUpdatedDate,
	pts.BudgetReportGroupPeriod
FROM
	#EmployeePayrollAllocationDetail TaxDetail 

	INNER JOIN #ProfitabilityPreTaxSource pts ON -- pre tax has already been resolved, above, so join to limit taxdetail
		TaxDetail.BudgetEmployeePayrollAllocationId = pts.BudgetEmployeePayrollAllocationId


PRINT ''Completed inserting records into #ProfitabilityTaxSource: ''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Overhead Amounts

CREATE TABLE #ProfitabilityOverheadSource
(
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
	OriginatingRegionCode CHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	OverheadUpdatedDate DATETIME NOT NULL
)
-- Insert original overhead amounts
INSERT INTO #ProfitabilityOverheadSource
(
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
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	OverheadUpdatedDate
)
SELECT
	Budget.SnapshotId,
	Budget.BudgetId AS BudgetId,
	ISNULL(BudgetProject.ProjectId,0) AS ProjectId,
	ISNULL(BudgetEmployee.HrEmployeeId,0) AS HrEmployeeId,
	OverheadDetail.BudgetOverheadAllocationId,
	OverheadDetail.BudgetOverheadAllocationDetailId,
	''TGB:BudgetId='' + CONVERT(varchar,Budget.BudgetId) + ''&ProjectId='' + CONVERT(varchar,ISNULL(BudgetProject.ProjectId,0)) + ''&HrEmployeeId='' + CONVERT(varchar,ISNULL(BudgetEmployee.HrEmployeeId,0)) + ''&BudgetEmployeePayrollAllocationId=0&BudgetEmployeePayrollAllocationDetailId=0'' + ''&BudgetOverheadAllocationDetailId='' + CONVERT(varchar,OverheadDetail.BudgetOverheadAllocationDetailId) + ''&ImportKey='' + CONVERT(varchar, OverheadDetail.ImportKey) AS ReferenceCode,
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
	
	CASE -- allocation region gets sourced from property fund, project region = allocation region
		WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
			ISNULL(CASE
						WHEN (BudgetProject.CorporateDepartmentCode = ''@'' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
							ProjectPropertyFund.PropertyFundId
						ELSE
							DepartmentPropertyFund.PropertyFundId 
				   END, -1) 
		ELSE
			ISNULL(OverheadPropertyFund.PropertyFundId, -1)
	END AS PropertyFundId,
	
	ISNULL(CASE -- Same case logic as above
				WHEN (BudgetProject.CorporateDepartmentCode = ''@'' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,	
	
	OriginatingRegion.CorporateEntityRef,
	OriginatingRegion.CorporateSourceCode,
	Budget.CurrencyCode AS LocalCurrencyCode,
	OverheadDetail.UpdatedDate

FROM
	#BudgetOverheadAllocation OverheadAllocation 

	INNER JOIN #BudgetEmployee BudgetEmployee ON
		OverheadAllocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId

	INNER JOIN #OverheadAllocationDetail OverheadDetail ON -- where overhead amount sits
		OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId
			
	INNER JOIN #BudgetProject BudgetProject ON 
		OverheadDetail.BudgetProjectId = BudgetProject.BudgetProjectId
		
	INNER JOIN #Budget Budget ON 
		BudgetProject.BudgetId = Budget.BudgetId		
		
	LEFT OUTER JOIN #Region SourceRegion ON 
		Budget.RegionId = SourceRegion.RegionId
		
	LEFT OUTER JOIN #RegionExtended RegionExtended ON 
		SourceRegion.RegionId = RegionExtended.RegionId

	LEFT OUTER JOIN Gdm.SnapshotFunctionalDepartment fd ON
		RegionExtended.OverheadFunctionalDepartmentId = fd.FunctionalDepartmentId AND
		fd.SnapshotId = Budget.SnapshotId 

	LEFT OUTER JOIN	#Project OverheadProject ON
		BudgetProject.AllocateOverheadsProjectId = OverheadProject.ProjectId

	LEFT OUTER JOIN Gdm.SnapshotPropertyFund ProjectPropertyFund ON
		BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
		ProjectPropertyFund.SnapshotId = Budget.SnapshotId 
	
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrScC ON
		GrScC.SourceCode = BudgetProject.CorporateSourceCode

	LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping pfm ON
		BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		BudgetProject.CorporateSourceCode = pfm.SourceCode AND
		pfm.SnapshotId = Budget.SnapshotId AND
		
		pfm.IsDeleted = 0 AND 
		(
			(GrScC.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrScC.IsCorporate = ''YES'' AND pfm.ActivityTypeId = BudgetProject.ActivityTypeId)
				OR
				(GrScC.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
			)
		) AND
		Budget.BudgetReportGroupPeriod < 201007
	
	LEFT OUTER JOIN	Gdm.SnapshotReportingEntityCorporateDepartment RECDC ON
		GrScC.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
		RECDC.CorporateDepartmentCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		RECDC.SourceCode = BudgetProject.CorporateSourceCode AND
		RECDC.SnapshotId = Budget.SnapshotId AND
		Budget.BudgetReportGroupPeriod >= 201007 AND
		RECDC.IsDeleted = 0
		   
	LEFT OUTER JOIN Gdm.SnapshotReportingEntityPropertyEntity REPEC ON
		GrScC.IsProperty = ''YES'' AND -- only property MRIs resolved through this
		REPEC.PropertyEntityCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		REPEC.SourceCode = BudgetProject.CorporateSourceCode AND
		REPEC.SnapshotId = Budget.SnapshotId  AND
		Budget.BudgetReportGroupPeriod >= 201007 AND
		REPEC.IsDeleted = 0	
	
	LEFT OUTER JOIN Gdm.SnapshotPropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN Budget.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrScC.IsCorporate = ''YES'' THEN RECDC.PropertyFundId
						ELSE REPEC.PropertyFundId
					END
			END AND
		DepartmentPropertyFund.SnapshotId = Budget.SnapshotId

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrScO ON
		GrScO.SourceCode = OverheadProject.CorporateSourceCode

	LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping opfm ON
		OverheadProject.CorporateDepartmentCode = opfm.PropertyFundCode AND -- Combination of entity and corporate department
		OverheadProject.CorporateSourceCode = opfm.SourceCode AND
		opfm.SnapshotId = Budget.SnapshotId AND
		
		opfm.IsDeleted = 0 AND 
		(
			(GrScO.IsProperty = ''YES'' AND opfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrScO.IsCorporate = ''YES'' AND opfm.ActivityTypeId = BudgetProject.ActivityTypeId)
				OR
				(GrScO.IsCorporate = ''YES'' AND opfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
			)
		) AND
		Budget.BudgetReportGroupPeriod < 201007

	LEFT OUTER JOIN	Gdm.SnapshotReportingEntityCorporateDepartment RECDO ON
		GrScO.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
		RECDO.CorporateDepartmentCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		RECDO.SourceCode = BudgetProject.CorporateSourceCode AND
		RECDO.SnapshotId = Budget.SnapshotId AND
		Budget.BudgetReportGroupPeriod >= 201007 AND
		RECDO.IsDeleted = 0
		   
	LEFT OUTER JOIN Gdm.SnapshotReportingEntityPropertyEntity REPEO ON
		GrScO.IsProperty = ''YES'' AND -- only property MRIs resolved through this
		REPEO.PropertyEntityCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		REPEO.SourceCode = BudgetProject.CorporateSourceCode AND
		REPEO.SnapshotId = Budget.SnapshotId AND
		Budget.BudgetReportGroupPeriod >= 201007 AND
		REPEO.IsDeleted = 0	

	LEFT OUTER JOIN Gdm.SnapshotPropertyFund OverheadPropertyFund ON
		OverheadPropertyFund.PropertyFundId =
			CASE
				WHEN Budget.BudgetReportGroupPeriod < 201007 THEN opfm.PropertyFundId
				ELSE
					CASE
						WHEN GrScO.IsCorporate = ''YES'' THEN RECDO.PropertyFundId
						ELSE REPEO.PropertyFundId
					END
			END AND
		OverheadPropertyFund.SnapshotId = Budget.SnapshotId

	LEFT OUTER JOIN Gdm.SnapshotOverheadRegion OriginatingRegion ON 
		OverheadAllocation.OverheadRegionId = OriginatingRegion.OverheadRegionId AND
		OriginatingRegion.SnapshotId = Budget.SnapshotId
		
WHERE
	OverheadAllocation.BudgetPeriod BETWEEN Budget.GroupStartPeriod AND Budget.GroupEndPeriod
		
PRINT ''Completed inserting records into #ProfitabilityOverheadSource: ''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Generate mapping records
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityPayrollMapping
(
	SnapshotId INT NOT NULL,
	BudgetId int NOT NULL,
	ReferenceCode varchar(300) NOT NULL,
	ExpensePeriod char(6) NOT NULL,	
	SourceCode varchar(2) NULL,
	BudgetAmount money NOT NULL,
	MajorGlAccountCategoryId int NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	FunctionalDepartmentId int NOT NULL,
	FunctionalDepartmentCode varchar(31) NULL,
	Reimbursable bit NOT NULL,
	FeeOrExpense  Varchar(20) NOT NULL,
	ActivityTypeId int NOT NULL,
	PropertyFundId int NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	OriginatingRegionCode char(6) NULL,
	OriginatingRegionSourceCode varchar(2) NULL,
	LocalCurrencyCode char(3) NOT NULL,
	AllocationUpdatedDate datetime NOT NULL,
	GLAccountSubTypeIdGlobal INT NOT NULL,
	GlobalGlAccountCode Varchar(10) NULL	
)

INSERT INTO #ProfitabilityPayrollMapping
(
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
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate,
	GLAccountSubTypeIdGlobal,
	GlobalGlAccountCode
)
-- Get Base Salary Payroll pre tax mappings and budget
SELECT
	pps.SnapshotId,
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=SalaryPreTax'' AS ReferenceCode,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.SalaryPreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	@BaseSalaryMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	''SalaryPreTax'' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = ''CORPOH'' 
		THEN (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsOverhead = 1 AND SnapshotId = pps.SnapshotId)
		ELSE (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsPayroll = 1 AND SnapshotId = pps.SnapshotId)
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = ''CORPOH'' THEN
		''50029500''+RIGHT(''0''+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityPreTaxSource pps -- pull all pre-tax amounts that are not zero
WHERE
	pps.SalaryPreTaxAmount <> 0

-- Get Profit Share Benefit pre tax mappings and budget
UNION ALL

SELECT
	pps.SnapshotId,
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=ProfitSharePreTax'' AS ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.ProfitSharePreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	@ProfitShareMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	''ProfitSharePreTax'' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = ''CORPOH'' 
		THEN (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsOverhead = 1 AND SnapshotId = pps.SnapshotId)
		ELSE (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsPayroll = 1 AND SnapshotId = pps.SnapshotId)
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = ''CORPOH'' THEN
		''50029500''+RIGHT(''0''+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityPreTaxSource pps
		INNER JOIN GrReporting.dbo.ActivityType Att ON Att.ActivityTypeId = pps.ActivityTypeId
WHERE
	pps.ProfitSharePreTaxAmount <> 0

-- Get Bonus pre tax mappings and budget
UNION ALL

SELECT
	pps.SnapshotId,
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=BonusPreTax'' AS ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusPreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	@BonusMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	''BonusPreTax'' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = ''CORPOH'' 
		THEN (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsOverhead = 1 AND SnapshotId = pps.SnapshotId)
		ELSE (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsPayroll = 1 AND SnapshotId = pps.SnapshotId)
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = ''CORPOH'' THEN
		''50029500''+RIGHT(''0''+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityPreTaxSource pps
		INNER JOIN GrReporting.dbo.ActivityType Att ON Att.ActivityTypeId = pps.ActivityTypeId
WHERE
	pps.BonusPreTaxAmount <> 0

--Get bonus cap pre tax mappings
UNION ALL

SELECT
	pps.SnapshotId,
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=BonusCapExcessPreTax'' AS ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusCapExcessPreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	@BonusMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	0 AS Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
	''BonusCapExcessPreTax'' FeeOrExpense,
	ISNULL(p.ActivityTypeId, -1) AS ActivityTypeId,
	
	ISNULL(CASE
				WHEN (p.CorporateDepartmentCode = ''@'' OR p.CorporateDepartmentCode IS NULL) THEN -- settings logic for bonus cap, override property fund
					ProjectPropertyFund.PropertyFundId
				ELSE 
					DepartmentPropertyFund.PropertyFundId 
		   END, -1) AS PropertyFundId,

	ISNULL(CASE -- Same case logic as above
				WHEN (p.CorporateDepartmentCode = ''@'' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,

	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = ''CORPOH'' 
		THEN (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsOverhead = 1 AND SnapshotId = pps.SnapshotId)
		ELSE (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsPayroll = 1 AND SnapshotId = pps.SnapshotId)
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = ''CORPOH'' THEN
		''50029500''+RIGHT(''0''+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityPreTaxSource pps	

	INNER JOIN GrReporting.dbo.ActivityType Att ON 
		Att.ActivityTypeId = pps.ActivityTypeId
	
	LEFT OUTER JOIN #SystemSettingRegion ssr ON
		pps.SourceCode = ssr.SourceCode AND
		pps.BudgetRegionId = ssr.RegionId AND
		ssr.SystemSettingName = ''BonusCapExcess''
		
	LEFT OUTER JOIN #Project p ON
		ssr.BonusCapExcessProjectId = p.ProjectId
			
	LEFT OUTER JOIN Gdm.SnapshotPropertyFund ProjectPropertyFund ON
		p.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
		ProjectPropertyFund.SnapshotId = pps.SnapshotId
	
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		GrSc.SourceCode = pps.SourceCode
		
	LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping pfm ON
		p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		p.CorporateSourceCode = pfm.SourceCode AND
		pfm.SnapshotId = pps.SnapshotId AND
		--This is a bypass for the ''NULL'' scenario, for only CORP have ActivityTypeId''s set
		ISNULL(p.ActivityTypeId, -1) = ISNULL(pfm.ActivityTypeId, -1) AND --This is a bypass for the ''NULL'' scenario, for only CORP have ActivityTypeId''s set
		pfm.IsDeleted = 0 AND 
		(
			(GrSc.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId = p.ActivityTypeId)
				OR
				(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
			)
		) AND
		pps.BudgetReportGroupPeriod < 201007
	
	LEFT OUTER JOIN	Gdm.SnapshotReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		RECD.SourceCode = p.CorporateSourceCode AND
		RECD.SnapshotId = pps.SnapshotId AND
		pps.BudgetReportGroupPeriod >= 201007 AND			   
		RECD.IsDeleted = 0
		   
	LEFT OUTER JOIN Gdm.SnapshotReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = ''YES'' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		REPE.SourceCode = p.CorporateSourceCode AND
		REPE.SnapshotId = pps.SnapshotId AND
		pps.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0	
	
	LEFT OUTER JOIN Gdm.SnapshotPropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN pps.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = ''YES'' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END AND
		DepartmentPropertyFund.SnapshotId = pps.SnapshotId
		
WHERE
	pps.BonusCapExcessPreTaxAmount <> 0

UNION ALL

-- Get Base Salary Payroll Tax mappings and budget
SELECT
	pps.SnapshotId,
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=SalaryTax'' AS ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.SalaryTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	''SalaryTaxTax'' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = ''CORPOH'' 
		THEN (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsOverhead = 1 AND SnapshotId = pps.SnapshotId)
		ELSE (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsPayroll = 1 AND SnapshotId = pps.SnapshotId)
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = ''CORPOH'' THEN
		''50029500''+RIGHT(''0''+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityTaxSource pps
		INNER JOIN GrReporting.dbo.ActivityType Att ON Att.ActivityTypeId = pps.ActivityTypeId
WHERE
	pps.SalaryTaxAmount <> 0

-- Get Profit Share Benefit Tax mappings and budget
UNION ALL

SELECT
	pps.SnapshotId,
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=ProfitShareTax'' AS ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.ProfitShareTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	''ProfitShareTax'' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = ''CORPOH'' 
		THEN (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsOverhead = 1 AND SnapshotId = pps.SnapshotId)
		ELSE (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsPayroll = 1 AND SnapshotId = pps.SnapshotId)
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = ''CORPOH'' THEN
		''50029500''+RIGHT(''0''+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityTaxSource pps
		INNER JOIN GrReporting.dbo.ActivityType Att ON Att.ActivityTypeId = pps.ActivityTypeId
WHERE
	pps.ProfitShareTaxAmount <> 0

-- Get Bonus Tax mappings and budget
UNION ALL

SELECT
	pps.SnapshotId,
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=BonusTax'' AS ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	''BonusTax'' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = ''CORPOH'' 
		THEN (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsOverhead = 1 AND SnapshotId = pps.SnapshotId)
		ELSE (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsPayroll = 1 AND SnapshotId = pps.SnapshotId)
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = ''CORPOH'' THEN
		''50029500''+RIGHT(''0''+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.BonusTaxAmount <> 0

-- Get Bonus cap Tax mappings 
UNION ALL

SELECT
	pps.SnapshotId,
	pps.BudgetId,
	pps.ReferenceCode + ''&Type=BonusCapExcessTax'' AS ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusCapExcessTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	0 AS Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
	''BonusCapExcessTax'' FeeOrExpense,
	ISNULL(p.ActivityTypeId, -1) AS ActivityTypeId,
	
	ISNULL(CASE
				WHEN (p.CorporateDepartmentCode = ''@'' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.PropertyFundId
				ELSE 
					DepartmentPropertyFund.PropertyFundId 
		   END, -1) AS PropertyFundId,
		   
	ISNULL(CASE -- Same case logic as above
				WHEN (p.CorporateDepartmentCode = ''@'' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,		   

	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = ''CORPOH'' 
		THEN (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsOverhead = 1 AND SnapshotId = pps.SnapshotId)
		ELSE (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsPayroll = 1 AND SnapshotId = pps.SnapshotId)
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = ''CORPOH'' THEN
		''50029500''+RIGHT(''0''+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityTaxSource pps	
		
	LEFT OUTER JOIN #SystemSettingRegion ssr ON
		pps.SourceCode = ssr.SourceCode AND
		pps.BudgetRegionId = ssr.RegionId AND
		ssr.SystemSettingName = ''BonusCapExcess''

	LEFT OUTER JOIN #Project p ON
		ssr.BonusCapExcessProjectId = p.ProjectId

	LEFT OUTER JOIN Gdm.SnapshotPropertyFund ProjectPropertyFund ON
		p.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
		ProjectPropertyFund.SnapshotId = pps.SnapshotId

	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON 
		GrSc.SourceCode = pps.SourceCode

	LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping pfm ON
		p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		p.CorporateSourceCode = pfm.SourceCode AND
		pfm.SnapshotId = pps.SnapshotId AND
		pfm.IsDeleted = 0 AND 
		(
			(GrSc.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId = p.ActivityTypeId)
				OR
				(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
			)
		) AND
		pps.BudgetReportGroupPeriod < 201007
	
	LEFT OUTER JOIN	Gdm.SnapshotReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		RECD.SourceCode = p.CorporateSourceCode AND
		RECD.SnapshotId = pps.SnapshotId AND
		pps.BudgetReportGroupPeriod >= 201007 AND			   
		RECD.IsDeleted = 0
		   
	LEFT OUTER JOIN Gdm.SnapshotReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = ''YES'' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		REPE.SourceCode = p.CorporateSourceCode AND
		REPE.SnapshotId = pps.SnapshotId AND
		pps.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0		
	
	LEFT OUTER JOIN Gdm.SnapshotPropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN pps.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = ''YES'' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END AND
		DepartmentPropertyFund.SnapshotId = pps.SnapshotId

WHERE
	pps.BonusCapExcessTaxAmount <> 0
	
-- Get Overhead mappings	
UNION ALL

SELECT
	pos.SnapshotId,
	pos.BudgetId,
	pos.ReferenceCode + ''&Type=OverheadAllocation'' AS ReferenceCode,
	pos.ExpensePeriod,
	pos.SourceCode,
	pos.OverheadAllocationAmount AS BudgetAmount,
	@OccupancyCostsMajorGlAccountCategoryId AS MinorGlAccountCategoryId,
	pos.MinorGlAccountCategoryId, 
	pos.FunctionalDepartmentId,
	pos.FunctionalDepartmentCode,
	pos.Reimbursable,  
	''Overhead'' FeeOrExpense,
	pos.ActivityTypeId,
	pos.PropertyFundId,
	pos.AllocationSubRegionGlobalRegionId,
	pos.OriginatingRegionCode,
	pos.OriginatingRegionSourceCode,
	pos.LocalCurrencyCode,
	pos.OverheadUpdatedDate,
	(SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsOverhead = 1 AND SnapshotId = pos.SnapshotId),
	--General Allocated Overhead Account :: CC8
	''50029500''+RIGHT(''0''+LTRIM(STR(pos.ActivityTypeId,3,0)),2)
FROM
	#ProfitabilityOverheadSource pos
WHERE
	pos.OverheadAllocationAmount <> 0


PRINT ''Completed inserting records into #ProfitabilityPayrollMapping: ''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_AllocationUpdatedDate ON #ProfitabilityPayrollMapping(ReferenceCode,AllocationUpdatedDate)
PRINT ''Completed creating indexes on #ProfitabilityPayrollMapping''
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Map mapped source data into the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
------------------------------------------------------------------------------------------------------
-- Map to the fact
------------------------------------------------------------------------------------------------------
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--If the join is not possible, default the link to the ''UNKNOWN'' link
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityBudget(
	CalendarKey int NOT NULL,
	GlAccountKey int NOT NULL,
	SourceKey int NOT NULL,
	FunctionalDepartmentKey int NOT NULL,
	ReimbursableKey int NOT NULL,
	ActivityTypeKey int NOT NULL,
	PropertyFundKey int NOT NULL,	
	AllocationRegionKey int NOT NULL,
	OriginatingRegionKey int NOT NULL,
	OverheadKey int NOT NULL,
	LocalCurrencyKey int NOT NULL,
	LocalBudget money NOT NULL,
	ReferenceCode Varchar(300) NOT NULL,
	BudgetId int NOT NULL,
	SourceSystemId int NOT NULL,
	
	EUCorporateGlAccountCategoryKey int NULL,
	EUPropertyGlAccountCategoryKey int NULL,
	EUFundGlAccountCategoryKey int NULL,

	USPropertyGlAccountCategoryKey int NULL,
	USCorporateGlAccountCategoryKey int NULL,
	USFundGlAccountCategoryKey int NULL,

	GlobalGlAccountCategoryKey int NULL,
	DevelopmentGlAccountCategoryKey int NULL
) 

INSERT INTO #ProfitabilityBudget 
(
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId
)
SELECT
	DATEDIFF(dd, ''1900-01-01'', LEFT(pbm.ExpensePeriod,4)+''-''+RIGHT(pbm.ExpensePeriod,2)+''-01'') AS CalendarKey,
	CASE WHEN GrGa.GlAccountKey IS NULL THEN @GlAccountKey ELSE GrGa.GlAccountKey END GlAccountKey,
	CASE WHEN GrSc.[SourceKey] IS NULL THEN @SourceKey ELSE GrSc.[SourceKey] END SourceKey,
	CASE WHEN GrFdm.[FunctionalDepartmentKey] IS NULL THEN @FunctionalDepartmentKey ELSE GrFdm.[FunctionalDepartmentKey] END FunctionalDepartmentKey,
	CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKey ELSE GrRi.ReimbursableKey END ReimbursableKey,
	CASE WHEN GrAt.[ActivityTypeKey] IS NULL THEN @ActivityTypeKey ELSE GrAt.[ActivityTypeKey] END ActivityTypeKey,
	CASE WHEN GrPf.[PropertyFundKey] IS NULL THEN @PropertyFundKey ELSE GrPf.[PropertyFundKey] END PropertyFundKey,
	CASE WHEN GrAr.[AllocationRegionKey] IS NULL THEN @AllocationRegionKey ELSE GrAr.[AllocationRegionKey] END AllocationRegionKey,
	CASE WHEN GrOr.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKey ELSE GrOr.[OriginatingRegionKey] END OriginatingRegionKey,
	CASE WHEN GrOh.[OverheadKey] IS NULL THEN @OverheadKey ELSE GrOh.[OverheadKey] END OverheadKey,
	CASE WHEN GrCu.[CurrencyKey] IS NULL THEN @LocalCurrencyKey ELSE GrCu.[CurrencyKey] END LocalCurrencyKey,
	pbm.BudgetAmount,
	pbm.ReferenceCode,
	pbm.BudgetId,
	@SourceSystemId
FROM
	#ProfitabilityPayrollMapping pbm
	
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON
		GrSc.SourceCode = pbm.SourceCode

	LEFT OUTER JOIN GrReporting.dbo.GlAccount GrGa ON
		GrGa.Code = pbm.GlobalGlAccountCode AND --Gam.GlobalGlAccountId AND
		pbm.AllocationUpdatedDate BETWEEN GrGa.StartDate AND GrGa.EndDate
		
	--Parent Level (No job code for payroll)
	LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdm ON
		pbm.AllocationUpdatedDate BETWEEN GrFdm.StartDate AND GrFdm.EndDate AND
		GrFdm.SubFunctionalDepartmentCode = GrFdm.FunctionalDepartmentCode AND
		--GrFdm.ReferenceCode LIKE pbm.FunctionalDepartmentCode +'':%'' AND --replaced by new logic below
		GrFdm.FunctionalDepartmentCode = pbm.FunctionalDepartmentCode
		
	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		CASE WHEN pbm.Reimbursable = 1 THEN ''YES'' ELSE ''NO'' END = GrRi.ReimbursableCode

	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		pbm.ActivityTypeId = GrAt.ActivityTypeId AND
		pbm.AllocationUpdatedDate BETWEEN GrAt.StartDate AND GrAt.EndDate

	LEFT OUTER JOIN GrReporting.dbo.Overhead GrOh ON
		--GC :: Change Control 1
		GrOh.OverheadCode = CASE WHEN pbm.FeeOrExpense = ''Overhead'' THEN ''ALLOC'' 
									WHEN GrAt.ActivityTypeCode = ''CORPOH'' THEN ''UNALLOC'' 
									ELSE ''UNKNOWN'' END

	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		pbm.PropertyFundId = GrPf.PropertyFundId AND
		pbm.AllocationUpdatedDate BETWEEN GrPf.StartDate AND GrPf.EndDate

	-- HACK: At some point tapas was supposed to pull project region out of GDM. 
	-- Now allocation regions are source based??? So I use the code because it is built up from the ProjectRegionId since there is only data for one source anyway.
	-- I don''t check source because actuals also don''t check source. 
	--LEFT OUTER JOIN #AllocationRegionMapping Arm ON
	--	Arm.RegionCode = pbm.ProjectRegionId AND -- TODO: Pull the RegionCode through from the top.
	--	Arm.IsDeleted = 0

	LEFT OUTER JOIN Gdm.SnapshotAllocationSubRegion ASR ON
		pbm.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId AND
		ASR.SnapshotId = pbm.SnapshotId 

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		ASR.AllocationSubRegionGlobalRegionId = GrAr.GlobalRegionId AND
		pbm.AllocationUpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate

/* -- At some point Allocation region in GDM was going to become the master list
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		pbm.ProjectRegionId = GrAr.GlobalRegionId AND
		pbm.AllocationUpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate
*/

	--LEFT OUTER JOIN #OriginatingRegionMapping Orm ON
	--	Orm.RegionCode = CASE WHEN RIGHT(pbm.OriginatingRegionSourceCode,1) = ''C'' THEN LTRIM(RTRIM(pbm.OriginatingRegionCode))
	--							ELSE LTRIM(RTRIM(pbm.OriginatingRegionCode)) + LTRIM(RTRIM(pbm.FunctionalDepartmentCode)) END AND
	--	Orm.SourceCode = pbm.OriginatingRegionSourceCode AND
	--	Orm.IsDeleted = 0

	LEFT OUTER JOIN Gdm.SnapshotOriginatingRegionCorporateEntity ORCE ON
		ORCE.CorporateEntityCode = pbm.OriginatingRegionCode AND
		ORCE.SourceCode = pbm.OriginatingRegionSourceCode AND 
		ORCE.SnapshotId = pbm.SnapshotId AND
		ORCE.IsDeleted = 0
		   
	LEFT OUTER JOIN Gdm.SnapshotOriginatingRegionPropertyDepartment ORPD ON
		ORPD.PropertyDepartmentCode = pbm.OriginatingRegionCode AND
		ORPD.SourceCode = pbm.OriginatingRegionSourceCode AND
		ORPD.SnapshotId = pbm.SnapshotId AND
		ORPD.IsDeleted = 0		
		
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		GrOr.GlobalRegionId = ISNULL(ORCE.GlobalRegionId, ORPD.GlobalRegionId) AND
		pbm.AllocationUpdatedDate BETWEEN GrOr.StartDate AND GrOr.EndDate
	
	LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
		pbm.LocalCurrencyCode = GrCu.CurrencyCode 

PRINT ''Completed inserting records into #ProfitabilityBudget: ''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProfitabilityBudget (ReferenceCode)
CREATE INDEX IX_CalendarKey ON #ProfitabilityBudget (CalendarKey)

PRINT ''Completed creating indexes on #OriginatingRegionMapping''
PRINT CONVERT(Varchar(27), getdate(), 121)

------------------------------------------------------------------------------------------------------
-- Map account categories
------------------------------------------------------------------------------------------------------

--GlobalGlAccountCategoryKey

CREATE TABLE #GlobalCategoryLookup(
	GlAccountCategoryKey INT NULL,
	ReferenceCode VARCHAR(300) NOT NULL
)

INSERT INTO #GlobalCategoryLookup(
	GlAccountCategoryKey,
	ReferenceCode
)

SELECT 
	GlAcGlobal.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT 
			ACT.GLTranslationTypeId,
			ACT.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			ACT.GLAccountTypeId,
			ACT.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode
		 FROM	
			#ProfitabilityPayrollMapping Gl				
			LEFT OUTER JOIN #GLAccountCategoryTranslations ACT ON 
				ACT.GLAccountSubTypeId = Gl.GLAccountSubTypeIdGlobal AND
				ACT.SnapshotId = Gl.SnapshotId
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcGlobal ON GlAcGlobal.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + '':'' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0)))

			AND Gl.AllocationUpdatedDate  BETWEEN GlAcGlobal.StartDate AND GlAcGlobal.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #GlobalCategoryLookup (ReferenceCode)

UPDATE
	#ProfitabilityBudget
SET
	GlobalGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END
FROM
	#GlobalCategoryLookup t1
WHERE
	t1.ReferenceCode = #ProfitabilityBudget.ReferenceCode



PRINT ''Completed converting all GlobalGlAccountCategoryKey keys: ''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


/*

This is where other Translation used to be and should be :: Gcloete

--EUCorporateGlAccountCategoryKey
--EUPropertyGlAccountCategoryKey
--EUFundGlAccountCategoryKey
--USPropertyGlAccountCategoryKey
--USCorporateGlAccountCategoryKey
--USFundGlAccountCategoryKey
--DevelopmentGlAccountCategoryKey
*/

/****** Stash unknowns and remove budget groups from import ******/

DELETE [dbo].[ProfitabilityBudgetUnknowns]
WHERE [SourceSystemId] = @SourceSystemId

INSERT INTO [dbo].[ProfitabilityBudgetUnknowns]
   ([ImportBatchId]
   ,[CalendarKey]
   ,[GlAccountKey]
   ,[SourceKey]
   ,[FunctionalDepartmentKey]
   ,[ReimbursableKey]
   ,[ActivityTypeKey]
   ,[PropertyFundKey]
   ,[AllocationRegionKey]
   ,[OriginatingRegionKey]
   ,[LocalCurrencyKey]
   ,[LocalBudget]
   ,[ReferenceCode]
   ,[EUCorporateGlAccountCategoryKey]
   ,[USPropertyGlAccountCategoryKey]
   ,[USFundGlAccountCategoryKey]
   ,[EUPropertyGlAccountCategoryKey]
   ,[USCorporateGlAccountCategoryKey]
   ,[DevelopmentGlAccountCategoryKey]
   ,[EUFundGlAccountCategoryKey]
   ,[GlobalGlAccountCategoryKey]
   ,[BudgetId]
   ,[SourceSystemId]
   ,[OverheadKey]
   ,[FeeAdjustmentKey])
SELECT
	b.ImportBatchId,
	pb.CalendarKey,
	pb.GlAccountKey,
	pb.SourceKey,
	pb.FunctionalDepartmentKey,
	pb.ReimbursableKey,
	pb.ActivityTypeKey,
	pb.PropertyFundKey,
	pb.AllocationRegionKey,
	pb.OriginatingRegionKey,
	pb.LocalCurrencyKey,
	pb.LocalBudget,
	pb.ReferenceCode,
	@EUCorporateGlAccountCategoryKeyUnknown,
	@USPropertyGlAccountCategoryKeyUnknown,	
	@USFundGlAccountCategoryKeyUnknown, 	
	@EUPropertyGlAccountCategoryKeyUnknown,
	@USCorporateGlAccountCategoryKeyUnknown, 
	@DevelopmentGlAccountCategoryKeyUnknown,
	@EUFundGlAccountCategoryKeyUnknown, 
	pb.GlobalGlAccountCategoryKey,	
	pb.BudgetId,
	pb.SourceSystemId,
	pb.OverheadKey,
	(Select FeeAdjustmentKey From GrReporting.dbo.FeeAdjustment Where FeeAdjustmentCode = ''NORMAL'')
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
	@LocalCurrencyKey = pb.LocalCurrencyKey

PRINT ''Completed inserting records into ProfitabilityBudgetUnknowns: '' + CONVERT(CHAR(10), @@ROWCOUNT)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

/******* Remove rows from staging import batch which are associated with budgets with unknowns ******/

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
	[dbo].[ProfitabilityBudgetUnknowns]

DELETE x
FROM TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment x
INNER JOIN #BudgetEmployeeFunctionalDepartment xh ON
	xh.ImportKey = x.ImportKey
INNER JOIN #BudgetEmployee be ON
	be.BudgetEmployeeId = xh.BudgetEmployeeId
INNER JOIN #DeletingBudget d ON
	d.BudgetId = be.BudgetId

PRINT ''Deleted from BudgetEmployeeFunctionalDepartment: '' + CONVERT(CHAR(10), @@ROWCOUNT)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

DELETE x
FROM TapasGlobalBudgeting.BudgetEmployee x
INNER JOIN #BudgetEmployee xh ON
	xh.ImportKey = x.ImportKey
INNER JOIN #DeletingBudget d ON
	d.BudgetId = xh.BudgetId

PRINT ''Deleted from BudgetEmployee: '' + CONVERT(CHAR(10), @@ROWCOUNT)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

DELETE x
FROM TapasGlobalBudgeting.BudgetEmployeePayrollAllocationDetail x
INNER JOIN #BudgetEmployeePayrollAllocationDetail xh ON
	xh.ImportKey = x.ImportKey
INNER JOIN #BudgetEmployeePayrollAllocation bpa ON
	bpa.BudgetEmployeePayrollAllocationId = xh.BudgetEmployeePayrollAllocationId
INNER JOIN #BudgetProject bp ON
	bp.BudgetProjectId = bpa.BudgetProjectId
INNER JOIN #DeletingBudget d ON
	d.BudgetId = bp.BudgetId

PRINT ''Deleted from BudgetEmployeePayrollAllocationDetail: '' + CONVERT(CHAR(10), @@ROWCOUNT)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

DELETE x
FROM TapasGlobalBudgeting.BudgetEmployeePayrollAllocation x
INNER JOIN #BudgetEmployeePayrollAllocation xh ON
	xh.ImportKey = x.ImportKey
INNER JOIN #BudgetProject bp ON
	bp.BudgetProjectId = xh.BudgetProjectId
INNER JOIN #DeletingBudget d ON
	d.BudgetId = bp.BudgetId

PRINT ''Deleted from BudgetEmployeePayrollAllocation: '' + CONVERT(CHAR(10), @@ROWCOUNT)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

DELETE x
FROM TapasGlobalBudgeting.BudgetOverheadAllocationDetail x
INNER JOIN #BudgetOverheadAllocationDetail xh ON
	xh.ImportKey = x.ImportKey
INNER JOIN #BudgetProject bp ON
	bp.BudgetProjectId = xh.BudgetProjectId
INNER JOIN #DeletingBudget d ON
	d.BudgetId = bp.BudgetId

PRINT ''Deleted from BudgetOverheadAllocationDetail: '' + CONVERT(CHAR(10), @@ROWCOUNT)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

DELETE x
FROM TapasGlobalBudgeting.BudgetProject x
INNER JOIN #BudgetProject xh ON
	xh.ImportKey = x.ImportKey
INNER JOIN #DeletingBudget d ON
	d.BudgetId = xh.BudgetId
	
PRINT ''Deleted from BudgetProject: '' + CONVERT(CHAR(10), @@ROWCOUNT)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

DELETE x
FROM TapasGlobalBudgeting.BudgetTaxType x
INNER JOIN #BudgetTaxType xh ON
	xh.ImportKey = x.ImportKey
INNER JOIN #DeletingBudget d ON
	d.BudgetId = xh.BudgetId

PRINT ''Deleted from BudgetTaxType: '' + CONVERT(CHAR(10), @@ROWCOUNT)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

DELETE x
FROM TapasGlobalBudgeting.BudgetReportGroupDetail x
INNER JOIN #Budget b ON
	b.BudgetId = x.BudgetId AND
	b.ImportBatchId = x.ImportBatchId
INNER JOIN #DeletingBudget d ON
	d.BudgetId = b.BudgetId

PRINT ''Deleted from BudgetReportGroupDetail: '' + CONVERT(CHAR(10), @@ROWCOUNT)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

DELETE x
FROM TapasGlobalBudgeting.Budget x
INNER JOIN #Budget xh ON
	xh.ImportKey = x.ImportKey
INNER JOIN #DeletingBudget d ON
	d.BudgetId = xh.BudgetId

PRINT ''Deleted from Budget: '' + CONVERT(CHAR(10), @@ROWCOUNT)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

/******* Remove rows from budgets in bugdet report groups in which there are budgets with unknowns ****/

DELETE #ProfitabilityBudget
WHERE 
	BudgetId IN (
		SELECT DISTINCT BudgetId 
		FROM #Budget
		WHERE BudgetReportGroupId IN (
			SELECT DISTINCT BudgetReportGroupId
			FROM #Budget 
			WHERE BudgetId IN (
				SELECT DISTINCT BudgetId
				FROM [dbo].[ProfitabilityBudgetUnknowns]
			)			
		)
	)

PRINT ''Completed removing records from #ProfitabilityBudget: '' + CONVERT(CHAR(10), @@ROWCOUNT)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Remove existing data for modified budget projects
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #BudgetsToImportOriginal ( -- we keep an original copy of the budgets to insert because #BudgetsToImport will always be empty after the loop below
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

CREATE TABLE #BudgetsToImport (
	BudgetId INT NOT NULL
)
INSERT INTO #BudgetsToImport (
	BudgetId
)
SELECT
	BudgetId
FROM
	#BudgetsToImportOriginal


DECLARE @BudgetId int = -1
DECLARE @LoopCount int = 0 -- Infinite loop safe guard

WHILE (EXISTS (SELECT TOP 1 BudgetId FROM #BudgetsToImport) AND @LoopCount < 100000)
BEGIN
	
	SET @LoopCount = @LoopCount + 1
	SET @BudgetId = (SELECT TOP 1 BudgetId FROM #BudgetsToImport)
	
	DECLARE @row Int = 1
	DECLARE @deleteCnt Int = 0
	WHILE (@row > 0)
		BEGIN
		-- Remove old facts
		DELETE TOP (100000)
		FROM GrReporting.dbo.ProfitabilityBudget 
		Where BudgetId = @BudgetId and SourceSystemId = @SourceSystemId
		
		SET @row = @@rowcount
		SET @deleteCnt = @deleteCnt + @row
		
		PRINT ''>>>: ''+CONVERT(char(10),@row)
		PRINT CONVERT(Varchar(27), getdate(), 121)
		
		END
		
	PRINT ''Rows Deleted from ProfitabilityBudget''+CONVERT(char(10),@deleteCnt)
	PRINT CONVERT(Varchar(27), getdate(), 121)
	
	PRINT ''Completed deleting records from ProfitabilityBudget:BudgetId=''+CONVERT(varchar,@BudgetId)
	PRINT CONVERT(Varchar(27), getdate(), 121)

	DELETE
	FROM
		#BudgetsToImport
	WHERE
		BudgetId = @BudgetId
END

print ''Cleaned up rows in ProfitabilityBudget''

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Insert modified and new data 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

INSERT INTO GrReporting.dbo.ProfitabilityBudget
(
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	FeeAdjustmentKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
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
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	(Select FeeAdjustmentKey From GrReporting.dbo.FeeAdjustment Where FeeAdjustmentCode = ''NORMAL''),
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	@EUCorporateGlAccountCategoryKeyUnknown, --EUCorporateGlAccountCategoryKey,
	@EUPropertyGlAccountCategoryKeyUnknown, --EUPropertyGlAccountCategoryKey,
	@EUFundGlAccountCategoryKeyUnknown, --EUFundGlAccountCategoryKey,

	@USPropertyGlAccountCategoryKeyUnknown, --USPropertyGlAccountCategoryKey,
	@USCorporateGlAccountCategoryKeyUnknown, ----USCorporateGlAccountCategoryKey,
	@USFundGlAccountCategoryKeyUnknown, --USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	@DevelopmentGlAccountCategoryKeyUnknown --DevelopmentGlAccountCategoryKey

FROM 
	#ProfitabilityBudget

print ''Rows Inserted in ProfitabilityBudget: ''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

UPDATE
	BTP
SET
	BTP.BudgetProcessedIntoWarehouse = CASE WHEN BTIO.BudgetId IS NULL THEN 0 ELSE 1 END,
	BTP.DateBudgetProcessedIntoWarehouse = CASE WHEN BTIO.BudgetId IS NULL THEN NULL ELSE GETDATE() END
FROM
	dbo.BudgetsToProcess BTP
	LEFT OUTER JOIN #BudgetsToImportOriginal BTIO ON
		BTP.BudgetId = BTIO.BudgetId
WHERE
	BTP.SourceSystemName = ''Tapas Budgeting''

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Clean up
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

DROP TABLE #SystemSettingRegion
DROP TABLE #BudgetAllocationSetSnapshots
DROP TABLE #GLAccountCategoryTranslations
DROP TABLE #Budget
DROP TABLE #BudgetProject
DROP TABLE #Region
DROP TABLE #BudgetEmployee
DROP TABLE #BudgetEmployeeFunctionalDepartment
DROP TABLE #Location
DROP TABLE #RegionExtended
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
DROP TABLE #ProfitabilityBudget
DROP TABLE #DeletingBudget
DROP TABLE #BudgetsToImportOriginal
DROP TABLE #GlobalCategoryLookup


------------------------------------------------------------------------------------------------------------------------------------------' 
END
GO
