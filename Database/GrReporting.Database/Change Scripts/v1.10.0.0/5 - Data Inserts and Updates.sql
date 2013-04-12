USE GrReporting
GO

UPDATE dbo.SourceSystem
SET
	SourceSystemName = 'MRI'
WHERE
	SourceTableName IN ('JOURNAL', 'GHIS')
	
UPDATE dbo.SourceSystem
SET
	SourceSystemName = 'TapasGlobal'
WHERE
	SourceTableName = 'BillingUploadDetail'

IF ((SELECT IS_NULLABLE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SourceSystem' AND COLUMN_NAME = 'SourceSystemName') = 'YES')
BEGIN
ALTER TABLE dbo.SourceSystem
	ALTER COLUMN SourceSystemName VARCHAR(256) NOT NULL
	PRINT 'SoureSystemName column of SourceSystem table is now NOT NULL'
END

IF NOT EXISTS (SELECT * FROM dbo.SourceSystem WHERE SourceSystemName = 'Corporate Budgeting' AND SourceTableName = 'GlobalReportingCorporateBudget')
BEGIN
	INSERT INTO dbo.SourceSystem
	(
		SourceSystemKey,
		SourceSystemName,
		SourceTableName
	)
	VALUES
	(
		(SELECT MAX(SourceSystemKey) FROM dbo.SourceSystem) + 1,
		'Corporate Budgeting',
		'GlobalReportingCorporateBudget'
	)
	
	
	UPDATE PB
		SET SourceSystemKey = (SELECT SourceSystemKey FROM dbo.SourceSystem WHERE SourceSystemName = 'Corporate Budgeting' AND SourceTableName = 'GlobalReportingCorporateBudget')
	FROM
		dbo.ProfitabilityBudget PB
		
		INNER JOIN dbo.Calendar C ON
			PB.CalendarKey = C.CalendarKey AND
			C.CalendarYear < 2011
			
		INNER JOIN dbo.GlAccountCategory GAC ON
			PB.GlobalGlAccountCategoryKey = GAC.GlAccountCategoryKey
	WHERE
		GAC.AccountSubTypeName = 'Non-Payroll'
		
	UPDATE PR
		SET SourceSystemKey = (SELECT SourceSystemKey FROM dbo.SourceSystem WHERE SourceSystemName = 'Corporate Budgeting' AND SourceTableName = 'GlobalReportingCorporateBudget')
	FROM
		dbo.ProfitabilityReforecast PR
		
		INNER JOIN dbo.Calendar C ON
			PR.CalendarKey = C.CalendarKey AND
			C.CalendarYear < 2011
			
		INNER JOIN dbo.GlAccountCategory GAC ON
			PR.GlobalGlAccountCategoryKey = GAC.GlAccountCategoryKey
	WHERE
		GAC.AccountSubTypeName = 'Non-Payroll'
		
END

IF NOT EXISTS (SELECT * FROM dbo.SourceSystem WHERE SourceSystemName = 'GlobalReporting' AND SourceTableName = 'ProfitabilityActual')
BEGIN
	INSERT INTO dbo.SourceSystem
	(
		SourceSystemKey,
		SourceSystemName,
		SourceTableName
	)
	VALUES
	(
		(SELECT MAX(SourceSystemKey) FROM dbo.SourceSystem) + 1,
		'GlobalReporting',
		'ProfitabilityActual'
	)
	
	UPDATE PB
		SET SourceSystemKey = (SELECT SourceSystemKey FROM dbo.SourceSystem WHERE SourceSystemName = 'GlobalReporting' AND SourceTableName = 'ProfitabilityActual')
	FROM
		dbo.ProfitabilityReforecast PB
		
		INNER JOIN dbo.Calendar C ON
			PB.CalendarKey = C.CalendarKey AND
			C.CalendarYear < 2011
			
		INNER JOIN dbo.BudgetReforecastType BRT ON
			PB.BudgetReforecastTypeKey = BRT.BudgetReforecastTypeKey
	WHERE
		BRT.BudgetReforecastSubTypeName = 'Actual'
END

IF NOT EXISTS (SELECT * FROM dbo.SourceSystem WHERE SourceSystemName = 'GBS' AND SourceTableName = 'Fee')
BEGIN
	INSERT INTO dbo.SourceSystem
	(
		SourceSystemKey,
		SourceSystemName,
		SourceTableName
	)
	VALUES
	(
		(SELECT MAX(SourceSystemKey) FROM dbo.SourceSystem) + 1,
		'GBS',
		'Fee'
	)
END

IF NOT EXISTS (SELECT * FROM dbo.SourceSystem WHERE SourceSystemName = 'GBS' AND SourceTableName = 'NonPayrollExpenseBreakdown')
BEGIN
	INSERT INTO dbo.SourceSystem
	(
		SourceSystemKey,
		SourceSystemName,
		SourceTableName
	)
	VALUES
	(
		(SELECT MAX(SourceSystemKey) FROM dbo.SourceSystem) + 1,
		'GBS',
		'NonPayrollExpenseBreakdown'
	)
END

IF NOT EXISTS (SELECT * FROM dbo.SourceSystem WHERE SourceSystemName = 'GBS' AND SourceTableName = 'BudgetProfitabilityActual')
BEGIN
	INSERT INTO dbo.SourceSystem
	(
		SourceSystemKey,
		SourceSystemName,
		SourceTableName
	)
	VALUES
	(
		(SELECT MAX(SourceSystemKey) FROM dbo.SourceSystem) + 1,
		'GBS',
		'BudgetProfitabilityActual'
	)
END

IF NOT EXISTS (SELECT * FROM dbo.SourceSystem WHERE SourceSystemName = 'TapasGlobalBudgeting' AND SourceTableName = 'BudgetEmployeePayrollAllocation')
BEGIN
	INSERT INTO dbo.SourceSystem
	(
		SourceSystemKey,
		SourceSystemName,
		SourceTableName
	)
	VALUES
	(
		(SELECT MAX(SourceSystemKey) FROM dbo.SourceSystem) + 1,
		'TapasGlobalBudgeting',
		'BudgetEmployeePayrollAllocation'
	)
	
	UPDATE PB
		SET SourceSystemKey = (SELECT SourceSystemKey FROM dbo.SourceSystem WHERE SourceSystemName = 'TapasGlobalBudgeting' AND SourceTableName = 'BudgetEmployeePayrollAllocation')
	FROM
		dbo.ProfitabilityBudget PB
		
		INNER JOIN dbo.Calendar C ON
			PB.CalendarKey = C.CalendarKey AND
			C.CalendarYear < 2011
			
		INNER JOIN dbo.GlAccountCategory GAC ON
			PB.GlobalGlAccountCategoryKey = GAC.GlAccountCategoryKey
	WHERE
		GAC.AccountSubTypeName = 'Payroll' AND
		PB.ReferenceCode LIKE '%PreTax%'
		
	UPDATE PR
		SET SourceSystemKey = (SELECT SourceSystemKey FROM dbo.SourceSystem WHERE SourceSystemName = 'TapasGlobalBudgeting' AND SourceTableName = 'BudgetEmployeePayrollAllocation')
	FROM
		dbo.ProfitabilityReforecast PR
		
		INNER JOIN dbo.Calendar C ON
			PR.CalendarKey = C.CalendarKey AND
			C.CalendarYear < 2011
			
		INNER JOIN dbo.GlAccountCategory GAC ON
			PR.GlobalGlAccountCategoryKey = GAC.GlAccountCategoryKey
	WHERE
		GAC.AccountSubTypeName = 'Payroll' AND
		PR.ReferenceCode LIKE '%PreTax%'
END

IF NOT EXISTS (SELECT * FROM dbo.SourceSystem WHERE SourceSystemName = 'TapasGlobalBudgeting' AND SourceTableName = 'BudgetEmployeePayrollAllocationDetail')
BEGIN
	INSERT INTO dbo.SourceSystem
	(
		SourceSystemKey,
		SourceSystemName,
		SourceTableName
	)
	VALUES
	(
		(SELECT MAX(SourceSystemKey) FROM dbo.SourceSystem) + 1,
		'TapasGlobalBudgeting',
		'BudgetEmployeePayrollAllocationDetail'
	)
	
	UPDATE PB
		SET SourceSystemKey = (SELECT SourceSystemKey FROM dbo.SourceSystem WHERE SourceSystemName = 'TapasGlobalBudgeting' AND SourceTableName = 'BudgetEmployeePayrollAllocationDetail')
	FROM
		dbo.ProfitabilityBudget PB
		
		INNER JOIN dbo.Calendar C ON
			PB.CalendarKey = C.CalendarKey AND
			C.CalendarYear < 2011
			
		INNER JOIN dbo.GlAccountCategory GAC ON
			PB.GlobalGlAccountCategoryKey = GAC.GlAccountCategoryKey
	WHERE
		GAC.AccountSubTypeName = 'Payroll' AND
		GAC.MinorCategoryName <> 'Base Salary' AND
		PB.ReferenceCode NOT LIKE '%PreTax%'

	UPDATE PR
		SET SourceSystemKey = (SELECT SourceSystemKey FROM dbo.SourceSystem WHERE SourceSystemName = 'TapasGlobalBudgeting' AND SourceTableName = 'BudgetEmployeePayrollAllocationDetail')
	FROM
		dbo.ProfitabilityReforecast PR
		
		INNER JOIN dbo.Calendar C ON
			PR.CalendarKey = C.CalendarKey AND
			C.CalendarYear < 2011
			
		INNER JOIN dbo.GlAccountCategory GAC ON
			PR.GlobalGlAccountCategoryKey = GAC.GlAccountCategoryKey
	WHERE
		GAC.AccountSubTypeName = 'Payroll' AND
		GAC.MinorCategoryName <> 'Base Salary'	AND
		PR.ReferenceCode NOT LIKE '%PreTax%'	
END

IF NOT EXISTS (SELECT * FROM dbo.SourceSystem WHERE SourceSystemName = 'TapasGlobalBudgeting' AND SourceTableName = 'BudgetOverheadAllocation')
BEGIN
	INSERT INTO dbo.SourceSystem
	(
		SourceSystemKey,
		SourceSystemName,
		SourceTableName
	)
	VALUES
	(
		(SELECT MAX(SourceSystemKey) FROM dbo.SourceSystem) + 1,
		'TapasGlobalBudgeting',
		'BudgetOverheadAllocation'
	)
	
	UPDATE PB
		SET SourceSystemKey = (SELECT SourceSystemKey FROM dbo.SourceSystem WHERE SourceSystemName = 'TapasGlobalBudgeting' AND SourceTableName = 'BudgetOverheadAllocation')
	FROM
		dbo.ProfitabilityBudget PB
		
		INNER JOIN dbo.Calendar C ON
			PB.CalendarKey = C.CalendarKey AND
			C.CalendarYear < 2011
			
		INNER JOIN dbo.GlAccountCategory GAC ON
			PB.GlobalGlAccountCategoryKey = GAC.GlAccountCategoryKey
	WHERE
		GAC.AccountSubTypeName = 'Overhead' 
		
	UPDATE PR
		SET SourceSystemKey = (SELECT SourceSystemKey FROM dbo.SourceSystem WHERE SourceSystemName = 'TapasGlobalBudgeting' AND SourceTableName = 'BudgetOverheadAllocation')
	FROM
		dbo.ProfitabilityReforecast PR
		
		INNER JOIN dbo.Calendar C ON
			PR.CalendarKey = C.CalendarKey AND
			C.CalendarYear < 2011
			
		INNER JOIN dbo.GlAccountCategory GAC ON
			PR.GlobalGlAccountCategoryKey = GAC.GlAccountCategoryKey
	WHERE
		GAC.AccountSubTypeName = 'Overhead' 	
END

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_SourceSystem]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
BEGIN
	ALTER TABLE dbo.ProfitabilityBudget
		ADD CONSTRAINT [FK_ProfitabilityBudget_SourceSystem] FOREIGN KEY (SourceSystemKey)
			REFERENCES dbo.SourceSystem(SourceSystemKey)
			
	PRINT 'FK_ProfitabilityBudget_SourceSystem foreign key constraint created'
END
GO
	
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityReforecast_SourceSystem]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
BEGIN
	ALTER TABLE dbo.ProfitabilityReforecast
		ADD CONSTRAINT [FK_ProfitabilityReforecast_SourceSystem] FOREIGN KEY (SourceSystemKey)
			REFERENCES dbo.SourceSystem(SourceSystemKey)
			
	PRINT 'FK_ProfitabilityReforecast_SourceSystem foreign key constraint created'
