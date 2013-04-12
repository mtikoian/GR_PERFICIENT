USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_S_UnknownSummaryMRIActualsLocal]    Script Date: 03/02/2012 10:04:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_S_UnknownSummaryMRIActualsLocal]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_S_UnknownSummaryMRIActualsLocal]
GO

USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_S_UnknownSummaryMRIActualsLocal]    Script Date: 03/02/2012 10:04:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[stp_S_UnknownSummaryMRIActualsLocal]
	@DataPriorToDate DateTime,
	@StartPeriod varchar(6),
	@EndPeriod varchar(6),
	@BudgetAllocationSetId int,
	@GBSAccounts bit = 0,
	@Sources varchar(max)
AS

/*********************************************************************************************************************
Description
	This validation report validates the profitability actuals for a specific period. The report is given to 
	Tishman Speyer, and they modify the data on their end to try and resolve the unknowns. There are two departments 
	that can handle this:

	2. Corporate Finance: They go into GDM and AM and modify mapping data to include the transaction setup.
	
	The report validates the following Corporate Finance (CDT Mapping) issues:
	
	2. Unknown GL Account
	3. Unknown Categorization Hierarchy 
		NOTE: This is due to two scenarios. First, GL Account unknown. Second, GL Account known, but rest of hierarchy
			  unknown, not mapped to global account in GDM.
	4. Unknown Property Fund
	
	Report Sections:
	
		STEP 1: GET ALL THE UNKNOWNS
		STEP 2.5: REMOVE ALL INFLOW Transactions
		STEP 8: Get Property Header GL Account Sum
		STEP 9: Get Corporate Header GL Account Sum
		STEP 10: GET FINAL RESULTS - GBS Only Version
		STEP 11: GET FINAL RESULTS - All Version													

History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
			2011-11-15		: SNothling	:	CC21 - Rewrite script to incorporate new hierarchy logic replacing 
											translation types etc. Please see CC21 Functional Specification for 
											further details.
**********************************************************************************************************************/

	/* ================================================================================================================
		STEP 0: GET THE SOURCE FILTER	
	=================================================================================================================*/

	CREATE TABLE #SourceFilter
	(
		SourceCode VARCHAR(2)
	)
	
	IF @Sources LIKE '%All%'
	BEGIN
		INSERT INTO #SourceFilter
		SELECT
			SourceCode
		FROM 
			Source
	END
	ELSE BEGIN
		INSERT INTO #SourceFilter
		SELECT
		*
		FROM 
			dbo.Split(@Sources) Sources
	END

	/* ================================================================================================================
		STEP 1: GET ALL THE UNKNOWNS
		
		-- Comments (SMN):
		-- 1. An unknown in either GLFinancialCategory, GLMajorCategory or GLMinorCategory will
		--    cause the categorization hierarchy to default to unknown, hence we only have to validate one 
		--    of these.
	=================================================================================================================*/

	BEGIN 
	
	CREATE TABLE #ValidationSummary
	(
		SourceCode CHAR(2) NOT NULL,
		ProfitabilityActualKey INT NOT NULL,
		ReferenceCode VARCHAR(100) NOT NULL,
		HasUnknownGLAccount BIT NULL,
		HasUnknownCategorizationHierarchy BIT NULL,
		HasUnknownGlobalCategorizationHierarchy BIT NULL
	)
	
	-- Get all MRI sourced actuals with unknowns
	INSERT INTO #ValidationSummary
	SELECT 
		[Source].SourceCode AS 'SourceCode',
		ProfitabilityActual.ProfitabilityActualKey AS 'ProfitabilityActualKey',
		ProfitabilityActual.ReferenceCode AS 'ReferenceCode',
		CASE
			WHEN ReportingHierarchy.GLAccountCode LIKE '%UNKNOWN%' THEN 1
			ELSE 0
		END AS 'HasUnknownGLAccount',
		CASE
			WHEN ReportingHierarchy.GLMinorCategoryName LIKE '%UNKNOWN%' THEN 1
			ELSE 0
		END AS 'HasUnknownCategorizationHierarchy',
		CASE
			WHEN GlobalGLHierarchy.GLMinorCategoryName LIKE '%UNKNOWN%' THEN 1
			ELSE 0
		END AS 'HasUnknownGlobalCategorizationHierarchy'
	FROM 
		dbo.ProfitabilityActual
		INNER JOIN dbo.Calendar ON
			ProfitabilityActual.CalendarKey = Calendar.CalendarKey
		INNER JOIN dbo.GLCategorizationHierarchy ReportingHierarchy ON
			ProfitabilityActual.ReportingGLCategorizationHierarchyKey = ReportingHierarchy.GLCategorizationHierarchyKey
		INNER JOIN dbo.GLCategorizationHierarchy GlobalGLHierarchy ON
			ProfitabilityActual.GlobalGLCategorizationHierarchyKey = GlobalGLHierarchy.GLCategorizationHierarchyKey
		INNER JOIN dbo.[Source] ON
			ProfitabilityActual.SourceKey = [Source].SourceKey
		INNER JOIN #SourceFilter ON
			Source.SourceCode = #SourceFilter.SourceCode
	WHERE
		Calendar.CalendarPeriod BETWEEN @StartPeriod AND @EndPeriod AND
		-- BillingUploadDetails indicate import from TAPAS, we want MRI only
		ProfitabilityActual.ReferenceCode NOT LIKE '%BillingUploadDetailId%' AND
		(
			ReportingHierarchy.GLAccountCode LIKE '%UNKNOWN%' OR
			ReportingHierarchy.GLMinorCategoryName LIKE '%UNKNOWN%'
		) AND
		GlobalGLHierarchy.GLAccountCode NOT LIKE '%UNKNOWN%' AND
		GlobalGLHierarchy.GLMinorCategoryName NOT LIKE '%UNKNOWN%'

		
	END
	
	/* ================================================================================================================
		STEP 2: Get all the original MRI actuals transactions from GrReportingStaging
		
		NOTE: We are going to use these to determine whether records have been reconciled with a re-class. Re-class items 
		still come up as unknowns, but they have duplicate records with identical but amount*-1.0 values so that they 
		balance out to 0.00
	=================================================================================================================*/
		
		BEGIN
	
	------------------------------------------------------------------------------------------------------		
	-- Create temp table
	------------------------------------------------------------------------------------------------------		

	CREATE TABLE #GeneralLedger
	(
		Period NVARCHAR(6),
		Item INT,
		Ref NVARCHAR(8),
		SiteId NVARCHAR(2),
		EntityId NVARCHAR(7),
		EntityName NVARCHAR(100),
		GlAccountCode NVARCHAR(14),
		GlAccountName NVARCHAR(70),
		DepartmentCode NVARCHAR(8),
		DepartmentDescription NVARCHAR(MAX),
		JobCode NVARCHAR(15),
		JobCodeDescription NVARCHAR(50),
		Amount MONEY,
		[Description] NVARCHAR(60),
		EnterDate DATETIME,
		Reversal NVARCHAR(1),
		Status NVARCHAR(1),
		Basis NVARCHAR(1),
		[UserId] NVARCHAR(20),
		CorporateDepartmentCode NVARCHAR(6),
		SourceCode NVARCHAR(2),
		SourcePrimaryKey NVARCHAR(62),
		[Source] NVARCHAR(2)
	)

	

	/* ================================================================================================================
		US
	=================================================================================================================*/
	
	-- US Prop
	IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = 'US'
	)
	BEGIN
		PRINT 'US'
		INSERT INTO #GeneralLedger
		SELECT
				GeneralLedger.Period,
				GeneralLedger.Item,
				GeneralLedger.Ref,
				GeneralLedger.SiteId,
				SourceEntity.EntityId,
				SourceEntity.Name AS 'EntityName',
				GeneralLedger.GlAccountCode,
				SourceGlobalAccount.AcctName AS 'GlAccountName',
				SourceDepartment.DepartmentCode,
				SourceDepartment.[Description] AS 'DepartmentDescription',
				SourceJobCode.JobCode,
				SourceJobCode.[Description] AS 'JobCodeDescription',
				GeneralLedger.Amount,
				GeneralLedger.[Description],
				GeneralLedger.EnterDate,
				GeneralLedger.Reversal,
				GeneralLedger.Status,
				GeneralLedger.Basis,
				GeneralLedger.[UserId],
				GeneralLedger.CorporateDepartmentCode,
				GeneralLedger.SourceCode,
				GeneralLedger.SourcePrimaryKey,
				GeneralLedger.[Source]
			FROM 
				GrReportingStaging.USProp.GeneralLedger GeneralLedger
				INNER JOIN (
					--This allows JOURNAL&GHIS to each have a record with the same PK,
					--but that is incorrect data and as such GR will pick GHIS as the 
					--more accurate data, for it is posted data, WHERE journal data is still open data
					SELECT 
						SourcePrimaryKey,
						MAX(SourceTableId) SourceTableId
					FROM
						GrReportingStaging.USProp.GeneralLedger Gl
					GROUP BY 
						SourcePrimaryKey
				) SourceGeneralLedger ON
					GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
					GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId
				
				--INNER JOIN #SourceFilter ON
				--	GeneralLedger.[Source] = #SourceFilter.SourceCode
					
				-- US Prop entity = propertyfund
				LEFT OUTER JOIN (
					SELECT
						Entity.*
					FROM 
						GrReportingStaging.USProp.Entity Entity
					INNER JOIN GrReportingStaging.USProp.EntityActive(@DataPriorToDate) ActiveEntity ON
						Entity.ImportKey = ActiveEntity.ImportKey
				) SourceEntity ON
					GeneralLedger.PropertyFundCode = SourceEntity.EntityId
				
				-- US Prop Department = Region + Functional Department OR Investors	
				LEFT OUTER JOIN (
					SELECT
						Department.*
					FROM 
						GrReportingStaging.gdm.Department Department 
					INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
						Department.ImportKey = ActiveDepartment.ImportKey 			
				) SourceDepartment ON
					GeneralLedger.SourceCode = SourceDepartment.[Source] AND
					GeneralLedger.RegionCode + GeneralLedger.FunctionalDepartmentCode = SourceDepartment.DepartmentCode
				
				-- US Prop GLAccount = Expense Type + Activity
				LEFT OUTER JOIN (
					SELECT
						GlobalAccount.*
					FROM
						GrReportingStaging.USProp.GACC GlobalAccount
					INNER JOIN GrReportingStaging.USProp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
						GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
				) SourceGlobalAccount ON
					GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
				
				-- US Prop Job Code = Tenant & Capital Improvements (Property Only)
				LEFT OUTER JOIN (
					SELECT
						JobCode.*
					FROM 
						GrReportingStaging.GACS.JobCode JobCode 
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
						JobCode.ImportKey = ActiveJobCode.ImportKey			
				) SourceJobCode ON
					GeneralLedger.SourceCode = SourceJobCode.[Source] AND 
					GeneralLedger.JobCode = SourceJobCode.JobCode
				
			WHERE
				GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod AND
				-- We do not import records with a corporate department code, because the transaction will
				-- come up as a corp transaction anyway, otherwise we count it twice
				(
					CorporateDepartmentCode IS NULL OR
					CorporateDepartmentCode = 'N'
				)
	END
					
	-- US Corp
	IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = 'UC'
	)
	BEGIN
		PRINT 'UC'
		INSERT INTO #GeneralLedger
			SELECT
				GeneralLedger.Period,
				GeneralLedger.Item,
				GeneralLedger.Ref,
				GeneralLedger.SiteId,
				SourceEntity.EntityId,
				SourceEntity.Name AS 'EntityName',
				GeneralLedger.GlAccountCode,
				SourceGlobalAccount.AcctName AS 'GlAccountName',
				SourceDepartment.DepartmentCode,
				SourceDepartment.[Description] AS 'DepartmentDescription',
				SourceJobCode.JobCode,
				SourceJobCode.[Description] AS 'JobCodeDescription',
				GeneralLedger.Amount,
				GeneralLedger.[Description],
				GeneralLedger.EnterDate,
				GeneralLedger.Reversal,
				GeneralLedger.Status,
				GeneralLedger.Basis,
				GeneralLedger.[UserId],
				GeneralLedger.CorporateDepartmentCode,
				GeneralLedger.SourceCode,
				GeneralLedger.SourcePrimaryKey,
				GeneralLedger.[Source]
			FROM 
				GrReportingStaging.USCorp.GeneralLedger GeneralLedger
				INNER JOIN (
					--This allows JOURNAL&GHIS to each have a record with the same PK,
					--but that is incorrect data and as such GR will pick GHIS as the 
					--more accurate data, for it is posted data, WHERE journal data is still open data
					SELECT 
						SourcePrimaryKey,
						MAX(SourceTableId) SourceTableId
					FROM
						GrReportingStaging.USCorp.GeneralLedger Gl
					GROUP BY 
						SourcePrimaryKey
				) SourceGeneralLedger ON
					GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
					GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId
				
				-- US Corp Entity = Region Code 
				LEFT OUTER JOIN (
					SELECT
						Entity.*
					FROM 
						GrReportingStaging.USCorp.Entity Entity
					INNER JOIN GrReportingStaging.USCorp.EntityActive(@DataPriorToDate) ActiveEntity ON
						Entity.ImportKey = ActiveEntity.ImportKey
				) SourceEntity ON
					GeneralLedger.RegionCode = SourceEntity.EntityId
					
				-- US Corp Department = PropertyFund
				LEFT OUTER JOIN (
					SELECT
						Department.*
					FROM 
						GrReportingStaging.gdm.Department Department 
					INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
						Department.ImportKey = ActiveDepartment.ImportKey 			
				) SourceDepartment ON
					GeneralLedger.SourceCode = SourceDepartment.[Source] AND
					GeneralLedger.PropertyFundCode = SourceDepartment.DepartmentCode
				
				-- US Prop GLAccount = Expense Type + Activity
				LEFT OUTER JOIN (
					SELECT
						GlobalAccount.*
					FROM
						GrReportingStaging.USCorp.GACC GlobalAccount
					INNER JOIN GrReportingStaging.USCorp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
						GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
				) SourceGlobalAccount ON
					GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
				
				-- US Corp Job Code = Functional Department OR IT Costs
				LEFT OUTER JOIN (
					SELECT
						JobCode.*
					FROM 
						GrReportingStaging.GACS.JobCode JobCode 
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
						JobCode.ImportKey = ActiveJobCode.ImportKey			
				) SourceJobCode ON
					GeneralLedger.SourceCode = SourceJobCode.[Source] AND 
					GeneralLedger.JobCode = SourceJobCode.JobCode
					
			WHERE
				GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod			
	END
				
	/* ================================================================================================================
		EU
	=================================================================================================================*/
	
	-- EU Prop
		IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = 'EU'
	)
	BEGIN
		PRINT 'EU'
		INSERT INTO #GeneralLedger
		SELECT
			GeneralLedger.Period,
			GeneralLedger.Item,
			GeneralLedger.Ref,
			GeneralLedger.SiteId,
			SourceEntity.EntityId,
			SourceEntity.Name AS 'EntityName',
			GeneralLedger.GlAccountCode,
			SourceGlobalAccount.AcctName AS 'GlAccountName',
			SourceDepartment.DepartmentCode,
			SourceDepartment.[Description] AS 'DepartmentDescription',
			SourceJobCode.JobCode,
			SourceJobCode.[Description] AS 'JobCodeDescription',
			GeneralLedger.Amount,
			GeneralLedger.[Description],
			GeneralLedger.EnterDate,
			GeneralLedger.Reversal,
			GeneralLedger.Status,
			GeneralLedger.Basis,
			GeneralLedger.[UserId],
			GeneralLedger.CorporateDepartmentCode,
			GeneralLedger.SourceCode,
			GeneralLedger.SourcePrimaryKey,
			GeneralLedger.[Source]
		FROM 
			GrReportingStaging.EUProp.GeneralLedger GeneralLedger
			INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, WHERE journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.EUProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
			) SourceGeneralLedger ON
				GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
				GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId
				
			-- EU Prop Entity = propertyFund
			LEFT OUTER JOIN (
				SELECT
					Entity.*
				FROM 
					GrReportingStaging.EUProp.Entity Entity
				INNER JOIN GrReportingStaging.EUProp.EntityActive(@DataPriorToDate) ActiveEntity ON
					Entity.ImportKey = ActiveEntity.ImportKey
			) SourceEntity ON
				GeneralLedger.PropertyFundCode = SourceEntity.EntityId
				
			LEFT OUTER JOIN (
				SELECT
					Department.*
				FROM 
					GrReportingStaging.gdm.Department Department 
				INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
					Department.ImportKey = ActiveDepartment.ImportKey 			
			) SourceDepartment ON
				GeneralLedger.SourceCode = SourceDepartment.[Source] AND
				GeneralLedger.RegionCode + GeneralLedger.FunctionalDepartmentCode = SourceDepartment.DepartmentCode
			
			LEFT OUTER JOIN (
				SELECT
					GlobalAccount.*
				FROM
					GrReportingStaging.EUProp.GACC GlobalAccount
				INNER JOIN GrReportingStaging.EUProp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
					GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
			) SourceGlobalAccount ON
				GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
			
			LEFT OUTER JOIN (
				SELECT
					JobCode.*
				FROM 
					GrReportingStaging.GACS.JobCode JobCode 
				INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
					JobCode.ImportKey = ActiveJobCode.ImportKey			
			) SourceJobCode ON
				GeneralLedger.SourceCode = SourceJobCode.[Source] AND 
				GeneralLedger.JobCode = SourceJobCode.JobCode
				
		WHERE
			GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod AND	
			-- We do not import records with a corporate department code, because the transaction will
			-- come up as a corp transaction anyway, otherwise we count it twice
			(
				CorporateDepartmentCode IS NULL OR
				CorporateDepartmentCode = 'N'
			)
	END	 
	
	-- EU Corp
	IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = 'EC'
	)
	BEGIN
		PRINT 'EC'
		INSERT INTO #GeneralLedger
		SELECT
			GeneralLedger.Period,
			GeneralLedger.Item,
			GeneralLedger.Ref,
			GeneralLedger.SiteId,
			SourceEntity.EntityId,
			SourceEntity.Name AS 'EntityName',
			GeneralLedger.GlAccountCode,
			SourceGlobalAccount.AcctName AS 'GlAccountName',
			SourceDepartment.DepartmentCode,
			SourceDepartment.[Description] AS 'DepartmentDescription',
			SourceJobCode.JobCode,
			SourceJobCode.[Description] AS 'JobCodeDescription',
			GeneralLedger.Amount,
			GeneralLedger.[Description],
			GeneralLedger.EnterDate,
			GeneralLedger.Reversal,
			GeneralLedger.Status,
			GeneralLedger.Basis,
			GeneralLedger.[UserId],
			GeneralLedger.CorporateDepartmentCode,
			GeneralLedger.SourceCode,
			GeneralLedger.SourcePrimaryKey,
			GeneralLedger.[Source]
		FROM 
			GrReportingStaging.EUCorp.GeneralLedger GeneralLedger
			INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, WHERE journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.EUCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
			) SourceGeneralLedger ON
				GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
				GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId
			
			-- EU Corp Entity = Region Code 	
			LEFT OUTER JOIN (
				SELECT
					Entity.*
				FROM 
					GrReportingStaging.EUCorp.Entity Entity
				INNER JOIN GrReportingStaging.EUCorp.EntityActive(@DataPriorToDate) ActiveEntity ON
					Entity.ImportKey = ActiveEntity.ImportKey
			) SourceEntity ON
				GeneralLedger.RegionCode = SourceEntity.EntityId
				
			LEFT OUTER JOIN (
				SELECT
					Department.*
				FROM 
					GrReportingStaging.gdm.Department Department 
				INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
					Department.ImportKey = ActiveDepartment.ImportKey 			
			) SourceDepartment ON
				GeneralLedger.SourceCode = SourceDepartment.[Source] AND
				GeneralLedger.PropertyFundCode = SourceDepartment.DepartmentCode
			
			LEFT OUTER JOIN (
				SELECT
					GlobalAccount.*
				FROM
					GrReportingStaging.EUCorp.GACC GlobalAccount
				INNER JOIN GrReportingStaging.EUCorp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
					GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
			) SourceGlobalAccount ON
				GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
			
			LEFT OUTER JOIN (
				SELECT
					JobCode.*
				FROM 
					GrReportingStaging.GACS.JobCode JobCode 
				INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
					JobCode.ImportKey = ActiveJobCode.ImportKey			
			) SourceJobCode ON
				GeneralLedger.SourceCode = SourceJobCode.[Source] AND GeneralLedger.JobCode = SourceJobCode.JobCode
				
		WHERE
			GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod
	END	
		
	/* ================================================================================================================
		BR
	=================================================================================================================*/
	
	-- BR Prop
	IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = 'BR'
	)
	BEGIN
		INSERT INTO #GeneralLedger
		SELECT
			GeneralLedger.Period,
			GeneralLedger.Item,
			GeneralLedger.Ref,
			GeneralLedger.SiteId,
			SourceEntity.EntityId,
			SourceEntity.Name AS 'EntityName',
			GeneralLedger.GlAccountCode,
			SourceGlobalAccount.AcctName AS 'GlAccountName',
			SourceDepartment.DepartmentCode,
			SourceDepartment.[Description] AS 'DepartmentDescription',
			SourceJobCode.JobCode,
			SourceJobCode.[Description] AS 'JobCodeDescription',
			GeneralLedger.Amount,
			GeneralLedger.[Description],
			GeneralLedger.EnterDate,
			GeneralLedger.Reversal,
			GeneralLedger.Status,
			GeneralLedger.Basis,
			GeneralLedger.[UserId],
			GeneralLedger.CorporateDepartmentCode,
			GeneralLedger.SourceCode,
			GeneralLedger.SourcePrimaryKey,
			GeneralLedger.[Source]
		FROM 
			GrReportingStaging.BRProp.GeneralLedger GeneralLedger
			INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, WHERE journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.BRProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
			) SourceGeneralLedger ON
				GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
				GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId
				
			LEFT OUTER JOIN (
				SELECT
					Entity.*
				FROM 
					GrReportingStaging.BRProp.Entity Entity
				INNER JOIN GrReportingStaging.BRProp.EntityActive(@DataPriorToDate) ActiveEntity ON
					Entity.ImportKey = ActiveEntity.ImportKey
			) SourceEntity ON
				GeneralLedger.PropertyFundCode = SourceEntity.EntityId
				
			LEFT OUTER JOIN (
				SELECT
					Department.*
				FROM 
					GrReportingStaging.gdm.Department Department 
				INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
					Department.ImportKey = ActiveDepartment.ImportKey 			
			) SourceDepartment ON
				GeneralLedger.SourceCode = SourceDepartment.[Source] AND
				GeneralLedger.RegionCode + GeneralLedger.FunctionalDepartmentCode = SourceDepartment.DepartmentCode
			
			LEFT OUTER JOIN (
				SELECT
					GlobalAccount.*
				FROM
					GrReportingStaging.BRProp.GACC GlobalAccount
				INNER JOIN GrReportingStaging.BRProp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
					GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
			) SourceGlobalAccount ON
				GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
			
			LEFT OUTER JOIN (
				SELECT
					JobCode.*
				FROM 
					GrReportingStaging.GACS.JobCode JobCode 
				INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
					JobCode.ImportKey = ActiveJobCode.ImportKey			
			) SourceJobCode ON
				GeneralLedger.SourceCode = SourceJobCode.[Source] AND GeneralLedger.JobCode = SourceJobCode.JobCode
			
		WHERE
			GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod AND	
			-- We do not import records with a corporate department code, because the transaction will
			-- come up as a corp transaction anyway, otherwise we count it twice
			(
				CorporateDepartmentCode IS NULL OR
				CorporateDepartmentCode = 'N'
			)	
	END
				
	-- BR Corp
	IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = 'BC'
	)
	BEGIN
		INSERT INTO #GeneralLedger
		SELECT
			GeneralLedger.Period,
			GeneralLedger.Item,
			GeneralLedger.Ref,
			GeneralLedger.SiteId,
			SourceEntity.EntityId,
			SourceEntity.Name AS 'EntityName',
			GeneralLedger.GlAccountCode,
			SourceGlobalAccount.AcctName AS 'GlAccountName',
			SourceDepartment.DepartmentCode,
			SourceDepartment.[Description] AS 'DepartmentDescription',
			SourceJobCode.JobCode,
			SourceJobCode.[Description] AS 'JobCodeDescription',
			GeneralLedger.Amount,
			GeneralLedger.[Description],
			GeneralLedger.EnterDate,
			GeneralLedger.Reversal,
			GeneralLedger.Status,
			GeneralLedger.Basis,
			GeneralLedger.[UserId],
			GeneralLedger.CorporateDepartmentCode,
			GeneralLedger.SourceCode,
			GeneralLedger.SourcePrimaryKey,
			GeneralLedger.[Source]
		FROM 
			GrReportingStaging.BRCorp.GeneralLedger GeneralLedger
			INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, WHERE journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.BRCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
			) SourceGeneralLedger ON
				GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
				GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId

			-- BR Corp Entity = Region Code 
			LEFT OUTER JOIN (
				SELECT
					Entity.*
				FROM 
					GrReportingStaging.BRCorp.Entity Entity
				INNER JOIN GrReportingStaging.BRCorp.EntityActive(@DataPriorToDate) ActiveEntity ON
					Entity.ImportKey = ActiveEntity.ImportKey
			) SourceEntity ON
				GeneralLedger.RegionCode = SourceEntity.EntityId
				
			LEFT OUTER JOIN (
				SELECT
					Department.*
				FROM 
					GrReportingStaging.gdm.Department Department 
				INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
					Department.ImportKey = ActiveDepartment.ImportKey 			
			) SourceDepartment ON
				GeneralLedger.SourceCode = SourceDepartment.[Source] AND
				GeneralLedger.PropertyFundCode = SourceDepartment.DepartmentCode
			
			LEFT OUTER JOIN (
				SELECT
					GlobalAccount.*
				FROM
					GrReportingStaging.BRCorp.GACC GlobalAccount
				INNER JOIN GrReportingStaging.BRCorp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
					GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
			) SourceGlobalAccount ON
				GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
			
			LEFT OUTER JOIN (
				SELECT
					JobCode.*
				FROM 
					GrReportingStaging.GACS.JobCode JobCode 
				INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
					JobCode.ImportKey = ActiveJobCode.ImportKey			
			) SourceJobCode ON
				GeneralLedger.SourceCode = SourceJobCode.[Source] AND GeneralLedger.JobCode = SourceJobCode.JobCode
			
		WHERE
			GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod		
	END
			
	/* ================================================================================================================
		IN
	=================================================================================================================*/

	-- IN Prop
	IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = 'IN'
	)
	BEGIN
		INSERT INTO #GeneralLedger
		SELECT
			GeneralLedger.Period,
			GeneralLedger.Item,
			GeneralLedger.Ref,
			GeneralLedger.SiteId,
			SourceEntity.EntityId,
			SourceEntity.Name AS 'EntityName',
			GeneralLedger.GlAccountCode,
			SourceGlobalAccount.AcctName AS 'GlAccountName',
			SourceDepartment.DepartmentCode,
			SourceDepartment.[Description] AS 'DepartmentDescription',
			SourceJobCode.JobCode,
			SourceJobCode.[Description] AS 'JobCodeDescription',
			GeneralLedger.Amount,
			GeneralLedger.[Description],
			GeneralLedger.EnterDate,
			GeneralLedger.Reversal,
			GeneralLedger.Status,
			GeneralLedger.Basis,
			GeneralLedger.[UserId],
			GeneralLedger.CorporateDepartmentCode,
			GeneralLedger.SourceCode,
			GeneralLedger.SourcePrimaryKey,
			GeneralLedger.[Source]
		FROM 
			GrReportingStaging.INProp.GeneralLedger GeneralLedger
			INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, WHERE journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.INProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
			) SourceGeneralLedger ON
				GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
				GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId
				
			LEFT OUTER JOIN (
				SELECT
					Entity.*
				FROM 
					GrReportingStaging.INProp.Entity Entity
				INNER JOIN GrReportingStaging.INProp.EntityActive(@DataPriorToDate) ActiveEntity ON
					Entity.ImportKey = ActiveEntity.ImportKey
			) SourceEntity ON
				GeneralLedger.PropertyFundCode = SourceEntity.EntityId
				
			LEFT OUTER JOIN (
				SELECT
					Department.*
				FROM 
					GrReportingStaging.gdm.Department Department 
				INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
					Department.ImportKey = ActiveDepartment.ImportKey 			
			) SourceDepartment ON
				GeneralLedger.SourceCode = SourceDepartment.[Source] AND
				GeneralLedger.RegionCode + GeneralLedger.FunctionalDepartmentCode = SourceDepartment.DepartmentCode
			
			LEFT OUTER JOIN (
				SELECT
					GlobalAccount.*
				FROM
					GrReportingStaging.INProp.GACC GlobalAccount
				INNER JOIN GrReportingStaging.INProp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
					GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
			) SourceGlobalAccount ON
				GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
			
			LEFT OUTER JOIN (
				SELECT
					JobCode.*
				FROM 
					GrReportingStaging.GACS.JobCode JobCode 
				INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
					JobCode.ImportKey = ActiveJobCode.ImportKey			
			) SourceJobCode ON
				GeneralLedger.SourceCode = SourceJobCode.[Source] AND GeneralLedger.JobCode = SourceJobCode.JobCode
			
		WHERE
			GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod AND	
			-- We do not import records with a corporate department code, because the transaction will
			-- come up as a corp transaction anyway, otherwise we count it twice
			(
				CorporateDepartmentCode IS NULL OR
				CorporateDepartmentCode = 'N'
			)
	END
	
	-- IN Corp
	IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = 'IC'
	)
	BEGIN
		INSERT INTO #GeneralLedger
		SELECT
			GeneralLedger.Period,
			GeneralLedger.Item,
			GeneralLedger.Ref,
			GeneralLedger.SiteId,
			SourceEntity.EntityId,
			SourceEntity.Name AS 'EntityName',
			GeneralLedger.GlAccountCode,
			SourceGlobalAccount.AcctName AS 'GlAccountName',
			SourceDepartment.DepartmentCode,
			SourceDepartment.[Description] AS 'DepartmentDescription',
			SourceJobCode.JobCode,
			SourceJobCode.[Description] AS 'JobCodeDescription',
			GeneralLedger.Amount,
			GeneralLedger.[Description],
			GeneralLedger.EnterDate,
			GeneralLedger.Reversal,
			GeneralLedger.Status,
			GeneralLedger.Basis,
			GeneralLedger.[UserId],
			GeneralLedger.CorporateDepartmentCode,
			GeneralLedger.SourceCode,
			GeneralLedger.SourcePrimaryKey,
			GeneralLedger.[Source]
		FROM 
			GrReportingStaging.INCorp.GeneralLedger GeneralLedger
			INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, WHERE journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.INCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
			) SourceGeneralLedger ON
				GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
				GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId
				
			-- IN Corp Entity = Region Code 
			LEFT OUTER JOIN (
				SELECT
					Entity.*
				FROM 
					GrReportingStaging.INCorp.Entity Entity
				INNER JOIN GrReportingStaging.INCorp.EntityActive(@DataPriorToDate) ActiveEntity ON
					Entity.ImportKey = ActiveEntity.ImportKey
			) SourceEntity ON
				GeneralLedger.RegionCode = SourceEntity.EntityId
				
			LEFT OUTER JOIN (
				SELECT
					Department.*
				FROM 
					GrReportingStaging.gdm.Department Department 
				INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
					Department.ImportKey = ActiveDepartment.ImportKey 			
			) SourceDepartment ON
				GeneralLedger.SourceCode = SourceDepartment.[Source] AND
				GeneralLedger.PropertyFundCode = SourceDepartment.DepartmentCode
			
			LEFT OUTER JOIN (
				SELECT
					GlobalAccount.*
				FROM
					GrReportingStaging.INCorp.GACC GlobalAccount
				INNER JOIN GrReportingStaging.INCorp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
					GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
			) SourceGlobalAccount ON
				GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
			
			LEFT OUTER JOIN (
				SELECT
					JobCode.*
				FROM 
					GrReportingStaging.GACS.JobCode JobCode 
				INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
					JobCode.ImportKey = ActiveJobCode.ImportKey			
			) SourceJobCode ON
				GeneralLedger.SourceCode = SourceJobCode.[Source] AND GeneralLedger.JobCode = SourceJobCode.JobCode
			
		WHERE
			GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod	
	END
	/* ================================================================================================================
		CN
	=================================================================================================================*/
	
	-- CN Prop
	IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = 'CN'
	)
	BEGIN
		INSERT INTO #GeneralLedger
		SELECT
			GeneralLedger.Period,
			GeneralLedger.Item,
			GeneralLedger.Ref,
			GeneralLedger.SiteId,
			SourceEntity.EntityId,
			SourceEntity.Name AS 'EntityName',
			GeneralLedger.GlAccountCode,
			SourceGlobalAccount.AcctName AS 'GlAccountName',
			SourceDepartment.DepartmentCode,
			SourceDepartment.[Description] AS 'DepartmentDescription',
			SourceJobCode.JobCode,
			SourceJobCode.[Description] AS 'JobCodeDescription',
			GeneralLedger.Amount,
			GeneralLedger.[Description],
			GeneralLedger.EnterDate,
			GeneralLedger.Reversal,
			GeneralLedger.Status,
			GeneralLedger.Basis,
			GeneralLedger.[UserId],
			GeneralLedger.CorporateDepartmentCode,
			GeneralLedger.SourceCode,
			GeneralLedger.SourcePrimaryKey,
			GeneralLedger.[Source]
		FROM 
			GrReportingStaging.CNProp.GeneralLedger GeneralLedger
			INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, WHERE journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.CNProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
			) SourceGeneralLedger ON
				GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
				GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId
				
			LEFT OUTER JOIN (
				SELECT
					Entity.*
				FROM 
					GrReportingStaging.CNProp.Entity Entity
				INNER JOIN GrReportingStaging.CNProp.EntityActive(@DataPriorToDate) ActiveEntity ON
					Entity.ImportKey = ActiveEntity.ImportKey
			) SourceEntity ON
				GeneralLedger.PropertyFundCode = SourceEntity.EntityId
				
			LEFT OUTER JOIN (
				SELECT
					Department.*
				FROM 
					GrReportingStaging.gdm.Department Department 
				INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
					Department.ImportKey = ActiveDepartment.ImportKey 			
			) SourceDepartment ON
				GeneralLedger.SourceCode = SourceDepartment.[Source] AND
				GeneralLedger.RegionCode + GeneralLedger.FunctionalDepartmentCode = SourceDepartment.DepartmentCode
			
			LEFT OUTER JOIN (
				SELECT
					GlobalAccount.*
				FROM
					GrReportingStaging.CNProp.GACC GlobalAccount
				INNER JOIN GrReportingStaging.CNProp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
					GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
			) SourceGlobalAccount ON
				GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
			
			LEFT OUTER JOIN (
				SELECT
					JobCode.*
				FROM 
					GrReportingStaging.GACS.JobCode JobCode 
				INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
					JobCode.ImportKey = ActiveJobCode.ImportKey			
			) SourceJobCode ON
				GeneralLedger.SourceCode = SourceJobCode.[Source] AND GeneralLedger.JobCode = SourceJobCode.JobCode
				
		WHERE
			GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod AND	
			-- We do not import records with a corporate department code, because the transaction will
			-- come up as a corp transaction anyway, otherwise we count it twice
			(
				CorporateDepartmentCode IS NULL OR
				CorporateDepartmentCode = 'N'
			)
	END
				
	-- CN Corp
	IF EXISTS (
		SELECT
			SourceCode
		FROM 
			#SourceFilter
		WHERE 
			SourceCode = 'CC'
	)
	BEGIN
		INSERT INTO #GeneralLedger
		SELECT
			GeneralLedger.Period,
			GeneralLedger.Item,
			GeneralLedger.Ref,
			GeneralLedger.SiteId,
			SourceEntity.EntityId,
			SourceEntity.Name AS 'EntityName',
			GeneralLedger.GlAccountCode,
			SourceGlobalAccount.AcctName AS 'GlAccountName',
			SourceDepartment.DepartmentCode,
			SourceDepartment.[Description] AS 'DepartmentDescription',
			SourceJobCode.JobCode,
			SourceJobCode.[Description] AS 'JobCodeDescription',
			GeneralLedger.Amount,
			GeneralLedger.[Description],
			GeneralLedger.EnterDate,
			GeneralLedger.Reversal,
			GeneralLedger.Status,
			GeneralLedger.Basis,
			GeneralLedger.[UserId],
			GeneralLedger.CorporateDepartmentCode,
			GeneralLedger.SourceCode,
			GeneralLedger.SourcePrimaryKey,
			GeneralLedger.[Source]
		FROM 
			GrReportingStaging.CNCorp.GeneralLedger GeneralLedger
			INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, WHERE journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.CNCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
			) SourceGeneralLedger ON
				GeneralLedger.SourcePrimaryKey = SourceGeneralLedger.SourcePrimaryKey AND
				GeneralLedger.SourceTableId = SourceGeneralLedger.SourceTableId
				
			-- CN Corp Entity = Region Code 
			LEFT OUTER JOIN (
				SELECT
					Entity.*
				FROM 
					GrReportingStaging.CNCorp.Entity Entity
				INNER JOIN GrReportingStaging.CNCorp.EntityActive(@DataPriorToDate) ActiveEntity ON
					Entity.ImportKey = ActiveEntity.ImportKey
			) SourceEntity ON
				GeneralLedger.RegionCode = SourceEntity.EntityId
				
			LEFT OUTER JOIN (
				SELECT
					Department.*
				FROM 
					GrReportingStaging.gdm.Department Department 
				INNER JOIN GrReportingStaging.gdm.DepartmentActive(@DataPriorToDate) ActiveDepartment ON
					Department.ImportKey = ActiveDepartment.ImportKey 			
			) SourceDepartment ON
				GeneralLedger.SourceCode = SourceDepartment.[Source] AND
				GeneralLedger.PropertyFundCode = SourceDepartment.DepartmentCode
			
			LEFT OUTER JOIN (
				SELECT
					GlobalAccount.*
				FROM
					GrReportingStaging.CNCorp.GACC GlobalAccount
				INNER JOIN GrReportingStaging.CNCorp.GAccActive(@DataPriorToDate) ActiveGlobalAccount ON
					GlobalAccount.ImportKey = ActiveGlobalAccount.ImportKey
			) SourceGlobalAccount ON
				GeneralLedger.GLAccountCode = SourceGlobalAccount.ACCTNUM
			
			LEFT OUTER JOIN (
				SELECT
					JobCode.*
				FROM 
					GrReportingStaging.GACS.JobCode JobCode 
				INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) ActiveJobCode ON
					JobCode.ImportKey = ActiveJobCode.ImportKey			
			) SourceJobCode ON
				GeneralLedger.SourceCode = SourceJobCode.[Source] AND GeneralLedger.JobCode = SourceJobCode.JobCode
				
		WHERE
			GeneralLedger.Period BETWEEN @StartPeriod AND @EndPeriod
	END
		
	END
	
	/* ================================================================================================================
		STEP 2.5: REMOVE ALL INFLOW Transactions
		
		Global 'Inflow' accounts 
	=================================================================================================================*/
	
	BEGIN
	
		DELETE ValidationSummary 
		FROM 
			#ValidationSummary ValidationSummary
		INNER JOIN ProfitabilityActual ON
			ValidationSummary.ProfitabilityActualKey = ProfitabilityActual.ProfitabilityActualKey
		INNER JOIN GLCategorizationHierarchy ON 
			ProfitabilityActual.GlobalGLCategorizationHierarchyKey = GLCategorizationHierarchy.GLCategorizationHierarchyKey
		INNER JOIN #GeneralLedger GeneralLedger ON 
			ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
			ValidationSummary.SourceCode = GeneralLedger.SourceCode
		WHERE 
			GLCategorizationHierarchy.InflowOutflow = 'Inflow' OR 
			GLCategorizationHierarchy.GLFinancialCategoryName = 'Other Expenses'
	END
			
	/* ================================================================================================================
		STEP 3: VALIDATE RECLASSED UNKNOWNS DATA
		
		This validates fixes of type 2 - see comment at top of script. We need to remove unknown transactions that have
		been fixed by a reclass. GL Account balances are calculated by GL Account and Entity in MRI, so a re-class will 
		make the GL Account Balance even out for that GL Account - Entity combination.
		
		ALGORITHM USED:
		
		Scenario: Assume the following transactions are flagged with unknown activity types
		
		GL Account Code		Entity											Amount
		EU5002300002		REGION DE                                       630.00                                
		EU5002300002		TISHMAN SPEYER REV VI ALTERNATIVE (IRE), L.P.   450.00                          
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.     640.00                                
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.     780.00                                
		EU6702290012		REGION DE										12.00                                 
		EU6702290012		REGION DE                                       12.00                                		
		
		They go and fix some of the transactions with re-classes, so now we see the following. 
		We want to exclude all the transactions with *** from the new validation report, because
		they have been fixed with a re-class. Please note that the re-classed transaction will not appear
		here, because it does not have an unknown activity type any more.	
		
		GL Account Code		Entity											Amount
		EU5002300002		REGION DE                                       630.00*****   
	    EU5002300002        REGION DE										-630.00****
		EU5002300002		TISHMAN SPEYER REV VI ALTERNATIVE (IRE), L.P.   450.00                          
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.     640.00****
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.     -640.00****                               
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.     780.00                                
		EU6702290012		REGION DE										12.00****  
	    EU6702290012		REGION DE										-12.00****                          
		EU6702290012		REGION DE                                       12.00 
		
		Step 1: Get a distinct list of gl accout code, entity, absolute value (hereafter indicated as |amount|
		Please note what happens to the EU6702290012 transactions here.
		
		GL Account Code		Entity											Amount
		EU5002300002		REGION DE                                       |630.00| 
		EU5002300002		TISHMAN SPEYER REV VI ALTERNATIVE (IRE), L.P.   |450.00|                         
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.     |640.00|                    
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.     |780.00|                              
		EU6702290012		REGION DE										|12.00|

		Step 2: join all transactions back onto this distinct list, and group by gl account code, entity and |amount|
		
		GL Account Code		Entity											Sum(Amount)		|Amount|
		EU5002300002		REGION DE										0.00			|630.00| 
		EU5002300002		TISHMAN SPEYER REV VI ALTERNATIVE (IRE), L.P.	450.00			|450.00|                         
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.		0.00			|640.00|                    
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.		780.00			|780.00|                              
		EU6702290012		REGION DE										12.00			|12.00|
		
		Step 3: return all transactions where the sum(amount) in step 2 did not balance out to 0.00. Please note that ALL
		the transactions for EU6702290012 is returned here, because we cannot distinguish which transaction is still invalid,
		and which was fixed by the re-class transaction. This algorithm is not fool proof, but it is as accurate as we can get.
		
		GL Account Code		Entity											Amount
		EU5002300002		TISHMAN SPEYER REV VI ALTERNATIVE (IRE), L.P.   450.00                          
		TS1023500000		TISHMAN SPEYER REAL ESTATE VENTURE VI, L.P.     780.00                                
		EU6702290012		REGION DE										12.00****  
	    EU6702290012		REGION DE										-12.00****                          
		EU6702290012		REGION DE                                       12.00 
		
		We do this for each unknown type.

	=================================================================================================================*/
		
	/* ================================================================================================================
		GL Account Unknowns
	=================================================================================================================*/

	BEGIN
	
	---------------------------------------------------------------------------------------
	-- Remove GLAccount Unknowns from #ValidationSummary that have been re-classed 
	-- and now net out to 0
	---------------------------------------------------------------------------------------
	
	UPDATE ValidationSummary 
	SET
		HasUnknownGlAccount = 0
	FROM 
	-- Step 3: Validation Summary Record where the account balance for that glaccount, entity and |amount| balances out to 0.0
		#ValidationSummary ValidationSummary
		INNER JOIN #GeneralLedger GeneralLedger ON
			ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
			ValidationSummary.SourceCode = GeneralLedger.SourceCode
		INNER JOIN (
			-- Step 2: Get a list of unknown transaction GL Account, Entity and Amount with an account balance of 0.00 for 
			-- that |amount|
			SELECT
				IndividualAmounts.GlAccountCode,
				IndividualAmounts.EntityId,
				IndividualAmounts.Amount
			FROM 
				#ValidationSummary ValidationSummary
			INNER JOIN #GeneralLedger GeneralLedger ON
				ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
				ValidationSummary.SourceCode = GeneralLedger.SourceCode
			INNER JOIN (
				-- Step 1: Get a distinct list of glaccountcode, entityid, |Amount|
				SELECT 
					GeneralLedger.GLAccountCode,
					GeneralLedger.EntityId, 
					CASE
						WHEN GeneralLedger.Amount < 0.0 THEN GeneralLedger.Amount * -1.0
						ELSE GeneralLedger.Amount
					END AS 'Amount'
				FROM #ValidationSummary ValidationSummary
				INNER JOIN #GeneralLedger GeneralLedger ON
					ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
					ValidationSummary.SourceCode = GeneralLedger.SourceCode
				WHERE
					ValidationSummary.HasUnknownGlAccount = 1
				GROUP BY
					GeneralLedger.GlAccountCode,
					GeneralLedger.EntityId,
					CASE
						WHEN GeneralLedger.Amount < 0.0 THEN GeneralLedger.Amount * -1.0
						ELSE GeneralLedger.Amount
					END
			) IndividualAmounts ON
				GeneralLedger.GLAccountCode = IndividualAmounts.GLAccountCode AND
				GeneralLedger.EntityId = IndividualAmounts.EntityId AND
				(CASE 
					WHEN GeneralLedger.Amount < 0.0 THEN -1.0 * GeneralLedger.Amount 
					ELSE GeneralLedger.Amount 
				END) = IndividualAmounts.Amount 
			WHERE 
				ValidationSummary.HasUnknownGlAccount = 1
			GROUP BY 
				IndividualAmounts.GlAccountCode,
				IndividualAmounts.EntityId,
				IndividualAmounts.Amount
			HAVING			
				SUM(GeneralLedger.Amount) = 0.0	
		) NonReclassedTransactions ON
			GeneralLedger.GlAccountCode = NonReclassedTransactions.GLAccountCode AND
			GeneralLedger.EntityId = NonReclassedTransactions.EntityId AND
			CASE 
				WHEN GeneralLedger.Amount < 0.0 THEN -1.0 * GeneralLedger.Amount
				ELSE GeneralLedger.Amount
			END = NonReclassedTransactions.Amount
		
	END	
		
	/* ================================================================================================================
		Global Categorization Unknowns
	=================================================================================================================*/
			
	BEGIN
	
	---------------------------------------------------------------------------------------
	-- Remove Global Categorization Hierarchy Unknowns from #ValidationSummary that have been re-classed 
	-- and now net out to 0
	---------------------------------------------------------------------------------------
	
	UPDATE ValidationSummary 
	SET
		HasUnknownCategorizationHierarchy = 0
	FROM 
	-- Step 3: Validation Summary Record where the account balance for that glaccount, entity and |amount| balances out to 0.0
		#ValidationSummary ValidationSummary
		INNER JOIN #GeneralLedger GeneralLedger ON
			ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
			ValidationSummary.SourceCode = GeneralLedger.SourceCode
		INNER JOIN (
			-- Step 2: Get a list of unknown transaction GL Account, Entity and Amount with an account balance of 0.00 for 
			-- that |amount|
			SELECT
				IndividualAmounts.GlAccountCode,
				IndividualAmounts.EntityId,
				IndividualAmounts.Amount
			FROM 
				#ValidationSummary ValidationSummary
			INNER JOIN #GeneralLedger GeneralLedger ON
				ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
				ValidationSummary.SourceCode = GeneralLedger.SourceCode
			INNER JOIN (
				-- Step 1: Get a distinct list of glaccountcode, entityid, |Amount|
				SELECT 
					GeneralLedger.GLAccountCode,
					GeneralLedger.EntityId, 
					CASE
						WHEN GeneralLedger.Amount < 0.0 THEN GeneralLedger.Amount * -1.0
						ELSE GeneralLedger.Amount
					END AS 'Amount'
				FROM #ValidationSummary ValidationSummary
				INNER JOIN #GeneralLedger GeneralLedger ON
					ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
					ValidationSummary.SourceCode = GeneralLedger.SourceCode
				WHERE
					ValidationSummary.HasUnknownCategorizationHierarchy = 1
				GROUP BY
					GeneralLedger.GlAccountCode,
					GeneralLedger.EntityId,
					CASE
						WHEN GeneralLedger.Amount < 0.0 THEN GeneralLedger.Amount * -1.0
						ELSE GeneralLedger.Amount
					END
			) IndividualAmounts ON
				GeneralLedger.GLAccountCode = IndividualAmounts.GLAccountCode AND
				GeneralLedger.EntityId = IndividualAmounts.EntityId AND
				(CASE 
					WHEN GeneralLedger.Amount < 0.0 THEN -1.0 * GeneralLedger.Amount 
					ELSE GeneralLedger.Amount 
				END) = IndividualAmounts.Amount 
			WHERE 
				ValidationSummary.HasUnknownCategorizationHierarchy = 1
			GROUP BY 
				IndividualAmounts.GlAccountCode,
				IndividualAmounts.EntityId,
				IndividualAmounts.Amount
			HAVING			
				SUM(GeneralLedger.Amount) = 0.0	
		) NonReclassedTransactions ON
			GeneralLedger.GlAccountCode = NonReclassedTransactions.GLAccountCode AND
			GeneralLedger.EntityId = NonReclassedTransactions.EntityId AND
			CASE 
				WHEN GeneralLedger.Amount < 0.0 THEN -1.0 * GeneralLedger.Amount
				ELSE GeneralLedger.Amount
			END = NonReclassedTransactions.Amount	
		
	END
		
	/* ================================================================================================================
		STEP 7: Clean Up Data														
	=================================================================================================================*/
	
	BEGIN
	
	DELETE 
		FROM 
			#ValidationSummary
	WHERE
		#ValidationSummary.HasUnknownGLAccount = 0 AND
		#ValidationSummary.HasUnknownCategorizationHierarchy = 0
	
	END	
	
 
	
	/* ================================================================================================================
		STEP 11: GET FINAL RESULTS
		Handle ALL Logic													
	=================================================================================================================*/
	BEGIN
		
	SELECT
		'Corporate Finance - Mapping' AS 'ResolvedBy',
		ValidationSummary.SourceCode,
		-- MRI
		GeneralLedger.Period,
		GeneralLedger.Ref,
		GeneralLedger.Item,
		ISNULL(GeneralLedger.EntityID, '') AS 'EntityID',
		ISNULL(GeneralLedger.EntityName, '') AS 'EntityName',
		ISNULL(GeneralLedger.GLAccountCode, '') AS 'GLAccountCode',
		ISNULL(GeneralLedger.GlAccountName, '') AS 'GlAccountName',
		ISNULL(GeneralLedger.DepartmentCode, '') AS 'Department',
		ISNULL(GeneralLedger.DepartmentDescription, '') AS 'DepartmentDescription',
		ISNULL(GeneralLedger.JobCode, '') AS 'JobCode',
		ISNULL(GeneralLedger.JobCodeDescription, '') AS 'JobCodeDescription',
		ISNULL(GeneralLedger.Amount, '') AS 'Amount',
		ISNULL(GeneralLedger.Description, '') AS 'Description',
		ISNULL(GeneralLedger.EnterDate, '') AS 'EnterDate',
		ISNULL(GeneralLedger.Reversal, '') AS 'Reversal',
		ISNULL(GeneralLedger.Status, '') AS 'Status',
		ISNULL(GeneralLedger.Basis, '') AS 'Basis',
		ISNULL(GeneralLedger.UserId, '') AS 'UserId',
		ISNULL(GeneralLedger.CorporateDepartmentCode, '') AS 'CorporateDepartmentCode',
		ISNULL(GeneralLedger.[Source], '') AS 'Source',
		GlobalHierarchy.GLAccountCode AS 'GlobalGLAccountCode',
		GlobalHierarchy.GLAccountName AS 'GlobalGLAccountName',
		ReportingHierarchy.GLCategorizationName AS 'LocalCategorization',
		ReportingHierarchy.GLFinancialCategoryName AS 'LocalFinancialCategoryName',
		ReportingHierarchy.GLMajorCategoryName AS 'LocalMajorCategoryName',
		ReportingHierarchy.GLMinorCategoryName AS 'LocalMinorCategoryName',
		ReportingHierarchy.InflowOutflow AS 'InflowOutFlow',
		PropertyFund.PropertyFundName AS 'GrReportingEntityName',
		ActivityType.ActivityTypeName AS 'GrActivityTypeName',
		OriginatingRegion.SubRegionName AS 'GrOriginatingSubRegionName',
		AllocationRegion.SubRegionName AS 'GrAllocationSubRegionName',
		FunctionalDepartment.FunctionalDepartmentName AS 'GrFunctionalDepartmentName'
	FROM 
		#ValidationSummary ValidationSummary
		INNER JOIN dbo.ProfitabilityActual ON 
			ValidationSummary.ProfitabilityActualKey = ProfitabilityActual.ProfitabilityActualKey
		INNER JOIN dbo.GLCategorizationHierarchy GlobalHierarchy ON
			ProfitabilityActual.GlobalGLCategorizationHierarchyKey = GlobalHierarchy.GLCategorizationHierarchyKey
		INNER JOIN dbo.GLCategorizationHierarchy ReportingHierarchy ON 
			ProfitabilityActual.ReportingGLCategorizationHierarchyKey = ReportingHierarchy.GLCategorizationHierarchyKey
		INNER JOIN dbo.PropertyFund ON 
			ProfitabilityActual.PropertyFundKey = PropertyFund.PropertyFundKey
		INNER JOIN dbo.ActivityType ON 
			ProfitabilityActual.ActivityTypeKey = ActivityType.ActivityTypeKey
		INNER JOIN dbo.OriginatingRegion ON 
			ProfitabilityActual.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey
		INNER JOIN dbo.AllocationRegion ON 
			 ProfitabilityActual.AllocationRegionKey = AllocationRegion.AllocationRegionKey
		INNER JOIN dbo.Overhead ON 
			ProfitabilityActual.OverheadKey = Overhead.OverheadKey
		INNER JOIN dbo.FunctionalDepartment ON 
			ProfitabilityActual.FunctionalDepartmentKey	= FunctionalDepartment.FunctionalDepartmentKey
		INNER JOIN #GeneralLedger GeneralLedger ON 
			ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND 
			ValidationSummary.SourceCode = GeneralLedger.SourceCode
	WHERE
		(
			ValidationSummary.HasUnknownGLAccount = 1 OR
			ValidationSummary.HasUnknownCategorizationHierarchy = 1 
		) AND
		ValidationSummary.HasUnknownGlobalCategorizationHierarchy = 0
	END
	
	--------------------------------------------------------------------------
	/*	Clean up temp tables												*/
	--------------------------------------------------------------------------

	BEGIN
	
	IF OBJECT_ID('tempdb..#ValidationSummary') IS NOT NULL
		DROP TABLE #ValidationSummary
		
	IF OBJECT_ID('tempdb..#GeneralLedger') IS NOT NULL
		DROP TABLE #GeneralLedger
		
	IF OBJECT_ID('tempdb..#IsGBSGlobalAccounts') IS NOT NULL
		DROP TABLE #IsGBSGlobalAccounts

	END

















GO


