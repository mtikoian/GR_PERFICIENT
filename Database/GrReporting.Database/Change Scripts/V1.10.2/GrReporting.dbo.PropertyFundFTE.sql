USE [GrReporting]
GO

/****** Object:  Table [dbo].[PropertyFundFTE]    Script Date: 08/14/2012 02:37:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PropertyFundFTE]') AND type in (N'U'))
DROP TABLE [dbo].[PropertyFundFTE]
GO

USE [GrReporting]
GO

/****** Object:  Table [dbo].[PropertyFundFTE]    Script Date: 08/14/2012 02:37:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[PropertyFundFTE](
	[PropertyFundKey] [int] IDENTITY(1,1) NOT NULL,
	[PropertyFundId] [int] NOT NULL,
	[PropertyFundName] [varchar](100) NOT NULL,
	[PropertyFundType] [varchar](50) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[SnapshotId] [int] NOT NULL,
	[ReasonForChange] [nvarchar](1024) NULL,
 CONSTRAINT [PK_PropertyFundFTE] PRIMARY KEY CLUSTERED 
(
	[PropertyFundKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


SET IDENTITY_INSERT [GrReporting].[dbo].[PropertyFundFTE] ON

INSERT INTO [GrReporting].[dbo].[PropertyFundFTE]
           ([PropertyFundKey]
           ,[PropertyFundId]
           ,[PropertyFundName]
           ,[PropertyFundType]
           ,[StartDate]
           ,[EndDate]
           ,[SnapshotId]
           ,[ReasonForChange])
     VALUES
           (-1,-1
           ,'UNKNOWN'
           ,'UNKNOWN'
           ,'1753-01-01 00:00:00.000'
           ,'9999-12-31 00:00:00.000'
           ,0
           ,NULL)
GO

SET IDENTITY_INSERT [GrReporting].[dbo].[PropertyFundFTE] OFF

