/*

Tables to create:

GrReportingStaging.Gdm.BusinessLine
GrReportingStaging.Gdm.ActivityTypeBusinessLine

*/

--------------------------------------------------------------------------------------------------------------------------------------------------

USE [GrReportingStaging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[BusinessLine]') AND type in (N'U'))
BEGIN
	CREATE TABLE [Gdm].[BusinessLine](
		[ImportKey] [int] IDENTITY(1,1) NOT NULL,
		[ImportBatchId] [int] NOT NULL,
		[ImportDate] [datetime] NOT NULL,
		[BusinessLineId] [int] NOT NULL,
		[Name] [varchar](50) NOT NULL,
		[IsActive] [bit] NOT NULL,
		[InsertedDate] [datetime] NOT NULL,
		[UpdatedDate] [datetime] NOT NULL,
		[UpdatedByStaffId] [int] NOT NULL
	) ON [PRIMARY]
	
	PRINT ('Table "Gdm.BusinessLine" created.')
END
ELSE
BEGIN
	PRINT ('Cannot create table "Gdm.BusinessLine" as it already exists.')
END

GO

SET ANSI_PADDING OFF
GO

--------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_BusinessLine_ImportDate]') AND type = 'D')
BEGIN
	ALTER TABLE Gdm.BusinessLine DROP CONSTRAINT DF_BusinessLine_ImportDate
	PRINT ('DF "DF_BusinessLine_ImportDate" created.')
END
GO

ALTER TABLE Gdm.BusinessLine ADD  CONSTRAINT DF_BusinessLine_ImportedDate  DEFAULT (getdate()) FOR ImportDate
PRINT ('DF "DF_BusinessLine_ImportDate" created.')

GO

--------------------------------------------------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ActivityTypeBusinessLine]') AND type in (N'U'))
BEGIN
	CREATE TABLE [Gdm].[ActivityTypeBusinessLine](
		[ImportKey] [int] IDENTITY(1,1) NOT NULL,
		[ImportBatchId] [int] NOT NULL,
		[ImportDate] [datetime] NOT NULL,
		[ActivityTypeBusinessLineId] [int] NOT NULL,
		[ActivityTypeId] [int] NOT NULL,
		[BusinessLineId] [int] NOT NULL,	
		[InsertedDate] [datetime] NOT NULL,
		[UpdatedDate] [datetime] NOT NULL,
		[UpdatedByStaffId] [int] NOT NULL,
		[IsActive] [bit] NOT NULL
	) ON [PRIMARY]
	
	PRINT ('Table "Gdm.ActivityTypeBusinessLine" created.')
END
ELSE
BEGIN
	PRINT ('Cannot create table "Gdm.ActivityTypeBusinessLine" as it already exists.')
END

GO

--------------------------------------------------------------------------------------------------------------------------------------------------

SET ANSI_PADDING OFF
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ActivityTypeBusinessLine_ImportDate]') AND type = 'D')
BEGIN
	ALTER TABLE Gdm.ActivityTypeBusinessLine ADD CONSTRAINT DF_ActivityTypeBusinessLine_ImportDate DEFAULT (getdate()) FOR ImportDate
	PRINT ('DF "DF_ActivityTypeBusinessLine_ImportDate" created.')
END
GO

--------------------------------------------------------------------------------------------------------------------------------------------------
