USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReportingEntity]') AND type in (N'U'))
DROP TABLE [dbo].[ReportingEntity]
GO

USE [GrReporting]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ReportingEntity](
	[ReportingEntityKey] [int] IDENTITY(1,1) NOT NULL,
	[ReportingEntityId] [int] NOT NULL,
	[ReportingEntityName] [varchar](100) NOT NULL,
	[ReportingEntityType] [varchar](50) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ReportingEntity] PRIMARY KEY CLUSTERED 
(
	[ReportingEntityKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
