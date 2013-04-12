USE GrReportingStaging
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SnapshotActivityType' AND (COLUMN_NAME = 'GLSuffix' OR COLUMN_NAME = 'ActivityTypeCode'))
BEGIN
	ALTER TABLE Gdm.SnapshotActivityType
	DROP CONSTRAINT UX_SnapshotActivityType_GLAccountSuffix
	
	ALTER TABLE Gdm.SnapshotActivityType
	DROP COLUMN
		GLSuffix,
		ActivityTypeCode

END