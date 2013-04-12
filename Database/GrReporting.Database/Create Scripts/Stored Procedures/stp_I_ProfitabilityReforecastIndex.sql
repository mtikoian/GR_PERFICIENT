USE GrReporting
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.stp_I_ProfitabilityReforecastIndex') AND type in (N'P', N'PC'))
	DROP PROCEDURE dbo.stp_I_ProfitabilityReforecastIndex
GO

CREATE PROCEDURE dbo.stp_I_ProfitabilityReforecastIndex
AS

/*
	Indexes:
		- dbo.ProfitabilityReforecast.IX_ActivityTypeKey
		- dbo.ProfitabilityReforecast.IX_AllocationRegionKey
		- dbo.ProfitabilityReforecast.IX_CalendarKey
		- dbo.ProfitabilityReforecast.IX_Clustered
		- dbo.ProfitabilityReforecast.IX_FunctionalDepartmentKey
		- dbo.ProfitabilityReforecast.IX_OriginatingRegionKey
		- dbo.ProfitabilityReforecast.IX_ProfitabilityReforecast_SourceSystemBudget
		- dbo.ProfitabilityReforecast.IX_PropertyFundKey
		- dbo.ProfitabilityReforecast.IX_ReferenceCode
		- dbo.ProfitabilityReforecast.IX_ReforecastKey
*/


/* =============================================================================================================================================== 
	Create Indexes
  ============================================================================================================================================== */

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityReforecast') AND name = N'IX_Clustered')
BEGIN

	CREATE CLUSTERED INDEX IX_Clustered ON dbo.ProfitabilityReforecast 
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

END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityReforecast') AND name = N'IX_ActivityTypeKey')
BEGIN

	CREATE NONCLUSTERED INDEX IX_ActivityTypeKey ON dbo.ProfitabilityReforecast 
	(
		ActivityTypeKey ASC
	)
	INCLUDE (
		ProfitabilityReforecastKey,
		CalendarKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		PropertyFundKey,
		AllocationRegionKey,
		OriginatingRegionKey,
		LocalCurrencyKey,
		LocalReforecast,
		GlobalGlCategorizationHierarchyKey,
		BudgetReforecastTypeKey,
		OverheadKey,
		FeeAdjustmentKey
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityReforecast') AND name = N'IX_AllocationRegionKey')
BEGIN

	CREATE NONCLUSTERED INDEX IX_AllocationRegionKey ON dbo.ProfitabilityReforecast 
	(
		AllocationRegionKey ASC
	)
	INCLUDE (
		ProfitabilityReforecastKey,
		CalendarKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		PropertyFundKey,
		OriginatingRegionKey,
		LocalCurrencyKey,
		LocalReforecast,
		GlobalGlCategorizationHierarchyKey,
		BudgetReforecastTypeKey,
		OverheadKey,
		FeeAdjustmentKey
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityReforecast') AND name = N'IX_CalendarKey')
BEGIN

	CREATE NONCLUSTERED INDEX IX_CalendarKey ON dbo.ProfitabilityReforecast 
	(
		CalendarKey ASC
	)
	INCLUDE (
		LocalReforecast,
		ProfitabilityReforecastKey,
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

END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityReforecast') AND name = N'IX_FunctionalDepartmentKey')
BEGIN

	CREATE NONCLUSTERED INDEX IX_FunctionalDepartmentKey ON dbo.ProfitabilityReforecast 
	(
		FunctionalDepartmentKey ASC
	)
	INCLUDE (
		ProfitabilityReforecastKey,
		CalendarKey,
		ReimbursableKey,
		PropertyFundKey,
		AllocationRegionKey,
		LocalCurrencyKey,
		LocalReforecast,
		SourceKey,
		ActivityTypeKey,
		OriginatingRegionKey,
		GlobalGlCategorizationHierarchyKey,
		BudgetReforecastTypeKey,
		OverheadKey,
		FeeAdjustmentKey
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityReforecast') AND name = N'IX_OriginatingRegionKey')
BEGIN

	CREATE NONCLUSTERED INDEX IX_OriginatingRegionKey ON dbo.ProfitabilityReforecast 
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
		BudgetReforecastTypeKey,
		OverheadKey ASC,
		FeeAdjustmentKey ASC
	)
	INCLUDE ( LocalReforecast,
	ProfitabilityReforecastKey) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityReforecast') AND name = N'IX_PropertyFundKey')
BEGIN

	CREATE NONCLUSTERED INDEX IX_PropertyFundKey ON dbo.ProfitabilityReforecast 
	(
		PropertyFundKey ASC
	)
	INCLUDE (
		LocalReforecast,
		ProfitabilityReforecastKey,
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

END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityReforecast') AND name = N'IX_ReferenceCode')
BEGIN

	CREATE UNIQUE NONCLUSTERED INDEX IX_ReferenceCode ON dbo.ProfitabilityReforecast 
	(
		ReferenceCode ASC
	)
	INCLUDE ( ProfitabilityReforecastKey) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityReforecast') AND name = N'IX_ReforecastKey')
BEGIN

	CREATE INDEX IX_ReforecastKey ON GrReporting.dbo.ProfitabilityReforecast 
	(
		ReforecastKey
	) 
	INCLUDE (
		CalendarKey, 
		SourceKey, 
		FunctionalDepartmentKey,
		ReimbursableKey, 
		PropertyFundKey, 
		AllocationRegionKey, 
		OriginatingRegionKey, 
		LocalCurrencyKey, 
		LocalReforecast, 
		ReferenceCode, 
		GlobalGlCategorizationHierarchyKey,
		BudgetReforecastTypeKey, 
		OverheadKey
	)

END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityReforecast') AND name = N'IX_ProfitabilityReforecast_Budget_BudgetReforecastType')
BEGIN

	CREATE NONCLUSTERED INDEX IX_ProfitabilityReforecast_Budget_BudgetReforecastType ON dbo.ProfitabilityReforecast 
	(
		BudgetId ASC,
		BudgetReforecastTypeKey ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityReforecast') AND name = N'IX_FeeAdjustmentKey')
BEGIN

	CREATE NONCLUSTERED INDEX IX_FeeAdjustmentKey ON dbo.ProfitabilityReforecast 
	(
		FeeAdjustmentKey ASC
	)
	INCLUDE ( CalendarKey,
	ReforecastKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalReforecast,
	GlobalGlCategorizationHierarchyKey,
	OverheadKey,
	ConsolidationRegionKey) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END

GO


