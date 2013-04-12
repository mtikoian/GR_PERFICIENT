--=========================================================================================
----------------------------------- CREATE NEW GDM TABLES ---------------------------------
--=========================================================================================

--------------------------------------------------------------
-- Gdm.GLGlobalAccountGlAccount (formerly Gr.GlAccountMapping)
--------------------------------------------------------------

USE [GrReportingStaging]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLGlobalAccountGLAccount]') AND type in (N'U'))
	DROP TABLE [Gdm].[GLGlobalAccountGLAccount]
GO

USE [GrReportingStaging]
GO
-- Script Date: 06/29/2010 08:45:25
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[GLGlobalAccountGLAccount](
	[ImportKey] int IDENTITY(1,1) NOT NULL,
	[ImportBatchId] int NOT NULL,
	[ImportDate] datetime NOT NULL DEFAULT (GETDATE()),
	[GLGlobalAccountGLAccountId] int NOT NULL,
	[GLGlobalAccountId] int NOT NULL,
	[SourceCode] char(2) NOT NULL,
	[Code] varchar(12) NOT NULL,
	[Name] nvarchar(50) NOT NULL,
	[Description] nvarchar(255) NOT NULL,
	[PreGlobalAccountCode] varchar(50) NULL,
	[IsActive] bit NOT NULL,
	--[Version] timestamp NOT NULL,
	[InsertedDate] datetime NOT NULL,
	[UpdatedDate] datetime NOT NULL,
	[UpdatedByStaffId] int NOT NULL )

GO

----------------------------------------------------
-- Gdm.GLGlobalAccount (formerly Gr.GlobalGlAccount)
----------------------------------------------------

USE [GrReportingStaging]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLGlobalAccount]') AND type in (N'U'))
	DROP TABLE [Gdm].[GLGlobalAccount]
GO

USE [GrReportingStaging]
GO
-- Script Date: 06/29/2010 08:52:49
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[GLGlobalAccount](
	[ImportKey] int IDENTITY(1,1) NOT NULL,
	[ImportBatchId] int NOT NULL,
	[ImportDate] datetime NOT NULL DEFAULT (GETDATE()),
	[GLGlobalAccountId] int NOT NULL,
	[ActivityTypeId] int NULL, -- changed from NOT NULL
	[GLStatutoryTypeId] int NULL,
	[ParentGLGlobalAccountId] int NULL,
	[Code] varchar(10) NOT NULL,
	[Name] nvarchar(150) NOT NULL,
	[Description] varchar(255) NOT NULL,
	[IsGR] bit NOT NULL,
	[IsGbs] bit NOT NULL,
	[IsRegionalOverheadCost] bit NOT NULL,
	[IsActive] bit NOT NULL,
	--[Version] timestamp NOT NULL,
	[InsertedDate] datetime NOT NULL,
	[UpdatedDate] datetime NOT NULL,
	[UpdatedByStaffId] int NOT NULL )

GO

-----------------------------------------------
-- Gdm.ActivityType (formerly dbo.ActivityType)
-----------------------------------------------

USE [GrReportingStaging]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ActivityType]') AND type in (N'U'))
	DROP TABLE [Gdm].[ActivityType]
GO

USE [GrReportingStaging]
GO
-- Script Date: 06/29/2010 08:53:22
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[ActivityType](
	[ImportKey] int IDENTITY(1,1) NOT NULL,
	[ImportBatchId] int NOT NULL,
	[ImportDate] datetime NOT NULL DEFAULT (GETDATE()),
	[ActivityTypeId] int NOT NULL,
	[Code] varchar(10) NOT NULL,
	[Name] varchar(50) NOT NULL,
	[GLAccountSuffix] char(2) NOT NULL,
	[IsEscalatable] bit NOT NULL,
	[IsActive] bit NOT NULL,
	--[Version] timestamp NOT NULL,
	[InsertedDate] datetime NOT NULL,
	[UpdatedDate] datetime NOT NULL,
	[UpdatedByStaffId] int NOT NULL,
	[ActivityTypeCode]  AS (CONVERT([varchar](10),[Code],0)),
	[GLSuffix]  AS (CONVERT([char](2),[GLAccountSuffix],0)) )
	