END
GO
	
/* -- Update Overhead references from UNKNOWN to N/A ------------------------------------------------------------------------------------------ */

-- Drop the foreign keys and indexes to the Overhead dimension to speed up the update

IF NOT EXISTS(SELECT * FROM dbo.Overhead WHERE OverheadCode = 'N/A') AND NOT EXISTS(SELECT * FROM dbo.Overhead WHERE OverheadKey = 0)
BEGIN
	INSERT INTO dbo.Overhead
	(
		OverheadKey,
		OverheadCode,
		OverheadName
	)
	VALUES
	(
		0,
		'N/A',
		'Not Applicable'
	)
	
	PRINT 'N/A Overhead Record inserted'

END
ELSE
BEGIN
	PRINT 'Cannot insert N/A Overhead record as it already exists'
END

DECLARE @UNKNOWNOverheadKey INT = (SELECT TOP 1 OverheadKey FROM GrReporting.dbo.Overhead WHERE OverheadCode = 'UNKNOWN')
DECLARE @NAOverheadKey INT = (SELECT TOP 1 OverheadKey FROM GrReporting.dbo.Overhead WHERE OverheadCode = 'N/A')

IF EXISTS (SELECT TOP 1 * FROM GrReporting.dbo.ProfitabilityActual WHERE OverheadKey = @UNKNOWNOverheadKey) AND
	EXISTS (SELECT TOP 1 * FROM GrReporting.dbo.ProfitabilityActualArchive WHERE OverheadKey = @UNKNOWNOverheadKey) AND
	EXISTS (SELECT TOP 1 * FROM GrReporting.dbo.ProfitabilityBudget WHERE OverheadKey = @UNKNOWNOverheadKey) AND
	EXISTS (SELECT TOP 1 * FROM GrReporting.dbo.ProfitabilityReforecast WHERE OverheadKey = @UNKNOWNOverheadKey)
