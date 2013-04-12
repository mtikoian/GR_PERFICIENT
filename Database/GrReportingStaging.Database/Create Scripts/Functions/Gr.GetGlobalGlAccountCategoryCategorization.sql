USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetGlobalGlAccountCategoryCategorization]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION Gr.GetGlobalGlAccountCategoryCategorization
GO

CREATE FUNCTION Gr.GetGlobalGlAccountCategoryCategorization
	(@DataPriorToDate DATETIME)
	
RETURNS @GLAccountCategories TABLE (
		GlobalAccountCategoryCode VARCHAR(32) NULL,
		GLCategorizationTypeName VARCHAR(50) NOT NULL,
		GLCategorizationName VARCHAR(50) NOT NULL,
		GLFinancialCategoryName VARCHAR(50) NOT NULL,
		InflowOutflow VARCHAR(7) NOT NULL,
		GLMajorCategoryId INT NOT NULL,
		GLMajorCategoryName VARCHAR(50) NOT NULL,
		GLMinorCategoryId INT NOT NULL,
		GLMinorCategoryName VARCHAR(100) NOT NULL,
		IsActive BIT NOT NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL
	)
AS

BEGIN
	
	-- The purpose of this table is to combine the columns of DirectGLMinorCategoryId, IndirectGLMinorCategoryId and CoAGLMinorCategoryId
	DECLARE @GLGlobalAccountCategorization TABLE (
		GLCategorizationId INT NOT NULL,
		GLMinorCategoryId INT NOT NULL,
		GLGlobalAccountId INT NOT NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL
	)
	INSERT INTO @GLGlobalAccountCategorization(
		GLCategorizationId,
		GLMinorCategoryId,
		GLGlobalAccountId,
		InsertedDate,
		UpdatedDate
	)
	SELECT
		GGAC.GLCategorizationId,
		GGAC.DirectGLMinorCategoryId AS GLMinorCategoryId,
		GLGlobalAccountId,
		InsertedDate,
		UpdatedDate
	FROM
		Gdm.GLGlobalAccountCategorization GGAC 
		INNER JOIN Gdm.GLGlobalAccountCategorizationActive(@DataPriorToDate) GGACA ON
			GGACA.ImportKey = GGAC.ImportKey
	WHERE
		GGAC.DirectGLMinorCategoryId IS NOT NULL
	
	UNION
	
	SELECT
		GGAC.GLCategorizationId,
		GGAC.IndirectGLMinorCategoryId AS GLMinorCategoryId,
		GLGlobalAccountId,
		InsertedDate,
		UpdatedDate
	FROM
		Gdm.GLGlobalAccountCategorization GGAC 
		INNER JOIN Gdm.GLGlobalAccountCategorizationActive(@DataPriorToDate) GGACA ON
			GGACA.ImportKey = GGAC.ImportKey
	WHERE
		GGAC.IndirectGLMinorCategoryId IS NOT NULL
	UNION
	
	SELECT
		GGAC.GLCategorizationId,
		GGAC.CoAGLMinorCategoryId AS GLMinorCategoryId,
		GLGlobalAccountId,
		InsertedDate,
		UpdatedDate
	FROM
		Gdm.GLGlobalAccountCategorization GGAC 
		INNER JOIN Gdm.GLGlobalAccountCategorizationActive(@DataPriorToDate) GGACA ON
			GGACA.ImportKey = GGAC.ImportKey
	WHERE
		GGAC.CoAGLMinorCategoryId IS NOT NULL

	INSERT INTO @GLAccountCategories (
		GlobalAccountCategoryCode,
		GLCategorizationTypeName,
		GLCategorizationName,
		GLFinancialCategoryName,
		InflowOutflow,
		GLMajorCategoryId,
		GLMajorCategoryName,
		GLMinorCategoryId,
		GLMinorCategoryName,
		IsActive,
		InsertedDate,
		UpdatedDate
	)
	SELECT
		LTRIM(STR(GCT.GLCategorizationTypeId, 10, 0)) + ':' + LTRIM(STR(GC.GLCategorizationId, 10, 0)) + ':-1:-1:-1',
		GCT.Name GLCategorizationTypeName,
		GC.Name GLCategorizationName,
		'UNKNOWN',
		'UNKNOWN',
		-1,
		'UNKNOWN',
		-1,
		'UNKNOWN',
		1,
		'1900-01-01',
		'1900-01-01'
	FROM
		(
			SELECT
				GCT.GLCategorizationTypeId,
				GCT.Name
			FROM
				Gdm.GLCategorizationType GCT
				INNER JOIN GDM.GLCategorizationTypeActive(@DataPriorToDate) GCTA ON
					GCT.ImportKey = GCTA.ImportKey
		) GCT
		
		INNER JOIN (
			SELECT
				GC.GLCategorizationTypeId,
				GC.GLCategorizationId,
				GC.Name
			FROM
				Gdm.GLCategorization GC
				INNER JOIN Gdm.GLCategorizationActive(@DataPriorToDate) GCA ON
					GC.ImportKey = GCA.ImportKey
		) GC ON
			GCT.GLCategorizationTypeId = GC.GLCategorizationTypeId
				
	UNION
	
	SELECT
		CONVERT(VARCHAR(32), LTRIM(STR(GCT.GLCategorizationTypeId, 10, 0)) + ':' + 
			LTRIM(STR(GC.GLCategorizationId, 10, 0)) + ':' +
			LTRIM(STR(GFC.GLFinancialCategoryId, 10, 0)) + ':' +
			LTRIM(STR(MajC.GLMajorCategoryId, 10, 0)) + ':' + 
			LTRIM(STR(MinC.GLMinorCategoryId, 10, 0))) GlobalAccountCategoryCode,
			GCT.Name GLCategorizationTypeName,
			GC.Name GLCategorizationName,
			GFC.Name GLFinancialCategoryName,
			GFC.InflowOutflow InflowOutflow,
			MajC.GLMajorCategoryId GLMajorCategoryId,
			MajC.Name GLMajorCategoryName,
			MinC.GLMinorCategoryId GLMinorCategoryId,
			MinC.Name GLMinorCategoryName,
			GCT.IsActive & GC.IsActive & MajC.IsActive & MinC.IsActive IsActive,
			MIN(GGAC.InsertedDate) InsertedDate,
			MAX(GGAC.UpdatedDate) UpdatedDate
				
	FROM
		Gdm.GLCategorizationType GCT
		
		INNER JOIN Gdm.GLCategorization GC ON
			GCT.GLCategorizationTypeId = GC.GLCategorizationTypeId
			
		INNER JOIN @GLGlobalAccountCategorization GGAC ON
			GGAC.GLCategorizationId = GC.GLCategorizationId
			
		INNER JOIN Gdm.GLMinorCategory MinC ON
			MinC.GLMinorCategoryId = GGAC.GLMinorCategoryId
			
		INNER JOIN Gdm.GLMajorCategory MajC ON
			MajC.GLMajorCategoryId = MinC.GLMajorCategoryID
			
		INNER JOIN Gdm.GLFinancialCategory GFC ON
			GFC.GLFinancialCategoryId = MajC.GLFinancialCategoryId
			
		INNER JOIN Gdm.GLCategorizationTypeActive(@DataPriorToDate) GCTA ON
			GCTA.ImportKey = GCT.ImportKey
		
		INNER JOIN Gdm.GLCategorizationActive(@DataPriorToDate) GCA ON
			GCA.ImportKey = GC.ImportKey
			
		INNER JOIN Gdm.GLMinorCategoryActive(@DataPriorToDate) MinCA ON
			MinCA.ImportKey = MinC.ImportKey
			
		INNER JOIN Gdm.GLMajorCategoryActive(@DataPriorToDate) MajCA ON
			MajCA.ImportKey = MajC.ImportKey
			
		INNER JOIN Gdm.GLFinancialCategoryActive(@DataPriorToDate) GFCA ON
			GFCA.ImportKey = GFC.ImportKey
	GROUP BY
		GCT.GLCategorizationTypeId,
		GC.GLCategorizationId,
		GFC.GLFinancialCategoryId,
		GCT.Name,
		GC.Name,
		GFC.Name,
		GFC.InflowOutflow,
		MajC.GLMajorCategoryId,
		MajC.Name,
		MinC.GLMinorCategoryId,
		MinC.Name,
		GCT.IsActive & GC.IsActive & MajC.IsActive & MinC.IsActive

RETURN

END

GO