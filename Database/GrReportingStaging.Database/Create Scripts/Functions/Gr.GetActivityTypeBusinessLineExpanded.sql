USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetActivityTypeBusinessLineExpanded]') AND type IN (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [Gr].[GetActivityTypeBusinessLineExpanded]
GO

USE [GrReportingStaging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Gr].[GetActivityTypeBusinessLineExpanded] 
	(@DataPriorToDate DATETIME)

RETURNS @Result TABLE
(
	ActivityTypeId INT NOT NULL,
	ActivityTypeName VARCHAR(50) NOT NULL,
	ActivityTypeCode VARCHAR(50) NOT NULL,
	BusinessLineId INT NOT NULL,
	BusinessLineName VARCHAR(50) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsActive BIT NOT NULL
)
AS
BEGIN

INSERT INTO @Result
SELECT
	ActivityType.ActivityTypeId,
	ActivityType.ActivityTypeName,
	ActivityType.ActivityTypeCode,
	BusinessLine.BusinessLineId,
	BusinessLine.BusinessLineName,
	ActivityTypeBusinessLine.InsertedDate, /* The records that are returned by this function are a combination of Activity Type and Business Line
													records, with the ActivityTypeBusinessLine table being used to store these associations. The
													InsertedDate of this record is set to ActivityTypeBusinessLine.InsertedDate because that is
													when the combination that this record represents came into existence. Both the ActivityType
													and BusinessLine records might have existed long before the ActivityTypeBusinessLine record
													was created to unite them. This is why the InsertedDate fields of the ActivityType and
													BusinessLine records are not used. */
	(	/* The UpdatedDate of the record (either ActivityType, BusinessLine, or ActivityTypeBusinessLine) that was last updated will be used as
				the UpdatedDate that is returned for this record. */
		SELECT
			MAX(UpdatedDate) AS UpdatedDate
		FROM
			(
				SELECT ActivityType.UpdatedDate UNION
				SELECT BusinessLine.UpdatedDate UNION
				SELECT ActivityTypeBusinessLine.UpdatedDate
			) UpdatedDates
	) AS UpdatedDate,
	-- All records (ActivityType, BusinessLine, and ActivityTypeBusinessLine) need to be active for the 'final' record to be active
	(ActivityTypeBusinessLine.IsActive & ActivityType.IsActive & BusinessLine.IsActive) AS IsActive
FROM
	(
		SELECT
			ATBL.ActivityTypeId,
			ATBL.BusinessLineId,
			ATBL.InsertedDate,
			ATBL.UpdatedDate,
			ATBL.IsActive
		FROM
			Gdm.ActivityTypeBusinessLine ATBL
			INNER JOIN Gdm.ActivityTypeBusinessLineActive(@DataPriorToDate) ATBLA ON
				ATBL.ImportKey = ATBLA.ImportKey

	) ActivityTypeBusinessLine

	INNER JOIN
	(	
		SELECT
			AT.ActivityTypeId,
			AT.Name AS ActivityTypeName,
			AT.Code AS ActivityTypeCode,
			AT.InsertedDate,
			AT.UpdatedDate,
			AT.IsActive
		FROM
			Gdm.ActivityType AT
			INNER JOIN Gdm.ActivityTypeActive(@DataPriorToDate) ATA ON
				AT.ImportKey = ATA.ImportKey

	) ActivityType ON
		ActivityTypeBusinessLine.ActivityTypeId = ActivityType.ActivityTypeId

	INNER JOIN
	(	
		SELECT
			BL.BusinessLineId,
			BL.Name AS BusinessLineName,
			BL.InsertedDate,
			BL.UpdatedDate,
			BL.IsActive
		FROM
			Gdm.BusinessLine BL
			INNER JOIN Gdm.BusinessLineActive(@DataPriorToDate) BLA ON
				BL.ImportKey = BLA.ImportKey

	) BusinessLine ON
		ActivityTypeBusinessLine.BusinessLineId = BusinessLine.BusinessLineId

RETURN

END

GO

