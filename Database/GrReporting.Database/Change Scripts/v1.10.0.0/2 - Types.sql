 USE [GrReporting]
GO

IF NOT EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'ReportParameterGLCategorizationHierarchyDetail' AND ss.name = N'dbo')

CREATE TYPE [dbo].[ReportParameterGLCategorizationHierarchyDetail] AS TABLE(
	[ReportTypeId] [int] NOT NULL,
	[ReportTypeName] [nvarchar](50) NOT NULL,
	[ReportId] [int] NOT NULL,
	[ReportName] [nvarchar](256) NOT NULL,
	[GLCategorizationId] [int] NOT NULL,
	[GLCategorizationName] [nvarchar](50) NOT NULL,
	[GLFinancialCategoryId] [int] NOT NULL,
	[FinancialCategoryName] [nvarchar](50) NOT NULL,
	[GLMajorCategoryId] [int] NOT NULL,
	[GLMajorCategoryName] [nvarchar](50) NOT NULL,
	[GLMinorCategoryId] [int] NOT NULL,
	[GLMinorCategoryName] [nvarchar](100) NOT NULL,
	[ActivityTypeId] [int] NULL,
	[Name] [nvarchar](50) NULL,
	[IsActive] [bit] NULL
)
GO

