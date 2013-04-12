USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_S_UnknownSummaryMRIActualsGlobal]    Script Date: 02/28/2012 10:46:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_S_UnknownSummaryMRIActualsGlobal]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_S_UnknownSummaryMRIActualsGlobal]
GO

USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_S_UnknownSummaryMRIActualsGlobal]    Script Date: 02/28/2012 10:46:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [dbo].[stp_S_UnknownSummaryMRIActualsGlobal]
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
	
	1. Accounting: They go into MRI and modify the transaction data to be valid.	
		 NOTE: Tishman Speyer Accounting can handle unknowns in two ways in MRI:
		 1. Modify existing journal record and update foreign key references to valid entries
		 2. Cancel out invalid transaction by rolling back, and recapture transaction as new record. 
		    This will cause the incorrect transaction to appear twice, one with + and one with -, in 
		    effect 'zeroing out'.

	2. Corporate Finance: They go into GDM and AM and modify mapping data to include the transaction setup.
	
	The report validates the following Accounting (Re-class) issues:
	
	1. Unknown Activity Type
	2. Unknown Functional Department
	3. Unknown Originating Region
	4. Invalid Originating Region - Functional Department Mapping
	5. Invalid Activity Type - Entity Mapping
	6. Invalid Functional Department - Global Account Mapping (new since CC21 - Restricted tables in GDM)
	7. Invalid Functional Department - Functional Department - Corporate Entity Mapping (new since CC21 - Restricted tables in GDM)
	
	The report validates the following Corporate Finance (CDT Mapping) issues:
	
	1. Unknown Allocation Region
	2. Unknown GL Account
	3. Unknown Categorization Hierarchy 
		NOTE: This is due to two scenarios. First, GL Account unknown. Second, GL Account known, but rest of hierarchy
			  unknown, not mapped to global account in GDM.
	4. Unknown Property Fund
	
	Report Sections:
	
		STEP 1: GET ALL THE UNKNOWNS
		STEP 2: Get all the original MRI actuals transactions from GrReportingStaging
		STEP 3: VALIDATE RECLASSED UNKNOWNS DATA
		STEP 4: VALIDATE ENTITY - ACTIVITYTYPE COMBINATION
		STEP 5: Validate OriginatingRegion & FunctionalDepartment Combination		
		STEP 6: Validate FunctionalDepartment & GL Global Account Combination	
		STEP 6.5: Remove Global Inflow and Other Expenses	
		STEP 7: Clean Up Data - Remove items that have been resolved
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
			dbo.Source
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
		HasUnknownActivityType BIT NULL,
		HasUnknownAllocationRegion BIT NULL,
		HasUnknownGLAccount BIT NULL,
		HasUnknownCategorizationHierarchy BIT NULL,
		HasUnknownFunctionalDepartment BIT NULL,
		HasUnknownOriginatingRegion BIT NULL,
		HasUnknownPropertyFund BIT NULL,
		InValidOriginatingRegionAndFunctionalDepartment BIT NULL DEFAULT(0),
		InvalidGLAccountAndFunctionalDepartment BIT NULL DEFAULT(0),
		InValidActivityTypeAndEntity  BIT NULL DEFAULT(0)
	)
	
	-- Get all MRI sourced actuals with unknowns
	INSERT INTO #ValidationSummary
	SELECT 
		[Source].SourceCode AS 'SourceCode',
		ProfitabilityActual.ProfitabilityActualKey AS 'ProfitabilityActualKey',
		ProfitabilityActual.ReferenceCode AS 'ReferenceCode',
		CASE
			WHEN ProfitabilityActual.ActivityTypeKey = -1 THEN 1
			ELSE 0
		END AS 'HasUnknownActivityType',
		CASE 
			WHEN ProfitabilityActual.AllocationRegionKey = -1 THEN 1
			ELSE 0 
		END AS 'HasUnknownAllocationRegion',
		CASE
			WHEN GlobalGLHierarchy.GLAccountCode LIKE '%UNKNOWN%' THEN 1
			ELSE 0
		END AS 'HasUnknownGLAccount',
		CASE
			WHEN GlobalGLHierarchy.GLMinorCategoryName LIKE '%UNKNOWN%' THEN 1
			ELSE 0
		END AS 'HasUnknownCategorizationHierarchy',
		CASE 
			WHEN ProfitabilityActual.FunctionalDepartmentKey= -1 THEN 1
			ELSE 0
		END AS 'HasUnknownFunctionalDepartment',
		CASE 
			WHEN ProfitabilityActual.OriginatingRegionKey = -1 THEN 1
			ELSE 0
		END AS 'HasUnknownOriginatingRegion',
		CASE 
			WHEN ProfitabilityActual.PropertyFundKey = -1 THEN 1
			ELSE 0
		END AS 'HasUnknownPropertyFund',	
		CASE 
			WHEN ProfitabilityActual.FunctionalDepartmentKey= -1 OR ProfitabilityActual.PropertyFundKey = -1 THEN 1
			ELSE 0
		END AS 'InValidOriginatingRegionAndFunctionalDepartment', 
		CASE 
			WHEN ProfitabilityActual.FunctionalDepartmentKey= -1 OR GlobalGLHierarchy.GLAccountCode LIKE '%UNKNOWN%' THEN 1
			ELSE 0
		END AS 'InvalidGLAccountAndFunctionalDepartment', 
		0 AS 'InValidActivityTypeAndEntity'
	FROM 
		dbo.ProfitabilityActual
		INNER JOIN dbo.Calendar ON
			ProfitabilityActual.CalendarKey = Calendar.CalendarKey
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
			ProfitabilityActual.ActivityTypeKey = -1 OR
			ProfitabilityActual.AllocationRegionKey = -1 OR
			ProfitabilityActual.FunctionalDepartmentKey = -1 OR
			GlobalGLHierarchy.GLAccountCode LIKE '%UNKNOWN%' OR
			GlobalGLHierarchy.GLMinorCategoryName LIKE '%UNKNOWN%' OR
			ProfitabilityActual.OriginatingRegionKey = -1 OR
			ProfitabilityActual.PropertyFundKey = -1
		)
		
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
		Activity Type Unknowns
	=================================================================================================================*/

	BEGIN
	
	---------------------------------------------------------------------------------------
	-- Remove activity type unknowns from #ValidationSummary that have been re-classed, 
	-- and now net out to 0. 
	
	-- We group by GLAccountCode and Entity, because as long as we balance out on unknowns for 
	-- a glaccountbalance, we are fine
	---------------------------------------------------------------------------------------
	
	UPDATE ValidationSummary 
	SET
		HasUnknownActivityType = 0
	FROM 
	-- step 3: Validation Summary Record where the account balance for that glaccount, entity and |amount| balances out to 0.0
		#ValidationSummary ValidationSummary
		INNER JOIN #GeneralLedger GeneralLedger ON
			ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
			ValidationSummary.SourceCode = GeneralLedger.SourceCode
		INNER JOIN (
			-- step 2: Get a list of unknown transaction GL Account, Entity and Amount with an account balance of 0.00 for 
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
				-- step 1: Get a distinct list of glaccountcode, entityid, |Amount|
				SELECT 
					GeneralLedger.GLAccountCode,
					GeneralLedger.EntityId, 
					CASE
						WHEN GeneralLedger.Amount < 0.0 THEN GeneralLedger.Amount * -1.0
						ELSE GeneralLedger.Amount
					END AS 'Amount'
				FROM 
					#ValidationSummary ValidationSummary
					INNER JOIN #GeneralLedger GeneralLedger ON
						ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
						ValidationSummary.SourceCode = GeneralLedger.SourceCode
				WHERE
					ValidationSummary.HasUnknownActivityType = 1
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
				ValidationSummary.HasUnknownActivityType = 1
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
		Allocation Region Unknowns
	=================================================================================================================*/

	BEGIN
	
	---------------------------------------------------------------------------------------
	-- Remove AllocationRegion Unknowns from #ValidationSummary that have been re-classed 
	-- and now net out to 0
	---------------------------------------------------------------------------------------
	
	UPDATE ValidationSummary 
	SET
		HasUnknownAllocationRegion = 0
	FROM 
	-- step 3: Validation Summary Record where the account balance for that glaccount, entity and |amount| balances out to 0.0
		#ValidationSummary ValidationSummary
		INNER JOIN #GeneralLedger GeneralLedger ON
			ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
			ValidationSummary.SourceCode = GeneralLedger.SourceCode
		INNER JOIN (
			-- step 2: Get a list of unknown transaction GL Account, Entity and Amount with an account balance of 0.00 for 
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
				-- step 1: Get a distinct list of glaccountcode, entityid, |Amount|
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
					ValidationSummary.HasUnknownAllocationRegion = 1
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
				ValidationSummary.HasUnknownOriginatingRegion = 1
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
		Originating Region Unknowns
	=================================================================================================================*/

	BEGIN
	
	---------------------------------------------------------------------------------------
	-- Remove OriginatingRegion Unknowns from #ValidationSummary that have been re-classed 
	-- and now net out to 0
	---------------------------------------------------------------------------------------
	
	UPDATE ValidationSummary 
	SET
		HasUnknownOriginatingRegion = 0
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
					ValidationSummary.HasUnknownOriginatingRegion = 1
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
				ValidationSummary.HasUnknownOriginatingRegion = 1
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
		Functional Department Unknowns
	=================================================================================================================*/
	
	BEGIN
	
	---------------------------------------------------------------------------------------
	-- Remove FunctionalDepartment Unknowns from #ValidationSummary that have been re-classed 
	-- and now net out to 0
	---------------------------------------------------------------------------------------
			
	UPDATE ValidationSummary 
	SET
		HasUnknownFunctionalDepartment = 0
	FROM 
	-- Validation Summary Record where the account balance for that glaccount, entity and |amount| balances out to 0.0
		#ValidationSummary ValidationSummary
		INNER JOIN #GeneralLedger GeneralLedger ON
			ValidationSummary.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
			ValidationSummary.SourceCode = GeneralLedger.SourceCode
		INNER JOIN (
			-- Get a list of unknown transaction GL Account, Entity and Amount with an account balance of 0.00 for 
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
				-- Get a distinct list of glaccountcode, entityid, |Amount|
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
					ValidationSummary.HasUnknownFunctionalDepartment = 1
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
				ValidationSummary.HasUnknownFunctionalDepartment = 1
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
		Property Fund Unknowns
	=================================================================================================================*/

	BEGIN
	
	---------------------------------------------------------------------------------------
	-- Remove PropertyFund Unknowns from #ValidationSummary that have been re-classed 
	-- and now net out to 0
	---------------------------------------------------------------------------------------
		
	UPDATE ValidationSummary 
	SET
		HasUnknownPropertyFund = 0
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
					ValidationSummary.HasUnknownPropertyFund = 1
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
				ValidationSummary.HasUnknownPropertyFund = 1
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
		STEP 4: VALIDATE ENTITY - ACTIVITYTYPE COMBINATION
		
		 The holistic review export temp stored procedure summarises which combinations
		 of:
		 
		 Project,
		 Activity Type,
		 PropertyFund, 
		 Allocation Sub Region,
		 Corporate Department,
		 Reporting Entity, 
		 Property Entity
		 
		 has been created in AM
		 
		 We only allow transactions for entity - activity type combinations that:
		 
		 1. Exist in AM
		 2. Has been explicitly defined by Martin, as per IMS 56718
	=================================================================================================================*/

	BEGIN
		
	IF OBJECT_ID('tempdb..#HolisticReviewExportTemp') IS NOT NULL
		DROP TABLE #HolisticReviewExportTemp

	CREATE TABLE #HolisticReviewExportTemp
	(	
		ProjectCode VARCHAR(20) NULL,
		ProjectName VARCHAR(100) NULL,
		ProjectEndPeriod INT NULL,
		ActivityType VARCHAR(50) NULL,
		PropertyFund VARCHAR(100) NULL,
		RelatedFund VARCHAR(100) NULL,
		PropertyFundAllocationSubRegionName VARCHAR(50) NULL,
		Source CHAR(2) NULL,
		AllocationType VARCHAR(100) NULL,
		CorporateDepartment CHAR(8) NULL,
		CorporateDepartmentDescription VARCHAR(50) NULL,
		ReportingEntity VARCHAR(100) NULL,
		ReportingEntityAllocationSubRegionName varchar(50) NULL,
		EntityType VARCHAR(50) NULL,
		BudgetOwner VARCHAR(255) NULL,
		RegionalOwner VARCHAR(255) NULL,
		BudgetCoordinatorDisplayNames nvarchar(MAX) NULL,
		IsTSCost VARCHAR(3) NULL,
		PropertyEntity CHAR(6) NULL,
		PropertyEntityName NVARCHAR(264) NULL
	)

	SET XACT_ABORT ON

	-- Get actuals
	INSERT INTO #HolisticReviewExportTemp
	EXEC SERVER3.GDM.dbo.HolisticReviewExport

	-- Get budget
	INSERT INTO #HolisticReviewExportTemp
	EXEC SERVER3.GDM.dbo.HolisticReviewExport @BudgetAllocationSetId=@BudgetAllocationSetId

	-- Get a distinct list of valid combinations of
	--	activity type
	--	allocation type
	--	reporting entity
	-- as projects have been set up in AM
	SELECT DISTINCT 
		ValidEntityActivityTypeCombinations.ActivityType ActivityTypeName,
		ValidEntityActivityTypeCombinations.AllocationType AllocationTypeName,
		ValidEntityActivityTypeCombinations.ReportingEntity ReportingEntityName
	INTO #ValidActivityTypeEntity
	FROM 
		#HolisticReviewExportTemp ValidEntityActivityTypeCombinations
		
	-- IMS 56718: Martin has specified additional entries that are also
	-- valid, even though they have no projects in AM
	INSERT INTO #ValidActivityTypeEntity
	SELECT 
		AdditionalMappings.ActivityTypeName, 
		AdditionalMappings.AllocationTypeName,
		AdditionalMappings.ReportingEntityName
	FROM 
		dbo.AdditionalValidCombinationsForEntityActivity AdditionalMappings
		LEFT OUTER JOIN #ValidActivityTypeEntity AMMappings ON 
			 AdditionalMappings.ReportingEntityName = AMMappings.ReportingEntityName AND
			 AdditionalMappings.ActivityTypeName = AMMappings.ActivityTypeName AND
			 AdditionalMappings.AllocationTypeName = AMMappings.AllocationTypeName
	WHERE 
		AMMappings.AllocationTypeName IS NULL

	SELECT
		[Source].SourceCode,
		ProfitabilityActual.ReferenceCode,
		ValidActivityTypeEntity.AllocationTypeName,
		REPLACE(GlobalHierarchy.GLFinancialCategoryName, '_', '') FinancialCategoryName,
		ValidActivityTypeEntity.ActivityTypeName ValidationActivityTypeName,
		ActivityType.ActivityTypeName LocalActivityTypeName,
		ValidActivityTypeEntity.ReportingEntityName,
		PropertyFund.PropertyFundName
	INTO 
		#InValidActivityTypeAndEntityCombination
	FROM
		dbo.ProfitabilityActual
		INNER JOIN Calendar ON
			ProfitabilityActual.CalendarKey = Calendar.CalendarKey  
		INNER JOIN dbo.GLCategorizationHierarchy GlobalHierarchy ON
			ProfitabilityActual.GlobalGLCategorizationHierarchyKey = GlobalHierarchy.GLCategorizationHierarchyKey
		INNER JOIN dbo.[Source] ON 
			ProfitabilityActual.SourceKey = [Source].SourceKey
		INNER JOIN dbo.Overhead ON
			ProfitabilityActual.OverheadKey = Overhead.OverheadKey
		INNER JOIN dbo.PropertyFund ON
			ProfitabilityActual.PropertyFundKey = PropertyFund.PropertyFundKey
		INNER JOIN dbo.ActivityType ON
			ProfitabilityActual.ActivityTypeKey = ActivityType.ActivityTypeKey
		LEFT OUTER JOIN #ValidActivityTypeEntity ValidActivityTypeEntity ON
			-- HANDLE CORPORATE OVERHEAD SEPARATELY
			(
				-- GR
				GlobalHierarchy.GLMajorCategoryName <> 'Salaries/Taxes/Benefits' AND
				Overhead.OverheadCode = 'UNALLOC' AND
				GlobalHierarchy.GLFinancialCategoryName = 'Overhead' AND
				
				-- AM
				ValidActivityTypeEntity.AllocationTypeName = 'NonPayroll' AND
				ValidActivityTypeEntity.ActivityTypeName = 'Corporate Overhead' AND
				ValidActivityTypeEntity.ReportingEntityName = PropertyFund.PropertyFundName
			) OR
			(
				-- GR
				GlobalHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' AND
				Overhead.OverheadCode = 'UNALLOC' AND
				GlobalHierarchy.GLFinancialCategoryName = 'Overhead' AND
				
				-- AM
				ValidActivityTypeEntity.AllocationTypeName = 'Payroll' AND
				ValidActivityTypeEntity.ActivityTypeName = 'Corporate Overhead' AND
				ValidActivityTypeEntity.ReportingEntityName = PropertyFund.PropertyFundName		
			) OR
			-- ALL OTHER TRANSACTIONS
			(
				ValidActivityTypeEntity.AllocationTypeName = REPLACE(GlobalHierarchy.GLFinancialCategoryName, '-', '') AND
				ValidActivityTypeEntity.ActivityTypeName = ActivityType.ActivityTypeName AND
				ValidActivityTypeEntity.ReportingEntityName = PropertyFund.PropertyFundName
			)
	WHERE
		Calendar.CalendarPeriod BETWEEN @StartPeriod AND @EndPeriod AND
		-- Calendar.CalendarPeriod BETWEEN 201101 AND 201103 AND
		ValidActivityTypeEntity.ActivityTypeName IS NULL AND
		NOT (
			Overhead.OverheadCode = 'ALLOC' AND
			GlobalHierarchy.GLFinancialCategoryName = 'Overhead'
		) AND
		GlobalHierarchy.GLMinorCategoryName <> 'Architects & Engineering' AND
		Calendar.CalendarPeriod >= 201007 AND
		GlobalHierarchy.InflowOutflow IN (
			'Outflow', 
			'UNKNOWN'
		) AND
		ProfitabilityActual.ReferenceCode NOT LIKE '%BillingUploadDetailId%' AND
		NOT (
			PropertyFund.PropertyFundType IN (
				'Property', 
				'3rd party property'
			) AND
			ActivityType.ActivityTypeCode IN (
				'PMN', 
				'AMA', 
				'PME', 
				'LEASE'
			)
		) --IMS #62502
		
	------------------------------------------------------------------------	
	-- Remove invalid activity type and entity combinations fixed by reclass
	------------------------------------------------------------------------
	
	DELETE InvalidCombo
	FROM 
		#InValidActivityTypeAndEntityCombination InvalidCombo
	INNER JOIN #GeneralLedger GeneralLedger ON
		InvalidCombo.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
		InvalidCombo.SourceCode = GeneralLedger.SourceCode
	INNER JOIN (
		-- Get all transactions per glaccount, entity and amount size that balance out to 0.00
		SELECT
			GeneralLedger.GlAccountCode,
			GeneralLedger.EntityId,
			InvalidAmounts.Amount
		FROM 
			#InValidActivityTypeAndEntityCombination InvalidCombo
			INNER JOIN #GeneralLedger GeneralLedger ON
				InvalidCombo.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
				InvalidCombo.SourceCode = GeneralLedger.SourceCode
			INNER JOIN (
				-- Get a distinct list of glaccountcode, entityid, |Amount|
				SELECT
					GeneralLedger.GlAccountCode,
					GeneralLedger.EntityId,
					CASE
						WHEN GeneralLedger.Amount < 0.0 THEN GeneralLedger.Amount * -1.0
						ELSE GeneralLedger.Amount
					END AS 'Amount'
				FROM 
					#InValidActivityTypeAndEntityCombination InvalidCombo
					INNER JOIN #GeneralLedger GeneralLedger ON
						InvalidCombo.ReferenceCode = GeneralLedger.SourcePrimaryKey AND
						InvalidCombo.SourceCode = GeneralLedger.SourceCode
				GROUP BY
					GeneralLedger.GlAccountCode,
					GeneralLedger.EntityId,
					CASE
						WHEN GeneralLedger.Amount < 0.0 THEN GeneralLedger.Amount * -1.0
						ELSE GeneralLedger.Amount
					END
			) InvalidAmounts ON
				GeneralLedger.GlAccountCode = InvalidAmounts.GlAccountCode AND
				GeneralLedger.EntityId = InvalidAmounts.EntityId AND
				(CASE 
					WHEN GeneralLedger.Amount < 0.0 THEN -1.0 * GeneralLedger.Amount 
					ELSE GeneralLedger.Amount 
				END) = InvalidAmounts.Amount 
		GROUP BY
			GeneralLedger.GlAccountCode,
			GeneralLedger.EntityId,
			InvalidAmounts.Amount
		HAVING
			SUM(GeneralLedger.Amount) = 0.0
	) ValidatedCombinations ON
		GeneralLedger.GlAccountCode = ValidatedCombinations.GlAccountCode AND
		GeneralLedger.EntityId = ValidatedCombinations.EntityId AND
		(CASE 
			WHEN GeneralLedger.Amount < 0.0 THEN -1.0 * GeneralLedger.Amount 
			ELSE GeneralLedger.Amount 
		END) = ValidatedCombinations.Amount 
		
	------------------------------------------------------------------------	
	-- Remove Old Reporting Entity Names
	------------------------------------------------------------------------

	DELETE FROM #InValidActivityTypeAndEntityCombination
	WHERE 
		LTRIM(RTRIM(PropertyFundName)) IN (
			SELECT 'ECM Business Development' AS 'ReportingEntity' UNION
			SELECT 'Employee Reimbursables' AS 'ReportingEntity' UNION
			SELECT 'US CORP TBD' AS 'ReportingEntity'
	)
	
	------------------------------------------------------------------------	
	-- Update #ValidationSummary with invalid combinations
	------------------------------------------------------------------------

	UPDATE ValidationSummary 
	SET
		InvalidActivityTypeAndEntity = 1	
	FROM 
		#ValidationSummary ValidationSummary
	INNER JOIN #InValidActivityTypeAndEntityCombination InvalidCombination ON
		ValidationSummary.ReferenceCode = InvalidCombination.ReferenceCode AND
		ValidationSummary.SourceCode = InvalidCombination.SourceCode
		
	------------------------------------------------------------------------	
	-- Insert records without unknowns but invalid entity/activity type combinations
	-- into validation summary
	------------------------------------------------------------------------
	
	INSERT INTO #ValidationSummary
	SELECT 
		[Source].SourceCode AS 'SourceCode',
		ProfitabilityActual.ProfitabilityActualKey AS 'ProfitabilityActualKey',
		ProfitabilityActual.ReferenceCode AS 'ReferenceCode',
		0 AS 'HasUnknownActivityType',
		0 AS 'HasUnknownAllocationRegion',
		0 AS 'HasUnknownGLAccount',
		0 AS 'HasUnknownCategorizationHierarchy',
		0 AS 'HasUnknownFunctionalDepartment',
		0 AS 'HasUnknownOriginatingRegion',
		0 AS 'HasUnknownPropertyFund',	
		0 AS 'InValidOriginatingRegionAndFunctionalDepartment',
		0 AS 'InValidGLAccountAndFunctionalDepartment',  
		1 AS 'InValidActivityTypeAndEntity'		
	FROM	
		dbo.ProfitabilityActual
		INNER JOIN dbo.[Source] ON
			ProfitabilityActual.SourceKey = [Source].SourceKey
		INNER JOIN #InValidActivityTypeAndEntityCombination InvalidCombo ON
			ProfitabilityActual.ReferenceCode = InvalidCombo.ReferenceCode AND
			[Source].SourceCode = InvalidCombo.SourceCode
		LEFT OUTER JOIN #ValidationSummary Existing ON
			[Source].SourceCode = Existing.SourceCode AND
			ProfitabilityActual.ReferenceCode = Existing.ReferenceCode
		INNER JOIN dbo.Calendar ON
			ProfitabilityActual.CalendarKey = Calendar.CalendarKey
		INNER JOIN dbo.GLCategorizationHierarchy GlobalHierarchy ON
			ProfitabilityActual.GlobalGLCategorizationHierarchyKey = GlobalHierarchy.GLCategorizationHierarchyKey
		INNER JOIN #SourceFilter ON
			Source.SourceCode = #SourceFilter.SourceCode
	WHERE
		Calendar.CalendarPeriod BETWEEN @StartPeriod AND @EndPeriod AND
		Calendar.CalendarPeriod >= 201107 AND
		Existing.ReferenceCode IS NULL AND
		GlobalHierarchy.GLMinorCategoryName <> 'Architects & Engineering'
		
	END
		
	/* ================================================================================================================
		STEP 5: Validate OriginatingRegion & FunctionalDepartment Combination		
		
		The functional department - originating region combination is only invalid if the functional department is
		restricted for ALL the corporate entities in that originating region. We therefore count the corporate entities
		mapped against the corporate department, and compare that to the count of corporate entities restricted
		for a functional department in that originating region.
	=================================================================================================================*/
	
BEGIN

	------------------------------------------------------------------------	
	-- Get the snapshotid from the budgetallocationsetId
	------------------------------------------------------------------------	

	DECLARE @SnapshotId INT = (
		SELECT
			SnapshotId
		FROM GrReportingStaging.gdm.Snapshot
		WHERE 
			GroupKey = @BudgetAllocationSetId
		)
			
	------------------------------------------------------------------------	
	-- Update all profitability actual transactions in the validation summary 
	-- where the functional department - originating region
	-- combination is invalid
	------------------------------------------------------------------------	
	UPDATE ValidationSummary
		SET
			InValidOriginatingRegionAndFunctionalDepartment = 1
	FROM #ValidationSummary ValidationSummary
		INNER JOIN dbo.ProfitabilityActual ON
			ValidationSummary.ProfitabilityActualKey = ProfitabilityActual.ProfitabilityActualKey
		INNER JOIN dbo.FunctionalDepartment ON	
			ProfitabilityActual.FunctionalDepartmentKey = FunctionalDepartment.FunctionalDepartmentKey
		INNER JOIN dbo.OriginatingRegion ON
			ProfitabilityActual.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey
		LEFT OUTER JOIN (
			-- get a list of functional for which all the corporate entities is restricted in a global region
			-- the global region - functional department combination is then restricted
			SELECT
				FunctionalDepartmentGlobalRegionCount.FunctionalDepartmentCode AS 'FunctionalDepartmentCode',
				GlobalRegion.Code AS 'GlobalRegionCode'
			FROM (
				-- Get a count of corporate entities restricted for each functional department per originating region
				SELECT
					FunctionalDepartment.GlobalCode AS 'FunctionalDepartmentCode',
					OriginatingRegionCorporateEntity.GlobalRegionId,
					COUNT(
						RestrictedCombinations.CorporateEntitySourceCode + 
						RestrictedCombinations.CorporateEntityCode
					) AS 'CorporateEntityRestrictionsCount'
				FROM 
					GrReportingStaging.Gdm.SnapshotRestrictedFunctionalDepartmentCorporateEntity RestrictedCombinations
				INNER JOIN GrReportingStaging.HR.FunctionalDepartment FunctionalDepartment ON
					RestrictedCombinations.FunctionalDepartmentId = FunctionalDepartment.FunctionalDepartmentId
				INNER JOIN GrReportingStaging.GDM.SnapshotOriginatingRegionCorporateEntity OriginatingRegionCorporateEntity ON
					RestrictedCombinations.CorporateEntityCode = OriginatingRegionCorporateEntity.CorporateEntityCode AND
					RestrictedCombinations.CorporateEntitySourceCode = OriginatingRegionCorporateEntity.SourceCode
				WHERE 
					FunctionalDepartment.IsActive = 1 AND
					RestrictedCombinations.SnapshotId = @SnapshotId AND
					OriginatingRegionCorporateEntity.SnapshotId = @SnapshotId
				GROUP BY 
					FunctionalDepartment.GlobalCode,
					GlobalRegionId
			) FunctionalDepartmentGlobalRegionCount
			INNER JOIN (
				-- Get a count of corporate entities per originating region
				SELECT
					GlobalRegionId,
					COUNT(OriginatingRegionCorporateEntity.SourceCode + CorporateEntityCode) AS CorporateEntitiesPerRegion
				FROM 
					GrReportingStaging.GDM.SnapshotOriginatingRegionCorporateEntity OriginatingRegionCorporateEntity
				WHERE
					OriginatingRegionCorporateEntity.SnapshotId = @SnapshotId
				GROUP BY
					GlobalRegionId
			) GlobalRegionCorporateEntityCount ON
				FunctionalDepartmentGlobalRegionCount.GlobalRegionId = GlobalRegionCorporateEntityCount.GlobalRegionId
			INNER JOIN GrReportingStaging.Gdm.GlobalRegion GlobalRegion ON
				FunctionalDepartmentGlobalRegionCount.GlobalRegionId = GlobalRegion.GlobalRegionId
			WHERE
				FunctionalDepartmentGlobalRegionCount.CorporateEntityRestrictionsCount = GlobalRegionCorporateEntityCount.CorporateEntitiesPerRegion
		) InvalidFunctionalDepartmentOriginatingRegion ON
			FunctionalDepartment.FunctionalDepartmentCode = InvalidFunctionalDepartmentOriginatingRegion.FunctionalDepartmentCode AND
			OriginatingRegion.SubRegionCode = InvalidFunctionalDepartmentOriginatingRegion.GlobalRegionCode
		LEFT OUTER JOIN dbo.AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment ON
			OriginatingRegion.SubRegionName = AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment.OriginatingSubRegionName AND
			FunctionalDepartment.FunctionalDepartmentName = AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment.FunctionalDepartmentName
	WHERE
		InvalidFunctionalDepartmentOriginatingRegion.FunctionalDepartmentCode IS NOT NULL AND
		InvalidFunctionalDepartmentOriginatingRegion.GlobalRegionCode IS NOT NULL AND
		AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment.FunctionalDepartmentName IS NULL AND
		AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment.OriginatingSubRegionName IS NULL

	------------------------------------------------------------------------	
	-- add all profitability actual transactions TO validation summary where 
	-- the functional department - originating region
	-- combination is invalid and they are not in the validation summary yet
	------------------------------------------------------------------------	
	
	INSERT INTO #ValidationSummary
	SELECT
		[Source].SourceCode AS 'SourceCode',
		ProfitabilityActual.ProfitabilityActualKey AS 'ProfitabilityActualKey',
		ProfitabilityActual.ReferenceCode AS 'ReferenceCode',
		0 AS 'HasUnknownActivityType',
		0 AS 'HasUnknownAllocationRegion',
		0 AS 'HasUnknownGLAccount',
		0 AS 'HasUnknownCategorizationHierarchy',
		0 AS 'HasUnknownFunctionalDepartment',
		0 AS 'HasUnknownOriginatingRegion',
		0 AS 'HasUnknownPropertyFund',	
		1 AS 'InValidOriginatingRegionAndFunctionalDepartment',
		0 AS 'InValidGLAccountAndFunctionalDepartment',  
		0 AS 'InValidActivityTypeAndEntity'		
	FROM	
		dbo.ProfitabilityActual
		INNER JOIN dbo.[Source] ON
			ProfitabilityActual.SourceKey = [Source].SourceKey
		LEFT OUTER JOIN #ValidationSummary Existing ON
			[Source].SourceCode = Existing.SourceCode AND
			ProfitabilityActual.ReferenceCode = Existing.ReferenceCode
		INNER JOIN dbo.Calendar ON
			ProfitabilityActual.CalendarKey = Calendar.CalendarKey
		INNER JOIN dbo.GLCategorizationHierarchy GlobalHierarchy ON
			ProfitabilityActual.GlobalGLCategorizationHierarchyKey = GlobalHierarchy.GLCategorizationHierarchyKey
		INNER JOIN dbo.FunctionalDepartment ON	
			ProfitabilityActual.FunctionalDepartmentKey = FunctionalDepartment.FunctionalDepartmentKey
		INNER JOIN dbo.OriginatingRegion ON
			ProfitabilityActual.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey
		LEFT OUTER JOIN (
			-- get a list of functional for which all the corporate entities is restricted in a global region
			-- the global region - functional department combination is then restricted
			SELECT
				FunctionalDepartmentGlobalRegionCount.FunctionalDepartmentCode AS 'FunctionalDepartmentCode',
				GlobalRegion.Code AS 'GlobalRegionCode'
			FROM (
				-- Get a count of corporate entities restricted for each functional department per originating region
				SELECT
					FunctionalDepartment.GlobalCode AS 'FunctionalDepartmentCode',
					OriginatingRegionCorporateEntity.GlobalRegionId,
					COUNT(
						RestrictedCombinations.CorporateEntitySourceCode + 
						RestrictedCombinations.CorporateEntityCode
					) AS 'CorporateEntityRestrictionsCount'
				FROM 
					GrReportingStaging.Gdm.SnapshotRestrictedFunctionalDepartmentCorporateEntity RestrictedCombinations
				INNER JOIN GrReportingStaging.HR.FunctionalDepartment FunctionalDepartment ON
					RestrictedCombinations.FunctionalDepartmentId = FunctionalDepartment.FunctionalDepartmentId
				INNER JOIN GrReportingStaging.GDM.SnapshotOriginatingRegionCorporateEntity OriginatingRegionCorporateEntity ON
					RestrictedCombinations.CorporateEntityCode = OriginatingRegionCorporateEntity.CorporateEntityCode AND
					RestrictedCombinations.CorporateEntitySourceCode = OriginatingRegionCorporateEntity.SourceCode
				WHERE 
					FunctionalDepartment.IsActive = 1 AND
					RestrictedCombinations.SnapshotId = @SnapshotId AND
					OriginatingRegionCorporateEntity.SnapshotId = @SnapshotId
				GROUP BY 
					FunctionalDepartment.GlobalCode,
					GlobalRegionId
			) FunctionalDepartmentGlobalRegionCount
			INNER JOIN (
				-- Get a count of corporate entities per originating region
				SELECT
					GlobalRegionId,
					COUNT(OriginatingRegionCorporateEntity.SourceCode + CorporateEntityCode) AS CorporateEntitiesPerRegion
				FROM 
					GrReportingStaging.GDM.SnapshotOriginatingRegionCorporateEntity OriginatingRegionCorporateEntity
				WHERE
					OriginatingRegionCorporateEntity.SnapshotId = @SnapshotId
				GROUP BY
					GlobalRegionId
			) GlobalRegionCorporateEntityCount ON
				FunctionalDepartmentGlobalRegionCount.GlobalRegionId = GlobalRegionCorporateEntityCount.GlobalRegionId
			INNER JOIN GrReportingStaging.Gdm.GlobalRegion GlobalRegion ON
				FunctionalDepartmentGlobalRegionCount.GlobalRegionId = GlobalRegion.GlobalRegionId
			WHERE
				FunctionalDepartmentGlobalRegionCount.CorporateEntityRestrictionsCount = GlobalRegionCorporateEntityCount.CorporateEntitiesPerRegion
		) InvalidFunctionalDepartmentOriginatingRegion ON
		FunctionalDepartment.FunctionalDepartmentCode = InvalidFunctionalDepartmentOriginatingRegion.FunctionalDepartmentCode AND
		OriginatingRegion.SubRegionCode = InvalidFunctionalDepartmentOriginatingRegion.GlobalRegionCode
		LEFT OUTER JOIN dbo.AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment ON
			OriginatingRegion.SubRegionName = AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment.OriginatingSubRegionName AND
			FunctionalDepartment.FunctionalDepartmentName = AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment.FunctionalDepartmentName
	WHERE
		Calendar.CalendarPeriod BETWEEN @StartPeriod AND @EndPeriod AND
		Existing.ReferenceCode IS NULL AND
		GlobalHierarchy.GLMinorCategoryName <> 'Architects & Engineering' AND
		InvalidFunctionalDepartmentOriginatingRegion.FunctionalDepartmentCode IS NOT NULL AND
		InvalidFunctionalDepartmentOriginatingRegion.GlobalRegionCode IS NOT NULL AND
		AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment.FunctionalDepartmentName IS NULL AND
		AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment.OriginatingSubRegionName IS NULL
		
	END

	
	/* ================================================================================================================
		STEP 6: Validate FunctionalDepartment & GL Global Account Combination	
		
		The RestrictedFunctionalDepartmentGLGlobalAccount table in GDM handles two scenario's:
		
		1. The FunctionalDepartmentId is null - the GLGlobalAccount is restricted for all functional departments	
	=================================================================================================================*/
	
	BEGIN
	
	UPDATE ValidationSummary
		SET 
			InvalidGLAccountAndFunctionalDepartment = 1
	FROM #ValidationSummary ValidationSummary
		INNER JOIN dbo.ProfitabilityActual ON
			ValidationSummary.ProfitabilityActualKey = ProfitabilityActual.ProfitabilityActualKey
		INNER JOIN dbo.FunctionalDepartment ON	
			ProfitabilityActual.FunctionalDepartmentKey = FunctionalDepartment.FunctionalDepartmentKey
		INNER JOIN dbo.GLCategorizationHierarchy GlobalHierarchy ON
			ProfitabilityActual.GlobalGLCategorizationHierarchyKey = GlobalHierarchy.GLCategorizationHierarchyKey
		INNER JOIN (
			SELECT 
				GLGlobalAccount.Code AS 'GLGlobalAccountCode',
				FunctionalDepartment.GlobalCode AS 'FunctionalDepartmentGlobalCode'
			FROM GrReportingStaging.GDM.RestrictedFunctionalDepartmentGLGlobalAccount
			INNER JOIN GrReportingStaging.GDM.RestrictedFunctionalDepartmentGLGlobalAccountActive(@DataPriorToDate) ActiveRestrictedFunctionalDepartmentGlGlobalAccount ON
				RestrictedFunctionalDepartmentGLGlobalAccount.ImportKey = ActiveRestrictedFunctionalDepartmentGlGlobalAccount.ImportKey
			LEFT OUTER JOIN GrReportingStaging.HR.FunctionalDepartment FunctionalDepartment ON
				RestrictedFunctionalDepartmentGLGlobalAccount.FunctionalDepartmentId = FunctionalDepartment.FunctionalDepartmentId
			LEFT OUTER JOIN GrReportingStaging.HR.FunctionalDepartmentActive(@DataPriorToDate) FunctionalDepartmentActive ON
				FunctionalDepartment.ImportKey = FunctionalDepartmentActive.ImportKey
			INNER JOIN GrReportingStaging.GDM.GLGlobalAccount ON
				RestrictedFunctionalDepartmentGLGlobalAccount.GLGlobalAccountId = GLGlobalAccount.GLGlobalAccountId
			INNER JOIN GrReportingStaging.GDM.GLGlobalAccountActive(@DataPriorToDate) GLGlobalAccountActive ON
				GLGlobalAccount.ImportKey = GLGlobalAccountActive.ImportKey
		) InvalidCombinations ON
			GlobalHierarchy.GLAccountCode = InvalidCombinations.GLGlobalAccountCode AND 
			FunctionalDepartment.FunctionalDepartmentCode =
			CASE
				WHEN InvalidCombinations.FunctionalDepartmentGlobalCode IS NULL THEN FunctionalDepartment.FunctionalDepartmentCode 
				ELSE InvalidCombinations.FunctionalDepartmentGlobalCode
			END
			
			INSERT INTO #ValidationSummary
			SELECT
				[Source].SourceCode AS 'SourceCode',
				ProfitabilityActual.ProfitabilityActualKey AS 'ProfitabilityActualKey',
				ProfitabilityActual.ReferenceCode AS 'ReferenceCode',
				0 AS 'HasUnknownActivityType',
				0 AS 'HasUnknownAllocationRegion',
				0 AS 'HasUnknownGLAccount',
				0 AS 'HasUnknownCategorizationHierarchy',
				0 AS 'HasUnknownFunctionalDepartment',
				0 AS 'HasUnknownOriginatingRegion',
				0 AS 'HasUnknownPropertyFund',	
				0 AS 'InValidOriginatingRegionAndFunctionalDepartment',
				1 AS 'InValidGLAccountAndFunctionalDepartment',  
				0 AS 'InValidActivityTypeAndEntity'		
			FROM ProfitabilityActual
			INNER JOIN [Source] ON
				ProfitabilityActual.SourceKey = [Source].SourceKey
			INNER JOIN FunctionalDepartment ON	
				ProfitabilityActual.FunctionalDepartmentKey = FunctionalDepartment.FunctionalDepartmentKey
			INNER JOIN GLCategorizationHierarchy GlobalHierarchy ON
				ProfitabilityActual.GlobalGLCategorizationHierarchyKey = GlobalHierarchy.GLCategorizationHierarchyKey
			LEFT OUTER JOIN #ValidationSummary Existing ON
				[Source].SourceCode = Existing.SourceCode AND
				ProfitabilityActual.ReferenceCode = Existing.ReferenceCode
			INNER JOIN Calendar ON
				ProfitabilityActual.CalendarKey = Calendar.CalendarKey
			INNER JOIN (
				SELECT 
					GLGlobalAccount.Code AS 'GLGlobalAccountCode',
					FunctionalDepartment.GlobalCode AS 'FunctionalDepartmentGlobalCode'
				FROM GrReportingStaging.GDM.RestrictedFunctionalDepartmentGLGlobalAccount
				INNER JOIN GrReportingStaging.GDM.RestrictedFunctionalDepartmentGLGlobalAccountActive(@DataPriorToDate) ActiveRestrictedFunctionalDepartmentGlGlobalAccount ON
					RestrictedFunctionalDepartmentGLGlobalAccount.ImportKey = ActiveRestrictedFunctionalDepartmentGlGlobalAccount.ImportKey
				LEFT OUTER JOIN GrReportingStaging.HR.FunctionalDepartment FunctionalDepartment ON
					RestrictedFunctionalDepartmentGLGlobalAccount.FunctionalDepartmentId = FunctionalDepartment.FunctionalDepartmentId
				LEFT OUTER JOIN GrReportingStaging.HR.FunctionalDepartmentActive(@DataPriorToDate) FunctionalDepartmentActive ON
					FunctionalDepartment.ImportKey = FunctionalDepartmentActive.ImportKey
				INNER JOIN GrReportingStaging.GDM.GLGlobalAccount ON
					RestrictedFunctionalDepartmentGLGlobalAccount.GLGlobalAccountId = GLGlobalAccount.GLGlobalAccountId
				INNER JOIN GrReportingStaging.GDM.GLGlobalAccountActive(@DataPriorToDate) GLGlobalAccountActive ON
					GLGlobalAccount.ImportKey = GLGlobalAccountActive.ImportKey
			) InvalidCombinations ON
				GlobalHierarchy.GLAccountCode = InvalidCombinations.GLGlobalAccountCode AND 
				FunctionalDepartment.FunctionalDepartmentCode =
				CASE
					WHEN InvalidCombinations.FunctionalDepartmentGlobalCode IS NULL THEN FunctionalDepartment.FunctionalDepartmentCode 
					ELSE InvalidCombinations.FunctionalDepartmentGlobalCode
				END	
		WHERE
			Calendar.CalendarPeriod BETWEEN @StartPeriod AND @EndPeriod AND
			Existing.ReferenceCode IS NULL AND
			GlobalHierarchy.GLMinorCategoryName <> 'Architects & Engineering'
	
	END	
	
	/* ================================================================================================================
		STEP 6.5: REMOVE ALL INFLOW Transactions
		
		Global 'Inflow' accounts have a local gl account code starting with 4xxxxx
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
		STEP 7: Clean Up Data														
	=================================================================================================================*/
	
	BEGIN
	
	DELETE 
		FROM 
			#ValidationSummary
	WHERE
		#ValidationSummary.HasUnknownActivityType = 0 AND
		#ValidationSummary.HasUnknownAllocationRegion = 0 AND
		#ValidationSummary.HasUnknownGLAccount = 0 AND
		#ValidationSummary.HasUnknownCategorizationHierarchy = 0 AND
		#ValidationSummary.HasUnknownFunctionalDepartment = 0 AND
		#ValidationSummary.HasUnknownOriginatingRegion = 0 AND
		#ValidationSummary.HasUnknownPropertyFund = 0 AND
		#ValidationSummary.InvalidOriginatingRegionAndFunctionalDepartment = 0 AND
		#ValidationSummary.InvalidActivityTypeAndEntity = 0
	
	END	
	
	/* ================================================================================================================
		STEP 8: Get Property Header GL Account Sum
		
		Gets a summary of the total of each header account with activity specific child gl accounts under it
	=================================================================================================================*/

	BEGIN
	
	SELECT 
		LEDGER.SourceCode, 
		LEDGER.EntityID, 
		LEDGER.GlAccountCode, 
		SUM(LEDGER.Amount) Amount
	INTO #PropertyHeaderSum
	FROM 
		GrReportingStaging.USPROP.GeneralLedger LEDGER 
		LEFT OUTER JOIN (
			SELECT 
				GACC.ACCTNUM, 
				GACC.ISGR
			FROM GrReportingStaging.USPROP.GACC
			INNER JOIN GrReportingStaging.USPROP.GAccActive(@DataPriorToDate) GaA ON 
				GaA.ImportKey = GACC.ImportKey
		) GACC ON 
			LEDGER.GlAccountCode = GACC.ACCTNUM
	WHERE 
		LEDGER.Period BETWEEN @StartPeriod AND @EndPeriod AND 
		LEDGER.Basis IN ('A','B') AND 
		GACC.ISGR = 'Y' AND 
		EXISTS(
			SELECT 
				NULL 
			FROM GrReportingStaging.USPROP.GACC G
			WHERE 
				G.ISGR = 'Y' AND 
				LEFT(G.ACCTNUM, 10) = LEFT(GACC.ACCTNUM, 10) AND 
				G.ACCTNUM <> GACC.ACCTNUM
		) AND 
		RIGHT(RTRIM(GACC.ACCTNUM), 2) = '00'
	GROUP BY
		LEDGER.SourceCode, 
		LEDGER.EntityID, 
		LEDGER.GlAccountCode
		
	UNION ALL
	 
	SELECT 
		LEDGER.SourceCode, 
		LEDGER.EntityID, 
		LEDGER.GlAccountCode, 
		SUM(LEDGER.Amount)
	FROM 
		GrReportingStaging.EUPROP.GeneralLedger LEDGER 
		LEFT OUTER JOIN (
			SELECT 
				GACC.ACCTNUM, 
				GACC.ISGR
			FROM GrReportingStaging.EUPROP.GACC
			INNER JOIN GrReportingStaging.EUPROP.GAccActive(@DataPriorToDate) GaA ON 
				GaA.ImportKey = GACC.ImportKey
		) GACC ON 
			LEDGER.GlAccountCode = GACC.ACCTNUM
	WHERE 
		LEDGER.Period BETWEEN @StartPeriod AND @EndPeriod AND 
		LEDGER.Basis IN ('A','B') AND 
		GACC.ISGR = 'Y' AND 
		EXISTS(
			SELECT 
				NULL 
			FROM GrReportingStaging.EUPROP.GACC G
			WHERE 
				G.ISGR = 'Y' AND 
				LEFT(G.ACCTNUM, 10) = LEFT(GACC.ACCTNUM, 10) AND 
				G.ACCTNUM <> GACC.ACCTNUM
		)
		AND RIGHT(RTRIM(GACC.ACCTNUM), 2) = '00'
	GROUP BY
		LEDGER.SourceCode, 
		LEDGER.EntityID, 
		LEDGER.GlAccountCode
		
	UNION ALL 

	SELECT 
		LEDGER.SourceCode, 
		LEDGER.EntityID, 
		LEDGER.GlAccountCode, 
		SUM(LEDGER.Amount)
	FROM 
		GrReportingStaging.CNPROP.GeneralLedger LEDGER 
		LEFT OUTER JOIN (
			SELECT 
				GACC.ACCTNUM, 
				GACC.ISGR
			FROM GrReportingStaging.CNCorp.GACC
			INNER JOIN GrReportingStaging.CNPROP.GAccActive(@DataPriorToDate) GaA ON 
				GaA.ImportKey = GACC.ImportKey
		) GACC ON 
			LEDGER.GlAccountCode = GACC.ACCTNUM
	WHERE 
		LEDGER.Period BETWEEN @StartPeriod AND @EndPeriod AND 
		LEDGER.Basis IN ('A','B') AND
		GACC.ISGR = 'Y' AND 
		EXISTS(
			SELECT 
				NULL 
			FROM GrReportingStaging.CNPROP.GACC G
			WHERE 
				G.ISGR = 'Y' AND 
				LEFT(G.ACCTNUM, 10) = LEFT(GACC.ACCTNUM, 10) AND 
				G.ACCTNUM <> GACC.ACCTNUM
		)AND 
		RIGHT(RTRIM(GACC.ACCTNUM), 2) = '00'
	GROUP BY
		LEDGER.SourceCode, 
		LEDGER.EntityID, 
		LEDGER.GlAccountCode
		
	UNION ALL 

	SELECT 
		LEDGER.SourceCode, 
		LEDGER.EntityID, 
		LEDGER.GlAccountCode, 
		SUM(LEDGER.Amount) 
	FROM 
		GrReportingStaging.INPROP.GeneralLedger LEDGER 
		LEFT OUTER JOIN (
			SELECT 
				GACC.ACCTNUM, 
				GACC.ISGR
			FROM GrReportingStaging.INPROP.GACC
			INNER JOIN GrReportingStaging.INPROP.GAccActive(@DataPriorToDate) GaA ON 
				GaA.ImportKey = GACC.ImportKey
		) GACC ON 
			LEDGER.GlAccountCode = GACC.ACCTNUM
	WHERE 
		LEDGER.Period BETWEEN @StartPeriod AND @EndPeriod AND 
		LEDGER.Basis IN ('A','B') AND 
		GACC.ISGR = 'Y' AND 
		EXISTS(
			SELECT 
				NULL 
			FROM GrReportingStaging.INPROP.GACC G
			WHERE 
				G.ISGR = 'Y' AND 
				LEFT(G.ACCTNUM, 10) = LEFT(GACC.ACCTNUM, 10) AND 
				G.ACCTNUM <> GACC.ACCTNUM
		) AND 
		RIGHT(RTRIM(GACC.ACCTNUM), 2) = '00'
	GROUP BY
		LEDGER.SourceCode, 
		LEDGER.EntityID, 
		LEDGER.GlAccountCode
		
	UNION ALL 

	SELECT 
		LEDGER.SourceCode, 
		LEDGER.EntityID, 
		LEDGER.GlAccountCode, 
		SUM(LEDGER.Amount) 
	FROM 
		GrReportingStaging.BRPROP.GeneralLedger LEDGER 
		LEFT OUTER JOIN (
			SELECT 
				GACC.ACCTNUM, 
				GACC.ISGR
			FROM GrReportingStaging.BRPROP.GACC
			INNER JOIN GrReportingStaging.BRPROP.GAccActive(@DataPriorToDate) GaA ON 
				GaA.ImportKey = GACC.ImportKey
		) GACC ON 
			LEDGER.GlAccountCode = GACC.ACCTNUM
	WHERE 
		LEDGER.Period BETWEEN @StartPeriod AND @EndPeriod AND 
		LEDGER.Basis IN ('A','B') AND 
		GACC.ISGR = 'Y' AND 
		EXISTS(
			SELECT 
				NULL 
			FROM GrReportingStaging.BRPROP.GACC G
			WHERE 
				G.ISGR = 'Y' AND 
				LEFT(G.ACCTNUM, 10) = LEFT(GACC.ACCTNUM, 10) AND 
				G.ACCTNUM <> GACC.ACCTNUM
		) AND 
		RIGHT(RTRIM(GACC.ACCTNUM), 2) = '00'
	GROUP BY
		LEDGER.SourceCode, 
		LEDGER.EntityID, 
		LEDGER.GlAccountCode
		
	END	

	/* ================================================================================================================
		STEP 9: Get Corporate Header GL Account Sum
		
		Gets a sum of all transactions against each corporate gl account (job code specific)
	=================================================================================================================*/

	BEGIN
		
	SELECT
		gl.SourceCode,
		gl.EntityID,
		gl.Source,
		ISNULL(gl.JobCode,'') JobCode,
		ISNULL(gl.Description,'') Description,
		SUM(gl.Amount) AS Amount
	INTO
		#CorporateDescSum
	FROM					
		#GeneralLedger gl	
	WHERE
		RIGHT(gl.SourceCode, 1) = 'C'
	GROUP BY
		gl.SourceCode,
		gl.EntityID,
		gl.Source,
		gl.JobCode,
		gl.Description
		
	END
			
	/* ================================================================================================================
		STEP 11: GET FINAL RESULTS
		Handle ALL Logic													
	=================================================================================================================*/
	
	BEGIN

	SELECT
		CASE 
			WHEN 
				ValidationSummary.HasUnknownActivityType = 1 OR 
				ValidationSummary.HasUnknownFunctionalDepartment = 1 OR
				ValidationSummary.HasUnknownOriginatingRegion = 1 OR
				ValidationSummary.InValidOriginatingRegionAndFunctionalDepartment = 1 OR
				ValidationSummary.InValidActivityTypeAndEntity = 1 OR
				InvalidGLAccountAndFunctionalDepartment = 1
			THEN 
				CASE WHEN
					ValidationSummary.HasUnknownPropertyFund = 1 OR
					ValidationSummary.HasUnknownAllocationRegion = 1 OR
					ValidationSummary.HasUnknownGlAccount = 1 OR
					ValidationSummary.HasUnknownCategorizationHierarchy = 1
				THEN 
					'Both Corporate Finance and Accounting'
				ELSE
					'Accounting - Re-class'
				END
			ELSE 
				'Corporate Finance - Mapping'
		END AS 'ResolvedBy',
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
		CASE 
			WHEN ValidationSummary.HasUnknownActivityType = 1 THEN 'YES' 
			ELSE 'NO' 
		END AS 'HasActivityTypeUnknown',
		CASE 
			WHEN ValidationSummary.HasUnknownFunctionalDepartment = 1 THEN 'YES' 
			ELSE 'NO' 
		END AS 'HasFunctionalDepartmentUnknown',
		CASE 
			WHEN ValidationSummary.HasUnknownOriginatingRegion = 1 THEN 'YES' 
			ELSE 'NO' 
		END AS 'HasOriginatingRegionUnknown',
		CASE 
			WHEN ValidationSummary.HasUnknownPropertyFund = 1 THEN 'YES' 
			ELSE 'NO' 
		END AS 'HasReportingEntityUnknown',
		CASE 
			WHEN ValidationSummary.HasUnknownAllocationRegion = 1 THEN 'YES' 
			ELSE 'NO' 
		END AS 'HasAllocationRegionUnknown',
		CASE 
			WHEN ValidationSummary.HasUnknownGlAccount = 1 THEN 'YES' 
			ELSE 'NO' 
		END AS 'HasGlAccountUnknown',
		CASE 
			WHEN ValidationSummary.InValidOriginatingRegionAndFunctionalDepartment = 1 THEN 'YES' 
			ELSE 'NO' 
		END AS 'InValidOriginatingRegionAndFunctionalDepartment',
		CASE 
			WHEN ValidationSummary.InValidActivityTypeAndEntity = 1 THEN 'YES' 
			ELSE 'NO' 
		END AS 'InValidActivityTypeAndEntity',
		CASE 
			WHEN ValidationSummary.InvalidGLAccountAndFunctionalDepartment = 1 THEN 'YES' 
			ELSE 'NO' 
		END AS 'InvalidGLAccountAndFunctionalDepartment',
		ISNULL(PropertyHeaderSum.Amount, '') AS 'PropertyParentAccountTotal',
		ISNULL(CorporateDescriptionSum.Amount, '') AS 'CorporateTotalByDescription',
		'Global' AS 'GrCategorization',
		GlobalHierarchy.GLFinancialCategoryName AS 'GrFinancialCategoryName',
		GlobalHierarchy.GLMajorCategoryName AS 'GrMajorCategoryName',
		GlobalHierarchy.GLMinorCategoryName AS 'GrMinorCategoryName',
		GlobalHierarchy.InflowOutflow AS 'InflowOutFlow',
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
		LEFT OUTER JOIN #PropertyHeaderSum PropertyHeaderSum ON 
			GeneralLedger.SourceCode = PropertyHeaderSum.SourceCode AND
			GeneralLedger.EntityId = PropertyHeaderSum.EntityID AND 
			GeneralLedger.GlAccountCode = PropertyHeaderSum.GlAccountCode
		LEFT OUTER JOIN #CorporateDescSum CorporateDescriptionSum ON 
			GeneralLedger.SourceCode = CorporateDescriptionSum.SourceCode AND
			GeneralLedger.EntityID = CorporateDescriptionSum.EntityID AND
			GeneralLedger.Source = CorporateDescriptionSum.Source AND
			ISNULL(GeneralLedger.JobCode,'') = CorporateDescriptionSum.JobCode AND
			ISNULL(GeneralLedger.Description,'') = CorporateDescriptionSum.Description		

	END
	
	--------------------------------------------------------------------------
	/*	Clean up temp tables												*/
	--------------------------------------------------------------------------

	BEGIN
	
	IF OBJECT_ID('tempdb..#ValidationSummary') IS NOT NULL
		DROP TABLE #ValidationSummary
		
	IF OBJECT_ID('tempdb..#GeneralLedger') IS NOT NULL
		DROP TABLE #GeneralLedger
	
	IF OBJECT_ID('tempdb..#HolisticReviewExport') IS NOT NULL
		DROP TABLE #HolisticReviewExport

	IF OBJECT_ID('tempdb..#ValidActivityTypeEntity') IS NOT NULL
		DROP TABLE #ValidActivityTypeEntity
	
	IF OBJECT_ID('tempdb..#HolisticReviewExportTemp') IS NOT NULL
		DROP TABLE #HolisticReviewExportTemp
	
	IF OBJECT_ID('tempdb..#InValidActivityTypeAndEntityCombination') IS NOT NULL
		DROP TABLE #InValidActivityTypeAndEntityCombination
	
	IF OBJECT_ID('tempdb..#IsGBSGlobalAccounts') IS NOT NULL
		DROP TABLE #IsGBSGlobalAccounts
		
	IF OBJECT_ID('tempdb..#ValidRegionAndFunctionalDepartment') IS NOT NULL
		DROP TABLE #ValidRegionAndFunctionalDepartment
		
	IF OBJECT_ID('tempdb..#PropertyHeaderSum') IS NOT NULL
		DROP TABLE #PropertyHeaderSum

	IF OBJECT_ID('tempdb..#CorporateDescSum') IS NOT NULL
		DROP TABLE #CorporateDescSum


	END





















GO


