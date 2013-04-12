/*

[dbo].[stp_I_ProfitabilityReforecastIndex]
[dbo].[stp_I_ProfitabilityBudgetIndex]
[dbo].[stp_D_ProfitabilityBudgetIndex]
[dbo].[stp_S_ValidNonPayrollRegionAndFunctionalDepartment]
[dbo].[stp_R_ProfitabilityDetailV2]
[dbo].[stp_R_ExpenseCzarTotalComparisonDetail]
[dbo].[stp_R_ExpenseCzarTotalComparison]
[dbo].[stp_R_ExpenseCzar]
[dbo].[stp_R_BudgetOwner]
[dbo].[stp_R_BudgetOriginator]
[dbo].[stp_R_BudgetJobCodeDetail]
[dbo].[stp_R_ProfitabilityV2]

*/

USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = 
OBJECT_ID(N'[dbo].[stp_I_ProfitabilityReforecastIndex]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_I_ProfitabilityReforecastIndex]
GO

CREATE PROCEDURE [dbo].[stp_I_ProfitabilityReforecastIndex]
AS

/****** Object:  Index [IX_ActivityTypeKey]    Script Date: 10/27/2010 10:51:26 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_ActivityTypeKey')
DROP INDEX [IX_ActivityTypeKey] ON [dbo].[ProfitabilityReforecast] WITH ( ONLINE = OFF )


/****** Object:  Index [IX_AllocationRegionKey]    Script Date: 10/27/2010 10:51:26 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_AllocationRegionKey')
DROP INDEX [IX_AllocationRegionKey] ON [dbo].[ProfitabilityReforecast] WITH ( ONLINE = OFF )


/****** Object:  Index [IX_CalendarKey]    Script Date: 10/27/2010 10:51:26 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_CalendarKey')
DROP INDEX [IX_CalendarKey] ON [dbo].[ProfitabilityReforecast] WITH ( ONLINE = OFF )


/****** Object:  Index [IX_Clustered]    Script Date: 10/27/2010 10:51:26 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_Clustered')
DROP INDEX [IX_Clustered] ON [dbo].[ProfitabilityReforecast] WITH ( ONLINE = OFF )


/****** Object:  Index [IX_FunctionalDepartmentKey]    Script Date: 10/27/2010 10:51:26 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_FunctionalDepartmentKey')
DROP INDEX [IX_FunctionalDepartmentKey] ON [dbo].[ProfitabilityReforecast] WITH ( ONLINE = OFF )


/****** Object:  Index [IX_GlAccountKey]    Script Date: 10/27/2010 10:51:26 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_GlAccountKey')
DROP INDEX [IX_GlAccountKey] ON [dbo].[ProfitabilityReforecast] WITH ( ONLINE = OFF )


/****** Object:  Index [IX_OriginatingRegionKey]    Script Date: 10/27/2010 10:51:26 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_OriginatingRegionKey')
DROP INDEX [IX_OriginatingRegionKey] ON [dbo].[ProfitabilityReforecast] WITH ( ONLINE = OFF )


/****** Object:  Index [IX_ProfitabilityReforecast_SourceSystemBudget]    Script Date: 10/27/2010 10:51:26 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_ProfitabilityReforecast_SourceSystemBudget')
DROP INDEX [IX_ProfitabilityReforecast_SourceSystemBudget] ON [dbo].[ProfitabilityReforecast] WITH ( ONLINE = OFF )


/****** Object:  Index [IX_PropertyFundKey]    Script Date: 10/27/2010 10:51:26 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_PropertyFundKey')
DROP INDEX [IX_PropertyFundKey] ON [dbo].[ProfitabilityReforecast] WITH ( ONLINE = OFF )


/****** Object:  Index [IX_ReferenceCode]    Script Date: 10/27/2010 10:51:26 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_ReferenceCode')
DROP INDEX [IX_ReferenceCode] ON [dbo].[ProfitabilityReforecast] WITH ( ONLINE = OFF )


/****** Object:  Index [IX_ReforecastKey]    Script Date: 10/27/2010 10:51:26 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_ReforecastKey')
DROP INDEX [IX_ReforecastKey] ON [dbo].[ProfitabilityReforecast] WITH ( ONLINE = OFF )


/****** Object:  Index [IX_ActivityTypeKey]    Script Date: 10/27/2010 10:51:26 ******/
CREATE NONCLUSTERED INDEX [IX_ActivityTypeKey] ON [dbo].[ProfitabilityReforecast] 
(
	[ActivityTypeKey] ASC
)
INCLUDE ( [ProfitabilityReforecastKey],
[CalendarKey],
[GlAccountKey],
[SourceKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[PropertyFundKey],
[AllocationRegionKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[LocalReforecast],
[GlobalGlAccountCategoryKey],
[SourceSystemId],
[OverheadKey],
[FeeAdjustmentKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


/****** Object:  Index [IX_AllocationRegionKey]    Script Date: 10/27/2010 10:51:26 ******/
CREATE NONCLUSTERED INDEX [IX_AllocationRegionKey] ON [dbo].[ProfitabilityReforecast] 
(
	[AllocationRegionKey] ASC
)
INCLUDE ( [ProfitabilityReforecastKey],
[CalendarKey],
[GlAccountKey],
[SourceKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[ActivityTypeKey],
[PropertyFundKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[LocalReforecast],
[GlobalGlAccountCategoryKey],
[SourceSystemId],
[OverheadKey],
[FeeAdjustmentKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


/****** Object:  Index [IX_CalendarKey]    Script Date: 10/27/2010 10:51:26 ******/
CREATE NONCLUSTERED INDEX [IX_CalendarKey] ON [dbo].[ProfitabilityReforecast] 
(
	[CalendarKey] ASC
)
INCLUDE ( [LocalReforecast],
[ProfitabilityReforecastKey],
[PropertyFundKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[AllocationRegionKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[GlAccountKey],
[SourceKey],
[ActivityTypeKey],
[GlobalGlAccountCategoryKey],
[SourceSystemId],
[OverheadKey],
[FeeAdjustmentKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


/****** Object:  Index [IX_Clustered]    Script Date: 10/27/2010 10:51:26 ******/
CREATE CLUSTERED INDEX [IX_Clustered] ON [dbo].[ProfitabilityReforecast] 
(
	[OriginatingRegionKey] ASC,
	[CalendarKey] ASC,
	[AllocationRegionKey] ASC,
	[GlobalGlAccountCategoryKey] ASC,
	[FunctionalDepartmentKey] ASC,
	[PropertyFundKey] ASC,
	[GlAccountKey] ASC,
	[SourceKey] ASC,
	[ReimbursableKey] ASC,
	[ActivityTypeKey] ASC,
	[LocalCurrencyKey] ASC,
	[OverheadKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


/****** Object:  Index [IX_FunctionalDepartmentKey]    Script Date: 10/27/2010 10:51:26 ******/
CREATE NONCLUSTERED INDEX [IX_FunctionalDepartmentKey] ON [dbo].[ProfitabilityReforecast] 
(
	[FunctionalDepartmentKey] ASC
)
INCLUDE ( [ProfitabilityReforecastKey],
[CalendarKey],
[ReimbursableKey],
[PropertyFundKey],
[AllocationRegionKey],
[LocalCurrencyKey],
[LocalReforecast],
[GlAccountKey],
[SourceKey],
[ActivityTypeKey],
[OriginatingRegionKey],
[GlobalGlAccountCategoryKey],
[SourceSystemId],
[OverheadKey],
[FeeAdjustmentKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


/****** Object:  Index [IX_GlAccountKey]    Script Date: 10/27/2010 10:51:26 ******/
CREATE NONCLUSTERED INDEX [IX_GlAccountKey] ON [dbo].[ProfitabilityReforecast] 
(
	[GlAccountKey] ASC
)
INCLUDE ( [ProfitabilityReforecastKey],
[CalendarKey],
[SourceKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[ActivityTypeKey],
[PropertyFundKey],
[AllocationRegionKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[LocalReforecast],
[GlobalGlAccountCategoryKey],
[SourceSystemId],
[OverheadKey],
[FeeAdjustmentKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


/****** Object:  Index [IX_OriginatingRegionKey]    Script Date: 10/27/2010 10:51:26 ******/
CREATE NONCLUSTERED INDEX [IX_OriginatingRegionKey] ON [dbo].[ProfitabilityReforecast] 
(
	[OriginatingRegionKey] ASC,
	[CalendarKey] ASC,
	[GlAccountKey] ASC,
	[SourceKey] ASC,
	[FunctionalDepartmentKey] ASC,
	[ReimbursableKey] ASC,
	[ActivityTypeKey] ASC,
	[PropertyFundKey] ASC,
	[AllocationRegionKey] ASC,
	[LocalCurrencyKey] ASC,
	[GlobalGlAccountCategoryKey] ASC,
	[SourceSystemId] ASC,
	[OverheadKey] ASC,
	[FeeAdjustmentKey] ASC
)
INCLUDE ( [LocalReforecast],
[ProfitabilityReforecastKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


/****** Object:  Index [IX_ProfitabilityReforecast_SourceSystemBudget]    Script Date: 10/27/2010 10:51:26 ******/
CREATE NONCLUSTERED INDEX [IX_ProfitabilityReforecast_SourceSystemBudget] ON [dbo].[ProfitabilityReforecast] 
(
	[BudgetId] ASC,
	[SourceSystemId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


/****** Object:  Index [IX_PropertyFundKey]    Script Date: 10/27/2010 10:51:26 ******/
CREATE NONCLUSTERED INDEX [IX_PropertyFundKey] ON [dbo].[ProfitabilityReforecast] 
(
	[PropertyFundKey] ASC
)
INCLUDE ( [LocalReforecast],
[ProfitabilityReforecastKey],
[CalendarKey],
[GlAccountKey],
[SourceKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[ActivityTypeKey],
[AllocationRegionKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[GlobalGlAccountCategoryKey],
[SourceSystemId],
[OverheadKey],
[FeeAdjustmentKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


/****** Object:  Index [IX_ReferenceCode]    Script Date: 10/27/2010 10:51:26 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ReferenceCode] ON [dbo].[ProfitabilityReforecast] 
(
	[ReferenceCode] ASC
)
INCLUDE ( [ProfitabilityReforecastKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


/****** Object:  Index [IX_ReforecastKey]    Script Date: 10/27/2010 10:51:26 ******/
CREATE INDEX [IX_ReforecastKey] 
ON [GrReporting].[dbo].[ProfitabilityReforecast] 
([ReforecastKey]) 
INCLUDE ([CalendarKey], 
[GlAccountKey], 
[SourceKey], 
[FunctionalDepartmentKey],
[ReimbursableKey], 
[PropertyFundKey], 
[AllocationRegionKey], 
[OriginatingRegionKey], 
[LocalCurrencyKey], 
[LocalReforecast], 
[ReferenceCode], 
[GlobalGlAccountCategoryKey], 
[OverheadKey])
 
GO

USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = 
OBJECT_ID(N'[dbo].[stp_I_ProfitabilityBudgetIndex]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_I_ProfitabilityBudgetIndex]
GO

CREATE PROCEDURE [dbo].[stp_I_ProfitabilityBudgetIndex]
AS

/****** Object:  Index [IX_ActivityTypeKey]    Script Date: 10/27/2010 10:49:22 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_ActivityTypeKey')
DROP INDEX [IX_ActivityTypeKey] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )


/****** Object:  Index [IX_AllocationRegionKey]    Script Date: 10/27/2010 10:49:22 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_AllocationRegionKey')
DROP INDEX [IX_AllocationRegionKey] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )


/****** Object:  Index [IX_CalendarKey]    Script Date: 10/27/2010 10:49:22 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_CalendarKey')
DROP INDEX [IX_CalendarKey] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )


/****** Object:  Index [IX_Clustered]    Script Date: 10/27/2010 10:49:22 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_Clustered')
DROP INDEX [IX_Clustered] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )


/****** Object:  Index [IX_FunctionalDepartmentKey]    Script Date: 10/27/2010 10:49:22 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_FunctionalDepartmentKey')
DROP INDEX [IX_FunctionalDepartmentKey] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )


/****** Object:  Index [IX_GlAccountKey]    Script Date: 10/27/2010 10:49:22 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_GlAccountKey')
DROP INDEX [IX_GlAccountKey] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )


/****** Object:  Index [IX_OriginatingRegionKey]    Script Date: 10/27/2010 10:49:22 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_OriginatingRegionKey')
DROP INDEX [IX_OriginatingRegionKey] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )


/****** Object:  Index [IX_ProfitabilityBudget_SourceSystemBudget]    Script Date: 10/27/2010 10:49:22 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_ProfitabilityBudget_SourceSystemBudget')
DROP INDEX [IX_ProfitabilityBudget_SourceSystemBudget] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )


/****** Object:  Index [IX_PropertyFundKey]    Script Date: 10/27/2010 10:49:22 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_PropertyFundKey')
DROP INDEX [IX_PropertyFundKey] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )


/****** Object:  Index [IX_ReferenceCode]    Script Date: 10/27/2010 10:49:22 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_ReferenceCode')
DROP INDEX [IX_ReferenceCode] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )


IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_GlobalGlAccountCategoryKey')
DROP INDEX [IX_GlobalGlAccountCategoryKey] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )


/****** Object:  Index [IX_Clustered]    Script Date: 10/27/2010 10:49:23 ******/
CREATE CLUSTERED INDEX [IX_Clustered] ON [dbo].[ProfitabilityBudget] 
(
	[OriginatingRegionKey] ASC,
	[CalendarKey] ASC,
	[AllocationRegionKey] ASC,
	[GlobalGlAccountCategoryKey] ASC,
	[FunctionalDepartmentKey] ASC,
	[PropertyFundKey] ASC,
	[GlAccountKey] ASC,
	[SourceKey] ASC,
	[ReimbursableKey] ASC,
	[ActivityTypeKey] ASC,
	[LocalCurrencyKey] ASC,
	[OverheadKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


/****** Object:  Index [IX_ActivityTypeKey]    Script Date: 10/27/2010 10:49:23 ******/
CREATE NONCLUSTERED INDEX [IX_ActivityTypeKey] ON [dbo].[ProfitabilityBudget] 
(
	[ActivityTypeKey] ASC
)
INCLUDE ( [ProfitabilityBudgetKey],
[CalendarKey],
[GlAccountKey],
[SourceKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[PropertyFundKey],
[AllocationRegionKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[LocalBudget],
[GlobalGlAccountCategoryKey],
[SourceSystemId],
[OverheadKey],
[FeeAdjustmentKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


/****** Object:  Index [IX_AllocationRegionKey]    Script Date: 10/27/2010 10:49:23 ******/
CREATE NONCLUSTERED INDEX [IX_AllocationRegionKey] ON [dbo].[ProfitabilityBudget] 
(
	[AllocationRegionKey] ASC
)
INCLUDE ( [ProfitabilityBudgetKey],
[CalendarKey],
[GlAccountKey],
[SourceKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[ActivityTypeKey],
[PropertyFundKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[LocalBudget],
[GlobalGlAccountCategoryKey],
[SourceSystemId],
[OverheadKey],
[FeeAdjustmentKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


/****** Object:  Index [IX_CalendarKey]    Script Date: 10/27/2010 10:49:23 ******/
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
[GlAccountKey],
[SourceKey],
[ActivityTypeKey],
[GlobalGlAccountCategoryKey],
[SourceSystemId],
[OverheadKey],
[FeeAdjustmentKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


/****** Object:  Index [IX_FunctionalDepartmentKey]    Script Date: 10/27/2010 10:49:23 ******/
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
[GlAccountKey],
[SourceKey],
[ActivityTypeKey],
[OriginatingRegionKey],
[GlobalGlAccountCategoryKey],
[SourceSystemId],
[OverheadKey],
[FeeAdjustmentKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


/****** Object:  Index [IX_GlAccountKey]    Script Date: 10/27/2010 10:49:23 ******/
CREATE NONCLUSTERED INDEX [IX_GlAccountKey] ON [dbo].[ProfitabilityBudget] 
(
	[GlAccountKey] ASC
)
INCLUDE ( [ProfitabilityBudgetKey],
[CalendarKey],
[SourceKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[ActivityTypeKey],
[PropertyFundKey],
[AllocationRegionKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[LocalBudget],
[GlobalGlAccountCategoryKey],
[SourceSystemId],
[OverheadKey],
[FeeAdjustmentKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


/****** Object:  Index [IX_OriginatingRegionKey]    Script Date: 10/27/2010 10:49:23 ******/
CREATE NONCLUSTERED INDEX [IX_OriginatingRegionKey] ON [dbo].[ProfitabilityBudget] 
(
	[OriginatingRegionKey] ASC,
	[CalendarKey] ASC,
	[GlAccountKey] ASC,
	[SourceKey] ASC,
	[FunctionalDepartmentKey] ASC,
	[ReimbursableKey] ASC,
	[ActivityTypeKey] ASC,
	[PropertyFundKey] ASC,
	[AllocationRegionKey] ASC,
	[LocalCurrencyKey] ASC,
	[GlobalGlAccountCategoryKey] ASC,
	[SourceSystemId] ASC,
	[OverheadKey] ASC,
	[FeeAdjustmentKey] ASC
)
INCLUDE ( [LocalBudget],
[ProfitabilityBudgetKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


/****** Object:  Index [IX_ProfitabilityBudget_SourceSystemBudget]    Script Date: 10/27/2010 10:49:23 ******/
CREATE NONCLUSTERED INDEX [IX_ProfitabilityBudget_SourceSystemBudget] ON [dbo].[ProfitabilityBudget] 
(
	[BudgetId] ASC,
	[SourceSystemId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


/****** Object:  Index [IX_PropertyFundKey]    Script Date: 10/27/2010 10:49:23 ******/
CREATE NONCLUSTERED INDEX [IX_PropertyFundKey] ON [dbo].[ProfitabilityBudget] 
(
	[PropertyFundKey] ASC
)
INCLUDE ( [LocalBudget],
[ProfitabilityBudgetKey],
[CalendarKey],
[GlAccountKey],
[SourceKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[ActivityTypeKey],
[AllocationRegionKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[GlobalGlAccountCategoryKey],
[SourceSystemId],
[OverheadKey],
[FeeAdjustmentKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


/****** Object:  Index [IX_ReferenceCode]    Script Date: 10/27/2010 10:49:23 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ReferenceCode] ON [dbo].[ProfitabilityBudget] 
(
	[ReferenceCode] ASC
)
INCLUDE ( [ProfitabilityBudgetKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


 
CREATE INDEX [IX_GlobalGlAccountCategoryKey] 
ON [GrReporting].[dbo].[ProfitabilityBudget] (
[GlobalGlAccountCategoryKey]) 
INCLUDE ([CalendarKey], 
[GlAccountKey], 
[SourceKey], 
[ReimbursableKey], 
[ActivityTypeKey], 
[LocalCurrencyKey], 
[LocalBudget], 
[OverheadKey])

GO

USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = 
OBJECT_ID(N'[dbo].[stp_D_ProfitabilityBudgetIndex]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_D_ProfitabilityBudgetIndex]
GO

CREATE PROCEDURE [dbo].[stp_D_ProfitabilityBudgetIndex]
AS

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

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_ReferenceCode')
DROP INDEX [IX_ReferenceCode] ON [dbo].[ProfitabilityBudget] 

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_GlobalGlAccountCategoryKey')
DROP INDEX [IX_GlobalGlAccountCategoryKey] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )

-------------------------------------------
--Used by loading stp and cannot be dropped
-------------------------------------------

--IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_BudgetIdSourceSystemId')
--DROP INDEX [IX_BudgetIdSourceSystemId] ON [dbo].[ProfitabilityBudget] 

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_Clustered')
DROP INDEX [IX_Clustered] ON [dbo].[ProfitabilityBudget] 

--3min

GO

USE GrReporting
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_S_ValidNonPayrollRegionAndFunctionalDepartment]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[stp_S_ValidNonPayrollRegionAndFunctionalDepartment]
GO

CREATE PROCEDURE [dbo].[stp_S_ValidNonPayrollRegionAndFunctionalDepartment]
@BudgetYear int,
@BudgetQuater	Varchar(2),
@DataPriorToDate DateTime
AS


CREATE TABLE #FunctionalDepartment(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	Code VARCHAR(20) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	GlobalCode CHAR(3) NULL
)

INSERT INTO #FunctionalDepartment(
	ImportKey,
	ImportBatchId,
	ImportDate,
	FunctionalDepartmentId,
	Name,
	Code,
	IsActive,
	InsertedDate,
	UpdatedDate,
	GlobalCode
)
SELECT 
	fd.* 
FROM 
	GrReportingStaging.HR.FunctionalDepartment fd
	INNER JOIN GrReportingStaging.HR.FunctionalDepartmentActive(@DataPriorToDate) fdA ON
		fd.ImportKey = fdA.ImportKey

PRINT 'Completed inserting records into #FunctionalDepartment:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_FunctionalDepartmentId ON #FunctionalDepartment (FunctionalDepartmentId)
PRINT 'Completed creating indexes on #FunctionalDepartment'
PRINT CONVERT(Varchar(27), getdate(), 121)


Select 
		DISTINCT
		Fd.Name FunctionalDepartmentName,
		GrOr.Name OriginatingSubRegionName
From 
		Server3.GBS.dbo.NonPayrollExpenseBreakdown ExB
			INNER JOIN #FunctionalDepartment Fd ON Fd.FunctionalDepartmentId = ExB.FunctionalDepartmentId
			
			 INNER JOIN (
					SELECT 
						Gr.* 
					FROM 
						GrReportingStaging.Gdm.GlobalRegion Gr
						INNER JOIN GrReportingStaging.Gdm.GlobalRegionActive(@DataPriorToDate) GrA ON
							Gr.ImportKey = GrA.ImportKey
					) GrOr ON GrOr.GlobalRegionId = ExB.OriginatingSubRegionGlobalRegionId
					
Where BudgetID in (										
					Select BudgetId
					From 
							Server3.GBS.dbo.Budget 
					Where BudgetReportGroupPeriodID IN (
						Select 
								BudgetReportGroupPeriodID 
						From 
								Server3.GDM.dbo.BudgetReportGroupPeriod 
						Where [YEAR] = @BudgetYear and Period = (Select 
																		MIN(t1.ReforecastEffectivePeriod)
																 From 
																		GrReporting.dbo.Reforecast t1
																Where ReforecastEffectiveYear = @BudgetYear
																And	ReforecastQuarterName = @BudgetQuater
																)
														)
				)
GO


-- Report Stored Procedures

USE [GrReporting]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_BudgetJobCodeDetail]    Script Date: 01/25/2011 14:18:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetJobCodeDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_BudgetJobCodeDetail]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginator]    Script Date: 01/25/2011 14:18:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOriginator]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_BudgetOriginator]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOwner]    Script Date: 01/25/2011 14:18:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOwner]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_BudgetOwner]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzar]    Script Date: 01/25/2011 14:18:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzar]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ExpenseCzar]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzarTotalComparison]    Script Date: 01/25/2011 14:18:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzarTotalComparison]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ExpenseCzarTotalComparison]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzarTotalComparisonDetail]    Script Date: 01/25/2011 14:18:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzarTotalComparisonDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ExpenseCzarTotalComparisonDetail]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ProfitabilityDetailV2]    Script Date: 01/25/2011 14:18:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ProfitabilityDetailV2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ProfitabilityDetailV2]
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ProfitabilityDetailV2]    Script Date: 01/25/2011 14:18:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ProfitabilityDetailV2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE [dbo].[stp_R_ProfitabilityDetailV2]
	@ReportExpensePeriod INT = NULL,
	@DestinationCurrency VARCHAR(3) = NULL,
	@TranslationTypeName VARCHAR(50) = NULL,

	@FunctionalDepartmentList TEXT = NULL,
	@ActivityTypeList TEXT = NULL,
	@EntityList TEXT = NULL,
	@MajorAccountCategoryList TEXT = NULL,
	@MinorAccountCategoryList TEXT = NULL,
	@AllocationRegionList TEXT = NULL,
	@AllocationSubRegionList TEXT = NULL,
	@OriginatingRegionList TEXT = NULL,
	@OriginatingSubRegionList TEXT = NULL,
	@DisplayOverheadBy Varchar(12),
	
	--Customized Filter Logic Specific to this Report
	@IncludeFeeAdjustments TinyInt = NULL,
	@OverheadOriginatingSubRegionList TEXT = NULL 
	
	
AS

IF ISNULL(@DisplayOverheadBy,'''') NOT IN (''Allocated'',''Unallocated'')
	BEGIN
	RAISERROR (''@DisplayOverheadBy have invalid value (Must be one of:Allocated,Unallocated)'',18,1)
	RETURN
	END
	
DECLARE

	@_ReportExpensePeriod INT = @ReportExpensePeriod,
	@_DestinationCurrency VARCHAR(3) = @DestinationCurrency,
	@_TranslationTypeName VARCHAR(50) = @TranslationTypeName,
	@_FunctionalDepartmentList VARCHAR(8000) = @FunctionalDepartmentList,
	@_ActivityTypeList VARCHAR(8000) = @ActivityTypeList,
	@_EntityList VARCHAR(8000) = @EntityList,
	@_MajorAccountCategoryList VARCHAR(8000) = @MajorAccountCategoryList,
	@_MinorAccountCategoryList VARCHAR(8000) = @MinorAccountCategoryList,
	@_AllocationRegionList VARCHAR(8000) = @AllocationRegionList,
	@_AllocationSubRegionList VARCHAR(8000) = @AllocationSubRegionList,
	@_OriginatingRegionList VARCHAR(8000) = @OriginatingRegionList,
	@_OriginatingSubRegionList VARCHAR(8000) = @OriginatingSubRegionList,
	@_OverheadOriginatingSubRegionList VARCHAR(8000) = @OverheadOriginatingSubRegionList	
			
--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Variable defaults		*/
--------------------------------------------------------------------------

IF @ReportExpensePeriod IS NULL
	SET @ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + REPLACE(STR(MONTH(GETDATE()),2 ),'' '',''0'')AS INT)

IF @DestinationCurrency IS NULL
	SET @DestinationCurrency = ''USD''

IF 	@TranslationTypeName IS NULL
	SET @TranslationTypeName = ''Global''

DECLARE @CalendarYear AS INT
SET @CalendarYear = CAST(SUBSTRING(CAST(@ReportExpensePeriod AS VARCHAR(10)), 1, 4) AS INT)				

DECLARE @ReforecastQuaterName VARCHAR(10)
SET @ReforecastQuaterName = (SELECT TOP 1
								ReforecastQuarterName 
							 FROM
								dbo.Reforecast 
							 WHERE
								ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
								ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
							 ORDER BY ReforecastEffectivePeriod DESC)

DECLARE @ReforecastEffectivePeriodQ1 INT
SET @ReforecastEffectivePeriodQ1 = (SELECT TOP 1 ReforecastEffectivePeriod 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										  ReforecastQuarterName = ''Q1''
									ORDER BY ReforecastEffectivePeriod)								

DECLARE @ReforecastEffectivePeriodQ2 INT
SET @ReforecastEffectivePeriodQ2 = (SELECT TOP 1 ReforecastEffectivePeriod 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										  ReforecastQuarterName = ''Q2''
									ORDER BY ReforecastEffectivePeriod)								

DECLARE @ReforecastEffectivePeriodQ3 INT
SET @ReforecastEffectivePeriodQ3 = (SELECT TOP 1 ReforecastEffectivePeriod 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										  ReforecastQuarterName = ''Q3''
									ORDER BY ReforecastEffectivePeriod)								

--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Tables		*/
--------------------------------------------------------------------------
	
	CREATE TABLE	#EntityFilterTable	(PropertyFundKey Int NOT NULL)
	CREATE TABLE	#FunctionalDepartmentFilterTable	(FunctionalDepartmentKey Int NOT NULL)
	CREATE TABLE	#ActivityTypeFilterTable(ActivityTypeKey Int NOT NULL)
	CREATE TABLE	#AllocationRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#AllocationSubRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#MajorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#MinorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#OriginatingRegionFilterTable	(OriginatingRegionKey Int NOT NULL)
	CREATE TABLE	#OriginatingSubRegionFilterTable	(OriginatingRegionKey Int NOT NULL)	
	CREATE TABLE	#OverheadOriginatingSubRegionFilterTable	(OriginatingRegionKey Int NOT NULL)	
		
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable	(PropertyFundKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable(ActivityTypeKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MajorAccountCategoryFilterTable(GlAccountCategoryKey)	
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MinorAccountCategoryFilterTable(GlAccountCategoryKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingRegionFilterTable	(OriginatingRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable	(OriginatingRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OverheadOriginatingSubRegionFilterTable	(OriginatingRegionKey)
	
IF (@EntityList IS NOT NULL)
	BEGIN
	Insert Into #EntityFilterTable
	Select pf.PropertyFundKey
	From dbo.Split(@_EntityList) t1
		INNER JOIN PropertyFund pf ON pf.PropertyFundName = t1.item
	
	END
	
IF (@FunctionalDepartmentList IS NOT NULL)
	BEGIN
	Insert Into #FunctionalDepartmentFilterTable
	Select fd.FunctionalDepartmentKey 
	From dbo.Split(@_FunctionalDepartmentList) t1
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentName = t1.item
	END

IF 	(@ActivityTypeList IS NOT NULL)
	BEGIN
    INSERT INTO #ActivityTypeFilterTable
    SELECT at.ActivityTypeKey 
    FROM dbo.Split(@_ActivityTypeList) t1
		INNER JOIN ActivityType at ON at.ActivityTypeName = t1.item
	END
	
IF (@AllocationRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationRegionFilterTable
	Select ar.AllocationRegionKey 
	From dbo.Split(@_AllocationRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.RegionName = t1.item
	END

IF (@AllocationSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationSubRegionFilterTable
	Select ar.AllocationRegionKey
	From dbo.Split(@_AllocationSubRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.SubRegionName = t1.item
	END

IF (@MajorAccountCategoryList IS NOT NULL)
	BEGIN
	Insert Into #MajorAccountCategoryFilterTable
	Select gl.GlAccountCategoryKey 
	From dbo.Split(@_MajorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MajorCategoryName = t1.item
	END
	
IF 	(@MinorAccountCategoryList IS NOT NULL)
	BEGIN
    INSERT INTO #MinorAccountCategoryFilterTable
    SELECT gl.GlAccountCategoryKey 
    FROM dbo.Split(@MinorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MinorCategoryName = t1.item
	END	

IF (@OriginatingRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingRegionFilterTable
	Select orr.OriginatingRegionKey 
	From dbo.Split(@_OriginatingRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.RegionName = t1.item
	END

IF (@OriginatingSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingSubRegionFilterTable
	Select orr.OriginatingRegionKey  
	From dbo.Split(@OriginatingSubRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.SubRegionName = t1.item
	END
	
IF (@OverheadOriginatingSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #OverheadOriginatingSubRegionFilterTable
	Select orr.OriginatingRegionKey  
	From dbo.Split(@OverheadOriginatingSubRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.SubRegionName = t1.item
	END	
--------------------------------------------------------------------------
/*	COMMON END															*/
--------------------------------------------------------------------------

IF 	OBJECT_ID(''tempdb..#ProfitabilityReport'') IS NOT NULL
    DROP TABLE #ProfitabilityReport

CREATE TABLE #ProfitabilityReport
(	
	GlAccountCategoryKey		Int,
    ActivityTypeKey				Int,
    PropertyFundKey				Int,
    AllocationRegionKey			Int,
    OriginatingRegionKey		Int,
    SourceKey					Int,
    GlAccountKey				Int,
	ReimbursableKey				Int,
	FeeAdjustmentKey			Int,
	FunctionalDepartmentKey		Int,
	OverheadKey					Int,
	CalendarPeriod				Varchar(6) DEFAULT(''''),
	
	EntryDate					VARCHAR(10),
	[User]						NVARCHAR(20),
	[Description]				NVARCHAR(60),
	AdditionalDescription		NVARCHAR(4000),
	PropertyFundCode			Varchar(6) DEFAULT(''''), --Varchar, for this helps to keep reports size smaller
	OriginatingRegionCode		Varchar(15) DEFAULT(''''), --Varchar, for this helps to keep reports size smaller
	FunctionalDepartmentCode	Varchar(15) DEFAULT(''''), --Varchar, for this helps to keep reports size smaller

	--Month to date	
	MtdActual				MONEY,
	MtdBudget				MONEY,
	MtdReforecastQ1		MONEY,
	MtdReforecastQ2		MONEY,
	MtdReforecastQ3		MONEY,
	
	--Year to date
	YtdActual				MONEY,	
	YtdBudget				MONEY, 
	YtdReforecastQ1		MONEY, 
	YtdReforecastQ2		MONEY, 
	YtdReforecastQ3		MONEY, 

	--Annual	
	AnnualBudget			MONEY,
	AnnualReforecastQ1		MONEY,
	AnnualReforecastQ2		MONEY,
	AnnualReforecastQ3		MONEY
)

DECLARE @cmdString Varchar(8000)
DECLARE @cmdString2 Varchar(8000)




--Get actual information
SET @cmdString = (Select ''

INSERT INTO #ProfitabilityReport
SELECT 	
	pa.GlobalGlAccountCategoryKey,
    pa.ActivityTypeKey,
    pa.PropertyFundKey,
    pa.AllocationRegionKey,
    pa.OriginatingRegionKey,
    pa.SourceKey,
    pa.GlAccountKey,
	pa.ReimbursableKey,
	(Select FeeAdjustmentKey From FeeAdjustment Where FeeAdjustmentCode = ''''NORMAL'''') FeeAdjustmentKey,
	pa.FunctionalDepartmentKey,
	pa.OverheadKey,
	c.CalendarPeriod,
	
    CONVERT(varchar(10),ISNULL(pa.EntryDate,''''''''), 101) as EntryDate,
    ISNULL(pa.[User], '''''''') [User],
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.Description ELSE '''''''' END as Description,
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.AdditionalDescription ELSE '''''''' END as AdditionalDescription,
    ISNULL(pa.PropertyFundCode, '''''''') PropertyFundCode,
    ISNULL(pa.OriginatingRegionCode, '''''''') OriginatingRegionCode,
	ISNULL(pa.FunctionalDepartmentCode, '''''''') FunctionalDepartmentCode,
	
    -- Expenses must be displayed as negative an Income is saved in MRI as negative
	SUM(
		er.Rate * -1 *
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdActual,
	NULL as MtdBudget,
	SUM(
		er.Rate * -1 *
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/''
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003,201006,201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdReforecastQ1,
	SUM(
		er.Rate * -1 *
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003,201006,201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdReforecastQ2,
	SUM(
		er.Rate * -1 *
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003,201006,201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdReforecastQ3,
	
	SUM(
		er.Rate * -1 *
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdActual,
	NULL as YtdBudget,
	SUM(
		er.Rate * -1 *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003,201006,201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdReforecastQ1,
	SUM(
		er.Rate * -1 *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003,201006,201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdReforecastQ2,
	SUM(
		er.Rate * -1 *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003,201006,201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdReforecastQ3,
	
	NULL as AnnualBudget,
	SUM(
		er.Rate * -1 *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003,201006,201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualReforecastQ1,
	SUM(
		er.Rate * -1 *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003,201006,201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualReforecastQ2,
	SUM(
		er.Rate * -1 *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003,201006,201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualReforecastQ3
FROM
	ProfitabilityActual pa

	INNER JOIN Overhead oh ON oh.OverheadKey = pa.OverheadKey

	INNER JOIN GlAccount ga on ga.GlAccountKey = pa.GlAccountKey
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pa.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pa.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pa.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pa.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pa.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pa.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pa.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pa.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
		
    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
    INNER JOIN Currency dc ON  dc.CurrencyKey = er.DestinationCurrencyKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pa.ReimbursableKey
    INNER JOIN Calendar c ON  c.CalendarKey = pa.CalendarKey
    INNER JOIN Source s ON s.SourceKey = pa.SourceKey

    INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pa.AllocationRegionKey
    INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey
    INNER JOIN ActivityType a ON  a.ActivityTypeKey = pa.ActivityTypeKey
    INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pa.PropertyFundKey
    INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey
'')

SET @cmdString2 = (Select ''
WHERE  1 = 1
    AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @DisplayOverheadBy = ''Unallocated'' THEN 
			''
		AND (
				(
					gac.AccountSubTypeName	= ''''Overhead''''
				and	Oh.OverHeadCode			IN (''''UNKNOWN'''',''''UNALLOC'''')
				'' +
				CASE WHEN @OverheadOriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OverheadOriginatingSubRegionFilterTable t1) '' END +
				''
				)
			OR	(
				gac.AccountSubTypeName		<> ''''Overhead''''
				''+
				+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable) '' END +
				+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable) '' END +
				''
				)
			)
			''

		ELSE --ALLOC
			''
		AND (
				(
					gac.AccountSubTypeName	<> ''''Overhead''''
				)
			OR	(
					gac.AccountSubTypeName	= ''''Overhead''''
				and	Oh.OverHeadCode			IN (''''UNKNOWN'''',''''ALLOC'''')
				)
			)
			''
		+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable) '' END +
		+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable) '' END

		END +
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select t1.FunctionalDepartmentKey From #FunctionalDepartmentFilterTable t1)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select t1.ActivityTypeKey From #ActivityTypeFilterTable t1)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select t1.PropertyFundKey From #EntityFilterTable t1)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MajorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MinorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingRegionFilterTable t1)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingSubRegionFilterTable t1)'' END +
''
Group By
	pa.GlobalGlAccountCategoryKey,
    pa.ActivityTypeKey,
    pa.PropertyFundKey,
    pa.AllocationRegionKey,
    pa.OriginatingRegionKey,
    pa.SourceKey,
    pa.GlAccountKey,
	pa.ReimbursableKey,
	pa.FunctionalDepartmentKey,
	pa.OverheadKey,
	c.CalendarPeriod,
	
    CONVERT(varchar(10),ISNULL(pa.EntryDate,''''''''), 101),
    ISNULL(pa.[User], ''''''''),
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.Description ELSE '''''''' END,
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.AdditionalDescription ELSE '''''''' END,
    ISNULL(pa.PropertyFundCode, ''''''''),
    ISNULL(pa.OriginatingRegionCode, ''''''''),
	ISNULL(pa.FunctionalDepartmentCode, '''''''')
	
'')
print @cmdString
print @cmdString2
IF LEN(@cmdString) > 7990
	RAISERROR (''Dynamic SQL to large'',16,1)
IF LEN(@cmdString2) > 7990
	RAISERROR (''Dynamic SQL to large'',16,1)

	
EXEC (@cmdString+@cmdString2)



--Get budget information
SET @cmdString = (Select ''

INSERT INTO #ProfitabilityReport
SELECT 
	pb.GlobalGlAccountCategoryKey,
    pb.ActivityTypeKey,
    pb.PropertyFundKey,
    pb.AllocationRegionKey,
    pb.OriginatingRegionKey,
    pb.SourceKey,
    pb.GlAccountKey,
	pb.ReimbursableKey,
	pb.FeeAdjustmentKey,
	pb.FunctionalDepartmentKey,
	pb.OverheadKey,
	'''''''' as CalendarPeriod,
	
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    '''''''' as PropertyFundCode,
    '''''''' as OriginatingRegionCode,
	'''''''' as FunctionalDepartmentCode,
	
    --Expenses must be displayed as negative
    NULL as MtdActual,
	SUM(
		er.Rate * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
					1
				   ELSE
					-1 
				   END) *
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as MtdBudget,
	NULL as MtdReforecastQ1,
	NULL as MtdReforecastQ2,
	NULL as MtdReforecastQ3,
	
	NULL as YtdActual,	
	SUM(
		er.Rate * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
					1
				   ELSE
					-1 
				   END) * 
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as YtdBudget, 
	NULL as YtdReforecastQ1, 
	NULL as YtdReforecastQ2, 
	NULL as YtdReforecastQ3, 
	
	SUM(er.Rate * pb.LocalBudget * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
									1
								  ELSE
									-1 
								  END)) as AnnualBudget,
	NULL as AnnualReforecastQ1,
	NULL as AnnualReforecastQ2,
	NULL as AnnualReforecastQ3
	
FROM
	ProfitabilityBudget pb --WITH (INDEX=IX_Clustered)

	INNER JOIN Overhead oh ON oh.OverheadKey = pb.OverheadKey
	
	INNER JOIN GlAccount ga on ga.GlAccountKey = pb.GlAccountKey
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pb.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pb.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pb.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pb.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pb.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pb.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pb.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pb.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			
    INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey
    INNER JOIN Currency dc ON er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pb.CalendarKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pb.ReimbursableKey
    INNER JOIN Source s ON s.SourceKey = pb.SourceKey

    INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey
    INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey
    INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey
    INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey
    INNER JOIN ActivityType a ON a.ActivityTypeKey = pb.ActivityTypeKey
    INNER JOIN FeeAdjustment Fa ON Fa.FeeAdjustmentKey = pb.FeeAdjustmentKey

WHERE  1 = 1
    AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */''
	
+ CASE WHEN @DisplayOverheadBy = ''Unallocated'' THEN 
			''
		AND (
				(
					gac.AccountSubTypeName	= ''''Overhead''''
				and	Oh.OverHeadCode			IN (''''UNKNOWN'''',''''UNALLOC'''')
				'' +
				CASE WHEN @OverheadOriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OverheadOriginatingSubRegionFilterTable t1) '' END +
				''
				)
			OR	(
				gac.AccountSubTypeName		<> ''''Overhead''''
				''+
				+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable) '' END +
				+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable) '' END +
				''
				)
			)
			''

		ELSE --ALLOC
			''
		AND (
				(
					gac.AccountSubTypeName	<> ''''Overhead''''
				)
			OR	(
					gac.AccountSubTypeName	= ''''Overhead''''
				and	Oh.OverHeadCode			IN (''''UNKNOWN'''',''''ALLOC'''')
				)
			)
			''
		+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable) '' END +
		+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable) '' END

		END +
	
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
+ CASE WHEN @IncludeFeeAdjustments = 1 THEN '' AND Fa.FeeAdjustmentCode IN (''''NORMAL'''',''''FEEADJUST'''')'' ELSE '' AND Fa.FeeAdjustmentCode IN (''''NORMAL'''')'' END +
''
Group By
	pb.GlobalGlAccountCategoryKey,
    pb.ActivityTypeKey,
    pb.PropertyFundKey,
    pb.AllocationRegionKey,
    pb.OriginatingRegionKey,
    pb.SourceKey,
    pb.GlAccountKey,
	pb.ReimbursableKey,
	pb.FeeAdjustmentKey,
	pb.FunctionalDepartmentKey,
	pb.OverheadKey

'')
print @cmdString
IF LEN(@cmdString) > 7990
	RAISERROR (''Dynamic SQL to large'',16,1)
	
EXEC (@cmdString)



--Get reforecast information
--Q1
SET @cmdString = (Select ''

INSERT INTO #ProfitabilityReport
SELECT 
	pr.GlobalGlAccountCategoryKey,
    pr.ActivityTypeKey,
    pr.PropertyFundKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.SourceKey,
    pr.GlAccountKey,
	pr.ReimbursableKey,
	pr.FeeAdjustmentKey,
	pr.FunctionalDepartmentKey,
	pr.OverheadKey,
	'''''''' as CalendarPeriod,
	
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    '''''''' as PropertyFundCode,
    '''''''' as OriginatingRegionCode,
    '''''''' as FunctionalDepartmentCode,
    
    --Expenses must be displayed as negative
	NULL as MtdActual,
	NULL as MtdBudget,
	SUM(
		er.Rate * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
					1
				   ELSE
					-1 
				   END) * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdReforecastQ1,
	NULL as MtdReforecastQ2,
	NULL as MtdReforecastQ3,
	
	NULL as YtdActual,	
	NULL as YtdBudget, 
	SUM(
		er.Rate * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
					1
				   ELSE
					-1 
				   END) * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdReforecastQ1, 
	NULL as YtdReforecastQ2, 
	NULL as YtdReforecastQ3, 
	
	NULL as AnnualBudget, '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''
     SUM(er.Rate * pr.LocalReforecast * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
										  1
									    ELSE
										 -1 
									    END)) as AnnualReforecastQ1,								    
	 
     NULL as AnnualReforecastQ2,								    
     NULL as AnnualReforecastQ3

FROM
	ProfitabilityReforecast pr --WITH (INDEX=IX_Clustered)

	INNER JOIN Overhead oh ON oh.OverheadKey = pr.OverheadKey
	
	INNER JOIN GlAccount ga on ga.GlAccountKey = pr.GlAccountKey
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			
    INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
    INNER JOIN Currency dc ON er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pr.CalendarKey
    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey
    INNER JOIN Source s ON s.SourceKey = pr.SourceKey

    INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey
    INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey
    INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey
    INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey
    INNER JOIN ActivityType a ON a.ActivityTypeKey = pr.ActivityTypeKey
    INNER JOIN FeeAdjustment Fa ON Fa.FeeAdjustmentKey = pr.FeeAdjustmentKey

WHERE  1 = 1
    AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
	AND ref.ReforecastEffectivePeriod = '' + STR(@ReforecastEffectivePeriodQ1,10,0) + ''
''
+ CASE WHEN @DisplayOverheadBy = ''Unallocated'' THEN 
			''
		AND (
				(
					gac.AccountSubTypeName	= ''''Overhead''''
				and	Oh.OverHeadCode			IN (''''UNKNOWN'''',''''UNALLOC'''')
				'' +
				CASE WHEN @OverheadOriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OverheadOriginatingSubRegionFilterTable t1) '' END +
				''
				)
			OR	(
				gac.AccountSubTypeName		<> ''''Overhead''''
				''+
				+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable) '' END +
				+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable) '' END +
				''
				)
			)
			''

		ELSE --ALLOC
			''
		AND (
				(
					gac.AccountSubTypeName	<> ''''Overhead''''
				)
			OR	(
					gac.AccountSubTypeName	= ''''Overhead''''
				and	Oh.OverHeadCode			IN (''''UNKNOWN'''',''''ALLOC'''')
				)
			)
			''
		+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable) '' END +
		+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable) '' END

		END +
		
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
+ CASE WHEN @IncludeFeeAdjustments = 1 THEN '' AND Fa.FeeAdjustmentCode IN (''''NORMAL'''',''''FEEADJUST'''')'' ELSE '' AND Fa.FeeAdjustmentCode IN (''''NORMAL'''')'' END +
''
Group By
	pr.GlobalGlAccountCategoryKey,
    pr.ActivityTypeKey,
    pr.PropertyFundKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.SourceKey,
    pr.GlAccountKey,
	pr.ReimbursableKey,
	pr.FeeAdjustmentKey,
	pr.FunctionalDepartmentKey,
	pr.OverheadKey

'')
print @cmdString
IF LEN(@cmdString) > 7990
	RAISERROR (''Dynamic SQL to large'',16,1)

EXEC (@cmdString)


--Q2



--Get reforecast information
SET @cmdString = (Select ''

INSERT INTO #ProfitabilityReport
SELECT 
	pr.GlobalGlAccountCategoryKey,
    pr.ActivityTypeKey,
    pr.PropertyFundKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.SourceKey,
    pr.GlAccountKey,
	pr.ReimbursableKey,
	pr.FeeAdjustmentKey,
	pr.FunctionalDepartmentKey,
	pr.OverheadKey,
	'''''''' as CalendarPeriod,
	
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    '''''''' as PropertyFundCode,
    '''''''' as OriginatingRegionCode,
    '''''''' as FunctionalDepartmentCode,
    
    --Expenses must be displayed as negative
	NULL as MtdActual,
	NULL as MtdBudget,
	NULL as MtdReforecastQ1,
	SUM(
		er.Rate * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
					1
				   ELSE
					-1 
				   END) * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdReforecastQ2,
	NULL as MtdReforecastQ3,
	
	NULL as YtdActual,	
	NULL as YtdBudget, 
	NULL as YtdReforecastQ1, 
	SUM(
		er.Rate * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
					1
				   ELSE
					-1 
				   END) * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdReforecastQ2, 
	NULL as YtdReforecastQ3, 
	
	NULL as AnnualBudget, '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''
     NULL as AnnualReforecastQ1,								    
	 
     SUM(er.Rate * pr.LocalReforecast * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
										  1
									    ELSE
										 -1 
									    END)) as AnnualReforecastQ2,								    
	 
     NULL as AnnualReforecastQ3

FROM
	ProfitabilityReforecast pr --WITH (INDEX=IX_Clustered)

	INNER JOIN Overhead oh ON oh.OverheadKey = pr.OverheadKey
	
	INNER JOIN GlAccount ga on ga.GlAccountKey = pr.GlAccountKey
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			
    INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
    INNER JOIN Currency dc ON er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pr.CalendarKey
    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey
    INNER JOIN Source s ON s.SourceKey = pr.SourceKey

    INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey
    INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey
    INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey
    INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey
    INNER JOIN ActivityType a ON a.ActivityTypeKey = pr.ActivityTypeKey
    INNER JOIN FeeAdjustment Fa ON Fa.FeeAdjustmentKey = pr.FeeAdjustmentKey

WHERE  1 = 1
    AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
	AND ref.ReforecastEffectivePeriod = '' + STR(@ReforecastEffectivePeriodQ2,10,0) + ''
''
+ CASE WHEN @DisplayOverheadBy = ''Unallocated'' THEN 
			''
		AND (
				(
					gac.AccountSubTypeName	= ''''Overhead''''
				and	Oh.OverHeadCode			IN (''''UNKNOWN'''',''''UNALLOC'''')
				'' +
				CASE WHEN @OverheadOriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OverheadOriginatingSubRegionFilterTable t1) '' END +
				''
				)
			OR	(
				gac.AccountSubTypeName		<> ''''Overhead''''
				''+
				+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable) '' END +
				+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable) '' END +
				''
				)
			)
			''

		ELSE --ALLOC
			''
		AND (
				(
					gac.AccountSubTypeName	<> ''''Overhead''''
				)
			OR	(
					gac.AccountSubTypeName	= ''''Overhead''''
				and	Oh.OverHeadCode			IN (''''UNKNOWN'''',''''ALLOC'''')
				)
			)
			''
		+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable) '' END +
		+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable) '' END

		END +
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
+ CASE WHEN @IncludeFeeAdjustments = 1 THEN '' AND Fa.FeeAdjustmentCode IN (''''NORMAL'''',''''FEEADJUST'''')'' ELSE '' AND Fa.FeeAdjustmentCode IN (''''NORMAL'''')'' END +
''
Group By
	pr.GlobalGlAccountCategoryKey,
    pr.ActivityTypeKey,
    pr.PropertyFundKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.SourceKey,
    pr.GlAccountKey,
	pr.ReimbursableKey,
	pr.FeeAdjustmentKey,
	pr.FunctionalDepartmentKey,
	pr.OverheadKey
'')
print @cmdString
IF LEN(@cmdString) > 7990
	RAISERROR (''Dynamic SQL to large'',16,1)

EXEC (@cmdString)

--Q3



--Get reforecast information
SET @cmdString = (Select ''

INSERT INTO #ProfitabilityReport
SELECT 
	pr.GlobalGlAccountCategoryKey,
    pr.ActivityTypeKey,
    pr.PropertyFundKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.SourceKey,
    pr.GlAccountKey,
	pr.ReimbursableKey,
	pr.FeeAdjustmentKey,
	pr.FunctionalDepartmentKey,
	pr.OverheadKey,
	'''''''' as CalendarPeriod,
	
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    '''''''' as PropertyFundCode,
    '''''''' as OriginatingRegionCode,
    '''''''' as FunctionalDepartmentCode,
    
    --Expenses must be displayed as negative
	NULL as MtdActual,
	NULL as MtdBudget,
	NULL as MtdReforecastQ1,
	NULL as MtdReforecastQ2,
	SUM(
		er.Rate * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
					1
				   ELSE
					-1 
				   END) * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdReforecastQ3,
	
	NULL as YtdActual,	
	NULL as YtdBudget, 
	NULL as YtdReforecastQ1, 
	NULL as YtdReforecastQ2, 
	SUM(
		er.Rate * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
					1
				   ELSE
					-1 
				   END) * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdReforecastQ3, 
	
	NULL as AnnualBudget, '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''
     NULL as AnnualReforecastQ1,								    
	 NULL as AnnualReforecastQ2,								    
	 
     SUM(er.Rate * pr.LocalReforecast * (CASE WHEN gac.FeeOrExpense = ''''INCOME'''' THEN
										  1
									    ELSE
										 -1 
									    END)) as AnnualReforecastQ3

FROM
	ProfitabilityReforecast pr --WITH (INDEX=IX_Clustered)

	INNER JOIN Overhead oh ON oh.OverheadKey = pr.OverheadKey
	
	INNER JOIN GlAccount ga on ga.GlAccountKey = pr.GlAccountKey
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			
    INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
    INNER JOIN Currency dc ON er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pr.CalendarKey
    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey
    INNER JOIN Source s ON s.SourceKey = pr.SourceKey

    INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey
    INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey
    INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey
    INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey
    INNER JOIN ActivityType a ON a.ActivityTypeKey = pr.ActivityTypeKey
    INNER JOIN FeeAdjustment Fa ON Fa.FeeAdjustmentKey = pr.FeeAdjustmentKey

WHERE  1 = 1
    AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
	AND ref.ReforecastEffectivePeriod = '' + STR(@ReforecastEffectivePeriodQ3,10,0) + ''
''
+ CASE WHEN @DisplayOverheadBy = ''Unallocated'' THEN 
			''
		AND (
				(
					gac.AccountSubTypeName	= ''''Overhead''''
				and	Oh.OverHeadCode			IN (''''UNKNOWN'''',''''UNALLOC'''')
				'' +
				CASE WHEN @OverheadOriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OverheadOriginatingSubRegionFilterTable t1) '' END +
				''
				)
			OR	(
				gac.AccountSubTypeName		<> ''''Overhead''''
				''+
				+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable) '' END +
				+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable) '' END +
				''
				)
			)
			''

		ELSE --ALLOC
			''
		AND (
				(
					gac.AccountSubTypeName	<> ''''Overhead''''
				)
			OR	(
					gac.AccountSubTypeName	= ''''Overhead''''
				and	Oh.OverHeadCode			IN (''''UNKNOWN'''',''''ALLOC'''')
				)
			)
			''
		+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable) '' END +
		+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable) '' END

		END +
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
+ CASE WHEN @IncludeFeeAdjustments = 1 THEN '' AND Fa.FeeAdjustmentCode IN (''''NORMAL'''',''''FEEADJUST'''')'' ELSE '' AND Fa.FeeAdjustmentCode IN (''''NORMAL'''')'' END +

''
Group By
	pr.GlobalGlAccountCategoryKey,
    pr.ActivityTypeKey,
    pr.PropertyFundKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.SourceKey,
    pr.GlAccountKey,
	pr.ReimbursableKey,
	pr.FeeAdjustmentKey,
	pr.FunctionalDepartmentKey,
	pr.OverheadKey
'')
print @cmdString
IF LEN(@cmdString) > 7990
	RAISERROR (''Dynamic SQL to large'',16,1)
	
EXEC (@cmdString)


SELECT 
	gac.AccountSubTypeName AS ExpenseType, 
	gac.FeeOrExpense AS FeeOrExpense,
    gac.MajorCategoryName AS MajorExpenseCategoryName,
    gac.MinorCategoryName AS MinorExpenseCategoryName,
    a.ActivityTypeName AS ActivityType,
	pf.PropertyFundName AS ReportingEntityName,
	ar.SubRegionName AS AllocationSubRegionName,
    orr.SubRegionName AS OriginatingSubRegionName,
	CASE WHEN (gac.MajorCategoryName = ''Salaries/Taxes/Benefits'') THEN '''' ELSE ga.Code END GlobalGlAccountCode,
    CASE WHEN (gac.MajorCategoryName = ''Salaries/Taxes/Benefits'') THEN '''' ELSE ga.Name END GlobalGlAccountName,    
	r.ReimbursableName,
	fa.FeeAdjustmentCode,
	s.SourceName,
	gac.GlAccountCategoryKey,
	
	res.CalendarPeriod AS ActualsExpensePeriod,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
	res.PropertyFundCode,
	res.FunctionalDepartmentCode,
    res.OriginatingRegionCode,

	--Gross
	--Month to date    
	SUM(ISNULL(res.MtdActual,0)) AS MtdActual,
	SUM(ISNULL(res.MtdBudget,0)) AS MtdOriginalBudget,
	
	SUM(ISNULL(res.MtdReforecastQ1,0))AS MtdReforecastQ1,
	SUM(ISNULL(res.MtdReforecastQ2,0))AS MtdReforecastQ2,
	SUM(ISNULL(res.MtdReforecastQ3,0))AS MtdReforecastQ3,

	CASE WHEN gac.FeeOrExpense = ''EXPENSE'' THEN SUM(ISNULL(MtdBudget,0)) - SUM(ISNULL(MtdActual,0)) ELSE SUM(ISNULL(res.MtdActual,0)) - SUM(ISNULL(MtdBudget,0)) END AS MtdVarianceQ0,
	CASE WHEN gac.FeeOrExpense = ''EXPENSE'' THEN SUM(ISNULL(res.MtdReforecastQ1,0)) - SUM(ISNULL(MtdActual,0)) ELSE SUM(ISNULL(MtdActual,0)) - SUM(ISNULL(res.MtdReforecastQ1,0)) END AS MtdVarianceQ1,
	CASE WHEN gac.FeeOrExpense = ''EXPENSE'' THEN SUM(ISNULL(res.MtdReforecastQ2,0)) - SUM(ISNULL(MtdActual,0)) ELSE SUM(ISNULL(MtdActual,0)) - SUM(ISNULL(res.MtdReforecastQ2,0)) END AS MtdVarianceQ2,
	CASE WHEN gac.FeeOrExpense = ''EXPENSE'' THEN SUM(ISNULL(res.MtdReforecastQ3,0)) - SUM(ISNULL(MtdActual,0)) ELSE SUM(ISNULL(MtdActual,0)) - SUM(ISNULL(res.MtdReforecastQ3,0)) END AS MtdVarianceQ3,
	
	--Year to date
	SUM(ISNULL(res.YtdActual,0)) AS YtdActual,	
	SUM(ISNULL(res.YtdBudget,0)) AS YtdOriginalBudget,
	
	SUM(ISNULL(res.YtdReforecastQ1,0)) AS YtdReforecastQ1,
	SUM(ISNULL(res.YtdReforecastQ2,0)) YtdReforecastQ2,
	SUM(ISNULL(res.YtdReforecastQ3,0)) YtdReforecastQ3,
	

	CASE WHEN gac.FeeOrExpense = ''EXPENSE'' THEN SUM(ISNULL(YtdBudget,0)) - SUM(ISNULL(YtdActual,0)) ELSE SUM(ISNULL(res.YtdActual,0)) - SUM(ISNULL(YtdBudget,0)) END AS YtdVarianceQ0,
	CASE WHEN gac.FeeOrExpense = ''EXPENSE'' THEN SUM(ISNULL(res.YtdReforecastQ1,0)) - SUM(ISNULL(YtdActual,0)) ELSE SUM(ISNULL(YtdActual,0)) - SUM(ISNULL(res.YtdReforecastQ1,0)) END AS YtdVarianceQ1,
	CASE WHEN gac.FeeOrExpense = ''EXPENSE'' THEN SUM(ISNULL(res.YtdReforecastQ2,0)) - SUM(ISNULL(YtdActual,0)) ELSE SUM(ISNULL(YtdActual,0)) - SUM(ISNULL(res.YtdReforecastQ2,0)) END AS YtdVarianceQ2,
	CASE WHEN gac.FeeOrExpense = ''EXPENSE'' THEN SUM(ISNULL(res.YtdReforecastQ3,0)) - SUM(ISNULL(YtdActual,0)) ELSE SUM(ISNULL(YtdActual,0)) - SUM(ISNULL(res.YtdReforecastQ3,0)) END AS YtdVarianceQ3,
	
	--Annual
	SUM(ISNULL(res.AnnualBudget,0)) AS AnnualOriginalBudget,	
	SUM(ISNULL(res.AnnualReforecastQ1,0)) AS AnnualReforecastQ1,
	SUM(ISNULL(res.AnnualReforecastQ2,0)) AS AnnualReforecastQ2,
	SUM(ISNULL(res.AnnualReforecastQ3,0)) AS AnnualReforecastQ3

INTO
	[#Output]
FROM
	#ProfitabilityReport res
	
	INNER JOIN Overhead oh ON oh.OverheadKey = res.OverheadKey

	INNER JOIN GlAccount ga on ga.GlAccountKey = res.GlAccountKey
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = res.GlAccountCategoryKey
		
    INNER JOIN Reimbursable r ON r.ReimbursableKey = res.ReimbursableKey
    INNER JOIN Source s ON s.SourceKey = res.SourceKey

    INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = res.AllocationRegionKey
    INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = res.OriginatingRegionKey
    INNER JOIN ActivityType a ON  a.ActivityTypeKey = res.ActivityTypeKey
    INNER JOIN PropertyFund pf ON pf.PropertyFundKey = res.PropertyFundKey
    INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = res.FunctionalDepartmentKey
    INNER JOIN FeeAdjustment fa ON fa.FeeAdjustmentKey = res.FeeAdjustmentKey
	
GROUP BY
	gac.AccountSubTypeName, 
	gac.FeeOrExpense,
    gac.MajorCategoryName,
    gac.MinorCategoryName,
    a.ActivityTypeName,
	pf.PropertyFundName,
	ar.SubRegionName,
    orr.SubRegionName,
	CASE WHEN (gac.MajorCategoryName = ''Salaries/Taxes/Benefits'') THEN '''' ELSE ga.Code END,
    CASE WHEN (gac.MajorCategoryName = ''Salaries/Taxes/Benefits'') THEN '''' ELSE ga.Name END,
	r.ReimbursableName,
	fa.FeeAdjustmentCode,
	s.SourceName,
	gac.GlAccountCategoryKey,
	
	res.CalendarPeriod,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
	res.PropertyFundCode,
	res.FunctionalDepartmentCode,
    res.OriginatingRegionCode


--Eliminate any rows, that all calcs product a 0 value, this is to reduce the report size
------------------------------------------------------------------------------------------------------------------------------------------
-- <<< NOTE !!!!!!! >>>
--Any changes to this resultset must be applied to the [stp_R_Profitability] for this stp is used in a insert into xxx exec xxx there
------------------------------------------------------------------------------------------------------------------------------------------
SELECT
	ExpenseType, 
	FeeOrExpense,
    MajorExpenseCategoryName,
    MinorExpenseCategoryName,
	GlobalGlAccountCode,
	GlobalGlAccountName,
    ActivityType,
	ReportingEntityName,
	PropertyFundCode,
	FunctionalDepartmentCode,
	AllocationSubRegionName,
	OriginatingSubRegionName,
	ActualsExpensePeriod,
    EntryDate,
    [User],
    [Description],
    AdditionalDescription,
	ReimbursableName,
	FeeAdjustmentCode,
	SourceName,
	GlAccountCategoryKey,
	
	--Gross
	--Month to date    
	MtdActual,
	MtdOriginalBudget,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE MtdReforecastQ1 END AS MtdReforecastQ1,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE MtdReforecastQ2 END AS MtdReforecastQ2,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE MtdReforecastQ3 END AS MtdReforecastQ3,

	MtdVarianceQ0,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE MtdVarianceQ1 END AS MtdVarianceQ1,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE MtdVarianceQ2 END AS MtdVarianceQ2,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE MtdVarianceQ3 END AS MtdVarianceQ3,
	
	--Year to date
	YtdActual,	
	YtdOriginalBudget,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE YtdReforecastQ1 END AS YtdReforecastQ1,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE YtdReforecastQ2 END AS YtdReforecastQ2,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE YtdReforecastQ3 END AS YtdReforecastQ3,

	YtdVarianceQ0,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE YtdVarianceQ1 END AS YtdVarianceQ1,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE YtdVarianceQ2 END AS YtdVarianceQ2,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE YtdVarianceQ3 END AS YtdVarianceQ3,

	--Annual
	AnnualOriginalBudget,	
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE AnnualReforecastQ1 END AS AnnualReforecastQ1,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE AnnualReforecastQ2 END AS AnnualReforecastQ2,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE AnnualReforecastQ3 END AS AnnualReforecastQ3

FROM
	[#Output]
--WHERE
	----Gross
	----Month to date    
	--MtdActual <> 0.00 OR
	--MtdOriginalBudget <> 0.00 OR
	--MtdReforecastQ1 <> 0.00 OR
	--MtdReforecastQ2 <> 0.00 OR
	--MtdReforecastQ3 <> 0.00 OR
	--MtdVarianceQ0 <> 0.00 OR
	--MtdVarianceQ1 <> 0.00 OR
	--MtdVarianceQ2 <> 0.00 OR
	--MtdVarianceQ3 <> 0.00 OR
	
	----Year to date
	--YtdActual <> 0.00 OR
	--YtdOriginalBudget <> 0.00 OR
	--YtdReforecastQ1 <> 0.00 OR
	--YtdReforecastQ2 <> 0.00 OR
	--YtdReforecastQ3 <> 0.00 OR
	--YtdVarianceQ0 <> 0.00 OR
	--YtdVarianceQ1 <> 0.00 OR
	--YtdVarianceQ2 <> 0.00 OR
	--YtdVarianceQ3 <> 0.00 OR
	
	----Annual
	--AnnualOriginalBudget <> 0.00 OR
	--AnnualReforecastQ1 <> 0.00 OR
	--AnnualReforecastQ2 <> 0.00 OR
	--AnnualReforecastQ3 <> 0.00

IF 	OBJECT_ID(''tempdb..#ProfitabilityReport'') IS NOT NULL
    DROP TABLE #ProfitabilityReport

IF 	OBJECT_ID(''tempdb..#Output'') IS NOT NULL
    DROP TABLE #Output

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzarTotalComparisonDetail]    Script Date: 01/25/2011 14:18:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzarTotalComparisonDetail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[stp_R_ExpenseCzarTotalComparisonDetail]
	@ReportExpensePeriod INT = NULL,
	@ReforecastQuaterName VARCHAR(10) = NULL, --''Q1'' or ''Q2'' or ''Q3''
	@PreviousReforecastQuaterName VARCHAR(10) = ''Q1'', -- or ''Q2'' or ''Q3''
	@DestinationCurrency VARCHAR(3) = NULL,
	@TranslationTypeName VARCHAR(50) = ''Global'',
	@IsGross bit = 1,
	@FunctionalDepartmentList TEXT = NULL,
	@ActivityTypeList TEXT = NULL,
	@EntityList TEXT = NULL,
	@MajorAccountCategoryList TEXT = NULL,
	@MinorAccountCategoryList TEXT = NULL,
	@AllocationRegionList TEXT = NULL,
	@AllocationSubRegionList TEXT = NULL,
	@OriginatingRegionList TEXT = NULL,
	@OriginatingSubRegionList TEXT = NULL,
	@CategoryActivityGroups dbo.CategoryActivityGroup READONLY,
	@OverheadCode Varchar(10)=''UNALLOC''
AS

/*
DECLARE @ReportExpensePeriod   INT,
	@AccountCategoryList   VARCHAR(8000),
	@DestinationCurrency   VARCHAR(3),
	@TranslationTypeName   VARCHAR(50),
	@FunctionalDepartmentList VARCHAR(8000),
	@AllocationRegionList VARCHAR(8000),
	@EntityList VARCHAR(8000)
	
	
	SET @ReportExpensePeriod = 201011
	SET @AccountCategoryList = ''IT Costs & Telecommunications''
	SET @DestinationCurrency =''USD''
	SET @TranslationTypeName = ''Global''
	SET @FunctionalDepartmentList = ''Information Technologies''
	SET @AllocationRegionList = NULL
	SET @EntityList = NULL
	
EXEC stp_R_ExpenseCzarTotalComparisonDetail
	@ReportExpensePeriod = 201011,
	@TranslationTypeName = ''Global'',
	@DestinationCurrency = ''USD'',

	@FunctionalDepartmentList = ''Information Technologies'',
	@AllocationRegionList = ''CHICAGO'',
	@EntityList = ''Aldgate|Centrium (St Cathrine House/Pegasus)''
*/

DECLARE
	@_ReportExpensePeriod INT = @ReportExpensePeriod,
	@_ReforecastQuaterName VARCHAR(10) = @ReforecastQuaterName,
	@_PreviousReforecastQuaterName VARCHAR(10) = @PreviousReforecastQuaterName,
	@_DestinationCurrency VARCHAR(3) = @DestinationCurrency,
	@_TranslationTypeName VARCHAR(50) = @TranslationTypeName,
	@_IsGross bit = @IsGross,
	@_FunctionalDepartmentList VARCHAR(8000) = @FunctionalDepartmentList,
	@_ActivityTypeList VARCHAR(8000) = @ActivityTypeList,
	@_EntityList VARCHAR(8000) = @EntityList,
	@_MajorAccountCategoryList VARCHAR(8000) = @MajorAccountCategoryList,
	@_MinorAccountCategoryList VARCHAR(8000) = @MinorAccountCategoryList,
	@_AllocationRegionList VARCHAR(8000) = @AllocationRegionList,
	@_AllocationSubRegionList VARCHAR(8000) = @AllocationSubRegionList,
	@_OriginatingRegionList VARCHAR(8000) = @OriginatingRegionList,
	@_OriginatingSubRegionList VARCHAR(8000) = @OriginatingSubRegionList

IF LEN(@_FunctionalDepartmentList) > 7998 OR
	LEN(@_ActivityTypeList) > 7998 OR
	LEN(@_EntityList) > 7998 OR
	LEN(@_MajorAccountCategoryList) > 7998 OR
	LEN(@_MinorAccountCategoryList) > 7998 OR
	LEN(@_AllocationRegionList) > 7998 OR
	LEN(@_AllocationSubRegionList) > 7998 OR
	LEN(@_OriginatingRegionList) > 7998 OR
	LEN(@_OriginatingSubRegionList) > 7998
BEGIN
	RAISERROR(''Filter List parameter is too big'',9,1)
END

--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Variable defaults		*/
--------------------------------------------------------------------------

IF @ReportExpensePeriod IS NULL
	SET @ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + CAST(MONTH(GETDATE()) AS VARCHAR(2))AS INT)

IF @DestinationCurrency IS NULL
	SET @DestinationCurrency = ''USD''

IF 	@TranslationTypeName IS NULL
	SET @TranslationTypeName = ''Global''

	DECLARE @CalendarYear AS INT
	SET @CalendarYear = CAST(SUBSTRING(CAST(@ReportExpensePeriod AS VARCHAR(10)), 1, 4) AS INT)		
	
-- let latest reforecast (it will be zero if there is no data for the reforecast)
IF @ReforecastQuaterName IS NULL OR @ReforecastQuaterName NOT IN (''Q0'', ''Q1'', ''Q2'', ''Q3'')
	SET @ReforecastQuaterName = (SELECT TOP 1
									ReforecastQuarterName 
								 FROM
									dbo.Reforecast 
								 WHERE
									ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
									ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
								 ORDER BY
									ReforecastEffectivePeriod DESC)

-- Compute Reforecast Effective Periods

DECLARE @ReforecastEffectivePeriodQ1 INT
DECLARE @ReforecastEffectivePeriodQ2 INT
DECLARE @ReforecastEffectivePeriodQ3 INT

SET @ReforecastEffectivePeriodQ1 = (SELECT TOP 1
										ReforecastEffectivePeriod 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										ReforecastQuarterName = ''Q1''
									ORDER BY
										ReforecastEffectivePeriod)								

SET @ReforecastEffectivePeriodQ2 = (SELECT TOP 1
										ReforecastEffectivePeriod 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										ReforecastQuarterName = ''Q2''
									ORDER BY
										ReforecastEffectivePeriod)								

SET @ReforecastEffectivePeriodQ3 = (SELECT TOP 1
										ReforecastEffectivePeriod 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										ReforecastQuarterName = ''Q3''
									ORDER BY
										ReforecastEffectivePeriod)

-- Retrieve Reforecast Quarter Name

DECLARE @ReforecastQuarterNameQ1 CHAR(2)
DECLARE @ReforecastQuarterNameQ2 CHAR(2)
DECLARE @ReforecastQuarterNameQ3 CHAR(2)

IF (@ReforecastEffectivePeriodQ1 IS NOT NULL)
BEGIN
	SET @ReforecastQuarterNameQ1 = (SELECT TOP 1
										ReforecastQuarterName 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectivePeriod = @ReforecastEffectivePeriodQ1)
END
ELSE
BEGIN
	PRINT (''@ReforecastEffectivePeriodQ1 is NULL - cannot determine Q1 reforecast quarter name.'')
END


IF (@ReforecastEffectivePeriodQ2 IS NOT NULL)
BEGIN
	SET @ReforecastQuarterNameQ2 = (SELECT TOP 1
											ReforecastQuarterName 
										FROM
											dbo.Reforecast 
										WHERE
											ReforecastEffectivePeriod = @ReforecastEffectivePeriodQ2)
END
ELSE
BEGIN
	PRINT (''@ReforecastEffectivePeriodQ2 is NULL - cannot determine Q2 reforecast quarter name.'')
END


IF (@ReforecastEffectivePeriodQ3 IS NOT NULL)
BEGIN
	SET @ReforecastQuarterNameQ3 = (SELECT TOP 1
											ReforecastQuarterName 
										FROM
											dbo.Reforecast 
										WHERE
											ReforecastEffectivePeriod = @ReforecastEffectivePeriodQ3)
END
ELSE
BEGIN
	PRINT (''@ReforecastEffectivePeriodQ3 is NULL - cannot determine Q3 reforecast quarter name.'')
END
	
--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Tables		*/
--------------------------------------------------------------------------
	
CREATE TABLE #EntityFilterTable (PropertyFundKey Int NOT NULL)
CREATE TABLE #FunctionalDepartmentFilterTable (FunctionalDepartmentKey Int NOT NULL)
CREATE TABLE #ActivityTypeFilterTable (ActivityTypeKey Int NOT NULL)
CREATE TABLE #AllocationRegionFilterTable (AllocationRegionKey Int NOT NULL)
CREATE TABLE #AllocationSubRegionFilterTable	(AllocationRegionKey Int NOT NULL)
CREATE TABLE #MajorAccountCategoryFilterTable (GlAccountCategoryKey Int NOT NULL)	
CREATE TABLE #MinorAccountCategoryFilterTable (GlAccountCategoryKey Int NOT NULL)	
CREATE TABLE #OriginatingRegionFilterTable (OriginatingRegionKey Int NOT NULL)
CREATE TABLE #OriginatingSubRegionFilterTable (OriginatingRegionKey Int NOT NULL)	
CREATE TABLE #CategoryActivityGroupFilterTable (GlAccountCategoryKey Int NOT NULL, ActivityTypeKey Int NULL)	

CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable (PropertyFundKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable (FunctionalDepartmentKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable (ActivityTypeKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationRegionFilterTable (AllocationRegionKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable (AllocationRegionKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MajorAccountCategoryFilterTable (GlAccountCategoryKey)	
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MinorAccountCategoryFilterTable (GlAccountCategoryKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingRegionFilterTable (OriginatingRegionKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable (OriginatingRegionKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #CategoryActivityGroupFilterTable (GlAccountCategoryKey, ActivityTypeKey)
	
IF (@EntityList IS NOT NULL)
	BEGIN
	Insert Into #EntityFilterTable
	Select pf.PropertyFundKey
	From dbo.Split(@_EntityList) t1
		INNER JOIN PropertyFund pf ON pf.PropertyFundName = t1.item
	
	END
	
IF (@FunctionalDepartmentList IS NOT NULL)
	BEGIN
	Insert Into #FunctionalDepartmentFilterTable
	Select fd.FunctionalDepartmentKey 
	From dbo.Split(@_FunctionalDepartmentList) t1
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentName = t1.item
	END

IF 	(@ActivityTypeList IS NOT NULL)
	BEGIN
    INSERT INTO #ActivityTypeFilterTable
    SELECT at.ActivityTypeKey 
    FROM dbo.Split(@_ActivityTypeList) t1
		INNER JOIN ActivityType at ON at.ActivityTypeName = t1.item
	END
	
IF (@AllocationRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationRegionFilterTable
	Select ar.AllocationRegionKey 
	From dbo.Split(@_AllocationRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.RegionName = t1.item
	END

IF (@AllocationSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationSubRegionFilterTable
	Select ar.AllocationRegionKey
	From dbo.Split(@_AllocationSubRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.SubRegionName = t1.item
	END

IF (@MajorAccountCategoryList IS NOT NULL)
	BEGIN
	Insert Into #MajorAccountCategoryFilterTable
	Select gl.GlAccountCategoryKey 
	From dbo.Split(@_MajorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MajorCategoryName = t1.item
	END
	
IF 	(@MinorAccountCategoryList IS NOT NULL)
	BEGIN
    INSERT INTO #MinorAccountCategoryFilterTable
    SELECT gl.GlAccountCategoryKey 
    FROM dbo.Split(@MinorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MinorCategoryName = t1.item
	END	

IF (@OriginatingRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingRegionFilterTable
	Select orr.OriginatingRegionKey 
	From dbo.Split(@_OriginatingRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.RegionName = t1.item
	END

IF (@OriginatingSubRegionList IS NOT NULL)
	BEGIN
	INSERT INTO #OriginatingSubRegionFilterTable
	SELECT orr.OriginatingRegionKey  
	From dbo.Split(@OriginatingSubRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.SubRegionName = t1.item
	END		
	
IF EXISTS(SELECT * FROM @CategoryActivityGroups)
	BEGIN
	INSERT INTO #CategoryActivityGroupFilterTable
	SELECT gl.GlAccountCategoryKey, at.ActivityTypeKey 
	FROM @CategoryActivityGroups cag
		CROSS APPLY dbo.Split(cag.MinorAccountCategoryList) t1
		OUTER APPLY dbo.Split(cag.ActivityTypeList) t2
		INNER JOIN GlAccountCategory gl ON gl.MinorCategoryName = t1.item 
		LEFT OUTER JOIN ActivityType at ON at.ActivityTypeName = t2.item
	END
--------------------------------------------------------------------------
/*	COMMON END															*/
--------------------------------------------------------------------------

IF 	OBJECT_ID(''tempdb..#ExpenseCzarTotalComparisonDetail'') IS NOT NULL
    DROP TABLE #ExpenseCzarTotalComparisonDetail

CREATE TABLE #ExpenseCzarTotalComparisonDetail
(	
	GlAccountCategoryKey	INT,
    FunctionalDepartmentKey	INT,
    AllocationRegionKey		INT,
    PropertyFundKey			INT,
	SourceName				VARCHAR(50),
	EntryDate				VARCHAR(10),
	[User]					NVARCHAR(20),
	[Description]			NVARCHAR(60),
	AdditionalDescription	NVARCHAR(4000),
	PropertyFundCode		VARCHAR(6) DEFAULT(''''), --Varchar, for this helps to keep reports size smaller
	OriginatingRegionCode	VARCHAR(15) DEFAULT(''''), --Varchar, for this helps to keep reports size smaller
	GlAccountKey			INT NULL,
	CalendarPeriod			Varchar(6) DEFAULT(''''),

	--Month to date	
	MtdGrossActual			MONEY,
	MtdGrossBudget			MONEY,
	MtdGrossReforecastQ1	MONEY,
	MtdGrossReforecastQ2	MONEY,
	MtdGrossReforecastQ3	MONEY,
	MtdNetActual			MONEY,
	MtdNetBudget			MONEY,
	MtdNetReforecastQ1		MONEY,
	MtdNetReforecastQ2		MONEY,
	MtdNetReforecastQ3		MONEY,
	
	--Year to date
	YtdGrossActual			MONEY,	
	YtdGrossBudget			MONEY, 
	YtdGrossReforecastQ1	MONEY,
	YtdGrossReforecastQ2	MONEY,
	YtdGrossReforecastQ3	MONEY,
	YtdNetActual			MONEY, 
	YtdNetBudget			MONEY, 
	YtdNetReforecastQ1		MONEY,
	YtdNetReforecastQ2		MONEY,
	YtdNetReforecastQ3		MONEY,

	--Annual	
	AnnualGrossBudget		MONEY,
	AnnualGrossReforecastQ1	MONEY,
	AnnualGrossReforecastQ2	MONEY,
	AnnualGrossReforecastQ3	MONEY,

	AnnualNetBudget			MONEY,
	AnnualNetReforecastQ1	MONEY,
	AnnualNetReforecastQ2	MONEY,
	AnnualNetReforecastQ3	MONEY,


	--Annual estimated
	AnnualEstGrossBudget	MONEY,
	AnnualEstGrossReforecastQ1 MONEY,
	AnnualEstGrossReforecastQ2 MONEY,
	AnnualEstGrossReforecastQ3 MONEY,
	
	AnnualEstNetBudget		MONEY,
	AnnualEstNetReforecastQ1 MONEY,
	AnnualEstNetReforecastQ2 MONEY,
	AnnualEstNetReforecastQ3 MONEY
)

DECLARE @cmdString VARCHAR(8000)

--Get actual information
SET @cmdString = (SELECT ''
	
INSERT INTO #ExpenseCzarTotalComparisonDetail
SELECT 
	gac.GlAccountCategoryKey,
    pa.FunctionalDepartmentKey,
    pa.AllocationRegionKey,
    pa.PropertyFundKey,
    s.SourceName,
    CONVERT(varchar(10),ISNULL(pa.EntryDate,''''''''), 101) as EntryDate,
    ISNULL(pa.[User], '''''''') [User],
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.Description ELSE '''''''' END as Description,
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.AdditionalDescription ELSE '''''''' END as AdditionalDescription,
    ISNULL(pa.PropertyFundCode, '''''''') PropertyFundCode,
    ISNULL(pa.OriginatingRegionCode, '''''''') OriginatingRegionCode,
    pa.GlAccountKey,
    c.CalendarPeriod,
    
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdGrossActual,
	NULL as MtdGrossBudget,
	
	'' + /*--  --------------------------*/ + ''
	
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdGrossReforecastQ1,
	
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdGrossReforecastQ2,

	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdGrossReforecastQ3,	
	
	'' + /*--  --------------------------*/ + ''
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdNetActual,
	NULL as MtdNetBudget,
	
	'' + /*--  --------------------------*/ + ''
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdNetReforecastQ1,

	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdNetReforecastQ2,

	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdNetReforecastQ3,

	'' + /*--  --------------------------*/ + ''
	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdGrossActual,
	NULL as YtdGrossBudget,
	
	'' + /*--  --------------------------*/ + ''
	
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdGrossReforecastQ1,

	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdGrossReforecastQ2,

	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdGrossReforecastQ3,

	'')
	
	DECLARE @cmdString2 VARCHAR(8000)
	SET @cmdString2 = (SELECT ''

	'' + /*--  --------------------------*/ + ''
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdNetActual,
	NULL as YtdNetBudget,
	
	'' + /*--  --------------------------*/ + ''
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdNetReforecastQ1,

	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdNetReforecastQ2,

	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdNetReforecastQ3,
	
	'' + /*--  --------------------------*/ + ''
	
	NULL as AnnualGrossBudget,
	
	'' + /*--  --------------------------*/ + ''
	
	SUM(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualGrossReforecastQ1,

	SUM(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualGrossReforecastQ2,

	SUM(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualGrossReforecastQ3,

	'' + /*--  --------------------------*/ + ''

	NULL as AnnualNetBudget,
	
	'' + /*--  --------------------------*/ + ''
	
    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ1,

    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ2,

    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ3,

	'' + /*--  --------------------------*/ + ''
		
	SUM(
        er.Rate *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pa.LocalActual
        ELSE 
			0
        END
	) as AnnualEstGrossBudget,
	
	'' + /*--  --------------------------*/ + ''
	
	'')
	
	DECLARE @cmdString3 VARCHAR(8000)
	SET @cmdString3 = (SELECT ''
	
	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecastQ1,

	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecastQ2,

	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecastQ3,

	'' + /*--  --------------------------*/ + ''

    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
    
    '' + /*--  --------------------------*/ + ''
    
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstNetReforecastQ1,
	
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstNetReforecastQ2,
	
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstNetReforecastQ3	
	
	'' + /*--  --------------------------*/ + ''
	
FROM
	ProfitabilityActual pa

	INNER JOIN Overhead oh ON oh.OverheadKey = pa.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1

		INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
				WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pa.EUCorporateGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''US Property'' THEN ''pa.USPropertyGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''US Fund'' THEN ''pa.USFundGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''EU Property'' THEN ''pa.EUPropertyGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''US Corporate'' THEN ''pa.USCorporateGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''Development'' THEN ''pa.DevelopmentGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''EU Fund'' THEN ''pa.EUFundGlAccountCategoryKey'' 
				WHEN @TranslationTypeName = ''Global'' THEN ''pa.GlobalGlAccountCategoryKey'' 
				ELSE ''break:not valid TranslationTypeName'' END + ''
				AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')
				
	    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
	    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
	    INNER JOIN Calendar c ON  c.CalendarKey = pa.CalendarKey
	    INNER JOIN Source s ON s.SourceKey = pa.SourceKey
	    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pa.ReimbursableKey ''
	    
    + CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pa.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pa.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pa.PropertyFundKey'' ELSE '''' END + 
	+ CASE WHEN EXISTS(SELECT * FROM @CategoryActivityGroups) THEN '' INNER JOIN #CategoryActivityGroupFilterTable cag ON cag.GlAccountCategoryKey = gac.GlAccountCategoryKey AND (cag.ActivityTypeKey IS NULL OR cag.ActivityTypeKey = pa.ActivityTypeKey)'' ELSE '''' END + ''
			
WHERE  1 = 1
    AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select t1.FunctionalDepartmentKey From #FunctionalDepartmentFilterTable t1)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select t1.ActivityTypeKey From #ActivityTypeFilterTable t1)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select t1.PropertyFundKey From #EntityFilterTable t1)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationRegionFilterTable t1)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationSubRegionFilterTable t1)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MajorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MinorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingRegionFilterTable t1)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingSubRegionFilterTable t1)'' END +
''
GROUP BY
	gac.GlAccountCategoryKey,
    pa.FunctionalDepartmentKey,
    pa.AllocationRegionKey,
    pa.PropertyFundKey,
    s.SourceName,
	CONVERT(varchar(10),ISNULL(pa.EntryDate,''''''''), 101),
	pa.[User],
	CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.Description ELSE '''''''' END,
	CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.AdditionalDescription ELSE '''''''' END,
	ISNULL(pa.PropertyFundCode, ''''''''),
	ISNULL(pa.OriginatingRegionCode, ''''''''),
	pa.GlAccountKey,
	c.CalendarPeriod

'')

IF (LEN(@cmdString) > 7995 OR LEN(@cmdString2) > 7995 OR LEN(@cmdString3) > 7995)
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LTRIM(RTRIM(LEN(@cmdString)))) + '' + '' + STR(LTRIM(RTRIM(LEN(@cmdString2)))) + '' + '' + STR(LTRIM(RTRIM(LEN(@cmdString3)))))

PRINT @cmdString
PRINT @cmdString2
PRINT @cmdString3

EXEC (@cmdString + @cmdString2 + @cmdString3)

-- Get budget information
SET @cmdString = (Select ''	

INSERT INTO #ExpenseCzarTotalComparisonDetail
SELECT 
	gac.GlAccountCategoryKey,
	pb.FunctionalDepartmentKey,
	pb.AllocationRegionKey,
	pb.PropertyFundKey,
	s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    '''''''' as PropertyFundCode,
    '''''''' as OriginatingRegionCode,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pb.GlAccountKey END,
	'''''''' as CalendarPeriod,
    
   NULL as MtdGrossActual,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as MtdGrossBudget,	
	NULL as MtdGrossReforecastQ1,
	NULL as MtdGrossReforecastQ2,
	NULL as MtdGrossReforecastQ3,
	
	NULL as MtdNetActual,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as MtdNetBudget,    
	NULL as MtdNetReforecastQ1,
	NULL as MtdNetReforecastQ2,
	NULL as MtdNetReforecastQ3,
	
	NULL as YtdGrossActual,	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as YtdGrossBudget, 
	NULL as YtdGrossReforecastQ1,
	NULL as YtdGrossReforecastQ2,
	NULL as YtdGrossReforecastQ3,
	
	NULL as YtdNetActual, 
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as YtdNetBudget, 
	NULL as YtdNetReforecastQ1,
	NULL as YtdNetReforecastQ2,
	NULL as YtdNetReforecastQ3,
	
	SUM(er.Rate * pb.LocalBudget) as AnnualGrossBudget,
	NULL as AnnualGrossReforecastQ1,
	NULL as AnnualGrossReforecastQ2,
	NULL as AnnualGrossReforecastQ3,

	SUM(er.Rate * r.MultiplicationFactor * pb.LocalBudget) as AnnualNetBudget,
	NULL as AnnualNetReforecastQ1,
	NULL as AnnualNetReforecastQ2,
	NULL as AnnualNetReforecastQ3,

	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as AnnualEstGrossBudget,
	NULL as AnnualEstGrossReforecastQ1,
	NULL as AnnualEstGrossReforecastQ2,
	NULL as AnnualEstGrossReforecastQ3,

	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
	NULL as AnnualEstNetReforecastQ1,
	NULL as AnnualEstNetReforecastQ2,
	NULL as AnnualEstNetReforecastQ3
	
FROM
	ProfitabilityBudget pb

	INNER JOIN Overhead oh ON oh.OverheadKey = pb.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1
		
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
		WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pb.EUCorporateGlAccountCategoryKey'' 
		WHEN @TranslationTypeName = ''US Property'' THEN ''pb.USPropertyGlAccountCategoryKey'' 
		WHEN @TranslationTypeName = ''US Fund'' THEN ''pb.USFundGlAccountCategoryKey'' 
		WHEN @TranslationTypeName = ''EU Property'' THEN ''pb.EUPropertyGlAccountCategoryKey'' 
		WHEN @TranslationTypeName = ''US Corporate'' THEN ''pb.USCorporateGlAccountCategoryKey'' 
		WHEN @TranslationTypeName = ''Development'' THEN ''pb.DevelopmentGlAccountCategoryKey'' 
		WHEN @TranslationTypeName = ''EU Fund'' THEN ''pb.EUFundGlAccountCategoryKey'' 
		WHEN @TranslationTypeName = ''Global'' THEN ''pb.GlobalGlAccountCategoryKey'' 
		ELSE ''break:not valid TranslationTypeName'' END + ''
		AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')	

    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pb.CalendarKey
    INNER JOIN Source s ON s.SourceKey = pb.SourceKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pb.ReimbursableKey ''
	    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pb.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey'' ELSE '''' END + 
	+ CASE WHEN EXISTS(SELECT * FROM @CategoryActivityGroups) THEN '' INNER JOIN #CategoryActivityGroupFilterTable cag ON cag.GlAccountCategoryKey = gac.GlAccountCategoryKey AND (cag.ActivityTypeKey IS NULL OR cag.ActivityTypeKey = pb.ActivityTypeKey)'' ELSE '''' END + ''

WHERE  1 = 1 
    AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
GROUP BY
	gac.GlAccountCategoryKey,
    pb.FunctionalDepartmentKey,
    pb.AllocationRegionKey,
    pb.PropertyFundKey,
    s.SourceName,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pb.GlAccountKey END
'')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LEN(@cmdString)) + '''')

PRINT @cmdString
EXEC (@cmdString)

----------------------------------------------------------------------------------------------------
-- Get Q1 reforecast information
SET @cmdString = (Select ''	

INSERT INTO #ExpenseCzarTotalComparisonDetail
SELECT 
	gac.GlAccountCategoryKey,
    pr.FunctionalDepartmentKey,
    pr.AllocationRegionKey,
    pr.PropertyFundKey,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    '''''''' as PropertyFundCode,
    '''''''' as OriginatingRegionCode,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END,
	'''''''' as CalendarPeriod,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecastQ1,
	NULL as MtdGrossReforecastQ2,
	NULL as MtdGrossReforecastQ3,
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecastQ1,
	NULL as MtdNetReforecastQ2,
	NULL as MtdNetReforecastQ3,
	
	NULL as YtdGrossActual,	
	NULL as YtdGrossBudget, 
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecastQ1,
	NULL as YtdGrossReforecastQ2,
	NULL as YtdGrossReforecastQ3,
	
	NULL as YtdNetActual, 
	NULL as YtdNetBudget, 
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecastQ1,
    NULL as YtdNetReforecastQ2,
    NULL as YtdNetReforecastQ3,
	
	NULL as AnnualGrossBudget, '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ1,
    NULL as AnnualGrossReforecastQ2,
    NULL as AnnualGrossReforecastQ3,

	NULL as AnnualNetBudget, '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecastQ1,
    NULL as AnnualNetReforecastQ2,
    NULL as AnnualNetReforecastQ3,

	NULL as AnnualEstGrossBudget,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstGrossReforecastQ1,
	NULL as AnnualEstGrossReforecastQ2,
	NULL as AnnualEstGrossReforecastQ3,

	NULL as AnnualEstNetBudget,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstNetReforecastQ1,
    NULL as AnnualEstNetReforecastQ2,
    NULL as AnnualEstNetReforecastQ3

FROM
	ProfitabilityReforecast pr

	INNER JOIN Overhead oh ON oh.OverheadKey = pr.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1
		
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid TranslationTypeName'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')	

    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pr.CalendarKey
    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
    INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pr.ReimbursableKey ''
	    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + 
	+ CASE WHEN EXISTS(SELECT * FROM @CategoryActivityGroups) THEN '' INNER JOIN #CategoryActivityGroupFilterTable cag ON cag.GlAccountCategoryKey = gac.GlAccountCategoryKey AND (cag.ActivityTypeKey IS NULL OR cag.ActivityTypeKey = pr.ActivityTypeKey)'' ELSE '''' END + ''

WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND ref.ReforecastEffectivePeriod = '' + STR(@ReforecastEffectivePeriodQ1,10,0) + ''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
GROUP BY
	gac.GlAccountCategoryKey,
    pr.FunctionalDepartmentKey,
    pr.AllocationRegionKey,
    pr.PropertyFundKey,
    s.SourceName,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END

'')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LEN(@cmdString)) + '''')

PRINT @cmdString
EXEC (@cmdString)


----------------------------------------------------------------------------------------------------
-- Get Q2 reforecast information
SET @cmdString = (Select ''	

INSERT INTO #ExpenseCzarTotalComparisonDetail
SELECT 
	gac.GlAccountCategoryKey,
    pr.FunctionalDepartmentKey,
    pr.AllocationRegionKey,
    pr.PropertyFundKey,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    '''''''' as PropertyFundCode,
    '''''''' as OriginatingRegionCode,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END,
	'''''''' as CalendarPeriod,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	NULL as MtdGrossReforecastQ1,
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecastQ2,
	NULL as MtdGrossReforecastQ3,
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
	NULL as MtdNetReforecastQ1,
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecastQ2,
	NULL as MtdNetReforecastQ3,
	
	NULL as YtdGrossActual,	
	NULL as YtdGrossBudget,
	NULL as YtdGrossReforecastQ1,
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecastQ2,
	NULL as YtdGrossReforecastQ3,
	
	NULL as YtdNetActual, 
	NULL as YtdNetBudget,
	NULL as YtdNetReforecastQ1,
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecastQ2,
    NULL as YtdNetReforecastQ3,
	
	NULL as AnnualGrossBudget, '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''
    NULL as AnnualGrossReforecastQ1,
    SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ2,    
    NULL as AnnualGrossReforecastQ3,

	NULL as AnnualNetBudget, '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''
    NULL as AnnualNetReforecastQ1,
    SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecastQ2,
    NULL as AnnualNetReforecastQ3,

	NULL as AnnualEstGrossBudget,
	NULL as AnnualEstGrossReforecastQ1,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstGrossReforecastQ2,
	NULL as AnnualEstGrossReforecastQ3,

	NULL as AnnualEstNetBudget,
	NULL as AnnualEstNetReforecastQ1,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstNetReforecastQ2,
    NULL as AnnualEstNetReforecastQ3

FROM
	ProfitabilityReforecast pr

	INNER JOIN Overhead oh ON oh.OverheadKey = pr.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1
		
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid TranslationTypeName'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')	

    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pr.CalendarKey
    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
    INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pr.ReimbursableKey ''
	    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + 
	+ CASE WHEN EXISTS(SELECT * FROM @CategoryActivityGroups) THEN '' INNER JOIN #CategoryActivityGroupFilterTable cag ON cag.GlAccountCategoryKey = gac.GlAccountCategoryKey AND (cag.ActivityTypeKey IS NULL OR cag.ActivityTypeKey = pr.ActivityTypeKey)'' ELSE '''' END + ''

WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND ref.ReforecastEffectivePeriod = '' + STR(@ReforecastEffectivePeriodQ2,10,0) + ''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
GROUP BY
	gac.GlAccountCategoryKey,
    pr.FunctionalDepartmentKey,
    pr.AllocationRegionKey,
    pr.PropertyFundKey,
    s.SourceName,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END 
'')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LEN(@cmdString)) + '''')

PRINT @cmdString
EXEC (@cmdString)


----------------------------------------------------------------------------------------------------
-- Get Q3 reforecast information
SET @cmdString = (Select ''	

INSERT INTO #ExpenseCzarTotalComparisonDetail
SELECT 
	gac.GlAccountCategoryKey,
    pr.FunctionalDepartmentKey,
    pr.AllocationRegionKey,
    pr.PropertyFundKey,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    '''''''' as PropertyFundCode,
    '''''''' as OriginatingRegionCode,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END,
    '''''''' as CalendarPeriod,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	NULL as MtdGrossReforecastQ1,
	NULL as MtdGrossReforecastQ2,
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecastQ3,
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
	NULL as MtdNetReforecastQ1,
	NULL as MtdNetReforecastQ2,
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecastQ3,
	
	NULL as YtdGrossActual,	
	NULL as YtdGrossBudget,
	NULL as YtdGrossReforecastQ1,
	NULL as YtdGrossReforecastQ2,
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecastQ3,
	
	NULL as YtdNetActual, 
	NULL as YtdNetBudget,
	NULL as YtdNetReforecastQ1,
	NULL as YtdNetReforecastQ2,
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecastQ3,
	
	NULL as AnnualGrossBudget, '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''
    NULL as AnnualGrossReforecastQ1,
    NULL as AnnualGrossReforecastQ2,
    SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ3,

	NULL as AnnualNetBudget, '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''
    NULL as AnnualNetReforecastQ1,
    NULL as AnnualNetReforecastQ2,
    SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecastQ3,

	NULL as AnnualEstGrossBudget,
	NULL as AnnualEstGrossReforecastQ1,
	NULL as AnnualEstGrossReforecastQ2,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstGrossReforecastQ3,

	NULL as AnnualEstNetBudget,
	NULL as AnnualEstNetReforecastQ1,
	NULL as AnnualEstNetReforecastQ2,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstNetReforecastQ3

FROM
	ProfitabilityReforecast pr

	INNER JOIN Overhead oh ON oh.OverheadKey = pr.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1
		
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
		WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
		WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
		WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
		WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
		WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
		WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
		WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
		WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
		ELSE ''break:not valid TranslationTypeName'' END + ''
		AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')	

    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pr.CalendarKey
    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
    INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pr.ReimbursableKey ''
	    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + 
	+ CASE WHEN EXISTS(SELECT * FROM @CategoryActivityGroups) THEN '' INNER JOIN #CategoryActivityGroupFilterTable cag ON cag.GlAccountCategoryKey = gac.GlAccountCategoryKey AND (cag.ActivityTypeKey IS NULL OR cag.ActivityTypeKey = pr.ActivityTypeKey)'' ELSE '''' END + ''

WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND ref.ReforecastEffectivePeriod = '' + STR(@ReforecastEffectivePeriodQ3,10,0) + ''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
GROUP BY
	gac.GlAccountCategoryKey,
    pr.FunctionalDepartmentKey,
    pr.AllocationRegionKey,
    pr.PropertyFundKey,
    s.SourceName,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END 
'')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LEN(@cmdString)) + '''')

PRINT @cmdString
EXEC (@cmdString)

------------------------------------------------------------------------------------------------------------------------------------

CREATE CLUSTERED INDEX IX ON #ExpenseCzarTotalComparisonDetail(
	PropertyFundKey,
	AllocationRegionKey,
	FunctionalDepartmentKey,
	GlAccountCategoryKey
)

SELECT 
	gac.AccountSubTypeName AS ExpenseType,
	gac.MajorCategoryName AS MajorExpenseCategoryName,
    gac.MinorCategoryName AS MinorExpenseCategoryName,    
    fd.FunctionalDepartmentName AS FunctionalDepartmentName,
    fd.FunctionalDepartmentName AS FunctionalDepartmentFilterName,
    ar.SubRegionName AS AllocationSubRegionName,
    ar.SubRegionName AS AllocationSubRegionFilterName,
    pf.PropertyFundName AS EntityName,
    res.CalendarPeriod AS ActualsExpensePeriod,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
    res.SourceName AS SourceName,
    res.PropertyFundCode,
    res.OriginatingRegionCode,
    ISNULL(ga.Code, '''') GlAccountCode,
    ISNULL(ga.Name, '''') GlAccountName,    

	--Month to date    
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossActual,0) ELSE ISNULL(MtdNetActual,0) END) AS MtdActual,
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossBudget,0) ELSE ISNULL(MtdNetBudget,0) END) AS MtdOriginalBudget,
	
	-------------------------------
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ1 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ1
		END,0) 
	END) 
	AS MtdReforecastQ1,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ2
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ2
		END,0) 
	END) 
	AS MtdReforecastQ2,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ3
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ3
		END,0) 
	END) 
	AS MtdReforecastQ3,
	-------------------------------
	
	-------------------------------
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ1
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ1
		END, 0) - ISNULL(MtdNetActual, 0) 
	END) 
	AS MtdVarianceQ1,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ2
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ2
		END, 0) - ISNULL(MtdNetActual, 0) 
	END) 
	AS MtdVarianceQ2,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ3
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ3
		END, 0) - ISNULL(MtdNetActual, 0) 
	END) 
	AS MtdVarianceQ3,
	-------------------------------
	
	--Year to date
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossActual,0) ELSE ISNULL(YtdNetActual,0) END) AS YtdActual,	
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossBudget,0) ELSE ISNULL(YtdNetBudget,0) END) AS YtdOriginalBudget,
	
	-------------------------------
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ1
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ1
		END,0) 
	END) 
	AS YtdReforecastQ1,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ2
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ2
		END,0) 
	END) 
	AS YtdReforecastQ2,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ3
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ3
		END,0) 
	END) 
	AS YtdReforecastQ3,
	-------------------------------
	
	-------------------------------
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget
		ELSE 
			YtdGrossReforecastQ1
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget
		ELSE 
			YtdNetReforecastQ1
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) 
	AS YtdVarianceQ1,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget
		ELSE 
			YtdGrossReforecastQ2
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget
		ELSE 
			YtdNetReforecastQ2
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) 
	AS YtdVarianceQ2,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget
		ELSE 
			YtdGrossReforecastQ3
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget
		ELSE 
			YtdNetReforecastQ3
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) 
	AS YtdVarianceQ3,	
	-------------------------------
	
	--Annual
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(AnnualGrossBudget,0) ELSE ISNULL(AnnualNetBudget,0) END) AS AnnualOriginalBudget,	

	-------------------------------
	SUM(CASE WHEN (@IsGross = 1) THEN
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN
			AnnualGrossBudget
		ELSE
			AnnualGrossReforecastQ1
		END,0)
	ELSE
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN
			AnnualNetBudget
		ELSE
			AnnualNetReforecastQ1
		END,0)
	END)
	AS AnnualReforecastQ1,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN
			AnnualGrossBudget
		ELSE
			AnnualGrossReforecastQ2
		END,0)
	ELSE
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN
			AnnualNetBudget
		ELSE
			AnnualNetReforecastQ2
		END,0)
	END)
	AS AnnualReforecastQ2,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN
			AnnualGrossBudget
		ELSE
			AnnualGrossReforecastQ3
		END,0)
	ELSE
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN
			AnnualNetBudget
		ELSE
			AnnualNetReforecastQ3
		END,0)
	END)
	AS AnnualReforecastQ3
	-------------------------------
INTO
	#Output	
FROM
	#ExpenseCzarTotalComparisonDetail res
	INNER JOIN PropertyFund pf ON pf.PropertyFundKey = res.PropertyFundKey
	INNER JOIN AllocationRegion ar ON ar.AllocationRegionKey = res.AllocationRegionKey
	INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentKey = res.FunctionalDepartmentKey
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = res.GlAccountCategoryKey 
	LEFT OUTER JOIN GlAccount ga ON ga.GlAccountKey = res.GlAccountKey 
GROUP BY
	gac.AccountSubTypeName,
	gac.MajorCategoryName,
    gac.MinorCategoryName,
    fd.FunctionalDepartmentName,
    ar.SubRegionName,
    pf.PropertyFundName,
    res.CalendarPeriod,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
    res.SourceName,
    res.PropertyFundCode,
    res.OriginatingRegionCode,
    ISNULL(ga.Code, ''''),
    ISNULL(ga.Name, '''')
	
--Output
SELECT
	ExpenseType,
	MajorExpenseCategoryName,
    MinorExpenseCategoryName,
    FunctionalDepartmentName,
    FunctionalDepartmentFilterName,
    AllocationSubRegionName,
    AllocationSubRegionFilterName,
    EntityName,
    ActualsExpensePeriod,
    EntryDate,
    [User],
    [Description],
    AdditionalDescription,
    SourceName,
    PropertyFundCode,
    OriginatingRegionCode,
    GlAccountCode,
    GlAccountName,    
    
	--Month to date    
	MtdActual,
	MtdOriginalBudget,
	--MtdReforecastQ1,
	--MtdReforecastQ2,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE MtdReforecastQ3 END AS MtdReforecastQ3,
	--MtdVarianceQ1,
	--MtdVarianceQ2,
	MtdVarianceQ3,
	
	--Year to date
	YtdActual,	
	YtdOriginalBudget,
	--YtdReforecastQ1,
	--YtdReforecastQ2,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE YtdReforecastQ3 END AS YtdReforecastQ3,
	--YtdVarianceQ1,
	--YtdVarianceQ2,
	YtdVarianceQ3,
	
	--Annual
	AnnualOriginalBudget,	
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE AnnualReforecastQ1 END AS AnnualReforecastQ1,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE AnnualReforecastQ2 END AS AnnualReforecastQ2,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE AnnualReforecastQ3 END AS AnnualReforecastQ3
FROM
	#Output
WHERE
	--Month to date    
	MtdActual <> 0.00 OR
	MtdOriginalBudget <> 0.00 OR
	--MtdReforecastQ1 <> 0.00 OR
	--MtdReforecastQ2 <> 0.00 OR
	--MtdReforecastQ3 <> 0.00 OR
	--MtdVarianceQ1 <> 0.00 OR
	--MtdVarianceQ2 <> 0.00 OR
	MtdVarianceQ3 <> 0.00 OR
	
	--Year to date
	YtdActual <> 0.00 OR
	YtdOriginalBudget <> 0.00 OR
	--YtdReforecastQ1 <> 0.00 OR
	--YtdReforecastQ2 <> 0.00 OR
	--YtdReforecastQ3 <> 0.00 OR
	--YtdVarianceQ1 <> 0.00 OR
	--YtdVarianceQ2 <> 0.00 OR
	YtdVarianceQ3 <> 0.00 OR
	
	--Annual
	AnnualOriginalBudget <> 0.00
	--AnnualReforecastQ1 <> 0.00 OR
	--AnnualReforecastQ2 <> 0.00 OR
	--AnnualReforecastQ3 <> 0.00

IF 	OBJECT_ID(''tempdb..#ExpenseCzarTotalComparisonDetail'') IS NOT NULL
    DROP TABLE #ExpenseCzarTotalComparisonDetail

IF 	OBJECT_ID(''tempdb..#Output'') IS NOT NULL
    DROP TABLE #Output

IF 	OBJECT_ID(''tempdb..#EntityFilterTable'') IS NOT NULL
	DROP TABLE #EntityFilterTable
	
IF 	OBJECT_ID(''tempdb..#FunctionalDepartmentFilterTable'') IS NOT NULL
	DROP TABLE #FunctionalDepartmentFilterTable
	
IF 	OBJECT_ID(''tempdb..#ActivityTypeFilterTable'') IS NOT NULL
	DROP TABLE #ActivityTypeFilterTable
	
IF 	OBJECT_ID(''tempdb..#AllocationRegionFilterTable'') IS NOT NULL
	DROP TABLE #AllocationRegionFilterTable
	
IF 	OBJECT_ID(''tempdb..#AllocationSubRegionFilterTable'') IS NOT NULL
	DROP TABLE #AllocationSubRegionFilterTable
	
IF 	OBJECT_ID(''tempdb..#MajorAccountCategoryFilterTable'') IS NOT NULL
	DROP TABLE #MajorAccountCategoryFilterTable
	
IF 	OBJECT_ID(''tempdb..#MinorAccountCategoryFilterTable'') IS NOT NULL
	DROP TABLE #MinorAccountCategoryFilterTable
	
IF 	OBJECT_ID(''tempdb..#OriginatingRegionFilterTable'') IS NOT NULL
	DROP TABLE #OriginatingRegionFilterTable
	
IF 	OBJECT_ID(''tempdb..#OriginatingSubRegionFilterTable'') IS NOT NULL
	DROP TABLE #OriginatingSubRegionFilterTable
	
IF 	OBJECT_ID(''tempdb..#CategoryActivityGroupFilterTable'') IS NOT NULL
	DROP TABLE #CategoryActivityGroupFilterTable

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzarTotalComparison]    Script Date: 01/25/2011 14:18:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzarTotalComparison]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_R_ExpenseCzarTotalComparison]
	@ReportExpensePeriod INT = NULL,
	@ReforecastQuaterName VARCHAR(10) = NULL, --''Q1'' or ''Q2'' or ''Q3''
	@DestinationCurrency VARCHAR(3) = NULL,
	@TranslationTypeName VARCHAR(50) = ''Global'',
	@IsGross bit = 1,
	@FunctionalDepartmentList TEXT = NULL,
	@ActivityTypeList TEXT = NULL,
	@EntityList TEXT = NULL,
	@MajorAccountCategoryList TEXT = NULL,
	@MinorAccountCategoryList TEXT = NULL,
	@AllocationRegionList TEXT = NULL,
	@AllocationSubRegionList TEXT = NULL,
	@OriginatingRegionList TEXT = NULL,
	@OriginatingSubRegionList TEXT = NULL,
	@CategoryActivityGroups dbo.CategoryActivityGroup READONLY,
	@OverheadCode Varchar(10)=''UNALLOC''
AS
 
/*
DECLARE @ReportExpensePeriod   INT,
    @DestinationCurrency   VARCHAR(3),
    @MajorGlAccountCategoryList VARCHAR(8000),
    @TranslationTypeName         VARCHAR(50)

	SET @ReportExpensePeriod = 201002
	SET @DestinationCurrency = ''USD''
	SET @MajorGlAccountCategoryList = ''Salaries/Taxes/Benefits,Occupancy Costs''
	SET @TranslationTypeName = ''Global''
*/ 
/*
EXEC stp_R_ExpenseCzarTotalComparison
	@ReportExpensePeriod = 201011,
	@TranslationTypeName = ''Global'',
	@DestinationCurrency = ''USD'',

	@FunctionalDepartmentList = ''Information Technologies'',
	@AllocationRegionList = ''CHICAGO'',
	@EntityList = ''Aldgate|Centrium (St Cathrine House/Pegasus)''
*/

DECLARE
	@_ReportExpensePeriod INT = @ReportExpensePeriod,
	@_DestinationCurrency VARCHAR(3) = @DestinationCurrency,
	@_TranslationTypeName VARCHAR(50) = @TranslationTypeName,
	@_IsGross bit = @IsGross,
	@_FunctionalDepartmentList VARCHAR(8000) = @FunctionalDepartmentList,
	@_ActivityTypeList VARCHAR(8000) = @ActivityTypeList,
	@_EntityList VARCHAR(8000) = @EntityList,
	@_MajorAccountCategoryList VARCHAR(8000) = @MajorAccountCategoryList,
	@_MinorAccountCategoryList VARCHAR(8000) = @MinorAccountCategoryList,
	@_AllocationRegionList VARCHAR(8000) = @AllocationRegionList,
	@_AllocationSubRegionList VARCHAR(8000) = @AllocationSubRegionList,
	@_OriginatingRegionList VARCHAR(8000) = @OriginatingRegionList,
	@_OriginatingSubRegionList VARCHAR(8000) = @OriginatingSubRegionList

IF LEN(@_FunctionalDepartmentList) > 7998 OR
	LEN(@_ActivityTypeList) > 7998 OR
	LEN(@_EntityList) > 7998 OR
	LEN(@_MajorAccountCategoryList) > 7998 OR
	LEN(@_MinorAccountCategoryList) > 7998 OR
	LEN(@_AllocationRegionList) > 7998 OR
	LEN(@_AllocationSubRegionList) > 7998 OR
	LEN(@_OriginatingRegionList) > 7998 OR
	LEN(@_OriginatingSubRegionList) > 7998
BEGIN
	RAISERROR(''Filter List parameter is too big'',9,1)
END

--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Variable defaults		*/
--------------------------------------------------------------------------

IF @ReportExpensePeriod IS NULL
	SET @ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + CAST(MONTH(GETDATE()) AS VARCHAR(2))AS INT)

IF @DestinationCurrency IS NULL
	SET @DestinationCurrency = ''USD''

IF 	@TranslationTypeName IS NULL
	SET @TranslationTypeName = ''Global''

	DECLARE @CalendarYear AS INT
	SET @CalendarYear = CAST(SUBSTRING(CAST(@ReportExpensePeriod AS VARCHAR(10)), 1, 4) AS INT)		
	
-- let latest reforecast (it will be zero if there is no data for the reforecast)
IF @ReforecastQuaterName IS NULL OR @ReforecastQuaterName NOT IN (''Q0'', ''Q1'', ''Q2'', ''Q3'')
	SET @ReforecastQuaterName = (SELECT TOP 1 ReforecastQuarterName 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
										  ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
									ORDER BY ReforecastEffectivePeriod DESC)

-- Compute Reforecast Effective Periods

DECLARE @ReforecastEffectivePeriodQ1 INT
DECLARE @ReforecastEffectivePeriodQ2 INT
DECLARE @ReforecastEffectivePeriodQ3 INT

SET @ReforecastEffectivePeriodQ1 = (SELECT TOP 1
										ReforecastEffectivePeriod 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										ReforecastQuarterName = ''Q1''
									ORDER BY
										ReforecastEffectivePeriod)								

SET @ReforecastEffectivePeriodQ2 = (SELECT TOP 1
										ReforecastEffectivePeriod 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										ReforecastQuarterName = ''Q2''
									ORDER BY
										ReforecastEffectivePeriod)								

SET @ReforecastEffectivePeriodQ3 = (SELECT TOP 1
										ReforecastEffectivePeriod 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										ReforecastQuarterName = ''Q3''
									ORDER BY
										ReforecastEffectivePeriod)

-- Retrieve Reforecast Quarter Name

DECLARE @ReforecastQuarterNameQ1 CHAR(2)
DECLARE @ReforecastQuarterNameQ2 CHAR(2)
DECLARE @ReforecastQuarterNameQ3 CHAR(2)

IF (@ReforecastEffectivePeriodQ1 IS NOT NULL)
BEGIN
	SET @ReforecastQuarterNameQ1 = (SELECT TOP 1
										ReforecastQuarterName 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectivePeriod = @ReforecastEffectivePeriodQ1)
END
ELSE
BEGIN
	PRINT (''@ReforecastEffectivePeriodQ1 is NULL - cannot determine Q1 reforecast quarter name.'')
END


IF (@ReforecastEffectivePeriodQ2 IS NOT NULL)
BEGIN
	SET @ReforecastQuarterNameQ2 = (SELECT TOP 1
											ReforecastQuarterName 
										FROM
											dbo.Reforecast 
										WHERE
											ReforecastEffectivePeriod = @ReforecastEffectivePeriodQ2)
END
ELSE
BEGIN
	PRINT (''@ReforecastEffectivePeriodQ2 is NULL - cannot determine Q2 reforecast quarter name.'')
END


IF (@ReforecastEffectivePeriodQ3 IS NOT NULL)
BEGIN
	SET @ReforecastQuarterNameQ3 = (SELECT TOP 1
											ReforecastQuarterName 
										FROM
											dbo.Reforecast 
										WHERE
											ReforecastEffectivePeriod = @ReforecastEffectivePeriodQ3)
END
ELSE
BEGIN
	PRINT (''@ReforecastEffectivePeriodQ3 is NULL - cannot determine Q3 reforecast quarter name.'')
END
											
--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Tables		*/
--------------------------------------------------------------------------
	
CREATE TABLE #EntityFilterTable	(PropertyFundKey Int NOT NULL)
CREATE TABLE #FunctionalDepartmentFilterTable (FunctionalDepartmentKey Int NOT NULL)
CREATE TABLE #ActivityTypeFilterTable (ActivityTypeKey Int NOT NULL)
CREATE TABLE #AllocationRegionFilterTable (AllocationRegionKey Int NOT NULL)
CREATE TABLE #AllocationSubRegionFilterTable (AllocationRegionKey Int NOT NULL)
CREATE TABLE #MajorAccountCategoryFilterTable (GlAccountCategoryKey Int NOT NULL)	
CREATE TABLE #MinorAccountCategoryFilterTable (GlAccountCategoryKey Int NOT NULL)	
CREATE TABLE #OriginatingRegionFilterTable (OriginatingRegionKey Int NOT NULL)
CREATE TABLE #OriginatingSubRegionFilterTable (OriginatingRegionKey Int NOT NULL)	
CREATE TABLE #CategoryActivityGroupFilterTable (GlAccountCategoryKey Int NOT NULL, ActivityTypeKey Int NULL)	
	
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable	(PropertyFundKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable(ActivityTypeKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationRegionFilterTable	(AllocationRegionKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MajorAccountCategoryFilterTable(GlAccountCategoryKey)	
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MinorAccountCategoryFilterTable(GlAccountCategoryKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingRegionFilterTable	(OriginatingRegionKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable	(OriginatingRegionKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #CategoryActivityGroupFilterTable	(GlAccountCategoryKey, ActivityTypeKey)
	
IF (@EntityList IS NOT NULL)
	BEGIN
	Insert Into #EntityFilterTable
	Select pf.PropertyFundKey
	From dbo.Split(@_EntityList) t1
		INNER JOIN PropertyFund pf ON pf.PropertyFundName = t1.item
	
	END
	
IF (@FunctionalDepartmentList IS NOT NULL)
	BEGIN
	Insert Into #FunctionalDepartmentFilterTable
	Select fd.FunctionalDepartmentKey 
	From dbo.Split(@_FunctionalDepartmentList) t1
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentName = t1.item
	END

IF 	(@ActivityTypeList IS NOT NULL)
	BEGIN
    INSERT INTO #ActivityTypeFilterTable
    SELECT at.ActivityTypeKey 
    FROM dbo.Split(@_ActivityTypeList) t1
		INNER JOIN ActivityType at ON at.ActivityTypeName = t1.item
	END
	
IF (@AllocationRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationRegionFilterTable
	Select ar.AllocationRegionKey 
	From dbo.Split(@_AllocationRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.RegionName = t1.item
	END

IF (@AllocationSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationSubRegionFilterTable
	Select ar.AllocationRegionKey
	From dbo.Split(@_AllocationSubRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.SubRegionName = t1.item
	END

IF (@MajorAccountCategoryList IS NOT NULL)
	BEGIN
	Insert Into #MajorAccountCategoryFilterTable
	Select gl.GlAccountCategoryKey 
	From dbo.Split(@_MajorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MajorCategoryName = t1.item
	END
	
IF 	(@MinorAccountCategoryList IS NOT NULL)
	BEGIN
    INSERT INTO #MinorAccountCategoryFilterTable
    SELECT gl.GlAccountCategoryKey 
    FROM dbo.Split(@MinorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MinorCategoryName = t1.item
	END	

IF (@OriginatingRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingRegionFilterTable
	Select orr.OriginatingRegionKey 
	From dbo.Split(@_OriginatingRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.RegionName = t1.item
	END

IF (@OriginatingSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingSubRegionFilterTable
	Select orr.OriginatingRegionKey  
	From dbo.Split(@OriginatingSubRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.SubRegionName = t1.item
	END	
	
IF EXISTS(SELECT * FROM @CategoryActivityGroups)
	BEGIN
	Insert Into #CategoryActivityGroupFilterTable
	Select gl.GlAccountCategoryKey, at.ActivityTypeKey 
	From @CategoryActivityGroups cag
		CROSS APPLY dbo.Split(cag.MinorAccountCategoryList) t1
		OUTER APPLY dbo.Split(cag.ActivityTypeList) t2
		INNER JOIN GlAccountCategory gl ON gl.MinorCategoryName = t1.item 
		LEFT OUTER JOIN ActivityType at ON at.ActivityTypeName = t2.item
	END	
--------------------------------------------------------------------------
/*	COMMON END															*/
--------------------------------------------------------------------------
 
 -- Combine budget and actual values
IF OBJECT_ID(''tempdb..#TotalComparison'') IS NOT NULL
    DROP TABLE #TotalComparison

CREATE TABLE #TotalComparison
(	
	AccountSubTypeName      VARCHAR(50),
	TranslationTypeName     VARCHAR(50),
	MajorCategoryName       VARCHAR(100),
	MinorCategoryName       VARCHAR(100),
	CalendarPeriod          INT,
	SourceName				VARCHAR(50),
	EntryDate				VARCHAR(10),
	[User]					NVARCHAR(20),
	[Description]			NVARCHAR(60),
	AdditionalDescription	NVARCHAR(4000),
	PropertyFundCode		VARCHAR(6) DEFAULT(''''), --Varchar, for this helps to keep reports size smaller
	OriginatingRegionCode	VARCHAR(15) DEFAULT(''''), --Varchar, for this helps to keep reports size smaller
	GlAccountCode			VARCHAR(50),
	GlAccountName			VARCHAR(150),

	--Month to date
	MtdGrossActual           MONEY,
	MtdGrossBudget           MONEY,
	
	MtdGrossReforecastQ1     MONEY,
	MtdGrossReforecastQ2     MONEY,
	MtdGrossReforecastQ3     MONEY,
	
	MtdNetActual			 MONEY,
	MtdNetBudget			 MONEY,
	
	MtdNetReforecastQ1		 MONEY,
	MtdNetReforecastQ2		 MONEY,
	MtdNetReforecastQ3		 MONEY,
	
	--Year to date
	YtdGrossActual           MONEY,
	YtdGrossBudget           MONEY,
	
	YtdGrossReforecastQ1     MONEY,
	YtdGrossReforecastQ2     MONEY,
	YtdGrossReforecastQ3     MONEY,
	
	YtdNetActual			 MONEY,
	YtdNetBudget			 MONEY,
	
	YtdNetReforecastQ1		 MONEY,
	YtdNetReforecastQ2		 MONEY,
	YtdNetReforecastQ3		 MONEY,

	--Annual
	AnnualGrossBudget		 MONEY,
	
	AnnualGrossReforecastQ1	 MONEY,
	AnnualGrossReforecastQ2	 MONEY,
	AnnualGrossReforecastQ3	 MONEY,
	
	AnnualNetBudget			 MONEY,
	
	AnnualNetReforecastQ1	 MONEY,
	AnnualNetReforecastQ2	 MONEY,
	AnnualNetReforecastQ3	 MONEY,

	--Annual estimated
	AnnualEstGrossBudget     MONEY,
	
	AnnualEstGrossReforecastQ1 MONEY,
	AnnualEstGrossReforecastQ2 MONEY,
	AnnualEstGrossReforecastQ3 MONEY,
	
	AnnualEstNetBudget		 MONEY,
	
	AnnualEstNetReforecastQ1 MONEY,
	AnnualEstNetReforecastQ2 MONEY,
	AnnualEstNetReforecastQ3 MONEY
)

DECLARE @cmdString Varchar(8000)

--Get actual information
SET @cmdString = (SELECT ''
INSERT INTO #TotalComparison
SELECT 	
	gac.AccountSubTypeName,
    gac.TranslationTypeName,
    gac.MajorCategoryName,
    gac.MinorCategoryName,
    c.CalendarPeriod,
    s.SourceName,
    CONVERT(varchar(10),ISNULL(pa.EntryDate,''''''''), 101) as EntryDate,
    ISNULL(pa.[User], '''''''') [User],
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.Description ELSE '''''''' END as Description,
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.AdditionalDescription ELSE '''''''' END as AdditionalDescription,
    ISNULL(pa.PropertyFundCode, '''''''') PropertyFundCode,
    ISNULL(pa.OriginatingRegionCode, '''''''') OriginatingRegionCode,
    ga.Code,
	ga.Name,
	
    (
		er.Rate *
		CASE WHEN (c.CalendarPeriod = ''+STR(@ReportExpensePeriod,10,0)+'') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdGrossActual,
	NULL as MtdGrossBudget,
	
	'' + /*-- MtdGrossReforecast --------------------------*/ + ''
	
	(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdGrossReforecastQ1,	
    
	(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdGrossReforecastQ2,
	
	(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdGrossReforecastQ3,
    
    '' + /*-- MtdGrossReforecast End --------------------------*/ + ''
    
    (
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod = ''+STR(@ReportExpensePeriod,10,0)+'') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as MtdNetActual,    
	NULL as MtdNetBudget,
	
	'' + /*-- MtdNetReforecast --------------------------*/ + ''
	
	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod = ''+STR(@ReportExpensePeriod,10,0)+''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdNetReforecastQ1,

	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod = ''+STR(@ReportExpensePeriod,10,0)+''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdNetReforecastQ2,
	
	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod = ''+STR(@ReportExpensePeriod,10,0)+''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdNetReforecastQ3,
	
	'' + /*-- MtdNetReforecast End --------------------------*/ + ''
	
    (
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+'') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdGrossActual,    
    NULL as YtdGrossBudget,
    
    '' + /*-- YtdGrossReforecast --------------------------*/ + ''
    
	(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdGrossReforecastQ1,

	(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdGrossReforecastQ2,

	(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdGrossReforecastQ3,
	
	'' + /*-- YtdGrossReforecast End --------------------------*/ + ''
	  
	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+'') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as YtdNetActual,
	NULL as YtdNetBudget,
   
    '' + /*-- YtdNetReforecast --------------------------*/ + ''
   
	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdNetReforecastQ1,

	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdNetReforecastQ2,

	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdNetReforecastQ3,
	'')
	
	DECLARE @cmdString2 Varchar(8000)
	SET @cmdString2 = (SELECT ''	
	
	'' + /*-- YtdNetReforecast End --------------------------*/ + ''
	
    NULL as AnnualGrossBudget,
    
    '' + /*-- AnnualGrossReforecast --------------------------*/ + ''
    
	(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualGrossReforecastQ1,

	(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualGrossReforecastQ2,
	
	(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualGrossReforecastQ3,

	'' + /*-- AnnualGrossReforecast End --------------------------*/ + ''

	NULL as AnnualNetBudget,
	
	'' + /*-- AnnualNetReforecast --------------------------*/ + ''
	
	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ1,

	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ2,

	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ3,

	'' + /*-- AnnualNetReforecast End --------------------------*/ + ''

	(
        er.Rate *
        CASE WHEN (c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0) + '') THEN 
			pa.LocalActual
        ELSE 
			0
        END
	) as AnnualEstGrossBudget,
	
	'' + /*-- AnnualEstGrossReforecast --------------------------*/ + ''
	
    (
        er.Rate *
        CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecastQ1,

    (
        er.Rate *
        CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecastQ2,

    (
        er.Rate *
        CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecastQ3,
	'')
	
	DECLARE @cmdString3 Varchar(8000)
	SET @cmdString3 = (SELECT ''
	
	'' + /*-- AnnualEstGrossReforecast End --------------------------*/ + ''
		
	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0) + '') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
    
    '' + /*-- AnnualEstGrossReforecast --------------------------*/ + ''
    
	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstNetReforecastQ1,

	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstNetReforecastQ2,

	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstNetReforecastQ3

	'' + /*-- AnnualEstGrossReforecast End --------------------------*/ + ''
	
FROM
	ProfitabilityActual pa

	INNER JOIN Overhead oh ON oh.OverheadKey = pa.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1

	INNER JOIN GlAccount ga on ga.GlAccountKey = pa.GlAccountKey
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pa.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pa.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pa.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pa.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pa.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pa.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pa.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pa.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid TranslationTypeName'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')
			
    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pa.CalendarKey
    INNER JOIN Source s ON s.SourceKey = pa.SourceKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pa.ReimbursableKey ''
		
    + CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pa.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pa.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pa.PropertyFundKey'' ELSE '''' END + 
	+ CASE WHEN EXISTS(SELECT * FROM @CategoryActivityGroups) THEN '' INNER JOIN #CategoryActivityGroupFilterTable cag ON cag.GlAccountCategoryKey = gac.GlAccountCategoryKey AND (cag.ActivityTypeKey IS NULL OR cag.ActivityTypeKey = pa.ActivityTypeKey)'' ELSE '''' END + ''
		
WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select t1.FunctionalDepartmentKey From #FunctionalDepartmentFilterTable t1)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select t1.ActivityTypeKey From #ActivityTypeFilterTable t1)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select t1.PropertyFundKey From #EntityFilterTable t1)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationRegionFilterTable t1)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationSubRegionFilterTable t1)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MajorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MinorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingRegionFilterTable t1)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingSubRegionFilterTable t1)'' END +
''    
'')

IF (LEN(@cmdString) > 7995 OR LEN(@cmdString2) > 7995 OR LEN(@cmdString3) > 7995)
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LTRIM(RTRIM(LEN(@cmdString)))) + '' + '' + STR(LTRIM(RTRIM(LEN(@cmdString2)))) + '' + '' + STR(LTRIM(RTRIM(LEN(@cmdString3)))))

PRINT @cmdString
PRINT @cmdString2
PRINT @cmdString3

EXEC (@cmdString + @cmdString2 + @cmdString3)

--------------------------------------------------------------------------------------------------------
--Get budget information
SET @cmdString = (Select ''
INSERT INTO #TotalComparison
SELECT 
	gac.AccountSubTypeName,
    gac.TranslationTypeName,
    gac.MajorCategoryName,
    gac.MinorCategoryName,
    c.CalendarPeriod,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    '''''''' as PropertyFundCode,
    '''''''' as OriginatingRegionCode,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN '''''''' ELSE ga.Code END,
	CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN '''''''' ELSE ga.Name END,
	
    NULL as MtdGrossActual,    
    (
		er.Rate *
		CASE WHEN (c.CalendarPeriod = ''+STR(@ReportExpensePeriod,10,0)+'') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as MtdGrossBudget,
	
	NULL as MtdGrossReforecastQ1,
	NULL as MtdGrossReforecastQ2,
	NULL as MtdGrossReforecastQ3,
    
    NULL as MtdNetActual,
	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod = ''+STR(@ReportExpensePeriod,10,0)+'') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as MtdNetBudget,
    
	NULL as MtdNetReforecastQ1,
	NULL as MtdNetReforecastQ2,
	NULL as MtdNetReforecastQ3,
    
    NULL as YtdGrossActual,	
	(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+'') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as YtdGrossBudget,
	
	NULL as YtdGrossReforecastQ1,
	NULL as YtdGrossReforecastQ2,
	NULL as YtdGrossReforecastQ3,
	
	NULL as YtdNetActual,	
	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+'') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as YtdNetBudget,
    
	NULL as YtdNetReforecastQ1,
	NULL as YtdNetReforecastQ2,
	NULL as YtdNetReforecastQ3,
	
	(
		er.Rate * pb.LocalBudget
	) as AnnualGrossBudget,
	
	NULL as AnnualGrossReforecastQ1,
	NULL as AnnualGrossReforecastQ2,
	NULL as AnnualGrossReforecastQ3,
	
	(
		er.Rate * r.MultiplicationFactor * pb.LocalBudget
    ) as AnnualNetBudget,
    
	NULL as AnnualNetReforecastQ1,
	NULL as AnnualNetReforecastQ2,
	NULL as AnnualNetReforecastQ3,
	
	(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > ''+STR(@ReportExpensePeriod,10,0)+'') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as AnnualEstGrossBudget,
	
	NULL as AnnualEstGrossReforecastQ1,
	NULL as AnnualEstGrossReforecastQ2,
	NULL as AnnualEstGrossReforecastQ3,
	
    (
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > ''+STR(@ReportExpensePeriod,10,0)+'') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
    
	NULL as AnnualEstNetReforecastQ1,
	NULL as AnnualEstNetReforecastQ2,
	NULL as AnnualEstNetReforecastQ3
    
FROM
	ProfitabilityBudget pb

	INNER JOIN Overhead oh ON oh.OverheadKey = pb.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1

	INNER JOIN GlAccount ga on ga.GlAccountKey = pb.GlAccountKey
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pb.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pb.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pb.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pb.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pb.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pb.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pb.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pb.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid TranslationTypeName'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')
	
    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON c.CalendarKey = pb.CalendarKey
    INNER JOIN Source s ON s.SourceKey = pb.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pb.ReimbursableKey	''
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pb.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey'' ELSE '''' END + 
	+ CASE WHEN EXISTS(SELECT * FROM @CategoryActivityGroups) THEN '' INNER JOIN #CategoryActivityGroupFilterTable cag ON cag.GlAccountCategoryKey = gac.GlAccountCategoryKey AND (cag.ActivityTypeKey IS NULL OR cag.ActivityTypeKey = pb.ActivityTypeKey)'' ELSE '''' END + ''

WHERE  1 = 1  
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''

'')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LEN(@cmdString)) + '''')

PRINT @cmdString
EXEC (@cmdString)

------------------------------------------------------------------------------------------------------------------------------
--Get Q1 reforecast information
SET @cmdString = (Select ''
INSERT INTO #TotalComparison
SELECT 
	gac.AccountSubTypeName,
    gac.TranslationTypeName,
    gac.MajorCategoryName,
    gac.MinorCategoryName,
    c.CalendarPeriod,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    '''''''' as PropertyFundCode,
    '''''''' as OriginatingRegionCode,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN '''''''' ELSE ga.Code END,
	CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN '''''''' ELSE ga.Name END,
	
    NULL as MtdGrossActual,
    NULL as MtdGrossBudget,
    
    '' + /*-- MtdGrossReforecast --------------------------*/ + ''
    
    (
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = ''+STR(@ReportExpensePeriod,10,0)+'') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecastQ1,
	NULL as MtdGrossReforecastQ2,
	NULL as MtdGrossReforecastQ3,
    
    '' + /*-- MtdGrossReforecast End --------------------------*/ + ''
    
    NULL as MtdNetActual,
	NULL as MtdNetBudget,
	
	'' + /*-- MtdNetReforecast --------------------------*/ + ''
	
	(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = ''+STR(@ReportExpensePeriod,10,0)+'') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecastQ1,
    NULL as MtdNetReforecastQ2,
    NULL as MtdNetReforecastQ3,
    
    '' + /*-- MtdNetReforecast End --------------------------*/ + ''
    
    NULL as YtdGrossActual,    
    NULL as YtdGrossBudget,
	
	'' + /*-- YtdGrossReforecast --------------------------*/ + ''
	
	(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+'') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecastQ1,
	NULL as YtdGrossReforecastQ2,
	NULL as YtdGrossReforecastQ3,
	
	'' + /*-- YtdGrossReforecast End --------------------------*/ + ''
	
	NULL as YtdNetActual,
	NULL as YtdNetBudget,
	
	'' + /*-- YtdNetReforecast --------------------------*/ + ''
	
	(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+'') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecastQ1,
    NULL as YtdNetReforecastQ2,
    NULL as YtdNetReforecastQ3,    
   	
   	'' + /*-- YtdNetReforecast End --------------------------*/ + ''
   	
   	NULL as AnnualGrossBudget,'' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''
    
    '' + /*-- AnnualGrossReforecast --------------------------*/ + ''
    
    (er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ1,
     NULL as AnnualGrossReforecastQ2,
     NULL as AnnualGrossReforecastQ3,
	
	'' + /*-- AnnualGrossReforecast End --------------------------*/ + ''
	
	NULL as AnnualNetBudget,'' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''    
    '' + /*-- AnnualNetReforecast --------------------------*/ + ''
    
    (er.Rate * r.MultiplicationFactor * pr.LocalReforecast) as AnnualNetReforecastQ1,
    NULL as AnnualNetReforecastQ2,
    NULL as AnnualNetReforecastQ3,
    
    '' + /*-- AnnualNetReforecast End --------------------------*/ + ''
    
    NULL as AnnualEstGrossBudget,
	
	'' + /*-- AnnualEstGrossReforecast --------------------------*/ + ''
	
	(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' +STR(@ReportExpensePeriod,10,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstGrossReforecastQ1,
    NULL as AnnualEstGrossReforecastQ2,
    NULL as AnnualEstGrossReforecastQ3,
	
	'' + /*-- AnnualEstGrossReforecast End --------------------------*/ + ''
	
	NULL as AnnualEstNetBudget,
	
	'' + /*-- AnnualEstNetReforecast --------------------------*/ + ''
	
	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' +STR(@ReportExpensePeriod,10,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstNetReforecastQ1,
    NULL as AnnualEstNetReforecastQ2,
    NULL as AnnualEstNetReforecastQ3
    
    '' + /*-- AnnualEstNetReforecast End --------------------------*/ + ''
    
FROM
	ProfitabilityReforecast pr

	INNER JOIN Overhead oh ON oh.OverheadKey = pr.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1

	INNER JOIN GlAccount ga on ga.GlAccountKey = pr.GlAccountKey
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid TranslationTypeName'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')
	
    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON c.CalendarKey = pr.CalendarKey
    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
    INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey	''
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + 
	+ CASE WHEN EXISTS(SELECT * FROM @CategoryActivityGroups) THEN '' INNER JOIN #CategoryActivityGroupFilterTable cag ON cag.GlAccountCategoryKey = gac.GlAccountCategoryKey AND (cag.ActivityTypeKey IS NULL OR cag.ActivityTypeKey = pr.ActivityTypeKey)'' ELSE '''' END + ''

WHERE  1 = 1  
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND ref.ReforecastEffectivePeriod = '' + STR(@ReforecastEffectivePeriodQ1,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''

'')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LEN(@cmdString)) + '''')

PRINT @cmdString
EXEC (@cmdString)

------------------------------------------------------------------------------------------------------------------------------
--Get Q2 reforecast information
SET @cmdString = (Select ''
INSERT INTO #TotalComparison
SELECT 
	gac.AccountSubTypeName,
    gac.TranslationTypeName,
    gac.MajorCategoryName,
    gac.MinorCategoryName,
    c.CalendarPeriod,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    '''''''' as PropertyFundCode,
    '''''''' as OriginatingRegionCode,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN '''''''' ELSE ga.Code END,
	CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN '''''''' ELSE ga.Name END,
	
    NULL as MtdGrossActual,
    NULL as MtdGrossBudget,
    
    '' + /*-- MtdGrossReforecast --------------------------*/ + ''
    
    NULL as MtdGrossReforecastQ1,
    (
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = ''+STR(@ReportExpensePeriod,10,0)+'') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecastQ2,
	NULL as MtdGrossReforecastQ3,
    
    '' + /*-- MtdGrossReforecast End --------------------------*/ + ''
    
    NULL as MtdNetActual,
	NULL as MtdNetBudget,
	
	'' + /*-- MtdNetReforecast --------------------------*/ + ''
	
	NULL as MtdNetReforecastQ1,
	(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = ''+STR(@ReportExpensePeriod,10,0)+'') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecastQ2,
    NULL as MtdNetReforecastQ3,
    
    '' + /*-- MtdNetReforecast End --------------------------*/ + ''
    
    NULL as YtdGrossActual,    
    NULL as YtdGrossBudget,
	
	'' + /*-- YtdGrossReforecast --------------------------*/ + ''
	
	NULL as YtdGrossReforecastQ1,
	(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+'') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecastQ2,
	NULL as YtdGrossReforecastQ3,
	
	'' + /*-- YtdGrossReforecast End --------------------------*/ + ''
	
	NULL as YtdNetActual,
	NULL as YtdNetBudget,
	
	'' + /*-- YtdNetReforecast --------------------------*/ + ''
	
	NULL as YtdNetReforecastQ1,
	(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+'') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecastQ2,
    NULL as YtdNetReforecastQ3,   
   	
   	'' + /*-- YtdNetReforecast End --------------------------*/ + ''
   	
   	NULL as AnnualGrossBudget,'' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''
    
    '' + /*-- AnnualGrossReforecast --------------------------*/ + ''
    
    NULL as AnnualGrossReforecastQ1,
    (er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ2,
     NULL as AnnualGrossReforecastQ3,
	
	'' + /*-- AnnualGrossReforecast End --------------------------*/ + ''
	
	NULL as AnnualNetBudget,'' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''    
    '' + /*-- AnnualNetReforecast --------------------------*/ + ''
    
    NULL as AnnualNetReforecastQ1,
    (er.Rate * r.MultiplicationFactor * pr.LocalReforecast) as AnnualNetReforecastQ2,
    NULL as AnnualNetReforecastQ3,
    
    '' + /*-- AnnualNetReforecast End --------------------------*/ + ''
    
    NULL as AnnualEstGrossBudget,
	
	'' + /*-- AnnualEstGrossReforecast --------------------------*/ + ''
	
	NULL as AnnualEstGrossReforecastQ1,
	(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' +STR(@ReportExpensePeriod,10,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstGrossReforecastQ2,
    NULL as AnnualEstGrossReforecastQ3,
	
	'' + /*-- AnnualEstGrossReforecast End --------------------------*/ + ''
	
	NULL as AnnualEstNetBudget,
	
	'' + /*-- AnnualEstNetReforecast --------------------------*/ + ''
	
	NULL as AnnualEstNetReforecastQ1,
	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' +STR(@ReportExpensePeriod,10,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstNetReforecastQ2,
    NULL as AnnualEstNetReforecastQ3
    
    '' + /*-- AnnualEstNetReforecast End --------------------------*/ + ''
    
FROM
	ProfitabilityReforecast pr

	INNER JOIN Overhead oh ON oh.OverheadKey = pr.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1

	INNER JOIN GlAccount ga on ga.GlAccountKey = pr.GlAccountKey
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid TranslationTypeName'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')
	
    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON c.CalendarKey = pr.CalendarKey
    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
    INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey	''
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + 
	+ CASE WHEN EXISTS(SELECT * FROM @CategoryActivityGroups) THEN '' INNER JOIN #CategoryActivityGroupFilterTable cag ON cag.GlAccountCategoryKey = gac.GlAccountCategoryKey AND (cag.ActivityTypeKey IS NULL OR cag.ActivityTypeKey = pr.ActivityTypeKey)'' ELSE '''' END + ''

WHERE  1 = 1  
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND ref.ReforecastEffectivePeriod = '' + STR(@ReforecastEffectivePeriodQ2,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''

'')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LEN(@cmdString)) + '''')

PRINT @cmdString
EXEC (@cmdString)



------------------------------------------------------------------------------------------------------------------------------
--Get Q2 reforecast information
SET @cmdString = (Select ''
INSERT INTO #TotalComparison
SELECT 
	gac.AccountSubTypeName,
    gac.TranslationTypeName,
    gac.MajorCategoryName,
    gac.MinorCategoryName,
    c.CalendarPeriod,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    '''''''' as PropertyFundCode,
    '''''''' as OriginatingRegionCode,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN '''''''' ELSE ga.Code END,
	CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN '''''''' ELSE ga.Name END,
	
    NULL as MtdGrossActual,
    NULL as MtdGrossBudget,
    
    '' + /*-- MtdGrossReforecast --------------------------*/ + ''
    
    NULL as MtdGrossReforecastQ1,
    NULL as MtdGrossReforecastQ2,
    (
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = ''+STR(@ReportExpensePeriod,10,0)+'') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecastQ3,
    
    '' + /*-- MtdGrossReforecast End --------------------------*/ + ''
    
    NULL as MtdNetActual,
	NULL as MtdNetBudget,
	
	'' + /*-- MtdNetReforecast --------------------------*/ + ''
	
	NULL as MtdNetReforecastQ1,
	NULL as MtdNetReforecastQ2,
	(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = ''+STR(@ReportExpensePeriod,10,0)+'') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecastQ3,
    
    '' + /*-- MtdNetReforecast End --------------------------*/ + ''
    
    NULL as YtdGrossActual,    
    NULL as YtdGrossBudget,
	
	'' + /*-- YtdGrossReforecast --------------------------*/ + ''
	
	NULL as YtdGrossReforecastQ1,
	NULL as YtdGrossReforecastQ2,
	(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+'') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecastQ3,
	
	'' + /*-- YtdGrossReforecast End --------------------------*/ + ''
	
	NULL as YtdNetActual,
	NULL as YtdNetBudget,
	
	'' + /*-- YtdNetReforecast --------------------------*/ + ''
	
	NULL as YtdNetReforecastQ1,
	NULL as YtdNetReforecastQ2,
	(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= ''+STR(@ReportExpensePeriod,10,0)+'') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecastQ3,  
   	
   	'' + /*-- YtdNetReforecast End --------------------------*/ + ''
   	
   	NULL as AnnualGrossBudget,'' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''
    
    '' + /*-- AnnualGrossReforecast --------------------------*/ + ''
    
    NULL as AnnualGrossReforecastQ1,
    NULL as AnnualGrossReforecastQ2,
    (er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ3,
    
	'' + /*-- AnnualGrossReforecast End --------------------------*/ + ''
	
	NULL as AnnualNetBudget,'' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''    
    '' + /*-- AnnualNetReforecast --------------------------*/ + ''
    
    NULL as AnnualNetReforecastQ1,
    NULL as AnnualNetReforecastQ2,
    (er.Rate * r.MultiplicationFactor * pr.LocalReforecast) as AnnualNetReforecastQ3,
    
    '' + /*-- AnnualNetReforecast End --------------------------*/ + ''
    
    NULL as AnnualEstGrossBudget,
	
	'' + /*-- AnnualEstGrossReforecast --------------------------*/ + ''
	
	NULL as AnnualEstGrossReforecastQ1,
	NULL as AnnualEstGrossReforecastQ2,
	(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' +STR(@ReportExpensePeriod,10,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstGrossReforecastQ3,
	
	'' + /*-- AnnualEstGrossReforecast End --------------------------*/ + ''
	
	NULL as AnnualEstNetBudget,
	
	'' + /*-- AnnualEstNetReforecast --------------------------*/ + ''
	
	NULL as AnnualEstNetReforecastQ1,
	NULL as AnnualEstNetReforecastQ2,
	(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' +STR(@ReportExpensePeriod,10,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstNetReforecastQ3
    
    '' + /*-- AnnualEstNetReforecast End --------------------------*/ + ''
    
FROM
	ProfitabilityReforecast pr

	INNER JOIN Overhead oh ON oh.OverheadKey = pr.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1

	INNER JOIN GlAccount ga on ga.GlAccountKey = pr.GlAccountKey
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid TranslationTypeName'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')
	
    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON c.CalendarKey = pr.CalendarKey
    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
    INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey	''
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + 
	+ CASE WHEN EXISTS(SELECT * FROM @CategoryActivityGroups) THEN '' INNER JOIN #CategoryActivityGroupFilterTable cag ON cag.GlAccountCategoryKey = gac.GlAccountCategoryKey AND (cag.ActivityTypeKey IS NULL OR cag.ActivityTypeKey = pr.ActivityTypeKey)'' ELSE '''' END + ''

WHERE  1 = 1  
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND ref.ReforecastEffectivePeriod = '' + STR(@ReforecastEffectivePeriodQ3,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''

'')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LEN(@cmdString)) + '''')

PRINT @cmdString
EXEC (@cmdString)



------------------------------------------------------------------------------------------------------------------
-- Return results
SELECT
	AccountSubTypeName AS ExpenseType,
	TranslationTypeName AS AccountCategoryMappingName,
    MajorCategoryName AS MajorAccountCategoryName,
	MajorCategoryName AS MajorAccountCategoryFilterName,
    MinorCategoryName AS MinorAccountCategoryName,
    CalendarPeriod AS ExpensePeriod,
    EntryDate,
    [User],
    [Description],
    AdditionalDescription,
	SourceName AS SourceName,
	PropertyFundCode,
    OriginatingRegionCode,	
    GlAccountCode,
    GlAccountName,
    
	--Month to date
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossActual,0) ELSE ISNULL(MtdNetActual,0) END) AS MtdActual,
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossBudget,0) ELSE ISNULL(MtdNetBudget,0) END) AS MtdOriginalBudget,
	
	-------------------------------
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ1 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ1
		END,0) 
	END) 
	AS MtdReforecastQ1,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ2
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ2
		END,0) 
	END) 
	AS MtdReforecastQ2,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ3
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ3
		END,0) 
	END) 
	AS MtdReforecastQ3,		
	-------------------------------
	
	-------------------------------
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ1
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ1
		END, 0) - ISNULL(MtdNetActual, 0) 
	END) 
	AS MtdVarianceQ1,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ2
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ2
		END, 0) - ISNULL(MtdNetActual, 0) 
	END) 
	AS MtdVarianceQ2,	
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ3
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ3
		END, 0) - ISNULL(MtdNetActual, 0) 
	END) 
	AS MtdVarianceQ3,	
	-------------------------------
	
	-- Year to date
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossActual,0) ELSE ISNULL(YtdNetActual,0) END) AS YtdActual,	
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossBudget,0) ELSE ISNULL(YtdNetBudget,0) END) AS YtdOriginalBudget,
	
	-------------------------------
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ1
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ1
		END,0) 
	END) 
	AS YtdReforecastQ1,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ2
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ2
		END,0) 
	END) 
	AS YtdReforecastQ2,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ3
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ3
		END,0) 
	END) 
	AS YtdReforecastQ3,		
	-------------------------------

	-------------------------------
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ1
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ1 
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) 
	AS YtdVarianceQ1,
	---
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ2
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ2
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) 
	AS YtdVarianceQ2,	
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ3 
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ3 
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) 
	AS YtdVarianceQ3,	
	-------------------------------
	
	--Annual
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(AnnualGrossBudget,0) ELSE ISNULL(AnnualNetBudget,0) END) AS AnnualOriginalBudget,
	
	-------------------------------
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecastQ1
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecastQ1
		END,0) 
	END) 
	AS AnnualReforecastQ1,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecastQ2
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecastQ2
		END,0) 
	END) 
	AS AnnualReforecastQ2,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecastQ3
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecastQ3
		END,0) 
	END) 
	AS AnnualReforecastQ3,
	-------------------------------
	
	--Annual Estimated
	-------------------------------
	SUM(CASE WHEN (@IsGross = 1) THEN
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN
			AnnualEstGrossBudget
		ELSE
			AnnualEstGrossReforecastQ1
		END,0)
	ELSE
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN
			AnnualEstNetBudget
		ELSE
			AnnualEstNetReforecastQ1
		END,0)
	END)
	AS AnnualEstimatedActualQ1,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN
			AnnualEstGrossBudget
		ELSE
			AnnualEstGrossReforecastQ2
		END,0)
	ELSE
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN
			AnnualEstNetBudget
		ELSE
			AnnualEstNetReforecastQ2
		END,0)
	END)
	AS AnnualEstimatedActualQ2,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN
			AnnualEstGrossBudget
		ELSE
			AnnualEstGrossReforecastQ3
		END,0)
	ELSE
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN
			AnnualEstNetBudget
		ELSE
			AnnualEstNetReforecastQ3
		END,0)
	END)
	AS AnnualEstimatedActualQ3,		
	-------------------------------
	
	-------------------------------
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(AnnualGrossBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN
												AnnualEstGrossBudget
											ELSE
												AnnualEstGrossReforecastQ1
											END,0)
		ELSE
			ISNULL(AnnualNetBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN
											AnnualEstNetBudget
										ELSE
											AnnualEstNetReforecastQ1
										END,0)
		END)
	AS AnnualEstimatedVarianceQ1,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(AnnualGrossBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN
												AnnualEstGrossBudget
											ELSE
												AnnualEstGrossReforecastQ2
											END,0)
		ELSE
			ISNULL(AnnualNetBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN
											AnnualEstNetBudget
										ELSE
											AnnualEstNetReforecastQ2
										END,0)
		END)
	AS AnnualEstimatedVarianceQ2,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(AnnualGrossBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN
												AnnualEstGrossBudget
											ELSE
												AnnualEstGrossReforecastQ3
											END,0)
		ELSE
			ISNULL(AnnualNetBudget,0) - ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN
											AnnualEstNetBudget
										ELSE
											AnnualEstNetReforecastQ3
										END,0)
		END)
	AS AnnualEstimatedVarianceQ3		
	-------------------------------
INTO
	#Output
FROM
	#TotalComparison
GROUP BY
	AccountSubTypeName,
	TranslationTypeName,
    MajorCategoryName,
    MinorCategoryName,
    CalendarPeriod,
    EntryDate,
    [User],
    [Description],
    AdditionalDescription,
    SourceName,
    PropertyFundCode,
    OriginatingRegionCode,
	GlAccountCode,
    GlAccountName


--Output
SELECT
	ExpenseType,
	AccountCategoryMappingName,
    MajorAccountCategoryName,
	MajorAccountCategoryFilterName,
    MinorAccountCategoryName,
    ExpensePeriod,
    EntryDate,
    [User],
    [Description],
    AdditionalDescription,
	SourceName,
	PropertyFundCode,
    OriginatingRegionCode,
	GlAccountCode,
	GlAccountName,

	--Month to date
	MtdActual,
	MtdOriginalBudget,
	
	--MtdReforecastQ1,
	--MtdReforecastQ2,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE MtdReforecastQ3 END AS MtdReforecastQ3,
	
	--MtdVarianceQ1,
	--MtdVarianceQ2,
	MtdVarianceQ3,
	
	-- Year to date
	YtdActual,	
	YtdOriginalBudget,
	
	--YtdReforecastQ1,
	--YtdReforecastQ2,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE YtdReforecastQ3 END AS YtdReforecastQ3,
	
	--YtdVarianceQ1,
	--YtdVarianceQ2,
	YtdVarianceQ3,
	
	--Annual
	AnnualOriginalBudget,
	
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE AnnualReforecastQ1 END AS AnnualReforecastQ1,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE AnnualReforecastQ2 END AS AnnualReforecastQ2,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE AnnualReforecastQ3 END AS AnnualReforecastQ3,
		
	--Annual Estimated
	--AnnualEstimatedActualQ1,
	--AnnualEstimatedActualQ2,
	AnnualEstimatedActualQ3,
	
	--AnnualEstimatedVarianceQ1,
	--AnnualEstimatedVarianceQ2,
	AnnualEstimatedVarianceQ3
	
FROM
	#Output
WHERE
	--Month to date
	MtdActual <> 0.00 OR
	MtdOriginalBudget <> 0.00 OR
	
	--MtdReforecastQ1 <> 0.00 OR
	--MtdReforecastQ2 <> 0.00 OR
	--MtdReforecastQ3 <> 0.00 OR
	
	--MtdVarianceQ1 <> 0.00 OR
	--MtdVarianceQ2 <> 0.00 OR
	MtdVarianceQ3 <> 0.00 OR
	
	-- Year to date
	YtdActual <> 0.00 OR
	YtdOriginalBudget <> 0.00 OR
	
	--YtdReforecastQ1 <> 0.00 OR
	--YtdReforecastQ2 <> 0.00 OR
	--YtdReforecastQ3 <> 0.00 OR
	
	--YtdVarianceQ1 <> 0.00 OR
	--YtdVarianceQ2 <> 0.00 OR
	YtdVarianceQ3 <> 0.00 OR
	
	--Annual
	AnnualOriginalBudget <> 0.00 OR
	
	--AnnualReforecastQ1 <> 0.00 OR
	--AnnualReforecastQ2 <> 0.00 OR
	--AnnualReforecastQ3 <> 0.00 OR
	
	--Annual Estimated
	--AnnualEstimatedActualQ1 <> 0.00 OR
	--AnnualEstimatedActualQ2 <> 0.00 OR
	AnnualEstimatedActualQ3 <> 0.00 OR
	
	--AnnualEstimatedVarianceQ1 <> 0.00 OR
	--AnnualEstimatedVarianceQ2 <> 0.00 OR
	AnnualEstimatedVarianceQ3 <> 0.00

IF 	OBJECT_ID(''tempdb..#Output'') IS NOT NULL
    DROP TABLE #Output

IF 	OBJECT_ID(''tempdb..#EntityFilterTable'') IS NOT NULL
	DROP TABLE #EntityFilterTable
	
IF 	OBJECT_ID(''tempdb..#FunctionalDepartmentFilterTable'') IS NOT NULL	
	DROP TABLE #FunctionalDepartmentFilterTable
	
IF 	OBJECT_ID(''tempdb..#ActivityTypeFilterTable'') IS NOT NULL
	DROP TABLE #ActivityTypeFilterTable
	
IF 	OBJECT_ID(''tempdb..#AllocationRegionFilterTable'') IS NOT NULL
	DROP TABLE #AllocationRegionFilterTable
	
IF 	OBJECT_ID(''tempdb..#AllocationSubRegionFilterTable'') IS NOT NULL
	DROP TABLE #AllocationSubRegionFilterTable
	
IF 	OBJECT_ID(''tempdb..#MajorAccountCategoryFilterTable'') IS NOT NULL
	DROP TABLE #MajorAccountCategoryFilterTable
	
IF 	OBJECT_ID(''tempdb..#MinorAccountCategoryFilterTable'') IS NOT NULL
	DROP TABLE #MinorAccountCategoryFilterTable
	
IF 	OBJECT_ID(''tempdb..#OriginatingRegionFilterTable'') IS NOT NULL
	DROP TABLE #OriginatingRegionFilterTable
	
IF 	OBJECT_ID(''tempdb..#OriginatingSubRegionFilterTable'') IS NOT NULL
	DROP TABLE #OriginatingSubRegionFilterTable
	
IF 	OBJECT_ID(''tempdb..#CategoryActivityGroupFilterTable'') IS NOT NULL
	DROP TABLE #CategoryActivityGroupFilterTable

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzar]    Script Date: 01/25/2011 14:18:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzar]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[stp_R_ExpenseCzar]
	@ReportExpensePeriod INT = NULL,
	@ReforecastQuaterName VARCHAR(10) = NULL, --''Q1'' or ''Q2'' or ''Q3''
	@DestinationCurrency VARCHAR(3) = NULL,
	@TranslationTypeName VARCHAR(50) = ''Global'',
	@IsGross bit = 1,
	@FunctionalDepartmentList TEXT = NULL,
	@ActivityTypeList TEXT = NULL,
	@EntityList TEXT = NULL,
	@MajorAccountCategoryList TEXT = NULL,
	@MinorAccountCategoryList TEXT = NULL,
	@AllocationRegionList TEXT = NULL,
	@AllocationSubRegionList TEXT = NULL,
	@OriginatingRegionList TEXT = NULL,
	@OriginatingSubRegionList TEXT = NULL,
	@CategoryActivityGroups dbo.CategoryActivityGroup READONLY,
	@OverheadCode Varchar(10)=''UNALLOC''
AS

/*
DECLARE @ReportExpensePeriod	AS INT,
	@AccountCategoryList	AS TEXT,
	@DestinationCurrency	AS VARCHAR(3),
	@TranslationTypeName	VARCHAR(50)
	
	SET @ReportExpensePeriod = 201011
	SET @AccountCategoryList = ''IT Costs & Telecommunications|Legal & Professional Fees|Marketing''
	SET @DestinationCurrency =''USD''
	SET @TranslationTypeName = ''Global''
	
EXEC stp_R_ExpenseCzar
	@ReportExpensePeriod = 201011,
	@TranslationTypeName = ''Global'',
	@DestinationCurrency = ''USD'',

	@FunctionalDepartmentList = ''Information Technologies'',
	@AllocationRegionList = ''CHICAGO'',
	@EntityList = ''Aldgate|Centrium (St Cathrine House/Pegasus)''
*/

DECLARE
	@_ReportExpensePeriod INT = @ReportExpensePeriod,
	@_ReforecastQuaterName VARCHAR(10) = @ReforecastQuaterName,
	@_DestinationCurrency VARCHAR(3) = @DestinationCurrency,
	@_TranslationTypeName VARCHAR(50) = @TranslationTypeName,
	@_FunctionalDepartmentList VARCHAR(8000) = @FunctionalDepartmentList,
	@_ActivityTypeList VARCHAR(8000) = @ActivityTypeList,
	@_EntityList VARCHAR(8000) = @EntityList,
	@_MajorAccountCategoryList VARCHAR(8000) = @MajorAccountCategoryList,
	@_MinorAccountCategoryList VARCHAR(8000) = @MinorAccountCategoryList,
	@_AllocationRegionList VARCHAR(8000) = @AllocationRegionList,
	@_AllocationSubRegionList VARCHAR(8000) = @AllocationSubRegionList,
	@_OriginatingRegionList VARCHAR(8000) = @OriginatingRegionList,
	@_OriginatingSubRegionList VARCHAR(8000) = @OriginatingSubRegionList

IF LEN(@_FunctionalDepartmentList) > 7998 OR
	LEN(@_ActivityTypeList) > 7998 OR
	LEN(@_EntityList) > 7998 OR
	LEN(@_MajorAccountCategoryList) > 7998 OR
	LEN(@_MinorAccountCategoryList) > 7998 OR
	LEN(@_AllocationRegionList) > 7998 OR
	LEN(@_AllocationSubRegionList) > 7998 OR
	LEN(@_OriginatingRegionList) > 7998 OR
	LEN(@_OriginatingSubRegionList) > 7998
BEGIN
	RAISERROR(''Filter List parameter is too big'',9,1)
END

--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Variable defaults		*/
--------------------------------------------------------------------------

IF @ReportExpensePeriod IS NULL
	SET @ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + CAST(MONTH(GETDATE()) AS VARCHAR(2))AS INT)

IF @DestinationCurrency IS NULL
	SET @DestinationCurrency = ''USD''

IF 	@TranslationTypeName IS NULL
	SET @TranslationTypeName = ''Global''

	DECLARE @CalendarYear AS INT
	SET @CalendarYear = CAST(SUBSTRING(CAST(@ReportExpensePeriod AS VARCHAR(10)), 1, 4) AS INT)		
	
-- let latest reforecast (it will be zero if there is no data for the reforecast)
IF @ReforecastQuaterName IS NULL OR @ReforecastQuaterName NOT IN (''Q0'', ''Q1'', ''Q2'', ''Q3'')
	SET @ReforecastQuaterName = (SELECT TOP 1 ReforecastQuarterName 
									FROM dbo.Reforecast 
									WHERE ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
										  ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
									ORDER BY ReforecastEffectivePeriod DESC)

-- Compute Reforecast Effective Periods

DECLARE @ReforecastEffectivePeriodQ1 INT
DECLARE @ReforecastEffectivePeriodQ2 INT
DECLARE @ReforecastEffectivePeriodQ3 INT

SET @ReforecastEffectivePeriodQ1 = (SELECT TOP 1
										ReforecastEffectivePeriod 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										ReforecastQuarterName = ''Q1''
									ORDER BY
										ReforecastEffectivePeriod)								

SET @ReforecastEffectivePeriodQ2 = (SELECT TOP 1
										ReforecastEffectivePeriod 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										ReforecastQuarterName = ''Q2''
									ORDER BY
										ReforecastEffectivePeriod)								

SET @ReforecastEffectivePeriodQ3 = (SELECT TOP 1
										ReforecastEffectivePeriod 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										ReforecastQuarterName = ''Q3''
									ORDER BY
										ReforecastEffectivePeriod)

-- Retrieve Reforecast Quarter Name

DECLARE @ReforecastQuarterNameQ1 CHAR(2)
DECLARE @ReforecastQuarterNameQ2 CHAR(2)
DECLARE @ReforecastQuarterNameQ3 CHAR(2)

IF (@ReforecastEffectivePeriodQ1 IS NOT NULL)
BEGIN
	SET @ReforecastQuarterNameQ1 = (SELECT TOP 1
										ReforecastQuarterName 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectivePeriod = @ReforecastEffectivePeriodQ1)
END
ELSE
BEGIN
	PRINT (''@ReforecastEffectivePeriodQ1 is NULL - cannot determine Q1 reforecast quarter name.'')
END


IF (@ReforecastEffectivePeriodQ2 IS NOT NULL)
BEGIN
	SET @ReforecastQuarterNameQ2 = (SELECT TOP 1
											ReforecastQuarterName 
										FROM
											dbo.Reforecast 
										WHERE
											ReforecastEffectivePeriod = @ReforecastEffectivePeriodQ2)
END
ELSE
BEGIN
	PRINT (''@ReforecastEffectivePeriodQ2 is NULL - cannot determine Q2 reforecast quarter name.'')
END


IF (@ReforecastEffectivePeriodQ3 IS NOT NULL)
BEGIN
	SET @ReforecastQuarterNameQ3 = (SELECT TOP 1
											ReforecastQuarterName 
										FROM
											dbo.Reforecast 
										WHERE
											ReforecastEffectivePeriod = @ReforecastEffectivePeriodQ3)
END
ELSE
BEGIN
	PRINT (''@ReforecastEffectivePeriodQ3 is NULL - cannot determine Q3 reforecast quarter name.'')
END

--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Tables		*/
--------------------------------------------------------------------------
	
CREATE TABLE #EntityFilterTable	(PropertyFundKey Int NOT NULL)
CREATE TABLE #FunctionalDepartmentFilterTable (FunctionalDepartmentKey Int NOT NULL)
CREATE TABLE #ActivityTypeFilterTable (ActivityTypeKey Int NOT NULL)
CREATE TABLE #AllocationRegionFilterTable (AllocationRegionKey Int NOT NULL)
CREATE TABLE #AllocationSubRegionFilterTable (AllocationRegionKey Int NOT NULL)
CREATE TABLE #MajorAccountCategoryFilterTable (GlAccountCategoryKey Int NOT NULL)	
CREATE TABLE #MinorAccountCategoryFilterTable (GlAccountCategoryKey Int NOT NULL)	
CREATE TABLE #OriginatingRegionFilterTable (OriginatingRegionKey Int NOT NULL)
CREATE TABLE #OriginatingSubRegionFilterTable (OriginatingRegionKey Int NOT NULL)	
CREATE TABLE #CategoryActivityGroupFilterTable (GlAccountCategoryKey Int NOT NULL, ActivityTypeKey Int NULL)	
	
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable (PropertyFundKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable (ActivityTypeKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationRegionFilterTable	(AllocationRegionKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable (AllocationRegionKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MajorAccountCategoryFilterTable (GlAccountCategoryKey)	
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MinorAccountCategoryFilterTable (GlAccountCategoryKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingRegionFilterTable (OriginatingRegionKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable (OriginatingRegionKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #CategoryActivityGroupFilterTable (GlAccountCategoryKey, ActivityTypeKey)
	
IF (@EntityList IS NOT NULL)
	BEGIN
	Insert Into #EntityFilterTable
	Select pf.PropertyFundKey
	From dbo.Split(@_EntityList) t1
		INNER JOIN PropertyFund pf ON pf.PropertyFundName = t1.item
	
	END
	
IF (@FunctionalDepartmentList IS NOT NULL)
	BEGIN
	Insert Into #FunctionalDepartmentFilterTable
	Select fd.FunctionalDepartmentKey 
	From dbo.Split(@_FunctionalDepartmentList) t1
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentName = t1.item
	END

IF 	(@ActivityTypeList IS NOT NULL)
	BEGIN
    INSERT INTO #ActivityTypeFilterTable
    SELECT at.ActivityTypeKey 
    FROM dbo.Split(@_ActivityTypeList) t1
		INNER JOIN ActivityType at ON at.ActivityTypeName = t1.item
	END
	
IF (@AllocationRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationRegionFilterTable
	Select ar.AllocationRegionKey 
	From dbo.Split(@_AllocationRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.RegionName = t1.item
	END

IF (@AllocationSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationSubRegionFilterTable
	Select ar.AllocationRegionKey
	From dbo.Split(@_AllocationSubRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.SubRegionName = t1.item
	END

IF (@MajorAccountCategoryList IS NOT NULL)
	BEGIN
	Insert Into #MajorAccountCategoryFilterTable
	Select gl.GlAccountCategoryKey 
	From dbo.Split(@_MajorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MajorCategoryName = t1.item
	END
	
IF 	(@MinorAccountCategoryList IS NOT NULL)
	BEGIN
    INSERT INTO #MinorAccountCategoryFilterTable
    SELECT gl.GlAccountCategoryKey 
    FROM dbo.Split(@MinorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MinorCategoryName = t1.item
	END	

IF (@OriginatingRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingRegionFilterTable
	Select orr.OriginatingRegionKey 
	From dbo.Split(@_OriginatingRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.RegionName = t1.item
	END

IF (@OriginatingSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingSubRegionFilterTable
	Select orr.OriginatingRegionKey  
	From dbo.Split(@OriginatingSubRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.SubRegionName = t1.item
	END		
	
IF EXISTS(SELECT * FROM @CategoryActivityGroups)
	BEGIN
	Insert Into #CategoryActivityGroupFilterTable
	Select gl.GlAccountCategoryKey, at.ActivityTypeKey 
	From @CategoryActivityGroups cag
		CROSS APPLY dbo.Split(cag.MinorAccountCategoryList) t1
		OUTER APPLY dbo.Split(cag.ActivityTypeList) t2
		INNER JOIN GlAccountCategory gl ON gl.MinorCategoryName = t1.item 
		LEFT OUTER JOIN ActivityType at ON at.ActivityTypeName = t2.item
	END
--------------------------------------------------------------------------
/*	COMMON END															*/
--------------------------------------------------------------------------
		
IF 	OBJECT_ID(''tempdb..#ExpenseCzar'') IS NOT NULL
    DROP TABLE #ExpenseCzar
		
CREATE TABLE #ExpenseCzar
(	
	GlAccountCategoryKey		Int,
	AllocationRegionKey			Int,
	FunctionalDepartmentKey		Int,	
	PropertyFundKey				Int,
	CalendarPeriod				INT,
	SourceName					VarChar(50),
	EntryDate					VARCHAR(10),
	[User]						NVARCHAR(20),
	[Description]				NVARCHAR(60),
	AdditionalDescription		NVARCHAR(4000),
	PropertyFundCode			Varchar(6) DEFAULT(''''), --Varchar, for this helps to keep reports size smaller
	OriginatingRegionCode		Varchar(15) DEFAULT(''''), --Varchar, for this helps to keep reports size smaller
	GlAccountKey				Int  NULL,
	
	--Month to date	
	MtdGrossActual				MONEY,
	MtdGrossBudget				MONEY,
	
	MtdGrossReforecastQ1		MONEY,
	MtdGrossReforecastQ2		MONEY,
	MtdGrossReforecastQ3		MONEY,
	
	MtdNetActual				MONEY,
	MtdNetBudget				MONEY,
	
	MtdNetReforecastQ1			MONEY,
	MtdNetReforecastQ2			MONEY,
	MtdNetReforecastQ3			MONEY,
	
	--Year to date
	YtdGrossActual				MONEY,	
	YtdGrossBudget				MONEY,
	 
	YtdGrossReforecastQ1		MONEY,
	YtdGrossReforecastQ2		MONEY,
	YtdGrossReforecastQ3		MONEY,
	
	YtdNetActual				MONEY, 
	YtdNetBudget				MONEY, 
	
	YtdNetReforecastQ1			MONEY,
	YtdNetReforecastQ2			MONEY,
	YtdNetReforecastQ3			MONEY,

	--Annual	
	AnnualGrossBudget			MONEY,
	
	AnnualGrossReforecastQ1		MONEY,
	AnnualGrossReforecastQ2		MONEY,
	AnnualGrossReforecastQ3		MONEY,
	
	AnnualNetBudget				MONEY,
	
	AnnualNetReforecastQ1		MONEY,
	AnnualNetReforecastQ2		MONEY,
	AnnualNetReforecastQ3		MONEY,
	
	--Annual estimated
	AnnualEstGrossBudget		MONEY,
	
	AnnualEstGrossReforecastQ1	MONEY,
	AnnualEstGrossReforecastQ2	MONEY,
	AnnualEstGrossReforecastQ3	MONEY,
	
	AnnualEstNetBudget			MONEY,
	
	AnnualEstNetReforecastQ1	MONEY,
	AnnualEstNetReforecastQ2	MONEY,
	AnnualEstNetReforecastQ3	MONEY
)

DECLARE @cmdString VARCHAR(8000)

--Get actual information
SET @cmdString = (SELECT ''

INSERT INTO #ExpenseCzar
SELECT 
	gac.GlAccountCategoryKey,
	pa.AllocationRegionKey,
    pa.FunctionalDepartmentKey,    
    pa.PropertyFundKey,
    c.CalendarPeriod,
    s.SourceName,
    CONVERT(varchar(10),ISNULL(pa.EntryDate,''''''''), 101) as EntryDate,
    ISNULL(pa.[User], '''''''') [User],
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.Description ELSE '''''''' END as Description,
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.AdditionalDescription ELSE '''''''' END as AdditionalDescription,
    ISNULL(pa.PropertyFundCode, '''''''') PropertyFundCode,
    ISNULL(pa.OriginatingRegionCode, '''''''') OriginatingRegionCode,
    pa.GlAccountKey,
    
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdGrossActual,
	NULL as MtdGrossBudget,
	
	'' + /*-- MtdGrossReforecast --------------------------*/ + ''
	
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdGrossReforecastQ1,

	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdGrossReforecastQ2,

	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdGrossReforecastQ3,
	
	'' + /*-- MtdGrossReforecast End --------------------------*/ + ''
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdNetActual,
	NULL as MtdNetBudget,
	
	'' + /*-- MtdNetReforecast --------------------------*/ + ''
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdNetReforecastQ1,

	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdNetReforecastQ2,

	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdNetReforecastQ3,
	
	'' + /*-- MtdNetReforecast End --------------------------*/ + ''
	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdGrossActual,
	NULL as YtdGrossBudget,
	
	'')
	
	DECLARE @cmdString2 VARCHAR(8000)
	SET @cmdString2 = (SELECT ''
	
	
	'' + /*-- YtdGrossReforecast --------------------------*/ + ''
	
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdGrossReforecastQ1,

	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdGrossReforecastQ2,

	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdGrossReforecastQ3,

	'' + /*-- YtdGrossReforecast End --------------------------*/ + ''
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdNetActual,
	NULL as YtdNetBudget,
	
	'' + /*-- YtdNetReforecast --------------------------*/ + ''
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdNetReforecastQ1,

	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdNetReforecastQ2,

	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdNetReforecastQ3,
	
	'' + /*-- YtdNetReforecast End --------------------------*/ + ''
	
	NULL as AnnualGrossBudget,
	
	'' + /*-- AnnualGrossReforecast --------------------------*/ + ''
	
	SUM(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualGrossReforecastQ1,

	SUM(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualGrossReforecastQ2,

	SUM(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualGrossReforecastQ3,

	'' + /*-- AnnualGrossReforecast End --------------------------*/ + ''

	NULL as AnnualNetBudget,
	
	'' + /*-- AnnualNetReforecast --------------------------*/ + ''
	
    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ1,

    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ2,

    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ3,
	
	'' + /*-- AnnualNetReforecast End --------------------------*/ + ''
		
	SUM(
        er.Rate *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pa.LocalActual
        ELSE 
			0
        END
	) as AnnualEstGrossBudget,
	
	'' + /*-- AnnualEstGrossReforecast --------------------------*/ + ''
	
	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecastQ1,

	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecastQ2,

	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecastQ3,

	'')
	
	DECLARE @cmdString3 VARCHAR(8000)
	SET @cmdString3 = (SELECT ''


	'' + /*-- AnnualEstGrossReforecast End --------------------------*/ + ''

    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
    
    '' + /*-- AnnualEstNetReforecast End --------------------------*/ + ''
    
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstNetReforecastQ1,

	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstNetReforecastQ2,

	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstNetReforecastQ3
	
	'' + /*-- AnnualEstNetReforecast End --------------------------*/ + ''
FROM
	ProfitabilityActual pa

	INNER JOIN Overhead oh ON oh.OverheadKey = pa.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1

	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pa.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pa.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pa.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pa.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pa.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pa.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pa.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pa.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
	INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
	INNER JOIN Calendar c ON  c.CalendarKey = pa.CalendarKey
	INNER JOIN Source s ON s.SourceKey = pa.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pa.ReimbursableKey ''
    			    
    + CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pa.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pa.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pa.PropertyFundKey'' ELSE '''' END + 
	+ CASE WHEN EXISTS(SELECT * FROM @CategoryActivityGroups) THEN '' INNER JOIN #CategoryActivityGroupFilterTable cag ON cag.GlAccountCategoryKey = gac.GlAccountCategoryKey AND (cag.ActivityTypeKey IS NULL OR cag.ActivityTypeKey = pa.ActivityTypeKey)'' ELSE '''' END + ''
		
WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select t1.FunctionalDepartmentKey From #FunctionalDepartmentFilterTable t1)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select t1.ActivityTypeKey From #ActivityTypeFilterTable t1)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select t1.PropertyFundKey From #EntityFilterTable t1)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationRegionFilterTable t1)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationSubRegionFilterTable t1)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MajorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MinorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingRegionFilterTable t1)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingSubRegionFilterTable t1)'' END +
''	
GROUP BY
	gac.GlAccountCategoryKey,
	pa.AllocationRegionKey,
	pa.FunctionalDepartmentKey,		
	pa.PropertyFundKey,
	c.CalendarPeriod,
	s.SourceName,
	CONVERT(varchar(10),ISNULL(pa.EntryDate,''''''''), 101),
	ISNULL(pa.[User], '''''''') ,
	CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.Description ELSE '''''''' END,
	CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.AdditionalDescription ELSE '''''''' END,
	ISNULL(pa.PropertyFundCode, ''''''''),
	ISNULL(pa.OriginatingRegionCode, ''''''''),
	pa.GlAccountKey
'')

IF (LEN(@cmdString) > 7995 OR LEN(@cmdString2) > 7995 OR LEN(@cmdString3) > 7995)
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LTRIM(RTRIM(LEN(@cmdString)))) + '' + '' + STR(LTRIM(RTRIM(LEN(@cmdString2)))) + '' + '' + STR(LTRIM(RTRIM(LEN(@cmdString3)))))

PRINT @cmdString
PRINT @cmdString2
PRINT @cmdString3

EXEC (@cmdString + @cmdString2 + @cmdString3)

-- Get budget information
SET @cmdString = (Select ''
INSERT INTO #ExpenseCzar
SELECT 
	gac.GlAccountCategoryKey,
	pb.AllocationRegionKey,
	pb.FunctionalDepartmentKey,	
	pb.PropertyFundKey,
	c.CalendarPeriod,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    '''''''' as PropertyFundCode,
    '''''''' as OriginatingRegionCode,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pb.GlAccountKey END,
    
   NULL as MtdGrossActual,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as MtdGrossBudget,	
	NULL as MtdGrossReforecastQ1,
	NULL as MtdGrossReforecastQ2,
	NULL as MtdGrossReforecastQ3,
	
	NULL as MtdNetActual,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as MtdNetBudget,
	NULL as MtdNetReforecastQ1,
	NULL as MtdNetReforecastQ2,
	NULL as MtdNetReforecastQ3,
	
	NULL as YtdGrossActual,	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as YtdGrossBudget, 
	NULL as YtdGrossReforecastQ1,
	NULL as YtdGrossReforecastQ2,
	NULL as YtdGrossReforecastQ3,
	
	NULL as YtdNetActual, 
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as YtdNetBudget, 
	NULL as YtdNetReforecastQ1,
	NULL as YtdNetReforecastQ2,
	NULL as YtdNetReforecastQ3,
	
	SUM(er.Rate * pb.LocalBudget) as AnnualGrossBudget,
	NULL as AnnualGrossReforecastQ1,
	NULL as AnnualGrossReforecastQ2,
	NULL as AnnualGrossReforecastQ3,
	

	SUM(er.Rate * r.MultiplicationFactor * pb.LocalBudget) as AnnualNetBudget,
	NULL as AnnualNetReforecastQ1,
	NULL as AnnualNetReforecastQ2,
	NULL as AnnualNetReforecastQ3,
	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as AnnualEstGrossBudget,
	NULL as AnnualEstGrossReforecastQ1,
	NULL as AnnualEstGrossReforecastQ2,
	NULL as AnnualEstGrossReforecastQ3,

	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
	NULL as AnnualEstNetReforecastQ1,
	NULL as AnnualEstNetReforecastQ2,
	NULL as AnnualEstNetReforecastQ3
FROM
	ProfitabilityBudget pb

	INNER JOIN Overhead oh ON oh.OverheadKey = pb.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1
    
    	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pb.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pb.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pb.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pb.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pb.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pb.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pb.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pb.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON c.CalendarKey = pb.CalendarKey
    INNER JOIN Source s ON s.SourceKey = pb.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pb.ReimbursableKey ''
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pb.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey'' ELSE '''' END + 
	+ CASE WHEN EXISTS(SELECT * FROM @CategoryActivityGroups) THEN '' INNER JOIN #CategoryActivityGroupFilterTable cag ON cag.GlAccountCategoryKey = gac.GlAccountCategoryKey AND (cag.ActivityTypeKey IS NULL OR cag.ActivityTypeKey = pb.ActivityTypeKey)'' ELSE '''' END + ''
		
WHERE  1 = 1 
    AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''    
GROUP BY
	gac.GlAccountCategoryKey,
	pb.AllocationRegionKey,
	pb.FunctionalDepartmentKey,
	pb.PropertyFundKey,
	c.CalendarPeriod,
	s.SourceName,
	CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pb.GlAccountKey END
'')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LEN(@cmdString)) + '''')

PRINT @cmdString
EXEC (@cmdString)

----------------------------------------------------------------------------------------------------------------------------------
-- Get Q1 reforecast information
SET @cmdString = (SELECT ''
INSERT INTO #ExpenseCzar
SELECT 
	gac.GlAccountCategoryKey,
	pr.AllocationRegionKey,
	pr.FunctionalDepartmentKey,	
	pr.PropertyFundKey,
	c.CalendarPeriod,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    '''''''' as PropertyFundCode,
    '''''''' as OriginatingRegionCode,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecastQ1,
	NULL as MtdGrossReforecastQ2,
	NULL as MtdGrossReforecastQ3,
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecastQ1,
	NULL as MtdNetReforecastQ2,
	NULL as MtdNetReforecastQ3,
	
	NULL as YtdGrossActual,	
	NULL as YtdGrossBudget, 
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecastQ1,
	NULL as YtdGrossReforecastQ2,
	NULL as YtdGrossReforecastQ3,
	
	NULL as YtdNetActual, 
	NULL as YtdNetBudget, 
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecastQ1,
    NULL as YtdNetReforecastQ2,
    NULL as YtdNetReforecastQ3,
	
	NULL as AnnualGrossBudget, '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ1,
    NULL as AnnualGrossReforecastQ2,
	NULL as AnnualGrossReforecastQ3,

	NULL as AnnualNetBudget, '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast) as AnnualNetReforecastQ1,
    NULL as AnnualNetReforecastQ2,
    NULL as AnnualNetReforecastQ3,

	NULL as AnnualEstGrossBudget,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstGrossReforecastQ1,
    NULL as AnnualEstGrossReforecastQ2,
    NULL as AnnualEstGrossReforecastQ3,

	NULL as AnnualEstNetBudget,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE
			0
        END
    ) as AnnualEstNetReforecastQ1,
    NULL as AnnualEstNetReforecastQ2,
    NULL as AnnualEstNetReforecastQ3
    
FROM
	ProfitabilityReforecast pr

	INNER JOIN Overhead oh ON oh.OverheadKey = pr.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1
    
    	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON c.CalendarKey = pr.CalendarKey
    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
    INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey ''
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + 
	+ CASE WHEN EXISTS(SELECT * FROM @CategoryActivityGroups) THEN '' INNER JOIN #CategoryActivityGroupFilterTable cag ON cag.GlAccountCategoryKey = gac.GlAccountCategoryKey AND (cag.ActivityTypeKey IS NULL OR cag.ActivityTypeKey = pr.ActivityTypeKey)'' ELSE '''' END + ''
		
WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND ref.ReforecastEffectivePeriod = '' + STR(@ReforecastEffectivePeriodQ1,10,0) + ''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''    
GROUP BY
	gac.GlAccountCategoryKey,
	pr.AllocationRegionKey,
	pr.FunctionalDepartmentKey,			
	pr.PropertyFundKey,
	c.CalendarPeriod,
	s.SourceName,
	CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END
'')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LEN(@cmdString)) + '''')

PRINT @cmdString
EXEC (@cmdString)

----------------------------------------------------------------------------------------------------------------------------------
-- Get Q2 reforecast information
SET @cmdString = (SELECT ''
INSERT INTO #ExpenseCzar
SELECT 
	gac.GlAccountCategoryKey,
	pr.AllocationRegionKey,
	pr.FunctionalDepartmentKey,	
	pr.PropertyFundKey,
	c.CalendarPeriod,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    '''''''' as PropertyFundCode,
    '''''''' as OriginatingRegionCode,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	
	NULL as MtdGrossReforecastQ1,
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecastQ2,
	NULL as MtdGrossReforecastQ3,
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
	
	NULL as MtdNetReforecastQ1,
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecastQ2,
	NULL as MtdNetReforecastQ3,
	
	NULL as YtdGrossActual,	
	NULL as YtdGrossBudget,
	
	NULL as YtdGrossReforecastQ1,
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecastQ2,
	NULL as YtdGrossReforecastQ3,
	
	NULL as YtdNetActual, 
	NULL as YtdNetBudget,
	
	NULL as YtdNetReforecastQ1,
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecastQ2,
    NULL as YtdNetReforecastQ3,
	
	NULL as AnnualGrossBudget, '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''
    NULL as AnnualGrossReforecastQ1,
    SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ2,
	NULL as AnnualGrossReforecastQ3,

	NULL as AnnualNetBudget, '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''
    NULL as AnnualNetReforecastQ1,
    SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast) as AnnualNetReforecastQ2,
    NULL as AnnualNetReforecastQ3,

	NULL as AnnualEstGrossBudget,
	
	NULL as AnnualEstGrossReforecastQ1,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstGrossReforecastQ2,
    NULL as AnnualEstGrossReforecastQ3,

	NULL as AnnualEstNetBudget,
	NULL as AnnualEstNetReforecastQ1,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE
			0
        END
    ) as AnnualEstNetReforecastQ2,
    NULL as AnnualEstNetReforecastQ3
    
FROM
	ProfitabilityReforecast pr

	INNER JOIN Overhead oh ON oh.OverheadKey = pr.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1
    
    	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON c.CalendarKey = pr.CalendarKey
    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
    INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey ''
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + 
	+ CASE WHEN EXISTS(SELECT * FROM @CategoryActivityGroups) THEN '' INNER JOIN #CategoryActivityGroupFilterTable cag ON cag.GlAccountCategoryKey = gac.GlAccountCategoryKey AND (cag.ActivityTypeKey IS NULL OR cag.ActivityTypeKey = pr.ActivityTypeKey)'' ELSE '''' END + ''
		
WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND ref.ReforecastEffectivePeriod = '' + STR(@ReforecastEffectivePeriodQ2,10,0) + ''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''    
GROUP BY
	gac.GlAccountCategoryKey,
	pr.AllocationRegionKey,
	pr.FunctionalDepartmentKey,			
	pr.PropertyFundKey,
	c.CalendarPeriod,
	s.SourceName,
	CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END
'')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LEN(@cmdString)) + '''')

PRINT @cmdString
EXEC (@cmdString)



----------------------------------------------------------------------------------------------------------------------------------
-- Get Q3 reforecast information
SET @cmdString = (SELECT ''
INSERT INTO #ExpenseCzar
SELECT 
	gac.GlAccountCategoryKey,
	pr.AllocationRegionKey,
	pr.FunctionalDepartmentKey,	
	pr.PropertyFundKey,
	c.CalendarPeriod,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    '''''''' as PropertyFundCode,
    '''''''' as OriginatingRegionCode,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	
	NULL as MtdGrossReforecastQ1,
	NULL as MtdGrossReforecastQ2,
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecastQ3,
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
	
	NULL as MtdNetReforecastQ1,
	NULL as MtdNetReforecastQ2,
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecastQ3,
	
	NULL as YtdGrossActual,	
	NULL as YtdGrossBudget,
	
	NULL as YtdGrossReforecastQ1,
	NULL as YtdGrossReforecastQ2,
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecastQ3,
	
	NULL as YtdNetActual, 
	NULL as YtdNetBudget,
	
	NULL as YtdNetReforecastQ1,
	NULL as YtdNetReforecastQ2,
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecastQ3,
	
	NULL as AnnualGrossBudget, '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''
    NULL as AnnualGrossReforecastQ1,
    NULL as AnnualGrossReforecastQ2,
    SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ3,

	NULL as AnnualNetBudget, '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''
    NULL as AnnualNetReforecastQ1,
    NULL as AnnualNetReforecastQ2,    
    SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast) as AnnualNetReforecastQ3,

	NULL as AnnualEstGrossBudget,
	
	NULL as AnnualEstGrossReforecastQ1,
	NULL as AnnualEstGrossReforecastQ2,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstGrossReforecastQ3,

	NULL as AnnualEstNetBudget,
	NULL as AnnualEstNetReforecastQ1,
	NULL as AnnualEstNetReforecastQ2,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE
			0
        END
    ) as AnnualEstNetReforecastQ3
    
FROM
	ProfitabilityReforecast pr

	INNER JOIN Overhead oh ON oh.OverheadKey = pr.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1
    
    	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON c.CalendarKey = pr.CalendarKey
    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
    INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey ''
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + 
	+ CASE WHEN EXISTS(SELECT * FROM @CategoryActivityGroups) THEN '' INNER JOIN #CategoryActivityGroupFilterTable cag ON cag.GlAccountCategoryKey = gac.GlAccountCategoryKey AND (cag.ActivityTypeKey IS NULL OR cag.ActivityTypeKey = pr.ActivityTypeKey)'' ELSE '''' END + ''
		
WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND ref.ReforecastEffectivePeriod = '' + STR(@ReforecastEffectivePeriodQ3,10,0) + ''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''    
GROUP BY
	gac.GlAccountCategoryKey,
	pr.AllocationRegionKey,
	pr.FunctionalDepartmentKey,			
	pr.PropertyFundKey,
	c.CalendarPeriod,
	s.SourceName,
	CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END
'')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LEN(@cmdString)) + '''')

PRINT @cmdString
EXEC (@cmdString)

---------------------------------------------------------------------------------------------------
SELECT 
	gac.AccountSubTypeName AS ExpenseType,
	ar.RegionName AS AllocationRegionName,
    fd.FunctionalDepartmentName AS FunctionalDepartmentName,    
    gac.MajorCategoryName AS MajorExpenseCategoryName,
    gac.MinorCategoryName AS MinorExpenseCategoryName,
    pf.PropertyFundName AS EntityName,
    res.CalendarPeriod AS ExpensePeriod,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
    res.SourceName AS SourceName,
    res.PropertyFundCode,
    res.OriginatingRegionCode,
	ISNULL(ga.Code, '''') GlAccountCode,
    ISNULL(ga.Name, '''') GlAccountName,

	--Gross
	--Month to date    
	SUM(ISNULL(MtdGrossActual,0)) AS MtdGrossActual,
	SUM(ISNULL(MtdGrossBudget,0)) AS MtdGrossOriginalBudget,
	
	-----
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ1 
	END,0)) AS MtdGrossReforecastQ1,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ2 
	END,0)) AS MtdGrossReforecastQ2,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ3 
	END,0)) AS MtdGrossReforecastQ3,		
	-----
	
	-----
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ1 
	END, 0) - ISNULL(MtdGrossActual, 0)) 
	AS MtdGrossVarianceQ1,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ2 
	END, 0) - ISNULL(MtdGrossActual, 0)) 
	AS MtdGrossVarianceQ2,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ3 
	END, 0) - ISNULL(MtdGrossActual, 0)) 
	AS MtdGrossVarianceQ3,			
	-----
		
	--Year to date
	SUM(ISNULL(YtdGrossActual,0)) AS YtdGrossActual,	
	SUM(ISNULL(YtdGrossBudget,0)) AS YtdGrossOriginalBudget,
	
	-----
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ1 
	END,0)) AS YtdGrossReforecastQ1,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ2 
	END,0)) AS YtdGrossReforecastQ2,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ3 
	END,0)) AS YtdGrossReforecastQ3,			
	-----
	
	-----
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ1
		END, 0) - ISNULL(YtdGrossActual, 0)) 
	AS YtdGrossVarianceQ1,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ2
		END, 0) - ISNULL(YtdGrossActual, 0)) 
	AS YtdGrossVarianceQ2,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ3
		END, 0) - ISNULL(YtdGrossActual, 0)) 
	AS YtdGrossVarianceQ3,
	-----
	--Annual
	SUM(ISNULL(AnnualGrossBudget,0)) AS AnnualGrossOriginalBudget,	
	
	-----
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecastQ1 
		END,0)) 
	AS AnnualGrossReforecastQ1,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecastQ2 
		END,0)) 
	AS AnnualGrossReforecastQ2,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecastQ3 
		END,0)) 
	AS AnnualGrossReforecastQ3,		
	-----

	--Net
	--Month to date    
	SUM(ISNULL(MtdNetActual,0)) AS MtdNetActual,
	SUM(ISNULL(MtdNetBudget,0)) AS MtdNetOriginalBudget,
	
	-----
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ1
		END,0)) 
	AS MtdNetReforecastQ1,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ2
		END,0)) 
	AS MtdNetReforecastQ2,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ3
		END,0)) 
	AS MtdNetReforecastQ3,	
	-----
	
	-----
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ1
		END, 0) - ISNULL(MtdNetActual, 0)) 
	AS MtdNetVarianceQ1,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ2
		END, 0) - ISNULL(MtdNetActual, 0)) 
	AS MtdNetVarianceQ2,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ3
		END, 0) - ISNULL(MtdNetActual, 0)) 
	AS MtdNetVarianceQ3,	
	-----
		
	--Year to date
	SUM(ISNULL(YtdNetActual,0)) AS YtdNetActual,	
	SUM(ISNULL(YtdNetBudget,0)) AS YtdNetOriginalBudget,
	
	-----
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ1
		END,0)) 
	AS YtdNetReforecastQ1,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ2
		END,0)) 
	AS YtdNetReforecastQ2,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ3
		END,0)) 
	AS YtdNetReforecastQ3,
	-----
	
	-----
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ1
		END, 0) - ISNULL(YtdNetActual, 0)) 
	AS YtdNetVarianceQ1,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ2
		END, 0) - ISNULL(YtdNetActual, 0)) 
	AS YtdNetVarianceQ2,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ3
		END, 0) - ISNULL(YtdNetActual, 0)) 
	AS YtdNetVarianceQ3,
	-----
	
	--Annual
	SUM(ISNULL(AnnualNetBudget,0)) AS AnnualNetOriginalBudget,	

	-----
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecastQ1
		END,0)) 
	AS AnnualNetReforecastQ1,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecastQ2
		END,0)) 
	AS AnnualNetReforecastQ2,
	--
	SUM(ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecastQ3
		END,0)) 
	AS AnnualNetReforecastQ3
	-----
INTO
	#Output
FROM
	#ExpenseCzar res
		INNER JOIN PropertyFund pf ON pf.PropertyFundKey = res.PropertyFundKey		
		INNER JOIN AllocationRegion ar ON ar.AllocationRegionKey = res.AllocationRegionKey
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentKey = res.FunctionalDepartmentKey
		INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = res.GlAccountCategoryKey 
		LEFT OUTER JOIN GlAccount ga ON ga.GlAccountKey = res.GlAccountKey 
GROUP BY
	gac.AccountSubTypeName,
	ar.RegionName,
    fd.FunctionalDepartmentName,    
    gac.MajorCategoryName,
    gac.MinorCategoryName,
    pf.PropertyFundName,
    res.CalendarPeriod,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
    res.SourceName,
    res.PropertyFundCode,
    res.OriginatingRegionCode,
    ISNULL(ga.Code, ''''),
    ISNULL(ga.Name, '''')

--Output
SELECT
	ExpenseType,
	AllocationRegionName,
    FunctionalDepartmentName,    
    MajorExpenseCategoryName,
    MinorExpenseCategoryName,
    EntityName,
    ExpensePeriod,
    EntryDate,
    [User],
    [Description],
    AdditionalDescription,
    SourceName,
    PropertyFundCode,
    OriginatingRegionCode,
    GlAccountCode,
    GlAccountName,
    
	--Gross
	--Month to date    
	MtdGrossActual,
	MtdGrossOriginalBudget,

	--MtdGrossReforecastQ1,
	--MtdGrossReforecastQ2,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE MtdGrossReforecastQ3 END AS MtdGrossReforecastQ3,
	
	--MtdGrossVarianceQ1,
	--MtdGrossVarianceQ2,
	MtdGrossVarianceQ3,
		
	--Year to date
	YtdGrossActual,	
	YtdGrossOriginalBudget,

	--YtdGrossReforecastQ1,
	--YtdGrossReforecastQ2,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE YtdGrossReforecastQ3 END AS YtdGrossReforecastQ3,
	
	--YtdGrossVarianceQ1,
	--YtdGrossVarianceQ2,
	YtdGrossVarianceQ3,

	--Annual
	AnnualGrossOriginalBudget,
	
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE AnnualGrossReforecastQ1 END AS AnnualGrossReforecastQ1,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE AnnualGrossReforecastQ2 END AS AnnualGrossReforecastQ2,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE AnnualGrossReforecastQ3 END AS AnnualGrossReforecastQ3,

	--Annual Estimated
	--AnnualGrossEstimatedActual,
	--AnnualGrossEstimatedVariance,

	--Net
	--Month to date    
	MtdNetActual,
	MtdNetOriginalBudget,
	
	--MtdNetReforecastQ1,
	--MtdNetReforecastQ2,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE MtdNetReforecastQ3 END AS MtdNetReforecastQ3,
	
	--MtdNetVarianceQ1,
	--MtdNetVarianceQ2,
	MtdNetVarianceQ3,

	--Year to date
	YtdNetActual,	
	YtdNetOriginalBudget,
	
	--YtdNetReforecastQ1,
	--YtdNetReforecastQ2,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE YtdNetReforecastQ3 END AS YtdNetReforecastQ3,
	
	--YtdNetVarianceQ1,
	--YtdNetVarianceQ2,
	YtdNetVarianceQ3,

	--Annual
	AnnualNetOriginalBudget,	
	
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE AnnualNetReforecastQ1 END AS AnnualNetReforecastQ1,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE AnnualNetReforecastQ2 END AS AnnualNetReforecastQ2,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE AnnualNetReforecastQ3 END AS AnnualNetReforecastQ3

	--Annual Estimated
	--AnnualNetEstimatedActual,	
	--AnnualNetEstimatedVariance
FROM
	#Output
WHERE
	--Gross
	--Month to date    
	MtdGrossActual <> 0.00 OR
	MtdGrossOriginalBudget <> 0.00 OR

	--MtdGrossReforecastQ1 <> 0.00 OR
	--MtdGrossReforecastQ2 <> 0.00 OR
	--MtdGrossReforecastQ3 <> 0.00 OR
	
	--MtdGrossVarianceQ1 <> 0.00 OR
	--MtdGrossVarianceQ2 <> 0.00 OR
	MtdGrossVarianceQ3 <> 0.00 OR
		
	--Year to date
	YtdGrossActual <> 0.00 OR
	YtdGrossOriginalBudget <> 0.00 OR

	--YtdGrossReforecastQ1 <> 0.00 OR
	--YtdGrossReforecastQ2 <> 0.00 OR
	--YtdGrossReforecastQ3 <> 0.00 OR
	
	--YtdGrossVarianceQ1 <> 0.00 OR
	--YtdGrossVarianceQ2 <> 0.00 OR
	YtdGrossVarianceQ3 <> 0.00 OR

	--Annual
	AnnualGrossOriginalBudget <> 0.00 OR
	
	--AnnualGrossReforecastQ1 <> 0.00 OR
	--AnnualGrossReforecastQ2 <> 0.00 OR
	--AnnualGrossReforecastQ3 <> 0.00 OR
	
	--Annual Estimated
	--AnnualGrossEstimatedActual <> 0.00 OR
	--AnnualGrossEstimatedVariance <> 0.00 OR

	--Net
	--Month to date
	MtdNetActual <> 0.00 OR
	MtdNetOriginalBudget <> 0.00 OR
	
	--MtdNetReforecastQ1 <> 0.00 OR
	--MtdNetReforecastQ2 <> 0.00 OR
	--MtdNetReforecastQ3 <> 0.00 OR
	
	--MtdNetVarianceQ1 <> 0.00 OR
	--MtdNetVarianceQ2 <> 0.00 OR
	MtdNetVarianceQ3 <> 0.00 OR

	--Year to date
	YtdNetActual <> 0.00 OR
	YtdNetOriginalBudget <> 0.00 OR
	
	--YtdNetReforecastQ1 <> 0.00 OR
	--YtdNetReforecastQ2 <> 0.00 OR
	--YtdNetReforecastQ3 <> 0.00 OR
	
	--YtdNetVarianceQ1 <> 0.00 OR
	--YtdNetVarianceQ2 <> 0.00 OR
	YtdNetVarianceQ3 <> 0.00 OR

	--Annual
	AnnualNetOriginalBudget <> 0.00
	
	--AnnualNetReforecastQ1 <> 0.00 OR
	--AnnualNetReforecastQ2 <> 0.00 OR
	--AnnualNetReforecastQ3 <> 0.00

IF 	OBJECT_ID(''tempdb..#AccountCategoryFilterTable'') IS NOT NULL
    DROP TABLE #AccountCategoryFilterTable
    
IF 	OBJECT_ID(''tempdb..#ActivityTypeFilterTable'') IS NOT NULL
    DROP TABLE #ActivityTypeFilterTable
    
IF 	OBJECT_ID(''tempdb..#MinorAccountCategoryFilterTable'') IS NOT NULL
	DROP TABLE #MinorAccountCategoryFilterTable

IF 	OBJECT_ID(''tempdb..#CategoryActivityGroupFilterTable'') IS NOT NULL
	DROP TABLE #CategoryActivityGroupFilterTable

IF 	OBJECT_ID(''tempdb..#ExpenseCzar'') IS NOT NULL
    DROP TABLE #ExpenseCzar
    
IF 	OBJECT_ID(''tempdb..#Output'') IS NOT NULL
	DROP TABLE #Output

IF 	OBJECT_ID(''tempdb..#EntityFilterTable'') IS NOT NULL
	DROP TABLE #EntityFilterTable

IF 	OBJECT_ID(''tempdb..#FunctionalDepartmentFilterTable'') IS NOT NULL
	DROP TABLE #FunctionalDepartmentFilterTable

IF 	OBJECT_ID(''tempdb..#AllocationRegionFilterTable'') IS NOT NULL
	DROP TABLE #AllocationRegionFilterTable

IF 	OBJECT_ID(''tempdb..#AllocationSubRegionFilterTable'') IS NOT NULL
	DROP TABLE #AllocationSubRegionFilterTable

IF 	OBJECT_ID(''tempdb..#MajorAccountCategoryFilterTable'') IS NOT NULL
	DROP TABLE #MajorAccountCategoryFilterTable

IF 	OBJECT_ID(''tempdb..#OriginatingRegionFilterTable'') IS NOT NULL
	DROP TABLE #OriginatingRegionFilterTable

IF 	OBJECT_ID(''tempdb..#OriginatingSubRegionFilterTable'') IS NOT NULL
	DROP TABLE #OriginatingSubRegionFilterTable

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOwner]    Script Date: 01/25/2011 14:18:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOwner]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_R_BudgetOwner]
	@ReportExpensePeriod INT = NULL,
	@ReforecastQuaterName VARCHAR(10) = NULL, --''Q1'' or ''Q2'' or ''Q3''
	@DestinationCurrency VARCHAR(3) = NULL,
	@TranslationTypeName VARCHAR(50) = ''Global'',
	@IsGross bit = 1,
	@FunctionalDepartmentList TEXT = NULL,
	@ActivityTypeList TEXT = NULL,
	@EntityList TEXT = NULL,
	@MajorAccountCategoryList TEXT = NULL,
	@MinorAccountCategoryList TEXT = NULL,
	@AllocationRegionList TEXT = NULL,
	@AllocationSubRegionList TEXT = NULL,
	@OriginatingRegionList TEXT = NULL,
	@OriginatingSubRegionList TEXT = NULL,
	@OverheadCode Varchar(10)=''ALLOC''
AS

/*
DECLARE @ReportExpensePeriod		AS INT,
        @DestinationCurrency		AS VARCHAR(3),
        @TranslationTypeName				VARCHAR(50)
				
SET @ReportExpensePeriod = 201011
SET @DestinationCurrency = ''USD''
SET @EntityList = ''Aldgate|Centrium (St Cathrine House/Pegasus)''
SET @TranslationTypeName = ''Global''

EXEC stp_R_BudgetOriginatorOwnerEntity
	@ReportExpensePeriod = 201011,
	@TranslationTypeName = ''Global'',
	@DestinationCurrency = ''USD'',

	@FunctionalDepartmentList = ''Information Technologies'',
	@AllocationRegionList = ''CHICAGO'',
	@EntityList = ''Aldgate|Centrium (St Cathrine House/Pegasus)''
*/
DECLARE

	@_ReportExpensePeriod INT = @ReportExpensePeriod,
	@_ReforecastQuaterName VARCHAR(10) = @ReforecastQuaterName,
	@_DestinationCurrency VARCHAR(3) = @DestinationCurrency,
	@_TranslationTypeName VARCHAR(50) = @TranslationTypeName,
	@_IsGross bit = @IsGross,
	@_FunctionalDepartmentList VARCHAR(8000) = @FunctionalDepartmentList,
	@_ActivityTypeList VARCHAR(8000) = @ActivityTypeList,
	@_EntityList VARCHAR(8000) = @EntityList,
	@_MajorAccountCategoryList VARCHAR(8000) = @MajorAccountCategoryList,
	@_MinorAccountCategoryList VARCHAR(8000) = @MinorAccountCategoryList,
	@_AllocationRegionList VARCHAR(8000) = @AllocationRegionList,
	@_AllocationSubRegionList VARCHAR(8000) = @AllocationSubRegionList,
	@_OriginatingRegionList VARCHAR(8000) = @OriginatingRegionList,
	@_OriginatingSubRegionList VARCHAR(8000) = @OriginatingSubRegionList

IF LEN(@_FunctionalDepartmentList) > 7998 OR
	LEN(@_ActivityTypeList) > 7998 OR
	LEN(@_EntityList) > 7998 OR
	LEN(@_MajorAccountCategoryList) > 7998 OR
	LEN(@_MinorAccountCategoryList) > 7998 OR
	LEN(@_AllocationRegionList) > 7998 OR
	LEN(@_AllocationSubRegionList) > 7998 OR
	LEN(@_OriginatingRegionList) > 7998 OR
	LEN(@_OriginatingSubRegionList) > 7998
BEGIN
	RAISERROR(''Filter List parameter is too big'',9,1)
END

--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Variable defaults		*/
--------------------------------------------------------------------------

IF @ReportExpensePeriod IS NULL
	SET @ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + REPLACE(STR(MONTH(GETDATE()),2 ),'' '',''0'')AS INT)

IF @DestinationCurrency IS NULL
	SET @DestinationCurrency = ''USD''

IF 	@TranslationTypeName IS NULL
	SET @TranslationTypeName = ''Global''

DECLARE @CalendarYear AS INT
SET @CalendarYear = CAST(SUBSTRING(CAST(@ReportExpensePeriod AS VARCHAR(10)), 1, 4) AS INT)

--------------------------------------------------------------------------
IF @ReforecastQuaterName IS NULL OR @ReforecastQuaterName NOT IN (''Q0'', ''Q1'', ''Q2'', ''Q3'')
	SET @ReforecastQuaterName = (SELECT TOP 1
									ReforecastQuarterName 
								 FROM
									dbo.Reforecast 
								 WHERE
									ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
									ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
								 ORDER BY ReforecastEffectivePeriod DESC)
-- Compute Reforecast Effective Periods

DECLARE @ReforecastEffectivePeriodQ1 INT
DECLARE @ReforecastEffectivePeriodQ2 INT
DECLARE @ReforecastEffectivePeriodQ3 INT

SET @ReforecastEffectivePeriodQ1 = (SELECT TOP 1
										ReforecastEffectivePeriod 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										ReforecastQuarterName = ''Q1''
									ORDER BY
										ReforecastEffectivePeriod)								

SET @ReforecastEffectivePeriodQ2 = (SELECT TOP 1
										ReforecastEffectivePeriod 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										ReforecastQuarterName = ''Q2''
									ORDER BY
										ReforecastEffectivePeriod)								

SET @ReforecastEffectivePeriodQ3 = (SELECT TOP 1
										ReforecastEffectivePeriod 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										ReforecastQuarterName = ''Q3''
									ORDER BY
										ReforecastEffectivePeriod)

-- Retrieve Reforecast Quarter Name

DECLARE @ReforecastQuarterNameQ1 CHAR(2)
DECLARE @ReforecastQuarterNameQ2 CHAR(2)
DECLARE @ReforecastQuarterNameQ3 CHAR(2)

IF (@ReforecastEffectivePeriodQ1 IS NOT NULL)
BEGIN
	SET @ReforecastQuarterNameQ1 = (SELECT TOP 1
										ReforecastQuarterName 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectivePeriod = @ReforecastEffectivePeriodQ1)
END
ELSE
BEGIN
	PRINT (''@ReforecastEffectivePeriodQ1 is NULL - cannot determine Q1 reforecast quarter name.'')
END


IF (@ReforecastEffectivePeriodQ2 IS NOT NULL)
BEGIN
	SET @ReforecastQuarterNameQ2 = (SELECT TOP 1
											ReforecastQuarterName 
										FROM
											dbo.Reforecast 
										WHERE
											ReforecastEffectivePeriod = @ReforecastEffectivePeriodQ2)
END
ELSE
BEGIN
	PRINT (''@ReforecastEffectivePeriodQ2 is NULL - cannot determine Q2 reforecast quarter name.'')
END


IF (@ReforecastEffectivePeriodQ3 IS NOT NULL)
BEGIN
	SET @ReforecastQuarterNameQ3 = (SELECT TOP 1
											ReforecastQuarterName 
										FROM
											dbo.Reforecast 
										WHERE
											ReforecastEffectivePeriod = @ReforecastEffectivePeriodQ3)
END
ELSE
BEGIN
	PRINT (''@ReforecastEffectivePeriodQ3 is NULL - cannot determine Q3 reforecast quarter name.'')
END

--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Tables		*/
--------------------------------------------------------------------------
	
CREATE TABLE #EntityFilterTable	(PropertyFundKey Int NOT NULL)
CREATE TABLE #FunctionalDepartmentFilterTable (FunctionalDepartmentKey Int NOT NULL)
CREATE TABLE #ActivityTypeFilterTable (ActivityTypeKey Int NOT NULL)
CREATE TABLE #AllocationRegionFilterTable (AllocationRegionKey Int NOT NULL)
CREATE TABLE #AllocationSubRegionFilterTable (AllocationRegionKey Int NOT NULL)
CREATE TABLE #MajorAccountCategoryFilterTable (GlAccountCategoryKey Int NOT NULL)	
CREATE TABLE #MinorAccountCategoryFilterTable (GlAccountCategoryKey Int NOT NULL)	
CREATE TABLE #OriginatingRegionFilterTable (OriginatingRegionKey Int NOT NULL)
CREATE TABLE #OriginatingSubRegionFilterTable (OriginatingRegionKey Int NOT NULL)	
	
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable	(PropertyFundKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable(ActivityTypeKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationRegionFilterTable	(AllocationRegionKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MajorAccountCategoryFilterTable(GlAccountCategoryKey)	
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MinorAccountCategoryFilterTable(GlAccountCategoryKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingRegionFilterTable	(OriginatingRegionKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable	(OriginatingRegionKey)
	
IF (@EntityList IS NOT NULL)
	BEGIN
	Insert Into #EntityFilterTable
	Select pf.PropertyFundKey
	From dbo.Split(@_EntityList) t1
		INNER JOIN PropertyFund pf ON pf.PropertyFundName = t1.item
	
	END
	
IF (@FunctionalDepartmentList IS NOT NULL)
	BEGIN
	Insert Into #FunctionalDepartmentFilterTable
	Select fd.FunctionalDepartmentKey 
	From dbo.Split(@_FunctionalDepartmentList) t1
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentName = t1.item
	END

IF 	(@ActivityTypeList IS NOT NULL)
	BEGIN
    INSERT INTO #ActivityTypeFilterTable
    SELECT at.ActivityTypeKey 
    FROM dbo.Split(@_ActivityTypeList) t1
		INNER JOIN ActivityType at ON at.ActivityTypeName = t1.item
	END
	
IF (@AllocationRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationRegionFilterTable
	Select ar.AllocationRegionKey 
	From dbo.Split(@_AllocationRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.RegionName = t1.item
	END

IF (@AllocationSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationSubRegionFilterTable
	Select ar.AllocationRegionKey
	From dbo.Split(@_AllocationSubRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.SubRegionName = t1.item
	END

IF (@MajorAccountCategoryList IS NOT NULL)
	BEGIN
	Insert Into #MajorAccountCategoryFilterTable
	Select gl.GlAccountCategoryKey 
	From dbo.Split(@_MajorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MajorCategoryName = t1.item
	END
	
IF 	(@MinorAccountCategoryList IS NOT NULL)
	BEGIN
    INSERT INTO #MinorAccountCategoryFilterTable
    SELECT gl.GlAccountCategoryKey 
    FROM dbo.Split(@MinorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MinorCategoryName = t1.item
	END	

IF (@OriginatingRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingRegionFilterTable
	Select orr.OriginatingRegionKey 
	From dbo.Split(@_OriginatingRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.RegionName = t1.item
	END

IF (@OriginatingSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingSubRegionFilterTable
	Select orr.OriginatingRegionKey  
	From dbo.Split(@OriginatingSubRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.SubRegionName = t1.item
	END		
--------------------------------------------------------------------------
/*	COMMON END															*/
--------------------------------------------------------------------------
	

IF 	OBJECT_ID(''tempdb..#BudgetOriginatorOwnerEntity'') IS NOT NULL
    DROP TABLE #BudgetOriginatorOwnerEntity

CREATE TABLE #BudgetOriginatorOwnerEntity
(
	ActivityTypeKey				Int,	
    GlAccountCategoryKey		Int,
    AllocationRegionKey			Int,
    OriginatingRegionKey		Int,
    FunctionalDepartmentKey		Int,
    PropertyFundKey				INT,
	SourceName					VarChar(50),
	EntryDate					VARCHAR(10),
	[User]						NVARCHAR(20),
	[Description]				NVARCHAR(60),
	AdditionalDescription		NVARCHAR(4000),
	PropertyFundCode			Varchar(6) DEFAULT(''''), --Varchar, for this helps to keep reports size smaller
	OriginatingRegionCode		Varchar(15) DEFAULT(''''), --Varchar, for this helps to keep reports size smaller
	GlAccountKey				Int NULL,
	CalendarPeriod				Varchar(6) DEFAULT(''''),

	--Month to date	
	MtdGrossActual				MONEY,
	MtdGrossBudget				MONEY,
	MtdGrossReforecastQ1		MONEY,
	MtdGrossReforecastQ2		MONEY,
	MtdGrossReforecastQ3		MONEY,
	
	MtdNetActual				MONEY,
	MtdNetBudget				MONEY,
	MtdNetReforecastQ1			MONEY,
	MtdNetReforecastQ2			MONEY,
	MtdNetReforecastQ3			MONEY,
	
	--Year to date
	YtdGrossActual				MONEY,	
	YtdGrossBudget				MONEY, 
	YtdGrossReforecastQ1		MONEY,
	YtdGrossReforecastQ2		MONEY,
	YtdGrossReforecastQ3		MONEY,
	
	YtdNetActual				MONEY, 
	YtdNetBudget				MONEY, 
	YtdNetReforecastQ1			MONEY, 
	YtdNetReforecastQ2			MONEY, 
	YtdNetReforecastQ3			MONEY, 

	--Annual	
	AnnualGrossBudget			MONEY,
	AnnualGrossReforecastQ1		MONEY,
	AnnualGrossReforecastQ2		MONEY,
	AnnualGrossReforecastQ3		MONEY,
	AnnualNetBudget				MONEY,
	AnnualNetReforecastQ1		MONEY,
	AnnualNetReforecastQ2		MONEY,
	AnnualNetReforecastQ3		MONEY,

	--Annual estimated
	AnnualEstGrossBudget		MONEY,
	AnnualEstGrossReforecastQ1	MONEY,
	AnnualEstGrossReforecastQ2	MONEY,
	AnnualEstGrossReforecastQ3	MONEY,
	AnnualEstNetBudget			MONEY,
	AnnualEstNetReforecastQ1	MONEY,
	AnnualEstNetReforecastQ2	MONEY,
	AnnualEstNetReforecastQ3	MONEY
)

DECLARE @cmdString	VARCHAR(MAX)
DECLARE @cmdString2	VARCHAR(MAX)
DECLARE @cmdString3	VARCHAR(MAX)

--Get actual information
SET @cmdString = (Select ''

INSERT INTO #BudgetOriginatorOwnerEntity
SELECT 
	pa.ActivityTypeKey,
    gac.GlAccountCategoryKey,
    pa.AllocationRegionKey,
    pa.OriginatingRegionKey,
    pa.FunctionalDepartmentKey,
    pa.PropertyFundKey,
    s.SourceName,
    CONVERT(varchar(10),ISNULL(pa.EntryDate,''''''''), 101) as EntryDate,
    ISNULL(pa.[User], '''''''') [User],
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.Description ELSE '''''''' END as Description,
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.AdditionalDescription ELSE '''''''' END as AdditionalDescription,
    ISNULL(pa.PropertyFundCode, '''''''') PropertyFundCode,
    ISNULL(pa.OriginatingRegionCode, '''''''') OriginatingRegionCode,
    pa.GlAccountKey,
    c.CalendarPeriod,
    
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdGrossActual,
	NULL as MtdGrossBudget,
	
	'' + /*-- MtdGrossReforecast --------------------------*/ + ''	
	
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdGrossReforecastQ1,

	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdGrossReforecastQ2,
	
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdGrossReforecastQ3,	
	
	'' + /*-- MtdGrossReforecast End --------------------------*/ + ''
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdNetActual,
	NULL as MtdNetBudget,
	
	'' + /*-- MtdNetReforecast --------------------------*/ + ''
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) +  
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdNetReforecastQ1,

	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) +  
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdNetReforecastQ2,
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) +  
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as MtdNetReforecastQ3,	

	'' + /*-- MtdNetReforecast End --------------------------*/ + ''
	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdGrossActual,
	NULL as YtdGrossBudget,
	
	'' + /*-- YtdGrossReforecast --------------------------*/ + ''
	
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) +  
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as YtdGrossReforecastQ1,
	
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) +  
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as YtdGrossReforecastQ2,
	
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) +  
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as YtdGrossReforecastQ3,		
	
	'' + /*-- YtdGrossReforecast End --------------------------*/ + ''
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdNetActual,
	NULL as YtdNetBudget,
	
	'' + /*-- YtdNetReforecast --------------------------*/ + ''
	
	'')
	
	SET @cmdString2 = (Select ''	
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) +  
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as YtdNetReforecastQ1,

	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) +  
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as YtdNetReforecastQ2,

	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) +  
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as YtdNetReforecastQ3,

	'' + /*-- YtdNetReforecast End --------------------------*/ + ''
	
	NULL as AnnualGrossBudget,
	
	'' + /*-- AnnualGrossReforecast --------------------------*/ + ''
	
	SUM(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualGrossReforecastQ1,

	SUM(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualGrossReforecastQ2,

	SUM(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualGrossReforecastQ3,

	'' + /*-- AnnualGrossReforecast End --------------------------*/ + ''

	NULL as AnnualNetBudget,
	
	'' + /*-- AnnualNetReforecast --------------------------*/ + ''
	
    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ1,
	
    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ2,

    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ3,	

	'' + /*-- AnnualNetReforecast End --------------------------*/ + ''
	
	SUM(
        er.Rate *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pa.LocalActual
        ELSE 
			0
        END
	) as AnnualEstGrossBudget,
	
	'' + /*-- AnnualEstGrossReforecast --------------------------*/ + ''
	
	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecastQ1,

	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecastQ2,

	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecastQ3,

	'' + /*-- AnnualEstGrossReforecast End --------------------------*/ + ''

	'')
	
	SET @cmdString3 = (Select ''

    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
    
    '' + /*-- AnnualEstNetReforecast --------------------------*/ + ''
    
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstNetReforecastQ1,
	
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstNetReforecastQ2,
	
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				  pa.LocalActual 
		ELSE 
			0 
		END
	) as AnnualEstNetReforecastQ3		
	
	'' + /*-- AnnualEstNetReforecast End --------------------------*/ + ''
	
FROM
	ProfitabilityActual pa

	INNER JOIN Overhead oh ON oh.OverheadKey = pa.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1
	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pa.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pa.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pa.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pa.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pa.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pa.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pa.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pa.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')
    
    INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
    INNER JOIN Currency dc ON er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON c.CalendarKey = pa.CalendarKey
    INNER JOIN Source s ON s.SourceKey = pa.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pa.ReimbursableKey ''
    
    + CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pa.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pa.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pa.PropertyFundKey'' ELSE '''' END + ''

WHERE  1 = 1
    AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select t1.FunctionalDepartmentKey From #FunctionalDepartmentFilterTable t1)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select t1.ActivityTypeKey From #ActivityTypeFilterTable t1)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select t1.PropertyFundKey From #EntityFilterTable t1)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationRegionFilterTable t1)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationSubRegionFilterTable t1)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MajorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MinorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingRegionFilterTable t1)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingSubRegionFilterTable t1)'' END +
''
Group by
	pa.ActivityTypeKey,
    gac.GlAccountCategoryKey,
    pa.AllocationRegionKey,
    pa.OriginatingRegionKey,
    pa.FunctionalDepartmentKey,
    pa.PropertyFundKey,
    s.SourceName,
	CONVERT(varchar(10),ISNULL(pa.EntryDate,''''''''), 101),
	ISNULL(pa.[User], '''''''') ,
	CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.Description ELSE '''''''' END,
	CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.AdditionalDescription ELSE '''''''' END,
	ISNULL(pa.PropertyFundCode, ''''''''),
    ISNULL(pa.OriginatingRegionCode, ''''''''),
	pa.GlAccountKey,
	c.CalendarPeriod
'')

IF (LEN(@cmdString) > 7995 OR LEN(@cmdString2) > 7995 OR LEN(@cmdString3) > 7995)
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LTRIM(RTRIM(LEN(@cmdString)))) + '' + '' + STR(LTRIM(RTRIM(LEN(@cmdString2)))) + '' + '' + STR(LTRIM(RTRIM(LEN(@cmdString3)))))

PRINT @cmdString
PRINT @cmdString2
PRINT @cmdString3
EXEC (@cmdString + @cmdString2 + @cmdString3)

-- Get budget information
SET @cmdString = (Select ''
INSERT INTO #BudgetOriginatorOwnerEntity
SELECT 
	pb.ActivityTypeKey,
    gac.GlAccountCategoryKey,
    pb.AllocationRegionKey,
    pb.OriginatingRegionKey,
    pb.FunctionalDepartmentKey,
    pb.PropertyFundKey,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    '''''''' as PropertyFundCode,
    '''''''' as OriginatingRegionCode,    
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pb.GlAccountKey END,
    '''''''' as CalendarPeriod,
    
    NULL as MtdGrossActual,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as MtdGrossBudget,
	
	NULL as MtdGrossReforecastQ1,
	NULL as MtdGrossReforecastQ2,
	NULL as MtdGrossReforecastQ3,
	
	NULL as MtdNetActual,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as MtdNetBudget,
    
	NULL as MtdNetReforecastQ1,
	NULL as MtdNetReforecastQ2,
	NULL as MtdNetReforecastQ3,
	
	NULL as YtdGrossActual,	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as YtdGrossBudget,
	
	NULL as YtdGrossReforecastQ1,
	NULL as YtdGrossReforecastQ2,
	NULL as YtdGrossReforecastQ3,
	
	NULL as YtdNetActual, 
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as YtdNetBudget,
    
	NULL as YtdNetReforecastQ1,
	NULL as YtdNetReforecastQ2,
	NULL as YtdNetReforecastQ3,
	
	SUM(er.Rate * pb.LocalBudget) as AnnualGrossBudget,
	
	NULL as AnnualGrossReforecastQ1,
	NULL as AnnualGrossReforecastQ2,
	NULL as AnnualGrossReforecastQ3,

	SUM(er.Rate * r.MultiplicationFactor * pb.LocalBudget) as AnnualNetBudget,
	
	NULL as AnnualNetReforecastQ1,
	NULL as AnnualNetReforecastQ2,
	NULL as AnnualNetReforecastQ3,	

	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as AnnualEstGrossBudget,
	
	NULL as AnnualEstGrossReforecastQ1,
	NULL as AnnualEstGrossReforecastQ2,
	NULL as AnnualEstGrossReforecastQ3,

	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
    
	NULL as AnnualEstNetReforecastQ1,
	NULL as AnnualEstNetReforecastQ2,
	NULL as AnnualEstNetReforecastQ3
FROM
	ProfitabilityBudget pb

	INNER JOIN Overhead oh ON oh.OverheadKey = pb.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1
	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pb.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pb.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pb.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pb.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pb.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pb.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pb.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pb.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

	INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pb.CalendarKey
    INNER JOIN Source s ON s.SourceKey = pb.SourceKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pb.ReimbursableKey ''
        
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pb.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey'' ELSE '''' END + ''
	
WHERE  1 = 1 
    AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
 	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
 	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
Group By
	pb.ActivityTypeKey,
    gac.GlAccountCategoryKey,
    pb.AllocationRegionKey,
    pb.OriginatingRegionKey,
    pb.FunctionalDepartmentKey,
    pb.PropertyFundKey,
    s.SourceName,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pb.GlAccountKey END
'')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LEN(@cmdString)) + '''')

PRINT @cmdString
EXEC (@cmdString)

-- Get reforecast information
SET @cmdString = (Select ''
INSERT INTO #BudgetOriginatorOwnerEntity
SELECT
	pr.ActivityTypeKey, 
    gac.GlAccountCategoryKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.FunctionalDepartmentKey,
    pr.PropertyFundKey,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    '''''''' as PropertyFundCode,
    '''''''' as OriginatingRegionCode,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END,
    '''''''' as CalendarPeriod,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecastQ1,
	NULL as MtdGrossReforecastQ2,
	NULL as MtdGrossReforecastQ3,
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecastQ1,
	NULL as MtdNetReforecastQ2,
	NULL as MtdNetReforecastQ3,
	
	NULL as YtdGrossActual,	
	NULL as YtdGrossBudget,
	
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecastQ1, 
	NULL as YtdGrossReforecastQ2,
	NULL as YtdGrossReforecastQ3,
	
	NULL as YtdNetActual, 
	NULL as YtdNetBudget, 
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecastQ1,
    NULL as YtdNetReforecastQ2,
    NULL as YtdNetReforecastQ3,
	
	NULL as AnnualGrossBudget,'' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ1,
    NULL as AnnualGrossReforecastQ2,
    NULL as AnnualGrossReforecastQ3,

	NULL as AnnualNetBudget,'' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecastQ1,
    NULL as AnnualNetReforecastQ2,
    NULL as AnnualNetReforecastQ3,

	NULL as AnnualEstGrossBudget,	
	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstGrossReforecastQ1,
    NULL as AnnualEstGrossReforecastQ2,
    NULL as AnnualEstGrossReforecastQ3,

	NULL as AnnualEstNetBudget,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstNetReforecastQ1,
    NULL as AnnualEstNetReforecastQ2,
    NULL as AnnualEstNetReforecastQ3

FROM
	ProfitabilityReforecast pr

	INNER JOIN Overhead oh ON oh.OverheadKey = pr.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1
	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

	INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pr.CalendarKey
    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
    INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pr.ReimbursableKey ''
        
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + ''
	
WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND ref.ReforecastEffectivePeriod = '' + STR(@ReforecastEffectivePeriodQ1,10,0) + ''
 	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
 	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
GROUP BY
	pr.ActivityTypeKey,
    gac.GlAccountCategoryKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.FunctionalDepartmentKey,
    pr.PropertyFundKey,
    s.SourceName,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END
'')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LEN(@cmdString)) + '''')

PRINT @cmdString
EXEC (@cmdString)

-- Q2 -----------------------------------------------------------------------------------------------------
SET @cmdString = (Select ''
INSERT INTO #BudgetOriginatorOwnerEntity
SELECT
	pr.ActivityTypeKey, 
    gac.GlAccountCategoryKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.FunctionalDepartmentKey,
    pr.PropertyFundKey,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    '''''''' as PropertyFundCode,
    '''''''' as OriginatingRegionCode,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END,
    '''''''' as CalendarPeriod,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	
	NULL as MtdGrossReforecastQ1,
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecastQ2,
	NULL as MtdGrossReforecastQ3,
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
	
	NULL as MtdNetReforecastQ1,
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecastQ2,
	NULL as MtdNetReforecastQ3,
	
	NULL as YtdGrossActual,	
	NULL as YtdGrossBudget,
	
	NULL as YtdGrossReforecastQ1,
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecastQ2, 
	NULL as YtdGrossReforecastQ3,
	
	NULL as YtdNetActual, 
	NULL as YtdNetBudget,
	
	NULL as YtdNetReforecastQ1,
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecastQ2,
    NULL as YtdNetReforecastQ3,
	
	NULL as AnnualGrossBudget,'' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''NULL as AnnualGrossReforecastQ1,
    SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ2,    
    NULL as AnnualGrossReforecastQ3,

	NULL as AnnualNetBudget,'' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''NULL as AnnualNetReforecastQ1,
    SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecastQ2,    
    NULL as AnnualNetReforecastQ3,

	NULL as AnnualEstGrossBudget,	
	
	NULL as AnnualEstGrossReforecastQ1,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstGrossReforecastQ2,
    NULL as AnnualEstGrossReforecastQ3,

	NULL as AnnualEstNetBudget,
	
	NULL as AnnualEstNetReforecastQ1,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstNetReforecastQ2,
    NULL as AnnualEstNetReforecastQ3

FROM
	ProfitabilityReforecast pr

	INNER JOIN Overhead oh ON oh.OverheadKey = pr.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1
	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

	INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pr.CalendarKey
    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
    INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pr.ReimbursableKey ''
        
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + ''
	
WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND ref.ReforecastEffectivePeriod = '' + STR(@ReforecastEffectivePeriodQ2,10,0) + ''
 	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
 	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
GROUP BY
	pr.ActivityTypeKey,
    gac.GlAccountCategoryKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.FunctionalDepartmentKey,
    pr.PropertyFundKey,
    s.SourceName,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END
'')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LEN(@cmdString)) + '''')

PRINT @cmdString
EXEC (@cmdString)

-- Q3 -----------------------------------------------------------------------------------------------------
SET @cmdString = (Select ''
INSERT INTO #BudgetOriginatorOwnerEntity
SELECT
	pr.ActivityTypeKey, 
    gac.GlAccountCategoryKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.FunctionalDepartmentKey,
    pr.PropertyFundKey,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    '''''''' as PropertyFundCode,
    '''''''' as OriginatingRegionCode,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END,
    '''''''' as CalendarPeriod,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	
	NULL as MtdGrossReforecastQ1,
	NULL as MtdGrossReforecastQ2,
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecastQ3,
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
	
	NULL as MtdNetReforecastQ1,
	NULL as MtdNetReforecastQ2,
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecastQ3,
	
	NULL as YtdGrossActual,	
	NULL as YtdGrossBudget,
	
	NULL as YtdGrossReforecastQ1,
	NULL as YtdGrossReforecastQ2,
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecastQ3,
	
	NULL as YtdNetActual, 
	NULL as YtdNetBudget,
	
	NULL as YtdNetReforecastQ1,
	NULL as YtdNetReforecastQ2,
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecastQ3,
	
	NULL as AnnualGrossBudget,'' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''NULL as AnnualGrossReforecastQ1,
    NULL as AnnualGrossReforecastQ2,
    SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ3,

	NULL as AnnualNetBudget,'' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''NULL as AnnualNetReforecastQ1,
    NULL as AnnualNetReforecastQ2,
    SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecastQ3,

	NULL as AnnualEstGrossBudget,	
	
	NULL as AnnualEstGrossReforecastQ1,
	NULL as AnnualEstGrossReforecastQ2,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstGrossReforecastQ3,

	NULL as AnnualEstNetBudget,
	
	NULL as AnnualEstNetReforecastQ1,
	NULL as AnnualEstNetReforecastQ2,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstNetReforecastQ3

FROM
	ProfitabilityReforecast pr

	INNER JOIN Overhead oh ON oh.OverheadKey = pr.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1
	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

	INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pr.CalendarKey
    INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
    INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pr.ReimbursableKey ''
        
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + ''
	
WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND ref.ReforecastEffectivePeriod = '' + STR(@ReforecastEffectivePeriodQ3,10,0) + ''
 	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
 	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
Group By
	pr.ActivityTypeKey,
    gac.GlAccountCategoryKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.FunctionalDepartmentKey,
    pr.PropertyFundKey,
    s.SourceName,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END
'')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LEN(@cmdString)) + '''')

print @cmdString
EXEC (@cmdString)
-------------------------------------------------------------------------------------------------------


--Entity Mode
SELECT 
	aty.ActivityTypeName as ActivityTypeName,
	aty.ActivityTypeName as ActivityTypeFilterName,
    gac.AccountSubTypeName as ExpenseType,
    ar.RegionName AS AllocationRegionName,
    ar.SubRegionName AS AllocationSubRegionName,
    ar.SubRegionName AS AllocationSubRegionFilterName,
    orr.RegionName AS OriginatingRegionName,
    orr.SubRegionName AS OriginatingSubRegionName,
    orr.SubRegionName AS OriginatingSubRegionFilterName,
    --NB!!!!!!!
    --The roll up to payroll is very sensitive information. It is crutial that information regarding payroll not 
    --get communicated to TS employees.
    CASE WHEN (gac.MajorCategoryName = ''Salaries/Taxes/Benefits'') THEN ''Payroll'' ELSE fd.FunctionalDepartmentName END AS FunctionalDepartmentName,
    gac.MajorCategoryName AS MajorExpenseCategoryName,
    gac.MinorCategoryName AS MinorExpenseCategoryName,
    pf.PropertyFundType AS EntityType,
    pf.PropertyFundName AS EntityName,
    res.CalendarPeriod AS ActualsExpensePeriod,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
	res.SourceName AS SourceName,
	res.PropertyFundCode,
    res.OriginatingRegionCode,
	ISNULL(ga.Code, '''') GlAccountCode,
    ISNULL(ga.Name, '''') GlAccountName,
	
	--Month to date    
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossActual,0) ELSE ISNULL(MtdNetActual,0) END) AS MtdActual,
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossBudget,0) ELSE ISNULL(MtdNetBudget,0) END) AS MtdOriginalBudget,
	
	----------
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ1
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ1
		END,0) 
	END) AS MtdReforecastQ1,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ2
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ2
		END,0) 
	END) AS MtdReforecastQ2,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ3
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ3
		END,0) 
	END) AS MtdReforecastQ3,	
	
	----------
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ1
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ1
		END, 0) - ISNULL(MtdNetActual, 0) 
	END) AS MtdVarianceQ1,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ2
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ2
		END, 0) - ISNULL(MtdNetActual, 0) 
	END) AS MtdVarianceQ2,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ3
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ3
		END, 0) - ISNULL(MtdNetActual, 0) 
	END) AS MtdVarianceQ3,		
	
	----------
	
	--Year to date
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossActual,0) ELSE ISNULL(YtdNetActual,0) END) AS YtdActual,	
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossBudget,0) ELSE ISNULL(YtdNetBudget,0) END) AS YtdOriginalBudget,
	
	----------
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ1 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ1 
		END,0) 
	END) AS YtdReforecastQ1,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ2
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ2
		END,0) 
	END) AS YtdReforecastQ2,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ3
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ3
		END,0) 
	END) AS YtdReforecastQ3,	
	----------
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ1
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ1
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) AS YtdVarianceQ1,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ2
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ2
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) AS YtdVarianceQ2,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ3
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ3
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) AS YtdVarianceQ3,
	
	----------
	
	--Annual
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(AnnualGrossBudget,0) ELSE ISNULL(AnnualNetBudget,0) END) AS AnnualOriginalBudget,	
	----------
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecastQ1 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecastQ1
		END,0) 
	END) AS AnnualReforecastQ1,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecastQ2
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecastQ2
		END,0) 
	END) AS AnnualReforecastQ2,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecastQ3
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecastQ3
		END,0) 
	END) AS AnnualReforecastQ3
	--
	
INTO
	#Output
FROM
	#BudgetOriginatorOwnerEntity res
		INNER JOIN AllocationRegion ar ON ar.AllocationRegionKey = res.AllocationRegionKey
		INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = res.OriginatingRegionKey
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentKey = res.FunctionalDepartmentKey
		INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = res.GlAccountCategoryKey
		INNER JOIN PropertyFund pf ON pf.PropertyFundKey = res.PropertyFundKey
		INNER JOIN ActivityType aty ON aty.ActivityTypeKey = res.ActivityTypeKey
		LEFT OUTER JOIN GlAccount ga ON ga.GlAccountKey = res.GlAccountKey 
GROUP BY
	aty.ActivityTypeName,
    gac.AccountSubTypeName,
    ar.RegionName,
    ar.SubRegionName,
    orr.RegionName,
    orr.SubRegionName,
    --NB!!!!!!!
    --The roll up to payroll is very sensitive information. It is crutial that information regarding payroll not 
    --get communicated to TS employees.
    CASE WHEN (gac.MajorCategoryName = ''Salaries/Taxes/Benefits'') THEN ''Payroll'' ELSE fd.FunctionalDepartmentName END,
    gac.MajorCategoryName,
    gac.MinorCategoryName,
    pf.PropertyFundType,
    pf.PropertyFundName,
    res.CalendarPeriod,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
    res.SourceName,
    res.PropertyFundCode,
    res.OriginatingRegionCode,
    ISNULL(ga.Code, ''''),
    ISNULL(ga.Name, '''')

--Output
SELECT
	ActivityTypeName,
	ActivityTypeFilterName,
    ExpenseType,
    AllocationRegionName,
    AllocationSubRegionName,
    AllocationSubRegionFilterName,
    OriginatingRegionName,
    OriginatingSubRegionName,
    OriginatingSubRegionFilterName,
    FunctionalDepartmentName,
    MajorExpenseCategoryName,
    MinorExpenseCategoryName,
    EntityType,
    EntityName,
    ActualsExpensePeriod,
    EntryDate,
    [User],
    [Description],
    AdditionalDescription,
	SourceName,
	PropertyFundCode,
    OriginatingRegionCode,
    GlAccountCode,
    GlAccountName,
	
	--Month to date    
	MtdActual,
	MtdOriginalBudget,
	
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE MtdReforecastQ1 END AS MtdReforecastQ1,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE MtdReforecastQ2 END AS MtdReforecastQ2,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE MtdReforecastQ3 END AS MtdReforecastQ3,
	
	MtdVarianceQ1,
	MtdVarianceQ2,
	MtdVarianceQ3,
	
	--Year to date
	YtdActual,
	YtdOriginalBudget,
	
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE YtdReforecastQ1 END AS YtdReforecastQ1,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE YtdReforecastQ2 END AS YtdReforecastQ2,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE YtdReforecastQ3 END AS YtdReforecastQ3,
	
	YtdVarianceQ1,
	YtdVarianceQ2,
	YtdVarianceQ3,
	--Annual
	AnnualOriginalBudget,
	
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE AnnualReforecastQ1 END AS AnnualReforecastQ1,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE AnnualReforecastQ2 END AS AnnualReforecastQ2,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE AnnualReforecastQ3 END AS AnnualReforecastQ3
	
	--Annual Estimated
	--AnnualEstimatedActual,
	--AnnualEstimatedVariance
FROM
	#Output
WHERE
	--Month to date    
	MtdActual <> 0.00 OR
	MtdOriginalBudget <> 0.00 OR
	
	--MtdReforecastQ1 <> 0.00 OR
	--MtdReforecastQ2 <> 0.00 OR
	--MtdReforecastQ3 <> 0.00 OR
	
	--MtdVarianceQ1 <> 0.00 OR
	--MtdVarianceQ2 <> 0.00 OR
	MtdVarianceQ3 <> 0.00 OR
	--Year to date
	YtdActual <> 0.00 OR
	YtdOriginalBudget <> 0.00 OR
	
	--YtdReforecastQ1 <> 0.00 OR
	--YtdReforecastQ2 <> 0.00 OR
	--YtdReforecastQ3 <> 0.00 OR
	
	--YtdVarianceQ1 <> 0.00 OR
	--YtdVarianceQ2 <> 0.00 OR
	YtdVarianceQ3 <> 0.00 OR
	--Annual
	AnnualOriginalBudget <> 0.00
	
	--AnnualReforecastQ1 <> 0.00 OR
	--AnnualReforecastQ2 <> 0.00 OR
	--AnnualReforecastQ3 <> 0.00
	--Annual Estimated
	--AnnualEstimatedActual <> 0.00 OR
	--AnnualEstimatedVariance <> 0.00

IF 	OBJECT_ID(''tempdb..#BudgetOriginatorOwnerEntity'') IS NOT NULL
    DROP TABLE #BudgetOriginatorOwnerEntity

IF 	OBJECT_ID(''tempdb..#Output'') IS NOT NULL
    DROP TABLE #Output

IF 	OBJECT_ID(''tempdb..#EntityFilterTable'') IS NOT NULL
	DROP TABLE	#EntityFilterTable

IF 	OBJECT_ID(''tempdb..#FunctionalDepartmentFilterTable'') IS NOT NULL
	DROP TABLE	#FunctionalDepartmentFilterTable
	
IF 	OBJECT_ID(''tempdb..#ActivityTypeFilterTable'') IS NOT NULL	
	DROP TABLE	#ActivityTypeFilterTable
	
IF 	OBJECT_ID(''tempdb..#AllocationRegionFilterTable'') IS NOT NULL	
	DROP TABLE	#AllocationRegionFilterTable
	
IF 	OBJECT_ID(''tempdb..#AllocationSubRegionFilterTable'') IS NOT NULL	
	DROP TABLE	#AllocationSubRegionFilterTable
	
IF 	OBJECT_ID(''tempdb..#MajorAccountCategoryFilterTable'') IS NOT NULL	
	DROP TABLE	#MajorAccountCategoryFilterTable

IF 	OBJECT_ID(''tempdb..#MinorAccountCategoryFilterTable'') IS NOT NULL	
	DROP TABLE	#MinorAccountCategoryFilterTable
	
IF 	OBJECT_ID(''tempdb..#OriginatingRegionFilterTable'') IS NOT NULL	
	DROP TABLE	#OriginatingRegionFilterTable

IF 	OBJECT_ID(''tempdb..#OriginatingSubRegionFilterTable'') IS NOT NULL	
	DROP TABLE	#OriginatingSubRegionFilterTable

IF 	OBJECT_ID(''tempdb..#ReforecastsEffectivePeriods'') IS NOT NULL	
	DROP TABLE #ReforecastsEffectivePeriods

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginator]    Script Date: 01/25/2011 14:18:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOriginator]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_R_BudgetOriginator]
	@ReportExpensePeriod INT = NULL,
	@ReforecastQuaterName VARCHAR(10) = NULL, --''Q1'' or ''Q2'' or ''Q3''
	@DestinationCurrency VARCHAR(3) = NULL,
	@TranslationTypeName VARCHAR(50) = ''Global'',
	@IsGross bit = 1,
	@FunctionalDepartmentList TEXT = NULL,
	@ActivityTypeList TEXT = NULL,
	@EntityList TEXT = NULL,
	@MajorAccountCategoryList TEXT = NULL,
	@MinorAccountCategoryList TEXT = NULL,
	@AllocationRegionList TEXT = NULL,
	@AllocationSubRegionList TEXT = NULL,
	@OriginatingRegionList TEXT = NULL,
	@OriginatingSubRegionList TEXT = NULL,
	@OverheadCode Varchar(10)=''UNALLOC''

AS

DECLARE
	@_ReportExpensePeriod INT = @ReportExpensePeriod,
	@_ReforecastQuaterName VARCHAR(10) = @ReforecastQuaterName,
	@_DestinationCurrency VARCHAR(3) = @DestinationCurrency,
	@_TranslationTypeName VARCHAR(50) = @TranslationTypeName,
	@_IsGross bit = @IsGross,
	@_FunctionalDepartmentList VARCHAR(8000) = @FunctionalDepartmentList,
	@_ActivityTypeList VARCHAR(8000) = @ActivityTypeList,
	@_EntityList VARCHAR(8000) = @EntityList,
	@_MajorAccountCategoryList VARCHAR(8000) = @MajorAccountCategoryList,
	@_MinorAccountCategoryList VARCHAR(8000) = @MinorAccountCategoryList,
	@_AllocationRegionList VARCHAR(8000) = @AllocationRegionList,
	@_AllocationSubRegionList VARCHAR(8000) = @AllocationSubRegionList,
	@_OriginatingRegionList VARCHAR(8000) = @OriginatingRegionList,
	@_OriginatingSubRegionList VARCHAR(8000) = @OriginatingSubRegionList
	
IF LEN(@_FunctionalDepartmentList) > 7998 OR
	LEN(@_ActivityTypeList) > 7998 OR
	LEN(@_EntityList) > 7998 OR
	LEN(@_MajorAccountCategoryList) > 7998 OR
	LEN(@_MinorAccountCategoryList) > 7998 OR
	LEN(@_AllocationRegionList) > 7998 OR
	LEN(@_AllocationSubRegionList) > 7998 OR
	LEN(@_OriginatingRegionList) > 7998 OR
	LEN(@_OriginatingSubRegionList) > 7998
BEGIN
	RAISERROR(''Filter List parameter is to big'',19,1)
END
	
/*
DECLARE @ReportExpensePeriod		AS INT,
        @FunctionalDepartmentList  AS VARCHAR(8000),
        @DestinationCurrency		AS VARCHAR(3),
        @TranslationTypeName				VARCHAR(50)
				
		
SET @ReportExpensePeriod = 201011
SET @FunctionalDepartmentList = ''Information Technologies''
SET @DestinationCurrency = ''USD''
SET @TranslationTypeName = ''Global''

EXEC stp_R_BudgetOriginatorOwnerFunctionalDepartment
	@ReportExpensePeriod = 201011,
	@TranslationTypeName = ''Global'',
	@DestinationCurrency = ''USD'',

	@FunctionalDepartmentList = ''Information Technologies'',
	@AllocationRegionList = ''CHICAGO'',
	@EntityList = ''Aldgate|Centrium (St Cathrine House/Pegasus)''

*/

--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Variable defaults		*/
--------------------------------------------------------------------------

IF @ReportExpensePeriod IS NULL
	SET @ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + REPLACE(STR(MONTH(GETDATE()),2 ),'' '',''0'')AS INT)

IF @DestinationCurrency IS NULL
	SET @DestinationCurrency = ''USD''

IF 	@TranslationTypeName IS NULL
	SET @TranslationTypeName = ''Global''

	DECLARE @CalendarYear AS INT
	SET @CalendarYear = CAST(SUBSTRING(CAST(@ReportExpensePeriod AS VARCHAR(10)), 1, 4) AS INT)				

--------------------------------------------------------------------------
-- let latest reforecast (it will be zero if there is no data for the reforecast)
IF @ReforecastQuaterName IS NULL OR @ReforecastQuaterName NOT IN (''Q0'', ''Q1'', ''Q2'', ''Q3'')
	SET @ReforecastQuaterName = (SELECT TOP 1
									ReforecastQuarterName 
								 FROM
									dbo.Reforecast 
								 WHERE
									ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
									ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
								 ORDER BY ReforecastEffectivePeriod DESC)
--------------------------------------------------------------------------
-- Compute Reforecast Effective Periods

DECLARE @ReforecastEffectivePeriodQ1 INT
DECLARE @ReforecastEffectivePeriodQ2 INT
DECLARE @ReforecastEffectivePeriodQ3 INT

SET @ReforecastEffectivePeriodQ1 = (SELECT TOP 1
										ReforecastEffectivePeriod 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										ReforecastQuarterName = ''Q1''
									ORDER BY
										ReforecastEffectivePeriod)								

SET @ReforecastEffectivePeriodQ2 = (SELECT TOP 1
										ReforecastEffectivePeriod 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										ReforecastQuarterName = ''Q2''
									ORDER BY
										ReforecastEffectivePeriod)								

SET @ReforecastEffectivePeriodQ3 = (SELECT TOP 1
										ReforecastEffectivePeriod 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										ReforecastQuarterName = ''Q3''
									ORDER BY
										ReforecastEffectivePeriod)

-- Retrieve Reforecast Quarter Name

DECLARE @ReforecastQuarterNameQ1 CHAR(2)
DECLARE @ReforecastQuarterNameQ2 CHAR(2)
DECLARE @ReforecastQuarterNameQ3 CHAR(2)

IF (@ReforecastEffectivePeriodQ1 IS NOT NULL)
BEGIN
	SET @ReforecastQuarterNameQ1 = (SELECT TOP 1
										ReforecastQuarterName 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectivePeriod = @ReforecastEffectivePeriodQ1)
END
ELSE
BEGIN
	PRINT (''@ReforecastEffectivePeriodQ1 is NULL - cannot determine Q1 reforecast quarter name.'')
END


IF (@ReforecastEffectivePeriodQ2 IS NOT NULL)
BEGIN
	SET @ReforecastQuarterNameQ2 = (SELECT TOP 1
											ReforecastQuarterName 
										FROM
											dbo.Reforecast 
										WHERE
											ReforecastEffectivePeriod = @ReforecastEffectivePeriodQ2)
END
ELSE
BEGIN
	PRINT (''@ReforecastEffectivePeriodQ2 is NULL - cannot determine Q2 reforecast quarter name.'')
END


IF (@ReforecastEffectivePeriodQ3 IS NOT NULL)
BEGIN
	SET @ReforecastQuarterNameQ3 = (SELECT TOP 1
											ReforecastQuarterName 
										FROM
											dbo.Reforecast 
										WHERE
											ReforecastEffectivePeriod = @ReforecastEffectivePeriodQ3)
END
ELSE
BEGIN
	PRINT (''@ReforecastEffectivePeriodQ3 is NULL - cannot determine Q3 reforecast quarter name.'')
END
	
--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Tables		*/
--------------------------------------------------------------------------
	
CREATE TABLE #EntityFilterTable	(PropertyFundKey Int NOT NULL)
CREATE TABLE #FunctionalDepartmentFilterTable (FunctionalDepartmentKey Int NOT NULL)
CREATE TABLE #ActivityTypeFilterTable (ActivityTypeKey Int NOT NULL)
CREATE TABLE #AllocationRegionFilterTable (AllocationRegionKey Int NOT NULL)
CREATE TABLE #AllocationSubRegionFilterTable (AllocationRegionKey Int NOT NULL)
CREATE TABLE #MajorAccountCategoryFilterTable (GlAccountCategoryKey Int NOT NULL)	
CREATE TABLE #MinorAccountCategoryFilterTable (GlAccountCategoryKey Int NOT NULL)	
CREATE TABLE #OriginatingRegionFilterTable (OriginatingRegionKey Int NOT NULL)
CREATE TABLE #OriginatingSubRegionFilterTable (OriginatingRegionKey Int NOT NULL)	
	
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable	(PropertyFundKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable(ActivityTypeKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationRegionFilterTable	(AllocationRegionKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MajorAccountCategoryFilterTable(GlAccountCategoryKey)	
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MinorAccountCategoryFilterTable(GlAccountCategoryKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingRegionFilterTable	(OriginatingRegionKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable	(OriginatingRegionKey)
	
IF (@EntityList IS NOT NULL)
	BEGIN
	Insert Into #EntityFilterTable
	Select pf.PropertyFundKey
	From dbo.Split(@_EntityList) t1
		INNER JOIN PropertyFund pf ON pf.PropertyFundName = t1.item
	END
	
IF (@FunctionalDepartmentList IS NOT NULL)
	BEGIN
	Insert Into #FunctionalDepartmentFilterTable
	Select fd.FunctionalDepartmentKey 
	From dbo.Split(@_FunctionalDepartmentList) t1
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentName = t1.item
	END

IF 	(@ActivityTypeList IS NOT NULL)
	BEGIN
    INSERT INTO #ActivityTypeFilterTable
    SELECT at.ActivityTypeKey 
    FROM dbo.Split(@_ActivityTypeList) t1
		INNER JOIN ActivityType at ON at.ActivityTypeName = t1.item
	END
	
IF (@AllocationRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationRegionFilterTable
	Select ar.AllocationRegionKey 
	From dbo.Split(@_AllocationRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.RegionName = t1.item
	END

IF (@AllocationSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationSubRegionFilterTable
	Select ar.AllocationRegionKey
	From dbo.Split(@_AllocationSubRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.SubRegionName = t1.item
	END

IF (@MajorAccountCategoryList IS NOT NULL)
	BEGIN
	Insert Into #MajorAccountCategoryFilterTable
	Select gl.GlAccountCategoryKey 
	From dbo.Split(@_MajorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MajorCategoryName = t1.item
	END
	
IF 	(@MinorAccountCategoryList IS NOT NULL)
	BEGIN
    INSERT INTO #MinorAccountCategoryFilterTable
    SELECT gl.GlAccountCategoryKey 
    FROM dbo.Split(@MinorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MinorCategoryName = t1.item
	END	

IF (@OriginatingRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingRegionFilterTable
	Select orr.OriginatingRegionKey 
	From dbo.Split(@_OriginatingRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.RegionName = t1.item
	END

IF (@OriginatingSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingSubRegionFilterTable
	Select orr.OriginatingRegionKey  
	From dbo.Split(@OriginatingSubRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.SubRegionName = t1.item
	END		
--------------------------------------------------------------------------
/*	COMMON END															*/
--------------------------------------------------------------------------
	
IF 	OBJECT_ID(''tempdb..#BudgetOriginatorOwner'') IS NOT NULL
    DROP TABLE #BudgetOriginatorOwner

CREATE TABLE #BudgetOriginatorOwner
(	
	ActivityTypeKey			INT,
	AllocationRegionKey		INT,
	OriginatingRegionKey	INT,
    PropertyFundKey			INT,
    FunctionalDepartmentKey INT,    
	GlAccountCategoryKey	INT,
	SourceName				VARCHAR(50),
	EntryDate				VARCHAR(10),
	[User]					NVARCHAR(20),
	[Description]			NVARCHAR(60),
	AdditionalDescription	NVARCHAR(4000),
	PropertyFundCode		VARCHAR(6) DEFAULT(''''), --Varchar, for this helps to keep reports size smaller
	OriginatingRegionCode	VARCHAR(15) DEFAULT(''''), --Varchar, for this helps to keep reports size smaller
	GlAccountKey			INT NULL,
	CalendarPeriod			Varchar(6) DEFAULT(''''),

	--Month to date	
	MtdGrossActual			MONEY,
	MtdGrossBudget			MONEY,
	MtdGrossReforecastQ1	MONEY,
	MtdGrossReforecastQ2	MONEY,
	MtdGrossReforecastQ3	MONEY,
	MtdNetActual			MONEY,
	MtdNetBudget			MONEY,
	MtdNetReforecastQ1		MONEY,
	MtdNetReforecastQ2		MONEY,
	MtdNetReforecastQ3		MONEY,
	
	--Year to date
	YtdGrossActual			MONEY,	
	YtdGrossBudget			MONEY, 
	YtdGrossReforecastQ1	MONEY,
	YtdGrossReforecastQ2	MONEY,
	YtdGrossReforecastQ3	MONEY,
	YtdNetActual			MONEY, 
	YtdNetBudget			MONEY, 
	YtdNetReforecastQ1		MONEY,
	YtdNetReforecastQ2		MONEY,
	YtdNetReforecastQ3		MONEY,
	
	--Annual
	AnnualGrossBudget		MONEY,
	AnnualGrossReforecastQ1	MONEY,
	AnnualGrossReforecastQ2 MONEY,
	AnnualGrossReforecastQ3 MONEY,
	AnnualNetBudget			MONEY,
	AnnualNetReforecastQ1	MONEY,
	AnnualNetReforecastQ2	MONEY,
	AnnualNetReforecastQ3	MONEY,

	--Annual estimated
	AnnualEstGrossBudget	 MONEY,
	AnnualEstGrossReforecastQ1 MONEY,
	AnnualEstGrossReforecastQ2 MONEY,
	AnnualEstGrossReforecastQ3 MONEY,
	AnnualEstNetBudget		 MONEY,
	AnnualEstNetReforecastQ1 MONEY,
	AnnualEstNetReforecastQ2 MONEY,
	AnnualEstNetReforecastQ3 MONEY
)

DECLARE @cmdString Varchar(MAX)

--Get actual information
SET @cmdString = (Select ''

INSERT INTO #BudgetOriginatorOwner
SELECT 	
	pa.ActivityTypeKey,
	pa.AllocationRegionKey,
	pa.OriginatingRegionKey,
    pa.PropertyFundKey,
    pa.FunctionalDepartmentKey,    
	gac.GlAccountCategoryKey,
    s.SourceName,
    CONVERT(varchar(10),ISNULL(pa.EntryDate,''''''''), 101) as EntryDate,
    ISNULL(pa.[User], '''''''') [User],
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.Description ELSE '''''''' END as Description,
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.AdditionalDescription ELSE '''''''' END as AdditionalDescription,
    ISNULL(pa.PropertyFundCode, '''''''') PropertyFundCode,
    ISNULL(pa.OriginatingRegionCode, '''''''') OriginatingRegionCode,
    pa.GLAccountKey,
    c.CalendarPeriod,
    
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdGrossActual,
	NULL as MtdGrossBudget,
	
	'' + /*-- ReforecastEffectivePeriod --------------------------*/ + ''
	
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + -- < because we are selecting from ProfitabilityActual
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdGrossReforecastQ1,

	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + -- < because we are selecting from ProfitabilityActual
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdGrossReforecastQ2,

	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + -- < because we are selecting from ProfitabilityActual
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdGrossReforecastQ3,
	
	'' + /*-- ReforecastEffectivePeriod End ----------------------*/ + ''
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdNetActual,
	NULL as MtdNetBudget,
	
	'' + /*-- MtdNetReforecast --------------------------*/ + ''
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdNetReforecastQ1,

	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdNetReforecastQ2,
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdNetReforecastQ3,	
	
	'' + /*-- MtdNetReforecast End --------------------------*/ + ''
	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdGrossActual,
	NULL as YtdGrossBudget,
	
	'' + /*-- YTDGrossReforecast --------------------------*/ + ''
	
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdGrossReforecastQ1,

	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdGrossReforecastQ2,

	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdGrossReforecastQ3,

	'' + /*-- YTDGrossReforecast End ----------------------*/ + ''
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdNetActual,
	NULL as YtdNetBudget,
	'')
	
	DECLARE @cmdString2 Varchar(MAX)
	SET @cmdString2 = (Select ''
	
	
	'' + /*-- YtdNetReforecast ----------------------*/ + ''
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdNetReforecastQ1,

	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdNetReforecastQ2,

	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as YtdNetReforecastQ3,

	'' +
	
	/*-- YtdNetReforecast End ------------------*/ + ''
	

	NULL as AnnualGrossBudget,
	
	'' + /*-- AnnualGrossReforecast ------------------*/ + ''
	
	SUM(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualGrossReforecastQ1,
	
	SUM(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualGrossReforecastQ2,

	SUM(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualGrossReforecastQ3,

	'' + /*-- AnnualGrossReforecast End ------------------*/ + ''

	'')

	DECLARE @cmdString3 Varchar(MAX)
	SET @cmdString3 = (Select ''

	NULL as AnnualNetBudget,
	
	'' + /*-- AnnualNetReforecast ------------------*/ + ''
	
    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ1,
	
    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ2,

    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ3,

	'' + /*-- AnnualNetReforecast End ------------------*/ + ''
	
	SUM(
        er.Rate *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pa.LocalActual
        ELSE 
			0
        END
	) as AnnualEstGrossBudget,
	
	'' + /*-- AnnualEstGrossReforecast ------------------*/ + ''
	
	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecastQ1,

	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecastQ2,
	
	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecastQ3,	

	'' + /*-- AnnualEstGrossReforecast End ------------------*/ + ''

    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
    
    '' + /*-- AnnualEstNetReforecast ------------------*/ + ''
    
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstNetReforecastQ1,
	
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstNetReforecastQ2,
	
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstNetReforecastQ3		

	'' + /*-- AnnualEstNetReforecast End ------------------*/ + ''
	
FROM
	ProfitabilityActual pa

	INNER JOIN Overhead oh ON oh.OverheadKey = pa.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1

	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pa.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pa.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pa.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pa.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pa.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pa.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pa.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pa.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')
	
    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pa.CalendarKey
    INNER JOIN Source s ON s.SourceKey = pa.SourceKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pa.ReimbursableKey ''
    		
    + CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pa.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pa.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pa.PropertyFundKey'' ELSE '''' END + ''

WHERE  1 = 1
    AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
 	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
 	AND gac.MinorCategoryName <> ''''Bonus''''
 	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select t1.FunctionalDepartmentKey From #FunctionalDepartmentFilterTable t1)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select t1.ActivityTypeKey From #ActivityTypeFilterTable t1)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select t1.PropertyFundKey From #EntityFilterTable t1)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationRegionFilterTable t1)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationSubRegionFilterTable t1)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MajorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MinorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingRegionFilterTable t1)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingSubRegionFilterTable t1)'' END +
''
GROUP BY
	pa.ActivityTypeKey,
	pa.AllocationRegionKey,
	pa.OriginatingRegionKey,
    pa.PropertyFundKey,
    pa.FunctionalDepartmentKey,
	gac.GlAccountCategoryKey,
	s.SourceName,
	CONVERT(varchar(10),ISNULL(pa.EntryDate,''''''''), 101),
	ISNULL(pa.[User], '''''''') ,
	CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.Description ELSE '''''''' END,
	CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.AdditionalDescription ELSE '''''''' END,
	ISNULL(pa.PropertyFundCode, ''''''''),
    ISNULL(pa.OriginatingRegionCode, ''''''''),
	pa.GlAccountKey,
	c.CalendarPeriod
	
	'')

IF (LEN(@cmdString) > 7995 OR LEN(@cmdString2) > 7995 OR LEN(@cmdString3) > 7995)
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LTRIM(RTRIM(LEN(@cmdString)))) + '' + '' + STR(LTRIM(RTRIM(LEN(@cmdString2)))) + '' + '' + STR(LTRIM(RTRIM(LEN(@cmdString3)))))

PRINT (@cmdString)
PRINT (@cmdString2)
PRINT (@cmdString3)

EXEC (@cmdString + @cmdString2 + @cmdString3)

-- Get budget information
SET @cmdString = (Select ''
INSERT INTO #BudgetOriginatorOwner
SELECT 
	pb.ActivityTypeKey,
	pb.AllocationRegionKey,
	pb.OriginatingRegionKey,
    pb.PropertyFundKey,
    pb.FunctionalDepartmentKey,
	gac.GlAccountCategoryKey,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    '''''''' as PropertyFundCode,
    '''''''' as OriginatingRegionCode,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pb.GlAccountKey END,
    '''''''' as CalendarPeriod,
    
    NULL as MtdGrossActual,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as MtdGrossBudget,
	
	NULL as MtdGrossReforecastQ1,
	NULL as MtdGrossReforecastQ2,
	NULL as MtdGrossReforecastQ3,
	
	NULL as MtdNetActual,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as MtdNetBudget,
    
	NULL as MtdNetReforecastQ1,
	NULL as MtdNetReforecastQ2,
	NULL as MtdNetReforecastQ3,
	
	NULL as YtdGrossActual,	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as YtdGrossBudget,
	
	NULL as YtdGrossReforecastQ1,
	NULL as YtdGrossReforecastQ2,
	NULL as YtdGrossReforecastQ3,
	
	NULL as YtdNetActual, 
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as YtdNetBudget,
    
	NULL as YtdNetReforecastQ1,
	NULL as YtdNetReforecastQ2,
	NULL as YtdNetReforecastQ3,
	
	SUM(er.Rate * pb.LocalBudget) as AnnualGrossBudget,
	
	NULL as AnnualGrossReforecastQ1,
	NULL as AnnualGrossReforecastQ2,
	NULL as AnnualGrossReforecastQ3,

	SUM(er.Rate * r.MultiplicationFactor * pb.LocalBudget) as AnnualNetBudget,
	
	NULL as AnnualNetReforecastQ1,
	NULL as AnnualNetReforecastQ2,
	NULL as AnnualNetReforecastQ3,

	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as AnnualEstGrossBudget,
	
	NULL as AnnualEstGrossReforecastQ1,
	NULL as AnnualEstGrossReforecastQ2,
	NULL as AnnualEstGrossReforecastQ3,

	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
    
	NULL as AnnualEstNetReforecastQ1,
	NULL as AnnualEstNetReforecastQ2,
	NULL as AnnualEstNetReforecastQ3
	
FROM
    ProfitabilityBudget pb

	INNER JOIN Overhead oh ON oh.OverheadKey = pb.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1
    	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pb.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pb.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pb.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pb.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pb.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pb.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pb.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pb.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

    INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey 
	INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey    
	INNER JOIN Calendar c ON  c.CalendarKey = pb.CalendarKey
	INNER JOIN Source s ON s.SourceKey = pb.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pb.ReimbursableKey ''
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pb.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey'' ELSE '''' END + ''
		
WHERE  1 = 1 
    AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Bonus''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
Group By
	pb.ActivityTypeKey,
	pb.AllocationRegionKey,
	pb.OriginatingRegionKey,
    pb.PropertyFundKey,
    pb.FunctionalDepartmentKey,
	gac.GlAccountCategoryKey,
	s.SourceName,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pb.GlAccountKey END
    
'')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LEN(@cmdString)) + '''')

PRINT @cmdString
EXEC (@cmdString)

-- Get reforecast information -------------------------------------------------------------------------------------------------

-- Q1
SET @cmdString = (Select ''
INSERT INTO #BudgetOriginatorOwner
SELECT 
	pr.ActivityTypeKey,
	pr.AllocationRegionKey,
	pr.OriginatingRegionKey,
    pr.PropertyFundKey,
    pr.FunctionalDepartmentKey,
	gac.GlAccountCategoryKey,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    '''''''' as PropertyFundCode,
    '''''''' as OriginatingRegionCode,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END,
    '''''''' as CalendarPeriod,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecastQ1,
	NULL as MtdGrossReforecastQ2,
	NULL as MtdGrossReforecastQ3,
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
	
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecastQ1,
	NULL as MtdNetReforecastQ2,
	NULL as MtdNetReforecastQ3,
	
	NULL as YtdGrossActual,	
	NULL as YtdGrossBudget,
	
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecastQ1,
	NULL as YtdGrossReforecastQ2,
	NULL as YtdGrossReforecastQ3,
	
	NULL as YtdNetActual, 
	NULL as YtdNetBudget,
	
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecastQ1,
    NULL as YtdNetReforecastQ2,
    NULL as YtdNetReforecastQ3,
    
    NULL as AnnualGrossBudget, '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ1,
     NULL as AnnualGrossReforecastQ2,
     NULL as AnnualGrossReforecastQ3,

	NULL as AnnualNetBudget, '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecastQ1,
    NULL as AnnualNetReforecastQ2,
    NULL as AnnualNetReforecastQ3,

	NULL as AnnualEstGrossBudget,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstGrossReforecastQ1,
    NULL as AnnualEstGrossReforecastQ2,
    NULL as AnnualEstGrossReforecastQ3,

	NULL as AnnualEstNetBudget,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstNetReforecastQ1,
    NULL as AnnualEstNetReforecastQ2,
    NULL as AnnualEstNetReforecastQ3
FROM
    ProfitabilityReforecast pr

	INNER JOIN Overhead oh ON oh.OverheadKey = pr.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1
    	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

    INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey 
	INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey    
	INNER JOIN Calendar c ON  c.CalendarKey = pr.CalendarKey
	INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
	INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey ''
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + ''
		
WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND ref.ReforecastEffectivePeriod = '' + STR(@ReforecastEffectivePeriodQ1,6,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Bonus''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
Group By
	pr.ActivityTypeKey,
	pr.AllocationRegionKey,
	pr.OriginatingRegionKey,
    pr.PropertyFundKey,
    pr.FunctionalDepartmentKey,
	gac.GlAccountCategoryKey,
	s.SourceName,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END
    
'')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LEN(@cmdString)) + '''')

PRINT @cmdString
EXEC (@cmdString)


-- Q2 -------------------------------------------------------------------------------------------------
SET @cmdString = (Select ''
INSERT INTO #BudgetOriginatorOwner
SELECT 
	pr.ActivityTypeKey,
	pr.AllocationRegionKey,
	pr.OriginatingRegionKey,
    pr.PropertyFundKey,
    pr.FunctionalDepartmentKey,
	gac.GlAccountCategoryKey,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    '''''''' as PropertyFundCode,
    '''''''' as OriginatingRegionCode,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END,
    '''''''' as CalendarPeriod,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	
	NULL as MtdGrossReforecastQ1,
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecastQ2,
	NULL as MtdGrossReforecastQ3,
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
	
	NULL as MtdNetReforecastQ1,
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecastQ2,
	NULL as MtdNetReforecastQ3,
	
	NULL as YtdGrossActual,	
	NULL as YtdGrossBudget,
	
	NULL as YtdGrossReforecastQ1,
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecastQ2,
	NULL as YtdGrossReforecastQ3,
	
	NULL as YtdNetActual, 
	NULL as YtdNetBudget,
	
	NULL as YtdNetReforecastQ1,
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecastQ2,
    NULL as YtdNetReforecastQ3,
    
    NULL as AnnualGrossBudget, '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''NULL as AnnualGrossReforecastQ1,
    SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ2,     
     NULL as AnnualGrossReforecastQ3,

	NULL as AnnualNetBudget, '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''
    NULL as AnnualNetReforecastQ1,
    SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecastQ2,    
    NULL as AnnualNetReforecastQ3,

	NULL as AnnualEstGrossBudget,
	
	NULL as AnnualEstGrossReforecastQ1,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstGrossReforecastQ2,
    NULL as AnnualEstGrossReforecastQ3,

	NULL as AnnualEstNetBudget,
	
	NULL as AnnualEstNetReforecastQ1,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstNetReforecastQ2,
    NULL as AnnualEstNetReforecastQ3
FROM
    ProfitabilityReforecast pr

	INNER JOIN Overhead oh ON oh.OverheadKey = pr.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1
    	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

    INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey 
	INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey    
	INNER JOIN Calendar c ON  c.CalendarKey = pr.CalendarKey
	INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
	INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey ''
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + ''
		
WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND ref.ReforecastEffectivePeriod = '' + STR(@ReforecastEffectivePeriodQ2,6,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Bonus''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
GROUP BY
	pr.ActivityTypeKey,
	pr.AllocationRegionKey,
	pr.OriginatingRegionKey,
    pr.PropertyFundKey,
    pr.FunctionalDepartmentKey,
	gac.GlAccountCategoryKey,
	s.SourceName,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END
    
'')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LEN(@cmdString)) + '''')

PRINT @cmdString
EXEC (@cmdString)


-- Q3 -------------------------------------------------------------------------------------------------
SET @cmdString = (Select ''
INSERT INTO #BudgetOriginatorOwner
SELECT 
	pr.ActivityTypeKey,
	pr.AllocationRegionKey,
	pr.OriginatingRegionKey,
    pr.PropertyFundKey,
    pr.FunctionalDepartmentKey,
	gac.GlAccountCategoryKey,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    '''''''' as PropertyFundCode,
    '''''''' as OriginatingRegionCode,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END,
    '''''''' as CalendarPeriod,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	
	NULL as MtdGrossReforecastQ1,
	NULL as MtdGrossReforecastQ2,
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecastQ3,
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
	
	NULL as MtdNetReforecastQ1,
	NULL as MtdNetReforecastQ2,
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecastQ3,
	
	NULL as YtdGrossActual,	
	NULL as YtdGrossBudget,
	
	NULL as YtdGrossReforecastQ1,
	NULL as YtdGrossReforecastQ2,
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecastQ3,
	
	NULL as YtdNetActual, 
	NULL as YtdNetBudget,
	
	NULL as YtdNetReforecastQ1,
	NULL as YtdNetReforecastQ2,
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecastQ3,    
    
    NULL as AnnualGrossBudget, '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''NULL as AnnualGrossReforecastQ1,
    NULL as AnnualGrossReforecastQ2,
    SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ3,

	NULL as AnnualNetBudget, '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
    ''
    NULL as AnnualNetReforecastQ1,
    NULL as AnnualNetReforecastQ2,
    SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecastQ3,

	NULL as AnnualEstGrossBudget,
	
	NULL as AnnualEstGrossReforecastQ1,
	NULL as AnnualEstGrossReforecastQ2,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstGrossReforecastQ3,

	NULL as AnnualEstNetBudget,
	
	NULL as AnnualEstNetReforecastQ1,
	NULL as AnnualEstNetReforecastQ2,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstNetReforecastQ3
FROM
    ProfitabilityReforecast pr

	INNER JOIN Overhead oh ON oh.OverheadKey = pr.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1
    	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

    INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey 
	INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey    
	INNER JOIN Calendar c ON  c.CalendarKey = pr.CalendarKey
	INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
	INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey ''
    
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + ''
		
WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,10,0) + ''
	AND ref.ReforecastEffectivePeriod = '' + STR(@ReforecastEffectivePeriodQ3,6,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Bonus''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
GROUP BY
	pr.ActivityTypeKey,
	pr.AllocationRegionKey,
	pr.OriginatingRegionKey,
    pr.PropertyFundKey,
    pr.FunctionalDepartmentKey,
	gac.GlAccountCategoryKey,
	s.SourceName,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END
    
'')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LEN(@cmdString)) + '''')

PRINT @cmdString
EXEC (@cmdString)

--Functional Department Mode
SELECT 
	aty.ActivityTypeName,
	aty.ActivityTypeName AS ActivityTypeFilterName,
	gac.AccountSubTypeName AS ExpenseType,
	ar.RegionName AS AllocationRegionName,
    ar.SubRegionName AS AllocationSubRegionName,
    ar.SubRegionName AS AllocationSubRegionFilterName,
    orr.RegionName AS OriginatingRegionName,
    orr.SubRegionName AS OriginatingSubRegionName,
    orr.SubRegionName AS OriginatingSubRegionFilterName,
	gac.MajorCategoryName AS MajorExpenseCategoryName,
	gac.MinorCategoryName AS MinorExpenseCategoryName,
	pf.PropertyFundType AS EntityType,
	pf.PropertyFundName AS EntityName,
	fd.FunctionalDepartmentName as FunctionalDepartmentName,
    res.CalendarPeriod AS ActualsExpensePeriod,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
	res.SourceName AS SourceName,
	res.PropertyFundCode,
    res.OriginatingRegionCode,
    ISNULL(ga.Code, '''') GlAccountCode,
    ISNULL(ga.Name, '''') GlAccountName,
    
	--Month to date    
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossActual,0) ELSE ISNULL(MtdNetActual,0) END) AS MtdActual,
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossBudget,0) ELSE ISNULL(MtdNetBudget,0) END) AS MtdOriginalBudget,
	
	--
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ1
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ1
		END,0) 
	END) 
	AS MtdReforecastQ1,

	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ2
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ2
		END,0) 
	END) 
	AS MtdReforecastQ2,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ3
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ3
		END,0) 
	END) 
	AS MtdReforecastQ3,	

	--
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ1
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ1 
		END, 0) - ISNULL(MtdNetActual, 0) 
	END) 
	AS MtdVarianceQ1,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ2
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ2
		END, 0) - ISNULL(MtdNetActual, 0) 
	END) 
	AS MtdVarianceQ2,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ3
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ3
		END, 0) - ISNULL(MtdNetActual, 0) 
	END) 
	AS MtdVarianceQ3,		
	
	--Year to date
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossActual,0) ELSE ISNULL(YtdNetActual,0) END) AS YtdActual,	
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossBudget,0) ELSE ISNULL(YtdNetBudget,0) END) AS YtdOriginalBudget,
	
	--
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ1
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ1
		END,0) 
	END) 
	AS YtdReforecastQ1,

	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ2 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ2 
		END,0) 
	END) 
	AS YtdReforecastQ2,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ3 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ3 
		END,0) 
	END) 
	AS YtdReforecastQ3,	
	
	--
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ1
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ1
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) 
	AS YtdVarianceQ1,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ2 
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ2 
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) 
	AS YtdVarianceQ2,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ3 
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ3 
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) 
	AS YtdVarianceQ3,		
	
	--Annual
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(AnnualGrossBudget,0) ELSE ISNULL(AnnualNetBudget,0) END) AS AnnualOriginalBudget,

	--
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecastQ1
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecastQ1
		END,0) 
	END) 
	AS AnnualReforecastQ1,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecastQ2
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecastQ2
		END,0) 
	END) 
	AS AnnualReforecastQ2,
	
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecastQ3
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecastQ3
		END,0) 
	END) 
	AS AnnualReforecastQ3	
	
	--

INTO
	#Output
FROM
	#BudgetOriginatorOwner res
		INNER JOIN AllocationRegion ar ON ar.AllocationRegionKey = res.AllocationRegionKey
		INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = res.OriginatingRegionKey
		INNER JOIN PropertyFund pf ON pf.PropertyFundKey = res.PropertyFundKey
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentKey = res.FunctionalDepartmentKey
		INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = res.GlAccountCategoryKey
		INNER JOIN ActivityType aty ON aty.ActivityTypeKey = res.ActivityTypeKey
		LEFT OUTER JOIN GlAccount ga ON ga.GlAccountKey = res.GlAccountKey 
GROUP BY
	aty.ActivityTypeName,
	gac.AccountSubTypeName,
	ar.RegionName,
    ar.SubRegionName, 
    orr.RegionName,
    orr.SubRegionName,
	gac.MajorCategoryName,
	gac.MinorCategoryName,
	pf.PropertyFundType,
	pf.PropertyFundName,
	fd.FunctionalDepartmentName,
	res.CalendarPeriod,
	res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
	res.SourceName,
	res.PropertyFundCode,
    res.OriginatingRegionCode,
    ISNULL(ga.Code, ''''),
    ISNULL(ga.Name, '''')

--Output
SELECT
	ActivityTypeName,
	ActivityTypeFilterName,
	ExpenseType,
	AllocationRegionName,
    AllocationSubRegionName,
    AllocationSubRegionFilterName,
    OriginatingRegionName,
    OriginatingSubRegionName,
    OriginatingSubRegionFilterName,
	MajorExpenseCategoryName,
	MinorExpenseCategoryName,
	EntityType,
	EntityName,
	FunctionalDepartmentName,
	ActualsExpensePeriod,
    EntryDate,
    [User],
    [Description],
    AdditionalDescription,
	SourceName,
	PropertyFundCode,
    OriginatingRegionCode,    
    GlAccountCode,
    GlAccountName,
	
	--Month to date    
	MtdActual,
	MtdOriginalBudget,
	--MtdReforecastQ1,
	--MtdReforecastQ2,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE MtdReforecastQ3 END AS MtdReforecastQ3,
	
	--MtdVarianceQ1,
	--MtdVarianceQ2,
	MtdVarianceQ3,
	
	--Year to date
	YtdActual,	
	YtdOriginalBudget,
	
	--YtdReforecastQ1,
	--YtdReforecastQ2,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE YtdReforecastQ3 END AS YtdReforecastQ3,
	
	--YtdVarianceQ1,
	--YtdVarianceQ2,
	YtdVarianceQ3,
	
	--Annual
	AnnualOriginalBudget,
		
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE AnnualReforecastQ1 END AS AnnualReforecastQ1,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE AnnualReforecastQ2 END AS AnnualReforecastQ2,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE AnnualReforecastQ3 END AS AnnualReforecastQ3

FROM
	#Output
WHERE
	--Month to date    
	MtdActual <> 0.00 OR
	MtdOriginalBudget <> 0.00 OR
	
	--MtdReforecastQ1 <> 0.00 OR
	--MtdReforecastQ2 <> 0.00 OR
	--MtdReforecastQ3 <> 0.00 OR
	
	--MtdVarianceQ1 <> 0.00 OR
	--MtdVarianceQ2 <> 0.00 OR
	MtdVarianceQ3 <> 0.00 OR
	
	--Year to date
	YtdActual <> 0.00 OR
	YtdOriginalBudget <> 0.00 OR
	
	--YtdReforecastQ1 <> 0.00 OR
	--YtdReforecastQ2 <> 0.00 OR
	--YtdReforecastQ3 <> 0.00 OR
		
	--YtdVarianceQ1 <> 0.00 OR
	--YtdVarianceQ2 <> 0.00 OR
	YtdVarianceQ3 <> 0.00 OR
	
	--Annual
	AnnualOriginalBudget <> 0.00
	
	--AnnualReforecastQ1 <> 0.00 OR
	--AnnualReforecastQ2 <> 0.00 OR
	--AnnualReforecastQ3 <> 0.00

IF 	OBJECT_ID(''tempdb..#BudgetOriginatorOwner'') IS NOT NULL
    DROP TABLE #BudgetOriginatorOwner

IF 	OBJECT_ID(''tempdb..#Output'') IS NOT NULL
    DROP TABLE #Output

IF 	OBJECT_ID(''tempdb..#ReforecastsEffectivePeriods'') IS NOT NULL
	DROP TABLE #ReforecastsEffectivePeriods

IF 	OBJECT_ID(''tempdb..#EntityFilterTable'') IS NOT NULL
	DROP TABLE #EntityFilterTable
	
IF 	OBJECT_ID(''tempdb..#FunctionalDepartmentFilterTable'') IS NOT NULL	
	DROP TABLE #FunctionalDepartmentFilterTable
	
IF 	OBJECT_ID(''tempdb..#ActivityTypeFilterTable'') IS NOT NULL	
	DROP TABLE #ActivityTypeFilterTable

IF 	OBJECT_ID(''tempdb..#AllocationRegionFilterTable'') IS NOT NULL	
	DROP TABLE #AllocationRegionFilterTable
	
IF 	OBJECT_ID(''tempdb..#AllocationSubRegionFilterTable'') IS NOT NULL	
	DROP TABLE #AllocationSubRegionFilterTable
	
IF 	OBJECT_ID(''tempdb..#MajorAccountCategoryFilterTable'') IS NOT NULL	
	DROP TABLE #MajorAccountCategoryFilterTable
	
IF 	OBJECT_ID(''tempdb..#MinorAccountCategoryFilterTable'') IS NOT NULL	
	DROP TABLE #MinorAccountCategoryFilterTable
	
IF 	OBJECT_ID(''tempdb..#OriginatingRegionFilterTable'') IS NOT NULL	
	DROP TABLE #OriginatingRegionFilterTable
	
IF 	OBJECT_ID(''tempdb..#OriginatingSubRegionFilterTable'') IS NOT NULL	
	DROP TABLE #OriginatingSubRegionFilterTable

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_R_BudgetJobCodeDetail]    Script Date: 01/25/2011 14:18:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetJobCodeDetail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_R_BudgetJobCodeDetail]
	@ReportExpensePeriod INT = NULL,
	@ReforecastQuaterName VARCHAR(10) = NULL, --''Q1'' or ''Q2'' or ''Q3''
	@DestinationCurrency VARCHAR(3) = NULL,
	@TranslationTypeName VARCHAR(50) = ''Global'',
	@IsGross bit = 1,
	@FunctionalDepartmentList TEXT = NULL,
	@ActivityTypeList TEXT = NULL,
	@EntityList TEXT = NULL,
	@MajorAccountCategoryList TEXT = NULL,
	@MinorAccountCategoryList TEXT = NULL,
	@AllocationRegionList TEXT = NULL,
	@AllocationSubRegionList TEXT = NULL,
	@OriginatingRegionList TEXT = NULL,
	@OriginatingSubRegionList TEXT = NULL,
	@OverheadCode Varchar(10)=''UNALLOC''
AS


DECLARE
	@_ReportExpensePeriod INT = @ReportExpensePeriod,
	@_ReforecastQuaterName VARCHAR(10) = @ReforecastQuaterName,
	@_DestinationCurrency VARCHAR(3) = @DestinationCurrency,
	@_TranslationTypeName VARCHAR(50) = @TranslationTypeName,
	@_IsGross bit = @IsGross,
	@_FunctionalDepartmentList VARCHAR(8000) = @FunctionalDepartmentList,
	@_ActivityTypeList VARCHAR(8000) = @ActivityTypeList,
	@_EntityList VARCHAR(8000) = @EntityList,
	@_MajorAccountCategoryList VARCHAR(8000) = @MajorAccountCategoryList,
	@_MinorAccountCategoryList VARCHAR(8000) = @MinorAccountCategoryList,
	@_AllocationRegionList VARCHAR(8000) = @AllocationRegionList,
	@_AllocationSubRegionList VARCHAR(8000) = @AllocationSubRegionList,
	@_OriginatingRegionList VARCHAR(8000) = @OriginatingRegionList,
	@_OriginatingSubRegionList VARCHAR(8000) = @OriginatingSubRegionList


IF LEN(@_FunctionalDepartmentList) > 7998 OR
	LEN(@_ActivityTypeList) > 7998 OR
	LEN(@_EntityList) > 7998 OR
	LEN(@_MajorAccountCategoryList) > 7998 OR
	LEN(@_MinorAccountCategoryList) > 7998 OR
	LEN(@_AllocationRegionList) > 7998 OR
	LEN(@_AllocationSubRegionList) > 7998 OR
	LEN(@_OriginatingRegionList) > 7998 OR
	LEN(@_OriginatingSubRegionList) > 7998
BEGIN
	RAISERROR(''Filter List parameter is too big'',9,1)
END
--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Variable defaults		*/
--------------------------------------------------------------------------

IF @ReportExpensePeriod IS NULL
	SET @ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + REPLACE(STR(MONTH(GETDATE()),2 ),'' '',''0'')AS INT)

IF @DestinationCurrency IS NULL
	SET @DestinationCurrency = ''USD''

IF 	@TranslationTypeName IS NULL
	SET @TranslationTypeName = ''Global''

	DECLARE @CalendarYear AS INT
	SET @CalendarYear = CAST(SUBSTRING(CAST(@ReportExpensePeriod AS VARCHAR(10)), 1, 4) AS INT)				

--------------------------------------------------------------------------
IF @ReforecastQuaterName IS NULL OR @ReforecastQuaterName NOT IN (''Q0'', ''Q1'', ''Q2'', ''Q3'')
	SET @ReforecastQuaterName = (SELECT TOP 1
									ReforecastQuarterName 
								 FROM
									dbo.Reforecast 
								 WHERE
									ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
									ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
								 ORDER BY ReforecastEffectivePeriod DESC)
-- Compute Reforecast Effective Periods

DECLARE @ReforecastEffectivePeriodQ1 INT
DECLARE @ReforecastEffectivePeriodQ2 INT
DECLARE @ReforecastEffectivePeriodQ3 INT

SET @ReforecastEffectivePeriodQ1 = (SELECT TOP 1
										ReforecastEffectivePeriod 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										ReforecastQuarterName = ''Q1''
									ORDER BY
										ReforecastEffectivePeriod)								

SET @ReforecastEffectivePeriodQ2 = (SELECT TOP 1
										ReforecastEffectivePeriod 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										ReforecastQuarterName = ''Q2''
									ORDER BY
										ReforecastEffectivePeriod)								

SET @ReforecastEffectivePeriodQ3 = (SELECT TOP 1
										ReforecastEffectivePeriod 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4) AND 
										ReforecastQuarterName = ''Q3''
									ORDER BY
										ReforecastEffectivePeriod)

-- Retrieve Reforecast Quarter Name

DECLARE @ReforecastQuarterNameQ1 CHAR(2)
DECLARE @ReforecastQuarterNameQ2 CHAR(2)
DECLARE @ReforecastQuarterNameQ3 CHAR(2)

IF (@ReforecastEffectivePeriodQ1 IS NOT NULL)
BEGIN
	SET @ReforecastQuarterNameQ1 = (SELECT TOP 1
										ReforecastQuarterName 
									FROM
										dbo.Reforecast 
									WHERE
										ReforecastEffectivePeriod = @ReforecastEffectivePeriodQ1)
END
ELSE
BEGIN
	PRINT (''@ReforecastEffectivePeriodQ1 is NULL - cannot determine Q1 reforecast quarter name.'')
END


IF (@ReforecastEffectivePeriodQ2 IS NOT NULL)
BEGIN
	SET @ReforecastQuarterNameQ2 = (SELECT TOP 1
											ReforecastQuarterName 
										FROM
											dbo.Reforecast 
										WHERE
											ReforecastEffectivePeriod = @ReforecastEffectivePeriodQ2)
END
ELSE
BEGIN
	PRINT (''@ReforecastEffectivePeriodQ2 is NULL - cannot determine Q2 reforecast quarter name.'')
END


IF (@ReforecastEffectivePeriodQ3 IS NOT NULL)
BEGIN
	SET @ReforecastQuarterNameQ3 = (SELECT TOP 1
											ReforecastQuarterName
										FROM
											dbo.Reforecast 
										WHERE
											ReforecastEffectivePeriod = @ReforecastEffectivePeriodQ3)
END
ELSE
BEGIN
	PRINT (''@ReforecastEffectivePeriodQ3 is NULL - cannot determine Q3 reforecast quarter name.'')
END

--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Tables		*/
--------------------------------------------------------------------------
	
CREATE TABLE #EntityFilterTable (PropertyFundKey Int NOT NULL)
CREATE TABLE #FunctionalDepartmentFilterTable (FunctionalDepartmentKey Int NOT NULL)
CREATE TABLE #ActivityTypeFilterTable (ActivityTypeKey Int NOT NULL)
CREATE TABLE #AllocationRegionFilterTable (AllocationRegionKey Int NOT NULL)
CREATE TABLE #AllocationSubRegionFilterTable (AllocationRegionKey Int NOT NULL)
CREATE TABLE #MajorAccountCategoryFilterTable (GlAccountCategoryKey Int NOT NULL)	
CREATE TABLE #MinorAccountCategoryFilterTable (GlAccountCategoryKey Int NOT NULL)	
CREATE TABLE #OriginatingRegionFilterTable (OriginatingRegionKey Int NOT NULL)
CREATE TABLE #OriginatingSubRegionFilterTable (OriginatingRegionKey Int NOT NULL)	
	
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable (PropertyFundKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable (ActivityTypeKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationRegionFilterTable	(AllocationRegionKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable (AllocationRegionKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MajorAccountCategoryFilterTable (GlAccountCategoryKey)	
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MinorAccountCategoryFilterTable (GlAccountCategoryKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingRegionFilterTable (OriginatingRegionKey)
CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable (OriginatingRegionKey)
	
IF (@EntityList IS NOT NULL)
	BEGIN
	Insert Into #EntityFilterTable
	Select pf.PropertyFundKey
	From dbo.Split(@_EntityList) t1
		INNER JOIN PropertyFund pf ON pf.PropertyFundName = t1.item
	
	END
	
IF (@FunctionalDepartmentList IS NOT NULL)
	BEGIN
	Insert Into #FunctionalDepartmentFilterTable
	Select fd.FunctionalDepartmentKey 
	From dbo.Split(@_FunctionalDepartmentList) t1
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentName = t1.item
	END

IF 	(@ActivityTypeList IS NOT NULL)
	BEGIN
    INSERT INTO #ActivityTypeFilterTable
    SELECT at.ActivityTypeKey 
    FROM dbo.Split(@_ActivityTypeList) t1
		INNER JOIN ActivityType at ON at.ActivityTypeName = t1.item
	END
	
IF (@AllocationRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationRegionFilterTable
	Select ar.AllocationRegionKey 
	From dbo.Split(@_AllocationRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.RegionName = t1.item
	END

IF (@AllocationSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationSubRegionFilterTable
	Select ar.AllocationRegionKey
	From dbo.Split(@_AllocationSubRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.SubRegionName = t1.item
	END

IF (@MajorAccountCategoryList IS NOT NULL)
	BEGIN
	Insert Into #MajorAccountCategoryFilterTable
	Select gl.GlAccountCategoryKey 
	From dbo.Split(@_MajorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MajorCategoryName = t1.item
	END
	
IF 	(@MinorAccountCategoryList IS NOT NULL)
	BEGIN
    INSERT INTO #MinorAccountCategoryFilterTable
    SELECT gl.GlAccountCategoryKey 
    FROM dbo.Split(@MinorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MinorCategoryName = t1.item
	END	

IF (@OriginatingRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingRegionFilterTable
	Select orr.OriginatingRegionKey 
	From dbo.Split(@_OriginatingRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.RegionName = t1.item
	END

IF (@OriginatingSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingSubRegionFilterTable
	Select orr.OriginatingRegionKey  
	From dbo.Split(@OriginatingSubRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.SubRegionName = t1.item
	END		
--------------------------------------------------------------------------
/*	COMMON END															*/
--------------------------------------------------------------------------
	

IF 	OBJECT_ID(''tempdb..#BudgetOriginator'') IS NOT NULL
    DROP TABLE #BudgetOriginator

CREATE TABLE #BudgetOriginator
(	
	GlAccountCategoryKey		INT,
    AllocationRegionKey			INT,
    OriginatingRegionKey		INT,
    FunctionalDepartmentKey		INT,
    PropertyFundKey				INT,
	CalendarPeriod				INT,
	SourceName					VARCHAR(50),
	EntryDate					VARCHAR(10),
	[User]						NVARCHAR(20),
	[Description]				NVARCHAR(60),
	AdditionalDescription		NVARCHAR(4000),
	PropertyFundCode			Varchar(6) DEFAULT(''''), --Varchar, for this helps to keep reports size smaller
	OriginatingRegionCode		Varchar(15) DEFAULT(''''), --Varchar, for this helps to keep reports size smaller
	GlAccountKey				Int  NULL,
	
	--Month to date	
	MtdGrossActual				MONEY,
	MtdGrossBudget				MONEY,
	MtdGrossReforecastQ1		MONEY,
	MtdGrossReforecastQ2		MONEY,
	MtdGrossReforecastQ3		MONEY,
	MtdNetActual				MONEY,
	MtdNetBudget				MONEY,
	MtdNetReforecastQ1			MONEY,
	MtdNetReforecastQ2			MONEY,
	MtdNetReforecastQ3			MONEY,
	
	--Year to date
	YtdGrossActual				MONEY,	
	YtdGrossBudget				MONEY, 
	YtdGrossReforecastQ1		MONEY,
	YtdGrossReforecastQ2		MONEY,
	YtdGrossReforecastQ3		MONEY,
	YtdNetActual				MONEY, 
	YtdNetBudget				MONEY, 
	YtdNetReforecastQ1			MONEY,
	YtdNetReforecastQ2			MONEY,
	YtdNetReforecastQ3			MONEY,

	--Annual	
	AnnualGrossBudget			MONEY,
	AnnualGrossReforecastQ1		MONEY,
	AnnualGrossReforecastQ2		MONEY,
	AnnualGrossReforecastQ3		MONEY,
	AnnualNetBudget				MONEY,
	AnnualNetReforecastQ1		MONEY,
	AnnualNetReforecastQ2		MONEY,
	AnnualNetReforecastQ3		MONEY,
	--Annual estimated
	AnnualEstGrossBudget		MONEY,
	AnnualEstGrossReforecastQ1	MONEY,
	AnnualEstGrossReforecastQ2	MONEY,
	AnnualEstGrossReforecastQ3	MONEY,
	AnnualEstNetBudget			MONEY,
	AnnualEstNetReforecastQ1	MONEY,
	AnnualEstNetReforecastQ2	MONEY,
	AnnualEstNetReforecastQ3	MONEY
)
DECLARE @cmdString Varchar(8000)

-- Get actual information
SET @cmdString = (Select ''
INSERT INTO #BudgetOriginator
SELECT 	
	gac.GlAccountCategoryKey,
    pa.AllocationRegionKey,
    pa.OriginatingRegionKey,
    pa.FunctionalDepartmentKey,
    pa.PropertyFundKey,
    c.CalendarPeriod,
    s.SourceName,
    CONVERT(varchar(10),ISNULL(pa.EntryDate,''''''''), 101) as EntryDate,
    ISNULL(pa.[User], '''''''') [User],
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.Description ELSE '''''''' END as Description,
    CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.AdditionalDescription ELSE '''''''' END as AdditionalDescription,
    ISNULL(pa.PropertyFundCode, '''''''') PropertyFundCode,
    ISNULL(pa.OriginatingRegionCode, '''''''') OriginatingRegionCode,
    pa.GlAccountKey,
    
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdGrossActual,
	NULL as MtdGrossBudget,
	
	'' + /*-- MtdGrossReforecast --------------------------*/ + ''
	
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + 
				'' AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdGrossReforecastQ1,
	
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + 
				'' AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdGrossReforecastQ2,
	
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + 
				'' AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdGrossReforecastQ3,		
	
	'' + /*-- MtdGrossReforecast End --------------------------*/ + ''
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as MtdNetActual,
	NULL as MtdNetBudget,
	
	'' + /*-- MtdNetReforecast --------------------------*/ + ''
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + 
		'' AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdNetReforecastQ1,
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + 
		'' AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdNetReforecastQ2,
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + 
		'' AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as MtdNetReforecastQ3,		
	
	'' + /*-- MtdNetReforecast End --------------------------*/ + ''
	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdGrossActual,
	NULL as YtdGrossBudget,
	
	'' + /*-- YtdGrossReforecast --------------------------*/ + ''
	
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			'' AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
		) as YtdGrossReforecastQ1,
		
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			'' AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
		) as YtdGrossReforecastQ2,
		
	SUM(
		er.Rate * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			'' AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
		) as YtdGrossReforecastQ3,				
	
	'' + /*-- YtdGrossReforecast End --------------------------*/ + ''
	
	'')
	DECLARE @cmdString2 VARCHAR(8000)
	SET @cmdString2 = (SELECT ''		
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pa.LocalActual
		ELSE
			0
		END
	) as YtdNetActual,
	NULL as YtdNetBudget,
	
	'' + /*-- YtdNetReforecast End --------------------------*/ + ''
	
	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
		) as YtdNetReforecastQ1,

	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
		) as YtdNetReforecastQ2,

	SUM(
		er.Rate * r.MultiplicationFactor * 
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			 AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
		) as YtdNetReforecastQ3,

	'' + /*-- YtdNetReforecast End --------------------------*/ + ''
	
	NULL as AnnualGrossBudget,
	
	'' + /*-- AnnualGrossReforecast --------------------------*/ + ''
	
	SUM(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualGrossReforecastQ1,

	SUM(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualGrossReforecastQ2,

	SUM(
		er.Rate *
		CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualGrossReforecastQ3,

	'' + /*-- AnnualGrossReforecast End --------------------------*/ + ''

	NULL as AnnualNetBudget,
		
	'' + /*-- AnnualNetReforecast --------------------------*/ + ''
	
    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ1,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ1,
	
    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ2,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ2,
	
    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + ''
			  AND c.CalendarPeriod < '' + STR(@ReforecastEffectivePeriodQ3,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualNetReforecastQ3,		
	
	'' + /*-- AnnualNetReforecast End --------------------------*/ + ''
	
		'')
	DECLARE @cmdString3 VARCHAR(8000)
	SET @cmdString3 = (SELECT ''	
	
	SUM(
        er.Rate *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pa.LocalActual
        ELSE 
			0
        END
	) as AnnualEstGrossBudget,
	
	'' + /*-- AnnualEstGrossReforecast --------------------------*/ + ''
	
	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecastQ1,

	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecastQ2,

	SUM(
            er.Rate *
            CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstGrossReforecastQ3,

	'' + /*-- AnnualEstGrossReforecast End --------------------------*/ + ''

    SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pa.LocalActual
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
    
    '' + /*-- AnnualEstNetReforecast --------------------------*/ + ''
    
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstNetReforecastQ1,
	
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstNetReforecastQ2,
	
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Exclude actual... actuals here so we don''t double count on the grinder actuals*/
			'' 
			AND (
					gac.AccountSubTypeName <> ''''Non-Payroll''''
				 OR	'' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' NOT IN (201003, 201006, 201009)
				 )
			THEN
				''+--ie not payroll and is unalloc then ... dont use actual, use reforecast+
				''
				CASE WHEN gac.MajorCategoryName <> ''''Salaries/Taxes/Benefits'''' AND oh.OverheadCode = ''''UNALLOC'''' THEN 
					0
				ELSE
					pa.LocalActual
				END
		ELSE 
			0 
		END
	) as AnnualEstNetReforecastQ3		
	
	'' + /*-- AnnualEstNetReforecast End --------------------------*/ + ''

FROM
	ProfitabilityActual pa

	INNER JOIN Overhead oh ON oh.OverheadKey = pa.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1

	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pa.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pa.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pa.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pa.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pa.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pa.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pa.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pa.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')
			
    INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
	INNER JOIN Currency dc ON er.DestinationCurrencyKey = dc.CurrencyKey
	INNER JOIN Calendar c ON c.CalendarKey = pa.CalendarKey
	INNER JOIN Source s ON s.SourceKey = pa.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pa.ReimbursableKey ''

    + CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pa.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pa.ActivityTypeKey'' ELSE '''' END +
    + CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pa.PropertyFundKey'' ELSE '''' END + ''

WHERE  1 = 1
	AND c.CalendarYear = '' + STR(@CalendarYear,4,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select t1.FunctionalDepartmentKey From #FunctionalDepartmentFilterTable t1)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select t1.ActivityTypeKey From #ActivityTypeFilterTable t1)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select t1.PropertyFundKey From #EntityFilterTable t1)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationRegionFilterTable t1)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationSubRegionFilterTable t1)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MajorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MinorAccountCategoryFilterTable t1)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingRegionFilterTable t1)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingSubRegionFilterTable t1)'' END +
''
GROUP BY
	gac.GlAccountCategoryKey,
	pa.AllocationRegionKey,
	pa.OriginatingRegionKey,
	pa.FunctionalDepartmentKey,
	pa.PropertyFundKey,
	c.CalendarPeriod,
	s.SourceName,
	CONVERT(varchar(10),ISNULL(pa.EntryDate,''''''''), 101),
	ISNULL(pa.[User], ''''''''),
	CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.Description ELSE '''''''' END,
	CASE WHEN gac.AccountSubTypeName = ''''Non-Payroll'''' THEN pa.AdditionalDescription ELSE '''''''' END,
	ISNULL(pa.PropertyFundCode, ''''''''),
	ISNULL(pa.OriginatingRegionCode, ''''''''),
	pa.GlAccountKey
'')

IF (LEN(@cmdString) > 7995 OR LEN(@cmdString2) > 7995 OR LEN(@cmdString3) > 7995)
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LTRIM(RTRIM(LEN(@cmdString)))) + '' + '' + STR(LTRIM(RTRIM(LEN(@cmdString2)))) + '' + '' + STR(LTRIM(RTRIM(LEN(@cmdString3)))))

PRINT @cmdString
PRINT @cmdString2
PRINT @cmdString3

EXEC (@cmdString + @cmdString2 + @cmdString3)

-----------------------------------------------------------------------------------------------------
-- Get budget information
SET @cmdString = (SELECT ''
INSERT INTO #BudgetOriginator
SELECT 	
	gac.GlAccountCategoryKey,
    pb.AllocationRegionKey,
    pb.OriginatingRegionKey,
    pb.FunctionalDepartmentKey,
    pb.PropertyFundKey,
    c.CalendarPeriod,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    '''''''' as PropertyFundCode,
    '''''''' OriginatingRegionCode,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pb.GlAccountKey END,
    
    NULL as MtdGrossActual,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as MtdGrossBudget,
	
	NULL as MtdGrossReforecastQ1,
	NULL as MtdGrossReforecastQ2,
	NULL as MtdGrossReforecastQ3,
	
	NULL as MtdNetActual,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as MtdNetBudget,
    
	NULL as MtdNetReforecastQ1,
	NULL as MtdNetReforecastQ2,
	NULL as MtdNetReforecastQ3,
	
	NULL as YtdGrossActual,	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as YtdGrossBudget,
	
	NULL as YtdGrossReforecastQ1,
	NULL as YtdGrossReforecastQ2,
	NULL as YtdGrossReforecastQ3,
	
	NULL as YtdNetActual, 
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as YtdNetBudget,
    
	NULL as YtdNetReforecastQ1,
	NULL as YtdNetReforecastQ2,
	NULL as YtdNetReforecastQ3,
	
	SUM(er.Rate * pb.LocalBudget) as AnnualGrossBudget,
	
	NULL as AnnualGrossReforecastQ1,
	NULL as AnnualGrossReforecastQ2,
	NULL as AnnualGrossReforecastQ3,

	SUM(er.Rate * r.MultiplicationFactor * pb.LocalBudget) as AnnualNetBudget,
	
	NULL as AnnualNetReforecastQ1,
	NULL as AnnualNetReforecastQ2,
	NULL as AnnualNetReforecastQ3,	

	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pb.LocalBudget
		ELSE
			0
		END
	) as AnnualEstGrossBudget,
	
	NULL as AnnualEstGrossReforecastQ1,
	NULL as AnnualEstGrossReforecastQ2,
	NULL as AnnualEstGrossReforecastQ3,

	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pb.LocalBudget
        ELSE 
			0
        END
    ) as AnnualEstNetBudget,
    
	NULL as AnnualEstNetReforecastQ1,
	NULL as AnnualEstNetReforecastQ2,
	NULL as AnnualEstNetReforecastQ3
    
FROM
	ProfitabilityBudget pb 
	
	INNER JOIN Overhead oh ON oh.OverheadKey = pb.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1
	
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pb.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pb.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pb.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pb.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pb.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pb.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pb.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pb.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

	INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey
	INNER JOIN Currency dc ON er.DestinationCurrencyKey = dc.CurrencyKey
	INNER JOIN Calendar c ON c.CalendarKey = pb.CalendarKey
	INNER JOIN Source s ON s.SourceKey = pb.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pb.ReimbursableKey ''
    			
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pb.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey'' ELSE '''' END + ''
    
WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,4,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
GROUP BY
    gac.GlAccountCategoryKey,
    pb.AllocationRegionKey,
    pb.OriginatingRegionKey,
    pb.FunctionalDepartmentKey,
    pb.PropertyFundKey,
    c.CalendarPeriod,
    s.SourceName,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pb.GlAccountKey END
'')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LEN(@cmdString)))

print @cmdString
EXEC (@cmdString)

--------------------------------------------------------------------------------------------------------------------------
-- Get Q1 reforecast information
SET @cmdString = (Select ''
INSERT INTO #BudgetOriginator
SELECT 	
	gac.GlAccountCategoryKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.FunctionalDepartmentKey,
    pr.PropertyFundKey,
    c.CalendarPeriod,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    '''''''' as PropertyFundCode,
    '''''''' OriginatingRegionCode,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	
	'' + /*-- MtdGrossReforecast --------------------------*/ + ''
	
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecastQ1,
	NULL  as MtdGrossReforecastQ2,
	NULL  as MtdGrossReforecastQ3,
	
	'' + /*-- MtdGrossReforecast End --------------------------*/ + ''
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
	
	'' + /*-- MtdNetReforecast --------------------------*/ + ''
	
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecastQ1,
    NULL as MtdNetReforecastQ2,
    NULL as MtdNetReforecastQ3,    
	
	'' + /*-- MtdNetReforecast End --------------------------*/ + ''
	
	NULL as YtdGrossActual,
	NULL as YtdGrossBudget,
	
	'' + /*-- YtdGrossReforecast --------------------------*/ + ''
	
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecastQ1, 
	NULL as YtdGrossReforecastQ2,
	NULL as YtdGrossReforecastQ3,
	
	'' + /*-- YtdGrossReforecast End --------------------------*/ + ''
	
	NULL as YtdNetActual,
	NULL as YtdNetBudget,
	
	'' + /*-- YtdNetReforecast --------------------------*/ + ''
	
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecastQ1,
	NULL  as YtdNetReforecastQ2,
	NULL  as YtdNetReforecastQ3,
	
	'' + /*-- YtdNetReforecast End --------------------------*/ + ''
	
	NULL as AnnualGrossBudget,
	
	'' + /*-- AnnualGrossReforecast --------------------------*/ + ''
		
	SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ1,
	NULL as AnnualGrossReforecastQ2,
	NULL as AnnualGrossReforecastQ3,

	'' + /*-- AnnualGrossReforecast End --------------------------*/ + ''

	NULL as AnnualNetBudget,
	
	'' + /*-- AnnualNetReforecast --------------------------*/ + ''
	
	SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecastQ1,
	NULL as AnnualNetReforecastQ2,
	NULL as AnnualNetReforecastQ3,

	'' + /*-- AnnualNetReforecast End --------------------------*/ + ''

	NULL as AnnualEstGrossBudget,
	
	'' + /*-- AnnualEstGrossReforecast --------------------------*/ + ''
	
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN 
			pr.LocalReforecast
		ELSE
			0
		END
	) as AnnualEstGrossReforecastQ1,
	NULL as AnnualEstGrossReforecastQ2,
	NULL as AnnualEstGrossReforecastQ3,		
	
	'' + /*-- AnnualEstGrossReforecast End --------------------------*/ + ''
	
	NULL as AnnualEstNetBudget,
	
	'' + /*-- AnnualEstNetReforecast --------------------------*/ + ''
	
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ1,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstNetReforecastQ1,
	NULL as AnnualEstNetReforecastQ2,
	NULL as AnnualEstNetReforecastQ3        
    
    '' + /*-- AnnualEstNetReforecast End --------------------------*/ + ''
    
FROM
	ProfitabilityReforecast pr 
	
	INNER JOIN Overhead oh ON oh.OverheadKey = pr.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1

	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

	INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
	INNER JOIN Currency dc ON er.DestinationCurrencyKey = dc.CurrencyKey
	INNER JOIN Calendar c ON c.CalendarKey = pr.CalendarKey
	INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
	INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey ''
    			
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + ''
    
WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,4,0) + ''
	AND ref.ReforecastEffectivePeriod = '' + STR(@ReforecastEffectivePeriodQ1,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
GROUP BY
    gac.GlAccountCategoryKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.FunctionalDepartmentKey,
    pr.PropertyFundKey,
    c.CalendarPeriod,
    s.SourceName,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END
	
'')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LEN(@cmdString)) + '''')

PRINT @cmdString
EXEC (@cmdString)


--------------------------------------------------------------------------------------------------------------------------
-- Get Q2 reforecast information
SET @cmdString = (Select ''
INSERT INTO #BudgetOriginator
SELECT 	
	gac.GlAccountCategoryKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.FunctionalDepartmentKey,
    pr.PropertyFundKey,
    c.CalendarPeriod,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    '''''''' as PropertyFundCode,
    '''''''' OriginatingRegionCode,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	
	'' + /*-- MtdGrossReforecast --------------------------*/ + ''
	
	NULL  as MtdGrossReforecastQ1,
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecastQ2,
	NULL  as MtdGrossReforecastQ3,
	
	'' + /*-- MtdGrossReforecast End --------------------------*/ + ''
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
	
	'' + /*-- MtdNetReforecast --------------------------*/ + ''
	
	NULL as MtdNetReforecastQ1,
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecastQ2,
    NULL as MtdNetReforecastQ3,    
	
	'' + /*-- MtdNetReforecast End --------------------------*/ + ''
	
	NULL as YtdGrossActual,
	NULL as YtdGrossBudget,
	
	'' + /*-- YtdGrossReforecast --------------------------*/ + ''
	
	NULL as YtdGrossReforecastQ1,
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecastQ2,
	NULL as YtdGrossReforecastQ3,
	
	'' + /*-- YtdGrossReforecast End --------------------------*/ + ''
	
	NULL as YtdNetActual,
	NULL as YtdNetBudget,
	
	'' + /*-- YtdNetReforecast --------------------------*/ + ''
	
	NULL as YtdNetReforecastQ1,
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecastQ2,
	NULL as YtdNetReforecastQ3,
	
	'' + /*-- YtdNetReforecast End --------------------------*/ + ''
	
	NULL as AnnualGrossBudget,
	
	'' + /*-- AnnualGrossReforecast --------------------------*/ + ''
		
	NULL as AnnualGrossReforecastQ1,
	SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ2,
	NULL as AnnualGrossReforecastQ3,

	'' + /*-- AnnualGrossReforecast End --------------------------*/ + ''

	NULL as AnnualNetBudget,
	
	'' + /*-- AnnualNetReforecast --------------------------*/ + ''
	
	NULL as AnnualNetReforecastQ1,
	SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecastQ2,
	NULL as AnnualNetReforecastQ3,
	
	'' + /*-- AnnualNetReforecast End --------------------------*/ + ''
	
	NULL as AnnualEstGrossBudget,
	
	'' + /*-- AnnualEstGrossReforecast --------------------------*/ + ''
	
	NULL as AnnualEstGrossReforecastQ1,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN 
			pr.LocalReforecast
		ELSE
			0
		END
	) as AnnualEstGrossReforecastQ2,
	NULL as AnnualEstGrossReforecastQ3,		
	
	'' + /*-- AnnualEstGrossReforecast End --------------------------*/ + ''
	
	NULL as AnnualEstNetBudget,
	
	'' + /*-- AnnualEstNetReforecast --------------------------*/ + ''
	
	NULL as AnnualEstNetReforecastQ1,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ2,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstNetReforecastQ2,
	NULL as AnnualEstNetReforecastQ3        
    
    '' + /*-- AnnualEstNetReforecast End --------------------------*/ + ''
    
FROM
	ProfitabilityReforecast pr 
	
	INNER JOIN Overhead oh ON oh.OverheadKey = pr.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1

	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

	INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
	INNER JOIN Currency dc ON er.DestinationCurrencyKey = dc.CurrencyKey
	INNER JOIN Calendar c ON c.CalendarKey = pr.CalendarKey
	INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
	INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey ''
    			
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + ''
    
WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,4,0) + ''
	AND ref.ReforecastEffectivePeriod = '' + STR(@ReforecastEffectivePeriodQ2,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
GROUP BY
    gac.GlAccountCategoryKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.FunctionalDepartmentKey,
    pr.PropertyFundKey,
    c.CalendarPeriod,
    s.SourceName,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END
	
'')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LEN(@cmdString)) + '''')

PRINT @cmdString
EXEC (@cmdString)

--------------------------------------------------------------------------------------------------------------------------
-- Get Q3 reforecast information
SET @cmdString = (Select ''
INSERT INTO #BudgetOriginator
SELECT 	
	gac.GlAccountCategoryKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.FunctionalDepartmentKey,
    pr.PropertyFundKey,
    c.CalendarPeriod,
    s.SourceName,
    '''''''' as EntryDate,
    '''''''' as [User],
    '''''''' as Description,
    '''''''' as AdditionalDescription,
    '''''''' as PropertyFundCode,
    '''''''' OriginatingRegionCode,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END,
    
	NULL as MtdGrossActual,
	NULL as MtdGrossBudget,
	
	'' + /*-- MtdGrossReforecast --------------------------*/ + ''
	
	NULL  as MtdGrossReforecastQ1,
	NULL  as MtdGrossReforecastQ2,
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as MtdGrossReforecastQ3,
	
	'' + /*-- MtdGrossReforecast End --------------------------*/ + ''
	
	NULL as MtdNetActual,
	NULL as MtdNetBudget,
	
	'' + /*-- MtdNetReforecast --------------------------*/ + ''
	
	NULL as MtdNetReforecastQ1,
	NULL as MtdNetReforecastQ2,
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod = '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as MtdNetReforecastQ3, 
	
	'' + /*-- MtdNetReforecast End --------------------------*/ + ''
	
	NULL as YtdGrossActual,
	NULL as YtdGrossBudget,
	
	'' + /*-- YtdGrossReforecast --------------------------*/ + ''
	
	NULL as YtdGrossReforecastQ1,
	NULL as YtdGrossReforecastQ2,
	SUM(
		er.Rate * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN
			pr.LocalReforecast
		ELSE
			0
		END
	) as YtdGrossReforecastQ3,
	
	'' + /*-- YtdGrossReforecast End --------------------------*/ + ''
	
	NULL as YtdNetActual,
	NULL as YtdNetBudget,
	
	'' + /*-- YtdNetReforecast --------------------------*/ + ''
	
	NULL as YtdNetReforecastQ1,
	NULL as YtdNetReforecastQ2,
    SUM(
        er.Rate * r.MultiplicationFactor * '' +
        /*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
        /*Remember that reforecast... actuals will get pulled here if it''s available (i.e we import it)*/
        ''CASE WHEN (c.CalendarPeriod <= '' + STR(@ReportExpensePeriod,6,0) + '') THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as YtdNetReforecastQ3,
	
	'' + /*-- YtdNetReforecast End --------------------------*/ + ''
	
	NULL as AnnualGrossBudget,
	
	'' + /*-- AnnualGrossReforecast --------------------------*/ + ''
		
	NULL as AnnualGrossReforecastQ1,
	NULL as AnnualGrossReforecastQ2,
	SUM(er.Rate * pr.LocalReforecast) as AnnualGrossReforecastQ3,

	'' + /*-- AnnualGrossReforecast End --------------------------*/ + ''

	NULL as AnnualNetBudget,
	
	'' + /*-- AnnualNetReforecast --------------------------*/ + ''
	
	NULL as AnnualNetReforecastQ1,
	NULL as AnnualNetReforecastQ2,
	SUM (er.Rate * r.MultiplicationFactor * pr.LocalReforecast)as AnnualNetReforecastQ3,
	
	'' + /*-- AnnualNetReforecast End --------------------------*/ + ''
	
	NULL as AnnualEstGrossBudget,
	
	'' + /*-- AnnualEstGrossReforecast --------------------------*/ + ''
	
	NULL as AnnualEstGrossReforecastQ1,
	NULL as AnnualEstGrossReforecastQ2,
	SUM(
		er.Rate *
		CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN 
			pr.LocalReforecast
		ELSE
			0
		END
	) as AnnualEstGrossReforecastQ3,
	
	'' + /*-- AnnualEstGrossReforecast End --------------------------*/ + ''
	
	NULL as AnnualEstNetBudget,
	
	'' + /*-- AnnualEstNetReforecast --------------------------*/ + ''
	
	NULL as AnnualEstNetReforecastQ1,
	NULL as AnnualEstNetReforecastQ2,
	SUM(
        er.Rate * r.MultiplicationFactor *
        CASE WHEN (c.CalendarPeriod > '' + STR(@ReportExpensePeriod,6,0) + 
			/*Hack to pull non-payroll actuals from the grinder for Q1, 201003... yes 201003 Q1. (Ask MikeC)*/ 
			/*Don''t use the category mapping here like for actual exclude because we want unknowns to come through*/
			''
				 OR (
						LEFT(pr.ReferenceCode,3) = ''''BC:''''
						AND '' + STR(@ReforecastEffectivePeriodQ3,6,0) + '' IN (201003, 201006, 201009)
					)
				 ) THEN 
			pr.LocalReforecast
        ELSE 
			0
        END
    ) as AnnualEstNetReforecastQ3
    
    '' + /*-- AnnualEstNetReforecast End --------------------------*/ + ''
    
FROM
	ProfitabilityReforecast pr 
	
	INNER JOIN Overhead oh ON oh.OverheadKey = pr.OverheadKey
		AND OverHeadCode IN (''''UNKNOWN'''', '''''' + @OverheadCode + '''''') -- GC :: Change Control 1

	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = '' + CASE 
			WHEN @TranslationTypeName = ''EU Corporate'' THEN ''pr.EUCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Property'' THEN ''pr.USPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Fund'' THEN ''pr.USFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Property'' THEN ''pr.EUPropertyGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''US Corporate'' THEN ''pr.USCorporateGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Development'' THEN ''pr.DevelopmentGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''EU Fund'' THEN ''pr.EUFundGlAccountCategoryKey'' 
			WHEN @TranslationTypeName = ''Global'' THEN ''pr.GlobalGlAccountCategoryKey'' 
			ELSE ''break:not valid hierarchyname'' END + ''
			AND gac.FeeOrExpense IN (''''EXPENSE'''',''''UNKNOWN'''')

	INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pr.LocalCurrencyKey AND er.CalendarKey = pr.CalendarKey
	INNER JOIN Currency dc ON er.DestinationCurrencyKey = dc.CurrencyKey
	INNER JOIN Calendar c ON c.CalendarKey = pr.CalendarKey
	INNER JOIN Reforecast ref ON ref.ReforecastKey = pr.ReforecastKey
	INNER JOIN Source s ON s.SourceKey = pr.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey ''
    			
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN '' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pr.AllocationRegionKey '' ELSE '''' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN '' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pr.OriginatingRegionKey '' ELSE '''' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN '' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pr.FunctionalDepartmentKey '' ELSE '''' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN '' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pr.ActivityTypeKey'' ELSE '''' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN '' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pr.PropertyFundKey'' ELSE '''' END + ''
    
WHERE  1 = 1 
	AND c.CalendarYear = '' + STR(@CalendarYear,4,0) + ''
	AND ref.ReforecastEffectivePeriod = '' + STR(@ReforecastEffectivePeriodQ3,10,0) + ''
	AND dc.CurrencyCode = '''''' + @DestinationCurrency + ''''''
	AND gac.MinorCategoryName <> ''''Architects & Engineering'''' /* IMS 51655 */
''
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '''' ELSE '' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)'' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '''' ELSE '' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)'' END +
+ CASE WHEN @EntityList IS NULL THEN '''' ELSE '' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)'' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)'' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '''' ELSE '' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)'' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)'' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '''' ELSE '' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)'' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)'' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '''' ELSE '' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)'' END +
''
GROUP BY
    gac.GlAccountCategoryKey,
    pr.AllocationRegionKey,
    pr.OriginatingRegionKey,
    pr.FunctionalDepartmentKey,
    pr.PropertyFundKey,
    c.CalendarPeriod,
    s.SourceName,
    CASE WHEN gac.MajorCategoryName = ''''Salaries/Taxes/Benefits'''' THEN NULL ELSE pr.GlAccountKey END
	
'')

IF (LEN(@cmdString)) > 7995
BEGIN
	RAISERROR(''The dynamic sql statement is greater than 7995 characters in length, which is the maximum. Cowardly aborting ...'',9,1)
END

PRINT (''Total dynamic sql statement size: '' + STR(LEN(@cmdString)) + '''')

PRINT @cmdString
EXEC (@cmdString)

-----------------------------------------------------------------------------------------------------------------------    
SELECT 
	gac.AccountSubTypeName ExpenseType,
    ar.RegionName AS AllocationRegionName,
    ar.SubRegionName AS AllocationSubRegionName,
    orr.RegionName AS OriginatingRegionName,
    orr.SubRegionName AS OriginatingSubRegionName,
    fd.FunctionalDepartmentName AS FunctionalDepartmentName,
    fd.SubFunctionalDepartmentName AS JobCode,
    gac.MajorCategoryName AS MajorExpenseCategoryName,
    gac.MinorCategoryName AS MinorExpenseCategoryName,
    pf.PropertyFundType AS EntityType,
    pf.PropertyFundName AS EntityName,
    res.CalendarPeriod AS ExpensePeriod,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
    res.SourceName AS SourceName,
    res.PropertyFundCode PropertyFundCode,
    res.OriginatingRegionCode OriginatingRegionCode,
    ISNULL(ga.Code, '''') GlAccountCode,
    ISNULL(ga.Name, '''') GlAccountName,
    
	--Month to date    
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossActual,0) ELSE ISNULL(MtdNetActual,0) END) AS MtdActual,
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossBudget,0) ELSE ISNULL(MtdNetBudget,0) END) AS MtdOriginalBudget,
	
	----- MtdReforecast
	SUM(CASE WHEN (@IsGross = 1) THEN
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ1 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ1
		END,0) 
	END) 
	AS MtdReforecastQ1,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ2 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ2 
		END,0) 
	END) 
	AS MtdReforecastQ2,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ3 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ3 
		END,0) 
	END) 
	AS MtdReforecastQ3,		
	----- MtdReforecast End
	
	----- MtdVariance
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ1 
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ1 
		END, 0) - ISNULL(MtdNetActual, 0) 
	END) 
	AS MtdVarianceQ1,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ2 
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ2 
		END, 0) - ISNULL(MtdNetActual, 0) 
	END) 
	AS MtdVarianceQ2,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdGrossBudget 
		ELSE 
			MtdGrossReforecastQ3 
		END, 0) - ISNULL(MtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			MtdNetBudget 
		ELSE 
			MtdNetReforecastQ3 
		END, 0) - ISNULL(MtdNetActual, 0) 
	END) 
	AS MtdVarianceQ3,		
	----- MtdVariance End
	
	--Year to date
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossActual,0) ELSE ISNULL(YtdNetActual,0) END) AS YtdActual,	
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossBudget,0) ELSE ISNULL(YtdNetBudget,0) END) AS YtdOriginalBudget,
	
	----- YtdReforecast
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ1 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ1 
		END,0) 
	END) 
	AS YtdReforecastQ1,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ2 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ2 
		END,0) 
	END) 
	AS YtdReforecastQ2,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ3 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ3 
		END,0) 
	END) 
	AS YtdReforecastQ3,		
	----- YtdReforecast End
	
	----- YtdVariance
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ1 
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ1 
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) 
	AS YtdVarianceQ1,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ2 
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ2 
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) 
	AS YtdVarianceQ2,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdGrossBudget 
		ELSE 
			YtdGrossReforecastQ3 
		END, 0) - ISNULL(YtdGrossActual, 0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			YtdNetBudget 
		ELSE 
			YtdNetReforecastQ3 
		END, 0) - ISNULL(YtdNetActual, 0) 
	END) 
	AS YtdVarianceQ3,		
	----- YtdVariance End
	
	--Annual
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(AnnualGrossBudget,0) ELSE ISNULL(AnnualNetBudget,0) END) AS AnnualOriginalBudget,	
	
	----- AnnualReforecast
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecastQ1 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecastQ1 
		END,0) 
	END) 
	AS AnnualReforecastQ1,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualGrossBudget 
		ELSE 
			AnnualGrossReforecastQ2 
		END,0) 
	ELSE 
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 
			AnnualNetBudget 
		ELSE 
			AnnualNetReforecastQ2 
		END,0) 
	END)
	AS AnnualReforecastQ2,
	--
	SUM(CASE WHEN (@IsGross = 1) THEN
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN
			AnnualGrossBudget
		ELSE
			AnnualGrossReforecastQ3
		END,0)
	ELSE
		ISNULL(CASE WHEN @ReforecastQuaterName = ''Q0'' THEN
			AnnualNetBudget
		ELSE
			AnnualNetReforecastQ3
		END,0)
	END)
	AS AnnualReforecastQ3	
	----- AnnualReforecast End
	
	--SUM(CASE WHEN (@IsGross = 1) THEN 
	--	ISNULL(CASE WHEN @PreviousReforecastQuaterName = ''Q1'' THEN 
	--		AnnualGrossReforecastQ1 		
	--	END,0) 
	--ELSE 
	--	ISNULL(CASE WHEN @PreviousReforecastQuaterName = ''Q1'' THEN 
	--		AnnualNetReforecastQ1	
	--	END,0) 
	--END) 
	--AS AnnualReforecastQ1

INTO
	#Output
FROM
	#BudgetOriginator res
	INNER JOIN AllocationRegion ar ON ar.AllocationRegionKey = res.AllocationRegionKey
	INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = res.OriginatingRegionKey
	INNER JOIN PropertyFund pf ON pf.PropertyFundKey = res.PropertyFundKey
	INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentKey = res.FunctionalDepartmentKey
	INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = res.GlAccountCategoryKey 
	LEFT OUTER JOIN GlAccount ga ON ga.GlAccountKey = res.GlAccountKey 
GROUP BY	
	gac.AccountSubTypeName,
    ar.RegionName,
    ar.SubRegionName,
    orr.RegionName,
    orr.SubRegionName,
    fd.FunctionalDepartmentName,
    fd.SubFunctionalDepartmentName,
    gac.MajorCategoryName,
    gac.MinorCategoryName,
    pf.PropertyFundType,
    pf.PropertyFundName,
    res.CalendarPeriod,
    res.EntryDate,
    res.[User],
    res.[Description],
    res.AdditionalDescription,
    res.SourceName,
    res.PropertyFundCode,
    res.OriginatingRegionCode,
    ISNULL(ga.Code, ''''),
    ISNULL(ga.Name, '''')
	
--Output
SELECT
	ExpenseType,
    AllocationRegionName,
    AllocationSubRegionName,
    OriginatingRegionName,
    OriginatingSubRegionName,
    FunctionalDepartmentName,
    JobCode,
    MajorExpenseCategoryName,
    MinorExpenseCategoryName,
    EntityType,
    EntityName,
    ExpensePeriod,
    EntryDate,
    [User],
    [Description],
    AdditionalDescription,
    SourceName,
    PropertyFundCode,
    OriginatingRegionCode,
    GlAccountCode,
    GlAccountName,
    
	--Month to date    
	MtdActual,
	MtdOriginalBudget,
	
	--MtdReforecastQ1,
	--MtdReforecastQ2,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE MtdReforecastQ3 END AS MtdReforecastQ3,
	
	--MtdVarianceQ1,
	--MtdVarianceQ2,
	MtdVarianceQ3,
		
	--Year to date
	YtdActual,	
	YtdOriginalBudget,
	
	--YtdReforecastQ1,
	--YtdReforecastQ2,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE YtdReforecastQ3 END AS YtdReforecastQ3,
	
	--YtdVarianceQ1,
	--YtdVarianceQ2,
	YtdVarianceQ3,
	
	--Annual
	AnnualOriginalBudget,
	
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE AnnualReforecastQ1 END AS AnnualReforecastQ1,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE AnnualReforecastQ2 END AS AnnualReforecastQ2,
	CASE WHEN @ReforecastQuaterName = ''Q0'' THEN 0 ELSE AnnualReforecastQ3 END AS AnnualReforecastQ3
	
	--Annual Estimated
	--AnnualEstimatedActual,	
	--AnnualEstimatedVariance
FROM
	#Output
WHERE
	--Month to date    
	MtdActual <> 0.00 OR
	MtdOriginalBudget <> 0.00 OR
	
	/* removed for Q0
	--MtdReforecastQ1 <> 0.00 OR
	--MtdReforecastQ2 <> 0.00 OR
	MtdReforecastQ3 <> 0.00 OR
	*/
		
	--MtdVarianceQ1 <> 0.00 OR
	--MtdVarianceQ2 <> 0.00 OR
	MtdVarianceQ3 <> 0.00 OR
			
	--Year to date
	YtdActual <> 0.00 OR	
	YtdOriginalBudget <> 0.00 OR
	
	/* removed for Q0
	--YtdReforecastQ1 <> 0.00 OR
	--YtdReforecastQ2 <> 0.00 OR
	YtdReforecastQ3 <> 0.00 OR
	*/
	
	--YtdVarianceQ1 <> 0.00 OR
	--YtdVarianceQ2 <> 0.00 OR
	YtdVarianceQ3 <> 0.00 OR
		
	--Annual
	AnnualOriginalBudget <> 0.00
	
	/* removed for Q0
	AnnualReforecastQ1 <> 0.00 OR
	AnnualReforecastQ2 <> 0.00 OR
	AnnualReforecastQ3 <> 0.00
	*/
	
	--Annual Estimated
	--AnnualEstimatedActual <> 0.00 OR	
	--AnnualEstimatedVariance <> 0.00
	
IF OBJECT_ID(''tempdb..#BudgetOriginator'') IS NOT NULL
    DROP TABLE #BudgetOriginator

IF 	OBJECT_ID(''tempdb..#Output'') IS NOT NULL
    DROP TABLE #Output

IF 	OBJECT_ID(''tempdb..#EntityFilterTable'') IS NOT NULL
	DROP TABLE #EntityFilterTable

IF 	OBJECT_ID(''tempdb..#FunctionalDepartmentFilterTable'') IS NOT NULL
	DROP TABLE #FunctionalDepartmentFilterTable

IF 	OBJECT_ID(''tempdb..#ActivityTypeFilterTable'') IS NOT NULL
	DROP TABLE #ActivityTypeFilterTable

IF 	OBJECT_ID(''tempdb..#AllocationRegionFilterTable'') IS NOT NULL
	DROP TABLE #AllocationRegionFilterTable

IF 	OBJECT_ID(''tempdb..#AllocationSubRegionFilterTable'') IS NOT NULL
	DROP TABLE #AllocationSubRegionFilterTable

IF 	OBJECT_ID(''tempdb..#MajorAccountCategoryFilterTable'') IS NOT NULL
	DROP TABLE #MajorAccountCategoryFilterTable

IF 	OBJECT_ID(''tempdb..#MinorAccountCategoryFilterTable'') IS NOT NULL
	DROP TABLE #MinorAccountCategoryFilterTable

IF 	OBJECT_ID(''tempdb..#OriginatingRegionFilterTable'') IS NOT NULL
	DROP TABLE #OriginatingRegionFilterTable

IF 	OBJECT_ID(''tempdb..#OriginatingSubRegionFilterTable'') IS NOT NULL
	DROP TABLE #OriginatingSubRegionFilterTable

' 
END
GO


---------------------------------------------------------------------------------------------------------------------------------------

USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ProfitabilityV2]    Script Date: 04/08/2010 18:01:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ProfitabilityV2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ProfitabilityV2]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ProfitabilityV2]    Script Date: 12/29/2009 11:20:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE [dbo].[stp_R_ProfitabilityV2]
	@ReportExpensePeriod INT = NULL,
	@ReforecastQuaterName VARCHAR(10) = NULL, --'Q1' or 'Q2' or 'Q3'
	@DestinationCurrency VARCHAR(3) = NULL,
	@TranslationTypeName VARCHAR(50) = 'Global',
	@IsGross Bit=NULL, --not used, just placeholder
	@FunctionalDepartmentList TEXT = NULL,
	@ActivityTypeList TEXT = NULL,
	@EntityList TEXT = NULL,
	@MajorAccountCategoryList TEXT = NULL,
	@MinorAccountCategoryList TEXT = NULL,
	@AllocationRegionList TEXT = NULL,
	@AllocationSubRegionList TEXT = NULL,
	@OriginatingRegionList TEXT = NULL,
	@OriginatingSubRegionList TEXT = NULL,
	@DisplayOverheadBy Varchar(12)='Allocated', --alloc / unalloc

	--Customized Filter Logic Specific to this Report
	@IncludeGrossNonPayrollExpenses TinyInt = NULL,
	@IncludeFeeAdjustments TinyInt = NULL,
	@DisplayFeeAdjustmentsBy Varchar(20) = NULL,
	@OverheadOriginatingSubRegionList TEXT = NULL 
	

AS


IF ISNULL(@DisplayOverheadBy,'') NOT IN ('Allocated','Unallocated')
	BEGIN
	RAISERROR ('@DisplayOverheadBy have invalid value (Must be one of:Allocated,Unallocated)',18,1)
	RETURN
	END

IF (@IncludeFeeAdjustments = 1 AND ISNULL(@DisplayFeeAdjustmentsBy,'') NOT IN ('AllocationRegion','ReportingEntity'))
	BEGIN
	RAISERROR ('@DisplayFeeAdjustmentsBy have invalid value (Must be one of:AllocationRegion,ReportingEntity)',18,1)
	RETURN
	END
	
IF @ReforecastQuaterName IS NULL OR @ReforecastQuaterName NOT IN ('Q0', 'Q1', 'Q2', 'Q3')
	SET @ReforecastQuaterName = (SELECT TOP 1
									ReforecastQuarterName 
								 FROM
									dbo.Reforecast 
								 WHERE
									ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
									ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
								 ORDER BY
									ReforecastEffectivePeriod DESC)

CREATE TABLE #DetailResult(
	ExpenseType varchar(50) NULL,
	FeeOrExpense varchar(50) NULL,
	MajorExpenseCategoryName varchar(100) NULL,
	MinorExpenseCategoryName varchar(100) NULL,
	GlobalGlAccountCode varchar(50) NULL,
	GlobalGlAccountName varchar(150) NULL,
	ActivityType varchar(50) NULL,
	ReportingEntityName varchar(100) NULL,
	
	PropertyFundCode varchar(6) NULL,
	FunctionalDepartmentCode varchar(15) NULL,
	AllocationSubRegionName varchar(50) NULL,
	OriginatingSubRegionName varchar(50) NULL,

	ActualsExpensePeriod Varchar(6) NULL,
	EntryDate varchar(10) NULL,
	[User] nvarchar(20) NULL,
	Description nvarchar(60) NULL,
	AdditionalDescription nvarchar(4000) NULL,
	ReimbursableName varchar(50) NULL,
	FeeAdjustmentCode varchar(10) NULL,
	SourceName varchar(50) NULL,
	GlAccountCategoryKey int not null,
	
	MtdActual money NULL,
	MtdOriginalBudget money NULL,
	MtdReforecastQ1 money NULL,
	MtdReforecastQ2 money NULL,
	MtdReforecastQ3 money NULL,
	MtdVarianceQ0 money NULL,
	MtdVarianceQ1 money NULL,
	MtdVarianceQ2 money NULL,
	MtdVarianceQ3 money NULL,
	YtdActual money NULL,
	YtdOriginalBudget money NULL,
	YtdReforecastQ1 money NULL,
	YtdReforecastQ2 money NULL,
	YtdReforecastQ3 money NULL,
	YtdVarianceQ0 money NULL,
	YtdVarianceQ1 money NULL,
	YtdVarianceQ2 money NULL,
	YtdVarianceQ3 money NULL,
	AnnualOriginalBudget money NULL,
	AnnualReforecastQ1 money NULL,
	AnnualReforecastQ2 money NULL,
	AnnualReforecastQ3 money NULL
)

Insert Into #DetailResult
(	ExpenseType, 
	FeeOrExpense,
    MajorExpenseCategoryName,
    MinorExpenseCategoryName,
	GlobalGlAccountCode,
	GlobalGlAccountName,
    ActivityType,
	ReportingEntityName,
	PropertyFundCode,
	FunctionalDepartmentCode,
	AllocationSubRegionName,
	OriginatingSubRegionName,
	ActualsExpensePeriod,
    EntryDate,
    [User],
    [Description],
    AdditionalDescription,
	ReimbursableName,
	FeeAdjustmentCode,
	SourceName,
	GlAccountCategoryKey,

	--Gross
	--Month to date    
	MtdActual,
	MtdOriginalBudget,
	MtdReforecastQ1,
	MtdReforecastQ2,
	MtdReforecastQ3,

	MtdVarianceQ0,
	MtdVarianceQ1,
	MtdVarianceQ2,
	MtdVarianceQ3,
	
	--Year to date
	YtdActual,	
	YtdOriginalBudget,
	YtdReforecastQ1,
	YtdReforecastQ2,
	YtdReforecastQ3,

	YtdVarianceQ0,
	YtdVarianceQ1,
	YtdVarianceQ2,
	YtdVarianceQ3,
	
	--Annual
	AnnualOriginalBudget,	
	AnnualReforecastQ1,
	AnnualReforecastQ2,
	AnnualReforecastQ3)
	
exec [stp_R_ProfitabilityDetailV2]
	@ReportExpensePeriod = @ReportExpensePeriod,
	@DestinationCurrency = @DestinationCurrency,
	@TranslationTypeName = @TranslationTypeName,
	@FunctionalDepartmentList = @FunctionalDepartmentList,
	@ActivityTypeList = @ActivityTypeList,
	@EntityList = @EntityList,
	@MajorAccountCategoryList = @MajorAccountCategoryList,
	@MinorAccountCategoryList = @MinorAccountCategoryList,
	@AllocationRegionList = @AllocationRegionList,
	@AllocationSubRegionList = @AllocationSubRegionList,
	@OriginatingRegionList = @OriginatingRegionList,
	@OriginatingSubRegionList = @OriginatingSubRegionList,
	@DisplayOverheadBy = @DisplayOverheadBy,
	@OverheadOriginatingSubRegionList = @OverheadOriginatingSubRegionList,
	@IncludeFeeAdjustments = @IncludeFeeAdjustments


--select * Into DetailResult From #DetailResult

--select * Into #DetailResult From DetailResult


CREATE TABLE #Result (
	NumberOfSpacesToPad TinyInt NOT NULL,
	GroupDisplayCode Varchar(500) NOT NULL,
	GroupDisplayName Varchar(500) NOT NULL,
	DisplayOrderNumber Int NOT NULL,
	MtdActual money NOT NULL DEFAULT(0),
	MtdOriginalBudget money NOT NULL DEFAULT(0),
	MtdReforecastQ1 money NOT NULL DEFAULT(0),
	MtdReforecastQ2 money NOT NULL DEFAULT(0),
	MtdReforecastQ3 money NOT NULL DEFAULT(0),
	
	MtdVarianceQ0 money NOT NULL DEFAULT(0),
	MtdVarianceQ1 money NOT NULL DEFAULT(0),
	MtdVarianceQ2 money NOT NULL DEFAULT(0),
	MtdVarianceQ3 money NOT NULL DEFAULT(0),

	MtdVariancePercentageQ0 money NOT NULL DEFAULT(0),
	MtdVariancePercentageQ1 money NOT NULL DEFAULT(0),
	MtdVariancePercentageQ2 money NOT NULL DEFAULT(0),
	MtdVariancePercentageQ3 money NOT NULL DEFAULT(0),
	
	YtdActual money NOT NULL DEFAULT(0),
	YtdOriginalBudget money NOT NULL DEFAULT(0),
	YtdReforecastQ1 money NOT NULL DEFAULT(0),
	YtdReforecastQ2 money NOT NULL DEFAULT(0),
	YtdReforecastQ3 money NOT NULL DEFAULT(0),
	
	YtdVarianceQ0 money NOT NULL DEFAULT(0),
	YtdVarianceQ1 money NOT NULL DEFAULT(0),
	YtdVarianceQ2 money NOT NULL DEFAULT(0),
	YtdVarianceQ3 money NOT NULL DEFAULT(0),
	
	YtdVariancePercentageQ0 money NOT NULL DEFAULT(0),
	YtdVariancePercentageQ1 money NOT NULL DEFAULT(0),
	YtdVariancePercentageQ2 money NOT NULL DEFAULT(0),
	YtdVariancePercentageQ3 money NOT NULL DEFAULT(0),
	
	AnnualOriginalBudget money NOT NULL DEFAULT(0),
	AnnualReforecastQ1 money NOT NULL DEFAULT(0),
	AnnualReforecastQ2 money NOT NULL DEFAULT(0),
	AnnualReforecastQ3 money NOT NULL DEFAULT(0)
)

Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
VALUES(0,'REVENUE','REVENUE',100)

Insert Into #Result
(NumberOfSpacesToPad,GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
VALUES(0, 'OPERATINGREVENUE', 'Operating Revenue',200)

Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		gac.MinorCategoryName GroupDisplayCode,
		gac.MinorCategoryName,
		201 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0),
		ISNULL(SUM(t1.MtdOriginalBudget),0),
		ISNULL(SUM(t1.MtdReforecastQ1),0),
		ISNULL(SUM(t1.MtdReforecastQ2),0),
		ISNULL(SUM(t1.MtdReforecastQ3),0),
		ISNULL(SUM(t1.MtdVarianceQ0),0),
		ISNULL(SUM(t1.MtdVarianceQ1),0),
		ISNULL(SUM(t1.MtdVarianceQ2),0),
		ISNULL(SUM(t1.MtdVarianceQ3),0),
		ISNULL(SUM(t1.YtdActual),0),
		ISNULL(SUM(t1.YtdOriginalBudget),0),
		ISNULL(SUM(t1.YtdReforecastQ1),0),
		ISNULL(SUM(t1.YtdReforecastQ2),0),
		ISNULL(SUM(t1.YtdReforecastQ3),0),
		ISNULL(SUM(t1.YtdVarianceQ0),0),
		ISNULL(SUM(t1.YtdVarianceQ1),0),
		ISNULL(SUM(t1.YtdVarianceQ2),0),
		ISNULL(SUM(t1.YtdVarianceQ3),0),
		ISNULL(SUM(t1.AnnualOriginalBudget),0),
		ISNULL(SUM(t1.AnnualReforecastQ1),0),
		ISNULL(SUM(t1.AnnualReforecastQ2),0),
		ISNULL(SUM(t1.AnnualReforecastQ3),0)

From 
		GlAccountCategory gac
			LEFT OUTER JOIN (Select * 
							From #DetailResult t1
							Where t1.FeeAdjustmentCode		= 'NORMAL'
							) t1 ON gac.GlAccountCategoryKey = t1.GlAccountCategoryKey


Where	gac.FeeOrExpense		= 'INCOME'
AND		gac.MajorCategoryName	= 'Fee Income'
AND		gac.TranslationSubTypeName	= @TranslationTypeName
Group By 
		gac.MinorCategoryName
		
IF @DisplayFeeAdjustmentsBy = 'AllocationRegion'
	BEGIN
	
	Insert Into #Result
	(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
	MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
	MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
	YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
	YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
	AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)
	
	Select 
			5 NumberOfSpacesToPad,
			t1.MinorExpenseCategoryName + '-' + t1.AllocationSubRegionName GroupDisplayCode,
			t1.AllocationSubRegionName + ' Adjustment',
			201 DisplayOrderNumber,
			ISNULL(SUM(t1.MtdActual),0),
			ISNULL(SUM(t1.MtdOriginalBudget),0),
			ISNULL(SUM(t1.MtdReforecastQ1),0),
			ISNULL(SUM(t1.MtdReforecastQ2),0),
			ISNULL(SUM(t1.MtdReforecastQ3),0),
			ISNULL(SUM(t1.MtdVarianceQ0),0),
			ISNULL(SUM(t1.MtdVarianceQ1),0),
			ISNULL(SUM(t1.MtdVarianceQ2),0),
			ISNULL(SUM(t1.MtdVarianceQ3),0),
			ISNULL(SUM(t1.YtdActual),0),
			ISNULL(SUM(t1.YtdOriginalBudget),0),
			ISNULL(SUM(t1.YtdReforecastQ1),0),
			ISNULL(SUM(t1.YtdReforecastQ2),0),
			ISNULL(SUM(t1.YtdReforecastQ3),0),
			ISNULL(SUM(t1.YtdVarianceQ0),0),
			ISNULL(SUM(t1.YtdVarianceQ1),0),
			ISNULL(SUM(t1.YtdVarianceQ2),0),
			ISNULL(SUM(t1.YtdVarianceQ3),0),
			ISNULL(SUM(t1.AnnualOriginalBudget),0),
			ISNULL(SUM(t1.AnnualReforecastQ1),0),
			ISNULL(SUM(t1.AnnualReforecastQ2),0),
			ISNULL(SUM(t1.AnnualReforecastQ3),0)

	From #DetailResult t1


	Where	t1.FeeOrExpense				= 'INCOME'
	AND		t1.MajorExpenseCategoryName = 'Fee Income'
	AND		t1.FeeAdjustmentCode		= 'FEEADJUST'
	Group By 
			t1.MinorExpenseCategoryName + '-' + t1.AllocationSubRegionName,
			t1.AllocationSubRegionName + ' Adjustment'
	END
	
ELSE IF @DisplayFeeAdjustmentsBy = 'ReportingEntity'
	BEGIN
	Insert Into #Result
	(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
	MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
	MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
	YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
	YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
	AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)
	
	Select 
			5 NumberOfSpacesToPad,
			t1.MinorExpenseCategoryName + '-' + RTRIM(t1.ReportingEntityName) GroupDisplayCode,
			RTRIM(t1.ReportingEntityName) + ' Adjustment',
			201 DisplayOrderNumber,
			ISNULL(SUM(t1.MtdActual),0),
			ISNULL(SUM(t1.MtdOriginalBudget),0),
			ISNULL(SUM(t1.MtdReforecastQ1),0),
			ISNULL(SUM(t1.MtdReforecastQ2),0),
			ISNULL(SUM(t1.MtdReforecastQ3),0),
			ISNULL(SUM(t1.MtdVarianceQ0),0),
			ISNULL(SUM(t1.MtdVarianceQ1),0),
			ISNULL(SUM(t1.MtdVarianceQ2),0),
			ISNULL(SUM(t1.MtdVarianceQ3),0),
			ISNULL(SUM(t1.YtdActual),0),
			ISNULL(SUM(t1.YtdOriginalBudget),0),
			ISNULL(SUM(t1.YtdReforecastQ1),0),
			ISNULL(SUM(t1.YtdReforecastQ2),0),
			ISNULL(SUM(t1.YtdReforecastQ3),0),
			ISNULL(SUM(t1.YtdVarianceQ0),0),
			ISNULL(SUM(t1.YtdVarianceQ1),0),
			ISNULL(SUM(t1.YtdVarianceQ2),0),
			ISNULL(SUM(t1.YtdVarianceQ3),0),
			ISNULL(SUM(t1.AnnualOriginalBudget),0),
			ISNULL(SUM(t1.AnnualReforecastQ1),0),
			ISNULL(SUM(t1.AnnualReforecastQ2),0),
			ISNULL(SUM(t1.AnnualReforecastQ3),0)

	From #DetailResult t1


	Where	t1.FeeOrExpense				= 'INCOME'
	AND		t1.MajorExpenseCategoryName = 'Fee Income'
	AND		t1.FeeAdjustmentCode		= 'FEEADJUST'
	
	Group By 
			t1.MinorExpenseCategoryName + '-' + RTRIM(t1.ReportingEntityName),
			t1.ReportingEntityName
	END


Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		'TOTALOPERATINGREVENUE' GroupDisplayCode,
		'Total Operating Revenue',
		203 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0),
		ISNULL(SUM(t1.MtdOriginalBudget),0),
		ISNULL(SUM(t1.MtdReforecastQ1),0),
		ISNULL(SUM(t1.MtdReforecastQ2),0),
		ISNULL(SUM(t1.MtdReforecastQ3),0),
		ISNULL(SUM(t1.MtdVarianceQ0),0),
		ISNULL(SUM(t1.MtdVarianceQ1),0),
		ISNULL(SUM(t1.MtdVarianceQ2),0),
		ISNULL(SUM(t1.MtdVarianceQ3),0),
		ISNULL(SUM(t1.YtdActual),0),
		ISNULL(SUM(t1.YtdOriginalBudget),0),
		ISNULL(SUM(t1.YtdReforecastQ1),0),
		ISNULL(SUM(t1.YtdReforecastQ2),0),
		ISNULL(SUM(t1.YtdReforecastQ3),0),
		ISNULL(SUM(t1.YtdVarianceQ0),0),
		ISNULL(SUM(t1.YtdVarianceQ1),0),
		ISNULL(SUM(t1.YtdVarianceQ2),0),
		ISNULL(SUM(t1.YtdVarianceQ3),0),
		ISNULL(SUM(t1.AnnualOriginalBudget),0),
		ISNULL(SUM(t1.AnnualReforecastQ1),0),
		ISNULL(SUM(t1.AnnualReforecastQ2),0),
		ISNULL(SUM(t1.AnnualReforecastQ3),0)

From #DetailResult t1


Where	t1.FeeOrExpense				= 'INCOME'
AND		t1.MajorExpenseCategoryName = 'Fee Income'	

Insert Into #Result
(NumberOfSpacesToPad,GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
VALUES(0, 'OTHERREVENUE', 'Other Revenue',210)
	
	
Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		gac.MinorCategoryName GroupDisplayCode,
		gac.MinorCategoryName,
		211 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0),
		ISNULL(SUM(t1.MtdOriginalBudget),0),
		ISNULL(SUM(t1.MtdReforecastQ1),0),
		ISNULL(SUM(t1.MtdReforecastQ2),0),
		ISNULL(SUM(t1.MtdReforecastQ3),0),
		ISNULL(SUM(t1.MtdVarianceQ0),0),
		ISNULL(SUM(t1.MtdVarianceQ1),0),
		ISNULL(SUM(t1.MtdVarianceQ2),0),
		ISNULL(SUM(t1.MtdVarianceQ3),0),
		ISNULL(SUM(t1.YtdActual),0),
		ISNULL(SUM(t1.YtdOriginalBudget),0),
		ISNULL(SUM(t1.YtdReforecastQ1),0),
		ISNULL(SUM(t1.YtdReforecastQ2),0),
		ISNULL(SUM(t1.YtdReforecastQ3),0),
		ISNULL(SUM(t1.YtdVarianceQ0),0),
		ISNULL(SUM(t1.YtdVarianceQ1),0),
		ISNULL(SUM(t1.YtdVarianceQ2),0),
		ISNULL(SUM(t1.YtdVarianceQ3),0),
		ISNULL(SUM(t1.AnnualOriginalBudget),0),
		ISNULL(SUM(t1.AnnualReforecastQ1),0),
		ISNULL(SUM(t1.AnnualReforecastQ2),0),
		ISNULL(SUM(t1.AnnualReforecastQ3),0)

From GlAccountCategory gac

			LEFT OUTER JOIN #DetailResult t1 ON gac.GlAccountCategoryKey = t1.GlAccountCategoryKey


Where	gac.FeeOrExpense		= 'INCOME'
AND		gac.MajorCategoryName	<> 'Fee Income'
AND		gac.TranslationSubTypeName	= @TranslationTypeName
Group By 
		gac.MinorCategoryName
	

Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		'TOTALOTHERREVENUE' GroupDisplayCode,
		'Total Other Revenue',
		212 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0),
		ISNULL(SUM(t1.MtdOriginalBudget),0),
		ISNULL(SUM(t1.MtdReforecastQ1),0),
		ISNULL(SUM(t1.MtdReforecastQ2),0),
		ISNULL(SUM(t1.MtdReforecastQ3),0),
		ISNULL(SUM(t1.MtdVarianceQ0),0),
		ISNULL(SUM(t1.MtdVarianceQ1),0),
		ISNULL(SUM(t1.MtdVarianceQ2),0),
		ISNULL(SUM(t1.MtdVarianceQ3),0),
		ISNULL(SUM(t1.YtdActual),0),
		ISNULL(SUM(t1.YtdOriginalBudget),0),
		ISNULL(SUM(t1.YtdReforecastQ1),0),
		ISNULL(SUM(t1.YtdReforecastQ2),0),
		ISNULL(SUM(t1.YtdReforecastQ3),0),
		ISNULL(SUM(t1.YtdVarianceQ0),0),
		ISNULL(SUM(t1.YtdVarianceQ1),0),
		ISNULL(SUM(t1.YtdVarianceQ2),0),
		ISNULL(SUM(t1.YtdVarianceQ3),0),
		ISNULL(SUM(t1.AnnualOriginalBudget),0),
		ISNULL(SUM(t1.AnnualReforecastQ1),0),
		ISNULL(SUM(t1.AnnualReforecastQ2),0),
		ISNULL(SUM(t1.AnnualReforecastQ3),0)

From #DetailResult t1


Where	t1.FeeOrExpense				= 'INCOME'
AND		t1.MajorExpenseCategoryName <> 'Fee Income'	


Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		'TOTALREVENUE' GroupDisplayCode,
		'Total Revenue',
		220 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0),
		ISNULL(SUM(t1.MtdOriginalBudget),0),
		ISNULL(SUM(t1.MtdReforecastQ1),0),
		ISNULL(SUM(t1.MtdReforecastQ2),0),
		ISNULL(SUM(t1.MtdReforecastQ3),0),
		ISNULL(SUM(t1.MtdVarianceQ0),0),
		ISNULL(SUM(t1.MtdVarianceQ1),0),
		ISNULL(SUM(t1.MtdVarianceQ2),0),
		ISNULL(SUM(t1.MtdVarianceQ3),0),
		ISNULL(SUM(t1.YtdActual),0),
		ISNULL(SUM(t1.YtdOriginalBudget),0),
		ISNULL(SUM(t1.YtdReforecastQ1),0),
		ISNULL(SUM(t1.YtdReforecastQ2),0),
		ISNULL(SUM(t1.YtdReforecastQ3),0),
		ISNULL(SUM(t1.YtdVarianceQ0),0),
		ISNULL(SUM(t1.YtdVarianceQ1),0),
		ISNULL(SUM(t1.YtdVarianceQ2),0),
		ISNULL(SUM(t1.YtdVarianceQ3),0),
		ISNULL(SUM(t1.AnnualOriginalBudget),0),
		ISNULL(SUM(t1.AnnualReforecastQ1),0),
		ISNULL(SUM(t1.AnnualReforecastQ2),0),
		ISNULL(SUM(t1.AnnualReforecastQ3),0)

From #DetailResult t1
Where	t1.FeeOrExpense				= 'INCOME'

Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
		0 NumberOfSpacesToPad,
		'BLANK' GroupDisplayCode,
		'',
		230 DisplayOrderNumber


Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
		0 NumberOfSpacesToPad,
		'EXPENSES' GroupDisplayCode,
		'EXPENSES',
		240 DisplayOrderNumber
		
		
Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
		0 NumberOfSpacesToPad,
		'PAYROLLEXPENSES' GroupDisplayCode,
		'Payroll Expenses',
		241 DisplayOrderNumber


		
Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		'Gross ' + t1.MajorExpenseCategoryName GroupDisplayCode,
		'Gross ' + t1.MajorExpenseCategoryName,
		242 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0) * -1,
		ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.YtdActual),0) * -1,
		ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

From #DetailResult t1
Where	t1.FeeOrExpense				= 'EXPENSE'
AND		t1.MajorExpenseCategoryName = 'Salaries/Taxes/Benefits'
AND		t1.ExpenseType				<> 'Overhead'
Group By 
		t1.MajorExpenseCategoryName
		
		
Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		'Reimbursed ' + t1.MajorExpenseCategoryName GroupDisplayCode,
		'Reimbursed ' + t1.MajorExpenseCategoryName,
		243 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0) * -1,
		ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.YtdActual),0) * -1,
		ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

From #DetailResult t1
Where	t1.FeeOrExpense				= 'EXPENSE'
AND		t1.MajorExpenseCategoryName = 'Salaries/Taxes/Benefits'
AND		t1.ReimbursableName			= 'Reimbursable'
AND		t1.ExpenseType				<> 'Overhead'
Group By 
		t1.MajorExpenseCategoryName	

		
Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		'Total Net ' + t1.MajorExpenseCategoryName GroupDisplayCode,
		'Total Net ' + t1.MajorExpenseCategoryName,
		244 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0) * -1,
		ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.YtdActual),0) * -1,
		ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

From #DetailResult t1
Where	t1.FeeOrExpense				= 'EXPENSE'
AND		t1.MajorExpenseCategoryName = 'Salaries/Taxes/Benefits'
AND		t1.ReimbursableName			= 'Not Reimbursable'
AND		t1.ExpenseType				<> 'Overhead'
Group By 
		t1.MajorExpenseCategoryName	
		
Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		'Payroll Reimbursement Rate' GroupDisplayCode,
		'% Recovery',
		245 DisplayOrderNumber,
		ISNULL(Reimbursed.MtdActual / CASE WHEN Gross.MtdActual = 0 THEN NULL ELSE Gross.MtdActual END,0),
		ISNULL(Reimbursed.MtdOriginalBudget / CASE WHEN Gross.MtdOriginalBudget = 0 THEN NULL ELSE Gross.MtdOriginalBudget END,0),
		ISNULL(Reimbursed.MtdReforecastQ1 / CASE WHEN Gross.MtdReforecastQ1 = 0 THEN NULL ELSE Gross.MtdReforecastQ1 END,0),
		ISNULL(Reimbursed.MtdReforecastQ2 / CASE WHEN Gross.MtdReforecastQ2 = 0 THEN NULL ELSE Gross.MtdReforecastQ2 END,0),
		ISNULL(Reimbursed.MtdReforecastQ3 / CASE WHEN Gross.MtdReforecastQ3 = 0 THEN NULL ELSE Gross.MtdReforecastQ3 END,0),
		0,
		0,
		0,
		0,
		ISNULL(Reimbursed.YtdActual / CASE WHEN Gross.YtdActual = 0 THEN NULL ELSE Gross.YtdActual END,0),
		ISNULL(Reimbursed.YtdOriginalBudget / CASE WHEN Gross.YtdOriginalBudget = 0 THEN NULL ELSE Gross.YtdOriginalBudget END,0),
		ISNULL(Reimbursed.YtdReforecastQ1 / CASE WHEN Gross.YtdReforecastQ1 = 0 THEN NULL ELSE Gross.YtdReforecastQ1 END,0),
		ISNULL(Reimbursed.YtdReforecastQ2 / CASE WHEN Gross.YtdReforecastQ2 = 0 THEN NULL ELSE Gross.YtdReforecastQ2 END,0),
		ISNULL(Reimbursed.YtdReforecastQ3 / CASE WHEN Gross.YtdReforecastQ3 = 0 THEN NULL ELSE Gross.YtdReforecastQ3 END,0),
		0,
		0,
		0,
		0,
		ISNULL(Reimbursed.AnnualOriginalBudget / CASE WHEN Gross.AnnualOriginalBudget = 0 THEN NULL ELSE Gross.AnnualOriginalBudget END,0),
		ISNULL(Reimbursed.AnnualReforecastQ1 / CASE WHEN Gross.AnnualReforecastQ1 = 0 THEN NULL ELSE Gross.AnnualReforecastQ1 END,0),
		ISNULL(Reimbursed.AnnualReforecastQ2 / CASE WHEN Gross.AnnualReforecastQ2 = 0 THEN NULL ELSE Gross.AnnualReforecastQ2 END,0),
		ISNULL(Reimbursed.AnnualReforecastQ3 / CASE WHEN Gross.AnnualReforecastQ3 = 0 THEN NULL ELSE Gross.AnnualReforecastQ3 END,0)
From 
	(
		Select 
					ISNULL(SUM(t1.MtdActual),0) MtdActual,
					ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
					ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
					ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
					ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
					ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
					ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
					ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
					ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
					ISNULL(SUM(t1.YtdActual),0) YtdActual,
					ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
					ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
					ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
					ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
					ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
					ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
					ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
					ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
					ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
					ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
					ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
					ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

		From #DetailResult t1
		Where	t1.FeeOrExpense				= 'EXPENSE'
		AND		t1.MajorExpenseCategoryName = 'Salaries/Taxes/Benefits'
		AND		t1.ReimbursableName			= 'Reimbursable'
		AND		t1.ExpenseType				<> 'Overhead'
		) Reimbursed
		CROSS JOIN 
			(
				Select 
					ISNULL(SUM(t1.MtdActual),0) MtdActual,
					ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
					ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
					ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
					ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
					ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
					ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
					ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
					ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
					ISNULL(SUM(t1.YtdActual),0) YtdActual,
					ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
					ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
					ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
					ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
					ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
					ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
					ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
					ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
					ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
					ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
					ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
					ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

				From #DetailResult t1
				Where	t1.FeeOrExpense				= 'EXPENSE'
				AND		t1.MajorExpenseCategoryName = 'Salaries/Taxes/Benefits'
				AND		t1.ExpenseType				<> 'Overhead'
			
			) Gross 
	
--Calculate the Payroll Reimbursement Rate Variance Columns
Update 		#Result
Set			
			MtdVarianceQ0 = (MtdActual - MtdOriginalBudget) * -1,
			MtdVarianceQ1 = (MtdActual - MtdReforecastQ1) * -1,
			MtdVarianceQ2 = (MtdActual - MtdReforecastQ2) * -1,
			MtdVarianceQ3 = (MtdActual - MtdReforecastQ3) * -1,
			YtdVarianceQ0 = (YtdActual - YtdOriginalBudget) * -1,
			YtdVarianceQ1 = (YtdActual - YtdReforecastQ1) * -1,
			YtdVarianceQ2 = (YtdActual - YtdReforecastQ2) * -1,
			YtdVarianceQ3 = (YtdActual - YtdReforecastQ3) * -1

Where	GroupDisplayCode = 'Payroll Reimbursement Rate'
AND		DisplayOrderNumber = 245	

	
Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
		0 NumberOfSpacesToPad,
		'BLANK' GroupDisplayCode,
		'',
		250 DisplayOrderNumber
		
Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
		0 NumberOfSpacesToPad,
		'OVERHEADEXPENSE' GroupDisplayCode,
		'Overhead  Expenses',
		260 DisplayOrderNumber

Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
		0 NumberOfSpacesToPad,
		'GROSSOVERHEADEXPENSE' GroupDisplayCode,
		'Gross Overhead  Expenses',
		261 DisplayOrderNumber


IF @DisplayOverheadBy = 'Unallocated'
	BEGIN

	Insert Into #Result
	(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
	MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
	MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
	YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
	YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
	AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

	Select 
			0 NumberOfSpacesToPad,
			gac.MajorCategoryName GroupDisplayCode,
			gac.MajorCategoryName,
			262 DisplayOrderNumber,
			ISNULL(SUM(t1.MtdActual),0) * -1,
			ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
			ISNULL(SUM(t1.YtdActual),0) * -1,
			ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
			ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

	From GlAccountCategory gac

				LEFT OUTER JOIN (Select * 
				From #DetailResult t1 
				Where t1.ExpenseType = 'Overhead') t1 ON gac.GlAccountCategoryKey = t1.GlAccountCategoryKey
				
	Where	gac.FeeOrExpense			= 'Expense'
	AND		gac.TranslationSubTypeName	= @TranslationTypeName
	AND		gac.AccountSubTypeName		= 'Overhead'
	Group By 
			gac.MajorCategoryName	
				
	END
ELSE
	BEGIN

	Insert Into #Result
	(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
	MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
	MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
	YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
	YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
	AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

	Select 
			0 NumberOfSpacesToPad,
			gac.MajorCategoryName GroupDisplayCode,
			gac.MajorCategoryName,
			262 DisplayOrderNumber,
			ISNULL(SUM(t1.MtdActual),0) * -1,
			ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
			ISNULL(SUM(t1.YtdActual),0) * -1,
			ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
			ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

	From GlAccountCategory gac

				INNER JOIN (Select * 
				From #DetailResult t1 
				Where t1.ExpenseType = 'Overhead') t1 ON gac.GlAccountCategoryKey = t1.GlAccountCategoryKey
				
	Where	gac.FeeOrExpense		= 'Expense'
	AND		gac.TranslationSubTypeName	= @TranslationTypeName
	AND		gac.AccountSubTypeName		= 'Overhead'
	Group By 
			gac.MajorCategoryName	
	END
	
IF @DisplayOverheadBy = 'Unallocated'
	BEGIN
	Insert Into #Result
	(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
	MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
	MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
	YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
	YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
	AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

	Select 
			0 NumberOfSpacesToPad,
			'Total Gross Overhead Expense' GroupDisplayCode,
			'Total Gross Overhead Expense',
			263 DisplayOrderNumber,
			ISNULL(SUM(t1.MtdActual),0) * -1,
			ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
			ISNULL(SUM(t1.YtdActual),0) * -1,
			ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
			ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

	From #DetailResult t1
	Where	t1.FeeOrExpense		= 'Expense'
	AND		t1.ExpenseType		= 'Overhead'

END

Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
		0 NumberOfSpacesToPad,
		'REIMBERSEDOVERHEADEXPENSE' GroupDisplayCode,
		'Reimbursed Overhead  Expenses',
		270 DisplayOrderNumber

IF @DisplayOverheadBy = 'Unallocated'
	BEGIN
		
	Insert Into #Result
	(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
	MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
	MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
	YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
	YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
	AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

	Select 
			0 NumberOfSpacesToPad,
			gac.MajorCategoryName GroupDisplayCode,
			gac.MajorCategoryName,
			271 DisplayOrderNumber,
			ISNULL(SUM(t1.MtdActual),0) * -1,
			ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
			ISNULL(SUM(t1.YtdActual),0) * -1,
			ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
			ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

	From GlAccountCategory gac

				LEFT OUTER JOIN (Select * 
								From #DetailResult t1
								Where	t1.ExpenseType		= 'Overhead'
								AND		t1.ReimbursableName	= 'Reimbursable'
								) t1
								 ON gac.GlAccountCategoryKey = t1.GlAccountCategoryKey
				
	Where	gac.FeeOrExpense		= 'Expense'
	AND		gac.TranslationSubTypeName	= @TranslationTypeName
	AND		gac.AccountSubTypeName		= 'Overhead'
	Group By 
			gac.MajorCategoryName	
	END
ELSE
	BEGIN
	Insert Into #Result
	(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
	MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
	MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
	YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
	YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
	AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

	Select 
			0 NumberOfSpacesToPad,
			gac.MajorCategoryName GroupDisplayCode,
			gac.MajorCategoryName,
			271 DisplayOrderNumber,
			ISNULL(SUM(t1.MtdActual),0) * -1,
			ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
			ISNULL(SUM(t1.YtdActual),0) * -1,
			ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
			ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

	From GlAccountCategory gac

				INNER JOIN (Select * 
								From #DetailResult t1
								Where	t1.ExpenseType		= 'Overhead'
								AND		t1.ReimbursableName	= 'Reimbursable'
								) t1
								 ON gac.GlAccountCategoryKey = t1.GlAccountCategoryKey
				
	Where	gac.FeeOrExpense		= 'Expense'
	AND		gac.TranslationSubTypeName	= @TranslationTypeName
	AND		gac.AccountSubTypeName		= 'Overhead'
	Group By 
			gac.MajorCategoryName	
	END
				
IF @DisplayOverheadBy = 'Unallocated'
	BEGIN

	Insert Into #Result
	(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
	MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
	MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
	YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
	YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
	AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

	Select 
			0 NumberOfSpacesToPad,
			'Total Reimbursed Overhead Expense' GroupDisplayCode,
			'Total Reimbursed Overhead Expense',
			272 DisplayOrderNumber,
			ISNULL(SUM(t1.MtdActual),0) * -1,
			ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
			ISNULL(SUM(t1.YtdActual),0) * -1,
			ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
			ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

	From #DetailResult t1
	Where	t1.FeeOrExpense		= 'Expense'
	AND		t1.ExpenseType		= 'Overhead'
	AND		ReimbursableName	= 'Reimbursable'
END
		
Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		'Total Net Overhead Expense' GroupDisplayCode,
		'Total Net Overhead Expense',
		273 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0) * -1,
		ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.YtdActual),0) * -1,
		ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

From #DetailResult t1
Where	t1.FeeOrExpense		= 'Expense'
AND		t1.ExpenseType		= 'Overhead'
AND		t1.ReimbursableName = 'Not Reimbursable'


Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		'Overhead Reimbursement Rate' GroupDisplayCode,
		'% Recovery',
		274 DisplayOrderNumber,
		ISNULL(Reimbursed.MtdActual / CASE WHEN Gross.MtdActual = 0 THEN NULL ELSE Gross.MtdActual END,0),
		ISNULL(Reimbursed.MtdOriginalBudget / CASE WHEN Gross.MtdOriginalBudget = 0 THEN NULL ELSE Gross.MtdOriginalBudget END,0),
		ISNULL(Reimbursed.MtdReforecastQ1 / CASE WHEN Gross.MtdReforecastQ1 = 0 THEN NULL ELSE Gross.MtdReforecastQ1 END,0),
		ISNULL(Reimbursed.MtdReforecastQ2 / CASE WHEN Gross.MtdReforecastQ2 = 0 THEN NULL ELSE Gross.MtdReforecastQ2 END,0),
		ISNULL(Reimbursed.MtdReforecastQ3 / CASE WHEN Gross.MtdReforecastQ3 = 0 THEN NULL ELSE Gross.MtdReforecastQ3 END,0),
		0,
		0,
		0,
		0,
		ISNULL(Reimbursed.YtdActual / CASE WHEN Gross.YtdActual = 0 THEN NULL ELSE Gross.YtdActual END,0),
		ISNULL(Reimbursed.YtdOriginalBudget / CASE WHEN Gross.YtdOriginalBudget = 0 THEN NULL ELSE Gross.YtdOriginalBudget END,0),
		ISNULL(Reimbursed.YtdReforecastQ1 / CASE WHEN Gross.YtdReforecastQ1 = 0 THEN NULL ELSE Gross.YtdReforecastQ1 END,0),
		ISNULL(Reimbursed.YtdReforecastQ2 / CASE WHEN Gross.YtdReforecastQ2 = 0 THEN NULL ELSE Gross.YtdReforecastQ2 END,0),
		ISNULL(Reimbursed.YtdReforecastQ3 / CASE WHEN Gross.YtdReforecastQ3 = 0 THEN NULL ELSE Gross.YtdReforecastQ3 END,0),
		0,
		0,
		0,
		0,
		ISNULL(Reimbursed.AnnualOriginalBudget / CASE WHEN Gross.AnnualOriginalBudget = 0 THEN NULL ELSE Gross.AnnualOriginalBudget END,0),
		ISNULL(Reimbursed.AnnualReforecastQ1 / CASE WHEN Gross.AnnualReforecastQ1 = 0 THEN NULL ELSE Gross.AnnualReforecastQ1 END,0),
		ISNULL(Reimbursed.AnnualReforecastQ2 / CASE WHEN Gross.AnnualReforecastQ2 = 0 THEN NULL ELSE Gross.AnnualReforecastQ2 END,0),
		ISNULL(Reimbursed.AnnualReforecastQ3 / CASE WHEN Gross.AnnualReforecastQ3 = 0 THEN NULL ELSE Gross.AnnualReforecastQ3 END,0)

From 
	(
		Select 
					ISNULL(SUM(t1.MtdActual),0) MtdActual,
					ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
					ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
					ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
					ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
					ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
					ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
					ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
					ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
					ISNULL(SUM(t1.YtdActual),0) YtdActual,
					ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
					ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
					ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
					ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
					ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
					ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
					ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
					ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
					ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
					ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
					ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
					ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

		From #DetailResult t1
		Where	t1.FeeOrExpense		= 'Expense'
		AND		t1.ExpenseType		= 'Overhead'
		AND		t1.ReimbursableName	= 'Reimbursable'
		) Reimbursed
		CROSS JOIN 
			(
				Select 
					ISNULL(SUM(t1.MtdActual),0) MtdActual,
					ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
					ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
					ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
					ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
					ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
					ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
					ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
					ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
					ISNULL(SUM(t1.YtdActual),0) YtdActual,
					ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
					ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
					ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
					ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
					ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
					ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
					ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
					ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
					ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
					ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
					ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
					ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

				From #DetailResult t1
				Where	t1.FeeOrExpense		= 'Expense'
				AND		t1.ExpenseType		= 'Overhead'
			) Gross 

--Calculate the Overhead Reimbursement Rate Variance Columns
Update 		#Result
Set			
			MtdVarianceQ0 = (MtdActual - MtdOriginalBudget) * -1,
			MtdVarianceQ1 = (MtdActual - MtdReforecastQ1) * -1,
			MtdVarianceQ2 = (MtdActual - MtdReforecastQ2) * -1,
			MtdVarianceQ3 = (MtdActual - MtdReforecastQ3) * -1,
			YtdVarianceQ0 = (YtdActual - YtdOriginalBudget) * -1,
			YtdVarianceQ1 = (YtdActual - YtdReforecastQ1) * -1,
			YtdVarianceQ2 = (YtdActual - YtdReforecastQ2) * -1,
			YtdVarianceQ3 = (YtdActual - YtdReforecastQ3) * -1

Where	GroupDisplayCode = 'Overhead Reimbursement Rate'
AND		DisplayOrderNumber = 274

	
Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
		0 NumberOfSpacesToPad,
		'BLANK' GroupDisplayCode,
		'',
		280 DisplayOrderNumber
		
Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
		0 NumberOfSpacesToPad,
		'NONPAYROLLEXPENSE' GroupDisplayCode,
		'Non-Payroll Expenses',
		290 DisplayOrderNumber

IF @IncludeGrossNonPayrollExpenses = 1
	BEGIN
	
	Insert Into #Result
	(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
	Select 
		0 NumberOfSpacesToPad,
		'GROSSNONPAYROLLEXPENSE' GroupDisplayCode,
		'Gross Non-Payroll  Expenses',
		291 DisplayOrderNumber

	Insert Into #Result
	(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
	MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
	MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
	YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
	YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
	AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

	Select 
			0 NumberOfSpacesToPad,
			gac.MajorCategoryName GroupDisplayCode,
			gac.MajorCategoryName,
			292 DisplayOrderNumber,
			ISNULL(SUM(t1.MtdActual),0) * -1,
			ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
			ISNULL(SUM(t1.YtdActual),0) * -1,
			ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
			ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

	From GlAccountCategory gac

			LEFT OUTER JOIN (Select *
							From	#DetailResult t1
							Where	t1.ExpenseType		= 'Non-Payroll'
							) t1 ON gac.GlAccountCategoryKey = t1.GlAccountCategoryKey
			
	Where	gac.FeeOrExpense		= 'Expense'
	AND		gac.TranslationSubTypeName	= @TranslationTypeName
	AND		gac.AccountSubTypeName		= 'Non-Payroll'
	Group By 
			gac.MajorCategoryName	
					

	Insert Into #Result
	(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
	MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
	MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
	YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
	YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
	AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

	Select 
			0 NumberOfSpacesToPad,
			'Total Gross Non-Payroll Expense' GroupDisplayCode,
			'Total Gross Non-Payroll Expense',
			293 DisplayOrderNumber,
			ISNULL(SUM(t1.MtdActual),0) * -1,
			ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
			ISNULL(SUM(t1.YtdActual),0) * -1,
			ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
			ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

	From #DetailResult t1
	Where	t1.FeeOrExpense		= 'Expense'
	AND		t1.ExpenseType		= 'Non-Payroll'

	END


Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
	0 NumberOfSpacesToPad,
	'NETNONPAYROLLEXPENSE' GroupDisplayCode,
	'Net Non-Payroll  Expenses',
	301 DisplayOrderNumber

Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		gac.MajorCategoryName GroupDisplayCode,
		gac.MajorCategoryName,
		302 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0) * -1,
		ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.YtdActual),0) * -1,
		ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

From GlAccountCategory gac

			LEFT OUTER JOIN (Select * 
							From	#DetailResult t1
							Where
									t1.ExpenseType		= 'Non-Payroll'
							AND		t1.ReimbursableName = 'Not Reimbursable'

							) t1 ON gac.GlAccountCategoryKey = t1.GlAccountCategoryKey
			
Where	gac.FeeOrExpense			= 'Expense'
AND		gac.TranslationSubTypeName	= @TranslationTypeName
AND		gac.AccountSubTypeName		= 'Non-Payroll'
Group By 
		gac.MajorCategoryName	
				

Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		'Total Net Non-Payroll Expense' GroupDisplayCode,
		'Total Net Non-Payroll Expense',
		303 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0) * -1,
		ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.YtdActual),0) * -1,
		ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

From #DetailResult t1
Where	t1.FeeOrExpense		= 'Expense'
AND		t1.ExpenseType		= 'Non-Payroll'
AND		t1.ReimbursableName = 'Not Reimbursable'



Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
		0 NumberOfSpacesToPad,
		'BLANK' GroupDisplayCode,
		'',
		310 DisplayOrderNumber
		
Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		'TOTALNETEXPENSE' GroupDisplayCode,
		'Total Net Expenses',
		320 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0) * -1,
		ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.YtdActual),0) * -1,
		ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

From #DetailResult t1
Where	t1.FeeOrExpense		= 'Expense'
AND		t1.ReimbursableName = 'Not Reimbursable'

Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
		0 NumberOfSpacesToPad,
		'BLANK' GroupDisplayCode,
		'',
		321 DisplayOrderNumber

Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)
Select 
		0 NumberOfSpacesToPad,
		'PROFIT' GroupDisplayCode,
		'PROFIT',
		330 DisplayOrderNumber,
		(INC.MtdActual + EP.MtdActual) AS MtdActual,
		(INC.MtdOriginalBudget + EP.MtdOriginalBudget) AS MtdOriginalBudget,
		(INC.MtdReforecastQ1 + EP.MtdReforecastQ1) AS MtdReforecastQ1,
		(INC.MtdReforecastQ2 + EP.MtdReforecastQ2) AS MtdReforecastQ2,
		(INC.MtdReforecastQ3 + EP.MtdReforecastQ3) AS MtdReforecastQ3,
		(INC.MtdVarianceQ0 + EP.MtdVarianceQ0) AS MtdVarianceQ0,
		(INC.MtdVarianceQ1 + EP.MtdVarianceQ1) AS MtdVarianceQ1,
		(INC.MtdVarianceQ2 + EP.MtdVarianceQ2) AS MtdVarianceQ2,
		(INC.MtdVarianceQ3 + EP.MtdVarianceQ3) AS MtdVarianceQ3,
		(INC.YtdActual + EP.YtdActual) AS YtdActual,
		(INC.YtdOriginalBudget + EP.YtdOriginalBudget) AS YtdOriginalBudget,
		(INC.YtdReforecastQ1 + EP.YtdReforecastQ1) AS YtdReforecastQ1,
		(INC.YtdReforecastQ2 + EP.YtdReforecastQ2) AS YtdReforecastQ2,
		(INC.YtdReforecastQ3 + EP.YtdReforecastQ3) AS YtdReforecastQ3,
		(INC.YtdVarianceQ0 + EP.YtdVarianceQ0) AS YtdVarianceQ0,
		(INC.YtdVarianceQ1 + EP.YtdVarianceQ1) AS YtdVarianceQ1,
		(INC.YtdVarianceQ2 + EP.YtdVarianceQ2) AS YtdVarianceQ2,
		(INC.YtdVarianceQ3 + EP.YtdVarianceQ3) AS YtdVarianceQ3,
		(INC.AnnualOriginalBudget + EP.AnnualOriginalBudget) AS AnnualOriginalBudget,
		(INC.AnnualReforecastQ1 + EP.AnnualReforecastQ1) AS AnnualReforecastQ1,
		(INC.AnnualReforecastQ2 + EP.AnnualReforecastQ2) AS AnnualReforecastQ2,
		(INC.AnnualReforecastQ3 + EP.AnnualReforecastQ3) AS AnnualReforecastQ3
		
		
FROM	(
		Select 
				ISNULL(SUM(t1.MtdActual),0) MtdActual,
				ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
				ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
				ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
				ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
				ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
				ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
				ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
				ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
				ISNULL(SUM(t1.YtdActual),0) YtdActual,
				ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
				ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
				ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
				ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
				ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
				ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
				ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
				ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
				ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
				ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
				ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
				ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

		From #DetailResult t1
		Where	t1.FeeOrExpense				= 'INCOME'
		) INC
		CROSS JOIN (
		Select 
				ISNULL(SUM(t1.MtdActual),0) MtdActual,
				ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
				ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
				ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
				ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
				ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
				ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
				ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
				ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
				ISNULL(SUM(t1.YtdActual),0) YtdActual,
				ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
				ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
				ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
				ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
				ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
				ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
				ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
				ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
				ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
				ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
				ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
				ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

			From #DetailResult t1
			Where	t1.FeeOrExpense		= 'Expense'
			AND		t1.ReimbursableName = 'Not Reimbursable'
		) EP


Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)
Select 
		0 NumberOfSpacesToPad,
		'PROFITMARGIN' GroupDisplayCode,
		'Profit Margin (Profit / Total Revenue)',
		331 DisplayOrderNumber,
		ISNULL(((INC.MtdActual + EP.MtdActual) / CASE WHEN INC.MtdActual <> 0 THEN INC.MtdActual ELSE NULL END),0) AS MtdActual,
		ISNULL(((INC.MtdOriginalBudget + EP.MtdOriginalBudget) / CASE WHEN INC.MtdOriginalBudget <> 0 THEN INC.MtdOriginalBudget ELSE NULL END),0) AS MtdOriginalBudget,
		ISNULL(((INC.MtdReforecastQ1 + EP.MtdReforecastQ1) / CASE WHEN INC.MtdReforecastQ1 <> 0 THEN INC.MtdReforecastQ1 ELSE NULL END),0) AS MtdReforecastQ1,
		ISNULL(((INC.MtdReforecastQ2 + EP.MtdReforecastQ2) / CASE WHEN INC.MtdReforecastQ2 <> 0 THEN INC.MtdReforecastQ2 ELSE NULL END),0) AS MtdReforecastQ2,
		ISNULL(((INC.MtdReforecastQ3 + EP.MtdReforecastQ3) / CASE WHEN INC.MtdReforecastQ3 <> 0 THEN INC.MtdReforecastQ3 ELSE NULL END),0) AS MtdReforecastQ3,
		0 AS MtdVarianceQ0, --Done Below for it use these results to sub calculate
		0 AS MtdVarianceQ1, --Done Below for it use these results to sub calculate
		0 AS MtdVarianceQ2, --Done Below for it use these results to sub calculate
		0 AS MtdVarianceQ3, --Done Below for it use these results to sub calculate
		ISNULL(((INC.YtdActual + EP.YtdActual) / CASE WHEN INC.YtdActual <> 0 THEN INC.YtdActual ELSE NULL END),0) AS YtdActual,
		ISNULL(((INC.YtdOriginalBudget + EP.YtdOriginalBudget) / CASE WHEN INC.YtdOriginalBudget <> 0 THEN INC.YtdOriginalBudget ELSE NULL END),0) AS YtdOriginalBudget,
		ISNULL(((INC.YtdReforecastQ1 + EP.YtdReforecastQ1) / CASE WHEN INC.YtdReforecastQ1 <> 0 THEN INC.YtdReforecastQ1 ELSE NULL END),0) AS YtdReforecastQ1,
		ISNULL(((INC.YtdReforecastQ2 + EP.YtdReforecastQ2) / CASE WHEN INC.YtdReforecastQ2 <> 0 THEN INC.YtdReforecastQ2 ELSE NULL END),0) AS YtdReforecastQ2,
		ISNULL(((INC.YtdReforecastQ3 + EP.YtdReforecastQ3) / CASE WHEN INC.YtdReforecastQ3 <> 0 THEN INC.YtdReforecastQ3 ELSE NULL END),0) AS YtdReforecastQ3,
		0 AS YtdVarianceQ0, --Done Below for it use these results to sub calculate
		0 AS YtdVarianceQ1, --Done Below for it use these results to sub calculate
		0 AS YtdVarianceQ2, --Done Below for it use these results to sub calculate
		0 AS YtdVarianceQ3, --Done Below for it use these results to sub calculate
		ISNULL(((INC.AnnualOriginalBudget + EP.AnnualOriginalBudget) / CASE WHEN INC.AnnualOriginalBudget <> 0 THEN INC.AnnualOriginalBudget ELSE NULL END),0) AS AnnualOriginalBudget,
		ISNULL(((INC.AnnualReforecastQ1 + EP.AnnualReforecastQ1) / CASE WHEN INC.AnnualReforecastQ1 <> 0 THEN INC.AnnualReforecastQ1 ELSE NULL END),0) AS AnnualReforecastQ1,
		ISNULL(((INC.AnnualReforecastQ2 + EP.AnnualReforecastQ2) / CASE WHEN INC.AnnualReforecastQ2 <> 0 THEN INC.AnnualReforecastQ2 ELSE NULL END),0) AS AnnualReforecastQ2,
		ISNULL(((INC.AnnualReforecastQ3 + EP.AnnualReforecastQ3) / CASE WHEN INC.AnnualReforecastQ3 <> 0 THEN INC.AnnualReforecastQ3 ELSE NULL END),0) AS AnnualReforecastQ3
		
FROM	(
		Select 
				ISNULL(SUM(t1.MtdActual),0) MtdActual,
				ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
				ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
				ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
				ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
				ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
				ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
				ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
				ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
				ISNULL(SUM(t1.YtdActual),0) YtdActual,
				ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
				ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
				ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
				ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
				ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
				ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
				ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
				ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
				ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
				ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
				ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
				ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

		From #DetailResult t1
		Where	t1.FeeOrExpense				= 'INCOME'
		) INC
		CROSS JOIN (
		Select 
				ISNULL(SUM(t1.MtdActual),0) MtdActual,
				ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
				ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
				ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
				ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
				ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
				ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
				ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
				ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
				ISNULL(SUM(t1.YtdActual),0) YtdActual,
				ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
				ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
				ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
				ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
				ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
				ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
				ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
				ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
				ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
				ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
				ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
				ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

			From #DetailResult t1
			Where	t1.FeeOrExpense		= 'Expense'
			AND		t1.ReimbursableName = 'Not Reimbursable'
		) EP

--Calculate the Profit Variance Columns
Update 		#Result
Set			
			MtdVarianceQ0 = MtdActual - MtdOriginalBudget,
			MtdVarianceQ1 = MtdActual - MtdReforecastQ1,
			MtdVarianceQ2 = MtdActual - MtdReforecastQ2,
			MtdVarianceQ3 = MtdActual - MtdReforecastQ3,
			YtdVarianceQ0 = YtdActual - YtdOriginalBudget,
			YtdVarianceQ1 = YtdActual - YtdReforecastQ1,
			YtdVarianceQ2 = YtdActual - YtdReforecastQ2,
			YtdVarianceQ3 = YtdActual - YtdReforecastQ3

Where	GroupDisplayCode = 'PROFITMARGIN'
AND		DisplayOrderNumber = 331	
		
		
--------------------------------------------------------------------------------------------------------------------------------------	
--Final Common block to set the Variance% columns
--------------------------------------------------------------------------------------------------------------------------------------	
		
Update #Result
Set		
	MtdVariancePercentageQ0 = ISNULL(MtdVarianceQ0 / CASE WHEN MtdOriginalBudget <> 0 THEN MtdOriginalBudget ELSE NULL END,0) ,
	MtdVariancePercentageQ1 = ISNULL(MtdVarianceQ1 / CASE WHEN MtdReforecastQ1 <> 0 THEN MtdReforecastQ1 ELSE NULL END,0) ,
	MtdVariancePercentageQ2 = ISNULL(MtdVarianceQ2 / CASE WHEN MtdReforecastQ2 <> 0 THEN MtdReforecastQ2 ELSE NULL END,0) ,
	MtdVariancePercentageQ3 = ISNULL(MtdVarianceQ3 / CASE WHEN MtdReforecastQ3 <> 0 THEN MtdReforecastQ3 ELSE NULL END,0) ,

	YtdVariancePercentageQ0 = ISNULL(YtdVarianceQ0 / CASE WHEN YtdOriginalBudget <> 0 THEN YtdOriginalBudget ELSE NULL END,0) ,
	YtdVariancePercentageQ1 = ISNULL(YtdVarianceQ1 / CASE WHEN YtdReforecastQ1 <> 0 THEN YtdReforecastQ1 ELSE NULL END,0) ,
	YtdVariancePercentageQ2 = ISNULL(YtdVarianceQ2 / CASE WHEN YtdReforecastQ2 <> 0 THEN YtdReforecastQ2 ELSE NULL END,0) ,
	YtdVariancePercentageQ3 = ISNULL(YtdVarianceQ3 / CASE WHEN YtdReforecastQ3 <> 0 THEN YtdReforecastQ3 ELSE NULL END,0) 
Where GroupDisplayCode NOT IN('Payroll Reimbursement Rate','Overhead Reimbursement Rate','PROFITMARGIN')

--UNKNOWN MajorCategory

Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
		0 NumberOfSpacesToPad,
		'BLANK' GroupDisplayCode,
		'',
		340 DisplayOrderNumber

Insert Into #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

Select 
		0 NumberOfSpacesToPad,
		'UNKNOWN' GroupDisplayCode,
		'Unknown',
		341 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0),
		ISNULL(SUM(t1.MtdOriginalBudget),0),
		ISNULL(SUM(t1.MtdReforecastQ1),0),
		ISNULL(SUM(t1.MtdReforecastQ2),0),
		ISNULL(SUM(t1.MtdReforecastQ3),0),
		ISNULL(SUM(t1.MtdVarianceQ0),0),
		ISNULL(SUM(t1.MtdVarianceQ1),0),
		ISNULL(SUM(t1.MtdVarianceQ2),0),
		ISNULL(SUM(t1.MtdVarianceQ3),0),
		ISNULL(SUM(t1.YtdActual),0),
		ISNULL(SUM(t1.YtdOriginalBudget),0),
		ISNULL(SUM(t1.YtdReforecastQ1),0),
		ISNULL(SUM(t1.YtdReforecastQ2),0),
		ISNULL(SUM(t1.YtdReforecastQ3),0),
		ISNULL(SUM(t1.YtdVarianceQ0),0),
		ISNULL(SUM(t1.YtdVarianceQ1),0),
		ISNULL(SUM(t1.YtdVarianceQ2),0),
		ISNULL(SUM(t1.YtdVarianceQ3),0),
		ISNULL(SUM(t1.AnnualOriginalBudget),0),
		ISNULL(SUM(t1.AnnualReforecastQ1),0),
		ISNULL(SUM(t1.AnnualReforecastQ2),0),
		ISNULL(SUM(t1.AnnualReforecastQ3),0)

From #DetailResult t1
Where	t1.MajorExpenseCategoryName	= 'UNKNOWN'
Having (
		ISNULL(SUM(t1.MtdActual),0) <> 0 OR 
		ISNULL(SUM(t1.MtdOriginalBudget),0) <> 0 OR 
		ISNULL(SUM(t1.MtdReforecastQ1),0) <> 0 OR 
		ISNULL(SUM(t1.MtdReforecastQ2),0) <> 0 OR 
		ISNULL(SUM(t1.MtdReforecastQ3),0) <> 0 OR 
		ISNULL(SUM(t1.MtdVarianceQ0),0) <> 0 OR 
		ISNULL(SUM(t1.MtdVarianceQ1),0) <> 0 OR 
		ISNULL(SUM(t1.MtdVarianceQ2),0) <> 0 OR 
		ISNULL(SUM(t1.MtdVarianceQ3),0) <> 0 OR 
		ISNULL(SUM(t1.YtdActual),0) <> 0 OR 
		ISNULL(SUM(t1.YtdOriginalBudget),0) <> 0 OR 
		ISNULL(SUM(t1.YtdReforecastQ1),0) <> 0 OR 
		ISNULL(SUM(t1.YtdReforecastQ2),0) <> 0 OR 
		ISNULL(SUM(t1.YtdReforecastQ3),0) <> 0 OR 
		ISNULL(SUM(t1.YtdVarianceQ0),0) <> 0 OR 
		ISNULL(SUM(t1.YtdVarianceQ1),0) <> 0 OR 
		ISNULL(SUM(t1.YtdVarianceQ2),0) <> 0 OR 
		ISNULL(SUM(t1.YtdVarianceQ3),0) <> 0 OR 
		ISNULL(SUM(t1.AnnualOriginalBudget),0) <> 0 OR 
		ISNULL(SUM(t1.AnnualReforecastQ1),0) <> 0 OR 
		ISNULL(SUM(t1.AnnualReforecastQ2),0) <> 0 OR 
		ISNULL(SUM(t1.AnnualReforecastQ3),0) <> 0
	)




--------------------------------------------------------------------------------------------------------------------------------------	
--Final Result
--------------------------------------------------------------------------------------------------------------------------------------	

Select 
	NumberOfSpacesToPad,
	GroupDisplayCode,
	REPLICATE(' ', NumberOfSpacesToPad) + GroupDisplayName AS GroupDisplayName,
	DisplayOrderNumber,
	MtdActual,
	MtdOriginalBudget,
	CASE WHEN @ReforecastQuaterName = 'Q0' THEN 0 ELSE MtdReforecastQ1 END AS MtdReforecastQ1,
	CASE WHEN @ReforecastQuaterName = 'Q0' THEN 0 ELSE MtdReforecastQ2 END AS MtdReforecastQ2,
	CASE WHEN @ReforecastQuaterName = 'Q0' THEN 0 ELSE MtdReforecastQ3 END AS MtdReforecastQ3,
	
	MtdVarianceQ0,
	MtdVarianceQ1,
	MtdVarianceQ2,
	MtdVarianceQ3,

	MtdVariancePercentageQ0,
	MtdVariancePercentageQ1,
	MtdVariancePercentageQ2,
	MtdVariancePercentageQ3,
	
	YtdActual,
	YtdOriginalBudget,
	CASE WHEN @ReforecastQuaterName = 'Q0' THEN 0 ELSE YtdReforecastQ1 END AS YtdReforecastQ1,
	CASE WHEN @ReforecastQuaterName = 'Q0' THEN 0 ELSE YtdReforecastQ2 END AS YtdReforecastQ2,
	CASE WHEN @ReforecastQuaterName = 'Q0' THEN 0 ELSE YtdReforecastQ3 END AS YtdReforecastQ3,
	
	YtdVarianceQ0,
	YtdVarianceQ1,
	YtdVarianceQ2,
	YtdVarianceQ3,

	YtdVariancePercentageQ0,
	YtdVariancePercentageQ1,
	YtdVariancePercentageQ2,
	YtdVariancePercentageQ3,
		
	AnnualOriginalBudget,
	CASE WHEN @ReforecastQuaterName = 'Q0' THEN 0 ELSE AnnualReforecastQ1 END AS AnnualReforecastQ1,
	CASE WHEN @ReforecastQuaterName = 'Q0' THEN 0 ELSE AnnualReforecastQ2 END AS AnnualReforecastQ2,
	CASE WHEN @ReforecastQuaterName = 'Q0' THEN 0 ELSE AnnualReforecastQ3 END AS AnnualReforecastQ3
From #Result
Order By 
	DisplayOrderNumber,
	#Result.GroupDisplayCode

--Second Resultset for Excel
--Select * From #DetailResult



SELECT
	ExpenseType,
	FeeOrExpense,
	MajorExpenseCategoryName,
	MinorExpenseCategoryName,
	GlobalGlAccountCode,
	GlobalGlAccountName,
	ActivityType,
	ReportingEntityName,
	
	PropertyFundCode,
	FunctionalDepartmentCode,
	AllocationSubRegionName,
	OriginatingSubRegionName,

	ActualsExpensePeriod,
	EntryDate,
	[User],
	Description,
	AdditionalDescription,
	ReimbursableName,
	FeeAdjustmentCode,
	SourceName,
	GlAccountCategoryKey,
	
	MtdActual,
	MtdOriginalBudget,
	MtdReforecastQ1,
	MtdReforecastQ2,
	MtdReforecastQ3,
	MtdVarianceQ0,
	MtdVarianceQ1,
	MtdVarianceQ2,
	MtdVarianceQ3,
	YtdActual,
	YtdOriginalBudget,
	YtdReforecastQ1,
	YtdReforecastQ2,
	YtdReforecastQ3,
	YtdVarianceQ0,
	YtdVarianceQ1,
	YtdVarianceQ2,
	YtdVarianceQ3,
	AnnualOriginalBudget,
	AnnualReforecastQ1,
	AnnualReforecastQ2,
	AnnualReforecastQ3 
FROM
	#DetailResult

GO