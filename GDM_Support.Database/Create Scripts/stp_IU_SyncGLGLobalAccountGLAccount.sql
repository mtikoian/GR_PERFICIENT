USE [GDM_GR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncGLGLobalAccountGLAccount]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncGLGLobalAccountGLAccount]
GO

USE [GDM_GR]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.GLGlobalAccountGLAccount table in the GDM_GR database with the 
	GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncGLGLobalAccountGLAccount] AS

/*
	OLD							NEW
	--------------------------------------------------------
	GLGlobalAccountGLAccountId	GLAccountId
	GLGlobalAccount				GLGlobalAccount
	Code						Code
	SourceCode					SourceCode
	Name						Name
	Description										[Default to '']
	PreGlobalAccountCode
								EnglishName
								Type
								LastDate
	IsActive					IsActive
								IsHistoric
								IsGlobalReporting
								IsServiceCharge
								IsDirectRecharge
	InsertedDate				InsertedDate
	UpdatedDate					UpdatedDate
	UpdatedByStaffId			UpdatedByStaffId																									 */


MERGE
	GDM_GR.dbo.GLGlobalAccountGLAccount AS [Target]
USING
	(
		SELECT
			*
		FROM
			GDM.dbo.GLAccount
		WHERE
			GLGlobalAccountId IS NOT NULL
	)  AS [Source]
ON
	[Source].SourceCode = [Target].SourceCode AND -- can't match primary keys as GLGlobalAccountGLAccountId and GLAccountId are different fields
	[Source].Code = [Target].Code AND
	[Source].GLGlobalAccountId = [Target].GLGlobalAccountId

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]'s fields to be equal to [Source]'s fields (besides the PK field)
	UPDATE SET
		[Target].GLGlobalAccountId = [Source].GLGlobalAccountId,
		[Target].Code = [Source].Code,
		[Target].SourceCode = [Source].SourceCode,
		[Target].Name = [Source].Name,
		[Target].[Description] = '',							-- Description: doesn't exist in dbo.GLAccount, so default to ''
		[Target].IsActive = [Source].IsActive,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn't exist in [Target], insert it
	INSERT (
		GLGlobalAccountId,
		SourceCode,
		Code,
		Name,
		[Description],
		PreGlobalAccountCode,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].GLGlobalAccountId,
		[Source].SourceCode,
		[Source].Code,
		[Source].Name,
		'',							-- Description: doesn't exist in dbo.GLAccount, so default to ''
		NULL,						-- PreGlobalAccountCode: doesn't exist in dbo.GLAccount, so default to NULL
		[Source].IsActive,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn't exist in [Source], delete it in [Target].
	DELETE;						-- can't deactivate as there is a good chance that dbo.GLGlobalAccountGLAccount_SourceCode_Code_IsActive_UniqueIndex
								-- will be triggered, causing the statement to fail.
								-- Deleting should be fine as there are no foreign key constraints onto dbo.GLGlobalAccountGLAccount

GO
