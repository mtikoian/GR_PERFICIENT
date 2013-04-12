USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetGlobalGlAccountCategoryTranslation]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gr].[GetGlobalGlAccountCategoryTranslation]
GO

USE [GrReportingStaging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [Gr].[GetGlobalGlAccountCategoryTranslation]
	(@DataPriorToDate DATETIME)

RETURNS @GLAccountCategories TABLE (
		GlobalAccountCategoryCode VARCHAR(33) NULL,
		TranslationTypeName VARCHAR(50) NOT NULL,
		TranslationSubTypeName VARCHAR(50) NOT NULL,
		GLMajorCategoryId INT NOT NULL,
		GLMajorCategoryName VARCHAR(50) NOT NULL,
		GLMinorCategoryId INT NOT NULL,
		GLMinorCategoryName VARCHAR(100) NOT NULL,
		FeeOrExpense VARCHAR(7) NOT NULL,
		GLAccountSubTypeName VARCHAR(50) NULL,
		IsActive BIT NOT NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL
	)
AS

BEGIN	

	INSERT INTO @GLAccountCategories (
		GlobalAccountCategoryCode,
		TranslationTypeName,
		TranslationSubTypeName,
		GLMajorCategoryId,
		GLMajorCategoryName,
		GLMinorCategoryId,
		GLMinorCategoryName,
		FeeOrExpense,
		GLAccountSubTypeName,
		IsActive,
		InsertedDate,
		UpdatedDate
	)

--------------------------------------------------------------------------------------------------------------------------------------------

	-- Get 'UNKNOWN' GL Account Category records for each Translation SubType

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
		1,
		'1900-01-01',
		'1900-01-01'	
	FROM
	
		(
			SELECT
				TT.*
			FROM
				Gdm.GLTranslationType TT
				INNER JOIN
					Gdm.GLTranslationTypeActive(@DataPriorToDate) TTA
					ON TTA.ImportKey = TT.ImportKey
		) TT
	
		INNER JOIN (
			SELECT
				TST.*
			FROM
				Gdm.GLTranslationSubType TST
				INNER JOIN
					Gdm.GLTranslationSubTypeActive(@DataPriorToDate) TSTA 
					ON TSTA.ImportKey = TST.ImportKey
		) TST ON TT.GLTranslationTypeId = TST.GLTranslationTypeId

	------------------

	UNION

	------------------

	/*  Sample output from the SELECT below:

		GlobalAccountCategoryCode	TranslationTypeName	TranslationSubTypeName	GLMajorCategoryId	GLMajorCategoryName			GLMinorCategoryId	GLMinorCategoryName				FeeOrExpense	GLAccountSubTypeName
		1:233:18:490:1:1			Global				Global					18					Legal & Professional Fees	490					Legal - HR Related - Non-Union	EXPENSE			Non-Payroll
	*/

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
		CASE
			WHEN									-- Every record that is used to construct the GL Account Category record needs to be active
				TST.IsActive = 1 AND				-- for the GL Account Category record to be active itself.
				GLATST.IsActive = 1 AND
				GLATT.IsActive = 1 AND
				TT.IsActive = 1 AND
				MajC.IsActive = 1 AND
				MinC.IsActive = 1 AND
				AST.IsActive = 1 AND
				AT.IsActive = 1
			THEN
				1
			ELSE
				0
		END AS IsActive, 
		MIN(GLATT.InsertedDate) InsertedDate,
		MAX(GLATT.UpdatedDate) UpdatedDate
	FROM
		Gdm.GLTranslationSubType TST
		
		INNER JOIN Gdm.GLGlobalAccountTranslationSubType GLATST ON
			TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId					
			
		INNER JOIN Gdm.GLGlobalAccountTranslationType GLATT ON
			GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
			TST.GLTranslationTypeId = GLATT.GLTranslationTypeId
					
		INNER JOIN Gdm.GLTranslationType TT ON
			GLATT.GLTranslationTypeId = TT.GLTranslationTypeId
	
		INNER JOIN Gdm.GLMinorCategory MinC ON
			GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId

		INNER JOIN Gdm.GLMajorCategory MajC ON
			MinC.GLMajorCategoryId = MajC.GLMajorCategoryId

		INNER JOIN Gdm.GLAccountSubType AST ON
			GLATT.GLAccountSubTypeId = AST.GLAccountSubTypeId
			
		INNER JOIN Gdm.GLAccountType AT ON
			GLATT.GLAccountTypeId = AT.GLAccountTypeId 
			
		INNER JOIN Gdm.GLTranslationSubTypeActive(@DataPriorToDate) TSTA ON 
			TSTA.ImportKey = TST.ImportKey	
			
		INNER JOIN Gdm.GLGlobalAccountTranslationSubTypeActive(@DataPriorToDate) GLATSTA ON 
			GLATSTA.ImportKey = GLATST.ImportKey
			
		INNER JOIN Gdm.GLTranslationTypeActive(@DataPriorToDate) TTA ON 
			TTA.ImportKey = TT.ImportKey	
			
		INNER JOIN Gdm.GLGlobalAccountTranslationTypeActive(@DataPriorToDate) GLATTA ON 
			GLATTA.ImportKey = GLATT.ImportKey	
			
		INNER JOIN Gdm.GLMinorCategoryActive(@DataPriorToDate) MinCA ON 
			MinCA.ImportKey = MinC.ImportKey
			
		INNER JOIN Gdm.GLMajorCategoryActive(@DataPriorToDate) MajCA ON 
			MajCA.ImportKey = MajC.ImportKey	
			
		INNER JOIN Gdm.GLAccountSubTypeActive(@DataPriorToDate) ASTA ON 
			ASTA.ImportKey = AST.ImportKey	
			
		INNER JOIN Gdm.GLAccountTypeActive(@DataPriorToDate) ATA ON
			ATA.ImportKey = AT.ImportKey 	
			
	GROUP BY
		TT.GLTranslationTypeId,
		TT.Name,		
		TST.GLTranslationSubTypeId,
		TST.Name,
		MajC.GLMajorCategoryId,
		MajC.Name,
		MinC.GLMinorCategoryId,
		MinC.Name,
		CASE
			WHEN
				AT.Code LIKE '%EXP%'
			THEN
				'EXPENSE' 
			WHEN
				AT.Code LIKE '%INC%'
			THEN
				'INCOME'
			ELSE
				'UNKNOWN'
		END,
		AT.GLAccountTypeId,
		AST.Name,
		AST.GLAccountSubTypeId,
		CASE
			WHEN
				TST.IsActive = 1 AND
				GLATST.IsActive = 1 AND
				GLATT.IsActive = 1 AND
				TT.IsActive = 1 AND
				MajC.IsActive = 1 AND
				MinC.IsActive = 1 AND
				AST.IsActive = 1 AND
				AT.IsActive = 1
			THEN
				1
			ELSE
				0
		END

--------------------------------------------------------------------------------------------------------------------------------------------

	DECLARE @GLAccountCategories_GLAccountSubTypeAsOverhead TABLE(
		GlobalAccountCategoryCode VARCHAR(33) NULL,
		TranslationTypeName VARCHAR(50) NOT NULL,
		TranslationSubTypeName VARCHAR(50) NOT NULL,
		GLMajorCategoryId INT NOT NULL,
		GLMajorCategoryName VARCHAR(50) NOT NULL,
		GLMinorCategoryId INT NOT NULL,
		GLMinorCategoryName VARCHAR(100) NOT NULL,
		FeeOrExpense VARCHAR(7) NOT NULL,
		GLAccountSubTypeName VARCHAR(50) NULL,
		IsActive BIT NOT NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL
	)
	
	DECLARE @GRPOHD_Name VARCHAR(50) = (SELECT TOP 1 Name FROM Gdm.GLAccountSubType WHERE Code = 'GRPOHD')
	DECLARE @GRPOHD_ID VARCHAR(10) = (SELECT LTRIM(STR(GLAccountSubTypeId, 10, 0)) FROM Gdm.GLAccountSubType WHERE Code = 'GRPOHD')
	
	/*
		For each GL Account Category record that has been inserted into @GLAccountCategories, a new record needs to be inserted that is identical to this
		record in every respect apart from its GLAccountSubType - this will be hardcoded from the original GLAccountSubType to 'Overhead'
		Note that in thet record below, all field values should be identical to the sample record above (around line 100) besides the
		GLAccountSubType field: this has been updated from 'Non-Payroll' to 'Overhead'.

		GlobalAccountCategoryCode	TranslationTypeName		TranslationSubTypeName	GLMajorCategoryId	GLMajorCategoryName			GLMinorCategoryId	GLMinorCategoryName					FeeOrExpense	GLAccountSubTypeName
		1:233:18:490:1:3			Global					Global					18					Legal & Professional Fees	490					Legal - HR Related - Non-Union		EXPENSE			Overhead
	*/

	INSERT INTO @GLAccountCategories_GLAccountSubTypeAsOverhead (
		GlobalAccountCategoryCode,
		TranslationTypeName,
		TranslationSubTypeName,
		GLMajorCategoryId,
		GLMajorCategoryName,
		GLMinorCategoryId,
		GLMinorCategoryName,
		FeeOrExpense,
		GLAccountSubTypeName,
		IsActive,
		InsertedDate,
		UpdatedDate
	)
	SELECT	
		DISTINCT
		REVERSE(SUBSTRING(REVERSE(GlobalAccountCategoryCode),
						  PATINDEX('%:%', REVERSE(GlobalAccountCategoryCode)),
						  LEN(GlobalAccountCategoryCode))
						  ) + @GRPOHD_ID -- we can hardcode the ID of the 'Overhead' GLAccountSubType record
		AS GlobalAccountCategoryCode,
		TranslationTypeName,
		TranslationSubTypeName,
		GLMajorCategoryId,
		GLMajorCategoryName,
		GLMinorCategoryId,
		GLMinorCategoryName,
		FeeOrExpense,
		@GRPOHD_Name AS GLAccountSubTypeName, -- Instead of selecting the original GLAccountSubType, hardcode 'Overhead'
		IsActive,
		InsertedDate,
		UpdatedDate
	FROM
		@GLAccountCategories
		
	-- Insert the new 'Overhead' GL Account Category records into @GLAccountCategories that do not already exist in @GLAccountCategories.
	
	INSERT INTO @GLAccountCategories (
		GlobalAccountCategoryCode,
		TranslationTypeName,
		TranslationSubTypeName,
		GLMajorCategoryId,
		GLMajorCategoryName,
		GLMinorCategoryId,
		GLMinorCategoryName,
		FeeOrExpense,
		GLAccountSubTypeName,
		IsActive,
		InsertedDate,
		UpdatedDate
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
		t1.IsActive,
		t1.InsertedDate,
		t1.UpdatedDate
	FROM
		@GLAccountCategories_GLAccountSubTypeAsOverhead t1

		LEFT OUTER JOIN @GLAccountCategories t2 ON
			t1.GlobalAccountCategoryCode = t2.GlobalAccountCategoryCode
	WHERE
		t2.GlobalAccountCategoryCode IS NULL
		
	RETURN

END

GO
