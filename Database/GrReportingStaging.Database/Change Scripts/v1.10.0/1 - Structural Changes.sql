 USE GrReportingStaging
 GO
 
 PRINT  '
----------------------------------------------------------------
General Changes
----------------------------------------------------------------'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotConsolidationSubRegion]') AND type in (N'U'))
BEGIN

	DROP TABLE Gdm.SnapshotConsolidationSubRegion

	PRINT ('The Gdm.SnapshotConsolidationSubRegion table has been dropped')

END

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BudgetAllocationSetYearQuarterMapping]') AND type in (N'U'))
BEGIN
	
 CREATE TABLE dbo.BudgetAllocationSetYearQuarterMapping
	(
		BudgetAllocationSetId INT NOT NULL,
		BudgetYear INT NOT NULL,
		BudgetQuarter CHAR(2) NOT NULL,
		CONSTRAINT [PK_BudgetAllocationSetYearQuarterMapping] PRIMARY KEY CLUSTERED
		(
			BudgetAllocationSetId ASC
		)
	)

	PRINT 'The dbo.BudgetAllocationSetYearQuarterMapping table has been created' 

END

 PRINT '
----------------------------------------------------------------
GDM Changes
----------------------------------------------------------------'
 -- Gdm.GlAccount
 
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLAccount]') AND type in (N'U'))
BEGIN

 CREATE TABLE [Gdm].[GLAccount](
 	ImportKey int  IDENTITY(1,1) NOT NULL,
	ImportBatchId int NOT NULL,
	ImportDate datetime NOT NULL,
	[GLAccountId] [int]  NOT NULL,
	[GLGlobalAccountId] [int] NULL,
	[Code] [varchar](15) NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[Name] [nvarchar](120) NULL,
	[EnglishName] [nvarchar](120) NULL,
	[Type] [char](1) NULL,
	[LastDate] [datetime2](0) NULL,
	[IsActive] [bit] NOT NULL,
	[IsHistoric] [bit] NOT NULL,
	[IsGlobalReporting] [bit] NOT NULL,
	[IsServiceCharge] [bit] NOT NULL,
	[IsDirectRecharge] [bit] NOT NULL,
	--[Version] [timestamp] NOT NULL,
	[InsertedDate] [datetime2](0) NOT NULL,
	[UpdatedDate] [datetime2](0) NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
)
 
ALTER TABLE [Gdm].[GLAccount] ADD  CONSTRAINT [DF_GLAccount_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
PRINT 'The [Gdm].[GLAccount] table has been created' 
END
GO

-- Gdm.Department

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[Department]') AND type in (N'U'))
BEGIN

CREATE TABLE [Gdm].[Department](
	ImportKey int  IDENTITY(1,1) NOT NULL,
	ImportBatchId int NOT NULL,
	ImportDate datetime NOT NULL,
	[DepartmentCode] [char](8) NOT NULL,
	[DepartmentTypeCode] [varchar](100) NULL,
	[Description] [varchar](50) NULL,
	[LastDate] [datetime] NULL,
	[MRIUserID] [char](20) NULL,
	[Source] [char](2) NOT NULL,
	[IsTsCost] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[FunctionalDepartmentId] [int] NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UseInServiceCharge] [bit] NOT NULL
)

ALTER TABLE [Gdm].[Department] ADD  CONSTRAINT [DF_Department_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
PRINT 'The [Gdm].[Department] table has been created' 
END
GO

 -- GDM.GlCategorization
 
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLCategorization]') AND type in (N'U'))
BEGIN

CREATE TABLE [Gdm].[GLCategorization](
	ImportKey int  IDENTITY(1,1) NOT NULL,
	ImportBatchId int NOT NULL,
	ImportDate datetime NOT NULL,
	GLCategorizationId int NOT NULL,
	GLCategorizationTypeId int NOT NULL,
	[Name] varchar(50) NOT NULL,
	IsActive bit NOT NULL,
	--Version timestamp NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	UpdatedByStaffId int NOT NULL,
	IsGRDefault bit NOT NULL,
	Description varchar(255) NULL,
	IsFinancialCategoryEditable bit NOT NULL,
	IsCategoryCodeRequired bit NOT NULL,
	IsSeparateIndirectCategorizationRequired bit NOT NULL,
	ExcludeNonReimbursableCorporateCosts bit NOT NULL,
	RechargeBudgetTypeId int NULL,
	RechargeSourceCode char(2) NULL,
	IsConfiguredForRecharge  BIT NULL,
)


ALTER TABLE [Gdm].[GLCategorization] ADD  CONSTRAINT [DF_GLCategorization_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
PRINT 'The [Gdm].[GLCategorization] table has been created' 
END

GO

 -- GDM.GlCategorizationType
 
IF NOT  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLCategorizationType]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[GLCategorizationType](
	ImportKey int  IDENTITY(1,1) NOT NULL,
	ImportBatchId int NOT NULL,
	ImportDate datetime NOT NULL,
	GLCategorizationTypeId int NOT NULL,
	[Name] varchar(50) NOT NULL,
	Description varchar(255) NOT NULL,
	IsActive bit NOT NULL,
	--Version timestamp NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	UpdatedByStaffId int NOT NULL,
	FinancialCategoryDescription [varchar](255) NOT NULL,
	MajorCategoryDescription varchar(255) NOT NULL,
	MinorCategoryDescription varchar(255) NOT NULL,
)

ALTER TABLE [Gdm].[GLCategorizationType] ADD  CONSTRAINT [DF_GLCategorizationType_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
PRINT 'The [Gdm].[GLCategorizationType] table has been created' 
END
GO

-- Gdm.FinancialCategory

IF NOT  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLFinancialCategory]') AND type in (N'U'))
BEGIN

CREATE TABLE [Gdm].[GLFinancialCategory](
	ImportKey int  IDENTITY(1,1) NOT NULL,
	ImportBatchId int NOT NULL,
	ImportDate datetime NOT NULL,
	GLFinancialCategoryId int NOT NULL,
	GLCategorizationId int NOT NULL,
	[Name] varchar(50) NOT NULL,
	InflowOutflow varchar(7) NOT NULL,
	RequiresMinorCategoryExpenseCzars bit NOT NULL,
	--Version timestamp NOT NULL,
	InsertedDate datetime2(0) NOT NULL,
	UpdatedDate datetime2(0) NOT NULL,
	UpdatedByStaffId int NOT NULL,
)

ALTER TABLE [Gdm].[GLFinancialCategory] ADD  CONSTRAINT [DF_GLFinancialCategory_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
PRINT 'The [Gdm].[GLFinancialCategory] table has been created' 

END
GO

-- Gdm.GLGlobalAccountCategorization

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLGlobalAccountCategorization]') AND type in (N'U'))

BEGIN

CREATE TABLE [Gdm].[GLGlobalAccountCategorization](
	ImportKey int  IDENTITY(1,1) NOT NULL,
	ImportBatchId int NOT NULL,
	ImportDate datetime NOT NULL,
	GLGlobalAccountCategorizationId int NOT NULL,
	GLGlobalAccountId int NOT NULL,
	GLCategorizationId int NOT NULL,
	CoAGLMinorCategoryId int NULL,
	DirectGLMinorCategoryId int NULL,
	DirectPostingGLAccountId int NULL,
	IsDirectApplicable bit NOT NULL,
	IndirectGLMinorCategoryId int NULL,
	IndirectPostingGLAccountId int NULL,
	IsIndirectApplicable bit NOT NULL,
	--Version timestamp NOT NULL,
	InsertedDate datetime2(0) NOT NULL,
	UpdatedDate datetime2(0) NOT NULL,
	UpdatedByStaffId int NOT NULL,
	IsCoAApplicable bit NOT NULL,
)

ALTER TABLE [Gdm].[GLGlobalAccountCategorization] ADD  CONSTRAINT [DF_GLGlobalAccountCategorization_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]

PRINT 'The [Gdm].[GLGlobalAccountCategorization] table has been created' 
END 
GO

-- Gdm.GLMinorCategoryPayrollType

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLMinorCategoryPayrollType]') AND type in (N'U'))

BEGIN

CREATE TABLE [Gdm].[GLMinorCategoryPayrollType](
	ImportKey int  IDENTITY(1,1) NOT NULL,
	ImportBatchId int NOT NULL,
	ImportDate datetime NOT NULL,
	[GLMinorCategoryPayrollTypeId] [int] NOT NULL,
	[GLMinorCategoryId] [int] NOT NULL,
	[PayrollTypeId] [int] NOT NULL,
	--[Version] [timestamp] NOT NULL,
	[InsertedDate] [datetime2](0) NOT NULL,
	[UpdatedDate] [datetime2](0) NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
)

ALTER TABLE [Gdm].[GLMinorCategoryPayrollType] ADD  CONSTRAINT [DF_GLMinorCategoryPayrollType_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]

PRINT 'The [Gdm].[GLMinorCategoryPayrollType] table has been created'
END
GO

-- Gdm.PropertyOverheadPropertyGlAccount

IF NOT  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[PropertyOverheadPropertyGLAccount]') AND type in (N'U'))

BEGIN

CREATE TABLE [Gdm].[PropertyOverheadPropertyGLAccount](
	ImportKey int  IDENTITY(1,1) NOT NULL,
	ImportBatchId int NOT NULL,
	ImportDate datetime NOT NULL,
	[PropertyOverheadPropertyGLAccountId] [int] NOT NULL,
	[GLCategorizationId] [int] NOT NULL,
	[ActivityTypeId] [int] NULL,
	[FunctionalDepartmentId] [int] NULL,
	[PropertyGLAccountId] [int] NULL,
	[GLGlobalAccountId] [int] NULL,
	--[Version] [timestamp] NOT NULL,
	[InsertedDate] [datetime2](0) NOT NULL,
	[UpdatedDate] [datetime2](0) NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
)


ALTER TABLE [Gdm].[PropertyOverheadPropertyGLAccount] ADD  CONSTRAINT [DF_PropertyOverheadPropertyGLAccount_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]

PRINT 'The [Gdm].[PropertyOverheadPropertyGLAccount] table has been created'
END
GO

-- Gdm.PropertyPayrollPropertyGlAccount

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[PropertyPayrollPropertyGLAccount]') AND type in (N'U'))

BEGIN

