 USE [GrReporting]
GO

/****** Object:  View [dbo].[AllocationRegionLatestState]    Script Date: 01/23/2012 17:00:07 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[AllocationRegionLatestState]'))
DROP VIEW [dbo].[AllocationRegionLatestState]
GO


/****** Object:  View [dbo].[AllocationRegionLatestState]    Script Date: 01/23/2012 17:00:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO













CREATE VIEW [dbo].[AllocationRegionLatestState]
AS

/*********************************************************************************************************************
Description
	This view returns all records in the AllocationRegion dimension, 
	as well as the latest property fund state for that GDM item. 
	This allows us to handle property fund name and property fund type
	changes correctly.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

2012-01-18	Sarah-Marie Nothling	: Created View
**********************************************************************************************************************/

SELECT
	AllocationRegion.AllocationRegionKey AS 'AllocationRegionKey',
	AllocationRegion.SnapshotId AS 'AllocationRegionSnapshotId',
	AllocationRegion.GlobalRegionId AS 'AllocationRegionGlobalRegionId',
	MaxAllocationRegionRecord.RegionCode AS 'LatestAllocationRegionCode',
	MaxAllocationRegionRecord.RegionName AS 'LatestAllocationRegionName',
	MaxAllocationRegionRecord.SubRegionCode AS 'LatestAllocationSubRegionCode',
	MaxAllocationRegionRecord.SubRegionName AS 'LatestAllocationSubRegionName'
FROM
	dbo.AllocationRegion
	INNER JOIN (
		SELECT
			GlobalRegionId,
			SnapshotId,
			MAX(EndDate) AS 'MaxAllocationRegionEndDate'
		FROM 
			dbo.AllocationRegion
		GROUP BY 
			GlobalRegionId,
			SnapshotId
		) MaxAllocationRegion ON
		AllocationRegion.GlobalRegionId = MaxAllocationRegion.GlobalRegionId AND
		AllocationRegion.SnapshotId = MaxAllocationRegion.SnapshotId
	INNER JOIN dbo.AllocationRegion MaxAllocationRegionRecord ON
		MaxAllocationRegion.GlobalRegionId = MaxAllocationRegionRecord.GlobalRegionId AND
		MaxAllocationRegion.SnapshotId = MaxAllocationRegionRecord.SnapshotId AND
		MaxAllocationRegion.MaxAllocationRegionEndDate = MaxAllocationRegionRecord.EndDate






GO


