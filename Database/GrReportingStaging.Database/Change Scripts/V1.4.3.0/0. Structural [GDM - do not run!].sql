 ---------------------------------

USE [GDM]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ManageType_IsDeleted]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ManageType] DROP CONSTRAINT [DF_ManageType_IsDeleted]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ManageType_InsertedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ManageType] DROP CONSTRAINT [DF_ManageType_InsertedDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ManageType_UpdatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ManageType] DROP CONSTRAINT [DF_ManageType_UpdatedDate]
END

GO

USE [GDM]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ManageType]') AND type in (N'U'))
DROP TABLE [dbo].[ManageType]
GO

USE [GDM]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ManageType](
	[ManageTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](10) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[Version] [timestamp] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_ManageType] PRIMARY KEY CLUSTERED 
(
	[ManageTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [CK_ManageType_Code] UNIQUE NONCLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[ManageType] ADD  CONSTRAINT [DF_ManageType_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO

ALTER TABLE [dbo].[ManageType] ADD  CONSTRAINT [DF_ManageType_InsertedDate]  DEFAULT (getdate()) FOR [InsertedDate]
GO

ALTER TABLE [dbo].[ManageType] ADD  CONSTRAINT [DF_ManageType_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO

---------------------------------

USE [GDM]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ManagePropertyEntity_ManageTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ManagePropertyEntity]'))
ALTER TABLE [dbo].[ManagePropertyEntity] DROP CONSTRAINT [FK_ManagePropertyEntity_ManageTypeId]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_ManagePropertyEntity_SourceCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[ManagePropertyEntity]'))
ALTER TABLE [dbo].[ManagePropertyEntity] DROP CONSTRAINT [DF_ManagePropertyEntity_SourceCode]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ManagePropertyEntity_IsDeleted]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ManagePropertyEntity] DROP CONSTRAINT [DF_ManagePropertyEntity_IsDeleted]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ManagePropertyEntity_InsertedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ManagePropertyEntity] DROP CONSTRAINT [DF_ManagePropertyEntity_InsertedDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ManagePropertyEntity_UpdatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ManagePropertyEntity] DROP CONSTRAINT [DF_ManagePropertyEntity_UpdatedDate]
END

GO

USE [GDM]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ManagePropertyEntity]') AND type in (N'U'))
DROP TABLE [dbo].[ManagePropertyEntity]
GO

USE [GDM]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ManagePropertyEntity](
	[ManagePropertyEntityId] [int] IDENTITY(1,1) NOT NULL,
	[ManageTypeId] [int] NOT NULL,
	[PropertyEntityCode] [char](6) NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[Version] [timestamp] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_ManagePropertyEntity] PRIMARY KEY CLUSTERED 
(
	[ManagePropertyEntityId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [CK_ManagePropertyEntity_ManageTypeId_PropertyEntityCode_SourceCode] UNIQUE NONCLUSTERED 
(
	[ManageTypeId] ASC,
	[PropertyEntityCode] ASC,
	[SourceCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[ManagePropertyEntity]  WITH CHECK ADD  CONSTRAINT [FK_ManagePropertyEntity_ManageTypeId] FOREIGN KEY([ManageTypeId])
REFERENCES [dbo].[ManageType] ([ManageTypeId])
GO

ALTER TABLE [dbo].[ManagePropertyEntity] CHECK CONSTRAINT [FK_ManagePropertyEntity_ManageTypeId]
GO

ALTER TABLE [dbo].[ManagePropertyEntity]  WITH CHECK ADD  CONSTRAINT [DF_ManagePropertyEntity_SourceCode] CHECK  ((right([SourceCode],(1))<>'C'))
GO

ALTER TABLE [dbo].[ManagePropertyEntity] CHECK CONSTRAINT [DF_ManagePropertyEntity_SourceCode]
GO

ALTER TABLE [dbo].[ManagePropertyEntity] ADD  CONSTRAINT [DF_ManagePropertyEntity_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO

ALTER TABLE [dbo].[ManagePropertyEntity] ADD  CONSTRAINT [DF_ManagePropertyEntity_InsertedDate]  DEFAULT (getdate()) FOR [InsertedDate]
GO

ALTER TABLE [dbo].[ManagePropertyEntity] ADD  CONSTRAINT [DF_ManagePropertyEntity_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO

---------------------------------

USE [GDM]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ManagePropertyDepartment_ManageTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ManagePropertyDepartment]'))
ALTER TABLE [dbo].[ManagePropertyDepartment] DROP CONSTRAINT [FK_ManagePropertyDepartment_ManageTypeId]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_ManagePropertyDepartment_SourceCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[ManagePropertyDepartment]'))
ALTER TABLE [dbo].[ManagePropertyDepartment] DROP CONSTRAINT [DF_ManagePropertyDepartment_SourceCode]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ManagePropertyDepartment_IsDeleted]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ManagePropertyDepartment] DROP CONSTRAINT [DF_ManagePropertyDepartment_IsDeleted]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ManagePropertyDepartment_InsertedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ManagePropertyDepartment] DROP CONSTRAINT [DF_ManagePropertyDepartment_InsertedDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ManagePropertyDepartment_UpdatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ManagePropertyDepartment] DROP CONSTRAINT [DF_ManagePropertyDepartment_UpdatedDate]
END

GO

USE [GDM]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ManagePropertyDepartment]') AND type in (N'U'))
DROP TABLE [dbo].[ManagePropertyDepartment]
GO

USE [GDM]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ManagePropertyDepartment](
	[ManagePropertyDepartmentId] [int] IDENTITY(1,1) NOT NULL,
	[ManageTypeId] [int] NOT NULL,
	[PropertyDepartmentCode] [char](8) NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[Version] [timestamp] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_ManagePropertyDepartment] PRIMARY KEY CLUSTERED 
