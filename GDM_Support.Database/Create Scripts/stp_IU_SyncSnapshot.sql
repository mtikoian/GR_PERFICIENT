 USE [GDM_GR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshot]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshot]
GO

USE [GDM_GR]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.Snapshot table in the GDM_GR database with the 
	dbo.Snapshot table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshot]
AS

SET IDENTITY_INSERT GDM_GR.dbo.Snapshot ON

MERGE
	GDM_GR.dbo.Snapshot AS [Target]
USING
	GDM.dbo.Snapshot AS [Source]
ON
	[Source].SnapshotId = [Target].SnapshotId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]'s fields to be equal to [Source]'s fields (besides the PK field)
	UPDATE SET
		[Target].GroupName = [Source].GroupName,
		[Target].GroupKey = [Source].GroupKey,
		[Target].IsLocked = [Source].IsLocked,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].LastSyncDate = [Source].LastSyncDate,
		[Target].ManualUpdatedDate = [Source].ManualUpdatedDate

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn't exist in [Target], insert it
	INSERT (
		SnapshotId,
		GroupName,
		GroupKey,
		IsLocked,
		InsertedDate,
		LastSyncDate,
		ManualUpdatedDate
	)
	VALUES (
		[Source].SnapshotId,
		[Source].GroupName,
		[Source].GroupKey,
		[Source].IsLocked,
		[Source].InsertedDate,
		[Source].LastSyncDate,
		[Source].ManualUpdatedDate
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn't exist in [Source], deactivate it in [Target]
	DELETE; -- 

SET IDENTITY_INSERT GDM_GR.dbo.Snapshot OFF

GO