CREATE TABLE [Gdm].[PropertyPayrollPropertyGLAccount](
	ImportKey int  IDENTITY(1,1) NOT NULL,
	ImportBatchId int NOT NULL,
	ImportDate datetime NOT NULL,
	[PropertyPayrollPropertyGLAccountId] [int] NOT NULL,
	[GLCategorizationId] [int] NOT NULL,
	[PayrollTypeId] [int] NOT NULL,
	[ActivityTypeId] [int] NULL,
	[FunctionalDepartmentId] [int] NULL,
	[PropertyGLAccountId] [int] NULL,
	[GLGlobalAccountId] [int] NULL,
	[GLMinorCategoryId] [int] NULL,
	--[Version] [timestamp] NOT NULL,
	[InsertedDate] [datetime2](0) NOT NULL,
	[UpdatedDate] [datetime2](0) NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
)

ALTER TABLE [Gdm].[PropertyPayrollPropertyGLAccount] ADD  CONSTRAINT [DF_PropertyPayrollPropertyGLAccount_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]

PRINT 'The [Gdm].[PropertyPayrollPropertyGLAccount] table has been created'
END
GO

-- Gdm.ReportCategorization

IF NOT  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ReportingCategorization]') AND type in (N'U'))

BEGIN

CREATE TABLE [Gdm].[ReportingCategorization](
	ImportKey int  IDENTITY(1,1) NOT NULL,
	ImportBatchId int NOT NULL,
	ImportDate datetime NOT NULL,
	[ReportingCategorizationId] [int] NOT NULL,
	[EntityTypeId] [int] NOT NULL,
	[AllocationSubRegionGlobalRegionId] [int] NOT NULL,
	[GLCategorizationId] [int] NOT NULL,
	--[Version] [timestamp] NOT NULL,
	[InsertedDate] [datetime2](0) NOT NULL,
	[UpdatedDate] [datetime2](0) NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
)

ALTER TABLE [Gdm].[ReportingCategorization] ADD  CONSTRAINT [DF_ReportingCategorization_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
PRINT 'The [Gdm].[ReportingCategorization] table has been created'

END
GO

-- Gdm.RestrictedFunctionalDepartmentCorporateEntity

IF NOT  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[RestrictedFunctionalDepartmentCorporateEntity]') AND type in (N'U'))

BEGIN

CREATE TABLE [Gdm].[RestrictedFunctionalDepartmentCorporateEntity](
	ImportKey int  IDENTITY(1,1) NOT NULL,
	ImportBatchId int NOT NULL,
	ImportDate datetime NOT NULL,
	[RestrictedFunctionalDepartmentCorporateEntityId] [int] NOT NULL,
	[CorporateEntityCode] [char](6) NOT NULL,
	[CorporateEntitySourceCode] [char](2) NOT NULL,
	[FunctionalDepartmentId] [int] NOT NULL,
	--[Version] [timestamp] NOT NULL,
	[InsertedDate] [datetime2](0) NOT NULL,
	[UpdatedDate] [datetime2](0) NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
) 

ALTER TABLE [Gdm].[RestrictedFunctionalDepartmentCorporateEntity] ADD  CONSTRAINT [DF_RestrictedFunctionalDepartmentCorporateEntity_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
PRINT 'The [Gdm].[RestrictedFunctionalDepartmentCorporateEntity] table has been created'
END 
GO

-- Gdm.RestrictedFunctionalDepartmentGlGlobalAccount

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[RestrictedFunctionalDepartmentGLGlobalAccount]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[RestrictedFunctionalDepartmentGLGlobalAccount](
	ImportKey int  IDENTITY(1,1) NOT NULL,
	ImportBatchId int NOT NULL,
	ImportDate datetime NOT NULL,
	[RestrictedFunctionalDepartmentGLGlobalAccountId] [int] NOT NULL,
	[GLGlobalAccountId] [int] NOT NULL,
	[FunctionalDepartmentId] [int] NULL,
	--[Version] [timestamp] NOT NULL,
	[InsertedDate] [datetime2](0) NOT NULL,
	[UpdatedDate] [datetime2](0) NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL
)

ALTER TABLE [Gdm].[RestrictedFunctionalDepartmentGLGlobalAccount] ADD  CONSTRAINT [DF_RestrictedFunctionalDepartmentGLGlobalAccount_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
PRINT 'The [Gdm].[RestrictedFunctionalDepartmentGLGlobalAccount] table has been created'

END
GO

-- Gdm.SnapshotGLCategorization

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLCategorization]') AND type in (N'U'))
BEGIN

CREATE TABLE [Gdm].[SnapshotGLCategorization](
	[SnapshotId] [int] NOT NULL,
	[GLCategorizationId] [int] NOT NULL,
	[GLCategorizationTypeId] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime2](0) NOT NULL,
	[UpdatedDate] [datetime2](0) NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[IsGRDefault] [bit] NOT NULL,
	[Description] [varchar](255) NULL,
	[IsFinancialCategoryEditable] [bit] NULL,
	[IsCategoryCodeRequired] [bit] NULL,
	[IsSeparateIndirectCategorizationRequired] [bit] NULL,
	[RechargeBudgetTypeId] [int] NULL,
	[RechargeSourceCode] [char](2) NULL,
	[IsConfiguredForRecharge] BIT,
	[ExcludeNonReimbursableCorporateCosts] [bit] NULL,
 CONSTRAINT [PK_SnapshotGLCategorization] PRIMARY KEY CLUSTERED 
(
	[GLCategorizationId] ASC,
	[SnapshotId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UX_SnapshotGLCategorization_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC,
	[SnapshotId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) 

PRINT 'The Gdm.SnapshotGLCategorization table has been created'

END
GO
-- Gdm.SnapshotGLCategorizationType

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLCategorizationType]') AND type in (N'U'))
BEGIN

CREATE TABLE [Gdm].[SnapshotGLCategorizationType](
	[SnapshotId] [int] NOT NULL,
	[GLCategorizationTypeId] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime2](0) NOT NULL,
	[UpdatedDate] [datetime2](0) NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[FinancialCategoryDescription] [varchar](255) NOT NULL,
	[MajorCategoryDescription] [varchar](255) NOT NULL,
	[MinorCategoryDescription] [varchar](255) NOT NULL,
 CONSTRAINT [PK_SnapshotGLCategorizationType] PRIMARY KEY CLUSTERED 
(
	[GLCategorizationTypeId] ASC,
	[SnapshotId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UX_SnapshotGLCategorizationType_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC,
	[SnapshotId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
)
PRINT 'The Gdm.SnapshotGLCategorizationType table has been created'

END
GO

-- Gdm.SnapshotGlFinancialCategory

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLFinancialCategory]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].[SnapshotGLFinancialCategory](
	[SnapshotId] [int] NOT NULL,
	[GLFinancialCategoryId] [int] NOT NULL,
	[GLCategorizationId] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[InflowOutflow] [varchar](7) NOT NULL,
	[RequiresMinorCategoryExpenseCzars] [bit] NOT NULL,
	[InsertedDate] [datetime2](0) NOT NULL,
	[UpdatedDate] [datetime2](0) NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotGLFinancialCategory] PRIMARY KEY CLUSTERED 
(
	[GLFinancialCategoryId] ASC,
	[SnapshotId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UX_SnapshotGLFinancialCategory_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC,
	[GLCategorizationId] ASC,
	[SnapshotId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

PRINT 'The [Gdm].[SnapshotGLFinancialCategory] table has been created'

END
GO

-- Gdm.SnapshotGlGlobalAccountCategorization

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLGlobalAccountCategorization]') AND type in (N'U'))
BEGIN

CREATE TABLE [Gdm].[SnapshotGLGlobalAccountCategorization](
	[SnapshotId] [int] NOT NULL,
	[GLGlobalAccountCategorizationId] [int] NOT NULL,
	[GLGlobalAccountId] [int] NOT NULL,
	[GLCategorizationId] [int] NOT NULL,
	[CoAGLMinorCategoryId] [int] NULL,
	[DirectGLMinorCategoryId] [int] NULL,
	[DirectPostingGLAccountId] [int] NULL,
	[IndirectGLMinorCategoryId] [int] NULL,
	[IndirectPostingGLAccountId] [int] NULL,
	--[Version] [timestamp] NOT NULL,
	[InsertedDate] [datetime2](0) NOT NULL,
	[UpdatedDate] [datetime2](0) NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[IsDirectApplicable] [bit] NOT NULL,
	[IsIndirectApplicable] [bit] NOT NULL,
	[IsCoAApplicable] [bit] NOT NULL,
 CONSTRAINT [PK_SnapshotGLGlobalAccountCategorization] PRIMARY KEY CLUSTERED 
(
	[GLGlobalAccountCategorizationId] ASC,
	[SnapshotId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UX_SnapshotGLGlobalAccountCategorization_GLGlobalAccount] UNIQUE NONCLUSTERED 
(
	[GLGlobalAccountId] ASC,
	[GLCategorizationId] ASC,
	[SnapshotId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
)

PRINT 'The [Gdm].[SnapshotGLGlobalAccountCategorization] table has been created'

END
GO

-- Gdm.SnapshotReportCategorization

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotReportingCategorization]') AND type in (N'U'))
BEGIN

CREATE TABLE [Gdm].[SnapshotReportingCategorization](
	[SnapshotId] [int] NOT NULL,
	[ReportingCategorizationId] [int] NOT NULL,
	[EntityTypeId] [int] NOT NULL,
	[AllocationSubRegionGlobalRegionId] [int] NOT NULL,
	[GLCategorizationId] [int] NOT NULL,
	[InsertedDate] [datetime2](0) NOT NULL,
	[UpdatedDate] [datetime2](0) NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SnapshotReportingCategorization] PRIMARY KEY CLUSTERED 
(
	[ReportingCategorizationId] ASC,
	[SnapshotId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UX_SnapshotReportingCategorization_EntityTypeAllocationSubRegion] UNIQUE NONCLUSTERED 
(
	[EntityTypeId] ASC,
	[AllocationSubRegionGlobalRegionId] ASC,
	[SnapshotId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
)

PRINT 'The [Gdm].[SnapshotReportingCategorization] table has been created'

END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[MRIServerSource]') AND type in (N'U'))
BEGIN

CREATE TABLE [Gdm].[MRIServerSource](
	ImportKey int  IDENTITY(1,1) NOT NULL,
	ImportBatchId int NOT NULL,
	ImportDate datetime NOT NULL,
	SourceCode [char](2) NOT NULL,
	GLAccountSourceCode [char](2) NULL,
	GLAccountPrefix [char](2) NULL,
	[Name] [varchar](30) NULL,
	Server [varchar](20) NOT NULL,
	LinkedServer [varchar](20) NOT NULL,
	DatabaseName [varchar](50) NOT NULL,
	SourceGroupCode  CHAR(1) NULL,
	MappingSourceCode [char](2) NULL,
	ManuallyMapToGlobalGLAccounts  BIT NULL,
	IsActive [bit] NOT NULL,
	IsCorporate [bit] NOT NULL,
	InsertedDate [datetime2](0) NOT NULL,
	UpdatedDate [datetime2](0) NOT NULL,
	UpdatedByStaffId [int] NOT NULL,
 CONSTRAINT [PK_MRIServerSource] PRIMARY KEY CLUSTERED 
(
	ImportKey ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [Gdm].[MRIServerSource] ADD  CONSTRAINT [DF_MRIServerSource_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]

PRINT 'The [Gdm].[MRIServerSource] table has been created'

END
/*
Drop unused tables
*/

-- [Gdm].[AllocationRegionProjectRegion]

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Allocatio__Impor__44A412F1]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[AllocationRegionProjectRegion] DROP CONSTRAINT [DF__Allocatio__Impor__44A412F1]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[AllocationRegionProjectRegion]') AND type in (N'U'))
BEGIN
DROP TABLE [Gdm].[AllocationRegionProjectRegion]
PRINT 'The [Gdm].[AllocationRegionProjectRegion] table has been dropped'
END
GO

-- [Gdm].[GLAccountSubType]

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__GLAccount__Impor__6AC9BBD9]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[GLAccountSubType] DROP CONSTRAINT [DF__GLAccount__Impor__6AC9BBD9]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLAccountSubType]') AND type in (N'U'))
BEGIN
DROP TABLE [Gdm].[GLAccountSubType]
PRINT 'The [Gdm].[GLAccountSubType] table has been dropped'
END
GO

-- [Gdm].[GLAccountType]

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__GLAccount__Impor__68E17367]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[GLAccountType] DROP CONSTRAINT [DF__GLAccount__Impor__68E17367]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLAccountType]') AND type in (N'U'))
BEGIN
DROP TABLE [Gdm].[GLAccountType]
PRINT 'The [Gdm].[GLAccountType] table has been dropped'
END
GO
-- [Gdm].[GLGlobalAccountGLAccount]

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__GLGlobalA__Impor__3D02F129]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[GLGlobalAccountGLAccount] DROP CONSTRAINT [DF__GLGlobalA__Impor__3D02F129]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLGlobalAccountGLAccount]') AND type in (N'U'))
BEGIN
DROP TABLE [Gdm].[GLGlobalAccountGLAccount]
PRINT 'The [Gdm].[GLGlobalAccountGLAccount] table has been dropped'
END
GO

-- [Gdm].[GLGlobalAccountTranslationSubType]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__GLGlobalA__Impor__57B6E765]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[GLGlobalAccountTranslationSubType] DROP CONSTRAINT [DF__GLGlobalA__Impor__57B6E765]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLGlobalAccountTranslationSubType]') AND type in (N'U'))
BEGIN
DROP TABLE [Gdm].[GLGlobalAccountTranslationSubType]
PRINT 'The [Gdm].[GLGlobalAccountTranslationSubType] table has been dropped'
END
GO

-- [Gdm].[GLGlobalAccountTranslationType]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__GLGlobalA__Impor__599F2FD7]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[GLGlobalAccountTranslationType] DROP CONSTRAINT [DF__GLGlobalA__Impor__599F2FD7]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLGlobalAccountTranslationType]') AND type in (N'U'))
BEGIN
DROP TABLE [Gdm].[GLGlobalAccountTranslationType]
PRINT 'The [Gdm].[GLGlobalAccountTranslationType] table has been dropped'
END
GO

