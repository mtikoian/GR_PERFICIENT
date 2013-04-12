/*

1. Tables that need to be created:

	1.1 GrReportingStaging.dbo.BudgetsToProcess - remember to include description object as part of scripting of constraints

	1.2 GrReportingStaging.GBS.BudgetCategory
	1.3 GrReportingStaging.GBS.BudgetPeriod
	1.4 GrReportingStaging.GBS.BudgetProfitabilityActual
	1.5 GrReportingStaging.GBS.OverheadType

	1.6 GrReportingStaging.dbo.ProfitabilityReforecastUnknowns

2. Tables that need to be updated:

	2.1 GrReportingStaging.GBS.NonPayrollExpense -> Add: DispositionNonPayrollExpenseId INT NULL
												 -> Add: IsDispositionCost BIT NULL

	2.2 GrReportingStaging.GBS.NonPayrollExpenseBreakdown -> Add: DispositionNonPayrollExpenseId INT NULL
														  -> Add: IsDispositionCost BIT NULL

	2.3 GrReportingStaging.GBS.NonPayrollExpenseDispute -> Add: ResolvedDate DATETIME NULL

*/
------------------------------------------------------------------------------------------------------------------------------------------

--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||--
--														1. Tables that need to be created
--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||--

-- 1.1 -- dbo.BudgetsToProcess -------------------------------------------------------------------------------------------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK_BudgetsToProcess_IsReforecast]') AND parent_object_id = OBJECT_ID(N'[dbo].[BudgetsToProcess]'))
ALTER TABLE [dbo].[BudgetsToProcess] DROP CONSTRAINT [CK_BudgetsToProcess_IsReforecast]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK_BudgetsToProcess_ReasonForFailure]') AND parent_object_id = OBJECT_ID(N'[dbo].[BudgetsToProcess]'))
ALTER TABLE [dbo].[BudgetsToProcess] DROP CONSTRAINT [CK_BudgetsToProcess_ReasonForFailure]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_BudgetsToProcess_InsertedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BudgetsToProcess] DROP CONSTRAINT [DF_BudgetsToProcess_InsertedDate]
END

GO

USE [GrReportingStaging]
GO

