------------------------
-- Gdm.GlAccountMapping
------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GlAccountMapping_ImportDate]') AND type = 'D')
BEGIN
	ALTER TABLE [Gdm].[GlAccountMapping] DROP CONSTRAINT [DF_GlAccountMapping_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GlAccountMapping_UpdatedDate]') AND type = 'D')
BEGIN
	ALTER TABLE [Gdm].[GlAccountMapping] DROP CONSTRAINT [DF_GlAccountMapping_UpdatedDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GlAccountMapping_IsDeleted]') AND type = 'D')
BEGIN
	ALTER TABLE [Gdm].[GlAccountMapping] DROP CONSTRAINT [DF_GlAccountMapping_IsDeleted]
END

GO

USE [GrReportingStaging]
GO

-- Script Date: 07/02/2010 08:05:08
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GlAccountMapping]') AND type in (N'U'))
	DROP TABLE [Gdm].[GlAccountMapping]
GO

-----------------------
-- Gdm.GlobalGlAccount
-----------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GlobalGlAccount_ImportDate]') AND type = 'D')
BEGIN
	ALTER TABLE [Gdm].[GlobalGlAccount] DROP CONSTRAINT [DF_GlobalGlAccount_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GlobalGlAccount_AccountType]') AND type = 'D')
BEGIN
	ALTER TABLE [Gdm].[GlobalGlAccount] DROP CONSTRAINT [DF_GlobalGlAccount_AccountType]
END

GO

USE [GrReportingStaging]
GO

-- Script Date: 07/02/2010 09:10:13
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalGlAccount]') AND type in (N'U'))
	DROP TABLE [Gdm].[GlobalGlAccount]
GO

-------------------------------
-- Gdm.AllocationRegionMapping
-------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AllocationRegionMapping_ImportDate]') AND type = 'D')
BEGIN
	ALTER TABLE [Gdm].[AllocationRegionMapping] DROP CONSTRAINT [DF_AllocationRegionMapping_ImportDate]
END

GO

USE [GrReportingStaging]
GO

-- Script Date: 07/02/2010 09:10:40
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[AllocationRegionMapping]') AND type in (N'U'))
	DROP TABLE [Gdm].[AllocationRegionMapping]
GO

--------------------------------
-- Gdm.OriginatingRegionMapping
--------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_OriginatingRegionMapping_ImportDate]') AND type = 'D')
BEGIN
	ALTER TABLE [Gdm].[OriginatingRegionMapping] DROP CONSTRAINT [DF_OriginatingRegionMapping_ImportDate]
END

GO

USE [GrReportingStaging]
GO

