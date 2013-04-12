USE GrReportingStaging
GO
IF NOT EXISTS(Select * From INFORMATION_SCHEMA.COLUMNS Where TABLE_SCHEMA = 'Gdm' AND TABLE_NAME = 'PropertyFundMapping' AND COLUMN_NAME = 'ActivityTypeId')
	BEGIN
	ALTER TABLE Gdm.PropertyFundMapping ADD ActivityTypeId int NULL
	END
GO
IF EXISTS(Select * From INFORMATION_SCHEMA.TABLES tab Where tab.TABLE_SCHEMA = 'TapasGlobal' AND TABLE_NAME = 'ProjectRegion')
	BEGIN
	ALTER SCHEMA Gdm TRANSFER TapasGlobal.ProjectRegion 
	END
GO
IF EXISTS(Select * From INFORMATION_SCHEMA.TABLES tab Where tab.TABLE_SCHEMA = 'TapasGlobal' AND TABLE_NAME = 'ProjectType')
	BEGIN
	ALTER SCHEMA Gdm TRANSFER TapasGlobal.ProjectType 
	END
GO
IF EXISTS(Select * From INFORMATION_SCHEMA.COLUMNS Where TABLE_SCHEMA = 'Gdm' AND TABLE_NAME = 'PropertyFund' AND COLUMN_NAME = 'ProjectTypeId')
	BEGIN
	exec sp_rename 'Gdm.PropertyFund.ProjectTypeId','EntityTypeId', 'COLUMN'
	END
GO
IF EXISTS(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_SCHEMA = 'Gdm' AND TABLE_NAME = 'ProjectType')
	BEGIN
	exec sp_rename 'Gdm.ProjectType', 'EntityType'
	END
GO
IF EXISTS(Select * From INFORMATION_SCHEMA.COLUMNS Where TABLE_SCHEMA = 'Gdm' AND TABLE_NAME = 'EntityType' AND COLUMN_NAME = 'ProjectTypeId')
	BEGIN
	exec sp_rename 'Gdm.EntityType.ProjectTypeId', 'EntityTypeId', 'COLUMN'
	END
GO

GO
IF EXISTS(Select * From INFORMATION_SCHEMA.TABLES tab Where tab.TABLE_SCHEMA = 'TapasGlobal' AND TABLE_NAME = 'ProjectRegion')
	BEGIN
	ALTER SCHEMA Gdm TRANSFER TapasGlobal.ProjectRegion 
	END