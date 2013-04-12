  USE [GDM_GR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLTranslationSubType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotGLTranslationSubType]
GO

USE [GDM_GR]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotGLTranslationSubType table in the GDM_GR database 
	with the dbo.SnapshotGLTranslationSubType table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-08		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotGLTranslationSubType]
AS


MERGE
	GDM_GR.dbo.SnapshotGLTranslationSubType AS [Target]
USING
	(
		SELECT
			S.SnapshotId,
			GLTST.[GLTranslationSubTypeId],
			GLTST.[GLTranslationTypeId],
			GLTST.[Code],
			GLTST.[Name],
			GLTST.[IsActive],
			GLTST.[Version],
			GLTST.[InsertedDate],
			GLTST.[UpdatedDate],
			GLTST.[UpdatedByStaffId],
			GLTST.[IsGRDefault]
		FROM
			GDM_GR.dbo.GLTranslationSubType GLTST 
			
			CROSS JOIN GDM_GR.dbo.[Snapshot] S
	)
	AS [Source]
ON
	[Source].GLTranslationSubTypeId = [Target].GLTranslationSubTypeId AND
	[Source].SnapshotId = [Target].SnapshotId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]'s fields to be equal to [Source]'s fields (besides the PK field)
	UPDATE SET
		[Target].GLTranslationTypeId = [Source].GLTranslationTypeId,
		[Target].Code = [Source].Code,
		[Target].Name = [Source].Name,
		[Target].IsActive = [Source].IsActive,  
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId,
		[Target].IsGRDefault = [Source].IsGRDefault
WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn't exist in [Target], insert it
	INSERT (
		SnapshotId,
		[GLTranslationSubTypeId],
		[GLTranslationTypeId],
		[Code],
		[Name],
		[IsActive],
		[InsertedDate],
		[UpdatedDate],
		[UpdatedByStaffId],
		[IsGRDefault]
	)
	VALUES (
			[Source].SnapshotId,
			[Source].[GLTranslationSubTypeId],
			[Source].[GLTranslationTypeId],
			[Source].[Code],
			[Source].[Name],
			[Source].[IsActive],
			[Source].[InsertedDate],
			[Source].[UpdatedDate],
			[Source].[UpdatedByStaffId],
			[Source].[IsGRDefault]
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn't exist in [Source], delete it in [Target]
	UPDATE SET
		[Target].IsActive = 0;


GO