-- [Gdm].[GLTranslationSubType]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__GLTransla__Impor__5D6FC0BB]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[GLTranslationSubType] DROP CONSTRAINT [DF__GLTransla__Impor__5D6FC0BB]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLTranslationSubType]') AND type in (N'U'))
BEGIN
DROP TABLE [Gdm].[GLTranslationSubType]
PRINT 'The [Gdm].[GLTranslationSubType] table has been dropped'
END
GO

-- [Gdm].[GLTranslationType]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__GLTransla__Impor__5B877849]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[GLTranslationType] DROP CONSTRAINT [DF__GLTransla__Impor__5B877849]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLTranslationType]') AND type in (N'U'))
BEGIN
DROP TABLE [Gdm].[GLTranslationType]
PRINT 'The [Gdm].[GLTranslationType] table has been dropped'
END
GO

-- [Gdm].[SnapshotGLAccountSubType]
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLAccountSubType]') AND type in (N'U'))
BEGIN
DROP TABLE [Gdm].[SnapshotGLAccountSubType]
PRINT 'The [Gdm].[SnapshotGLAccountSubType] table has been dropped'
END
GO

-- [Gdm].[SnapshotGLAccountType]
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLAccountType]') AND type in (N'U'))
BEGIN
DROP TABLE [Gdm].[SnapshotGLAccountType]
PRINT 'The [Gdm].[SnapshotGLAccountType] table has been dropped'
END
GO

-- [Gdm].[SnapshotGLGlobalAccountGLAccount]
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLGlobalAccountGLAccount]') AND type in (N'U'))
BEGIN
DROP TABLE [Gdm].[SnapshotGLGlobalAccountGLAccount]
PRINT 'The [Gdm].[SnapshotGLGlobalAccountGLAccount] table has been dropped'
END
GO

-- [Gdm].[SnapshotGLGlobalAccountTranslationSubType]
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLGlobalAccountTranslationSubType]') AND type in (N'U'))
BEGIN
DROP TABLE [Gdm].[SnapshotGLGlobalAccountTranslationSubType]
PRINT 'The [Gdm].[SnapshotGLGlobalAccountTranslationSubType] table has been dropped'
END
GO

-- [Gdm].[SnapshotGLGlobalAccountTranslationType]
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLGlobalAccountTranslationType]') AND type in (N'U'))
BEGIN
DROP TABLE [Gdm].[SnapshotGLGlobalAccountTranslationType]
PRINT 'The [Gdm].[SnapshotGLGlobalAccountTranslationType] table has been dropped'
END
GO

-- [Gdm].[SnapshotGLTranslationSubType]
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLTranslationSubType]') AND type in (N'U'))
BEGIN
DROP TABLE [Gdm].[SnapshotGLTranslationSubType]
PRINT 'The [Gdm].[SnapshotGLTranslationSubType] table has been dropped'
END
GO

-- [Gdm].[SnapshotGLTranslationType]
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLTranslationType]') AND type in (N'U'))
BEGIN
DROP TABLE [Gdm].[SnapshotGLTranslationType]
PRINT 'The [Gdm].[SnapshotGLTranslationType] table has been dropped'
END
GO

--[Gdm].[SnapshotGLStatutoryType]
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLStatutoryType]') AND type in (N'U'))
BEGIN
DROP TABLE [Gdm].[SnapshotGLStatutoryType]
PRINT 'The [Gdm].[SnapshotGLStatutoryType] table has been dropped'
END
GO

-- [SnapshotPropertyGLAccountGLGlobalAccount]
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotPropertyGLAccountGLGlobalAccount]') AND type in (N'U'))
BEGIN
DROP TABLE [Gdm].[SnapshotPropertyGLAccountGLGlobalAccount]
PRINT 'The [Gdm].[SnapshotPropertyGLAccountGLGlobalAccount] table has been dropped'
END
GO

--[Gdm].[SnapshotRechargeCorporateDepartmentPropertyEntity]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotRechargeCorporateDepartmentPropertyEntity]') AND type in (N'U'))
BEGIN
DROP TABLE [Gdm].[SnapshotRechargeCorporateDepartmentPropertyEntity]
PRINT 'The [Gdm].[SnapshotRechargeCorporateDepartmentPropertyEntity] table has been dropped'
END
GO

--[BudgetingCorp].[GlobalReportingCorporateBudget]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BudgetingCorp].[GlobalReportingCorporateBudget]') AND type in (N'U'))
BEGIN
DROP TABLE [BudgetingCorp].[GlobalReportingCorporateBudget]
PRINT 'The [BudgetingCorp].[GlobalReportingCorporateBudget] table has been dropped'
END
GO



/*
GDM Schema Updates
*/

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ProfitabilityBudgetUnknowns' AND TABLE_SCHEMA = 'dbo' AND COLUMN_NAME = 'GlobalGLCategorizationHierarchyKey')
BEGIN
	
	ALTER TABLE dbo.ProfitabilityBudgetUnknowns
		ADD 
			[GlobalGLCategorizationHierarchyKey] [int] NULL,
			[EUDevelopmentGLCategorizationHierarchyKey] [int] NULL,
			[EUPropertyGLCategorizationHierarchyKey] [int] NULL,
			[EUFundGLCategorizationHierarchyKey] [int] NULL,
			[USDevelopmentGLCategorizationHierarchyKey] [int] NULL,
			[USPropertyGLCategorizationHierarchyKey] [int] NULL,
			[USFundGLCategorizationHierarchyKey] [int] NULL,
			[ReportingGLCategorizationHierarchyKey] [int] NULL
		
		PRINT 'The new GLCategorizationHierarchy fields have been added to ProfitabilityBudgetUnknowns'
			
	ALTER TABLE dbo.ProfitabilityBudgetUnknowns
		DROP COLUMN
			[GlAccountKey],
			[EUCorporateGlAccountCategoryKey],
			[USPropertyGlAccountCategoryKey],
			[USFundGlAccountCategoryKey],
			[EUPropertyGlAccountCategoryKey],
			[USCorporateGlAccountCategoryKey],
			[DevelopmentGlAccountCategoryKey],
			[EUFundGlAccountCategoryKey],
			[GlobalGlAccountCategoryKey]
			
	PRINT 'The old GlAccount Category fields have been removed from ProfitabilityBudgetUnknowns'

