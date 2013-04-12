 DECLARE @SnapshotId INT = 10 -- The SnapshotId that is to be used when determining the Categorization hierarchy of the facts' global accounts

DECLARE @First2010CalendarKey INT = (SELECT MIN(CalendarKey) FROM GrReporting.dbo.Calendar WHERE CalendarYear = 2010) 
DECLARE @Last2010CalendarKey INT = (SELECT MAX(CalendarKey) FROM GrReporting.dbo.Calendar WHERE CalendarYear = 2010)

/* =============================================================================================================================================
	Get all 2010 transactions from the ProfitabilityBudget and ProfitabilityReforecast facts.
	
		Also, determine the 'type' of each transaction (Fee Income, Payroll, Non-Payroll, Allocated Overhead) by looking at its Major Category.
		
			Major Category						Transaction Type
				UNKNOWN								Fee Income / Non-Payroll / UNKNOWN (based off ReferenceCode)
				Fee Income							Fee Income
				Salaries/Taxes/Benefits				Payroll
				General Overhead					Allocated Overhead
				Non-Payroll							Non-Payroll (default to this of it's not any of the previous ones)
	
	Takes ~  minutes 4:13 on BISQLDEV for query (excluding index creation)
		
   =========================================================================================================================================== */
BEGIN

	IF 	OBJECT_ID('tempdb..#2010Transactions') IS NOT NULL
		DROP TABLE #2010Transactions

	SELECT DISTINCT
		Transactions2010.IsOriginalBudget,
		Transactions2010.ReferenceCode,
		ActivityType.ActivityTypeId,
		ISNULL(FunctionalDepartments.FunctionalDepartmentId, -1) AS FunctionalDepartmentId,
		GLAccountCategory.GlobalGlAccountCategoryCode,
		GLAccountCategory.MajorCategoryName,
		GLAccountCategory.MinorCategoryName,
		CASE
			WHEN
				CHARINDEX('-', GLAccountCategory.GlobalGlAccountCategoryCode) = 0 -- If the code does not contain an unknown (-1)
			THEN
				SUBSTRING(GLAccountCategory.GlobalGlAccountCategoryCode, 7, LEN(GLAccountCategory.GlobalGlAccountCategoryCode)-10)
			ELSE
				SUBSTRING(GLAccountCategory.GlobalGlAccountCategoryCode, 7, LEN(GLAccountCategory.GlobalGlAccountCategoryCode)-12)
		END AS MajorMinorId,
		NULL AS MajorCategoryId,
		NULL AS MinorCategoryId,
		GLAccount.GLGlobalAccountId,
		Overhead.OverheadName,
		CASE
			WHEN -- If the Minor Category is UNKNOWN then we will try and determine the Financial Category from the ReferenceCode
				GlAccountCategory.MajorCategoryName = 'UNKNOWN'
			THEN
				CASE -- NB: There are no Payroll unknowns. All unknowns seem to be Non-Payroll
					WHEN
						Transactions2010.ReferenceCode LIKE 'BC:%' AND
						Transactions2010.ReferenceCode LIKE '%FeeIncomeId=%' AND
						Transactions2010.ReferenceCode LIKE '%NonPayrollExpenseId=0&%'
					THEN
						'Fee Income'
					WHEN
						Transactions2010.ReferenceCode LIKE 'BC:%' AND
						Transactions2010.ReferenceCode LIKE '%FeeIncomeId=0&%' AND
						Transactions2010.ReferenceCode LIKE '%NonPayrollExpenseId=%'
					THEN
						'Non-Payroll'
					ELSE
						'UNKNOWN'
				END
			ELSE
				CASE
					WHEN
						GlAccountCategory.MajorCategoryName = 'Fee Income'
					THEN
						'Fee Income'
					WHEN
						GlAccountCategory.MajorCategoryName = 'Salaries/Taxes/Benefits'
					THEN
						'Payroll'
					WHEN
						GlAccountCategory.MajorCategoryName = 'General Overhead'
					THEN
						'Allocated Overhead'
					ELSE
						'Non-Payroll'
				END
		END AS TransactionType,
		
		ISNULL(ReportingCategorizations.GLCategorizationId, -1) AS DefaultGLCategorizationId
	INTO
		#2010Transactions
	FROM
		(
			SELECT
				1 AS IsOriginalBudget,
				ReferenceCode,
				GlobalGlAccountCategoryKey,
				GlAccountKey,
				ActivityTypeKey,
				FunctionalDepartmentKey,
				OverheadKey,
				PropertyFundKey,
				AllocationRegionKey
			FROM
				GrReporting.dbo.ProfitabilityBudget
			WHERE
				CalendarKey BETWEEN @First2010CalendarKey AND @Last2010CalendarKey
			UNION ALL
			SELECT
				0 AS IsOriginalBudget,
				ReferenceCode,
				GlobalGlAccountCategoryKey,
				GlAccountKey,
				ActivityTypeKey,
				FunctionalDepartmentKey,
				OverheadKey,
				PropertyFundKey,
				AllocationRegionKey
			FROM
				GrReporting.dbo.ProfitabilityReforecast
			WHERE
				CalendarKey BETWEEN @First2010CalendarKey AND @Last2010CalendarKey

		) Transactions2010

		INNER JOIN GrReporting.dbo.GlAccount ON
			Transactions2010.GlAccountKey = GlAccount.GlAccountKey

		INNER JOIN GrReporting.dbo.GlAccountCategory ON
			Transactions2010.GlobalGlAccountCategoryKey = GlAccountCategory.GlAccountCategoryKey

		INNER JOIN GrReporting.dbo.Overhead ON
			Transactions2010.OverheadKey = Overhead.OverheadKey

		INNER JOIN GrReporting.dbo.ActivityType ON
			Transactions2010.ActivityTypeKey = ActivityType.ActivityTypeKey

		INNER JOIN GrReporting.dbo.FunctionalDepartment ON
			Transactions2010.FunctionalDepartmentKey = FunctionalDepartment.FunctionalDepartmentKey
			
		INNER JOIN GrReporting.dbo.PropertyFund ON
			Transactions2010.PropertyFundKey = PropertyFund.PropertyFundKey
			
		INNER JOIN GrReporting.dbo.AllocationRegion ON
			Transactions2010.AllocationRegionKey = AllocationRegion.AllocationRegionKey

		LEFT OUTER JOIN
		(
			SELECT
				FunctionalDepartmentId,
				GlobalCode
			FROM
				SERVER3.GDM.dbo.SnapshotFunctionalDepartment
			WHERE
				SnapshotId = @SnapshotId AND
				IsActive = 1

		) FunctionalDepartments ON
			FunctionalDepartment.FunctionalDepartmentCode = FunctionalDepartments.GlobalCode
			
		LEFT OUTER JOIN
		(
			SELECT DISTINCT
				EntityTypeId,
				Name
			FROM
				SERVER3.Gdm.dbo.SnapshotEntityType
			WHERE
				SnapshotId = @SnapshotId AND
				IsActive = 1

		) EntityTypes ON
			PropertyFund.PropertyFundType = EntityTypes.Name
			
		LEFT OUTER JOIN 
		(
			SELECT DISTINCT
				EntityTypeId,
				AllocationSubRegionGlobalRegionId,
				GLCategorizationId
			FROM
				SERVER3.Gdm.dbo.SnapshotReportingCategorization
			WHERE
				SnapshotId = @SnapshotId
		) ReportingCategorizations ON
			EntityTypes.EntityTypeId = ReportingCategorizations.EntityTypeId AND
			AllocationRegion.GlobalRegionId = ReportingCategorizations.AllocationSubRegionGlobalRegionId

		-- Find the Major and Minor Category Id of each transaction using the MajorMinorId field
		--		(x:y, where x is the Major Category Id and y the Minor CategoryId)

		UPDATE
			#2010Transactions
		SET
			MajorCategoryId = CONVERT(INT, SUBSTRING(MajorMinorId, 0, CHARINDEX(':', MajorMinorId))),
			MinorCategoryId = CONVERT(INT, SUBSTRING(MajorMinorId, CHARINDEX(':', MajorMinorId)+1, LEN(MajorMinorId)))

		ALTER TABLE
			#2010Transactions
		ALTER COLUMN MajorCategoryId INT NOT NULL

		ALTER TABLE
			#2010Transactions
		ALTER COLUMN MinorCategoryId INT NOT NULL

		PRINT ('2010 transactions inserted into #2010Transactions')

		-- Takes ~ 1:01 minutes on BISQLDEV to create index
		CREATE NONCLUSTERED INDEX IX_2010Transactions_Clustered ON #2010Transactions (MinorCategoryId, TransactionType) --INCLUDE (IsOriginalBudget, ReferenceCode, ActivityTypeId, FunctionalDepartmentId)

		PRINT ('Index IX_2010Transactions_Clustered created')

