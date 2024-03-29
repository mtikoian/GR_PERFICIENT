USE GrReporting
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.stp_I_ProfitabilityBudgetIndex') AND type in (N'P', N'PC'))
	DROP PROCEDURE dbo.stp_I_ProfitabilityBudgetIndex

GO

CREATE PROCEDURE dbo.stp_I_ProfitabilityBudgetIndex
AS

/*
	Indexes:
		- dbo.ProfitabilityBudget.IX_ActivityTypeKey
		- dbo.ProfitabilityBudget.IX_AllocationRegionKey
		- dbo.ProfitabilityBudget.IX_CalendarKey
		- dbo.ProfitabilityBudget.IX_Clustered
		- dbo.ProfitabilityBudget.IX_FunctionalDepartmentKey
		- dbo.ProfitabilityBudget.IX_GlAccountKey
		- dbo.ProfitabilityBudget.IX_OriginatingRegionKey
		- dbo.ProfitabilityBudget.IX_ProfitabilityBudget_SourceSystemBudget				don't recreate
		- dbo.ProfitabilityBudget.IX_PropertyFundKey
		- dbo.ProfitabilityBudget.IX_ReferenceCode
		- dbo.ProfitabilityBudget.IX_ProfitabilityBudget_Budget_BudgetReforecastType
		- dbo.ProfitabilityBudget.IX_BudgetIdSourceSystemId								don't recreate
		- dbo.ProfitabilityBudget.IX_ProfitabilityBudget_SourceSystemBudget				don't recreate

*/

/* ===============================================================================================================================================
	Create Indexes
   =============================================================================================================================================*/