BEGIN

	IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_Overhead]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
		ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_Overhead]
	
	IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_Overhead]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
		ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_Overhead]
	

	IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_Overhead]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
		ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_Overhead]
	

	IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityReforecast_Overhead]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
		ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_Overhead]
	

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_ReforecastKey')
		DROP INDEX [IX_ReforecastKey] ON [dbo].[ProfitabilityReforecast] WITH ( ONLINE = OFF )

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_ActivityTypeKey')
		DROP INDEX [IX_ActivityTypeKey] ON [dbo].[ProfitabilityReforecast] 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_FeeAdjustmentKey')
		DROP INDEX [IX_FeeAdjustmentKey] ON [dbo].[ProfitabilityReforecast] WITH ( ONLINE = OFF )

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_AllocationRegionKey')
		DROP INDEX [IX_AllocationRegionKey] ON [dbo].[ProfitabilityReforecast] 

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_CalendarKey')
		DROP INDEX [IX_CalendarKey] ON [dbo].[ProfitabilityReforecast] 

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_FunctionalDepartmentKey')
		DROP INDEX [IX_FunctionalDepartmentKey] ON [dbo].[ProfitabilityReforecast] 

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_GlAccountKey')
		DROP INDEX [IX_GlAccountKey] ON [dbo].[ProfitabilityReforecast] 

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_OriginatingRegionKey')
		DROP INDEX [IX_OriginatingRegionKey] ON [dbo].[ProfitabilityReforecast] 

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_ProfitabilityReforecast_SourceSystem')
		DROP INDEX [IX_ProfitabilityReforecast_SourceSystem] ON [dbo].[ProfitabilityReforecast] 

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_PropertyFundKey')
		DROP INDEX [IX_PropertyFundKey] ON [dbo].[ProfitabilityReforecast] 

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_ReforecatKey')
		DROP INDEX [IX_ReforecatKey] ON [dbo].[ProfitabilityReforecast] 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_ProfitabilityReforecast_Budget_BudgetReforecastType')
		DROP INDEX  [IX_ProfitabilityReforecast_Budget_BudgetReforecastType] ON [dbo].[ProfitabilityReforecast] WITH ( ONLINE = OFF )

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_Clustered')
		DROP INDEX [IX_Clustered] ON [dbo].[ProfitabilityReforecast] 
		
		IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_ActivityTypeKey')
		DROP INDEX [IX_ActivityTypeKey] ON [dbo].[ProfitabilityBudget] 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_AllocationRegionKey')
		DROP INDEX [IX_AllocationRegionKey] ON [dbo].[ProfitabilityBudget] 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_CalendarKey')
		DROP INDEX [IX_CalendarKey] ON [dbo].[ProfitabilityBudget] 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_FunctionalDepartmentKey')
		DROP INDEX [IX_FunctionalDepartmentKey] ON [dbo].[ProfitabilityBudget] 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_GlAccountKey')
		DROP INDEX [IX_GlAccountKey] ON [dbo].[ProfitabilityBudget] 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_OriginatingRegionKey')
		DROP INDEX [IX_OriginatingRegionKey] ON [dbo].[ProfitabilityBudget] 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_ProfitabilityBudget_SourceSystemBudget')
		DROP INDEX [IX_ProfitabilityBudget_SourceSystemBudget] ON [dbo].[ProfitabilityBudget] 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_PropertyFundKey')
		DROP INDEX [IX_PropertyFundKey] ON [dbo].[ProfitabilityBudget] 

	-- This is required for the Merge functions in the import stored procedures.
	--IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_ReferenceCode')
		--DROP INDEX [IX_ReferenceCode] ON [dbo].[ProfitabilityBudget] 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_GlobalGlAccountCategoryKey')
		DROP INDEX [IX_GlobalGlAccountCategoryKey] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_ProfitabilityBudget_SourceSystemBudget')
		DROP INDEX [IX_ProfitabilityBudget_SourceSystemBudget] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )


	-------------------------------------------
	--Used by loading stp and cannot be dropped
	-------------------------------------------

	--IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_BudgetIdSourceSystemId')
	--DROP INDEX [IX_BudgetIdSourceSystemId] ON [dbo].[ProfitabilityBudget] 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_Clustered')
		DROP INDEX [IX_Clustered] ON [dbo].[ProfitabilityBudget] 