GO	

----------------------------------------------
-- Gdm.GlobalRegion (formerly Gr.GlobalRegion)
----------------------------------------------

USE [GrReportingStaging]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalRegion]') AND type in (N'U'))
	DROP TABLE [Gdm].[GlobalRegion]
GO

USE [GrReportingStaging]
GO
-- Script Date: 06/29/2010 08:53:47
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[GlobalRegion](
	[ImportKey] int IDENTITY(1,1) NOT NULL,
	[ImportBatchId] int NOT NULL,
	[ImportDate] datetime NOT NULL DEFAULT (GETDATE()),
	[GlobalRegionId] int NOT NULL,
	[ParentGlobalRegionId] int NULL,
	[CountryId] int NULL,
	[Code] varchar(10) NOT NULL,
	[Name] varchar(50) NOT NULL,
	[IsAllocationRegion] bit NOT NULL,
	[IsOriginatingRegion] bit NOT NULL,
	[DefaultCurrencyCode] char(3) NOT NULL,
	[DefaultCorporateSourceCode] char(2) NOT NULL,
	[ProjectCodePortion] varchar(2) NOT NULL,
	[IsActive] bit NOT NULL,
	--[Version] timestamp NOT NULL,
	[InsertedDate] datetime NOT NULL,
	[UpdatedDate] datetime NOT NULL,
	[UpdatedByStaffId] int NOT NULL )

GO

--------------------------------------------------------------------------
-- Gdm.AllocationRegionProjectRegion (formerly Gr.AllocationRegionMapping)
--------------------------------------------------------------------------

USE [GrReportingStaging]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[AllocationRegionProjectRegion]') AND type in (N'U'))
	DROP TABLE [Gdm].[AllocationRegionProjectRegion]
GO

USE [GrReportingStaging]
GO
-- Script Date: 06/29/2010 08:55:16
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Gdm].[AllocationRegionProjectRegion](
	[ImportKey] int IDENTITY(1,1) NOT NULL,
	[ImportBatchId] int NOT NULL,
	[ImportDate] datetime NOT NULL DEFAULT (GETDATE()),
	[AllocationRegionProjectRegionId] int NOT NULL,
	[GlobalRegionId] int NOT NULL,
	[ProjectRegionId] int NOT NULL,
	[InsertedDate] datetime NOT NULL,
	[UpdatedDate] datetime NOT NULL,
	[UpdatedByStaffId] int NOT NULL,
	[IsDeleted] bit NOT NULL )
GO

-----------------------------------------------
-- Gdm.PropertyFund (formerly dbo.PropertyFund)
-----------------------------------------------

USE [GrReportingStaging]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[PropertyFund]') AND type in (N'U'))
	DROP TABLE [Gdm].[PropertyFund]
GO

USE [GrReportingStaging]
GO
-- Script Date: 06/29/2010 08:55:44
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[PropertyFund](
	[ImportKey] int IDENTITY(1,1) NOT NULL,
	[ImportBatchId] int NOT NULL,
	[ImportDate] datetime NOT NULL DEFAULT (GETDATE()),
	[PropertyFundId] int NOT NULL,
	[RelatedFundId] int NULL,
	[EntityTypeId] int NOT NULL,
	[AllocationSubRegionGlobalRegionId] int NOT NULL,
	[BudgetOwnerStaffId] int NOT NULL,
	[RegionalOwnerStaffId] int NOT NULL,
	[DefaultGLTranslationSubTypeId] int NULL,
	[Name] varchar(100) NOT NULL,
	[IsReportingEntity] bit NOT NULL,
	[IsPropertyFund] bit NOT NULL,
	[IsActive] bit NOT NULL,
	--[Version] timestamp NOT NULL,
	[InsertedDate] datetime NOT NULL,
	[UpdatedDate] datetime NOT NULL,
	[UpdatedByStaffId] int NOT NULL )

