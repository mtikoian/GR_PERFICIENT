USE [GrReporting]
GO

/****** Object:  UserDefinedTableType [dbo].[CategoryActivityGroup]    Script Date: 08/18/2010 11:04:10 ******/
IF  EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'CategoryActivityGroup' AND ss.name = N'dbo')
DROP TYPE [dbo].[CategoryActivityGroup]
GO

/****** Object:  UserDefinedTableType [dbo].[CategoryActivityGroup]    Script Date: 08/18/2010 11:04:10 ******/
CREATE TYPE [dbo].[CategoryActivityGroup] AS TABLE(
	[MinorAccountCategoryList] [nvarchar](max) NOT NULL,
	[ActivityTypeList] [nvarchar](max) NULL
)
GO
IF NOT EXISTS(SElect * From INFORMATION_SCHEMA.COLUMNS Where 
TABLE_NAME = 'ProfitabilityActual' AND COLUMN_NAME = 'OriginatingRegionCode')
	BEGIN

	ALTER TABLE dbo.ProfitabilityActual ADD
		OriginatingRegionCode char(6) NULL,
		PropertyFundCode char(12) NULL,
		FunctionalDepartmentCode char(15) NULL 
		
	END
GO