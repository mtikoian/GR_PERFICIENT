 USE [GDM_GR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLGLobalAccountGLAccount]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotGLGLobalAccountGLAccount]
GO

USE [GDM_GR]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotGLGlobalAccountGLAccount table in the GDM_GR database with the 
	dbo.SnapshotGLAccount table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-04		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotGLGLobalAccountGLAccount] AS

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


SELECT
	GLA.*,
	GGAGA.GLGlobalAccountGLAccountId
INTO 
	#Source
FROM
	GDM.dbo.SnapshotGLAccount GLA 
	INNER JOIN GDM_GR.dbo.GLGlobalAccountGLAccount GGAGA ON
		GLA.SourceCode = GGAGA.SourceCode AND 
		GLA.Code = GGAGA.Code AND
		GLA.GLGlobalAccountId = GGAGA.GLGlobalAccountId
WHERE
	GLA.GLGlobalAccountId IS NOT NULL

CREATE UNIQUE CLUSTERED INDEX #Source_SourceCode_Code_GLGlobalAccountId_SnapshotId
ON #Source
	(
		SourceCode,
		Code,
		GLGlobalAccountId,
		SnapshotId
	)

MERGE
	GDM_GR.dbo.SnapshotGLGlobalAccountGLAccount AS [Target]
USING
	
	#Source AS [Source]
ON
	[Source].SourceCode = [Target].SourceCode AND -- can't match primary keys as GLGlobalAccountGLAccountId and GLAccountId are different fields
	[Source].Code = [Target].Code AND
	[Source].GLGlobalAccountId = [Target].GLGlobalAccountId AND
	[Source].SnapshotId = [Target].SnapshotId

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
		SnapshotId,
		GLGlobalAccountGLAccountId,
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
		[Source].SnapshotId,
		[Source].GLGlobalAccountGLAccountId,
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