GO

-----------------------------------------------
-- Gdm.ReportingEntity (new addition)
-----------------------------------------------

USE [GrReportingStaging]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ReportingEntity]') AND type in (N'U'))
	DROP TABLE [Gdm].[ReportingEntity]
GO

USE [GrReportingStaging]
GO
-- Script Date: 06/29/2010 08:55:44
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[ReportingEntity](
	[ImportKey] int IDENTITY(1,1) NOT NULL,
	[ImportBatchId] int NOT NULL,
	[ImportDate] datetime NOT NULL DEFAULT (GETDATE()),
	[ReportingEntityId] int NOT NULL,
	[RelatedFundId] int NULL,
	[EntityTypeId] int NOT NULL,
	[AllocationSubRegionGlobalRegionId] int NOT NULL,
	[BudgetOwnerStaffId] int NOT NULL,
	[RegionalOwnerStaffId] int NOT NULL,
	[DefaultGLTranslationSubTypeId] int NULL,
	[Name] varchar(100) NOT NULL,
	[IsReportingEntity] bit NOT NULL,
	[IsPropertyFund] bit NOT NULL,
	[IsActive] bit NOT NULL,
	--[Version] timestamp NOT NULL,
	[InsertedDate] datetime NOT NULL,
	[UpdatedDate] datetime NOT NULL,
	[UpdatedByStaffId] int NOT NULL )

GO

---------------------------------------------------------------------------
-- Gdm.ReportingEntityCorporateDepartment (formerly Gr.PropertyFundMapping)
---------------------------------------------------------------------------

USE [GrReportingStaging]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ReportingEntityCorporateDepartment]') AND type in (N'U'))
	DROP TABLE [Gdm].[ReportingEntityCorporateDepartment]
GO

USE [GrReportingStaging]
GO
-- Script Date: 06/29/2010 08:56:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[ReportingEntityCorporateDepartment](
	[ImportKey] int IDENTITY(1,1) NOT NULL,
	[ImportBatchId] int NOT NULL,
	[ImportDate] datetime NOT NULL DEFAULT (GETDATE()),
	[ReportingEntityCorporateDepartmentId] int NOT NULL,
	[PropertyFundId] int NOT NULL,
	[SourceCode] char(2) NOT NULL,
	[CorporateDepartmentCode] char(6) NOT NULL,
	[InsertedDate] datetime NOT NULL,
	[UpdatedDate] datetime NOT NULL,
	[UpdatedByStaffId] int NOT NULL,
	[IsDeleted] bit NOT NULL )
	
GO

----------------------------------------------------------------------
-- Gdm.ReportingEntityPropertyEntity (formerly Gr.PropertyFundMapping)
----------------------------------------------------------------------

USE [GrReportingStaging]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ReportingEntityPropertyEntity]') AND type in (N'U'))
	DROP TABLE [Gdm].[ReportingEntityPropertyEntity]
GO

USE [GrReportingStaging]
GO
-- Script Date: 06/29/2010 08:57:01
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[ReportingEntityPropertyEntity](
	[ImportKey] int IDENTITY(1,1) NOT NULL,
	[ImportBatchId] int NOT NULL,
	[ImportDate] datetime NOT NULL DEFAULT (GETDATE()),
	[ReportingEntityPropertyEntityId] int NOT NULL,
	[PropertyFundId] int NOT NULL,
	[SourceCode] char(2) NOT NULL,
	[PropertyEntityCode] char(6) NOT NULL,
	[InsertedDate] datetime NOT NULL,
	[UpdatedDate] datetime NOT NULL,
	[UpdatedByStaffId] int NOT NULL,
	[IsDeleted] bit NOT NULL )

GO

------------------------------------------------------------------------------
-- Gdm.OriginatingRegionCorporateEntity (formerly Gr.OriginatingRegionMapping)
------------------------------------------------------------------------------