DECLARE @StartTime DATETIME = GETDATE()

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityBudget') AND name = N'IX_Clustered')
BEGIN

	CREATE CLUSTERED INDEX IX_Clustered ON dbo.ProfitabilityBudget 
	(
		OriginatingRegionKey ASC,
		CalendarKey ASC,
		AllocationRegionKey ASC,
		GlobalGlCategorizationHierarchyKey ASC,
		FunctionalDepartmentKey ASC,
		PropertyFundKey ASC,
		SourceKey ASC,
		ReimbursableKey ASC,
		ActivityTypeKey ASC,
		LocalCurrencyKey ASC,
		OverheadKey ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

	PRINT ('Index dbo.ProfitabilityBudget.IX_Clustered created in ' + CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END

----------------------------------------------------------------------------------------------------------------------------------------

SET @StartTime = GETDATE()

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityBudget') AND name = N'IX_ActivityTypeKey')
BEGIN

	CREATE NONCLUSTERED INDEX IX_ActivityTypeKey ON dbo.ProfitabilityBudget 
	(
		ActivityTypeKey ASC
	)
	INCLUDE (
		ProfitabilityBudgetKey,
		CalendarKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		PropertyFundKey,
		AllocationRegionKey,
		OriginatingRegionKey,
		LocalCurrencyKey,
		LocalBudget,
		GlobalGlCategorizationHierarchyKey,
		BudgetReforecastTypeKey,
		OverheadKey,
		FeeAdjustmentKey
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

	PRINT ('Index dbo.ProfitabilityBudget.IX_ActivityTypeKey created in ' + CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END

----------------------------------------------------------------------------------------------------------------------------------------

SET @StartTime = GETDATE()

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityBudget') AND name = N'IX_AllocationRegionKey')
BEGIN

	CREATE NONCLUSTERED INDEX IX_AllocationRegionKey ON dbo.ProfitabilityBudget 
	(
		AllocationRegionKey ASC
	)
	INCLUDE (
		ProfitabilityBudgetKey,
		CalendarKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		PropertyFundKey,
		OriginatingRegionKey,
		LocalCurrencyKey,
		LocalBudget,
		GlobalGlCategorizationHierarchyKey,
		BudgetReforecastTypeKey,
		OverheadKey,
		FeeAdjustmentKey
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

	PRINT ('Index dbo.ProfitabilityBudget.IX_AllocationRegionKey created in ' + CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END


----------------------------------------------------------------------------------------------------------------------------------------

SET @StartTime = GETDATE()

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityBudget') AND name = N'IX_CalendarKey')
BEGIN

	CREATE NONCLUSTERED INDEX IX_CalendarKey ON dbo.ProfitabilityBudget 
	(
		CalendarKey ASC
	)
	INCLUDE (
		LocalBudget,
		ProfitabilityBudgetKey,
		PropertyFundKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		AllocationRegionKey,
		OriginatingRegionKey,
		LocalCurrencyKey,
		SourceKey,
		ActivityTypeKey,
		GlobalGlCategorizationHierarchyKey,
		BudgetReforecastTypeKey,
		OverheadKey,
		FeeAdjustmentKey
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

	PRINT ('Index dbo.ProfitabilityBudget.IX_CalendarKey created in ' + CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END

----------------------------------------------------------------------------------------------------------------------------------------

SET @StartTime = GETDATE()

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityBudget') AND name = N'IX_FunctionalDepartmentKey')
BEGIN

	CREATE NONCLUSTERED INDEX IX_FunctionalDepartmentKey ON dbo.ProfitabilityBudget 
	(
		FunctionalDepartmentKey ASC
	)
	INCLUDE (
		ProfitabilityBudgetKey,
		CalendarKey,
		ReimbursableKey,
		PropertyFundKey,
		AllocationRegionKey,
		LocalCurrencyKey,
		LocalBudget,
		SourceKey,
		ActivityTypeKey,
		OriginatingRegionKey,
		GlobalGlCategorizationHierarchyKey,
		BudgetReforecastTypeKey,
		OverheadKey,
		FeeAdjustmentKey
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

	PRINT ('Index dbo.ProfitabilityBudget.IX_FunctionalDepartmentKey created in ' + CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END

----------------------------------------------------------------------------------------------------------------------------------------

SET @StartTime = GETDATE()

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityBudget') AND name = N'IX_OriginatingRegionKey')
BEGIN

	CREATE NONCLUSTERED INDEX IX_OriginatingRegionKey ON dbo.ProfitabilityBudget 
	(
		OriginatingRegionKey ASC,
		CalendarKey ASC,
		SourceKey ASC,
		FunctionalDepartmentKey ASC,
		ReimbursableKey ASC,
		ActivityTypeKey ASC,
		PropertyFundKey ASC,
		AllocationRegionKey ASC,
		LocalCurrencyKey ASC,
		GlobalGlCategorizationHierarchyKey ASC,
		BudgetReforecastTypeKey ASC,
		OverheadKey ASC,
		FeeAdjustmentKey ASC
	)
	INCLUDE ( LocalBudget,
	ProfitabilityBudgetKey) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

	PRINT ('Index dbo.ProfitabilityBudget.IX_OriginatingRegionKey created in ' + CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END

----------------------------------------------------------------------------------------------------------------------------------------

SET @StartTime = GETDATE()

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityBudget') AND name = N'IX_ProfitabilityBudget_Budget_BudgetReforecastType')
BEGIN

	CREATE NONCLUSTERED INDEX IX_ProfitabilityBudget_Budget_BudgetReforecastType ON dbo.ProfitabilityBudget 
	(
		BudgetId ASC,
		BudgetReforecastTypeKey ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

	PRINT ('Index dbo.ProfitabilityBudget.IX_ProfitabilityBudget_Budget_BudgetReforecastType created in ' + CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END

----------------------------------------------------------------------------------------------------------------------------------------

SET @StartTime = GETDATE()

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityBudget') AND name = N'IX_PropertyFundKey')
BEGIN

	CREATE NONCLUSTERED INDEX IX_PropertyFundKey ON dbo.ProfitabilityBudget 
	(
		PropertyFundKey ASC
	)
	INCLUDE (
		LocalBudget,
		ProfitabilityBudgetKey,
		CalendarKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		AllocationRegionKey,
		OriginatingRegionKey,
		LocalCurrencyKey,
		GlobalGlCategorizationHierarchyKey,
		BudgetReforecastTypeKey,
		OverheadKey,
		FeeAdjustmentKey
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

	PRINT ('Index dbo.ProfitabilityBudget.IX_PropertyFundKey created in ' + CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END

----------------------------------------------------------------------------------------------------------------------------------------

SET @StartTime = GETDATE()

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityBudget') AND name = N'IX_ReferenceCode')
BEGIN

	CREATE UNIQUE NONCLUSTERED INDEX IX_ReferenceCode ON dbo.ProfitabilityBudget 
	(
		ReferenceCode ASC
	)
	INCLUDE ( ProfitabilityBudgetKey) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	 
	PRINT ('Index dbo.ProfitabilityBudget.IX_ReferenceCode created in ' + CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END

GO


