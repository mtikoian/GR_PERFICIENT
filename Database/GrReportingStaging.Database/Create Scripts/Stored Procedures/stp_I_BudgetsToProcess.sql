USE [GrReportingStaging]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_BudgetsToProcess]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[stp_IU_BudgetsToProcess]
GO

CREATE PROCEDURE [dbo].[stp_IU_BudgetsToProcess]
	@IsTestExecution BIT = 0,
	@ForceSnapshotsToBeReimported BIT = 0,
	@GBSBudgetIdsToForcefullyProcess VARCHAR(128) = NULL,
	@TAPASBudgetIdsToForcefullyProcess VARCHAR(128) = NULL
	
AS

	/*
		It is sometimes the case that we want to manually specificy certain budgets to be (re)processed without (re)processing other budgets
			that are legitimately ready to be loaded into the warehouse (for instance, a new budget has just been locked in GBS on live but we
			need to run the job for a minor support release and process an existing budget, and need to put the processing of the new GBSbudget
			on hold for the time being).

		The @GBSBudgetIdsToForcefullyProcess and @TAPASBudgetIdsToForcefullyProcess parameters allow for a pipe-separated list of budget Ids for
			each system to be passed to this stored procedure. These budgets are then forced to be (re)processed.

		The @ForceSnapshotsToBeReimported parameter indicates whether the snapshots associated with budgets that are to be forcefully reprocessed
			should be reimported.
	*/

/* =============================================================================================================================================
	Process stored procedure parameters
   =========================================================================================================================================== */
BEGIN

	IF (@IsTestExecution = 1)
	BEGIN
		PRINT ('dbo.stp_I_BudgetsToProcess is executing in test mode ...')
	END

	CREATE TABLE #GBSBudgetIdsToForcefullyProcess (
		BudgetId INT NOT NULL
	)

	CREATE TABLE #TAPASBudgetIdsToForcefullyProcess (
		BudgetId INT NOT NULL
	)

	DECLARE @ErrorMessage NVARCHAR(MAX)

	IF (@GBSBudgetIdsToForcefullyProcess IS NOT NULL)
	BEGIN

		BEGIN TRY

			INSERT INTO #GBSBudgetIdsToForcefullyProcess
			SELECT
				CONVERT(INT, LTRIM(RTRIM(item)))
			FROM
				GrReporting.dbo.SPLIT(@GBSBudgetIdsToForcefullyProcess)

		END TRY
		
		BEGIN CATCH

			SET @ErrorMessage = ERROR_MESSAGE()
			RAISERROR(N'An error was thrown while trying to split and cast " %s ". %s. If multiple budget ids are being passed, make sure they are | seperated. Aborting ...', 10, 1, @GBSBudgetIdsToForcefullyProcess, @ErrorMessage)

			RETURN; -- Quit as it was the intention of the executor to exclude certain budgets, and there is no guarantee that this will now happen.

		END CATCH
		
	END

	IF (@TAPASBudgetIdsToForcefullyProcess IS NOT NULL)
	BEGIN

		BEGIN TRY

			INSERT INTO #TAPASBudgetIdsToForcefullyProcess
			SELECT
				CONVERT(INT, LTRIM(RTRIM(item)))
			FROM
				GrReporting.dbo.SPLIT(@TAPASBudgetIdsToForcefullyProcess)

		END TRY
		
		BEGIN CATCH

			SET @ErrorMessage = ERROR_MESSAGE()
			RAISERROR(N'An error was thrown while trying to split and cast " %s ". %s. If multiple budget ids are being passed, make sure they are | seperated. Aborting ...', 10, 1, @TAPASBudgetIdsToForcefullyProcess, @ErrorMessage)

			RETURN; -- Quit as it was the intention of the executor to exclude certain budgets, and there is no guarantee that this will now happen.

		END CATCH
		
	END

END

/* =============================================================================================================================================
	Perform validity check on dbo.BudgetsToProcess table
   =========================================================================================================================================== */