-----



IF (@UNKNOWNOverheadKey IS NOT NULL AND @NAOverheadKey IS NOT NULL)
BEGIN

	IF EXISTS (SELECT TOP 1 * FROM GrReporting.dbo.ProfitabilityActual WHERE OverheadKey = @UNKNOWNOverheadKey)
	BEGIN	
		UPDATE
			dbo.ProfitabilityActual
		SET
			OverheadKey = @NAOverheadKey
		WHERE
			OverheadKey = @UNKNOWNOverheadKey

		PRINT ('dbo.ProfitabilityActual Overhead keys updated.' + STR(@@rowcount))
	END
	ELSE
	BEGIN
		PRINT ('dbo.ProfitabilityActual Overhead keys already updated.')
	END

	IF EXISTS (SELECT TOP 1 * FROM GrReporting.dbo.ProfitabilityActualArchive WHERE OverheadKey = @UNKNOWNOverheadKey)
	BEGIN
		UPDATE
			dbo.ProfitabilityActualArchive
		SET
			OverheadKey = @NAOverheadKey
		WHERE
			OverheadKey = @UNKNOWNOverheadKey

		PRINT ('dbo.ProfitabilityActualArchive Overhead keys updated.' + STR(@@rowcount))
	END
	ELSE
	BEGIN
		PRINT ('dbo.ProfitabilityActualArchive Overhead keys already updated.')
	END

	IF EXISTS (SELECT TOP 1 * FROM GrReporting.dbo.ProfitabilityBudget WHERE OverheadKey = @UNKNOWNOverheadKey)
	BEGIN
		UPDATE
			dbo.ProfitabilityBudget
		SET
			OverheadKey = @NAOverheadKey
		WHERE
			OverheadKey = @UNKNOWNOverheadKey

		PRINT ('dbo.ProfitabilityBudget Overhead keys updated.' + STR(@@rowcount))
	END
	ELSE
	BEGIN
		PRINT ('dbo.ProfitabilityBudget Overhead keys already updated.')
	END

	IF EXISTS (SELECT TOP 1 * FROM GrReporting.dbo.ProfitabilityReforecast WHERE OverheadKey = @UNKNOWNOverheadKey)
	BEGIN
		UPDATE
			dbo.ProfitabilityReforecast
		SET
			OverheadKey = @NAOverheadKey
		WHERE
			OverheadKey = @UNKNOWNOverheadKey

		PRINT ('dbo.ProfitabilityReforecast Overhead keys updated.' + STR(@@rowcount))
	END
	ELSE
	BEGIN
		PRINT ('dbo.ProfitabilityReforecast Overhead keys already updated.')
	END
