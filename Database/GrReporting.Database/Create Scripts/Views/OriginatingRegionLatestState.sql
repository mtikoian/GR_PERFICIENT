 USE [GrReporting]
GO

/****** Object:  View [dbo].[OriginatingRegionLatestState]    Script Date: 01/23/2012 17:00:55 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[OriginatingRegionLatestState]'))
DROP VIEW [dbo].[OriginatingRegionLatestState]
GO

USE [GrReporting]
GO

/****** Object:  View [dbo].[OriginatingRegionLatestState]    Script Date: 01/23/2012 17:00:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO














CREATE VIEW [dbo].[OriginatingRegionLatestState]
AS

/*********************************************************************************************************************
Description
	This view returns all records in the OriginatingRegion dimension, 
	as well as the latest property fund state for that GDM item. 
	This allows us to handle property fund name and property fund type
	changes correctly.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

2012-01-18	Sarah-Marie Nothling	: Created View
**********************************************************************************************************************/

SELECT
	OriginatingRegion.OriginatingRegionKey AS 'OriginatingRegionKey',
	OriginatingRegion.SnapshotId AS 'OriginatingRegionSnapshotId',
	OriginatingRegion.GlobalRegionId AS 'OriginatingRegionGlobalRegionId',
	MaxOriginatingRegionRecord.RegionCode AS 'LatestOriginatingRegionCode',
	MaxOriginatingRegionRecord.RegionName AS 'LatestOriginatingRegionName',
	MaxOriginatingRegionRecord.SubRegionCode AS 'LatestOriginatingSubRegionCode',
	MaxOriginatingRegionRecord.SubRegionName AS 'LatestOriginatingSubRegionName'
FROM
	dbo.OriginatingRegion
	INNER JOIN (
		SELECT
			GlobalRegionId,
			SnapshotId,
			MAX(EndDate) AS 'MaxOriginatingRegionEndDate'
		FROM 
			dbo.OriginatingRegion
		GROUP BY 
			GlobalRegionId,
			SnapshotId
		) MaxOriginatingRegion ON
		OriginatingRegion.GlobalRegionId = MaxOriginatingRegion.GlobalRegionId AND
		OriginatingRegion.SnapshotId = MaxOriginatingRegion.SnapshotId
	INNER JOIN dbo.OriginatingRegion MaxOriginatingRegionRecord ON
		MaxOriginatingRegion.GlobalRegionId = MaxOriginatingRegionRecord.GlobalRegionId AND
		MaxOriginatingRegion.SnapshotId = MaxOriginatingRegionRecord.SnapshotId AND
		MaxOriginatingRegion.MaxOriginatingRegionEndDate = MaxOriginatingRegionRecord.EndDate







GO