END



/* =============================================================================================================================================
	Create temporary tables

	Takes ~ 4 seconds ON BISQLDEV to create
   =========================================================================================================================================== */
BEGIN

	--DECLARE @SnapshotId INT = 11 -- The SnapshotId that is to be used when determining the Categorization hierarchy of the facts' global accounts

	--------------------------------------------------------
	-- #SnapshotGLCategorization
	--------------------------------------------------------

	SELECT DISTINCT
		GLCategorizationId,
		Name
	INTO
		#SnapshotGLCategorization
	FROM
		SERVER3.GDM.dbo.SnapshotGLCategorization
	WHERE
		IsActive = 1 AND
		-- GLCategorizationId <> 233 AND
		SnapshotId = @SnapshotId

	CREATE UNIQUE CLUSTERED INDEX IX_SnapshotGLCategorization_Clustered ON #SnapshotGLCategorization (GLCategorizationId)
	
	--------------------------------------------------------
	-- #SnapshotGLMinorCategoryPayrollType
	--------------------------------------------------------

	IF 	OBJECT_ID('tempdb..#SnapshotGLMinorCategoryPayrollType') IS NOT NULL
		DROP TABLE #SnapshotGLMinorCategoryPayrollType

	SELECT DISTINCT
		GLMinorCategoryId,
		PayrollTypeId
	INTO
		#SnapshotGLMinorCategoryPayrollType
	FROM
		SERVER3.GDM.dbo.SnapshotGLMinorCategoryPayrollType
	WHERE
		SnapshotId = @SnapshotId

	CREATE UNIQUE CLUSTERED INDEX IX_SnapshotGLMinorCategoryPayrollType_Clustered ON #SnapshotGLMinorCategoryPayrollType (GLMinorCategoryId, PayrollTypeId)

	--------------------------------------------------------
	-- #SnapshotPropertyPayrollPropertyGLAccount
	--------------------------------------------------------

	IF 	OBJECT_ID('tempdb..#SnapshotPropertyPayrollPropertyGLAccount') IS NOT NULL
		DROP TABLE #SnapshotPropertyPayrollPropertyGLAccount

	SELECT DISTINCT
		SnapshotPropertyPayrollPropertyGLAccount.PropertyPayrollPropertyGLAccountId,
		SnapshotPropertyPayrollPropertyGLAccount.GLCategorizationId,
		ISNULL(SnapshotPropertyPayrollPropertyGLAccount.ActivityTypeId, SnapshotActivityType.ActivityTypeId) AS ActivityTypeId,
		ISNULL(SnapshotPropertyPayrollPropertyGLAccount.FunctionalDepartmentId, SnapshotFunctionalDepartment.FunctionalDepartmentId) AS FunctionalDepartmentId,
		ISNULL(SnapshotPropertyPayrollPropertyGLAccount.GLMinorCategoryId, PayrollMinorCategory.GLMinorCategoryId) AS GLMinorCategoryId,
		SnapshotPropertyPayrollPropertyGLAccount.PayrollTypeId,
		SnapshotPropertyPayrollPropertyGLAccount.PropertyGLAccountId
	INTO
		#SnapshotPropertyPayrollPropertyGLAccount
	FROM
		(
			SELECT DISTINCT
				PropertyPayrollPropertyGLAccountId,
				GLCategorizationId,
				ActivityTypeId,						-- NULL implies ALL Activity Types
				FunctionalDepartmentId,				-- NULL implies ALL Functional Departments
				GLMinorCategoryId,					-- NULL implies ALL Minor Categories
				PayrollTypeId,
				PropertyGLAccountId
			FROM
				SERVER3.GDM.dbo.SnapshotPropertyPayrollPropertyGLAccount
			WHERE
				SnapshotId = @SnapshotId AND
				IsActive = 1

		) SnapshotPropertyPayrollPropertyGLAccount

		CROSS JOIN
			(
				SELECT DISTINCT
					ActivityTypeId
				FROM
					SERVER3.GDM.dbo.SnapshotActivityType
				WHERE
					SnapshotId = @SnapshotId

			) SnapshotActivityType

		CROSS JOIN
			(
				SELECT DISTINCT
					MinorCategoryId AS GLMinorCategoryId
				FROM
					#2010Transactions
				WHERE
					TransactionType = 'Payroll'

			) PayrollMinorCategory

		CROSS JOIN
			(
				SELECT DISTINCT
					FunctionalDepartmentId
				FROM
					SERVER3.GDM.dbo.SnapshotFunctionalDepartment
				WHERE
					IsActive = 1 AND
					SnapshotId = @SnapshotId

			) SnapshotFunctionalDepartment
	WHERE
		(
			SnapshotPropertyPayrollPropertyGLAccount.ActivityTypeId IS NULL OR
			SnapshotPropertyPayrollPropertyGLAccount.FunctionalDepartmentId IS NULL OR
			SnapshotPropertyPayrollPropertyGLAccount.GLMinorCategoryId IS NULL
		) OR
		(
			SnapshotPropertyPayrollPropertyGLAccount.ActivityTypeId IS NOT NULL AND
			SnapshotPropertyPayrollPropertyGLAccount.FunctionalDepartmentId IS NOT NULL AND
			SnapshotPropertyPayrollPropertyGLAccount.GLMinorCategoryId IS NOT NULL
		)

	CREATE CLUSTERED INDEX IX_SnapshotPropertyPayrollPropertyGLAccount_Clustered ON #SnapshotPropertyPayrollPropertyGLAccount (GLCategorizationId, ActivityTypeId, FunctionalDepartmentId, GLMinorCategoryId, PayrollTypeId, PropertyGLAccountId)

	--------------------------------------------------------
	-- #PropertyOverheadPropertyGLAccount
	--------------------------------------------------------

	IF 	OBJECT_ID('tempdb..#PropertyOverheadPropertyGLAccount') IS NOT NULL
		DROP TABLE #PropertyOverheadPropertyGLAccount

	SELECT DISTINCT
		SnapshotPropertyOverheadPropertyGLAccount.GLCategorizationId,
		ISNULL(SnapshotPropertyOverheadPropertyGLAccount.ActivityTypeId, SnapshotActivityType.ActivityTypeId) AS ActivityTypeId,
		ISNULL(SnapshotPropertyOverheadPropertyGLAccount.FunctionalDepartmentId, SnapshotFunctionalDepartment.FunctionalDepartmentId) AS FunctionalDepartmentId,
		SnapshotPropertyOverheadPropertyGLAccount.PropertyGLAccountId,
		SnapshotPropertyOverheadPropertyGLAccount.GLGlobalAccountId
	INTO
		#PropertyOverheadPropertyGLAccount
	FROM
		(
			SELECT
				GLCategorizationId,
				ActivityTypeId,
				FunctionalDepartmentId,
				GLGLobalAccountId,
				PropertyGLAccountId
			FROM
				SERVER3.GDM.dbo.SnapshotPropertyOverheadPropertyGLAccount
			WHERE
				SnapshotId = @SnapshotId AND
				IsActive = 1

		) SnapshotPropertyOverheadPropertyGLAccount

		CROSS JOIN
			(
				SELECT DISTINCT
					ActivityTypeId
				FROM
					SERVER3.GDM.dbo.SnapshotActivityType
				WHERE
					SnapshotId = @SnapshotId

			) SnapshotActivityType		

		CROSS JOIN
			(
				SELECT DISTINCT
					FunctionalDepartmentId
				FROM
					SERVER3.GDM.dbo.SnapshotFunctionalDepartment
				WHERE
					IsActive = 1 AND
					SnapshotId = @SnapshotId

			) SnapshotFunctionalDepartment
	WHERE
		(
			SnapshotPropertyOverheadPropertyGLAccount.ActivityTypeId IS NULL OR
			SnapshotPropertyOverheadPropertyGLAccount.FunctionalDepartmentId IS NULL
		) OR
		(
			SnapshotPropertyOverheadPropertyGLAccount.ActivityTypeId IS NOT NULL AND
			SnapshotPropertyOverheadPropertyGLAccount.FunctionalDepartmentId IS NOT NULL
		)

	CREATE CLUSTERED INDEX IX_PropertyOverheadPropertyGLAccount_Clustered ON #PropertyOverheadPropertyGLAccount (GLCategorizationId, ActivityTypeId, FunctionalDepartmentId)

	--------------------------------------------------------
	-- #SnapshotGLAccount
	--------------------------------------------------------

	IF 	OBJECT_ID('tempdb..#SnapshotGLAccount') IS NOT NULL
		DROP TABLE #SnapshotGLAccount

	SELECT DISTINCT
		GLAccountId,
		GLGlobalAccountId
	INTO
		#SnapshotGLAccount
	FROM
		SERVER3.GDM.dbo.SnapshotGLAccount
	WHERE
		SnapshotId = @SnapshotId AND
		IsActive = 1 AND
		GLGlobalAccountId IS NOT NULL

	CREATE UNIQUE CLUSTERED INDEX IX_SnapshotGLAccount_Clustered ON #SnapshotGLAccount (GLAccountId, GLGlobalAccountId)

	--------------------------------------------------------
	-- #SnapshotGLGlobalAccount
	--------------------------------------------------------

	IF 	OBJECT_ID('tempdb..#SnapshotGLGlobalAccount') IS NOT NULL
		DROP TABLE #SnapshotGLGlobalAccount

	SELECT DISTINCT
		GLGlobalAccountId,
		Code
	INTO
		#SnapshotGLGlobalAccount
	FROM
		SERVER3.GDM.dbo.SnapshotGLGlobalAccount
	WHERE
		SnapshotId = @SnapshotId AND
		IsActive = 1

	CREATE UNIQUE CLUSTERED INDEX IX_SnapshotGLGlobalAccount_Clustered ON #SnapshotGLGlobalAccount (GLGlobalAccountId, Code)
	
	--------------------------------------------------------
	-- #SnapshotGLGlobalAccountDetail
	--------------------------------------------------------

	IF 	OBJECT_ID('tempdb..#SnapshotGLGlobalAccountDetail') IS NOT NULL
		DROP TABLE #SnapshotGLGlobalAccountDetail

	SELECT DISTINCT
		GLCategorizationId,
		GLFinancialCategoryId,
		GLMajorCategoryId,
		GLMinorCategoryId,
		GLGlobalAccountId,
		IsDirect
	INTO
		#SnapshotGLGlobalAccountDetail
	FROM
		SERVER3.GDM.dbo.SnapshotGLGlobalAccountDetail
	WHERE
		SnapshotId = @SnapshotId AND
		GLCategorizationId IN (233, 244, 241, 242, 243)  -- Global (233) is not configured for recharge, so exclude it

	CREATE CLUSTERED INDEX IX_SnapshotGLGlobalAccountDetail_Clustered ON #SnapshotGLGlobalAccountDetail (GLCategorizationId, GLGlobalAccountId)

	------------------------------------------------------
	-- #SnapshotGLGlobalAccountCategorization
	------------------------------------------------------

	IF 	OBJECT_ID('tempdb..#SnapshotGLGlobalAccountCategorization') IS NOT NULL
		DROP TABLE #SnapshotGLGlobalAccountCategorization

	SELECT DISTINCT
		GLCategorizationId,
		GLGlobalAccountId,
		COAGLMinorCategoryId,
		DirectGLMinorCategoryId,
		IndirectGLMinorCategoryId,
		IsDirectApplicable,
		IsIndirectApplicable -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Is this necessary?
	INTO
		#SnapshotGLGlobalAccountCategorization
	FROM
		SERVER3.GDM.dbo.SnapshotGLGlobalAccountCategorization
	WHERE
		SnapshotId = @SnapshotId

	PRINT ('Mapping tables created')

	-----------------------------------------------------------------

	IF 	OBJECT_ID('tempdb..#2010TransactionsMapped') IS NOT NULL
		DROP TABLE #2010TransactionsMapped

	CREATE TABLE #2010TransactionsMapped -- Mapped transactions of every type get inserted into this table
	(
		IsOriginalBudget BIT NOT NULL,
		ReferenceCode VARCHAR(500) NULL,
		GlobalGLCategorizationHierarchyCode VARCHAR(50) NULL,
		USPropertyGLCategorizationHierarchyCode VARCHAR(50) NULL,
		EUPropertyGLCategorizationHierarchyCode VARCHAR(50) NULL,
		USFundGLCategorizationHierarchyCode VARCHAR(50) NULL,
		EUFundGLCategorizationHierarchyCode VARCHAR(50) NULL,
		DefaultGLCategorizationId INT NULL
	)

