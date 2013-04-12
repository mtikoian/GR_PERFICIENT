USE [GDM_GR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncGLMajorCategory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncGLMajorCategory]
GO

USE [GDM_GR]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.GLMajorCategory table in the GDM_GR database with the 
	dbo.GLMajorCategory table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncGLMajorCategory] AS

SET IDENTITY_INSERT GDM_GR.dbo.GLMajorCategory ON

MERGE
	GDM_GR.dbo.GLMajorCategory AS [Target]
USING
	(
		SELECT
			*
		FROM
			GDM.dbo.GLMajorCategory
		WHERE
			GLCategorizationId = 233 -- we're only syncing GLOBAL
	) AS [Source]
ON
	[Source].GLMajorCategoryId = [Target].GLMajorCategoryId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]'s fields to be equal to [Source]'s fields (besides the PK field)
	UPDATE SET
		[Target].GLTranslationSubTypeId = [Source].GLCategorizationId,
		[Target].Name = [Source].Name,
		[Target].IsActive = [Source].IsActive,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn't exist in [Target], insert it
	INSERT (
		GLMajorCategoryId,
		GLTranslationSubTypeId,
		Name,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].GLMajorCategoryId,
		[Source].GLCategorizationId, -- should always be 233 because of the (WHERE GLCategorizationId = 233) filter above
		[Source].Name,
		[Source].IsActive,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn't exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don't hard delete the target record as this will probably break FK constraints on this table

SET IDENTITY_INSERT GDM_GR.dbo.GLMajorCategory OFF

GO
