USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetSnapshotGlobalGlAccountCategoryTranslation]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gr].[GetSnapshotGlobalGlAccountCategoryTranslation]
GO

USE [GrReportingStaging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [Gr].[GetSnapshotGlobalGlAccountCategoryTranslation] ()

RETURNS @Result TABLE (
	GlobalAccountCategoryCode VARCHAR(33) NULL,
	TranslationTypeName VARCHAR(50) NOT NULL,
	TranslationSubTypeName VARCHAR(50) NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	GLMajorCategoryName VARCHAR(50) NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLMinorCategoryName VARCHAR(100) NOT NULL,
	FeeOrExpense VARCHAR(7) NOT NULL,
	GLAccountSubTypeName VARCHAR(50) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	SnapshotId INT NOT NULL
)
AS

BEGIN
	
	INSERT INTO @Result (
		GlobalAccountCategoryCode,
		TranslationTypeName,
		TranslationSubTypeName,
		GLMajorCategoryId,
		GLMajorCategoryName,
		GLMinorCategoryId,
		GLMinorCategoryName,
		FeeOrExpense,
		GLAccountSubTypeName,
		InsertedDate,
		UpdatedDate,
		SnapshotId
	)
	SELECT	
		CONVERT(VARCHAR(32), LTRIM(STR(TT.GLTranslationTypeId, 10, 0)) + ':' + 
			LTRIM(STR(TST.GLTranslationSubTypeId, 10, 0)) + ':' + 
			LTRIM(STR(MajC.GLMajorCategoryId, 10, 0)) + ':' + 
			LTRIM(STR(MinC.GLMinorCategoryId, 10, 0)) + ':' + 
			LTRIM(STR(AT.GLAccountTypeId, 10, 0)) + ':' + 
			LTRIM(STR(AST.GLAccountSubTypeId, 10, 0))) GlobalAccountCategoryCode,
		TT.Name TranslationTypeName,
		TST.Name TranslationSubTypeName,
		MajC.GLMajorCategoryId,
		MajC.Name GLMajorCategoryName,
		MinC.GLMinorCategoryId,
		MinC.Name GLMinorCategoryName,
		CASE
			WHEN
				AT.Code LIKE '%EXP%'
			THEN
				'EXPENSE' 
			WHEN
				AT.Code LIKE '%INC%'
			THEN
				'INCOME'
			ELSE 'UNKNOWN'
		END AS FeeOrExpense,						-- sourced from Gdm.GlobalGlAccountCategoryHierarchy.AccountType
		AST.Name GLAccountSubTypeName,				-- used to be ExpenseType, sourced from Gdm.GlobalGlAccountCategoryHierarchy.ExpenseType
		MIN(GLATT.InsertedDate) InsertedDate,
		MAX(GLATT.UpdatedDate) UpdatedDate,
		TST.SnapshotId -- shouldn't matter which table we source the SnapshotId from - it should form part of all join criteria
	FROM
		Gdm.SnapshotGLTranslationSubType TST
		
		INNER JOIN Gdm.SnapshotGLGlobalAccountTranslationSubType GLATST ON
			TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
			TST.SnapshotId = GLATST.SnapshotId				
			
		INNER JOIN Gdm.SnapshotGLGlobalAccountTranslationType GLATT ON
			GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
			GLATST.SnapshotId = GLATT.SnapshotId AND
			TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
			TST.SnapshotId = GLATT.SnapshotId
					
		INNER JOIN Gdm.SnapshotGLTranslationType TT ON
			GLATT.GLTranslationTypeId = TT.GLTranslationTypeId AND
			GLATT.SnapshotId = TT.SnapshotId
	
		INNER JOIN Gdm.SnapshotGLGlobalAccount GLA ON
			GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId	AND
			GLATT.SnapshotId = GLA.SnapshotId
		
		INNER JOIN Gdm.SnapshotGLMinorCategory MinC ON
			GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
			GLATST.SnapshotId = MinC.SnapshotId

		INNER JOIN Gdm.SnapshotGLMajorCategory MajC ON
			MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
			MinC.SnapshotId = MajC.SnapshotId

		INNER JOIN Gdm.SnapshotGLAccountSubType AST ON
			GLATT.GLAccountSubTypeId = AST.GLAccountSubTypeId AND
			GLATT.SnapshotId = AST.SnapshotId
			
		INNER JOIN Gdm.SnapshotGLAccountType AT ON
			GLATT.GLAccountTypeId = AT.GLAccountTypeId AND
			GLATT.SnapshotId = AT.SnapshotId
/*			
		INNER JOIN Gdm.GLTranslationSubTypeActive(@DataPriorToDate) TSTA ON 
			TSTA.ImportKey = TST.ImportKey	
			
		INNER JOIN Gdm.GLGlobalAccountTranslationSubTypeActive(@DataPriorToDate) GLATSTA ON 
			GLATSTA.ImportKey = GLATST.ImportKey
			
		INNER JOIN Gdm.GLTranslationTypeActive(@DataPriorToDate) TTA ON 
			TTA.ImportKey = TT.ImportKey	
			
		INNER JOIN Gdm.GLGlobalAccountTranslationTypeActive(@DataPriorToDate) GLATTA ON 
			GLATTA.ImportKey = GLATT.ImportKey	
			
		INNER JOIN 	Gdm.GLGlobalAccountActive(@DataPriorToDate) GLAA ON
			GLAA.ImportKey = GLA.ImportKey	
			
		INNER JOIN Gdm.GLMinorCategoryActive(@DataPriorToDate) MinCA ON 
			MinCA.ImportKey = MinC.ImportKey
			
		INNER JOIN Gdm.GLMajorCategoryActive(@DataPriorToDate) MajCA ON 
			MajCA.ImportKey = MajC.ImportKey	
			
		INNER JOIN Gdm.GLAccountSubTypeActive(@DataPriorToDate) ASTA ON 
			ASTA.ImportKey = AST.ImportKey	
			
		INNER JOIN Gdm.GLAccountTypeActive(@DataPriorToDate) ATA ON
			ATA.ImportKey = AT.ImportKey 	
*/			
	GROUP BY
		TT.GLTranslationTypeId,
		TT.Name,		
		TST.GLTranslationSubTypeId,
		TST.Name,
		MajC.GLMajorCategoryId,
		MajC.Name,
		MinC.GLMinorCategoryId,
		MinC.Name,
		CASE WHEN AT.Code LIKE '%EXP%' THEN 'EXPENSE' 
			WHEN AT.Code LIKE '%INC%' THEN 'INCOME'
			ELSE 'UNKNOWN' END,
		AT.GLAccountTypeId,
		AST.Name,
		AST.GLAccountSubTypeId,
		TST.SnapshotId
/*	-- When using unknown values in the dimension tables, both actuals and snapshot records that are to be inserted into the fact tables will use
    -- the ACTUAL unknowns (with snapshotId = 0). At present it doesn't make sense to have unknowns for actuals, and for every snapshot that is
    -- represented in the dimensions. When an unknown record is needed, there will only be one version in the dimension - this will be sourced
    -- from the actuals - this is why the code below is commented: we don't need unknowns for snapshots, as the actual unknowns will be used.
	UNION
	
	SELECT
		LTRIM(STR(TT.GLTranslationTypeId, 10, 0)) + ':' + LTRIM(STR(TST.GLTranslationSubTypeId, 10, 0)) + ':-1:-1:-1:-1',
		TT.Name TranslationTypeName,
		TST.Name TranslationSubTypeName,
		-1,
		'UNKNOWN',
		-1,
		'UNKNOWN',
		'UNKNOWN',
		'UNKNOWN',
		'1900-01-01',
		'1900-01-01',
		TT.SnapshotId
		
	FROM
	
		(
			SELECT
				TT.*
			FROM
				Gdm.SnapshotGLTranslationType TT
			INNER JOIN
					Gdm.GLTranslationTypeActive(@DataPriorToDate) TTA
					ON TTA.ImportKey = TT.ImportKey
		) TT
	
		INNER JOIN (
			SELECT
				TST.*
			FROM
				Gdm.SnapshotGLTranslationSubType TST
				INNER JOIN
					Gdm.GLTranslationSubTypeActive(@DataPriorToDate) TSTA 
					ON TSTA.ImportKey = TST.ImportKey
		) TST ON
			TT.GLTranslationTypeId = TST.GLTranslationTypeId AND
			TT.SnapshotId = TST.SnapshotId
*/	
	DECLARE @Temp TABLE (
		GlobalAccountCategoryCode varchar(33) NULL,
		TranslationTypeName varchar(50) NOT NULL,
		TranslationSubTypeName varchar(50) NOT NULL,
		GLMajorCategoryId int NOT NULL,
		GLMajorCategoryName varchar(50) NOT NULL,
		GLMinorCategoryId int NOT NULL,
		GLMinorCategoryName varchar(100) NOT NULL,
		FeeOrExpense varchar(7) NOT NULL,
		GLAccountSubTypeName varchar(50) NULL,
		InsertedDate DateTime NOT NULL,
		UpdatedDate DateTime NOT NULL,
		SnapshotId INT NOT NULL
	)
	
		
	--Now add the virtual rows, for each Major&Minor combination, we need to have a copy combination, but the
	--GLAccountSubType must be Overhead instead of the original GLAccountSubType
	INSERT INTO @Temp (
		GlobalAccountCategoryCode,
		TranslationTypeName,
		TranslationSubTypeName,
		GLMajorCategoryId,
		GLMajorCategoryName,
		GLMinorCategoryId,
		GLMinorCategoryName,
		FeeOrExpense,
		GLAccountSubTypeName,
		InsertedDate,
		UpdatedDate,
		SnapshotId
	)
	SELECT	
		DISTINCT
		REVERSE(SUBSTRING(REVERSE(GlobalAccountCategoryCode), patindex('%:%',REVERSE(GlobalAccountCategoryCode)), LEN(GlobalAccountCategoryCode)))+
			(SELECT LTRIM(STR(GLAccountSubTypeId,10,0)) FROM Gdm.SnapshotGLAccountSubType WHERE Code = 'GRPOHD' AND SnapshotId = Result.SnapshotId) AS GlobalAccountCategoryCode,
		Result.TranslationTypeName,
		Result.TranslationSubTypeName,
		Result.GLMajorCategoryId,
		Result.GLMajorCategoryName,
		Result.GLMinorCategoryId,
		Result.GLMinorCategoryName,
		Result.FeeOrExpense,
		(SELECT Name FROM Gdm.SnapshotGLAccountSubType Where Code = 'GRPOHD' AND SnapshotId = Result.SnapshotId),
		Result.InsertedDate,
		Result.UpdatedDate,
		Result.SnapshotId
	FROM
		@Result Result
			
	INSERT INTO @Result (
		GlobalAccountCategoryCode,
		TranslationTypeName,
		TranslationSubTypeName,
		GLMajorCategoryId,
		GLMajorCategoryName,
		GLMinorCategoryId,
		GLMinorCategoryName,
		FeeOrExpense,
		GLAccountSubTypeName,
		InsertedDate,
		UpdatedDate,
		SnapshotId
	)
	SELECT
		t1.GlobalAccountCategoryCode,
		t1.TranslationTypeName,
		t1.TranslationSubTypeName,
		t1.GLMajorCategoryId,
		t1.GLMajorCategoryName,
		t1.GLMinorCategoryId,
		t1.GLMinorCategoryName,
		t1.FeeOrExpense,
		t1.GLAccountSubTypeName,
		t1.InsertedDate,
		t1.UpdatedDate,
		t1.SnapshotId
	FROM
		@Temp t1
		LEFT OUTER JOIN @Result t2 ON
			t1.GlobalAccountCategoryCode = t2.GlobalAccountCategoryCode AND
			t1.SnapshotId = t2.SnapshotId
	WHERE
		t2.GlobalAccountCategoryCode IS NULL
		
	RETURN 
END



GO


