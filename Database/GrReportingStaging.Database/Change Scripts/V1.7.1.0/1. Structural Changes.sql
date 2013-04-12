USE GrReportingStaging
GO
/*
1. Create Gdm.ConsolidationRegionCorporateDepartment Table 
2. Add Gdm.SnapshotConsolidationRegionCorporateDepartment Table
3. Add Gdm.ConsolidationRegionPropertyEntity Table
4. Add Gdm.SnapshotConsolidationRegionPropertyEntity Table
5. Add IsConsolidatedRegion field to Gdm.GlobalRegion Table
6. Add IsConsolidatedRegion field to Gdm.SnapshotGlobalRegion Table
7. Add ConsolidatedRegionKey field to dbo.ProfitabilityBudgetUnknowns Table
8. Add ConsolidatedRegionKey field to dbo.ProfitabilityReforecastUnknowns Table
9. Add Gdm.ConsolidationRegionRegion Table
10. Add Gdm.ConsolidationSubRegionRegion Table
11. Add Gdm.SnapshotConsolidationSubRegionRegion Table
12. Add ConsolidationSubRegionGlobalRegionId field to [GBS].BudgetProfitabilityActual table
*/

/* 
1. Create Gdm.ConsolidationRegionCorporateDepartment Table 
*/

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ConsolidationRegionCorporateDepartment]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].ConsolidationRegionCorporateDepartment
(
	ImportKey INT IDENTITY(1,1) NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	ConsolidationRegionCorporateDepartmentId INT NOT NULL,
	CorporateDepartmentCode VARCHAR(10) NOT NULL,
	SourceCode VARCHAR(2) NOT NULL,
	GlobalRegionId INT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL	 

) ON [PRIMARY]
END	
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[Gdm].[DF_ConsolidationRegionCorporateDepartment_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].ConsolidationRegionCorporateDepartment 
	ADD  CONSTRAINT [DF_ConsolidationRegionCorporateDepartment_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
END
GO

/*
2. Add Gdm.SnapshotConsolidationRegionCorporateDepartment Table
*/

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotConsolidationRegionCorporateDepartment]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].SnapshotConsolidationRegionCorporateDepartment
(
	SnapshotId INT NOT NULL,
	ConsolidationRegionCorporateDepartmentId INT NOT NULL,
	CorporateDepartmentCode VARCHAR(10) NOT NULL,
	SourceCode VARCHAR(2) NOT NULL,
	GlobalRegionId INT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
) ON [PRIMARY]
END	
GO


/*
3. Add Gdm.ConsolidationRegionPropertyEntity Table
*/

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ConsolidationRegionPropertyEntity]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].ConsolidationRegionPropertyEntity
(
	ImportKey INT IDENTITY(1,1) NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	ConsolidationRegionPropertyEntityId INT NOT NULL,
	PropertyEntityCode VARCHAR(10) NOT NULL,
	SourceCode VARCHAR(2) NOT NULL,
	GlobalRegionId INT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
) ON [PRIMARY]
END	
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[Gdm].[DF_ConsolidationRegionPropertyEntity_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].ConsolidationRegionPropertyEntity 
	ADD  CONSTRAINT [DF_ConsolidationRegionPropertyEntity_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
END
GO

/*
4. Add Gdm.SnapshotConsolidationRegionPropertyEntity Table
*/

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotConsolidationRegionPropertyEntity]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].SnapshotConsolidationRegionPropertyEntity
(
	SnapshotId INT NOT NULL,
	ConsolidationRegionPropertyEntityId INT NOT NULL,
	PropertyEntityCode VARCHAR(10) NOT NULL,
	SourceCode VARCHAR(2) NOT NULL,
	GlobalRegionId INT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
) ON [PRIMARY]
END	
GO


/*
5. Add IsConsolidatedRegion field to Gdm.GlobalRegion Table
*/

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GlobalRegion' AND COLUMN_NAME = 'IsConsolidationRegion' AND TABLE_SCHEMA='Gdm')
BEGIN
ALTER TABLE [Gdm].GlobalRegion
	ADD IsConsolidationRegion BIT
