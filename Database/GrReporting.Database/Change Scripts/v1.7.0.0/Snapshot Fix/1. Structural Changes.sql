/*

Add
	1. dbo.ProfitabilityBudget.SnapshotId
	2. dbo.ProfitabilityReforecast.SnapshotId
	3. dbo.ActivityType.SnapshotId
	4. dbo.OriginatingRegion.SnapshotId
	5. dbo.AllocationRegion.SnapshotId
	6. dbo.GlAccount.SnapshotId
	7. dbo.GlAccountCategory.SnapshotId
	8. dbo.PropertyFund.SnapshotId
	9. dbo.ReportingEntity.SnapshotId

*/

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 1. dbo.ProfitabilityBudget.SnapshotId --------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------
USE GrReporting
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ProfitabilityBudget' AND COLUMN_NAME = 'SnapshotId')
BEGIN
	ALTER TABLE
		dbo.ProfitabilityBudget
	ADD
		SnapshotId INT CONSTRAINT DF_ProfitabilityBudget_SnapshotId DEFAULT(0) NOT NULL
	
	PRINT ('Column "SnapshotId" added to table "ProfitabilityBudget".')	
	
	ALTER TABLE
		dbo.ProfitabilityBudget
	DROP CONSTRAINT
		DF_ProfitabilityBudget_SnapshotId
	
	PRINT ('DF "DF_ProfitabilityBudget_SnapshotId" dropped.')
	
END
ELSE
BEGIN
	PRINT ('Cannot add column "SnapshotId" to table "ProfitabilityBudget" as it already exists.')
END


IF EXISTS 
(
	SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
	WHERE 
		COLUMN_NAME = 'SnapshotId' AND 
		TABLE_NAME = 'ProfitabilityBudget' AND
		IS_NULLABLE = 'YES'
)
BEGIN
	ALTER TABLE
		dbo.ProfitabilityBudget
	ALTER COLUMN
		SnapshotId INT NOT NULL
	PRINT 'SnapshotId ON ProfitabilityBudget was NULLABLE, Updated to NOT NULL'
END




GO

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 2. dbo.ProfitabilityReforecast.SnapshotId ----------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

USE GrReporting
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ProfitabilityReforecast' AND COLUMN_NAME = 'SnapshotId')
BEGIN
	ALTER TABLE
		dbo.ProfitabilityReforecast
	ADD
		SnapshotId INT CONSTRAINT DF_ProfitabilityReforecast_SnapshotId DEFAULT(0) NOT NULL

	PRINT ('Column "SnapshotId" added to table "ProfitabilityReforecast".')
	
	ALTER TABLE
		dbo.ProfitabilityReforecast
	DROP CONSTRAINT
		DF_ProfitabilityReforecast_SnapshotId
	
	PRINT ('DF "DF_ProfitabilityReforecast_SnapshotId" dropped.')

END
ELSE
BEGIN
	PRINT ('Cannot add column "SnapshotId" to table "ProfitabilityReforecast" as it already exists.')
END

IF EXISTS 
(
	SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
	WHERE 
		COLUMN_NAME = 'SnapshotId' AND 
		TABLE_NAME = 'ProfitabilityReforecast' AND
		IS_NULLABLE = 'YES'
)
BEGIN
	ALTER TABLE
		dbo.ProfitabilityReforecast
	ALTER COLUMN
		SnapshotId INT NOT NULL
	PRINT 'SnapshotId ON ProfitabilityReforecast was NULLABLE, Updated to NOT NULL'
END



GO

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 3. dbo.ActivityType.SnapshotId ---------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

USE GrReporting
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ActivityType' AND COLUMN_NAME = 'SnapshotId' AND TABLE_SCHEMA = 'dbo')
BEGIN

	ALTER TABLE
		dbo.ActivityType
	ADD
		SnapshotId INT CONSTRAINT DF_ActivityType_SnapshotId DEFAULT(0) NOT NULL

	PRINT ('Column "SnapshotId" added to table "dbo.ActivityType".')

	ALTER TABLE
		dbo.ActivityType
	DROP CONSTRAINT
		DF_ActivityType_SnapshotId

	PRINT ('DF "DF_ActivityType_SnapshotId" dropped.')

END
ELSE
BEGIN
	PRINT ('Cannot add column "SnapshotId" added to table "dbo.ActivityType" as it already exists.')
END

GO

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 4. dbo.OriginatingRegion.SnapshotId ----------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

USE GrReporting
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'OriginatingRegion' AND COLUMN_NAME = 'SnapshotId' AND TABLE_SCHEMA = 'dbo')
BEGIN

	ALTER TABLE
		dbo.OriginatingRegion
	ADD
		SnapshotId INT CONSTRAINT DF_OriginatingRegion_SnapshotId DEFAULT(0) NOT NULL

	PRINT ('Column "SnapshotId" added to table "dbo.OriginatingRegion".')

	ALTER TABLE
		dbo.OriginatingRegion
	DROP CONSTRAINT
		DF_OriginatingRegion_SnapshotId

	PRINT ('DF "DF_OriginatingRegion_SnapshotId" dropped.')