END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ProfitabilityReforecastUnknowns' AND TABLE_SCHEMA = 'dbo' AND COLUMN_NAME = 'GlobalGLCategorizationHierarchyKey')
BEGIN
	
	ALTER TABLE dbo.ProfitabilityReforecastUnknowns
		ADD 
			[GlobalGLCategorizationHierarchyKey] [int] NULL,
			[EUDevelopmentGLCategorizationHierarchyKey] [int] NULL,
			[EUPropertyGLCategorizationHierarchyKey] [int] NULL,
			[EUFundGLCategorizationHierarchyKey] [int] NULL,
			[USDevelopmentGLCategorizationHierarchyKey] [int] NULL,
			[USPropertyGLCategorizationHierarchyKey] [int] NULL,
			[USFundGLCategorizationHierarchyKey] [int] NULL,
			[ReportingGLCategorizationHierarchyKey] [int] NULL
		
		PRINT 'The new GLCategorizationHierarchy fields have been added to ProfitabilityReforecastUnknowns'
			
	ALTER TABLE dbo.ProfitabilityReforecastUnknowns	
		DROP COLUMN
			[GlAccountKey],
			[EUCorporateGlAccountCategoryKey],
			[USPropertyGlAccountCategoryKey],
			[USFundGlAccountCategoryKey],
			[EUPropertyGlAccountCategoryKey],
			[USCorporateGlAccountCategoryKey],
			[DevelopmentGlAccountCategoryKey],
			[EUFundGlAccountCategoryKey],
			[GlobalGlAccountCategoryKey]
			
	PRINT 'The old GlAccount Category fields have been removed from ProfitabilityReforecastUnknowns'

END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = 'SourceSystemKey' AND TABLE_NAME = 'ProfitabilityBudgetUnknowns')
BEGIN

	EXEC sp_rename 'dbo.ProfitabilityBudgetUnknowns.SourceSystemId', 'SourceSystemKey', 'COLUMN';
	
	PRINT 'SourceSystemId column renamed to SourceSystemKey in the ProfitabilityBudgetUnknowns table' 
END
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = 'SourceSystemKey' AND TABLE_NAME = 'ProfitabilityReforecastUnknowns')
BEGIN

	EXEC sp_rename 'dbo.ProfitabilityReforecastUnknowns.SourceSystemId', 'SourceSystemKey', 'COLUMN';
	
	PRINT 'SourceSystemId column renamed to SourceSystemKey in the ProfitabilityReforecastUnknowns table' 
END
GO

-- Gdm.AllocationSubRegion

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'AllocationSubRegion' AND TABLE_SCHEMA = 'Gdm' AND COLUMN_NAME = 'DefaultCorporateSourceCode')
BEGIN
	
	ALTER TABLE Gdm.AllocationSubRegion 
		ADD DefaultCorporateSourceCode CHAR(2) NULL
	PRINT 'The DefaultCorporateSourceCode column has been added to the [Gdm].[AllocationSubRegion] table'

END

-- Gdm.GlGlobalAccount

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GlGlobalAccount' AND TABLE_SCHEMA = 'Gdm' AND COLUMN_NAME = 'ParentGLGlobalAccountId')
BEGIN
	
	ALTER TABLE Gdm.GlGlobalAccount
		ADD	ParentGLGlobalAccountId INT NULL
		
	PRINT 'The ParentGLGlobalAccountId column haS been added to the [Gdm].[GlGlobalAccoun] table'
	
	ALTER TABLE Gdm.GlGlobalAccount
		DROP COLUMN 
			[Description],
			GLStatutoryTypeId,
			IsGr
	
	PRINT 'The Description, GLStatutoryTypeId & IsGr columns have been removed from the [Gdm].[GlGlobalAccoun] table'

END

-- Gdm.SnapshotGlAccount'

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SnapshotGlAccount' AND TABLE_SCHEMA = 'Gdm' AND COLUMN_NAME = 'UpdatedByStaffId')
BEGIN
	DROP TABLE [Gdm].[SnapshotGLAccount]
	PRINT '[Gdm].[SnapshotGLAccount] table has been dropped'
END
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SnapshotGlAccount' AND TABLE_SCHEMA = 'Gdm' AND COLUMN_NAME = 'IsGlobalReporting')
BEGIN
	
	
	CREATE TABLE [Gdm].[SnapshotGLAccount](
		[SnapshotId] [int] NOT NULL,
		[Code] [varchar](15) NOT NULL,
		[SourceCode] [char](2) NOT NULL,
		[Name] [nvarchar](120) NULL,
		[Type] [char](1) NULL,
		[IsHistoric] [bit] NULL,
		[IsGlobalReporting] [bit] NULL,
		[IsActive] [bit] NULL,
		[LastDate] [datetime2](0) NULL,
		[GLAccountId] [int] NOT NULL,
		[GLGlobalAccountId] [int] NULL,
		[EnglishName] [nvarchar](120) NULL,
		[IsServiceCharge] [bit] NULL,
		[IsDirectRecharge] [bit] NULL,
		[InsertedDate] [datetime2](0) NOT NULL,
		[UpdatedDate] [datetime2](0) NOT NULL,
		[UpdatedByStaffId] [int] NOT NULL,
	 CONSTRAINT [PK_SnapshotGLAccount] PRIMARY KEY CLUSTERED 
	(
		[GLAccountId] ASC,
		[SnapshotId] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	)
		

END

-- Gdm.SnapshotRestrictedFunctionalDepartmentCorporateEntity

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotRestrictedFunctionalDepartmentCorporateEntity]') AND type in (N'U'))
BEGIN

	CREATE TABLE [Gdm].[SnapshotRestrictedFunctionalDepartmentCorporateEntity](
		[SnapshotId] [int] NOT NULL,
		[RestrictedFunctionalDepartmentCorporateEntityId] [int] NOT NULL,
		[CorporateEntityCode] [char](6) NOT NULL,
		[CorporateEntitySourceCode] [char](2) NOT NULL,
		[FunctionalDepartmentId] [int] NOT NULL,
		[InsertedDate] [datetime2](0) NOT NULL,
		[UpdatedDate] [datetime2](0) NOT NULL,
		[UpdatedByStaffId] [int] NOT NULL,
	 CONSTRAINT [PK_SnapshotRestrictedFunctionalDepartmentCorporateEntity] PRIMARY KEY CLUSTERED 
	(
		[SnapshotId] ASC,
		[RestrictedFunctionalDepartmentCorporateEntityId] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
	) ON [PRIMARY]
	
	PRINT '[Gdm].[SnapshotRestrictedFunctionalDepartmentCorporateEntity] table created'
END
-- Gdm.GLMajorCategory

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GLMajorCategory' AND TABLE_SCHEMA = 'Gdm' AND COLUMN_NAME = 'AllowCorporateDepartmentExceptions')
BEGIN
	
	ALTER TABLE Gdm.GLMajorCategory
		ADD
			AllowCorporateDepartmentExceptions BIT NULL,
			Code VARCHAR(50) NULL,
			GLCategorizationId INT NULL,
			GLFinancialCategoryId INT NULL,
			OrderedCode VARCHAR(10) NULL
			
	PRINT 'The new columns have been added to the [Gdm].[GLMajorCategory] table'
	
	ALTER TABLE Gdm.GLMajorCategory
		DROP COLUMN 
			GLTranslationSubTypeId
	
	PRINT 'The GLTranslationSubTypeId column has been removed from the [Gdm].[GLMajorCategory] table'
	
	ALTER TABLE Gdm.GLMajorCategory
		ALTER COLUMN [Name] VARCHAR(400) NOT NULL

END

-- Gdm.GLMinorCategory

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GLMinorCategory' AND TABLE_SCHEMA = 'Gdm' AND COLUMN_NAME = 'ExpenseCzarStaffId')
BEGIN
	
	ALTER TABLE Gdm.GLMinorCategory
		ADD
			Code VARCHAR(50) NULL,
			ExpenseCzarStaffId INT NULL,
			RecurringExpenseStatusId INT NULL,
			OrderedCode VARCHAR(10) NULL
			
	PRINT 'The new columns have been added to the [Gdm].[GLMinorCategory] table'

	ALTER TABLE Gdm.GLMinorCategory
		ALTER COLUMN [Name] VARCHAR(400) NOT NULL
END

-- Gdm.PropertyFund

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PropertyFund' AND TABLE_SCHEMA = 'Gdm' AND COLUMN_NAME = 'DefaultGLTranslationSubTypeId')
BEGIN
	
	ALTER TABLE Gdm.PropertyFund
		DROP COLUMN 
			DefaultGLTranslationSubTypeId
	
	PRINT 'The DefaultGLTranslationSubTypeId column has been removed from the [Gdm].[PropertyFund] table'
	
	ALTER TABLE Gdm.PropertyFund
		ALTER COLUMN 
			RegionalOwnerStaffId INT NULL
	
	PRINT 'The RegionalOwnerStaffId column in the [Gdm].[PropertyFund] table has been altered to allow NULLS'
	
	ALTER TABLE Gdm.PropertyFund
		ALTER COLUMN 
			BudgetOwnerStaffId INT NULL
	
	PRINT 'The BudgetOwnerStaffId column in the [Gdm].[PropertyFund] table has been altered to allow NULLS'

END

-- Gdm.ReportingEntityPropertyEntity

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ReportingEntityPropertyEntity' AND TABLE_SCHEMA = 'Gdm' AND COLUMN_NAME = 'IsPrimary')
BEGIN
	
	ALTER TABLE Gdm.ReportingEntityPropertyEntity
		ADD 
			IsPrimary BIT NULL,
			IsActualsPrimary BIT NULL
			
	PRINT 'The IsPrimary column has been added to the [Gdm].[ReportingEntityPropertyEntity] table'
	
	ALTER TABLE Gdm.ReportingEntityPropertyEntity
		DROP COLUMN IsDeleted
			
	PRINT 'The IsDeleted column has been dropped from the [Gdm].[ReportingEntityPropertyEntity] table'

END

-- Gdm.ReportingEntityCorporateDepartment

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ReportingEntityCorporateDepartment' AND TABLE_SCHEMA = 'Gdm' AND COLUMN_NAME = 'IsDeleted')
BEGIN
	

	ALTER TABLE Gdm.ReportingEntityCorporateDepartment
		DROP COLUMN IsDeleted
			
	PRINT 'The IsDeleted column has been dropped from the [Gdm].[ReportingEntityCorporateDepartment] table'

END

-- Gdm.OriginatingRegionCorporateEntity

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'OriginatingRegionCorporateEntity' AND TABLE_SCHEMA = 'Gdm' AND COLUMN_NAME = 'IsDeleted')
BEGIN
	
	ALTER TABLE Gdm.OriginatingRegionCorporateEntity
		DROP COLUMN IsDeleted
			
	PRINT 'The IsDeleted column has been dropped from the [Gdm].[OriginatingRegionCorporateEntity] table'