END

/* =============================================================================================================================================
	Migrate Payroll

		Categorization Name				IsConfiguredForRecharge
			Global							0
			US Property						1
			US Fund							1
			EU Property						1
			EU Fund							1

   =========================================================================================================================================== */
BEGIN
	-- Categorization IS set up for recharge (everything besides Global)
	--		takes ~ 2:24 minutes on BISQLDEV

	IF 	OBJECT_ID('tempdb..#PayrollFinal') IS NOT NULL
		DROP TABLE #PayrollFinal

	SELECT DISTINCT
		Payroll2010Transactions.IsOriginalBudget,
		Payroll2010Transactions.ReferenceCode,
		SnapshotGLCategorization.GLCategorizationId,
		'3:' + -- GLCategorizationTypeId for Local Operating Statement
		LTRIM(RTRIM(STR(SnapshotGLCategorization.GLCategorizationId))) + ':' +
		LTRIM(RTRIM(STR(CASE WHEN SnapshotGLGlobalAccountDetail.GLCategorizationId IS NULL THEN -1 ELSE SnapshotGLGlobalAccountDetail.GLFinancialCategoryId END))) + ':' +
		LTRIM(RTRIM(STR(CASE WHEN SnapshotGLGlobalAccountDetail.GLCategorizationId IS NULL THEN -1 ELSE SnapshotGLGlobalAccountDetail.GLMajorCategoryId END))) + ':' +
		LTRIM(RTRIM(STR(CASE WHEN SnapshotGLGlobalAccountDetail.GLCategorizationId IS NULL THEN -1 ELSE SnapshotGLGlobalAccountDetail.GLMinorCategoryId END))) + ':' +
		LTRIM(RTRIM(STR(ISNULL(SnapshotGLAccount.GLGlobalAccountId, -1)))) AS GLCategorizationHierarchyCode, -- !!!!!!!!!!!!!!!!!!!!!!!!
		Payroll2010Transactions.DefaultGLCategorizationId
	INTO
		#PayrollFinal
	FROM
		(
			SELECT DISTINCT
				IsOriginalBudget,
				ReferenceCode,
				ActivityTypeId,
				FunctionalDepartmentId,
				MinorCategoryId,
				DefaultGLCategorizationId
			FROM
				#2010Transactions
			WHERE
				TransactionType = 'Payroll'

		) Payroll2010Transactions
		
		LEFT OUTER JOIN #SnapshotGLCategorization SnapshotGLCategorization ON
			SnapshotGLCategorization.GLCategorizationId = SnapshotGLCategorization.GLCategorizationId

		LEFT OUTER JOIN #SnapshotGLMinorCategoryPayrollType SnapshotGLMinorCategoryPayrollType ON
			Payroll2010Transactions.MinorCategoryId = SnapshotGLMinorCategoryPayrollType.GLMinorCategoryId

		/*	If SnapshotPropertyPayrollPropertyGLAccount.GLMinorCategoryId / ActivityTypeId / FunctionalDepartmentId is NULL then the record
				applies to all Minor Categories / Activity Types / Functional Departments.
			ISNULL is used to ensure that, when this is the case, the join condition does not fail.	*/

		LEFT OUTER JOIN #SnapshotPropertyPayrollPropertyGLAccount SnapshotPropertyPayrollPropertyGLAccount ON
			Payroll2010Transactions.ActivityTypeId = ISNULL(SnapshotPropertyPayrollPropertyGLAccount.ActivityTypeId, Payroll2010Transactions.ActivityTypeId) AND
			Payroll2010Transactions.FunctionalDepartmentId = ISNULL(SnapshotPropertyPayrollPropertyGLAccount.FunctionalDepartmentId, Payroll2010Transactions.FunctionalDepartmentId) AND
			Payroll2010Transactions.MinorCategoryId = ISNULL(SnapshotPropertyPayrollPropertyGLAccount.GLMinorCategoryId, Payroll2010Transactions.MinorCategoryId) AND
			SnapshotGLMinorCategoryPayrollType.PayrollTypeId = SnapshotPropertyPayrollPropertyGLAccount.PayrollTypeId AND
			SnapshotGLCategorization.GLCategorizationId = SnapshotPropertyPayrollPropertyGLAccount.GLCategorizationId		

		LEFT OUTER JOIN #SnapshotGLAccount SnapshotGLAccount ON
			SnapshotPropertyPayrollPropertyGLAccount.PropertyGLAccountId = SnapshotGLAccount.GLAccountId

		LEFT OUTER JOIN #SnapshotGLGlobalAccountCategorization SnapshotGLGlobalAccountCategorization ON
			SnapshotGLAccount.GLGlobalAccountId = SnapshotGLGlobalAccountCategorization.GLGlobalAccountId AND
			SnapshotPropertyPayrollPropertyGLAccount.GLCategorizationId = SnapshotGLGlobalAccountCategorization.GLCategorizationId

		LEFT OUTER JOIN
			(	-- We need to exclude GLGlobalAccountId. Including it here will cause duplicate joins
				SELECT DISTINCT
					GLCategorizationId,
					GLFinancialCategoryId,
					GLMajorCategoryId,
					GLMinorCategoryId
				FROM
					#SnapshotGLGlobalAccountDetail
				WHERE
					IsDirect = 0 AND -- Payroll Transactions are INDIRECT
					GLCategorizationId <> 233 -- Global (233) is not configured for recharge, so exclude it

			) SnapshotGLGlobalAccountDetail ON
				SnapshotGLGlobalAccountCategorization.COAGLMinorCategoryId = SnapshotGLGlobalAccountDetail.GLMinorCategoryId AND
				SnapshotGLGlobalAccountCategorization.GLCategorizationId = SnapshotGLGlobalAccountDetail.GLCategorizationId
		WHERE
			SnapshotGLCategorization.GLCategorizationId <> 233

	PRINT ('Local categorizations for Payroll computed')

	-- Categorization IS NOT set up for recharge (Global only)
	--		takes ~ 1:06 minutes on BISQLDEV

	INSERT INTO #PayrollFinal
	SELECT
		Payroll2010Transactions.IsOriginalBudget,
		Payroll2010Transactions.ReferenceCode,
		233 AS GLCategorizationId,
		'1:' + -- GLCategorizationTypeId for Global
		LTRIM(RTRIM(STR(SnapshotGLGlobalAccountDetail.GLCategorizationId))) + ':' +
		LTRIM(RTRIM(STR(SnapshotGLGlobalAccountDetail.GLFinancialCategoryId))) + ':' +
		LTRIM(RTRIM(STR(SnapshotGLGlobalAccountDetail.GLMajorCategoryId))) + ':' +
		LTRIM(RTRIM(STR(SnapshotGLGlobalAccountDetail.GLMinorCategoryId))) + ':0' -- No GLGlobalAccountId for Payroll
		GLCategorizationHierarchyCode,
		DefaultGLCategorizationId
	FROM
		#2010Transactions Payroll2010Transactions

		LEFT OUTER JOIN
		(
			SELECT DISTINCT
				GLCategorizationId,
				GLFinancialCategoryId,
				GLMajorCategoryId,
				GLMinorCategoryId
			FROM
				#SnapshotGLGlobalAccountDetail
			WHERE
				IsDirect = 0 AND -- Payroll transactions are INDIRECT
				GLCategorizationId = 233
				
		) SnapshotGLGlobalAccountDetail ON
			SnapshotGLGlobalAccountDetail.GLMinorCategoryId = Payroll2010Transactions.MinorCategoryId
	WHERE
		Payroll2010Transactions.TransactionType = 'Payroll'

	PRINT ('Global categorization for Payroll computed')

	-- Takes ~8:33 to create :/
	CREATE CLUSTERED INDEX IX_PayrollFinal_Clustered ON #PayrollFinal (IsOriginalBudget, ReferenceCode, GLCategorizationId, GLCategorizationHierarchyCode)

	PRINT ('Index IX_PayrollFinal_Clustered created')

	---------------------------------------------------------
	-- PIVOT results [21,690,206 + 8,138,134 = 29,828,340] -> [8,138,134]
	--				21,690,206
	---------------------------------------------------------

	-- Takes ~1:05 minutes to insert

	INSERT INTO #2010TransactionsMapped
	SELECT
		Pivoted.IsOriginalBudget,
		Pivoted.ReferenceCode,
		Pivoted.[233] AS GlobalGLCategorizationHierarchyCode,
		Pivoted.[241] AS USPropertyGLCategorizationHierarchyCode,
		Pivoted.[242] AS USFundGLCategorizationHierarchyCode,
		Pivoted.[243] AS EUPropertyGLCategorizationHierarchyCode,
		Pivoted.[244] AS EUFundGLCategorizationHierarchyCode,
		Pivoted.DefaultGLCategorizationId
	FROM
		 #PayrollFinal 

		PIVOT
			(
				MAX(GLCategorizationHierarchyCode)
				FOR GLCategorizationId IN ([233], [241], [242], [243], [244])

			) AS Pivoted

	PRINT ('Payroll data pivoted')