USE [GrReportingStaging]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[OriginatingRegionCorporateEntity]') AND type in (N'U'))
	DROP TABLE [Gdm].[OriginatingRegionCorporateEntity]
GO

USE [GrReportingStaging]
GO
-- Script Date: 06/29/2010 08:57:36
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[OriginatingRegionCorporateEntity](
	[ImportKey] int IDENTITY(1,1) NOT NULL,
	[ImportBatchId] int NOT NULL,
	[ImportDate] datetime NOT NULL DEFAULT (GETDATE()),
	[OriginatingRegionCorporateEntityId] int NOT NULL,
	[GlobalRegionId] int NOT NULL,
	[CorporateEntityCode] varchar(10) NOT NULL,
	[SourceCode] char(2) NOT NULL,
	[IsDeleted] bit NOT NULL,
	[InsertedDate] datetime NOT NULL,
	[UpdatedDate] datetime NOT NULL,
	[UpdatedByStaffId] int NOT NULL )

GO

---------------------------------------------------------------------------------
-- Gdm.OriginatingRegionPropertyDepartment (formerly Gr.OriginatingRegionMapping)
---------------------------------------------------------------------------------

USE [GrReportingStaging]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[OriginatingRegionPropertyDepartment]') AND type in (N'U'))
	DROP TABLE [Gdm].[OriginatingRegionPropertyDepartment]
GO

USE [GrReportingStaging]
GO
-- Script Date: 06/29/2010 08:58:06
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[OriginatingRegionPropertyDepartment](
	[ImportKey] int IDENTITY(1,1) NOT NULL,
	[ImportBatchId] int NOT NULL,
	[ImportDate] datetime NOT NULL DEFAULT (GETDATE()),
	[OriginatingRegionPropertyDepartmentId] int NOT NULL,
	[GlobalRegionId] int NOT NULL,
	[PropertyDepartmentCode] varchar(10) NOT NULL,
	[SourceCode] char(2) NOT NULL,
	[IsDeleted] bit NOT NULL,
	[InsertedDate] datetime NOT NULL,
	[UpdatedDate] datetime NOT NULL,
	[UpdatedByStaffId] int NOT NULL )

GO

------------------------------------------------------------
-- Gdm.GLMajorCategory (formerly dbo.MajorGlAccountCategory)
------------------------------------------------------------

USE [GrReportingStaging]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLMajorCategory]') AND type in (N'U'))
	DROP TABLE [Gdm].[GLMajorCategory]
GO

USE [GrReportingStaging]
GO
-- Script Date: 06/29/2010 08:59:06
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[GLMajorCategory](
	[ImportKey] int IDENTITY(1,1) NOT NULL,
	[ImportBatchId] int NOT NULL,
	[ImportDate] datetime NOT NULL DEFAULT (GETDATE()),
	[GLMajorCategoryId] int NOT NULL,
	[GLTranslationSubTypeId] int NOT NULL,
	[Name] varchar(50) NOT NULL,
	[IsActive] bit NOT NULL,
	--[Version] timestamp NOT NULL,
	[InsertedDate] datetime NOT NULL,
	[UpdatedDate] datetime NOT NULL,
	[UpdatedByStaffId] int NOT NULL )

GO

------------------------------------------------------------
-- Gdm.GLMinorCategory (formerly dbo.MinorGlAccountCategory)
------------------------------------------------------------

USE [GrReportingStaging]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLMinorCategory]') AND type in (N'U'))
	DROP TABLE [Gdm].[GLMinorCategory]
GO

USE [GrReportingStaging]
GO
-- Script Date: 06/29/2010 08:59:36
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[GLMinorCategory](
	[ImportKey] int IDENTITY(1,1) NOT NULL,
	[ImportBatchId] int NOT NULL,
	[ImportDate] datetime NOT NULL DEFAULT (GETDATE()),
	[GLMinorCategoryId] int NOT NULL,
	[GLMajorCategoryId] int NOT NULL,
	[Name] varchar(100) NOT NULL,
	[IsActive] bit NOT NULL,
	--[Version] timestamp NOT NULL,
	[InsertedDate] datetime NOT NULL,
	[UpdatedDate] datetime NOT NULL,
	[UpdatedByStaffId] int NOT NULL )