END

-- Gdm.OriginatingRegionPropertyDepartment

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'OriginatingRegionPropertyDepartment' AND TABLE_SCHEMA = 'Gdm' AND COLUMN_NAME = 'IsDeleted')
BEGIN
	
	ALTER TABLE Gdm.OriginatingRegionPropertyDepartment
		DROP COLUMN IsDeleted
			
	PRINT 'The IsDeleted column has been dropped from the [Gdm].[OriginatingRegionPropertyDepartment] table'

END

-- Gdm.Snapshot

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'Gdm' AND TABLE_NAME = 'Snapshot' AND COLUMN_NAME = 'GroupKey' AND DATA_TYPE = 'varchar')
BEGIN

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Gdm].[Snapshot]') AND name = N'UX_Snapshot_GroupKey')
	BEGIN
		ALTER TABLE [Gdm].[Snapshot] DROP CONSTRAINT [UX_Snapshot_GroupKey]
	END

	ALTER TABLE Gdm.Snapshot
		ALTER COLUMN GroupKey INT NOT NULL

	ALTER TABLE [Gdm].[Snapshot] ADD  CONSTRAINT [UX_Snapshot_GroupKey] UNIQUE NONCLUSTERED 
	(
		[GroupName] ASC,
		[GroupKey] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

	PRINT ('Gdm.Snapshot.GroupKey updated from VARCHAR to INT - UX_Snapshot_GroupKey dropped and re-created')

END

-- Gdm.SnapshotActivityType

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SnapshotActivityType' AND TABLE_SCHEMA = 'Gdm' AND (COLUMN_NAME = 'ActivityTypeCode' OR COLUMN_NAME = 'GLSuffix'))
BEGIN
	
	ALTER TABLE Gdm.SnapshotActivityType
		ADD GLSuffix CHAR(2) NULL

	ALTER TABLE Gdm.SnapshotActivityType
		ADD ActivityTypeCode VARCHAR(10) NULL
	
	PRINT 'The ActivityTypeCode and GLSuffix columns has been added to the [Gdm].[SnapshotActivityType] table'

END
GO


-- Gdm.SnapshotAllocationSubRegion

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SnapshotAllocationSubRegion' AND TABLE_SCHEMA = 'Gdm' AND COLUMN_NAME = 'DefaultCorporateSourceCode')
BEGIN
	
	ALTER TABLE Gdm.SnapshotAllocationSubRegion
		ADD DefaultCorporateSourceCode CHAR(2) NULL
	PRINT 'The DefaultCorporateSourceCode column has been added to the [Gdm].[SnapshotAllocationSubRegion] table'

END
GO

-- Gdm.SnapshotGlGlobalAccount

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SnapshotGlGlobalAccount' AND TABLE_SCHEMA = 'Gdm' AND COLUMN_NAME = 'ExpenseCzarStaffId')
BEGIN
		
	ALTER TABLE Gdm.SnapshotGlGlobalAccount
		DROP COLUMN 
			[Description],
			ExpenseCzarStaffId,
			GLStatutoryTypeId,
			IsGr,
			ParentCode
	
	PRINT 'The columns have been removed from the [Gdm].[SnapshotGlGlobalAccoun] table'

END


-- Gdm.SnapshotMajorCategory

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SnapshotGLMajorCategory' AND TABLE_SCHEMA = 'Gdm' AND COLUMN_NAME = 'AllowCorporateDepartmentExceptions')
BEGIN
	
	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLMajorCategory]') AND name = N'UX_SnapshotGLMajorCategory_Name')
		ALTER TABLE [Gdm].[SnapshotGLMajorCategory] DROP CONSTRAINT [UX_SnapshotGLMajorCategory_Name]
		
	ALTER TABLE Gdm.SnapshotGLMajorCategory
		ADD
			AllowCorporateDepartmentExceptions BIT NULL,
			Code VARCHAR(50) NULL,
			GLCategorizationId INT NULL,
			GLFinancialCategoryId INT NULL
			
	PRINT 'The new columns have been added to the [Gdm].[SnapshotGLMajorCategory] table'
	
	ALTER TABLE Gdm.SnapshotGLMajorCategory
		DROP COLUMN 
			GLTranslationSubTypeId
	
	PRINT 'The GLTranslationSubTypeId column has been removed from the [Gdm].[SnapshotGLMajorCategory] table'
	

END
GO
-- Gdm.SnapshotGLMinorCategory

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SnapshotGLMinorCategory' AND TABLE_SCHEMA = 'Gdm' AND COLUMN_NAME = 'ExpenseCzarStaffId')
BEGIN
	
	ALTER TABLE Gdm.SnapshotGLMinorCategory
		ADD
			Code VARCHAR(50) NULL,
			ExpenseCzarStaffId INT NULL,
			RecurringExpenseStatusId INT NULL
	
	
	PRINT 'The new columns have been added to the [Gdm].[SnapshotGLMinorCategory] table'

END
GO

IF NOT EXISTS(SELECT * FROM	INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SnapshotGLMinorCategory' AND	TABLE_SCHEMA = 'Gdm' AND COLUMN_NAME = 'Name' AND CHARACTER_MAXIMUM_LENGTH = 400)
BEGIN

	ALTER TABLE Gdm.SnapshotGLMinorCategory
		ALTER COLUMN [Name] VARCHAR(400) NOT NULL
	
	PRINT 'SnapshotGLMinorCategory Name column changed to allow a maximum of 400 characters'	
END
GO

IF NOT EXISTS(SELECT * FROM	INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SnapshotGLMajorCategory' AND	TABLE_SCHEMA = 'Gdm' AND COLUMN_NAME = 'Name' AND CHARACTER_MAXIMUM_LENGTH = 400)
BEGIN

	ALTER TABLE Gdm.SnapshotGLMajorCategory
		ALTER COLUMN [Name] VARCHAR(400) NOT NULL
	
	PRINT 'SnapshotGLMajorCategory Name column changed to allow a maximum of 400 characters'	
END
GO
-- Gdm.SnapshotPropertyEntityException

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SnapshotPropertyEntityException' AND TABLE_SCHEMA = 'Gdm' AND COLUMN_NAME = 'GLCategorizationId')
BEGIN
	
	ALTER TABLE Gdm.SnapshotPropertyEntityException
		ADD
			GLCategorizationId INT NULL,
			PropertyFundId INT NULL,
			PropertyGLAccountId INT NULL
			
	PRINT 'The new columns have been added to the [Gdm].[SnapshotPropertyEntityException] table'
	
	ALTER TABLE Gdm.SnapshotPropertyEntityException
		DROP COLUMN 
			PropertyBudgetTypeId,
			PropertyEntityCode,
			PropertyGLAccountCode,
			SourceCode
	
	PRINT 'The columns have been removed from the [Gdm].[SnapshotPropertyEntityException] table'

END
GO
-- Gdm.SnapshotPropertyFund

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SnapshotPropertyFund' AND TABLE_SCHEMA = 'Gdm' AND COLUMN_NAME = 'DefaultGLTranslationSubTypeId')
BEGIN
	
	ALTER TABLE Gdm.SnapshotPropertyFund
		DROP COLUMN 
			DefaultGLTranslationSubTypeId
	
	PRINT 'The DefaultGLTranslationSubTypeId column has been removed from the [Gdm].[SnapshotPropertyFund] table'
	
	ALTER TABLE Gdm.SnapshotPropertyFund
		ALTER COLUMN 
			RegionalOwnerStaffId INT NULL
	
	PRINT 'The RegionalOwnerStaffId column in the [Gdm].[SnapshotPropertyFund] table has been altered to allow NULLS'
	
	ALTER TABLE Gdm.SnapshotPropertyFund
		ALTER COLUMN 
			BudgetOwnerStaffId INT NULL
	
	PRINT 'The BudgetOwnerStaffId column in the [Gdm].[SnapshotPropertyFund] table has been altered to allow NULLS'

END
GO
-- GDM.SnapshotPropertyOverheadPropertyGLAccount

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SnapshotPropertyOverheadPropertyGLAccount' AND TABLE_SCHEMA = 'Gdm' AND COLUMN_NAME = 'GLCategorizationId')
BEGIN

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotPropertyOverheadPropertyGLAccount]') AND name = N'IX_SnapshotPropertyOverheadPropertyGLAccount_Unique')
	ALTER TABLE [Gdm].[SnapshotPropertyOverheadPropertyGLAccount] DROP CONSTRAINT [IX_SnapshotPropertyOverheadPropertyGLAccount_Unique]
	
	
	ALTER TABLE Gdm.SnapshotPropertyOverheadPropertyGLAccount
		ADD
			GLCategorizationId INT NULL,
			GLGlobalAccountId INT NULL,
			PropertyGLAccountId INT NULL
			
	PRINT 'The new columns have been added to the [Gdm].[SnapshotPropertyOverheadPropertyGLAccount] table'
	
	ALTER TABLE Gdm.SnapshotPropertyOverheadPropertyGLAccount
		DROP COLUMN 
			PropertyBudgetTypeId,
			PropertyGLAccountCode,
			SourceCode
	
	PRINT 'The columns have been removed from the [Gdm].[SnapshotPropertyOverheadPropertyGLAccount] table'

END
GO
-- GDM.SnapshotPropertyPayrollPropertyGlAccount

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SnapshotPropertyPayrollPropertyGlAccount' AND TABLE_SCHEMA = 'Gdm' AND COLUMN_NAME = 'GLCategorizationId')
BEGIN

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotPropertyPayrollPropertyGLAccount]') AND name = N'IX_SnapshotPropertyPayrollPropertyGLAccount_Unique')
	ALTER TABLE [Gdm].[SnapshotPropertyPayrollPropertyGLAccount] DROP CONSTRAINT [IX_SnapshotPropertyPayrollPropertyGLAccount_Unique]
	

	ALTER TABLE Gdm.SnapshotPropertyPayrollPropertyGlAccount
		ADD
			GLCategorizationId INT NULL,
			GLGlobalAccountId INT NULL,
			GLMinorCategoryId INT NULL,
			PropertyGLAccountId INT NULL
			
	PRINT 'The new columns have been added to the [Gdm].[SnapshotPropertyPayrollPropertyGlAccount] table'
	
	ALTER TABLE Gdm.SnapshotPropertyPayrollPropertyGlAccount
		DROP COLUMN 
			PropertyBudgetTypeId,
			PropertyGLAccountCode,
			SourceCode
	
	PRINT 'The columns have been removed from the [Gdm].[SnapshotPropertyPayrollPropertyGlAccount] table'
	
	ALTER TABLE Gdm.SnapshotPropertyPayrollPropertyGlAccount
		ALTER COLUMN InsertedDate DATETIME2(0) NOT NULL
		
	ALTER TABLE Gdm.SnapshotPropertyPayrollPropertyGlAccount	
		ALTER COLUMN UpdatedDate DATETIME2(0) NOT NULL
	
	PRINT 'The Inserted Date and Updated Date columns in the [Gdm].[SnapshotPropertyPayrollPropertyGlAccount] table have been converted to DATETIME2'