(
	[ManagePropertyDepartmentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [CK_ManagePropertyDepartment_ManageTypeId_PropertyDepartmentCode_SourceCode] UNIQUE NONCLUSTERED 
(
	[ManageTypeId] ASC,
	[PropertyDepartmentCode] ASC,
	[SourceCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[ManagePropertyDepartment]  WITH CHECK ADD  CONSTRAINT [FK_ManagePropertyDepartment_ManageTypeId] FOREIGN KEY([ManageTypeId])
REFERENCES [dbo].[ManageType] ([ManageTypeId])
GO

ALTER TABLE [dbo].[ManagePropertyDepartment] CHECK CONSTRAINT [FK_ManagePropertyDepartment_ManageTypeId]
GO

ALTER TABLE [dbo].[ManagePropertyDepartment]  WITH CHECK ADD  CONSTRAINT [DF_ManagePropertyDepartment_SourceCode] CHECK  ((right([SourceCode],(1))<>'C'))
GO

ALTER TABLE [dbo].[ManagePropertyDepartment] CHECK CONSTRAINT [DF_ManagePropertyDepartment_SourceCode]
GO

ALTER TABLE [dbo].[ManagePropertyDepartment] ADD  CONSTRAINT [DF_ManagePropertyDepartment_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO

ALTER TABLE [dbo].[ManagePropertyDepartment] ADD  CONSTRAINT [DF_ManagePropertyDepartment_InsertedDate]  DEFAULT (getdate()) FOR [InsertedDate]
GO

ALTER TABLE [dbo].[ManagePropertyDepartment] ADD  CONSTRAINT [DF_ManagePropertyDepartment_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO

---------------------------------

USE [GDM]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ManageCorporateEntity_ManageTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ManageCorporateEntity]'))
ALTER TABLE [dbo].[ManageCorporateEntity] DROP CONSTRAINT [FK_ManageCorporateEntity_ManageTypeId]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_ManageCorporateEntity_SourceCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[ManageCorporateEntity]'))
ALTER TABLE [dbo].[ManageCorporateEntity] DROP CONSTRAINT [DF_ManageCorporateEntity_SourceCode]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ManageCorporateEntity_IsDeleted]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ManageCorporateEntity] DROP CONSTRAINT [DF_ManageCorporateEntity_IsDeleted]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ManageCorporateEntity_InsertedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ManageCorporateEntity] DROP CONSTRAINT [DF_ManageCorporateEntity_InsertedDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ManageCorporateEntity_UpdatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ManageCorporateEntity] DROP CONSTRAINT [DF_ManageCorporateEntity_UpdatedDate]
END

GO

USE [GDM]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ManageCorporateEntity]') AND type in (N'U'))
DROP TABLE [dbo].[ManageCorporateEntity]
GO

USE [GDM]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ManageCorporateEntity](
	[ManageCorporateEntityId] [int] IDENTITY(1,1) NOT NULL,
	[ManageTypeId] [int] NOT NULL,
	[CorporateEntityCode] [char](6) NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[Version] [timestamp] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_ManageCorporateEntity] PRIMARY KEY CLUSTERED 
