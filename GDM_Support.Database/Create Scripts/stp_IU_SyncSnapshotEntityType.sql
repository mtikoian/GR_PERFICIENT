 USE [GDM_GR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotEntityType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotEntityType]
GO

USE [GDM_GR]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotEntityType table in the GDM_GR database with the 
	dbo.SnapshotEntityType table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-08-08		: PKayongo	:	The stored procedure was created.
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotEntityType] AS


MERGE
	GDM_GR.dbo.SnapshotEntityType AS [Target]
USING
	GDM.dbo.SnapshotEntityType AS [Source]
ON
	[Source].EntityTypeId = [Target].EntityTypeId AND
	[Source].SnapshotId = [Target].SnapshotId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]'s fields to be equal to [Source]'s fields (besides the PK field)
	UPDATE SET
		[Target].Name = [Source].Name,
		[Target].ProjectCodePortion = [Source].ProjectCodePortion,
		[Target].[Description] = [Source].[Description],
		[Target].IsActive = [Source].IsActive,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn't exist in [Target], insert it
	INSERT (
		SnapshotId,
		EntityTypeId,
		Name,
		ProjectCodePortion,
		[Description],
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].SnapshotId,
		[Source].EntityTypeId,
		[Source].Name,
		[Source].ProjectCodePortion,
		[Source].[Description],
		[Source].IsActive,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn't exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don't hard delete the target record as this will probably break FK constraints on this table



GO