END
GO
-- GDM.SnapshotRegionalAdministratorGlobalSubRegion

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SnapshotRegionalAdministratorGlobalSubRegion' AND TABLE_SCHEMA = 'Gdm' AND COLUMN_NAME = 'GlobalRegionId')
BEGIN

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotRegionalAdministratorGlobalSubRegion]') AND name = N'PK_SnapshotRegionalAdministratorGlobalSubRegion')
	ALTER TABLE [Gdm].[SnapshotRegionalAdministratorGlobalSubRegion] DROP CONSTRAINT [PK_SnapshotRegionalAdministratorGlobalSubRegion]
	
	EXEC sp_rename 'Gdm.SnapshotRegionalAdministratorGlobalSubRegion.GlobalSubRegionId', 'GlobalRegionId', 'COLUMN'
	
	PRINT 'The GlobalSubRegionId column has been renamed to GlobalRegionId in the [Gdm].[SnapshotRegionalAdministratorGlobalSubRegion] table'
	
	ALTER TABLE [Gdm].[SnapshotRegionalAdministratorGlobalSubRegion] ADD  CONSTRAINT [PK_SnapshotRegionalAdministratorGlobalSubRegion] PRIMARY KEY CLUSTERED 
	(
		[SnapshotId] ASC,
		[StaffId] ASC,
		[GlobalRegionId] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	
	

END
GO
-- Gdm.SnapshotReportingEntityPropertyEntity

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SnapshotReportingEntityPropertyEntity' AND TABLE_SCHEMA = 'Gdm' AND (COLUMN_NAME = 'IsPrimary' OR COLUMN_NAME = 'IsActualsPrimary'))
BEGIN
	
	ALTER TABLE Gdm.SnapshotReportingEntityPropertyEntity
		ADD 
			IsPrimary BIT NULL,
			IsActualsPrimary BIT NULL
		
			
	PRINT 'The IsPrimary & IsActualsPrimary columns have been added to the [Gdm].[SnapshotReportingEntityPropertyEntity] table'
	
	ALTER TABLE Gdm.SnapshotReportingEntityPropertyEntity
		DROP COLUMN IsDeleted
			
	PRINT 'The IsDeleted column has dropped from the [Gdm].[SnapshotReportingEntityPropertyEntity] table'

END
GO

-- Gdm.SnapshotReportingEntityCorporateDepartment

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SnapshotReportingEntityCorporateDepartment' AND TABLE_SCHEMA = 'Gdm' AND COLUMN_NAME = 'IsDeleted')
BEGIN
	

	ALTER TABLE Gdm.SnapshotReportingEntityCorporateDepartment
		DROP COLUMN IsDeleted
			
	PRINT 'The IsDeleted column has been dropped from the [Gdm].[SnapshotReportingEntityCorporateDepartment] table'

END

-- Gdm.SnapshotOriginatingRegionCorporateEntity

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SnapshotOriginatingRegionCorporateEntity' AND TABLE_SCHEMA = 'Gdm' AND COLUMN_NAME = 'IsDeleted')
BEGIN
	
	ALTER TABLE Gdm.SnapshotOriginatingRegionCorporateEntity
		DROP COLUMN IsDeleted
			
	PRINT 'The IsDeleted column has been dropped from the [Gdm].[SnapshotOriginatingRegionCorporateEntity] table'

END

-- Gdm.SnapshotOriginatingRegionPropertyDepartment

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SnapshotOriginatingRegionPropertyDepartment' AND TABLE_SCHEMA = 'Gdm' AND COLUMN_NAME = 'IsDeleted')
BEGIN
	
	ALTER TABLE Gdm.SnapshotOriginatingRegionPropertyDepartment
		DROP COLUMN IsDeleted
			
	PRINT 'The IsDeleted column has been dropped from the [Gdm].[SnapshotOriginatingRegionPropertyDepartment] table'

END

/*
GBS Changes
*/

PRINT '
----------------------------------------------------------------
GBS Changes
----------------------------------------------------------------'

-- GBS.Budget

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Budget' AND TABLE_SCHEMA = 'GBS' AND COLUMN_NAME = 'SnapshotId')
BEGIN

	
	ALTER TABLE GBS.Budget
		ADD 
			IsDisplayedOnPortlet BIT,
			PriorSnapshotId INT,
			SnapshotId INT
	
	PRINT 'New columns were added to the GBS.Budget table'
END


IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Budget' AND TABLE_SCHEMA = 'GBS' AND COLUMN_NAME = 'MustEmailOwners')
BEGIN

	
	ALTER TABLE GBS.Budget ADD MustEmailOwners BIT
	
	PRINT 'MustEmailOwners added to the GBS.Budget table'
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Budget' AND TABLE_SCHEMA = 'GBS' AND COLUMN_NAME = 'MustEmailOriginators')
BEGIN

	
	ALTER TABLE GBS.Budget ADD MustEmailOriginators BIT
	
	PRINT 'MustEmailOriginators added to the GBS.Budget table'
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Budget' AND TABLE_SCHEMA = 'GBS' AND COLUMN_NAME = 'CanCreateDisputes')
BEGIN

	
	ALTER TABLE GBS.Budget ADD CanCreateDisputes BIT
	
	PRINT 'CanCreateDisputes added to the GBS.Budget table'
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Budget' AND TABLE_SCHEMA = 'GBS' AND COLUMN_NAME = 'CanRedispute')
BEGIN

	
	ALTER TABLE GBS.Budget ADD CanRedispute BIT
	
	PRINT 'CanRedispute added to the GBS.Budget table'
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Budget' AND TABLE_SCHEMA = 'GBS' AND COLUMN_NAME = 'IsFeeOriginatorReadOnly')
BEGIN

	
	ALTER TABLE GBS.Budget ADD IsFeeOriginatorReadOnly BIT
	
	PRINT 'IsFeeOriginatorReadOnly added to the GBS.Budget table'
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Budget' AND TABLE_SCHEMA = 'GBS' AND COLUMN_NAME = 'CanImportBudgetIntoGr')
BEGIN

	EXEC sp_rename 'GBS.Budget.ImportBudgetIntoGr', 'CanImportBudgetIntoGr', 'COLUMN'
	
	PRINT 'The ImportBudgetIntoGr column has been renamed to CanImportBudgetIntoGr in the GBS.Budget table'
	
END
GO
-- GBS.BudgetCategory

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'BudgetCategory' AND TABLE_SCHEMA = 'GBS' AND COLUMN_NAME = 'IsActive')
BEGIN
	
	ALTER TABLE GBS.BudgetCategory
		DROP COLUMN IsActive
			
	PRINT 'The IsActive column has been removed from the GBS.BudgetCategory table'

END
GO
-- GBS.BudgetProfitabilityActual

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'BudgetProfitabilityActual' AND TABLE_SCHEMA = 'GBS' AND COLUMN_NAME = 'SnapshotId')
BEGIN

	EXEC sp_rename 'GBS.BudgetProfitabilityActual.CorporateDepartmentCode', 'PropertyFundCode', 'COLUMN'
	
	ALTER TABLE GBS.BudgetProfitabilityActual
		ADD 
			IsDirectCost BIT,
			SnapshotId INT
	
	PRINT 'New columns were added to the GBS.BudgetProfitabilityActual table'
	
	ALTER TABLE GBS.BudgetProfitabilityActual
		DROP COLUMN BudgetCategoryId
			
	PRINT 'The BudgetCategoryId column has been removed from the GBS.BudgetProfitabilityActual table'
	
END
GO

-- GBS.Fee

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Fee' AND TABLE_SCHEMA = 'GBS' AND COLUMN_NAME = 'SnapshotId')
BEGIN

	
	ALTER TABLE GBS.Fee
		ADD 
			SnapshotId INT NULL,
			IsEditable BIT NULL
	
	PRINT 'SnapshotId and IsEditable was added to the GBS.Fee table'
		
	ALTER TABLE GBS.Fee
		DROP COLUMN AllocationSubRegionGlobalRegionId
			
	
	PRINT 'AllocationSubRegionGlobalRegionId was removed from the GBS.Fee table'
END
GO

-- GBS.NonPayrollExpenseBreakdown

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'NonPayrollExpenseBreakdown' AND TABLE_SCHEMA = 'GBS' AND COLUMN_NAME = 'SnapshotId')
BEGIN

	
	ALTER TABLE GBS.NonPayrollExpenseBreakdown
		ADD 
			AmountInDollar MONEY,
			EntityTypeId INT,
			GLFinancialCategoryId INT,
			GlobalGLMajorCategoryId INT,
			GlobalGLMinorCategoryId INT,
			IsDisputed BIT,
			ReportingEntityPropertyFundId INT,
			SnapshotId INT
	
	PRINT 'New columns were added to the GBS.NonPayrollExpenseBreakdown table'
	
	ALTER TABLE GBS.NonPayrollExpenseBreakdown
		DROP COLUMN IsActive
		
	PRINT 'The IsActive column has been removed from the GBS.NonPayrollExpenseBreakdown table'
END

-- GBS.NonPayrollExpense

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'NonPayrollExpense' AND TABLE_SCHEMA = 'GBS' AND COLUMN_NAME = 'NonPayrollExpenseImportItemId')
BEGIN
	ALTER TABLE GBS.NonPayrollExpense
		ADD NonPayrollExpenseImportItemId INT NULL
		
	PRINT 'NonPayrollExpenseImportItemId column added to the GBS.NonPayrollExpense table'
