
--Add the new GlAccountCategoryKey columns with the FK

--EUCorporateGlAccountCategoryKey
ALTER TABLE dbo.ProfitabilityBudget ADD EUCorporateGlAccountCategoryKey int NULL
GO
ALTER TABLE dbo.ProfitabilityBudget ADD CONSTRAINT
	FKEUCorporateGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory FOREIGN KEY
	(
	EUCorporateGlAccountCategoryKey
	) REFERENCES dbo.GlAccountCategory
	(
	GlAccountCategoryKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
GO


--USPropertyGlAccountCategoryKey
ALTER TABLE dbo.ProfitabilityBudget ADD USPropertyGlAccountCategoryKey int NULL
GO
ALTER TABLE dbo.ProfitabilityBudget ADD CONSTRAINT
	FKUSPropertyGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory FOREIGN KEY
	(
	USPropertyGlAccountCategoryKey
	) REFERENCES dbo.GlAccountCategory
	(
	GlAccountCategoryKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
GO
--USFundGlAccountCategoryKey
ALTER TABLE dbo.ProfitabilityBudget ADD USFundGlAccountCategoryKey int NULL
GO
ALTER TABLE dbo.ProfitabilityBudget ADD CONSTRAINT
	FKUSFundGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory FOREIGN KEY
	(
	USFundGlAccountCategoryKey
	) REFERENCES dbo.GlAccountCategory
	(
	GlAccountCategoryKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
GO
--EUPropertyGlAccountCategoryKey
ALTER TABLE dbo.ProfitabilityBudget ADD EUPropertyGlAccountCategoryKey int NULL
GO
ALTER TABLE dbo.ProfitabilityBudget ADD CONSTRAINT
	FKEUPropertyGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory FOREIGN KEY
	(
	EUPropertyGlAccountCategoryKey
	) REFERENCES dbo.GlAccountCategory
	(
	GlAccountCategoryKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
GO
--USCorporateGlAccountCategoryKey
ALTER TABLE dbo.ProfitabilityBudget ADD USCorporateGlAccountCategoryKey int NULL
GO
ALTER TABLE dbo.ProfitabilityBudget ADD CONSTRAINT
	FKUSCorporateGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory FOREIGN KEY
	(
	USCorporateGlAccountCategoryKey
	) REFERENCES dbo.GlAccountCategory
	(
	GlAccountCategoryKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
GO
--DevelopmentGlAccountCategoryKey
ALTER TABLE dbo.ProfitabilityBudget ADD DevelopmentGlAccountCategoryKey int NULL
GO
ALTER TABLE dbo.ProfitabilityBudget ADD CONSTRAINT
	FKDevelopmentGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory FOREIGN KEY
	(
	DevelopmentGlAccountCategoryKey
	) REFERENCES dbo.GlAccountCategory
	(
	GlAccountCategoryKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
GO
--EUFundGlAccountCategoryKey
ALTER TABLE dbo.ProfitabilityBudget ADD EUFundGlAccountCategoryKey int NULL
GO
ALTER TABLE dbo.ProfitabilityBudget ADD CONSTRAINT
	FKEUFundGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory FOREIGN KEY
	(
	EUFundGlAccountCategoryKey
	) REFERENCES dbo.GlAccountCategory
	(
	GlAccountCategoryKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
GO
--GlobalGlAccountCategoryKey
ALTER TABLE dbo.ProfitabilityBudget ADD GlobalGlAccountCategoryKey int NULL
GO
ALTER TABLE dbo.ProfitabilityBudget ADD CONSTRAINT
	FKGlobalGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory FOREIGN KEY
	(
	GlobalGlAccountCategoryKey
	) REFERENCES dbo.GlAccountCategory
	(
	GlAccountCategoryKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
GO

-- Enlarge reference code
ALTER TABLE dbo.ProfitabilityBudget ALTER Column ReferenceCode Varchar(500) NOT NULL
GO

-- Alter indexes

/****** Object:  Index [IX_ActivityTypeKey]    Script Date: 03/17/2010 10:15:38 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_ActivityTypeKey')
DROP INDEX [IX_ActivityTypeKey] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )
GO

/****** Object:  Index [IX_AllocationRegionKey]    Script Date: 03/17/2010 10:15:38 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_AllocationRegionKey')
DROP INDEX [IX_AllocationRegionKey] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )
GO

/****** Object:  Index [IX_CalendarKey]    Script Date: 03/17/2010 10:15:38 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_CalendarKey')
DROP INDEX [IX_CalendarKey] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )
GO

/****** Object:  Index [IX_Clustered]    Script Date: 03/17/2010 10:15:38 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_Clustered')
DROP INDEX [IX_Clustered] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )
GO

/****** Object:  Index [IX_FunctionalDepartmentKey]    Script Date: 03/17/2010 10:15:38 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_FunctionalDepartmentKey')
DROP INDEX [IX_FunctionalDepartmentKey] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )
GO

/****** Object:  Index [IX_GlAccountKey]    Script Date: 03/17/2010 10:15:38 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_GlAccountKey')
DROP INDEX [IX_GlAccountKey] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )
GO

/****** Object:  Index [IX_OriginatingRegionKey]    Script Date: 03/17/2010 10:15:38 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_OriginatingRegionKey')
DROP INDEX [IX_OriginatingRegionKey] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )
GO

/****** Object:  Index [IX_PropertyFundKey]    Script Date: 03/17/2010 10:15:38 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_PropertyFundKey')
DROP INDEX [IX_PropertyFundKey] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )
GO

/****** Object:  Index [IX_ReferenceCode]    Script Date: 03/17/2010 10:15:38 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_ReferenceCode')
DROP INDEX [IX_ReferenceCode] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )
GO


/****** Object:  Index [IX_ActivityTypeKey]    Script Date: 03/17/2010 10:15:38 ******/
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
[LocalBudget]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_AllocationRegionKey]    Script Date: 03/17/2010 10:15:38 ******/
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
[LocalBudget]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_CalendarKey]    Script Date: 03/17/2010 10:15:38 ******/
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
[ActivityTypeKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_Clustered]    Script Date: 03/17/2010 10:15:38 ******/
CREATE CLUSTERED INDEX [IX_Clustered] ON [dbo].[ProfitabilityBudget] 
(
	[CalendarKey] ASC,
	[LocalCurrencyKey] ASC,
	[FunctionalDepartmentKey] ASC,
	[AllocationRegionKey] ASC,
	[OriginatingRegionKey] ASC,
	[PropertyFundKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_FunctionalDepartmentKey]    Script Date: 03/17/2010 10:15:38 ******/
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
[OriginatingRegionKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_GlAccountKey]    Script Date: 03/17/2010 10:15:38 ******/
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
[LocalBudget]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_OriginatingRegionKey]    Script Date: 03/17/2010 10:15:38 ******/
CREATE NONCLUSTERED INDEX [IX_OriginatingRegionKey] ON [dbo].[ProfitabilityBudget] 
(
	[OriginatingRegionKey] ASC
)
INCLUDE ( [ProfitabilityBudgetKey],
[CalendarKey],
[GlAccountKey],
[SourceKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[ActivityTypeKey],
[PropertyFundKey],
[AllocationRegionKey],
[LocalCurrencyKey],
[LocalBudget]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_PropertyFundKey]    Script Date: 03/17/2010 10:15:38 ******/
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
[LocalCurrencyKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_ReferenceCode]    Script Date: 03/17/2010 10:15:38 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ReferenceCode] ON [dbo].[ProfitabilityBudget] 
(
	[ReferenceCode] ASC
)
INCLUDE ( [ProfitabilityBudgetKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO




--Remove reforecast key
ALTER TABLE dbo.ProfitabilityBudget
	DROP CONSTRAINT FK_ProfitabilityBudget_Reforecast
GO
ALTER TABLE dbo.ProfitabilityBudget
	DROP COLUMN ReforecastKey
GO


-- Create source system table
CREATE TABLE dbo.SourceSystem
	(
	SourceSystemId int NOT NULL,
	[Name] varchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.SourceSystem ADD CONSTRAINT
	PK_SourceSystem PRIMARY KEY CLUSTERED 
	(
	SourceSystemId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.SourceSystem SET (LOCK_ESCALATION = TABLE)
GO

INSERT INTO dbo.SourceSystem (SourceSystemId, [Name]) values (1, 'Corporate Budgeting')
GO

INSERT INTO dbo.SourceSystem (SourceSystemId, [Name]) values (2, 'Tapas Budgeting')
GO

--Add BudgetId and Source System columns
ALTER TABLE dbo.ProfitabilityBudget ADD BudgetId int NULL
GO

ALTER TABLE dbo.ProfitabilityBudget ADD SourceSystemId int NULL
GO

UPDATE dbo.ProfitabilityBudget
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
FROM dbo.ProfitabilityBudget where ReferenceCode like 'BC:%' 
GO

UPDATE dbo.ProfitabilityBudget
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
FROM dbo.ProfitabilityBudget where ReferenceCode like 'TGB:%' 
GO

ALTER TABLE dbo.ProfitabilityBudget ALTER COLUMN BudgetId int NOT NULL
GO

ALTER TABLE dbo.ProfitabilityBudget ALTER COLUMN SourceSystemId int NOT NULL
GO

ALTER TABLE dbo.ProfitabilityBudget ADD CONSTRAINT
	FK_ProfitabilityBudget_SourceSystem FOREIGN KEY
	(
	SourceSystemId
	) REFERENCES dbo.SourceSystem
	(
	SourceSystemId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
GO

CREATE NONCLUSTERED INDEX IX_ProfitabilityBudget_SourceSystem ON dbo.ProfitabilityBudget (BudgetId, SourceSystemId)
GO
