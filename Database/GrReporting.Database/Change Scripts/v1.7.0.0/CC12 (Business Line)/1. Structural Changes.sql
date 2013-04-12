USE [GrReporting]
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ActivityType' AND COLUMN_NAME = 'BusinessLineId')
BEGIN

	ALTER TABLE
		dbo.ActivityType
	ADD
		BusinessLineId INT NULL

	PRINT ('Column "BusinessLineId" added to table "dbo.ActivityType".')

END
ELSE
BEGIN
	PRINT ('Unable to add column "BusinessLineId" to table "dbo.ActivityType" as it already exists.')
END

GO
----------------------------------------------------------------------------------------------------------------------------------

USE [GrReporting]
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ActivityType' AND COLUMN_NAME = 'BusinessLineName')
BEGIN

	ALTER TABLE
		dbo.ActivityType
	ADD
		BusinessLineName VARCHAR(50) NULL

	PRINT ('Column "BusinessLineName" added to table "dbo.ActivityType".')

END
ELSE
BEGIN
	PRINT ('Unable to add column "BusinessLineName" to table "dbo.ActivityType" as it already exists.')
END

GO
----------------------------------------------------------------------------------------------------------------------------------

USE [GrReporting]
GO

UPDATE
	dbo.ActivityType
SET
	BusinessLineId = -1,
	BusinessLineName = 'UNKNOWN'
WHERE
	ActivityTypeId = -1

GO

PRINT ('"UNKNOWN" Activity Type''s Business Line Id updated.')

USE [GrReporting]
GO

UPDATE
	AT
SET
	AT.BusinessLineId = ATBLE.BusinessLineId,
	AT.BusinessLineName = ATBLE.BusinessLineName
FROM
	dbo.ActivityType AT
	INNER JOIN
	(
		SELECT
			ActivityType.ActivityTypeId,
			ActivityType.ActivityTypeName,
			ActivityType.ActivityTypeCode,
			BusinessLine.BusinessLineId,
			BusinessLine.BusinessLineName,
			MIN(ActivityTypeBusinessLine.InsertedDate) InsertedDate,
			MAX(ActivityTypeBusinessLine.UpdatedDate) UpdatedDate
		FROM
			(
				SELECT
					ATBL.ActivityTypeId,
					ATBL.BusinessLineId,
					ATBL.InsertedDate,
					ATBL.UpdatedDate
				FROM
					SERVER3.GDM.dbo.ActivityTypeBusinessLine ATBL
			
			) ActivityTypeBusinessLine
				
			INNER JOIN (
			
				SELECT
					AT.ActivityTypeId,
					AT.Name AS ActivityTypeName,
					AT.Code AS ActivityTypeCode
				FROM
					SERVER3.GDM.dbo.ActivityType AT
			
			) ActivityType ON
				ActivityTypeBusinessLine.ActivityTypeId = ActivityType.ActivityTypeId

			INNER JOIN (
			
				SELECT
					BL.BusinessLineId,
					BL.Name AS BusinessLineName
				FROM
					SERVER3.GDM.dbo.BusinessLine BL
			
			) BusinessLine ON
				ActivityTypeBusinessLine.BusinessLineId = BusinessLine.BusinessLineId

		GROUP BY
			ActivityType.ActivityTypeId,
			ActivityType.ActivityTypeName,
			ActivityType.ActivityTypeCode,
			BusinessLine.BusinessLineId,
			BusinessLine.BusinessLineName	
	
	) ATBLE ON
		AT.ActivityTypeId = ATBLE.ActivityTypeId
	
GO

PRINT (LTRIM(RTRIM(STR(@@rowcount))) + ' records in dbo.ActivityType updated.')

--------------------------------

USE [GrReporting]
GO

ALTER TABLE
	dbo.ActivityType
ALTER COLUMN
	BusinessLineId INT NOT NULL

PRINT ('dbo.ActivityType.BusinessLineId updated to: INT NOT NULL')

GO

USE [GrReporting]
GO

ALTER TABLE
	dbo.ActivityType
ALTER COLUMN
	BusinessLineName VARCHAR(50) NOT NULL

PRINT ('dbo.ActivityType.BusinessLineName updated to: INT NOT NULL')

GO