END
ELSE
BEGIN
	PRINT ('Cannot find Overhead keys for UNKNOWN and/or N/A: this is not looking good. Cowardly aborting ...')
END

-- Recreate the foreign keys 


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_Overhead]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_Overhead]


USE [GrReporting]


ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_Overhead] FOREIGN KEY([OverheadKey])
REFERENCES [dbo].[Overhead] ([OverheadKey])


ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_Overhead]


USE [GrReporting]

ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_Overhead] FOREIGN KEY([OverheadKey])
REFERENCES [dbo].[Overhead] ([OverheadKey])


ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_Overhead]


USE [GrReporting]


ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_Overhead] FOREIGN KEY([OverheadKey])
REFERENCES [dbo].[Overhead] ([OverheadKey])


ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_Overhead]


-- Recreate the indexes that were dropped

EXEC stp_D_ProfitabilityActualIndex
EXEC stp_D_ProfitabilityBudgetIndex
EXEC stp_D_ProfitabilityReforecastIndex

END

/* -------------------------------------------------------------------------------------------------------------------------------------------- */

/* =============================================================================================================================================
	Insert unknown record into the GLCategorizationHierarchy dimension
   =========================================================================================================================================== */
   
IF NOT EXISTS(SELECT * FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLCategorizationHierarchyKey = -1)
BEGIN
SET IDENTITY_INSERT GrReporting.dbo.GLCategorizationHierarchy ON