END

/* =============================================================================================================================================
	Migrate Allocated Overhead

		Categorization Name				IsConfiguredForRecharge
			Global							0
			US Property						1
			US Fund							1
			EU Property						1
			EU Fund							1

   =========================================================================================================================================== */
BEGIN

	--SELECT COUNT(*) FROM #AllocatedOverheadFinal -- 3,483,742

	IF 	OBJECT_ID('tempdb..#AllocatedOverheadFinal') IS NOT NULL
		DROP TABLE #AllocatedOverheadFinal

	-- Categorization IS set up for recharge (everything besides Global)

	SELECT
		FeeIncome2010Transactions.IsOriginalBudget,
		FeeIncome2010Transactions.ReferenceCode,
		SnapshotGLCategorization.GLCategorizationId,
		'3:' + -- GLCategorizationTypeId for Local Operating Statement
		LTRIM(RTRIM(STR(SnapshotGLCategorization.GLCategorizationId))) + ':' +
		LTRIM(RTRIM(STR(CASE WHEN SnapshotGLGlobalAccountDetail.GLFinancialCategoryId IS NULL THEN -1 ELSE SnapshotGLGlobalAccountDetail.GLFinancialCategoryId END))) + ':' +
		LTRIM(RTRIM(STR(CASE WHEN SnapshotGLGlobalAccountDetail.GLFinancialCategoryId IS NULL THEN -1 ELSE SnapshotGLGlobalAccountDetail.GLMajorCategoryId END))) + ':' +
		LTRIM(RTRIM(STR(CASE WHEN SnapshotGLGlobalAccountDetail.GLFinancialCategoryId IS NULL THEN -1 ELSE SnapshotGLGlobalAccountDetail.GLMinorCategoryId END))) + ':' +
		LTRIM(RTRIM(STR(ISNULL(SnapshotGLAccount.GLGlobalAccountId, -1)))) AS GLCategorizationHierarchyCode, -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		FeeIncome2010Transactions.DefaultGLCategorizationId
	INTO
		#AllocatedOverheadFinal
	FROM
		(
			SELECT
				IsOriginalBudget,
				ReferenceCode,
				ActivityTypeId,
				FunctionalDepartmentId,
				DefaultGLCategorizationId
			FROM
				#2010Transactions
			WHERE
				TransactionType = 'Allocated Overhead'

		) FeeIncome2010Transactions

		LEFT OUTER JOIN #SnapshotGLCategorization SnapshotGLCategorization ON
			SnapshotGLCategorization.GLCategorizationId = SnapshotGLCategorization.GLCategorizationId -- Joining to itself is the same as a cross join
		
		LEFT OUTER JOIN #PropertyOverheadPropertyGLAccount PropertyOverheadPropertyGLAccount ON
			FeeIncome2010Transactions.ActivityTypeId = ISNULL(PropertyOverheadPropertyGLAccount.ActivityTypeId, FeeIncome2010Transactions.ActivityTypeId) AND
			FeeIncome2010Transactions.FunctionalDepartmentId = ISNULL(PropertyOverheadPropertyGLAccount.FunctionalDepartmentId, FeeIncome2010Transactions.FunctionalDepartmentId) AND
			SnapshotGLCategorization.GLCategorizationId = PropertyOverheadPropertyGLAccount.GLCategorizationId
		
		LEFT OUTER JOIN #SnapshotGLAccount SnapshotGLAccount ON
			PropertyOverheadPropertyGLAccount.PropertyGLAccountId = SnapshotGLAccount.GLAccountId

		LEFT OUTER JOIN #SnapshotGLGlobalAccountCategorization SnapshotGLGlobalAccountCategorization ON
			SnapshotGLAccount.GLGlobalAccountId = SnapshotGLGlobalAccountCategorization.GLGlobalAccountId AND
			PropertyOverheadPropertyGLAccount.GLCategorizationId = SnapshotGLGlobalAccountCategorization.GLCategorizationId

		LEFT OUTER JOIN
			(	-- We need to exclude GLGlobalAccountId. Including it here will cause duplicate joins
				SELECT DISTINCT
					GLCategorizationId,
					GLFinancialCategoryId,
					GLMajorCategoryId,
					GLMinorCategoryId,
					IsDirect
				FROM
					#SnapshotGLGlobalAccountDetail
				WHERE
					GLCategorizationId <> 233 AND -- Global (233) is not configured for recharge, so exclude it
					IsDirect = 0 -- Allocated Overhead Transactions are INDIRECT

			) SnapshotGLGlobalAccountDetail ON
				SnapshotGLGlobalAccountCategorization.COAGLMinorCategoryId = SnapshotGLGlobalAccountDetail.GLMinorCategoryId AND
				PropertyOverheadPropertyGLAccount.GLCategorizationId = SnapshotGLGlobalAccountDetail.GLCategorizationId
	WHERE
		SnapshotGLCategorization.GLCategorizationId <> 233 -- Local only


	PRINT ('Local categorizations for Allocated Overhead computed')

	-- Categorization IS NOT set up for recharge (Global only)

	INSERT INTO #AllocatedOverheadFinal
	SELECT DISTINCT
		FeeIncome2010Transactions.IsOriginalBudget,
		FeeIncome2010Transactions.ReferenceCode,
		233,
		'1:' + -- GLCategorizationTypeId for Local Operating Statement
		'233:' +
		LTRIM(RTRIM(STR(ISNULL(SnapshotGLGlobalAccountDetail.GLFinancialCategoryId, -1)))) + ':' +
		LTRIM(RTRIM(STR(ISNULL(SnapshotGLGlobalAccountDetail.GLMajorCategoryId, -1)))) + ':' +
		LTRIM(RTRIM(STR(ISNULL(SnapshotGLGlobalAccountDetail.GLMinorCategoryId, -1)))) + ':' +
		LTRIM(RTRIM(STR(ISNULL(SnapshotGLGlobalAccount.GLGlobalAccountId, -1)))) AS GLCategorizationHierarchyCode, -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		FeeIncome2010Transactions.DefaultGLCategorizationId
	FROM
		(
			SELECT
				IsOriginalBudget,
				ReferenceCode,
				ActivityTypeId,
				FunctionalDepartmentId,
				DefaultGLCategorizationId
			FROM
				#2010Transactions
			WHERE
				TransactionType = 'Allocated Overhead'

		) FeeIncome2010Transactions

		LEFT OUTER JOIN #SnapshotGLGlobalAccount SnapshotGLGlobalAccount ON
			SnapshotGLGlobalAccount.Code = '50029500'+RIGHT('0'+LTRIM(STR(FeeIncome2010Transactions.ActivityTypeId,3,0)),2)

		LEFT OUTER JOIN #SnapshotGLGlobalAccountCategorization SnapshotGLGlobalAccountCategorization ON
			SnapshotGLGlobalAccount.GLGlobalAccountId = SnapshotGLGlobalAccountCategorization.GLGlobalAccountId AND
			SnapshotGLGlobalAccountCategorization.GLCategorizationId = 233

		LEFT OUTER JOIN
			(	-- We need to exclude GLGlobalAccountId. Including it here will cause duplicate joins
				SELECT DISTINCT
					GLFinancialCategoryId,
					GLMajorCategoryId,
					GLMinorCategoryId
				FROM
					#SnapshotGLGlobalAccountDetail
				WHERE
					IsDirect = 0 AND
					GLCategorizationId = 233

			) SnapshotGLGlobalAccountDetail ON
				SnapshotGLGlobalAccountCategorization.DirectGLMinorCategoryId = SnapshotGLGlobalAccountDetail.GLMinorCategoryId

	PRINT ('Global categorization for Allocated Overhead computed')

	---------------------------------------------------------
	-- PIVOT results [2,588,416 + 895,326 = 3,483,742] - > [895,326]
	---------------------------------------------------------

	-- Takes ~0:07 minutes to insert

	INSERT INTO #2010TransactionsMapped
	SELECT
		Pivoted.IsOriginalBudget,
		Pivoted.ReferenceCode,
		Pivoted.[233] AS GlobalGLCategorizationHierarchyCode,
		Pivoted.[241] AS USPropertyGLCategorizationHierarchyCode,
		Pivoted.[242] AS USFundGLCategorizationHierarchyCode,
		Pivoted.[243] AS EUPropertyGLCategorizationHierarchyCode,
		Pivoted.[244] AS EUFundGLCategorizationHierarchyCode,
		Pivoted.DefaultGLCategorizationId
	FROM
		 #AllocatedOverheadFinal

		PIVOT
			(
				MAX(GLCategorizationHierarchyCode)
				FOR GLCategorizationId IN ([233], [241], [242], [243], [244])

			) AS Pivoted

	PRINT ('Allocated Overhead data pivoted')

