USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GlobalReportingCorporateBudget_ImportDate]') AND type = 'D')
BEGIN
	ALTER TABLE [BudgetingCorp].[GlobalReportingCorporateBudget] DROP CONSTRAINT [DF_GlobalReportingCorporateBudget_ImportDate]
END

GO

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BudgetingCorp].[GlobalReportingCorporateBudget]') AND type in (N'U'))
BEGIN
	DROP TABLE [BudgetingCorp].[GlobalReportingCorporateBudget]
END

GO

USE [GrReportingStaging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [BudgetingCorp].[GlobalReportingCorporateBudget](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[SourceUniqueKey] [varchar](370) NOT NULL,
	[BudgetId] [int] NOT NULL,
	[SourceCode] [varchar](2) NOT NULL,
	[BudgetYear] [int] NOT NULL,
	[BudgetPeriodCode] [varchar](2) NOT NULL,
	[LockedDate] [datetime] NULL,
	[Period] [int] NOT NULL,
	[InternationalCurrencyCode] [varchar](3) NOT NULL,
	[LocalAmount] [decimal](38, 11) NULL,
	[GlobalGlAccountCode] [bigint] NOT NULL,
	[FunctionalDepartment] [varchar](50) NOT NULL,
	[FunctionalDepartmentGlobalCode] [varchar](3) NULL,
	[OriginatingSubRegion] [varchar](50) NOT NULL,
	[OriginatingSubRegionCode] [varchar](3) NULL,
	[OriginatingRegion] [varchar](50) NOT NULL,
	[OriginatingRegionCode] [varchar](4) NOT NULL,
	[NonPayrollCorporateMRIDepartmentCode] [varchar](10) NULL,
	[AllocationSubRegion] [varchar](50) NOT NULL,
	[AllocationSubRegionProjectRegionId] [varchar](50) NOT NULL,
	[AllocationRegion] [varchar](50) NOT NULL,
	[AllocationRegionGlobalRegionId] [varchar](50) NOT NULL,
	[IsReimbursable] [int] NOT NULL,
	[JobCode] [varchar](20) NULL,
	[IsExpense] [bit] NULL,
 CONSTRAINT [PK_GlobalReportingCorporateBudget] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [BudgetingCorp].[GlobalReportingCorporateBudget] ADD  CONSTRAINT [DF_GlobalReportingCorporateBudget_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO
