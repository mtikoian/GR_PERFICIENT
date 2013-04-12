USE [GrReporting]
GO

/****** Object:  Table [dbo].[Project]    Script Date: 07/02/2012 22:31:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Project]') AND type in (N'U'))
DROP TABLE [dbo].[Project]
GO

USE [GrReporting]
GO

/****** Object:  Table [dbo].[Project]    Script Date: 07/02/2012 22:31:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Project](
	[ProjectKey] [int] IDENTITY(1,1) NOT NULL,
	[ProjectId] [int] NOT NULL,
	[BudgetProjectId] [int] NOT NULL,
	[ProjectCode] [varchar](50) NOT NULL,
	[ProjectName] [varchar](100) NOT NULL,
	[RegionName] [varchar](50) NOT NULL,
	[RegionId] [int] NOT NULL,
	[CorporateDepartmentCode] [varchar](10)NOT NULL,
	[CorporateDepartmentName] [varchar](50) NOT NULL,
	[CorporateSourceCode][char](2) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[BudgetId] [int] NOT NULL,
	[ReasonForChange] [nvarchar](1024) NULL,
 CONSTRAINT [PK_Project] PRIMARY KEY CLUSTERED 
(
	[ProjectKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

---insert the default record

SET IDENTITY_INSERT [dbo].[Project] ON

insert into [dbo].[Project]
(
	ProjectKey,
	ProjectId,
	BudgetProjectId,
	ProjectName,
	ProjectCode,
	RegionName,
	RegionId,
	CorporateDepartmentCode,
	CorporateDepartmentName,
	CorporateSourceCode,
	StartDate,
	EndDate,
	BudgetId,
	ReasonForChange
)
select -1,-1,-1,'UNKNOWN','UNKNOWN','',-1,'','','','1753-01-01 00:00:00.000','9999-12-31 00:00:00.000',-1,''

SET IDENTITY_INSERT [dbo].[Project] OFF