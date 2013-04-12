 USE [GDM_GR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLGlobalAccountTranslationSubType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotGLGlobalAccountTranslationSubType]
GO

USE [GDM_GR]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotGLGlobalAccountTranslationSubType table in the GDM_GR database 
	with the dbo.SnapshotGLGlobalAccountCategorization table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-04		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotGLGlobalAccountTranslationSubType]
AS



MERGE
	GDM_GR.dbo.SnapshotGLGlobalAccountTranslationSubType AS [Target]
USING
	(
		SELECT
			*
		FROM
			GDM.dbo.SnapshotGLGlobalAccountCategorization
		WHERE
			GLCategorizationId = 233 AND
			DirectGLMinorCategoryId IS NOT NULL
	) AS [Source]
ON
	[Source].GLGlobalAccountCategorizationId = [Target].GLGlobalAccountTranslationSubTypeId AND
	[Source].SnapshotId = [Target].SnapshotId-- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]'s fields to be equal to [Source]'s fields (besides the PK field)
	UPDATE SET
		[Target].GLGlobalAccountId = [Source].GLGlobalAccountId,
		[Target].GLTranslationSubTypeId = [Source].GLCategorizationId,
		[Target].GLMinorCategoryId = [Source].DirectGLMinorCategoryId, -- DirectGLMinorCategoryId should equal DirectGLMinorCategoryId for 233
		[Target].IsActive = 1, -- IsActive field has been removed from GLGlobalAccountCategorization
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn't exist in [Target], insert it
	INSERT (
		SnapshotId,
		GLGlobalAccountTranslationSubTypeId,
		GLGlobalAccountId,
		GLTranslationSubTypeId,
		GLMinorCategoryId,
		PostingPropertyGLAccountCode,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].SnapshotId,
		[Source].GLGlobalAccountCategorizationId,
		[Source].GLGlobalAccountId,
		[Source].GLCategorizationId,
		[Source].DirectGLMinorCategoryId,
		NULL,
		1,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE AND [Target].GLTranslationSubTypeId = 233 THEN -- when a record exists in [Target] that doesn't exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don't hard delete the target record as this will probably break FK constraints on this table



GO