END

/*
6. Add IsConsolidatedRegion field to Gdm.SnapshotGlobalRegion Table
*/

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SnapshotGlobalRegion' AND COLUMN_NAME = 'IsConsolidationRegion' AND TABLE_SCHEMA='Gdm')
BEGIN
ALTER TABLE [Gdm].SnapshotGlobalRegion
	ADD IsConsolidationRegion BIT
END

/*
7. Add ConsolidatedRegionKey field to dbo.ProfitabilityBudgetUnknowns Table
*/

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ProfitabilityBudgetUnknowns' AND COLUMN_NAME = 'ConsolidationRegionKey' AND TABLE_SCHEMA='dbo')
BEGIN
ALTER TABLE [dbo].ProfitabilityBudgetUnknowns
	ADD ConsolidationRegionKey INT
END

/*
8. Add ConsolidatedRegionKey field to dbo.ProfitabilityReforecastUnknowns Table
*/

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ProfitabilityReforecastUnknowns' AND COLUMN_NAME = 'ConsolidationRegionKey' AND TABLE_SCHEMA='dbo')
BEGIN
ALTER TABLE [dbo].ProfitabilityReforecastUnknowns
	ADD ConsolidationRegionKey INT
END

/*
9. Add Gdm.ConsolidationRegion Table
*/

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ConsolidationRegion]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].ConsolidationRegion
(
	ImportKey INT IDENTITY(1,1) NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	ConsolidationRegionGlobalRegionId INT NOT NULL,
	ConsolidationRegionGlobalRegionCode VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	ProjectCodePortion VARCHAR(2) NOT NULL,
	DefaultCurrencyCode CHAR(3) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
) ON [PRIMARY]
END	
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[Gdm].[DF_ConsolidationRegion_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].ConsolidationRegion 
	ADD  CONSTRAINT [DF_ConsolidationRegion_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
END
GO

/*
10. Add Gdm.ConsolidationSubRegionRegion Table
*/

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ConsolidationSubRegion]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].ConsolidationSubRegion
(
	ImportKey INT IDENTITY(1,1) NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	ConsolidationSubRegionGlobalRegionId INT NOT NULL,
	ConsolidationSubRegionGlobalRegionCode VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	ProjectCodePortion VARCHAR(2) NOT NULL,
	ConsolidationRegionGlobalRegionId INT NOT NULL,
	DefaultCurrencyCode CHAR(3) NOT NULL,
	DefaultCorporateSourceCode CHAR(2) NOT NULL,
	CountryId INT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
) ON [PRIMARY]
END	
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[Gdm].[DF_ConsolidationSubRegion_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].ConsolidationSubRegion 
	ADD  CONSTRAINT [DF_ConsolidationSubRegion_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
END
GO

/*
11. Add Gdm.SnapshotConsolidationSubRegionRegion Table
*/

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotConsolidationSubRegion]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gdm].SnapshotConsolidationSubRegion
(
	SnapshotId INT NOT NULL,
	ConsolidationSubRegionGlobalRegionId INT NOT NULL,
	ConsolidationSubRegionGlobalRegionCode VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	ProjectCodePortion VARCHAR(2) NOT NULL,
	ConsolidationRegionGlobalRegionId INT NOT NULL,
	DefaultCurrencyCode CHAR(3) NOT NULL,
	DefaultCorporateSourceCode CHAR(2) NOT NULL,
	CountryId INT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
) ON [PRIMARY]
END	
GO

/*
12. Add ConsolidationSubRegionGlobalRegionId field to [GBS].BudgetProfitabilityActual table
*/
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'BudgetProfitabilityActual' AND COLUMN_NAME = 'ConsolidationSubRegionGlobalRegionId' AND TABLE_SCHEMA='GBS')
BEGIN
ALTER TABLE [GBS].BudgetProfitabilityActual
	ADD ConsolidationSubRegionGlobalRegionId INT
END