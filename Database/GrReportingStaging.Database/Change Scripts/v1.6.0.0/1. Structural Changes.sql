 /*
 
:: DBO
	dbo.BudgetsToProcess
	dbo.ProfitabilityBudgetUnknowns

:: Gdm.Snapshot
	All

:: GBS
	 GBS.Budget
	 GBS.Fee
	 GBS.FeeDetail
	 GBS.NonPayrollExpense
	 GBS.NonPayrollExpenseBreakdown
	 GBS.NonPayrollExpenseDispute
	 GBS.DisputeStatus
 
 :: TapasGlobalBudgeting
	None - should already exist, buet structural changes are required to TapasGlobalBudgeting.Budget
 
 */

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM SYS.TYPES ST JOIN SYS.SCHEMAS SS ON ST.SCHEMA_ID = SS.SCHEMA_ID WHERE ST.NAME = N'GBSBudgetImportBatchType' AND SS.NAME = N'dbo')
	DROP TYPE [dbo].[GBSBudgetImportBatchType]
GO

CREATE TYPE dbo.GBSBudgetImportBatchType AS TABLE (
	ImportKey INT NOT NULL,
	BudgetId INT NOT NULL,
	ImportBatchId INT NOT NULL
)

GO

USE [GrReportingStaging]
GO

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'TapasGlobalBudgeting' AND TABLE_NAME = 'Budget' AND COLUMN_NAME = 'ImportBudgetIntoGR')
ALTER TABLE [TapasGlobalBudgeting].[Budget] ADD
      [ImportBudgetIntoGR] [bit] NOT NULL CONSTRAINT [DF_TapasGlobalBudgeting_Budget_ImportBudgetIntoGR] DEFAULT ((0))
GO
      
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'TapasGlobalBudgeting' AND TABLE_NAME = 'Budget' AND COLUMN_NAME = 'LastImportBudgetIntoGRDate')
ALTER TABLE [TapasGlobalBudgeting].[Budget] ADD
      [LastImportBudgetIntoGRDate] [datetime] NULL
GO
 
USE [GrReportingStaging]
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'GBS')
BEGIN
	EXEC ('CREATE SCHEMA GBS')
END

GO 

--------------------------------------------------------------------------------------------------------------------------------------------

