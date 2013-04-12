 USE [GDM_GR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotActivityType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotActivityType]
GO

USE [GDM_GR]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotActivityType table in the GDM_GR database with the 
	dbo.SnapshotActivityType table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-04		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotActivityType]
AS



MERGE
	GDM_GR.dbo.SnapshotActivityType AS [Target]
USING
	GDM.dbo.SnapshotActivityType AS [Source]
ON
	[Source].ActivityTypeId = [Target].ActivityTypeId AND
	[Source].SnapshotId = [Target].SnapshotId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]'s fields to be equal to [Source]'s fields (besides the PK field)
	UPDATE SET
		[Target].Code = [Source].Code,
		[Target].Name = [Source].Name,
		[Target].GLAccountSuffix = [Source].GLAccountSuffix,
		[Target].IsEscalatable = [Source].IsEscalatable,
		[Target].IsActive = [Source].IsActive,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId
		-- [Target].ActivityTypeCode = [Source].ActivityTypeCode, -- can't update these as they are computed fields
		-- [Target].GLSuffix = [Source].GLSuffix

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn't exist in [Target], insert it
	INSERT (
		SnapshotId,
		ActivityTypeId,
		Code,
		Name,
		GLAccountSuffix,
		IsEscalatable,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
		-- ActivityTypeCode, -- can't update these as they are computed fields
		-- GLSuffix
	)
	VALUES (
		[Source].SnapshotId,
		[Source].ActivityTypeId,
		[Source].Code,
		[Source].Name,
		[Source].GLAccountSuffix,
		[Source].IsEscalatable,
		[Source].IsActive,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
		-- [Source].ActivityTypeCode, -- can't update these as they are computed fields
		-- [Source].GLSuffix
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn't exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don't hard delete the target record as this will probably break FK constraints on this table



GO
