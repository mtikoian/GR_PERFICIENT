USE [GrReporting]
GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TimeAllocationBudget_LocalCurrencyKey]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TimeAllocationBudget] DROP CONSTRAINT [DF_TimeAllocationBudget_LocalCurrencyKey]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TimeAllocationBudget_InsertedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TimeAllocationBudget] DROP CONSTRAINT [DF_TimeAllocationBudget_InsertedDate]
END

GO

USE [GrReporting]
GO

/****** Object:  Table [dbo].[TimeAllocationBudget]    Script Date: 07/10/2012 03:53:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TimeAllocationBudget]') AND type in (N'U'))
DROP TABLE [dbo].[TimeAllocationBudget]
GO

USE [GrReporting]
GO

/****** Object:  Table [dbo].[TimeAllocationBudget]    Script Date: 07/10/2012 03:53:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TimeAllocationBudget](
	[TimeAllocationBudgetKey] [bigint] IDENTITY(1,1) NOT NULL,
	[CalendarKey] [int] NOT NULL,
	[ProjectKey] [int] NOT NULL,
	[ProjectGroupKey] [int] NOT NULL,
	[EmployeeKey] [int] NOT NULL,

	[SourceKey] [int] NOT NULL,
	[FunctionalDepartmentKey] [int] NOT NULL,
	[ReimbursableKey] [int] NOT NULL,
	[ActivityTypeKey] [int] NOT NULL,
	[PropertyFundKey] [int] NOT NULL,
	[ReportingEntityKey] [int] NOT NULL,
	[AllocationRegionKey] [int] NOT NULL,
	[OriginatingRegionKey] [int] NOT NULL,
	[LocalCurrencyKey] [int] NOT NULL,
	[LocalBudgetAllocatedAmount] [money] NOT NULL,
	[BudgetAllocatedFTE] [decimal](18, 12) NOT NULL,
	[ReferenceCode] [varchar](500) NOT NULL,
	[Local_NonLocal] [varchar](10) NOT NULL,
	[BudgetId] [int] NOT NULL,
	[SourceSystemKey] [int] NULL,
	[BudgetOwnerStaff] varchar(255) NULL,
	[ApprovedByStaff] varchar(255) NULL,

	[SnapshotId] [int] NOT NULL,
	[BudgetReforecastTypeKey] [int] NOT NULL,
	[ReforecastKey] [int] NOT NULL,
	[ConsolidationRegionKey] [int] NULL,

	[InsertedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
 CONSTRAINT [PK_TimeAllocationBudget] PRIMARY KEY NONCLUSTERED 
(
	[TimeAllocationBudgetKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TimeAllocationBudget] ADD  CONSTRAINT [DF_TimeAllocationBudget_LocalCurrencyKey]  DEFAULT ((-1)) FOR [LocalCurrencyKey]
GO


ALTER TABLE [dbo].[TimeAllocationBudget] ADD  CONSTRAINT [DF_TimeAllocationBudget_InsertedDate]  DEFAULT (getdate()) FOR [InsertedDate]
GO


