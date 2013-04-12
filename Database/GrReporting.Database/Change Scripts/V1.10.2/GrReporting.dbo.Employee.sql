USE [GrReporting]
GO

/****** Object:  Table [dbo].[Employee]    Script Date: 07/02/2012 22:31:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Employee]') AND type in (N'U'))
DROP TABLE [dbo].[Employee]
GO

USE [GrReporting]
GO

/****** Object:  Table [dbo].[Employee]    Script Date: 07/02/2012 22:31:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Employee](
	[EmployeeKey] [int] IDENTITY(1,1) NOT NULL,
	[HrEmployeeId] [int] NOT NULL,
	[StaffId] [int] NOT NULL,
	[BudgetEmployeeId] [int] NOT NULL,
	EmployeeHistoryId [int] NOT NULL,
	BudgetEmployeeFunctionalDepartmentId int NOT NULL,
	PayGroupCode varchar(50) NOT NULL,
	PayGroupName varchar(50) NOT NULL,
	SubDepartmentCode varchar(50) NOT NULL,
	SubDepartmentName varchar(50) NOT NULL,
	CorporateEntityRef [varchar](6) NOT NULL, 
	CorporateSourceCode [varchar](2) NOT NULL,
	[EmployeeName] [varchar](255) NOT NULL,
	FirstName varchar(100) NOT NULL,
	LastName varchar(100) NOT NULL,
	Initials varchar(50) NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[BudgetId] [int] NOT NULL,
	SnapshotId int NOT NULL,
	[ReasonForChange] [nvarchar](1024) NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[EmployeeKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

---insert the default record

SET IDENTITY_INSERT [dbo].[Employee] ON

insert into [dbo].[Employee]
(
	EmployeeKey,
	HrEmployeeId,
	StaffId,
	BudgetEmployeeId,
	EmployeeHistoryId,
	BudgetEmployeeFunctionalDepartmentId,
	PayGroupCode,
	PayGroupName,
	SubDepartmentCode,
	SubDepartmentName,
	CorporateEntityRef,
	CorporateSourceCode ,
	EmployeeName,
	FirstName,
	LastName,
	Initials,
	StartDate,
	EndDate,
	BudgetId,
	SnapshotId,
	ReasonForChange
)
select -1,-1,-1,-1,-1,-1,'','','','','','','','','','','1753-01-01 00:00:00.000','9999-12-31 00:00:00.000',-1,0,''

SET IDENTITY_INSERT [dbo].[Employee] OFF