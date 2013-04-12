USE GrReportingStaging
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetSnapshotGLCategorizationHierarchyExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION Gr.GetSnapshotGLCategorizationHierarchyExpanded
GO

CREATE FUNCTION Gr.GetSnapshotGLCategorizationHierarchyExpanded()

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
		GGAC.GLGlobalAccountId,
		GGAC.InsertedDate,
		GGAC.UpdatedDate
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
		GGAC.GLGlobalAccountId,
		GGAC.InsertedDate,
		GGAC.UpdatedDate
	FROM
		Gdm.SnapshotGLGlobalAccountCategorization GGAC 
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
		SnapshotId,
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
		GLA.SnapshotId,
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
				GLA.UpdatedDate,
				GLA.SnapshotId
			FROM
				Gdm.SnapshotGLGlobalAccount GLA
	
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
		GLA.SnapshotId,
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
				GLA.UpdatedDate,
				GLA.SnapshotId
			FROM
				Gdm.SnapshotGLGlobalAccount GLA
					
				LEFT OUTER JOIN Gdm.SnapshotGLCategorization GC ON
					GLA.SnapshotId = GC.SnapshotId -- Joins onto itself. Has the same effect as a cross join.
					
				INNER JOIN Gdm.SnapshotGLCategorizationType GCT ON
					GC.GLCategorizationTypeId = GCT.GLCategorizationTypeId AND
					GC.SnapshotId = GCT.SnapshotId
				
		) GLA

	UNION

	/* ===========================================================================================================================================
		The Categorization information for each mapped GL Global Account is mapped below. This includes Direct, Indirect and CoA mappings.
	   ========================================================================================================================================= */
	
	SELECT
		CONVERT(VARCHAR(32),
			LTRIM(STR(GCT.GLCategorizationTypeId, 10, 0)) + ':' + 
			LTRIM(STR(GC.GLCategorizationId, 10, 0)) + ':' +
			LTRIM(STR(GFC.GLFinancialCategoryId, 10, 0)) + ':' +
			LTRIM(STR(MajC.GLMajorCategoryId, 10, 0)) + ':' + 
			LTRIM(STR(MinC.GLMinorCategoryId, 10, 0)) + ':' +
			LTRIM(STR(GGA.GLGlobalAccountId, 10, 0))) AS GlobalAccountCategoryCode,
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
		GCT.SnapshotId,
		GCT.IsActive & GC.IsActive & MajC.IsActive & MinC.IsActive & GGA.IsActive AS IsActive,
		(	-- Select the highest Inserted Date from all the tables used
			SELECT TOP 1
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
		) InsertedDate,
		(	-- Select the highest Updated Date from all the tables used
			SELECT TOP 1
				MAX(Dates.UpdatedDate)
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
		) UpdatedDate
	FROM
		Gdm.SnapshotGLCategorizationType GCT

		INNER JOIN Gdm.SnapshotGLCategorization GC ON
			GCT.GLCategorizationTypeId = GC.GLCategorizationTypeId AND
			GCT.SnapshotId = GC.SnapshotId

		INNER JOIN @GLGlobalAccountCategorization GGAC ON -- This combines Indirect, Direct and CoA mappings into one field.
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

	/* ===========================================================================================================================================
		Payroll data from Tapas Global Budgeting doesn't use GL Accounts. The portion below gets the Categorization mappings for payroll data and
			sets the GL Global Account information to 'N/A'.
	   ========================================================================================================================================= */
	
	SELECT
		CONVERT(VARCHAR(32),
			LTRIM(STR(GCT.GLCategorizationTypeId, 10, 0)) + ':' + 
			LTRIM(STR(GC.GLCategorizationId, 10, 0)) + ':' +
			LTRIM(STR(GFC.GLFinancialCategoryId, 10, 0)) + ':' +
			LTRIM(STR(MajC.GLMajorCategoryId, 10, 0)) + ':' + 
			LTRIM(STR(MinC.GLMinorCategoryId, 10, 0)) + ':0') GlobalAccountCategoryCode, -- Global Account Id is set to 0
		GCT.Name,					-- GLCategorizationTypeName,
		GC.Name,					-- GLCategorizationName,
		GFC.Name,					-- GLFinancialCategoryName,
		GFC.InflowOutflow,
		MajC.GLMajorCategoryId,
		MajC.Name,					-- GLMajorCategoryName,
		MinC.GLMinorCategoryId, 
		MinC.Name,					--GLMinorCategoryName,
		0,
		'N/A',						-- GL Account Name
		'N/A',						-- GL Account Code
		MinC.SnapshotId,
		GCT.IsActive & GC.IsActive & MinC.IsActive & MajC.IsActive AS IsActive,
		(	-- Select the highest Inserted Date from all the tables used
			SELECT
				MAX(InsertedDates.InsertedDate)
			FROM
				(
					SELECT GCT.InsertedDate UNION
					SELECT GC.InsertedDate UNION
					SELECT GFC.InsertedDate UNION
					SELECT MajC.InsertedDate UNION
					SELECT MinC.InsertedDate
				) InsertedDates
		) AS InsertedDate,
		(	-- Select the highest Updated Date from all the tables used
			SELECT
				MAX(UpdatedDates.UpdatedDate)
			FROM
				(
					SELECT GCT.UpdatedDate UNION
					SELECT GC.UpdatedDate UNION
					SELECT GFC.UpdatedDate UNION
					SELECT MajC.UpdatedDate UNION
					SELECT MinC.UpdatedDate
				) UpdatedDates
		) AS UpdatedDate
	FROM
		Gdm.SnapshotGLMinorCategory MinC

		INNER JOIN Gdm.SnapshotGLMajorCategory MajC ON
			MajC.GLMajorCategoryId = MinC.GLMajorCategoryID AND
			MajC.SnapshotId = MinC.SnapshotId AND
			MajC.Name = 'Salaries/Taxes/Benefits' -- Limits this to Payroll information.

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