DECLARE @MinimumStartDate DATETIME = '1753-01-01 00:00:00.000'
DECLARE @MaximumEndDate DATETIME = '9999-12-31 00:00:00.000'

INSERT INTO GrReporting.dbo.GLCategorizationHierarchy(
	GLCategorizationHierarchyKey,
	GLCategorizationHierarchyCode,
	GLCategorizationTypeName,
	GLCategorizationName,
	GLFinancialCategoryName,
	GLMajorCategoryName,
	GLMinorCategoryName,
	GLAccountName,
	GLAccountCode,
	InflowOutflow,
	SnapshotId,
	StartDate,
	EndDate
)
SELECT
	-1,
	'-1:-1:-1:-1:-1:-1',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	0,
	@MinimumStartDate,
	@MaximumEndDate

INSERT INTO GrReporting.dbo.GLCategorizationHierarchy(
	GLCategorizationHierarchyKey,
	GLCategorizationHierarchyCode,
	GLCategorizationTypeName,
	GLCategorizationName,
	GLFinancialCategoryName,
	GLMajorCategoryName,
	GLMinorCategoryName,
	GLAccountName,
	GLAccountCode,
	InflowOutflow,
	SnapshotId,
	StartDate,
	EndDate
)
SELECT
	-2,
	'3:241:-1:-1:-1:-1',
	'Local Operating Statement',
	'US Property',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	0,
	@MinimumStartDate,
	@MaximumEndDate