USE [GrReportingStaging]
GO
/****** Object:  Table [GBS].[Budget]    Script Date: 01/17/2011 14:15:02 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GBS_Budget_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [GBS].[Budget] DROP CONSTRAINT [DF_GBS_Budget_ImportDate]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GBS].[Budget]') AND type in (N'U'))
DROP TABLE [GBS].[Budget]
GO
/****** Object:  Table [dbo].[BudgetsToProcess]    Script Date: 01/17/2011 14:15:02 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_BudgetsToProcess_InsertedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BudgetsToProcess] DROP CONSTRAINT [DF_BudgetsToProcess_InsertedDate]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BudgetsToProcess]') AND type in (N'U'))
DROP TABLE [dbo].[BudgetsToProcess]
GO
/****** Object:  Table [GBS].[DisputeStatus]    Script Date: 01/17/2011 14:15:02 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GBS_DisputeStatus_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [GBS].[DisputeStatus] DROP CONSTRAINT [DF_GBS_DisputeStatus_ImportDate]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GBS].[DisputeStatus]') AND type in (N'U'))
DROP TABLE [GBS].[DisputeStatus]
GO
/****** Object:  Table [GBS].[Fee]    Script Date: 01/17/2011 14:15:02 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GBS_Fee_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [GBS].[Fee] DROP CONSTRAINT [DF_GBS_Fee_ImportDate]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GBS].[Fee]') AND type in (N'U'))
DROP TABLE [GBS].[Fee]
GO
/****** Object:  Table [GBS].[FeeDetail]    Script Date: 01/17/2011 14:15:02 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GBS_FeeDetail_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [GBS].[FeeDetail] DROP CONSTRAINT [DF_GBS_FeeDetail_ImportDate]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GBS].[FeeDetail]') AND type in (N'U'))
DROP TABLE [GBS].[FeeDetail]
GO
/****** Object:  Table [GBS].[NonPayrollExpense]    Script Date: 01/17/2011 14:15:03 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GBS_NonPayrollExpense_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [GBS].[NonPayrollExpense] DROP CONSTRAINT [DF_GBS_NonPayrollExpense_ImportDate]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GBS].[NonPayrollExpense]') AND type in (N'U'))
DROP TABLE [GBS].[NonPayrollExpense]
GO
/****** Object:  Table [GBS].[NonPayrollExpenseBreakdown]    Script Date: 01/17/2011 14:15:03 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GBS_NonPayrollExpenseBreakdown_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [GBS].[NonPayrollExpenseBreakdown] DROP CONSTRAINT [DF_GBS_NonPayrollExpenseBreakdown_ImportDate]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GBS].[NonPayrollExpenseBreakdown]') AND type in (N'U'))
DROP TABLE [GBS].[NonPayrollExpenseBreakdown]
GO
/****** Object:  Table [GBS].[NonPayrollExpenseDispute]    Script Date: 01/17/2011 14:15:03 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GBS_NonPayrollExpenseDispute_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [GBS].[NonPayrollExpenseDispute] DROP CONSTRAINT [DF_GBS_NonPayrollExpenseDispute_ImportDate]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GBS].[NonPayrollExpenseDispute]') AND type in (N'U'))
DROP TABLE [GBS].[NonPayrollExpenseDispute]
GO
/****** Object:  Table [dbo].[ProfitabilityBudgetUnknowns]    Script Date: 01/17/2011 14:15:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudgetUnknowns]') AND type in (N'U'))
DROP TABLE [dbo].[ProfitabilityBudgetUnknowns]
GO
/****** Object:  Table [Gdm].[Snapshot]    Script Date: 01/17/2011 14:15:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[Snapshot]') AND type in (N'U'))
DROP TABLE [Gdm].[Snapshot]
GO
/****** Object:  Table [Gdm].[SnapshotActivityType]    Script Date: 01/17/2011 14:15:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotActivityType]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotActivityType]
GO
/****** Object:  Table [Gdm].[SnapshotAllocationSubRegion]    Script Date: 01/17/2011 14:15:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotAllocationSubRegion]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotAllocationSubRegion]
GO
/****** Object:  Table [Gdm].[SnapshotCorporateDepartment]    Script Date: 01/17/2011 14:15:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotCorporateDepartment]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotCorporateDepartment]
GO
/****** Object:  Table [Gdm].[SnapshotCorporateEntity]    Script Date: 01/17/2011 14:15:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotCorporateEntity]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotCorporateEntity]
GO
/****** Object:  Table [Gdm].[SnapshotCorporateJobCode]    Script Date: 01/17/2011 14:15:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotCorporateJobCode]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotCorporateJobCode]
GO
/****** Object:  Table [Gdm].[SnapshotCurrency]    Script Date: 01/17/2011 14:15:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotCurrency]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotCurrency]
GO
/****** Object:  Table [Gdm].[SnapshotEntityType]    Script Date: 01/17/2011 14:15:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotEntityType]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotEntityType]
GO
/****** Object:  Table [Gdm].[SnapshotFeePropertyGLAccountGLGlobalAccount]    Script Date: 01/17/2011 14:15:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotFeePropertyGLAccountGLGlobalAccount]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotFeePropertyGLAccountGLGlobalAccount]
GO
/****** Object:  Table [Gdm].[SnapshotFunctionalDepartment]    Script Date: 01/17/2011 14:15:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotFunctionalDepartment]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotFunctionalDepartment]
GO
/****** Object:  Table [Gdm].[SnapshotGLAccount]    Script Date: 01/17/2011 14:15:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLAccount]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotGLAccount]
GO
/****** Object:  Table [Gdm].[SnapshotGLAccountSubType]    Script Date: 01/17/2011 14:15:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLAccountSubType]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotGLAccountSubType]
GO
/****** Object:  Table [Gdm].[SnapshotGLAccountType]    Script Date: 01/17/2011 14:15:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLAccountType]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotGLAccountType]
GO
/****** Object:  Table [Gdm].[SnapshotGLGlobalAccount]    Script Date: 01/17/2011 14:15:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLGlobalAccount]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotGLGlobalAccount]
GO
/****** Object:  Table [Gdm].[SnapshotGLGlobalAccountGLAccount]    Script Date: 01/17/2011 14:15:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLGlobalAccountGLAccount]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotGLGlobalAccountGLAccount]
GO
/****** Object:  Table [Gdm].[SnapshotGLGlobalAccountTranslationSubType]    Script Date: 01/17/2011 14:15:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLGlobalAccountTranslationSubType]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotGLGlobalAccountTranslationSubType]
GO
/****** Object:  Table [Gdm].[SnapshotGLGlobalAccountTranslationType]    Script Date: 01/17/2011 14:15:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLGlobalAccountTranslationType]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotGLGlobalAccountTranslationType]
GO
/****** Object:  Table [Gdm].[SnapshotGLMajorCategory]    Script Date: 01/17/2011 14:15:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLMajorCategory]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotGLMajorCategory]
GO
/****** Object:  Table [Gdm].[SnapshotGLMinorCategory]    Script Date: 01/17/2011 14:15:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLMinorCategory]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotGLMinorCategory]
GO
/****** Object:  Table [Gdm].[SnapshotGLMinorCategoryPayrollType]    Script Date: 01/17/2011 14:15:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLMinorCategoryPayrollType]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotGLMinorCategoryPayrollType]
GO
/****** Object:  Table [Gdm].[SnapshotGlobalRegion]    Script Date: 01/17/2011 14:15:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGlobalRegion]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotGlobalRegion]
GO
/****** Object:  Table [Gdm].[SnapshotGLStatutoryType]    Script Date: 01/17/2011 14:15:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLStatutoryType]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotGLStatutoryType]
GO
/****** Object:  Table [Gdm].[SnapshotGLTranslationSubType]    Script Date: 01/17/2011 14:15:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLTranslationSubType]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotGLTranslationSubType]
GO
/****** Object:  Table [Gdm].[SnapshotGLTranslationType]    Script Date: 01/17/2011 14:15:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLTranslationType]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotGLTranslationType]
GO
/****** Object:  Table [Gdm].[SnapshotManageCorporateDepartment]    Script Date: 01/17/2011 14:15:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotManageCorporateDepartment]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotManageCorporateDepartment]
GO
/****** Object:  Table [Gdm].[SnapshotManageCorporateEntity]    Script Date: 01/17/2011 14:15:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotManageCorporateEntity]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotManageCorporateEntity]
GO
/****** Object:  Table [Gdm].[SnapshotManagePropertyDepartment]    Script Date: 01/17/2011 14:15:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotManagePropertyDepartment]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotManagePropertyDepartment]
GO
/****** Object:  Table [Gdm].[SnapshotManagePropertyEntity]    Script Date: 01/17/2011 14:15:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotManagePropertyEntity]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotManagePropertyEntity]
GO
/****** Object:  Table [Gdm].[SnapshotManageType]    Script Date: 01/17/2011 14:15:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotManageType]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotManageType]
GO
/****** Object:  Table [Gdm].[SnapshotOriginatingRegionCorporateEntity]    Script Date: 01/17/2011 14:15:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotOriginatingRegionCorporateEntity]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotOriginatingRegionCorporateEntity]
GO
/****** Object:  Table [Gdm].[SnapshotOriginatingRegionPropertyDepartment]    Script Date: 01/17/2011 14:15:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotOriginatingRegionPropertyDepartment]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotOriginatingRegionPropertyDepartment]
GO
/****** Object:  Table [Gdm].[SnapshotOverheadRegion]    Script Date: 01/17/2011 14:15:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotOverheadRegion]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotOverheadRegion]
GO
/****** Object:  Table [Gdm].[SnapshotPayrollRegion]    Script Date: 01/17/2011 14:15:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotPayrollRegion]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotPayrollRegion]
GO
/****** Object:  Table [Gdm].[SnapshotPropertyEntityException]    Script Date: 01/17/2011 14:15:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotPropertyEntityException]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotPropertyEntityException]
GO
/****** Object:  Table [Gdm].[SnapshotPropertyEntityGLAccountInclusion]    Script Date: 01/17/2011 14:15:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotPropertyEntityGLAccountInclusion]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotPropertyEntityGLAccountInclusion]
GO
/****** Object:  Table [Gdm].[SnapshotPropertyFund]    Script Date: 01/17/2011 14:15:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotPropertyFund]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotPropertyFund]
GO
/****** Object:  Table [Gdm].[SnapshotPropertyFundBudgetCoordinator]    Script Date: 01/17/2011 14:15:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotPropertyFundBudgetCoordinator]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotPropertyFundBudgetCoordinator]
GO
/****** Object:  Table [Gdm].[SnapshotPropertyFundDisplayName]    Script Date: 01/17/2011 14:15:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotPropertyFundDisplayName]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotPropertyFundDisplayName]
GO
/****** Object:  Table [Gdm].[SnapshotPropertyFundMapping]    Script Date: 01/17/2011 14:15:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotPropertyFundMapping]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotPropertyFundMapping]
GO
/****** Object:  Table [Gdm].[SnapshotPropertyGLAccountGLGlobalAccount]    Script Date: 01/17/2011 14:15:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotPropertyGLAccountGLGlobalAccount]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotPropertyGLAccountGLGlobalAccount]
GO
/****** Object:  Table [Gdm].[SnapshotPropertyOverheadPropertyGLAccount]    Script Date: 01/17/2011 14:15:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotPropertyOverheadPropertyGLAccount]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotPropertyOverheadPropertyGLAccount]
GO
/****** Object:  Table [Gdm].[SnapshotPropertyPayrollPropertyGLAccount]    Script Date: 01/17/2011 14:15:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotPropertyPayrollPropertyGLAccount]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotPropertyPayrollPropertyGLAccount]
GO
/****** Object:  Table [Gdm].[SnapshotRechargeCorporateDepartmentPropertyEntity]    Script Date: 01/17/2011 14:15:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotRechargeCorporateDepartmentPropertyEntity]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotRechargeCorporateDepartmentPropertyEntity]
GO
/****** Object:  Table [Gdm].[SnapshotRegionalAdministratorGlobalSubRegion]    Script Date: 01/17/2011 14:15:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotRegionalAdministratorGlobalSubRegion]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotRegionalAdministratorGlobalSubRegion]
GO
/****** Object:  Table [Gdm].[SnapshotRelatedFund]    Script Date: 01/17/2011 14:15:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotRelatedFund]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotRelatedFund]
GO
/****** Object:  Table [Gdm].[SnapshotReportingEntityCorporateDepartment]    Script Date: 01/17/2011 14:15:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotReportingEntityCorporateDepartment]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotReportingEntityCorporateDepartment]
GO
/****** Object:  Table [Gdm].[SnapshotReportingEntityPropertyEntity]    Script Date: 01/17/2011 14:15:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotReportingEntityPropertyEntity]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotReportingEntityPropertyEntity]
GO
/****** Object:  Table [Gdm].[SnapshotReportingEntityPropertyEntity]    Script Date: 01/17/2011 14:15:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotReportingEntityPropertyEntity]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotReportingEntityPropertyEntity](
	[SnapshotId] [int] NOT NULL,
	[ReportingEntityPropertyEntityId] [int] NOT NULL,
	[PropertyFundId] [int] NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[PropertyEntityCode] [char](6) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_SnapshotReportingEntityPropertyEntity] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[ReportingEntityPropertyEntityId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotReportingEntityCorporateDepartment]    Script Date: 01/17/2011 14:15:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotReportingEntityCorporateDepartment]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotReportingEntityCorporateDepartment](
	[SnapshotId] [int] NOT NULL,
	[ReportingEntityCorporateDepartmentId] [int] NOT NULL,
	[PropertyFundId] [int] NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[CorporateDepartmentCode] [char](6) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_SnapshotReportingEntityCorporateDepartment] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[ReportingEntityCorporateDepartmentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotRelatedFund]    Script Date: 01/17/2011 14:15:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotRelatedFund]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotRelatedFund](
	[SnapshotId] [int] NOT NULL,
	[RelatedFundId] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[AbbreviatedName] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotRelatedFund] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[RelatedFundId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotRegionalAdministratorGlobalSubRegion]    Script Date: 01/17/2011 14:15:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotRegionalAdministratorGlobalSubRegion]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotRegionalAdministratorGlobalSubRegion](
	[SnapshotId] [int] NOT NULL,
	[StaffId] [int] NOT NULL,
	[GlobalSubRegionId] [int] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotRegionalAdministratorGlobalSubRegion] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[StaffId] ASC,
	[GlobalSubRegionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [Gdm].[SnapshotRechargeCorporateDepartmentPropertyEntity]    Script Date: 01/17/2011 14:15:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotRechargeCorporateDepartmentPropertyEntity]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotRechargeCorporateDepartmentPropertyEntity](
	[SnapshotId] [int] NOT NULL,
	[RechargeCorporateDepartmentPropertyEntityId] [int] NOT NULL,
	[CorporateDepartmentCode] [char](8) NOT NULL,
	[CorporateDepartmentSourceCode] [char](2) NOT NULL,
	[PropertyEntityCode] [char](6) NOT NULL,
	[PropertyEntitySourceCode] [char](2) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotRechargeCorporateDepartmentPropertyEntity] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[RechargeCorporateDepartmentPropertyEntityId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotPropertyPayrollPropertyGLAccount]    Script Date: 01/17/2011 14:15:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotPropertyPayrollPropertyGLAccount]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotPropertyPayrollPropertyGLAccount](
	[SnapshotId] [int] NOT NULL,
	[PropertyPayrollPropertyGLAccountId] [int] NOT NULL,
	[PropertyGLAccountCode] [char](14) NOT NULL,
	[PropertyBudgetTypeId] [int] NULL,
	[SourceCode] [char](2) NOT NULL,
	[ActivityTypeId] [int] NULL,
	[FunctionalDepartmentId] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[PayrollTypeId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotPropertyPayrollPropertyGLAccount] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[PropertyPayrollPropertyGLAccountId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_SnapshotPropertyPayrollPropertyGLAccount_Unique] UNIQUE NONCLUSTERED 
(
	[SnapshotId] ASC,
	[SourceCode] ASC,
	[ActivityTypeId] ASC,
	[FunctionalDepartmentId] ASC,
	[PropertyBudgetTypeId] ASC,
	[PayrollTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotPropertyOverheadPropertyGLAccount]    Script Date: 01/17/2011 14:15:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotPropertyOverheadPropertyGLAccount]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotPropertyOverheadPropertyGLAccount](
	[SnapshotId] [int] NOT NULL,
	[PropertyOverheadPropertyGLAccountId] [int] NOT NULL,
	[PropertyGLAccountCode] [char](14) NOT NULL,
	[PropertyBudgetTypeId] [int] NULL,
	[SourceCode] [char](2) NOT NULL,
	[ActivityTypeId] [int] NULL,
	[FunctionalDepartmentId] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotPropertyOverheadPropertyGLAccount] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[PropertyOverheadPropertyGLAccountId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_SnapshotPropertyOverheadPropertyGLAccount_Unique] UNIQUE NONCLUSTERED 
(
	[SnapshotId] ASC,
	[SourceCode] ASC,
	[ActivityTypeId] ASC,
	[FunctionalDepartmentId] ASC,
	[PropertyBudgetTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotPropertyGLAccountGLGlobalAccount]    Script Date: 01/17/2011 14:15:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotPropertyGLAccountGLGlobalAccount]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotPropertyGLAccountGLGlobalAccount](
	[SnapshotId] [int] NOT NULL,
	[PropertyGLAccountGLGlobalAccountId] [int] NOT NULL,
	[PropertyGLAccountCode] [char](14) NOT NULL,
	[GLGlobalAccountId] [int] NOT NULL,
	[PropertyBudgetTypeId] [int] NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[IsDirectCost] [bit] NOT NULL,
 CONSTRAINT [PK_SnapshotPropertyGLAccountGLGlobalAccount] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[PropertyGLAccountGLGlobalAccountId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotPropertyFundMapping]    Script Date: 01/17/2011 14:15:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotPropertyFundMapping]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotPropertyFundMapping](
	[SnapshotId] [int] NOT NULL,
	[PropertyFundMappingId] [int] NOT NULL,
	[PropertyFundId] [int] NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[PropertyFundCode] [char](6) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[ActivityTypeId] [int] NULL,
 CONSTRAINT [PK_SnapshotPropertyFundMapping] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[PropertyFundMappingId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotPropertyFundDisplayName]    Script Date: 01/17/2011 14:15:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotPropertyFundDisplayName]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotPropertyFundDisplayName](
	[SnapshotId] [int] NOT NULL,
	[PropertyFundDisplayNameId] [int] NOT NULL,
	[PropertyFundId] [int] NOT NULL,
	[DisplayName] [varchar](100) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotPropertyFundDisplayName] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[PropertyFundDisplayNameId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotPropertyFundBudgetCoordinator]    Script Date: 01/17/2011 14:15:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotPropertyFundBudgetCoordinator]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotPropertyFundBudgetCoordinator](
	[SnapshotId] [int] NOT NULL,
	[PropertyFundBudgetCoordinatorId] [int] NOT NULL,
	[PropertyFundId] [int] NOT NULL,
	[BudgetCoordinatorStaffId] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotPropertyFundBudgetCoordinator] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[PropertyFundBudgetCoordinatorId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [Gdm].[SnapshotPropertyFund]    Script Date: 01/17/2011 14:15:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotPropertyFund]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotPropertyFund](
	[SnapshotId] [int] NOT NULL,
	[PropertyFundId] [int] NOT NULL,
	[RelatedFundId] [int] NULL,
	[EntityTypeId] [int] NOT NULL,
	[AllocationSubRegionGlobalRegionId] [int] NOT NULL,
	[BudgetOwnerStaffId] [int] NOT NULL,
	[RegionalOwnerStaffId] [int] NOT NULL,
	[DefaultGLTranslationSubTypeId] [int] NULL,
	[Name] [varchar](100) NOT NULL,
	[IsReportingEntity] [bit] NOT NULL,
	[IsPropertyFund] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotPropertyFund] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[PropertyFundId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotPropertyEntityGLAccountInclusion]    Script Date: 01/17/2011 14:15:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotPropertyEntityGLAccountInclusion]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotPropertyEntityGLAccountInclusion](
	[SnapshotId] [int] NOT NULL,
	[PropertyEntityGLAccountInclusionId] [int] NOT NULL,
	[PropertyEntityCode] [varchar](10) NOT NULL,
	[GLAccountCode] [varchar](12) NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotPropertyEntityGLAccountInclusion] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[PropertyEntityGLAccountInclusionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UX_PropertyEntityGLAccountInclusion_PropertyEntityCode_GLAccountCode_SourceCode] UNIQUE NONCLUSTERED 
(
	[SnapshotId] ASC,
	[PropertyEntityCode] ASC,
	[GLAccountCode] ASC,
	[SourceCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotPropertyEntityException]    Script Date: 01/17/2011 14:15:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotPropertyEntityException]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotPropertyEntityException](
	[SnapshotId] [int] NOT NULL,
	[PropertyEntityExceptionId] [int] NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[PropertyEntityCode] [char](6) NOT NULL,
	[GLGlobalAccountId] [int] NOT NULL,
	[PropertyBudgetTypeId] [int] NOT NULL,
	[PropertyGLAccountCode] [char](14) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[IsDirectCost] [bit] NOT NULL,
 CONSTRAINT [PK_SnapshotPropertyEntityException] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[PropertyEntityExceptionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotPayrollRegion]    Script Date: 01/17/2011 14:15:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotPayrollRegion]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotPayrollRegion](
	[SnapshotId] [int] NOT NULL,
	[PayrollRegionId] [int] NOT NULL,
	[RegionId] [int] NULL,
	[ExternalSubRegionId] [int] NULL,
	[CorporateEntityRef] [varchar](6) NULL,
	[CorporateSourceCode] [varchar](2) NULL,
	[InsertedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedByStaffId] [int] NULL,
 CONSTRAINT [PK_SnapshotPayrollRegion] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[PayrollRegionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotOverheadRegion]    Script Date: 01/17/2011 14:15:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotOverheadRegion]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotOverheadRegion](
	[SnapshotId] [int] NOT NULL,
	[OverheadRegionId] [int] NOT NULL,
	[RegionId] [int] NULL,
	[CorporateEntityRef] [varchar](6) NULL,
	[CorporateSourceCode] [varchar](2) NULL,
	[Name] [varchar](50) NULL,
	[InsertedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedByStaffId] [int] NULL,
 CONSTRAINT [PK_SnapshotOverheadRegion_1] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[OverheadRegionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotOriginatingRegionPropertyDepartment]    Script Date: 01/17/2011 14:15:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotOriginatingRegionPropertyDepartment]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotOriginatingRegionPropertyDepartment](
	[SnapshotId] [int] NOT NULL,
	[OriginatingRegionPropertyDepartmentId] [int] NOT NULL,
	[GlobalRegionId] [int] NOT NULL,
	[PropertyDepartmentCode] [varchar](10) NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotOriginatingRegionPropertyDepartment] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[OriginatingRegionPropertyDepartmentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotOriginatingRegionCorporateEntity]    Script Date: 01/17/2011 14:15:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotOriginatingRegionCorporateEntity]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotOriginatingRegionCorporateEntity](
	[SnapshotId] [int] NOT NULL,
	[OriginatingRegionCorporateEntityId] [int] NOT NULL,
	[GlobalRegionId] [int] NOT NULL,
	[CorporateEntityCode] [varchar](10) NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotOriginatingRegionCorporateEntity] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[OriginatingRegionCorporateEntityId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotManageType]    Script Date: 01/17/2011 14:15:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotManageType]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotManageType](
	[SnapshotId] [int] NOT NULL,
	[ManageTypeId] [int] NOT NULL,
	[Code] [varchar](10) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotManageType] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[ManageTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UX_SnapshotManageType_Code] UNIQUE NONCLUSTERED 
(
	[SnapshotId] ASC,
	[Code] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotManagePropertyEntity]    Script Date: 01/17/2011 14:15:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotManagePropertyEntity]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotManagePropertyEntity](
	[SnapshotId] [int] NOT NULL,
	[ManagePropertyEntityId] [int] NOT NULL,
	[ManageTypeId] [int] NOT NULL,
	[PropertyEntityCode] [char](6) NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotManagePropertyEntity] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[ManagePropertyEntityId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UX_SnapshotManagePropertyEntity_ManageTypeId_PropertyEntityCode_SourceCode] UNIQUE NONCLUSTERED 
(
	[SnapshotId] ASC,
	[ManageTypeId] ASC,
	[PropertyEntityCode] ASC,
	[SourceCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotManagePropertyDepartment]    Script Date: 01/17/2011 14:15:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotManagePropertyDepartment]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotManagePropertyDepartment](
	[SnapshotId] [int] NOT NULL,
	[ManagePropertyDepartmentId] [int] NOT NULL,
	[ManageTypeId] [int] NOT NULL,
	[PropertyDepartmentCode] [char](8) NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotManagePropertyDepartment] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[ManagePropertyDepartmentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UX_SnapshotManagePropertyDepartment_ManageTypeId_PropertyDepartmentCode_SourceCode] UNIQUE NONCLUSTERED 
(
	[SnapshotId] ASC,
	[ManageTypeId] ASC,
	[PropertyDepartmentCode] ASC,
	[SourceCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotManageCorporateEntity]    Script Date: 01/17/2011 14:15:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotManageCorporateEntity]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotManageCorporateEntity](
	[SnapshotId] [int] NOT NULL,
	[ManageCorporateEntityId] [int] NOT NULL,
	[ManageTypeId] [int] NOT NULL,
	[CorporateEntityCode] [char](6) NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotManageCorporateEntity] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[ManageCorporateEntityId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UX_SnapshotManageCorporateEntity_ManageTypeId_CorporateEntityCode_SourceCode] UNIQUE NONCLUSTERED 
(
	[SnapshotId] ASC,
	[ManageTypeId] ASC,
	[CorporateEntityCode] ASC,
	[SourceCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotManageCorporateDepartment]    Script Date: 01/17/2011 14:15:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotManageCorporateDepartment]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotManageCorporateDepartment](
	[SnapshotId] [int] NOT NULL,
	[ManageCorporateDepartmentId] [int] NOT NULL,
	[ManageTypeId] [int] NOT NULL,
	[CorporateDepartmentCode] [char](8) NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotManageCorporateDepartment] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[ManageCorporateDepartmentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UX_SnapshotManageCorporateDepartment_ManageTypeId_CorporateDepartmentCode_SourceCode] UNIQUE NONCLUSTERED 
(
	[SnapshotId] ASC,
	[ManageTypeId] ASC,
	[CorporateDepartmentCode] ASC,
	[SourceCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotGLTranslationType]    Script Date: 01/17/2011 14:15:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLTranslationType]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotGLTranslationType](
	[SnapshotId] [int] NOT NULL,
	[GLTranslationTypeId] [int] NOT NULL,
	[Code] [varchar](10) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotGLTranslationType] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[GLTranslationTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UX_SnapshotGLTranslationType_Code] UNIQUE NONCLUSTERED 
(
	[SnapshotId] ASC,
	[Code] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UX_SnapshotGLTranslationType_Name] UNIQUE NONCLUSTERED 
(
	[SnapshotId] ASC,
	[Name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotGLTranslationSubType]    Script Date: 01/17/2011 14:15:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLTranslationSubType]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotGLTranslationSubType](
	[SnapshotId] [int] NOT NULL,
	[GLTranslationSubTypeId] [int] NOT NULL,
	[GLTranslationTypeId] [int] NOT NULL,
	[Code] [varchar](10) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[IsGRDefault] [bit] NOT NULL,
 CONSTRAINT [PK_SnapshotGLTranslationSubType] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[GLTranslationSubTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UX_SnapshotGLTranslationSubType_Code] UNIQUE NONCLUSTERED 
(
	[SnapshotId] ASC,
	[Code] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UX_SnapshotGLTranslationSubType_Name] UNIQUE NONCLUSTERED 
(
	[SnapshotId] ASC,
	[Name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotGLStatutoryType]    Script Date: 01/17/2011 14:15:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLStatutoryType]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotGLStatutoryType](
	[SnapshotId] [int] NOT NULL,
	[GLStatutoryTypeId] [int] NOT NULL,
	[Code] [varchar](10) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotGLStatutoryType] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[GLStatutoryTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotGlobalRegion]    Script Date: 01/17/2011 14:15:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGlobalRegion]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotGlobalRegion](
	[SnapshotId] [int] NOT NULL,
	[GlobalRegionId] [int] NOT NULL,
	[ParentGlobalRegionId] [int] NULL,
	[CountryId] [int] NULL,
	[Code] [varchar](10) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[IsAllocationRegion] [bit] NOT NULL,
	[IsOriginatingRegion] [bit] NOT NULL,
	[DefaultCurrencyCode] [char](3) NOT NULL,
	[DefaultCorporateSourceCode] [char](2) NOT NULL,
	[ProjectCodePortion] [varchar](2) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotGlobalRegion] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[GlobalRegionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotGLMinorCategoryPayrollType]    Script Date: 01/17/2011 14:15:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLMinorCategoryPayrollType]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotGLMinorCategoryPayrollType](
	[SnapshotId] [int] NOT NULL,
	[GLMinorCategoryPayrollTypeId] [int] NOT NULL,
	[GLMinorCategoryId] [int] NOT NULL,
	[PayrollTypeId] [int] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotGLMinorCategoryPayrollType] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[GLMinorCategoryPayrollTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [Gdm].[SnapshotGLMinorCategory]    Script Date: 01/17/2011 14:15:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLMinorCategory]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotGLMinorCategory](
	[SnapshotId] [int] NOT NULL,
	[GLMinorCategoryId] [int] NOT NULL,
	[GLMajorCategoryId] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotGLMinorCategory] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[GLMinorCategoryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UX_SnapshotGLMinorCategory_Name] UNIQUE NONCLUSTERED 
(
	[SnapshotId] ASC,
	[Name] ASC,
	[GLMajorCategoryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotGLMajorCategory]    Script Date: 01/17/2011 14:15:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLMajorCategory]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotGLMajorCategory](
	[SnapshotId] [int] NOT NULL,
	[GLMajorCategoryId] [int] NOT NULL,
	[GLTranslationSubTypeId] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotGLMajorCategory] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[GLMajorCategoryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UX_SnapshotGLMajorCategory_Name] UNIQUE NONCLUSTERED 
(
	[SnapshotId] ASC,
	[Name] ASC,
	[GLTranslationSubTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotGLGlobalAccountTranslationType]    Script Date: 01/17/2011 14:15:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLGlobalAccountTranslationType]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotGLGlobalAccountTranslationType](
	[SnapshotId] [int] NOT NULL,
	[GLGlobalAccountTranslationTypeId] [int] NOT NULL,
	[GLGlobalAccountId] [int] NOT NULL,
	[GLTranslationTypeId] [int] NOT NULL,
	[GLAccountTypeId] [int] NOT NULL,
	[GLAccountSubTypeId] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotGLGlobalAccountTranslationType] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[GLGlobalAccountTranslationTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UX_SnapshotGLGlobalAccountTranslationType_GLGlobalAccountId] UNIQUE NONCLUSTERED 
(
	[SnapshotId] ASC,
	[GLGlobalAccountId] ASC,
	[GLTranslationTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [Gdm].[SnapshotGLGlobalAccountTranslationSubType]    Script Date: 01/17/2011 14:15:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLGlobalAccountTranslationSubType]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotGLGlobalAccountTranslationSubType](
	[SnapshotId] [int] NOT NULL,
	[GLGlobalAccountTranslationSubTypeId] [int] NOT NULL,
	[GLGlobalAccountId] [int] NOT NULL,
	[GLTranslationSubTypeId] [int] NOT NULL,
	[GLMinorCategoryId] [int] NOT NULL,
	[PostingPropertyGLAccountCode] [varchar](14) NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotGLGlobalAccountTranslationSubType] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[GLGlobalAccountTranslationSubTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UX_SnapshotGLGlobalAccountTranslationSubType_GLGlobalAccountId] UNIQUE NONCLUSTERED 
(
	[SnapshotId] ASC,
	[GLGlobalAccountId] ASC,
	[GLTranslationSubTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotGLGlobalAccountGLAccount]    Script Date: 01/17/2011 14:15:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLGlobalAccountGLAccount]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotGLGlobalAccountGLAccount](
	[SnapshotId] [int] NOT NULL,
	[GLGlobalAccountGLAccountId] [int] NOT NULL,
	[GLGlobalAccountId] [int] NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[Code] [varchar](12) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[PreGlobalAccountCode] [varchar](50) NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotGLGlobalAccountGLAccount] PRIMARY KEY NONCLUSTERED 
(
	[SnapshotId] ASC,
	[GLGlobalAccountGLAccountId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotGLGlobalAccount]    Script Date: 01/17/2011 14:15:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLGlobalAccount]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotGLGlobalAccount](
	[SnapshotId] [int] NOT NULL,
	[GLGlobalAccountId] [int] NOT NULL,
	[ActivityTypeId] [int] NULL,
	[GLStatutoryTypeId] [int] NOT NULL,
	[ParentGLGlobalAccountId] [int] NULL,
	[Code] [varchar](10) NOT NULL,
	[Name] [nvarchar](150) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[IsGR] [bit] NOT NULL,
	[IsGbs] [bit] NOT NULL,
	[IsRegionalOverheadCost] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[ExpenseCzarStaffId] [int] NOT NULL,
	[ParentCode]  AS (left([Code],(8))) PERSISTED,
 CONSTRAINT [PK_SnapshotGLGlobalAccount] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[GLGlobalAccountId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UX_SnapshotGLGlobalAccount_Code] UNIQUE NONCLUSTERED 
(
	[SnapshotId] ASC,
	[Code] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotGLAccountType]    Script Date: 01/17/2011 14:15:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLAccountType]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotGLAccountType](
	[SnapshotId] [int] NOT NULL,
	[GLAccountTypeId] [int] NOT NULL,
	[GLTranslationTypeId] [int] NOT NULL,
	[Code] [varchar](10) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotGLAccountTypeId] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[GLAccountTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UX_SnapshotGLAccountType_Code] UNIQUE NONCLUSTERED 
(
	[SnapshotId] ASC,
	[Code] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UX_SnapshotGLAccountType_Name] UNIQUE NONCLUSTERED 
(
	[SnapshotId] ASC,
	[Name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotGLAccountSubType]    Script Date: 01/17/2011 14:15:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLAccountSubType]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotGLAccountSubType](
	[SnapshotId] [int] NOT NULL,
	[GLAccountSubTypeId] [int] NOT NULL,
	[GLTranslationTypeId] [int] NOT NULL,
	[Code] [varchar](10) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotGLAccountSubType] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[GLAccountSubTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UX_SnapshotGLAccountSubType_Code] UNIQUE NONCLUSTERED 
(
	[SnapshotId] ASC,
	[Code] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UX_SnapshotGLAccountSubType_Name] UNIQUE NONCLUSTERED 
(
	[SnapshotId] ASC,
	[Name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotGLAccount]    Script Date: 01/17/2011 14:15:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLAccount]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotGLAccount](
	[SnapshotId] [int] NOT NULL,
	[Code] [varchar](15) NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Type] [char](1) NULL,
	[IsHistoric] [bit] NULL,
	[IsGR] [bit] NULL,
	[IsActive] [bit] NULL,
	[UpdatedDate] [datetime] NULL,
 CONSTRAINT [PK_SnapshotGLAccount] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[Code] ASC,
	[SourceCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotFunctionalDepartment]    Script Date: 01/17/2011 14:15:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotFunctionalDepartment]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotFunctionalDepartment](
	[SnapshotId] [int] NOT NULL,
	[FunctionalDepartmentId] [int] NOT NULL,
	[Name] [varchar](50) NULL,
	[Code] [varchar](20) NULL,
	[GlobalCode] [varchar](3) NULL,
	[IsActive] [bit] NULL,
	[InsertedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedByStaffId] [int] NULL,
	[NuViewId] [int] NULL,
 CONSTRAINT [PK_SnapshotFunctionalDepartment] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[FunctionalDepartmentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotFeePropertyGLAccountGLGlobalAccount]    Script Date: 01/17/2011 14:15:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotFeePropertyGLAccountGLGlobalAccount]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotFeePropertyGLAccountGLGlobalAccount](
	[SnapshotId] [int] NOT NULL,
	[FeePropertyGLAccountGLGlobalAccountId] [int] NOT NULL,
	[PropertyGLAccountCode] [char](14) NOT NULL,
	[GLGlobalAccountId] [int] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[SourceCode] [char](2) NULL,
 CONSTRAINT [PK_SnapshotFeePropertyGLAccountGLGlobalAccountId] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[FeePropertyGLAccountGLGlobalAccountId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_SnapshotFeePropertyGLAccountGLGlobalAccountId_PropertyGLAccountId] UNIQUE NONCLUSTERED 
(
	[SnapshotId] ASC,
	[PropertyGLAccountCode] ASC,
	[SourceCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotEntityType]    Script Date: 01/17/2011 14:15:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotEntityType]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotEntityType](
	[SnapshotId] [int] NOT NULL,
	[EntityTypeId] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[ProjectCodePortion] [char](1) NULL,
	[Description] [varchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotEntityType] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[EntityTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotCurrency]    Script Date: 01/17/2011 14:15:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotCurrency]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotCurrency](
	[SnapshotId] [int] NOT NULL,
	[Code] [char](3) NOT NULL,
	[Symbol] [varchar](20) NOT NULL,
 CONSTRAINT [PK_SnapshotCurrency] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[Code] ASC,
	[Symbol] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotCorporateJobCode]    Script Date: 01/17/2011 14:15:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotCorporateJobCode]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotCorporateJobCode](
	[SnapshotId] [int] NOT NULL,
	[Code] [varchar](15) NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[JobType] [varchar](15) NULL,
	[Description] [varchar](50) NULL,
	[FunctionalDepartmentId] [int] NULL,
	[IsActive] [bit] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
 CONSTRAINT [PK_SnapshotCorporateJobCode] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[Code] ASC,
	[SourceCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotCorporateEntity]    Script Date: 01/17/2011 14:15:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotCorporateEntity]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotCorporateEntity](
	[SnapshotId] [int] NOT NULL,
	[Code] [char](6) NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[CityID] [int] NULL,
	[Name] [nvarchar](264) NULL,
	[DisplayName] [varchar](80) NULL,
	[CurrencyCode] [char](3) NULL,
	[IsActive] [bit] NULL,
	[IsCustom] [bit] NULL,
	[Address] [varchar](1024) NULL,
	[IsFund] [bit] NULL,
	[ShippingAddress] [varchar](512) NULL,
	[BillingAddress] [varchar](512) NULL,
	[ProjectRef] [char](8) NULL,
	[IsOutsourced] [bit] NULL,
	[IsRMProperty] [bit] NULL,
	[IsHistoric] [bit] NULL,
 CONSTRAINT [PK_SnapshotCorporateEntity] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[Code] ASC,
	[SourceCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotCorporateDepartment]    Script Date: 01/17/2011 14:15:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotCorporateDepartment]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotCorporateDepartment](
	[SnapshotId] [int] NOT NULL,
	[Code] [char](8) NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[Description] [varchar](50) NULL,
	[LastDate] [datetime] NULL,
	[MriUserID] [char](20) NULL,
	[IsActive] [bit] NULL,
	[FunctionalDepartmentId] [int] NULL,
	[IsTsCost] [bit] NULL,
 CONSTRAINT [PK_SnapshotCorporateDepartment] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[Code] ASC,
	[SourceCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotAllocationSubRegion]    Script Date: 01/17/2011 14:15:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotAllocationSubRegion]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotAllocationSubRegion](
	[SnapshotId] [int] NOT NULL,
	[AllocationSubRegionGlobalRegionId] [int] NOT NULL,
	[Code] [varchar](10) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[ProjectCodePortion] [varchar](2) NOT NULL,
	[AllocationRegionGlobalRegionId] [int] NULL,
	[DefaultCurrencyCode] [char](3) NOT NULL,
	[DefaultCorporateSourceCode] [char](2) NOT NULL,
	[CountryId] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[SnapshotActivityType]    Script Date: 01/17/2011 14:15:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotActivityType]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotActivityType](
	[SnapshotId] [int] NOT NULL,
	[ActivityTypeId] [int] NOT NULL,
	[Code] [varchar](10) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[GLAccountSuffix] [char](2) NOT NULL,
	[IsEscalatable] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[ActivityTypeCode]  AS (CONVERT([varchar](10),[Code],(0))),
	[GLSuffix]  AS (CONVERT([char](2),[GLAccountSuffix],(0))),
 CONSTRAINT [PK_SnapshotActivityType] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[ActivityTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UX_SnapshotActivityType_GLAccountSuffix] UNIQUE NONCLUSTERED 
(
	[SnapshotId] ASC,
	[GLAccountSuffix] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UX_SnapshotActivityType_Name] UNIQUE NONCLUSTERED 
(
	[SnapshotId] ASC,
	[Name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Gdm].[Snapshot]    Script Date: 01/17/2011 14:15:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[Snapshot]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[Snapshot](
	[SnapshotId] [int] NOT NULL,
	[GroupName] [varchar](50) NOT NULL,
	[GroupKey] [varchar](50) NOT NULL,
	[IsLocked] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[LastSyncDate] [datetime] NULL,
	[ManualUpdatedDate] [datetime] NULL,
 CONSTRAINT [PK_Snapshot] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UX_Snapshot_GroupKey] UNIQUE NONCLUSTERED 
(
	[GroupName] ASC,
	[GroupKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProfitabilityBudgetUnknowns]    Script Date: 01/17/2011 14:15:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudgetUnknowns]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ProfitabilityBudgetUnknowns](
	[ProfitabilityBudgetUnknownsKey] [bigint] IDENTITY(1,1) NOT NULL,
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
	[LocalBudget] [money] NOT NULL,
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
	[SourceSystemId] [int] NOT NULL,
	[OverheadKey] [int] NOT NULL,
	[FeeAdjustmentKey] [int] NOT NULL,
 CONSTRAINT [PK_ProfitabilityBudgetUnknowns] PRIMARY KEY NONCLUSTERED 
(
	[ProfitabilityBudgetUnknownsKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [GBS].[NonPayrollExpenseDispute]    Script Date: 01/17/2011 14:15:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GBS].[NonPayrollExpenseDispute]') AND type in (N'U'))
BEGIN
CREATE TABLE [GBS].[NonPayrollExpenseDispute](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL CONSTRAINT [DF_GBS_NonPayrollExpenseDispute_ImportDate]  DEFAULT (getdate()),
	[NonPayrollExpenseDisputeId] [int] NOT NULL,
	[NonPayrollExpenseId] [int] NOT NULL,
	[BudgetProjectId] [int] NOT NULL,
	[DisputeCategoryId] [int] NOT NULL,
	[DisputeStatusId] [int] NOT NULL,
	[DisputeCreatorStaffId] [int] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [GBS].[NonPayrollExpenseBreakdown]    Script Date: 01/17/2011 14:15:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GBS].[NonPayrollExpenseBreakdown]') AND type in (N'U'))
BEGIN
CREATE TABLE [GBS].[NonPayrollExpenseBreakdown](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL CONSTRAINT [DF_GBS_NonPayrollExpenseBreakdown_ImportDate]  DEFAULT (getdate()),
	[NonPayrollExpenseBreakdownId] [int] NOT NULL,
	[NonPayrollExpenseId] [int] NOT NULL,
	[BudgetId] [int] NOT NULL,
	[BudgetProjectId] [int] NOT NULL,
	[BudgetProjectGroupId] [int] NULL,
	[ActivityTypeId] [int] NOT NULL,
	[OriginatingSubRegionGlobalRegionId] [int] NOT NULL,
	[GLGlobalAccountId] [int] NOT NULL,
	[FunctionalDepartmentId] [int] NOT NULL,
	[DateRangeSpreadId] [int] NOT NULL,
	[JobCode] [varchar](15) NULL,
	[Vendor] [varchar](50) NOT NULL,
	[Period] [int] NOT NULL,
	[CorporateDepartmentCode] [char](8) NOT NULL,
	[BudgetProjectPropertyFundId] [int] NOT NULL,
	[ExpenseDescription] [varchar](300) NOT NULL,
	[CurrencyCode] [char](3) NOT NULL,
	[CorporateSourceCode] [char](2) NOT NULL,
	[BudgetProjectName] [varchar](100) NOT NULL,
	[BudgetProjectGroupName] [varchar](100) NULL,
	[Amount] [money] NOT NULL,
	[AllocationPercentage] [decimal](7, 3) NOT NULL,
	[CannotBeDisputed] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[ExpenseCreatorStaffId] [int] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[IsDirectCost] [bit] NOT NULL,
	[IsRegionalOverheadCost] [bit] NOT NULL,
	[NonPayrollExpenseUpdatedDate] [datetime] NOT NULL,
	[ActivitySpecificGLGlobalAccountId] [int] NULL,
	[OriginalNonPayrollExpenseId] [int] NULL,
	[OriginalBudgetProjectId] [int] NULL,
	[OriginalBudgetProjectGroupId] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [GBS].[NonPayrollExpense]    Script Date: 01/17/2011 14:15:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GBS].[NonPayrollExpense]') AND type in (N'U'))
BEGIN
CREATE TABLE [GBS].[NonPayrollExpense](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL CONSTRAINT [DF_GBS_NonPayrollExpense_ImportDate]  DEFAULT (getdate()),
	[NonPayrollExpenseId] [int] NOT NULL,
	[BudgetId] [int] NOT NULL,
	[OriginalNonPayrollExpenseId] [int] NULL,
	[CorporateSourceCode] [char](2) NOT NULL,
	[OriginatingSubRegionGlobalRegionId] [int] NOT NULL,
	[GLGlobalAccountId] [int] NOT NULL,
	[FunctionalDepartmentId] [int] NOT NULL,
	[BudgetProjectId] [int] NULL,
	[BudgetProjectGroupId] [int] NULL,
	[ExpenseCreatorStaffId] [int] NOT NULL,
	[DateRangeSpreadId] [int] NOT NULL,
	[JobCode] [varchar](15) NULL,
	[Vendor] [varchar](50) NULL,
	[CurrencyCode] [char](3) NOT NULL,
	[Description] [varchar](300) NOT NULL,
	[IsDirectCost] [bit] NOT NULL,
	[IsRegionalOverheadCost] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [GBS].[FeeDetail]    Script Date: 01/17/2011 14:15:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GBS].[FeeDetail]') AND type in (N'U'))
BEGIN
CREATE TABLE [GBS].[FeeDetail](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL CONSTRAINT [DF_GBS_FeeDetail_ImportDate]  DEFAULT (getdate()),
	[FeeDetailId] [int] NOT NULL,
	[FeeId] [int] NOT NULL,
	[Period] [int] NOT NULL,
	[Amount] [money] NOT NULL,
	[IsAdjustment] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [GBS].[Fee]    Script Date: 01/17/2011 14:15:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GBS].[Fee]') AND type in (N'U'))
BEGIN
CREATE TABLE [GBS].[Fee](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL CONSTRAINT [DF_GBS_Fee_ImportDate]  DEFAULT (getdate()),
	[FeeId] [int] NOT NULL,
	[BudgetId] [int] NOT NULL,
	[PropertyFundId] [int] NOT NULL,
	[AllocationSubRegionGlobalRegionId] [int] NOT NULL,
	[GLGlobalAccountId] [int] NOT NULL,
	[CurrencyCode] [char](3) NOT NULL,
	[Description] [varchar](300) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[IsImported] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[DateRangeSpreadId] [int] NOT NULL,
	[OriginalFeeId] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [GBS].[DisputeStatus]    Script Date: 01/17/2011 14:15:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GBS].[DisputeStatus]') AND type in (N'U'))
BEGIN
CREATE TABLE [GBS].[DisputeStatus](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL CONSTRAINT [DF_GBS_DisputeStatus_ImportDate]  DEFAULT (getdate()),
	[DisputeStatusId] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BudgetsToProcess]    Script Date: 01/17/2011 14:15:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BudgetsToProcess]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[BudgetsToProcess](
	[ImportBatchId] [int] NOT NULL,
	[SourceSystemName] [varchar](50) NOT NULL,
	[BudgetId] [int] NOT NULL,
	[ImportBudgetFromSourceSystem] [bit] NOT NULL,
	[IsReforecast] [bit] NOT NULL,
	[SnapshotId] [int] NOT NULL,
	[ImportSnapshotFromSourceSystem] [bit] NOT NULL,
	[InsertedDate] [datetime]  NOT NULL CONSTRAINT [DF_BudgetsToProcess_InsertedDate]  DEFAULT (getdate()),
	[BudgetProcessedIntoWarehouse] [bit] NULL,
	[DateBudgetProcessedIntoWarehouse] [datetime] NULL,
 CONSTRAINT [PK_SourceSystemId_BudgetId] PRIMARY KEY CLUSTERED 
(
	[SourceSystemName] ASC,
	[BudgetId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [GBS].[Budget]    Script Date: 01/17/2011 14:15:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GBS].[Budget]') AND type in (N'U'))
BEGIN
CREATE TABLE [GBS].[Budget](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL CONSTRAINT [DF_GBS_Budget_ImportDate]  DEFAULT (getdate()),
	[BudgetId] [int] NOT NULL,
	[BudgetAllocationSetId] [int] NOT NULL,
	[BudgetReportGroupPeriodId] [int] NOT NULL,
	[BudgetExchangeRateId] [int] NOT NULL,
	[BudgetStatusId] [int] NOT NULL,
	[CreatorStaffId] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[HealthyTensionStartDate] [datetime] NOT NULL,
	[HealthyTensionEndDate] [datetime] NOT NULL,
	[LastLockedDate] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[PriorBudgetId] [int] NULL,
	[IsReforecast] [bit] NOT NULL,
	[CopiedFromBudgetId] [int] NULL,
	[ImportBudgetIntoGR] [bit] NOT NULL,
	[LastImportBudgetIntoGRDate] [datetime] NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
