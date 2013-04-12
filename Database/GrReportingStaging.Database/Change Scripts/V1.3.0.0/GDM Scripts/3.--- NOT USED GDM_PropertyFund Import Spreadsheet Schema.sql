USE [GDM_Import]
GO

/****** Object:  Table [dbo].[ImportCorporateDepartmentMappingTemp]    Script Date: 04/21/2010 10:55:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ImportCorporateDepartmentMappingTemp](
	[CorpMRISource] [nvarchar](50) NULL,
	[MRIDeptCode] [nvarchar](50) NULL,
	[MRISourceDept] [nvarchar](50) NULL,
	[Activity] [nvarchar](255) NULL,
	[MRIDepartmentName] [nvarchar](255) NULL,
	[ReportingEntity] [nvarchar](255) NULL,
	[ReportingRegion] [nvarchar](255) NULL,
	[BudgetOwner] [nvarchar](255) NULL,
	[BudgetCoordinator] [nvarchar](255) NULL,
	[RegionalOwner] [nvarchar](255) NULL,
	[SuperRegionalOwner] [nvarchar](255) NULL,
	[IsNetTSCost] [nvarchar](255) NULL,
	[BillingEntityType] [nvarchar](255) NULL
) ON [PRIMARY]

GO

USE [GDM_Import]
GO

/****** Object:  Table [dbo].[ImportCorporateDepartmentMapping]    Script Date: 04/21/2010 10:55:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ImportCorporateDepartmentMapping](
	[ImportVersion] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[CorpMRISource] [nvarchar](50) NOT NULL,
	[MRIDeptCode] [nvarchar](50) NOT NULL,
	[MRISourceDept] [nvarchar](50) NOT NULL,
	[Activity] [nvarchar](255) NOT NULL,
	[MRIDepartmentName] [nvarchar](255) NULL,
	[ReportingEntity] [nvarchar](255) NULL,
	[ReportingRegion] [nvarchar](255) NULL,
	[BudgetOwner] [nvarchar](255) NULL,
	[BudgetCoordinator] [nvarchar](255) NULL,
	[RegionalOwner] [nvarchar](255) NULL,
	[SuperRegionalOwner] [nvarchar](255) NULL,
	[IsNetTSCost] [nvarchar](255) NULL,
	[BillingEntityType] [nvarchar](255) NULL
) ON [PRIMARY]

GO


USE [GDM_Import]
/****** Object:  Index [IX_Clustered]    Script Date: 04/21/2010 10:55:02 ******/
CREATE UNIQUE CLUSTERED INDEX [IX_Clustered] ON [dbo].[ImportCorporateDepartmentMapping] 
(
	[ImportVersion] ASC,
	[CorpMRISource] ASC,
	[MRIDeptCode] ASC,
	[Activity] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

 USE [GDM_Import]
GO

/****** Object:  UserDefinedFunction [dbo].[ConvertCsvToTable]    Script Date: 04/21/2010 10:55:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ConvertCsvToTable]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ConvertCsvToTable]
GO

USE [GDM_Import]
GO

/****** Object:  UserDefinedFunction [dbo].[ConvertCsvToTable]    Script Date: 04/21/2010 10:55:34 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[ConvertCsvToTable] (
	@ValueList TEXT
)
RETURNS @ReturnTable TABLE (Field1 NVarchar(50) NOT NULL)

AS
BEGIN

	DECLARE	@CommaIndexLen int,
		@IdCounter int,
		@CurrentChar varchar(1),
		@Id nvarchar(50),
		@TerminateIn int

	DECLARE	@tempTable TABLE (Field1 nvarchar(50) NOT NULL)

	SET @TerminateIn = 0
	SET @IdCounter = 1
	SET @Id = ''

	-- @TerminateIn var is for catching infinite loops. If this is not returning all data, then increase the number
	WHILE  @IdCounter <= DATALENGTH(@ValueList) AND @TerminateIn <= 500000
	BEGIN
		SET @CurrentChar = SUBSTRING(@ValueList,@IdCounter, 1)

		IF @CurrentChar = ','
		BEGIN
			INSERT INTO @tempTable (Field1)
			SELECT @Id
			-- Clear the Id variable
			SET @Id = ''
		END
		ELSE
		BEGIN
			SET @Id = @Id + @CurrentChar
		END

		--Move to next Char
		SET @IdCounter = @IdCounter + 1
		SET @TerminateIn = @TerminateIn + 1
	END

	INSERT INTO @tempTable (Field1)
	SELECT @Id

	INSERT INTO @ReturnTable (Field1)
	SELECT DISTINCT Field1 FROM @tempTable

	RETURN
	
END 


GO

ALTER TABLE dbo.PropertyFund ADD
	IsReportingEntity bit NOT NULL CONSTRAINT DF_PropertyFund_IsReportingEntity_1 DEFAULT ((1)),
	IsPropertyFund bit NOT NULL CONSTRAINT DF_PropertyFund_IsPropertyFund_1 DEFAULT ((1))
GO
ALTER TABLE dbo.PropertyFund ADD CONSTRAINT
	CK_PropertyFund CHECK (([IsReportingEntity]=(1) AND [EntityTypeId]>(0) AND [EntityTypeId]>(0) OR  [IsReportingEntity]=(0)))
GO
ALTER TABLE dbo.PropertyFund ADD CONSTRAINT
	CK_PropertyFund_1 
	CHECK (([IsPropertyFund]=(1) AND [RelatedFundId]>(0) AND [EntityTypeId]>(0) AND [EntityTypeId]>(0) OR [IsPropertyFund]=(0)))