IF (@IsTestExecution = 0)
BEGIN

	/*
		Make sure that no records currently have their IsCurrentBatch flags set to 1 as there is a chance that we will be inserting a new batch
			of budgets to (re)process.
	*/

	UPDATE
		dbo.BudgetsToProcess
	SET
		IsCurrentBatch = 0
	WHERE
		IsCurrentBatch = 1

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

	PRINT ('Problems during the previous import were not handled correctly as ("OriginalBudgetProcessedIntoWarehouse" IS NULL OR "DateBudgetProcessedIntoWarehouse" IS NULL)')
	
	UPDATE
		dbo.BudgetsToProcess
	SET
		OriginalBudgetProcessedIntoWarehouse = ISNULL(OriginalBudgetProcessedIntoWarehouse, -1),
		ImportBatchId = ISNULL(ImportBatchId, -1),
		BudgetSourceSystemSyncd = ISNULL(BudgetSourceSystemSyncd, 0),
		DateBudgetProcessedIntoWarehouse = ISNULL(DateBudgetProcessedIntoWarehouse, GETDATE()),
		ReasonForFailure = ISNULL(ReasonForFailure, '') +
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

	UPDATE
		dbo.BudgetsToProcess
	SET
		ReforecastActualsProcessedIntoWarehouse = ISNULL(ReforecastActualsProcessedIntoWarehouse, -1),
		ReforecastBudgetsProcessedIntoWarehouse = ISNULL(ReforecastBudgetsProcessedIntoWarehouse, -1),
		DateBudgetProcessedIntoWarehouse = ISNULL(DateBudgetProcessedIntoWarehouse, GETDATE()),
		ImportBatchId = ISNULL(ImportBatchId, -1),
		BudgetSourceSystemSyncd = ISNULL(BudgetSourceSystemSyncd, 0),
		ReasonForFailure = ISNULL(ReasonForFailure, '') + 'Validity check in stp_I_BudgetsToProcess failed|' + -- NULL + string returns NULL, which is not what we want
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

/* =============================================================================================================================================
	Declare variables and create common tables
   =========================================================================================================================================== */