GO

-------------------------------------------
-- Gdm.EntityType (formerly dbo.EntityType)
-------------------------------------------

USE [GrReportingStaging]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[EntityType]') AND type in (N'U'))
	DROP TABLE [Gdm].[EntityType]
GO

USE [GrReportingStaging]
GO
-- Script Date: 06/29/2010 09:00:02
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[EntityType](
	[ImportKey] int IDENTITY(1,1) NOT NULL,
	[ImportBatchId] int NOT NULL,
	[ImportDate] datetime NOT NULL DEFAULT (GETDATE()),
	[EntityTypeId] int NOT NULL,
	[Name] varchar(50) NOT NULL,
	[ProjectCodePortion] char(1) NULL,
	[Description] varchar(100) NOT NULL,
	[IsActive] bit NOT NULL,
	--[Version] timestamp NOT NULL,
	[InsertedDate] datetime NOT NULL,
	[UpdatedDate] datetime NOT NULL,
	[UpdatedByStaffId] int NOT NULL )

GO

-----------------------------------------------------
-- Gdm.GLGlobalAccountTranslationSubType (formerly ?)
-----------------------------------------------------

USE [GrReportingStaging]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLGlobalAccountTranslationSubType]') AND type in (N'U'))
	DROP TABLE [Gdm].[GLGlobalAccountTranslationSubType]
GO

USE [GrReportingStaging]
GO
-- Script Date: 06/29/2010 09:00:02
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[GLGlobalAccountTranslationSubType](
	[ImportKey] int IDENTITY(1,1) NOT NULL,
	[ImportBatchId] int NOT NULL,
	[ImportDate] datetime NOT NULL DEFAULT (GETDATE()),
	[GLGlobalAccountTranslationSubTypeId] int NOT NULL,
	[GLGlobalAccountId] int NOT NULL,
	[GLTranslationSubTypeId] int NOT NULL,
	[GLMinorCategoryId] int NOT NULL,
	[PostingPropertyGLAccountCode] varchar(14) NULL,
	[IsActive] bit NOT NULL,
	--[Version] timestamp NOT NULL,
	[InsertedDate] datetime NOT NULL,
	[UpdatedDate] datetime NOT NULL,
	[UpdatedByStaffId] int NOT NULL )

GO

--------------------------------------------------
-- Gdm.GLGlobalAccountTranslationType (formerly ?)
--------------------------------------------------

USE [GrReportingStaging]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLGlobalAccountTranslationType]') AND type in (N'U'))
	DROP TABLE [Gdm].[GLGlobalAccountTranslationType]
GO

USE [GrReportingStaging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[GLGlobalAccountTranslationType](
	[ImportKey] int IDENTITY(1,1) NOT NULL,
	[ImportBatchId] int NOT NULL,
	[ImportDate] datetime NOT NULL DEFAULT (GETDATE()),
	[GLGlobalAccountTranslationTypeId] int NOT NULL,
	[GLGlobalAccountId] int NOT NULL,
	[GLTranslationTypeId] int NOT NULL,
	[GLAccountTypeId] int NOT NULL,
	[GLAccountSubTypeId] int NOT NULL,
	[IsActive] bit NOT NULL,
	--[Version] timestamp NOT NULL,
	[InsertedDate] datetime NOT NULL,
	[UpdatedDate] datetime NOT NULL,
	[UpdatedByStaffId] int NOT NULL )
	
GO

----------------------
-- Gdm.GLTranslationType
----------------------

USE [GrReportingStaging]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLTranslationType]') AND type in (N'U'))
	DROP TABLE [Gdm].[GLTranslationType]
GO

