USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ManageType_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[ManageType] DROP CONSTRAINT [DF_ManageType_ImportDate]
END

GO

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ManageType]') AND type in (N'U'))
DROP TABLE [Gdm].[ManageType]
GO

USE [GrReportingStaging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[ManageType](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ManageTypeId] [int] NOT NULL,
	[Code] [varchar](10) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [Gdm].[ManageType] ADD  CONSTRAINT [DF_ManageType_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

------------------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ManagePropertyEntity_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[ManagePropertyEntity] DROP CONSTRAINT [DF_ManagePropertyEntity_ImportDate]
END

GO

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ManagePropertyEntity]') AND type in (N'U'))
DROP TABLE [Gdm].[ManagePropertyEntity]
GO

USE [GrReportingStaging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[ManagePropertyEntity](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ManagePropertyEntityId] [int] NOT NULL,
	[ManageTypeId] [int] NOT NULL,
	[PropertyEntityCode] [char](6) NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [Gdm].[ManagePropertyEntity] ADD  CONSTRAINT [DF_ManagePropertyEntity_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

------------------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ManagePropertyDepartment_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[ManagePropertyDepartment] DROP CONSTRAINT [DF_ManagePropertyDepartment_ImportDate]
END

GO

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ManagePropertyDepartment]') AND type in (N'U'))
DROP TABLE [Gdm].[ManagePropertyDepartment]
GO

USE [GrReportingStaging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[ManagePropertyDepartment](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ManagePropertyDepartmentId] [int] NOT NULL,
	[ManageTypeId] [int] NOT NULL,
	[PropertyDepartmentCode] [char](8) NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [Gdm].[ManagePropertyDepartment] ADD  CONSTRAINT [DF_ManagePropertyDepartment_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

------------------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ManageCorporateEntity_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[ManageCorporateEntity] DROP CONSTRAINT [DF_ManageCorporateEntity_ImportDate]
END

GO

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ManageCorporateEntity]') AND type in (N'U'))
DROP TABLE [Gdm].[ManageCorporateEntity]
GO

USE [GrReportingStaging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[ManageCorporateEntity](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ManageCorporateEntityId] [int] NOT NULL,
	[ManageTypeId] [int] NOT NULL,
	[CorporateEntityCode] [char](6) NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [Gdm].[ManageCorporateEntity] ADD  CONSTRAINT [DF_ManageCorporateEntity_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

------------------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ManageCorporateDepartment_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[ManageCorporateDepartment] DROP CONSTRAINT [DF_ManageCorporateDepartment_ImportDate]
END

GO

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ManageCorporateDepartment]') AND type in (N'U'))
DROP TABLE [Gdm].[ManageCorporateDepartment]
GO

USE [GrReportingStaging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[ManageCorporateDepartment](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ManageCorporateDepartmentId] [int] NOT NULL,
	[ManageTypeId] [int] NOT NULL,
	[CorporateDepartmentCode] [char](8) NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [Gdm].[ManageCorporateDepartment] ADD  CONSTRAINT [DF_ManageCorporateDepartment_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

------------------------------------------