END

/* =============================================================================================================================================
	Migrate Fee Income
   =========================================================================================================================================== */
BEGIN

	IF 	OBJECT_ID('tempdb..#FeeIncomeFinal') IS NOT NULL
		DROP TABLE #FeeIncomeFinal

	SELECT
		FeeIncome2010Transactions.IsOriginalBudget,
		FeeIncome2010Transactions.ReferenceCode,
		SnapshotGLCategorization.GLCategorizationId,
		CASE
			WHEN
				SnapshotGLGlobalAccountDetail.GLCategorizationId = 233
			THEN
				'1:' -- Global categorization has GLCategorizationTypeId = 1
			ELSE
				'3:' -- Local categorizations have GLCategorizationTypeId = 3
		END +
		LTRIM(RTRIM(STR(SnapshotGLCategorization.GLCategorizationId))) + ':' +
		LTRIM(RTRIM(STR(ISNULL(SnapshotGLGlobalAccountDetail.GLFinancialCategoryId, -1)))) + ':' +
		LTRIM(RTRIM(STR(ISNULL(SnapshotGLGlobalAccountDetail.GLMajorCategoryId, -1)))) + ':' +
		LTRIM(RTRIM(STR(ISNULL(SnapshotGLGlobalAccountDetail.GLMinorCategoryId, -1)))) + ':' +
		LTRIM(RTRIM(STR(ISNULL(SnapshotGLGlobalAccountDetail.GLGlobalAccountId, -1)))) AS GLCategorizationHierarchyCode,
		FeeIncome2010Transactions.DefaultGLCategorizationId
	INTO
		#FeeIncomeFinal	
	FROM
		#2010Transactions FeeIncome2010Transactions
		
		LEFT OUTER JOIN #SnapshotGLCategorization SnapshotGLCategorization ON
			SnapshotGLCategorization.GLCategorizationId = SnapshotGLCategorization.GLCategorizationId

		LEFT OUTER JOIN #SnapshotGLGlobalAccountDetail SnapshotGLGlobalAccountDetail ON
			FeeIncome2010Transactions.GLGlobalAccountId = SnapshotGLGlobalAccountDetail.GLGlobalAccountId AND
			SnapshotGLCategorization.GLCategorizationId = SnapshotGLGlobalAccountDetail.GLCategorizationId AND
			SnapshotGLGlobalAccountDetail.IsDirect =	CASE
															WHEN
																SnapshotGLCategorization.GLCategorizationId = 233
															THEN
																0	-- Global categorization for Fee Income is INDIRECT
															ELSE
																1	-- Local categorizations for Fee Income are DIRECT
														END
	WHERE
		FeeIncome2010Transactions.TransactionType = 'Fee Income'

	PRINT ('Global and Local categorizations for Fee Income data computed')

	----------------------------------------------
	-- PIVOT [14,617] -> [13,824]
	----------------------------------------------

	INSERT INTO #2010TransactionsMapped
	SELECT
		Pivoted.IsOriginalBudget,
		Pivoted.ReferenceCode,
		Pivoted.[233] AS GlobalGLCategorizationHierarchyCode,
		Pivoted.[241] AS USPropertyGLCategorizationHierarchyCode,
		Pivoted.[242] AS USFundGLCategorizationHierarchyCode,
		Pivoted.[243] AS EUPropertyGLCategorizationHierarchyCode,
		Pivoted.[244] AS EUFundGLCategorizationHierarchyCode,
		Pivoted.DefaultGLCategorizationId
	FROM
		 #FeeIncomeFinal 

		PIVOT
			(
				MAX(GLCategorizationHierarchyCode)
				FOR GLCategorizationId IN ([233], [241], [242], [243], [244])

			) AS Pivoted

	PRINT ('Fee Income data pivoted')

