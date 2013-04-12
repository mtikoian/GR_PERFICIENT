USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetGLCategorizationHierarchyExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION Gr.GetGLCategorizationHierarchyExpanded
GO

CREATE FUNCTION Gr.GetGLCategorizationHierarchyExpanded
	(@DataPriorToDate DATETIME)
	
RETURNS @GLAccountCategories TABLE
(
	GLCategorizationHierarchyCode VARCHAR(32) NULL,
	GLCategorizationTypeName VARCHAR(50) NOT NULL,
	GLCategorizationName VARCHAR(50) NOT NULL,
	GLFinancialCategoryName VARCHAR(50) NOT NULL,
	InflowOutflow VARCHAR(7) NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	GLMajorCategoryName VARCHAR(400) NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLMinorCategoryName VARCHAR(400) NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLGlobalAccountName VARCHAR(300) NOT NULL,
	GLGlobalAccountCode VARCHAR(10) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)
AS

BEGIN

	-- The purpose of this table is to combine the columns of DirectGLMinorCategoryId, IndirectGLMinorCategoryId and CoAGLMinorCategoryId
	DECLARE @GLGlobalAccountCategorization TABLE
	(
		GLCategorizationId INT NOT NULL,
		GLMinorCategoryId INT NOT NULL,
		GLGlobalAccountId INT NOT NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL
	)
	INSERT INTO @GLGlobalAccountCategorization
	(
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

	INSERT INTO @GLAccountCategories
	(
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
	/* ===========================================================================================================================================
		Records are created for each GL Global Account with unknown Categorization information (Major Account, Minor Account and Financial
			Category). This is to ensure that if the Categorization cannot be mapped, there will be a record available to map a transaction to
			which shows that the GL Global Account is known, but the Categorization information is unknown.
	   ======================================================================================================================================== */

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
		CONVERT(VARCHAR(10), GLA.GLCategorizationTypeId) + ':' +
			CONVERT(VARCHAR(10), GLA.GLCategorizationId) + 
			':-1:-1:-1:' + LTRIM(STR(GLA.GLGlobalAccountId, 10, 0)),
		GLA.GLCategorizationTypeName,
		GLA.GLCategorizationName,
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
				GCT.GLCategorizationTypeId,
				GCT.Name AS GLCategorizationTypeName,
				GC.GLCategorizationId,
				GC.Name AS GLCategorizationName,
				GLA.Name,
				GLA.Code,
				GLA.IsActive,
				GLA.InsertedDate,
				GLA.UpdatedDate
			FROM
				Gdm.GLGlobalAccount GLA
				INNER JOIN Gdm.GLGlobalAccountActive(@DataPriorToDate) GLAa ON
					GLA.ImportKey = GLAa.ImportKey
					
				LEFT OUTER JOIN Gdm.GLCategorization GC ON
					GC.GLCategorizationId = GC.GLCategorizationId -- Joins onto itself. Has the same effect as a cross join.
					
				INNER JOIN Gdm.GLCategorizationActive(@DataPriorToDate) GCa ON
					GC.ImportKey = GCa.ImportKey
					
				LEFT OUTER JOIN Gdm.GLCategorizationType GCT ON
					GC.GLCategorizationTypeId = GCT.GLCategorizationTypeId 
				
				INNER JOIN Gdm.GLCategorizationTypeActive(@DataPriorToDate) GCTa ON
					GCT.ImportKey = GCTa.ImportKey
		) GLA
		
	UNION

	/* ===========================================================================================================================================
		The Categorization information for each mapped GL Global Account is mapped below. This includes Direct, Indirect and CoA mappings.
	   =========================================================================================================================================*/

	SELECT
		CONVERT(VARCHAR(32),
			LTRIM(STR(GCT.GLCategorizationTypeId, 10, 0)) + ':' + 
			LTRIM(STR(GC.GLCategorizationId, 10, 0)) + ':' +
			LTRIM(STR(GFC.GLFinancialCategoryId, 10, 0)) + ':' +
			LTRIM(STR(MajC.GLMajorCategoryId, 10, 0)) + ':' + 
			LTRIM(STR(MinC.GLMinorCategoryId, 10, 0)) + ':' +
			LTRIM(STR(GGA.GLGlobalAccountId, 10, 0))
		) AS GLCategorizationHierarchyCode,
		GCT.Name AS GLCategorizationTypeName,
		GC.Name AS GLCategorizationName,
		GFC.Name AS GLFinancialCategoryName,
		GFC.InflowOutflow,
		MajC.GLMajorCategoryId,
		MajC.Name AS GLMajorCategoryName,
		MinC.GLMinorCategoryId,
		MinC.Name AS GLMinorCategoryName,
		GGA.GLGlobalAccountId,
		GGA.Name,
		GGA.Code,
		CAST((GCT.IsActive & GC.IsActive & MajC.IsActive & MinC.IsActive & GGA.IsActive) AS BIT) AS IsActive,
		(	/* Select the highest Inserted Date from all the tables used. This is because this record (which is composed of records from several
					other tables) only came into existence once all of the records that were used to created it were created */
			SELECT
				MAX(Dates.InsertedDate)
			FROM
			(
				SELECT GCT.InsertedDate UNION 
				SELECT GC.InsertedDate UNION 
				SELECT GFC.InsertedDate UNION 
				SELECT MajC.InsertedDate UNION 
				SELECT MinC.InsertedDate UNION 
				SELECT GGAC.InsertedDate UNION
				SELECT GGA.InsertedDate
			) Dates
		) AS InsertedDate,
		(	-- Select the highest Updated Date from all the tables used
			SELECT
				MAX(Dates.UpdatedDate)
			FROM
			(
				SELECT GCT.UpdatedDate UNION 
				SELECT GC.UpdatedDate UNION 
				SELECT GFC.UpdatedDate UNION 
				SELECT MajC.UpdatedDate UNION 
				SELECT MinC.UpdatedDate UNION 
				SELECT GGAC.UpdatedDate UNION
				SELECT GGA.UpdatedDate
			) Dates
		) AS UpdatedDate
	FROM
		Gdm.GLCategorizationType GCT

		INNER JOIN Gdm.GLCategorization GC ON
			GCT.GLCategorizationTypeId = GC.GLCategorizationTypeId

		INNER JOIN @GLGlobalAccountCategorization GGAC ON -- This combines Indirect, Direct and CoA mappings into one field.
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