END
-- Indexes


GO
/*
TapasGlobalBudgeting Changes
*/

PRINT '
----------------------------------------------------------------
TapasGlobalBudgeting Changes
----------------------------------------------------------------'

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'BudgetProject' AND TABLE_SCHEMA = 'TapasGlobalBudgeting' AND COLUMN_NAME = 'IsDispositionProject')
BEGIN

	
	ALTER TABLE TapasGlobalBudgeting.BudgetProject
		ADD IsDispositionProject BIT
	
	PRINT 'IsDispositionProject was added to the TapasGlobalBudgeting.BudgetProject table'
END
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'BudgetEmployee' AND TABLE_SCHEMA = 'TapasGlobalBudgeting' AND COLUMN_NAME = 'IsWorkersCompensationOnlyEmployee')
BEGIN

	
	ALTER TABLE TapasGlobalBudgeting.BudgetEmployee
		ADD IsWorkersCompensationOnlyEmployee BIT
	
	PRINT 'IsWorkersCompensationOnlyEmployee was added to the TapasGlobalBudgeting.BudgetEmployee table'
END
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ReforecastActualBilledPayroll' AND TABLE_SCHEMA = 'TapasGlobalBudgeting' AND COLUMN_NAME = 'CorporateDepartmentCode')
BEGIN

	
	ALTER TABLE TapasGlobalBudgeting.ReforecastActualBilledPayroll
		ADD CorporateDepartmentCode VARCHAR(8)
	
	PRINT 'CorporateDepartmentCode was added to the TapasGlobalBudgeting.ReforecastActualBilledPayroll table'
END
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ReforecastActualBilledPayroll' AND TABLE_SCHEMA = 'TapasGlobalBudgeting' AND COLUMN_NAME = 'CorporateSourceCode')
BEGIN

	
	ALTER TABLE TapasGlobalBudgeting.ReforecastActualBilledPayroll
		ADD CorporateSourceCode VARCHAR(2)
	
	PRINT 'CorporateSourceCode was added to the TapasGlobalBudgeting.ReforecastActualBilledPayroll table'
END
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TaxType' AND TABLE_SCHEMA = 'TapasGlobalBudgeting' AND COLUMN_NAME = 'IsDeleted')
BEGIN

	
	ALTER TABLE TapasGlobalBudgeting.TaxType
		ADD IsDeleted BIT
	
	PRINT 'IsDeleted was added to the TapasGlobalBudgeting.TaxType table'
END
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TaxType' AND TABLE_SCHEMA = 'TapasGlobalBudgeting' AND COLUMN_NAME = 'GLAccountCode')
BEGIN

	
	ALTER TABLE TapasGlobalBudgeting.TaxType
		ADD GLAccountCode VARCHAR(15)
	
	PRINT 'GLAccountCode was added to the TapasGlobalBudgeting.TaxType table'
END
GO

/*
TapasGlobal Changes
*/

PRINT '
----------------------------------------------------------------
TapasGlobal Changes
----------------------------------------------------------------'

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'BillingUploadDetail' AND TABLE_SCHEMA = 'TapasGlobal' AND COLUMN_NAME = 'CorporateJobCode')
BEGIN

	
	ALTER TABLE TapasGlobal.BillingUploadDetail
		ADD CorporateJobCode VARCHAR(15) NULL
	
	PRINT 'CorporateJobCode was added to the TapasGlobal.BillingUploadDetail table'
END
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Project' AND TABLE_SCHEMA = 'TapasGlobal' AND COLUMN_NAME = 'AMProjectId')
BEGIN

	
	ALTER TABLE TapasGlobal.Project
		ADD AMProjectId INT NULL
	
	PRINT 'AMProjectId was added to the TapasGlobal.Project table'
END
GO

/*
HR Changes
*/

PRINT '
----------------------------------------------------------------
HR Changes
----------------------------------------------------------------'

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Location' AND TABLE_SCHEMA = 'HR' AND COLUMN_NAME = 'City')
BEGIN

	
	ALTER TABLE Hr.Location
		ADD 
			City VARCHAR(25) NULL,
			CountryId INT NULL,
			UpdatedByStaffId INT NULL
		
	
	PRINT 'City was added to the Hr.Location table'
END
GO

/*
GACS Changes
*/

PRINT '
----------------------------------------------------------------
GACS Changes
----------------------------------------------------------------'

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GACS].[Entity]') AND type in (N'U'))

BEGIN

CREATE TABLE [GACS].[Entity](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[EntityRef] [char](6) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Source] [char](2) NOT NULL,
	[IsActive] [bit] NULL,
	[LastDate] [datetime] NOT NULL,
	[Address] [varchar](1024) NOT NULL,
	[CurrencyCode] [char](3) NOT NULL,
	[DisplayName] [varchar](80) NOT NULL,
	[IsCustom] [bit] NOT NULL,
	[CityID] [int] NOT NULL,
	[ShipAddr] [varchar](512) NULL,
	[BillAddr] [varchar](512) NULL,
	[ProjectRef] [char](8) NULL,
	[IsOutsourced] [bit] NOT NULL,
	[IsRMProperty] [bit] NOT NULL,
	[IsFund] [bit] NOT NULL,
	[IsHistoric] [bit] NOT NULL,
	[FaxNumber] [varchar](25) NULL,
	[VatReg] [varchar](20) NULL,
CONSTRAINT [PK_Entity] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [GACS].[Entity] ADD  CONSTRAINT [DF_Entity_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]

PRINT 'The [GACS].[Entity] table has been created'
END
GO

IF EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GACS].[Department]') AND type in (N'U'))
BEGIN

	
	ALTER TABLE [GACS].[Department] DROP CONSTRAINT [DF_Department_ImportDate]
	ALTER TABLE [GACS].[Department] DROP CONSTRAINT [DF_Department_IsTsCost]
	DROP TABLE [GACS].[Department]
	PRINT 'The [GACS].[Department] table has been dropped'
END
GO

IF ((SELECT DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'FunctionalDepartment' AND COLUMN_NAME = 'GlobalCode') = 'char')
BEGIN
	ALTER TABLE HR.FunctionalDepartment
		ALTER COLUMN GlobalCode VARCHAR(3)
		
	PRINT 'GlobalCode field in HR.FunctionalDepartment table changed from CHAR(3) TO VARCHAR(3)'

END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'FunctionalDepartment' AND COLUMN_NAME = 'UpdatedByStaffId')
BEGIN
	ALTER TABLE HR.FunctionalDepartment
		ADD UpdatedByStaffId INT NULL
		
	PRINT 'UpdatedByStaffId added to the Functional Department table.'
END
/*
Budgets To Process Changes
*/

PRINT '
----------------------------------------------------------------
Budgets To Process Changes
----------------------------------------------------------------'

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'BudgetsToProcess' AND TABLE_SCHEMA = 'dbo' AND COLUMN_NAME = 'IsCurrentBatch')
BEGIN

	ALTER TABLE dbo.BudgetsToProcess
		ADD 
			IsCurrentBatch BIT NULL,
			ReasonForProcessing VARCHAR(1024) NULL
			
	PRINT 'IsCurrentBatch and ReasonForProcessing columns added to the dbo.BudgetsToProcess table'
END
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'BudgetsToProcess' AND TABLE_SCHEMA = 'dbo' AND COLUMN_NAME = 'IsCurrentBatch' AND IS_NULLABLE = 'NO')
BEGIN
	UPDATE dbo.BudgetsToProcess
	SET 
		IsCurrentBatch = 0	
		
	ALTER TABLE dbo.BudgetsToProcess
		ALTER COLUMN IsCurrentBatch BIT NOT NULL 
END
GO

/*
MRI Table Changes
*/

PRINT '
----------------------------------------------------------------
MRI Table Changes
----------------------------------------------------------------'

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GJOB' AND TABLE_SCHEMA = 'USCorp' AND COLUMN_NAME = 'ISGR')
BEGIN

	ALTER TABLE USCorp.GJOB
		ADD 
			ISGR CHAR(1) NULL
			
	PRINT 'ISGR and ReasonForProcessing columns added to the USCorp.GJOB table'
END
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GJOB' AND TABLE_SCHEMA = 'EUCorp' AND COLUMN_NAME = 'ISGR')
BEGIN

	ALTER TABLE EUCorp.GJOB
		ADD 
			ISGR CHAR(1) NULL
			
	PRINT 'ISGR and ReasonForProcessing columns added to the EUCorp.GJOB table'
END
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GJOB' AND TABLE_SCHEMA = 'INCorp' AND COLUMN_NAME = 'ISGR')
BEGIN

	ALTER TABLE INCorp.GJOB
		ADD 
			ISGR CHAR(1) NULL
			
	PRINT 'ISGR and ReasonForProcessing columns added to the INCorp.GJOB table'
END
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GJOB' AND TABLE_SCHEMA = 'BRCorp' AND COLUMN_NAME = 'ISGR')
BEGIN

	ALTER TABLE BRCorp.GJOB
		ADD 
			ISGR CHAR(1) NULL
			
	PRINT 'ISGR and ReasonForProcessing columns added to the BRCorp.GJOB table'
END
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GJOB' AND TABLE_SCHEMA = 'CNCorp' AND COLUMN_NAME = 'ISGR')
BEGIN

	ALTER TABLE CNCorp.GJOB
		ADD 
			ISGR CHAR(1) NULL
			
	PRINT 'ISGR and ReasonForProcessing columns added to the CNCorp.GJOB table'
END
GO

/*
Indexes
*/

PRINT '
----------------------------------------------------------------
Indexes
----------------------------------------------------------------'