END

/* =============================================================================================================================================
	Migrate Non-Payroll
   =========================================================================================================================================== */
BEGIN

	IF 	OBJECT_ID('tempdb..#NonPayrollFinal') IS NOT NULL
		DROP TABLE #NonPayrollFinal
		
	SELECT
		NonPayroll2010Transactions.IsOriginalBudget,
		NonPayroll2010Transactions.ReferenceCode,
		SnapshotGLCategorization.GLCategorizationId,
		CASE
			WHEN
				SnapshotGLCategorization.GLCategorizationId = 233
			THEN
				'1:' -- Global categorization has GLCategorizationTypeId = 1
			ELSE
				'3:' -- Local categorizations have GLCategorizationTypeId = 3
		END +
		LTRIM(RTRIM(STR(SnapshotGLCategorization.GLCategorizationId))) + ':' +
		LTRIM(RTRIM(STR(ISNULL(SnapshotGLGlobalAccountDetail.GLFinancialCategoryId, -1)))) + ':' +
		LTRIM(RTRIM(STR(ISNULL(SnapshotGLGlobalAccountDetail.GLMajorCategoryId, -1)))) + ':' +
		LTRIM(RTRIM(STR(ISNULL(SnapshotGLGlobalAccountDetail.GLMinorCategoryId, -1)))) + ':' +
		LTRIM(RTRIM(STR(NonPayroll2010Transactions.GLGlobalAccountId))) AS GLCategorizationHierarchyCode,
		NonPayroll2010Transactions.DefaultGLCategorizationId
	INTO
		#NonPayrollFinal
	FROM
		#2010Transactions NonPayroll2010Transactions
		
		LEFT OUTER JOIN #SnapshotGLCategorization SnapshotGLCategorization ON
			SnapshotGLCategorization.GLCategorizationId = SnapshotGLCategorization.GLCategorizationId

		LEFT OUTER JOIN #SnapshotGLGlobalAccountCategorization SnapshotGLGlobalAccountCategorization ON
			NonPayroll2010Transactions.GLGlobalAccountId = SnapshotGLGlobalAccountCategorization.GLGlobalAccountId AND
			SnapshotGLCategorization.GLCategorizationId = SnapshotGLGlobalAccountCategorization.GLCategorizationId AND
			SnapshotGLGlobalAccountCategorization.IsIndirectApplicable = 1

		LEFT OUTER JOIN
		(
			SELECT DISTINCT
				GLCategorizationId,
				GLFinancialCategoryId,
				GLMajorCategoryId,
				GLMinorCategoryId
			FROM
				#SnapshotGLGlobalAccountDetail
			WHERE
				IsDirect = 0 -- Default Non-Payroll transactions to INDIRECT

		) SnapshotGLGlobalAccountDetail ON
			SnapshotGLGlobalAccountCategorization.GLCategorizationId = SnapshotGLGlobalAccountDetail.GLCategorizationId AND
			SnapshotGLGlobalAccountCategorization.IndirectGLMinorCategoryId = SnapshotGLGlobalAccountDetail.GLMinorCategoryId
	WHERE
		NonPayroll2010Transactions.TransactionType = 'Non-Payroll'
		

	--------------------------------------------
	-- PIVOT [12,596,471] -> [3,678,635]
	--------------------------------------------

	INSERT INTO #2010TransactionsMapped
	SELECT
		Pivoted.IsOriginalBudget,
		Pivoted.ReferenceCode,
		Pivoted.[233] AS GlobalGLCategorizationHierarchyCode,
		Pivoted.[241] AS USPropertyGLCategorizationHierarchyCode,
		Pivoted.[242] AS USFundGLCategorizationHierarchyCode,
		Pivoted.[243] AS EUPropertyGLCategorizationHierarchyCode,
		Pivoted.[244] AS EUFundGLCategorizationHierarchyCode,
		Pivoted.DefaultGLCategorizationId
	FROM
		 #NonPayrollFinal

		PIVOT
			(
				MAX(GLCategorizationHierarchyCode)
				FOR GLCategorizationId IN ([233], [241], [242], [243], [244])

			) AS Pivoted

	PRINT ('Non-Payroll data pivoted')