/****** Object:  Table [Gdm].[OriginatingRegionMapping]    Script Date: 07/02/2010 09:11:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[OriginatingRegionMapping]') AND type in (N'U'))
	DROP TABLE [Gdm].[OriginatingRegionMapping]
GO

------------------------------
-- Gdm.MajorGlAccountCategory
------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MajorGlAccountCategory_ImportDate]') AND type = 'D')
BEGIN
	ALTER TABLE [Gdm].[MajorGlAccountCategory] DROP CONSTRAINT [DF_MajorGlAccountCategory_ImportDate]
END

GO

USE [GrReportingStaging]
GO

-- Script Date: 07/02/2010 09:11:21
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[MajorGlAccountCategory]') AND type in (N'U'))
	DROP TABLE [Gdm].[MajorGlAccountCategory]
GO

------------------------------
-- Gdm.MinorGlAccountCategory
------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MinorGlAccountCategory_ImportDate]') AND type = 'D')
BEGIN
	ALTER TABLE [Gdm].[MinorGlAccountCategory] DROP CONSTRAINT [DF_MinorGlAccountCategory_ImportDate]
END

GO

USE [GrReportingStaging]
GO

-- Script Date: 07/02/2010 09:11:34
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[MinorGlAccountCategory]') AND type in (N'U'))
	DROP TABLE [Gdm].[MinorGlAccountCategory]
GO

---------------------------------------
-- Gdm.GlobalGlAccountCategoryHierarchy
---------------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GlobalGlAccountCategoryHieranchy_ImportDate]') AND type = 'D')
BEGIN
	ALTER TABLE [Gdm].[GlobalGlAccountCategoryHierarchy] DROP CONSTRAINT [DF_GlobalGlAccountCategoryHieranchy_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GlobalGlAccountCategoryHieranchy_AccountType]') AND type = 'D')
BEGIN
	ALTER TABLE [Gdm].[GlobalGlAccountCategoryHierarchy] DROP CONSTRAINT [DF_GlobalGlAccountCategoryHieranchy_AccountType]
END

GO

USE [GrReportingStaging]
GO

-- Script Date: 07/02/2010 09:11:50
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalGlAccountCategoryHierarchy]') AND type in (N'U'))
	DROP TABLE [Gdm].[GlobalGlAccountCategoryHierarchy]
GO

--------------------------------------------
-- Gdm.GlobalGlAccountCategoryHierarchyGroup
--------------------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GlobalGlAccountCategoryHieranchyGroup_ImportDate]') AND type = 'D')
BEGIN
	ALTER TABLE [Gdm].[GlobalGlAccountCategoryHierarchyGroup] DROP CONSTRAINT [DF_GlobalGlAccountCategoryHieranchyGroup_ImportDate]
END

GO

USE [GrReportingStaging]
GO

/****** Object:  Table [Gdm].[GlobalGlAccountCategoryHierarchyGroup]    Script Date: 07/02/2010 09:12:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalGlAccountCategoryHierarchyGroup]') AND type in (N'U'))
	DROP TABLE [Gdm].[GlobalGlAccountCategoryHierarchyGroup]
GO

---------------------
-- Gdm.ProjectRegion
---------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ProjectRegion_ImportDate]') AND type = 'D')
BEGIN
	ALTER TABLE [Gdm].[ProjectRegion] DROP CONSTRAINT [DF_ProjectRegion_ImportDate]
END

GO

USE [GrReportingStaging]
GO

/****** Object:  Table [Gdm].[ProjectRegion]    Script Date: 07/02/2010 09:12:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ProjectRegion]') AND type in (N'U'))
	DROP TABLE [Gdm].[ProjectRegion]
GO

---------------------------------
-- Gdm.GRBudgetReportGroupPeriod
---------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GRBudgetReportGroupPeriod_ImportDate]') AND type = 'D')
BEGIN
	ALTER TABLE [Gdm].[GRBudgetReportGroupPeriod] DROP CONSTRAINT [DF_GRBudgetReportGroupPeriod_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GRBudgetReportGroupPeriod_InsertedDate]') AND type = 'D')
BEGIN
	ALTER TABLE [Gdm].[GRBudgetReportGroupPeriod] DROP CONSTRAINT [DF_GRBudgetReportGroupPeriod_InsertedDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_GRBudgetReportGroupPeriod_UpdatedDate]') AND type = 'D')
BEGIN
	ALTER TABLE [Gdm].[GRBudgetReportGroupPeriod] DROP CONSTRAINT [DF_GRBudgetReportGroupPeriod_UpdatedDate]
END

GO

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GRBudgetReportGroupPeriod]') AND type in (N'U'))
	DROP TABLE [Gdm].[GRBudgetReportGroupPeriod]
GO

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Allocatio__Impor__12BADEFE]') AND type = 'D')
BEGIN
	ALTER TABLE [Gdm].[AllocationRegionProjectRegion] DROP CONSTRAINT [DF__Allocatio__Impor__12BADEFE]
END

GO

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[AllocationRegionProjectRegion]') AND type in (N'U'))
BEGIN
	DROP TABLE [Gdm].[AllocationRegionProjectRegion]
END

GO

---------------------------------
-- Gdm.ExchangeRate
---------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ExchangeRate_ImportDate]') AND type = 'D')
BEGIN
	ALTER TABLE [Gdm].[ExchangeRate] DROP CONSTRAINT [DF_ExchangeRate_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ExchangeRate_InsertedDate]') AND type = 'D')
BEGIN
	ALTER TABLE [Gdm].[ExchangeRate] DROP CONSTRAINT [DF_ExchangeRate_InsertedDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ExchangeRate_UpdatedDate]') AND type = 'D')
BEGIN
	ALTER TABLE [Gdm].[ExchangeRate] DROP CONSTRAINT [DF_ExchangeRate_UpdatedDate]
END

GO

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ExchangeRate]') AND type in (N'U'))
	DROP TABLE [Gdm].[ExchangeRate]
GO

---------------------------------
-- Gdm.ExchangeRateDetail
---------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ExchangeRateDetail_ImportDate]') AND type = 'D')
BEGIN
	ALTER TABLE [Gdm].[ExchangeRateDetail] DROP CONSTRAINT [DF_ExchangeRateDetail_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ExchangeRateDetail_InsertedDate]') AND type = 'D')
BEGIN
	ALTER TABLE [Gdm].[ExchangeRateDetail] DROP CONSTRAINT [DF_ExchangeRateDetail_InsertedDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ExchangeRateDetail_UpdatedDate]') AND type = 'D')
BEGIN
	ALTER TABLE [Gdm].[ExchangeRateDetail] DROP CONSTRAINT [DF_ExchangeRateDetail_UpdatedDate]
END

GO

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ExchangeRateDetail]') AND type in (N'U'))
	DROP TABLE [Gdm].[ExchangeRateDetail]

GO