/****** Object:  Table [dbo].[BudgetsToProcess]    Script Date: 05/02/2011 08:21:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BudgetsToProcess]') AND type in (N'U'))
DROP TABLE [dbo].[BudgetsToProcess]
GO

USE [GrReportingStaging]
GO

/****** Object:  Table [dbo].[BudgetsToProcess]    Script Date: 05/02/2011 08:21:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[BudgetsToProcess](
	[BudgetsToProcessId] [int] IDENTITY(1,1) NOT NULL,
	[BatchId] [int] NOT NULL,
	[ImportBatchId] [int] NULL,
	[BudgetReforecastTypeName] [varchar](50) NOT NULL,
	[BudgetId] [int] NOT NULL,
	[BudgetExchangeRateId] [int] NOT NULL,
	[BudgetReportGroupPeriodId] [int] NOT NULL,
	[ImportBudgetFromSourceSystem] [bit] NOT NULL,
	[IsReforecast] [bit] NOT NULL,
	[BudgetYear] [int] NULL,
	[BudgetQuarter] [char](2) NULL,
	[SnapshotId] [int] NOT NULL,
	[ImportSnapshotFromSourceSystem] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[MustImportAllActualsIntoWarehouse] [bit] NULL,
	[OriginalBudgetProcessedIntoWarehouse] [smallint] NULL,
	[ReforecastActualsProcessedIntoWarehouse] [smallint] NULL,
	[ReforecastBudgetsProcessedIntoWarehouse] [smallint] NULL,
	[ReasonForFailure] [varchar](1024) NULL,
	[DateBudgetProcessedIntoWarehouse] [datetime] NULL,
	[BudgetSourceSystemSyncd] [bit] NULL,
 CONSTRAINT [PK_BudgetsToProcess] PRIMARY KEY CLUSTERED 
(
	[BudgetsToProcessId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

/*
ALTER TABLE [dbo].[BudgetsToProcess]  WITH CHECK ADD  CONSTRAINT [CK_BudgetsToProcess_IsReforecast] CHECK  ((case when [IsReforecast]=(0) then case when [MustImportAllActualsIntoWarehouse] IS NULL AND [ReforecastActualsProcessedIntoWarehouse] IS NULL AND [ReforecastBudgetsProcessedIntoWarehouse] IS NULL then (1) else (0) end else case when [OriginalBudgetProcessedIntoWarehouse] IS NULL then (1) else (0) end end=(1)))
GO

ALTER TABLE [dbo].[BudgetsToProcess] CHECK CONSTRAINT [CK_BudgetsToProcess_IsReforecast]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'For reforecasts (when IsReforecast = 0), only MustImportAllActualsIntoWarehouse, ReforecastActualsProcessedIntoWarehouse, ReforecastBudgetsProcessedIntoWarehouse may be null. For reforecasts, only OriginalBudgetProcessedIntoWarehouse may be null.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BudgetsToProcess', @level2type=N'CONSTRAINT',@level2name=N'CK_BudgetsToProcess_IsReforecast'
GO


ALTER TABLE [dbo].[BudgetsToProcess]  WITH CHECK ADD  CONSTRAINT [CK_BudgetsToProcess_ReasonForFailure] CHECK  ((case when [ReasonForFailure] IS NULL then case when [IsReforecast]=(1) then case when [ReforecastActualsProcessedIntoWarehouse]=(0) OR [ReforecastBudgetsProcessedIntoWarehouse]=(0) then (0) else (1) end else case when [OriginalBudgetProcessedIntoWarehouse]=(0) then (0) else (1) end end else (1) end=(1)))
GO

ALTER TABLE [dbo].[BudgetsToProcess] CHECK CONSTRAINT [CK_BudgetsToProcess_ReasonForFailure]
GO
*/
ALTER TABLE [dbo].[BudgetsToProcess] ADD  CONSTRAINT [DF_BudgetsToProcess_InsertedDate]  DEFAULT (getdate()) FOR [InsertedDate]
GO

-- 1.2 -- GrReportingStaging.GBS.BudgetCategory --------------------------------------------------------------------------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GBS_BudgetCategory_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [GBS].[BudgetCategory] DROP CONSTRAINT [DF_GBS_BudgetCategory_ImportDate]
END

GO

USE [GrReportingStaging]
GO

