USE [GrReporting]
GO

/****** Object:  Table [dbo].[ProjectGroup]    Script Date: 07/17/2012 21:34:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProjectGroup]') AND type in (N'U'))
DROP TABLE [dbo].[ProjectGroup]
GO

USE [GrReporting]
GO

/****** Object:  Table [dbo].[ProjectGroup]    Script Date: 07/17/2012 21:34:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ProjectGroup](
	[ProjectGroupKey] [int] IDENTITY(1,1) NOT NULL,
	[ProjectGroupId] [int] NOT NULL,
	[BudgetProjectGroupId] [int] NOT NULL,
	[ProjectGroupName] [varchar](100) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[BudgetId] [int] NOT NULL,
	[ReasonForChange] [nvarchar](1024) NULL,
 CONSTRAINT [PK_ProjectGroup] PRIMARY KEY CLUSTERED 
(
	[ProjectGroupKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


---insert the default record

SET IDENTITY_INSERT [dbo].[ProjectGroup] ON

insert into [dbo].[ProjectGroup]
(
	ProjectGroupKey,
	ProjectGroupId,
	BudgetProjectGroupId,
	ProjectGroupName,
	StartDate,
	EndDate,
	BudgetId,
	ReasonForChange
)
select -1,-1,-1,'','1753-01-01 00:00:00.000','9999-12-31 00:00:00.000',-1,''

SET IDENTITY_INSERT [dbo].[ProjectGroup] OFF