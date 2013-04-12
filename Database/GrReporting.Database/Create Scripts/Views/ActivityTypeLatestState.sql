 USE GrReporting
 GO
 
/****** Object:  View [dbo].[ActivityTypeLatestState]    Script Date: 01/23/2012 16:59:44 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ActivityTypeLatestState]'))
DROP VIEW [dbo].[ActivityTypeLatestState]
GO

/****** Object:  View [dbo].[ActivityTypeLatestState]    Script Date: 01/23/2012 16:59:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[ActivityTypeLatestState]
AS

/*********************************************************************************************************************
Description
	This view returns all records in the activity type dimension, 
	as well as the latest activity type state for that GDM item. 
	This allows us to handle activity type name, code and business line
	changes correctly.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

2012-01-18	Sarah-Marie Nothling	: Created View
**********************************************************************************************************************/

SELECT
	ActivityType.ActivityTypeKey AS 'ActivityTypeKey',
	ActivityType.ActivityTypeId AS 'ActivityTypeId',
	ActivityType.SnapshotId AS 'ActivityTypeSnapshotId',
	MaxActivityTypeRecord.ActivityTypeCode AS 'LatestActivityTypeCode',
	MaxActivityTypeRecord.ActivityTypeName AS 'LatestActivityTypeName',
	MaxActivityTypeRecord.BusinessLineName AS 'LatestBusinessLineName'
FROM
	dbo.ActivityType
	INNER JOIN (
		SELECT
			ActivityTypeId,
			SnapshotId,
			MAX(EndDate) AS 'MaxActivityTypeEndDate'
		FROM 
			dbo.ActivityType
		GROUP BY 
			ActivityTypeId,
			SnapshotId
		) MaxActivityType ON
		ActivityType.ActivityTypeId = MaxActivityType.ActivityTypeId AND
		ActivityType.SnapshotId = MaxActivityType.SnapshotId
	INNER JOIN dbo.ActivityType MaxActivityTypeRecord ON
		MaxActivityType.ActivityTypeId = MaxActivityTypeRecord.ActivityTypeId AND
		MaxActivityType.SnapshotId = MaxActivityTypeRecord.SnapshotId AND
		MaxActivityType.MaxActivityTypeEndDate = MaxActivityTypeRecord.EndDate






GO


