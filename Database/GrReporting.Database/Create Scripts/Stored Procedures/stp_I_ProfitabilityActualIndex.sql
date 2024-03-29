USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = 
OBJECT_ID(N'[dbo].[stp_I_ProfitabilityActualIndex]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_I_ProfitabilityActualIndex]
GO

CREATE PROCEDURE [dbo].[stp_I_ProfitabilityActualIndex]
AS


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_Clustered')
BEGIN
CREATE CLUSTERED INDEX [IX_Clustered] ON [dbo].[ProfitabilityActual] 
(
	[OriginatingRegionKey] ASC,
	[CalendarKey] ASC,
	[AllocationRegionKey] ASC,
	[GlobalGlCategorizationHierarchyKey] ASC,
	[FunctionalDepartmentKey] ASC,
	[PropertyFundKey] ASC,
	[SourceKey] ASC,
	[ReimbursableKey] ASC,
	[ActivityTypeKey] ASC,
	[LocalCurrencyKey] ASC,
	[OverheadKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_ActivityTypeKey')
BEGIN
CREATE NONCLUSTERED INDEX [IX_ActivityTypeKey] ON [dbo].[ProfitabilityActual] 
(
	[ActivityTypeKey] ASC
)
INCLUDE ( [ProfitabilityActualKey],
[CalendarKey],
[SourceKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[PropertyFundKey],
[AllocationRegionKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[LocalActual],
[GlobalGlCategorizationHierarchyKey],
[OverheadKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_AllocationRegionKey')
BEGIN
CREATE NONCLUSTERED INDEX [IX_AllocationRegionKey] ON [dbo].[ProfitabilityActual] 
(
	[AllocationRegionKey] ASC
)
INCLUDE ( [ProfitabilityActualKey],
[CalendarKey],
[SourceKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[ActivityTypeKey],
[PropertyFundKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[LocalActual],
[GlobalGlCategorizationHierarchyKey],
[OverheadKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_CalendarKey')
BEGIN
CREATE NONCLUSTERED INDEX [IX_CalendarKey] ON [dbo].[ProfitabilityActual] 
(
	[CalendarKey] ASC
)
INCLUDE ( [LocalActual],
[ProfitabilityActualKey],
[PropertyFundKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[AllocationRegionKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[SourceKey],
[ActivityTypeKey],
[GlobalGlCategorizationHierarchyKey],
[OverheadKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_FunctionalDepartmentKey')
BEGIN
CREATE NONCLUSTERED INDEX [IX_FunctionalDepartmentKey] ON [dbo].[ProfitabilityActual] 
(
	[FunctionalDepartmentKey] ASC
)
INCLUDE ( [ProfitabilityActualKey],
[CalendarKey],
[ReimbursableKey],
[PropertyFundKey],
[AllocationRegionKey],
[LocalCurrencyKey],
[LocalActual],
[SourceKey],
[ActivityTypeKey],
[OriginatingRegionKey],
[GlobalGlCategorizationHierarchyKey],
[OverheadKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_OriginatingRegionKey')
BEGIN
CREATE NONCLUSTERED INDEX [IX_OriginatingRegionKey] ON [dbo].[ProfitabilityActual] 
(
	[OriginatingRegionKey] ASC
)
INCLUDE ( [LocalActual],
[CalendarKey],
[SourceKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[ActivityTypeKey],
[PropertyFundKey],
[AllocationRegionKey],
[LocalCurrencyKey],
[GlobalGlCategorizationHierarchyKey],
[OverheadKey],
[ProfitabilityActualKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_PropertyFundKey')
BEGIN
CREATE NONCLUSTERED INDEX [IX_PropertyFundKey] ON [dbo].[ProfitabilityActual] 
(
	[PropertyFundKey] ASC
)
INCLUDE ( [LocalActual],
[ProfitabilityActualKey],
[CalendarKey],
[SourceKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[ActivityTypeKey],
[AllocationRegionKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[GlobalGlCategorizationHierarchyKey],
[OverheadKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END
GO

