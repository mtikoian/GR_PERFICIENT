/*

Tables that need to be created:

GrReportingStaging.Gdm.SnapshotActivityType
GrReportingStaging.Gdm.SnapshotActivityTypeBusinessLine
GrReportingStaging.Gdm.SnapshotBusinessLine

*/ 

USE [GrReportingStaging]
GO

/****** Object:  Table [Gdm].[SnapshotActivityType]    Script Date: 04/04/2011 18:49:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotActivityType]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotActivityType]
GO

USE [GrReportingStaging]
GO

/****** Object:  Table [Gdm].[SnapshotActivityType]    Script Date: 04/04/2011 18:49:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

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

GO

SET ANSI_PADDING OFF
GO

------------------------------------------------------------------------------------------------------------------------------

USE [GrReportingStaging]
GO

/****** Object:  Table [Gdm].[SnapshotActivityTypeBusinessLine]    Script Date: 04/04/2011 18:50:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotActivityTypeBusinessLine]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotActivityTypeBusinessLine]
GO

USE [GrReportingStaging]
GO

/****** Object:  Table [Gdm].[SnapshotActivityTypeBusinessLine]    Script Date: 04/04/2011 18:50:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Gdm].[SnapshotActivityTypeBusinessLine](
	[SnapshotId] [int] NOT NULL,
	[ActivityTypeBusinessLineId] [int] NOT NULL,
	[ActivityTypeId] [int] NOT NULL,
	[BusinessLineId] [int] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_SnapshotActivityTypeBusinessLine] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[ActivityTypeBusinessLineId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UX_SnapshotActivityTypeBusinessLine_ActivityTypeId] UNIQUE NONCLUSTERED 
(
	[SnapshotId] ASC,
	[ActivityTypeId] ASC,
	[BusinessLineId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

------------------------------------------------------------------------------------------------------------------------------

USE [GrReportingStaging]
GO

/****** Object:  Table [Gdm].[SnapshotBusinessLine]    Script Date: 04/04/2011 18:51:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotBusinessLine]') AND type in (N'U'))
DROP TABLE [Gdm].[SnapshotBusinessLine]
GO

USE [GrReportingStaging]
GO

/****** Object:  Table [Gdm].[SnapshotBusinessLine]    Script Date: 04/04/2011 18:51:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[SnapshotBusinessLine](
	[SnapshotId] [int] NOT NULL,
	[BusinessLineId] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotBusinessLine] PRIMARY KEY CLUSTERED 
(
	[SnapshotId] ASC,
	[BusinessLineId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UX_SnapshotBusinessLine_Name] UNIQUE NONCLUSTERED 
(
	[SnapshotId] ASC,
	[Name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

------------------------------------------------------------------------------------------------------------------------------
