-- dbo.AllocationRegion.[IX_Name_SubName] --------------------------------------------------------------------------------------------------------

USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[AllocationRegion]') AND name = N'IX_Name_SubName')
BEGIN
	DROP INDEX [IX_Name_SubName] ON [dbo].[AllocationRegion] WITH ( ONLINE = OFF )
	PRINT ('Index [IX_Name_SubName] on dbo.AllocationRegion dropped.')
END

GO

USE [GrReporting]
GO

CREATE NONCLUSTERED INDEX [IX_Name_SubName] ON [dbo].[AllocationRegion] 
(
	[RegionName] ASC,
	[SubRegionName] ASC,
	[SnapshotId] ASC
)
INCLUDE (
	[AllocationRegionKey],
	[RegionCode],
	[SubRegionCode]
) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

	PRINT ('Index [IX_Name_SubName] on dbo.AllocationRegion created.')

GO

--------------------------------------------------------------------------------------------------------------------------------------------------