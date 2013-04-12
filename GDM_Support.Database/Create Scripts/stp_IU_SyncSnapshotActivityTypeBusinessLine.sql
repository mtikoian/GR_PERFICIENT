 USE [GDM_GR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotActivityTypeBusinessLine]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotActivityTypeBusinessLine]
GO

USE [GDM_GR]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotActivityTypeBusinessLine table in the GDM_GR database with the 
	dbo.SnapshotActivityTypeBusinessLine table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-04		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotActivityTypeBusinessLine]
AS



MERGE
	GDM_GR.dbo.SnapshotActivityTypeBusinessLine AS [Target]
USING
	GDM.dbo.SnapshotActivityTypeBusinessLine AS [Source]
ON
	[Source].ActivityTypeBusinessLineId = [Target].ActivityTypeBusinessLineId AND
	[Source].SnapshotId = [Target].SnapshotId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]'s fields to be equal to [Source]'s fields (besides the PK field)
	UPDATE SET
		[Target].ActivityTypeId = [Source].ActivityTypeId,
		[Target].BusinessLineId = [Source].BusinessLineId,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId,
		[Target].IsActive = [Source].IsActive

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn't exist in [Target], insert it
	INSERT (
		SnapshotId,
		ActivityTypeBusinessLineId,
		ActivityTypeId,
		BusinessLineId,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId,
		IsActive
	)
	VALUES (
		[Source].SnapshotId,
		[Source].ActivityTypeBusinessLineId,
		[Source].ActivityTypeId,
		[Source].BusinessLineId,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId,
		[Source].IsActive
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn't exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don't hard delete the target record as this will probably break FK constraints on this table



GO
