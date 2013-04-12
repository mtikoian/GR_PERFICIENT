USE [GrReporting]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

--Create tables

/****** Object:  Table [dbo].[ActivityType]    Script Date: 12/18/2009 16:12:33 ******/
CREATE TABLE [dbo].[ActivityType](
	[ActivityTypeKey] [int] IDENTITY(1,1) NOT NULL,
	[ActivityTypeId] [int] NOT NULL,
	[ActivityTypeCode] [varchar](50) NOT NULL,
	[ActivityTypeName] [varchar](50) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Activity] PRIMARY KEY CLUSTERED 
(
	[ActivityTypeKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[AllocationRegion]    Script Date: 12/18/2009 16:12:33 ******/
CREATE TABLE [dbo].[AllocationRegion](
	[AllocationRegionKey] [int] IDENTITY(1,1) NOT NULL,
	[GlobalRegionId] [int] NOT NULL,
	[RegionCode] [varchar](50) NOT NULL,
	[RegionName] [varchar](50) NOT NULL,
	[SubRegionCode] [varchar](10) NOT NULL,
	[SubRegionName] [varchar](50) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
 CONSTRAINT [PK_AllocationRegion] PRIMARY KEY CLUSTERED 
(
	[AllocationRegionKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[Calendar]    Script Date: 12/18/2009 16:12:33 ******/
CREATE TABLE [dbo].[Calendar](
	[CalendarKey] [int] NOT NULL,
	[CalendarDate] [date] NOT NULL,
	[CalendarYear] [smallint] NOT NULL,
	[CalendarQuarter] [tinyint] NOT NULL,
	[CalendarMonth] [tinyint] NOT NULL,
	[CalendarMonthName] [varchar](10) NOT NULL,
	[CalendarPeriod] [int] NOT NULL,
	[FinancialPeriod] [int] NOT NULL,
 CONSTRAINT [PK_Calendar] PRIMARY KEY CLUSTERED 
(
	[CalendarKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[Currency]    Script Date: 12/18/2009 16:12:33 ******/
CREATE TABLE [dbo].[Currency](
	[CurrencyKey] [int] IDENTITY(1,1) NOT NULL,
	[CurrencyCode] [char](3) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Currency] PRIMARY KEY CLUSTERED 
(
	[CurrencyKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[ExchangeRate]    Script Date: 12/18/2009 16:12:33 ******/
CREATE TABLE [dbo].[ExchangeRate](
	[SourceCurrencyKey] [int] NOT NULL,
	[DestinationCurrencyKey] [int] NOT NULL,
	[CalendarKey] [int] NOT NULL,
	[Rate] [decimal](18, 12) NOT NULL,
	[ReferenceCode] [varchar](255) NOT NULL
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[FunctionalDepartment]    Script Date: 12/18/2009 16:12:33 ******/
CREATE TABLE [dbo].[FunctionalDepartment](
	[FunctionalDepartmentKey] [int] IDENTITY(1,1) NOT NULL,
	[ReferenceCode] [varchar](20) NOT NULL,
	[FunctionalDepartmentCode] [varchar](20) NOT NULL,
	[FunctionalDepartmentName] [varchar](100) NOT NULL,
	[SubFunctionalDepartmentCode] [varchar](20) NOT NULL,
	[SubFunctionalDepartmentName] [varchar](100) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
 CONSTRAINT [PK_FunctionalDepartment] PRIMARY KEY CLUSTERED 
(
	[FunctionalDepartmentKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[GlAccount]    Script Date: 12/18/2009 16:12:33 ******/
CREATE TABLE [dbo].[GlAccount](
	[GlAccountKey] [int] IDENTITY(1,1) NOT NULL,
	[GlobalGlAccountId] [int] NOT NULL,
	[GlAccountCode] [char](12) NOT NULL,
	[GlAccountName] [nvarchar](250) NOT NULL,
	[AccountType] [varchar](50) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
 CONSTRAINT [PK_GlAccount] PRIMARY KEY CLUSTERED 
(
	[GlAccountKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[GlAccountCategory]    Script Date: 12/18/2009 16:12:33 ******/
CREATE TABLE [dbo].[GlAccountCategory](
	[GlAccountCategoryKey] [int] IDENTITY(1,1) NOT NULL,
	[GlobalGlAccountCategoryCode] [varchar](32) NOT NULL,
	[HierarchyName] [varchar](50) NOT NULL,
	[FeeOrExpense] [varchar](10) NOT NULL,
	[FeeOrExpenseMultiplicationFactor]  AS (case when [FeeOrExpense]='INCOME' then (1) else (-1) end),
	[MajorName] [varchar](100) NOT NULL,
	[MinorName] [varchar](100) NOT NULL,
	[ExpenseType] [varchar](50) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
 CONSTRAINT [PK_TypeHierarchy] PRIMARY KEY CLUSTERED 
(
	[GlAccountCategoryKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[OriginatingRegion]    Script Date: 12/18/2009 16:12:33 ******/
CREATE TABLE [dbo].[OriginatingRegion](
	[OriginatingRegionKey] [int] IDENTITY(1,1) NOT NULL,
	[GlobalRegionId] [int] NOT NULL,
	[RegionName] [varchar](50) NOT NULL,
	[RegionCode] [varchar](10) NOT NULL,
	[SubRegionCode] [varchar](10) NOT NULL,
	[SubRegionName] [varchar](50) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
 CONSTRAINT [PK_OriginatingRegion] PRIMARY KEY CLUSTERED 
(
	[OriginatingRegionKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[ProfitabilityActual]    Script Date: 12/18/2009 16:12:33 ******/
CREATE TABLE [dbo].[ProfitabilityActual](
	[ProfitabilityActualKey] [bigint] IDENTITY(1,1) NOT NULL,
	[CalendarKey] [int] NOT NULL,
	[GlAccountKey] [int] NOT NULL,
	[SourceKey] [int] NOT NULL,
	[FunctionalDepartmentKey] [int] NOT NULL,
	[ReimbursableKey] [int] NOT NULL,
	[ActivityTypeKey] [int] NOT NULL,
	[PropertyFundKey] [int] NOT NULL,
	[OriginatingRegionKey] [int] NOT NULL,
	[AllocationRegionKey] [int] NOT NULL,
	[LocalCurrencyKey] [int] NOT NULL,
	[LocalActual] [money] NOT NULL,
	[ReferenceCode] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ProfitabilityActual] PRIMARY KEY NONCLUSTERED 
(
	[ProfitabilityActualKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[ProfitabilityActualGlAccountCategoryBridge]    Script Date: 12/18/2009 16:12:33 ******/
CREATE TABLE [dbo].[ProfitabilityActualGlAccountCategoryBridge](
	[ProfitabilityActualKey] [bigint] NOT NULL,
	[GlAccountCategoryKey] [int] NOT NULL,
 CONSTRAINT [PK_ProfitabilityActualGlAccountCategoryBridge] PRIMARY KEY CLUSTERED 
(
	[ProfitabilityActualKey] ASC,
	[GlAccountCategoryKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[ProfitabilityBudget]    Script Date: 12/18/2009 16:12:33 ******/
CREATE TABLE [dbo].[ProfitabilityBudget](
	[ProfitabilityBudgetKey] [bigint] IDENTITY(1,1) NOT NULL,
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
	[LocalBudget] [money] NOT NULL,
	[ReferenceCode] [varchar](300) NOT NULL,
 CONSTRAINT [PK_ProfitabilityBudget] PRIMARY KEY NONCLUSTERED 
(
	[ProfitabilityBudgetKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[ProfitabilityBudgetGlAccountCategoryBridge]    Script Date: 12/18/2009 16:12:33 ******/
CREATE TABLE [dbo].[ProfitabilityBudgetGlAccountCategoryBridge](
	[ProfitabilityBudgetKey] [bigint] NOT NULL,
	[GlAccountCategoryKey] [int] NOT NULL,
 CONSTRAINT [PK_ProfitabilityBudgetGlAccountCategoryBridge] PRIMARY KEY CLUSTERED 
(
	[ProfitabilityBudgetKey] ASC,
	[GlAccountCategoryKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[PropertyFund]    Script Date: 12/18/2009 16:12:33 ******/
CREATE TABLE [dbo].[PropertyFund](
	[PropertyFundKey] [int] IDENTITY(1,1) NOT NULL,
	[PropertyFundId] [int] NOT NULL,
	[PropertyFundName] [varchar](100) NOT NULL,
	[PropertyFundType] [varchar](50) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
 CONSTRAINT [PK_PropertyFund] PRIMARY KEY CLUSTERED 
(
	[PropertyFundKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[Reforecast]    Script Date: 12/18/2009 16:12:33 ******/
CREATE TABLE [dbo].[Reforecast](
	[ReforecastKey] [int] NOT NULL,
	[ReforecastEffectiveMonth] [tinyint] NOT NULL,
	[ReforecastEffectiveQuarter] [tinyint] NOT NULL,
	[ReforecastEffectiveYear] [smallint] NOT NULL,
	[ReforecastMonthName] [varchar](10) NOT NULL,
	[ReforecastQuarterName] [varchar](10) NOT NULL,
	[ReforecastEffectivePeriod] [int] NOT NULL,
 CONSTRAINT [PK_Reforecast] PRIMARY KEY CLUSTERED 
(
	[ReforecastKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[Reimbursable]    Script Date: 12/18/2009 16:12:33 ******/
CREATE TABLE [dbo].[Reimbursable](
	[ReimbursableKey] [int] NOT NULL,
	[ReimbursableCode] [varchar](10) NOT NULL,
	[ReimbursableName] [varchar](50) NOT NULL,
	[MultiplicationFactor] [decimal](18, 12) NULL,
 CONSTRAINT [PK_Reimbursable] PRIMARY KEY CLUSTERED 
(
	[ReimbursableKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[Source]    Script Date: 12/18/2009 16:12:33 ******/
CREATE TABLE [dbo].[Source](
	[SourceKey] [int] IDENTITY(1,1) NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[SourceSystem] [varchar](50) NOT NULL,
	[SourceName] [varchar](50) NOT NULL,
	[IsCorporate] [varchar](3) NOT NULL,
	[IsProperty] [varchar](3) NOT NULL,
 CONSTRAINT [PK_Source] PRIMARY KEY CLUSTERED 
(
	[SourceKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

-- Add constraints

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[ExchangeRate]  WITH CHECK ADD  CONSTRAINT [FK_ExchangeRate_Calendar] FOREIGN KEY([CalendarKey])
REFERENCES [dbo].[Calendar] ([CalendarKey])
GO

ALTER TABLE [dbo].[ExchangeRate] CHECK CONSTRAINT [FK_ExchangeRate_Calendar]
GO

ALTER TABLE [dbo].[ExchangeRate]  WITH CHECK ADD  CONSTRAINT [FK_ExchangeRate_DestinationCurrency] FOREIGN KEY([DestinationCurrencyKey])
REFERENCES [dbo].[Currency] ([CurrencyKey])
GO

ALTER TABLE [dbo].[ExchangeRate] CHECK CONSTRAINT [FK_ExchangeRate_DestinationCurrency]
GO

ALTER TABLE [dbo].[ExchangeRate]  WITH CHECK ADD  CONSTRAINT [FK_ExchangeRate_SourceCurrency] FOREIGN KEY([SourceCurrencyKey])
REFERENCES [dbo].[Currency] ([CurrencyKey])
GO

ALTER TABLE [dbo].[ExchangeRate] CHECK CONSTRAINT [FK_ExchangeRate_SourceCurrency]
GO

ALTER TABLE [dbo].[GlAccount] ADD  CONSTRAINT [DF_GlAccount_AccountType]  DEFAULT ('') FOR [AccountType]
GO

ALTER TABLE [dbo].[GlAccountCategory] ADD  CONSTRAINT [DF_TypeHierarchy_AccountSubCategory]  DEFAULT ('') FOR [MinorName]
GO

ALTER TABLE [dbo].[OriginatingRegion] ADD  CONSTRAINT [DF_OriginatingRegion_SubRegionCode]  DEFAULT ('UNKNOWN') FOR [SubRegionCode]
GO

ALTER TABLE [dbo].[OriginatingRegion] ADD  CONSTRAINT [DF_OriginatingRegion_SubRegionName]  DEFAULT ('UNKNOWN') FOR [SubRegionName]
GO

ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_ActivityType] FOREIGN KEY([ActivityTypeKey])
REFERENCES [dbo].[ActivityType] ([ActivityTypeKey])
GO

ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_ActivityType]
GO

ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_AllocationRegion] FOREIGN KEY([AllocationRegionKey])
REFERENCES [dbo].[AllocationRegion] ([AllocationRegionKey])
GO

ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_AllocationRegion]
GO

ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_Calendar] FOREIGN KEY([CalendarKey])
REFERENCES [dbo].[Calendar] ([CalendarKey])
GO

ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_Calendar]
GO

ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_Currency] FOREIGN KEY([LocalCurrencyKey])
REFERENCES [dbo].[Currency] ([CurrencyKey])
GO

ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_Currency]
GO

ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_FunctionalDepartment] FOREIGN KEY([FunctionalDepartmentKey])
REFERENCES [dbo].[FunctionalDepartment] ([FunctionalDepartmentKey])
GO

ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_FunctionalDepartment]
GO

ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_GlAccount] FOREIGN KEY([GlAccountKey])
REFERENCES [dbo].[GlAccount] ([GlAccountKey])
GO

ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_GlAccount]
GO

ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_OriginatingRegion] FOREIGN KEY([OriginatingRegionKey])
REFERENCES [dbo].[OriginatingRegion] ([OriginatingRegionKey])
GO

ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_OriginatingRegion]
GO

ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_PropertyFund] FOREIGN KEY([PropertyFundKey])
REFERENCES [dbo].[PropertyFund] ([PropertyFundKey])
GO

ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_PropertyFund]
GO

ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_Reimbursable] FOREIGN KEY([ReimbursableKey])
REFERENCES [dbo].[Reimbursable] ([ReimbursableKey])
GO

ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_Reimbursable]
GO

ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_Source] FOREIGN KEY([SourceKey])
REFERENCES [dbo].[Source] ([SourceKey])
GO

ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_Source]
GO

ALTER TABLE [dbo].[ProfitabilityActualGlAccountCategoryBridge]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualGlAccountCategoryBridge_GlAccountCategory] FOREIGN KEY([GlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityActualGlAccountCategoryBridge] CHECK CONSTRAINT [FK_ProfitabilityActualGlAccountCategoryBridge_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityActualGlAccountCategoryBridge]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualGlAccountCategoryBridge_ProfitabilityActual] FOREIGN KEY([ProfitabilityActualKey])
REFERENCES [dbo].[ProfitabilityActual] ([ProfitabilityActualKey])
GO

ALTER TABLE [dbo].[ProfitabilityActualGlAccountCategoryBridge] CHECK CONSTRAINT [FK_ProfitabilityActualGlAccountCategoryBridge_ProfitabilityActual]
GO

ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_Activity] FOREIGN KEY([ActivityTypeKey])
REFERENCES [dbo].[ActivityType] ([ActivityTypeKey])
GO

ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_Activity]
GO

ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_AllocationRegion] FOREIGN KEY([AllocationRegionKey])
REFERENCES [dbo].[AllocationRegion] ([AllocationRegionKey])
GO

ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_AllocationRegion]
GO

ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_Calendar] FOREIGN KEY([CalendarKey])
REFERENCES [dbo].[Calendar] ([CalendarKey])
GO

ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_Calendar]
GO

ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_Currency] FOREIGN KEY([LocalCurrencyKey])
REFERENCES [dbo].[Currency] ([CurrencyKey])
GO

ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_Currency]
GO

ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_FunctionalDepartment] FOREIGN KEY([FunctionalDepartmentKey])
REFERENCES [dbo].[FunctionalDepartment] ([FunctionalDepartmentKey])
GO

ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_FunctionalDepartment]
GO

ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_GlAccount] FOREIGN KEY([GlAccountKey])
REFERENCES [dbo].[GlAccount] ([GlAccountKey])
GO

ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_GlAccount]
GO

ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_OriginatingRegion] FOREIGN KEY([OriginatingRegionKey])
REFERENCES [dbo].[OriginatingRegion] ([OriginatingRegionKey])
GO

ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_OriginatingRegion]
GO

ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_PropertyFund] FOREIGN KEY([PropertyFundKey])
REFERENCES [dbo].[PropertyFund] ([PropertyFundKey])
GO

ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_PropertyFund]
GO

ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_Reforecast] FOREIGN KEY([ReforecastKey])
REFERENCES [dbo].[Reforecast] ([ReforecastKey])
GO

ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_Reforecast]
GO

ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_Reimbursable] FOREIGN KEY([ReimbursableKey])
REFERENCES [dbo].[Reimbursable] ([ReimbursableKey])
GO

ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_Reimbursable]
GO

ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_Source] FOREIGN KEY([SourceKey])
REFERENCES [dbo].[Source] ([SourceKey])
GO

ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_Source]
GO

ALTER TABLE [dbo].[ProfitabilityBudget] ADD  CONSTRAINT [DF_ProfitabilityBudget_LocalCurrencyKey]  DEFAULT ((-1)) FOR [LocalCurrencyKey]
GO

ALTER TABLE [dbo].[ProfitabilityBudgetGlAccountCategoryBridge]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudgetGlAccountCategoryBridge_GlAccountCategory] FOREIGN KEY([GlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityBudgetGlAccountCategoryBridge] CHECK CONSTRAINT [FK_ProfitabilityBudgetGlAccountCategoryBridge_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityBudgetGlAccountCategoryBridge]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudgetGlAccountCategoryBridge_ProfitabilityBudget] FOREIGN KEY([ProfitabilityBudgetKey])
REFERENCES [dbo].[ProfitabilityBudget] ([ProfitabilityBudgetKey])
GO

ALTER TABLE [dbo].[ProfitabilityBudgetGlAccountCategoryBridge] CHECK CONSTRAINT [FK_ProfitabilityBudgetGlAccountCategoryBridge_ProfitabilityBudget]
GO

ALTER TABLE [dbo].[Reimbursable] ADD  CONSTRAINT [DF_Reimbursable_ReimbursableName]  DEFAULT ('') FOR [ReimbursableName]
GO

ALTER TABLE [dbo].[Source] ADD  CONSTRAINT [DF_Source_IsCorporate]  DEFAULT ('NO') FOR [IsCorporate]
GO

ALTER TABLE [dbo].[Source] ADD  CONSTRAINT [DF_Source_IsProperty]  DEFAULT ('NO') FOR [IsProperty]
GO




SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

SET ANSI_PADDING OFF
GO
