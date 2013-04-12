USE [GrReporting]
GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TimeAllocationActual_LocalCurrencyKey]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TimeAllocationActual] DROP CONSTRAINT [DF_TimeAllocationActual_LocalCurrencyKey]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TimeAllocationActual_InsertedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TimeAllocationActual] DROP CONSTRAINT [DF_TimeAllocationActual_InsertedDate]
END

GO

USE [GrReporting]
GO

/****** Object:  Table [dbo].[TimeAllocationActual]    Script Date: 07/16/2012 23:21:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TimeAllocationActual]') AND type in (N'U'))
DROP TABLE [dbo].[TimeAllocationActual]
GO

USE [GrReporting]
GO

/****** Object:  Table [dbo].[TimeAllocationActual]    Script Date: 07/16/2012 23:21:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TimeAllocationActual](
	[TimeAllocationActualKey] [bigint] IDENTITY(1,1) NOT NULL,
	[ReferenceCode] [varchar](500) NOT NULL,
	[ProjectKey] [int] NOT NULL,
	[BudgetOwnerStaff] varchar(255) NULL,
	[PropertyFundKey] [int] NOT NULL,
	[AllocationRegionKey] [int] NOT NULL,
	[Local_NonLocal] [varchar](20) NOT NULL,
	[OriginatingRegionKey] [int] NOT NULL,
	[EmployeeKey] [int] NOT NULL,
	[CalendarKey] [int] NOT NULL,
	[ReportingEntityKey] [int] NOT NULL,
	[CorporateDepartmentCode] [varchar](8) NULL,
	[FunctionalDepartmentKey] [int] NOT NULL,
	[SourceSystemId] [int] NOT NULL,
	[SourceKey] [int] NOT NULL,
	[ReimbursableKey] [int] NOT NULL,
	[ActivityTypeKey] [int] NOT NULL,
	[ProjectGroupKey] [int] NOT NULL,
	[UserId] [int] NULL,
	[ActualAllocatedFTE] [numeric](18, 12) NULL,
	[BilledAmount] [money] NOT NULL,
	[BilledFTE] [numeric](18, 12) NOT NULL,
	[AdjustmentsAmount] [money] NOT NULL,
	[AdjustmentsFTE] [numeric](18, 12) NOT NULL,
	[LocalCurrencyKey] [int] NOT NULL,
	[ConsolidationRegionKey] [int] NOT NULL,

	[InsertedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
	[ApprovedByStaff] varchar(255) NULL,
 CONSTRAINT [PK_TimeAllocationActual] PRIMARY KEY CLUSTERED 
(
	[TimeAllocationActualKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



ALTER TABLE [dbo].[TimeAllocationActual] ADD  CONSTRAINT [DF_TimeAllocationActual_LocalCurrencyKey]  DEFAULT ((-1)) FOR [LocalCurrencyKey]
GO


ALTER TABLE [dbo].[TimeAllocationActual] ADD  CONSTRAINT [DF_TimeAllocationActual_InsertedDate]  DEFAULT (getdate()) FOR [InsertedDate]
GO