INSERT INTO GrReporting.dbo.GLCategorizationHierarchy(
	GLCategorizationHierarchyKey,
	GLCategorizationHierarchyCode,
	GLCategorizationTypeName,
	GLCategorizationName,
	GLFinancialCategoryName,
	GLMajorCategoryName,
	GLMinorCategoryName,
	GLAccountName,
	GLAccountCode,
	InflowOutflow,
	SnapshotId,
	StartDate,
	EndDate
)
SELECT
	-3,
	'3:242:-1:-1:-1:-1',
	'Local Operating Statement',
	'US Fund',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	0,
	@MinimumStartDate,
	@MaximumEndDate		

INSERT INTO GrReporting.dbo.GLCategorizationHierarchy(
	GLCategorizationHierarchyKey,
	GLCategorizationHierarchyCode,
	GLCategorizationTypeName,
	GLCategorizationName,
	GLFinancialCategoryName,
	GLMajorCategoryName,
	GLMinorCategoryName,
	GLAccountName,
	GLAccountCode,
	InflowOutflow,
	SnapshotId,
	StartDate,
	EndDate
)
SELECT
	-4,
	'3:243:-1:-1:-1:-1',
	'Local Operating Statement',
	'EU Property',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	0,
	@MinimumStartDate,
	@MaximumEndDate		

INSERT INTO GrReporting.dbo.GLCategorizationHierarchy(
	GLCategorizationHierarchyKey,
	GLCategorizationHierarchyCode,
	GLCategorizationTypeName,
	GLCategorizationName,
	GLFinancialCategoryName,
	GLMajorCategoryName,
	GLMinorCategoryName,
	GLAccountName,
	GLAccountCode,
	InflowOutflow,
	SnapshotId,
	StartDate,
	EndDate
)
SELECT
	-5,
	'3:244:-1:-1:-1:-1',
	'Local Operating Statement',
	'EU Fund',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	0,
	@MinimumStartDate,
	@MaximumEndDate	
	
INSERT INTO GrReporting.dbo.GLCategorizationHierarchy(
	GLCategorizationHierarchyKey,
	GLCategorizationHierarchyCode,
	GLCategorizationTypeName,
	GLCategorizationName,
	GLFinancialCategoryName,
	GLMajorCategoryName,
	GLMinorCategoryName,
	GLAccountName,
	GLAccountCode,
	InflowOutflow,
	SnapshotId,
	StartDate,
	EndDate
)
SELECT
	-6,
	'3:247:-1:-1:-1:-1',
	'Local Operating Statement',
	'US Development',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	0,
	@MinimumStartDate,
	@MaximumEndDate		

INSERT INTO GrReporting.dbo.GLCategorizationHierarchy(
	GLCategorizationHierarchyKey,
	GLCategorizationHierarchyCode,
	GLCategorizationTypeName,
	GLCategorizationName,
	GLFinancialCategoryName,
	GLMajorCategoryName,
	GLMinorCategoryName,
	GLAccountName,
	GLAccountCode,
	InflowOutflow,
	SnapshotId,
	StartDate,
	EndDate
)
SELECT
	-7,
	'1:233:-1:-1:-1:-1',
	'Global',
	'Global',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	'UNKNOWN',
	0,
	@MinimumStartDate,
	@MaximumEndDate	
			
SET IDENTITY_INSERT GrReporting.dbo.GLCategorizationHierarchy OFF

END