USE [GrReportingStaging]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_I_BudgetsToProcess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_I_BudgetsToProcess]
GO

CREATE PROCEDURE [dbo].[stp_I_BudgetsToProcess]
AS

----========================================================================================================================
---- Declare variables and create common tables
----========================================================================================================================

DELETE
FROM
	dbo.BudgetsToProcess

DECLARE @GBSSourceSystemId INT = (SELECT SourceSystemId FROM GrReporting.dbo.SourceSystem WHERE Name = 'Global Budgeting System')
DECLARE @TAPASSourceSystemId INT = (SELECT SourceSystemId FROM GrReporting.dbo.SourceSystem WHERE Name = 'Tapas Budgeting')

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
	S.GroupName = 'BudgetAllocationSet'

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
	S.GroupName = 'BudgetAllocationSet'


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
		Budget.BudgetId = BSM.BudgetId AND
		@GBSSourceSystemId = BSM.SourceSystemId
WHERE
	BSM.SourceSystemId = @GBSSourceSystemId AND
	(	-- if the budget is locked and it has never been imported (i.e.: LastImportBudgetIntoGR is NULL), then import it
		(Budget.LastLockedDate IS NOT NULL AND Budget.LastLockedDate > ISNULL(Budget.LastImportBudgetIntoGRDate, '1900-01-01')) OR
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
			b.LastLockedDate > ISNULL(b.LastImportBudgetIntoGRDate, '1900-01-01') OR b.ImportBudgetIntoGR = 1 
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
		brgp.IsDeleted = 0 AND
		brgp.[Year] > 2010 -- Dummy tapas budgets for 2010 have been created which we do not want to import
)
INSERT INTO #BudgetsToProcess
SELECT 
	@TAPASSourceSystemId, -- SourceSystemId
	b.BudgetId,			  -- BudgetId
	1,					  -- ImportBudgetFromSourceSystem
	b.IsReforecast,		  -- IsReforecast
	BSM.SnapshotId,		  -- SnapshotId
	0					  -- ImportSnapshotFromSourceSystem: don't know whether the snapshot has changed and needs repimporting - assume it doesn't
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
		i.BudgetId = BSM.BudgetId AND
		@TAPASSourceSystemId = BSM.SourceSystemId

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
	0,				   -- ImportBudgetFromSourceSystem: Assume that the budget doesn't require importing. If it does it should have been identified in [A] above
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
					ISNULL(S.ManualUpdatedDate, '1900-01-01') > ISNULL(SS.ManualUpdatedDate, '1900-01-01')
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
					ISNULL(S.LastSyncDate, '1900-01-01') > ISNULL(SS.LastSyncDate, '1900-01-01') AND
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

IF 	OBJECT_ID('tempdb..#BudgetsToProcess') IS NOT NULL
	DROP TABLE #BudgetsToProcess

IF 	OBJECT_ID('tempdb..#BudgetSnapshotMapping') IS NOT NULL
	DROP TABLE #BudgetSnapshotMapping