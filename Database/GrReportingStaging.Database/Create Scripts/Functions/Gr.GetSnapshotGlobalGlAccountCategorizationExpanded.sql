 USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetSnapshotGlobalGlAccountCategorizationExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION Gr.GetSnapshotGlobalGlAccountCategorizationExpanded
GO

CREATE FUNCTION Gr.GetSnapshotGlobalGlAccountCategorizationExpanded()	
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
		SnapshotId INT NOT NULL,
		IsActive BIT NOT NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL
	)
AS

BEGIN
	
	-- The purpose of this table is to combine the columns of DirectGLMinorCategoryId, IndirectGLMinorCategoryId and CoAGLMinorCategoryId
	DECLARE @GLGlobalAccountCategorization TABLE 
	(
		SnapshotId INT NOT NULL,
		GLCategorizationId INT NOT NULL,
		GLMinorCategoryId INT NOT NULL,
		GLGlobalAccountId INT NOT NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL
	)
	INSERT INTO @GLGlobalAccountCategorization(
		SnapshotId,
		GLCategorizationId,
		GLMinorCategoryId,
		GLGlobalAccountId,
		InsertedDate,
		UpdatedDate
	)
	SELECT
		GGAC.SnapshotId,
		GGAC.GLCategorizationId,
		GGAC.DirectGLMinorCategoryId AS GLMinorCategoryId,
		GLGlobalAccountId,
		InsertedDate,
		UpdatedDate
	FROM
		Gdm.SnapshotGLGlobalAccountCategorization GGAC 
	WHERE
		GGAC.DirectGLMinorCategoryId IS NOT NULL
	
	UNION
	
	SELECT
		GGAC.SnapshotId,
		GGAC.GLCategorizationId,
		GGAC.IndirectGLMinorCategoryId AS GLMinorCategoryId,
		GLGlobalAccountId,
		InsertedDate,
		UpdatedDate
	FROM
		Gdm.SnapshotGLGlobalAccountCategorization GGAC 
	WHERE
		GGAC.IndirectGLMinorCategoryId IS NOT NULL
	UNION
	
	SELECT
		GGAC.SnapshotId,
		GGAC.GLCategorizationId,
		GGAC.CoAGLMinorCategoryId AS GLMinorCategoryId,
		GLGlobalAccountId,
		InsertedDate,
		UpdatedDate
	FROM
		Gdm.SnapshotGLGlobalAccountCategorization GGAC 
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
		SnapshotId,
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
		GLA.SnapshotId,
		GLA.IsActive,
		GLA.InsertedDate,
		GLA.UpdatedDate
	FROM
		Gdm.SnapshotGLGlobalAccount GLA
				
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
		GCT.SnapshotId,
		GCT.IsActive & GC.IsActive & MajC.IsActive & MinC.IsActive & GGA.IsActive IsActive,
		( -- Select the highest Inserted Date from all the tables used
			SELECT TOP 1 Dates.InsertedDate
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
			ORDER BY Dates.InsertedDate DESC
		) InsertedDate,
		( -- Select the highest Updated Date from all the tables used
			SELECT TOP 1 Dates.UpdatedDate
			FROM
			(
				SELECT GC.UpdatedDate UNION 
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
		Gdm.SnapshotGLCategorizationType GCT
		
		INNER JOIN Gdm.SnapshotGLCategorization GC ON
			GCT.GLCategorizationTypeId = GC.GLCategorizationTypeId AND
			GCT.SnapshotId = GC.SnapshotId
			
		INNER JOIN @GLGlobalAccountCategorization GGAC ON
			GGAC.GLCategorizationId = GC.GLCategorizationId AND
			GGAC.SnapshotId = GC.SnapshotId
			
		INNER JOIN Gdm.SnapshotGLGlobalAccount GGA ON
			GGA.GLGlobalAccountId = GGAC.GLGlobalAccountId AND
			GGA.SnapshotId = GGAC.SnapshotId
			
		INNER JOIN Gdm.SnapshotGLMinorCategory MinC ON
			MinC.GLMinorCategoryId = GGAC.GLMinorCategoryId AND
			MinC.SnapshotId = GGAC.SnapshotId
			
		INNER JOIN Gdm.SnapshotGLMajorCategory MajC ON
			MajC.GLMajorCategoryId = MinC.GLMajorCategoryID AND
			MajC.SnapshotId = MinC.SnapshotId
			
		INNER JOIN Gdm.SnapshotGLFinancialCategory GFC ON
			GFC.GLFinancialCategoryId = MajC.GLFinancialCategoryId AND
			GFC.SnapshotId = MajC.SnapshotId
			
	UNION
	
	SELECT
		CONVERT(VARCHAR(32), LTRIM(STR(GCT.GLCategorizationTypeId, 10, 0)) + ':' + 
			LTRIM(STR(GC.GLCategorizationId, 10, 0)) + ':' +
			LTRIM(STR(GFC.GLFinancialCategoryId, 10, 0)) + ':' +
			LTRIM(STR(MajC.GLMajorCategoryId, 10, 0)) + ':' + 
			LTRIM(STR(MinC.GLMinorCategoryId, 10, 0)) + ':0') GlobalAccountCategoryCode,
		GCT.Name, -- GLCategorizationTypeName,
		GC.Name, -- GLCategorizationName,
		GFC.Name, -- GLFinancialCategoryName,
		GFC.InflowOutflow,
		MajC.GLMajorCategoryId,
		MajC.Name, -- GLMajorCategoryName,
		MinC.GLMinorCategoryId, 
		MinC.Name, --GLMinorCategoryName,
		0,
		'N/A', -- GL Account Name
		'N/A', -- GL Account Code
		MinC.SnapshotId,
		MinC.IsActive & MajC.IsActive IsActive,
		MinC.InsertedDate,
		MinC.UpdatedDate
		
	FROM
		Gdm.SnapshotGLMinorCategory MinC
			
		INNER JOIN Gdm.SnapshotGLMajorCategory MajC ON
			MajC.GLMajorCategoryId = MinC.GLMajorCategoryID AND
			MajC.SnapshotId = MinC.SnapshotId AND
			MajC.Name = 'Salaries/Taxes/Benefits'
			
		INNER JOIN Gdm.SnapshotGLFinancialCategory GFC ON
			GFC.GLFinancialCategoryId = MajC.GLFinancialCategoryId AND
			GFC.SnapshotId = MajC.SnapshotId 
			
		INNER JOIN Gdm.SnapshotGLCategorization GC ON
			GFC.GLCategorizationId = GC.GLCategorizationId AND
			GFC.SnapshotId = GC.SnapshotId
			
		INNER JOIN Gdm.SnapshotGLCategorizationType GCT ON
			GCT.GLCategorizationTypeId = GC.GLCategorizationTypeId AND
			GCT.SnapshotId = GC.SnapshotId

	
RETURN

END

GO