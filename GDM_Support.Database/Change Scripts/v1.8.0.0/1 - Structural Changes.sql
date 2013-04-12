USE GDM_GR
GO


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SnapshotActivityTypeExtended]'))
DROP VIEW [dbo].[SnapshotActivityTypeExtended]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ActivityType' AND COLUMN_NAME = 'GLSuffix') 
BEGIN
	ALTER TABLE dbo.ActivityType
	DROP COLUMN 
		GLSuffix,
		ActivityTypeCode
	PRINT 'ActivityTypeCode, GLSuffix and GLAccountSuffix fields dropped from dbo.ActivityType'
END

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SnapshotActivityType' AND (COLUMN_NAME = 'GLSuffix' OR COLUMN_NAME = 'ActivityTypeCode'))
BEGIN
	ALTER TABLE dbo.SnapshotActivityType
	DROP COLUMN
		GLSuffix,
		ActivityTypeCode

	PRINT 'GLSuffix and ActivityType columns dropped from dbo.SnapshotActivityType'
END