(
	[ManageCorporateEntityId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [CK_ManageCorporateEntity_ManageTypeId_CorporateEntityCode_SourceCode] UNIQUE NONCLUSTERED 
(
	[ManageTypeId] ASC,
	[CorporateEntityCode] ASC,
	[SourceCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[ManageCorporateEntity]  WITH CHECK ADD  CONSTRAINT [FK_ManageCorporateEntity_ManageTypeId] FOREIGN KEY([ManageTypeId])
REFERENCES [dbo].[ManageType] ([ManageTypeId])
GO

ALTER TABLE [dbo].[ManageCorporateEntity] CHECK CONSTRAINT [FK_ManageCorporateEntity_ManageTypeId]
GO

ALTER TABLE [dbo].[ManageCorporateEntity]  WITH CHECK ADD  CONSTRAINT [DF_ManageCorporateEntity_SourceCode] CHECK  ((right([SourceCode],(1))='C'))
GO

ALTER TABLE [dbo].[ManageCorporateEntity] CHECK CONSTRAINT [DF_ManageCorporateEntity_SourceCode]
GO

ALTER TABLE [dbo].[ManageCorporateEntity] ADD  CONSTRAINT [DF_ManageCorporateEntity_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO

ALTER TABLE [dbo].[ManageCorporateEntity] ADD  CONSTRAINT [DF_ManageCorporateEntity_InsertedDate]  DEFAULT (getdate()) FOR [InsertedDate]
GO

ALTER TABLE [dbo].[ManageCorporateEntity] ADD  CONSTRAINT [DF_ManageCorporateEntity_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO

---------------------------------

USE [GDM]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ManageCorporateDepartment_ManageTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ManageCorporateDepartment]'))
ALTER TABLE [dbo].[ManageCorporateDepartment] DROP CONSTRAINT [FK_ManageCorporateDepartment_ManageTypeId]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_ManageCorporateDepartment_SourceCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[ManageCorporateDepartment]'))
ALTER TABLE [dbo].[ManageCorporateDepartment] DROP CONSTRAINT [DF_ManageCorporateDepartment_SourceCode]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ManageCorporateDepartment_IsDeleted]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ManageCorporateDepartment] DROP CONSTRAINT [DF_ManageCorporateDepartment_IsDeleted]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ManageCorporateDepartment_InsertedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ManageCorporateDepartment] DROP CONSTRAINT [DF_ManageCorporateDepartment_InsertedDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ManageCorporateDepartment_UpdatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ManageCorporateDepartment] DROP CONSTRAINT [DF_ManageCorporateDepartment_UpdatedDate]
END

GO

USE [GDM]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ManageCorporateDepartment]') AND type in (N'U'))
DROP TABLE [dbo].[ManageCorporateDepartment]
GO

USE [GDM]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ManageCorporateDepartment](
	[ManageCorporateDepartmentId] [int] IDENTITY(1,1) NOT NULL,
	[ManageTypeId] [int] NOT NULL,
	[CorporateDepartmentCode] [char](8) NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[Version] [timestamp] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_ManageCorporateDepartment] PRIMARY KEY CLUSTERED 
(
	[ManageCorporateDepartmentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [CK_ManageCorporateDepartment_ManageTypeId_CorporateDepartmentCode_SourceCode] UNIQUE NONCLUSTERED 
(
	[ManageTypeId] ASC,
	[CorporateDepartmentCode] ASC,
	[SourceCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[ManageCorporateDepartment]  WITH CHECK ADD  CONSTRAINT [FK_ManageCorporateDepartment_ManageTypeId] FOREIGN KEY([ManageTypeId])
REFERENCES [dbo].[ManageType] ([ManageTypeId])
GO

ALTER TABLE [dbo].[ManageCorporateDepartment] CHECK CONSTRAINT [FK_ManageCorporateDepartment_ManageTypeId]
GO

ALTER TABLE [dbo].[ManageCorporateDepartment]  WITH CHECK ADD  CONSTRAINT [DF_ManageCorporateDepartment_SourceCode] CHECK  ((right([SourceCode],(1))='C'))
GO

ALTER TABLE [dbo].[ManageCorporateDepartment] CHECK CONSTRAINT [DF_ManageCorporateDepartment_SourceCode]
GO

ALTER TABLE [dbo].[ManageCorporateDepartment] ADD  CONSTRAINT [DF_ManageCorporateDepartment_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO

ALTER TABLE [dbo].[ManageCorporateDepartment] ADD  CONSTRAINT [DF_ManageCorporateDepartment_InsertedDate]  DEFAULT (getdate()) FOR [InsertedDate]
GO

ALTER TABLE [dbo].[ManageCorporateDepartment] ADD  CONSTRAINT [DF_ManageCorporateDepartment_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO

---------------------------------