IF  NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLGlobalAccountCategorization]') AND name = N'UX_SnapshotGLGlobalAccountCategorization_GLGlobalAccountId')
BEGIN
ALTER TABLE [Gdm].[SnapshotGLGlobalAccountCategorization] 
	ADD CONSTRAINT [UX_SnapshotGLGlobalAccountCategorization_GLGlobalAccountId] UNIQUE NONCLUSTERED 
	(		
		GLGlobalAccountId ASC,
		GLCategorizationId ASC,
		SnapshotId ASC
	)
	PRINT '[UX_SnapshotGLGlobalAccountCategorization_GLGlobalAccount] index created'
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLCategorization]') AND name = N'UX_SnapshotGLCategorization_Name')
ALTER TABLE [Gdm].[SnapshotGLCategorization] 
	ADD  CONSTRAINT [UX_SnapshotGLCategorization_Name] UNIQUE NONCLUSTERED 
	(
		[Name] ASC,
		SnapshotId ASC	
	)
	PRINT '[UX_SnapshotGLCategorization_Name] index created'
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLCategorizationType]') AND name = N'UX_SnapshotGLCategorizationType_Name')
ALTER TABLE [Gdm].[SnapshotGLCategorizationType] 
	ADD  CONSTRAINT [UX_SnapshotGLCategorizationType_Name] UNIQUE NONCLUSTERED 
	(
		[Name] ASC,
		SnapshotId ASC	
	)
	PRINT '[UX_SnapshotGLCategorizationType_Name] index created'
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLFinancialCategory]') AND name = N'UX_SnapshotGLFinancialCategory_Name')
ALTER TABLE [Gdm].[SnapshotGLFinancialCategory] 
	ADD  CONSTRAINT [UX_SnapshotGLFinancialCategory_Name] UNIQUE NONCLUSTERED 
	(
		[Name] ASC,
		GLCategorizationId ASC,
		SnapshotId ASC
		
	)
	PRINT '[UX_SnapshotGLFinancialCategory_Name] index created'
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLMajorCategory]') AND name = N'UX_SnapshotGLMajorCategory_Name')
ALTER TABLE [Gdm].[SnapshotGLMajorCategory] 
	DROP CONSTRAINT [UX_SnapshotGLMajorCategory_Name]
	PRINT '[UX_SnapshotGLMajorCategory_Name] index dropped'
GO


-- This is being done because of the current ordering of the columns

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLMinorCategory]') AND name = N'UX_SnapshotGLMinorCategory_Name')
ALTER TABLE [Gdm].[SnapshotGLMinorCategory] DROP CONSTRAINT [UX_SnapshotGLMinorCategory_Name]
PRINT '[UX_SnapshotGLMinorCategory_Name] index dropped'
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLMinorCategory]') AND name = N'UX_SnapshotGLMinorCategory_Name')
ALTER TABLE [Gdm].[SnapshotGLMinorCategory] 
	ADD CONSTRAINT [UX_SnapshotGLMinorCategory_Name] UNIQUE NONCLUSTERED 
	(
		[Name] ASC,
		[GLMajorCategoryId] ASC,
		[SnapshotId] ASC
	)
	PRINT '[UX_SnapshotGLMinorCategory_Name] index created'
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[GBS].[NonPayrollExpenseBreakdown]') AND name = N'IX_NonPayrollExpenseBreakdown_BudgetId')
CREATE NONCLUSTERED INDEX IX_NonPayrollExpenseBreakdown_BudgetId ON
	[GBS].[NonPayrollExpenseBreakdown] (
		BudgetId ASC,
		ImportBatchId ASC
	)
	PRINT 'IX_NonPayrollExpenseBreakdown_BudgetProjectd_NonPayrollExpenseId index dropped'
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[GBS].[NonPayrollExpenseBreakdown]') AND name = N'IX_NonPayrollExpenseBreakdown_BudgetProjectd_NonPayrollExpenseId')
CREATE NONCLUSTERED INDEX IX_NonPayrollExpenseBreakdown_BudgetProjectd_NonPayrollExpenseId ON
	[GBS].[NonPayrollExpenseBreakdown] (
		NonPayrollExpenseId ASC,
		BudgetProjectId ASC,
		ImportBatchId ASC
	)
	PRINT 'IX_NonPayrollExpenseBreakdown_BudgetProjectd_NonPayrollExpenseId index created'
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Reporting__Impor__4874A3D5]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[ReportingEntity] DROP CONSTRAINT [DF__Reporting__Impor__4874A3D5]
END

GO

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ReportingEntity]') AND type in (N'U'))
BEGIN
DROP TABLE [Gdm].[ReportingEntity]
PRINT '[Gdm].[ReportingEntity] table has been dropped'
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotReportingEntityCorporateDepartment]') AND name = N'IX_SnapshotReportingEntityCorporateDepartment_CorporateDepartmentCode_SourceCode')
CREATE NONCLUSTERED INDEX IX_SnapshotReportingEntityCorporateDepartment_CorporateDepartmentCode_SourceCode ON
	[Gdm].[SnapshotReportingEntityCorporateDepartment] (
		CorporateDepartmentCode ASC,
		SourceCode ASC,
		SnapshotId ASC
	)
	PRINT 'IX_SnapshotReportingEntityCorporateDepartment_CorporateDepartmentCode_SourceCode index created'
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotReportingEntityPropertyEntity]') AND name = N'IX_SnapshotReportingEntityPropertyEntity_PropertyEntityCode_SourceCode')
CREATE NONCLUSTERED INDEX IX_SnapshotReportingEntityPropertyEntity_PropertyEntityCode_SourceCode ON
	[Gdm].[SnapshotReportingEntityPropertyEntity] (
		PropertyEntityCode ASC,
		SourceCode ASC,
		SnapshotId ASC
	)
	PRINT 'IX_SnapshotReportingEntityPropertyEntity_CorporateDepartmentCode_SourceCode index created'
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotConsolidationRegionCorporateDepartment]') AND name = N'IX_SnapshotConsolidationRegionCorporateDepartment_CorporateDepartmentCode_SourceCode')
CREATE NONCLUSTERED INDEX IX_SnapshotConsolidationRegionCorporateDepartment_CorporateDepartmentCode_SourceCode ON
	[Gdm].[SnapshotConsolidationRegionCorporateDepartment] (
		CorporateDepartmentCode ASC,
		SourceCode ASC,
		SnapshotId ASC
	)
	PRINT 'IX_SnapshotConsolidationRegionCorporateDepartment_CorporateDepartmentCode_SourceCode index created'
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotConsolidationRegionPropertyEntity]') AND name = N'IX_SnapshotConsolidationRegionPropertyEntity_PropertyEntityCode_SourceCode')
CREATE NONCLUSTERED INDEX IX_SnapshotConsolidationRegionPropertyEntity_PropertyEntityCode_SourceCode ON
	[Gdm].[SnapshotConsolidationRegionPropertyEntity] (
		PropertyEntityCode ASC,
		SourceCode ASC,
		SnapshotId ASC
	)
	PRINT 'IX_SnapshotConsolidationRegionPropertyEntity_CorporateDepartmentCode_SourceCode index created'
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotPropertyPayrollPropertyGLAccount]') AND name = N'UX_SnapshotPropertyPayrollPropertyGLAccount_Unique')
CREATE NONCLUSTERED INDEX UX_SnapshotPropertyPayrollPropertyGLAccount_Unique ON
	[Gdm].[SnapshotPropertyPayrollPropertyGLAccount] (
		SnapshotId ASC,
		ActivityTypeId ASC,
		FunctionalDepartmentId ASC,
		GLMinorCategoryId ASC,
		PayrollTypeId ASC
		
	)
	PRINT 'UX_SnapshotPropertyPayrollPropertyGLAccount_Unique'
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotPropertyPayrollPropertyGLAccount]') AND name = N'UX_SnapshotPropertyPayrollPropertyGLAccount_ActivityTypeId')
CREATE NONCLUSTERED INDEX UX_SnapshotPropertyPayrollPropertyGLAccount_ActivityTypeId ON
	[Gdm].[SnapshotPropertyPayrollPropertyGLAccount] (
		SnapshotId ASC,
		ActivityTypeId ASC
	)
	PRINT 'UX_SnapshotPropertyPayrollPropertyGLAccount_ActivityTypeId'
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotPropertyPayrollPropertyGLAccount]') AND name = N'UX_SnapshotPropertyPayrollPropertyGLAccount_FunctionalDepartmentId')
CREATE NONCLUSTERED INDEX UX_SnapshotPropertyPayrollPropertyGLAccount_FunctionalDepartmentId ON
	[Gdm].[SnapshotPropertyPayrollPropertyGLAccount] (
		SnapshotId ASC,
		FunctionalDepartmentId ASC
	)
	PRINT 'UX_SnapshotPropertyPayrollPropertyGLAccount_FunctionalDepartmentId'
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotPropertyOverheadPropertyGLAccount]') AND name = N'UX_SnapshotPropertyOverheadPropertyGLAccount_Unique')
CREATE NONCLUSTERED INDEX UX_SnapshotPropertyOverheadPropertyGLAccount_Unique ON
	[Gdm].[SnapshotPropertyOverheadPropertyGLAccount] (
		SnapshotId ASC,
		ActivityTypeId ASC,
		FunctionalDepartmentId ASC
		
	)
	PRINT 'UX_SnapshotPropertyOverheadPropertyGLAccount_Unique'
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotPropertyOverheadPropertyGLAccount]') AND name = N'UX_SnapshotPropertyOverheadPropertyGLAccount_ActivityTypeId')
CREATE NONCLUSTERED INDEX UX_SnapshotPropertyOverheadPropertyGLAccount_ActivityTypeId ON
	[Gdm].[SnapshotPropertyOverheadPropertyGLAccount] (
		SnapshotId ASC,
		ActivityTypeId ASC
	)
	PRINT 'UX_SnapshotPropertyOverheadPropertyGLAccount_ActivityTypeId'
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotPropertyOverheadPropertyGLAccount]') AND name = N'UX_SnapshotPropertyOverheadPropertyGLAccount_FunctionalDepartmentId')
CREATE NONCLUSTERED INDEX UX_SnapshotPropertyOverheadPropertyGLAccount_FunctionalDepartmentId ON
	[Gdm].[SnapshotPropertyOverheadPropertyGLAccount] (
		SnapshotId ASC,
		FunctionalDepartmentId ASC
	)
	PRINT 'UX_SnapshotPropertyOverheadPropertyGLAccount_FunctionalDepartmentId'
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGLGlobalAccountCategorization]') AND name = N'IX_SnapshotGLGlobalAccountCategorization_GLGlobalAccountId')
CREATE NONCLUSTERED INDEX IX_SnapshotGLGlobalAccountCategorization_GLGlobalAccountId ON
	[Gdm].[SnapshotGLGlobalAccountCategorization] (
		SnapshotId ASC,
		GLGlobalAccountId ASC
	)
	PRINT 'IX_SnapshotGLGlobalAccountCategorization_GLGlobalAccountId'
GO