USE [GrReportingStaging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[GLTranslationType](
	[ImportKey] int IDENTITY(1,1) NOT NULL,
	[ImportBatchId] int NOT NULL,
	[ImportDate] datetime NOT NULL DEFAULT (GETDATE()),
	[GLTranslationTypeId] int NOT NULL,
	[Code] varchar(10) NOT NULL,
	[Name] varchar(50) NOT NULL,
	[Description] varchar(255) NOT NULL,
	[IsActive] bit NOT NULL,
	--[Version] timestamp NOT NULL,
	[InsertedDate] datetime NOT NULL,
	[UpdatedDate] datetime NOT NULL,
	[UpdatedByStaffId] int NOT NULL )

GO

----------------------
-- Gdm.GLTranslationSubType
----------------------

USE [GrReportingStaging]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLTranslationSubType]') AND type in (N'U'))
	DROP TABLE [Gdm].[GLTranslationSubType]
GO

USE [GrReportingStaging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[GLTranslationSubType](
	[ImportKey] int IDENTITY(1,1) NOT NULL,
	[ImportBatchId] int NOT NULL,
	[ImportDate] datetime NOT NULL DEFAULT (GETDATE()),
	[GLTranslationSubTypeId] int NOT NULL,
	[GLTranslationTypeId] int NOT NULL,
	[Code] varchar(10) NOT NULL,
	[Name] varchar(50) NOT NULL,
	[IsActive] bit NOT NULL,
	--[Version] timestamp NOT NULL,
	[InsertedDate] datetime NOT NULL,
	[UpdatedDate] datetime NOT NULL,
	[UpdatedByStaffId] int NOT NULL,
	[IsGRDefault] bit NOT NULL )
	
GO

--------------------------------------------------
-- Gdm.AllocationRegion (formerly ?ProjectRegion?)
--------------------------------------------------

USE [GrReportingStaging]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[AllocationRegion]') AND type in (N'U'))
	DROP TABLE [Gdm].[AllocationRegion]
GO

USE [GrReportingStaging]
GO
-- Script Date: 06/29/2010 09:00:02
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[AllocationRegion](
	[ImportKey] int IDENTITY(1,1) NOT NULL,
	[ImportBatchId] int NOT NULL,
	[ImportDate] datetime NOT NULL DEFAULT (GETDATE()),
	[AllocationRegionGlobalRegionId] int NOT NULL,
	Code varchar(10) NOT NULL,
	[Name] varchar(50) NOT NULL,
	ProjectCodePortion varchar(2) NOT NULL,
	DefaultCurrencyCode char(3) NULL,
	IsActive bit NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	UpdatedByStaffId int NOT NULL )

GO

-----------------------------------------------------
-- Gdm.AllocationSubRegion (formerly ?ProjectRegion?)
-----------------------------------------------------

USE [GrReportingStaging]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[AllocationSubRegion]') AND type in (N'U'))
	DROP TABLE [Gdm].[AllocationSubRegion]
GO

USE [GrReportingStaging]
GO
-- Script Date: 06/29/2010 09:00:02
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[AllocationSubRegion](
	[ImportKey] int IDENTITY(1,1) NOT NULL,
	[ImportBatchId] int NOT NULL,
	[ImportDate] datetime NOT NULL DEFAULT (GETDATE()),
	[AllocationSubRegionGlobalRegionId] int NOT NULL,
	[Code] varchar(10) NOT NULL,
	[Name] varchar(50) NOT NULL,
	[ProjectCodePortion] varchar(2) NOT NULL,
	AllocationRegionGlobalRegionId int NULL,
	DefaultCurrencyCode char(3) NOT NULL,
	CountryId int NULL,
	IsActive bit NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	UpdatedByStaffId int NOT NULL )

GO

--=========================================================================================
------------------------- CREATE NEW TAPAS BUDGETING TABLES----------------------
--=========================================================================================

--------------------------
-- Gdm.BudgetExchangeRate
--------------------------

IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[Gdm].[BudgetExchangeRate]') AND TYPE in (N'U'))
	DROP TABLE [Gdm].[BudgetExchangeRate]
GO

USE [GrReportingStaging]
GO

-- Script Date: 07/01/2010 09:57:32
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[BudgetExchangeRate](
	[ImportKey] int IDENTITY(1,1) NOT NULL,
	[ImportBatchId] int NOT NULL,
	[ImportDate] datetime NOT NULL DEFAULT (GETDATE()),
	[BudgetExchangeRateId] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[StartPeriod] [int] NOT NULL,
	[EndPeriod] [int] NOT NULL,
	[IsLocked] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	--[Version] [timestamp] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL )

GO

-------------------------------
-- Gdm.BudgetExchangeRateDetail
-------------------------------

IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[Gdm].[BudgetExchangeRateDetail]') AND TYPE in (N'U'))
	DROP TABLE [Gdm].[BudgetExchangeRateDetail]
GO

USE [GrReportingStaging]
GO

-- Script Date: 07/01/2010 10:03:30
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[BudgetExchangeRateDetail](
	[ImportKey] int IDENTITY(1,1) NOT NULL,
	[ImportBatchId] int NOT NULL,
	[ImportDate] datetime NOT NULL DEFAULT (GETDATE()),
	[BudgetExchangeRateDetailId] [int] NOT NULL,
	[BudgetExchangeRateId] [int] NOT NULL,
	[CurrencyCode] [char](3) NOT NULL,
	[Period] [int] NOT NULL,
	[Rate] [decimal](18, 12) NOT NULL,
	--[Version] [timestamp] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL )

GO

-------------------------------
-- Gdm.BudgetReportGroupPeriod
-------------------------------

IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[Gdm].[BudgetReportGroupPeriod]') AND TYPE in (N'U'))
	DROP TABLE [Gdm].[BudgetReportGroupPeriod]
GO

USE [GrReportingStaging]
GO

-- Script Date: 07/01/2010 10:06:48
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Gdm].[BudgetReportGroupPeriod](
	[ImportKey] int IDENTITY(1,1) NOT NULL,
	[ImportBatchId] int NOT NULL,
	[ImportDate] datetime NOT NULL DEFAULT (GETDATE()),
	[BudgetReportGroupPeriodId] [int] NOT NULL,
	[BudgetExchangeRateId] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[Period] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	--[Version] [timestamp] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL )
	
