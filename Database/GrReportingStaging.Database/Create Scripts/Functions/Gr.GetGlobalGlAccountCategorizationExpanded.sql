USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetGlobalGlAccountCategorizationExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION Gr.GetGlobalGlAccountCategorizationExpanded
GO

CREATE FUNCTION Gr.GetGlobalGlAccountCategorizationExpanded
	(@DataPriorToDate DATETIME)
	
RETURNS @GLAccountCategories TABLE (
		GLCategorizationHierarchyCode VARCHAR(32) NULL,
		GLCategorizationTypeName VARCHAR(50) NOT NULL,
		GLCategorizationName VARCHAR(50) NOT NULL,
		GLFinancialCategoryName VARCHAR(50) NOT NULL,
		InflowOutflow VARCHAR(7) NOT NULL,
		GLMajorCategoryId INT NOT NULL,
		GLMajorCategoryName VARCHAR(50) NOT NULL,
		GLMinorCategoryId INT NOT NULL,
		GLMinorCategoryName VARCHAR(100) NOT NULL,
		GLGlobalAccountId INT NOT NULL,
		GLGlobalAccountName VARCHAR(150) NOT NULL,
		GLGlobalAccountCode VARCHAR(10) NOT NULL,
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
		GLCategorizationHierarchyCode,
		GLCategorizationTypeName,
		GLCategorizationName,
		GLFinancialCategoryName,
		InflowOutflow,
		GLMajorCategoryId,
		GLMajorCategoryName,
		GLMinorCategoryId,
		GLMinorCategoryName,
		GLGlobalAccountId,
		GLGlobalAccountName,
		GLGlobalAccountCode,
		IsActive,
		InsertedDate,
		UpdatedDate
	)
	SELECT
		'-1:-1:-1:-1:-1:' + LTRIM(STR(GLA.GLGlobalAccountId, 10, 0)),
		'UNKNOWN',
		'UNKNOWN',
		'UNKNOWN',
		'UNKNOWN',
		-1,
		'UNKNOWN',
		-1,
		'UNKNOWN',
		GLA.GLGlobalAccountId,
		GLA.Name,
		GLA.Code,
		GLA.IsActive,
		GLA.InsertedDate,
		GLA.UpdatedDate
	FROM
		(
			SELECT
				GLA.GLGlobalAccountId,
				GLA.Name,
				GLA.Code,
				GLA.IsActive,
				GLA.InsertedDate,
				GLA.UpdatedDate
			FROM
				Gdm.GLGlobalAccount GLA
				INNER JOIN Gdm.GLGlobalAccountActive(@DataPriorToDate) GLAa ON
					GLA.ImportKey = GLAa.ImportKey
		) GLA
		
				
	UNION
	
	SELECT
		CONVERT(VARCHAR(32), LTRIM(STR(GCT.GLCategorizationTypeId, 10, 0)) + ':' + 
			LTRIM(STR(GC.GLCategorizationId, 10, 0)) + ':' +
			LTRIM(STR(GFC.GLFinancialCategoryId, 10, 0)) + ':' +
			LTRIM(STR(MajC.GLMajorCategoryId, 10, 0)) + ':' + 
			LTRIM(STR(MinC.GLMinorCategoryId, 10, 0)) + ':' +
			LTRIM(STR(GGA.GLGlobalAccountId, 10, 0))) GlobalAccountCategoryCode,
		GCT.Name GLCategorizationTypeName,
		GC.Name GLCategorizationName,
		GFC.Name GLFinancialCategoryName,
		GFC.InflowOutflow InflowOutflow,
		MajC.GLMajorCategoryId GLMajorCategoryId,
		MajC.Name GLMajorCategoryName,
		MinC.GLMinorCategoryId GLMinorCategoryId,
		MinC.Name GLMinorCategoryName,
		GGA.GLGlobalAccountId,
		GGA.Name,
		GGA.Code,
		GCT.IsActive & GC.IsActive & MajC.IsActive & MinC.IsActive & GGA.IsActive IsActive,
		( -- Select the highest Inserted Date from all the tables used
			SELECT TOP 1 Dates.InsertedDate
			FROM
			(
				SELECT GCT.InsertedDate UNION 
				SELECT GCT.InsertedDate UNION 
				SELECT GFC.InsertedDate UNION 
				SELECT MajC.InsertedDate UNION 
				SELECT MinC.InsertedDate UNION 
				SELECT GGAC.InsertedDate UNION
				SELECT GGA.InsertedDate
			) Dates
			ORDER BY Dates.InsertedDate DESC
		) InsertedDate,
		( -- Select the highest Updated Date from all the tables used
			SELECT TOP 1 Dates.UpdatedDate
			FROM
			(
				SELECT GCT.UpdatedDate UNION 
				SELECT GCT.UpdatedDate UNION 
				SELECT GFC.UpdatedDate UNION 
				SELECT MajC.UpdatedDate UNION 
				SELECT MinC.UpdatedDate UNION 
				SELECT GGAC.UpdatedDate UNION
				SELECT GGA.UpdatedDate
			) Dates
			ORDER BY Dates.UpdatedDate DESC
		) UpdatedDate
				
	FROM
		Gdm.GLCategorizationType GCT
		
		INNER JOIN Gdm.GLCategorization GC ON
			GCT.GLCategorizationTypeId = GC.GLCategorizationTypeId
			
		INNER JOIN @GLGlobalAccountCategorization GGAC ON
			GGAC.GLCategorizationId = GC.GLCategorizationId
			
		INNER JOIN Gdm.GLGlobalAccount GGA ON
			GGA.GLGlobalAccountId = GGAC.GLGlobalAccountId
			
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
			
		INNER JOIN Gdm.GLGlobalAccountActive(@DataPriorToDate) GGAa ON
			GGA.ImportKey = GGAa.ImportKey	
			
		INNER JOIN Gdm.GLMinorCategoryActive(@DataPriorToDate) MinCA ON
			MinCA.ImportKey = MinC.ImportKey
			
		INNER JOIN Gdm.GLMajorCategoryActive(@DataPriorToDate) MajCA ON
			MajCA.ImportKey = MajC.ImportKey
			
		INNER JOIN Gdm.GLFinancialCategoryActive(@DataPriorToDate) GFCA ON
			GFCA.ImportKey = GFC.ImportKey


RETURN

END

GO