END

/* =============================================================================================================================================
	Combine all data into a single table
   =========================================================================================================================================== */
BEGIN

	-- Takes ~  minutes to create
	CREATE UNIQUE CLUSTERED INDEX IX_2010TransactionsMapped_Clustered ON #2010TransactionsMapped (IsOriginalBudget, ReferenceCode)

	PRINT ('Index IX_2010TransactionsMapped_Clustered created.')
	
	--SELECT -- SnapshotId = 11: 350 ALL unknowns
	--	*
	--FROM
	--	#2010TransactionsMapped
	--WHERE
	--	GlobalGLCategorizationHierarchyCode IS NULL AND
	--	USPropertyGLCategorizationHierarchyCode IS NULL AND
	--	USFundGLCategorizationHierarchyCode IS NULL AND
	--	EUPropertyGLCategorizationHierarchyCode IS NULL AND
	--	EUFundGLCategorizationHierarchyCode	IS NULL

	--SELECT
	--	All2010Transactions.*,
	--	'',
	--	All2010TransactionsMapped.*
	--FROM
	--	#2010Transactions All2010Transactions
	--	FULL JOIN #2010TransactionsMapped All2010TransactionsMapped ON
	--		All2010Transactions.IsOriginalBudget = All2010TransactionsMapped.IsOriginalBudget AND
	--		All2010Transactions.ReferenceCode = All2010TransactionsMapped.ReferenceCode
	--WHERE
	--	All2010Transactions.ReferenceCode IS NULL OR
	--	All2010TransactionsMapped.ReferenceCode IS NULL

END

/* =============================================================================================================================================
	Resolve to the GLCategorizationHierarchy dimension
   =========================================================================================================================================== */