GO


--=====================================================================================================

--------------------------------------------------
-- Gdm.GLAccountType 
--------------------------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLAccountType]') AND type in (N'U'))
DROP TABLE [Gdm].[GLAccountType]
GO

USE [GrReportingStaging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[GLAccountType](
	[ImportKey] int IDENTITY(1,1) NOT NULL,
	[ImportBatchId] int NOT NULL,
	[ImportDate] datetime NOT NULL DEFAULT (GETDATE()),
	[GLAccountTypeId] int NOT NULL,
	[GLTranslationTypeId] int NOT NULL,
	[Code] varchar(10) NOT NULL,
	[Name] varchar(50) NOT NULL,
	[IsActive] bit NOT NULL,
	--[Version] timestamp NOT NULL,
	[InsertedDate] datetime NOT NULL,
	[UpdatedDate] datetime NOT NULL,
	[UpdatedByStaffId] int NOT NULL )
	
GO

--------------------------------------------------
-- Gdm.GLAccountSubType 
--------------------------------------------------
USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLAccountSubType]') AND type in (N'U'))
DROP TABLE [Gdm].[GLAccountSubType]
GO

USE [GrReportingStaging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[GLAccountSubType](
	[ImportKey] int IDENTITY(1,1) NOT NULL,
	[ImportBatchId] int NOT NULL,
	[ImportDate] datetime NOT NULL DEFAULT (GETDATE()),
	[GLAccountSubTypeId] int NOT NULL,
	[GLTranslationTypeId] int NOT NULL,
	[Code] varchar(10) NOT NULL,
	[Name] varchar(50) NOT NULL,
	[IsActive] bit NOT NULL,
	--[Version] timestamp NOT NULL,
	[InsertedDate] datetime NOT NULL,
	[UpdatedDate] datetime NOT NULL,
	[UpdatedByStaffId] int NOT NULL )

GO

