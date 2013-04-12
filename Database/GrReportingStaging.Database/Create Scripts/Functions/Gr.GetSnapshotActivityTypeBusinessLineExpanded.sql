USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetSnapshotActivityTypeBusinessLineExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gr].[GetSnapshotActivityTypeBusinessLineExpanded]
GO

USE [GrReportingStaging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [Gr].[GetSnapshotActivityTypeBusinessLineExpanded] 
	()
RETURNS @Result TABLE (
	ActivityTypeId INT NOT NULL,
	ActivityTypeName VARCHAR(50) NOT NULL,
	ActivityTypeCode VARCHAR(50) NOT NULL,
	BusinessLineId INT NOT NULL,
	BusinessLineName VARCHAR(50) NOT NULL,
	SnapshotId INT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsActive BIT NOT NULL
)
AS
BEGIN 

INSERT INTO @Result
SELECT
	ActivityType.ActivityTypeId,
	ActivityType.Name,
	ActivityType.Code,
	BusinessLine.BusinessLineId,
	BusinessLine.Name,
	ActivityTypeBusinessLine.SnapshotId,
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
			MAX(UpdatedDate)
		FROM
			(
				SELECT ActivityType.UpdatedDate UNION
				SELECT BusinessLine.UpdatedDate UNION
				SELECT ActivityTypeBusinessLine.UpdatedDate
			) UpdatedDates
	) AS UpdatedDate,
	CONVERT(BIT, (ActivityTypeBusinessLine.IsActive & ActivityType.IsActive & BusinessLine.IsActive)) AS IsActive
FROM
	Gdm.SnapshotActivityTypeBusinessLine ActivityTypeBusinessLine
			
	INNER JOIN Gdm.SnapshotActivityType ActivityType ON
		ActivityTypeBusinessLine.ActivityTypeId = ActivityType.ActivityTypeId AND
		ActivityTypeBusinessLine.SnapshotId = ActivityType.SnapshotId

	INNER JOIN Gdm.SnapshotBusinessLine BusinessLine ON
		ActivityTypeBusinessLine.BusinessLineId = BusinessLine.BusinessLineId AND
		ActivityTypeBusinessLine.SnapshotId = BusinessLine.SnapshotId

RETURN
END

GO

