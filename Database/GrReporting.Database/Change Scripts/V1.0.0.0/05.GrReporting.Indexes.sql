USE [GrReporting]
GO

 
 IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ExchangeRate]') AND name = N'IX_Clustered')
DROP INDEX [IX_Clustered] ON [dbo].[ExchangeRate] WITH ( ONLINE = OFF )
GO

CREATE CLUSTERED INDEX [IX_Clustered] ON [dbo].[ExchangeRate] 
(
	[SourceCurrencyKey] ASC,
	[CalendarKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ExchangeRate]') AND name = N'IX_CalendarKey')
DROP INDEX [IX_CalendarKey] ON [dbo].[ExchangeRate] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_CalendarKey] ON [dbo].[ExchangeRate] 
(
	[CalendarKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ExchangeRate]') AND name = N'IX_SourceCurrencyKey')
DROP INDEX [IX_SourceCurrencyKey] ON [dbo].[ExchangeRate] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_SourceCurrencyKey] ON [dbo].[ExchangeRate] 
(
	[SourceCurrencyKey] ASC
)
INCLUDE ( [DestinationCurrencyKey],
[Rate]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ExchangeRate]') AND name = N'IX_SourceToDestination')
DROP INDEX [IX_SourceToDestination] ON [dbo].[ExchangeRate] WITH ( ONLINE = OFF )
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_SourceToDestination] ON [dbo].[ExchangeRate] 
(
	[SourceCurrencyKey] ASC,
	[DestinationCurrencyKey] ASC,
	[CalendarKey] ASC
)
INCLUDE ( [Rate]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualGlAccountCategoryBridge]') AND name = N'IX_GlAccountCategoryKey')
DROP INDEX [IX_GlAccountCategoryKey] ON [dbo].[ProfitabilityActualGlAccountCategoryBridge] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_GlAccountCategoryKey] ON [dbo].[ProfitabilityActualGlAccountCategoryBridge] 
(
	[GlAccountCategoryKey] ASC
)
INCLUDE ( [ProfitabilityActualKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudgetGlAccountCategoryBridge]') AND name = N'IX_GlAccountCategoryKey')
DROP INDEX [IX_GlAccountCategoryKey] ON [dbo].[ProfitabilityBudgetGlAccountCategoryBridge] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_GlAccountCategoryKey] ON [dbo].[ProfitabilityBudgetGlAccountCategoryBridge] 
(
	[GlAccountCategoryKey] ASC
)
INCLUDE ( [ProfitabilityBudgetKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO




IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_Clustered')
BEGIN
DROP INDEX [IX_Clustered] ON [dbo].[ProfitabilityActual] WITH ( ONLINE = OFF )
END
GO
CREATE CLUSTERED INDEX [IX_Clustered] ON [dbo].[ProfitabilityActual] 
(
	[CalendarKey] ASC,
	[LocalCurrencyKey] ASC,
	[ProfitabilityActualKey] ASC,
	[GlAccountKey] ASC,
	[AllocationRegionKey] ASC,
	[OriginatingRegionKey] ASC,
	[FunctionalDepartmentKey] ASC,
	[PropertyFundKey] ASC,
	[SourceKey] ASC,
	[ActivityTypeKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_ActivityTypeKey')
BEGIN
DROP INDEX [IX_ActivityTypeKey] ON [dbo].[ProfitabilityActual] WITH ( ONLINE = OFF )
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_ActivityTypeKey')
CREATE NONCLUSTERED INDEX [IX_ActivityTypeKey] ON [dbo].[ProfitabilityActual] 
(
	[ActivityTypeKey] ASC
)
INCLUDE ( [ProfitabilityActualKey],
[CalendarKey],
[GlAccountKey],
[SourceKey],
[FunctionalDepartmentKey],
[PropertyFundKey],
[AllocationRegionKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[LocalActual]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_AllocationRegionKey')
BEGIN
DROP INDEX [IX_AllocationRegionKey] ON [dbo].[ProfitabilityActual] WITH ( ONLINE = OFF )
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_AllocationRegionKey')
CREATE NONCLUSTERED INDEX [IX_AllocationRegionKey] ON [dbo].[ProfitabilityActual] 
(
	[AllocationRegionKey] ASC
)
INCLUDE ( [ProfitabilityActualKey],
[CalendarKey],
[GlAccountKey],
[SourceKey],
[FunctionalDepartmentKey],
[ActivityTypeKey],
[PropertyFundKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[LocalActual]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_CalendarKey')
BEGIN
DROP INDEX [IX_CalendarKey] ON [dbo].[ProfitabilityActual] WITH ( ONLINE = OFF )
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_CalendarKey')
CREATE NONCLUSTERED INDEX [IX_CalendarKey] ON [dbo].[ProfitabilityActual] 
(
	[CalendarKey] ASC
)
INCLUDE ( [LocalActual],
[ProfitabilityActualKey],
[PropertyFundKey],
[FunctionalDepartmentKey],
[AllocationRegionKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[GlAccountKey],
[SourceKey],
[ActivityTypeKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_FunctionalDepartmentKey')
BEGIN
DROP INDEX [IX_FunctionalDepartmentKey] ON [dbo].[ProfitabilityActual] WITH ( ONLINE = OFF )
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_FunctionalDepartmentKey')
CREATE NONCLUSTERED INDEX [IX_FunctionalDepartmentKey] ON [dbo].[ProfitabilityActual] 
(
	[FunctionalDepartmentKey] ASC
)
INCLUDE ( [ProfitabilityActualKey],
[CalendarKey],
[PropertyFundKey],
[AllocationRegionKey],
[LocalCurrencyKey],
[LocalActual],
[GlAccountKey],
[SourceKey],
[ActivityTypeKey],
[OriginatingRegionKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_GlAccountKey')
BEGIN
DROP INDEX [IX_GlAccountKey] ON [dbo].[ProfitabilityActual] WITH ( ONLINE = OFF )
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_GlAccountKey')
CREATE NONCLUSTERED INDEX [IX_GlAccountKey] ON [dbo].[ProfitabilityActual] 
(
	[GlAccountKey] ASC
)
INCLUDE ( [ProfitabilityActualKey],
[CalendarKey],
[SourceKey],
[FunctionalDepartmentKey],
[ActivityTypeKey],
[PropertyFundKey],
[AllocationRegionKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[LocalActual]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_OriginatingRegionKey')
BEGIN
DROP INDEX [IX_OriginatingRegionKey] ON [dbo].[ProfitabilityActual] WITH ( ONLINE = OFF )
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_OriginatingRegionKey')
CREATE NONCLUSTERED INDEX [IX_OriginatingRegionKey] ON [dbo].[ProfitabilityActual] 
(
	[OriginatingRegionKey] ASC
)
INCLUDE ( [ProfitabilityActualKey],
[CalendarKey],
[FunctionalDepartmentKey],
[PropertyFundKey],
[AllocationRegionKey],
[LocalCurrencyKey],
[LocalActual],
[GlAccountKey],
[SourceKey],
[ActivityTypeKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_PropertyFundKey')
BEGIN
DROP INDEX [IX_PropertyFundKey] ON [dbo].[ProfitabilityActual] WITH ( ONLINE = OFF )
END
GO


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_PropertyFundKey')
CREATE NONCLUSTERED INDEX [IX_PropertyFundKey] ON [dbo].[ProfitabilityActual] 
(
	[PropertyFundKey] ASC
)
INCLUDE ( [LocalActual],
[ProfitabilityActualKey],
[CalendarKey],
[FunctionalDepartmentKey],
[AllocationRegionKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[GlAccountKey],
[SourceKey],
[ActivityTypeKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_ReferenceCode')
BEGIN
DROP INDEX [IX_ReferenceCode] ON [dbo].[ProfitabilityActual] WITH ( ONLINE = OFF )
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_ReferenceCode')
CREATE UNIQUE NONCLUSTERED INDEX [IX_ReferenceCode] ON [dbo].[ProfitabilityActual] 
(
	[ReferenceCode] ASC
)
INCLUDE ( [ProfitabilityActualKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_Clustered')
BEGIN
DROP INDEX [IX_Clustered] ON [dbo].[ProfitabilityActual] WITH ( ONLINE = OFF )
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_Clustered')
CREATE CLUSTERED INDEX [IX_Clustered] ON [dbo].[ProfitabilityBudget] 
(
	[CalendarKey] ASC,
	[LocalCurrencyKey] ASC,
	[ProfitabilityBudgetKey] ASC,
	[GlAccountKey] ASC,
	[AllocationRegionKey] ASC,
	[OriginatingRegionKey] ASC,
	[FunctionalDepartmentKey] ASC,
	[PropertyFundKey] ASC,
	[SourceKey] ASC,
	[ReimbursableKey] ASC,
	[ActivityTypeKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_ActivityTypeKey')
BEGIN
DROP INDEX [IX_ActivityTypeKey] ON [dbo].[ProfitabilityActual] WITH ( ONLINE = OFF )
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_ActivityTypeKey')
CREATE NONCLUSTERED INDEX [IX_ActivityTypeKey] ON [dbo].[ProfitabilityBudget] 
(
	[ActivityTypeKey] ASC
)
INCLUDE ( [ProfitabilityBudgetKey],
[CalendarKey],
[ReforecastKey],
[GlAccountKey],
[SourceKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[PropertyFundKey],
[AllocationRegionKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[LocalBudget]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_AllocationRegionKey')
BEGIN
DROP INDEX [IX_AllocationRegionKey] ON [dbo].[ProfitabilityActual] WITH ( ONLINE = OFF )
END
GO


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_AllocationRegionKey')
CREATE NONCLUSTERED INDEX [IX_AllocationRegionKey] ON [dbo].[ProfitabilityBudget] 
(
	[AllocationRegionKey] ASC
)
INCLUDE ( [ProfitabilityBudgetKey],
[CalendarKey],
[ReforecastKey],
[GlAccountKey],
[SourceKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[ActivityTypeKey],
[PropertyFundKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[LocalBudget]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_CalendarKey')
BEGIN
DROP INDEX [IX_CalendarKey] ON [dbo].[ProfitabilityActual] WITH ( ONLINE = OFF )
END
GO


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_CalendarKey')
CREATE NONCLUSTERED INDEX [IX_CalendarKey] ON [dbo].[ProfitabilityBudget] 
(
	[CalendarKey] ASC
)
INCLUDE ( [LocalBudget],
[ProfitabilityBudgetKey],
[PropertyFundKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[AllocationRegionKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[ReforecastKey],
[GlAccountKey],
[SourceKey],
[ActivityTypeKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_FunctionalDepartmentKey')
BEGIN
DROP INDEX [IX_FunctionalDepartmentKey] ON [dbo].[ProfitabilityActual] WITH ( ONLINE = OFF )
END
GO


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_FunctionalDepartmentKey')
CREATE NONCLUSTERED INDEX [IX_FunctionalDepartmentKey] ON [dbo].[ProfitabilityBudget] 
(
	[FunctionalDepartmentKey] ASC
)
INCLUDE ( [ProfitabilityBudgetKey],
[CalendarKey],
[ReimbursableKey],
[PropertyFundKey],
[AllocationRegionKey],
[LocalCurrencyKey],
[LocalBudget],
[ReforecastKey],
[GlAccountKey],
[SourceKey],
[ActivityTypeKey],
[OriginatingRegionKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_GlAccountKey')
BEGIN
DROP INDEX [IX_GlAccountKey] ON [dbo].[ProfitabilityActual] WITH ( ONLINE = OFF )
END
GO


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_GlAccountKey')
CREATE NONCLUSTERED INDEX [IX_GlAccountKey] ON [dbo].[ProfitabilityBudget] 
(
	[GlAccountKey] ASC
)
INCLUDE ( [ProfitabilityBudgetKey],
[CalendarKey],
[ReforecastKey],
[SourceKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[ActivityTypeKey],
[PropertyFundKey],
[AllocationRegionKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[LocalBudget]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_OriginatingRegionKey')
BEGIN
DROP INDEX [IX_OriginatingRegionKey] ON [dbo].[ProfitabilityActual] WITH ( ONLINE = OFF )
END
GO


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_OriginatingRegionKey')
CREATE NONCLUSTERED INDEX [IX_OriginatingRegionKey] ON [dbo].[ProfitabilityBudget] 
(
	[OriginatingRegionKey] ASC
)
INCLUDE ( [ProfitabilityBudgetKey],
[CalendarKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[PropertyFundKey],
[AllocationRegionKey],
[LocalCurrencyKey],
[LocalBudget],
[ReforecastKey],
[GlAccountKey],
[SourceKey],
[ActivityTypeKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_PropertyFundKey')
BEGIN
DROP INDEX [IX_PropertyFundKey] ON [dbo].[ProfitabilityActual] WITH ( ONLINE = OFF )
END
GO


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_PropertyFundKey')
CREATE NONCLUSTERED INDEX [IX_PropertyFundKey] ON [dbo].[ProfitabilityBudget] 
(
	[PropertyFundKey] ASC
)
INCLUDE ( [LocalBudget],
[ProfitabilityBudgetKey],
[CalendarKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[AllocationRegionKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[ReforecastKey],
[GlAccountKey],
[SourceKey],
[ActivityTypeKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_ReferenceCode')
BEGIN
DROP INDEX [IX_ReferenceCode] ON [dbo].[ProfitabilityActual] WITH ( ONLINE = OFF )
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_ReferenceCode')
CREATE UNIQUE NONCLUSTERED INDEX [IX_ReferenceCode] ON [dbo].[ProfitabilityBudget] 
(
	[ReferenceCode] ASC
)
INCLUDE ( [ProfitabilityBudgetKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
