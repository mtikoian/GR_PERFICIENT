USE [GDM_GR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncGLGlobalAccountTranslationSubType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncGLGlobalAccountTranslationSubType]
GO

USE [GDM_GR]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.GLGlobalAccountTranslationSubType table in the GDM_GR database with the 
	GDM.dbo.GLGlobalAccountCategorization table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncGLGlobalAccountTranslationSubType]
AS

SET IDENTITY_INSERT GDM_GR.dbo.GLGlobalAccountTranslationSubType ON

MERGE
	GDM_GR.dbo.GLGlobalAccountTranslationSubType AS [Target]
USING
	(
		SELECT
			*
		FROM
			GDM.dbo.GLGlobalAccountCategorization
		WHERE
			GLCategorizationId = 233 AND
			DirectGLMinorCategoryId IS NOT NULL
	) AS [Source]
ON
	[Source].GLGlobalAccountCategorizationId = [Target].GLGlobalAccountTranslationSubTypeId -- match where primary keys are equal

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

SET IDENTITY_INSERT GDM_GR.dbo.GLGlobalAccountTranslationSubType OFF

GO
