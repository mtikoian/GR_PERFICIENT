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
	SERVER3.GDM_GR.dbo.BudgetReportGroupPeriod BRGP
	
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
			INNER JOIN SERVER3.GDM_GR.dbo.BudgetReportGroupPeriod BRGP ON
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
			BudgetGBS.CanImportBudgetIntoGR,
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
		
	INNER JOIN SERVER3.GDM_GR.dbo.[Snapshot] S ON
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