END
ELSE
BEGIN
	PRINT ('Cannot add column "SnapshotId" added to table "dbo.OriginatingRegion" as it already exists.')
END

GO

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 5. dbo.AllocationRegion.SnapshotId -----------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

USE GrReporting
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'AllocationRegion' AND COLUMN_NAME = 'SnapshotId' AND TABLE_SCHEMA = 'dbo')
BEGIN

	ALTER TABLE
		dbo.AllocationRegion
	ADD
		SnapshotId INT CONSTRAINT DF_AllocationRegion_SnapshotId DEFAULT(0) NOT NULL

	PRINT ('Column "SnapshotId" added to table "dbo.AllocationRegion".')

	ALTER TABLE
		dbo.AllocationRegion
	DROP CONSTRAINT
		DF_AllocationRegion_SnapshotId

	PRINT ('DF "DF_AllocationRegion_SnapshotId" dropped.')

END
ELSE
BEGIN
	PRINT ('Cannot add column "SnapshotId" added to table "dbo.AllocationRegion" as it already exists.')
END

GO

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 6. dbo.GlAccount.SnapshotId ------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

USE GrReporting
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GlAccount' AND COLUMN_NAME = 'SnapshotId' AND TABLE_SCHEMA = 'dbo')
BEGIN

	ALTER TABLE
		dbo.GlAccount
	ADD
		SnapshotId INT CONSTRAINT DF_GlAccount_SnapshotId DEFAULT(0) NOT NULL

	PRINT ('Column "SnapshotId" added to table "dbo.GlAccount".')

	ALTER TABLE
		dbo.GlAccount
	DROP CONSTRAINT
		DF_GlAccount_SnapshotId

	PRINT ('DF "DF_GlAccount_SnapshotId" dropped.')

END
ELSE
BEGIN
	PRINT ('Cannot add column "SnapshotId" added to table "dbo.GlAccount" as it already exists.')
END

GO

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 7. dbo.GlAccountCategory.SnapshotId ----------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

USE GrReporting
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GlAccountCategory' AND COLUMN_NAME = 'SnapshotId' AND TABLE_SCHEMA = 'dbo')
BEGIN

	ALTER TABLE
		dbo.GlAccountCategory
	ADD
		SnapshotId INT CONSTRAINT DF_GlAccountCategory_SnapshotId DEFAULT(0) NOT NULL

	PRINT ('Column "SnapshotId" added to table "dbo.GlAccountCategory".')

	ALTER TABLE
		dbo.GlAccountCategory
	DROP CONSTRAINT
		DF_GlAccountCategory_SnapshotId

	PRINT ('DF "DF_GlAccountCategory_SnapshotId" dropped.')

END
ELSE
BEGIN
	PRINT ('Cannot add column "SnapshotId" added to table "dbo.GlAccountCategory" as it already exists.')
END

GO

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 8. dbo.PropertyFund.SnapshotId ---------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

USE GrReporting
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PropertyFund' AND COLUMN_NAME = 'SnapshotId' AND TABLE_SCHEMA = 'dbo')
BEGIN

	ALTER TABLE
		dbo.PropertyFund
	ADD
		SnapshotId INT CONSTRAINT DF_PropertyFund_SnapshotId DEFAULT(0) NOT NULL

	PRINT ('Column "SnapshotId" added to table "dbo.PropertyFund".')

	ALTER TABLE
		dbo.PropertyFund
	DROP CONSTRAINT
		DF_PropertyFund_SnapshotId

	PRINT ('DF "DF_PropertyFund_SnapshotId" dropped.')

END
ELSE
BEGIN
	PRINT ('Cannot add column "SnapshotId" added to table "dbo.PropertyFund" as it already exists.')
END

GO

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 9. dbo.ReportingEntity.SnapshotId ------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

USE GrReporting
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ReportingEntity' AND COLUMN_NAME = 'SnapshotId' AND TABLE_SCHEMA = 'dbo')
BEGIN

	ALTER TABLE
		dbo.ReportingEntity
	ADD
		SnapshotId INT CONSTRAINT DF_ReportingEntity_SnapshotId DEFAULT(0) NOT NULL

	PRINT ('Column "SnapshotId" added to table "dbo.ReportingEntity".')

	ALTER TABLE
		dbo.ReportingEntity
	DROP CONSTRAINT
		DF_ReportingEntity_SnapshotId

	PRINT ('DF "DF_ReportingEntity_SnapshotId" dropped.')

END
ELSE
BEGIN
	PRINT ('Cannot add column "SnapshotId" added to table "dbo.ReportingEntity" as it already exists.')
END

GO
