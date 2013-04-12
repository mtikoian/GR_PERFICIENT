USE [GDM_GR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncPropertyEntityGLAccountInclusion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncPropertyEntityGLAccountInclusion]
GO

USE [GDM_GR]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.PropertyEntityGLAccountInclusion table in the GDM_GR database with the 
	dbo.PropertyEntityGLAccountInclusion table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncPropertyEntityGLAccountInclusion]
AS

SET IDENTITY_INSERT GDM_GR.dbo.PropertyEntityGLAccountInclusion ON

MERGE
	GDM_GR.dbo.PropertyEntityGLAccountInclusion AS [Target]
USING
	GDM.dbo.PropertyEntityGLAccountInclusion AS [Source]
ON
	[Source].PropertyEntityGLAccountInclusionId = [Target].PropertyEntityGLAccountInclusionId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]'s fields to be equal to [Source]'s fields (besides the PK field)
	UPDATE SET
		[Target].PropertyEntityCode = [Source].PropertyEntityCode,
		[Target].GLAccountCode = [Source].GLAccountCode,
		[Target].SourceCode = [Source].SourceCode,
		[Target].IsDeleted = [Source].IsDeleted,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn't exist in [Target], insert it
	INSERT (
		PropertyEntityGLAccountInclusionId,
		PropertyEntityCode,
		GLAccountCode,
		SourceCode,
		IsDeleted,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].PropertyEntityGLAccountInclusionId,
		[Source].PropertyEntityCode,
		[Source].GLAccountCode,
		[Source].SourceCode,
		[Source].IsDeleted,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn't exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsDeleted = 1; -- Don't hard delete the target record as this will probably break FK constraints on this table

SET IDENTITY_INSERT GDM_GR.dbo.PropertyEntityGLAccountInclusion OFF

GO
