 USE [GDM_GR]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGLGLobalAccountGLAccount]    Script Date: 08/26/2011 17:39:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLGLobalAccountGLAccount]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotGLGLobalAccountGLAccount]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGLMajorCategory]    Script Date: 08/26/2011 17:39:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLMajorCategory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotGLMajorCategory]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGLAccountSubType]    Script Date: 08/26/2011 17:39:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLAccountSubType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotGLAccountSubType]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGLAccountSubType]    Script Date: 08/26/2011 17:39:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLAccountSubType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotGLAccountSubType table in the GDM_GR database 
	with the dbo.SnapshotGLAccountSubType table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-08		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotGLAccountSubType]
AS

--------------------------------------------------------------------------------------------------------------------------------------------------
-- The indexes on the view below are updated when this sync script is executed. Unfortunately, this causes the sync script to execute indefinitely.
-- To prevent this from happening, the view (and its indexes) are dropped before the sync script is executed, and then recreated afterwards.

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N''[dbo].[SnapshotGLGlobalAccountDetail]''))
	DROP VIEW [dbo].[SnapshotGLGlobalAccountDetail]


MERGE
	GDM_GR.dbo.SnapshotGLAccountSubType AS [Target]
USING
	(
		SELECT
			S.SnapshotId,
			GLAST.[GLAccountSubTypeId],
			GLAST.[GLTranslationTypeId],
			GLAST.[Code],
			GLAST.[Name],
			GLAST.[IsActive],
			GLAST.[InsertedDate],
			GLAST.[UpdatedDate],
			GLAST.[UpdatedByStaffId]
		FROM
			GDM_GR.dbo.GLAccountSubType GLAST 
			
			CROSS JOIN GDM_GR.dbo.[Snapshot] S
	)
	AS [Source]
ON
	[Source].GLAccountSubTypeId = [Target].GLAccountSubTypeId AND
	[Source].SnapshotId = [Target].SnapshotId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].GLTranslationTypeId = [Source].GLTranslationTypeId,
		[Target].Code = [Source].Code,
		[Target].Name = [Source].Name,
		[Target].IsActive = [Source].IsActive,  
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId
WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		SnapshotId,
		[GLAccountSubTypeId],
		[GLTranslationTypeId],
		[Code],
		[Name],
		[IsActive],
		[InsertedDate],
		[UpdatedDate],
		[UpdatedByStaffId]
	)
	VALUES (
			[Source].SnapshotId,
			[Source].[GLAccountSubTypeId],
			[Source].[GLTranslationTypeId],
			[Source].[Code],
			[Source].[Name],
			[Source].[IsActive],
			[Source].[InsertedDate],
			[Source].[UpdatedDate],
			[Source].[UpdatedByStaffId]
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], delete it in [Target]
	UPDATE SET
		[Target].IsActive = 0;


' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGLMajorCategory]    Script Date: 08/26/2011 17:39:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLMajorCategory]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotGLMajorCategory table in the GDM_GR database 
	with the dbo.SnapshotGLMajorCategory table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-04		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotGLMajorCategory] AS

--------------------------------------------------------------------------------------------------------------------------------------------------
-- The indexes on the view below are updated when this sync script is executed. Unfortunately, this causes the sync script to execute indefinitely.
-- To prevent this from happening, the view (and its indexes) are dropped before the sync script is executed, and then recreated afterwards.

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N''[dbo].[SnapshotGLGlobalAccountDetail]''))
	DROP VIEW [dbo].[SnapshotGLGlobalAccountDetail]


MERGE
	GDM_GR.dbo.SnapshotGLMajorCategory AS [Target]
USING
	(
		SELECT
			*
		FROM
			GDM.dbo.SnapshotGLMajorCategory
		WHERE
			GLCategorizationId = 233 -- we''re only syncing GLOBAL
	) AS [Source]
ON
	[Source].GLMajorCategoryId = [Target].GLMajorCategoryId AND
	[Source].SnapshotId = [Target].SnapshotId-- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].GLTranslationSubTypeId = [Source].GLCategorizationId,
		[Target].Name = [Source].Name,
		[Target].IsActive = [Source].IsActive,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		SnapshotId,
		GLMajorCategoryId,
		GLTranslationSubTypeId,
		Name,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].SnapshotId,
		[Source].GLMajorCategoryId,
		[Source].GLCategorizationId, -- should always be 233 because of the (WHERE GLCategorizationId = 233) filter above
		[Source].Name,
		[Source].IsActive,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don''t hard delete the target record as this will probably break FK constraints on this table


--------------------------------------------------------------------------------------------------------------------------------------------------
-- Recreate the view (and its indexes) that was dropped at the beginning of this stored procedure

IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N''[dbo].[SnapshotGLGlobalAccountDetail]''))
EXEC dbo.sp_executesql @statement = N''CREATE VIEW [dbo].[SnapshotGLGlobalAccountDetail] WITH SCHEMABINDING AS
SELECT 
	S.GroupKey as BudgetAllocationSetId,
	GLA.SnapshotId,
	GLA.GLGlobalAccountId,
    GLA.Code AS GLGlobalAccountCode,
    GLA.Name AS GLGlobalAccountName,
	MajC.GLMajorCategoryId,
    MajC.Name AS GLMajorCategoryName,
	MC.GLMinorCategoryId,
    MC.Name AS GLMinorCategoryName,
	GLATT.GLAccountTypeId,
	GLATT.GLAccountSubTypeId,
	TT.GLTranslationTypeId,
	TST.GLTranslationSubTypeId, 
	TT.Code AS TranslationTypeCode,
	TST.Code AS TranslationSubTypeCode,
	GLATST.PostingPropertyGLAccountCode,
	GLA.IsGbs,
	GLA.IsRegionalOverheadCost,
	GLA.ActivityTypeId,
	AST.Name AS GLAccountSubTypeName
FROM
	dbo.SnapshotGLGlobalAccount GLA
	
	INNER JOIN dbo.SnapshotGLGlobalAccountTranslationSubType GLATST ON
		GLA.GLGlobalAccountId = GLATST.GLGlobalAccountId AND
		GLA.SnapshotId = GLATST.SnapshotId 		
		
	INNER JOIN dbo.SnapshotGLTranslationSubType TST ON
		GLATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		GLATST.SnapShotId = TST.SnapshotId
	
	INNER JOIN dbo.SnapshotGLTranslationType TT ON
		TST.GLTranslationTypeId = TT.GLTranslationTypeId AND
		TST.SnapshotId = TT.SnapshotId
		
	INNER JOIN dbo.SnapshotGLGlobalAccountTranslationType GLATT ON
		GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId AND
		GLATT.SnapshotId = GLA.SnapshotId AND
		GLATT.GLTranslationTypeId = TT.GLTranslationTypeId 
				
	INNER JOIN dbo.SnapshotGLMinorCategory MC ON
		MC.GLMinorCategoryId = GLATST.GLMinorCategoryId AND
		MC.SnapshotId = GLATST.SnapshotId

    INNER JOIN dbo.SnapshotGLMajorCategory MajC ON
        MC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
		MC.SnapshotId = MajC.SnapshotId

	INNER JOIN dbo.SnapshotGLAccountSubType AST ON
		GLATT.GLAccountSubTypeId = AST.GLAccountSubTypeId AND
		GLA.SnapshotId = AST.SnapshotId
		
	INNER JOIN dbo.[Snapshot] S ON
		GLA.SnapshotId = S.SnapshotId
WHERE
	GLA.IsActive = 1 AND
	GLATST.IsActive = 1 AND 
	GLATT.IsActive = 1 AND
	S.GroupName = ''''BudgetAllocationSet''''
''
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[SnapshotGLGlobalAccountDetail]'') AND name = N''UX_GLGlobalAccountIdSnapshotIdTranslationSubTypeCodeTranslationTypeCode'')
	CREATE UNIQUE CLUSTERED INDEX [UX_GLGlobalAccountIdSnapshotIdTranslationSubTypeCodeTranslationTypeCode] ON [dbo].[SnapshotGLGlobalAccountDetail] 
	(
		[GLGlobalAccountId] ASC,
		[BudgetAllocationSetId] ASC,
		[TranslationSubTypeCode] ASC,
		[TranslationTypeCode] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[SnapshotGLGlobalAccountDetail]'') AND name = N''UX_GLGlobalAccountIdSnapshotIdTranslationSubTypeIdTranslationTypeId'')
	CREATE UNIQUE NONCLUSTERED INDEX [UX_GLGlobalAccountIdSnapshotIdTranslationSubTypeIdTranslationTypeId] ON [dbo].[SnapshotGLGlobalAccountDetail] 
	(
		[GLGlobalAccountId] ASC,
		[BudgetAllocationSetId] ASC,
		[GLTranslationSubTypeId] ASC,
		[GLTranslationTypeId] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

--------------------------------------------------------------------------------------------------------------------------------------------------

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGLGLobalAccountGLAccount]    Script Date: 08/26/2011 17:39:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLGLobalAccountGLAccount]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
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
	Description										[Default to '''']
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
	[Source].SourceCode = [Target].SourceCode AND -- can''t match primary keys as GLGlobalAccountGLAccountId and GLAccountId are different fields
	[Source].Code = [Target].Code AND
	[Source].GLGlobalAccountId = [Target].GLGlobalAccountId AND
	[Source].SnapshotId = [Target].SnapshotId

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].GLGlobalAccountId = [Source].GLGlobalAccountId,
		[Target].Code = [Source].Code,
		[Target].SourceCode = [Source].SourceCode,
		[Target].Name = [Source].Name,
		[Target].[Description] = '''',							-- Description: doesn''t exist in dbo.GLAccount, so default to ''''
		[Target].IsActive = [Source].IsActive,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
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
		'''',							-- Description: doesn''t exist in dbo.GLAccount, so default to ''''
		NULL,						-- PreGlobalAccountCode: doesn''t exist in dbo.GLAccount, so default to NULL
		[Source].IsActive,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], delete it in [Target].
	DELETE;						-- can''t deactivate as there is a good chance that dbo.GLGlobalAccountGLAccount_SourceCode_Code_IsActive_UniqueIndex
								-- will be triggered, causing the statement to fail.
								-- Deleting should be fine as there are no foreign key constraints onto dbo.GLGlobalAccountGLAccount

' 
END
GO
