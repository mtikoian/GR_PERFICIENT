   USE [GDM_GR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLTranslationType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotGLTranslationType]
GO

USE [GDM_GR]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotGLTranslationType table in the GDM_GR database 
	with the dbo.SnapshotGLTranslationType table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-08		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotGLTranslationType]
AS


MERGE
	GDM_GR.dbo.SnapshotGLTranslationType AS [Target]
USING
	(
		SELECT
			S.SnapshotId,
			GLTT.[GLTranslationTypeId],
			GLTT.[Code],
			GLTT.[Name],
			GLTT.[Description],
			GLTT.[IsActive],
			GLTT.[InsertedDate],
			GLTT.[UpdatedDate],
			GLTT.[UpdatedByStaffId]
		FROM
			GDM_GR.dbo.GLTranslationType GLTT 
			
			CROSS JOIN GDM_GR.dbo.[Snapshot] S
	)
	AS [Source]
ON
	[Source].GLTranslationTypeId = [Target].GLTranslationTypeId AND
	[Source].SnapshotId = [Target].SnapshotId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]'s fields to be equal to [Source]'s fields (besides the PK field)
	UPDATE SET
		[Target].Code = [Source].Code,
		[Target].Name = [Source].Name,
		[Target].[Description] = [Source].[Description],
		[Target].IsActive = [Source].IsActive,  
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId
WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn't exist in [Target], insert it
	INSERT (
		SnapshotId,
		[GLTranslationTypeId],
		[Code],
		[Name],
		[Description],
		[IsActive],
		[InsertedDate],
		[UpdatedDate],
		[UpdatedByStaffId]
	)
	VALUES (
			[Source].SnapshotId,
			[Source].[GLTranslationTypeId],
			[Source].[Code],
			[Source].[Name],
			[Source].[Description],
			[Source].[IsActive],
			[Source].[InsertedDate],
			[Source].[UpdatedDate],
			[Source].[UpdatedByStaffId]
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn't exist in [Source], delete it in [Target]
	UPDATE SET
		[Target].IsActive = 0;


GO