BEGIN

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		At present there is no way to determine which GBS or TAPAS budget is used for a given reforecast. In other words, there's no absolute
			way to determine which GBS and TAPAS budgets are used for the 2011 Q1 reforecast, for instance.
		To help determine which budgets/reforecasts are linked to a given reforecast (Q0 -> Q3), a mapping between reforecasts and
			BudgetAllocationSet is created.
	*/

	CREATE TABLE #BudgetAllocationSetYearQuarterMapping (
		BudgetAllocationSetId INT NOT NULL,
		BudgetYear INT NOT NULL,
		BudgetQuarter CHAR(2) NOT NULL
	)

	INSERT INTO #BudgetAllocationSetYearQuarterMapping (
		BudgetAllocationSetId,
		BudgetYear,
		BudgetQuarter
	)
	VALUES
		(1, 2011, 'Q0'),
		(9, 2011, 'Q1'),
		(10, 2011, 'Q2')

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		Find all possible Budget-to-Snapshot mappings that are possible for both GBS and TAPAS
	*/

	CREATE TABLE #BudgetSnapshotMapping (
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
		
		INNER JOIN
		(
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
				BudgetGBS.CanImportBudgetIntoGR,
				BudgetGBS.BudgetAllocationSetId,
				NULL AS BudgetReportGroupId,
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

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		Find all budgets and reforecasts for 2011 that have already been processed into the warehouse
	*/

	CREATE TABLE #ExistingBudgetsReforecasts (
		BudgetId INT NOT NULL,
		BudgetReforecastTypeName VARCHAR(32) NOT NULL,
		IsReforecast BIT NOT NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #ExistingBudgetsReforecasts

	SELECT DISTINCT -- this DISTINCT shouldn't be necessary, but there's a 'bug' that needs looking into (ReferenceCodes LIKE 'TGB:GBSBudgetId=3&BudgetProfitabilityActualId=...')
		ExistingBudgetsReforecasts.BudgetId,
		BRT.BudgetReforecastTypeName,
		ExistingBudgetsReforecasts.IsReforecast,
		ExistingBudgetsReforecasts.SnapshotId
	FROM
	(
		-- Get Original Budgets in the warehouse (after 2010)
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
			C.CalendarYear > 2010
			
		UNION ALL

		-- Get Reforecasts in the warehouse (after 2010)
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
			C.CalendarYear > 2010

	)	ExistingBudgetsReforecasts

		INNER JOIN GrReporting.dbo.BudgetReforecastType BRT ON
			ExistingBudgetsReforecasts.BudgetReforecastTypeKey = BRT.BudgetReforecastTypeKey

END

/* =============================================================================================================================================
	Check that, for all the budgets (both original and reforecast) that have been processed into the warehouse, the LastImportBudgetIntoGRDate
		field for these budgets in GBS.dbo.Budget and TAPASUS_Budgeting.Budget.Budget is not NULL (which implies that, according to
		GBS/TAPASUS_Budgeting the budget has never been processed into the warehouse before) - this is a problem as the logic that follows in
		this stored procedure assumes that this is not the case.
	=========================================================================================================================================== */
BEGIN

	SELECT
		EBR.BudgetReforecastTypeName,
		EBR.BudgetId,
		EBR.IsReforecast,
		EBR.SnapshotId
	INTO
		#ProcessedBudgetsNotReflectingAsProcessedInSource
	FROM
		#ExistingBudgetsReforecasts EBR

		INNER JOIN #BudgetSnapshotMapping BSM ON
			EBR.BudgetReforecastTypeName = BSM.BudgetReforecastTypeName AND
			EBR.BudgetId = BSM.BudgetId
	WHERE
		BSM.LastImportBudgetIntoGRDate IS NULL

	IF EXISTS (SELECT * FROM #ProcessedBudgetsNotReflectingAsProcessedInSource)
	BEGIN

		SELECT
			*
		FROM
			#ProcessedBudgetsNotReflectingAsProcessedInSource
		ORDER BY
			BudgetReforecastTypeName,
			BudgetId,
			IsReforecast

		RAISERROR ('Budget(s) that have been processed into the warehouse are not reflected as such in the budget source tables (LastImportBudgetIntoGRDate IS NULL). Aborting ...', 16, -1)
		RETURN -- just to make sure we don't continue execution at this point
	
	END

END

/* =============================================================================================================================================
	A: Find all budgets that are to be processed into the warehouse because they have been flagged to be imported:
		1. An unlocked budget's ImportBudgetIntoGR field is set to 1
		2. A locked budget's LastLockedDate in GBS/TAPAS is greater than the budget's LastLockedDate in GrReportingStaging.GBS/TAPAS
			(or if the budget has been locked for the first time)
   =========================================================================================================================================== */
BEGIN

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The ImportBudgetFromSourceSystem and ImportSnapshotFromSourceSystem fields are of data type INT and not BIT because aggregate functions
			are to be applied to them.
	*/

	CREATE TABLE #BudgetsToProcess (
		BudgetReforecastTypeName VARCHAR(32) NOT NULL, -- 'GBS Budget/Reforecast' or 'TGB Budget/Reforecast'
		BudgetId INT NOT NULL,						   -- either the GBS or TAPAS budget id	
		BudgetExchangeRateId INT NOT NULL,
		BudgetReportGroupPeriodId INT NOT NULL,
		BudgetAllocationSetId INT NOT NULL,
		ImportBudgetFromSourceSystem INT NOT NULL,		/*
															True if the budget is required to be imported/reimported from GBS AND reprocessed
																into the warehouse because of changes to the budget. If False, then the budget
																only requires reprocessing into the warehouse, and not reimporting from the
																source system as well.
														*/
		IsReforecast BIT NOT NULL,				       -- will be set to 1 when reforecasts are processed
		SnapshotId INT NULL,
		ImportSnapshotFromSourceSystem INT NOT NULL,
		MustImportAllActualsIntoWarehouse INT NULL,    -- Initially set to null because we will determine whether actuals need to be imported later
		ReasonForProcessing VARCHAR(1024) NOT NULL
	)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		These include:
			1. All locked _budgets_ that have been processed into the warehouse whose LastLockedDates have changed since they were last imported
			2. All locked _budgets_ that have never been processed into the warehouse before
			3. All unlocked _budgets_ whose ImportBudgetIntoGR fields are set to 1
	*/

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
		-----
		CASE
			WHEN
				@GBSBudgetIdsToForcefullyProcess IS NOT NULL OR @TAPASBudgetIdsToForcefullyProcess IS NOT NULL
			THEN
				@ForceSnapshotsToBeReimported -- if we're forcing budgets to be (re)processed, use the value of @ForceSnapshotsToBeReimported
			ELSE
				0	-- ImportSnapshotFromSourceSystem: don't know whether the snapshot has changed and needs repimporting - assume it doesn't
		END AS ImportSnapshotFromSourceSystem,	  
		-----
		CASE
			WHEN
				BSM.IsReforecast = 1			-- If the budget is a reforecast ...
			THEN
				CASE
					WHEN
						BSM.LastLockedDate IS NULL			  -- If the budget is not locked ...
					THEN
						1									  --  ... keep reimporting all of its actuals
					ELSE
						0									  -- if the budget is locked, assume that all of its actuals have already been imported
				END
			ELSE
				NULL							   -- Else the budget must be an original budget, so use NULL because of the check constraint
		END	AS MustImportAllActualsIntoWarehouse,  -- MustImportAllActualsIntoWarehouse: don't know whether all actuals need importing, assume they don't (i.e.: only import fee actuals)	
		-----
		CASE
			WHEN
				@GBSBudgetIdsToForcefullyProcess IS NULL AND @TAPASBudgetIdsToForcefullyProcess IS NULL
			THEN
				CASE
					WHEN
						BSM.LastLockedDate IS NOT NULL
					THEN
						CASE
							WHEN
								BSM.LastImportBudgetIntoGRDate IS NULL
							THEN
								'Budget is locked but has never been processed (LastImportBudgetIntoGRDate IS NULL)'
							ELSE
								CASE
									WHEN
										BSM.LastLockedDate > BSM.LastImportBudgetIntoGRDate
									THEN
										'Budget has been relocked (LastLockedDate = ' + CONVERT(VARCHAR, BSM.LastLockedDate) + ') since it was last processed (LastImportBudgetIntoGRDate = ' + CONVERT(VARCHAR, BSM.LastImportBudgetIntoGRDate) + ')'
								END
						END
					WHEN
						BSM.LastLockedDate IS NULL AND
						BSM.ImportBudgetIntoGR = 1					
					THEN
						'Budget is unlocked and has been flagged for processing (ImportBudgetIntoGR = 1)'
					ELSE
						'Not sure - something strange has happened'
				END
			ELSE
				'Budget has been set to be forcefully processed'		
		END AS ReasonForProcessing
	FROM
		#BudgetSnapshotMapping BSM
		
		LEFT OUTER JOIN
		(	/*
				This join caters for the case when either GBS and/or TAPAS budgets are being forcefully (re)processed.
				Look in the WHERE clause below for details of how this table is used if this is the case.	
			*/		
			SELECT
				'GBS Budget/Reforecast' AS BudgetReforecastTypeName,
				BudgetId
			FROM
				#GBSBudgetIdsToForcefullyProcess
			
			UNION ALL
			
			SELECT
				'TGB Budget/Reforecast' AS BudgetReforecastTypeName,
				BudgetId
			FROM
				#TAPASBudgetIdsToForcefullyProcess

		) BudgetsToForcefullyProcess ON
			BSM.BudgetReforecastTypeName = BudgetsToForcefullyProcess.BudgetReforecastTypeName AND
			BSM.BudgetId = BudgetsToForcefullyProcess.BudgetId
	WHERE
		(	/*
				If neither GBS not TAPAS budgets have been marked to be forecefully reprocessed ...
			*/
			(@GBSBudgetIdsToForcefullyProcess IS NULL AND @TAPASBudgetIdsToForcefullyProcess IS NULL) AND
			(	/*
					If the budget has been relocked since it was originally processed into the warehouse, or it is locked but has never been
						imported (point 2. above) - (i.e.: LastLockedDate IS NOT NULL AND LastImportBudgetIntoGR IS NULL)
				*/	
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
		)
		OR
		(	/*
				Either GBS or TAPAS budgets (or both) are to be forefully (re)processed ...
			*/		
			(@GBSBudgetIdsToForcefullyProcess IS NOT NULL OR @TAPASBudgetIdsToForcefullyProcess IS NOT NULL) AND
			(	/*
					Only consider those budgets in #BudgetSnapshotMapping that could join onto the budgets that are to be forecefully
						(re)processed.
				*/			
				BudgetsToForcefullyProcess.BudgetId IS NOT NULL
			)
		)

END

/* =============================================================================================================================================
	B: Find all budgets in the warehouse that are associated with snapshots that have been resync'd (if the snapshot is unlocked) or manually
	   changed (if the snapshot is locked) since these budgets were last imported.
   =========================================================================================================================================== */
BEGIN

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
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
	WHERE
		ExistingBudgetsReforecasts.BudgetId IS NULL

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		If an unlocked snapshot has changed it is only reimported if it is used by a budget that is to be imported.
		Determine which snapshots (that are used by budgets in the warehouse) require reimporting and which budgets (that have previously been
			processed into the warehouse) require reprocessing as a result.

		Note: Locked snapshots should not be resyncd. If a locked snapshot is resyncd that is associated with a budget that has already been
			processed into the warehouse, we will not automatically reprocess the budget (as this is a special case that theoretically should not
			happen - if it does, we will have to manually cater for this)
	*/

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
		-----
		CASE
			WHEN
				BSM.IsReforecast = 0
			THEN
				NULL							   -- NULL because of the check constraint on the dbo.BudgetsToProcess
			ELSE
				0
		END AS MustImportAllActualsIntoWarehouse,-- MustImportAllActualsIntoWarehouse: changes in snapshot should not have any affect on the budget
												 -- If a budget is locked, its snapshot has to be locked
		-----
		CASE
			WHEN
				@GBSBudgetIdsToForcefullyProcess IS NULL AND @TAPASBudgetIdsToForcefullyProcess IS NULL
			THEN
				CASE
					WHEN
						BSM.SnapshotIsLocked = 0 AND
						ISNULL(BSM.SnapshotLastSyncDate, '1900-01-01') > ISNULL(SnapshotStaging.LastSyncDate, '1900-01-01')
					THEN
						'Unlocked snapshot (LastSyncDate = ' + CONVERT(VARCHAR, ISNULL(BSM.SnapshotLastSyncDate, '1900-01-01')) + ') associated with an unlocked budget in the warehouse has been resynced (LastSyncDate in GrReportingStaging = ' + CONVERT(VARCHAR, ISNULL(SnapshotStaging.LastSyncDate, '1900-01-01')) + ')'
					WHEN
						BSM.SnapshotIsLocked <> SnapshotStaging.IsLocked
					THEN
						'Unlocked snapshot associated with an unlocked budget in the warehouse has been locked in GDM'
					ELSE
						'Not sure - something strange has happened'
				END	
		END AS ReasonForProcessing
	FROM
		#ExistingBudgetsReforecasts ExistingBudgetsReforecasts
		
		INNER JOIN #BudgetSnapshotMapping BSM ON
			ExistingBudgetsReforecasts.BudgetId = BSM.BudgetId AND
			ExistingBudgetsReforecasts.BudgetReforecastTypeName = BSM.BudgetReforecastTypeName AND
			ExistingBudgetsReforecasts.IsReforecast = BSM.IsReforecast
			
		INNER JOIN GrReportingStaging.GDM.[Snapshot] SnapshotStaging ON
			BSM.SnapshotId = SnapshotStaging.SnapshotId
	WHERE
		/*
			If we aren't trying to inject budgets for either TAPAS or GBS that need to be forcefully (re)processed.
			The check below is necessary as the code beneath might include additional budgets that aren't specified in the
				@GBSBudgetIdsToForcefullyProcess and @TAPASBudgetIdsToForcefullyProcess parameters.
		*/	
		(@GBSBudgetIdsToForcefullyProcess IS NULL AND @TAPASBudgetIdsToForcefullyProcess IS NULL) AND
		(	/*
				If the snapshot is unlocked and GDM_Support.dbo.Snapshot.LastSyncDate > GrReportingStaging.GDM.Snapshot.LastSyncDate (i.e.: has
					changed), AND the snapshot is being used by a budget that is to be imported, the snapshot must be reimported and the budgets in
					the warehouse that use it must be reprocessed.
				This is because a budget must not be reprocessed purely because the unlocked snapshot that it uses has changed. Only if the
					snapshot is being used by a budget that is set to be imported must the budgets in the warehouse that use this snapshot be
					reprocessed.
			*/
			(
				BSM.SnapshotIsLocked = 0 AND
				ISNULL(BSM.SnapshotLastSyncDate, '1900-01-01') > ISNULL(SnapshotStaging.LastSyncDate, '1900-01-01')
			)
			-- If the snapshot is unlocked in Staging but has since been locked in GDM_Support.dbo.Snapshot 
			OR	
			(
				BSM.SnapshotIsLocked <> SnapshotStaging.IsLocked
			)
		)

END

/* =============================================================================================================================================
	C: For reforecasts, determine whether reforecast actuals require processing into the warehouse
   =========================================================================================================================================== */
BEGIN

	UPDATE
		BTP
	SET
		BTP.MustImportAllActualsIntoWarehouse = 1
	FROM
		#BudgetsToProcess BTP
		
		LEFT OUTER JOIN
		(	/*
				Find all reforecasts that have previously been processed whose actuals were marked for import
					(MustImportAllActualsIntoWarehouse = 1), and were subsequently processed successfully into the warehouse
					(ReforecastActualsProcessedIntoWarehouse = 1).
				We don't want to import these budgets' actuals again (hence the LEFT OUTER JOIN and WHERE clause below)
			*/
			SELECT
				BudgetReforecastTypeName,
				BudgetId
			FROM
				GrReportingStaging.dbo.BudgetsToProcess			
			WHERE
				IsReforecast = 1 AND -- Only consider reforecasts because original budgets do not have 'Actual' components
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

END

/* =============================================================================================================================================
	D: Determine whether budget and snapshot data require importing from the source system
   =========================================================================================================================================== */
BEGIN

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
		MustImportAllActualsIntoWarehouse INT NULL,   -- Initially set to 0 because we will determine whether actuals need to be imported in D
		ReasonForProcessing VARCHAR(1024)
	)

	INSERT INTO #BudgetsToProcessPreInsert
	SELECT
		BTP.BudgetReforecastTypeName,
		BTP.BudgetId,
		BTP.BudgetExchangeRateId,
		BTP.BudgetReportGroupPeriodId,
		BTP.BudgetAllocationSetId,
		BTPBudgets.ImportBudgetFromSourceSystem,
		BTP.IsReforecast,
		BTP.SnapshotId,
		BTPSnapshot.ImportSnapshotFromSourceSystem,
		BTPBudgets.MustImportAllActualsIntoWarehouse,
		ReasonForProcessingConcatenated.ReasonForProcessing
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
				BudgetReportGroupPeriodId,	
				CAST(MAX(MustImportAllActualsIntoWarehouse) AS BIT) AS MustImportAllActualsIntoWarehouse,
				CAST(MAX(ImportBudgetFromSourceSystem) AS BIT) AS ImportBudgetFromSourceSystem
			FROM
				#BudgetsToProcess
			GROUP BY
				BudgetReforecastTypeName,
				BudgetReportGroupPeriodId

		) BTPBudgets ON
			BTP.BudgetReforecastTypeName = BTPBudgets.BudgetReforecastTypeName AND
			BTP.BudgetReportGroupPeriodId = BTPBudgets.BudgetReportGroupPeriodId

		INNER JOIN
		(
			SELECT DISTINCT
				BudgetReforecastTypeName,
				BudgetId,
				(	/*
						The code below concatenates ReasonForProcessing where there is more than one ReasonForProcessing value per BudgetId and
							BudgetReforecastTypeName combination.

						For instance:
						
							BudgetReforecastTypeName	BudgetId	ReasonForProcessing
							'GBS Budget/Reforecast'		1			Reason 1
							'GBS Budget/Reforecast'		1			Reason 2
							
							BECOMES
							
							BudgetReforecastTypeName	BudgetId	ReasonForProcessing
							'GBS Budget/Reforecast'		1			Reason 1|Reason 2						
					*/				
					STUFF
					(
						(
							SELECT
								'|' + ReasonForProcessing
							FROM
								#BudgetsToProcess BTP2
							WHERE
								BTP1.BudgetReforecastTypeName = BTP2.BudgetReforecastTypeName AND
								BTP1.BudgetId = BTP2.BudgetId
							ORDER BY
								ReasonForProcessing
							FOR XML PATH (''), TYPE, ROOT

						).value('root[1]', 'NVARCHAR(MAX)'), 1, 1, ''
					)
				) AS ReasonForProcessing
			FROM
				#BudgetsToProcess BTP1

		) ReasonForProcessingConcatenated ON
			BTP.BudgetReforecastTypeName = ReasonForProcessingConcatenated.BudgetReforecastTypeName AND
			BTP.BudgetId = ReasonForProcessingConcatenated.BudgetId

END

/* =============================================================================================================================================
	E: Insert data into GrReportingStaging.dbo.BudgetsToProcess
   =========================================================================================================================================== */
BEGIN

	DECLARE @NextBatchId INT = (ISNULL((SELECT MAX(BatchId) FROM dbo.BudgetsToProcess), 0) + 1)

	SELECT DISTINCT
		@NextBatchId AS BatchId,
		-------
		CASE
			WHEN
				/*
					If the budget is to be imported from the source system, the ImportBatchId for that import will be determine after the budget
						data has been imported by the SSIS package(s) (the final step of the GBS and TAPAS master packages updates the
						ImportBatchId field in dbo.BudgetsToProcess - the step before this finalizes the entry into dbo.Batch)
				*/
				BTP.ImportBudgetFromSourceSystem = 1
			THEN
				NULL
			ELSE
				/*
					If the budget does not need importing from the budget source system, then this implies that a budget batch that already
						exists in either GrReportingStaging.GBS... or GrReportingStaging.TapasGlobalBudgeting... will be used and reprocessed
						into the warehouse. The last budget set to be imported into GrReportingStaging will be used for reprocessing into the
						warehouse, as this is the last budget set to be processed (into the warehouse).
				*/			
				CASE
					WHEN
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
		BASYQM.BudgetQuarter,
		BTP.ReasonForProcessing
	INTO
		#BudgetsToProcessToInsert
	FROM
		#BudgetsToProcessPreInsert BTP

		LEFT OUTER JOIN #BudgetAllocationSetYearQuarterMapping BASYQM ON
			BTP.BudgetAllocationSetId = BASYQM.BudgetAllocationSetId

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		If this is a test execution, display the results with a SELECT.
		If this is not a test execution, insert the results into the GrReportingStaging.dbo.BudgetsToProcess table
	*/

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
			BudgetQuarter,
			1 AS IsCurrentBatch,
			ReasonForProcessing
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
			BudgetQuarter,
			IsCurrentBatch,
			ReasonForProcessing
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
			BudgetQuarter,
			1, -- set all records that are inserted as being part of the current batch.
			ReasonForProcessing
		FROM
			#BudgetsToProcessToInsert

	END

END

/* =============================================================================================================================================
	Clean up
   ========================================================================================================================================== */
BEGIN

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

	IF 	OBJECT_ID('tempdb..#ProcessedBudgetsNotReflectingAsProcessedInSource') IS NOT NULL	
		DROP TABLE #ProcessedBudgetsNotReflectingAsProcessedInSource

END