/****** Object:  Table [GBS].[BudgetCategory]    Script Date: 05/02/2011 08:22:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GBS].[BudgetCategory]') AND type in (N'U'))
DROP TABLE [GBS].[BudgetCategory]
GO

USE [GrReportingStaging]
GO

/****** Object:  Table [GBS].[BudgetCategory]    Script Date: 05/02/2011 08:22:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING OFF
GO

CREATE TABLE [GBS].[BudgetCategory](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[BudgetCategoryId] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Version] [timestamp] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [GBS].[BudgetCategory] ADD  CONSTRAINT [DF_GBS_BudgetCategory_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

-- 1.3 -- GrReportingStaging.GBS.BudgetPeriod --------------------------------------------------------------------------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GBS_BudgetPeriod_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [GBS].[BudgetPeriod] DROP CONSTRAINT [DF_GBS_BudgetPeriod_ImportDate]
END

GO

USE [GrReportingStaging]
GO

/****** Object:  Table [GBS].[BudgetPeriod]    Script Date: 05/02/2011 08:24:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GBS].[BudgetPeriod]') AND type in (N'U'))
DROP TABLE [GBS].[BudgetPeriod]
GO

USE [GrReportingStaging]
GO

/****** Object:  Table [GBS].[BudgetPeriod]    Script Date: 05/02/2011 08:24:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [GBS].[BudgetPeriod](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[BudgetPeriodId] [int] NOT NULL,
	[BudgetId] [int] NOT NULL,
	[Period] [int] NOT NULL,
	[IsNonPayrollFirstProjectedPeriod] [bit] NOT NULL,
	[IsPayrollFirstProjectedPeriod] [bit] NOT NULL,
	[IsFeeFirstProjectedPeriod] [bit] NOT NULL,
	[IsNonPayrollActual] [bit] NOT NULL,
	[IsPayrollActual] [bit] NOT NULL,
	[IsFeeActual] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL
) ON [PRIMARY]

GO

ALTER TABLE [GBS].[BudgetPeriod] ADD  CONSTRAINT [DF_GBS_BudgetPeriod_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

-- 1.4 -- GrReportingStaging.GBS.BudgetProfitabilityActual -------------------------------------------------------------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GBS_BudgetProfitabilityActual_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [GBS].[BudgetProfitabilityActual] DROP CONSTRAINT [DF_GBS_BudgetProfitabilityActual_ImportDate]
END

GO

USE [GrReportingStaging]
GO

/****** Object:  Table [GBS].[BudgetProfitabilityActual]    Script Date: 05/02/2011 08:24:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GBS].[BudgetProfitabilityActual]') AND type in (N'U'))
DROP TABLE [GBS].[BudgetProfitabilityActual]
GO

USE [GrReportingStaging]
GO

/****** Object:  Table [GBS].[BudgetProfitabilityActual]    Script Date: 05/02/2011 08:24:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING OFF
GO

CREATE TABLE [GBS].[BudgetProfitabilityActual](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[BudgetProfitabilityActualId] [int] NOT NULL,
	[BudgetId] [int] NOT NULL,
	[BudgetCategoryId] [int] NOT NULL,
	[Period] [int] NOT NULL,
	[GLGlobalAccountId] [int] NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[FunctionalDepartmentId] [int] NOT NULL,
	[CorporateJobCode] [varchar](20) NULL,
	[IsTsCost] [bit] NOT NULL,
	[ActivityTypeId] [int] NOT NULL,
	[ReportingEntityPropertyFundId] [int] NOT NULL,
	[OriginatingSubRegionGlobalRegionId] [int] NOT NULL,
	[AllocationSubRegionGlobalRegionId] [int] NOT NULL,
	[OverheadTypeId] [int] NULL,
	[CurrencyCode] [char](3) NOT NULL,
	[Amount] [money] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[Version] [timestamp] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[IsGBS] [bit] NOT NULL,
	[CorporateDepartmentCode] [char](12) NULL	
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [GBS].[BudgetProfitabilityActual] ADD  CONSTRAINT [DF_GBS_BudgetProfitabilityActual_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

-- 1.5 -- GrReportingStaging.GBS.OverheadType --------------------------------------------------------------------------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GBS_OverheadType_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [GBS].[OverheadType] DROP CONSTRAINT [DF_GBS_OverheadType_ImportDate]
END

GO

USE [GrReportingStaging]
GO

/****** Object:  Table [GBS].[OverheadType]    Script Date: 05/02/2011 08:24:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GBS].[OverheadType]') AND type in (N'U'))
DROP TABLE [GBS].[OverheadType]
GO

USE [GrReportingStaging]
GO

/****** Object:  Table [GBS].[OverheadType]    Script Date: 05/02/2011 08:24:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [GBS].[OverheadType](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[OverheadTypeId] [int] NOT NULL,
	[Code] [varchar](20) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_OverheadType_1] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [GBS].[OverheadType] ADD  CONSTRAINT [DF_GBS_OverheadType_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

-- 1.6 -- GrReportingStaging.dbo.ProfitabilityReforecastUnknowns ---------------------------------------------------------------------------------

USE [GrReportingStaging]
GO

/****** Object:  Table [dbo].[ProfitabilityReforecastUnknowns]    Script Date: 05/02/2011 09:14:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecastUnknowns]') AND type in (N'U'))
DROP TABLE [dbo].[ProfitabilityReforecastUnknowns]
GO

USE [GrReportingStaging]
GO

/****** Object:  Table [dbo].[ProfitabilityReforecastUnknowns]    Script Date: 05/02/2011 09:14:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING OFF
GO

CREATE TABLE [dbo].[ProfitabilityReforecastUnknowns](
	[ProfitabilityReforecastUnknownsKey] [bigint] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[CalendarKey] [int] NOT NULL,
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
	[BudgetId] [int] NOT NULL,
	[SourceSystemId] [int] NULL,
	[OverheadKey] [int] NOT NULL,
	[FeeAdjustmentKey] [int] NOT NULL,
	[BudgetReforecastTypeKey] [int] NOT NULL,
	[SnapshotId] [int] NOT NULL,
 CONSTRAINT [PK_ProfitabilityReforecastUnknowns] PRIMARY KEY NONCLUSTERED 
(
	[ProfitabilityReforecastUnknownsKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


IF NOT EXISTS 
(
	SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
	WHERE 
		COLUMN_NAME = 'SourceSystemId' AND 
		TABLE_NAME = 'ProfitabilityReforecastUnknowns' AND
		IS_NULLABLE = 'YES'
		
)
BEGIN
	ALTER TABLE ProfitabilityReforecastUnknowns ALTER COLUMN SourceSystemId [int] NULL	
	PRINT 'ProfitabilityReforecastUnknowns.SourceSystemId was NOT NULLABLE, changed to NULLABLE'
END


SET ANSI_PADDING OFF
GO

--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||--
--														2. Tables that need to be updated
--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||--

-- 2.1 -- GBS.NonPayrollExpense.DispositionNonPayrollExpenseId

USE GrReportingStaging
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'GBS' AND TABLE_NAME = 'NonPayrollExpense' AND COLUMN_NAME = 'DispositionNonPayrollExpenseId')
BEGIN
	ALTER TABLE
		GBS.NonPayrollExpense
	ADD
		DispositionNonPayrollExpenseId INT NULL -- NULL because we have legacy data that has already been loaded into this table
		
	PRINT ('Column GBS.NonPayrollExpense.DispositionNonPayrollExpenseId added.')
END
ELSE
BEGIN
	PRINT ('Cannot add column GBS.NonPayrollExpense.DispositionNonPayrollExpenseId as it already exists.')
END

GO
--------------------------------------------------------------------------------------------------------------------------------------

-- 2.1 -- GBS.NonPayrollExpense.IsDispositionCost

USE GrReportingStaging
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'GBS' AND TABLE_NAME = 'NonPayrollExpense' AND COLUMN_NAME = 'IsDispositionCost')
BEGIN
	ALTER TABLE
		GBS.NonPayrollExpense
	ADD
		IsDispositionCost BIT NULL -- NULL because we have legacy data that has already been loaded into this table
		
	PRINT ('Column GBS.NonPayrollExpense.IsDispositionCost added.')
END
ELSE
BEGIN
	PRINT ('Cannot add column GBS.NonPayrollExpense.IsDispositionCost as it already exists.')
END

GO
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

-- 2.2 -- GBS.NonPayrollExpenseBreakdown.DispositionNonPayrollExpenseId

USE GrReportingStaging
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'GBS' AND TABLE_NAME = 'NonPayrollExpenseBreakdown' AND COLUMN_NAME = 'DispositionNonPayrollExpenseId')
BEGIN
	ALTER TABLE
		GBS.NonPayrollExpenseBreakdown
	ADD
		DispositionNonPayrollExpenseId INT NULL -- NULL because we have legacy data that has already been loaded into this table
		
	PRINT ('Column GBS.NonPayrollExpenseBreakdown.DispositionNonPayrollExpenseId added.')
END
ELSE
BEGIN
	PRINT ('Cannot add column GBS.NonPayrollExpenseBreakdown.DispositionNonPayrollExpenseId as it already exists.')
END

GO
--------------------------------------------------------------------------------------------------------------------------------------

-- 2.2 -- GBS.NonPayrollExpenseBreakdown.IsDispositionCost

USE GrReportingStaging
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'GBS' AND TABLE_NAME = 'NonPayrollExpenseBreakdown' AND COLUMN_NAME = 'IsDispositionCost')
BEGIN
	ALTER TABLE
		GBS.NonPayrollExpenseBreakdown
	ADD
		IsDispositionCost BIT NULL -- NULL because we have legacy data that has already been loaded into this table
		
	PRINT ('Column GBS.NonPayrollExpenseBreakdown.IsDispositionCost added.')
END
ELSE
BEGIN
	PRINT ('Cannot add column GBS.NonPayrollExpenseBreakdown.IsDispositionCost as it already exists.')
END

GO

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

-- 2.3 -- GBS.NonPayrollExpenseDispute.ResolvedDate

USE GrReportingStaging
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'GBS' AND TABLE_NAME = 'NonPayrollExpenseDispute' AND COLUMN_NAME = 'ResolvedDate')
BEGIN
	ALTER TABLE
		GBS.NonPayrollExpenseDispute
	ADD
		ResolvedDate BIT DATETIME -- NULL because we have legacy data that has already been loaded into this table
		
	PRINT ('Column GBS.NonPayrollExpenseDispute.ResolvedDate added.')
END
ELSE
BEGIN
	PRINT ('Cannot add column GBS.NonPayrollExpenseDispute.ResolvedDate as it already exists.')
END

GO

-- 2.5 -- GrReportingStaging.dbo.BudgetProfitibilityUnknowns.SnapshotId

USE GrReportingStaging
GO

IF NOT EXISTS 
(
	SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
	WHERE 
		COLUMN_NAME = 'SnapshotId' AND 
		TABLE_NAME = 'ProfitabilityBudgetUnknowns'
)
BEGIN
	ALTER TABLE ProfitabilityBudgetUnknowns ADD SnapshotId [int] NULL
	
	PRINT 'Added Column SnapshotId to ProfitabilityBudgetUnknowns'
END
GO

USE GrReportingStaging
GO

UPDATE ProfitabilityBudgetUnknowns SET
	SnapshotId = 1
WHERE
	SnapshotId IS NULL

PRINT (LTRIM(RTRIM(STR(@@rowcount))) + ' records in dbo.ProfitabilityBudgetUnknowns updated for SnapshotId IS NULL')

GO

USE GrReportingStaging
GO

IF EXISTS 
(
	SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
	WHERE 
		COLUMN_NAME = 'SnapshotId' AND 
		TABLE_NAME = 'ProfitabilityBudgetUnknowns' AND
		IS_NULLABLE = 'YES'
)
BEGIN
	ALTER TABLE
		dbo.ProfitabilityBudgetUnknowns
	ALTER COLUMN
		SnapshotId INT NOT NULL

	PRINT 'SnapshotId was NULLABLE, Updated to NOT NULL'
END

GO

--------------------------------------------------------------------------------------------------------------------------------------

-- 2.6 -- GrReportingStaging.dbo.BudgetProfitibilityUnknowns.SourceSystemId

USE GrReportingStaging
GO

IF NOT EXISTS 
(
	SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
	WHERE 
		COLUMN_NAME = 'SourceSystemId' AND 
		TABLE_NAME = 'ProfitabilityBudgetUnknowns' AND
		IS_NULLABLE = 'YES'
		
)
BEGIN
	ALTER TABLE ProfitabilityBudgetUnknowns ALTER COLUMN SourceSystemId [int] NULL	
	PRINT 'ProfitabilityBudgetUnknowns.SourceSystemId was NOT NULLABLE, changed to NULLABLE'
END

GO


