 USE [GrReporting]
GO

/****** Object:  Table [dbo].[ProfitabilityReforecast]    Script Date: 03/17/2010 10:05:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ProfitabilityReforecast](
	[ProfitabilityReforecastKey] [bigint] IDENTITY(1,1) NOT NULL,
	[CalendarKey] [int] NOT NULL,
	[ReforecastKey] [int] NOT NULL,
	[GlAccountKey] [int] NOT NULL,
	[SourceKey] [int] NOT NULL,
	[FunctionalDepartmentKey] [int] NOT NULL,
	[ReimbursableKey] [int] NOT NULL,
	[ActivityTypeKey] [int] NOT NULL,
	[PropertyFundKey] [int] NOT NULL,
	[AllocationRegionKey] [int] NOT NULL,
	[OriginatingRegionKey] [int] NOT NULL,
	[LocalCurrencyKey] [int] NOT NULL,
	[LocalReforecast] [money] NOT NULL,
	[ReferenceCode] [varchar](500) NOT NULL,
	[EUCorporateGlAccountCategoryKey] [int] NULL,
	[USPropertyGlAccountCategoryKey] [int] NULL,
	[USFundGlAccountCategoryKey] [int] NULL,
	[EUPropertyGlAccountCategoryKey] [int] NULL,
	[USCorporateGlAccountCategoryKey] [int] NULL,
	[DevelopmentGlAccountCategoryKey] [int] NULL,
	[EUFundGlAccountCategoryKey] [int] NULL,
	[GlobalGlAccountCategoryKey] [int] NULL,
 CONSTRAINT [PK_ProfitabilityReforecast] PRIMARY KEY NONCLUSTERED 
(
	[ProfitabilityReforecastKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_Activity] FOREIGN KEY([ActivityTypeKey])
REFERENCES [dbo].[ActivityType] ([ActivityTypeKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_Activity]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_AllocationRegion] FOREIGN KEY([AllocationRegionKey])
REFERENCES [dbo].[AllocationRegion] ([AllocationRegionKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_AllocationRegion]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_Calendar] FOREIGN KEY([CalendarKey])
REFERENCES [dbo].[Calendar] ([CalendarKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_Calendar]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_Currency] FOREIGN KEY([LocalCurrencyKey])
REFERENCES [dbo].[Currency] ([CurrencyKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_Currency]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_FunctionalDepartment] FOREIGN KEY([FunctionalDepartmentKey])
REFERENCES [dbo].[FunctionalDepartment] ([FunctionalDepartmentKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_FunctionalDepartment]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_GlAccount] FOREIGN KEY([GlAccountKey])
REFERENCES [dbo].[GlAccount] ([GlAccountKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_GlAccount]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_OriginatingRegion] FOREIGN KEY([OriginatingRegionKey])
REFERENCES [dbo].[OriginatingRegion] ([OriginatingRegionKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_OriginatingRegion]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_PropertyFund] FOREIGN KEY([PropertyFundKey])
REFERENCES [dbo].[PropertyFund] ([PropertyFundKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_PropertyFund]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_Reforecast] FOREIGN KEY([ReforecastKey])
REFERENCES [dbo].[Reforecast] ([ReforecastKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_Reforecast]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_Reimbursable] FOREIGN KEY([ReimbursableKey])
REFERENCES [dbo].[Reimbursable] ([ReimbursableKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_Reimbursable]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_Source] FOREIGN KEY([SourceKey])
REFERENCES [dbo].[Source] ([SourceKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_Source]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FKDevelopmentGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory] FOREIGN KEY([DevelopmentGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FKDevelopmentGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FKEUCorporateGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory] FOREIGN KEY([EUCorporateGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FKEUCorporateGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FKEUFundGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory] FOREIGN KEY([EUFundGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FKEUFundGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FKEUPropertyGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory] FOREIGN KEY([EUPropertyGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FKEUPropertyGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FKGlobalGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory] FOREIGN KEY([GlobalGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FKGlobalGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FKUSCorporateGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory] FOREIGN KEY([USCorporateGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FKUSCorporateGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FKUSFundGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory] FOREIGN KEY([USFundGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FKUSFundGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FKUSPropertyGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory] FOREIGN KEY([USPropertyGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FKUSPropertyGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] ADD  CONSTRAINT [DF_ProfitabilityReforecast_LocalCurrencyKey]  DEFAULT ((-1)) FOR [LocalCurrencyKey]
GO


-- Add indexes


/****** Object:  Index [IX_ActivityTypeKey]    Script Date: 03/17/2010 10:15:38 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_ActivityTypeKey')
DROP INDEX [IX_ActivityTypeKey] ON [dbo].[ProfitabilityReforecast] WITH ( ONLINE = OFF )
GO

/****** Object:  Index [IX_AllocationRegionKey]    Script Date: 03/17/2010 10:15:38 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_AllocationRegionKey')
DROP INDEX [IX_AllocationRegionKey] ON [dbo].[ProfitabilityReforecast] WITH ( ONLINE = OFF )
GO

/****** Object:  Index [IX_CalendarKey]    Script Date: 03/17/2010 10:15:38 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_CalendarKey')
DROP INDEX [IX_CalendarKey] ON [dbo].[ProfitabilityReforecast] WITH ( ONLINE = OFF )
GO

/****** Object:  Index [IX_ReforecastKey]    Script Date: 03/17/2010 10:15:38 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_ReforecastKey')
DROP INDEX [IX_ReforecastKey] ON [dbo].[ProfitabilityReforecast] WITH ( ONLINE = OFF )
GO

/****** Object:  Index [IX_Clustered]    Script Date: 03/17/2010 10:15:38 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_Clustered')
DROP INDEX [IX_Clustered] ON [dbo].[ProfitabilityReforecast] WITH ( ONLINE = OFF )
GO

/****** Object:  Index [IX_FunctionalDepartmentKey]    Script Date: 03/17/2010 10:15:38 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_FunctionalDepartmentKey')
DROP INDEX [IX_FunctionalDepartmentKey] ON [dbo].[ProfitabilityReforecast] WITH ( ONLINE = OFF )
GO

/****** Object:  Index [IX_GlAccountKey]    Script Date: 03/17/2010 10:15:38 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_GlAccountKey')
DROP INDEX [IX_GlAccountKey] ON [dbo].[ProfitabilityReforecast] WITH ( ONLINE = OFF )
GO

/****** Object:  Index [IX_OriginatingRegionKey]    Script Date: 03/17/2010 10:15:38 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_OriginatingRegionKey')
DROP INDEX [IX_OriginatingRegionKey] ON [dbo].[ProfitabilityReforecast] WITH ( ONLINE = OFF )
GO

/****** Object:  Index [IX_PropertyFundKey]    Script Date: 03/17/2010 10:15:38 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_PropertyFundKey')
DROP INDEX [IX_PropertyFundKey] ON [dbo].[ProfitabilityReforecast] WITH ( ONLINE = OFF )
GO

/****** Object:  Index [IX_ReferenceCode]    Script Date: 03/17/2010 10:15:38 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_ReferenceCode')
DROP INDEX [IX_ReferenceCode] ON [dbo].[ProfitabilityReforecast] WITH ( ONLINE = OFF )
GO


/****** Object:  Index [IX_ActivityTypeKey]    Script Date: 03/17/2010 10:15:38 ******/
CREATE NONCLUSTERED INDEX [IX_ActivityTypeKey] ON [dbo].[ProfitabilityReforecast] 
(
	[ActivityTypeKey] ASC
)
INCLUDE ( [ProfitabilityReforecastKey],
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
[LocalReforecast]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_AllocationRegionKey]    Script Date: 03/17/2010 10:15:38 ******/
CREATE NONCLUSTERED INDEX [IX_AllocationRegionKey] ON [dbo].[ProfitabilityReforecast] 
(
	[AllocationRegionKey] ASC
)
INCLUDE ( [ProfitabilityReforecastKey],
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
[LocalReforecast]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_CalendarKey]    Script Date: 03/17/2010 10:15:38 ******/
CREATE NONCLUSTERED INDEX [IX_CalendarKey] ON [dbo].[ProfitabilityReforecast] 
(
	[CalendarKey] ASC
)
INCLUDE ( [LocalReforecast],
[ProfitabilityReforecastKey],
[ReforecastKey],
[PropertyFundKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[AllocationRegionKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[GlAccountKey],
[SourceKey],
[ActivityTypeKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_ReforecastKey]    Script Date: 03/17/2010 10:15:38 ******/
CREATE NONCLUSTERED INDEX [IX_ReforecatKey] ON [dbo].[ProfitabilityReforecast] 
(
	[ReforecastKey] ASC
)
INCLUDE ( [LocalReforecast],
[ProfitabilityReforecastKey],
[CalendarKey],
[PropertyFundKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[AllocationRegionKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[GlAccountKey],
[SourceKey],
[ActivityTypeKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_Clustered]    Script Date: 03/17/2010 10:15:38 ******/
CREATE CLUSTERED INDEX [IX_Clustered] ON [dbo].[ProfitabilityReforecast] 
(
	[CalendarKey] ASC,
	[ReforecastKey] ASC,
	[LocalCurrencyKey] ASC,
	[FunctionalDepartmentKey] ASC,
	[AllocationRegionKey] ASC,
	[OriginatingRegionKey] ASC,
	[PropertyFundKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_FunctionalDepartmentKey]    Script Date: 03/17/2010 10:15:38 ******/
CREATE NONCLUSTERED INDEX [IX_FunctionalDepartmentKey] ON [dbo].[ProfitabilityReforecast] 
(
	[FunctionalDepartmentKey] ASC
)
INCLUDE ( [ProfitabilityReforecastKey],
[CalendarKey],
[ReforecastKey],
[ReimbursableKey],
[PropertyFundKey],
[AllocationRegionKey],
[LocalCurrencyKey],
[LocalReforecast],
[GlAccountKey],
[SourceKey],
[ActivityTypeKey],
[OriginatingRegionKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_GlAccountKey]    Script Date: 03/17/2010 10:15:38 ******/
CREATE NONCLUSTERED INDEX [IX_GlAccountKey] ON [dbo].[ProfitabilityReforecast] 
(
	[GlAccountKey] ASC
)
INCLUDE ( [ProfitabilityReforecastKey],
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
[LocalReforecast]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_OriginatingRegionKey]    Script Date: 03/17/2010 10:15:38 ******/
CREATE NONCLUSTERED INDEX [IX_OriginatingRegionKey] ON [dbo].[ProfitabilityReforecast] 
(
	[OriginatingRegionKey] ASC
)
INCLUDE ( [ProfitabilityReforecastKey],
[CalendarKey],
[ReforecastKey],
[GlAccountKey],
[SourceKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[ActivityTypeKey],
[PropertyFundKey],
[AllocationRegionKey],
[LocalCurrencyKey],
[LocalReforecast]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_PropertyFundKey]    Script Date: 03/17/2010 10:15:38 ******/
CREATE NONCLUSTERED INDEX [IX_PropertyFundKey] ON [dbo].[ProfitabilityReforecast] 
(
	[PropertyFundKey] ASC
)
INCLUDE ( [LocalReforecast],
[ProfitabilityReforecastKey],
[CalendarKey],
[ReforecastKey],
[GlAccountKey],
[SourceKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[ActivityTypeKey],
[AllocationRegionKey],
[OriginatingRegionKey],
[LocalCurrencyKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_ReferenceCode]    Script Date: 03/17/2010 10:15:38 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ReferenceCode] ON [dbo].[ProfitabilityReforecast] 
(
	[ReferenceCode] ASC
)
INCLUDE ( [ProfitabilityReforecastKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


--Add BudgetId and Source System columns
ALTER TABLE dbo.ProfitabilityReforecast ADD BudgetId int NULL
GO

ALTER TABLE dbo.ProfitabilityReforecast ADD SourceSystemId int NULL
GO

UPDATE dbo.ProfitabilityReforecast
SET BudgetId = 
	REPLACE(
		SUBSTRING(ReferenceCode, 
		PATINDEX('%:BudgetId=%', ReferenceCode),
		(
			PATINDEX('%&Period=%',ReferenceCode) 
		--min intial point
		 - PATINDEX('%:BudgetId=%', ReferenceCode)
		 )
	)
	,':BudgetId=',''),
	SourceSystemId = 1
FROM dbo.ProfitabilityReforecast where ReferenceCode like 'BC:%' 
GO

UPDATE dbo.ProfitabilityReforecast
SET BudgetId = 
	REPLACE(
		SUBSTRING(ReferenceCode, 
		PATINDEX('%:BudgetId=%', ReferenceCode),
		(
			PATINDEX('%&ProjectId=%',ReferenceCode) 
		--min intial point
		 - PATINDEX('%:BudgetId=%', ReferenceCode)
		 )
	)
	,':BudgetId=',''),
	SourceSystemId = 2
FROM dbo.ProfitabilityReforecast where ReferenceCode like 'TGB:%' 
GO

ALTER TABLE dbo.ProfitabilityReforecast ALTER COLUMN BudgetId int NOT NULL
GO

ALTER TABLE dbo.ProfitabilityReforecast ALTER COLUMN SourceSystemId int NOT NULL
GO

ALTER TABLE dbo.ProfitabilityReforecast ADD CONSTRAINT
	FK_ProfitabilityReforecast_SourceSystem FOREIGN KEY
	(
	SourceSystemId
	) REFERENCES dbo.SourceSystem
	(
	SourceSystemId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
GO

CREATE NONCLUSTERED INDEX IX_ProfitabilityReforecast_SourceSystem ON dbo.ProfitabilityReforecast (BudgetId, SourceSystemId)
GO