BEGIN
PRINT 'NOT YET IMPLMENTED'
/*
	-- Update Profitability Budget Fact table

	DECLARE
		@UnknownUSPropertyGLCategorizationKey		INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'US Property' AND SnapshotId = 0),
		@UnknownUSFundGLCategorizationKey			INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'US Fund' AND SnapshotId = 0),
		@UnknownEUPropertyGLCategorizationKey		INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'EU Property' AND SnapshotId = 0),
		@UnknownEUFundGLCategorizationKey			INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'EU Fund' AND SnapshotId = 0),
		@UnknownUSDevelopmentGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'US Development' AND SnapshotId = 0),
		@UnknownGlobalGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'Global' AND SnapshotId = 0),
		@UnknownGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'UNKNOWN' AND SnapshotId = 0)

	UPDATE FACT 
	SET
		GlobalGLCategorizationHierarchyKey = ISNULL(GlobalDIM.GLCategorizationHierarchyKey, @UnknownGlobalGLCategorizationKey),
		USPropertyGLCategorizationHierarchyKey = ISNULL(USPropertyDIM.GLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey),
		USFundGLCategorizationHierarchyKey = ISNULL(USFundDIM.GLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey),
		EUPropertyGLCategorizationHierarchyKey = ISNULL(EUPropertyDIM.GLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey),
		EUFundGLCategorizationHierarchyKey = ISNULL(EUFundDIM.GLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey),
		USDevelopmentGLCategorizationHierarchyKey = @UnknownUSDevelopmentGLCategorizationKey,
		EUDevelopmentGLCategorizationHierarchyKey = @UnknownGLCategorizationKey,
		ReportingGLCategorizationHierarchyKey = 
			CASE 
				WHEN SRC.DefaultGLCategorizationId = -1 THEN @UnknownGLCategorizationKey
				WHEN GLCategorization.Name = 'Global' THEN ISNULL(GlobalDIM.GLCategorizationHierarchyKey, @UnknownGlobalGLCategorizationKey)
				WHEN GLCategorization.Name = 'US Property' THEN ISNULL(USPropertyDIM.GLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey)
				WHEN GLCategorization.Name = 'US Fund' THEN ISNULL(USFundDIM.GLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey)
				WHEN GLCategorization.Name = 'EU Property' THEN ISNULL(EUPropertyDIM.GLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey)
				WHEN GLCategorization.Name = 'EU Fund' THEN ISNULL(EUFundDIM.GLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey)
				ELSE @UnknownGLCategorizationKey
			END
	FROM 
		GrReporting.dbo.ProfitabilityBudget FACT
		
		INNER JOIN #2010TransactionsMapped SRC ON
			FACT.ReferenceCode = SRC.ReferenceCode AND
			SRC.IsOriginalBudget = 1
			
		LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy GlobalDIM ON
			SRC.GlobalGLCategorizationHierarchyCode = GlobalDIM.GLCategorizationHierarchyCode AND
			GlobalDIM.SnapshotId = @SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy USPropertyDIM ON
			SRC.USPropertyGLCategorizationHierarchyCode = USPropertyDIM.GLCategorizationHierarchyCode AND
			USPropertyDIM.SnapshotId = @SnapshotId
			
		LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy USFundDIM ON
			SRC.USFundGLCategorizationHierarchyCode = USFundDIM.GLCategorizationHierarchyCode AND
			USFundDIM.SnapshotId = @SnapshotId
			
		LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy EUPropertyDIM ON
			SRC.EUPropertyGLCategorizationHierarchyCode = EUPropertyDIM.GLCategorizationHierarchyCode AND
			EUPropertyDIM.SnapshotId = @SnapshotId
			
		LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy EUFundDIM ON
			SRC.EUFundGLCategorizationHierarchyCode = EUFundDIM.GLCategorizationHierarchyCode AND
			EUFundDIM.SnapshotId = @SnapshotId
			
		LEFT OUTER JOIN #SnapshotGLCategorization GLCategorization ON
			SRC.DefaultGLCategorizationId = GLCategorization.GLCategorizationId

	-- Update Profitability Reforecast Fact table

	UPDATE FACT 
	SET
		GlobalGLCategorizationHierarchyKey = ISNULL(GlobalDIM.GLCategorizationHierarchyKey, @UnknownGlobalGLCategorizationKey),
		USPropertyGLCategorizationHierarchyKey = ISNULL(USPropertyDIM.GLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey),
		USFundGLCategorizationHierarchyKey = ISNULL(USFundDIM.GLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey),
		EUPropertyGLCategorizationHierarchyKey = ISNULL(EUPropertyDIM.GLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey),
		EUFundGLCategorizationHierarchyKey = ISNULL(EUFundDIM.GLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey),
		USDevelopmentGLCategorizationHierarchyKey = @UnknownUSDevelopmentGLCategorizationKey,
		EUDevelopmentGLCategorizationHierarchyKey = @UnknownGLCategorizationKey,
		ReportingGLCategorizationHierarchyKey = 
			CASE 
				WHEN SRC.DefaultGLCategorizationId = -1 THEN @UnknownGLCategorizationKey
				WHEN GLCategorization.Name = 'Global' THEN ISNULL(GlobalDIM.GLCategorizationHierarchyKey, @UnknownGlobalGLCategorizationKey)
				WHEN GLCategorization.Name = 'US Property' THEN ISNULL(USPropertyDIM.GLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey)
				WHEN GLCategorization.Name = 'US Fund' THEN ISNULL(USFundDIM.GLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey)
				WHEN GLCategorization.Name = 'EU Property' THEN ISNULL(EUPropertyDIM.GLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey)
				WHEN GLCategorization.Name = 'EU Fund' THEN ISNULL(EUFundDIM.GLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey)
				ELSE @UnknownGLCategorizationKey
			END
	FROM 
		GrReporting.dbo.ProfitabilityReforecast FACT
		
		INNER JOIN #2010TransactionsMapped SRC ON
			FACT.ReferenceCode = SRC.ReferenceCode AND
			SRC.IsOriginalBudget = 0
			
		LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy GlobalDIM ON
			SRC.GlobalGLCategorizationHierarchyCode = GlobalDIM.GLCategorizationHierarchyCode AND
			GlobalDIM.SnapshotId = @SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy USPropertyDIM ON
			SRC.USPropertyGLCategorizationHierarchyCode = USPropertyDIM.GLCategorizationHierarchyCode AND
			USPropertyDIM.SnapshotId = @SnapshotId
			
		LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy USFundDIM ON
			SRC.USFundGLCategorizationHierarchyCode = USFundDIM.GLCategorizationHierarchyCode AND
			USFundDIM.SnapshotId = @SnapshotId
			
		LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy EUPropertyDIM ON
			SRC.EUPropertyGLCategorizationHierarchyCode = EUPropertyDIM.GLCategorizationHierarchyCode AND
			EUPropertyDIM.SnapshotId = @SnapshotId
			
		LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy EUFundDIM ON
			SRC.EUFundGLCategorizationHierarchyCode = EUFundDIM.GLCategorizationHierarchyCode AND
			EUFundDIM.SnapshotId = @SnapshotId
			
		LEFT OUTER JOIN #SnapshotGLCategorization GLCategorization ON
			SRC.DefaultGLCategorizationId = GLCategorization.GLCategorizationId
	*/
	
END


